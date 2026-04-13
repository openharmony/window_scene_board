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
import { FingerprintConstants, CommonConstants } from '@ohos/screenlockcommon';
import { Callback } from '@ohos.base';
import Constants from '../common/Constants';

const TAG = 'InputPwdDefaultPromptViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class InputPwdDefaultPromptViewModel {
  public defaultPrompt: Resource = $r('app.string.psd_enter_psd');
  private defaultPromptTimeId: number = -1;
  public pinType: string = '';

  public setPinType(passwordType: string): void {
    if (this.pinType === passwordType) {
      return;
    }
    this.pinType = passwordType;
    this.setDefaultPrompt(this.pinType);
  }

  protected setDefaultPrompt(passwordType: string): Resource {
    this.defaultPrompt = $r('app.string.psd_enter_psd');
    if (this.pinType === CommonConstants.PIN_TYPE_MIX) {
      this.defaultPrompt = $r('app.string.psd_enter_psd_mix');
    } else if (this.pinType === CommonConstants.PIN_TYPE_PATTERN) {
      this.defaultPrompt = $r('app.string.pattern_psd_enter_psd');
    }
    return this.defaultPrompt;
  }

  public changePSDDefaultPrompt(delay: number, defaultPrompt: Resource,
                                restoreCallback: Callback<void> = (): void => {
                                }): void {
    log.showInfo(`changePSDDefaultPrompt ${delay}.`);
    if (delay === FingerprintConstants.INVALID_DURATION) {
      log.showInfo(`delay(${delay}) is forbided forever.`);
      this.defaultPrompt = !!defaultPrompt ? defaultPrompt : this.defaultPrompt;
      return;
    }

    if (delay < 0 || delay > FingerprintConstants.DEFAULT_FINGERPRINT_DISABLE_MILLI_SECOND) {
      log.showWarn(`delay(${delay}) is invalid.`);
      return;
    }

    if (this.defaultPromptTimeId !== -1) {
      clearTimeout(this.defaultPromptTimeId);
      this.defaultPromptTimeId = -1;
    }

    if (delay === 0) {
      log.showWarn(`delay(${delay}) so reset default prompt .`);
      this.defaultPrompt = this.setDefaultPrompt(this.pinType);
      return;
    }

    this.defaultPrompt = !!defaultPrompt ? defaultPrompt : this.defaultPrompt;
    this.defaultPromptTimeId = setTimeout(() => {
      log.showInfo('restore password default prompt.');
      this.defaultPrompt = this.setDefaultPrompt(this.pinType);
      restoreCallback();
      if (this.defaultPromptTimeId !== -1) {
        clearTimeout(this.defaultPromptTimeId);
        this.defaultPromptTimeId = -1;
      }
    }, delay);
  }

  public resetDefaultPrompt() {
    if (this.defaultPromptTimeId !== -1) {
      clearTimeout(this.defaultPromptTimeId);
      this.defaultPromptTimeId = -1;
    }
    log.showInfo('resetDefaultPrompt');
    this.defaultPrompt = this.setDefaultPrompt(this.pinType);
  }
}