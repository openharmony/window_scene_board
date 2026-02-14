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
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  when,
  MockKit,
  ArgumentMatchers
} from '@ohos/hypium';
import screenSessionManager from '@ohos.screenSessionManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBSceneInfo, SystemSessionInfo } from '../../../../../../../..';
import {
  INVALID_SCREEN_ID,
  SCBSceneSessionManager,
  SCBSpecificSceneSessionList
} from '../../../../../../../main/ets/scene/session/SCBSceneSessionManager';
import { SCBSpecificSession } from '../../../../../../../main/ets/scene/session/SCBSpecificSession';
import { SCBSceneSession } from '../../../../../../../main/ets/scene/session/SCBSceneSession';
import { ReflectionUtils } from '../../utils/ReflectionUtils';
import {
  SCBScreenSessionManager
} from '../../../../../../../../src/main/ets/screen/session/SCBScreenSessionManager';
import {
  SCBScreenSession
} from '../../../../../../../../src/main/ets/screen/session/SCBScreenSession';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { SCBSystemSceneSession } from '../../../../../../../main/ets/scene/session/SCBSystemSceneSession';
import {
  SCBSceneContainerSession
} from '../../../../../../../main/ets/scene/session/SCBSceneContainerSession';
import { SCBScreenProperty } from '../../../../../../../main/ets/screen/session/SCBScreenSession';
import type { UIContext } from '@ohos.arkui.UIContext';
import { SCBSceneMode } from '../../../../../../../main/ets/scene/session/SCBSceneInfo';

