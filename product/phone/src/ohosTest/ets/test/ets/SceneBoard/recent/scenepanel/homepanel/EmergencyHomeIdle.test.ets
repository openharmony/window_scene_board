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
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import {
  EmergencyHomeIdle
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/homepanel/EmergencyHomeIdle';
import { ScenePanelEvents } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/ScenePanelEvents';
import {
  gestureHelperInstance
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/common/GestureHelper';
import { GestureHelper } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/common/GestureHelper';
import screenSessionManager from '@ohos.screenSessionManager';
import { HomeIdle } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/homepanel/HomeIdle';
import { RecentIdle } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentIdle';

export default function EmergencyHomeIdleTest() {
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
  let emergencyHomeIdle: EmergencyHomeIdle = new EmergencyHomeIdle(scbScenePanelManager);
  let recentIdle: RecentIdle = new RecentIdle(scbScenePanelManager);
  let homeIdle: HomeIdle = new HomeIdle(scbScenePanelManager)

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


  emergencyHomeIdle.callback = {
    name: 'EmergencyHomeIdleCallback',
    enterHomeIdle: (offsetX: number, offsetY: number) => {
    },
  };


  describe('EmergencyHomeIdleTest', () => {
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

    it('EmergencyHomeIdle_onEnter', Level.LEVEL0, (): void => {
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE);
      emergencyHomeIdle.onEnter(emergencyHomeIdle, fsmEvent, event);
      expect(fsmEvent).not().assertNull();
    })

    it('EmergencyHomeIdle_init_01', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(emergencyHomeIdle).addState(recentIdle).addState(homeIdle);
      fsm.currentState = emergencyHomeIdle;
      emergencyHomeIdle.attachToFsm(fsm);
      emergencyHomeIdle.init();
      emergencyHomeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_START);
      emergencyHomeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      //toHomeFollowing GestureHelper.isUpForward(event)为true
      event.offsetY = -10;
      emergencyHomeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(fsm).not().assertNull();
    })

    it('EmergencyHomeIdle_init_02', Level.LEVEL0, (): void => {
      event.offsetY = -0.000001;
      emergencyHomeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(emergencyHomeIdle).not().assertNull();
    })

    it('EmergencyHomeIdle_init_03', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(emergencyHomeIdle).addState(recentIdle).addState(homeIdle);
      fsm.currentState = emergencyHomeIdle;
      emergencyHomeIdle.attachToFsm(fsm);
      emergencyHomeIdle.callback = null;
      emergencyHomeIdle.init();
      expect(fsm).not().assertNull();
      event.offsetY = -0.000001;
      emergencyHomeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      event.offsetY = 10;
      emergencyHomeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('EmergencyHomeIdle_init_04', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(emergencyHomeIdle).addState(recentIdle).addState(homeIdle);
      fsm.currentState = emergencyHomeIdle;
      emergencyHomeIdle.attachToFsm(fsm);
      emergencyHomeIdle.callback = {
        name: 'EmergencyHomeIdleCallback',
        enterHomeIdle: (offsetX: number, offsetY: number) => {
        },
      };
      emergencyHomeIdle.init();
      expect(fsm).not().assertNull();
      event.offsetY = -0.000001;
      emergencyHomeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      event.offsetY = 10;
      emergencyHomeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('EmergencyHomeIdle_init_05', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(emergencyHomeIdle).addState(recentIdle).addState(homeIdle);
      fsm.currentState = emergencyHomeIdle;
      emergencyHomeIdle.attachToFsm(fsm);
      emergencyHomeIdle.callback = null;
      emergencyHomeIdle.init();
      expect(fsm).not().assertNull();
      event.offsetY = 10;
      emergencyHomeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('EmergencyHomeIdle_init_06', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(emergencyHomeIdle).addState(recentIdle).addState(homeIdle);
      fsm.currentState = emergencyHomeIdle;
      emergencyHomeIdle.attachToFsm(fsm);
      emergencyHomeIdle.callback = {
        name: 'EmergencyHomeIdleCallback',
        enterHomeIdle: (offsetX: number, offsetY: number) => {
        },
      };
      emergencyHomeIdle.init();
      expect(fsm).not().assertNull();
      event.offsetY = 10;
      emergencyHomeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('EmergencyHomeIdle_init_07', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(emergencyHomeIdle).addState(recentIdle).addState(homeIdle);
      fsm.currentState = emergencyHomeIdle;
      emergencyHomeIdle.attachToFsm(fsm);
      emergencyHomeIdle.init();
      emergencyHomeIdle.callback = null;
      expect(fsm).not().assertNull();
      event.offsetY = -10;
      gestureHelperInstance.startEvent = {
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
        offsetY: 10,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      gestureHelperInstance.curSpeed = 0.25;
      emergencyHomeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('EmergencyHomeIdle_init_08', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(emergencyHomeIdle).addState(recentIdle).addState(homeIdle);
      fsm.currentState = emergencyHomeIdle;
      emergencyHomeIdle.attachToFsm(fsm);
      emergencyHomeIdle.init();
      emergencyHomeIdle.callback = {
        name: 'EmergencyHomeIdleCallback',
        enterHomeIdle: (offsetX: number, offsetY: number) => {
        },
      };
      expect(fsm).not().assertNull();
      event.offsetY = -10;
      gestureHelperInstance.startEvent = {
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
        offsetY: 10,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      gestureHelperInstance.curSpeed = 0.25;
      emergencyHomeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('EmergencyHomeIdle_init_09', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(emergencyHomeIdle).addState(recentIdle).addState(homeIdle);
      fsm.currentState = emergencyHomeIdle;
      emergencyHomeIdle.attachToFsm(fsm);
      emergencyHomeIdle.init();
      emergencyHomeIdle.callback = {
        name: 'EmergencyHomeIdleCallback',
        enterHomeIdle: (offsetX: number, offsetY: number) => {
        },
      };
      expect(fsm).not().assertNull();
      event.offsetY = -10;
      gestureHelperInstance.startEvent = {
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
        offsetY: 10,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      gestureHelperInstance.curSpeed = 0.25;
      let mocker: MockKit = new MockKit();
      let isNearlyUpForward: Function = mocker.mockFunc(GestureHelper, GestureHelper.isNearlyUpForward);
      when(isNearlyUpForward)(ArgumentMatchers.any).afterReturn(false);
      emergencyHomeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      mocker.ignoreMock(GestureHelper, GestureHelper.isNearlyUpForward);
      expect(fsm).not().assertNull();
    })

    it('EmergencyHomeIdle_init_10', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(emergencyHomeIdle).addState(recentIdle).addState(homeIdle);
      fsm.currentState = emergencyHomeIdle;
      emergencyHomeIdle.attachToFsm(fsm);
      emergencyHomeIdle.init();
      emergencyHomeIdle.callback = {
        name: 'EmergencyHomeIdleCallback',
        enterHomeIdle: (offsetX: number, offsetY: number) => {
        },
      };
      expect(fsm).not().assertNull();
      event.offsetY = -10;
      gestureHelperInstance.startEvent = {
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
        offsetY: 10,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      gestureHelperInstance.curSpeed = 0.25;
      let mocker: MockKit = new MockKit();
      let isNearlyUpForward: Function = mocker.mockFunc(GestureHelper, GestureHelper.isNearlyUpForward);
      when(isNearlyUpForward)(ArgumentMatchers.any).afterReturn(true);
      emergencyHomeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      mocker.ignoreMock(GestureHelper, GestureHelper.isNearlyUpForward);
      expect(fsm).not().assertNull();
    })

    it('EmergencyHomeIdle_onLeave', Level.LEVEL0, (): void => {
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE);
      emergencyHomeIdle.onLeave(emergencyHomeIdle, fsmEvent);
      expect(fsmEvent).not().assertNull();
    })
  })
}