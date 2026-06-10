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
import { DragGridItem } from '../../common/type/CommonTypes';
import { SqueezeCheckResult, SqueezeParams } from '../../common/type/SqueezeTypes';

const TAG = 'Drag-CombineState';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);

/**
 * 合并状态实现
 */
export class CombineState extends State {
  private params: SqueezeParams;
  private coveredItem?: DragGridItem;

  constructor(userParams: SqueezeParams) {
    super(SqueezeStateType.COMBINE_STATE);

    this.params = userParams;

    this.addTransition(new StateTransition(SqueezeStateType.FINISH_STATE, (ctx) => this.toFinishState(ctx)));
    this.addTransition(new StateTransition(SqueezeStateType.MOVE_STATE, (ctx) => this.toMoveState(ctx)));
    this.addTransition(new StateTransition(SqueezeStateType.SQUEEZE_STATE, (ctx) => this.toSqueezeState(ctx)));
  }

  private toMoveState(ctx: object): StateTransitionResult {
    if (!(ctx instanceof SqueezeMachineContext)) {
      log.showError('invalid context');
      return StateTransitionResult.ERROR;
    }
    if (!ctx.isSlow() && this.coveredItem !== ctx.getCoveredItem()) {
      log.showInfo('fast to move state');
      return StateTransitionResult.TRANSITION;
    }
    if (ctx.getCoveredItem() == null || ctx.getSqueezeCheckResult() === SqueezeCheckResult.MOVE) {
      log.showInfo(`to move state. hasCoveredItem: ${ctx.getCoveredItem() != null}`);
      return StateTransitionResult.TRANSITION;
    }
    return StateTransitionResult.CONTINUE;
  }

  private toSqueezeState(ctx: object): StateTransitionResult {
    if (!(ctx instanceof SqueezeMachineContext)) {
      log.showError('invalid context');
      return StateTransitionResult.ERROR;
    }
    if (ctx.getSqueezeCheckResult() === SqueezeCheckResult.SQUEEZE) {
      log.showInfo('to squeeze state');
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

  private triggerCallback(ctx: SqueezeMachineContext): void {
    log.showInfo(`trigger combine callback. ctx:${ctx.toString()}`);
    this.coveredItem = ctx.getCoveredItem();
    this.params.itemCombineCallback?.(ctx.getCallbackParam(), this.coveredItem);
  }

  public afterTransition(ctx: object, stateName: string): void {
    if (!(ctx instanceof SqueezeMachineContext)) {
      return;
    }
    if (stateName === this.getName()) {
      if (this.coveredItem !== ctx.getCoveredItem()) {
        this.triggerCallback(ctx);
      }
    } else {
      this.params.itemCancelCombineCallback?.(ctx.getCallbackParam(), this.coveredItem);
      this.coveredItem = undefined;
    }
  }

  public onTransitionTo(ctx: object): void {
    if (!(ctx instanceof SqueezeMachineContext)) {
      return;
    }
    this.triggerCallback(ctx);
  }
}