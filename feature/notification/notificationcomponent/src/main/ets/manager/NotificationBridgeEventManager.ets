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

import { ArrayUtils, LogDomain, LogHelper, SingletonHelper, CommonUtils } from '@ohos/basicutils';
import {
  crossModuleCallUtil,
  ImmersiveEntryEvent,
  LiveUseScene,
  LiveViewRequestEnterImmersiveEvent,
  LiveViewEntryEvent,
  NtfEventType,
  immersiveKgMgr,
  ImmersiveType,
  LiveViewRequestExitImmersiveEvent,
} from '@ohos/systemuicommon';
import { NotificationEntryEvent } from '../common/event/NotificationEvent';
import { NotificationCompatibleConverter } from '../parser/NotificationCompatibleConverter';
import { NotificationEntry } from '../model/NotificationEntry';
import {
  LiveViewShowAuthEvent,
  NotificationEvent,
  NotificationEventForBridge } from '@ohos/systemuicommon/src/main/ets/event/NotificationEvent';
import { InnerEventUtil } from '@ohos/systemuicommon/newTsIndex';
import { LiveType } from '@ohos/systemuicommon/src/main/ets/live/model/LiveCommonModel';
import { immeLiveStateShareMgr } from '@ohos/screenlockcommon/Index';
import { NotificationBaseForBridge } from '@ohos/systemuicommon/src/main/ets/model/NotificationBase';
import { ScreenLockEvent } from '@ohos/frameworkwrapper';
import { CcmConfigHelper } from '@ohos/screenlockcommon';

const TAG = 'NotificationBridgeEventManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 主线程的通知数据管理，数据来源于子线程，通过跨线程的事件同步传递到主线程。包含以下功能:
 * 1.跨线程的数据经过处理之后 再通过主线程事件发送给主线程的其他模块，保证主线程模块无感知。
 * 2.缓存通知数据，避免频繁大量的数据跨线程传递造成性能开销。
 */
export class NotificationBridgeEventManager {
  /**
   * 获取单例
   */
  public static get = SingletonHelper.createFactory(() => new NotificationBridgeEventManager());

  /**
   * 全量通知集
   * 通知hashCode => 通知数据
   */
  private allNtfList: Map<string, NotificationEntry> = new Map();

  /**
   * 提供给hasNotification调用的通知数据集合
   */
  private hasNtfMap: Map<string, NotificationBaseForBridge> = new Map();

  /**
   * 初始化通知订阅
   */
  public init(): void {
    log.showInfo(`Notification bridge event manager init.`);
    // 监听通知事件
    InnerEventUtil.on(NotificationEvent, this.handleNotificationEvent);

    InnerEventUtil.on(NotificationEventForBridge, this.handleNotificationEventForBridge);

    // 监听实况卡片授权事件
    InnerEventUtil.on(LiveViewShowAuthEvent, this.onBridgeLiveViewAuthChange);

    // 提供数据到主线程其他模块
    // 通知列表生产
    InnerEventUtil.produceOn(NotificationEntryEvent, this.onProduceNtfEntryEvent);

    // 实况列表生产
    InnerEventUtil.produceOn(LiveViewEntryEvent, this.onProduceLiveViewEntryEvent);

    // 沉浸锁屏列表生产
    InnerEventUtil.produceOn(ImmersiveEntryEvent, this.onProduceImmersiveEntryEvent);

    // 在主线程注册判断通知是否存在的方法
    crossModuleCallUtil.register('hasNotification', this.hasNtf);

    InnerEventUtil.on(LiveViewRequestEnterImmersiveEvent, this.onRequestEnterImmersive);
    InnerEventUtil.on(LiveViewRequestExitImmersiveEvent, this.onRequestExitImmersive);
  }

  /**
   * 判断是否存在某条通知
   * @param creatorUid
   * @param ntfId
   * @returns
   */
  public hasNtf = (creatorUid: number, ntfId: number): boolean => {
    let hasNotification = false;
    for (const ntf of this.hasNtfMap.values()) {
      if (ntf?.creatorUid === creatorUid && ntf?.id === ntfId) {
        hasNotification = true;
        break;
      }
    }
    return hasNotification;
  };

