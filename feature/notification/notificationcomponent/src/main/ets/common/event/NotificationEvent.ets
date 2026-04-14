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
import { TargetPanel } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';

import type { AggregateContent, NotificationEntry, UnifiedGroupEventEntry } from '../../model/NotificationEntry';

/**
 * 通知post/cancel事件
 */
export class NotificationEntryEvent {
  public static readonly eventTypeName = 'NotificationEntryEvent';

  /**
   * 通知列表初始化
   */
  public static readonly EVENT_TYPE_INIT = 0;

  /**
   * 通知新增事件
   */
  public static readonly EVENT_TYPE_POST_ADD = 1;

  /**
   * 通知更新事件
   */
  public static readonly EVENT_TYPE_POST_UPDATE = 2;

  /**
   * 通知取消事件
   */
  public static readonly EVENT_TYPE_POST_CANCEL = 3;

  /**
   * 事件类型
   */
  public eventType: number = 0;

  /**
   * 通知数据列表
   */
  public notificationList: Array<NotificationEntry> = [];
}

/**
 * 通知状态栏图标事件
 */
export class NtfStatusIconEvent {
  public static readonly eventTypeName = 'NtfStatusIconEvent';

  /**
   * 通知状态栏图标集
   */
  public ntfSbIconList: Array<NotificationEntry> = [];
  /**
   * 是否强制刷新
   */
  public forceRefresh: boolean = false;

  /**
   * 创建事件
   *
   * @param sbIconList 状态栏通知图标集
   * @return 事件
   */
  public static create(sbIconList: Array<(NotificationEntry)>): NtfStatusIconEvent {
    let event = new NtfStatusIconEvent();
    event.ntfSbIconList = sbIconList;
    return event;
  }
}

/**
 * 通知未读消息事件
 */
export class NtfUnreadEvent {
  public static readonly eventTypeName = 'NtfUnreadEvent';

  /**
   * 通知未读个数
   */
  public ntfUnreadCount: number = 0;
}

/**
 * 重置通知条目展开状态
 */
export class ResetItemExpandEvent {
  public static readonly eventTypeName = 'ResetItemExpandEvent';

  /**
   * 通知分组标识，组通知使用
   * 为空时，表示重置所有
   */
  public ntfGroupKey?: string;

  /**
   * 通知唯一标示，单通知使用
   * 为空时，标示重置所有
   */
  public ntfHashCode?: string;

  /**
   * 通知面板类型
   * NotificationType
   */
  public ntfPanelType: number = 0;

  /**
   * 创建事件
   *
   * @param ntfType 通知面板类型
   * @param ntfGroupKey 通知分组标识
   * @param ntfHashCode 通知唯一标示
   * @return 事件
   */
  public static create(ntfType: number, ntfGroupKey?: string, ntfHashCode?: string): ResetItemExpandEvent {
    let event = new ResetItemExpandEvent();
    event.ntfPanelType = ntfType;
    event.ntfGroupKey = ntfGroupKey;
    event.ntfHashCode = ntfHashCode;
    return event;
  }
}

/**
 * 重置条目横滑展开状态
 */
export class ResetItemSwipeEvent {
  public static readonly eventTypeName = 'ResetItemSwipeEvent';

  /**
   * 通知分组标识，组通知使用
   * 为空时，表示重置所有
   */
  public ntfGroupKey?: string;

  /**
   * 通知唯一标示，单通知使用
   * 为空时，标示重置所有
   */
  public ntfHashCode?: string;

  /**
   * 通知面板类型
   * NotificationType
   */
  public ntfPanelType?: number;

  /**
   * 创建事件
   *
   * @param ntfType 通知面板类型
   * @param ntfGroupKey 通知分组标识
   * @param ntfHashCode 通知唯一标示
   * @return 事件
   */
  public static create(ntfType: number, ntfGroupKey?: string, ntfHashCode?: string): ResetItemSwipeEvent {
    let event = new ResetItemExpandEvent();
    event.ntfPanelType = ntfType;
    event.ntfGroupKey = ntfGroupKey;
    event.ntfHashCode = ntfHashCode;
    return event;
  }
}

