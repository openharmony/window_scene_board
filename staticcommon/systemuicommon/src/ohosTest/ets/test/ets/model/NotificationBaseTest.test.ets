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
import notificationManager from '@ohos.notificationManager';
import image from '@ohos.multimedia.image';
import { wantAgent, WantAgent } from '@kit.AbilityKit';
import bundleManager from '@ohos.bundle.bundleManager';
import {
  NotificationAction,
  NotificationCategory,
  NotificationCreatorType,
  NotificationRole,
  OverlayIconStyle
} from '../../../main/ets/model/NotificationContent';
import systemSoundManager from '@ohos.multimedia.systemSoundManager';
import resourceManager from '@ohos.resourceManager';
import { NotificationWantAgentInfo } from '../../../main/ets/model/NotificationAppInfo';
import { NormalNotification } from '../../../main/ets/model/NormalNotification';
import { NormalNotificationGroup } from '../../../main/ets/model/NormalNotificationGroup';
import { LiveNotification } from '../../../main/ets/live/model/LiveNotification';
import { NtfControlConfig } from '../../../main/ets/model/NtfControlFlags';
import { NtfReminderConfig } from '../../../main/ets/model/NtfRemindFlags';
import { NotificationUtil } from '../../../main/ets/utils/NotificationUtil';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationBase } from '../../../main/ets/model/NotificationBase';
export default function NotificationBaseTest() {
  describe('isEmergencyNtf_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_slotType_is_EMERGENCY_INFORMATION', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.slotType = notificationManager.SlotType.EMERGENCY_INFORMATION;
      const result = notificationbase.isEmergencyNtf();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_slotType_is_not_EMERGENCY_INFORMATION', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.slotType = notificationManager.SlotType.INFO;
      const result = notificationbase.isEmergencyNtf();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_role_is_NORMAL', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.role = NotificationRole.NORMAL;
      const result = notificationbase.isNormal();
      expect(result).assertTrue();
    });

    it('should_return_false_when_role_is_not_NORMAL', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.role = NotificationRole.HIGH_PRIVACY;
      const result = notificationbase.isNormal();
      expect(result).assertFalse();
    });

    it('should_return_true_when_role_is_NORMAL_GROUP', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.role = NotificationRole.NORMAL_GROUP;
      const result = notificationbase.isNormalGroup();
      expect(result).assertTrue();
    });

    it('should_return_false_when_role_is_not_NORMAL_GROUP', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.role = NotificationRole.LARGE_ICON;
      const result = notificationbase.isNormalGroup();
      expect(result).assertFalse();
    });

    it('should_return_true_when_role_is_LIVE_VIEW', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.role = NotificationRole.LIVE_VIEW;
      const result = notificationbase.isLiveView();
      expect(result).assertTrue();
    });

    it('should_return_false_when_role_is_not_LIVE_VIEW', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.role = NotificationRole.NORMAL;
      const result = notificationbase.isLiveView();
      expect(result).assertFalse();
    });

    it('should_update_key_when_getCategory_and_getGroupKey_are_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let notificationBase: NotificationBase = new NotificationBase();

      let mockGetCategory: Function = mocker.mockFunc(notificationBase, notificationBase.getCategory);
      let mockGetGroupKey: Function = mocker.mockFunc(notificationBase, notificationBase.getGroupKey);

      let mockCategory: NotificationCategory = new NotificationCategory();
      let mockGroupKey: string = "mockGroupKey";

      when(mockGetCategory)([]).afterReturn(mockCategory);
      when(mockGetGroupKey)([]).afterReturn(mockGroupKey);

      notificationBase.updateKey();

      expect(notificationBase.category).assertEqual(mockCategory);
      expect(notificationBase.groupKey).assertEqual(mockGroupKey);

      mocker.ignoreMock(notificationBase, notificationBase.getCategory);
      mocker.ignoreMock(notificationBase, notificationBase.getGroupKey);
    });

    it('should_return_overlayIcon_when_overlayIconStyle_is_not_REVERSE', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.overlayIconStyle = OverlayIconStyle.DEFAULT;
      notificationbase.overlayIcon = 'overlayIcon';
      const result = notificationbase.getBigIcon();
      expect(result).assertEqual('overlayIcon');
    });

    it('should_return_getAppIcon_result_when_overlayIconStyle_is_REVERSE', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.overlayIconStyle = OverlayIconStyle.REVERSE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationbase, notificationbase.getAppIcon);
      when(mockfunc)(ArgumentMatchers.anyBoolean).afterReturn('getAppIconResult');
      const result = notificationbase.getBigIcon();
      expect(result).assertEqual('getAppIconResult');
      mocker.ignoreMock(notificationbase, notificationbase.getAppIcon);  //还原mock函数，否则会影响其他用例
    });

    it('should_return_overlayIcon_when_overlayIconStyle_is_REVERSE', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.overlayIconStyle = OverlayIconStyle.REVERSE;
      notificationbase.overlayIcon = "overlayIcon";
      const result = notificationbase.getStackIcon();
      expect(result).assertEqual("overlayIcon");
    });

    it('should_return_getAppIcon_result_when_overlayIconStyle_is_not_REVERSE', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.overlayIconStyle = OverlayIconStyle.DEFAULT;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationbase, notificationbase.getAppIcon);
      when(mockfunc)(ArgumentMatchers.anyBoolean).afterReturn("getAppIconResult");
      const result = notificationbase.getStackIcon();
      expect(result).assertEqual("getAppIconResult");
      mocker.ignoreMock(notificationbase, notificationbase.getAppIcon);  //还原mock函数，否则会影响其他用例
    });

    it('should_return_uid_when_toSimpleString_is_called', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      let result = notificationbase.toSimpleString();
      expect(result).assertContain('_')
      expect(result).assertContain(Date.now().toString())
    });

    it('should_return_new_notification_with_cloned_properties', 0, async () => {
      let notificationbase: NotificationBase = new NotificationBase();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationbase, notificationbase.updateKey);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let newNtf = notificationbase.clone();
      expect(newNtf.uid).assertEqual(notificationbase.uid);
      mocker.ignoreMock(notificationbase, notificationbase.updateKey);
    });

    it('should_return_true_when_slotType_is_EMERGENCY_INFORMATION', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.slotType = notificationManager.SlotType.EMERGENCY_INFORMATION;
      const result = notificationbase.isEmergencyNtf();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_slotType_is_not_EMERGENCY_INFORMATION', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.slotType = notificationManager.SlotType.INFO;
      const result = notificationbase.isEmergencyNtf();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_role_is_NORMAL', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.role = NotificationRole.NORMAL;
      const result = notificationbase.isNormal();
      expect(result).assertTrue();
    });

    it('should_return_false_when_role_is_not_NORMAL', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.role = NotificationRole.HIGH_PRIVACY;
      const result = notificationbase.isNormal();
      expect(result).assertFalse();
    });

    it('should_return_true_when_role_is_NORMAL_GROUP', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.role = NotificationRole.NORMAL_GROUP;
      const result = notificationbase.isNormalGroup();
      expect(result).assertTrue();
    });

    it('should_return_false_when_role_is_not_NORMAL_GROUP', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.role = NotificationRole.LARGE_ICON;
      const result = notificationbase.isNormalGroup();
      expect(result).assertFalse();
    });

    it('should_return_true_when_role_is_LIVE_VIEW', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.role = NotificationRole.LIVE_VIEW;
      const result = notificationbase.isLiveView();
      expect(result).assertTrue();
    });

    it('should_return_false_when_role_is_not_LIVE_VIEW', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.role = NotificationRole.NORMAL;
      const result = notificationbase.isLiveView();
      expect(result).assertFalse();
    });

    it('should_update_key_when_getCategory_and_getGroupKey_are_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let notificationBase: NotificationBase = new NotificationBase();

      let mockGetCategory: Function = mocker.mockFunc(notificationBase, notificationBase.getCategory);
      let mockGetGroupKey: Function = mocker.mockFunc(notificationBase, notificationBase.getGroupKey);

      let mockCategory: NotificationCategory = new NotificationCategory();
      let mockGroupKey: string = "mockGroupKey";

      when(mockGetCategory)([]).afterReturn(mockCategory);
      when(mockGetGroupKey)([]).afterReturn(mockGroupKey);

      notificationBase.updateKey();

      expect(notificationBase.category).assertEqual(mockCategory);
      expect(notificationBase.groupKey).assertEqual(mockGroupKey);

      mocker.ignoreMock(notificationBase, notificationBase.getCategory);
      mocker.ignoreMock(notificationBase, notificationBase.getGroupKey);
    });

    it('should_return_overlayIcon_when_overlayIconStyle_is_not_REVERSE', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.overlayIconStyle = OverlayIconStyle.DEFAULT;
      notificationbase.overlayIcon = 'overlayIcon';
      const result = notificationbase.getBigIcon();
      expect(result).assertEqual('overlayIcon');
    });

    it('should_return_getAppIcon_result_when_overlayIconStyle_is_REVERSE', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.overlayIconStyle = OverlayIconStyle.REVERSE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationbase, notificationbase.getAppIcon);
      when(mockfunc)(ArgumentMatchers.anyBoolean).afterReturn('getAppIconResult');
      const result = notificationbase.getBigIcon();
      expect(result).assertEqual('getAppIconResult');
      mocker.ignoreMock(notificationbase, notificationbase.getAppIcon);  //还原mock函数，否则会影响其他用例
    });

    it('should_return_overlayIcon_when_overlayIconStyle_is_REVERSE', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.overlayIconStyle = OverlayIconStyle.REVERSE;
      notificationbase.overlayIcon = "overlayIcon";
      const result = notificationbase.getStackIcon();
      expect(result).assertEqual("overlayIcon");
    });

    it('should_return_getAppIcon_result_when_overlayIconStyle_is_not_REVERSE', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.overlayIconStyle = OverlayIconStyle.DEFAULT;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationbase, notificationbase.getAppIcon);
      when(mockfunc)(ArgumentMatchers.anyBoolean).afterReturn("getAppIconResult");
      const result = notificationbase.getStackIcon();
      expect(result).assertEqual("getAppIconResult");
      mocker.ignoreMock(notificationbase, notificationbase.getAppIcon);  //还原mock函数，否则会影响其他用例
    });

    it('should_return_uid_when_toSimpleString_is_called', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      let result = notificationbase.toSimpleString();
      expect(result).assertContain('_')
      expect(result).assertContain(Date.now().toString())
    });

    it('should_return_new_notification_with_cloned_properties', 0, async () => {
      let notificationbase: NotificationBase = new NotificationBase();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationbase, notificationbase.updateKey);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      let newNtf = notificationbase.clone();
      expect(newNtf.uid).assertEqual(notificationbase.uid);
      mocker.ignoreMock(notificationbase, notificationbase.updateKey);
    });

    it('should_return_true_when_slotType_is_EMERGENCY_INFORMATION', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.slotType = notificationManager.SlotType.EMERGENCY_INFORMATION;
      const result = notificationbase.isEmergencyNtf();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_slotType_is_not_EMERGENCY_INFORMATION', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.slotType = notificationManager.SlotType.INFO;
      const result = notificationbase.isEmergencyNtf();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_role_is_NORMAL', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.role = NotificationRole.NORMAL;
      const result = notificationbase.isNormal();
      expect(result).assertTrue();
    });

    it('should_return_false_when_role_is_not_NORMAL', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.role = NotificationRole.HIGH_PRIVACY;
      const result = notificationbase.isNormal();
      expect(result).assertFalse();
    });

    it('should_return_true_when_role_is_NORMAL_GROUP', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.role = NotificationRole.NORMAL_GROUP;
      const result = notificationbase.isNormalGroup();
      expect(result).assertTrue();
    });

    it('should_return_false_when_role_is_not_NORMAL_GROUP', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.role = NotificationRole.LARGE_ICON;
      const result = notificationbase.isNormalGroup();
      expect(result).assertFalse();
    });

    it('should_return_true_when_role_is_LIVE_VIEW', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.role = NotificationRole.LIVE_VIEW;
      const result = notificationbase.isLiveView();
      expect(result).assertTrue();
    });

    it('should_return_false_when_role_is_not_LIVE_VIEW', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.role = NotificationRole.NORMAL;
      const result = notificationbase.isLiveView();
      expect(result).assertFalse();
    });

    it('should_update_key_when_getCategory_and_getGroupKey_are_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let notificationBase: NotificationBase = new NotificationBase();

      let mockGetCategory: Function = mocker.mockFunc(notificationBase, notificationBase.getCategory);
      let mockGetGroupKey: Function = mocker.mockFunc(notificationBase, notificationBase.getGroupKey);

      let mockCategory: NotificationCategory = new NotificationCategory();
      let mockGroupKey: string = "mockGroupKey";

      when(mockGetCategory)([]).afterReturn(mockCategory);
      when(mockGetGroupKey)([]).afterReturn(mockGroupKey);

      notificationBase.updateKey();

      expect(notificationBase.category).assertEqual(mockCategory);
      expect(notificationBase.groupKey).assertEqual(mockGroupKey);

      mocker.ignoreMock(notificationBase, notificationBase.getCategory);
      mocker.ignoreMock(notificationBase, notificationBase.getGroupKey);
    });

    it('should_return_overlayIcon_when_overlayIconStyle_is_not_REVERSE', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.overlayIconStyle = OverlayIconStyle.DEFAULT;
      notificationbase.overlayIcon = 'overlayIcon';
      const result = notificationbase.getBigIcon();
      expect(result).assertEqual('overlayIcon');
    });

    it('should_return_getAppIcon_result_when_overlayIconStyle_is_REVERSE', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.overlayIconStyle = OverlayIconStyle.REVERSE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationbase, notificationbase.getAppIcon);
      when(mockfunc)(ArgumentMatchers.anyBoolean).afterReturn('getAppIconResult');
      const result = notificationbase.getBigIcon();
      expect(result).assertEqual('getAppIconResult');
      mocker.ignoreMock(notificationbase, notificationbase.getAppIcon);  //还原mock函数，否则会影响其他用例
    });

    it('should_return_overlayIcon_when_overlayIconStyle_is_REVERSE', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.overlayIconStyle = OverlayIconStyle.REVERSE;
      notificationbase.overlayIcon = "overlayIcon";
      const result = notificationbase.getStackIcon();
      expect(result).assertEqual("overlayIcon");
    });

    it('should_return_getAppIcon_result_when_overlayIconStyle_is_not_REVERSE', 0, () => {
      let notificationbase: NotificationBase = new NotificationBase();
      notificationbase.overlayIconStyle = OverlayIconStyle.DEFAULT;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationbase, notificationbase.getAppIcon);
      when(mockfunc)(ArgumentMatchers.anyBoolean).afterReturn("getAppIconResult");
      const result = notificationbase.getStackIcon();
      expect(result).assertEqual("getAppIconResult");
      mocker.ignoreMock(notificationbase, notificationbase.getAppIcon);  //还原mock函数，否则会影响其他用例
    });
  });
}
