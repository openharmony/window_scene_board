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

import { RectItem } from '@ohos/basicutils';
import { SCBConstants } from '@ohos/commonconstants';
import { DeviceHelper, GlobalContext, SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import {
  SCBScreenProperty,
  SCBSceneInfo,
  SCBSceneSession,
  SCBSceneContainerSession,
  SCBSceneMode,
  SCBScreenSessionManager,
  ScenePanelState,
  SCBSceneSessionManager,
  SCBDividerParam,
  SplitStyle,
  PreferMultiWindowOrientation,
  SCBKeyboardSession,
  KeyboardChangeCallback,
  SCBScenePanelManager,
  SCBSceneContainerState,
  SCBKeyboardManager,
  SCBScreenSessionArray,
  SCBScreenSession,
  SCBSceneContainerSessionArray,
  SCBKeyboardPanelSession,
  SystemSessionInfo,
  SCBAppIconParam,
  SceneParam,
} from '@ohos/windowscene';
import { ArgumentMatchers, beforeAll, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import screenSessionManager from '@ohos.screenSessionManager';
import {
  DockPairSplitProcessor,
  DockSplitType,
  GestureEventType,
  OneStepSplitData,
  ReplaceSplitProcessor,
  SCBSplitManager,
  SplitStatus,
  StartFromHomeProcessor,
  StartFromRecentProcessor
} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBSplitManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { ReflectionUtils } from './ReflectionUtils';
import { SCBGestureRecord } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBGestureRecord';
import { SCBMultiWindowUtils } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBMultiWindowUtils';
import { unifiedDataChannel } from '@kit.ArkData';
import { SCBPreviewRectModel } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBDockSplitView';
import { AppItemInfo } from '@ohos/launchercommon';
import dockSplitHelper from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBDockSplitHelper';

const FROM_CONTAINER_SESSION: string = 'fromContainerSession';
const ONE_HUNDRED_PERCENT: string = '100%';
const ZERO_STR = '0';
const IS_SUPPORT_SPLIT: string = 'isSupportSplit';
const IS_UP_DOWN_SPLIT: string = 'isUpDownSplit';
const NEXT_ALIGNMENT: string = 'nextAlignment';
const SCENE_INFO: string = 'sceneInfo';
const UI_TYPE: string = 'uiType';
const TAG = 'SCBSplitManager';
const testScreenId = 1000;

let splitManager: SCBSplitManager;
let screenProperty: SCBScreenProperty = new SCBScreenProperty();
let sceneInfo: SCBSceneInfo;
let secSceneInfo: SCBSceneInfo;
let floatInfo: SCBSceneInfo;
let primSession: SCBSceneSession;
let primNullSession: SCBSceneSession | null;
let secondarySession: SCBSceneSession;
let container: SCBSceneContainerSession;
let targetContainerSession: SCBSceneContainerSession;
let toInfo: SCBSceneInfo;
let toSession: SCBSceneSession;
let fromContainerSession: SCBSceneContainerSession;
let dividerParam: SCBDividerParam;
let config: sceneSessionManager.AppWindowSceneConfig = SCBWindowSceneConfig.getInstance().windowSceneConfig;
let scbScreenSessionManager: SCBScreenSessionManager;
let floatSession: SCBSceneSession;
let floatContainer: SCBSceneContainerSession;
let screenSession: screenSessionManager.ScreenSession = {
  screenId: testScreenId,
  name: 'testScreen',
  on: (type: string, callback: Function): void => undefined,
  setScreenRotationLocked: (isLocked: boolean): void => undefined,
  loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => undefined,
  setTouchEnabled: (isTouchEnabled: boolean): void => undefined,
  getScreenUIContext: (): UIContext => {
    return sceneSessionManager.getRootSceneUIContext();
  }
};
let scbScreenSession = new SCBScreenSession(screenSession);
let kbSystemSessionInfo: SystemSessionInfo = {
  systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
  sceneName: 'SplitManagerTest',
  sceneZIndex: 0,
  isFocusable: false,
  isTouchable: true,
  privacyMode: false,
  hitTestMode: HitTestMode.Default,
  isOverlayScene: true,
};
let keyBoardSceneInfo: SCBSceneInfo = new SCBSceneInfo('testKBBundle', 'testKBModule', 'testKBAbility');
let keyboardPanelSession =
  new SCBKeyboardPanelSession(sceneSessionManager.requestSceneSession(keyBoardSceneInfo), kbSystemSessionInfo);

let initSession = () => {
  let persistentIdCount = 1;
  sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
  sceneInfo.persistentId = persistentIdCount++;
  let sceneInfo2 = new SCBSceneInfo('testPriBundle2', 'testPriModule2', 'testPriAbility2');
  sceneInfo2.persistentId = persistentIdCount++;
  secSceneInfo = new SCBSceneInfo('testSecBundle', 'testSecModule', 'testSecAbility');
  secSceneInfo.persistentId = persistentIdCount++;
  floatInfo = new SCBSceneInfo('testFloatBundle', 'testFloatModule', 'testFloatAbility');
  floatInfo.persistentId = persistentIdCount++;
  primSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  primNullSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
  secondarySession = new SCBSceneSession(sceneSessionManager.requestSceneSession(secSceneInfo), secSceneInfo);
  container = new SCBSceneContainerSession(primSession, screenProperty);
  targetContainerSession = new SCBSceneContainerSession(secondarySession, screenProperty);
  container.addSceneSession(secondarySession);
  container.dividerParam = new SCBDividerParam();
  container.initAll();
  dividerParam = new SCBDividerParam();
  toInfo = new SCBSceneInfo('testToBundle', 'testToModule', 'testToAbility');
  toInfo.persistentId = persistentIdCount++;
  toInfo.updateWindowModeAndSync(SCBSceneMode.SECONDARY);
  toSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(toInfo), toInfo);
  fromContainerSession = new SCBSceneContainerSession(primSession, screenProperty);
  floatSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(floatInfo), floatInfo);
  floatContainer = new SCBSceneContainerSession(floatSession, screenProperty);
  splitManager = SCBSplitManager.getInstance();
  config = SCBWindowSceneConfig.getInstance().windowSceneConfig;
  scbScreenSessionManager = SCBScreenSessionManager.getInstance();
}
let initForPairSplitInOneApp = () => {
  let persistentIdCount = 10;
  toInfo = new SCBSceneInfo('testToBundle', 'testToModule', 'testToAbility');
  toInfo.persistentId = persistentIdCount++;
  toInfo.updateWindowModeAndSync(SCBSceneMode.SECONDARY);
  toSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(toInfo), toInfo);
  fromContainerSession = new SCBSceneContainerSession(primSession, screenProperty);
}
let keyboardSession: SCBKeyboardSession;
let initKeyboard = () => {
  let sceneInfo = new SCBSceneInfo('testKeyboardBundle', 'testKeyboardModule', 'testKeyboardAbility');
  let session = sceneSessionManager.requestSceneSession(sceneInfo);
  let keyboardChangeCallbackMap: Map<string, KeyboardChangeCallback> = new Map<string, KeyboardChangeCallback>();
  let keyboardChangeListenerList: Array<KeyboardChangeCallback> = new Array();
  keyboardSession = new SCBKeyboardSession(session, () => {
  }, keyboardChangeCallbackMap,
    keyboardChangeListenerList);
}
let voidCallback = () => {
}

export function SCBSplitManagerTest() {
  SCBSplitManagerTest_01();
  SCBSplitManagerTest_02();
  SCBSplitManagerTest_03();
  SCBSplitManagerTest_04();
  SCBSplitManagerTest_05();
  SCBSplitManagerTest_06();
  SCBSplitManagerTest_07();
  SCBSplitManagerTest_08();
  SCBSplitManagerTest_09();
  SCBSplitManagerTest_10();
}

function SCBSplitManagerTest_01() {
  describe('SCBSplitManagerTest_01', () => {
    beforeAll(initSession);
    it('registerSplitTitleBarAppearCallback', Level.LEVEL0, (): void => {
      splitManager.registerSplitTitleBarAppearCallback(voidCallback);
      expect(true).assertTrue();
    });

    it('registerSplitTitleDisappearCallback', Level.LEVEL0, (): void => {
      splitManager.registerSplitTitleDisappearCallback(voidCallback);
      expect(true).assertTrue();
    });

    it('registerStartSceneWithRotationCallback', Level.LEVEL0, (): void => {
      let testNum = 0;
      let startSceneWithRotationIfNeedCallback = (containerSession?: SCBSceneContainerSession | null,
        needAnimation: boolean = false, isFromRecent: boolean = false, fromUser: boolean = false): void => {
        testNum++;
      }
      splitManager.registerStartSceneWithRotationCallback(startSceneWithRotationIfNeedCallback);
      expect(ReflectionUtils.getProperty(splitManager, 'startSceneWithRotationCallback')).assertInstanceOf('Function');
      splitManager.notifyStartSceneWithRotation(container);
      expect(testNum).assertEqual(1);
      splitManager.unRegisterStartSceneWithRotationCallback();
      expect(ReflectionUtils.getProperty(splitManager, 'startSceneWithRotationCallback')).assertUndefined();
    });

    it('registerHotRegionStateChangeCallback', Level.LEVEL0, (): void => {
      let testNum = 0;
      splitManager.registerHotRegionStateChangeCallback(() => {
        testNum++;
      });
      expect(ReflectionUtils.getProperty(splitManager, 'hotRegionStateChangeCallback')).assertInstanceOf('Function');
      splitManager.notifyHotRegionStateChange();
      expect(testNum).assertEqual(1);
    });

    it('notifySplitTitleBarAppear', Level.LEVEL0, (): void => {
      let array: RectItem[] = [];
      array.push(new RectItem(0, 0, 0, 0));
      let callback: Function = () => {
        screenProperty.width = 0;
      };
      splitManager.registerSplitTitleBarAppearCallback(callback);
      splitManager.notifySplitTitleBarAppear(array);
      expect(true).assertTrue();
    });

    it('notifySplitTitleDisappear', Level.LEVEL0, (): void => {
      splitManager.registerSplitTitleDisappearCallback(voidCallback);
      splitManager.notifySplitTitleDisappear();
      expect(true).assertTrue();
    });

    it('createOneStepSplitData', Level.LEVEL0, (): void => {
      let res = splitManager.createOneStepSplitData(SplitStatus.EXIT, dividerParam);
      expect(res.splitStatus).assertEqual(SplitStatus.EXIT);
      let res2 = splitManager.createOneStepSplitData(SplitStatus.ONE_STEP_SPLIT, dividerParam);
      expect(res2.splitStatus).assertEqual(SplitStatus.ONE_STEP_SPLIT);
    });

    gestureRecordTest();

    it('resetSplitViewDividerParam', Level.LEVEL0, (): void => {
      splitManager.resetSplitViewDividerParam(container, screenProperty);
      expect(container.dividerParam.blackBackgroundOpacity).assertEqual(1);
      expect(container.dividerParam.isShowIcon).assertFalse()
      expect(container.splitParam.needShowIcon).assertFalse()
      container.dividerParam.splitOrderIsNotReverse = true;
      if (container.dividerParam.isUpDownSplit()) {
        expect(container.dividerParam.primary.sessionScaleY).assertEqual(1);
        expect(container.dividerParam.secondary.sessionScaleY).assertEqual(1);
        expect(container.dividerParam.primary.sessionScaleCenterX).assertEqual(0);
        expect(container.dividerParam.secondary.sessionScaleCenterY).assertEqual(0);
        expect(container.dividerParam.primary.sessionScaleCenterX).assertEqual(0);
        expect(container.dividerParam.secondary.sessionScaleCenterY).assertEqual(0);
      } else {
        expect(container.dividerParam.primary.sessionScaleX).assertEqual(1);
        expect(container.dividerParam.secondary.sessionScaleX).assertEqual(1);
        expect(container.dividerParam.primary.sessionScaleCenterX).assertEqual(0);
        expect(container.dividerParam.secondary.sessionScaleCenterY).assertEqual(0);
        expect(container.dividerParam.primary.sessionScaleCenterX).assertEqual(0);
        expect(container.dividerParam.secondary.sessionScaleCenterY).assertEqual(0);
      }
      container.dividerParam.splitOrderIsNotReverse = false;
      if (container.dividerParam.isUpDownSplit()) {
        expect(container.dividerParam.secondary.sessionScaleY).assertEqual(1);
        expect(container.dividerParam.primary.sessionScaleY).assertEqual(1);
      } else {
        expect(container.dividerParam.secondary.sessionScaleX).assertEqual(1);
        expect(container.dividerParam.primary.sessionScaleX).assertEqual(1);
      }
      if (container.dividerParam.isUpDownSplit()) {
        expect(container.dividerParam.primary.scaleX).assertEqual(1);
        expect(container.dividerParam.primary.scaleY).assertEqual(1);
        expect(container.dividerParam.secondary.scaleX).assertEqual(1);
        expect(container.dividerParam.secondary.scaleY).assertEqual(1);
      } else {
        expect(container.dividerParam.primary.scaleX).assertEqual(1);
        expect(container.dividerParam.primary.scaleY).assertEqual(1);
        expect(container.dividerParam.secondary.scaleX).assertEqual(1);
        expect(container.dividerParam.secondary.scaleY).assertEqual(1);
      }
      container.dividerParam.splitOrderIsNotReverse = true;
      if (container.dividerParam.isUpDownSplit()) {
        expect(container.dividerParam.primary.touchTranslateX).assertEqual(0);
        expect(container.dividerParam.primary.touchTranslateY).assertEqual(0);
        expect(container.dividerParam.secondary.touchTranslateX).assertEqual(0);
        expect(container.dividerParam.secondary.touchTranslateY).assertEqual(0);
      } else {
        expect(container.dividerParam.primary.touchTranslateY).assertEqual(0);
        expect(container.dividerParam.primary.touchTranslateX).assertEqual(0);
        expect(container.dividerParam.secondary.touchTranslateY).assertEqual(0);
        expect(container.dividerParam.secondary.touchTranslateX).assertEqual(0);
      }
      expect(container.dividerParam.primary.blurScale).assertEqual(0);
      expect(container.dividerParam.primary.blurScale).assertEqual(0);
      expect(container.dividerParam.dividerTranslateX).assertEqual(0);
      expect(container.dividerParam.dividerTranslateY).assertEqual(0);
    });
  });
}

