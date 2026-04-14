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
import I18n from '@ohos.i18n';
import { CommonUtils } from '@ohos/basicutils';
// import { MemoryUtils } from '@ohos/windowscene';

/**
 * 时间工具
 *
 * @since 2022-12-12
 */
export class DateUtils {
  /**
   * 1秒钟
   */
  public static readonly SECOND_IN_MILLIS = 1000;

  /**
   * 1分钟
   */
  public static readonly MINUTE_IN_MILLIS = DateUtils.SECOND_IN_MILLIS * 60;

  /**
   * 1小时
   */
  public static readonly HOUR_IN_MILLIS = DateUtils.MINUTE_IN_MILLIS * 60;

  /**
   * 1天
   */
  public static readonly DAY_IN_MILLIS = DateUtils.HOUR_IN_MILLIS * 24;

  /**
   * 一周
   */
  public static readonly WEEK_IN_MILLIS = DateUtils.DAY_IN_MILLIS * 7;

  /**
   * 样式，短样式
   */
  public static readonly STYLE_SHORT = 'short';

  /**
   * 样式，长样式
   */
  public static readonly STYLE_LONG = 'long';

  /**
   * 样式，数字(非自动补0)
   */
  public static readonly STYLE_NUMERIC = 'numeric';

  /**
   * 样式，数字(自动补0)
   */
  public static readonly STYLE_2_DIGIT = '2-digit';

  /**
   * 解析本地时间
   *   24小时制时格式：00:00/09:01
   *   12小时制时格式：12:00/01:00
   *
   * @param time 时间
   * @returns 解析后的时间
   */
  public static parseLocaleTime(time: Date): string {
    const hour = DateUtils.getHour(time);
    const minute = String(time.getMinutes()).padStart(2, '0');
    return `${hour}:${minute}`;
  }

  private static getHour(time: Date): string {
    if (I18n.System.is24HourClock()) {
      return String(time.getHours()).padStart(2, '0');
    } else {
      const hour = time.getHours() % 12;
      // 长度小于2位时用0填补首位:1->01
      return String(hour === 0 ? 12 : hour).padStart(2, '0');
    }
  }

  /**
   * 在date基础上加上days天数
   *
   * @param date 基础日期
   * @param days 增加天数
   * @return 增加后的毫秒值
   */
  static plusDays(date: Date, days: number): number {
    let curTime = date.getTime();
    return curTime + (days * DateUtils.DAY_IN_MILLIS);
  }

  /**
   * 在date基础减去上days天数
   *
   * @param date 基础日期
   * @param days 减去天数
   * @return 减去后的毫秒值
   */
  static minusDays(date: Date, days: number): number {
    let curTime = date.getTime();
    return curTime - (days * DateUtils.DAY_IN_MILLIS);
  }

  /**
   * 在date基础上加上hours小时
   *
   * @param date 基础日期
   * @param hours 增加小时数
   * @return 增加后的毫秒值
   */
  static plusHours(date: Date, hours: number): number {
    let curTime = date.getTime();
    return curTime + (hours * DateUtils.HOUR_IN_MILLIS);
  }

  /**
   * 在date基础减去上hours小时
   *
   * @param date 基础日期
   * @param hours 减去小时数
   * @return 减去后的毫秒值
   */
  static minusHours(date: Date, hours: number): number {
    let curTime = date.getTime();
    return curTime - (hours * DateUtils.HOUR_IN_MILLIS);
  }

  /**
   * 获取当前local下的日期格式化工具
   *
   * @param dateStyle 日期样式
   * @param date 日期
   * @returns 时间转换后的字符串
   */
  static formatLocalDate(date: Date, dateStyle: string): string {
    let local = I18n.System.getSystemLanguage();
    let formatOptions: Intl.DateTimeOptions = {
      locale: local,
      dateStyle: dateStyle,
      hour12: !I18n.System.is24HourClock(),
      timeZone: I18n.getTimeZone()?.getID(),
    };
    return DateUtils.formatTimeAndRelease(local, formatOptions, date);
  }

  /**
   * 获取当前local下的日期格式化工具，不显示 年
   *
   * @param date 日期
   * @returns 时间转换后的字符串
   */
  static formatDateNoYear(date: Date): string {
    let local = I18n.System.getSystemLanguage();
    let formatOptions: Intl.DateTimeOptions = {
      locale: local,
      month: DateUtils.STYLE_LONG,
      day: DateUtils.STYLE_NUMERIC,
      weekday: DateUtils.STYLE_LONG,
      hour12: !I18n.System.is24HourClock(),
      timeZone: I18n.getTimeZone()?.getID(),
    };
    return DateUtils.formatTimeAndRelease(local, formatOptions, date);
  }

