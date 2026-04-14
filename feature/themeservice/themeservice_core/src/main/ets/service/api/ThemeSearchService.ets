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

import { common } from '@kit.AbilityKit';
import { TsContext } from '@ohos/themeservicebase';

export interface ThemeSearchService {
  /**
   * 初始化
   *
   * @param subscribe 是否订阅事件回调
   */
  init(subscribe: boolean): Promise<void>;

  /**
   * 搜索词动态注入
   *
   * @param locale 系统设置的区域
   */
  injectSearch(locale: string): Promise<void>;
}