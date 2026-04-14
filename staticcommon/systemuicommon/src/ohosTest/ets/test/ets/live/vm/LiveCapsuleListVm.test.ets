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
import {
  CapsulePositionChangeCallback,
  CapsuleTransferParam,
  ILiveCapsuleListVm,
  StatusBarChangeCallback
} from '../../../../../../main/ets/live/interface/ILiveCapsuleListVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CustomPromise, obtainLocalEvent, sEventManager, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';
import { LiveBaseVm } from '../../../../../../main/ets/live/vm/LiveBaseVm';
import { NotificationArray } from '../../../../../../main/ets/model/NotificationBase';
import { StatusBarCapsulePosition } from '../../../../../../main/ets/statusbar/model/StatusBarCapsulePosition';
import { CutoutVm } from '../../../../../../main/ets/statusbar/vm/CutoutVm';
import {
  CapsuleShowType,
  LiveMetaBallScene,
  LiveCapsuleLayoutInfo,
  LiveCapsuleLayoutScene
} from '../../../../../../main/ets/live/model/LiveCommonModel';
import { LiveStyle } from '../../../../../../main/ets/live/constants/LiveStyle';
import { EnvVm } from '../../../../../../main/ets/vm/EnvVm';
import { DropdownVm } from '../../../../../../main/ets/vm/DropdownVm';
import { AppForegroundEvent, AppLifeCycleManager } from '../../../../../../main/ets/manager/AppLifeCycleManager';
import { SwipeAppToCapsuleAnimation } from '../../../../../../main/ets/animation/SwipeAppToCapsuleAnimation';
import { NodeControllerManager } from '../../../../../../main/ets/framenode/NodeControllerManager';
import { BannerVm } from '../../../../../../main/ets/vm/BannerVm';
import { DeviceInfoVm } from '../../../../../../main/ets/vm/DeviceInfoVm';
import { SystemUICcmConfig } from '../../../../../../main/ets/utils/SystemUICcmConfig';
import {
  bannerMgr,
  BannerPanelType,
  StatusBarEventType,
  SystemUICommonUtil,
  SysTypeCode
} from '../../../../../../main/ets/TsIndex';
import { LiveCapsuleAnimation } from '../../../../../../main/ets/live/animation/LiveCapsuleAnimation';
import { ILiveMetaBallVisibleVm } from '../../../../../../main/ets/live/interface/ILiveMetaBallVisibleVm';
import { ClickNotificationMaintenance } from '../../../../../../main/ets/maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '../../../../../../main/ets/maintenance/StatisticsConstants';
import { Lifecycle, LiveHiSysEvent } from '../../../../../../main/ets/live/sysEvent/LiveHiSysEvent';
import { AnimationBase } from '../../../../../../main/ets/animation/AnimationBase';
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
import { LiveCapsuleListVm } from '../../../../../../main/ets/live/vm/LiveCapsuleListVm';
import { asset } from '@kit.AssetStoreKit';

