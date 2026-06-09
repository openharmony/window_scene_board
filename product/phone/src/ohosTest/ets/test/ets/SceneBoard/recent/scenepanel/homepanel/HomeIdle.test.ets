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
import { HomeIdle } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/homepanel/HomeIdle';
import { ScenePanelEvents } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/ScenePanelEvents';
import {
  gestureHelperInstance
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/common/GestureHelper';
import screenSessionManager from '@ohos.screenSessionManager';
import {
  OverViewFollowingFromHome
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/homepanel/OverViewFollowingHome';

export default function HomeIdleTest() {
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
  let homeIdle: HomeIdle = new HomeIdle(scbScenePanelManager);
  let overViewFollowingFromHome: OverViewFollowingFromHome = new OverViewFollowingFromHome(scbScenePanelManager);
  let fsm = new FSM('testFSM');
  fsm.addState(homeIdle).addState(overViewFollowingFromHome);
  fsm.currentState = homeIdle;
  homeIdle.attachToFsm(fsm);

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


  homeIdle.callback = {
    name: 'HomeIdleCallback',
    gestureStart: () => {
    },
    onEnterOverView: () => {
    },
    enterHomeIdle: () => {
    },
    update: (offsetX: number, offsetY: number) => {
    }
  }


  describe('HomeIdleTest', () => {
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

    it('HomeIdleTest_onEnter', Level.LEVEL0, (): void => {
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE);
      homeIdle.onEnter(homeIdle, fsmEvent);
      expect(fsmEvent).not().assertNull();
    })

    it('HomeIdleTest_init_01_01', Level.LEVEL0, (): void => {
      //toQuickSwitchFollowing
      homeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(homeIdle).not().assertNull();
    })

    it('HomeIdleTest_init_01_02', Level.LEVEL0, (): void => {
      //toQuickSwitchFollowing GestureHelper.isRightForward(event)为false
      event.offsetX = -10;
      homeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(homeIdle).not().assertNull();
    })

    it('HomeIdleTest_init_01_03', Level.LEVEL0, (): void => {
      //toQuickSwitchFollowing Math.abs(event.offsetX) > Math.abs(event.offsetY) 为false
      event.offsetX = 1;
      event.offsetY = 1;
      homeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(homeIdle).not().assertNull();
    })

    it('HomeIdleTest_init_01_04', Level.LEVEL0, (): void => {
      //toQuickSwitchFollowing GestureHelper.isRightForward(event)为true
      event.offsetX = 10;
      homeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(homeIdle).not().assertNull();
    })

    it('HomeIdleTest_init_02', Level.LEVEL0, (): void => {
      homeIdle.callback = null;
      let fsm = new FSM('testFSM');
      fsm.addState(homeIdle).addState(overViewFollowingFromHome);
      fsm.currentState = homeIdle;
      homeIdle.attachToFsm(fsm);
      homeIdle.init();
      event.offsetX = 10;
      homeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(fsm).not().assertNull();
    })

    it('HomeIdleTest_init_03', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(homeIdle).addState(overViewFollowingFromHome);
      fsm.currentState = homeIdle;
      homeIdle.attachToFsm(fsm);
      homeIdle.init();
      //toRecentFollowing
      event.offsetX = -10;
      event.offsetY = -10;
      homeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      gestureHelperInstance.curSpeed = -1;
      homeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(fsm).not().assertNull();
    })

    it('HomeIdleTest_init_04', Level.LEVEL0, (): void => {
      homeIdle.callback = {
        name: 'HomeIdleCallback',
        gestureStart: () => {
        },
        onEnterOverView: () => {
        },
        enterHomeIdle: () => {
        },
        update: (offsetX: number, offsetY: number) => {
        }
      };
      let fsm = new FSM('testFSM');
      fsm.addState(homeIdle).addState(overViewFollowingFromHome);
      fsm.currentState = homeIdle;
      homeIdle.attachToFsm(fsm);
      homeIdle.init();
      //toRecentFollowing
      event.offsetX = -10;
      event.offsetY = -10;
      homeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(fsm).not().assertNull();
    })

    it('HomeIdleTest_init_04_01', Level.LEVEL0, (): void => {
      homeIdle.callback = null;
      let fsm = new FSM('testFSM');
      fsm.addState(homeIdle).addState(overViewFollowingFromHome);
      fsm.currentState = homeIdle;
      homeIdle.attachToFsm(fsm);
      homeIdle.init();
      //toRecentFollowing
      event.offsetX = -10;
      event.offsetY = -10;
      homeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(fsm).not().assertNull();
    })

    it('HomeIdleTest_init_05', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(homeIdle).addState(overViewFollowingFromHome);
      fsm.currentState = homeIdle;
      homeIdle.attachToFsm(fsm);
      homeIdle.init();
      //toSelfFollowingUpdate
      event.offsetY = -10;
      gestureHelperInstance.curSpeed = -1;
      homeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(fsm).not().assertNull();
    })

    it('HomeIdleTest_init_06', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(homeIdle).addState(overViewFollowingFromHome);
      fsm.currentState = homeIdle;
      homeIdle.attachToFsm(fsm);
      homeIdle.init();
      homeIdle.callback = {
        name: 'HomeIdleCallback',
        gestureStart: () => {
        },
        onEnterOverView: () => {
        },
        enterHomeIdle: () => {
        },
        update: (offsetX: number, offsetY: number) => {
        }
      };
      //toSelfIdleUpdate
      event.offsetY = -10;
      gestureHelperInstance.curSpeed = -1;
      homeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(fsm).not().assertNull();
    })

    it('HomeIdleTest_init_06_01', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(homeIdle).addState(overViewFollowingFromHome);
      fsm.currentState = homeIdle;
      homeIdle.attachToFsm(fsm);
      homeIdle.init();
      homeIdle.callback = null;
      //toSelfIdleUpdate
      event.offsetY = -10;
      gestureHelperInstance.curSpeed = -1;
      homeIdle.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(fsm).not().assertNull();
    })
  })
}