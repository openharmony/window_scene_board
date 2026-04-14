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
import { NtfListVm } from '../../../../main/ets/model/NtfListVm';
import { NotificationEntry } from '../../../../main/ets/model/NotificationEntry';
import { NtfListScrollController } from '../../../../main/ets/controller/NtfListScrollController';
import {
  CommonUtils,
  DomainName,
  LogDomain,
  LogHelper,
  Trace,
  TraceUtil,
  RectInfo,
  AnimateToScheduleUtils
} from '@ohos/basicutils';
import {
  DropDownEvent,
  EventManager,
  EvtBus,
  HiDfxEventUtil,
  TargetPanel,
  DeviceHelper
} from '@ohos/frameworkwrapper';
import { ResUtils, SCBSceneSessionManager } from '@ohos/windowscene';
import { ItemUtils } from '@ohos/componenthelper';
import { DeviceModeEnum } from '@ohos/commonconstants';
import { DropDownPanelConstants, DropDownPanelManager, ProgressCardAnimVm,
  OhterCardExtendAnimVm,
  OuterHomeVm,
} from '@ohos/systemuicommon/Index';
import { NotificationConfig } from '../../../../main/ets/common/NotificationConfig';
import curves from '@ohos.curves';
import { NotificationListItem } from '../../../../main/ets/pages/phone/NotificationListItem';
import { NotificationAnimationParas } from '../../../../main/ets/common/NotificationAnimationParas';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { NotificationExtraHeader } from '../../../../main/ets/pages/phone/NotificationExtraHeader';
import { NotificationExtraContentBrief } from '../../../../main/ets/pages/phone/NotificationExtraContentBrief';
import { NotificationSettings } from '../../../../main/ets/pages/common/NotificationSettings';
import { NotificationClose } from '../../../../main/ets/pages/common/NotificationClose';
import { NtfCloseVM } from '../../../../main/ets/vm/NtfCloseVM';
import { NtfDataChangeType } from '../../../../main/ets/model/NotificationListAdapter';
import { NtfColorModeVM } from '../../../../main/ets/vm/NtfColorModeVM';
import NtfDropdownController from '../../../../main/ets/controller/NotificationDropdownController';
import { ntfViewConfigManager } from '../../../../main/ets/vm/config/NtfViewConfigManager';
import { NtfListContentConfig } from '../../../../main/ets/vm/config/NtfViewConfig';
import { NtfAnimVM } from '../../../../main/ets/vm/NtfAnimVM';
import { NotificationConstants } from '../../../../main/ets/common/NotificationConstants';
import { blurButtonVM } from '../../../../main/ets/vm/BlurButtonVM';
import {
  CardScaleType,
  CardScaleUtil,
  EmergencyThermalAppType, getIsInEmergencyOrThermalSafeMode,
  LiveUseScene, fontScaleManager, FontScaleState } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { NtfAnimationConsts } from '../../../../main/ets/common/NtfAnimationConsts';
import { NtfClearAllAnimation } from '../../../../main/ets/animation/NtfClearAllAnimation';
import { NotificationPanelSlideParams,
  NotificationSysEventReporter } from '@ohos/systemuicommon/src/main/ets/utils/NotificationSysEventReporter';
