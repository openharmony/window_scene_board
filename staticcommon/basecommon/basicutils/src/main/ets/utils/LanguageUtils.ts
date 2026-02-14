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

import { i18n } from '@kit.LocalizationKit';

/**
 * 语言工具类
 */
export class LanguageUtils {
  public static readonly UG: string = 'ug';
  public static readonly UG_CN: string = 'ug-CN';

  /**
   * 是否为镜像语言
   * @param language
   * @returns
   */
  public static isMirrorLanguage(): boolean {
    let language = AppStorage.get<string>('systemLanguage');
    return i18n.isRTL(language);
  }

  /**
   * 判断是否是维语
   *
   * @returns
   */
  public static isUgLanguage(): boolean {
    let language: string = i18n.System.getSystemLanguage();
    return language === LanguageUtils.UG || language === LanguageUtils.UG_CN;
  }
}