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
import HashMap from '@ohos.util.HashMap';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { BuilderNodeRenderType } from './BaseConstants';

const TAG = 'BaseNodeParams';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export type RenderType = BuilderNodeRenderType;

/**
 * 扩展属性基础实现
 */
export class BaseNodeParams {
  public paramsTag: string = '';

  public propertyList: string[] = [];

  /**
   * 设置Extended信息
   *
   * @param property 属性
   * @param value 属性值
   * @param scene 场景
   * @param position 位置
   */
  setUpdatePropertyValue(property: string, value: Object, scene?: RenderType): void {
    ParamHelper.setParamsValue(property, value);
  }

  /**
   * 复写Extended信息
   *
   * @param property 属性
   * @param value 属性值
   * @param scene 场景
   * @param position 位置
   */
  getUpdatePropertyValue<T>(property: string): T | undefined {
    return ParamHelper.getParamsValue(property);
  }

  /**
   * 复写Extended信息
   *
   * @param property 属性
   * @param value 属性值
   * @param scene 场景
   * @param position 位置
   */
  getNeedUpdateParamsMap(): HashMap<string, object | string | boolean | number | undefined> {
    return ParamHelper.getParamsMap();
  }

  /**
   * 复写Extended信息
   *
   * @param property 属性
   * @param value 属性值
   * @param scene 场景
   * @param position 位置
   */
  getUpdateParamsList(): string[] {
    return this.propertyList;
  }
}

export class ParamHelper {
  static needUpdateParamsMap: HashMap<string, object | string | boolean | number> = new HashMap();

  /**
   * 设置属性值
   *
   * @param obj 目标对象
   * @param propertyKey 属性key
   * @param value 属性值
   */
  static setParamsValue(propertyKey: string, value: Object | string | boolean | number): void {
    if (value instanceof String) {
      ParamHelper.needUpdateParamsMap.set(propertyKey, value.valueOf());
    }
    if (value instanceof Boolean) {
      ParamHelper.needUpdateParamsMap.set(propertyKey, value.valueOf());
    }
    if (value instanceof Number) {
      ParamHelper.needUpdateParamsMap.set(propertyKey, value.valueOf());
    }
    if (value instanceof Object) {
      ParamHelper.needUpdateParamsMap.set(propertyKey, value.valueOf());
    }
  }

  /**
   * 获取属性值
   *
   * @param obj 目标对象
   * @param propertyKey 属性key
   * @return 属性值
   */
  static getParamsValue<T>(propertyKey: string): T | undefined {
    if (!ParamHelper.needUpdateParamsMap.hasKey(propertyKey)) {
      return undefined;
    }
    return ParamHelper.needUpdateParamsMap.get(propertyKey) as T;
  }

  /**
   * 获取刷新变量的map
   *
   * @param obj 目标对象
   * @param propertyKey 属性key
   * @return 刷新变量的map
   */
  static getParamsMap(): HashMap<string, object | string | boolean | number> {
    return ParamHelper.needUpdateParamsMap;
  }
}