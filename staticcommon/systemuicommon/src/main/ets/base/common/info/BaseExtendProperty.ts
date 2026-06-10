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

import type { IPropertyExtended } from '../interface/IPropertyExtended';
import { PropertyHelper } from '../interface/IPropertyExtended';
import type { PositionName, PropertyName, UsageScene } from '../interface/IPropertyExtended';

/**
 * 扩展属性基础实现
 */
export class BaseExtendProperty implements IPropertyExtended {
  /**
   * 复写IPropertyExtended
   *
   * @param property 属性
   * @param value 属性值
   * @param scene 场景
   * @param position 位置
   */
  setExtendPropertyValue<T>(property: PropertyName, value?: T, scene?: UsageScene, position?: PositionName): void {
    let key = PropertyHelper.getPropertyKey(property, scene, position);
    PropertyHelper.setPropertyValue(this, key, value);
  }

  /**
   * 复写IPropertyExtended
   *
   * @param property 属性
   * @param scene 场景
   * @param position 位置
   */
  getExtendPropertyValue<T>(property: PropertyName, scene?: UsageScene, position?: PositionName): T | undefined {
    let key = PropertyHelper.getPropertyKey(property, scene, position);
    return PropertyHelper.getPropertyValue(this, key);
  }
}