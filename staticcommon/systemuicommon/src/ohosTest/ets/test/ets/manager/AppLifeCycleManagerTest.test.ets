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
import { Singleton } from '../../../main/ets/utils/Singleton';
import { abilityManager, appManager } from '@kit.AbilityKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { EventEmitter } from '../../../main/ets/utils/EventEmitter';
import { PipSceneManager } from '../../../main/ets/manager/PipSceneManager';
import { LiveNotification } from '../../../main/ets/live/model/LiveNotification';
import { InnerEventUtil } from '../../../main/ets/utils/InnerEventUtil';
import { AbilityStateChangedEvent } from '@ohos/frameworkwrapper';
import { AbilityState } from '../../../main/ets/plugin/PhoneAppManager';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { AppLifeCycleManager } from '../../../main/ets/manager/AppLifeCycleManager';
export default function AppLifeCycleManagerTest() {
  describe('init_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_error_when_init_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let applifecyclemanager: AppLifeCycleManager = new AppLifeCycleManager();
      await applifecyclemanager.init();

      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_register_ability_state_observer_and_call_onAbilityStateChanged_when_init_succeeds', 0, async () => {
      let mocker: MockKit = new MockKit();
      let abilityManager: abilityManager = abilityManager.getAbilityManager();
      let logHelper: LogHelper = LogHelper.getInstance();
      let pipSceneManager: PipSceneManager = new PipSceneManager();
      let liveNotification: LiveNotification = new LiveNotification();
      let eventEmitter: EventEmitter = new EventEmitter();

      let mockGetForegroundUIAbilities: Function = mocker.mockFunc(abilityManager, abilityManager.getForegroundUIAbilities);
      let mockOn: Function = mocker.mockFunc(abilityManager, abilityManager.on);
      let mockInnerEventUtilOn: Function = mocker.mockFunc(InnerEventUtil, InnerEventUtil.on);

      when(mockGetForegroundUIAbilities)().afterReturn([new AbilityState()]);
      when(mockOn)('abilityForegroundState', ArgumentMatchers.any).afterReturn(null);
      when(mockInnerEventUtilOn)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);

      let applifecyclemanager: AppLifeCycleManager = new AppLifeCycleManager();
      await applifecyclemanager.init();

      mocker.ignoreMock(abilityManager, abilityManager.getForegroundUIAbilities);
      mocker.ignoreMock(abilityManager, abilityManager.on);
      mocker.ignoreMock(InnerEventUtil, InnerEventUtil.on);
    });

    it('should_return_true_when_foregroundInfo_has_uid', 0, () => {
      let mocker: MockKit = new MockKit();
      let pipSceneManager: PipSceneManager = PipSceneManager.instance;
      let mockIsPipLive: Function = mocker.mockFunc(pipSceneManager, pipSceneManager.isPipLive);
      when(mockIsPipLive)(ArgumentMatchers.any).afterReturn(false);

      let applifecyclemanager: AppLifeCycleManager = AppLifeCycleManager.INSTANCE;
      applifecyclemanager.foregroundInfo.set(1, new Set([1]));
      const result = applifecyclemanager.isForeground(1);
      expect(result).assertEqual(true);

      mocker.ignoreMock(pipSceneManager, pipSceneManager.isPipLive);
    });

    it('should_return_true_when_live_is_pip_live', 0, () => {
      let mocker: MockKit = new MockKit();
      let pipSceneManager: PipSceneManager = PipSceneManager.instance;
      let mockIsPipLive: Function = mocker.mockFunc(pipSceneManager, pipSceneManager.isPipLive);
      when(mockIsPipLive)(ArgumentMatchers.any).afterReturn(true);

      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let applifecyclemanager: AppLifeCycleManager = AppLifeCycleManager.INSTANCE;
      const result = applifecyclemanager.isForeground(1, new LiveNotification());
      expect(result).assertEqual(true);

      mocker.ignoreMock(pipSceneManager, pipSceneManager.isPipLive);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_false_when_live_is_not_pip_live', 0, () => {
      let mocker: MockKit = new MockKit();
      let pipSceneManager: PipSceneManager = PipSceneManager.instance;
      let mockIsPipLive: Function = mocker.mockFunc(pipSceneManager, pipSceneManager.isPipLive);
      when(mockIsPipLive)(ArgumentMatchers.any).afterReturn(false);

      let applifecyclemanager: AppLifeCycleManager = AppLifeCycleManager.INSTANCE;
      const result = applifecyclemanager.isForeground(1, new LiveNotification());
      expect(result).assertEqual(false);

      mocker.ignoreMock(pipSceneManager, pipSceneManager.isPipLive);
    });

    it('should_return_false_when_live_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let applifecyclemanager: AppLifeCycleManager = AppLifeCycleManager.INSTANCE;
      const result = applifecyclemanager.isForeground(1, null);
      expect(result).assertEqual(false);
    });
    it('should_log_error_when_init_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let applifecyclemanager: AppLifeCycleManager = new AppLifeCycleManager();
      await applifecyclemanager.init();

      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_register_ability_state_observer_and_call_onAbilityStateChanged_when_init_succeeds', 0, async () => {
      let mocker: MockKit = new MockKit();
      let abilityManager: abilityManager = abilityManager.getAbilityManager();
      let logHelper: LogHelper = LogHelper.getInstance();
      let pipSceneManager: PipSceneManager = new PipSceneManager();
      let liveNotification: LiveNotification = new LiveNotification();
      let eventEmitter: EventEmitter = new EventEmitter();

      let mockGetForegroundUIAbilities: Function = mocker.mockFunc(abilityManager, abilityManager.getForegroundUIAbilities);
      let mockOn: Function = mocker.mockFunc(abilityManager, abilityManager.on);
      let mockInnerEventUtilOn: Function = mocker.mockFunc(InnerEventUtil, InnerEventUtil.on);

      when(mockGetForegroundUIAbilities)().afterReturn([new AbilityState()]);
      when(mockOn)('abilityForegroundState', ArgumentMatchers.any).afterReturn(null);
      when(mockInnerEventUtilOn)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);

      let applifecyclemanager: AppLifeCycleManager = new AppLifeCycleManager();
      await applifecyclemanager.init();

      mocker.ignoreMock(abilityManager, abilityManager.getForegroundUIAbilities);
      mocker.ignoreMock(abilityManager, abilityManager.on);
      mocker.ignoreMock(InnerEventUtil, InnerEventUtil.on);
    });

    it('should_return_true_when_foregroundInfo_has_uid', 0, () => {
      let mocker: MockKit = new MockKit();
      let pipSceneManager: PipSceneManager = PipSceneManager.instance;
      let mockIsPipLive: Function = mocker.mockFunc(pipSceneManager, pipSceneManager.isPipLive);
      when(mockIsPipLive)(ArgumentMatchers.any).afterReturn(false);

      let applifecyclemanager: AppLifeCycleManager = AppLifeCycleManager.INSTANCE;
      applifecyclemanager.foregroundInfo.set(1, new Set([1]));
      const result = applifecyclemanager.isForeground(1);
      expect(result).assertEqual(true);

      mocker.ignoreMock(pipSceneManager, pipSceneManager.isPipLive);
    });

    it('should_return_true_when_live_is_pip_live', 0, () => {
      let mocker: MockKit = new MockKit();
      let pipSceneManager: PipSceneManager = PipSceneManager.instance;
      let mockIsPipLive: Function = mocker.mockFunc(pipSceneManager, pipSceneManager.isPipLive);
      when(mockIsPipLive)(ArgumentMatchers.any).afterReturn(true);

      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let applifecyclemanager: AppLifeCycleManager = AppLifeCycleManager.INSTANCE;
      const result = applifecyclemanager.isForeground(1, new LiveNotification());
      expect(result).assertEqual(true);

      mocker.ignoreMock(pipSceneManager, pipSceneManager.isPipLive);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_false_when_live_is_not_pip_live', 0, () => {
      let mocker: MockKit = new MockKit();
      let pipSceneManager: PipSceneManager = PipSceneManager.instance;
      let mockIsPipLive: Function = mocker.mockFunc(pipSceneManager, pipSceneManager.isPipLive);
      when(mockIsPipLive)(ArgumentMatchers.any).afterReturn(false);

      let applifecyclemanager: AppLifeCycleManager = AppLifeCycleManager.INSTANCE;
      const result = applifecyclemanager.isForeground(1, new LiveNotification());
      expect(result).assertEqual(false);

      mocker.ignoreMock(pipSceneManager, pipSceneManager.isPipLive);
    });

    it('should_return_false_when_live_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let applifecyclemanager: AppLifeCycleManager = AppLifeCycleManager.INSTANCE;
      const result = applifecyclemanager.isForeground(1, null);
      expect(result).assertEqual(false);
    });

    it('should_log_error_when_init_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let applifecyclemanager: AppLifeCycleManager = new AppLifeCycleManager();
      await applifecyclemanager.init();

      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_register_ability_state_observer_and_call_onAbilityStateChanged_when_init_succeeds', 0, async () => {
      let mocker: MockKit = new MockKit();
      let abilityManager: abilityManager = abilityManager.getAbilityManager();
      let logHelper: LogHelper = LogHelper.getInstance();
      let pipSceneManager: PipSceneManager = new PipSceneManager();
      let liveNotification: LiveNotification = new LiveNotification();
      let eventEmitter: EventEmitter = new EventEmitter();

      let mockGetForegroundUIAbilities: Function = mocker.mockFunc(abilityManager, abilityManager.getForegroundUIAbilities);
      let mockOn: Function = mocker.mockFunc(abilityManager, abilityManager.on);
      let mockInnerEventUtilOn: Function = mocker.mockFunc(InnerEventUtil, InnerEventUtil.on);

      when(mockGetForegroundUIAbilities)().afterReturn([new AbilityState()]);
      when(mockOn)('abilityForegroundState', ArgumentMatchers.any).afterReturn(null);
      when(mockInnerEventUtilOn)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);

      let applifecyclemanager: AppLifeCycleManager = new AppLifeCycleManager();
      await applifecyclemanager.init();

      mocker.ignoreMock(abilityManager, abilityManager.getForegroundUIAbilities);
      mocker.ignoreMock(abilityManager, abilityManager.on);
      mocker.ignoreMock(InnerEventUtil, InnerEventUtil.on);
    });

    it('should_return_true_when_foregroundInfo_has_uid', 0, () => {
      let mocker: MockKit = new MockKit();
      let pipSceneManager: PipSceneManager = PipSceneManager.instance;
      let mockIsPipLive: Function = mocker.mockFunc(pipSceneManager, pipSceneManager.isPipLive);
      when(mockIsPipLive)(ArgumentMatchers.any).afterReturn(false);

      let applifecyclemanager: AppLifeCycleManager = AppLifeCycleManager.INSTANCE;
      applifecyclemanager.foregroundInfo.set(1, new Set([1]));
      const result = applifecyclemanager.isForeground(1);
      expect(result).assertEqual(true);

      mocker.ignoreMock(pipSceneManager, pipSceneManager.isPipLive);
    });

    it('should_return_true_when_live_is_pip_live', 0, () => {
      let mocker: MockKit = new MockKit();
      let pipSceneManager: PipSceneManager = PipSceneManager.instance;
      let mockIsPipLive: Function = mocker.mockFunc(pipSceneManager, pipSceneManager.isPipLive);
      when(mockIsPipLive)(ArgumentMatchers.any).afterReturn(true);

      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let applifecyclemanager: AppLifeCycleManager = AppLifeCycleManager.INSTANCE;
      const result = applifecyclemanager.isForeground(1, new LiveNotification());
      expect(result).assertEqual(true);

      mocker.ignoreMock(pipSceneManager, pipSceneManager.isPipLive);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_false_when_live_is_not_pip_live', 0, () => {
      let mocker: MockKit = new MockKit();
      let pipSceneManager: PipSceneManager = PipSceneManager.instance;
      let mockIsPipLive: Function = mocker.mockFunc(pipSceneManager, pipSceneManager.isPipLive);
      when(mockIsPipLive)(ArgumentMatchers.any).afterReturn(false);

      let applifecyclemanager: AppLifeCycleManager = AppLifeCycleManager.INSTANCE;
      const result = applifecyclemanager.isForeground(1, new LiveNotification());
      expect(result).assertEqual(false);

      mocker.ignoreMock(pipSceneManager, pipSceneManager.isPipLive);
    });

    it('should_return_false_when_live_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let applifecyclemanager: AppLifeCycleManager = AppLifeCycleManager.INSTANCE;
      const result = applifecyclemanager.isForeground(1, null);
      expect(result).assertEqual(false);
    });

    it('should_log_error_when_init_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let applifecyclemanager: AppLifeCycleManager = new AppLifeCycleManager();
      await applifecyclemanager.init();

      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_register_ability_state_observer_and_call_onAbilityStateChanged_when_init_succeeds', 0, async () => {
      let mocker: MockKit = new MockKit();
      let abilityManager: abilityManager = abilityManager.getAbilityManager();
      let logHelper: LogHelper = LogHelper.getInstance();
      let pipSceneManager: PipSceneManager = new PipSceneManager();
      let liveNotification: LiveNotification = new LiveNotification();
      let eventEmitter: EventEmitter = new EventEmitter();

      let mockGetForegroundUIAbilities: Function = mocker.mockFunc(abilityManager, abilityManager.getForegroundUIAbilities);
      let mockOn: Function = mocker.mockFunc(abilityManager, abilityManager.on);
      let mockInnerEventUtilOn: Function = mocker.mockFunc(InnerEventUtil, InnerEventUtil.on);

      when(mockGetForegroundUIAbilities)().afterReturn([new AbilityState()]);
      when(mockOn)('abilityForegroundState', ArgumentMatchers.any).afterReturn(null);
      when(mockInnerEventUtilOn)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);

      let applifecyclemanager: AppLifeCycleManager = new AppLifeCycleManager();
      await applifecyclemanager.init();

      mocker.ignoreMock(abilityManager, abilityManager.getForegroundUIAbilities);
      mocker.ignoreMock(abilityManager, abilityManager.on);
      mocker.ignoreMock(InnerEventUtil, InnerEventUtil.on);
    });

    it('should_return_true_when_foregroundInfo_has_uid', 0, () => {
      let mocker: MockKit = new MockKit();
      let pipSceneManager: PipSceneManager = PipSceneManager.instance;
      let mockIsPipLive: Function = mocker.mockFunc(pipSceneManager, pipSceneManager.isPipLive);
      when(mockIsPipLive)(ArgumentMatchers.any).afterReturn(false);

      let applifecyclemanager: AppLifeCycleManager = AppLifeCycleManager.INSTANCE;
      applifecyclemanager.foregroundInfo.set(1, new Set([1]));
      const result = applifecyclemanager.isForeground(1);
      expect(result).assertEqual(true);

      mocker.ignoreMock(pipSceneManager, pipSceneManager.isPipLive);
    });

    it('should_return_true_when_live_is_pip_live', 0, () => {
      let mocker: MockKit = new MockKit();
      let pipSceneManager: PipSceneManager = PipSceneManager.instance;
      let mockIsPipLive: Function = mocker.mockFunc(pipSceneManager, pipSceneManager.isPipLive);
      when(mockIsPipLive)(ArgumentMatchers.any).afterReturn(true);

      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let applifecyclemanager: AppLifeCycleManager = AppLifeCycleManager.INSTANCE;
      const result = applifecyclemanager.isForeground(1, new LiveNotification());
      expect(result).assertEqual(true);

      mocker.ignoreMock(pipSceneManager, pipSceneManager.isPipLive);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_false_when_live_is_not_pip_live', 0, () => {
      let mocker: MockKit = new MockKit();
      let pipSceneManager: PipSceneManager = PipSceneManager.instance;
      let mockIsPipLive: Function = mocker.mockFunc(pipSceneManager, pipSceneManager.isPipLive);
      when(mockIsPipLive)(ArgumentMatchers.any).afterReturn(false);

      let applifecyclemanager: AppLifeCycleManager = AppLifeCycleManager.INSTANCE;
      const result = applifecyclemanager.isForeground(1, new LiveNotification());
      expect(result).assertEqual(false);

      mocker.ignoreMock(pipSceneManager, pipSceneManager.isPipLive);
    });

    it('should_return_false_when_live_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let applifecyclemanager: AppLifeCycleManager = AppLifeCycleManager.INSTANCE;
      const result = applifecyclemanager.isForeground(1, null);
      expect(result).assertEqual(false);
    });

    it('should_log_error_when_init_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let applifecyclemanager: AppLifeCycleManager = new AppLifeCycleManager();
      await applifecyclemanager.init();

      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_register_ability_state_observer_and_call_onAbilityStateChanged_when_init_succeeds', 0, async () => {
      let mocker: MockKit = new MockKit();
      let abilityManager: abilityManager = abilityManager.getAbilityManager();
      let logHelper: LogHelper = LogHelper.getInstance();
      let pipSceneManager: PipSceneManager = new PipSceneManager();
      let liveNotification: LiveNotification = new LiveNotification();
      let eventEmitter: EventEmitter = new EventEmitter();

      let mockGetForegroundUIAbilities: Function = mocker.mockFunc(abilityManager, abilityManager.getForegroundUIAbilities);
      let mockOn: Function = mocker.mockFunc(abilityManager, abilityManager.on);
      let mockInnerEventUtilOn: Function = mocker.mockFunc(InnerEventUtil, InnerEventUtil.on);

      when(mockGetForegroundUIAbilities)().afterReturn([new AbilityState()]);
      when(mockOn)('abilityForegroundState', ArgumentMatchers.any).afterReturn(null);
      when(mockInnerEventUtilOn)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);

      let applifecyclemanager: AppLifeCycleManager = new AppLifeCycleManager();
      await applifecyclemanager.init();

      mocker.ignoreMock(abilityManager, abilityManager.getForegroundUIAbilities);
      mocker.ignoreMock(abilityManager, abilityManager.on);
      mocker.ignoreMock(InnerEventUtil, InnerEventUtil.on);
    });

    it('should_return_true_when_foregroundInfo_has_uid', 0, () => {
      let mocker: MockKit = new MockKit();
      let pipSceneManager: PipSceneManager = PipSceneManager.instance;
      let mockIsPipLive: Function = mocker.mockFunc(pipSceneManager, pipSceneManager.isPipLive);
      when(mockIsPipLive)(ArgumentMatchers.any).afterReturn(false);

      let applifecyclemanager: AppLifeCycleManager = AppLifeCycleManager.INSTANCE;
      applifecyclemanager.foregroundInfo.set(1, new Set([1]));
      const result = applifecyclemanager.isForeground(1);
      expect(result).assertEqual(true);

      mocker.ignoreMock(pipSceneManager, pipSceneManager.isPipLive);
    });

    it('should_return_true_when_live_is_pip_live', 0, () => {
      let mocker: MockKit = new MockKit();
      let pipSceneManager: PipSceneManager = PipSceneManager.instance;
      let mockIsPipLive: Function = mocker.mockFunc(pipSceneManager, pipSceneManager.isPipLive);
      when(mockIsPipLive)(ArgumentMatchers.any).afterReturn(true);

      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let applifecyclemanager: AppLifeCycleManager = AppLifeCycleManager.INSTANCE;
      const result = applifecyclemanager.isForeground(1, new LiveNotification());
      expect(result).assertEqual(true);

      mocker.ignoreMock(pipSceneManager, pipSceneManager.isPipLive);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_false_when_live_is_not_pip_live', 0, () => {
      let mocker: MockKit = new MockKit();
      let pipSceneManager: PipSceneManager = PipSceneManager.instance;
      let mockIsPipLive: Function = mocker.mockFunc(pipSceneManager, pipSceneManager.isPipLive);
      when(mockIsPipLive)(ArgumentMatchers.any).afterReturn(false);

      let applifecyclemanager: AppLifeCycleManager = AppLifeCycleManager.INSTANCE;
      const result = applifecyclemanager.isForeground(1, new LiveNotification());
      expect(result).assertEqual(false);

      mocker.ignoreMock(pipSceneManager, pipSceneManager.isPipLive);
    });

    it('should_return_false_when_live_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let applifecyclemanager: AppLifeCycleManager = AppLifeCycleManager.INSTANCE;
      const result = applifecyclemanager.isForeground(1, null);
      expect(result).assertEqual(false);
    });

    it('should_log_error_when_init_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.error);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let applifecyclemanager: AppLifeCycleManager = new AppLifeCycleManager();
      await applifecyclemanager.init();

      mocker.ignoreMock(logHelper, logHelper.error);
    });

    it('should_register_ability_state_observer_and_call_onAbilityStateChanged_when_init_succeeds', 0, async () => {
      let mocker: MockKit = new MockKit();
      let abilityManager: abilityManager = abilityManager.getAbilityManager();
      let logHelper: LogHelper = LogHelper.getInstance();
      let pipSceneManager: PipSceneManager = new PipSceneManager();
      let liveNotification: LiveNotification = new LiveNotification();
      let eventEmitter: EventEmitter = new EventEmitter();

      let mockGetForegroundUIAbilities: Function = mocker.mockFunc(abilityManager, abilityManager.getForegroundUIAbilities);
      let mockOn: Function = mocker.mockFunc(abilityManager, abilityManager.on);
      let mockInnerEventUtilOn: Function = mocker.mockFunc(InnerEventUtil, InnerEventUtil.on);

      when(mockGetForegroundUIAbilities)().afterReturn([new AbilityState()]);
      when(mockOn)('abilityForegroundState', ArgumentMatchers.any).afterReturn(null);
      when(mockInnerEventUtilOn)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);

      let applifecyclemanager: AppLifeCycleManager = new AppLifeCycleManager();
      await applifecyclemanager.init();

      mocker.ignoreMock(abilityManager, abilityManager.getForegroundUIAbilities);
      mocker.ignoreMock(abilityManager, abilityManager.on);
      mocker.ignoreMock(InnerEventUtil, InnerEventUtil.on);
    });
  });
}