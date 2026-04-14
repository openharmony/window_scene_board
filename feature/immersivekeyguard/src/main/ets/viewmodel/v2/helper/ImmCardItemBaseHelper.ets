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

import { SlStateId } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { CardAnimSuffix, CardCacheSuffix, CardShowType, CardStyleSuffix } from '../../../common/constants/ImmCardConst';
import { ImmItemBaseHelper } from './ImmItemBaseHelper';
import { IBaseNestableState } from './IBaseNestableState';

/**
 * 沉浸大卡条目状态辅助工具基类
 */
export abstract class ImmCardItemBaseHelper<T extends IBaseNestableState<T>> extends ImmItemBaseHelper<T> {
  /**
   * 标识大卡状态
   *
   * @returns 大卡标识
   */
  protected getStateId(): SlStateId.SL_CARD_STATE {
    return SlStateId.SL_CARD_STATE;
  }

  /**
   * 大卡item状态拼接后缀
   *
   * @returns 拼接后缀
   */
  protected abstract getStSuffix(): CardAnimSuffix | CardStyleSuffix | CardCacheSuffix;

  /**
   * 加入item状态
   *
   * @param cardType 大卡类型
   */
  public addItemSt(cardType: CardShowType): void {
    super.addItemSt(cardType);
  }

  /**
   * 移除item状态
   *
   * @param cardType 大卡类型
   */
  public removeItemSt(cardType: CardShowType): void {
    super.removeItemSt(cardType);
  }

  /**
   * 取值item状态
   *
   * @param cardType 大卡类型
   * @returns 状态值
   */
  public getItemSt(cardType: CardShowType): T | undefined {
    return super.getItemSt(cardType);
  }
}