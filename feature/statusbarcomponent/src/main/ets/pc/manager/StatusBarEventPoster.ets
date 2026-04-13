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
import { StatusBarEventId, StatusBarEventManager } from './StatusBarEventManager';
import { CapsuleSortEvent, PanelChangeEvent, PluginAreaEvent, StatusBarCustomEvent } from '../utils/events';
import { InternalEventPoster, ExternalEventPoster } from '../utils/interfaces';
import { Event } from '@ohos/frameworkwrapper';


export default class StatusBarEventPoster implements InternalEventPoster, ExternalEventPoster {
  private static mInstance: StatusBarEventPoster;

  public static getInstance(): StatusBarEventPoster {
    if (!StatusBarEventPoster.mInstance) {
      StatusBarEventPoster.mInstance = new StatusBarEventPoster();
    }
    return StatusBarEventPoster.mInstance;
  }

  postClickEvent(event: ClickEvent, slot: string, actsOn: string): void {
    StatusBarEventManager.getInstance()
      .postSpecial(StatusBarEventId.CUSTOM_EVENT,
        StatusBarCustomEvent.createEvent(event, slot, actsOn, 'click', undefined));
  }

  postHoverEvent(event: HoverEvent, slot: string, actsOn: string, isHovered: boolean,
    sendTo?: string): void {
    StatusBarEventManager.getInstance()
      .postSpecial(StatusBarEventId.CUSTOM_EVENT,
        StatusBarCustomEvent.createEvent(event, slot, actsOn, 'hover', isHovered));

  }

  postTouchEvent(event: TouchEvent, slot: string, actsOn: string): void {
    StatusBarEventManager.getInstance()
      .postSpecial(StatusBarEventId.CUSTOM_EVENT,
        StatusBarCustomEvent.createEvent(event, slot, actsOn, 'touch', undefined));
  }

  postGestureEvent(event: GestureEvent, slot: string, actsOn: string): void {
    StatusBarEventManager.getInstance()
      .postSpecial(StatusBarEventId.CUSTOM_EVENT,
        StatusBarCustomEvent.createEvent(event, slot, actsOn, 'gesture', undefined));

  }

  postDoubleClickEvent(event: GestureEvent, slot: string, actsOn: string): void {
    StatusBarEventManager.getInstance()
      .postSpecial(StatusBarEventId.CUSTOM_EVENT,
        StatusBarCustomEvent.createEvent(event, slot, actsOn, 'doubleClick', undefined));

  }

  postLongClickEvent(event: GestureEvent, slot: string, actsOn: string): void {
    StatusBarEventManager.getInstance()
      .postSpecial(StatusBarEventId.CUSTOM_EVENT,
        StatusBarCustomEvent.createEvent(event, slot, actsOn, 'longClick', undefined));

  }

  postRightClickEvent(event: MouseEvent, slot: string, actsOn: string): void {
    StatusBarEventManager.getInstance()
      .postSpecial(StatusBarEventId.CUSTOM_EVENT,
        StatusBarCustomEvent.createEvent(event, slot, actsOn, 'rightClick', undefined));

  }

  postMouseEvent(event: MouseEvent, slot: string, actsOn: string): void {
    StatusBarEventManager.getInstance()
      .postSpecial(StatusBarEventId.CUSTOM_EVENT,
        StatusBarCustomEvent.createEvent(event, slot, actsOn, 'mouse', undefined));

  }

  postAreaEvent(slot: string, area?: Area): void {
    StatusBarEventManager.getInstance()
      .postSpecial(StatusBarEventId.PLUGIN_AREA_EVENT,
        PluginAreaEvent.createEvent(slot, area));
  }

  postCapsuleSortEvent(position: string): void {
    StatusBarEventManager.getInstance()
      .postSpecial(StatusBarEventId.CAPSULE_SORT_EVENT, CapsuleSortEvent.createEvent(position));
  }

  postPanelChangeEvent(event: PanelChangeEvent): void {
    StatusBarEventManager.getInstance().postSpecial(StatusBarEventId.PANEL_CHANGE_EVENT, event);
  }

  postExternalEvent<T>(event: Event<T>, data: T): void {
    StatusBarEventManager.getInstance().post(event, data);
  }
}