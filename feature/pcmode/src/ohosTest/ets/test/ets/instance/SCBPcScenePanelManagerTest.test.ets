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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import {
  SCBSceneInfo,
  SCBSceneSession,
  SCBSceneContainerSession,
  SCBSpecificSession,
  SCBSceneMode,
  SCBScreenSessionManager,
  SCBScreenSession,
  SCBSpecificSceneSessionList,
  SCBSceneSessionManager,
  WindowSize,
  SCBSessionRect
} from '@ohos/windowscene/src/main/ets/TsIndex';
import {
  SCBPcScenePanelManager
} from '../../../../../main/ets/instance/SCBPcScenePanelManager';
import { SCBSystemSceneUtils } from '../../../../../main/ets/utils/SCBSystemSceneUtils';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBScreenProperty } from '@ohos/windowscene';
import {
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import screenSessionManager from '@ohos.screenSessionManager';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { ReflectionUtils } from '../ReflectionUtils';
import { UIContext } from '@kit.ArkUI';

const TAG = 'SCBPcScenePanelManagerTest';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

let scbPcScenePanelManager: SCBPcScenePanelManager;

export function SCBPcScenePanelManagerTest() {
  describe('SCBScenePanelViewModelTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // init SCBScenePanelViewModel instance
      scbPcScenePanelManager = SCBPcScenePanelManager.getInstance();
    })
    beforeEach(() => {

    })
    afterEach(() => {

    })
    afterAll(() => {

    });
    moveContainerSessionToAnotherScreenForDisplayTest();
    isFullScreenSessionNeedFollowScreenTest();
    isNonFullScreenFloatSessionTest();
    updateSubSessionTest();
    mergeSpecificSessionListTest();
    updateSystemSceneFollowScreenTest();
    getTopThresholdTest();
    getBottomThresholdTest();
    updateExtendContainerSessionTest();
    updateContainerSessionWithChangeModeTest();
    getIsWindowRectAutoSaveMapTest();
    setIsWindowRectAutoSaveMapTest();
    getIsEnableSpecifiedRectAutoSaveMapTest();
    setIsEnableSpecifiedRectAutoSaveMapTest();
    createIsWindowRectAutoSaveKeyTest();
    updateExtendSubSessionTest();
    updateContainerSessionDisplayInfoTest();
    getSpecificSessionListTest();
    updateRectWithDpiChangeTest();
    registerGetIsPairSplitCallbackTest();
    unRegisterGetIsPairSplitCallbackTest();
    getIsPairSplitTest();
    registerUIContextTest();
    unregisterUIContextTest();
    registerAddListNotShowRecentCallbackTest();
    unRegisterAddListNotShowRecentCallbackTest();
    registerRemoveListNotShowRecentCallbackTest();
    unRegisterRemoveListNotShowRecentCallbackTest();
    registerSceneHiddenModeVisChangeCallbackTest();
    unRegisterSceneHiddenModeVisChangeCallbackTest();
    moveHiddenSessionToAnotherScreenForDisplayTest();
    registerDisplayChangeCallbackTest();
    unregisterDisplayChangeCallbackTest();
  });
}

function moveContainerSessionToAnotherScreenForDisplayTest() {
  it('moveContainerSessionToAnotherScreenForDisplayTest_01', Level.LEVEL0, (): void => {
    log.showInfo(`moveContainerSessionToAnotherScreenForDisplayTest_01 start`);
    let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
    testSCBSceneInfo.screenId = 1;
    let testSession = sceneSessionManager.requestSceneSession(testSCBSceneInfo);
    let testPrimarySCBSceneSession: SCBSceneSession = new SCBSceneSession(testSession, testSCBSceneInfo);
    let testSCBScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    let testContainer: SCBSceneContainerSession = new SCBSceneContainerSession(testPrimarySCBSceneSession, testSCBScreenProperty);
    scbPcScenePanelManager.registerAddListNotShowRecentCallback((
        containerSession: SCBSceneContainerSession) => {}, 1);
    scbPcScenePanelManager.registerRemoveListNotShowRecentCallback((
        containerSession: SCBSceneContainerSession) => {}, 1);
    scbPcScenePanelManager.registerSceneHiddenModeVisChangeCallback((
        containerSession: SCBSceneContainerSession, visible?: boolean, isFromClient?: boolean
    ) => {}, 1);
    let scbSceneSessionManager = SCBSceneSessionManager.getInstance();
    let mocker: MockKit = new MockKit();
    let mockFunc: Function =
      mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.getAbilityWindowSize);
    let windowSize = new WindowSize();
    windowSize.maxWindowRatio = 100;
    windowSize.minWindowRatio = 0;
    windowSize.maxWindowWidth = 3120;
    windowSize.minWindowWidth = 0;
    windowSize.maxWindowHeight = 2080;
    windowSize.minWindowHeight = 0;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(windowSize);
    scbPcScenePanelManager.moveContainerSessionToAnotherScreenForDisplay(testContainer, 1, 0);
    scbPcScenePanelManager.unRegisterAddListNotShowRecentCallback(1);
    scbPcScenePanelManager.unRegisterRemoveListNotShowRecentCallback(1);
    scbPcScenePanelManager.unRegisterSceneHiddenModeVisChangeCallback(1);
    mocker.clear(scbSceneSessionManager);
    expect(testContainer.primarySession!.sceneInfo.screenId).assertEqual(0);
    log.showInfo(`moveContainerSessionToAnotherScreenForDisplayTest_01 end`);
  });
}

