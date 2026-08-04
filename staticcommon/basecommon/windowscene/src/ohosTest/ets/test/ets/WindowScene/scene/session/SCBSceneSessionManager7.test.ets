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
} from '@ohos/hypium';
import {
  SCBSceneInfo,
  SCBSceneSession,
  SCBScreenProperty,
  SCBSceneContainerSession,
  SCBSpecificSession,
  SCBSystemBarProperty,
  SCBSceneMode
} from '../../../../../../../..';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  SCBSceneSessionManager,
  PopSceneSessionFunc,
  VirtualScreenStartSceneFunc
} from '../../../../../../../main/ets/scene/session/SCBSceneSessionManager';
import { ReflectionUtils } from '../../utils/ReflectionUtils';
import { SCBSceneContainerSessionArray } from '../../../../../../../main/ets/scene/session/SCBSceneContainerSession';
import { display } from '@kit.ArkUI';

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

let getContainerSessionListNotShowRecentCallBack = (): SCBSceneContainerSessionArray => {
  let sceneInfo = new SCBSceneInfo('getContainerSessionListNotShowRecent_test',
    'getContainerSessionListNotShowRecent_test', 'getContainerSessionListNotShowRecent_test');
  sceneInfo.persistentId = 1;
  let scbSceneSession: SCBSceneSession = new SCBSceneSession(
    sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  let screenProperty: SCBScreenProperty = new SCBScreenProperty();
  let scbSceneContainerSession: SCBSceneContainerSession =
    new SCBSceneContainerSession(scbSceneSession, screenProperty);
  let sceneContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
  sceneContainerSessionList.push(scbSceneContainerSession);
  return sceneContainerSessionList;
}

export function SCBSceneSessionManagerTest7() {
  describe('SCBSceneSessionManagerTest7', () => {
    let popSceneSession: PopSceneSessionFunc;
    let virtualScreenStartSceneFunc = (sceneInfo: SCBSceneInfo): void => {
      return;
    };

    beforeAll(() => {
      initAll();
      popSceneSession = (): SCBSceneSession | undefined => {
        let sceneInfo = new SCBSceneInfo('popSceneSessionBundle',
          'popSceneSessionMoudle', 'popSceneSessionAbility');
        let scbSceneSession: SCBSceneSession = new SCBSceneSession(
          sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
        return scbSceneSession;
      }
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('requestFocus_undefinedPersistentId', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      manager.requestFocus(undefined);
    })

    it('requestUnFocus_invalid_persistentId', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      manager.requestUnfocus(undefined);
    })

    it('requestUnFocus_valid_persistentId', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();

      let persistentId: number = 1234;
      manager.requestUnfocus(persistentId);
    })

    it('setAppOverrideSystemBarProperty_TYPE_STATUS_BAR', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      const mockPropertys: Map<number, SCBSystemBarProperty> = new Map();
      ReflectionUtils.setProperty(manager, 'appOverrideSystemBarPropertys', mockPropertys);
      const prop: SCBSystemBarProperty = new SCBSystemBarProperty(sceneSessionManager.SessionType.TYPE_STATUS_BAR,
        true, '#00FFFFFF', '#FF000000');
      const callModule: string = 'callModule';
      manager.setAppOverrideSystemBarProperty(prop, 0, callModule);
      expect((ReflectionUtils.getProperty(manager, 'appOverrideSystemBarPropertys')).get(0)).assertEqual(prop);
    })

    it('setAppOverrideSystemBarProperty_not_TYPE_STATUS_BAR', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      const mockPropertys: Map<number, SCBSystemBarProperty> = new Map();
      ReflectionUtils.setProperty(manager, 'appOverrideSystemBarPropertys', mockPropertys);
      const prop: SCBSystemBarProperty = new SCBSystemBarProperty(sceneSessionManager.SessionType.TYPE_APP,
        true, '#00FFFFFF', '#FF000000');
      const callModule: string = 'callModule';
      manager.setAppOverrideSystemBarProperty(prop, 0, callModule);
      expect((ReflectionUtils.getProperty(manager, 'appOverrideSystemBarPropertys')).has(0)).assertEqual(false);
    })

    it('enterRecentTask', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();

      // enter recent
      manager.enterRecentTask(true);
      let scbSystemBarProperty: SCBSystemBarProperty = ReflectionUtils.getProperty(manager, 'sceneBoardForceProperty');
      expect(scbSystemBarProperty.type).assertEqual(sceneSessionManager.SessionType.TYPE_STATUS_BAR);

      // exit recent
      manager.enterRecentTask(false);
      scbSystemBarProperty = ReflectionUtils.getProperty(manager, 'sceneBoardForceProperty');
      expect(scbSystemBarProperty.type).assertEqual(sceneSessionManager.SessionType.TYPE_UNDEFINED);
    })

    it('checkIsInitDeliverAbilityInfo', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();

      // codePath === ohos_APPLICATION && isInitDeliverAbilityInfo === false
      let codePath = '1';
      ReflectionUtils.useFunc(manager, 'checkIsInitDeliverAbilityInfo', codePath);
      expect(ReflectionUtils.getProperty(manager, 'isInitDeliverAbilityInfo')).assertTrue();

      // codePath === LINUX_APPLICATION && isInitDeliverAbilityInfo === false
      ReflectionUtils.setProperty(manager, 'isInitDeliverAbilityInfo', false);
      codePath = '2';
      ReflectionUtils.useFunc(manager, 'checkIsInitDeliverAbilityInfo', codePath);
      expect(ReflectionUtils.getProperty(manager, 'isInitDeliverAbilityInfo')).assertTrue();

      // isInitDeliverAbilityInfo === true
      ReflectionUtils.useFunc(manager, 'checkIsInitDeliverAbilityInfo', codePath);
      expect(ReflectionUtils.getProperty(manager, 'isInitDeliverAbilityInfo')).assertTrue();

      // wrong codePath
      ReflectionUtils.setProperty(manager, 'isInitDeliverAbilityInfo', false);
      codePath = '3';
      ReflectionUtils.useFunc(manager, 'checkIsInitDeliverAbilityInfo', codePath);
      expect(ReflectionUtils.getProperty(manager, 'isInitDeliverAbilityInfo')).assertFalse();
    })

    it('test_unregisterGetContainerSessionListCallback_success', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let callback: Function = () => {
      };
      let screenId: number = 1;
      manager.registerGetContainerSessionListCallback(callback, screenId);

      manager.unregisterGetContainerSessionListCallback(screenId);

      expect(manager.getContainerSessionList(screenId).length).assertEqual(0);
    });

    it('test_unregisterPopSceneSession_success', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let screenId: number = 1;
      manager.registerPopSceneSession(popSceneSession, screenId);

      let beforeLength: number = ReflectionUtils.getProperty(manager, 'popSceneSessionFuncMap').size;
      manager.unregisterPopSceneSession(screenId);
      expect(beforeLength).assertEqual(ReflectionUtils.getProperty(manager, 'popSceneSessionFuncMap').size + 1);
    });

    it('test_unregisterPopSpecialSceneSession_success', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let screenId: number = 1;

      manager.registerPopSpecialSceneSession(popSceneSession, screenId);

      let beforeLength: number = ReflectionUtils.getProperty(manager, 'popSpecialSceneSessionFuncMap').size;
      manager.unregisterPopSpecialSceneSession(screenId);
      expect(beforeLength)
        .assertEqual(ReflectionUtils.getProperty(manager, 'popSpecialSceneSessionFuncMap').size + 1);
    });

    it('test_unregisterVirtualScreenStartScene_success', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let screenId: number = 1;

      manager.registerVirtualScreenStartScene(virtualScreenStartSceneFunc, screenId);

      let beforeLength: number = ReflectionUtils.getProperty(manager, 'virtualScreenStartSceneFuncMap').size;
      manager.unregisterVirtualScreenStartScene(screenId);
      expect(beforeLength)
        .assertEqual(ReflectionUtils.getProperty(manager, 'virtualScreenStartSceneFuncMap').size + 1);
    });

    it('test_popSpecialSceneFromOtherScreen_returnUndefined', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();

      ReflectionUtils.setProperty(manager, 'popSpecialSceneSessionFuncMap', new Map());
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123)
      let ret: SCBSceneSession | undefined = manager.popSpecialSceneFromOtherScreen(sceneInfo, true)
      expect(ret).assertUndefined();
    });

    it('test_unRegisterRecoverSessionCallback_success', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let callback: Function = () => {
      };
      let screenId: number = 1;

      manager.registerRecoverSessionCallback(callback, screenId);

      let beforeLength: number = ReflectionUtils.getProperty(manager, 'recoverSessionCallbackMap').size;
      manager.unRegisterRecoverSessionCallback(screenId);
      expect(beforeLength)
        .assertEqual(ReflectionUtils.getProperty(manager, 'recoverSessionCallbackMap').size + 1);
    });

    it('test_unRegisterStartSceneWithRotationIfNeedCallback_success', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let callback: Function = () => {
      };

      manager.registerStartSceneWithRotationIfNeedCallback(callback)

      manager.unRegisterStartSceneWithRotationIfNeedCallback();
      expect(ReflectionUtils.getProperty(manager, 'startSceneWithRotationIfNeedCallback')).assertNull();
    });

    it('test_unRegisterStartSceneWithRotationIfNeedCallback_success', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let callback: Function = () => {
      };

      manager.registerSpecialScenePanelExitSceneWithRotationRecoverCallback(callback)

      manager.unregisterSpecialScenePanelExitSceneWithRotationRecoverCallback();
      expect(ReflectionUtils.getProperty(manager, 'specialScenePanelExitSceneWithRotationRecoverCallback'))
        .assertNull();
    });

    it('test_unRegisterStartSceneWithRotationIfNeedCallback_success', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let callback: Function = () => {
      };

      manager.registerGetSpecialContainerSessionListCallback(callback)

      manager.unregisterGetSpecialContainerSessionListCallback();
      expect(ReflectionUtils.getProperty(manager, 'getSpecialContainerSessionListCallback')).assertNull();
    });

    it('test_getCurrentDensityDpi_success', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let ret: number = manager.getCurrentDensityDpi();
      expect(ret).assertEqual(display.getDefaultDisplaySync().densityDPI);
    });

    it('test_setPcModeState_success', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      manager.setPcModeState(true);
      expect(ReflectionUtils.getProperty(manager, 'isInPcMode')).assertTrue();
    });

    it('test_clearTogglePcModeActionFunc_success', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();

      manager.clearTogglePcModeActionFunc();
      expect(ReflectionUtils.getProperty(manager, 'togglePcModeFunc')).assertNull();
    });

    it('test_findLastSessionWhenOobeNotExistWhencOobePersistentIdEqualCallerPersistentId_returnUndefined', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let callerPersistentId: number = 2;
      let oobePersistentId: number = 2;

      let ret: SCBSceneSession | undefined =
        ReflectionUtils.useFunc(manager, 'findLastSessionWhenOobeNotExist', sceneSession, callerPersistentId,
          oobePersistentId);
      expect(ret).assertUndefined();
    });

    it('test_linkToCurrentSessionAsCaller_success', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let currentTopSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let sceneInfoOobe = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 124);
      let oobeSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfoOobe), sceneInfoOobe);

      ReflectionUtils.useFunc(manager, 'linkToCurrentSessionAsCaller', currentTopSession, oobeSession);
      expect(oobeSession.sceneInfo.toPersistentId).assertEqual(currentTopSession.session.persistentId);
      expect(currentTopSession.sceneInfo.callerPersistentId).assertEqual(oobeSession.session.persistentId);
    });

    it('test_getCurrentUserId_success', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();

      ReflectionUtils.setProperty(manager, 'mCurrentUserId', 100);
      let ret: number = manager.getCurrentUserId()
      expect(ret).assertEqual(100);
    });

    it('test_unRegisterKeyguardOccludedChangeCallbacks_success', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let callback: Function = () => {
      };

      manager.registerKeyguardOccludedChangeCallbacks(callback);
      let beforeLength: number = ReflectionUtils.getProperty(manager, 'keyguardOccludedChangeCallbacks').length;
      manager.unRegisterKeyguardOccludedChangeCallbacks(callback);
      expect(beforeLength)
        .assertEqual(ReflectionUtils.getProperty(manager, 'keyguardOccludedChangeCallbacks').length + 1);
    });

    it('test_unRegisterFullSceneEndCallback_success', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();

      manager.unRegisterFullSceneEndCallback();
      expect(ReflectionUtils.getProperty(manager, 'fullSceneEndCallback')).assertUndefined();
    });

    it('test_registerGetPluginSessionListCallback_success', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let callback: Function = () => {
      };

      manager.registerGetPluginSessionListCallback(callback);
      expect(callback).assertEqual(ReflectionUtils.getProperty(manager, 'getPluginSessionListCallback'));
    });

    it('test_getFloatContainerSessionFromScenePanelWhenPersistentIdIsInvalid_returnNull', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();

      let ret: SCBSceneContainerSession | null = manager.getFloatContainerSessionFromScenePanel(-1);
      expect(ret).assertNull();
    });

    it('test_getSceneContainerSessionFromScenePanelWhenPersistentIdIsInvalid_returnNull', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();

      let ret: SCBSceneContainerSession | null = manager.getSceneContainerSessionFromScenePanel(-1);
      expect(ret).assertNull();
    });

    it('test_isGrayAppIconWhenGrayAppListManagerFunctionCallbackIsNull_returnFalse', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();

      ReflectionUtils.setProperty(manager, 'grayAppListManagerFunctionCallback', null)
      let ret: boolean = manager.isGrayAppIcon({ bundleName: "bundleName", appIndex: 1 });
      expect(ret).assertFalse();
    });

    it('test_removeSceneContainerSessionBySessionWhenContainerListIsNull_returnFalse', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: SCBSceneSession =
        new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let containerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());

      let ret: boolean = ReflectionUtils.useFunc(manager, 'removeSceneContainerSessionBySession', containerSession,
        new SCBSceneContainerSessionArray());
      expect(ret).assertFalse();
    });

    it('test_registerGrayAllAppsAppIconCallback_success', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let callback: Function = () => {
      };

      manager.registerGrayAllAppsAppIconCallback(callback);
      expect(callback).assertEqual(ReflectionUtils.getProperty(manager, 'ntfGrayAllAppsAppIconCallbacks'));
    });

    it('test_unregisterGrayAllAppsAppIconCallback_success', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();

      manager.unregisterGrayAllAppsAppIconCallback();
      expect(ReflectionUtils.getProperty(manager, 'ntfGrayAllAppsAppIconCallbacks')).assertNull();
    });

    it('test_registerOnFocusedScreenChangeCallback_success', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let callback: Function = () => {
      };
      let beforeLength: number = ReflectionUtils.getProperty(manager, 'focusedScreenChangeCallbacks').length;
      manager.registerOnFocusedScreenChangeCallback(callback);
      expect(beforeLength).assertEqual(ReflectionUtils.getProperty(manager, 'focusedScreenChangeCallbacks').length - 1);
    });

    it('test_unRegisterOnFocusedScreenChangeCallback_success', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let callback: Function = () => {
      };

      manager.registerOnFocusedScreenChangeCallback(callback);
      let beforeLength: number = ReflectionUtils.getProperty(manager, 'focusedScreenChangeCallbacks').length;
      manager.unRegisterOnFocusedScreenChangeCallback(callback);
      expect(beforeLength).assertEqual(ReflectionUtils.getProperty(manager, 'focusedScreenChangeCallbacks').length + 1);
    });

    it('test_unRegisterOnFocusedScreenChangeCallback_success', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();

      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility', 0, 123);
      let sceneSession: sceneSessionManager.SceneSession = sceneSessionManager.requestSceneSession(sceneInfo);
      let ret: boolean = manager.isSceneSessionValid(sceneSession);
      expect(ret).assertTrue();
    });

    it('getContainerSessionListNotShowRecent_test', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();

      manager.registerGetContainerSessionListNotShowRecentCallback(getContainerSessionListNotShowRecentCallBack, 1);
      let result = manager.getContainerSessionListNotShowRecent(2);
      expect(result.length === 0).assertTrue();
      result = manager.getContainerSessionListNotShowRecent(1);
      expect(result.length === 1).assertTrue();
      manager.unregisterGetContainerSessionListNotShowRecentCallback(1);
      result = manager.getContainerSessionListNotShowRecent(1);
      expect(result.length === 0).assertTrue();
    });

    it('getInNotShowRecentIndex_test', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();

      manager.registerGetContainerSessionListNotShowRecentCallback(getContainerSessionListNotShowRecentCallBack, 1);
      let index = manager.getInNotShowRecentIndex(2, 1);
      expect(index === -1).assertTrue();
      index = manager.getInNotShowRecentIndex(1, 1);
      expect(index === 0).assertTrue();
      index = manager.getInNotShowRecentIndex(1, 2);
      expect(index === -1).assertTrue();
      manager.unregisterGetContainerSessionListNotShowRecentCallback(1);
    });

    it('onAddExtendNotShowRecentContainerSession_test', 0, () => {
      const manager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      expect(manager).not().assertNull();
      let count = 0;
      let callback = (list: SCBSceneContainerSessionArray, extendScreenId: number): void => {
        count++;
      };
      manager.registerAddExtendNotShowRecentContainerSessionCallback(callback, 1);
      let list: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      manager.onAddExtendNotShowRecentContainerSession(list, 2, 2);
      expect(count === 0).assertTrue();
      manager.onAddExtendNotShowRecentContainerSession(list, 1, 1);
      expect(count === 1).assertTrue();
      manager.unregisterAddExtendNotShowRecentContainerSessionCallback(1);
      manager.onAddExtendNotShowRecentContainerSession(list, 1, 1);
      expect(count === 1).assertTrue();
    });
  })
}