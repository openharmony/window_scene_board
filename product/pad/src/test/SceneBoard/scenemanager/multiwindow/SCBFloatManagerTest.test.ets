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
import { ArgumentMatchers, beforeAll, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import { RectInfo } from '@ohos/basicutils';
import {
  CornerArea,
  RecentFloatingAnimParams,
  SCBFloatingParam,
  SCBSceneContainerSession,
  SCBSceneContainerState,
  SCBSceneInfo,
  SCBSceneSession, SCBScreenProperty,
  SCBSessionRect,
  SCBSideEdgeBarOptions } from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  SCBScreenSessionManager,
  SCBPropertyChangeReason,
  SCBScenePanelManager,
  PreferMultiWindowOrientation,
  SCBSceneSessionManager,
  UserAction
} from '@ohos/windowscene';
import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { RectItem, } from '@ohos/basicutils';
import { SCBConstants } from '@ohos/commonconstants';
import {
  SCBSceneContainerSessionArray} from '@ohos/windowscene';
import { SCBFloatManager } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBFloatManager';
import { SCBSideEdgeBarManager } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBSideEdgeBarManager';
import { ReflectionUtils } from './ReflectionUtils';
import { SCBMultiWindowUtils } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBMultiWindowUtils';
import { FloatRect } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/utils/FloatUtils';
import { RecentNotShow } from '../../../../main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentNotShow';

const FOCUSED_SHADOW_RADIUS: number = 215;
const FOCUSED_SHADOW_OFFSET_X: number = 0;
const FOCUSED_SHADOW_OFFSET_Y: number = 30;
const FOCUSED_SHADOW_COLOR: string = '#73000000';

let floatManager: SCBFloatManager = SCBFloatManager.getInstance();
let containerSession: SCBSceneContainerSession;
let containerSession2: SCBSceneContainerSession;
let sceneInfo: SCBSceneInfo;
let sceneInfo2: SCBSceneInfo;
let sceneInfoForNull: SCBSceneInfo;
let sceneSession: SCBSceneSession;
let sceneSession2: SCBSceneSession;
let sceneSessionForNull: SCBSceneSession;
let floatingParam: SCBFloatingParam;
let shadowOptions: ShadowOptions =
  {
    radius: FOCUSED_SHADOW_RADIUS * 0.3,
    offsetX: FOCUSED_SHADOW_OFFSET_X * 0.3,
    offsetY: FOCUSED_SHADOW_OFFSET_Y * 0.3,
    color: FOCUSED_SHADOW_COLOR
  };
let delHotArea: RectItem = new RectItem(0, 0, 0, 0);
let preDelHotArea: RectItem = new RectItem(0, 0, 0, 0);
let screenWidth: number = 0;
let screenHeight: number = 0;
let animationFinishedCallback: (flag: boolean) => void;
let floatingSessionList: SCBSceneContainerSessionArray;
let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
let floatContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
let  screenProperty: SCBScreenProperty = new SCBScreenProperty();
let assertFlag: boolean = true;

let initAll = () => {
  sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
  sceneInfo2 = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 1);
  sceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  sceneSession2 = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
  floatingParam = new SCBFloatingParam();
  screenWidth = 1260;
  screenHeight = 2440;
  floatingSessionList = new SCBSceneContainerSessionArray();
  screenProperty.width = 1260;
  screenProperty.height = 2440;
  screenProperty.screenId = 0;
  screenProperty.rotation = 0;
  containerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
  containerSession2 = new SCBSceneContainerSession(sceneSession2, screenProperty);
  floatContainerSessionList.add(containerSession);
  totalContainerSessionList.add(containerSession2);
}

export function SCBFloatManagerTest() {
  beforeAll(initAll);
  animateOnMinToSideTest();
  SCBFloatManagerTest_02();
  SCBFloatManagerTest_03();
  SCBFloatManagerTest_04();
  SCBFloatManagerTest_05();
  SCBFloatManagerTest_06();
  SCBFloatManagerTest_07();
  SCBFloatManagerTest_08();
  SCBFloatManagerTest_09();
  SCBFloatManagerTest_10();
  SCBFloatManagerTest_11();
  SCBFloatManagerTest_12();
  SCBFloatManagerTest_13();
  SCBFloatManagerTest_14();
  SCBFloatManagerTest_15();
  SCBFloatManagerTest_57();
  SCBFloatManagerTest_58();
  SCBFloatManagerTest_59();
  SCBFloatManagerTest_60();
}

function animateOnMinToSideTest() {
  describe('animateOnMinToSideTest', () => {
    it('animateOnMinToSideTest_01', Level.LEVEL0, () => {
      floatManager.animateOnMinToSide(containerSession, true);
      expect(containerSession.getState()).assertEqual(SCBSceneContainerState.HIDDEN);
    })

    it('animateOnMinToSideTest_02', Level.LEVEL0, () => {
      floatManager.animateOnMinToSide(containerSession, false);
      expect(containerSession.getState()).assertEqual(SCBSceneContainerState.HIDDEN);
    })
  })
}


function SCBFloatManagerTest_02() {
  describe('SCBFloatManagerTest_02', () => {

    it('delPadFloatingSessionList', Level.LEVEL0, () => {
      let id: number = containerSession.containerId;
      floatManager.delPadFloatingSessionList(id);
      expect(floatManager.getPadFloatingSessionList().findByContainerId(id)).assertEqual(-1);
    })

    it('notifyDockToFloatTransition', Level.LEVEL0, () => {
      let floatingRect: RectItem = new RectItem(0, 0, 0, 0);
      let iconRectInfo: RectInfo = new RectInfo();
      floatManager.notifyDockToFloatTransition(containerSession, floatingRect, iconRectInfo);
      let callback = (container: SCBSceneContainerSession, floatingRect: RectItem, iconRectInfo: RectInfo) => {};
      floatManager.registerDockToFloatingTransitionCallback(callback);
      floatManager.notifyDockToFloatTransition(containerSession, floatingRect, iconRectInfo);
      expect(ReflectionUtils.getProperty(floatManager, 'onDockToFloatingTransitionCallback')).not().assertUndefined();
    })

    it('onDockToFloatingTransitionBreak', Level.LEVEL0, () => {
      floatManager.onDockToFloatingTransitionBreak();
      let callback = () => {};
      floatManager.registerDockToFloatingTransitionBreakCallback(callback);
      floatManager.onDockToFloatingTransitionBreak();
      expect(containerSession.isDisappearing).assertTrue();
    })

    it('closeFloatingWindow', Level.LEVEL0, () => {
      floatingParam.isClosingFloat = false;
      floatingParam.minAnimationNum = 0;
      floatingParam.shadowOptions = shadowOptions;
      floatingParam.isMinFloating = true;
      floatingParam.needRecoverStatusBar = true;
      containerSession.floatingParam = floatingParam;
      floatManager.closeFloatingWindow(containerSession, false);
      expect(containerSession.isDisappearing).assertTrue();
    })

    it('closeFloatingWindowByDumpsters', Level.LEVEL0, () => {
      floatingParam.isClosingFloat = false;
      floatingParam.minAnimationNum = 0;
      floatingParam.shadowOptions = shadowOptions;
      floatingParam.isMinFloating = false;
      containerSession.floatingParam = floatingParam;
      floatManager.closeFloatingWindow(containerSession, true);
      expect(containerSession.isDisappearing).assertTrue();
    })
  });
}

function SCBFloatManagerTest_03() {
  describe('SCBFloatManagerTest_03', () => {
    it('getTopActiveFloatContainer_01', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let scenePanelManager = SCBScenePanelManager.getInstance();
      let func: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(func)(ArgumentMatchers.any).afterReturn(floatContainerSessionList);
      containerSession.requestActivation();
      expect(floatManager.getTopActiveFloatContainer()).not().assertNull();
      mocker.clear(scenePanelManager);
    })

    it('getTopActiveFloatContainer_02', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let scenePanelManager = SCBScenePanelManager.getInstance();
      let func: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(func)(ArgumentMatchers.any).afterReturn([]);
      expect(floatManager.getTopActiveFloatContainer()).assertNull();
      mocker.clear(scenePanelManager);
    })

    it('notifyFoldOrExpandWithAnimation_02', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let scenePanelManager = SCBScenePanelManager.getInstance();
      let func: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      let array = new SCBSceneContainerSessionArray();
      when(func)(ArgumentMatchers.any).afterReturn(array);
      floatManager.notifyFoldOrExpandWithAnimation(new SCBScreenProperty(), SCBPropertyChangeReason.FOLD_TO_EXPAND);
      mocker.clear(scenePanelManager);

      containerSession.floatingParam.isMinimized = false;
      containerSession.floatingParam.isClosed = false;
      containerSession.floatingParam.isTerminated = false;
      array.push(containerSession);
      when(func)(ArgumentMatchers.any).afterReturn(array);
      floatManager.notifyFoldOrExpandWithAnimation(new SCBScreenProperty(), SCBPropertyChangeReason.EXPAND_TO_FOLD);
      expect(true).assertTrue();
      mocker.clear(scenePanelManager);
    })
  });
}

function SCBFloatManagerTest_04() {
  describe('SCBFloatManagerTest_04', () => {
    it('notifyFoldOrExpandWithAnimation_03', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let scenePanelManager = SCBScenePanelManager.getInstance();
      let func: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      let array = new SCBSceneContainerSessionArray();
      containerSession.floatingParam.isMinimized = false;
      containerSession.floatingParam.isClosed = false;
      containerSession.floatingParam.isTerminated = false;
      array.push(containerSession);
      when(func)(ArgumentMatchers.any).afterReturn(array);
      floatManager.notifyFoldOrExpandWithAnimation(new SCBScreenProperty(), SCBPropertyChangeReason.EXPAND_TO_FOLD);
      expect(true).assertTrue();
      mocker.clear(scenePanelManager);
    })

    it('notifyFoldOrExpandWithAnimation_04', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let scenePanelManager = SCBScenePanelManager.getInstance();
      let func1: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      let array = new SCBSceneContainerSessionArray();
      containerSession.floatingParam.isFloatDragging = true;
      containerSession.requestActivation();
      containerSession.isFloat = true;
      containerSession.floatingParam.isMinimized = false;
      containerSession.floatingParam.setFloatingSceneClosed(false);
      array.push(containerSession);
      when(func1)(ArgumentMatchers.any).afterReturn(array);
      floatManager.notifyFoldOrExpandWithAnimation(new SCBScreenProperty(), SCBPropertyChangeReason.FOLD_TO_EXPAND);
      expect(true).assertTrue();
      mocker.clear(scenePanelManager);
    })

    it('notifyFoldOrExpandWithAnimation_05', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let scenePanelManager = SCBScenePanelManager.getInstance();
      let func1: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      let array = new SCBSceneContainerSessionArray();
      containerSession.floatingParam.isFloatDragging = false;
      containerSession.requestActivation();
      containerSession.isFloat = true;
      containerSession.floatingParam.isMinimized = false;
      containerSession.floatingParam.setFloatingSceneClosed(false);
      array.push(containerSession);
      when(func1)(ArgumentMatchers.any).afterReturn(array);
      floatManager.notifyFoldOrExpandWithAnimation(new SCBScreenProperty(), SCBPropertyChangeReason.FOLD_TO_EXPAND);
      expect(true).assertTrue();
      mocker.clear(scenePanelManager);
    })
  });
}

