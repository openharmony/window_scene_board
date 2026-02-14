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
import {
  FSM, FSMEvent, SCBScenePanelManager,
  SCBScreenProperty
} from '@ohos/windowscene';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  Level,
} from '@ohos/hypium';
import screenSessionManager from '@ohos.screenSessionManager';
import {
  QuickSwitchIdle
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/quickswitchpanel/QuickSwitchIdle';
import { ScenePanelEvents } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/ScenePanelEvents';

export default function QuickSwitchIdleTest() {
  let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
  let screenProp: screenSessionManager.ScreenProperty = {
    rotation: 1,
    bounds: {
      left: 1,
      top: 1,
      width: 1,
      height: 1,
      radius: 1,
    },
    fakeBounds: {
      left: 0,
      top: 0,
      width: 0,
      height: 0,
      radius: 0
    },
    isFakeInUse: false,
    rsId: 0,
  };
  scbScreenProperty.update(screenProp);
  let scbScenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
  let quickSwitchIdle: QuickSwitchIdle = new QuickSwitchIdle(scbScenePanelManager);




  describe('QuickSwitchIdleTest', () => {
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
    it('QuickSwitchIdleTest_onEnter', Level.LEVEL0, (): void => {
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE);
      quickSwitchIdle.onEnter(quickSwitchIdle, fsmEvent);
      expect(fsmEvent).not().assertNull();
    })

    it('QuickSwitchIdleTest_onLeave', Level.LEVEL0, (): void => {
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE);
      quickSwitchIdle.onLeave(quickSwitchIdle, fsmEvent);
      expect(fsmEvent).not().assertNull();
    })
  })
}