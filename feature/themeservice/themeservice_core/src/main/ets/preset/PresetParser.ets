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

/**
 * PresetParser接口，定义了一个预设解析器，用于解析预设数据
 * @export
 * @interface
 * @template T 预设数据的类型
 */
export interface PresetParser<T> {
  /**
   * 解析所有预设数据
   * @param {string} json 主题包目录下的json文件{manifest.json和hidemanifest.json}
   * @returns {Promise<T[]>} 返回一个Promise，其解析结果是一个预设数据的数组
   */
  parseAll(json: string): Promise<T[]>;

  /**
   * 解析指定目录下的预设数据
   * @param {string} dir 预设数据的目录
   * @returns {Promise<T>} 返回一个Promise，其解析结果是一个预设数据
   */
  parse(dir: string): Promise<T>;

  /**
   * 解析默认的预设数据
   * @returns {Promise<T>} 返回一个Promise，其解析结果是一个预设数据
   */
  parseDefault(): Promise<T>;

  /**
   * 获取默认预设数据的目录
   * @returns {Promise<string>} 返回一个Promise，其解析结果是默认预设数据的目录
   */
  getDefaultDir(): Promise<string>;
}
