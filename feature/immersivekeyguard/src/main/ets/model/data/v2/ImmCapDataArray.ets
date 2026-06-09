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

import { LimitMap } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { CapShowType } from '../../../common/constants/ImmCapConst';
import { ImmersiveComHelper } from '../../../common/helper/ImmersiveComHelper';
import { ImmCapData } from './ImmCapData';

// 胶囊类型与索引映射关系
const TYPE_INDEX: Map<CapShowType, number> = new Map([
  [CapShowType.CAP_ADD, -1],
  [CapShowType.CAP_REMOVE, -1],
  [CapShowType.CAP_UPDATE, -1],
  [CapShowType.CAP_CARD_BACK, -1],
  [CapShowType.CAP_SHADOW, 0],
  [CapShowType.CAP_CONTENT, 1],
  [CapShowType.CAP_REMIND, 2],
  [CapShowType.CAP_CARD, 3],
]);

/**
 * 沉浸胶囊数据列表
 */
export class ImmCapDataArray extends Array<ImmCapData> {
  // 数据列表管理，dataGroupKey => ImmCapData
  private readonly allDataMap: LimitMap<string, ImmCapData> = new LimitMap();
  // 记录旧的有效数据个数
  private oldValidSize: number = 0;

  /**
   * 删除指定胶囊类型数据
   *
   * @param capType 胶囊类型
   */
  public remove(capType?: CapShowType): void {
    if (!capType || capType === CapShowType.CAP_NONE) {
      return;
    }
    const index = this.findIndex((data) => {
      if (data.getCapShowType() === capType) {
        // 同步删除map
        this.allDataMap.delete(data?.getDataGroupKey());
        return true;
      }
      return false;
    });
    if (index > -1) {
      this.splice(index, 1);
    }
  }

  /**
   * 清除所有数据
   */
  public clear(): void {
    if (!this.length) {
      return;
    }
    this.splice(0, this.length);
    this.allDataMap.clear();
  }

  /**
   * 有效数据个数
   *
   * @returns 数据个数
   */
  public getValidSize(): number {
    let validSize: number = 0;
    this.forEach((data) => {
      let capType = data?.getCapShowType();
      if (this.isValidType(capType)) {
        validSize++;
      }
    });
    return validSize;
  }

  /**
   * 旧的有效数据个数
   *
   * @returns 数据个数
   */
  public getOldValidSize(): number {
    return this.oldValidSize;
  }

  /**
   * 记录当前有效数据个数
   */
  public recordValidSize(): void {
    this.oldValidSize = this.getValidSize();
  }

  /**
   * 胶囊是否无数据
   *
   * @returns true无数据
   */
  public isEmpty(): boolean {
    let validData = this.find((data) => this.isValidType(data?.getCapShowType()));
    return !Boolean(validData);
  }

  /**
   * 排序列表数据
   */
  public sortData(): void {
    super.sort((a, b) => ImmersiveComHelper.compareImmData(a.getOriData(), b.getOriData()));
  }

  /**
   * 存储胶囊数据
   *
   * @param type 该数据显示类型
   * @param data 胶囊数据，空表示清空该类型数据
   */
  public setCapData(type: CapShowType, data?: ImmCapData): void {
    // 不允许空类型
    if (type === CapShowType.CAP_NONE) {
      return;
    }
    // 移除现有数据，重新添加
    this.remove(type);
    // 添加新数据
    if (data) {
      data.setCapShowType(type);
      // 数据不存在则添加
      let groupKey = data.getDataGroupKey();
      if (!this.allDataMap.has(groupKey)) {
        this.push(data);
        this.allDataMap.set(groupKey, data);
      }
    }
  }

  /**
   * 取值目标显示胶囊数据
   *
   * @param type 胶囊显示类型
   * @returns 目标胶囊数据
   */
  public getCapData(type: CapShowType): ImmCapData | undefined {
    return this.find((data) => data.getCapShowType() === type);
  }

  /**
   * 根据分组标识查找胶囊数据
   *
   * @param groupKey 分组标识
   * @returns 胶囊数据
   */
  public findCapData(groupKey: string): ImmCapData | undefined {
    return this.find((cap: ImmCapData) => cap?.getGroupKey() === groupKey);
  }

  private isValidType(type?: CapShowType): boolean {
    // 内容胶囊、阴影胶囊为有效数据
    return type === CapShowType.CAP_SHADOW || type === CapShowType.CAP_CONTENT;
  }

  /**
   * 对应映射索引
   *
   * @param type 胶囊类型
   * @returns 映射索引
   */
  public static getZIndex(type: CapShowType): number {
    return TYPE_INDEX.get(type) ?? 0;
  }
}