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

import { ScenePanelEvents } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/ScenePanelEvents';
import screenSessionManager from '@ohos.screenSessionManager';
import { AppIdle } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/apppanel/AppIdle';
import {
  QuickSwitchFollowingFromApp
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/apppanel/QuickSwitchFollowingFromApp';
import {
  ZoomFollowingFromApp
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/apppanel/ZoomFollowingFromApp';
import {
  FarAwayFollowingFromApp
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/apppanel/FarAwayFollowingFromApp';
import {
  RecentFollowingFromApp
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/apppanel/RecentFollowingFromApp';
import { HomeIdle } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/homepanel/HomeIdle';
import {
  QuickSwitchIdle
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/quickswitchpanel/QuickSwitchIdle';
import {
  GestureHelper,
  gestureHelperInstance
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/common/GestureHelper';
import { RecentIdle } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentIdle';
import { oneStepStateManagerInstance } from '@ohos/gesturenavigation/src/main/ets/constants/CommonConstants';
import { DockUtils } from '@ohos/launchercommon/src/main/ets/TsIndex';

export default function RecentFollowingFromAppTest() {
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
  let quickSwitchFollowingFromApp: QuickSwitchFollowingFromApp = new QuickSwitchFollowingFromApp(scbScenePanelManager);
  let appIdle: AppIdle = new AppIdle(scbScenePanelManager);
  let farAwayFollowingFromApp: FarAwayFollowingFromApp = new FarAwayFollowingFromApp(scbScenePanelManager);
  let recentFollowingFromApp: RecentFollowingFromApp = new RecentFollowingFromApp(scbScenePanelManager);
  let homeIdle: HomeIdle = new HomeIdle(scbScenePanelManager);
  let quickSwitchIdle: QuickSwitchIdle = new QuickSwitchIdle(scbScenePanelManager);
  let zoomFollowingFromApp: ZoomFollowingFromApp = new ZoomFollowingFromApp(scbScenePanelManager);
  let recentIdle: RecentIdle = new RecentIdle(scbScenePanelManager);

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
    offsetX: 0,
    offsetY: 0,
    angle: 0,
    speed: 0,
    scale: 0,
    pinchCenterX: 0,
    pinchCenterY: 0,
    velocityX: 0,
    velocityY: 0,
    velocity: 0
  };

  describe('RecentFollowingFromAppTest', () => {
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


    it('RecentFollowingFromAppTest_init_01', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentFollowingFromApp)
        .addState(quickSwitchFollowingFromApp)
        .addState(appIdle)
        .addState(farAwayFollowingFromApp)
        .addState(homeIdle)
        .addState(quickSwitchIdle)
        .addState(zoomFollowingFromApp)
        .addState(recentIdle);
      fsm.currentState = recentFollowingFromApp;
      recentFollowingFromApp.attachToFsm(fsm);
      recentFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isSupportFullDock = mocker.mockFunc(DockUtils, DockUtils.isSupportFullDock);
      when(isSupportFullDock)().afterReturn(true);
      recentFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_START);
      expect(recentFollowingFromApp).not().assertNull();
      mocker.ignoreMock(DockUtils, DockUtils.isSupportFullDock);
      
    })

    it('RecentFollowingFromAppTest_init_02', Level.LEVEL0, (): void => {
      event.offsetY = 10;
      recentFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(recentFollowingFromApp).not().assertNull();
    })

    it('RecentFollowingFromAppTest_init_03', Level.LEVEL0, (): void => {
      event.offsetY = -10;
      recentFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(recentFollowingFromApp).not().assertNull();
    })

    it('RecentFollowingFromAppTest_init_04', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentFollowingFromApp)
        .addState(quickSwitchFollowingFromApp)
        .addState(appIdle)
        .addState(farAwayFollowingFromApp)
        .addState(homeIdle)
        .addState(quickSwitchIdle)
        .addState(zoomFollowingFromApp)
        .addState(recentIdle);
      fsm.currentState = recentFollowingFromApp;
      recentFollowingFromApp.attachToFsm(fsm);
      recentFollowingFromApp.init();
      recentFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(recentFollowingFromApp).not().assertNull();
    })

    it('RecentFollowingFromAppTest_init_04_01', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentFollowingFromApp)
        .addState(quickSwitchFollowingFromApp)
        .addState(appIdle)
        .addState(farAwayFollowingFromApp)
        .addState(homeIdle)
        .addState(quickSwitchIdle)
        .addState(zoomFollowingFromApp)
        .addState(recentIdle);
      fsm.currentState = recentFollowingFromApp;
      recentFollowingFromApp.attachToFsm(fsm);
      recentFollowingFromApp.init();
      recentFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(recentFollowingFromApp).not().assertNull();
    })

    it('RecentFollowingFromAppTest_init_05', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentFollowingFromApp)
        .addState(quickSwitchFollowingFromApp)
        .addState(appIdle)
        .addState(farAwayFollowingFromApp)
        .addState(homeIdle)
        .addState(quickSwitchIdle)
        .addState(zoomFollowingFromApp)
        .addState(recentIdle);
      fsm.currentState = recentFollowingFromApp;
      recentFollowingFromApp.attachToFsm(fsm);
      recentFollowingFromApp.init();
      recentFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(recentFollowingFromApp).not().assertNull();
    })

    it('RecentFollowingFromAppTest_init_05_1', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentFollowingFromApp)
        .addState(quickSwitchFollowingFromApp)
        .addState(appIdle)
        .addState(farAwayFollowingFromApp)
        .addState(homeIdle)
        .addState(quickSwitchIdle)
        .addState(zoomFollowingFromApp)
        .addState(recentIdle);
      fsm.currentState = recentFollowingFromApp;
      recentFollowingFromApp.attachToFsm(fsm);
      recentFollowingFromApp.init();
      recentFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(recentFollowingFromApp).not().assertNull();
    })

    it('RecentFollowingFromAppTest_init_06', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentFollowingFromApp)
        .addState(quickSwitchFollowingFromApp)
        .addState(appIdle)
        .addState(farAwayFollowingFromApp)
        .addState(homeIdle)
        .addState(quickSwitchIdle)
        .addState(zoomFollowingFromApp)
        .addState(recentIdle);
      fsm.currentState = recentFollowingFromApp;
      recentFollowingFromApp.attachToFsm(fsm);
      recentFollowingFromApp.init();
      let startEvent: GestureEvent = {
        target: eventTarget,
        timestamp: 0,
        source: 0,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: 0,
        repeat: false,
        fingerList: [],
        offsetX: 0,
        offsetY: 0,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE);
      recentFollowingFromApp.onEnter(recentFollowingFromApp, fsmEvent, startEvent);
      event.offsetY = 0;
      let mocker: MockKit = new MockKit();
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)().afterReturn(true);
      recentFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(recentFollowingFromApp).not().assertNull();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('RecentFollowingFromAppTest_init_06_01', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentFollowingFromApp)
        .addState(quickSwitchFollowingFromApp)
        .addState(appIdle)
        .addState(farAwayFollowingFromApp)
        .addState(homeIdle)
        .addState(quickSwitchIdle)
        .addState(zoomFollowingFromApp)
        .addState(recentIdle);
      fsm.currentState = recentFollowingFromApp;
      recentFollowingFromApp.attachToFsm(fsm);
      recentFollowingFromApp.init();
      let startEvent: GestureEvent = {
        target: eventTarget,
        timestamp: 0,
        source: 0,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: 0,
        repeat: false,
        fingerList: [],
        offsetX: 0,
        offsetY: 0,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE);
      recentFollowingFromApp.onEnter(recentFollowingFromApp, fsmEvent, startEvent);
      event.offsetY = 0;
      let mocker: MockKit = new MockKit();
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)().afterReturn(true);
      recentFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(recentFollowingFromApp).not().assertNull();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('RecentFollowingFromAppTest_FarAwayFollowingFromAppTest_init_07', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentFollowingFromApp)
        .addState(quickSwitchFollowingFromApp)
        .addState(appIdle)
        .addState(farAwayFollowingFromApp)
        .addState(homeIdle)
        .addState(quickSwitchIdle)
        .addState(zoomFollowingFromApp)
        .addState(recentIdle);
      fsm.currentState = recentFollowingFromApp;
      recentFollowingFromApp.attachToFsm(fsm);
      recentFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)().afterReturn(true);
      recentFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(recentFollowingFromApp).not().assertNull();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })


    it('RecentFollowingFromAppTest_FarAwayFollowingFromAppTest_init_08', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentFollowingFromApp)
        .addState(quickSwitchFollowingFromApp)
        .addState(appIdle)
        .addState(farAwayFollowingFromApp)
        .addState(homeIdle)
        .addState(quickSwitchIdle)
        .addState(zoomFollowingFromApp)
        .addState(recentIdle);
      fsm.currentState = recentFollowingFromApp;
      recentFollowingFromApp.attachToFsm(fsm);
      recentFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)().afterReturn(false);
      recentFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(recentFollowingFromApp).not().assertNull();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('RecentFollowingFromAppTest_FarAwayFollowingFromAppTest_init_08_01', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentFollowingFromApp)
        .addState(quickSwitchFollowingFromApp)
        .addState(appIdle)
        .addState(farAwayFollowingFromApp)
        .addState(homeIdle)
        .addState(quickSwitchIdle)
        .addState(zoomFollowingFromApp)
        .addState(recentIdle);
      fsm.currentState = recentFollowingFromApp;
      recentFollowingFromApp.attachToFsm(fsm);
      recentFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)().afterReturn(false);
      recentFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(recentFollowingFromApp).not().assertNull();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('RecentFollowingFromAppTest_FarAwayFollowingFromAppTest_init_09', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentFollowingFromApp)
        .addState(quickSwitchFollowingFromApp)
        .addState(appIdle)
        .addState(farAwayFollowingFromApp)
        .addState(homeIdle)
        .addState(quickSwitchIdle)
        .addState(zoomFollowingFromApp)
        .addState(recentIdle);
      fsm.currentState = recentFollowingFromApp;
      recentFollowingFromApp.attachToFsm(fsm);
      recentFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)().afterReturn(false);
      event.offsetY = 10;
      recentFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(recentFollowingFromApp).not().assertNull();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('RecentFollowingFromAppTest_FarAwayFollowingFromAppTest_init_09_01', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentFollowingFromApp)
        .addState(quickSwitchFollowingFromApp)
        .addState(appIdle)
        .addState(farAwayFollowingFromApp)
        .addState(homeIdle)
        .addState(quickSwitchIdle)
        .addState(zoomFollowingFromApp)
        .addState(recentIdle);
      fsm.currentState = recentFollowingFromApp;
      recentFollowingFromApp.attachToFsm(fsm);
      recentFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)().afterReturn(false);
      event.offsetY = 10;
      recentFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(recentFollowingFromApp).not().assertNull();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('RecentFollowingFromAppTest_FarAwayFollowingFromAppTest_init_10', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentFollowingFromApp)
        .addState(quickSwitchFollowingFromApp)
        .addState(appIdle)
        .addState(farAwayFollowingFromApp)
        .addState(homeIdle)
        .addState(quickSwitchIdle)
        .addState(zoomFollowingFromApp)
        .addState(recentIdle);
      fsm.currentState = recentFollowingFromApp;
      recentFollowingFromApp.attachToFsm(fsm);
      recentFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)().afterReturn(false);
      event.offsetY = 200;
      recentFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(recentFollowingFromApp).not().assertNull();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('RecentFollowingFromAppTest_FarAwayFollowingFromAppTest_init_11', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentFollowingFromApp)
        .addState(quickSwitchFollowingFromApp)
        .addState(appIdle)
        .addState(farAwayFollowingFromApp)
        .addState(homeIdle)
        .addState(quickSwitchIdle)
        .addState(zoomFollowingFromApp)
        .addState(recentIdle);
      fsm.currentState = recentFollowingFromApp;
      recentFollowingFromApp.attachToFsm(fsm);
      recentFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)().afterReturn(false);
      gestureHelperInstance.curSpeed = -1;
      recentFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(recentFollowingFromApp).not().assertNull();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('RecentFollowingFromAppTest_FarAwayFollowingFromAppTest_init_11_01', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentFollowingFromApp)
        .addState(quickSwitchFollowingFromApp)
        .addState(appIdle)
        .addState(farAwayFollowingFromApp)
        .addState(homeIdle)
        .addState(quickSwitchIdle)
        .addState(zoomFollowingFromApp)
        .addState(recentIdle);
      fsm.currentState = recentFollowingFromApp;
      recentFollowingFromApp.attachToFsm(fsm);
      recentFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)().afterReturn(false);
      gestureHelperInstance.curSpeed = -1;
      recentFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(recentFollowingFromApp).not().assertNull();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('RecentFollowingFromAppTest_FarAwayFollowingFromAppTest_init_12', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(recentFollowingFromApp)
        .addState(quickSwitchFollowingFromApp)
        .addState(appIdle)
        .addState(farAwayFollowingFromApp)
        .addState(homeIdle)
        .addState(quickSwitchIdle)
        .addState(zoomFollowingFromApp)
        .addState(recentIdle);
      fsm.currentState = recentFollowingFromApp;
      recentFollowingFromApp.attachToFsm(fsm);
      recentFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)().afterReturn(false);
      recentFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(recentFollowingFromApp).not().assertNull();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('RecentFollowingFromAppTest_onLeave', Level.LEVEL0, (): void => {
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_END);
      recentFollowingFromApp.onLeave(recentFollowingFromApp, fsmEvent);
      expect(recentFollowingFromApp).not().assertNull();
    })
  })
}