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
import { ILiveVmInjector } from './interface/ILiveVmInjector';
import { LiveNotification } from './model/LiveNotification';
import { LiveItemBaseVm } from './vm/LiveBaseVm';
import { ILiveCardSystemVm } from './interface/ILiveCardSystemVm';
import { ILiveCardSystemProgressVm } from './interface/ILiveCardSystemProgressVm';
import { LiveHeadsUpWalletCardVm } from './vm/LiveHeadsUpWalletCardVm';
import { ILiveHeadsUpWalletCardVm } from './interface/ILiveHeadsUpWalletCardVm';
import { ILiveCardSystemButtonVm } from './interface/ILiveCardSystemButtonVm';
import { ILiveTimerVm } from './interface/ILiveTimerVm';
import { ILiveCardOtherVm } from './interface/ILiveCardOtherVm';
import { BaseVmInjector } from '../vm/BaseVmInjector';
import { ILiveCapsuleListVm } from './interface/ILiveCapsuleListVm';
import { ILiveCapsuleVm } from './interface/ILiveCapsuleVm';
import { LiveCapsuleListVm } from './vm/LiveCapsuleListVm';
import { SystemUIUseScene } from '../constants/SystemuiConstants';
import { ILiveCapsuleMarqueeVm } from './interface/ILiveCapsuleMarqueeVm';
import { LiveCapsuleMarqueeVm } from './vm/LiveCapsuleMarqueeVm';
import { LiveCapsuleVm } from './vm/LiveCapsuleVm';
import { LiveTimerVm } from './vm/LiveTimerVm';
import { ILiveCardListVm } from './interface/ILiveCardListVm';
import { LiveCardListVm } from './vm/LiveCardListVm';
import { LiveCardOtherVm } from './vm/LiveCardOtherVm';
import { LiveCardSystemProgressVm } from './vm/LiveCardSystemProgressVm';
import { LiveCardSystemButtonVm } from './vm/LiveCardSystemButtonVm';
import { LiveCardSystemVm } from './vm/LiveCardSystemVm';
import { LiveCardListItemVm } from './vm/LiveCardListItemVm';
import { ILiveCardFloatingVm } from './interface/ILiveCardFloatingVm';
import { LiveCardFloatingVm } from './vm/LiveCardFloatingVm';
import { ILiveCardListItemVm } from './interface/ILiveCardListItemVm';
import { ILiveSwitchVm } from './interface/ILiveSwitchVm';
import { LiveSwitchVm } from './vm/LiveSwitchVm';
import { ILiveCardNavigationVm } from './interface/ILiveCardNavigationVm';
import { ILiveCardAuthorizationVm } from './interface/ILiveCardAuthorizationVm';
import { LiveCardNavigationVm } from './vm/LiveCardNavigationVm';
import { LiveCardAuthorizationVm } from './vm/LiveCardAuthorizationVm';
import { LiveCapsulePhoneCallVm } from './vm/LiveCapsulePhoneCallVm';
import { LiveCapsuleScreenRecordVm } from './vm/LiveCapsuleScreenRecordVm';
import { ILiveCardOtherProgressVm } from './interface/ILiveCardOtherProgressVm';
import { LiveCardOtherProgressVm } from './vm/LiveCardOtherProgressVm';
import { ILiveCardOtherExtendVm } from './interface/ILiveCardOtherExtendVm';
import { LiveCardOtherExtendVm } from './vm/LiveCardOtherExtendVm';
import { ILiveCardMenuVm } from './interface/ILiveCardMenuVm';
import { LiveCardMenuVm } from './vm/LiveCardMenuVm';
import { ILiveCapsuleWaveVm } from './interface/ILiveCapsuleWaveVm';
import { LiveCapsuleWaveVm } from './vm/LiveCapsuleWaveVm';
import { ILiveCapsuleLightWaveVm } from './interface/ILiveCapsuleLightWaveVm';
import { LiveCapsuleLightWaveVm } from './vm/LiveCapsuleLightWaveVm';
import { ILiveCapsuleListAnimVm } from './interface/ILiveCapsuleListAnimVm';
import { ILiveDataVm } from './interface/ILiveDataVm';
import { LiveDataVm } from './vm/LiveDataVm';
import { ILiveMetaBallVm } from './interface/ILiveMetaBallVm';
import { ILiveCapsuleListLayoutVm } from './interface/ILiveCapsuleLayoutVm';
import { ILiveStarterVm } from './interface/ILiveStarterVm';
import { LiveStarterVm } from './vm/LiveStarterVm';
import { LiveVmFactory } from './vm/LiveVmFactory';
import { ILiveActionButtonVm } from './interface/ILiveActionButtonVm';
import { LiveActionButtonVm } from './vm/LiveActionButtonVm';
import { ILiveCardOtherFlightVm } from './interface/ILiveCardOtherFlightVm';
import { LiveCardOtherFlightVm } from './vm/LiveCardOtherFlightVm';
import { ILiveRemindVm } from './interface/ILiveRemindVm';
import { LiveRemindVm } from './vm/LiveRemindVm';
import { LiveMediaPlayerVm } from './vm/LiveMediaPlayerVm';
import { ILiveMediaPlayerVm } from './interface/ILiveMediaPlayerVm';
import { ILiveMetaBallVisibleVm } from './interface/ILiveMetaBallVisibleVm';
import { LiveMetaBallVisibleVm } from './vm/LiveMetaBallVisibleVm';
import { ILiveHeadsUpVm } from './interface/ILiveHeadsUpVm';
import { ILiveHeadsUpCommonCardVm } from './interface/ILiveHeadsUpCommonCardVm';
import { LiveHeadsUpCommonCardVm } from './vm/LiveHeadsUpCommonCardVm';
import { LiveHeadsUpVm } from './vm/LiveHeadsUpVm';
import { LiveHeadsUpSwipeVm } from './vm/LiveHeadsUpSwipeVm';
import { ILiveHeadsUpSwipeVm } from './interface/ILiveHeadsUpSwipeVm';
import { LiveCapsuleLifecycleVm } from './vm/LiveCapsuleLifecycleVm';
import { ILiveCapsuleLifecycleVm } from './interface/ILiveCapsuleLifecycleVm';
import { ICapsuleKeepShowingVm } from './interface/ICapsuleKeepShowingVm';
import { CapsuleKeepShowingVm } from './vm/CapsuleKeepShowingVm';
import { LiveHeadsUpFaceLockVm } from './vm/LiveHeadsUpFaceLockVm';
import { ILiveHeadsUpFaceLockVm } from './interface/ILiveHeadsUpFaceLockVm';
import { ILiveCardOtherPickupVm } from './interface/ILiveCardOtherPickupVm';
import { LiveCardOtherPickupVm } from './vm/LiveCardOtherPickupVm';
import { ILiveCardOtherScoreVm } from './interface/ILiveCardOtherScoreVm';
import { LiveCardOtherScoreVm } from './vm/LiveCardOtherScoreVm';
import lazy { LiveCapsuleFaceLockVm } from './vm/LiveCapsuleFaceLockVm';
import lazy { ILiveCapsuleFaceLockVm } from './interface/ILiveCapsuleFaceLockVm';
import { NotificationDataManager } from '../manager/NotificationDataManager';