  /**
   * 监听通知事件
   */
  private handleNotificationEvent = (event: NotificationEvent): void => {
    log.showInfo(`handleNotificationEvent, type: ${event.eventType}, length: ${event.notificationList.length}`);
    const ntfList = event.notificationList;

    // 非初始化场景且通知数据为空，无需处理
    if (event.eventType !== NotificationEvent.EVENT_TYPE_INIT && ArrayUtils.isEmpty(ntfList)) {
      return;
    }
    if (event.eventType === NotificationEvent.EVENT_TYPE_INIT) {
      // 初始化场景，清空原有的list
      this.allNtfList.clear();
    }

    // 通知列表
    const entryNtfList: NotificationEntry[] = [];
    // 实况列表
    const liveList: NotificationEntry[] = [];

    ntfList.forEach(ntf => {
      // 新增即时类实况类型，不显示在通知及沉浸锁屏列表
      if (ntf.isLiveView() && (ntf.type === LiveType.INSTANT || ntf.type === LiveType.INSTANT_BANNER)) {
        return;
      }
      // 将新的通知数据结构转换为老的
      const entry = NotificationCompatibleConverter.convert(ntf, Reflect.get(ntf, 'innerRequest'));

      // 根据事件类型，更新缓存的通知数据信息
      this.updateAllListByEvent(event, entry);
      // 加入待发送给主线程其他模块的通知列表中
      entryNtfList.push(entry);
      if (entry?.isLiveType()) {
        liveList?.push(entry);
      }
    });

    if (liveList.length) {
      // 发送实况通知事件
      InnerEventUtil.post(LiveViewEntryEvent, this.createLiveViewEntryEvent(event.eventType, liveList));
    }
    if (entryNtfList.length) {
      // 发送锁屏通知事件
      InnerEventUtil.post(ImmersiveEntryEvent, this.createImmersiveEntryEvent(event.eventType, entryNtfList));
      // 发送普通通知事件
      InnerEventUtil.post(NotificationEntryEvent, this.createNtfEntryEvent(event.eventType, entryNtfList));
    }
  };

  /**
   * 监听通知事件
   */
  private handleNotificationEventForBridge = (event: NotificationEventForBridge): void => {
    log.showInfo(`handleNotificationEventForBridge, type: ${event.eventType}, length: ${event.notificationList.length}`);
    const ntfList = event.notificationList;

    if (event.eventType === NotificationEvent.EVENT_TYPE_INIT) {
      // 初始化场景，清空原有的list
      this.hasNtfMap.clear();
    }

    ntfList.forEach(ntf => {
      // 根据事件类型，更新缓存的通知数据信息
     if (event.eventType === NotificationEvent.EVENT_TYPE_INIT ||
        event.eventType === NotificationEvent.EVENT_TYPE_ADD ||
        event.eventType === NotificationEvent.EVENT_TYPE_UPDATE) {
        // 添加或更新
        this.hasNtfMap.set(ntf.hashCode, ntf);
      } else if (event.eventType === NotificationEvent.EVENT_TYPE_REMOVE) {
        // 取消
        this.hasNtfMap.delete(ntf.hashCode);
      }
    });
  }

  /**
   * 通知事件生产者
   * 返回通知初始化列表
   * @return 初始化列表
   */
  private onProduceNtfEntryEvent = (): NotificationEntryEvent => {
    const allList = this.getMapNtfList();
    log.showInfo(`onProduceNtfEntryEvent, ntfList length is: ${allList.length}`);

    return this.createNtfEntryEvent(NotificationEntryEvent.EVENT_TYPE_INIT, allList);
  };

  /**
   * 创建通知事件
   * @param eventType 事件类型
   * @param ntfList 通知集
   */
  private createNtfEntryEvent(eventType: number, ntfList: NotificationEntry[]): NotificationEntryEvent {
    log.showInfo(`createNtfEntryEvent length: ${ntfList.length}`);
    let event = new NotificationEntryEvent();
    event.eventType = eventType;
    event.notificationList = ntfList;

    return event;
  }

  /**
   * 实况通知事件生产者
   * 返回实况通知初始化列表
   * @returns 初始化列表
   */
  private onProduceLiveViewEntryEvent = (): LiveViewEntryEvent => {
    const liveList = this.getMapNtfList(true);
    return this.createLiveViewEntryEvent(NotificationEntryEvent.EVENT_TYPE_INIT, liveList);
  };

  /**
   * 创建实况通知事件
   * @param eventType 事件类型
   * @param ntfList 通知集
   */
  private createLiveViewEntryEvent(eventType: number, ntfList: NotificationEntry[]): LiveViewEntryEvent {
    log.showInfo(`createLiveViewEntryEvent length: ${ntfList.length}`);

    let event = new LiveViewEntryEvent();
    event.eventType = eventType;
    event.liveViewList = ntfList;

    return event;
  }

  /**
   * 沉浸锁屏通知事件生产者
   * 返回沉浸锁屏况通知初始化列表
   * @returns 初始化列表
   */
  private onProduceImmersiveEntryEvent = (): ImmersiveEntryEvent => {
    const liveList = this.getMapNtfList(true);
    return this.createImmersiveEntryEvent(NotificationEntryEvent.EVENT_TYPE_INIT, liveList);
  };

