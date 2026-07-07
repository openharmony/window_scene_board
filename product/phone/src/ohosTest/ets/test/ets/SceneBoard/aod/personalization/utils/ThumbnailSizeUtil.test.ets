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

import { describe, expect, it, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { ThumbnailSizeUtil }  from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/utils/ThumbnailSizeUtil';
import { AodSceneType } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/constant/Constant';
import { MainPageController } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/controller/MainPageController';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import display from '@ohos.display';
import { AodUtil, ComponentSize } from '@ohos/aod';


export function ThumbnailSizeUtilTest() {
  describe('ThumbnailSizeUtilTest', () => {

    it('test_getThumbnailSize_FOLD_STATUS_EXPANDED_1', 0, () => {
      const currentDisplay : display.Display = {
        orientation: 1,
      } as display.Display;
      const controller: MainPageController = new MainPageController();
      let mocker: MockKit = new MockKit();
      let mockIsPhoneFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockIsPhoneFunc)().afterReturn(true);// 走ThumbnailSizeUtil.getPhoneThumbnailSize(scene)
      let mockIsFoldButNotSmallFoldProductFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      when(mockIsFoldButNotSmallFoldProductFunc)().afterReturn(true);// 走display.getFoldStatus()
      let mockGetFoldStatusFunc: Function = mocker.mockFunc(display.getFoldStatus, display.getFoldStatus);
      when(mockGetFoldStatusFunc)().afterReturn(1);// 走FOLD_STATUS_EXPANDED,getFoldPhoneThumbnailSize(scene)
      let mockGetDefaultDisplaySyncFunc: Function = mocker.mockFunc(display.getDefaultDisplaySync, display.getDefaultDisplaySync);
      when(mockGetDefaultDisplaySyncFunc)().afterReturn(currentDisplay);// 走orientation === display.Orientation.LANDSCAPE
      ThumbnailSizeUtil.getThumbnailSize((AodSceneType.SCREEN_LOCK));
      expect(true).assertTrue();
      mocker.clear(mockIsPhoneFunc);
      mocker.clear(mockIsFoldButNotSmallFoldProductFunc);
      mocker.clear(mockGetFoldStatusFunc);
      mocker.clear(mockGetDefaultDisplaySyncFunc);
      mocker.clearAll();
    });

    it('test_getThumbnailSize_FOLD_STATUS_EXPANDED_2', 0, () => {
      const currentDisplay : display.Display = {
        orientation: 1,
      } as display.Display;
      const controller: MainPageController = new MainPageController();
      let mocker: MockKit = new MockKit();
      let mockIsPhoneFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockIsPhoneFunc)().afterReturn(true);// 走ThumbnailSizeUtil.getPhoneThumbnailSize(scene)
      let mockIsFoldButNotSmallFoldProductFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      when(mockIsFoldButNotSmallFoldProductFunc)().afterReturn(true);// 走display.getFoldStatus()
      let mockGetFoldStatusFunc: Function = mocker.mockFunc(display.getFoldStatus, display.getFoldStatus);
      when(mockGetFoldStatusFunc)().afterReturn(1);// 走FOLD_STATUS_EXPANDED,getFoldPhoneThumbnailSize(scene)
      let mockGetDefaultDisplaySyncFunc: Function = mocker.mockFunc(display.getDefaultDisplaySync, display.getDefaultDisplaySync);
      when(mockGetDefaultDisplaySyncFunc)().afterReturn(currentDisplay);// 走orientation === display.Orientation.LANDSCAPE
      ThumbnailSizeUtil.getThumbnailSize(AodSceneType.SETTING);
      expect(true).assertTrue();
      mocker.clear(mockIsPhoneFunc);
      mocker.clear(mockIsFoldButNotSmallFoldProductFunc);
      mocker.clear(mockGetFoldStatusFunc);
      mocker.clear(mockGetDefaultDisplaySyncFunc);
      mocker.clearAll();
    });

    it('test_getThumbnailSize_FOLD_STATUS_HALF_FOLDED', 0, () => {
      const controller: MainPageController = new MainPageController();
      let mocker: MockKit = new MockKit();
      let mockIsPhoneFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockIsPhoneFunc)().afterReturn(true);// 走ThumbnailSizeUtil.getPhoneThumbnailSize(scene)
      let mockIsFoldButNotSmallFoldProductFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      when(mockIsFoldButNotSmallFoldProductFunc)().afterReturn(true);// 走display.getFoldStatus()
      let mockGetFoldStatusFunc: Function = mocker.mockFunc(display.getFoldStatus, display.getFoldStatus);
      when(mockGetFoldStatusFunc)().afterReturn(3);// 走FOLD_STATUS_HALF_FOLDED
      ThumbnailSizeUtil.getThumbnailSize(controller.getScene());
      expect(true).assertTrue();
      mocker.clear(mockIsPhoneFunc);
      mocker.clear(mockIsFoldButNotSmallFoldProductFunc);
      mocker.clear(mockGetFoldStatusFunc);
      mocker.clearAll();
    });

    it('test_getThumbnailSize_FOLD_STATUS_else', 0, () => {
      const controller: MainPageController = new MainPageController();
      let mocker: MockKit = new MockKit();
      let mockIsPhoneFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockIsPhoneFunc)().afterReturn(true);// 走ThumbnailSizeUtil.getPhoneThumbnailSize(scene)
      let mockIsFoldButNotSmallFoldProductFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      when(mockIsFoldButNotSmallFoldProductFunc)().afterReturn(true);// 走display.getFoldStatus()
      let mockGetFoldStatusFunc: Function = mocker.mockFunc(display.getFoldStatus, display.getFoldStatus);
      when(mockGetFoldStatusFunc)().afterReturn(2);// 走FOLD_STATUS_FOLDED
      ThumbnailSizeUtil.getThumbnailSize(controller.getScene());
      expect(true).assertTrue();
      mocker.clear(mockIsPhoneFunc);
      mocker.clear(mockIsFoldButNotSmallFoldProductFunc);
      mocker.clear(mockGetFoldStatusFunc);
      mocker.clearAll();
    });

    it('test_getThumbnailSize_notFoldButNotSmallFoldProduct', 0, () => {
      const controller: MainPageController = new MainPageController();
      let mocker: MockKit = new MockKit();
      let mockIsPhoneFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockIsPhoneFunc)().afterReturn(true);// 走ThumbnailSizeUtil.getPhoneThumbnailSize(scene)
      let mockIsFoldButNotSmallFoldProductFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      when(mockIsFoldButNotSmallFoldProductFunc)().afterReturn(false);// 走else
      ThumbnailSizeUtil.getThumbnailSize(controller.getScene());
      expect(true).assertTrue();
      mocker.clear(mockIsPhoneFunc);
      mocker.clear(mockIsFoldButNotSmallFoldProductFunc);
      mocker.clearAll();
    });

    it('test_getThumbnailSize_notPhone', 0, () => {
      const controller: MainPageController = new MainPageController();
      let mocker: MockKit = new MockKit();
      let mockIsPhoneFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockIsPhoneFunc)().afterReturn(false);// 走ThumbnailSizeUtil.getDefaultPhoneThumbnailSize()
      ThumbnailSizeUtil.getThumbnailSize(controller.getScene());
      expect(true).assertTrue();
      mocker.clear(mockIsPhoneFunc);
      mocker.clearAll();
    });

    it('test_getThumbnailSize_catch', 0, () => {
      const controller: MainPageController = new MainPageController();
      let mocker: MockKit = new MockKit();
      let mockIsPhoneFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockIsPhoneFunc)().afterThrow('error');// 走catch,ThumbnailSizeUtil.getDefaultPhoneThumbnailSize()
      ThumbnailSizeUtil.getThumbnailSize(controller.getScene());
      expect(true).assertTrue();
      mocker.clear(mockIsPhoneFunc);
      mocker.clearAll();
    });

    it('ThumbnailSizeUtilTest_getPhoneThumbnailSize1', 0, () => {
      let mocker: MockKit = new MockKit();
      let phoneFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      when(phoneFunc)().afterReturn(false);
      let result: ComponentSize = (ThumbnailSizeUtil as object)['getPhoneThumbnailSize'](AodSceneType.SETTING)
      expect(result).not().assertNull();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('ThumbnailSizeUtilTest_getFoldPhoneThumbnailSize1', 0, () => {
      let result: ComponentSize = (ThumbnailSizeUtil as object)['getFoldPhoneThumbnailSize'](AodSceneType.SETTING)
      expect(result).not().assertUndefined();
    });

    it('ThumbnailSizeUtilTest_getFoldPhoneThumbnailSize2', 0, () => {
      let result: ComponentSize = (ThumbnailSizeUtil as object)['getFoldPhoneThumbnailSize'](AodSceneType.SCREEN_LOCK)
      expect(result).not().assertUndefined();
    });

    it('ThumbnailSizeUtilTest_getPadThumbnailSize1', 0, () => {
      let result: ComponentSize = (ThumbnailSizeUtil as object)['getPadThumbnailSize'](AodSceneType.SETTING)
      expect(result).not().assertUndefined();
    });

    it('ThumbnailSizeUtilTest_getPadThumbnailSize2', 0, () => {
      let result: ComponentSize = (ThumbnailSizeUtil as object)['getPadThumbnailSize'](AodSceneType.SCREEN_LOCK)
      expect(result).not().assertUndefined();
    });

    it('ThumbnailSizeUtilTest_calculateSmallWinThumbnailSize', 0, () => {
      let result: ComponentSize = (ThumbnailSizeUtil as object)['calculateSmallWinThumbnailSize'](1, 0);
      expect(result).not().assertUndefined();
    });

    it('ThumbnailSizeUtilTest_getSmallWinSize', 0, () => {
      let result: ComponentSize = (ThumbnailSizeUtil as object)['getSmallWinSize'](1);
      expect(result).not().assertUndefined();
    });

    it('ThumbnailSizeUtilTest_getSmallWinUnfoldSize', 0, () => {
      let result: ComponentSize = (ThumbnailSizeUtil as object)['getSmallWinUnfoldSize'](1);
      expect(result).not().assertUndefined();
    });

    it('ThumbnailSizeUtilTest_getSmallWinPadSize', 0, () => {
      let result: ComponentSize = (ThumbnailSizeUtil as object)['getSmallWinPadSize'](1);
      expect(result).not().assertUndefined();
    });

    it('ThumbnailSizeUtilTest_getSmallWinThumbnailSize1', 0, () => {
      let mocker: MockKit = new MockKit();
      let phoneFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(phoneFunc)().afterReturn(true);
      let phoneFunc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isSmallFoldProduct);
      when(phoneFunc1)().afterReturn(true);
      let result: ComponentSize = (ThumbnailSizeUtil as object)['getSmallWinThumbnailSize'](1);
      expect(result).not().assertNull();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('ThumbnailSizeUtilTest_getSmallWinThumbnailSize2', 0, () => {
      let mocker: MockKit = new MockKit();
      let phoneFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(phoneFunc)().afterReturn(true);
      let phoneFunc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isSmallFoldProduct);
      when(phoneFunc1)().afterReturn(false);
      let phoneFunc2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(phoneFunc2)().afterReturn(true);
      let phoneFunc3: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(phoneFunc3)().afterReturn(true);
      let result: ComponentSize = (ThumbnailSizeUtil as object)['getSmallWinThumbnailSize'](1);
      expect(result).not().assertNull();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('ThumbnailSizeUtilTest_getSmallWinThumbnailSize3', 0, () => {
      let mocker: MockKit = new MockKit();
      let phoneFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(phoneFunc)().afterReturn(true);
      let phoneFunc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isSmallFoldProduct);
      when(phoneFunc1)().afterReturn(false);
      let phoneFunc2: Function = mocker.mockFunc(AodUtil, AodUtil.isHalfFoldedStatus);
      when(phoneFunc2)().afterReturn(true);
      let result: ComponentSize = (ThumbnailSizeUtil as object)['getSmallWinThumbnailSize'](1);
      expect(result).not().assertNull();
      mocker.clear(DeviceHelper);
      mocker.clear(AodUtil);
      mocker.clearAll();
    });

    it('ThumbnailSizeUtilTest_getSmallWinThumbnailSize4', 0, () => {
      let mocker: MockKit = new MockKit();
      let phoneFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(phoneFunc)().afterReturn(true);
      let phoneFunc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isSmallFoldProduct);
      when(phoneFunc1)().afterReturn(false);
      let phoneFunc2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(phoneFunc2)().afterReturn(false);
      let phoneFunc3: Function = mocker.mockFunc(AodUtil, AodUtil.isHalfFoldedStatus);
      when(phoneFunc3)().afterReturn(false);
      let result: ComponentSize = (ThumbnailSizeUtil as object)['getSmallWinThumbnailSize'](1);
      expect(result).not().assertNull();
      mocker.clear(DeviceHelper);
      mocker.clear(AodUtil);
      mocker.clearAll();
    });

    it('ThumbnailSizeUtilTest_getSmallWinThumbnailSize5', 0, () => {
      let mocker: MockKit = new MockKit();
      let phoneFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(phoneFunc)().afterReturn(false);
      let phoneFunc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(phoneFunc1)().afterReturn(true);
      let result: ComponentSize = (ThumbnailSizeUtil as object)['getSmallWinThumbnailSize'](1);
      expect(result).not().assertNull();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('ThumbnailSizeUtilTest_getSmallWinThumbnailSize6', 0, () => {
      let mocker: MockKit = new MockKit();
      let phoneFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(phoneFunc)().afterReturn(false);
      let phoneFunc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(phoneFunc1)().afterReturn(false);
      let result: ComponentSize = (ThumbnailSizeUtil as object)['getSmallWinThumbnailSize'](1);
      expect(result).not().assertNull();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });
  })
}