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

import { clockLayoutHelper } from './ClockLayoutHelper';
import { ElementConf } from './ClockLayoutParam';

// 横向左中右，竖向上中下
export enum HVAlign {
  START = 0,
  CENTER = 1,
  END = 2
}

// 横向对齐方式标示
export enum HAlignKey {
  H_START = 'H_0',
  H_CENTER = 'H_1',
  H_END = 'H_2',
}

// 竖向对齐方式标示
export enum VAlignKey {
  V_START = 'V_0',
  V_CENTER = 'V_1',
  V_END = 'V_2',
}

// 横向对齐方式标示 - 小折叠产品折叠态
export enum PocketHAlignKey {
  PH_START = 'PH_0',
  PH_CENTER = 'PH_1',
  PH_END = 'PH_2',
}

// 竖向对齐方式标示 - 小折叠产品折叠态
export enum PocketVAlignKey {
  PV_START = 'PV_0',
  PV_CENTER = 'PV_1',
  PV_END = 'PV_2',
}

// 横向、竖向对齐方式标识装饰器
export class AlignKeyWrapper {
  public horizontalAlign?: HVAlign = HVAlign.CENTER; // 横向对齐方式
  public verticalAlign?: HVAlign = HVAlign.START; // 竖向对齐方式
  public eleConf?: ElementConf; // 元素配置

  public static getHKey(wrapper: AlignKeyWrapper): HAlignKey | PocketHAlignKey {
    let hAlign = wrapper?.horizontalAlign ?? HVAlign.CENTER; // 横向默认居中对齐
    return `H_${hAlign}` as HAlignKey;
  }

  public static getVKey(wrapper: AlignKeyWrapper): VAlignKey | PocketVAlignKey {
    let vAlign = wrapper?.verticalAlign ?? HVAlign.START; // 竖向默认顶部对齐
    return `V_${vAlign}` as VAlignKey;
  }
}