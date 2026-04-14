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
import { WindowConstants } from '@ohos/commonconstants';
import { WindowEvent } from '@ohos/frameworkwrapper';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { OccludedStateManager } from '../../../../../main/ets/manager/OccludedStateManager';

export default function OccludedStateManagerTest() {
  let occludedStateManager: OccludedStateManager = new OccludedStateManager();
  describe('OccludedStateManagerTest', () => {
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

    it('OccludedStateManager_getInstance', 0, () => {
      let result = OccludedStateManager.getInstance();
      expect(result).not().assertNull();
    });

    it('OccludedStateManager_isOccluded', 0, () => {
      (occludedStateManager as object)['_windowOccludedState'] = 0;
      (occludedStateManager as object)['_isDropdownShow'] = false;
      let result: boolean = occludedStateManager.isOccluded;
      expect(result).assertFalse();
    });

    it('OccludedStateManager_handleOccludedChange1', 0, () => {
      (occludedStateManager as object)['_windowOccludedState'] = 10;
      (occludedStateManager as object)['handleOccludedChange'](10);
      expect(occludedStateManager).not().assertUndefined();
    });

    it('OccludedStateManager_handleOccludedChange2', 0, () => {
      (occludedStateManager as object)['_windowOccludedState'] = 0;
      (occludedStateManager as object)['handleOccludedChange'](10);
      expect(occludedStateManager).not().assertUndefined();
    });

    it('OccludedStateManager_handleWindowEvent1', 0, () => {
      let windowEvent: WindowEvent = new WindowEvent();
      windowEvent.windowName = WindowConstants.WINDOW_NAME_LIVEVIEW;
      (occludedStateManager as object)['handleWindowEvent'](windowEvent);
      expect(occludedStateManager).not().assertUndefined();
    });

    it('OccludedStateManager_handleWindowEvent2', 0, () => {
      let windowEvent: WindowEvent = new WindowEvent();
      windowEvent.windowName = WindowConstants.WINDOW_NAME_DROPDOWN;
      windowEvent.eventType = WindowEvent.EVENT_TYPE_SHOW;
      (occludedStateManager as object)['handleWindowEvent'](windowEvent);
      expect(occludedStateManager).not().assertUndefined();
    });

    it('OccludedStateManager_handleWindowEvent3', 0, () => {
      let windowEvent: WindowEvent = new WindowEvent();
      windowEvent.windowName = WindowConstants.WINDOW_NAME_DROPDOWN;
      windowEvent.eventType = WindowEvent.EVENT_TYPE_HIDE;
      (occludedStateManager as object)['handleWindowEvent'](windowEvent);
      expect(occludedStateManager).not().assertUndefined();
    });

    it('OccludedStateManager_handleWindowEvent4', 0, () => {
      let windowEvent: WindowEvent = new WindowEvent();
      windowEvent.windowName = WindowConstants.WINDOW_NAME_DROPDOWN;
      windowEvent.eventType = WindowEvent.EVENT_STATE_END;
      (occludedStateManager as object)['handleWindowEvent'](windowEvent);
      expect(occludedStateManager).not().assertUndefined();
    });

  })
}