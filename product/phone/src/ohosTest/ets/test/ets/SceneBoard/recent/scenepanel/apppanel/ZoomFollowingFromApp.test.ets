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
import { FSM, FSMEvent, launcherStatusUtil, SCBScenePanelManager, SCBScreenProperty } from '@ohos/windowscene';
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
import { oneStepStateManagerInstance } from '@ohos/gesturenavigation/src/main/ets/constants/CommonConstants';
import { DockUtils, CommonConstants } from '@ohos/launchercommon';
import { ScenePanelStates } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/ScenePanelStates';

export default function ZoomFollowingFromAppTest() {
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
  let farAwayFollowingFromApp: FarAwayFollowingFromApp = new FarAwayFollowingFromApp(scbScenePanelManager);
  let recentFollowingFromApp: RecentFollowingFromApp = new RecentFollowingFromApp(scbScenePanelManager);
  let homeIdle: HomeIdle = new HomeIdle(scbScenePanelManager);
  let zoomFollowingFromApp: ZoomFollowingFromApp = new ZoomFollowingFromApp(scbScenePanelManager);
  let quickSwitchFollowingFromApp: QuickSwitchFollowingFromApp = new QuickSwitchFollowingFromApp(scbScenePanelManager);
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

  describe('ZoomFollowingFromAppTest', () => {
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
    let fsm = new FSM('testFSM');
    fsm.addState(zoomFollowingFromApp)
      .addState(appIdle)
    fsm.currentState = zoomFollowingFromApp;
    zoomFollowingFromApp.attachToFsm(fsm);
    it('ZoomFollowingFromApp_onLeave', Level.LEVEL0, (): void => {
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelStates.STATE_APP_IDLE);
      zoomFollowingFromApp.onLeave(zoomFollowingFromApp, fsmEvent);
      expect(zoomFollowingFromApp).not().assertNull();
    })

    it('ZoomFollowingFromApp_onEnter_01', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isSupportFullDock: Function = mocker.mockFunc(DockUtils, DockUtils.isSupportFullDock);
      when(isSupportFullDock)(ArgumentMatchers.any).afterReturn(true);
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelStates.STATE_APP_IDLE);
      zoomFollowingFromApp.onEnter(zoomFollowingFromApp, fsmEvent);
     expect(zoomFollowingFromApp).not().assertNull();
      mocker.ignoreMock(DockUtils, DockUtils.isSupportFullDock);
    })

    it('ZoomFollowingFromApp_onEnter_02', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isSupportFullDock: Function = mocker.mockFunc(DockUtils, DockUtils.isSupportFullDock);
      when(isSupportFullDock)(ArgumentMatchers.any).afterReturn(true);
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelStates.STATE_APP_IDLE);
      zoomFollowingFromApp.onEnter(zoomFollowingFromApp, fsmEvent);
     expect(zoomFollowingFromApp).not().assertNull();
      mocker.ignoreMock(DockUtils, DockUtils.isSupportFullDock);
    })

    it('ZoomFollowingFromApp_onEnter_03', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isSupportFullDock: Function = mocker.mockFunc(DockUtils, DockUtils.isSupportFullDock);
      when(isSupportFullDock)(ArgumentMatchers.any).afterReturn(true);
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelStates.STATE_APP_IDLE);
      zoomFollowingFromApp.onEnter(zoomFollowingFromApp, fsmEvent);
     expect(zoomFollowingFromApp).not().assertNull();
      mocker.ignoreMock(DockUtils, DockUtils.isSupportFullDock);
    })

    it('ZoomFollowingFromApp_onEnter_04', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isSupportFullDock: Function = mocker.mockFunc(DockUtils, DockUtils.isSupportFullDock);
      when(isSupportFullDock)(ArgumentMatchers.any).afterReturn(false);
      let fsmEvent: FSMEvent = FSMEvent.builder(ScenePanelStates.STATE_APP_IDLE);
      zoomFollowingFromApp.onEnter(zoomFollowingFromApp, fsmEvent);
     expect(zoomFollowingFromApp).not().assertNull();
      mocker.ignoreMock(DockUtils, DockUtils.isSupportFullDock);
    })

    it('ZoomFollowingFromApp_test_toSelfFollowingUpdate_01', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNearlyUpForward: Function = mocker.mockFunc(GestureHelper, GestureHelper.isNearlyUpForward);
      when(isNearlyUpForward)(ArgumentMatchers.any).afterReturn(false);
      (zoomFollowingFromApp as object)['toSelfFollowingUpdate']();
     expect(zoomFollowingFromApp).not().assertNull();
      mocker.ignoreMock(GestureHelper, GestureHelper.isNearlyUpForward);
    })

    it('ZoomFollowingFromApp_test_toSelfFollowingUpdate_02', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNearlyUpForward: Function = mocker.mockFunc(GestureHelper, GestureHelper.isNearlyUpForward);
      when(isNearlyUpForward)(ArgumentMatchers.any).afterReturn(true);
      (zoomFollowingFromApp as object)['toSelfFollowingUpdate']();
     expect(zoomFollowingFromApp).not().assertNull();
      mocker.ignoreMock(GestureHelper, GestureHelper.isNearlyUpForward);
    })

    it('ZoomFollowingFromApp_test_toHomeIdleByOneStep_01', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNearlyUpForward: Function = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isNearlyUpForward)(ArgumentMatchers.any).afterReturn(true);
      (zoomFollowingFromApp as object)['toSelfFollowingUpdate']();
     expect(zoomFollowingFromApp).not().assertNull();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('ZoomFollowingFromApp_test_toHomeIdleByOneStep_02', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNearlyUpForward: Function = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isNearlyUpForward)(ArgumentMatchers.any).afterReturn(false);
      (zoomFollowingFromApp as object)['toSelfFollowingUpdate']();
     expect(zoomFollowingFromApp).not().assertNull();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('ZoomFollowingFromApp_test_toRecentSpeedJudge_01', Level.LEVEL0, (): void => {
      gestureHelperInstance.acceleration = 0.1;
      gestureHelperInstance.curSpeed = -0.1;
      expect((zoomFollowingFromApp as object)['toRecentSpeedJudge'](event)).assertTrue();
    })

    it('ZoomFollowingFromApp_test_toRecentSpeedJudge_02', Level.LEVEL0, (): void => {
      gestureHelperInstance.acceleration = 0.1;
      gestureHelperInstance.curSpeed = 1;
      gestureHelperInstance.stopDuration = 90;
      expect((zoomFollowingFromApp as object)['toRecentSpeedJudge'](event)).assertTrue();
    })

    it('ZoomFollowingFromApp_test_toRecentSpeedJudge_03', Level.LEVEL0, (): void => {
      gestureHelperInstance.acceleration = 0.1;
      gestureHelperInstance.curSpeed = 1;
      gestureHelperInstance.stopDuration = 60;
      expect((zoomFollowingFromApp as object)['toRecentSpeedJudge'](event)).assertFalse();
    })

    it('toRecentFollowing_test_01', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(zoomFollowingFromApp)
        .addState(recentFollowingFromApp);
      fsm.currentState = zoomFollowingFromApp;
      zoomFollowingFromApp.attachToFsm(fsm);
      zoomFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isNearlyUpForward: Function = mocker.mockFunc(GestureHelper, GestureHelper.isNearlyUpForward);
      when(isNearlyUpForward)(ArgumentMatchers.any).afterReturn(false);
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)(ArgumentMatchers.any).afterReturn(false);
      (zoomFollowingFromApp as object)['screenHeight'] = 100;
      gestureHelperInstance.stopDuration = 90;
      zoomFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event)
      expect(zoomFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(GestureHelper, GestureHelper.isNearlyUpForward);
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('toQuickSwitchFollowing_test_01', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(zoomFollowingFromApp)
        .addState(quickSwitchFollowingFromApp);
      fsm.currentState = zoomFollowingFromApp;
      zoomFollowingFromApp.attachToFsm(fsm);
      zoomFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isNearlyUpForward: Function = mocker.mockFunc(GestureHelper, GestureHelper.isNearlyUpForward);
      when(isNearlyUpForward)(ArgumentMatchers.any).afterReturn(false);
      let getShowOutLauncherStatus: Function = mocker.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(getShowOutLauncherStatus)(ArgumentMatchers.any).afterReturn(false);
      let isNearlyXForward: Function = mocker.mockFunc(GestureHelper, GestureHelper.isNearlyXForward);
      when(isNearlyXForward)(ArgumentMatchers.any).afterReturn(true);
      zoomFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event)
      expect(zoomFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(GestureHelper, GestureHelper.isNearlyUpForward);
      mocker.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      mocker.ignoreMock(GestureHelper, GestureHelper.isNearlyXForward);
    })

    it('toQuickSwitchFollowing_test_02', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(zoomFollowingFromApp)
        .addState(quickSwitchFollowingFromApp);
      fsm.currentState = zoomFollowingFromApp;
      zoomFollowingFromApp.attachToFsm(fsm);
      zoomFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isNearlyUpForward: Function = mocker.mockFunc(GestureHelper, GestureHelper.isNearlyUpForward);
      when(isNearlyUpForward)(ArgumentMatchers.any).afterReturn(false);
      let getShowOutLauncherStatus: Function = mocker.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(getShowOutLauncherStatus)(ArgumentMatchers.any).afterReturn(true);
      let isNearlyXForward: Function = mocker.mockFunc(GestureHelper, GestureHelper.isNearlyXForward);
      when(isNearlyXForward)(ArgumentMatchers.any).afterReturn(true);
      zoomFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event)
      expect(zoomFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(GestureHelper, GestureHelper.isNearlyUpForward);
      mocker.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      mocker.ignoreMock(GestureHelper, GestureHelper.isNearlyXForward);
    })

    it('toQuickSwitchFollowing_test_03', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(zoomFollowingFromApp)
        .addState(quickSwitchFollowingFromApp);
      fsm.currentState = zoomFollowingFromApp;
      zoomFollowingFromApp.attachToFsm(fsm);
      zoomFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isNearlyUpForward: Function = mocker.mockFunc(GestureHelper, GestureHelper.isNearlyUpForward);
      when(isNearlyUpForward)(ArgumentMatchers.any).afterReturn(false);
      let getShowOutLauncherStatus: Function = mocker.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(getShowOutLauncherStatus)(ArgumentMatchers.any).afterReturn(false);
      let isNearlyXForward: Function = mocker.mockFunc(GestureHelper, GestureHelper.isNearlyXForward);
      when(isNearlyXForward)(ArgumentMatchers.any).afterReturn(false);
      zoomFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event)
      expect(zoomFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(GestureHelper, GestureHelper.isNearlyUpForward);
      mocker.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      mocker.ignoreMock(GestureHelper, GestureHelper.isNearlyXForward);
    })

    it('toFarAwayFollowing_test_01', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(zoomFollowingFromApp)
        .addState(farAwayFollowingFromApp);
      fsm.currentState = zoomFollowingFromApp;
      zoomFollowingFromApp.attachToFsm(fsm);
      zoomFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isNearlyUpForward: Function = mocker.mockFunc(GestureHelper, GestureHelper.isNearlyUpForward);
      when(isNearlyUpForward)(ArgumentMatchers.any).afterReturn(false);
      let getShowOutLauncherStatus: Function = mocker.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(getShowOutLauncherStatus)(ArgumentMatchers.any).afterReturn(true);
      zoomFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event)
      expect(zoomFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(GestureHelper, GestureHelper.isNearlyUpForward);
      mocker.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
    })

    it('toFarAwayFollowing_test_02', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(zoomFollowingFromApp)
        .addState(farAwayFollowingFromApp);
      fsm.currentState = zoomFollowingFromApp;
      zoomFollowingFromApp.attachToFsm(fsm);
      zoomFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isNearlyUpForward: Function = mocker.mockFunc(GestureHelper, GestureHelper.isNearlyUpForward);
      when(isNearlyUpForward)(ArgumentMatchers.any).afterReturn(true);
      gestureHelperInstance.acceleration = 0.1;
      gestureHelperInstance.curSpeed = 1;
      gestureHelperInstance.stopDuration = 60;
      let getShowOutLauncherStatus: Function = mocker.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(getShowOutLauncherStatus)(ArgumentMatchers.any).afterReturn(true);
      (zoomFollowingFromApp as object)['aspectRadio'] = 3;
      (zoomFollowingFromApp as object)['screenHeight'] = 17;
      zoomFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event)
      expect(zoomFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(GestureHelper, GestureHelper.isNearlyUpForward);
      mocker.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
    })

    it('toSelfFollowingUpdate_test_01', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(zoomFollowingFromApp)
        .addState(farAwayFollowingFromApp);
      fsm.currentState = zoomFollowingFromApp;
      zoomFollowingFromApp.attachToFsm(fsm);
      zoomFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isNearlyUpForward: Function = mocker.mockFunc(GestureHelper, GestureHelper.isNearlyUpForward);
      when(isNearlyUpForward)(ArgumentMatchers.any).afterReturn(true);
      gestureHelperInstance.acceleration = 0.1;
      gestureHelperInstance.curSpeed = 1;
      gestureHelperInstance.stopDuration = 60;
      let getShowOutLauncherStatus: Function = mocker.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(getShowOutLauncherStatus)(ArgumentMatchers.any).afterReturn(true);
      (zoomFollowingFromApp as object)['aspectRadio'] = 1;
      (zoomFollowingFromApp as object)['screenHeight'] = 100;
      zoomFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event)
      expect(zoomFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(GestureHelper, GestureHelper.isNearlyUpForward);
      mocker.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
    })

    it('toSelfFollowingUpdate_test_02', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(zoomFollowingFromApp)
        .addState(farAwayFollowingFromApp);
      fsm.currentState = zoomFollowingFromApp;
      zoomFollowingFromApp.attachToFsm(fsm);
      zoomFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isNearlyUpForward: Function = mocker.mockFunc(GestureHelper, GestureHelper.isNearlyUpForward);
      when(isNearlyUpForward)(ArgumentMatchers.any).afterReturn(false);
      gestureHelperInstance.acceleration = 0.1;
      gestureHelperInstance.curSpeed = 1;
      gestureHelperInstance.stopDuration = 60;
      let getShowOutLauncherStatus: Function = mocker.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
      when(getShowOutLauncherStatus)(ArgumentMatchers.any).afterReturn(true);
      (zoomFollowingFromApp as object)['aspectRadio'] = 1;
      (zoomFollowingFromApp as object)['screenHeight'] = 100;
      zoomFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_UPDATE, event)
      expect(zoomFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(GestureHelper, GestureHelper.isNearlyUpForward);
      mocker.ignoreMock(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
    })

    it('cancelToAppIdle_test_01', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(zoomFollowingFromApp)
        .addState(appIdle);
      fsm.currentState = zoomFollowingFromApp;
      zoomFollowingFromApp.attachToFsm(fsm);
      zoomFollowingFromApp.init();
      zoomFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_CANCEL, event)
      expect(zoomFollowingFromApp).not().assertUndefined();
    })

    it('toHomeIdleByOneStep_test_01', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(zoomFollowingFromApp)
        .addState(homeIdle);
      fsm.currentState = zoomFollowingFromApp;
      zoomFollowingFromApp.attachToFsm(fsm);
      zoomFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)(ArgumentMatchers.any).afterReturn(true);
      zoomFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_END, event)
      expect(zoomFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('toHomeIdle_test_01', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(zoomFollowingFromApp)
        .addState(homeIdle);
      fsm.currentState = zoomFollowingFromApp;
      zoomFollowingFromApp.attachToFsm(fsm);
      zoomFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)(ArgumentMatchers.any).afterReturn(false);
      let isSpeedUpForward = mocker.mockFunc(gestureHelperInstance, gestureHelperInstance.isSpeedUpForward);
      when(isSpeedUpForward)(ArgumentMatchers.any).afterReturn(true);
      gestureHelperInstance.speedScalar = 1;
      zoomFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_END, event)
      expect(zoomFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })

    it('toAppIdle_test_01', Level.LEVEL0, (): void => {
      let fsm = new FSM('testFSM');
      fsm.addState(zoomFollowingFromApp)
        .addState(appIdle);
      fsm.currentState = zoomFollowingFromApp;
      zoomFollowingFromApp.attachToFsm(fsm);
      zoomFollowingFromApp.init();
      let mocker: MockKit = new MockKit();
      let isEnter = mocker.mockFunc(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
      when(isEnter)(ArgumentMatchers.any).afterReturn(false);
      let isSpeedUpForward = mocker.mockFunc(gestureHelperInstance, gestureHelperInstance.isSpeedUpForward);
      when(isSpeedUpForward)(ArgumentMatchers.any).afterReturn(false);
      zoomFollowingFromApp.transfer(ScenePanelEvents.EVENT_GESTURE_END, event)
      expect(zoomFollowingFromApp).not().assertUndefined();
      mocker.ignoreMock(oneStepStateManagerInstance, oneStepStateManagerInstance.isEnter);
    })
  })
}