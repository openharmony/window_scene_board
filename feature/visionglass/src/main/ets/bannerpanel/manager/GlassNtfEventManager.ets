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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { EventManager, EvtBus } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { NotificationEntryEvent } from '@ohos/notificationcomponent/src/main/ets/common/event/NotificationEvent';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, 'GlassNtfEventManager');

export class GlassNtfEventManager {
  private static instance?: GlassNtfEventManager;
  private eventMgr: EventManager = EvtBus.createEventManager();

  private constructor() {
  }

  public static getInstance(): GlassNtfEventManager {
    if (!GlassNtfEventManager.instance) {
      log.showInfo(`getInstance new instance`);
      GlassNtfEventManager.instance = new GlassNtfEventManager();
    }
    return GlassNtfEventManager.instance;
  }

  public static destroyInstance(): void {
    log.showInfo(`destroyInstance`);
    GlassNtfEventManager.instance?.destroy();
    GlassNtfEventManager.instance = undefined;
  }

  private destroy(): void {
    this.eventMgr.offAll();
  }

  /**
   * 注册接收通知的回调
   * @param callBack
   */
  public registerNtfEventCallBack(callBack: (event: NotificationEntryEvent) => void): void {
    log.info(`registerNtfEventCallBack`);
    this.eventMgr.on(NotificationEntryEvent, callBack);
  }
}