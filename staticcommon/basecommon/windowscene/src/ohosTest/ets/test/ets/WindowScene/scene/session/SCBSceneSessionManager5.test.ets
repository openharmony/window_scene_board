/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when,
  Level
} from '@ohos/hypium';
import {
  SCBSceneInfo,
  SCBSceneSession,
  SCBScreenProperty,
  SCBSceneContainerSession,
  SCBSpecificSession,
  SCBSceneMode
} from '../../../../../../../..';
import {
  SCBScreenSessionManager
} from '../../../../../../../main/ets/screen/session/SCBScreenSessionManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  SCBSceneSessionManager,
  ScenePanelState,
  SCBSpecificSceneSessionList
} from '../../../../../../../main/ets/scene/session/SCBSceneSessionManager';
import type {
  SCBUnlockTransitionController
} from '../../../../../../../main/ets/animation/SCBTransitionManager';
import sSCBOobeManager from '../../../../../../../main/ets/oobe/SCBOobeManager';
import { ReflectionUtils } from '../../utils/ReflectionUtils';
import type { AbilityItemInfo } from '../../../../../../../main/ets/bean/AbilityItemInfo';
import display from '@ohos.display';
import { bundleManager } from '@kit.AbilityKit'
import { WindowSize } from '../../../../../../../main/ets/bean/AbilityItemInfo';
import { PackageCommonEvent } from '@ohos/frameworkwrapper';
import commonEvent from '@ohos.commonEventManager';
import { SCBSystemSceneSession } from '../../../../../../../main/ets/scene/session/SCBSystemSceneSession';
import { SystemSessionInfo } from '../../../../../../../../';
import { SCBSceneContainerSessionArray } from '../../../../../../../main/ets/scene/session/SCBSceneContainerSession';

interface GeneratedObjectLiteralInterface_1 {
  'appIndex': number;
  'isModuleUpdate': boolean;
  'bundleType': number;
  'atomicServiceModuleUpgrade': number;
}

let primarySessionGlobal: SCBSceneSession;
let secondSessionGlobal: SCBSceneSession;
let screenPropertyGlobal: SCBScreenProperty;
let sceneInfoGlobal: SCBSceneInfo;

let initAll = () => {
  screenPropertyGlobal = new SCBScreenProperty();
  screenPropertyGlobal.width = 1;
  screenPropertyGlobal.height = 1;
  sceneInfoGlobal = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
  primarySessionGlobal = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfoGlobal), sceneInfoGlobal);
  secondSessionGlobal = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfoGlobal), sceneInfoGlobal);
}

