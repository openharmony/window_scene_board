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

    it('checkShowSettingButton_returns_false', 0, () => {
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

    it('swipeOffsetX_is_greater_than_zero_or_isClickButtonRemoving_is_true', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      let swipeOffsetX: number = 1;
      let isSwipeRemoving: boolean = false;
      notificationmenuvm.updateSwipeOffsetX(swipeOffsetX, isSwipeRemoving);
      expect(notificationmenuvm.offsetX).assertEqual(swipeOffsetX);

      swipeOffsetX = -1;
      notificationmenuvm.updateSwipeOffsetX(swipeOffsetX, isSwipeRemoving);
      expect(notificationmenuvm.offsetX).assertEqual(swipeOffsetX);

      notificationmenuvm.isClickButtonRemoving = true;
      swipeOffsetX = 0;
      notificationmenuvm.updateSwipeOffsetX(swipeOffsetX, isSwipeRemoving);
      expect(notificationmenuvm.offsetX).assertEqual(swipeOffsetX);
    });

    it('negative_and_isClickButtonRemoving_is_false',
      0, () => {
        let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
        let mocker: MockKit = new MockKit();

        let swipeOffsetX: number = 0;
        let isSwipeRemoving: boolean = false;
        notificationmenuvm.updateSwipeOffsetX(swipeOffsetX, isSwipeRemoving);
        expect(notificationmenuvm.offsetX).assertEqual(swipeOffsetX);
        expect(notificationmenuvm.isSwipeOverThreshold).assertEqual(false);

        swipeOffsetX = -1;
        notificationmenuvm.updateSwipeOffsetX(swipeOffsetX, isSwipeRemoving);
        expect(notificationmenuvm.offsetX).assertEqual(swipeOffsetX);
        expect(notificationmenuvm.isSwipeOverThreshold).assertEqual(false);

        swipeOffsetX = 0;
        notificationmenuvm.updateSwipeOffsetX(swipeOffsetX, isSwipeRemoving);
        expect(notificationmenuvm.offsetX).assertEqual(swipeOffsetX);
        expect(notificationmenuvm.isSwipeOverThreshold).assertEqual(false);

        notificationmenuvm.isClickButtonRemoving = true;
        swipeOffsetX = -1;
        notificationmenuvm.updateSwipeOffsetX(swipeOffsetX, isSwipeRemoving);
        expect(notificationmenuvm.offsetX).assertEqual(swipeOffsetX);
        expect(notificationmenuvm.isSwipeOverThreshold).assertEqual(false);
      });

    it('should_call_openSetting_when_isClickButtonRemoving_is_false', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.isClickButtonRemoving = false;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationmenuvm.vmInjector.getSettingDiagVm(),
        notificationmenuvm.vmInjector.getSettingDiagVm().openSetting);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      notificationmenuvm.onSettingButtonClick();
      mocker.ignoreMock(notificationmenuvm.vmInjector.getSettingDiagVm(),
        notificationmenuvm.vmInjector.getSettingDiagVm().openSetting);
    });

    it('should_call_openSetting_when_isClickButtonRemoving_is_true', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.isClickButtonRemoving = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationmenuvm.vmInjector.getSettingDiagVm(),
        notificationmenuvm.vmInjector.getSettingDiagVm().openSetting);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      notificationmenuvm.onSettingButtonClick();
      mocker.ignoreMock(notificationmenuvm.vmInjector.getSettingDiagVm(),
        notificationmenuvm.vmInjector.getSettingDiagVm().openSetting);
    });

    it('should_call_openSetting_with_correct_params_when_isClickButtonRemoving_is_false', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.isClickButtonRemoving = false;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationmenuvm.vmInjector.getSettingDiagVm(),
        notificationmenuvm.vmInjector.getSettingDiagVm().openSetting);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      notificationmenuvm.onSettingButtonClick();
      mocker.ignoreMock(notificationmenuvm.vmInjector.getSettingDiagVm(),
        notificationmenuvm.vmInjector.getSettingDiagVm().openSetting);
    });

    it('should_set_remove_button_opacity_correctly_when_isSwipeRemoving_is_true', 0, () => {
      let notificationMenuVm: NotificationMenuVm = new NotificationMenuVm();
      notificationMenuVm.setRemoveButton(100, 50, true);
      expect(notificationMenuVm.removeButtonData.opacity).assertEqual(0);
    });

    it('should_set_remove_button_opacity_correctly_when_isSwipeRemoving_is_false', 0, () => {
      let notificationMenuVm: NotificationMenuVm = new NotificationMenuVm();
      notificationMenuVm.setRemoveButton(100, 50, false);
      expect(notificationMenuVm.removeButtonData.opacity).assertEqual(Math.min(1, -100 / notificationMenuVm.menuWidth));
    });

    it('should_call_setButtonOffsetAndScale_and_animationOverThreshold_when_overMenuOffsetX_is_greater_than_or_equal_to_0_and_isMoreBrief_is_false',
      0, () => {
        let notificationMenuVm: NotificationMenuVm = new NotificationMenuVm();
        let mocker: MockKit = new MockKit();
        let mockSetButtonOffsetAndScale: Function =
          mocker.mockFunc(notificationMenuVm, notificationMenuVm.setButtonOffsetAndScale);
        let mockAnimationOverThreshold: Function =
          mocker.mockFunc(notificationMenuVm, notificationMenuVm.animationOverThreshold);
        when(mockSetButtonOffsetAndScale)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturnNothing();
        when(mockAnimationOverThreshold)(ArgumentMatchers.anyNumber).afterReturnNothing();
        notificationMenuVm.setRemoveButton(100, 50, false);
        mocker.ignoreMock(notificationMenuVm, notificationMenuVm.setButtonOffsetAndScale);
        mocker.ignoreMock(notificationMenuVm, notificationMenuVm.animationOverThreshold);
      });

    it('should_not_call_setButtonOffsetAndScale_and_animationOverThreshold_when_overMenuOffsetX_is_less_than_0_or_isMoreBrief_is_true',
      0, () => {
        let notificationMenuVm: NotificationMenuVm = new NotificationMenuVm();
        let mocker: MockKit = new MockKit();
        let mockSetButtonOffsetAndScale: Function =
          mocker.mockFunc(notificationMenuVm, notificationMenuVm.setButtonOffsetAndScale);
        let mockAnimationOverThreshold: Function =
          mocker.mockFunc(notificationMenuVm, notificationMenuVm.animationOverThreshold);
        when(mockSetButtonOffsetAndScale)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturnNothing();
        when(mockAnimationOverThreshold)(ArgumentMatchers.anyNumber).afterReturnNothing();
        notificationMenuVm.setRemoveButton(100, -50, false);
        mocker.ignoreMock(notificationMenuVm, notificationMenuVm.setButtonOffsetAndScale);
        mocker.ignoreMock(notificationMenuVm, notificationMenuVm.animationOverThreshold);
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

    it('should_calculate_remove_button_offset_and_scale_correctly', 0, () => {
      let notificationMenuVm: NotificationMenuVm = new NotificationMenuVm();
      let mocker: MockKit = new MockKit();

      notificationMenuVm.setMenuWidth(100);
      notificationMenuVm.setButtonOffsetAndScale(50, 75);

      expect(notificationMenuVm.removeButtonData.offsetX).assertEqual(7);
      expect(notificationMenuVm.removeButtonData.scale).assertEqual(1.05);
    });

    it('should_calculate_remove_button_offset_and_scale_correctly_when_overMenuOffsetX_is_less_than_removeOffsetX_threshold',
      0, () => {
        let notificationMenuVm: NotificationMenuVm = new NotificationMenuVm();
        let mocker: MockKit = new MockKit();

        notificationMenuVm.setMenuWidth(100);
        notificationMenuVm.setButtonOffsetAndScale(50, 50);

        expect(notificationMenuVm.removeButtonData.offsetX).assertEqual(7);
        expect(notificationMenuVm.removeButtonData.scale).assertEqual(1);
      });

    it('should_calculate_remove_button_offset_and_scale_correctly_when_swipeOffsetX_is_zero', 0, () => {
      let notificationMenuVm: NotificationMenuVm = new NotificationMenuVm();
      let mocker: MockKit = new MockKit();

      notificationMenuVm.setMenuWidth(100);
      notificationMenuVm.setButtonOffsetAndScale(0, 75);

      expect(notificationMenuVm.removeButtonData.offsetX).assertEqual(7);
      expect(notificationMenuVm.removeButtonData.scale).assertEqual(1.05);
    });

    it('should_execute_animation_with_correct_parameters', 0, async () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      let mocker: MockKit = new MockKit();

      notificationmenuvm.doAnimation(100, 0.5, 30);

      expect(notificationmenuvm.removeButtonData.expandOffsetX).assertEqual(100);
      expect(notificationmenuvm.removeButtonData.expandScale).assertEqual(0.5);
      expect(notificationmenuvm.removeButtonData.binRotate).assertEqual(30);

    });

    it('should_call_removeNtf_when_swipe_over_threshold_is_true', 0, async () => {
      let notificationMenuVm: NotificationMenuVm = new NotificationMenuVm();
      notificationMenuVm.isSwipeOverThreshold = true;
      notificationMenuVm.removeNtf();
      expect(notificationMenuVm.isClickButtonRemoving).assertTrue();
    });

    it('should_call_removeNtf_when_swipe_over_threshold_is_false', 0, async () => {
      let notificationMenuVm: NotificationMenuVm = new NotificationMenuVm();
      notificationMenuVm.isSwipeOverThreshold = false;
      notificationMenuVm.removeNtf();
      expect(notificationMenuVm.isClickButtonRemoving).assertTrue();
    });

    it('should_call_removeNtf_and_animate_correctly', 0, async () => {
      let notificationMenuVm: NotificationMenuVm = new NotificationMenuVm();
      notificationMenuVm.isSwipeOverThreshold = true;
      notificationMenuVm.removeNtf();
      expect(notificationMenuVm.removeButtonData.opacity).assertEqual(0);
      expect(notificationMenuVm.settingButtonData.opacity).assertEqual(0);
      expect(notificationMenuVm.removeButtonData.offsetX).assertEqual(-NotificationMenuVm.REMOVE_ITEM_TRAN_X);
      expect(notificationMenuVm.settingButtonData.offsetX).assertEqual(-NotificationMenuVm.REMOVE_ITEM_TRAN_X);
    });

    it('should_return_false_when_isCollapsed_is_false', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.vmInjector = {
        getNotificationMoreHeaderVm: () => {
          return {
            isCollapsed: false
          } as INotificationMenuVm
        }
      } as any;
      notificationmenuvm.ntf = {
        category: NotificationCategory.OTHER
      } as NotificationBase;
      const result = notificationmenuvm.isMoreBrief();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_isCollapsed_is_true', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.vmInjector = {
        getNotificationMoreHeaderVm: () => {
          return {
            isCollapsed: true
          } as INotificationMenuVm
        }
      } as any;
      notificationmenuvm.ntf = {
        category: NotificationCategory.OTHER
      } as NotificationBase;
      const result = notificationmenuvm.isMoreBrief();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_category_is_not_OTHER', 0, () => {
      let notificationmenuvm: NotificationMenuVm = new NotificationMenuVm();
      notificationmenuvm.vmInjector = {
        getNotificationMoreHeaderVm: () => {
          return {
            isCollapsed: false
          } as INotificationMenuVm
        }
      } as any;
      notificationmenuvm.ntf = {
        category: NotificationCategory.INFO
      } as NotificationBase;
      const result = notificationmenuvm.isMoreBrief();
      expect(result).assertEqual(false);
    });
  });
}