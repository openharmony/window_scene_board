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

import type GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import type Context from '@ohos.app.ability.common';
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import { RdbStoreHelper } from '@ohos/frameworkwrapper/src/main/ets/service/db/RdbStoreHelper';
import rdb from '@ohos.data.relationalStore';
import InfoDataHandleFactory, { IDataHandler } from './InfoDataHandleController';

// 数据处理方案的阈值，少于该值时通过循环向数据库中修改数据，多于该值时则批量向数据库中数据
export const MINOR_COUNT: number = 3;

export async function handleDataInfo(tableName: string, gridItemList: GridLayoutItemInfo[], type: HandleType,
  container: number, screenId?: number, reason?: string , context?: Context.BaseContext): Promise<boolean> {
  'use concurrent';
  const TAG = 'taskPool';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  let rdbStoreHelper: RdbStoreHelper = new RdbStoreHelper();
  log.showWarn(`handleDataInfo start, type: ${type}, itemSize: ${gridItemList.length}`);
  try {
    await rdbStoreHelper.createRdbStore(context);
    let rdbStore: rdb.RdbStore = rdbStoreHelper.getRdbStore();
    if (!rdbStore) {
      log.showError('handleDataInfo error, rdbStore is null!!!');
      return false;
    }
    rdbStore.beginTransaction();
    let handler: IDataHandler = InfoDataHandleFactory.getInstance().getHandler(type);
    await handler.handleDataToRdb(tableName, gridItemList, rdbStoreHelper, container, screenId, reason);
    rdbStore.commit();
    return true;
  } catch (e) {
    log.showError('queryGridLayoutInfo error%{public}d:%{public}s', e.code, e.message);
    rdbStoreHelper.getRdbStore()?.rollBack();
  } finally {
    log.showWarn(`handleDataInfo end, type: ${type}`);
    rdbStoreHelper.release();
  }
  return false;
}

/**
 * 数据处理类型，少量和大量的数据大小界限由MINOR_COUNT决定
 */
export enum HandleType {
  INSERT_BATCH, // 将数据批量插入数据库
  MINOR_UPDATE, // 将少量数据更新入数据
  MASS_UPDATE, // 将大量数据更新入数据
}