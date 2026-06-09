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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { State, StateTransition, StateTransitionResult } from '../../common/utils/statemachine/StateMachine';
import { SqueezeMachineContext, SqueezeStateType } from './SqueezeMachineContext';
import { SqueezeCheckResult, SqueezeResult, SqueezeParams } from '../../common/type/SqueezeTypes';
import { DragGridItem, DragGridPosition } from '../../common/type/CommonTypes';
import { DragUtils } from '../../common/utils/DragUtils';
import { ShareSqueezeStatus } from '../../common/share/ShareSqueezeStatus';
import { ShareDataManager } from '../../common/share/ShareDataManager';

const TAG = 'Drag-SqueezeState';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);

/**
 * 挤位状态类
 */
export class SqueezeState extends State {
  private params: SqueezeParams;
  private squeezeResult?: Map<DragGridItem, SqueezeResult>;
  private gridPosition?: DragGridPosition;
  private shareSqueezeStatus: ShareSqueezeStatus;

  constructor(userParams: SqueezeParams) {
    super(SqueezeStateType.SQUEEZE_STATE);

    this.params = userParams;
    this.shareSqueezeStatus = ShareDataManager.getInstance(ShareSqueezeStatus, 'ShareSqueezeStatus');

    this.addTransition(new StateTransition(SqueezeStateType.FINISH_STATE, (ctx) => this.toFinishState(ctx)));
    this.addTransition(new StateTransition(SqueezeStateType.MOVE_STATE, (ctx) => this.toMoveState(ctx)));
    this.addTransition(new StateTransition(SqueezeStateType.COMBINE_STATE, (ctx) => this.toCombineState(ctx)));
  }

  private toMoveState(ctx: object): StateTransitionResult {
    if (!(ctx instanceof SqueezeMachineContext)) {
      log.showError('invalid context');
      return StateTransitionResult.ERROR;
    }
    if (!ctx.isSlow() && !DragUtils.isGridPositionEqual(this.gridPosition, ctx.getGridPosition())) {
      log.showInfo('fast to move state');
      return StateTransitionResult.TRANSITION;
    }
    if (ctx.getCoveredItem() == null || ctx.getSqueezeCheckResult() === SqueezeCheckResult.MOVE) {
      log.showInfo(`to move state. hasCoveredItem: ${ctx.getCoveredItem() != null}`);
      return StateTransitionResult.TRANSITION;
    }
    return StateTransitionResult.CONTINUE;
  }

  private toCombineState(ctx: object): StateTransitionResult {
    if (!(ctx instanceof SqueezeMachineContext)) {
      log.showError('invalid context');
      return StateTransitionResult.ERROR;
    }
    // 已经触发挤位后只有落点变化才能再触发合并
    if (this.squeezeResult != null && this.squeezeResult.size > 0 &&
      DragUtils.isGridPositionEqual(this.gridPosition, ctx.getGridPosition())) {
      log.showInfo('continue squeeze with unchanging position');
      return StateTransitionResult.CONTINUE;
    }
    if (ctx.getSqueezeCheckResult() === SqueezeCheckResult.COMBINE) {
      log.showInfo('to combine state');
      return StateTransitionResult.TRANSITION;
    }
    return StateTransitionResult.CONTINUE;
  }

  private toFinishState(ctx: object): StateTransitionResult {
    if (!(ctx instanceof SqueezeMachineContext)) {
      log.showError('invalid context');
      return StateTransitionResult.ERROR;
    }
    if (ctx.isFinish()) {
      log.showInfo('to finish state');
      return StateTransitionResult.TRANSITION;
    }
    return StateTransitionResult.CONTINUE;
  }

  private triggerSqueezeCallback(ctx: SqueezeMachineContext): void {
    if (DragUtils.isGridPositionEqual(this.gridPosition, ctx.getGridPosition())) {
      return;
    }
    log.showInfo('trigger squeeze callback');
    this.gridPosition = ctx.getGridPosition();
    this.squeezeResult = this.params.squeezeEngineChain?.getSqueezeResult(ctx.getPosition().x, ctx.getPosition().y);
    log.showInfo(`squeezeResult length:${this.squeezeResult?.size} ${JSON.stringify(this.squeezeResult)}`);
    if (this.squeezeResult != null && this.squeezeResult.size > 0) {
      this.shareSqueezeStatus.startSqueeze();
      this.params.itemSqueezeCallback?.(ctx.getCallbackParam(), this.squeezeResult);
    } else {
      this.shareSqueezeStatus.stopSqueeze();
      const blankGridPosition = DragUtils.getAvailableGridPosition(ctx.getDragInfo().dragItem[0], ctx.getDragLayout(),
        ctx.getGridPosition());
      ctx.setGridPosition(blankGridPosition);
      this.params.itemMoveCallback?.(ctx.getCallbackParam(), ctx.getCoveredItem());
    }
  }

  public afterTransition(ctx: object, stateName: string): void {
    if (!(ctx instanceof SqueezeMachineContext)) {
      return;
    }
    if (stateName === this.getName()) {
      this.triggerSqueezeCallback(ctx);
    } else {
      this.shareSqueezeStatus.stopSqueeze();
      this.params.itemCancelSqueezeCallback?.(ctx.getCallbackParam(), this.squeezeResult);
      this.squeezeResult = undefined;
      this.gridPosition = undefined;
    }
  }

  public onTransitionTo(ctx: object): void {
    if (!(ctx instanceof SqueezeMachineContext)) {
      return;
    }
    this.triggerSqueezeCallback(ctx);
  }
}