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

import { LogDomain, Logger } from '@ohos/basicutils';
import { desktopUtil } from '@ohos/componenthelper';
import { AppListInfo, PageInfoManager, StyleConstants } from '@ohos/launchercommon';
import { DisplayCountViewModel } from '@ohos/launchercommon/src/main/ets/displaycount/DisplayCountViewModel';
import { BlankPageViewModel } from '@ohos/pagedesktop/src/main/ets/default/common/viewmodel/BlankPageViewModel';

const TAG = 'UltraScreenRotateUtils';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

// 超大屏设备每6页一组计算
const ULTRA_SCREEN_GROUP = 6;

/**
 * 超大屏旋转、开合工具类
 */
export class UltraScreenRotateUtils {
  /**
   * 获取折叠屏设备最左侧页数
   * @returns
   */
  public static getStartPage(displayCount: number): number {
    let pageIndex = PageInfoManager.getInstance().getPageIndex();
    return Math.floor(pageIndex / displayCount) * displayCount;
  }


  /**
   * 获取当前页数
   * 如果显示3屏，返回首页以及后面2页
   * 如果显示2屏，返回首页以及后面1页
   * @param displayCount 显示屏数
   * @param startPage 起始页
   * @returns 获取当前页数
   */
  public static getCurrentPages(displayCount: number, startPage: number): number[] {
    // 记录3屏设备旋转前的页数
    let lastPageArr: number[] = [];
    lastPageArr.push(startPage);
    lastPageArr.push(startPage + 1);
    if (displayCount === StyleConstants.DEFAULT_3) {
      lastPageArr.push(startPage + 2);
    }
    return lastPageArr;
  }

  /**
   * 判断是否是以下三个场景选择，需要把pageIndex修改为中间页数
   * 3 4 5页 --旋转到--> 4 5页
   * 9 10 11页 ---旋转到--> 10 11页
   * 16 17 18页 --旋转到--> 17 18页
   */
  private static isChangeToLastTwoPage(displayCount: number, startPage: number): boolean {
    let isNeedChange =
      displayCount === StyleConstants.DEFAULT_3 && (startPage - displayCount) % (displayCount * 2) === 0;
    if (isNeedChange) {
      let totalPageCount = PageInfoManager.getInstance().getPageCount();
      // 如果不是最后3屏
      if (startPage + displayCount < totalPageCount) {
        return true;
      }
      let appListInfo = AppStorage.get(desktopUtil.getAppListInfo()) as AppListInfo;
      if (appListInfo && appListInfo.appGridInfo) {
        // 如果是最后3屏，只有最后2屏不是空白屏才满足条件
        if (appListInfo.appGridInfo[totalPageCount - 1]?.length === 0 &&
          appListInfo.appGridInfo[totalPageCount - 2]?.length === 0) {
          log.showInfo(TAG, 'last two page is blank page');
          return false;
        } else {
          log.showInfo(TAG, 'last two page is not blank page');
          return true;
        }
      }
    }
    return false;
  }

  /**
   * 对于超大屏，如果有旋转，重新修正pageIndex
   * 由于超大屏设备会有从3屏旋转到2屏，2屏旋转到3屏，旋转页数不一致，需要对pageIndex做修正
   * @param index
   */
  public static changePageIndex(displayCount: number, startPage: number, lastPageFrom: number[],
    lastPageTo: number): void {
    log.showInfo(TAG, 'lastPageTo:%{public}d, startPage:%{public}d, displayCount:%{public}d, lastPageArr:%{public}s',
      lastPageTo, startPage, displayCount, lastPageFrom.join());
    /**
     * 1. 如果最左侧页不是上次旋转来的，不需要记忆上次旋转的页数
     * 2. 如果查询不到上次旋转记录，不需要记忆上次旋转的页数
     */
    if (lastPageTo !== startPage || !lastPageFrom || lastPageFrom.length === 0) {
      UltraScreenRotateUtils.changeToLastTwoPage(displayCount, startPage, lastPageTo);
      return;
    }

    // 旋转或者折叠展开到到上次的页数
    if (displayCount === StyleConstants.DEFAULT_3) {
      UltraScreenRotateUtils.threeRotateTwo(startPage, lastPageFrom);
      return;
    }
    if (displayCount === StyleConstants.DEFAULT_2) {
      UltraScreenRotateUtils.twoRotateThree(startPage, lastPageFrom);
    }
  }

