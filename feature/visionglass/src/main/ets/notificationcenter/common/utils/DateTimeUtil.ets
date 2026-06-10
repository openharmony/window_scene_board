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

import I18n from '@ohos.i18n';
import Intl from '@ohos.intl';
import { MemoryUtils } from '@ohos/windowscene';

/**
 * 日期时间工具类
 */
export class DateTimeUtil {
  /**
   * 一天开始时间的小时数、分钟、秒数以及毫秒数的最小值
   */
  public static readonly DEFAULT_CALENDAR_TIME: number = 0;
  /**
   * 天的结束时间 23:59:59 的小时数
   */
  public static readonly DAY_END_TIME_HOUR: number = 23;
  /**
   * 天的结束时间 23:59:59 的分钟/秒钟数
   */
  public static readonly DAY_END_TIME_MINUTE_OR_SECOND: number = 59;
  /**
   * 天的结束时间 23:59:59 的毫秒数
   */
  public static readonly DAY_END_TIME_MILLISECOND: number = 999;
  /**
   * Calendar字段值：year
   */
  public static readonly CALENDAR_FIELD_NAME_YEAR: string = 'year';
  /**
   * Calendar字段值：month
   */
  public static readonly CALENDAR_FIELD_NAME_MONTH: string = 'month';
  /**
   * Calendar字段值：day_of_week_in_month
   */
  public static readonly CALENDAR_FIELD_NAME_DAY: string = 'day_of_week_in_month';
  /**
   * Calendar字段值：hour_of_day
   */
  public static readonly CALENDAR_FIELD_NAME_HOUR: string = 'hour_of_day';
  /**
   * Calendar字段值：millisecond
   */
  public static readonly CALENDAR_FIELD_NAME_MILLISECOND: string = 'millisecond';
  /**
   * Calendar字段值：week_of_year
   */
  public static readonly CALENDAR_FIELD_NAME_WEEK: string = 'week_of_year';
  /**
   * 格式化显示时间（12小时制,10:50 上午/下午）
   */
  public static readonly FORMAT_TIME_TWELVE_HOUR: string = 'hh:mm aa';
  /**
   * 格式化显示时间（12小时制,10:50）
   */
  public static readonly FORMAT_TIME_TWELVE_HOUR_NO_MERIDIEM: string = 'hh:mm';
  /**
   * 样式，长样式
   */
  public static readonly STYLE_LONG = 'long';
  /**
   * 样式，数字(非自动补0)
   */
  public static readonly STYLE_NUMERIC = 'numeric';

  /**
   * 根据传入的毫秒值和格式获取日期时间
   *
   * @param millisTime 以UTC毫秒为单位的时间毫秒值（如Date.now() 获取的就是UTC值）
   * @param format 时间日期格式化对象
   * @return 返回格式化日期(详细参考Intl.DateTimeOptions源码)
   */
  public static getDateTimeByFormat(millisTime: number, format: Intl.DateTimeOptions): string {
    let dateFormat = new Intl.DateTimeFormat(I18n.System.getSystemLocale(), format);
    return dateFormat.format(new Date(millisTime));
  }

  /**
   * 比较两个时间是否在同一个小时内
   *
   * @param startTime 需要比对时间点的毫秒数，如：1585089660000
   * @param endTime 需要比对时间点的毫秒数，如：1585107072859
   * @return true 表示在同一个小时 false 不在同一个小时内
   */
  public static isSameNearHour(startTime: number, endTime: number): boolean {
    let isSameYear = DateTimeUtil.getDigitYear(startTime) === DateTimeUtil.getDigitYear(endTime);
    if (!isSameYear) {
      return false;
    }
    let isSameMonth = DateTimeUtil.getDigitMonth(startTime) === DateTimeUtil.getDigitMonth(endTime);
    if (!isSameMonth) {
      return false;
    }
    let isSameDay = DateTimeUtil.getDigitDay(startTime) === DateTimeUtil.getDigitDay(endTime);
    if (!isSameDay) {
      return false;
    }
    let isSameHour = DateTimeUtil.getDigitHour(startTime) === DateTimeUtil.getDigitHour(endTime);
    return isSameHour;
  }

