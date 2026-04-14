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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import lazy { scbEventExclusiveManager, EventType } from '@ohos/windowscene';
import { threadCall, ThreadCallType } from '../messageChannel/ThreadCall';

const TAG = 'SCBEventExclusiveManagerAdapter';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

interface EventExclusiveCallback {
  caller: EventType;
  restoreCallBack?: () => void;
}

export class SCBEventExclusiveManagerAdapter {
  private static isSetStatusBarEventExclusive: boolean = false;

  @threadCall()
  public static setEventExclusive(caller: EventType, isExclusive: boolean): void {
    scbEventExclusiveManager.setEventExclusive(caller, isExclusive);
  }

  public static setStatusBarEventExclusive(): void {
    if (SCBEventExclusiveManagerAdapter.isSetStatusBarEventExclusive) {
      return;
    }
    SCBEventExclusiveManagerAdapter.setEventExclusive(EventType.GESTURE_STATUS_BAR, true);
    SCBEventExclusiveManagerAdapter.isSetStatusBarEventExclusive = true;
  }

  public static clearStatusBarEventExclusive(): void {
    if (!SCBEventExclusiveManagerAdapter.isSetStatusBarEventExclusive) {
      return;
    }
    SCBEventExclusiveManagerAdapter.setEventExclusive(EventType.GESTURE_STATUS_BAR, false);
    SCBEventExclusiveManagerAdapter.isSetStatusBarEventExclusive = false;
  }

  @threadCall()
  public static getEventExclusiveByCaller(caller: EventType): boolean | Promise<boolean> {
    return scbEventExclusiveManager.getEventExclusiveByCaller(caller);
  }

  @threadCall()
  public static restoreAllEventExclusive(caller: EventType): void {
    scbEventExclusiveManager.restoreAllEventExclusive(caller);
  }

  @threadCall(ThreadCallType.Register)
  public static registerEventExclusive(eventExclusiveCallback: EventExclusiveCallback, tag: string): void {
    log.showInfo(`registerEventExclusive tag ${tag}`)
    scbEventExclusiveManager.registerEventExclusive(eventExclusiveCallback.caller, eventExclusiveCallback.restoreCallBack);
  }

  @threadCall(ThreadCallType.UnRegister)
  public static unRegisterEventExclusive(eventExclusiveCallback: EventExclusiveCallback, tag: string): void {
    log.showInfo(`unRegisterEventExclusive caller ${eventExclusiveCallback.caller} tag ${tag}`)
    return scbEventExclusiveManager.unRegisterEventExclusive(eventExclusiveCallback.caller);
  }
}