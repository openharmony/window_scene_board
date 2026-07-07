/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
// import collaborationServiceManager from '@ohos.collaboration.collaborationServiceManager'

const TAG = 'CollaborationRegisterManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export interface CollaborationCallBack {
  // callBack: (result: collaborationServiceManager.ServiceStateInfo) => void;
}

export class CollaborationRegisterManager {

  private collaborationCallBackMap: Map<string, CollaborationCallBack> = new Map();

  public static getInstance(): CollaborationRegisterManager {
    if (!globalThis.CollaborationRegisterManagerInstance) {
      globalThis.CollaborationRegisterManagerInstance = new CollaborationRegisterManager();
    }
    return globalThis.CollaborationRegisterManagerInstance;
  }

  /**
   * Subscribe distributed service status change notifications.
   * The callback function is used to notify
   *
   * @param { string } callingName
   * @param { CollaborationCallBack } callback
   */
  public register(callingName: string, callback: CollaborationCallBack) {
    try {
      log.showInfo(`register CollaborationRegisterManager callback: ${callingName}`);
      this.collaborationCallBackMap.set(callingName, callback);
      // 遍历map，打包各个register
      // collaborationServiceManager.subscribeServiceState((result: collaborationServiceManager.ServiceStateInfo) => {
      //   this.collaborationCallBackMap.forEach((collaborationCallBack) => {
      //     collaborationCallBack.callBack(result);
      //   });
      // });
    } catch (error) {
      log.showError(`register CollaborationRegisterManager error: ${error}`)
    }
  }

  /**
   * Unsubscribe distributed service status change notifications.
   *
   * @param { string } callingName
   */
  public unregister(callingName: string) {
    try {
      log.showInfo(`unregister CollaborationRegisterManager callback: ${callingName}`);
      this.collaborationCallBackMap.delete(callingName);
      // if (this.collaborationCallBackMap.size === 0) {
      //   collaborationServiceManager.unsubscribeServiceState();
      //   return;
      // }
      // collaborationServiceManager.subscribeServiceState((result: collaborationServiceManager.ServiceStateInfo) => {
      //   this.collaborationCallBackMap.forEach((collaborationCallBack) => {
      //     collaborationCallBack.callBack(result);
      //   });
      // });
    } catch (error) {
      log.showError(`unregister CollaborationRegisterManager error: ${error}`);
    }
  }
}