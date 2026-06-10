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
import type { BaseNotification } from '../../model/BaseNotification';
import type { NtfEventType } from '../common/ImmersiveConstants';

/**
 * 沉浸锁屏实况通知事件
 */
export class ImmersiveEntryEvent {
  /**
   * 事件类型
   */
  eventType: NtfEventType;

  /**
   * 通知数据列表
   */
  notificationList: Array<BaseNotification>;
}

Object.defineProperty(ImmersiveEntryEvent, 'eventTypeName', { value: 'ImmersiveEntryEvent' });

/**
 * 沉浸锁屏实况通知是否需要隐藏
 */
export class HideNtfContentEvent {
  /**
   * 通知分组唯一标识
   */
  groupKey: string;

  /**
   * 是否需要隐藏
   */
  shouldHide: boolean = false;
}

Object.defineProperty(HideNtfContentEvent, 'eventTypeName', { value: 'HideNtfContentEvent' });

/**
 * 锁屏壁纸切换事件
 */
export class ScreenLockWallpaperChangeEvent {}

Object.defineProperty(ScreenLockWallpaperChangeEvent, 'eventTypeName', { value: 'ScreenLockWallpaperChangeEvent' });

/**
 * 使能或禁用BACK手势事件
 */
export class EnableBackGestureEvent {
  public static eventTypeName = 'EnableBackGestureEvent';

  public isEnable: boolean = false;

  public callerName: string = '';

  constructor(isEnable: boolean, callerName?: string) {
    this.isEnable = isEnable;
    this.callerName = callerName;
  }
}