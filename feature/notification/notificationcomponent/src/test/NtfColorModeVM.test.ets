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
import { BrightnessEffectChangeCallback, NtfThemeActiveMgr } from '../../../main/ets/common/NotificationThemeActiveManager';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NtfColorModeVM } from '../../../main/ets/vm/NtfColorModeVM';
export default function NtfColorModeVMTest() {
  describe('onModeChange_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_set_dark_mode_to_true_when_curMode_is_COLOR_MODE_DARK', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper(LogDomain.NOTIFICATION);
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfcolormodevm.onModeChange(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);

      expect(ntfcolormodevm.isDarkMode).assertTrue();
      expect(ntfcolormodevm.bgBrightnessOption).assertEqual(ntfcolormodevm.darkConfig?.bgBrightnessOption);
      expect(ntfcolormodevm.foregroundDividerOption).assertEqual(ntfcolormodevm.darkConfig?.foregroundDividerOption);
      expect(ntfcolormodevm.fontForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundSecondaryDarkOption);
      expect(ntfcolormodevm.timestampForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundTertiaryGlossDarkOption);
      expect(ntfcolormodevm.bannerCardOption).assertEqual(BrightnessOptionUtils.bannerCardDarkOption);
      expect(ntfcolormodevm.buttonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customActionViewBgDark);
      expect(ntfcolormodevm.circleButtonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customWifiBgDark);
      expect(ntfcolormodevm.foregroundDividerForGroupOption).assertEqual(BrightnessOptionUtils.foregroundDividerForGroupDarkOption);
      expect(ntfcolormodevm.groupRemainderCountOptions).assertEqual(BrightnessOptionUtils.customWifiBgDark);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_dark_mode_to_false_when_curMode_is_COLOR_MODE_LIGHT', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper(LogDomain.NOTIFICATION);
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfcolormodevm.onModeChange(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);

      expect(ntfcolormodevm.isDarkMode).assertFalse();
      expect(ntfcolormodevm.bgBrightnessOption).assertEqual(ntfcolormodevm.lightConfig?.bgBrightnessOption);
      expect(ntfcolormodevm.foregroundDividerOption).assertEqual(ntfcolormodevm.lightConfig?.foregroundDividerOption);
      expect(ntfcolormodevm.fontForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundSecondaryOption);
      expect(ntfcolormodevm.timestampForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundTertiaryGlossOption);
      expect(ntfcolormodevm.bannerCardOption).assertEqual(BrightnessOptionUtils.bannerCardOption);
      expect(ntfcolormodevm.buttonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.getInstance().customActionViewBg);
      expect(ntfcolormodevm.circleButtonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customWifiBg);
      expect(ntfcolormodevm.foregroundDividerForGroupOption).assertEqual(BrightnessOptionUtils.foregroundDividerForGroupOption);
      expect(ntfcolormodevm.groupRemainderCountOptions).assertEqual(BrightnessOptionUtils.groupRemainderCount);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_dark_mode_to_true_when_curMode_is_COLOR_MODE_DARK', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper(LogDomain.NOTIFICATION);
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfcolormodevm.onModeChange(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);

      expect(ntfcolormodevm.isDarkMode).assertTrue();
      expect(ntfcolormodevm.bgBrightnessOption).assertEqual(ntfcolormodevm.darkConfig?.bgBrightnessOption);
      expect(ntfcolormodevm.foregroundDividerOption).assertEqual(ntfcolormodevm.darkConfig?.foregroundDividerOption);
      expect(ntfcolormodevm.fontForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundSecondaryDarkOption);
      expect(ntfcolormodevm.timestampForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundTertiaryGlossDarkOption);
      expect(ntfcolormodevm.bannerCardOption).assertEqual(BrightnessOptionUtils.bannerCardDarkOption);
      expect(ntfcolormodevm.buttonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customActionViewBgDark);
      expect(ntfcolormodevm.circleButtonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customWifiBgDark);
      expect(ntfcolormodevm.foregroundDividerForGroupOption).assertEqual(BrightnessOptionUtils.foregroundDividerForGroupDarkOption);
      expect(ntfcolormodevm.groupRemainderCountOptions).assertEqual(BrightnessOptionUtils.customWifiBgDark);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_dark_mode_to_false_when_curMode_is_COLOR_MODE_LIGHT', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper(LogDomain.NOTIFICATION);
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfcolormodevm.onModeChange(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);

      expect(ntfcolormodevm.isDarkMode).assertFalse();
      expect(ntfcolormodevm.bgBrightnessOption).assertEqual(ntfcolormodevm.lightConfig?.bgBrightnessOption);
      expect(ntfcolormodevm.foregroundDividerOption).assertEqual(ntfcolormodevm.lightConfig?.foregroundDividerOption);
      expect(ntfcolormodevm.fontForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundSecondaryOption);
      expect(ntfcolormodevm.timestampForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundTertiaryGlossOption);
      expect(ntfcolormodevm.bannerCardOption).assertEqual(BrightnessOptionUtils.bannerCardOption);
      expect(ntfcolormodevm.buttonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.getInstance().customActionViewBg);
      expect(ntfcolormodevm.circleButtonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customWifiBg);
      expect(ntfcolormodevm.foregroundDividerForGroupOption).assertEqual(BrightnessOptionUtils.foregroundDividerForGroupOption);
      expect(ntfcolormodevm.groupRemainderCountOptions).assertEqual(BrightnessOptionUtils.groupRemainderCount);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_dark_mode_to_true_when_curMode_is_COLOR_MODE_DARK', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper(LogDomain.NOTIFICATION);
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfcolormodevm.onModeChange(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);

      expect(ntfcolormodevm.isDarkMode).assertTrue();
      expect(ntfcolormodevm.bgBrightnessOption).assertEqual(ntfcolormodevm.darkConfig?.bgBrightnessOption);
      expect(ntfcolormodevm.foregroundDividerOption).assertEqual(ntfcolormodevm.darkConfig?.foregroundDividerOption);
      expect(ntfcolormodevm.fontForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundSecondaryDarkOption);
      expect(ntfcolormodevm.timestampForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundTertiaryGlossDarkOption);
      expect(ntfcolormodevm.bannerCardOption).assertEqual(BrightnessOptionUtils.bannerCardDarkOption);
      expect(ntfcolormodevm.buttonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customActionViewBgDark);
      expect(ntfcolormodevm.circleButtonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customWifiBgDark);
      expect(ntfcolormodevm.foregroundDividerForGroupOption).assertEqual(BrightnessOptionUtils.foregroundDividerForGroupDarkOption);
      expect(ntfcolormodevm.groupRemainderCountOptions).assertEqual(BrightnessOptionUtils.customWifiBgDark);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_dark_mode_to_false_when_curMode_is_COLOR_MODE_LIGHT', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper(LogDomain.NOTIFICATION);
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfcolormodevm.onModeChange(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);

      expect(ntfcolormodevm.isDarkMode).assertFalse();
      expect(ntfcolormodevm.bgBrightnessOption).assertEqual(ntfcolormodevm.lightConfig?.bgBrightnessOption);
      expect(ntfcolormodevm.foregroundDividerOption).assertEqual(ntfcolormodevm.lightConfig?.foregroundDividerOption);
      expect(ntfcolormodevm.fontForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundSecondaryOption);
      expect(ntfcolormodevm.timestampForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundTertiaryGlossOption);
      expect(ntfcolormodevm.bannerCardOption).assertEqual(BrightnessOptionUtils.bannerCardOption);
      expect(ntfcolormodevm.buttonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.getInstance().customActionViewBg);
      expect(ntfcolormodevm.circleButtonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customWifiBg);
      expect(ntfcolormodevm.foregroundDividerForGroupOption).assertEqual(BrightnessOptionUtils.foregroundDividerForGroupOption);
      expect(ntfcolormodevm.groupRemainderCountOptions).assertEqual(BrightnessOptionUtils.groupRemainderCount);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_dark_mode_to_true_when_curMode_is_COLOR_MODE_DARK', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper(LogDomain.NOTIFICATION);
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfcolormodevm.onModeChange(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);

      expect(ntfcolormodevm.isDarkMode).assertTrue();
      expect(ntfcolormodevm.bgBrightnessOption).assertEqual(ntfcolormodevm.darkConfig?.bgBrightnessOption);
      expect(ntfcolormodevm.foregroundDividerOption).assertEqual(ntfcolormodevm.darkConfig?.foregroundDividerOption);
      expect(ntfcolormodevm.fontForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundSecondaryDarkOption);
      expect(ntfcolormodevm.timestampForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundTertiaryGlossDarkOption);
      expect(ntfcolormodevm.bannerCardOption).assertEqual(BrightnessOptionUtils.bannerCardDarkOption);
      expect(ntfcolormodevm.buttonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customActionViewBgDark);
      expect(ntfcolormodevm.circleButtonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customWifiBgDark);
      expect(ntfcolormodevm.foregroundDividerForGroupOption).assertEqual(BrightnessOptionUtils.foregroundDividerForGroupDarkOption);
      expect(ntfcolormodevm.groupRemainderCountOptions).assertEqual(BrightnessOptionUtils.customWifiBgDark);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_dark_mode_to_false_when_curMode_is_COLOR_MODE_LIGHT', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper(LogDomain.NOTIFICATION);
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfcolormodevm.onModeChange(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);

      expect(ntfcolormodevm.isDarkMode).assertFalse();
      expect(ntfcolormodevm.bgBrightnessOption).assertEqual(ntfcolormodevm.lightConfig?.bgBrightnessOption);
      expect(ntfcolormodevm.foregroundDividerOption).assertEqual(ntfcolormodevm.lightConfig?.foregroundDividerOption);
      expect(ntfcolormodevm.fontForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundSecondaryOption);
      expect(ntfcolormodevm.timestampForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundTertiaryGlossOption);
      expect(ntfcolormodevm.bannerCardOption).assertEqual(BrightnessOptionUtils.bannerCardOption);
      expect(ntfcolormodevm.buttonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.getInstance().customActionViewBg);
      expect(ntfcolormodevm.circleButtonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customWifiBg);
      expect(ntfcolormodevm.foregroundDividerForGroupOption).assertEqual(BrightnessOptionUtils.foregroundDividerForGroupOption);
      expect(ntfcolormodevm.groupRemainderCountOptions).assertEqual(BrightnessOptionUtils.groupRemainderCount);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_dark_mode_to_true_when_curMode_is_COLOR_MODE_DARK', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper(LogDomain.NOTIFICATION);
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfcolormodevm.onModeChange(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);

      expect(ntfcolormodevm.isDarkMode).assertTrue();
      expect(ntfcolormodevm.bgBrightnessOption).assertEqual(ntfcolormodevm.darkConfig?.bgBrightnessOption);
      expect(ntfcolormodevm.foregroundDividerOption).assertEqual(ntfcolormodevm.darkConfig?.foregroundDividerOption);
      expect(ntfcolormodevm.fontForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundSecondaryDarkOption);
      expect(ntfcolormodevm.timestampForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundTertiaryGlossDarkOption);
      expect(ntfcolormodevm.bannerCardOption).assertEqual(BrightnessOptionUtils.bannerCardDarkOption);
      expect(ntfcolormodevm.buttonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customActionViewBgDark);
      expect(ntfcolormodevm.circleButtonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customWifiBgDark);
      expect(ntfcolormodevm.foregroundDividerForGroupOption).assertEqual(BrightnessOptionUtils.foregroundDividerForGroupDarkOption);
      expect(ntfcolormodevm.groupRemainderCountOptions).assertEqual(BrightnessOptionUtils.customWifiBgDark);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_dark_mode_to_false_when_curMode_is_COLOR_MODE_LIGHT', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper(LogDomain.NOTIFICATION);
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfcolormodevm.onModeChange(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);

      expect(ntfcolormodevm.isDarkMode).assertFalse();
      expect(ntfcolormodevm.bgBrightnessOption).assertEqual(ntfcolormodevm.lightConfig?.bgBrightnessOption);
      expect(ntfcolormodevm.foregroundDividerOption).assertEqual(ntfcolormodevm.lightConfig?.foregroundDividerOption);
      expect(ntfcolormodevm.fontForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundSecondaryOption);
      expect(ntfcolormodevm.timestampForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundTertiaryGlossOption);
      expect(ntfcolormodevm.bannerCardOption).assertEqual(BrightnessOptionUtils.bannerCardOption);
      expect(ntfcolormodevm.buttonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.getInstance().customActionViewBg);
      expect(ntfcolormodevm.circleButtonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customWifiBg);
      expect(ntfcolormodevm.foregroundDividerForGroupOption).assertEqual(BrightnessOptionUtils.foregroundDividerForGroupOption);
      expect(ntfcolormodevm.groupRemainderCountOptions).assertEqual(BrightnessOptionUtils.groupRemainderCount);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_dark_mode_to_true_when_curMode_is_COLOR_MODE_DARK', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper(LogDomain.NOTIFICATION);
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfcolormodevm.onModeChange(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);

      expect(ntfcolormodevm.isDarkMode).assertTrue();
      expect(ntfcolormodevm.bgBrightnessOption).assertEqual(ntfcolormodevm.darkConfig?.bgBrightnessOption);
      expect(ntfcolormodevm.foregroundDividerOption).assertEqual(ntfcolormodevm.darkConfig?.foregroundDividerOption);
      expect(ntfcolormodevm.fontForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundSecondaryDarkOption);
      expect(ntfcolormodevm.timestampForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundTertiaryGlossDarkOption);
      expect(ntfcolormodevm.bannerCardOption).assertEqual(BrightnessOptionUtils.bannerCardDarkOption);
      expect(ntfcolormodevm.buttonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customActionViewBgDark);
      expect(ntfcolormodevm.circleButtonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customWifiBgDark);
      expect(ntfcolormodevm.foregroundDividerForGroupOption).assertEqual(BrightnessOptionUtils.foregroundDividerForGroupDarkOption);
      expect(ntfcolormodevm.groupRemainderCountOptions).assertEqual(BrightnessOptionUtils.customWifiBgDark);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_dark_mode_to_false_when_curMode_is_COLOR_MODE_LIGHT', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper(LogDomain.NOTIFICATION);
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfcolormodevm.onModeChange(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);

      expect(ntfcolormodevm.isDarkMode).assertFalse();
      expect(ntfcolormodevm.bgBrightnessOption).assertEqual(ntfcolormodevm.lightConfig?.bgBrightnessOption);
      expect(ntfcolormodevm.foregroundDividerOption).assertEqual(ntfcolormodevm.lightConfig?.foregroundDividerOption);
      expect(ntfcolormodevm.fontForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundSecondaryOption);
      expect(ntfcolormodevm.timestampForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundTertiaryGlossOption);
      expect(ntfcolormodevm.bannerCardOption).assertEqual(BrightnessOptionUtils.bannerCardOption);
      expect(ntfcolormodevm.buttonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.getInstance().customActionViewBg);
      expect(ntfcolormodevm.circleButtonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customWifiBg);
      expect(ntfcolormodevm.foregroundDividerForGroupOption).assertEqual(BrightnessOptionUtils.foregroundDividerForGroupOption);
      expect(ntfcolormodevm.groupRemainderCountOptions).assertEqual(BrightnessOptionUtils.groupRemainderCount);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_dark_mode_to_true_when_curMode_is_COLOR_MODE_DARK', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper(LogDomain.NOTIFICATION);
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfcolormodevm.onModeChange(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);

      expect(ntfcolormodevm.isDarkMode).assertTrue();
      expect(ntfcolormodevm.bgBrightnessOption).assertEqual(ntfcolormodevm.darkConfig?.bgBrightnessOption);
      expect(ntfcolormodevm.foregroundDividerOption).assertEqual(ntfcolormodevm.darkConfig?.foregroundDividerOption);
      expect(ntfcolormodevm.fontForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundSecondaryDarkOption);
      expect(ntfcolormodevm.timestampForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundTertiaryGlossDarkOption);
      expect(ntfcolormodevm.bannerCardOption).assertEqual(BrightnessOptionUtils.bannerCardDarkOption);
      expect(ntfcolormodevm.buttonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customActionViewBgDark);
      expect(ntfcolormodevm.circleButtonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customWifiBgDark);
      expect(ntfcolormodevm.foregroundDividerForGroupOption).assertEqual(BrightnessOptionUtils.foregroundDividerForGroupDarkOption);
      expect(ntfcolormodevm.groupRemainderCountOptions).assertEqual(BrightnessOptionUtils.customWifiBgDark);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_dark_mode_to_false_when_curMode_is_COLOR_MODE_LIGHT', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper(LogDomain.NOTIFICATION);
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfcolormodevm.onModeChange(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);

      expect(ntfcolormodevm.isDarkMode).assertFalse();
      expect(ntfcolormodevm.bgBrightnessOption).assertEqual(ntfcolormodevm.lightConfig?.bgBrightnessOption);
      expect(ntfcolormodevm.foregroundDividerOption).assertEqual(ntfcolormodevm.lightConfig?.foregroundDividerOption);
      expect(ntfcolormodevm.fontForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundSecondaryOption);
      expect(ntfcolormodevm.timestampForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundTertiaryGlossOption);
      expect(ntfcolormodevm.bannerCardOption).assertEqual(BrightnessOptionUtils.bannerCardOption);
      expect(ntfcolormodevm.buttonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.getInstance().customActionViewBg);
      expect(ntfcolormodevm.circleButtonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customWifiBg);
      expect(ntfcolormodevm.foregroundDividerForGroupOption).assertEqual(BrightnessOptionUtils.foregroundDividerForGroupOption);
      expect(ntfcolormodevm.groupRemainderCountOptions).assertEqual(BrightnessOptionUtils.groupRemainderCount);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_dark_mode_to_true_when_curMode_is_COLOR_MODE_DARK', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper(LogDomain.NOTIFICATION);
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfcolormodevm.onModeChange(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);

      expect(ntfcolormodevm.isDarkMode).assertTrue();
      expect(ntfcolormodevm.bgBrightnessOption).assertEqual(ntfcolormodevm.darkConfig?.bgBrightnessOption);
      expect(ntfcolormodevm.foregroundDividerOption).assertEqual(ntfcolormodevm.darkConfig?.foregroundDividerOption);
      expect(ntfcolormodevm.fontForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundSecondaryDarkOption);
      expect(ntfcolormodevm.timestampForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundTertiaryGlossDarkOption);
      expect(ntfcolormodevm.bannerCardOption).assertEqual(BrightnessOptionUtils.bannerCardDarkOption);
      expect(ntfcolormodevm.buttonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customActionViewBgDark);
      expect(ntfcolormodevm.circleButtonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customWifiBgDark);
      expect(ntfcolormodevm.foregroundDividerForGroupOption).assertEqual(BrightnessOptionUtils.foregroundDividerForGroupDarkOption);
      expect(ntfcolormodevm.groupRemainderCountOptions).assertEqual(BrightnessOptionUtils.customWifiBgDark);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_dark_mode_to_false_when_curMode_is_COLOR_MODE_LIGHT', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper(LogDomain.NOTIFICATION);
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfcolormodevm.onModeChange(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);

      expect(ntfcolormodevm.isDarkMode).assertFalse();
      expect(ntfcolormodevm.bgBrightnessOption).assertEqual(ntfcolormodevm.lightConfig?.bgBrightnessOption);
      expect(ntfcolormodevm.foregroundDividerOption).assertEqual(ntfcolormodevm.lightConfig?.foregroundDividerOption);
      expect(ntfcolormodevm.fontForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundSecondaryOption);
      expect(ntfcolormodevm.timestampForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundTertiaryGlossOption);
      expect(ntfcolormodevm.bannerCardOption).assertEqual(BrightnessOptionUtils.bannerCardOption);
      expect(ntfcolormodevm.buttonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.getInstance().customActionViewBg);
      expect(ntfcolormodevm.circleButtonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customWifiBg);
      expect(ntfcolormodevm.foregroundDividerForGroupOption).assertEqual(BrightnessOptionUtils.foregroundDividerForGroupOption);
      expect(ntfcolormodevm.groupRemainderCountOptions).assertEqual(BrightnessOptionUtils.groupRemainderCount);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_dark_mode_to_true_when_curMode_is_COLOR_MODE_DARK', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper(LogDomain.NOTIFICATION);
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfcolormodevm.onModeChange(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);

      expect(ntfcolormodevm.isDarkMode).assertTrue();
      expect(ntfcolormodevm.bgBrightnessOption).assertEqual(ntfcolormodevm.darkConfig?.bgBrightnessOption);
      expect(ntfcolormodevm.foregroundDividerOption).assertEqual(ntfcolormodevm.darkConfig?.foregroundDividerOption);
      expect(ntfcolormodevm.fontForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundSecondaryDarkOption);
      expect(ntfcolormodevm.timestampForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundTertiaryGlossDarkOption);
      expect(ntfcolormodevm.bannerCardOption).assertEqual(BrightnessOptionUtils.bannerCardDarkOption);
      expect(ntfcolormodevm.buttonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customActionViewBgDark);
      expect(ntfcolormodevm.circleButtonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customWifiBgDark);
      expect(ntfcolormodevm.foregroundDividerForGroupOption).assertEqual(BrightnessOptionUtils.foregroundDividerForGroupDarkOption);
      expect(ntfcolormodevm.groupRemainderCountOptions).assertEqual(BrightnessOptionUtils.customWifiBgDark);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_dark_mode_to_false_when_curMode_is_COLOR_MODE_LIGHT', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper(LogDomain.NOTIFICATION);
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfcolormodevm.onModeChange(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);

      expect(ntfcolormodevm.isDarkMode).assertFalse();
      expect(ntfcolormodevm.bgBrightnessOption).assertEqual(ntfcolormodevm.lightConfig?.bgBrightnessOption);
      expect(ntfcolormodevm.foregroundDividerOption).assertEqual(ntfcolormodevm.lightConfig?.foregroundDividerOption);
      expect(ntfcolormodevm.fontForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundSecondaryOption);
      expect(ntfcolormodevm.timestampForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundTertiaryGlossOption);
      expect(ntfcolormodevm.bannerCardOption).assertEqual(BrightnessOptionUtils.bannerCardOption);
      expect(ntfcolormodevm.buttonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.getInstance().customActionViewBg);
      expect(ntfcolormodevm.circleButtonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customWifiBg);
      expect(ntfcolormodevm.foregroundDividerForGroupOption).assertEqual(BrightnessOptionUtils.foregroundDividerForGroupOption);
      expect(ntfcolormodevm.groupRemainderCountOptions).assertEqual(BrightnessOptionUtils.groupRemainderCount);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_dark_mode_to_true_when_curMode_is_COLOR_MODE_DARK', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper(LogDomain.NOTIFICATION);
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfcolormodevm.onModeChange(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);

      expect(ntfcolormodevm.isDarkMode).assertTrue();
      expect(ntfcolormodevm.bgBrightnessOption).assertEqual(ntfcolormodevm.darkConfig?.bgBrightnessOption);
      expect(ntfcolormodevm.foregroundDividerOption).assertEqual(ntfcolormodevm.darkConfig?.foregroundDividerOption);
      expect(ntfcolormodevm.fontForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundSecondaryDarkOption);
      expect(ntfcolormodevm.timestampForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundTertiaryGlossDarkOption);
      expect(ntfcolormodevm.bannerCardOption).assertEqual(BrightnessOptionUtils.bannerCardDarkOption);
      expect(ntfcolormodevm.buttonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customActionViewBgDark);
      expect(ntfcolormodevm.circleButtonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customWifiBgDark);
      expect(ntfcolormodevm.foregroundDividerForGroupOption).assertEqual(BrightnessOptionUtils.foregroundDividerForGroupDarkOption);
      expect(ntfcolormodevm.groupRemainderCountOptions).assertEqual(BrightnessOptionUtils.customWifiBgDark);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_dark_mode_to_false_when_curMode_is_COLOR_MODE_LIGHT', 0, async () => {
      let ntfcolormodevm: NtfColorModeVM = new NtfColorModeVM();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.createLogHelper(LogDomain.NOTIFICATION);
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfcolormodevm.onModeChange(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);

      expect(ntfcolormodevm.isDarkMode).assertFalse();
      expect(ntfcolormodevm.bgBrightnessOption).assertEqual(ntfcolormodevm.lightConfig?.bgBrightnessOption);
      expect(ntfcolormodevm.foregroundDividerOption).assertEqual(ntfcolormodevm.lightConfig?.foregroundDividerOption);
      expect(ntfcolormodevm.fontForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundSecondaryOption);
      expect(ntfcolormodevm.timestampForegroundBrightnessOptions).assertEqual(BrightnessOptionUtils.foregroundTertiaryGlossOption);
      expect(ntfcolormodevm.bannerCardOption).assertEqual(BrightnessOptionUtils.bannerCardOption);
      expect(ntfcolormodevm.buttonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.getInstance().customActionViewBg);
      expect(ntfcolormodevm.circleButtonBgBrightnessOptions).assertEqual(BrightnessOptionUtils.customWifiBg);
      expect(ntfcolormodevm.foregroundDividerForGroupOption).assertEqual(BrightnessOptionUtils.foregroundDividerForGroupOption);
      expect(ntfcolormodevm.groupRemainderCountOptions).assertEqual(BrightnessOptionUtils.groupRemainderCount);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });
}