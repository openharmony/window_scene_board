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
import { ThemeInfo } from './../../../../Index';
import { NullableType } from '@ohos/themeservicebase';

export interface ThemeInfoApi {

  /**
   * 获取正在应用的主题信息
   * @returns 当前主题信息
   */
  getCurrentInnerTheme(): Promise<NullableType<ThemeInfo>>;

  /**
   * 获取当前内屏所有主题信息
   * @param {number} type - 主题类型
   * @returns 当前内屏所有主题信息
   */
  getCurrentInnerThemeInfoList(type: number): Promise<NullableType<ThemeInfo[]>>;
}