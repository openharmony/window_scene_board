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

import IconInfo from '@ohos/frameworkwrapper/src/main/ets/resourcemanager/IconInfo';
import { IconChangeListener } from '../AppModel';

/**
 * 刷新策略基类
 */
export abstract class RefreshStrategy {
  private isCancel: boolean = false;

  private batchId: number = 0;

  constructor(batchId: number) {
    this.batchId = batchId;
  }

  /**
   * 获取资源并刷新控件和缓存
   *
   * @param iconChangeListener 控件监听回调
   * @param deliverAppIconInfosMap dh应用列表
   * @returns
   */
  abstract refreshDataAndView(iconChangeListener: IconChangeListener[],
    deliverAppIconInfosMap: Map<string, IconInfo>, allFinished: () => void): Promise<void>

  /**
   * 取消该刷新任务,具体的取消功能子类可重写改方法
   */
  public cancelStrategy(): void {
    this.isCancel = true;
  }

  /**
   * 当前刷新任务是否被取消
   *
   * @returns true:已取消 false:正在执行
   */
  public isCanceled(): boolean {
    return this.isCancel;
  }

  /**
   * 获取该刷新任务对应的批次号,用于区分各个刷新任务
   *
   * @returns 该刷新任务对应的批次号
   */
  public getBatchId(): number {
    return this.batchId;
  }
}