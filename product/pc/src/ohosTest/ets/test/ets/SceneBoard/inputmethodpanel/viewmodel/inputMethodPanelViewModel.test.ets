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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, TestType, Size, Level,
  MockKit,
  ArgumentMatchers,
  when
} from '@ohos/hypium';
import {
  InputMethodInfo,
  InputMethodItemChangeListener,
  InputMethodItemType,
  InputMethodSubtypeInfo,
  SwitchType
} from '@ohos/pcbase/src/main/ets/SceneBoard/inputmethodpanel/common/Constants';
import {
  InputMethodPanelViewModel
} from '@ohos/pcbase/src/main/ets/SceneBoard/inputmethodpanel/viewmodel/InputMethodPanelViewModel';
import inputMethod from '@ohos.inputMethod';
import { StateChangeListener } from '@ohos/pcbase/src/main/ets/SceneBoard/systempanel/common/Constants';
import hilog from '@ohos.hilog';
import InputMethodSubtype from '@ohos.InputMethodSubtype';
import { commonEventManager } from '@kit.BasicServicesKit';
import { CheckEmptyUtils } from '@ohos/basicutils';


const TAG = 'InputMethodPanelViewModelTest';
const inputMethodInfos: InputMethodItemType[] = [];
const unknownInputMethodInfos: InputMethodItemType[] = [];
const InputMethodSubtypeInfos: InputMethodSubtypeInfo[] = [];
const windowListener: InputMethodItemChangeListener = {
  updateInputMethodPanelWindow(): void {
  }
}

const stateListener: StateChangeListener = {
  onStateChange(): void {
  }
}

