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

import { NotificationEntry } from '../../../../main/ets/model/NotificationEntry';
import { NotificationConfig } from '../../../../main/ets/common/NotificationConfig';
import curves from '@ohos.curves';
import {
  BannerDeformState,
  bannerMgr,
  DarkModeState,
  fontScaleManager,
  FontScaleState,
  NtfMultiLineContent,
  ObservedItem,
  OverlayIconStyle
} from '@ohos/systemuicommon';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import { NotificationActionView } from '../../../../main/ets/pages/common/NotificationActionView';
import { CommonData } from '@ohos/screenlockcommon';
import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { ResUtils } from '@ohos/windowscene';
import { ImmersiveAodStyle, immersiveKgMgr } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { AccessibilityAppName, NotificationType } from '@ohos/systemuicommon/Index';
import { notificationStyle } from '../../../../main/ets/vm/style/NotificationStyle';
import { SwingTrackVm } from '../../../../main/ets/model/SwingTrackVm';
import { hideBannerNtfContentObj } from '../../../../main/ets/model/HideBannerNtfContentObj';
import measure from '@ohos.measure';
import { NtfColorModeVM } from '../../../../main/ets/vm/NtfColorModeVM';
import { NtfTimeVM } from '../../../../main/ets/vm/NtfTimeVM';
import NtfMgr from '@ohos.notificationManager';
import { AppProtectedVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedVm';
import { LengthMetrics } from '@kit.ArkUI';
import { NotificationUtils } from '../../../../main/ets/common/NotificationUtils';
import { NtfSingleItemVM } from '../../../../main/ets/vm/NtfSingleItemVM';
import { ColorModeNCViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeNCViewData';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {  } from '../../../../main/ets/pages/phone/NotificationContentInTint';
export default function Test() {
  describe('isHiddenBannerContent_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_true_when_isHiddenBannerContent_is_true', 0, async () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.isHideContent = true;
      let config: NotificationConfig = new NotificationConfig();
      config.isNeedBannerInScreenLock = true;
      config.isShowBannerFromScreenLock = true;
      let mocker: MockKit = new MockKit();
      let mockIsHiddenBannerContent: Function = mocker.mockFunc(bannerMgr, bannerMgr.isHiddenBannerContent);
      when(mockIsHiddenBannerContent)(ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean).afterReturn(true);
      const result = isHiddenBannerContent(entry, config);
      expect(result).assertEqual(true);
      mocker.ignoreMock(bannerMgr, bannerMgr.isHiddenBannerContent);
    });

    it('should_return_false_when_isHiddenBannerContent_is_false_and_swingTrackVm_isShow_is_undefined', 0, async () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.isHideContent = false;
      let config: NotificationConfig = new NotificationConfig();
      config.isNeedBannerInScreenLock = false;
      config.isShowBannerFromScreenLock = false;
      let mocker: MockKit = new MockKit();
      let mockIsHiddenBannerContent: Function = mocker.mockFunc(bannerMgr, bannerMgr.isHiddenBannerContent);
      when(mockIsHiddenBannerContent)(ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean).afterReturn(false);
      let mockSwingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      let mockUnRegister: Function = mocker.mockFunc(mockSwingTrackVm, mockSwingTrackVm.unRegister);
      when(mockUnRegister)().afterReturnNothing();
      const result = isHiddenBannerContent(entry, config);
      expect(result).assertEqual(false);
      mocker.ignoreMock(bannerMgr, bannerMgr.isHiddenBannerContent);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(mockSwingTrackVm, mockSwingTrackVm.unRegister);
    });

    it('should_return_true_when_isHiddenBannerContent_is_false_and_hideBannerNtfContentObj_isUseSwing_is_true_and_swingTrackVm_isShow_is_false', 0, async () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.isHideContent = false;
      let config: NotificationConfig = new NotificationConfig();
      config.isNeedBannerInScreenLock = false;
      config.isShowBannerFromScreenLock = false;
      let mocker: MockKit = new MockKit();
      let mockIsHiddenBannerContent: Function = mocker.mockFunc(bannerMgr, bannerMgr.isHiddenBannerContent);
      when(mockIsHiddenBannerContent)(ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean).afterReturn(false);
      let mockSwingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      let mockUnRegister: Function = mocker.mockFunc(mockSwingTrackVm, mockSwingTrackVm.unRegister);
      when(mockUnRegister)().afterReturnNothing();
      let mockIsUseSwing: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.isUseSwing);
      when(mockIsUseSwing)().afterReturn(true);
      const result = isHiddenBannerContent(entry, config);
      expect(result).assertEqual(true);
      mocker.ignoreMock(bannerMgr, bannerMgr.isHiddenBannerContent);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(mockSwingTrackVm, mockSwingTrackVm.unRegister);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.isUseSwing);
    });

    it('should_return_false_when_all_conditions_are_false', 0, async () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.isHideContent = false;
      let config: NotificationConfig = new NotificationConfig();
      config.isNeedBannerInScreenLock = false;
      config.isShowBannerFromScreenLock = false;
      let mocker: MockKit = new MockKit();
      let mockIsHiddenBannerContent: Function = mocker.mockFunc(bannerMgr, bannerMgr.isHiddenBannerContent);
      when(mockIsHiddenBannerContent)(ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean).afterReturn(false);
      let mockSwingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      let mockUnRegister: Function = mocker.mockFunc(mockSwingTrackVm, mockSwingTrackVm.unRegister);
      when(mockUnRegister)().afterReturnNothing();
      let mockIsUseSwing: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.isUseSwing);
      when(mockIsUseSwing)().afterReturn(false);
      const result = isHiddenBannerContent(entry, config);
      expect(result).assertEqual(false);
      mocker.ignoreMock(bannerMgr, bannerMgr.isHiddenBannerContent);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(mockSwingTrackVm, mockSwingTrackVm.unRegister);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.isUseSwing);
    });

    it('should_return_true_when_isHiddenBannerContent_is_true', 0, async () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.isHideContent = true;
      let config: NotificationConfig = new NotificationConfig();
      config.isNeedBannerInScreenLock = true;
      config.isShowBannerFromScreenLock = true;
      let mocker: MockKit = new MockKit();
      let mockIsHiddenBannerContent: Function = mocker.mockFunc(bannerMgr, bannerMgr.isHiddenBannerContent);
      when(mockIsHiddenBannerContent)(ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean).afterReturn(true);
      const result = isHiddenBannerContent(entry, config);
      expect(result).assertEqual(true);
      mocker.ignoreMock(bannerMgr, bannerMgr.isHiddenBannerContent);
    });

    it('should_return_false_when_isHiddenBannerContent_is_false_and_swingTrackVm_isShow_is_undefined', 0, async () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.isHideContent = false;
      let config: NotificationConfig = new NotificationConfig();
      config.isNeedBannerInScreenLock = false;
      config.isShowBannerFromScreenLock = false;
      let mocker: MockKit = new MockKit();
      let mockIsHiddenBannerContent: Function = mocker.mockFunc(bannerMgr, bannerMgr.isHiddenBannerContent);
      when(mockIsHiddenBannerContent)(ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean).afterReturn(false);
      let mockSwingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      let mockUnRegister: Function = mocker.mockFunc(mockSwingTrackVm, mockSwingTrackVm.unRegister);
      when(mockUnRegister)().afterReturnNothing();
      const result = isHiddenBannerContent(entry, config);
      expect(result).assertEqual(false);
      mocker.ignoreMock(bannerMgr, bannerMgr.isHiddenBannerContent);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(mockSwingTrackVm, mockSwingTrackVm.unRegister);
    });

    it('should_return_true_when_isHiddenBannerContent_is_false_and_hideBannerNtfContentObj_isUseSwing_is_true_and_swingTrackVm_isShow_is_false', 0, async () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.isHideContent = false;
      let config: NotificationConfig = new NotificationConfig();
      config.isNeedBannerInScreenLock = false;
      config.isShowBannerFromScreenLock = false;
      let mocker: MockKit = new MockKit();
      let mockIsHiddenBannerContent: Function = mocker.mockFunc(bannerMgr, bannerMgr.isHiddenBannerContent);
      when(mockIsHiddenBannerContent)(ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean).afterReturn(false);
      let mockSwingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      let mockUnRegister: Function = mocker.mockFunc(mockSwingTrackVm, mockSwingTrackVm.unRegister);
      when(mockUnRegister)().afterReturnNothing();
      let mockIsUseSwing: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.isUseSwing);
      when(mockIsUseSwing)().afterReturn(true);
      const result = isHiddenBannerContent(entry, config);
      expect(result).assertEqual(true);
      mocker.ignoreMock(bannerMgr, bannerMgr.isHiddenBannerContent);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(mockSwingTrackVm, mockSwingTrackVm.unRegister);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.isUseSwing);
    });

    it('should_return_false_when_all_conditions_are_false', 0, async () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.isHideContent = false;
      let config: NotificationConfig = new NotificationConfig();
      config.isNeedBannerInScreenLock = false;
      config.isShowBannerFromScreenLock = false;
      let mocker: MockKit = new MockKit();
      let mockIsHiddenBannerContent: Function = mocker.mockFunc(bannerMgr, bannerMgr.isHiddenBannerContent);
      when(mockIsHiddenBannerContent)(ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean).afterReturn(false);
      let mockSwingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      let mockUnRegister: Function = mocker.mockFunc(mockSwingTrackVm, mockSwingTrackVm.unRegister);
      when(mockUnRegister)().afterReturnNothing();
      let mockIsUseSwing: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.isUseSwing);
      when(mockIsUseSwing)().afterReturn(false);
      const result = isHiddenBannerContent(entry, config);
      expect(result).assertEqual(false);
      mocker.ignoreMock(bannerMgr, bannerMgr.isHiddenBannerContent);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(mockSwingTrackVm, mockSwingTrackVm.unRegister);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.isUseSwing);
    });

    it('should_return_true_when_isHiddenBannerContent_is_true', 0, async () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.isHideContent = true;
      let config: NotificationConfig = new NotificationConfig();
      config.isNeedBannerInScreenLock = true;
      config.isShowBannerFromScreenLock = true;
      let mocker: MockKit = new MockKit();
      let mockIsHiddenBannerContent: Function = mocker.mockFunc(bannerMgr, bannerMgr.isHiddenBannerContent);
      when(mockIsHiddenBannerContent)(ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean).afterReturn(true);
      const result = isHiddenBannerContent(entry, config);
      expect(result).assertEqual(true);
      mocker.ignoreMock(bannerMgr, bannerMgr.isHiddenBannerContent);
    });

    it('should_return_false_when_isHiddenBannerContent_is_false_and_swingTrackVm_isShow_is_undefined', 0, async () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.isHideContent = false;
      let config: NotificationConfig = new NotificationConfig();
      config.isNeedBannerInScreenLock = false;
      config.isShowBannerFromScreenLock = false;
      let mocker: MockKit = new MockKit();
      let mockIsHiddenBannerContent: Function = mocker.mockFunc(bannerMgr, bannerMgr.isHiddenBannerContent);
      when(mockIsHiddenBannerContent)(ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean).afterReturn(false);
      let mockSwingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      let mockUnRegister: Function = mocker.mockFunc(mockSwingTrackVm, mockSwingTrackVm.unRegister);
      when(mockUnRegister)().afterReturnNothing();
      const result = isHiddenBannerContent(entry, config);
      expect(result).assertEqual(false);
      mocker.ignoreMock(bannerMgr, bannerMgr.isHiddenBannerContent);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(mockSwingTrackVm, mockSwingTrackVm.unRegister);
    });

    it('should_return_true_when_isHiddenBannerContent_is_false_and_hideBannerNtfContentObj_isUseSwing_is_true_and_swingTrackVm_isShow_is_false', 0, async () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.isHideContent = false;
      let config: NotificationConfig = new NotificationConfig();
      config.isNeedBannerInScreenLock = false;
      config.isShowBannerFromScreenLock = false;
      let mocker: MockKit = new MockKit();
      let mockIsHiddenBannerContent: Function = mocker.mockFunc(bannerMgr, bannerMgr.isHiddenBannerContent);
      when(mockIsHiddenBannerContent)(ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean).afterReturn(false);
      let mockSwingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      let mockUnRegister: Function = mocker.mockFunc(mockSwingTrackVm, mockSwingTrackVm.unRegister);
      when(mockUnRegister)().afterReturnNothing();
      let mockIsUseSwing: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.isUseSwing);
      when(mockIsUseSwing)().afterReturn(true);
      const result = isHiddenBannerContent(entry, config);
      expect(result).assertEqual(true);
      mocker.ignoreMock(bannerMgr, bannerMgr.isHiddenBannerContent);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(mockSwingTrackVm, mockSwingTrackVm.unRegister);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.isUseSwing);
    });

    it('should_return_false_when_all_conditions_are_false', 0, async () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.isHideContent = false;
      let config: NotificationConfig = new NotificationConfig();
      config.isNeedBannerInScreenLock = false;
      config.isShowBannerFromScreenLock = false;
      let mocker: MockKit = new MockKit();
      let mockIsHiddenBannerContent: Function = mocker.mockFunc(bannerMgr, bannerMgr.isHiddenBannerContent);
      when(mockIsHiddenBannerContent)(ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean).afterReturn(false);
      let mockSwingTrackVm: SwingTrackVm = new SwingTrackVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      let mockUnRegister: Function = mocker.mockFunc(mockSwingTrackVm, mockSwingTrackVm.unRegister);
      when(mockUnRegister)().afterReturnNothing();
      let mockIsUseSwing: Function = mocker.mockFunc(hideBannerNtfContentObj, hideBannerNtfContentObj.isUseSwing);
      when(mockIsUseSwing)().afterReturn(false);
      const result = isHiddenBannerContent(entry, config);
      expect(result).assertEqual(false);
      mocker.ignoreMock(bannerMgr, bannerMgr.isHiddenBannerContent);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(mockSwingTrackVm, mockSwingTrackVm.unRegister);
      mocker.ignoreMock(hideBannerNtfContentObj, hideBannerNtfContentObj.isUseSwing);
    });

    it('should_return_true_when_actionButtons_is_not_empty', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.actionButtons = [new ObservedItem('test')];
      entry.contentType = NtfMgr.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT;
      let vm: NtfSingleItemVM = new NtfSingleItemVM(entry);
      expect(vm.checkOverMaxLine()).assertTrue();
    });

    it('should_return_true_when_contentType_is_not_NOTIFICATION_CONTENT_BASIC_TEXT', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.actionButtons = [];
      entry.contentType = NtfMgr.ContentType.NOTIFICATION_CONTENT_UNKNOWN;
      let vm: NtfSingleItemVM = new NtfSingleItemVM(entry);
      expect(vm.checkOverMaxLine()).assertTrue();
    });

    it('should_return_false_when_title_height_equals_content_height', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.actionButtons = [];
      entry.contentType = NtfMgr.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ResUtils, ResUtils.getNumber);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(100);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(100);
      let vm: NtfSingleItemVM = new NtfSingleItemVM(entry);
      expect(vm.checkOverMaxLine()).assertFalse();
      mocker.ignoreMock(ResUtils, ResUtils.getNumber);
    });

    it('should_return_true_when_title_height_not_equals_content_height', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.actionButtons = [];
      entry.contentType = NtfMgr.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ResUtils, ResUtils.getNumber);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(100);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(200);
      let vm: NtfSingleItemVM = new NtfSingleItemVM(entry);
      expect(vm.checkOverMaxLine()).assertTrue();
      mocker.ignoreMock(ResUtils, ResUtils.getNumber);
    });

    it('should_return_true_when_actionButtons_is_not_empty', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.actionButtons = [new ObservedItem('test')];
      entry.contentType = NtfMgr.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT;
      let vm: NtfSingleItemVM = new NtfSingleItemVM(entry);
      expect(vm.checkOverMaxLine()).assertTrue();
    });

    it('should_return_true_when_contentType_is_not_NOTIFICATION_CONTENT_BASIC_TEXT', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.actionButtons = [];
      entry.contentType = NtfMgr.ContentType.NOTIFICATION_CONTENT_UNKNOWN;
      let vm: NtfSingleItemVM = new NtfSingleItemVM(entry);
      expect(vm.checkOverMaxLine()).assertTrue();
    });

    it('should_return_false_when_title_height_equals_content_height', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.actionButtons = [];
      entry.contentType = NtfMgr.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ResUtils, ResUtils.getNumber);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(100);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(100);
      let vm: NtfSingleItemVM = new NtfSingleItemVM(entry);
      expect(vm.checkOverMaxLine()).assertFalse();
      mocker.ignoreMock(ResUtils, ResUtils.getNumber);
    });

    it('should_return_true_when_title_height_not_equals_content_height', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.actionButtons = [];
      entry.contentType = NtfMgr.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ResUtils, ResUtils.getNumber);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(100);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(200);
      let vm: NtfSingleItemVM = new NtfSingleItemVM(entry);
      expect(vm.checkOverMaxLine()).assertTrue();
      mocker.ignoreMock(ResUtils, ResUtils.getNumber);
    });
    it('should_return_true_when_actionButtons_is_not_empty', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.actionButtons = [new ObservedItem('test')];
      entry.contentType = NtfMgr.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT;
      let vm: NtfSingleItemVM = new NtfSingleItemVM(entry);
      expect(vm.checkOverMaxLine()).assertTrue();
    });

    it('should_return_true_when_contentType_is_not_NOTIFICATION_CONTENT_BASIC_TEXT', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.actionButtons = [];
      entry.contentType = NtfMgr.ContentType.NOTIFICATION_CONTENT_UNKNOWN;
      let vm: NtfSingleItemVM = new NtfSingleItemVM(entry);
      expect(vm.checkOverMaxLine()).assertTrue();
    });

    it('should_return_false_when_title_height_equals_content_height', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.actionButtons = [];
      entry.contentType = NtfMgr.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ResUtils, ResUtils.getNumber);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(100);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(100);
      let vm: NtfSingleItemVM = new NtfSingleItemVM(entry);
      expect(vm.checkOverMaxLine()).assertFalse();
      mocker.ignoreMock(ResUtils, ResUtils.getNumber);
    });

    it('should_return_true_when_title_height_not_equals_content_height', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.actionButtons = [];
      entry.contentType = NtfMgr.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ResUtils, ResUtils.getNumber);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(100);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(200);
      let vm: NtfSingleItemVM = new NtfSingleItemVM(entry);
      expect(vm.checkOverMaxLine()).assertTrue();
      mocker.ignoreMock(ResUtils, ResUtils.getNumber);
    });
    it('should_return_undefined_when_isExpand_is_true', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.notificationConfig = new NotificationConfig();
      entry.notificationConfig.isExpand = true;
      const result = NotificationContentInTint.getTitleLength(entry, 'title');
      expect(result).assertEqual(undefined);
    });

    it('should_return_titleLength_when_titleLength_is_less_than_excludeContent', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.notificationConfig = new NotificationConfig();
      entry.notificationConfig.isExpand = false;
      const result = NotificationContentInTint.getTitleLength(entry, 'title');
      expect(result).assertEqual(100);
    });

    it('should_return_titleAndContentLength_when_titleLength_is_greater_than_excludeContent', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.notificationConfig = new NotificationConfig();
      entry.notificationConfig.isExpand = false;
      const result = NotificationContentInTint.getTitleLength(entry, 'title');
      expect(result).assertEqual(200);
    });
    it('should_return_undefined_when_isExpand_is_true', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.notificationConfig = new NotificationConfig();
      entry.notificationConfig.isExpand = true;
      const result = NotificationContentInTint.getTitleLength(entry, 'title');
      expect(result).assertEqual(undefined);
    });

    it('should_return_titleLength_when_titleLength_is_less_than_excludeContent', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.notificationConfig = new NotificationConfig();
      entry.notificationConfig.isExpand = false;
      const result = NotificationContentInTint.getTitleLength(entry, 'title');
      expect(result).assertEqual(100);
    });

    it('should_return_titleAndContentLength_when_titleLength_is_greater_than_excludeContent', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.notificationConfig = new NotificationConfig();
      entry.notificationConfig.isExpand = false;
      const result = NotificationContentInTint.getTitleLength(entry, 'title');
      expect(result).assertEqual(200);
    });

    it('should_return_undefined_when_isExpand_is_true', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.notificationConfig = new NotificationConfig();
      entry.notificationConfig.isExpand = true;
      const result = NotificationContentInTint.getTitleLength(entry, 'title');
      expect(result).assertEqual(undefined);
    });

    it('should_return_titleLength_when_titleLength_is_less_than_excludeContent', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.notificationConfig = new NotificationConfig();
      entry.notificationConfig.isExpand = false;
      const result = NotificationContentInTint.getTitleLength(entry, 'title');
      expect(result).assertEqual(100);
    });

    it('should_return_titleAndContentLength_when_titleLength_is_greater_than_excludeContent', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.notificationConfig = new NotificationConfig();
      entry.notificationConfig.isExpand = false;
      const result = NotificationContentInTint.getTitleLength(entry, 'title');
      expect(result).assertEqual(200);
    });
  });
}
