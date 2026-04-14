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
import { OriginType, QualifierContent } from '../constant/TSTypes';

export class ThemePackInfo {
  /**
   * 主题包路径,如：/sys_prod/variant/region_comm/china/resource/theme/themes/default
   */
  public srcPath: string = '';
  /**
   * 优化后壁纸缩略图存储路径
   * 增量包优化路径：/data/storage/el1/base/files/theme_service/t_pkg/${editorId}/opt
   * 原始包优化路径：/data/storage/el1/base/files/theme_service/t_pre_pkg/${themeId}/opt
   *
   * TS内部缓存中该字段为空,该字段只有在toThemeInfo时才会赋值
   */
  public optPath: string = '';
  /**
   * 主题安装来源
   */
  public origin?: OriginType;
  /**
   * 【JSON字符串】主题包描述文件内容
   */
  public description: string = '';
  /**
   * 【JSON字符串】主题包（锁屏）描述配置文件，用于配置锁屏相关信息。
   */
  public lockManifest: string = '';
  /**
   * 【json字符串】  锁屏时钟、卡片等配置信息
   */
  public lockConfig?: QualifierContent<string>;
  /**
   * 【JSON字符串】主题包（home）描述配置文件，用于配置桌面锁屏相关信息。
   */
  public homeManifest: string = ``;
}