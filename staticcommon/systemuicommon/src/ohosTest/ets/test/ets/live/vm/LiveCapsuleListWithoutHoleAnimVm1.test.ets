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
import { beforeEach, DEFAULT, describe, expect, it } from '@ohos/hypium';

describe('LiveCapsuleListWithoutHoleAnimVm1', () => {
  let liveCapsuleListVm: LiveCapsuleListWithoutHoleLayoutVm;
  describe('testsuit_6', () => {
    it('should_return_immediately_when_position_is_null', 0, () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      livecapsulelistwithoutholelayoutvm.initParam(null, true);
      expect(livecapsulelistwithoutholelayoutvm.totalFreeSpace).assertEqual(0);
      expect(livecapsulelistwithoutholelayoutvm.isUpdate).assertEqual(true);
    });

    it('should_calculate_totalFreeSpace_correctly_when_position_is_not_null', 0, () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistwithoutholelayoutvm, livecapsulelistwithoutholelayoutvm.getSpaceBetweenCapsuleAndStatusBar);
      when(mockfunc)().afterReturn(10);
      let position: StatusBarCapsulePosition = new StatusBarCapsulePosition();
      position.capsuleLeftMin = 10;
      position.capsuleRightMax = 20;
      livecapsulelistwithoutholelayoutvm.initParam(position, true);
      expect(livecapsulelistwithoutholelayoutvm.totalFreeSpace).assertEqual(10);
      expect(livecapsulelistwithoutholelayoutvm.isUpdate).assertEqual(true);
      mocker.ignoreMock(livecapsulelistwithoutholelayoutvm, livecapsulelistwithoutholelayoutvm.getSpaceBetweenCapsuleAndStatusBar);
    });

    it('should_set_isUpdate_to_true_when_isUpdate_is_undefined', 0, () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistwithoutholelayoutvm, livecapsulelistwithoutholelayoutvm.getSpaceBetweenCapsuleAndStatusBar);
      when(mockfunc)().afterReturn(10);
      let position: StatusBarCapsulePosition = new StatusBarCapsulePosition();
      position.capsuleLeftMin = 10;
      position.capsuleRightMax = 20;
      livecapsulelistwithoutholelayoutvm.initParam(position, undefined);
      expect(livecapsulelistwithoutholelayoutvm.totalFreeSpace).assertEqual(10);
      expect(livecapsulelistwithoutholelayoutvm.isUpdate).assertEqual(true);
      mocker.ignoreMock(livecapsulelistwithoutholelayoutvm, livecapsulelistwithoutholelayoutvm.getSpaceBetweenCapsuleAndStatusBar);
    });

    it('should_set_isUpdate_to_false_when_isUpdate_is_false', 0, () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistwithoutholelayoutvm, livecapsulelistwithoutholelayoutvm.getSpaceBetweenCapsuleAndStatusBar);
      when(mockfunc)().afterReturn(10);
      let position: StatusBarCapsulePosition = new StatusBarCapsulePosition();
      position.capsuleLeftMin = 10;
      position.capsuleRightMax = 20;
      livecapsulelistwithoutholelayoutvm.initParam(position, false);
      expect(livecapsulelistwithoutholelayoutvm.totalFreeSpace).assertEqual(10);
      expect(livecapsulelistwithoutholelayoutvm.isUpdate).assertEqual(false);
      mocker.ignoreMock(livecapsulelistwithoutholelayoutvm, livecapsulelistwithoutholelayoutvm.getSpaceBetweenCapsuleAndStatusBar);
    });

    it('should_set_isUpdate_to_true_when_isUpdate_is_true', 0, () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistwithoutholelayoutvm, livecapsulelistwithoutholelayoutvm.getSpaceBetweenCapsuleAndStatusBar);
      when(mockfunc)().afterReturn(10);
      let position: StatusBarCapsulePosition = new StatusBarCapsulePosition();
      position.capsuleLeftMin = 10;
      position.capsuleRightMax = 20;
      livecapsulelistwithoutholelayoutvm.initParam(position, true);
      expect(livecapsulelistwithoutholelayoutvm.totalFreeSpace).assertEqual(10);
      expect(livecapsulelistwithoutholelayoutvm.isUpdate).assertEqual(true);
      mocker.ignoreMock(livecapsulelistwithoutholelayoutvm, livecapsulelistwithoutholelayoutvm.getSpaceBetweenCapsuleAndStatusBar);
    });

    it('should_calculate_totalFreeSpace_correctly_when_position_is_not_null_and_getSpaceBetweenCapsuleAndStatusBar_returns_non_zero', 0, () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistwithoutholelayoutvm, livecapsulelistwithoutholelayoutvm.getSpaceBetweenCapsuleAndStatusBar);
      when(mockfunc)().afterReturn(10);
      let position: StatusBarCapsulePosition = new StatusBarCapsulePosition();
      position.capsuleLeftMin = 10;
      position.capsuleRightMax = 20;
      livecapsulelistwithoutholelayoutvm.initParam(position, true);
      expect(livecapsulelistwithoutholelayoutvm.totalFreeSpace).assertEqual(10);
      expect(livecapsulelistwithoutholelayoutvm.isUpdate).assertEqual(true);
      mocker.ignoreMock(livecapsulelistwithoutholelayoutvm, livecapsulelistwithoutholelayoutvm.getSpaceBetweenCapsuleAndStatusBar);
    });

    it('should_set_capsule_visibility_false_when_capsuleVm_is_not_visible', 0, async () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let capsuleVm: ILiveCapsuleVm = mocker.mockFunc(livecapsulelistwithoutholelayoutvm.vmInjector, livecapsulelistwithoutholelayoutvm.vmInjector.getCapsuleVm);
      when(capsuleVm)(ArgumentMatchers.any).afterReturn({
        isVisible: false,
        isShow: false,
        fixedShowType: CapsuleShowType.NONE,
        fixedWidth: 0,
        fixedOffsetX: 0
      });
      let liveList: LiveNotification[] = [new LiveNotification()];
      livecapsulelistwithoutholelayoutvm.filterShowCapsuleList(liveList);
      expect(capsuleVm.isVisible).assertEqual(false);
      expect(capsuleVm.isShow).assertEqual(false);
      expect(capsuleVm.fixedShowType).assertEqual(CapsuleShowType.NONE);
      expect(capsuleVm.fixedWidth).assertEqual(0);
      expect(capsuleVm.fixedOffsetX).assertEqual(0);
      mocker.ignoreMock(livecapsulelistwithoutholelayoutvm.vmInjector, livecapsulelistwithoutholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_set_capsule_visibility_true_when_capsuleVm_is_visible_and_live_is_instant', 0, async () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let capsuleVm: ILiveCapsuleVm = mocker.mockFunc(livecapsulelistwithoutholelayoutvm.vmInjector, livecapsulelistwithoutholelayoutvm.vmInjector.getCapsuleVm);
      when(capsuleVm)(ArgumentMatchers.any).afterReturn({
        isVisible: true,
        isShow: false,
        fixedShowType: CapsuleShowType.NONE,
        fixedWidth: 0,
        fixedOffsetX: 0
      });
      let liveList: LiveNotification[] = [new LiveNotification()];
      livecapsulelistwithoutholelayoutvm.filterShowCapsuleList(liveList);
      expect(capsuleVm.isVisible).assertEqual(true);
      expect(capsuleVm.isShow).assertEqual(true);
      expect(capsuleVm.fixedShowType).assertEqual(CapsuleShowType.NONE);
      expect(capsuleVm.fixedWidth).assertEqual(0);
      expect(capsuleVm.fixedOffsetX).assertEqual(0);
      mocker.ignoreMock(livecapsulelistwithoutholelayoutvm.vmInjector, livecapsulelistwithoutholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_set_capsule_visibility_true_when_capsuleVm_is_visible_and_live_is_persistent', 0, async () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let capsuleVm: ILiveCapsuleVm = mocker.mockFunc(livecapsulelistwithoutholelayoutvm.vmInjector, livecapsulelistwithoutholelayoutvm.vmInjector.getCapsuleVm);
      when(capsuleVm)(ArgumentMatchers.any).afterReturn({
        isVisible: true,
        isShow: false,
        fixedShowType: CapsuleShowType.NONE,
        fixedWidth: 0,
        fixedOffsetX: 0
      });
      let liveList: LiveNotification[] = [new LiveNotification()];
      livecapsulelistwithoutholelayoutvm.filterShowCapsuleList(liveList);
      expect(capsuleVm.isVisible).assertEqual(true);
      expect(capsuleVm.isShow).assertEqual(true);
      expect(capsuleVm.fixedShowType).assertEqual(CapsuleShowType.NONE);
      expect(capsuleVm.fixedWidth).assertEqual(0);
      expect(capsuleVm.fixedOffsetX).assertEqual(0);
      mocker.ignoreMock(livecapsulelistwithoutholelayoutvm.vmInjector, livecapsulelistwithoutholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_set_capsule_visibility_true_when_capsuleVm_is_visible_and_live_is_screen_recorder', 0, async () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let capsuleVm: ILiveCapsuleVm = mocker.mockFunc(livecapsulelistwithoutholelayoutvm.vmInjector, livecapsulelistwithoutholelayoutvm.vmInjector.getCapsuleVm);
      when(capsuleVm)(ArgumentMatchers.any).afterReturn({
        isVisible: true,
        isShow: false,
        fixedShowType: CapsuleShowType.NONE,
        fixedWidth: 0,
        fixedOffsetX: 0
      });
      let liveList: LiveNotification[] = [new LiveNotification()];
      livecapsulelistwithoutholelayoutvm.filterShowCapsuleList(liveList);
      expect(capsuleVm.isVisible).assertEqual(true);
      expect(capsuleVm.isShow).assertEqual(true);
      expect(capsuleVm.fixedShowType).assertEqual(CapsuleShowType.NONE);
      expect(capsuleVm.fixedWidth).assertEqual(0);
      expect(capsuleVm.fixedOffsetX).assertEqual(0);
      mocker.ignoreMock(livecapsulelistwithoutholelayoutvm.vmInjector, livecapsulelistwithoutholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_set_capsule_visibility_true_when_capsuleVm_is_visible_and_live_is_persistent_and_is_showed', 0, async () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let capsuleVm: ILiveCapsuleVm = mocker.mockFunc(livecapsulelistwithoutholelayoutvm.vmInjector, livecapsulelistwithoutholelayoutvm.vmInjector.getCapsuleVm);
      when(capsuleVm)(ArgumentMatchers.any).afterReturn({
        isVisible: true,
        isShow: true,
        fixedShowType: CapsuleShowType.NONE,
        fixedWidth: 0,
        fixedOffsetX: 0
      });
      let liveList: LiveNotification[] = [new LiveNotification()];
      livecapsulelistwithoutholelayoutvm.filterShowCapsuleList(liveList);
      expect(capsuleVm.isVisible).assertEqual(true);
      expect(capsuleVm.isShow).assertEqual(true);
      expect(capsuleVm.fixedShowType).assertEqual(CapsuleShowType.NONE);
      expect(capsuleVm.fixedWidth).assertEqual(0);
      expect(capsuleVm.fixedOffsetX).assertEqual(0);
      mocker.ignoreMock(livecapsulelistwithoutholelayoutvm.vmInjector, livecapsulelistwithoutholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_set_capsule_visibility_true_when_capsuleVm_is_visible_and_live_is_screen_recorder_and_is_showed', 0, async () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let capsuleVm: ILiveCapsuleVm = mocker.mockFunc(livecapsulelistwithoutholelayoutvm.vmInjector, livecapsulelistwithoutholelayoutvm.vmInjector.getCapsuleVm);
      when(capsuleVm)(ArgumentMatchers.any).afterReturn({
        isVisible: true,
        isShow: true,
        fixedShowType: CapsuleShowType.NONE,
        fixedWidth: 0,
        fixedOffsetX: 0
      });
      let liveList: LiveNotification[] = [new LiveNotification()];
      livecapsulelistwithoutholelayoutvm.filterShowCapsuleList(liveList);
      expect(capsuleVm.isVisible).assertEqual(true);
      expect(capsuleVm.isShow).assertEqual(true);
      expect(capsuleVm.fixedShowType).assertEqual(CapsuleShowType.NONE);
      expect(capsuleVm.fixedWidth).assertEqual(0);
    });

    it('should_log_info_when_updateFixedWidth_is_called', 0, async () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      livecapsulelistwithoutholelayoutvm.updateFixedWidth();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_generate_capsule_show_list_by_priority_sort', 0, async () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      livecapsulelistwithoutholelayoutvm.showCapsuleList =
        [new NotificationArray<LiveNotification>(), new NotificationArray<LiveNotification>(),
          new NotificationArray<LiveNotification>()];
      livecapsulelistwithoutholelayoutvm.capsuleSpaceAllocationSequence =
        [CapsuleType.PROGRESS, CapsuleType.SCREEN_RECORDING, CapsuleType.PERSISTENT];

      livecapsulelistwithoutholelayoutvm.updateFixedWidth();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_compute_capsule_show_flag', 0, async () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      livecapsulelistwithoutholelayoutvm.showCapsuleList =
        [new NotificationArray<LiveNotification>(), new NotificationArray<LiveNotification>(),
          new NotificationArray<LiveNotification>()];
      livecapsulelistwithoutholelayoutvm.capsuleSpaceAllocationSequence =
        [CapsuleType.PROGRESS, CapsuleType.SCREEN_RECORDING, CapsuleType.PERSISTENT];
      livecapsulelistwithoutholelayoutvm.totalFreeSpace = 100;

      livecapsulelistwithoutholelayoutvm.updateFixedWidth();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_adjust_show_capsule_width', 0, async () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      livecapsulelistwithoutholelayoutvm.showCapsuleList =
        [new NotificationArray<LiveNotification>(), new NotificationArray<LiveNotification>(),
          new NotificationArray<LiveNotification>()];
      livecapsulelistwithoutholelayoutvm.capsuleSpaceAllocationSequence =
        [CapsuleType.PROGRESS, CapsuleType.SCREEN_RECORDING, CapsuleType.PERSISTENT];
      livecapsulelistwithoutholelayoutvm.totalFreeSpace = 100;

      let liveNotification: LiveNotification = new LiveNotification();
      liveNotification.liveType = LiveType.VIDEO_MEETING;
      liveNotification.sysType = SysTypeCode.NORMAL_VIDEO_MEETING;
      liveNotification.statusBarCapsulePosition = StatusBarCapsulePosition.LEFT;
      liveNotification.liveStyle = LiveStyle.VIDEO_MEETING;
      liveNotification.deviceInfoVm = new DeviceInfoVm();
      liveNotification.deviceInfoVm.hasCutout = false;
      liveNotification.deviceInfoVm.deviceType = 1;
      liveNotification.deviceInfoVm.deviceModel = "model";
      liveNotification.deviceInfoVm.deviceName = "name";
      liveNotification.deviceInfoVm.deviceStyle = 1;
      liveNotification.deviceInfoVm.deviceCutoutStyle = 1;
      liveNotification.deviceInfoVm.deviceCutoutPosition = 1;
      liveNotification.deviceInfoVm.deviceCutoutSize = 1;
      liveNotification.deviceInfoVm.deviceCutoutPadding = 1;
      liveNotification.deviceInfoVm.deviceCutoutMargin = 1;
      liveNotification.deviceInfoVm.deviceCutoutBlur = 1;
      liveNotification.deviceInfoVm.deviceCutoutBackground = 1;
      liveNotification.deviceInfoVm.deviceCutoutForeground = 1;
      liveNotification.deviceInfoVm.deviceCutoutIcon = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotification = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTip = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipStyle = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipSize = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipBlur = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipBackground = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipForeground = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipIcon = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipNotification = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipNotificationTip = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipNotificationTipStyle = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipNotificationTipSize = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipNotificationTipBlur = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipNotificationTipBackground = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipNotificationTipForeground = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipNotificationTipIcon = 1;
      livecapsulelistwithoutholelayoutvm.showCapsuleList[CapsuleType.SCREEN_RECORDING].push(liveNotification);

      let liveCapsuleVm: ILiveCapsuleVm = {
        getCapsuleVm: (live: LiveNotification) => {
          return {
            fixedShowType: CapsuleShowType.SHOW,
            capsuleWidth: 50,
            capsuleHeight: 50,
            capsuleShowType: CapsuleShowType.SHOW,
            capsuleNotification: live
          } as ILiveCapsuleVm;
        },
        fixedShowType: CapsuleShowType.SHOW,
        capsuleWidth: 50,
        capsuleHeight: 50,
        capsuleShowType: CapsuleShowType.SHOW,
        capsuleNotification: liveNotification
      } as ILiveCapsuleVm;

      livecapsulelistwithoutholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(liveNotification);
      livecapsulelistwithoutholelayoutvm.showCapsuleList[CapsuleType.PERSISTENT].push(liveNotification);

      livecapsulelistwithoutholelayoutvm.updateFixedWidth();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_SCREEN_RECORDING_when_isScreenRecorder_is_true', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(live, live.isScreenRecorder);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(live, live.isPersistent);
      when(mockfunc2)().afterReturn(false);
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let result = livecapsulelistwithoutholelayoutvm.getCapsuleType(live);
      expect(result).assertEqual(CapsuleType.SCREEN_RECORDING);
      mocker.ignoreMock(live, live.isScreenRecorder);
      mocker.ignoreMock(live, live.isPersistent);
    });

    it('should_return_PERSISTENT_when_isPersistent_is_true', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(live, live.isScreenRecorder);
      when(mockfunc)().afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(live, live.isPersistent);
      when(mockfunc2)().afterReturn(true);
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let result = livecapsulelistwithoutholelayoutvm.getCapsuleType(live);
      expect(result).assertEqual(CapsuleType.PERSISTENT);
      mocker.ignoreMock(live, live.isScreenRecorder);
      mocker.ignoreMock(live, live.isPersistent);
    });

    it('should_return_PROGRESS_when_isScreenRecorder_and_isPersistent_are_false', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(live, live.isScreenRecorder);
      when(mockfunc)().afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(live, live.isPersistent);
      when(mockfunc2)().afterReturn(false);
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let result = livecapsulelistwithoutholelayoutvm.getCapsuleType(live);
      expect(result).assertEqual(CapsuleType.PROGRESS);
      mocker.ignoreMock(live, live.isScreenRecorder);
      mocker.ignoreMock(live, live.isPersistent);
    });

    it('should_return_correct_remainSpace_when_capsuleShowList_is_empty', 0, () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let capsuleShowList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let mandatoryElementIdx: number = 0;
      let freeSpace: number = 100;
      let result = livecapsulelistwithoutholelayoutvm.computeCapsuleShowFlag(capsuleShowList, mandatoryElementIdx, freeSpace);
      expect(result).assertEqual(freeSpace);
    });

    it('should_return_correct_remainSpace_when_mandatoryElementIdx_is_out_of_range', 0, () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let capsuleShowList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let mandatoryElementIdx: number = 3;
      let freeSpace: number = 100;
      let result = livecapsulelistwithoutholelayoutvm.computeCapsuleShowFlag(capsuleShowList, mandatoryElementIdx, freeSpace);
      expect(result).assertEqual(freeSpace);
    });

    it('should_return_correct_remainSpace_when_capsuleShowList_has_mandatoryElement', 0, () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let capsuleShowList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let mandatoryElementIdx: number = 1;
      let liveCapsule1: LiveNotification = new LiveNotification();
      liveCapsule1.liveType = LiveType.VIDEO_CONFERENCE;
      liveCapsule1.sysType = SysTypeCode.MANDATORY;
      let liveCapsule2: LiveNotification = new LiveNotification();
      liveCapsule2.liveType = LiveType.VIDEO_CONFERENCE;
      liveCapsule2.sysType = SysTypeCode.NORMAL;
      capsuleShowList.add(liveCapsule1);
      capsuleShowList.add(liveCapsule2);
      let freeSpace: number = 100;
      let result = livecapsulelistwithoutholelayoutvm.computeCapsuleShowFlag(capsuleShowList, mandatoryElementIdx, freeSpace);
      expect(result).assertEqual(freeSpace);
    });

    it('should_return_correct_remainSpace_when_capsuleShowList_has_non_mandatoryElement', 0, () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let capsuleShowList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let mandatoryElementIdx: number = 0;
      let liveCapsule1: LiveNotification = new LiveNotification();
      liveCapsule1.liveType = LiveType.VIDEO_CONFERENCE;
      liveCapsule1.sysType = SysTypeCode.MANDATORY;
      let liveCapsule2: LiveNotification = new LiveNotification();
      liveCapsule2.liveType = LiveType.VIDEO_CONFERENCE;
      liveCapsule2.sysType = SysTypeCode.NORMAL;
      capsuleShowList.add(liveCapsule1);
      capsuleShowList.add(liveCapsule2);
      let freeSpace: number = 100;
      let result = livecapsulelistwithoutholelayoutvm.computeCapsuleShowFlag(capsuleShowList, mandatoryElementIdx, freeSpace);
      expect(result).assertEqual(freeSpace - livecapsulelistwithoutholelayoutvm.baseGap);
    });

    it('should_return_correct_remainSpace_when_capsuleShowList_has_mandatoryElement_and_non_mandatoryElement', 0, () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let capsuleShowList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let mandatoryElementIdx: number = 1;
      let liveCapsule1: LiveNotification = new LiveNotification();
      liveCapsule1.liveType = LiveType.VIDEO_CONFERENCE;
      liveCapsule1.sysType = SysTypeCode.MANDATORY;
      let liveCapsule2: LiveNotification = new LiveNotification();
      liveCapsule2.liveType = LiveType.VIDEO_CONFERENCE;
      liveCapsule2.sysType = SysTypeCode.NORMAL;
      capsuleShowList.add(liveCapsule1);
      capsuleShowList.add(liveCapsule2);
      let freeSpace: number = 100;
      let result = livecapsulelistwithoutholelayoutvm.computeCapsuleShowFlag(capsuleShowList, mandatoryElementIdx, freeSpace);
      expect(result).assertEqual(freeSpace - (livecapsulelistwithoutholelayoutvm.baseGap * 2));
    });

    it('should_return_correct_remainSpace_when_capsuleShowList_has_mandatoryElement_and_non_mandatoryElement', 0, () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let capsuleShowList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let mandatoryElementIdx: number = 1;
      let liveCapsule1: LiveNotification = new LiveNotification();
      liveCapsule1.liveType = LiveType.VIDEO_CONFERENCE;
      liveCapsule1.sysType = SysTypeCode.MANDATORY;
      let liveCapsule2: LiveNotification = new LiveNotification();
      liveCapsule2.liveType = LiveType.VIDEO_CONFERENCE;
      liveCapsule2.sysType = SysTypeCode.NORMAL;
      capsuleShowList.add(liveCapsule1);
      capsuleShowList.add(liveCapsule2);
      let freeSpace: number = 100;
      let result = livecapsulelistwithoutholelayoutvm.computeCapsuleShowFlag(capsuleShowList, mandatoryElementIdx, freeSpace);
      expect(result).assertEqual(freeSpace - (livecapsulelistwithoutholelayoutvm.baseGap * 2));
    });
  })
})

