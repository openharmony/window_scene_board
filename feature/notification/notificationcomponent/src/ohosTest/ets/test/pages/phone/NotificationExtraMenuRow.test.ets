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


import { CommonUtils, LogDomain, LogHelper, Log } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { NtfMgr } from '../../../../main/ets/model/NotificationManager';
import { NotificationEntry } from '../../../../main/ets/model/NotificationEntry';
import { NtfItemSwipeController } from '../../../../main/ets/controller/NtfItemSwipeController';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import { NotificationAccessibilityUtil } from '../../../../main/ets/common/NotificationAccessibilityUtil';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {  } from '../../../../main/ets/pages/phone/NotificationExtraMenuRow';
export default function Test() {
  describe('onUpdateItemTranX_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_menuWidth_is_invalid', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      ntfItemSwipeController.onUpdateItemTranX(10, false);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_return_immediately_when_menuWidth_is_zero', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      ntfItemSwipeController.onUpdateItemTranX(10, false);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_return_immediately_when_tranX_is_positive', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      ntfItemSwipeController.onUpdateItemTranX(10, false);
    });

    it('should_return_immediately_when_isRemoveEntry_is_true', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      ntfItemSwipeController.onUpdateItemTranX(10, true);
    });

    it('should_execute_correct_logic_when_posTranX_is_greater_than_menuWidth', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      ntfItemSwipeController.menuWidth = 50;
      ntfItemSwipeController.onUpdateItemTranX(60, false);
      expect(ntfItemSwipeController.dropTransX).assertEqual(10);
      expect(ntfItemSwipeController.isCoverOpen).assertEqual(true);
      expect(ntfItemSwipeController.isButtonDeleteOpen).assertEqual(true);
      expect(ntfItemSwipeController.isButtonBinOpen).assertEqual(true);
      expect(ntfItemSwipeController.isDeleteButtonScaleOpen).assertEqual(true);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_return_immediately_when_menuWidth_is_invalid', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      ntfItemSwipeController.onUpdateItemTranX(10, false);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_return_immediately_when_menuWidth_is_zero', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      ntfItemSwipeController.onUpdateItemTranX(10, false);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_return_immediately_when_tranX_is_positive', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      ntfItemSwipeController.onUpdateItemTranX(10, false);
    });

    it('should_return_immediately_when_isRemoveEntry_is_true', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      ntfItemSwipeController.onUpdateItemTranX(10, true);
    });

    it('should_execute_correct_logic_when_posTranX_is_greater_than_menuWidth', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      ntfItemSwipeController.menuWidth = 50;
      ntfItemSwipeController.onUpdateItemTranX(60, false);
      expect(ntfItemSwipeController.dropTransX).assertEqual(10);
      expect(ntfItemSwipeController.isCoverOpen).assertEqual(true);
      expect(ntfItemSwipeController.isButtonDeleteOpen).assertEqual(true);
      expect(ntfItemSwipeController.isButtonBinOpen).assertEqual(true);
      expect(ntfItemSwipeController.isDeleteButtonScaleOpen).assertEqual(true);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_return_immediately_when_menuWidth_is_invalid', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      ntfItemSwipeController.onUpdateItemTranX(10, false);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_return_immediately_when_menuWidth_is_zero', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      ntfItemSwipeController.onUpdateItemTranX(10, false);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_return_immediately_when_tranX_is_positive', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      ntfItemSwipeController.onUpdateItemTranX(10, false);
    });

    it('should_return_immediately_when_isRemoveEntry_is_true', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      ntfItemSwipeController.onUpdateItemTranX(10, true);
    });

    it('should_execute_correct_logic_when_posTranX_is_greater_than_menuWidth', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      ntfItemSwipeController.menuWidth = 50;
      ntfItemSwipeController.onUpdateItemTranX(60, false);
      expect(ntfItemSwipeController.dropTransX).assertEqual(10);
      expect(ntfItemSwipeController.isCoverOpen).assertEqual(true);
      expect(ntfItemSwipeController.isButtonDeleteOpen).assertEqual(true);
      expect(ntfItemSwipeController.isButtonBinOpen).assertEqual(true);
      expect(ntfItemSwipeController.isDeleteButtonScaleOpen).assertEqual(true);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });


    it('should_set_del_scale_button_correctly_when_hasAnim_is_false', 0, () => {
      let obj: any = new NtfItemSwipeController();
      obj.dropTransX = 0.5;
      obj.binDelTransXThreshold = 0.3;
      obj.DEL_BTN_FIRST_GEAR_SCALE_RATIO = 0.2;
      obj.setDelButtonScale(false);
      expect(obj.delScaleButton).assertEqual(1 + (0.5 / 0.3) * 0.2);
    });

    it('should_set_del_scale_button_correctly_when_hasAnim_is_true_and_menuAlphaAnim_is_undefined', 0, () => {
      let obj: any = new NtfItemSwipeController();
      obj.dropTransX = 0.5;
      obj.binDelTransXThreshold = 0.3;
      obj.DEL_BTN_FIRST_GEAR_SCALE_RATIO = 0.2;
      obj.menuAlphaAnim = undefined;
      obj.setDelButtonScale(true);
      expect(obj.delScaleButton).assertEqual(1 + (0.5 / 0.3) * 0.2);
    });

    it('should_call_animateTo_when_hasAnim_is_true_and_menuAlphaAnim_is_defined', 0, () => {
      let obj: any = new NtfItemSwipeController();
      obj.dropTransX = 0.5;
      obj.binDelTransXThreshold = 0.3;
      obj.DEL_BTN_FIRST_GEAR_SCALE_RATIO = 0.2;
      obj.menuAlphaAnim = {
        animateTo: (duration: number, callback: Function) => {
          callback();
        }
      };
      let mocker: MockKit = new MockKit();
      obj.setDelButtonScale(true);
      expect(obj.delScaleButton).assertEqual(1 + (0.5 / 0.3) * 0.2);
    });

    it('should_set_del_scale_button_correctly_when_hasAnim_is_false', 0, () => {
      let obj: any = new NtfItemSwipeController();
      obj.dropTransX = 0.5;
      obj.binDelTransXThreshold = 0.3;
      obj.DEL_BTN_FIRST_GEAR_SCALE_RATIO = 0.2;
      obj.setDelButtonScale(false);
      expect(obj.delScaleButton).assertEqual(1 + (0.5 / 0.3) * 0.2);
    });

    it('should_set_del_scale_button_correctly_when_hasAnim_is_true_and_menuAlphaAnim_is_undefined', 0, () => {
      let obj: any = new NtfItemSwipeController();
      obj.dropTransX = 0.5;
      obj.binDelTransXThreshold = 0.3;
      obj.DEL_BTN_FIRST_GEAR_SCALE_RATIO = 0.2;
      obj.menuAlphaAnim = undefined;
      obj.setDelButtonScale(true);
      expect(obj.delScaleButton).assertEqual(1 + (0.5 / 0.3) * 0.2);
    });

    it('should_call_animateTo_when_hasAnim_is_true_and_menuAlphaAnim_is_defined', 0, () => {
      let obj: any = new NtfItemSwipeController();
      obj.dropTransX = 0.5;
      obj.binDelTransXThreshold = 0.3;
      obj.DEL_BTN_FIRST_GEAR_SCALE_RATIO = 0.2;
      obj.menuAlphaAnim = {
        animateTo: (duration: number, callback: Function) => {
          callback();
        }
      };
      let mocker: MockKit = new MockKit();
      obj.setDelButtonScale(true);
      expect(obj.delScaleButton).assertEqual(1 + (0.5 / 0.3) * 0.2);
    });

    it('should_return_empty_string_when_isAccessibilityMode_is_false', 0, () => {
      let menuName: MenuName = MenuName.MenuDelete;
      let util = new NotificationAccessibilityUtil();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(util, util.getAccessibilitySettingText);
      when(mockfunc)(ArgumentMatchers.any).afterReturn('');
      const result = util.getAccessibilitySettingText(menuName);
      expect(result).assertEqual('');
      mocker.ignoreMock(util, util.getAccessibilitySettingText);
    });

    it('should_return_text_when_menuName_is_MenuDelete', 0, () => {
      let menuName: MenuName = MenuName.MenuDelete;
      let util = new NotificationAccessibilityUtil();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ResUtils, ResUtils.getInnerString);
      when(mockfunc)(ArgumentMatchers.any).afterReturn('delete');
      const result = util.getAccessibilitySettingText(menuName);
      expect(result).assertEqual('delete');
      mocker.ignoreMock(ResUtils, ResUtils.getInnerString);
    });

    it('should_return_empty_string_when_menuName_is_not_MenuDelete', 0, () => {
      let menuName: MenuName = MenuName.MenuSettings;
      let util = new NotificationAccessibilityUtil();
      const result = util.getAccessibilitySettingText(menuName);
      expect(result).assertEqual('');
    });

    it('should_return_empty_string_when_isAccessibilityMode_is_false', 0, () => {
      let menuName: MenuName = MenuName.MenuDelete;
      let util = new NotificationAccessibilityUtil();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(util, util.getAccessibilitySettingText);
      when(mockfunc)(ArgumentMatchers.any).afterReturn('');
      const result = util.getAccessibilitySettingText(menuName);
      expect(result).assertEqual('');
      mocker.ignoreMock(util, util.getAccessibilitySettingText);
    });

    it('should_return_text_when_menuName_is_MenuDelete', 0, () => {
      let menuName: MenuName = MenuName.MenuDelete;
      let util = new NotificationAccessibilityUtil();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ResUtils, ResUtils.getInnerString);
      when(mockfunc)(ArgumentMatchers.any).afterReturn('delete');
      const result = util.getAccessibilitySettingText(menuName);
      expect(result).assertEqual('delete');
      mocker.ignoreMock(ResUtils, ResUtils.getInnerString);
    });

    it('should_return_empty_string_when_menuName_is_not_MenuDelete', 0, () => {
      let menuName: MenuName = MenuName.MenuSettings;
      let util = new NotificationAccessibilityUtil();
      const result = util.getAccessibilitySettingText(menuName);
      expect(result).assertEqual('');
    });

    it('should_return_empty_string_when_isAccessibilityMode_is_false', 0, () => {
      let menuName: MenuName = MenuName.MenuDelete;
      let util = new NotificationAccessibilityUtil();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(util, util.getAccessibilitySettingText);
      when(mockfunc)(ArgumentMatchers.any).afterReturn('');
      const result = util.getAccessibilitySettingText(menuName);
      expect(result).assertEqual('');
      mocker.ignoreMock(util, util.getAccessibilitySettingText);
    });

    it('should_return_text_when_menuName_is_MenuDelete', 0, () => {
      let menuName: MenuName = MenuName.MenuDelete;
      let util = new NotificationAccessibilityUtil();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ResUtils, ResUtils.getInnerString);
      when(mockfunc)(ArgumentMatchers.any).afterReturn('delete');
      const result = util.getAccessibilitySettingText(menuName);
      expect(result).assertEqual('delete');
      mocker.ignoreMock(ResUtils, ResUtils.getInnerString);
    });

    it('should_return_empty_string_when_menuName_is_not_MenuDelete', 0, () => {
      let menuName: MenuName = MenuName.MenuSettings;
      let util = new NotificationAccessibilityUtil();
      const result = util.getAccessibilitySettingText(menuName);
      expect(result).assertEqual('');
    });

    it('should_not_call_batchRemoveNtf_when_deleteList_is_empty', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfMgr, NtfMgr.batchRemoveNtf);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.isGroup = true;
      ntfEntry.childrenEntry = [];

      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      ntfItemSwipeController.extraNtfList = [ntfEntry];
      ntfItemSwipeController.canDel(ntfEntry);

      ntfItemSwipeController.groupBriefDel();

      mocker.ignoreMock(NtfMgr, NtfMgr.batchRemoveNtf);
    });

    it('should_call_batchRemoveNtf_when_deleteList_is_not_empty', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfMgr, NtfMgr.batchRemoveNtf);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.isGroup = true;
      ntfEntry.childrenEntry = [new NotificationEntry()];

      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      ntfItemSwipeController.extraNtfList = [ntfEntry];
      ntfItemSwipeController.canDel(ntfEntry);

      ntfItemSwipeController.groupBriefDel();

      mocker.ignoreMock(NtfMgr, NtfMgr.batchRemoveNtf);
    });

    it('should_not_call_batchRemoveNtf_when_deleteList_is_empty', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfMgr, NtfMgr.batchRemoveNtf);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.isGroup = true;
      ntfEntry.childrenEntry = [];

      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      ntfItemSwipeController.extraNtfList = [ntfEntry];
      ntfItemSwipeController.canDel(ntfEntry);

      ntfItemSwipeController.groupBriefDel();

      mocker.ignoreMock(NtfMgr, NtfMgr.batchRemoveNtf);
    });

    it('should_return_empty_string_when_menuName_is_not_MenuDelete', 0, () => {
      let menuName: MenuName = MenuName.MenuSettings;
      let util = new NotificationAccessibilityUtil();
      const result = util.getAccessibilitySettingText(menuName);
      expect(result).assertEqual('');
    });

    it('should_call_batchRemoveNtf_when_deleteList_is_not_empty', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfMgr, NtfMgr.batchRemoveNtf);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.isGroup = true;
      ntfEntry.childrenEntry = [new NotificationEntry()];

      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      ntfItemSwipeController.extraNtfList = [ntfEntry];
      ntfItemSwipeController.canDel(ntfEntry);

      ntfItemSwipeController.groupBriefDel();

      mocker.ignoreMock(NtfMgr, NtfMgr.batchRemoveNtf);
    });

    it('should_not_call_batchRemoveNtf_when_deleteList_is_empty', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfMgr, NtfMgr.batchRemoveNtf);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.isGroup = true;
      ntfEntry.childrenEntry = [];

      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      ntfItemSwipeController.extraNtfList = [ntfEntry];
      ntfItemSwipeController.canDel(ntfEntry);

      ntfItemSwipeController.groupBriefDel();

      mocker.ignoreMock(NtfMgr, NtfMgr.batchRemoveNtf);
    });

    it('should_call_batchRemoveNtf_when_deleteList_is_not_empty', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NtfMgr, NtfMgr.batchRemoveNtf);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.isGroup = true;
      ntfEntry.childrenEntry = [new NotificationEntry()];

      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      ntfItemSwipeController.extraNtfList = [ntfEntry];
      ntfItemSwipeController.canDel(ntfEntry);

      ntfItemSwipeController.groupBriefDel();

      mocker.ignoreMock(NtfMgr, NtfMgr.batchRemoveNtf);
    });

    it('should_calculate_transX_correctly', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ResUtils, ResUtils.getNumberFromLength);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(100);

      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      ntfItemSwipeController.delScaleButton = 1;
      ntfItemSwipeController.menuWidth = 200;
      ntfItemSwipeController.binDelTransXThreshold = 50;
      ntfItemSwipeController.buttonDelTransX = 30;
      ntfItemSwipeController.delScaleButtonGear2 = 0.5;
      ntfItemSwipeController.dropTransXBeyond();

      expect(ntfItemSwipeController.buttonDelExpandTransX).assertEqual(-20);
      mocker.ignoreMock(ResUtils, ResUtils.getNumberFromLength);
    });

    it('should_calculate_transX_correctly_with_different_values', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ResUtils, ResUtils.getNumberFromLength);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(200);

      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      ntfItemSwipeController.delScaleButton = 2;
      ntfItemSwipeController.menuWidth = 300;
      ntfItemSwipeController.binDelTransXThreshold = 60;
      ntfItemSwipeController.buttonDelTransX = 40;
      ntfItemSwipeController.delScaleButtonGear2 = 0.3;
      ntfItemSwipeController.dropTransXBeyond();

      expect(ntfItemSwipeController.buttonDelExpandTransX).assertEqual(-25);
      mocker.ignoreMock(ResUtils, ResUtils.getNumberFromLength);
    });

    it('should_calculate_transX_correctly', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ResUtils, ResUtils.getNumberFromLength);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(100);

      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      ntfItemSwipeController.delScaleButton = 1;
      ntfItemSwipeController.menuWidth = 200;
      ntfItemSwipeController.binDelTransXThreshold = 50;
      ntfItemSwipeController.buttonDelTransX = 30;
      ntfItemSwipeController.delScaleButtonGear2 = 0.5;
      ntfItemSwipeController.dropTransXBeyond();

      expect(ntfItemSwipeController.buttonDelExpandTransX).assertEqual(-20);
      mocker.ignoreMock(ResUtils, ResUtils.getNumberFromLength);
    });

    it('should_calculate_transX_correctly_with_different_values', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ResUtils, ResUtils.getNumberFromLength);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(200);

      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      ntfItemSwipeController.delScaleButton = 2;
      ntfItemSwipeController.menuWidth = 300;
      ntfItemSwipeController.binDelTransXThreshold = 60;
      ntfItemSwipeController.buttonDelTransX = 40;
      ntfItemSwipeController.delScaleButtonGear2 = 0.3;
      ntfItemSwipeController.dropTransXBeyond();

      expect(ntfItemSwipeController.buttonDelExpandTransX).assertEqual(-25);
      mocker.ignoreMock(ResUtils, ResUtils.getNumberFromLength);
    });

  });
}