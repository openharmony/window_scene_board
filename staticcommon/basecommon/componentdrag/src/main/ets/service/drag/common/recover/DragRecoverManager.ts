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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { dragContext } from './DragContext';

const TAG: string = 'DragRecoverManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);
const INVALID: number = -1;
const MAX_TIME: number = 10000;

/**
 * 拖拽容错恢复管理类
 */
class DragRecoverManager {
  private timeoutId: number = INVALID;

  /**
   * 启动拖拽计时器，计时器到时清空拖拽上下文
   *
   * @returns 计时器id
   */
  public startDragTimer(): number {
    this.clearDragTimer();
    this.timeoutId = setTimeout(() => {
      dragContext.release();
      this.timeoutId = INVALID;
    }, MAX_TIME);
    return this.timeoutId;
  }

  /**
   * 清空拖拽计时器
   *
   * @returns 是否清除成功
   */
  public clearDragTimer(): boolean {
    if (this.timeoutId !== INVALID) {
      clearTimeout(this.timeoutId);
      this.timeoutId = INVALID;
      return true;
    }
    return false;
  }
}

export const dragRecoverManager: DragRecoverManager =
  SingletonHelper.getInstance(DragRecoverManager, TAG) as DragRecoverManager;