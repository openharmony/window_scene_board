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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { CommonConstants } from '../constants/CommonConstants';
import { GridLayoutItemInfo } from '../TsIndex';
import { OhosLayoutManager } from './OhosLayoutManager';
import { CoverPositionOperator } from './operator/CoverPositionOperator';
import { ExtractOperator } from './operator/ExtractOperator';
import ScreenTransferBean from './ScreenTransferBean';

const TAG = 'OhosCloneLayoutManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.BACKUP, TAG);

export class OhosCloneLayoutManager extends OhosLayoutManager {
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
   * @param screenData 当前屏所有元素
   */
  public realignScreenData(screenData: ScreenTransferBean): void {
    // 创建一个空白宫格记录元素位置
    let occupied: boolean[][] = [];
    // 空白页不会进行后续处理，设置为新机大小布局即可，防止极端场景特殊文件夹找位找到超出的空行
    if (CheckEmptyUtils.isEmptyArr(screenData.children)) {
      this.fillOccupied(occupied, false);
      screenData.occupied = occupied;
      log.showInfo(`current page is black page,page:${screenData.page}`);
      return;
    } else {
      // 系统，需多创建一行，为可能存在的天气widget放大挤位场景预留空间
      for (let i = 0; i < this.fromGrid[1] * 2; i++) {
        let item: boolean[] = new Array(this.toGrid[0]);
        item.fill(false, 0, item.length);
        occupied[i] = item;
      }
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
    // 系统迁移抽离后处理天气卡片新增空白行
    this.addEmptyRowAfterextract(screenData);
    log.showInfo(`extact after page ${screenData.page}, children length: ${screenData.children.length}, ` +
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
   * 系统抽离后处理天气卡片新增空白行
   *
   * @param screenData 当页布局
   */
  public addEmptyRowAfterextract(screenData: ScreenTransferBean): void {
    let hasElement: boolean = screenData.occupied[this.toGrid[1] - 1].find(rowOccupied => rowOccupied) ?? false;
    let widgetIndexArr: number[] = [];
    screenData.children.forEach((baseTransferBean, index) => {
      if (baseTransferBean.typeId === CommonConstants.TYPE_CARD &&
        CommonConstants.TRANSLUCENT_CLOCK_WEATHER_CARD.includes(baseTransferBean.cardName ?? '')) {
        widgetIndexArr.push(index);
      }
    });
    if (hasElement || this.fromGrid[1] >= this.toGrid[1] || widgetIndexArr.length === 0) {
      return;
    }
    this.addWidgetEmptyRow(screenData, widgetIndexArr);
  }
}