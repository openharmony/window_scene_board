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
import {
  PreferMultiWindowOrientation,
  SCBGestureAction, SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBScenePanelManager,
  SCBSceneSession,
  SCBScreenProperty,
  ScenePanelState} from '@ohos/windowscene';
import { ArgumentMatchers, beforeAll, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import sceneSessionManager from '@ohos.sceneSessionManager'
import {
  OneStepModel,
  SCBOneStepViewModel
} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBOneStepViewModel';
import { OneStepState } from '@ohos/gesturenavigation/src/main/ets/constants/CommonConstants';
import { SCBMultiWindowUtils } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBMultiWindowUtils';
import { DockUtils } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { ReflectionUtils } from './ReflectionUtils';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { SCBConstants } from '@ohos/commonconstants';

export function SCBOneStepViewModelTest() {
  let oneStepViewModel: SCBOneStepViewModel;
  let screenProperty: SCBScreenProperty = new SCBScreenProperty();
  let sceneInfo: SCBSceneInfo;
  let secondarySceneInfo: SCBSceneInfo;
  let sceneSession: SCBSceneSession;
  let secondarySceneSession: SCBSceneSession;
  let containerSession: SCBSceneContainerSession;
  let onGestureChange: (action: SCBGestureAction) => void;
  let eventArea: Area = {
    width: 0,
    height: 0,
    position: { x: 0, y: 0 },
    globalPosition: { x: 0, y: 0 }
  };
  let eventTarget: EventTarget = {
    area: eventArea
  };
  let event: GestureEvent = {
    repeat: false,
    fingerList: [],
    offsetX: 9,
    offsetY: 19,
    angle: 0,
    speed: 0,
    scale: 0,
    pinchCenterX: 0,
    pinchCenterY: 0,
    velocityX: 0,
    velocityY: 0,
    velocity: 0,
    target: eventTarget,
    timestamp: 0,
    source: SourceType.Unknown,
    pressure: 0,
    tiltX: 0,
    tiltY: 0,
    sourceTool: SourceTool.Unknown
  };
  describe('SCBOneStepViewModelTest', () => {
    beforeAll((): void => {
      oneStepViewModel = new SCBOneStepViewModel(SCBOneStepViewModel.getDefaultSplitModel(),
        SCBOneStepViewModel.getDefaultMidSceneModel(), SCBOneStepViewModel.getDefaultFloatingModel());
      sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      sceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      secondarySceneInfo = new SCBSceneInfo('secondaryTestPriBundle', 'secondaryTestPriModule', 'secondaryTestPriAbility');
      secondarySceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(secondarySceneInfo), secondarySceneInfo);
      screenProperty.width = 100;
      screenProperty.height = 100;
      screenProperty.rotation = 0;
      screenProperty.screenId = 0;
      containerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      onGestureChange = (action: SCBGestureAction) => {
      }
    })

    it('getDefaultSplitModel', Level.LEVEL0, () => {
      let splitModel: OneStepModel = SCBOneStepViewModel.getDefaultSplitModel();
      expect(splitModel.isVisible).assertFalse();
      expect(splitModel.isIconVisible).assertFalse();
      expect(splitModel.isHitHotArea).assertFalse();
    })

    it('getDefaultFloatingModel', Level.LEVEL0, () => {
      let floatingModel: OneStepModel = SCBOneStepViewModel.getDefaultFloatingModel();
      expect(floatingModel.isVisible).assertFalse();
      expect(floatingModel.isIconVisible).assertFalse();
      expect(floatingModel.isHitHotArea).assertFalse();
    })

    it('getDefaultMidSceneModel', Level.LEVEL0, () => {
      let midSceneModel: OneStepModel = SCBOneStepViewModel.getDefaultMidSceneModel();
      expect(midSceneModel.isVisible).assertFalse();
      expect(midSceneModel.isIconVisible).assertFalse();
      expect(midSceneModel.isHitHotArea).assertFalse();
    })

    it('setCurOneStepState', Level.LEVEL0, () => {
      oneStepViewModel.setCurOneStepState(OneStepState.DEFAULT);
      expect(oneStepViewModel.getCurOneStepState()).assertEqual(OneStepState.DEFAULT);
      oneStepViewModel.setCurOneStepState(OneStepState.SHOW_ONLY_BG);
      expect(oneStepViewModel.getCurOneStepState()).assertEqual(OneStepState.SHOW_ONLY_BG);
      oneStepViewModel.setCurOneStepState(OneStepState.SHOW_BG_AND_ICON);
      expect(oneStepViewModel.getCurOneStepState()).assertEqual(OneStepState.SHOW_BG_AND_ICON);
      oneStepViewModel.setCurOneStepState(OneStepState.ENTER_SPLIT);
      expect(oneStepViewModel.getCurOneStepState()).assertEqual(OneStepState.ENTER_SPLIT);
      oneStepViewModel.setCurOneStepState(OneStepState.ENTER_FLOATING);
      expect(oneStepViewModel.getCurOneStepState()).assertEqual(OneStepState.ENTER_FLOATING);
      oneStepViewModel.setCurOneStepState(OneStepState.ENTER_FLOATING);
      oneStepViewModel.setCurOneStepState(OneStepState.ENTER_FLOATING);
      expect(true).assertTrue();
    })

    it('onOneStepStart', Level.LEVEL0, () => {
      containerSession.requestActivation(true)
      containerSession.isSplit = true;
      let mocker: MockKit = new MockKit();
      let fun_01: Function = mocker.mockFunc(SCBMultiWindowUtils, SCBMultiWindowUtils.isFoldableDeviceExpanded);
      let fun_02: Function = mocker.mockFunc(SCBMultiWindowUtils, SCBMultiWindowUtils.isVertical);
      when(fun_01)(ArgumentMatchers.any).afterReturn(false);
      when(fun_02)(ArgumentMatchers.any).afterReturn(false);
      oneStepViewModel.onOneStepStart(screenProperty, ScenePanelState.FULLSCENE, containerSession);
      expect(true).assertTrue();
      containerSession.isSplit = true;
      oneStepViewModel.onOneStepStart(screenProperty, ScenePanelState.SPLIT, containerSession);
      expect(true).assertTrue();
      containerSession.isSplit = true;
      oneStepViewModel.onOneStepStart(screenProperty, ScenePanelState.RECENT, containerSession);
      expect(true).assertTrue();

      when(fun_01)(ArgumentMatchers.any).afterReturn(false);
      when(fun_02)(ArgumentMatchers.any).afterReturn(true);
      containerSession.isSplit = false;
      oneStepViewModel.onOneStepStart(screenProperty, ScenePanelState.FULLSCENE, containerSession);
      expect(true).assertTrue();
      containerSession.isSplit = true;
      oneStepViewModel.onOneStepStart(screenProperty, ScenePanelState.SPLIT, containerSession);
      expect(true).assertTrue();
      containerSession.isSplit = false;
      oneStepViewModel.onOneStepStart(screenProperty, ScenePanelState.RECENT, containerSession);
      expect(true).assertTrue();

      containerSession.isSplit = false;
      when(fun_01)(ArgumentMatchers.any).afterReturn(true);
      when(fun_02)(ArgumentMatchers.any).afterReturn(false);
      oneStepViewModel.onOneStepStart(screenProperty, ScenePanelState.FULLSCENE, containerSession);
      expect(true).assertTrue();
      containerSession.isSplit = false;
      oneStepViewModel.onOneStepStart(screenProperty, ScenePanelState.SPLIT, containerSession);
      expect(true).assertTrue();
      containerSession.isSplit = false;
      oneStepViewModel.onOneStepStart(screenProperty, ScenePanelState.RECENT, containerSession);
      expect(true).assertTrue();

      when(fun_01)(ArgumentMatchers.any).afterReturn(true);
      when(fun_02)(ArgumentMatchers.any).afterReturn(true);
      oneStepViewModel.onOneStepStart(screenProperty, ScenePanelState.FULLSCENE, containerSession);
      expect(true).assertTrue();
      mocker.clear(fun_01);
      mocker.clear(fun_02);
    })

    it('onOneStepUpdate', Level.LEVEL0, () => {
      containerSession.primarySession = sceneSession;
      ReflectionUtils.setProperty(oneStepViewModel, 'isSupportSplitMode', false);
      oneStepViewModel.onOneStepUpdate(0, px2vp(1), px2vp(1));
      expect(true).assertTrue();
      oneStepViewModel.onOneStepUpdate(0, px2vp(11), px2vp(1));
      expect(true).assertTrue();
      oneStepViewModel.onOneStepUpdate(0, px2vp(22), px2vp(1));
      expect(true).assertTrue();
      oneStepViewModel.onOneStepUpdate(0, px2vp(1), px2vp(1));
      expect(true).assertTrue();
      oneStepViewModel.onOneStepUpdate(0, px2vp(11), px2vp(1));
      expect(true).assertTrue();
      oneStepViewModel.onOneStepUpdate(0, px2vp(26), px2vp(1));
      expect(true).assertTrue();
      oneStepViewModel.onOneStepUpdate(0, px2vp(30), px2vp(1));
      expect(true).assertTrue();
      oneStepViewModel.onOneStepUpdate(0, px2vp(40), px2vp(1));
      expect(true).assertTrue();
      oneStepViewModel.onOneStepUpdate(0, px2vp(50), px2vp(1));
      expect(true).assertTrue();
      oneStepViewModel.onOneStepUpdate(0, px2vp(60), px2vp(1));
      expect(true).assertTrue();
      oneStepViewModel.onOneStepUpdate(0, px2vp(88), px2vp(1));
      expect(true).assertTrue();
      oneStepViewModel.onOneStepUpdate(0, px2vp(79), px2vp(1));
      expect(true).assertTrue();
      oneStepViewModel.onOneStepStart(screenProperty, ScenePanelState.FULLSCENE, containerSession);
      ReflectionUtils.setProperty(oneStepViewModel, 'isSupportSplitMode', true);
      let mocker: MockKit = new MockKit();
      let fun_01: Function = mocker.mockFunc(oneStepViewModel, oneStepViewModel.isInEllipseArea);
      when(fun_01)(ArgumentMatchers.any).afterReturn(true);
      oneStepViewModel.onOneStepUpdate(px2vp(246), px2vp(326), px2vp(1));
      expect(true).assertTrue();
      ReflectionUtils.setProperty(oneStepViewModel, 'isSupportFloatingMode', true);
      ReflectionUtils.setProperty(oneStepViewModel, 'isSupportSplitMode', false);
      oneStepViewModel.onOneStepUpdate(px2vp(992), px2vp(326), px2vp(1));
      expect(true).assertTrue();
      let screenSessionManager = SCBScreenSessionManager.getInstance();
      let fun_02: Function = mocker.mockFunc(screenSessionManager,screenSessionManager.isFoldablePhoneExpandStatus);
      when(fun_02)(ArgumentMatchers.any).afterReturn(true);
      oneStepViewModel.onOneStepUpdate(px2vp(992), px2vp(326), px2vp(1));
      expect(true).assertTrue();
      SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PAD;
      oneStepViewModel.onOneStepUpdate(px2vp(992), px2vp(326), px2vp(1));
      expect(true).assertTrue();
      mocker.clear(fun_01);
      mocker.clear(fun_02);
      ReflectionUtils.setProperty(oneStepViewModel, 'isSupportMidSceneMode', true);
      oneStepViewModel.isFloatingToCorner = true;
      let fun_03: Function = mocker.mockFunc(oneStepViewModel, oneStepViewModel.isInOneStepMidSceneHotArea);
      when(fun_03)(ArgumentMatchers.any).afterReturn(true);
      let fun_04: Function = mocker.mockFunc(oneStepViewModel, oneStepViewModel.isInRectangleArea);
      when(fun_04)(ArgumentMatchers.any).afterReturn(true);
      oneStepViewModel.onOneStepUpdate(0, px2vp(78), px2vp(1));
      expect(oneStepViewModel.getCurOneStepState()).assertEqual(OneStepState.ENTER_MID_SCENE);
      ReflectionUtils.setProperty(oneStepViewModel, 'isSupportMidSceneMode', false);
      ReflectionUtils.setProperty(oneStepViewModel, 'isSupportFloatingMode', false);
      mocker.clear(fun_03);
      mocker.clear(fun_04);
    })

    it('onOneStepEnd', Level.LEVEL0, () => {
      screenProperty.width = 100;
      screenProperty.height = 100;
      containerSession.primarySession = sceneSession;
      containerSession.requestActivation();
      oneStepViewModel.onGestureChange = onGestureChange;
      containerSession.isSplit = false;
      oneStepViewModel.onOneStepEnd(0, 0);
      expect(true).assertTrue();
      containerSession.isSplit = false;
      oneStepViewModel.onOneStepEnd(-1, -1);
      expect(true).assertTrue();
      containerSession.isSplit = false;
      oneStepViewModel.onOneStepEnd(1, 1);
      expect(true).assertTrue();
      containerSession.isSplit = false;
      oneStepViewModel.onOneStepEnd(1, 0);
      expect(true).assertTrue();
      containerSession.isSplit = false;
      oneStepViewModel.onOneStepEnd(0, 1);
      expect(true).assertTrue();
      containerSession.isSplit = false;
      oneStepViewModel.onOneStepEnd(0, 11);
      expect(true).assertTrue();
      containerSession.isSplit = false;
      oneStepViewModel.onOneStepEnd(0, 22);
      expect(true).assertTrue();
      containerSession.isSplit = false;
      oneStepViewModel.onOneStepEnd(0, 26);
      expect(true).assertTrue();
      containerSession.isSplit = false;
      oneStepViewModel.onOneStepEnd(0, 30);
      expect(true).assertTrue();
      containerSession.isSplit = false;
      oneStepViewModel.onOneStepEnd(0, 40);
      expect(true).assertTrue();
      containerSession.isSplit = false;
      oneStepViewModel.onOneStepEnd(0, 50);
      expect(true).assertTrue();
      containerSession.isSplit = false;
      oneStepViewModel.onOneStepEnd(0, 60);
      expect(true).assertTrue();
      containerSession.isSplit = true;
      oneStepViewModel.onOneStepEnd(0, 60);
      expect(true).assertTrue();
      ReflectionUtils.setProperty(oneStepViewModel, 'isSupportMidSceneMode', true);
      let mocker: MockKit = new MockKit();
      let fun_01: Function = mocker.mockFunc(oneStepViewModel, oneStepViewModel.isInRectangleArea);
      when(fun_01)(ArgumentMatchers.any).afterReturn(true);
      let scenePanelManager = SCBScenePanelManager.getInstance();
      containerSession.isSplit = true;
      containerSession.secondarySession = secondarySceneSession;
      let fun_02: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      let array = new SCBSceneContainerSessionArray();
      array.push(containerSession);
      when(fun_02)(ArgumentMatchers.any).afterReturn(array)
      let fun_03: Function = mocker.mockFunc(oneStepViewModel, oneStepViewModel.isInOneStepMidSceneHotArea);
      when(fun_03)(ArgumentMatchers.any).afterReturn(true);
      oneStepViewModel.onOneStepEnd(px2vp(50), px2vp(20));
      expect(OneStepState.SHOW_ONLY_BG === oneStepViewModel.getCurOneStepState()).assertFalse();
      ReflectionUtils.setProperty(oneStepViewModel, 'isSupportMidSceneMode', false);
      mocker.clear(fun_01);
      mocker.clear(fun_02);
      mocker.clear(fun_03);
    })

    it('floatingWindowAvoidAnim', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let scenePanelManager = SCBScenePanelManager.getInstance();
      let fun_02: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getActiveFloatContainerList);
      let activeSessionList = new Array<SCBSceneSession>();
      activeSessionList[0] = sceneSession;
      activeSessionList[1] = secondarySceneSession;
      containerSession.secondarySession
      ReflectionUtils.setProperty(oneStepViewModel, 'isSupportSplitMode', false);
      containerSession.requestActivation();
      oneStepViewModel.floatingWindowAvoidAnim(-1);
      expect(true).assertTrue();
      oneStepViewModel.floatingWindowAvoidAnim(0);
      expect(true).assertTrue();
      oneStepViewModel.floatingWindowAvoidAnim(1);
      expect(true).assertTrue();
      ReflectionUtils.setProperty(oneStepViewModel, 'isSupportSplitMode', true);
      oneStepViewModel.floatingWindowAvoidAnim(10);
      expect(true).assertTrue();
      oneStepViewModel.floatingWindowAvoidAnim(20);
      expect(true).assertTrue();
      oneStepViewModel.floatingWindowAvoidAnim(50);
      expect(true).assertTrue();
      oneStepViewModel.floatingWindowAvoidAnim(100);
      expect(true).assertTrue();
      when(fun_02)(ArgumentMatchers.any).afterReturn(activeSessionList);
      oneStepViewModel.floatingWindowAvoidAnim(1000);
      expect(true).assertTrue();
      mocker.clear(fun_02);
      ReflectionUtils.setProperty(oneStepViewModel, 'isSupportSplitMode', false);
      mocker.clear(scenePanelManager);
    })

    it('consumeStartEvent', Level.LEVEL0, () => {
      oneStepViewModel.consumeStartEvent(event);
      expect(true).assertTrue();
    })

    it('consumeUpdateEvent', Level.LEVEL0, () => {
      oneStepViewModel.consumeUpdateEvent(event, 1);
      expect(true).assertTrue();
      event.offsetY = 0;
      oneStepViewModel.consumeUpdateEvent(event, 1);
      expect(true).assertTrue();

      event.fingerList[0] = {
        globalX: 1,
        globalY: 2,
        id: 1,
        localX: 1,
        localY: 2,
        displayX: 1,
        displayY: 2
      };
      ReflectionUtils.setProperty(oneStepViewModel, 'isFloatingToCorner', false);
      oneStepViewModel.consumeUpdateEvent(event, 1);
      expect(true).assertTrue();
    })

    it('consumeEndEvent', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let fun_01: Function = mocker.mockFunc(DockUtils, DockUtils.isSupportFullDock);
      when(fun_01)(ArgumentMatchers.any).afterReturn(false);
      oneStepViewModel.consumeEndEvent(event);
      expect(true).assertTrue();
      when(fun_01)(ArgumentMatchers.any).afterReturn(true);
      oneStepViewModel.consumeEndEvent(event);
      expect(true).assertTrue();

      event.fingerList[0] = {
        globalX: 1,
        globalY: 2,
        id: 1,
        localX: 1,
        localY: 2,
        displayX: 1,
        displayY: 2
      };
      oneStepViewModel.consumeEndEvent(event);
      expect(true).assertTrue();

      event.fingerList = [];
      oneStepViewModel.consumeEndEvent(event);
      expect(true).assertTrue();
      mocker.clear(fun_01);
    })

    it('setFloatingModelParamsForPad', Level.LEVEL0, () => {
      oneStepViewModel.setFloatingModelParamsForPad();
      expect(true).assertTrue();
      let mocker: MockKit = new MockKit();
      let floatManager = SCBFloatManager.getInstance();
      let fun_01: Function = mocker.mockFunc(floatManager, floatManager.isLandscapeFloat);
      when(fun_01)(ArgumentMatchers.any).afterReturn(true);
      oneStepViewModel.setFloatingModelParamsForPad();
      expect(true).assertTrue();
      mocker.clear(fun_01);
    })

    it('doBgAndIconFastAnimationIfNeed', Level.LEVEL0, () => {
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(0, 0);
      expect(true).assertTrue();
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(0, 1);
      expect(true).assertTrue();
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(10, 10);
      expect(true).assertTrue();
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(20, 20);
      expect(true).assertTrue();
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(30, 30);
      expect(true).assertTrue();
    })

    it('onEnterOneStepSplitHotArea', Level.LEVEL0, () => {
      oneStepViewModel.onEnterOneStepSplitHotArea(0);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepSplitHotArea(90);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepSplitHotArea(180);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepSplitHotArea(270);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepSplitHotArea(360);
      expect(true).assertTrue();
    })

    it('onEnterOneStepFloatingHotArea', Level.LEVEL0, () => {
      oneStepViewModel.onEnterOneStepFloatingHotArea(0);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepFloatingHotArea(90);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepFloatingHotArea(180);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepFloatingHotArea(270);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepFloatingHotArea(360);
      expect(true).assertTrue();
    })

    it('onEnterOneStepSplitHotAreaTestAdd', Level.LEVEL0, () => {
      oneStepViewModel.onEnterOneStepSplitHotArea(-90);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepSplitHotArea(-45);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepSplitHotArea(-1);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepSplitHotArea(0);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepSplitHotArea(1);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepSplitHotArea(45);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepSplitHotArea(90);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepSplitHotArea(130);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepSplitHotArea(180);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepSplitHotArea(200);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepSplitHotArea(270);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepSplitHotArea(300);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepSplitHotArea(360);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepSplitHotArea(361);
      expect(true).assertTrue();
    })

    it('onEnterOneStepFloatingHotAreaTestAdd', Level.LEVEL0, () => {
      oneStepViewModel.onEnterOneStepFloatingHotArea(-90);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepFloatingHotArea(-45);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepFloatingHotArea(-1);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepFloatingHotArea(0);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepFloatingHotArea(1);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepFloatingHotArea(45);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepFloatingHotArea(90);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepFloatingHotArea(130);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepFloatingHotArea(180);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepFloatingHotArea(200);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepFloatingHotArea(270);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepFloatingHotArea(300);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepFloatingHotArea(360);
      expect(true).assertTrue();
      oneStepViewModel.onEnterOneStepFloatingHotArea(361);
      expect(true).assertTrue();
    })

    it('doBgAndIconFastAnimationIfNeedTestAdd', Level.LEVEL0, () => {
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(0, 0);
      expect(true).assertTrue();
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(0, 1);
      expect(true).assertTrue();
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(1, 0);
      expect(true).assertTrue();
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(1, 1);
      expect(true).assertTrue();
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(10, 0);
      expect(true).assertTrue();
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(0, 10);
      expect(true).assertTrue();
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(10, 10);
      expect(true).assertTrue();
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(0, 20);
      expect(true).assertTrue();
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(20, 0);
      expect(true).assertTrue();
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(20, 20);
      expect(true).assertTrue();
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(0, 30);
      expect(true).assertTrue();
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(30, 0);
      expect(true).assertTrue();
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(30, 30);
      expect(true).assertTrue();
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(0, 50);
      expect(true).assertTrue();
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(50, 0);
      expect(true).assertTrue();
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(50, 50);
      expect(true).assertTrue();
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(0, 1080);
      expect(true).assertTrue();
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(1080, 0);
      expect(true).assertTrue();
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(1080, 2504);
      expect(true).assertTrue();
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(0, 2504);
      expect(true).assertTrue();
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(2504, 0);
      expect(true).assertTrue();
      oneStepViewModel.doBgAndIconFastAnimationIfNeed(2504, 1080);
      expect(true).assertTrue();
    })

    it('consumeUpdateEventTestAdd', Level.LEVEL0, () => {
      oneStepViewModel.consumeUpdateEvent(event, 0);
      oneStepViewModel.consumeUpdateEvent(event, 1);
      oneStepViewModel.consumeUpdateEvent(event, 10);
      oneStepViewModel.consumeUpdateEvent(event, 50);
      oneStepViewModel.consumeUpdateEvent(event, 100);
      expect(true).assertTrue();
      event.offsetY = 0;
      oneStepViewModel.consumeUpdateEvent(event, 0);
      oneStepViewModel.consumeUpdateEvent(event, 1);
      oneStepViewModel.consumeUpdateEvent(event, 10);
      oneStepViewModel.consumeUpdateEvent(event, 50);
      oneStepViewModel.consumeUpdateEvent(event, 100);
      expect(true).assertTrue();

      event.fingerList[0] = {
        globalX: 2,
        globalY: 2,
        id: 2,
        localX: 2,
        localY: 3,
        displayX: 2,
        displayY: 2
      };
      ReflectionUtils.setProperty(oneStepViewModel, 'isFloatingToCorner', false);
      oneStepViewModel.consumeUpdateEvent(event, 1);

      event.fingerList[0] = {
        globalX: 0,
        globalY: 0,
        id: 2,
        localX: 0,
        localY: 0,
        displayX: 0,
        displayY: 0
      };
      ReflectionUtils.setProperty(oneStepViewModel, 'isFloatingToCorner', false);
      oneStepViewModel.consumeUpdateEvent(event, 1);

      event.fingerList[0] = {
        globalX: 2,
        globalY: 2,
        id: 2,
        localX: 2,
        localY: 3,
        displayX: 2,
        displayY: 2
      };
      ReflectionUtils.setProperty(oneStepViewModel, 'isFloatingToCorner', false);
      oneStepViewModel.consumeUpdateEvent(event, 1);
      expect(true).assertTrue();

      event.fingerList[0] = {
        globalX: 10,
        globalY: 0,
        id: 2,
        localX: 2,
        localY: 3,
        displayX: 2,
        displayY: 2
      };
      ReflectionUtils.setProperty(oneStepViewModel, 'isFloatingToCorner', false);
      oneStepViewModel.consumeUpdateEvent(event, 1);
      expect(true).assertTrue();

      event.fingerList[0] = {
        globalX: 0,
        globalY: 10,
        id: 2,
        localX: 2,
        localY: 3,
        displayX: 2,
        displayY: 2
      };
      ReflectionUtils.setProperty(oneStepViewModel, 'isFloatingToCorner', false);
      oneStepViewModel.consumeUpdateEvent(event, 1);

      event.fingerList[0] = {
        globalX: 10,
        globalY: 0,
        id: 2,
        localX: 0,
        localY: 10,
        displayX: 0,
        displayY: 10
      };
      ReflectionUtils.setProperty(oneStepViewModel, 'isFloatingToCorner', false);
      oneStepViewModel.consumeUpdateEvent(event, 1);

      event.fingerList[0] = {
        globalX: 0,
        globalY: 10,
        id: 2,
        localX: 0,
        localY: 10,
        displayX: 0,
        displayY: 10
      };
      ReflectionUtils.setProperty(oneStepViewModel, 'isFloatingToCorner', false);
      oneStepViewModel.consumeUpdateEvent(event, 1);

      event.fingerList[0] = {
        globalX: 0,
        globalY: 10,
        id: 2,
        localX: 10,
        localY: 0,
        displayX: 10,
        displayY: 0
      };
      ReflectionUtils.setProperty(oneStepViewModel, 'isFloatingToCorner', false);
      oneStepViewModel.consumeUpdateEvent(event, 1);

      event.fingerList[0] = {
        globalX: 10,
        globalY: 10,
        id: 2,
        localX: 10,
        localY: 0,
        displayX: 10,
        displayY: 0
      };
      ReflectionUtils.setProperty(oneStepViewModel, 'isFloatingToCorner', false);
      oneStepViewModel.consumeUpdateEvent(event, 1);

      event.fingerList[0] = {
        globalX: 10,
        globalY: 10,
        id: 2,
        localX: 0,
        localY: 10,
        displayX: 0,
        displayY: 10
      };
      ReflectionUtils.setProperty(oneStepViewModel, 'isFloatingToCorner', false);
      oneStepViewModel.consumeUpdateEvent(event, 1);
    })
  });
}