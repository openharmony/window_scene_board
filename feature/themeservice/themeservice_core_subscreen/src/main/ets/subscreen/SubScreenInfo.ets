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

import { StringUtils } from '@ohos/themeservicebase/Index'

export const TYPE_INDEPENDENT: string = 'independent';

export const TYPE_COMBINED: string = 'combined';

/**
 * 外屏主题包
 */
export class SubScreenInfo {
  private static readonly DEFAULT_ORDER: number = 0;

  /**
   * 主题包Id
   */
  public readonly originId: string = '';

  /**
   * 主题包Id
   */
  public readonly themeId: string = '';

  /**
   * 外屏主题包类型
   */
  public type: string = '';

  /**
   * 外屏主题包预置类型
   */
  public origin: string = 'preset';

  /**
   * 主题包路径
   */
  public path: string = '';

  /**
   * 主题包自定义路径
   */
  public customPath: string = '';

  /**
   * 是否自定义
   */
  public isCustom: boolean = false;

  /**
   * 是否应用中
   */
  public isEnabled: boolean = false;

  /**
   * 外屏画廊排序
   */
  public order: number = SubScreenInfo.DEFAULT_ORDER;

  /**
   * 是否套系化主题
   */
  public isSuite: boolean = false;

  /**
   * 内屏editorId（用于内外屏主题映射）
   */
  public suiteEditorId: string = '';

  /**
   * 构造方法
   * @param originId 主题原始id
   * @param themeId 外屏主题id
   * @param path 外屏主题原始路径
   * @param customPath 自定义路径
   */
  constructor(originId: string, themeId: string, path: string, customPath?: string | undefined) {
    this.originId = originId;
    this.themeId = themeId;
    this.path = path;
    if (StringUtils.isEmpty(path)) {
      return;
    }
    this.customPath = customPath ? customPath : '';
  }
}