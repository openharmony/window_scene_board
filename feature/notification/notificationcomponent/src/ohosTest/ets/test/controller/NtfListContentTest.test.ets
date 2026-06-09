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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {  } from '../../../../main/ets/pages/phone/NotificationListContent';
export default function Test() {
  describe('onFoldFullDisplayChange_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_update_isShowExtraNtfs_and_isOuterHomeFolded_correctly_when_isOuterHome_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetListContentConfig: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockNtfListContentConfig: NtfListContentConfig = {
        isOuterHome: true,
        isRefreshNftListByFoldState: false,
      };
      when(mockGetListContentConfig)().afterReturn(mockNtfListContentConfig);

      let mockMainNtfList: Array<NotificationListItem> = [new NotificationListItem()];

      let testee: OuterHomeVm = new OuterHomeVm();
      testee.ntfListVM = new NtfListVm();
      testee.ntfListVM.ntfAdapterList = mockMainNtfList;

      testee.onFoldFullDisplayChange();

      expect(testee.isShowExtraNtfs).assertEqual(true);
      expect(testee.isOuterHomeFolded).assertEqual(false);

      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_update_isShowExtraNtfs_and_isOuterHomeFolded_correctly_when_isOuterHome_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetListContentConfig: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockNtfListContentConfig: NtfListContentConfig = {
        isOuterHome: false,
        isRefreshNftListByFoldState: false,
      };
      when(mockGetListContentConfig)().afterReturn(mockNtfListContentConfig);

      let testee: OuterHomeVm = new OuterHomeVm();

      testee.onFoldFullDisplayChange();

      expect(testee.isShowExtraNtfs).assertEqual(false);
      expect(testee.isOuterHomeFolded).assertEqual(false);

      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_showInfo_when_isRefreshNftListByFoldState_is_true_and_ntfListVM_has_items', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetListContentConfig: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockNtfListContentConfig: NtfListContentConfig = {
        isOuterHome: true,
        isRefreshNftListByFoldState: true,
      };
      when(mockGetListContentConfig)().afterReturn(mockNtfListContentConfig);

      let mockMainNtfList: Array<NotificationListItem> = [new NotificationListItem()];

      let testee: OuterHomeVm = new OuterHomeVm();
      testee.ntfListVM = new NtfListVm();
      testee.ntfListVM.ntfAdapterList = mockMainNtfList;

      testee.onFoldFullDisplayChange();

      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_showInfo_when_isRefreshNftListByFoldState_is_false_and_ntfListVM_has_items', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetListContentConfig: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockNtfListContentConfig: NtfListContentConfig = {
        isOuterHome: true,
        isRefreshNftListByFoldState: false,
      };
      when(mockGetListContentConfig)().afterReturn(mockNtfListContentConfig);

      let mockMainNtfList: Array<NotificationListItem> = [new NotificationListItem()];

      let testee: OuterHomeVm = new OuterHomeVm();
      testee.ntfListVM = new NtfListVm();
      testee.ntfListVM.ntfAdapterList = mockMainNtfList;

      testee.onFoldFullDisplayChange();

      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_showInfo_when_isRefreshNftListByFoldState_is_true_and_ntfListVM_has_no_items', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetListContentConfig: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockNtfListContentConfig: NtfListContentConfig = {
        isOuterHome: true,
        isRefreshNftListByFoldState: true,
      };
      when(mockGetListContentConfig)().afterReturn(mockNtfListContentConfig);

      let mockMainNtfList: Array<NotificationListItem> = [];

      let testee: OuterHomeVm = new OuterHomeVm();
      testee.ntfListVM = new NtfListVm();
      testee.ntfListVM.ntfAdapterList = mockMainNtfList;

      testee.onFoldFullDisplayChange();

      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_showInfo_when_isRefreshNftListByFoldState_is_true_and_ntfListVM_has_no_items', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetListContentConfig: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockNtfListContentConfig: NtfListContentConfig = {
        isOuterHome: true,
        isRefreshNftListByFoldState: true,
      };
      when(mockGetListContentConfig)().afterReturn(mockNtfListContentConfig);

      let mockMainNtfList: Array<NotificationListItem> = [];

      let testee: OuterHomeVm = new OuterHomeVm();
      testee.ntfListVM = new NtfListVm();
      testee.ntfListVM.ntfAdapterList = mockMainNtfList;

      testee.onFoldFullDisplayChange();

      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_showInfo_when_isRefreshNftListByFoldState_is_true_and_ntfListVM_has_no_items', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetListContentConfig: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockNtfListContentConfig: NtfListContentConfig = {
        isOuterHome: true,
        isRefreshNftListByFoldState: true,
      };
      when(mockGetListContentConfig)().afterReturn(mockNtfListContentConfig);

      let mockMainNtfList: Array<NotificationListItem> = [];

      let testee: OuterHomeVm = new OuterHomeVm();
      testee.ntfListVM = new NtfListVm();
      testee.ntfListVM.ntfAdapterList = mockMainNtfList;

      testee.onFoldFullDisplayChange();

      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_showInfo_when_isRefreshNftListByFoldState_is_true_and_ntfListVM_has_no_items', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetListContentConfig: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockNtfListContentConfig: NtfListContentConfig = {
        isOuterHome: true,
        isRefreshNftListByFoldState: true,
      };
      when(mockGetListContentConfig)().afterReturn(mockNtfListContentConfig);

      let mockMainNtfList: Array<NotificationListItem> = [];

      let testee: OuterHomeVm = new OuterHomeVm();
      testee.ntfListVM = new NtfListVm();
      testee.ntfListVM.ntfAdapterList = mockMainNtfList;

      testee.onFoldFullDisplayChange();

      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_showInfo_when_isRefreshNftListByFoldState_is_true_and_ntfListVM_has_no_items', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetListContentConfig: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockNtfListContentConfig: NtfListContentConfig = {
        isOuterHome: true,
        isRefreshNftListByFoldState: true,
      };
      when(mockGetListContentConfig)().afterReturn(mockNtfListContentConfig);

      let mockMainNtfList: Array<NotificationListItem> = [];

      let testee: OuterHomeVm = new OuterHomeVm();
      testee.ntfListVM = new NtfListVm();
      testee.ntfListVM.ntfAdapterList = mockMainNtfList;

      testee.onFoldFullDisplayChange();

      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_showInfo_when_isRefreshNftListByFoldState_is_true_and_ntfListVM_has_no_items', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetListContentConfig: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockNtfListContentConfig: NtfListContentConfig = {
        isOuterHome: true,
        isRefreshNftListByFoldState: true,
      };
      when(mockGetListContentConfig)().afterReturn(mockNtfListContentConfig);

      let mockMainNtfList: Array<NotificationListItem> = [];

      let testee: OuterHomeVm = new OuterHomeVm();
      testee.ntfListVM = new NtfListVm();
      testee.ntfListVM.ntfAdapterList = mockMainNtfList;

      testee.onFoldFullDisplayChange();

      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_showInfo_when_isRefreshNftListByFoldState_is_true_and_ntfListVM_has_no_items', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetListContentConfig: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockNtfListContentConfig: NtfListContentConfig = {
        isOuterHome: true,
        isRefreshNftListByFoldState: true,
      };
      when(mockGetListContentConfig)().afterReturn(mockNtfListContentConfig);

      let mockMainNtfList: Array<NotificationListItem> = [];

      let testee: OuterHomeVm = new OuterHomeVm();
      testee.ntfListVM = new NtfListVm();
      testee.ntfListVM.ntfAdapterList = mockMainNtfList;

      testee.onFoldFullDisplayChange();

      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_showInfo_when_isRefreshNftListByFoldState_is_true_and_ntfListVM_has_no_items', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetListContentConfig: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockNtfListContentConfig: NtfListContentConfig = {
        isOuterHome: true,
        isRefreshNftListByFoldState: true,
      };
      when(mockGetListContentConfig)().afterReturn(mockNtfListContentConfig);

      let mockMainNtfList: Array<NotificationListItem> = [];

      let testee: OuterHomeVm = new OuterHomeVm();
      testee.ntfListVM = new NtfListVm();
      testee.ntfListVM.ntfAdapterList = mockMainNtfList;

      testee.onFoldFullDisplayChange();

      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });


    it('should_not_call_showInfo_when_isRefreshNftListByFoldState_is_true_and_ntfListVM_has_no_items', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetListContentConfig: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockNtfListContentConfig: NtfListContentConfig = {
        isOuterHome: true,
        isRefreshNftListByFoldState: true,
      };
      when(mockGetListContentConfig)().afterReturn(mockNtfListContentConfig);

      let mockMainNtfList: Array<NotificationListItem> = [];

      let testee: OuterHomeVm = new OuterHomeVm();
      testee.ntfListVM = new NtfListVm();
      testee.ntfListVM.ntfAdapterList = mockMainNtfList;

      testee.onFoldFullDisplayChange();

      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_showInfo_when_isRefreshNftListByFoldState_is_true_and_ntfListVM_has_no_items', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetListContentConfig: Function = mocker.mockFunc(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let mockNtfListContentConfig: NtfListContentConfig = {
        isOuterHome: true,
        isRefreshNftListByFoldState: true,
      };
      when(mockGetListContentConfig)().afterReturn(mockNtfListContentConfig);

      let mockMainNtfList: Array<NotificationListItem> = [];

      let testee: OuterHomeVm = new OuterHomeVm();
      testee.ntfListVM = new NtfListVm();
      testee.ntfListVM.ntfAdapterList = mockMainNtfList;

      testee.onFoldFullDisplayChange();

      mocker.ignoreMock(ntfViewConfigManager, ntfViewConfigManager.getListContentConfig);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_add_callback_to_swipeCallbacks_when_registerSwipeCallback_is_called', 0, () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let swipeCallback: SwipeCallback = new SwipeCallback();
      ntfitemswipecontroller.registerSwipeCallback(swipeCallback);
      expect(ntfitemswipecontroller.swipeCallbacks.has(swipeCallback)).assertTrue();
    });

    it('should_unregister_swipe_callback_successfully', 0, () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let swipeCallback: SwipeCallback = new SwipeCallback();
      ntfitemswipecontroller.unregisterSwipeCallback(swipeCallback);
      expect(ntfitemswipecontroller.swipeCallbacks.has(swipeCallback)).assertFalse();
    });

    it('should_set_groupEntryCB_correctly', 0, () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let groupEntryCB: () => NotificationEntry | undefined = () => undefined;
      ntfitemswipecontroller.setGroupEntryCB(groupEntryCB);
      expect(ntfitemswipecontroller.groupEntryCB).assertEqual(groupEntryCB);
    });

    it('should_set_ntfEntry_and_call_getItemCanClear_when_entry_is_not_null', 0, () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ntfitemswipecontroller, ntfitemswipecontroller.getItemCanClear);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let entry: NotificationEntry = new NotificationEntry(1, 1, 1, NotificationType.NOTIFICATION_TYPE_DEFAULT);
      ntfitemswipecontroller.setNtfEntry(entry);

      expect(ntfitemswipecontroller.ntfEntry).assertEqual(entry);
      mocker.ignoreMock(ntfitemswipecontroller, ntfitemswipecontroller.getItemCanClear);
    });

    it('should_set_ntfEntry_and_call_getItemCanClear_when_entry_is_null', 0, () => {
      let ntfitemswipecontroller: NtfItemSwipeController = new NtfItemSwipeController();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ntfitemswipecontroller, ntfitemswipecontroller.getItemCanClear);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let entry: NotificationEntry | null = null;
      ntfitemswipecontroller.setNtfEntry(entry);

      expect(ntfitemswipecontroller.ntfEntry).assertEqual(entry);
      mocker.ignoreMock(ntfitemswipecontroller, ntfitemswipecontroller.getItemCanClear);
    });
  });
}