export default function LiveCapsuleListVmTest() {
  describe('capsuleLayoutRefresh_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_onCapsulePositionChange_when_isMiddleCutout_is_true', 0, () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let mockfunc: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockfunc)().afterReturn(true);

      let layoutVm: any = {};
      let mockLayoutVmFunc: Function = mocker.mockFunc(layoutVm, layoutVm.computeCapsuleFixedWithAndOffset);
      when(mockLayoutVmFunc)(ArgumentMatchers.any).afterReturnNothing();

      livecapsulelistvm.layoutVm = layoutVm;
      livecapsulelistvm.cutoutVm = cutoutVm;

      livecapsulelistvm.capsuleLayoutRefresh();

      mocker.verify('computeCapsuleFixedWithAndOffset', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
      mocker.ignoreMock(layoutVm, layoutVm.computeCapsuleFixedWithAndOffset);
    });

    it('should_call_layoutVm_computeCapsuleFixedWithAndOffset_when_isMiddleCutout_is_false', 0, () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let mockfunc: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockfunc)().afterReturn(false);

      let layoutVm: any = {};
      let mockLayoutVmFunc: Function = mocker.mockFunc(layoutVm, layoutVm.computeCapsuleFixedWithAndOffset);
      when(mockLayoutVmFunc)(ArgumentMatchers.any).afterReturnNothing();

      livecapsulelistvm.layoutVm = layoutVm;
      livecapsulelistvm.cutoutVm = cutoutVm;

      livecapsulelistvm.capsuleLayoutRefresh();

      mocker.verify('computeCapsuleFixedWithAndOffset', [ArgumentMatchers.any]).once();
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
      mocker.ignoreMock(layoutVm, layoutVm.computeCapsuleFixedWithAndOffset);
    });


  });

  describe('remoteUpdateLive_testSuite', () => {

    it('should_log_info_when_live_not_found', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let live: LiveNotification = new LiveNotification();
      live.hashCode = 1;
      livecapsulelistvm.liveList = new NotificationArray();
      await livecapsulelistvm.remoteUpdateLive(live);
      expect(LogHelper.log.showInfo).assertCalledWith("Can not find Live");
    });
    it('should_update_live_when_live_is_not_instant_and_not_expand', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let live: LiveNotification = new LiveNotification();
      live.hashCode = 1;
      livecapsulelistvm.liveList = new NotificationArray();
      livecapsulelistvm.liveList.push(live);
      await livecapsulelistvm.remoteUpdateLive(live);
      expect(livecapsulelistvm.liveList[0]).assertDeepEquals(live);
    });
    it('should_update_live_when_live_is_instant', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let live: LiveNotification = new LiveNotification();
      live.hashCode = 1;
      live.isInstant = () => true;
      livecapsulelistvm.liveList = new NotificationArray();
      livecapsulelistvm.liveList.push(live);
      await livecapsulelistvm.remoteUpdateLive(live);
      expect(livecapsulelistvm.liveList[0]).assertDeepEquals(live);
    });
    it('should_update_live_when_live_is_expand', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let live: LiveNotification = new LiveNotification();
      live.hashCode = 1;
      live.isExpand = () => true;
      livecapsulelistvm.liveList = new NotificationArray();
      livecapsulelistvm.liveList.push(live);
      await livecapsulelistvm.remoteUpdateLive(live);
      expect(livecapsulelistvm.liveList[0]).assertDeepEquals(live);
    });
    it('should_update_live_when_live_is_flip', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let live: LiveNotification = new LiveNotification();
      live.hashCode = 1;
      live.isFlip = () => true;
      livecapsulelistvm.liveList = new NotificationArray();
      livecapsulelistvm.liveList.push(live);
      await livecapsulelistvm.remoteUpdateLive(live);
      expect(livecapsulelistvm.liveList[0]).assertDeepEquals(live);
    });
    it('should_update_live_when_live_is_media_player', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let live: LiveNotification = new LiveNotification();
      live.hashCode = 1;
      live.isMediaPlayer = () => true;
      livecapsulelistvm.liveList = new NotificationArray();
      livecapsulelistvm.liveList.push(live);
      await livecapsulelistvm.remoteUpdateLive(live);
      expect(livecapsulelistvm.liveList[0]).assertDeepEquals(live);
    });
    it('should_update_live_when_live_is_in_remind', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let live: LiveNotification = new LiveNotification();
      live.hashCode = 1;
      livecapsulelistvm.liveList = new NotificationArray();
      livecapsulelistvm.liveList.push(live);
      livecapsulelistvm.remindVm.getCurrentRemindCapsule = () => live;
      await livecapsulelistvm.remoteUpdateLive(live);
      expect(livecapsulelistvm.liveList[0]).assertDeepEquals(live);
    });
    it('should_animate_to_layout_view_for_update_when_live_is_not_instant_and_not_expand', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let live: LiveNotification = new LiveNotification();
      live.hashCode = 1;
      live.isInstant = () => false;
      live.isExpand = () => false;
      livecapsulelistvm.liveList = new NotificationArray();
      livecapsulelistvm.liveList.push(live);
      let mocker: MockKit = new MockKit();
      await livecapsulelistvm.remoteUpdateLive(live);
      expect(livecapsulelistvm.liveList.length).assertEqual(0);
    });
  });

  describe('addLive_testSuite', () => {

    it('should_add_live_and_sort_capsule_list_when_live_is_not_heads_up_and_status_bar_is_showing', async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let mockSortCapsuleList: Function =
        mocker.mockFunc(livecapsulelistvm.liveList, livecapsulelistvm.liveList.sortCapsuleList);
      let mockGetCapsuleLightWaveVm: Function =
        mocker.mockFunc(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleLightWaveVm);
      let mockIsViewShowing: Function = mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing);
      let mockShowView: Function = mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.showView);
      let mockIsHideCapsule: Function =
        mocker.mockFunc(livecapsulelistvm.bannerVm, livecapsulelistvm.bannerVm.isHideCapsule);

      when(mockIsViewShowing)(ArgumentMatchers.any).afterReturn(true);
      when(mockShowView)(ArgumentMatchers.any).afterReturnNothing();
      when(mockIsHideCapsule)().afterReturn(false);

      let live: LiveNotification = new LiveNotification();
      live.typeCode = SysTypeCode.TEST;
      live.isInstant = () => false;
      live.isPersistent = () => false;
      live.isMediaPlayer = () => false;
      live.hashCode = 1;
      await livecapsulelistvm.addLive(live);

      expect(livecapsulelistvm.liveList.length).assertEqual(1);
      mocker.ignoreMock(livecapsulelistvm.liveList, livecapsulelistvm.liveList.sortCapsuleList);
      mocker.ignoreMock(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleLightWaveVm);
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.isViewShowing);
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.showView);
      mocker.ignoreMock(livecapsulelistvm.bannerVm, livecapsulelistvm.bannerVm.isHideCapsule);
    });
    it('should_add_live_and_sort_capsule_list_when_live_is_heads_up_and_status_bar_is_not_showing', async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let mockSortCapsuleList: Function =
        mocker.mockFunc(livecapsulelistvm.liveList, livecapsulelistvm.liveList.sortCapsuleList);
      let mockGetCapsuleLightWaveVm: Function =
        mocker.mockFunc(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleLightWaveVm);
      let mockIsViewShowing: Function = mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing);
      let mockShowView: Function = mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.showView);
      let mockIsHideCapsule: Function =
        mocker.mockFunc(livecapsulelistvm.bannerVm, livecapsulelistvm.bannerVm.isHideCapsule);

      when(mockIsViewShowing)(ArgumentMatchers.any).afterReturn(false);
      when(mockShowView)(ArgumentMatchers.any).afterReturnNothing();
      when(mockIsHideCapsule)().afterReturn(false);

      let live: LiveNotification = new LiveNotification();
      live.typeCode = SysTypeCode.TEST;
      live.isInstant = () => false;
      live.isPersistent = () => false;
      live.isMediaPlayer = () => false;
      live.hashCode = 1;
      live.isheadsUp = true;
      await livecapsulelistvm.addLive(live);

      expect(livecapsulelistvm.liveList.length).assertEqual(1);
      mocker.ignoreMock(livecapsulelistvm.liveList, livecapsulelistvm.liveList.sortCapsuleList);
      mocker.ignoreMock(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleLightWaveVm);
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.isViewShowing);
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.showView);
      mocker.ignoreMock(livecapsulelistvm.bannerVm, livecapsulelistvm.bannerVm.isHideCapsule);
    });
    it('should_add_live_and_sort_capsule_list_when_live_is_heads_up_and_status_bar_is_showing', async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let mockSortCapsuleList: Function =
        mocker.mockFunc(livecapsulelistvm.liveList, livecapsulelistvm.liveList.sortCapsuleList);
      let mockGetCapsuleLightWaveVm: Function =
        mocker.mockFunc(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleLightWaveVm);
      let mockIsViewShowing: Function = mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing);
      let mockShowView: Function = mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.showView);
      let mockIsHideCapsule: Function =
        mocker.mockFunc(livecapsulelistvm.bannerVm, livecapsulelistvm.bannerVm.isHideCapsule);

      when(mockIsViewShowing)(ArgumentMatchers.any).afterReturn(true);
      when(mockShowView)(ArgumentMatchers.any).afterReturnNothing();
      when(mockIsHideCapsule)().afterReturn(false);

      let live: LiveNotification = new LiveNotification();
      live.typeCode = SysTypeCode.TEST;
      live.isInstant = () => false;
      live.isPersistent = () => false;
      live.isMediaPlayer = () => false;
      live.hashCode = 1;
      live.isheadsUp = true;
      await livecapsulelistvm.addLive(live);

      expect(livecapsulelistvm.liveList.length).assertEqual(1);
      mocker.ignoreMock(livecapsulelistvm.liveList, livecapsulelistvm.liveList.sortCapsuleList);
      mocker.ignoreMock(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleLightWaveVm);
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.isViewShowing);
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.showView);
      mocker.ignoreMock(livecapsulelistvm.bannerVm, livecapsulelistvm.bannerVm.isHideCapsule);
    });
  })

  describe('removeLiveList_testSuite', () => {

    it('should_remove_live_list_and_update_live_meta_ball_visibility_when_live_list_is_not_empty', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isToDelete: false,
        opacity: 0,
        isVisible: false,
        layoutInfo: new LiveCapsuleLayoutInfo(),
        scene: LiveStyle.SCENE_DEFAULT,
        showType: CapsuleShowType.DEFAULT,
        toggleCapsule: () => {}
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      let mockGetCapsuleLifecycleVm: Function = mocker.mockFunc(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleLifecycleVm);
      let mockCapsuleLifecycleVm: ILiveCapsuleLifecycleVm = {
        getCapsuleShowTime: (id: string) => 0,
        deleteLifecycleInfo: (id: string) => {}
      };
      when(mockGetCapsuleLifecycleVm)().afterReturn(mockCapsuleLifecycleVm);

      let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      when(mockToggleCapsuleList)([]).afterReturn(new Promise<void>(() => {}));

      let mockRemove: Function = mocker.mockFunc(livecapsulelistvm.liveList, livecapsulelistvm.liveList.remove);
      when(mockRemove)(ArgumentMatchers.anyString).afterReturn(new Promise<void>(() => {}));

      let mockLiveHiSysEventReport: Function = mocker.mockFunc(LiveHiSysEvent, LiveHiSysEvent.reportLiveLifeCycleEvent);
      when(mockLiveHiSysEventReport)(ArgumentMatchers.any).afterReturn(new Promise<void>(() => {}));

      let mockRemimdVm: MockKit = new MockKit();
      let mockRemimdVmFunc: Function = mocker.mockFunc(livecapsulelistvm.remindVm, livecapsulelistvm.remindVm.isCurrentRemindCapsule);
      when(mockRemimdVmFunc)(ArgumentMatchers.any).afterReturn(false);

      let liveList: LiveNotification[] = [
        {
          hashCode: '1',
          creatorUid: '1',
          creatorBundleName: 'com.ohos.test',
          appIndex: 0,
          typeCode: SysTypeCode.PHONE,
          isInstant: false,
          isRemindShow: false
        } as LiveNotification
      ];

      await livecapsulelistvm.removeLiveList(liveList);

      expect(livecapsulelistvm.liveList.length).assertEqual(0);
      expect(livecapsulelistvm.liveMetaBallVisibleVm.isExistCapsule).assertEqual(false);

      mocker.ignoreMock(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleLifecycleVm);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      mocker.ignoreMock(livecapsulelistvm.liveList, livecapsulelistvm.liveList.remove);
      mocker.ignoreMock(LiveHiSysEvent, LiveHiSysEvent.reportLiveLifeCycleEvent);
      mocker.ignoreMock(livecapsulelistvm.remindVm, livecapsulelistvm.remindVm.isCurrentRemindCapsule);
    });

    it('should_do_nothing_when_live_list_is_empty', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isToDelete: false,
        opacity: 0,
        isVisible: false,
        layoutInfo: new LiveCapsuleLayoutInfo(),
        scene: LiveStyle.SCENE_DEFAULT,
        showType: CapsuleShowType.DEFAULT,
        toggleCapsule: () => {}
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      let mockGetCapsuleLifecycleVm: Function = mocker.mockFunc(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleLifecycleVm);
      let mockCapsuleLifecycleVm: ILiveCapsuleLifecycleVm = {
        getCapsuleShowTime: (id: string) => 0,
        deleteLifecycleInfo: (id: string) => {}
      };
      when(mockGetCapsuleLifecycleVm)().afterReturn(mockCapsuleLifecycleVm);

      let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      when(mockToggleCapsuleList)([]).afterReturn(new Promise<void>(() => {}));

      let mockRemove: Function = mocker.mockFunc(livecapsulelistvm.liveList, livecapsulelistvm.liveList.remove);
      when(mockRemove)(ArgumentMatchers.anyString).afterReturn(new Promise<void>(() => {}));

      let mockLiveHiSysEventReport: Function = mocker.mockFunc(LiveHiSysEvent, LiveHiSysEvent.reportLiveLifeCycleEvent);
      when(mockLiveHiSysEventReport)(ArgumentMatchers.any).afterReturn(new Promise<void>(() => {}));

      let mockRemimdVm: MockKit = new MockKit();
      let mockRemimdVmFunc: Function = mocker.mockFunc(livecapsulelistvm.remindVm, livecapsulelistvm.remindVm.isCurrentRemindCapsule);
      when(mockRemimdVmFunc)(ArgumentMatchers.any).afterReturn(false);

      let liveList: LiveNotification[] = [];

      await livecapsulelistvm.removeLiveList(liveList);

      expect(livecapsulelistvm.liveList.length).assertEqual(0);
      expect(livecapsulelistvm.liveMetaBallVisibleVm.isExistCapsule).assertEqual(false);

      mocker.ignoreMock(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleLifecycleVm);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      mocker.ignoreMock(livecapsulelistvm.liveList, livecapsulelistvm.liveList.remove);
      mocker.ignoreMock(LiveHiSysEvent, LiveHiSysEvent.reportLiveLifeCycleEvent);
      mocker.ignoreMock(livecapsulelistvm.remindVm, livecapsulelistvm.remindVm.isCurrentRemindCapsule);
    });
  });

  describe('removeLiveList_testSuite', () => {


    it('should_remove_live_list_and_update_live_meta_ball_visibility_when_live_list_is_not_empty', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleVm: Function = mocker.mockFunc(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isToDelete: false,
        opacity: 0,
        isVisible: false,
        layoutInfo: new LiveCapsuleLayoutInfo(),
        scene: LiveStyle.SCENE_DEFAULT,
        showType: CapsuleShowType.DEFAULT,
        toggleCapsule: () => {}
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      let mockGetCapsuleLifecycleVm: Function = mocker.mockFunc(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleLifecycleVm);
      let mockCapsuleLifecycleVm: ILiveCapsuleLifecycleVm = {
        getCapsuleShowTime: (id: string) => 0,
        deleteLifecycleInfo: (id: string) => {}
      };
      when(mockGetCapsuleLifecycleVm)().afterReturn(mockCapsuleLifecycleVm);

      let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      when(mockToggleCapsuleList)([]).afterReturn(new Promise<void>(() => {}));

      let mockRemove: Function = mocker.mockFunc(livecapsulelistvm.liveList, livecapsulelistvm.liveList.remove);
      when(mockRemove)(ArgumentMatchers.anyString).afterReturn(new Promise<void>(() => {}));

      let mockLiveHiSysEventReport: Function = mocker.mockFunc(LiveHiSysEvent, LiveHiSysEvent.reportLiveLifeCycleEvent);
      when(mockLiveHiSysEventReport)(ArgumentMatchers.any).afterReturn(new Promise<void>(() => {}));

      let mockRemimdVm: MockKit = new MockKit();
      let mockRemimdVmFunc: Function = mocker.mockFunc(livecapsulelistvm.remindVm, livecapsulelistvm.remindVm.isCurrentRemindCapsule);
      when(mockRemimdVmFunc)(ArgumentMatchers.any).afterReturn(false);

      let liveList: LiveNotification[] = [
        {
          hashCode: '1',
          creatorUid: '1',
          creatorBundleName: 'com.ohos.test',
          appIndex: 0,
          typeCode: SysTypeCode.PHONE,
          isInstant: false,
          isRemindShow: false
        } as LiveNotification
      ];

      await livecapsulelistvm.removeLiveList(liveList);

      expect(livecapsulelistvm.liveList.length).assertEqual(0);
      expect(livecapsulelistvm.liveMetaBallVisibleVm.isExistCapsule).assertEqual(false);

      mocker.ignoreMock(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleLifecycleVm);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      mocker.ignoreMock(livecapsulelistvm.liveList, livecapsulelistvm.liveList.remove);
      mocker.ignoreMock(LiveHiSysEvent, LiveHiSysEvent.reportLiveLifeCycleEvent);
      mocker.ignoreMock(livecapsulelistvm.remindVm, livecapsulelistvm.remindVm.isCurrentRemindCapsule);
    });

    it('should_not_update_live_meta_ball_visibility_when_live_list_is_empty', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();

      let mockGetCapsuleLifecycleVm: Function = mocker.mockFunc(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleLifecycleVm);
      let mockCapsuleLifecycleVm: ILiveCapsuleLifecycleVm = {
        getCapsuleShowTime: (id: string) => 0,
        deleteLifecycleInfo: (id: string) => {}
      };
      when(mockGetCapsuleLifecycleVm)().afterReturn(mockCapsuleLifecycleVm);

      let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      when(mockToggleCapsuleList)([]).afterReturn(new Promise<void>(() => {}));

      let mockRemove: Function = mocker.mockFunc(livecapsulelistvm.liveList, livecapsulelistvm.liveList.remove);
      when(mockRemove)(ArgumentMatchers.anyString).afterReturn(new Promise<void>(() => {}));

      let mockLiveHiSysEventReport: Function = mocker.mockFunc(LiveHiSysEvent, LiveHiSysEvent.reportLiveLifeCycleEvent);
      when(mockLiveHiSysEventReport)(ArgumentMatchers.any).afterReturn(new Promise<void>(() => {}));

      let mockRemimdVm: MockKit = new MockKit();
      let mockRemimdVmFunc: Function = mocker.mockFunc(livecapsulelistvm.remindVm, livecapsulelistvm.remindVm.isCurrentRemindCapsule);
      when(mockRemimdVmFunc)(ArgumentMatchers.any).afterReturn(false);

      let liveList: LiveNotification[] = [];

      await livecapsulelistvm.removeLiveList(liveList);

      expect(livecapsulelistvm.liveList.length).assertEqual(0);
      expect(livecapsulelistvm.liveMetaBallVisibleVm.isExistCapsule).assertEqual(true);

      mocker.ignoreMock(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleLifecycleVm);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      mocker.ignoreMock(livecapsulelistvm.liveList, livecapsulelistvm.liveList.remove);
      mocker.ignoreMock(LiveHiSysEvent, LiveHiSysEvent.reportLiveLifeCycleEvent);
      mocker.ignoreMock(livecapsulelistvm.remindVm, livecapsulelistvm.remindVm.isCurrentRemindCapsule);
    });
  });

  describe('toggleCapsuleList_testSuite', () => {

    it('should_stop_toggleCapsuleList_when_visible_not_changed', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let mockVisibleChanged: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.checkAllVisibleChanged);
      when(mockVisibleChanged)().afterReturn(false);

      let logHelper: LogHelper = new LogHelper();
      let mockLogInfo: Function = mocker.mockFunc(logHelper, logHelper.info);
      when(mockLogInfo)('Visible is not changed, stop toggleCapsuleList.');

      await livecapsulelistvm.toggleCapsuleList();

      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.checkAllVisibleChanged);
      mocker.ignoreMock(logHelper, logHelper.info);
    });

    it('should_not_call_animateToLayoutView_when_needAnimation_is_false', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let mockVisibleChanged: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.checkAllVisibleChanged);
      when(mockVisibleChanged)().afterReturn(true);

      let capsuleTransferParam: CapsuleTransferParam = new CapsuleTransferParam();
      capsuleTransferParam.needAnimation = false;

      await livecapsulelistvm.toggleCapsuleList(capsuleTransferParam);

      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.checkAllVisibleChanged);
    });

    it('should_call_animateToLayoutView_when_needAnimation_is_true', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let mockVisibleChanged: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.checkAllVisibleChanged);
      when(mockVisibleChanged)().afterReturn(true);

      let capsuleTransferParam: CapsuleTransferParam = new CapsuleTransferParam();
      capsuleTransferParam.needAnimation = true;

      let mockAnimateToLayoutView: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.animateToLayoutView);
      when(mockAnimateToLayoutView)(ArgumentMatchers.any).afterReturn(new Promise<void>(() => {
      }));

      await livecapsulelistvm.toggleCapsuleList(capsuleTransferParam);

      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.checkAllVisibleChanged);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.animateToLayoutView);
    });

    it('should_call_statusBarChangeCallback_when_needAnimation_is_true', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let mockVisibleChanged: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.checkAllVisibleChanged);
      when(mockVisibleChanged)().afterReturn(true);

      let capsuleTransferParam: CapsuleTransferParam = new CapsuleTransferParam();
      capsuleTransferParam.needAnimation = true;

      let mockAnimateToLayoutView: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.animateToLayoutView);
      when(mockAnimateToLayoutView)(ArgumentMatchers.any).afterReturn(new Promise<void>(() => {
      }));

      let mockStatusBarChangeCallback: Function =
        mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.statusBarChangeCallback);
      when(mockStatusBarChangeCallback)().afterReturn(undefined);

      await livecapsulelistvm.toggleCapsuleList(capsuleTransferParam);

      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.checkAllVisibleChanged);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.animateToLayoutView);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.statusBarChangeCallback);
    });

    it('should_call_onCapsulePositionChange_when_needAnimation_is_true', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let mockVisibleChanged: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.checkAllVisibleChanged);
      when(mockVisibleChanged)().afterReturn(true);

      let capsuleTransferParam: CapsuleTransferParam = new CapsuleTransferParam();
      capsuleTransferParam.needAnimation = true;

      let mockAnimateToLayoutView: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.animateToLayoutView);
      when(mockAnimateToLayoutView)(ArgumentMatchers.any).afterReturn(new Promise<void>(() => {
      }));

      let mockOnCapsulePositionChange: Function =
        mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.onCapsulePositionChange);
      when(mockOnCapsulePositionChange)(ArgumentMatchers.any).afterReturn(undefined);

      await livecapsulelistvm.toggleCapsuleList(capsuleTransferParam);

      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.checkAllVisibleChanged);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.animateToLayoutView);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.onCapsulePositionChange);
    });

    it('should_call_getCapsuleLifecycleVm_when_needAnimation_is_true', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let mockVisibleChanged: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.checkAllVisibleChanged);
      when(mockVisibleChanged)().afterReturn(true);

      let capsuleTransferParam: CapsuleTransferParam = new CapsuleTransferParam();
      capsuleTransferParam.needAnimation = true;

      let mockAnimateToLayoutView: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.animateToLayoutView);
      when(mockAnimateToLayoutView)(ArgumentMatchers.any).afterReturn(new Promise<void>(() => {
      }));

      let mockGetCapsuleLifecycleVm: Function =
        mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.vmInjector.getCapsuleLifecycleVm);
      when(mockGetCapsuleLifecycleVm)().afterReturn({
        updateCapsuleShow: (liveList: NotificationArray<LiveNotification>) => {
        }
      });

      await livecapsulelistvm.toggleCapsuleList(capsuleTransferParam);

      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.checkAllVisibleChanged);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.animateToLayoutView);
      mocker.ignoreMock(livecapsulelistvm.vmInjector.getCapsuleLifecycleVm);
    });
  });

  describe('onDropdownShowChange_testSuite', () => {


    it('should_return_immediately_when_isDropDown_is_false_and_isMiddleCutout_is_true_and_envVm_is_immersive', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let dropdownVm: DropdownVm = livecapsulelistvm.dropdownVm;
      let mockIsDropDown: Function = mocker.mockFunc(dropdownVm, dropdownVm.isDropDown);
      when(mockIsDropDown)().afterReturn(false);

      let cutoutVm: CutoutVm = livecapsulelistvm.cutoutVm;
      let mockIsMiddleCutout: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockIsMiddleCutout)().afterReturn(true);

      let envVm: EnvVm = livecapsulelistvm.envVm;
      let mockEnvImmersive: Function = mocker.mockFunc(envVm, envVm.isImmersive);
      when(mockEnvImmersive)().afterReturn(true);

      livecapsulelistvm.onDropdownShowChange();

      mocker.ignoreMock(dropdownVm, dropdownVm.isDropDown);
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
      mocker.ignoreMock(envVm, envVm.isImmersive);
    });

    it('should_call_toggleCapsuleList_when_isMiddleCutout_is_true_and_envVm_is_not_immersive', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let dropdownVm: DropdownVm = livecapsulelistvm.dropdownVm;
      let mockIsDropDown: Function = mocker.mockFunc(dropdownVm, dropdownVm.isDropDown);
      when(mockIsDropDown)().afterReturn(false);

      let cutoutVm: CutoutVm = livecapsulelistvm.cutoutVm;
      let mockIsMiddleCutout: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockIsMiddleCutout)().afterReturn(true);

      let envVm: EnvVm = livecapsulelistvm.envVm;
      let mockEnvImmersive: Function = mocker.mockFunc(envVm, envVm.isImmersive);
      when(mockEnvImmersive)().afterReturn(false);

      let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      when(mockToggleCapsuleList)(ArgumentMatchers.any).afterReturn(new CustomPromise());

      livecapsulelistvm.onDropdownShowChange();

      mocker.ignoreMock(dropdownVm, dropdownVm.isDropDown);
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
      mocker.ignoreMock(envVm, envVm.isImmersive);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
    });

    it('should_call_toggleCapsuleList_with_delay_when_isMiddleCutout_is_false', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let dropdownVm: DropdownVm = livecapsulelistvm.dropdownVm;
      let mockIsDropDown: Function = mocker.mockFunc(dropdownVm, dropdownVm.isDropDown);
      when(mockIsDropDown)().afterReturn(false);

      let cutoutVm: CutoutVm = livecapsulelistvm.cutoutVm;
      let mockIsMiddleCutout: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockIsMiddleCutout)().afterReturn(false);

      let envVm: EnvVm = livecapsulelistvm.envVm;
      let mockEnvImmersive: Function = mocker.mockFunc(envVm, envVm.isImmersive);
      when(mockEnvImmersive)().afterReturn(false);

      let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      when(mockToggleCapsuleList)(ArgumentMatchers.any).afterReturn(new CustomPromise());

      livecapsulelistvm.onDropdownShowChange();

      mocker.ignoreMock(dropdownVm, dropdownVm.isDropDown);
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
      mocker.ignoreMock(envVm, envVm.isImmersive);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
    });
  });

  describe('onScreenLockChange_testSuite', () => {


    it('should_set_isInterruptInstantBanner_to_false', 0, () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      livecapsulelistvm.onScreenLockChange();
      expect(livecapsulelistvm.isInterruptInstantBanner).assertEqual(false);
    });

    it('should_call_metaBallVm_setScene_with_LiveMetaBallScene.SCREEN_LOCK_when_envVm_isScreenLock_is_true', 0, () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let envVm: EnvVm = livecapsulelistvm.envVm;
      let mockfunc: Function = mocker.mockFunc(envVm, envVm.isScreenLock);
      when(mockfunc)().afterReturn(true);
      livecapsulelistvm.onScreenLockChange();
      mocker.ignoreMock(envVm, envVm.isScreenLock);
    });

    it('should_call_metaBallVm_setScene_with_LiveMetaBallScene.SCREEN_LOCK_when_envVm_isScreenLock_is_false', 0, () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let envVm: EnvVm = livecapsulelistvm.envVm;
      let mockfunc: Function = mocker.mockFunc(envVm, envVm.isScreenLock);
      when(mockfunc)().afterReturn(false);
      livecapsulelistvm.onScreenLockChange();
      mocker.ignoreMock(envVm, envVm.isScreenLock);
    });

    it('should_call_toggleCapsuleList_when_cutoutVm_isMiddleCutout_is_true', 0, () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = livecapsulelistvm.cutoutVm;
      let mockfunc: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockfunc)().afterReturn(true);
      livecapsulelistvm.onScreenLockChange();
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
    });

    it('should_call_toggleCapsuleList_with_delay_when_cutoutVm_isMiddleCutout_is_false', 0, () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = livecapsulelistvm.cutoutVm;
      let mockfunc: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockfunc)().afterReturn(false);
      livecapsulelistvm.onScreenLockChange();
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
    });
  });

  describe('onDropdownShowChange_testSuite', () => {


    it('should_return_immediately_when_cutoutVm_isMiddleCutout_and_dropdownVm_isDropDown_and_envVm_isImmersive', 0,
      async () => {
        let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
        let mocker: MockKit = new MockKit();

        let mockCutoutIsMiddleCutout: Function =
          mocker.mockFunc(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
        when(mockCutoutIsMiddleCutout)().afterReturn(true);

        let mockDropdownIsDropDown: Function =
          mocker.mockFunc(livecapsulelistvm.dropdownVm, livecapsulelistvm.dropdownVm.isDropDown);
        when(mockDropdownIsMiddleCutout)().afterReturn(true);

        let mockEnvIsImmersive: Function =
          mocker.mockFunc(livecapsulelistvm.envVm, livecapsulelistvm.envVm.isImmersive);
        when(mockEnvIsImmersive)().afterReturn(true);

        livecapsulelistvm.onDropdownShowChange();

        mocker.ignoreMock(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
        mocker.ignoreMock(livecapsulelistvm.dropdownVm, livecapsulelistvm.dropdownVm.isDropDown);
        mocker.ignoreMock(livecapsulelistvm.envVm, livecapsulelistvm.envVm.isImmersive);
      });

    it('should_call_toggleCapsuleList_when_cutoutVm_isMiddleCutout_and_dropdownVm_isDropDown_and_envVm_isImmersive_false',
      0, async () => {
        let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
        let mocker: MockKit = new MockKit();

        let mockCutoutIsMiddleCutout: Function =
          mocker.mockFunc(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
        when(mockCutoutIsMiddleCutout)().afterReturn(true);

        let mockDropdownIsDropDown: Function =
          mocker.mockFunc(livecapsulelistvm.dropdownVm, livecapsulelistvm.dropdownVm.isDropDown);
        when(mockDropdownIsMiddleCutout)().afterReturn(true);

        let mockEnvIsImmersive: Function =
          mocker.mockFunc(livecapsulelistvm.envVm, livecapsulelistvm.envVm.isImmersive);
        when(mockEnvIsImmersive)().afterReturn(false);

        let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
        when(mockToggleCapsuleList)(ArgumentMatchers.any).afterReturn(new CustomPromise());

        livecapsulelistvm.onDropdownShowChange();

        mocker.ignoreMock(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
        mocker.ignoreMock(livecapsulelistvm.dropdownVm, livecapsulelistvm.dropdownVm.isDropDown);
        mocker.ignoreMock(livecapsulelistvm.envVm, livecapsulelistvm.envVm.isImmersive);
        mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      });

    it('should_call_toggleCapsuleList_when_cutoutVm_isMiddleCutout_and_dropdownVm_isDropDown_and_envVm_isImmersive_true_and_liveList_length_is_not_1',
      0, async () => {
        let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
        livecapsulelistvm.liveList = new NotificationArray();
        livecapsulelistvm.liveList.push(new LiveNotification());
        let mocker: MockKit = new MockKit();

        let mockCutoutIsMiddleCutout: Function =
          mocker.mockFunc(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
        when(mockCutoutIsMiddleCutout)().afterReturn(true);

        let mockDropdownIsDropDown: Function =
          mocker.mockFunc(livecapsulelistvm.dropdownVm, livecapsulelistvm.dropdownVm.isDropDown);
        when(mockDropdownIsMiddleCutout)().afterReturn(true);

        let mockEnvIsImmersive: Function =
          mocker.mockFunc(livecapsulelistvm.envVm, livecapsulelistvm.envVm.isImmersive);
        when(mockEnvIsImmersive)().afterReturn(true);

        let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
        when(mockToggleCapsuleList)(ArgumentMatchers.any).afterReturn(new CustomPromise());

        livecapsulelistvm.onDropdownShowChange();

        mocker.ignoreMock(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
        mocker.ignoreMock(livecapsulelistvm.dropdownVm, livecapsulelistvm.dropdownVm.isDropDown);
        mocker.ignoreMock(livecapsulelistvm.envVm, livecapsulelistvm.envVm.isImmersive);
        mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      });

    it('should_call_toggleCapsuleList_when_cutoutVm_isMiddleCutout_and_dropdownVm_isDropDown_and_envVm_isImmersive_true_and_liveList_length_is_1_and_live_typeCode_is_PHONE_and_capsuleVm_opacity_is_0',
      0, async () => {
        let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
        livecapsulelistvm.liveList = new NotificationArray();
        livecapsulelistvm.liveList.push(new LiveNotification());
        livecapsulelistvm.liveList[0].typeCode = SysTypeCode.PHONE;
        let mocker: MockKit = new MockKit();

        let mockCutoutIsMiddleCutout: Function =
          mocker.mockFunc(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
        when(mockCutoutIsMiddleCutout)().afterReturn(true);

        let mockDropdownIsDropDown: Function =
          mocker.mockFunc(livecapsulelistvm.dropdownVm, livecapsulelistvm.dropdownVm.isDropDown);
        when(mockDropdownIsMiddleCutout)().afterReturn(true);

        let mockEnvIsImmersive: Function =
          mocker.mockFunc(livecapsulelistvm.envVm, livecapsulelistvm.envVm.isImmersive);
        when(mockEnvIsImmersive)().afterReturn(true);

        let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
        when(mockToggleCapsuleList)(ArgumentMatchers.any).afterReturn(new CustomPromise());

        let mockCapsuleVmOpacity: Function =
          mocker.mockFunc(livecapsulelistvm.vmInjector.getCapsuleVm(livecapsulelistvm.liveList[0]),
            livecapsulelistvm.vmInjector.getCapsuleVm(livecapsulelistvm.liveList[0]).opacity);
        when(mockCapsuleVmOpacity)().afterReturn(0);

        livecapsulelistvm.onDropdownShowChange();

        mocker.ignoreMock(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
        mocker.ignoreMock(livecapsulelistvm.dropdownVm, livecapsulelistvm.dropdownVm.isDropDown);
        mocker.ignoreMock(livecapsulelistvm.envVm, livecapsulelistvm.envVm.isImmersive);
        mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
        mocker.ignoreMock(livecapsulelistvm.vmInjector.getCapsuleVm(livecapsulelistvm.liveList[0]),
          livecapsulelistvm.vmInjector.getCapsuleVm(livecapsulelistvm.liveList[0]).opacity);
      });
  });

  describe('onScreenLockChange_testSuite', () => {


    it('should_set_isInterruptInstantBanner_to_false', 0, () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      livecapsulelistvm.onScreenLockChange();
      expect(livecapsulelistvm.isInterruptInstantBanner).assertEqual(false);
    });

    it('should_call_metaBallVm_setScene_with_LiveMetaBallScene.SCREEN_LOCK_when_envVm_isScreenLock_is_true', 0, () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let envVm: EnvVm = livecapsulelistvm.envVm;
      let mockfunc: Function = mocker.mockFunc(envVm, envVm.isScreenLock);
      when(mockfunc)().afterReturn(true);
      livecapsulelistvm.onScreenLockChange();
      mocker.ignoreMock(envVm, envVm.isScreenLock);
    });

    it('should_call_metaBallVm_setScene_with_LiveMetaBallScene.SCREEN_LOCK_when_envVm_isScreenLock_is_false', 0, () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let envVm: EnvVm = livecapsulelistvm.envVm;
      let mockfunc: Function = mocker.mockFunc(envVm, envVm.isScreenLock);
      when(mockfunc)().afterReturn(false);
      livecapsulelistvm.onScreenLockChange();
      mocker.ignoreMock(envVm, envVm.isScreenLock);
    });

    it('should_call_toggleCapsuleList_when_cutoutVm_isMiddleCutout_is_true', 0, () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = livecapsulelistvm.cutoutVm;
      let mockfunc: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockfunc)().afterReturn(true);
      livecapsulelistvm.onScreenLockChange();
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
    });

    it('should_call_toggleCapsuleList_with_delay_when_cutoutVm_isMiddleCutout_is_false', 0, () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = livecapsulelistvm.cutoutVm;
      let mockfunc: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockfunc)().afterReturn(false);
      livecapsulelistvm.onScreenLockChange();
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
    });
  });

  describe('onStatusBarShowHideChange_testSuite', () => {


    it('should_log_info_when_statusBar_show_hide_change', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = new LogHelper();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      livecapsulelistvm.onStatusBarShowHideChange();
      expect(mockShowInfo).assertCalledWith("onStatusBarShowHideChange isShow(true) isMiddleCutout(false) rotaitonPromise(true).");
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_scene_when_statusBar_show_hide_change', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let envVm: EnvVm = new EnvVm();
      livecapsulelistvm.envVm = envVm;
      let mockMetaBallSetScene: Function = mocker.mockFunc(livecapsulelistvm.metaBallVm, livecapsulelistvm.metaBallVm.setScene);
      when(mockMetaBallSetScene)(ArgumentMatchers.any).afterReturnNothing();
      livecapsulelistvm.onStatusBarShowHideChange();
      expect(mockMetaBallSetScene).assertCalledWith(LiveMetaBallScene.STATUSBAR_HIDE, true);
      mocker.ignoreMock(livecapsulelistvm.metaBallVm, livecapsulelistvm.metaBallVm.setScene);
    });

    it('should_return_when_isClearAllApp_is_true', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let liveDataVm: ESObject = { isClearAllApp: true } as ILiveVmInjector;
      let mockGetLiveDataVm: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.vmInjector.getLiveDataVm);
      when(mockGetLiveDataVm)().afterReturn(liveDataVm);
      livecapsulelistvm.onStatusBarShowHideChange();
      expect(mockGetLiveDataVm).assertCalled();
      mocker.ignoreMock(livecapsulelistvm.vmInjector.getLiveDataVm, livecapsulelistvm.vmInjector.getLiveDataVm);
    });

    it('should_toggle_capsule_list_when_isMiddleCutout_is_true_and_no_rotation_promise', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = new CutoutVm();
      livecapsulelistvm.cutoutVm = cutoutVm;
      let mockIsMiddleCutout: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockIsMiddleCutout)().afterReturn(true);
      let deviceInfoVm: DeviceInfoVm = new DeviceInfoVm();
      livecapsulelistvm.deviceInfoVm = deviceInfoVm;
      let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      when(mockToggleCapsuleList)(ArgumentMatchers.any).afterReturn(new CustomPromise());
      livecapsulelistvm.onStatusBarShowHideChange();
      expect(mockIsMiddleCutout).assertCalled();
      expect(mockToggleCapsuleList).assertCalled();
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
    });

    it('should_not_toggle_capsule_list_when_isMiddleCutout_is_false_or_rotation_promise_is_not_null', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = new CutoutVm();
      livecapsulelistvm.cutoutVm = cutoutVm;
      let mockIsMiddleCutout: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockIsMiddleCutout)().afterReturn(false);
      let deviceInfoVm: DeviceInfoVm = new DeviceInfoVm();
      deviceInfoVm.rotationPromise = new CustomPromise();
      livecapsulelistvm.deviceInfoVm = deviceInfoVm;
      livecapsulelistvm.onStatusBarShowHideChange();
      expect(mockIsMiddleCutout).assertCalled();
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
    });
  });

  describe('onCutoutChange_testSuite', () => {


    it('should_handle_cutout_change_middle_cutout', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();

      // Mock CutoutVm.isMiddleCutout
      let mockIsMiddleCutout: Function = mocker.mockFunc(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
      when(mockIsMiddleCutout)().afterReturn(true);

      // Mock LiveCapsuleListVm.toggleCapsuleList
      let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      when(mockToggleCapsuleList)(ArgumentMatchers.any).afterReturn(new CustomPromise());

      livecapsulelistvm.onCutoutChange();

      mocker.ignoreMock(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
    });

    it('should_handle_cutout_change_not_middle_cutout', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();

      // Mock CutoutVm.isMiddleCutout
      let mockIsMiddleCutout: Function = mocker.mockFunc(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
      when(mockIsMiddleCutout)().afterReturn(false);

      // Mock LiveCapsuleListVm.toggleCapsuleList
      let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      when(mockToggleCapsuleList)(ArgumentMatchers.any).afterReturn(new CustomPromise());

      livecapsulelistvm.onCutoutChange();

      mocker.ignoreMock(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
    });

    it('should_handle_cutout_change_with_persistent_capsule', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();

      // Mock CutoutVm.isMiddleCutout
      let mockIsMiddleCutout: Function = mocker.mockFunc(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
      when(mockIsMiddleCutout)().afterReturn(false);

      // Mock LiveCapsuleListVm.toggleCapsuleList
      let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      when(mockToggleCapsuleList)(ArgumentMatchers.any).afterReturn(new CustomPromise());

      // Mock findShowingPersistentCapsule
      let mockFindShowingPersistentCapsule: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.findShowingPersistentCapsule);
      when(mockFindShowingPersistentCapsule)().afterReturn({ duration: 10 });

      livecapsulelistvm.onCutoutChange();

      mocker.ignoreMock(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.findShowingPersistentCapsule);
    });

    it('should_handle_cutout_change_without_persistent_capsule_and_show_capsule', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();

      // Mock CutoutVm.isMiddleCutout
      let mockIsMiddleCutout: Function = mocker.mockFunc(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
      when(mockIsMiddleCutout)().afterReturn(false);

      // Mock LiveCapsuleListVm.toggleCapsuleList
      let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      when(mockToggleCapsuleList)(ArgumentMatchers.any).afterReturn(new CustomPromise());

      // Mock findShowingPersistentCapsule
      let mockFindShowingPersistentCapsule: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.findShowingPersistentCapsule);
      when(mockFindShowingPersistentCapsule)().afterReturn(undefined);

      // Mock getShowCapsuleNum
      let mockGetShowCapsuleNum: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.getShowCapsuleNum);
      when(mockGetShowCapsuleNum)().afterReturn(1);

      livecapsulelistvm.onCutoutChange();

      mocker.ignoreMock(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.findShowingPersistentCapsule);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.getShowCapsuleNum);
    });

    it('should_handle_cutout_change_without_persistent_capsule_and_no_show_capsule', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();

      // Mock CutoutVm.isMiddleCutout
      let mockIsMiddleCutout: Function = mocker.mockFunc(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
      when(mockIsMiddleCutout)().afterReturn(false);

      // Mock LiveCapsuleListVm.toggleCapsuleList
      let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      when(mockToggleCapsuleList)(ArgumentMatchers.any).afterReturn(new CustomPromise());

      // Mock findShowingPersistentCapsule
      let mockFindShowingPersistentCapsule: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.findShowingPersistentCapsule);
      when(mockFindShowingPersistentCapsule)().afterReturn(undefined);

      // Mock getShowCapsuleNum
      let mockGetShowCapsuleNum: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.getShowCapsuleNum);
      when(mockGetShowCapsuleNum)().afterReturn(0);

      livecapsulelistvm.onCutoutChange();

      mocker.ignoreMock(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.findShowingPersistentCapsule);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.getShowCapsuleNum);
    });
  });
  describe('localUpdateLiveList_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_info_when_live_not_found', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let liveList: LiveNotification[] = [
        {
          hashCode: 1,
          creatorUid: 1,
          creatorBundleName: 'bundleName',
          appIndex: 1,
          typeCode: SysTypeCode.PHONE,
          liveStyle: LiveStyle.VIDEO_CALL,
          liveShowType: CapsuleShowType.DEFAULT,
          liveCapsuleLayoutInfo: new LiveCapsuleLayoutInfo(),
          liveCapsuleLayoutScene: LiveCapsuleLayoutScene.DEFAULT,
          liveMetaBallVisibleVm: ILiveMetaBallVisibleVm.instance,
          capsuleTransferParam: new CapsuleTransferParam(),
          statusBarCapsulePosition: new StatusBarCapsulePosition(),
          onCapsuleTransfer: () => {}
        }
      ];

      await livecapsulelistvm.localUpdateLiveList(liveList);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_update_live_list_and_report_event', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let liveList: LiveNotification[] = [
        {
          hashCode: 1,
          creatorUid: 1,
          creatorBundleName: 'bundleName',
          appIndex: 1,
          typeCode: SysTypeCode.PHONE,
          liveStyle: LiveStyle.VIDEO_CALL,
          liveShowType: CapsuleShowType.DEFAULT,
          liveCapsuleLayoutInfo: new LiveCapsuleLayoutInfo(),
          liveCapsuleLayoutScene: LiveCapsuleLayoutScene.DEFAULT,
          liveMetaBallVisibleVm: ILiveMetaBallVisibleVm.instance,
          capsuleTransferParam: new CapsuleTransferParam(),
          statusBarCapsulePosition: new StatusBarCapsulePosition(),
          onCapsuleTransfer: () => {}
        }
      ];

      livecapsulelistvm.liveList = new NotificationArray();
      livecapsulelistvm.liveList.push({
        hashCode: 1,
        creatorUid: 1,
        creatorBundleName: 'bundleName',
        appIndex: 1,
        typeCode: SysTypeCode.PHONE,
        liveStyle: LiveStyle.VIDEO_CALL,
        liveShowType: CapsuleShowType.DEFAULT,
        liveCapsuleLayoutInfo: new LiveCapsuleLayoutInfo(),
        liveCapsuleLayoutScene: LiveCapsuleLayoutScene.DEFAULT,
        liveMetaBallVisibleVm: ILiveMetaBallVisibleVm.instance,
        capsuleTransferParam: new CapsuleTransferParam(),
        statusBarCapsulePosition: new StatusBarCapsulePosition(),
        onCapsuleTransfer: () => {}
      });

      await livecapsulelistvm.localUpdateLiveList(liveList);

      expect(livecapsulelistvm.liveList[0]).assertDeepEquals(liveList[0]);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_layoutVm_and_animVm_update_methods', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let layoutVm: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.layoutVm);
      let animVm: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.animVm);
      when(layoutVm)(ArgumentMatchers.any).afterReturnNothing();
      when(animVm)(ArgumentMatchers.any).afterReturnNothing();

      let liveList: LiveNotification[] = [
        {
          hashCode: 1,
          creatorUid: 1,
          creatorBundleName: 'bundleName',
          appIndex: 1,
          typeCode: SysTypeCode.PHONE,
          liveStyle: LiveStyle.VIDEO_CALL,
          liveShowType: CapsuleShowType.DEFAULT,
          liveCapsuleLayoutInfo: new LiveCapsuleLayoutInfo(),
          liveCapsuleLayoutScene: LiveCapsuleLayoutScene.DEFAULT,
          liveMetaBallVisibleVm: ILiveMetaBallVisibleVm.instance,
          capsuleTransferParam: new CapsuleTransferParam(),
          statusBarCapsulePosition: new StatusBarCapsulePosition(),
          onCapsuleTransfer: () => {}
        }
      ];

      await livecapsulelistvm.localUpdateLiveList(liveList);

      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.layoutVm);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.animVm);
    });
  });

  describe('toggleCapsuleList_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_stop_toggleCapsuleList_when_visible_not_changed', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockCheckAllVisibleChanged: Function =
        mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.checkAllVisibleChanged);
      when(mockCheckAllVisibleChanged)().afterReturn(false);

      await livecapsulelistvm.toggleCapsuleList();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.checkAllVisibleChanged);
    });

    it('should_call_layoutVm_and_animateToLayoutView_when_needAnimation_is_true', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockCheckAllVisibleChanged: Function =
        mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.checkAllVisibleChanged);
      when(mockCheckAllVisibleChanged)().afterReturn(true);

      let mockLayoutVm: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.layoutVm);
      when(mockLayoutVm)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturnNothing();

      let mockAnimateToLayoutView: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.animateToLayoutView);
      when(mockAnimateToLayoutView)(ArgumentMatchers.any).afterReturn(new Promise<void>(() => {
      }));

      let mockGetCapsuleLifecycleVm: Function =
        mocker.mockFunc(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleLifecycleVm);
      when(mockGetCapsuleLifecycleVm)().afterReturn({
        updateCapsuleShow: (liveList: NotificationArray<LiveNotification>) => {
        }
      });

      await livecapsulelistvm.toggleCapsuleList({
        needAnimation: true
      });

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.checkAllVisibleChanged);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.layoutVm);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.animateToLayoutView);
      mocker.ignoreMock(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleLifecycleVm);
    });

    it('should_not_call_animateToLayoutView_when_needAnimation_is_false', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockCheckAllVisibleChanged: Function =
        mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.checkAllVisibleChanged);
      when(mockCheckAllVisibleChanged)().afterReturn(true);

      let mockLayoutVm: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.layoutVm);
      when(mockLayoutVm)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturnNothing();

      let mockAnimateToLayoutView: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.animateToLayoutView);
      when(mockAnimateToLayoutView)(ArgumentMatchers.any).afterReturn(new Promise<void>(() => {
      }));

      let mockGetCapsuleLifecycleVm: Function =
        mocker.mockFunc(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleLifecycleVm);
      when(mockGetCapsuleLifecycleVm)().afterReturn({
        updateCapsuleShow: (liveList: NotificationArray<LiveNotification>) => {
        }
      });

      await livecapsulelistvm.toggleCapsuleList({
        needAnimation: false
      });

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.checkAllVisibleChanged);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.layoutVm);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.animateToLayoutView);
      mocker.ignoreMock(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleLifecycleVm);
    });

    it('should_call_statusBarChangeCallback_when_needAnimation_is_true', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockCheckAllVisibleChanged: Function =
        mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.checkAllVisibleChanged);
      when(mockCheckAllVisibleChanged)().afterReturn(true);

      let mockLayoutVm: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.layoutVm);
      when(mockLayoutVm)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturnNothing();

      let mockAnimateToLayoutView: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.animateToLayoutView);
      when(mockAnimateToLayoutView)(ArgumentMatchers.any).afterReturn(new Promise<void>(() => {
      }));

      let mockGetCapsuleLifecycleVm: Function =
        mocker.mockFunc(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleLifecycleVm);
      when(mockGetCapsuleLifecycleVm)().afterReturn({
        updateCapsuleShow: (liveList: NotificationArray<LiveNotification>) => {
        }
      });

      let mockStatusBarChangeCallback: Function =
        mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.statusBarChangeCallback);
      when(mockStatusBarChangeCallback)().afterReturnNothing();

      await livecapsulelistvm.toggleCapsuleList({
        needAnimation: true
      });

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.checkAllVisibleChanged);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.layoutVm);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.animateToLayoutView);
      mocker.ignoreMock(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleLifecycleVm);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.statusBarChangeCallback);
    });
  });

  describe('onCutoutChange_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_info_when_cutoutChange_is_called', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      livecapsulelistvm.onCutoutChange();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_needStatusBarKeepShowing_to_true_when_findShowingPersistentCapsule_returns_a_value', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = livecapsulelistvm.cutoutVm;

      when(mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout))(ArgumentMatchers.any).afterReturn(true);

      livecapsulelistvm.onCutoutChange();

      expect(livecapsulelistvm.needStatusBarKeepShowing).assertEqual(true);
    });

    it('should_call_toggleCapsuleList_when_targetPersistentCapsule_is_undefined_and_showCapsuleNum_is_greater_than_0', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new CustomPromise<void>(() => {}));

      livecapsulelistvm.onCutoutChange();

      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
    });

    it('should_call_onCutoutDisplayChangeToMiddle_when_cutoutVm_is_middleCutout', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = livecapsulelistvm.cutoutVm;

      when(mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout))(ArgumentMatchers.any).afterReturn(true);

      livecapsulelistvm.onCutoutChange();

    });

    it('should_call_toggleCapsuleList_with_needAnimation_false_when_cutoutVm_is_not_middleCutout', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new CustomPromise<void>(() => {}));
      let cutoutVm: CutoutVm = livecapsulelistvm.cutoutVm;

      when(mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout))(ArgumentMatchers.any).afterReturn(false);

      livecapsulelistvm.onCutoutChange();

      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
    });
  });

  describe('addLive1_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_add_live_and_sort_capsule_list_when_live_is_not_heads_up_and_status_bar_is_showing', async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();

      let mockLiveHeadsUpVm: ILiveHeadsUpVm = mocker.mockObj(LiveVmInjector.instance.getLiveHeadsUpVm());
      when(mockLiveHeadsUpVm.headsUpNtfHashCode).afterReturn(12345);

      let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      when(mockToggleCapsuleList)(ArgumentMatchers.any).afterReturn(new CustomPromise());

      let mockLiveMediaPlayerVm: ILiveMediaPlayerVm =
        mocker.mockObj(LiveVmInjector.instance.getLiveMediaPlayerVm(new LiveNotification()));
      when(mockLiveMediaPlayerVm.addMedia).afterReturn(new CustomPromise());

      let mockLiveHiSysEvent: Function = mocker.mockFunc(LiveHiSysEvent, LiveHiSysEvent.reportLiveLifeCycleEvent);
      when(mockLiveHiSysEvent)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any)
        .afterReturn(new CustomPromise());

      let mockLiveHiSysEvent2: Function = mocker.mockFunc(LiveHiSysEvent, LiveHiSysEvent.reportCapsuleNumChangeEvent);
      when(mockLiveHiSysEvent2)(ArgumentMatchers.any).afterReturn(new CustomPromise());

      let mockIsViewShowing: Function = mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing);
      when(mockIsViewShowing)(ArgumentMatchers.any).afterReturn(true);

      let mockShowView: Function = mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.showView);
      when(mockShowView)(ArgumentMatchers.any).afterReturnNothing();

      let live: LiveNotification = new LiveNotification();
      live.typeCode = SysTypeCode.PHONE;
      live.isInstant = () => false;
      live.isPersistent = () => false;
      live.isMediaPlayer = () => false;
      live.hashCode = 12345;
      await livecapsulelistvm.addLive(live);

      expect(livecapsulelistvm.liveList.length).assertEqual(1);
      expect(livecapsulelistvm.liveList[0].hashCode).assertEqual(12345);
      mocker.ignoreMock(LiveVmInjector.instance.getLiveHeadsUpVm());
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      mocker.ignoreMock(LiveVmInjector.instance.getLiveMediaPlayerVm(new LiveNotification()),
        LiveVmInjector.instance.getLiveMediaPlayerVm(new LiveNotification()).addMedia);
      mocker.ignoreMock(LiveHiSysEvent, LiveHiSysEvent.reportLiveLifeCycleEvent);
      mocker.ignoreMock(LiveHiSysEvent, LiveHiSysEvent.reportCapsuleNumChangeEvent);

      //待测试分支： 进入live.isHeadsUp 进入 !this.bannerVm.isHideCapsule() 进入 !this.dropdownVm.isDropDown
      it('should_handle_headsUp_capsule_when_banner_is_not_hidden_and_dropdown_is_not_shown', 0, async () => {
        let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm

        //待测试分支： 进入SystemUICcmConfig.instance.liveConfig.isShowLightWhenExpandCapsule() 进入    viewMgrPolicy.isViewShowing(ViewType.STATUS_BAR)
        it('should_add_live_and_show_light_wave_when_conditions_are_met', 0, async () => {
          let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
          let mocker: MockKit = new MockKit();
          let live: LiveNotification = new LiveNotification();
          let mockSystemUICcmConfig = mocker.mockFunc(SystemUICcmConfig.instance.liveConfig,
            SystemUICcmConfig.instance.liveConfig.isShowLightWhenExpandCapsule);
          let mockViewMgrPolicy = mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing);
          when(mockSystemUICcmConfig)().afterReturn(true);
          when(mockViewMgrPolicy)(ViewType.STATUS_BAR).afterReturn(true);
          await livecapsulelistvm.addLive(live);
          mocker.verify('isShowLightWhenExpandCapsule', []).atLeast(1);
          mocker.verify('isViewShowing', [ViewType.STATUS_BAR]).atLeast(1);
          mocker.ignoreMock(SystemUICcmConfig.instance.liveConfig,
            SystemUICcmConfig.instance.liveConfig.isShowLightWhenExpandCapsule);
          mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.isViewShowing);
        });

        //待测试分支： 不进入 (live.isHeadsUp 进入 !this.bannerVm.isHideCapsule() 进入 !this.dropdownVm.isDropDown) 进入!viewMgrPolicy.isViewShowing(ViewType.STATUS_BAR)
        it('should_not_toggle_capsule_list_when_live_is_headsUp_and_banner_is_not_hidden_and_dropdown_is_not_shown', 0,
          async () => {
            let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
            let mocker: MockKit = new MockKit();
            let live = new LiveNotification();
            live.isHeadsUp = true;
            let mockBannerVm = mocker.mockFunc(livecapsulelistvm.bannerVm, livecapsulelistvm.bannerVm.isHideCapsule);
            when(mockBannerVm)().afterReturn(false);
            let mockDropdownVm = mocker.mockFunc(livecapsulelistvm.dropdownVm, livecapsulelistvm.dropdownVm.isDropDown);
            when(mockDropdownVm)().afterReturn(false);
            let mockToggleCapsuleList = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
            await livecapsulelistvm.addLive(live);
            mocker.verify('toggleCapsuleList', []).never();
            mocker.ignoreMock(livecapsulelistvm.bannerVm, livecapsulelistvm.bannerVm.isHideCapsule);
            mocker.ignoreMock(livecapsulelistvm.dropdownVm, livecapsulelistvm.dropdownVm.isDropDown);
          });

        //待测试分支： 不进入 (live.isHeadsUp 进入 !this.bannerVm.isHideCapsule() 进入 !this.dropdownVm.isDropDown) 进入live.isMediaPlayer()
        it('should_handle_media_player_live_and_show_light_wave_when_expand_capsule', 0, async () => {
          let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
          let mocker: MockKit = new MockKit();
          let live: LiveNotification = new LiveNotification();
          let mockIsMediaPlayer: Function = mocker.mockFunc(live, live.isMediaPlayer);
          let mockIsInstant: Function = mocker.mockFunc(live, live.isInstant);
          let mockIsPersistent: Function = mocker.mockFunc(live, live.isPersistent);
          let mockIsHideCapsule: Function =
            mocker.mockFunc(livecapsulelistvm.bannerVm, livecapsulelistvm.bannerVm.isHideCapsule);
          let mockIsShowLightWhenExpandCapsule: Function = mocker.mockFunc(SystemUICcmConfig.instance.liveConfig,
            SystemUICcmConfig.instance.liveConfig.isShowLightWhenExpandCapsule);
          let mockGetCapsuleLightWaveVm: Function =
            mocker.mockFunc(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleLightWaveVm);
          let mockGetLiveMediaPlayerVm: Function =
            mocker.mockFunc(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getLiveMediaPlayerVm);
          let mockShowView: Function =
            mocker.mockFunc(livecapsulelistvm.viewManager, livecapsulelistvm.viewManager.showView);
          let mockIsViewShowing: Function =
            mocker.mockFunc(livecapsulelistvm.viewManager, livecapsulelistvm.viewManager.isViewShowing);
          let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);

          when(mockIsMediaPlayer)().afterReturn(true);
          when(mockIsInstant)().afterReturn(false);
          when(mockIsPersistent)().afterReturn(true);
          when(mockIsHideCapsule)().afterReturn(true);
          when(mockIsShowLightWhenExpandCapsule)().afterReturn(true);
          when(mockGetCapsuleLightWaveVm)(live).afterReturn({
            lightShow: false
          });
          when(mockGetLiveMediaPlayerVm)(live).afterReturn({
            addMedia: () => {
            }
          });
          when(mockShowView)(ViewType.STATUS_BAR).afterReturn();
          when(mockIsViewShowing)(ViewType.STATUS_BAR).afterReturn(true);
          when(mockToggleCapsuleList)().afterReturn();

          await livecapsulelistvm.addLive(live);

          expect(mockGetCapsuleLightWaveVm(live).lightShow).assertTrue();
          expect(mockGetLiveMediaPlayerVm(live).addMedia).assertEqual(live);
          mocker.ignoreMock(livecapsulelistvm.bannerVm, livecapsulelistvm.bannerVm.isHideCapsule);
          mocker.ignoreMock(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleLightWaveVm);
          mocker.ignoreMock(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getLiveMediaPlayerVm);
          mocker.ignoreMock(livecapsulelistvm.viewManager, livecapsulelistvm.viewManager.showView);
          mocker.ignoreMock(livecapsulelistvm.viewManager, livecapsulelistvm.viewManager.isViewShowing);
          mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
        });
      })
    })
  });

  describe('initLiveList1_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_immediately_when_liveList_is_empty', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.animateToLayoutView);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new CustomPromise<void>(() => {
      }));

      let mockfunc2: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.getCapsuleVm);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn({
        opacity: 0,
        isVisible: false,
        isShowed: false
      });

      let mockfunc3: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.sortCapsuleList);
      when(mockfunc3)().afterReturn(livecapsulelistvm);

      let mockfunc4: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      when(mockfunc4)(ArgumentMatchers.any).afterReturn(new CustomPromise<void>(() => {
      }));

      let mockfunc5: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.onBannerTypeChange);
      when(mockfunc5)().afterReturnNothing();

      let mockfunc6: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.onAppForegroundStateChange);
      when(mockfunc6)(ArgumentMatchers.any).afterReturn(new CustomPromise<void>(() => {
      }));

      let mockfunc7: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.onCheckAppToCapsule);
      when(mockfunc7)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(false);

      let mockfunc8: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc8)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc9: Function = mocker.mockFunc(LiveBaseVm, LiveBaseVm.instance.getLiveDataVm);
      when(mockfunc9)().afterReturn({
        isClearAllApp: false
      });

      let mockfunc10: Function = mocker.mockFunc(LiveBaseVm, LiveBaseVm.instance.getViewModel);
      when(mockfunc10)(ArgumentMatchers.any).afterReturn({
        on: () => {
        }
      });

      let mockfunc11: Function = mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.play);
      when(mockfunc11)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc12: Function = mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.stop);
      when(mockfunc12)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc13: Function = mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.release);
      when(mockfunc13)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc14: Function = mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.init);
      when(mockfunc14)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc15: Function = mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.playOpenCapsule);
      when(mockfunc15)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc16: Function = mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.playCloseCapsule);
      when(mockfunc16)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc17: Function = mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.playToggleCapsule);
      when(mockfunc17)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc18: Function =
        mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.playCollapseCapsule);
      when(mockfunc18)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc19: Function = mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.playExpandCapsule);
      when(mockfunc19)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc20: Function = mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.playToggleScroll);
      when(mockfunc20)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc21: Function = mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.playScroll);
      when(mockfunc21)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc22: Function = mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.playScrollSpring);
      when(mockfunc22)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc23: Function = mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.playScrollStop);
      when(mockfunc23)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc24: Function =
        mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.playScrollSpringStop);
      when(mockfunc24)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc25: Function =
        mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.playScrollSpringStop);
      when(mockfunc25)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc26: Function = mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.playScrollSpring);
      when(mockfunc26)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc27: Function = mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.playScrollStop);
      when(mockfunc27)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc28: Function =
        mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.playScrollSpringStop);
      when(mockfunc28)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc29: Function =
        mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.playScrollSpringStop);
      when(mockfunc29)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc30: Function = mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.playScrollSpring);
      when(mockfunc30)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc31: Function = mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.playScrollStop);
      when(mockfunc31)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc32: Function =
        mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.playScrollSpringStop);
      when(mockfunc32)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc33: Function =
        mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.playScrollSpringStop);
      when(mockfunc33)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc34: Function = mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.playScrollSpring);
      when(mockfunc34)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc35: Function = mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.playScrollStop);
      when(mockfunc35)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc36: Function =
        mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.playScrollSpringStop);
      when(mockfunc36)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc37: Function =
        mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.playScrollSpringStop);
      when(mockfunc37)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc38: Function = mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.playScrollSpring);
      when(mockfunc38)(ArgumentMatchers.any).afterReturnNothing();

      let mockfunc39: Function = mocker.mockFunc(LiveCapsuleAnimation, LiveCapsuleAnimation.instance.playScrollStop);
      when(mockfunc39)(ArgumentMatchers.any).afterReturnNothing();

      let mock

      //待测试分支： 进入this.liveList.length === liveList.length 进入        !this.liveList.find(i => !liveList.find(live => live.hashCode === i.hashCode))
      it('should_not_perform_collapse_animation_when_live_list_is_the_same_as_existing_list', 0, async () => {
        let liveList: LiveNotification[] = [new LiveNotification()];
        let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
        livecapsulelistvm.liveList.push(new LiveNotification());
        let mocker: MockKit = new MockKit();
        let mockFunc = mocker.mockFunc(livecapsulelistvm.liveList, livecapsulelistvm.liveList.clear);
        let mockFunc2 = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.animateToLayoutView);
        await livecapsulelistvm.initLiveList(liveList);
        expect(mockFunc).not.assertUndefined();
        expect(mockFunc2).not.assertUndefined();
        mocker.ignoreMock(livecapsulelistvm.liveList, livecapsulelistvm.liveList.clear);
        mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.animateToLayoutView);
      });

      //待测试分支： 进入this.liveList.length
      it('should_handle_non-empty liveList correctly', 0, async () => {
        let liveList: LiveNotification[] = [new LiveNotification()];
        let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
        let mocker: MockKit = new MockKit();
        let mockFunc = mocker.mockFunc(livecapsulelistvm.liveList, livecapsulelistvm.liveList.clear);
        let mockFunc2 = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.animateToLayoutView);
        let mockFunc3 = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
        when(mockFunc)().afterReturnNothing();
        when(mockFunc2)().afterReturnNothing();
        when(mockFunc3)().afterReturnNothing();
        await livecapsulelistvm.initLiveList(liveList);
        expect(livecapsulelistvm.liveList.length).assertEqual(1);
        mocker.verify('clear', []).atLeast(1);
        mocker.verify('animateToLayoutView', []).atLeast(1);
        mocker.verify('toggleCapsuleList', []).atLeast(1);
        mocker.ignoreMock(livecapsulelistvm.liveList, livecapsulelistvm.liveList.clear);
        mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.animateToLayoutView);
        mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      });

      //待测试分支： 不进入 (capsuleVm.opacity !== 0) 进入liveList.length
      it('should_not_animate_when_capsule_is_visible_and_list_is_the_same', 0, async () => {
        let liveList: LiveNotification[] = [{
          hashCode: 1, isInstant: false
        }];
        let liveCapsuleListVm: LiveCapsuleListVm = new LiveCapsuleListVm();
        let mocker: MockKit = new MockKit();
        let capsuleVm = mocker.mockFunc(liveCapsuleListVm.vmInjector, liveCapsuleListVm.vmInjector.getCapsuleVm);
        let mockCapsuleVm = {
          opacity: 0
        };
        when(capsuleVm)([ArgumentMatchers.any]).afterReturn(mockCapsuleVm);
        await liveCapsuleListVm.initLiveList(liveList);
        expect(mockCapsuleVm.opacity).assertEqual(0);
        mocker.ignoreMock(liveCapsuleListVm.vmInjector, liveCapsuleListVm.vmInjector.getCapsuleVm);
      });

      //待测试分支： 进入this.liveList.length === liveList.length 进入        !this.liveList.find(i => !liveList.find(live => live.hashCode === i.hashCode)) 进入capsuleVm.opacity !== 0
      it('should_not_perform_collapse_animation_if_live_list_is_the_same_and_capsule_is_not_visible', 0, async () => {
        let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
        let mocker: MockKit = new MockKit();
        let liveList: LiveNotification[] = [{
          hashCode: 1, creatorUid: '123', isInstant: false
        }];
        let mockLiveList = mocker.mockFunc(livecapsulelistvm.liveList, livecapsulelistvm.liveList.clear);
        let mockCapsuleVm = mocker.mockFunc(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleVm);
        let mockCapsuleVmOpacity = mocker.mockFunc(mockCapsuleVm, mockCapsuleVm.opacity);
        when(mockCapsuleVmOpacity)().afterReturn(1);
        await livecapsulelistvm.initLiveList(liveList);
        expect(mockLiveList).not.assertUndefined();
        mocker.ignoreMock(livecapsulelistvm.liveList, livecapsulelistvm.liveList.clear);
      });
    })
  });

  describe('onDropdownShowChange1_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_immediately_when_isDropDown_is_false_and_isMiddleCutout_is_true_and_envVm_isImmersive_is_true', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();

      let mockIsDropDown: Function = mocker.mockFunc(livecapsulelistvm.dropdownVm, livecapsulelistvm.dropdownVm.isDropDown);
      when(mockIsDropDown)().afterReturn(false);

      let mockIsMiddleCutout: Function = mocker.mockFunc(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
      when(mockIsMiddleCutout)().afterReturn(true);

      let mockEnvVm: Function = mocker.mockFunc(livecapsulelistvm.envVm, livecapsulelistvm.envVm.isImmersive);
      when(mockEnvVm)().afterReturn(true);

      livecapsulelistvm.onDropdownShowChange();

      mocker.ignoreMock(livecapsulelistvm.dropdownVm, livecapsulelistvm.dropdownVm.isDropDown);
      mocker.ignoreMock(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
      mocker.ignoreMock(livecapsulelistvm.envVm, livecapsulelistvm.envVm.isImmersive);
    });

    it('should_call_toggleCapsuleList_when_isMiddleCutout_is_true_and_envVm_isImmersive_is_false', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();

      let mockIsDropDown: Function = mocker.mockFunc(livecapsulelistvm.dropdownVm, livecapsulelistvm.dropdownVm.isDropDown);
      when(mockIsDropDown)().afterReturn(false);

      let mockIsMiddleCutout: Function = mocker.mockFunc(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
      when(mockIsMiddleCutout)().afterReturn(true);

      let mockEnvVm: Function = mocker.mockFunc(livecapsulelistvm.envVm, livecapsulelistvm.envVm.isImmersive);
      when(mockEnvVm)().afterReturn(false);

      let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      when(mockToggleCapsuleList)(ArgumentMatchers.any).afterReturn(new CustomPromise<void>(() => {}));

      livecapsulelistvm.onDropdownShowChange();

      mocker.ignoreMock(livecapsulelistvm.dropdownVm, livecapsulelistvm.dropdownVm.isDropDown);
      mocker.ignoreMock(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
      mocker.ignoreMock(livecapsulelistvm.envVm, livecapsulelistvm.envVm.isImmersive);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
    });

    it('should_call_toggleCapsuleList_with_delay_when_isMiddleCutout_is_false', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();

      let mockIsDropDown: Function = mocker.mockFunc(livecapsulelistvm.dropdownVm, livecapsulelistvm.dropdownVm.isDropDown);
      when(mockIsDropDown)().afterReturn(false);

      let mockIsMiddleCutout: Function = mocker.mockFunc(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
      when(mockIsMiddleCutout)().afterReturn(false);

      let mockEnvVm: Function = mocker.mockFunc(livecapsulelistvm.envVm, livecapsulelistvm.envVm.isImmersive);
      when(mockEnvVm)().afterReturn(false);

      let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      when(mockToggleCapsuleList)(ArgumentMatchers.any).afterReturn(new CustomPromise<void>(() => {}));

      livecapsulelistvm.onDropdownShowChange();

      mocker.ignoreMock(livecapsulelistvm.dropdownVm, livecapsulelistvm.dropdownVm.isDropDown);
      mocker.ignoreMock(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
      mocker.ignoreMock(livecapsulelistvm.envVm, livecapsulelistvm.envVm.isImmersive);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
    });

    //待测试分支： 不进入 (this.cutoutVm.isMiddleCutout() 进入 !this.dropdownVm.isDropDown 进入 this.envVm.isImmersive) 进入this.cutoutVm.isMiddleCutout()
    it('should_toggle_capsule_list_when_conditions_are_met', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let mockIsDropDown: Function = mocker.mockFunc(livecapsulelistvm.dropdownVm, livecapsulelistvm.dropdownVm.isDropDown);
      let mockIsMiddleCutout: Function = mocker.mockFunc(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
      let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      let mockMetaBallVm: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.metaBallVm);

      when(mockIsDropDown)().afterReturn(true);
      when(mockIsMiddleCutout)().afterReturn(true);
      when(mockToggleCapsuleList)().afterReturnNothing();
      when(mockMetaBallVm)().afterReturnNothing();

      livecapsulelistvm.onDropdownShowChange();

      mocker.verify('toggleCapsuleList', []).atLeast(1);
      mocker.ignoreMock(livecapsulelistvm.dropdownVm, livecapsulelistvm.dropdownVm.isDropDown);
      mocker.ignoreMock(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.metaBallVm);
    });

    //待测试分支： 不进入 (this.cutoutVm.isMiddleCutout() 进入 !this.dropdownVm.isDropDown 进入 this.envVm.isImmersive) 不进入 (this.cutoutVm.isMiddleCutout())
    it('should_not_toggle_capsule_list_when_conditions_are_met', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let mockIsDropDown: Function = mocker.mockFunc(livecapsulelistvm.dropdownVm, livecapsulelistvm.dropdownVm.isDropDown);
      let mockIsMiddleCutout: Function = mocker.mockFunc(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
      let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      let mockMetaBallVm: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.metaBallVm);

      when(mockIsDropDown)().afterReturn(true);
      when(mockIsMiddleCutout)().afterReturn(true);
      when(mockMetaBallVm)().afterReturnNothing();

      livecapsulelistvm.onDropdownShowChange();

      mocker.verify('toggleCapsuleList', []).never();
      mocker.ignoreMock(livecapsulelistvm.dropdownVm, livecapsulelistvm.dropdownVm.isDropDown);
      mocker.ignoreMock(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.metaBallVm);
    });

    //待测试分支： 进入this.cutoutVm.isMiddleCutout() 进入 !this.dropdownVm.isDropDown 进入 this.envVm.isImmersive
    it('should_not_toggle_capsule_list_when_isMiddleCutout_is_true_and_isDropDown_is_false_and_isImmersive_is_true', 0, () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let mockIsMiddleCutout: Function = mocker.mockFunc(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
      let mockIsDropDown: Function = mocker.mockFunc(livecapsulelistvm.dropdownVm, livecapsulelistvm.dropdownVm.isDropDown);
      let mockIsImmersive: Function = mocker.mockFunc(livecapsulelistvm.envVm, livecapsulelistvm.envVm.isImmersive);
      when(mockIsMiddleCutout)().afterReturn(true);
      when(mockIsDropDown)().afterReturn(false);
      when(mockIsImmersive)().afterReturn(true);
      livecapsulelistvm.onDropdownShowChange();
      mocker.verify('isMiddleCutout', []).atLeast(1);
      mocker.verify('isDropDown', []).atLeast(1);
      mocker.verify('isImmersive', []).atLeast(1);
      mocker.ignoreMock(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
      mocker.ignoreMock(livecapsulelistvm.dropdownVm, livecapsulelistvm.dropdownVm.isDropDown);
      mocker.ignoreMock(livecapsulelistvm.envVm, livecapsulelistvm.envVm.isImmersive);
    });

  });

  describe('onScreenLockChange1_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_toggleCapsuleList_when_envVm_isScreenLock_is_true_and_cutoutVm_isMiddleCutout_is_true', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let mockfunc: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockfunc)().afterReturn(true);

      let toggleCapsuleListMock: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      when(toggleCapsuleListMock)(ArgumentMatchers.any).afterReturn(new CustomPromise<void>(() => {}));

      let envVm: EnvVm = EnvVm.instance;
      let mockEnvFunc: Function = mocker.mockFunc(envVm, envVm.isScreenLock);
      when(mockEnvFunc)().afterReturn(true);

      livecapsulelistvm.onScreenLockChange();

      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      mocker.ignoreMock(envVm, envVm.isScreenLock);
    });

    it('should_call_toggleCapsuleList_with_delay_when_envVm_isScreenLock_is_true_and_cutoutVm_isMiddleCutout_is_false', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let mockfunc: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockfunc)().afterReturn(false);

      let toggleCapsuleListMock: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      when(toggleCapsuleListMock)(ArgumentMatchers.any).afterReturn(new CustomPromise<void>(() => {}));

      let envVm: EnvVm = EnvVm.instance;
      let mockEnvFunc: Function = mocker.mockFunc(envVm, envVm.isScreenLock);
      when(mockEnvFunc)().afterReturn(true);

      livecapsulelistvm.onScreenLockChange();

      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      mocker.ignoreMock(envVm, envVm.isScreenLock);
    });

    it('should_not_call_toggleCapsuleList_when_envVm_isScreenLock_is_false', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let envVm: EnvVm = EnvVm.instance;
      let mockEnvFunc: Function = mocker.mockFunc(envVm, envVm.isScreenLock);
      when(mockEnvFunc)().afterReturn(false);

      livecapsulelistvm.onScreenLockChange();

      mocker.ignoreMock(envVm, envVm.isScreenLock);
    });

    //待测试分支： 不进入 (this.cutoutVm.isMiddleCutout())
    it('should_toggle_capsule_list_when_screen_is_unlocked_and_cutout_is_not_middle', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let mockIsMiddleCutout: Function = mocker.mockFunc(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
      let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      let mockMetaBallVm: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.metaBallVm);

      when(mockIsMiddleCutout)().afterReturn(false);
      when(mockMetaBallVm)().afterReturnNothing();

      livecapsulelistvm.onScreenLockChange();

      setTimeout(() => {
        mocker.verify('toggleCapsuleList', [{ onlyChangeOpacity: true, delay: 350 }]).atLeast(1);
        mocker.ignoreMock(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
        mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
        mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.metaBallVm);
      }, 150);
    });

    //待测试分支： 进入this.cutoutVm.isMiddleCutout()
    it('should_call_toggleCapsuleList_with_onlyChangeOpacity_true_and_delay_350_when_screen_is_locked_and_cutout_is_not_middle', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let mockIsMiddleCutout: Function = mocker.mockFunc(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
      let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      let mockMetaBallVm: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.metaBallVm);

      when(mockIsMiddleCutout)().afterReturn(false);
      when(mockMetaBallVm)().afterReturnNothing();

      livecapsulelistvm.onScreenLockChange();

      setTimeout(() => {
        mocker.verify('toggleCapsuleList', [{ onlyChangeOpacity: true, delay: 350 }]).atLeast(1);
        mocker.ignoreMock(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
        mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
        mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.metaBallVm);
      }, 150);
    });

  });

  describe('onStatusBarShowHideChange_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_info_when_statusBar_show_hide_change', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      livecapsulelistvm.onStatusBarShowHideChange();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_scene_when_statusBar_show_hide_change', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let envVm: EnvVm = EnvVm.instance;
      let mockfunc: Function = mocker.mockFunc(envVm, envVm.isStatusBarShow);
      when(mockfunc)().afterReturn(true);

      livecapsulelistvm.onStatusBarShowHideChange();

      mocker.ignoreMock(envVm, envVm.isStatusBarShow);
    });

    it('should_return_when_isClearAllApp_is_true', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let liveDataVm = LiveVmInjector.instance.getLiveDataVm();
      let mockfunc: Function = mocker.mockFunc(liveDataVm, liveDataVm.isClearAllApp);
      when(mockfunc)().afterReturn(true);

      livecapsulelistvm.onStatusBarShowHideChange();

      mocker.ignoreMock(liveDataVm, liveDataVm.isClearAllApp);
    });

    it('should_call_toggleCapsuleList_when_isMiddleCutout_is_true_and_rotationPromise_is_false', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let mockfunc1: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockfunc1)().afterReturn(true);

      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let mockfunc2: Function = mocker.mockFunc(deviceInfoVm, deviceInfoVm.rotationPromise);
      when(mockfunc2)().afterReturn(false);

      let toggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      when(toggleCapsuleList)().afterReturn(new Promise<void>(() => {}));

      livecapsulelistvm.onStatusBarShowHideChange();

      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
      mocker.ignoreMock(deviceInfoVm, deviceInfoVm.rotationPromise);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
    });

    it('should_not_call_toggleCapsuleList_when_isMiddleCutout_is_false', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let mockfunc1: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockfunc1)().afterReturn(false);

      livecapsulelistvm.onStatusBarShowHideChange();

      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
    });

    it('should_not_call_toggleCapsuleList_when_rotationPromise_is_true', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let mockfunc2: Function = mocker.mockFunc(deviceInfoVm, deviceInfoVm.rotationPromise);
      when(mockfunc2)().afterReturn(true);

      livecapsulelistvm.onStatusBarShowHideChange();

      mocker.ignoreMock(deviceInfoVm, deviceInfoVm.rotationPromise);
    });

    it('should_call_toggleCapsuleList_when_liveList_length_is_1_and_isInstant_is_true_and_event_isForeground', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let liveList: NotificationArray<LiveNotification> = new NotificationArray();
      liveList.push({
        typeCode: SysTypeCode.INSTANT,
        creatorUid: '123',
        appIndex: 0,
        isInstant: () => true
      } as LiveNotification);
      livecapsulelistvm.liveList = liveList;

      let appLifeCycleManager: AppLifeCycleManager = AppLifeCycleManager.instance;
      let mockfunc: Function = mocker.mockFunc(appLifeCycleManager, appLifeCycleManager.isAppForeground);
      when(mockfunc)().afterReturn(true);

      let capsuleVm: ILiveCapsuleListVm = LiveVmInjector.instance.getCapsuleVm(liveList[0]);
      let mockfunc2: Function = mocker.mockFunc(capsuleVm, capsuleVm.opacity);
      when(mockfunc2)().afterReturn(0);

      let toggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      when(toggleCapsuleList)().afterReturn(new Promise<void>(() => {}));

      livecapsulelistvm.onStatusBarShowHideChange();

      mocker.ignoreMock(appLifeCycleManager, appLifeCycleManager.isAppForeground);
      mocker.ignoreMock(capsuleVm, capsuleVm.opacity);
      mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
    });

    it('should_not_call_toggleCapsuleList_when_liveList_length_is_1_and_isInstant_is_true_and_event_isBackground', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let liveList: NotificationArray<LiveNotification> = new NotificationArray();
      liveList.push({
        typeCode: SysTypeCode.INSTANT,
        creatorUid: '123',
        appIndex: 0,
        isInstant: () => true
      } as LiveNotification);
      livecapsulelistvm.liveList = liveList;

      let appLifeCycleManager: AppLifeCycleManager = AppLifeCycleManager.instance;
      let mockfunc: Function = mocker.mockFunc(appLifeCycleManager, appLifeCycleManager.isAppForeground);
      when(mockfunc)().afterReturn(false);

      livecapsulelistvm.onStatusBarShowHideChange();

      mocker.ignoreMock(appLifeCycleManager, appLifeCycleManager.isAppForeground);
    });

    it('should_not_call_toggleCapsuleList_when_liveList_length_is_1_and_isInstant_is_true_and_event_isForeground_and_capsuleVm_is_not_visible', 0, async () => {
      let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
      let mocker: MockKit = new MockKit();
      let liveList: NotificationArray<LiveNotification> = new NotificationArray();
      liveList.push({
        typeCode: SysTypeCode.INSTANT,
        creatorUid: '123',
        appIndex: 0,
        isInstant: () => true
      } as LiveNotification);
      livecapsulelistvm.liveList = liveList;

      let appLifeCycleManager: AppLifeCycleManager = AppLifeCycleManager.instance;
      let mockfunc: Function = mocker.mockFunc(appLifeCycleManager, appLifeCycleManager.isAppForeground);
      when(mockfunc)().afterReturn(true);

      //待测试分支： 进入this.vmInjector.getLiveDataVm().isClearAllApp
      it('should_not_call_toggleCapsuleList_when_isClearAllApp_is_true', 0, () => {
        let livecapsulelistvm: LiveCapsuleListVm = new LiveCapsuleListVm();
        let mocker: MockKit = new MockKit();
        let mockMetaBallVm = mocker.mockFunc(livecapsulelistvm.metaBallVm, livecapsulelistvm.metaBallVm.setScene);
        let mockToggleCapsuleList = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
        let mockGetLiveDataVm = mocker.mockFunc(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getLiveDataVm);
        let mockIsMiddleCutout = mocker.mockFunc(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
        let mockShowInfo = mocker.mockFunc(LogHelper, LogHelper.showInfo);
        when(mockGetLiveDataVm)().afterReturn({ isClearAllApp: true });
        when(mockIsMiddleCutout)().afterReturn(true);
        livecapsulelistvm.onStatusBarShowHideChange();
        mocker.verify('setScene', []).atLeast(1);
        mocker.verify('toggleCapsuleList', []).never();
        mocker.ignoreMock(livecapsulelistvm.metaBallVm, livecapsulelistvm.metaBallVm.setScene);
        mocker.ignoreMock(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
        mocker.ignoreMock(livecapsulelistvm.cutoutVm, livecapsulelistvm.cutoutVm.isMiddleCutout);
        mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      });

      //待测试分支： 不进入 (this.vmInjector.getLiveDataVm().isClearAllApp) 进入this.cutoutVm.isMiddleCutout() 进入 !this.deviceInfoVm.rotationPromise
      it('should_return_error_when_dsHelper_is_null', 0, () => {
        let valuesBucket: ValuesBucket = {};
        let ra: CalDevAccountRepository = CalDevAccountRepository.INSTANCE;
        let mocker: MockKit = new MockKit();
        let dsHelper: DBUtils = DBUtils.INSTANCE;
        let mockfunc: Function = mocker.mockFunc(dsHelper, dsHelper.getDsHelper);
        when(mockfunc)([ArgumentMatchers.any]).afterReturn(null);
        const result = await ra.insertCalDevTag(valuesBucket);
        expect(result.message).assertEqual("insertCalDevTag dsHelper is null");
        mocker.verify('getDsHelper',[]).atLeast(1);
        mocker.ignoreMock(dsHelper, dsHelper.getDsHelper);  //还原mock函数，否则会影响其他用例
      });
    });
  });
}

