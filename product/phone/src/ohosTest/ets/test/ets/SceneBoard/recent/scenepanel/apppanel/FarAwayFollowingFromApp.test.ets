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
import { GestureHelper } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/common/GestureHelper';
import { oneStepStateManagerInstance } from '@ohos/gesturenavigation/src/main/ets/constants/CommonConstants';
import { DockUtils } from '@ohos/launchercommon/src/main/ets/TsIndex';

export default function FarAwayFollowingFromAppTest() {
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
  let farAwayFollowingFromApp: FarAwayFollowingFromApp = new FarAwayFollowingFromApp(scbScenePanelManager);
  let recentFollowingFromApp: RecentFollowingFromApp = new RecentFollowingFromApp(scbScenePanelManager);
  let homeIdle: HomeIdle = new HomeIdle(scbScenePanelManager);
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


  describe('FarAwayFollowingFromAppTest', () => {
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


    it('FarAwayFollowingFromAppTest_init_01', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(farAwayFollowingFromApp)
        .addState(recentFollowingFromApp)
        .addState(homeIdle);
      fsm.currentState = farAwayFollowingFromApp;
      farAwayFollowingFromApp.attachToFsm(fsm);
      farAwayFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isSupportFullDock = mocker.mockFunc(DockUtils, DockUtils.isSupportFullDock);
      when(isSupportFullDock)().afterReturn(true);
      farAwayFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_START);
      expect(farAwayFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(DockUtils, DockUtils.isSupportFullDock);
    })

    it('FarAwayFollowingFromAppTest_init_02', Level.LEVEL0, (): void => {
      farAwayFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(farAwayFollowingFromApp).not().assertUndefined();
    })

    it('FarAwayFollowingFromAppTest_init_03', Level.LEVEL0, (): void => {
      event.offsetY = 10;
      farAwayFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(farAwayFollowingFromApp).not().assertUndefined();
    })

    it('FarAwayFollowingFromAppTest_init_04', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)().afterReturn(true);
      farAwayFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(farAwayFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('FarAwayFollowingFromAppTest_init_05', Level.LEVEL0, (): void => {
      scbScenePanelManager.getScreenProperty().height = 300;
      scbScenePanelManager.getScreenProperty().rotation = 0;
      farAwayFollowingFromApp = new FarAwayFollowingFromApp(scbScenePanelManager);
      let fsm = new FSM('testFSM');
      fsm.addState(farAwayFollowingFromApp)
        .addState(recentFollowingFromApp)
        .addState(homeIdle);
      fsm.currentState = farAwayFollowingFromApp;
      farAwayFollowingFromApp.attachToFsm(fsm);
      farAwayFollowingFromApp.init();
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE);
      farAwayFollowingFromApp.onEnter(farAwayFollowingFromApp, fsmEvent);
      let tmpEvent: GestureEvent = {
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
        offsetY: -5,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      let mocker: MockKit = new MockKit();
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)().afterReturn(false);
      farAwayFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, tmpEvent);
      expect(farAwayFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('FarAwayFollowingFromAppTest_init_06', Level.LEVEL0, (): void => {
      scbScenePanelManager.getScreenProperty().height = 300;
      scbScenePanelManager.getScreenProperty().rotation = 0;
      farAwayFollowingFromApp = new FarAwayFollowingFromApp(scbScenePanelManager);
      let fsm = new FSM('testFSM');
      fsm.addState(farAwayFollowingFromApp).addState(recentFollowingFromApp).addState(homeIdle);
      fsm.currentState = farAwayFollowingFromApp;
      farAwayFollowingFromApp.attachToFsm(fsm);
      farAwayFollowingFromApp.init();
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE);
      farAwayFollowingFromApp.onEnter(farAwayFollowingFromApp, fsmEvent);
      let tmpEvent: GestureEvent = {
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
        offsetY: 30,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      let mocker: MockKit = new MockKit();
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)().afterReturn(false);
      farAwayFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, tmpEvent);
      expect(farAwayFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('FarAwayFollowingFromAppTest_init_07', Level.LEVEL0, (): void => {
      farAwayFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(farAwayFollowingFromApp).not().assertUndefined();
    })

    it('FarAwayFollowingFromAppTest_init_08', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(farAwayFollowingFromApp)
        .addState(recentFollowingFromApp)
        .addState(homeIdle);
      fsm.currentState = farAwayFollowingFromApp;
      farAwayFollowingFromApp.attachToFsm(fsm);
      farAwayFollowingFromApp.init();
      farAwayFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(farAwayFollowingFromApp).not().assertUndefined();
    })

    it('FarAwayFollowingFromAppTest_init_09', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(farAwayFollowingFromApp)
        .addState(recentFollowingFromApp)
        .addState(homeIdle);
      fsm.currentState = farAwayFollowingFromApp;
      farAwayFollowingFromApp.attachToFsm(fsm);
      farAwayFollowingFromApp.init();
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE);
      farAwayFollowingFromApp.onEnter(farAwayFollowingFromApp, fsmEvent);
      let mocker: MockKit = new MockKit();
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)().afterReturn(true);
      farAwayFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(farAwayFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('FarAwayFollowingFromApp_onLeave', Level.LEVEL0, (): void => {
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE);
      farAwayFollowingFromApp.onLeave(farAwayFollowingFromApp, fsmEvent);
      expect(farAwayFollowingFromApp).not().assertUndefined();
    })

  })
}