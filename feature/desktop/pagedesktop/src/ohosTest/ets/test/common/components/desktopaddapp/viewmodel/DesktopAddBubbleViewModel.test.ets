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
import { AppIconContainerModifier, DeskTopItemStyle } from '@ohos/launchercommon/Index'
import {
  DesktopAddBubbleViewModel
} from '../../../../../../../main/ets/default/common/components/desktopaddapp/DesktopAddBubbleViewModel'

export default function DesktopAddBubbleViewModelTest() {
  describe('DesktopAddBubbleViewModelTest', () => {
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
    it('getInstance_01', 0, () => {
      let instance: DesktopAddBubbleViewModel = DesktopAddBubbleViewModel.getInstance();
      expect(instance).not().assertNull();
    });

    it('updateModifier_01', 0, () => {
      let instance: DesktopAddBubbleViewModel = DesktopAddBubbleViewModel.getInstance();
      let desktopStyle = new DeskTopItemStyle(0,0,0,0,false);
      let appIconContainerModifier: AppIconContainerModifier = new AppIconContainerModifier(
        () => instance.updateModifier(desktopStyle, appIconContainerModifier));
      instance.updateModifier(desktopStyle, appIconContainerModifier);
      expect(instance).not().assertNull();
    });

    it('getAddIconModifier_01', 0, () => {
      let instance: DesktopAddBubbleViewModel = DesktopAddBubbleViewModel.getInstance();
      let appItemWidth = 0;
      let modifier = instance.getAddIconModifier(appItemWidth);
      expect(modifier).not().assertNull();
    });

    it('getScale_01', 0, () => {
      let desktopAddBubbleViewModel = new DesktopAddBubbleViewModel();
      let desktopStyle = new DeskTopItemStyle(0,0,0,0,false);
      let scale: ScaleOptions = (desktopAddBubbleViewModel as object)['getScale'](desktopStyle);
      expect(scale).not().assertNull();
    });

    it('getScale_02', 0, () => {
      let desktopAddBubbleViewModel = new DesktopAddBubbleViewModel();
      let desktopStyle = new DeskTopItemStyle(2,2,2,2,false);
      let scale: ScaleOptions = (desktopAddBubbleViewModel as object)['getScale'](desktopStyle);
      expect(scale).not().assertNull();
    });

  })
}