const TAG = 'LiveVmInjector';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 实况VM注入器
 */
export class LiveVmInjector extends BaseVmInjector implements ILiveVmInjector {
  /**
   * 空的占位符，用于赋值给装饰@Consumer的变量，解决@Consumer必须指定初始值的问题
   */
  public static readonly HOLDER = 0 as Object as LiveVmInjector;

  protected liveVmFactory = new LiveVmFactory();

  public readonly scene: SystemUIUseScene = SystemUIUseScene.LIVE;

  /**
   * 实况数据管理
   * @returns
   */
  public getLiveDataVm(): ILiveDataVm {
    return this.getVm(LiveDataVm.name, () => new LiveDataVm(this));
  }

  /**
   * 获取胶囊列表VM
   * @returns
   */
  public getCapsuleListVm(): ILiveCapsuleListVm {
    return this.getVm(LiveCapsuleListVm.name, () => new LiveCapsuleListVm(this));
  }

  /**
   * 获取胶囊VM
   * @returns
   */
  public getCapsuleVm(live: LiveNotification): ILiveCapsuleVm {
    if (live.isScreenRecorder()) {
      return this.getVm(this.getKey(LiveCapsuleScreenRecordVm, live), () => new LiveCapsuleScreenRecordVm(this, live));
    }
    if (live.isPhoneCall()) {
      return this.getVm(this.getKey(LiveCapsulePhoneCallVm, live), () => new LiveCapsulePhoneCallVm(this, live));
    }
    return this.getVm(this.getKey(LiveCapsuleVm, live), () => new LiveCapsuleVm(this, live));
  }

