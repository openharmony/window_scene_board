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

import { ArrayUtils, CommonUtils } from '@ohos/basicutils';
import { Runnable } from '../Runnable';

export enum TriggerType { // 任务触发类型
  TRIGGER_IMMEDIATELY = 1, // 立即触发
  TRIGGER_TIMEOUT // 延时触发
}

/**
 * 触摸手势任务统一管理
 */
export class TouchRunnableManager {
  private touchIdType: Map<number, TouchType> = new Map(); // 手势ID-状态映射
  private upRunnable: Map<number, Map<TriggerType, Set<Runnable>>> = new Map(); // 手势ID-up任务映射
  private upTimeoutId: Map<number, number> = new Map(); // 手势ID-up延时任务ID映射

  /**
   * 更新触摸类型
   *
   * @param id 手势ID
   * @param touchType 触摸类型
   */
  public updateTouchType(id: number, touchType: TouchType): void {
    let isFinish = touchType === TouchType.Up || touchType === TouchType.Cancel;
    if (isFinish) {
      this.touchIdType.delete(id);
      this.triggerUpRunnable(id);
    } else {
      this.touchIdType.set(id, touchType);
    }
  }

  /**
   * 添加up事件任务
   *
   * @param id 手势ID
   * @param runnable 任务
   * @param trigger 触发类型
   */
  public addUpRunnable(id: number, runnable: Runnable, trigger: TriggerType = TriggerType.TRIGGER_IMMEDIATELY): void {
    if (!this.touchIdType.has(id)) { // 添加up任务时，无对应手势ID的事件，则不允许添加
      return;
    }
    let triggerMap = this.upRunnable.get(id);
    if (CommonUtils.isInvalid(triggerMap)) {
      triggerMap = new Map();
      this.upRunnable.set(id, triggerMap);
    }
    let rSet = triggerMap?.get(trigger);
    if (CommonUtils.isInvalid(rSet)) {
      rSet = new Set();
      triggerMap?.set(trigger, rSet);
    }
    rSet?.add(runnable);
  }

  /**
   * 取消up事件所有任务
   *
   * @param id 手势ID
   */
  public cancelUpRunnable(id: number): void {
    this.clearTimeout(id);
    this.upRunnable.delete(id);
  }

  private triggerUpRunnable(id: number): void { // 触发抬手任务
    let triggerR = this.upRunnable.get(id);
    this.upRunnable.delete(id); // 任务触发后直接清除
    let immediateR = triggerR?.get(TriggerType.TRIGGER_IMMEDIATELY);
    let timeoutR = triggerR?.get(TriggerType.TRIGGER_TIMEOUT);
    immediateR?.forEach((runnable) => runnable?.()); // 直接触发任务
    if (!ArrayUtils.isEmpty(timeoutR)) { // 延时触发任务
      this.clearTimeout(id);
      this.upTimeoutId.set(id, setTimeout(() => {
        this.clearTimeout(id);
        timeoutR?.forEach((runnable) => runnable?.());
      }));
    }
  }

  private clearTimeout(touchId: number): void { // 清除对应手势ID的延时任务
    clearTimeout(this.upTimeoutId.get(touchId));
    this.upTimeoutId.delete(touchId);
  }
}