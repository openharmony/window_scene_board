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

import {
  LogDomain,
  LogHelper
} from '@ohos/basicutils';
import { DockItemInfo } from '../../TsIndex';
import { IDockLayoutCacheMgr } from './IDockLayoutCacheMgr';

const TAG = 'BaseDockLayoutCacheMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export abstract class BaseDockLayoutCacheMgr implements IDockLayoutCacheMgr {

  protected dockCacheData: DockItemInfo[] = [];

  constructor() {
  }

  /**
   * 获取所有的dockItem
   * @returns
   */
  getAllDockItems(): DockItemInfo[] {
    return this.dockCacheData;
  }

  /**
   * 更新所有数据
   * @param from 更新来源
   * @param dockItems 数据
   * @param isOperateDb 是否操作数据库
   */
  abstract updateAllDockItems(from: string, dockItems: DockItemInfo[], isOperateDb: boolean): void;

}