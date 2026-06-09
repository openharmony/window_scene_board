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

import { CapShowType } from '../../../common/constants/ImmCapConst';
import { ImmCapData } from './ImmCapData';

// 胶囊动效检测数据集
export class ImmCapCheckData extends Map<CapShowType, ImmCapData> {
  // 记录此次数据刷新是否自动亮屏
  private _isAutoScreenOn: boolean = false;

  /**
   * 标识此次数据刷新是否自动亮屏
   *
   * @param isAutoScreenOn true自动亮屏
   */
  public setAutoScreenOn(isAutoScreenOn: boolean): void {
    this._isAutoScreenOn = isAutoScreenOn;
  }

  /**
   * 此次数据刷新是否自动亮屏
   *
   * @returns true自动亮屏
   */
  public isAutoScreenOn(): boolean {
    return this._isAutoScreenOn;
  }
}