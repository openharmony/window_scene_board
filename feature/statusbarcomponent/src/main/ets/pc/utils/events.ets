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
import { PluginInfo } from '@ohos/frameworkwrapper';

/**
 * 图标自定义事件
 */
export class StatusBarCustomEvent {
  public eventType: CustomEventType = 'none';
  // 事件触发者
  public slot: string = '';
  // 作用于name对应的图标
  public actsOn: string = '';
  public event: CustomEvent;
  public isHovered?: boolean;

  constructor(event: CustomEvent, slot: string, actsOn: string,
    eventType: CustomEventType, isHovered?: boolean) {
    this.event = event;
    this.slot = slot;
    this.actsOn = actsOn;
    this.eventType = eventType;
    this.isHovered = isHovered;
  }

  public static createEvent(event: CustomEvent, slot: string, actsOn: string, eventType: CustomEventType,
    isHovered?: boolean): StatusBarCustomEvent {
    return new StatusBarCustomEvent(event, slot, actsOn, eventType, isHovered);
  }
}

export type CustomEvent = ClickEvent | boolean | TouchEvent | GestureEvent | MouseEvent | HoverEvent;

export type CustomEventType = 'none' | 'click' | 'hover' | 'touch' | 'gesture' |
'doubleClick' | 'longClick' | 'rightClick' | 'mouse';

/**
 * 图标位置变更事件
 */
export class PluginAreaEvent {
  public slot: string = '';
  public area?: Area;

  constructor(slot: string, area?: Area) {
    this.slot = slot;
    this.area = area;
  }

  public static createEvent(slot: string, area?: Area): PluginAreaEvent {
    return new PluginAreaEvent(slot, area);
  }
}

/**
 * 胶囊排序事件
 */
export class CapsuleSortEvent {
  public position: string = '';

  constructor(pos: string) {
    this.position = pos;
  }

  public static createEvent(pos: string): CapsuleSortEvent {
    return new CapsuleSortEvent(pos);
  }
}

/**
 * 二级面板变更事件
 */
export class PanelChangeEvent {
  public eventType: PanelChangeEventType = 'none';
  public panelInfos: PluginInfo[] = [];
  public tokenId?: number;
  public instanceKey?: string;
  public height?: number;

  constructor(type: PanelChangeEventType, panelInfos: PluginInfo[],
    tokenId?: number, instanceKey?: string, height?: number) {
    this.eventType = type;
    this.panelInfos = panelInfos;
    this.tokenId = tokenId;
    this.instanceKey = instanceKey;
    this.height = height;
  }
}

export type PanelChangeEventType = 'none' | 'dynamic' | 'access';

/**
 * 状态栏图标拖拽事件
 */

export class PluginDragEvent {
  public isAccessPlugin: boolean = true;
  public slot: string = '';

  constructor(isAccess: boolean, slot: string) {
    this.isAccessPlugin = isAccess;
    this.slot = slot;
  }
}