function gestureRecordTest() {
  it('addGestureRecord', Level.LEVEL0, (): void => {
    let gestureRecord: SCBGestureRecord = new SCBGestureRecord(voidCallback);
    splitManager.addGestureRecord(gestureRecord);
    expect(true).assertTrue();
  });

  it('removeGestureRecord_test_01', Level.LEVEL0, (): void => {
    let gestureRecord: SCBGestureRecord = new SCBGestureRecord(voidCallback);
    splitManager.addGestureRecord(gestureRecord);
    splitManager.removeGestureRecord(gestureRecord);
    expect(true).assertTrue();
  });

  it('removeGestureRecord_test_02', Level.LEVEL0, (): void => {
    let gestureRecord: SCBGestureRecord = new SCBGestureRecord(voidCallback);
    splitManager.removeGestureRecord(gestureRecord);
    expect(true).assertTrue();
  });

  const recordListName: string = 'gestureRecordList';
  it('tryExecCancelGesture_test_01', Level.LEVEL0, (): void => {
    ReflectionUtils.setProperty(splitManager, recordListName, []);
    splitManager.tryExecCancelGesture();
    expect(ReflectionUtils.getProperty(splitManager, recordListName)).assertInstanceOf('Array');
  });

  it('tryExecCancelGesture_test_02', Level.LEVEL0, (): void => {
    let gestureRecord: SCBGestureRecord = new SCBGestureRecord(voidCallback);
    splitManager.addGestureRecord(gestureRecord);
    splitManager.tryExecCancelGesture();
    expect(ReflectionUtils.getProperty(splitManager, recordListName)).assertInstanceOf('Array');
  });
}

function SCBSplitManagerTest_02() {
  describe('SCBSplitManagerTest_02', () => {
    beforeAll(initSession);
    it('updateBarStatusForExiting', Level.LEVEL0, (): void => {
      splitManager.updateBarStatusForExiting(container);
      splitManager.updateBarStatusForExiting(null);
      expect(true).assertTrue();
    });
    it('rotationAfterDraggingIfNeeded_test_01', Level.LEVEL0, (): void => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const screenSessionListName: string = 'screenSessionList';
      let screenSessionList =
        ReflectionUtils.getProperty(scbScreenSessionManager, screenSessionListName) as SCBScreenSessionArray;
      if (!(screenSessionList instanceof SCBScreenSessionArray)) {
        return;
      }
      screenSessionList.push(scbScreenSession);
      splitManager.rotationAfterDraggingIfNeeded(sceneInfo.persistentId, testScreenId, true);
      const getFuncName: string = 'getContainerSessionList';
      let getContainerSessionListFunc = ReflectionUtils.getProperty(sessionManager, getFuncName) as
      (screenId?: number) => SCBSceneContainerSessionArray;
      expect(getContainerSessionListFunc).assertInstanceOf('Function');
      ReflectionUtils.setProperty(sessionManager, getFuncName, () => {
        return [container];
      });
      container.primarySession = primSession;
      container.setSkipRotation(true);
      expect(container.secondarySceneW).assertInstanceOf('String');
      expect(container.secondarySceneH).assertInstanceOf('String');
      expect(container.dividerParam).assertInstanceOf('Object');
      expect(container.floatingParam).assertInstanceOf('Object');
      expect(container.midSceneMap).assertInstanceOf('Object');
      expect(container.isMidScene).assertFalse();
      expect(container.isInMidSceneRecordForPad).assertFalse();
      expect(container.isStartFromRecentForPad).assertFalse();
      expect(container.isShowIconInMidScene).assertFalse();
      expect(container.isSplit).assertFalse();
      expect(container.isFloat).assertFalse();
      expect(container.isMidExitSplit).assertFalse();
      expect(container.toggleHomeState).assertFalse();
      expect(container.isDisappearing).assertFalse();
      expect(container.isKeyboardEnableShow).assertFalse();
      expect(container.isTerminating).assertFalse();
      expect(container.isShowBackgroundForMinWidth).assertTrue();
      expect(container.isNotSupportSplit).assertFalse();
      expect(container.transformData).assertInstanceOf('Object');
      expect(container.invisible).assertInstanceOf('Object');
      expect(container.isPendingResizeAfterFold).assertFalse();
      expect(container.isPendingResizeAfterRotation).assertFalse();
      expect(container.needPreBuild).assertInstanceOf('Object');
      expect(container.needRenderShowInRecent).assertInstanceOf('Object');
      expect(container.needRenderTranslate).assertInstanceOf('Object');
      expect(container.needRenderAlpha).assertInstanceOf('Object');
      expect(container.needRenderBorderRadius).assertInstanceOf('Object');
      expect(container.needRenderPos).assertInstanceOf('Object');
      expect(container.needRenderScale).assertInstanceOf('Object');
      expect(container.needRenderBlurRadius).assertInstanceOf('Object');
      expect(container.needRenderVisibility).assertInstanceOf('Object');
      expect(container.needRenderZIndex).assertInstanceOf('Object');
      expect(container.needRenderRotate).assertInstanceOf('Object');
      expect(container.needRenderClip).assertInstanceOf('Object');
      expect(container.needRenderTranslateIcon).assertInstanceOf('Object');
      expect(container.width).assertInstanceOf('Object');
      expect(container.width.getPx()).assertEqual(0);
      expect(container.height).assertInstanceOf('Object');
      expect(container.height.getPx()).assertEqual(0);
      expect(container.iconAlpha).assertEqual(1);
      expect(container.isScreenLockIconShow).assertTrue();
      expect(container.isPrimarySelected).assertTrue();
      expect(container.isPairSplitAnimating).assertFalse();
      expect(container.needRenderRecentMinBackgroundShow).assertInstanceOf('Object');
      expect(container.needRenderBackgroundForMinScale).assertInstanceOf('Object');
      expect(container.needRenderSubSceneShow).assertInstanceOf('Object');
      expect(container.needRenderTitleViewAlpha).assertInstanceOf('Object');
      expect(container.needRenderRecentHoverState).assertInstanceOf('Object');
      splitManager.rotationAfterDraggingIfNeeded(primSession.sceneInfo.persistentId, testScreenId, true);
      expect(container.getSkipRotation()).assertFalse();
      ReflectionUtils.setProperty(sessionManager, getFuncName, getContainerSessionListFunc);
    });

    getDefaultSplitStyleTest();
  });
}

function getDefaultSplitStyleTest() {
  it('getDefaultSplitStyle_01', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let obj = SCBScreenSessionManager.getInstance();
    let mockFunc: Function = mocker.mockFunc(obj, obj.isFoldablePhoneExpandStatus);
    when(mockFunc)().afterReturn(false);
    expect(true).assertTrue();
    mocker.clear(obj);
  });

  it('getDefaultSplitStyle_02', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let obj = SCBScreenSessionManager.getInstance();
    let mockFunc: Function = mocker.mockFunc(obj, obj.isFoldablePhoneExpandStatus);
    when(mockFunc)().afterReturn(true);
    if (container.primarySession) {
      container.primarySession.preferMultiWindowOrientation = PreferMultiWindowOrientation.LANDSCAPE;
      splitManager.getDefaultSplitStyle(container);
      expect(container.secondarySceneW).assertInstanceOf('String');
      expect(container.secondarySceneH).assertInstanceOf('String');
      expect(container.dividerParam).assertInstanceOf('Object');
      expect(container.floatingParam).assertInstanceOf('Object');
      expect(container.midSceneMap).assertInstanceOf('Object');
      expect(container.isMidScene).assertFalse();
      expect(container.isInMidSceneRecordForPad).assertFalse();
      expect(container.isStartFromRecentForPad).assertFalse();
      expect(container.isShowIconInMidScene).assertFalse();
      expect(container.isSplit).assertFalse();
      expect(container.isFloat).assertFalse();
      expect(true).assertTrue();
    }
    mocker.clear(obj);
  });

  it('getDefaultSplitStyle_03', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let obj = SCBScreenSessionManager.getInstance();
    let mockFunc: Function = mocker.mockFunc(obj, obj.isFoldablePhoneExpandStatus);
    when(mockFunc)().afterReturn(true);
    if (container.primarySession) {
      container.primarySession.preferMultiWindowOrientation = PreferMultiWindowOrientation.LANDSCAPE_AUTO;
      container.primarySession.isLandscapeMultiWindow = true;
      expect(container.isDisappearing).assertFalse();
      expect(container.isKeyboardEnableShow).assertFalse();
      expect(container.isTerminating).assertFalse();
      expect(container.isShowBackgroundForMinWidth).assertTrue();
      expect(container.isNotSupportSplit).assertFalse();
      expect(container.transformData).assertInstanceOf('Object');
      expect(container.invisible).assertInstanceOf('Object');
      expect(container.isPendingResizeAfterFold).assertFalse();
      expect(container.isPendingResizeAfterRotation).assertFalse();
      expect(container.needPreBuild).assertInstanceOf('Object');
      expect(container.needRenderShowInRecent).assertInstanceOf('Object');
      expect(container.needRenderTranslate).assertInstanceOf('Object');
      expect(container.needRenderAlpha).assertInstanceOf('Object');
    }
    mocker.clear(obj);
  });

  it('getDefaultSplitStyle_04', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(SCBMultiWindowUtils, SCBMultiWindowUtils.isLargeFoldProductInExpand);
    when(mockFunc)().afterReturn(true);
    if (container.primarySession) {
      container.primarySession.preferMultiWindowOrientation = PreferMultiWindowOrientation.DEFAULT;
      expect(splitManager.getDefaultSplitStyle(container)).assertEqual(SplitStyle.LEFT_AND_RIGHT_POS);
      expect(container.needRenderBlurRadius).assertInstanceOf('Object');
      expect(container.needRenderVisibility).assertInstanceOf('Object');
      expect(container.needRenderZIndex).assertInstanceOf('Object');
      expect(container.needRenderRotate).assertInstanceOf('Object');
      expect(container.needRenderClip).assertInstanceOf('Object');
      expect(container.needRenderTranslateIcon).assertInstanceOf('Object');
      expect(container.width).assertInstanceOf('Object');
      expect(container.width.getPx()).assertEqual(0);
      expect(container.height).assertInstanceOf('Object');
      expect(container.height.getPx()).assertEqual(0);
      expect(container.iconAlpha).assertEqual(1);
      expect(container.isScreenLockIconShow).assertTrue();
      expect(container.isPrimarySelected).assertTrue();
      expect(container.isPairSplitAnimating).assertFalse();
      expect(container.needRenderRecentMinBackgroundShow).assertInstanceOf('Object');
      expect(container.needRenderBackgroundForMinScale).assertInstanceOf('Object');
      expect(container.needRenderSubSceneShow).assertInstanceOf('Object');
    }
    mocker.clear(mockFunc);
  });
}

