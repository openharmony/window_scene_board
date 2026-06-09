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
import { RTLUtil, desktopUtil } from '@ohos/componenthelper';
import { AppListInfo, PageInfoManager, StyleConstants } from '@ohos/launchercommon';
import { DisplayCountData } from '@ohos/launchercommon/src/main/ets/displaycount/DisplayCountData';
import { DisplayCountViewModel } from '@ohos/launchercommon/src/main/ets/displaycount/DisplayCountViewModel';
import { BlankPageViewModel } from '@ohos/pagedesktop/src/main/ets/default/common/viewmodel/BlankPageViewModel';
import { ScreenState } from '@ohos/frameworkwrapper';

const TAG = 'UltraScreenUtils';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
const PRE_NEXT_MARGIN = 0.01;

/**
 * 超大屏旋转、开合工具类
 */
export class UltraScreenUtils {
  private static isCurrentRTL: boolean = false;
  /**
   * 获取折叠屏设备最左侧页数
   * @returns
   */
  public static getStartPage(displayCount: number): number {
    let pageIndex = PageInfoManager.getInstance().getPageIndex();
    return Math.floor(pageIndex / displayCount) * displayCount;
  }

  /**
   * 还原PreMargin,NextMargin
   */
  public static resetPreNextMargin(): void {
    let displayCountViewModel: DisplayCountViewModel = DisplayCountViewModel.getInstance();
    log.showInfo(TAG, `resetPreNextMargin ${displayCountViewModel.getDisplayCountData().log()}`);
    if (displayCountViewModel.getNextMargin() !== 0) {
      displayCountViewModel.setNextMargin(0);
    }
    if (displayCountViewModel.getPreMargin() !== 0) {
      displayCountViewModel.setPreMargin(0);
    }
    if (displayCountViewModel.getCacheCount() !== 0) {
      displayCountViewModel.setCacheCount(0);
    }
  }

  /**
   * ultraScreenExpandBefore仅在MG状态切换时调用，针对FG切换，仅在维吾尔语条件下，GTF场景需要延迟下树
   */
  public static setGTFPreNextMargin(curState: ScreenState, lastState: ScreenState): void {
    let maxDisplayCount: number = PageInfoManager.getInstance().getMaxDisplayCount();
    if (maxDisplayCount !== StyleConstants.DEFAULT_3) {
      log.showInfo(TAG, 'not three display, return');
      return;
    }
    if (curState === ScreenState.F && lastState === ScreenState.G && RTLUtil.isRTL()) {
      DisplayCountViewModel.getInstance().setNextMargin(PRE_NEXT_MARGIN);
      let displayCountData: DisplayCountData = DisplayCountViewModel.getInstance().getDisplayCountData();
      displayCountData.setCacheCount(1);
    }
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
      UltraScreenUtils.changeToLastTwoPage(displayCount, startPage, lastPageTo);
      return;
    }

