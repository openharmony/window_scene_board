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
import { DockItemInfo } from '../bean/DockItemInfo';
import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { rdbTaskPool } from './RdbTaskPool';

const TAG = 'HomeRdbStoreManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Wrapper class for gridLayoutInfo rdb interfaces.
 */
export class HomeRdbStoreManager {
  private mLayoutInfo: string = RdbStoreConfig.gridLayoutInfo.tableName;

  private constructor() {
  }

  private static sInstance: HomeRdbStoreManager;

  /**
   * simple db manager instance
   *
   * @return rdbStoreManager instance
   */
  public static getInstance(): HomeRdbStoreManager {
    if (HomeRdbStoreManager.sInstance == null) {
      HomeRdbStoreManager.sInstance = new HomeRdbStoreManager();
    }
    return HomeRdbStoreManager.sInstance;
  }

  /**
   * 查询普通桌面布局
   *
   * @returns 桌面布局信息
   */
  public async queryGridLayoutInfo(): Promise<GridLayoutItemInfo[]> {
    log.showInfo('queryGridLayoutInfo start');
    let result: GridLayoutItemInfo[] = await rdbTaskPool.queryGridLayoutInfo(this.mLayoutInfo, undefined);
    return result;
  }

  /**
   * 查询普通桌面Dock布局
   *
   * @returns 桌面布局信息
   */
  public async querySmartDock(): Promise<DockItemInfo[]> {
    log.showInfo('querySmartDock start');
    let dockItems: DockItemInfo[] = await rdbTaskPool.querySmartDock(this.mLayoutInfo);
    return dockItems;
  }
}