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
import { BannerPanelType } from '../../banner/common/info/BannerState';
import { AppLifeCycleManager } from '../../manager/AppLifeCycleManager';
import { BannerVm } from '../../vm/BannerVm';
import { DeviceInfoVm } from '../../vm/DeviceInfoVm';
import { DropdownVm } from '../../vm/DropdownVm';
import { EnvVm } from '../../vm/EnvVm';
import { ILiveRemindVm } from '../interface/ILiveRemindVm';
import { LiveMetaBallScene } from '../model/LiveCommonModel';
import { LiveNotification } from '../model/LiveNotification';
import { LiveBaseVm } from './LiveBaseVm';

@ObservedV2
export class LiveRemindVm extends LiveBaseVm implements ILiveRemindVm {
  public dropdownVm = DropdownVm.instance;
  public envVm = EnvVm.instance;
  public bannerVm = BannerVm.instance;
  public deviceVm = DeviceInfoVm.instance;

  private remindCapsule?: LiveNotification;

  getCurrentRemindCapsule(): LiveNotification | undefined {
    return this.remindCapsule;
  }

  setRemindCapsule(live: LiveNotification): void {
    this.remindCapsule = live;
    const metaBallVm = this.vmInjector.getMetaBallVm();
    metaBallVm.setScene(LiveMetaBallScene.REMIND, true);
  }

  clearRemindCapsule(): void {
    this.remindCapsule = undefined;
    const metaBallVm = this.vmInjector.getMetaBallVm();
    metaBallVm.setScene(LiveMetaBallScene.REMIND, false);
  }

  isCurrentRemindCapsule(live: LiveNotification): boolean {
    return this.remindCapsule?.hashCode === live.hashCode;
  }

  checkAddCapsuleScene(live: LiveNotification): void {
    if (!live.isInstant()) {
      return;
    }

    if (this.deviceVm.isEmergencyMode()) {
      const capsuleVm = this.vmInjector.getCapsuleVm(live);
      capsuleVm.isShowed = true;
      return;
    }

    this.setRemindCapsule(live);
  }

  checkUpdateCapsuleScene(live: LiveNotification): void {
    if (!live.isFlip()) {
      return;
    }

    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    if (this.deviceVm.isEmergencyMode()) {
      capsuleVm.isShowed = true;
      return;
    }

    if (this.dropdownVm.isDropDown) {
      capsuleVm.isShowed = true;
      return;
    }

    if (this.bannerVm.isHideCapsule()) {
      capsuleVm.isShowed = true;
      return;
    }

    if (this.vmInjector.getLiveHeadsUpVm().headsUpNtfHashCode === live.hashCode) {
      capsuleVm.isShowed = true;
      return;
    }

    if (this.isShowOnScreenLock()) {
      capsuleVm.isShowed = true;
      return;
    }

    if (AppLifeCycleManager.instance.isForeground(live.creatorUid, live) && !live.capsule?.sticky) {
      capsuleVm.isShowed = true;
      return;
    }

    this.setRemindCapsule(live);
  }

  checkCurrentRemindScene(): void {
    const live = this.getCurrentRemindCapsule();
    if (live) {
      if (this.deviceVm.isEmergencyMode()) {
        this.clearRemindCapsule();
        return;
      }

      if (live.isInstant()) {
        const capsuleVm = this.vmInjector.getCapsuleVm(live);
        if (capsuleVm.isToDelete) {
          this.clearRemindCapsule();
        }
        return;
      }

      if (live.isFlip()) {
        if (this.dropdownVm.isDropDown) {
          this.clearRemindCapsule();
          return;
        }

        if (this.bannerVm.isHideCapsule()) {
          this.clearRemindCapsule();
          return;
        }

        if (this.vmInjector.getLiveHeadsUpVm().headsUpNtfHashCode === live.hashCode) {
          this.clearRemindCapsule();
          return;
        }

        if (this.isShowOnScreenLock()) {
          this.clearRemindCapsule();
          return;
        }

        if (AppLifeCycleManager.instance.isForeground(live.creatorUid, live) && !live.capsule?.sticky) {
          this.clearRemindCapsule();
          return;
        }

        // 当前处于横幅面板同时胶囊正在FLIP动效
        const capsuleVm = this.vmInjector.getCapsuleVm(live);
        if (this.bannerVm.bannerType === BannerPanelType.TYPE_LIVE_HEADS_UP && capsuleVm.isRemindShow) {
          this.clearRemindCapsule();
          return;
        }
      }
    }
  }

  /**
   * 小外屏锁屏界面会显示胶囊，需要保证小外屏锁屏界面正常设置抢占胶囊
   * @returns 当前是否在锁屏界面
   */
  protected isShowOnScreenLock(): boolean {
    return this.envVm.isScreenLock
  }
}