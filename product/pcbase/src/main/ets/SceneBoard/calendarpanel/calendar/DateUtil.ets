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


export const HOURS_PER_DAY = 24;

// 一周7天
export const DAY_PER_WEEK: number = 7;

// 一年12个月
export const MONTH_PER_YEAR: number = 12;

// 一小时分钟数
export const MINUTES_PER_HOUR = 60;

// 一天分钟数
export const MINUTES_PER_DAY = MINUTES_PER_HOUR * HOURS_PER_DAY;

// 一分钟秒数
export const SECONDS_PER_MINUTE = 60;

// 一秒毫秒数
export const MILLS_PER_SECOND = 1000;

// 一分钟毫秒数
export const MILLS_PER_MINUTE = MILLS_PER_SECOND * SECONDS_PER_MINUTE;

// 一小时毫秒数
export const MILLS_PER_HOUR = MILLS_PER_MINUTE * MINUTES_PER_HOUR;

// 一天毫秒数
export const MILLS_PER_DAY = MILLS_PER_HOUR * HOURS_PER_DAY;

// 30天毫秒数
export const MILLS_THIRTY_DAYS = MILLS_PER_DAY * 30;

// 365天的毫秒数
export const MILLS_ONE_YEAR = MILLS_PER_DAY * 365;

// 一周毫秒数
export const MILLS_PER_WEEK = MILLS_PER_DAY * DAY_PER_WEEK;

/**
 * 日期工具类
 *
 * @since 2022-12-19
 */
export class DateUtil {
  // 年份月数
  private static readonly MONTH_PER_YEAR: number = 12;
  private static readonly MAX_DAY_PER_MONTH: number = 31;
  private static readonly MONTH_UPPER_INDEX: number = 11;
  private static readonly WEEKDAYS = 7;
  private static readonly OLD_CALENDAR_END_YEAR = 1582;
  private static readonly OLD_CALENDAR_END_MONTH = 10;
  private static readonly LOST_DAY_IN_1582 = 10;
  private static readonly FEBRUARY = 2;
  private static readonly ONE_CENTURY = 100;
  private static readonly FOUR_CENTURY = 400;
  // 一天的毫秒数 24 * 60 * 60 * 1000
  static readonly ONE_DAY_TIMESTAMP:number = 86400000;

  // 年份下限值：公元1年
  static readonly YEAR_LOWER_LIMIT: number = 1;

  // 年份上限值：公元5000年
  static readonly YEAR_UPPER_LIMIT: number = 5000;

  // Julian day
  static readonly JULIAN_DAY: number = 0.5000115740;

  // 月份下限值：公元1年1月
  static readonly MONTH_LOWER_LIMIT: number = DateUtil.YEAR_LOWER_LIMIT * DateUtil.MONTH_PER_YEAR;

  // 月份上限值：公元5000年12月
  static readonly MONTH_UPPER_LIMIT: number = DateUtil.YEAR_UPPER_LIMIT * DateUtil.MONTH_PER_YEAR +
    DateUtil.MONTH_UPPER_INDEX;

  // days one year
  private static readonly DAYS_PER_YEAR: number = 372;

  // days one month
  private static readonly DAYS_PER_MONTH: number = 31;

  // 100 multi
  private static readonly YEAR_MULTI_100: number = 100;

  // 400 multi
  private static readonly YEAR_MULTI_400: number = 400;

  // diff
  private static readonly TOTAL_DIFF: number = 2;

  // least days
  private static readonly LEAST_DAY: number = 588829;

  // days multi
  private static readonly DAYS_MULTI: number = 365.25;

  // years multi
  private static readonly YEARS_MULTI: number = 4716;

  // diff 1
  private static readonly DIFF_1: number = 0.01;

  // diff 1524
  private static readonly DIFF_1524: number = 1524.5;

  // month multi
  private static readonly MONTH_MULTI: number = 30.60001;

  // 一周7天
  static readonly DAY_PER_WEEK: number = 7;

  /**
   * 根据偏移量计算年份月份信息，offset < 0表示前offset个月份，offset > 0表示后offset个月份
   * 公元1年1月往前展示公元5000年12月；公元5000年12月往后展示公元1年1月
   *
   * @param monthInfo 基准年份月份信息，基于此信息进行偏移计算
   * @param offset 月份偏移量
   * @return 计算偏移量后的年份月份信息，偏移后取当月1日的时间戳
   */
  static getOffsetMonthInfo(monthInfo: MonthInfo, offset: number): MonthInfo {
    const MONTH_PEER_YEAR = 12;
    const year = monthInfo.year;
    const month = monthInfo.month;
    let sum = year * DateUtil.MONTH_PER_YEAR + month + offset;

    sum = DateUtil.countOffsetDepLimit(sum, DateUtil.MONTH_LOWER_LIMIT, DateUtil.MONTH_UPPER_LIMIT);

    const result: MonthInfo = {
      year: 0,
      month: 0
    };
    result.year = Math.floor(sum / MONTH_PEER_YEAR);
    result.month = sum % DateUtil.MONTH_PER_YEAR;
    return result;
  }

