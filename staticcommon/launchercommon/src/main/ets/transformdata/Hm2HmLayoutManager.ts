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
import { CommonConstants, GridLayoutItemInfo, NotHarmonyUtil } from '../TsIndex';
import { BaseTransferBean } from './BaseTransferBean';
import { BaseTransferLayoutManager, IMyObj } from './BaseTransferLayoutManager';
import { ExtractOperator } from './operator/ExtractOperator';
import ScreenTransferBean from './ScreenTransferBean';
import { LogBatchPrint } from './dfx/LogBatchPrint';
import { ObjectCopyUtil } from '@ohos/componenthelper';

const TAG = 'Hm2HmLayoutManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.BACKUP, TAG);

export class Hm2HmLayoutManager extends BaseTransferLayoutManager {
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
   * 以屏为单位收集旧布局列表，便于后续一屏一屏地进行布局转换处理
   *
   * @param oldLayoutInfo
   * @returns
   */
  public async collectOldLayoutByScreen(oldLayoutInfo: GridLayoutItemInfo[]): Promise<void> {
    this.manyToOneReplace(oldLayoutInfo);
    let notHarmonyObj: Object[] = [];
    oldLayoutInfo = oldLayoutInfo.filter(item => {
      // 过滤并收集未鸿蒙化应用
      if (this.isNeedAddToNotHarmnoyFolder(item)) {
        let icon: BaseTransferBean = ObjectCopyUtil.simpleClone(item) as BaseTransferBean;
        icon.layoutWeight = 0;
        notHarmonyObj.push({ bundleName: icon.bundleName, appIndex: icon.appIndex } as IMyObj);
        this.notHarmonyList.push(icon);
        return NotHarmonyUtil.CANCEL_NOT_HARMONY_FOLDER;
      }
      return true;
    });
    let uniqueItemObj: Object[] = [];
    for (let gridItem of oldLayoutInfo) {
      if (gridItem.container === CommonConstants.CONTAINER_DESKTOP) {
        this.collectDesktop(gridItem, oldLayoutInfo);
      } else if (gridItem.container === CommonConstants.CONTAINER_DOCK) {
        this.collectSmartDock(gridItem, oldLayoutInfo);
      } else if (gridItem.container === CommonConstants.CONTAINER_UNIQUE_SINGLE) {
        this.collectUniqueSingle(gridItem, oldLayoutInfo, uniqueItemObj);
      }
    }
    this.sortScreenDataMap();
    log.showInfo(`collect old layout length: ${this.maxScreen}`);
    // 集中打印新机特有及特殊应用
    if (notHarmonyObj.length !== 0) {
      LogBatchPrint.printLogsInBatch(notHarmonyObj, 20, 'collect not harmony app', TAG);
      notHarmonyObj = [];
    }
    if (uniqueItemObj.length !== 0) {
      LogBatchPrint.printLogsInBatch(uniqueItemObj, 20, 'collect single unique item', TAG);
      uniqueItemObj = [];
    }
  }

  /**
   * 将当前屏的元素按照维持方案进行排列
   *
   * @param screenData 当前屏所有元素
   */
  public realignScreenData(screenData: ScreenTransferBean): void {
    let occupied: boolean[][] = [];
    this.fillOccupied(occupied, false);
    screenData.occupied = occupied;
    this.realignByMaintenance(screenData);
  }

  /**
   * 处理单屏元素
   * @param ScreenTransferBean 单屏对象
   * @param occupied 屏幕占用
   */
  public realignByMaintenance(screenData: ScreenTransferBean): void {
    if (CheckEmptyUtils.isEmptyArr(screenData.children)) {
      log.showInfo(`the children of screenData is null, page:${screenData.page}`);
      return;
    }
    log.showInfo(`realignByMaintenance start, screen page is ${screenData.page}, item length:${screenData.children.length}`);
    // 以行为单位，存放当前屏的元素
    let rowElementMap: Map<number, number[]> = new Map();
    // 存放当前屏所有天气widget，不包含4*1卡片
    let widgetIndexArr: number[] = [];
    // 存放当前屏所有天气widget，包含4*1卡片
    let allWidgetIndexArr: number[] = [];
    // 存放当前屏所有空行
    let emptyRowArr: number[] = [];
    // 遍历当前屏元素，获取所有天气widget和空行
    this.calculateRowElement(screenData, rowElementMap, widgetIndexArr, emptyRowArr, allWidgetIndexArr);
    // 抽离操作
    ExtractOperator.extract(screenData, this.toGrid);
    // 针对单窗口单屏少到多场景下的空行处理：在widget下方增加空行
    this.addWidgetEmptyRow(screenData, allWidgetIndexArr);
  }

  /**
   * 生成桌面布局列表
   *
   * @returns 返回最终桌面布局
   */
  public getNewLayoutFromScreenDataMap(): GridLayoutItemInfo[] {
    // dock区合并
    this.dockList = this.dealWithExcessiveDockList(this.dockList);
    // 校验重复元素后返回
    return super.getNewLayoutFromScreenDataMap();
  }
}