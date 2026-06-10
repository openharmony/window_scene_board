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

import { ClockStaticStateType } from '@ohos/screenlockcommon';
import { IImmConfigKey } from './IImmConfigKey';

/**
 * 首页时钟配置标识
 */
export class SlClockCfgKey implements IImmConfigKey {
  // 实例复用
  private static defaultKey: SlClockCfgKey = new SlClockCfgKey();

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

  /**
   * V1状态标识
   *
   * @param v1Id 标识
   * @returns 标识
   */
  public static genV1Key(v1Id?: string): SlClockCfgKey {
    SlClockCfgKey.defaultKey._strKey = v1Id ?? ClockStaticStateType.CLOCK_VIEW_ANIM;
    return SlClockCfgKey.defaultKey;
  }
}