  /**
   * 创建沉浸锁屏通知事件
   * @param eventType 事件类型
   * @param ntfList 通知集
   */
  private createImmersiveEntryEvent(eventType: NtfEventType, ntfList: NotificationEntry[]): ImmersiveEntryEvent {
    log.showInfo(`createImmersiveEntryEvent length: ${ntfList.length}`);

    let event = new ImmersiveEntryEvent();
    event.eventType = eventType;
    event.notificationList = ntfList;

    return event;
  }

  /**
   * 获取缓存Map中的通知数据集
   * @param isOnlyLiveType 是否仅获取实况数据通知
   * @returns
   */
  private getMapNtfList(isOnlyLiveType = false): NotificationEntry[] {
    const allList: NotificationEntry[] = [];

    for (const entry of this.allNtfList.values()) {
      if (!isOnlyLiveType || (isOnlyLiveType && entry?.isLiveType())) {
        allList?.push(entry);
      }
    }

    return allList;
  }

  /**
   * 根据通知事件和数据，更新主线程的缓存信息
   * @param event
   * @param entry
   */
  private updateAllListByEvent(event: NotificationEvent, entry: NotificationEntry): void {
    // 根据事件类型，更新缓存的通知数据信息
    if (event.eventType === NotificationEvent.EVENT_TYPE_INIT) {
      // 初始化
      this.allNtfList.set(entry.hashCode, entry);
    } else if (event.eventType === NotificationEvent.EVENT_TYPE_ADD ||
      event.eventType === NotificationEvent.EVENT_TYPE_UPDATE) {
      // 更新通知
      if (event.eventType === NotificationEvent.EVENT_TYPE_UPDATE) {
        const oldEntry = this.allNtfList.get(entry.hashCode);
        if (!CommonUtils.isInvalid(oldEntry)) {
          entry.updateDataWhenUpdate(oldEntry);
        }
      }
      // 添加或更新
      this.allNtfList.set(entry.hashCode, entry);
    } else if (event.eventType === NotificationEvent.EVENT_TYPE_REMOVE) {
      // 取消
      this.allNtfList.delete(entry.hashCode);
    }
  }

  /**
   * 监听实况授权变化事件，更新主线程的entry数据。提供给锁屏上的实况使用。
   */
  private onBridgeLiveViewAuthChange = (event: LiveViewShowAuthEvent): void => {
    log.info(`onBridgeLiveViewAuthChange ${event.hashCode}`);
    const entry = this.allNtfList.get(event.hashCode);
    if (!entry || !entry?.isLiveType()) {
      return;
    }

    entry.liveViewData?.updateShowAuth();
    entry.notifyDataChanged();
  };

  /**
   * 监听请求进入沉浸式实况
   */
  private onRequestEnterImmersive = (event: LiveViewRequestEnterImmersiveEvent): void => {
    const liveViewData = this.allNtfList.get(event.hashCode)?.liveViewData;
    if (!liveViewData) {
      log.error(`Cannot find liveViewData for ${event.hashCode}`);
      return;
    }
    const listener = liveViewData.getIconClickListener(LiveUseScene.SCENE_LIVE_LIST, true, true);
    if (!listener) {
      log.error(`Cannot find icon listener for ${event.hashCode}`);
      return;
    }
    log.showInfo(`Request enter immersive from live card ${event.hashCode}`);
    immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_LIST);
    const shareData = immeLiveStateShareMgr.getShareLiveData();
    shareData.splice(0, shareData.length, liveViewData);
    listener();
  };

  /**
   * 监听请求退出沉浸式实况
   */
  private onRequestExitImmersive = (event: LiveViewRequestExitImmersiveEvent): void => {
    log.showInfo(`Request exit immersive from live card`);
    immeLiveStateShareMgr.getLiveCapsuleClick()?.();
  };

  /**
   * 启用worker时初始化通知监听
   */
  private initSubscribeNotificationForWorker() {
    // 锁屏未启用v2，需桥接v1数据结构。锁屏V2上主干后可删除
    if (!CcmConfigHelper.getInstance().isImmKgV2Enable()) {
      log.showInfo(`ImmKgV2 disable, use bridge`)
      InnerEventUtil.on(ScreenLockEvent, this.onScreenLockEvent);
    }
  }

  /**
   * 监听锁屏事件，锁屏时将通知消息发给锁屏通知
   */
  private onScreenLockEvent = (event: ScreenLockEvent): void => {
    log.showInfo(`bridge onScreenLockEvent, isScreenLock: ${event.isLockScreen}`);
    if (event.isLockScreen) {
      InnerEventUtil.on(NotificationEvent, this.handleNotificationEvent);
    } else {
      InnerEventUtil.off(NotificationEvent, this.handleNotificationEvent);
      this.allNtfList.clear();
    }
  }
}