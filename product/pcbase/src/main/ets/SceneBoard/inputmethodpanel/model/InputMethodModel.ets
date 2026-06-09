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

import {
  LogDomain,
  LogHelper,
  SingletonHelper,
} from '@ohos/basicutils';
import { HiSysEventUtil } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { ReportType } from '../common/Constants';
import type { InputMethodUpdateListener } from '../common/Constants';
import type InputMethodSubtype from '@ohos.InputMethodSubtype';
import inputMethod from '@ohos.inputMethod';
import InputMethodUtils from '@ohos/inputmethodcomponent/src/main/ets/default/common/InputMethodUtils';

const TAG = 'InputMethodModel';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class InputMethodModel {
  mIsStart: boolean = false;
  mListeners = new Set<InputMethodUpdateListener>();
  private mInputMethodSetting: inputMethod.InputMethodSetting = inputMethod.getSetting();

  constructor() {
    log.showInfo('constructor');
  }

  startService(): void {
    log.showInfo('startService');
    if (this.mIsStart) {
      return;
    }
    this.reportReStartInputMethod();
    this.mIsStart = true;
    log.showInfo('input method change listener');
    this.mInputMethodSetting.on('imeChange', this.onInputMethodChange.bind(this));
  }

  stopService(): void {
    if (!this.mIsStart) {
      return;
    }
    log.showInfo('stopService');
    this.mIsStart = false;
  }

  registerListener(listener: InputMethodUpdateListener): void {
    let res = this.mListeners.add(listener);
    log.showInfo(`register input method listener ${res}`);
  }

  unregisterListener(listener: InputMethodUpdateListener): void {
    let res = this.mListeners.delete(listener);
    log.showInfo(`unregister InputMethodListener ${res}}`);
  }

  async onInputMethodChange(inputMethodProperty: inputMethod.InputMethodProperty,
    inputMethodSubtype: InputMethodSubtype): Promise<void> {
    log.showInfo(`onInputMethodChange property:${JSON.stringify(inputMethodProperty)}, subtype:${JSON.stringify(inputMethodSubtype)}`);
    this.mListeners.forEach(listener => {
      listener.updateInputMethodInfo(inputMethodProperty, inputMethodSubtype);
    });
  }

  private async reportReStartInputMethod(): Promise<void> {
    let currentIme: inputMethod.InputMethodProperty | null = await InputMethodUtils.queryCurrentInputMethod();
    let currentImeSubType: InputMethodSubtype | null = await InputMethodUtils.queryCurrentInputMethodSubtype();
    let data = await ResUtils.getBundleInfo(TAG, currentIme?.packageName);
    let resource: Resource = {
      bundleName: data.name,
      moduleName: data.entryModuleName,
      id: parseInt(data?.appInfo?.labelId)
    };
    let label: string = await ResUtils.getOutString(resource);
    HiSysEventUtil.reportInputMethod(ReportType.REPORT_RESTART, label, currentImeSubType?.label);
  }
}

let inputMethodModel = SingletonHelper.getInstance(InputMethodModel, TAG);
export default inputMethodModel as InputMethodModel;