    // 旋转或者折叠展开到到上次的页数
    if (displayCount === StyleConstants.DEFAULT_3) {
      UltraScreenUtils.threeRotateTwo(startPage, lastPageFrom);
      return;
    }
    if (displayCount === StyleConstants.DEFAULT_2) {
      UltraScreenUtils.twoRotateThree(startPage, lastPageFrom);
    }
  }

  /**
   * 对于超大屏部分开合场景，需要重新修正pageIndex
   *
   * @param displayCount 当前屏幕形态显示页面数量
   * @param startPage 当前开合页面
   * @param lastPageFrom 最近一次开合前的页面
   * @param lastPageTo 最近一次开合后显示的页面
   */
  public static changePageIndexForFoldExpand(displayCount: number, startPage: number, lastPageFrom: number[],
    lastPageTo: number): void {
    log.showInfo(TAG, 'lastPageTo:%{public}d, startPage:%{public}d, displayCount:%{public}d, lastPageArr:%{public}s',
      lastPageTo, startPage, displayCount, lastPageFrom.join());
    // 1. 如果最左侧页不是上次开合来的，不需要记忆上次开合的页数; 2. 如果查询不到上次开合记录，不需要记忆上次开合的页数
    if (lastPageTo !== startPage || !lastPageFrom || lastPageFrom.length === 0) {
      UltraScreenUtils.changeToLastTwoPageForFoldExpand(displayCount, startPage, lastPageTo);
      return;
    }
    // 由于不同语言之间规格存在差异，切换语言后不可遵循记忆规则
    if (UltraScreenUtils.isCurrentRTL !== RTLUtil.isRTL()) {
      UltraScreenUtils.changeToLastTwoPageForFoldExpand(displayCount, startPage, lastPageTo);
      UltraScreenUtils.isCurrentRTL = RTLUtil.isRTL();
      return;
    }
    // 折叠到到上次的页数,复用旋转逻辑
    if (displayCount === StyleConstants.DEFAULT_3) {
      UltraScreenUtils.ultraScreenTwo(startPage, lastPageFrom);
      return;
    }
    // 展开到到上次的页数，存在特殊场景：M态共10页，0-8页存在图标，第9页无图标，该场景下需要做特殊处理
    if (displayCount === StyleConstants.DEFAULT_2) {
      UltraScreenUtils.twoExpandThree(startPage, lastPageFrom);
    }
  }

  private static changeToLastTwoPageForFoldExpand(displayCount: number, startPage: number, lastPageTo: number): void {
    // 中间页 + 右页做动效，保持左页不下树，比如 345 -> 45
    if (UltraScreenUtils.isChangeToLastTwoPage(displayCount, startPage)) {
      log.showInfo(TAG, `not from last fold or expand, lastPageTo:${lastPageTo} startPage:${startPage}`);
      PageInfoManager.getInstance().updatePageIndex(startPage + 1);
      DisplayCountViewModel.getInstance().setPreMargin(PRE_NEXT_MARGIN);
      return;
    }
    // 为了保持桌面图标与dock动画方向的一致性，新增规格：中文：23 -> 345; 维吾尔语：23->012
    if (!RTLUtil.isRTL() && displayCount === StyleConstants.DEFAULT_2 &&
      startPage % StyleConstants.DEFAULT_3 === StyleConstants.DEFAULT_2) {
      let totalPageCount = PageInfoManager.getInstance().getPageCount();
      let appListInfo = AppStorage.get(desktopUtil.getAppListInfo()) as AppListInfo;
      // 特殊场景：M态共10页，第0-8页存在图标，第9页空白，此时，需要无需遵循原规格8/9 -> 9/10/11，而是8/9 -> 6/7/8
      if (startPage + displayCount === totalPageCount && appListInfo && appListInfo.appGridInfo &&
        appListInfo.appGridInfo[totalPageCount - 1]?.length === 0) {
        return;
      }
      PageInfoManager.getInstance().updatePageIndex(startPage + 1);
      DisplayCountViewModel.getInstance().setNextMargin(PRE_NEXT_MARGIN);
      let displayCountData: DisplayCountData = DisplayCountViewModel.getInstance().getDisplayCountData();
      displayCountData.setCacheCount(1);
      return;
    }
    log.showInfo(TAG, `fold or expand does not change page index, lastPageTo:${lastPageTo} startPage:${startPage}`);
    // 中间页 + 左页做动效，保持右页不下树，比如 678 -> 67
    DisplayCountViewModel.getInstance().setNextMargin(PRE_NEXT_MARGIN);
  }

  private static changeToLastTwoPage(displayCount: number, startPage: number, lastPageTo: number): void {
    if (UltraScreenUtils.isChangeToLastTwoPage(displayCount, startPage)) {
      log.showInfo(TAG, 'not from last rotate, lastPageTo:%{public}d startPage:%{public}d', lastPageTo,
        startPage);
      PageInfoManager.getInstance().updatePageIndex(startPage + 1);
      // 中间页 + 右页做动效，保持左页不下树，比如 456 旋转到 56
      DisplayCountViewModel.getInstance().setPreMargin(PRE_NEXT_MARGIN);
      return;
    }
    log.showInfo(TAG, 'rotate does not change page index, lastPageTo:%{public}d startPage:%{public}d',
      lastPageTo, startPage);
    // 中间页 + 左页做动效，保持右页不下树，比如 789 旋转到 78
    DisplayCountViewModel.getInstance().setNextMargin(PRE_NEXT_MARGIN);
  }

  private static threeRotateTwo(startPage: number, lastPageFrom: number[]): void {
    let displayCountViewModel: DisplayCountViewModel = DisplayCountViewModel.getInstance();
    if (lastPageFrom.indexOf(startPage) !== -1) {
      // 中间页 + 左页做动效，保持右页不下树，比如 789 旋转到 78
      displayCountViewModel.setNextMargin(PRE_NEXT_MARGIN);
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
      if (lastPageIndex === startPage && BlankPageViewModel.getInstance().canDeleteLastTwoBlankPage(appListInfo)) {
        log.showInfo(TAG, 'do not change page index startPage:%{public}d lastPageArr:%{public}s', startPage,
          lastPageFrom.join());
        return;
      }

      PageInfoManager.getInstance().updatePageIndex(startPage + 1);
      displayCountViewModel.setPreMargin(PRE_NEXT_MARGIN);
      return;
    }
    if (lastPageFrom.indexOf(startPage + 2) !== -1) {
      PageInfoManager.getInstance().updatePageIndex(startPage + 2);
      // 中间页 + 右页做动效，保持左页不下树，比如 123 旋转到 34
      displayCountViewModel.setPreMargin(PRE_NEXT_MARGIN);
      // 针对123 旋转到 34等场景，需要让前2页不要下树场景，设置cacheCount=2
      let displayCountData: DisplayCountData = displayCountViewModel.getDisplayCountData();
      displayCountData.setCacheCount(1);
    }
  }

  private static twoRotateThree(startPage: number, lastPageFrom: number[]): void {
    if (lastPageFrom.indexOf(startPage) !== -1) {
      // 中间页 + 左页做动效，保持右页不下树，比如 34 旋转到 123
      DisplayCountViewModel.getInstance().setNextMargin(PRE_NEXT_MARGIN);
      return;
    }
    if (lastPageFrom.indexOf(startPage + 1) !== -1) {
      PageInfoManager.getInstance().updatePageIndex(startPage + 1);
      // 中间页 + 右页做动效，保持左页不下树，比如 34 旋转到 456
      DisplayCountViewModel.getInstance().setPreMargin(PRE_NEXT_MARGIN);
    }
  }

  private static ultraScreenTwo(startPage: number, lastPageFrom: number[]): void {
    // 特殊场景：345 -> 23，需要4、5页延迟下树，开合做专门的处理
    if (!RTLUtil.isRTL() && startPage % StyleConstants.DEFAULT_6 === StyleConstants.DEFAULT_3 &&
      lastPageFrom.indexOf(startPage) !== -1) {
      DisplayCountViewModel.getInstance().setNextMargin(PRE_NEXT_MARGIN);
      let displayCountData: DisplayCountData = DisplayCountViewModel.getInstance().getDisplayCountData();
      displayCountData.setCacheCount(1);
      return;
    }
    UltraScreenUtils.threeRotateTwo(startPage, lastPageFrom);
  }

  private static twoExpandThree(startPage: number, lastPageFrom: number[]): void {
    // 特殊场景：M态共10页，第0-8页存在图标，第9页空白；如果在经过一次记忆后，将第8页图标部分整理到第9页，此时不能遵循记忆规则，开合做特殊处理
    let totalPageCount = PageInfoManager.getInstance().getPageCount();
    if (!RTLUtil.isRTL() && startPage % StyleConstants.DEFAULT_3 === StyleConstants.DEFAULT_2 &&
      (startPage + StyleConstants.DEFAULT_2 === totalPageCount)) {
      let appListInfo = AppStorage.get(desktopUtil.getAppListInfo()) as AppListInfo;
      // 该场景下，原本第9页已从空白屏变为存在图标的页面，不再遵循原本的记忆
      if (appListInfo && appListInfo.appGridInfo && appListInfo.appGridInfo[totalPageCount - 1]?.length !== 0) {
        PageInfoManager.getInstance().updatePageIndex(startPage + 1);
      }
      DisplayCountViewModel.getInstance().setPreMargin(PRE_NEXT_MARGIN);
      return;
    }
    UltraScreenUtils.twoRotateThree(startPage, lastPageFrom);
  }
}