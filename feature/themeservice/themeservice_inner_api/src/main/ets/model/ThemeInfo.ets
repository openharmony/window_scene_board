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
import { NullableType } from '@ohos/themeservicebase/Index';
import { TargetType } from '../constant/TSTypes';
import { ThemeMixInfo } from './ThemeMixInfo';
import { ThemeOnlineInfo } from './ThemeOnlineInfo';
import { ThemePackInfo } from './ThemePackInfo';

/**
 * 主题信息
 */
export class ThemeInfo {
  /**
   * 主题Id
   */
  public readonly id: string;

  /**
   * 主题编辑id（画廊映射id-同一个主题可以多次添加编辑到画廊）
   */
  public readonly editorId: string;

  /**
   * 新增相同主题时，新增主题名称添加数字后缀
   */
  public themeIndex: number = 0;

  /**
   * 是否混搭在线主题资源
   */
  public isMixedOnlineResource: boolean = false;

  /**
   * 原始主题包信息
   */
  public originThemePack?: NullableType<ThemePackInfo>;

  /**
   * 用户自定义主题包信息（增量主题包信息）
   */
  public customThemePack?: NullableType<ThemePackInfo>;

  /**
   * 是否是默认主题
   */
  public isDefault: boolean = false;

  /**
   * 混搭主题信息
   */
  public mixThemeInfos?: Map<TargetType, ThemeMixInfo>;

  /**
   * 是否是托管上云主题（预置小包）
   */
  public isPresetFragment: boolean = false;

  /**
   * 是否是试用主题，默认非试用：false
   */
  public isTrial: boolean = false;

  /**
   * 是否下载（云服务主题app下载主题）
   */
  public isDownLoaded?: boolean;

  /**
   * 在线主题配置
   */
  public themeOnlineInfo?: ThemeOnlineInfo;

  /**
   * 互动主题是否可应用（潘多拉二期主题新增不可应用状态）
   */
  public isUsable: boolean = true;

  /**
   * 互动主题配置项
   */
  public interactive?: string[];

  constructor(id: string, editorId: string) {
    this.id = id;
    this.editorId = editorId;
  }
}