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
import { DragGridPosition } from '../../../../TsIndex';
import { State, StateTransition, StateTransitionResult } from '../../common/utils/statemachine/StateMachine';
import { SqueezeCheckResult } from '../../common/type/SqueezeTypes';
import { SqueezeMachineContext, SqueezeStateType } from './SqueezeMachineContext';
import type { SqueezeParams } from '../../common/type/SqueezeTypes';
import { DragUtils } from '../../common/utils/DragUtils';

const TAG = 'Drag-MoveState';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);

/**
 * 移动状态实现
 */
export class MoveState extends State {
  private params: SqueezeParams;
  private gridPosition?: DragGridPosition;

  constructor(userParams: SqueezeParams) {
    super(SqueezeStateType.MOVE_STATE);

    this.params = userParams;

    this.addTransition(new StateTransition(SqueezeStateType.FINISH_STATE, (ctx) => this.toFinishState(ctx)));
    this.addTransition(new StateTransition(SqueezeStateType.SQUEEZE_STATE, (ctx) => this.toSqueezeState(ctx)));
    this.addTransition(new StateTransition(SqueezeStateType.COMBINE_STATE, (ctx) => this.toCombineState(ctx)));
  }

  private toSqueezeState(ctx: object): StateTransitionResult {
    if (!(ctx instanceof SqueezeMachineContext)) {
      log.showError('invalid context');
      return StateTransitionResult.ERROR;
    }
    if (!ctx.isSlow()) {
      log.showInfo('fast to continue');
      return StateTransitionResult.CONTINUE;
    }
    if (ctx.getSqueezeCheckResult() === SqueezeCheckResult.SQUEEZE) {
      log.showInfo('to squeeze state');
      return StateTransitionResult.TRANSITION;
    }
    return StateTransitionResult.CONTINUE;
  }

  private toCombineState(ctx: object): StateTransitionResult {
    if (!(ctx instanceof SqueezeMachineContext)) {
      log.showError('invalid context');
      return StateTransitionResult.ERROR;
    }
    if (!ctx.isSlow()) {
      log.showInfo('fast to continue');
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

  private triggerMoveCallback(ctx: SqueezeMachineContext): void {
    log.showInfo(`trigger move callback. ctx:${ctx.toString()}`);
    if (ctx.getCoveredItem() != null) {
      const blankGridPosition = DragUtils.getAvailableGridPosition(ctx.getDragInfo().dragItem[0], ctx.getDragLayout(),
        ctx.getGridPosition());
      ctx.setGridPosition(blankGridPosition);
    }
    if (!DragUtils.isGridPositionEqual(this.gridPosition, ctx.getGridPosition())) {
      this.gridPosition = ctx.getGridPosition();
      this.params.itemMoveCallback?.(ctx.getCallbackParam(), ctx.getCoveredItem());
    }
  }

  public afterTransition(ctx: object, stateName: string): void {
    if (!(ctx instanceof SqueezeMachineContext)) {
      return;
    }
    if (stateName === this.getName()) {
      this.triggerMoveCallback(ctx);
    } else {
      this.gridPosition = undefined;
    }
  }

  public onTransitionTo(ctx: object): void {
    if (!(ctx instanceof SqueezeMachineContext)) {
      return;
    }
    this.triggerMoveCallback(ctx);
  }
}