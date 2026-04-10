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
import { DayData } from './PanelMonthViewModel';

export const ALL_LUNAR_TERM: string[] = [
  "小寒", "大寒", "立春", "雨水", "惊蛰", "春分",
  "清明节", "谷雨", "立夏", "小满", "芒种", "夏至",
  "小暑", "大暑", "立秋", "处暑",
  "白露", "秋分", "寒露", "霜降",
  "立冬", "小雪", "大雪", "冬至",
  "入九", "二九", "三九", "四九", "五九", "六九", "七九", "八九", "九九",
  "入伏", "中伏", "末伏"
]

export default class LunarCalendar {
  static readonly MONTH_SIZE: number = 12;
  static readonly MONTH_START: number = 1;
  static readonly OFFSET_OF_TEN: number = 10;
  static readonly OFFSET_OF_TWENTY: number = 20;
  static readonly LUNAR_STRING: string[] = ['零', '一', '二', '三', '四',
    '五', '六', '七', '八', '九', '十'];
  //农历月份
  static readonly WINTERMOON: string = '冬月';
  static readonly LASTMONTH: string = '腊月';
  static readonly MONTH: string = '月';
  static readonly RUN: string = '闰';
  static readonly ELEVEN: number = 11;
  static readonly TWELVE: number = 12;

  constructor() {
  }


  public static getChineseNum(num: number): string {
    if (num < 0) {
      return "";
    }
    let convertNum = "";

    switch (Math.floor(num / LunarCalendar.OFFSET_OF_TEN)) {
      case 1: // 大于十小于十九，农历前缀为‘十’
        convertNum = "十";
        break;
      case 2: // 大于二十小于二十九，农历前缀为‘二十’
        if ((num % LunarCalendar.OFFSET_OF_TWENTY) === 0) {
          convertNum = "二十";
        } else {
          convertNum = "廿";
        }
        break;
      case 3: // 农历三十
        convertNum = "三十";
        break;
      default:
        break;
    }
    let offset = Math.floor(num % LunarCalendar.OFFSET_OF_TEN);
    if (offset !== 0) {
      convertNum = convertNum + LunarCalendar.LUNAR_STRING[offset];
    }
    return convertNum;
  }

  public static getChineseLunarDay(mLunarDay: number): string {
    let chineseDay = "";
    if (mLunarDay <= LunarCalendar.OFFSET_OF_TEN) {
      chineseDay = chineseDay + "初";
    }
    chineseDay = chineseDay + LunarCalendar.getChineseNum(mLunarDay);
    return chineseDay;
  }

  /**
   * 处理农历月份
   */
  public static parseLeapLunaMonth(dayData: DayData): string {
    let calendarMonth = ''
    if (dayData.lunarDay === LunarCalendar.MONTH_START) {
      if (dayData.lunaMonth > LunarCalendar.MONTH_SIZE) {
        calendarMonth = LunarCalendar.RUN + LunarCalendar.getChineseLunaMonth(dayData.lunaMonth - LunarCalendar.MONTH_SIZE);
      } else {
        calendarMonth = LunarCalendar.getChineseLunaMonth(dayData.lunaMonth);
      }
    } else {
      calendarMonth = LunarCalendar.getChineseLunarDay(dayData.lunarDay);
    }
    return calendarMonth;
  }


  public static getChineseLunaMonth(mLunarMonth: number): string {
    let chineseMonth: string = ""
    if (mLunarMonth === LunarCalendar.ELEVEN) {
      chineseMonth = LunarCalendar.WINTERMOON
    } else if (mLunarMonth === LunarCalendar.TWELVE) {
      chineseMonth = LunarCalendar.LASTMONTH
    } else {
      chineseMonth = LunarCalendar.getChineseNum(mLunarMonth) + LunarCalendar.MONTH;
    }
    return chineseMonth;
  }
}