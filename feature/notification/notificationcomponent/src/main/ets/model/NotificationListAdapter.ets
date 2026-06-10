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

import { NotificationEntry } from './NotificationEntry';
import { ArrayUtils, CommonUtils } from '@ohos/basicutils';

/**
 * 通知列表适配器
 *
 * @since 2022-12-28
 */
export class NotificationListAdapter {
  /**
   * 视图冻结开关，开启后，仅更新数据，新数据不推送给视图层。
   */
  private isFreezeEnable: boolean = false;
  /**
   * 记录视图冻结期间，数据更新的次数。
   */
  private updateCount: number = 0;
  /**
   * 数据集
   */
  private myDataSource: Array<NotificationEntry> = [];

  /**
   * 数据变化监听器集
   */
  private dataListeners: Set<NtfListDataChangeListener> = new Set();

  setFreezeViewEnable(isEnable: boolean): void {
    this.isFreezeEnable = isEnable;
  }

  setDataSource(dataSource: Array<NotificationEntry>): void {
    this.myDataSource = dataSource;
    this.update();
  }

  /**
   * 复写，数据总数
   */
  totalCount(): number {
    return ArrayUtils.getSize(this.myDataSource);
  }

  /**
   * 复写，获取单条目数据
   *
   * @param index 条目索引
   */
  getData(index: number): NotificationEntry {
    return this.myDataSource[index];
  }

  getAllData(): Array<NotificationEntry> {
    return this.myDataSource;
  }

  /**
   *
   * @param index
   * @param data
   */
  addByIndex(index: number, data: NotificationEntry): void {
    ArrayUtils.addArr(this.myDataSource, index, data);
    this.onDataAdd(index);
  }

  /**
   * 添加/更新数据
   *
   * @param data 数据
   * @return 老数据索引
   */
  addOrUpdateData(data: NotificationEntry): number {
    let oldIndex = ArrayUtils.updateArr(this.myDataSource, data);
    let isAdd = oldIndex != -1;
    let lastIndex = ArrayUtils.getSize(this.myDataSource) - 1;
    if (isAdd) {
      this.onDataAdd(lastIndex);
    } else {
      this.onDataChange(oldIndex);
    }
    return oldIndex;
  }

  /**
   * 添加/更新数据
   *
   * @param data 数据
   * @return 老数据索引
   */
  addOrUpdateDataNoNeedUpdate(data: NotificationEntry): number {
    let oldIndex = ArrayUtils.updateArr(this.myDataSource, data);
    return oldIndex;
  }

  /**
   * 移动数据
   *
   * @param from 数据原始索引
   * @param to 数据最终索引
   */
  moveData(from: number, to: number): void {
    if (ArrayUtils.moveArr(this.myDataSource, from, to)) {
      this.onDataMove(from, to);
    }
  }

  /**
   * 删除数据
   *
   * @param index 数据索引
   */
  deleteByIndex(index: number): void {
    let delData = ArrayUtils.deleteArrByIndex(this.myDataSource, index);
    if (!CommonUtils.isInvalid(delData)) {
      this.onDataDelete(index);
    }
  }


  /**
   * 回调数据添加
   *
   * @param index 添加数据索引
   */
  onDataAdd(index: number): void {
    this.update();
  }


  /**
   * 回调数据更新
   *
   * @param index 更新数据索引
   */
  onDataChange(index: number): void {
    this.update();
  }

  /**
   * 回调数据删除
   *
   * @param index 删除数据索引
   */
  onDataDelete(index: number): void {
    this.update();
  }


  /**
   * 回调数据移动
   *
   * @param fromIndex 移动数据起始索引
   * @param toIndex 移动数据结束索引
   */
  onDataMove(fromIndex: number, toIndex: number): void {
    this.update();
  }

  /**
   * 回调数据列表刷新
   */
  onDataReloaded(): void {
    this.update();
  }

  /**
   * 删除数据
   *
   * @param data 待删除数据
   */
  deleteData(data: NotificationEntry): void {
    let delIndex = ArrayUtils.deleteArr(this.myDataSource, data);
    if (delIndex != -1) {
      this.onDataDelete(delIndex);
    }
  }

  /**
   * 删除数据
   *
   * @param data 待删除数据
   */
  deleteDataNoNeedUpdate(data: NotificationEntry): void {
    ArrayUtils.deleteArr(this.myDataSource, data);
  }

  update(type ?: NtfDataChangeType) {
    this.updateCount++;
    if (this.isFreezeEnable) {
      return;
    }

    // 下拉通知中心触发的更新视图，且更新次数为1，说明这期间没有数据更新，则不需要更新视图
    if (type === NtfDataChangeType.BATCH_UPDATE && this.updateCount === 1) {
      this.updateCount = 0;
      return;
    }

    this.dataListeners.forEach((listener: NtfListDataChangeListener) => {
      listener.onNtfListDataChange(this.myDataSource, type);
    });

    this.updateCount = 0;
  }

  /**
   * 注册数据变化监听
   *
   * @param listener 监听器
   */
  registerDataChangeListener(listener: NtfListDataChangeListener): void {
    this.dataListeners.add(listener);
  }

  /**
   * 注销数据变化监听
   *
   * @param listener 监听器
   */
  unregisterDataChangeListener(listener: NtfListDataChangeListener): void {
    this.dataListeners.delete(listener);
  }

  /**
   * 根据hashCode查询组通知
   *
   * @param hashCode
   */
  findGroupEntryByHashCode(hashCode: string | undefined): NotificationEntry | undefined {
    let groupEntry: NotificationEntry | undefined = undefined;
    if (!this.myDataSource) {
      return groupEntry;
    }
    for (let data of this.myDataSource) {
      const delEntry = data?.childrenEntry?.find((entry) => {
        return entry?.hashCode === hashCode;
      })
      if (delEntry) {
        groupEntry = data;
        break;
      }
    }
    return groupEntry;
  }
}

export enum NtfDataChangeType {
  ADD = 0,
  UPDATE = 1,
  REMOVE = 2,
  BATCH_UPDATE = 3, // 批量更新，仅用于下拉通知面板时，刷新列表。
}

export interface NtfListDataChangeListener {
  onNtfListDataChange: (dataSource: Array<NotificationEntry>, type ?: NtfDataChangeType) => void;
}