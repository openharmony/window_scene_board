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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { BaseBundleInfo } from '../../../../../../main/ets/bean/BaseBundleInfo';
import { CustomBadgeManager, SuperposeBadge } from '../../../../../../main/ets/TsIndex';

export default function CustomBadgeManagerTest() {
  let manager = CustomBadgeManager.getInstance();
  describe('CustomBadgeManagerTest', () => {
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
    it('CustomBadgeManager_test_getInstance', 0, () => {
      expect(CustomBadgeManager.getInstance()).assertEqual(manager);
      expect(CustomBadgeManager.getInstance()).assertEqual(manager);
    })
    it('test_setAppBadgeValue', 0, () => {
      let bundleInfo: BaseBundleInfo = { bundleName: 'testBundle', appIndex: 0 };
      const budgeValue = 10;
      CustomBadgeManager.getInstance().setAppBadgeValue(bundleInfo, budgeValue);
      expect(CustomBadgeManager.getInstance().getAppBadgeValue(bundleInfo)).assertEqual(budgeValue);
    })

    it('test_clearAppBadgeValue', 0, () => {
      let bundleInfo: BaseBundleInfo = { bundleName: 'testBundle', appIndex: 0 };
      const budgeValue = 10;
      manager.setAppBadgeValue(bundleInfo, budgeValue);
      manager.clearAppStarBadge(bundleInfo);
      expect(manager.getAppBadgeValue(bundleInfo)).assertEqual(0);

      manager['badgeInfo'].clear();
      manager.clearAppStarBadge(bundleInfo);
      expect(true).assertTrue();
    })
    it('test_setSuperposeBadge', 0, () => {
      const bundleName = "testBundle";
      const badgeNumber = 10;
      const iconSize = 40;
      const budgeValue: SuperposeBadge = {
        badgeNumber,
        iconSize
      };
      CustomBadgeManager.getInstance().setSuperposeBadge(bundleName, budgeValue);
      expect(CustomBadgeManager.getInstance().getSuperposeBadge(bundleName)).not().assertNull();

      expect(CustomBadgeManager.getInstance().getSuperposeBadge(bundleName).badgeNumber).assertEqual(badgeNumber);
      expect(CustomBadgeManager.getInstance().getSuperposeBadge(bundleName).iconSize).assertEqual(iconSize);
    })
    it('test_setSuperposeBadge1', 0, () => {
      CustomBadgeManager.getInstance().setSuperposeBadge(null, null);
      expect(true).assertTrue();
    })
    it('test_clearSuperposeBadge', 0, () => {
      const bundleName = "testBundle";
      const badgeNumber = 10;
      const iconSize = 40;
      const budgeValue: SuperposeBadge = {
        badgeNumber,
        iconSize
      };
      manager.setSuperposeBadge(bundleName, budgeValue);
      manager.clearSuperposeBadge(bundleName);
      expect(manager.getSuperposeBadge(bundleName)).assertNull();
    })
    it('test_clearSuperposeBadge1', 0, () => {
      const bundleName = "testBundle";
      CustomBadgeManager.getInstance()['superposeBadgeList'].clear();
      CustomBadgeManager.getInstance().clearSuperposeBadge(bundleName);
      expect(true).assertTrue();
    })
  })
}