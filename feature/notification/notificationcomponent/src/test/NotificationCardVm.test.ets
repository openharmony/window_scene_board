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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { AccessibilityVm, INotificationCardVm, NotificationItemBaseVm } from '@ohos/systemuicommon/newIndex';
import { NormalNotificationGroup, NotificationBase, NotificationCategory } from '@ohos/systemuicommon/newTsIndex';
import { NotificationConfig } from '../../../main/ets/common/NotificationConfig';
import {
  ClickNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsConstants';
import { curves } from '@kit.ArkUI';
import { AppProtectedStatusVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedStatusVm';
import { ClickNotificationErrorCode } from '@ohos/systemuicommon';
import { sSettingsUtil } from '@ohos/frameworkwrapper';
import { SettingsConstants, SettingsKeyConstants } from '@ohos/commonconstants';
import { NotificationConstants } from '../../../main/ets/common/NotificationConstants';
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
import { NotificationCardVm } from '../../../main/ets/viewmodel/NotificationCardVm';

export default function NotificationCardVmTest() {
  describe('onTouch_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_set_isTouching_to_true_when_event_type_is_Down', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let event: TouchEvent = {
        type: TouchType.Down,
        changedTouches: [{
          windowX: 100, windowY: 200
        }]
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
        changedTouches: [{
          windowX: 100, windowY: 200
        }]
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
        changedTouches: [{
          windowX: 100, windowY: 200
        }]
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
        changedTouches: [{
          windowX: 105, windowY: 205
        }]
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
        changedTouches: [{
          windowX: 105, windowY: 205
        }]
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

    it('should_animate_itemClickScale_to_1_when_event_type_is_Move_and_scale_is_not_1_and_distance_greater_than_4', 0,
      () => {
        let notificationcardvm: NotificationCardVm = new NotificationCardVm();
        let event: TouchEvent = {
          type: TouchType.Move,
          changedTouches: [{
            windowX: 110, windowY: 210
          }]
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

    it('should_return_empty_string_when_accessibility_is_disabled', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let mocker: MockKit = new MockKit();
      let accessibilityVm: AccessibilityVm = AccessibilityVm.instance;
      let mockfunc: Function = mocker.mockFunc(accessibilityVm, accessibilityVm.isEnabled);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      const result = notificationcardvm.accessibilityDescription;
      expect(result).assertEqual('');
      mocker.ignoreMock(accessibilityVm, accessibilityVm.isEnabled);
    });

    it('should_return_swipe_accessibility_description_when_show_setting_button_or_remove_button_is_shown', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let mocker: MockKit = new MockKit();
      let accessibilityVm: AccessibilityVm = AccessibilityVm.instance;
      let mockfunc: Function = mocker.mockFunc(accessibilityVm, accessibilityVm.isEnabled);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let menuVm: INotificationCardVm = notificationcardvm.vmInjector.getMenuVm(notificationcardvm.ntf);
      let mockfunc2: Function = mocker.mockFunc(menuVm, menuVm.isShowSettingButton);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(true);
      let mockfunc3: Function = mocker.mockFunc(menuVm, menuVm.isShowRemoveButton);
      when(mockfunc3)(ArgumentMatchers.any).afterReturn(false);
      let swipeVm: INotificationCardVm = notificationcardvm.vmInjector.getSwipeVm(notificationcardvm.ntf);
      const result = notificationcardvm.accessibilityDescription;
      expect(result).assertEqual('Swipe up to delete');
      mocker.ignoreMock(accessibilityVm, accessibilityVm.isEnabled);
      mocker.ignoreMock(menuVm, menuVm.isShowSettingButton);
      mocker.ignoreMock(menuVm, menuVm.isShowRemoveButton);
    });

    it('should_return_empty_string_when_neither_setting_button_nor_remove_button_is_shown', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let mocker: MockKit = new MockKit();
      let accessibilityVm: AccessibilityVm = AccessibilityVm.instance;
      let mockfunc: Function = mocker.mockFunc(accessibilityVm, accessibilityVm.isEnabled);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let menuVm: INotificationCardVm = notificationcardvm.vmInjector.getMenuVm(notificationcardvm.ntf);
      let mockfunc2: Function = mocker.mockFunc(menuVm, menuVm.isShowSettingButton);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(false);
      let mockfunc3: Function = mocker.mockFunc(menuVm, menuVm.isShowRemoveButton);
      when(mockfunc3)(ArgumentMatchers.any).afterReturn(false);
      const result = notificationcardvm.accessibilityDescription;
      expect(result).assertEqual('');
      mocker.ignoreMock(accessibilityVm, accessibilityVm.isEnabled);
      mocker.ignoreMock(menuVm, menuVm.isShowSettingButton);
      mocker.ignoreMock(menuVm, menuVm.isShowRemoveButton);
    });

    it('should_reset_all_params_when_reset_is_called', 0, () => {
      let notificationCardVm: NotificationCardVm = new NotificationCardVm();
      notificationCardVm.reset();
      expect(notificationCardVm.scale).assertEqual(1);
      expect(notificationCardVm.opacity).assertEqual(1);
      expect(notificationCardVm.translateY).assertEqual(0);
      expect(notificationCardVm.rotateAngle).assertEqual(0);
      expect(notificationCardVm.contentClipParam).assertEqual(true);
      expect(notificationCardVm.zIndex).assertEqual(1);
      expect(notificationCardVm.containerSize).assertUndefined();
      expect(notificationCardVm.contentSize).assertUndefined();
    });


    it('should_update_scale_opacity_and_translateY_when_scrollListItem_is_called', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let scale: number = 1.5;
      let opacity: number = 0.5;
      let translateY: number = 10;
      notificationcardvm.scrollListItem(scale, opacity, translateY);
      expect(notificationcardvm.scale).assertEqual(scale);
      expect(notificationcardvm.opacity).assertEqual(opacity);
      expect(notificationcardvm.translateY).assertEqual(translateY);
      expect(notificationcardvm.zIndex).assertEqual(0);
    });

    it('should_log_info_when_scrollListItem_is_called', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let scale: number = 1.5;
      let opacity: number = 0.5;
      let translateY: number = 10;
      let logHelper: LogHelper = new LogHelper(LogDomain.NOTIFICATION);
      let logDomain: LogDomain = LogDomain.NOTIFICATION;
      let logLevel: number = 1;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.logInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber,
        ArgumentMatchers.anyNumber).afterReturn(null);
      notificationcardvm.scrollListItem(scale, opacity, translateY);
      mocker.ignoreMock(logHelper, logHelper.logInfo);
    });

    it('should_set_zIndex_to_0_when_scrollListItem_is_called', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let scale: number = 1.5;
      let opacity: number = 0.5;
      let translateY: number = 10;
      notificationcardvm.scrollListItem(scale, opacity, translateY);
      expect(notificationcardvm.zIndex).assertEqual(0);
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

    it('should_not_update_scale_when_scale_is_not_provided', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation();
      expect(notificationcardvm.scale).assertEqual(1);
    });

    it('should_not_update_opacity_when_opacity_is_not_provided', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation(undefined, undefined, undefined, undefined);
      expect(notificationcardvm.opacity).assertEqual(1);
    });

    it('should_not_update_translateY_when_translateY_is_not_provided', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation(undefined, undefined, undefined, undefined);
      expect(notificationcardvm.translateY).assertEqual(0);
    });

    it('should_not_update_rotateAngle_when_rotateAngle_is_not_provided', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.clearAllAnimation(undefined, undefined, undefined, undefined);
      expect(notificationcardvm.rotateAngle).assertEqual(0);
    });

    it('should_update_scale_and_opacity_when_scale_and_opacity_are_provided', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let scale: number = 1.5;
      let opacity: number = 0.5;
      notificationcardvm.itemAppearAnimation(scale, opacity);
      expect(notificationcardvm.scale).assertEqual(scale);
      expect(notificationcardvm.opacity).assertEqual(opacity);
    });

    it('should_not_update_scale_when_scale_is_undefined', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let opacity: number = 0.5;
      notificationcardvm.itemAppearAnimation(undefined, opacity);
      expect(notificationcardvm.scale).assertEqual(1);
    });

    it('should_not_update_opacity_when_opacity_is_undefined', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let scale: number = 1.5;
      notificationcardvm.itemAppearAnimation(scale, undefined);
      expect(notificationcardvm.opacity).assertEqual(1);
    });

    it('should_update_translateY_when_translateY_is_not_undefined', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let translateY: number = 100;
      notificationcardvm.itemFollowAnimation(translateY);
      expect(notificationcardvm.translateY).assertEqual(translateY);
    });

    it('should_not_update_translateY_when_translateY_is_undefined', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.itemFollowAnimation();
      expect(notificationcardvm.translateY).assertEqual(0);
    });


    it('should_update_translateY_when_translateY_is_not_undefined', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let translateY: number = 100;
      notificationcardvm.itemReboundAnimation(translateY);
      expect(notificationcardvm.translateY).assertEqual(translateY);
    });

    it('should_not_update_translateY_when_translateY_is_undefined', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let translateY: number = undefined;
      notificationcardvm.itemReboundAnimation(translateY);
      expect(notificationcardvm.translateY).assertEqual(0);
    });

    it('should_return_true_when_index_is_0_and_category_is_OTHER_and_isCollapsed_is_true', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let mocker: MockKit = new MockKit();
      let vmInjector: any = notificationcardvm.vmInjector;
      let mockfunc: Function = mocker.mockFunc(vmInjector, vmInjector.getNotificationMoreHeaderVm);
      when(mockfunc)().afterReturn({ isCollapsed: true });
      const result = notificationcardvm.isMoreBrief(0);
      expect(result).assertEqual(true);
      mocker.ignoreMock(vmInjector, vmInjector.getNotificationMoreHeaderVm);
    });

    it('should_return_false_when_index_is_not_0', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      const result = notificationcardvm.isMoreBrief(1);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_category_is_not_OTHER', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.ntf.category = NotificationCategory.URGENT;
      const result = notificationcardvm.isMoreBrief(0);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_isCollapsed_is_false', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let mocker: MockKit = new MockKit();
      let vmInjector: any = notificationcardvm.vmInjector;
      let mockfunc: Function = mocker.mockFunc(vmInjector, vmInjector.getNotificationMoreHeaderVm);
      when(mockfunc)().afterReturn({ isCollapsed: false });
      const result = notificationcardvm.isMoreBrief(0);
      expect(result).assertEqual(false);
      mocker.ignoreMock(vmInjector, vmInjector.getNotificationMoreHeaderVm);
    });

    it('should_update_transition_animation_when_animation_is_provided', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let mocker: MockKit = new MockKit();

      let mockAccessibilityVm: AccessibilityVm = new AccessibilityVm();
      let mockNotificationItemBaseVm: NotificationItemBaseVm = new NotificationItemBaseVm();
      let mockAppProtectedStatusVm: AppProtectedStatusVm = new AppProtectedStatusVm();

      let notificationBase: NotificationBase = new NotificationBase(1, NotificationCategory.NORMAL, "title", "text", "action", "data", 1, 1, 1, false, "id");
      notificationBase.wantAgent = {
        wants: [
          {
            bundleName: "com.ohos.test"
          }
        ],
        operationType: 1,
        requestCode: 1,
        wantAgentFlags: [
          "FLAG1",
          "FLAG2"
        ]
      };
      notificationcardvm.ntf = notificationBase;

      let notificationConfig: NotificationConfig = new NotificationConfig();
      notificationConfig.accessibilityVm = mockAccessibilityVm;
      notificationConfig.notificationItemBaseVm = mockNotificationItemBaseVm;
      notificationConfig.appProtectedStatusVm = mockAppProtectedStatusVm;
      notificationcardvm.vmInjector = notificationConfig;

      let animation: TransitionEffect = TransitionEffect.asymmetric(TransitionEffect.OPACITY.animation({
        duration: 167,
        delay: 83,
        curve: curves.LIST_ITEM_TRANSITION_CURVE
      }).combine(TransitionEffect.opacity(0)).combine(TransitionEffect.scale({ x: 0.6, y: 0.6 })),
        TransitionEffect.OPACITY.combine(TransitionEffect.scale({
          x: 0.6,
          y: 0.6,
          centerX: '50%',
          centerY: 0
        })).animation({ duration: 100, curve: curves.LIST_ITEM_TRANSITION_CURVE }));

      notificationcardvm.updateTransitionAnimation(animation);

      expect(notificationcardvm.transitionAnimation).assertEqual(animation);
    });

  })
}