function isFullScreenSessionNeedFollowScreenTest() {
  it('isFullScreenSessionNeedFollowScreenTest_01', Level.LEVEL0, (): void => {
    let specificSceneInfo: SCBSceneInfo =
      new SCBSceneInfo('testSpecificBundle', 'testSpecificModule', 'testSpecificAbility');
    let specificSession: SCBSpecificSession =
      new SCBSpecificSession(sceneSessionManager.requestSceneSession(specificSceneInfo), () => {});
    specificSession.currRect.setRectNum(0, 0, 2472, 3296);
    specificSession.isFollowScreenChange = true;
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    screenProperty.left = 0;
    screenProperty.top = 0;
    screenProperty.width = 2472;
    screenProperty.height = 3296;
    let result: boolean =
      scbPcScenePanelManager.isFullScreenSessionNeedFollowScreen(specificSession, screenProperty);
    expect(result).assertTrue();
    specificSession.isFollowScreenChange = false;
    result = scbPcScenePanelManager.isFullScreenSessionNeedFollowScreen(specificSession, screenProperty);
    expect(result).assertFalse();
    specificSession.isFollowScreenChange = true;
    specificSession.currRect.setRectNum(0, 0, 1, 1);
    result = scbPcScenePanelManager.isFullScreenSessionNeedFollowScreen(specificSession, screenProperty);
    expect(result).assertFalse();
  });
}

function isNonFullScreenFloatSessionTest() {
  it('isNonFullScreenFloatSessionTest_01', Level.LEVEL0, (): void => {
    let specificSceneInfo: SCBSceneInfo =
      new SCBSceneInfo('testSpecificBundle', 'testSpecificModule', 'testSpecificAbility');
    let specificSession: SCBSpecificSession =
      new SCBSpecificSession(sceneSessionManager.requestSceneSession(specificSceneInfo), () => {});
    specificSession.currRect.setRectNum(0, 0, 2472, 3296);
    specificSession.isFollowScreenChange = true;
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    screenProperty.left = 0;
    screenProperty.top = 0;
    screenProperty.width = 2472;
    screenProperty.height = 3296;
    let result: boolean =
      scbPcScenePanelManager.isNonFullScreenFloatSession(specificSession, screenProperty);
    expect(result).assertFalse();
  });
}

function updateSubSessionTest() {
  it('updateSubSessionTest_01', Level.LEVEL0, (): void => {
    let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
    let testSession = sceneSessionManager.requestSceneSession(testSCBSceneInfo);
    let testPrimarySCBSceneSession: SCBSceneSession = new SCBSceneSession(testSession, testSCBSceneInfo);
    let oldScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    oldScreenProperty.screenId = 0;
    let newScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    newScreenProperty.screenId = 12;
    newScreenProperty.width = 3296;
    newScreenProperty.height = 2472;
    let specificSceneInfo: SCBSceneInfo =
      new SCBSceneInfo('testSpecificBundle', 'testSpecificModule', 'testSpecificAbility');
    let specificSession: SCBSpecificSession =
      new SCBSpecificSession(sceneSessionManager.requestSceneSession(specificSceneInfo), () => {});
    specificSession.screenId = 12;
    specificSession.windowMode = SCBSceneMode.FULLSCREEN;
    testPrimarySCBSceneSession.subSessionList.push(specificSession);
    scbPcScenePanelManager.updateSubSession(testPrimarySCBSceneSession, oldScreenProperty,
      newScreenProperty, testPrimarySCBSceneSession.currRect.copy(), 0);
    expect(specificSession.currRect.width.getPx()).assertEqual(0);
    expect(specificSession.currRect.height.getPx()).assertEqual(0);
    specificSession.screenId = 0;
    scbPcScenePanelManager.updateSubSession(testPrimarySCBSceneSession, oldScreenProperty,
      newScreenProperty, testPrimarySCBSceneSession.currRect.copy(), 0);
    expect(specificSession.screenId).assertEqual(12);
    scbPcScenePanelManager.updateSubSession(testPrimarySCBSceneSession, oldScreenProperty,
      newScreenProperty, testPrimarySCBSceneSession.currRect.copy(), 0);
    expect(specificSession.currRect.width.getPx()).assertEqual(3296);
    expect(specificSession.currRect.height.getPx()).assertEqual(2472);
  });
}

