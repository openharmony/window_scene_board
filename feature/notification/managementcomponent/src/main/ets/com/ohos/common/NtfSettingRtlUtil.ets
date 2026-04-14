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
 * RTL语言工具类，用于判断当前是否是RTL语言
 */
export class NtfSettingRtlUtil {
  /**
   * 获取系统语言是否是RTL语言
   *
   * @returns 系统语言是否是RTL语言
   */
  public static getSystemRTL(): boolean {
    let systemLanguage: string = i18n.System.getSystemLanguage();
    let isRTL: boolean = i18n.isRTL(systemLanguage);
    return isRTL;
  }
}