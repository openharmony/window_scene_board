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

import lazy { localEventManager } from '@ohos/frameworkwrapper';
import { threadCall, ThreadCallType } from '../messageChannel/ThreadCall';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'LocalEventManagerAdapter';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export class EventConstants {
  static SYSTEM_BAR_CHANGE = 'usual.event.SYSTEM_BAR_CHANGE';
  static readonly EVENT_ICON_RESOURCE_REFRESH = 'launcher.event.EVENT_ICON_RESOURCE_REFRESH';
}

interface localEventManagerIntf {
  onReceiveEvent: Function;
}

export class LocalEventManagerAdapter {
  @threadCall()
  public static sendLocalEvent(event: string, params?: Object): void {
    localEventManager.sendLocalEvent(event, params);
  }

  @threadCall(ThreadCallType.Register)
  public static subscribeIconChangeEvent(listener: localEventManagerIntf, tag: string): void {
    log.showInfo(`subscribeIconChangeEvent tag ${tag}`);
    LocalEventManagerAdapter.registerEventListener(listener, [EventConstants.EVENT_ICON_RESOURCE_REFRESH]);
  }

  private static registerEventListener(listener: localEventManagerIntf, events: string[]): void {
    localEventManager.registerEventListener(listener, events);
  }
}