function mergeSpecificSessionListTest() {
  it('mergeSpecificSessionListTest_01', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let screenSessionManager = SCBScreenSessionManager.getInstance();
    let mockFunc1: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getMainScreenSession);
    let mockFunc2: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenSession);
    let testPtr : UIContext;
    let screenSession1: screenSessionManager.ScreenSession = {
      screenId: 0,
      name: 'testScreen1',
      on: (type: string, callback: Function): void => {},
      setScreenRotationLocked: (isLocked: boolean): void => {},
      loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {},
      setTouchEnabled: (isTouchEnabled: boolean): void => {},
      getScreenUIContext: (): UIContext => {return testPtr; },
      displayGroupId: 0,
      destroyContent: (): void => {
        throw new Error('Function not implemented.');
      },
      releaseResource: (): void => {}
    };
    let newScreenProperty1: SCBScreenProperty = new SCBScreenProperty();
    newScreenProperty1.screenId = 0;
    newScreenProperty1.width = 3296;
    newScreenProperty1.height = 2472;
    let scbScreenSession1: SCBScreenSession = new SCBScreenSession(screenSession1);
    scbScreenSession1.scbScreenProperty = newScreenProperty1;
    let screenSession2: screenSessionManager.ScreenSession = {
      screenId: 12,
      name: 'testScreen2',
      on: (type: string, callback: Function): void => {},
      setScreenRotationLocked: (isLocked: boolean): void => {},
      loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {},
      setTouchEnabled: (isTouchEnabled: boolean): void => {},
      getScreenUIContext: (): UIContext => { return testPtr; },
      displayGroupId: 0,
      destroyContent: (): void => {
        throw new Error('Function not implemented.');
      },
      releaseResource: (): void => {}
    };
    let newScreenProperty2: SCBScreenProperty = new SCBScreenProperty();
    newScreenProperty2.screenId = 12;
    newScreenProperty2.width = 2472;
    newScreenProperty2.height = 3296;
    let scbScreenSession2: SCBScreenSession = new SCBScreenSession(screenSession2);
    scbScreenSession2.scbScreenProperty = newScreenProperty2;
    when(mockFunc1)(ArgumentMatchers.any).afterReturn(scbScreenSession1);
    when(mockFunc2)(ArgumentMatchers.any).afterReturn(scbScreenSession2);
    let specificSessionMap: Map<number, SCBSpecificSceneSessionList> = new Map();
    let specificSessionList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
    let specificSceneInfo: SCBSceneInfo =
      new SCBSceneInfo('testSpecificBundle', 'testSpecificModule', 'testSpecificAbility');
    let specificSession: SCBSpecificSession =
      new SCBSpecificSession(sceneSessionManager.requestSceneSession(specificSceneInfo), () => {});
    specificSession.currRect.setRectNum(0, 0, 2472, 3296);
    specificSession.isFollowScreenChange = true;
    specificSession.isActive = true;
    specificSession.screenId = 12;
    specificSessionList.push(specificSession);
    specificSessionMap.set(0, specificSessionList);
    ReflectionUtils.setProperty(scbPcScenePanelManager, 'specificSessionMap', specificSessionMap);
    scbPcScenePanelManager.mergeSpecificSessionList(12);
    mocker.clear(screenSessionManager);
    expect(specificSession.currRect.width.getPx()).assertEqual(3296);
    expect(specificSession.currRect.height.getPx()).assertEqual(2472);
  });
}

