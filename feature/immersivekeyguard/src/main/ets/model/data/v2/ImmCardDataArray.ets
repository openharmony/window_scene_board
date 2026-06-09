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

import { CardShowType } from '../../../common/constants/ImmCardConst';
import { ImmersiveComHelper } from '../../../common/helper/ImmersiveComHelper';
import { ImmCardData } from './ImmCardData';

// 大卡类型与索引映射关系
const TYPE_INDEX: Map<CardShowType, number> = new Map([
  [CardShowType.CARD_NONE, -1],
  [CardShowType.CARD_CAP, -1],
  [CardShowType.CARD_LIST, -1],
  [CardShowType.CARD_UPDATE_OLD, 1],
  [CardShowType.CARD_DELETE, 1],
  [CardShowType.CARD_CONTENT, 2],
]);

// UIExtension缓存最大值
const UI_EXTENSION_MAX_CACHE: number = 3;

/**
 * 沉浸大卡数据列表
 */
export class ImmCardDataArray extends Array<ImmCardData> {
  // 缓存UIExtension数据Map，groupKey => ImmCardData
  private readonly cacheUiExtension: Map<string, ImmCardData> = new Map();
  // 数据列表管理，dataGroupKey => ImmCardData
  private readonly allDataMap: Map<string, ImmCardData> = new Map();

  /**
   * 删除指定大卡类型数据
   *
   * @param cardType 大卡类型
   */
  public remove(cardType: CardShowType): void {
    if (!cardType || cardType === CardShowType.CARD_NONE) {
      return;
    }
    const index = this.findIndex((data) => {
      if (data.getCardShowType() === cardType) {
        // 若为UIExtension数据，则同步清除
        this.cacheUiExtension.delete(data?.getGroupKey());
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
    this.cacheUiExtension.clear();
    this.allDataMap.clear();
    if (!this.length) {
      return;
    }
    this.splice(0, this.length);
  }

  /**
   * 排序列表数据
   */
  public sortData(): void {
    super.sort((a, b) => ImmersiveComHelper.compareImmData(a.getOriData(), b.getOriData()));
  }

  /**
   * 存储大卡数据
   *
   * @param type 该数据显示类型
   * @param data 大卡数据
   */
  public setCardData(type: CardShowType, data?: ImmCardData): void {
    // 不允许空类型
    if (type === CardShowType.CARD_NONE) {
      return;
    }
    // 移除现有数据，重新添加
    this.remove(type);
    if (!data) {
      return;
    }
    // 直接刷新类型
    data.setCardShowType(type);
    // 数据不存在则添加
    let groupKey = data.getDataGroupKey();
    if (!this.allDataMap.has(groupKey)) {
      this.push(data);
      this.allDataMap.set(groupKey, data);
    }
  }

  /**
   * 取值目标显示大卡数据
   *
   * @param type 大卡显示类型
   * @returns 目标大卡数据
   */
  public getCardData(type: CardShowType): ImmCardData | undefined {
    return this.find((data) => data.getCardShowType() === type);
  }

  /**
   * 根据分组标识查找大卡数据
   *
   * @param groupKey 分组标识
   * @returns 大卡数据
   */
  public findCardData(groupKey: string): ImmCardData | undefined {
    return this.find((card: ImmCardData) => (card?.getGroupKey() === groupKey && !card?.isCopyData()));
  }

  /**
   * 尝试删除动效检测数据
   *
   * @param type 动效检测类型
   */
  public tryDelAnimCheckData(type: CardShowType): void {
    // 如果数据类型为UIExtension，则直接缓存，否则删除
    let cardData = this.getCardData(type);
    if (cardData?.isUiExtensionCard()) {
      this.addCacheUIExtension(cardData);
    } else {
      this.remove(type);
    }
  }

  /**
   * 移除UIExtension的缓存数据
   *
   * @param groupKey 数据分组标识
   */
  public delCacheUIExtension(groupKey?: string): void {
    if (!groupKey) {
      return;
    }
    // 非UIExtension数据
    if (!this.cacheUiExtension.has(groupKey)) {
      return;
    }
    // 删除数据
    const index = this.findIndex((data) => {
      if (data.getGroupKey() === groupKey && !data.isCopyData()) {
        // 同步清空标识
        data.setCardShowType(CardShowType.CARD_NONE);
        this.allDataMap.delete(data.getDataGroupKey());
        return true;
      }
      return false;
    });
    if (index > -1) {
      this.splice(index, 1);
    }
    this.cacheUiExtension.delete(groupKey);
  }

  /**
   * 添加UIExtension的缓存数据
   *
   * @param data 数据
   */
  public addCacheUIExtension(data?: ImmCardData): void {
    // 非UIExtension数据不允许缓存
    if (!data || !data.isUiExtensionCard()) {
      return;
    }
    // 标识UIExtension缓存类型
    data.setCardShowType(CardShowType.CARD_UI_EXTENSION_CACHE);
    let groupKey = data.getGroupKey();
    // 已缓存
    if (this.cacheUiExtension.has(groupKey)) {
      return;
    }
    // 若已超出缓存阈值，则移除一个
    if (this.cacheUiExtension.size >= UI_EXTENSION_MAX_CACHE) {
      this.remove(CardShowType.CARD_UI_EXTENSION_CACHE);
    }
    // 加入缓存
    this.push(data);
    this.cacheUiExtension.set(groupKey, data);
    this.allDataMap.set(data.getDataGroupKey(), data);
  }

  /**
   * 对应映射索引
   *
   * @param type 大卡类型
   * @returns 映射索引
   */
  public static getZIndex(type: CardShowType): number {
    return TYPE_INDEX.get(type) ?? 0;
  }
}