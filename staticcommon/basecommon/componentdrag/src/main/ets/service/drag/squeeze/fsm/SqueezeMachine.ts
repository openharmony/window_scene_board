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

import { Machine } from '../../common/utils/statemachine/StateMachine';
import { CombineState } from './CombineState';
import { FinishState } from './FinishState';
import { MoveState } from './MoveState';
import { SqueezeState } from './SqueezeState';
import { SqueezeMachineContext } from './SqueezeMachineContext';
import type { SqueezeParams } from '../../common/type/SqueezeTypes';
import type { DragEvent } from 'DragControllerParam';
import { ShareDataManager } from '../../common/share/ShareDataManager';
import { DragGridInfo, DragGridLayout, DragGridPosition, DragPosition } from '../../common/type/CommonTypes';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SpeedLimitUtil } from '../../common/utils/SpeedLimitUtil';
import { DragUtils } from '../../common/utils/DragUtils';
import { ShareDragStatus } from '../../common/share/ShareDragStatus';
import { ShareDragInfo } from '../../common/share/ShareDragInfo';
import { ShareDragLayout } from '../../common/share/ShareDragLayout';

const TAG = 'Drag-SqueezeMachine';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);
const SPEED_LIMIT = 0.04;
const SPEED_CHECK_TIMES = 3;

/**
 * 挤位状态机实现，衔接挤位管理模块和抽象状态机
 */
export class SqueezeMachine extends Machine {
  private ctx: SqueezeMachineContext = new SqueezeMachineContext();
  private speedLimitUtil: SpeedLimitUtil = new SpeedLimitUtil(SPEED_LIMIT, SPEED_CHECK_TIMES);
  private squeezeParams: SqueezeParams = null;
  private shareDragStatus: ShareDragStatus = ShareDataManager.getInstance(ShareDragStatus, 'ShareDragStatus');
  private shareDragInfo: ShareDragInfo = ShareDataManager.getInstance(ShareDragInfo, 'ShareDragInfo');
  private shareDragLayout: ShareDragLayout = ShareDataManager.getInstance(ShareDragLayout, 'ShareDragLayout');

  /**
   * 构造函数
   *
   * @param params 挤位参数
   */
  constructor(params: SqueezeParams) {
    super('Squeezer');
    this.squeezeParams = params;

    let starter = new MoveState(params);
    this.addState(starter);
    this.setStart(starter);
    this.addState(new CombineState(params));
    this.addState(new SqueezeState(params));
    this.addState(new FinishState(params));
  }

  /**
   * 初始化挤位状态
   *
   * @param event 拖拽事件
   * @param extraParams 拖拽额外参数
   */
  public initPosition(event: DragEvent, extraParams?: string): void {
    this.speedLimitUtil.setData(DragUtils.getDragPosition(event));
  }

  /**
   * 拖拽移动状态切换
   *
   * @param event 拖拽事件
   * @param extraParams 拖拽额外参数
   * @returns 是否完成状态切换
   */
  public moveStep(event: DragEvent, extraParams?: string): boolean {
    if (this.squeezeParams == null) {
      log.showError('cannot move without squeeze param');
      return false;
    }
    if (!this.shareDragStatus.isDragging()) {
      log.showError('move when not dragging');
      return false;
    }
    let dragInfo: DragGridInfo = this.shareDragInfo.getDragInfo();
    let dragLayout: DragGridLayout = this.shareDragLayout.getGridLayout();
    if (dragInfo == null || dragLayout == null) {
      log.showError('move with invalid dragItem or layout');
      return false;
    }
    const position: DragPosition = DragUtils.getDragPosition(event);
    const isSlowSpeed = this.speedLimitUtil.isSlowSpeed(position);
    const gridPosition: DragGridPosition =
      DragUtils.getNearestGridPosition(event, dragInfo.dragItem[0], dragLayout.gridParam);
    const coveredItem = DragUtils.getCoveredItem(dragLayout.layout, dragInfo.dragItem[0], gridPosition);
    this.ctx.setDragParams(event, extraParams)
      .setDragInfo(dragInfo)
      .setDragLayout(dragLayout)
      .setSlowSpeed(isSlowSpeed)
      .setPosition(position)
      .setGridPosition(gridPosition)
      .setCoveredItem(coveredItem);

    if (coveredItem != null && this.squeezeParams.itemCheckCallback) {
      log.showInfo(`moveStep coveredItem:${JSON.stringify(coveredItem)}`);
      let result = this.squeezeParams.itemCheckCallback(this.ctx.getCallbackParam(), coveredItem);
      this.ctx.setSqueezeCheckResult(result);
    }

    log.showInfo(`moveStep ctx:${this.ctx.toString()}`);
    super.stepRun(this.ctx);
    this.ctx.clear();
    return true;
  }

  /**
   * 切换到结束状态
   */
  public toFinish(): void {
    this.ctx.clear();
    super.stepRun(this.ctx);
  }
}