function updateSystemSceneFollowScreenTest() {
  it('updateSystemSceneFollowScreenTest_01', Level.LEVEL0, (): void => {
    let specificSceneInfo: SCBSceneInfo =
      new SCBSceneInfo('testSpecificBundle', 'testSpecificModule', 'testSpecificAbility');
    let specificSession: SCBSpecificSession =
      new SCBSpecificSession(sceneSessionManager.requestSceneSession(specificSceneInfo), () => {});
    specificSession.isActive = false;
    specificSession.currRect.setRectNum(0, 0, 2472, 3296);
    specificSession.isFollowScreenChange = true;
    specificSession.screenId = 0;
    let newScreenProperty1: SCBScreenProperty = new SCBScreenProperty();
    newScreenProperty1.screenId = 0;
    newScreenProperty1.width = 2472;
    newScreenProperty1.height = 3296;
    let newScreenProperty2: SCBScreenProperty = new SCBScreenProperty();
    newScreenProperty2.screenId = 12;
    newScreenProperty2.width = 3296;
    newScreenProperty2.height = 2472;
    ReflectionUtils.useFunc(scbPcScenePanelManager, 'updateSystemSceneFollowScreen', specificSession,
      newScreenProperty1, newScreenProperty2);
    specificSession.isActive = true;
    ReflectionUtils.useFunc(scbPcScenePanelManager, 'updateSystemSceneFollowScreen', specificSession,
      null, newScreenProperty2);
    ReflectionUtils.useFunc(scbPcScenePanelManager, 'updateSystemSceneFollowScreen', specificSession,
      undefined, newScreenProperty2);
    ReflectionUtils.useFunc(scbPcScenePanelManager, 'updateSystemSceneFollowScreen', specificSession,
      newScreenProperty1, newScreenProperty2);
    expect(specificSession.currRect.width.getPx()).assertEqual(3296);
    expect(specificSession.currRect.height.getPx()).assertEqual(2472);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function =
      mocker.mockFunc(scbPcScenePanelManager, scbPcScenePanelManager.isNonFullScreenFloatSession);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
    specificSession.currRect.setRectNum(200, 200, 300, 400);
    ReflectionUtils.useFunc(scbPcScenePanelManager, 'updateSystemSceneFollowScreen', specificSession,
      newScreenProperty1, newScreenProperty2);
    mocker.clear(scbPcScenePanelManager);
    expect(specificSession.currRect.width.getPx()).assertEqual(300);
    expect(specificSession.currRect.height.getPx()).assertEqual(400);
  });
}

function getTopThresholdTest() {
  it('getTopThresholdTest', Level.LEVEL0, () => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    screenProperty.screenId = 0;
    screenProperty.width = 2472;
    screenProperty.height = 3296;
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
    let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let container: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
    let mocker: MockKit = new MockKit();
    let scbSystemSceneUtils = SCBSystemSceneUtils.getInstance();
    let mockFunc1: Function =
      mocker.mockFunc(scbSystemSceneUtils, scbSystemSceneUtils.getStatusBarHeightPx);
    when(mockFunc1)(ArgumentMatchers.any).afterReturn(0);
    let ret: number = ReflectionUtils.useFunc(scbPcScenePanelManager, 'getTopThreshold', 1);
    mocker.clear(scbSystemSceneUtils);
    expect(ret).assertEqual(0);
  });
}

function getBottomThresholdTest() {
  it('getBottomThresholdTest', Level.LEVEL0, () => {
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    screenProperty.screenId = 0;
    screenProperty.width = 2472;
    screenProperty.height = 3296;
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
    let session: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
    let container: SCBSceneContainerSession = new SCBSceneContainerSession(session, screenProperty);
    let mocker: MockKit = new MockKit();
    let scbSystemSceneUtils = SCBSystemSceneUtils.getInstance();
    let mockFunc1: Function =
      mocker.mockFunc(scbSystemSceneUtils, scbSystemSceneUtils.getDockHeightPx);
    when(mockFunc1)(ArgumentMatchers.any).afterReturn(118);
    let ret: number = ReflectionUtils.useFunc(scbPcScenePanelManager, 'getBottomThreshold', screenProperty);
    mocker.clear(scbSystemSceneUtils);
    expect(ret).assertEqual(3178);
  });
}

