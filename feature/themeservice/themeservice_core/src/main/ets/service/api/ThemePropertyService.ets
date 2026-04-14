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
 * 画廊主题历史试用记录管理服务
 */
export interface ThemePropertyService {
  /**
   * 修改主题属性值
   * @param id 和主题关联的id
   * @param property 主题属性
   * @param defaultValue 主题属性默认值
   * @returns 是否成功
   */
  modifyThemePropertyValue(id: string, property: string, defaultValue?: string): Promise<boolean>;

  /**
   * 获取主题属性值
   * @param id 和主题关联的id
   * @param property 主题属性
   * @returns 主题属性值
   */
  getThemePropertyValue(id: string, property: string): Promise<string>;

  /**
   * 删除主题属性值
   * @param id 和主题关联的id
   * @param property 主题属性
   * @returns 是否成功
   */
  removeThemePropertyValue(id: string, property?: string): Promise<boolean>;
}