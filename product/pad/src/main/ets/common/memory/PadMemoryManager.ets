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
import { MemoryManager } from '@ohos/frameworkcommon';
import { SCBOobeManager } from '@ohos/windowscene';
import { localEventManager } from '@ohos/frameworkwrapper';
import {
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import { ReceiveEventInfo } from '@ohos/launchercommon';

const TAG: string = 'PadMemoryManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const SCREEN_OFF_GC_TIME_OUT: number = 3 * 60 * 1000;

enum SCBScreenPowerEventType {
  WAKE_UP = 0,
  SLEEP = 1,
  DISPLAY_ON = 2,
  DISPLAY_OFF = 3,
  DESKTOP_READY = 4,
}

enum SCBScreenPowerEventStatus {
  BEGIN = 0,
  END = 1,
}

export class SCBScreenPowerEvent {
  public eventType: SCBScreenPowerEventType = SCBScreenPowerEventType.WAKE_UP;
  public eventStatus: SCBScreenPowerEventStatus = SCBScreenPowerEventStatus.BEGIN;
  public changeReason: number = 0;
}

/**
 * PAD内存监听业务
 */
export class PadMemoryManager {
  private timerId: number | undefined = undefined;

  private static instance: PadMemoryManager | null = null;

  private handlePowerEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, powerEvent: SCBScreenPowerEvent) => {
      this.updateScreenPowerState(powerEvent.eventType, powerEvent.eventStatus);
    }
  }

  /**
   * 获取桌面应用信息管理对象
   *
   * @return 桌面应用信息管理对象单一实例
   */
  public static getInstance(): PadMemoryManager {
    if (PadMemoryManager.instance === null) {
      PadMemoryManager.instance = new PadMemoryManager();
    }
    return PadMemoryManager.instance;
  }

  private constructor() {
  }

  public init(): void {
    localEventManager.registerEventListener(this.handlePowerEventListener, ['SCBScreen_ScreenPowerEvent']);
  }

  public updateScreenPowerState(displayPowerEvent: SCBScreenPowerEventType,
    eventStatus: SCBScreenPowerEventStatus): void {
    if (displayPowerEvent === SCBScreenPowerEventType.DISPLAY_OFF &&
      eventStatus === SCBScreenPowerEventStatus.END) {
      this.handleScreenOffEvent();
    } else if (displayPowerEvent === SCBScreenPowerEventType.DISPLAY_ON &&
      eventStatus === SCBScreenPowerEventStatus.BEGIN) {
      this.handleScreenOnEvent();
    }
  }

  /**
   * 处理电源亮屏事件
   */
  private handleScreenOnEvent(): void {
    log.showInfo('handleScreenOnEvent');
    MemoryManager.getInstance().updateStaticMemoryScene(false);
    this.stopTimer();
  }

  /**
   * 处理电源灭屏事件
   */
  private handleScreenOffEvent(): void {
    log.showInfo('handleScreenOffEvent');
    if (SCBOobeManager.isOobeActivated()) {
      log.showInfo('handleScreenOffEvent isOobe stage, return');
      return;
    }
    this.stopTimer();
    this.timerId = setTimeout(() => {
      this.timerId = undefined;
      MemoryManager.getInstance().updateStaticMemoryScene(true);
      MemoryManager.getInstance().notifyClearScreenOff();
    }, SCREEN_OFF_GC_TIME_OUT);
  }

  private stopTimer(): void {
    log.showInfo(`stopTimer timerId: ${this.timerId}`);
    if (this.timerId) {
      clearTimeout(this.timerId);
      this.timerId = undefined;
    }
  }
}
