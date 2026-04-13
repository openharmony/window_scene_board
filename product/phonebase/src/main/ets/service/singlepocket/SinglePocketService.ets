/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {IService } from '@ohos/componenthelper';
import { IExecutor, CallResult } from './executor/IExecutor';
import lazy { AppSwitchContinuation } from './executor/impl/AppSwitchContinuation';
import bundleManager from '@ohos.bundle.bundleManager';
import lazy { OuterAppManager } from '@ohos/launchercommon/src/main/ets/manager/OuterAppManager';
import { DesktopUtils } from '@ohos/launchercommon';

const TAG = 'SinglePocketService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 请求方法
 *
 * @since 2024-03-28
 */
export const enum RequestMethod {
  /**
   * 应用切换内外屏接续使能
   */
  APP_SWITCH_IN_OUT_CONTINUATION = 'appSwitchContinuation',
}

/**
 * 请求消息数据结构
 *
 */
export interface CallMessage {
  /**
   * 方法名
   */
  method: string;

  /**
   * 附加参数
   */
  extra: boolean;
}

/**
 * 扩展新形态小折叠业务服务
 *
 */
export class SinglePocketService implements IService {
  private static readonly executorMap: Map<string, () => IExecutor> = new Map<string, () => IExecutor>([
    [RequestMethod.APP_SWITCH_IN_OUT_CONTINUATION, (): IExecutor => new AppSwitchContinuation()]]);

  async onCall(json: string, remoteObject?: rpc.IRemoteObject | null): Promise<string> {
    let msg: CallMessage | undefined = undefined;
    try {
      msg = JSON.parse(json) as CallMessage;
    } catch (err) {
      log.error('onCall parse message failed, ', err);
    }
    if (!msg) {
      log.showWarn('onCall invalid message');
      return CallResult.FAIL;
    }
    const method: string = msg?.method;
    log.info(`onCall method = ${method} enable is ${msg?.extra}`);
    if (!method) {
      log.error('onCall invalid method');
      return CallResult.INVALID_METHOD;
    }
    const executor = SinglePocketService.executorMap.get(method);
    if (!executor) {
      log.error(`onCall unknown method = ${method}`);
      return CallResult.UNKNOWN_METHOD;
    }
    if (!this.verifyIdentity()) {
      log.error('onCall verifyIdentity failed');
      return CallResult.VERIFY_FAILED;
    }
    executor()?.execute(msg?.extra, remoteObject);
    return CallResult.SUCCESS;
  }

  isSupportSegments(): boolean {
    return false;
  }

  private verifyIdentity(): boolean {
    return true;
  }

  private getBundleName(): string {
    let bundleName: string = '';
    try {
      let callUid: number = rpc.IPCSkeleton.getCallingUid();
      bundleName = bundleManager.getBundleNameByUidSync(callUid);
    } catch (error) {
      log.error('call getBundleName error', error);
    }
    return bundleName;
  }
}