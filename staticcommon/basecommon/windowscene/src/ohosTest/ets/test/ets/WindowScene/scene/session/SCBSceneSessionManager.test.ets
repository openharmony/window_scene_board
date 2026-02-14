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
  SCBSessionRect,
  SCBScreenProperty,
  SCBSceneContainerSessionArray,
  SCBSceneContainerSession,
} from '../../../../../../../..';
import {
  SCBPropertyChangeReason,
  SCBScreenSessionManager
} from '../../../../../../../main/ets/screen/session/SCBScreenSessionManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  SCBSceneSessionManager,
  OccludeKeygaurdScene,
  SCBEventId,
  ScenePanelState,
  UserSwitchEventType
} from '../../../../../../../main/ets/scene/session/SCBSceneSessionManager';
import type {
  SCBUnlockTransitionController
} from '../../../../../../../main/ets/animation/SCBTransitionManager';
import {
  SystemSessionChangeCallback,
  SystemSessionInfo
} from '../../../../../../../../';
import { CheckEmptyUtils, RectItem, RectInfo } from '@ohos/basicutils';
import sSCBOobeManager from '../../../../../../../main/ets/oobe/SCBOobeManager';
import sSampleManager from '../../../../../../../main/ets/sampleManager/SampleManager';
import { ReflectionUtils } from './ReflectionUtils';
import screenSessionManager from '@ohos.screenSessionManager';
import { SCBWindowSceneConfig, DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBConstants } from '@ohos/commonconstants';
import { display } from '@kit.ArkUI';

