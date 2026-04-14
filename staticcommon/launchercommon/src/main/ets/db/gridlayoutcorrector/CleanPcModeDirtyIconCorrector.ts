/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { CommonConstants } from '../../constants/CommonConstants';
import { AbstractGridLayoutCorrector } from './AbstractGridLayoutCorrector';
import rdb from '@ohos.data.relationalStore';
import { rdbTaskPool } from '../RdbTaskPool';
import GridLayoutInfoColumns from '../column/GridLayoutInfoColumns';

const TAG = 'CleanPcModeDirtyIconCorrector';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 针对平板清理beta升级过程中的自由多窗（PC模式）脏数据
 * 1.bundleName: com.ohos.sceneboard
 * 2.abilityName: com.ohos.sceneboard.recents.MainAbility
 * 3.typeId: 2
 * 4.container: 100
 */
export class CleanPcModeDirtyIconCorrector extends AbstractGridLayoutCorrector {
  handleData(girdLayoutInfo: GridLayoutItemInfo[], isOuter?: boolean): void {

    // sql执行删除，避免数据量过多
    this.delete();
    for (let i = 0; i < girdLayoutInfo.length; i++) {
      let itemInfo: GridLayoutItemInfo = girdLayoutInfo[i];

      // 文件夹内脏数据
      if (itemInfo.typeId === CommonConstants.TYPE_FOLDER && itemInfo.layoutInfo && itemInfo.layoutInfo[0]) {
        this.handleFolderItem(itemInfo);
      }

      // 桌面图标删除脏数据
      if (this.checkIsDirtyIcon(itemInfo)) {
        girdLayoutInfo.splice(i, 1);
        i--;
      }
    }
  }

  private handleFolderItem(itemInfo: GridLayoutItemInfo, isOuter?: boolean): void {
    if (!itemInfo.layoutInfo) {
      return;
    }
    let folderInfo = itemInfo.layoutInfo[0];
    for (let j: number = 0; j < folderInfo.length; j++) {
      if (this.checkIsDirtyIcon(itemInfo)) {
        folderInfo.splice(j, 1);
        j--;
      }
    }
  }

  private checkIsDirtyIcon(itemInfo: GridLayoutItemInfo): boolean {
    if (itemInfo.bundleName === CommonConstants.LAUNCHER_BUNDLE &&
      itemInfo.abilityName === CommonConstants.RECENT_ABILITY &&
      itemInfo.typeId === CommonConstants.TYPE_FUNCTION) {
      return true;
    }
    return false;
  }

  private async delete(): Promise<void> {
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.BUNDLE_NAME, CommonConstants.LAUNCHER_BUNDLE);
    conditions.set(GridLayoutInfoColumns.ABILITY_NAME, CommonConstants.RECENT_ABILITY);
    conditions.set(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_FUNCTION);
    conditions.set(GridLayoutInfoColumns.CONTAINER, CommonConstants.CONTAINER_DESKTOP);
    const changeRows = await rdbTaskPool.delete(RdbStoreConfig.gridLayoutInfo.tableName, conditions);
    log.showInfo(`gridLayoutInfo rdb delete ok:${changeRows}`);
  }
}