function updateExtendContainerSessionTest() {
  it('updateExtendContainerSessionTest_01', Level.LEVEL0, (): void => {
    let oldScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    oldScreenProperty.screenId = 12;
    oldScreenProperty.width = 3120;
    oldScreenProperty.height = 1755;
    let newScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    newScreenProperty.screenId = 0;
    newScreenProperty.width = 3120;
    newScreenProperty.height = 2080;
    let sceneInfo1: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
    let scbSceneSessionManager = SCBSceneSessionManager.getInstance();
    let mocker: MockKit = new MockKit();
    let mockFunc: Function =
      mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.getAbilityWindowSize);
    let windowSize = new WindowSize();
    windowSize.maxWindowRatio = 100;
    windowSize.minWindowRatio = 0;
    windowSize.maxWindowWidth = 3120;
    windowSize.minWindowWidth = 0;
    windowSize.maxWindowHeight = 2080;
    windowSize.minWindowHeight = 0;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(windowSize);
    let scbSystemSceneUtils = SCBSystemSceneUtils.getInstance();
    let mockFunc1: Function =
      mocker.mockFunc(scbSystemSceneUtils, scbSystemSceneUtils.getStatusBarHeightPx);
    when(mockFunc1)(ArgumentMatchers.any).afterReturn(0);
    let mockFunc2: Function =
      mocker.mockFunc(scbSystemSceneUtils, scbSystemSceneUtils.getDockHeightPx);
    when(mockFunc2)(ArgumentMatchers.any).afterReturn(125);
    sceneInfo1.updateWindowModeAndSync(SCBSceneMode.FLOATING);
    let session1: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
    session1.currRect.setRectNum(200, 200, 300, 400);
    let containerSession1: SCBSceneContainerSession = new SCBSceneContainerSession(session1, oldScreenProperty);
    scbPcScenePanelManager.updateExtendContainerSession(containerSession1, newScreenProperty);
    expect(containerSession1.primarySession!.currRect.width.getPx()).assertEqual(300);
    expect(containerSession1.primarySession!.currRect.height.getPx()).assertEqual(400);
    let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
    sceneInfo2.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
    let session2: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
    session2.currRect.setRectNum(0, 0, 3120, 1662);
    let containerSession2: SCBSceneContainerSession = new SCBSceneContainerSession(session2, oldScreenProperty);
    scbPcScenePanelManager.updateExtendContainerSession(containerSession2, newScreenProperty);
    mocker.clear(scbSceneSessionManager);
    mocker.clear(scbSystemSceneUtils);
    expect(containerSession2.primarySession!.currRect.width.getPx()).assertEqual(3120);
    expect(containerSession2.primarySession!.currRect.height.getPx()).assertEqual(1955);
  });
}

function updateContainerSessionWithChangeModeTest() {
  it('updateContainerSessionWithChangeModeTest_01', Level.LEVEL0, (): void => {
    let oldScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    oldScreenProperty.screenId = 0;
    oldScreenProperty.width = 3120;
    oldScreenProperty.height = 1755;
    let newScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    newScreenProperty.screenId = 0;
    newScreenProperty.width = 3120;
    newScreenProperty.height = 2080;
    let sceneInfo1: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
    let scbSceneSessionManager = SCBSceneSessionManager.getInstance();
    let mocker: MockKit = new MockKit();
    let mockFunc: Function =
      mocker.mockFunc(scbSceneSessionManager, scbSceneSessionManager.getAbilityWindowSize);
    let windowSize = new WindowSize();
    windowSize.maxWindowRatio = 100;
    windowSize.minWindowRatio = 0;
    windowSize.maxWindowWidth = 3120;
    windowSize.minWindowWidth = 0;
    windowSize.maxWindowHeight = 2080;
    windowSize.minWindowHeight = 0;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(windowSize);
    let scbSystemSceneUtils = SCBSystemSceneUtils.getInstance();
    let mockFunc1: Function =
      mocker.mockFunc(scbSystemSceneUtils, scbSystemSceneUtils.getStatusBarHeightPx);
    when(mockFunc1)(ArgumentMatchers.any).afterReturn(0);
    let mockFunc2: Function =
      mocker.mockFunc(scbSystemSceneUtils, scbSystemSceneUtils.getDockHeightPx);
    when(mockFunc2)(ArgumentMatchers.any).afterReturn(125);
    sceneInfo1.updateWindowModeAndSync(SCBSceneMode.FLOATING);
    let session1: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
    session1.currRect.setRectNum(200, 200, 300, 400);
    let containerSession1: SCBSceneContainerSession = new SCBSceneContainerSession(session1, oldScreenProperty);
    scbPcScenePanelManager.updateContainerSessionWithChangeMode(containerSession1, oldScreenProperty,
      newScreenProperty, 1.9);
    expect(containerSession1.primarySession!.currRect.width.getPx()).assertEqual(300);
    expect(containerSession1.primarySession!.currRect.height.getPx()).assertEqual(400);
    let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
    sceneInfo2.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
    let session2: SCBSceneSession =
      new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo2), sceneInfo2);
    session2.currRect.setRectNum(0, 0, 3120, 1662);
    let containerSession2: SCBSceneContainerSession = new SCBSceneContainerSession(session2, oldScreenProperty);
    scbPcScenePanelManager.updateContainerSessionWithChangeMode(containerSession2, oldScreenProperty,
      newScreenProperty, 1.9);
    mocker.clear(scbSceneSessionManager);
    mocker.clear(scbSystemSceneUtils);
    expect(containerSession2.primarySession!.currRect.width.getPx()).assertEqual(3120);
    expect(containerSession2.primarySession!.currRect.height.getPx()).assertEqual(1955);
  });
}

