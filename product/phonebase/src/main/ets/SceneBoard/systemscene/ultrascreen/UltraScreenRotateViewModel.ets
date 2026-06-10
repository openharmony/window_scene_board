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

import { LogDomain, Logger, } from '@ohos/basicutils';
import { ScreenState, ScreenStateMonitor } from '@ohos/frameworkwrapper';
import {
  SCBScreenProperty,
  SCBRotateChangeReason,
  SCBScreenSessionManager,
} from '@ohos/windowscene';
import { PageInfoManager, StyleConstants } from '@ohos/launchercommon';
import { DisplayCountViewModel } from '@ohos/launchercommon/src/main/ets/displaycount/DisplayCountViewModel';
import { UltraScreenRotateUtils } from './UltraScreenRotateUtils';
import { UltraScreenUtils } from './UltraScreenUtils';

const TAG = 'UltraScreenRotateViewModel';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

/**
 * 超大屏设备旋转view model
 */
export class UltraScreenRotateViewModel {
  private static sInstance: UltraScreenRotateViewModel;

  /**
   * 最近一次旋转后到的页数
   */
  private lastPageTo: number = 0;

  /**
   * 最近一次旋转前到的页数
   */
  private lastPageFrom: number[] = [];

  private ultraScreenScreenRotateCallback =
    (screenProperty: SCBScreenProperty, reason: SCBRotateChangeReason) => this.ultraScreenRotateCallback(screenProperty,
      reason);

  protected constructor() {
  }

  /**
   * 获取本类单例
   * @returns
   */
  public static getInstance(): UltraScreenRotateViewModel {
    if (UltraScreenRotateViewModel.sInstance == null) {
      UltraScreenRotateViewModel.sInstance = new UltraScreenRotateViewModel();
    }
    return UltraScreenRotateViewModel.sInstance;
  }

  /**
   * 注册三屏旋转回调
   */
  public registerUltraScreenRotateCallback(): void {
    SCBScreenSessionManager.getInstance().registerScreenRotateChangeCallbacks(this.ultraScreenScreenRotateCallback);
  }

  /**
   * 反注册三屏旋转回调
   */
  public unRegisterUltraScreenRotateCallback(): void {
    SCBScreenSessionManager.getInstance().unRegisterScreenRotateChangeCallbacks(this.ultraScreenScreenRotateCallback);
  }

  /**
   * 三屏旋转回调函数
   * @param screenProperty
   * @param reason
   */
  private ultraScreenRotateCallback(screenProperty: SCBScreenProperty, reason: SCBRotateChangeReason): void {
    let displayCountViewModel: DisplayCountViewModel = DisplayCountViewModel.getInstance();
    let displayCount = displayCountViewModel.getDisplayCount();
    if (!this.isNeedChangePageIndex(displayCount)) {
      return;
    }
    let pageIndex = PageInfoManager.getInstance().getPageIndex();
    let startPage = Math.floor(pageIndex / displayCount) * displayCount;
    log.showInfo(TAG,
      '%{public}s startPage%:{public}d, lastPageArr:%{public}s, property:%{public}s, %{public}s',
      reason === SCBRotateChangeReason.ROTATE_BEGIN ? 'rotate begin' : 'rotate end', startPage,
      this.lastPageFrom.join(), screenProperty.getLogString(), displayCountViewModel.getDisplayCountData().log());

    switch (reason) {
      case SCBRotateChangeReason.ROTATE_BEGIN:
        this.ultraScreenRotateCallbackBefore(displayCount, startPage);
        break;
      case SCBRotateChangeReason.ROTATE_END:
        this.ultraScreenRotateCallbackAfter(startPage);
        break;
      default:
        break;
    }
  }

  /**
   * 三屏旋转回调结束调用函数
   */
  private ultraScreenRotateCallbackAfter(startPage: number): void {
    UltraScreenUtils.resetPreNextMargin();
    // 记录3屏设备旋转后的页数
    this.lastPageTo = startPage;
  }

  private isNeedChangePageIndex(displayCount: number): boolean {
    // G态才有记忆能力
    if (ScreenStateMonitor.getInstance().getCurrentScreenStateModel().screenState !== ScreenState.G) {
      log.showInfo(TAG, 'ScreenState id not G, return');
      return false;
    }
    // 只显示单屏返回
    if (displayCount === StyleConstants.DEFAULT_1) {
      log.showInfo(TAG, 'displayCount = 1, return');
      return false;
    }
    return true;
  }

  /**
   * 三屏旋转回调开始调用函数
   * @param displayCount
   * @param startPage
   */
  private ultraScreenRotateCallbackBefore(displayCount: number, startPage: number): void {
    UltraScreenRotateUtils.changePageIndex(displayCount, startPage, this.lastPageFrom, this.lastPageTo);
    this.lastPageFrom = UltraScreenRotateUtils.getCurrentPages(displayCount, startPage);
  }
}