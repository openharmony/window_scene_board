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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level, Size, TestType } from '@ohos/hypium';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { InputMethodModel } from '@ohos/pcbase/src/main/ets/SceneBoard/inputmethodpanel/model/InputMethodModel';
import InputMethodSubtype from '@ohos.InputMethodSubtype';
import { inputMethod } from '@kit.IMEKit';


const TAG = 'InputMethodModelTest';

export default function InputMethodModelTest() {
  let inputMethodModel: InputMethodModel = new InputMethodModel();
  let listener: InputMethodModelTestListener = new InputMethodModelTestListener();
  let subtype: InputMethodSubtype = {
    'id': 'InputZhService',
    'label': '中文拼音',
    'labelId': 134217733,
    'name': 'com.ohos.inputmethod',
    'mode': 'lower',
    'locale': 'zh_CN',
    'language': 'chinese',
    'icon': '$media:134217738',
    'iconId': 134217738
  }
  describe('InputMethodModelTest', () => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    });
    afterEach((): void => {

    });
    afterAll((): void => {
      hilog.info(0x0000, TAG, 'afterAll all it pass');
    });

    it('startService', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        inputMethodModel.startService();
        inputMethodModel.startService();
      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'startService error' + e);
      }
    });

    it('stopService', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        inputMethodModel.stopService();
        inputMethodModel.stopService();
      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'stopService error' + e);
      }
    });

    it('registerListener', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        inputMethodModel.startService();
        inputMethodModel.registerListener(listener);
      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'registerAudioDeviceListener error' + e);
      }
    });

    it('unregisterListener', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        inputMethodModel.startService();
        inputMethodModel.unregisterListener(listener);
      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'unregisterAudioDeviceListener error' + e);
      }
    });

    it('onInputMethodChange', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        inputMethodModel.startService();
        inputMethodModel.registerListener(listener);
        inputMethodModel.onInputMethodChange(property, subtype);
      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'registerInputDeviceListener error' + e);
      }
    });
  });
}

class InputMethodModelTestListener {
  constructor() {
  }

  updateInputMethodInfo(): void {
    hilog.info(0x0000, TAG, 'updateInputMethodInfo success');
  }
}