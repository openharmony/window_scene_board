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
import { SystemUIUseScene } from '../../../constants/SystemuiConstants';
import { LiveViewShowAuthEvent, NotificationEvent } from '../../../event/NotificationEvent';
import { InnerEventUtil } from '../../../utils/InnerEventUtil';
import { Singleton } from '../../../utils/Singleton';
import { ILiveCardAuthorizationVm } from '../../interface/ILiveCardAuthorizationVm';
import { ILiveCardNavigationVm } from '../../interface/ILiveCardNavigationVm';
import { ILiveCardOtherExtendVm } from '../../interface/ILiveCardOtherExtendVm';
import { ILiveCardOtherFlightVm } from '../../interface/ILiveCardOtherFlightVm';
import { ILiveCardOtherVm } from '../../interface/ILiveCardOtherVm';
import { ILiveCardSystemVm } from '../../interface/ILiveCardSystemVm';
import { LiveVmInjector } from '../../LiveVmInjector';
import { LiveNotification } from '../../model/LiveNotification';
import { LiveCardAuthorizationDropdownVm } from './vm/LiveCardAuthorizationDropdownVm';
import { LiveCardNavigationDropdownVm } from './vm/LiveCardNavigationDropdownVm';
import { LiveCardOtherDropdownVm } from './vm/LiveCardOtherDropdownVm';
import { LiveCardOtherExtendDropdownVm } from './vm/LiveCardOtherExtendDropdownVm';
import { LiveCardOtherFlightDropdownVm } from './vm/LiveCardOtherFlightDropdownVm';
import { LiveCardSystemDropdownVm } from './vm/LiveCardSystemDropdownVm';
import { TaskQueue, TaskItem } from '../../../utils/TaskQueue';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ILiveCardSystemButtonVm } from '../../interface/ILiveCardSystemButtonVm';
import { LiveCardSystemButtonDropdownVm } from './vm/LiveCardSystemButtonDropdownVm';
import { ILiveCardOtherProgressVm } from '../../interface/ILiveCardOtherProgressVm';
import { LiveCardOtherProgressDropdownVm } from './vm/LiveCardOtherProgressDropdownVm';
import { ILiveSwitchVm } from '../../interface/ILiveSwitchVm';
import { LiveSwitchDropdownVm } from './vm/LiveSwitchDropdownVm';
import { LiveActionButtonDropdownVm } from './vm/LiveActionButtonDropdownVm';
import { ILiveActionButtonVm } from '../../interface/ILiveActionButtonVm';
import { ILiveCardSystemProgressVm } from '../../interface/ILiveCardSystemProgressVm';
import { LiveCardSystemProgressDropdownVm } from './vm/LiveCardSystemProgressDropdownVm';

const TAG = 'LiveDropdownVmInjector';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 通知中心面板实况VM注入器
 */
@ObservedV2
export class LiveDropdownVmInjector extends LiveVmInjector {
  /**
   * 空的占位符，用于赋值给装饰@Consumer的变量，解决@Consumer必须指定初始值的问题
   */
  public static readonly HOLDER = 0 as Object as LiveDropdownVmInjector;
  public readonly scene: SystemUIUseScene = SystemUIUseScene.DROPDOWN;

  @Trace public liveMap: Map<string, LiveNotification> = new Map();
  protected taskQueue = new TaskQueue(TAG, 1);
  protected enableDelayDeleteVm: boolean = true;

  /**
   * 单例
   * @returns
   */
  @Singleton.decorate()
  static get instance() {
    return new LiveDropdownVmInjector();
  }

  /**
   * 获取导航卡片
   * @param live
   * @returns
   */
  public getCardNavigationVm(live: LiveNotification): ILiveCardNavigationVm {
    return this.getVm(this.getKey(LiveCardNavigationDropdownVm, live),
      () => new LiveCardNavigationDropdownVm(this, live));
  }

  /**
   * 获取三方实况卡片VM
   * @param live
   * @returns
   */
  public getCardOtherVm(live: LiveNotification): ILiveCardOtherVm {
    return this.getVm(this.getKey(LiveCardOtherDropdownVm, live), () => new LiveCardOtherDropdownVm(this, live));
  }

  /**
   * 获取三方实况左右拓展区卡片VM
   * @param live
   * @returns
   */
  public getCardOtherFlightVm(live: LiveNotification): ILiveCardOtherFlightVm {
    return this.getVm(this.getKey(LiveCardOtherFlightDropdownVm, live),
      () => new LiveCardOtherFlightDropdownVm(this, live));
  }

  /**
   * 获取三方实况卡片扩展区进度VM
   * @param live
   * @returns
   */
  public getCardOtherProgressVm(live: LiveNotification): ILiveCardOtherProgressVm {
    return this.getVm(this.getKey(LiveCardOtherProgressDropdownVm, live),
      () => new LiveCardOtherProgressDropdownVm(this, live));
  }

