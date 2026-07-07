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
  SCBMultiWindowGuideUtils,
  SCBMultiWindowUtils,
  MultiWindowToast,
  SCBSplitRecorder,
  GuideCase
} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBMultiWindowUtils';
import {
  SCBSceneOrientation,
  SCBSceneSession,
  SCBSceneSessionManager,
  PreferMultiWindowOrientation,
  SCBDividerParam,
  SCBFloatingParam,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBScreenProperty,
  SCBScreenSessionManager,
  SCBSceneContainerSession
} from '@ohos/windowscene';
import { SplitType } from '@ohos/commonconstants';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { AppItemInfo, AppModel } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { expect, it, Level, ArgumentMatchers, describe, MockKit, when } from '@ohos/hypium';
import { Location } from '../../../../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBSplitManager';
import {
  MidSceneManagerFactory
} from '../../../../../../../main/ets/SceneBoard/scenemanager/midsceneforpad/MidSceneManagerFactory';
import { CommonConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';

let floatContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
let sceneInfo: SCBSceneInfo ;
let sceneSession: SCBSceneSession ;
let secSceneInfo: SCBSceneInfo ;
let secSceneSession: SCBSceneSession ;
let screenProperty: SCBScreenProperty ;
let container: SCBSceneContainerSession;
let floatContainerSessionList: SCBSceneContainerSessionArray;

export default function SCBMultiWindowUtilsTest() {
  describe("SCBMultiWindowUtilsTest_describe", () => {
    beforeAll(() => {
      sceneInfo = new SCBSceneInfo('testBundle001', 'testModule001', 'testAbility001');
      sceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      secSceneInfo = new SCBSceneInfo('testSecondaryBundle002', 'testSecondaryModule002', 'testSecondaryAbility002');
      secSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(secSceneInfo), secSceneInfo);
      screenProperty = new SCBScreenProperty();
      container = new SCBSceneContainerSession(sceneSession, screenProperty);
      floatContainerSessionList = new SCBSceneContainerSessionArray();
      screenProperty.width = 10;
      screenProperty.height = 10;
    })
    getColumnsByLenTest_func();
    showToastTest_func();
    isVerticalTest_func();
    isFoldableAndExpandTest_func();
    showNotSupportGameSplitToastTest_func();
    isFoldableAndFoldedTest_func();
    isFoldableDeviceTest_func();
    isNotSupportGameSplitTest_func();
    isSupportLargeScreenMultiWindowTest_func();
    updateWindowModeInExpandStatusTest_func();
    generateOneStepOffsetTest_func();
    updateFloatingWindowTouchableIfNeedTest_func();
    isNotSupportGameSplitTestAdd_func();
    isMiniFloatWindowTestAdd_func();
    setNeedStartGuideKnowMoreTest_func();
    getIsNeedGuideKnowMoreTest_func();
    isMiniFloatWindowTest_func();
    generateDefaultGestureEvent_func();
    updateDockRecentListTest();
    ifGuideShowTest_func();
    guideBreakTest_func();
    guideFinishTest_func();
    isAppInDockRecentTest_func();
    splitRecorderTest_func();
    multiWindowGuideUtilsTest_func();
    isStartFromAppDockTest_func();
    applyToContainerTest_func();
    showToastTestAll_func();
    showToastTestAdd_func();
    isSplitExpectWindowModeTest();
    covertCoordinateByRotationTest();
    showNotSupportAdjustWindowToastTest();
    showClickAppAddToMidSceneToastTest();
    isSupportMidSceneAndIsMidSceneTest();
    hideKeyBoardWhenWillEnterRecentForSplitTest();
    getAllActiveAppsInfosTest();
    isPadUiTypeTest();
    getDockItemIdTest();
    isScreenRectUpdateTest();
  });
}

function getColumnsByLenTest_func() {
  it('getColumnsByLenTest_it', Level.LEVEL0, () => {
    expect(SCBMultiWindowUtils.getColumnsByLen(840)).assertEqual(12);
    expect(SCBMultiWindowUtils.getColumnsByLen(-1)).assertEqual(1);
    expect(SCBMultiWindowUtils.getColumnsByLen(1)).assertEqual(2);
    expect(SCBMultiWindowUtils.getColumnsByLen(320)).assertEqual(4);
    expect(SCBMultiWindowUtils.getColumnsByLen(600)).assertEqual(8);
  });
}

function showToastTest_func() {
  it('showToastTest_it', Level.LEVEL0, (): void => {
    SCBMultiWindowUtils.showToast($r('app.string.oh_multiwindow_not_support_split_ratio'));
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showClickAnotherAppToPairSplitToast();
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showClickAppAddToMidSceneToast();
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showNotSupportMultiWindowsToast('');
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showNotSupportMultiWindowsToast('testBundle001_Bundle');
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showNotSupportMultiWindowsToast('testModule00');
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showBackToMiddleSceneToast();
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showNotSupportFloatingWindowsToast('testModule00');
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showNotSupportFloatingWindowsToast('testBundle001_Bundle');
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showThisAppIsOpenToast('testModule00');
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showThisAppIsOpenToast('testBundle001_Bundle');
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showCommonToast(MultiWindowToast.NOT_SUPPORT_SPLIT, sceneInfo);
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showCommonToast(MultiWindowToast.NOT_SUPPORT_SPLIT, sceneInfo);
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showCommonToast(MultiWindowToast.NOT_SUPPORT_SPLIT_RATIO, sceneInfo);
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showCommonToast(MultiWindowToast.NOT_SUPPORT_SPLIT_FOR_FOLDED, sceneInfo);
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showCommonToast(MultiWindowToast.NOT_SUPPORT_HORIZONTAL_SPLIT, sceneInfo);
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showCommonToast(MultiWindowToast.NOT_SUPPORT_VERTICAL_SPLIT, sceneInfo);
    expect(assertFlag).assertTrue();

    // 使用mock更改条件
    let appModel: AppModel = AppModel.getInstance();
    let appInfo: AppItemInfo = new AppItemInfo();
    appInfo.moduleName = 'testBundle001_Bundle';
    appInfo.appId = '0';
    let mocker1: MockKit = new MockKit();
    let mockFunc: Function = mocker1.mockFunc(appModel,appModel.getAppInfoByBundleName);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(appInfo);
    SCBMultiWindowUtils.showToast($r('app.string.oh_multiwindow_not_support_split_ratio'));
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showClickAnotherAppToPairSplitToast();
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showClickAppAddToMidSceneToast();
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showNotSupportMultiWindowsToast('testBundle001_Bundle');
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showNotSupportMultiWindowsToast('testModule00');
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showBackToMiddleSceneToast();
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showNotSupportFloatingWindowsToast('testModule00');
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showNotSupportFloatingWindowsToast('testBundle001_Bundle');
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showThisAppIsOpenToast('testModule00');
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showThisAppIsOpenToast('testBundle001_Bundle');
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showCommonToast(MultiWindowToast.NOT_SUPPORT_SPLIT, sceneInfo);
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showCommonToast(MultiWindowToast.NOT_SUPPORT_SPLIT, sceneInfo);
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showCommonToast(MultiWindowToast.NOT_SUPPORT_SPLIT_RATIO, sceneInfo);
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showCommonToast(MultiWindowToast.NOT_SUPPORT_SPLIT_FOR_FOLDED, sceneInfo);
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showCommonToast(MultiWindowToast.NOT_SUPPORT_HORIZONTAL_SPLIT, sceneInfo);
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showCommonToast(MultiWindowToast.NOT_SUPPORT_VERTICAL_SPLIT, sceneInfo);
    expect(assertFlag).assertTrue();

    mocker1.clear(mockFunc)
  });
}

