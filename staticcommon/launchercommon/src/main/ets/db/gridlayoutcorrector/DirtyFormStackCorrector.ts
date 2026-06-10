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

import rdb from '@ohos.data.rdb';
import {
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import { RdbStoreConfig } from '@ohos/frameworkwrapper';
import { launcherStatusUtil } from '@ohos/windowscene';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { CommonConstants } from '../../constants/CommonConstants';
import { AbstractGridLayoutCorrector } from './AbstractGridLayoutCorrector';
import GridLayoutInfoColumns, { GridLayoutInfoEnums } from '../column/GridLayoutInfoColumns';
import { rdbTaskPool } from '../RdbTaskPool';
import { FormCommonUtil } from '../../utils/FormCommonUtil';

const TAG = 'DirtyFormStackCorrector';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const FORMSTACK_CARDS_MIN_LEN = 2;

export class DirtyFormStackCorrector extends AbstractGridLayoutCorrector {

  handleData(girdLayoutInfo: GridLayoutItemInfo[], isOuter?:boolean): void {
    // 处理堆叠内卡片列表数量小于2的数据
    this.dealDirtyFromStack(girdLayoutInfo, isOuter);

    // 处理堆叠内卡片数正常，但是存在同key(bundleName+cardId)卡片
    this.dealFormStackDuplicateCards(girdLayoutInfo, isOuter);
  }

  private dealFormStackDuplicateCards(girdLayoutInfo: GridLayoutItemInfo[], isOuter?:boolean): void {
    let fromStacks: GridLayoutItemInfo[] = girdLayoutInfo.filter((itemInfo) => {
      if (itemInfo.typeId === CommonConstants.TYPE_FORM_STACK) {
        return !CheckEmptyUtils.isEmptyArr(itemInfo.layoutInfo) &&
          itemInfo.layoutInfo && itemInfo.layoutInfo[0].length >= FORMSTACK_CARDS_MIN_LEN;
      }
      return false;
    });

    fromStacks.forEach((formStackItem) => {
      let cardInfoList: GridLayoutItemInfo[] = formStackItem.layoutInfo?.[0] ?? [];
      let cardKeys: Set<string> = new Set<string>(cardInfoList.map(item => `${item.bundleName}${item.cardId}`));
      if (cardInfoList.length !== cardKeys.size) {
        // 存在同key卡片，需要去重
        log.showWarn(`the formstack exist duplicate card, cardKeys len: ${cardKeys.size}`);
        this.dealDuplicateCard(cardInfoList, formStackItem, girdLayoutInfo, isOuter);
      }
    });
  }

  private dealDuplicateCard(cardInfoList: GridLayoutItemInfo[], formStackItem: GridLayoutItemInfo,
    girdLayoutInfo: GridLayoutItemInfo[], isOuter?:boolean): void {
    let deleteItems: GridLayoutItemInfo[] = [];
    let remainItems: GridLayoutItemInfo[] = [];
    let cardKeys: Set<string> = new Set<string>();
    cardInfoList.forEach((item) => {
      let key: string = `${item.bundleName}${item.cardId}`;
      if (!cardKeys.has(key)) {
        log.showInfo(`valid item, id: ${item.id}, bundleName: ${item.bundleName}, cardId: ${item.cardId}.`);
        remainItems.push(item);
        cardKeys.add(key);
      } else {
        log.showInfo(`duplicate item, id: ${item.id}, bundleName: ${item.bundleName}, cardId: ${item.cardId}.`);
        deleteItems.push(item);
      }
    });

    if (formStackItem.layoutInfo) {
      formStackItem.layoutInfo[0] = remainItems;
    }
    let selectIndex: number = girdLayoutInfo.findIndex(item => item.formStackId === formStackItem.formStackId);
    if (selectIndex >= 0) {
      girdLayoutInfo[selectIndex] = formStackItem;
    }
    if (remainItems.length === 1) {
      // 剩一张卡片时，退化成单卡同时删除堆叠数据（布局缓存+db）
      this.handlerCardItem(girdLayoutInfo, formStackItem, remainItems[0], isOuter);
      girdLayoutInfo.splice(girdLayoutInfo.indexOf(formStackItem), 1);
      this.deleteRdbGridLayoutItemInfo(formStackItem, isOuter);
    }
    deleteItems.forEach((deleteItem) => {
      this.deleteRdbGridLayoutItemInfo(deleteItem, isOuter);
    });
  }

  private dealDirtyFromStack(girdLayoutInfo: GridLayoutItemInfo[], isOuter?:boolean): void {
    let incorrectData: GridLayoutItemInfo[] = girdLayoutInfo.filter((itemInfo) => {
      // 脏数据: 堆叠卡片列表数量小于2
      if (itemInfo.typeId === CommonConstants.TYPE_FORM_STACK) {
        return !itemInfo.layoutInfo || CheckEmptyUtils.isEmptyArr(itemInfo.layoutInfo) ||
          itemInfo.layoutInfo[0].length < FORMSTACK_CARDS_MIN_LEN;
      }
      return false;
    });

    incorrectData.forEach((itemInfo) => {
      log.showError(`gridLayoutCorrector delete:${JSON.stringify(itemInfo)}`);
      if (itemInfo.layoutInfo?.[0]?.length as number > 0) {
        // 堆叠中只有一张卡片数据，刷新到桌面
        if (itemInfo.layoutInfo) {
          this.handlerCardItem(girdLayoutInfo, itemInfo, itemInfo.layoutInfo[0][0], isOuter);
        }
      }
      girdLayoutInfo.splice(girdLayoutInfo.indexOf(itemInfo), 1);
      this.deleteRdbGridLayoutItemInfo(itemInfo, isOuter);
    });
  }

  private async handlerCardItem(girdLayoutInfo: GridLayoutItemInfo[],
                                formStackInfo: GridLayoutItemInfo, card: GridLayoutItemInfo,
                                isOuter?:boolean): Promise<void> {
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.INFO_ID, card.cardId);
    conditions.set(GridLayoutInfoColumns.TYPE_ID, card.typeId);
    const updateBucket: rdb.ValuesBucket = {
      [GridLayoutInfoEnums.PAGE_INDEX]: formStackInfo.page,
      [GridLayoutInfoEnums.ROW]: formStackInfo.row,
      [GridLayoutInfoEnums.COLUMN]: formStackInfo.column,
      [GridLayoutInfoEnums.CONTAINER]: CommonConstants.CONTAINER_DESKTOP,
    };
    let tableName: string = RdbStoreConfig.gridLayoutInfo.tableName;
    if (isOuter === undefined) {
      if (launcherStatusUtil.getShowOutLauncherStatus()) {
        tableName = RdbStoreConfig.outerGridLayoutInfo.tableName;
      }
    }
    if (isOuter) {
      tableName = RdbStoreConfig.outerGridLayoutInfo.tableName;
    }
    card.page = formStackInfo.page;
    card.row = formStackInfo.row;
    card.column = formStackInfo.column;
    card.container = CommonConstants.CONTAINER_DESKTOP;
    log.showInfo(`handlerCardItem: ${JSON.stringify(card)}`);
    FormCommonUtil.reportDirtyFormStackDegradation(card);
    girdLayoutInfo.push(card);
    let changeRows = await rdbTaskPool.update(tableName, conditions, updateBucket);
    log.showInfo('handlerCardItem db update: %{public}d', changeRows);
  }
}