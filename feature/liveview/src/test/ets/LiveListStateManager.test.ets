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
import {
  BannerOutsideState,
  HandleClickAction,
  immersiveKgMgr,
  ImmersiveType,
  IState,
  LiveBaseTemplate,
  LiveButtonData,
  LiveOtherExtendData,
  LiveSystemTemplate,
  LiveViewData,
  LiveViewDataArray,
  OnStateChangeListener,
  OtherBaseTemplate,
  CardScaleUtil,
  LiveViewCommonConstants,
} from '@ohos/systemuicommon';
import {
  bannerMgr,
  phoneAppMgr,
  BannerPanelType,
  LiveExtendType,
  LiveUseScene,
  LiveViewEventType,
  LiveViewFormEntryEvent,
  NotificationSysEventReporter,
  SceneFlag,
  StateType,
  ImmersiveSysEventUtils
} from '@ohos/systemuicommon';
import {
  ArrayUtils,
  CommonUtils,
  LogDomain,
  StartType,
  LogHelper,
  RectInfo
} from '@ohos/basicutils';
import { ResUtils, SCBTransitionManager } from '@ohos/windowscene';
import { CustomPromise, EvtBus } from '@ohos/frameworkwrapper';
import { CloseAppManager } from '@ohos/launchercommon';
import { LiveListState } from '../../../main/ets/info/LiveListState';
import { LiveViewConstants } from '../../../main/ets/common/LiveViewConstants';
import { WantAgent } from '@ohos.wantAgent';
import wantAgent from '@ohos.app.ability.wantAgent';
import Ntf from '@ohos.notificationSubscribe';
import NtfManger from '@ohos.notificationManager';
import { DropDownPanelManager, liveStartAnimMgr, LiveViewSysEventUtil,
  NotificationType } from '@ohos/systemuicommon/Index';
import {
  ScreenLockApi,
  ScreenLockNotificationConst,
  screenLockSysFloatTipControl
} from '@ohos/screenlockcommon';
import { performanceMonitor } from '@kit.ArkUI';
import { liveCapsuleVm } from '../../../main/ets/vm/LiveViewVm';
import { LiveViewItemSwipeVm } from '../../../main/ets/vm/LiveViewItemSwipeVm';
import {
  DeleteNotificationErrorCode,
  DeleteNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/DeleteNotificationMaintenance';
import {
  ClickNotificationErrorCode,
  ClickNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/ClickNotificationMaintenance';
import { ClickRegion, DeleteNotificationType } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsConstants';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { SlMainStateType, SlStaticStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import {
  StartAbilityOverlayAnimate
} from '@ohos/systemuicommon/src/main/ets/liveview/common/StartAbilityOverlayAnimate';
import { SystemuiConstants } from '@ohos/systemuicommon/src/main/ets/constants/SystemuiConstants';
import { windowManager } from '@ohos/componentdrag';
import { ItemUtils } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { NtfListener } from '@ohos/notificationcomponent/src/main/ets/model/NotificationListener';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveListStateManager } from '../../../main/ets/common/LiveListStateManager';
export default function LiveListStateManagerTest() {
  describe('handleLiveViewRemove_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_log_error_when_data_is_invalid', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      liveliststatemanager.handleLiveViewRemove(null);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_log_error_when_delete_notification_fails', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_log_error_when_catch_exception', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_report_click_notification_when_data_is_valid', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let mockfunc2: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_report_click_notification_when_catch_exception_during_delete', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let mockfunc2: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_log_error_when_data_is_invalid', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      liveliststatemanager.handleLiveViewRemove(null);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_log_error_when_delete_notification_fails', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_log_error_when_catch_exception', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_report_click_notification_when_data_is_valid', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let mockfunc2: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_report_click_notification_when_catch_exception_during_delete', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let mockfunc2: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_log_error_when_data_is_invalid', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      liveliststatemanager.handleLiveViewRemove(null);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_log_error_when_delete_notification_fails', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_log_error_when_catch_exception', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_report_click_notification_when_data_is_valid', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let mockfunc2: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_report_click_notification_when_catch_exception_during_delete', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let mockfunc2: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_log_error_when_data_is_invalid', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      liveliststatemanager.handleLiveViewRemove(null);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_log_error_when_delete_notification_fails', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_log_error_when_catch_exception', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_report_click_notification_when_data_is_valid', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let mockfunc2: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_report_click_notification_when_catch_exception_during_delete', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let mockfunc2: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_log_error_when_data_is_invalid', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      liveliststatemanager.handleLiveViewRemove(null);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_log_error_when_delete_notification_fails', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_log_error_when_catch_exception', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_report_click_notification_when_data_is_valid', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let mockfunc2: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_report_click_notification_when_catch_exception_during_delete', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let mockfunc2: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_log_error_when_data_is_invalid', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      liveliststatemanager.handleLiveViewRemove(null);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_log_error_when_delete_notification_fails', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_log_error_when_catch_exception', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_report_click_notification_when_data_is_valid', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let mockfunc2: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_report_click_notification_when_catch_exception_during_delete', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let mockfunc2: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_log_error_when_data_is_invalid', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      liveliststatemanager.handleLiveViewRemove(null);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_log_error_when_delete_notification_fails', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_log_error_when_catch_exception', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_report_click_notification_when_data_is_valid', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let mockfunc2: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_report_click_notification_when_catch_exception_during_delete', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let mockfunc2: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_log_error_when_data_is_invalid', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      liveliststatemanager.handleLiveViewRemove(null);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_log_error_when_delete_notification_fails', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_log_error_when_catch_exception', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_report_click_notification_when_data_is_valid', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let mockfunc2: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
    it('should_report_click_notification_when_catch_exception_during_delete', 0, () => {
      let liveliststatemanager: LiveListStateManager = new LiveListStateManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let mockfunc2: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturn(undefined);
      let data: LiveViewData = new LiveViewData();
      liveliststatemanager.handleLiveViewRemove(data);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });
  });
}
