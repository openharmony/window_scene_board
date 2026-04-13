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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium';
import { immersiveMultiDeviceHelper,
  MultiDeviceConst } from '../../../../../../main/ets/common/helper/ImmersiveMultiDeviceHelper';
import { DeviceHelper } from '@ohos/frameworkwrapper';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveMultiDeviceHelperTest() {
  let mocker: MockKit;
  describe('ImmersiveMultiDeviceHelperTest', (): void => {
    beforeAll((): void => {
      mocker = new MockKit();
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_getCapsuleWidthDisplay_invalid', Level.LEVEL0, (): void => {
      let res = immersiveMultiDeviceHelper.getCapsuleWidthDisplay(0);
      expect(res).not().assertNull();
    });

    it('test_getCapsuleWidthDisplay_fold_expend_1', Level.LEVEL0, (): void => {
      let mockfunc_1 = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      let mockfunc_2 = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockfunc_1)().afterReturn(true);
      when(mockfunc_2)().afterReturn(true);
      let testDisplay = 1080;
      let res = immersiveMultiDeviceHelper.getCapsuleWidthDisplay(testDisplay);
      mocker.clear(DeviceHelper);
      expect(res).not().assertNull();
    });

    it('test_getCapsuleWidthDisplay_fold_expend_2', Level.LEVEL0, (): void => {
      let mockfunc_1 = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      let mockfunc_2 = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockfunc_1)().afterReturn(true);
      when(mockfunc_2)().afterReturn(false);
      let testDisplay = 1080;
      let res = immersiveMultiDeviceHelper.getCapsuleWidthDisplay(testDisplay);
      mocker.clear(DeviceHelper);
      expect(res).not().assertNull();
    });

    it('test_getCapsuleWidthDisplay_pad_1', Level.LEVEL0, (): void => {
      let mockfunc_1 = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      let mockfunc_2 = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      let mockfunc_3 = mocker.mockFunc(DeviceHelper, DeviceHelper.getOrientation);

      when(mockfunc_1)().afterReturn(false);
      when(mockfunc_2)().afterReturn(true);
      when(mockfunc_3)().afterReturn(MultiDeviceConst.DEVICE_PORTRAIT_STATE);
      let testDisplay = 1080;
      let res = immersiveMultiDeviceHelper.getCapsuleWidthDisplay(testDisplay);
      mocker.clear(DeviceHelper);
      expect(res).not().assertNull();
    });

    it('test_getCapsuleWidthDisplay_pad_2', Level.LEVEL0, (): void => {
      let mockfunc_1 = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      let mockfunc_2 = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      let mockfunc_3 = mocker.mockFunc(DeviceHelper, DeviceHelper.getOrientation);

      when(mockfunc_1)().afterReturn(false);
      when(mockfunc_2)().afterReturn(true);
      when(mockfunc_3)().afterReturn(MultiDeviceConst.DEVICE_LANDSCAPE_STATE);
      let testDisplay = 1080;
      let res = immersiveMultiDeviceHelper.getCapsuleWidthDisplay(testDisplay);
      mocker.clear(DeviceHelper);
      expect(res).not().assertNull();
    });

    it('test_getCapsuleWidthDisplay_pad_3', Level.LEVEL0, (): void => {
      let mockfunc_1 = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      let mockfunc_2 = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      let mockfunc_3 = mocker.mockFunc(DeviceHelper, DeviceHelper.getOrientation);

      when(mockfunc_1)().afterReturn(false);
      when(mockfunc_2)().afterReturn(true);
      when(mockfunc_3)().afterReturn(-1);
      let testDisplay = 1080;
      let res = immersiveMultiDeviceHelper.getCapsuleWidthDisplay(testDisplay);
      mocker.clear(DeviceHelper);
      expect(res).not().assertNull();
    });

    it('test_getCapsuleWidthDisplay_default', Level.LEVEL0, (): void => {
      let mockfunc_1 = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      let mockfunc_2 = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockfunc_1)().afterReturn(false);
      when(mockfunc_2)().afterReturn(false);
      let testDisplay = 2200;
      let res = immersiveMultiDeviceHelper.getCapsuleWidthDisplay(testDisplay);
      mocker.clear(DeviceHelper);
      expect(res).assertEqual(px2vp(testDisplay) - MultiDeviceConst.DEFAULT_EDGE);
    });

    it('test_getCapsuleBtnCount_01', Level.LEVEL0, (): void => {
      let mockfunc_1 = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockfunc_1)().afterReturn(true);
      let res = immersiveMultiDeviceHelper.getCapsuleBtnCount();
      mocker.clear(DeviceHelper);
      expect(res).not().assertNull();
    });

    it('test_getCapsuleBtnCount_02', Level.LEVEL0, (): void => {
      let mockfunc_1 = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      let mockfunc_2 = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockfunc_1)().afterReturn(false);
      when(mockfunc_2)().afterReturn(true);
      let res = immersiveMultiDeviceHelper.getCapsuleBtnCount();
      mocker.clear(DeviceHelper);
      expect(res).not().assertNull();
    });

    it('test_getCapsuleBtnCount_03', Level.LEVEL0, (): void => {
      let mockfunc_1 = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      let mockfunc_2 = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockfunc_1)().afterReturn(false);
      when(mockfunc_2)().afterReturn(false);
      let res = immersiveMultiDeviceHelper.getCapsuleBtnCount();
      mocker.clear(DeviceHelper);
      expect(res).not().assertNull();
    });

    it('test_isLandscape_01', Level.LEVEL0, (): void => {
      let mockfunc_1 = mocker.mockFunc(DeviceHelper, DeviceHelper.getOrientation);
      when(mockfunc_1)().afterReturn(MultiDeviceConst.DEVICE_LANDSCAPE_STATE );
      let res = immersiveMultiDeviceHelper.isLandscape();
      mocker.clear(DeviceHelper);
      expect(res).not().assertNull();
    });

    it('test_isLandscape_02', Level.LEVEL0, (): void => {
      let mockfunc_1 = mocker.mockFunc(DeviceHelper, DeviceHelper.getOrientation);
      when(mockfunc_1)().afterReturn(MultiDeviceConst.DEVICE_LANDSCAPE_REVERSE_STATE );
      let res = immersiveMultiDeviceHelper.isLandscape();
      mocker.clear(DeviceHelper);
      expect(res).not().assertNull();
    });

    it('test_getCardWidthDisplay_01', Level.LEVEL0, (): void => {
      let res = immersiveMultiDeviceHelper.getCardWidthDisplay(0);
      expect(res).not().assertNull();
    });

    it('test_getCardWidthDisplay_02', Level.LEVEL0, (): void => {
      let mockfunc_1 = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockfunc_1)().afterReturn(true);
      let displaySize = 1080;
      let res = immersiveMultiDeviceHelper.getCardWidthDisplay(displaySize);
      mocker.clear(DeviceHelper);
      expect(res).not().assertNull();
    });

    it('test_getCardWidthDisplay_03', Level.LEVEL0, (): void => {
      let mocker = new MockKit();
      let mockfunc_1 = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      let mockfunc_2 = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockfunc_1)().afterReturn(false);
      when(mockfunc_2)().afterReturn(true);
      let displaySize = 1080;
      let res = immersiveMultiDeviceHelper.getCardWidthDisplay(displaySize);
      mocker.clear(DeviceHelper);
      expect(res).not().assertNull();
    });

    it('test_getCardWidthDisplay_04', Level.LEVEL0, (): void => {
      let mocker = new MockKit();
      let mockfunc_1 = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      let mockfunc_2 = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockfunc_1)().afterReturn(false);
      when(mockfunc_2)().afterReturn(false);
      let displaySize = 1080;
      let res = immersiveMultiDeviceHelper.getCardWidthDisplay(displaySize);
      mocker.clear(DeviceHelper);
      expect(res).not().assertNull();
    });

    it('test_getCardHeightDisplay_01', Level.LEVEL0, (): void => {
      let width = 0;
      let height = 0;
      let res = immersiveMultiDeviceHelper.getCardHeightDisplay(width, height);
      expect(res).not().assertNull();
    });

    it('test_getCardHeightDisplay_02', Level.LEVEL0, (): void => {
      let mocker = new MockKit();
      let mockfunc_1 = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      let mockfunc_2 = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockfunc_1)().afterReturn(true);
      when(mockfunc_2)().afterReturn(false);
      let width = 1080;
      let height = 1886;
      let res = immersiveMultiDeviceHelper.getCardHeightDisplay(width, height);
      mocker.clear(DeviceHelper);
      expect(res).not().assertNull();
    });

    it('test_getCardHeightDisplay_03', Level.LEVEL0, (): void => {
      let mocker = new MockKit();
      let mockfunc_1 = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      let mockfunc_2 = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockfunc_1)().afterReturn(true);
      when(mockfunc_2)().afterReturn(true);
      let width = 1080;
      let height = 1886;
      let res = immersiveMultiDeviceHelper.getCardHeightDisplay(width, height);
      mocker.clear(DeviceHelper);
      expect(res).not().assertNull();
    });

    it('test_getCardHeightDisplay_04', Level.LEVEL0, (): void => {
      let mocker = new MockKit();
      let mockfunc_1 = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      let mockfunc_2 = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockfunc_1)().afterReturn(false);
      when(mockfunc_2)().afterReturn(false);
      let width = 1080;
      let height = 1886;
      let res = immersiveMultiDeviceHelper.getCardHeightDisplay(width, height);
      mocker.clear(DeviceHelper);
      expect(res).not().assertNull();
    });

    it('test_getCardHeightDisplay_05', Level.LEVEL0, (): void => {
      let mocker = new MockKit();
      let mockfunc_1 = mocker.mockFunc(DeviceHelper, DeviceHelper.isLandscape);
      let mockfunc_2 = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockfunc_1)().afterReturn(false);
      when(mockfunc_2)().afterReturn(true);
      let width = 1080;
      let height = 1886;
      let res = immersiveMultiDeviceHelper.getCardHeightDisplay(width, height);
      mocker.clear(DeviceHelper);
      expect(res).not().assertNull();
    });

    it('test_getFoldCapsuleWidth', Level.LEVEL0, (): void => {
      let mockfunc_1 = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockfunc_1)().afterReturn(true);
      (immersiveMultiDeviceHelper as object)['getFoldCapsuleWidth'](10);
      when(mockfunc_1)().afterReturn(false);
      (immersiveMultiDeviceHelper as object)['getFoldCapsuleWidth'](2010);
      (immersiveMultiDeviceHelper as object)['getFoldCapsuleWidth'](1010);
      expect(immersiveMultiDeviceHelper).not().assertNull();
      mocker.clear(DeviceHelper);
    });

    it('test_getPadCapsuleWidth', Level.LEVEL0, (): void => {
      let mockfunc_1 = mocker.mockFunc(DeviceHelper, DeviceHelper.getOrientation);
      when(mockfunc_1)().afterReturn(MultiDeviceConst.DEVICE_PORTRAIT_STATE);
      (immersiveMultiDeviceHelper as object)['getPadCapsuleWidth'](10);
      when(mockfunc_1)().afterReturn(MultiDeviceConst.DEVICE_PORTRAIT_REVERSE_STATE);
      (immersiveMultiDeviceHelper as object)['getPadCapsuleWidth'](10);
      when(mockfunc_1)().afterReturn(MultiDeviceConst.DEVICE_LANDSCAPE_STATE);
      (immersiveMultiDeviceHelper as object)['getPadCapsuleWidth'](10);
      when(mockfunc_1)().afterReturn(MultiDeviceConst.DEVICE_LANDSCAPE_REVERSE_STATE);
      (immersiveMultiDeviceHelper as object)['getPadCapsuleWidth'](10);
      when(mockfunc_1)().afterReturn(MultiDeviceConst.PAD_LANDSCAPE_CAPSULE_WIDTH_PERCENTAGE);
      (immersiveMultiDeviceHelper as object)['getPadCapsuleWidth'](10);
      expect(immersiveMultiDeviceHelper).not().assertNull();
      mocker.clear(DeviceHelper);
    });

    it('test_getCapsuleBtnCount_04', Level.LEVEL0, (): void => {
      let mockfunc_1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFullDisplayMode);
      when(mockfunc_1)().afterReturn(true);
      let res = immersiveMultiDeviceHelper.getCapsuleBtnCount();
      expect(res).not().assertNull();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isFullDisplayMode)
    });
  });
}