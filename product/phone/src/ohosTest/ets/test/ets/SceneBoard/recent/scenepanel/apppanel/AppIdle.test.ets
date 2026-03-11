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
import { FSM, FSMEvent, SCBScenePanelManager, SCBScreenProperty } from '@ohos/windowscene';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  TestType,
  Size,
  Level,
  MockKit,
  when
} from '@ohos/hypium';

import { ScenePanelEvents } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/ScenePanelEvents';
import screenSessionManager from '@ohos.screenSessionManager';
import { AppIdle } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/apppanel/AppIdle';
import {
  QuickSwitchFollowingFromApp
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/apppanel/QuickSwitchFollowingFromApp';
import {
  ZoomFollowingFromApp
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/apppanel/ZoomFollowingFromApp';
import { ScenePanelStates } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/ScenePanelStates';

export default function AppIdleTest() {
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
  let appIdle: AppIdle = new AppIdle(scbScenePanelManager);
  let quickSwitchFollowingFromApp: QuickSwitchFollowingFromApp = new QuickSwitchFollowingFromApp(scbScenePanelManager);
  let zoomFollowingFromApp: ZoomFollowingFromApp = new ZoomFollowingFromApp(scbScenePanelManager);
  let eventArea: Area = {
    width: 0,
    height: 0,
    position: {
      x: 0, y: 0
    },
    globalPosition: {
      x: 0, y: 0
    }
  };

  let eventTarget: EventTarget = {
    area: eventArea
  };

  let event: GestureEvent = {
    target: eventTarget,
    timestamp: 0,
    source: 0,
    pressure: 0,
    tiltX: 0,
    tiltY: 0,
    sourceTool: 0,
    repeat: false,
    fingerList: [],
    offsetX: 10,
    offsetY: 5,
    angle: 0,
    speed: 0,
    scale: 0,
    pinchCenterX: 0,
    pinchCenterY: 0,
    velocityX: 0,
    velocityY: 0,
    velocity: 0
  };

  describe('AppIdleTest', () => {
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

    it('AppIdleTest_onEnter', Level.LEVEL0, (): void => {
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelStates.STATE_APP_IDLE);
      appIdle.onEnter(appIdle, fsmEvent);
      expect(appIdle).not().assertUndefined();
    })

    it('AppIdleTest_init_01', Level.LEVEL0, (): void => {

      let fsm = new FSM('testFSM');
      fsm.addState(appIdle).addState(quickSwitchFollowingFromApp).addState(zoomFollowingFromApp);
      fsm.currentState = appIdle;
      appIdle.attachToFsm(fsm);
      appIdle.init();
      appIdle.transfer(ScenePanelEvents.EVENT_GESTURE_START);
      appIdle.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(appIdle).not().assertUndefined();
    })

    it('AppIdleTest_init_02', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(appIdle).addState(quickSwitchFollowingFromApp).addState(zoomFollowingFromApp);
      fsm.currentState = appIdle;
      appIdle.attachToFsm(fsm);
      appIdle.init();
      event.offsetY = -10;
      appIdle.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(appIdle).not().assertUndefined();
    })

    it('AppIdleTest_init_03', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(appIdle).addState(quickSwitchFollowingFromApp).addState(zoomFollowingFromApp);
      fsm.currentState = appIdle;
      appIdle.attachToFsm(fsm);
      appIdle.init();
      event.offsetY = -10;
      appIdle.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(appIdle).not().assertUndefined();
    })

    it('AppIdleTest_init_06', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(appIdle).addState(quickSwitchFollowingFromApp).addState(zoomFollowingFromApp);
      fsm.currentState = appIdle;
      appIdle.attachToFsm(fsm);
      appIdle.init();
      appIdle.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(appIdle).not().assertUndefined();
    })

    it('AppIdleTest_onLeave', Level.LEVEL0, (): void => {
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelStates.STATE_APP_IDLE);
      appIdle.onLeave(appIdle, fsmEvent);
      expect(appIdle).not().assertUndefined();
    })
  })
}