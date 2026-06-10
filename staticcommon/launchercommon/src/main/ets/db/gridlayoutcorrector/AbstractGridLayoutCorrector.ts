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
import { RdbStoreConfig } from '@ohos/frameworkwrapper';
import { launcherStatusUtil } from '@ohos/windowscene';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import rdb from '@ohos.data.rdb';
import { rdbTaskPool } from '../RdbTaskPool';
import GridLayoutInfoColumns from '../column/GridLayoutInfoColumns';

const TAG = 'AbstractGridLayoutCorrector';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export abstract class AbstractGridLayoutCorrector {

  abstract handleData(girdLayoutInfo: GridLayoutItemInfo[], isOuter?: boolean): void;

  protected async deleteRdbGridLayoutItemInfo(itemInfo: GridLayoutItemInfo, isOuter?: boolean): Promise<boolean> {
    if (itemInfo.id === undefined) {
      return false;
    }
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.ID, itemInfo.id);
    let tableName: string = RdbStoreConfig.gridLayoutInfo.tableName;
    if (isOuter === undefined) {
      if (launcherStatusUtil.getShowOutLauncherStatus()) {
        tableName = RdbStoreConfig.outerGridLayoutInfo.tableName;
      }
    }
    if (isOuter) {
      tableName = RdbStoreConfig.outerGridLayoutInfo.tableName;
    }
    const changeRows = await rdbTaskPool.delete(tableName, conditions);
    if (changeRows >= 1) {
      log.showInfo(`gridLayoutInfo rdb delete ok:${itemInfo.id}`);
      return true;
    }
    return false;
  }
}