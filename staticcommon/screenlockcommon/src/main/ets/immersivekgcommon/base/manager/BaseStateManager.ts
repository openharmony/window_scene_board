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
import { LimitMap } from '../utils/LimitMap';
import { StateType } from '../constants/BaseType';
import { IBaseState } from '../interface/IBaseState';
import { IBaseStateChangeListener, IStateTag } from '../interface/IBaseStateChangeListener';

const TAG = 'BaseStateManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 状态管理基类，共享中心
 */
export class BaseStateManager {
  // 管理中心标识
  private readonly mgrName: string;
  // 状态集
  private readonly allState: LimitMap<string, IBaseState> = new LimitMap();
  // 状态切换监听集
  private readonly allListeners: LimitMap<string, Set<IBaseStateChangeListener>> = new LimitMap();
  // 状态回调统一管理
  private readonly stateChangeListener: IBaseStateChangeListener = {
    listenerName: TAG,
    onStateChange: (stateType: StateType, stateId: string, property?: string) => {
      this.allListeners.get(this.getTypeIdKey(stateType, stateId))?.forEach((listener) => {
        listener?.onStateChange(stateType, stateId, property);
      });
    }
  };

  constructor(mgrName: string) {
    this.mgrName = mgrName;
    this.stateChangeListener.listenerName = mgrName;
  }

  /**
   * 状态加入共享中心
   *
   * @param state 状态
   * @returns true 添加成功
   */
  public addState(state: IBaseState): boolean {
    if (!state) {
      return false;
    }
    let key = this.getTypeIdKey(state.getStateType(), state.getStateId());
    if (this.allState?.has(key)) {
      log.showWarn(`${this.mgrName} addState ${key} has exist, del it before add.`);
      return false;
    }
    // 状态切换统一管理
    state.registerStateChangeListener?.(this.stateChangeListener);
    this.allState.set(key, state);
    return true;
  }

  /**
   * 获取状态
   *
   * @param stateType 状态类型
   * @param stateId 状态id
   * @returns 目标状态实例
   */
  public getState(stateType: StateType, stateId: string): IBaseState | undefined {
    return this.allState.get(this.getTypeIdKey(stateType, stateId));
  }

  /**
   * 状态移出共享中心
   *
   * @param state 状态
   * @returns 删除成功
   */
  public deleteState(state: IBaseState): boolean {
    if (!state) {
      return false;
    }
    return this.deleteStateById(state.getStateType(), state.getStateId());
  }

  /**
   * 状态移出共享中心
   *
   * @param stateType 状态类型
   * @param stateId 状态id
   * @returns 删除成功
   */
  public deleteStateById(stateType: StateType, stateId: string): boolean {
    let key = this.getTypeIdKey(stateType, stateId);
    let state = this.allState.get(key);
    if (state) {
      // 注销状态切换监听
      state.unregisterStateChangeListener?.(this.stateChangeListener);
      this.allState.delete(key);
      log.showInfo(`${this.mgrName} deleteStateById ${key} has delete.`);
      return true;
    }
    return false;
  }

  /**
   * 注册状态切换监听
   *
   * @param listener 监听器
   * @param stateTag 唯一标识
   */
  public registerStateListener(listener: IBaseStateChangeListener, stateTag?: IStateTag): void {
    if (!listener) {
      log.showWarn(`${this.mgrName} registerStateListener fail, no listener.`);
      return;
    }
    let stateType = stateTag?.stateType ?? listener?.stateType;
    let stateId = stateTag?.stateId ?? listener?.stateId;
    if (stateType && stateId) {
      let key = this.getTypeIdKey(stateType, stateId);
      let listenerSet = this.allListeners.get(key);
      if (!listenerSet) {
        listenerSet = new Set();
        this.allListeners.set(key, listenerSet);
      }
      listenerSet.add(listener);
    } else {
      log.showWarn(`${this.mgrName} registerStateListener fail. ${stateType}, ${stateId}`);
    }
  }

  /**
   * 注销状态切换监听
   *
   * @param listener 监听器
   * @param stateTag 唯一标识
   */
  public unregisterStateListener(listener: IBaseStateChangeListener, stateTag?: IStateTag): void {
    let stateType = stateTag?.stateType ?? listener?.stateType;
    let stateId = stateTag?.stateId ?? listener?.stateId;
    if (stateType && stateId) {
      let key = this.getTypeIdKey(stateType, stateId);
      this.allListeners.get(key)?.delete(listener);
    }
  }

  /**
   * 状态组合键值
   *
   * @param stateType 状态类型
   * @param stateId 状态id
   * @returns 组合键值
   */
  private getTypeIdKey(stateType: StateType, stateId: string): string {
    return `${stateType}-${stateId}`;
  }
}