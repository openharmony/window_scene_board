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

import { CheckEmptyUtils, LogDomain, Logger } from '@ohos/basicutils';
import { AppListInfo, DeviceState, LaunchLayoutCacheManager, StyleConstants } from '@ohos/launchercommon';
import { BusinessType } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { pageEditManager } from '@ohos/launchercommon/Index';
import { DisplayCountViewModel } from '@ohos/launchercommon/src/main/ets/displaycount/DisplayCountViewModel';
import { SwiperLoadData } from '@ohos/swiperdata';
import { launcherStatusUtil } from '@ohos/windowscene';

const TAG = 'BlankPageViewModel';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

/**
 * 空白页管理类
 */
export class BlankPageViewModel {
  private static mInstance: BlankPageViewModel;

  /**
   * 获取单例
   * @returns 单例
   */
  public static getInstance(): BlankPageViewModel {
    if (!BlankPageViewModel.mInstance) {
      BlankPageViewModel.mInstance = new BlankPageViewModel();
    }
    return BlankPageViewModel.mInstance;
  }

  private addBlankPage(appListInfo: AppListInfo, addCount: number): void {
    const isOuter = launcherStatusUtil.getShowOutLauncherStatus();
    const currentMaxKey: number = SwiperLoadData.getInstance().getPageMaxValue();
    for (let i = 0; i < addCount; i++) {
      appListInfo.appGridInfo.push([]);
      pageEditManager.getRealBlankPageList(isOuter).set(currentMaxKey + 1 + i, false);
    }
    LaunchLayoutCacheManager.getInstance()
      .updatePageCount(appListInfo.appGridInfo.length, BusinessType.BUSINESS_BASIC_DESKTOP, true, false);
    log.showInfo(TAG, 'after addLastBlankPage, pages:%{public}d, addCount:%{public}d',
      appListInfo.appGridInfo.length, addCount);
  }

  private deleteBlankPage(appListInfo: AppListInfo, deleteCount: number): void {
    for (let i = 0; i < deleteCount; i++) {
      let lastPageIndex = appListInfo.appGridInfo.length - 1;
      if (this.canDeleteBlankPage(appListInfo, lastPageIndex)) {
        appListInfo.appGridInfo.pop();
        log.showInfo(TAG, 'deleteBlankPage pageIndex:%{public}d deleteCount:%{public}d deleteIndex:%{public}d', lastPageIndex, deleteCount, i);
      }
    }
    LaunchLayoutCacheManager.getInstance()
      .updatePageCount(appListInfo.appGridInfo.length, BusinessType.BUSINESS_BASIC_DESKTOP, true);
  }

  /**
   * 最后2页是否能删除
   * @param appListInfo AppListInfo
   * @returns 最后2页是否能删除
   */
  public canDeleteLastTwoBlankPage(appListInfo: AppListInfo): boolean {
    if (!appListInfo || !appListInfo.appGridInfo) {
      return false;
    }
    let lastPageIndex = appListInfo.appGridInfo.length - 1;
    // 最后1屏是否可以删除
    if (!this.canDeleteBlankPage(appListInfo, lastPageIndex)) {
      log.showInfo(TAG, 'canDeleteBlankPage pageIndex[%{public}d] can not delete', lastPageIndex);
      return false;
    }
    // 倒数第2屏是否可以删除
    if (this.canDeleteBlankPage(appListInfo, lastPageIndex - 1)) {
      return true;
    }
    log.showInfo(TAG, 'canDeleteBlankPage pageIndex[%{public}d] can not delete', lastPageIndex - 1);
    return false;
  }

  private canDeleteBlankPage(appListInfo: AppListInfo, pageIndex: number): boolean {
    if (!appListInfo || !appListInfo.appGridInfo) {
      return false;
    }
    if (!CheckEmptyUtils.isEmptyArr(appListInfo.appGridInfo[pageIndex])) {
      log.showInfo(TAG, 'canDeleteBlankPage pageIndex[%{public}d] is not blank page', pageIndex);
      return false;
    }
    let ret = LaunchLayoutCacheManager.getInstance().isBlankPageAddedByEditMode(pageIndex, false);
    if (ret) {
      log.showInfo(TAG, 'canDeleteBlankPage pageIndex[%{public}d] is added by edit mode', pageIndex);
    }
    return !ret;
  }

  /**
   * 处理添加或者删除空白页逻辑
   * @param appListInfo
   * @param folderStatus
   */
  public dealBlankPage(appListInfo: AppListInfo, folderStatus: DeviceState): void {
    let displayCount = DisplayCountViewModel.getInstance().getDisplayCount();
    let appGridInfoLength = appListInfo.appGridInfo.length;
    log.showInfo(TAG, 'dealBlankPage displayCount:%{public}d, folderStatus:%{public}d, page:%{public}d',
      displayCount, folderStatus, appGridInfoLength);
    if (folderStatus === DeviceState.DEFAULT_STATE) {
      this.deleteBlankPage(appListInfo, 2);
      return;
    }
    let modulus = appGridInfoLength % displayCount;
    if (displayCount === StyleConstants.DEFAULT_2) {
      /**
       * 如果是奇数屏
       * 1. 最后1屏是空白屏，删除空白屏
       * 2. 最后1屏不是空白屏，补1页空白屏
       */
      if (modulus === StyleConstants.DEFAULT_1) {
        let lastPageIndex = appListInfo.appGridInfo.length - 1;
        // 最后1屏是空白屏，删除空白屏
        if (this.canDeleteBlankPage(appListInfo, lastPageIndex)) {
          this.deleteBlankPage(appListInfo, modulus);
        } else {
          this.addBlankPage(appListInfo, modulus);
        }
      } else {
        let lastPageIndex = appListInfo.appGridInfo.length - 1;
        // 如果是偶数屏，最后2屏是新增导致的空白屏，删除最后2页的空白屏
        if (this.canDeleteLastTwoBlankPage(appListInfo)) {
          this.deleteBlankPage(appListInfo, 2);
        }
      }
      return;
    }
    if (displayCount === StyleConstants.DEFAULT_3) {
      let lastPageIndex = appListInfo.appGridInfo.length - 1;
      if (modulus === StyleConstants.DEFAULT_1) {
        if (this.canDeleteBlankPage(appListInfo, lastPageIndex)) {
          this.deleteBlankPage(appListInfo, modulus);
        } else {
          // 最后1屏不是空白屏，加2个空白屏
          this.addBlankPage(appListInfo, displayCount - modulus);
        }
      } else if (modulus === StyleConstants.DEFAULT_2) {
        // 删除2个空白屏
        if (this.canDeleteLastTwoBlankPage(appListInfo)) {
          this.deleteBlankPage(appListInfo, modulus);
        } else {
          this.addBlankPage(appListInfo, displayCount - modulus);
        }
      }
    }
  }
}