  /**
   * 获取当前local下的日期格式化工具，不显示 年 星期
   *
   * @param date 日期
   * @returns 时间转换后的日期 X月Y日
   */
  static formatDateNoWeek(date: Date): string {
    let local = I18n.System.getSystemLanguage();
    let formatOptions: Intl.DateTimeOptions = {
      locale: local,
      month: DateUtils.STYLE_LONG,
      day: DateUtils.STYLE_NUMERIC,
      hour12: !I18n.System.is24HourClock(),
      timeZone: I18n.getTimeZone()?.getID(),
    };
    return DateUtils.formatTimeAndRelease(local, formatOptions, date);
  }

  /**
   * 获取当前local下的日期格式化工具，不显示年月日
   *
   * @param date 日期
   * @returns 时间转换后的星期
   */
  static formatDateNoMonthDay(date: Date): string {
    let local = I18n.System.getSystemLanguage();
    let formatOptions: Intl.DateTimeOptions = {
      locale: local,
      weekday: DateUtils.STYLE_LONG,
      hour12: !I18n.System.is24HourClock(),
      timeZone: I18n.getTimeZone()?.getID(),
    };
    return DateUtils.formatTimeAndRelease(local, formatOptions, date);
  }

  /**
   * 获取当前local下的时间格式化工具
   *
   * @param timeStyle 时间样式
   * @param date 日期
   * @returns 时间转换后的字符串
   */
  static formatLocalTime(date: Date, timeStyle?: string): string {
    let local = I18n.System.getSystemLanguage();

    // timeStyle会覆盖hour/minute等，分开使用
    let formatOptions: Intl.DateTimeOptions | undefined = undefined;
    if (CommonUtils.isInvalid(timeStyle)) {
      formatOptions = {
        locale: local,
        // 24小时制下会自动补0,12小时制下会am/pm
        hour: DateUtils.STYLE_2_DIGIT,
        minute: DateUtils.STYLE_2_DIGIT,
        hour12: !I18n.System.is24HourClock(),
        timeZone: I18n.getTimeZone()?.getID(),
      };
    } else {
      formatOptions = {
        locale: local,
        timeStyle: timeStyle,
        hour12: !I18n.System.is24HourClock(),
        timeZone: I18n.getTimeZone()?.getID(),
      };
    }
    return DateUtils.formatTimeAndRelease(local, formatOptions, date);
  }

  /**
   * 获取时间文本，去掉AM PM
   *
   * @param oriTime 原时间字串
   * @return 去掉后的时间字串
   */
  static getTimeWithoutAmPm(oriTime: string): string {
    if (CommonUtils.isEmpty(oriTime)) {
      return '';
    }
    let timeLen = oriTime.length;
    let digitStart = DateUtils.findFirstDigit(oriTime);
    let digitEnd = DateUtils.findLastDigit(oriTime) + 1;
    // 截取字串
    if (digitEnd > digitStart && (digitEnd - digitStart) < timeLen) {
      return oriTime.substring(digitStart, digitEnd);
    }
    return oriTime;
  }

  /**
   * 提供时间转换的能力，且在完成时间转换后自动释放format占用的内存
   *
   * @param local 语言
   * @param opt format配置信息
   * @param date 日期
   * @returns 时间转换后的字符串
   */
  private static formatTimeAndRelease(local: string, opt: Intl.DateTimeOptions, date: Date): string {
    let formatter: Intl.DateTimeFormat = new Intl.DateTimeFormat(local, opt);
    let result: string = formatter.format(date);

    // DateTimeFormat在native侧存在一些内存占用，需要在format实例使用完后手动调用removeNapiWrap触发此部分native内存回收
    // MemoryUtils.removeNapiWrap(formatter, false);
    return result;
  }

  /**
   * 查找时间字串中第一个数字
   *
   * @param oriTime 时间字串
   * @return 第一个数字索引
   */
  private static findFirstDigit(oriTime: string): number {
    let len = oriTime.length;
    for (let i = 0; i < len; i++) {
      let ch = oriTime.charAt(i);
      if (I18n.Unicode.isDigit(ch)) {
        return i;
      }
    }
    return -1;
  }

  /**
   * 查找时间字串中最后一个数字
   *
   * @param oriTime 时间字串
   * @return 最后一个数字索引
   */
  private static findLastDigit(oriTime: string): number {
    let len = oriTime.length;
    let index = -1;
    for (let i = 0; i < len; i++) {
      let ch = oriTime.charAt(i);
      if (I18n.Unicode.isDigit(ch)) {
        index = i;
      }
    }
    return index;
  }
}