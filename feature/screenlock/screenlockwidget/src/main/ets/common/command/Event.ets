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

/**
 * 组件内向组件外发送的时钟业务事件
 */
export enum ClockOutputEventType {
}

/**
 * 组件内向组件外发送的卡片业务事件
 */
export enum FormOutputEventType {
  ENTER_EDIT_CARD_EVENT = 'enter_edit_card_event',
  FORM_CARD_SUCCESS_EVENT = 'form_cark_success_event'
}

/**
 * 组件外向组件内发送的时钟业务事件
 */
export enum ClockInputEventType {
  /**
   * 屏幕尺寸变化
   */
  SCREEN_SIZE_CHANGE = 'screen_size_change',

  /**
   * 锁屏通知折叠展开状态事件
   */
  NTF_EXPAND_COLLAPSE = 'ntf_expand_collapse',

  /**
   * 时钟内部样式布局刷新事件
   */
  UPDATE_CLOCK_PARAM_EVENT = 'update_clock_param_event',

  /**
   * 时钟折叠刷新组件内布局后，触发时钟网格信息事件
   */
  AFTER_CLOCK_COLLAPSE_EVENT = 'after_clock_collapse_event',

  /**
   * 时钟网格变化事件
   */
  CLOCK_MESH_CHANGE = 'clock_mesh_change',
}

/**
 * 事件联合类型
 */
export type EventType = ClockOutputEventType | ClockInputEventType | FormOutputEventType;

/**
 * 通信事件
 *
 */
export interface IEvent {
  /**
   * 获取事件类型
   *
   * @returns 事件类型
   */
  getEventType(): EventType;

  /**
   * 发送事件的来源
   *
   * @returns 事件发送来源
   */
  getScene(): string;
}

/**
 * 组件通信事件基类
 */
export abstract class BaseEvent implements IEvent {
  /**
   * 事件类型
   */
  private type: EventType;
  /**
   * 保存发送事件的TAG
   */
  private scene: string;

  constructor(type: EventType, scene: string) {
    this.type = type;
    this.scene = scene;
  }

  /**
   * 获取事件类型
   *
   * @returns 事件类型
   */
  getEventType(): EventType {
    return this.type;
  }

  /**
   * 发送事件的来源
   *
   * @returns 事件发送来源
   */
  getScene(): string {
    return this.scene;
  }
}

/**
 * 屏幕尺寸变化事件，需要触发UI刷新
 */
export class ScreenSizeChangeEvent extends BaseEvent {
}

/**
 * 锁屏通知折叠展开状态事件
 */
export class SetNtfExpandCollapseEvent extends BaseEvent {
  /**
   * 通知展开状态
   */
  public isExpand: boolean = true;
}

/**
 * 时钟内部样式布局刷新事件
 */
export class UpdateClockParamEvent extends BaseEvent {
}

/**
 * 时钟折叠刷新组件内布局后，触发时钟网格信息事件
 */
export class AfterClockCollapseEvent extends BaseEvent {
}

/**
 * 进入主页编辑态（1、点击卡片),提交主页状态机时间
 */
export class FormEnterEditCardEvent extends BaseEvent {
}

/**
 * 卡片加载成功事件
 */
export class FormCardSuccessEvent extends BaseEvent {
}
