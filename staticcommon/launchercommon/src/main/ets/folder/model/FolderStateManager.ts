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

const TAG = 'FolderStateManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/*
 * 文件夹状态
 */
export enum FolderState {
  CLOSED = 0, /* 文件夹处于关闭/折叠状态 */
  CLOSING, /* 文件夹处于关闭过程中状态 */
  OPENED, /* 文件夹处于打开/展开状态 */
  OPENING, /* 文件夹处于打开/展开过程中 */
  SWIPING, /* 文件夹打开/展开状态下滑动过程中 */
  CONVERTING, /* 转换文件夹大小过程中 */
}

/**
 * 文件夹状态跃迁类
 */
class FolderTransition {
  private fromState?: FolderState;
  private toState?: FolderState;
  private whenCallback?: (fromState: FolderState, toState: FolderState) => boolean;
  private performCallback?: (fromState: FolderState, toState: FolderState) => boolean;

  public canTransfer(fromState: FolderState, toState: FolderState): boolean {
    if (this.fromState === fromState && this.toState === toState) {
      if (!this.whenCallback) {
        return true;
      }
      return this.whenCallback(fromState, toState);
    }
    return false;
  }

  public doPerform(fromState: FolderState, toState: FolderState): void {
    if (this.performCallback) {
      this.performCallback(fromState, toState);
    }
  }

  public is(from: FolderState, to: FolderState): boolean {
    return this.fromState === from && this.toState === to;
  }

  public from(state: FolderState): FolderTransition {
    this.fromState = state;
    return this;
  }

  public to(state: FolderState): FolderTransition {
    this.toState = state;
    return this;
  }

  public when(callback: (fromState: FolderState, toState: FolderState) => boolean): FolderTransition {
    this.whenCallback = callback;
    return this;
  }

  public perform(callback: (fromState: FolderState, toState: FolderState) => boolean): FolderTransition {
    this.performCallback = callback;
    return this;
  }
}

/**
 * 文件夹状态管理类
 */
export class FolderStateManager {
  private static instance: FolderStateManager;
  private transitions: FolderTransition[] = [];
  private now: FolderState = FolderState.CLOSED;

  private constructor() {
    /* 不添加的就是不允许跳转的状态 */
    /* 操作：打开文件夹 */
    this.transitions.push(new FolderTransition().from(FolderState.CLOSED).to(FolderState.OPENING));
    this.transitions.push(new FolderTransition().from(FolderState.OPENING).to(FolderState.OPENED));

    /* 操作：关闭文件夹 */
    this.transitions.push(new FolderTransition().from(FolderState.OPENED).to(FolderState.CLOSING));
    this.transitions.push(new FolderTransition().from(FolderState.CLOSING).to(FolderState.CLOSED));

    /* 操作：打开关闭文件夹的打断场景 */
    this.transitions.push(new FolderTransition().from(FolderState.OPENING).to(FolderState.CLOSING));
    this.transitions.push(new FolderTransition().from(FolderState.CLOSING).to(FolderState.OPENING));

    /* 操作：无动效立刻打开关闭文件夹场景 */
    this.transitions.push(new FolderTransition().from(FolderState.CLOSED).to(FolderState.OPENED));
    this.transitions.push(new FolderTransition().from(FolderState.OPENED).to(FolderState.CLOSED));

    /* 操作: 打开文件夹过程中立刻无动效关闭文件夹场景，如：打开文件夹过程中立刻折叠或展开手机或锁屏 */
    this.transitions.push(new FolderTransition().from(FolderState.OPENING).to(FolderState.CLOSED));
  }

  static getInstance(): FolderStateManager {
    if (FolderStateManager.instance == null) {
      FolderStateManager.instance = new FolderStateManager();
    }
    return FolderStateManager.instance;
  }

  /**
   * 延迟执行逻辑。
   * 对于业务直接支持可打断的功能，放到支持的状态跃迁中；对于不可打断的场景，可在此延迟方案下规避。
   *
   * @param trans 跃迁类
   * @param state 状态
   * @returns 是否纳入延迟队列
   */
  private doActionLater(trans: FolderTransition, state: FolderState): boolean {
    /* 后续支持延迟1次执行的队列 */
    log.showError('folder state cannot transfer to %{public}d because we are busying', state);
    return false;
  }

  private findTransition(from: FolderState, to: FolderState): FolderTransition | undefined {
    return this.transitions.find((trans: FolderTransition) => {
      return trans.is(from, to);
    });
  }

  private doAction(trans: FolderTransition, state: FolderState,
    beforePerform?: (from: FolderState, to: FolderState) => void,
    afterPerform?: (from: FolderState, to: FolderState) => void): boolean {
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
  public tryAction(state: FolderState,
    beforePerform?: (from: FolderState, to: FolderState) => void,
    afterPerform?: (from: FolderState, to: FolderState) => void): boolean {
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

  public getStatusDesc(): string {
    return 'now status: ' + this.now.toString();
  }
}