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
import { NotificationActionView } from '../../../../main/ets/pages/common/NotificationActionView';
import { CommonData } from '@ohos/screenlockcommon';
import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { DeviceHelper } from '@ohos/frameworkwrapper';
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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {  } from '../../../../main/ets/pages/phone/NotificationContentInTint';
export default function Test() {
  describe('buildHideBannerNtfTitle_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_correct_text_when_appName_is_null', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.notificationType = NotificationType.NOTIFICATION_TYPE_HIDE_BANNER;
      entry.notificationSource = 'testSource';
      entry.notificationId = 1;
      entry.time = new Date().getTime();
      entry.title = 'testTitle';
      entry.content = 'testContent';
      entry.bannerDeformState = BannerDeformState.DEFAULT;
      entry.observed = new ObservedItem();
      entry.overlayIconStyle = new OverlayIconStyle();
      entry.ImmersiveAodStyle = new ImmersiveAodStyle();
      entry.hideBannerNtfContentObj = hideBannerNtfContentObj.createHideBannerNtfContentObj();
      entry.commonData = new CommonData();
      entry.logHelper = new LogHelper(LogDomain.LOG_DOMAIN_NOTIFICATION);
      entry.rtlUtil = new RTLUtil();
      entry.deviceHelper = new DeviceHelper();
      entry.resUtils = new ResUtils();
      entry.notificationActionView = new NotificationActionView();
      entry.swingTrackVm = new SwingTrackVm();
      entry.acoAppNames = [new AccessibilityAppName('test1'), new AccessibilityAppName('test2')];
      entry.notificationColorModeVM = new NtfColorModeVM();
      entry.notificationTimeVM = new NtfTimeVM();
      entry.ntfSingleItemVM = new NtfSingleItemVM();
      entry.appProtectedVm = new AppProtectedVm();
      entry.bannerMgr = new bannerMgr();
      entry.darkModeState = new DarkModeState();
      entry.fontScaleState = new FontScaleState();
      entry.fontScaleManager = fontScaleManager.getInstance();
      entry.immersiveKgMgr = immersiveKgMgr.getInstance();
      entry.notificationStyle = notificationStyle.getInstance();
      entry.measure = measure.getInstance();
      entry.acoAppNames = [new AccessibilityAppName('test1'), new AccessibilityAppName('test2')];
      entry.commonData.acoBundleName = 'com.test.app';
      entry.commonData.appLabelId = 1;
      entry.commonData.appIconId = 2;
      entry.commonData.settingsEnabled = true;
      entry.commonData.protectedEnabled = true;
      entry.commonData.hideBannerNtfEntry = entry;
      entry.commonData.bannerEntry = entry;
      entry.commonData.notificationEntry = entry;
      entry.commonData.notificationType = NotificationType.NOTIFICATION_TYPE_HIDE_BANNER;
      entry.commonData.notificationSource = 'testSource';
      entry.commonData.notificationId = 1;
      entry.commonData.time = new Date().getTime();
      entry.commonData.title = 'testTitle';
      entry.commonData.content = 'testContent';
      entry.commonData.bannerDeformState = BannerDeformState.DEFAULT;
      entry.commonData.observed = new ObservedItem();
      entry.commonData.overlayIconStyle = new OverlayIconStyle();
      entry.commonData.ImmersiveAodStyle = new ImmersiveAodStyle();
      entry.commonData.hideBannerNtfContentObj = hideBannerNtfContentObj.createHideBannerNtfContentObj();
      entry.commonData.commonData = new CommonData();
      entry.commonData.logHelper = new LogHelper(LogDomain.LOG_DOMAIN_NOTIFICATION);
      entry.commonData.rtlUtil = new RTLUtil();
      entry.commonData.deviceHelper = new DeviceHelper();
      entry.commonData.resUtils = new ResUtils();
      entry.commonData.notificationActionView = new NotificationActionView();
      entry.commonData.swingTrackVm = new SwingTrackVm();
      entry.commonData.acoAppNames = [new AccessibilityAppName('test1'), new AccessibilityAppName('test2')];
      entry.commonData.notificationColorModeVM = new NtfColorModeVM();
      entry.commonData.notificationTimeVM = new NtfTimeVM();
      entry.commonData.ntfSingleItemVM = new NtfSingleItemVM();
      entry.commonData.appProtectedVm = new AppProtectedVm();
      entry.commonData.bannerMgr = new bannerMgr();
      entry.commonData.darkModeState = new DarkModeState();
      entry.commonData.fontScaleState = new FontScaleState();
      entry.commonData.fontScaleManager = fontScaleManager.getInstance();
      entry.commonData.immersiveKgMgr = immersiveKgMgr.getInstance();
      entry.commonData.notificationStyle = notificationStyle.getInstance();
      entry.commonData.measure = measure.getInstance();

      let mocker: MockKit = new MockKit();


      let mockFontColor: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontColor);
      let mockFontSize: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      let mockMaxLines: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.maxLines);
      let mockTextOverflow: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      let mockFontWeight: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      let mockGetScaleSize: Function = mocker.mockFunc(FontScaleState.prototype, FontScaleState.prototype.getScaleSize);

      when(mockFontColor)(ArgumentMatchers.any).afterReturn(new TextAttribute());
      when(mockFontSize)(ArgumentMatchers.any).afterReturn(new TextAttribute());
      when(mockMaxLines)(ArgumentMatchers.any).afterReturn(new TextAttribute());
      when(mockTextOverflow)(ArgumentMatchers.any).afterReturn(new TextAttribute());
      when(mockFontWeight)(ArgumentMatchers.any).afterReturn(new TextAttribute());
      when(mockGetScaleSize)(ArgumentMatchers.any).afterReturn('100%');

      const result = entry.buildHideBannerNtfTitle();
      expect(result.appName?.value).assertEqual(null);

      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontColor);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.maxLines);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      mocker.ignoreMock(FontScaleState.prototype, FontScaleState.prototype.getScaleSize);
    });

    it('should_return_correct_text_when_appName_is_null', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.notificationType = NotificationType.NOTIFICATION_TYPE_HIDE_BANNER;
      entry.notificationSource = 'testSource';
      entry.notificationId = 1;
      entry.time = new Date().getTime();
      entry.title = 'testTitle';
      entry.content = 'testContent';
      entry.bannerDeformState = BannerDeformState.DEFAULT;
      entry.observed = new ObservedItem();
      entry.overlayIconStyle = new OverlayIconStyle();
      entry.ImmersiveAodStyle = new ImmersiveAodStyle();
      entry.hideBannerNtfContentObj = hideBannerNtfContentObj.createHideBannerNtfContentObj();
      entry.commonData = new CommonData();
      entry.logHelper = new LogHelper(LogDomain.LOG_DOMAIN_NOTIFICATION);
      entry.rtlUtil = new RTLUtil();
      entry.deviceHelper = new DeviceHelper();
      entry.resUtils = new ResUtils();
      entry.notificationActionView = new NotificationActionView();
      entry.swingTrackVm = new SwingTrackVm();
      entry.acoAppNames = [new AccessibilityAppName('test1'), new AccessibilityAppName('test2')];
      entry.notificationColorModeVM = new NtfColorModeVM();
      entry.notificationTimeVM = new NtfTimeVM();
      entry.ntfSingleItemVM = new NtfSingleItemVM();
      entry.appProtectedVm = new AppProtectedVm();
      entry.bannerMgr = new bannerMgr();
      entry.darkModeState = new DarkModeState();
      entry.fontScaleState = new FontScaleState();
      entry.fontScaleManager = fontScaleManager.getInstance();
      entry.immersiveKgMgr = immersiveKgMgr.getInstance();
      entry.notificationStyle = notificationStyle.getInstance();
      entry.measure = measure.getInstance();
      entry.acoAppNames = [new AccessibilityAppName('test1'), new AccessibilityAppName('test2')];
      entry.commonData.acoBundleName = 'com.test.app';
      entry.commonData.appLabelId = 1;
      entry.commonData.appIconId = 2;
      entry.commonData.settingsEnabled = true;
      entry.commonData.protectedEnabled = true;
      entry.commonData.hideBannerNtfEntry = entry;
      entry.commonData.bannerEntry = entry;
      entry.commonData.notificationEntry = entry;
      entry.commonData.notificationType = NotificationType.NOTIFICATION_TYPE_HIDE_BANNER;
      entry.commonData.notificationSource = 'testSource';
      entry.commonData.notificationId = 1;
      entry.commonData.time = new Date().getTime();
      entry.commonData.title = 'testTitle';
      entry.commonData.content = 'testContent';
      entry.commonData.bannerDeformState = BannerDeformState.DEFAULT;
      entry.commonData.observed = new ObservedItem();
      entry.commonData.overlayIconStyle = new OverlayIconStyle();
      entry.commonData.ImmersiveAodStyle = new ImmersiveAodStyle();
      entry.commonData.hideBannerNtfContentObj = hideBannerNtfContentObj.createHideBannerNtfContentObj();
      entry.commonData.commonData = new CommonData();
      entry.commonData.logHelper = new LogHelper(LogDomain.LOG_DOMAIN_NOTIFICATION);
      entry.commonData.rtlUtil = new RTLUtil();
      entry.commonData.deviceHelper = new DeviceHelper();
      entry.commonData.resUtils = new ResUtils();
      entry.commonData.notificationActionView = new NotificationActionView();
      entry.commonData.swingTrackVm = new SwingTrackVm();
      entry.commonData.acoAppNames = [new AccessibilityAppName('test1'), new AccessibilityAppName('test2')];
      entry.commonData.notificationColorModeVM = new NtfColorModeVM();
      entry.commonData.notificationTimeVM = new NtfTimeVM();
      entry.commonData.ntfSingleItemVM = new NtfSingleItemVM();
      entry.commonData.appProtectedVm = new AppProtectedVm();
      entry.commonData.bannerMgr = new bannerMgr();
      entry.commonData.darkModeState = new DarkModeState();
      entry.commonData.fontScaleState = new FontScaleState();
      entry.commonData.fontScaleManager = fontScaleManager.getInstance();
      entry.commonData.immersiveKgMgr = immersiveKgMgr.getInstance();
      entry.commonData.notificationStyle = notificationStyle.getInstance();
      entry.commonData.measure = measure.getInstance();

      let mocker: MockKit = new MockKit();


      let mockFontColor: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontColor);
      let mockFontSize: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      let mockMaxLines: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.maxLines);
      let mockTextOverflow: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      let mockFontWeight: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      let mockGetScaleSize: Function = mocker.mockFunc(FontScaleState.prototype, FontScaleState.prototype.getScaleSize);

      when(mockFontColor)(ArgumentMatchers.any).afterReturn(new TextAttribute());
      when(mockFontSize)(ArgumentMatchers.any).afterReturn(new TextAttribute());
      when(mockMaxLines)(ArgumentMatchers.any).afterReturn(new TextAttribute());
      when(mockTextOverflow)(ArgumentMatchers.any).afterReturn(new TextAttribute());
      when(mockFontWeight)(ArgumentMatchers.any).afterReturn(new TextAttribute());
      when(mockGetScaleSize)(ArgumentMatchers.any).afterReturn('100%');

      const result = entry.buildHideBannerNtfTitle();
      expect(result.appName?.value).assertEqual(null);

      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontColor);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.maxLines);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      mocker.ignoreMock(FontScaleState.prototype, FontScaleState.prototype.getScaleSize);
    });




    it('should_return_correct_text_when_appName_is_null', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.notificationType = NotificationType.NOTIFICATION_TYPE_HIDE_BANNER;
      entry.notificationSource = 'testSource';
      entry.notificationId = 1;
      entry.time = new Date().getTime();
      entry.title = 'testTitle';
      entry.content = 'testContent';
      entry.bannerDeformState = BannerDeformState.DEFAULT;
      entry.observed = new ObservedItem();
      entry.overlayIconStyle = new OverlayIconStyle();
      entry.ImmersiveAodStyle = new ImmersiveAodStyle();
      entry.hideBannerNtfContentObj = hideBannerNtfContentObj.createHideBannerNtfContentObj();
      entry.commonData = new CommonData();
      entry.logHelper = new LogHelper(LogDomain.LOG_DOMAIN_NOTIFICATION);
      entry.rtlUtil = new RTLUtil();
      entry.deviceHelper = new DeviceHelper();
      entry.resUtils = new ResUtils();
      entry.notificationActionView = new NotificationActionView();
      entry.swingTrackVm = new SwingTrackVm();
      entry.acoAppNames = [new AccessibilityAppName('test1'), new AccessibilityAppName('test2')];
      entry.notificationColorModeVM = new NtfColorModeVM();
      entry.notificationTimeVM = new NtfTimeVM();
      entry.ntfSingleItemVM = new NtfSingleItemVM();
      entry.appProtectedVm = new AppProtectedVm();
      entry.bannerMgr = new bannerMgr();
      entry.darkModeState = new DarkModeState();
      entry.fontScaleState = new FontScaleState();
      entry.fontScaleManager = fontScaleManager.getInstance();
      entry.immersiveKgMgr = immersiveKgMgr.getInstance();
      entry.notificationStyle = notificationStyle.getInstance();
      entry.measure = measure.getInstance();
      entry.acoAppNames = [new AccessibilityAppName('test1'), new AccessibilityAppName('test2')];
      entry.commonData.acoBundleName = 'com.test.app';
      entry.commonData.appLabelId = 1;
      entry.commonData.appIconId = 2;
      entry.commonData.settingsEnabled = true;
      entry.commonData.protectedEnabled = true;
      entry.commonData.hideBannerNtfEntry = entry;
      entry.commonData.bannerEntry = entry;
      entry.commonData.notificationEntry = entry;
      entry.commonData.notificationType = NotificationType.NOTIFICATION_TYPE_HIDE_BANNER;
      entry.commonData.notificationSource = 'testSource';
      entry.commonData.notificationId = 1;
      entry.commonData.time = new Date().getTime();
      entry.commonData.title = 'testTitle';
      entry.commonData.content = 'testContent';
      entry.commonData.bannerDeformState = BannerDeformState.DEFAULT;
      entry.commonData.observed = new ObservedItem();
      entry.commonData.overlayIconStyle = new OverlayIconStyle();
      entry.commonData.ImmersiveAodStyle = new ImmersiveAodStyle();
      entry.commonData.hideBannerNtfContentObj = hideBannerNtfContentObj.createHideBannerNtfContentObj();
      entry.commonData.commonData = new CommonData();
      entry.commonData.logHelper = new LogHelper(LogDomain.LOG_DOMAIN_NOTIFICATION);
      entry.commonData.rtlUtil = new RTLUtil();
      entry.commonData.deviceHelper = new DeviceHelper();
      entry.commonData.resUtils = new ResUtils();
      entry.commonData.notificationActionView = new NotificationActionView();
      entry.commonData.swingTrackVm = new SwingTrackVm();
      entry.commonData.acoAppNames = [new AccessibilityAppName('test1'), new AccessibilityAppName('test2')];
      entry.commonData.notificationColorModeVM = new NtfColorModeVM();
      entry.commonData.notificationTimeVM = new NtfTimeVM();
      entry.commonData.ntfSingleItemVM = new NtfSingleItemVM();
      entry.commonData.appProtectedVm = new AppProtectedVm();
      entry.commonData.bannerMgr = new bannerMgr();
      entry.commonData.darkModeState = new DarkModeState();
      entry.commonData.fontScaleState = new FontScaleState();
      entry.commonData.fontScaleManager = fontScaleManager.getInstance();
      entry.commonData.immersiveKgMgr = immersiveKgMgr.getInstance();
      entry.commonData.notificationStyle = notificationStyle.getInstance();
      entry.commonData.measure = measure.getInstance();

      let mocker: MockKit = new MockKit();


      let mockFontColor: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontColor);
      let mockFontSize: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      let mockMaxLines: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.maxLines);
      let mockTextOverflow: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      let mockFontWeight: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      let mockGetScaleSize: Function = mocker.mockFunc(FontScaleState.prototype, FontScaleState.prototype.getScaleSize);

      when(mockFontColor)(ArgumentMatchers.any).afterReturn(new TextAttribute());
      when(mockFontSize)(ArgumentMatchers.any).afterReturn(new TextAttribute());
      when(mockMaxLines)(ArgumentMatchers.any).afterReturn(new TextAttribute());
      when(mockTextOverflow)(ArgumentMatchers.any).afterReturn(new TextAttribute());
      when(mockFontWeight)(ArgumentMatchers.any).afterReturn(new TextAttribute());
      when(mockGetScaleSize)(ArgumentMatchers.any).afterReturn('100%');

      const result = entry.buildHideBannerNtfTitle();
      expect(result.appName?.value).assertEqual(null);




      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontColor);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.maxLines);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      mocker.ignoreMock(FontScaleState.prototype, FontScaleState.prototype.getScaleSize);
    });


    it('should_return_correct_text_when_appName_is_null', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.notificationType = NotificationType.NOTIFICATION_TYPE_HIDE_BANNER;
      entry.notificationSource = 'testSource';
      entry.notificationId = 1;
      entry.time = new Date().getTime();
      entry.title = 'testTitle';
      entry.content = 'testContent';
      entry.bannerDeformState = BannerDeformState.DEFAULT;
      entry.observed = new ObservedItem();
      entry.overlayIconStyle = new OverlayIconStyle();
      entry.ImmersiveAodStyle = new ImmersiveAodStyle();
      entry.hideBannerNtfContentObj = hideBannerNtfContentObj.createHideBannerNtfContentObj();
      entry.commonData = new CommonData();
      entry.logHelper = new LogHelper(LogDomain.LOG_DOMAIN_NOTIFICATION);
      entry.rtlUtil = new RTLUtil();
      entry.deviceHelper = new DeviceHelper();
      entry.resUtils = new ResUtils();
      entry.notificationActionView = new NotificationActionView();
      entry.swingTrackVm = new SwingTrackVm();
      entry.acoAppNames = [new AccessibilityAppName('test1'), new AccessibilityAppName('test2')];
      entry.notificationColorModeVM = new NtfColorModeVM();
      entry.notificationTimeVM = new NtfTimeVM();
      entry.ntfSingleItemVM = new NtfSingleItemVM();
      entry.appProtectedVm = new AppProtectedVm();
      entry.bannerMgr = new bannerMgr();
      entry.darkModeState = new DarkModeState();
      entry.fontScaleState = new FontScaleState();
      entry.fontScaleManager = fontScaleManager.getInstance();
      entry.immersiveKgMgr = immersiveKgMgr.getInstance();
      entry.notificationStyle = notificationStyle.getInstance();
      entry.measure = measure.getInstance();
      entry.acoAppNames = [new AccessibilityAppName('test1'), new AccessibilityAppName('test2')];
      entry.commonData.acoBundleName = 'com.test.app';
      entry.commonData.appLabelId = 1;
      entry.commonData.appIconId = 2;
      entry.commonData.settingsEnabled = true;
      entry.commonData.protectedEnabled = true;
      entry.commonData.hideBannerNtfEntry = entry;
      entry.commonData.bannerEntry = entry;
      entry.commonData.notificationEntry = entry;
      entry.commonData.notificationType = NotificationType.NOTIFICATION_TYPE_HIDE_BANNER;
      entry.commonData.notificationSource = 'testSource';
      entry.commonData.notificationId = 1;
      entry.commonData.time = new Date().getTime();
      entry.commonData.title = 'testTitle';
      entry.commonData.content = 'testContent';
      entry.commonData.bannerDeformState = BannerDeformState.DEFAULT;
      entry.commonData.observed = new ObservedItem();
      entry.commonData.overlayIconStyle = new OverlayIconStyle();
      entry.commonData.ImmersiveAodStyle = new ImmersiveAodStyle();
      entry.commonData.hideBannerNtfContentObj = hideBannerNtfContentObj.createHideBannerNtfContentObj();
      entry.commonData.commonData = new CommonData();
      entry.commonData.logHelper = new LogHelper(LogDomain.LOG_DOMAIN_NOTIFICATION);
      entry.commonData.rtlUtil = new RTLUtil();
      entry.commonData.deviceHelper = new DeviceHelper();
      entry.commonData.resUtils = new ResUtils();
      entry.commonData.notificationActionView = new NotificationActionView();
      entry.commonData.swingTrackVm = new SwingTrackVm();
      entry.commonData.acoAppNames = [new AccessibilityAppName('test1'), new AccessibilityAppName('test2')];
      entry.commonData.notificationColorModeVM = new NtfColorModeVM();
      entry.commonData.notificationTimeVM = new NtfTimeVM();
      entry.commonData.ntfSingleItemVM = new NtfSingleItemVM();
      entry.commonData.appProtectedVm = new AppProtectedVm();
      entry.commonData.bannerMgr = new bannerMgr();
      entry.commonData.darkModeState = new DarkModeState();
      entry.commonData.fontScaleState = new FontScaleState();
      entry.commonData.fontScaleManager = fontScaleManager.getInstance();
      entry.commonData.immersiveKgMgr = immersiveKgMgr.getInstance();
      entry.commonData.notificationStyle = notificationStyle.getInstance();
      entry.commonData.measure = measure.getInstance();

      let mocker: MockKit = new MockKit();

      let mockFontColor: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontColor);
      let mockFontSize: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      let mockMaxLines: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.maxLines);
      let mockTextOverflow: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      let mockFontWeight: Function = mocker.mockFunc(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      let mockGetScaleSize: Function = mocker.mockFunc(FontScaleState.prototype, FontScaleState.prototype.getScaleSize);

      when(mockFontColor)(ArgumentMatchers.any).afterReturn(new TextAttribute());
      when(mockFontSize)(ArgumentMatchers.any).afterReturn(new TextAttribute());
      when(mockMaxLines)(ArgumentMatchers.any).afterReturn(new TextAttribute());
      when(mockTextOverflow)(ArgumentMatchers.any).afterReturn(new TextAttribute());
      when(mockFontWeight)(ArgumentMatchers.any).afterReturn(new TextAttribute());
      when(mockGetScaleSize)(ArgumentMatchers.any).afterReturn('100%');

      const result = entry.buildHideBannerNtfTitle();
      expect(result.appName?.value).assertEqual(null);

      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontColor);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontSize);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.maxLines);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      mocker.ignoreMock(FontScaleState.prototype, FontScaleState.prototype.getScaleSize);
    });

    it('should_return_correct_text_when_appName_is_null', 0, () => {
      let entry: NotificationEntry = new NotificationEntry();
      entry.notificationType = NotificationType.NOTIFICATION_TYPE_HIDE_BANNER;
      entry.notificationSource = 'testSource';
      entry.notificationId = 1;
      entry.time = new Date().getTime();
      entry.title = 'testTitle';
      entry.content = 'testContent';
      entry.bannerDeformState = BannerDeformState.DEFAULT;
      entry.observed = new ObservedItem();
      entry.overlayIconStyle = new OverlayIconStyle();
      entry.ImmersiveAodStyle = new ImmersiveAodStyle();
      entry.commonData.bannerDeformState = BannerDeformState.DEFAULT;
      entry.commonData.observed = new ObservedItem();
      entry.commonData.overlayIconStyle = new OverlayIconStyle();
      entry.commonData.ImmersiveAodStyle = new ImmersiveAodStyle();
      entry.commonData.hideBannerNtfContentObj = hideBannerNtfContentObj.createHideBannerNtfContentObj();
      entry.commonData.commonData = new CommonData();
      entry.commonData.logHelper = new LogHelper(LogDomain.LOG_DOMAIN_NOTIFICATION);
      entry.commonData.rtlUtil = new RTLUtil();
      entry.commonData.deviceHelper = new DeviceHelper();
      entry.commonData.resUtils = new ResUtils();
      entry.commonData.notificationActionView = new NotificationActionView();
      entry.commonData.swingTrackVm = new SwingTrackVm();
      let mocker: MockKit = new MockKit();

      const result = entry.buildHideBannerNtfTitle();
      expect(result.appName?.value).assertEqual(null);

      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.textOverflow);
      mocker.ignoreMock(TextAttribute.prototype, TextAttribute.prototype.fontWeight);
      mocker.ignoreMock(FontScaleState.prototype, FontScaleState.prototype.getScaleSize);
    });
  });
}

