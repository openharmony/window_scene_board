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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DragGridPosition } from '@ohos/componentdrag';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  GridLayoutItemInfo,
  LauncherLayoutCacheConfig, LaunchLayoutCacheManager, LayoutDescription } from '@ohos/launchercommon';
import { ItemParameter } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { DesktopLayoutManager } from '@ohos/pagedesktop/src/main/ets/default/manager/DesktopLayoutManager';

const TAG = 'PcDesktopLayoutManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class PcDesktopLayoutManager extends DesktopLayoutManager {

  private launcherLayoutCacheManager: LaunchLayoutCacheManager;

  constructor(launcherLayoutCacheManager?: LaunchLayoutCacheManager) {
    super();
    if (launcherLayoutCacheManager) {
      this.launcherLayoutCacheManager = launcherLayoutCacheManager;
    } else {
      this.launcherLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
    }
  }

  public isAvailablePosition(column: number, row: number, page: number): boolean {
      return !this.launcherLayoutCacheManager.isPositionOccupied(page, column, row);
  }

  public getItemPositionInScreen(area: GridLayoutItemInfo | ItemParameter,
    startPage: number): DragGridPosition | null {
    const searchPageCnt = this.getCurStateScreenPageCnt();
    startPage -= startPage % searchPageCnt;
    return this.getAvailablePosition(area, startPage, searchPageCnt, false);
  }

  public getCurStateScreenPageCnt(): number {
    return 1;
  }
  
  private getAvailablePosition(item: GridLayoutItemInfo | ItemParameter, startPage: number,
    searchPageCnt: number, isHorizontal: boolean): DragGridPosition | null {
    const layout: LayoutDescription = this.launcherLayoutCacheManager.selectLayoutDescription();
    const column = layout.column;
    const row = layout.row;
    log.showInfo(`layoutParam:${item.area}, ${startPage}, ${searchPageCnt}, ${column}, ${row}, ${layout.pageCount}, ${isHorizontal}`);
    searchPageCnt = Math.min(layout.pageCount - startPage, searchPageCnt);
    const maxColumn = isHorizontal ? column * searchPageCnt : column;
    const maxRow = isHorizontal ? row : row * searchPageCnt;
    for (let y = 0; y < maxColumn; y++) {
      for (let x = 0; x < maxRow; x++) {
        const curPage = startPage + Math.floor(y / column) + Math.floor(x / row);
        let positionX = y % column;
        let positionY = x % row;
        if (this.launcherLayoutCacheManager.isPositionValid(item, curPage, positionX, positionY)) {
          log.showInfo(`getAvailablePosition:${positionX}, ${positionY}, ${curPage}`);
          return { row: positionY, column: positionX, page: curPage };
        }
      }
    }
    return null;
  }
}