  /**
   * 获取胶囊跑马灯VM
   * @param live 实况数据
   * @returns
   */
  public getCapsuleMarqueeVm(live: LiveNotification): ILiveCapsuleMarqueeVm {
    return this.getVm(this.getKey(LiveCapsuleMarqueeVm, live), () => new LiveCapsuleMarqueeVm(this, live));
  }

  /**
   * 获取实况卡片列表VM
   * @returns
   */
  public getCardListVm(): ILiveCardListVm {
    return this.getVm(LiveCardListVm.name, () => new LiveCardListVm(this));
  }

  /**
   * 获取实况卡片VM
   * @returns
   */
  public getCardListItemVm(live: LiveNotification): ILiveCardListItemVm {
    return this.getVm(this.getKey(LiveCardListItemVm, live), () => new LiveCardListItemVm(this, live));
  }

  /**
   * 获取实况卡片菜单VM
   * @param live
   * @returns
   */
  public getCardMenuVm(live: LiveNotification): ILiveCardMenuVm {
    return this.getVm(this.getKey(LiveCardMenuVm, live), () => new LiveCardMenuVm(this, live));
  }

  /**
   * 获取实况卡片滑动VM
   * @param live
   * @returns
   */
  public getLiveHeadsUpSwipeVm(live: LiveNotification): ILiveHeadsUpSwipeVm {
    return this.getVm(this.getKey(LiveHeadsUpSwipeVm, live), () => new LiveHeadsUpSwipeVm(this, live));
  }

  /**
   * 获取实况横幅悬浮窗VM
   * @param live
   * @returns
   */
  public getCardFloatingVm(live: LiveNotification): ILiveCardFloatingVm {
    return this.getVm(this.getKey(LiveCardFloatingVm, live), () => new LiveCardFloatingVm(this, live));
  }

  /**
   * 获取系统实况卡片VM
   * @param live
   * @returns
   */
  public getCardSystemVm(live: LiveNotification): ILiveCardSystemVm {
    return this.getVm(this.getKey(LiveCardSystemVm, live), () => new LiveCardSystemVm(this, live));
  }

  /**
   * 获取系统实况进度环VM
   * @param live
   * @returns
   */
  public getCardSystemProgressVm(live: LiveNotification): ILiveCardSystemProgressVm {
    return this.getVm(this.getKey(LiveCardSystemProgressVm, live), () => new LiveCardSystemProgressVm(this, live));
  }

  /**
   * 获取系统实况按钮VM
   * @param live
   * @returns
   */
  public getCardSystemButtonVm(live: LiveNotification): ILiveCardSystemButtonVm {
    return this.getVm(this.getKey(LiveCardSystemButtonVm, live), () => new LiveCardSystemButtonVm(this, live));
  }

  /**
   * 获取实况计时器VM
   * @returns
   */
  public getTimerVm(): ILiveTimerVm {
    return LiveTimerVm.instance;
  }