let popSceneSession = (): SCBSceneSession | undefined => {
  let sceneInfo = new SCBSceneInfo('popSceneSessionBundle',
    'popSceneSessionMoudle', 'popSceneSessionAbility');
  let scbSceneSession: SCBSceneSession = new SCBSceneSession(
    sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  return scbSceneSession;
}

let popSceneSession2 = (): SCBSceneSession | undefined => {
  let sceneInfo = new SCBSceneInfo('popSceneSession2Bundle',
    'popSceneSession2Moudle', 'popSceneSession2Ability');
  let scbSceneSession: SCBSceneSession = new SCBSceneSession(
    sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  return scbSceneSession;
}

let getContainerSessionListCallback = (): SCBSceneContainerSessionArray => {
  let sceneInfo = new SCBSceneInfo('callbackBundle',
    'callbackMoudle', 'callbackAbility');
  sceneInfo.screenId = 201;
  sceneInfo.persistentId = 211;
  let scbSceneSession: SCBSceneSession = new SCBSceneSession(
    sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  let screenProperty: SCBScreenProperty = new SCBScreenProperty();
  let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, screenProperty);
  let sceneContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
  sceneContainerSessionList.push(scbSceneContainerSession);
  return sceneContainerSessionList;
}

let getFloatingSessionListCallback = (): SCBSceneContainerSessionArray => {
  let sceneInfo = new SCBSceneInfo('floatingCallbackBundle',
    'floatingCallbackMoudle', 'floatingCallbackAbility');
  sceneInfo.persistentId = 111;
  let scbSceneSession: SCBSceneSession = new SCBSceneSession(
    sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  let screenProperty: SCBScreenProperty = new SCBScreenProperty();
  let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, screenProperty);
  scbSceneContainerSession.isSplit = false;
  let sceneContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
  sceneContainerSessionList.push(scbSceneContainerSession);
  return sceneContainerSessionList;
}

let getFloatingSessionList2Callback = (): SCBSceneContainerSessionArray => {
  let sceneInfo = new SCBSceneInfo('floatingCallback2Bundle',
    'floatingCallback2Moudle', 'floatingCallback2Ability');
  sceneInfo.persistentId = 222;
  let scbSceneSession: SCBSceneSession = new SCBSceneSession(
    sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  let screenProperty: SCBScreenProperty = new SCBScreenProperty();
  let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, screenProperty);
  scbSceneContainerSession.isSplit = true;
  let sceneContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
  sceneContainerSessionList.push(scbSceneContainerSession);
  return sceneContainerSessionList;
}

const callback: Function = () => {};

const callback2: Function = () => {
  return 2;
};

let virtualScreenStartSceneFunc = (sceneInfo: SCBSceneInfo): void => {
  return;
};

const systemSessionChangeCallback: SystemSessionChangeCallback = {
  onActiveChange: (isActive: boolean) => {},
  onVisibilityChange: (visibility: boolean) => {},
  onFocusableChange: (isFocusable: boolean) => {},
  onHitTestModeChange: (hitTestMode: HitTestMode) => {},
  onUpdateRect: (rect: SCBSessionRect) => {},
  onTouchOutside: (x: number, y: number) => {},
  onTranslateChange: (x: number, y: number, z: number) => {},
  onBackgroundColorChange: (backgroundColor: string) => {},
  onBackdropBlurChange: (backdropBlur: number) => {},
  onBorderRadiusChange: (borderRadius: number) => {},
  onShadowChange: (radius: number, color: string, offsetX: number, offsetY: number) => {},
  onOpacityChange: (opacity: number) => {},
  onTouchableChange: (touchable: boolean) => {},
  onRotationChange: (screenProperty: SCBScreenProperty) => {},
  onActiveModeChange: (oldScreenProperty : SCBScreenProperty, newScreenProperty: SCBScreenProperty) => {},
  onFoldChange: (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {},
  onZIndexChange: (zIndex: number) => {},
  onResponseRegionChange: (responseRegion: Array<Rectangle>) => {}
}

export function SCBSceneSessionManagerOneTest() {
  describe('SCBSceneSessionManagerOneTest', () => {
    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterEach(() => {
    });
    afterAll(() => {
    });

    it('isContainerSessionNeedRotateTest01', 0, async (done: Function) => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('isContainerSessionNeedRotate01Bundle',
        'isContainerSessionNeedRotate01Moudle', 'isContainerSessionNeedRotate01Ability');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, screenProperty);
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().getScreenSession);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let sessionManager = SCBSceneSessionManager.getInstance();
      let isNeedRotate = sessionManager.isContainerSessionNeedRotate(scbSceneContainerSession);
      expect(isNeedRotate).assertFalse();
      mocker.clear(SCBScreenSessionManager.getInstance());
      mocker.clearAll();
      done();
    });

    it('isContainerSessionNeedRotateTest02', 0, async (done: Function) => {
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('isContainerSessionNeedRotateBundle',
        'isContainerSessionNeedRotateMoudle', 'isContainerSessionNeedRotateAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, screenProperty);
      let sessionManager = SCBSceneSessionManager.getInstance();
      let isNeedRotate = sessionManager.isContainerSessionNeedRotate(scbSceneContainerSession);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('unregisterSceneStateChangeCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.unregisterSceneStateChangeCallback(0);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('registerInitCasePosCallback', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.registerRequestFocusCallback(callback);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('notifyInitCasePosCallback', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfo = new SCBSceneInfo('notifyInitCasePosIconBundle',
        'notifyInitCasePosMoudle', 'notifyInitCasePosAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      sessionManager.registerInitCasePosCallback(callback, 0);
      sessionManager.notifyInitCasePosCallback(scbSceneSession);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('popSceneFromOtherScreenTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('TestBundle',
        'TestMoudle', 'TestAbility');
      sessionManager.registerPopSceneSession(popSceneSession, 1);
      let sceneSession: SCBSceneSession | undefined =
        sessionManager.popSceneFromOtherScreen(sceneInfo);

      sessionManager.registerPopSceneSession(popSceneSession2, 2);
      sceneInfo.screenId = 10;
      let sceneSession2: SCBSceneSession | undefined =
        sessionManager.popSceneFromOtherScreen(sceneInfo);

      sceneInfo.screenId = -1;
      let sceneSession3: SCBSceneSession | undefined =
        sessionManager.popSceneFromOtherScreen(sceneInfo);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('popSceneFromOtherScreen02Test', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('TestBundle',
        'TestMoudle', 'TestAbility');
      let sceneSession: SCBSceneSession | undefined =
        sessionManager.popSceneFromOtherScreen(sceneInfo);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('getContainerSessionListTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.registerGetContainerSessionListCallback(getContainerSessionListCallback, 1);
      sessionManager.getContainerSessionList(1);
      sessionManager.getContainerSessionList(25);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('getSpecialContainerSessionListTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.registerGetSpecialContainerSessionListCallback(callback);
      sessionManager.getSpecialContainerSessionList();
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('getFloatingSessionListTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.registerGetFloatingSessionListCallback(callback);
      sessionManager.getFloatingSessionList();
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('notifyExitRecentForFloatTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.registerExitRecentForFloatCallback(callback);
      sessionManager.notifyExitRecentForFloat();
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('getSpecificContainerSessionListTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.registerGetSpecificContainerSessionListCallback(callback, 11);
      sessionManager.getSpecificContainerSessionList(11);
      sessionManager.getSpecificContainerSessionList(12);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('getIdFromSysSessionNameIdMapTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.sysSessionNameIdMap.set('fakeName', 1);
      let index = sessionManager.getIdFromSysSessionNameIdMap('fakeName');
      expect(index).assertEqual(1);
      sessionManager.sysSessionNameIdMap.set('appName1', 2);
      index = sessionManager.getIdFromSysSessionNameIdMap('appName');
      expect(index).assertEqual(2);
      done();
    });

    it('initSystemSceneListTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.initSystemSceneList(1);
      sessionManager.initSystemSceneList(1);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('setPanelListsTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.setPanelLists(1);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('addActiveSessionListTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.addActiveSessionList(1);
      expect(sessionManager.checkActiveSessionListIsEmpty()).assertFalse();
      sessionManager.addActiveSessionList(1);
      expect(sessionManager.getActiveSessionList().length === 1).assertTrue();
      done();});

    it('removeActiveSessionListTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.removeActiveSessionList(1);
      expect(sessionManager.checkActiveSessionListIsEmpty()).assertTrue();
      sessionManager.addActiveSessionList(1);
      expect(sessionManager.checkActiveSessionListIsEmpty()).assertFalse();
      sessionManager.removeActiveSessionList(1);
      expect(sessionManager.checkActiveSessionListIsEmpty()).assertTrue();
      done();
    });

    it('unlockTransitionCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let unLockTransitionController: SCBUnlockTransitionController | undefined = undefined;
      sessionManager.registerUnlockTransitionCallback(unLockTransitionController);
      sessionManager.unregisterUnlockTransitionCallback(unLockTransitionController);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('handleUserSwitchEventTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.handleUserSwitchEvent(UserSwitchEventType.SWITCHING, 100);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('transferToBackgroundWhenLockedTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('isContainerSessionNeedRotateBundle',
        'isContainerSessionNeedRotateMoudle', 'isContainerSessionNeedRotateAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(scbSceneSession, screenProperty);
      sessionManager.transferToBackgroundWhenLocked(scbSceneContainerSession);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('abilityInfoMapTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      expect(sessionManager.getAbilityLaunchType('test') === 0).assertTrue();
      expect(sessionManager.getAbilityWindowSize('test')).assertNull();
      expect(sessionManager.getAbilityWindowSupportInfo('test')).assertNull();
      expect(sessionManager.getAbilityOrientation('test', 'test', 'test') === 0).assertTrue();
      expect(sessionManager.isExcludeFromSession('test', 'test', 'test')).assertFalse();
      expect(sessionManager.isUnClearFromRecent('test', 'test', 'test')).assertFalse();
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('getTargetSDKVersionTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      expect(sessionManager.getTargetSDKVersion('test') === 0).assertTrue();
      done();
    });

    it('isRemoveSessionAfterTerminateTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      expect(sessionManager.isRemoveSessionAfterTerminate('test', 'test', 'test')).assertFalse();
      let sceneInfo = new SCBSceneInfo('RemoveSessionAfterTerminateBundle',
        'RemoveSessionAfterTerminateMoudle', 'RemoveSessionAfterTerminateAbility');
      sceneInfo.isStartupInstallFree = true;
      sceneInfo.isAtomicService = true;
      expect(sessionManager.isRemoveSessionAfterTerminate('test', 'test', 'test', sceneInfo)).assertTrue();
      done();
    });

    it('getAspectRatioFromPreferenceTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      expect(sessionManager.isRemoveSessionAfterTerminate('test', 'test', 'test')).assertFalse();
      let sceneInfo = new SCBSceneInfo('RemoveSessionAfterTerminateBundle',
        'RemoveSessionAfterTerminateMoudle', 'RemoveSessionAfterTerminateAbility');
      sceneInfo.isStartupInstallFree = true;
      sceneInfo.isAtomicService = true;
      expect(sessionManager.isRemoveSessionAfterTerminate('test', 'test', 'test', sceneInfo)).assertTrue();
      done();
    });

    it('listenerOnTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.on(0, 0, callback);
      sessionManager.off(1, 0, callback);
      sessionManager.off(0, 1, callback);
      sessionManager.off(0, 0, callback);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('registerOnFocusedCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.registerOnFocusedCallback(callback);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('getAspectRatioFromPreferenceTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.getAspectRatioFromPreference('test');
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('requestToTopAndProcessRecoverTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.requestToTop(0, -1);
      sessionManager.requestToTop(0, 1);
      sessionManager.processRecover(0, -1);
      sessionManager.processRecover(0, 1);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('requestFocusTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.requestFocus(undefined);
      sessionManager.requestFocus(1);
      sessionManager.requestUnfocus(undefined);
      sessionManager.requestUnfocus(1);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('updateNavigationBarPropertyTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.updateNavigationBarProperty();
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('registerSystemBarPropertyRecentCallbacksTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.registerSystemBarPropertyRecentCallbacks(callback);
      sessionManager.registerSystemBarPropertyRecentCallbacks(callback);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('registerGetAndUpdateScenePanelStateCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.registerGetScenePanelStateCallback(1, 1, callback);
      sessionManager.unregisterGetScenePanelStateCallback(0, 0);
      sessionManager.unregisterGetScenePanelStateCallback(1, 0);
      sessionManager.unregisterGetScenePanelStateCallback(1, 1);

      sessionManager.registerUpdateScenePanelStateCallback(1, 1, callback);
      sessionManager.unregisterUpdateScenePanelStateCallback(0, 0);
      sessionManager.unregisterUpdateScenePanelStateCallback(1, 0);
      sessionManager.unregisterUpdateScenePanelStateCallback(1, 1);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('registerGetAndUpdateScenePanelStateCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.initSystemSceneList(1);
      sessionManager.getSystemSceneSessionWithSystemType(0);
      sessionManager.getSystemSceneSessionWithSystemBarType(0);
      sessionManager.refreshAvailableArea(1);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('registerPiPOcclusiveChangeCallback', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.registerPiPOcclusiveChangeCallback(callback);
      sessionManager.unRegisterPiPOcclusiveChangeCallback();
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('registerGetAndUpdateScenePanelStateCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sessionInfo: SystemSessionInfo = {
        systemType: sceneSessionManager.SessionType.TYPE_PANEL,
        sceneName: 'test',
        sceneZIndex: 0,
        hitTestMode: HitTestMode.Default
      };
      let systemSceneSession = sessionManager.requestSystemSceneSession(sessionInfo);
      sessionManager.requestSystemSceneSessionDestruction(systemSceneSession);
      sessionManager.initSystemSceneList(1);

      sessionInfo = {
        systemType: sceneSessionManager.SessionType.TYPE_PANEL,
        sceneName: 'test02',
        sceneZIndex: 1,
        hitTestMode: HitTestMode.Default
      };
      sessionManager.requestSystemSceneSessionDestruction(systemSceneSession);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('reOrderShowWhenLockedTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sessionManager,
        sessionManager.isScreenLocked);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      sessionManager.reOrderShowWhenLocked();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      sessionManager.reOrderShowWhenLocked();
      mocker.clear(sessionManager);
      mocker.clearAll();
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('AppExitListenerTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.registerAppExitListener();
      sessionManager.unRegisterAppExitListener();
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('initSystemSceneList02Test', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sessionInfo: SystemSessionInfo = {
        systemType: sceneSessionManager.SessionType.TYPE_APP,
        sceneName: 'test',
        sceneZIndex: 0,
        hitTestMode: HitTestMode.Default
      };

      sessionManager.requestSystemSceneSession(sessionInfo, systemSessionChangeCallback, false, 10);
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(CheckEmptyUtils,
        CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      sessionManager.initSystemSceneList(10);

      sessionManager.requestSystemSceneSession(sessionInfo, systemSessionChangeCallback, false, 11);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      sessionManager.initSystemSceneList(11);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('isSplitMode01Test', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.registerGetFloatingSessionListCallback(getFloatingSessionListCallback);
      sessionManager.isSplitMode(111);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('isSplitMode02Test', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.registerGetFloatingSessionListCallback(getFloatingSessionList2Callback);
      sessionManager.isSplitMode(222);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('initTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.init();
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('onSpecialTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.onSpecial(1, 1, callback);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('registerRequestFocusCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.registerRequestFocusCallback(callback);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('unregisterOnFocusedCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.unregisterOnFocusedCallback(callback);

      sessionManager.registerOnFocusedCallback(callback2);
      sessionManager.unregisterOnFocusedCallback(callback2);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('registerOnNtfFloatingWindowCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.unregisterOnNtfFloatingWindowCallback(callback);
      sessionManager.notifyNtfFloatingWindowCallback();

      sessionManager.registerOnNtfFloatingWindowCallback(callback2);
      sessionManager.notifyNtfFloatingWindowCallback();
      sessionManager.unregisterOnNtfFloatingWindowCallback(callback2);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('registerOnGetFloatingRectCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let rect: RectItem = new RectItem(0, 0, 1, 1);
      let rectCallback: Function = () => {
        return rectCallback;
      }
      sessionManager.unregisterOnNtfFloatingWindowCallback(rectCallback);

      sessionManager.registerOnNtfFloatingWindowCallback(rectCallback);
      sessionManager.unregisterOnNtfFloatingWindowCallback(rectCallback);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });
    
    it('unregisterOnGetFloatingRectCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let rect: RectItem = new RectItem(0, 0, 1, 1);
      let rectCallback: Function = () => {
      }
      sessionManager.registerOnGetFloatingRectCallback(rectCallback);
      sessionManager.notifyNtfFloatingRect(rect);
      sessionManager.unregisterOnGetFloatingRectCallback(rectCallback);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('registerOnAnimationFinishedCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.notifyAnimationFinishedCallback(false);
      sessionManager.registerOnAnimationFinishedCallback(callback);

      sessionManager.notifyAnimationFinishedCallback(false);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('notifyGrayAppIconCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfo = new SCBSceneInfo('notifyGrayAppIconBundle',
        'notifyGrayAppIconMoudle', 'notifyGrayAppIconAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, screenProperty);
      sessionManager.notifyGrayAppIconCallback(scbSceneContainerSession, true);

      sessionManager.registerGrayAppIconCallback(callback);
      sessionManager.notifyGrayAppIconCallback(scbSceneContainerSession, true);
      sessionManager.unregisterGrayAppIconCallback();
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('registerOnUnfocusedCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.registerOnUnfocusedCallback(callback);
      sessionManager.unregisterOnUnfocusedCallback(callback);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('startSceneInVirtualTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfo = new SCBSceneInfo('startSceneInVirtualBundle',
        'startSceneInVirtualMoudle', 'startSceneInVirtualAbility');
      sessionManager.startSceneInVirtual(undefined);

      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isOobeActivated);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      sceneInfo.isCastScene = false;
      sessionManager.startSceneInVirtual(sceneInfo);
      sceneInfo.isCastScene = true;
      sessionManager.startSceneInVirtual(sceneInfo);

      const mockFunc2: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isTrustlistForWms);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      sessionManager.startSceneInVirtual(sceneInfo);
      expect(sessionManager !== undefined).assertTrue();
      mocker.clear(sSCBOobeManager);
      mocker.clearAll();
      done();
    });

    it('startSceneInVirtual02Test', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfo = new SCBSceneInfo('startSceneInVirtualBundle',
        'startSceneInVirtualMoudle', 'startSceneInVirtualAbility');
      sceneInfo.screenId = 111;
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isOobeActivated);
      sessionManager.registerVirtualScreenStartScene(virtualScreenStartSceneFunc, 111);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      sceneInfo.isCastScene = false;
      sessionManager.startSceneInVirtual(sceneInfo);
      sceneInfo.isCastScene = true;
      sessionManager.startSceneInVirtual(sceneInfo);
      expect(sessionManager !== undefined).assertTrue();
      mocker.clear(sSCBOobeManager);
      mocker.clearAll();
      done();
    });

    it('startFloatFromDockTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('startFloatFromDockBundle',
        'startFloatFromDockMoudle', 'startFloatFromDockAbility');
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isOobeActivated);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      sessionManager.startFloatFromDock(sceneInfo);
      const mockFunc2: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isTrustlistForWms);

      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      sessionManager.startFloatFromDock(sceneInfo);
      expect(sessionManager !== undefined).assertTrue();
      mocker.clear(sSCBOobeManager);
      mocker.clearAll();
      done();
    });

    it('transitionFloatTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('startFloatFromDockBundle',
        'startFloatFromDockMoudle', 'startFloatFromDockAbility');
      sessionManager.transitionFloat(undefined, 111);

      sessionManager.transitionFloat(sceneInfo, 111);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('isSampleManagerIntercepted01Test', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfo = new SCBSceneInfo('isSampleManagerInterceptedBundle',
        'isSampleManagerInterceptedMoudle', 'isSampleManagerInterceptedAbility');
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSampleManager,
        sSampleManager.isSampleManagerChecked);
      const mockFunc2: Function = mocker.mockFunc(sSampleManager,
        sSampleManager.isTrustlistForWms);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

      sessionManager.startSceneFromOther(sceneInfo);
      expect(sessionManager !== undefined).assertTrue();
      mocker.clear(sSampleManager);
      mocker.clearAll();
      done();
    });

    it('isSampleManagerIntercepted02Test', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfo = new SCBSceneInfo('isSampleManagerInterceptedBundle',
        'isSampleManagerInterceptedMoudle', 'isSampleManagerInterceptedAbility');
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSampleManager,
        sSampleManager.isSampleManagerChecked);
      const mockFunc2: Function = mocker.mockFunc(sSampleManager,
        sSampleManager.isTrustlistForWms);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

      sessionManager.startSceneFromOther(sceneInfo);
      expect(sessionManager !== undefined).assertTrue();
      mocker.clear(sSampleManager);
      mocker.clearAll();
      done();
    });

    it('startSceneFromPiPTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.startSceneFromPiP(111);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('startSceneFromPiP02Test', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.onShow(callback);
      sessionManager.startSceneFromPiP(111);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('executeCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.minimize(111, 112, 113);

      sessionManager.on(SCBEventId.MINIMIZE_SCENE, 111, callback);
      sessionManager.minimize(109, 112, 113);

      sessionManager.minimize(111, 112, 113);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('executeCloseCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.close(111, 112, 113);

      sessionManager.on(SCBEventId.CLOSE_SCENE, 111, callback);
      sessionManager.onSpecial(SCBEventId.CLOSE_SCENE, 111, callback);
      sessionManager.close(109, 112, 113);

      sessionManager.close(111, 112, 113);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('executeMinimizeAllSceneCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.minimizeAllFloatingScene(111);

      sessionManager.on(SCBEventId.MINIMIZE_ALL_FLOATING_SCENE, 111, callback);
      sessionManager.minimizeAllFloatingScene(109);

      sessionManager.minimizeAllFloatingScene(111);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('executeSpecialMinimizeAllSceneCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.minimizeAllFloatingScene(111);

      sessionManager.onSpecial(SCBEventId.MINIMIZE_ALL_FLOATING_SCENE, 111, callback);
      sessionManager.minimizeAllFloatingScene(109);

      sessionManager.minimizeAllFloatingScene(111);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('executeSpecialMinimizeAllSceneCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.minimizeAllFloatingScene(111);

      sessionManager.onSpecial(SCBEventId.MINIMIZE_ALL_FLOATING_SCENE, 111, callback);
      sessionManager.minimizeAllFloatingScene(109);

      sessionManager.minimizeAllFloatingScene(111);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('isFullSceneModeTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.isFullSceneMode();
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('changeSessionVisWithStatusBarTransitionTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfoTo = new SCBSceneInfo('changeSessionBundleTo',
        'changeSessionMoudleTo', 'changeSessionAbilityTo');
      let sceneInfoFrom = new SCBSceneInfo('changeSessionBundleFrom',
        'changeSessionMoudleFrom', 'changeSessionAbilityFrom');
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sessionManager,
        sessionManager.changeSessionVisWithStatusBarFromOther);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      sceneInfoTo.persistentId = 111;
      sceneInfoFrom.persistentId = 222;
      sessionManager.changeSessionVisWithStatusBarTransition(sceneInfoTo, sceneInfoFrom, false);
      mocker.clear(SCBScreenSessionManager.getInstance());
      mocker.clearAll();
      done();
    });

    it('changeSessionVisWithStatusBarTransition02Test', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfoTo = new SCBSceneInfo('changeSessionBundleTo',
        'changeSessionMoudleTo', 'changeSessionAbilityTo');
      let sceneInfoFrom = new SCBSceneInfo('changeSessionBundleFrom',
        'changeSessionMoudleFrom', 'changeSessionAbilityFrom');
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sessionManager,
        sessionManager.changeSessionVisWithStatusBarFromOther);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      sceneInfoTo.persistentId = 222;
      sceneInfoFrom.persistentId = 222;
      sessionManager.changeSessionVisWithStatusBarTransition(sceneInfoTo, sceneInfoFrom, false);
      mocker.clear(SCBScreenSessionManager.getInstance());
      mocker.clearAll();
      done();
    });

    it('hiddenStartSceneTransitionTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfoTo = new SCBSceneInfo('hiddenStartSceneBundleTo',
        'hiddenStartSceneMoudleTo', 'hiddenStartSceneAbilityTo');
      let sceneInfoFrom = new SCBSceneInfo('hiddenStartSceneBundleFrom',
        'hiddenStartSceneMoudleFrom', 'hiddenStartSceneAbilityFrom');
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sessionManager,
        sessionManager.hiddenStartSceneFromOther);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      sceneInfoTo.persistentId = 111;
      sceneInfoFrom.persistentId = 222;
      sessionManager.hiddenStartSceneTransition(sceneInfoTo, sceneInfoFrom);
      mocker.clear(SCBScreenSessionManager.getInstance());
      mocker.clearAll();
      done();
    });

    it('startSceneByCallTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfoTo = new SCBSceneInfo('hiddenStartSceneBundleTo',
        'hiddenStartSceneMoudleTo', 'hiddenStartSceneAbilityTo');
      sceneInfoTo.screenId = 109;
      let sceneInfoFrom = new SCBSceneInfo('hiddenStartSceneBundleFrom',
        'hiddenStartSceneMoudleFrom', 'hiddenStartSceneAbilityFrom');
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isOobeActivated);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      sessionManager.startSceneByCall(sceneInfoTo, sceneInfoFrom);
      expect(sessionManager !== undefined).assertTrue();
      mocker.clear(sSCBOobeManager);
      mocker.clearAll();
      done();
    });

    it('startSceneByCall02Test', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfoTo = new SCBSceneInfo('hiddenStartSceneBundleTo',
        'hiddenStartSceneMoudleTo', 'hiddenStartSceneAbilityTo');
      sceneInfoTo.screenId = 109;
      let sceneInfoFrom = new SCBSceneInfo('hiddenStartSceneBundleFrom',
        'hiddenStartSceneMoudleFrom', 'hiddenStartSceneAbilityFrom');
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isOobeActivated);
      const mockFunc2: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isTrustlistForWms);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      sessionManager.startSceneByCall(sceneInfoTo, sceneInfoFrom);
      expect(sessionManager !== undefined).assertTrue();
      mocker.clear(sSCBOobeManager);
      mocker.clearAll();
      done();
    });

    it('startSceneFromOtherAboveKeyguardTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfoTo = new SCBSceneInfo('hiddenStartSceneBundleTo',
        'hiddenStartSceneMoudleTo', 'hiddenStartSceneAbilityTo');
      sceneInfoTo.screenId = 109;
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isOobeActivated);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      sessionManager.startSceneFromOtherAboveKeyguard(sceneInfoTo);
      expect(sessionManager !== undefined).assertTrue();
      mocker.clear(sSCBOobeManager);
      mocker.clearAll();
      done();
    });

    it('startSceneFromOtherAboveKeyguard02Test', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfoTo = new SCBSceneInfo('hiddenStartSceneBundleTo',
        'hiddenStartSceneMoudleTo', 'hiddenStartSceneAbilityTo');
      sceneInfoTo.screenId = 109;
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isOobeActivated);
      const mockFunc2: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isTrustlistForWms);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      sessionManager.startSceneFromOtherAboveKeyguard(sceneInfoTo);
      expect(sessionManager !== undefined).assertTrue();
      mocker.clear(sSCBOobeManager);
      mocker.clearAll();
      done();
    });

    it('startSceneTransition03Test', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfoTo = new SCBSceneInfo('startSceneTransitionBundle',
        'startSceneTransitionMoudle', 'startSceneTransitionAbility');
      sceneInfoTo.screenId = 109;
      let sceneInfoFrom = new SCBSceneInfo('startSceneTransitionFromBundle',
        'startSceneTransitionFromMoudle', 'startSceneTransitionFromAbility');
      sceneInfoFrom.screenId = 113;
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isOobeActivated);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      sceneInfoTo.persistentId = 111;
      sceneInfoFrom.persistentId = 222;
      sessionManager.startSceneTransition(sceneInfoTo, sceneInfoFrom);
      expect(sessionManager !== undefined).assertTrue();
      mocker.clear(sSCBOobeManager);
      mocker.clearAll();
      done();
    });

    it('startSceneTransition04Test', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfoTo = new SCBSceneInfo('startSceneTransitionBundle',
        'startSceneTransitionMoudle', 'startSceneTransitionAbility');
      sceneInfoTo.screenId = 109;
      let sceneInfoFrom = new SCBSceneInfo('startSceneTransitionFromBundle',
        'startSceneTransitionFromMoudle', 'startSceneTransitionFromAbility');
      sceneInfoFrom.screenId = 113;
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isOobeActivated);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      sceneInfoTo.persistentId = 222;
      sceneInfoFrom.persistentId = 222;
      sessionManager.startSceneTransition(sceneInfoTo, sceneInfoFrom);
      expect(sessionManager !== undefined).assertTrue();
      mocker.clear(sSCBOobeManager);
      mocker.clearAll();
      done();
    });

    it('startSceneTransition05Test', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfoTo = new SCBSceneInfo('com.ohos.callui',
        'testMoudle', 'com.ohos.callui.MainAbility');
      sceneInfoTo.screenId = 109;
      let sceneInfoFrom = new SCBSceneInfo('startSceneTransitionFromBundle',
        'startSceneTransitionFromMoudle', 'startSceneTransitionFromAbility');
      sceneInfoFrom.screenId = 113;
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isOobeActivated);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      sceneInfoTo.persistentId = 111;
      sceneInfoFrom.persistentId = 222;
      sessionManager.startSceneTransition(sceneInfoTo, sceneInfoFrom);
      expect(sessionManager !== undefined).assertTrue();
      mocker.clear(sSCBOobeManager);
      mocker.clearAll();
      done();
    });

    it('startSceneFromNotificationTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfoTo = new SCBSceneInfo('com.ohos.callui',
        'testMoudle', 'com.ohos.callui.MainAbility');
      sceneInfoTo.screenId = 109;
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isOobeActivated);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      sceneInfoTo.persistentId = 111;
      sessionManager.startSceneFromNotification(sceneInfoTo);
      expect(sessionManager !== undefined).assertTrue();
      mocker.clear(sSCBOobeManager);
      mocker.clearAll();
      done();
    });

    it('startSceneFromNotification02Test', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfoTo = new SCBSceneInfo('com.ohos.callui',
        'testMoudle', 'com.ohos.callui.MainAbility');
      sceneInfoTo.screenId = 109;
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isOobeActivated);
      const mockFunc2: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isTrustlistForWms);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      sceneInfoTo.persistentId = 111;
      sessionManager.startSceneFromNotification(sceneInfoTo);
      expect(sessionManager !== undefined).assertTrue();
      mocker.clear(sSCBOobeManager);
      mocker.clearAll();
      done();
    });

    it('updateSessionDisplayIdTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.updateSessionDisplayId(-1, -1);
      sessionManager.updateSessionDisplayId(111, -1);
      sessionManager.updateSessionDisplayId(-1, 109);
      sessionManager.updateSessionDisplayId(111, 109);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('notifyResetSplitViewDividerParamTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfo = new SCBSceneInfo('notifyResetSplitViewDividerParamBundle',
        'notifyResetSplitViewDividerParamMoudle', 'notifyResetSplitViewDividerParamAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(scbSceneSession, screenProperty);

      sessionManager.notifyResetSplitViewWithFold(null);
      sessionManager.notifyResetSplitViewWithFold(undefined);

      sessionManager.notifyResetSplitViewWithFold(scbSceneContainerSession);

      scbSceneContainerSession.dividerParam.needCancelDividerEvent = true;
      sessionManager.notifyResetSplitViewWithFold(scbSceneContainerSession);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('notifyExitGameSplitTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfo = new SCBSceneInfo('setIsShowStatusBar02Bundle',
        'setIsShowStatusBar02Moudle', 'setIsShowStatusBar02Ability');
      sceneInfo.persistentId = 212;
      sceneInfo.screenId = 201;
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, screenProperty);

      sessionManager.notifyExitGameSplit(null);
      sessionManager.notifyExitGameSplit(scbSceneContainerSession);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('notifyExitGameSplitTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfo = new SCBSceneInfo('setIsShowStatusBar02Bundle',
        'setIsShowStatusBar02Moudle', 'setIsShowStatusBar02Ability');
      sceneInfo.persistentId = 212;
      sceneInfo.screenId = 201;
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, screenProperty);

      sessionManager.notifyExitGameSplit(null);
      sessionManager.notifyExitGameSplit(scbSceneContainerSession);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('onPendingCastSceneTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().getScreenSession);
      when(mockFunc)(ArgumentMatchers.any).afterReturn('CastEngine');
      let sceneInfo = new SCBSceneInfo('setIsShowStatusBar02Bundle',
        'setIsShowStatusBar02Moudle', 'setIsShowStatusBar02Ability');
      sceneInfo.persistentId = 212;
      sceneInfo.screenId = 201;
      expect(sessionManager.onPendingCastScene(sceneInfo, sceneInfo)).assertFalse()
      mocker.clear(SCBScreenSessionManager.getInstance());
      mocker.clearAll();
      done();
    });

    it('notifyAINavigationBarShowStatusTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.notifyAINavigationBarShowStatus(false, null, 109);
      sessionManager.notifyAINavigationBarShowStatus(false, undefined, 109);
      let iconRect: RectInfo = { left: 0, top: 0, right: 0, bottom: 0 };
      sessionManager.notifyAINavigationBarShowStatus(false, iconRect, 109);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('notifyAINavigationBarShowStatus02Test', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let iconRect: RectInfo = { left: 0, top: 0, right: 0, bottom: 0 };
      sessionManager.registerNavChangeCallback(callback);
      sessionManager.notifyAINavigationBarShowStatus(false, iconRect, 109);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('callRecentFuncsTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.callRecentFuncs(false);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('callRecentFuncs02Test', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.processSystemRecentEvent();
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('sendTouchEventTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.sendTouchEvent(undefined, 10);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('updateKeyguardOccludedStateTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneFlag: number = OccludeKeygaurdScene.SPECIAL;
      sessionManager.updateKeyguardOccludedState(sceneFlag, false);

      sessionManager.registerKeyguardOccludedChangeCallbacks(callback);
      sessionManager.updateKeyguardOccludedState(sceneFlag, true);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('registerClearToggleHomeSceneCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const testCallback: Function = () => {};
      sessionManager.registerClearToggleHomeSceneCallback(testCallback);
      expect(sessionManager !== undefined).assertTrue();
      sessionManager.unRegisterClearToggleHomeSceneCallback(testCallback);
      done();
    });

    it('unRegisterClearToggleHomeSceneCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const testCallback: Function = () => {};
      sessionManager.registerClearToggleHomeSceneCallback(testCallback);
      sessionManager.unRegisterClearToggleHomeSceneCallback(testCallback);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('clearToggleHomeSceneTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.clearToggleHomeScene();
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('registerIsPairSplitCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const testCallback: Function = () => {};
      const testScreenId: number = 0;
      sessionManager.registerIsPairSplitCallback(testCallback, testScreenId);
      expect(sessionManager !== undefined).assertTrue();
      sessionManager.unRegisterIsPairSplitCallback(testScreenId);
      done();
    });

    it('unRegisterIsPairSplitCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const testCallback: Function = () => {};
      const testScreenId: number = 0;
      sessionManager.registerIsPairSplitCallback(testCallback, testScreenId);
      sessionManager.unRegisterIsPairSplitCallback(testScreenId);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('registerPipRestoreCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const testCallback: Function = () => {};
      const testScreenId: number = 0;
      sessionManager.registerPipRestoreCallback(testCallback, testScreenId);
      expect(sessionManager !== undefined).assertTrue();
      sessionManager.unregisterPipRestoreCallback(testScreenId);
      done();
    });

    it('unregisterPipRestoreCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const testCallback: Function = () => {};
      const testScreenId: number = 0;
      sessionManager.registerPipRestoreCallback(testCallback, testScreenId);
      sessionManager.unregisterPipRestoreCallback(testScreenId);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('startSceneByPipRestoreTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const testCallback: Function = () => {};
      const testScreenId: number = 0;
      sessionManager.registerPipRestoreCallback(testCallback, testScreenId);
      sessionManager.startSceneByPipRestore(99, true, testScreenId);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('getIsAnyScenePanelIsPairSplitTest_01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.getIsAnyScenePanelIsPairSplit();
      expect(sessionManager !== undefined).assertTrue();
      done();
    });
    it('getIsAnyScenePanelIsPairSplitTest_02', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.getIsAnyScenePanelIsPairSplit();
      expect(sessionManager.getIsAnyScenePanelIsPairSplit()).assertFalse();
      done();
    });

    it('registerIsHandleThreeFingerSwiperCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const testCallback: Function = () => {};
      const testScreenId: number = 0;
      sessionManager.registerIsHandleThreeFingerSwiperCallback(testCallback, testScreenId);
      expect(sessionManager !== undefined).assertTrue();
      sessionManager.unRegisterIsHandleThreeFingerSwiperCallback(testScreenId);
      done();
    });

    it('unRegisterIsHandleThreeFingerSwiperCallbackTest', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const testCallback: Function = () => {};
      const testScreenId: number = 0;
      sessionManager.registerIsHandleThreeFingerSwiperCallback(testCallback, testScreenId);
      sessionManager.unRegisterIsHandleThreeFingerSwiperCallback(testScreenId);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('getIsHandleThreeFingerSwiperTest_01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.getIsHandleThreeFingerSwiper();
      expect(sessionManager !== undefined).assertTrue();
      done();
    });
    it('getIsHandleThreeFingerSwiperTest_02', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      expect(sessionManager.getIsHandleThreeFingerSwiper()).assertFalse();
      done();
    });
    it('getTopFullScreenSubSession_01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      expect(sessionManager !== undefined).assertTrue();
      let sceneInfo = new SCBSceneInfo('getTopFullScreenSubSession',
        'getTopFullScreenSubSession', 'getTopFullScreenSubSession');
      sceneInfo.persistentId = 111;
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneContainerSession: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, screenProperty);
      let subSession = sessionManager.getTopFullScreenSubSession(0, scbSceneContainerSession);
      expect(subSession === undefined).assertTrue();
      done();
    });
    it('registerPipCallbackTest_01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const testCallback: Function = (persistentId: number) => {};
      sessionManager.registerPipCallback(testCallback);
      expect(sessionManager !== undefined).assertTrue();
      sessionManager.unregisterPipCallback();
      done();
    });
    it('unregisterPipCallbackTest_01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const testCallback: Function = (persistentId: number) => {};
      sessionManager.registerPipCallback(testCallback);
      sessionManager.unregisterPipCallback();
      expect(sessionManager !== undefined).assertTrue();
      done();
    });
    it('starPipRestoreTest_01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const testCallback: Function = (persistentId: number) => {};
      const testPersistentId: number = 0;
      sessionManager.registerPipCallback(testCallback);
      sessionManager.starPipRestore(testPersistentId);
      expect(sessionManager !== undefined).assertTrue();
      sessionManager.unregisterPipCallback();
      done();
    });
    it('setProjectionBundleNameTest_01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const testBundleName: string = 'com.ohos.himovie';
      const testScreenId: number = 1001;
      sessionManager.setProjectionBundleName(testBundleName, testScreenId);
      expect(sessionManager !== undefined).assertTrue();
      sessionManager.setProjectionBundleName('', 0);
      done();
    });
    it('isProjectionBundleNameTest_01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const testBundleName: string = 'com.ohos.himovie';
      const testScreenId: number = 0;
      sessionManager.setProjectionBundleName(testBundleName, testScreenId);
      let ret: boolean = sessionManager.isProjectionBundleName(testBundleName);
      expect(ret === false).assertTrue();
      sessionManager.setProjectionBundleName('', 0);
      done();
    });
    it('isProjectionBundleNameTest_02', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const testBundleName: string = 'com.ohos.himovie';
      const testScreenId: number = 1001;
      sessionManager.setProjectionBundleName(testBundleName, testScreenId);
      let ret: boolean = sessionManager.isProjectionBundleName('');
      expect(ret === false).assertTrue();
      sessionManager.setProjectionBundleName('', 0);
      done();
    });
    it('isProjectionBundleNameTest_03', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let displayInfos: display.Display[] = await display.getAllDisplays();
      let testScreenId: number = 0;
      displayInfos.forEach((displayInfo: display.Display) => {
        if (displayInfo?.name === 'PadWithCar') {
          testScreenId = displayInfo.id;
        }
      });
      const testBundleName: string = 'com.ohos.himovie';
      sessionManager.setProjectionBundleName(testBundleName, testScreenId);
      let ret: boolean = sessionManager.isProjectionBundleName('com.ohos.himovie');
      if (testScreenId === 0) {
        expect(ret === false).assertTrue();
      } else {
        expect(ret === true).assertTrue();
      }
      sessionManager.setProjectionBundleName('', 0);
      done();
    });
    it('isProjectionBundleNameTest_04', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let displayInfos: display.Display[] = await display.getAllDisplays();
      let testScreenId: number = 0;
      displayInfos.forEach((displayInfo: display.Display) => {
        if (displayInfo?.name === 'PadWithCar') {
          testScreenId = displayInfo.id;
        }
      });
      const testBundleName: string = 'com.ohos.himovie';
      sessionManager.setProjectionBundleName(testBundleName, testScreenId);
      let ret: boolean = sessionManager.isProjectionBundleName('test');
      expect(ret === false).assertTrue();
      sessionManager.setProjectionBundleName('', 0);
      done();
    });

    it('handleExtendScreenSessionRecover', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      // isPC mock测试
      const mocker: MockKit = new MockKit();
      let isPC = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);

      when(isPC)(ArgumentMatchers.any).afterReturn(false);
      expect(DeviceHelper.isPC()).assertFalse();
      sessionManager.handleExtendScreenSessionRecover();
      expect(ReflectionUtils.getProperty(sessionManager, 'recoverSceneSessionList').size === 0).assertTrue();

      when(isPC)(ArgumentMatchers.any).afterReturn(true);
      expect(DeviceHelper.isPC()).assertTrue();
      sessionManager.handleExtendScreenSessionRecover();
      expect(ReflectionUtils.getProperty(sessionManager, 'recoverSceneSessionList').size === 0).assertTrue();
      done();
    });
    it('registerDockAvoidWindowCallback', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.registerDockAvoidWindowCallback(callback);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });
    it('unregisterDockAvoidWindowCallback', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.unregisterDockAvoidWindowCallback();
      expect(sessionManager !== undefined).assertTrue();
      done();
    });
    it('notifyDockAvoidWindow', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.notifyDockAvoidWindow(-1, true);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });
    it('existWindowOverlappedByDock', 0, async (done: Function) => {
      let sceneInfo = new SCBSceneInfo('existWindowOverlappedByDock',
        'existWindowOverlappedByDock', 'existWindowOverlappedByDock');
      sceneInfo.screenId = 221;
      sceneInfo.persistentId = 225;
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      scbSceneSession.currRect.setRectNum(100, 100, 500, 500);
      let sessionManager = SCBSceneSessionManager.getInstance();
      expect(sessionManager.existWindowOverlappedByDock(225)).assertFalse();
      expect(sessionManager.existWindowOverlappedByDock(-1)).assertFalse();
      done();
    });

    it('onRecoverSessionTest', 0, async  (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfo = new SCBSceneInfo('onRecoverSessionTestBundle',
        'onRecoverSessionTestModule', 'onRecoverSessionTestAbility');
      sceneInfo.screenId = 201;
      sceneInfo.persistentId = 211;
      let sceneSession: sceneSessionManager.SceneSession = sceneSessionManager.requestSceneSession(sceneInfo);
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSession, sceneInfo);
      let sceneRecoverInfo: sceneSessionManager.SceneRecoverInfo = {
        bundleName: 'onRecoverSessionTestBundle',
        moduleName: 'onRecoverSessionTestModule',
        abilityName: 'onRecoverSessionTestAbility',
        appIndex: 101,
        screenId: 201,
        windowMode: 0,
        sessionState: 1,
        sessionType: sceneSessionManager.SessionType.TYPE_APP,
        requestOrientation: 0,
        recoverRect: {
          posX_: 0,
          posY_: 0,
          width_: 1080,
          height_: 1920
        },
        layoutFullScreen: true,
        mainWindowTopmost: true,
        currentRotation: 0,
        transitionAnimationMap: new Map(),
        supportWindowModes: [0, 1, 2]
      };
      ReflectionUtils.useFunc(sessionManager, 'onRecoverSession', sceneSession, sceneRecoverInfo);
      expect(scbSceneSession.sessionData.transitionAnimationConfig).assertNull();
      done();
    });

    it('notifySetRotationBySystemWantAnimationTest_01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let systemWantAnimation = true;
      sessionManager.notifySetSystemSceneRotaion(screenProperty, systemWantAnimation);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });
    it('notifySetRotationBySystemWantAnimationTest_02', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let systemWantAnimation = false;
      sessionManager.notifySetSystemSceneRotaion(screenProperty, systemWantAnimation);
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('getTopContainerSession_test', 0, () => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundle', 'testModule', 'testAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let panelSession: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, screenProperty);
      let mocker = new MockKit();
      let func: Function = mocker.mockFunc(sessionManager, sessionManager.onRemoveContainerSession);
      when(func)(ArgumentMatchers.any).afterReturn([panelSession]);
      let session: SCBSceneContainerSession | null = ReflectionUtils.useFunc(sessionManager, 'getTopContainerSession',
        0);
      mocker.clear(sessionManager);
      mocker.clearAll();
      expect(session !== null).assertTrue();
    });

    it('execAdditionalCallersCallback_test', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.registerClearAdditionalCallersCallback(callback);
      sessionManager.execAdditionalCallersCallback();
      expect(sessionManager !== undefined).assertTrue();
      done();
    });
  })
}