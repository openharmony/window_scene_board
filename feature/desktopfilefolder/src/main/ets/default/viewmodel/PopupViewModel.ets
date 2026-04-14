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
import { CommonConstants, GridLayoutItemInfo } from '@ohos/launchercommon';
import { LogDomain, Logger } from '@ohos/basicutils';

const TAG = 'PopupViewModel';
const log = Logger.getLogHelper(LogDomain.HOME);

export class PopupViewModel {
  private isViewShow_: boolean = false;
  private timerID: number = CommonConstants.INVALID_VALUE;
  private fileFolderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
  private tag: string = '';

  constructor(fileFolderItem: GridLayoutItemInfo) {
    this.fileFolderItem = fileFolderItem;
    this.tag = TAG + this.fileFolderItem.ino;
  }

  public get isViewShow(): boolean {
    return this.isViewShow_;
  }

  /**
   * 显示弹窗，会清理掉已有的延时显示任务
   */
  public showView(reason: string): void {
    this.clearTimer();
    this.isViewShow_ = true;
    log.showInfo(this.tag, `showView, reason: ${reason}`);
  }

  /**
   * 延时显示弹窗，已存在延时显示任务时，使用已有的延时显示任务显示弹窗，不会清理和覆盖已有的延时任务
   * @param delayTime
   */
  public showViewWithDelay(delayTime: number, reason: string): void {
    if (this.timerID !== CommonConstants.INVALID_VALUE) {
      return;
    }
    this.timerID = setTimeout(() => {
      this.isViewShow_ = true
      log.showInfo(this.tag, `showViewWithDelay, reason: ${reason}`);
    }, delayTime);
  }

  /**
   * 隐藏弹窗，同时会清理掉已有的延时显示任务
   */
  public hideView(reason: string): void {
    this.clearTimer();
    this.isViewShow_ = false;
    log.showInfo(this.tag, `hideView, reason: ${reason}`);
  }
  
  private clearTimer(): void {
    if (this.timerID === CommonConstants.INVALID_VALUE) {
      return;
    }
    clearTimeout(this.timerID);
    this.timerID = CommonConstants.INVALID_VALUE;
  }
}