  /**
   * 获取传入时间的数字年
   *
   * @param time 传入的时间的毫秒数，如：1585107072859
   * @param calendar 日历对象
   * @return 数字形式的年:如1970
   */
  public static getDigitYear(time: number): number {
    let calendar: I18n.Calendar = DateTimeUtil.getCalendar();
    calendar.setTime(time);
    return calendar.get(DateTimeUtil.CALENDAR_FIELD_NAME_YEAR);
  }

  /**
   * 获取传入时间的数字月
   *
   * @param time 传入的时间的毫秒数，如：1585107072859
   * @param calendar 日历对象
   * @return 数字形式的月（1~12）
   */
  public static getDigitMonth(time: number): number {
    let calendar: I18n.Calendar = DateTimeUtil.getCalendar();
    calendar.setTime(time);
    return calendar.get(DateTimeUtil.CALENDAR_FIELD_NAME_MONTH);
  }

  /**
   * 获取传入时间的数字天
   *
   * @param time 传入的时间的毫秒数，如：1585107072859
   * @param calendar 日历对象
   * @return 数字形式的天（1~31）
   */
  public static getDigitDay(time: number): number {
    let calendar: I18n.Calendar = DateTimeUtil.getCalendar();
    calendar.setTime(time);
    return calendar.get(DateTimeUtil.CALENDAR_FIELD_NAME_DAY);
  }

  /**
   * 获取传入时间的数字形式的小时数
   *
   * @param time 传入的时间的毫秒数，如：1585107072859
   * @param calendar 日历对象
   * @return 数字形式的小时:0~23
   */
  public static getDigitHour(time: number): number {
    let calendar: I18n.Calendar = DateTimeUtil.getCalendar();
    calendar.setTime(time);
    return calendar.get(DateTimeUtil.CALENDAR_FIELD_NAME_HOUR);
  }

  /**
   * 检测时间是否和基准时间在同一天
   *
   * @param time 需要检测的时间毫秒数，如：1585107072859
   * @param compareTime 基准时间的毫秒数，如：1585107072859
   * @return true 在当前天 false 不在当前天
   */
  public static isSameDay(time: number, compareTime: number): boolean {
    const curDay = new Date(time);
    const preDay = new Date(compareTime);
    return (curDay.getDate()) === preDay.getDate() &&
      curDay.getMonth() === preDay.getMonth() && curDay.getFullYear() === preDay.getFullYear();
  }

  /**
   * 检测时间是否和基准时间在同一天
   *
   * @param time 需要检测的时间毫秒数，如：1585107072859
   * @param compareTime 基准时间的毫秒数，如：1585107072859
   * @param calendar 日历对象
   * @return true 在当前天 false 不在当前天
   */
  public static isSameDayFormCalendar(time: number, compareTime: number): boolean {
    let startTime = DateTimeUtil.getDayStartTime(compareTime);
    let endTime = DateTimeUtil.getDayEndTime(compareTime);
    return (time >= startTime) && (time <= endTime);
  }

  /**
   * 获取传入时间的凌晨的时间
   *
   * @param time 传入的毫秒数,如：1585107072859
   * @param calendar 日历对象
   * @return 凌晨时间:单位是毫秒,如：1585107072859
   */
  public static getDayStartTime(time: number): number {
    let calendar: I18n.Calendar = DateTimeUtil.getCalendar();
    // 设置时间为 0点0分0秒0毫秒;
    calendar.setTime(new Date(time).setHours(DateTimeUtil.DEFAULT_CALENDAR_TIME, DateTimeUtil.DEFAULT_CALENDAR_TIME,
      DateTimeUtil.DEFAULT_CALENDAR_TIME, DateTimeUtil.DEFAULT_CALENDAR_TIME));
    return calendar.get(DateTimeUtil.CALENDAR_FIELD_NAME_MILLISECOND);
  }

