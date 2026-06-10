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
import { IDataHandler } from './InfoDataHandleController';
import GridLayoutInfoColumns from './column/GridLayoutInfoColumns';
import GridLayoutItemInfoDB from '../entity/GridLayoutItemInfoDataBase';
import type GridLayoutItemInfo from '../bean/GridLayoutItemInfo';

const TAG: string = 'InsertBatchHandler';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export default class InsertBatchHandler implements IDataHandler {
  async handleDataToRdb(target: string, gridItemList: GridLayoutItemInfo[], rdbStoreHelper: RdbStoreHelper,
    container?: number): Promise<void> {
    if (ArrayUtils.isEmpty(gridItemList)) {
      log.showError('gridItemList is null on handleDataToRdb');
      return;
    }
    let insertBucketList: Array<rdb.ValuesBucket> = new Array();
    gridItemList.forEach(item => {
      let valuesBucket: rdb.ValuesBucket = GridLayoutItemInfoDB.toGridLayoutItemInfoDB(item).toValuesBucket();
      valuesBucket[GridLayoutInfoColumns.CONTAINER] = container ? container : item.container;
      insertBucketList.push(valuesBucket);
    });
    let successNum: number = await rdbStoreHelper.batchInsert(target, insertBucketList);
    log.showInfo('insertSqlBatch target: %{public}s, total: %{public}d, successNum: %{public}d', target,
      gridItemList.length, successNum);
    // 待补充失败处理逻辑
  }
}