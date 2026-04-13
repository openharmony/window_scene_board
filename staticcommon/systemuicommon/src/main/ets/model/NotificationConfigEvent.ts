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

import { NotificationConfigEntity } from './NotificationConfigEntity';

/**
 * 通知配置事件类型
 */
export enum NotificationConfigEventType {
  UPDATE_RESOURCE = 0,
  ADD_ITEM = 1,
  DELETE_ITEM = 2,
  UPDATE_ITEM = 3,
  PINTOP_ITEM = 4,
  SLOT_CHANGE = 5,
  CHANGE_IGNORE = 6,
  HIDE_BANNER_CONTENT = 7,
  BADGE_CHANGE = 8,
  SHOWING_NOTIFICATION_UPDATE = 9,
  SILENT_NOTIFICATION = 10,
  SILENT_DIALOG = 11,
  DISTRIBUTED_ITEM = 12,
}

/**
 * 触发更新资源事件的类型
 */
export enum ResourceUpdateType {
  UNKNOWN = -1,
  /** 语言切换 */
  LANGUAGE_CHANGE = 1,
  /** 主题切换 */
  THEME_CHANGE = 16,
  /** 图标切换 */
  ICON_CHANGE = 100,
}

/**
 * 切换通知资源事件
 */
export class NotificationConfigUpdateResourceEvent {
  public readonly type: NotificationConfigEventType.UPDATE_RESOURCE = NotificationConfigEventType.UPDATE_RESOURCE;

  constructor(public readonly resourceUpdateType: ResourceUpdateType, public readonly duplicateUid?: Set<number>) {
  }
}

/**
 * 通知配置新增事件
 */
export class NotificationConfigAddEvent {
  public readonly type: NotificationConfigEventType.ADD_ITEM = NotificationConfigEventType.ADD_ITEM;

  constructor(public readonly config: NotificationConfigEntity) {
  }
}

/**
 * 删除通知配置事件
 */
export class NotificationConfigDeleteEvent {
  public readonly type: NotificationConfigEventType.DELETE_ITEM = NotificationConfigEventType.DELETE_ITEM;

  constructor(public readonly uid: number) {
  }
}

/**
 * 更新通知配置事件
 */
export class NotificationConfigUpdateConfigEvent {
  public readonly type: NotificationConfigEventType.UPDATE_ITEM = NotificationConfigEventType.UPDATE_ITEM;

  constructor(public readonly config: NotificationConfigEntity) {
  }
}

/**
 * 更新静默通知事件
 */
export class NotificationSilenceEvent {
  public readonly type: NotificationConfigEventType.SILENT_NOTIFICATION = NotificationConfigEventType.SILENT_NOTIFICATION;

  constructor(public readonly uid: number, public readonly bundleName: string, public readonly isSilent: boolean) {
  }
}

/**
 * 更新静默通知菜单变化事件
 */
export class NtfSilentDialogEvent {
  public readonly type: NotificationConfigEventType.SILENT_DIALOG = NotificationConfigEventType.SILENT_DIALOG;

  constructor(public readonly uid: number, public readonly bundleName: string) {
  }
}

/**
 * 置顶通知配置事件
 */
export class NotificationConfigPinTopEvent {
  public readonly type: NotificationConfigEventType.PINTOP_ITEM = NotificationConfigEventType.PINTOP_ITEM;

  constructor(public readonly uid: number, public readonly enabled: boolean) {
  }
}

/**
 * 隐藏横幅通知内容配置事件
 */
export class NotificationConfigHideBannerContentEvent {
  public readonly type: NotificationConfigEventType.HIDE_BANNER_CONTENT = NotificationConfigEventType.HIDE_BANNER_CONTENT;

  constructor(public readonly uid: number, public readonly index: number) {
  }
}

/**
 * 通知渠道变化事件
 */
export class NotificationConfigSlotChangeEvent {
  public readonly type: NotificationConfigEventType.SLOT_CHANGE = NotificationConfigEventType.SLOT_CHANGE;

  constructor(public readonly uid: number) {
  }
}

/**
 * 通知配置是否忽略变化事件
 */
export class NotificationConfigChangeIgnoreEvent {
  public readonly type: NotificationConfigEventType.CHANGE_IGNORE = NotificationConfigEventType.CHANGE_IGNORE;

  constructor(public readonly config: NotificationConfigEntity) {
  }
}

/**
 * 角标变化事件
 */
export class NotificationConfigBadgeChangeEvent {
  public readonly type: NotificationConfigEventType.BADGE_CHANGE = NotificationConfigEventType.BADGE_CHANGE;

  constructor(public readonly uid: number) {
  }
}

/**
 * 正在展示的通知资源更新事件
 */
export class NotificationShowingUpdateEvent {
  public readonly type: NotificationConfigEventType.SHOWING_NOTIFICATION_UPDATE = NotificationConfigEventType.SHOWING_NOTIFICATION_UPDATE;

  constructor(public readonly resourceUpdateType: ResourceUpdateType) {
  }
}

/**
 * 多屏协同开关出现事件
 */
export class NotificationDistributionButtonEvent {
  public readonly type: NotificationConfigEventType.DISTRIBUTED_ITEM = NotificationConfigEventType.DISTRIBUTED_ITEM;
}

/**
 * 通知配置事件
 */
export type NotificationConfigEvent =
  NotificationConfigUpdateResourceEvent |
  NotificationConfigAddEvent |
  NotificationConfigDeleteEvent |
  NotificationConfigUpdateConfigEvent |
  NotificationConfigPinTopEvent |
  NotificationConfigSlotChangeEvent |
  NotificationConfigChangeIgnoreEvent |
  NotificationConfigHideBannerContentEvent |
  NotificationConfigBadgeChangeEvent |
  NotificationShowingUpdateEvent |
  NotificationSilenceEvent |
  NtfSilentDialogEvent|
  NotificationDistributionButtonEvent;