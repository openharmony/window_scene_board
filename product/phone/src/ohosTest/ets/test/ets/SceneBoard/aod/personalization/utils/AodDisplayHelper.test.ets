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
import { ArgumentMatchers, describe, expect, it, MockKit, when } from '@ohos/hypium';
import {
  AodDisplayHelper
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/utils/AodDisplayHelper';
import { display, uiExtensionHost } from '@kit.ArkUI';

export function AodDisplayHelperTest() {
  let aodDisplayHelper: AodDisplayHelper = new AodDisplayHelper();
  describe('AodDisplayHelperTest', () => {

    it('test_init', 0, () => {
      const instance = new AodDisplayHelper();
      instance.init();
      instance.init();
      expect(true).assertTrue();
    });

    it('test_init_1', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(display.on, display.on);
      when(mockFunction)(ArgumentMatchers.any).afterThrow('err');

      const instance = new AodDisplayHelper();
      instance.init();
      expect(true).assertTrue();
      mocker.clear(display.on);
      mocker.clearAll();
    });

    it('test_destroy', 0, () => {
      const instance = new AodDisplayHelper();
      instance.destroy();
      expect(true).assertTrue();
    });

    it('test_destroy_1', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(display.off, display.off);
      when(mockFunction)(ArgumentMatchers.any).afterThrow('err');

      const instance = new AodDisplayHelper();
      instance.destroy();
      expect(true).assertTrue();
      mocker.clear(display.off);
      mocker.clearAll();
    });

    it('AodDisplayHelperTest_foldStatusChange1', 0, () => {
      (aodDisplayHelper as object)['preFoldStatus'] = 0;
      (aodDisplayHelper as object)['foldStatusChange'](0);
      expect(aodDisplayHelper).not().assertNull();
    });

    it('AodDisplayHelperTest_foldStatusChange2', 0, () => {
      (aodDisplayHelper as object)['preFoldStatus'] = 1;
      (aodDisplayHelper as object)['isDisplayChange'] = true;
      (aodDisplayHelper as object)['foldStatusChange'](0);
      expect(aodDisplayHelper).not().assertNull();
    });

    it('AodDisplayHelperTest_displayChange1', 0, () => {
      const defaultDisplay = display.getDefaultDisplaySync();
      (aodDisplayHelper as object)['preDisplayHeight'] = defaultDisplay.height;
      (aodDisplayHelper as object)['preDisplayWidth'] = defaultDisplay.width;
      (aodDisplayHelper as object)['displayChange']();
      expect(aodDisplayHelper).not().assertNull();
    });

    it('AodDisplayHelperTest_displayChange2', 0, () => {
      const defaultDisplay = display.getDefaultDisplaySync();
      (aodDisplayHelper as object)['preDisplayWidth'] = defaultDisplay.height;
      (aodDisplayHelper as object)['preDisplayHeight'] = defaultDisplay.width;
      (aodDisplayHelper as object)['displayChange']();
      expect(aodDisplayHelper).not().assertNull();
    });

    it('AodDisplayHelperTest_displayChange3', 0, () => {
      (aodDisplayHelper as object)['preDisplayWidth'] = 100;
      (aodDisplayHelper as object)['preDisplayHeight'] = 200;
      (aodDisplayHelper as object)['isFoldStatusChange'] = true;
      (aodDisplayHelper as object)['displayChange']();
      expect(aodDisplayHelper).not().assertNull();
    });

    it('AodDisplayHelperTest_doFoldStatusChange', 0, () => {
      (aodDisplayHelper as object)['doFoldStatusChange']();
      expect(aodDisplayHelper).not().assertNull();
    });

    it('AodDisplayHelperTest_doRotationChange', 0, () => {
      (aodDisplayHelper as object)['doRotationChange']();
      expect(aodDisplayHelper).not().assertNull();
    });
  });
}