  /**
   * 获取三方实况卡片VM
   * @param live
   * @returns
   */
  public getCardOtherVm(live: LiveNotification): ILiveCardOtherVm {
    return this.getVm(this.getKey(LiveCardOtherVm, live), () => new LiveCardOtherVm(this, live));
  }

  /**
   * 获取三方实况左右拓展区卡片VM
   * @param live
   * @returns
   */
  public getCardOtherFlightVm(live: LiveNotification): ILiveCardOtherFlightVm {
    return this.getVm(this.getKey(LiveCardOtherFlightVm, live), () => new LiveCardOtherFlightVm(this, live));
  }

  /**
   * 获取三方实况取餐卡片VM
   * @param live
   * @returns
   */
  public getCardOtherPickupVm(live: LiveNotification): ILiveCardOtherPickupVm {
    return this.getVm(this.getKey(LiveCardOtherPickupVm, live), () => new LiveCardOtherPickupVm(this, live));
  }

  /**
   * 获取三方实况比分卡片VM
   * @param live
   * @returns
   */
  public getCardOtherScoreVm(live: LiveNotification): ILiveCardOtherScoreVm {
    return this.getVm(this.getKey(LiveCardOtherScoreVm, live), () => new LiveCardOtherScoreVm(this, live));
  }

  /**
   * 获取三方实况卡片扩展区进度VM
   * @param live
   * @returns
   */
  public getCardOtherProgressVm(live: LiveNotification): ILiveCardOtherProgressVm {
    return this.getVm(this.getKey(LiveCardOtherProgressVm, live), () => new LiveCardOtherProgressVm(this, live));
  }

  /**
   * 获取胶囊和卡片切换VM
   * @returns
   */
  public getSwitchVm(): ILiveSwitchVm {
    return this.getVm(LiveSwitchVm.name, () => new LiveSwitchVm(this));
  }

  /**
   * 获取导航卡片
   * @param live
   * @returns
   */
  public getCardNavigationVm(live: LiveNotification): ILiveCardNavigationVm {
    return this.getVm(this.getKey(LiveCardNavigationVm, live), () => new LiveCardNavigationVm(this, live));
  }

  /**
   * 获取卡片授权信息
   * @param live
   * @returns
   */
  public getCardAuthorizationVm(live: LiveNotification): ILiveCardAuthorizationVm {
    return this.getVm(this.getKey(LiveCardAuthorizationVm, live), () => new LiveCardAuthorizationVm(this, live));
  }

  /**
   * 获取三方实况卡片辅助区VM
   * @param live
   * @returns
   */
  public getCardOtherExtendVm(live: LiveNotification): ILiveCardOtherExtendVm {
    return this.getVm(this.getKey(LiveCardOtherExtendVm, live), () => new LiveCardOtherExtendVm(this, live));
  }

  /**
   * 获取进度类扫光动效组件VM
   */
  public getCapsuleWaveVm(live: LiveNotification): ILiveCapsuleWaveVm {
    return this.getVm(this.getKey(LiveCapsuleWaveVm, live), () => new LiveCapsuleWaveVm(this, live));
  }

  /**
   * 获取扫光动效组件VM
   */
  getCapsuleLightWaveVm(live: LiveNotification): ILiveCapsuleLightWaveVm {
    const key = this.getKey(LiveCapsuleLightWaveVm, live) + '_left'
    return this.getVm(key, () => new LiveCapsuleLightWaveVm(this, live));
  }

  getCapsuleRightLightWaveVm(live: LiveNotification): ILiveCapsuleLightWaveVm {
    const key = this.getKey(LiveCapsuleLightWaveVm, live) + '_right'
    return this.getVm(key, () => new LiveCapsuleLightWaveVm(this, live));
  }

  /**
   * 实况按钮vm
   * @param live
   * @returns
   */
  public getLiveActionButtonVm(live: LiveNotification): ILiveActionButtonVm {
    return this.getVm(this.getKey(LiveActionButtonVm, live), () => new LiveActionButtonVm(this, live));
  }

