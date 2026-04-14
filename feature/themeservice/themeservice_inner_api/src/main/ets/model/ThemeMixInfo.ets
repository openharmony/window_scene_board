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

import { OriginType } from '../constant/TSTypes';
import { ThemeOnlineInfo } from './ThemeOnlineInfo';

/**
 * 主题混搭信息
 */
export interface ThemeMixInfo {
  /**
   * 资源id
   */
  id: string;

  /**
   * 资源原始类型
   */
  originType: OriginType;

  /**
   * 在线主题配置
   */
  themeOnlineInfo?: ThemeOnlineInfo;
}