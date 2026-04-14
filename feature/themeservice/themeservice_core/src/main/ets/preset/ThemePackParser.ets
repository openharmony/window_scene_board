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

import { ORIGIN_PRESET, OriginType, PRESET_RES_THEME, ThemePackInfo } from '@ohos/themeservice_inner_api';
import { FileUtil, JsonUtils, StringUtils, TsLog } from '@ohos/themeservicebase';
import { QualifierUtil } from '../util/QualifierUtil';
import { ThemeColorRuleUtil } from '../util/ThemeColorRuleUtil';
import { ThemePackUtils } from '../util/ThemePackUtils';
import { TSPathUtils } from '../util/TSPathUtils';
import { PresetParser } from './PresetParser';

const TAG: string = 'ThemePackParser';

/**
 * 预置主题解析器
 */
class ThemePackParser implements PresetParser<ThemePackInfo> {
  constructor() {
  }

  /**
   * 解析所有主题包信息
   * @param {string} json 主题包目录下的json文件{manifest.json和hidemanifest.json}
   * @return {Promise<ThemePackInfo[]>} 返回一个Promise，其解析结果为ThemePackInfo数组
   */
  async parseAll(json: string): Promise<ThemePackInfo[]> {
    TsLog.info(TAG, `parseAll start`);
    try {
      // 遍历主题类别数组，得到预置主题数组
      const themePackInfoArray: ThemePackInfo[] = [];
      const presetThemePathList: string[] = await TSPathUtils.getTsPresetRootPath(PRESET_RES_THEME);
      let themePackMap: Map<string, ThemePackInfo[]> = new Map();
      for (const presetThemeRootPath of presetThemePathList) {
        // 从json文件中获取主题清单，将主题清单解析为ThemeCategory数组。当前json文件为manifest.json和hidemanifest.json(分享需求新增)
        const themeManifest: string = FileUtil.getStringByFile(`${presetThemeRootPath}/${json}`);
        const themeCategoryArray: ThemeCategory[] | undefined = JsonUtils.parse(themeManifest);
        if (!themeCategoryArray || themeCategoryArray.length === 0) {
          TsLog.error(TAG, `parseAll is null`);
          continue;
        }
        themeCategoryArray.sort((item1, item2) => {
          return this.getValidIdxTe(item1) - this.getValidIdxTe(item2);
        });
        for (let themeCategory of themeCategoryArray) {
          if (!themeCategory.dir) {
            continue;
          }
          await this.handleThemeCategory(themeCategory, presetThemeRootPath, themePackMap);
        }
      }
      themePackMap.forEach((infoArray) => {
        if (infoArray.length > 0) {
          themePackInfoArray.push(...infoArray);
        }
      });
      return themePackInfoArray;
    } catch (error) {
      TsLog.error(TAG, `parseAll failed , error = ${error}`);
      return [];
    }
  }

  private getValidIdxTe(themeCategory: ThemeCategory): number {
    if (!themeCategory) {
      return 0;
    }
    return themeCategory.idxTe ?? 0;
  }

  private async handleThemeCategory(themeCategory: ThemeCategory, presetThemeRootPath: string,
    themePackMap: Map<string, ThemePackInfo[]>): Promise<void> {
    // 存储数据，不会去重
    let themePackInfoArray: ThemePackInfo[] = themePackMap.get(themeCategory.category) ?? [];
    if (themeCategory.dir.length === 0) {
      if (!themePackMap.has(themeCategory.category)) {
        themePackMap.set(themeCategory.category, themePackInfoArray);
        TsLog.info(TAG, `reserve empty category ${themeCategory.category}`);
      }
      TsLog.info(TAG, `handleThemeCategory, empty dir`);
      return;
    }

    for (let themeDir of themeCategory.dir) {
      // 解析dir对应路径下的主题包配置信息
      let themePackInfo: ThemePackInfo = await this.parse(`${presetThemeRootPath}/${themeDir.theme}`);
      if (themePackInfo && !StringUtils.isEmpty(themePackInfo.description)) {
        // 符合新主题包规范
        themePackInfoArray.push(themePackInfo);
      } else {
        // 不符合新主题包规范
        TsLog.warning(TAG, `parse themePackInfo not comply specifications : ${JsonUtils.stringify(themePackInfo)}`);
      }
    }
    themePackMap.set(themeCategory.category, themePackInfoArray);
  }

