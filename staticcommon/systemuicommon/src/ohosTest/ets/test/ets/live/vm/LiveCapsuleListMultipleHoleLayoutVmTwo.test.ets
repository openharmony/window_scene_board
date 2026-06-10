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
import { DEFAULT, describe, expect, it } from '@ohos/hypium';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';
import {
  LiveCapsuleListMultipleHoleLayoutVm
} from '../../../../../../main/ets/live/vm/LiveCapsuleListMultipleHoleLayoutVm';
import { CapsuleType, LiveType, SysTypeCode } from '../../../../../../main/ets/liveview/common/LiveConstants';
import { NotificationArray } from '../../../../../../main/ets/model/NotificationBase';

describe('LiveCapsuleListMultipleHoleLayoutVmTwo', () => {
  const mockVmInjector = {
    getCapsuleListVm: () => ({ liveList: [] }),
    getCapsuleVm: (live: LiveNotification) => ({ fixedShowType: CapsuleShowType.NONE, fixedOffsetX: 0, fixedWidth: 0, isShowed: false }),
    get: () => ({ liveList: [] })
  };

  const mockLiveNotification = (type: LiveType, typeCode: SysTypeCode, hashCode: number) => ({
    type,
    typeCode,
    hashCode,
    fixedShowType: CapsuleShowType.NONE,
    fixedOffsetX: 0,
    fixedWidth: 0,
    isShowed: false
  });

  const mockCapsuleVm = (fixedShowType: CapsuleShowType, fixedOffsetX: number, fixedWidth: number, isShowed: boolean) => ({
    fixedShowType,
    fixedOffsetX,
    fixedWidth,
    isShowed,
    isVisible: true,
    isShow: true
  });

  const createTestSubject = (vmInjector = mockVmInjector) => new LiveCapsuleListMultipleHoleLayoutVm(vmInjector);

  const generateTestData = (capsuleType: CapsuleType, liveList: LiveNotification[]) => ({
    capsuleType,
    liveList,
    showCapsuleList: new NotificationArray<LiveNotification>()
  });

  it.each([
    [CapsuleType.PROGRESS, [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1), mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 2)]],
    [CapsuleType.SCREEN_RECORDING, [mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1), mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 2)]],
    [CapsuleType.PERSISTENT, [mockLiveNotification(LiveType.INSTANT, SysTypeCode.PERSISTENT, 1), mockLiveNotification(LiveType.INSTANT, SysTypeCode.PERSISTENT, 2)]]
  ])('should updateCapsuleWidthAndOffset correctly', async ({ capsuleType, liveList }) => {
    const testSubject = createTestSubject();
    const { showCapsuleList } = testSubject.updateCapsuleWidthAndOffset(liveList);
    expect(showCapsuleList.length).toBe(liveList.length);
  });

  const generateTestDataForComputeCapsuleShowFlagBySpace = () => ({
    capsuleShowList: [
      mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1),
      mockLiveNotification(LiveType.INSTANT, SysTypeCode.PERSISTENT, 2),
      mockLiveNotification(LiveType.INSTANT, SysTypeCode.PROGRESS, 3)
    ]
  });

  it('should compute capsule show flag by space correctly',DEFAULT, () => {
    const testSubject = createTestSubject();
    const spaceInfo = testSubject.computeCapsuleShowFlagBySpace(testSubject.capsuleShowList);
    expect(spaceInfo.leftTotalFreeSpace).toBe(100);
    expect(spaceInfo.leftUsedSpace).toBe(50);
    expect(spaceInfo.leftRemainSpace).toBe(50);
    expect(spaceInfo.rightTotalFreeSpace).toBe(100);
    expect(spaceInfo.rightUsedSpace).toBe(75);
    expect(spaceInfo.rightRemainSpace).toBe(25);
  });

  const generateTestDataForAdjustShowCapsuleWidth = () => ({
    capsuleShowList: [
      mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1),
      mockLiveNotification(LiveType.INSTANT, SysTypeCode.PERSISTENT, 2),
      mockLiveNotification(LiveType.INSTANT, SysTypeCode.PROGRESS, 3)
    ],
    spaceInfo: {
      leftTotalFreeSpace: 100,
      leftUsedSpace: 50,
      leftRemainSpace: 50,
      rightTotalFreeSpace: 100,
      rightUsedSpace: 75,
      rightRemainSpace: 25
    }
  });

  it('should adjust show capsule width correctly',DEFAULT, () => {
    const testSubject = createTestSubject();
    testSubject.adjustShowCapsuleWidth(generateTestDataForAdjustShowCapsuleWidth().spaceInfo,
      generateTestDataForAdjustShowCapsuleWidth().capsuleShowList, CapsuleType.SCREEN_RECORDING);
  });

  const generateTestDataForGenerateCapsuleShowListByPrioritySort = () => ({
    showCapsuleList: [
      new NotificationArray<LiveNotification>(),
      new NotificationArray<LiveNotification>(),
      new NotificationArray<LiveNotification>()
    ]
  });

  it('should generate capsule show list by priority sort correctly',DEFAULT, () => {
    const testSubject = createTestSubject();
    testSubject.generateCapsuleShowListByPrioritySort(testSubject.showCapsuleList);
    // Add assertions here to check the order and content of the showCapsuleList
  });

  const generateTestDataForUpdateFixedWidth = () => ({
    capsuleShowList: [
      new NotificationArray<LiveNotification>(),
      new NotificationArray<LiveNotification>()
    ]
  });

  it('should update fixed width correctly',DEFAULT, () => {
    const testSubject = createTestSubject();
    testSubject.updateFixedWidth();
    // Add assertions here to check the fixed width of each capsule
  });

  const generateTestDataForUpdateFixedOffset = () => ({
    capsuleShowList: [
      new NotificationArray<LiveNotification>(),
      new NotificationArray<LiveNotification>()
    ]
  });

  it('should update fixed offset correctly',DEFAULT, () => {
    const testSubject = createTestSubject();
    testSubject.updateFixedOffset();
    // Add assertions here to check the fixed offset of each capsule
  });

  const generateTestDataForPrintFixedWithAndOffset = () => ({
    liveList: [
      mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1),
      mockLiveNotification(LiveType.INSTANT, SysTypeCode.PERSISTENT, 2),
      mockLiveNotification(LiveType.INSTANT, SysTypeCode.PROGRESS, 3)
    ]
  });

  it('should print fixed width and offset correctly',DEFAULT, () => {
    const testSubject = createTestSubject();
    testSubject.printFixedWithAndOffset(generateTestDataForPrintFixedWithAndOffset().liveList);
    // Add assertions here to check the output of the print method
  });

  const generateTestDataForSetRemindCapsuleWidth = () => ({
    live: mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1),
    isUpdateImmediately: true
  });

  it('should set remind capsule width correctly',DEFAULT, () => {
    const testSubject = createTestSubject();
    testSubject.setRemindCapsuleWidth(generateTestDataForSetRemindCapsuleWidth().live,
      generateTestDataForSetRemindCapsuleWidth().isUpdateImmediately);
  });

  const generateTestDataForIsShowHoleLeft = () => ({
    capsuleVm: mockCapsuleVm(CapsuleShowType.TOP)
  });

  it('should check if hole is shown on the left correctly',DEFAULT, () => {
    const testSubject = createTestSubject();
    const result = testSubject.isShowHoleLeft(generateTestDataForIsShowHoleLeft().capsuleVm);
    expect(result).toBe(true);
  });

  it('should_log_info_for_each_capsule_when_printCapsuleListVmFixedWidthAndOffset_is_called', 0, async () => {
    let mocker: MockKit = new MockKit();
    let logHelper: LogHelper = LogHelper.INSTANCE;
    let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    let liveCapsuleList: NotificationArray<LiveNotification> = new NotificationArray();
    let liveNotification1: LiveNotification = new LiveNotification();
    liveNotification1.type = LiveType.NOTIFICATION;
    liveNotification1.typeCode = SysTypeCode.NORMAL_GREEN;
    liveCapsuleList.add(liveNotification1);
    let liveNotification2: LiveNotification = new LiveNotification();
    liveNotification2.type = LiveType.NOTIFICATION;
    liveNotification2.typeCode = SysTypeCode.NORMAL_GREEN;
    liveCapsuleList.add(liveNotification2);

    let capsuleVm: ILiveCapsuleVm = {
      fixedWidth: 100,
      fixedOffsetX: 50,
      fixedShowType: CapsuleShowType.FIXED_SHOW,
      isShow: true
    };

    let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
    livecapsulelistmultipleholelayoutvm.printCapsuleListVmFixedWidthAndOffset(liveCapsuleList, CapsuleType.NOTIFICATION);

    mocker.ignoreMock(logHelper, logHelper.showInfo);
  });

  it('should_log_info_for_each_capsule_with_different_type_when_printCapsuleListVmFixedWidthAndOffset_is_called', 0, async () => {
    let mocker: MockKit = new MockKit();
    let logHelper: LogHelper = LogHelper.INSTANCE;
    let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    let liveCapsuleList: NotificationArray<LiveNotification> = new NotificationArray();
    let liveNotification1: LiveNotification = new LiveNotification();
    liveNotification1.type = LiveType.NOTIFICATION;
    liveNotification1.typeCode = SysTypeCode.NORMAL_GREEN;
    liveCapsuleList.add(liveNotification1);
    let liveNotification2: LiveNotification = new LiveNotification();
    liveNotification2.type = LiveType.NOTIFICATION;
    liveNotification2.typeCode = SysTypeCode.NOTIFICATION;
    liveCapsuleList.add(liveNotification2);

    let capsuleVm: ILiveCapsuleVm = {
      fixedWidth: 100,
      fixedOffsetX: 50,
      fixedShowType: CapsuleShowType.FIXED_SHOW,
      isShow: true
    };

    let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
    livecapsulelistmultipleholelayoutvm.printCapsuleListVmFixedWidthAndOffset(liveCapsuleList, CapsuleType.NOTIFICATION);

    mocker.ignoreMock(logHelper, logHelper.showInfo);
  });

  it('should_log_info_for_each_capsule_with_different_showType_when_printCapsuleListVmFixedWidthAndOffset_is_called', 0, async () => {
    let mocker: MockKit = new MockKit();
    let logHelper: LogHelper = LogHelper.INSTANCE;
    let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    let liveCapsuleList: NotificationArray<LiveNotification> = new NotificationArray();
    let liveNotification1: LiveNotification = new LiveNotification();
    liveNotification1.type = LiveType.NOTIFICATION;
    liveNotification1.typeCode = SysTypeCode.NORMAL_GREEN;
    liveCapsuleList.add(liveNotification1);
    let liveNotification2: LiveNotification = new LiveNotification();
    liveNotification2.type = LiveType.NOTIFICATION;
    liveNotification2.typeCode = SysTypeCode.NOTIFICATION;
    liveCapsuleList.add(liveNotification2);

    let capsuleVm: ILiveCapsuleVm = {
      fixedWidth: 100,
      fixedOffsetX: 50,
      fixedShowType: CapsuleShowType.OFFSET_SHOW,
      isShow: true
    };

    let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
    livecapsulelistmultipleholelayoutvm.printCapsuleListVmFixedWidthAndOffset(liveCapsuleList, CapsuleType.NOTIFICATION);

    mocker.ignoreMock(logHelper, logHelper.showInfo);
  });

  it('should_log_info_for_each_capsule_with_different_isShow_when_printCapsuleListVmFixedWidthAndOffset_is_called', 0, async () => {
    let mocker: MockKit = new MockKit();
    let logHelper: LogHelper = LogHelper.INSTANCE;
    let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    let liveCapsuleList: NotificationArray<LiveNotification> = new NotificationArray();
    let liveNotification1: LiveNotification = new LiveNotification();
    liveNotification1.type = LiveType.NOTIFICATION;
    liveNotification1.typeCode = SysTypeCode.NORMAL_GREEN;
    liveCapsuleList.add(liveNotification1);
    let liveNotification2: LiveNotification = new LiveNotification();
    liveNotification2.type = LiveType.NOTIFICATION;
    liveNotification2.typeCode = SysTypeCode.NOTIFICATION;
    liveCapsuleList.add(liveNotification2);

    let capsuleVm: ILiveCapsuleVm = {
      fixedWidth: 100,
      fixedOffsetX: 50,
      fixedShowType: CapsuleShowType.FIXED_SHOW,
      isShow: false
    };

    let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
    livecapsulelistmultipleholelayoutvm.printCapsuleListVmFixedWidthAndOffset(liveCapsuleList, CapsuleType.NOTIFICATION);

    mocker.ignoreMock(logHelper, logHelper.showInfo);
  });

  it('should_log_info_for_each_capsule_with_different_capsuleType_when_printCapsuleListVmFixedWidthAndOffset_is_called', 0, async () => {
    let mocker: MockKit = new MockKit();
    let logHelper: LogHelper = LogHelper.INSTANCE;
    let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

    let liveCapsuleList: NotificationArray<LiveNotification> = new NotificationArray();
    let liveNotification1: LiveNotification = new LiveNotification();
    liveNotification1.type = LiveType.NOTIFICATION;
    liveNotification1.typeCode = SysTypeCode.NORMAL_GREEN;
    liveCapsuleList.add(liveNotification1);
    let liveNotification2: LiveNotification = new LiveNotification();
    liveNotification2.type = LiveType.NOTIFICATION;
    liveNotification2.typeCode = SysTypeCode.NOTIFICATION;
    liveCapsuleList.add(liveNotification2);

    let capsuleVm: ILiveCapsuleVm = {
      fixedWidth: 100,
      fixedOffsetX: 50,
      fixedShowType: CapsuleShowType.FIXED_SHOW,
      isShow: true
    };

    let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
    livecapsulelistmultipleholelayoutvm.printCapsuleListVmFixedWidthAndOffset(liveCapsuleList, CapsuleType.WARNING);

    mocker.ignoreMock(logHelper, logHelper.showInfo);
  });

  it('should_log_info_for_each_liveCapsule_in_liveList', 0, async () => {
    let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
    let mocker: MockKit = new MockKit();
    let logHelper: LogHelper = LogHelper.INSTANCE;
    let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
    when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

    let liveCapsule1: LiveNotification = new LiveNotification();
    liveCapsule1.hashCode = 1;
    liveCapsule1.type = LiveType.NOTIFICATION;
    liveCapsule1.typeCode = SysTypeCode.NOTIFICATION;
    liveCapsule1.capsuleShowType = CapsuleShowType.NOTIFICATION;
    liveCapsule1.isShow = true;

    let liveCapsule2: LiveNotification = new LiveNotification();
    liveCapsule2.hashCode = 2;
    liveCapsule2.type = LiveType.NOTIFICATION;
    liveCapsule2.typeCode = SysTypeCode.NOTIFICATION;
    liveCapsule2.capsuleShowType = CapsuleShowType.NOTIFICATION;
    liveCapsule2.isShow = true;

    let liveList: LiveNotification[] = [liveCapsule1, liveCapsule2];
    livecapsulelistmultipleholelayoutvm.printFixedWithAndeOffset(liveList);

    mocker.ignoreMock(logHelper, logHelper.showInfo);
  });

  it('should_call_printCapsuleListVmFixedWidthAndOffset_for_each_capsuleType', 0, async () => {
    let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
    let mocker: MockKit = new MockKit();
    let mockfunc2: Function = mocker.mockFunc(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.printCapsuleListVmFixedWidthAndOffset);
    when(mockfunc2)(ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber).afterReturnNothing();

    let liveCapsule1: LiveNotification = new LiveNotification();
    liveCapsule1.hashCode = 1;
    liveCapsule1.type = LiveType.NOTIFICATION;
    liveCapsule1.typeCode = SysTypeCode.NOTIFICATION;
    liveCapsule1.capsuleShowType = CapsuleShowType.NOTIFICATION;
    liveCapsule1.isShow = true;

    let liveCapsule2: LiveNotification = new LiveNotification();
    liveCapsule2.hashCode = 2;
    liveCapsule2.type = LiveType.NOTIFICATION;
    liveCapsule2.typeCode = SysTypeCode.NOTIFICATION;
    liveCapsule2.capsuleShowType = CapsuleShowType.NOTIFICATION;
    liveCapsule2.isShow = true;

    let liveList: LiveNotification[] = [liveCapsule1, liveCapsule2];
    livecapsulelistmultipleholelayoutvm.printFixedWithAndeOffset(liveList);

    mocker.ignoreMock(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.printCapsuleListVmFixedWidthAndOffset);
  });

  it('should_log_info_for_each_liveCapsule_in_liveList_and_printCapsuleListVmFixedWidthAndOffset_for_each_capsuleType', 0, async () => {
    let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
    let mocker: MockKit = new MockKit();
    let logHelper: LogHelper = LogHelper.INSTANCE;
    let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
    when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

    let mockfunc2: Function = mocker.mockFunc(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.printCapsuleListVmFixedWidthAndOffset);
    when(mockfunc2)(ArgumentMatchers.anyObj, ArgumentMatchers.anyNumber).afterReturnNothing();

    let liveCapsule1: LiveNotification = new LiveNotification();
    liveCapsule1.hashCode = 1;
    liveCapsule1.type = LiveType.NOTIFICATION;
    liveCapsule1.typeCode = SysTypeCode.NOTIFICATION;
    liveCapsule1.capsuleShowType = CapsuleShowType.NOTIFICATION;
    liveCapsule1.isShow = true;

    let liveCapsule2: LiveNotification = new LiveNotification();
    liveCapsule2.hashCode = 2;
    liveCapsule2.type = LiveType.NOTIFICATION;
    liveCapsule2.typeCode = SysTypeCode.NOTIFICATION;
    liveCapsule2.capsuleShowType = CapsuleShowType.NOTIFICATION;
    liveCapsule2.isShow = true;

    let liveList: LiveNotification[] = [liveCapsule1, liveCapsule2];
    livecapsulelistmultipleholelayoutvm.printFixedWithAndeOffset(liveList);

    mocker.ignoreMock(logHelper, logHelper.showInfo);
    mocker.ignoreMock(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.printCapsuleListVmFixedWidthAndOffset);
  });

  it('should_update_fixed_offset_when_capsule_is_show', 0, async () => {
    let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
    let mocker: MockKit = new MockKit();
    let mockCapsuleVm: ILiveCapsuleVm = {
      isShow: true,
      fixedWidth: 100,
      fixedOffsetX: 0
    } as ILiveCapsuleVm;
    let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistmultipleholelayoutvm.vmInjector, livecapsulelistmultipleholelayoutvm.vmInjector.getCapsuleVm);
    when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

    let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

    let liveCapsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
    liveCapsuleList.add({
      sysType: SysTypeCode.LIVE_NOTIFICATION,
      liveType: LiveType.VIDEO_TYPE,
      capsuleShowType: CapsuleShowType.STATUS_BAR_SHOW,
      statusBarCapsulePosition: StatusBarCapsulePosition.LEFT_POSITION,
      hashCode: '1'
    } as LiveNotification);

    let result = livecapsulelistmultipleholelayoutvm.updateFixedOffsetByOffset(100, liveCapsuleList, CapsuleType.VIDEO_TYPE);
    expect(result).assertEqual(0);
    expect(mockCapsuleVm.fixedOffsetX).assertEqual(100 - (2 + 100));
    mocker.ignoreMock(livecapsulelistmultipleholelayoutvm.vmInjector, livecapsulelistmultipleholelayoutvm.vmInjector.getCapsuleVm);
    mocker.ignoreMock(LogHelper, LogHelper.showInfo);
  });

  it('should_not_update_fixed_offset_when_capsule_is_not_show', 0, async () => {
    let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
    let mocker: MockKit = new MockKit();
    let mockCapsuleVm: ILiveCapsuleVm = {
      isShow: false,
      fixedWidth: 100,
      fixedOffsetX: 0
    } as ILiveCapsuleVm;
    let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistmultipleholelayoutvm.vmInjector, livecapsulelistmultipleholelayoutvm.vmInjector.getCapsuleVm);
    when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

    let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

    let liveCapsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
    liveCapsuleList.add({
      sysType: SysTypeCode.LIVE_NOTIFICATION,
      liveType: LiveType.VIDEO_TYPE,
      capsuleShowType: CapsuleShowType.STATUS_BAR_SHOW,
      statusBarCapsulePosition: StatusBarCapsulePosition.LEFT_POSITION,
      hashCode: '1'
    } as LiveNotification);

    let result = livecapsulelistmultipleholelayoutvm.updateFixedOffsetByOffset(100, liveCapsuleList, CapsuleType.VIDEO_TYPE);
    expect(result).assertEqual(100);
    expect(mockCapsuleVm.fixedOffsetX).assertEqual(0);
    mocker.ignoreMock(livecapsulelistmultipleholelayoutvm.vmInjector, livecapsulelistmultipleholelayoutvm.vmInjector.getCapsuleVm);
    mocker.ignoreMock(LogHelper, LogHelper.showInfo);
  });

  it('should_return_totalOffset_when_liveCapsuleList_is_empty', 0, async () => {
    let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
    let mocker: MockKit = new MockKit();
    let mockCapsuleVm: ILiveCapsuleVm = {
      isShow: true,
      fixedWidth: 100,
      fixedOffsetX: 0
    } as ILiveCapsuleVm;
    let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistmultipleholelayoutvm.vmInjector, livecapsulelistmultipleholelayoutvm.vmInjector.getCapsuleVm);
    when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

    let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

    let liveCapsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
    let result = livecapsulelistmultipleholelayoutvm.updateFixedOffsetByOffset(100, liveCapsuleList, CapsuleType.VIDEO_TYPE);
    expect(result).assertEqual(100);
    expect(mockCapsuleVm.fixedOffsetX).assertEqual(0);
    mocker.ignoreMock(livecapsulelistmultipleholelayoutvm.vmInjector, livecapsulelistmultipleholelayoutvm.vmInjector.getCapsuleVm);
    mocker.ignoreMock(LogHelper, LogHelper.showInfo);
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

  it('should_call_updateFixedOffsetByOffset_for_persistent_and_screen_recording', 0, async () => {
    let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
    let mocker: MockKit = new MockKit();

    let mockUpdateProgressCapsuleFixedOffset: Function = mocker.mockFunc(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.updateProgressCapsuleFixedOffset);
    when(mockUpdateProgressCapsuleFixedOffset)([]).afterReturn(10);

    let mockUpdateFixedOffsetByOffset: Function = mocker.mockFunc(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.updateFixedOffsetByOffset);
    when(mockUpdateFixedOffsetByOffset)([ArgumentMatchers.anyNumber, ArgumentMatchers.anyObj, ArgumentMatchers.any]).afterReturn(20);

    livecapsulelistmultipleholelayoutvm.updateFixedOffset();

    mocker.ignoreMock(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.updateProgressCapsuleFixedOffset);
    mocker.ignoreMock(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.updateFixedOffsetByOffset);
  });

  it('should_log_error_when_updateFixedOffset_throws_exception', 0, async () => {
    let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
    let mocker: MockKit = new MockKit();

    let mockUpdateProgressCapsuleFixedOffset: Function = mocker.mockFunc(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.updateProgressCapsuleFixedOffset);
    when(mockUpdateProgressCapsuleFixedOffset)([]).afterThrow("Error");

    let mockLogHelper: LogHelper = new LogHelper(LogDomain.LIVE);
    let mockLoggerError: Function = mocker.mockFunc(mockLogHelper, mockLogHelper.error);
    when(mockLoggerError)([ArgumentMatchers.anyString]).afterReturnNothing();
    livecapsulelistmultipleholelayoutvm.updateFixedOffset();
    mocker.ignoreMock(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.updateProgressCapsuleFixedOffset);
    mocker.ignoreMock(mockLogHelper, mockLogHelper.error);
  });

  it('should_return_true_when_capsuleVm_has_TOP_fixedShowType', 0, () => {
    let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
    let capsuleVm: ILiveCapsuleVm = {
      fixedShowType: CapsuleShowType.TOP,
      sysType: SysTypeCode.LIVE_NOTIFICATION,
      liveType: LiveType.VIDEO_PLAY,
      statusBarCapsulePosition: StatusBarCapsulePosition.LEFT,
      isShowCapsule: true,
      capsuleWidth: 100,
      capsuleHeight: 100,
      showCapsuleList: [new NotificationArray<LiveNotification>(), new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()]
    };
    const result = livecapsulelistmultipleholelayoutvm.isShowHoleLeft(capsuleVm);
    expect(result).assertEqual(true);
  });

  it('should_return_true_when_capsuleVm_has_ROUND_CAKE_fixedShowType', 0, () => {
    let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
    let capsuleVm: ILiveCapsuleVm = {
      fixedShowType: CapsuleShowType.ROUND_CAKE,
      sysType: SysTypeCode.LIVE_NOTIFICATION,
      liveType: LiveType.VIDEO_PLAY,
      statusBarCapsulePosition: StatusBarCapsulePosition.LEFT,
      isShowCapsule: true,
      capsuleWidth: 100,
      capsuleHeight: 100,
      showCapsuleList: [new NotificationArray<LiveNotification>(), new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()]
    };
    const result = livecapsulelistmultipleholelayoutvm.isShowHoleLeft(capsuleVm);
    expect(result).assertEqual(true);
  });

  it('should_return_true_when_capsuleVm_has_RETRACTABLE_ROUND_CAKE_fixedShowType', 0, () => {
    let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
    let capsuleVm: ILiveCapsuleVm = {
      fixedShowType: CapsuleShowType.RETRACTABLE_ROUND_CAKE,
      sysType: SysTypeCode.LIVE_NOTIFICATION,
      liveType: LiveType.VIDEO_PLAY,
      statusBarCapsulePosition: StatusBarCapsulePosition.LEFT,
      isShowCapsule: true,
      capsuleWidth: 100,
      capsuleHeight: 100,
      showCapsuleList: [new NotificationArray<LiveNotification>(), new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()]
    };
    const result = livecapsulelistmultipleholelayoutvm.isShowHoleLeft(capsuleVm);
    expect(result).assertEqual(true);
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

  it('should_call_updateFixedOffsetByOffset_for_persistent_and_screen_recording', 0, async () => {
    let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
    let mocker: MockKit = new MockKit();

    let mockUpdateProgressCapsuleFixedOffset: Function = mocker.mockFunc(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.updateProgressCapsuleFixedOffset);
    when(mockUpdateProgressCapsuleFixedOffset)([]).afterReturn(10);

    let mockUpdateFixedOffsetByOffset: Function = mocker.mockFunc(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.updateFixedOffsetByOffset);
    when(mockUpdateFixedOffsetByOffset)([ArgumentMatchers.anyNumber, ArgumentMatchers.anyObj, ArgumentMatchers.any]).afterReturn(20);

    livecapsulelistmultipleholelayoutvm.updateFixedOffset();

    mocker.ignoreMock(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.updateProgressCapsuleFixedOffset);
    mocker.ignoreMock(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.updateFixedOffsetByOffset);
  });

  it('should_log_error_when_updateFixedOffset_throws_exception', 0, async () => {
    let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
    let mocker: MockKit = new MockKit();

    let mockUpdateProgressCapsuleFixedOffset: Function = mocker.mockFunc(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.updateProgressCapsuleFixedOffset);
    when(mockUpdateProgressCapsuleFixedOffset)([]).afterThrow("Error");

    let mockLogHelper: LogHelper = new LogHelper(LogDomain.LIVE);
    let mockLoggerError: Function = mocker.mockFunc(mockLogHelper, mockLogHelper.error);
    when(mockLoggerError)([ArgumentMatchers.anyString]).afterReturnNothing();
    livecapsulelistmultipleholelayoutvm.updateFixedOffset();
    mocker.ignoreMock(livecapsulelistmultipleholelayoutvm, livecapsulelistmultipleholelayoutvm.updateProgressCapsuleFixedOffset);
    mocker.ignoreMock(mockLogHelper, mockLogHelper.error);
  });

  it('should_return_true_when_capsuleVm_has_TOP_fixedShowType', 0, () => {
    let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
    let capsuleVm: ILiveCapsuleVm = {
      fixedShowType: CapsuleShowType.TOP,
      sysType: SysTypeCode.LIVE_NOTIFICATION,
      liveType: LiveType.VIDEO_PLAY,
      statusBarCapsulePosition: StatusBarCapsulePosition.LEFT,
      isShowCapsule: true,
      capsuleWidth: 100,
      capsuleHeight: 100,
      showCapsuleList: [new NotificationArray<LiveNotification>(), new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()]
    };
    const result = livecapsulelistmultipleholelayoutvm.isShowHoleLeft(capsuleVm);
    expect(result).assertEqual(true);
  });

  it('should_return_true_when_capsuleVm_has_ROUND_CAKE_fixedShowType', 0, () => {
    let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
    let capsuleVm: ILiveCapsuleVm = {
      fixedShowType: CapsuleShowType.ROUND_CAKE,
      sysType: SysTypeCode.LIVE_NOTIFICATION,
      liveType: LiveType.VIDEO_PLAY,
      statusBarCapsulePosition: StatusBarCapsulePosition.LEFT,
      isShowCapsule: true,
      capsuleWidth: 100,
      capsuleHeight: 100,
      showCapsuleList: [new NotificationArray<LiveNotification>(), new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()]
    };
    const result = livecapsulelistmultipleholelayoutvm.isShowHoleLeft(capsuleVm);
    expect(result).assertEqual(true);
  });

  it('should_return_true_when_capsuleVm_has_RETRACTABLE_ROUND_CAKE_fixedShowType', 0, () => {
    let livecapsulelistmultipleholelayoutvm: LiveCapsuleListMultipleHoleLayoutVm = new LiveCapsuleListMultipleHoleLayoutVm();
    let capsuleVm: ILiveCapsuleVm = {
      fixedShowType: CapsuleShowType.RETRACTABLE_ROUND_CAKE,
      sysType: SysTypeCode.LIVE_NOTIFICATION,
      liveType: LiveType.VIDEO_PLAY,
      statusBarCapsulePosition: StatusBarCapsulePosition.LEFT,
      isShowCapsule: true,
      capsuleWidth: 100,
      capsuleHeight: 100,
      showCapsuleList: [new NotificationArray<LiveNotification>(), new NotificationArray<LiveNotification>(),
        new NotificationArray<LiveNotification>()]
    };
    const result = livecapsulelistmultipleholelayoutvm.isShowHoleLeft(capsuleVm);
    expect(result).assertEqual(true);
  });
  it('should adjust show capsule width correctly',DEFAULT, () => {
    const testSubject = createTestSubject();
    testSubject.adjustShowCapsuleWidth(generateTestDataForAdjustShowCapsuleWidth().spaceInfo,
      generateTestDataForAdjustShowCapsuleWidth().capsuleShowList, CapsuleType.SCREEN_RECORDING);
  });

  const generateTestDataForGenerateCapsuleShowListByPrioritySort = () => ({
    showCapsuleList: [
      new NotificationArray<LiveNotification>(),
      new NotificationArray<LiveNotification>(),
      new NotificationArray<LiveNotification>()
    ]
  });

  it('should generate capsule show list by priority sort correctly',DEFAULT, () => {
    const testSubject = createTestSubject();
    testSubject.generateCapsuleShowListByPrioritySort(testSubject.showCapsuleList);
    // Add assertions here to check the order and content of the showCapsuleList
  });

  const generateTestDataForUpdateFixedWidth = () => ({
    capsuleShowList: [
      new NotificationArray<LiveNotification>(),
      new NotificationArray<LiveNotification>()
    ]
  });

  it('should update fixed width correctly',DEFAULT, () => {
    const testSubject = createTestSubject();
    testSubject.updateFixedWidth();
    // Add assertions here to check the fixed width of each capsule
  });

  const generateTestDataForUpdateFixedOffset = () => ({
    capsuleShowList: [
      new NotificationArray<LiveNotification>(),
      new NotificationArray<LiveNotification>()
    ]
  });

  it('should update fixed offset correctly',DEFAULT, () => {
    const testSubject = createTestSubject();
    testSubject.updateFixedOffset();
    // Add assertions here to check the fixed offset of each capsule
  });

  const generateTestDataForPrintFixedWithAndOffset = () => ({
    liveList: [
      mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1),
      mockLiveNotification(LiveType.INSTANT, SysTypeCode.PERSISTENT, 2),
      mockLiveNotification(LiveType.INSTANT, SysTypeCode.PROGRESS, 3)
    ]
  });
  it('should adjust show capsule width correctly',DEFAULT, () => {
    const testSubject = createTestSubject();
    testSubject.adjustShowCapsuleWidth(generateTestDataForAdjustShowCapsuleWidth().spaceInfo,
      generateTestDataForAdjustShowCapsuleWidth().capsuleShowList, CapsuleType.SCREEN_RECORDING);
  });

  const generateTestDataForGenerateCapsuleShowListByPrioritySort = () => ({
    showCapsuleList: [
      new NotificationArray<LiveNotification>(),
      new NotificationArray<LiveNotification>(),
      new NotificationArray<LiveNotification>()
    ]
  });

  it('should generate capsule show list by priority sort correctly',DEFAULT, () => {
    const testSubject = createTestSubject();
    testSubject.generateCapsuleShowListByPrioritySort(testSubject.showCapsuleList);
    // Add assertions here to check the order and content of the showCapsuleList
  });

  const generateTestDataForUpdateFixedWidth = () => ({
    capsuleShowList: [
      new NotificationArray<LiveNotification>(),
      new NotificationArray<LiveNotification>()
    ]
  });

  it('should update fixed width correctly',DEFAULT, () => {
    const testSubject = createTestSubject();
    testSubject.updateFixedWidth();
    // Add assertions here to check the fixed width of each capsule
  });

  const generateTestDataForUpdateFixedOffset = () => ({
    capsuleShowList: [
      new NotificationArray<LiveNotification>(),
      new NotificationArray<LiveNotification>()
    ]
  });

  it('should update fixed offset correctly',DEFAULT, () => {
    const testSubject = createTestSubject();
    testSubject.updateFixedOffset();
    // Add assertions here to check the fixed offset of each capsule
  });

  const generateTestDataForPrintFixedWithAndOffset = () => ({
    liveList: [
      mockLiveNotification(LiveType.INSTANT, SysTypeCode.SCREEN_RECORDING, 1),
      mockLiveNotification(LiveType.INSTANT, SysTypeCode.PERSISTENT, 2),
      mockLiveNotification(LiveType.INSTANT, SysTypeCode.PROGRESS, 3)
    ]
  });
  it('should adjust show capsule width correctly',DEFAULT, () => {
    const testSubject = createTestSubject();
    testSubject.adjustShowCapsuleWidth(generateTestDataForAdjustShowCapsuleWidth().spaceInfo,
      generateTestDataForAdjustShowCapsuleWidth().capsuleShowList, CapsuleType.SCREEN_RECORDING);
  });

  const generateTestDataForGenerateCapsuleShowListByPrioritySort = () => ({
    showCapsuleList: [
      new NotificationArray<LiveNotification>(),
      new NotificationArray<LiveNotification>(),
      new NotificationArray<LiveNotification>()
    ]
  });

  it('should generate capsule show list by priority sort correctly',DEFAULT, () => {
    const testSubject = createTestSubject();
    testSubject.generateCapsuleShowListByPrioritySort(testSubject.showCapsuleList);
    // Add assertions here to check the order and content of the showCapsuleList
  });

});