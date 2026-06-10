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
import { rdbTaskPool } from './RdbTaskPool';
import rdb from '@ohos.data.relationalStore';
import { CommonConstants } from '../constants/CommonConstants';
import { DockItemInfo } from '../bean/DockItemInfo';
import { CardItemInfo } from '../bean/CardItemInfo';
import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import GridLayoutInfoColumns from './column/GridLayoutInfoColumns';

const TAG = 'SimpleRdbStoreManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Wrapper class for simple rdb interfaces.
 */
export class SimpleRdbStoreManager {
  private mSimpleLayoutInfo: string = RdbStoreConfig.simpleLayoutInfo.tableName;

  private constructor() {
  }

  private static sInstance: SimpleRdbStoreManager;

  /**
   * simple db manager instance
   *
   * @return rdbStoreManager instance
   */
  public static getInstance(): SimpleRdbStoreManager {
    if (SimpleRdbStoreManager.sInstance == null) {
      SimpleRdbStoreManager.sInstance = new SimpleRdbStoreManager();
    }
    return SimpleRdbStoreManager.sInstance;
  }

  /**
   * 查询简易桌面布局
   *
   * @returns 桌面布局信息
   */
  public async queryGridLayoutInfo(): Promise<GridLayoutItemInfo[]> {
    log.showInfo('queryGridLayoutInfo start');
    let result: GridLayoutItemInfo[] = await rdbTaskPool.queryGridLayoutInfo(this.mSimpleLayoutInfo, undefined);
    return result;
  }

  /**
   * 查询简易桌面Dock布局
   *
   * @returns 桌面布局信息
   */
  public async querySmartDock(): Promise<DockItemInfo[]> {
    log.showInfo('querySmartDock start');
    let dockItems: DockItemInfo[] = await rdbTaskPool.querySmartDock(this.mSimpleLayoutInfo);
    return dockItems;
  }

  /**
   * 获取所有卡片信息
   *
   * @returns 卡片列表
   */
  public async getAllFormInfos(): Promise<CardItemInfo[]> {
    log.showInfo('getAllFormInfosInSimpleMode start');
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_CARD);
    return await rdbTaskPool.queryForm(this.mSimpleLayoutInfo, conditions);
  }
}