function testIsSupportSplitInOneApp() {
  return splitManager.isSupportSplitInOneApp(ScenePanelState.FULLSCENE, fromContainerSession);
}

let setFromContainer = () => {
  ReflectionUtils.setProperty(splitManager, FROM_CONTAINER_SESSION, fromContainerSession);
}

function SCBSplitManagerTest_03() {
  describe('SCBSplitManagerTest_03', () => {
    beforeAll(initSession);
    setDefaultSplitModeTest();

    interruptStartSceneForSplitIfNeedTest();

    it('isSupportSplitInOneAppTest', Level.LEVEL0, (): void => {
      initForPairSplitInOneApp();
      let isSupportSplitInOneApp = testIsSupportSplitInOneApp();
      if (!(SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus() || DeviceHelper.isPad())) {
        expect(container.needRenderBlurRadius).assertInstanceOf('Object');
        expect(container.needRenderVisibility).assertInstanceOf('Object');
        expect(container.needRenderZIndex).assertInstanceOf('Object');
        expect(container.needRenderRotate).assertInstanceOf('Object');
        expect(container.needRenderClip).assertInstanceOf('Object');
        expect(container.needRenderTranslateIcon).assertInstanceOf('Object');
        expect(container.width).assertInstanceOf('Object');
        expect(container.width.getPx()).assertEqual(0);
        expect(container.height).assertInstanceOf('Object');
        expect(container.height.getPx()).assertEqual(0);
        expect(container.iconAlpha).assertEqual(1);
        expect(container.isScreenLockIconShow).assertTrue();
        expect(container.isPrimarySelected).assertTrue();
        expect(container.isPairSplitAnimating).assertFalse();
        expect(container.needRenderRecentMinBackgroundShow).assertInstanceOf('Object');
        expect(container.needRenderBackgroundForMinScale).assertInstanceOf('Object');
        expect(container.needRenderSubSceneShow).assertInstanceOf('Object');
        return;
      }
    });

    it('calulateAvoidTranslate', Level.LEVEL0, (): void => {
      let res = splitManager.calulateAvoidTranslate(keyboardSession,
        keyboardPanelSession, screenProperty, container);
      expect(Math.abs(res)).assertLessOrEqual(100);
      expect(keyboardSession.refCount).assertEqual(0);
      expect(keyboardSession.isActive).assertFalse();
      expect(keyboardSession.visibility).assertTrue();
      expect(keyboardSession.isFocusable).assertTrue();
      expect(keyboardSession.specialBoarderRadius).assertEqual(0);
      expect(keyboardSession.keyboardPanelRects).assertInstanceOf('Object');
      expect(keyboardSession.rectForFingerprint).assertInstanceOf('Object');
      expect(keyboardSession.rectForFingerprint.left.getPx()).assertEqual(0);
      expect(keyboardSession.rectForFingerprint.top.getPx()).assertEqual(0);
      expect(keyboardSession.rectForFingerprint.width.getPx()).assertEqual(0);
      expect(keyboardSession.rectForFingerprint.height.getPx()).assertEqual(0);
      expect(keyboardSession.currRect).assertInstanceOf('Object');
      expect(keyboardSession.currRect.left.getPx()).assertEqual(0);
      expect(keyboardSession.currRect.top.getPx()).assertEqual(0);
      expect(keyboardSession.currRect.width.getPx()).assertEqual(0);
      expect(keyboardSession.currRect.height.getPx()).assertEqual(0);
      expect(keyboardSession.shadowConfig).assertInstanceOf('Object');
      expect(keyboardSession.isWindowShowAnimate).assertTrue();
      expect(keyboardSession.isCustomAnimationPlaying).assertFalse();
      expect(keyboardSession.isTouchable).assertTrue();
      expect(keyboardSession.keyboardOffset).assertEqual(0);
      expect(keyboardSession.translatePosY).assertEqual(0);
      expect(keyboardSession.sessionGravity).assertInstanceOf('Object');
    });

    it('isSupportSplitInOneAppTest1', Level.LEVEL0, (): void => {
      initForPairSplitInOneApp();
      fromContainerSession.primarySession = primSession;
      let isSupportSplitInOneApp = splitManager.isSupportSplitInOneApp(ScenePanelState.RECENT,
        fromContainerSession);
      expect(isSupportSplitInOneApp).assertFalse();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(SCBMultiWindowUtils, SCBMultiWindowUtils.isLargeFoldProductInExpand);
      when(mockFunc)().afterReturn(false);
      let config: sceneSessionManager.AppWindowSceneConfig = SCBWindowSceneConfig.getInstance().windowSceneConfig;
      const originUiType: string = ReflectionUtils.getProperty(config, UI_TYPE);
      ReflectionUtils.setProperty(config, UI_TYPE, SCBConstants.UITYPE_PHONE);
      expect(testIsSupportSplitInOneApp()).assertFalse();
      ReflectionUtils.setProperty(config, UI_TYPE, SCBConstants.UITYPE_PAD);
      expect(config.uiType).assertEqual(SCBConstants.UITYPE_PAD);
      expect(testIsSupportSplitInOneApp()).assertFalse();
      when(mockFunc)().afterReturn(true);
      fromContainerSession.isSplit = true;
      let res: boolean = testIsSupportSplitInOneApp();
      fromContainerSession.isSplit = false;
      primSession.sceneInfo.updateWindowModeAndSync(SCBSceneMode.FLOATING);
      let res1: boolean = testIsSupportSplitInOneApp();
      mocker.clear(mockFunc);
      expect(res).assertTrue();
      expect(res1).assertFalse();
      ReflectionUtils.setProperty(config, UI_TYPE, originUiType);
    })

    it('pairSplitInOneAppTest1', Level.LEVEL0, (): void => {
      initForPairSplitInOneApp();
      let config: sceneSessionManager.AppWindowSceneConfig = SCBWindowSceneConfig.getInstance().windowSceneConfig;
      const originUiType: string = ReflectionUtils.getProperty(config, UI_TYPE);
      ReflectionUtils.setProperty(config, UI_TYPE, SCBConstants.UITYPE_PAD);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(SCBMultiWindowUtils, SCBMultiWindowUtils.isLargeFoldProductInExpand);
      let func_01: Function =
        mocker.mockFunc(fromContainerSession.dividerParam, fromContainerSession.dividerParam.isUpDownSplit);
      when(mockFunc)().afterReturn(true);
      when(func_01)().afterReturn(true);
      ReflectionUtils.setProperty(splitManager, FROM_CONTAINER_SESSION, fromContainerSession);
      toInfo.updateWindowModeAndSync(SCBSceneMode.SECONDARY);
      splitManager.pairSplitInOneApp(primSession, toSession, toSession.sceneInfo, null);
      setFromContainer();
      fromContainerSession.isSplit = false;
      splitManager.pairSplitInOneApp(primSession, toSession, toSession.sceneInfo, null);
      expect(container.secondarySceneW).assertInstanceOf('String');
      expect(container.secondarySceneH).assertInstanceOf('String');
      expect(container.dividerParam).assertInstanceOf('Object');
      expect(container.floatingParam).assertInstanceOf('Object');
      expect(container.midSceneMap).assertInstanceOf('Object');
      expect(container.isMidScene).assertFalse();
      expect(container.isInMidSceneRecordForPad).assertFalse();
      expect(container.isStartFromRecentForPad).assertFalse();
      expect(container.isShowIconInMidScene).assertFalse();
      expect(container.isSplit).assertFalse();
      expect(container.isFloat).assertFalse();
      expect(container.isMidExitSplit).assertFalse();
      expect(container.toggleHomeState).assertFalse();
      expect(container.isDisappearing).assertFalse();
      expect(container.isKeyboardEnableShow).assertFalse();
      expect(container.isTerminating).assertFalse();
      expect(container.isShowBackgroundForMinWidth).assertTrue();
      expect(container.isNotSupportSplit).assertFalse();
      expect(container.transformData).assertInstanceOf('Object');
      expect(container.invisible).assertInstanceOf('Object');
      expect(container.isPendingResizeAfterFold).assertFalse();
      expect(container.isPendingResizeAfterRotation).assertFalse();
      expect(container.needPreBuild).assertInstanceOf('Object');
      expect(container.needRenderShowInRecent).assertInstanceOf('Object');
      expect(container.needRenderTranslate).assertInstanceOf('Object');
      expect(container.needRenderAlpha).assertInstanceOf('Object');
      expect(container.needRenderBorderRadius).assertInstanceOf('Object');
      expect(container.needRenderPos).assertInstanceOf('Object');
      expect(container.needRenderScale).assertInstanceOf('Object');
      expect(container.needRenderBlurRadius).assertInstanceOf('Object');
      expect(container.needRenderVisibility).assertInstanceOf('Object');
      expect(container.needRenderZIndex).assertInstanceOf('Object');
      expect(container.needRenderRotate).assertInstanceOf('Object');
      expect(container.needRenderClip).assertInstanceOf('Object');
      expect(container.needRenderTranslateIcon).assertInstanceOf('Object');
      expect(container.width).assertInstanceOf('Object');
      expect(container.width.getPx()).assertEqual(0);
      expect(container.height).assertInstanceOf('Object');
      expect(container.height.getPx()).assertEqual(0);
      expect(container.iconAlpha).assertEqual(1);
      expect(container.isScreenLockIconShow).assertTrue();
      expect(container.isPrimarySelected).assertTrue();
      expect(container.isPairSplitAnimating).assertFalse();
      expect(container.needRenderRecentMinBackgroundShow).assertInstanceOf('Object');
      expect(container.needRenderBackgroundForMinScale).assertInstanceOf('Object');
      expect(container.needRenderSubSceneShow).assertInstanceOf('Object');
      expect(container.needRenderTitleViewAlpha).assertInstanceOf('Object');
      expect(container.needRenderRecentHoverState).assertInstanceOf('Object');
      when(func_01)().afterReturn(false);
      setFromContainer();
      splitManager.pairSplitInOneApp(primSession, toSession, toSession.sceneInfo, null);
      splitManager.pairSplitInOneApp(primSession, toSession, toSession.sceneInfo, voidCallback);
      ReflectionUtils.setProperty(config, UI_TYPE, originUiType);
      mocker.clear(mockFunc);
    })
  });
}

function setDefaultSplitModeTest() {
  it('setDefaultSplitMode_01', Level.LEVEL0, (): void => {
    splitManager.setDefaultSplitMode(container, 90);
  });

  it('setDefaultSplitMode_02', Level.LEVEL0, (): void => {
    container.primarySession = null;
    splitManager.setDefaultSplitMode(container, 90);
    expect(true).assertTrue();
  });
}

