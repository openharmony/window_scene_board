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
import { CommonUtils } from '@ohos/basicutils';
import type { IState, StateType } from './BaseState';

/**
 * 状态切换监听器
 */
export interface OnStateChangeListener {
  /**
   * 状态切换回调
   *
   * @param state 状态
   */
  onStateChange: (state: IState) => void;

  /**
   * 扩展类型
   * 状态类型相同，可进一步区分扩展类型
   *
   * @returns 扩展类型
   */
  getExtendType?: () => number;
}

/**
 * 状态监听注册器
 */
export class StateListenerRegister {
  /**
   * 状态监听集
   */
  private stateListeners: Map<StateType, Set<OnStateChangeListener>> = new Map();

  /**
   * 注册状态监听
   *
   * @param type 状态类型
   * @param listener 监听器
   * @returns 快速注销监听
   */
  registerStateChangeListener(type: StateType, listener: OnStateChangeListener): () => void {
    let listeners = this.stateListeners.get(type);
    if (CommonUtils.isInvalid(listeners)) {
      listeners = new Set();
      this.stateListeners.set(type, listeners);
    }
    listeners?.add(listener);
    return () => this.unregisterStateChangeListener(type, listener);
  }

  /**
   * 注销状态监听
   *
   * @param type 状态类型
   * @param listener 监听器
   */
  unregisterStateChangeListener(type: StateType, listener: OnStateChangeListener): void {
    this.stateListeners.get(type)?.delete(listener);
  }

  /**
   * 通知状态变化
   *
   * @param state 状态数据
   */
  notifyStateChange(state: IState | undefined): void {
    if (CommonUtils.isInvalid(state) || !state) {
      return;
    }

    // 数据存在扩展类型，则需要匹配扩展类型才会回调
    let dataExtendType = state.getExtendType?.();
    this.stateListeners.get(state.getStateType())?.forEach((listener) => {
      let extendType = listener?.getExtendType?.();
      if (CommonUtils.isInvalid(dataExtendType) || CommonUtils.equals(dataExtendType, extendType)) {
        listener?.onStateChange?.(state);
      }
    });
  }
}