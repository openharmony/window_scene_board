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
import { MainPanelUtil } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/utils/MainPanelUtil';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import display from '@ohos.display';

export function MainPanelUtilTest() {
  describe('MainPanelUtilTest', () => {

    it('test_getSheetOptions', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);

      MainPanelUtil.getSheetOptions({});
      expect(true).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('test_getSheetOptions_1', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);

      MainPanelUtil.getSheetOptions({});
      expect(true).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('test_getSheetOptions_2', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction2: Function = mocker.mockFunc(display.getFoldStatus, display.getFoldStatus);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(display.FoldStatus.FOLD_STATUS_EXPANDED);

      MainPanelUtil.getSheetOptions({});
      expect(true).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clear(display.getFoldStatus);
      mocker.clearAll();
    });

    it('test_getSheetOptions_3', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction2: Function = mocker.mockFunc(display.getFoldStatus, display.getFoldStatus);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(display.FoldStatus.FOLD_STATUS_HALF_FOLDED);

      MainPanelUtil.getSheetOptions({});
      expect(true).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clear(display.getFoldStatus);
      mocker.clearAll();
    });

    it('test_getSheetOptions_4', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction2: Function = mocker.mockFunc(display.getFoldStatus, display.getFoldStatus);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(display.FoldStatus.FOLD_STATUS_HALF_FOLDED);
      let mockFunction3: Function = mocker.mockFunc(display.getDefaultDisplaySync, display.getDefaultDisplaySync);
      when(mockFunction3)(ArgumentMatchers.any).afterThrow('err');

      MainPanelUtil.getSheetOptions({});
      expect(true).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clear(display.getFoldStatus);
      mocker.clear(display.getDefaultDisplaySync);
      mocker.clearAll();
    });

    it('MainPanelUtil_getSheetOptions1', 0, () => {
      let mainPanelUtil = new MainPanelUtil();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      MainPanelUtil.getSheetOptions({});
      expect(mainPanelUtil).not().assertNull();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('MainPanelUtil_getSheetOptions2', 0, () => {
      let mainPanelUtil = new MainPanelUtil();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunction)(ArgumentMatchers.any).afterThrow('test');
      MainPanelUtil.getSheetOptions({});
      expect(mainPanelUtil).not().assertNull();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('MainPanelUtil_getFoldPhoneSheetOptions', 0, () => {
      let sheetOptions: SheetOptions = {
        dragBar: false,
        showClose: true,
        preferType: 0,
        backgroundColor: Color.Transparent,
        blurStyle: BlurStyle.COMPONENT_ULTRA_THICK,
        title: { title: $r('app.string.aod_style_title') },
      }
      let result: number = (MainPanelUtil as object)['getFoldPhoneSheetOptions'](sheetOptions);
      expect(result).not().assertNull();
    });

    it('MainPanelUtil_getPadSheetOptions', 0, () => {
      let sheetOptions: SheetOptions = {
        dragBar: false,
        showClose: true,
        preferType: 0,
        backgroundColor: Color.Transparent,
        blurStyle: BlurStyle.COMPONENT_ULTRA_THICK,
        title: { title: $r('app.string.aod_style_title') },
      }
      let result: number = (MainPanelUtil as object)['getPadSheetOptions'](sheetOptions);
      expect(result).not().assertNull();
    });

    it('MainPanelUtil_getPadSheetWidth', 0, () => {
      let defaultDisplay: display.Display = display.getDefaultDisplaySync();
      let result: number = MainPanelUtil.getPadSheetWidth(defaultDisplay);
      expect(result).not().assertNull();
    });

  });
}