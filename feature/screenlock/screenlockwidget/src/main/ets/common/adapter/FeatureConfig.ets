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
import { CommonUtils } from '@ohos/basicutils';
import { ConfigType, PropertyName } from './Constans';

/**
 * 特性配置接口
 */
export interface IFeatureConfig {
  /**
   * 添加配置项
   *
   * @param property 配置项类型
   * @param value 配置项值
   */
  setConfig<T>(property: ConfigType, value?: T): void;

  /**
   * 获取配置项
   *
   * @param property 配置项类型
   * @returns 配置项值
   */
  getConfig<T>(property: ConfigType): T | undefined;
}

/**
 * 扩展属性工具
 */
export class PropertyHelper {
  /**
   * 设置属性值
   *
   * @param obj 目标对象
   * @param propertyKey 属性key
   * @param value 属性值
   */
  static setPropertyValue<T>(obj: object, propertyKey: PropertyName, value?: T): void {
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
  static getPropertyValue<T>(obj: object, propertyKey: PropertyName): T | undefined {
    if (CommonUtils.isInvalid(obj)) {
      return undefined;
    }
    return obj[propertyKey] as T;
  }
}


/**
 * 基础配置类，可以实现灵活添加配置
 */
export class BaseConfig implements IFeatureConfig {
  /**
   * 添加配置项
   *
   * @param property 配置项类型
   * @param value 配置项值
   */
  setConfig<T>(property: ConfigType, value: T | undefined): void {
    PropertyHelper.setPropertyValue(this, property, value);
  }

  /**
   * 获取配置项
   *
   * @param property 配置项类型
   * @returns 配置项值
   */
  getConfig<T>(property: ConfigType): T | undefined {
    return PropertyHelper.getPropertyValue(this, property);
  }
}