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

import configPolicy from '@ohos.configPolicy';
import { PresetResType, Qualifier, TargetType, ThemeInfo, ThemeOptions } from '@ohos/themeservice_inner_api';
import { ContextUtil, StringUtils, TsLog, FileUtil, JsonUtils } from '@ohos/themeservicebase';

const TAG: string = `TSPathUtils`;

const FILE_SEPARATOR: string = '/';
const OPT_FILE_DIR: string = `opt`;

export namespace TSPathUtils {
  export type TSPathType = () => string;

  export const getSCBRootPath: TSPathType = () => ContextUtil.getTsApplicationContext()?.filesDir;

  export const themeSharePath: string = `/data/themes/s`;

  export const getTsRootPath: TSPathType = () => `${getSCBRootPath()}/theme_service`;

  /**
   * 整合主题资源包路径
   */
  export const getTsPackagedPath: TSPathType = () => `${getTsRootPath()}/theme`;

  export const getTsCustomTmpPath: TSPathType = () => `${getTsRootPath()}/customtmp`;

  export const getTsCustomRootPath: TSPathType = () => `${getTsRootPath()}/t_pkg`;

  export const getTsOnlineRecommendPath: TSPathType = () => `${getTsRootPath()}/online/recom`;

  export const getTsOnlineThemePath: TSPathType = () => `${themeSharePath}/online/`;

  /**
   * 预置包优化缓存根路径
   */
  export const getTsPresetOptimizePath: TSPathType = () => `${getTsRootPath()}/t_pre_pkg`;

  export const getTsWallpaperBlurPath: TSPathType = () => `${getTsRootPath()}/t_wallpaper/blur`;

  export const getTsCachePath: TSPathType = () => `${getTsRootPath()}/cache_json`

  export function getCustomResourceTmpPath(targetType: TargetType,
    qualifier?: Qualifier, fileName?: string): string {
    return StringUtils.join(`/`, [`${getTsCustomTmpPath()}`,
      targetType, qualifier, fileName]);
  }

  export function getThemeOriginPackageOptPath(themeId: string): string {
    return StringUtils.join(FILE_SEPARATOR, [`${getTsPresetOptimizePath()}`, themeId, OPT_FILE_DIR])
  }

  export function getThemeCustomPackageOptPath(themeInfo: ThemeInfo | string): string {
    return StringUtils.join(FILE_SEPARATOR, [`${getThemeCustomPackagePath(themeInfo)}`, OPT_FILE_DIR]);
  }

  export function getThemeCustomPackagePath(themeInfo: ThemeInfo | string): string {
    return StringUtils.join(`/`, [`${getTsCustomRootPath()}`, `${genThemePackageName(themeInfo)}`]);
  }

  function genThemePackageName(themeInfo: ThemeInfo | string): string {
    let editorId: string = (typeof themeInfo === 'string') ? themeInfo : themeInfo.editorId;

    if (editorId) {
      let themeIdIndex: number = editorId.indexOf('-');
      if (themeIdIndex >= 0) {
        return editorId.substring(themeIdIndex + 1)
      }
      return editorId;
    }
    return '';
  }

  /**
   * 获取预设资源的根路径,返回优先级从低到高
   * @param {PresetResType} resType - 预设资源类型，可选参数
   * @return {Promise<Array<string>>} 返回一个Promise，其解析值为预设资源的根路径
   */
  export async function getTsPresetRootPath(resType?: PresetResType): Promise<Array<string>> {
    // 根据resType的值，构建相对路径
    const relPath: string = resType ? `resource/themes/${resType}` : `resource/themes`
    // 调用configPolicy的getOneCfgFile方法，获取配置文件的路径
    try {
      return await configPolicy.getCfgFiles(relPath);
    } catch (error) {
      TsLog.warning(TAG, `config policy get error:${error.code},message:${error.msg}`);
      return [];
    }
  }

  /**
   * 打印路径下的文件内容，根据option进行过滤
   * @param path  需要打印的文件路径
   * @param option 根据option进行过滤
   */
  export async function printFileNameByPath(path: string | undefined, option: ThemeOptions | undefined): Promise<void> {
    if (path === undefined || !FileUtil.isFileExists(path)) {
      TsLog.info(TAG, `file path is null.`);
      return;
    }
    const printNum: number = 5;
    let subActivateResource: string[] =
      ['home', 'lock', 'aod', 'sub_screen'];
    let optionStr: string | undefined = JsonUtils.stringify(option);
    TsLog.info(TAG, `printFileNameByPath option is : ${optionStr}`);
    for (const resource of subActivateResource) {
      let num: number = 0;
      if (optionStr === undefined || optionStr.includes(resource)) {
        let fileNames = await FileUtil.listFileNames(`${path}/${resource}`, true);
        TsLog.info(TAG, `printFileNameByPath resource is : ${resource}, file size is: ${fileNames.length}`);
        fileNames.forEach((themeName: string) => {
          if (num++ < printNum) {
            TsLog.info(TAG, `print file name is : ${themeName}`);
          }
        });
      }
    }
  }

  /**
   * 获取ttf文件的完整路径
   * @param fontDir  字体文件所在路径
   * @param fontName 字体文件名
   */
  export function getFontPath(fontDir: string, fontName: string): string {
    if (!FileUtil.isFileExists(fontDir) || StringUtils.isEmpty(fontName)) {
      TsLog.error(TAG, 'getFontPath, fontDir invalid or fontName is empty');
      return fontName;
    }
    if (fontName?.includes(FILE_SEPARATOR)) {
      return fontName;
    }
    return `${fontDir}/${fontName}`;
  }

  /**
   * 获取ttf文件的路径数组
   * @param fontDir  字体文件所在路径
   * @param fontName 字体文件名
   * @param fontNameExt 字体文件名数组
   */
  export function getFontPathExt(fontDir: string, fontName: string,
    fontNameExt: Nullable<string[]>): Nullable<string[]> {
    if (!FileUtil.isFileExists(fontDir) || StringUtils.isEmpty(fontName)) {
      TsLog.error(TAG, 'getFontPathExt, fontDir invalid or fontName is empty');
      return fontNameExt;
    }
    if (fontName?.includes(FILE_SEPARATOR)) {
      return fontNameExt;
    }
    let fontPathExt: Nullable<string[]> = fontNameExt ? [] : undefined;
    fontNameExt?.forEach((fileName: string) => {
      if (fileName?.endsWith('.ttf')) {
        fontPathExt?.push(`${fontDir}/${fileName}`);
      } else {
        TsLog.warning(TAG, `getFontPathExt Invalid file name. fileName= ${fileName}`);
      }
    });
    return fontPathExt;
  }

  /**
   * 获取ttf文件名数组
   * @param fontPath 字体文件路径
   * @param fontPathExt 字体文件路径数组
   */
  export function getFontNameExt(fontPath: string | undefined, fontPathExt: Nullable<string[]>): Nullable<string[]> {
    if (StringUtils.isEmpty(fontPath)) {
      TsLog.error(TAG, 'getFontNameExt, fontPath is empty');
      return fontPathExt;
    }
    if (!fontPath?.includes(FILE_SEPARATOR)) {
      return fontPathExt
    }
    let fontNameExt: Nullable<string[]> = fontPathExt ? [] : undefined;
    fontPathExt?.forEach((filePath: string) => {
      fontNameExt?.push(FileUtil.getFileName(filePath));
    });
    return fontNameExt;
  }
}