function isVerticalTest_func() {
  it('isVerticalTest_it', Level.LEVEL0, (): void => {
    let res: boolean = SCBMultiWindowUtils.isVertical(0);
    expect(res).assertTrue();
    res = SCBMultiWindowUtils.isVertical(180);
    expect(res).assertTrue();
    res = SCBMultiWindowUtils.isVertical(360);
    expect(res).assertTrue();
    res = SCBMultiWindowUtils.isVertical(-1);
    expect(res).assertEqual(false);
    res = SCBMultiWindowUtils.isVertical(45);
    expect(res).assertEqual(false);
    res = SCBMultiWindowUtils.isVertical(90);
    expect(res).assertEqual(false);
    res = SCBMultiWindowUtils.isVertical(120);
    expect(res).assertEqual(false);
    res = SCBMultiWindowUtils.isVertical(200);
    expect(res).assertEqual(false);
    res = SCBMultiWindowUtils.isVertical(270);
    expect(res).assertEqual(false);
    res = SCBMultiWindowUtils.isVertical(300);
    expect(res).assertEqual(false);
    res = SCBMultiWindowUtils.isVertical(361);
    expect(res).assertEqual(false);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
    let res9: boolean = SCBMultiWindowUtils.isVertical(90);
    let res10: boolean = SCBMultiWindowUtils.isVertical(270);
    mocker.clear(DeviceHelper);
    expect(res9).assertTrue();
    expect(res10).assertTrue();
  });
}

function isFoldableAndExpandTest_func() {
  it('isFoldableAndExpandTest_it', Level.LEVEL0, (): void => {
    SCBMultiWindowUtils.isDockAnimating = false;
    SCBMultiWindowUtils.isFoldableAndExpand();
    SCBMultiWindowUtils.isFoldableDeviceExpanded()
    SCBMultiWindowUtils.isFoldableDeviceExpanded()
    expect(SCBMultiWindowUtils.isDockAnimating).assertEqual(false);
  });
}

function showNotSupportGameSplitToastTest_func() {
  it('showNotSupportGameSplitToastTest_it', Level.LEVEL0, (): void => {
    secSceneSession.preferMultiWindowOrientation = PreferMultiWindowOrientation.PORTRAIT;
    secSceneInfo.bundleName = 'testBundle002_Bundle';
    secSceneSession.sceneInfo = secSceneInfo;
    SCBMultiWindowUtils.showNotSupportGameSplitToast(secSceneSession);
    expect(secSceneInfo.bundleName).assertEqual('testBundle002_Bundle');
    secSceneSession.preferMultiWindowOrientation = PreferMultiWindowOrientation.LANDSCAPE;
    SCBMultiWindowUtils.showNotSupportGameSplitToast(secSceneSession);
    expect(secSceneInfo.bundleName).assertEqual('testBundle002_Bundle');

    sceneSession.preferMultiWindowOrientation = PreferMultiWindowOrientation.PORTRAIT;
    sceneInfo.bundleName = 'testBundle001_Bundle';
    sceneSession.sceneInfo = sceneInfo;
    SCBMultiWindowUtils.showNotSupportGameSplitToast(sceneSession);
    expect(sceneInfo.bundleName).assertEqual('testBundle001_Bundle');
    sceneSession.preferMultiWindowOrientation = PreferMultiWindowOrientation.LANDSCAPE;
    SCBMultiWindowUtils.showNotSupportGameSplitToast(sceneSession);
    expect(sceneInfo.bundleName).assertEqual('testBundle001_Bundle');
  });
}

function isFoldableAndFoldedTest_func() {
  it('isFoldableAndFoldedTest_it', Level.LEVEL0, (): void => {
    SCBMultiWindowUtils.isDockAnimating = false;
    SCBMultiWindowUtils.isFoldableAndFolded();
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.isFoldableDeviceFolded();
    SCBMultiWindowUtils.isFoldableDeviceExpanded()
    expect(SCBMultiWindowUtils.isDockAnimating).assertEqual(false);
  });
}

function isFoldableDeviceTest_func() {
  it('isFoldableDevice_it', Level.LEVEL0, (): void => {
    SCBMultiWindowUtils.isFoldableDevice();
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.isDockAnimating = false;
    SCBMultiWindowUtils.isFoldableDevice();
    expect(SCBMultiWindowUtils.isDockAnimating).assertEqual(false);
  });
}

function isNotSupportGameSplitTest_func() {
  it('isNotSupportGameSplitTest_it', Level.LEVEL0, (): void => {
    secSceneSession.isFixedMultiWindowOrientation = false;
    expect(SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.LEFT_RIGHT_SPLIT))
      .assertEqual(false);
    secSceneSession.isFixedMultiWindowOrientation = true;
    secSceneSession.preferMultiWindowOrientation = PreferMultiWindowOrientation.LANDSCAPE;
    expect(SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.LEFT_RIGHT_SPLIT))
      .assertEqual(true);
    secSceneSession.preferMultiWindowOrientation = PreferMultiWindowOrientation.PORTRAIT;
    expect(SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.UP_DOWN_SPLIT))
      .assertEqual(true);
    secSceneSession.preferMultiWindowOrientation = PreferMultiWindowOrientation.PORTRAIT;
    expect(SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.UNKNOWN))
      .assertEqual(false);
    secSceneSession.preferMultiWindowOrientation = PreferMultiWindowOrientation.LANDSCAPE;
    expect(SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.UNKNOWN))
      .assertEqual(false);
  });
}

function isSupportLargeScreenMultiWindowTest_func() {
  it('isSupportLargeScreenMultiWindowTest_it', Level.LEVEL0, (): void => {
    SCBMultiWindowUtils.isSupportLargeScreenMultiWindow();
    expect(assertFlag).assertTrue();
  });
}

function updateWindowModeInExpandStatusTest_func() {
  it('updateWindowModeInExpandStatusTest_it', Level.LEVEL0, (): void => {
    SCBMultiWindowUtils.updateWindowModeInExpandStatus(secSceneInfo, sceneSession);
    expect(assertFlag).assertTrue();
  });
}

