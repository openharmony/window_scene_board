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
import { SCBFoldState, SCBFoldStateProperty } from '../utils/Constants';
import { FoldShutdownViewProxyManager } from '../fold/FoldShutdownViewProxyManager';

const TAG = 'ShutdownViewFoldModel';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const QUARTER_OF_SCREEN = 4;

export interface ShutDownViewDialogChangeCallback {
  /**
   * 弹窗位置变化
   *
   * @param dialogOffsetY 关机中断弹窗的位置偏移
   */
  onCustomDialogOffsetYChange?: ((dialogOffsetY: number) => void);
}

export default class ShutDownViewFoldModel {
  private static instance: ShutDownViewFoldModel;
  private dialogOffsetY: number = 0;
  /**
   * @description: 关机中断弹窗布局回调函数
   */
  private layoutChangeCallbacks: Array<ShutDownViewDialogChangeCallback> = [];
  private foldCallback: Callback<SCBFoldStateProperty, void> = (foldStateProperty: SCBFoldStateProperty) => {
    const curState: SCBFoldState = foldStateProperty.curState;
    const tarState: SCBFoldState = foldStateProperty.tarState;
    log.showInfo(`foldCallback foldStateProperty curState: ${curState}, tarState: ${tarState}`);

    const curBSideHeight = FoldShutdownViewProxyManager.getInstance().getBSideRegion().height.getPx();
    switch (tarState) {
      case SCBFoldState.HALF_FOLDED_VIRTUAL_KEYBOARD:
      case SCBFoldState.HALF_FOLDED_PHYSICAL_KEYBOARD:
      case SCBFoldState.HALF_FOLDED:
        this.dialogOffsetY = -curBSideHeight / QUARTER_OF_SCREEN;
        break;
      default:
        this.dialogOffsetY = 0;
    }
    log.showInfo(`layoutChangeCallbacks dialogOffsetY: ${this.dialogOffsetY}`);
    this.notifyDialogOffsetYChange();
  };

  constructor() {
    FoldShutdownViewProxyManager.getInstance().registerFoldSceneStateChangeCallback(this.foldCallback);
  }

  public static getInstance(): ShutDownViewFoldModel {
    if (!ShutDownViewFoldModel.instance) {
      ShutDownViewFoldModel.instance = new ShutDownViewFoldModel();
    }
    return ShutDownViewFoldModel.instance;
  }

  private notifyDialogOffsetYChange(): void {
    if (this.layoutChangeCallbacks.length <= 0) {
      log.showInfo('notifyDialogOffsetYChange this.layoutChangeCallbacks is none');
      return;
    }
    this.layoutChangeCallbacks.forEach((callback: ShutDownViewDialogChangeCallback) => {
      if (callback && callback.onCustomDialogOffsetYChange) {
        callback.onCustomDialogOffsetYChange(this.dialogOffsetY);
      }
    });
  }

  public registerShutDownViewDialogChangeCallback(callback: ShutDownViewDialogChangeCallback) {
    log.showInfo('registerShutDownViewDialogChangeCallback');
    this.layoutChangeCallbacks.push(callback);
    FoldShutdownViewProxyManager.getInstance().registerFoldSceneStateChangeCallback(this.foldCallback);
  }

  public unregisterShutDownViewDialogChangeCallback(callback: ShutDownViewDialogChangeCallback) {
    log.showInfo('unregisterShutDownViewDialogChangeCallback');
    FoldShutdownViewProxyManager.getInstance().unregisterFoldSceneStateChangeCallback(this.foldCallback);
    const index = this.layoutChangeCallbacks.indexOf(callback);
    if (index !== -1) {
      this.layoutChangeCallbacks.splice(index, 1);
    }
  }

  public destroy(): void {
    FoldShutdownViewProxyManager.getInstance().unregisterFoldSceneStateChangeCallback(this.foldCallback);
  }
}