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
import { Constants } from './Constants';

const TAG = 'DialogFoldModel';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export interface DialogChangeCallback {
  /**
   * 弹窗位置变化
   *
   * @param dialogOffsetY 弹窗的位置偏移
   */
  onCustomDialogOffsetYChange?: ((dialogOffsetY: number) => void);
}

export default class DialogFoldModel {
  private static instance: DialogFoldModel;
  private dialogOffsetY: number = 0;
  /**
   * @description: 弹窗布局回调函数
   */
  private layoutChangeCallbacks: Array<DialogChangeCallback> = [];

  private constructor() {}

  public static getInstance(): DialogFoldModel {
    if (!DialogFoldModel.instance) {
      DialogFoldModel.instance = new DialogFoldModel();
    }
    return DialogFoldModel.instance;
  }

  private notifyDialogOffsetYChange(): void {
    if (this.layoutChangeCallbacks.length <= 0) {
      log.showInfo(`notifyDialogOffsetYChange this.layoutChangeCallbacks is none`);
      return;
    }
    this.layoutChangeCallbacks.forEach((callback: DialogChangeCallback) => {
      if (callback && callback.onCustomDialogOffsetYChange) {
        callback.onCustomDialogOffsetYChange(this.dialogOffsetY);
      }
    });
  }

  public registerDialogChangeCallback(callback: DialogChangeCallback) {
    log.showInfo(`registerDialogChangeCallback`);
    this.layoutChangeCallbacks.push(callback);
  }

  public unregisterDialogChangeCallback(callback: DialogChangeCallback) {
    log.showInfo(`unregisterDialogChangeCallback`);
    const index = this.layoutChangeCallbacks.indexOf(callback);
    if (index !== -1) {
      this.layoutChangeCallbacks.splice(index, 1);
    }
  }

  public destroy(): void {}
}