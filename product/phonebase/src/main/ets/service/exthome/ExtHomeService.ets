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

import rpc from '@ohos.rpc';
import {LogDomain, LogHelper } from '@ohos/basicutils';
import {IService} from '@ohos/componenthelper';
import { InvokeFace } from './executor/impl/InvokeFace';
import { BundleVerifyUtils } from './BundleVerifyUtils';
import { InvokeUnlock } from './executor/impl/invokeUnlock';
import { InvokeAuthResultCallback } from './executor/impl/InvokeAuthResultCallback';
import { CallResult, IExecutor } from './executor/IExecutor';

const TAG = 'ExtHomeService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const ACCESS_WHITELIST: string[] = ['com.ohos.outerhome'];

/**
 * 请求方法
 *
 * @since 2024-03-28
 */
export const enum RequestMethod {
  /**
   * 人脸识别方法
   */
  INVOKE_FACE_VERIFY = 'FaceVerify',

  /**
   * unlock方法
   */
  INVOKE_UNLOCK = 'Unlock',

  /**
   * 人脸，指纹认证结果回调方法
   */
  INVOKE_AUTH_RESULT_CALLBACK = 'AuthResultCallback'
}

/**
 * 请求消息数据结构
 *
 * @since 2024-03-28
 */
export interface CallMessage {
  /**
   * 方法名
   */
  method: string;

  /**
   * 附加参数
   */
  extra: object;
}

/**
 * OuterHome业务服务
 *
 * @since 2024-03-28
 */
export class ExtHomeService implements IService {
  private static readonly executorMap: Map<string, () => IExecutor> = new Map<string, () => IExecutor>([
    [RequestMethod.INVOKE_FACE_VERIFY, (): IExecutor => new InvokeFace()],
    [RequestMethod.INVOKE_UNLOCK, (): IExecutor => new InvokeUnlock()],
    [RequestMethod.INVOKE_AUTH_RESULT_CALLBACK, (): IExecutor => new InvokeAuthResultCallback()]
  ]);

  async onCall(json: string, remoteObject?: rpc.IRemoteObject | null): Promise<string> {
    let msg: CallMessage | undefined = undefined;
    try {
      msg = JSON.parse(json) as CallMessage;
    } catch (err) {
      log.error('onCall parse message failed, ', err);
    }
    if (!msg || !msg.method) {
      log.showWarn('onCall invalid method');
      return CallResult.FAIL;
    }
    const method: string = msg?.method;
    log.info(`onCall method = ${method}`);
    if (!method) {
      log.error('onCall invalid method');
      return CallResult.INVALID_METHOD;
    }
    const executor = ExtHomeService.executorMap.get(method);
    if (!executor) {
      log.error(`onCall unknown method = ${method}`);
      return CallResult.UNKNOWN_METHOD;
    }
    let verifyResult: boolean = await this.verifyIdentity(executor());
    if (!verifyResult) {
      log.error('onCall verifyIdentity failed');
      return CallResult.VERIFY_FAILED;
    }
    executor()?.execute(msg?.extra, remoteObject);
    return CallResult.SUCCESS;
  }

  isSupportSegments(): boolean {
    return false;
  }

  async verifyIdentity(executor: IExecutor): Promise<boolean> {
    let bundleName: string = BundleVerifyUtils.getBundleName();
    //1.白名单校验
    if (!ACCESS_WHITELIST.includes(bundleName)) {
      log.error(`verifyIdentity failed, reason: illegal app, bundleName:${bundleName}`);
      return false;
    }
    //2.系统应用校验
    if (!BundleVerifyUtils.isSystemApp(bundleName)) {
      log.error(`verifyIdentity failed, reason: not system app, bundleName:${bundleName}`);
      return false;
    }
    return executor.verifyIdentity(bundleName);
  }

}