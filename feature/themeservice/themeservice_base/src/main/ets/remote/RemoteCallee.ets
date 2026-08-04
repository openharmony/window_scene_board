/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { abilityAccessCtrl, bundleManager, Permissions } from '@kit.AbilityKit';
import { LightWeightMap } from '@kit.ArkTS';
import { BusinessError, systemParameterEnhance } from '@kit.BasicServicesKit';
import rpc from '@ohos.rpc';
import { TsLog } from '../log/TsLog';
import { JsonUtils } from '../utils/JsonUtils';
import { AnyType } from '../utils/Types';
import { RemoteCode } from './RemoteCode';
import { RemoteInterceptor } from './RemoteInterceptor';
import { RemoteReq } from './RemoteReq';
import { RemoteRsp } from './RemoteRsp';
import { RpcCodec } from './RpcCodec';
import { trustCallerInterceptor } from './TrustCallerInterceptor';
import { postSerialExecutionInterceptor, preSerialExecutionInterceptor } from './SerialExecutionInterceptor';
import { CloudUtils } from '../utils/CloudUtils';

const TAG: string = 'RemoteStub';
const TIMEOUT: number = 30000;

/**
 * 远程存根，对端建立连接后，创建该对象后传递给对端
 */
class RemoteStub extends rpc.RemoteObject {
  private readonly methodSet: CalleeMethodSet = new CalleeMethodSet();
  private readonly callee: RemoteCallee;

  private readonly preInterceptors: RemoteInterceptor[] = [];

  private readonly postInterceptors: RemoteInterceptor[] = [];

  constructor(descriptor: string, callee: RemoteCallee) {
    super(descriptor);
    this.callee = callee;
    callee.onRegister(this.methodSet);
    this.preInterceptors.push(trustCallerInterceptor(this.methodSet), preSerialExecutionInterceptor(this.methodSet));
    this.postInterceptors.push(postSerialExecutionInterceptor(this.methodSet));

    callee.onAddPreInterceptor(this.preInterceptors);
    callee.onAddPostInterceptor(this.postInterceptors);
  }

  /**
   * 接收并处理远程消息请求
   */
  async onRemoteMessageRequest(code: number, data: rpc.MessageSequence, reply: rpc.MessageSequence,
    _options: rpc.MessageOption): Promise<boolean> {
    try {
      // code：对端发送的服务请求码，作为TS内部跨端接口版本号使用
      const version: number = code;
      TsLog.info(TAG, `remote version = ${version}`);
      // 校验调用真合法性 (云端模式下拦截所有请求接口)
      if (CloudUtils.isInCloudMode() || !this.verifyAccessToken()) {
        TsLog.warning(TAG, `${this.getDescriptor()} cloud or illegal caller method`);
        reply = RpcCodec.toRpc(version, RemoteRsp.ERR_ILLEGAL_CALLER, reply);
      } else {
        const rsp: RemoteRsp = await this.request(version, data);
        reply = RpcCodec.toRpc(version, rsp, reply);
      }
      await this.callerAuth();
    } catch (err) {
      TsLog.error(TAG, `onRemoteMessageRequest code:${code}, catch exception.`, err);
    }
    return true;
  }

  private async intercept(interceptors: RemoteInterceptor[], timestamp: number, req: RemoteReq,
    rsp: RemoteRsp): Promise<boolean> {
    if ((interceptors?.length ?? 0) <= 0) {
      return false;
    }
    for (const interceptor of interceptors) {
      try {
        const result: boolean = await interceptor.intercept(timestamp, req, rsp);
        if (result) {
          return true;
        }
      } catch (err) {
        TsLog.error(TAG, `intercept catch exception.`, err);
      }
    }
    return false;
  }

  /**
   * 处理对端请求，并返回处理结果
   * @param version 跨端接口版本号
   * @param data 对端请求数据
   * @returns 处理结果
   */
  private async request(version: number, data: rpc.MessageSequence): Promise<RemoteRsp> {
    const timestamp: number = new Date().getTime();
    const req: RemoteReq | undefined = RpcCodec.fromRpc(version, data);
    if (req === undefined) {
      TsLog.error(TAG, `${this.getDescriptor()} invalid params`);
      return RemoteRsp.ERR_PARAM;
    }
    let rsp: RemoteRsp = new RemoteRsp(RemoteCode.ERR_UNKNOWN, 'Unknown error');
    const preIntercept: boolean = await this.intercept(this.preInterceptors, timestamp, req, rsp);
    if (!preIntercept) {
      try {
        rsp = await this.exeCalleeMethod(req);
      } catch (err) {
        TsLog.error(TAG, `exeCalleeMethod catch exception.`, err);
        let error: BusinessError<string> = err as BusinessError<string>;
        rsp = new RemoteRsp(error?.code ?? RemoteCode.ERR_UNKNOWN, error?.data ?? 'ERR');
      }
    }
    const postIntercept: boolean = await this.intercept(this.postInterceptors, timestamp, req, rsp);
    if (postIntercept) {
      TsLog.info(TAG, `Remote postResult Intercept, req:[${req?.method}]`);
    }
    return rsp;
  }