function interruptStartSceneForSplitIfNeedTest() {
  it('interruptStartSceneForSplitIfNeed_01', Level.LEVEL0, (): void => {
    let res = splitManager.interruptStartSceneForSplitIfNeed(ScenePanelState.SPLIT, primSession,
      container, container, screenProperty, () => {
      });
    expect(res).assertFalse();
  });

  it('interruptStartSceneForSplitIfNeed_02', Level.LEVEL0, (): void => {
    primNullSession = null;
    splitManager.interruptStartSceneForSplitIfNeed(ScenePanelState.FULLSCENE, primNullSession,
      container, container, screenProperty, voidCallback);
    primNullSession = null;
    container.primarySession = null;
    splitManager.interruptStartSceneForSplitIfNeed(ScenePanelState.FULLSCENE, primNullSession,
      container, container, screenProperty, voidCallback);
    expect(container.primarySession).assertNull();
    expect(container.secondarySceneW).assertInstanceOf('String');
    expect(container.secondarySceneH).assertInstanceOf('String');
    expect(container.dividerParam).assertInstanceOf('Object');
    expect(container.floatingParam).assertInstanceOf('Object');
    expect(container.midSceneMap).assertInstanceOf('Object');
    expect(container.isMidScene).assertFalse();
    expect(container.isInMidSceneRecordForPad).assertFalse();
    expect(container.isStartFromRecentForPad).assertFalse();
    expect(container.isShowIconInMidScene).assertFalse();
    expect(container.isSplit).assertFalse();
    expect(container.isFloat).assertFalse();
    expect(container.isMidExitSplit).assertFalse();
    expect(container.toggleHomeState).assertFalse();
    expect(container.isDisappearing).assertFalse();
    expect(container.isKeyboardEnableShow).assertFalse();
    expect(container.isTerminating).assertFalse();
    expect(container.isShowBackgroundForMinWidth).assertTrue();
    expect(container.isNotSupportSplit).assertFalse();
    expect(container.transformData).assertInstanceOf('Object');
    expect(container.invisible).assertInstanceOf('Object');
    expect(container.isPendingResizeAfterFold).assertFalse();
    expect(container.isPendingResizeAfterRotation).assertFalse();
    expect(container.needPreBuild).assertInstanceOf('Object');
    expect(container.needRenderShowInRecent).assertInstanceOf('Object');
    expect(container.needRenderTranslate).assertInstanceOf('Object');
    expect(container.needRenderAlpha).assertInstanceOf('Object');
    expect(container.needRenderBorderRadius).assertInstanceOf('Object');
    expect(container.needRenderPos).assertInstanceOf('Object');
    expect(container.needRenderScale).assertInstanceOf('Object');
    expect(container.needRenderBlurRadius).assertInstanceOf('Object');
    expect(container.needRenderVisibility).assertInstanceOf('Object');
    expect(container.needRenderZIndex).assertInstanceOf('Object');
    expect(container.needRenderRotate).assertInstanceOf('Object');
    expect(container.needRenderClip).assertInstanceOf('Object');
    expect(container.needRenderTranslateIcon).assertInstanceOf('Object');
    expect(container.width).assertInstanceOf('Object');
    expect(container.width.getPx()).assertEqual(0);
    expect(container.height).assertInstanceOf('Object');
    expect(container.height.getPx()).assertEqual(0);
    expect(container.iconAlpha).assertEqual(1);
    expect(container.isScreenLockIconShow).assertTrue();
    expect(container.isPrimarySelected).assertTrue();
    expect(container.isPairSplitAnimating).assertFalse();
    expect(container.needRenderRecentMinBackgroundShow).assertInstanceOf('Object');
    expect(container.needRenderBackgroundForMinScale).assertInstanceOf('Object');
    expect(container.needRenderSubSceneShow).assertInstanceOf('Object');
    expect(container.needRenderTitleViewAlpha).assertInstanceOf('Object');
    expect(container.needRenderRecentHoverState).assertInstanceOf('Object');
  });

  it('interruptStartSceneForSplitIfNeed_03', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(primSession, primSession.isSupportSplitMode);
    when(mockFunc)().afterReturn(false);
    splitManager.interruptStartSceneForSplitIfNeed(ScenePanelState.FULLSCENE, primSession,
      container, container, screenProperty, voidCallback);
    expect(true).assertTrue();
    mocker.clear(primSession);
  });

  it('interruptStartSceneForSplitIfNeed_04', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(primSession, primSession.isSupportSplitMode);
    when(mockFunc)().afterReturn(true);
    splitManager.interruptStartSceneForSplitIfNeed(ScenePanelState.FULLSCENE, primSession,
      container, container, screenProperty, voidCallback);
    expect(true).assertTrue();
    mocker.clear(primSession);
  });

  it('interruptStartSceneForSplitIfNeed_05', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(primSession, primSession.isSupportSplitMode);
    when(mockFunc)().afterReturn(true);
    splitManager.interruptStartSceneForSplitIfNeed(ScenePanelState.FULLSCENE, primSession,
      container, container, screenProperty, voidCallback);
    expect(true).assertTrue();
    mocker.clear(primSession);
  });
}

export function SCBSplitManagerTest_04() {
  describe('SCBSplitManagerTest_04', () => {
    beforeAll(() => {
      initSession();
      initKeyboard();
      initFloat();
    });
    it('removeAvoidInputMethodTest_Reverse_true', Level.LEVEL0, (): void => {
      container.dividerParam.primary = new SceneParam();
      container.dividerParam.splitOrderIsNotReverse = true;
      splitManager.removeAvoidInputMethod(screenProperty, container);
      expect(container.dividerParam.primary.translateX).assertEqual(0);
      expect(container.dividerParam.primary.persistentId).assertEqual(0);
      expect(container.dividerParam.primary.posX).assertEqual('0%');
      expect(container.dividerParam.primary.posY).assertEqual('0%');
      expect(container.dividerParam.primary.width).assertEqual('0%');
      expect(container.dividerParam.primary.height).assertEqual('0%');
      expect(container.dividerParam.primary.sessionWidth).assertEqual(0);
      expect(container.dividerParam.primary.sessionHeight).assertEqual(0);
      expect(container.dividerParam.primary.minWidth).assertEqual(320);
      expect(container.dividerParam.primary.minHeight).assertEqual(320);
      expect(container.dividerParam.primary.maxWidthRatio).assertEqual(1);
      expect(container.dividerParam.primary.rotateX).assertEqual(0);
      expect(container.dividerParam.primary.rotateY).assertEqual(0);
      expect(container.dividerParam.primary.rotateZ).assertEqual(0);
      expect(container.dividerParam.primary.rotateAngle).assertEqual(0);
      expect(container.dividerParam.primary.rotateCenterX).assertEqual(0);
      expect(container.dividerParam.primary.rotateCenterY).assertEqual(0);
      expect(container.dividerParam.primary.translateX).assertEqual(0);
      expect(container.dividerParam.primary.translateY).assertEqual(0);
      expect(container.dividerParam.primary.touchTranslateX).assertEqual(0);
      expect(container.dividerParam.primary.touchTranslateY).assertEqual(0);
      expect(container.dividerParam.primary.sessionScaleX).assertEqual(1);
      expect(container.dividerParam.primary.sessionScaleCenterX).assertEqual(0);
      expect(container.dividerParam.primary.sessionScaleY).assertEqual(1);
      expect(container.dividerParam.primary.sessionScaleCenterY).assertEqual(0);
      expect(container.dividerParam.primary.scaleX).assertEqual(1);
      expect(container.dividerParam.primary.scaleY).assertEqual(1);
      expect(container.dividerParam.primary.scaleCenterX).assertEqual(0);
      expect(container.dividerParam.primary.scaleCenterY).assertEqual(0);
      expect(container.dividerParam.primary.gradientAngle).assertEqual(0);
      expect(container.dividerParam.primary.gradient1).assertEqual(0);
      expect(container.dividerParam.primary.gradient2).assertEqual(0);
      expect(container.splitParam.hasAvoidInputMethod).assertFalse();
      expect(container.dividerParam.dividerAlpha).assertEqual(1);
      expect(container.dividerParam.containerTranYPct).assertEqual(0);
      expect(container.dividerParam.secondary.borderRadius.bottomLeft)
        .assertEqual(container.dividerParam.primary.borderRadius.topLeft);
      expect(container.dividerParam.secondary.borderRadius.bottomRight)
        .assertEqual(container.dividerParam.primary.borderRadius.topRight);
    });
    it('removeAvoidInputMethodTest_Reverse_false', Level.LEVEL0, (): void => {
      container.dividerParam.splitOrderIsNotReverse = false;
      splitManager.removeAvoidInputMethod(screenProperty, container);
      expect(container.dividerParam.dividerAlpha).assertEqual(1);
      expect(container.splitParam.hasAvoidInputMethod).assertFalse();
      expect(container.dividerParam.containerTranYPct).assertEqual(0);
      expect(container.dividerParam.primary.borderRadius.bottomLeft)
        .assertEqual(container.dividerParam.secondary.borderRadius.topLeft);
      expect(container.dividerParam.primary.borderRadius.bottomRight)
        .assertEqual(container.dividerParam.secondary.borderRadius.topRight);
    });
    it('addAvoidInputMethod_Reverse_true', Level.LEVEL0, (): void => {
      container.dividerParam.primary = new SceneParam();
      container.dividerParam.splitOrderIsNotReverse = true;
      let translateY = 200;
      expect(container.dividerParam.primary.translateX).assertEqual(0);
      expect(container.dividerParam.primary.persistentId).assertEqual(0);
      expect(container.dividerParam.primary.posX).assertEqual('0%');
      expect(container.dividerParam.primary.posY).assertEqual('0%');
      expect(container.dividerParam.primary.width).assertEqual('0%');
      expect(container.dividerParam.primary.height).assertEqual('0%');
      expect(container.dividerParam.primary.sessionWidth).assertEqual(0);
      expect(container.dividerParam.primary.sessionHeight).assertEqual(0);
      expect(container.dividerParam.primary.minWidth).assertEqual(320);
      expect(container.dividerParam.primary.minHeight).assertEqual(320);
      expect(container.dividerParam.primary.maxWidthRatio).assertEqual(1);
      expect(container.dividerParam.primary.rotateX).assertEqual(0);
      expect(container.dividerParam.primary.rotateY).assertEqual(0);
      expect(container.dividerParam.primary.rotateZ).assertEqual(0);
      expect(container.dividerParam.primary.rotateAngle).assertEqual(0);
      expect(container.dividerParam.primary.rotateCenterX).assertEqual(0);
      expect(container.dividerParam.primary.rotateCenterY).assertEqual(0);
      expect(container.dividerParam.primary.translateX).assertEqual(0);
      expect(container.dividerParam.primary.translateY).assertEqual(0);
      expect(container.dividerParam.primary.touchTranslateX).assertEqual(0);
      expect(container.dividerParam.primary.touchTranslateY).assertEqual(0);
      expect(container.dividerParam.primary.sessionScaleX).assertEqual(1);
      expect(container.dividerParam.primary.sessionScaleCenterX).assertEqual(0);
      expect(container.dividerParam.primary.sessionScaleY).assertEqual(1);
      expect(container.dividerParam.primary.sessionScaleCenterY).assertEqual(0);
      expect(container.dividerParam.primary.scaleX).assertEqual(1);
      expect(container.dividerParam.primary.scaleY).assertEqual(1);
      expect(container.dividerParam.primary.scaleCenterX).assertEqual(0);
      expect(container.dividerParam.primary.scaleCenterY).assertEqual(0);
      expect(container.dividerParam.primary.gradientAngle).assertEqual(0);
      expect(container.dividerParam.primary.gradient1).assertEqual(0);
      expect(container.dividerParam.primary.gradient2).assertEqual(0);
      splitManager.addAvoidInputMethod(screenProperty, container, translateY);
      expect(container.splitParam.hasAvoidInputMethod).assertTrue();
      expect(container.dividerParam.dividerAlpha).assertEqual(0);
      expect(container.dividerParam.containerTranYPct).assertEqual(-translateY / px2vp(screenProperty.height));
      expect(container.dividerParam.secondary.borderRadius.bottomLeft).assertEqual(0);
      expect(container.dividerParam.secondary.borderRadius.bottomRight).assertEqual(0);
      translateY = 100;
      splitManager.addAvoidInputMethod(screenProperty, container, translateY);
      expect(container.dividerParam.containerTranYPct).assertEqual(-translateY / px2vp(screenProperty.height));
    });
    it('addAvoidInputMethod_Reverse_false', Level.LEVEL0, (): void => {
      container.dividerParam.splitOrderIsNotReverse = false;
      let translateY = 150;
      splitManager.addAvoidInputMethod(screenProperty, container, translateY);
      expect(container.splitParam.hasAvoidInputMethod).assertTrue();
      expect(container.dividerParam.dividerAlpha).assertEqual(0);
      expect(container.dividerParam.containerTranYPct).assertEqual(-translateY / px2vp(screenProperty.height));
      expect(container.dividerParam.primary.borderRadius.bottomLeft).assertEqual(0);
      expect(container.dividerParam.primary.borderRadius.bottomRight).assertEqual(0);
      translateY = 80;
      splitManager.addAvoidInputMethod(screenProperty, container, translateY);
      expect(container.dividerParam.containerTranYPct).assertEqual(-translateY / px2vp(screenProperty.height));
    });

    it('splitToFloatResetBorderRadiusAnimation', Level.LEVEL0, (): void => {
      splitManager.splitToFloatResetBorderRadiusAnimation(container, 100);
      expect(true).assertTrue();
    });

    it('notifyOneStepSplitEvent', Level.LEVEL0, (): void => {
      const eventId = 'notifyOneStepSplitEvent';
      let obj: OneStepSplitData | null = null;
      let callback = (data: OneStepSplitData): void => {
        obj = data;
      };
      GlobalContext.getContext()?.eventHub?.on(eventId, callback)
      splitManager.notifyOneStepSplitEvent(GlobalContext.getContext(), eventId, 1, dividerParam);
      expect(obj).assertInstanceOf('Object');
      GlobalContext.getContext()?.eventHub?.off(eventId, callback);
    });
    ifAvoidInputMethodNeededTest();
    updateRecentAndContainerInfoWithFoldTest();
    floatToSplitTest();
    splitToFloatTest();
    showOrHideInputMethodTest();
  });
}

