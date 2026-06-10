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

import { ConfigurationConstant } from '@kit.AbilityKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { VisualEffectConstants } from '@ohos/commonconstants';
import { SCBVisualEffectMgr } from '@ohos/componenthelper';
import { ConfigurationEvent, EventManager, EvtBus, GlobalContext } from '@ohos/frameworkwrapper';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import { NotificationConfig } from '../../../main/ets/common/NotificationConfig';
import {
  BrightnessEffectChangeCallback,
  NtfThemeActiveMgr
} from '../../../main/ets/common/NotificationThemeActiveManager';
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
import { NtfColorModeVM } from '../../../main/ets/vm/NtfColorModeVM';

export default function NtfColorModeVMTest() {
  describe('deinit_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_unregister_brightness_effect_change_callback_when_onThemeChange_is_undefined', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();
      let eventMgr: EventManager = EventManager.createEventManager();
      let mockfunc: Function = mocker.mockFunc(eventMgr, eventMgr.offAll);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      ntfcolormodevm.eventMgr = eventMgr;
      ntfcolormodevm.onThemeChange = undefined;
      ntfcolormodevm.deinit();
      mocker.verify('offAll', []).once();
      mocker.ignoreMock(eventMgr, eventMgr.offAll);
    });

    it('should_not_unregister_brightness_effect_change_callback_when_onThemeChange_is_defined', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();
      let eventMgr: EventManager = EventManager.createEventManager();
      let mockfunc: Function = mocker.mockFunc(eventMgr, eventMgr.offAll);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      ntfcolormodevm.eventMgr = eventMgr;
      let onThemeChange: () => void = () => {
      };
      ntfcolormodevm.onThemeChange = onThemeChange;
      ntfcolormodevm.deinit();
      mocker.verify('offAll', []).once();
      mocker.ignoreMock(eventMgr, eventMgr.offAll);
    });

    it('should_update_theme_color_correctly_when_brightness_is_enabled', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      ntfcolormodevm.isBrightnessEffect = true;
      ntfcolormodevm.isNtfBrightnessDisable = false;
      ntfcolormodevm.updateThemeColor();

      expect(ntfcolormodevm.themeFontForegroundBrightnessOptions)
        .assertEqual(ntfcolormodevm.fontForegroundBrightnessOptions);
      expect(ntfcolormodevm.themeTimestampForegroundBrightnessOptions)
        .assertEqual(ntfcolormodevm.timestampForegroundBrightnessOptions);
      expect(ntfcolormodevm.themeBgBrightnessOption).assertEqual(ntfcolormodevm.bgBrightnessOption);
      expect(ntfcolormodevm.themeAllClearButtonBgOptions).assertEqual(ntfcolormodevm.allClearButtonBgOptions);
      expect(ntfcolormodevm.themeExtraHeaderButtonBgOptions).assertEqual(ntfcolormodevm.extraHeaderButtonBgOptions);
      expect(ntfcolormodevm.themeHeaderContentButtonBgOptions).assertEqual(ntfcolormodevm.headerContentBgOptions);
      expect(ntfcolormodevm.themeBannerBgOptions).assertEqual(ntfcolormodevm.bannerCardOption);
      expect(ntfcolormodevm.themeFontForegroundColor).assertEqual(ntfcolormodevm.bgColor);
      expect(ntfcolormodevm.themeTimestampForegroundColor).assertEqual(ntfcolormodevm.bgColor);
      expect(ntfcolormodevm.themeBgColor).assertEqual(ntfcolormodevm.bgColor);

      expect(ntfcolormodevm.foregroundDividerOption).assertEqual(ntfcolormodevm.lightConfig?.foregroundDividerOption);
      expect(ntfcolormodevm.buttonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customActionViewBg);
      expect(ntfcolormodevm.groupRemainderCountOptions).assertEqual(BrightnessOptionUtils.customWifiBg);

      expect(ntfcolormodevm.headsUpBgEffect).assertEqual(ntfcolormodevm.headsUpDefaultBgEffect);
    });

    it('should_update_theme_color_correctly_when_brightness_is_disabled', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      ntfcolormodevm.isBrightnessEffect = false;
      ntfcolormodevm.isNtfBrightnessDisable = true;
      ntfcolormodevm.updateThemeColor();

      expect(ntfcolormodevm.themeFontForegroundBrightnessOptions).assertEqual(undefined);
      expect(ntfcolormodevm.themeTimestampForegroundBrightnessOptions).assertEqual(undefined);
      expect(ntfcolormodevm.themeBgBrightnessOption).assertEqual(undefined);
      expect(ntfcolormodevm.themeAllClearButtonBgOptions).assertEqual(undefined);
      expect(ntfcolormodevm.themeExtraHeaderButtonBgOptions).assertEqual(undefined);
      expect(ntfcolormodevm.themeHeaderContentButtonBgOptions).assertEqual(undefined);
      expect(ntfcolormodevm.themeBannerBgOptions).assertEqual(undefined);
      expect(ntfcolormodevm.themeFontForegroundColor)
        .assertEqual(ntfcolormodevm.getThemeColor(ThemeColorType.NTF_TEXT_SECONDARY_COLOR));
      expect(ntfcolormodevm.themeTimestampForegroundColor)
        .assertEqual(ntfcolormodevm.getThemeColor(ThemeColorType.NTF_TEXT_TERTIARY_COLOR));
      expect(ntfcolormodevm.themeBgColor).assertEqual(ntfcolormodevm.getThemeColor(ThemeColorType.NTF_BG_COLOR));

      expect(ntfcolormodevm.foregroundDividerOption).assertEqual(undefined);
      expect(ntfcolormodevm.buttonBgBrightnessOptions).assertEqual(undefined);
      expect(ntfcolormodevm.groupRemainderCountOptions).assertEqual(undefined);

      expect(ntfcolormodevm.headsUpBgEffect).assertEqual(ntfcolormodevm.headsUpNoBrightnessBgEffect);
    });

    it('should_update_all_brightness_options_correctly', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();
      let eventMgr: EventManager = EventManager.createEventManager();
      let mockfunc: Function = mocker.mockFunc(eventMgr, eventMgr.publish);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      ntfcolormodevm.eventMgr = eventMgr;

      let scbVisualEffectMgr: SCBVisualEffectMgr = new SCBVisualEffectMgr();
      let mockfunc2: Function = mocker.mockFunc(scbVisualEffectMgr, scbVisualEffectMgr.applyGlobalColor);
      when(mockfunc2)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      ntfcolormodevm.scbVisualEffectMgr = scbVisualEffectMgr;

      let globalContext: GlobalContext = new GlobalContext();
      let mockfunc3: Function = mocker.mockFunc(globalContext, globalContext.setColor);
      when(mockfunc3)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      ntfcolormodevm.globalContext = globalContext;

      ntfcolormodevm.updateBrightnessOptionLightColor();

      expect(ntfcolormodevm.foregroundPrimaryOptionOnBackground)
        .assertEqual(ntfcolormodevm.lightConfig?.foregroundPrimaryBackground);
      expect(ntfcolormodevm.foregroundPrimaryOption).assertEqual(ntfcolormodevm.lightConfig?.foregroundPrimary);
      expect(ntfcolormodevm.themeFontForegroundOptions)
        .assertEqual(ntfcolormodevm.lightConfig?.themeFontForegroundOptions);
      expect(ntfcolormodevm.ntfThemeTextPrimaryColor).assertEqual(ntfcolormodevm.lightConfig?.themeNtfTextPrimaryColor);
      expect(ntfcolormodevm.ntfExtraContentColor).assertEqual(ntfcolormodevm.lightConfig?.extraNtfContentColor);
      expect(ntfcolormodevm.ntfCenterTitleColor).assertEqual(ntfcolormodevm.lightConfig?.centerNtfTitleColor);
      expect(ntfcolormodevm.ntfButtonImageColor).assertEqual(ntfcolormodevm.lightConfig?.buttonImageNtfColor);
      expect(ntfcolormodevm.ntfThemeTextSecondaryColor).assertEqual(ntfcolormodevm.lightConfig?.themeNtfTextSecondary);
      expect(ntfcolormodevm.bgPinTextColor).assertEqual(ntfcolormodevm.lightConfig?.bgPinTextColor);

      mocker.ignoreMock(eventMgr, eventMgr.publish);
      mocker.ignoreMock(scbVisualEffectMgr, scbVisualEffectMgr.applyGlobalColor);
      mocker.ignoreMock(globalContext, globalContext.setColor);
    });

    it('should_update_all_dark_config_options', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      ntfcolormodevm.updateBrightnessOptionDarkColor();

      expect(ntfcolormodevm.foregroundPrimaryOptionOnBackground)
        .assertEqual(ntfcolormodevm.darkConfig?.foregroundPrimaryBackground);
      expect(ntfcolormodevm.foregroundPrimaryOption).assertEqual(ntfcolormodevm.darkConfig?.foregroundPrimary);
      expect(ntfcolormodevm.themeFontForegroundOptions)
        .assertEqual(ntfcolormodevm.darkConfig?.themeFontForegroundOptions);
      expect(ntfcolormodevm.ntfThemeTextPrimaryColor).assertEqual(ntfcolormodevm.darkConfig?.themeNtfTextPrimaryColor);
      expect(ntfcolormodevm.ntfExtraContentColor).assertEqual(ntfcolormodevm.darkConfig?.extraNtfContentColor);
      expect(ntfcolormodevm.ntfCenterTitleColor).assertEqual(ntfcolormodevm.darkConfig?.centerNtfTitleColor);
      expect(ntfcolormodevm.ntfButtonImageColor).assertEqual(ntfcolormodevm.darkConfig?.buttonImageNtfColor);
      expect(ntfcolormodevm.ntfThemeTextSecondaryColor).assertEqual(ntfcolormodevm.darkConfig?.themeNtfTextSecondary);
      expect(ntfcolormodevm.bgPinTextColor).assertEqual(ntfcolormodevm.darkConfig?.bgPinTextColor);
    });

    it('should_set_dark_mode_to_true_when_curMode_is_COLOR_MODE_DARK', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper(LogDomain.NOTIFICATION);
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockUpdateThemeColor: Function = mocker.mockFunc(ntfcolormodevm, ntfcolormodevm.updateThemeColor);
      when(mockUpdateThemeColor)().afterReturnNothing();

      let mockUpdateBrightnessOptionDarkColor: Function =
        mocker.mockFunc(ntfcolormodevm, ntfcolormodevm.updateBrightnessOptionDarkColor);
      when(mockUpdateBrightnessOptionDarkColor)().afterReturnNothing();

      let mockUpdateBrightnessOptionLightColor: Function =
        mocker.mockFunc(ntfcolormodevm, ntfcolormodevm.updateBrightnessOptionLightColor);
      when(mockUpdateBrightnessOptionLightColor)().afterReturnNothing();

      ntfcolormodevm.onModeChange(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);

      expect(ntfcolormodevm.isDarkMode).assertTrue();
      expect(ntfcolormodevm.bgBrightnessOption).assertEqual(ntfcolormodevm.darkConfig?.bgBrightnessOption);
      expect(ntfcolormodevm.foregroundDividerOption).assertEqual(ntfcolormodevm.darkConfig?.foregroundDividerOption);
      expect(ntfcolormodevm.fontForegroundBrightnessOptions)
        .assertEqual(BrightnessOptionUtils.foregroundSecondaryDarkOption);
      expect(ntfcolormodevm.timestampForegroundBrightnessOptions)
        .assertEqual(BrightnessOptionUtils.foregroundTertiaryGlossDarkOption);
      expect(ntfcolormodevm.bannerCardOption).assertEqual(BrightnessOptionUtils.bannerCardDarkOption);
      expect(ntfcolormodevm.buttonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customActionViewBgDark);
      expect(ntfcolormodevm.circleButtonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customWifiBgDark);
      expect(ntfcolormodevm.foregroundDividerForGroupOption)
        .assertEqual(BrightnessOptionUtils.foregroundDividerForGroupDarkOption);
      expect(ntfcolormodevm.groupRemainderCountOptions).assertEqual(BrightnessOptionUtils.customWifiBgDark);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(ntfcolormodevm, ntfcolormodevm.updateThemeColor);
      mocker.ignoreMock(ntfcolormodevm, ntfcolormodevm.updateBrightnessOptionDarkColor);
      mocker.ignoreMock(ntfcolormodevm, ntfcolormodevm.updateBrightnessOptionLightColor);
    });

    it('should_set_dark_mode_to_false_when_curMode_is_COLOR_MODE_LIGHT', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper(LogDomain.NOTIFICATION);
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockUpdateThemeColor: Function = mocker.mockFunc(ntfcolormodevm, ntfcolormodevm.updateThemeColor);
      when(mockUpdateThemeColor)().afterReturnNothing();

      let mockUpdateBrightnessOptionDarkColor: Function =
        mocker.mockFunc(ntfcolormodevm, ntfcolormodevm.updateBrightnessOptionDarkColor);
      when(mockUpdateBrightnessOptionDarkColor)().afterReturnNothing();

      let mockUpdateBrightnessOptionLightColor: Function =
        mocker.mockFunc(ntfcolormodevm, ntfcolormodevm.updateBrightnessOptionLightColor);
      when(mockUpdateBrightnessOptionLightColor)().afterReturnNothing();

      ntfcolormodevm.onModeChange(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);

      expect(ntfcolormodevm.isDarkMode).assertFalse();
      expect(ntfcolormodevm.bgBrightnessOption).assertEqual(ntfcolormodevm.lightConfig?.bgBrightnessOption);
      expect(ntfcolormodevm.foregroundDividerOption).assertEqual(ntfcolormodevm.lightConfig?.foregroundDividerOption);
      expect(ntfcolormodevm.fontForegroundBrightnessOptions)
        .assertEqual(BrightnessOptionUtils.foregroundSecondaryOption);
      expect(ntfcolormodevm.timestampForegroundBrightnessOptions)
        .assertEqual(BrightnessOptionUtils.foregroundTertiaryGlossOption);
      expect(ntfcolormodevm.bannerCardOption).assertEqual(BrightnessOptionUtils.bannerCardOption);
      expect(ntfcolormodevm.buttonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customActionViewBg);
      expect(ntfcolormodevm.circleButtonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customWifiBg);
      expect(ntfcolormodevm.foregroundDividerForGroupOption)
        .assertEqual(BrightnessOptionUtils.foregroundDividerForGroupOption);
      expect(ntfcolormodevm.groupRemainderCountOptions).assertEqual(BrightnessOptionUtils.groupRemainderCount);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(ntfcolormodevm, ntfcolormodevm.updateThemeColor);
      mocker.ignoreMock(ntfcolormodevm, ntfcolormodevm.updateBrightnessOptionDarkColor);
      mocker.ignoreMock(ntfcolormodevm, ntfcolormodevm.updateBrightnessOptionLightColor);
    });

    it('should_return_correct_color_when_type_is_NTF_TEXT_PRIMARY_COLOR', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let result = ntfcolormodevm.getThemeColor(ThemeColorType.NTF_TEXT_PRIMARY_COLOR);
      expect(result).assertEqual($r('app.color.theme_ntf_color_text_primary'));
    });

    it('should_return_correct_color_when_type_is_NTF_TEXT_SECONDARY_COLOR', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let result = ntfcolormodevm.getThemeColor(ThemeColorType.NTF_TEXT_SECONDARY_COLOR);
      expect(result).assertEqual($r('app.color.theme_ntf_color_text_secondary'));
    });

    it('should_return_correct_color_when_type_is_NTF_TEXT_TERTIARY_COLOR', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let result = ntfcolormodevm.getThemeColor(ThemeColorType.NTF_TEXT_TERTIARY_COLOR);
      expect(result).assertEqual($r('app.color.theme_ntf_color_text_tertiary'));
    });

    it('should_return_correct_color_when_type_is_NTF_BG_COLOR', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let result = ntfcolormodevm.getThemeColor(ThemeColorType.NTF_BG_COLOR);
      expect(result).assertEqual($r('app.color.ntf_blur_style_bg'));
    });

    it('should_return_correct_color_when_type_is_NTF_CENTER_TITLE_COLOR', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let result = ntfcolormodevm.getThemeColor(ThemeColorType.NTF_CENTER_TITLE_COLOR);
      expect(result).assertEqual($r('app.color.ntf_center_title_font_color'));
    });

    it('should_return_correct_color_when_type_is_NTF_BUTTON_IMAGE_COLOR', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let result = ntfcolormodevm.getThemeColor(ThemeColorType.NTF_BUTTON_IMAGE_COLOR);
      expect(result).assertEqual($r('app.color.ntf_extra_content_image_color'));
    });

    it('should_return_correct_color_when_type_is_NTF_EXTRA_CONTENT_COLOR', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let result = ntfcolormodevm.getThemeColor(ThemeColorType.NTF_EXTRA_CONTENT_COLOR);
      expect(result).assertEqual($r('app.color.ntf_extra_content_color'));
    });

    it('should_return_correct_color_when_type_is_NTF_BG_PIN_TEXT_COLOR', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let result = ntfcolormodevm.getThemeColor(ThemeColorType.NTF_BG_PIN_TEXT_COLOR);
      expect(result).assertEqual($r('app.color.theme_ntf_phone_pin_text_color'));
    });

    it('should_return_correct_color_when_type_is_NTF_TIMESTAMP_FOREGROUND_COLOR', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let result = ntfcolormodevm.getThemeColor(ThemeColorType.NTF_TIMESTAMP_FOREGROUND_COLOR);
      expect(result).assertEqual($r('app.color.theme_ntf_color_text_secondary'));
    });

    it('should_return_correct_color_when_type_is_NTF_FONT_FOREGROUND_COLOR', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let result = ntfcolormodevm.getThemeColor(ThemeColorType.NTF_FONT_FOREGROUND_COLOR);
      expect(result).assertEqual($r('app.color.ntf_blur_style_bg'));
    });

    it('should_return_correct_color_when_type_is_NTF_FONT_FOREGROUND_HIGHLIGHT_COLOR', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let result = ntfcolormodevm.getThemeColor(ThemeColorType.NTF_FONT_FOREGROUND_HIGHLIGHT_COLOR);
      expect(result).assertEqual($r('app.color.ntf_blur_style_bg'));
    });

    it('should_return_correct_color_when_type_is_NTF_FONT_FOREGROUND_DISABLED_COLOR', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let result = ntfcolormodevm.getThemeColor(ThemeColorType.NTF_FONT_FOREGROUND_DISABLED_COLOR);
      expect(result).assertEqual($r('app.color.ntf_blur_style_bg'));
    });

    it('should_return_correct_color_when_type_is_NTF_FONT_FOREGROUND_ERROR_COLOR', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let result = ntfcolormodevm.getThemeColor(ThemeColorType.NTF_FONT_FOREGROUND_ERROR_COLOR);
      expect(result).assertEqual($r('app.color.ntf_blur_style_bg'));
    });

    it('should_return_correct_color_when_type_is_NTF_FONT_FOREGROUND_WARNING_COLOR', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let result = ntfcolormodevm.getThemeColor(ThemeColorType.NTF_FONT_FOREGROUND_WARNING_COLOR);
      expect(result).assertEqual($r('app.color.ntf_blur_style_bg'));
    });

    it('should_return_correct_color_when_type_is_NTF_FONT_FOREGROUND_SUCCESS_COLOR', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let result = ntfcolormodevm.getThemeColor(ThemeColorType.NTF_FONT_FOREGROUND_SUCCESS_COLOR);
      expect(result).assertEqual($r('app.color.ntf_blur_style_bg'));
    });

    it('should_return_correct_color_when_type_is_NTF_FONT_FOREGROUND_PENDING_COLOR', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let result = ntfcolormodevm.getThemeColor(ThemeColorType.NTF_FONT_FOREGROUND_PENDING_COLOR);
      expect(result).assertEqual($r('app.color.ntf_blur_style_bg'));
    });

    it('should_return_correct_color_when_type_is_NTF_FONT_FOREGROUND_ACTION_COLOR', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let result = ntfcolormodevm.getThemeColor(ThemeColorType.NTF_FONT_FOREGROUND_ACTION_COLOR);
      expect(result).assertEqual($r('app.color.ntf_blur_style_bg'));
    });

    it('should_register_brightness_effect_and_update_status', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();

      let mockRegisterBrightnessEffectChange: Function =
        mocker.mockFunc(NtfThemeActiveMgr, NtfThemeActiveMgr.registerBrightnessEffectChange);
      when(mockRegisterBrightnessEffectChange)(ArgumentMatchers.any).afterReturnNothing();

      let mockIsNtfBrightnessEffectUse: Function =
        mocker.mockFunc(NtfThemeActiveMgr, NtfThemeActiveMgr.isNtfBrightnessEffectUse);
      when(mockIsNtfBrightnessEffectUse)([]).afterReturn(true);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturnNothing();

      ntfcolormodevm.registerBrightnessEffect();

      expect(ntfcolormodevm.isBrightnessEffect).assertTrue();
      mocker.ignoreMock(NtfThemeActiveMgr, NtfThemeActiveMgr.registerBrightnessEffectChange);
      mocker.ignoreMock(NtfThemeActiveMgr, NtfThemeActiveMgr.isNtfBrightnessEffectUse);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_register_brightness_effect_and_call_onThemeChange', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();

      let mockRegisterBrightnessEffectChange: Function =
        mocker.mockFunc(NtfThemeActiveMgr, NtfThemeActiveMgr.registerBrightnessEffectChange);
      when(mockRegisterBrightnessEffectChange)(ArgumentMatchers.any).afterReturnNothing();

      let mockIsNtfBrightnessEffectUse: Function =
        mocker.mockFunc(NtfThemeActiveMgr, NtfThemeActiveMgr.isNtfBrightnessEffectUse);
      when(mockIsNtfBrightnessEffectUse)([]).afterReturn(true);

      let mockOnThemeChange: Function = mocker.mockFunc(ntfcolormodevm, ntfcolormodevm.onThemeChange);
      when(mockOnThemeChange)([]).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturnNothing();

      ntfcolormodevm.registerBrightnessEffect();

      expect(ntfcolormodevm.isBrightnessEffect).assertTrue();
      mocker.ignoreMock(NtfThemeActiveMgr, NtfThemeActiveMgr.registerBrightnessEffectChange);
      mocker.ignoreMock(NtfThemeActiveMgr, NtfThemeActiveMgr.isNtfBrightnessEffectUse);
      mocker.ignoreMock(ntfcolormodevm, ntfcolormodevm.onThemeChange);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_register_brightness_effect_and_log_info', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();

      let mockRegisterBrightnessEffectChange: Function =
        mocker.mockFunc(NtfThemeActiveMgr, NtfThemeActiveMgr.registerBrightnessEffectChange);
      when(mockRegisterBrightnessEffectChange)(ArgumentMatchers.any).afterReturnNothing();

      let mockIsNtfBrightnessEffectUse: Function =
        mocker.mockFunc(NtfThemeActiveMgr, NtfThemeActiveMgr.isNtfBrightnessEffectUse);
      when(mockIsNtfBrightnessEffectUse)([]).afterReturn(true);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturnNothing();

      ntfcolormodevm.registerBrightnessEffect();

      expect(ntfcolormodevm.isBrightnessEffect).assertTrue();
      mocker.ignoreMock(NtfThemeActiveMgr, NtfThemeActiveMgr.registerBrightnessEffectChange);
      mocker.ignoreMock(NtfThemeActiveMgr, NtfThemeActiveMgr.isNtfBrightnessEffectUse);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_disable_brightness_options_when_isNtfBrightnessDisable_is_true', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      ntfcolormodevm.isNtfBrightnessDisable = true;
      ntfcolormodevm.updateDisableBrightnessOptions();
      expect(ntfcolormodevm.themeMenuButtonBgOptions).assertUndefined();
      expect(ntfcolormodevm.bgBrightnessOption).assertUndefined();
      expect(ntfcolormodevm.bannerCardOption).assertUndefined();
      expect(ntfcolormodevm.foregroundPrimaryOption).assertUndefined();
    });

    it('should_not_disable_brightness_options_when_isNtfBrightnessDisable_is_false', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      ntfcolormodevm.isNtfBrightnessDisable = false;
      ntfcolormodevm.updateDisableBrightnessOptions();
      expect(ntfcolormodevm.themeMenuButtonBgOptions).assertInstanceOf(BrightnessOptions);
      expect(ntfcolormodevm.bgBrightnessOption).assertInstanceOf(BrightnessOptions);
      expect(ntfcolormodevm.bannerCardOption).assertInstanceOf(BrightnessOptions);
      expect(ntfcolormodevm.foregroundPrimaryOption).assertInstanceOf(BrightnessOptions);
    });

    it('should_update_disable_brightness_option_color', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      ntfcolormodevm.updateDisableBrightnessOptionColor();
      expect(ntfcolormodevm.liveNtfItemBgColor).assertEqual($r('app.color.live_ntf_disable_brightness_bg_color'));
      expect(ntfcolormodevm.liveHeadsUpBgColor).assertEqual($r('app.color.live_heads_up_disable_brightness_bg_color'));
    });

    it('should_add_default_config_correctly', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let ntfModeConfig: NtfColorModeConfig = new NtfColorModeConfig();
      ntfcolormodevm.addDefaultConfig(ntfModeConfig);

      expect(ntfModeConfig.foregroundPrimary).assertEqual(undefined);
      expect(ntfModeConfig.foregroundPrimaryBackground).assertEqual(undefined);
      expect(ntfModeConfig.themeFontForegroundOptions).assertEqual(undefined);
      expect(ntfModeConfig.themeNtfTextPrimaryColor).assertEqual($r('app.color.theme_ntf_color_text_primary'));
      expect(ntfModeConfig.extraNtfContentColor).assertEqual($r('app.color.ntf_extra_content_color'));
      expect(ntfModeConfig.centerNtfTitleColor).assertEqual($r('app.color.ntf_center_title_font_color'));
      expect(ntfModeConfig.buttonImageNtfColor).assertEqual($r('app.color.ntf_extra_content_image_color'));
      expect(ntfModeConfig.themeNtfTextSecondary).assertEqual($r('app.color.theme_ntf_color_text_secondary'));
      expect(ntfModeConfig.bgPinTextColor).assertEqual($r('app.color.theme_ntf_phone_pin_text_color'));
    });

    it('should_add_default_config_incorrectly', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let ntfModeConfig: NtfColorModeConfig = new NtfColorModeConfig();
      ntfcolormodevm.addDefaultConfig(ntfModeConfig);

      expect(ntfModeConfig.foregroundPrimary).assertEqual(undefined);
      expect(ntfModeConfig.foregroundPrimaryBackground).assertEqual(undefined);
      expect(ntfModeConfig.themeFontForegroundOptions).assertEqual(undefined);
      expect(ntfModeConfig.themeNtfTextPrimaryColor).assertEqual($r('app.color.theme_ntf_color_text_primary'));
      expect(ntfModeConfig.extraNtfContentColor).assertEqual($r('app.color.ntf_extra_content_color'));
      expect(ntfModeConfig.centerNtfTitleColor).assertEqual($r('app.color.ntf_center_title_font_color'));
      expect(ntfModeConfig.buttonImageNtfColor).assertEqual($r('app.color.ntf_extra_content_image_color'));
      expect(ntfModeConfig.themeNtfTextSecondary).assertEqual($r('app.color.theme_ntf_color_text_secondary'));
      expect(ntfModeConfig.bgPinTextColor).assertEqual($r('app.color.theme_ntf_phone_pin_text_color'));
    });

    it('should_update_able_brightness_option_color_', 0, () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      ntfcolormodevm.updateDisableBrightnessOptionColor();
      expect(ntfcolormodevm.liveNtfItemBgColor).assertEqual($r('app.color.live_ntf_disable_brightness_bg_color'));
      expect(ntfcolormodevm.liveHeadsUpBgColor).assertEqual($r('app.color.live_heads_up_disable_brightness_bg_color'));
    });
  });
}