function getIsWindowRectAutoSaveMapTest() {
  it('getIsWindowRectAutoSaveMapTest_01', Level.LEVEL0, (): void => {
    let key = 'test';
    scbPcScenePanelManager.setIsWindowRectAutoSaveMap(key, false);
    expect(scbPcScenePanelManager.getIsWindowRectAutoSaveMap(key)).assertFalse();
  });
}

function setIsWindowRectAutoSaveMapTest() {
  it('setIsWindowRectAutoSaveMapTest_01', Level.LEVEL0, (): void => {
    let key = 'test';
    scbPcScenePanelManager.setIsWindowRectAutoSaveMap(key, true);
    expect(scbPcScenePanelManager.getIsWindowRectAutoSaveMap(key)).assertTrue();
  });
}

function getIsEnableSpecifiedRectAutoSaveMapTest() {
  it('getIsEnableSpecifiedRectAutoSaveMapTest_01', Level.LEVEL0, (): void => {
    let key = 'test';
    scbPcScenePanelManager.setIsEnableSpecifiedRectAutoSaveMap(key, false);
    expect(scbPcScenePanelManager.getIsEnableSpecifiedRectAutoSaveMap(key)).assertFalse();
  });
}

function setIsEnableSpecifiedRectAutoSaveMapTest() {
  it('setIsEnableSpecifiedRectAutoSaveMapTest_01', Level.LEVEL0, (): void => {
    let key = 'test';
    scbPcScenePanelManager.setIsEnableSpecifiedRectAutoSaveMap(key, true);
    expect(scbPcScenePanelManager.getIsEnableSpecifiedRectAutoSaveMap(key)).assertTrue();
  });
}

function createIsWindowRectAutoSaveKeyTest() {
  it('createIsWindowRectAutoSaveKeyTest_01', Level.LEVEL0, (): void => {
    let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
    let key = scbPcScenePanelManager.createIsWindowRectAutoSaveKey(sceneInfo);
    expect(key).assertEqual('testBundleName' + 'testModuleName' + 'testAbilityName');
    sceneInfo.specifiedFlag = 'specifiedFlag';
    scbPcScenePanelManager.setIsEnableSpecifiedRectAutoSaveMap(key, true);
    key = scbPcScenePanelManager.createIsWindowRectAutoSaveKey(sceneInfo);
    expect(key).assertEqual('testBundleName' + 'testModuleName' + 'testAbilityName' + 'specifiedFlag');
  });
}

function updateExtendSubSessionTest() {
  it('updateExtendSubSession_01', Level.LEVEL0, (): void => {
    let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
    let testSession = sceneSessionManager.requestSceneSession(testSCBSceneInfo);
    let testPrimarySession: SCBSceneSession = new SCBSceneSession(testSession, testSCBSceneInfo);
    let oldScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    oldScreenProperty.screenId = 12;
    oldScreenProperty.width = 3120;
    oldScreenProperty.height = 1755;
    let testPtr : UIContext;
    let screenSession: screenSessionManager.ScreenSession = {
      screenId: 12,
      name: 'testScreen1',
      on: (type: string, callback: Function): void => {},
      setScreenRotationLocked: (isLocked: boolean): void => {},
      loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {},
      setTouchEnabled: (isTouchEnabled: boolean): void => {},
      getScreenUIContext: (): UIContext => {return testPtr; },
      displayGroupId: 0,
      destroyContent: (): void => {
        throw new Error('Function not implemented.');
      },
      releaseResource: (): void => {}
    };
    let scbScreenSession: SCBScreenSession = new SCBScreenSession(screenSession);
    scbScreenSession.scbScreenProperty = oldScreenProperty;
    let mocker: MockKit = new MockKit();
    let screenSessionManager = SCBScreenSessionManager.getInstance();
    let mockFunc: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenSession);
    when(mockFunc)(ArgumentMatchers.any).afterReturn(scbScreenSession);
    let newScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    newScreenProperty.screenId = 0;
    newScreenProperty.width = 3120;
    newScreenProperty.height = 2080;
    let specificSceneInfo: SCBSceneInfo =
      new SCBSceneInfo('testSpecificBundle', 'testSpecificModule', 'testSpecificAbility');
    let specificSession: SCBSpecificSession =
      new SCBSpecificSession(sceneSessionManager.requestSceneSession(specificSceneInfo), () => {});
    specificSession.screenId = 12;
    specificSession.currRect.setRectNum(0, 0, 3120, 1755);
    testPrimarySession.subSessionList.push(specificSession);
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(testPrimarySession,
      oldScreenProperty);
    scbPcScenePanelManager.updateExtendSubSession(containerSession, newScreenProperty, 12);
    mocker.clear(screenSessionManager);
    expect(specificSession.screenId).assertEqual(0);
    expect(specificSession.currRect.width.getPx()).assertEqual(3120);
    expect(specificSession.currRect.height.getPx()).assertEqual(2080);
  });
}

