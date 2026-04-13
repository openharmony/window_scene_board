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
import { bannerMgr } from '@ohos/systemuicommon';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { LiveCardListView } from '@ohos/systemuicommon/src/main/ets/live/view/LiveCardListView';
import { LiveHeadsUpView } from '@ohos/systemuicommon/src/main/ets/live/view/LiveHeadsUpView';
import { BannerPanelTypeState } from '@ohos/systemuicommon';
import { LiveCardMediaPlayerView, LiveCardMediaPlayerBuilderParam, BannerVm, EnvVm } from '@ohos/systemuicommon/newIndex';
import { MediaPlaybackControllerItem } from '@ohos/mediacontrolcomponent/src/main/ets/default/pages/components/MediaPlaybackControllerItem';
import { NotificationBannerView } from '@ohos/notificationcomponent/src/main/ets/view/NotificationBannerView';
import { sharedData } from '@ohos/systemuicommon/Index';
import { ISlStateChangeListener, SlMainStateType,
  SlStaticStateType, SlSubStateType, slUiStateMgr } from '@ohos/screenlockcommon';
import { SnapshotType, SystemUIColorVm } from '@ohos/systemuicommon/src/main/ets/vm/SystemUIColorVm';

const TAG = 'BannerPanelView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@Builder
function mediaPlayerBuilder(param: LiveCardMediaPlayerBuilderParam) {
  MediaPlaybackControllerItem({
    notifyId: param.notifyId,
    isNotificationFromDeviceChange: param.isNotificationFromDeviceChange,
    isScreenLock: param.isScreenLock,
    groupKey: param.groupKey,
    scene: param.scene,
    itemData: undefined,
    onIconClickV2: param.onItemClick
  })
}

/**
 * Banner面板内容
 */
@Component
export struct BannerPanelView {
  /**
   * banner面板当前面板类型
   */
  @State @Watch('onPanelTypeChange') bannerPanelType: BannerPanelTypeState = bannerMgr.getBannerState().bannerPanelType;

  private systemUIColorVm: SystemUIColorVm = SystemUIColorVm.instance;

  private onScreenLockStateChange: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_STATIC_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      if (subType === SlStaticStateType.SL_SECURE_LOCKED_STATE) {
        this.updateSecureAndLockedFlag();
        return;
      }
    }
  };

  aboutToAppear() {
    log.showInfo(`aboutToAppear ${sharedData.bannerPersistentId}`);
    bannerMgr.updatePersistentId(sharedData.bannerPersistentId);
    bannerMgr.appear(this.getUIContext());
    LiveCardMediaPlayerView.setBuilder(wrapBuilder(mediaPlayerBuilder));
    slUiStateMgr.registerSlStateChangeListener(this.onScreenLockStateChange);
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisAppear`);
    bannerMgr.disappear();
    slUiStateMgr.unregisterSlStateChangeListener(this.onScreenLockStateChange);
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      // 实况列表
      LiveCardListView()
      // 实况横幅
      LiveHeadsUpView()
      // 普通通知横幅
      NotificationBannerView({
        screenId: sharedData.bannerScreenId,
        persistentId: sharedData.bannerPersistentId,
      })
    }
    .id(TAG)
  }

  onPanelTypeChange(): void {
    BannerVm.instance.setBannerType(this.bannerPanelType.bannerPanelType, this.bannerPanelType.secondaryPanelType);
    if (this.bannerPanelType.isPanelHeadsUp()) {
      this.systemUIColorVm.getAverageColor(SnapshotType.Banner);
    } else if (this.bannerPanelType.isPanelLiveHeadsUp()) {
      this.systemUIColorVm.getAverageColor(SnapshotType.LiveBanner);
    } else if (this.bannerPanelType.isPanelLiveList()) {
      this.systemUIColorVm.getAverageColor(SnapshotType.LiveList);
    }
  }

  private updateSecureAndLockedFlag() {
    EnvVm.instance.isSecureAndLocked = slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE)
    ?.getSlState(SlStaticStateType.SL_SECURE_LOCKED_STATE) as boolean ?? false;
    log.showInfo(`update lock status flag: ${EnvVm.instance.isSecureAndLocked}`);
  }
}