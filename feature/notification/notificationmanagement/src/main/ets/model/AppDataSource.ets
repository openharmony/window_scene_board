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

import { LogDomain, LogHelper } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/BasicCommon';

const TAG = 'ManagementComponent-AppLiveViewDataSource';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * APP实况开关显示数据
 *
 * @since 2025-01-23
 */
export default class AppLiveViewDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];

  private mDataSource: object[] = [];

  constructor(dataList: object[]) {
    this.mDataSource = dataList;
  }

  public totalCount(): number {
    return this.mDataSource == null ? 0 : this.mDataSource.length;
  }

  public getData(index: number): object | null {
    return index >= 0 && index < this.totalCount() ? this.mDataSource[index] : null;
  }

  public refreshData(dataList: object[]) {
    this.mDataSource = dataList;
    this.notifyDataReload();
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) >= 0) {
      return;
    }
    log.showInfo('add listener');
    this.listeners.push(listener);
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      log.showInfo('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach((listener: DataChangeListener) => {
      listener.onDataReloaded();
    })
  }
}