import sDropDownPanelManager from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { ExtraNtfCollapsedAnimation } from '../../../../main/ets/animation/ExtraNtfCollapsedAnimation';
import {
  NtfAnimateEvent,
  NtfPinnedEvent,
  NtfListScrollEvent,
  NtfSwipeDeleteEvent,
  GroupItemExpandingEvent
} from '../../../../main/ets/common/event/NotificationEvent';
import { NtfScrollAnimation } from '../../../../main/ets/animation/NtfScrollAnimation';
import { AttributeUpdater, LengthMetrics } from '@kit.ArkUI';
import { screenLock, systemDateTime } from '@kit.BasicServicesKit';
import { SysFloatTipDialog } from '@ohos/screenlockcommon/Index';
import { ScreenLockNotificationConst } from '@ohos/screenlockcommon/';
import { NotificationGroupExpandAnimation } from '../../../../main/ets/animation/NotificationGroupExpandAnimation';
import { LayoutUtils, XTLayoutType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { NotificationListStyle } from '../../../../main/ets/vm/style/NotificationListStyle';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { LiveDropdownVmInjector } from '@ohos/systemuicommon/src/main/ets/live/variant/dropdown/LiveDropdownVmInjector';
import { LiveNotification } from '@ohos/systemuicommon/newTsIndex';
import { OuterHomeNtfBridgeManager } from '../../../../main/ets/manager/OuterHomeNtfBridgeManager';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {  } from '../../../../main/ets/pages/phone/NotificationListContent';
export default function Test() {
  describe('onNtfListDataChange_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_info_when_deleteAnimSyncFlag_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = true;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.BATCH_UPDATE);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_deleteAnimSyncFlag_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = false;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.BATCH_UPDATE);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_BATCH_UPDATE', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = false;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.BATCH_UPDATE);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_not_BATCH_UPDATE', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = false;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.FULL_UPDATE);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_not_BATCH_UPDATE_2', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = false;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.INCREMENTAL_UPDATE);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_not_BATCH_UPDATE_3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = false;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.UNKNOWN);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_BATCH_UPDATE_and_deleteAnimSyncFlag_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = true;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.BATCH_UPDATE);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_FULL_UPDATE_and_deleteAnimSyncFlag_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = true;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.FULL_UPDATE);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_INCREMENTAL_UPDATE_and_deleteAnimSyncFlag_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = true;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.INCREMENTAL_UPDATE);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_UNKNOWN_and_deleteAnimSyncFlag_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = true;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.UNKNOWN);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_not_BATCH_UPDATE_2', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = false;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.INCREMENTAL_UPDATE);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_not_BATCH_UPDATE_3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = false;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.UNKNOWN);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_BATCH_UPDATE_and_deleteAnimSyncFlag_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = true;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.BATCH_UPDATE);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_FULL_UPDATE_and_deleteAnimSyncFlag_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = true;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.FULL_UPDATE);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_INCREMENTAL_UPDATE_and_deleteAnimSyncFlag_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = true;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.INCREMENTAL_UPDATE);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_UNKNOWN_and_deleteAnimSyncFlag_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = true;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.UNKNOWN);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_not_BATCH_UPDATE_2', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = false;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.INCREMENTAL_UPDATE);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_not_BATCH_UPDATE_3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = false;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.UNKNOWN);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_BATCH_UPDATE_and_deleteAnimSyncFlag_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = true;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.BATCH_UPDATE);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_FULL_UPDATE_and_deleteAnimSyncFlag_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = true;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.FULL_UPDATE);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_INCREMENTAL_UPDATE_and_deleteAnimSyncFlag_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = true;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.INCREMENTAL_UPDATE);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_UNKNOWN_and_deleteAnimSyncFlag_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = true;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.UNKNOWN);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_not_BATCH_UPDATE_2', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = false;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.INCREMENTAL_UPDATE);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_not_BATCH_UPDATE_3', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = false;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.UNKNOWN);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_BATCH_UPDATE_and_deleteAnimSyncFlag_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = true;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.BATCH_UPDATE);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_FULL_UPDATE_and_deleteAnimSyncFlag_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = true;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.FULL_UPDATE);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_INCREMENTAL_UPDATE_and_deleteAnimSyncFlag_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = true;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.INCREMENTAL_UPDATE);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_UNKNOWN_and_deleteAnimSyncFlag_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = true;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.UNKNOWN);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_refresh_ntf_list_when_type_is_UNKNOWN_and_deleteAnimSyncFlag_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let ntfListChange: NtfListVm = new NtfListVm();
      ntfListChange.deleteAnimSyncFlag = true;
      ntfListChange.deleteAnimSyncData = [new NotificationEntry()];
      ntfListChange.onNtfListDataChange([new NotificationEntry()], NtfDataChangeType.UNKNOWN);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });
}