function generateOneStepOffsetTest_func() {
  it('generateOneStepOffsetTest_expanded_it', Level.LEVEL0, (): void => {
    let mocker1: MockKit = new MockKit();
    let obj = SCBScreenSessionManager.getInstance();
    let mockFunc: Function = mocker1.mockFunc(obj, obj.isFoldablePhoneExpandStatus);
    when(mockFunc)().afterReturn(true);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 20, 0).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 40, 0).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 44, 0).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 1).y).assertEqual(43);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 10).y).assertEqual(34);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 20).y).assertEqual(24);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 40).y).assertEqual(4);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 44).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 45).y).assertEqual(-1);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 0).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 0).y).assertEqual(44);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 40).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 44).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 45).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 1, 0).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 0, 0).x).assertEqual(44);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 0, 0).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 1).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 10).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 20).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 10, 0).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 1, 0).y).assertEqual(44);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 10, 0).y).assertEqual(44);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 20, 0).y).assertEqual(44);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 0, 20).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 0, 30).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 0, 56).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 0, 57).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 1, 0).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 10, 0).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 20, 0).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 40, 0).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 44, 0).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 45, 0).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 40, 0).y).assertEqual(44);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 44, 0).y).assertEqual(44);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 0, 1).x).assertEqual(44);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 0, 10).x).assertEqual(44);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 0, 20).x).assertEqual(44);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 0, 30).x).assertEqual(44);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 1, 0).x).assertEqual(43);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 10, 0).x).assertEqual(34);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 20, 0).x).assertEqual(24);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 40, 0).x).assertEqual(4);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 44, 0).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 45, 0).x).assertEqual(-1);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 0, 1).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 0, 10).y).assertEqual(0);
    mocker1.clear(mockFunc);
  });

  it('generateOneStepOffsetTest_folded_it', Level.LEVEL0, (): void => {
    let mocker1: MockKit = new MockKit();
    let obj = SCBScreenSessionManager.getInstance();
    let mockFunc: Function = mocker1.mockFunc(obj, obj.isFoldablePhoneExpandStatus);
    when(mockFunc)().afterReturn(false);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 10).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 20).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 50).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 56).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 57).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 20, 0).y).assertEqual(56);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 50, 0).y).assertEqual(56);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 56, 0).y).assertEqual(56);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 0, 1).x).assertEqual(56);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 0, 10).x).assertEqual(56);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 0, 20).x).assertEqual(56);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 0, 30).x).assertEqual(56);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 1, 0).x).assertEqual(55);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 1, 0).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 10, 0).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 20, 0).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 50, 0).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 56, 0).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 0).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 0).y).assertEqual(56);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 0, 0).x).assertEqual(56);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 0, 0).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 1).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 1).y).assertEqual(55);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 10).y).assertEqual(46);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 0, 1).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 0, 10).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 0, 20).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 0, 30).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 0, 56).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 0, 57).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 1, 0).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 10, 0).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 20, 0).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 50, 0).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 56, 0).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 57, 0).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 20).y).assertEqual(36);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 50).y).assertEqual(6);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 56).y).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 0, 57).y).assertEqual(-1);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 1, 0).y).assertEqual(56);
    expect(SCBMultiWindowUtils.generateOneStepOffset(true, 10, 0).y).assertEqual(56);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 10, 0).x).assertEqual(46);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 20, 0).x).assertEqual(36);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 50, 0).x).assertEqual(6);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 56, 0).x).assertEqual(0);
    expect(SCBMultiWindowUtils.generateOneStepOffset(false, 57, 0).x).assertEqual(-1);
    mocker1.clear(mockFunc);
  });
}

function updateFloatingWindowTouchableIfNeedTest_func() {
  it('updateFloatingWindowTouchableIfNeedTest_it', Level.LEVEL0, (): void => {
    let mocker1: MockKit = new MockKit();
    let sceneSessionManager = SCBSceneSessionManager.getInstance();
    floatContainerSessionList.add(container);
    let fun_01: Function = mocker1.mockFunc(sceneSessionManager, sceneSessionManager.getFloatingSessionList);
    when(fun_01)(ArgumentMatchers.any).afterReturn(floatContainerSessionList);
    SCBMultiWindowUtils.updateFloatingWindowTouchableIfNeed(true);
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.updateFloatingWindowTouchableIfNeed(false);
    expect(assertFlag).assertTrue();
    mocker1.clear(fun_01);
  });
}

function isNotSupportGameSplitTestAdd_func() {
  it('isNotSupportGameSplitTestAdd_it', Level.LEVEL0, (): void => {
    secSceneSession.preferMultiWindowOrientation = PreferMultiWindowOrientation.LANDSCAPE;
    SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.LEFT_RIGHT_SPLIT);
    SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.UP_DOWN_SPLIT);
    SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.UNKNOWN);
    SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.FULL_SCREEN);
    expect(SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.UNKNOWN))
      .assertEqual(false);
    secSceneSession.isFixedMultiWindowOrientation = false;
    SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.LEFT_RIGHT_SPLIT);
    SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.UP_DOWN_SPLIT);
    SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.UNKNOWN);
    SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.FULL_SCREEN);
    expect(SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.LEFT_RIGHT_SPLIT))
      .assertEqual(false);
    secSceneSession.preferMultiWindowOrientation = PreferMultiWindowOrientation.PORTRAIT;
    SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.LEFT_RIGHT_SPLIT);
    SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.UP_DOWN_SPLIT);
    SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.UNKNOWN);
    SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.FULL_SCREEN);
    expect(SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.UP_DOWN_SPLIT))
      .assertEqual(true);
    secSceneSession.isFixedMultiWindowOrientation = true;
    secSceneSession.preferMultiWindowOrientation = PreferMultiWindowOrientation.LANDSCAPE;
    SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.LEFT_RIGHT_SPLIT);
    SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.UP_DOWN_SPLIT);
    SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.UNKNOWN);
    SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.FULL_SCREEN);
    expect(SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.LEFT_RIGHT_SPLIT))
      .assertEqual(true);
    secSceneSession.preferMultiWindowOrientation = PreferMultiWindowOrientation.PORTRAIT;
    SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.LEFT_RIGHT_SPLIT);
    SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.UP_DOWN_SPLIT);
    SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.UNKNOWN);
    SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.FULL_SCREEN);
    expect(SCBMultiWindowUtils.isNotSupportGamePairSplit(secSceneSession, SplitType.UNKNOWN))
      .assertEqual(false);
  });
}

function isMiniFloatWindowTestAdd_func() {
  it('isMiniFloatWindowTestAdd_it', Level.LEVEL0, (): void => {
    let param: SCBFloatingParam = new SCBFloatingParam();
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    param.scale = -1;
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    param.scale = -10;
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    param.scale = 0;
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    param.scale = 90;
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    param.scale = 180;
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    param.scale = 270;
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    param.scale = 360;
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    param.scale = 10;
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    param.scale = 20;
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    param.scale = 30;
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    param.scale = 45;
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    param.scale = 1;
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    expect(param.scale).assertEqual(1);
  });
}

function setNeedStartGuideKnowMoreTest_func() {
  it("setNeedStartGuideKnowMoreTest_it_01", Level.LEVEL0, () => {
    SCBMultiWindowGuideUtils.getInstance().setNeedStartGuideKnowMore(false);
    expect(SCBMultiWindowGuideUtils.getInstance().getIsNeedGuideKnowMore()).assertFalse();
  });
  it("setNeedStartGuideKnowMoreTest_it_02", Level.LEVEL0, () => {
    SCBMultiWindowGuideUtils.getInstance().setNeedStartGuideKnowMore(true);
    expect(SCBMultiWindowGuideUtils.getInstance().getIsNeedGuideKnowMore()).assertTrue();
  });
}

