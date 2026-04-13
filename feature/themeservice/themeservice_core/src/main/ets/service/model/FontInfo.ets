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
import { OriginType } from '@ohos/themeservice_inner_api/Index';

/**
 * AB目录中字体manifest.json（eg：a/app/fonts/manifest.json）
 */
export interface FontInfo {
  /**
   * 字体资源ID
   */
  id: string;

  /**
   * 主题安装来源
   * preset：预置完整的主题包。
   * presetFragment：需要跳转到主题APP，完成整包下载后才能应用。
   * online：在线
   */
  origin: OriginType;

  /**
   * ttf资源文件名
   */
  src: string;

  /**
   * 可扩展的ttf资源文件名数组
   */
  srcExt?: string[];

  /**
   * ttf资源文件原始路径
   */
  ttfFileSrc: string;

  /**
   * 可扩展的ttf资源文件原始路径数组
   */
  ttfFileSrcExt?: string[];

  /**
   * 是否支持多字重
   */
  multiWeight: boolean;
}