  /**
   * 获取胶囊列表布局VM
   * @returns
   */
  public getCapsuleListLayoutVm(): ILiveCapsuleListLayoutVm {
    const vmKey = 'CapsuleListLayoutVm';
    const capsuleListLayoutVmName = this.liveVmFactory.getCapsuleListLayoutVmNameByCutoutVm();
    if (!this.hasVm(vmKey)) {
      return this.getVm(vmKey, () => this.liveVmFactory.createCapsuleListLayoutVm(capsuleListLayoutVmName, this));
    } else {
      let currentVm = this.getCacheVm(vmKey) as ILiveCapsuleListLayoutVm;
      if (currentVm.constructor.name === capsuleListLayoutVmName) {
        return currentVm;
      } else {
        const newVm = this.liveVmFactory.createCapsuleListLayoutVm(capsuleListLayoutVmName, this);
        this.setVm(vmKey, newVm);
        return newVm;
      }
    }
  }

  /**
   * 获取胶囊状态动效控制VM
   */
  public getCapsuleListAnimVm(): ILiveCapsuleListAnimVm {
    const vmKey = 'CapsuleListAnimVm';
    const capsuleListAnimVmName = this.liveVmFactory.getCapsuleListAnimVmNameByCutoutVm();
    if (!this.hasVm(vmKey)) {
      return this.getVm(vmKey, () => this.liveVmFactory.createCapsuleListAnimVm(capsuleListAnimVmName, this));
    } else {
      let currentVm = this.getCacheVm(vmKey) as ILiveCapsuleListAnimVm;
      if (currentVm.constructor.name === capsuleListAnimVmName) {
        return currentVm;
      } else {
        const newVm = this.liveVmFactory.createCapsuleListAnimVm(capsuleListAnimVmName, this);
        this.setVm(vmKey, newVm);
        return newVm;
      }
    }
  }

  /**
   * 获取融球VM
   * @returns
   */
  public getMetaBallVm(): ILiveMetaBallVm {
    const vmKey = 'liveMetaBallVm';
    const metaBallVmName = this.liveVmFactory.getMetaBallVmNameByCutoutVm();
    if (!this.hasVm(vmKey)) {
      return this.getVm(vmKey, () => this.liveVmFactory.createMetaBallVm(metaBallVmName, this));
    } else {
      let currentVm = this.getCacheVm(vmKey) as ILiveMetaBallVm;
      if (currentVm.constructor.name === metaBallVmName) {
        return currentVm;
      } else {
        const newVm = this.liveVmFactory.createMetaBallVm(metaBallVmName, this);
        newVm.updateProperty(currentVm); // 融球vm切换时需同步状态变量，保持前后一致
        this.setVm(vmKey, newVm);
        return newVm;
      }
    }
  }

  public getMetaBallVisibleVm(): ILiveMetaBallVisibleVm {
    return this.getVm(LiveMetaBallVisibleVm.name, () => new LiveMetaBallVisibleVm(this));
  }

  /**
   * 获取实况拉起wantAgent的vm
   * @returns
   */
  public getStarterVm(): ILiveStarterVm {
    return this.getVm(LiveStarterVm.name, () => new LiveStarterVm(this));
  }

  /**
   * 获取横幅实况Vm
   * @returns
   */
  public getLiveHeadsUpVm(): ILiveHeadsUpVm {
    return this.getVm(LiveHeadsUpVm.name, () => new LiveHeadsUpVm(this));
  }

  /**
   * 获取实况横幅通用卡片VM
   * @returns
   */
  public getLiveHeadsUpCommonCardVm(): ILiveHeadsUpCommonCardVm {
    return this.getVm(LiveHeadsUpCommonCardVm.name, () => new LiveHeadsUpCommonCardVm(this));
  }

  /**
   * 获取实况横幅钱包卡片VM
   * @returns
   */
  public getLiveHeadsUpWalletCardVm(): ILiveHeadsUpWalletCardVm {
    return this.getVm(LiveHeadsUpWalletCardVm.name, () => new LiveHeadsUpWalletCardVm(this));
  }

