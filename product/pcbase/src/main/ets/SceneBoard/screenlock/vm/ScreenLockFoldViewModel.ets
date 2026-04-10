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
import { KeyboardChangeCallback, SCBKeyboardManager } from '@ohos/windowscene';
import Constants from '../common/Constants';

const TAG = 'ScreenLock-ScreenLockFoldViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export interface ScreenLockLayoutChangeCallback {
  /**
   * 账号顶部网格数变化
   *
   * @param offsetGridNum 账号间距偏移网格数
   */
  onAccountTopGridNumChange?: ((offsetGridNum: number) => void);

  /**
   * 忘记密码底部边距高度变化
   *
   * @param forgetPwdMarginHeight 忘记密码底部边距高度
   */
  onForgetPwdMarginChange?: ((forgetPwdMarginHeight: number) => void);

  /**
   * 锁屏弹窗位置变化
   *
   * @param dialogOffset 锁屏自定义弹窗的位置偏移
   */
  onCustomDialogOffsetChange?: ((dialogOffset: Offset) => void);

  /**
   * 锁屏丢失模式位置变化
   *
   * @param lostModeMarginHeight 丢失模式距离顶部边距高度
   */
  onLostModeMarginChange?: ((lostModeMarginHeight: number) => void);
}

export default class ScreenLockFoldViewModel {
  private static instance: ScreenLockFoldViewModel;
  private forgetPwdMarginHeight: number = 0;
  private accountTopOffsetGridNum: number = 0;
  private dialogOffset: Offset = {
    dx: 0, dy: 0
  };
  private isChangePwdPageShow: boolean = false;
  private lostModeMarginTop: number = Constants.VERTICAL_LOST_MODE_MARGIN;
  /**
   * @description: 锁屏布局回调函数
   */
  private layoutChangeCallbacks: Array<ScreenLockLayoutChangeCallback> = [];

  constructor() {
  }

  public static getInstance(): ScreenLockFoldViewModel {
    if (!ScreenLockFoldViewModel.instance) {
      ScreenLockFoldViewModel.instance = new ScreenLockFoldViewModel();
    }
    return ScreenLockFoldViewModel.instance;
  }

  private notifyAccountTopGridNumChange(): void {
    if (this.layoutChangeCallbacks.length <= 0) {
      log.showInfo('notifyAccountTopGridNumChange this.marginChangeCallback is none');
      return;
    }
    this.layoutChangeCallbacks.forEach((callback: ScreenLockLayoutChangeCallback) => {
      if (callback && callback.onAccountTopGridNumChange) {
        callback.onAccountTopGridNumChange(this.accountTopOffsetGridNum);
      }
    });
  }

  private notifyForgetPwdMarginHeightChange(): void {
    if (this.layoutChangeCallbacks.length <= 0) {
      log.showInfo('notifyForgetPwdMarginChange this.marginChangeCallback is none');
      return;
    }
    this.layoutChangeCallbacks.forEach((callback: ScreenLockLayoutChangeCallback) => {
      if (callback && callback.onForgetPwdMarginChange) {
        callback.onForgetPwdMarginChange(this.forgetPwdMarginHeight);
      }
    });
  }

  private notifyDialogOffsetChange(): void {
    if (this.layoutChangeCallbacks.length <= 0) {
      log.showInfo('notifyDialogOffsetChange this.layoutChangeCallbacks is none');
      return;
    }
    this.layoutChangeCallbacks.forEach((callback: ScreenLockLayoutChangeCallback) => {
      if (callback && callback.onCustomDialogOffsetChange) {
        callback.onCustomDialogOffsetChange(this.dialogOffset);
      }
    });
  }

  private notifyLostModeMarginChange(): void {
    if (this.layoutChangeCallbacks.length <= 0) {
      log.showInfo('notifyLostModeMarginChange this.layoutChangeCallbacks is none');
      return;
    }
    this.layoutChangeCallbacks.forEach((callback: ScreenLockLayoutChangeCallback) => {
      if (callback && callback.onLostModeMarginChange) {
        callback.onLostModeMarginChange(this.lostModeMarginTop);
      }
    });
  }

  public registerScreenLockLayoutChangeCallback(callback: ScreenLockLayoutChangeCallback) {
    log.showInfo('registerScreenLockLayoutChangeCallback');
    this.layoutChangeCallbacks.push(callback);
  }

  public unregisterScreenLockLayoutChangeCallback(callback: ScreenLockLayoutChangeCallback) {
    log.showInfo('unregisterScreenLockLayoutChangeCallback');
    const index = this.layoutChangeCallbacks.indexOf(callback);
    if (index !== -1) {
      this.layoutChangeCallbacks.splice(index, 1);
    }
  }

  public getForgetPwdMarginHeight(): number {
    log.showInfo(`getForgetPwdMarginHeight ${this.forgetPwdMarginHeight}`);
    return this.forgetPwdMarginHeight;
  }

  public setIsChangePwdPageShow(isShow: boolean): void {
    this.isChangePwdPageShow = isShow;
  }

  public getLostModeMarginTop(): number {
    log.showInfo(`getLostModeMarginTop ${this.lostModeMarginTop}`);
    return this.lostModeMarginTop;
  }

  public destroy(): void {}
}