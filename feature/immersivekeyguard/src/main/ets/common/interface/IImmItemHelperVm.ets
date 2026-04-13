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

import { CapAnimSuffix, CapCacheSuffix, CapStyleSuffix } from '../constants/ImmCapConst';
import { CardAnimSuffix, CardCacheSuffix, CardStyleSuffix } from '../constants/ImmCardConst';
import { ListAnimSuffix, ListCacheSuffix, ListStyleSuffix } from '../constants/ImmListConst';
import { ICapItemAnimStHelper } from './ICapItemAnimStHelper';
import { ICapItemCacheStHelper } from './ICapItemCacheStHelper';
import { ICapItemStyleStHelper } from './ICapItemStyleStHelper';
import { ICardItemAnimStHelper } from './ICardItemAnimStHelper';
import { ICardItemCacheStHelper } from './ICardItemCacheStHelper';
import { ICardItemStyleStHelper } from './ICardItemStyleStHelper';
import { IImmItemAnimStHelper } from './IImmItemAnimStHelper';
import { IImmItemCacheStHelper } from './IImmItemCacheStHelper';
import { IImmItemStyleStHelper } from './IImmItemStyleStHelper';

/**
 * 沉浸模块条目辅助工具汇总业务抽象层
 */
export interface IImmItemHelperVm {
  /**
   * 列表动效状态辅助工具
   *
   * @param suffix 动效后缀
   * @returns 辅助工具实例
   */
  getListAnimH(suffix: ListAnimSuffix): IImmItemAnimStHelper;

  /**
   * 列表样式状态辅助工具
   *
   * @param suffix 样式后缀
   * @returns 辅助工具实例
   */
  getListStyleH(suffix: ListStyleSuffix): IImmItemStyleStHelper;

  /**
   * 列表缓存状态辅助工具
   *
   * @param suffix 缓存后缀
   * @returns 辅助工具实例
   */
  getListCacheH(suffix: ListCacheSuffix): IImmItemCacheStHelper;

  /**
   * 胶囊动效状态辅助工具
   *
   * @param suffix 动效后缀
   * @returns 辅助工具实例
   */
  getCapAnimH(suffix: CapAnimSuffix): ICapItemAnimStHelper;

  /**
   * 胶囊样式状态辅助工具
   *
   * @param suffix 样式后缀
   * @returns 辅助工具实例
   */
  getCapStyleH(suffix: CapStyleSuffix): ICapItemStyleStHelper;

  /**
   * 胶囊缓存状态辅助工具
   *
   * @param suffix 缓存后缀
   * @returns 辅助工具实例
   */
  getCapCacheH(suffix: CapCacheSuffix): ICapItemCacheStHelper;

  /**
   * 大卡动效状态辅助工具
   *
   * @param suffix 动效后缀
   * @returns 辅助工具实例
   */
  getCardAnimH(suffix: CardAnimSuffix): ICardItemAnimStHelper;

  /**
   * 大卡样式状态辅助工具
   *
   * @param suffix 样式后缀
   * @returns 辅助工具实例
   */
  getCardStyleH(suffix: CardStyleSuffix): ICardItemStyleStHelper;

  /**
   * 大卡缓存状态辅助工具
   *
   * @param suffix 缓存后缀
   * @returns 辅助工具实例
   */
  getCardCacheH(suffix: CardCacheSuffix): ICardItemCacheStHelper;
}