function getIsNeedGuideKnowMoreTest_func() {
  it("getIsNeedGuideKnowMoreTest_it_01", Level.LEVEL0, () => {
    let needGuideKnowMore: boolean = SCBMultiWindowGuideUtils.getInstance().getIsNeedGuideKnowMore();
    expect(needGuideKnowMore !== undefined).assertTrue();
  });
}

function isMiniFloatWindowTest_func() {
  it('isMiniFloatWindowTest_it', Level.LEVEL0, (): void => {
    let param: SCBFloatingParam = new SCBFloatingParam();
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    param.scale = 0;
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    param.scale = 0.55;
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    param.scale = 0.7;
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    param.scale = 0.8;
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    param.scale = 0.9;
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    param.scale = 1.001;
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    param.scale = 0.001;
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    param.scale = 0.1;
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    param.scale = 0.2;
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    param.scale = 0.3;
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    param.scale = 0.5;
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    param.scale = 1;
    SCBMultiWindowUtils.isMiniFloatWindow(param);
    expect(param.scale).assertEqual(1);
  });
}

/**
 * generate gesture event for restore
 */
function generateDefaultGestureEvent_func() {
  it('generateDefaultGestureEventTest_it', Level.LEVEL0, (): void => {
    let event: GestureEvent = SCBMultiWindowUtils.generateDefaultGestureEvent();
    expect(event.fingerList.length).assertEqual(0);
    expect(event.offsetX).assertEqual(0);
    expect(event.offsetY).assertEqual(0);
    expect(event.angle).assertEqual(0);
    expect(event.speed).assertEqual(0);
    expect(event.scale).assertEqual(0);
    expect(event.pinchCenterX).assertEqual(0);
    expect(event.pinchCenterY).assertEqual(0);
    expect(event.velocityX).assertEqual(0);
    expect(event.velocityY).assertEqual(0);
    expect(event.offsetX).assertEqual(0);
    expect(event.velocity).assertEqual(0);
    expect(event.timestamp).assertEqual(0);
    expect(event.source).assertEqual(0);
    expect(event.pressure).assertEqual(0);
    expect(event.tiltX).assertEqual(0);
    expect(event.tiltY).assertEqual(0);
    expect(event.sourceTool).assertEqual(0);
    expect(event.target.area.width).assertEqual(0);
    expect(event.target.area.height).assertEqual(0);
    expect(event.target.area.position.x).assertEqual(0);
    expect(event.target.area.position.y).assertEqual(0);
    expect(event.target.area.globalPosition.x).assertEqual(0);
    expect(event.target.area.globalPosition.y).assertEqual(0);
  });
}

function ifGuideShowTest_func() {
  it('ifGuideShowTest_it', Level.LEVEL0, (): void => {
    let guideCase: GuideCase = GuideCase.FLOATING_TO_SPLITING;
    SCBMultiWindowGuideUtils.getInstance().ifGuideShow(guideCase);
    expect(assertFlag).assertTrue();
  });
}

function updateDockRecentListTest() {
  it("updateDockRecentListTest", Level.LEVEL0, () => {
    SCBMultiWindowUtils.isDockAnimating = false;
    SCBMultiWindowUtils.updateDockRecentList(sceneSession, true);
    expect(SCBMultiWindowUtils.isDockAnimating).assertTrue();
    let viewEvent = GestureDockViewModel.getInstance().getViewEvent() as GestureDockViewEventMgr;
    if (!(viewEvent instanceof GestureDockViewEventMgr)) {
      return;
    }
    let gestureDockParam = viewEvent?.gestureDockParam;
    let scbGestureDockParam = viewEvent?.scbGestureDockParam;
    expect(gestureDockParam.gestureDockShowMode).assertEqual(GestureDockMode.INVISIBLE);
    expect(scbGestureDockParam.isGestureDockShow).assertFalse();
    expect(SCBMultiWindowUtils.isDockAnimating).assertTrue();
    expect(gestureDockParam.gestureDockDirection).assertEqual(GestureDockState.GESTURE_DOCK_IN);
  });
}

function guideBreakTest_func() {
  it('guideBreakTest_it', Level.LEVEL0, (): void => {
    let guideCase: GuideCase = GuideCase.SPLITING_GUIDE;
    SCBMultiWindowGuideUtils.getInstance().guideBreak(guideCase);
    expect(assertFlag).assertTrue();
  });
}

function guideFinishTest_func() {
  it('guideFinishTest_it', Level.LEVEL0, (): void => {
    let guideCase: GuideCase = GuideCase.FLOATING_TIPS;
    SCBMultiWindowGuideUtils.getInstance().guideFinish(guideCase);
    expect(assertFlag).assertTrue();
  });
}

function isAppInDockRecentTest_func() {
  it('isAppInDockRecentTest_it', Level.LEVEL0, (): void => {
    SCBMultiWindowUtils.isAppInDockRecent(sceneInfo);
    sceneInfo.bundleName = 'testBundle005';
    SCBMultiWindowUtils.isAppInDockRecent(sceneInfo);
    sceneInfo.bundleName = 'testBundle001';
    SCBMultiWindowUtils.isAppInDockRecent(sceneInfo);
    sceneInfo.bundleName = 'testBundle003';
    SCBMultiWindowUtils.isAppInDockRecent(sceneInfo);
    sceneInfo.bundleName = 'testBundle004';
    SCBMultiWindowUtils.isAppInDockRecent(sceneInfo);
    sceneInfo.bundleName = 'testBundle002';
    SCBMultiWindowUtils.isAppInDockRecent(sceneInfo);
    sceneInfo.abilityName = 'testAbility003';
    SCBMultiWindowUtils.isAppInDockRecent(sceneInfo);
    sceneInfo.abilityName = 'testAbility004';
    SCBMultiWindowUtils.isAppInDockRecent(sceneInfo);
    sceneInfo.abilityName = 'testAbility001';
    SCBMultiWindowUtils.isAppInDockRecent(sceneInfo);
    sceneInfo.abilityName = 'testAbility002';
    SCBMultiWindowUtils.isAppInDockRecent(sceneInfo);
    sceneInfo.abilityName = 'testAbility005';
    SCBMultiWindowUtils.isAppInDockRecent(sceneInfo);
    expect(sceneInfo.abilityName).assertEqual('testAbility005');
  });

  it('isAppInDockRecentTest02', Level.LEVEL0, (): void => {
    sceneInfo.bundleName = 'testBundle001';
    let itemInfo = new DockItemInfo();
    itemInfo.bundleName = sceneInfo.bundleName;
    itemInfo.abilityName = sceneInfo.abilityName;
    AppStorage.set('recentDockList', []);
    let res = SCBMultiWindowUtils.isAppInDockRecent(sceneInfo);
    AppStorage.set('recentDockList', [itemInfo]);
    let res1 = SCBMultiWindowUtils.isAppInDockRecent(sceneInfo);
    expect(res).assertFalse();
    expect(res1).assertTrue();
  });
}

