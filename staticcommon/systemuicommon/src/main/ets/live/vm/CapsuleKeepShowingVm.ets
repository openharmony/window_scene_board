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

import { obtainLocalEvent, sEventManager, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { BannerPanelType } from '../../banner/common/info/BannerState';
import { bannerMgr } from '../../banner/phone/BannerManager';
import { StatusBarEventType } from '../../event/StatusBarEvent';
import { scbStatusBarStatusManager } from '../../statusbar/ScbStatusBarStatusManager';
import { BannerVm } from '../../vm/BannerVm';
import { DropdownVm } from '../../vm/DropdownVm';
import { EnvVm } from '../../vm/EnvVm';
import { ICapsuleKeepShowingVm } from '../interface/ICapsuleKeepShowingVm';
import { LiveBaseVm } from './LiveBaseVm';
import { LiveNotification } from '../model/LiveNotification';
import { HandleType } from '../../liveview/common/LiveConstants';
import { WindowAdapter } from '../../adapter/WindowAdapter';
import { AppLifeCycleManager } from '../../manager/AppLifeCycleManager';

/**
 * 将胶囊创建/更新/抢占，呼出状态栏 并保持常亮功能，抽取为单独的管理vm
 */
@ObservedV2
export class CapsuleKeepShowingVm extends LiveBaseVm implements ICapsuleKeepShowingVm {
  /**
   * 沉浸式下状态栏要展示的时长
   */
  public readonly KEEP_SHOWING_TIME = 3500;

  private needAnimation: boolean = true;
  /**
   * 用来设置/重置状态栏使能变量的定时器id
   */
  private keepShowingTimerId?: number;
  private dropdownVm = DropdownVm.instance;
  private bannerVm = BannerVm.instance;
  private envVm = EnvVm.instance;

  public async checkAndStartKeepShowing(live: LiveNotification, handleType: HandleType): Promise<void> {
    // 新增类型 & 新胶囊不是即时类型 & 存在抢占胶囊，不需要清除定时器
    if (handleType === HandleType.ADD && !live.isInstant() &&
    this.vmInjector.getLiveRemindVm().getCurrentRemindCapsule()) {
      return;
    }
    if (this.envVm.isScreenLock && this.envVm.isImmersive && !live.isInstant()) {
      // 锁屏、沉浸式状态栏、非即时胶囊，不呼出状态栏
      return;
    }
    // 应用在前台&&非即时，不需要呼出状态栏
    if (AppLifeCycleManager.instance.isForeground(live.creatorUid) && !live.isInstant()) {
      return;
    }
    if (this.envVm.isImmersive) {
      scbStatusBarStatusManager.setNeedStatusBarKeepShowing(live.isFlip() || live.isInstant());
      this.clearDelayTimer(this.keepShowingTimerId);
    }
    this.needAnimation = true;

    if (!(await WindowAdapter.isViewShowing(ViewType.STATUS_BAR))) {
      this.needAnimation = false;
    }
  }

  public getNeedAnimation(): boolean {
    return this.needAnimation;
  }

  public setNeedAnimation(needAnimation: boolean): void {
    this.needAnimation = needAnimation;
  }

  /**
   * 抢占态的胶囊要一开始就设置，不然旋转接续后，没有地方关闭标记
   * @param isRemindCapsule 是否抢占态胶囊
   * @param delayTime
   */
  public startKeepShowingTimer(live: LiveNotification, isRemindCapsule: boolean = false,
    handleType: HandleType, delayTime?: number): void {
    if (handleType === HandleType.ADD && !isRemindCapsule &&
    this.vmInjector.getLiveRemindVm().getCurrentRemindCapsule()) {
      return;
    }
    if (this.envVm.isScreenLock && this.envVm.isImmersive && !isRemindCapsule) {
      // 锁屏、沉浸式状态栏、非及时胶囊，不呼出状态栏
      return
    }
    if (!isRemindCapsule && !this.envVm.isImmersive) {
      return;
    }
    // 应用在前台&&非即时，不需要呼出状态栏
    if (AppLifeCycleManager.instance.isForeground(live.creatorUid) && !live.isInstant()) {
      return;
    }
    if (!delayTime) {
      delayTime = this.KEEP_SHOWING_TIME;
    }
    this.clearDelayTimer(this.keepShowingTimerId);
    this.keepShowingTimerId = setTimeout(() => {
      this.clearDelayTimer(this.keepShowingTimerId);
      scbStatusBarStatusManager.setNeedStatusBarKeepShowing(false);
      // 下拉面板或者呼出实况卡片或横幅卡片存在时状态状态栏要常驻，不用隐藏状态栏
      if (!this.dropdownVm.isDropDown && this.bannerVm.bannerType !== BannerPanelType.TYPE_LIVE_LIST &&
        this.bannerVm.bannerType !== BannerPanelType.TYPE_LIVE_HEADS_UP) {
        sEventManager.publish(obtainLocalEvent(StatusBarEventType.STATUS_BAR_HIDE, true));
      }
    }, bannerMgr.getBannerState().bannerPanelType.bannerPanelType === BannerPanelType.TYPE_LIVE_LIST ? 0 : delayTime);
  }

  private clearDelayTimer($$?: number): void {
    clearTimeout($$);
    $$ = undefined;
  }
}