function SCBFloatManagerTest_05() {
  describe('SCBFloatManagerTest_05', () => {
    it('enterFloatViewFromNotification', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let sceneSessionManager = SCBSceneSessionManager.getInstance();
      let func1: Function = mocker.mockFunc(sceneSessionManager, sceneSessionManager.registerOnAnimationFinishedCallback);
      when(func1)(ArgumentMatchers.any).afterReturnNothing();
      let func2: Function = mocker.mockFunc(sceneSessionManager, sceneSessionManager.notifyNtfFloatingRect);
      when(func2)(ArgumentMatchers.any).afterReturnNothing();
      let func3: Function = mocker.mockFunc(sceneSessionManager, sceneSessionManager.refreshZOrder);
      when(func3)(ArgumentMatchers.any).afterReturnNothing();
      containerSession.isFloat = false;
      containerSession.floatingParam.scale = 0.7;
      if (containerSession.primarySession) {
        containerSession.primarySession.preferMultiWindowOrientation = PreferMultiWindowOrientation.DEFAULT;
      }
      floatManager.enterFloatViewFromNotification(containerSession, new SCBScreenProperty());
      expect(true).assertTrue();
      mocker.clear(sceneSessionManager);
    })

    it('calcNotifyFloatingSizeAndPos', Level.LEVEL0, () => {
      floatManager.calcNotifyFloatingSizeAndPos(floatingParam, new SCBScreenProperty());
    })

    it('floatCenterRect1', Level.LEVEL0, () => {
      containerSession.floatingParam.setUserAction(UserAction.NONE);
      SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PHONE;
      floatManager.floatCenterRect(containerSession, new SCBScreenProperty());
    })

    it('floatCenterRect2', Level.LEVEL0, () => {
      containerSession.floatingParam.setUserAction(UserAction.NONE);
      SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PAD;
      floatManager.floatCenterRect(containerSession, new SCBScreenProperty());
    })

    it('minimizeAllFloatContainer', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let scenePanelManager = SCBScenePanelManager.getInstance();
      let sideEdgeBarManager = SCBSideEdgeBarManager.getInstance();
      let func1: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      let func2: Function = mocker.mockFunc(sideEdgeBarManager, sideEdgeBarManager.hideSideEdgeBar);
      containerSession.setActivationAtToggleHomeScenario();
      containerSession.isFloat = true;
      containerSession.floatingParam.isMinimized = false;
      containerSession.floatingParam.setFloatingSceneClosed(false);
      floatingSessionList.push(containerSession);
      when(func1)(ArgumentMatchers.any).afterReturn(floatingSessionList);
      when(func2)(ArgumentMatchers.any).afterReturnNothing();
      containerSession.floatingParam.setUserAction(UserAction.QUICK_MIN);
      floatManager.minimizeAllFloatContainer();
      expect(true).assertTrue();
      mocker.clear(scenePanelManager);
      mocker.clear(sideEdgeBarManager);
    });
  });
}

function SCBFloatManagerTest_06() {
  describe('SCBFloatManagerTest_06', () => {
    it('repositionExistingFloatingWindow_03', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let scenePanelManager = SCBScenePanelManager.getInstance();
      let screenSessionManager = SCBScreenSessionManager.getInstance();
      let func1: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      let func2: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);
      when(func2)(ArgumentMatchers.any).afterReturn(false);
      SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PHONE;
      let list = new Array<SCBSceneContainerSession>();
      containerSession.isFloat = true;
      containerSession.floatingParam.isMinimized = false;
      containerSession.floatingParam.setFloatingSceneClosed(false);
      list.push(containerSession);
      when(func1)(ArgumentMatchers.any).afterReturn(list);
      floatManager.repositionExistingFloatingWindow(new SCBScreenProperty(), containerSession);
      expect(true).assertTrue();
      mocker.clear(scenePanelManager);
      mocker.clear(screenSessionManager);
    })

    it('repositionExistingFloatingWindow_04', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let scenePanelManager = SCBScenePanelManager.getInstance();
      let func1: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      let list = new Array<SCBSceneContainerSession>();
      containerSession.isFloat = true;
      containerSession.floatingParam.isMinimized = false;
      containerSession.floatingParam.setFloatingSceneClosed(false);
      list.push(containerSession);
      when(func1)(ArgumentMatchers.any).afterReturn(list);
      floatManager.repositionExistingFloatingWindow(new SCBScreenProperty(), containerSession);
      expect(true).assertTrue();
      mocker.clear(scenePanelManager);
    })

    it('repositionExistingFloatingWindow_05', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let scenePanelManager = SCBScenePanelManager.getInstance();
      let func1: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PAD;
      let list = new Array<SCBSceneContainerSession>();
      containerSession.isFloat = true;
      containerSession.floatingParam.isMinimized = false;
      containerSession.floatingParam.setFloatingSceneClosed(false);
      list.push(containerSession);
      when(func1)(ArgumentMatchers.any).afterReturn(list);
      floatManager.repositionExistingFloatingWindow(new SCBScreenProperty(), containerSession);
      expect(true).assertTrue();
      mocker.clear(scenePanelManager);
    })

    it('repositionExistingFloatingWindow_06', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let scenePanelManager = SCBScenePanelManager.getInstance();
      let func1: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PHONE;
      let list = new Array<SCBSceneContainerSession>();
      containerSession.isFloat = true;
      containerSession.floatingParam.isMinimized = false;
      containerSession.floatingParam.setFloatingSceneClosed(false);
      list.push(containerSession);
      when(func1)(ArgumentMatchers.any).afterReturn(list);
      floatManager.repositionExistingFloatingWindow(new SCBScreenProperty(), containerSession);
      expect(true).assertTrue();
      mocker.clear(scenePanelManager);
    })
  });
}

function SCBFloatManagerTest_07() {
  describe('SCBFloatManagerTest_07', () => {
    it('oneStepEnterFloat_01', Level.LEVEL0, () => {
      SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PAD;
      let mocker: MockKit = new MockKit();
      let screenSessionManager = SCBScreenSessionManager.getInstance();
      let func1: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      floatManager.oneStepEnterFloat(containerSession, new SCBScreenProperty());
      expect(true).assertTrue();
      mocker.clear(screenSessionManager);
    })

    it('calcDefaultSizeAndPos_01', Level.LEVEL0, () => {
      SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PAD;
      let mocker: MockKit = new MockKit();
      let screenSessionManager = SCBScreenSessionManager.getInstance();
      let func1: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      floatManager.calcDefaultSizeAndPos(floatingParam, new SCBScreenProperty());
      expect(true).assertTrue();
      mocker.clear(screenSessionManager);
    })

    it('calcDefaultSizeAndPos_02', Level.LEVEL0, () => {
      SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PHONE;
      let mocker: MockKit = new MockKit();
      let screenSessionManager = SCBScreenSessionManager.getInstance();
      let func1: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      floatManager.calcDefaultSizeAndPos(floatingParam, new SCBScreenProperty());
      expect(true).assertTrue();
      mocker.clear(screenSessionManager);
    })

    it('calcDefaultSizeAndPos_03', Level.LEVEL0, () => {
      SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PHONE;
      let mocker: MockKit = new MockKit();
      let screenSessionManager = SCBScreenSessionManager.getInstance();
      let func1: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      let screenProperty = new SCBScreenProperty();
      screenProperty.rotation = 0;
      floatManager.calcDefaultSizeAndPos(floatingParam, screenProperty);
      expect(true).assertTrue();
      mocker.clear(screenSessionManager);
    })

    it('calcDefaultSizeAndPos_04', Level.LEVEL0, () => {
      SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PHONE;
      let mocker: MockKit = new MockKit();
      let screenSessionManager = SCBScreenSessionManager.getInstance();
      let func1: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      let screenProperty = new SCBScreenProperty();
      screenProperty.rotation = 90;
      floatManager.calcDefaultSizeAndPos(floatingParam, screenProperty);
      expect(true).assertTrue();
      mocker.clear(screenSessionManager);
    })
  });
}

function SCBFloatManagerTest_08() {
  describe('SCBFloatManagerTest_08', () => {
    it('moveToDefaultMiniFloat_01', Level.LEVEL0, () => {
      SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PAD;
      let mocker1: MockKit = new MockKit();
      let screenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let func1: Function = mocker1.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);
      when(func1)(ArgumentMatchers.any).afterReturn(false);
      let screenProperty = new SCBScreenProperty();
      screenProperty.rotation = 0;
      containerSession.floatingParam.calcRatioBaseWidth = 100;
      floatManager.moveToDefaultMiniFloat(containerSession, screenProperty);
      expect(assertFlag).assertTrue();
      mocker1.clear(func1);
    })

    it('moveToDefaultMiniFloat_02', Level.LEVEL0, () => {
      SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PAD;
      let mocker: MockKit = new MockKit();
      let screenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let func1: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      let screenProperty = new SCBScreenProperty();
      screenProperty.width = 1000;
      screenProperty.width = 2000;
      containerSession.floatingParam.calcRatioBaseWidth = 100;
      floatManager.moveToDefaultMiniFloat(containerSession, screenProperty);
      expect(assertFlag).assertTrue();
      mocker.clear(func1);
    })
  });
}

function SCBFloatManagerTest_09() {
  describe('SCBFloatManagerTest_09', () => {
    it('repositionExistingFloatingWindow_01', Level.LEVEL0, () => {
      let mocker1: MockKit = new MockKit();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance();
      let func1: Function = mocker1.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(func1)(ArgumentMatchers.any).afterReturn(null);
      floatManager.repositionExistingFloatingWindow(new SCBScreenProperty(), containerSession);
      expect(assertFlag).assertTrue();
      mocker1.clear(func1);
    })

    it('repositionExistingFloatingWindow_02', Level.LEVEL0, () => {
      let mocker1: MockKit = new MockKit();
      let scenePanelManager = SCBScenePanelManager.getInstance();
      let screenSessionManager = SCBScreenSessionManager.getInstance();
      let func1: Function = mocker1.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      let func2: Function = mocker1.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);
      when(func2)(ArgumentMatchers.any).afterReturn(true);

      let list: SCBSceneContainerSession[] = new Array<SCBSceneContainerSession>();
      list.push(containerSession);
      when(func1)(ArgumentMatchers.any).afterReturn(list);
      floatManager.repositionExistingFloatingWindow(new SCBScreenProperty(), containerSession);
      expect(assertFlag).assertTrue();
      mocker1.clear(func1);
      mocker1.clear(func2);
    })
  });
}

