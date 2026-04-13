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
import TextCapsule from '../../../../../main/ets/liveview/component/capsule/TextCapsule';
import TimerCapsule from '../../../../../main/ets/liveview/component/capsule/TimerCapsule';
import ProgressCapsule from '../../../../../main/ets/liveview/component/capsule/ProgressCapsule';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { CapsuleShowType, CapsuleType, SysTypeCode } from '../../../../../main/ets/liveview/common/LiveConstants';
import { LiveCapsuleData } from '../../../../../main/ets/liveview/data/capsule/LiveCapsuleData';
import { LiveProgressData } from '../../../../../main/ets/liveview/data/extend/LiveProgressData';
import { LiveTimerData } from '../../../../../main/ets/liveview/data/extend/LiveTimerData';
import { LiveViewCapsuleStyle } from '../../../../../main/ets/liveview/common/LiveViewCapsuleStyle';
import { CapsuleAnimStyle } from '../../../../../main/ets/liveview/info/capsule/CapsuleAnimStyle';
import { CapsuleListState } from '../../../../../main/ets/liveview/info/capsule/CapsuleListState';
import { capsuleStateMgr } from '../../../../../main/ets/liveview/CapsuleManager';
import { ComponentAnimState } from '../../../../../main/ets/base/anim/ComponentAnimState';
import { AnimValue, PropertyType } from '../../../../../main/ets/base/anim/AnimConstants';
import { BannerPanelTypeState } from '../../../../../main/ets/banner/common/info/BannerState';
import { bannerMgr } from '../../../../../main/ets/banner/phone/BannerManager';
import { ColorUtil } from '../../../../../main/ets/utils/ColorUtil';
import { LengthMetrics } from '@ohos.arkui.node';
import { LiveViewData } from '../../../../../main/ets/liveview/data/LiveViewData';
import ScreenRecordCapsule from '../../../../../main/ets/liveview/component/capsule/ScreenRecordCapsule';
import { AccessibilityAppName } from '../../../../../main/ets/accessibility/AccessibilityAppName';
import { LiveAccessibilityUtil } from '../../../../../main/ets/liveview/common/liveAccessibilityUtil';
import { ImmersiveAodStyle, immersiveKgMgr } from '../../../../../main/ets/TsIndex';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {  } from '../../../../../main/ets/liveview/component/capsule/RootCapsule';
export default function Test() {
  describe('buildContentCapsule_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_render_text_capsule_when_capsule_data_is_text_type', 0, () => {
      let capsuleData: LiveCapsuleData = new LiveCapsuleData();
      capsuleData.capsuleType = CapsuleType.TYPE_TEXT;
      let liveViewData: LiveViewData = new LiveViewData();
      let capsuleState: CapsuleListState = new CapsuleListState();
      let capsuleAnimState: CapsuleAnimStyle = new CapsuleAnimStyle();
      capsuleState.capsuleShowType = CapsuleShowType.SHOW_TYPE_FULL;
      let capsuleStyle: LiveViewCapsuleStyle = new LiveViewCapsuleStyle();
      capsuleStyle.borderRadius = LengthMetrics.vp(10);
      capsuleData.capsuleStyle = capsuleStyle;
      capsuleData.capsuleAnimStyle = capsuleAnimState;
      capsuleData.capsuleState = capsuleState;
      let mocker: MockKit = new MockKit();
      let mockGetAccessibilityAppName: Function =
        mocker.mockFunc(LiveAccessibilityUtil, LiveAccessibilityUtil.getAccessibilityAppName);
      when(mockGetAccessibilityAppName)(ArgumentMatchers.any).afterReturn("Mocked Accessibility App Name");
      let mockGetCapsuleTextOpacity: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleTextOpacity);
      when(mockGetCapsuleTextOpacity)(ArgumentMatchers.any).afterReturn(1.0);
      let mockGetCapsuleIconOpacity: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleIconOpacity);
      when(mockGetCapsuleIconOpacity)(ArgumentMatchers.any).afterReturn(1.0);
      let mockGetFontColor: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getFontColor);
      when(mockGetFontColor)(ArgumentMatchers.any).afterReturn(ColorUtil.Color.COLOR_WHITE);
      let mockIsMarqueeEnabled: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.isMarqueeEnabled);
      when(mockIsMarqueeEnabled)(ArgumentMatchers.any).afterReturn(true);
      let mockCheckShouldHideContent: Function =
        mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.checkShouldHideContent);
      when(mockCheckShouldHideContent)(ArgumentMatchers.any).afterReturn(false);
      let mockGetCapsuleWidth: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleWidth);
      when(mockGetCapsuleWidth)(ArgumentMatchers.any).afterReturn(100);
      let mockGetCapsuleAnimState: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleAnimState);
      when(mockGetCapsuleAnimState)(ArgumentMatchers.any).afterReturn(new ComponentAnimState());
      let mockGetCapsuleState: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleState);
      when(mockGetCapsuleState)(ArgumentMatchers.any).afterReturn(capsuleState);
      let mockGetDeviceHelper: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockGetDeviceHelper)(ArgumentMatchers.any).afterReturn(false);
      let mockGetKgStyle: Function = mocker.mockFunc(immersiveKgMgr, immersiveKgMgr.getKgStyle);
      when(mockGetKgStyle)(ArgumentMatchers.any).afterReturn(ImmersiveAodStyle.IMMERSIVE_AOD_STYLE_LIGHT);
      let mockGetLiveViewCapsule: Function = mocker.mockFunc(LiveViewCapsule, LiveViewCapsule.buildContentCapsule);
      when(mockGetLiveViewCapsule)(ArgumentMatchers.any).afterReturn(new TextCapsule());
      let capsule: LiveViewCapsule = new LiveViewCapsule();
      capsule.buildContentCapsule();
      mocker.ignoreMock(LiveAccessibilityUtil, LiveAccessibilityUtil.getAccessibilityAppName);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleTextOpacity);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleIconOpacity);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getFontColor);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.isMarqueeEnabled);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.checkShouldHideContent);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleWidth);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleAnimState);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleState);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPC);
      mocker.ignoreMock(immersiveKgMgr, immersiveKgMgr.getKgStyle);
      mocker.ignoreMock(LiveViewCapsule, LiveViewCapsule.buildContentCapsule);
    });

    it('should_render_timer_capsule_when_capsule_data_is_timer_type', 0, () => {
      let capsuleData: LiveCapsuleData = new LiveCapsuleData();
      capsuleData.capsuleType = CapsuleType.TYPE_TIMER;
      let liveViewData: LiveViewData = new LiveViewData();
      let capsuleState: CapsuleListState = new CapsuleListState();
      let capsuleAnimState: CapsuleAnimStyle = new CapsuleAnimStyle();
      capsuleState.capsuleShowType = CapsuleShowType.SHOW_TYPE_FULL;
      let capsuleStyle: LiveViewCapsuleStyle = new LiveViewCapsuleStyle();
      capsuleStyle.borderRadius = LengthMetrics.vp(10);
      capsuleData.capsuleStyle = capsuleStyle;
      capsuleData.capsuleAnimStyle = capsuleAnimState;
      capsuleData.capsuleState = capsuleState;
      let mocker: MockKit = new MockKit();
      let mockGetKgStyle: Function = mocker.mockFunc(immersiveKgMgr, immersiveKgMgr.getKgStyle);
      when(mockGetKgStyle)(ArgumentMatchers.any).afterReturn(ImmersiveAodStyle.IMMERSIVE_AOD_STYLE_LIGHT);
      let mockGetLiveViewCapsule: Function = mocker.mockFunc(LiveViewCapsule, LiveViewCapsule.buildContentCapsule);
      when(mockGetLiveViewCapsule)(ArgumentMatchers.any).afterReturn(new TimerCapsule());
      let capsule: LiveViewCapsule = new LiveViewCapsule();
      capsule.buildContentCapsule();
      mocker.ignoreMock(LiveAccessibilityUtil, LiveAccessibilityUtil.getAccessibilityAppName);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleTextOpacity);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleIconOpacity);
    });

    it('should_render_text_capsule_when_capsule_data_is_text_type', 0, () => {
      let capsuleData: LiveCapsuleData = new LiveCapsuleData();
      capsuleData.capsuleType = CapsuleType.TYPE_TEXT;
      let liveViewData: LiveViewData = new LiveViewData();
      let capsuleState: CapsuleListState = new CapsuleListState();
      let capsuleAnimState: CapsuleAnimStyle = new CapsuleAnimStyle();
      capsuleState.capsuleShowType = CapsuleShowType.SHOW_TYPE_FULL;
      let capsuleStyle: LiveViewCapsuleStyle = new LiveViewCapsuleStyle();
      capsuleStyle.borderRadius = LengthMetrics.vp(10);
      capsuleData.capsuleStyle = capsuleStyle;
      capsuleData.capsuleAnimStyle = capsuleAnimState;
      capsuleData.capsuleState = capsuleState;
      let mocker: MockKit = new MockKit();
      let mockGetAccessibilityAppName: Function =
        mocker.mockFunc(LiveAccessibilityUtil, LiveAccessibilityUtil.getAccessibilityAppName);
      when(mockGetAccessibilityAppName)(ArgumentMatchers.any).afterReturn("Mocked Accessibility App Name");
      let mockGetCapsuleTextOpacity: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleTextOpacity);
      when(mockGetCapsuleTextOpacity)(ArgumentMatchers.any).afterReturn(1.0);
      let mockGetCapsuleIconOpacity: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleIconOpacity);
      when(mockGetCapsuleIconOpacity)(ArgumentMatchers.any).afterReturn(1.0);
      let mockGetFontColor: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getFontColor);
      when(mockGetFontColor)(ArgumentMatchers.any).afterReturn(ColorUtil.Color.COLOR_WHITE);
      let mockIsMarqueeEnabled: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.isMarqueeEnabled);
      when(mockIsMarqueeEnabled)(ArgumentMatchers.any).afterReturn(true);
      let mockCheckShouldHideContent: Function =
        mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.checkShouldHideContent);
      when(mockCheckShouldHideContent)(ArgumentMatchers.any).afterReturn(false);
      let mockGetCapsuleWidth: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleWidth);
      when(mockGetCapsuleWidth)(ArgumentMatchers.any).afterReturn(100);
      let mockGetCapsuleAnimState: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleAnimState);
      when(mockGetCapsuleAnimState)(ArgumentMatchers.any).afterReturn(new ComponentAnimState());
      let mockGetCapsuleState: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleState);
      when(mockGetCapsuleState)(ArgumentMatchers.any).afterReturn(capsuleState);
      let mockGetDeviceHelper: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockGetDeviceHelper)(ArgumentMatchers.any).afterReturn(false);
      let mockGetKgStyle: Function = mocker.mockFunc(immersiveKgMgr, immersiveKgMgr.getKgStyle);
      when(mockGetKgStyle)(ArgumentMatchers.any).afterReturn(ImmersiveAodStyle.IMMERSIVE_AOD_STYLE_LIGHT);
      let mockGetLiveViewCapsule: Function = mocker.mockFunc(LiveViewCapsule, LiveViewCapsule.buildContentCapsule);
      when(mockGetLiveViewCapsule)(ArgumentMatchers.any).afterReturn(new TextCapsule());
      let capsule: LiveViewCapsule = new LiveViewCapsule();
      capsule.buildContentCapsule();
      mocker.ignoreMock(LiveAccessibilityUtil, LiveAccessibilityUtil.getAccessibilityAppName);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleTextOpacity);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleIconOpacity);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getFontColor);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.isMarqueeEnabled);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.checkShouldHideContent);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleWidth);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleAnimState);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleState);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPC);
      mocker.ignoreMock(immersiveKgMgr, immersiveKgMgr.getKgStyle);
      mocker.ignoreMock(LiveViewCapsule, LiveViewCapsule.buildContentCapsule);
    });

    it('should_render_timer_capsule_when_capsule_data_is_timer_type', 0, () => {
      let capsuleData: LiveCapsuleData = new LiveCapsuleData();
      capsuleData.capsuleType = CapsuleType.TYPE_TIMER;
      let liveViewData: LiveViewData = new LiveViewData();
      let capsuleState: CapsuleListState = new CapsuleListState();
      let capsuleAnimState: CapsuleAnimStyle = new CapsuleAnimStyle();
      capsuleState.capsuleShowType = CapsuleShowType.SHOW_TYPE_FULL;
      let capsuleStyle: LiveViewCapsuleStyle = new LiveViewCapsuleStyle();
      capsuleStyle.borderRadius = LengthMetrics.vp(10);
      capsuleData.capsuleStyle = capsuleStyle;
      capsuleData.capsuleAnimStyle = capsuleAnimState;
      capsuleData.capsuleState = capsuleState;
      let mocker: MockKit = new MockKit();
      let mockGetAccessibilityAppName: Function =
        mocker.mockFunc(LiveAccessibilityUtil, LiveAccessibilityUtil.getAccessibilityAppName);
      when(mockGetAccessibilityAppName)(ArgumentMatchers.any).afterReturn("Mocked Accessibility App Name");
      let mockGetCapsuleTextOpacity: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleTextOpacity);
      when(mockGetCapsuleTextOpacity)(ArgumentMatchers.any).afterReturn(1.0);
      let mockGetCapsuleIconOpacity: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleIconOpacity);
      when(mockGetCapsuleIconOpacity)(ArgumentMatchers.any).afterReturn(1.0);
      let mockGetFontColor: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getFontColor);
      when(mockGetFontColor)(ArgumentMatchers.any).afterReturn(ColorUtil.Color.COLOR_WHITE);
      let mockIsMarqueeEnabled: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.isMarqueeEnabled);
      when(mockIsMarqueeEnabled)(ArgumentMatchers.any).afterReturn(true);
      let mockCheckShouldHideContent: Function =
        mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.checkShouldHideContent);
      when(mockCheckShouldHideContent)(ArgumentMatchers.any).afterReturn(false);
      let mockGetCapsuleWidth: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleWidth);
      when(mockGetCapsuleWidth)(ArgumentMatchers.any).afterReturn(100);
      let mockGetCapsuleAnimState: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleAnimState);
      when(mockGetCapsuleAnimState)(ArgumentMatchers.any).afterReturn(new ComponentAnimState());
      let mockGetCapsuleState: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleState);
      when(mockGetCapsuleState)(ArgumentMatchers.any).afterReturn(capsuleState);
      let mockGetDeviceHelper: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockGetDeviceHelper)(ArgumentMatchers.any).afterReturn(false);
      let mockGetKgStyle: Function = mocker.mockFunc(immersiveKgMgr, immersiveKgMgr.getKgStyle);
      when(mockGetKgStyle)(ArgumentMatchers.any).afterReturn(ImmersiveAodStyle.IMMERSIVE_AOD_STYLE_LIGHT);
      let mockGetLiveViewCapsule: Function = mocker.mockFunc(LiveViewCapsule, LiveViewCapsule.buildContentCapsule);
      when(mockGetLiveViewCapsule)(ArgumentMatchers.any).afterReturn(new TimerCapsule());
      let capsule: LiveViewCapsule = new LiveViewCapsule();
      capsule.buildContentCapsule();
      mocker.ignoreMock(LiveAccessibilityUtil, LiveAccessibilityUtil.getAccessibilityAppName);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleTextOpacity);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleIconOpacity);
    });

    it('should_render_text_capsule_when_capsule_data_is_text_type', 0, () => {
      let capsuleData: LiveCapsuleData = new LiveCapsuleData();
      capsuleData.capsuleType = CapsuleType.TYPE_TEXT;
      let liveViewData: LiveViewData = new LiveViewData();
      let capsuleState: CapsuleListState = new CapsuleListState();
      let capsuleAnimState: CapsuleAnimStyle = new CapsuleAnimStyle();
      capsuleState.capsuleShowType = CapsuleShowType.SHOW_TYPE_FULL;
      let capsuleStyle: LiveViewCapsuleStyle = new LiveViewCapsuleStyle();
      capsuleStyle.borderRadius = LengthMetrics.vp(10);
      capsuleData.capsuleStyle = capsuleStyle;
      capsuleData.capsuleAnimStyle = capsuleAnimState;
      capsuleData.capsuleState = capsuleState;
      let mocker: MockKit = new MockKit();
      let mockGetAccessibilityAppName: Function =
        mocker.mockFunc(LiveAccessibilityUtil, LiveAccessibilityUtil.getAccessibilityAppName);
      when(mockGetAccessibilityAppName)(ArgumentMatchers.any).afterReturn("Mocked Accessibility App Name");
      let mockGetCapsuleTextOpacity: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleTextOpacity);
      when(mockGetCapsuleTextOpacity)(ArgumentMatchers.any).afterReturn(1.0);
      let mockGetCapsuleIconOpacity: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleIconOpacity);
      when(mockGetCapsuleIconOpacity)(ArgumentMatchers.any).afterReturn(1.0);
      let mockGetFontColor: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getFontColor);
      when(mockGetFontColor)(ArgumentMatchers.any).afterReturn(ColorUtil.Color.COLOR_WHITE);
      let mockIsMarqueeEnabled: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.isMarqueeEnabled);
      when(mockIsMarqueeEnabled)(ArgumentMatchers.any).afterReturn(true);
      let mockCheckShouldHideContent: Function =
        mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.checkShouldHideContent);
      when(mockCheckShouldHideContent)(ArgumentMatchers.any).afterReturn(false);
      let mockGetCapsuleWidth: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleWidth);
      when(mockGetCapsuleWidth)(ArgumentMatchers.any).afterReturn(100);
      let mockGetCapsuleAnimState: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleAnimState);
      when(mockGetCapsuleAnimState)(ArgumentMatchers.any).afterReturn(new ComponentAnimState());
      let mockGetCapsuleState: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleState);
      when(mockGetCapsuleState)(ArgumentMatchers.any).afterReturn(capsuleState);
      let mockGetDeviceHelper: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockGetDeviceHelper)(ArgumentMatchers.any).afterReturn(false);
      let mockGetKgStyle: Function = mocker.mockFunc(immersiveKgMgr, immersiveKgMgr.getKgStyle);
      when(mockGetKgStyle)(ArgumentMatchers.any).afterReturn(ImmersiveAodStyle.IMMERSIVE_AOD_STYLE_LIGHT);
      let mockGetLiveViewCapsule: Function = mocker.mockFunc(LiveViewCapsule, LiveViewCapsule.buildContentCapsule);
      when(mockGetLiveViewCapsule)(ArgumentMatchers.any).afterReturn(new TextCapsule());
      let capsule: LiveViewCapsule = new LiveViewCapsule();
      capsule.buildContentCapsule();
      mocker.ignoreMock(LiveAccessibilityUtil, LiveAccessibilityUtil.getAccessibilityAppName);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleTextOpacity);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleIconOpacity);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getFontColor);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.isMarqueeEnabled);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.checkShouldHideContent);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleWidth);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleAnimState);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleState);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPC);
      mocker.ignoreMock(immersiveKgMgr, immersiveKgMgr.getKgStyle);
      mocker.ignoreMock(LiveViewCapsule, LiveViewCapsule.buildContentCapsule);
    });

    it('should_render_timer_capsule_when_capsule_data_is_timer_type', 0, () => {
      let capsuleData: LiveCapsuleData = new LiveCapsuleData();
      capsuleData.capsuleType = CapsuleType.TYPE_TIMER;
      let liveViewData: LiveViewData = new LiveViewData();
      let capsuleState: CapsuleListState = new CapsuleListState();
      let capsuleAnimState: CapsuleAnimStyle = new CapsuleAnimStyle();
      capsuleState.capsuleShowType = CapsuleShowType.SHOW_TYPE_FULL;
      let capsuleStyle: LiveViewCapsuleStyle = new LiveViewCapsuleStyle();
      capsuleStyle.borderRadius = LengthMetrics.vp(10);
      capsuleData.capsuleStyle = capsuleStyle;
      capsuleData.capsuleAnimStyle = capsuleAnimState;
      capsuleData.capsuleState = capsuleState;
      let mocker: MockKit = new MockKit();
      let mockGetAccessibilityAppName: Function =
        mocker.mockFunc(LiveAccessibilityUtil, LiveAccessibilityUtil.getAccessibilityAppName);
      when(mockGetAccessibilityAppName)(ArgumentMatchers.any).afterReturn("Mocked Accessibility App Name");
      let mockGetCapsuleTextOpacity: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleTextOpacity);
      when(mockGetCapsuleTextOpacity)(ArgumentMatchers.any).afterReturn(1.0);
      let mockGetCapsuleIconOpacity: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleIconOpacity);
      when(mockGetCapsuleIconOpacity)(ArgumentMatchers.any).afterReturn(1.0);
      let mockGetFontColor: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getFontColor);
      when(mockGetFontColor)(ArgumentMatchers.any).afterReturn(ColorUtil.Color.COLOR_WHITE);
      let mockIsMarqueeEnabled: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.isMarqueeEnabled);
      when(mockIsMarqueeEnabled)(ArgumentMatchers.any).afterReturn(true);
      let mockCheckShouldHideContent: Function =
        mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.checkShouldHideContent);
      when(mockCheckShouldHideContent)(ArgumentMatchers.any).afterReturn(false);
      let mockGetCapsuleWidth: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleWidth);
      when(mockGetCapsuleWidth)(ArgumentMatchers.any).afterReturn(100);
      let mockGetCapsuleAnimState: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleAnimState);
      when(mockGetCapsuleAnimState)(ArgumentMatchers.any).afterReturn(new ComponentAnimState());
      let mockGetCapsuleState: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleState);
      when(mockGetCapsuleState)(ArgumentMatchers.any).afterReturn(capsuleState);
      let mockGetDeviceHelper: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockGetDeviceHelper)(ArgumentMatchers.any).afterReturn(false);
      let mockGetKgStyle: Function = mocker.mockFunc(immersiveKgMgr, immersiveKgMgr.getKgStyle);
      when(mockGetKgStyle)(ArgumentMatchers.any).afterReturn(ImmersiveAodStyle.IMMERSIVE_AOD_STYLE_LIGHT);
      let mockGetLiveViewCapsule: Function = mocker.mockFunc(LiveViewCapsule, LiveViewCapsule.buildContentCapsule);
      when(mockGetLiveViewCapsule)(ArgumentMatchers.any).afterReturn(new TimerCapsule());
      let capsule: LiveViewCapsule = new LiveViewCapsule();
      capsule.buildContentCapsule();
      mocker.ignoreMock(LiveAccessibilityUtil, LiveAccessibilityUtil.getAccessibilityAppName);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleTextOpacity);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleIconOpacity);
    });

    it('should_render_text_capsule_when_capsule_data_is_text_type', 0, () => {
      let capsuleData: LiveCapsuleData = new LiveCapsuleData();
      capsuleData.capsuleType = CapsuleType.TYPE_TEXT;
      let liveViewData: LiveViewData = new LiveViewData();
      let capsuleState: CapsuleListState = new CapsuleListState();
      let capsuleAnimState: CapsuleAnimStyle = new CapsuleAnimStyle();
      capsuleState.capsuleShowType = CapsuleShowType.SHOW_TYPE_FULL;
      let capsuleStyle: LiveViewCapsuleStyle = new LiveViewCapsuleStyle();
      capsuleStyle.borderRadius = LengthMetrics.vp(10);
      capsuleData.capsuleStyle = capsuleStyle;
      capsuleData.capsuleAnimStyle = capsuleAnimState;
      capsuleData.capsuleState = capsuleState;
      let mocker: MockKit = new MockKit();
      let mockGetAccessibilityAppName: Function =
        mocker.mockFunc(LiveAccessibilityUtil, LiveAccessibilityUtil.getAccessibilityAppName);
      when(mockGetAccessibilityAppName)(ArgumentMatchers.any).afterReturn("Mocked Accessibility App Name");
      let mockGetCapsuleTextOpacity: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleTextOpacity);
      when(mockGetCapsuleTextOpacity)(ArgumentMatchers.any).afterReturn(1.0);
      let mockGetCapsuleIconOpacity: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleIconOpacity);
      when(mockGetCapsuleIconOpacity)(ArgumentMatchers.any).afterReturn(1.0);
      let mockGetFontColor: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getFontColor);
      when(mockGetFontColor)(ArgumentMatchers.any).afterReturn(ColorUtil.Color.COLOR_WHITE);
      let mockIsMarqueeEnabled: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.isMarqueeEnabled);
      when(mockIsMarqueeEnabled)(ArgumentMatchers.any).afterReturn(true);
      let mockCheckShouldHideContent: Function =
        mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.checkShouldHideContent);
      when(mockCheckShouldHideContent)(ArgumentMatchers.any).afterReturn(false);
      let mockGetCapsuleWidth: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleWidth);
      when(mockGetCapsuleWidth)(ArgumentMatchers.any).afterReturn(100);
      let mockGetCapsuleAnimState: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleAnimState);
      when(mockGetCapsuleAnimState)(ArgumentMatchers.any).afterReturn(new ComponentAnimState());
      let mockGetCapsuleState: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleState);
      when(mockGetCapsuleState)(ArgumentMatchers.any).afterReturn(capsuleState);
      let mockGetDeviceHelper: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockGetDeviceHelper)(ArgumentMatchers.any).afterReturn(false);
      let mockGetKgStyle: Function = mocker.mockFunc(immersiveKgMgr, immersiveKgMgr.getKgStyle);
      when(mockGetKgStyle)(ArgumentMatchers.any).afterReturn(ImmersiveAodStyle.IMMERSIVE_AOD_STYLE_LIGHT);
      let mockGetLiveViewCapsule: Function = mocker.mockFunc(LiveViewCapsule, LiveViewCapsule.buildContentCapsule);
      when(mockGetLiveViewCapsule)(ArgumentMatchers.any).afterReturn(new TextCapsule());
      let capsule: LiveViewCapsule = new LiveViewCapsule();
      capsule.buildContentCapsule();
      mocker.ignoreMock(LiveAccessibilityUtil, LiveAccessibilityUtil.getAccessibilityAppName);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleTextOpacity);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleIconOpacity);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getFontColor);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.isMarqueeEnabled);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.checkShouldHideContent);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleWidth);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleAnimState);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleState);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPC);
      mocker.ignoreMock(immersiveKgMgr, immersiveKgMgr.getKgStyle);
      mocker.ignoreMock(LiveViewCapsule, LiveViewCapsule.buildContentCapsule);
    });

    it('should_render_timer_capsule_when_capsule_data_is_timer_type', 0, () => {
      let capsuleData: LiveCapsuleData = new LiveCapsuleData();
      capsuleData.capsuleType = CapsuleType.TYPE_TIMER;
      let liveViewData: LiveViewData = new LiveViewData();
      let capsuleState: CapsuleListState = new CapsuleListState();
      let capsuleAnimState: CapsuleAnimStyle = new CapsuleAnimStyle();
      capsuleState.capsuleShowType = CapsuleShowType.SHOW_TYPE_FULL;
      let capsuleStyle: LiveViewCapsuleStyle = new LiveViewCapsuleStyle();
      capsuleStyle.borderRadius = LengthMetrics.vp(10);
      capsuleData.capsuleStyle = capsuleStyle;
      capsuleData.capsuleAnimStyle = capsuleAnimState;
      capsuleData.capsuleState = capsuleState;
      let mocker: MockKit = new MockKit();
      let mockGetAccessibilityAppName: Function =
        mocker.mockFunc(LiveAccessibilityUtil, LiveAccessibilityUtil.getAccessibilityAppName);
      when(mockGetAccessibilityAppName)(ArgumentMatchers.any).afterReturn("Mocked Accessibility App Name");
      let mockGetCapsuleTextOpacity: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleTextOpacity);
      when(mockGetCapsuleTextOpacity)(ArgumentMatchers.any).afterReturn(1.0);
      let mockGetCapsuleIconOpacity: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleIconOpacity);
      when(mockGetCapsuleIconOpacity)(ArgumentMatchers.any).afterReturn(1.0);
      let mockGetFontColor: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getFontColor);
      when(mockGetFontColor)(ArgumentMatchers.any).afterReturn(ColorUtil.Color.COLOR_WHITE);
      let mockIsMarqueeEnabled: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.isMarqueeEnabled);
      when(mockIsMarqueeEnabled)(ArgumentMatchers.any).afterReturn(true);
      let mockCheckShouldHideContent: Function =
        mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.checkShouldHideContent);
      when(mockCheckShouldHideContent)(ArgumentMatchers.any).afterReturn(false);
      let mockGetCapsuleWidth: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleWidth);
      when(mockGetCapsuleWidth)(ArgumentMatchers.any).afterReturn(100);
      let mockGetCapsuleAnimState: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleAnimState);
      when(mockGetCapsuleAnimState)(ArgumentMatchers.any).afterReturn(new ComponentAnimState());
      let mockGetCapsuleState: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleState);
      when(mockGetCapsuleState)(ArgumentMatchers.any).afterReturn(capsuleState);
      let mockGetDeviceHelper: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockGetDeviceHelper)(ArgumentMatchers.any).afterReturn(false);
      let mockGetKgStyle: Function = mocker.mockFunc(immersiveKgMgr, immersiveKgMgr.getKgStyle);
      when(mockGetKgStyle)(ArgumentMatchers.any).afterReturn(ImmersiveAodStyle.IMMERSIVE_AOD_STYLE_LIGHT);
      let mockGetLiveViewCapsule: Function = mocker.mockFunc(LiveViewCapsule, LiveViewCapsule.buildContentCapsule);
      when(mockGetLiveViewCapsule)(ArgumentMatchers.any).afterReturn(new TimerCapsule());
      let capsule: LiveViewCapsule = new LiveViewCapsule();
      capsule.buildContentCapsule();
      mocker.ignoreMock(LiveAccessibilityUtil, LiveAccessibilityUtil.getAccessibilityAppName);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleTextOpacity);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleIconOpacity);
    });

    it('should_render_text_capsule_when_capsule_data_is_text_type', 0, () => {
      let capsuleData: LiveCapsuleData = new LiveCapsuleData();
      capsuleData.capsuleType = CapsuleType.TYPE_TEXT;
      let liveViewData: LiveViewData = new LiveViewData();
      let capsuleState: CapsuleListState = new CapsuleListState();
      let capsuleAnimState: CapsuleAnimStyle = new CapsuleAnimStyle();
      capsuleState.capsuleShowType = CapsuleShowType.SHOW_TYPE_FULL;
      let capsuleStyle: LiveViewCapsuleStyle = new LiveViewCapsuleStyle();
      capsuleStyle.borderRadius = LengthMetrics.vp(10);
      capsuleData.capsuleStyle = capsuleStyle;
      capsuleData.capsuleAnimStyle = capsuleAnimState;
      capsuleData.capsuleState = capsuleState;
      let mocker: MockKit = new MockKit();
      let mockGetAccessibilityAppName: Function =
        mocker.mockFunc(LiveAccessibilityUtil, LiveAccessibilityUtil.getAccessibilityAppName);
      when(mockGetAccessibilityAppName)(ArgumentMatchers.any).afterReturn("Mocked Accessibility App Name");
      let mockGetCapsuleTextOpacity: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleTextOpacity);
      when(mockGetCapsuleTextOpacity)(ArgumentMatchers.any).afterReturn(1.0);
      let mockGetCapsuleIconOpacity: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleIconOpacity);
      when(mockGetCapsuleIconOpacity)(ArgumentMatchers.any).afterReturn(1.0);
      let mockGetFontColor: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getFontColor);
      when(mockGetFontColor)(ArgumentMatchers.any).afterReturn(ColorUtil.Color.COLOR_WHITE);
      let mockIsMarqueeEnabled: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.isMarqueeEnabled);
      when(mockIsMarqueeEnabled)(ArgumentMatchers.any).afterReturn(true);
      let mockCheckShouldHideContent: Function =
        mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.checkShouldHideContent);
      when(mockCheckShouldHideContent)(ArgumentMatchers.any).afterReturn(false);
      let mockGetCapsuleWidth: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleWidth);
      when(mockGetCapsuleWidth)(ArgumentMatchers.any).afterReturn(100);
      let mockGetCapsuleAnimState: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleAnimState);
      when(mockGetCapsuleAnimState)(ArgumentMatchers.any).afterReturn(new ComponentAnimState());
      let mockGetCapsuleState: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleState);
      when(mockGetCapsuleState)(ArgumentMatchers.any).afterReturn(capsuleState);
      let capsule: LiveViewCapsule = new LiveViewCapsule();
      capsule.buildContentCapsule();
      mocker.ignoreMock(LiveAccessibilityUtil, LiveAccessibilityUtil.getAccessibilityAppName);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleTextOpacity);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleIconOpacity);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getFontColor);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.isMarqueeEnabled);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.checkShouldHideContent);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleWidth);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleAnimState);
      mocker.ignoreMock(capsuleStateMgr, capsuleStateMgr.getCapsuleState);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPC);
    });

    it('should_render_timer_capsule_when_capsule_data_is_timer_type', 0, () => {
      let capsuleData: LiveCapsuleData = new LiveCapsuleData();
      capsuleData.capsuleType = CapsuleType.TYPE_TIMER;
      let liveViewData: LiveViewData = new LiveViewData();
      let capsuleState: CapsuleListState = new CapsuleListState();
      let capsuleAnimState: CapsuleAnimStyle = new CapsuleAnimStyle();
      capsuleState.capsuleShowType = CapsuleShowType.SHOW_TYPE_FULL;
      let capsuleStyle: LiveViewCapsuleStyle = new LiveViewCapsuleStyle();
      capsuleStyle.borderRadius = LengthMetrics.vp(10);
      capsuleData.capsuleStyle = capsuleStyle;
      capsuleData.capsuleAnimStyle = capsuleAnimState;
      capsuleData.capsuleState = capsuleState;
      let mocker: MockKit = new MockKit();
      let mockGetCapsuleWidth: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleWidth);
      when(mockGetCapsuleWidth)(ArgumentMatchers.any).afterReturn(100);
      let mockGetCapsuleAnimState: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleAnimState);
      when(mockGetCapsuleAnimState)(ArgumentMatchers.any).afterReturn(new ComponentAnimState());
      let mockGetCapsuleState: Function = mocker.mockFunc(capsuleStateMgr, capsuleStateMgr.getCapsuleState);
      when(mockGetCapsuleState)(ArgumentMatchers.any).afterReturn(capsuleState);
      let mockGetDeviceHelper: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockGetDeviceHelper)(ArgumentMatchers.any).afterReturn(false);
      when(mockGetLiveViewCapsule)(ArgumentMatchers.any).afterReturn(new TimerCapsule());
      let capsule: LiveViewCapsule = new LiveViewCapsule();
    });
  })
}