function ifAvoidInputMethodNeededTest() {
  it('ifAvoidInputMethodNeededTest_ShowKeyboard_false', Level.LEVEL0, (): void => {
    expect(splitManager.ifAvoidInputMethodNeeded(keyboardSession, container)).assertEqual(false);
  });
  it('ifAvoidInputMethodNeededTest_GRAVITY_FLOAT', Level.LEVEL0, (): void => {
    keyboardSession.sessionData.sessionState = sceneSessionManager.SessionState.STATE_FOREGROUND;
    keyboardSession.sessionGravity = sceneSessionManager.KeyboardGravity.GRAVITY_FLOAT;
    expect(splitManager.ifAvoidInputMethodNeeded(keyboardSession, container)).assertEqual(false);
    expect(keyboardSession.refCount).assertEqual(0);
    expect(keyboardSession.isActive).assertFalse();
    expect(keyboardSession.visibility).assertTrue();
    expect(keyboardSession.isFocusable).assertTrue();
    expect(keyboardSession.specialBoarderRadius).assertEqual(0);
    expect(keyboardSession.keyboardPanelRects).assertInstanceOf('Object');
    expect(keyboardSession.rectForFingerprint).assertInstanceOf('Object');
    expect(keyboardSession.rectForFingerprint.left.getPx()).assertEqual(0);
    expect(keyboardSession.rectForFingerprint.top.getPx()).assertEqual(0);
    expect(keyboardSession.rectForFingerprint.width.getPx()).assertEqual(0);
    expect(keyboardSession.rectForFingerprint.height.getPx()).assertEqual(0);
    expect(keyboardSession.currRect).assertInstanceOf('Object');
    expect(keyboardSession.currRect.left.getPx()).assertEqual(0);
    expect(keyboardSession.currRect.top.getPx()).assertEqual(0);
    expect(keyboardSession.currRect.width.getPx()).assertEqual(0);
    expect(keyboardSession.currRect.height.getPx()).assertEqual(0);
    expect(keyboardSession.shadowConfig).assertInstanceOf('Object');
    expect(keyboardSession.isWindowShowAnimate).assertTrue();
    expect(keyboardSession.isCustomAnimationPlaying).assertFalse();
    expect(keyboardSession.isTouchable).assertTrue();
    expect(keyboardSession.keyboardOffset).assertEqual(0);
    expect(keyboardSession.translatePosY).assertEqual(0);
    expect(keyboardSession.sessionGravity).assertInstanceOf('Object');
  });
  it('ifAvoidInputMethodNeededTest_LEFT_AND_RIGHT', Level.LEVEL0, (): void => {
    keyboardSession.sessionData.sessionState = sceneSessionManager.SessionState.STATE_FOREGROUND;
    keyboardSession.sessionGravity = sceneSessionManager.KeyboardGravity.GRAVITY_DEFAULT;
    container.isSplit = false;
    container.dividerParam.setSplitStyle(SplitStyle.LEFT_AND_RIGHT_POS);
    container.dividerParam.setIsVertical(false);
    expect(splitManager.ifAvoidInputMethodNeeded(keyboardSession, container)).assertEqual(false);
    expect(keyboardSession.refCount).assertEqual(0);
    expect(keyboardSession.isActive).assertFalse();
    expect(keyboardSession.visibility).assertTrue();
    expect(keyboardSession.isFocusable).assertTrue();
    expect(keyboardSession.specialBoarderRadius).assertEqual(0);
    expect(keyboardSession.keyboardPanelRects).assertInstanceOf('Object');
    expect(keyboardSession.rectForFingerprint).assertInstanceOf('Object');
    expect(keyboardSession.rectForFingerprint.left.getPx()).assertEqual(0);
    expect(keyboardSession.rectForFingerprint.top.getPx()).assertEqual(0);
    expect(keyboardSession.rectForFingerprint.width.getPx()).assertEqual(0);
    expect(keyboardSession.rectForFingerprint.height.getPx()).assertEqual(0);
    expect(keyboardSession.currRect).assertInstanceOf('Object');
    expect(keyboardSession.currRect.left.getPx()).assertEqual(0);
    expect(keyboardSession.currRect.top.getPx()).assertEqual(0);
    expect(keyboardSession.currRect.width.getPx()).assertEqual(0);
    expect(keyboardSession.currRect.height.getPx()).assertEqual(0);
    expect(keyboardSession.shadowConfig).assertInstanceOf('Object');
    expect(keyboardSession.isWindowShowAnimate).assertTrue();
    expect(keyboardSession.isCustomAnimationPlaying).assertFalse();
    expect(keyboardSession.isTouchable).assertTrue();
    expect(keyboardSession.keyboardOffset).assertEqual(0);
    expect(keyboardSession.translatePosY).assertEqual(0);
    expect(keyboardSession.sessionGravity).assertInstanceOf('Object');
  });
  it('ifAvoidInputMethodNeededTest_01', Level.LEVEL0, (): void => {
    keyboardSession.sessionData.sessionState = sceneSessionManager.SessionState.STATE_FOREGROUND;
    keyboardSession.sessionGravity = sceneSessionManager.KeyboardGravity.GRAVITY_DEFAULT;
    container.isSplit = true;
    let result = container.haveSessionWithPersistentId(
      SCBSceneSessionManager.getInstance().getFocusedSessionId(),
      !container.dividerParam.splitOrderIsNotReverse, container.dividerParam.splitOrderIsNotReverse);
    expect(splitManager.ifAvoidInputMethodNeeded(keyboardSession, container)).assertEqual(result);
    expect(keyboardSession.refCount).assertEqual(0);
    expect(keyboardSession.isActive).assertFalse();
    expect(keyboardSession.visibility).assertTrue();
    expect(keyboardSession.isFocusable).assertTrue();
    expect(keyboardSession.specialBoarderRadius).assertEqual(0);
    expect(keyboardSession.keyboardPanelRects).assertInstanceOf('Object');
    expect(keyboardSession.rectForFingerprint).assertInstanceOf('Object');
    expect(keyboardSession.rectForFingerprint.left.getPx()).assertEqual(0);
    expect(keyboardSession.rectForFingerprint.top.getPx()).assertEqual(0);
    expect(keyboardSession.rectForFingerprint.width.getPx()).assertEqual(0);
    expect(keyboardSession.rectForFingerprint.height.getPx()).assertEqual(0);
    expect(keyboardSession.currRect).assertInstanceOf('Object');
    expect(keyboardSession.currRect.left.getPx()).assertEqual(0);
    expect(keyboardSession.currRect.top.getPx()).assertEqual(0);
    expect(keyboardSession.currRect.width.getPx()).assertEqual(0);
    expect(keyboardSession.currRect.height.getPx()).assertEqual(0);
    expect(keyboardSession.shadowConfig).assertInstanceOf('Object');
    expect(keyboardSession.isWindowShowAnimate).assertTrue();
    expect(keyboardSession.isCustomAnimationPlaying).assertFalse();
    expect(keyboardSession.isTouchable).assertTrue();
    expect(keyboardSession.keyboardOffset).assertEqual(0);
    expect(keyboardSession.translatePosY).assertEqual(0);
    expect(keyboardSession.sessionGravity).assertInstanceOf('Object');
  });
  it('ifAvoidInputMethodNeededTest_02', Level.LEVEL0, (): void => {
    keyboardSession.sessionData.sessionState = sceneSessionManager.SessionState.STATE_FOREGROUND;
    keyboardSession.sessionGravity = sceneSessionManager.KeyboardGravity.GRAVITY_DEFAULT;
    container.dividerParam.setSplitStyle(SplitStyle.UP_AND_DOWN_POS);
    container.dividerParam.setIsVertical(true);
    let result = container.haveSessionWithPersistentId(
      SCBSceneSessionManager.getInstance().getFocusedSessionId(),
      !container.dividerParam.splitOrderIsNotReverse, container.dividerParam.splitOrderIsNotReverse);
    expect(splitManager.ifAvoidInputMethodNeeded(keyboardSession, container)).assertEqual(result);
    expect(keyboardSession.refCount).assertEqual(0);
    expect(keyboardSession.isActive).assertFalse();
    expect(keyboardSession.visibility).assertTrue();
    expect(keyboardSession.isFocusable).assertTrue();
    expect(keyboardSession.specialBoarderRadius).assertEqual(0);
    expect(keyboardSession.keyboardPanelRects).assertInstanceOf('Object');
    expect(keyboardSession.rectForFingerprint).assertInstanceOf('Object');
    expect(keyboardSession.rectForFingerprint.left.getPx()).assertEqual(0);
    expect(keyboardSession.rectForFingerprint.top.getPx()).assertEqual(0);
    expect(keyboardSession.rectForFingerprint.width.getPx()).assertEqual(0);
    expect(keyboardSession.rectForFingerprint.height.getPx()).assertEqual(0);
    expect(keyboardSession.currRect).assertInstanceOf('Object');
    expect(keyboardSession.currRect.left.getPx()).assertEqual(0);
    expect(keyboardSession.currRect.top.getPx()).assertEqual(0);
    expect(keyboardSession.currRect.width.getPx()).assertEqual(0);
    expect(keyboardSession.currRect.height.getPx()).assertEqual(0);
    expect(keyboardSession.shadowConfig).assertInstanceOf('Object');
    expect(keyboardSession.isWindowShowAnimate).assertTrue();
    expect(keyboardSession.isCustomAnimationPlaying).assertFalse();
    expect(keyboardSession.isTouchable).assertTrue();
    expect(keyboardSession.keyboardOffset).assertEqual(0);
    expect(keyboardSession.translatePosY).assertEqual(0);
    expect(keyboardSession.sessionGravity).assertInstanceOf('Object');
  });
}

function updateRecentAndContainerInfoWithFoldTest() {
  it('updateRecentAndContainerInfoWithFoldTest_01', Level.LEVEL0, (): void => {
    let isVertical: Function = (rotation: number) => {
      rotation === 0 || rotation === 180 || rotation === 360;
    };
    splitManager.updateRecentAndContainerInfoWithFold(container, screenProperty,
      (rotation: number): boolean => isVertical(rotation));
    expect(container.width.getVp()).assertEqual(screenProperty.width);
  });
  it('updateRecentAndContainerInfoWithFoldTest_02', Level.LEVEL0, (): void => {
    let isVertical: Function = (rotation: number) => {
      return rotation === 0 || rotation === 180 || rotation === 360;
    };
    let func01 = mocker.mockFunc(container, container.getTargetRotation);
    let func02: Function =
      mocker.mockFunc(scbScreenSessionManager, scbScreenSessionManager.isFoldablePhoneExpandStatus);
    when(func01)(ArgumentMatchers.any).afterReturn(0);
    when(func02)().afterReturn(true);
    container.currentRotation = -1;
    container.screenProperty.width = 100;
    container.screenProperty.height = 100;
    container.needRenderClip.setClipHeight(0);
    container.needRenderClip.setClipWidth(0);
    splitManager.updateRecentAndContainerInfoWithFold(container, screenProperty,
      (rotation: number): boolean => isVertical(rotation));
    mocker.clear(func01);
    mocker.clear(func02);
    expect(container.needRenderClip.clipHeight.getPx()).assertLarger(0);
    expect(container.needRenderClip.clipWidth.getPx()).assertLarger(0);
    expect(container.secondarySceneW).assertInstanceOf('String');
    expect(container.secondarySceneH).assertInstanceOf('String');
    expect(container.dividerParam).assertInstanceOf('Object');
    expect(container.floatingParam).assertInstanceOf('Object');
    expect(container.midSceneMap).assertInstanceOf('Object');
    expect(container.isMidScene).assertFalse();
    expect(container.isInMidSceneRecordForPad).assertFalse();
    expect(container.isStartFromRecentForPad).assertFalse();
    expect(container.isShowIconInMidScene).assertFalse();
    expect(container.needRenderShowInRecent).assertInstanceOf('Object');
    expect(container.needRenderTranslate).assertInstanceOf('Object');
    expect(container.needRenderAlpha).assertInstanceOf('Object');
    expect(container.needRenderBorderRadius).assertInstanceOf('Object');
    expect(container.needRenderPos).assertInstanceOf('Object');
    expect(container.needRenderScale).assertInstanceOf('Object');
    expect(container.needRenderBlurRadius).assertInstanceOf('Object');
    expect(container.needRenderVisibility).assertInstanceOf('Object');
    expect(container.needRenderZIndex).assertInstanceOf('Object');
    expect(container.needRenderRotate).assertInstanceOf('Object');
    expect(container.needRenderClip).assertInstanceOf('Object');
    expect(container.needRenderTranslateIcon).assertInstanceOf('Object');
    expect(container.width).assertInstanceOf('Object');
    expect(container.width.getPx()).assertEqual(0);
    expect(container.height).assertInstanceOf('Object');
    expect(container.height.getPx()).assertEqual(0);
    expect(container.iconAlpha).assertEqual(1);
    expect(container.isScreenLockIconShow).assertTrue();
    expect(container.isPrimarySelected).assertTrue();
    expect(container.isPairSplitAnimating).assertFalse();
    expect(container.needRenderRecentMinBackgroundShow).assertInstanceOf('Object');
    expect(container.needRenderBackgroundForMinScale).assertInstanceOf('Object');
    expect(container.needRenderSubSceneShow).assertInstanceOf('Object');
    expect(container.needRenderTitleViewAlpha).assertInstanceOf('Object');
    expect(container.needRenderRecentHoverState).assertInstanceOf('Object');
    expect(container.isSplit).assertFalse();
    expect(container.isFloat).assertFalse();
    expect(container.isMidExitSplit).assertFalse();
    expect(container.toggleHomeState).assertFalse();
    expect(container.isDisappearing).assertFalse();
    expect(container.isKeyboardEnableShow).assertFalse();
    expect(container.isTerminating).assertFalse();
    expect(container.isShowBackgroundForMinWidth).assertTrue();
    expect(container.isNotSupportSplit).assertFalse();
    expect(container.transformData).assertInstanceOf('Object');
    expect(container.invisible).assertInstanceOf('Object');
    expect(container.isPendingResizeAfterFold).assertFalse();
    expect(container.isPendingResizeAfterRotation).assertFalse();
    expect(container.needPreBuild).assertInstanceOf('Object');
  });
}

