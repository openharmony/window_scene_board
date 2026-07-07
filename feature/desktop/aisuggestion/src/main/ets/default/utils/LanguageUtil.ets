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
import intl from '@ohos.intl';
import { LogDomain, LogHelper, } from '@ohos/basicutils';

const TAG: string = 'LanguageUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

export class LanguageUtil {
  /**
   * 系统目前默认支持的5种语言
   */
  public static readonly SUPPORT_MULTI_LANGUAGES: string[] = ['zh_HK', 'en_US', 'zh_TW', 'bo_CN', 'ug_CN'];
  /**
   * 默认语言：中文_中国
   */
  public static readonly DEFAULT_CHINESE_CN: string = 'zh_CN';
  /**
   * 中文_香港
   */
  public static readonly CHINESE_HK: string = 'zh_HK';
  /**
   * 中文_台湾
   */
  public static readonly CHINESE_TW: string = 'zh_TW';
  /**
   * 繁体中文
   */
  public static readonly TRADITIONAL_CHINESE: string = 'zh-Hant';
  /**
   * 简体中文
   */
  public static readonly SIMPLIFIED_CHINESE: string = 'zh-Hans';
  /**
   * 地区：香港
   */
  public static readonly REGION_HK: string = 'HK';
  /**
   * 默认语言
   */
  public static readonly DEFAULT_LANGUAGE: string = 'en_Us';

  /**
   * 获取当前系统语言对应的多语言，比如切成en_TW会被转换为en_US,因为配置
   * 文件里面英文只有en_US.其他的多语言类似处理。
   *
   * @returns 多语言能识别的语言
   */
  public static getCurrentLanguage(): string {
    const deviceLanguage = LanguageUtil.getDeviceLanguages(); // 设备语音
    const systemLanguage = LanguageUtil.getSystemLanguage(); // 系统语言
    if (systemLanguage?.includes(LanguageUtil.SIMPLIFIED_CHINESE)) {
      return LanguageUtil.DEFAULT_CHINESE_CN;
    }
    const languageRegions: string[] = deviceLanguage?.split('_');
    if (systemLanguage?.includes(LanguageUtil.TRADITIONAL_CHINESE)) {
      if (languageRegions?.length > 1 && languageRegions?.[1] === LanguageUtil.REGION_HK) {
        return LanguageUtil.CHINESE_HK;
      }
      return LanguageUtil.CHINESE_TW;
    }
    if (LanguageUtil.SUPPORT_MULTI_LANGUAGES.includes(deviceLanguage)) {
      return deviceLanguage;
    }
    const matchedLanguage =
      LanguageUtil.SUPPORT_MULTI_LANGUAGES.filter(language => language.includes(languageRegions?.[0]))?.[0];
    return matchedLanguage ?? LanguageUtil.DEFAULT_CHINESE_CN;
  }

  /**
   * 获取设备语言类型
   *
   * @returns 设备语言类型，默认zh_CN
   */
  public static getDeviceLanguages(): string {
    const locale = new intl.Locale(i18n.System.getSystemLanguage());
    return locale.language + '_' + i18n.System.getSystemRegion();
  }

  /**
   * 获取设备当前使用的语言
   *
   * @description 异常时返回简体中文
   * @return TerminalUtil.SYS_LANG_X, 参考值: "en-Latn-US", "zh-Hans", "zh-Hant", "ug", "bo"
   */
  public static getSystemLanguage(): string {
    try {
      return i18n.System.getSystemLanguage();
    } catch (error) {
      log.showError(`getSystemLanguage error`, error);
      return LanguageUtil.SIMPLIFIED_CHINESE;
    }
  }
}