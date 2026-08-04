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
import { ThreeFoldRotateUtils } from './ThreeFoldRotateUtils';
import { ThreeFoldUtils } from './ThreeFoldUtils';

const TAG = 'ThreeFoldRotateViewModel';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

/**
 * 三折叠设备旋转view model
 */
export class ThreeFoldRotateViewModel {
  private static sInstance: ThreeFoldRotateViewModel;

  /**
   * 最近一次旋转后到的页数
   */
  private lastPageTo: number = 0;

  /**
   * 最近一次旋转前到的页数
   */
  private lastPageFrom: number[] = [];

  private threeFoldScreenRotateCallback =
    (screenProperty: SCBScreenProperty, reason: SCBRotateChangeReason) => this.threeFoldRotateCallback(screenProperty,
      reason);

  protected constructor() {
  }

  /**
   * 获取本类单例
   * @returns
   */
  public static getInstance(): ThreeFoldRotateViewModel {
    if (ThreeFoldRotateViewModel.sInstance == null) {
      ThreeFoldRotateViewModel.sInstance = new ThreeFoldRotateViewModel();
    }
    return ThreeFoldRotateViewModel.sInstance;
  }

  /**
   * 注册三屏旋转回调
   */
  public registerThreeFoldRotateCallback(): void {
    SCBScreenSessionManager.getInstance().registerScreenRotateChangeCallbacks(this.threeFoldScreenRotateCallback);
  }

  /**
   * 反注册三屏旋转回调
   */
  public unRegisterThreeFoldRotateCallback(): void {
    SCBScreenSessionManager.getInstance().unRegisterScreenRotateChangeCallbacks(this.threeFoldScreenRotateCallback);
  }

  /**
   * 三屏旋转回调函数
   * @param screenProperty
   * @param reason
   */
  private threeFoldRotateCallback(screenProperty: SCBScreenProperty, reason: SCBRotateChangeReason): void {
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
        this.threeFoldRotateCallbackBefore(displayCount, startPage);
        break;
      case SCBRotateChangeReason.ROTATE_END:
        this.threeFoldRotateCallbackAfter(startPage);
        break;
      default:
        break;
    }
  }

  /**
   * 三屏旋转回调结束调用函数
   */
  private threeFoldRotateCallbackAfter(startPage: number): void {
    ThreeFoldUtils.resetPreNextMargin();
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
  private threeFoldRotateCallbackBefore(displayCount: number, startPage: number): void {
    ThreeFoldRotateUtils.changePageIndex(displayCount, startPage, this.lastPageFrom, this.lastPageTo);
    this.lastPageFrom = ThreeFoldRotateUtils.getCurrentPages(displayCount, startPage);
  }
}