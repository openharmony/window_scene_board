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
import { DragConstants } from '@ohos/commonconstants';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { dragControllerUtil, DragControllerParams } from '@ohos/componenthelper/Index';
import { TouchEvent } from 'touchEvent';

const TAG: string = 'DragTriggerUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const DRAG_TRIGGER_DISTANCE: number = 1;
const DRAG_TRIGGER_DISTANCE_PAN: number = 8;

/**
 * 拖拽触发工具类，仅适用于pc桌面场景，当前触发逻辑为按下后移动1vp
 */
export class DragTriggerUtil {
  private triggerX: number = 0;
  private triggerY: number = 0;
  private isPreparing: boolean = false;
  private isTriggering: boolean = false;
  private params: DragControllerParams = {};
  private dragItemRect: Rectangle | undefined = undefined;
  private dragTriggerDistance: number = DRAG_TRIGGER_DISTANCE;

  /**
   * 初始化拖拽相关参数
   */
  public initDragParams(params: DragControllerParams): void {
    this.params = params;
  }

  public getDragParams(): DragControllerParams {
    return this.params;
  }

  public setDragItemRect(rect: Rectangle): void {
    if (!rect) {
      log.showError('setDragItemRect rect invalid');
      return;
    }
    this.dragItemRect = rect;
  }

  public getDragItemRect(): Rectangle | undefined {
    return this.dragItemRect;
  }

  public resetDragItemRect(): void {
    this.dragItemRect = undefined;
  }

  /**
   * 触发拖拽行为前预处理
   */
  public preDragTrigger(event: TouchEvent): void {
    if (!event) {
      log.showWarn('preDragTrigger event invalid');
      return;
    }
    if (!event.touches || !event.touches[0]) {
      // 触摸事件中touches为空时，打印整个touches信息，用于与ArkUI定界
      log.showWarn('preDragTrigger interrupt with invalid touches: %{public}s', JSON.stringify(event.touches));
      return;
    }
    let x: number = event.touches[0].windowX;
    let y: number = event.touches[0].windowY;
    if (event.type === TouchType.Down) {
      this.prePareDragTrigger(x, y);
    }
    if (event.type === TouchType.Move) {
      this.dragTriggerDistance = event.sourceTool === SourceTool.Pen ? DRAG_TRIGGER_DISTANCE_PAN :
        DRAG_TRIGGER_DISTANCE;
      this.executeDragTrigger(x, y);
    }
    if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      this.resetDragTrigger();
    }
  }

  private prePareDragTrigger(x: number, y: number): void {
    this.triggerX = x;
    this.triggerY = y;
    this.updatePrepareStatus(true);
  }

  private executeDragTrigger(x: number, y: number): void {
    if (this.checkDragTrigger(x, y)) {
      this.isTriggering = true;
      dragControllerUtil.executeDrag(this.params, this.triggerX, this.triggerY);
    }
  }

  private resetDragTrigger(): void {
    this.isTriggering = false;
    this.params = {};
    this.updatePrepareStatus(false);
  }

  private checkDragTrigger(x: number, y: number): boolean {
    let distance: number = Math.hypot(this.triggerX - x, this.triggerY - y);
    return distance > this.dragTriggerDistance;
  }

  private updatePrepareStatus(isPreparing: boolean): void {
    this.isPreparing = isPreparing;
    GlobalContext.getContext()?.eventHub.emit(DragConstants.DRAG_PREPARE_STATUS_CHANGE_EVENT, this.isPreparing);
  }

  /**
   * 获取拖拽准备状态
   */
  public getPrepareStatus(): boolean {
    return this.isPreparing;
  }

  /**
   * 获取拖拽触发状态
   */
  public getTriggerStatus(): boolean {
    return this.isTriggering;
  }
}

export const dragTriggerUtil: DragTriggerUtil = SingletonHelper.getInstance(DragTriggerUtil, TAG);