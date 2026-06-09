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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { START_ABILITY_EVENT, START_SERVICE_EXT_EVENT } from './EventUtil';
import type { EventParser, Event, LocalEvent } from './EventUtil';
import { Callback, createEventBus, EventBus } from './EventBus';

export type unsubscribe = () => void;

export type Events = string | string[];

const TAG = 'EventManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class EventConstants {
  static readonly CONTROL_CENTER_BACK = 'ControlCenterBack';
  static readonly CONTROL_CENTER_EDIT_BACK = 'ControlCenterEditBack';
  static readonly RING_MODE_EVENT = 'RingModeEvent';
  static readonly SCREEN_LOCK_BEGIN_SLEEP = 'ScreenLockBeginSleep';
  static readonly SCREEN_LOCK_END_DISPLAY_ON = 'ScreenLockEndDisplayOn';
  static readonly SCREEN_LOCK_EXIT = 'ScreenLockExit';
  static readonly BACK_GESTURE = 'BackGesture';

  static readonly SCREEN_LOCK_NOTIFICATION_CHANGE = 'ScreenLockNotificationChange';
  static readonly EVENT_PACKAGE_CHANGED = 'usual.event.PACKAGE_CHANGED';

  static readonly STATUS_BAR_DROPDOWN_TOUCH = 'StatusBarDropdownTouch';
  static readonly STATUS_BAR_DROPDOWN_FINGER_PRINT = 'StatusBarDropdownFingerPrint';
  static readonly STATUS_BAR_DROPDOWN_PAN = 'StatusBarDropdownPan';
  static readonly STATUS_BAR_TIME_VIEW_AREA = 'StatusBarTimeViewArea';
  static readonly GESTURE_TOP_BAR_DROPDOWN_PAN = 'GestureTopBarDropdownPan';

  static readonly CONTROL_CENTER_SHOW_HIDE_BAR = 'ControlCenter_Show_Hide_Bar';
  static readonly EVENT_REFRESH_SMALL_FOLDER_IMAGE = 'launcher.event.REFRESH_SMALL_FOLDER_IMAGE';

  static readonly DESKTOP_CLOCK_ANIMATION_START = 'DESKTOP_CLOCK_ANIMATION_START';
  static readonly SCREEN_LOCK_CLOCK_STYLE_CHANGED = 'SCREEN_LOCK_CLOCK_STYLE_CHANGED';

  // 版本校验完成 图标刷新
  static readonly EVENT_REFRESH_ICON_IMAGE: string = 'launcher.event.REFRESH_ICON_IMAGE';
  // 版本校验完成 快捷图标刷新
  static readonly EVENT_REFRESH_SHORTCUT_IMAGE: string = 'launcher.event.REFRESH_SHORTCUT_IMAGE';
  // 跳转到编辑页面
  static readonly EVENT_JUMP_TO_EDIT_MODE_PAGE: string = 'launcher.event.JUMP_TO_EDIT_MODE_PAGE';

  // desktop icon menu event when long pressing
  static EVENT_DESKTOP_MENU_EVENT = 'usual.event.DESKTOP_MENU_EVENT';

  static EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH = 'EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH'; // pageDesktop refresh
  // folder close component events
  static EVENT_FOLDER_CLOSING = 'usual.event.EVENT_FOLDER_CLOSING';

  static readonly START_SERVICE = 'EventManager.startService';

  static readonly START_SERVICE_EXT = 'EventManager.startServiceExt';
  static readonly EVENT_ICON_RESOURCE_REFRESH = 'launcher.event.EVENT_ICON_RESOURCE_REFRESH';
}

class EventManager {
  mEventBus: EventBus<string>;
  eventParser: EventParser;

  constructor() {
    this.mEventBus = createEventBus();
    this.eventParser = {
      local: this.publishLocalEvent,
      ability: this.startAbility,
      serviceExt: this.startServiceExt,
      commonEvent: this.publishCommonEvent,
      remote: this.publishRemoteEvent,
    };
  }

  publish(event: Event): boolean {
    return this.eventParser[event.target].call(this, event.data);
  }

  subscribe(eventType: Events, callback: Callback): unsubscribe {
    return this.mEventBus.on(eventType, callback);
  }

  off(eventType: Events, callback: Callback): void {
    this.mEventBus.off(eventType, callback);
  }

  subscribeOnce(eventType: string, callback: Callback): unsubscribe {
    return this.mEventBus.once(eventType, callback);
  }

  private publishLocalEvent(data: LocalEvent): boolean {
    log.showDebug(`publish localEvent type: ${data.eventName}`);
    if (data.eventName) {
      this.mEventBus.emit(data.eventName, data.args);
      return true;
    }
    return false;
  }

  private startAbility(data: { [key: string]: any }): boolean {
    log.showDebug(`start Ability: ${data.abilityName}`);
    if (data.bundleName && data.abilityName) {
      this.mEventBus.emit(START_ABILITY_EVENT, { abilityName: data.abilityName });
      // 以下逻辑拆解到windowscene模块中，通过事件通知方式来完成对StartAbilityUtil功能的解耦，
      this.mEventBus.emit(EventConstants.START_SERVICE, {
        bundleName: data.bundleName,
        abilityName: data.abilityName,
        moduleName: data.moduleName ?? undefined,
        uri: data.uri ?? undefined,
        parameters: data.parameters ?? undefined
      });
      return true;
    }
    return false;
  }

  private startServiceExt(data: { [key: string]: any }): boolean {
    log.showDebug(`start ServiceExt: ${data.abilityName}`);
    if (data.bundleName && data.abilityName) {
      this.mEventBus.emit(START_SERVICE_EXT_EVENT, { abilityName: data.abilityName });
      this.mEventBus.emit(EventConstants.START_SERVICE_EXT, {
        bundleName: data.bundleName,
        abilityName: data.abilityName,
        parameters: data.parameters ?? undefined
      });
      return true;
    }
    return false;
  }

  private publishRemoteEvent(data: { [key: string]: unknown }): boolean {
    // todo publish to remote device
    return false;
  }

  private publishCommonEvent(data: { [key: string]: any }): boolean {
    // todo publish commonEvent to other app
    return false;
  }
}

export let sEventManager = SingletonHelper.getInstance(EventManager, TAG);