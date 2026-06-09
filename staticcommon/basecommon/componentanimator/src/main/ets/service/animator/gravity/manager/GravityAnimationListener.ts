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
import { DomainName, LogDomain, LogHelper } from '@ohos/basicutils';
import { TraceUtil, SingletonHelper } from '@ohos/basicutils';

const TAG = 'GravityAnimationListenerManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 引力动效生命周期监听器
 */
export interface GravityAnimationListener {
  /* 引力动效完全结束时的回调 */
  finishAllCallback: () => void;
}

/**
 * 引力动效生命周期监听管理
 */
export class GravityAnimationListenerManager {
  private listeners: GravityAnimationListener[] = [];

  private findListenerIndex(listener: GravityAnimationListener): number {
    return this.listeners.findIndex((item) => {
      if (item === listener) {
        return true;
      }

      return false;
    });
  }

  /**
   * 由GravityAnimationManager触发，通知引力动效结束，其他模块不要调用
   */
  public notifyFinished(): void {
    log.showInfo('gravity animation is finished');
    TraceUtil.startTraceWithTaskId(DomainName.SCB, 'NotifyGravityAnimationAllFinished', 1);
    this.listeners.forEach((item) => item.finishAllCallback());
    TraceUtil.endTraceWithTaskId(DomainName.SCB, 'NotifyGravityAnimationAllFinished', 1);
  }

  /**
   * 注册监听器
   *
   * @param listener 业务模块的监听器
   */
  public registerListener(listener: GravityAnimationListener): void {
    let found = this.findListenerIndex(listener);
    if (found > -1) {
      log.showWarn('repeat listener, do nothing');
      return;
    }

    this.listeners.push(listener);
  }

  /**
   * 去注册监听器
   *
   * @param listener 业务模块的监听器
   */
  public unregisterListener(listener: GravityAnimationListener): void {
    let found = this.findListenerIndex(listener);
    if (found < 0) {
      log.showWarn('listener is not existed, do nothing');
      return;
    }

    this.listeners.splice(found, 1);
  }
}

export let gravityAnimationListenerManager: GravityAnimationListenerManager =
  SingletonHelper.getInstance(GravityAnimationListenerManager, TAG);