function updateContainerSessionDisplayInfoTest() {
  it('updateContainerSessionDisplayInfoTest_01', Level.LEVEL0, (): void => {
    let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
    let testSession = sceneSessionManager.requestSceneSession(testSCBSceneInfo);
    let testPrimarySession: SCBSceneSession = new SCBSceneSession(testSession, testSCBSceneInfo);
    let oldScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    oldScreenProperty.screenId = 12;
    oldScreenProperty.width = 3120;
    oldScreenProperty.height = 1755;
    let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(testPrimarySession,
      oldScreenProperty);
    let newScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    newScreenProperty.screenId = 0;
    newScreenProperty.width = 3120;
    newScreenProperty.height = 2080;
    scbPcScenePanelManager.updateContainerSessionDisplayInfo(containerSession, newScreenProperty);
    expect(containerSession.screenProperty.screenId).assertEqual(0);
    expect(containerSession.screenProperty.width).assertEqual(3120);
    expect(containerSession.screenProperty.height).assertEqual(2080);
  });
}

function getSpecificSessionListTest() {
  it('getSpecificSessionListTest_01', Level.LEVEL0, (): void => {
    let specificSessionMap: Map<number, SCBSpecificSceneSessionList> = new Map();
    let specificSessionList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
    let specificSceneInfo: SCBSceneInfo =
      new SCBSceneInfo('testSpecificBundle', 'testSpecificModule', 'testSpecificAbility');
    let specificSession: SCBSpecificSession =
      new SCBSpecificSession(sceneSessionManager.requestSceneSession(specificSceneInfo), () => {});
    specificSession.screenId = 0;
    specificSessionList.push(specificSession);
    specificSessionMap.set(0, specificSessionList);
    ReflectionUtils.setProperty(scbPcScenePanelManager, 'specificSessionMap', specificSessionMap);
    expect(scbPcScenePanelManager.getSpecificSessionList(0)).assertEqual(specificSessionList);
  });
}

function updateRectWithDpiChangeTest() {
  it('updateRectWithDpiChangeTest_01', Level.LEVEL0, (): void => {
    let screenDensityMap: Map<number, number> = new Map();
    ReflectionUtils.setProperty(scbPcScenePanelManager, 'screenDensityMap', screenDensityMap);
    let srcScreenId = 0;
    let targetScreenId = 12;
    let rect: SCBSessionRect = new SCBSessionRect(0, 0, 200, 200);
    scbPcScenePanelManager.updateRectWithDpiChange(rect, srcScreenId, targetScreenId);
    expect(rect.width.getPx()).assertEqual(200);
    expect(rect.height.getPx()).assertEqual(200);
    screenDensityMap.set(srcScreenId, 300);
    screenDensityMap.set(targetScreenId, 300);
    scbPcScenePanelManager.updateRectWithDpiChange(rect, srcScreenId, targetScreenId);
    expect(rect.width.getPx()).assertEqual(200);
    expect(rect.height.getPx()).assertEqual(200);
    screenDensityMap.set(targetScreenId, 150);
    scbPcScenePanelManager.updateRectWithDpiChange(rect, srcScreenId, targetScreenId);
    expect(rect.width.getPx()).assertEqual(100);
    expect(rect.height.getPx()).assertEqual(100);
  });
}

function registerGetIsPairSplitCallbackTest() {
  it('registerGetIsPairSplitCallbackTest_01', Level.LEVEL0, (): void => {
    let callback = () => { return true };
    expect(scbPcScenePanelManager.getIsPairSplit(12)).assertFalse();
    scbPcScenePanelManager.registerGetIsPairSplitCallback(callback, 12);
    expect(scbPcScenePanelManager.getIsPairSplit(12)).assertTrue();
  });
}

function unRegisterGetIsPairSplitCallbackTest() {
  it('unRegisterGetIsPairSplitCallbackTest_01', Level.LEVEL0, (): void => {
    let callback = () => { return true };
    scbPcScenePanelManager.registerGetIsPairSplitCallback(callback, 12);
    expect(scbPcScenePanelManager.getIsPairSplit(12)).assertTrue();
    scbPcScenePanelManager.unRegisterGetIsPairSplitCallback(12);
    expect(scbPcScenePanelManager.getIsPairSplit(12)).assertFalse();
  });
}

function getIsPairSplitTest() {
  it('getIsPairSplitTest_01', Level.LEVEL0, (): void => {
    let callback = () => { return true };
    scbPcScenePanelManager.registerGetIsPairSplitCallback(callback, 12);
    expect(scbPcScenePanelManager.getIsPairSplit(12)).assertTrue();
  });
}

