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

import { LogWithHa, NotificationConfigEntity, TablePredicates } from '../common/BasicCommon';
import { NotificationConfigBaseManager } from '../common/BasicCommon';
import {
  NotificationConfigEvent,
  NotificationConfigSlotChangeEvent,
  NotificationConfigBadgeChangeEvent
} from '../common/BasicCommon';
import { LogDomain, LogHelper } from '../common/BasicCommon';
import { Trace } from '../common/Trace';
import { CustomPromise } from '../common/CustomPromise';
import { taskpool } from '@kit.ArkTS';
import { preloadAppListTask } from './PreloadAppListTask';
import { ContextManager } from './ContextManager';
import { bundleManager } from '@kit.AbilityKit';
import lazy launcherBundleManager from '@ohos.bundle.launcherBundleManager';
import lazy notificationSubscribe from '@ohos.notificationSubscribe';

const log = LogHelper.getLogHelper(LogDomain.NC, 'NotificationSettingManager');

/**
 * 0用户ID，在所有用户下都需要显示通知设置
 */
const ZERO_USER_ID = 0;

class NotificationSettingManager extends NotificationConfigBaseManager {
  private isSubscribedSlotEvent = false;
  private preloadedAppList?: CustomPromise<NotificationConfigEntity[]>;

  public init(): void {
    this.userId = this.getUserIdFromUid(ContextManager.context.applicationInfo.uid);
  }

  /*
   * 是否有桌面图标
   */
  public async hasLauncher(bundle: string, uid: number): Promise<boolean> {
    try {
      let userId = this.getUserIdFromUid(uid);
      const launcherAbility = await launcherBundleManager.getLauncherAbilityInfo(bundle, userId);
      return launcherAbility?.length > 0;
    } catch (e) {
      log.error(`Has launcher for ${bundle}_${uid} error:`, e);
      return false;
    }
  }

  /**
   * 使用taskpool预加载应用列表，提升首页加载效率
   * @returns
   */
  public async preloadAppList(): Promise<void> {
    Trace.start('PreloadAppList');
    try {
      this.preloadedAppList = new CustomPromise();
      const myTask = new taskpool.Task('preloadAppListTask', preloadAppListTask, ContextManager.context);
      // taskpool执行超时打点
      let timeoutId = setTimeout(() => {
        if (!myTask.isDone()) {
          LogWithHa.error(log, `preloadAppListTask taskpool timeout`);
        } else {
          log.showInfo(`preloadAppListTask taskpool success`);
        }
      }, 3 * 60 * 1000);
      const appList = await taskpool.execute(myTask) as NotificationConfigEntity[];

      clearTimeout(timeoutId);
      this.preloadedAppList.resolve(appList);
      log.showInfo(`Preload app list success, length: ${appList.length}`);
    } catch (e) {
      log.error('Preload app list error code:' + e?.code + ', message:' + e?.message);
      this.preloadedAppList?.resolve([]);
    }
    Trace.end('PreloadAppList');
  }

  /**
   * 获取通知配置服务列表
   */
  public async getServiceList(usePreload = false): Promise<NotificationConfigEntity[]> {
    const predicates = NotificationConfigEntity.getPredicates()
      .inCondition({ userId: [this.userId, ZERO_USER_ID] })
      .equalTo({ bundleType: bundleManager.BundleType.ATOMIC_SERVICE })
      .orderByAsc('sortTag');
    return this.fetchAppList(usePreload, predicates);
  }

  /**
   * 获取通知配置应用列表，先查全量数据，再过滤settingIgnore为false的
   */
  public async getAppList(usePreload = false): Promise<NotificationConfigEntity[]> {
    const liveViewAppList = await this.getOriginAppList(usePreload);
    return liveViewAppList.filter((config) => config.settingIgnore === false);
  }

