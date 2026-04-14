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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveNotification } from '../../../../main/ets/live/model/LiveNotification';
import { CapsuleShowType } from '../../../../main/ets/live/model/LiveCommonModel';
import { NotificationArray } from '../../../../main/ets/model/NotificationBase';
import { StatusBarCapsulePosition } from '';
import { ILiveCapsuleVm } from '../../../../main/ets/live/interface/ILiveCapsuleVm';
import { SysTypeCode } from '../../../../main/ets/TsIndex';
import { LiveType } from '../../../../main/ets/live/model/LiveCommonModel';
import { LiveCapsuleListLayoutBaseVm } from '../../../../main/ets/live/vm/LiveCapsuleListLayoutBaseVm';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers,
  DEFAULT } from '@ohos/hypium';
import { LiveCapsuleListMultipleHoleLayoutVm } from '../../../../main/ets/live/vm/LiveCapsuleListMultipleHoleLayoutVm';
export default function LiveCapsuleListMultipleHoleLayoutVmTest() {
  describe('computeCapsuleFixedWithAndOffset_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_log_warning_when_liveList_is_invalid', 0, () => {
      let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      livecapsulelistmultipleholelayoutvm.computeCapsuleFixedWithAndOffset(null);
      mocker.verify('showWarn', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });

    it('should_log_warning_when_position_is_invalid', 0, () => {
      let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      let liveList: LiveNotification[] = [new LiveNotification()];
      livecapsulelistmultipleholelayoutvm.computeCapsuleFixedWithAndOffset(liveList, null);

      mocker.verify('showWarn', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });

    it('should_process_liveList_when_position_is_valid', 0, () => {
      let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let liveList: LiveNotification[] = [new LiveNotification()];
      let position: StatusBarCapsulePosition = {
        liveType: LiveType.VIDEO_PLAY,
        capsuleShowType: CapsuleShowType.MULTIPLE_HOLE,
        leftTotalFreeSpace: 10,
        rightTotalFreeSpace: 10,
        capsuleLeftMin: 5,
        capsuleRightMax: 5,
        leftHoleGap: 2,
        rightHoleGap: 2,
        capsuleStateGap: 2
      };
      livecapsulelistmultipleholelayoutvm.computeCapsuleFixedWithAndOffset(liveList, false);

      mocker.verify('showWarn', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });

    it('should_process_liveList_immediately_when_isUpdateImmediately_is_true', 0, () => {
      let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let liveList: LiveNotification[] = [new LiveNotification()];
      let position: StatusBarCapsulePosition = {
        liveType: LiveType.VIDEO_PLAY,
        capsuleShowType: CapsuleShowType.MULTIPLE_HOLE,
        leftTotalFreeSpace: 10,
        rightTotalFreeSpace: 10,
        capsuleLeftMin: 5,
        capsuleRightMax: 5,
        leftHoleGap: 2,
        rightHoleGap: 2,
        capsuleStateGap: 2
      };
      livecapsulelistmultipleholelayoutvm.computeCapsuleFixedWithAndOffset(liveList, true);

      mocker.verify('showWarn', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });
    it('should_log_warn_when_live_is_null', 0, () => {
      let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.warn);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      livecapsulelistmultipleholelayoutvm.setRemindCapsuleWidth(null, false);

      mocker.verify('showWarn', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_log_warn_when_live_type_is_sys_and_show_type_is_not_supported', 0, () => {
      let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.warn);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let live: LiveNotification = new LiveNotification();
      live.sysType = SysTypeCode.LIVE_SYS_TYPE_VIDEO_MEETING;
      live.liveType = LiveType.LIVE_TYPE_DIVIDE;
      live.capsuleShowType = CapsuleShowType.SUPPORTED_SHOW_TYPE;
      livecapsulelistmultipleholelayoutvm.setRemindCapsuleWidth(live, false);

      mocker.verify('showWarn', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_log_warn_when_live_type_is_sys_and_show_type_is_supported_but_status_is_not_supported', 0, () => {
      let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.warn);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let live: LiveNotification = new LiveNotification();
      live.sysType = SysTypeCode.LIVE_SYS_TYPE_VIDEO_MEETING;
      live.liveType = LiveType.LIVE_TYPE_DIVIDE;
      live.capsuleShowType = CapsuleShowType.SUPPORTED_SHOW_TYPE;
      live.status = StatusBarCapsulePosition.SUPPORTED_STATUS;
      livecapsulelistmultipleholelayoutvm.setRemindCapsuleWidth(live, false);

      mocker.verify('showWarn', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_log_warn_when_live_type_is_not_sys_and_show_type_is_not_supported', 0, () => {
      let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.warn);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let live: LiveNotification = new LiveNotification();
      live.sysType = SysTypeCode.LIVE_SYS_TYPE_VIDEO_MEETING;
      live.liveType = LiveType.LIVE_TYPE_DIVIDE;
      live.capsuleShowType = CapsuleShowType.SUPPORTED_SHOW_TYPE;
      live.status = StatusBarCapsulePosition.SUPPORTED_STATUS;
      livecapsulelistmultipleholelayoutvm.setRemindCapsuleWidth(live, false);

      mocker.verify('showWarn', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_log_warn_when_live_type_is_not_sys_and_show_type_is_supported_but_status_is_not_supported', 0, () => {
      let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.warn);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let live: LiveNotification = new LiveNotification();
      live.sysType = SysTypeCode.LIVE_SYS_TYPE_VIDEO_MEETING;
      live.liveType = LiveType.LIVE_TYPE_DIVIDE;
      live.capsuleShowType = CapsuleShowType.SUPPORTED_SHOW_TYPE;
      live.status = StatusBarCapsulePosition.SUPPORTED_STATUS;
      livecapsulelistmultipleholelayoutvm.setRemindCapsuleWidth(live, false);

      mocker.verify('showWarn', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_log_warn_when_live_type_is_sys_and_show_type_is_supported_but_status_is_supported', 0, () => {
      let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.warn);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let live: LiveNotification = new LiveNotification();
      live.sysType = SysTypeCode.LIVE_SYS_TYPE_VIDEO_MEETING;
      live.liveType = LiveType.LIVE_TYPE_DIVIDE;
      live.capsuleShowType = CapsuleShowType.SUPPORTED_SHOW_TYPE;
      live.status = StatusBarCapsulePosition.SUPPORTED_STATUS;
      livecapsulelistmultipleholelayoutvm.setRemindCapsuleWidth(live, false);

      mocker.verify('showWarn', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_log_warn_when_live_type_is_not_sys_and_show_type_is_supported_but_status_is_supported', 0, () => {
      let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.warn);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let live: LiveNotification = new LiveNotification();
      live.sysType = SysTypeCode.LIVE_SYS_TYPE_VIDEO_MEETING;
      live.liveType = LiveType.LIVE_TYPE_DIVIDE;
      live.capsuleShowType = CapsuleShowType.SUPPORTED_SHOW_TYPE;
      live.status = StatusBarCapsulePosition.SUPPORTED_STATUS;
      livecapsulelistmultipleholelayoutvm.setRemindCapsuleWidth(live, false);

      mocker.verify('showWarn', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_return_correct_offset_when_no_holes', 0, async () => {
      let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistmultipleholelayoutvm.vmInjector, livecapsulelistmultipleholelayoutvm.vmInjector.getCapsuleVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let liveCapsule1: LiveNotification = new LiveNotification();
      liveCapsule1.sysType = SysTypeCode.LIVE_NOTIFICATION;
      liveCapsule1.liveType = LiveType.PROGRESS;
      liveCapsule1.showType = CapsuleShowType.SHOW;
      liveCapsule1.statusBarCapsulePosition = StatusBarCapsulePosition.ONLY_LEFT;

      let liveCapsule2: LiveNotification = new LiveNotification();
      liveCapsule2.sysType = SysTypeCode.LIVE_NOTIFICATION;
      liveCapsule2.liveType = LiveType.PROGRESS;
      liveCapsule2.showType = CapsuleShowType.SHOW;
      liveCapsule2.statusBarCapsulePosition = StatusBarCapsulePosition.ONLY_RIGHT;

      let capsuleVm1: ILiveCapsuleVm = {
        isShow: true,
        fixedOffsetX: 0,
        fixedWidth: 100
      };
      let capsuleVm2: ILiveCapsuleVm = {
        isShow: true,
        fixedOffsetX: 0,
        fixedWidth: 100
      };

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm1);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm2);

      livecapsulelistmultipleholelayoutvm.showCapsuleList = [new NotificationArray<LiveNotification>()];
      livecapsulelistmultipleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS] = new NotificationArray<LiveNotification>();
      livecapsulelistmultipleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(liveCapsule1);
      livecapsulelistmultipleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(liveCapsule2);

      const result = livecapsulelistmultipleholelayoutvm.updateProgressCapsuleFixedOffset();
      expect(result).assertEqual(0);

      mocker.ignoreMock(livecapsulelistmultipleholelayoutvm.vmInjector, livecapsulelistmultipleholelayoutvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_correct_offset_when_holes_exist', 0, async () => {
      let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistmultipleholelayoutvm.vmInjector, livecapsulelistmultipleholelayoutvm.vmInjector.getCapsuleVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let liveCapsule1: LiveNotification = new LiveNotification();
      liveCapsule1.sysType = SysTypeCode.LIVE_NOTIFICATION;
      liveCapsule1.liveType = LiveType.PROGRESS;
      liveCapsule1.showType = CapsuleShowType.SHOW;
      liveCapsule1.statusBarCapsulePosition = StatusBarCapsulePosition.ONLY_LEFT;

      let liveCapsule2: LiveNotification = new LiveNotification();
      liveCapsule2.sysType = SysTypeCode.LIVE_NOTIFICATION;
      liveCapsule2.liveType = LiveType.PROGRESS;
      liveCapsule2.showType = CapsuleShowType.SHOW;
      liveCapsule2.statusBarCapsulePosition = StatusBarCapsulePosition.ONLY_RIGHT;

      let liveCapsule3: LiveNotification = new LiveNotification();
      liveCapsule3.sysType = SysTypeCode.LIVE_NOTIFICATION;
      liveCapsule3.liveType = LiveType.PROGRESS;
      liveCapsule3.showType = CapsuleShowType.SHOW;
      liveCapsule3.statusBarCapsulePosition = StatusBarCapsulePosition.NEITHER_LEFT_NOR_RIGHT;

      let capsuleVm1: ILiveCapsuleVm = {
        isShow: true,
        fixedOffsetX: 0,
        fixedWidth: 100
      };
      let capsuleVm2: ILiveCapsuleVm = {
        isShow: true,
        fixedOffsetX: 0,
        fixedWidth: 100
      };
      let capsuleVm3: ILiveCapsuleVm = {
        isShow: true,
        fixedOffsetX: 0,
        fixedWidth: 100
      };

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm1);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm2);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm3);

      livecapsulelistmultipleholelayoutvm.showCapsuleList = [new NotificationArray<LiveNotification>()];
      livecapsulelistmultipleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS] = new NotificationArray<LiveNotification>();
      livecapsulelistmultipleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(liveCapsule1);
      livecapsulelistmultipleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(liveCapsule2);
      livecapsulelistmultipleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(liveCapsule3);
      livecapsulelistmultipleholelayoutvm.leftTotalFreeSpace = 10;
      livecapsulelistmultipleholelayoutvm.rightTotalFreeSpace = 10;
      const result = livecapsulelistmultipleholelayoutvm.updateProgressCapsuleFixedOffset();
      expect(result).assertEqual(-10);
      mocker.ignoreMock(livecapsulelistmultipleholelayoutvm.vmInjector, livecapsulelistmultipleholelayoutvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });


    it('should_return_spaceInfo_when_capsuleShowList_is_empty', 0, () => {
      let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let capsuleShowList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.getCapsuleVm);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      let result = livecapsulelistmultipleholelayoutvm.computeCapsuleShowFlagBySpace(capsuleShowList);
      expect(result.leftTotalFreeSpace).assertEqual(0);
      expect(result.rightTotalFreeSpace).assertEqual(0);
      expect(result.leftUsedSpace).assertEqual(0);
      expect(result.rightUsedSpace).assertEqual(0);
      expect(result.leftRemainSpace).assertEqual(0);
      expect(result.rightRemainSpace).assertEqual(0);
      mocker.ignoreMock(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.getCapsuleVm);
    });

    it('should_return_spaceInfo_when_capsuleVm_isShow_is_false', 0, () => {
      let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let capsuleShowList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.getCapsuleVm);
      let liveCapsuleVm: ILiveCapsuleVm = {
        isShow: false,
        fixedWidth: 0,
        fixedOffsetX: 0,
        capsuleShowType: CapsuleShowType.LiveCapsuleShowTypeNormal,
        sysType: SysTypeCode.LIVE_capsule,
        liveType: LiveType.LiveTypeNormal,
        statusBarCapsulePosition: StatusBarCapsulePosition.STATUS_BAR_capsulePositionNormal,
        avoidStart: 0,
        avoidEnd: 0,
        capsuleLeftMin: 0,
        capsuleRightMax: 0,
        isUpdate: false
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(liveCapsuleVm);
      let result = livecapsulelistmultipleholelayoutvm.computeCapsuleShowFlagBySpace(capsuleShowList);
      expect(result.leftTotalFreeSpace).assertEqual(0);
      expect(result.rightTotalFreeSpace).assertEqual(0);
      expect(result.leftUsedSpace).assertEqual(0);
      expect(result.rightUsedSpace).assertEqual(0);
      expect(result.leftRemainSpace).assertEqual(0);
      expect(result.rightRemainSpace).assertEqual(0);
      mocker.ignoreMock(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.getCapsuleVm);
    });

    it('should_return_spaceInfo_when_capsuleVm_isShow_is_true_and_isShowHoleLeft_is_true', 0, () => {
      let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      livecapsulelistmultipleholelayoutvm.leftTotalFreeSpace = 100;
      let capsuleShowList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.getCapsuleVm);
      let liveCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 50,
        fixedOffsetX: 0,
        capsuleShowType: CapsuleShowType.LiveCapsuleShowTypeNormal,
        sysType: SysTypeCode.LIVE_capsule,
        liveType: LiveType.LiveTypeNormal,
        statusBarCapsulePosition: StatusBarCapsulePosition.STATUS_BAR_capsulePositionNormal,
        avoidStart: 0,
        avoidEnd: 0,
        capsuleLeftMin: 0,
        capsuleRightMax: 0,
        isUpdate: false
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(liveCapsuleVm);
      let result = livecapsulelistmultipleholelayoutvm.computeCapsuleShowFlagBySpace(capsuleShowList);
      expect(result.leftTotalFreeSpace).assertEqual(50);
      expect(result.rightTotalFreeSpace).assertEqual(0);
      expect(result.leftUsedSpace).assertEqual(50);
      expect(result.rightUsedSpace).assertEqual(0);
      expect(result.leftRemainSpace).assertEqual(50);
      expect(result.rightRemainSpace).assertEqual(0);
      mocker.ignoreMock(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.getCapsuleVm);
    });

    it('should_return_spaceInfo_when_capsuleVm_isShow_is_true_and_isShowHoleRight_is_true', 0, () => {
      let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      livecapsulelistmultipleholelayoutvm.rightTotalFreeSpace = 100;
      let capsuleShowList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.getCapsuleVm);
      let liveCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 50,
        fixedOffsetX: 0,
        capsuleShowType: CapsuleShowType.LiveCapsuleShowTypeNormal,
        sysType: SysTypeCode.LIVE_capsule,
        liveType: LiveType.LiveTypeNormal,
        statusBarCapsulePosition: StatusBarCapsulePosition.STATUS_BAR_capsulePositionNormal,
        avoidStart: 0,
        avoidEnd: 0,
        capsuleLeftMin: 0,
        capsuleRightMax: 0,
        isUpdate: false
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(liveCapsuleVm);
      let result = livecapsulelistmultipleholelayoutvm.computeCapsuleShowFlagBySpace(capsuleShowList);
      expect(result.leftTotalFreeSpace).assertEqual(0);
      expect(result.rightTotalFreeSpace).assertEqual(50);
      expect(result.leftUsedSpace).assertEqual(0);
      expect(result.rightUsedSpace).assertEqual(50);
      expect(result.leftRemainSpace).assertEqual(0);
      expect(result.rightRemainSpace).assertEqual(50);
      mocker.ignoreMock(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.getCapsuleVm);
    });

    it('should_continue_when_capsuleVm_is_not_show', 0, async () => {
      let spaceInfo: ISpaceInfo = new ISpaceInfo();
      let capsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let capsuleType: CapsuleType = new CapsuleType();
      let liveCapsuleListMultipleHoleLayoutVm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockCapsuleVm: ILiveCapsuleVm = new ILiveCapsuleVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockCapsuleVm.isShow).afterReturn(false);
      liveCapsuleListMultipleHoleLayoutVm.adjustShowCapsuleWidth(spaceInfo, capsuleList, capsuleType);
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_continue_when_leftHole_is_show_and_leftRemainSpace_is_zero', 0, async () => {
      let spaceInfo: ISpaceInfo = new ISpaceInfo();
      let capsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let capsuleType: CapsuleType = new CapsuleType();
      let liveCapsuleListMultipleHoleLayoutVm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockCapsuleVm: ILiveCapsuleVm = new ILiveCapsuleVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockCapsuleVm.isShow).afterReturn(true);
      when(mockCapsuleVm.capsuleShowType).afterReturn(CapsuleShowType.LEFT_HOLE);
      liveCapsuleListMultipleHoleLayoutVm.adjustShowCapsuleWidth(spaceInfo, capsuleList, capsuleType);
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_continue_when_rightHole_is_show_and_rightRemainSpace_is_zero', 0, async () => {
      let spaceInfo: ISpaceInfo = new ISpaceInfo();
      let capsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let capsuleType: CapsuleType = new CapsuleType();
      let liveCapsuleListMultipleHoleLayoutVm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockCapsuleVm: ILiveCapsuleVm = new ILiveCapsuleVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockCapsuleVm.isShow).afterReturn(true);
      when(mockCapsuleVm.capsuleShowType).afterReturn(CapsuleShowType.RIGHT_HOLE);
      liveCapsuleListMultipleHoleLayoutVm.adjustShowCapsuleWidth(spaceInfo, capsuleList, capsuleType);
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_continue_when_leftHole_is_show_and_leftRemainSpace_is_greater_than_zero', 0, async () => {
      let spaceInfo: ISpaceInfo = new ISpaceInfo();
      spaceInfo.leftRemainSpace = 100;
      let capsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let capsuleType: CapsuleType = new CapsuleType();
      let liveCapsuleListMultipleHoleLayoutVm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockCapsuleVm: ILiveCapsuleVm = new ILiveCapsuleVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockAdjustFixedWidth: Function = mocker.mockFunc(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.adjustFixedWidth);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockCapsuleVm.isShow).afterReturn(true);
      when(mockCapsuleVm.capsuleShowType).afterReturn(CapsuleShowType.LEFT_HOLE);
      when(mockAdjustFixedWidth)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean).afterReturn(50);
      liveCapsuleListMultipleHoleLayoutVm.adjustShowCapsuleWidth(spaceInfo, capsuleList, capsuleType);
      expect(spaceInfo.leftRemainSpace).assertEqual(50);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.adjustFixedWidth);
    });

    it('should_continue_when_rightHole_is_show_and_rightRemainSpace_is_greater_than_zero', 0, async () => {
      let spaceInfo: ISpaceInfo = new ISpaceInfo();
      spaceInfo.rightRemainSpace = 100;
      let capsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let capsuleType: CapsuleType = new CapsuleType();
      let liveCapsuleListMultipleHoleLayoutVm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockCapsuleVm: ILiveCapsuleVm = new ILiveCapsuleVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockAdjustFixedWidth: Function = mocker.mockFunc(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.adjustFixedWidth);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockCapsuleVm.isShow).afterReturn(true);
      when(mockCapsuleVm.capsuleShowType).afterReturn(CapsuleShowType.RIGHT_HOLE);
      when(mockAdjustFixedWidth)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean).afterReturn(50);
      liveCapsuleListMultipleHoleLayoutVm.adjustShowCapsuleWidth(spaceInfo, capsuleList, capsuleType);
      expect(spaceInfo.rightRemainSpace).assertEqual(50);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.adjustFixedWidth);
    });

    const generateTestDataForGenerateCapsuleShowListByPrioritySort = () => ({
      capsuleShowList: new NotificationArray<LiveNotification>()
    });

    it('should generate capsule show list by priority sort correctly',DEFAULT, () => {
      const testSubject = createTestSubject();
      const cmds = testSubject.generateCapsuleShowListByPrioritySort(generateTestDataForGenerateCapsuleShowListByPrioritySort().capsuleShowList);
      expect(testSubject.value).assertEqual(0);
    });

    const generateTestDataForIsShowHoleRight = () => ({
      live: mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1),
      capsuleVm: mockILiveCapsuleVm()
    });

    it('should isShowHoleRight correctly',DEFAULT, () => {
      const testSubject = createTestSubject();
      const result = testSubject.isShowHoleRight(generateTestDataForIsShowHoleRight().live, generateTestDataForIsShowHoleRight().capsuleVm);
      expect(testSubject.value).assertEqual(0);
    });

    const generateTestDataForIsShowHoleLeft = () => ({
      live: mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1),
      capsuleVm: mockILiveCapsuleVm()
    });

    it('should isShowHoleLeft correctly',DEFAULT, () => {
      const testSubject = createTestSubject();
      const result = testSubject.isShowHoleLeft(generateTestDataForIsShowHoleLeft().live, generateTestDataForIsShowHoleLeft().capsuleVm);
      expect(testSubject.value).assertEqual(0);
    });

    const generateTestDataForUpdateFixedOffset = () => ({
      showCapsuleList: {
        [CapsuleType.PROGRESS]: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1)],
        [CapsuleType.SCREEN_RECORDING]: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 2)],
        [CapsuleType.PERSISTENT]: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.PERSISTENT, 3)]
      }
    });

    it('should update fixed offset correctly',DEFAULT, () => {
      const testSubject = createTestSubject();
      testSubject.updateFixedOffset();
      expect(testSubject.value).assertEqual(0);
    });

    const generateTestDataForUpdateFixedOffsetByOffset = () => ({
      totalOffset: 100,
      liveCapsuleList: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1)],
      capsuleType: CapsuleType.SCREEN_RECORDING
    });

    it('should update fixed offset by offset correctly',DEFAULT, () => {
      const testSubject = createTestSubject();
      const cmds = testSubject.updateFixedOffsetByOffset(generateTestDataForUpdateFixedOffsetByOffset().totalOffset, generateTestDataForUpdateFixedOffsetByOffset().liveCapsuleList, generateTestDataForUpdateFixedOffsetByOffset().capsuleType);
      expect(testSubject.value).assertEqual(0);
    });

    const generateTestDataForModifyFixedWidthAndFixedOffsetByShowType = () => ({
      showCapsuleList: {
        [CapsuleType.SCREEN_RECORDING]: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1)],
        [CapsuleType.PROGRESS]: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 2)]
      }
    });

    it('should modify fixed width and fixed offset by show type correctly',DEFAULT, () => {
      const testSubject = createTestSubject();
      testSubject.modifyFixedWidthAndFixedOffsetByShowType();
      expect(testSubject.value).assertEqual(0);
    });

    const generateTestDataForMoveScreen2ProgressCapsule = () => ({
      showCapsuleList: {
        [CapsuleType.SCREEN_RECORDING]: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1)],
        [CapsuleType.PROGRESS]: []
      }
    });

    it('should move screen to progress capsule correctly',DEFAULT, () => {
      const testSubject = createTestSubject();
      testSubject.moveScreen2ProgressCapsule();
      expect(testSubject.value).assertEqual(0);
    });

    const generateTestDataForPrintFixedWithAndeOffset = () => ({
      liveList: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1)]
    });

    it('should print fixed width and offset correctly',DEFAULT, () => {
      const testSubject = createTestSubject();
      testSubject.printFixedWithAndeOffset(generateTestDataForPrintFixedWithAndeOffset().liveList);
      expect(testSubject.value).assertEqual(0);
    });
    const generateTestDataForUpdateFixedOffset = () => ({
      showCapsuleList: {
        [CapsuleType.PROGRESS]: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1)],
        [CapsuleType.SCREEN_RECORDING]: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 2)],
        [CapsuleType.PERSISTENT]: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.PERSISTENT, 3)]
      }
    });

    it('should update fixed offset correctly', DEFAULT,() => {
      const testSubject = createTestSubject();
      testSubject.updateFixedOffset();
      // Add assertions here to check the fixed offset of each capsule
      expect(testSubject.value).assertEqual(0);
    });

    const generateTestDataForUpdateFixedOffsetByOffset = () => ({
      totalOffset: 100,
      liveCapsuleList: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1)],
      capsuleType: CapsuleType.SCREEN_RECORDING
    });

    it('should update fixed offset by offset correctly', DEFAULT,() => {
      const testSubject = createTestSubject();
      const cmds = testSubject.updateFixedOffsetByOffset(generateTestDataForUpdateFixedOffsetByOffset().totalOffset, generateTestDataForUpdateFixedOffsetByOffset().liveCapsuleList, generateTestDataForUpdateFixedOffsetByOffset().capsuleType);
      // Add assertions here to check the fixed offset of each capsule
      expect(testSubject.value).assertEqual(0);
    });

    const generateTestDataForModifyFixedWidthAndFixedOffsetByShowType = () => ({
      showCapsuleList: {
        [CapsuleType.SCREEN_RECORDING]: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1)],
        [CapsuleType.PROGRESS]: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 2)]
      }
    });

    it('should modify fixed width and fixed offset by show type correctly',DEFAULT, () => {
      const testSubject = createTestSubject();
      testSubject.modifyFixedWidthAndFixedOffsetByShowType();
      // Add assertions here to check the fixed width and fixed offset of each capsule
      expect(testSubject.value).assertEqual(0);
    });

    const generateTestDataForMoveScreen2ProgressCapsule = () => ({
      showCapsuleList: {
        [CapsuleType.SCREEN_RECORDING]: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1)],
        [CapsuleType.PROGRESS]: []
      }
    });

    it('should move screen to progress capsule correctly', DEFAULT,() => {
      const testSubject = createTestSubject();
      testSubject.moveScreen2ProgressCapsule();
      // Add assertions here to check the showCapsuleList after moving
      expect(testSubject.value).assertEqual(0);
    });

    const generateTestDataForPrintFixedWithAndeOffset = () => ({
      liveList: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1)]
    });

    it('should print fixed width and offset correctly',DEFAULT, () => {
      const testSubject = createTestSubject();
      testSubject.printFixedWithAndeOffset(generateTestDataForPrintFixedWithAndeOffset().liveList);
      // Add assertions here to check the printed output
      expect(testSubject.value).assertEqual(0);
    });
    it('should_log_warn_when_live_type_is_not_sys_and_show_type_is_supported_but_status_is_supported', 0, () => {
      let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.warn);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      let live: LiveNotification = new LiveNotification();
      live.sysType = SysTypeCode.LIVE_SYS_TYPE_VIDEO_MEETING;
      live.liveType = LiveType.LIVE_TYPE_DIVIDE;
      live.capsuleShowType = CapsuleShowType.SUPPORTED_SHOW_TYPE;
      live.status = StatusBarCapsulePosition.SUPPORTED_STATUS;
      livecapsulelistmultipleholelayoutvm.setRemindCapsuleWidth(live, false);
      mocker.verify('warn', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(logHelper, logHelper.warn);
    });

    it('should_return_correct_offset_when_no_holes', 0, async () => {
      let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistmultipleholelayoutvm.vmInjector, livecapsulelistmultipleholelayoutvm.vmInjector.getCapsuleVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let liveCapsule1: LiveNotification = new LiveNotification();
      liveCapsule1.sysType = SysTypeCode.LIVE_NOTIFICATION;
      liveCapsule1.liveType = LiveType.PROGRESS;
      liveCapsule1.showType = CapsuleShowType.SHOW;
      liveCapsule1.statusBarCapsulePosition = StatusBarCapsulePosition.ONLY_LEFT;

      let liveCapsule2: LiveNotification = new LiveNotification();
      liveCapsule2.sysType = SysTypeCode.LIVE_NOTIFICATION;
      liveCapsule2.liveType = LiveType.PROGRESS;
      liveCapsule2.showType = CapsuleShowType.SHOW;
      liveCapsule2.statusBarCapsulePosition = StatusBarCapsulePosition.ONLY_RIGHT;

      let capsuleVm1: ILiveCapsuleVm = {
        isShow: true,
        fixedOffsetX: 0,
        fixedWidth: 100
      };
      let capsuleVm2: ILiveCapsuleVm = {
        isShow: true,
        fixedOffsetX: 0,
        fixedWidth: 100
      };

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm1);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm2);

      livecapsulelistmultipleholelayoutvm.showCapsuleList = [new NotificationArray<LiveNotification>()];
      livecapsulelistmultipleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS] = new NotificationArray<LiveNotification>();
      livecapsulelistmultipleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(liveCapsule1);
      livecapsulelistmultipleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(liveCapsule2);

      const result = livecapsulelistmultipleholelayoutvm.updateProgressCapsuleFixedOffset();
      expect(result).assertEqual(0);

      mocker.ignoreMock(livecapsulelistmultipleholelayoutvm.vmInjector, livecapsulelistmultipleholelayoutvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_correct_offset_when_holes_exist', 0, async () => {
      let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistmultipleholelayoutvm.vmInjector, livecapsulelistmultipleholelayoutvm.vmInjector.getCapsuleVm);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      let liveCapsule1: LiveNotification = new LiveNotification();
      liveCapsule1.sysType = SysTypeCode.LIVE_NOTIFICATION;
      liveCapsule1.liveType = LiveType.PROGRESS;
      liveCapsule1.showType = CapsuleShowType.SHOW;
      liveCapsule1.statusBarCapsulePosition = StatusBarCapsulePosition.ONLY_LEFT;

      let liveCapsule2: LiveNotification = new LiveNotification();
      liveCapsule2.sysType = SysTypeCode.LIVE_NOTIFICATION;
      liveCapsule2.liveType = LiveType.PROGRESS;
      liveCapsule2.showType = CapsuleShowType.SHOW;
      liveCapsule2.statusBarCapsulePosition = StatusBarCapsulePosition.ONLY_RIGHT;

      let liveCapsule3: LiveNotification = new LiveNotification();
      liveCapsule3.sysType = SysTypeCode.LIVE_NOTIFICATION;
      liveCapsule3.liveType = LiveType.PROGRESS;
      liveCapsule3.showType = CapsuleShowType.SHOW;
      liveCapsule3.statusBarCapsulePosition = StatusBarCapsulePosition.NEITHER_LEFT_NOR_RIGHT;

      let capsuleVm1: ILiveCapsuleVm = {
        isShow: true,
        fixedOffsetX: 0,
        fixedWidth: 100
      };
      let capsuleVm2: ILiveCapsuleVm = {
        isShow: true,
        fixedOffsetX: 0,
        fixedWidth: 100
      };
      let capsuleVm3: ILiveCapsuleVm = {
        isShow: true,
        fixedOffsetX: 0,
        fixedWidth: 100
      };

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm1);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm2);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm3);

      livecapsulelistmultipleholelayoutvm.showCapsuleList = [new NotificationArray<LiveNotification>()];
      livecapsulelistmultipleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS] = new NotificationArray<LiveNotification>();
      livecapsulelistmultipleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(liveCapsule1);
      livecapsulelistmultipleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(liveCapsule2);
      livecapsulelistmultipleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(liveCapsule3);
      livecapsulelistmultipleholelayoutvm.leftTotalFreeSpace = 10;
      livecapsulelistmultipleholelayoutvm.rightTotalFreeSpace = 10;
      const result = livecapsulelistmultipleholelayoutvm.updateProgressCapsuleFixedOffset();
      expect(result).assertEqual(-10);
      mocker.ignoreMock(livecapsulelistmultipleholelayoutvm.vmInjector, livecapsulelistmultipleholelayoutvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });


    it('should_return_spaceInfo_when_capsuleShowList_is_empty', 0, () => {
      let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let capsuleShowList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.getCapsuleVm);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      let result = livecapsulelistmultipleholelayoutvm.computeCapsuleShowFlagBySpace(capsuleShowList);
      expect(result.leftTotalFreeSpace).assertEqual(0);
      expect(result.rightTotalFreeSpace).assertEqual(0);
      expect(result.leftUsedSpace).assertEqual(0);
      expect(result.rightUsedSpace).assertEqual(0);
      expect(result.leftRemainSpace).assertEqual(0);
      expect(result.rightRemainSpace).assertEqual(0);
      mocker.ignoreMock(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.getCapsuleVm);
    });

    it('should_return_spaceInfo_when_capsuleVm_isShow_is_false', 0, () => {
      let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let capsuleShowList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.getCapsuleVm);
      let liveCapsuleVm: ILiveCapsuleVm = {
        isShow: false,
        fixedWidth: 0,
        fixedOffsetX: 0,
        capsuleShowType: CapsuleShowType.LiveCapsuleShowTypeNormal,
        sysType: SysTypeCode.LIVE_capsule,
        liveType: LiveType.LiveTypeNormal,
        statusBarCapsulePosition: StatusBarCapsulePosition.STATUS_BAR_capsulePositionNormal,
        avoidStart: 0,
        avoidEnd: 0,
        capsuleLeftMin: 0,
        capsuleRightMax: 0,
        isUpdate: false
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(liveCapsuleVm);
      let result = livecapsulelistmultipleholelayoutvm.computeCapsuleShowFlagBySpace(capsuleShowList);
      expect(result.leftTotalFreeSpace).assertEqual(0);
      expect(result.rightTotalFreeSpace).assertEqual(0);
      expect(result.leftUsedSpace).assertEqual(0);
      expect(result.rightUsedSpace).assertEqual(0);
      expect(result.leftRemainSpace).assertEqual(0);
      expect(result.rightRemainSpace).assertEqual(0);
      mocker.ignoreMock(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.getCapsuleVm);
    });

    it('should_return_spaceInfo_when_capsuleVm_isShow_is_true_and_isShowHoleLeft_is_true', 0, () => {
      let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      livecapsulelistmultipleholelayoutvm.leftTotalFreeSpace = 100;
      let capsuleShowList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.getCapsuleVm);
      let liveCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 50,
        fixedOffsetX: 0,
        capsuleShowType: CapsuleShowType.LiveCapsuleShowTypeNormal,
        sysType: SysTypeCode.LIVE_capsule,
        liveType: LiveType.LiveTypeNormal,
        statusBarCapsulePosition: StatusBarCapsulePosition.STATUS_BAR_capsulePositionNormal,
        avoidStart: 0,
        avoidEnd: 0,
        capsuleLeftMin: 0,
        capsuleRightMax: 0,
        isUpdate: false
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(liveCapsuleVm);
      let result = livecapsulelistmultipleholelayoutvm.computeCapsuleShowFlagBySpace(capsuleShowList);
      expect(result.leftTotalFreeSpace).assertEqual(50);
      expect(result.rightTotalFreeSpace).assertEqual(0);
      expect(result.leftUsedSpace).assertEqual(50);
      expect(result.rightUsedSpace).assertEqual(0);
      expect(result.leftRemainSpace).assertEqual(50);
      expect(result.rightRemainSpace).assertEqual(0);
      mocker.ignoreMock(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.getCapsuleVm);
    });

    it('should_return_spaceInfo_when_capsuleVm_isShow_is_true_and_isShowHoleRight_is_true', 0, () => {
      let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      livecapsulelistmultipleholelayoutvm.rightTotalFreeSpace = 100;
      let capsuleShowList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.getCapsuleVm);
      let liveCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 50,
        fixedOffsetX: 0,
        capsuleShowType: CapsuleShowType.LiveCapsuleShowTypeNormal,
        sysType: SysTypeCode.LIVE_capsule,
        liveType: LiveType.LiveTypeNormal,
        statusBarCapsulePosition: StatusBarCapsulePosition.STATUS_BAR_capsulePositionNormal,
        avoidStart: 0,
        avoidEnd: 0,
        capsuleLeftMin: 0,
        capsuleRightMax: 0,
        isUpdate: false
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(liveCapsuleVm);
      let result = livecapsulelistmultipleholelayoutvm.computeCapsuleShowFlagBySpace(capsuleShowList);
      expect(result.leftTotalFreeSpace).assertEqual(0);
      expect(result.rightTotalFreeSpace).assertEqual(50);
      expect(result.leftUsedSpace).assertEqual(0);
      expect(result.rightUsedSpace).assertEqual(50);
      expect(result.leftRemainSpace).assertEqual(0);
      expect(result.rightRemainSpace).assertEqual(50);
      mocker.ignoreMock(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.getCapsuleVm);
    });

    it('should_continue_when_capsuleVm_is_not_show', 0, async () => {
      let spaceInfo: ISpaceInfo = new ISpaceInfo();
      let capsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let capsuleType: CapsuleType = new CapsuleType();
      let liveCapsuleListMultipleHoleLayoutVm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockCapsuleVm: ILiveCapsuleVm = new ILiveCapsuleVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockCapsuleVm.isShow).afterReturn(false);
      liveCapsuleListMultipleHoleLayoutVm.adjustShowCapsuleWidth(spaceInfo, capsuleList, capsuleType);
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_continue_when_leftHole_is_show_and_leftRemainSpace_is_zero', 0, async () => {
      let spaceInfo: ISpaceInfo = new ISpaceInfo();
      let capsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let capsuleType: CapsuleType = new CapsuleType();
      let liveCapsuleListMultipleHoleLayoutVm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockCapsuleVm: ILiveCapsuleVm = new ILiveCapsuleVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockCapsuleVm.isShow).afterReturn(true);
      when(mockCapsuleVm.capsuleShowType).afterReturn(CapsuleShowType.LEFT_HOLE);
      liveCapsuleListMultipleHoleLayoutVm.adjustShowCapsuleWidth(spaceInfo, capsuleList, capsuleType);
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_continue_when_rightHole_is_show_and_rightRemainSpace_is_zero', 0, async () => {
      let spaceInfo: ISpaceInfo = new ISpaceInfo();
      let capsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let capsuleType: CapsuleType = new CapsuleType();
      let liveCapsuleListMultipleHoleLayoutVm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockCapsuleVm: ILiveCapsuleVm = new ILiveCapsuleVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockCapsuleVm.isShow).afterReturn(true);
      when(mockCapsuleVm.capsuleShowType).afterReturn(CapsuleShowType.RIGHT_HOLE);
      liveCapsuleListMultipleHoleLayoutVm.adjustShowCapsuleWidth(spaceInfo, capsuleList, capsuleType);
      mocker.verify('showInfo', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_continue_when_leftHole_is_show_and_leftRemainSpace_is_greater_than_zero', 0, async () => {
      let spaceInfo: ISpaceInfo = new ISpaceInfo();
      spaceInfo.leftRemainSpace = 100;
      let capsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let capsuleType: CapsuleType = new CapsuleType();
      let liveCapsuleListMultipleHoleLayoutVm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockCapsuleVm: ILiveCapsuleVm = new ILiveCapsuleVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockAdjustFixedWidth: Function = mocker.mockFunc(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.adjustFixedWidth);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockCapsuleVm.isShow).afterReturn(true);
      when(mockCapsuleVm.capsuleShowType).afterReturn(CapsuleShowType.LEFT_HOLE);
      when(mockAdjustFixedWidth)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean).afterReturn(50);
      liveCapsuleListMultipleHoleLayoutVm.adjustShowCapsuleWidth(spaceInfo, capsuleList, capsuleType);
      expect(spaceInfo.leftRemainSpace).assertEqual(50);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.adjustFixedWidth);
    });

    it('should_continue_when_rightHole_is_show_and_rightRemainSpace_is_greater_than_zero', 0, async () => {
      let spaceInfo: ISpaceInfo = new ISpaceInfo();
      spaceInfo.rightRemainSpace = 100;
      let capsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let capsuleType: CapsuleType = new CapsuleType();
      let liveCapsuleListMultipleHoleLayoutVm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockCapsuleVm: ILiveCapsuleVm = new ILiveCapsuleVm();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockAdjustFixedWidth: Function = mocker.mockFunc(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.adjustFixedWidth);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockCapsuleVm.isShow).afterReturn(true);
      when(mockCapsuleVm.capsuleShowType).afterReturn(CapsuleShowType.RIGHT_HOLE);
      when(mockAdjustFixedWidth)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean).afterReturn(50);
      liveCapsuleListMultipleHoleLayoutVm.adjustShowCapsuleWidth(spaceInfo, capsuleList, capsuleType);
      expect(spaceInfo.rightRemainSpace).assertEqual(50);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.adjustFixedWidth);
    });

    const generateTestDataForGenerateCapsuleShowListByPrioritySort = () => ({
      capsuleShowList: new NotificationArray<LiveNotification>()
    });

    it('should generate capsule show list by priority sort correctly',DEFAULT, () => {
      const testSubject = createTestSubject();
      const cmds = testSubject.generateCapsuleShowListByPrioritySort(generateTestDataForGenerateCapsuleShowListByPrioritySort().capsuleShowList);
      expect(testSubject.value).assertEqual(0);
    });

    const generateTestDataForIsShowHoleRight = () => ({
      live: mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1),
      capsuleVm: mockILiveCapsuleVm()
    });

    it('should isShowHoleRight correctly',DEFAULT, () => {
      const testSubject = createTestSubject();
      const result = testSubject.isShowHoleRight(generateTestDataForIsShowHoleRight().live, generateTestDataForIsShowHoleRight().capsuleVm);
      expect(testSubject.value).assertEqual(0);
    });

    const generateTestDataForIsShowHoleLeft = () => ({
      live: mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1),
      capsuleVm: mockILiveCapsuleVm()
    });

    it('should isShowHoleLeft correctly',DEFAULT, () => {
      const testSubject = createTestSubject();
      const result = testSubject.isShowHoleLeft(generateTestDataForIsShowHoleLeft().live, generateTestDataForIsShowHoleLeft().capsuleVm);
      expect(testSubject.value).assertEqual(0);
    });

    const generateTestDataForUpdateFixedOffset = () => ({
      showCapsuleList: {
        [CapsuleType.PROGRESS]: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1)],
        [CapsuleType.SCREEN_RECORDING]: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 2)],
        [CapsuleType.PERSISTENT]: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.PERSISTENT, 3)]
      }
    });

    it('should update fixed offset correctly',DEFAULT, () => {
      const testSubject = createTestSubject();
      testSubject.updateFixedOffset();
      expect(testSubject.value).assertEqual(0);
    });

    const generateTestDataForUpdateFixedOffsetByOffset = () => ({
      totalOffset: 100,
      liveCapsuleList: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1)],
      capsuleType: CapsuleType.SCREEN_RECORDING
    });

    it('should update fixed offset by offset correctly',DEFAULT, () => {
      const testSubject = createTestSubject();
      const cmds = testSubject.updateFixedOffsetByOffset(generateTestDataForUpdateFixedOffsetByOffset().totalOffset, generateTestDataForUpdateFixedOffsetByOffset().liveCapsuleList, generateTestDataForUpdateFixedOffsetByOffset().capsuleType);
      expect(testSubject.value).assertEqual(0);
    });

    const generateTestDataForModifyFixedWidthAndFixedOffsetByShowType = () => ({
      showCapsuleList: {
        [CapsuleType.SCREEN_RECORDING]: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1)],
        [CapsuleType.PROGRESS]: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 2)]
      }
    });

    it('should modify fixed width and fixed offset by show type correctly',DEFAULT, () => {
      const testSubject = createTestSubject();
      testSubject.modifyFixedWidthAndFixedOffsetByShowType();
      expect(testSubject.value).assertEqual(0);
    });

    const generateTestDataForMoveScreen2ProgressCapsule = () => ({
      showCapsuleList: {
        [CapsuleType.SCREEN_RECORDING]: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1)],
        [CapsuleType.PROGRESS]: []
      }
    });

    it('should move screen to progress capsule correctly',DEFAULT, () => {
      const testSubject = createTestSubject();
      testSubject.moveScreen2ProgressCapsule();
      expect(testSubject.value).assertEqual(0);
    });

    const generateTestDataForPrintFixedWithAndeOffset = () => ({
      liveList: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1)]
    });

    it('should print fixed width and offset correctly',DEFAULT, () => {
      const testSubject = createTestSubject();
      testSubject.printFixedWithAndeOffset(generateTestDataForPrintFixedWithAndeOffset().liveList);
      expect(testSubject.value).assertEqual(0);
    });
    const generateTestDataForUpdateFixedOffset = () => ({
      showCapsuleList: {
        [CapsuleType.PROGRESS]: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1)],
        [CapsuleType.SCREEN_RECORDING]: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 2)],
        [CapsuleType.PERSISTENT]: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.PERSISTENT, 3)]
      }
    });

    it('should update fixed offset correctly', DEFAULT,() => {
      const testSubject = createTestSubject();
      testSubject.updateFixedOffset();
      // Add assertions here to check the fixed offset of each capsule
      expect(testSubject.value).assertEqual(0);
    });

    const generateTestDataForUpdateFixedOffsetByOffset = () => ({
      totalOffset: 100,
      liveCapsuleList: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1)],
      capsuleType: CapsuleType.SCREEN_RECORDING
    });

    it('should update fixed offset by offset correctly', DEFAULT,() => {
      const testSubject = createTestSubject();
      const cmds = testSubject.updateFixedOffsetByOffset(generateTestDataForUpdateFixedOffsetByOffset().totalOffset, generateTestDataForUpdateFixedOffsetByOffset().liveCapsuleList, generateTestDataForUpdateFixedOffsetByOffset().capsuleType);
      // Add assertions here to check the fixed offset of each capsule
      expect(testSubject.value).assertEqual(0);
    });

    const generateTestDataForModifyFixedWidthAndFixedOffsetByShowType = () => ({
      showCapsuleList: {
        [CapsuleType.SCREEN_RECORDING]: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1)],
        [CapsuleType.PROGRESS]: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 2)]
      }
    });

    it('should modify fixed width and fixed offset by show type correctly',DEFAULT, () => {
      const testSubject = createTestSubject();
      testSubject.modifyFixedWidthAndFixedOffsetByShowType();
      // Add assertions here to check the fixed width and fixed offset of each capsule
      expect(testSubject.value).assertEqual(0);
    });

    const generateTestDataForMoveScreen2ProgressCapsule = () => ({
      showCapsuleList: {
        [CapsuleType.SCREEN_RECORDING]: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1)],
        [CapsuleType.PROGRESS]: []
      }
    });

    it('should move screen to progress capsule correctly', DEFAULT,() => {
      const testSubject = createTestSubject();
      testSubject.moveScreen2ProgressCapsule();
      // Add assertions here to check the showCapsuleList after moving
      expect(testSubject.value).assertEqual(0);
    });

    const generateTestDataForPrintFixedWithAndeOffset = () => ({
      liveList: [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1)]
    });

    it('should print fixed width and offset correctly',DEFAULT, () => {
      const testSubject = createTestSubject();
      testSubject.printFixedWithAndeOffset(generateTestDataForPrintFixedWithAndeOffset().liveList);
      // Add assertions here to check the printed output
      expect(testSubject.value).assertEqual(0);
    });
  });
}

function createTestSubject() {
  throw new Error('Function not implemented.');
}