  /**
   * 获取系统实况卡片VM
   * @param live
   * @returns
   */
  public getCardSystemVm(live: LiveNotification): ILiveCardSystemVm {
    return this.getVm(this.getKey(LiveCardSystemDropdownVm, live), () => new LiveCardSystemDropdownVm(this, live));
  }

  /**
   * 获取三方实况卡片辅助区VM
   * @param live
   * @returns
   */
  public getCardOtherExtendVm(live: LiveNotification): ILiveCardOtherExtendVm {
    return this.getVm(this.getKey(LiveCardOtherExtendDropdownVm, live),
      () => new LiveCardOtherExtendDropdownVm(this, live));
  }

  /**
   * 实况关联服务按钮vm
   * @param live
   * @returns
   */
  public getLiveActionButtonVm(live: LiveNotification): ILiveActionButtonVm {
    return this.getVm(this.getKey(LiveActionButtonDropdownVm, live), () => new LiveActionButtonDropdownVm(this, live));
  }

  /**
   * 获取卡片授权信息
   * @param live
   * @returns
   */
  public getCardAuthorizationVm(live: LiveNotification): ILiveCardAuthorizationVm {
    return this.getVm(this.getKey(LiveCardAuthorizationDropdownVm, live),
      () => new LiveCardAuthorizationDropdownVm(this, live));
  }

  /**
   * 获取系统实况按钮VM
   * @param live
   * @returns
   */
  public getCardSystemButtonVm(live: LiveNotification): ILiveCardSystemButtonVm {
    return this.getVm(this.getKey(LiveCardSystemButtonDropdownVm, live),
      () => new LiveCardSystemButtonDropdownVm(this, live));
  }

  /**
   * 获取系统实况进度环VM
   * @param live
   * @returns
   */
  public getCardSystemProgressVm(live: LiveNotification): ILiveCardSystemProgressVm {
    return this.getVm(this.getKey(LiveCardSystemProgressDropdownVm, live),
      () => new LiveCardSystemProgressDropdownVm(this, live));
  }

  /**
   * 获取胶囊和卡片切换VM
   * @returns
   */
  public getSwitchVm(): ILiveSwitchVm {
    return this.getVm(LiveSwitchDropdownVm.name, () => new LiveSwitchDropdownVm(this));
  }

  public init(): void {
    log.showInfo(`init`)
    InnerEventUtil.on(NotificationEvent, this.onNotificationEvent);
    InnerEventUtil.on(LiveViewShowAuthEvent, this.onUpdateAuth);
  }

  protected onNotificationEvent = (event: NotificationEvent): void => {
    let liveList = event.notificationList.filter((ntf) => ntf.isLiveView()) as LiveNotification[];
    if (!liveList.length) {
      return;
    }

    log.showInfo(`Recieve live event: ${event.eventType}, live length: ${liveList.length}`);
    if (event.eventType === NotificationEvent.EVENT_TYPE_INIT) {
      this.taskQueue.add(new TaskItem('onInit', () => this.onInit(liveList)));
    } else if (event.eventType === NotificationEvent.EVENT_TYPE_ADD) {
      this.taskQueue.add(new TaskItem('onAdd', () => this.onAdd(liveList)));
    } else if (event.eventType === NotificationEvent.EVENT_TYPE_UPDATE) {
      this.taskQueue.add(new TaskItem('onUpdate', () => this.onUpdate(liveList)));
    } else if (event.eventType === NotificationEvent.EVENT_TYPE_REMOVE) {
      this.taskQueue.add(new TaskItem('onRemove', () => this.onRemove(liveList)));
    }
  };

  onInit(liveList: LiveNotification[]): void {
    for (const live of liveList) {
      this.liveMap.set(live.hashCode, live);
    }
  }

  onAdd(liveList: LiveNotification[]): void {
    for (const live of liveList) {
      this.liveMap.set(live.hashCode, live);
    }
  }

  onUpdate(liveList: LiveNotification[]): void {
    for (const live of liveList) {
      this.liveMap.set(live.hashCode, live);
      this.updateVmByLive(live, TAG);
    }
  }

  private onUpdateAuth = (event: LiveViewShowAuthEvent): void => {
    const live = this.liveMap.get(event.hashCode);
    // 更新实况授权点击信息
    if (live && live.card.isOtherCard()) {
      live.card.isShowAuthorization = false;
      this.liveMap.set(live.hashCode, live);
      log.showInfo('UpdateAuth: isShowAuthorization false');
      this.getCardAuthorizationVm(live).isShowAuthorizationZone = false;
    }
  }

  async onRemove(liveList: LiveNotification[]): Promise<void> {
    for (const live of liveList) {
      this.liveMap.delete(live.hashCode);
      this.deleteVmByLive(live);
    }
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
}