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
import { ListAnimSuffix, ListStyleSuffix } from '../../../common/constants/ImmListConst';
import { IImmConfigKey } from './IImmConfigKey';

/**
 * 沉浸列表配置标识
 */
export class ImmListCfgKey implements IImmConfigKey {
  // 实例复用
  private static defaultKey: ImmListCfgKey = new ImmListCfgKey();

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

  private static getListKey(groupKey: string, suffix: ListAnimSuffix | ListStyleSuffix): string {
    return `${groupKey}_${suffix}`;
  }

  /**
   * 组合生成标识
   *
   * @param groupKey 分组标识
   * @param suffix 后缀标识
   * @returns 标识
   */
  public static genKey(groupKey?: string, suffix?: ListAnimSuffix | ListStyleSuffix): ImmListCfgKey {
    // 子条目标识
    if (groupKey && suffix) {
      let strKey = ImmListCfgKey.getListKey(groupKey, suffix);
      ImmListCfgKey.defaultKey._strKey = strKey;
    } else {
      // 根组件标识
      ImmListCfgKey.defaultKey._strKey = SlStateId.SL_LIST_STATE;
    }
    return ImmListCfgKey.defaultKey;
  }

  /**
   * V1状态标识
   *
   * @param v1Id 标识
   * @returns 标识
   */
  public static genV1Key(v1Id?: string): ImmListCfgKey {
    ImmListCfgKey.defaultKey._strKey = v1Id ?? '';
    return ImmListCfgKey.defaultKey;
  }
}