function registerUIContextTest() {
  it('registerUIContextTest_01', Level.LEVEL0, (): void => {
    let context: UIContext = new UIContext();
    scbPcScenePanelManager.registerUIContext(context, 12);
    expect(scbPcScenePanelManager !== undefined).assertTrue();
  });
}

function unregisterUIContextTest() {
  it('unregisterUIContextTest_01', Level.LEVEL0, (): void => {
    scbPcScenePanelManager.unregisterUIContext(12);
    expect(scbPcScenePanelManager !== undefined).assertTrue();
  });
}

function registerAddListNotShowRecentCallbackTest() {
  it('registerAddListNotShowRecentCallbackTest_01', Level.LEVEL0, (): void => {
    let callback = () => {};
    scbPcScenePanelManager.registerAddListNotShowRecentCallback(callback, 12);
    expect(scbPcScenePanelManager !== undefined).assertTrue();
  });
}

function unRegisterAddListNotShowRecentCallbackTest() {
  it('unRegisterAddListNotShowRecentCallbackTestTest_01', Level.LEVEL0, (): void => {
    scbPcScenePanelManager.unRegisterAddListNotShowRecentCallback(12);
    expect(scbPcScenePanelManager !== undefined).assertTrue();
  });
}

function registerRemoveListNotShowRecentCallbackTest() {
  it('registerRemoveListNotShowRecentCallbackTest_01', Level.LEVEL0, (): void => {
    let callback = () => {};
    scbPcScenePanelManager.registerRemoveListNotShowRecentCallback(callback, 12);
    expect(scbPcScenePanelManager !== undefined).assertTrue();
  });
}

function unRegisterRemoveListNotShowRecentCallbackTest() {
  it('unRegisterRemoveListNotShowRecentCallbackTest_01', Level.LEVEL0, (): void => {
    scbPcScenePanelManager.unRegisterRemoveListNotShowRecentCallback(12);
    expect(scbPcScenePanelManager !== undefined).assertTrue();
  });
}

function registerSceneHiddenModeVisChangeCallbackTest() {
  it('registerSceneHiddenModeVisChangeCallback_01', Level.LEVEL0, (): void => {
    let callback = () => {};
    scbPcScenePanelManager.registerSceneHiddenModeVisChangeCallback(callback, 12);
    expect(scbPcScenePanelManager !== undefined).assertTrue();
  });
}

function unRegisterSceneHiddenModeVisChangeCallbackTest() {
  it('unRegisterSceneHiddenModeVisChangeCallbackTest_01', Level.LEVEL0, (): void => {
    scbPcScenePanelManager.unRegisterSceneHiddenModeVisChangeCallback(12);
    expect(scbPcScenePanelManager !== undefined).assertTrue();
  });
}

function moveHiddenSessionToAnotherScreenForDisplayTest() {
  it('moveHiddenSessionToAnotherScreenForDisplayTest_01', Level.LEVEL0, (): void => {
    let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
    testSCBSceneInfo.screenId = 1;
    let testSession = sceneSessionManager.requestSceneSession(testSCBSceneInfo);
    let testPrimarySCBSceneSession: SCBSceneSession = new SCBSceneSession(testSession, testSCBSceneInfo);
    let testSCBScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    let testContainer: SCBSceneContainerSession = new SCBSceneContainerSession(testPrimarySCBSceneSession, testSCBScreenProperty);
    scbPcScenePanelManager.registerAddListNotShowRecentCallback((
      containerSession: SCBSceneContainerSession) => {}, 1);
    scbPcScenePanelManager.registerRemoveListNotShowRecentCallback((
      containerSession: SCBSceneContainerSession) => {}, 1);
    scbPcScenePanelManager.moveHiddenSessionToAnotherScreenForDisplay(testContainer, 1, 0);
    scbPcScenePanelManager.unRegisterAddListNotShowRecentCallback(1);
    scbPcScenePanelManager.unRegisterRemoveListNotShowRecentCallback(1);
    expect(testContainer.primarySession!.sceneInfo.screenId).assertEqual(0);
  });
}

function registerDisplayChangeCallbackTest() {
  it('registerDisplayChangeCallbackTest_01', Level.LEVEL0, (): void => {
    let callback = () => {};
    scbPcScenePanelManager.registerDisplayChangeCallback(callback, 12);
    expect(scbPcScenePanelManager !== undefined).assertTrue();
  });
}

function unregisterDisplayChangeCallbackTest() {
  it('unregisterDisplayChangeCallbackTest_01', Level.LEVEL0, (): void => {
    scbPcScenePanelManager.unregisterDisplayChangeCallback(12);
    expect(scbPcScenePanelManager !== undefined).assertTrue();
  });
}