  /**
   * 获取实况人脸解锁VM
   * @returns
   */
  public getLiveHeadsUpFaceLockVm(): ILiveHeadsUpFaceLockVm {
    return this.getVm(LiveHeadsUpFaceLockVm.name, () => new LiveHeadsUpFaceLockVm(this));
  }

  /**
   * 获取抢占场景VM
   */
  public getLiveRemindVm(): ILiveRemindVm {
    return this.getVm(LiveRemindVm.name, () => new LiveRemindVm(this));
  }

  /**
   * 获取播控VM
   * @returns
   */
  public getLiveMediaPlayerVm(live: LiveNotification): ILiveMediaPlayerVm {
    return this.getVm(this.getKey(LiveMediaPlayerVm, live), () => new LiveMediaPlayerVm(this, live));
  }

  /**
   * 获取人脸认证胶囊VM
   * @returns
   */
  public getLiveCapsuleFaceLockVm(live: LiveNotification): ILiveCapsuleFaceLockVm {
    return this.getVm(this.getKey(LiveCapsuleFaceLockVm, live), () => new LiveCapsuleFaceLockVm(this, live));
  }

  /**
   * 获取胶囊生命周期VM
   * @returns
   */
  public getCapsuleLifecycleVm(): ILiveCapsuleLifecycleVm {
    return this.getVm(LiveCapsuleLifecycleVm.name, () => new LiveCapsuleLifecycleVm(this));
  }

  /**
   * 获取通知VM的key
   * @param vmClass
   * @param live
   * @returns
   */
  protected getKey(vmClass: Function, live: LiveNotification): string {
    return `[${live.key}]${vmClass.name}`;
  }

  protected onCreateVm(vm: Object): void {
    if (vm instanceof LiveItemBaseVm) {
      vm.init();
    }
  }

  /**
   * 清理某个通知对应的所有VM
   * @param live
   * @Param isUpdateToDelete 是否更新删除场景
   */
  public deleteVmByLive(live: LiveNotification, isUpdateToDelete?: boolean): void {
    this.foreachVm((vm, key) => {
      if (key.startsWith(`[${live.key}]`)) {
        if (vm instanceof LiveItemBaseVm) {
          vm.destroy();
        }
        if (isUpdateToDelete) {
          this.deleteVm(key);
        }
      }
    });
    if (!isUpdateToDelete) {
      setTimeout(() => {
        this.foreachVm((vm, key) => {
          if (key.startsWith(`[${live.key}]`)) {
            this.deleteVm(key);
          }
        });
      }, 3000);
    }
  }

  /**
   * 更新某个实况对应的所有VM的数据
   * @param live
   */
  public updateVmByLive(live: LiveNotification, scene?: string): void {
    log.showInfo(`updateVmByLive: ${scene}, hash: ${live.key}, uid: ${live.uid}`);
    this.foreachVm((vm, key) => {
      if (key.startsWith(`[${live.key}]`) && vm instanceof LiveItemBaseVm) {
        vm.onUpdate(live);
      }
    });
  }

  /**
   * 胶囊显示接续管理类
   */
  public getCapsuleKeepShowingVm(): ICapsuleKeepShowingVm {
    return this.getVm(CapsuleKeepShowingVm.name, () => new CapsuleKeepShowingVm(this));
  }

  // 获取异常前10层的调用栈
  protected getErrorStack(error: Error, limit: number = 10): string {
    const stack = error.stack || '';
    const lines = stack.split('\n');
    if (lines.length <= 1) {
      return stack;
    }
    const stackLines = lines.slice(1, limit + 1);

    // 重新组合并返回
    return [lines[0], ...stackLines].join('\n');
  }

  protected isVmPossibleLeak(vm: Object): boolean {
    if (!(vm instanceof LiveItemBaseVm)) {
      return false;
    }
    return NotificationDataManager.instance.ntfMap.get(vm.live.hashCode)?.key !== vm.live.key;
  }
}