function SCBFloatManagerTest_10() {
  describe('SCBFloatManagerTest_10', () => {
    it('resetReservedFloating_01', Level.LEVEL0, () => {
      let mocker1: MockKit = new MockKit();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance();
      let func1: Function = mocker1.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(func1)(ArgumentMatchers.any).afterReturn(null);

      SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PAD;
      containerSession.floatingParam.cornerParam.area = CornerArea.MAIN;
      floatManager.resetReservedFloating(containerSession, new SCBScreenProperty(), containerSession);
      expect(assertFlag).assertTrue();
      mocker1.clear(func1);
    })

    it('resetReservedFloating_02', Level.LEVEL0, () => {
      let mocker1: MockKit = new MockKit();
      let scenePanelManager = SCBScenePanelManager.getInstance();
      let func1: Function = mocker1.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(func1)(ArgumentMatchers.any).afterReturn(null);

      SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PHONE;
      containerSession.floatingParam.cornerParam.area = CornerArea.MAIN;
      floatManager.resetReservedFloating(containerSession, new SCBScreenProperty(), containerSession);
      expect(assertFlag).assertTrue();
      mocker1.clear(func1);
    })

    it('onRemoveFloatingScene_01', Level.LEVEL0, () => {
      floatManager.onRemoveFloatingScene(sceneSession);
      expect(assertFlag).assertTrue();

      let mocker1: MockKit = new MockKit();
      let scenePanelManager = SCBScenePanelManager.getInstance();
      let func1: Function = mocker1.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      let array = new SCBSceneContainerSessionArray();
      array.push(containerSession);
      when(func1)(ArgumentMatchers.any).afterReturn(array);
      floatManager.onRemoveFloatingScene(sceneSession);
      expect(assertFlag).assertTrue();
      mocker1.clear(func1);
    })

    it('onRemoveFloatingScene_02', Level.LEVEL0, () => {
      let mocker1: MockKit = new MockKit();
      let scenePanelManager = SCBScenePanelManager.getInstance();
      let func1: Function = mocker1.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      when(func1)(ArgumentMatchers.any).afterReturn(floatContainerSessionList);
      floatManager.updateFloatContainerWithScreenChange(containerSession.screenProperty, screenWidth);
      expect(assertFlag).assertTrue();
      floatManager.updateFloatContainerWithScreenChange(containerSession.screenProperty, screenWidth);
      expect(assertFlag).assertTrue();
      let screenSessionManager = SCBScreenSessionManager.getInstance();
      let func2: Function = mocker1.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);
      when(func2)(ArgumentMatchers.any).afterReturn(false);
      floatManager.updateFloatContainerWithScreenChange(containerSession.screenProperty, screenWidth);
      expect(assertFlag).assertTrue();
      when(func2)(ArgumentMatchers.any).afterReturn(true);
      floatManager.updateFloatContainerWithScreenChange(containerSession.screenProperty, screenWidth);
      expect(assertFlag).assertTrue();
      mocker1.clear(func1);
      mocker1.clear(func2);
    })

    it('onRemoveFloatingScene_03', Level.LEVEL0, () => {
      let mocker1: MockKit = new MockKit();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance();
      let func1: Function = mocker1.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      let array: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      containerSession.primarySession = sceneSession;
      array.push(containerSession);
      when(func1)(ArgumentMatchers.any).afterReturn(array);
      let sideEdgeBarOptions: SCBSideEdgeBarOptions = SCBSideEdgeBarManager.getInstance().getSideEdgeBarOptions();
      let persistentId: number = sideEdgeBarOptions.persistentId;
      ReflectionUtils.setProperty(containerSession.primarySession.sceneInfo, 'persistentId', persistentId);
      floatManager.onRemoveFloatingScene(sceneSession);
      expect(sideEdgeBarOptions.persistentId === -1).assertTrue();
      mocker1.clear(func1);
    });

    it('onRemoveFloatingScene_04', Level.LEVEL0, () => {
      let mocker1: MockKit = new MockKit();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance();
      let func1: Function = mocker1.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      let array: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      containerSession.primarySession = sceneSession;
      array.push(containerSession);
      when(func1)(ArgumentMatchers.any).afterReturn(array);
      let sideEdgeBarOptions: SCBSideEdgeBarOptions = SCBSideEdgeBarManager.getInstance().getSideEdgeBarOptions();
      let persistentId: number = sideEdgeBarOptions.persistentId;
      ReflectionUtils.setProperty(containerSession.primarySession.sceneInfo, 'persistentId', persistentId + 1);
      floatManager.onRemoveFloatingScene(sceneSession);
      expect(sideEdgeBarOptions.persistentId === -1).assertTrue();
      mocker1.clear(func1);
    });

    it('updateFloatContainerWithScreenChange_03', Level.LEVEL0, () => {
      let mocker1: MockKit = new MockKit();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance();
      let screenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      containerSession.floatingParam = floatingParam;
      containerSession.floatingParam.cornerParam.area = 2;
      containerSession.needRenderPos.setPosXWithDfx(0, 'test', 'updateFloatContainerWithScreenChange');
      containerSession.needRenderPos.setPosYWithDfx(0, 'test', 'updateFloatContainerWithScreenChange');
      containerSession.floatingParam.scale = 0.3;
      containerSession.requestActivation();
      let func1: Function = mocker1.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      floatContainerSessionList[0] = containerSession;
      when(func1)(ArgumentMatchers.any).afterReturn(floatContainerSessionList);
      floatManager.updateFloatContainerWithScreenChange(containerSession.screenProperty, screenWidth);
      expect(assertFlag).assertTrue();
      let func2: Function = mocker1.mockFunc(SCBMultiWindowUtils, SCBMultiWindowUtils.isSupportLargeScreenMultiWindow);
      when(func2)(ArgumentMatchers.any).afterReturn(true);
      floatManager.updateFloatContainerWithScreenChange(containerSession.screenProperty, screenWidth);
      expect(assertFlag).assertTrue();
      when(func2)(ArgumentMatchers.any).afterReturn(false);
      floatManager.updateFloatContainerWithScreenChange(containerSession.screenProperty, screenWidth);
      expect(assertFlag).assertTrue();
      let func3: Function = mocker1.mockFunc(screenSessionManager, screenSessionManager.getPhyScreenProperty);
      when(func3)(ArgumentMatchers.any).afterReturn(0);
      floatManager.updateFloatContainerWithScreenChange(containerSession.screenProperty, screenWidth);
      expect(assertFlag).assertTrue();
      when(func3)(ArgumentMatchers.any).afterReturn(1);
      let func4: Function = mocker1.mockFunc(SCBMultiWindowUtils, SCBMultiWindowUtils.isVertical);
      when(func4)(ArgumentMatchers.any).afterReturn(true);
      floatManager.updateFloatContainerWithScreenChange(containerSession.screenProperty, screenWidth);
      expect(assertFlag).assertTrue();
      when(func4)(ArgumentMatchers.any).afterReturn(false);
      floatManager.updateFloatContainerWithScreenChange(containerSession.screenProperty, screenWidth);
      expect(assertFlag).assertTrue();
      floatManager.onRemoveFloatingScene(sceneSession);
      expect(assertFlag).assertTrue();
      mocker1.clear(func1);
      mocker1.clear(func2);
      mocker1.clear(func3);
      mocker1.clear(func4);
    })

    it('onMaximizeFloatingSceneByDrag_01', Level.LEVEL0, () => {
      let mocker1: MockKit = new MockKit();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance();
      let sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let func1: Function = mocker1.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      let func2: Function = mocker1.mockFunc(sceneSessionManager, sceneSessionManager.updateNavigationBarProperty);
      let func3: Function = mocker1.mockFunc(sceneSessionManager, sceneSessionManager.updateSystemBarProperty);
      when(func1)(ArgumentMatchers.any).afterReturn(floatContainerSessionList);
      when(func2)(ArgumentMatchers.any).afterReturnNothing();
      when(func3)(ArgumentMatchers.any).afterReturnNothing();
      floatManager.onMaximizeFloatingSceneByDrag(1);
      expect(assertFlag).assertTrue();
      mocker1.clear(func1);
      mocker1.clear(func2);
      mocker1.clear(func3);
    })

    it('onMaximizeFloatingSceneByDrag_02', Level.LEVEL0, () => {
      let mocker1: MockKit = new MockKit();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance();
      let sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let func1: Function = mocker1.mockFunc(scenePanelManager, scenePanelManager.getFloatingSessionList);
      let func2: Function = mocker1.mockFunc(sceneSessionManager, sceneSessionManager.updateNavigationBarProperty);
      let func3: Function = mocker1.mockFunc(sceneSessionManager, sceneSessionManager.updateSystemBarProperty);
      let list: SCBSceneContainerSession[] = new Array<SCBSceneContainerSession>();
      list.push(containerSession);
      when(func1)(ArgumentMatchers.any).afterReturn(list);
      when(func2)(ArgumentMatchers.any).afterReturnNothing();
      when(func3)(ArgumentMatchers.any).afterReturnNothing();
      floatManager.onMaximizeFloatingSceneByDrag(0);
      expect(assertFlag).assertTrue();
      mocker1.clear(func1);
      mocker1.clear(func2);
      mocker1.clear(func3);
    })

    it('resetFloatingRectOnSideBar_test', Level.LEVEL0, () => {
      floatManager.resetFloatingRectOnSideBar(containerSession);
      expect(assertFlag).assertTrue();
    })
  });
}