  private static changeToLastTwoPage(displayCount: number, startPage: number, lastPageTo: number): void {
    if (UltraScreenRotateUtils.isChangeToLastTwoPage(displayCount, startPage)) {
      log.showInfo(TAG, 'not from last rotate, lastPageTo:%{public}d startPage:%{public}d', lastPageTo,
        startPage);
      // 中间页 + 右页做动效，保持左页不下树，比如 456 旋转到 56
      PageInfoManager.getInstance().updatePageIndex(startPage + 1);
      return;
    }
    // 中间页 + 左页做动效，保持右页不下树，比如 789 旋转到 78
    log.showInfo(TAG, 'rotate does not change page index, lastPageTo:%{public}d startPage:%{public}d',
      lastPageTo, startPage);
    if (UltraScreenRotateUtils.isNeedSetCacheCount(startPage)) {
      // 中间页 + 左页做动效，保持右页不下树，比如 34 旋转到 123
      DisplayCountViewModel.getInstance().setCacheCount(1);
    }
  }

  private static threeRotateTwo(startPage: number, lastPageFrom: number[]): void {
    let displayCountViewModel: DisplayCountViewModel = DisplayCountViewModel.getInstance();
    if (lastPageFrom.indexOf(startPage) !== -1) {
      // 中间页 + 左页做动效，保持右页不下树，比如 789 旋转到 78
      return;
    }
    if (lastPageFrom.indexOf(startPage + 1) !== -1) {
      // 中间页 + 右页做动效，保持左页不下树，比如 456 旋转到 56
      let appListInfo = AppStorage.get(desktopUtil.getAppListInfo()) as AppListInfo;
      let pageCount = appListInfo?.appGridInfo?.length ?? 0;
      let displayCount = displayCountViewModel.getDisplayCount();
      let lastPageIndex = Math.floor((pageCount - 1) / displayCount) * displayCount;
      log.showInfo(TAG, 'threeRotateTwo rotate to last two page, startPage:%{public}d pageCount:%{public}d', startPage,
        pageCount);
      // 456 旋转为例，如果56是虚拟空白页
      if (lastPageIndex === startPage &&BlankPageViewModel.getInstance().canDeleteLastTwoBlankPage(appListInfo)) {
        log.showInfo(TAG, 'do not change page index startPage:%{public}d lastPageArr:%{public}s', startPage,
          lastPageFrom.join());
        return;
      }

      PageInfoManager.getInstance().updatePageIndex(startPage + 1);
      return;
    }
    if (lastPageFrom.indexOf(startPage + 2) !== -1) {
      PageInfoManager.getInstance().updatePageIndex(startPage + 2);
      // 针对123 旋转到 34等场景，需要让前2页不要下树场景，设置cacheCount=2
      if (UltraScreenRotateUtils.isNeedSetCacheCount(startPage + 2)) {
        DisplayCountViewModel.getInstance().setCacheCount(1);
      }
    }
  }

  private static twoRotateThree(startPage: number, lastPageFrom: number[]): void {
    if (lastPageFrom.indexOf(startPage) !== -1) {
      if (UltraScreenRotateUtils.isNeedSetCacheCount(startPage)) {
        // 中间页 + 左页做动效，保持右页不下树，比如 34 旋转到 123
        DisplayCountViewModel.getInstance().setCacheCount(1);
      }
      return;
    }
    if (lastPageFrom.indexOf(startPage + 1) !== -1) {
      // 中间页 + 右页做动效，保持左页不下树，比如 34 旋转到 456
      PageInfoManager.getInstance().updatePageIndex(startPage + 1);
    }
  }

  /**
   * 计算是否需要设置cacheCount
   * @param pageIndex
   * @returns
   */
  private static isNeedSetCacheCount(pageIndex: number): boolean {
    let module: number = pageIndex % ULTRA_SCREEN_GROUP;
    return module === 2 || module === 3;
  }
}