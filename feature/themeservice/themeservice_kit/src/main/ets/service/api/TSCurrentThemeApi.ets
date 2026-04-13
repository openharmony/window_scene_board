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

import { IconsInfo } from '../model/IconsInfo';

/**
 * 当前主题通用API，调用方为大桌面主进程
 */
export interface TSCurrentThemeApi {

  /**
   * 判断当前主题包是否有在线充电动效资源
   *
   * @return true：有充电动效资源
   */
  hasChargingResource(): Promise<boolean[]>;

  /**
   * 获取当前使能的图标信息
   *
   * @returns {IconsInfo} 图标信息，包含id和origin
   */
  getIconsInfo(): Promise<IconsInfo>;
}