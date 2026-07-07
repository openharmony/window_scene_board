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

import { CheckEmptyUtils, LogDomain, Logger } from '@ohos/basicutils/src/main/ets/TsIndex';
import { ObjectCopyUtil } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { GridLayoutItemInfo } from '../TsIndex';
import { BaseTransferBean } from './BaseTransferBean';
import { BaseTransferLayoutManager } from './BaseTransferLayoutManager';
import ScreenTransferBean from './ScreenTransferBean';

const TAG = 'OhosLayoutManager';
const log: Logger = Logger.getLogHelper(LogDomain.BACKUP);

export class OhosLayoutManager extends BaseTransferLayoutManager {
  /**
   * 转换布局
   *
   * @param oldLayoutInfo 旧机布局
   * @param isOuter 是否是外屏
   * @returns 新机布局
   */
  public async transferLayout(oldLayoutInfo: GridLayoutItemInfo [], isOuter?: boolean): Promise<boolean> {
    return super.transferLayout(oldLayoutInfo, isOuter);
  }

  /**
   * 5x转4x之后，需将当前页抽离出来的多余元素重新在当前页找空位放置
   *
   * @param screenData
   * @returns
   */
  public fillBackExtraElements(screenData: ScreenTransferBean): void {
    if (CheckEmptyUtils.isEmptyArr(screenData.moveToNextPage)) {
      log.showWarn(TAG, 'there is no extra element after 5x to 4x.');
      return;
    }
    // 抽离元素插入顺序按照 大小 > 相对顺序 排序
    screenData.moveToNextPage.sort((a, b) => {
      return this.compare(a, b);
    });
    let needFillBackElements: number[] = [];
    for (let i = 0; i < screenData.moveToNextPage.length; i++) {
      let extraElement: BaseTransferBean = ObjectCopyUtil.deepClone(screenData.moveToNextPage[i]);
      let isFind: boolean = this.findAreafromToGrid(screenData.occupied, extraElement);
      if (isFind) {
        log.showInfo(TAG, `rediscovered position ,boundlename:${extraElement.bundleName},page:${extraElement.page},row:${extraElement.row},column:${extraElement.column}`);
        this.fillOccupied(screenData.occupied, true, extraElement);
        screenData.children.push(extraElement);
        needFillBackElements.push(i);
      }
    }
    needFillBackElements.reverse().forEach(index => {
      screenData.moveToNextPage.splice(index, 1);
    });
  }

  /**
   * 按新机的布局查找桌面宫格中为每个布局元素寻找合适的位置
   *
   * @param occupied 桌面宫格
   * @param transferBean 单个布局元素
   * @returns 返回是否找位成功
   */
  public findAreafromToGrid(occupied: boolean[][], transferBean: BaseTransferBean): boolean {
    if (CheckEmptyUtils.isEmptyArr(transferBean?.area)) {
      return false;
    }
    for (let i = 0; i < this.toGrid[1]; i++) {
      if (!transferBean.area) {
        continue;
      }
      // 如果元素实际行数超过新机布局最大行数则直接返回
      if (transferBean.area[1] + i > this.toGrid[1]) {
        return false;
      }
      for (let j = 0; j < this.toGrid[0]; j++) {
        if (occupied[i][j]) {
          continue;
        }
        if (this.validElementArea(occupied, transferBean.area, i, j)) {
          transferBean.row = i;
          transferBean.column = j;
          return true;
        }
      }
    }
    return false;
  }
}