function splitRecorderTest_func() {
  it('splitRecorderTest_it', Level.LEVEL0, (): void => {
    let splitRecorder: SCBSplitRecorder = new SCBSplitRecorder();
    splitRecorder.setX(100);
    expect(splitRecorder.x).assertEqual(100);
    splitRecorder.setX(10);
    expect(splitRecorder.x).assertEqual(10);
    splitRecorder.setX(-1);
    expect(splitRecorder.x).assertEqual(-1);
    splitRecorder.setX(1);
    expect(splitRecorder.x).assertEqual(1);
    splitRecorder.setX(0);
    expect(splitRecorder.x).assertEqual(0);
    splitRecorder.setY(100);
    expect(splitRecorder.y).assertEqual(100);
    splitRecorder.setY(10);
    expect(splitRecorder.y).assertEqual(10);
    splitRecorder.setY(-1);
    expect(splitRecorder.y).assertEqual(-1);
    splitRecorder.setY(1);
    expect(splitRecorder.y).assertEqual(1);
    splitRecorder.setY(0);
    expect(splitRecorder.y).assertEqual(0);
    splitRecorder.setWidth(100);
    expect(splitRecorder.width).assertEqual(100);
    splitRecorder.setWidth(-1);
    expect(splitRecorder.width).assertEqual(-1);
    splitRecorder.setWidth(1);
    expect(splitRecorder.width).assertEqual(1);
    splitRecorder.setWidth(10);
    expect(splitRecorder.width).assertEqual(10);
    splitRecorder.setWidth(0);
    expect(splitRecorder.width).assertEqual(0);
    splitRecorder.setHeight(100);
    expect(splitRecorder.height).assertEqual(100);
    splitRecorder.setHeight(10);
    expect(splitRecorder.height).assertEqual(10);
    splitRecorder.setHeight(-1);
    expect(splitRecorder.height).assertEqual(-1);
    splitRecorder.setHeight(1);
    expect(splitRecorder.height).assertEqual(1);
    splitRecorder.setHeight(0);
    expect(splitRecorder.height).assertEqual(0);
    splitRecorder.setBorderRadius(100, 100, 100, 100);
    expect(splitRecorder.borderRadius.topLeft).assertEqual(100);
    expect(splitRecorder.borderRadius.topRight).assertEqual(100);
    expect(splitRecorder.borderRadius.bottomLeft).assertEqual(100);
    expect(splitRecorder.borderRadius.bottomRight).assertEqual(100);
    splitRecorder.setBorderRadius(1, 1, 1, 1);
    expect(splitRecorder.borderRadius.topLeft).assertEqual(1);
    expect(splitRecorder.borderRadius.topRight).assertEqual(1);
    expect(splitRecorder.borderRadius.bottomLeft).assertEqual(1);
    expect(splitRecorder.borderRadius.bottomRight).assertEqual(1);
    splitRecorder.setBorderRadius(0, 0, 0, 0);
    expect(splitRecorder.borderRadius.topLeft).assertEqual(0);
    expect(splitRecorder.borderRadius.topRight).assertEqual(0);
    expect(splitRecorder.borderRadius.bottomLeft).assertEqual(0);
    expect(splitRecorder.borderRadius.bottomRight).assertEqual(0);
    splitRecorder.setBorderRadius(-1, -1, -1, -1);
    expect(splitRecorder.borderRadius.topLeft).assertEqual(-1);
    expect(splitRecorder.borderRadius.topRight).assertEqual(-1);
    expect(splitRecorder.borderRadius.bottomLeft).assertEqual(-1);
    expect(splitRecorder.borderRadius.bottomRight).assertEqual(-1);
    splitRecorder.setBlurScale(-1);
    expect(splitRecorder.blurScale).assertEqual(-1);
    splitRecorder.setBlurScale(100);
    expect(splitRecorder.blurScale).assertEqual(100);
    splitRecorder.setBlurScale(1);
    expect(splitRecorder.blurScale).assertEqual(1);
    splitRecorder.setBlurScale(10);
    expect(splitRecorder.blurScale).assertEqual(10);
    splitRecorder.setBlurScale(0);
    expect(splitRecorder.blurScale).assertEqual(0);
    let divider: SCBDividerParam = new SCBDividerParam();
    splitRecorder.applyToDivider(divider, 10, 10, true);
    splitRecorder.applyToDivider(divider, 100, 100, true);
    splitRecorder.applyToDivider(divider, 1000, 1000, true);
    splitRecorder.applyToDivider(divider, 1, 1, true);
    expect(assertFlag).assertTrue();
    splitRecorder.applyToDivider(divider, 10, 10, false);
    splitRecorder.applyToDivider(divider, 100, 100, false);
    splitRecorder.applyToDivider(divider, 1000, 1000, false);
    splitRecorder.applyToDivider(divider, 1, 1, false);
    expect(assertFlag).assertTrue();
    SCBSplitRecorder.generateFromDividerParam(divider, true, screenProperty);
    expect(assertFlag).assertTrue();
    SCBSplitRecorder.generateFromDividerParam(divider, false, screenProperty);
    expect(assertFlag).assertTrue();
    splitRecorder.fixPositionRecord(divider, true);
    expect(assertFlag).assertTrue();
    splitRecorder.fixPositionRecord(divider, false);
    expect(assertFlag).assertTrue();
    splitRecorder.applyToContainer(container);
    expect(assertFlag).assertTrue();
    let record = SCBSplitRecorder.generateFloatInfoForFloatToSplit(container, container);
    expect(record.blurScale).assertEqual(container.dividerParam.primary.blurScale);
  });
}

function multiWindowGuideUtilsTest_func() {
  it('multiWindowGuideUtilsTest_it', Level.LEVEL0, (): void => {
    let multiWindowGuideUtils: SCBMultiWindowGuideUtils
      = SCBMultiWindowGuideUtils.getInstance();
    multiWindowGuideUtils.ifGuideShow(GuideCase.FLOATING_TO_SPLITING);
    expect(assertFlag).assertTrue();
    multiWindowGuideUtils.ifGuideShow(GuideCase.SPLITING_GUIDE);
    expect(assertFlag).assertTrue();
    multiWindowGuideUtils.ifGuideShow(GuideCase.FLOATING_TIPS);
    expect(assertFlag).assertTrue();
    multiWindowGuideUtils.ifGuideShow(GuideCase.SPLITING_TIPS);
    expect(assertFlag).assertTrue();

    multiWindowGuideUtils.guideBreak(GuideCase.FLOATING_TO_SPLITING);
    expect(assertFlag).assertTrue();
    multiWindowGuideUtils.guideBreak(GuideCase.SPLITING_GUIDE);
    expect(assertFlag).assertTrue();
    multiWindowGuideUtils.guideBreak(GuideCase.FLOATING_TIPS);
    expect(assertFlag).assertTrue();
    multiWindowGuideUtils.guideBreak(GuideCase.SPLITING_TIPS);
    expect(assertFlag).assertTrue();

    multiWindowGuideUtils.guideFinish(GuideCase.FLOATING_TO_SPLITING);
    expect(assertFlag).assertTrue();
    multiWindowGuideUtils.guideFinish(GuideCase.SPLITING_GUIDE);
    expect(assertFlag).assertTrue();
    multiWindowGuideUtils.guideFinish(GuideCase.FLOATING_TIPS);
    expect(assertFlag).assertTrue();
    multiWindowGuideUtils.guideFinish(GuideCase.SPLITING_TIPS);
    expect(assertFlag).assertTrue();
  });
}

