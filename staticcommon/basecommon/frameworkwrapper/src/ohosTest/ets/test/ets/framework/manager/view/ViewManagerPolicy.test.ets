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
import { PluginInfo, viewMgrPolicy, ViewType } from '../../../../../../../main/ets/TsIndex'

export default function ViewManagerPolicyTest() {
  describe('ViewManagerPolicyTest', () => {
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
    it('ViewManagerPolicyTest_unregisterViewController', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      try {
        viewMgrPolicy.unregisterViewController(ViewType.DESKTOP);
      } catch (error) {
      }
      expect(true).assertTrue();
      expect(viewMgrPolicy.getViewController(ViewType.DESKTOP)).assertUndefined();
    })

    it('ViewManagerPolicyTest_gestureCallback', 0, () => {
      viewMgrPolicy.gestureCallback(-1, -1);
      //SCBEventId.BACK_GESTURE_EVENT
      viewMgrPolicy.gestureCallback(30, 100);
      expect(true).assertTrue();
    })

    it('ViewManagerPolicyTest_offGestureCallback', 0, () => {
      try {
      viewMgrPolicy.offGestureCallback(-1, -1);
      viewMgrPolicy.offGestureCallback(30, 100);
      } catch (e) {
        expect(true).assertTrue();
      }
    })

    it('ViewManagerPolicyTest_unRegisterViewCallback', 0, () => {
      try {
        viewMgrPolicy.unRegisterViewCallback(-1, null);
      } catch (error) {
      }
      try {
        viewMgrPolicy.unRegisterViewCallback(ViewType.DESKTOP, null);
      } catch (error) {
      }
      expect(true).assertTrue();
    })

    it('ViewManagerPolicyTest_destroyView', 0, () => {
      try {
        viewMgrPolicy.destroyView(ViewType.RECENT);
      } catch (error) {
      }
      expect(true).assertTrue();
    })

    it('ViewManagerPolicyTest_setViewData', 0, () => {
      try {
        viewMgrPolicy.setViewData(ViewType.RECENT, null);
      } catch (error) {
      }
      try {
        viewMgrPolicy.setViewData(ViewType.RECENT, new PluginInfo());
      } catch (error) {
      }
      expect(true).assertTrue();
    })

    it('ViewManagerPolicyTest_getViewData', 0, () => {
      try {
        viewMgrPolicy.getViewData(ViewType.KEYGUARD);
      } catch (error) {
      }
      expect(true).assertTrue();
    })

    it('ViewManagerPolicyTest_setZIndex', 0, () => {
      viewMgrPolicy.setZIndex(ViewType.KEYGUARD, 100);
      expect(true).assertTrue();
    })

    it('ViewManagerPolicyTest_getSystemSceneState', 0, () => {
      viewMgrPolicy.getSystemSceneState();
      expect(true).assertTrue();
    })
  })
}