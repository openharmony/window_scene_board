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
import FingerprintViewModel from '../refactor/FingerprintViewModel';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { PromptShowType } from '@ohos/screenlockcomponent/src/main/ets/fingerprint/BasePromptViewModel';
import { IAMAuthExtraInfo } from '@ohos/screenlockcommon';
import { PCBasePromptViewModel } from './PCBasePromptViewModel';

const TAG = 'ScreenLock-PCFingerprintViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

// 这里类主要是维护tip，需要知道是主动还是被动刷新tips，以及tips显示优先级
export class PCFingerprintViewModel extends FingerprintViewModel {
  public async fingerprintAcquireInfoCallback(moduleId: number, acquire: number,
    extraJsonInfo: IAMAuthExtraInfo): Promise<void> {
    if (this.customizePromptVM && this.customizePromptVM instanceof PCBasePromptViewModel) {
      this.customizePromptVM.haveTryUnlock = true;
      this.customizePromptVM.userRetry = true;
    }
    super.fingerprintAcquireInfoCallback(moduleId, acquire, extraJsonInfo);
  }

  public showPrompt(prompt: string, promptShowType: PromptShowType, duration?: number) {
  }
}