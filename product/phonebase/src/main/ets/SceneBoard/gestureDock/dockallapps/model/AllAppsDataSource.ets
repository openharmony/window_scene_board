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

import { GestureDockItemInfo } from '../../dockbar/model/GestureDockItemInfo';

/**
 * AllApps页面适配LazyForeach数据源
 */
export class AllAppsDataSource implements IDataSource {
  private dataSource: GestureDockItemInfo[] = [];
  private dataChangeListeners: DataChangeListener[] = [];

  constructor(dataList: GestureDockItemInfo[]) {
    this.dataSource = dataList;
  }

  /**
   * 获取数据源列表长度
   */
  public totalCount(): number {
    return this.dataSource === null ? 0 : this.dataSource.length;
  }

  /**
   * 从数据源获取指定索引值的数据项
   *
   * @param index 数据源索引值
   * @return 对应索引值的数据项
   */
  public getData(index: number): GestureDockItemInfo {
    return index >= 0 && index < this.totalCount() ? this.dataSource[index] : new GestureDockItemInfo();
  }

  /**
   * 更新数据源
   */
  public refreshData(dataList: GestureDockItemInfo[]) {
    this.dataSource = dataList;
    this.notifyDataReload();
  }

  /**
   * 注册数据改变的监听器
   * @param listener
   */
  public registerDataChangeListener(listener: DataChangeListener): void {
    if (this.dataChangeListeners.indexOf(listener) >= 0) {
      return;
    }
    this.dataChangeListeners.push(listener);
  }

  /**
   * 注销数据改变的监听器
   * @param listener
   */
  public unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos: number = this.dataChangeListeners.indexOf(listener);
    if (pos >= 0) {
      this.dataChangeListeners.splice(pos, 1);
    }
  }

  /**
   * 通知组件重新加载所有数据
   */
  public notifyDataReload(): void {
    this.dataChangeListeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }
}