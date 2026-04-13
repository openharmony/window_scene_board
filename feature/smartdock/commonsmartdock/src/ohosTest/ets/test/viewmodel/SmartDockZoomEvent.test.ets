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
import { DockRegionLayoutModel } from '../../../../main/ets/default/model/DockRegionLayoutModel';
import { DockRegionType } from '../../../../main/ets/default/common/enum/SmartDockEnum';
import { SmartDockZoomEvent } from '../../../../main/ets/default/viewmodel/SmartDockZoomEvent';
import { SmartDockZoomAnimationConfig } from '../../../../main/ets/default/common/SmartDockZoomAnimationConfig';
import { SmartDockZoomAnimationManager } from '../../../../main/ets/default/viewmodel/SmartDockZoomAnimationManager';

export default function SmartDockZoomEventTest() {
  describe('SmartDockZoomEventTest', () => {
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

    it('test_onSmallFolderConvertToBig', 0, (): void => {
      let instance = SmartDockZoomEvent.getInstance();
      expect(instance.onSmallFolderConvertToBig(3)).assertTrue();
    })

    it('test_onRecentAppMove', 0, (): void => {
      let instance = SmartDockZoomEvent.getInstance();
      instance.onRecentAppMove(20);
      expect(SmartDockZoomAnimationManager.getInstance().animationList.length).assertLargerOrEqual(0);
      SmartDockZoomAnimationManager.getInstance().animationList = [];
    })

    it('test_onAppUninstall', 0, (): void => {
      let instance = SmartDockZoomEvent.getInstance();
      instance.onAppUninstall(20);
      expect(SmartDockZoomAnimationManager.getInstance().animationList.length).assertLargerOrEqual(0);
      SmartDockZoomAnimationManager.getInstance().animationList = [];
    })

    it('test_onDragSqueezing', 0, (): void => {
      let instance = SmartDockZoomEvent.getInstance();
      const residentLength = DockRegionLayoutModel.getInstance().getRegionLayoutLength(DockRegionType.RESIDENT);
      instance.onDragSqueezing(residentLength);
      instance.onDragSqueezing(1);
      instance.onDragSqueezing(11);
      expect(DockRegionLayoutModel.getInstance().getRegionLayoutLength(DockRegionType.RESIDENT)).assertEqual(11);
      instance.onDragSqueezing(residentLength);
    })

    it('test_onDockListChange', 0, (): void => {
      let instance = SmartDockZoomEvent.getInstance();
      instance.onDragSqueezing(4);
      instance.onConnectChange(0);
      instance.onRecentAppMove(4);
      instance.onAppUninstall(3);
      expect(DockRegionLayoutModel.getInstance().getRegionLayoutLength(DockRegionType.RESIDENT)).assertLargerOrEqual(3);
    })

    it('test_onPortraitStatusChange', 0, (): void => {
      let instance = SmartDockZoomEvent.getInstance();
      instance.onPortraitStatusChange();
      expect(instance.getMinZoomLimit()).assertLargerOrEqual(1);
    })
  })
}
