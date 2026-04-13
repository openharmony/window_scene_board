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
import { TConfigArg } from '../model/TConfigArg';
import { ThemeOptions } from '../model/ThemeOptions';
import { WallPaperInfo } from '../model/WallPaper';
import { EditThemeArg } from '../model/EditThemeArg';

export interface ThemeActivateApi {
  /**
   * 应用主题；调用方：主题app
   * @param path 主题资源包的根路径
   * @param option 应用主题参数
   * @param apply 是否应用到主题画廊
   * @param innerScreenOnly 是否仅应用内屏
   * @returns 应用结果
   */
  activateTheme(path: string, option?: ThemeOptions, apply?: boolean, innerScreenOnly?: boolean): Promise<boolean>;

  /**
   * 应用编辑的主题；调用方：合一编辑器、主题app
   * @param editorId 画廊编辑ID
   * @param option 应用选项
   * @param innerScreenOnly 是否仅应用内屏
   * @returns 应用结果
   * @deprecated {Use the editTheme() method instead}
   */
  activateEditedTheme(editorId: string, option?: ThemeOptions, innerScreenOnly?: boolean): Promise<boolean>;

  /**
   * 保存主题；调用方：合一编辑器
   * @param path 主题资源包的根路径
   * @param custom 自定义主题资源包路径
   * @param isUsable 主题包是否可应用(潘多拉二期主题新增)
   * @returns 保存主题的editorId
   */
  saveThemeCustom(path: string, custom?: string, isUsable?: boolean): Promise<string>;

  /**
  * 应用自定义主题；调用方：合一编辑器
  * @param path 主题资源包的根路径
  * @param customPath 自定义主题资源包路径
  * @param option 应用主题参数
  * @param apply 是否应用保存到主题画廊
  * @param innerScreenOnly 是否仅应用内屏
  * @returns 应用结果
  */
  activateThemeCustom(path: string, customPath?: string, option?: ThemeOptions, apply?: boolean,
    innerScreenOnly?: boolean): Promise<boolean>;

  /**
   * 应用编辑的主题。调用方：合一编辑器、主题app
   * @param editArg 编辑主题参数
   * @param innerScreenOnly 是否仅应用内屏
   * @returns 应用结果 true：应用成功 false：应用失败
   */
  editTheme(editArg: EditThemeArg, innerScreenOnly?: boolean): Promise<boolean>;

  /**
   * 设置壁纸；调用方：合一编辑器
   * @param wallPapers 壁纸信息，可以一次设置多种类型壁纸
   * @returns 结果
   */
  setWallPaper(wallPapers: WallPaperInfo[]): Promise<boolean>

  /**
   * 应用图标资源；调用方：桌面
   * @param path 图标资源路径
   * @returns 应用结果
   */
  applyIcons(path: string): Promise<boolean>;

  /**
   * 应用字体；调用方：合一编辑器
   * @param id 字体包id
   * @param ttf 字体ttf文件路径
   * @param originType 字体包安装来源
   * @param ttfExt 字体ttf文件路径数组
   * @param multiWeight 是否可调节字重
   * @returns 应用结果
   */
  applyFont(id: string, ttf: string, originType: OriginType, ttfExt?: string[], multiWeight?: boolean): Promise<number>;

  /**
   * 应用主题皮肤；调用方：主题app
   * @param skinPkg 皮肤资源目录，可以支持多个皮肤包
   * @param pkgNames 需要换肤的应用bundle名称列表
   * @returns 结果
   */
  setSkin(skinPath: string, pkgNames: string[]): Promise<boolean>;

  /**
   * 应用自定义配置
   * @param tConfigArgs 配置信息
   * @param activated true:应用到ab目录；false|undefined:不应用到ab目录
   * @returns 结果
   */
  applyCustomConfig(tConfigArgs: TConfigArg[], activated?: boolean): Promise<boolean>;

  /**
   * 使能系统默认主题
   * 1：画廊中存在的没有编辑过的默认主题记录，使能该默认主题记录
   * 2：不存在，使能新默认主题，画廊中增加一条记录
   * @returns true：使能成功
   */
  activateDefaultTheme(): Promise<boolean>;

  /**
   * 使能系统默认字体
   * @returns true：使能成功
   */
  activateDefaultFont(): Promise<boolean>;

  /**
   * 使能切换主题风格
   * @returns
   */
  activateThemeStyle(contentType: string[], style: string):Promise<boolean>;
}