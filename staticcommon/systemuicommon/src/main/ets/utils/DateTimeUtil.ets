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

import Intl from '@ohos.intl';
import { LogDomain, LogHelper } from '@ohos/basicutils';
// import { MemoryUtils } from '@ohos/windowscene';

const TAG = 'SysUI_DateTimeUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/*
 * 日期时间工具类
 */
export class DateTimeUtil {

  /**
   * 获取yyyy/mm/dd格式日期字符串
   * @param Date 对象
   * @param 系统语言
   * @returns 返回对应的 dateString 日期字符串
   */
  public static formatDateToYYYYMMDD(systemLanguage: string, date: Date): string {
    return DateTimeUtil.DateFormat(date, { year: 'numeric', month: '2-digit', day: '2-digit' }, systemLanguage);
  }

  /**
   * 日期对象转为指定格式字符串
   * @param Date 对象
   * @param 系统语言
   * @param 格式化选项
   * @returns 返回对应的 dateString 日期字符串
   */
  public static DateFormat(date: Date, opt: Intl.DateTimeOptions, systemLanguage: string): string {
    const locale: Intl.Locale | undefined = new Intl.Locale(systemLanguage);
    if (!locale) {
      return '';
    }
    const dateFormat: Intl.DateTimeFormat = new Intl.DateTimeFormat(locale?.toString(), opt);
    const dateStr: string = dateFormat.format(date);
    // 存在内存泄漏，需要手动释放
    // MemoryUtils.removeNapiWrap(dateFormat, false);
    return dateStr;
  }
}
