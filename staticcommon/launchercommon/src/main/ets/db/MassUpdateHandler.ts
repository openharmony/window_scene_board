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

import { RdbStoreHelper } from '@ohos/frameworkwrapper/src/main/ets/service/db/RdbStoreHelper';
import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import rdb from '@ohos.data.relationalStore';
import { CommonConstants } from '../constants/CommonConstants';
import { IDataHandler } from './InfoDataHandleController';
import GridLayoutInfoColumns from './column/GridLayoutInfoColumns';
import GridLayoutItemInfoDB from '../entity/GridLayoutItemInfoDataBase';
import type GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import RdbSqlHelp, { SqlItemData, UpdateSqlDataSet } from './RdbSqlHelp';
import { SceneMsgEnum } from '../TsIndex';

const TAG: string = 'MassUpdateHandler';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const UPDATE_BATCH_COUNT: number = 30;

/*
 * 修改大量数据时的处理方案：将库中数据全量查询至本地后建立_id与数据的映射，然后与需要处理的数据比对生成需要更新和新增的集合，最后批量处理
 * 无论处理多大的数据，sql操作次数变化不大，但单次数据处理耗时较长，适合处理大批量的数据更新
 */
export default class MassUpdateHandler implements IDataHandler {
  async handleDataToRdb(target: string, gridItemList: GridLayoutItemInfo[], rdbStoreHelper: RdbStoreHelper,
    container?: number | undefined): Promise<void> {
    if (ArrayUtils.isEmpty(gridItemList)) {
      log.showError('gridItemList is null on handleDataToRdb');
      return;
    }
    log.showWarn('handleDataToRdb target: %{public}s, dataSize: %{public}d', target, gridItemList.length);
    let sqlItemData: SqlItemData = new SqlItemData();
    await this.initSqlItemData(gridItemList, sqlItemData, rdbStoreHelper, target);
    log.showWarn('initSqlItemData end, target: %{public}s, totalNum: %{public}d, updateSize: %{public}d, insertSize: %{public}d',
      target, gridItemList.length, sqlItemData.updateList.length, sqlItemData.insertList.length);

    await this.insertSqlBatch(sqlItemData, container, target, rdbStoreHelper);
    await this.updateSqlBatch(sqlItemData, container, target, rdbStoreHelper);
  }

  private async initSqlItemData(gridItemList: GridLayoutItemInfo[], sqlItemData: SqlItemData,
    rdbStoreHelper: RdbStoreHelper, tableName: string): Promise<void> {
    await RdbSqlHelp.getInstance().getAllDataByBatchSql(rdbStoreHelper, tableName, sqlItemData, 1);
    gridItemList.forEach(item => {
      let itemKey: string = RdbSqlHelp.getInstance().getItemKey(item);
      if (sqlItemData.keyMap.has(itemKey)) {
        sqlItemData.updateList.push(item);
      } else {
        log.showWarn('initSqlItemData insert itemKey: %{public}s', itemKey);
        sqlItemData.insertList.push(item);
      }
    });
  }

  private async insertSqlBatch(sqlItemData: SqlItemData, container: number, target: string,
    rdbStoreHelper: RdbStoreHelper): Promise<void> {
    if (ArrayUtils.isEmpty(sqlItemData.insertList)) {
      return;
    }
    let insertBucketList: Array<rdb.ValuesBucket> = new Array();
    sqlItemData.insertList.forEach(item => {
      let valuesBucket: rdb.ValuesBucket = GridLayoutItemInfoDB.toGridLayoutItemInfoDB(item).toValuesBucket();
      valuesBucket[GridLayoutInfoColumns.CONTAINER] = container ? container : item.container;
      insertBucketList.push(valuesBucket);
      rdbStoreHelper.printExecuteSql('insertSqlBatch', SceneMsgEnum.MASS_BATCH_INSERT,
        rdbStoreHelper.valuesBucketToStr(valuesBucket), insertBucketList.length);
    });
    let successNum: number = await rdbStoreHelper.batchInsert(target, insertBucketList);
    log.showWarn('insertSqlBatch target: %{public}s, total: %{public}d, successNum: %{public}d', target,
      sqlItemData.insertList.length, successNum);
    // 待添加如果未完全插入时的补充插入
  }

  private async updateSqlBatch(sqlItemData: SqlItemData, container: number | undefined, tableName: string,
    rdbStoreHelper: RdbStoreHelper): Promise<void> {
    if (ArrayUtils.isEmpty(sqlItemData.updateList)) {
      log.showInfo('updateList is null, not need update');
      return;
    }
    let updateData: UpdateSqlDataSet = RdbSqlHelp.getInstance().getUpdateSqlDataSet(sqlItemData, container);
    let startIndex: number = 0;
    while (startIndex < sqlItemData.updateList.length) {
      let updateSql: string = RdbSqlHelp.getInstance().getBatchUpdateSql(updateData, startIndex,
        tableName, UPDATE_BATCH_COUNT);
      await rdbStoreHelper.executeSql(updateSql);
      rdbStoreHelper.printExecuteSql(`updateSqlBatch_${startIndex}`, SceneMsgEnum.MASS_UPDATE, updateSql,
        sqlItemData.updateList.length);
      startIndex += UPDATE_BATCH_COUNT;
    }
  }
}