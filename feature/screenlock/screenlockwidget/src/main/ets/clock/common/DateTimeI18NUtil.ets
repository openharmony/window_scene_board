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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
// import { MemoryUtils } from '@ohos/windowscene';
import I18n from '@ohos.i18n';
import Intl from '@ohos.intl';

const TAG = 'DateTimeI18NUtil'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 简体中文语言标识
 */
const CHINESE: string = 'zh-Hans';

export class DateTimeI18NUtil {
  private static curSystemLanguage: string = I18n.System.getSystemLanguage();
  private static readonly ONE_DAY_TIMESTAMP: number = 86400000;
  // 一周7天
  private static readonly DAY_PER_WEEK: number = 7;
  private static weeks: string[];

  constructor() {
  }

  public static getDateStr(systemLanguage: string, 
    date?: Date): string {
    return DateTimeI18NUtil.DateFormatDefault(date, systemLanguage, { month: 'short', day: 'numeric' });
  }

  public static isChinese(systemLanguage: string = I18n.System.getSystemLanguage()): boolean {
    log.showInfo(`systemLanguage switch into ${systemLanguage}`)
    return systemLanguage.split('-')[0].toLocaleLowerCase() === 'zh';
  }

  /**
   * 判断当前系统语言是否属于艺术签名字体支持的语言，艺术签名字体仅支持中英文两种语言
   *
   * @returns true表示支持
   */
  public static isArtSupportLanguage(): boolean {
    return DateTimeI18NUtil.isZhOrEn(I18n.System.getSystemLanguage());
  }

  /**
   * 获取短格式的日期字符串
   *
   * @param systemLanguage 系统语言
   * @param date 日期
   * @returns 日期字符串，类似xx/xx
   */
  public static getBigDateStr(systemLanguage: string, date?: Date): string {
    let language: string = systemLanguage;
    // 非中英文的小语种不做翻译，统一按中文处理
    if (!DateTimeI18NUtil.isZhOrEn(systemLanguage)) {
      language = CHINESE;
    }
    return DateTimeI18NUtil.DateFormatDefault(date, language, { month: '2-digit', day: '2-digit' });
  }

  public static getDateWithWeekStr(systemLanguage: string, date?: Date): string {
    return DateTimeI18NUtil.DateFormatDefault(date, systemLanguage, {
      month: 'short',
      day: 'numeric',
      weekday: 'long'
    });
  }

  public static getWeekTitle(systemLanguage: string = I18n.System.getSystemLanguage(), 
    date: Date = new Date()): string[] {
    if (DateTimeI18NUtil.curSystemLanguage === systemLanguage && DateTimeI18NUtil.weeks !== undefined) {
      return DateTimeI18NUtil.weeks;
    }
    const weekDay = date.getDay(); // 返回一周（0~6）的某一天的数字。星期天为 0, 星期一为 1, 以此类推。
    const sundayTimestamp = date.getTime() - weekDay * DateTimeI18NUtil.ONE_DAY_TIMESTAMP;
    DateTimeI18NUtil.weeks = new Array(DateTimeI18NUtil.DAY_PER_WEEK).fill('').map((day: number, i): string => {
      const date = new Date(sundayTimestamp + i * DateTimeI18NUtil.ONE_DAY_TIMESTAMP);
      return DateTimeI18NUtil.DateFormatDefault(date, systemLanguage, { weekday: 'long' });
    });
    DateTimeI18NUtil.curSystemLanguage = systemLanguage;
    return DateTimeI18NUtil.weeks;
  }

  public static DateFormatDefault(date: Date = new Date(), systemLanguage: string = I18n.System.getSystemLanguage(), 
    opt: Intl.DateTimeOptions): string {
    const isChinese = DateTimeI18NUtil.isChinese(systemLanguage);
    if (isChinese) {
      return DateTimeI18NUtil.DateFormat(date, opt, systemLanguage);
    } else {
      if (opt?.weekday) {
        opt.weekday = 'short';
      }
      return DateTimeI18NUtil.DateFormat(date, opt, systemLanguage);
    }
  }

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

  private static isZhOrEn(systemLanguage: string) {
    let systemLanguageArray: string[] = systemLanguage?.split('-');
    if (!systemLanguageArray || systemLanguageArray.length < 1) {
      return false;
    }
    return systemLanguageArray[0].toLocaleLowerCase() === 'zh' || systemLanguageArray[0].toLocaleLowerCase() === 'en';
  }
}

export let dateTimeI18NUtil = SingletonHelper.getInstance(DateTimeI18NUtil, TAG);