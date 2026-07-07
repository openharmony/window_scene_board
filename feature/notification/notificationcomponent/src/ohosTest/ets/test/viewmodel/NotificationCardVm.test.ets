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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { AccessibilityVm, INotificationCardVm, NotificationItemBaseVm } from '@ohos/systemuicommon/newIndex';
import { NormalNotificationGroup, NotificationBase, NotificationCategory } from '@ohos/systemuicommon/newTsIndex';
import { NotificationConfig } from '../../../main/ets/common/NotificationConfig';
import { ClickNotificationMaintenance } from '@ohos/systemuicommon/src/main/ets/maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsConstants';
import { curves } from '@kit.ArkUI';
import { AppProtectedStatusVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedStatusVm';
import { ClickNotificationErrorCode } from '@ohos/systemuicommon';
import { sSettingsUtil } from '@ohos/frameworkwrapper';
import { SettingsConstants, SettingsKeyConstants } from '@ohos/commonconstants';
import { NotificationConstants } from '../../../main/ets/common/NotificationConstants';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationCardVm } from '../../../main/ets/viewmodel/NotificationCardVm';
export default function NotificationCardVmTest() {
  describe('clearAllAnimation_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_update_scale_when_scale_is_provided', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation(0.5);
      expect(notificationcardvm.scale).assertEqual(0.5);
    });

    it('should_update_opacity_when_opacity_is_provided', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation(undefined, 0.5);
      expect(notificationcardvm.opacity).assertEqual(0.5);
    });

    it('should_update_translateY_when_translateY_is_provided', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation(undefined, undefined, 10);
      expect(notificationcardvm.translateY).assertEqual(10);
    });

    it('should_update_rotateAngle_when_rotateAngle_is_provided', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation(undefined, undefined, undefined, 30);
      expect(notificationcardvm.rotateAngle).assertEqual(30);
    });

    it('should_not_update_scale_when_scale_is_undefined', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation();
      expect(notificationcardvm.scale).assertEqual(1);
    });

    it('should_not_update_opacity_when_opacity_is_undefined', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation();
      expect(notificationcardvm.opacity).assertEqual(1);
    });

    it('should_not_update_translateY_when_translateY_is_undefined', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation();
      expect(notificationcardvm.translateY).assertEqual(0);
    });

    it('should_not_update_rotateAngle_when_rotateAngle_is_undefined', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation();
      expect(notificationcardvm.rotateAngle).assertEqual(0);
    });

    it('should_update_scale_when_scale_is_provided', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation(0.5);
      expect(notificationcardvm.scale).assertEqual(0.5);
    });

    it('should_update_opacity_when_opacity_is_provided', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation(undefined, 0.5);
      expect(notificationcardvm.opacity).assertEqual(0.5);
    });

    it('should_update_translateY_when_translateY_is_provided', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation(undefined, undefined, 10);
      expect(notificationcardvm.translateY).assertEqual(10);
    });
    it('should_update_rotateAngle_when_rotateAngle_is_provided', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation(undefined, undefined, undefined, 30);
      expect(notificationcardvm.rotateAngle).assertEqual(30);
    });
    it('should_not_update_scale_when_scale_is_undefined', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation();
      expect(notificationcardvm.scale).assertEqual(1);
    });
    it('should_not_update_opacity_when_opacity_is_undefined', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation();
      expect(notificationcardvm.opacity).assertEqual(1);
    });
    it('should_not_update_translateY_when_translateY_is_undefined', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation();
      expect(notificationcardvm.translateY).assertEqual(0);
    });
    it('should_not_update_rotateAngle_when_rotateAngle_is_undefined', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation();
      expect(notificationcardvm.rotateAngle).assertEqual(0);
    });

    it('should_update_scale_when_scale_is_provided', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation(0.5);
      expect(notificationcardvm.scale).assertEqual(0.5);
    });

    it('should_update_opacity_when_opacity_is_provided', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation(undefined, 0.5);
      expect(notificationcardvm.opacity).assertEqual(0.5);
    });

    it('should_update_translateY_when_translateY_is_provided', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation(undefined, undefined, 10);
      expect(notificationcardvm.translateY).assertEqual(10);
    });

    it('should_update_rotateAngle_when_rotateAngle_is_provided', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation(undefined, undefined, undefined, 30);
      expect(notificationcardvm.rotateAngle).assertEqual(30);
    });

    it('should_not_update_scale_when_scale_is_undefined', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation();
      expect(notificationcardvm.scale).assertEqual(1);
    });

    it('should_not_update_opacity_when_opacity_is_undefined', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation();
      expect(notificationcardvm.opacity).assertEqual(1);
    });

    it('should_not_update_translateY_when_translateY_is_undefined', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation();
      expect(notificationcardvm.translateY).assertEqual(0);
    });

    it('should_not_update_rotateAngle_when_rotateAngle_is_undefined', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation();
      expect(notificationcardvm.rotateAngle).assertEqual(0);
    });

    it('should_set_isTouching_to_true_when_event_type_is_Down', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let event: TouchEvent = {
        type: TouchType.Down,
        changedTouches: [{ windowX: 100, windowY: 200 }]
      };
      notificationcardvm.onTouch(event);
      expect(notificationcardvm.isTouching).assertTrue();
      expect(notificationcardvm.touchStartX).assertEqual(100);
      expect(notificationcardvm.touchStartY).assertEqual(200);
      expect(notificationcardvm.itemClickScale).assertEqual(0.95);
    });

    it('should_set_isTouching_to_false_when_event_type_is_Up', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let event: TouchEvent = {
        type: TouchType.Up,
        changedTouches: [{ windowX: 100, windowY: 200 }]
      };
      notificationcardvm.isTouching = true;
      notificationcardvm.touchStartX = 100;
      notificationcardvm.touchStartY = 200;
      notificationcardvm.itemClickScale = 0.95;
      notificationcardvm.onTouch(event);
      expect(notificationcardvm.isTouching).assertFalse();
      expect(notificationcardvm.itemClickScale).assertEqual(1);
    });

    it('should_set_isTouching_to_false_when_event_type_is_Cancel', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let event: TouchEvent = {
        type: TouchType.Cancel,
        changedTouches: [{ windowX: 100, windowY: 200 }]
      };
      notificationcardvm.isTouching = true;
      notificationcardvm.touchStartX = 100;
      notificationcardvm.touchStartY = 200;
      notificationcardvm.itemClickScale = 0.95;
      notificationcardvm.onTouch(event);
      expect(notificationcardvm.isTouching).assertFalse();
      expect(notificationcardvm.itemClickScale).assertEqual(1);
    });

    it('should_animate_itemClickScale_to_1_when_event_type_is_Move_and_scale_is_not_1', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let event: TouchEvent = {
        type: TouchType.Move,
        changedTouches: [{ windowX: 105, windowY: 205 }]
      };
      notificationcardvm.isTouching = true;
      notificationcardvm.touchStartX = 100;
      notificationcardvm.touchStartY = 200;
      notificationcardvm.itemClickScale = 0.95;
      notificationcardvm.onTouch(event);
      expect(notificationcardvm.isTouching).assertTrue();
      expect(notificationcardvm.touchStartX).assertEqual(100);
      expect(notificationcardvm.touchStartY).assertEqual(200);
      expect(notificationcardvm.itemClickScale).assertEqual(1);
    });

    it('should_not_animate_itemClickScale_to_1_when_event_type_is_Move_and_scale_is_1', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let event: TouchEvent = {
        type: TouchType.Move,
        changedTouches: [{ windowX: 105, windowY: 205 }]
      };
      notificationcardvm.isTouching = true;
      notificationcardvm.touchStartX = 100;
      notificationcardvm.touchStartY = 200;
      notificationcardvm.itemClickScale = 1;
      notificationcardvm.onTouch(event);
      expect(notificationcardvm.isTouching).assertTrue();
      expect(notificationcardvm.touchStartX).assertEqual(100);
      expect(notificationcardvm.touchStartY).assertEqual(200);
      expect(notificationcardvm.itemClickScale).assertEqual(1);
    });

    it('should_animate_itemClickScale_to_1_when_event_type_is_Move_and_scale_is_not_1_and_distance_greater_than_4', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let event: TouchEvent = {
        type: TouchType.Move,
        changedTouches: [{ windowX: 110, windowY: 210 }]
      };
      notificationcardvm.isTouching = true;
      notificationcardvm.touchStartX = 100;
      notificationcardvm.touchStartY = 200;
      notificationcardvm.itemClickScale = 0.95;
      notificationcardvm.onTouch(event);
      expect(notificationcardvm.isTouching).assertTrue();
      expect(notificationcardvm.touchStartX).assertEqual(100);
      expect(notificationcardvm.touchStartY).assertEqual(200);
      expect(notificationcardvm.itemClickScale).assertEqual(1);
    });

    it('should_report_click_when_event_type_is_Up_and_ntf_is_deliver_notification_and_privacy_disabled', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let event: TouchEvent = {
        type: TouchType.Up,
        changedTouches: [{ windowX: 100, windowY: 200 }]
      };
      let ntf: NotificationBase = {
        isDeliverNotification: true,
        wantAgent: {} as any,
        wantAgentInfo: {} as any
      };
      let groupNtf: NormalNotificationGroup = {
        notificationBase: ntf,
        notificationType: NotificationCategory.ANNOUNCE
      };
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSystemValue);
      when(mockFunc1)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(SettingsConstants.DELIVER_PRIVACY_ENABLE_STATE_DEFAULT);
      let mockFunc2: Function = mocker.mockFunc(ClickNotificationMaintenance, ClickNotificationMaintenance.reportClick);
      when(mockFunc2)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      let mockFunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockFunc3)(ArgumentMatchers.any).afterReturnNothing();
      notificationcardvm.isTouching = true;
      notificationcardvm.touchStartX = 100;
      notificationcardvm.touchStartY = 200;
      notificationcardvm.itemClickScale = 0.95;
      notificationcardvm.ntf = ntf;
      notificationcardvm.vmInjector.getListVm = () => ({
        getGroupNtf: () => groupNtf
      }) as any;
      notificationcardvm.vmInjector.getStarterVm = () => ({
        startWantAgent: () => {}
      }) as any;
      notificationcardvm.onTouch(event);
      expect(notificationcardvm.isTouching).assertFalse();
      expect(notificationcardvm.itemClickScale).assertEqual(1);
      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSystemValue);
      mocker.ignoreMock(ClickNotificationMaintenance, ClickNotificationMaintenance.reportClick);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_report_click_when_event_type_is_Up_and_ntf_is_not_deliver_notification_or_privacy_enabled', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let event: TouchEvent = {
        type: TouchType.Up,
        changedTouches: [{
          windowX: 100, windowY: 200
        }]
      };
      let ntf: NotificationBase = {
        isDeliverNotification: false,
        wantAgent: {} as any,
        wantAgentInfo: {} as any
      };
      let groupNtf: NormalNotificationGroup = {
        notificationBase: ntf,
        notificationType: NotificationCategory.ANNOUNCE
      };
      let mocker;
    });
    it('should_set_isTouching_to_true_when_event_type_is_Down', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let event: TouchEvent = {
        type: TouchType.Down,
        changedTouches: [{ windowX: 100, windowY: 200 }]
      };
      notificationcardvm.onTouch(event);
      expect(notificationcardvm.isTouching).assertTrue();
      expect(notificationcardvm.touchStartX).assertEqual(100);
      expect(notificationcardvm.touchStartY).assertEqual(200);
      expect(notificationcardvm.itemClickScale).assertEqual(0.95);
    });

    it('should_set_isTouching_to_false_when_event_type_is_Up', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let event: TouchEvent = {
        type: TouchType.Up,
        changedTouches: [{ windowX: 100, windowY: 200 }]
      };
      notificationcardvm.isTouching = true;
      notificationcardvm.touchStartX = 100;
      notificationcardvm.touchStartY = 200;
      notificationcardvm.itemClickScale = 0.95;
      notificationcardvm.onTouch(event);
      expect(notificationcardvm.isTouching).assertFalse();
      expect(notificationcardvm.itemClickScale).assertEqual(1);
    });

    it('should_set_isTouching_to_false_when_event_type_is_Cancel', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let event: TouchEvent = {
        type: TouchType.Cancel,
        changedTouches: [{ windowX: 100, windowY: 200 }]
      };
      notificationcardvm.isTouching = true;
      notificationcardvm.touchStartX = 100;
      notificationcardvm.touchStartY = 200;
      notificationcardvm.itemClickScale = 0.95;
      notificationcardvm.onTouch(event);
      expect(notificationcardvm.isTouching).assertFalse();
      expect(notificationcardvm.itemClickScale).assertEqual(1);
    });

    it('should_animate_itemClickScale_to_1_when_event_type_is_Move_and_scale_is_not_1', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let event: TouchEvent = {
        type: TouchType.Move,
        changedTouches: [{ windowX: 105, windowY: 205 }]
      };
      notificationcardvm.isTouching = true;
      notificationcardvm.touchStartX = 100;
      notificationcardvm.touchStartY = 200;
      notificationcardvm.itemClickScale = 0.95;
      notificationcardvm.onTouch(event);
      expect(notificationcardvm.isTouching).assertTrue();
      expect(notificationcardvm.touchStartX).assertEqual(100);
      expect(notificationcardvm.touchStartY).assertEqual(200);
      expect(notificationcardvm.itemClickScale).assertEqual(1);
    });

    it('should_not_animate_itemClickScale_to_1_when_event_type_is_Move_and_scale_is_1', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let event: TouchEvent = {
        type: TouchType.Move,
        changedTouches: [{ windowX: 105, windowY: 205 }]
      };
      notificationcardvm.isTouching = true;
      notificationcardvm.touchStartX = 100;
      notificationcardvm.touchStartY = 200;
      notificationcardvm.itemClickScale = 1;
      notificationcardvm.onTouch(event);
      expect(notificationcardvm.isTouching).assertTrue();
      expect(notificationcardvm.touchStartX).assertEqual(100);
      expect(notificationcardvm.touchStartY).assertEqual(200);
      expect(notificationcardvm.itemClickScale).assertEqual(1);
    });

    it('should_animate_itemClickScale_to_1_when_event_type_is_Move_and_scale_is_not_1_and_distance_greater_than_4', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let event: TouchEvent = {
        type: TouchType.Move,
        changedTouches: [{ windowX: 110, windowY: 210 }]
      };
      notificationcardvm.isTouching = true;
      notificationcardvm.touchStartX = 100;
      notificationcardvm.touchStartY = 200;
      notificationcardvm.itemClickScale = 0.95;
      notificationcardvm.onTouch(event);
      expect(notificationcardvm.isTouching).assertTrue();
      expect(notificationcardvm.touchStartX).assertEqual(100);
      expect(notificationcardvm.touchStartY).assertEqual(200);
      expect(notificationcardvm.itemClickScale).assertEqual(1);
    });

    it('should_report_click_when_event_type_is_Up_and_ntf_is_deliver_notification_and_privacy_disabled', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let event: TouchEvent = {
        type: TouchType.Up,
        changedTouches: [{ windowX: 100, windowY: 200 }]
      };
      let ntf: NotificationBase = {
        isDeliverNotification: true,
        wantAgent: {} as any,
        wantAgentInfo: {} as any
      };
      let groupNtf: NormalNotificationGroup = {
        notificationBase: ntf,
        notificationType: NotificationCategory.ANNOUNCE
      };
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSystemValue);
      when(mockFunc1)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(SettingsConstants.DELIVER_PRIVACY_ENABLE_STATE_DEFAULT);
      let mockFunc2: Function = mocker.mockFunc(ClickNotificationMaintenance, ClickNotificationMaintenance.reportClick);
      when(mockFunc2)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      let mockFunc3: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockFunc3)(ArgumentMatchers.any).afterReturnNothing();
      notificationcardvm.isTouching = true;
      notificationcardvm.touchStartX = 100;
      notificationcardvm.touchStartY = 200;
      notificationcardvm.itemClickScale = 0.95;
      notificationcardvm.ntf = ntf;
      notificationcardvm.vmInjector.getListVm = () => ({
        getGroupNtf: () => groupNtf
      }) as any;
      notificationcardvm.vmInjector.getStarterVm = () => ({
        startWantAgent: () => {}
      }) as any;
      notificationcardvm.onTouch(event);
      expect(notificationcardvm.isTouching).assertFalse();
      expect(notificationcardvm.itemClickScale).assertEqual(1);
      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSystemValue);
      mocker.ignoreMock(ClickNotificationMaintenance, ClickNotificationMaintenance.reportClick);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_report_click_when_event_type_is_Up_and_ntf_is_not_deliver_notification_or_privacy_enabled', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let event: TouchEvent = {
        type: TouchType.Up,
        changedTouches: [{
          windowX: 100, windowY: 200
        }]
      };
      let ntf: NotificationBase = {
        isDeliverNotification: false,
        wantAgent: {} as any,
        wantAgentInfo: {} as any
      };
      let groupNtf: NormalNotificationGroup = {
        notificationBase: ntf,
        notificationType: NotificationCategory.ANNOUNCE
      };
      let mocker
    });

    it('should_not_animate_itemClickScale_to_1_when_event_type_is_Move_and_scale_is_1', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let event: TouchEvent = {
        type: TouchType.Move,
        changedTouches: [{ windowX: 105, windowY: 205 }]
      };
      notificationcardvm.isTouching = true;
      notificationcardvm.touchStartX = 100;
      notificationcardvm.touchStartY = 200;
      notificationcardvm.itemClickScale = 1;
      notificationcardvm.onTouch(event);
      expect(notificationcardvm.isTouching).assertTrue();
      expect(notificationcardvm.touchStartX).assertEqual(100);
      expect(notificationcardvm.touchStartY).assertEqual(200);
      expect(notificationcardvm.itemClickScale).assertEqual(1);
    });

  });
}