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

/*
 */

import { CommonUtils } from '@ohos/basicutils';
import type { LivePositionName, LivePropertyName, LiveUsageScene } from '../../../liveview/common/LiveConstants';

/**
 * 类型-属性名称
 */
export type PropertyName = LivePropertyName;

/**
 * 类型-属性使用场景
 */
export type UsageScene = LiveUsageScene;

/**
 * 类型-属性使用组件位置
 */
export type PositionName = LivePositionName;

/**
 * 属性扩展接口
 */
export interface IPropertyExtended {
  /**
   * 设置对应属性值
   *
   * @param property 属性名
   * @param value 属性值
   * @param scene 使用场景
   * @param position 使用位置
   */
  setExtendPropertyValue<T>(property: PropertyName, value?: T, scene?: UsageScene, position?: PositionName): void;

  /**
   * 获取对应属性值
   *
   * @param property 属性名
   * @param scene 使用场景
   * @param position 使用位置
   * @returns 当前值
   */
  getExtendPropertyValue<T>(property: PropertyName, scene?: UsageScene, position?: PositionName): T;
}

/**
 * 扩展属性工具
 */
export class PropertyHelper {
  /**
   * 获取属性key
   *
   * @param property 属性名
   * @param scene 场景
   * @param position 位置
   * @returns 属性标示
   */
  static getPropertyKey(property: PropertyName, scene?: UsageScene, position?: PositionName): string {
    return `${scene ?? ''}${position ?? ''}${property}`;
  }

  /**
   * 设置属性值
   *
   * @param obj 目标对象
   * @param propertyKey 属性key
   * @param value 属性值
   */
  static setPropertyValue<T>(obj: object, propertyKey: string, value?: T): void {
    if (CommonUtils.isInvalid(obj)) {
      return;
    }
    obj[propertyKey] = value;
  }

  /**
   * 获取属性值
   *
   * @param obj 目标对象
   * @param propertyKey 属性key
   * @return 属性值
   */
  static getPropertyValue<T>(obj: object, propertyKey: string): T | undefined {
    if (CommonUtils.isInvalid(obj)) {
      return undefined;
    }
    return obj[propertyKey] as T;
  }
}