function isStartFromAppDockTest_func() {
  it('isStartFromAppDockTest_it', Level.LEVEL0, (): void => {
    SCBMultiWindowUtils.isStartFromAppDock(sceneInfo);
    expect(assertFlag).assertTrue();
  });
}

function applyToContainerTest_func() {
  it('applyToContainerTest_it', Level.LEVEL0, (): void => {
    SCBMultiWindowUtils.isStartFromAppDock(sceneInfo);
    expect(assertFlag).assertTrue();
  });
}

function showToastTestAll_func() {
  it('showToastTestAll_it', Level.LEVEL0, (): void => {
    SCBMultiWindowUtils.showToast($r('app.string.oh_multiwindow_not_support_horizontal_split_new'));
    SCBMultiWindowUtils.showToast($r('app.string.MultiWindow_guidance_button_next'));
    SCBMultiWindowUtils.showToast($r('app.string.MultiWindow_guidance_split_swap_title'));
    SCBMultiWindowUtils.showToast($r('app.string.MultiWindow_guidance_split_to_float_title'));
    SCBMultiWindowUtils.showToast($r('app.string.MultiWindow_guidance_button_finish'));
    SCBMultiWindowUtils.showToast($r('app.string.oh_multiwindow_vertical_exchange'));
    SCBMultiWindowUtils.showToast($r('app.string.oh_multiwindow_not_support_split_ratio'));
    SCBMultiWindowUtils.showToast($r('app.string.oh_multiwindow_not_support_split_ratio'));
    SCBMultiWindowUtils.showToast($r('app.string.MultiWindow_guidance_split_swap_content_fold'));
    SCBMultiWindowUtils.showToast($r('app.string.MultiWindow_guidance_split_to_float_content_fold'));
    SCBMultiWindowUtils.showToast($r('app.string.MultiWindow_guidance_button_quit'));
    SCBMultiWindowUtils.showToast($r('app.string.MultiWindow_guidance_button_more'));
    SCBMultiWindowUtils.showToast($r('app.string.oh_multiwindow_horizontal_split'));
    SCBMultiWindowUtils.showToast($r('app.string.MultiWindow_guidance_split_swap_content_phone'));
    SCBMultiWindowUtils.showToast($r('app.string.oh_multiwindow_not_support_split_for_folded_new'));
    SCBMultiWindowUtils.showToast($r('app.string.MultiWindow_guidance_float_to_split_title'));
    SCBMultiWindowUtils.showToast($r('app.string.MultiWindow_guidance_float_to_split_content'));
    SCBMultiWindowUtils.showToast($r('app.string.MultiWindow_guidance_split_to_float_content_phone'));
    SCBMultiWindowUtils.showToast($r('app.string.MultiWindow_guidance_button_know'));
    SCBMultiWindowUtils.showToast($r('app.string.oh_multiwindow_not_support_multiwindows'));
    SCBMultiWindowUtils.showToast($r('app.string.oh_multiwindow_not_support_split'));
    SCBMultiWindowUtils.showToast($r('app.string.oh_multiwindow_click_application_form_split_screen'));
    SCBMultiWindowUtils.showToast($r('app.string.oh_multiwindow_not_support_float_window'));
    SCBMultiWindowUtils.showToast($r('app.string.oh_multiwindow_app_is_open'));
    SCBMultiWindowUtils.showToast($r('app.string.oh_multiwindow_not_support_vertical_split_new'));
    SCBMultiWindowUtils.showToast($r('app.string.oh_multiwindow_vertical_split'));
    SCBMultiWindowUtils.showToast($r('app.string.oh_multiwindow_horizontal_exchange'));
    SCBMultiWindowUtils.showToast($r('app.string.oh_multiwindow_save_group'));

    expect(assertFlag).assertTrue();
  });
}

function showToastTestAdd_func() {
  it('showToastTestAdd_it', Level.LEVEL0, (): void => {
    SCBMultiWindowUtils.showToast($r('app.string.oh_multiwindow_not_support_split_ratio'));
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showClickAnotherAppToPairSplitToast();
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showClickAppAddToMidSceneToast();
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showNotSupportMultiWindowsToast('');
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showNotSupportMultiWindowsToast('testBundle002');
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showNotSupportMultiWindowsToast('testModule002');
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showBackToMiddleSceneToast();
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showCommonToast(MultiWindowToast.NOT_SUPPORT_SPLIT, sceneInfo);
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showCommonToast(MultiWindowToast.NOT_SUPPORT_SPLIT, sceneInfo);
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showCommonToast(MultiWindowToast.NOT_SUPPORT_SPLIT_RATIO, sceneInfo);
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showCommonToast(MultiWindowToast.NOT_SUPPORT_SPLIT_FOR_FOLDED, sceneInfo);
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showCommonToast(MultiWindowToast.NOT_SUPPORT_HORIZONTAL_SPLIT, sceneInfo);
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showCommonToast(MultiWindowToast.NOT_SUPPORT_VERTICAL_SPLIT, sceneInfo);
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showNotSupportFloatingWindowsToast('testModule002');
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showNotSupportFloatingWindowsToast('testBundle002');
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showThisAppIsOpenToast('testModule002');
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showThisAppIsOpenToast('testBundle002');
    expect(assertFlag).assertTrue();

    // 使用mock更改条件
    let appInfo: AppItemInfo = new AppItemInfo();
    appInfo.appId = '0';
    appInfo.moduleName = 'testModule003';
    let mocker1: MockKit = new MockKit();
    let appModel: AppModel = AppModel.getInstance();
    let mockFunc: Function = mocker1.mockFunc(appModel,appModel.getAppInfoByBundleName);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(appInfo);
    SCBMultiWindowUtils.showToast($r('app.string.oh_multiwindow_not_support_split_ratio'));
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showClickAnotherAppToPairSplitToast();
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showClickAppAddToMidSceneToast();
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showNotSupportMultiWindowsToast('testBundle003');
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showNotSupportMultiWindowsToast('testModule03');
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showBackToMiddleSceneToast();
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showCommonToast(MultiWindowToast.NOT_SUPPORT_SPLIT, sceneInfo);
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showCommonToast(MultiWindowToast.NOT_SUPPORT_SPLIT, sceneInfo);
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showCommonToast(MultiWindowToast.NOT_SUPPORT_SPLIT_RATIO, sceneInfo);
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showCommonToast(MultiWindowToast.NOT_SUPPORT_SPLIT_FOR_FOLDED, sceneInfo);
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showCommonToast(MultiWindowToast.NOT_SUPPORT_HORIZONTAL_SPLIT, sceneInfo);
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showCommonToast(MultiWindowToast.NOT_SUPPORT_VERTICAL_SPLIT, sceneInfo);
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showNotSupportFloatingWindowsToast('testModule03');
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showNotSupportFloatingWindowsToast('testBundle003');
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showThisAppIsOpenToast('testModule03');
    expect(assertFlag).assertTrue();
    SCBMultiWindowUtils.showThisAppIsOpenToast('testBundle003');
    expect(assertFlag).assertTrue();

    mocker1.clear(mockFunc);
  });
}