  /**
   * 获取传入时间的23:59:59的时间
   *
   * @param time 传入的毫秒数,如：1585107072859
   * @param calendar 日历对象
   * @return 凌晨时间:单位是毫秒,如：1585107072859
   */
  public static getDayEndTime(time: number): number {
    let calendar: I18n.Calendar = DateTimeUtil.getCalendar();
    // 设置时间为 23:59:59.999;
    calendar.setTime(new Date(time)
      .setHours(DateTimeUtil.DAY_END_TIME_HOUR, DateTimeUtil.DAY_END_TIME_MINUTE_OR_SECOND,
        DateTimeUtil.DAY_END_TIME_MINUTE_OR_SECOND, DateTimeUtil.DAY_END_TIME_MILLISECOND));
    return calendar.get(DateTimeUtil.CALENDAR_FIELD_NAME_MILLISECOND);
  }

  /**
   * 检测时间是否和基准时间在同一周
   *
   * @param time 需要检测的时间毫秒数，如：1585107072859
   * @param compareTime 基准时间的毫秒数，如：1585107072859
   * @return true 在同一周 false 不在同一周
   */
  public static isSameWeek(time: number, compareTime: number): boolean {
    let calendar = DateTimeUtil.getCalendar();
    let compareCalendar = DateTimeUtil.getCalendar();
    calendar.setTime(time);
    compareCalendar.setTime(compareTime);
    return (calendar.get(DateTimeUtil.CALENDAR_FIELD_NAME_YEAR) ===
    compareCalendar.get(DateTimeUtil.CALENDAR_FIELD_NAME_YEAR)) &&
      (calendar.get(DateTimeUtil.CALENDAR_FIELD_NAME_WEEK) ===
      compareCalendar.get(DateTimeUtil.CALENDAR_FIELD_NAME_WEEK));
  }

  /**
   * 比较两个时间是否在同一年
   *
   * @param time 需要比对时间点的毫秒数
   * @param compareTime 需要比对时间点的毫秒数
   * @return true 代表同一年， false代表不在同一年
   */
  public static isSameNearYear(time: number, compareTime: number): boolean {
    return DateTimeUtil.getDigitYear(time) === DateTimeUtil.getDigitYear(compareTime);
  }

  /**
   * 传入的时间是否为白天
   *
   * @param currentTime 当前时间
   * @param sunRise 日出时间
   * @param sunSet 日落时间
   * @return true 白天 false 夜晚
   */
  public static isDay(currentTime: number, sunRise: number, sunSet: number): boolean {
    return (currentTime > sunRise) && (currentTime <= sunSet);
  }

  private static getCalendar(): I18n.Calendar {
    let locale = I18n.System.getSystemLocale();
    let language = I18n.System.getSystemLanguage();
    return I18n.getCalendar(locale, language);
  }

  private static formatTimeAndRelease(local: string, opt: Intl.DateTimeOptions, date: Date): string {
    let formatter: Intl.DateTimeFormat = new Intl.DateTimeFormat(local, opt);
    let result: string = formatter.format(date);
    // DateTimeFormat在native侧存在一些内存占用，需要在format实例使用完后手动调用removeNapiWrap触发此部分native内存回收
    MemoryUtils.removeNapiWrap(formatter, false);
    return result;
  }

  public static formatDateNoWeek(date: Date): string {
    let local = I18n.System.getSystemLanguage();
    let formatOptions: Intl.DateTimeOptions = {
      locale: local,
      month: DateTimeUtil.STYLE_LONG,
      day: DateTimeUtil.STYLE_NUMERIC,
      hour12: !I18n.System.is24HourClock(),
      timeZone: I18n.getTimeZone()?.getID(),
    };
    return DateTimeUtil.formatTimeAndRelease(local, formatOptions, date);
  }

  public static getCurrentDate(): string {
    let current = new Date();
    let result = DateTimeUtil.formatDateNoWeek(current);
    // 一天后更新
    current.setHours(0, 0, 0, 0);
    current.setDate(current.getDate() + 1);
    return result;
  }

  public static formatDateNoMonthDay(date: Date): string {
    let local = I18n.System.getSystemLanguage();
    let formatOptions: Intl.DateTimeOptions = {
      locale: local,
      weekday: DateTimeUtil.STYLE_LONG,
      hour12: !I18n.System.is24HourClock(),
      timeZone: I18n.getTimeZone()?.getID(),
    };
    return DateTimeUtil.formatTimeAndRelease(local, formatOptions, date);
  }
}