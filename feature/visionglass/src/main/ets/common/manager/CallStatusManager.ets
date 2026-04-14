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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { call } from '@kit.TelephonyKit';

const TAG = 'CallStatusManager';
const log = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

export class CallStatusManager {
  public static instance: CallStatusManager | undefined = undefined;
  public isCallingState: boolean = false;

  public registerCallDetailsChangeCallback(): void {
    log.showInfo('registerCallDetailsChangeCallback');
    try {
      call.on('callDetailsChange', (data: call.CallAttributeOptions) => {
        if (!data) {
          log.showInfo('call.on registerCallDetailsChangeCallback, data is null');
          return;
        }
        if (data.callState === call.DetailedCallState.CALL_STATUS_ACTIVE) {
          this.isCallingState = true;
        } else {
          this.isCallingState = false;
        }
      });
    } catch (err) {
      log.showError(`registerCallDetailsChangeCallback err ${err.code}`);
    }
  }

  public unRegisterCallDetailsChangeCallback(): void {
    try {
      call.off('callDetailsChange', (data: call.CallAttributeOptions) => {
        log.showInfo('call.off unRegisterCallDetailsChangeCallback');
      });
    } catch (err) {
      log.showError(`unRegisterCallDetailsChangeCallback err ${err.code}`);
    }
  }

  /*
   * 获取当前类单例
   * */
  public static getInstance(): CallStatusManager {
    if (!CallStatusManager.instance) {
      log.showInfo(`getInstance new instance`);
      CallStatusManager.instance = new CallStatusManager();
    }
    return CallStatusManager.instance;
  }

  /*
   * 销毁当前类单例
   * */
  public static destroyInstance(): void {
    log.showInfo(`destroyInstance`);
    CallStatusManager.instance = undefined;
  }
}