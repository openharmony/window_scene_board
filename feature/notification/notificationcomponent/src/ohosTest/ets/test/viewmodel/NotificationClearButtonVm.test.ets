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

import { NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import { DeviceInfoVm, DropdownVm, INotificationClearButtonVm,
  NotificationBaseVm } from '@ohos/systemuicommon/newIndex';
import { notificationManager } from '@kit.NotificationKit';
import { NotificationApiUtil } from '../../../main/ets/utils/NotificationApiUtil';
import { NotificationClearAllAnimation } from '../../../main/ets/animation/NotificationClearAllAnimation';
import { NotificationSysEventReporter } from '@ohos/systemuicommon';
import { DropDownPanelManager } from '@ohos/systemuicommon/Index';
import {
  DeleteNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/DeleteNotificationMaintenance';
import { DeleteNotificationType } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsConstants';
import { LengthMetrics } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationClearButtonVm } from '../../../main/ets/viewmodel/NotificationClearButtonVm';
export default function NotificationClearButtonVmTest() {
  describe('getClearNtfList_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_empty_list_when_all_notifications_are_normal_groups', 0, () => {
      let notificationclearbuttonvm: NotificationClearButtonVm = new NotificationClearButtonVm();
      let ntfList: NotificationBase[] = [
        new NotificationBase(),
        new NotificationBase()
      ];
      let result = notificationclearbuttonvm.getClearNtfList(ntfList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_list_with_all_clearable_notifications_when_ntf_list_contains_clearable_notifications', 0, () => {
      let notificationclearbuttonvm: NotificationClearButtonVm = new NotificationClearButtonVm();
      let ntfList: NotificationBase[] = [
        new NotificationBase(),
        new NotificationBase()
      ];
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ntfList[0], ntfList[0].isNormalGroup);
      when(mockfunc)().afterReturn(false);
      let result = notificationclearbuttonvm.getClearNtfList(ntfList);
      expect(result.length).assertEqual(2);
      mocker.ignoreMock(ntfList[0], ntfList[0].isNormalGroup);
    });

    it('should_return_list_with_all_clearable_children_when_ntf_list_contains_normal_groups_with_clearable_children', 0, () => {
      let notificationclearbuttonvm: NotificationClearButtonVm = new NotificationClearButtonVm();
      let ntfList: NotificationBase[] = [
        new NotificationBase(),
        new NotificationBase()
      ];
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ntfList[0], ntfList[0].isNormalGroup);
      when(mockfunc)().afterReturn(true);
      let childList: NotificationBase[] = [
        new NotificationBase(),
        new NotificationBase()
      ];
      let mockfunc2: Function = mocker.mockFunc(ntfList[0], ntfList[0].children);
      when(mockfunc2)().afterReturn(childList);
      let result = notificationclearbuttonvm.getClearNtfList(ntfList);
      expect(result.length).assertEqual(2);
      mocker.ignoreMock(ntfList[0], ntfList[0].isNormalGroup);
      mocker.ignoreMock(ntfList[0], ntfList[0].children);
    });

    it('should_return_list_with_all_clearable_notifications_when_ntf_list_contains_normal_groups_with_clearable_notifications', 0, () => {
      let notificationclearbuttonvm: NotificationClearButtonVm = new NotificationClearButtonVm();
      let ntfList: NotificationBase[] = [
        new NotificationBase(),
        new NotificationBase()
      ];
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ntfList[0], ntfList[0].isNormalGroup);
      when(mockfunc)().afterReturn(true);
      let childList: NotificationBase[] = [
        new NotificationBase(),
        new NotificationBase()
      ];
      let mockfunc2: Function = mocker.mockFunc(ntfList[0], ntfList[0].children);
      when(mockfunc2)().afterReturn(childList);
      let mockfunc3: Function = mocker.mockFunc(childList[0], childList[0].isNormalGroup);
      when(mockfunc3)().afterReturn(false);
      let result = notificationclearbuttonvm.getClearNtfList(ntfList);
      expect(result.length).assertEqual(3);
      mocker.ignoreMock(ntfList[0], ntfList[0].isNormalGroup);
      mocker.ignoreMock(ntfList[0], ntfList[0].children);
      mocker.ignoreMock(childList[0], childList[0].isNormalGroup);
    });

    it('should_return_empty_list_when_all_notifications_are_normal_groups', 0, () => {
      let notificationclearbuttonvm: NotificationClearButtonVm = new NotificationClearButtonVm();
      let ntfList: NotificationBase[] = [
        new NotificationBase(),
        new NotificationBase()
      ];
      let result = notificationclearbuttonvm.getClearNtfList(ntfList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_list_with_all_clearable_notifications_when_ntf_list_contains_clearable_notifications', 0, () => {
      let notificationclearbuttonvm: NotificationClearButtonVm = new NotificationClearButtonVm();
      let ntfList: NotificationBase[] = [
        new NotificationBase(),
        new NotificationBase()
      ];
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ntfList[0], ntfList[0].isNormalGroup);
      when(mockfunc)().afterReturn(false);
      let result = notificationclearbuttonvm.getClearNtfList(ntfList);
      expect(result.length).assertEqual(2);
      mocker.ignoreMock(ntfList[0], ntfList[0].isNormalGroup);
    });

    it('should_return_list_with_all_clearable_children_when_ntf_list_contains_normal_groups_with_clearable_children', 0, () => {
      let notificationclearbuttonvm: NotificationClearButtonVm = new NotificationClearButtonVm();
      let ntfList: NotificationBase[] = [
        new NotificationBase(),
        new NotificationBase()
      ];
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ntfList[0], ntfList[0].isNormalGroup);
      when(mockfunc)().afterReturn(true);
      let childList: NotificationBase[] = [
        new NotificationBase(),
        new NotificationBase()
      ];
      let mockfunc2: Function = mocker.mockFunc(ntfList[0], ntfList[0].children);
      when(mockfunc2)().afterReturn(childList);
      let result = notificationclearbuttonvm.getClearNtfList(ntfList);
      expect(result.length).assertEqual(2);
      mocker.ignoreMock(ntfList[0], ntfList[0].isNormalGroup);
      mocker.ignoreMock(ntfList[0], ntfList[0].children);
    });

    it('should_return_list_with_all_clearable_notifications_when_ntf_list_contains_normal_groups_with_clearable_notifications', 0, () => {
      let notificationclearbuttonvm: NotificationClearButtonVm = new NotificationClearButtonVm();
      let ntfList: NotificationBase[] = [
        new NotificationBase(),
        new NotificationBase()
      ];
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ntfList[0], ntfList[0].isNormalGroup);
      when(mockfunc)().afterReturn(true);
      let childList: NotificationBase[] = [
        new NotificationBase(),
        new NotificationBase()
      ];
      let mockfunc2: Function = mocker.mockFunc(ntfList[0], ntfList[0].children);
      when(mockfunc2)().afterReturn(childList);
      let mockfunc3: Function = mocker.mockFunc(childList[0], childList[0].isNormalGroup);
      when(mockfunc3)().afterReturn(false);
      let result = notificationclearbuttonvm.getClearNtfList(ntfList);
      expect(result.length).assertEqual(3);
      mocker.ignoreMock(ntfList[0], ntfList[0].isNormalGroup);
      mocker.ignoreMock(ntfList[0], ntfList[0].children);
      mocker.ignoreMock(childList[0], childList[0].isNormalGroup);
    });

    it('should_return_empty_list_when_all_notifications_are_normal_groups', 0, () => {
      let notificationclearbuttonvm: NotificationClearButtonVm = new NotificationClearButtonVm();
      let ntfList: NotificationBase[] = [
        new NotificationBase(),
        new NotificationBase()
      ];
      let result = notificationclearbuttonvm.getClearNtfList(ntfList);
      expect(result.length).assertEqual(0);
    });

    it('should_return_list_with_all_clearable_notifications_when_ntf_list_contains_clearable_notifications', 0, () => {
      let notificationclearbuttonvm: NotificationClearButtonVm = new NotificationClearButtonVm();
      let ntfList: NotificationBase[] = [
        new NotificationBase(),
        new NotificationBase()
      ];
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ntfList[0], ntfList[0].isNormalGroup);
      when(mockfunc)().afterReturn(false);
      let result = notificationclearbuttonvm.getClearNtfList(ntfList);
      expect(result.length).assertEqual(2);
      mocker.ignoreMock(ntfList[0], ntfList[0].isNormalGroup);
    });

    it('should_return_list_with_all_clearable_children_when_ntf_list_contains_normal_groups_with_clearable_children', 0, () => {
      let notificationclearbuttonvm: NotificationClearButtonVm = new NotificationClearButtonVm();
      let ntfList: NotificationBase[] = [
        new NotificationBase(),
        new NotificationBase()
      ];
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ntfList[0], ntfList[0].isNormalGroup);
      when(mockfunc)().afterReturn(true);
      let childList: NotificationBase[] = [
        new NotificationBase(),
        new NotificationBase()
      ];
      let mockfunc2: Function = mocker.mockFunc(ntfList[0], ntfList[0].children);
      when(mockfunc2)().afterReturn(childList);
      let result = notificationclearbuttonvm.getClearNtfList(ntfList);
      expect(result.length).assertEqual(2);
      mocker.ignoreMock(ntfList[0], ntfList[0].isNormalGroup);
      mocker.ignoreMock(ntfList[0], ntfList[0].children);
    });

    it('should_return_list_with_all_clearable_notifications_when_ntf_list_contains_normal_groups_with_clearable_notifications', 0, () => {
      let notificationclearbuttonvm: NotificationClearButtonVm = new NotificationClearButtonVm();
      let ntfList: NotificationBase[] = [
        new NotificationBase(),
        new NotificationBase()
      ];
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ntfList[0], ntfList[0].isNormalGroup);
      when(mockfunc)().afterReturn(true);
      let childList: NotificationBase[] = [
        new NotificationBase(),
        new NotificationBase()
      ];
      let mockfunc2: Function = mocker.mockFunc(ntfList[0], ntfList[0].children);
      when(mockfunc2)().afterReturn(childList);
      let mockfunc3: Function = mocker.mockFunc(childList[0], childList[0].isNormalGroup);
      when(mockfunc3)().afterReturn(false);
      let result = notificationclearbuttonvm.getClearNtfList(ntfList);
      expect(result.length).assertEqual(3);
      mocker.ignoreMock(ntfList[0], ntfList[0].isNormalGroup);
      mocker.ignoreMock(ntfList[0], ntfList[0].children);
      mocker.ignoreMock(childList[0], childList[0].isNormalGroup);
    });

    it('should_return_when_listVm_is_null', 0, () => {
      let notificationclearbuttonvm: NotificationClearButtonVm = new NotificationClearButtonVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getListVm);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearbuttonvm.clear();
      mocker.ignoreMock(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getListVm);
    });

    it('should_execute_clear_process_when_listVm_is_not_null', 0, async () => {
      let notificationclearbuttonvm: NotificationClearButtonVm = new NotificationClearButtonVm();
      let mocker: MockKit = new MockKit();
      let listVm: NotificationBaseVm = new NotificationBaseVm();
      let mockfuncListVm: Function = mocker.mockFunc(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getListVm);
      when(mockfuncListVm)(ArgumentMatchers.any).afterReturn(listVm);

      let dropdownVm: DropdownVm = new DropdownVm();
      let mockfuncDropdownVm: Function = mocker.mockFunc(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getCardVm);
      when(mockfuncDropdownVm)(ArgumentMatchers.any).afterReturn(dropdownVm);

      let deviceInfoVm: DeviceInfoVm = new DeviceInfoVm();
      let mockfuncDeviceInfoVm: Function = mocker.mockFunc(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getDeviceInfoVm);
      when(mockfuncDeviceInfoVm)(ArgumentMatchers.any).afterReturn(deviceInfoVm);

      let mockStartAnimation: Function = mocker.mockFunc(notificationclearbuttonvm.animation, notificationclearbuttonvm.animation.startAnimation);
      when(mockStartAnimation)(ArgumentMatchers.anyString, ArgumentMatchers.anyNumber).afterReturn(Promise.resolve());

      let mockAddListItemAnimation: Function = mocker.mockFunc(notificationclearbuttonvm.animation, notificationclearbuttonvm.animation.addListItemAnimation);
      when(mockAddListItemAnimation)(ArgumentMatchers.any).afterReturnNothing();

      let mockAddClearButtonAnimation: Function = mocker.mockFunc(notificationclearbuttonvm.animation, notificationclearbuttonvm.animation.addClearButtonAnimation);
      when(mockAddClearButtonAnimation)(ArgumentMatchers.any).afterReturnNothing();

      notificationclearbuttonvm.isClearingAll = true;
      notificationclearbuttonvm.marginBottom = LengthMetrics.resource($r('app.float.ntf_clear_btn_padding'));
      notificationclearbuttonvm.width = '100%';
      notificationclearbuttonvm.position = { left: 0, bottom: 0 };

      let scrollerVm: any = { startIndex: 0, endIndex: 0 };
      let mockfuncScrollerVm: Function = mocker.mockFunc(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getListScrollerVm);
      when(mockfuncScrollerVm)(ArgumentMatchers.any).afterReturn(scrollerVm);

      let ntf: NotificationBase = new NotificationBase();
      ntf.isClearAllowed = true;
      listVm.notifications = [ntf];

      notificationclearbuttonvm.clear();

      expect(notificationclearbuttonvm.isClearingAll).assertEqual(false);

      mocker.ignoreMock(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getListVm);
      mocker.ignoreMock(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getCardVm);
      mocker.ignoreMock(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getDeviceInfoVm);
      mocker.ignoreMock(notificationclearbuttonvm.animation, notificationclearbuttonvm.animation.startAnimation);
      mocker.ignoreMock(notificationclearbuttonvm.animation, notificationclearbuttonvm.animation.addListItemAnimation);
      mocker.ignoreMock(notificationclearbuttonvm.animation, notificationclearbuttonvm.animation.addClearButtonAnimation);
    });

    it('should_return_when_listVm_is_null', 0, () => {
      let notificationclearbuttonvm: NotificationClearButtonVm = new NotificationClearButtonVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getListVm);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearbuttonvm.clear();
      mocker.ignoreMock(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getListVm);
    });

    it('should_execute_clear_process_when_listVm_is_not_null', 0, async () => {
      let notificationclearbuttonvm: NotificationClearButtonVm = new NotificationClearButtonVm();
      let mocker: MockKit = new MockKit();
      let listVm: NotificationBaseVm = new NotificationBaseVm();
      let mockfuncListVm: Function = mocker.mockFunc(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getListVm);
      when(mockfuncListVm)(ArgumentMatchers.any).afterReturn(listVm);

      let dropdownVm: DropdownVm = new DropdownVm();
      let mockfuncDropdownVm: Function = mocker.mockFunc(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getCardVm);
      when(mockfuncDropdownVm)(ArgumentMatchers.any).afterReturn(dropdownVm);

      let deviceInfoVm: DeviceInfoVm = new DeviceInfoVm();
      let mockfuncDeviceInfoVm: Function = mocker.mockFunc(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getDeviceInfoVm);
      when(mockfuncDeviceInfoVm)(ArgumentMatchers.any).afterReturn(deviceInfoVm);

      let mockStartAnimation: Function = mocker.mockFunc(notificationclearbuttonvm.animation, notificationclearbuttonvm.animation.startAnimation);
      when(mockStartAnimation)(ArgumentMatchers.anyString, ArgumentMatchers.anyNumber).afterReturn(Promise.resolve());

      let mockAddListItemAnimation: Function = mocker.mockFunc(notificationclearbuttonvm.animation, notificationclearbuttonvm.animation.addListItemAnimation);
      when(mockAddListItemAnimation)(ArgumentMatchers.any).afterReturnNothing();

      let mockAddClearButtonAnimation: Function = mocker.mockFunc(notificationclearbuttonvm.animation, notificationclearbuttonvm.animation.addClearButtonAnimation);
      when(mockAddClearButtonAnimation)(ArgumentMatchers.any).afterReturnNothing();

      notificationclearbuttonvm.isClearingAll = true;
      notificationclearbuttonvm.marginBottom = LengthMetrics.resource($r('app.float.ntf_clear_btn_padding'));
      notificationclearbuttonvm.width = '100%';
      notificationclearbuttonvm.position = { left: 0, bottom: 0 };

      let scrollerVm: any = { startIndex: 0, endIndex: 0 };
      let mockfuncScrollerVm: Function = mocker.mockFunc(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getListScrollerVm);
      when(mockfuncScrollerVm)(ArgumentMatchers.any).afterReturn(scrollerVm);

      let ntf: NotificationBase = new NotificationBase();
      ntf.isClearAllowed = true;
      listVm.notifications = [ntf];

      notificationclearbuttonvm.clear();

      expect(notificationclearbuttonvm.isClearingAll).assertEqual(false);

      mocker.ignoreMock(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getListVm);
      mocker.ignoreMock(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getCardVm);
      mocker.ignoreMock(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getDeviceInfoVm);
      mocker.ignoreMock(notificationclearbuttonvm.animation, notificationclearbuttonvm.animation.startAnimation);
      mocker.ignoreMock(notificationclearbuttonvm.animation, notificationclearbuttonvm.animation.addListItemAnimation);
      mocker.ignoreMock(notificationclearbuttonvm.animation, notificationclearbuttonvm.animation.addClearButtonAnimation);
    });

    it('should_return_when_listVm_is_null', 0, () => {
      let notificationclearbuttonvm: NotificationClearButtonVm = new NotificationClearButtonVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getListVm);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationclearbuttonvm.clear();
      mocker.ignoreMock(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getListVm);
    });

    it('should_execute_clear_process_when_listVm_is_not_null', 0, async () => {
      let notificationclearbuttonvm: NotificationClearButtonVm = new NotificationClearButtonVm();
      let mocker: MockKit = new MockKit();
      let listVm: NotificationBaseVm = new NotificationBaseVm();
      let mockfuncListVm: Function = mocker.mockFunc(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getListVm);
      when(mockfuncListVm)(ArgumentMatchers.any).afterReturn(listVm);

      let dropdownVm: DropdownVm = new DropdownVm();
      let mockfuncDropdownVm: Function = mocker.mockFunc(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getCardVm);
      when(mockfuncDropdownVm)(ArgumentMatchers.any).afterReturn(dropdownVm);

      let deviceInfoVm: DeviceInfoVm = new DeviceInfoVm();
      let mockfuncDeviceInfoVm: Function = mocker.mockFunc(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getDeviceInfoVm);
      when(mockfuncDeviceInfoVm)(ArgumentMatchers.any).afterReturn(deviceInfoVm);

      let mockStartAnimation: Function = mocker.mockFunc(notificationclearbuttonvm.animation, notificationclearbuttonvm.animation.startAnimation);
      when(mockStartAnimation)(ArgumentMatchers.anyString, ArgumentMatchers.anyNumber).afterReturn(Promise.resolve());

      let mockAddListItemAnimation: Function = mocker.mockFunc(notificationclearbuttonvm.animation, notificationclearbuttonvm.animation.addListItemAnimation);
      when(mockAddListItemAnimation)(ArgumentMatchers.any).afterReturnNothing();

      let mockAddClearButtonAnimation: Function = mocker.mockFunc(notificationclearbuttonvm.animation, notificationclearbuttonvm.animation.addClearButtonAnimation);
      when(mockAddClearButtonAnimation)(ArgumentMatchers.any).afterReturnNothing();

      notificationclearbuttonvm.isClearingAll = true;
      notificationclearbuttonvm.marginBottom = LengthMetrics.resource($r('app.float.ntf_clear_btn_padding'));
      notificationclearbuttonvm.width = '100%';
      notificationclearbuttonvm.position = { left: 0, bottom: 0 };

      let scrollerVm: any = { startIndex: 0, endIndex: 0 };
      let mockfuncScrollerVm: Function = mocker.mockFunc(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getListScrollerVm);
      when(mockfuncScrollerVm)(ArgumentMatchers.any).afterReturn(scrollerVm);

      let ntf: NotificationBase = new NotificationBase();
      ntf.isClearAllowed = true;
      listVm.notifications = [ntf];

      notificationclearbuttonvm.clear();

      expect(notificationclearbuttonvm.isClearingAll).assertEqual(false);

      mocker.ignoreMock(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getListVm);
      mocker.ignoreMock(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getCardVm);
      mocker.ignoreMock(notificationclearbuttonvm, notificationclearbuttonvm.vmInjector.getDeviceInfoVm);
      mocker.ignoreMock(notificationclearbuttonvm.animation, notificationclearbuttonvm.animation.startAnimation);
      mocker.ignoreMock(notificationclearbuttonvm.animation, notificationclearbuttonvm.animation.addListItemAnimation);
      mocker.ignoreMock(notificationclearbuttonvm.animation, notificationclearbuttonvm.animation.addClearButtonAnimation);
    });

    it('should_report_clear_all_data_correctly', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.getLastDropdownTime);
      when(mockfunc)([]).afterReturn(123456789);

      let notificationclearbuttonvm: NotificationClearButtonVm = new NotificationClearButtonVm();
      notificationclearbuttonvm.pendingClearNtfList = [
        new NotificationBase(),
        new NotificationBase(),
        new NotificationBase()
      ];
      notificationclearbuttonvm.pendingClearNtfList[0].slotType = notificationManager.SlotType.UNKNOWN_TYPE;
      notificationclearbuttonvm.pendingClearNtfList[1].slotType = notificationManager.SlotType.SOCIAL_COMMUNICATION;
      notificationclearbuttonvm.pendingClearNtfList[2].slotType = notificationManager.SlotType.SERVICE_INFORMATION;

      notificationclearbuttonvm.reportClearAllData();

      expect(NotificationSysEventReporter.notificationPanelClear).assertCalledWith({
        TIME_STAMP: '123456789',
        UNKNOWN_DELETED_NUMBER: 1,
        SOCIAL_DELETED_NUMBER: 1,
        SERVICE_DELETED_NUMBER: 1,
        CONTENT_DELETED_NUMBER: 0,
        DELETED_NUMBER: 3
      });

      mocker.ignoreMock(DropDownPanelManager, DropDownPanelManager.getLastDropdownTime);
    });

    it('should_report_clear_all_data_correctly', 0, async () => {
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.getLastDropdownTime);
      when(mockfunc)([]).afterReturn(123456789);

      let notificationclearbuttonvm: NotificationClearButtonVm = new NotificationClearButtonVm();
      notificationclearbuttonvm.pendingClearNtfList = [
        new NotificationBase(),
        new NotificationBase(),
        new NotificationBase()
      ];
      notificationclearbuttonvm.pendingClearNtfList[0].slotType = notificationManager.SlotType.UNKNOWN_TYPE;
      notificationclearbuttonvm.pendingClearNtfList[1].slotType = notificationManager.SlotType.SOCIAL_COMMUNICATION;
      notificationclearbuttonvm.pendingClearNtfList[2].slotType = notificationManager.SlotType.SERVICE_INFORMATION;

      notificationclearbuttonvm.reportClearAllData();

      expect(NotificationSysEventReporter.notificationPanelClear).assertCalledWith({
        TIME_STAMP: '123456789',
        UNKNOWN_DELETED_NUMBER: 1,
        SOCIAL_DELETED_NUMBER: 1,
        SERVICE_DELETED_NUMBER: 1,
        CONTENT_DELETED_NUMBER: 0,
        DELETED_NUMBER: 3
      });

      mocker.ignoreMock(DropDownPanelManager, DropDownPanelManager.getLastDropdownTime);
    });

    it('should_report_clear_all_data_correctly', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DropDownPanelManager, DropDownPanelManager.getLastDropdownTime);
      when(mockfunc)([]).afterReturn(123456789);
      let notificationclearbuttonvm: NotificationClearButtonVm = new NotificationClearButtonVm();
      notificationclearbuttonvm.pendingClearNtfList = [
        new NotificationBase(),
        new NotificationBase(),
        new NotificationBase()
      ];
      notificationclearbuttonvm.pendingClearNtfList[0].slotType = notificationManager.SlotType.UNKNOWN_TYPE;
      notificationclearbuttonvm.pendingClearNtfList[1].slotType = notificationManager.SlotType.SOCIAL_COMMUNICATION;
      notificationclearbuttonvm.pendingClearNtfList[2].slotType = notificationManager.SlotType.SERVICE_INFORMATION;

      notificationclearbuttonvm.reportClearAllData();

      expect(NotificationSysEventReporter.notificationPanelClear).assertCalledWith({
        TIME_STAMP: '123456789',
        UNKNOWN_DELETED_NUMBER: 1,
        SOCIAL_DELETED_NUMBER: 1,
        SERVICE_DELETED_NUMBER: 1,
        CONTENT_DELETED_NUMBER: 0,
        DELETED_NUMBER: 3
      });
    });
  });
}