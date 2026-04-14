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

import { NotificationCreatorType, SystemuiConstants } from '@ohos/systemuicommon';
import { bundleManager } from '@kit.AbilityKit';
import {
  AnimationBase,
  DeviceInfoVm,
  INotificationMenuVm,
  NotificationItemBaseVm,
  RemoveButtonData,
  ResourceVm,
  SettingButtonData
} from '@ohos/systemuicommon/newIndex';
import { NotificationCategory } from '@ohos/systemuicommon/newTsIndex';
import Curves from '@ohos.curves';
import { NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import { NotificationStyle } from '../../../main/ets/constants/NotificationStyle';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { ItemUtils } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationMenuVm } from '../../../main/ets/viewmodel/NotificationMenuVm';
export default function NotificationMenuVmTest() {
  describe('menuWidth_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_correct_menuWidth_when_isShowSettingButton_and_isShowRemoveButton_are_true', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.settingButtonData.isShowSettingButton = true;
      notificationmenuvm.removeButtonData.isShowRemoveButton = true;
      let result = notificationmenuvm.menuWidth;
      expect(result).assertEqual(singleMenuWidth * 2);
    });

    it('should_return_correct_menuWidth_when_isShowSettingButton_is_true_and_isShowRemoveButton_is_false', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.settingButtonData.isShowSettingButton = true;
      notificationmenuvm.removeButtonData.isShowRemoveButton = false;
      let result = notificationmenuvm.menuWidth;
      expect(result).assertEqual(singleMenuWidth);
    });

    it('should_return_correct_menuWidth_when_isShowSettingButton_is_false_and_isShowRemoveButton_is_true', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.settingButtonData.isShowSettingButton = false;
      notificationmenuvm.removeButtonData.isShowRemoveButton = true;
      let result = notificationmenuvm.menuWidth;
      expect(result).assertEqual(singleMenuWidth);
    });

    it('should_return_correct_menuWidth_when_isShowSettingButton_and_isShowRemoveButton_are_false', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.settingButtonData.isShowSettingButton = false;
      notificationmenuvm.removeButtonData.isShowRemoveButton = false;
      let result = notificationmenuvm.menuWidth;
      expect(result).assertEqual(0);
    });


    it('should_return_false_when_isInGroup_is_true', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.isInGroup = true;
      const result = notificationmenuvm.isShowSettingButton();
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_ntf_is_null', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.ntf = null;
      const result = notificationmenuvm.isShowSettingButton();
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_ntf_is_normal_group_and_children_not_every_show_setting_button', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationmenuvm, notificationmenuvm.checkShowSettingButton);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let ntf: NotificationBase = new NotificationBase();
      ntf.notificationStyle = NotificationStyle.NOTIFICATION_STYLE_NORMAL;
      ntf.notificationCategory = NotificationCategory.NOTIFICATION_CATEGORY_SYSTEM;
      ntf.bundleName = "com.ohos.test";
      ntf.abilityName = "MainAbility";
      ntf.title = "test_title";
      ntf.text = "test_text";
      ntf.titleId = 1;
      ntf.textId = 2;
      ntf.bundleName = "com.ohos.test";
      ntf.abilityName = "MainAbility";
      ntf.children = [new NotificationItemBaseVm(), new NotificationItemBaseVm()];
      notificationmenuvm.ntf = ntf;
      notificationmenuvm.isInGroup = false;
      const result = notificationmenuvm.isShowSettingButton();
      expect(result).assertEqual(false);
      mocker.ignoreMock(notificationmenuvm, notificationmenuvm.checkShowSettingButton);
    });

    it('should_return_true_when_ntf_is_normal_group_and_children_every_show_setting_button', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationmenuvm, notificationmenuvm.checkShowSettingButton);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let ntf: NotificationBase = new NotificationBase();
      ntf.notificationStyle = NotificationStyle.NOTIFICATION_STYLE_NORMAL;
      ntf.notificationCategory = NotificationCategory.NOTIFICATION_CATEGORY_SYSTEM;
      ntf.bundleName = "com.ohos.test";
      ntf.abilityName = "MainAbility";
      ntf.title = "test_title";
      ntf.text = "test_text";
      ntf.titleId = 1;
      ntf.textId = 2;
      ntf.bundleName = "com.ohos.test";
      ntf.abilityName = "MainAbility";
      ntf.children = [new NotificationItemBaseVm(), new NotificationItemBaseVm()];
      notificationmenuvm.ntf = ntf;
      notificationmenuvm.isInGroup = false;
      const result = notificationmenuvm.isShowSettingButton();
      expect(result).assertEqual(true);
      mocker.ignoreMock(notificationmenuvm, notificationmenuvm.checkShowSettingButton);
    });

    it('should_return_true_when_ntf_is_not_normal_group_and_checkShowSettingButton_returns_true', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationmenuvm, notificationmenuvm.checkShowSettingButton);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      let ntf: NotificationBase = new NotificationBase();
      ntf.notificationStyle = NotificationStyle.NOTIFICATION_STYLE_NORMAL;
      ntf.notificationCategory = NotificationCategory.NOTIFICATION_CATEGORY_SYSTEM;
      ntf.bundleName = "com.ohos.test";
      ntf.abilityName = "MainAbility";
      ntf.title = "test_title";
      ntf.text = "test_text";
      ntf.titleId = 1;
      ntf.textId = 2;
      ntf.bundleName = "com.ohos.test";
      ntf.abilityName = "MainAbility";
      notificationmenuvm.ntf = ntf;
      notificationmenuvm.isInGroup = false;
      const result = notificationmenuvm.isShowSettingButton();
      expect(result).assertEqual(true);
      mocker.ignoreMock(notificationmenuvm, notificationmenuvm.checkShowSettingButton);
    });

    it('should_return_false_when_ntf_is_not_normal_group_and_checkShowSettingButton_returns_false', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationmenuvm, notificationmenuvm.checkShowSettingButton);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let ntf: NotificationBase = new NotificationBase();
      ntf.notificationStyle = NotificationStyle.NOTIFICATION_STYLE_NORMAL;
      ntf.notificationCategory = NotificationCategory.NOTIFICATION_CATEGORY_SYSTEM;
      ntf.bundleName = "com.ohos.test";
      ntf.abilityName = "MainAbility";
      ntf.title = "test_title";
      ntf.text = "test_text";
      ntf.titleId = 1;
      ntf.textId = 2;
      ntf.bundleName = "com.ohos.test";
      ntf.abilityName = "MainAbility";
      notificationmenuvm.ntf = ntf;
      notificationmenuvm.isInGroup = false;
      const result = notificationmenuvm.isShowSettingButton();
      expect(result).assertEqual(false);
      mocker.ignoreMock(notificationmenuvm, notificationmenuvm.checkShowSettingButton);
    });

    it('should_return_false_when_bundleType_is_ATOMIC_SERVICE', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      let ntf: NotificationBase = new NotificationBase();
      ntf.bundleType = bundleManager.BundleType.ATOMIC_SERVICE;
      const result = notificationmenuvm.checkShowSettingButton(ntf);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_agentBundle_is_PUSH_BUNDLE_NAME', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      let ntf: NotificationBase = new NotificationBase();
      ntf.agentBundle = { bundle: SystemuiConstants.PUSH_BUNDLE_NAME };
      const result = notificationmenuvm.checkShowSettingButton(ntf);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_creatorType_is_SA', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      let ntf: NotificationBase = new NotificationBase();
      ntf.creatorType = NotificationCreatorType.SA;
      const result = notificationmenuvm.checkShowSettingButton(ntf);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_isEmergencyMode_is_true', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      let ntf: NotificationBase = new NotificationBase();
      let mocker: MockKit = new MockKit();
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let mockfunc: Function = mocker.mockFunc(deviceInfoVm, deviceInfoVm.isEmergencyMode);
      when(mockfunc)().afterReturn(true);
      const result = notificationmenuvm.checkShowSettingButton(ntf);
      expect(result).assertEqual(false);
      mocker.ignoreMock(deviceInfoVm, deviceInfoVm.isEmergencyMode);
    });

    it('should_return_false_when_isMoreBrief_is_true', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      let ntf: NotificationBase = new NotificationBase();
      notificationmenuvm.isMoreBrief = () => true;
      const result = notificationmenuvm.checkShowSettingButton(ntf);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isSettingIgnore_is_false', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      let ntf: NotificationBase = new NotificationBase();
      ntf.isSettingIgnore = false;
      const result = notificationmenuvm.checkShowSettingButton(ntf);
      expect(result).assertEqual(true);
    });

    it('should_execute_animation_when_isSwipeOverThreshold_or_isSwipeRemoving_is_true', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.isSwipeOverThreshold = true;
      let settingButtonData: SettingButtonData = new SettingButtonData();
      settingButtonData.opacity = 1;
      notificationmenuvm.settingButtonData = settingButtonData;
      let ntf: NotificationBase = new NotificationBase();
      ntf.isClearAllowed = true;
      notificationmenuvm.ntf = ntf;
      notificationmenuvm.setSettingButton(100, true);
      expect(settingButtonData.opacity).assertEqual(0);
    });

    it('should_set_opacity_to_0_when_isSwipeOverThreshold_or_isSwipeRemoving_is_true_and_opacity_is_not_null', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.isSwipeOverThreshold = true;
      let settingButtonData: SettingButtonData = new SettingButtonData();
      settingButtonData.opacity = 0.5;
      notificationmenuvm.settingButtonData = settingButtonData;
      let ntf: NotificationBase = new NotificationBase();
      ntf.isClearAllowed = true;
      notificationmenuvm.ntf = ntf;
      notificationmenuvm.setSettingButton(100, true);
      expect(settingButtonData.opacity).assertEqual(0);
    });

    it('should_not_execute_animation_when_isSwipeOverThreshold_or_isSwipeRemoving_is_false', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.isSwipeOverThreshold = false;
      let settingButtonData: SettingButtonData = new SettingButtonData();
      settingButtonData.opacity = 1;
      notificationmenuvm.settingButtonData = settingButtonData;
      let ntf: NotificationBase = new NotificationBase();
      ntf.isClearAllowed = true;
      notificationmenuvm.ntf = ntf;
      notificationmenuvm.setSettingButton(100, false);
      expect(settingButtonData.opacity).assertEqual(1);
    });

    it('should_set_opacity_to_0.5_when_isSwipeOverThreshold_or_isSwipeRemoving_is_false_and_opacity_is_0.5', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.isSwipeOverThreshold = false;
      let settingButtonData: SettingButtonData = new SettingButtonData();
      settingButtonData.opacity = 0.5;
      notificationmenuvm.settingButtonData = settingButtonData;
      let ntf: NotificationBase = new NotificationBase();
      ntf.isClearAllowed = true;
      notificationmenuvm.ntf = ntf;
      notificationmenuvm.setSettingButton(100, false);
      expect(settingButtonData.opacity).assertEqual(0.5);
    });

    it('should_set_offsetX_to_0_when_swipeOffsetX_is_less_than_or_equal_to_menuWidth', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.isSwipeOverThreshold = false;
      let settingButtonData: SettingButtonData = new SettingButtonData();
      notificationmenuvm.settingButtonData = settingButtonData;
      notificationmenuvm.menuWidth = 200;
      notificationmenuvm.setSettingButton(100, false);
      expect(settingButtonData.offsetX).assertEqual(0);
    });

    it('should_set_offsetX_to_menuWidth_plus_swipeOffsetX_div_SETTING_BUTTON_OFFSET_RATIO_when_swipeOffsetX_is_greater_than_menuWidth', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.isSwipeOverThreshold = false;
      let settingButtonData: SettingButtonData = new SettingButtonData();
      notificationmenuvm.settingButtonData = settingButtonData;
      notificationmenuvm.menuWidth = 100;
      notificationmenuvm.setSettingButton(200, false);
      expect(settingButtonData.offsetX).assertEqual(3);
    });

    it('should_return_immediately_when_isClearAllowed_is_false', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationmenuvm, notificationmenuvm.ntf);
      when(mockfunc).isClearAllowed = false;
      notificationmenuvm.animationOverThreshold(100);
      mocker.ignoreMock(notificationmenuvm, notificationmenuvm.ntf);
    });

    it('should_animate_remove_button_when_isSwipeOverThreshold_is_true_and_expandScale_is_0', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.isSwipeOverThreshold = true;
      notificationmenuvm.removeButtonData.expandScale = 0;
      notificationmenuvm.removeButtonData.scale = 0.5;
      let mocker: MockKit = new MockKit();

      notificationmenuvm.animationOverThreshold(100);

      expect(notificationmenuvm.removeButtonData.coverRotate).assertEqual(12.0);

    });

    it('should_animate_remove_button_when_isSwipeOverThreshold_is_false_and_expandScale_is_not_0', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.isSwipeOverThreshold = false;
      notificationmenuvm.removeButtonData.expandScale = 0.5;
      let mocker: MockKit = new MockKit();

      notificationmenuvm.animationOverThreshold(100);

      expect(notificationmenuvm.removeButtonData.coverRotate).assertEqual(12.0);

    });

    it('should_not_animate_remove_button_when_isSwipeOverThreshold_is_false_and_expandScale_is_0', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.isSwipeOverThreshold = false;
      notificationmenuvm.removeButtonData.expandScale = 0;
      let mocker: MockKit = new MockKit();

      notificationmenuvm.animationOverThreshold(100);

      expect(notificationmenuvm.removeButtonData.coverRotate).assertEqual(0);

    });

    it('should_return_false_when_isEmergencyMode_is_true', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      let ntf: NotificationBase = new NotificationBase();
      let mocker: MockKit = new MockKit();
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let mockfunc: Function = mocker.mockFunc(deviceInfoVm, deviceInfoVm.isEmergencyMode);
      when(mockfunc)().afterReturn(true);
      const result = notificationmenuvm.checkShowSettingButton(ntf);
      expect(result).assertEqual(false);
      mocker.ignoreMock(deviceInfoVm, deviceInfoVm.isEmergencyMode);
    });

    it('should_return_false_when_isMoreBrief_is_true', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      let ntf: NotificationBase = new NotificationBase();
      notificationmenuvm.isMoreBrief = () => true;
      const result = notificationmenuvm.checkShowSettingButton(ntf);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isSettingIgnore_is_false', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      let ntf: NotificationBase = new NotificationBase();
      ntf.isSettingIgnore = false;
      const result = notificationmenuvm.checkShowSettingButton(ntf);
      expect(result).assertEqual(true);
    });

    it('should_execute_animation_when_isSwipeOverThreshold_or_isSwipeRemoving_is_true', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.isSwipeOverThreshold = true;
      let settingButtonData: SettingButtonData = new SettingButtonData();
      settingButtonData.opacity = 1;
      notificationmenuvm.settingButtonData = settingButtonData;
      let ntf: NotificationBase = new NotificationBase();
      ntf.isClearAllowed = true;
      notificationmenuvm.ntf = ntf;
      notificationmenuvm.setSettingButton(100, true);
      expect(settingButtonData.opacity).assertEqual(0);
    });

    it('should_set_opacity_to_0_when_isSwipeOverThreshold_or_isSwipeRemoving_is_true_and_opacity_is_not_null', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.isSwipeOverThreshold = true;
      let settingButtonData: SettingButtonData = new SettingButtonData();
      settingButtonData.opacity = 0.5;
      notificationmenuvm.settingButtonData = settingButtonData;
      let ntf: NotificationBase = new NotificationBase();
      ntf.isClearAllowed = true;
      notificationmenuvm.ntf = ntf;
      notificationmenuvm.setSettingButton(100, true);
      expect(settingButtonData.opacity).assertEqual(0);
    });

    it('should_not_execute_animation_when_isSwipeOverThreshold_or_isSwipeRemoving_is_false', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.isSwipeOverThreshold = false;
      let settingButtonData: SettingButtonData = new SettingButtonData();
      settingButtonData.opacity = 1;
      notificationmenuvm.settingButtonData = settingButtonData;
      let ntf: NotificationBase = new NotificationBase();
      ntf.isClearAllowed = true;
      notificationmenuvm.ntf = ntf;
      notificationmenuvm.setSettingButton(100, false);
      expect(settingButtonData.opacity).assertEqual(1);
    });

    it('should_set_opacity_to_0.5_when_isSwipeOverThreshold_or_isSwipeRemoving_is_false_and_opacity_is_0.5', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.isSwipeOverThreshold = false;
      let settingButtonData: SettingButtonData = new SettingButtonData();
      settingButtonData.opacity = 0.5;
      notificationmenuvm.settingButtonData = settingButtonData;
      let ntf: NotificationBase = new NotificationBase();
      ntf.isClearAllowed = true;
      notificationmenuvm.ntf = ntf;
      notificationmenuvm.setSettingButton(100, false);
      expect(settingButtonData.opacity).assertEqual(0.5);
    });

    it('should_set_offsetX_to_0_when_swipeOffsetX_is_less_than_or_equal_to_menuWidth', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.isSwipeOverThreshold = false;
      let settingButtonData: SettingButtonData = new SettingButtonData();
      notificationmenuvm.settingButtonData = settingButtonData;
      notificationmenuvm.menuWidth = 200;
      notificationmenuvm.setSettingButton(100, false);
      expect(settingButtonData.offsetX).assertEqual(0);
    });

    it('should_set_offsetX_to_menuWidth_plus_swipeOffsetX_div_SETTING_BUTTON_OFFSET_RATIO_when_swipeOffsetX_is_greater_than_menuWidth', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.isSwipeOverThreshold = false;
      let settingButtonData: SettingButtonData = new SettingButtonData();
      notificationmenuvm.settingButtonData = settingButtonData;
      notificationmenuvm.menuWidth = 100;
      notificationmenuvm.setSettingButton(200, false);
      expect(settingButtonData.offsetX).assertEqual(3);
    });

    it('should_return_true_when_isSettingIgnore_is_false', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      let ntf: NotificationBase = new NotificationBase();
      ntf.isSettingIgnore = false;
      const result = notificationmenuvm.checkShowSettingButton(ntf);
      expect(result).assertEqual(true);
    });

    it('should_execute_animation_when_isSwipeOverThreshold_or_isSwipeRemoving_is_true', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.isSwipeOverThreshold = true;
      let settingButtonData: SettingButtonData = new SettingButtonData();
      settingButtonData.opacity = 1;
      notificationmenuvm.settingButtonData = settingButtonData;
      let ntf: NotificationBase = new NotificationBase();
      ntf.isClearAllowed = true;
      notificationmenuvm.ntf = ntf;
      notificationmenuvm.setSettingButton(100, true);
      expect(settingButtonData.opacity).assertEqual(0);
    });

    it('should_return_false_when_bundleType_is_ATOMIC_SERVICE', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      let ntf: NotificationBase = new NotificationBase();
      ntf.bundleType = bundleManager.BundleType.ATOMIC_SERVICE;
      const result = notificationmenuvm.checkShowSettingButton(ntf);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_agentBundle_is_PUSH_BUNDLE_NAME', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      let ntf: NotificationBase = new NotificationBase();
      ntf.agentBundle = { bundle: SystemuiConstants.PUSH_BUNDLE_NAME };
      const result = notificationmenuvm.checkShowSettingButton(ntf);
      expect(result).assertEqual(false);
    });

  });
}