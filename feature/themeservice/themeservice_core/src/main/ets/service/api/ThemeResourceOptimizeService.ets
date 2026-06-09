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
import { ThemeInfo } from '@ohos/themeservice_inner_api/Index';

export interface ThemeResourceOptimizeService {
  /**
   * 优化主题包中图片资源
   * @param themeInfo 待优化的主题包
   */
  optimizeThemeImage(themeInfo: ThemeInfo): Promise<void>;

  /**
   * 监听需要优化资源的事件
   */
  subscribeOptEvent(): Promise<void>;
}