  /**
   * 解析主题包信息
   * @param themePath 主题包的路径，eg：/sys_prod/.../themes/theme/default、/sys_prod/.../themes/theme/default_02
   * @return 返回一个Promise，其中包含主题包的信息
   */
  async parse(themePath: string): Promise<ThemePackInfo> {
    TsLog.info(TAG, `parse themePath = ${FileUtil.getFileName(themePath)}`);
    const themePackInfo: ThemePackInfo = new ThemePackInfo();
    try {
      // 设置主题包信息的源路径
      themePackInfo.srcPath = themePath;
      // 从description.json文件中读取主题包的描述信息
      themePackInfo.description = await FileUtil.readFileContent(`${themePath}/description.json`);
      themePackInfo.origin = await this.getOrigin(themePackInfo.description);
      // 从home/manifest.json文件中读取主题包的主页配置信息
      themePackInfo.homeManifest = await FileUtil.readFileContent(`${themePath}/home/manifest.json`);
      // 从lock/manifest.json文件中读取主题包的锁屏配置信息
      themePackInfo.lockManifest = await FileUtil.readFileContent(`${themePath}/lock/manifest.json`);
      // 初始化时钟信息
      themePackInfo.lockConfig = await QualifierUtil.getQualifierFile(`${themePath}/lock`, `config.json`);
      TsLog.info(TAG, `parse success`);
    } catch (e) {
      TsLog.error(TAG, `parse themePath`, e);
    }
    return themePackInfo;
  }

  /**
   * 解析默认的预设数据
   * @returns {Promise<T>} 返回一个Promise，其解析结果是一个预设数据
   */
  parseDefault(): Promise<ThemePackInfo> {
    return this.getDefaultDir().then(defThemeDir => this.parse(defThemeDir).then());
  }

  async getDefaultDir(): Promise<string> {
    const presetThemeDirList: string[] = await TSPathUtils.getTsPresetRootPath(PRESET_RES_THEME);
    let defaultDir: string = '';
    for (const presetThemeDir of presetThemeDirList) {
      if (FileUtil.isFileExists(`${presetThemeDir}/default`)) {
        // 默认主题使用优先级最高匹配的优先级
        defaultDir = `${presetThemeDir}/default`;
      }
    }
    return await this.getDefaultDirWithColorRule(defaultDir);
  }

  private async getDefaultDirWithColorRule(dir: string): Promise<string> {
    let colorJsonObject: Nullable<object> = await ThemeColorRuleUtil.getThemeColorJsonObject();
    let defaultDir: string = dir;
    if (colorJsonObject && String(Object.values(colorJsonObject)[0]) === dir) {
      defaultDir = this.updateDefaultDirWithColorRule(colorJsonObject, dir);
    }
    return defaultDir;
  }

  private updateDefaultDirWithColorRule(colorRule: object, dir: string): string {
    let backColor: string = ThemeColorRuleUtil.getDeviceBackColor();
    TsLog.info(TAG, `backColor = ${backColor}`);
    let value: object = colorRule[`${backColor}`];
    if (!value) {
      TsLog.info(TAG, `updateDefaultDirWithColorRule, not match color rule`);
      return dir;
    }
    return String(value);
  }

  /**
   * 获取原始数据的来源
   * @param {string} descriptionPath - 描述路径，用于查找原始数据
   * @param {OriginType} defOrigin - 默认的原始数据类型，如果没有找到原始数据，则返回此默认值，默认值为预设的原始数据类型
   * @return {Promise<OriginType>} 返回一个Promise，其解析值为原始数据的类型
   */
  async getOrigin(descriptionValue: string, defOrigin: OriginType = ORIGIN_PRESET): Promise<OriginType> {
    let origin: number | string | object | undefined = ThemePackUtils.getDescription(descriptionValue, 'origin');
    return origin ? origin.toString() as OriginType : defOrigin;
  }
}

export function getThemePackParser(): PresetParser<ThemePackInfo> {
  return new ThemePackParser();
}

export async function getCustomThemePack(editorId: string): Promise<Nullable<ThemePackInfo>> {
  return await getThemePackParser().parse(TSPathUtils.getThemeCustomPackagePath(editorId));
}

/**
 * 定义主题类别的类型，解析theme/manifest.json
 */
export interface ThemeCategory {
  /**
   * 分类的名称，例如：theme_category_01（此为key名，value值在i18n目录下对应语言的配置文件内）
   */
  category: string;

  /**
   * 类别下的主题目录数组
   */
  dir: ThemeDir[];

  /**
   * 主题库排序
   */
  idxTe: number;
}

/**
 * 定义主题目录的类型
 */
export interface ThemeDir {
  /**
   * 主题包资源目录名称，eg：default、default_01
   */
  theme: string;

  /**
   * 主题资源id
   */
  theme_id: string;

  /**
   * 关联图标资源id
   */
  icon_id: string;

  /**
   * 关联的字体id
   */
  font_id: string;
}