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
import { CutoutVm, DeviceInfoVm, StatusBarCapsulePosition } from '';
import { ILiveCapsuleVm } from '../../../../main/ets/live/interface/ILiveCapsuleVm';
import { SysTypeCode } from '../../../../main/ets/TsIndex';
import { ILiveCapsuleListLayoutVm } from '../../../../main/ets/live/interface/ILiveCapsuleLayoutVm';
import { LiveType } from '../../../../main/ets/live/model/LiveCommonModel';
import { LiveCapsuleListLayoutBaseVm } from '../../../../main/ets/live/vm/LiveCapsuleListLayoutBaseVm';
import { LiveStyle } from '../../../../main/ets/live/constants/LiveStyle';
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
import { LiveCapsuleListSingleHoleLayoutVm } from '../../../../main/ets/live/vm/LiveCapsuleListSingleHoleLayoutVm';

export default function LiveCapsuleListSingleHoleLayoutVmTest() {
  describe('computeCapsuleFixedWithAndOffset_testSuite', () => {

    beforeEach(() => {
    });
    afterEach(() => {

    });

    it('should_execute_all_steps_when_liveList_is_valid', 0, () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.checkParam);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);
      let mockfunc2: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.initParam);
      when(mockfunc2)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturnNothing();
      let mockfunc3: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.filterShowCapsuleList);
      when(mockfunc3)(ArgumentMatchers.any).afterReturnNothing();
      let mockfunc4: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.moveScreen2ProgressCapsule);
      when(mockfunc4)().afterReturnNothing();
      let mockfunc5: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.updateFixedWidth);
      when(mockfunc5)().afterReturnNothing();
      let mockfunc6: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.updateFixedOffset);
      when(mockfunc6)().afterReturnNothing();
      let mockfunc7: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.modifyFixedWidthAndFixedOffsetByShowType);
      when(mockfunc7)().afterReturnNothing();
      let mockfunc8: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.printFixedWithAndeOffset);
      when(mockfunc8)(ArgumentMatchers.any).afterReturnNothing();
      livecapsulelistsingleholelayoutvm.computeCapsuleFixedWithAndOffset([new LiveNotification()], true);
      mocker.verify('updateFixedWidth', []).once();
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.checkParam);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.initParam);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.filterShowCapsuleList);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.moveScreen2ProgressCapsule);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.updateFixedWidth);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.updateFixedOffset);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.modifyFixedWidthAndFixedOffsetByShowType);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.printFixedWithAndeOffset);
    });
    it('should_set_capsule_width_correctly_when_live_is_flip_and_increasesUsedSpace_is_greater_than_zero', 0,
      async () => {
        let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
          new LiveCapsuleListSingleHoleLayoutVm();
        let mocker: MockKit = new MockKit();

        let mockGetCapsuleVm: Function =
          mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleVm);
        let mockGetCapsuleMarqueeVm: Function =
          mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleMarqueeVm);
        let mockGetCapsuleGap: Function =
          mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
        let mockAdjustFixedWidthForHangingWithExtend: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm,
          livecapsulelistsingleholelayoutvm.adjustFixedWidthForHangingWithExtend);
        let mockGetTextWidthBySize: Function =
          mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getTextWidthBySize);
        let mockGetCapsuleMarqueeWithoutTextWidth: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm,
          livecapsulelistsingleholelayoutvm.getCapsuleMarqueeWithoutTextWidth);
        let mockIsFlip: Function = mocker.mockFunc(LiveNotification.prototype, LiveNotification.prototype.isFlip);
        let mockGetText: Function =
          mocker.mockFunc(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.getText);

        let live: LiveNotification = new LiveNotification();
        let capsuleVm: ILiveCapsuleVm = new ILiveCapsuleVm();
        let capsuleMarqueeVm: ILiveCapsuleListLayoutVm = new ILiveCapsuleListLayoutVm();

        when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);
        when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn(capsuleMarqueeVm);
        when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(4);
        when(mockAdjustFixedWidthForHangingWithExtend)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any,
          ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(10);
        when(mockGetTextWidthBySize)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(20);
        when(mockGetCapsuleMarqueeWithoutTextWidth)(ArgumentMatchers.any).afterReturn(10);
        when(mockIsFlip)().afterReturn(true);
        when(mockGetText)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn("test");

        livecapsulelistsingleholelayoutvm.setRemindCapsuleWidth(live, false);

        expect(capsuleVm.fixedWidth).assertEqual(34);
        expect(capsuleMarqueeVm.fixedTextWidth).assertEqual(16);

        mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleVm);
        mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleMarqueeVm);
        mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
        mocker.ignoreMock(livecapsulelistsingleholelayoutvm,
          livecapsulelistsingleholelayoutvm.adjustFixedWidthForHangingWithExtend);
        mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getTextWidthBySize);
        mocker.ignoreMock(livecapsulelistsingleholelayoutvm,
          livecapsulelistsingleholelayoutvm.getCapsuleMarqueeWithoutTextWidth);
        mocker.ignoreMock(LiveNotification.prototype, LiveNotification.prototype.isFlip);
        mocker.ignoreMock(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.getText);
      });

    it('should_set_capsule_width_correctly_when_live_is_not_flip_and_width_is_less_than_max_width', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleMarqueeVm);
      let mockGetCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      let mockGetTextWidthBySize: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getTextWidthBySize);
      let mockGetCapsuleMarqueeWithoutTextWidth: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.getCapsuleMarqueeWithoutTextWidth);
      let mockIsFlip: Function = mocker.mockFunc(LiveNotification.prototype, LiveNotification.prototype.isFlip);
      let mockGetText: Function =
        mocker.mockFunc(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.getText);

      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new ILiveCapsuleVm();
      let capsuleMarqueeVm: ILiveCapsuleListLayoutVm = new ILiveCapsuleListLayoutVm();

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn(capsuleMarqueeVm);
      when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(4);
      when(mockGetTextWidthBySize)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(20);
      when(mockGetCapsuleMarqueeWithoutTextWidth)(ArgumentMatchers.any).afterReturn(10);
      when(mockIsFlip)().afterReturn(false);
      when(mockGetText)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn("test");

      livecapsulelistsingleholelayoutvm.setRemindCapsuleWidth(live, false);

      expect(capsuleVm.fixedWidth).assertEqual(34);
      expect(capsuleMarqueeVm.fixedTextWidth).assertEqual(16);

      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleMarqueeVm);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getTextWidthBySize);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.getCapsuleMarqueeWithoutTextWidth);
      mocker.ignoreMock(LiveNotification.prototype, LiveNotification.prototype.isFlip);
      mocker.ignoreMock(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.getText);
    });
    it('should_calculate_correct_offset_when_progress_capsule_has_holes_on_both_sides', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogHelperShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let mockIsShowHoleLeft: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      when(mockIsShowHoleLeft)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockIsShowHoleRight: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      when(mockIsShowHoleRight)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      livecapsulelistsingleholelayoutvm.showCapsuleList = [
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()
      ];
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS] =
        new NotificationArray<LiveNotification>();
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());

      livecapsulelistsingleholelayoutvm.leftMinFreeSpace = 10;
      livecapsulelistsingleholelayoutvm.leftWithoutTimeTotalFreeSpace = 20;
      livecapsulelistsingleholelayoutvm.leftTotalFreeSpace = 30;
      livecapsulelistsingleholelayoutvm.rightTotalFreeSpace = 40;
      livecapsulelistsingleholelayoutvm.avoidStart = 5;
      livecapsulelistsingleholelayoutvm.avoidEnd = 6;

      let result = livecapsulelistsingleholelayoutvm.updateProgressCapsuleFixedOffset();

      expect(result).assertEqual(0);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_calculate_correct_offset_when_progress_capsule_has_holes_on_left_side_only', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogHelperShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let mockIsShowHoleLeft: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      when(mockIsShowHoleLeft)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockIsShowHoleRight: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      when(mockIsShowHoleRight)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(false);

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);
      livecapsulelistsingleholelayoutvm.showCapsuleList = [
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()
      ];
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS] =
        new NotificationArray<LiveNotification>();
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.leftMinFreeSpace = 10;
      livecapsulelistsingleholelayoutvm.leftWithoutTimeTotalFreeSpace = 20;
      livecapsulelistsingleholelayoutvm.leftTotalFreeSpace = 30;
      livecapsulelistsingleholelayoutvm.rightTotalFreeSpace = 40;
      livecapsulelistsingleholelayoutvm.avoidStart = 5;
      livecapsulelistsingleholelayoutvm.avoidEnd = 6;

      let result = livecapsulelistsingleholelayoutvm.updateProgressCapsuleFixedOffset();

      expect(result).assertEqual(0);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_update_fixed_offset_when_capsule_is_show', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let liveCapsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      liveCapsuleList.add(new LiveNotification());

      let result = livecapsulelistsingleholelayoutvm.updateFixedOffsetByOffset(100, liveCapsuleList,
        CapsuleType.VIDEO_TIME_capsuleType);

      expect(result).assertEqual(95);

      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
    });

    it('should_not_update_fixed_offset_when_capsule_is_not_show', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: false,
        fixedWidth: 100,
        fixedOffsetX: 0
      };

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let liveCapsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      liveCapsuleList.add(new LiveNotification());

      let result = livecapsulelistsingleholelayoutvm.updateFixedOffsetByOffset(100, liveCapsuleList,
        CapsuleType.VIDEO_TIME_capsuleType);

      expect(result).assertEqual(100);

      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
    });

    it('should_update_fixed_offset_when_liveCapsuleList_is_empty', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let liveCapsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();

      let result = livecapsulelistsingleholelayoutvm.updateFixedOffsetByOffset(100, liveCapsuleList,
        CapsuleType.VIDEO_TIME_capsuleType);

      expect(result).assertEqual(100);

      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
    });
    it('should_calculate_correct_offset_when_progress_capsule_has_holes_on_left_side_only', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogHelperShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let mockIsShowHoleLeft: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      when(mockIsShowHoleLeft)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockIsShowHoleRight: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      when(mockIsShowHoleRight)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(false);

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      livecapsulelistsingleholelayoutvm.showCapsuleList = [
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()
      ];
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS] =
        new NotificationArray<LiveNotification>();
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());

      livecapsulelistsingleholelayoutvm.leftMinFreeSpace = 10;
      livecapsulelistsingleholelayoutvm.leftWithoutTimeTotalFreeSpace = 20;
      livecapsulelistsingleholelayoutvm.leftTotalFreeSpace = 30;
      livecapsulelistsingleholelayoutvm.rightTotalFreeSpace = 40;
      livecapsulelistsingleholelayoutvm.avoidStart = 5;
      livecapsulelistsingleholelayoutvm.avoidEnd = 6;

      let result = livecapsulelistsingleholelayoutvm.updateProgressCapsuleFixedOffset();

      expect(result).assertEqual(0);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_calculate_correct_offset_when_progress_capsule_has_holes_on_both_sides', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm = new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogHelperShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetCapsuleGap: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let mockIsShowHoleLeft: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      when(mockIsShowHoleLeft)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockIsShowHoleRight: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      when(mockIsShowHoleRight)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector, livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      livecapsulelistsingleholelayoutvm.showCapsuleList = [
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()
      ];
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS] = new NotificationArray<LiveNotification>();
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.leftMinFreeSpace = 10;
      livecapsulelistsingleholelayoutvm.leftWithoutTimeTotalFreeSpace = 20;
      livecapsulelistsingleholelayoutvm.leftTotalFreeSpace = 30;
      livecapsulelistsingleholelayoutvm.rightTotalFreeSpace = 40;
      livecapsulelistsingleholelayoutvm.avoidStart = 5;
      livecapsulelistsingleholelayoutvm.avoidEnd = 6;
      let result = livecapsulelistsingleholelayoutvm.updateProgressCapsuleFixedOffset();
      expect(result).assertEqual(0);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector, livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_execute_all_steps_when_liveList_is_valid', 0, () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.checkParam);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);
      let mockfunc2: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.initParam);
      when(mockfunc2)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturnNothing();
      let mockfunc3: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.filterShowCapsuleList);
      when(mockfunc3)(ArgumentMatchers.any).afterReturnNothing();
      let mockfunc4: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.moveScreen2ProgressCapsule);
      when(mockfunc4)().afterReturnNothing();
      let mockfunc5: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.updateFixedWidth);
      when(mockfunc5)().afterReturnNothing();
      let mockfunc6: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.updateFixedOffset);
      when(mockfunc6)().afterReturnNothing();
      let mockfunc7: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.modifyFixedWidthAndFixedOffsetByShowType);
      when(mockfunc7)().afterReturnNothing();
      let mockfunc8: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.printFixedWithAndeOffset);
      when(mockfunc8)(ArgumentMatchers.any).afterReturnNothing();
      livecapsulelistsingleholelayoutvm.computeCapsuleFixedWithAndOffset([new LiveNotification()], true);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.checkParam);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.initParam);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.filterShowCapsuleList);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.moveScreen2ProgressCapsule);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.updateFixedWidth);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.updateFixedOffset);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.modifyFixedWidthAndFixedOffsetByShowType);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.printFixedWithAndeOffset);
    });
    it('should_set_capsule_width_correctly_when_live_is_flip_and_increasesUsedSpace_is_greater_than_zero', 0,
      async () => {
        let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
          new LiveCapsuleListSingleHoleLayoutVm();
        let mocker: MockKit = new MockKit();

        let mockGetCapsuleVm: Function =
          mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleVm);
        let mockGetCapsuleMarqueeVm: Function =
          mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleMarqueeVm);
        let mockGetCapsuleGap: Function =
          mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
        let mockAdjustFixedWidthForHangingWithExtend: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm,
          livecapsulelistsingleholelayoutvm.adjustFixedWidthForHangingWithExtend);
        let mockGetTextWidthBySize: Function =
          mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getTextWidthBySize);
        let mockGetCapsuleMarqueeWithoutTextWidth: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm,
          livecapsulelistsingleholelayoutvm.getCapsuleMarqueeWithoutTextWidth);
        let mockIsFlip: Function = mocker.mockFunc(LiveNotification.prototype, LiveNotification.prototype.isFlip);
        let mockGetText: Function =
          mocker.mockFunc(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.getText);

        let live: LiveNotification = new LiveNotification();
        let capsuleVm: ILiveCapsuleVm = new ILiveCapsuleVm();
        let capsuleMarqueeVm: ILiveCapsuleListLayoutVm = new ILiveCapsuleListLayoutVm();

        when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);
        when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn(capsuleMarqueeVm);
        when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(4);
        when(mockAdjustFixedWidthForHangingWithExtend)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any,
          ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(10);
        when(mockGetTextWidthBySize)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(20);
        when(mockGetCapsuleMarqueeWithoutTextWidth)(ArgumentMatchers.any).afterReturn(10);
        when(mockIsFlip)().afterReturn(true);
        when(mockGetText)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn("test");

        livecapsulelistsingleholelayoutvm.setRemindCapsuleWidth(live, false);

        expect(capsuleVm.fixedWidth).assertEqual(34);
        expect(capsuleMarqueeVm.fixedTextWidth).assertEqual(16);

        mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleVm);
        mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleMarqueeVm);
        mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
        mocker.ignoreMock(livecapsulelistsingleholelayoutvm,
          livecapsulelistsingleholelayoutvm.adjustFixedWidthForHangingWithExtend);
        mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getTextWidthBySize);
        mocker.ignoreMock(livecapsulelistsingleholelayoutvm,
          livecapsulelistsingleholelayoutvm.getCapsuleMarqueeWithoutTextWidth);
        mocker.ignoreMock(LiveNotification.prototype, LiveNotification.prototype.isFlip);
        mocker.ignoreMock(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.getText);
      });

    it('should_set_capsule_width_correctly_when_live_is_not_flip_and_width_is_less_than_max_width', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleMarqueeVm);
      let mockGetCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      let mockGetTextWidthBySize: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getTextWidthBySize);
      let mockGetCapsuleMarqueeWithoutTextWidth: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.getCapsuleMarqueeWithoutTextWidth);
      let mockIsFlip: Function = mocker.mockFunc(LiveNotification.prototype, LiveNotification.prototype.isFlip);
      let mockGetText: Function =
        mocker.mockFunc(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.getText);

      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new ILiveCapsuleVm();
      let capsuleMarqueeVm: ILiveCapsuleListLayoutVm = new ILiveCapsuleListLayoutVm();

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn(capsuleMarqueeVm);
      when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(4);
      when(mockGetTextWidthBySize)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(20);
      when(mockGetCapsuleMarqueeWithoutTextWidth)(ArgumentMatchers.any).afterReturn(10);
      when(mockIsFlip)().afterReturn(false);
      when(mockGetText)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn("test");

      livecapsulelistsingleholelayoutvm.setRemindCapsuleWidth(live, false);

      expect(capsuleVm.fixedWidth).assertEqual(34);
      expect(capsuleMarqueeVm.fixedTextWidth).assertEqual(16);

      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleMarqueeVm);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getTextWidthBySize);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.getCapsuleMarqueeWithoutTextWidth);
      mocker.ignoreMock(LiveNotification.prototype, LiveNotification.prototype.isFlip);
      mocker.ignoreMock(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.getText);
    });
    it('should_calculate_correct_offset_when_progress_capsule_has_holes_on_both_sides', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogHelperShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let mockIsShowHoleLeft: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      when(mockIsShowHoleLeft)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockIsShowHoleRight: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      when(mockIsShowHoleRight)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      livecapsulelistsingleholelayoutvm.showCapsuleList = [
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()
      ];
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS] =
        new NotificationArray<LiveNotification>();
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());

      livecapsulelistsingleholelayoutvm.leftMinFreeSpace = 10;
      livecapsulelistsingleholelayoutvm.leftWithoutTimeTotalFreeSpace = 20;
      livecapsulelistsingleholelayoutvm.leftTotalFreeSpace = 30;
      livecapsulelistsingleholelayoutvm.rightTotalFreeSpace = 40;
      livecapsulelistsingleholelayoutvm.avoidStart = 5;
      livecapsulelistsingleholelayoutvm.avoidEnd = 6;

      let result = livecapsulelistsingleholelayoutvm.updateProgressCapsuleFixedOffset();

      expect(result).assertEqual(0);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_calculate_correct_offset_when_progress_capsule_has_holes_on_left_side_only', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogHelperShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let mockIsShowHoleLeft: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      when(mockIsShowHoleLeft)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockIsShowHoleRight: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      when(mockIsShowHoleRight)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(false);

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);
      livecapsulelistsingleholelayoutvm.showCapsuleList = [
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()
      ];
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS] =
        new NotificationArray<LiveNotification>();
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.leftMinFreeSpace = 10;
      livecapsulelistsingleholelayoutvm.leftWithoutTimeTotalFreeSpace = 20;
      livecapsulelistsingleholelayoutvm.leftTotalFreeSpace = 30;
      livecapsulelistsingleholelayoutvm.rightTotalFreeSpace = 40;
      livecapsulelistsingleholelayoutvm.avoidStart = 5;
      livecapsulelistsingleholelayoutvm.avoidEnd = 6;

      let result = livecapsulelistsingleholelayoutvm.updateProgressCapsuleFixedOffset();

      expect(result).assertEqual(0);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_update_fixed_offset_when_capsule_is_show', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let liveCapsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      liveCapsuleList.add(new LiveNotification());

      let result = livecapsulelistsingleholelayoutvm.updateFixedOffsetByOffset(100, liveCapsuleList,
        CapsuleType.VIDEO_TIME_capsuleType);

      expect(result).assertEqual(95);

      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
    });

    it('should_not_update_fixed_offset_when_capsule_is_not_show', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: false,
        fixedWidth: 100,
        fixedOffsetX: 0
      };

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let liveCapsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      liveCapsuleList.add(new LiveNotification());

      let result = livecapsulelistsingleholelayoutvm.updateFixedOffsetByOffset(100, liveCapsuleList,
        CapsuleType.VIDEO_TIME_capsuleType);

      expect(result).assertEqual(100);

      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
    });

    it('should_update_fixed_offset_when_liveCapsuleList_is_empty', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let liveCapsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();

      let result = livecapsulelistsingleholelayoutvm.updateFixedOffsetByOffset(100, liveCapsuleList,
        CapsuleType.VIDEO_TIME_capsuleType);

      expect(result).assertEqual(100);

      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
    });
    it('should_calculate_correct_offset_when_progress_capsule_has_holes_on_left_side_only', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogHelperShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let mockIsShowHoleLeft: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      when(mockIsShowHoleLeft)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockIsShowHoleRight: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      when(mockIsShowHoleRight)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(false);

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      livecapsulelistsingleholelayoutvm.showCapsuleList = [
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()
      ];
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS] =
        new NotificationArray<LiveNotification>();
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());

      livecapsulelistsingleholelayoutvm.leftMinFreeSpace = 10;
      livecapsulelistsingleholelayoutvm.leftWithoutTimeTotalFreeSpace = 20;
      livecapsulelistsingleholelayoutvm.leftTotalFreeSpace = 30;
      livecapsulelistsingleholelayoutvm.rightTotalFreeSpace = 40;
      livecapsulelistsingleholelayoutvm.avoidStart = 5;
      livecapsulelistsingleholelayoutvm.avoidEnd = 6;

      let result = livecapsulelistsingleholelayoutvm.updateProgressCapsuleFixedOffset();

      expect(result).assertEqual(0);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_calculate_correct_offset_when_progress_capsule_has_holes_on_both_sides', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm = new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogHelperShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetCapsuleGap: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let mockIsShowHoleLeft: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      when(mockIsShowHoleLeft)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockIsShowHoleRight: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      when(mockIsShowHoleRight)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector, livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      livecapsulelistsingleholelayoutvm.showCapsuleList = [
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()
      ];
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS] = new NotificationArray<LiveNotification>();
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.leftMinFreeSpace = 10;
      livecapsulelistsingleholelayoutvm.leftWithoutTimeTotalFreeSpace = 20;
      livecapsulelistsingleholelayoutvm.leftTotalFreeSpace = 30;
      livecapsulelistsingleholelayoutvm.rightTotalFreeSpace = 40;
      livecapsulelistsingleholelayoutvm.avoidStart = 5;
      livecapsulelistsingleholelayoutvm.avoidEnd = 6;
      let result = livecapsulelistsingleholelayoutvm.updateProgressCapsuleFixedOffset();
      expect(result).assertEqual(0);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector, livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_execute_all_steps_when_liveList_is_valid', 0, () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.checkParam);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);
      let mockfunc2: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.initParam);
      when(mockfunc2)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturnNothing();
      let mockfunc3: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.filterShowCapsuleList);
      when(mockfunc3)(ArgumentMatchers.any).afterReturnNothing();
      let mockfunc4: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.moveScreen2ProgressCapsule);
      when(mockfunc4)().afterReturnNothing();
      let mockfunc5: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.updateFixedWidth);
      when(mockfunc5)().afterReturnNothing();
      let mockfunc6: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.updateFixedOffset);
      when(mockfunc6)().afterReturnNothing();
      let mockfunc7: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.modifyFixedWidthAndFixedOffsetByShowType);
      when(mockfunc7)().afterReturnNothing();
      let mockfunc8: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.printFixedWithAndeOffset);
      when(mockfunc8)(ArgumentMatchers.any).afterReturnNothing();
      livecapsulelistsingleholelayoutvm.computeCapsuleFixedWithAndOffset([new LiveNotification()], true);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.checkParam);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.initParam);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.filterShowCapsuleList);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.moveScreen2ProgressCapsule);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.updateFixedWidth);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.updateFixedOffset);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.modifyFixedWidthAndFixedOffsetByShowType);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.printFixedWithAndeOffset);
    });
    it('should_set_capsule_width_correctly_when_live_is_flip_and_increasesUsedSpace_is_greater_than_zero', 0,
      async () => {
        let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
          new LiveCapsuleListSingleHoleLayoutVm();
        let mocker: MockKit = new MockKit();

        let mockGetCapsuleVm: Function =
          mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleVm);
        let mockGetCapsuleMarqueeVm: Function =
          mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleMarqueeVm);
        let mockGetCapsuleGap: Function =
          mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
        let mockAdjustFixedWidthForHangingWithExtend: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm,
          livecapsulelistsingleholelayoutvm.adjustFixedWidthForHangingWithExtend);
        let mockGetTextWidthBySize: Function =
          mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getTextWidthBySize);
        let mockGetCapsuleMarqueeWithoutTextWidth: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm,
          livecapsulelistsingleholelayoutvm.getCapsuleMarqueeWithoutTextWidth);
        let mockIsFlip: Function = mocker.mockFunc(LiveNotification.prototype, LiveNotification.prototype.isFlip);
        let mockGetText: Function =
          mocker.mockFunc(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.getText);

        let live: LiveNotification = new LiveNotification();
        let capsuleVm: ILiveCapsuleVm = new ILiveCapsuleVm();
        let capsuleMarqueeVm: ILiveCapsuleListLayoutVm = new ILiveCapsuleListLayoutVm();

        when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);
        when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn(capsuleMarqueeVm);
        when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(4);
        when(mockAdjustFixedWidthForHangingWithExtend)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any,
          ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(10);
        when(mockGetTextWidthBySize)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(20);
        when(mockGetCapsuleMarqueeWithoutTextWidth)(ArgumentMatchers.any).afterReturn(10);
        when(mockIsFlip)().afterReturn(true);
        when(mockGetText)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn("test");

        livecapsulelistsingleholelayoutvm.setRemindCapsuleWidth(live, false);

        expect(capsuleVm.fixedWidth).assertEqual(34);
        expect(capsuleMarqueeVm.fixedTextWidth).assertEqual(16);

        mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleVm);
        mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleMarqueeVm);
        mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
        mocker.ignoreMock(livecapsulelistsingleholelayoutvm,
          livecapsulelistsingleholelayoutvm.adjustFixedWidthForHangingWithExtend);
        mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getTextWidthBySize);
        mocker.ignoreMock(livecapsulelistsingleholelayoutvm,
          livecapsulelistsingleholelayoutvm.getCapsuleMarqueeWithoutTextWidth);
        mocker.ignoreMock(LiveNotification.prototype, LiveNotification.prototype.isFlip);
        mocker.ignoreMock(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.getText);
      });

    it('should_set_capsule_width_correctly_when_live_is_not_flip_and_width_is_less_than_max_width', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleMarqueeVm);
      let mockGetCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      let mockGetTextWidthBySize: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getTextWidthBySize);
      let mockGetCapsuleMarqueeWithoutTextWidth: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.getCapsuleMarqueeWithoutTextWidth);
      let mockIsFlip: Function = mocker.mockFunc(LiveNotification.prototype, LiveNotification.prototype.isFlip);
      let mockGetText: Function =
        mocker.mockFunc(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.getText);

      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new ILiveCapsuleVm();
      let capsuleMarqueeVm: ILiveCapsuleListLayoutVm = new ILiveCapsuleListLayoutVm();

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn(capsuleMarqueeVm);
      when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(4);
      when(mockGetTextWidthBySize)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(20);
      when(mockGetCapsuleMarqueeWithoutTextWidth)(ArgumentMatchers.any).afterReturn(10);
      when(mockIsFlip)().afterReturn(false);
      when(mockGetText)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn("test");

      livecapsulelistsingleholelayoutvm.setRemindCapsuleWidth(live, false);

      expect(capsuleVm.fixedWidth).assertEqual(34);
      expect(capsuleMarqueeVm.fixedTextWidth).assertEqual(16);

      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleMarqueeVm);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getTextWidthBySize);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.getCapsuleMarqueeWithoutTextWidth);
      mocker.ignoreMock(LiveNotification.prototype, LiveNotification.prototype.isFlip);
      mocker.ignoreMock(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.getText);
    });
    it('should_calculate_correct_offset_when_progress_capsule_has_holes_on_both_sides', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogHelperShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let mockIsShowHoleLeft: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      when(mockIsShowHoleLeft)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockIsShowHoleRight: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      when(mockIsShowHoleRight)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      livecapsulelistsingleholelayoutvm.showCapsuleList = [
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()
      ];
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS] =
        new NotificationArray<LiveNotification>();
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());

      livecapsulelistsingleholelayoutvm.leftMinFreeSpace = 10;
      livecapsulelistsingleholelayoutvm.leftWithoutTimeTotalFreeSpace = 20;
      livecapsulelistsingleholelayoutvm.leftTotalFreeSpace = 30;
      livecapsulelistsingleholelayoutvm.rightTotalFreeSpace = 40;
      livecapsulelistsingleholelayoutvm.avoidStart = 5;
      livecapsulelistsingleholelayoutvm.avoidEnd = 6;

      let result = livecapsulelistsingleholelayoutvm.updateProgressCapsuleFixedOffset();

      expect(result).assertEqual(0);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_calculate_correct_offset_when_progress_capsule_has_holes_on_left_side_only', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogHelperShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let mockIsShowHoleLeft: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      when(mockIsShowHoleLeft)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockIsShowHoleRight: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      when(mockIsShowHoleRight)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(false);

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);
      livecapsulelistsingleholelayoutvm.showCapsuleList = [
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()
      ];
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS] =
        new NotificationArray<LiveNotification>();
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.leftMinFreeSpace = 10;
      livecapsulelistsingleholelayoutvm.leftWithoutTimeTotalFreeSpace = 20;
      livecapsulelistsingleholelayoutvm.leftTotalFreeSpace = 30;
      livecapsulelistsingleholelayoutvm.rightTotalFreeSpace = 40;
      livecapsulelistsingleholelayoutvm.avoidStart = 5;
      livecapsulelistsingleholelayoutvm.avoidEnd = 6;

      let result = livecapsulelistsingleholelayoutvm.updateProgressCapsuleFixedOffset();

      expect(result).assertEqual(0);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_update_fixed_offset_when_capsule_is_show', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let liveCapsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      liveCapsuleList.add(new LiveNotification());

      let result = livecapsulelistsingleholelayoutvm.updateFixedOffsetByOffset(100, liveCapsuleList,
        CapsuleType.VIDEO_TIME_capsuleType);

      expect(result).assertEqual(95);

      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
    });

    it('should_not_update_fixed_offset_when_capsule_is_not_show', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: false,
        fixedWidth: 100,
        fixedOffsetX: 0
      };

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let liveCapsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      liveCapsuleList.add(new LiveNotification());

      let result = livecapsulelistsingleholelayoutvm.updateFixedOffsetByOffset(100, liveCapsuleList,
        CapsuleType.VIDEO_TIME_capsuleType);

      expect(result).assertEqual(100);

      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
    });

    it('should_update_fixed_offset_when_liveCapsuleList_is_empty', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let liveCapsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();

      let result = livecapsulelistsingleholelayoutvm.updateFixedOffsetByOffset(100, liveCapsuleList,
        CapsuleType.VIDEO_TIME_capsuleType);

      expect(result).assertEqual(100);

      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
    });
    it('should_calculate_correct_offset_when_progress_capsule_has_holes_on_left_side_only', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogHelperShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let mockIsShowHoleLeft: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      when(mockIsShowHoleLeft)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockIsShowHoleRight: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      when(mockIsShowHoleRight)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(false);

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      livecapsulelistsingleholelayoutvm.showCapsuleList = [
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()
      ];
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS] =
        new NotificationArray<LiveNotification>();
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());

      livecapsulelistsingleholelayoutvm.leftMinFreeSpace = 10;
      livecapsulelistsingleholelayoutvm.leftWithoutTimeTotalFreeSpace = 20;
      livecapsulelistsingleholelayoutvm.leftTotalFreeSpace = 30;
      livecapsulelistsingleholelayoutvm.rightTotalFreeSpace = 40;
      livecapsulelistsingleholelayoutvm.avoidStart = 5;
      livecapsulelistsingleholelayoutvm.avoidEnd = 6;

      let result = livecapsulelistsingleholelayoutvm.updateProgressCapsuleFixedOffset();

      expect(result).assertEqual(0);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_calculate_correct_offset_when_progress_capsule_has_holes_on_both_sides', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm = new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogHelperShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetCapsuleGap: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let mockIsShowHoleLeft: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      when(mockIsShowHoleLeft)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockIsShowHoleRight: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      when(mockIsShowHoleRight)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector, livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      livecapsulelistsingleholelayoutvm.showCapsuleList = [
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()
      ];
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS] = new NotificationArray<LiveNotification>();
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.leftMinFreeSpace = 10;
      livecapsulelistsingleholelayoutvm.leftWithoutTimeTotalFreeSpace = 20;
      livecapsulelistsingleholelayoutvm.leftTotalFreeSpace = 30;
      livecapsulelistsingleholelayoutvm.rightTotalFreeSpace = 40;
      livecapsulelistsingleholelayoutvm.avoidStart = 5;
      livecapsulelistsingleholelayoutvm.avoidEnd = 6;
      let result = livecapsulelistsingleholelayoutvm.updateProgressCapsuleFixedOffset();
      expect(result).assertEqual(0);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector, livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
    });



    
    it('should_execute_all_steps_when_liveList_is_valid', 0, () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.checkParam);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);
      let mockfunc2: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.initParam);
      when(mockfunc2)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturnNothing();
      let mockfunc3: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.filterShowCapsuleList);
      when(mockfunc3)(ArgumentMatchers.any).afterReturnNothing();
      let mockfunc4: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.moveScreen2ProgressCapsule);
      when(mockfunc4)().afterReturnNothing();
      let mockfunc5: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.updateFixedWidth);
      when(mockfunc5)().afterReturnNothing();
      let mockfunc6: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.updateFixedOffset);
      when(mockfunc6)().afterReturnNothing();
      let mockfunc7: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.modifyFixedWidthAndFixedOffsetByShowType);
      when(mockfunc7)().afterReturnNothing();
      let mockfunc8: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.printFixedWithAndeOffset);
      when(mockfunc8)(ArgumentMatchers.any).afterReturnNothing();
      livecapsulelistsingleholelayoutvm.computeCapsuleFixedWithAndOffset([new LiveNotification()], true);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.checkParam);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.initParam);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.filterShowCapsuleList);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.moveScreen2ProgressCapsule);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.updateFixedWidth);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.updateFixedOffset);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.modifyFixedWidthAndFixedOffsetByShowType);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.printFixedWithAndeOffset);
    });
    it('should_set_capsule_width_correctly_when_live_is_flip_and_increasesUsedSpace_is_greater_than_zero', 0,
      async () => {
        let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
          new LiveCapsuleListSingleHoleLayoutVm();
        let mocker: MockKit = new MockKit();

        let mockGetCapsuleVm: Function =
          mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleVm);
        let mockGetCapsuleMarqueeVm: Function =
          mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleMarqueeVm);
        let mockGetCapsuleGap: Function =
          mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
        let mockAdjustFixedWidthForHangingWithExtend: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm,
          livecapsulelistsingleholelayoutvm.adjustFixedWidthForHangingWithExtend);
        let mockGetTextWidthBySize: Function =
          mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getTextWidthBySize);
        let mockGetCapsuleMarqueeWithoutTextWidth: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm,
          livecapsulelistsingleholelayoutvm.getCapsuleMarqueeWithoutTextWidth);
        let mockIsFlip: Function = mocker.mockFunc(LiveNotification.prototype, LiveNotification.prototype.isFlip);
        let mockGetText: Function =
          mocker.mockFunc(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.getText);

        let live: LiveNotification = new LiveNotification();
        let capsuleVm: ILiveCapsuleVm = new ILiveCapsuleVm();
        let capsuleMarqueeVm: ILiveCapsuleListLayoutVm = new ILiveCapsuleListLayoutVm();

        when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);
        when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn(capsuleMarqueeVm);
        when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(4);
        when(mockAdjustFixedWidthForHangingWithExtend)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any,
          ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(10);
        when(mockGetTextWidthBySize)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(20);
        when(mockGetCapsuleMarqueeWithoutTextWidth)(ArgumentMatchers.any).afterReturn(10);
        when(mockIsFlip)().afterReturn(true);
        when(mockGetText)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn("test");

        livecapsulelistsingleholelayoutvm.setRemindCapsuleWidth(live, false);

        expect(capsuleVm.fixedWidth).assertEqual(34);
        expect(capsuleMarqueeVm.fixedTextWidth).assertEqual(16);

        mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleVm);
        mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleMarqueeVm);
        mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
        mocker.ignoreMock(livecapsulelistsingleholelayoutvm,
          livecapsulelistsingleholelayoutvm.adjustFixedWidthForHangingWithExtend);
        mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getTextWidthBySize);
        mocker.ignoreMock(livecapsulelistsingleholelayoutvm,
          livecapsulelistsingleholelayoutvm.getCapsuleMarqueeWithoutTextWidth);
        mocker.ignoreMock(LiveNotification.prototype, LiveNotification.prototype.isFlip);
        mocker.ignoreMock(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.getText);
      });

    it('should_set_capsule_width_correctly_when_live_is_not_flip_and_width_is_less_than_max_width', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleMarqueeVm);
      let mockGetCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      let mockGetTextWidthBySize: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getTextWidthBySize);
      let mockGetCapsuleMarqueeWithoutTextWidth: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.getCapsuleMarqueeWithoutTextWidth);
      let mockIsFlip: Function = mocker.mockFunc(LiveNotification.prototype, LiveNotification.prototype.isFlip);
      let mockGetText: Function =
        mocker.mockFunc(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.getText);

      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new ILiveCapsuleVm();
      let capsuleMarqueeVm: ILiveCapsuleListLayoutVm = new ILiveCapsuleListLayoutVm();

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn(capsuleMarqueeVm);
      when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(4);
      when(mockGetTextWidthBySize)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(20);
      when(mockGetCapsuleMarqueeWithoutTextWidth)(ArgumentMatchers.any).afterReturn(10);
      when(mockIsFlip)().afterReturn(false);
      when(mockGetText)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn("test");

      livecapsulelistsingleholelayoutvm.setRemindCapsuleWidth(live, false);

      expect(capsuleVm.fixedWidth).assertEqual(34);
      expect(capsuleMarqueeVm.fixedTextWidth).assertEqual(16);

      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleMarqueeVm);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getTextWidthBySize);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.getCapsuleMarqueeWithoutTextWidth);
      mocker.ignoreMock(LiveNotification.prototype, LiveNotification.prototype.isFlip);
      mocker.ignoreMock(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.getText);
    });
    it('should_calculate_correct_offset_when_progress_capsule_has_holes_on_both_sides', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogHelperShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let mockIsShowHoleLeft: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      when(mockIsShowHoleLeft)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockIsShowHoleRight: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      when(mockIsShowHoleRight)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      livecapsulelistsingleholelayoutvm.showCapsuleList = [
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()
      ];
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS] =
        new NotificationArray<LiveNotification>();
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());

      livecapsulelistsingleholelayoutvm.leftMinFreeSpace = 10;
      livecapsulelistsingleholelayoutvm.leftWithoutTimeTotalFreeSpace = 20;
      livecapsulelistsingleholelayoutvm.leftTotalFreeSpace = 30;
      livecapsulelistsingleholelayoutvm.rightTotalFreeSpace = 40;
      livecapsulelistsingleholelayoutvm.avoidStart = 5;
      livecapsulelistsingleholelayoutvm.avoidEnd = 6;

      let result = livecapsulelistsingleholelayoutvm.updateProgressCapsuleFixedOffset();

      expect(result).assertEqual(0);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_calculate_correct_offset_when_progress_capsule_has_holes_on_left_side_only', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogHelperShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let mockIsShowHoleLeft: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      when(mockIsShowHoleLeft)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockIsShowHoleRight: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      when(mockIsShowHoleRight)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(false);

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);
      livecapsulelistsingleholelayoutvm.showCapsuleList = [
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()
      ];
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS] =
        new NotificationArray<LiveNotification>();
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.leftMinFreeSpace = 10;
      livecapsulelistsingleholelayoutvm.leftWithoutTimeTotalFreeSpace = 20;
      livecapsulelistsingleholelayoutvm.leftTotalFreeSpace = 30;
      livecapsulelistsingleholelayoutvm.rightTotalFreeSpace = 40;
      livecapsulelistsingleholelayoutvm.avoidStart = 5;
      livecapsulelistsingleholelayoutvm.avoidEnd = 6;

      let result = livecapsulelistsingleholelayoutvm.updateProgressCapsuleFixedOffset();

      expect(result).assertEqual(0);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_update_fixed_offset_when_capsule_is_show', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let liveCapsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      liveCapsuleList.add(new LiveNotification());

      let result = livecapsulelistsingleholelayoutvm.updateFixedOffsetByOffset(100, liveCapsuleList,
        CapsuleType.VIDEO_TIME_capsuleType);

      expect(result).assertEqual(95);

      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
    });

    it('should_not_update_fixed_offset_when_capsule_is_not_show', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: false,
        fixedWidth: 100,
        fixedOffsetX: 0
      };

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let liveCapsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      liveCapsuleList.add(new LiveNotification());

      let result = livecapsulelistsingleholelayoutvm.updateFixedOffsetByOffset(100, liveCapsuleList,
        CapsuleType.VIDEO_TIME_capsuleType);

      expect(result).assertEqual(100);

      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
    });

    it('should_update_fixed_offset_when_liveCapsuleList_is_empty', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let liveCapsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();

      let result = livecapsulelistsingleholelayoutvm.updateFixedOffsetByOffset(100, liveCapsuleList,
        CapsuleType.VIDEO_TIME_capsuleType);

      expect(result).assertEqual(100);

      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
    });
    it('should_calculate_correct_offset_when_progress_capsule_has_holes_on_left_side_only', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogHelperShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let mockIsShowHoleLeft: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      when(mockIsShowHoleLeft)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockIsShowHoleRight: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      when(mockIsShowHoleRight)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(false);

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      livecapsulelistsingleholelayoutvm.showCapsuleList = [
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()
      ];
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS] =
        new NotificationArray<LiveNotification>();
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());

      livecapsulelistsingleholelayoutvm.leftMinFreeSpace = 10;
      livecapsulelistsingleholelayoutvm.leftWithoutTimeTotalFreeSpace = 20;
      livecapsulelistsingleholelayoutvm.leftTotalFreeSpace = 30;
      livecapsulelistsingleholelayoutvm.rightTotalFreeSpace = 40;
      livecapsulelistsingleholelayoutvm.avoidStart = 5;
      livecapsulelistsingleholelayoutvm.avoidEnd = 6;

      let result = livecapsulelistsingleholelayoutvm.updateProgressCapsuleFixedOffset();

      expect(result).assertEqual(0);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_calculate_correct_offset_when_progress_capsule_has_holes_on_both_sides', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm = new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogHelperShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetCapsuleGap: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let mockIsShowHoleLeft: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      when(mockIsShowHoleLeft)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockIsShowHoleRight: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      when(mockIsShowHoleRight)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector, livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      livecapsulelistsingleholelayoutvm.showCapsuleList = [
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()
      ];
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS] = new NotificationArray<LiveNotification>();
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.leftMinFreeSpace = 10;
      livecapsulelistsingleholelayoutvm.leftWithoutTimeTotalFreeSpace = 20;
      livecapsulelistsingleholelayoutvm.leftTotalFreeSpace = 30;
      livecapsulelistsingleholelayoutvm.rightTotalFreeSpace = 40;
      livecapsulelistsingleholelayoutvm.avoidStart = 5;
      livecapsulelistsingleholelayoutvm.avoidEnd = 6;
      let result = livecapsulelistsingleholelayoutvm.updateProgressCapsuleFixedOffset();
      expect(result).assertEqual(0);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector, livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
    });
    
    it('should_execute_all_steps_when_liveList_is_valid', 0, () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.checkParam);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);
      let mockfunc2: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.initParam);
      when(mockfunc2)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturnNothing();
      let mockfunc3: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.filterShowCapsuleList);
      when(mockfunc3)(ArgumentMatchers.any).afterReturnNothing();
      let mockfunc4: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.moveScreen2ProgressCapsule);
      when(mockfunc4)().afterReturnNothing();
      let mockfunc5: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.updateFixedWidth);
      when(mockfunc5)().afterReturnNothing();
      let mockfunc6: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.updateFixedOffset);
      when(mockfunc6)().afterReturnNothing();
      let mockfunc7: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.modifyFixedWidthAndFixedOffsetByShowType);
      when(mockfunc7)().afterReturnNothing();
      let mockfunc8: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.printFixedWithAndeOffset);
      when(mockfunc8)(ArgumentMatchers.any).afterReturnNothing();
      livecapsulelistsingleholelayoutvm.computeCapsuleFixedWithAndOffset([new LiveNotification()], true);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.checkParam);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.initParam);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.filterShowCapsuleList);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.moveScreen2ProgressCapsule);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.updateFixedWidth);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.updateFixedOffset);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.modifyFixedWidthAndFixedOffsetByShowType);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.printFixedWithAndeOffset);
    });
    it('should_set_capsule_width_correctly_when_live_is_flip_and_increasesUsedSpace_is_greater_than_zero', 0,
      async () => {
        let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
          new LiveCapsuleListSingleHoleLayoutVm();
        let mocker: MockKit = new MockKit();

        let mockGetCapsuleVm: Function =
          mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleVm);
        let mockGetCapsuleMarqueeVm: Function =
          mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleMarqueeVm);
        let mockGetCapsuleGap: Function =
          mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
        let mockAdjustFixedWidthForHangingWithExtend: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm,
          livecapsulelistsingleholelayoutvm.adjustFixedWidthForHangingWithExtend);
        let mockGetTextWidthBySize: Function =
          mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getTextWidthBySize);
        let mockGetCapsuleMarqueeWithoutTextWidth: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm,
          livecapsulelistsingleholelayoutvm.getCapsuleMarqueeWithoutTextWidth);
        let mockIsFlip: Function = mocker.mockFunc(LiveNotification.prototype, LiveNotification.prototype.isFlip);
        let mockGetText: Function =
          mocker.mockFunc(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.getText);

        let live: LiveNotification = new LiveNotification();
        let capsuleVm: ILiveCapsuleVm = new ILiveCapsuleVm();
        let capsuleMarqueeVm: ILiveCapsuleListLayoutVm = new ILiveCapsuleListLayoutVm();

        when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);
        when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn(capsuleMarqueeVm);
        when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(4);
        when(mockAdjustFixedWidthForHangingWithExtend)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any,
          ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(10);
        when(mockGetTextWidthBySize)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(20);
        when(mockGetCapsuleMarqueeWithoutTextWidth)(ArgumentMatchers.any).afterReturn(10);
        when(mockIsFlip)().afterReturn(true);
        when(mockGetText)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn("test");

        livecapsulelistsingleholelayoutvm.setRemindCapsuleWidth(live, false);

        expect(capsuleVm.fixedWidth).assertEqual(34);
        expect(capsuleMarqueeVm.fixedTextWidth).assertEqual(16);

        mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleVm);
        mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleMarqueeVm);
        mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
        mocker.ignoreMock(livecapsulelistsingleholelayoutvm,
          livecapsulelistsingleholelayoutvm.adjustFixedWidthForHangingWithExtend);
        mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getTextWidthBySize);
        mocker.ignoreMock(livecapsulelistsingleholelayoutvm,
          livecapsulelistsingleholelayoutvm.getCapsuleMarqueeWithoutTextWidth);
        mocker.ignoreMock(LiveNotification.prototype, LiveNotification.prototype.isFlip);
        mocker.ignoreMock(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.getText);
      });

    it('should_set_capsule_width_correctly_when_live_is_not_flip_and_width_is_less_than_max_width', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleVm);
      let mockGetCapsuleMarqueeVm: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleMarqueeVm);
      let mockGetCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      let mockGetTextWidthBySize: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getTextWidthBySize);
      let mockGetCapsuleMarqueeWithoutTextWidth: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.getCapsuleMarqueeWithoutTextWidth);
      let mockIsFlip: Function = mocker.mockFunc(LiveNotification.prototype, LiveNotification.prototype.isFlip);
      let mockGetText: Function =
        mocker.mockFunc(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.getText);

      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new ILiveCapsuleVm();
      let capsuleMarqueeVm: ILiveCapsuleListLayoutVm = new ILiveCapsuleListLayoutVm();

      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);
      when(mockGetCapsuleMarqueeVm)(ArgumentMatchers.any).afterReturn(capsuleMarqueeVm);
      when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(4);
      when(mockGetTextWidthBySize)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(20);
      when(mockGetCapsuleMarqueeWithoutTextWidth)(ArgumentMatchers.any).afterReturn(10);
      when(mockIsFlip)().afterReturn(false);
      when(mockGetText)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn("test");

      livecapsulelistsingleholelayoutvm.setRemindCapsuleWidth(live, false);

      expect(capsuleVm.fixedWidth).assertEqual(34);
      expect(capsuleMarqueeVm.fixedTextWidth).assertEqual(16);

      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleMarqueeVm);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getTextWidthBySize);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm,
        livecapsulelistsingleholelayoutvm.getCapsuleMarqueeWithoutTextWidth);
      mocker.ignoreMock(LiveNotification.prototype, LiveNotification.prototype.isFlip);
      mocker.ignoreMock(LiveCapsuleListLayoutBaseVm.prototype, LiveCapsuleListLayoutBaseVm.prototype.getText);
    });
    it('should_calculate_correct_offset_when_progress_capsule_has_holes_on_both_sides', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogHelperShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let mockIsShowHoleLeft: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      when(mockIsShowHoleLeft)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockIsShowHoleRight: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      when(mockIsShowHoleRight)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      livecapsulelistsingleholelayoutvm.showCapsuleList = [
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()
      ];
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS] =
        new NotificationArray<LiveNotification>();
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());

      livecapsulelistsingleholelayoutvm.leftMinFreeSpace = 10;
      livecapsulelistsingleholelayoutvm.leftWithoutTimeTotalFreeSpace = 20;
      livecapsulelistsingleholelayoutvm.leftTotalFreeSpace = 30;
      livecapsulelistsingleholelayoutvm.rightTotalFreeSpace = 40;
      livecapsulelistsingleholelayoutvm.avoidStart = 5;
      livecapsulelistsingleholelayoutvm.avoidEnd = 6;

      let result = livecapsulelistsingleholelayoutvm.updateProgressCapsuleFixedOffset();

      expect(result).assertEqual(0);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_calculate_correct_offset_when_progress_capsule_has_holes_on_left_side_only', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogHelperShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let mockIsShowHoleLeft: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      when(mockIsShowHoleLeft)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockIsShowHoleRight: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      when(mockIsShowHoleRight)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(false);

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);
      livecapsulelistsingleholelayoutvm.showCapsuleList = [
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()
      ];
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS] =
        new NotificationArray<LiveNotification>();
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.leftMinFreeSpace = 10;
      livecapsulelistsingleholelayoutvm.leftWithoutTimeTotalFreeSpace = 20;
      livecapsulelistsingleholelayoutvm.leftTotalFreeSpace = 30;
      livecapsulelistsingleholelayoutvm.rightTotalFreeSpace = 40;
      livecapsulelistsingleholelayoutvm.avoidStart = 5;
      livecapsulelistsingleholelayoutvm.avoidEnd = 6;

      let result = livecapsulelistsingleholelayoutvm.updateProgressCapsuleFixedOffset();

      expect(result).assertEqual(0);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_update_fixed_offset_when_capsule_is_show', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let liveCapsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      liveCapsuleList.add(new LiveNotification());

      let result = livecapsulelistsingleholelayoutvm.updateFixedOffsetByOffset(100, liveCapsuleList,
        CapsuleType.VIDEO_TIME_capsuleType);

      expect(result).assertEqual(95);

      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
    });

    it('should_not_update_fixed_offset_when_capsule_is_not_show', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: false,
        fixedWidth: 100,
        fixedOffsetX: 0
      };

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let liveCapsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
      liveCapsuleList.add(new LiveNotification());

      let result = livecapsulelistsingleholelayoutvm.updateFixedOffsetByOffset(100, liveCapsuleList,
        CapsuleType.VIDEO_TIME_capsuleType);

      expect(result).assertEqual(100);

      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
    });

    it('should_update_fixed_offset_when_liveCapsuleList_is_empty', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let liveCapsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();

      let result = livecapsulelistsingleholelayoutvm.updateFixedOffsetByOffset(100, liveCapsuleList,
        CapsuleType.VIDEO_TIME_capsuleType);

      expect(result).assertEqual(100);

      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
    });
    it('should_calculate_correct_offset_when_progress_capsule_has_holes_on_left_side_only', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm =
        new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogHelperShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetCapsuleGap: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let mockIsShowHoleLeft: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      when(mockIsShowHoleLeft)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockIsShowHoleRight: Function =
        mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      when(mockIsShowHoleRight)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(false);

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      livecapsulelistsingleholelayoutvm.showCapsuleList = [
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()
      ];
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS] =
        new NotificationArray<LiveNotification>();
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());

      livecapsulelistsingleholelayoutvm.leftMinFreeSpace = 10;
      livecapsulelistsingleholelayoutvm.leftWithoutTimeTotalFreeSpace = 20;
      livecapsulelistsingleholelayoutvm.leftTotalFreeSpace = 30;
      livecapsulelistsingleholelayoutvm.rightTotalFreeSpace = 40;
      livecapsulelistsingleholelayoutvm.avoidStart = 5;
      livecapsulelistsingleholelayoutvm.avoidEnd = 6;

      let result = livecapsulelistsingleholelayoutvm.updateProgressCapsuleFixedOffset();

      expect(result).assertEqual(0);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector,
        livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
    });

    it('should_calculate_correct_offset_when_progress_capsule_has_holes_on_both_sides', 0, async () => {
      let livecapsulelistsingleholelayoutvm: LiveCapsuleListSingleHoleLayoutVm = new LiveCapsuleListSingleHoleLayoutVm();
      let mocker: MockKit = new MockKit();

      let mockLogHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockLogHelperShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockGetCapsuleGap: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      when(mockGetCapsuleGap)(ArgumentMatchers.any).afterReturn(5);

      let mockIsShowHoleLeft: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      when(mockIsShowHoleLeft)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockIsShowHoleRight: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      when(mockIsShowHoleRight)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistsingleholelayoutvm.vmInjector, livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isShow: true,
        fixedWidth: 100,
        fixedOffsetX: 0
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      livecapsulelistsingleholelayoutvm.showCapsuleList = [
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()
      ];
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS] = new NotificationArray<LiveNotification>();
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.showCapsuleList[CapsuleType.PROGRESS].push(new LiveNotification());
      livecapsulelistsingleholelayoutvm.leftMinFreeSpace = 10;
      livecapsulelistsingleholelayoutvm.leftWithoutTimeTotalFreeSpace = 20;
      livecapsulelistsingleholelayoutvm.leftTotalFreeSpace = 30;
      livecapsulelistsingleholelayoutvm.rightTotalFreeSpace = 40;
      livecapsulelistsingleholelayoutvm.avoidStart = 5;
      livecapsulelistsingleholelayoutvm.avoidEnd = 6;
      let result = livecapsulelistsingleholelayoutvm.updateProgressCapsuleFixedOffset();
      expect(result).assertEqual(0);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.getCapsuleGap);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleLeft);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm, livecapsulelistsingleholelayoutvm.isShowHoleRight);
      mocker.ignoreMock(livecapsulelistsingleholelayoutvm.vmInjector, livecapsulelistsingleholelayoutvm.vmInjector.getCapsuleVm);
    });

  });
}