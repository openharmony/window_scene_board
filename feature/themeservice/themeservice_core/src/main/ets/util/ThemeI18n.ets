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

import i18n from '@ohos.i18n';
import { FileUtil, Singleton, StringUtils, TsLog } from '@ohos/themeservicebase';

const TAG: string = 'ThemeI18n';
const I18N_KEY_PREFIX: string = '$t:';
const I18N_DIR: string = 'i18n';
const I18N_BASE: string = 'base';
const I18N_EN: string = 'en';

/**
 * 全球化工具类
 */
export class ThemeI18n {
  private static sInstance: Singleton<ThemeI18n> = new Singleton<ThemeI18n>(() => new ThemeI18n);
  private i18nGlobal: Map<string, Map<string, string>> = new Map();
  private locale: string = i18n.System.getSystemLocale();

  public static getInstance(): ThemeI18n {
    return ThemeI18n.sInstance.get();
  }

  /**
   * 根据KEY获取国际化语言值（非主题包内）
   *
   * @param source 原始关键字
   * @param themeDir i18n目录路径
   * @returns 国际化后的文字
   */
  public async getI18nGlobal(source: string, themeDir: string): Promise<string> {
    // 规范要求，国际化的文字全部以$t:开头
    if (!source.startsWith(I18N_KEY_PREFIX)) {
      return source;
    }
    // 按照优先级，依次搜索主题包i18n目录下的国际化json文件
    try {
      if (!await this.initI18nMap(themeDir)) {
        TsLog.info(TAG, 'i18n mismatched');
      }
    } catch (err) {
      TsLog.error(TAG, `initI18nMap failed with error message: ${err?.message}, error code: ${err?.code}`);
    }
    return this.i18nGlobal.get(themeDir)?.get(source.substring(I18N_KEY_PREFIX.length)) ??
    source.substring(I18N_KEY_PREFIX.length);
  }

  /**
   * 按照优先级，依次搜索主题包i18n目录下的国际化json文件，转成map
   *
   * @param themeDir i18n目录
   * @returns 初始化是否成功
   */
  private async initI18nMap(themeDir: string): Promise<boolean> {
    let systemLocale: string = i18n.System.getSystemLocale();
    if (this.locale !== systemLocale) {
      this.i18nGlobal.clear();
    }
    if (this.i18nGlobal.has(themeDir)) {
      return true;
    }
    this.locale = systemLocale;
    let systemLanguage: string = i18n.System.getSystemLanguage();
    let region: string = i18n.System.getSystemRegion();

    // 依次按照 zh-Hans-CN、zh-Hans、zh-CN、zh、base(兜底) 优先级匹配
    let baseLanguage: string = systemLanguage.substring(0, systemLanguage.indexOf('-'));
    let languageList: string[] = [systemLocale, systemLanguage, baseLanguage + '-' + region, baseLanguage, I18N_EN,
      I18N_BASE];
    for (let language of languageList) {
      if (await this.initI18nMapByLan(themeDir, language)) {
        TsLog.info(TAG, `initI18nMapByLan success by language: ${language}`);
        return true;
      }
    }
    return false;
  }

  private async initI18nMapByLan(themeDir: string, language: string): Promise<boolean> {
    let filePath: string = `${themeDir}/${I18N_DIR}/${language}.json`;
    if (!FileUtil.isFileExists(filePath)) {
      TsLog.warning(TAG, `language json not exists.`);
      return false;
    }

    const content: string = await FileUtil.readFileContent(filePath);
    if (StringUtils.isEmpty(content)) {
      TsLog.error(TAG, 'error content');
      return false;
    }

    let descList: Map<string, string> = new Map();
    let json: object;
    try {
      json = JSON.parse(content);
    } catch (error) {
      TsLog.error(TAG, `parse content failed`, error);
      return false;
    }
    let jsonKeys: string[] = Object.keys(json);
    for (let key of jsonKeys) {
      descList.set(key, json[key]);
    }
    this.i18nGlobal.set(themeDir, descList);
    return true;
  }

  /**
   * 读取主题包i18n目录下的国际化json文件，读取搜索词全注入
   *
   * @param themeDir i18n目录
   * @param themeSearchItem 搜索项key数组
   * @returns 初始化是否成功
   */
  public async getI18nAlias(themeDir: string, themeSearchItem: string[]): Promise<string> {
    let aliasSet: Set<string> = new Set();
    const i18nFiles: string[] = await FileUtil.listFiles(themeDir);
    for (const filePath of i18nFiles) {
      const content: string = await FileUtil.readFileContent(filePath);
      if (StringUtils.isEmpty(content)) {
        TsLog.warning(TAG, `read file failed, file path: ${filePath}`);
        continue;
      }
      let json: object;
      try {
        json = JSON.parse(content);
      } catch (error) {
        TsLog.error(TAG, `parse content failed`, error);
        continue;
      }
      for (const item of themeSearchItem) {
        try {
          let value: string = json[item.substring(I18N_KEY_PREFIX.length)] ?? '';
          if (!StringUtils.isEmpty(value)) {
            aliasSet.add(value);
          }
        } catch (error) {
          TsLog.warning(TAG, `read item failed, item: ${item}`)
          continue;
        }
      }
    }
    let alias: string = Array.from(aliasSet).join('|');
    return alias;
  }
};