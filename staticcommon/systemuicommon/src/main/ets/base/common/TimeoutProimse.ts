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
import { CustomPromise } from '@ohos/frameworkwrapper';

const TAG = 'TimeoutPromise';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 带定时的Promise
 */
export class TimeoutPromise<T> extends CustomPromise<T> {
  private tag: string;
  private timer?: number;
  private removeCurrentPromiseCallback?: (promise: TimeoutPromise<T>) => void;

  constructor(tag: string, func?: () => void) {
    super();
    this.tag = tag;
    func && this.then(func);
    log.showInfo('Create for %{public}s.', this.tag);
  }

  public toString(): string {
    return this.tag;
  }

  /**
   * 开始计时
   *
   * @param timeout
   */
  public startTimeout(timeout: number): TimeoutPromise<T> {
    log.showInfo('StartTimeout for %{public}s timeout %{public}d', this.tag, timeout);
    if (this.timer) {
      log.showWarn('Repeat startTimeout for %{public}s', this.tag);
    } else {
      this.initTimer(timeout);
    }
    return this;
  }

  /**
   * 手动执行Resolve
   *
   * @param reason
   */
  public manuallyResolve(reason: string): void {
    if (this.timer === undefined) {
      log.showWarn('Manually resolve for %{public}s. reason: %{public}s. but repeat.', this.tag, reason);
      return;
    }

    log.showInfo('Manually resolve fot %{public}s. reason: %{public}s', this.tag, reason);
    this.removeCurrentPromise();
    this.clearTimer();
    this.resolve(undefined);
  }

  /**
   * 手动执行Reject
   */
  public manuallyReject(reason: string): void {
    if (this.timer === undefined) {
      log.showWarn('Manually reject for %{public}s. reason: %{public}s. but repeat.', this.tag, reason);
      return;
    }
    log.showInfo('Manually reject for %{public}s. reason: %{public}s', this.tag, reason);
    this.removeCurrentPromise();
    this.clearTimer();
    this.reject();
  }

  public clear(): void {
    log.showInfo('Reset for %{public}s', this.tag);
    this.removeCurrentPromise();
    this.clearTimer();
    this.reject();
  }

  /**
   * 添加Promise移除回调
   *
   * @param removePromise
   */
  public addRemovePromiseCallback = (removePromise: (promise: TimeoutPromise<T>) => void) : TimeoutPromise<T> => {
    this.removeCurrentPromiseCallback = removePromise;
    return this;
  };

  private removeCurrentPromise(): void {
    this.removeCurrentPromiseCallback?.(this);
    this.removeCurrentPromiseCallback = undefined;
  }

  /**
   * 添加回调事件
   *
   * @param callback
   * @returns
   */
  public addThenCallback(callback: (ret: T) => void): TimeoutPromise<T> {
    this.then(callback);
    return this;
  }

  private initTimer(timeout: number): void {
    this.timer = setTimeout(() => {
      this.removeCurrentPromise();
      if (this.timer !== undefined) {
        this.clearTimer();
        log.showInfo('Resolve by timeout for %{public}s.', this.tag);
        this.resolve(undefined);
      } else {
        log.showWarn('Resolve by timeout for %{public}s, timer is null', this.tag);
      }
    }, timeout);
  }

  private clearTimer(): void {
    const delTimer = this.timer;
    this.timer = undefined;
    clearTimeout(delTimer);
  }
}