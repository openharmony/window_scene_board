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

import call from '@ohos.telephony.call';
import observer from '@ohos.telephony.observer';
import { LogHelper, LogDomain } from '@ohos/basicutils';

const TAG = 'CallStateChangeHandler';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

/**
 * Handle call state change.
 */
export class CallStateChangeHandler {
  private callStateChangeListener?: Function;

  private callStateChangeCallback: (callStateInfo: CallBack) => void = (callStateInfo: CallBack) => {
    if (callStateInfo.state === call.CallState.CALL_STATE_RINGING ||
      callStateInfo.state === call.CallState.CALL_STATE_OFFHOOK) {
      this.callStateChangeListener?.();
    }
  };

  registerCallBack(listener: Function): void {
    this.callStateChangeListener = listener;
    try {
      observer.on('callStateChange', this.callStateChangeCallback);
    } catch (error) {
      log.error('registerCallBack observer error', error);
    }
  }

  unregisterCallBack(): void {
    try {
      observer.off('callStateChange', this.callStateChangeCallback);
    } catch (error) {
      log.error('unregisterCallBack observer error', error);
    }
  }
}

/**
 * Call state change callback.
 */
class CallBack {
  public state: call.CallState = call.CallState.CALL_STATE_UNKNOWN;
  public stateType: string = '';
}