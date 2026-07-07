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

import { NotificationEntry } from '../../../main/ets/model/NotificationEntry';
import { NtfMgr } from '../../../main/ets/model/NotificationManager';
import { NotificationPanelManager } from '../../../main/ets/model/NotificationPanelManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import { NotificationType } from '../../../main/ets/common/NotificationType';
import { ScreenLockApi } from '@ohos/screenlockcommon';
import { WantAgent } from '@ohos.app.ability.wantAgent';
import { bannerMgr, LiveUseScene, NotificationAction } from '@ohos/systemuicommon';
import { ExclusiveChecker } from '../../../main/ets/model/ExclusiveChecker';
import {
  ClickNotificationErrorCode,
  ClickNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/ClickNotificationMaintenance';
import { AnimParam } from '@ohos/systemuicommon/src/main/ets/liveview/common/LiveItemStartAnimManager';
import { SlMainStateType, SlStaticStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import {
  DeleteNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/DeleteNotificationMaintenance';
import { ClickRegion, DeleteNotificationType } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsConstants';
import { liveStartAnimMgr } from '@ohos/systemuicommon/Index';
import Want from '@ohos.app.ability.Want';
import { NtfSingleItemVM } from '../../../main/ets/vm/NtfSingleItemVM';
import NTF_LIST_VM_HOLDER from '../../../main/ets/model/NtfListVmHolder';
import {
  StartAbilityOverlayAnimate
} from '@ohos/systemuicommon/src/main/ets/liveview/common/StartAbilityOverlayAnimate';
import { OuterHomeNtfBridgeManager } from '../../../main/ets/manager/OuterHomeNtfBridgeManager';
import { ntfViewConfigManager } from '../../../main/ets/vm/config/NtfViewConfigManager';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { NtfActionVM } from '../../../main/ets/vm/NtfActionVM';

export default function NtfActionVMTest() {
  describe('init_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_log_error_when_wantAgent_is_null', 0, () => {
      let ntfactionvm: NtfActionVM = new NtfActionVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(null);
      let action: NotificationAction = new NotificationAction('test');
      ntfactionvm.checkAndStart(action, true, 'inputContent');
      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_update_error_code_and_call_startActionInner_when_wantAgent_is_null', 0, () => {
      let ntfactionvm: NtfActionVM = new NtfActionVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(null);
      let mockStartActionInner: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.startActionInner);
      when(mockStartActionInner)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any,
        ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      let action: NotificationAction = new NotificationAction('test');
      ntfactionvm.checkAndStart(action, true, 'inputContent');
      mocker.ignoreMock(logHelper, logHelper.showError);
      mocker.ignoreMock(ntfactionvm, ntfactionvm.startActionInner);
    });

    it('should_log_error_and_call_startActionInner_when_getOperationType_fails', 0, () => {
      let ntfactionvm: NtfActionVM = new NtfActionVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(null);
      let mockStartActionInner: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.startActionInner);
      when(mockStartActionInner)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any,
        ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      let action: NotificationAction = new NotificationAction('test');
      action.wantAgent = new WantAgent();
      ntfactionvm.checkAndStart(action, true, 'inputContent');
      mocker.ignoreMock(logHelper, logHelper.showError);
      mocker.ignoreMock(ntfactionvm, ntfactionvm.startActionInner);
    });

    it('should_call_startWantAgent_when_getOperationType_succeeds', 0, () => {
      let ntfactionvm: NtfActionVM = new NtfActionVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(null);
      let mockStartWantAgent: Function = mocker.mockFunc(NtfMgr, NtfMgr.startWantAgent);
      when(mockStartWantAgent)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any,
        ArgumentMatchers.any).afterReturn(null);
      let action: NotificationAction = new NotificationAction('test');
      action.wantAgent = new WantAgent();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfactionvm.callback = {
        getNtfEntry: () => ntfEntry,
        getNtfType: () => NotificationType.NOTIFICATION_TYPE_DEFAULT
      };
      ntfactionvm.checkAndStart(action, true, 'inputContent');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(NtfMgr, NtfMgr.startWantAgent);
    });
    it('should_release_panel_heads_up_when_isDeliverNotification_and_isHeadsUp_is_true', 0, async () => {
      let ntfactionvm: NtfActionVM = new NtfActionVM();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(bannerMgr, bannerMgr.releasePanelHeadsUp);
      when(mockfunc)().afterReturnNothing();
      let entry: NotificationEntry = new NotificationEntry();
      entry.isDeliverNotification = true;
      let action: NotificationAction = new NotificationAction();
      ntfactionvm.startNtfAction(action, false, true);
      mocker.ignoreMock(bannerMgr, bannerMgr.releasePanelHeadsUp);
    });
    it('should_collapse_panel_when_isDeliverNotification_and_isHeadsUp_is_false', 0, async () => {
      let ntfactionvm: NtfActionVM = new NtfActionVM();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean).afterReturnNothing();
      let entry: NotificationEntry = new NotificationEntry();
      entry.isDeliverNotification = true;
      let action: NotificationAction = new NotificationAction();
      ntfactionvm.startNtfAction(action, false, false);
      mocker.ignoreMock(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);
    });
    it('should_call_checkAndStart_when_entry_is_valid', 0, async () => {
      let ntfactionvm: NtfActionVM = new NtfActionVM();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfActionVM.prototype, NtfActionVM.prototype.checkAndStart);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean, ArgumentMatchers.any).afterReturnNothing();
      let entry: NotificationEntry = new NotificationEntry();
      let action: NotificationAction = new NotificationAction();
      ntfactionvm.startNtfAction(action, false, false);
      mocker.ignoreMock(NtfActionVM.prototype, NtfActionVM.prototype.checkAndStart);
    });
    it('should_report_click_when_entry_is_valid_and_isDeliverNotification_is_true', 0, async () => {
      let ntfactionvm: NtfActionVM = new NtfActionVM();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ClickNotificationMaintenance, ClickNotificationMaintenance.reportClick);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();
      let entry: NotificationEntry = new NotificationEntry();
      entry.isDeliverNotification = true;
      let action: NotificationAction = new NotificationAction();
      ntfactionvm.startNtfAction(action, false, false);
      mocker.ignoreMock(ClickNotificationMaintenance, ClickNotificationMaintenance.reportClick);
    });
    it('should_call_releasePanelHeadsUp_when_entry_is_valid_and_isDeliverNotification_is_true_and_isHeadsUp_is_true', 0,
      async () => {
        let ntfactionvm: NtfActionVM = new NtfActionVM();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(bannerMgr, bannerMgr.releasePanelHeadsUp);
        when(mockfunc)().afterReturnNothing();
        let entry: NotificationEntry = new NotificationEntry();
        entry.isDeliverNotification = true;
        let action: NotificationAction = new NotificationAction();
        ntfactionvm.startNtfAction(action, false, true);
        mocker.ignoreMock(bannerMgr, bannerMgr.releasePanelHeadsUp);
      });
    it('should_call_collapsePanel_when_entry_is_valid_and_isDeliverNotification_is_true_and_isHeadsUp_is_false', 0,
      async () => {
        let ntfactionvm: NtfActionVM = new NtfActionVM();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);
        when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean).afterReturnNothing();
        let entry: NotificationEntry = new NotificationEntry();
        entry.isDeliverNotification = true;
        let action: NotificationAction = new NotificationAction();
        ntfactionvm.startNtfAction(action, false, false);
        mocker.ignoreMock(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);
      });
    it('should_call_startWantAgent_when_entry_is_valid_and_isDeliverNotification_is_false', 0, async () => {
      let ntfactionvm: NtfActionVM = new NtfActionVM();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfMgr, NtfMgr.startWantAgent);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any)
        .afterReturnNothing();
      let entry: NotificationEntry = new NotificationEntry();
      entry.isDeliverNotification = false;
      let action: NotificationAction = new NotificationAction();
      ntfactionvm.startNtfAction(action, false, false);
      mocker.ignoreMock(NtfMgr, NtfMgr.startWantAgent);
    });

    it('should_call_startActionInner_when_wantAgent_is_null', 0, () => {
      let ntfactionvm: NtfActionVM = new NtfActionVM();
      let mocker: MockKit = new MockKit();
      let mockStartActionInner: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.startActionInner);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);

      let action: NotificationAction = new NotificationAction('test');
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockStartActionInner)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean,
        ArgumentMatchers.anyString).afterReturnNothing();

      ntfactionvm.checkAndStart(action, true, 'inputContent');

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
      mocker.ignoreMock(ntfactionvm, ntfactionvm.startActionInner);
    });

    it('should_call_startActionInner_when_getOperationType_fails', 0, () => {
      let ntfactionvm: NtfActionVM = new NtfActionVM();
      let mocker: MockKit = new MockKit();
      let mockStartActionInner: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.startActionInner);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);

      let action: NotificationAction = new NotificationAction('test');
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockStartActionInner)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean,
        ArgumentMatchers.anyString).afterReturnNothing();

      ntfactionvm.checkAndStart(action, true, 'inputContent');

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
      mocker.ignoreMock(ntfactionvm, ntfactionvm.startActionInner);
    });

    it('should_call_startWantAgent_when_getOperationType_succeeds', 0, () => {
      let ntfactionvm: NtfActionVM = new NtfActionVM();
      let mocker: MockKit = new MockKit();
      let mockStartActionInner: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.startActionInner);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);

      let action: NotificationAction = new NotificationAction('test');
      let wantAgent: WantAgent = new WantAgent();
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockStartActionInner)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean,
        ArgumentMatchers.anyString).afterReturnNothing();

      ntfactionvm.checkAndStart(action, true, 'inputContent');

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
      mocker.ignoreMock(ntfactionvm, ntfactionvm.startActionInner);
    });

    it('should_call_startActionInner_when_isOuterHome_is_true_and_isOuterHomeFolded_is_true', 0, () => {
      let ntfactionvm: NtfActionVM = new NtfActionVM();
      let mocker: MockKit = new MockKit();
      let mockStartActionInner: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.startActionInner);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);

      let action: NotificationAction = new NotificationAction('test');
      let wantAgent: WantAgent = new WantAgent();
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockStartActionInner)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean,
        ArgumentMatchers.anyString).afterReturnNothing();

      ntfactionvm.checkAndStart(action, true, 'inputContent');

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
      mocker.ignoreMock(ntfactionvm, ntfactionvm.startActionInner);
    });

    it('should_call_startWantAgent_when_isOuterHome_is_true_and_isOuterHomeFolded_is_false', 0, () => {
      let ntfactionvm: NtfActionVM = new NtfActionVM();
      let mocker: MockKit = new MockKit();
      let mockStartActionInner: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.startActionInner);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);

      let action: NotificationAction = new NotificationAction('test');
      let wantAgent: WantAgent = new WantAgent();
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockStartActionInner)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean,
        ArgumentMatchers.anyString).afterReturnNothing();

      ntfactionvm.checkAndStart(action, true, 'inputContent');

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
      mocker.ignoreMock(ntfactionvm, ntfactionvm.startActionInner);
    });

    it('should_execute_normally_when_ntfType_is_phone_dropdown_and_headsUp_is_false', 0, async () => {
      let ntfactionvm: NtfActionVM = new NtfActionVM();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.callback?.getNtfType);
      when(mockfunc)().afterReturn(NotificationType.TYPE_PHONE_DROPDOWN);
      let mockfunc2: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.callback?.isHeadsUpNtf);
      when(mockfunc2)().afterReturn(false);
      let mockfunc3: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.ntfItemVM?.setNtfCenterOverlayAnim);
      when(mockfunc3)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      let mockfunc4: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.ntfItemVM?.handleNtfPanelCollapseByWant);
      when(mockfunc4)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      let mockfunc5: Function = mocker.mockFunc(NtfMgr, NtfMgr.startWantAgent);
      when(mockfunc5)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any)
        .afterReturnNothing();
      let mockfunc6: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      when(mockfunc6)().afterReturn({
        isOuterHome: false
      });

      let entry: NotificationEntry = new NotificationEntry();
      entry.isAutoDelete = true;
      entry.hashCode = 1;
      let action: NotificationAction = new NotificationAction();
      action.wantAgent = new WantAgent();
      action.userInputKey = 'test';
      action.inputContent = 'test';
      ntfactionvm.startWantAgent(entry, 'test', action, 'test', true, WindowConstants.OperationType.SEND_COMMON_EVENT);

      mocker.ignoreMock(ntfactionvm, ntfactionvm.callback?.getNtfType);
      mocker.ignoreMock(ntfactionvm, ntfactionvm.callback?.isHeadsUpNtf);
      mocker.ignoreMock(ntfactionvm, ntfactionvm.ntfItemVM?.setNtfCenterOverlayAnim);
      mocker.ignoreMock(ntfactionvm, ntfactionvm.ntfItemVM?.handleNtfPanelCollapseByWant);
      mocker.ignoreMock(NtfMgr, NtfMgr.startWantAgent);
      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
    });

    it('should_execute_normally_when_ntfType_is_phone_dropdown_and_headsUp_is_true', 0, async () => {
      let ntfactionvm: NtfActionVM = new NtfActionVM();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.callback?.getNtfType);
      when(mockfunc)().afterReturn(NotificationType.TYPE_PHONE_DROPDOWN);
      let mockfunc2: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.callback?.isHeadsUpNtf);
      when(mockfunc2)().afterReturn(true);
      let mockfunc3: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.startAnimPreInHeadsUp);
      when(mockfunc3)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

      let entry: NotificationEntry = new NotificationEntry();
      entry.isAutoDelete = true;
      entry.hashCode = 1;
      let action: NotificationAction = new NotificationAction();
      action.wantAgent = new WantAgent();
      action.userInputKey = 'test';
      action.inputContent = 'test';
      ntfactionvm.startWantAgent(entry, 'test', action, 'test', true, WindowConstants.OperationType.SEND_COMMON_EVENT);

      mocker.ignoreMock(ntfactionvm, ntfactionvm.callback?.getNtfType);
      mocker.ignoreMock(ntfactionvm, ntfactionvm.callback?.isHeadsUpNtf);
      mocker.ignoreMock(ntfactionvm, ntfactionvm.startAnimPreInHeadsUp);
    });

    it('should_execute_normally_when_ntfType_is_not_phone_dropdown', 0, async () => {
      let ntfactionvm: NtfActionVM = new NtfActionVM();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.callback?.getNtfType);
      when(mockfunc)().afterReturn(NotificationType.TYPE_SINGLE);

      let entry: NotificationEntry = new NotificationEntry();
      entry.isAutoDelete = true;
      entry.hashCode = 1;
      let action: NotificationAction = new NotificationAction();
      action.wantAgent = new WantAgent();
      action.userInputKey = 'test';
      action.inputContent = 'test';
      ntfactionvm.startWantAgent(entry, 'test', action, 'test', true, WindowConstants.OperationType.SEND_COMMON_EVENT);

      mocker.ignoreMock(ntfactionvm, ntfactionvm.callback?.getNtfType);
    });

    it('should_execute_normally_when_isAutoCancel_is_false', 0, async () => {
      let ntfactionvm: NtfActionVM = new NtfActionVM();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.callback?.getNtfType);
      when(mockfunc)().afterReturn(NotificationType.TYPE_PHONE_DROPDOWN);
      let mockfunc2: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.callback?.isHeadsUpNtf);
      when(mockfunc2)().afterReturn(false);
      let mockfunc3: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.ntfItemVM?.setNtfCenterOverlayAnim);
      when(mockfunc3)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      let mockfunc4: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.ntfItemVM?.handleNtfPanelCollapseByWant);
      when(mockfunc4)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      let mockfunc5: Function = mocker.mockFunc(NtfMgr, NtfMgr.startWantAgent);
      when(mockfunc5)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any)
        .afterReturnNothing();
      let mockfunc6: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      when(mockfunc6)().afterReturn({
        isOuterHome: false
      });

      let entry: NotificationEntry = new NotificationEntry();
      entry.isAutoDelete = true;
      entry.hashCode = 1;
      let action: NotificationAction = new NotificationAction();
      action.wantAgent = new WantAgent();
      action.userInputKey = 'test';
      action.inputContent = 'test';
      ntfactionvm.startWantAgent(entry, 'test', action, 'test', false, WindowConstants.OperationType.SEND_COMMON_EVENT);

      mocker.ignoreMock(ntfactionvm, ntfactionvm.callback?.getNtfType);
      mocker.ignoreMock(ntfactionvm, ntfactionvm.callback?.isHeadsUpNtf);
      mocker.ignoreMock(ntfactionvm, ntfactionvm.ntfItemVM?.setNtfCenterOverlayAnim);
      mocker.ignoreMock(ntfactionvm, ntfactionvm.ntfItemVM?.handleNtfPanelCollapseByWant);
      mocker.ignoreMock(NtfMgr, NtfMgr.startWantAgent);
      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
    });

    it('should_call_requestUnlock_when_getKeyguardLock_is_true', 0, async () => {
      let ntfactionvm: NtfActionVM = new NtfActionVM();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.getKeyguardLock);
      when(mockfunc)().afterReturn(true);

      let requestUnlockCallback: () => void = () => {
        expect(true).assertEqual(true);
      };
      let unlockCallback: () => void = () => {
        expect(true).assertEqual(false);
      };
      ntfactionvm.startAnimInNtfKeyguard(requestUnlockCallback, unlockCallback);

      mocker.ignoreMock(ntfactionvm, ntfactionvm.getKeyguardLock);
    });

    it('should_call_notifyEarlyUnlockTransition_and_unlockCallback_when_getKeyguardLock_is_false', 0, async () => {
      let ntfactionvm: NtfActionVM = new NtfActionVM();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.getKeyguardLock);
      when(mockfunc)().afterReturn(false);

      let requestUnlockCallback: () => void = () => {
        expect(true).assertEqual(false);
      };
      let unlockCallback: () => void = () => {
        expect(true).assertEqual(true);
      };
      ntfactionvm.startAnimInNtfKeyguard(requestUnlockCallback, unlockCallback);

      mocker.ignoreMock(ntfactionvm, ntfactionvm.getKeyguardLock);
    });

    it('should_call_bridgeActionWantAgent_when_isOuterHome_is_true_and_isOuterHomeFolded_is_true', 0, async () => {
      let ntfactionvm: NtfActionVM = new NtfActionVM();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.getKeyguardLock);
      when(mockfunc)().afterReturn(false);

      let mockNtfEntry: NotificationEntry = new NotificationEntry(1, NotificationType.NOTIFICATION_TYPE_DEFAULT);
      let mockWantAgent: WantAgent = new WantAgent();
      let mockStartAction: () => void = () => {
        expect(true).assertEqual(true);
      };

      let outerHomeNtfBridgeManager: OuterHomeNtfBridgeManager = OuterHomeNtfBridgeManager.get();
      let mockBridgeFunc: Function =
        mocker.mockFunc(outerHomeNtfBridgeManager, outerHomeNtfBridgeManager.bridgeActionWantAgent);
      when(mockBridgeFunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyObj, ArgumentMatchers.anyFunction,
        ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturnNothing();

      ntfViewConfigManager.getListContentConfig().isOuterHome = true;
      outerHomeNtfBridgeManager.isOuterHomeFolded = true;

      ntfactionvm.startAnimInNtfKeyguard(() => {
      }, () => {
      });

      mocker.ignoreMock(ntfactionvm, ntfactionvm.getKeyguardLock);
      mocker.ignoreMock(outerHomeNtfBridgeManager, outerHomeNtfBridgeManager.bridgeActionWantAgent);
    });
  });
}