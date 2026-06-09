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
import { LengthMetrics } from '@ohos.arkui.node';
import {
  ArrayUtils,
  DeviceHelper,
  DeviceModeEnum,
  LogDomain,
  LogHelper,
  obtainLocalEvent,
  sEventManager
} from '@ohos/basiccommon';
import {
  AnimDataScene,
  AnimValue,
  CapsuleHideScene,
  CapsuleListState,
  capsuleStateMgr,
  ComponentAnimState,
  EventName,
  getIsInEmergencyOrThermalSafeMode,
  ImmersiveAodStyle,
  immersiveKgMgr,
  LiveAnimScene,
  LiveCapsuleData,
  LiveViewData,
  PropertyType,
  SysTypeCode
} from '@ohos/systemuicommon';
import { RootCapsule } from '@ohos/systemuicommon/Index';
import { liveCapsuleVm } from '../../../../main/ets/vm/LiveViewVm';
import { LiveViewConstants } from '../../../../main/ets/common/LiveViewConstants';
import { LiveViewAnimManager } from '../../../../main/ets/anim/LiveViewAnimManager';
import { CapsuleAnimComponent } from '../../../../main/ets/pages/capsule/CapsuleAnimComponent';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { ISlStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/interface/ISlStateChangeListener';
import {
  SlMainStateType,
  SlStaticStateType,
  SlSubStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {  } from '../../../../main/ets/pages/capsule/CapsuleListComponent';
export default function Test() {
  describe('build_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_build_capsule_list_when_capsule_list_is_valid_and_not_in_emergency_or_thermal_safe_mode', 0,
      async () => {
        let mocker: MockKit = new MockKit();
        let mockHasAnimCapsule: Function =
          mocker.mockFunc(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
        let mockOnCapsuleAreaChange: Function =
          mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.onCapsuleAreaChange);
        let mockGetCapsuleListAnimVm: Function =
          mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.getCapsuleListAnimVm);
        let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

        when(mockHasAnimCapsule)([ArgumentMatchers.any]).afterReturn(true);
        when(mockGetCapsuleListAnimVm)([]).afterReturn(new CapsuleAnimVm());

        capsuleStateMgr.capsuleListState.capsuleList = [new LiveViewData()];
        capsuleStateMgr.capsuleListState.animContentCapsule = new LiveViewData();
        capsuleStateMgr.capsuleListState.animOverlayCapsule = new LiveViewData();
        capsuleStateMgr.capsuleListState.animShadowCapsule = new LiveViewData();

        liveCapsuleVm.deviceModeState = DeviceModeEnum.DEVICE_MODE_NORMAL;
        liveCapsuleVm.isDeviceOuterHome = false;
        liveCapsuleVm.aodStyle = new ImmersiveAodStyle();
        liveCapsuleVm.aodStyle.isAod = false;

        liveCapsuleVm.build();

        expect(mockShowInfo)
          .assertCalledWith('capsuleList into hashCode:' +
            ArrayUtils.first(capsuleStateMgr.capsuleListState.capsuleList)?.hashCode);
        expect(mockHasAnimCapsule).assertCalledWith(AnimDataScene.SCENE_HIDE_CAPSULE);
        expect(mockGetCapsuleListAnimVm).assertCalled();
        expect(mockOnCapsuleAreaChange).assertCalledWith(LiveCapsuleData.capsuleArea);

        mocker.ignoreMock(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
        mocker.ignoreMock(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.getCapsuleListAnimVm);
        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      });

    it('should_not_build_capsule_list_when_capsule_list_is_invalid', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockHasAnimCapsule: Function =
        mocker.mockFunc(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
      let mockOnCapsuleAreaChange: Function =
        mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.onCapsuleAreaChange);
      let mockGetCapsuleListAnimVm: Function =
        mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.getCapsuleListAnimVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockHasAnimCapsule)([ArgumentMatchers.any]).afterReturn(true);
      when(mockGetCapsuleListAnimVm)([]).afterReturn(new CapsuleAnimVm());

      capsuleStateMgr.capsuleListState.capsuleList = [];

      liveCapsuleVm.build();

      expect(mockShowInfo).assertNotCalled();
      expect(mockHasAnimCapsule).assertNotCalled();
      expect(mockGetCapsuleListAnimVm).assertNotCalled();
      expect(mockOnCapsuleAreaChange).assertNotCalled();

      mocker.ignoreMock(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
      mocker.ignoreMock(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.getCapsuleListAnimVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_build_capsule_list_when_in_emergency_or_thermal_safe_mode', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockHasAnimCapsule: Function =
        mocker.mockFunc(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
      let mockOnCapsuleAreaChange: Function =
        mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.onCapsuleAreaChange);
      let mockGetCapsuleListAnimVm: Function =
        mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.getCapsuleListAnimVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockHasAnimCapsule)([ArgumentMatchers.any]).afterReturn(true);
      when(mockGetCapsuleListAnimVm)([]).afterReturn(new CapsuleAnimVm());

      capsuleStateMgr.capsuleListState.capsuleList = [new LiveViewData()];
      capsuleStateMgr.capsuleListState.animContentCapsule = new LiveViewData();
      capsuleStateMgr.capsuleListState.animOverlayCapsule = new LiveViewData();
      capsuleStateMgr.capsuleListState.animShadowCapsule = new LiveViewData();

      liveCapsuleVm.deviceModeState = DeviceModeEnum.DEVICE_MODE_EMERGENCY;
      liveCapsuleVm.isDeviceOuterHome = false;
      liveCapsuleVm.aodStyle = new ImmersiveAodStyle();
      liveCapsuleVm.aodStyle.isAod = false;

      liveCapsuleVm.build();

      expect(mockShowInfo).assertNotCalled();
      expect(mockHasAnimCapsule).assertNotCalled();
      expect(mockGetCapsuleListAnimVm).assertNotCalled();
      expect(mockOnCapsuleAreaChange).assertNotCalled();

      mocker.ignoreMock(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
      mocker.ignoreMock(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.getCapsuleListAnimVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_build_capsule_anim_component_when_has_anim_capsule_and_is_animating', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockHasAnimCapsule: Function =
        mocker.mockFunc(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
      let mockGetCapsuleListAnimVm: Function =
        mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.getCapsuleListAnimVm);
      let mockOnCapsuleAreaChange: Function =
        mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.onCapsuleAreaChange);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockHasAnimCapsule)([ArgumentMatchers.any]).afterReturn(true);
      when(mockGetCapsuleListAnimVm)([]).afterReturn(new CapsuleAnimVm());
      when(mockOnCapsuleAreaChange)([ArgumentMatchers.any]).afterReturnNothing();
      when(mockShowInfo)([ArgumentMatchers.any]).afterReturnNothing();

      capsuleStateMgr.capsuleListState.capsuleList = [new LiveViewData()];
      capsuleStateMgr.capsuleListState.animContentCapsule = new LiveViewData();
      capsuleStateMgr.capsuleListState.animOverlayCapsule = new LiveViewData();
      capsuleStateMgr.capsuleListState.animShadowCapsule = new LiveViewData();

      liveCapsuleVm.deviceModeState = DeviceModeEnum.DEVICE_MODE_NORMAL;
      liveCapsuleVm.isDeviceOuterHome = false;
      liveCapsuleVm.aodStyle = new ImmersiveAodStyle();
      liveCapsuleVm.aodStyle.isAod = false;
      liveCapsuleVm.liveAnimMgr.isAnimating = true;

      liveCapsuleVm.build();

      expect(mockShowInfo)
        .assertCalledWith('capsuleList into hashCode:' +
          ArrayUtils.first(capsuleStateMgr.capsuleListState.capsuleList)?.hashCode);
      expect(mockHasAnimCapsule).assertCalledWith(AnimDataScene.SCENE_HIDE_CAPSULE);
      expect(mockGetCapsuleListAnimVm).assertCalled();
      expect(mockOnCapsuleAreaChange).assertCalledWith(LiveCapsuleData.capsuleArea);

      mocker.ignoreMock(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
      mocker.ignoreMock(liveCapsuleVm.liveAnimMgr);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);

      it('should_build_capsule_list_when_capsule_list_is_valid_and_not_in_emergency_or_thermal_safe_mode', 0,
        async () => {
          let mocker: MockKit = new MockKit();
          let mockHasAnimCapsule: Function =
            mocker.mockFunc(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
          let mockOnCapsuleAreaChange: Function =
            mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.onCapsuleAreaChange);
          let mockGetCapsuleListAnimVm: Function =
            mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.getCapsuleListAnimVm);
          let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

          when(mockHasAnimCapsule)([ArgumentMatchers.any]).afterReturn(true);
          when(mockGetCapsuleListAnimVm)([]).afterReturn(new CapsuleAnimVm());

          capsuleStateMgr.capsuleListState.capsuleList = [new LiveViewData()];
          capsuleStateMgr.capsuleListState.animContentCapsule = new LiveViewData();
          capsuleStateMgr.capsuleListState.animOverlayCapsule = new LiveViewData();
          capsuleStateMgr.capsuleListState.animShadowCapsule = new LiveViewData();

          liveCapsuleVm.deviceModeState = DeviceModeEnum.DEVICE_MODE_NORMAL;
          liveCapsuleVm.isDeviceOuterHome = false;
          liveCapsuleVm.aodStyle = new ImmersiveAodStyle();
          liveCapsuleVm.aodStyle.isAod = false;

          liveCapsuleVm.build();

          expect(mockShowInfo)
            .assertCalledWith('capsuleList into hashCode:' +
              ArrayUtils.first(capsuleStateMgr.capsuleListState.capsuleList)?.hashCode);
          expect(mockHasAnimCapsule).assertCalledWith(AnimDataScene.SCENE_HIDE_CAPSULE);
          expect(mockGetCapsuleListAnimVm).assertCalled();
          expect(mockOnCapsuleAreaChange).assertCalledWith(LiveCapsuleData.capsuleArea);

          mocker.ignoreMock(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
          mocker.ignoreMock(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.getCapsuleListAnimVm);
          mocker.ignoreMock(LogHelper, LogHelper.showInfo);
        });

      it('should_not_build_capsule_list_when_capsule_list_is_invalid', 0, async () => {
        let mocker: MockKit = new MockKit();
        let mockHasAnimCapsule: Function =
          mocker.mockFunc(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
        let mockOnCapsuleAreaChange: Function =
          mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.onCapsuleAreaChange);
        let mockGetCapsuleListAnimVm: Function =
          mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.getCapsuleListAnimVm);
        let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

        when(mockHasAnimCapsule)([ArgumentMatchers.any]).afterReturn(true);
        when(mockGetCapsuleListAnimVm)([]).afterReturn(new CapsuleAnimVm());

        capsuleStateMgr.capsuleListState.capsuleList = [];

        liveCapsuleVm.build();

        expect(mockShowInfo).assertNotCalled();
        expect(mockHasAnimCapsule).assertNotCalled();
        expect(mockGetCapsuleListAnimVm).assertNotCalled();
        expect(mockOnCapsuleAreaChange).assertNotCalled();

        mocker.ignoreMock(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
        mocker.ignoreMock(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.getCapsuleListAnimVm);
        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      });

      it('should_not_build_capsule_list_when_in_emergency_or_thermal_safe_mode', 0, async () => {
        let mocker: MockKit = new MockKit();
        let mockHasAnimCapsule: Function =
          mocker.mockFunc(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
        let mockOnCapsuleAreaChange: Function =
          mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.onCapsuleAreaChange);
        let mockGetCapsuleListAnimVm: Function =
          mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.getCapsuleListAnimVm);
        let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

        when(mockHasAnimCapsule)([ArgumentMatchers.any]).afterReturn(true);
        when(mockGetCapsuleListAnimVm)([]).afterReturn(new CapsuleAnimVm());

        capsuleStateMgr.capsuleListState.capsuleList = [new LiveViewData()];
        capsuleStateMgr.capsuleListState.animContentCapsule = new LiveViewData();
        capsuleStateMgr.capsuleListState.animOverlayCapsule = new LiveViewData();
        capsuleStateMgr.capsuleListState.animShadowCapsule = new LiveViewData();

        liveCapsuleVm.deviceModeState = DeviceModeEnum.DEVICE_MODE_EMERGENCY;
        liveCapsuleVm.isDeviceOuterHome = false;
        liveCapsuleVm.aodStyle = new ImmersiveAodStyle();
        liveCapsuleVm.aodStyle.isAod = false;

        liveCapsuleVm.build();

        expect(mockShowInfo).assertNotCalled();
        expect(mockHasAnimCapsule).assertNotCalled();
        expect(mockGetCapsuleListAnimVm).assertNotCalled();
        expect(mockOnCapsuleAreaChange).assertNotCalled();

        mocker.ignoreMock(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
        mocker.ignoreMock(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.getCapsuleListAnimVm);
        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      });

      it('should_build_capsule_list_when_capsule_list_is_valid_and_not_in_emergency_or_thermal_safe_mode', 0,
        async () => {
          let mocker: MockKit = new MockKit();
          let mockHasAnimCapsule: Function =
            mocker.mockFunc(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
          let mockOnCapsuleAreaChange: Function =
            mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.onCapsuleAreaChange);
          let mockGetCapsuleListAnimVm: Function =
            mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.getCapsuleListAnimVm);
          let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

          when(mockHasAnimCapsule)([ArgumentMatchers.any]).afterReturn(true);
          when(mockGetCapsuleListAnimVm)([]).afterReturn(new CapsuleAnimVm());

          capsuleStateMgr.capsuleListState.capsuleList = [new LiveViewData()];
          capsuleStateMgr.capsuleListState.animContentCapsule = new LiveViewData();
          capsuleStateMgr.capsuleListState.animOverlayCapsule = new LiveViewData();
          capsuleStateMgr.capsuleListState.animShadowCapsule = new LiveViewData();

          liveCapsuleVm.deviceModeState = DeviceModeEnum.DEVICE_MODE_NORMAL;
          liveCapsuleVm.isDeviceOuterHome = false;
          liveCapsuleVm.aodStyle = new ImmersiveAodStyle();
          liveCapsuleVm.aodStyle.isAod = false;

          liveCapsuleVm.build();

          expect(mockShowInfo)
            .assertCalledWith('capsuleList into hashCode:' +
              ArrayUtils.first(capsuleStateMgr.capsuleListState.capsuleList)?.hashCode);
          expect(mockHasAnimCapsule).assertCalledWith(AnimDataScene.SCENE_HIDE_CAPSULE);
          expect(mockGetCapsuleListAnimVm).assertCalled();
          expect(mockOnCapsuleAreaChange).assertCalledWith(LiveCapsuleData.capsuleArea);

          mocker.ignoreMock(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
          mocker.ignoreMock(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.getCapsuleListAnimVm);
          mocker.ignoreMock(LogHelper, LogHelper.showInfo);
        });

      it('should_not_build_capsule_list_when_capsule_list_is_invalid', 0, async () => {
        let mocker: MockKit = new MockKit();
        let mockHasAnimCapsule: Function =
          mocker.mockFunc(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
        let mockOnCapsuleAreaChange: Function =
          mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.onCapsuleAreaChange);
        let mockGetCapsuleListAnimVm: Function =
          mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.getCapsuleListAnimVm);
        let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

        when(mockHasAnimCapsule)([ArgumentMatchers.any]).afterReturn(true);
        when(mockGetCapsuleListAnimVm)([]).afterReturn(new CapsuleAnimVm());

        capsuleStateMgr.capsuleListState.capsuleList = [];

        liveCapsuleVm.build();

        expect(mockShowInfo).assertNotCalled();
        expect(mockHasAnimCapsule).assertNotCalled();
        expect(mockGetCapsuleListAnimVm).assertNotCalled();
        expect(mockOnCapsuleAreaChange).assertNotCalled();

        mocker.ignoreMock(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
        mocker.ignoreMock(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.getCapsuleListAnimVm);
        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      });

      it('should_not_build_capsule_list_when_in_emergency_or_thermal_safe_mode', 0, async () => {
        let mocker: MockKit = new MockKit();
        let mockHasAnimCapsule: Function =
          mocker.mockFunc(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
        let mockOnCapsuleAreaChange: Function =
          mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.onCapsuleAreaChange);
        let mockGetCapsuleListAnimVm: Function =
          mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.getCapsuleListAnimVm);
        let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

        when(mockHasAnimCapsule)([ArgumentMatchers.any]).afterReturn(true);
        when(mockGetCapsuleListAnimVm)([]).afterReturn(new CapsuleAnimVm());

        capsuleStateMgr.capsuleListState.capsuleList = [new LiveViewData()];
        capsuleStateMgr.capsuleListState.animContentCapsule = new LiveViewData();
        capsuleStateMgr.capsuleListState.animOverlayCapsule = new LiveViewData();
        capsuleStateMgr.capsuleListState.animShadowCapsule = new LiveViewData();

        liveCapsuleVm.deviceModeState = DeviceModeEnum.DEVICE_MODE_EMERGENCY;
        liveCapsuleVm.isDeviceOuterHome = false;
        liveCapsuleVm.aodStyle = new ImmersiveAodStyle();
        liveCapsuleVm.aodStyle.isAod = false;

        liveCapsuleVm.build();

        expect(mockShowInfo).assertNotCalled();
        expect(mockHasAnimCapsule).assertNotCalled();
        expect(mockGetCapsuleListAnimVm).assertNotCalled();
        expect(mockOnCapsuleAreaChange).assertNotCalled();

        mocker.ignoreMock(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
        mocker.ignoreMock(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.getCapsuleListAnimVm);
        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      });

      it('should_build_capsule_list_when_capsule_list_is_valid_and_not_in_emergency_or_thermal_safe_mode', 0,
        async () => {
          let mocker: MockKit = new MockKit();
          let mockHasAnimCapsule: Function =
            mocker.mockFunc(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
          let mockOnCapsuleAreaChange: Function =
            mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.onCapsuleAreaChange);
          let mockGetCapsuleListAnimVm: Function =
            mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.getCapsuleListAnimVm);
          let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

          when(mockHasAnimCapsule)([ArgumentMatchers.any]).afterReturn(true);
          when(mockGetCapsuleListAnimVm)([]).afterReturn(new CapsuleAnimVm());

          capsuleStateMgr.capsuleListState.capsuleList = [new LiveViewData()];
          capsuleStateMgr.capsuleListState.animContentCapsule = new LiveViewData();
          capsuleStateMgr.capsuleListState.animOverlayCapsule = new LiveViewData();
          capsuleStateMgr.capsuleListState.animShadowCapsule = new LiveViewData();

          liveCapsuleVm.deviceModeState = DeviceModeEnum.DEVICE_MODE_NORMAL;
          liveCapsuleVm.isDeviceOuterHome = false;
          liveCapsuleVm.aodStyle = new ImmersiveAodStyle();
          liveCapsuleVm.aodStyle.isAod = false;

          liveCapsuleVm.build();

          expect(mockShowInfo)
            .assertCalledWith('capsuleList into hashCode:' +
              ArrayUtils.first(capsuleStateMgr.capsuleListState.capsuleList)?.hashCode);
          expect(mockHasAnimCapsule).assertCalledWith(AnimDataScene.SCENE_HIDE_CAPSULE);
          expect(mockGetCapsuleListAnimVm).assertCalled();
          expect(mockOnCapsuleAreaChange).assertCalledWith(LiveCapsuleData.capsuleArea);

          mocker.ignoreMock(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
          mocker.ignoreMock(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.getCapsuleListAnimVm);
          mocker.ignoreMock(LogHelper, LogHelper.showInfo);
        });

      it('should_not_build_capsule_list_when_capsule_list_is_invalid', 0, async () => {
        let mocker: MockKit = new MockKit();
        let mockHasAnimCapsule: Function =
          mocker.mockFunc(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
        let mockOnCapsuleAreaChange: Function =
          mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.onCapsuleAreaChange);
        let mockGetCapsuleListAnimVm: Function =
          mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.getCapsuleListAnimVm);
        let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

        when(mockHasAnimCapsule)([ArgumentMatchers.any]).afterReturn(true);
        when(mockGetCapsuleListAnimVm)([]).afterReturn(new CapsuleAnimVm());

        capsuleStateMgr.capsuleListState.capsuleList = [];

        liveCapsuleVm.build();

        expect(mockShowInfo).assertNotCalled();
        expect(mockHasAnimCapsule).assertNotCalled();
        expect(mockGetCapsuleListAnimVm).assertNotCalled();
        expect(mockOnCapsuleAreaChange).assertNotCalled();

        mocker.ignoreMock(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
        mocker.ignoreMock(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.getCapsuleListAnimVm);
        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      });

      it('should_not_build_capsule_list_when_in_emergency_or_thermal_safe_mode', 0, async () => {
        let mocker: MockKit = new MockKit();
        let mockHasAnimCapsule: Function =
          mocker.mockFunc(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
        let mockOnCapsuleAreaChange: Function =
          mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.onCapsuleAreaChange);
        let mockGetCapsuleListAnimVm: Function =
          mocker.mockFunc(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.getCapsuleListAnimVm);
        let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

        when(mockHasAnimCapsule)([ArgumentMatchers.any]).afterReturn(true);
        when(mockGetCapsuleListAnimVm)([]).afterReturn(new CapsuleAnimVm());

        capsuleStateMgr.capsuleListState.capsuleList = [new LiveViewData()];
        capsuleStateMgr.capsuleListState.animContentCapsule = new LiveViewData();
        capsuleStateMgr.capsuleListState.animOverlayCapsule = new LiveViewData();
        capsuleStateMgr.capsuleListState.animShadowCapsule = new LiveViewData();

        liveCapsuleVm.deviceModeState = DeviceModeEnum.DEVICE_MODE_EMERGENCY;
        liveCapsuleVm.isDeviceOuterHome = false;
        liveCapsuleVm.aodStyle = new ImmersiveAodStyle();
        liveCapsuleVm.aodStyle.isAod = false;

        liveCapsuleVm.build();

        expect(mockShowInfo).assertNotCalled();
        expect(mockHasAnimCapsule).assertNotCalled();
        expect(mockGetCapsuleListAnimVm).assertNotCalled();
        expect(mockOnCapsuleAreaChange).assertNotCalled();

        mocker.ignoreMock(capsuleStateMgr.capsuleListState, capsuleStateMgr.capsuleListState.hasAnimCapsule);
        mocker.ignoreMock(liveCapsuleVm.liveAnimMgr, liveCapsuleVm.liveAnimMgr.getCapsuleListAnimVm);
        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      });
    });
  })
}