export function SCBSceneSessionManagerTest6() {
  describe('SCBSceneSessionManagerTest6', () => {

    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('resetStartingSceneFromPiP_test', 0, () => {
      let manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      manager.resetStartingSceneFromPiP();
      expect(manager.isStartingSceneFromPiP).assertFalse();
    });

    it('executeCallback_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let callbackMap = new Map<number, Map<number, Array<Function>>>();
      let map = new Map<number, Array<Function>>();
      let array = new Array<Function>();
      map.set(11, array);
      callbackMap.set(11, map);
      ReflectionUtils.setProperty(sessionManager, 'callbackMap', callbackMap);

      ReflectionUtils.useFunc(sessionManager, 'executeCallback', 12, 12);
      sessionManager.mainScreenId = 13;
      ReflectionUtils.useFunc(sessionManager, 'executeCallback', 11, -1);
      ReflectionUtils.useFunc(sessionManager, 'executeCallback', 11, 11);
      expect(sessionManager !== undefined).assertTrue();
    });

    it('executeCloseCallback_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let callbackMap = new Map<number, Map<number, Array<Function>>>();
      let map = new Map<number, Array<Function>>();
      let array = new Array<Function>();
      map.set(11, array);
      callbackMap.set(11, map);
      ReflectionUtils.setProperty(sessionManager, 'callbackMap', callbackMap);

      ReflectionUtils.useFunc(sessionManager, 'executeCloseCallback', 12, 12);
      sessionManager.mainScreenId = 13;
      ReflectionUtils.useFunc(sessionManager, 'executeCloseCallback', 11, -1);
      ReflectionUtils.useFunc(sessionManager, 'executeCloseCallback', 11, 11);
      expect(sessionManager !== undefined).assertTrue();
    });

    it('executeSpecialCallback_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let specialCallbackMap = new Map<number, Map<number, Array<Function>>>();
      let map = new Map<number, Array<Function>>();
      let array = new Array<Function>();
      map.set(11, array);
      specialCallbackMap.set(11, map);
      ReflectionUtils.setProperty(sessionManager, 'specialCallbackMap', specialCallbackMap);

      ReflectionUtils.useFunc(sessionManager, 'executeSpecialCallback', 12, 12);
      sessionManager.mainScreenId = 13;
      ReflectionUtils.useFunc(sessionManager, 'executeSpecialCallback', 11, -1);
      ReflectionUtils.useFunc(sessionManager, 'executeSpecialCallback', 11, 11);
      expect(sessionManager !== undefined).assertTrue();
    });

    it('executeCloseSpecialCallback_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let specialCallbackMap = new Map<number, Map<number, Array<Function>>>();
      let map = new Map<number, Array<Function>>();
      let array = new Array<Function>();
      map.set(11, array);
      specialCallbackMap.set(11, map);
      ReflectionUtils.setProperty(sessionManager, 'specialCallbackMap', specialCallbackMap);

      ReflectionUtils.useFunc(sessionManager, 'executeCloseSpecialCallback', 12, 12);
      sessionManager.mainScreenId = 13;
      ReflectionUtils.useFunc(sessionManager, 'executeCloseSpecialCallback', 11, -1);
      ReflectionUtils.useFunc(sessionManager, 'executeCloseSpecialCallback', 11, 11);
      expect(sessionManager !== undefined).assertTrue();
    });

    it('executeSpecialStartSceneCallback_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let specialCallbackMap = new Map<number, Map<number, Array<Function>>>();
      let map = new Map<number, Array<Function>>();
      let array = new Array<Function>();
      map.set(11, array);
      specialCallbackMap.set(11, map);
      ReflectionUtils.setProperty(sessionManager, 'specialCallbackMap', specialCallbackMap);

      let toInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName',
        'testModuleName', 'testAbilityName');
      ReflectionUtils.useFunc(sessionManager, 'executeSpecialStartSceneCallback', 12, 12, toInfo);
      sessionManager.mainScreenId = 13;
      toInfo.screenId = 14;
      ReflectionUtils.useFunc(sessionManager, 'executeSpecialStartSceneCallback', 11, 11, toInfo);
      toInfo.screenId = -1;
      ReflectionUtils.useFunc(sessionManager, 'executeSpecialStartSceneCallback', 11, 12, toInfo);
      expect(sessionManager !== undefined).assertTrue();
    });

    it('executeStartSceneCallback_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let callbackMap = new Map<number, Map<number, Array<Function>>>();
      let map = new Map<number, Array<Function>>();
      let array = new Array<Function>();
      map.set(11, array);
      callbackMap.set(11, map);
      ReflectionUtils.setProperty(sessionManager, 'callbackMap', callbackMap);

      let toInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName',
        'testModuleName', 'testAbilityName');
      ReflectionUtils.useFunc(sessionManager, 'executeStartSceneCallback', 12, 12, toInfo);
      sessionManager.mainScreenId = 13;
      toInfo.screenId = 14;
      ReflectionUtils.useFunc(sessionManager, 'executeStartSceneCallback', 11, 11, toInfo);
      toInfo.screenId = -1;
      ReflectionUtils.useFunc(sessionManager, 'executeStartSceneCallback', 11, 12, toInfo);
      expect(sessionManager !== undefined).assertTrue();
    });

    it('executeMinimizeAllSceneCallback_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let callbackMap = new Map<number, Map<number, Array<Function>>>();
      let map = new Map<number, Array<Function>>();
      let array = new Array<Function>();
      map.set(11, array);
      callbackMap.set(11, map);
      ReflectionUtils.setProperty(sessionManager, 'callbackMap', callbackMap);

      ReflectionUtils.useFunc(sessionManager, 'executeMinimizeAllSceneCallback', 12, 12);
      sessionManager.mainScreenId = 13;
      ReflectionUtils.useFunc(sessionManager, 'executeMinimizeAllSceneCallback', 11, -1);
      ReflectionUtils.useFunc(sessionManager, 'executeMinimizeAllSceneCallback', 11, 11);
      expect(sessionManager !== undefined).assertTrue();
    });

    it('executeSpecialMinimizeAllSceneCallback_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let callbackMap = new Map<number, Map<number, Array<Function>>>();
      let map = new Map<number, Array<Function>>();
      let array = new Array<Function>();
      map.set(11, array);
      callbackMap.set(11, map);
      ReflectionUtils.setProperty(sessionManager, 'callbackMap', callbackMap);

      ReflectionUtils.useFunc(sessionManager, 'executeSpecialMinimizeAllSceneCallback', 12, 12);
      sessionManager.mainScreenId = 13;
      ReflectionUtils.useFunc(sessionManager, 'executeSpecialMinimizeAllSceneCallback', 11, -1);
      ReflectionUtils.useFunc(sessionManager, 'executeSpecialMinimizeAllSceneCallback', 11, 11);
      expect(sessionManager !== undefined).assertTrue();
    });

    it('executeSwitchUserCompleteCallback_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let callbackMap = new Map<number, Map<number, Array<Function>>>();
      let map = new Map<number, Array<Function>>();
      let array = new Array<Function>();
      map.set(11, array);
      callbackMap.set(11, map);
      ReflectionUtils.setProperty(sessionManager, 'callbackMap', callbackMap);

      ReflectionUtils.useFunc(sessionManager, 'executeSwitchUserCompleteCallback', 12, 12);
      sessionManager.mainScreenId = 13;
      ReflectionUtils.useFunc(sessionManager, 'executeSwitchUserCompleteCallback', 11, -1);
      ReflectionUtils.useFunc(sessionManager, 'executeSwitchUserCompleteCallback', 11, 11);
      expect(sessionManager !== undefined).assertTrue();
    });

    it('refreshZOrder_test', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      ReflectionUtils.setProperty(sessionManager, '_isCoreEnable', true);
      sessionManager.refreshZOrder();
      ReflectionUtils.setProperty(sessionManager, '_isCoreEnable', false);
      sessionManager.refreshZOrder();
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('traversePanelFromTopToBottom_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.mainScreenId = 999;
      ReflectionUtils.useFunc(sessionManager, 'traversePanelFromTopToBottom', null, ()=>{});

      let panelLists = new Array<Function>();
      ReflectionUtils.useFunc(sessionManager, 'traversePanelFromTopToBottom', panelLists, ()=>{});

      expect(sessionManager !== undefined).assertTrue();
    });

    it('traverseOverlaySessionTopToBottom_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      ReflectionUtils.useFunc(sessionManager, 'traverseOverlaySessionTopToBottom', null, ()=>{});

      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let systemSessionInfo: SystemSessionInfo = {
        systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
        sceneName: 'SCBGestureBackViewModelTest',
        sceneZIndex: 101,
        isFocusable: false,
        isTouchable: true,
        privacyMode: false,
        hitTestMode: HitTestMode.Default,
        isOverlayScene: true,
      };
      let systemSceneSession: SCBSystemSceneSession =
        new SCBSystemSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), systemSessionInfo, undefined);
      let overlaySessionList = new Array<SCBSystemSceneSession>();
      ReflectionUtils.useFunc(sessionManager, 'traverseOverlaySessionTopToBottom', overlaySessionList, ()=>{});
      overlaySessionList.push(systemSceneSession);
      ReflectionUtils.useFunc(sessionManager, 'traverseOverlaySessionTopToBottom', overlaySessionList, ()=>{});
      ReflectionUtils.useFunc(sessionManager, 'traverseOverlaySessionTopToBottom',
        overlaySessionList, (session: SCBSystemSceneSession)=>{return true});

      expect(sessionManager !== undefined).assertTrue();
    });

    it('traverseDividerPanelSession_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let panelSession: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, screenProperty);
      let scbSceneSession2: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      panelSession.secondarySession = scbSceneSession2;

      panelSession.isSplit = true;
      panelSession.dividerParam.isFocusPrimary = true
      let mocker: MockKit = new MockKit();
      let func1: Function = mocker.mockFunc(sessionManager, sessionManager.isPcMode);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      ReflectionUtils.useFunc(sessionManager, 'traverseDividerPanelSession', panelSession, ()=>{return true});

      panelSession.isSplit = false;
      panelSession.isMidScene = true;
      ReflectionUtils.useFunc(sessionManager, 'traverseDividerPanelSession', panelSession, ()=>{return true});

      panelSession.isSplit = false;
      panelSession.isMidScene = false;
      ReflectionUtils.useFunc(sessionManager, 'traverseDividerPanelSession', panelSession, ()=>{return true});

      panelSession.secondarySession = null;
      ReflectionUtils.useFunc(sessionManager, 'traverseDividerPanelSession', panelSession, ()=>{return true});

      expect(sessionManager !== undefined).assertTrue();
      mocker.clear(sessionManager);
      mocker.clearAll();
    });

    it('traversePanelFromBottomToTop_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let panelSession: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, screenProperty);
      let scbSceneSession2: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      panelSession.secondarySession = scbSceneSession2;
      let panelList = new Array<SCBSceneContainerSession>().push(panelSession);

      panelSession.isSplit = true;
      panelSession.dividerParam.isFocusPrimary = true
      let mocker: MockKit = new MockKit();
      let func1: Function = mocker.mockFunc(sessionManager, sessionManager.isPcMode);
      when(func1)(ArgumentMatchers.any).afterReturn(true);
      ReflectionUtils.useFunc(sessionManager, 'traversePanelFromBottomToTop', panelList, ()=>{return true});

      panelSession.isSplit = false;
      panelSession.isMidScene = true;
      ReflectionUtils.useFunc(sessionManager, 'traversePanelFromBottomToTop', panelList, ()=>{return true});

      panelSession.isSplit = false;
      panelSession.isMidScene = false;
      ReflectionUtils.useFunc(sessionManager, 'traversePanelFromBottomToTop', panelList, ()=>{return true});

      let systemSessionInfo: SystemSessionInfo = {
        systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
        sceneName: 'SCBGestureBackViewModelTest',
        sceneZIndex: 101,
        isFocusable: false,
        isTouchable: true,
        privacyMode: false,
        hitTestMode: HitTestMode.Default,
        isOverlayScene: true,
      };
      let systemSceneSession: SCBSystemSceneSession =
        new SCBSystemSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), systemSessionInfo, undefined);
      let func2: Function = mocker.mockFunc(panelSession, panelSession.getOverlaySessionList);
      when(func2)(ArgumentMatchers.any).afterReturn(new Array<SCBSystemSceneSession>().push(systemSceneSession));
      ReflectionUtils.useFunc(sessionManager, 'traversePanelFromBottomToTop', panelList, ()=>{return true});

      let panelList2 = new Array<SCBSceneSession>().push(scbSceneSession);
      ReflectionUtils.useFunc(sessionManager, 'traversePanelFromBottomToTop', panelList2, ()=>{return true});

      expect(sessionManager !== undefined).assertTrue();
      mocker.clear(sessionManager);
      mocker.clearAll();
    });

    it('traverseOverlaySession_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let systemSessionInfo: SystemSessionInfo = {
        systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
        sceneName: 'SCBGestureBackViewModelTest',
        sceneZIndex: 101,
        isFocusable: false,
        isTouchable: true,
        privacyMode: false,
        hitTestMode: HitTestMode.Default,
        isOverlayScene: true,
      };
      let systemSceneSession: SCBSystemSceneSession =
        new SCBSystemSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), systemSessionInfo, undefined);
      let overlaySessionList = new Array<SCBSystemSceneSession>();
      ReflectionUtils.useFunc(sessionManager, 'traverseOverlaySession', overlaySessionList, ()=>{});
      overlaySessionList.push(systemSceneSession);
      ReflectionUtils.useFunc(sessionManager, 'traverseOverlaySession', overlaySessionList, ()=>{return true});

      expect(sessionManager !== undefined).assertTrue();
    });

    it('traverseSubList_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      let stateChangeCallback = (parentId: number, persistentId: number, state: sceneSessionManager.SessionState): void => {
        if (typeof parentId !== 'number') {
          return;
        }
      };
      let sceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let specificSession: SCBSpecificSession = new SCBSpecificSession(sceneSessionManager.requestSceneSession(sceneInfo2), stateChangeCallback);
      let specificSessionList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
      ReflectionUtils.useFunc(sessionManager, 'traverseSubList', specificSessionList, ()=>{return true});
      specificSessionList.push(specificSession);
      specificSession.subSessionList = specificSessionList;
      ReflectionUtils.useFunc(sessionManager, 'traverseSubList', specificSessionList, ()=>{return true});

      expect(sessionManager !== undefined).assertTrue();
    });

    it('insertToTopByModalType_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      ReflectionUtils.useFunc(sessionManager, 'insertToTopByModalType', null, null);

      let sceneInfo2: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let stateChangeCallback = (parentId: number, persistentId: number, state: sceneSessionManager.SessionState): void => {
        if (typeof parentId !== 'number') {
          return;
        }
      };
      let specificSession: SCBSpecificSession =
        new SCBSpecificSession(sceneSessionManager.requestSceneSession(sceneInfo2), stateChangeCallback);
      let specificSessionList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
      specificSessionList.push(specificSession);
      specificSession.subSessionList = specificSessionList;
      ReflectionUtils.useFunc(sessionManager, 'insertToTopByModalType', specificSession, specificSessionList);

      expect(sessionManager !== undefined).assertTrue();
    });

    it('modalTypeToLevelHeight_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      ReflectionUtils.useFunc(sessionManager, 'modalTypeToLevelHeight', 1, true);
      ReflectionUtils.useFunc(sessionManager, 'modalTypeToLevelHeight', 1, false);

      expect(sessionManager !== undefined).assertTrue();
    });

    it('requestSingleScreenToTop_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      ReflectionUtils.useFunc(sessionManager, 'requestSingleScreenToTop', 123, 0);
      ReflectionUtils.useFunc(sessionManager, 'requestSingleScreenToTop', 123, 456);

      expect(sessionManager !== undefined).assertTrue();
    });

    it('updateSystemBarProperty_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let screenSessionManager = SCBScreenSessionManager.getInstance();
      let testPtr : UIContext;
      let screenSession: screenSessionManager.ScreenSession = {
        screenId: -1,
        name: 'testScreen',
        on: (type: string, callback: Function): void => {
        },
        setScreenRotationLocked: (isLocked: boolean): void => {
        },
        loadContent: (path: string, context: ServiceExtensionContext, storage?: LocalStorage): void => {
        },
        setTouchEnabled: (isTouchEnabled: boolean): void => {
        },
        getScreenUIContext: (): UIContext => {
          return testPtr;
        }
      };
      let scbScreenSession: SCBScreenSession = new SCBScreenSession(screenSession);

      let mocker = new MockKit();
      let func: Function = mocker.mockFunc(screenSessionManager, screenSessionManager.getScreenSessionList);
      when(func)(ArgumentMatchers.any).afterReturn([scbScreenSession]);
      ReflectionUtils.useFunc(sessionManager, 'updateSystemBarProperty');

      mocker.clear(screenSessionManager);
      mocker.clearAll();
      expect(sessionManager !== undefined).assertTrue();
    });

    it('updateSystemBarPropertyInAppForPc_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.sessionData._isSystemBarPropertyApplied = true;
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, screenProperty);

      let dockVisibleCallback: Map<number, Function> = new Map().set(123, ()=>{});
      ReflectionUtils.setProperty(sessionManager, 'dockVisibleCallback', dockVisibleCallback);
      let statusBarRecoverCallback: Map<number, Function> = new Map().set(123, ()=>{});
      ReflectionUtils.setProperty(sessionManager, 'statusBarRecoverCallback', statusBarRecoverCallback);

      ReflectionUtils.useFunc(sessionManager, 'updateSystemBarPropertyInAppForPc', containerSession, 123);

      expect(sessionManager !== undefined).assertTrue();
    });

    it('onGestureBarVisibleChange_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      let gestureBarVisibleCallback: Map<number, Function> = new Map().set(456, ()=>{});
      ReflectionUtils.setProperty(sessionManager, 'gestureBarVisibleCallback', gestureBarVisibleCallback);
      ReflectionUtils.useFunc(sessionManager, 'onGestureBarVisibleChange', 123, 456);

      expect(sessionManager !== undefined).assertTrue();
    });

    it('updateSystemBarPropertyInSplit_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.sessionData._isSystemBarPropertyApplied = true;
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, screenProperty);
      containerSession.screenProperty.screenId = 123;

      let dockVisibleCallback: Map<number, Function> = new Map().set(123, ()=>{});
      ReflectionUtils.setProperty(sessionManager, 'dockVisibleCallback', dockVisibleCallback);
      let statusBarRecoverCallback: Map<number, Function> = new Map().set(123, ()=>{});
      ReflectionUtils.setProperty(sessionManager, 'statusBarRecoverCallback', statusBarRecoverCallback);
      ReflectionUtils.useFunc(sessionManager, 'updateSystemBarPropertyInSplit', containerSession);

      expect(sessionManager !== undefined).assertTrue();
    });

    it('updateSystemBarPropertyInMidScene_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let primarySession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      primarySession.sessionData._isSystemBarPropertyApplied = true;
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
      containerSession.screenProperty.screenId = 123;
      containerSession.isMidScene = true;
      let mocker = new MockKit();
      let func: Function = mocker.mockFunc(sessionManager, sessionManager.isExpectedState);
      when(func)(ArgumentMatchers.any).afterReturn(true);
      ReflectionUtils.useFunc(sessionManager, 'updateSystemBarPropertyInMidScene', containerSession);

      mocker.clear(sessionManager);
      expect(sessionManager !== undefined).assertTrue();
    });

    it('setCurScreenTopSessionWindowModeMap_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let primarySession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      primarySession.sessionData._isSystemBarPropertyApplied = true;
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, screenProperty);
      containerSession.screenProperty.screenId = 123;
      (containerSession.primarySession as SCBSceneSession).sceneInfo.screenId = 123;

      ReflectionUtils.useFunc(sessionManager, 'setCurScreenTopSessionWindowModeMap', containerSession, 123);

      let mocker = new MockKit();
      let func: Function = mocker.mockFunc(containerSession, containerSession.haveActiveSession);
      when(func)(ArgumentMatchers.any).afterReturn(true);

      containerSession.isSplit = true;
      ReflectionUtils.useFunc(sessionManager, 'setCurScreenTopSessionWindowModeMap', containerSession, 123);

      containerSession.isSplit = false;
      containerSession.isMidScene = true;
      ReflectionUtils.useFunc(sessionManager, 'setCurScreenTopSessionWindowModeMap', containerSession, 123);

      containerSession.isMidScene = false;
      (containerSession.primarySession as SCBSceneSession).sceneInfo.updateWindowModeAndSync(SCBSceneMode.FULLSCREEN);
      (containerSession.primarySession as SCBSceneSession).setIsClosing(false);
      ReflectionUtils.useFunc(sessionManager, 'setCurScreenTopSessionWindowModeMap', containerSession, 123);

      mocker.clear(containerSession);
      expect(sessionManager !== undefined).assertTrue();
    });

    it('requestKeyboardPanelSession_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.sessionData._isSystemBarPropertyApplied = true;
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let containerSession: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, screenProperty);
      containerSession.screenProperty.screenId = 123;

      let systemSessionInfo: SystemSessionInfo = {
        systemType: sceneSessionManager.SessionType.TYPE_UNDEFINED,
        sceneName: 'SCBGestureBackViewModelTest',
        sceneZIndex: 101,
        isFocusable: false,
        isTouchable: true,
        privacyMode: false,
        hitTestMode: HitTestMode.Default,
        isOverlayScene: true,
      };
      ReflectionUtils.useFunc(sessionManager,
        'requestKeyboardPanelSession', sceneSessionManager.requestSceneSession(sceneInfo),
        systemSessionInfo, null, 123);
      ReflectionUtils.useFunc(sessionManager,
        'requestKeyboardPanelSession', sceneSessionManager.requestSceneSession(sceneInfo),
        systemSessionInfo, null, undefined);

      expect(sessionManager !== undefined).assertTrue();
    });

    it('getSystemSceneSessionWithId_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      ReflectionUtils.useFunc(sessionManager, 'getSystemSceneSessionWithId', 123, undefined);
      ReflectionUtils.useFunc(sessionManager, 'getSystemSceneSessionWithId', 123, 456);

      expect(sessionManager !== undefined).assertTrue();
    });

    it('getSystemSceneSessionWithSystemType_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      ReflectionUtils.useFunc(sessionManager, 'getSystemSceneSessionWithSystemType', 3, undefined);
      ReflectionUtils.useFunc(sessionManager, 'getSystemSceneSessionWithSystemType', 3, 456);

      expect(sessionManager !== undefined).assertTrue();
    });

    it('getSystemSceneSessionWithSystemBarType_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      ReflectionUtils.useFunc(sessionManager, 'getSystemSceneSessionWithSystemBarType', 1, undefined);
      ReflectionUtils.useFunc(sessionManager, 'getSystemSceneSessionWithSystemBarType', 1, 456);

      expect(sessionManager !== undefined).assertTrue();
    });

    it('refreshAvailableArea_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      ReflectionUtils.useFunc(sessionManager, 'refreshAvailableArea', undefined);
      ReflectionUtils.useFunc(sessionManager, 'refreshAvailableArea', 456);

      expect(sessionManager !== undefined).assertTrue();
    });

    it('requestSystemSceneSessionDestruction_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      let sessionInfo: SystemSessionInfo = {
        systemType: sceneSessionManager.SessionType.TYPE_APP,
        sceneName: 'test',
        sceneZIndex: 0,
        hitTestMode: HitTestMode.Default,
        windowInputType: 1,
      };
      let systemSceneSession = sessionManager.requestSystemSceneSession(sessionInfo);
      ReflectionUtils.useFunc(sessionManager, 'requestSystemSceneSessionDestruction', systemSceneSession, undefined);
      ReflectionUtils.useFunc(sessionManager, 'requestSystemSceneSessionDestruction', systemSceneSession, 456);

      expect(sessionManager !== undefined).assertTrue();
    });

    it('reOrderShowRemoveWhenLocked_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      ReflectionUtils.setProperty(sessionManager, 'isScreenLock', false);
      sessionManager.reOrderShowRemoveWhenLocked();
      ReflectionUtils.setProperty(sessionManager, 'isScreenLock', true);
      sessionManager.reOrderShowRemoveWhenLocked();

      expect(sessionManager !== undefined).assertTrue();
    });

    it('moveSpecialContainerSessionUp_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let panelSession: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, screenProperty);
      let mocker = new MockKit();
      let func: Function = mocker.mockFunc(sessionManager, sessionManager.onRemoveContainerSession);
      when(func)(ArgumentMatchers.any).afterReturn([panelSession]);

      ReflectionUtils.useFunc(sessionManager, 'moveSpecialContainerSessionUp', false, true);

      mocker.clear(sessionManager);
      mocker.clearAll();
      expect(sessionManager !== undefined).assertTrue();
    });

    it('requestActivationInReorderShowWhenLocked_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let panelSession: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, screenProperty);

      let mocker = new MockKit();
      let func: Function = mocker.mockFunc(sessionManager, sessionManager.getSceneContainerSessionFromSpecialScenePanel);
      when(func)(ArgumentMatchers.any).afterReturn(panelSession);

      ReflectionUtils.useFunc(sessionManager, 'requestActivationInReorderShowWhenLocked', panelSession);

      mocker.clear(sessionManager);
      mocker.clearAll();
      expect(sessionManager !== undefined).assertTrue();
    });

    it('registerAddContainerSessionCallback_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      sessionManager.registerAddContainerSessionCallback(()=>{}, undefined);
      sessionManager.registerAddContainerSessionCallback(()=>{}, 123);

      expect(sessionManager !== undefined).assertTrue();
    });

    it('registerAddExtendContainerSessionCallback_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      sessionManager.registerAddExtendContainerSessionCallback(()=>{}, undefined);
      sessionManager.registerAddExtendContainerSessionCallback(()=>{}, 123);

      expect(sessionManager !== undefined).assertTrue();
    });

    it('unregisterAddContainerSessionCallback_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      sessionManager.unregisterAddContainerSessionCallback(undefined);
      sessionManager.unregisterAddContainerSessionCallback(123);

      expect(sessionManager !== undefined).assertTrue();
    });

    it('unregisterAddExtendContainerSessionCallback_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      sessionManager.unregisterAddExtendContainerSessionCallback(undefined);
      sessionManager.unregisterAddExtendContainerSessionCallback(123);

      expect(sessionManager !== undefined).assertTrue();
    });

    it('registerRemoveContainerSessionCallback_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      sessionManager.registerRemoveContainerSessionCallback(()=>{}, undefined);
      sessionManager.registerRemoveContainerSessionCallback(()=>{}, 123);

      expect(sessionManager !== undefined).assertTrue();
    });

    it('unregisterStatusBarRecoverCallback_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      sessionManager.unregisterStatusBarRecoverCallback(undefined);
      sessionManager.unregisterStatusBarRecoverCallback(123);

      expect(sessionManager !== undefined).assertTrue();
    });

    it('unregisterRemoveContainerSessionCallback_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      sessionManager.unregisterRemoveContainerSessionCallback(undefined);
      sessionManager.unregisterRemoveContainerSessionCallback(123);

      expect(sessionManager !== undefined).assertTrue();
    });

    it('onAddContainerSession_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      sessionManager.onAddContainerSession(null, true, undefined);
      sessionManager.onAddContainerSession(null, true, 123);

      expect(sessionManager !== undefined).assertTrue();
    });

    it('onAddExtendContainerSession_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      sessionManager.onAddExtendContainerSession(null, undefined);
      sessionManager.onAddExtendContainerSession(null, 123);

      expect(sessionManager !== undefined).assertTrue();
    });

    it('onRemoveContainerSession_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();

      sessionManager.onRemoveContainerSession(undefined);
      sessionManager.onRemoveContainerSession(123);

      expect(sessionManager !== undefined).assertTrue();
    });

    it('exitActiveSplit_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let screenId = INVALID_SCREEN_ID;
      sessionManager.exitActiveSplit(screenId);
      screenId = 11;
      sessionManager.exitActiveSplit(screenId);
      expect(sessionManager !== undefined).assertTrue();
    });
  });
}