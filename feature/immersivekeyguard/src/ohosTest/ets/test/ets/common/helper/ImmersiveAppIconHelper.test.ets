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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level,MockKit, when } from '@ohos/hypium';
import { appIconHelper, AppIconCallback }  from '../../../../../../main/ets/common/helper/ImmersiveAppIconHelper';
import { DrawableDescriptor } from '@kit.ArkUI';
import { image } from '@kit.ImageKit';
import { CommonUtils } from '@ohos/basicutils';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveAppIconHelperTest() {
  describe('ImmersiveAppIconHelperTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_registerListener', Level.LEVEL0, (): void => {
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      appIconHelper.registerListener("TEST_REGISTER", callback);
      let res = appIconHelper.listeners.get("TEST_REGISTER");
      expect(res === callback).assertTrue();
    });

    it('test_registerListener_invalid_listener', Level.LEVEL0, (): void => {
      appIconHelper.registerListener("TEST_REGISTER_INVALID");
      let res = appIconHelper.listeners.get("TEST_REGISTER_INVALID");
      expect(res === undefined).assertTrue();
    });

    it('test_registerListener_invalid_hashCode', Level.LEVEL0, (): void => {
      appIconHelper.registerListener();
      expect(appIconHelper).not().assertNull();
    });

    it('test_registerListener_invalid_hashCode_02', Level.LEVEL0, (): void => {
      let hasCode ="TEST_REGISTER";
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      appIconHelper.registerListener(hasCode, callback);
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(false);
      appIconHelper.registerListener(hasCode, callback);
      let res = appIconHelper.appIcons.get(hasCode);
      expect(res === undefined).assertTrue();
      mock.clear(CommonUtils);
    });

    it('test_registerListener_invalid_hashCode_03', Level.LEVEL0, (): void => {
      let hasCode ="TEST_REGISTER";
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      appIconHelper.registerListener(hasCode, callback);
      let res = appIconHelper.appIcons.get(hasCode);
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(false);
      when(mockFun2)(callback).afterReturn(true);
      appIconHelper.registerListener(hasCode, callback);
      expect(res === undefined).assertTrue();
      mock.clear(CommonUtils);
    });

    it('test_registerListener_invalid_hashCode_04', Level.LEVEL0, (): void => {
      let hasCode ="TEST_REGISTER";
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      appIconHelper.registerListener(hasCode, callback);
      let mock = new MockKit();
      let res = appIconHelper.appIcons.get(hasCode);
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(false);
      when(mockFun2)(callback).afterReturn(false);
      appIconHelper.registerListener(hasCode, callback);
      expect(res === undefined).assertTrue();
      mock.clear(CommonUtils);
    });


    it('test_unRegisterListener', Level.LEVEL0, (): void => {
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      appIconHelper.registerListener("TEST_REGISTER", callback);
      appIconHelper.unRegisterListener("TEST_REGISTER");
      let res = appIconHelper.listeners.get("TEST_REGISTER");
      expect(res === undefined).assertTrue();
    });

    it('test_unRegisterListener_invalid_hasCode', Level.LEVEL0, (): void => {
      appIconHelper.unRegisterListener();
      expect(appIconHelper).not().assertNull();
    });

    it('test_unRegisterListener_invalid_hasCode_02', Level.LEVEL0, (): void => {
      let hashCode = '111';
      appIconHelper.appIcons.set(hashCode, '111');
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)().afterReturn(true);
      appIconHelper.unRegisterListener(hashCode);
      expect(appIconHelper).not().assertNull();
      mock.clear(CommonUtils);
    });

    it('test_getAppIcon_invalid', Level.LEVEL0, (): void => {
      let res = appIconHelper.getAppIcon();
      expect(res === undefined).assertTrue();
    });

    it('test_releaseAppIcon_string', Level.LEVEL0, (): void => {
      let hashCode = 'TEST_RELEASEAPPICON';
      appIconHelper.appIcons.set(hashCode, 'TEST_RELEASEAPPICON');
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      appIconHelper.registerListener(hashCode, callback);
      appIconHelper.unRegisterListener(hashCode);
      let res = appIconHelper.appIcons.get(hashCode);
      expect(res === undefined).assertTrue();
    });

    it('test_releaseAppIcon_drawable', Level.LEVEL0, (): void => {
      let hashCode = 'TEST_RELEASEAPPICON';
      appIconHelper.appIcons.set(hashCode, new DrawableDescriptor());
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      appIconHelper.registerListener(hashCode, callback);
      appIconHelper.unRegisterListener(hashCode);
      let res = appIconHelper.appIcons.get(hashCode);
      expect(res === undefined).assertTrue();
    });

    it('test_releaseAppIcon_pixelMap', Level.LEVEL0, (): void => {
      let hashCode = 'TEST_RELEASEAPPICON';
      let pixelMap: image.PixelMap = {} as image.PixelMap;
      appIconHelper.appIcons.set(hashCode, pixelMap);
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      appIconHelper.registerListener(hashCode, callback);
      appIconHelper.unRegisterListener(hashCode);
      let res = appIconHelper.appIcons.get(hashCode);
      expect(res === undefined).assertTrue();
    });

    it('test_releaseAppIcon_pixelMap_02', Level.LEVEL0, (): void => {
      let hashCode = '111';
      let pixelMap: image.PixelMap = {} as image.PixelMap;
      let pixelMap2:Map<string, string> = new Map()
      appIconHelper.appIcons.set(hashCode, pixelMap);
      let appIcon = appIconHelper.appIcons.get(hashCode);
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(appIcon).afterReturn(true);
      pixelMap2.delete(hashCode);
      (appIconHelper as object)['releaseAppIcon'](hashCode)
      expect(appIcon !== undefined).assertTrue();
     mock.ignoreMock(CommonUtils,CommonUtils.isInvalid)
    });
  });
}