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
import { DockItemInfo, DockUtils } from '../../TsIndex';
import { BaseDockLayoutCacheMgr } from './BaseDockLayoutCacheMgr';

const TAG = 'CollaborationLayoutCacheMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 *  collaboration缓存数据管理类
 */
export class CollaborationLayoutCacheMgr extends BaseDockLayoutCacheMgr {

  protected static instance: CollaborationLayoutCacheMgr;

  private constructor() {
    super();
  }

  public static getInstance(): CollaborationLayoutCacheMgr {
    if (!CollaborationLayoutCacheMgr.instance) {
      CollaborationLayoutCacheMgr.instance = new CollaborationLayoutCacheMgr();
    }
    return CollaborationLayoutCacheMgr.instance;
  }

  /**
   * 获取所有collaboration区数据
   * @returns
   */
  getAllDockItems(): DockItemInfo[] {
    return this.dockCacheData ?? [];
  }

  /**
   * 更新所有collaboration区数据
   * @param from 更新来源
   * @param dockItems 数据
   * @param isOperateDb 是否操作数据库，默认不入库
   */
  updateAllDockItems(from: string, dockItems: DockItemInfo[], isOperateDb: boolean = false): void {
    let paramLog = DockUtils.getPrintParam(dockItems);
    log.showInfo(`updateAllDockItems from: ${from}, param: ${paramLog}, isOperateDb: ${isOperateDb}`);
    this.dockCacheData = dockItems;
  }
}