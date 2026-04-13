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
import { SystemUICommonUtil } from '@ohos/systemuicommon';
import { Singleton } from '@ohos/systemuicommon/newTsIndex';
import { NotificationEvent } from '@ohos/systemuicommon/src/main/ets/event/NotificationEvent';
import { ILiveCardListItemVm } from '@ohos/systemuicommon/src/main/ets/live/interface/ILiveCardListItemVm';
import { LiveNotification } from '@ohos/systemuicommon/src/main/ets/live/model/LiveNotification';
import { LiveDropdownVmInjector } from '@ohos/systemuicommon/src/main/ets/live/variant/dropdown/LiveDropdownVmInjector';
import { LiveTimerVm } from '@ohos/systemuicommon/src/main/ets/live/vm/LiveTimerVm';
import { InnerEventUtil } from '@ohos/systemuicommon/src/main/ets/utils/InnerEventUtil';
import { TaskItem, TaskQueue } from '@ohos/systemuicommon/src/main/ets/utils/TaskQueue';
import { BannerLiveCardListItemVm } from './BannerLiveCardListItemVm';

const TAG = 'NotificationBannerLiveVmInjector';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class NotificationBannerLiveVmInjector extends LiveDropdownVmInjector {
  /**
   * 单例
   * @returns
   */
  @Singleton.decorate()
  static get instance() {
    return new NotificationBannerLiveVmInjector();
  }
  /**
   * 所有实况数据全集
   */
  public liveMap: Map<string, LiveNotification> = new Map();

  protected taskQueue = new TaskQueue(TAG, 1);
  protected timerVm = LiveTimerVm.instance;

  constructor() {
    super();

    // 监听实况通知，处理实况横幅的timer
    InnerEventUtil.on(NotificationEvent, this.onNotificationEvent);
  }


  protected onNotificationEvent = (event: NotificationEvent): void => {
    const liveList = event.notificationList.filter(
      (ntf) => ntf.isLiveView() && !ntf.isConvertFromNormal && !ntf.isInstantBanner()) as LiveNotification[];
    log.showInfo(`Recieve live event: ${event.eventType}, isBatch: ${event.isBatch}, live length: ${liveList.length}`);

    if (event.eventType === NotificationEvent.EVENT_TYPE_INIT) {
      this.taskQueue.add(new TaskItem('onInit', () => this.onInit(liveList)));
    } else if (event.eventType === NotificationEvent.EVENT_TYPE_ADD) {
      this.taskQueue.add(new TaskItem('onAdd', () => this.onAdd(liveList)));
    } else if (event.eventType === NotificationEvent.EVENT_TYPE_UPDATE) {
      this.taskQueue.add(new TaskItem('onBatchUpdate', () => this.onUpdate(liveList)));
    } else if (event.eventType === NotificationEvent.EVENT_TYPE_REMOVE) {
      this.taskQueue.add(new TaskItem('onRemove', () => this.onRemove(liveList)));
    }
  };

  /**
   * 初始化
   * @param liveList
   */
  onInit(liveList: LiveNotification[]): void {
    this.liveMap.clear();
    this.timerVm.clearTimer();
    for (const live of liveList) {
      log.showInfo(`Add live for ${live.hashCode}`);
      this.liveMap.set(live.hashCode, live);
      this.timerVm.setLiveTimer(live);
    }
  }

  /**
   * 新增
   * @param live
   */
  onAdd(liveList: LiveNotification[]): void {
    for (const live of liveList) {
      this.liveMap.set(live.hashCode, live);
      this.timerVm.setLiveTimer(live);
      this.updateVmByLive(live);
    }
  }

  /**
   * 更新
   * @param liveList
   */
  onUpdate(liveList: LiveNotification[]): void {
    for (const live of liveList) {
      const oldLive = this.liveMap.get(live.hashCode);
      if (oldLive) {
        log.showInfo(`Update live for ${live.hashCode}`);
        this.timerVm.updateLiveTimer(live, oldLive);
        this.liveMap.set(live.hashCode, live);
        this.updateVmByLive(live);
      }
    }
  }

  /**
   * 删除
   * @param liveList
   * @returns
   */
  async onRemove(liveList: LiveNotification[]): Promise<void> {
    // 等待卡片删除动画执行结束再删除数据
    await SystemUICommonUtil.sleep(300);

    for (const live of liveList) {
      log.showInfo(`Remove live for ${live.hashCode}`);
      this.liveMap.delete(live.hashCode);
      this.timerVm.deleteLiveTimer(live);
    }
  }

  /**
   * 获取CardListItemVm
   * @param live live
   * @returns ILiveCardListItemVm
   */
  public getCardListItemVm(live: LiveNotification): ILiveCardListItemVm {
    return this.getVm(this.getKey(BannerLiveCardListItemVm, live), () => new BannerLiveCardListItemVm(this, live));
  }
}