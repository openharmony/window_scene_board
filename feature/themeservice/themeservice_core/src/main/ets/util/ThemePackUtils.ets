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

import { JsonUtils } from '@ohos/themeservicebase/Index';

/**
 * 主题包工具类
 */
export namespace ThemePackUtils {
  /**
   * 修改主题包描述信息
   * @param {string} description - 主题包描述信息
   * @param {string} key - 需要修改的关键字
   * @param {string | number | object} value - 新的值，可以是字符串、数字或对象
   * @return {string} 返回修改后的描述信息
   */
  export function modifyDescription(description: string, key: string, value: string | number | object): string {
    let descriptionObj: Nullable<Record<string, number | string | object>> =
      JsonUtils.parse(description);
    if (descriptionObj) {
      descriptionObj[key] = value;
    }
    return JsonUtils.stringify(descriptionObj) ?? description;
  }

  /**
   * 修改Json字串key对应的value值
   * @param {string} strContent - 字串内容
   * @param {string} key - 需要修改的关键字
   * @param {string | number | object} value - 新的值，可以是字符串、数字或对象
   * @return {string} 返回修改后的json字串
   */
  export function modifyJson(strContent: string, key: string, value: string | number | object,
    condition?: (value: number | string | object) => boolean): string {
    let jsonContent: Nullable<Record<string, number | string | object>> = JsonUtils.parse(strContent);
    if (jsonContent) {
      if (condition) {
        if (condition(jsonContent[key])) {
          jsonContent[key] = value;
        }
      } else {
        jsonContent[key] = value;
      }
    }
    return JsonUtils.stringify(jsonContent) ?? strContent;
  }

  /**
   * 获取描述信息内容
   * @param {Nullable<string>} description - 可能为空的描述字符串
   * @param {string} key - 用于获取描述的键
   * @return {number | string | object | undefined} 返回对应键的描述，可能是数字、字符串、对象或者未定义
   */
  export function getDescription(descriptionValue: Nullable<string>,
    key: string): number | string | object | undefined {
    if (!descriptionValue) {
      return undefined;
    }
    let descriptionObj: Nullable<Record<string, number | string | object>> = JsonUtils.parse(descriptionValue);
    return descriptionObj ? descriptionObj[key] : undefined;
  }
}