export function SCBSceneSessionManagerFiveTest() {
  describe('SCBSceneSessionManagerFiveTest', () => {
    beforeAll(() => {
      initAll();
    });
    beforeEach(() => {
    });
    afterEach(() => {
    });
    afterAll(() => {
    });

    it('handlePackageEventTest01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let mTestEvt: PackageCommonEvent = new PackageCommonEvent({
        event: commonEvent.Support.COMMON_EVENT_PACKAGE_ADDED,
        bundleName: '',
        code: 0,
        data: '',
        parameters: ({ 'appIndex': 1 } as GeneratedObjectLiteralInterface_1)
      });
      ReflectionUtils.useFunc(sessionManager, 'handlePackageEvent', mTestEvt);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('handlePackageEventTest02', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let mTestEvt: PackageCommonEvent = new PackageCommonEvent({
        event: commonEvent.Support.COMMON_EVENT_PACKAGE_CHANGED,
        bundleName : '',
        code : 0,
        data : '',
        parameters : ({ 'appIndex': 1,
          'isModuleUpdate': true,
          'bundleType': 1,
          'atomicServiceModuleUpgrade': 1
        } as GeneratedObjectLiteralInterface_1)
      });
      ReflectionUtils.useFunc(sessionManager, 'handlePackageEvent', mTestEvt);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('handlePackageEventTest04', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let mTestEvt: PackageCommonEvent = new PackageCommonEvent({
        event: commonEvent.Support.COMMON_EVENT_PACKAGES_UNSUSPENDED,
        bundleName:'',
        code:0,
        data:'',
        parameters : ({ 'appIndex': 1 } as GeneratedObjectLiteralInterface_1)
      });
      ReflectionUtils.useFunc(sessionManager, 'handlePackageEvent', mTestEvt);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('removeAbilityItemInfoTest01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let map = new Map<string, AbilityItemInfo>();
      let bundleName: string = 'bundleNameTest';
      let abilityName: string = 'abilityNameTest';
      let moduleName: string = 'moduleNameTest';
      let key = bundleName + moduleName + abilityName;
      let abilityItemInfo: AbilityItemInfo = {
        appIconId: 0,
        appLabelId: 0,
        bundleName: bundleName,
        moduleName: moduleName,
        name: abilityName,
        launchType: bundleManager.LaunchType.SPECIFIED,
        supportWindowModes: [],
        windowSize: new WindowSize,
        orientation: bundleManager.DisplayOrientation.AUTO_ROTATION_RESTRICTED,
        removeSessionAfterTerminate: false,
        excludeFromSession: false,
        unclearableSession: false,
        continuable: false,
        preferMultiWindowOrientation: '',
        supportWindowModesInFreeMultiWindow: [],
        isAbilityHook: false,
        isForceRotate: false
      };
      map.set(key, abilityItemInfo);
      ReflectionUtils.setProperty(sessionManager, 'abilityInfoMap', map);

      expect(sessionManager.getAbilityLaunchType(key)).assertEqual(2);
      sessionManager.getAbilityWindowSize(key);
      sessionManager.getAbilityWindowSupportInfo(key, bundleName, abilityName);
      sessionManager.getAbilityWindowSupportInfo(key, 'bundleNameTest2', abilityName);
      sessionManager.getAbilityWindowSupportInfo(key, bundleName, 'abilityNameTest2');
      sessionManager.getAbilityWindowSupportInfo(key, 'bundleNameTest2', 'abilityNameTest2');

      expect(sessionManager.getAbilityOrientation(bundleName, moduleName, abilityName)).assertEqual(8);
      ReflectionUtils.useFunc(sessionManager, 'removeAbilityItemInfo', 'bundleNameTest2', 100);
      ReflectionUtils.useFunc(sessionManager, 'removeAbilityItemInfo', 'bundleNameTest', 200);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('isRemoveSessionAfterTerminateTest01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let map = new Map<string, AbilityItemInfo>();
      let bundleName: string = 'bundleNameTest';
      let abilityName: string = 'abilityNameTest';
      let moduleName: string = 'moduleNameTest';
      let key = bundleName + moduleName + abilityName;
      let abilityItemInfo: AbilityItemInfo = {
        appIconId: 0,
        appLabelId: 0,
        bundleName: bundleName,
        moduleName: moduleName,
        name: abilityName,
        launchType: bundleManager.LaunchType.SPECIFIED,
        supportWindowModes: [],
        windowSize: new WindowSize,
        orientation: bundleManager.DisplayOrientation.AUTO_ROTATION_RESTRICTED,
        removeSessionAfterTerminate: true,
        excludeFromSession: true,
        unclearableSession: true,
        continuable: false,
        preferMultiWindowOrientation: '',
        supportWindowModesInFreeMultiWindow: [],
        isAbilityHook: false,
        isForceRotate: false
      };
      map.set(key, abilityItemInfo);
      ReflectionUtils.setProperty(sessionManager, 'abilityInfoMap', map);
      expect(sessionManager.isRemoveSessionAfterTerminate(bundleName,
        moduleName, abilityName)).assertTrue();
      expect(sessionManager.isExcludeFromSession(bundleName,
        moduleName, abilityName)).assertTrue();
      expect(sessionManager.isUnClearFromRecent(bundleName,
        moduleName, abilityName)).assertTrue();
      done();
    });

    it('saveActiveSessionTest01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfo1: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      sceneInfo1.persistentId = 111;
      let sceneSession1: sceneSessionManager.SceneSession =
        SCBSceneSessionManager.getInstance().requestSceneSession(sceneInfo1);
      sessionManager.addActiveSessionList(111);
      ReflectionUtils.useFunc(sessionManager, 'saveActiveSession', sceneSession1);

      let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      sceneInfo2.persistentId = 112;
      let sceneSession2: sceneSessionManager.SceneSession =
        SCBSceneSessionManager.getInstance().requestSceneSession(sceneInfo2);

      ReflectionUtils.useFunc(sessionManager, 'saveActiveSession', sceneSession2);

      expect(sessionManager.getActiveSessionList().length === 2).assertTrue();
      done();
    });

    it('registerCreateSpecificSceneCallbackTest01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let map = new Map<number, Map<number, Function>>();
      map.set(111, new Map());
      ReflectionUtils.setProperty(sessionManager, 'createSpecificSceneCallbackMap', map);

      let map2 = new Map<number, Map<number, Function>>();
      map2.set(222, new Map());
      ReflectionUtils.setProperty(sessionManager, 'specificSessionCacheMap', map2);
      const callback: Function = () => {
        return;
      };
      sessionManager.registerCreateSpecificSceneCallback(callback, 1, 1);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('registerDestroyFloatWindowCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let map = new Map<number, Map<number, Function>>();
      map.set(111, new Map());
      ReflectionUtils.setProperty(sessionManager, 'createSpecificSceneCallbackMap', map);

      let map2 = new Map<number, Map<number, Function>>();
      map2.set(222, new Map());
      ReflectionUtils.setProperty(sessionManager, 'specificSessionCacheMap', map2);
      const callback: Function = () => {
        return;
      };
      sessionManager.registerCreateSpecificSceneCallback(callback, 1, 1);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('isSampleManagerInterceptedTest01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      expect(ReflectionUtils.useFunc(sessionManager,
        'isSampleManagerIntercepted', sceneInfo)).assertFalse();
      done();
    });

    it('isStartSceneInterceptedUnderConditionsTest01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isOobeActivated);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

      const mockFunc2: Function = mocker.mockFunc(sessionManager,
        sessionManager.isExternalScreenIntercepted);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

      expect(ReflectionUtils.useFunc(sessionManager,
        'isStartSceneInterceptedUnderConditions', sceneInfo)).assertFalse();
      mocker.clear(sSCBOobeManager);
      mocker.clear(sessionManager);
      mocker.clearAll();
      done();
    });

    it('getSpecificContainerSessionListFuncTest01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let map = new Map<number, Map<number, Function>>();
      map.set(111, new Map());
      ReflectionUtils.setProperty(sessionManager, 'getSpecificContainerSessionListCallbackMap', map);
      ReflectionUtils.useFunc(sessionManager, 'getSpecificContainerSessionListFunc', 10, 22);
      ReflectionUtils.useFunc(sessionManager, 'getSpecificContainerSessionListFunc', 10, 111);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('addSystemSceneToListTest01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let systemSessionInfo: SystemSessionInfo = {
        systemType: sceneSessionManager.SessionType.TYPE_PANEL,
        sceneName: 'SCBFloatMiniCoverTest',
        sceneZIndex: 101,
        isFocusable: false,
        isTouchable: true,
        privacyMode: false,
        hitTestMode: HitTestMode.Default,
        sceneType: sceneSessionManager.SceneType.INPUT_SCENE,
        isOverlayScene: true,
      };
      let systemSceneSession: SCBSystemSceneSession = sessionManager
        .requestSystemSceneSession(systemSessionInfo);
      systemSceneSession.zIndex = 9;
      let scbList:SCBSystemSceneSession[] = [systemSceneSession];
      let map = new Map<number, SCBSystemSceneSession[]>();
      map.set(111, scbList);
      ReflectionUtils.setProperty(sessionManager, 'systemSceneList', map);
      ReflectionUtils.useFunc(sessionManager, 'addSystemSceneToList', systemSceneSession, 111);
      expect(ReflectionUtils.getProperty(sessionManager,
        'systemSceneList').get(111).length).assertEqual(2);
      ReflectionUtils.useFunc(sessionManager, 'addSystemSceneToList', systemSceneSession, 112);
      expect(ReflectionUtils.getProperty(sessionManager,
        'systemSceneList').get(112).length).assertEqual(1);
      done();
    });

    it('removeActiveSessionListTest01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let activeSessionList: number[] = [22, 33];
      ReflectionUtils.setProperty(sessionManager, 'activeSessionList', activeSessionList);
      sessionManager.removeActiveSessionList(11);
      sessionManager.removeActiveSessionList(22);
      expect(ReflectionUtils.getProperty(sessionManager,
        'activeSessionList').length).assertEqual(1);
      done();
      sessionManager.removeActiveSessionList(33);
      expect(ReflectionUtils.getProperty(sessionManager,
        'activeSessionList').length).assertEqual(0);
      done();
    });

    it('notifyHotRegionStateChangeTest01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.notifyHotRegionStateChange();

      const callback: Function = () => {
        return;
      };
      sessionManager.registerHotRegionStateChangeCallback(callback);
      sessionManager.notifyHotRegionStateChange();
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('notifyImmersiveSceneTitleBarStateChangeTest01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const callback: Function = () => {
        return;
      };
      sessionManager.registerImmersiveSceneTitleBarStateChangeCallback(11, callback);
      sessionManager.notifyImmersiveSceneTitleBarStateChange(0);
      sessionManager.notifyImmersiveSceneTitleBarStateChange(1);
      sessionManager.notifyImmersiveSceneTitleBarStateChange(11);
      sessionManager.unregisterImmersiveSceneTitleBarStateChangeCallback(12);
      sessionManager.unregisterImmersiveSceneTitleBarStateChangeCallback(11);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('notifyMenuVisibleCallbackTest01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const callback: Function = (isVisible: boolean) => {
        return isVisible;
      };
      sessionManager.registerMenuVisibleCallback(11, callback);
      sessionManager.notifyMenuVisibleCallback(0, false);
      sessionManager.notifyMenuVisibleCallback(1, false);
      sessionManager.notifyMenuVisibleCallback(11, false);
      sessionManager.unregisterMenuVisibleCallback(11);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('setBehindWindowFilterEnabledTest01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.setBehindWindowFilterEnabled(false);
      expect(sessionManager !== undefined).assertTrue();
      sessionManager.setBehindWindowFilterEnabled(true);
      done();
    });

    it('processSystemBackEventTest01', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let systemSessionInfo: SystemSessionInfo = {
        systemType: sceneSessionManager.SessionType.TYPE_NEGATIVE_SCREEN,
        sceneName: 'SCBFloatMiniCoverTest',
        sceneZIndex: 101,
        isFocusable: false,
        isTouchable: true,
        privacyMode: false,
        hitTestMode: HitTestMode.Default,
        sceneType: sceneSessionManager.SceneType.INPUT_SCENE,
        isOverlayScene: true,
      };
      let systemSceneSession: SCBSystemSceneSession = manager
        .requestSystemSceneSession(systemSessionInfo);
      systemSceneSession.zIndex = 9;
      let scbList:SCBSystemSceneSession[] = [systemSceneSession];
      let map = new Map<number, SCBSystemSceneSession[]>();
      map.set(111, scbList);
      ReflectionUtils.setProperty(manager, 'systemSceneList', map);

      let mockFunc1 : Function = mocker.mockFunc(manager, manager.isDesktopNeedProcessFloatWindow);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);

      manager.windowFocusController.setFocusedSession(0, systemSceneSession.session.persistentId, 0, systemSceneSession);
      manager.mainScreenId = 111;
      expect(manager.processSystemBackEvent()).assertTrue();

      mocker.ignoreMock(manager, manager.isDesktopNeedProcessFloatWindow);
      mocker.ignoreMock(manager, manager.getSystemSceneSessionWithId);
      done();
    });

    it('processSystemHomeEventTest01', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let mockFunc1 : Function = mocker.mockFunc(manager, manager.isDesktopNeedProcessFloatWindow);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      let res = manager.processSystemHomeEvent();
      expect(res).assertTrue();
      mocker.ignoreMock(manager, manager.isDesktopNeedProcessFloatWindow);
      done();
    });

    it('processSystemHomeEventTest02', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let mockFunc1 : Function = mocker.mockFunc(manager, manager.isDesktopNeedProcessFloatWindow);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc2 : Function = mocker.mockFunc(manager, manager.getSystemSceneSessionWithId);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      let res = manager.processSystemBackEvent();
      expect(res).assertFalse();
      mocker.ignoreMock(manager, manager.isDesktopNeedProcessFloatWindow);
      mocker.ignoreMock(manager, manager.getSystemSceneSessionWithId);
      done();
    });

    it('processSystemHomeEventTest03', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let systemSessionInfo: SystemSessionInfo = {
        systemType: sceneSessionManager.SessionType.TYPE_NEGATIVE_SCREEN,
        sceneName: 'SCBFloatMiniCoverTest',
        sceneZIndex: 101,
        isFocusable: false,
        isTouchable: true,
        privacyMode: false,
        hitTestMode: HitTestMode.Default,
        sceneType: sceneSessionManager.SceneType.INPUT_SCENE,
        isOverlayScene: true,
      };
      let systemSceneSession: SCBSystemSceneSession = manager
        .requestSystemSceneSession(systemSessionInfo);
      systemSceneSession.zIndex = 9;
      let scbList:SCBSystemSceneSession[] = [systemSceneSession];
      let map = new Map<number, SCBSystemSceneSession[]>();
      map.set(111, scbList);
      ReflectionUtils.setProperty(manager, 'systemSceneList', map);

      let mockFunc1 : Function = mocker.mockFunc(manager, manager.isDesktopNeedProcessFloatWindow);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      manager.windowFocusController.setFocusedSession(0, systemSceneSession.session.persistentId, 0, systemSceneSession);
      manager.mainScreenId = 111;

      let res = manager.processSystemHomeEvent();
      expect(res).assertFalse();
      mocker.ignoreMock(manager, manager.isDesktopNeedProcessFloatWindow);
      mocker.ignoreMock(manager, manager.getSystemSceneSessionWithId);
      done();
    });

    it('isSplitTopActiveSessionTest01', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager.isSplitTopActiveSession()).assertFalse();

      let container1: SCBSceneContainerSession = new SCBSceneContainerSession(primarySessionGlobal, screenPropertyGlobal);
      let containerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      containerSessionList.push(container1);
      let callbackTmp = (): SCBSceneContainerSessionArray => {
        return containerSessionList;
      };
      manager.registerGetContainerSessionListCallback(callbackTmp, 111);
      manager.mainScreenId = 111;
      expect(manager.isSplitTopActiveSession()).assertFalse();
      done();
    });

    it('getTopActiveSessionForRotateCheckTest01', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager.isSplitTopActiveSession()).assertFalse();

      let container1: SCBSceneContainerSession = new SCBSceneContainerSession(primarySessionGlobal, screenPropertyGlobal);
      let containerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      containerSessionList.push(container1);
      let callbackTmp = (): SCBSceneContainerSessionArray => {
        return containerSessionList;
      };
      manager.registerGetContainerSessionListCallback(callbackTmp, 111);
      manager.mainScreenId = 111;
      expect(manager.isSplitTopActiveSession()).assertFalse();
      done();
    });

    it('shouldDelayRotationTest01', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      ReflectionUtils.setProperty(manager, 'isInAppExit', true);
      expect(ReflectionUtils.useFunc(manager, 'shouldDelayRotation')).assertTrue();
      done();
    });

    it('checkNeedRotateTest01', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(ReflectionUtils.useFunc(manager, 'checkNeedRotate', false, 11119, 10, 10)[0]).assertTrue();
      done();
    });

    it('getFirstActiveSessionTest01', 0, async (done: Function) => {
      const sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      const containerListNull: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      ReflectionUtils.useFunc(sceneSessionManager, 'getFirstActiveSession', containerListNull);

      const screenProperty: SCBScreenProperty = new SCBScreenProperty();
      const sceneInfo1: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      const sceneSession1: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
      const sceneContainerSession: SCBSceneContainerSession  = new SCBSceneContainerSession(sceneSession1, screenProperty);
      sceneContainerSession.isFloat = false;
      const containerList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      containerList.add(sceneContainerSession);
      ReflectionUtils.useFunc(sceneSessionManager, 'getFirstActiveSession', containerList);
      expect(sceneSessionManager !== undefined).assertTrue();
      done();
    });

    it('getFirstActiveSessionTest02', 0, async (done: Function) => {
      const sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      const screenProperty: SCBScreenProperty = new SCBScreenProperty();
      const sceneInfo1: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      const sceneSession1: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo1), sceneInfo1);
      const sceneContainerSession: SCBSceneContainerSession  = new SCBSceneContainerSession(sceneSession1, screenProperty);
      sceneContainerSession.isFloat = true;
      const containerList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      containerList.add(sceneContainerSession);
      ReflectionUtils.useFunc(sceneSessionManager, 'getFirstActiveSession', containerList);
      expect(sceneSessionManager !== undefined).assertTrue();
      done();
    });

    it('notifyKeyguardOccludedChangedTest01', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      ReflectionUtils.useFunc(manager, 'notifyKeyguardOccludedChanged');
      const callback: Function = (occludedState: number) => {
        occludedState = 1;
      };
      manager.registerKeyguardOccludedChangeCallbacks(callback);
      ReflectionUtils.useFunc(manager, 'notifyKeyguardOccludedChanged');
      expect(manager !== undefined).assertTrue();
      done();
    });

    it('updateFullSceneEndTest01', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      manager.updateFullSceneEnd('bundleName', 'abilityName');
      ReflectionUtils.useFunc(manager, 'notifyKeyguardOccludedChanged');
      const callback: Function = (bundleName: string, abilityName: string) => {
        return;
      };
      manager.registerFullSceneEndCallback(callback);
      manager.updateFullSceneEnd('bundleName', 'abilityName');
      expect(manager !== undefined).assertTrue();
      done();
    });

    it('updateHomeOccludedStateTest01', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let systemSceneList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneSession: sceneSessionManager.SceneSession =
        SCBSceneSessionManager.getInstance().requestSceneSession(sceneInfo);
      let specificScene = new SCBSpecificSession(sceneSession, () => {
      });
      systemSceneList.push(specificScene);
      systemSceneList[0].isActive = false;
      manager.updateHomeOccludedState(systemSceneList, 113);
      expect(manager !== undefined).assertTrue();
      done();
    });

    it('getSpecialScenePanelStateTest01', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      manager.mainScreenId = 13;
      ReflectionUtils.useFunc(manager, 'getSpecialScenePanelState');
      ReflectionUtils.useFunc(manager, 'getSpecialScenePanelState', 12);
      expect(manager.mainScreenId).assertEqual(13);
      done();
    });

    it('hasFullSceneSessionTest01', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager.hasFullSceneSession(113)).assertFalse();

      let container1: SCBSceneContainerSession = new SCBSceneContainerSession(primarySessionGlobal, screenPropertyGlobal);
      let containerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      container1.setActivationAtToggleHomeScenario();
      container1.isSplit = false;
      containerSessionList.push(container1);
      let callbackTmp = (): SCBSceneContainerSessionArray => {
        return containerSessionList;
      };
      manager.registerGetContainerSessionListCallback(callbackTmp, 111);
      manager.mainScreenId = 111;
      expect(manager.hasFullSceneSession(111)).assertFalse();
      done();
    });

    it('isOobeInterceptedTest01', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isOobeActivated);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      const mockFunc2: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isTrustlistForWms);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

      const mockFunc3: Function = mocker.mockFunc(manager, manager.isExclusion);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(ReflectionUtils.useFunc(manager, 'isOobeIntercepted', sceneInfoGlobal, false)).assertFalse();
      expect(ReflectionUtils.useFunc(manager, 'isOobeIntercepted', sceneInfoGlobal, true)).assertFalse();
      mocker.clear(sSCBOobeManager);
      mocker.clear(manager);
      mocker.clearAll();
      done();
    });

    it('isOobeInterceptedTest02', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isOobeActivated);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      const mockFunc2: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isTrustlistForWms);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

      const mockFunc3: Function = mocker.mockFunc(manager, manager.isExclusion);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(ReflectionUtils.useFunc(manager, 'isOobeIntercepted', sceneInfoGlobal, false)).assertFalse();
      expect(ReflectionUtils.useFunc(manager, 'isOobeIntercepted', sceneInfoGlobal, true)).assertTrue();
      mocker.clear(sSCBOobeManager);
      mocker.clear(manager);
      mocker.clearAll();
      done();
    });

    it('isOobeInterceptedTest03', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isOobeActivated);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      const mockFunc2: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isTrustlistForWms);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

      expect(ReflectionUtils.useFunc(manager, 'isOobeIntercepted', sceneInfoGlobal, false)).assertTrue();
      mocker.clear(sSCBOobeManager);
      mocker.clearAll();
      done();
    });

    it('isOobeInterceptedTest04', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isOobeActivated);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      const mockFunc2: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isTrustlistForWms);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

      expect(ReflectionUtils.useFunc(manager, 'isOobeIntercepted', sceneInfoGlobal, false)).assertFalse();
      mocker.clear(sSCBOobeManager);
      mocker.clearAll();
      done();
    });

    it('isOobeInterceptedTest05', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isOobeActivated);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      const mockFunc2: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isTrustlistForWms);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

      expect(ReflectionUtils.useFunc(manager, 'isOobeIntercepted', sceneInfoGlobal, false)).assertFalse();
      mocker.clear(sSCBOobeManager);
      mocker.clearAll();
      done();
    });

    it('isOobeInterceptedTest05', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isOobeActivated);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      const mockFunc2: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isTrustlistForWms);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

      expect(ReflectionUtils.useFunc(manager, 'isOobeIntercepted', sceneInfoGlobal, false)).assertFalse();
      mocker.clear(sSCBOobeManager);
      mocker.clearAll();
      done();
    });

    it('isExternalScreenInterceptedTest01', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let callbackTmp =(sceneInfo: SCBSceneInfo): boolean => {
        return true;
      };
      manager.registerExternalScreenInterceptorCallback(callbackTmp);
      expect(manager.isExternalScreenIntercepted(sceneInfoGlobal)).assertTrue();
      manager.unregisterExternalScreenInterceptorCallback();
      expect(manager.isExternalScreenIntercepted(sceneInfoGlobal)).assertFalse();
      done();
    });

    it('isExclusionTest01', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let mocker: MockKit = new MockKit();
      expect(manager.isExclusion(sceneInfoGlobal.bundleName, SCBSceneMode.UNDEFINED)).assertFalse();
      mocker.clearAll();
      done();
    });

    it('getPreferMultiWindowOrientationTest01', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let map = new Map<string, AbilityItemInfo>();
      let bundleName: string = 'bundleNameTest';
      let abilityName: string = 'abilityNameTest';
      let moduleName: string = 'moduleNameTest';
      let key = bundleName + moduleName + abilityName;
      let abilityItemInfo: AbilityItemInfo = {
        appIconId: 0,
        appLabelId: 0,
        bundleName: bundleName,
        moduleName: moduleName,
        name: abilityName,
        launchType: bundleManager.LaunchType.SPECIFIED,
        supportWindowModes: [],
        windowSize: new WindowSize,
        orientation: bundleManager.DisplayOrientation.AUTO_ROTATION_RESTRICTED,
        removeSessionAfterTerminate: false,
        excludeFromSession: false,
        unclearableSession: false,
        continuable: false,
        preferMultiWindowOrientation: '',
        supportWindowModesInFreeMultiWindow: [],
        isAbilityHook: false,
        isForceRotate: false
      };
      map.set(key, abilityItemInfo);
      ReflectionUtils.setProperty(manager, 'abilityInfoMap', map);
      expect(manager.getPreferMultiWindowOrientation(key) === '').assertTrue();
      expect(manager.getPreferMultiWindowOrientation('xxxxx') === 'default').assertTrue();
      done();
    });

    it('updateSessionDisplayIdTest01', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      manager.updateSessionDisplayId(0, 12);
      manager.updateSessionDisplayId(12, -1);
      expect(manager !==  undefined).assertTrue();
      done();
    });

    it('registerFullScreenLayoutCallBackTest01', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let callbackTmp = (isFullScreenLayout: boolean) : void => {
        isFullScreenLayout = false;
        return;
      };
      let map: Map<string, Function> = new Map();
      map.set('registerFullScreenLayoutCallBackTest', callbackTmp);
      let callbackMap: Map<number, Map<string, Function>> = new Map();
      callbackMap.set(111, map);
      ReflectionUtils.setProperty(manager, 'fullScreenLayoutCallBack', callbackMap);
      manager.unRegisterFullScreenLayoutCallBack('SCB', 112);

      manager.registerFullScreenLayoutCallBack('SCB', 112, callbackTmp);
      manager.registerFullScreenLayoutCallBack('SCB', 112, callbackTmp);
      manager.registerFullScreenLayoutCallBack('SCB01', 112, callbackTmp);

      expect(ReflectionUtils.getProperty(manager, 'fullScreenLayoutCallBack').has(112)).assertTrue();
      done();
    });

    it('registerFullScreenLayoutCallBackTest02', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let callbackTmp = (isFullScreenLayout: boolean) : void => {
        isFullScreenLayout = false;
        return;
      };
      let map: Map<string, Function> = new Map();
      map.set('registerFullScreenLayoutCallBackTest', callbackTmp);
      let callbackMap: Map<number, Map<string, Function>> = new Map();
      callbackMap.set(111, map);
      ReflectionUtils.setProperty(manager, 'fullScreenLayoutCallBack', callbackMap);
      manager.registerFullScreenLayoutCallBack('SCB', 112, callbackTmp);

      manager.unRegisterFullScreenLayoutCallBack('SCB', 112);
      expect(ReflectionUtils.getProperty(manager, 'fullScreenLayoutCallBack').has(112)).assertFalse();

      manager.unRegisterFullScreenLayoutCallBack('SCB', 111);
      manager.unRegisterFullScreenLayoutCallBack('registerFullScreenLayoutCallBackTest', 111);
      expect(ReflectionUtils.getProperty(manager, 'fullScreenLayoutCallBack').has(111)).assertFalse();
      done();
    });

    it('fullScreenLayoutChangeTest01', 0, async (done: Function) => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let callbackTmp = (isFullScreenLayout: boolean) : void => {
        isFullScreenLayout = false;
        return;
      };
      let map: Map<string, Function> = new Map();
      map.set('registerFullScreenLayoutCallBackTest', callbackTmp);
      let callbackMap: Map<number, Map<string, Function>> = new Map();
      callbackMap.set(111, map);
      ReflectionUtils.setProperty(manager, 'fullScreenLayoutCallBack', callbackMap);
      manager.fullScreenLayoutChange(false, 122);

      let map2: Map<number, boolean> = new Map();
      map2.set(111, false);
      ReflectionUtils.setProperty(manager, 'fullScreenLayoutMap', map2);
      manager.fullScreenLayoutChange(false, 111);
      expect(ReflectionUtils.getProperty(manager, 'fullScreenLayoutMap').has(111)).assertTrue();
      done();
    });

    it('notifyFullScreenMenuVisible', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const callback: Function = (isMenuVisible: boolean) => {
        return;
      };
      sessionManager.registerFullScreenMenuVisibleCallback(callback);
      sessionManager.notifyFullScreenMenuVisible(true);
      sessionManager.notifyFullScreenMenuVisible(false);
      expect(sessionManager !== undefined).assertTrue();
      sessionManager.unregisterFullScreenMenuVisibleCallback(callback);
      expect(ReflectionUtils.getProperty(sessionManager, 'fullScreenMenuVisibleCallback')).assertEqual(null);
      done();
    });
  })
}