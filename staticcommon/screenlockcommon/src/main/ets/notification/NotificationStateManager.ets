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
import { ComponentType } from '../base/BaseMeshViewModel';
import { screenLockInnerStateManager } from '../base/ScreenLockInnerStateManager';
import { MeshRange} from '../meshsystem/MeshSystem';
import { KeyguardStatusService } from '../manager/KeyguardStatusService';

const TAG = 'NotificationStateManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export type OnClockAnimInterruptListener = () => void; // 时钟动效打断监听

export class NotificationState {
  public meshRange?: MeshRange;
  public isBottomAlign: boolean = false;
  public isClockVisible: boolean = true; // 时钟元素是否显示
  public velY: number = 0; // 竖直方向速度
  public isClockAnimDelay: boolean = false; // 时钟元素是否存在延时动效
  public isDisableDelay: boolean = false; // 是否关闭时钟延时效果
  public interruptClockAnimListener?: OnClockAnimInterruptListener; // 时钟形态切换动效打断监听
}

/**
 * Notification State Manager.
 */
export class NotificationStateManager {
  private static instance: NotificationStateManager;
  private isHideLiveViewContent: boolean = false; // 锁定时是否隐藏实况通知内容
  public notificationState: NotificationState = new NotificationState();

  constructor() {
  }

  /**
   * notification state manager instance
   */
  public static getInstance(): NotificationStateManager {
    if (!NotificationStateManager.instance) {
      NotificationStateManager.instance = new NotificationStateManager();
    }
    return NotificationStateManager.instance;
  }

  /**
   * 更新跟手速度
   *
   * @param velY 速度
   */
  public updateTouchVelocityY(velY: number = 0): void {
    this.notificationState.velY = velY;
  }

  /**
   * 更新时钟时延开关
   *
   * @param isDisableDelay 是否关闭时钟延时效果
   */
  public updateDisableDelay(isDisableDelay: boolean = false): void {
    this.notificationState.isDisableDelay = isDisableDelay;
  }

  /**
   * 更新时钟元素动效延时状态
   *
   * @param isDelay 是否含有延时动效
   */
  public updateClockAnimDelayState(isDelay: boolean = false): void {
    this.notificationState.isClockAnimDelay = isDelay;
  }

  /**
   * 更新时钟元素打断动效监听器
   *
   * @param listener 监听器
   */
  public updateInterruptClockAnimListener(listener?: OnClockAnimInterruptListener): void {
    this.notificationState.interruptClockAnimListener = listener;
  }

  /**
   * 请求打断时钟形态切换动效
   */
  public requestInterruptClockAnim(): void {
    this.notificationState.interruptClockAnimListener?.();
  }

  /**
   * 设置锁定时是否显示实况窗内容开关状态
   */
  public getHideLiveViewFlag(): boolean {
    return this.isHideLiveViewContent;
  }

  /**
   * 获取锁定时是否显示实况窗内容开关状态
   */
  public setHideLiveViewFlag(isHide: boolean): void {
    this.isHideLiveViewContent = isHide;
  }

  /**
   * 通知区域网格范围回调
   *
   * @param notificationMeshRange 请求网格范围
   * @param resultCallback 回调可提供网格范围
   */
  public async requestNotificationMeshRange(notificationMeshRange: MeshRange,
    resultCallback: (notificationState: NotificationState) => void): Promise<void> {
    log.showWarn(`requestNotificationMeshRange param: rangeStart ${notificationMeshRange.getRangeStart()}, rangeEnd ${notificationMeshRange.getRangeEnd()}`);
    if (KeyguardStatusService.isSlGreetMode()) {
      log.showInfo('requestNotificationMeshRange requestUseMesh rejected, need to show greetModel');
      return;
    }
    try {
      await screenLockInnerStateManager.requestUseMesh(ComponentType.CENTER_CONTENT, notificationMeshRange,
        (result) => {
          log.showInfo(`requestNotificationMeshRange requestUseMesh is rangeStart ${result?.rangeStart}, rangeEnd ${result?.rangeEnd}`);
          this.notificationState.meshRange = result;
          resultCallback(this.notificationState);
        });
    } catch (err) {
      log.showError(`requestNotificationMeshRange fails error: ${err}`);
    }
  }
}

let screenLockNotificationManager: NotificationStateManager = NotificationStateManager.getInstance();

export default screenLockNotificationManager as NotificationStateManager;