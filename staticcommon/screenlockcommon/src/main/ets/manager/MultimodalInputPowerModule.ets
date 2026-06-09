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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import type { Callback } from '@ohos.base';
import inputConsumer from '@ohos.multimodalInput.inputConsumer';
import { KeyCode } from '@ohos.multimodalInput.keyCode';

const TAG = 'MultimodalInputPowerModule';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export default class MultimodalInputPowerModule {
  constructor(powerKeyDownUpCallback?: Callback<inputConsumer.KeyOptions>) {
    if (!!powerKeyDownUpCallback) {
      this.powerKeyDownUpCallback = powerKeyDownUpCallback;
    }
  }

  private powerKeyDownUpCallback: Callback<inputConsumer.KeyOptions> = (keyOptions: inputConsumer.KeyOptions) => {
    log.showInfo(`power key down up default callback, keyOptions: ${keyOptions.finalKey} + ${keyOptions.isFinalKeyDown}`);
  };

  private powerKeyDownOptions: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: KeyCode.KEYCODE_POWER,
    isFinalKeyDown: true,
    finalKeyDownDuration: 0
  };

  private powerKeyUpOptions: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: KeyCode.KEYCODE_POWER,
    isFinalKeyDown: false,
    finalKeyDownDuration: 0
  };

  public setPowerKeyDownUpCallback(powerKeyDownUpCallback: Callback<inputConsumer.KeyOptions>): void {
    this.powerKeyDownUpCallback = powerKeyDownUpCallback;
  }

  public registerPowerKeyDown(): void {
    try {
      inputConsumer.on('key', this.powerKeyDownOptions, this.powerKeyDownUpCallback);
      log.showInfo('Subscribe power key down success');
    } catch (error) {
      log.showError('Subscribe failed, error');
    }
  }

  public unRegisterPowerKeyDown(): void {
    try {
      inputConsumer.off('key', this.powerKeyDownOptions, this.powerKeyDownUpCallback);
      log.showInfo('Unsubscribe power key down success');
    } catch (error) {
      log.showError('Execute failed, error');
    }
  }

  public registerPowerKeyUp(): void {
    try {
      inputConsumer.on('key', this.powerKeyUpOptions, this.powerKeyDownUpCallback);
      log.showInfo('Subscribe power key up success');
    } catch (error) {
      log.showError('Subscribe failed, error');
    }
  }

  public unRegisterPowerKeyUp(): void {
    try {
      inputConsumer.off('key', this.powerKeyUpOptions, this.powerKeyDownUpCallback);
      log.showInfo('Unsubscribe power key up success');
    } catch (error) {
      log.showError('Execute failed, error');
    }
  }
}