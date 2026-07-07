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

import Ntf from '@ohos.notificationSubscribe';
import NtfManger from '@ohos.notificationManager';
import CommonEventManager from '@ohos.commonEventManager';
import PromptAction from '@ohos.promptAction';
import { WantAgent } from '@ohos.app.ability.wantAgent';
import {
  CommonUtils,
  SingletonHelper,
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import { ExtAppConstants } from '@ohos/commonconstants';
import { sEventManager, obtainLocalEvent } from '@ohos/frameworkwrapper';
import { StartAbilityUtil, ResUtils, SCBSceneMode } from '@ohos/windowscene';
import { NotificationEntry } from '../../../main/ets/model/NotificationEntry';
import { SystemuiConstants, SysTypeCode } from '@ohos/systemuicommon';
import { Callback } from '@kit.BasicServicesKit';
import { NtfListener } from '../../../main/ets/model/NotificationListener';
import {
  DeleteNotificationErrorCode,
  DeleteNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/DeleteNotificationMaintenance';
import {
  ClickMaintenanceInfo,
  ClickNotificationErrorCode,
  ClickNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/ClickNotificationMaintenance';
import { LogWithHa } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionMaintenance';
import Want from '@ohos.app.ability.Want';
import { InvokePushAgentParam } from '../../../main/ets/model/InvokePushAgentParam';
import { NotificationExceptionCode } from '../../../main/ets/maintenance/NotificationExceptionCode';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { GlobalContext } from '@ohos/frameworkwrapper';
import ohosWantAgent from '@ohos.wantAgent';
import { RdbStoreManager } from '@ohos/launchercommon';
import { image } from '@kit.ImageKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationManager } from '../../../main/ets/model/NotificationManager';
export default function NotificationManagerTest() {
  describe('isDeliverPushNts_testSuite', () => {

    beforeEach(() => {
    });
    afterEach(() => {
    });


    it('should_return_false_when_want_parameters_is_null', 0, async () => {
      let want: Want = new Want();
      want.parameters = null;
      let notificationManager: NotificationManager = new NotificationManager();
      const result = await notificationManager.isDeliverPushNts(want);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_pushDeliverLaunchInfo_is_null', 0, async () => {
      let want: Want = new Want();
      want.parameters = {};
      let notificationManager: NotificationManager = new NotificationManager();
      const result = await notificationManager.isDeliverPushNts(want);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_pushDeliverLaunchInfo_is_empty_string', 0, async () => {
      let want: Want = new Want();
      want.parameters = {
        [SystemuiConstants.KEY_PUSH_DELIVER_LAUNCH_INFO]: ''
      };
      let notificationManager: NotificationManager = new NotificationManager();
      const result = await notificationManager.isDeliverPushNts(want);
      expect(result).assertEqual(false);
    });


    it('should_return_default_value_when_systemParameterEnhance_throws_error', 0, async () => {
      let mocker: MockKit = new MockKit();

      const result = await NotificationManager.getDeliverStartStatus();
      expect(result).assertEqual(SystemuiConstants.DELIVER_START_FINISHED_CODE);

    });

    it('should_return_error_code_when_systemParameterEnhance_throws_error_with_code_not_found', 0, async () => {
      let mocker: MockKit = new MockKit();

      const result = await NotificationManager.getDeliverStartStatus();
      expect(result).assertEqual(SystemuiConstants.INVALID_VALUE);

    });

    it('should_return_actual_value_when_systemParameterEnhance_returns_valid_value', 0, async () => {
      let mocker: MockKit = new MockKit();

      const result = await NotificationManager.getDeliverStartStatus();
      expect(result).assertEqual('testValue');

    });

    it('should_log_info_when_startWantAgent_is_called', 0, async () => {
      let notificationmanager: NotificationManager = new NotificationManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let agent: WantAgent = new WantAgent();
      await notificationmanager.startWantAgent(agent);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_when_ntfEntry_is_undefined', 0, async () => {
      let notificationmanager: NotificationManager = new NotificationManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let agent: WantAgent = new WantAgent();
      await notificationmanager.startWantAgent(agent, undefined, 'inputKey', 'inputContent');

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_when_ntfEntry_is_DeliverPushNotification_and_agent_is_undefined', 0, async () => {
      let notificationmanager: NotificationManager = new NotificationManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let agent: WantAgent = new WantAgent();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.isDeliverPushNotification = true;
      await notificationmanager.startWantAgent(agent, undefined, 'inputKey', 'inputContent', ntfEntry);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_when_wantAgent_trigger_throws_error', 0, async () => {
      let notificationmanager: NotificationManager = new NotificationManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let agent: WantAgent = new WantAgent();
      let mockWantAgent: any = {
        trigger: (agent: WantAgent, wantParam: Want, callback: Function) => {
          throw new Error('trigger error');
        }
      };
      await notificationmanager.startWantAgent(agent);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_when_ntfEntry_is_DeliverPushNotification_and_getDeliverPushWantInfo_returns_undefined', 0, async () => {
      let notificationmanager: NotificationManager = new NotificationManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let agent: WantAgent = new WantAgent();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.isDeliverPushNotification = true;
      await notificationmanager.startWantAgent(agent, undefined, 'inputKey', 'inputContent', ntfEntry);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_when_ntfEntry_is_DeliverPushNotification_and_getDeliverPush WantInfo_returns_agent', 0, async () => {
      let notificationmanager: NotificationManager = new NotificationManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let agent: WantAgent = new WantAgent();
      let mockWantAgent: any = {
        trigger: (agent: WantAgent, wantParam: Want, callback: Function) => {
        }
      };
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.isDeliverPushNotification = true;
      await notificationmanager.startWantAgent(agent, undefined, 'inputKey', 'inputContent', ntfEntry);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_when_ntfEntry_is_DeliverPushNotification_and_getDeliverPush WantInfo_throws_error', 0, async () => {
      let notificationmanager: NotificationManager = new NotificationManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let agent: WantAgent = new WantAgent();
      let mockWantAgent: any = {
        trigger: (agent: WantAgent, wantParam: Want, callback: Function) => {
        }
      };
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.isDeliverPushNotification = true;
      await notificationmanager.startWantAgent(agent, undefined, 'inputKey', 'inputContent', ntfEntry);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_when_wantAgent_trigger_returns_error', 0, async () => {
      let notificationmanager: NotificationManager = new NotificationManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let agent: WantAgent = new WantAgent();
      let mockWantAgent: any = {
        trigger: (agent: WantAgent, wantParam: Want, callback: Function) => {
          throw new Error('trigger error');
        }
      };
      await notificationmanager.startWantAgent(agent);

    });

    it('should_return_when_wantAgent_trigger_returns_success', 0, async () => {
      let notificationmanager: NotificationManager = new NotificationManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let agent: WantAgent = new WantAgent();
      let mockWantAgent: any = {
        trigger: (agent: WantAgent, wantParam: Want, callback: Function) => {
        }
      };
      await notificationmanager.startWantAgent(agent);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_empty_string_when_bundleName_is_null', 0, async () => {
      let notificationManager: NotificationManager = new NotificationManager();
      const result = await notificationManager.getDeliverPushNotificationHomePage(null);
      expect(result).assertEqual('');
    });

    it('should_return_empty_string_when_queryGridLayoutItemsByBundleName_throws_error', 0, async () => {
      let notificationManager: NotificationManager = new NotificationManager();
      let mocker: MockKit = new MockKit();
      const result = await notificationManager.getDeliverPushNotificationHomePage('testBundleName');
      expect(result).assertEqual('');
    });

    it('should_return_empty_string_when_abilityInfos_is_null', 0, async () => {
      let notificationManager: NotificationManager = new NotificationManager();
      let mocker: MockKit = new MockKit();
      const result = await notificationManager.getDeliverPushNotificationHomePage('testBundleName');
      expect(result).assertEqual('');
    });

    it('should_return_abilityName_when_abilityName_is_not_null', 0, async () => {
      let notificationManager: NotificationManager = new NotificationManager();
      let mocker: MockKit = new MockKit();
      let abilityInfos: Array<any> = [{ abilityName: 'testAbilityName' }];
      const result = await notificationManager.getDeliverPushNotificationHomePage('testBundleName');
      expect(result).assertEqual('testAbilityName');
    });

    it('should_return_undefined_when_want_is_null', 0, () => {
      let notificationManager: NotificationManager = new NotificationManager();
      const result = notificationManager.getPushDeliverWantAgentInfo(null);
      expect(result).assertUndefined();
    });

    it('should_return_undefined_when_want_parameters_is_null', 0, () => {
      let notificationManager: NotificationManager = new NotificationManager();
      let want: Want = new Want();
      const result = notificationManager.getPushDeliverWantAgentInfo(want);
      expect(result).assertUndefined();
    });

    it('should_return_wantAgentInfo_when_want_parameters_has_push_info', 0, () => {
      let notificationManager: NotificationManager = new NotificationManager();
      let want: Want = new Want();
      want.parameters = {};
      want.parameters[SystemuiConstants.KEY_PUSH_DELIVER_WANT_AGENT_INFO] = new WantAgent();
      const result = notificationManager.getPushDeliverWantAgentInfo(want);
      expect(result).assertInstanceOf(WantAgent);
    });


    it('should_return_immediately_when_pushWantInfo_is_null', 0, async () => {
      let notificationmanager: NotificationManager = new NotificationManager();
      let invokePushAgentParam: InvokePushAgentParam = new InvokePushAgentParam();
      let result = await notificationmanager.startPushAgent(invokePushAgentParam);
      expect(result).assertUndefined();
    });

    it('should_return_immediately_when_want_is_null', 0, async () => {
      let notificationmanager: NotificationManager = new NotificationManager();
      let invokePushAgentParam: InvokePushAgentParam = new InvokePushAgentParam();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(invokePushAgentParam, invokePushAgentParam.getPushWantInfo);
      when(mockfunc)().afterReturn(null);
      let result = await notificationmanager.startPushAgent(invokePushAgentParam);
      expect(result).assertUndefined();
      mocker.ignoreMock(invokePushAgentParam, invokePushAgentParam.getPushWantInfo);
    });

    it('should_return_immediately_when_bundleName_is_not_push_bundle', 0, async () => {
      let notificationmanager: NotificationManager = new NotificationManager();
      let invokePushAgentParam: InvokePushAgentParam = new InvokePushAgentParam();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(invokePushAgentParam, invokePushAgentParam.getPushWantInfo);
      let pushWantInfo: wantAgent.WantAgentInfo = {
        wants: [{
          bundleName: 'testBundle',
          parameters: {}
        }],
        actionType: 0,
        actionFlags: 0,
        requestCode: 0
      };
      when(mockfunc)().afterReturn(pushWantInfo);
      let result = await notificationmanager.startPushAgent(invokePushAgentParam);
      expect(result).assertUndefined();
      mocker.ignoreMock(invokePushAgentParam, invokePushAgentParam.getPushWantInfo);
    });

    it('should_start_push_agent_successfully_when_all_conditions_are_met', 0, async () => {
      let notificationmanager: NotificationManager = new NotificationManager();
      let invokePushAgentParam: InvokePushAgentParam = new InvokePushAgentParam();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(invokePushAgentParam, invokePushAgentParam.getPushWantInfo);
      let pushWantInfo: wantAgent.WantAgentInfo = {
        wants: [{
          bundleName: SystemuiConstants.PUSH_BUNDLE_NAME,
          parameters: {}
        }],
        actionType: 0,
        actionFlags: 0,
        requestCode: 0
      };
      when(mockfunc)().afterReturn(pushWantInfo);
      let mockfunc2: Function = mocker.mockFunc(ohosWantAgent, ohosWantAgent.getWantAgent);
      let pushWantAgentInfo: wantAgent.WantAgentInfo = {
        wants: [{
          bundleName: SystemuiConstants.PUSH_BUNDLE_NAME,
          parameters: {}
        }],
        actionType: 0,
        actionFlags: 0,
        requestCode: 0
      };
      when(mockfunc2)(ArgumentMatchers.anyObj).afterReturn(pushWantAgentInfo);
      let mockfunc3: Function = mocker.mockFunc(ohosWantAgent, ohosWantAgent.trigger);
      when(mockfunc3)(ArgumentMatchers.anyObj, ArgumentMatchers.anyObj, ArgumentMatchers.anyFunction).afterReturn(null);
      let mockfunc4: Function = mocker.mockFunc(ohosWantAgent, ohosWantAgent.cancel);
      when(mockfunc4)(ArgumentMatchers.anyObj, ArgumentMatchers.anyFunction).afterReturn(null);
      let result = await notificationmanager.startPushAgent(invokePushAgentParam);
      expect(result).assertUndefined();
      mocker.ignoreMock(invokePushAgentParam, invokePushAgentParam.getPushWantInfo);
      mocker.ignoreMock(ohosWantAgent, ohosWantAgent.getWantAgent);
      mocker.ignoreMock(ohosWantAgent, ohosWantAgent.trigger);
      mocker.ignoreMock(ohosWantAgent, ohosWantAgent.cancel);
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
  });
}