  /**
   * 获取通知配置应用列表，用于查询实况窗列表
   */
  public async getOriginAppList(usePreload = false): Promise<NotificationConfigEntity[]> {
    const predicates = NotificationConfigEntity.getPredicates()
      .inCondition({ userId: [this.userId, ZERO_USER_ID] })
      .equalTo({ systemApp: false })
      .orderByAsc('sortTag');
    return this.fetchAppList(usePreload, predicates);
  }

  private async fetchAppList(usePreload: boolean, predicates: TablePredicates<NotificationConfigEntity>): Promise<NotificationConfigEntity[]> {
    let appList: NotificationConfigEntity[] = [];

    try {
      if (usePreload && this.preloadedAppList) {
        appList = await this.preloadedAppList;
        this.preloadedAppList = undefined;
      }
      if (appList?.length) {
        log.showInfo(`Get app list from preload, length: ${appList.length}`);
        return appList;
      }

      const list = await NotificationConfigEntity.queryList(predicates);
      const result = new Map<number, NotificationConfigEntity>();
      for (const item of list) {
        if (result.has(item.uid)) {
          log.showInfo(`Delete repeat config for ${item.uid}`);
          result.get(item.uid)?.delete();
        }
        result.set(item.uid, item);
      }
      appList = Array.from(result.values());
      log.showInfo(`Get app list success: ${appList.length}`);
    } catch (e) {
      log.error(`Get app list error:`, e);
    }
    return appList;
  }

  /**
   * 获取通知配置应用
   */
  public async getAppItem(uid: number, bundleName?: string): Promise<NotificationConfigEntity | undefined> {
    const props: NotificationConfigEntity = { uid: uid } as NotificationConfigEntity;
    if (bundleName) {
      props.bundle = bundleName;
    }
    try {
      return await NotificationConfigEntity.queryByProps(props);
    } catch (e) {
      log.error(`Get app item error code: ${e?.code}, message: ${e?.message}`);
      return undefined;
    }
  }

  /**
   * 复写订阅通知配置变化事件，增加监听slot变化事件
   * @param listener
   */
  public subscribeChangeEvent(listener: (event: NotificationConfigEvent) => void): void {
    super.subscribeChangeEvent(listener);
    if (!this.isSubscribedSlotEvent) {
      this.subscribeSlotChangeEvent();
      this.subscribeBadgeChangeEvent();
      this.isSubscribedSlotEvent = true;
    }
  }

  /**
   * 订阅通知开关变化事件
   */
  private async subscribeSlotChangeEvent(): Promise<void> {
    try {
      await notificationSubscribe.subscribe({
        onEnabledNotificationChanged: (data) => {
          if (typeof data.uid !== 'number') {
            log.error(`Handle notification enable event error cause uid is invalid:`, data);
            return;
          }
          log.showInfo(`Recieve notification enable event for ${data.bundle}_${data.uid}, enabled: ${data.enable}`);
          this.triggerChangeEvent(new NotificationConfigSlotChangeEvent(data.uid));
        },
      });
    } catch (e) {
      log.error(`Subscribe notification enable event error code: ${e?.code}, message: ${e?.message}`);
    }
  }

  /**
   * 订阅角标开关变化事件
   */
  private async subscribeBadgeChangeEvent(): Promise<void> {
    try {
      await notificationSubscribe.subscribe({
        onBadgeChanged: (data) => {
          if (typeof data.uid !== 'number') {
            log.error(`Handle badge enable event error cause uid is invalid:`, data);
            return;
          }
          log.showInfo(`Recieve badge enable event for ${data.bundle}_${data.uid}, enabled: ${data.badgeNumber}`);
          this.triggerChangeEvent(new NotificationConfigBadgeChangeEvent(data.uid));
        },
      });
    } catch (e) {
      log.error(`Subscribe badge enable event error code: ${e?.code}, message: ${e?.message}`);
    }
  }

  /**
   * 订阅全场景协同开关出现的事件
   * @param listener
   */
  public subscribeDistributionChangeEvent(listener: (event: NotificationConfigEvent) => void): void {
    super.subscribeDistributionChangeEvent(listener);
  }
}

export const notificationSettingManager = new NotificationSettingManager();