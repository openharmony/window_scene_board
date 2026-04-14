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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { FolderActionLifeCycleStatus } from './FolderActionLifeCycleEventManager';

const TAG = 'FolderActionLifeCycleStatusManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件夹操作状态跃迁类
 */
export class FolderActionTransition {
  private fromState: FolderActionLifeCycleStatus | undefined;
  private toState: FolderActionLifeCycleStatus | undefined;
  private whenCallback?: (fromState: FolderActionLifeCycleStatus, toState: FolderActionLifeCycleStatus) => boolean;
  private performCallback?: (fromState: FolderActionLifeCycleStatus, toState: FolderActionLifeCycleStatus) => boolean;

  /**
   * 是否状态能切换
   *
   * @param fromState 开始状态
   * @param toState 目标状态
   * @returns true能切换
   */
  public canTransfer(fromState: FolderActionLifeCycleStatus, toState: FolderActionLifeCycleStatus): boolean {
    if (this.fromState === fromState && this.toState === toState) {
      if (!this.whenCallback) {
        return true;
      }
      return this.whenCallback(fromState, toState);
    }
    return false;
  }

  /**
   * 执行状态切换注册的回调
   *
   * @param fromState 开始状态
   * @param toState 目标状态
   */
  public doPerform(fromState: FolderActionLifeCycleStatus, toState: FolderActionLifeCycleStatus): void {
    if (this.performCallback) {
      this.performCallback(fromState, toState);
    }
  }

  /**
   * 判断起始状态是否正确
   *
   * @param from 开始状态
   * @param to 目标状态
   * @returns true两个状态正常
   */
  public is(from: FolderActionLifeCycleStatus, to: FolderActionLifeCycleStatus): boolean {
    return this.fromState === from && this.toState === to;
  }

  /**
   * 设置开始状态
   *
   * @param state 状态
   * @returns 当前对象
   */
  public from(state: FolderActionLifeCycleStatus): FolderActionTransition {
    this.fromState = state;
    return this;
  }

  /**
   * 设置目标状态
   *
   * @param state 状态
   * @returns 当前对象
   */
  public to(state: FolderActionLifeCycleStatus): FolderActionTransition {
    this.toState = state;
    return this;
  }

  /**
   * 设置在状态切换前的逻辑
   *
   * @param callback 回调业务逻辑
   * @returns 当前对象
   */
  public when(callback: (fromState: FolderActionLifeCycleStatus,
    toState: FolderActionLifeCycleStatus) => boolean): FolderActionTransition {
    this.whenCallback = callback;
    return this;
  }

  /**
   * 设置状态切换时执行的逻辑
   *
   * @param callback 回调业务逻辑
   * @returns 当前对象
   */
  public perform(callback: (fromState: FolderActionLifeCycleStatus,
    toState: FolderActionLifeCycleStatus) => boolean): FolderActionTransition {
    this.performCallback = callback;
    return this;
  }
}

/**
 * 文件夹状态管理类
 */
export class FolderActionLifeCycleStatusManager {
  private static instance: FolderActionLifeCycleStatusManager;
  protected transitions: FolderActionTransition[] = [];
  protected now: FolderActionLifeCycleStatus = FolderActionLifeCycleStatus.CLOSED;

  protected constructor() {
  }

  static getInstance(): FolderActionLifeCycleStatusManager {
    if (!FolderActionLifeCycleStatusManager.instance) {
      FolderActionLifeCycleStatusManager.instance = new FolderActionLifeCycleStatusManager();
    }
    return FolderActionLifeCycleStatusManager.instance;
  }

  /**
   * 延迟执行逻辑。
   * 对于业务直接支持可打断的功能，放到支持的状态跃迁中；对于不可打断的场景，可在此延迟方案下规避。
   *
   * @param trans 跃迁类
   * @param state 状态
   * @returns 是否纳入延迟队列
   */
  private doActionLater(trans: FolderActionTransition, state: FolderActionLifeCycleStatus): boolean {
    /* 后续支持延迟1次执行的队列 */
    log.showError('folder state cannot transfer to %{public}d because we are busying', state);
    return false;
  }

  private findTransition(from: FolderActionLifeCycleStatus,
    to: FolderActionLifeCycleStatus): FolderActionTransition | undefined {
    return this.transitions.find((trans: FolderActionTransition) => {
      return trans.is(from, to);
    });
  }

  private doAction(trans: FolderActionTransition, state: FolderActionLifeCycleStatus,
    beforePerform?: (from: FolderActionLifeCycleStatus, to: FolderActionLifeCycleStatus) => void,
    afterPerform?: (from: FolderActionLifeCycleStatus, to: FolderActionLifeCycleStatus) => void): boolean {
    if (trans.canTransfer(this.now, state)) {
      log.showInfo('folder state change from %{public}d -> %{public}d', this.now, state);
      const last = this.now;
      this.now = state;
      if (beforePerform) {
        beforePerform(last, state);
      }
      trans.doPerform(last, state);
      if (afterPerform) {
        afterPerform(last, state);
      }
      return true;
    }

    return false;
  }

  /**
   * 尝试跃迁文件夹状态
   *
   * @param state 目标状态
   * @param beforePerform 状态变化前的回调
   * @param afterPerform 状态变化后的回调
   * @returns 跃迁结果
   */
  public tryAction(state: FolderActionLifeCycleStatus,
    beforePerform?: (from: FolderActionLifeCycleStatus, to: FolderActionLifeCycleStatus) => void,
    afterPerform?: (from: FolderActionLifeCycleStatus, to: FolderActionLifeCycleStatus) => void): boolean {
    const trans = this.findTransition(this.now, state);
    if (!trans) {
      log.showError('cannot find folder state transition with %{public}d', state);
      return false;
    }

    if (!this.doAction(trans, state, beforePerform, afterPerform)) {
      return this.doActionLater(trans, state);
    }
    return true;
  }

  /**
   * 获取当前状态的信息
   *
   * @returns 当前状态的描述信息
   */
  public getStatusDesc(): string {
    return 'now status: ' + this.now.toString();
  }
}