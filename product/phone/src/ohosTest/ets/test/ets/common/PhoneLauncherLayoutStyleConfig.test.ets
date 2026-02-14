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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium'
import PhoneLauncherLayoutStyleConfig from '@ohos/phonebase/src/main/ets/common/PhoneLauncherLayoutStyleConfig'
import { CommonConstants, LauncherLayoutStyleConfig } from '@ohos/launchercommon';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import PadPresetConstants from '@ohos/phonebase/src/main/ets/common/constants/PadPresetConstants';

export default function PhoneLauncherLayoutStyleConfigTest() {
  describe('PhoneLauncherLayoutStyleConfigTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    it('test_getInstance', 0, () => {
      globalThis.PhoneLauncherLayoutStyleConfigInstance = null;
      let instance: PhoneLauncherLayoutStyleConfig = PhoneLauncherLayoutStyleConfig.getInstance();
      expect(globalThis.PhoneLauncherLayoutStyleConfigInstance).assertEqual(instance);
      expect(instance).assertEqual(PhoneLauncherLayoutStyleConfig.getInstance());
    })

    it('test_getConfigLevel', 0, () => {
      globalThis.PhoneLauncherLayoutStyleConfigInstance = null;
      let instance: PhoneLauncherLayoutStyleConfig = PhoneLauncherLayoutStyleConfig.getInstance();
      expect(instance.getConfigLevel() === CommonConstants.LAYOUT_CONFIG_LEVEL_PRODUCT).assertTrue();
    })

    it('test_getFeatureName', 0, () => {
      globalThis.PhoneLauncherLayoutStyleConfigInstance = null;
      let instance: PhoneLauncherLayoutStyleConfig = PhoneLauncherLayoutStyleConfig.getInstance();
      expect(instance.getFeatureName() === LauncherLayoutStyleConfig.LAUNCHER_PRODUCT_STYLE_CONFIG).assertTrue();
    })

    it('test_mDockPadding_and_mDockIconSize_and_mDockMarginBottomHideBar', 0, () => {
      const mocker: MockKit = new MockKit();
      globalThis.PhoneLauncherLayoutStyleConfigInstance = null;
      const instance: PhoneLauncherLayoutStyleConfig = PhoneLauncherLayoutStyleConfig.getInstance();
      const isPad = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(isPad)().afterReturn(true);
      const isPhone = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(isPhone)().afterReturn(false);
      expect(instance.mDockPadding).not().assertNull();
      expect(instance.mDockIconSize).not().assertNull();
      expect(instance.mDockMarginBottomHideBar).not().assertNull();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

  })
}