/**
 * 通知右键点击menu弹框事件
 */
export class NtfRightClickEvent {
  public static readonly eventTypeName = 'NtfRightClickEvent';

  /**
   * 右键点击的通知数据
   */
  public ntfEntry: NotificationEntry;

  /**
   * 点击位置
   */
  public screenX: number = 0;

  /**
   * 点击位置
   */
  public screenY: number = 0;

  /**
   * 创建通知右键点击事件
   *
   * @param ntfEntry 通知数据
   * @param screenX 点击位置
   * @param screenY 点击位置
   * @return 事件
   */
  constructor(ntfEntry: NotificationEntry, screenX: number, screenY: number) {
    this.ntfEntry = ntfEntry;
    this.screenX = screenX;
    this.screenY = screenY;
  }
}

/**
 * 通知滑动删除事件
 */
export class NtfSwipeDeleteEvent {
  public static readonly eventTypeName = 'NtfSwipeDeleteEvent';

  /**
   * 通知滑动删除开始
   */
  public static readonly EVENT_TYPE_START = 0;

  /**
   * 通知滑动删除结束
   */
  public static readonly EVENT_TYPE_END = 1;

  public entry?: NotificationEntry | null;

  public inGroup: boolean = false;

  /**
   * 事件类型
   */
  public eventType?: number;
}

/**
 * 聚合通知提醒事件
 */
export class UnifiedGroupRemindEvent {
  public static readonly eventTypeName = 'UnifiedGroupRemindEvent';

  /**
   * 聚合数据
   */
  public unified?: UnifiedGroupEventEntry;
}

/**
 * 聚合通知更新事件
 */
export class UnifiedGroupUpdateEvent {
  public static readonly eventTypeName = 'UnifiedGroupUpdateEvent';

  /**
   * key
   */
  public key?: string;

  /**
   * 聚合消息
   */
  public unified?: AggregateContent;
}

export enum NtfAnimateStatus {
  START = 0,
  END = 1,
}

export class NtfAnimateEvent {
  public static readonly eventTypeName = 'NtfAnimateEvent';

  /**
   * 退出通知中心
   */
  public static readonly EXIT_NC = 0;

  /**
   * 事件类型
   */
  public eventType: number;

  /**
   * 动效状态。
   */
  public status: NtfAnimateStatus;

  constructor(eventType: number, status: NtfAnimateStatus) {
     this.eventType = eventType;
     this.status = status;
  }
}

/**
 * 通知置顶事件
 */
export class NtfPinnedEvent {
  public static readonly eventTypeName = 'NtfPinnedEvent';

  /**
   * uid
   */
  public creatorUid: number;

  constructor(creatorUid: number) {
    this.creatorUid = creatorUid;
  }
}

/**
 * 通知列表滑动时间
 */
export class NtfListScrollEvent {
  public static readonly eventTypeName = 'NtfListScrollEvent';
}

/**
 * 组通知折叠展开事件
 */
export class GroupItemExpandingEvent {
  public static readonly eventTypeName = 'GroupItemExpandingEvent';

  /**
   * 是否在展开过程中
   */
  public isGroupExpanding: boolean;

  /**
   * 点击展开组通知groupTypeKey
   */
  public groupTypeKey: string;

  constructor(isGroupExpanding: boolean, groupTypeKey: string) {
    this.isGroupExpanding = isGroupExpanding;
    this.groupTypeKey = groupTypeKey;
  }
}

/**
 * 下拉面板切换完成通知(切换动效结束后)
 */
export class DropdownPanelChangeFinishedEvent {
  public static readonly eventTypeName = 'DropdownPanelChangeFinishedEvent';

  public isShow: boolean;
  public currPanel: TargetPanel;
  public targetPanel: TargetPanel;

  constructor(isShow: boolean, currPanel: TargetPanel, targetPanel: TargetPanel) {
    this.isShow = isShow;
    this.currPanel = currPanel;
    this.targetPanel = targetPanel;
  }
}

/**
 * 更多通知折叠事件
 */
export class ExtraNtfCollapseEvent {
  public static readonly eventTypeName = 'ExtraNtfCollapseEvent';
}