function isSplitExpectWindowModeTest() {
  it('isSplitExpectWindowModeTest', Level.LEVEL0, () => {
    sceneInfo.updateWindowModeAndSync(SCBSceneMode.UNDEFINED);
    let res = SCBMultiWindowUtils.isSplitExpectWindowMode(sceneInfo);
    sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
    let res1 = SCBMultiWindowUtils.isSplitExpectWindowMode(sceneInfo);
    sceneInfo.updateWindowModeAndSync(SCBSceneMode.PRIMARY);
    let res2 = SCBMultiWindowUtils.isSplitExpectWindowMode(sceneInfo);
    sceneInfo.updateWindowModeAndSync(SCBSceneMode.SECONDARY);
    let res3 = SCBMultiWindowUtils.isSplitExpectWindowMode(sceneInfo);
    sceneInfo.updateWindowModeAndSync(SCBSceneMode.FLOATING);
    let res4 = SCBMultiWindowUtils.isSplitExpectWindowMode(sceneInfo);
    sceneInfo.updateWindowModeAndSync(SCBSceneMode.PIP);
    let res5 = SCBMultiWindowUtils.isSplitExpectWindowMode(sceneInfo);
    expect(res).assertFalse();
    expect(res1).assertFalse();
    expect(res2).assertTrue();
    expect(res3).assertTrue();
    expect(res4).assertFalse();
    expect(res5).assertFalse();
  });
}

export function covertCoordinateByRotationTest() {
  it('covertCoordinateByRotationTest', Level.LEVEL0, () => {
    let l = new Location(1, 1);
    let res = SCBMultiWindowUtils.covertCoordinateByRotation(l, 0, 100, 100);
    expect(res.x).assertLarger(0);
    expect(res.y).assertLarger(0);
    let res1 = SCBMultiWindowUtils.covertCoordinateByRotation(l, 180, 100, 100);
    expect(res1.x).assertLarger(0);
    expect(res1.y).assertLarger(0);
    let res2 = SCBMultiWindowUtils.covertCoordinateByRotation(l, 270, 100, 100);
    expect(res2.x).assertLarger(0);
    expect(res2.y).assertLarger(0);
    let res3 = SCBMultiWindowUtils.covertCoordinateByRotation(l, 90, 100, 100);
    expect(res3.x).assertLarger(0);
    expect(res3.y).assertLarger(0);
  })
}

export function showNotSupportAdjustWindowToastTest() {
  it('showNotSupportAdjustWindowToastTest01', Level.LEVEL0, () => {
    SCBMultiWindowUtils.isDockAnimating = false;
    SCBMultiWindowUtils.showNotSupportAdjustWindowToast('test');
    expect(SCBMultiWindowUtils.isDockAnimating).assertFalse();
  });
  it('showNotSupportAdjustWindowToastTest02', Level.LEVEL0, () => {
    SCBMultiWindowUtils.isDockAnimating = false;
    let appModel = AppModel.getInstance();
    let mocker = new MockKit();
    let func: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleName);
    let info = new AppItemInfo();
    when(func)(ArgumentMatchers.any).afterReturn(info);
    SCBMultiWindowUtils.showNotSupportAdjustWindowToast('test');
    mocker.clear(appModel);
    expect(SCBMultiWindowUtils.isDockAnimating).assertFalse();
  });
}

export function showClickAppAddToMidSceneToastTest() {
  it('showClickAppAddToMidSceneToastTest01', Level.LEVEL0, () => {
    SCBMultiWindowUtils.isDockAnimating = false;
    SCBMultiWindowUtils.showClickAppAddToMidSceneToast();
    expect(SCBMultiWindowUtils.isDockAnimating).assertFalse();
  });
  it('showBackToMiddleSceneToastTest', Level.LEVEL0, () => {
    SCBMultiWindowUtils.isDockAnimating = false;
    SCBMultiWindowUtils.showBackToMiddleSceneToast();
    expect(SCBMultiWindowUtils.isDockAnimating).assertFalse();
  });
}

export function isSupportMidSceneAndIsMidSceneTest() {
  it('isSupportMidSceneAndIsMidSceneTest01', Level.LEVEL0, () => {
    let containerSessionArray = SCBSceneSessionManager.getInstance().getContainerSessionList();
    containerSessionArray.clear();
    let res = SCBMultiWindowUtils.isSupportMidSceneAndIsMidScene(container.primarySession!);
    expect(res).assertFalse();
  });
  it('isSupportMidSceneAndIsMidSceneTest02', Level.LEVEL0, () => {
    let containerSessionArray = SCBSceneSessionManager.getInstance().getContainerSessionList();
    containerSessionArray.clear();
    containerSessionArray.push(container);
    let midManager = MidSceneManagerFactory.getInstance(container.screenProperty);
    let mocker = new MockKit();
    let func = mocker.mockFunc(midManager, midManager.isSupportMidScene);
    when(func)(ArgumentMatchers.any).afterReturn(true);
    container.isMidScene = true;
    sceneSession.defaultRequestOrientation = SCBSceneOrientation.SENSOR_HORIZONTAL;
    let res = SCBMultiWindowUtils.isSupportMidSceneAndIsMidScene(sceneSession);
    let res1 = SCBMultiWindowUtils.isNotSupportGamePairSplit(sceneSession, 0);
    mocker.clear(midManager);
    expect(res).assertTrue();
    expect(res1).assertTrue();
  });
}

export function isScreenRectUpdateTest() {
  it('isScreenRectUpdateTest01', Level.LEVEL0, () => {
    let oldScreenProperty = new SCBScreenProperty();
    let newScreenProperty = new SCBScreenProperty();
    newScreenProperty.left = 1;
    let res = SCBMultiWindowUtils.isScreenRectUpdate(oldScreenProperty, newScreenProperty);
    expect(res).assertTrue();
  });
  it('isScreenRectUpdateTest02', Level.LEVEL0, () => {
    let oldScreenProperty = new SCBScreenProperty();
    let newScreenProperty = new SCBScreenProperty();
    newScreenProperty.top = 1;
    let res = SCBMultiWindowUtils.isScreenRectUpdate(oldScreenProperty, newScreenProperty);
    expect(res).assertTrue();
  });
  it('isScreenRectUpdateTest03', Level.LEVEL0, () => {
    let oldScreenProperty = new SCBScreenProperty();
    let newScreenProperty = new SCBScreenProperty();
    newScreenProperty.width = 1;
    let res = SCBMultiWindowUtils.isScreenRectUpdate(oldScreenProperty, newScreenProperty);
    expect(res).assertTrue();
  });
  it('isScreenRectUpdateTest04', Level.LEVEL0, () => {
    let oldScreenProperty = new SCBScreenProperty();
    let newScreenProperty = new SCBScreenProperty();
    newScreenProperty.height = 1;
    let res = SCBMultiWindowUtils.isScreenRectUpdate(oldScreenProperty, newScreenProperty);
    expect(res).assertTrue();
  });
  it('isScreenRectUpdateTest05', Level.LEVEL0, () => {
    let oldScreenProperty = new SCBScreenProperty();
    let newScreenProperty = new SCBScreenProperty();
    let res = SCBMultiWindowUtils.isScreenRectUpdate(oldScreenProperty, newScreenProperty);
    expect(res).assertFalse();
  });
}

