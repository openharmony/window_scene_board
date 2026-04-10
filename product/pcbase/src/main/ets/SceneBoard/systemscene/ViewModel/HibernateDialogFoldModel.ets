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

const TAG = 'HibernateDialogFoldModel';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const QUARTER_OF_SCREEN = 4;

export interface HibernateDialogChangeCallback {
  /**
   * 弹窗位置变化
   *
   * @param dialogOffsetY 关机中断弹窗的位置偏移
   */
  onCustomDialogOffsetYChange?: ((dialogOffsetY: number) => void);
}

export class HibernateDialogFoldModel {
  private static instance: HibernateDialogFoldModel;
  private dialogOffsetY: number = 0;
  /**
   * @description: 关机中断弹窗布局回调函数
   */
  private layoutChangeCallbacks: Array<HibernateDialogChangeCallback> = [];

  constructor() {}

  public static getInstance(): HibernateDialogFoldModel {
    if (!HibernateDialogFoldModel.instance) {
      HibernateDialogFoldModel.instance = new HibernateDialogFoldModel();
    }
    return HibernateDialogFoldModel.instance;
  }

  private notifyDialogOffsetYChange(): void {
    if (this.layoutChangeCallbacks.length <= 0) {
      log.showInfo('notifyDialogOffsetYChange this.layoutChangeCallbacks is none');
      return;
    }
    this.layoutChangeCallbacks.forEach((callback: HibernateDialogChangeCallback) => {
      if (callback && callback.onCustomDialogOffsetYChange) {
        callback.onCustomDialogOffsetYChange(this.dialogOffsetY);
      }
    });
  }

  public registerHibernateDialogChangeCallback(callback: HibernateDialogChangeCallback) {
    log.showInfo('registerHibernateDialogChangeCallback');
    this.layoutChangeCallbacks.push(callback);
  }

  public unregisterHibernateDialogChangeCallback(callback: HibernateDialogChangeCallback) {
    log.showInfo('unregisterHibernateDialogChangeCallback');
    const index = this.layoutChangeCallbacks.indexOf(callback);
    if (index !== -1) {
      this.layoutChangeCallbacks.splice(index, 1);
    }
  }

  public destroy(): void {}
}