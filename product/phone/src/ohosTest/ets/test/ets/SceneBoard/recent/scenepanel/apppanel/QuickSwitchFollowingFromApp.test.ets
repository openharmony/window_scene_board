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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  FSM,
  FSMEvent,
  SCBScenePanelManager,
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
  TestType,
  Size,
  Level,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';

import { ScenePanelEvents } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/ScenePanelEvents';
import screenSessionManager from '@ohos.screenSessionManager';
import { AppIdle } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/apppanel/AppIdle';
import {
  QuickSwitchFollowingFromApp
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/apppanel/QuickSwitchFollowingFromApp';
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
import { DockUtils } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { oneStepStateManagerInstance } from '@ohos/gesturenavigation/src/main/ets/constants/CommonConstants';

export default function QuickSwitchFollowingFromAppTest() {
  let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
  let screenProp: screenSessionManager.ScreenProperty = {
    rotation: 1,
    bounds: {
      left: 1,
      top: 1,
      width: 1,
      height: 10,
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

  describe('QuickSwitchFollowingFromAppTest', () => {
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


    it('QuickSwitchFollowingFromAppTest_init_01', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(quickSwitchFollowingFromApp)
        .addState(appIdle)
        .addState(farAwayFollowingFromApp)
        .addState(recentFollowingFromApp)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = quickSwitchFollowingFromApp;
      quickSwitchFollowingFromApp.attachToFsm(fsm);
      quickSwitchFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isSupportFullDock = mocker.mockFunc(DockUtils, DockUtils.isSupportFullDock);
      when(isSupportFullDock)().afterReturn(true);
      quickSwitchFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_START);
      expect(quickSwitchFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(DockUtils, DockUtils.isSupportFullDock);
    })

    it('QuickSwitchFollowingFromAppTest_init_02', Level.LEVEL0, (): void => {
      event.offsetY = 10;
      quickSwitchFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(GestureHelper.isUpForward(event)).assertEqual(false);
    })

    it('QuickSwitchFollowingFromAppTest_init_03', Level.LEVEL0, (): void => {
      event.offsetY = 0;
      quickSwitchFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(GestureHelper.isUpForward(event)).assertEqual(true);
    })

    it('QuickSwitchFollowingFromAppTest_init_04', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)().afterReturn(true);
      quickSwitchFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(quickSwitchFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('QuickSwitchFollowingFromAppTest_init_05', Level.LEVEL0, (): void => {
      scbScenePanelManager.getScreenProperty().height = 300;
      quickSwitchFollowingFromApp = new QuickSwitchFollowingFromApp(scbScenePanelManager);
      let fsm = new FSM('testFSM');
      fsm.addState(quickSwitchFollowingFromApp)
        .addState(appIdle)
        .addState(farAwayFollowingFromApp)
        .addState(recentFollowingFromApp)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = quickSwitchFollowingFromApp;
      quickSwitchFollowingFromApp.attachToFsm(fsm);
      quickSwitchFollowingFromApp.init();
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
      quickSwitchFollowingFromApp.onEnter(quickSwitchFollowingFromApp, fsmEvent, startEvent);
      let mocker: MockKit = new MockKit();
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)().afterReturn(true);
      quickSwitchFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(quickSwitchFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('QuickSwitchFollowingFromAppTest_init_06', Level.LEVEL0, (): void => {
      scbScenePanelManager.getScreenProperty().height = 300;
      scbScenePanelManager.getScreenProperty().rotation = 0;
      quickSwitchFollowingFromApp = new QuickSwitchFollowingFromApp(scbScenePanelManager);
      let fsm = new FSM('testFSM');
      fsm.addState(quickSwitchFollowingFromApp)
        .addState(appIdle)
        .addState(farAwayFollowingFromApp)
        .addState(recentFollowingFromApp)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = quickSwitchFollowingFromApp;
      quickSwitchFollowingFromApp.attachToFsm(fsm);
      quickSwitchFollowingFromApp.init();
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
      quickSwitchFollowingFromApp.onEnter(quickSwitchFollowingFromApp, fsmEvent, startEvent);
      //isDistance 为true
      event.offsetY = -2;
      gestureHelperInstance.acceleration = 1;
      gestureHelperInstance.curSpeed = 0;
      let mocker: MockKit = new MockKit();
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)().afterReturn(false);
      quickSwitchFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(quickSwitchFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('QuickSwitchFollowingFromAppTest_init_07', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(quickSwitchFollowingFromApp)
        .addState(appIdle)
        .addState(farAwayFollowingFromApp)
        .addState(recentFollowingFromApp)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = quickSwitchFollowingFromApp;
      quickSwitchFollowingFromApp.attachToFsm(fsm);
      quickSwitchFollowingFromApp.init();
      //isDistance 为true
      event.offsetY = 10;
      gestureHelperInstance.acceleration = 1;
      gestureHelperInstance.curSpeed = 0;
      let mocker: MockKit = new MockKit();
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)().afterReturn(false);
      quickSwitchFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event);
      expect(quickSwitchFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('QuickSwitchFollowingFromAppTest_init_08', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(quickSwitchFollowingFromApp)
        .addState(appIdle)
        .addState(farAwayFollowingFromApp)
        .addState(recentFollowingFromApp)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = quickSwitchFollowingFromApp;
      quickSwitchFollowingFromApp.attachToFsm(fsm);
      quickSwitchFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)().afterReturn(true);
      quickSwitchFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(quickSwitchFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('QuickSwitchFollowingFromAppTest_init_09', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(quickSwitchFollowingFromApp)
        .addState(appIdle)
        .addState(farAwayFollowingFromApp)
        .addState(recentFollowingFromApp)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = quickSwitchFollowingFromApp;
      quickSwitchFollowingFromApp.attachToFsm(fsm);
      quickSwitchFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)().afterReturn(false);
      quickSwitchFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(quickSwitchFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('QuickSwitchFollowingFromAppTest_init_10', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(quickSwitchFollowingFromApp)
        .addState(appIdle)
        .addState(farAwayFollowingFromApp)
        .addState(recentFollowingFromApp)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = quickSwitchFollowingFromApp;
      quickSwitchFollowingFromApp.attachToFsm(fsm);
      quickSwitchFollowingFromApp.init();
      event.offsetX = 10;
      event.offsetY = 5;
      gestureHelperInstance.speedXVector = 1;
      quickSwitchFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(quickSwitchFollowingFromApp).not().assertUndefined();
    })

    it('QuickSwitchFollowingFromAppTest_init_11', Level.LEVEL0, (): void => {
      scbScenePanelManager.getScreenProperty().rotation = 10;
      quickSwitchFollowingFromApp = new QuickSwitchFollowingFromApp(scbScenePanelManager);
      let fsm = new FSM('testFSM');
      fsm.addState(quickSwitchFollowingFromApp)
        .addState(appIdle)
        .addState(farAwayFollowingFromApp)
        .addState(recentFollowingFromApp)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = quickSwitchFollowingFromApp;
      quickSwitchFollowingFromApp.attachToFsm(fsm);
      quickSwitchFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)().afterReturn(false);
      quickSwitchFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(quickSwitchFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('QuickSwitchFollowingFromAppTest_init_12', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(quickSwitchFollowingFromApp)
        .addState(appIdle)
        .addState(farAwayFollowingFromApp)
        .addState(recentFollowingFromApp)
        .addState(homeIdle)
        .addState(quickSwitchIdle);
      fsm.currentState = quickSwitchFollowingFromApp;
      quickSwitchFollowingFromApp.attachToFsm(fsm);
      quickSwitchFollowingFromApp.init();
      gestureHelperInstance.curSpeed = -0.2;
      quickSwitchFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_END, event);
      expect(quickSwitchFollowingFromApp).not().assertUndefined();
    })

    it('QuickSwitchFollowingFromApp_test_init_01', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isRightForward = mocker.mockFunc(GestureHelper, GestureHelper.isRightForward);
      when(isRightForward)(ArgumentMatchers.any).afterReturn(false);
      quickSwitchFollowingFromApp.init();
      expect(quickSwitchFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(GestureHelper, GestureHelper.isRightForward);
    })

    it('QuickSwitchFollowingFromApp_test_init_02', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isRightForward = mocker.mockFunc(GestureHelper, GestureHelper.isRightForward);
      when(isRightForward)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchFollowingFromApp.init();
      expect(quickSwitchFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(GestureHelper, GestureHelper.isRightForward);
    })

    it('QuickSwitchFollowingFromApp_test_init_03', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isSpeedLeftForward = mocker.mockFunc(gestureHelperInstance, gestureHelperInstance.isSpeedLeftForward);
      when(isSpeedLeftForward)(ArgumentMatchers.any).afterReturn(true);
      quickSwitchFollowingFromApp.init();
      expect(quickSwitchFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(gestureHelperInstance, gestureHelperInstance.isSpeedLeftForward);
    })

    it('QuickSwitchFollowingFromApp_test_init_04', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isRightForward = mocker.mockFunc(GestureHelper, GestureHelper.isRightForward);
      when(isRightForward)(ArgumentMatchers.any).afterReturn(true);
      let isSpeedLeftForward = mocker.mockFunc(gestureHelperInstance, gestureHelperInstance.isSpeedLeftForward);
      when(isSpeedLeftForward)(ArgumentMatchers.any).afterReturn(false);
      gestureHelperInstance.curSpeed = 0.7;
      quickSwitchFollowingFromApp.init();
      expect(quickSwitchFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(gestureHelperInstance, gestureHelperInstance.isSpeedLeftForward);
    })

    it('QuickSwitchFollowingFromApp_onLeave', Level.LEVEL0, (): void => {
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE);
      quickSwitchFollowingFromApp.onLeave(quickSwitchFollowingFromApp, fsmEvent);
      expect(quickSwitchFollowingFromApp).not().assertUndefined();
    })

    it('QuickSwitchFollowingFromApp_onEnter', Level.LEVEL0, (): void => {
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelEvents.EVENT_GESTURE_UPDATE);
      quickSwitchFollowingFromApp.onEnter(quickSwitchFollowingFromApp, fsmEvent);
      expect(quickSwitchFollowingFromApp).not().assertUndefined();
    })

    it('QuickSwitchFollowingFromApp_toFarAwayDistanceJudge_01', Level.LEVEL0, (): void => {
      (quickSwitchFollowingFromApp as object)['startEvent'] = null;
      expect((quickSwitchFollowingFromApp as object)['toFarAwayDistanceJudge'](event)).assertFalse();
    })

    it('QuickSwitchFollowingFromApp_isBigDisplay_01', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isPad = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(isPad)().afterReturn(true);
      expect((quickSwitchFollowingFromApp as object)['isBigDisplay']()).assertTrue();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
    })

    it('QuickSwitchFollowingFromApp_isBigDisplay_02', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isPad = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(isPad)().afterReturn(false);
      let isFold = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(isFold)().afterReturn(true);
      let isFoldExpanded = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(isFoldExpanded)().afterReturn(true);
      expect((quickSwitchFollowingFromApp as object)['isBigDisplay']()).assertFalse();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isFold);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isFoldExpanded);
    })

    it('QuickSwitchFollowingFromApp_isBigDisplay_03', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isPad = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(isPad)().afterReturn(false);
      let isFold = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(isFold)().afterReturn(false);
      let isFoldExpanded = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(isFoldExpanded)().afterReturn(true);
      expect((quickSwitchFollowingFromApp as object)['isBigDisplay']()).assertFalse();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isFold);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isFoldExpanded);
    })

    it('QuickSwitchFollowingFromApp_isBigDisplay_04', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isPad = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(isPad)().afterReturn(false);
      let isFold = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(isFold)().afterReturn(false);
      let isFoldExpanded = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(isFoldExpanded)().afterReturn(false);
      expect((quickSwitchFollowingFromApp as object)['isBigDisplay']()).assertFalse();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isFold);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isFoldExpanded);
    })

    it('QuickSwitchFollowingFromApp_toRecentSpeedJudge_01', Level.LEVEL0, (): void => {
      gestureHelperInstance.acceleration = 1;
      gestureHelperInstance.speedScalar = 1;
      gestureHelperInstance.curSpeed = 0;
      expect((quickSwitchFollowingFromApp as object)['toRecentSpeedJudge'](event)).assertFalse();
    })

    it('QuickSwitchFollowingFromApp_toRecentSpeedJudge_02', Level.LEVEL0, (): void => {
      gestureHelperInstance.acceleration = 1;
      gestureHelperInstance.speedScalar = 1;
      gestureHelperInstance.curSpeed = 1;
      gestureHelperInstance.stopDuration = 90;
      expect((quickSwitchFollowingFromApp as object)['toRecentSpeedJudge'](event)).assertTrue();
    })

    it('QuickSwitchFollowingFromApp_toRecentSpeedJudge_03', Level.LEVEL0, (): void => {
      gestureHelperInstance.acceleration = 1;
      gestureHelperInstance.speedScalar = 1;
      gestureHelperInstance.curSpeed = 1;
      gestureHelperInstance.stopDuration = 80;
      expect((quickSwitchFollowingFromApp as object)['toRecentSpeedJudge'](event)).assertFalse();
    })

    it('QuickSwitchFollowingFromApp_toFarAwayDistanceJudge_02', Level.LEVEL0, (): void => {
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
        offsetY: 1,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
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
        offsetY: 2,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      (quickSwitchFollowingFromApp as object)['aspectRadio'] = 2;
      (quickSwitchFollowingFromApp as object)['startEvent'] = startEvent;
      (quickSwitchFollowingFromApp as object)['screenHeight'] = 1;
      expect((quickSwitchFollowingFromApp as object)['toFarAwayDistanceJudge'](event)).assertTrue();
    })

    it('QuickSwitchFollowingFromApp_toFarAwayDistanceJudge_03', Level.LEVEL0, (): void => {
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
        offsetY: 1,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      (quickSwitchFollowingFromApp as object)['aspectRadio'] = 2;
      (quickSwitchFollowingFromApp as object)['startEvent'] = event;
      (quickSwitchFollowingFromApp as object)['screenHeight'] = 1;
      expect((quickSwitchFollowingFromApp as object)['toFarAwayDistanceJudge'](event)).assertTrue();
    })

    it('QuickSwitchFollowingFromApp_toRecentDistanceJudge_01', Level.LEVEL0, (): void => {
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
        offsetY: 1,
        angle: 0,
        speed: 0,
        scale: 0,
        pinchCenterX: 0,
        pinchCenterY: 0,
        velocityX: 0,
        velocityY: 0,
        velocity: 0
      };
      (quickSwitchFollowingFromApp as object)['aspectRadio'] = 2;
      (quickSwitchFollowingFromApp as object)['startEvent'] = event;
      (quickSwitchFollowingFromApp as object)['screenHeight'] = 1;
      expect((quickSwitchFollowingFromApp as object)['toFarAwayDistanceJudge'](event)).assertTrue();
    })

    it('QuickSwitchFollowingFromApp_toHomeIdle_01', Level.LEVEL0, (): void => {
      gestureHelperInstance.speedYVector = -0.2;
      (quickSwitchFollowingFromApp as object)['toHomeIdle']();
      expect(gestureHelperInstance.speedYVector).assertEqual(-0.2);
    })

    it('QuickSwitchFollowingFromApp_toHomeIdle_02', Level.LEVEL0, (): void => {
      gestureHelperInstance.speedYVector = 0.2;
      (quickSwitchFollowingFromApp as object)['toHomeIdle']();
      expect(gestureHelperInstance.speedYVector).assertEqual(0.2);
    })

    it('QuickSwitchFollowingFromApp_toQuickSwitchIdle_01', Level.LEVEL0, (): void => {
      gestureHelperInstance.speedXVector = 0.8;
      (quickSwitchFollowingFromApp as object)['toQuickSwitchIdle']();
      expect(gestureHelperInstance.speedYVector).assertEqual(0.2);
    })

    it('QuickSwitchFollowingFromApp_toQuickSwitchIdle_02', Level.LEVEL0, (): void => {
      gestureHelperInstance.speedXVector = -0.8;
      (quickSwitchFollowingFromApp as object)['toQuickSwitchIdle']();
      expect(gestureHelperInstance.speedYVector).assertEqual(0.2);
    })

    it('QuickSwitchFollowingFromApp_toQuickSwitchIdle_03', Level.LEVEL0, (): void => {
      gestureHelperInstance.speedXVector = -0.6;
      (quickSwitchFollowingFromApp as object)['toQuickSwitchIdle']();
      expect(gestureHelperInstance.speedYVector).assertEqual(0.2);
    })
  })
}