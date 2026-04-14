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
import { ThemeMixInfo } from '@ohos/themeservice_inner_api/Index';
import { ThemePackInfo } from './ThemePackInfo';

export class ThemeInfoV2 {
  /**
   * 主题id
   */
  public id: string = '';

  /**
   * 画廊编辑id
   */
  public editorId: string = '';

  /**
   * 原始主题包信息
   */
  public originThemePack?: ThemePackInfo;

  /**
   * 修改的主题包增量信息
   */
  public customThemePack?: Nullable<ThemePackInfo>;

  /**
   * 混搭主题信息
   */
  public mixThemeInfos?: Map<string, ThemeMixInfo>;
}