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

import { BaseMenuData } from './BaseMenu';
import { BasicDataSource } from './BasicDataSource';

/**
 * 用于显示菜单列表的懒加载数据源
 */
export class MenuDataSource extends BasicDataSource {

  public mDataSource: BaseMenuData[] = [];

  constructor(dataList: BaseMenuData[]) {
    super();
    this.mDataSource = dataList;
  }

  public totalCount(): number {
    return this.mDataSource === null ? 0 : this.mDataSource.length;
  }

  public getData(index: number): BaseMenuData | null {
    return index >= 0 && index < this.totalCount() ? this.mDataSource[index] : null;
  }

  public refreshData(dataList: BaseMenuData[]) {
    this.mDataSource = dataList;
    this.notifyDataReload();
  }

  public pushData(data: BaseMenuData): void {
    this.mDataSource.push(data);
    this.notifyDataAdd(this.mDataSource.length - 1);
  }
}