  private async exeCalleeMethod(req: RemoteReq | undefined): Promise<RemoteRsp> {
    if (!req?.method) {
      TsLog.warning(TAG, `${this.getDescriptor()}, err param no method`);
      return RemoteRsp.ERR_PARAM;
    }
    // 方法是否实现
    let methodArg: MethodArgs = this.methodSet.get(req.method);
    if (!methodArg) {
      TsLog.warning(TAG, `${this.getDescriptor()}, unsupport method: ${req.method}`);
      return RemoteRsp.ERR_API_NOT_EXIST;
    }
    if (TsLog.isDebug(TAG)) {
      TsLog.debug(TAG, `remote call TS: ${JsonUtils.stringify(req)}`);
    }
    return new Promise(async (resolve, reject) => {
      let timeoutId: number = -1;
      if (methodArg?.securityPolicy?.hasTimedOut) {
        timeoutId = setTimeout(() => {
          const error: BusinessError<string> = { name: `error`, message: `timeout`, code: RemoteCode.ERR_UNKNOWN };
          TsLog.error(TAG, `method apply timeout.`);
          reject(error);
        }, TIMEOUT);
      }
      //执行函数
      try {
        let result: string | number | boolean | void | object | null | undefined = false;
        if (req.args) {
          result = await methodArg.method(...req.args);
        } else {
          result = await methodArg.method();
        }
        resolve(new RemoteRsp(RemoteCode.SUCCESS, `success`, RpcCodec.encodeRsp(result)));
      } catch (err) {
        reject(err);
        return;
      } finally {
        if (timeoutId && timeoutId !== -1) {
          clearTimeout(timeoutId);
        }
      }
    });
  }

  private async callerAuth(): Promise<void> {
    try {
      let callerBundleName: string = await this.getCallerBundleName();
      TsLog.info(TAG, `callerBundleName:${callerBundleName}, Permissions:${this.callee.getRemotePermissions()}`);
    } catch (err) {
      TsLog.error(TAG, `callerAuth catch exception.`, err);
    }
  }

  private verifyAccessToken(): boolean {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    let tokenID: number = rpc.IPCSkeleton.getCallingTokenId();
    return this.callee.getRemotePermissions()?.every(permission =>
    atManager.verifyAccessTokenSync(tokenID, permission) === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED);
  }

  private async getCallerBundleName(): Promise<string> {
    let callerBundleName: string = '';
    try {
      let uid: number = rpc.IPCSkeleton.getCallingUid();
      callerBundleName = await bundleManager.getBundleNameByUid(uid);
      TsLog.info(TAG, `callerBundleName:${callerBundleName},uid:${uid}, pid:${rpc.IPCSkeleton.getCallingPid()}`);
    } catch (err) {
      TsLog.error(TAG, `callerBundleName catch err:`, err);
    }
    return callerBundleName;
  }
}

/**
 * 创建一个远程存根对象
 * @param {string} descriptor - 描述符，用于标识远程存根对象
 * @param {RemoteCallee} callee - 远程调用者，用于处理远程存根对象的远程调用
 * @return {rpc.RemoteObject} 返回一个远程对象
 */
export function createRemoteStub(descriptor: string, callee: RemoteCallee): rpc.RemoteObject {
  // 使用描述符和远程调用者创建一个新的远程存根对象
  return new RemoteStub(descriptor, callee);
}


/**
 * RemoteCallee接口，定义了远程调用者的方法
 */
export interface RemoteCallee {
  /**
   * 注册方法集，用于远程调用
   *
   * @param methodSet 方法集
   */
  onRegister(methodSet: CalleeMethodSet): void;

  /**
   * 添加响应前拦截器
   * @param interceptors 拦截器
   */
  onAddPreInterceptor(interceptors: RemoteInterceptor[]): void;

  /**
   * 添加响应后拦截器
   * @param interceptors 拦截器
   */
  onAddPostInterceptor(interceptors: RemoteInterceptor[]): void;

  /**
   * 获取远程权限
   *
   * @returns 返回一个字符串数组，表示远程权限
   */
  getRemotePermissions(): Permissions[];
}


// 导出一个CalleeMethodSet类，该类继承自LightWeightMap类，键值对的键为字符串，值为MethodArgs对象
export class CalleeMethodSet extends LightWeightMap<string, MethodArgs> {
  /**
   *
   * @param methodName 需要注册的方法名
   * @param method 需要注册的方法
   * @param trustList 可选参数，表示信任列表，默认值为undefined
   */
  public register(methodName: string, method: CalleeMethodType, securityPolicy?: SecurityPolicy): void {
    // 将methodName、method和trustList作为一个MethodArgs对象存入map中
    this.set(methodName, { method: method, securityPolicy: securityPolicy });
  }
}

export interface MethodArgs {
  method: CalleeMethodType;
  securityPolicy?: SecurityPolicy;
}

export interface SecurityPolicy {
  /**
   * 请求可并行的
   */
  parallel?: boolean;

  /**
   * 可信的调用者信息
   */
  trustCallers?: CallerInfo[],

  /**
   * 是否有超时时间
   */
  hasTimedOut?: boolean;
}

export interface CallerInfo {
  bundleName: string;
  appId?: string;
  fingerprint?: string;
  appIdentifier?: string;
}

type CalleeMethodType = (...args: (string | boolean | number | null | undefined | object | ESObject)[]) =>
Promise<string | boolean | number | null | undefined | object | void>;