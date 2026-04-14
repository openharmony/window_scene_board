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
import { UpdateResourceInfo } from '../../cache/UpdateThemeInfoCache';

export interface UpdateThemeInfoService {
  /**
   * 获取需要提示更新的主题，过滤掉忽略的
   *
   * @returns 需要更新的主题
   */
  getUpdateThemeListAndRefresh(): Promise<Nullable<UpdateResourceInfo[]>>;

  /**
   * 忽略更新
   *
   * @param id 主题id
   * @param ignoreVersion 忽略的版本
   * @returns 是否忽略成功
   */
  ignoreUpdateTheme(id: string, ignoreVersion: string): Promise<boolean>;

  /**
   * 资源版本变更,可能是删除云上主题或者更新云上主题
   *
   * @param ids 变更的资源id
   */
  resourceChangeNotification(ids: string[]): Promise<void>;

  /**
   * 清除主题更新相关所有缓存
   *
   * @returns 是否清除成功
   */
  clearUpdateThemeAllCache(): Promise<boolean>;
}