function SCBFloatManagerTest_11() {
  describe('SCBFloatManagerTest_11', () => {
    it('moveFloatToCorner_01', Level.LEVEL0, () => {
      let mocker1: MockKit = new MockKit();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance();
      let func1: Function = mocker1.mockFunc(scenePanelManager, scenePanelManager.getActiveFloatContainerList);
      let list: SCBSceneContainerSession[] = new Array<SCBSceneContainerSession>();
      containerSession.floatingParam.minAnimationNum = 0;
      containerSession2.floatingParam.minAnimationNum = 0;
      list.push(containerSession);
      list.push(containerSession2);
      when(func1)(ArgumentMatchers.any).afterReturn(list);
      floatManager.moveFloatToCorner();
      expect(assertFlag).assertTrue();
      mocker1.clear(func1);
    })

    it('moveFloatToCorner_02', Level.LEVEL0, () => {
      let mocker1: MockKit = new MockKit();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance();
      let sideEdgeBarManager: SCBSideEdgeBarManager = SCBSideEdgeBarManager.getInstance();
      let func1: Function = mocker1.mockFunc(scenePanelManager, scenePanelManager.getActiveFloatContainerList);
      let list: SCBSceneContainerSession[] = new Array<SCBSceneContainerSession>();
      containerSession.floatingParam.minAnimationNum = 1;
      containerSession2.floatingParam.minAnimationNum = 1;
      list.push(containerSession);
      list.push(containerSession2);
      when(func1)(ArgumentMatchers.any).afterReturn(list);

      let func2: Function = mocker1.mockFunc(sideEdgeBarManager, sideEdgeBarManager.getSideEdgeBarOptions);
      when(func2)(ArgumentMatchers.any).afterReturn(0);

      SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PAD;
      containerSession2.screenProperty.height = 1000;
      containerSession2.screenProperty.height = 2000;
      floatManager.moveFloatToCorner();
      expect(assertFlag).assertTrue();
      mocker1.clear(func1);
      mocker1.clear(func2);
    })

    it('moveFloatToCorner_03', Level.LEVEL0, () => {
      let mocker1: MockKit = new MockKit();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance();
      let sideEdgeBarManager: SCBSideEdgeBarManager = SCBSideEdgeBarManager.getInstance();
      let func1: Function = mocker1.mockFunc(scenePanelManager, scenePanelManager.getActiveFloatContainerList);
      let list: SCBSceneContainerSession[] = new Array<SCBSceneContainerSession>();
      containerSession.floatingParam.minAnimationNum = 1;
      containerSession2.floatingParam.minAnimationNum = 1;
      list.push(containerSession);
      list.push(containerSession2);
      when(func1)(ArgumentMatchers.any).afterReturn(list);

      let func2: Function = mocker1.mockFunc(sideEdgeBarManager, sideEdgeBarManager.getSideEdgeBarOptions);
      when(func2)(ArgumentMatchers.any).afterReturn(0);

      SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PAD;
      containerSession2.screenProperty.height = 2000;
      containerSession2.screenProperty.height = 1000;
      containerSession2.floatingParam.cornerParam.area = CornerArea.MAIN;
      floatManager.moveFloatToCorner();
      expect(assertFlag).assertTrue();
      mocker1.clear(func1);
      mocker1.clear(func2);
    })

    it('moveFloatToCorner_04', Level.LEVEL0, () => {
      let mocker1: MockKit = new MockKit();
      let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance();
      let sideEdgeBarManager: SCBSideEdgeBarManager = SCBSideEdgeBarManager.getInstance();
      let func1: Function = mocker1.mockFunc(scenePanelManager, scenePanelManager.getActiveFloatContainerList);
      let list: SCBSceneContainerSession[] = new Array<SCBSceneContainerSession>();
      containerSession.floatingParam.minAnimationNum = 1;
      containerSession2.floatingParam.minAnimationNum = 1;
      list.push(containerSession);
      list.push(containerSession2);
      when(func1)(ArgumentMatchers.any).afterReturn(list);

      let func2: Function = mocker1.mockFunc(sideEdgeBarManager, sideEdgeBarManager.getSideEdgeBarOptions);
      when(func2)(ArgumentMatchers.any).afterReturn(0);

      SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PHONE;
      containerSession2.screenProperty.height = 2000;
      containerSession2.screenProperty.height = 1000;
      containerSession2.floatingParam.cornerParam.area = CornerArea.SECONDARY;
      floatManager.moveFloatToCorner();
      expect(assertFlag).assertTrue();
      mocker1.clear(func1);
      mocker1.clear(func2);
    })
    it('miniScenePanelPutInCorner_test', Level.LEVEL0, () => {
      floatManager.miniScenePanelPutInCorner(containerSession, new SCBScreenProperty());
      expect(assertFlag).assertTrue();
    })
  });
}

function SCBFloatManagerTest_12() {
  describe('SCBFloatManagerTest_12', () => {
    it('SCBFloatManagerTest01_raiseFloatZIndexInRecent', Level.LEVEL0, (): void => {
      let mocker1: MockKit = new MockKit();
      let instance: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let mockFunc: Function = mocker1.mockFunc(instance, instance.getFloatingSessionList);
      when(mockFunc)().afterReturn(floatingSessionList);
      floatManager.raiseFloatZIndexInRecent(floatingSessionList);
      expect(floatingSessionList.length === 1).assertTrue();
      mocker1.clear(mockFunc);
    });

    it('getBasicFloatWidth_test', Level.LEVEL0, () => {
      let mocker1: MockKit = new MockKit();
      let screenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let func1: Function = mocker1.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      let basicFloatWidth = floatManager.getBasicFloatWidth(0, new SCBScreenProperty());
      expect(basicFloatWidth).assertEqual(0);
      mocker1.clear(func1);
    })

    it('SCBFloatManagerTest01_floatShowMenu', Level.LEVEL0, (): void => {
      let isFloatShowMenu: boolean = floatManager.isFloatShowMenu();
      expect(isFloatShowMenu).assertFalse();
      floatManager.setFloatShowMenu(true);
      isFloatShowMenu = floatManager.isFloatShowMenu();
      expect(isFloatShowMenu).assertTrue();
    });
  });
}

