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
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { DeviceHelper, obtainLocalEvent, sEventManager } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import NtfSubscribe from '@ohos.notificationSubscribe';
import { NotificationEntry } from '../../../main/ets/model/NotificationEntry';
import { NtfMgr } from '../../../main/ets/model/NotificationManager';
import {
  DeleteNotificationMaintenance,
  DeleteNotificationType,
  LiveUseScene,
  StatusBarEventType,
} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { AppProtectedVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedVm';
import { AppBundleInfo, AppInfo } from '@ohos/launchercommon/src/main/ets/bean/OuterAppNameList';
import { OuterAppManager } from '@ohos/launchercommon/src/main/ets/manager/OuterAppManager';
import { promptAction, UIContext } from '@kit.ArkUI';
import { WantAgent } from '@ohos.app.ability.wantAgent';
import { NtfListVm } from '../../../main/ets/model/NtfListVm';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { OuterHomeNtfBridgeManager } from '../../../main/ets/manager/OuterHomeNtfBridgeManager';
import { WantAgent } from '@kit.AbilityKit';

export default function NotificationRemindManagerTest() {
  describe('bridgeWantAgent_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_execute_noBlockCB_when_needBlock_is_false', 0, async () => {
      let outerhomentfbridgemanager: OuterHomeNtfBridgeManager = OuterHomeNtfBridgeManager.get();
      let mocker: MockKit = new MockKit();

      let mockNoBlockCB: Function =
        mocker.mockFunc(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
      when(mockNoBlockCB)(ArgumentMatchers.any).afterReturn(undefined);

      let entry: NotificationEntry = new NotificationEntry();
      entry.wantAgent = new WantAgent();

      await outerhomentfbridgemanager.bridgeWantAgent(entry, mockNoBlockCB, false, undefined, undefined);

      mocker.ignoreMock(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
    });

    it('should_put_to_bridge_when_needBlock_is_true', 0, async () => {
      let outerhomentfbridgemanager: OuterHomeNtfBridgeManager = OuterHomeNtfBridgeManager.get();
      let mocker: MockKit = new MockKit();


      let entry: NotificationEntry = new NotificationEntry();
      entry.wantAgent = new WantAgent();

      await outerhomentfbridgemanager.bridgeWantAgent(entry, () => {
      }, false, undefined, undefined);

    });

    it('should_reset_data_and_execute_noBlockCB_when_isStartApp_is_true', 0, async () => {
      let outerhomentfbridgemanager: OuterHomeNtfBridgeManager = OuterHomeNtfBridgeManager.get();
      let mocker: MockKit = new MockKit();

      let mockNoBlockCB: Function =
        mocker.mockFunc(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
      when(mockNoBlockCB)(ArgumentMatchers.any).afterReturn(undefined);

      let entry: NotificationEntry = new NotificationEntry();
      entry.wantAgent = new WantAgent();

      outerhomentfbridgemanager.isStartApp = true;

      await outerhomentfbridgemanager.bridgeWantAgent(entry, mockNoBlockCB, false, undefined, undefined);

      mocker.ignoreMock(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
    });

    it('should_reset_data_and_execute_noBlockCB_when_isBridgeAction_is_true', 0, async () => {
      let outerhomentfbridgemanager: OuterHomeNtfBridgeManager = OuterHomeNtfBridgeManager.get();
      let mocker: MockKit = new MockKit();

      let mockNoBlockCB: Function =
        mocker.mockFunc(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
      when(mockNoBlockCB)(ArgumentMatchers.any).afterReturn(undefined);

      let entry: NotificationEntry = new NotificationEntry();
      entry.wantAgent = new WantAgent();

      outerhomentfbridgemanager.isBridgeAction = true;

      await outerhomentfbridgemanager.bridgeWantAgent(entry, mockNoBlockCB, false, undefined, undefined);

      mocker.ignoreMock(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
    });

    it('should_reset_data_and_execute_noBlockCB_when_bridgeTime_is_greater_than_0', 0, async () => {
      let outerhomentfbridgemanager: OuterHomeNtfBridgeManager = OuterHomeNtfBridgeManager.get();
      let mocker: MockKit = new MockKit();

      let mockNoBlockCB: Function =
        mocker.mockFunc(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
      when(mockNoBlockCB)(ArgumentMatchers.any).afterReturn(undefined);

      let entry: NotificationEntry = new NotificationEntry();
      entry.wantAgent = new WantAgent();

      outerhomentfbridgemanager.bridgeTime = 1;

      await outerhomentfbridgemanager.bridgeWantAgent(entry, mockNoBlockCB, false, undefined, undefined);

      mocker.ignoreMock(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
    });

    it('should_reset_data_and_execute_noBlockCB_when_bridgeAgent_is_not_null', 0, async () => {
      let outerhomentfbridgemanager: OuterHomeNtfBridgeManager = OuterHomeNtfBridgeManager.get();
      let mocker: MockKit = new MockKit();

      let mockNoBlockCB: Function =
        mocker.mockFunc(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
      when(mockNoBlockCB)(ArgumentMatchers.any).afterReturn(undefined);

      let entry: NotificationEntry = new NotificationEntry();
      entry.wantAgent = new WantAgent();

      outerhomentfbridgemanager.bridgeAgent = new WantAgent();

      await outerhomentfbridgemanager.bridgeWantAgent(entry, mockNoBlockCB, false, undefined, undefined);

      mocker.ignoreMock(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
    });

    it('should_reset_data_and_execute_noBlockCB_when_bridgeEntry_is_not_null', 0, async () => {
      let outerhomentfbridgemanager: OuterHomeNtfBridgeManager = OuterHomeNtfBridgeManager.get();
      let mocker: MockKit = new MockKit();

      let mockNoBlockCB: Function =
        mocker.mockFunc(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
      when(mockNoBlockCB)(ArgumentMatchers.any).afterReturn(undefined);

      let entry: NotificationEntry = new NotificationEntry();
      entry.wantAgent = new WantAgent();

      outerhomentfbridgemanager.bridgeEntry = new NotificationEntry();

      await outerhomentfbridgemanager.bridgeWantAgent(entry, mockNoBlockCB, false, undefined, undefined);

      mocker.ignoreMock(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
    });

    it('should_reset_data_and_execute_noBlockCB_when_bridgeInputKey_is_not_null', 0, async () => {
      let outerhomentfbridgemanager: OuterHomeNtfBridgeManager = OuterHomeNtfBridgeManager.get();
      let mocker: MockKit = new MockKit();

      let mockNoBlockCB: Function =
        mocker.mockFunc(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
      when(mockNoBlockCB)(ArgumentMatchers.any).afterReturn(undefined);

      let entry: NotificationEntry = new NotificationEntry();
      entry.wantAgent = new WantAgent();

      outerhomentfbridgemanager.bridgeInputKey = 'test';

      await outerhomentfbridgemanager.bridgeWantAgent(entry, mockNoBlockCB, false, undefined, undefined);

      mocker.ignoreMock(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
    });

    it('should_reset_when_isLockScreen_is_true', 0, () => {
      let outerhomentfbridgemanager: OuterHomeNtfBridgeManager = OuterHomeNtfBridgeManager.get();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(outerhomentfbridgemanager, outerhomentfbridgemanager.reset);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      outerhomentfbridgemanager.onLockScreenChanged(true);

      expect(outerhomentfbridgemanager.isLockScreen).assertEqual(true);
      mocker.ignoreMock(outerhomentfbridgemanager, outerhomentfbridgemanager.reset);
    });

    it('should_not_reset_when_isLockScreen_is_false', 0, () => {
      let outerhomentfbridgemanager: OuterHomeNtfBridgeManager = OuterHomeNtfBridgeManager.get();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(outerhomentfbridgemanager, outerhomentfbridgemanager.reset);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      outerhomentfbridgemanager.onLockScreenChanged(false);

      expect(outerhomentfbridgemanager.isLockScreen).assertEqual(false);
      mocker.ignoreMock(outerhomentfbridgemanager, outerhomentfbridgemanager.reset);
    });

    it('should_reset_data_and_execute_noBlockCB_when_bridgeInputKey_is_not_null', 0, async () => {
      let outerhomentfbridgemanager: OuterHomeNtfBridgeManager = OuterHomeNtfBridgeManager.get();
      let mocker: MockKit = new MockKit();

      let mockNoBlockCB: Function =
        mocker.mockFunc(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
      when(mockNoBlockCB)(ArgumentMatchers.any).afterReturn(undefined);

      let entry: NotificationEntry = new NotificationEntry();
      entry.wantAgent = new WantAgent();

      outerhomentfbridgemanager.bridgeInputKey = 'test';

      await outerhomentfbridgemanager.bridgeWantAgent(entry, mockNoBlockCB, false, undefined, undefined);

      mocker.ignoreMock(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
    });

    it('should_reset_data_and_execute_noBlockCB_when_bridgeInputKey_is_not_null', 0, async () => {
      let outerhomentfbridgemanager: OuterHomeNtfBridgeManager = OuterHomeNtfBridgeManager.get();
      let mocker: MockKit = new MockKit();

      let mockNoBlockCB: Function =
        mocker.mockFunc(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
      when(mockNoBlockCB)(ArgumentMatchers.any).afterReturn(undefined);

      let entry: NotificationEntry = new NotificationEntry();
      entry.wantAgent = new WantAgent();

      outerhomentfbridgemanager.bridgeInputKey = 'test';

      await outerhomentfbridgemanager.bridgeWantAgent(entry, mockNoBlockCB, false, undefined, undefined);

      mocker.ignoreMock(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
    });

    it('should_reset_data_and_execute_noBlockCB_when_bridgeInputContent_is_not_null', 0, async () => {
      let outerhomentfbridgemanager: OuterHomeNtfBridgeManager = OuterHomeNtfBridgeManager.get();
      let mocker: MockKit = new MockKit();

      let mockNoBlockCB: Function =
        mocker.mockFunc(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
      when(mockNoBlockCB)(ArgumentMatchers.any).afterReturn(undefined);

      let entry: NotificationEntry = new NotificationEntry();
      entry.wantAgent = new WantAgent();

      outerhomentfbridgemanager.bridgeInputContent = 'test';

      await outerhomentfbridgemanager.bridgeWantAgent(entry, mockNoBlockCB, false, undefined, undefined);

      mocker.ignoreMock(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
    });


    it('should_reset_data_and_execute_noBlockCB_when_isStartApp_is_true', 0, async () => {
      let outerhomentfbridgemanager: OuterHomeNtfBridgeManager = OuterHomeNtfBridgeManager.get();
      let mocker: MockKit = new MockKit();

      let mockNoBlockCB: Function =
        mocker.mockFunc(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
      when(mockNoBlockCB)(ArgumentMatchers.any).afterReturn(undefined);

      let entry: NotificationEntry = new NotificationEntry();
      entry.wantAgent = new WantAgent();

      outerhomentfbridgemanager.isStartApp = true;

      await outerhomentfbridgemanager.bridgeWantAgent(entry, mockNoBlockCB, false, undefined, undefined);

      mocker.ignoreMock(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
    });

    it('should_execute_noBlockCB_when_needBlock_is_false', 0, async () => {
      let outerhomentfbridgemanager: OuterHomeNtfBridgeManager = OuterHomeNtfBridgeManager.get();
      let mocker: MockKit = new MockKit();

      let mockNoBlockCB: Function =
        mocker.mockFunc(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
      when(mockNoBlockCB)(ArgumentMatchers.any).afterReturn(undefined);

      let entry: NotificationEntry = new NotificationEntry();
      entry.wantAgent = new WantAgent();

      await outerhomentfbridgemanager.bridgeWantAgent(entry, mockNoBlockCB, false, undefined, undefined);

      mocker.ignoreMock(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
    });

    it('should_reset_data_and_execute_noBlockCB_when_isStartApp_is_true', 0, async () => {
      let outerhomentfbridgemanager: OuterHomeNtfBridgeManager = OuterHomeNtfBridgeManager.get();
      let mocker: MockKit = new MockKit();

      let mockNoBlockCB: Function =
        mocker.mockFunc(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
      when(mockNoBlockCB)(ArgumentMatchers.any).afterReturn(undefined);

      let entry: NotificationEntry = new NotificationEntry();
      entry.wantAgent = new WantAgent();

      outerhomentfbridgemanager.isStartApp = true;

      await outerhomentfbridgemanager.bridgeWantAgent(entry, mockNoBlockCB, false, undefined, undefined);

      mocker.ignoreMock(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
    });

    it('should_reset_data_and_execute_noBlockCB_when_isBridgeAction_is_true', 0, async () => {
      let outerhomentfbridgemanager: OuterHomeNtfBridgeManager = OuterHomeNtfBridgeManager.get();
      let mocker: MockKit = new MockKit();

      let mockNoBlockCB: Function =
        mocker.mockFunc(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
      when(mockNoBlockCB)(ArgumentMatchers.any).afterReturn(undefined);

      let entry: NotificationEntry = new NotificationEntry();
      entry.wantAgent = new WantAgent();

      outerhomentfbridgemanager.isBridgeAction = true;

      await outerhomentfbridgemanager.bridgeWantAgent(entry, mockNoBlockCB, false, undefined, undefined);

      mocker.ignoreMock(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
    });

    it('should_reset_data_and_execute_noBlockCB_when_bridgeTime_is_greater_than_0', 0, async () => {
      let outerhomentfbridgemanager: OuterHomeNtfBridgeManager = OuterHomeNtfBridgeManager.get();
      let mocker: MockKit = new MockKit();

      let mockNoBlockCB: Function =
        mocker.mockFunc(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
      when(mockNoBlockCB)(ArgumentMatchers.any).afterReturn(undefined);

      let entry: NotificationEntry = new NotificationEntry();
      entry.wantAgent = new WantAgent();

      outerhomentfbridgemanager.bridgeTime = 1;

      await outerhomentfbridgemanager.bridgeWantAgent(entry, mockNoBlockCB, false, undefined, undefined);

      mocker.ignoreMock(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
    });

    it('should_reset_data_and_execute_noBlockCB_when_bridgeAgent_is_not_null', 0, async () => {
      let outerhomentfbridgemanager: OuterHomeNtfBridgeManager = OuterHomeNtfBridgeManager.get();
      let mocker: MockKit = new MockKit();

      let mockNoBlockCB: Function =
        mocker.mockFunc(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
      when(mockNoBlockCB)(ArgumentMatchers.any).afterReturn(undefined);

      let entry: NotificationEntry = new NotificationEntry();
      entry.wantAgent = new WantAgent();

      outerhomentfbridgemanager.bridgeAgent = new WantAgent();

      await outerhomentfbridgemanager.bridgeWantAgent(entry, mockNoBlockCB, false, undefined, undefined);

      mocker.ignoreMock(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
    });

    it('should_reset_data_and_execute_noBlockCB_when_bridgeEntry_is_not_null', 0, async () => {
      let outerhomentfbridgemanager: OuterHomeNtfBridgeManager = OuterHomeNtfBridgeManager.get();
      let mocker: MockKit = new MockKit();

      let mockNoBlockCB: Function =
        mocker.mockFunc(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
      when(mockNoBlockCB)(ArgumentMatchers.any).afterReturn(undefined);

      let entry: NotificationEntry = new NotificationEntry();
      entry.wantAgent = new WantAgent();

      outerhomentfbridgemanager.bridgeEntry = new NotificationEntry();

      await outerhomentfbridgemanager.bridgeWantAgent(entry, mockNoBlockCB, false, undefined, undefined);

      mocker.ignoreMock(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
    });

    it('should_execute_noBlockCB_when_needBlock_is_false', 0, async () => {
      let outerhomentfbridgemanager: OuterHomeNtfBridgeManager = OuterHomeNtfBridgeManager.get();
      let mocker: MockKit = new MockKit();

      let mockNoBlockCB: Function =
        mocker.mockFunc(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
      when(mockNoBlockCB)(ArgumentMatchers.any).afterReturn(undefined);

      let entry: NotificationEntry = new NotificationEntry();
      entry.wantAgent = new WantAgent();

      await outerhomentfbridgemanager.bridgeWantAgent(entry, mockNoBlockCB, false, undefined, undefined);

      mocker.ignoreMock(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
    });

    it('should_put_to_bridge_when_needBlock_is_true', 0, async () => {
      let outerhomentfbridgemanager: OuterHomeNtfBridgeManager = OuterHomeNtfBridgeManager.get();
      let mocker: MockKit = new MockKit();


      let entry: NotificationEntry = new NotificationEntry();
      entry.wantAgent = new WantAgent();

      await outerhomentfbridgemanager.bridgeWantAgent(entry, () => {
      }, false, undefined, undefined);

    });

    it('should_reset_data_and_execute_noBlockCB_when_bridgeInputContent_is_not_null', 0, async () => {
      let outerhomentfbridgemanager: OuterHomeNtfBridgeManager = OuterHomeNtfBridgeManager.get();
      let mocker: MockKit = new MockKit();

      let mockNoBlockCB: Function =
        mocker.mockFunc(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
      when(mockNoBlockCB)(ArgumentMatchers.any).afterReturn(undefined);

      let entry: NotificationEntry = new NotificationEntry();
      entry.wantAgent = new WantAgent();

      outerhomentfbridgemanager.bridgeInputContent = 'test';

      await outerhomentfbridgemanager.bridgeWantAgent(entry, mockNoBlockCB, false, undefined, undefined);

      mocker.ignoreMock(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
    });


    it('should_reset_data_and_execute_noBlockCB_when_isStartApp_is_true', 0, async () => {
      let outerhomentfbridgemanager: OuterHomeNtfBridgeManager = OuterHomeNtfBridgeManager.get();
      let mocker: MockKit = new MockKit();

      let mockNoBlockCB: Function =
        mocker.mockFunc(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
      when(mockNoBlockCB)(ArgumentMatchers.any).afterReturn(undefined);

      let entry: NotificationEntry = new NotificationEntry();
      entry.wantAgent = new WantAgent();

      outerhomentfbridgemanager.isStartApp = true;

      await outerhomentfbridgemanager.bridgeWantAgent(entry, mockNoBlockCB, false, undefined, undefined);

      mocker.ignoreMock(outerhomentfbridgemanager, outerhomentfbridgemanager.bridgeWantAgent);
    });
  });
}