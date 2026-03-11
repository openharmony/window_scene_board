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
} from '../../../../../../../..';
import {
  SCBScreenSessionManager
} from '../../../../../../../main/ets/screen/session/SCBScreenSessionManager';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  SCBSceneSessionManager,
  ScenePanelState,
  UserSwitchEventType
} from '../../../../../../../main/ets/scene/session/SCBSceneSessionManager';
import type {
  SCBUnlockTransitionController
} from '../../../../../../../main/ets/animation/SCBTransitionManager';
import sSCBOobeManager from '../../../../../../../main/ets/oobe/SCBOobeManager';
import { ReflectionUtils } from '../../utils/ReflectionUtils';
import { sSettingsUtil } from '@ohos/frameworkwrapper';
import type { AbilityItemInfo } from '../../../../../../../main/ets/bean/AbilityItemInfo';
import display from '@ohos.display';
import { bundleManager } from '@kit.AbilityKit'
import { WindowSize } from '../../../../../../../main/ets/bean/AbilityItemInfo';

export function SCBSceneSessionManagerFourTest() {
  describe('SCBSceneSessionManagerFourTest', () => {
    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterEach(() => {
    });
    afterAll(() => {
    });

    it('handleUserSwitchEventTest01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      ReflectionUtils.setProperty(sessionManager,
        'mCurrentUserId', 100)
      sessionManager.handleUserSwitchEvent(UserSwitchEventType.SWITCHING, 100);
      expect(ReflectionUtils.getProperty(sessionManager,
        'mCurrentUserId')).assertEqual(100);
      done();
    });

    it('handleUserSwitchEventTest02', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      ReflectionUtils.setProperty(sessionManager,
        'mCurrentUserId', 50)
      sessionManager.handleUserSwitchEvent(UserSwitchEventType.SWITCHING, 100);
      expect(sessionManager !== undefined).assertTrue();
      expect(ReflectionUtils.getProperty(sessionManager,
        'mCurrentUserId')).assertEqual(50);
      done();
    });

    it('initDefaultDensityDpiTest01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sSettingsUtil.setValue('system_default_dpi_value', '1080');
      ReflectionUtils.useFunc(sessionManager, 'initDefaultDensityDpi')
      expect(ReflectionUtils.getProperty(sessionManager,
        'defaultDensityDpi')).assertEqual(1080);
      done();
    });

    it('constrainTest01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      expect(ReflectionUtils.useFunc(sessionManager,
        'constrain', 1, 2, 3)).assertEqual(2);
      expect(ReflectionUtils.useFunc(sessionManager,
        'constrain', 4, 0, 3)).assertEqual(3);
      expect(ReflectionUtils.useFunc(sessionManager,
        'constrain', 1, 0, 1)).assertEqual(1);
      done();
    });

    it('notifyWMSIsLockReceivedTest01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.notifyWMSIsLockReceived(false);
      expect(ReflectionUtils.getProperty(sessionManager, 'isScreenEarlyLock')).assertFalse();
      done();
    });

    it('notifyWMSIsLockReceivedTest02', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const func = () => {
        return true;
      }
      sessionManager.registerPiPOcclusiveChangeCallback(func)
      sessionManager.notifyWMSIsLockReceived(true);
      expect(ReflectionUtils.getProperty(sessionManager, 'isScreenEarlyLock')).assertTrue();
      done();
    });

    it('notifyWMSIsLockReceivedTest03', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      sessionManager.unRegisterPiPOcclusiveChangeCallback();
      sessionManager.notifyWMSIsLockReceived(true);
      expect(ReflectionUtils.getProperty(sessionManager, 'isScreenEarlyLock')).assertTrue();
      done();
    });

    it('onLockReceiveddTest02', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      ReflectionUtils.setProperty(sessionManager, 'isScreenLock', true);
      ReflectionUtils.useFunc(sessionManager, 'onLockReceived');
      expect(ReflectionUtils.getProperty(sessionManager, 'isScreenLock')).assertTrue();
      done();
    });

    it('clearActiveSessionWhenUnLockTest01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      ReflectionUtils.setProperty(sessionManager, 'isFirstSwitchFolderUnlock', true);
      let mocker: MockKit = new MockKit();
      let sreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      expect(sreenSessionManager).not().assertNull();
      let mockFunc1 : Function = mocker.mockFunc(sreenSessionManager, sreenSessionManager.isFoldablePhoneExpandStatus);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      ReflectionUtils.useFunc(sessionManager, 'clearActiveSessionWhenUnLock');
      expect(ReflectionUtils.getProperty(sessionManager, 'isFirstSwitchFolderUnlock')).assertFalse();
      mocker.clear(sreenSessionManager);
      mocker.clearAll();
      done();
    });

    it('clearActiveSessionWhenUnLockTest02', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let mocker: MockKit = new MockKit();
      let sreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      expect(sreenSessionManager).not().assertNull();
      let mockFunc1 : Function = mocker.mockFunc(sreenSessionManager, sreenSessionManager.isFoldablePhoneExpandStatus);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      ReflectionUtils.useFunc(sessionManager, 'clearActiveSessionWhenUnLock');
      expect(ReflectionUtils.getProperty(sessionManager, 'isFirstSwitchFolderUnlock')).assertFalse();
      mocker.clear(sreenSessionManager);
      mocker.clearAll();
      done();
    });

    it('requestActivationWhenfoldStatusChangeTest01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      ReflectionUtils.setProperty(sessionManager, 'isScreenLock', false);
      ReflectionUtils.useFunc(sessionManager,
        'requestActivationWhenfoldStatusChange', display.FoldStatus.FOLD_STATUS_FOLDED);
      expect(ReflectionUtils.getProperty(sessionManager, 'isScreenLock')).assertFalse();

      ReflectionUtils.setProperty(sessionManager, 'isScreenLock', true);
      ReflectionUtils.setProperty(sessionManager, 'lastfoldStatus', display.FoldStatus.FOLD_STATUS_HALF_FOLDED);
      ReflectionUtils.useFunc(sessionManager,
        'requestActivationWhenfoldStatusChange', display.FoldStatus.FOLD_STATUS_FOLDED);
      expect(ReflectionUtils.getProperty(sessionManager,
        'lastfoldStatus')).assertEqual(display.FoldStatus.FOLD_STATUS_HALF_FOLDED);

      ReflectionUtils.setProperty(sessionManager, 'isScreenLock', true);
      ReflectionUtils.setProperty(sessionManager, 'lastfoldStatus', display.FoldStatus.FOLD_STATUS_FOLDED);
      ReflectionUtils.useFunc(sessionManager,
        'requestActivationWhenfoldStatusChange', display.FoldStatus.FOLD_STATUS_FOLDED);
      expect(ReflectionUtils.getProperty(sessionManager,
        'lastfoldStatus')).assertEqual(display.FoldStatus.FOLD_STATUS_FOLDED);

      ReflectionUtils.setProperty(sessionManager, 'isScreenLock', true);
      ReflectionUtils.setProperty(sessionManager, 'lastfoldStatus', display.FoldStatus.FOLD_STATUS_HALF_FOLDED);
      ReflectionUtils.useFunc(sessionManager,
        'requestActivationWhenfoldStatusChange', display.FoldStatus.FOLD_STATUS_EXPANDED);
      expect(ReflectionUtils.getProperty(sessionManager,
        'lastfoldStatus')).assertEqual(display.FoldStatus.FOLD_STATUS_HALF_FOLDED);
      done();
    });

    it('getOobeContainerSessionTest01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      ReflectionUtils.useFunc(sessionManager, 'getOobeContainerSession');
      expect(sessionManager !== undefined).assertTrue();
      done();
    });

    it('restartOobeIfNeedTest01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isOobeActivated);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(ReflectionUtils.useFunc(sessionManager,
        'restartOobeIfNeed', false)).assertFalse();
      mocker.clear(sSCBOobeManager);
      mocker.clearAll();
      done();
    });

    it('restartOobeIfNeedTest02', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isOobeActivated);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

      ReflectionUtils.setProperty(sessionManager, 'supportPcMode', false);
      expect(ReflectionUtils.useFunc(sessionManager,
        'restartOobeIfNeed', false)).assertFalse();
      mocker.clear(sSCBOobeManager);
      mocker.clearAll();
      done();
    });

    it('restartOobeIfNeedTest03', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isOobeActivated);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

      expect(ReflectionUtils.useFunc(sessionManager,
        'restartOobeIfNeed', true)).assertFalse();
      mocker.clear(sSCBOobeManager);
      mocker.clearAll();
      done();
    });

    it('reLinkOobeIfNeedTest01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isOobeActivated);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

      ReflectionUtils.useFunc(sessionManager, 'reLinkOobeIfNeed');
      expect(sessionManager !== undefined).assertTrue()
      mocker.clear(sSCBOobeManager);
      mocker.clearAll();
      done();
    });

    it('reLinkOobeIfNeedTest02', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sSCBOobeManager,
        sSCBOobeManager.isOobeActivated);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

      ReflectionUtils.useFunc(sessionManager, 'reLinkOobeIfNeed');
      expect(sessionManager !== undefined).assertTrue()
      mocker.clear(sSCBOobeManager);
      mocker.clearAll();
      done();
    });

    it('handleStartSceneWithRotationCallbackTest01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      let sceneInfo = new SCBSceneInfo('notifyResetSplitViewDividerParamBundle',
        'notifyResetSplitViewDividerParamMoudle', 'notifyResetSplitViewDividerParamAbility');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let sceneContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(scbSceneSession, screenProperty);
      expect(ReflectionUtils.useFunc(sessionManager, 'handleStartSceneWithRotationCallback',
        sceneContainerSession, ScenePanelState.HOME)).assertEqual(ScenePanelState.HOME);
      expect(ReflectionUtils.useFunc(sessionManager, 'handleStartSceneWithRotationCallback',
        sceneContainerSession, ScenePanelState.FULLSCENE)).assertEqual(ScenePanelState.FULLSCENE);
      done();
    });

    it('setCurrentUserIdTest01', 0, async (done: Function) => {
      let sessionManager = SCBSceneSessionManager.getInstance();
      ReflectionUtils.setProperty(sessionManager, 'mCurrentUserId', -1);
      ReflectionUtils.useFunc(sessionManager, 'setCurrentUserId', -1);
      expect(ReflectionUtils.getProperty(sessionManager,
        'mCurrentUserId')).assertEqual(-1);

      ReflectionUtils.useFunc(sessionManager, 'setCurrentUserId', 100);
      expect(ReflectionUtils.getProperty(sessionManager,
        'mCurrentUserId')).assertEqual(100);

      ReflectionUtils.useFunc(sessionManager, 'setCurrentUserId', 200);
      expect(ReflectionUtils.getProperty(sessionManager,
        'mCurrentUserId')).assertEqual(200);
      done();
    });

    it('getAbilityInfoTest01', 0, async (done: Function) => {
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
        name: '',
        launchType: bundleManager.LaunchType.SINGLETON,
        supportWindowModes: [],
        windowSize: new WindowSize,
        orientation: bundleManager.DisplayOrientation.UNSPECIFIED,
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
      expect(sessionManager.getAbilityInfo(bundleName, moduleName, abilityName)).not().assertNull();

      expect(sessionManager.getAbilityInfo('bundleNameTest2', moduleName, abilityName)).assertNull();
      done();
    });
  })
}