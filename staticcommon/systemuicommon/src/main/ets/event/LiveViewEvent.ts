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
import type { LiveViewCapsuleInfo } from '../plugin/info/PluginAnimatorInfo';
import type { BaseNotification } from '../model/BaseNotification';
import { hash } from '@kit.CoreFileKit';
import { RectItem } from '@ohos/basicutils';

export enum LiveViewEventType {
  /**
   * 通知列表初始化
   */
  EVENT_TYPE_INIT = 0,


  /**
   * 通知新增事件
   */
  EVENT_TYPE_POST_ADD = 1,


  /**
   * 通知更新事件
   */
  EVENT_TYPE_POST_UPDATE = 2,

  /**
   * 通知取消事件
   */
  EVENT_TYPE_POST_CANCEL = 3,

  /**
   * 实况卡片点击事件
   */
  EVENT_TYPE_CARD_CLICK = 4,

  /**
   * 实况卡片触摸事件
   */
  EVENT_TYPE_CARD_TOUCH = 5,
  /**
   * 实况胶囊点击事件
   */
  EVENT_TYPE_CAPSULE_CLICK = 6
}

export enum LiveViewPluginType {
  /**
   * 通知列表
   */
  PLUGIN_TYPE_FORM = 0,


  /**
   * 胶囊
   */
  PLUGIN_TYPE_CAPSULE = 1,


  /**
   * 应用
   */
  PLUGIN_TYPE_APP = 2,
}

/**
 * 实况通知事件
 */
export class LiveViewEntryEvent {
  /**
   * 事件类型
   */
  eventType: number;

  /**
   * 通知数据列表
   */
  liveViewList: Array<BaseNotification>;
}

Object.defineProperty(LiveViewEntryEvent, 'eventTypeName', { value: 'LiveViewEntryEvent' });

/**
 * 实况胶囊事件
 */
export class LiveViewCapsuleEntryEvent {
  /**
   * 事件类型
   */
  eventType: number;

  /**
   * 通知数据列表
   */
  liveViewList: Array<BaseNotification>;

  /**
   * 实况胶囊位置数据
   */
  capsuleInfo: LiveViewCapsuleInfo;
}

Object.defineProperty(LiveViewCapsuleEntryEvent, 'eventTypeName', { value: 'LiveViewCapsuleEntryEvent' });

/**
 * 实况卡片事件
 */
export class LiveViewFormEntryEvent {
  /**
   * 事件类型
   */
  eventType: number;

  /**
   * 事件坐标X，number，单位px
   */
  posX?: number;

  /**
   * 事件坐标Y，number，单位px
   */
  poxY?: number;

  /**
   * 通知数据列表
   */
  liveViewList: Array<BaseNotification>;
}

Object.defineProperty(LiveViewFormEntryEvent, 'eventTypeName', { value: 'LiveViewFormEntryEvent' });

/**
 * 实况组件事件
 */
export class LiveViewPluginEvent {
  /**
   * 事件类型
   */
  eventType: number;

  /**
   * 组件类型
   */
  pluginType: number;

  /**
   * 组件id
   */
  pluginId: string;

  static create(eventType: number, pluginType: number, pluginId: string): LiveViewPluginEvent {
    let event = new LiveViewPluginEvent();
    event.eventType = eventType;
    event.pluginType = pluginType;
    event.pluginId = pluginId;
    return event;
  }
}

Object.defineProperty(LiveViewPluginEvent, 'eventTypeName', { value: 'LiveViewPluginEvent' });

/**
 * 实况数据超时事件
 */
export class LiveTimeoutEvent {
  /**
   * 超时通知数据位移标示
   */
  hashCode?: string;

  /**
   * 创建事件
   *
   * @param hashCode 唯一标示
   * @returns 事件
   */
  static create(hashCode?: string): LiveTimeoutEvent {
    let event = new LiveTimeoutEvent();
    event.hashCode = hashCode;
    return event;
  }
}

Object.defineProperty(LiveTimeoutEvent, 'eventTypeName', { value: 'LiveTimeoutEvent' });

/**
 * 录屏胶囊出现消失事件
 */
export class ScreenRecordCapsuleEvent {
  /**
   * 录屏胶囊状态
   */
  status: boolean;
  /**
   * 录屏胶囊背景色
   */
  color: string;
}

Object.defineProperty(ScreenRecordCapsuleEvent, 'eventTypeName', { value: 'ScreenRecordCapsuleEvent' });

/**
 * 状态栏Padding变化事件
 */
export class StatusBarStyleChangeEvent {
  /**
   * 状态栏左侧边距
   */
  statusBarPaddingLeft: string = '';
  /**
   * 状态栏顶部边距
   */
  statusBarPaddingTop: string = '';
  /**
   * 状态栏右侧边距
   */
  statusBarPaddingRight: string = '';
  /**
   * 旋转状态
   */
  orientation: number = 0;
}

Object.defineProperty(StatusBarStyleChangeEvent, 'eventTypeName', { value: 'StatusBarStyleChangeEvent' });

/**
 * 应用回胶囊事件
 */
export class LiveApp2CapsuleEvent {
  constructor(status: boolean) {
    this.status = status;
  }

  /**
   * 状态
   */
  status: boolean;
}

Object.defineProperty(LiveApp2CapsuleEvent, 'eventTypeName', { value: 'LiveApp2CapsuleEvent' });

/**
 * 手电筒切换实况事件
 */
export class FlashlightLiveEvent {
  // 手电筒状态
  isOn: boolean;

  /**
   * 创建事件
   *
   * @param status 是否打开手电筒
   */
  static create(status: boolean): FlashlightLiveEvent {
    let event = new FlashlightLiveEvent();
    event.isOn = status;
    return event;
  }
}

Object.defineProperty(FlashlightLiveEvent, 'eventTypeName', { value: 'FlashlightLiveEvent' });

/**
 * 请求进入实况沉浸式的事件
 */
export class LiveViewRequestEnterImmersiveEvent {
  public static eventTypeName = 'LiveViewRequestEnterImmersiveEvent';

  public hashCode = '';

  constructor(hashCode: string) {
    this.hashCode = hashCode;
  }
}

/**
 * 请求退出实况沉浸式的事件
 */
export class LiveViewRequestExitImmersiveEvent {
  public static eventTypeName = 'LiveViewRequestExitImmersiveEvent';
}

/**
 * 进入实况沉浸式的事件
 */
export class LiveViewEnterImmersiveEvent {
  public static eventTypeName = 'LiveViewEnterImmersiveEvent';
  public hashCode = '';

  constructor(hashCode: string) {
    this.hashCode = hashCode;
  }
}

/**
 * 退出实况沉浸式的事件
 */
export class LiveViewExitImmersiveEvent extends LiveViewEnterImmersiveEvent {
  public static eventTypeName = 'LiveViewExitImmersiveEvent';
}