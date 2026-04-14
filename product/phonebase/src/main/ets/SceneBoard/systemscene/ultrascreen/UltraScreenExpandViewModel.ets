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

import { LogDomain, Logger, } from '@ohos/basicutils';
import { StyleConstants } from '@ohos/launchercommon';
import { DisplayCountViewModel } from '@ohos/launchercommon/src/main/ets/displaycount/DisplayCountViewModel';
import { PageInfoManager } from '@ohos/launchercommon/src/main/ets/cache/layout/PageInfoManager';
import { UltraScreenUtils } from './UltraScreenUtils';

const TAG = 'UltraScreenExpandViewModel';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

/**
 * 超大屏设备折叠展开view model
 */
export class UltraScreenExpandViewModel {
  private static sInstance: UltraScreenExpandViewModel;

  /**
   * 最近一次旋转后到的页数
   */
  private lastPageTo: number = 0;

  /**
   * 最近一次旋转前到的页数
   */
  private lastPageFrom: number[] = [];

  protected constructor() {
  }

  /**
   * 获取本类单例
   * @returns
   */
  public static getInstance(): UltraScreenExpandViewModel {
    if (UltraScreenExpandViewModel.sInstance == null) {
      UltraScreenExpandViewModel.sInstance = new UltraScreenExpandViewModel();
    }
    return UltraScreenExpandViewModel.sInstance;
  }

  /**
   * 三屏折叠到二屏、二屏折叠到三屏开始时调用
   */
  public ultraScreenExpandBefore(): void {
    let maxDisplayCount: number = PageInfoManager.getInstance().getMaxDisplayCount();
    if (maxDisplayCount !== StyleConstants.DEFAULT_3) {
      log.showInfo(TAG, 'not three display, return');
      return;
    }
    let displayCountViewModel: DisplayCountViewModel = DisplayCountViewModel.getInstance();
    let displayCount = displayCountViewModel.getDisplayCount();
    if (displayCount === StyleConstants.DEFAULT_1) {
      log.showInfo(TAG, 'displayCount = 1, return');
      return;
    }
    if (displayCount === StyleConstants.DEFAULT_3) {
      let curPage: number = PageInfoManager.getInstance().getPageIndex();
      if (curPage % StyleConstants.DEFAULT_6 === StyleConstants.DEFAULT_2) {
        curPage = Math.floor(curPage / StyleConstants.DEFAULT_3) * StyleConstants.DEFAULT_3;
        PageInfoManager.getInstance().updatePageIndex(curPage);
      }
    }
    let startPage = UltraScreenUtils.getStartPage(displayCount);
    UltraScreenUtils.changePageIndexForFoldExpand(displayCount, startPage, this.lastPageFrom, this.lastPageTo);
    this.lastPageFrom = UltraScreenUtils.getCurrentPages(displayCount, startPage);
  }

  /**
   * 在开合动效逻辑处理后调用
   */
  public ultraScreenExpandAfter(): void {
    let maxDisplayCount: number = PageInfoManager.getInstance().getMaxDisplayCount();
    if (maxDisplayCount !== StyleConstants.DEFAULT_3) {
      log.showInfo(TAG, 'not three display, return');
      return;
    }
    let displayCount = DisplayCountViewModel.getInstance().getDisplayCount();
    let startPage = UltraScreenUtils.getStartPage(displayCount);
    // 记录3屏设备旋转后的页数
    this.lastPageTo = startPage;
    log.showInfo(TAG,
      'fold expand end displayCount:%{public}d, startPage:%{public}d, lastPageTo:%{public}d, lastPageArr:%{public}s',
      displayCount, startPage, this.lastPageTo, this.lastPageFrom.join());
  }
}