  /**
   * 根据边界值修正偏移量
   *
   * @param val 待修正的值
   * @param lowerLimit 下限值
   * @param upperLimit 上限值
   */
  static countOffsetDepLimit(val: number, lowerLimit: number, upperLimit: number): number {
    let result = val;
    if (result < lowerLimit) {
      result = upperLimit + result - lowerLimit + 1;
    } else if (result > upperLimit) {
      result = lowerLimit + result - upperLimit - 1;
    }
    return result;
  }

  /**
   * 日期转儒略日
   * @param year 年
   * @param month 月
   * @param monthDay 日
   */
  static date2julianDay(year: number, month: number, monthDay: number): number {
    let diff: number = 0;
    let mMonth = month;
    let mYear = year;
    const february = 2;
    if (mMonth <= february) {
      mMonth += DateUtil.MONTH_PER_YEAR;
      mYear -= 1;
    }
    if (mYear * DateUtil.DAYS_PER_YEAR + mMonth * DateUtil.DAYS_PER_MONTH + monthDay >= DateUtil.LEAST_DAY) {
      diff = Math.floor(mYear / DateUtil.YEAR_MULTI_100);
      diff = Math.floor(DateUtil.TOTAL_DIFF - diff + mYear / DateUtil.YEAR_MULTI_400);
    }
    let dd: number = monthDay + DateUtil.JULIAN_DAY;
    return Math.floor(Math.floor(DateUtil.DAYS_MULTI * (mYear + DateUtil.YEARS_MULTI) + DateUtil.DIFF_1) +
    Math.floor(DateUtil.MONTH_MULTI * (mMonth + 1)) + dd + diff - DateUtil.DIFF_1524);
  }

  /**
   * 取余获取时间戳所表示当天的0点0分0秒时间戳
   *
   * @param dateStamp 时间戳
   */
  static getZeroTimeStamp(dateStamp?: number): number {
    let date = new Date();
    if (dateStamp !== null && dateStamp !== undefined) {
      date = new Date(dateStamp);
    }
    date.setHours(0, 0, 0, 0);

    return date.getTime();
  }

  /**
   * 获取每月1日是星期几。0为星期天
   *
   * 由于1582年之前使用旧历法，旧历法缝4必闰，即在公元100,200,300,500年等也是闰年，导致与新历法多了很多日期。
   * 对于1582年的之前的日期，需要将这些多出来的2月29都加入进去。
   * @param year 自然年
   * @param month 自然月
   * @param curDate 月份对象
   * @param monthCount 每月多少天
   */
  static getWeekOfStart(year: number, month: number, curDate: Date): number {
    let week = curDate.getDay();
    if (year < DateUtil.OLD_CALENDAR_END_YEAR ||
      (year === DateUtil.OLD_CALENDAR_END_YEAR && month <= DateUtil.OLD_CALENDAR_END_MONTH)) {
      let count = 0; // 从1582年往前推，旧历法中闰年 与 新历法闰年差异多出来的天数
      //从当年到1582年之间有个多少个整百年（非400倍数）
      let integerYear = year;
      if (year % DateUtil.ONE_CENTURY !== 0) {
        integerYear = Math.ceil(year / DateUtil.ONE_CENTURY) * DateUtil.ONE_CENTURY;
      }
      for (let i = integerYear; i < DateUtil.OLD_CALENDAR_END_YEAR; i = i + DateUtil.ONE_CENTURY) {
        if (i % DateUtil.FOUR_CENTURY !== 0) {
          count++;
        }
      }
      // 如果当年正好为整百年（非400倍数），要区分月份
      if (year % DateUtil.ONE_CENTURY === 0 && year % DateUtil.FOUR_CENTURY !== 0) {
        if (month > DateUtil.FEBRUARY) {
          count -= 1;
        }
      }
      let lostDay = DateUtil.LOST_DAY_IN_1582;
      if (count > lostDay) {
        if (week - ((count - lostDay) % DateUtil.WEEKDAYS) > 0) {
          week = week - ((count - lostDay) % DateUtil.WEEKDAYS);
        } else {
          week = DateUtil.WEEKDAYS - Math.abs(week - ((count - lostDay) % DateUtil.WEEKDAYS));
        }
      } else {
        if (week + ((lostDay - count) % DateUtil.WEEKDAYS) > DateUtil.WEEKDAYS) {
          week = week + ((lostDay - count) % DateUtil.WEEKDAYS) - DateUtil.WEEKDAYS;
        } else {
          week = week + ((lostDay - count) % DateUtil.WEEKDAYS);
        }
      }
    }
    if (week === DateUtil.WEEKDAYS) {
      week = 0;
    }
    return week;
  }
}

export interface MonthInfo {
  year: number;
  month: number;
}