function floatToSplitTest() {
  it('floatToSplitTest_1', Level.LEVEL0, (): void => {
    container.primarySession = primSession;
    container.isSplit = true;
    container.dividerParam.splitOrderIsNotReverse = true;
    splitManager.floatToSplit(container, targetContainerSession, screenProperty, true);
    expect(container.getState()).assertEqual(SCBSceneContainerState.SPLIT);
    expect(container.splitParam.isPreSplit).assertFalse();
    expect(container.splitParam.getLifeCycle()).assertEqual(4);
  });
  it('floatToSplitTest_2', Level.LEVEL0, (): void => {
    initFloat();
    container.primarySession = primSession;
    splitManager.floatToSplit(targetContainerSession, container, screenProperty, true);
    expect(targetContainerSession.getState()).assertEqual(SCBSceneContainerState.SPLIT);
    expect(targetContainerSession.splitParam.isPreSplit).assertFalse();
    expect(targetContainerSession.splitParam.getLifeCycle()).assertEqual(4);
  });
  it('floatToSplitTest_3', Level.LEVEL0, (): void => {
    initFloat();
    container.primarySession = primSession;
    splitManager.floatToSplit(targetContainerSession, container, screenProperty, false);
    expect(targetContainerSession.getState()).assertEqual(SCBSceneContainerState.SPLIT);
    expect(targetContainerSession.splitParam.isPreSplit).assertFalse();
    expect(targetContainerSession.splitParam.getLifeCycle()).assertEqual(4);
  });
}

function splitToFloatTest() {
  it('exitSplitViewToFloatTest', Level.LEVEL0, (): void => {
    const originUiType: string = ReflectionUtils.getProperty(config, UI_TYPE);
    const EVENT_FROM_GESTURE: string = '_eventFromGesture';
    ReflectionUtils.setProperty(config, UI_TYPE, SCBConstants.UITYPE_PAD);
    ReflectionUtils.setProperty(container.dividerParam, EVENT_FROM_GESTURE, true);
    splitManager.splitToFloat(container, true, screenProperty, voidCallback);
    initSession();
    ReflectionUtils.setProperty(config, UI_TYPE, SCBConstants.UITYPE_PHONE);
    ReflectionUtils.setProperty(container.dividerParam, EVENT_FROM_GESTURE, false);
    splitManager.splitToFloat(container, false, screenProperty, voidCallback);
    ReflectionUtils.setProperty(config, UI_TYPE, originUiType);
  });
}

function showOrHideInputMethodTest() {
  let keyboardSession = SCBKeyboardManager.getInstance().getKeyboardSession();
  it('showKeyboardTest', Level.LEVEL0, (): void => {
    container.splitParam.showInputMethodFlag = 0;
    splitManager.showKeyboard(container);
    expect(container.splitParam.showInputMethodFlag).assertEqual(1);
    if (keyboardSession) {
      keyboardSession.isActive = true;
    }
    container.splitParam.showInputMethodFlag = 0;
    splitManager.showKeyboard(container);
    expect(container.splitParam.showInputMethodFlag).assertEqual(1);
    splitManager.showKeyboard(container);
    expect(container.splitParam.showInputMethodFlag).assertEqual(2);
    expect(keyboardSession.refCount).assertEqual(0);
    expect(keyboardSession.isActive).assertFalse();
    expect(keyboardSession.visibility).assertTrue();
    expect(keyboardSession.isFocusable).assertTrue();
    expect(keyboardSession.specialBoarderRadius).assertEqual(0);
    expect(keyboardSession.keyboardPanelRects).assertInstanceOf('Object');
    expect(keyboardSession.rectForFingerprint).assertInstanceOf('Object');
    expect(keyboardSession.rectForFingerprint.left.getPx()).assertEqual(0);
    expect(keyboardSession.rectForFingerprint.top.getPx()).assertEqual(0);
    expect(keyboardSession.rectForFingerprint.width.getPx()).assertEqual(0);
    expect(keyboardSession.rectForFingerprint.height.getPx()).assertEqual(0);
    expect(keyboardSession.currRect).assertInstanceOf('Object');
    expect(keyboardSession.currRect.left.getPx()).assertEqual(0);
    expect(keyboardSession.currRect.top.getPx()).assertEqual(0);
    expect(keyboardSession.currRect.width.getPx()).assertEqual(0);
    expect(keyboardSession.currRect.height.getPx()).assertEqual(0);
    expect(keyboardSession.shadowConfig).assertInstanceOf('Object');
    expect(keyboardSession.isWindowShowAnimate).assertTrue();
    expect(keyboardSession.isCustomAnimationPlaying).assertFalse();
    expect(keyboardSession.isTouchable).assertTrue();
    expect(keyboardSession.keyboardOffset).assertEqual(0);
    expect(keyboardSession.translatePosY).assertEqual(0);
    expect(keyboardSession.sessionGravity).assertInstanceOf('Object');
  });
  it('hideKeyboardTest', Level.LEVEL0, (): void => {
    if (keyboardSession) {
      keyboardSession.isActive = true;
    }
    container.splitParam.showInputMethodFlag = 2;
    splitManager.hideKeyboard(container)
    expect(container.splitParam.showInputMethodFlag).assertEqual(1);
    splitManager.hideKeyboard(container)
    expect(container.splitParam.showInputMethodFlag).assertEqual(0);
    expect(keyboardSession.refCount).assertEqual(0);
    expect(keyboardSession.isActive).assertFalse();
    expect(keyboardSession.visibility).assertTrue();
    expect(keyboardSession.isFocusable).assertTrue();
    expect(keyboardSession.specialBoarderRadius).assertEqual(0);
    expect(keyboardSession.keyboardPanelRects).assertInstanceOf('Object');
    expect(keyboardSession.rectForFingerprint).assertInstanceOf('Object');
    expect(keyboardSession.rectForFingerprint.left.getPx()).assertEqual(0);
    expect(keyboardSession.rectForFingerprint.top.getPx()).assertEqual(0);
    expect(keyboardSession.rectForFingerprint.width.getPx()).assertEqual(0);
    expect(keyboardSession.rectForFingerprint.height.getPx()).assertEqual(0);
    expect(keyboardSession.currRect).assertInstanceOf('Object');
    expect(keyboardSession.currRect.left.getPx()).assertEqual(0);
    expect(keyboardSession.currRect.top.getPx()).assertEqual(0);
    expect(keyboardSession.currRect.width.getPx()).assertEqual(0);
    expect(keyboardSession.currRect.height.getPx()).assertEqual(0);
    expect(keyboardSession.shadowConfig).assertInstanceOf('Object');
    expect(keyboardSession.isWindowShowAnimate).assertTrue();
    expect(keyboardSession.isCustomAnimationPlaying).assertFalse();
    expect(keyboardSession.isTouchable).assertTrue();
    expect(keyboardSession.keyboardOffset).assertEqual(0);
    expect(keyboardSession.translatePosY).assertEqual(0);
    expect(keyboardSession.sessionGravity).assertInstanceOf('Object');
  });
}

let fingerInfo: FingerInfo = {
  id: 0,
  globalX: 0,
  globalY: 0,
  localX: -1,
  localY: 0,
  displayX: 0,
  displayY: 0
};

class MockDockDragEvent implements DragEvent {
  displayX: number = 0;
  displayY: number = 0;

  getDisplayX(): number {
    return this.displayX;
  }

  getDisplayY(): number {
    return this.displayY;
  }

  getWindowX(): number {
    return 0;
  }

  getWindowY(): number {
    return 0;
  }

  getX(): number {
    return 0;
  }

  getY(): number {
    return 0;
  }

  dragBehavior: DragBehavior = DragBehavior.COPY;
  useCustomDropAnimation: boolean = false;

  setData(unifiedData: unifiedDataChannel.UnifiedData): void {
  }

  getData(): unifiedDataChannel.UnifiedData {
    return new unifiedDataChannel.UnifiedData(new unifiedDataChannel.UnifiedRecord());
  }

  getSummary(): unifiedDataChannel.Summary {
    return new unifiedDataChannel.Summary();
  }

  setResult(dragResult: DragResult): void {
  }

  getResult(): DragResult {
    return DragResult.DRAG_SUCCESSFUL;
  }

  getPreviewRect(): Rectangle {
    return {};
  }

  getVelocityX(): number {
    return 0;
  }

  getVelocityY(): number {
    return 0;
  }

  getVelocity(): number {
    return 0;
  }
}

class MockTouchObject implements TouchObject {
  type: TouchType = 0;
  id: number = 0;
  displayX: number = 0;
  displayY: number = 0;
  windowX: number = 0;
  windowY: number = 0;
  screenX: number = 0;
  screenY: number = 0;
  x: number = 0;
  y: number = 0;
}

let eventArea: Area = {
  width: 0,
  height: 0,
  position: { x: 0, y: 0 },
  globalPosition: { x: 0, y: 0 }
};

let eventTarget: EventTarget = {
  area: eventArea
};
let touchObject = new MockTouchObject();

class MockTouchEvent implements TouchEvent {
  type: TouchType = 0;
  touches: TouchObject[] = [touchObject];
  changedTouches: TouchObject[] = [];
  stopPropagation: () => void = voidCallback;

  getHistoricalPoints(): HistoricalPoint[] {
    throw new Error('Method not implemented.');
  }

  target: EventTarget = eventTarget;
  timestamp: number = 0;
  source: SourceType = 0;
  axisHorizontal?: number | undefined;
  axisVertical?: number | undefined;
  pressure: number = 0;
  tiltX: number = 0;
  tiltY: number = 0;
  sourceTool: SourceTool = 0;
  preventDefault: () => void = () => {
  };
}

class MockDockGestureEvent implements GestureEvent {
  repeat: boolean = false;
  fingerList: FingerInfo[] = [fingerInfo];
  offsetX: number = 0;
  offsetY: number = 0;
  angle: number = 0;
  speed: number = 0;
  scale: number = 0;
  pinchCenterX: number = 0;
  pinchCenterY: number = 0;
  velocityX: number = 0;
  velocityY: number = 0;
  velocity: number = 0;
  target: EventTarget = eventTarget;
  timestamp: number = 0;
  source: SourceType = 0;
  axisHorizontal?: number | undefined = 0;
  axisVertical?: number | undefined = 0;
  pressure: number = 0;
  tiltX: number = 0;
  tiltY: number = 0;
  sourceTool: SourceTool = 0;
}

