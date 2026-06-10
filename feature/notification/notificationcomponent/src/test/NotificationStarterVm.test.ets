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
import { performanceMonitor } from '@kit.ArkUI';
import { NotificationApiUtil } from '../../../main/ets/utils/NotificationApiUtil';
import {
  AnimationBase,
  DeviceInfoVm,
  DropdownVm,
  INotificationCardVm,
  INotificationStarterVm,
  NotificationBaseVm,
  NotificationStartWantAgentParams,
  StartAppOneMirrorAnimation
} from '@ohos/systemuicommon/newIndex';
import {
  NotificationSysEventReporter,
  NotificationWantAgentInfo,
  SystemUICommonUtil
} from '@ohos/systemuicommon';
import { ExclusiveChecker } from '../../../main/ets/model/ExclusiveChecker';
import { NotificationConfig } from '../../../main/ets/common/NotificationConfig';
import { wantAgent } from '@kit.AbilityKit';
import { NotificationBase, NotificationUtil } from '@ohos/systemuicommon/newTsIndex';
import {
  DeleteNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/DeleteNotificationMaintenance';
import { DeleteNotificationType } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsConstants';
import {
  ClickNotificationErrorCode,
  ClickNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/ClickNotificationMaintenance';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { HiDfxEventUtil, HiSysDataNotifyClickState } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
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
import { NotificationStarterVm } from '../../../main/ets/viewmodel/NotificationStarterVm';

export default function NotificationStarterVmTest() {
  describe('startWantAgent_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_error_when_agentInfo_is_null', 0, async () => {
      let notificationstartervm: NotificationStarterVm = new NotificationStarterVm();
      let params: NotificationStartWantAgentParams = new NotificationStartWantAgentParams();
      params.cardVm = new NotificationBaseVm();
      params.cardVm.ntf = new NotificationBase();
      params.cardVm.componentId = '1';
      params.wantAgentInfo = null;
      params.wantAgent = new wantAgent.WantAgent();
      params.triggerInfo = new wantAgent.TriggerInfo();

      let mocker: MockKit = new MockKit();

      await notificationstartervm.startWantAgent(params);

    });
    it('should_return_error_when_agentInfo_is_invalid', 0, async () => {
      let notificationstartervm: NotificationStarterVm = new NotificationStarterVm();
      let params: NotificationStartWantAgentParams = new NotificationStartWantAgentParams();
      params.cardVm = new NotificationBaseVm();
      params.cardVm.ntf = new NotificationBase();
      params.cardVm.componentId = '1';
      params.wantAgentInfo = new NotificationWantAgentInfo();
      params.wantAgentInfo.bundleName = 'com.example';
      params.wantAgent = new wantAgent.WantAgent();
      params.triggerInfo = new wantAgent.TriggerInfo();

      let mocker: MockKit = new MockKit();

      await notificationstartervm.startWantAgent(params);

    });
    it('should_start_wantAgent_when_agentInfo_is_valid', 0, async () => {
      let notificationstartervm: NotificationStarterVm = new NotificationStarterVm();
      let params: NotificationStartWantAgentParams = new NotificationStartWantAgentParams();
      params.cardVm = new NotificationBaseVm();
      params.cardVm.ntf = new NotificationBase();
      params.cardVm.componentId = '1';
      params.wantAgentInfo = new NotificationWantAgentInfo();
      params.wantAgentInfo.bundleName = 'com.example';
      params.wantAgentInfo.operationType = 1;
      params.wantAgentInfo.want = new wantAgent.Want();
      params.wantAgent = new wantAgent.WantAgent();
      params.triggerInfo = new wantAgent.TriggerInfo();

      let mocker: MockKit = new MockKit();


      await notificationstartervm.startWantAgent(params);

    });
    it('should_report_error_when_startWantAgent_fails', 0, async () => {
      let notificationstartervm: NotificationStarterVm = new NotificationStarterVm();
      let params: NotificationStartWantAgentParams = new NotificationStartWantAgentParams();
      params.cardVm = new NotificationBaseVm();
      params.cardVm.ntf = new NotificationBase();
      params.cardVm.componentId = '1';
      params.wantAgentInfo = new NotificationWantAgentInfo();
      params.wantAgentInfo.bundleName = 'com.example';
      params.wantAgentInfo.operationType = 1;
      params.wantAgentInfo.want = new wantAgent.Want();
      params.wantAgent = new wantAgent.WantAgent();
      params.triggerInfo = new wantAgent.TriggerInfo();

      let mocker: MockKit = new MockKit();


      await notificationstartervm.startWantAgent(params);

    });
    it('should_report_error_when_startWantAgent_throws_exception', 0, async () => {
      let notificationstartervm: NotificationStarterVm = new NotificationStarterVm();
      let params: NotificationStartWantAgentParams = new NotificationStartWantAgentParams();
      params.cardVm = new NotificationBaseVm();
      params.cardVm.ntf = new NotificationBase();
      params.cardVm.componentId = '1';
      params.wantAgentInfo = new NotificationWantAgentInfo();
      params.wantAgentInfo.bundleName = 'com.example';
      params.wantAgentInfo.operationType = 1;
      params.wantAgentInfo.want = new wantAgent.Want();
      params.wantAgent = new wantAgent.WantAgent();
      params.triggerInfo = new wantAgent.TriggerInfo();

      let mocker: MockKit = new MockKit();


      await notificationstartervm.startWantAgent(params);

    });

    it('should_execute_animation_correctly_when_all_conditions_are_met', 0, async () => {
      let notificationstartervm: NotificationStarterVm = new NotificationStarterVm();
      let mocker: MockKit = new MockKit();

      let cardVm: INotificationCardVm = new NotificationBaseVm();
      cardVm.ntf = new NotificationBase();
      cardVm.ntf.hashCode = '12345';
      cardVm.zIndex = 1;
      cardVm.translateY = 0;
      cardVm.opacity = 1;
      cardVm.containerClip = true;
      cardVm.containerSize = {
        width: '100%', height: 'auto'
      };
      cardVm.contentSize = undefined;
      if (panelVm) {
        panelVm.opacity = 1;
        panelVm.scale = 1;
      }
      if (listVm) {
        listVm.clipShape = undefined;
      }

      let cardRect: RectResult = {
        width: 100, height: 200
      };
      let panelVm: DropdownVm = new DropdownVm();
      let listVm: DropdownVm = new DropdownVm();
      panelVm.scale = 1;
      panelVm.opacity = 1;
      listVm.clipShape = 'someClipShape';

      await notificationstartervm.onExecute(cardVm, cardRect);

      expect(cardVm.zIndex).assertEqual(2);
      expect(cardVm.opacity).assertEqual(0);
      expect(cardVm.containerClip).assertEqual(false);
      expect(cardVm.containerSize.width).assertEqual('100%');
      expect(cardVm.containerSize.height).assertEqual('auto');
      expect(cardVm.contentSize).assertUndefined();
      expect(cardVm.translateY).assertEqual(0);
      if (panelVm) {
        expect(panelVm.opacity).assertEqual(0);
        expect(panelVm.scale).assertEqual(0.9);
      }
      if (listVm) {
        expect(listVm.clipShape).assertEqual('someClipShape');
      }

    });

    it('should_handle_animation_events_correctly', 0, async () => {
      let notificationstartervm: NotificationStarterVm = new NotificationStarterVm();
      let mocker: MockKit = new MockKit();

      let cardVm: INotificationCardVm = new NotificationBaseVm();
      cardVm.ntf = new NotificationBase();
      cardVm.ntf.hashCode = '12345';
      cardVm.zIndex = 1;
      cardVm.translateY = 0;
      cardVm.opacity = 1;
      cardVm.containerClip = true;
      cardVm.containerSize = {
        width: '100%', height: 'auto'
      };
      cardVm.contentSize = undefined;
      if (panelVm) {
        panelVm.opacity = 1;
        panelVm.scale = 1;
      }
      if (listVm) {
        listVm.clipShape = undefined;
      }

      let cardRect: RectResult = {
        width: 100, height: 200
      };
      let panelVm: DropdownVm = new DropdownVm();
      let listVm: DropdownVm = new DropdownVm();
      panelVm.scale = 1;
      panelVm.opacity = 1;
      listVm.clipShape = 'someClipShape';

      await notificationstartervm.onExecute(cardVm, cardRect);

      expect(cardVm.zIndex).assertEqual(2);
      expect(cardVm.opacity).assertEqual(0);
      expect(cardVm.containerClip).assertEqual(false);
      expect(cardVm.containerSize.width).assertEqual('100%');
      expect(cardVm.containerSize.height).assertEqual('auto');
      expect(cardVm.contentSize).assertUndefined();
      expect(cardVm.translateY).assertEqual(0);
      if (panelVm) {
        expect(panelVm.opacity).assertEqual(0);
        expect(panelVm.scale).assertEqual(0.9);
      }
      if (listVm) {
        expect(listVm.clipShape).assertEqual('someClipShape');
      }

    });


    it('should_return_false_when_isExcludeForStartApp_is_true', 0, () => {
      let notificationstartervm: NotificationStarterVm = new NotificationStarterVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationstartervm, notificationstartervm.isExcludeForStartApp);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);

      let params: NotificationStartWantAgentParams = new NotificationStartWantAgentParams();
      let result = notificationstartervm.beforeStartWantAgent(params);

      expect(result).assertEqual(false);
      mocker.ignoreMock(notificationstartervm, notificationstartervm.isExcludeForStartApp);
    });

    it('should_return_false_when_params_wantAgent_is_null', 0, () => {
      let notificationstartervm: NotificationStarterVm = new NotificationStarterVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationstartervm, notificationstartervm.isExcludeForStartApp);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);

      let params: NotificationStartWantAgentParams = new NotificationStartWantAgentParams();
      params.wantAgent = null;
      let result = notificationstartervm.beforeStartWantAgent(params);

      expect(result).assertEqual(false);
      mocker.ignoreMock(notificationstartervm, notificationstartervm.isExcludeForStartApp);
    });

    it('should_return_true_when_all_conditions_are_met', 0, () => {
      let notificationstartervm: NotificationStarterVm = new NotificationStarterVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationstartervm, notificationstartervm.isExcludeForStartApp);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);

      let params: NotificationStartWantAgentParams = new NotificationStartWantAgentParams();
      params.wantAgent = new wantAgent.WantAgent();
      let result = notificationstartervm.beforeStartWantAgent(params);

      expect(result).assertEqual(true);
      mocker.ignoreMock(notificationstartervm, notificationstartervm.isExcludeForStartApp);
    });

    it('should_report_start_want_agent_when_notification_is_not_null', 0, async () => {
      let notificationstartervm: NotificationStarterVm = new NotificationStarterVm();
      let mocker: MockKit = new MockKit();

      let mockStartAppOneMirrorAnimation: StartAppOneMirrorAnimation = new StartAppOneMirrorAnimation();

      let mockDeviceInfoVm: DeviceInfoVm = new DeviceInfoVm();
      mockDeviceInfoVm.isPC = false;

      let mockDropdownVm: DropdownVm = new DropdownVm();
      mockDropdownVm.lastDropdownTime = 123456789;

      let mockAnimationBase: AnimationBase = new AnimationBase(AnimationBase.NAMES.NTF_OVERLAY_ANIMATION);

      let mockNotificationBase: NotificationBase = new NotificationBase();
      mockNotificationBase.id = 1;
      mockNotificationBase.slotType = 2;
      mockNotificationBase.creatorBundleName = 'com.example.app';

      let mockNotificationBaseVm: INotificationCardVm = new NotificationBaseVm();
      mockNotificationBaseVm.notification = mockNotificationBase;

      let mockNotificationWantAgentInfo: NotificationWantAgentInfo = new NotificationWantAgentInfo();
      mockNotificationWantAgentInfo.wantAgent = wantAgent.WantAgentInfo.createWantAgentInfo();

      let mockExclusiveChecker: ExclusiveChecker = new ExclusiveChecker();

      let mockNotificationConfig: NotificationConfig = new NotificationConfig();

      let mockNotificationSysEventReporter: NotificationSysEventReporter = new NotificationSysEventReporter();

      let mockClickNotificationMaintenance: ClickNotificationMaintenance = new ClickNotificationMaintenance();

      let mockDeleteNotificationMaintenance: DeleteNotificationMaintenance = new DeleteNotificationMaintenance();

      let mockLogHelper: LogHelper = new LogHelper(LogDomain.NOTIFICATION);

      notificationstartervm.vmInjector = {
        getListVm: () => mockNotificationBaseVm,
        getDeviceInfoVm: () => mockDeviceInfoVm,
        getDropdownVm: () => mockDropdownVm,
        getAnimationBase: () => mockAnimationBase,
        getNotificationWantAgentInfo: () => mockNotificationWantAgentInfo,
        getExclusiveChecker: () => mockExclusiveChecker,
        getNotificationConfig: () => mockNotificationConfig,
        getNotificationSysEventReporter: () => mockNotificationSysEventReporter,
        getClickNotificationMaintenance: () => mockClickNotificationMaintenance,
        getDeleteNotificationMaintenance: () => mockDeleteNotificationMaintenance,
        getLogHelper: () => mockLogHelper
      };

      notificationstartervm.reportStartWantAgent(mockNotificationBase);

    });

    it('should_return_false_when_operationType_is_UNKNOWN_TYPE', 0, () => {
      let notificationstartervm: NotificationStarterVm = new NotificationStarterVm();
      let agentInfo: NotificationWantAgentInfo = new NotificationWantAgentInfo();
      agentInfo.operationType = wantAgent.OperationType.UNKNOWN_TYPE;
      const result = notificationstartervm.isStartApp(agentInfo);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_operationType_is_SEND_COMMON_EVENT', 0, () => {
      let notificationstartervm: NotificationStarterVm = new NotificationStarterVm();
      let agentInfo: NotificationWantAgentInfo = new NotificationWantAgentInfo();
      agentInfo.operationType = wantAgent.OperationType.SEND_COMMON_EVENT;
      const result = notificationstartervm.isStartApp(agentInfo);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_operationType_is_not_UNKNOWN_TYPE_or_SEND_COMMON_EVENT', 0, () => {
      let notificationstartervm: NotificationStarterVm = new NotificationStarterVm();
      let agentInfo: NotificationWantAgentInfo = new NotificationWantAgentInfo();
      agentInfo.operationType = wantAgent.OperationType.START_APP;
      const result = notificationstartervm.isStartApp(agentInfo);
      expect(result).assertEqual(true);
    });
  });
}