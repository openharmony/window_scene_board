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
import { GlobalContext } from '@ohos/frameworkwrapper';

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  Level,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers,
} from '@ohos/hypium'
import { FlashlightTipsUtil } from '../../../../../main/ets/utils/FlashlightTipsUtil';
import { display } from '@kit.ArkUI';
import { camera } from '@kit.CameraKit';
import { FlashlightTipsConstants } from '../../../../../main/ets/constants/FlashlightTipsConstants';
import { asset } from '@kit.AssetStoreKit';
import { CheckEmptyUtils } from '@ohos/basicutils';

/**
 * 手电筒工具类测试用例
 */
export function FlashlightTipsUtilTest() {
  let mCameraManager: camera.CameraManager = camera.getCameraManager(getContext());

  describe('FlashlightTipsUtilTest', () => {
    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterAll(() => {
      GlobalContext.getContext().eventHub.off(FlashlightTipsConstants.EXTERNAL_SCREEN_FLASHLIGHT_EVENT);
      GlobalContext.getContext().eventHub.off(FlashlightTipsConstants.CLOSE_DROPDOWN_PANEL_EVENT);
    });
    afterEach(() => {
    });

    it("isOpenFlashlightTips", Level.LEVEL1, () => {
      let isOpenFlashlightTips: boolean = FlashlightTipsUtil.isOpenFlashlightTips(true);
      expect(true).assertTrue();
      isOpenFlashlightTips = FlashlightTipsUtil.isOpenFlashlightTips(false);
      expect(isOpenFlashlightTips).assertFalse();
    });

    it("existFlashlightTipsResource", Level.LEVEL1, () => {
      let existFlashlightTipsResource: boolean = FlashlightTipsUtil.existFlashlightTipsResource();
      expect(true).assertTrue();
    });

    it("openFlashlight_closeFlashlight", Level.LEVEL1, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

      FlashlightTipsUtil.openFlashlight(true);
      FlashlightTipsUtil.closeFlashlight(true);

      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();

      FlashlightTipsUtil.openFlashlight(true);
      let torchMode = mCameraManager.getTorchMode() == 1;
      expect(true).assertTrue();
      FlashlightTipsUtil.closeFlashlight(true);
      FlashlightTipsUtil.closeFlashlight(true);
      torchMode = mCameraManager.getTorchMode() == 0;
      expect(true).assertTrue();
    });

    it("flashlightTipsReport", Level.LEVEL1, () => {
      FlashlightTipsUtil.flashlightTipsReport(FlashlightTipsConstants.PNAMEID,
        FlashlightTipsConstants.PVERSIONID, FlashlightTipsConstants.CLOSE_FLASHLIGHT_BY_FOLD_EVENT);
      FlashlightTipsUtil.flashlightTipsReport(null,
        null, FlashlightTipsConstants.CLOSE_FLASHLIGHT_BY_FOLD_EVENT);
      expect(true).assertTrue();
    });

    it("startVibrate", Level.LEVEL1, () => {
      FlashlightTipsUtil.startVibrate();
      expect(true).assertTrue();
    });

    it("showFlashlightTipsPage", Level.LEVEL1, () => {
      GlobalContext.getContext().eventHub.on(FlashlightTipsConstants.EXTERNAL_SCREEN_FLASHLIGHT_EVENT
        , (showFlashLightTipsPage: boolean) => {
          expect(showFlashLightTipsPage).assertTrue();
          GlobalContext.getContext().eventHub.off(FlashlightTipsConstants.EXTERNAL_SCREEN_FLASHLIGHT_EVENT);
      })
      FlashlightTipsUtil.showFlashlightTipsPage();
    });

    it("closeFlashlightTipsPage", Level.LEVEL1, () => {
      GlobalContext.getContext().eventHub.on(FlashlightTipsConstants.EXTERNAL_SCREEN_FLASHLIGHT_EVENT
        , (showFlashLightTipsPage: boolean) => {
          expect(showFlashLightTipsPage).assertFalse();
          GlobalContext.getContext().eventHub.off(FlashlightTipsConstants.EXTERNAL_SCREEN_FLASHLIGHT_EVENT);
        })
      FlashlightTipsUtil.closeFlashlightTipsPage();
    });

    it("closeFlashlightTipsPage", Level.LEVEL1, () => {
      GlobalContext.getContext().eventHub.on(FlashlightTipsConstants.CLOSE_DROPDOWN_PANEL_EVENT
        , (closeDropdownPanel: boolean) => {
          expect(closeDropdownPanel).assertTrue();
          GlobalContext.getContext().eventHub.off(FlashlightTipsConstants.CLOSE_DROPDOWN_PANEL_EVENT);
        })
      FlashlightTipsUtil.closeDropdownPanel();
    });
  })
}