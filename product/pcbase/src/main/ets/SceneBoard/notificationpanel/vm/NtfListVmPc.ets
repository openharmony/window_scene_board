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
import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { NtfListVm } from '@ohos/notificationcomponent/src/main/ets/model/NtfListVm';

const TAG = 'NtfListVmPc';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export class NtfListVmPc extends NtfListVm {
  /**
   * 清除所有通知
   */
  clearAllNtf(delay: number): void {
    // 无可清除通知
    if (ArrayUtils.isEmpty(this.ntfClearMap)) {
      log.showInfo('clearAllNtf no ntf: ' + this.getNtfType());
      return;
    }
    this.ntfListChangeCallback.forEach((callback) => callback?.onClearingAllChange(true));
    super.clearAllNtf(delay);
  }

  updateClearButtonState(): void {
    this.callback?.onClearButtonStateChange(super.isShowClearBtn());
  }
}