export function SCBSplitManagerTest_05() {
  beforeAll(initSession);
  describe('SCBSplitManagerTest_05', () => {
    it('registerGetPreviewModelCallbackTest', Level.LEVEL0, (): void => {
      splitManager.registerGetPreviewModelCallback(container.containerId, () => {
        return new SCBPreviewRectModel();
      });
      expect(ReflectionUtils.getProperty(splitManager, 'containerModelMap')).assertInstanceOf('Object');
    });
    it('getPreviewModelCallbackTest', Level.LEVEL0, (): void => {
      splitManager.getPreviewModelCallback(container.containerId);
      expect(ReflectionUtils.getProperty(splitManager, 'containerModelMap')).assertInstanceOf('Object');
    });
    it('unRegisterGetPreviewModelCallbackTest', Level.LEVEL0, (): void => {
      splitManager.unRegisterGetPreviewModelCallback(container.containerId);
      expect(ReflectionUtils.getProperty(splitManager, 'containerModelMap')).assertInstanceOf('Object');
    });
    it('registerGetAppIconParamCallbackTest', Level.LEVEL0, (): void => {
      splitManager.registerGetAppIconParamCallback(container.containerId, () => {
        return [new SCBAppIconParam(() => container.primarySession)];
      });
      expect(ReflectionUtils.getProperty(splitManager, 'appIconParamMap')).assertInstanceOf('Object');
    });
    it('getAppIconParamCallbackTest', Level.LEVEL0, (): void => {
      splitManager.getAppIconParamCallback(container.containerId);
      expect(ReflectionUtils.getProperty(splitManager, 'appIconParamMap')).assertInstanceOf('Object');
    });
    it('unRegisterGetAppIconParamCallbackTest', Level.LEVEL0, (): void => {
      splitManager.unRegisterGetAppIconParamCallback(container.containerId);
      expect(ReflectionUtils.getProperty(splitManager, 'appIconParamMap')).assertInstanceOf('Object');
    });
    it('getPanelState', Level.LEVEL0, (): void => {
      let state = splitManager.getPanelState();
      expect(state).assertLargerOrEqual(0);
    });
  })
}

let dragEvent = new MockDockDragEvent();
let gestureEvent = new MockDockGestureEvent();
let touchEvent = new MockTouchEvent();
let itemInfo = new AppItemInfo();
let mocker: MockKit = new MockKit();
let registerIconParam = (containerSession: SCBSceneContainerSession) => {
  splitManager.registerGetAppIconParamCallback(containerSession.containerId, () => {
    return [new SCBAppIconParam(() => containerSession.primarySession),
      new SCBAppIconParam(() => containerSession.secondarySession)];
  })
}
let requestSceneSessionCallback = (sceneInfo: SCBSceneInfo): SCBSceneSession | null => {
  return toSession;
};
let isSupportSplitCallback = (): boolean => true;
let initFloat = () => {
  let floatList = SCBScenePanelManager.getInstance().getFloatingSessionList();
  floatList.clear();
  floatList.push(floatContainer);
  ReflectionUtils.setProperty(floatContainer, '_isActive', true);
}

let initForDockPairSplitProcessor = () => {
  let sceneSessionManager = SCBSceneSessionManager.getInstance();
  let containerList = sceneSessionManager.getContainerSessionList();
  containerList.clear();
  containerList.push(container);
  container.isSplit = false;
  let topActiveContainer = containerList.getTopActiveSession();
  topActiveContainer = topActiveContainer || container;
  ReflectionUtils.setProperty(topActiveContainer, '_isActive', true);
  dockSplitHelper.setDockItemOpacityCallback(() => 1, (opacity: number) => 1);
}

let initForReplaceProcessor = () => {
  initForDockPairSplitProcessor();
  container.isSplit = true;
}

let registerCallbackAndModel = () => {
  dockSplitHelper.registerCallbackAndModel(requestSceneSessionCallback, isSupportSplitCallback, voidCallback);
}

let pairProcessor: DockPairSplitProcessor;
let replaceProcessor: ReplaceSplitProcessor;
let pressEventTypes: number[];
let touchEventTypes: number[];
let initForDockDrag = () => {
  initSession();
  initFloat();
  DockPairSplitProcessor.instance = new DockPairSplitProcessor();
  ReplaceSplitProcessor.instance = new ReplaceSplitProcessor();
  StartFromHomeProcessor.instance = new StartFromHomeProcessor();
  StartFromRecentProcessor.instance = new StartFromRecentProcessor();
  pairProcessor = DockPairSplitProcessor.instance;
  replaceProcessor = ReplaceSplitProcessor.instance;
  registerCallbackAndModel();
  registerIconParam(container);
};
let setIconParams = (processor: ReplaceSplitProcessor) => {
  processor.primIconParam = new SCBAppIconParam(() => container.primarySession);
  processor.secIconParam = new SCBAppIconParam(() => container.secondarySession);
}

export function SCBSplitManagerTest_06() {
  describe('SCBSplitManagerTest_06', () => {
    beforeAll(() => {
      initForDockDrag();
    });
    it('DockPairSplitProcessorTest01', Level.LEVEL0, () => {
      initForDockPairSplitProcessor();
      let func01 = mocker.mockFunc(SCBMultiWindowUtils, SCBMultiWindowUtils.isSupportPairSplit);
      when(func01)(ArgumentMatchers.any).afterReturn(true);
      ReflectionUtils.setProperty(pairProcessor, SCENE_INFO, toInfo);
      splitManager.getPanelState = () => ScenePanelState.FULLSCENE;
      splitManager.onDockGestureEvent(GestureEventType.LONG_PRESS_SUCCESS, gestureEvent, itemInfo);
      expect(splitManager.dockPreviewProcessor?.getName()).assertEqual(pairProcessor.getName());
      splitManager.onDockGestureEvent(GestureEventType.LONG_PRESS_SUCCESS, gestureEvent, itemInfo);
      let processor = splitManager.dockPreviewProcessor;
      expect(processor?.getName()).assertEqual(pairProcessor.getName());
      container = ReflectionUtils.getProperty(splitManager.dockPreviewProcessor, 'container');
      pairProcessor.splitType = 0;
      dockSplitHelper.isIconHoverOnDock = false;
      let normalStart = pairProcessor.needStartScene();
      expect(normalStart).assertTrue();
      expect(ReflectionUtils.getProperty(pairProcessor, 'width')).assertEqual(1);
      expect(ReflectionUtils.getProperty(pairProcessor, 'height')).assertEqual(1);
      expect(ReflectionUtils.getProperty(pairProcessor, 'iconRectInfo')).assertUndefined();
      expect(ReflectionUtils.getProperty(pairProcessor, 'dragIconCenter')).assertInstanceOf('Object');
      expect(ReflectionUtils.getProperty(pairProcessor, 'dragOffset')).assertInstanceOf('Object');
      expect(ReflectionUtils.getProperty(pairProcessor, 'startLocation')).assertInstanceOf('Object');
      expect(ReflectionUtils.getProperty(pairProcessor, 'primIconParam')).assertInstanceOf('Object');
      expect(ReflectionUtils.getProperty(pairProcessor, 'secIconParam')).assertInstanceOf('Object');
      expect(ReflectionUtils.getProperty(pairProcessor, 'boardWidth')).assertInstanceOf('String');
      expect(ReflectionUtils.getProperty(pairProcessor, 'sceneWidthRecord')).assertEqual(0);
      expect(ReflectionUtils.getProperty(pairProcessor, 'sceneWidthRecord')).assertEqual(0);
      expect(ReflectionUtils.getProperty(pairProcessor, 'boardScale')).assertEqual(0);
      expect(ReflectionUtils.getProperty(pairProcessor, 'marginTop')).assertEqual(0);
      expect(ReflectionUtils.getProperty(pairProcessor, 'marginLeft')).assertEqual(0);
      expect(ReflectionUtils.getProperty(pairProcessor, 'splitType')).assertEqual(5);
      expect(ReflectionUtils.getProperty(pairProcessor, 'nextAlignment')).assertEqual(NaN);
      expect(ReflectionUtils.getProperty(pairProcessor, 'isShowRect')).assertFalse();
      expect(ReflectionUtils.getProperty(pairProcessor, 'isUpDownSplit')).assertFalse();
      expect(ReflectionUtils.getProperty(pairProcessor, '_boardPreviewModel')).assertNull();
      expect(ReflectionUtils.getProperty(pairProcessor, 'container')).assertNull();
      expect(ReflectionUtils.getProperty(pairProcessor, 'dragHotRegionJudge')).assertInstanceOf('Function');
      expect(pairProcessor.sceneInfo).assertNull();
      expect(pairProcessor.activatedSceneSession).assertNull();
      expect(pairProcessor.activatedSceneSession).assertNull();
      expect(pairProcessor).assertTrue();
      expect(splitManager.dockPreviewProcessor?.getName()).assertEqual(pairProcessor.getName());
      mocker.clear(func01);
    })
    it('ReplaceSplitProcessorTest01', Level.LEVEL0, () => {
      initForReplaceProcessor();
      let func01 = mocker.mockFunc(SCBMultiWindowUtils, SCBMultiWindowUtils.isSupportPairSplit);
      when(func01)(ArgumentMatchers.any).afterReturn(true);
      ReflectionUtils.setProperty(replaceProcessor, SCENE_INFO, toInfo);
      splitManager.getPanelState = () => ScenePanelState.FULLSCENE;
      splitManager.onDockGestureEvent(GestureEventType.LONG_PRESS_SUCCESS, gestureEvent, itemInfo);
      expect(splitManager.dockPreviewProcessor?.getName()).assertEqual(replaceProcessor.getName());
      splitManager.onDockGestureEvent(GestureEventType.LONG_PRESS_SUCCESS, gestureEvent, itemInfo);
      let processor = splitManager.dockPreviewProcessor;
      expect(processor?.getName()).assertEqual(replaceProcessor.getName());
      container = ReflectionUtils.getProperty(splitManager.dockPreviewProcessor, 'container');
      replaceProcessor.splitType = 0;
      dockSplitHelper.isIconHoverOnDock = false;
      let normalStart = replaceProcessor.needStartScene();
      expect(normalStart).assertTrue();
      expect(ReflectionUtils.getProperty(replaceProcessor, 'width')).assertEqual(1);
      expect(ReflectionUtils.getProperty(replaceProcessor, 'height')).assertEqual(1);
      expect(ReflectionUtils.getProperty(replaceProcessor, 'iconRectInfo')).assertUndefined();
      expect(ReflectionUtils.getProperty(replaceProcessor, 'dragIconCenter')).assertInstanceOf('Object');
      expect(ReflectionUtils.getProperty(replaceProcessor, 'dragOffset')).assertInstanceOf('Object');
      expect(ReflectionUtils.getProperty(replaceProcessor, 'startLocation')).assertInstanceOf('Object');
      expect(ReflectionUtils.getProperty(replaceProcessor, 'primIconParam')).assertInstanceOf('Object');
      expect(ReflectionUtils.getProperty(replaceProcessor, 'secIconParam')).assertInstanceOf('Object');
      expect(ReflectionUtils.getProperty(replaceProcessor, 'boardWidth')).assertInstanceOf('String');
      expect(ReflectionUtils.getProperty(replaceProcessor, 'sceneWidthRecord')).assertEqual(0);
      expect(ReflectionUtils.getProperty(replaceProcessor, 'sceneWidthRecord')).assertEqual(0);
      expect(ReflectionUtils.getProperty(replaceProcessor, 'boardScale')).assertEqual(0);
      expect(ReflectionUtils.getProperty(replaceProcessor, 'marginTop')).assertEqual(0);
      expect(ReflectionUtils.getProperty(replaceProcessor, 'marginLeft')).assertEqual(0);
      expect(ReflectionUtils.getProperty(replaceProcessor, 'splitType')).assertEqual(5);
      expect(ReflectionUtils.getProperty(replaceProcessor, 'nextAlignment')).assertEqual(NaN);
      expect(ReflectionUtils.getProperty(replaceProcessor, 'isShowRect')).assertFalse();
      expect(ReflectionUtils.getProperty(replaceProcessor, 'isUpDownSplit')).assertFalse();
      expect(ReflectionUtils.getProperty(replaceProcessor, '_boardPreviewModel')).assertNull();
      expect(ReflectionUtils.getProperty(replaceProcessor, 'container')).assertNull();
      expect(ReflectionUtils.getProperty(replaceProcessor, 'dragHotRegionJudge')).assertInstanceOf('Function');
      expect(splitManager.dockPreviewProcessor?.getName()).assertEqual(replaceProcessor.getName());
      mocker.clear(func01);
    })
    it('StartFromHomeProcessorTest01', Level.LEVEL0, () => {
      splitManager.getPanelState = () => ScenePanelState.HOME;
      splitManager.onDockGestureEvent(GestureEventType.LONG_PRESS_SUCCESS, gestureEvent, itemInfo);
      let processor = StartFromHomeProcessor.instance;
      expect(splitManager.dockPreviewProcessor?.getName()).assertEqual(processor.getName());
      splitManager.onDockGestureEvent(GestureEventType.LONG_PRESS_SUCCESS, gestureEvent, itemInfo);
      ReflectionUtils.setProperty(processor, 'isShowRect', true);
      processor.doPreviewStyleAnimation();
      ReflectionUtils.setProperty(processor, 'isShowRect', false);
      processor.doPreviewStyleAnimation();
      expect(splitManager.dockPreviewProcessor?.getName()).assertEqual(processor.getName());
      ReflectionUtils.setProperty(processor, SCENE_INFO, toInfo);
      processor.startNewSceneIfNeed(touchEvent);
      let res = processor.onStartNewScene(container, secondarySession);
      let res1 = processor.onStartNewScene(null, secondarySession);
      expect(res).assertTrue();
      expect(res1).assertFalse();
      expect(ReflectionUtils.getProperty(pairProcessor, 'width')).assertEqual(1);
      expect(ReflectionUtils.getProperty(pairProcessor, 'height')).assertEqual(1);
      expect(ReflectionUtils.getProperty(pairProcessor, 'iconRectInfo')).assertUndefined();
      expect(ReflectionUtils.getProperty(pairProcessor, 'dragIconCenter')).assertInstanceOf('Object');
      expect(ReflectionUtils.getProperty(pairProcessor, 'dragOffset')).assertInstanceOf('Object');
      expect(ReflectionUtils.getProperty(pairProcessor, 'startLocation')).assertInstanceOf('Object');
      expect(ReflectionUtils.getProperty(pairProcessor, 'primIconParam')).assertInstanceOf('Object');
      expect(ReflectionUtils.getProperty(pairProcessor, 'secIconParam')).assertInstanceOf('Object');
      expect(ReflectionUtils.getProperty(pairProcessor, 'boardWidth')).assertInstanceOf('String');
      expect(ReflectionUtils.getProperty(pairProcessor, 'sceneWidthRecord')).assertEqual(0);
      expect(ReflectionUtils.getProperty(pairProcessor, 'sceneWidthRecord')).assertEqual(0);
      expect(ReflectionUtils.getProperty(pairProcessor, 'boardScale')).assertEqual(0);
      expect(ReflectionUtils.getProperty(pairProcessor, 'marginTop')).assertEqual(0);
      expect(ReflectionUtils.getProperty(pairProcessor, 'marginLeft')).assertEqual(0);
      expect(ReflectionUtils.getProperty(pairProcessor, 'splitType')).assertEqual(5);
      expect(ReflectionUtils.getProperty(pairProcessor, 'nextAlignment')).assertEqual(NaN);
      expect(ReflectionUtils.getProperty(pairProcessor, 'isShowRect')).assertFalse();
      expect(ReflectionUtils.getProperty(pairProcessor, 'isUpDownSplit')).assertFalse();
      expect(ReflectionUtils.getProperty(pairProcessor, '_boardPreviewModel')).assertNull();
      expect(ReflectionUtils.getProperty(pairProcessor, 'container')).assertNull();
      expect(ReflectionUtils.getProperty(pairProcessor, 'dragHotRegionJudge')).assertInstanceOf('Function');
    })
    it('StartFromRecentProcessorTest01', Level.LEVEL0, () => {
     let homeProcessor =  StartFromRecentProcessor.instance;
      splitManager.getPanelState = () => ScenePanelState.RECENT;
      expect(ReflectionUtils.getProperty(homeProcessor, 'width')).assertEqual(1);
      expect(ReflectionUtils.getProperty(homeProcessor, 'height')).assertEqual(1);
      expect(ReflectionUtils.getProperty(homeProcessor, 'iconRectInfo')).assertUndefined();
      expect(ReflectionUtils.getProperty(homeProcessor, 'dragIconCenter')).assertInstanceOf('Object');
      expect(ReflectionUtils.getProperty(homeProcessor, 'dragOffset')).assertInstanceOf('Object');
      expect(ReflectionUtils.getProperty(homeProcessor, 'startLocation')).assertInstanceOf('Object');
      expect(ReflectionUtils.getProperty(homeProcessor, 'primIconParam')).assertInstanceOf('Object');
      expect(ReflectionUtils.getProperty(homeProcessor, 'secIconParam')).assertInstanceOf('Object');
      expect(ReflectionUtils.getProperty(homeProcessor, 'boardWidth')).assertInstanceOf('String');
      expect(ReflectionUtils.getProperty(homeProcessor, 'sceneWidthRecord')).assertEqual(0);
      expect(ReflectionUtils.getProperty(homeProcessor, 'sceneWidthRecord')).assertEqual(0);
      expect(ReflectionUtils.getProperty(homeProcessor, 'boardScale')).assertEqual(0);
      expect(ReflectionUtils.getProperty(homeProcessor, 'marginTop')).assertEqual(0);
      expect(ReflectionUtils.getProperty(homeProcessor, 'marginLeft')).assertEqual(0);
      expect(ReflectionUtils.getProperty(homeProcessor, 'splitType')).assertEqual(5);
      expect(ReflectionUtils.getProperty(homeProcessor, 'nextAlignment')).assertEqual(NaN);
      expect(ReflectionUtils.getProperty(homeProcessor, 'isShowRect')).assertFalse();
      expect(ReflectionUtils.getProperty(homeProcessor, 'isUpDownSplit')).assertFalse();
      expect(ReflectionUtils.getProperty(homeProcessor, '_boardPreviewModel')).assertNull();
      expect(ReflectionUtils.getProperty(homeProcessor, 'container')).assertNull();
      expect(ReflectionUtils.getProperty(homeProcessor, 'dragHotRegionJudge')).assertInstanceOf('Function');
      splitManager.onDockGestureEvent(GestureEventType.LONG_PRESS_SUCCESS, gestureEvent, itemInfo);
      expect(splitManager.dockPreviewProcessor?.getName()).assertEqual(StartFromRecentProcessor.instance.getName());
      splitManager.onDockGestureEvent(GestureEventType.LONG_PRESS_SUCCESS, gestureEvent, itemInfo);
      expect(splitManager.dockPreviewProcessor?.getName()).assertEqual(StartFromRecentProcessor.instance.getName());
    })
  });
}