export default function InputMethodPanelViewModelTest() {

  let leftSub: InputMethodSubtypeInfo = {
    vType: 'InputMethodSubtypeInfo',
    subtype: {
      label: undefined,
      "id": "InputMethodExtAbility",
      "labelId": 16777220,
      "name": "com.example.testIme",
      "mode": "lower",
      "locale": "zh-CN",
      "language": "chinese",
      "icon": "$media:16777224",
      "iconId": 16777224
    }
  };
  let rightSub: InputMethodSubtypeInfo = {
    vType: 'InputMethodSubtypeInfo',
    subtype: {
      label: undefined,
      "id": "InputMethodExtAbility",
      "labelId": 16777220,
      "name": "com.example.testIme",
      "mode": "lower",
      "locale": "zh-CN",
      "language": "chinese",
      "icon": "$media:16777224",
      "iconId": 16777224
    }
  };

  let left: InputMethodInfo = {
    vType: 'InputMethodInfo',
    property: {
      "packageName": 'com.ohos.inputmethod',
      "methodId": '',
      "id": "A",
      "label": "A",
      "labelId": 123456,
      "name": "com.ohos.A",
      "icon": "$media:123456",
      "iconId": undefined,
    }
  };
  let right: InputMethodInfo = {
    vType: 'InputMethodInfo',
    property: {
      "packageName": 'com.ohos.inputmethod',
      "methodId": '',
      "id": "A",
      "label": "A",
      "labelId": 123456,
      "name": "com.ohos.A",
      "icon": "$media:123456",
      "iconId": undefined,
    }
  };

  let leftSubtype: InputMethodSubtype = {
    "id": "A",
    "label": "A",
    "labelId": 123456,
    "name": "com.ohos.A",
    "icon": "$media:123456",
    "iconId": undefined,
    "locale": "",
    "language": "A",
    "mode": "upper"
  };
  let rightSubtype: InputMethodSubtypeInfo = {
    vType: 'InputMethodSubtypeInfo',
    subtype: {
      "id": "A",
      "label": "A",
      "labelId": 123456,
      "name": "com.ohos.A",
      "icon": "$media:123456",
      "iconId": undefined,
      "locale": "",
      "language": "A",
      "mode": "upper"
    }
  };

  describe('InputMethodPanelViewModelTest', () => {
    beforeAll((): void => {
      // 英文
      inputMethodInfos.push({
        'vType': 'InputMethodSubtypeInfo',
        'subtype': {
          "id": "InputEnLowerService",
          "label": "英文",
          "labelId": 134217730,
          "name": "com.ohos.inputmethod",
          "mode": "lower",
          "locale": "en_US",
          "language": "english",
          "icon": "$media:134217736",
          "iconId": 134217736
        }
      });
      // 中文
      inputMethodInfos.push({
        'vType': 'InputMethodSubtypeInfo',
        'subtype': {
          "id": "InputZhService",
          "label": "中文拼音",
          "labelId": 134217733,
          "name": "com.ohos.inputmethod",
          "mode": "lower",
          "locale": "zh_CN",
          "language": "chinese",
          "icon": "$media:134217738",
          "iconId": 134217738
        }
      });
      // 英文大写
      inputMethodInfos.push({
        'vType': 'InputMethodSubtypeInfo',
        'subtype': {
          "id": "InputEnUpperService",
          "label": "A",
          "labelId": 134217732,
          "name": "com.ohos.inputmethod",
          "mode": "upper",
          "locale": "en_US",
          "language": "english",
          "icon": "$media:134217737",
          "iconId": 134217737
        }
      });
      // 英文
      InputMethodSubtypeInfos.push({
        'vType': 'InputMethodSubtypeInfo',
        'subtype': {
          "id": "InputEnLowerService",
          "label": "英文",
          "labelId": 134217730,
          "name": "com.ohos.inputmethod",
          "mode": "lower",
          "locale": "en_US",
          "language": "english",
          "icon": "$media:134217736",
          "iconId": 134217736
        }
      });
      // 中文
      InputMethodSubtypeInfos.push({
        'vType': 'InputMethodSubtypeInfo',
        'subtype': {
          "id": "InputZhService",
          "label": "中文拼音",
          "labelId": 134217733,
          "name": "com.ohos.inputmethod",
          "mode": "lower",
          "locale": "zh_CN",
          "language": "chinese",
          "icon": "$media:134217738",
          "iconId": 134217738
        }
      });
      // 英文大写
      InputMethodSubtypeInfos.push({
        'vType': 'InputMethodSubtypeInfo',
        'subtype': {
          "id": "InputEnUpperService",
          "label": "A",
          "labelId": 134217732,
          "name": "com.ohos.inputmethod",
          "mode": "upper",
          "locale": "en_US",
          "language": "english",
          "icon": "$media:134217737",
          "iconId": 134217737
        }
      });

      // error
      inputMethodInfos.push({
        'vType': 'InputMethodInfo',
        'property': {
          "packageName": 'com.ohos.inputmethod',
          "methodId": '',
          "id": "A",
          "label": "A",
          "labelId": 123456,
          "name": "com.ohos.A",
          "icon": "$media:123456",
          "iconId": undefined,
        }
      });

      // 未知
      unknownInputMethodInfos.push({
        'vType': 'InputMethodSubtypeInfo',
        'subtype': {
          "id": "A",
          "label": "A",
          "labelId": 123456,
          "name": "com.ohos.A",
          "mode": "upper",
          "locale": "en_US",
          "language": "english",
          "icon": "$media:123456",
          "iconId": 654321
        }
      });

      // undefined
      unknownInputMethodInfos.push({
        'vType': 'InputMethodInfo',
        'property': {
          "packageName": '',
          "methodId": '',
          "id": "A",
          "label": "A",
          "labelId": 123456,
          "name": "com.ohos.A",
          "icon": "$media:123456",
          "iconId": undefined,
        }
      });

      // error1
      unknownInputMethodInfos.push({
        'vType': 'InputMethodInfo',
        'property': {
          "packageName": 'fadsfasdf',
          "methodId": 'fdasf',
          "id": "A",
          "label": "A",
          "labelId": 123456,
          "name": "com.ohos.A",
          "icon": "$media:123456",
          "iconId": 123456,
        }
      });

      // error2
      unknownInputMethodInfos.push({
        'vType': 'InputMethodInfo',
        'property': {
          "packageName": 'fadsfasdf',
          "methodId": 'fdasf',
          "id": "A",
          "label": "A",
          "labelId": 431243214,
          "name": "com.ohos.A",
          "icon": "$media:123456",
          "iconId": 123454352,
        }
      });

      // error3
      unknownInputMethodInfos.push({
        'vType': 'InputMethodInfo',
        'property': {
          "packageName": 'abcabc',
          "methodId": 'cbacxz',
          "id": "",
          "label": "",
          "labelId": undefined,
          "name": "",
          "icon": "",
          "iconId": undefined,
        }
      });

      // demo输入法
      inputMethodInfos.push({
        'vType': 'InputMethodSubtypeInfo',
        'subtype': {
          "id": "InputMethodExtAbility",
          "label": "chinese",
          "labelId": 16777220,
          "name": "com.example.testIme",
          "mode": "lower",
          "locale": "zh-CN",
          "language": "chinese",
          "icon": "$media:16777224",
          "iconId": 16777224
        }
      });

      // demo输入法
      inputMethodInfos.push({
        'vType': 'InputMethodSubtypeInfo',
        'subtype': {
          "id": "ServiceExtAbility",
          "label": "kikaInput",
          "labelId": 16777220,
          "name": "com.samples.kikainput",
          "mode": undefined,
          "locale": "",
          "language": "",
          "icon": "",
          "iconId": 0
        }
      });
    });
    beforeEach((): void => {

    });
    afterEach((): void => {

    });
    afterAll((): void => {
      hilog.info(0x0000, TAG, 'afterAll all it pass');
    });

    it('getDefaultLanguageMode', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      const languages = ["english", "chinese"];
      const unknownLanguages = ["A", "B", "C"];
      try {
        let inputMethodPanelViewModel = new InputMethodPanelViewModel();
        for (let i = 0; i < languages.length; i++) {
          inputMethodPanelViewModel.getDefaultLanguageMode(languages[i], (inputMethodInfo: InputMethodItemType): void => {
          });
        }

        for (let i = 0; i < unknownLanguages.length; i++) {
          inputMethodPanelViewModel.getDefaultLanguageMode(unknownLanguages[i], (inputMethodInfo: InputMethodItemType): void => {
          });
        }
      } catch (e) {
        hilog.info(0x0000, TAG, 'getDefaultLanguageMode' + JSON.stringify(e));
        expect(false).assertFail();
      }
    });

    it('updateIcon', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let inputMethodPanelViewModel = new InputMethodPanelViewModel();
        for (let i = 0; i < inputMethodInfos.length; i++) {
          inputMethodPanelViewModel.updateIcon(inputMethodInfos[i], () => {
          });
        }

        for (let i = 0; i < unknownInputMethodInfos.length; i++) {
          inputMethodPanelViewModel.updateIcon(unknownInputMethodInfos[i], () => {
          });
        }
      } catch (e) {
        hilog.info(0x0000, TAG, 'updateIcon' + JSON.stringify(e));

        expect(false).assertFail();
      }
    });

    it('updateTitle', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let inputMethodPanelViewModel = new InputMethodPanelViewModel();
        for (let i = 0; i < inputMethodInfos.length; i++) {
          inputMethodPanelViewModel.updateTitle(inputMethodInfos[i], (title: string) => {
          });
        }

        for (let i = 0; i < unknownInputMethodInfos.length; i++) {
          inputMethodPanelViewModel.updateTitle(unknownInputMethodInfos[i], (title: string) => {
          });
        }
      } catch (e) {
        hilog.info(0x0000, TAG, 'updateTitle' + JSON.stringify(e));

        expect(false).assertFail();
      }
    });

    it('updateInputMethodSubtypeTitle', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let inputMethodPanelViewModel = new InputMethodPanelViewModel();
      try {
        let obj: InputMethodSubtypeInfo = {
          vType: 'InputMethodSubtypeInfo',
          subtype: {
            "label": undefined,
            "id": "InputMethodExtAbility",
            "labelId": 16777220,
            "name": "com.example.testIme",
            "mode": "lower",
            "locale": "zh-CN",
            "language": "chinese",
            "icon": "$media:16777224",
            "iconId": 16777224
          }
        };
        inputMethodPanelViewModel.updateInputMethodSubtypeTitle(obj, () => {});
        obj = {
          vType: 'InputMethodSubtypeInfo',
          subtype: {
            "label": "aaa",
            "id": "InputMethodExtAbility",
            "labelId": 16777220,
            "name": "com.example.testIme",
            "mode": "lower",
            "locale": "zh-CN",
            "language": "chinese",
            "icon": "$media:16777224",
            "iconId": 16777224
          }
        };
        inputMethodPanelViewModel.updateInputMethodSubtypeTitle(obj, () => {});
      } catch (e) {
        hilog.info(0x0000, TAG, 'updateTitle' + JSON.stringify(e));
        expect(inputMethodPanelViewModel).not().assertNull();
      }
      expect(inputMethodPanelViewModel).not().assertNull();
    });

    it('setCurrentInputMethod', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let inputMethodPanelViewModel = new InputMethodPanelViewModel();
        let currentIme: inputMethod.InputMethodProperty = inputMethod.getCurrentInputMethod();
        inputMethodPanelViewModel.setCurrentInputMethod(currentIme, true);
      } catch (e) {
        hilog.info(0x0000, TAG, 'setCurrentInputMethod' + JSON.stringify(e));

        expect(false).assertFail();
      }
    });

    it('updateInputMethodInfo', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      AppStorage.setOrCreate('currentInputMethod', {});
      AppStorage.setOrCreate('currentInputMethodSubtype', {});
      let inputMethodPanelViewModel = new InputMethodPanelViewModel();
      let mocker: MockKit = new MockKit();
      let mockerFunc1 = mocker.mockFunc(inputMethodPanelViewModel, inputMethodPanelViewModel.isInputMethodPropertyInfoEqual);
      when(mockerFunc1)(ArgumentMatchers.any).afterReturn(false);
      let mockerFunc2 = mocker.mockFunc(inputMethodPanelViewModel, inputMethodPanelViewModel.isInputMethodSubtypeEqual);
      when(mockerFunc2)(ArgumentMatchers.any).afterReturn(false);
      try {
        for (let i = 0; i < inputMethodInfos.length; i++) {
          let property = inputMethodInfos[i] as InputMethodInfo;
          for (let j = 0; j < inputMethodInfos.length; j++) {
            let subtype = inputMethodInfos[i] as InputMethodSubtypeInfo;
            if (property && subtype) {
              inputMethodPanelViewModel.updateInputMethodInfo(property.property, subtype.subtype);
            }
          }
        }

        for (let i = 0; i < unknownInputMethodInfos.length; i++) {
          inputMethodPanelViewModel.updateIcon(unknownInputMethodInfos[i], () => {
          });
        }
      } catch (e) {
        hilog.info(0x0000, TAG, 'updateInputMethodInfo' + JSON.stringify(e));
      }
      expect(inputMethodPanelViewModel).not().assertNull();
      mocker.clear(inputMethodPanelViewModel);
    })

    it('updateState', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let inputMethodPanelViewModel = new InputMethodPanelViewModel();
        inputMethodPanelViewModel.updateState(false);
        inputMethodPanelViewModel.updateState(true);
      } catch (e) {
        hilog.info(0x0000, TAG, 'updateState' + JSON.stringify(e));

        expect(false).assertFail();
      }
    })

    it('updateMethodPropertyIcon1', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let inputMethodPanelViewModel = new InputMethodPanelViewModel();
        for (let i = 0; i < unknownInputMethodInfos.length; i++) {
          inputMethodPanelViewModel.updateMethodPropertyIcon((unknownInputMethodInfos[i] as InputMethodInfo), () => {
          })
        }
        for (let i = 0; i < unknownInputMethodInfos.length; i++) {
          inputMethodPanelViewModel.updateMethodPropertyIcon((inputMethodInfos[i] as InputMethodInfo), () => {
          })
        }
      } catch (e) {
        hilog.info(0x0000, TAG, 'updateMethodPropertyIcon1' + JSON.stringify(e));

        expect(false).assertFail();
      }
    })

    it('switchInputMethod', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let inputMethodPanelViewModel = new InputMethodPanelViewModel();
        for (let i = 0; i < inputMethodInfos.length; i++) {
          inputMethodPanelViewModel.switchInputMethod(inputMethodInfos[i])
        }

        for (let i = 0; i < unknownInputMethodInfos.length; i++) {
          inputMethodPanelViewModel.switchInputMethod(unknownInputMethodInfos[i])
        }
        inputMethodPanelViewModel.switchInputMethod(undefined);
      } catch (e) {
        hilog.info(0x0000, TAG, 'switchInputMethod' + JSON.stringify(e));

        expect(false).assertFail();
      }
    })

    it('registerUpdatePanelWindowListener', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let inputMethodPanelViewModel = new InputMethodPanelViewModel();
        inputMethodPanelViewModel.registerUpdatePanelWindowListener(windowListener);
      } catch (e) {
        hilog.info(0x0000, TAG, 'registerUpdatePanelWindowListener' + JSON.stringify(e));

        expect(false).assertFail();
      }
    })

    it('unregisterUpdatePanelWindowListener', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let inputMethodPanelViewModel = new InputMethodPanelViewModel();
        inputMethodPanelViewModel.registerUpdatePanelWindowListener(windowListener);
        inputMethodPanelViewModel.unregisterUpdatePanelWindowListener(windowListener);
      } catch (e) {
        hilog.info(0x0000, TAG, 'unregisterUpdatePanelWindowListener' + JSON.stringify(e));

        expect(false).assertFail();
      }
    })

    it('registerStateChangeListener', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let inputMethodPanelViewModel = new InputMethodPanelViewModel();
        inputMethodPanelViewModel.registerStateChangeListener(stateListener);
      } catch (e) {
        hilog.info(0x0000, TAG, 'registerStateChangeListener' + JSON.stringify(e));

        expect(false).assertFail();
      }
    })

    it('unregisterStateChangeListener', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let inputMethodPanelViewModel = new InputMethodPanelViewModel();
        inputMethodPanelViewModel.registerStateChangeListener(stateListener);
        inputMethodPanelViewModel.unregisterStateChangeListener(stateListener);
      } catch (e) {
        hilog.info(0x0000, TAG, 'unregisterStateChangeListener' + JSON.stringify(e));

        expect(false).assertFail();
      }
    })

    it('isInputMethodItemTypeEqual', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let inputMethodPanelViewModel = new InputMethodPanelViewModel();
      let mocker: MockKit = new MockKit();
      let mockerFunc = mocker.mockFunc(inputMethodPanelViewModel, inputMethodPanelViewModel.isInputMethodItemTypeEqual);
      when(mockerFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let isEqual = inputMethodPanelViewModel.isInputMethodItemTypeEqual(left, right);
        isEqual = inputMethodPanelViewModel.isInputMethodItemTypeEqual(leftSub, rightSub);
        isEqual = inputMethodPanelViewModel.isInputMethodItemTypeEqual(leftSub, right);
        expect(isEqual).assertTrue();
      } catch (e) {
        hilog.info(0x0000, TAG, 'isInputMethodItemTypeEqual' + JSON.stringify(e));

        expect(false).assertFalse();
      }
      mocker.clear(inputMethodPanelViewModel);
    })

    it('isInputMethodPropertyInfoEqual', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let inputMethodPanelViewModel = new InputMethodPanelViewModel();
        let left: InputMethodInfo = inputMethodInfos[3] as InputMethodInfo;
        let right: InputMethodInfo = inputMethodInfos[3] as InputMethodInfo;
        let isEqual = inputMethodPanelViewModel.isInputMethodPropertyInfoEqual(left, right);
        expect(isEqual).assertTrue();

        right = {} as InputMethodInfo;
        isEqual = inputMethodPanelViewModel.isInputMethodPropertyInfoEqual(left, right);
        expect(isEqual).assertFalse();
      } catch (e) {
        hilog.info(0x0000, TAG, 'isInputMethodPropertyInfoEqual' + JSON.stringify(e));

        expect(false).assertFail();
      }
    })

    it('updateInputMethodPanelWindow', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let inputMethodPanelViewModel = new InputMethodPanelViewModel();
        inputMethodPanelViewModel.updateInputMethodPanelWindow();
      } catch (e) {
        hilog.info(0x0000, TAG, 'updateInputMethodPanelWindow' + JSON.stringify(e));

        expect(false).assertFail();
      }
    })

    it('reportSwitchEvent', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let switchTypes: SwitchType[] = [SwitchType.SWITCH_INPUT_METHOD, SwitchType.SWITCH_LANGUAGE];
        let inputMethodPanelViewModel = new InputMethodPanelViewModel();
        for (let i = 0; i < switchTypes.length; i++) {
          inputMethodPanelViewModel.reportSwitchEvent(switchTypes[i]);
        }
      } catch (e) {
        hilog.info(0x0000, TAG, 'reportSwitchEvent' + JSON.stringify(e));
        expect(false).assertFail();
      }
    })

    it('initViewModelOfInput_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let inputMethodPanelViewModel = new InputMethodPanelViewModel();
        inputMethodPanelViewModel.initViewModel();
      } catch (e) {
        hilog.info(0x0000, TAG, 'initViewModelOfInput_01' + JSON.stringify(e));

        expect(false).assertFail();
      }
    })

    it('initViewModelOfInput_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let inputMethodPanelViewModel = new InputMethodPanelViewModel();
        (inputMethodPanelViewModel as object)['mIsStart'] = true;
        inputMethodPanelViewModel.initViewModel();
      } catch (e) {
        hilog.info(0x0000, TAG, 'initViewModelOfInput_02' + JSON.stringify(e));

        expect(false).assertFail();
      }
    })

    it('registerCommonEventChange', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let inputMethodPanelViewModel = new InputMethodPanelViewModel();
      let mocker: MockKit = new MockKit();
      let mockerFunc = mocker.mockFunc(commonEventManager.createSubscriberSync, commonEventManager.createSubscriberSync);
      try {
        (inputMethodPanelViewModel as object)['mSubscriber'] = {};
        inputMethodPanelViewModel.registerCommonEventChange();

        when(mockerFunc)(ArgumentMatchers.any).afterReturn(null);
        (inputMethodPanelViewModel as object)['mSubscriber'] = null;
        inputMethodPanelViewModel.registerCommonEventChange();

        when(mockerFunc)(ArgumentMatchers.any).afterReturn({});
        (inputMethodPanelViewModel as object)['mSubscriber'] = null;
        inputMethodPanelViewModel.registerCommonEventChange();
      } catch (e) {
        hilog.info(0x0000, TAG, 'registerCommonEventChange' + JSON.stringify(e));
        expect(inputMethodPanelViewModel).not().assertNull();
      }
      expect(inputMethodPanelViewModel).not().assertNull();
      mocker.clear(commonEventManager.createSubscriberSync);
    })

    it('unregisterCommonEventChange', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let inputMethodPanelViewModel = new InputMethodPanelViewModel();
      try {
        (inputMethodPanelViewModel as object)['mSubscriber'] = {};
        inputMethodPanelViewModel.unregisterCommonEventChange();
      } catch (e) {
        hilog.info(0x0000, TAG, 'unregisterCommonEventChange' + JSON.stringify(e));
        expect(inputMethodPanelViewModel).not().assertNull();
      }
      expect(inputMethodPanelViewModel).not().assertNull();
    })

    it('registerListeners', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let inputMethodPanelViewModel = new InputMethodPanelViewModel();
        inputMethodPanelViewModel.registerListeners();
      } catch (e) {
        hilog.info(0x0000, TAG, 'registerListeners' + JSON.stringify(e));
        expect(false).assertFail();
      }
      try {
        let inputMethodPanelViewModel = new InputMethodPanelViewModel();
        inputMethodPanelViewModel.unregisterListeners();
      } catch (e) {
        hilog.info(0x0000, TAG, 'unregisterListeners' + JSON.stringify(e));
        expect(false).assertFail();
      }
    })

    it('isInputMethodSubtypeLabelEqual', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let inputMethodPanelViewModel = new InputMethodPanelViewModel();
      let mocker: MockKit = new MockKit();
      let mockerFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      try {
        let left: InputMethodSubtypeInfo = InputMethodSubtypeInfos[0];
        let right: InputMethodSubtypeInfo = InputMethodSubtypeInfos[0];
        when(mockerFunc)(ArgumentMatchers.any).afterReturn(true);
        inputMethodPanelViewModel.isInputMethodSubtypeLabelEqual(left, right);

        when(mockerFunc)(right).afterReturn(false);
        inputMethodPanelViewModel.isInputMethodSubtypeLabelEqual(left, right);

        when(mockerFunc)(ArgumentMatchers.any).afterReturn(false);
        inputMethodPanelViewModel.isInputMethodSubtypeLabelEqual(left, right);
        expect(inputMethodPanelViewModel).not().assertNull();
      } catch (e) {
        hilog.info(0x0000, TAG, 'isInputMethodSubtypeLabelEqual' + JSON.stringify(e));
        expect(inputMethodPanelViewModel).not().assertNull();
      }
      mocker.clear(CheckEmptyUtils);
    })

    it('isInputMethodSubtypeInfoEqual', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let inputMethodPanelViewModel = new InputMethodPanelViewModel();
      let mocker: MockKit = new MockKit();
      let mockerFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      try {
        let left: InputMethodSubtypeInfo = InputMethodSubtypeInfos[0];
        let right: InputMethodSubtypeInfo = InputMethodSubtypeInfos[0];
        when(mockerFunc)(ArgumentMatchers.any).afterReturn(true);
        inputMethodPanelViewModel.isInputMethodSubtypeInfoEqual(left, right);

        when(mockerFunc)(right).afterReturn(false);
        inputMethodPanelViewModel.isInputMethodSubtypeInfoEqual(left, right);

        when(mockerFunc)(ArgumentMatchers.any).afterReturn(false);
        inputMethodPanelViewModel.isInputMethodSubtypeInfoEqual(left, right);
        expect(inputMethodPanelViewModel).not().assertNull();
      } catch (e) {
        hilog.info(0x0000, TAG, 'isInputMethodSubtypeInfoEqual' + JSON.stringify(e));
        expect(inputMethodPanelViewModel).not().assertNull();
      }
      mocker.clear(CheckEmptyUtils);
    })

    it('isInputMethodSubtypeEqual', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let inputMethodPanelViewModel = new InputMethodPanelViewModel();
      let mocker: MockKit = new MockKit();
      let mockerFunc = mocker.mockFunc(inputMethodPanelViewModel, inputMethodPanelViewModel.isInputMethodSubtypeEqual);
      try {
        when(mockerFunc)(ArgumentMatchers.any).afterReturn(true);
        let left: InputMethodSubtype = InputMethodSubtypeInfos[0].subtype;
        let right: InputMethodSubtypeInfo = InputMethodSubtypeInfos[0];
        let isEqual: boolean = inputMethodPanelViewModel.isInputMethodSubtypeEqual(left, right);

        left = InputMethodSubtypeInfos[1].subtype;
        isEqual = inputMethodPanelViewModel.isInputMethodSubtypeEqual(left, right);

        left = {} as InputMethodSubtype;
        isEqual = inputMethodPanelViewModel.isInputMethodSubtypeEqual(left, right);

        right = {} as InputMethodSubtypeInfo;
        isEqual = inputMethodPanelViewModel.isInputMethodSubtypeEqual(left, right);

        isEqual = inputMethodPanelViewModel.isInputMethodSubtypeEqual(leftSubtype, rightSubtype);
        expect(isEqual).assertTrue();
      } catch (e) {
        hilog.info(0x0000, TAG, 'registerListeners' + JSON.stringify(e));
        expect(false).assertFalse();
      }
      mocker.clear(inputMethodPanelViewModel);
    })
  })
}

