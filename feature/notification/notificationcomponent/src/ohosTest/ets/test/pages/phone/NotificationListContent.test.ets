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
  LiveUseScene, fontScaleManager, FontScaleState, FrameCount } from '@ohos/systemuicommon/src/main/ets/TsIndex';
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
import { LiveNotification, NotificationDataManager } from '@ohos/systemuicommon/newTsIndex';
import { OuterHomeNtfBridgeManager } from '../../../../main/ets/manager/OuterHomeNtfBridgeManager';
import { EmergencyThermalSafeManager } from '../../../../main/ets/manager/EmergencyThermalSafeManager';
import { AnimateParams } from '@ohos/systemuicommon/src/main/ets/animation/AnimationBase';
import { NtfListener } from '../../../../main/ets/model/NotificationListener';
import { AppProtectedVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedVm';
import { NotificationType } from '../../../../main/ets/common/NotificationType';
import { AccessibilityUtil } from '@ohos/systemuicommon';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {  } from '../../../../main/ets/pages/phone/NotificationListContent';
export default function Test() {
  describe('onChangeDataEmitter_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_setDeviceModeState_with_correct_param', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(EmergencyThermalSafeManager.instance, EmergencyThermalSafeManager.instance.setDeviceModeState);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.NORMAL_MODE;
      testClass.emergencyInfoList = [new NotificationEntry()];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(EmergencyThermalSafeManager.instance, EmergencyThermalSafeManager.instance.setDeviceModeState);
    });

    it('should_call_onNtfListDataChange_when_emergency_mode_is_on_and_has_ntf_list', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.onNtfListDataChange);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.EMERGENCY_MODE;
      testClass.emergencyInfoList = [new NotificationEntry()];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.onNtfListDataChange);
    });

    it('should_not_call_onNtfListDataChange_when_emergency_mode_is_off_and_has_no_ntf_list', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.onNtfListDataChange);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.NORMAL_MODE;
      testClass.emergencyInfoList = [];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.onNtfListDataChange);
    });

    it('should_call_setEmergencyWhiteList_when_device_mode_is_thermal_safe_mode', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(EmergencyThermalSafeManager.instance, EmergencyThermalSafeManager.instance.setEmergencyWhiteList);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.THERMAL_SAFE_MODE;
      testClass.emergencyInfoList = [new NotificationEntry()];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(EmergencyThermalSafeManager.instance, EmergencyThermalSafeManager.instance.setEmergencyWhiteList);
    });

    it('should_call_exitEmergencyMode_when_device_mode_is_not_thermal_safe_mode', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.exitEmergencyMode);
      when(mockfunc)().afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.NORMAL_MODE;
      testClass.emergencyInfoList = [new NotificationEntry()];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.exitEmergencyMode);
    });


    it('should_call_setDeviceModeState_with_correct_param', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(EmergencyThermalSafeManager.instance, EmergencyThermalSafeManager.instance.setDeviceModeState);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.NORMAL_MODE;
      testClass.emergencyInfoList = [new NotificationEntry()];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(EmergencyThermalSafeManager.instance, EmergencyThermalSafeManager.instance.setDeviceModeState);
    });

    it('should_call_onNtfListDataChange_when_emergency_mode_is_on_and_has_ntf_list', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.onNtfListDataChange);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.EMERGENCY_MODE;
      testClass.emergencyInfoList = [new NotificationEntry()];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.onNtfListDataChange);
    });

    it('should_not_call_onNtfListDataChange_when_emergency_mode_is_off_and_has_no_ntf_list', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.onNtfListDataChange);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.NORMAL_MODE;
      testClass.emergencyInfoList = [];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.onNtfListDataChange);
    });

    it('should_call_setEmergencyWhiteList_when_device_mode_is_thermal_safe_mode', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(EmergencyThermalSafeManager.instance, EmergencyThermalSafeManager.instance.setEmergencyWhiteList);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.THERMAL_SAFE_MODE;
      testClass.emergencyInfoList = [new NotificationEntry()];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(EmergencyThermalSafeManager.instance, EmergencyThermalSafeManager.instance.setEmergencyWhiteList);
    });

    it('should_call_exitEmergencyMode_when_device_mode_is_not_thermal_safe_mode', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.exitEmergencyMode);
      when(mockfunc)().afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.NORMAL_MODE;
      testClass.emergencyInfoList = [new NotificationEntry()];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.exitEmergencyMode);
    });

    it('should_call_setDeviceModeState_with_correct_param', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(EmergencyThermalSafeManager.instance, EmergencyThermalSafeManager.instance.setDeviceModeState);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.NORMAL_MODE;
      testClass.emergencyInfoList = [new NotificationEntry()];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(EmergencyThermalSafeManager.instance, EmergencyThermalSafeManager.instance.setDeviceModeState);
    });

    it('should_call_onNtfListDataChange_when_emergency_mode_is_on_and_has_ntf_list', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.onNtfListDataChange);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.EMERGENCY_MODE;
      testClass.emergencyInfoList = [new NotificationEntry()];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.onNtfListDataChange);
    });

    it('should_not_call_onNtfListDataChange_when_emergency_mode_is_off_and_has_no_ntf_list', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.onNtfListDataChange);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.NORMAL_MODE;
      testClass.emergencyInfoList = [];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.onNtfListDataChange);
    });

    it('should_call_setEmergencyWhiteList_when_device_mode_is_thermal_safe_mode', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(EmergencyThermalSafeManager.instance, EmergencyThermalSafeManager.instance.setEmergencyWhiteList);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.THERMAL_SAFE_MODE;
      testClass.emergencyInfoList = [new NotificationEntry()];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(EmergencyThermalSafeManager.instance, EmergencyThermalSafeManager.instance.setEmergencyWhiteList);
    });

    it('should_call_exitEmergencyMode_when_device_mode_is_not_thermal_safe_mode', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.exitEmergencyMode);
      when(mockfunc)().afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.NORMAL_MODE;
      testClass.emergencyInfoList = [new NotificationEntry()];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.exitEmergencyMode);
    });

    it('should_call_setDeviceModeState_with_correct_param', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(EmergencyThermalSafeManager.instance, EmergencyThermalSafeManager.instance.setDeviceModeState);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.NORMAL_MODE;
      testClass.emergencyInfoList = [new NotificationEntry()];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(EmergencyThermalSafeManager.instance, EmergencyThermalSafeManager.instance.setDeviceModeState);
    });

    it('should_call_onNtfListDataChange_when_emergency_mode_is_on_and_has_ntf_list', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.onNtfListDataChange);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.EMERGENCY_MODE;
      testClass.emergencyInfoList = [new NotificationEntry()];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.onNtfListDataChange);
    });

    it('should_not_call_onNtfListDataChange_when_emergency_mode_is_off_and_has_no_ntf_list', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.onNtfListDataChange);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.NORMAL_MODE;
      testClass.emergencyInfoList = [];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.onNtfListDataChange);
    });

    it('should_call_setEmergencyWhiteList_when_device_mode_is_thermal_safe_mode', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(EmergencyThermalSafeManager.instance, EmergencyThermalSafeManager.instance.setEmergencyWhiteList);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.THERMAL_SAFE_MODE;
      testClass.emergencyInfoList = [new NotificationEntry()];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(EmergencyThermalSafeManager.instance, EmergencyThermalSafeManager.instance.setEmergencyWhiteList);
    });

    it('should_call_exitEmergencyMode_when_device_mode_is_not_thermal_safe_mode', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.exitEmergencyMode);
      when(mockfunc)().afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.NORMAL_MODE;
      testClass.emergencyInfoList = [new NotificationEntry()];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.exitEmergencyMode);
    });

    it('should_call_setDeviceModeState_with_correct_param', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(EmergencyThermalSafeManager.instance, EmergencyThermalSafeManager.instance.setDeviceModeState);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.NORMAL_MODE;
      testClass.emergencyInfoList = [new NotificationEntry()];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(EmergencyThermalSafeManager.instance, EmergencyThermalSafeManager.instance.setDeviceModeState);
    });

    it('should_call_onNtfListDataChange_when_emergency_mode_is_on_and_has_ntf_list', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.onNtfListDataChange);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.EMERGENCY_MODE;
      testClass.emergencyInfoList = [new NotificationEntry()];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.onNtfListDataChange);
    });

    it('should_not_call_onNtfListDataChange_when_emergency_mode_is_off_and_has_no_ntf_list', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.onNtfListDataChange);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.NORMAL_MODE;
      testClass.emergencyInfoList = [];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.onNtfListDataChange);
    });

    it('should_call_setEmergencyWhiteList_when_device_mode_is_thermal_safe_mode', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(EmergencyThermalSafeManager.instance, EmergencyThermalSafeManager.instance.setEmergencyWhiteList);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.THERMAL_SAFE_MODE;
      testClass.emergencyInfoList = [new NotificationEntry()];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(EmergencyThermalSafeManager.instance, EmergencyThermalSafeManager.instance.setEmergencyWhiteList);
    });

    it('should_call_setDeviceModeState_with_correct_param', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(EmergencyThermalSafeManager.instance, EmergencyThermalSafeManager.instance.setDeviceModeState);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.NORMAL_MODE;
      testClass.emergencyInfoList = [new NotificationEntry()];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(EmergencyThermalSafeManager.instance, EmergencyThermalSafeManager.instance.setDeviceModeState);
    });

    it('should_call_onNtfListDataChange_when_emergency_mode_is_on_and_has_ntf_list', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.onNtfListDataChange);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.EMERGENCY_MODE;
      testClass.emergencyInfoList = [new NotificationEntry()];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.onNtfListDataChange);

    });

    it('should_not_call_onNtfListDataChange_when_emergency_mode_is_off_and_has_no_ntf_list', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfListVm.prototype, NtfListVm.prototype.onNtfListDataChange);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.NORMAL_MODE;
      testClass.emergencyInfoList = [];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(NtfListVm.prototype, NtfListVm.prototype.onNtfListDataChange);
    });

    it('should_call_setEmergencyWhiteList_when_device_mode_is_thermal_safe_mode', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(EmergencyThermalSafeManager.instance, EmergencyThermalSafeManager.instance.setEmergencyWhiteList);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let testClass: any = new TestClass();
      testClass.deviceModeState = DeviceModeEnum.THERMAL_SAFE_MODE;
      testClass.emergencyInfoList = [new NotificationEntry()];
      testClass.ntfListVM = new NtfListVm();
      testClass.onChangeDataEmitter();

      mocker.ignoreMock(EmergencyThermalSafeManager.instance, EmergencyThermalSafeManager.instance.setEmergencyWhiteList);
    });

  });
}
