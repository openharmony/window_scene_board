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
import AppGridLayoutCacheManager from '@ohos/appcenter/src/main/ets/default/common/cache/AppGridLayoutCacheManager'
import { AppCenterIconMenuVm } from '@ohos/appcenter/src/main/ets/default/vm/AppCenterIconMenuVm'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium'
import { AppItemInfo } from '@ohos/launchercommon'

export default function AppCenterIconMenuVmTest() {
  describe('AppCenterIconMenuVmTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('test_AppCenterIconMenuVmTest_getMenuTransition', Level.LEVEL0, (): void => {
      let instance: AppCenterIconMenuVm = new AppCenterIconMenuVm();
      instance.getMenuTransition(true);
      instance.getMenuTransition(false);
      expect(instance instanceof AppCenterIconMenuVm).assertTrue();
    })

    it('test_AppCenterIconMenuVmTest_getPlacement', Level.LEVEL0, (): void => {
      let instance: AppCenterIconMenuVm = new AppCenterIconMenuVm();
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.ohos.appgallery';
      appItemInfo.typeId = 0;
      appItemInfo.abilityName = 'MainAbility';
      appItemInfo.moduleName = 'entry';
      appItemInfo.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      appItemInfo.badgeNumber = 1;
      appItemInfo.area = [2,3];
      appItemInfo.appName = '应用市场';
      appItemInfo.appIconId = 67109115;
      appItemInfo.appLabelId = 67108895;
      appItemInfo.kindId = 0;
      appItemInfo.bundleType = 0;
      appItemInfo.applicationName = '';
      appItemInfo.appStatus = 0;
      appItemInfo.downloadProgress = 2;
      appItemInfo.iconResource = '2';
      appItemInfo.callerName = 'yyy';

      let mocker: MockKit = new MockKit();
      let appGridLayoutCacheManager: AppGridLayoutCacheManager = AppGridLayoutCacheManager.getInstance();
      let mockerFunc1 = mocker.mockFunc(appGridLayoutCacheManager, appGridLayoutCacheManager.lookForApp);
      when(mockerFunc1)().afterReturn(appItemInfo);
      instance.getMenuPlacement(true);
      appItemInfo.row = 1;
      when(mockerFunc1)().afterReturn(appItemInfo);
      instance.getMenuPlacement(true);
      appItemInfo.row = 3;
      when(mockerFunc1)().afterReturn(appItemInfo);
      instance.getMenuPlacement(true);
      instance.getMenuPlacement(false);
      expect(instance instanceof AppCenterIconMenuVm).assertTrue();
    })
  })
}