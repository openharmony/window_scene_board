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

import { CommonUtils, LogDomain, Logger } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GridLayoutItemInfo } from '../TsIndex';
import { OhosLayoutManager } from './OhosLayoutManager';
import ScreenTransferBean from './ScreenTransferBean';
import { ExtractOperator } from './operator/ExtractOperator';
import { CoverPositionOperator } from './operator/CoverPositionOperator';
import { NumberConstants } from '@ohos/commonconstants';

const TAG = 'OhosMigrateLayoutManager';
const log: Logger = Logger.getLogHelper(LogDomain.BACKUP);

export class OhosMigrateLayoutManager extends OhosLayoutManager {

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
   * 将当前屏的元素按照维持方案进行排列
   *
   * @param screenData 当前屏所有元素
   */
  public realignScreenData(screenData: ScreenTransferBean): void {
    // 创建一个空白宫格记录元素位置
    let occupied: boolean[][] = [];
    // 系统，需多创建行，为可能存在的天气widget放大挤位场景预留空间
    for (let i = 0; i < this.fromGrid[1] * 2; i++) {
      let item: boolean[] = new Array(this.toGrid[0]);
      item.fill(false, 0, item.length);
      occupied[i] = item;
    }
    // 每屏第一个天气widget进行放大挤位处理
    this.isFirstWidgetProcessed = false;
    this.realignByMaintenance(screenData, occupied);
    // 将每屏的宫格布局记录下来
    screenData.occupied = occupied;
    // 如果旧机的列数大于新机则将抽离的元素在当前屏幕再次排序
    if (this.fromGrid[0] > this.toGrid[0]) {
      this.fillBackExtraElements(screenData);
      // 执行补位操作
      CoverPositionOperator.coverPosition(screenData);
      // 如果补位完还有未处理的抽离元素则再次在当页找位
      this.fillBackExtraElements(screenData);
    }
    ExtractOperator.extract(screenData, this.toGrid);
    log.showInfo(TAG, `extact after page ${screenData.page}, children length: ${screenData.children.length}, ` +
      `movetolast: ${screenData.moveToNextPage.length}`);
  }

  /**
   * 生成桌面布局列表
   *
   * @returns 返回最终桌面布局
   */
  public getNewLayoutFromScreenDataMap(): GridLayoutItemInfo[] {
    // 处理卡片缩小
    this.dealFormStackElement();
    // dock区合并
    this.dockList = this.dealWithExcessiveDockList(this.dockList);
    // 校验重复元素后返回
    return super.getNewLayoutFromScreenDataMap();
  }

  /**
   * 收集旧机重复元素
   *
   * @param oldLayoutInfo 旧机待恢复元素
   * @returns 重复元素集合
   */
  public collectDuplicateApp(oldLayoutInfo: GridLayoutItemInfo[]): Map<string, GridLayoutItemInfo[]> {
    let manyToOneMapping: Map<string, GridLayoutItemInfo[]> = new Map();
    oldLayoutInfo.forEach(item => {
      if (CommonUtils.jsonStrToMap(item.intent).get('multiMappingRelationship') !== NumberConstants.CONSTANT_NUMBER_ONE) {
        return;
      }
      if (manyToOneMapping.has(item.bundleName)) {
        manyToOneMapping.get(item.bundleName)?.push(item);
      } else {
        manyToOneMapping.set(item.bundleName, [item]);
      }
    });
    return manyToOneMapping;
  }

}