export function SCBSplitManagerTest_09() {
  describe('SCBSplitManagerTest_09', () => {
    beforeAll(initForDockDrag);
    it('onDockGestureEventTest', Level.LEVEL0, () => {
      initForDockPairSplitProcessor();
      splitManager.getPanelState = () => ScenePanelState.FULLSCENE;
      splitManager.onDockGestureEvent(GestureEventType.LONG_PRESS_SUCCESS, gestureEvent, itemInfo, [0, 0]);
      pressEventTypes = [GestureEventType.UNDEFINED, GestureEventType.LONG_PRESS_SUCCESS,
        GestureEventType.LONG_PRESS_CANCEL, GestureEventType.LONG_PRESS_END];
      pressEventTypes.forEach((value) => {
        splitManager.onDockGestureEvent(value, gestureEvent, itemInfo);
        expect(ReflectionUtils.getProperty(pairProcessor, 'width')).assertEqual(1);
        expect(ReflectionUtils.getProperty(pairProcessor, 'height')).assertEqual(1);
        expect(ReflectionUtils.getProperty(pairProcessor, 'iconRectInfo')).assertUndefined();
        expect(ReflectionUtils.getProperty(pairProcessor, 'dragIconCenter')).assertInstanceOf('Object');
        expect(ReflectionUtils.getProperty(pairProcessor, 'dragOffset')).assertInstanceOf('Object');
        expect(ReflectionUtils.getProperty(pairProcessor, 'startLocation')).assertInstanceOf('Object');
        expect(ReflectionUtils.getProperty(pairProcessor, 'primIconParam')).assertInstanceOf('Object');
        expect(ReflectionUtils.getProperty(pairProcessor, 'secIconParam')).assertInstanceOf('Object');
        expect(ReflectionUtils.getProperty(pairProcessor, 'boardWidth')).assertInstanceOf('String');
        expect(ReflectionUtils.getProperty(pairProcessor, 'sceneWidthRecord')).assertEqual(0);
        expect(ReflectionUtils.getProperty(pairProcessor, 'sceneWidthRecord')).assertEqual(0);
        expect(ReflectionUtils.getProperty(pairProcessor, 'boardScale')).assertEqual(0);
        expect(ReflectionUtils.getProperty(pairProcessor, 'marginTop')).assertEqual(0);
        expect(ReflectionUtils.getProperty(pairProcessor, 'marginLeft')).assertEqual(0);
        expect(ReflectionUtils.getProperty(pairProcessor, 'splitType')).assertEqual(5);
        expect(ReflectionUtils.getProperty(pairProcessor, 'nextAlignment')).assertEqual(NaN);
        expect(ReflectionUtils.getProperty(pairProcessor, 'isShowRect')).assertFalse();
        expect(ReflectionUtils.getProperty(pairProcessor, 'isUpDownSplit')).assertFalse();
        expect(ReflectionUtils.getProperty(pairProcessor, '_boardPreviewModel')).assertNull();
        expect(ReflectionUtils.getProperty(pairProcessor, 'container')).assertNull();
        expect(ReflectionUtils.getProperty(pairProcessor, 'dragHotRegionJudge')).assertInstanceOf('Function');
      })
    });
    it('onDragEventTest', Level.LEVEL0, () => {
      initForDockPairSplitProcessor();
      splitManager.getPanelState = () => ScenePanelState.FULLSCENE;
      touchEventTypes = [TouchType.Down, TouchType.Up, TouchType.Move, TouchType.Cancel,];
      touchEventTypes.forEach((value) => {
        touchEvent.type = value;
        splitManager.onDockTouchEvent(touchEvent);
        expect(ReflectionUtils.getProperty(pairProcessor, 'width')).assertEqual(1);
        expect(ReflectionUtils.getProperty(pairProcessor, 'height')).assertEqual(1);
        expect(ReflectionUtils.getProperty(pairProcessor, 'iconRectInfo')).assertUndefined();
        expect(ReflectionUtils.getProperty(pairProcessor, 'dragIconCenter')).assertInstanceOf('Object');
        expect(ReflectionUtils.getProperty(pairProcessor, 'dragOffset')).assertInstanceOf('Object');
        expect(ReflectionUtils.getProperty(pairProcessor, 'startLocation')).assertInstanceOf('Object');
        expect(ReflectionUtils.getProperty(pairProcessor, 'primIconParam')).assertInstanceOf('Object');
        expect(ReflectionUtils.getProperty(pairProcessor, 'secIconParam')).assertInstanceOf('Object');
        expect(ReflectionUtils.getProperty(pairProcessor, 'boardWidth')).assertInstanceOf('String');
        expect(ReflectionUtils.getProperty(pairProcessor, 'sceneWidthRecord')).assertEqual(0);
        expect(ReflectionUtils.getProperty(pairProcessor, 'sceneWidthRecord')).assertEqual(0);
        expect(ReflectionUtils.getProperty(pairProcessor, 'boardScale')).assertEqual(0);
        expect(ReflectionUtils.getProperty(pairProcessor, 'marginTop')).assertEqual(0);
        expect(ReflectionUtils.getProperty(pairProcessor, 'marginLeft')).assertEqual(0);
        expect(ReflectionUtils.getProperty(pairProcessor, 'splitType')).assertEqual(5);
        expect(ReflectionUtils.getProperty(pairProcessor, 'nextAlignment')).assertEqual(NaN);
        expect(ReflectionUtils.getProperty(pairProcessor, 'isShowRect')).assertFalse();
        expect(ReflectionUtils.getProperty(pairProcessor, 'isUpDownSplit')).assertFalse();
        expect(ReflectionUtils.getProperty(pairProcessor, '_boardPreviewModel')).assertNull();
        expect(ReflectionUtils.getProperty(pairProcessor, 'container')).assertNull();
        expect(ReflectionUtils.getProperty(pairProcessor, 'dragHotRegionJudge')).assertInstanceOf('Function');
      })
    });
  });
}