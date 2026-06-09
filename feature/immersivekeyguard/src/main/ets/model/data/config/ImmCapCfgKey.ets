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

import { SlStateId } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { CapAnimSuffix, CapShowType, CapStyleSuffix } from '../../../common/constants/ImmCapConst';
import { IImmConfigKey } from './IImmConfigKey';

/**
 * 沉浸胶囊配置标识
 */
export class ImmCapCfgKey implements IImmConfigKey {
  // 实例复用
  private static defaultKey: ImmCapCfgKey = new ImmCapCfgKey();

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

  private static getCapKey(capType: CapShowType, suffix: CapAnimSuffix | CapStyleSuffix): string {
    return `${capType}_${suffix}`;
  }

  /**
   * 组合生成标识
   *
   * @param capType 胶囊类型
   * @param suffix 后缀标识
   * @returns 标识
   */
  public static genKey(capType?: CapShowType, suffix?: CapAnimSuffix | CapStyleSuffix): ImmCapCfgKey {
    // 子条目标识
    if (capType && suffix) {
      let strKey = ImmCapCfgKey.getCapKey(capType, suffix);
      ImmCapCfgKey.defaultKey._strKey = strKey;
    } else {
      // 根组件标识
      ImmCapCfgKey.defaultKey._strKey = SlStateId.SL_CAP_STATE;
    }
    return ImmCapCfgKey.defaultKey;
  }
}