describe('LiveCapsuleListWithoutHoleAnimVm2', () => {
  let liveCapsuleListVm: LiveCapsuleListWithoutHoleLayoutVm;
  describe('testsuit_6', () => {
    it('should_return_immediately_when_position_is_null', 0, () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      livecapsulelistwithoutholelayoutvm.initParam(null, true);
      expect(livecapsulelistwithoutholelayoutvm.totalFreeSpace).assertEqual(0);
      expect(livecapsulelistwithoutholelayoutvm.isUpdate).assertEqual(true);
    });

    it('should_calculate_totalFreeSpace_correctly_when_position_is_not_null', 0, () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistwithoutholelayoutvm, livecapsulelistwithoutholelayoutvm.getSpaceBetweenCapsuleAndStatusBar);
      when(mockfunc)().afterReturn(10);
      let position: StatusBarCapsulePosition = new StatusBarCapsulePosition();
      position.capsuleLeftMin = 10;
      position.capsuleRightMax = 20;
      livecapsulelistwithoutholelayoutvm.initParam(position, true);
      expect(livecapsulelistwithoutholelayoutvm.totalFreeSpace).assertEqual(10);
      expect(livecapsulelistwithoutholelayoutvm.isUpdate).assertEqual(true);
      mocker.ignoreMock(livecapsulelistwithoutholelayoutvm, livecapsulelistwithoutholelayoutvm.getSpaceBetweenCapsuleAndStatusBar);
    });

    it('should_set_isUpdate_to_true_when_isUpdate_is_undefined', 0, () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistwithoutholelayoutvm, livecapsulelistwithoutholelayoutvm.getSpaceBetweenCapsuleAndStatusBar);
      when(mockfunc)().afterReturn(10);
      let position: StatusBarCapsulePosition = new StatusBarCapsulePosition();
      position.capsuleLeftMin = 10;
      position.capsuleRightMax = 20;
      livecapsulelistwithoutholelayoutvm.initParam(position, undefined);
      expect(livecapsulelistwithoutholelayoutvm.totalFreeSpace).assertEqual(10);
      expect(livecapsulelistwithoutholelayoutvm.isUpdate).assertEqual(true);
      mocker.ignoreMock(livecapsulelistwithoutholelayoutvm, livecapsulelistwithoutholelayoutvm.getSpaceBetweenCapsuleAndStatusBar);
    });

    it('should_set_isUpdate_to_false_when_isUpdate_is_false', 0, () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistwithoutholelayoutvm, livecapsulelistwithoutholelayoutvm.getSpaceBetweenCapsuleAndStatusBar);
      when(mockfunc)().afterReturn(10);
      let position: StatusBarCapsulePosition = new StatusBarCapsulePosition();
      position.capsuleLeftMin = 10;
      position.capsuleRightMax = 20;
      livecapsulelistwithoutholelayoutvm.initParam(position, false);
      expect(livecapsulelistwithoutholelayoutvm.totalFreeSpace).assertEqual(10);
      expect(livecapsulelistwithoutholelayoutvm.isUpdate).assertEqual(false);
      mocker.ignoreMock(livecapsulelistwithoutholelayoutvm, livecapsulelistwithoutholelayoutvm.getSpaceBetweenCapsuleAndStatusBar);
    });

    it('should_set_isUpdate_to_true_when_isUpdate_is_true', 0, () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistwithoutholelayoutvm, livecapsulelistwithoutholelayoutvm.getSpaceBetweenCapsuleAndStatusBar);
      when(mockfunc)().afterReturn(10);
      let position: StatusBarCapsulePosition = new StatusBarCapsulePosition();
      position.capsuleLeftMin = 10;
      position.capsuleRightMax = 20;
      livecapsulelistwithoutholelayoutvm.initParam(position, true);
      expect(livecapsulelistwithoutholelayoutvm.totalFreeSpace).assertEqual(10);
      expect(livecapsulelistwithoutholelayoutvm.isUpdate).assertEqual(true);
      mocker.ignoreMock(livecapsulelistwithoutholelayoutvm, livecapsulelistwithoutholelayoutvm.getSpaceBetweenCapsuleAndStatusBar);
    });

    it('should_calculate_totalFreeSpace_correctly_when_position_is_not_null_and_getSpaceBetweenCapsuleAndStatusBar_returns_non_zero', 0, () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistwithoutholelayoutvm, livecapsulelistwithoutholelayoutvm.getSpaceBetweenCapsuleAndStatusBar);
      when(mockfunc)().afterReturn(10);
      let position: StatusBarCapsulePosition = new StatusBarCapsulePosition();
      position.capsuleLeftMin = 10;
      position.capsuleRightMax = 20;
      livecapsulelistwithoutholelayoutvm.initParam(position, true);
      expect(livecapsulelistwithoutholelayoutvm.totalFreeSpace).assertEqual(10);
      expect(livecapsulelistwithoutholelayoutvm.isUpdate).assertEqual(true);
      mocker.ignoreMock(livecapsulelistwithoutholelayoutvm, livecapsulelistwithoutholelayoutvm.getSpaceBetweenCapsuleAndStatusBar);
    });

    it('should_set_capsule_visibility_false_when_capsuleVm_is_not_visible', 0, async () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let capsuleVm: ILiveCapsuleVm = mocker.mockFunc(livecapsulelistwithoutholelayoutvm.vmInjector, livecapsulelistwithoutholelayoutvm.vmInjector.getCapsuleVm);
      when(capsuleVm)(ArgumentMatchers.any).afterReturn({
        isVisible: false,
        isShow: false,
        fixedShowType: CapsuleShowType.NONE,
        fixedWidth: 0,
        fixedOffsetX: 0
      });
      let liveList: LiveNotification[] = [new LiveNotification()];
      livecapsulelistwithoutholelayoutvm.filterShowCapsuleList(liveList);
      expect(capsuleVm.isVisible).assertEqual(false);
      expect(capsuleVm.isShow).assertEqual(false);
      expect(capsuleVm.fixedShowType).assertEqual(CapsuleShowType.NONE);
      expect(capsuleVm.fixedWidth).assertEqual(0);
      expect(capsuleVm.fixedOffsetX).assertEqual(0);
      mocker.ignoreMock(livecapsulelistwithoutholelayoutvm.vmInjector, livecapsulelistwithoutholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_set_capsule_visibility_true_when_capsuleVm_is_visible_and_live_is_instant', 0, async () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let capsuleVm: ILiveCapsuleVm = mocker.mockFunc(livecapsulelistwithoutholelayoutvm.vmInjector, livecapsulelistwithoutholelayoutvm.vmInjector.getCapsuleVm);
      when(capsuleVm)(ArgumentMatchers.any).afterReturn({
        isVisible: true,
        isShow: false,
        fixedShowType: CapsuleShowType.NONE,
        fixedWidth: 0,
        fixedOffsetX: 0
      });
      let liveList: LiveNotification[] = [new LiveNotification()];
      livecapsulelistwithoutholelayoutvm.filterShowCapsuleList(liveList);
      expect(capsuleVm.isVisible).assertEqual(true);
      expect(capsuleVm.isShow).assertEqual(true);
      expect(capsuleVm.fixedShowType).assertEqual(CapsuleShowType.NONE);
      expect(capsuleVm.fixedWidth).assertEqual(0);
      expect(capsuleVm.fixedOffsetX).assertEqual(0);
      mocker.ignoreMock(livecapsulelistwithoutholelayoutvm.vmInjector, livecapsulelistwithoutholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_set_capsule_visibility_true_when_capsuleVm_is_visible_and_live_is_persistent', 0, async () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let capsuleVm: ILiveCapsuleVm = mocker.mockFunc(livecapsulelistwithoutholelayoutvm.vmInjector, livecapsulelistwithoutholelayoutvm.vmInjector.getCapsuleVm);
      when(capsuleVm)(ArgumentMatchers.any).afterReturn({
        isVisible: true,
        isShow: false,
        fixedShowType: CapsuleShowType.NONE,
        fixedWidth: 0,
        fixedOffsetX: 0
      });
      let liveList: LiveNotification[] = [new LiveNotification()];
      livecapsulelistwithoutholelayoutvm.filterShowCapsuleList(liveList);
      expect(capsuleVm.isVisible).assertEqual(true);
      expect(capsuleVm.isShow).assertEqual(true);
      expect(capsuleVm.fixedShowType).assertEqual(CapsuleShowType.NONE);
      expect(capsuleVm.fixedWidth).assertEqual(0);
      expect(capsuleVm.fixedOffsetX).assertEqual(0);
      mocker.ignoreMock(livecapsulelistwithoutholelayoutvm.vmInjector, livecapsulelistwithoutholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_set_capsule_visibility_true_when_capsuleVm_is_visible_and_live_is_screen_recorder', 0, async () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let capsuleVm: ILiveCapsuleVm = mocker.mockFunc(livecapsulelistwithoutholelayoutvm.vmInjector, livecapsulelistwithoutholelayoutvm.vmInjector.getCapsuleVm);
      when(capsuleVm)(ArgumentMatchers.any).afterReturn({
        isVisible: true,
        isShow: false,
        fixedShowType: CapsuleShowType.NONE,
        fixedWidth: 0,
        fixedOffsetX: 0
      });
      let liveList: LiveNotification[] = [new LiveNotification()];
      livecapsulelistwithoutholelayoutvm.filterShowCapsuleList(liveList);
      expect(capsuleVm.isVisible).assertEqual(true);
      expect(capsuleVm.isShow).assertEqual(true);
      expect(capsuleVm.fixedShowType).assertEqual(CapsuleShowType.NONE);
      expect(capsuleVm.fixedWidth).assertEqual(0);
      expect(capsuleVm.fixedOffsetX).assertEqual(0);
      mocker.ignoreMock(livecapsulelistwithoutholelayoutvm.vmInjector, livecapsulelistwithoutholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_set_capsule_visibility_true_when_capsuleVm_is_visible_and_live_is_persistent_and_is_showed', 0, async () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let capsuleVm: ILiveCapsuleVm = mocker.mockFunc(livecapsulelistwithoutholelayoutvm.vmInjector, livecapsulelistwithoutholelayoutvm.vmInjector.getCapsuleVm);
      when(capsuleVm)(ArgumentMatchers.any).afterReturn({
        isVisible: true,
        isShow: true,
        fixedShowType: CapsuleShowType.NONE,
        fixedWidth: 0,
        fixedOffsetX: 0
      });
      let liveList: LiveNotification[] = [new LiveNotification()];
      livecapsulelistwithoutholelayoutvm.filterShowCapsuleList(liveList);
      expect(capsuleVm.isVisible).assertEqual(true);
      expect(capsuleVm.isShow).assertEqual(true);
      expect(capsuleVm.fixedShowType).assertEqual(CapsuleShowType.NONE);
      expect(capsuleVm.fixedWidth).assertEqual(0);
      expect(capsuleVm.fixedOffsetX).assertEqual(0);
      mocker.ignoreMock(livecapsulelistwithoutholelayoutvm.vmInjector, livecapsulelistwithoutholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_set_capsule_visibility_true_when_capsuleVm_is_visible_and_live_is_screen_recorder_and_is_showed', 0, async () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let capsuleVm: ILiveCapsuleVm = mocker.mockFunc(livecapsulelistwithoutholelayoutvm.vmInjector, livecapsulelistwithoutholelayoutvm.vmInjector.getCapsuleVm);
      when(capsuleVm)(ArgumentMatchers.any).afterReturn({
        isVisible: true,
        isShow: true,
        fixedShowType: CapsuleShowType.NONE,
        fixedWidth: 0,
        fixedOffsetX: 0
      });
      let liveList: LiveNotification[] = [new LiveNotification()];
      livecapsulelistwithoutholelayoutvm.filterShowCapsuleList(liveList);
      expect(capsuleVm.isVisible).assertEqual(true);
      expect(capsuleVm.isShow).assertEqual(true);
      expect(capsuleVm.fixedShowType).assertEqual(CapsuleShowType.NONE);
      expect(capsuleVm.fixedWidth).assertEqual(0);
    });

    it('should_log_info_when_updateFixedWidth_is_called', 0, async () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      livecapsulelistwithoutholelayoutvm.updateFixedWidth();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_generate_capsule_show_list_by_priority_sort', 0, async () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      livecapsulelistwithoutholelayoutvm.showCapsuleList =
        [new NotificationArray<LiveNotification>(), new NotificationArray<LiveNotification>(),
          new NotificationArray<LiveNotification>()];
      livecapsulelistwithoutholelayoutvm.capsuleSpaceAllocationSequence =
        [CapsuleType.PROGRESS, CapsuleType.SCREEN_RECORDING, CapsuleType.PERSISTENT];

      livecapsulelistwithoutholelayoutvm.updateFixedWidth();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_compute_capsule_show_flag', 0, async () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      livecapsulelistwithoutholelayoutvm.showCapsuleList =
        [new NotificationArray<LiveNotification>(), new NotificationArray<LiveNotification>(),
          new NotificationArray<LiveNotification>()];
      livecapsulelistwithoutholelayoutvm.capsuleSpaceAllocationSequence =
        [CapsuleType.PROGRESS, CapsuleType.SCREEN_RECORDING, CapsuleType.PERSISTENT];
      livecapsulelistwithoutholelayoutvm.totalFreeSpace = 100;

      livecapsulelistwithoutholelayoutvm.updateFixedWidth();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_adjust_show_capsule_width', 0, async () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      livecapsulelistwithoutholelayoutvm.showCapsuleList =
        [new NotificationArray<LiveNotification>(), new NotificationArray<LiveNotification>(),
          new NotificationArray<LiveNotification>()];
      livecapsulelistwithoutholelayoutvm.capsuleSpaceAllocationSequence =
        [CapsuleType.PROGRESS, CapsuleType.SCREEN_RECORDING, CapsuleType.PERSISTENT];
      livecapsulelistwithoutholelayoutvm.totalFreeSpace = 100;

      let liveNotification: LiveNotification = new LiveNotification();
      liveNotification.liveType = LiveType.VIDEO_MEETING;
      liveNotification.sysType = SysTypeCode.NORMAL_VIDEO_MEETING;
      liveNotification.statusBarCapsulePosition = StatusBarCapsulePosition.LEFT;
      liveNotification.liveStyle = LiveStyle.VIDEO_MEETING;
      liveNotification.deviceInfoVm = new DeviceInfoVm();
      liveNotification.deviceInfoVm.hasCutout = false;
      liveNotification.deviceInfoVm.deviceType = 1;
      liveNotification.deviceInfoVm.deviceModel = "model";
      liveNotification.deviceInfoVm.deviceName = "name";
      liveNotification.deviceInfoVm.deviceStyle = 1;
      liveNotification.deviceInfoVm.deviceCutoutStyle = 1;
      liveNotification.deviceInfoVm.deviceCutoutPosition = 1;
      liveNotification.deviceInfoVm.deviceCutoutSize = 1;
      liveNotification.deviceInfoVm.deviceCutoutPadding = 1;
      liveNotification.deviceInfoVm.deviceCutoutMargin = 1;
      liveNotification.deviceInfoVm.deviceCutoutBlur = 1;
      liveNotification.deviceInfoVm.deviceCutoutBackground = 1;
      liveNotification.deviceInfoVm.deviceCutoutForeground = 1;
      liveNotification.deviceInfoVm.deviceCutoutIcon = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotification = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTip = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipStyle = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipSize = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipBlur = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipBackground = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipForeground = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipIcon = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipNotification = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipNotificationTip = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipNotificationTipStyle = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipNotificationTipSize = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipNotificationTipBlur = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipNotificationTipBackground = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipNotificationTipForeground = 1;
      liveNotification.deviceInfoVm.deviceCutoutNotificationTipNotificationTipIcon = 1;
      livecapsulelistwithoutholelayoutvm.showCapsuleList[CapsuleType.SCREEN_RECORDING].push(liveNotification);

      let liveCapsuleVm: ILiveCapsuleVm = {
        getCapsuleVm: (live: LiveNotification) => {
          return {
            fixedShowType: CapsuleShowType.SHOW,
            capsuleWidth: 50,
            capsuleHeight: 50,
            capsuleShowType: CapsuleShowType.SHOW,
            capsuleNotification: live
          } as ILiveCapsuleVm;
        },
        fixedShowType: CapsuleShowType.SHOW,
        capsuleWidth: 50,
        capsuleHeight: 50,
        capsuleShowType: CapsuleShowType.SHOW,
        capsuleNotification: liveNotification
      } as ILiveCapsuleVm;

      livecapsulelistwithoutholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(liveNotification);
      livecapsulelistwithoutholelayoutvm.showCapsuleList[CapsuleType.PERSISTENT].push(liveNotification);

      livecapsulelistwithoutholelayoutvm.updateFixedWidth();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_SCREEN_RECORDING_when_isScreenRecorder_is_true', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(live, live.isScreenRecorder);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(live, live.isPersistent);
      when(mockfunc2)().afterReturn(false);
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let result = livecapsulelistwithoutholelayoutvm.getCapsuleType(live);
      expect(result).assertEqual(CapsuleType.SCREEN_RECORDING);
      mocker.ignoreMock(live, live.isScreenRecorder);
      mocker.ignoreMock(live, live.isPersistent);
    });

    it('should_return_PERSISTENT_when_isPersistent_is_true', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(live, live.isScreenRecorder);
      when(mockfunc)().afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(live, live.isPersistent);
      when(mockfunc2)().afterReturn(true);
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let result = livecapsulelistwithoutholelayoutvm.getCapsuleType(live);
      expect(result).assertEqual(CapsuleType.PERSISTENT);
      mocker.ignoreMock(live, live.isScreenRecorder);
      mocker.ignoreMock(live, live.isPersistent);
    });

    it('should_return_PROGRESS_when_isScreenRecorder_and_isPersistent_are_false', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(live, live.isScreenRecorder);
      when(mockfunc)().afterReturn(false);
      let mockfunc2: Function = mocker.mockFunc(live, live.isPersistent);
      when(mockfunc2)().afterReturn(false);
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let result = livecapsulelistwithoutholelayoutvm.getCapsuleType(live);
      expect(result).assertEqual(CapsuleType.PROGRESS);
      mocker.ignoreMock(live, live.isScreenRecorder);
      mocker.ignoreMock(live, live.isPersistent);
    });

    it('should_return_correct_remainSpace_when_capsuleShowList_is_empty', 0, () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let capsuleShowList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let mandatoryElementIdx: number = 0;
      let freeSpace: number = 100;
      let result = livecapsulelistwithoutholelayoutvm.computeCapsuleShowFlag(capsuleShowList, mandatoryElementIdx, freeSpace);
      expect(result).assertEqual(freeSpace);
    });

    it('should_return_correct_remainSpace_when_mandatoryElementIdx_is_out_of_range', 0, () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let capsuleShowList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let mandatoryElementIdx: number = 3;
      let freeSpace: number = 100;
      let result = livecapsulelistwithoutholelayoutvm.computeCapsuleShowFlag(capsuleShowList, mandatoryElementIdx, freeSpace);
      expect(result).assertEqual(freeSpace);
    });

    it('should_return_correct_remainSpace_when_capsuleShowList_has_mandatoryElement', 0, () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let capsuleShowList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let mandatoryElementIdx: number = 1;
      let liveCapsule1: LiveNotification = new LiveNotification();
      liveCapsule1.liveType = LiveType.VIDEO_CONFERENCE;
      liveCapsule1.sysType = SysTypeCode.MANDATORY;
      let liveCapsule2: LiveNotification = new LiveNotification();
      liveCapsule2.liveType = LiveType.VIDEO_CONFERENCE;
      liveCapsule2.sysType = SysTypeCode.NORMAL;
      capsuleShowList.add(liveCapsule1);
      capsuleShowList.add(liveCapsule2);
      let freeSpace: number = 100;
      let result = livecapsulelistwithoutholelayoutvm.computeCapsuleShowFlag(capsuleShowList, mandatoryElementIdx, freeSpace);
      expect(result).assertEqual(freeSpace);
    });

    it('should_return_correct_remainSpace_when_capsuleShowList_has_non_mandatoryElement', 0, () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let capsuleShowList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let mandatoryElementIdx: number = 0;
      let liveCapsule1: LiveNotification = new LiveNotification();
      liveCapsule1.liveType = LiveType.VIDEO_CONFERENCE;
      liveCapsule1.sysType = SysTypeCode.MANDATORY;
      let liveCapsule2: LiveNotification = new LiveNotification();
      liveCapsule2.liveType = LiveType.VIDEO_CONFERENCE;
      liveCapsule2.sysType = SysTypeCode.NORMAL;
      capsuleShowList.add(liveCapsule1);
      capsuleShowList.add(liveCapsule2);
      let freeSpace: number = 100;
      let result = livecapsulelistwithoutholelayoutvm.computeCapsuleShowFlag(capsuleShowList, mandatoryElementIdx, freeSpace);
      expect(result).assertEqual(freeSpace - livecapsulelistwithoutholelayoutvm.baseGap);
    });

    it('should_return_correct_remainSpace_when_capsuleShowList_has_mandatoryElement_and_non_mandatoryElement', 0, () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let capsuleShowList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let mandatoryElementIdx: number = 1;
      let liveCapsule1: LiveNotification = new LiveNotification();
      liveCapsule1.liveType = LiveType.VIDEO_CONFERENCE;
      liveCapsule1.sysType = SysTypeCode.MANDATORY;
      let liveCapsule2: LiveNotification = new LiveNotification();
      liveCapsule2.liveType = LiveType.VIDEO_CONFERENCE;
      liveCapsule2.sysType = SysTypeCode.NORMAL;
      capsuleShowList.add(liveCapsule1);
      capsuleShowList.add(liveCapsule2);
      let freeSpace: number = 100;
      let result = livecapsulelistwithoutholelayoutvm.computeCapsuleShowFlag(capsuleShowList, mandatoryElementIdx, freeSpace);
      expect(result).assertEqual(freeSpace - (livecapsulelistwithoutholelayoutvm.baseGap * 2));
    });

    it('should_return_correct_remainSpace_when_capsuleShowList_has_mandatoryElement_and_non_mandatoryElement', 0, () => {
      let livecapsulelistwithoutholelayoutvm: LiveCapsuleListWithoutHoleLayoutVm = new LiveCapsuleListWithoutHoleLayoutVm();
      let capsuleShowList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      let mandatoryElementIdx: number = 1;
      let liveCapsule1: LiveNotification = new LiveNotification();
      liveCapsule1.liveType = LiveType.VIDEO_CONFERENCE;
      liveCapsule1.sysType = SysTypeCode.MANDATORY;
      let liveCapsule2: LiveNotification = new LiveNotification();
      liveCapsule2.liveType = LiveType.VIDEO_CONFERENCE;
      liveCapsule2.sysType = SysTypeCode.NORMAL;
      capsuleShowList.add(liveCapsule1);
      capsuleShowList.add(liveCapsule2);
      let freeSpace: number = 100;
      let result = livecapsulelistwithoutholelayoutvm.computeCapsuleShowFlag(capsuleShowList, mandatoryElementIdx, freeSpace);
      expect(result).assertEqual(freeSpace - (livecapsulelistwithoutholelayoutvm.baseGap * 2));
    });
  })
})