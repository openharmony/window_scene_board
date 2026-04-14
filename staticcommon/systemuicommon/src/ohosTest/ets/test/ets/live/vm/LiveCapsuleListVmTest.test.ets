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

      let mockGetCapsuleVm: Function =
        mocker.mockFunc(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isToDelete: false,
        opacity: 0,
        isVisible: false,
        layoutInfo: new LiveCapsuleLayoutInfo(),
        scene: LiveStyle.SCENE_DEFAULT,
        showType: CapsuleShowType.DEFAULT,
        toggleCapsule: () => {
        }
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      let mockGetCapsuleLifecycleVm: Function =
        mocker.mockFunc(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleLifecycleVm);
      let mockCapsuleLifecycleVm: ILiveCapsuleLifecycleVm = {
        getCapsuleShowTime: (id: string) => 0,
        deleteLifecycleInfo: (id: string) => {
        }
      };
      when(mockGetCapsuleLifecycleVm)().afterReturn(mockCapsuleLifecycleVm);

      let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      when(mockToggleCapsuleList)([]).afterReturn(new Promise<void>(() => {
      }));

      let mockRemove: Function = mocker.mockFunc(livecapsulelistvm.liveList, livecapsulelistvm.liveList.remove);
      when(mockRemove)(ArgumentMatchers.anyString).afterReturn(new Promise<void>(() => {
      }));

      let mockLiveHiSysEventReport: Function = mocker.mockFunc(LiveHiSysEvent, LiveHiSysEvent.reportLiveLifeCycleEvent);
      when(mockLiveHiSysEventReport)(ArgumentMatchers.any).afterReturn(new Promise<void>(() => {
      }));

      let mockRemimdVm: MockKit = new MockKit();
      let mockRemimdVmFunc: Function =
        mocker.mockFunc(livecapsulelistvm.remindVm, livecapsulelistvm.remindVm.isCurrentRemindCapsule);
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

      let mockGetCapsuleVm: Function =
        mocker.mockFunc(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isToDelete: false,
        opacity: 0,
        isVisible: false,
        layoutInfo: new LiveCapsuleLayoutInfo(),
        scene: LiveStyle.SCENE_DEFAULT,
        showType: CapsuleShowType.DEFAULT,
        toggleCapsule: () => {
        }
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      let mockGetCapsuleLifecycleVm: Function =
        mocker.mockFunc(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleLifecycleVm);
      let mockCapsuleLifecycleVm: ILiveCapsuleLifecycleVm = {
        getCapsuleShowTime: (id: string) => 0,
        deleteLifecycleInfo: (id: string) => {
        }
      };
      when(mockGetCapsuleLifecycleVm)().afterReturn(mockCapsuleLifecycleVm);

      let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      when(mockToggleCapsuleList)([]).afterReturn(new Promise<void>(() => {
      }));

      let mockRemove: Function = mocker.mockFunc(livecapsulelistvm.liveList, livecapsulelistvm.liveList.remove);
      when(mockRemove)(ArgumentMatchers.anyString).afterReturn(new Promise<void>(() => {
      }));

      let mockLiveHiSysEventReport: Function = mocker.mockFunc(LiveHiSysEvent, LiveHiSysEvent.reportLiveLifeCycleEvent);
      when(mockLiveHiSysEventReport)(ArgumentMatchers.any).afterReturn(new Promise<void>(() => {
      }));

      let mockRemimdVm: MockKit = new MockKit();
      let mockRemimdVmFunc: Function =
        mocker.mockFunc(livecapsulelistvm.remindVm, livecapsulelistvm.remindVm.isCurrentRemindCapsule);
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

      let mockGetCapsuleVm: Function =
        mocker.mockFunc(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleVm);
      let mockCapsuleVm: ILiveCapsuleVm = {
        isToDelete: false,
        opacity: 0,
        isVisible: false,
        layoutInfo: new LiveCapsuleLayoutInfo(),
        scene: LiveStyle.SCENE_DEFAULT,
        showType: CapsuleShowType.DEFAULT,
        toggleCapsule: () => {
        }
      };
      when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

      let mockGetCapsuleLifecycleVm: Function =
        mocker.mockFunc(livecapsulelistvm.vmInjector, livecapsulelistvm.vmInjector.getCapsuleLifecycleVm);
      let mockCapsuleLifecycleVm: ILiveCapsuleLifecycleVm = {
        getCapsuleShowTime: (id: string) => 0,
        deleteLifecycleInfo: (id: string) => {
        }
      };
      when(mockGetCapsuleLifecycleVm)().afterReturn(mockCapsuleLifecycleVm);

      let mockToggleCapsuleList: Function = mocker.mockFunc(livecapsulelistvm, livecapsulelistvm.toggleCapsuleList);
      when(mockToggleCapsuleList)([]).afterReturn(new Promise<void>(() => {
      }));

      let mockRemove: Function = mocker.mockFunc(livecapsulelistvm.liveList, livecapsulelistvm.liveList.remove);
      when(mockRemove)(ArgumentMatchers.anyString).afterReturn(new Promise<void>(() => {
      }));

      let mockLiveHiSysEventReport: Function = mocker.mockFunc(LiveHiSysEvent, LiveHiSysEvent.reportLiveLifeCycleEvent);
      when(mockLiveHiSysEventReport)(ArgumentMatchers.any).afterReturn(new Promise<void>(() => {
      }));

      let mockRemimdVm: MockKit = new MockKit();
      let mockRemimdVmFunc: Function =
        mocker.mockFunc(livecapsulelistvm.remindVm, livecapsulelistvm.remindVm.isCurrentRemindCapsule);
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
  })
}