function SCBFloatManagerTest_13() {
  describe('SCBFloatManagerTest_13', () => {
    it('resetOneStepOffset_01', Level.LEVEL0, () => {
      containerSession.needRenderAlpha.setNeedRenderAlpha(1);
      containerSession.needRenderScale.setScaleX(1);
      containerSession.needRenderScale.setScaleY(1);
      containerSession.needRenderTranslate.setTranslateX(0);
      containerSession.needRenderTranslate.setTranslateY(0);
      containerSession.isFloat = true;
      let mocker: MockKit = new MockKit();
      let array1:Array<SCBSceneContainerSession> = new Array();
      array1.push(containerSession);
      let array2:Array<SCBSceneContainerSession> = new Array();
      array2.push(containerSession);
      let scbSceneSessionManager = SCBSceneSessionManager.getInstance();
      let scbScenePanelManager = SCBScenePanelManager.getInstance();

      let func01: Function = mocker.mockFunc(SCBSceneSessionManager, scbSceneSessionManager.getActiveSessionList);
      let func02: Function = mocker.mockFunc(SCBSceneSessionManager, scbScenePanelManager.getFloatingSessionList);
      when(func01)(ArgumentMatchers.any).afterReturn(array1);
      when(func02)(ArgumentMatchers.any).afterReturn(array2);
      floatManager.resetOneStepOffset();

      expect(containerSession.needRenderTranslate.translateX).assertEqual(0);
      expect(containerSession.needRenderTranslate.translateY).assertEqual(0);
      expect(containerSession.needRenderScale.scaleX).assertEqual(1);
      expect(containerSession.needRenderScale.scaleY).assertEqual(1);
      expect(containerSession.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(containerSession.isFloat).assertEqual(true);

      mocker.clear(scbSceneSessionManager);
      mocker.clear(scbScenePanelManager);
    })

    it('resetOneStepOffset_02', Level.LEVEL0, () => {
      containerSession.needRenderTranslate.setTranslateX(0);
      containerSession.needRenderTranslate.setTranslateY(0);
      containerSession.needRenderAlpha.setNeedRenderAlpha(1);
      containerSession.needRenderScale.setScaleX(1);
      containerSession.needRenderScale.setScaleY(1);
      containerSession.isFloat = true;
      let mocker: MockKit = new MockKit();
      let array1:Array<SCBSceneContainerSession> = new Array();
      let array2:Array<SCBSceneContainerSession> = new Array();
      array1.push(containerSession);
      array2.push(containerSession);
      let scbSceneSessionManager = SCBSceneSessionManager.getInstance();
      let scbScenePanelManager = SCBScenePanelManager.getInstance();

      let func01: Function = mocker.mockFunc(SCBSceneSessionManager, scbSceneSessionManager.getActiveSessionList);
      let func02: Function = mocker.mockFunc(SCBSceneSessionManager, scbScenePanelManager.getFloatingSessionList);
      when(func01)(ArgumentMatchers.any).afterReturn(array1);
      when(func02)(ArgumentMatchers.any).afterReturn(array2);
      floatManager.resetOneStepOffset();

      expect(containerSession.needRenderScale.scaleX).assertEqual(1);
      expect(containerSession.needRenderScale.scaleY).assertEqual(1);
      expect(containerSession.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(containerSession.needRenderTranslate.translateX).assertEqual(0);
      expect(containerSession.needRenderTranslate.translateY).assertEqual(0);
      expect(containerSession.isFloat).assertEqual(true);

      mocker.clear(scbSceneSessionManager);
      mocker.clear(scbScenePanelManager);
    })
  });
}

function SCBFloatManagerTest_14() {
  describe('SCBFloatManagerTest_14', () => {
    it('isFloatDragging_01', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let scbScenePanelManager = SCBScenePanelManager.getInstance();
      let func01: Function = mocker.mockFunc(SCBSceneSessionManager, scbScenePanelManager.getActiveFloatContainerList);
      when(func01)(ArgumentMatchers.any).afterReturnNothing();
      let res = floatManager.isFloatDragging();
      expect(res).assertFalse();
      mocker.clear(scbScenePanelManager);
    })

    it('isFloatDragging_02', Level.LEVEL0, () => {
      containerSession.needRenderTranslate.setTranslateX(0);
      containerSession.needRenderTranslate.setTranslateY(0);
      containerSession.needRenderAlpha.setNeedRenderAlpha(1);
      containerSession.needRenderScale.setScaleX(1);
      containerSession.needRenderScale.setScaleY(1);
      containerSession.floatingParam.isFloatDragging = false;

      let mocker: MockKit = new MockKit();
      let scbScenePanelManager = SCBScenePanelManager.getInstance();
      let func01: Function = mocker.mockFunc(SCBSceneSessionManager, scbScenePanelManager.getActiveFloatContainerList);
      let array1:Array<SCBSceneContainerSession> = new Array();
      array1.push(containerSession);
      when(func01)(ArgumentMatchers.any).afterReturn(array1);
      let res = floatManager.isFloatDragging();

      expect(res).assertFalse();
      expect(containerSession.needRenderScale.scaleX).assertEqual(1);
      expect(containerSession.needRenderScale.scaleY).assertEqual(1);
      expect(containerSession.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(containerSession.needRenderTranslate.translateX).assertEqual(0);
      expect(containerSession.needRenderTranslate.translateY).assertEqual(0);

      mocker.clear(scbScenePanelManager);
    })

    it('isFloatDragging_03', Level.LEVEL0, () => {
      containerSession.needRenderTranslate.setTranslateX(0);
      containerSession.needRenderTranslate.setTranslateY(0);
      containerSession.needRenderAlpha.setNeedRenderAlpha(1);
      containerSession.needRenderScale.setScaleX(1);
      containerSession.needRenderScale.setScaleY(1);
      containerSession.floatingParam.isFloatDragging = true;

      let mocker: MockKit = new MockKit();
      let scbScenePanelManager = SCBScenePanelManager.getInstance();
      let func01: Function = mocker.mockFunc(SCBSceneSessionManager, scbScenePanelManager.getActiveFloatContainerList);
      let array1:Array<SCBSceneContainerSession> = new Array();
      array1.push(containerSession);
      when(func01)(ArgumentMatchers.any).afterReturn(array1);
      let res = floatManager.isFloatDragging();

      expect(res).assertTrue();
      expect(containerSession.needRenderScale.scaleX).assertEqual(1);
      expect(containerSession.needRenderScale.scaleY).assertEqual(1);
      expect(containerSession.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(containerSession.needRenderTranslate.translateX).assertEqual(0);
      expect(containerSession.needRenderTranslate.translateY).assertEqual(0);

      mocker.clear(scbScenePanelManager);
    })
  });
}

function SCBFloatManagerTest_15() {
  describe('SCBFloatManagerTest_15', () => {
    it('zoomDeleteToPreDeleteAnimation_01', Level.LEVEL0, () => {
      containerSession.isFloat = false;
      containerSession.needRenderTranslate.setTranslateX(0);
      containerSession.needRenderTranslate.setTranslateY(0);
      containerSession.needRenderAlpha.setNeedRenderAlpha(1);
      containerSession.needRenderScale.setScaleX(1);
      containerSession.needRenderScale.setScaleY(1);
      floatManager.zoomDeleteToPreDeleteAnimation(containerSession);
      expect(containerSession.isFloat).assertEqual(false);
    })

    it('zoomDeleteToPreDeleteAnimation_02', Level.LEVEL0, () => {
      containerSession.isFloat = true;
      floatManager.zoomDeleteToPreDeleteAnimation(containerSession);
      expect(containerSession.needRenderScale.scaleX).assertEqual(1);
      expect(containerSession.needRenderScale.scaleY).assertEqual(1);
      expect(containerSession.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(containerSession.needRenderTranslate.translateX).assertEqual(0);
      expect(containerSession.needRenderTranslate.translateY).assertEqual(0);
    })
  });
}

function SCBFloatManagerTest_57() {
  describe('SCBFloatManagerTest_57', () => {
    it('setAllAppsIconStartInfo', Level.LEVEL0, () => {
      let container = new SCBSceneContainerSession(sceneSession, screenProperty);
      container.isFloat = false;
      container.needRenderTranslate.setTranslateX(0);
      container.needRenderTranslate.setTranslateY(0);
      container.needRenderAlpha.setNeedRenderAlpha(1);
      container.needRenderScale.setScaleX(1);
      container.needRenderScale.setScaleY(1);
      let rectInfo = new RectInfo();
      floatManager.setAllAppsIconStartInfo('id', rectInfo);
      expect(container.isFloat).assertFalse();
      expect(container.needRenderTranslate.translateX).assertEqual(0);
      expect(container.needRenderTranslate.translateY).assertEqual(0);
      expect(container.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container.needRenderScale.scaleX).assertEqual(1);
      expect(container.needRenderScale.scaleY).assertEqual(1);
      let map: Map<string, RectInfo> = ReflectionUtils.getProperty(floatManager, 'allAppsIconStartInfo');
      expect(map instanceof Map).assertTrue();
      expect(ReflectionUtils.getProperty(map, 'size')).assertLarger(0);
    })

    it('setScenePanelViewModel', Level.LEVEL0, () => {
      let container = new SCBSceneContainerSession(sceneSession, screenProperty);
      container.isFloat = false;
      container.needRenderTranslate.setTranslateX(0);
      container.needRenderTranslate.setTranslateY(0);
      container.needRenderAlpha.setNeedRenderAlpha(1);
      container.needRenderScale.setScaleX(1);
      container.needRenderScale.setScaleY(1);
      floatManager.setScenePanelViewModel(panelViewModel);
      expect(container.isFloat).assertFalse();
      expect(container.needRenderTranslate.translateX).assertEqual(0);
      expect(container.needRenderTranslate.translateY).assertEqual(0);
      expect(container.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container.needRenderScale.scaleX).assertEqual(1);
      expect(container.needRenderScale.scaleY).assertEqual(1);
      expect(ReflectionUtils.getProperty(floatManager, 'scenePanelViewModel')).not().assertUndefined();
    })

    it('setTransitionController', Level.LEVEL0, () => {
      let container = new SCBSceneContainerSession(sceneSession, screenProperty);
      container.isFloat = false;
      container.needRenderTranslate.setTranslateX(0);
      container.needRenderTranslate.setTranslateY(0);
      container.needRenderAlpha.setNeedRenderAlpha(1);
      container.needRenderScale.setScaleX(1);
      container.needRenderScale.setScaleY(1);
      let controller: SCBTransitionController = {
        appData: new AppData(),
        onActive: () => 0,
        onInactive: () => 0
      };
      floatManager.setTransitionController(controller);
      expect(container.isFloat).assertFalse();
      expect(container.needRenderTranslate.translateX).assertEqual(0);
      expect(container.needRenderTranslate.translateY).assertEqual(0);
      expect(container.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container.needRenderScale.scaleX).assertEqual(1);
      expect(container.needRenderScale.scaleY).assertEqual(1);
      expect(ReflectionUtils.getProperty(floatManager, 'transitionController')).not().assertNull();
      floatManager.setTransitionController(null);
      expect(ReflectionUtils.getProperty(floatManager, 'transitionController')).assertNull();
    })

    it('clearScenePanelViewModel', Level.LEVEL0, () => {
      let floatContainer = new SCBSceneContainerSession(sceneSession, screenProperty);
      floatContainer.isFloat = false;
      floatContainer.needRenderTranslate.setTranslateX(0);
      floatContainer.needRenderTranslate.setTranslateY(0);
      floatContainer.needRenderAlpha.setNeedRenderAlpha(1);
      floatContainer.needRenderScale.setScaleX(1);
      floatContainer.needRenderScale.setScaleY(1);
      floatManager.clearScenePanelViewModel();
      expect(floatContainer.isFloat).assertFalse();
      expect(floatContainer.needRenderTranslate.translateX).assertEqual(0);
      expect(floatContainer.needRenderTranslate.translateY).assertEqual(0);
      expect(floatContainer.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(floatContainer.needRenderScale.scaleX).assertEqual(1);
      expect(floatContainer.needRenderScale.scaleY).assertEqual(1);
      expect(floatContainer.needRenderScale.scaleY).not().assertEqual(0);
      expect(ReflectionUtils.getProperty(floatManager, 'scenePanelViewModel')).assertUndefined();
    })

    it('registerFloatingSceneToFullCallback', Level.LEVEL0, () => {
      let containerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.isFloat = false;
      containerSession.needRenderTranslate.setTranslateX(0);
      containerSession.needRenderTranslate.setTranslateY(0);
      containerSession.needRenderAlpha.setNeedRenderAlpha(1);
      containerSession.needRenderScale.setScaleX(1);
      containerSession.needRenderScale.setScaleY(1);
      floatManager.registerFloatingSceneToFullCallback(() => false);
      expect(containerSession.isFloat).assertFalse();
      expect(containerSession.needRenderTranslate.translateX).assertEqual(0);
      expect(containerSession.needRenderTranslate.translateY).assertEqual(0);
      expect(containerSession.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(containerSession.needRenderScale.scaleX).assertEqual(1);
      expect(containerSession.needRenderScale.scaleY).assertEqual(1);
      expect(containerSession.needRenderScale.scaleY).not().assertEqual(0);
      expect(ReflectionUtils.getProperty(floatManager, 'floatingToFullCallback')).not().assertUndefined();
    })

    it('calculatePosAndScaleInFloatWindow', Level.LEVEL0, () => {
      let containerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.isFloat = false;
      containerSession.needRenderTranslate.setTranslateX(0);
      containerSession.needRenderTranslate.setTranslateY(0);
      containerSession.needRenderAlpha.setNeedRenderAlpha(1);
      containerSession.needRenderScale.setScaleX(1);
      containerSession.needRenderScale.setScaleY(1);
      floatManager.calculatePosAndScaleInFloatWindow(containerSession, screenProperty);
      containerSession.width = new ScbNumber(100);
      containerSession.height = new ScbNumber(100);
      let floatRect = floatManager.calculatePosAndScaleInFloatWindow(containerSession, screenProperty);
      expect(containerSession.isFloat).assertFalse();
      expect(containerSession.needRenderTranslate.translateX).assertEqual(0);
      expect(containerSession.needRenderTranslate.translateY).assertEqual(0);
      expect(containerSession.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(containerSession.needRenderScale.scaleX).assertEqual(1);
      expect(containerSession.needRenderScale.scaleY).assertEqual(1);
      expect(containerSession.needRenderScale.scaleY).not().assertEqual(0);
      expect(floatRect.isMiniScene).not().assertUndefined();
    })
  });
}

function SCBFloatManagerTest_58() {
  describe('SCBFloatManagerTest_58', () => {
    it('initFloatToFull', Level.LEVEL0, () => {
      let containerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.isFloat = false;
      containerSession.needRenderTranslate.setTranslateX(0);
      containerSession.needRenderTranslate.setTranslateY(0);
      containerSession.needRenderAlpha.setNeedRenderAlpha(1);
      containerSession.needRenderScale.setScaleX(1);
      containerSession.needRenderScale.setScaleY(1);
      let list = SCBScenePanelManager.getInstance().getSceneContainerSessionList();
      list.clear();
      list.push(containerSession);
      ReflectionUtils.setProperty(containerSession, '_isActive', true);
      floatManager.initFloatToFull(containerSession);
      ReflectionUtils.setProperty(containerSession, '_isActive', false);
      floatManager.initFloatToFull(containerSession);
      expect(containerSession.isFloat).assertFalse();
      expect(containerSession.needRenderTranslate.translateX).assertEqual(0);
      expect(containerSession.needRenderTranslate.translateY).assertEqual(0);
      expect(containerSession.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(containerSession.needRenderScale.scaleX).assertEqual(1);
      expect(containerSession.needRenderScale.scaleY).assertEqual(1);
      expect(containerSession.getState()).assertEqual(SCBSceneContainerState.FULL_SCREEN);
      expect(containerSession.floatingParam.cacheRect.left).assertEqual(0);
      expect(containerSession.floatingParam.cacheRect.top).assertEqual(0);
      expect(containerSession.floatingParam.cacheRect.right).assertEqual(0);
      expect(containerSession.floatingParam.cacheRect.bottom).assertEqual(0);
    })

    it('calculateRectWithRotation', Level.LEVEL0, () => {
      let containerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.isFloat = false;
      containerSession.needRenderTranslate.setTranslateX(0);
      containerSession.needRenderTranslate.setTranslateY(0);
      containerSession.needRenderAlpha.setNeedRenderAlpha(1);
      containerSession.needRenderScale.setScaleX(1);
      containerSession.needRenderScale.setScaleY(1);
      let cacheRect: FloatingRectCache = ReflectionUtils.useFunc(floatManager, 'calculateRectWithRotation',
        containerSession, screenProperty, screenProperty);
      expect(containerSession.isFloat).assertFalse();
      expect(containerSession.needRenderTranslate.translateX).assertEqual(0);
      expect(containerSession.needRenderTranslate.translateY).assertEqual(0);
      expect(containerSession.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(containerSession.needRenderScale.scaleX).assertEqual(1);
      expect(containerSession.needRenderScale.scaleY).assertEqual(1);
    })

    it('updateFloatContainerScreenChangeInRecent', Level.LEVEL0, () => {
      let containerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
      containerSession.isFloat = false;
      containerSession.needRenderTranslate.setTranslateX(0);
      containerSession.needRenderTranslate.setTranslateY(0);
      containerSession.needRenderAlpha.setNeedRenderAlpha(1);
      containerSession.needRenderScale.setScaleX(1);
      containerSession.needRenderScale.setScaleY(1);
      screenProperty.width = 100;
      screenProperty.height = 100;
      ReflectionUtils.useFunc(floatManager, 'updateFloatContainerScreenChangeInRecent',
        containerSession, screenProperty);
      expect(containerSession.isFloat).assertFalse();
      expect(containerSession.needRenderTranslate.translateX).assertEqual(0);
      expect(containerSession.needRenderTranslate.translateY).assertEqual(0);
      expect(containerSession.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(containerSession.needRenderScale.scaleX).assertEqual(1);
      expect(containerSession.needRenderScale.scaleY).assertEqual(1);
      expect(containerSession.screenProperty.width).assertEqual(100);
      expect(containerSession.screenProperty.height).assertEqual(100);
    })

    it('doFloatingExpandAnimation', Level.LEVEL0, () => {
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      container1.isFloat = false;
      container1.floatingParam.isMinimized = false;
      container1.floatingParam.isClosed = false;
      container1.floatingParam.isTerminated = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      screenProperty.width = 100;
      screenProperty.height = 100;
      floatManager.doFloatingExpandAnimation(screenProperty);
      expect(container1.isFloat).assertFalse();
      expect(container1.floatingParam.doFoldOrExpand).assertFalse();
      expect(container1.floatingParam.cornerParam.area).assertLargerOrEqual(0);
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
    })

    it('animationForSceneTransitionToFloat', Level.LEVEL0, () => {
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      container1.isFloat = false;
      container1.floatingParam.isMinimized = false;
      container1.floatingParam.isMinimized = false;
      container1.floatingParam.isClosed = false;
      container1.floatingParam.isTerminated = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      screenProperty.width = 100;
      screenProperty.height = 100;
      container1.isFloat = false;
      floatManager.animationForSceneTransitionToFloat(container1);
      container1.isFloat = true;
      floatManager.animationForSceneTransitionToFloat(container1);
      expect(container1.isFloat).assertTrue();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertLargerOrEqual(0);
      expect(container1.needRenderScale.scaleX).assertLargerOrEqual(1);
      expect(container1.needRenderScale.scaleY).assertLargerOrEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
    })

    it('clearCallerInfoForInheritWindowMode', Level.LEVEL0, () => {
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      let container2 = new SCBSceneContainerSession(sceneSession, screenProperty);
      let container3 = new SCBSceneContainerSession(sceneSession, screenProperty);
      container2.isFloat = false;
      container2.floatingParam.isMinimized = false;
      container2.floatingParam.isMinimized = false;
      container2.floatingParam.isClosed = false;
      container2.floatingParam.isTerminated = false;
      container2.needRenderTranslate.setTranslateX(0);
      container2.needRenderTranslate.setTranslateY(0);
      container2.needRenderAlpha.setNeedRenderAlpha(1);
      container2.needRenderScale.setScaleX(1);
      container2.needRenderScale.setScaleY(1);
      let containerList = SCBSceneSessionManager.getInstance().getContainerSessionList();
      containerList.clear();
      containerList.push(container1);
      let floatSessionList = SCBSceneSessionManager.getInstance().getFloatingSessionList();
      floatSessionList.clear();
      floatSessionList.push(container2);
      let containerSessionListNotShowRecent = panelViewModel?.getContainerSessionListNotShowRecent();
      containerSessionListNotShowRecent.clear();
      let sideEdgeFloatList = SCBSideEdgeBarManager.getInstance().getSideEdgeFloatingList();
      sideEdgeFloatList.clear();
      sideEdgeFloatList.push(container3);
      floatManager.clearCallerInfoForInheritWindowMode(container1.primarySession?.session.persistentId ?? 0);
      floatManager.clearCallerInfoForInheritWindowMode(container2.primarySession?.session.persistentId ?? 0);
      floatManager.clearCallerInfoForInheritWindowMode(container3.primarySession?.session.persistentId ?? 0);
      ReflectionUtils.useFunc(floatManager, 'updateFloatContainerScreenChangeInRecent',
        container2, screenProperty);
      expect(container2.isFloat).assertFalse();
      expect(container2.needRenderTranslate.translateX).assertEqual(0);
      expect(container2.needRenderTranslate.translateY).assertEqual(0);
      expect(container2.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container2.needRenderScale.scaleX).assertEqual(1);
      expect(container2.needRenderScale.scaleY).assertEqual(1);
      expect(container2.screenProperty.width).assertEqual(100);
      expect(container2.screenProperty.height).assertEqual(100);
      expect(container1.primarySession?.sceneInfo.callerPersistentId).assertEqual(0);
      expect(container2.primarySession?.sceneInfo.callerPersistentId).assertEqual(0);
      expect(container3.primarySession?.sceneInfo.callerPersistentId).assertEqual(0);
    })

    it('addNotShowList', Level.LEVEL0, () => {
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      let container2 = new SCBSceneContainerSession(sceneSession, screenProperty);
      let container3 = new SCBSceneContainerSession(sceneSession, screenProperty);
      container2.isFloat = false;
      container2.floatingParam.isMinimized = false;
      container2.floatingParam.isMinimized = false;
      container2.floatingParam.isClosed = false;
      container2.floatingParam.isTerminated = false;
      container2.needRenderTranslate.setTranslateX(0);
      container2.needRenderTranslate.setTranslateY(0);
      container2.needRenderAlpha.setNeedRenderAlpha(1);
      container2.needRenderScale.setScaleX(1);
      container2.needRenderScale.setScaleY(1);
      let notShowList = SCBScenePanelManager.getInstance().getNotShowRecentList();
      notShowList.clear();
      ReflectionUtils.useFunc(floatManager, 'addNotShowList', container2);
      notShowList.push(container2);
      ReflectionUtils.useFunc(floatManager, 'addNotShowList', container2);
      expect(container2.isFloat).assertFalse();
      expect(container2.needRenderTranslate.translateX).assertEqual(0);
      expect(container2.needRenderTranslate.translateY).assertEqual(0);
      expect(container2.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container2.needRenderScale.scaleX).assertEqual(1);
      expect(container2.needRenderScale.scaleY).assertEqual(1);
      expect(container2.screenProperty.width).assertEqual(100);
      expect(container2.screenProperty.height).assertEqual(100);
    })

    it('processFoldOrExpandOnUltraScreen', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(floatManager, floatManager.getKeepForegroundFloatingList);
      let screenSessionManager = SCBScreenSessionManager.getInstance();
      let func2: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getLastUltraScreenState);
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      floatingSessionList.clear();
      floatingSessionList.push(container1);
      when(mockFunc)().afterReturn(floatingSessionList);
      container1.isFloat = false;
      container1.floatingParam.isMinimized = false;
      container1.floatingParam.isMinimized = false;
      container1.floatingParam.isClosed = false;
      container1.floatingParam.isTerminated = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      screenProperty.width = 100;
      screenProperty.height = 100;
      container1.isFloat = false;
      when(func2)(ArgumentMatchers.any).afterReturn(SCBUltraScreenState.M);
      floatManager.processFoldOrExpandOnUltraScreen();
      container1.isFloat = true;
      when(func2)(ArgumentMatchers.any).afterReturn(SCBUltraScreenState.G);
      floatManager.processFoldOrExpandOnUltraScreen();
      mocker.clear(floatManager);
      mocker.clear(screenSessionManager);
      expect(container1.isFloat).assertTrue();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
    })

    it('doFoldInFState', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let scenePanelManager = SCBScenePanelManager.getInstance();
      let screenSessionManager = SCBScreenSessionManager.getInstance();
      let func1: Function = mocker.mockFunc(floatManager, floatManager.getKeepForegroundFloatingList);
      let func2: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getLastUltraScreenState);
      let func3: Function = mocker.mockFunc(scenePanelManager, scenePanelManager.getTopActiveSceneSessionArray);
      when(func3)(ArgumentMatchers.any).afterReturn(null);
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      let container2 = new SCBSceneContainerSession(sceneSession2, screenProperty);
      floatingSessionList.clear();
      floatingSessionList.push(container1);
      when(func1)().afterReturn(floatingSessionList);
      container1.isFloat = false;
      container1.floatingParam.isMinimized = false;
      container1.floatingParam.isMinimized = false;
      container1.floatingParam.isClosed = false;
      container1.floatingParam.isTerminated = false;
      container1.needRenderTranslate.setTranslateX(1);
      container1.needRenderTranslate.setTranslateY(1);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(0);
      container1.needRenderScale.setScaleY(0);
      container2.isFloat = false;
      container2.floatingParam.isMinimized = false;
      container2.floatingParam.isMinimized = false;
      container2.floatingParam.isClosed = false;
      container2.floatingParam.isTerminated = false;
      container2.needRenderTranslate.setTranslateX(1);
      container2.needRenderTranslate.setTranslateY(1);
      container2.needRenderAlpha.setNeedRenderAlpha(1);
      container2.needRenderScale.setScaleX(0);
      container2.needRenderScale.setScaleY(0);
      screenProperty.width = 100;
      screenProperty.height = 100;
      container1.isFloat = false;
      let activeSceneSessionArray = new Array<SCBSceneContainerSession>();
      activeSceneSessionArray.push(container1);
      activeSceneSessionArray.push(container2);
      when(func3)(ArgumentMatchers.any).afterReturn(activeSceneSessionArray);
      when(func2)(ArgumentMatchers.any).afterReturn(SCBUltraScreenState.M);
      floatManager.doFoldInFState(screenProperty);
      container1.isFloat = true;
      when(func2)(ArgumentMatchers.any).afterReturn(SCBUltraScreenState.G);
      floatManager.doFoldInFState(screenProperty);
      mocker.clear(floatManager);
      mocker.clear(scenePanelManager);
      mocker.clear(screenSessionManager);
      expect(container1.isFloat).assertTrue();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
      expect(container1.floatingParam.isFloatDragging).assertFalse();
      expect(container1.floatingParam.needShowBackground).assertFalse();
      expect(container1.splitParam.needShowIcon).assertFalse();
      expect(container2.isFloat).assertFalse();
      expect(container2.needRenderTranslate.translateY).assertLargerOrEqual(0);
      expect(container2.needRenderAlpha.sceneAlpha).assertEqual(0);
      expect(container2.needRenderScale.scaleX).assertLargerOrEqual(1);
      expect(container2.needRenderScale.scaleY).assertLargerOrEqual(0);
      expect(container2.screenProperty.width).assertEqual(100);
      expect(container2.screenProperty.height).assertEqual(100);
      expect(container2.floatingParam.isFloatDragging).assertFalse();
      expect(container2.floatingParam.needShowBackground).assertFalse();
      expect(container2.splitParam.needShowIcon).assertFalse();
    })

    it('doExpandInMOrGState', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let func1: Function = mocker.mockFunc(floatManager, floatManager.getKeepForegroundFloatingList);
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      floatingSessionList.clear();
      floatingSessionList.push(container1);
      when(func1)().afterReturn(floatingSessionList);
      container1.isFloat = false;
      container1.floatingParam.isMinimized = false;
      container1.floatingParam.isMinimized = false;
      container1.floatingParam.isClosed = false;
      container1.floatingParam.isTerminated = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      screenProperty.width = 100;
      screenProperty.height = 100;
      floatManager.setDraggingFloatState(container1.containerId, true);
      floatManager.doExpandInMOrGState(screenProperty);
      mocker.clear(floatManager);
      floatManager.deleteDraggingFloatState(container1.containerId);
      expect(container1.isFloat).assertFalse();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
    })

    it('resetAllFloatingRectOnSideBar', Level.LEVEL0, () => {
      let sideEdgeSessionList = SCBSideEdgeBarManager.getInstance().getSideEdgeFloatingList();
      sideEdgeSessionList.clear();
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      sideEdgeSessionList.push(container1);
      container1.isFloat = false;
      container1.floatingParam.isMinimized = false;
      container1.floatingParam.isMinimized = false;
      container1.floatingParam.isClosed = false;
      container1.floatingParam.isTerminated = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      screenProperty.width = 100;
      screenProperty.height = 100;
      floatManager.resetAllFloatingRectOnSideBar();
      expect(container1.isFloat).assertFalse();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
    })
  })
}

function SCBFloatManagerTest_59() {
  describe('SCBFloatManagerTest_59', () => {
    it('exitFloatToBackground', Level.LEVEL0, () => {
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      container1.isFloat = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      screenProperty.width = 100;
      screenProperty.height = 100;
      ReflectionUtils.useFunc(floatManager, 'exitFloatToBackground', containerSession);
      expect(container1.isFloat).assertFalse();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
    })

    it('closeFloatingWindowToSide', Level.LEVEL0, () => {
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      container1.isFloat = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      container1.floatingParam.needRecoverStatusBar = true;
      screenProperty.width = 100;
      screenProperty.height = 100;
      floatManager.closeFloatingWindowToSide(container1);
      ReflectionUtils.useFunc(floatManager, 'closeFloating', container1.floatingParam, container1,
        new FloatRect(0, 0, 0, 0), false);
      ReflectionUtils.useFunc(floatManager, 'doCloseFloatWindowBlurAnim', container1);
      expect(container1.isFloat).assertFalse();
      expect(container1.floatingParam.shadowOptions?.radius).assertEqual(0);
      expect(container1.sideEdgeManagerParam.sideIsAmin).assertTrue();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(0);
      expect(container1.needRenderScale.scaleX).not().assertEqual(1);
      expect(container1.needRenderScale.scaleY).not().assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
    })

    it('onCloseFloatingSceneWithBackground', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let sceneSessionManager = SCBSceneSessionManager.getInstance();
      let func1: Function = mocker.mockFunc(sceneSessionManager, sceneSessionManager.isRemoveSessionAfterTerminate);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      let floatContainerList = SCBScenePanelManager.getInstance().getFloatingSessionList();
      floatContainerList.clear();
      floatContainerList.push(container1);
      container1.isFloat = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      container1.floatingParam.needRecoverStatusBar = true;
      screenProperty.width = 100;
      screenProperty.height = 100;
      floatManager.onCloseFloatingSceneWithBackground();
      container1.floatingParam.isTerminated = true;
      floatManager.onCloseFloatingSceneWithBackground(container1.primarySession?.session.persistentId);
      mocker.clear(sceneSessionManager);
      expect(container1.isFloat).assertFalse();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
    })

    it('sidebarSceneFromRecent', Level.LEVEL0, () => {
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      let floatContainerList = SCBScenePanelManager.getInstance().getFloatingSessionList();
      floatContainerList.clear();
      floatContainerList.push(container1);
      container1.isFloat = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      container1.floatingParam.needRecoverStatusBar = true;
      screenProperty.width = 100;
      screenProperty.height = 100;
      ReflectionUtils.useFunc(floatManager, 'sidebarSceneFromRecent');
      ReflectionUtils.useFunc(floatManager, 'sidebarSceneFromRecent', container1);
      expect(container1.floatingParam.isMinimized).assertTrue();
      expect(container1.isFloat).assertFalse();
      expect(container1.needRenderTranslate.translateY).assertLargerOrEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(0);
      expect(container1.needRenderScale.scaleX).assertLargerOrEqual(1);
      expect(container1.needRenderScale.scaleY).assertLargerOrEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
    })

    it('animateOnTouch', Level.LEVEL0, () => {
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      let sideEdgeFloatingList = SCBSideEdgeBarManager.getInstance().getSideEdgeFloatingList();
      sideEdgeFloatingList.clear();
      let sideFloatingAnimParams: SideFloatingAnimParams = new SideFloatingAnimParams(
        container1.primarySession?.session.persistentId ?? 0, 0, 0, 0, 0, 0);
      floatManager.animateOnTouch(sideFloatingAnimParams);
      sideEdgeFloatingList.push(container1);
      container1.isFloat = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      container1.floatingParam.needRecoverStatusBar = true;
      screenProperty.width = 100;
      screenProperty.height = 100;
      floatManager.animateOnTouch(sideFloatingAnimParams);
      expect(container1.isFloat).assertFalse();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
    })

    it('initFloatingFromSideToFull', Level.LEVEL0, () => {
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      let sideEdgeFloatingList = SCBSideEdgeBarManager.getInstance().getSideEdgeFloatingList();
      sideEdgeFloatingList.clear();
      sideEdgeFloatingList.push(container1);
      container1.isFloat = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      container1.floatingParam.needRecoverStatusBar = true;
      screenProperty.width = 100;
      screenProperty.height = 100;
      floatManager.initFloatingFromSideToFull(-1);
      floatManager.initFloatingFromSideToFull(container1.primarySession?.session.persistentId ?? 0);
      expect(container1.isFloat).assertFalse();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
      expect(container1.floatingParam.cacheRect.left).assertEqual(0);
      expect(container1.floatingParam.cacheRect.top).assertEqual(0);
      expect(container1.floatingParam.cacheRect.right).assertEqual(0);
      expect(container1.floatingParam.cacheRect.bottom).assertEqual(0);
    })

    it('initFloatingFromSideManager', Level.LEVEL0, () => {
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      let sideEdgeFloatingList = SCBSideEdgeBarManager.getInstance().getSideEdgeFloatingList();
      sideEdgeFloatingList.clear();
      sideEdgeFloatingList.push(container1);
      container1.isFloat = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      container1.floatingParam.needRecoverStatusBar = true;
      screenProperty.width = 100;
      screenProperty.height = 100;
      floatManager.initFloatingFromSideManager(null);
      floatManager.initFloatingFromSideManager(container1);
      expect(container1.isFloat).assertFalse();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
      expect(container1.floatingParam.cacheRect.left).assertEqual(0);
      expect(container1.floatingParam.cacheRect.top).assertEqual(0);
      expect(container1.floatingParam.cacheRect.right).assertEqual(0);
      expect(container1.floatingParam.cacheRect.bottom).assertEqual(0);
    })

    it('processFloatingAfterExpand', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let array = new SCBSceneContainerSessionArray();
      array.push(containerSession);
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      let sideEdgeFloatingList = SCBSideEdgeBarManager.getInstance().getSideEdgeFloatingList();
      sideEdgeFloatingList.clear();
      sideEdgeFloatingList.push(container1);
      container1.isFloat = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      container1.floatingParam.needRecoverStatusBar = true;
      screenProperty.width = 100;
      screenProperty.height = 100;
      let func2: Function = mocker.mockFunc(floatManager, floatManager.isMiniScene);
      when(func2)(ArgumentMatchers.any).afterReturn(true);
      ReflectionUtils.useFunc(floatManager, 'processFloatingAfterExpand', container1);
      when(func2)(ArgumentMatchers.any).afterReturn(false);
      ReflectionUtils.useFunc(floatManager, 'processFloatingAfterExpand', container1);
      mocker.clear(floatManager);
      expect(container1.isFloat).assertFalse();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
    })

    it('initRectRecoverMinFromSide', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let array = new SCBSceneContainerSessionArray();
      array.push(containerSession);
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      let sideEdgeFloatingList = SCBSideEdgeBarManager.getInstance().getSideEdgeFloatingList();
      sideEdgeFloatingList.clear();
      sideEdgeFloatingList.push(container1);
      container1.isFloat = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      screenProperty.width = 100;
      screenProperty.height = 100;
      let fun_01: Function = mocker.mockFunc(SCBMultiWindowUtils, SCBMultiWindowUtils.isFoldableDeviceExpanded);
      container1.floatingParam.doFoldOrExpand = true;
      container1.floatingParam.setUserAction(UserAction.QUICK_MIN);
      let func2: Function = mocker.mockFunc(floatManager, floatManager.isMiniScene);
      when(fun_01)(ArgumentMatchers.any).afterReturn(true);
      when(func2)(ArgumentMatchers.any).afterReturn(true);
      ReflectionUtils.useFunc(floatManager, 'initRectRecoverMinFromSide', container1);
      when(fun_01)(ArgumentMatchers.any).afterReturn(false);
      ReflectionUtils.useFunc(floatManager, 'initRectRecoverMinFromSide', container1);
      mocker.clear(SCBMultiWindowUtils);
      mocker.clear(floatManager);
      expect(container1.isFloat).assertFalse();
      expect(container1.needRenderTranslate.translateY).assertLargerOrEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
    })

    it('initAnimParam', Level.LEVEL0, () => {
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      container1.isFloat = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      screenProperty.width = 100;
      screenProperty.height = 100;
      ReflectionUtils.useFunc(floatManager, 'initAnimParam', container1);
      expect(container1.floatingParam.showSideBarCover).assertTrue();
      expect(container1.floatingParam.sideBarAlpha).assertEqual(0);
      expect(container1.dividerParam.primary.width).assertEqual('100%');
      expect(container1.floatingParam.sideBarAlpha).assertEqual(0);
      expect(container1.floatingParam.highLightBarOffsetX).assertEqual(0);
      expect(container1.isFloat).assertFalse();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
    })

    it('folderStatusChangeCallback', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let func1: Function = mocker.mockFunc(floatManager, floatManager.getKeepForegroundFloatingList);
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      floatingSessionList.clear();
      floatingSessionList.push(container1);
      when(func1)().afterReturn(floatingSessionList);
      container1.isFloat = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      screenProperty.width = 100;
      screenProperty.height = 100;
      ReflectionUtils.useFunc(floatManager, 'folderStatusChangeCallback', FoldStatus.FOLD_STATUS_EXPANDED);
      mocker.clear(floatManager);
      expect(container1.isFloat).assertFalse();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
    })

    it('registerFoldChangeListener', Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let func1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isUltraScreenProduct);
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      container1.isFloat = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      screenProperty.width = 100;
      screenProperty.height = 100;
      when(func1)().afterReturn(false);
      floatManager.registerFoldChangeListener();
      floatManager.unRegisterFoldChangeListener();
      when(func1)().afterReturn(true);
      floatManager.registerFoldChangeListener();
      floatManager.unRegisterFoldChangeListener();
      mocker.clear(DeviceHelper);
      expect(container1.isFloat).assertFalse();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
    })
  })
}

