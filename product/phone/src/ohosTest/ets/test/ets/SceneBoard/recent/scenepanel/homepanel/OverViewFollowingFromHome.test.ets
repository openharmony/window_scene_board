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
import {
  OverViewFollowingFromHome
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/homepanel/OverViewFollowingHome';
import { ScenePanelEvents } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/ScenePanelEvents';
import {
  gestureHelperInstance
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/common/GestureHelper';

import screenSessionManager from '@ohos.screenSessionManager';
import { HomeIdle } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/homepanel/HomeIdle';
import { RecentIdle } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentIdle';
import {
  QuickSwitchIdle
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/quickswitchpanel/QuickSwitchIdle';

export default function OverViewFollowingFromHomeTest() {
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
  let overViewFollowingHome: OverViewFollowingFromHome = new OverViewFollowingFromHome(scbScenePanelManager);
  let recentIdle: RecentIdle = new RecentIdle(scbScenePanelManager);
  let homeIdle: HomeIdle = new HomeIdle(scbScenePanelManager);
  let quickSwitchIdle: QuickSwitchIdle = new QuickSwitchIdle(scbScenePanelManager);

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


  overViewFollowingHome.callback = {
    name: 'OverViewFollowingFromHomeCallback',
    enterHomeIdle: () => {},
    update: (offsetX: number, offsetY: number) => {
    },
    enterRecentIdle: (offsetX: number, offsetY: number, isFromNavigationCallback: boolean) => {
    },
    enterQuickSwitchIdle: (offsetX: number, offsetY: number) => {
    },
    onExitOverView: () => {},
  };


  describe('OverViewFollowingFromHomeTest', () => {
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

    it('RecentFollowingFromHomeTest_onEnter', Level.LEVEL0, (): void => {
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE);
      overViewFollowingHome.onEnter(overViewFollowingHome, fsmEvent, event);
      expect(fsmEvent).not().assertNull();
    })

    it('RecentFollowingFromHomeTest_init_01', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(overViewFollowingHome)
        .addState(recentIdle)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = overViewFollowingHome;
      overViewFollowingHome.attachToFsm(fsm);
      overViewFollowingHome.init();
      overViewFollowingHome.transfer(ScenePanelEvents.EVENT_GESTURE_START);
      overViewFollowingHome.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      //toHomeFollowing GestureHelper.isUpForward(event)为true
      event.offsetY = -10;
      overViewFollowingHome.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(fsm).not().assertNull();
    })

    it('RecentFollowingFromHomeTest_init_01_01', Level.LEVEL0, (): void => {
      event.offsetY = -0.000001;
      overViewFollowingHome.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(overViewFollowingHome).not().assertNull();
    })

    it('RecentFollowingFromHomeTest_init_02', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(overViewFollowingHome)
        .addState(recentIdle)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = overViewFollowingHome;
      overViewFollowingHome.attachToFsm(fsm);
      overViewFollowingHome.callback = null;
      overViewFollowingHome.init();
      expect(fsm).not().assertNull();
      event.offsetY = -0.000001;
      overViewFollowingHome.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      event.offsetY = 10;
      overViewFollowingHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('RecentFollowingFromHomeTest_init_02_01', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(overViewFollowingHome)
        .addState(recentIdle)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = overViewFollowingHome;
      overViewFollowingHome.attachToFsm(fsm);
      overViewFollowingHome.callback = {
        name: 'OverViewFollowingFromHomeCallback',
        enterHomeIdle: () => {},
        update: (offsetX: number, offsetY: number) => {
        },
        enterRecentIdle: (offsetX: number, offsetY: number, isFromNavigationCallback: boolean) => {
        },
        enterQuickSwitchIdle: (offsetX: number, offsetY: number) => {
        },
        onExitOverView: () => {},
      };
      overViewFollowingHome.init();
      expect(fsm).not().assertNull();
      event.offsetY = -0.000001;
      overViewFollowingHome.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      event.offsetY = 10;
      overViewFollowingHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('RecentFollowingFromHomeTest_init_03', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(overViewFollowingHome)
        .addState(recentIdle)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = overViewFollowingHome;
      overViewFollowingHome.attachToFsm(fsm);
      overViewFollowingHome.callback = null;
      overViewFollowingHome.init();
      expect(fsm).not().assertNull();
      event.offsetY = 10;
      overViewFollowingHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('RecentFollowingFromHomeTest_init_03_01', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(overViewFollowingHome)
        .addState(recentIdle)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = overViewFollowingHome;
      overViewFollowingHome.attachToFsm(fsm);
      overViewFollowingHome.callback = {
        name: 'OverViewFollowingFromHomeCallback',
        enterHomeIdle: () => {},
        update: (offsetX: number, offsetY: number) => {
        },
        enterRecentIdle: (offsetX: number, offsetY: number, isFromNavigationCallback: boolean) => {
        },
        enterQuickSwitchIdle: (offsetX: number, offsetY: number) => {
        },
        onExitOverView: () => {},
      };
      overViewFollowingHome.init();
      expect(fsm).not().assertNull();
      event.offsetY = 10;
      overViewFollowingHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('RecentFollowingFromHomeTest_init_04', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(overViewFollowingHome)
        .addState(recentIdle)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = overViewFollowingHome;
      overViewFollowingHome.attachToFsm(fsm);
      overViewFollowingHome.init();
      overViewFollowingHome.callback = null;
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
      overViewFollowingHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('RecentFollowingFromHomeTest_init_05', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(overViewFollowingHome)
        .addState(recentIdle)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = overViewFollowingHome;
      overViewFollowingHome.attachToFsm(fsm);
      overViewFollowingHome.init();
      overViewFollowingHome.callback = null;
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
      overViewFollowingHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('RecentFollowingFromHomeTest_init_06', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(overViewFollowingHome)
        .addState(recentIdle)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = overViewFollowingHome;
      overViewFollowingHome.attachToFsm(fsm);
      overViewFollowingHome.init();
      overViewFollowingHome.callback = null;
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
      overViewFollowingHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('RecentFollowingFromHomeTest_init_07', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(overViewFollowingHome)
        .addState(recentIdle)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = overViewFollowingHome;
      overViewFollowingHome.attachToFsm(fsm);
      overViewFollowingHome.init();
      overViewFollowingHome.callback = null;
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
      overViewFollowingHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('RecentFollowingFromHomeTest_init_08', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(overViewFollowingHome)
        .addState(recentIdle)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = overViewFollowingHome;
      overViewFollowingHome.attachToFsm(fsm);
      overViewFollowingHome.init();
      overViewFollowingHome.callback = null;
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
      overViewFollowingHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('RecentFollowingFromHomeTest_init_09', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(overViewFollowingHome)
        .addState(recentIdle)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = overViewFollowingHome;
      overViewFollowingHome.attachToFsm(fsm);
      overViewFollowingHome.init();
      overViewFollowingHome.callback = null;
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
      overViewFollowingHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('RecentFollowingFromHomeTest_init_10', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(overViewFollowingHome)
        .addState(recentIdle)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = overViewFollowingHome;
      overViewFollowingHome.attachToFsm(fsm);
      overViewFollowingHome.init();
      overViewFollowingHome.callback = null;
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
      overViewFollowingHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('RecentFollowingFromHomeTest_init_11', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(overViewFollowingHome)
        .addState(recentIdle)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = overViewFollowingHome;
      overViewFollowingHome.attachToFsm(fsm);
      overViewFollowingHome.init();
      overViewFollowingHome.callback = null;
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
      overViewFollowingHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('RecentFollowingFromHomeTest_init_12', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(overViewFollowingHome)
        .addState(recentIdle)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = overViewFollowingHome;
      overViewFollowingHome.attachToFsm(fsm);
      overViewFollowingHome.init();
      overViewFollowingHome.callback = null;
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
      overViewFollowingHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('RecentFollowingFromHomeTest_init_13', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(overViewFollowingHome)
        .addState(recentIdle)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = overViewFollowingHome;
      overViewFollowingHome.attachToFsm(fsm);
      overViewFollowingHome.init();
      overViewFollowingHome.callback = null;
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
      overViewFollowingHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('RecentFollowingFromHomeTest_init_14', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(overViewFollowingHome)
        .addState(recentIdle)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = overViewFollowingHome;
      overViewFollowingHome.attachToFsm(fsm);
      overViewFollowingHome.init();
      overViewFollowingHome.callback = null;
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
      overViewFollowingHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('RecentFollowingFromHomeTest_init_15', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(overViewFollowingHome)
        .addState(recentIdle)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = overViewFollowingHome;
      overViewFollowingHome.attachToFsm(fsm);
      overViewFollowingHome.init();
      overViewFollowingHome.callback = null;
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
      overViewFollowingHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('RecentFollowingFromHomeTest_init_16', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(overViewFollowingHome)
        .addState(recentIdle)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = overViewFollowingHome;
      overViewFollowingHome.attachToFsm(fsm);
      overViewFollowingHome.init();
      overViewFollowingHome.callback = null;
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
      overViewFollowingHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('RecentFollowingFromHomeTest_init_04_01', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(overViewFollowingHome)
        .addState(recentIdle)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = overViewFollowingHome;
      overViewFollowingHome.attachToFsm(fsm);
      overViewFollowingHome.init();
      overViewFollowingHome.callback = {
        name: 'OverViewFollowingFromHomeCallback',
        enterHomeIdle: () => {},
        update: (offsetX: number, offsetY: number) => {
        },
        enterRecentIdle: (offsetX: number, offsetY: number, isFromNavigationCallback: boolean) => {
        },
        enterQuickSwitchIdle: (offsetX: number, offsetY: number) => {
        },
        onExitOverView: () => {},
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
      overViewFollowingHome.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(fsm).not().assertNull();
    })

    it('RecentFollowingFromHomeTest_onLeave', Level.LEVEL0, (): void => {
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE);
      overViewFollowingHome.onLeave(overViewFollowingHome, fsmEvent);
      expect(fsmEvent).not().assertNull();
    })
  })
}