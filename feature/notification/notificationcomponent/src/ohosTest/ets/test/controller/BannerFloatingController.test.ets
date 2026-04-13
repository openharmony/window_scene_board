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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { BannerFloatingController } from '../../../../main/ets/controller/BannerFloatingController'
import { ArgumentMatchers, MockKit, when } from '@ohos/hypium';
import { AccessibilityManager } from '@ohos/frameworkwrapper';

export default function BannerFloatingControllerTest() {
  describe('BannerFloatingControllerTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('banner_floating_test_support_floating', 0, () => {
      const banner = new BannerFloatingController();
      const floating = banner.isSupportFloating()
      expect(banner.canOpenFloating(true, false)).assertEqual(floating)
      expect(banner.canOpenFloating(false, true)).assertEqual(floating)
      expect(banner.canOpenFloating(true, true)).assertEqual(floating)
    })

    it('banner_floating_test_support_floating_01', 0, () => {
      const banner = new BannerFloatingController();
      let accessibilityManager = AccessibilityManager.getInstance();
      let mocker1: MockKit = new MockKit();
      let func1: Function =
        mocker1.mockFunc(accessibilityManager, accessibilityManager.getIsAccessibilityMode);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      expect(banner.isSupportFloating()).assertFalse();
      mocker1.clear(accessibilityManager);
    })
  })
}