function SCBFloatManagerTest_60() {
  describe('SCBFloatManagerTest_60', () => {
    it('avoidWithAnimation', Level.LEVEL0, () => {
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      container1.isFloat = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      screenProperty.width = 100;
      screenProperty.height = 0;
      ReflectionUtils.useFunc(floatManager, 'avoidWithAnimation', new SCBSessionRect(0, 100, 100, 100),
        new FloatingRectCache(0, 0, 0, 0), new FloatRect(0, 0, 0, 0), new FloatRect(0, 0, 0, 0), container1);
      screenProperty.height = 100;
      ReflectionUtils.useFunc(floatManager, 'avoidWithAnimation', new SCBSessionRect(0, 0, 0, 0),
        new FloatingRectCache(0, 0, 0, 0), new FloatRect(0, 0, 0, 0), new FloatRect(0, 0, 0, 0), container1);
      expect(container1.isFloat).assertFalse();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
    })

    it('avoidCommonAnimation', Level.LEVEL0, () => {
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      container1.isFloat = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      screenProperty.width = 100;
      screenProperty.height = 100;
      ReflectionUtils.useFunc(floatManager, 'avoidCommonAnimation', container1, new FloatingRectCache(0, 0, 0, 0));
      expect(container1.isFloat).assertFalse();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
    })

    it('processFloatToRecent', Level.LEVEL0, () => {
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      container1.isFloat = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      screenProperty.width = 100;
      screenProperty.height = 100;
      ReflectionUtils.useFunc(floatManager, 'processFloatToRecent', null);
      ReflectionUtils.setProperty(container1, '_isActive', false);
      ReflectionUtils.useFunc(floatManager, 'processFloatToRecent', container1);
      ReflectionUtils.setProperty(container1, '_isActive', true);
      ReflectionUtils.useFunc(floatManager, 'processFloatToRecent', container1);
      expect(container1.isFloat).assertFalse();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(0);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
    })

    it('calculateFloatViewWhiteSpace', Level.LEVEL0, () => {
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      container1.isFloat = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      screenProperty.width = 100;
      screenProperty.height = 100;
      ReflectionUtils.useFunc(floatManager, 'calculateFloatViewWhiteSpace', container1);
      expect(container1.isFloat).assertFalse();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
    })

    it('transitionPadSize', Level.LEVEL0, () => {
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      container1.isFloat = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      screenProperty.width = 100;
      screenProperty.height = 100;
      container1.floatingParam.isLandscapeFloat = true;
      ReflectionUtils.useFunc(floatManager, 'transitionPadSize', container1, screenProperty);
      container1.floatingParam.isLandscapeFloat = false;
      ReflectionUtils.useFunc(floatManager, 'transitionPadSize', container1, screenProperty);
      expect(container1.isFloat).assertFalse();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
    })

    it('buildRectForPhone', Level.LEVEL0, () => {
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      container1.isFloat = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      screenProperty.width = 100;
      screenProperty.height = 100;
      let rect = new FloatRect(0, 0, 0, 0);
      ReflectionUtils.useFunc(floatManager, 'buildRectForPhone', container1, rect, screenProperty);
      expect(container1.isFloat).assertFalse();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
    })

    it('buildRectForPad', Level.LEVEL0, () => {
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      container1.isFloat = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      screenProperty.width = 100;
      screenProperty.height = 100;
      let rect = new FloatRect(0, 0, 0, 0);
      ReflectionUtils.useFunc(floatManager, 'buildRectForPad', rect, screenProperty);
      expect(container1.isFloat).assertFalse();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
      expect(rect.left).not().assertEqual(0);
      expect(rect.top).assertLargerOrEqual(0);
      expect(rect.right).assertLargerOrEqual(0);
      expect(rect.bottom).assertLargerOrEqual(0);
    })

    it('buildLandscapeRectForPad', Level.LEVEL0, () => {
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      container1.isFloat = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      screenProperty.width = 100;
      screenProperty.height = 100;
      let rect = new FloatRect(0, 0, 0, 0);
      ReflectionUtils.useFunc(floatManager, 'buildLandscapeRectForPad', rect, screenProperty);
      expect(container1.isFloat).assertFalse();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
      expect(rect.left).not().assertEqual(0);
      expect(rect.top).assertLargerOrEqual(0);
      expect(rect.right).assertLargerOrEqual(0);
      expect(rect.bottom).assertLargerOrEqual(0);
    })

    it('getTitleBarPercent', Level.LEVEL0, () => {
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      container1.isFloat = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      screenProperty.width = 100;
      screenProperty.height = 100;
      let rect = new FloatRect(0, 0, 0, 0);
      container1.floatingParam.defaultWidthRatio = 0;
      let ret: number = ReflectionUtils.useFunc(floatManager, 'getTitleBarPercent', container1);
      expect(ret).assertEqual(0);
      container1.floatingParam.defaultWidthRatio = 0.5;
      container1.floatingParam.aspectRatio = 0.5;
      let ret1: number = ReflectionUtils.useFunc(floatManager, 'getTitleBarPercent', container1);
      expect(container1.isFloat).assertFalse();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
      expect(ret1).not().assertEqual(0);
    })

    it('getMoveHotArea', Level.LEVEL0, () => {
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      container1.isFloat = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      screenProperty.width = 100;
      screenProperty.height = 100;
      let rect = new FloatRect(0, 0, 0, 0);
      container1.floatingParam.defaultWidthRatio = 0;
      let rect1: RectItem = ReflectionUtils.useFunc(floatManager, 'getMoveHotArea', container1, rect);
      expect(container1.isFloat).assertFalse();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
      expect(rect1.right).assertEqual(0);
    })

    it('updateFloatRectAfterDrag', Level.LEVEL0, () => {
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      container1.isFloat = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      screenProperty.width = 100;
      screenProperty.height = 100;
      container1.floatingParam.defaultWidthRatio = 0;
      let rectAndScale = new FloatingRectCache(0, 10, 10, 100)
      let rect1: RectItem = ReflectionUtils.useFunc(floatManager, 'updateFloatRectAfterDrag', container1, 0.8,
        rectAndScale);
      rectAndScale.scale = 0.5;
      let rect2: RectItem = ReflectionUtils.useFunc(floatManager, 'updateFloatRectAfterDrag', container1, 0.8,
        rectAndScale);
      expect(container1.isFloat).assertFalse();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
      expect(rect1.left).not().assertEqual(0);
      expect(rect1.top).not().assertEqual(0);
      expect(rect1.right).not().assertEqual(0);
      expect(rect1.bottom).not().assertEqual(0);
      expect(rect2.left).not().assertEqual(0);
      expect(rect2.top).not().assertEqual(0);
      expect(rect2.right).not().assertEqual(0);
      expect(rect2.bottom).not().assertEqual(0);
    })

    it('processFloatBeforeEnterRecent', Level.LEVEL0, () => {
      let listForView = SCBScenePanelManager.getInstance().getFloatingSessionListForView();
      listForView.clear();
      let container1 = new SCBSceneContainerSession(sceneSession, screenProperty);
      listForView.push(container1);
      container1.isFloat = false;
      container1.needRenderTranslate.setTranslateX(0);
      container1.needRenderTranslate.setTranslateY(0);
      container1.needRenderAlpha.setNeedRenderAlpha(1);
      container1.needRenderScale.setScaleX(1);
      container1.needRenderScale.setScaleY(1);
      screenProperty.width = 100;
      screenProperty.height = 100;
      floatManager.processFloatBeforeEnterRecent(0);
      expect(container1.isFloat).assertFalse();
      expect(container1.needRenderTranslate.translateX).assertEqual(0);
      expect(container1.needRenderTranslate.translateY).assertEqual(0);
      expect(container1.needRenderAlpha.sceneAlpha).assertEqual(1);
      expect(container1.needRenderScale.scaleX).assertEqual(1);
      expect(container1.needRenderScale.scaleY).assertEqual(1);
      expect(container1.screenProperty.width).assertEqual(100);
      expect(container1.screenProperty.height).assertEqual(100);
    })
  });
}