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

import { AiSuggestionConstants } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';

// 日志里面不需要打印的字段
const LOG_INTERCEPTION: string[] = ['icon', 'formWantInfo', 'recId', 'subRecId', 'columnStart',
  'rowStart', 'columnSpan', 'rowSpan', 'keyName', 'isUsed', 'itemType', 'rowsTemplate', 'columnsTemplate', 'sceneSpanX',
  'sceneSpanY', 'row', 'column', 'rankScore', 'appIconId', 'uid', 'appIndex', 'pic2x2Url', 'pic2x4Url', 'pic4x4Url',
  'picMinResId', 'moduleName', 'abilityName', 'isTransparent', 'multiLanguages', 'appName'];

// 不存数据库字段
const DB_INTERCEPTION: string[] = ['icon'];

/**
 * Json工具
 *
 * @since 2023-12-06
 */
export class JsonHelper {
  /**
   * 日志字段替换(替换不打印字段为undefined)
   *
   * @param key 字段
   * @param value 替换内容
   * @returns 替换后的内容
   */
  public static logReplacer(key: string, value: object): object | undefined {
    if (LOG_INTERCEPTION.indexOf(key) !== AiSuggestionConstants.INVALID_INDEX) {
      return undefined;
    }
    return value;
  }

  /**
   * 数据库字段替换(替换字段不存数据库)
   *
   * @param key 字段
   * @param value 替换内容
   * @returns 替换后的内容
   */
  public static dbReplacer(key: string, value: object): object | undefined {
    if (DB_INTERCEPTION.indexOf(key) !== AiSuggestionConstants.INVALID_INDEX) {
      return undefined;
    }
    return value;
  }
}