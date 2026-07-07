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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NtfActionVM } from '../../../main/ets/vm/NtfActionVM';
export default function NtfActionVMTest() {
  describe('checkAndStart_testSuite', () => {

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

    it('should_call_bridgeActionWantAgent_when_isOuterHome_is_true', 0, () => {
      let ntfactionvm: NtfActionVM = new NtfActionVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(null);
      let mockBridgeActionWantAgent: Function =
        mocker.mockFunc(OuterHomeNtfBridgeManager, OuterHomeNtfBridgeManager.bridgeActionWantAgent);
      when(mockBridgeActionWantAgent)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any,
        ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      let action: NotificationAction = new NotificationAction('test');
      action.wantAgent = new WantAgent();
      ntfactionvm.callback = {
        getNtfEntry: () => null,
        getNtfType: () => NotificationType.NOTIFICATION_TYPE_DEFAULT
      };
      ntfViewConfigManager.isOuterHome = true;
      ntfViewConfigManager.isOuterHomeFolded = true;
      ntfactionvm.checkAndStart(action, true, 'inputContent');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(OuterHomeNtfBridgeManager, OuterHomeNtfBridgeManager.bridgeActionWantAgent);
    });

    it('should_call_startActionInner_when_isStartAbility_is_true', 0, () => {
      let ntfactionvm: NtfActionVM = new NtfActionVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(null);
      let mockStartActionInner: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.startActionInner);
      when(mockStartActionInner)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any,
        ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      let action: NotificationAction = new NotificationAction('test');
      action.wantAgent = new WantAgent();
      ntfactionvm.callback = {
        getNtfEntry: () => null,
        getNtfType: () => NotificationType.NOTIFICATION_TYPE_DEFAULT
      };
      ntfViewConfigManager.isOuterHome = false;
      ntfViewConfigManager.isStartAbility = true;
      ntfactionvm.checkAndStart(action, true, 'inputContent');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(ntfactionvm, ntfactionvm.startActionInner);
    });
  });
  it('should_start_want_agent_when_ntf_type_is_phone_dropdown_and_heads_up_is_false', 0, async () => {
    let ntfactionvm: NtfActionVM = new NtfActionVM();
    let mocker: MockKit = new MockKit();
    let mockStartWantAgent: Function = mocker.mockFunc(NtfMgr, NtfMgr.startWantAgent);
    let mockStartActionInner: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.startActionInner);
    let mockGetNtfListVmInstance: Function = mocker.mockFunc(NTF_LIST_VM_HOLDER, NTF_LIST_VM_HOLDER.getNtfListVmInstance);
    let mockBridgeActionWantAgent: Function = mocker.mockFunc(OuterHomeNtfBridgeManager, OuterHomeNtfBridgeManager.bridgeActionWantAgent);
    let mockStartAnimPre: Function = mocker.mockFunc(liveStartAnimMgr, liveStartAnimMgr.startAnimPre);

    let entry: NotificationEntry = new NotificationEntry();
    entry.isAutoDelete = true;
    entry.isDeliverNotification = true;
    entry.hashCode = 1;
    let action: NotificationAction = new NotificationAction();
    action.wantAgent = new WantAgent();
    action.userInputKey = 'test';
    action.inputContent = 'test';
    let inputContent: string = 'test';
    let isAutoCancel: boolean = true;
    let operType: number = 1;
    let bundleName: string = 'test';

    when(mockGetNtfListVmInstance)([NotificationType.TYPE_PHONE_DROPDOWN]).afterReturn(new NtfListVm());
    when(mockStartWantAgent)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(Promise.resolve());
    when(mockStartActionInner)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();
    when(mockBridgeActionWantAgent)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(Promise.resolve());
    when(mockStartAnimPre)([ArgumentMatchers.any]).afterReturnNothing();

    ntfactionvm.callback = {
      getNtfType: () => NotificationType.TYPE_PHONE_DROPDOWN,
      isHeadsUpNtf: () => false,
      isNtfKeyguard: () => false
    };
    ntfactionvm.ntfItemVM = new NtfSingleItemVM();

    await ntfactionvm.startWantAgent(entry, bundleName, action, inputContent, isAutoCancel, operType);

    mocker.ignoreMock(NtfMgr, NtfMgr.startWantAgent);
    mocker.ignoreMock(ntfactionvm, ntfactionvm.startActionInner);
    mocker.ignoreMock(NTF_LIST_VM_HOLDER, NTF_LIST_VM_HOLDER.getNtfListVmInstance);
    mocker.ignoreMock(OuterHomeNtfBridgeManager, OuterHomeNtfBridgeManager.bridgeActionWantAgent);
    mocker.ignoreMock(liveStartAnimMgr, liveStartAnimMgr.startAnimPre);
  });
  it('should_start_want_agent_when_ntf_type_is_phone_dropdown_and_heads_up_is_true_and_auto_cancel_is_true', 0, async () => {
    let ntfactionvm: NtfActionVM = new NtfActionVM();
    let mocker: MockKit = new MockKit();
    let mockStartWantAgent: Function = mocker.mockFunc(NtfMgr, NtfMgr.startWantAgent);
    let mockStartActionInner: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.startActionInner);
    let mockGetNtfListVmInstance: Function = mocker.mockFunc(NTF_LIST_VM_HOLDER, NTF_LIST_VM_HOLDER.getNtfListVmInstance);
    let mockBridgeActionWantAgent: Function = mocker.mockFunc(OuterHomeNtfBridgeManager, OuterHomeNtfBridgeManager.bridgeActionWantAgent);
    let mockStartAnimPre: Function = mocker.mockFunc(liveStartAnimMgr, liveStartAnimMgr.startAnimPre);

    let entry: NotificationEntry = new NotificationEntry();
    entry.isAutoDelete = true;
    entry.isDeliverNotification = true;
    entry.hashCode = 1;
    let action: NotificationAction = new NotificationAction();
    action.wantAgent = new WantAgent();
    action.userInputKey = 'test';
    action.inputContent = 'test';
    let inputContent: string = 'test';
    let isAutoCancel: boolean = true;
    let operType: number = 1;
    let bundleName: string = 'test';

    when(mockGetNtfListVmInstance)([NotificationType.TYPE_PHONE_DROPDOWN]).afterReturn(new NtfListVm());
    when(mockStartWantAgent)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(Promise.resolve());
    when(mockStartActionInner)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();
    when(mockBridgeActionWantAgent)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(Promise.resolve());
    when(mockStartAnimPre)([ArgumentMatchers.any]).afterReturnNothing();

    ntfactionvm.callback = {
      getNtfType: () => NotificationType.TYPE_PHONE_DROPDOWN,
      isHeadsUpNtf: () => true,
      isNtfKeyguard: () => false
    };
    ntfactionvm.ntfItemVM = new NtfSingleItemVM();

    await ntfactionvm.startWantAgent(entry, bundleName, action, inputContent, isAutoCancel, operType);

    mocker.ignoreMock(NtfMgr, NtfMgr.startWantAgent);
    mocker.ignoreMock(ntfactionvm, ntfactionvm.startActionInner);
    mocker.ignoreMock(NTF_LIST_VM_HOLDER, NTF_LIST_VM_HOLDER.getNtfListVmInstance);
    mocker.ignoreMock(OuterHomeNtfBridgeManager, OuterHomeNtfBridgeManager.bridgeActionWantAgent);
    mocker.ignoreMock(liveStartAnimMgr, liveStartAnimMgr.startAnimPre);
  });
  it('should_start_want_agent_when_ntf_type_is_phone_dropdown_and_heads_up_is_true_and_auto_cancel_is_true_1', 0, async () => {
    let ntfactionvm: NtfActionVM = new NtfActionVM();
    let mocker: MockKit = new MockKit();
    let mockStartWantAgent: Function = mocker.mockFunc(NtfMgr, NtfMgr.startWantAgent);
    let mockStartActionInner: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.startActionInner);
    let mockGetNtfListVmInstance: Function = mocker.mockFunc(NTF_LIST_VM_HOLDER, NTF_LIST_VM_HOLDER.getNtfListVmInstance);
    let mockBridgeActionWantAgent: Function = mocker.mockFunc(OuterHomeNtfBridgeManager, OuterHomeNtfBridgeManager.bridgeActionWantAgent);
    let mockStartAnimPre: Function = mocker.mockFunc(liveStartAnimMgr, liveStartAnimMgr.startAnimPre);

    let entry: NotificationEntry = new NotificationEntry();
    entry.isAutoDelete = true;
    entry.isDeliverNotification = true;
    entry.hashCode = 1;
    let action: NotificationAction = new NotificationAction();
    action.wantAgent = new WantAgent();
    action.userInputKey = 'test';
    action.inputContent = 'test';
    let inputContent: string = 'test';
    let isAutoCancel: boolean = true;
    let operType: number = 1;
    let bundleName: string = 'test';

    when(mockGetNtfListVmInstance)([NotificationType.TYPE_PHONE_DROPDOWN]).afterReturn(new NtfListVm());
    when(mockStartWantAgent)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(Promise.resolve());
    when(mockStartActionInner)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();
    when(mockBridgeActionWantAgent)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(Promise.resolve());
    when(mockStartAnimPre)([ArgumentMatchers.any]).afterReturnNothing();

    ntfactionvm.callback = {
      getNtfType: () => NotificationType.TYPE_PHONE_DROPDOWN,
      isHeadsUpNtf: () => true,
      isNtfKeyguard: () => false
    };
    ntfactionvm.ntfItemVM = new NtfSingleItemVM();

    await ntfactionvm.startWantAgent(entry, bundleName, action, inputContent, isAutoCancel, operType);

    mocker.ignoreMock(NtfMgr, NtfMgr.startWantAgent);
    mocker.ignoreMock(ntfactionvm, ntfactionvm.startActionInner);
    mocker.ignoreMock(NTF_LIST_VM_HOLDER, NTF_LIST_VM_HOLDER.getNtfListVmInstance);
    mocker.ignoreMock(OuterHomeNtfBridgeManager, OuterHomeNtfBridgeManager.bridgeActionWantAgent);
    mocker.ignoreMock(liveStartAnimMgr, liveStartAnimMgr.startAnimPre);
  });
  it('should_call_requestUnlock_when_getKeyguardLock_is_true', 0, async () => {
    let ntfactionvm: NtfActionVM = new NtfActionVM();
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.getKeyguardLock);
    when(mockfunc)().afterReturn(true);


    ntfactionvm.startAnimInNtfKeyguard(() => {}, () => {});

    mocker.ignoreMock(ntfactionvm, ntfactionvm.getKeyguardLock);
  });

  it('should_call_notifyEarlyUnlockTransition_and_unlockCallback_when_getKeyguardLock_is_false', 0, async () => {
    let ntfactionvm: NtfActionVM = new NtfActionVM();
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.getKeyguardLock);
    when(mockfunc)().afterReturn(false);


    ntfactionvm.startAnimInNtfKeyguard(() => {}, () => {});

    mocker.ignoreMock(ntfactionvm, ntfactionvm.getKeyguardLock);
  });
  it('should_call_requestUnlock_with_success_callback_when_getKeyguardLock_is_true', 0, async () => {
    let ntfactionvm: NtfActionVM = new NtfActionVM();
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.getKeyguardLock);
    when(mockfunc)().afterReturn(true);


    let successCallbackCalled = false;
    ScreenLockApi.requestUnlock({
      success: () => {
        successCallbackCalled = true;
      }
    });

    expect(successCallbackCalled).assertTrue();

    mocker.ignoreMock(ntfactionvm, ntfactionvm.getKeyguardLock);
  });

  it('should_call_unlockCallback_when_getKeyguardLock_is_false', 0, async () => {
    let ntfactionvm: NtfActionVM = new NtfActionVM();
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.getKeyguardLock);
    when(mockfunc)().afterReturn(false);


    let unlockCallbackCalled = false;
    ntfactionvm.startAnimInNtfKeyguard(() => {
      unlockCallbackCalled = true;
    }, () => {});

    expect(unlockCallbackCalled).assertTrue();

    mocker.ignoreMock(ntfactionvm, ntfactionvm.getKeyguardLock);
  });
  it('should_call_notifyEarlyUnlockTransition_when_getKeyguardLock_is_false', 0, async () => {
    let ntfactionvm: NtfActionVM = new NtfActionVM();
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.getKeyguardLock);
    when(mockfunc)().afterReturn(false);


    ntfactionvm.startAnimInNtfKeyguard(() => {}, () => {});

    mocker.ignoreMock(ntfactionvm, ntfactionvm.getKeyguardLock);
  });

  it('should_call_startWantAgent_when_isOuterHome_is_true_and_isOuterHomeFolded_is_true', 0, async () => {
    let ntfactionvm: NtfActionVM = new NtfActionVM();
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.getKeyguardLock);
    when(mockfunc)().afterReturn(false);

    let mockIsOuterHome = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig().isOuterHome);
    when(mockIsOuterHome)().afterReturn(true);

    let mockIsOuterHomeFolded = mocker.mockFunc(OuterHomeNtfBridgeManager.get(), OuterHomeNtfBridgeManager.get().isOuterHomeFolded);
    when(mockIsOuterHomeFolded)().afterReturn(true);

    let mockStartWantAgent = mocker.mockFunc(NtfMgr, NtfMgr.startWantAgent);
    when(mockStartWantAgent)(ArgumentMatchers.anyObj, ArgumentMatchers.anyFunction, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturnNothing();

    ntfactionvm.startAnimInNtfKeyguard(() => {}, () => {});

    mocker.ignoreMock(ntfactionvm, ntfactionvm.getKeyguardLock);
    mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig().isOuterHome);
    mocker.ignoreMock(OuterHomeNtfBridgeManager.get(), OuterHomeNtfBridgeManager.get().isOuterHomeFolded);
    mocker.ignoreMock(NtfMgr, NtfMgr.startWantAgent);
  });
  it('should_call_startWantAgent_when_isOuterHome_is_true_and_isOuterHomeFolded_is_false', 0, async () => {
    let ntfactionvm: NtfActionVM = new NtfActionVM();
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.getKeyguardLock);
    when(mockfunc)().afterReturn(false);

    let mockIsOuterHome = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig().isOuterHome);
    when(mockIsOuterHome)().afterReturn(true);

    let mockIsOuterHomeFolded = mocker.mockFunc(OuterHomeNtfBridgeManager.get(), OuterHomeNtfBridgeManager.get().isOuterHomeFolded);
    when(mockIsOuterHomeFolded)().afterReturn(false);

    let mockStartWantAgent = mocker.mockFunc(NtfMgr, NtfMgr.startWantAgent);
    when(mockStartWantAgent)(ArgumentMatchers.anyObj, ArgumentMatchers.anyFunction, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturnNothing();

    ntfactionvm.startAnimInNtfKeyguard(() => {}, () => {});

    mocker.ignoreMock(ntfactionvm, ntfactionvm.getKeyguardLock);
    mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig().isOuterHome);
    mocker.ignoreMock(OuterHomeNtfBridgeManager.get(), OuterHomeNtfBridgeManager.get().isOuterHomeFolded);
    mocker.ignoreMock(NtfMgr, NtfMgr.startWantAgent);
  });

  it('should_call_startWantAgent_when_isOuterHome_is_false', 0, async () => {
    let ntfactionvm: NtfActionVM = new NtfActionVM();
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(ntfactionvm, ntfactionvm.getKeyguardLock);
    when(mockfunc)().afterReturn(false);

    let mockIsOuterHome = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig().isOuterHome);
    when(mockIsOuterHome)().afterReturn(false);

    let mockStartWantAgent = mocker.mockFunc(NtfMgr, NtfMgr.startWantAgent);
    when(mockStartWantAgent)(ArgumentMatchers.anyObj, ArgumentMatchers.anyFunction, ArgumentMatchers.anyString, ArgumentMatchers.anyObj).afterReturnNothing();

    ntfactionvm.startAnimInNtfKeyguard(() => {}, () => {});

    mocker.ignoreMock(ntfactionvm, ntfactionvm.getKeyguardLock);
    mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig().isOuterHome);
    mocker.ignoreMock(NtfMgr, NtfMgr.startWantAgent);
  });
  it('should_return_immediately_when_entry_or_ntfItemVM_is_null', 0, () => {
    let ntfactionvm: NtfActionVM = new NtfActionVM();
    ntfactionvm.startAnimPreInHeadsUp(null, () => {});
  });
  it('should_call_liveStartAnimMgr_startAnimPre_when_callback_isNtfKeyguard_is_false', 0, async () => {
    let mocker: MockKit = new MockKit();
    let mockStartAnimPre: Function = mocker.mockFunc(liveStartAnimMgr, liveStartAnimMgr.startAnimPre);
    when(mockStartAnimPre)(ArgumentMatchers.any).afterReturnNothing();

    let entry: NotificationEntry = new NotificationEntry();
    let ntfactionvm: NtfActionVM = new NtfActionVM();
    ntfactionvm.ntfItemVM = new NtfSingleItemVM();
    ntfactionvm.callback = {
      isNtfKeyguard: () => false,
      getNtfType: () => NotificationType.NOTIFICATION_TYPE_DEFAULT
    } as ActionCallback;
    ntfactionvm.startAnimPreInHeadsUp(entry, () => {});

    mocker.ignoreMock(liveStartAnimMgr, liveStartAnimMgr.startAnimPre);
  });
  it('should_call_startAnimInNtfKeyguard_when_callback_isNtfKeyguard_is_true', 0, async () => {
    let mocker: MockKit = new MockKit();
    let mockStartAnimInNtfKeyguard: Function = mocker.mockFunc(NtfActionVM.prototype, NtfActionVM.prototype.startAnimInNtfKeyguard);
    when(mockStartAnimInNtfKeyguard)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();

    let entry: NotificationEntry = new NotificationEntry();
    let ntfactionvm: NtfActionVM = new NtfActionVM();
    ntfactionvm.ntfItemVM = new NtfSingleItemVM();
    ntfactionvm.callback = {
      isNtfKeyguard: () => true,
      getNtfType: () => NotificationType.NOTIFICATION_TYPE_DEFAULT
    } as ActionCallback;
    ntfactionvm.startAnimPreInHeadsUp(entry, () => {});

    mocker.ignoreMock(NtfActionVM.prototype, NtfActionVM.prototype.startAnimInNtfKeyguard);
  });
}