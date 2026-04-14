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
import { ConfigurationConstant } from '@kit.AbilityKit';
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import { ConfigurationEvent, GlobalContext } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { ThemeActiveEvent } from '../../../main/ets/event/ThemeActiveEvent';
import { LiveStyle } from '../../../main/ets/live/constants/LiveStyle';
import { BrightnessOptionUtils } from '../../../main/ets/template/newStyle/BrightnessOptionUtils';
import { InnerEventUtil } from '../../../main/ets/utils/InnerEventUtil';
import { Singleton } from '../../../main/ets/utils/Singleton';
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
import { SystemUIColorVm } from '../../../main/ets/vm/SystemUIColorVm';

export default function SystemUIColorVmTest() {
  describe('updateColorMode_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_update_color_mode_to_light_when_color_mode_is_light', 0, async () => {
      let systemuicolorvm: SystemUIColorVm = new SystemUIColorVm();
      let mocker: MockKit = new MockKit();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockGetThemeColor: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.getThemeColor);
      when(mockGetThemeColor)(ArgumentMatchers.any).afterReturn($r('app.color.theme_ntf_color_text_secondary'));

      let mockGetColor: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.getColor);
      when(mockGetColor)(ArgumentMatchers.any).afterReturn($r('app.color.theme_ntf_color_text_secondary'));

      let mockGetOption: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.getOption);
      when(mockGetOption)(ArgumentMatchers.any).afterReturn(BrightnessOptionUtils.backgroundFiveOption);

      systemuicolorvm.colorMode = ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
      systemuicolorvm.isBrightnessEffect = true;
      systemuicolorvm.updateColorMode();

      expect(systemuicolorvm.fontColor).assertEqual($r('app.color.theme_ntf_color_text_secondary'));
      expect(systemuicolorvm.timeFontColor).assertEqual($r('app.color.theme_ntf_color_text_tertiary'));
      expect(systemuicolorvm.ntfCardBgColor).assertEqual($r('app.color.theme_ntf_color_text_secondary'));
      expect(systemuicolorvm.themeTimestampForegroundColor).assertEqual($r('app.color.theme_ntf_color_text_tertiary'));
      expect(systemuicolorvm.bannerCardBgColor).assertEqual($r('app.color.theme_ntf_color_text_secondary'));
      expect(systemuicolorvm.ntfThemeTextSecondaryColor).assertEqual($r('app.color.theme_ntf_color_text_secondary'));
      expect(systemuicolorvm.ntfThemeTextPrimaryColor).assertEqual($r('app.color.theme_ntf_color_text_primary'));

      expect(systemuicolorvm.actionButtonBgBrightness).assertEqual(BrightnessOptionUtils.customActionViewBg);
      expect(systemuicolorvm.dividerFgBrightness).assertEqual(BrightnessOptionUtils.foregroundDividerOption);
      expect(systemuicolorvm.cardBgBrightness).assertEqual(BrightnessOptionUtils.backgroundFiveOption);
      expect(systemuicolorvm.fontFgBrightness).assertEqual(BrightnessOptionUtils.foregroundSecondaryOption);
      expect(systemuicolorvm.timeFgBrightness).assertEqual(BrightnessOptionUtils.foregroundTertiaryGlossOption);
      expect(systemuicolorvm.bannerCardBgBrightness).assertEqual(BrightnessOptionUtils.bannerCardOption);
      expect(systemuicolorvm.remainderBgBrightness).assertEqual(BrightnessOptionUtils.customWifiBg);
      expect(systemuicolorvm.systemButtonBgBrightness).assertEqual(BrightnessOptionUtils.systemLiveButtonBgCardOption);
      expect(systemuicolorvm.systemButtonOnBgBrightness)
        .assertEqual(BrightnessOptionUtils.systemLiveButtonOnBgCardOption);
      expect(systemuicolorvm.systemButtonOffBgBrightness)
        .assertEqual(BrightnessOptionUtils.systemLiveButtonOffBgCardOption);
      expect(systemuicolorvm.screenRecordButtonOnBgBrightness)
        .assertEqual(BrightnessOptionUtils.systemLiveButtonOnBgCardOption);
      expect(systemuicolorvm.screenRecordButtonOffBgBrightness)
        .assertEqual(BrightnessOptionUtils.systemLiveButtonOffBgCardOption);
      expect(systemuicolorvm.colorFilter).assertEqual(LiveStyle.BLACK_COLOR_FILTER);
      expect(systemuicolorvm.mediaCardTitleBrightness).assertEqual(BrightnessOptionUtils.foregroundPrimaryOptionLight);
      expect(systemuicolorvm.mediaCardSwitchBgBrightness).assertEqual(BrightnessOptionUtils.customWifiBgOn);
      expect(systemuicolorvm.mediaCardSwitchOnBrightness)
        .assertEqual(BrightnessOptionUtils.foregroundPrimaryOnOptionLight);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.getThemeColor);
      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.getColor);
      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.getOption);
    });

    it('should_update_color_mode_to_dark_when_color_mode_is_dark', 0, async () => {
      let systemuicolorvm: SystemUIColorVm = new SystemUIColorVm();
      let mocker: MockKit = new MockKit();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockGetThemeColor: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.getThemeColor);
      when(mockGetThemeColor)(ArgumentMatchers.any).afterReturn($r('app.color.theme_ntf_color_text_secondary'));

      let mockGetColor: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.getColor);
      when(mockGetColor)(ArgumentMatchers.any).afterReturn($r('app.color.theme_ntf_color_text_secondary'));

      let mockGetOption: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.getOption);
      when(mockGetOption)(ArgumentMatchers.any).afterReturn(BrightnessOptionUtils.backgroundFiveOptionDark);

      systemuicolorvm.colorMode = ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
      systemuicolorvm.isBrightnessEffect = true;
      systemuicolorvm.updateColorMode();

      expect(systemuicolorvm.fontColor).assertEqual($r('app.color.theme_ntf_color_text_secondary'));
      expect(systemuicolorvm.timeFontColor).assertEqual($r('app.color.theme_ntf_color_text_tertiary'));
      expect(systemuicolorvm.ntfCardBgColor).assertEqual($r('app.color.theme_ntf_color_text_secondary'));
      expect(systemuicolorvm.themeTimestampForegroundColor).assertEqual($r('app.color.theme_ntf_color_text_tertiary'));
      expect(systemuicolorvm.bannerCardBgColor).assertEqual($r('app.color.theme_ntf_color_text_secondary'));
      expect(systemuicolorvm.ntfThemeTextSecondaryColor).assertEqual($r('app.color.theme_ntf_color_text_secondary'));
      expect(systemuicolorvm.ntfThemeTextPrimaryColor).assertEqual($r('app.color.theme_ntf_color_text_primary'));

      expect(systemuicolorvm.actionButtonBgBrightness).assertEqual(BrightnessOptionUtils.customActionViewBgDark);
      expect(systemuicolorvm.dividerFgBrightness).assertEqual(BrightnessOptionUtils.foregroundDividerDarkOption);
      expect(systemuicolorvm.cardBgBrightness).assertEqual(BrightnessOptionUtils.backgroundFiveOptionDark);
      expect(systemuicolorvm.fontFgBrightness).assertEqual(BrightnessOptionUtils.foregroundSecondaryDarkOption);
      expect(systemuicolorvm.timeFgBrightness).assertEqual(BrightnessOptionUtils.foregroundTertiaryGlossDarkOption);
      expect(systemuicolorvm.bannerCardBgBrightness).assertEqual(BrightnessOptionUtils.bannerCardDarkOption);
      expect(systemuicolorvm.remainderBgBrightness).assertEqual(BrightnessOptionUtils.customWifiBgDark);
      expect(systemuicolorvm.systemButtonBgBrightness)
        .assertEqual(BrightnessOptionUtils.systemLiveButtonBgCardDarkOption);
      expect(systemuicolorvm.systemButtonOnBgBrightness)
        .assertEqual(BrightnessOptionUtils.systemLiveButtonOnBgCardDarkOption);
      expect(systemuicolorvm.systemButtonOffBgBrightness)
        .assertEqual(BrightnessOptionUtils.systemLiveButtonOffBgCardDarkOption);
      expect(systemuicolorvm.screenRecordButtonOnBgBrightness)
        .assertEqual(BrightnessOptionUtils.systemLiveButtonOnBgCardDarkOption);
      expect(systemuicolorvm.screenRecordButtonOffBgBrightness)
        .assertEqual(BrightnessOptionUtils.systemLiveButtonOffBgCardDarkOption);
      expect(systemuicolorvm.colorFilter).assertEqual(LiveStyle.WHITE_COLOR_FILTER);
      expect(systemuicolorvm.mediaCardTitleBrightness).assertEqual(BrightnessOptionUtils.foregroundPrimaryOptionDark);
      expect(systemuicolorvm.mediaCardSwitchBgBrightness).assertEqual(BrightnessOptionUtils.customWifiBgOnDark);
    });
    it('should_register_configuration_and_theme_active_events', 0, () => {
      let systemuicolorvm: SystemUIColorVm = new SystemUIColorVm();
      let mocker: MockKit = new MockKit();

      let mockCheckThemeColor: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.checkThemeColor);
      let mockUpdateColorMode: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.updateColorMode);

      when(mockCheckThemeColor)(ArgumentMatchers.any).afterReturnNothing();
      when(mockUpdateColorMode)(ArgumentMatchers.any).afterReturnNothing();

      systemuicolorvm.init();

      expect(mockCheckThemeColor).assertEqual(true);
      expect(mockUpdateColorMode).assertEqual(true);

      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.checkThemeColor);
      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.updateColorMode);
    });

    it('should_update_color_mode_when_colorMode_is_changed', 0, () => {
      let systemuicolorvm: SystemUIColorVm = new SystemUIColorVm();
      let mocker: MockKit = new MockKit();

      let mockCheckThemeColor: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.checkThemeColor);
      let mockUpdateColorMode: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.updateColorMode);

      when(mockCheckThemeColor)(ArgumentMatchers.any).afterReturnNothing();
      when(mockUpdateColorMode)(ArgumentMatchers.any).afterReturnNothing();

      let event: ConfigurationEvent = {
        config: {
          colorMode: ConfigurationConstant.ColorMode.COLOR_MODE_DARK
        }
      };
      systemuicolorvm.onConfigurationEvent(event);

      expect(systemuicolorvm.colorMode).assertEqual(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
      expect(mockUpdateColorMode).assertEqual(true);

      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.checkThemeColor);
      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.updateColorMode);
    });

    it('should_not_update_color_mode_when_colorMode_is_same', 0, () => {
      let systemuicolorvm: SystemUIColorVm = new SystemUIColorVm();
      let mocker: MockKit = new MockKit();

      let mockCheckThemeColor: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.checkThemeColor);
      let mockUpdateColorMode: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.updateColorMode);

      when(mockCheckThemeColor)(ArgumentMatchers.any).afterReturnNothing();
      when(mockUpdateColorMode)(ArgumentMatchers.any).afterReturnNothing();

      let event: ConfigurationEvent = {
        config: {
          colorMode: ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT
        }
      };
      systemuicolorvm.onConfigurationEvent(event);

      expect(systemuicolorvm.colorMode).assertEqual(undefined);
      expect(mockUpdateColorMode).assertEqual(false);

      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.checkThemeColor);
      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.updateColorMode);
    });

    it('should_call_theme_active_event_when_theme_is_active', 0, () => {
      let systemuicolorvm: SystemUIColorVm = new SystemUIColorVm();
      let mocker: MockKit = new MockKit();

      let mockCheckThemeColor: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.checkThemeColor);
      let mockUpdateColorMode: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.updateColorMode);

      when(mockCheckThemeColor)(ArgumentMatchers.any).afterReturnNothing();
      when(mockUpdateColorMode)(ArgumentMatchers.any).afterReturnNothing();

      let themeActiveEvent: ThemeActiveEvent = new ThemeActiveEvent();
      systemuicolorvm.onThemeActiveEvent();

      expect(mockCheckThemeColor).assertEqual(true);
      expect(mockUpdateColorMode).assertEqual(true);

      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.checkThemeColor);
      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.updateColorMode);
    });

    it('should_set_isBrightnessEffect_to_false_when_theme_color_not_support_brightness', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockGetColor: Function = mocker.mockFunc(ResUtils, ResUtils.getColor);
      when(mockGetColor)(ArgumentMatchers.any).afterReturn(1);
      when(mockGetColor)(ArgumentMatchers.any).afterReturn(2);
      when(mockGetColor)(ArgumentMatchers.any).afterReturn(3);
      when(mockGetColor)(ArgumentMatchers.any).afterReturn(4);
      when(mockGetColor)(ArgumentMatchers.any).afterReturn(5);

      let systemuicolorvm: SystemUIColorVm = new SystemUIColorVm();
      systemuicolorvm.onThemeActiveEvent();

      expect(systemuicolorvm.isBrightnessEffect).assertEqual(false);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(ResUtils, ResUtils.getColor);
    });

    it('should_set_isBrightnessEffect_to_true_when_theme_color_support_brightness', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockGetColor: Function = mocker.mockFunc(ResUtils, ResUtils.getColor);
      when(mockGetColor)(ArgumentMatchers.any).afterReturn(1);
      when(mockGetColor)(ArgumentMatchers.any).afterReturn(2);
      when(mockGetColor)(ArgumentMatchers.any).afterReturn(3);
      when(mockGetColor)(ArgumentMatchers.any).afterReturn(4);
      when(mockGetColor)(ArgumentMatchers.any).afterReturn(5);

      let systemuicolorvm: SystemUIColorVm = new SystemUIColorVm();
      systemuicolorvm.onThemeActiveEvent();

      expect(systemuicolorvm.isBrightnessEffect).assertEqual(true);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(ResUtils, ResUtils.getColor);
    });

    it('should_set_isBrightnessEffect_to_false_when_theme_color_is_undefined', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockGetColor: Function = mocker.mockFunc(ResUtils, ResUtils.getColor);
      when(mockGetColor)(ArgumentMatchers.any).afterReturn(undefined);

      let systemuicolorvm: SystemUIColorVm = new SystemUIColorVm();
      systemuicolorvm.onThemeActiveEvent();

      expect(systemuicolorvm.isBrightnessEffect).assertEqual(false);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(ResUtils, ResUtils.getColor);
    });

    it('should_return_undefined_when_isBrightnessEffect_is_false', 0, () => {
      let systemuicolorvm: SystemUIColorVm = new SystemUIColorVm();
      systemuicolorvm.isBrightnessEffect = false;
      let result = systemuicolorvm.getOption(BrightnessOptionUtils.foregroundTertiaryGlossOption);
      expect(result).assertUndefined();
    });

    it('should_return_brightnessEffectOpt_when_isBrightnessEffect_is_true', 0, () => {
      let systemuicolorvm: SystemUIColorVm = new SystemUIColorVm();
      systemuicolorvm.isBrightnessEffect = true;
      let result = systemuicolorvm.getOption(BrightnessOptionUtils.foregroundTertiaryGlossOption);
      expect(result).assertDeepEquals(BrightnessOptionUtils.foregroundTertiaryGlossOption);
    });

    it('should_return_defaultColor_when_isBrightnessEffect_is_true', 0, () => {
      let systemuicolorvm: SystemUIColorVm = new SystemUIColorVm();
      systemuicolorvm.isBrightnessEffect = true;
      let conflictColor: ResourceColor = $r('app.color.ntf_brightness_bg_color');
      const result = systemuicolorvm.getColor(conflictColor);
      expect(result).assertEqual(systemuicolorvm.defaultColor);
    });

    it('should_return_conflictColor_when_isBrightnessEffect_is_false', 0, () => {
      let systemuicolorvm: SystemUIColorVm = new SystemUIColorVm();
      systemuicolorvm.isBrightnessEffect = false;
      let conflictColor: ResourceColor = $r('app.color.ntf_brightness_bg_color');
      const result = systemuicolorvm.getColor(conflictColor);
      expect(result).assertEqual(conflictColor);
    });

    it('should_return_correct_color_when_type_is_NTF_TEXT_PRIMARY_COLOR', 0, () => {
      let systemuicolorvm: SystemUIColorVm = new SystemUIColorVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.getThemeColor);
      when(mockfunc)(ArgumentMatchers.any)
        .afterReturn(ResUtils.getResourceColor($r('app.color.theme_ntf_color_text_primary')));
      const result = systemuicolorvm.getThemeColor(ThemeColorType.NTF_TEXT_PRIMARY_COLOR);
      expect(result).assertEqual(ResUtils.getResourceColor($r('app.color.theme_ntf_color_text_primary')));
      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.getThemeColor);
    });

    it('should_return_correct_color_when_type_is_NTF_TEXT_SECONDARY_COLOR', 0, () => {
      let systemuicolorvm: SystemUIColorVm = new SystemUIColorVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.getThemeColor);
      when(mockfunc)(ArgumentMatchers.any)
        .afterReturn(ResUtils.getResourceColor($r('app.color.theme_ntf_color_text_secondary')));
      const result = systemuicolorvm.getThemeColor(ThemeColorType.NTF_TEXT_SECONDARY_COLOR);
      expect(result).assertEqual(ResUtils.getResourceColor($r('app.color.theme_ntf_color_text_secondary')));
      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.getThemeColor);
    });

    it('should_return_correct_color_when_type_is_NTF_TEXT_TERTIARY_COLOR', 0, () => {
      let systemuicolorvm: SystemUIColorVm = new SystemUIColorVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.getThemeColor);
      when(mockfunc)(ArgumentMatchers.any)
        .afterReturn(ResUtils.getResourceColor($r('app.color.theme_ntf_color_text_tertiary')));
      const result = systemuicolorvm.getThemeColor(ThemeColorType.NTF_TEXT_TERTIARY_COLOR);
      expect(result).assertEqual(ResUtils.getResourceColor($r('app.color.theme_ntf_color_text_tertiary')));
      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.getThemeColor);
    });

    it('should_return_correct_color_when_type_is_NTF_BG_COLOR', 0, () => {
      let systemuicolorvm: SystemUIColorVm = new SystemUIColorVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.getThemeColor);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(ResUtils.getResourceColor($r('app.color.ntf_blur_style_bg')));
      const result = systemuicolorvm.getThemeColor(ThemeColorType.NTF_BG_COLOR);
      expect(result).assertEqual(ResUtils.getResourceColor($r('app.color.ntf_blur_style_bg')));
      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.getThemeColor);
    });

    it('should_return_immediately_when_colorMode_is_undefined', 0, () => {
      let event: ConfigurationEvent = new ConfigurationEvent();
      event.config = {
        colorMode: undefined
      };
      let systemuicolorvm: SystemUIColorVm = new SystemUIColorVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockUpdateColorMode: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.updateColorMode);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockUpdateColorMode)().afterReturnNothing();
      systemuicolorvm.onConfigurationEvent(event);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.updateColorMode);
    });

    it('should_return_immediately_when_colorMode_is_same', 0, () => {
      let event: ConfigurationEvent = new ConfigurationEvent();
      event.config = {
        colorMode: ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT
      };
      let systemuicolorvm: SystemUIColorVm = new SystemUIColorVm();
      systemuicolorvm.colorMode = ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockUpdateColorMode: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.updateColorMode);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockUpdateColorMode)().afterReturnNothing();
      systemuicolorvm.onConfigurationEvent(event);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.updateColorMode);
    });

    it('should_update_colorMode_and_call_updateColorMode_when_colorMode_is_different', 0, () => {
      let event: ConfigurationEvent = new ConfigurationEvent();
      event.config = {
        colorMode: ConfigurationConstant.ColorMode.COLOR_MODE_DARK
      };
      let systemuicolorvm: SystemUIColorVm = new SystemUIColorVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockUpdateColorMode: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.updateColorMode);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockUpdateColorMode)().afterReturnNothing();
      systemuicolorvm.onConfigurationEvent(event);
      expect(systemuicolorvm.colorMode).assertEqual(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.updateColorMode);
    });

    it('should_call_updateColorMode_when_colorMode_is_dark', 0, () => {
      let event: ConfigurationEvent = new ConfigurationEvent();
      event.config = {
        colorMode: ConfigurationConstant.ColorMode.COLOR_MODE_DARK
      };
      let systemuicolorvm: SystemUIColorVm = new SystemUIColorVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockUpdateColorMode: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.updateColorMode);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockUpdateColorMode)().afterReturnNothing();
      systemuicolorvm.onConfigurationEvent(event);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.updateColorMode);
    });

    it('should_call_updateColorMode_when_colorMode_is_light', 0, () => {
      let event: ConfigurationEvent = new ConfigurationEvent();
      event.config = {
        colorMode: ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT
      };
      let systemuicolorvm: SystemUIColorVm = new SystemUIColorVm();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockUpdateColorMode: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.updateColorMode);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockUpdateColorMode)().afterReturnNothing();
      systemuicolorvm.onConfigurationEvent(event);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.updateColorMode);
    });

    it('should_call_checkThemeColor_and_updateColorMode_when_onThemeActiveEvent_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let systemuicolorvm: SystemUIColorVm = new SystemUIColorVm();
      let mockCheckThemeColor: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.checkThemeColor);
      let mockUpdateColorMode: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.updateColorMode);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockCheckThemeColor)().afterReturnNothing();
      when(mockUpdateColorMode)().afterReturnNothing();
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      systemuicolorvm.onThemeActiveEvent();
      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.checkThemeColor);
      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.updateColorMode);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_set_colorMode_when_config_colorMode_is_undefined', 0, async () => {
      let mocker: MockKit = new MockKit();
      let systemuicolorvm: SystemUIColorVm = new SystemUIColorVm();
      let mockCheckThemeColor: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.checkThemeColor);
      let mockUpdateColorMode: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.updateColorMode);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockCheckThemeColor)().afterReturnNothing();
      when(mockUpdateColorMode)().afterReturnNothing();
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      let config: ConfigurationEvent = {
        config: {
          colorMode: undefined
        }
      };
      systemuicolorvm.onConfigurationEvent(config);
      expect(systemuicolorvm.colorMode).assertEqual(undefined);
      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.checkThemeColor);
      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.updateColorMode);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_set_colorMode_when_config_colorMode_is_not_undefined', 0, async () => {
      let mocker: MockKit = new MockKit();
      let systemuicolorvm: SystemUIColorVm = new SystemUIColorVm();
      let mockCheckThemeColor: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.checkThemeColor);
      let mockUpdateColorMode: Function = mocker.mockFunc(systemuicolorvm, systemuicolorvm.updateColorMode);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockCheckThemeColor)().afterReturnNothing();
      when(mockUpdateColorMode)().afterReturnNothing();
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      let config: ConfigurationEvent = {
        config: {
          colorMode: ConfigurationConstant.ColorMode.COLOR_MODE_DARK
        }
      };
      systemuicolorvm.onConfigurationEvent(config);
      expect(systemuicolorvm.colorMode).assertEqual(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.checkThemeColor);
      mocker.ignoreMock(systemuicolorvm, systemuicolorvm.updateColorMode);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
  });
}