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

import { AbstractInitialAble } from './AbstractInitialAble';

/**
 * 状态转移动作
 */
export interface StateTransferAction<T> {
  /**
   * 判断状态转移是否匹配
   */
  isStateTransferMatched: (oldState: T, newState: T) => boolean;

  /**
   * 是否立即执行动画
   */
  isAnimateImmediately?: boolean;

  /**
   * 动效参数：不设置即表示状态转移时不需要动效
   */
  animationParam?: AnimateParam;

  /**
   * 动效前准备动作
   */
  prepareAction?: () => void;

  /**
   * 目标动作
   */
  targetAction?: () => void;

  /**
   * 结束动作
   */
  finishAction?: () => void;
}

/**
 * 状态转移接口
 */
export abstract class StateTransferable<T> extends AbstractInitialAble {
  /**
   * 当前所处状态
   */
  private _currentState: T = 0 as T;

  /**
   * 状态转移动作表
   */
  private readonly _stateTransferActions: Set<StateTransferAction<T>> = new Set();

  public get currentState(): T {
    return this._currentState;
  }

  /**
   * 注册状态转移动作，通常父View调用
   */
  public registerStateTransferAction(stateTransferAction: StateTransferAction<T>): void {
    this._stateTransferActions.add(stateTransferAction);
  }

  /**
   * 注销状态转移动作，通常父View调用
   */
  public unRegisterStateTransferAction(stateTransferAction: StateTransferAction<T>): void {
    this._stateTransferActions.delete(stateTransferAction);
  }

  /**
   *
   * @param oldState 原状态
   * @param newState 新状态
   * @returns true 状态切换被执行；false未执行状态切换
   */
  public triggerStateTransferAction(oldState: T, newState: T): boolean {
    let ret: boolean = false;
    this._currentState = newState;
    for (let stateTransferAction of this._stateTransferActions) {
      if (stateTransferAction.isStateTransferMatched(oldState, newState)) {
        this.doStateTransferAction(stateTransferAction);
        ret = true;
      }
    }
    return ret;
  }

  /**
   * 执行释放逻辑
   */
  protected doRelease(): void {
    this._stateTransferActions.clear();
  }

  private doStateTransferAction(stateTransferAction: StateTransferAction<T>): void {
    stateTransferAction.prepareAction?.();
    if (stateTransferAction.animationParam) {
      // 动效场景
      if (stateTransferAction.isAnimateImmediately === true) {
        animateToImmediately(this.getAnimationParam(stateTransferAction), stateTransferAction.targetAction);
      } else {
        animateTo(this.getAnimationParam(stateTransferAction), stateTransferAction.targetAction);
      }
    } else {
      stateTransferAction.targetAction?.();
      stateTransferAction.finishAction?.();
    }
  }

  private getAnimationParam(stateTransferAction: StateTransferAction<T>): AnimateParam {
    return {
      duration: stateTransferAction.animationParam?.duration,
      tempo: stateTransferAction.animationParam?.tempo,
      curve: stateTransferAction.animationParam?.curve,
      delay: stateTransferAction.animationParam?.delay,
      iterations: stateTransferAction.animationParam?.iterations,
      playMode: stateTransferAction.animationParam?.playMode,
      onFinish: () => {
        // 需要调用各个地方的回调函数
        stateTransferAction.animationParam?.onFinish?.();
        stateTransferAction.finishAction?.();
      },
      finishCallbackType: stateTransferAction.animationParam?.finishCallbackType,
      expectedFrameRateRange: stateTransferAction.animationParam?.expectedFrameRateRange
    };
  }
}