export function getAllActiveAppsInfosTest() {
  it('getAllActiveAppsInfosTest01', Level.LEVEL0, () => {
    let containerList = SCBScenePanelManager.getInstance().getSceneContainerSessionList();
    let floatList = SCBScenePanelManager.getInstance().getFloatingSessionList();
    let floatManager = SCBFloatManager.getInstance();
    containerList.clear();
    floatList.clear();
    let res = SCBMultiWindowUtils.getAllActiveAppsInfos();
    expect(res).assertEqual('');
  });

  it('getAllActiveAppsInfosTest02', Level.LEVEL0, () => {
    let containerList = SCBScenePanelManager.getInstance().getSceneContainerSessionList();
    let floatList = SCBScenePanelManager.getInstance().getFloatingSessionList();
    containerList.clear();
    floatList.clear();
    let floatManager = SCBFloatManager.getInstance();
    let mocker = new MockKit();
    let mockFunc: Function = mocker.mockFunc(floatManager, floatManager.getKeepForegroundFloatingList);
    when(mockFunc)(ArgumentMatchers.any).afterReturn([container]);
    let res = SCBMultiWindowUtils.getAllActiveAppsInfos();
    containerList.push(container);
    let res1 = SCBMultiWindowUtils.getAllActiveAppsInfos();
    container.addSceneSession(secSceneSession);
    ReflectionUtils.setProperty(container, '_isActive', true);
    let res2 = SCBMultiWindowUtils.getAllActiveAppsInfos();
    container = new SCBSceneContainerSession(sceneSession, screenProperty);
    mocker.clear(floatManager);
    expect(res.length).assertLarger(0);
    expect(res1.length).assertLarger(0);
    expect(res2.length).assertLarger(0);
  });
}

export function isPadUiTypeTest() {
  it('isPadUiTypeTest', Level.LEVEL0, () => {
    let config = SCBWindowSceneConfig.getInstance().windowSceneConfig;
    let type: string = ReflectionUtils.getProperty(config, 'uiType');
    ReflectionUtils.setProperty(config, 'uiType', SCBConstants.UITYPE_PAD);
    let res = SCBMultiWindowUtils.isPadUiType();
    ReflectionUtils.setProperty(config, 'uiType', SCBConstants.UITYPE_PHONE);
    let res1 = SCBMultiWindowUtils.isPadUiType();
    ReflectionUtils.setProperty(config, 'uiType', SCBConstants.UITYPE_PHONE);
    let res2 = SCBMultiWindowUtils.isPadUiType();
    ReflectionUtils.setProperty(config, 'uiType', type);
    expect(res).assertTrue();
    expect(res1).assertFalse();
    expect(res2).assertFalse();
  });
}

export function getDockItemIdTest() {
  it('getDockItemIdTest', Level.LEVEL0, () => {
    let itemInfo = new DockItemInfo();
    let res = SCBMultiWindowUtils.getDockItemId(itemInfo);
    expect(res.length).assertLarger(0);
  });
  it('hideGestureDockTest', Level.LEVEL0, () => {
    SCBMultiWindowUtils.isDockAnimating = true;
    SCBMultiWindowUtils.hideGestureDock();
    expect(SCBMultiWindowUtils.isDockAnimating).assertTrue();
  });
}

export function hideKeyBoardWhenWillEnterRecentForSplitTest() {
  it('hideKeyBoardWhenWillEnterRecentForSplit', Level.LEVEL0, () => {
    SCBMultiWindowUtils.isDockAnimating = true;
    SCBMultiWindowUtils.hideKeyBoardWhenWillEnterRecentForSplit(null);
    expect(SCBMultiWindowUtils.isDockAnimating).assertTrue();
    SCBMultiWindowUtils.hideKeyBoardWhenWillEnterRecentForSplit(undefined);
    expect(SCBMultiWindowUtils.isDockAnimating).assertTrue();
    container.isSplit = false;
    SCBMultiWindowUtils.hideKeyBoardWhenWillEnterRecentForSplit(container);
    expect(SCBMultiWindowUtils.isDockAnimating).assertTrue();
    container.isSplit = true;
    container.splitParam.hasAvoidInputMethod = true;
    SCBMultiWindowUtils.hideKeyBoardWhenWillEnterRecentForSplit(container);
    expect(SCBMultiWindowUtils.isDockAnimating).assertTrue();
    let session = SCBKeyboardManager.getInstance().getKeyboardSession();
    if (session) {
      expect(session.isKeyboardShowing()).assertFalse();
    }
  });
  it('hideGestureDockTest', Level.LEVEL0, () => {
    SCBMultiWindowUtils.isDockAnimating = true;
    SCBMultiWindowUtils.hideGestureDock();
    expect(SCBMultiWindowUtils.isDockAnimating).assertTrue();
  });
}

export function isNeedUpdateAppIconOpacity() {
  it('GestureDockUtil_isNeedUpdateAppIconOpacity_8', 0, (): void => {
    AppStorage.setOrCreate('scenePanelState', 5);
    let mocker = new MockKit();
    let sessionManager = SCBSceneSessionManager.getInstance();
    let mockFunc: Function = mocker.mockFunc(sessionManager, sessionManager.isPcMode);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

    const getFuncName: string = 'getContainerSessionList';
    let getContainerSessionListFunc = ReflectionUtils.getProperty(sessionManager, getFuncName) as
    (screenId?: number) => SCBSceneContainerSessionArray;
    expect(getContainerSessionListFunc).assertInstanceOf('Function');

    sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
    sceneInfo.persistentId = 1001;
    let sceneInfo2 = new SCBSceneInfo('testPriBundle2', 'testPriModule2', 'testPriAbility2');
    sceneInfo2.persistentId = 1002;
    let primSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    primSession.requestSessionActivation(true);
    container.primarySession = primSession;

    ReflectionUtils.setProperty(sessionManager, getFuncName, () => {
      return [container];
    });
    let appItemInfo = new AppItemInfo();
    appItemInfo.bundleName = 'testPriBundle';
    let result: boolean = SCBMultiWindowUtils.isNeedUpdateAppIconOpacity(appItemInfo);
    expect(result !== undefined).assertTrue();
  });
}