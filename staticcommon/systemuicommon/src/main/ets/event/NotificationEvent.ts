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

import type { NotificationBase, NotificationBaseForBridge } from '../model/NotificationBase';

/**
 * 通知事件
 */
export class NotificationEvent {
  /**
   * 事件名称
   */
  static readonly eventTypeName = 'NotificationEvent';

  /**
   * 通知列表初始化
   */
  static readonly EVENT_TYPE_INIT = 0;

  /**
   * 通知新增事件
   */
  static readonly EVENT_TYPE_ADD = 1;

  /**
   * 通知更新事件
   */
  static readonly EVENT_TYPE_UPDATE = 2;

  /**
   * 通知删除事件
   */
  static readonly EVENT_TYPE_REMOVE = 3;

  /**
   * ANS触发UPDATE
   */
  static readonly UPDATE_TYPE_ANS = 0;

  /**
   * 配置变更触发UPDATE
   */
  static readonly UPDATE_TYPE_CONFIG = 1;

  /**
   * 置顶触发UPDATE
   */
  static readonly UPDATE_TYPE_PIN_TOP = 2;

  /**
   * 通知更新场景，表示本次事件携带的数据是否为批量
   */
  public get isBatch(): boolean {
    return this.updateType !== NotificationEvent.UPDATE_TYPE_ANS;
  }

  /**
   * 通知更新事件场景，触发更新的配置变更类型
   */
  public updateType: number = NotificationEvent.UPDATE_TYPE_ANS;

  constructor(public eventType: number, public notificationList: NotificationBase[]) { }
}

export class NotificationEventForBridge {
  /**
   * 事件名称
   */
  static readonly eventTypeName = 'NotificationEventForBridge';

  constructor(public eventType: number, public notificationList: NotificationBaseForBridge[]) {}
}

export class NotificationListenerEntryCancelEvent {
  /**
   * 事件名称
   */
  static readonly eventTypeName = 'NotificationListenerEntryCancelEvent';

  constructor(public hashCode: string, public userId?: number) {}
}

/**
 * 状态栏通知事件
 */
export class StatusBarNotificationEvent {
  /**
   * 事件名称
   */
  static readonly eventTypeName = 'StatusBarNotificationEvent';

  constructor(public notificationList: NotificationBase[], public forceRefresh = false) { }
}


/**
 * 实况卡片授权事件
 */
export class LiveViewShowAuthEvent {
  /**
   * 事件名称
   */
  static readonly eventTypeName = 'LiveViewShowAuthEvent';

  constructor(public hashCode: string) { }
}


/*
 * 横幅卡片上滑事件
 */
export class BannerSlideUpEvent{
  /**
   * 事件名称
   */
  static readonly eventTypeName = 'BannerSlideUpEvent';
  constructor() { }
}


/*
 * 通知中心下拉事件
 */
export class NtfCenterDropDownEvent{
  /**
   * 事件名称
   */
  static readonly eventTypeName = 'NtfCenterDropDownEvent';
  constructor() { }
}