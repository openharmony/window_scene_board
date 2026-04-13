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
import { CardAnimSuffix, CardShowType, CardStyleSuffix } from '../../../common/constants/ImmCardConst';
import { IImmConfigKey } from './IImmConfigKey';

/**
 * 沉浸大卡配置标识
 */
export class ImmCardCfgKey implements IImmConfigKey {
  // 实例复用
  private static defaultKey: ImmCardCfgKey = new ImmCardCfgKey();

  // 转换标识
  private _strKey: string = 'default';

  private constructor() {
  }

  /**
   * 转换标识
   *
   * @returns 标识
   */
  public getKey(): string {
    return this._strKey;
  }

  private static getCapKey(cardType: CardShowType, suffix: CardAnimSuffix | CardStyleSuffix): string {
    return `${cardType}_${suffix}`;
  }

  /**
   * 组合生成标识
   *
   * @param cardType 大卡类型
   * @param suffix 后缀标识
   * @returns 标识
   */
  public static genKey(cardType?: CardShowType, suffix?: CardAnimSuffix | CardStyleSuffix): ImmCardCfgKey {
    // 子条目标识
    if (cardType && suffix) {
      let strKey = ImmCardCfgKey.getCapKey(cardType, suffix);
      ImmCardCfgKey.defaultKey._strKey = strKey;
    } else {
      // 根组件标识
      ImmCardCfgKey.defaultKey._strKey = SlStateId.SL_CARD_STATE;
    }
    return ImmCardCfgKey.defaultKey;
  }

  /**
   * V1状态标识
   *
   * @param v1Id 标识
   * @returns 标识
   */
  public static genV1Key(v1Id?: string): ImmCardCfgKey {
    ImmCardCfgKey.defaultKey._strKey = v1Id ?? '';
    return ImmCardCfgKey.defaultKey;
  }
}