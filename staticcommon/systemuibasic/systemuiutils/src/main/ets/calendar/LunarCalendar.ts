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

import type { LunarTermsInfo } from './LunarTermsInfo';
import { LunarTerm } from './LunarTerm';
import { SexagenarianCycle } from './SexagenarianCycle';

export default class LunarCalendar {
  static readonly LUNAR_INFO: Array<number> = [0x6aa0, 0xbaa3, 0xab50, 0x4bd8, 0x4ae0, 0xa570, 0x54d5, 0xd260, 0xd950,
    0x5554, 0x56af, 0x9ad0, 0x55d2, 0x4ae0, 0xa5b6, 0xa4d0, 0xd250, 0xd295, 0xb54f, 0xd6a0, 0xada2, 0x95b0, 0x4977,
    0x497f, 0xa4b0, 0xb4b5, 0x6a50, 0x6d40, 0xab54, 0x2b6f, 0x9570, 0x52f2, 0x4970, 0x6566, 0xd4a0, 0xea50, 0x6a95,
    0x5adf, 0x2b60, 0x86e3, 0x92ef, 0xc8d7, 0xc95f, 0xd4a0, 0xd8a6, 0xb55f, 0x56a0, 0xa5b4, 0x25df, 0x92d0, 0xd2b2,
    0xa950, 0xb557, 0x6ca0, 0xb550, 0x5355, 0x4daf, 0xa5b0, 0x4573, 0x52bf, 0xa9a8, 0xe950, 0x6aa0, 0xaea6, 0xab50,
    0x4b60, 0xaae4, 0xa570, 0x5260, 0xf263, 0xd950, 0x5b57, 0x56a0, 0x96d0, 0x4dd5, 0x4ad0, 0xa4d0, 0xd4d4, 0xd250,
    0xd558, 0xb540, 0xb6a0, 0x95a6, 0x95bf, 0x49b0, 0xa974, 0xa4b0, 0xb27a, 0x6a50, 0x6d40, 0xaf46, 0xab60, 0x9570,
    0x4af5, 0x4970, 0x64b0, 0x74a3, 0xea50, 0x6b58, 0x5ac0, 0xab60, 0x96d5, 0x92e0, 0xc960, 0xd954, 0xd4a0, 0xda50,
    0x7552, 0x56a0, 0xabb7, 0x25d0, 0x92d0, 0xcab5, 0xa950, 0xb4a0, 0xbaa4, 0xad50, 0x55d9, 0x4ba0, 0xa5b0, 0x5176,
    0x52bf, 0xa930, 0x7954, 0x6aa0, 0xad50, 0x5b52, 0x4b60, 0xa6e6, 0xa4e0, 0xd260, 0xea65, 0xd530, 0x5aa0, 0x76a3,
    0x96d0, 0x4afb, 0x4ad0, 0xa4d0, 0xd0b6, 0xd25f, 0xd520, 0xdd45, 0xb5a0, 0x56d0, 0x55b2, 0x49b0, 0xa577, 0xa4b0,
    0xaa50, 0xb255, 0x6d2f, 0xada0, 0x4b63, 0x937f, 0x49f8, 0x4970, 0x64b0, 0x68a6, 0xea5f, 0x6b20, 0xa6c4, 0xaaef,
    0x92e0, 0xd2e3, 0xc960, 0xd557, 0xd4a0, 0xda50, 0x5d55, 0x56a0, 0xa6d0, 0x55d4, 0x52d0, 0xa9b8, 0xa950, 0xb4a0,
    0xb6a6, 0xad50, 0x55a0, 0xaba4, 0xa5b0, 0x52b0, 0xb273, 0x6930, 0x7337, 0x6aa0, 0xad50, 0x4b55, 0x4b6f, 0xa570,
    0x54e4, 0xd260, 0xe968, 0xd520, 0xdaa0, 0x6aa6, 0x56df, 0x4ae0, 0xa9d4, 0xa4d0, 0xd150, 0xf252, 0xd520, 0xdd45,
    0xb5a0, 0x56d0];
  static readonly YEAR_START: number = 1897;
  static readonly YEAR_HOLIDAY_START: number = 1900;
  static readonly LUNAR_LEAP_MONTH_MASK: number = 0xf;
  static readonly LUNAR_MONTH_DAYS_MASK: number = 0x10000;
  static readonly LUNAR_MONTH_NORMAL_SIZE: number = 30;
  static readonly LUNAR_MONTH_LEAP_SIZE: number = 29;
  static readonly MONTH_SIZE: number = 12;
  static readonly YEAR_END: number = 2102;
  static readonly YEAR_HOLIDAY_END: number = 2100;
  static readonly MONTH_START: number = 1;
  static readonly DAY_START: number = 2;
  static readonly OFFSET_OF_TEN: number = 10;
  static readonly OFFSET_OF_TWENTY: number = 20;
  static readonly LUNAR_STRING: Array<string> = ['零', '一', '二', '三', '四',
    '五', '六', '七', '八', '九', '十'];

  /* Chinese zodiac */
  static readonly ZODIAC: Array<string> =
    ['鼠', '牛', '虎', '兔', '龙', '蛇', '马', '羊', '猴', '鸡', '狗', '猪'];
  static readonly HEAVENLY_STEMS: Array<string> =
    ['甲', '乙', '丙', '丁', '戊', '己',
      '庚', '辛', '壬', '癸'];
  static readonly EARTHLY_BRANCHES: Array<string> =
    ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

  /**
   * 农历正月是1月
   */
  static readonly MONTH_OF_ZHENG_YUE: number = 1;

  /**
   * 农历冬月是11月
   */
  static readonly MONTH_OF_DONG_YUE: number = 11;

  /**
   * 农历腊月是12月
   */
  static readonly MONTH_OF_LA_YUE: number = 12;
  static readonly SOLAR_TERM: Array<string> = ['小寒', '大寒', '立春',
    '雨水', '惊蛰', '春分', '清明节',
    '谷雨', '立夏', '小满', '芒种',
    '夏至', '小暑', '大暑', '立秋',
    '处暑', '白露', '秋分', '寒露', '霜降',
    '立冬', '小雪', '大雪', '冬至'];
  static readonly NUMBER_OF_MARCH: number = 3;
  static readonly NUMBER_SIX: number = 6;
  static readonly NUMBER_TWO: number = 2;
  static readonly DONG_ZHI: number = 23;
  static readonly XIA_ZHI: number = 11;
  static readonly QIU_FEN: number = 14;
  static readonly GAN_ZHI_NUMBER: number = 60;
  static readonly NUMBER_FOUR: number = 4;
  static readonly NUMBER_TWENTY_SIX: number = 26;
  static readonly NUMBER_TWENTY: number = 20;
  static readonly NUMBER_TEN: number = 10;
  static readonly ONE_DAY_MILL: number = 86400000;
  static readonly NINE_DAY_MILL: number = 777600000;
  static readonly NUMBER_THREE: number = 3;
  static readonly MONTH_NOVEMBER: number = 10;
  static readonly ONE_HUNDRED: number = 100;
  static readonly D_NUMBER: number = 0.2422;
  static readonly CENTURY_20: number = 19;
  static readonly CENTURY_20_WINTER: number = 22.60;
  static readonly CENTURY_21_WINTER: number = 21.94;
  static readonly SPECIAL_YEAR_ONE: number = 2021;
  static readonly SPECIAL_YEAR_TWO: number = 1918;
  static readonly DONGZHI_IS_23: number = 22.9;
  static readonly BEGIN_CHINESE_ERA: number = 33;

  /**
   * 12生肖计算时的偏移值
   */
  static readonly OFFSET_OF_ZODIAC: number = 4;

  /**
   * 12生肖
   */
  static readonly SIZE_OF_ZODIAC: number = 12;
  static readonly JIU_JIU: Array<string> = ['入九', '二九', '三九', '四九',
    '五九', '六九', '七九', '八九', '九九'];
  static readonly GREGORIAN_FOUR: number = 4;
  static readonly GREGORIAN_FIVE: number = 5;
  static readonly GREGORIAN_SIX: number = 6;
  mLunarYear: number = 0;
  mIsLeap: boolean = false;
  mDaysInLunarMonth: number = 0;
  mLunarDay: number = 0;
  mLunarMonth: number = 0;
  mInstanceYear: number = 0;
  mSolarYear: number = 0;
  mSolarMonth: number = 0;
  mSolarDay: number = 0;
  mCurYearJqinfo: Array<LunarTermsInfo>;
  mLunarTerm: LunarTerm;
  isHasTerm: boolean = false;
  mSexagenarianCycle: SexagenarianCycle;

  constructor() {
    this.mCurYearJqinfo = new Array<LunarTermsInfo>();
    this.mLunarTerm = new LunarTerm();
    this.mSexagenarianCycle = new SexagenarianCycle();
  }

  /**
   * 初始化农历，获取农历日期
   *
   * @param year 阳历年
   * @param month 阳历月
   * @param day 阳历日
   */
  public init(year: number, month: number, day: number): void {
    this.mSolarYear = year;
    this.mSolarMonth = month;
    this.mSolarDay = day;
    this.mLunarYear = LunarCalendar.YEAR_START;
    let currentDate = new Date(Date.UTC(year, month, day));
    let baseDate = new Date(Date.UTC(LunarCalendar.YEAR_START, LunarCalendar.MONTH_START, LunarCalendar.DAY_START));
    let offset = (currentDate.getTime() - baseDate.getTime()) / 86400000; // convert to days
    let daysInLunarYear = this.getLunarYearDays(this.mLunarYear);

    /* get current lunar year */
    while (this.mLunarYear < LunarCalendar.YEAR_END && offset >= daysInLunarYear) {
      offset -= daysInLunarYear;
      daysInLunarYear = this.getLunarYearDays(++this.mLunarYear);
    }

    /* get current lunar month */
    let lunarMonth = 1;
    let isLeapDec = false;
    let isLeap = false;
    let dayInLunarMonth = 0;
    let leapMonth = this.getLunarLeapMonth(this.mLunarYear);
    /* to get lunar year, month and day */
    while (lunarMonth <= LunarCalendar.MONTH_SIZE && offset > 0) {
      if (isLeap && isLeapDec) {
        dayInLunarMonth = this.getLunarLeapDays(this.mLunarYear);
        isLeapDec = false;
      } else {
        dayInLunarMonth = this.getLunarMonthDays(this.mLunarYear, lunarMonth);
      }

      if (offset < dayInLunarMonth) {
        break;
      }
      offset -= dayInLunarMonth;

      if (leapMonth === lunarMonth && !isLeap) {
        isLeap = true;
        isLeapDec = true;
      } else {
        lunarMonth++;
      }
    }
    this.mIsLeap = (lunarMonth === leapMonth && isLeap);
    this.mDaysInLunarMonth = dayInLunarMonth;
    this.mLunarDay = Math.floor(offset) + 1;
    this.mLunarMonth = lunarMonth;
  }

  private getLunarYearDays(lunarYear: number): number {
    /* lunar year has (12 * 29 =) 348 days at least */
    let totalDays = 348;
    for (let index = 0x8000; index > 0x8; index >>= 1) {
      totalDays += ((LunarCalendar.LUNAR_INFO[lunarYear - LunarCalendar.YEAR_START] & index) !== 0) ? 1 : 0;
    }
    return totalDays + this.getLunarLeapDays(lunarYear);
  }

  private getLunarLeapDays(lunarYear: number): number {
    return this.getLunarLeapMonth(lunarYear) > 0 ?
      ((LunarCalendar.LUNAR_INFO[lunarYear - LunarCalendar.YEAR_START + 1] & LunarCalendar.LUNAR_LEAP_MONTH_MASK) ===
      LunarCalendar.LUNAR_LEAP_MONTH_MASK ? LunarCalendar.LUNAR_MONTH_NORMAL_SIZE :
        LunarCalendar.LUNAR_MONTH_LEAP_SIZE) : 0;
  }

  getLunarLeapMonth(lunarYear: number): number {
    let leapMonth = LunarCalendar.LUNAR_INFO[lunarYear - LunarCalendar.YEAR_START] & LunarCalendar.LUNAR_LEAP_MONTH_MASK;
    return leapMonth === LunarCalendar.LUNAR_LEAP_MONTH_MASK ? 0 : leapMonth;
  }

  private getLunarMonthDays(lunarYear: number, lunarMonth: number): number {
    return ((LunarCalendar.LUNAR_INFO[lunarYear - LunarCalendar.YEAR_START] & (LunarCalendar.LUNAR_MONTH_DAYS_MASK >>
      lunarMonth)) !== 0) ? LunarCalendar.LUNAR_MONTH_NORMAL_SIZE : LunarCalendar.LUNAR_MONTH_LEAP_SIZE;
  }

  private getChineseInfo(): string {
    if (this.mLunarYear < LunarCalendar.YEAR_START && this.mLunarYear > LunarCalendar.YEAR_END) {
      return '';
    }
    if (this.isFirstDayOfMonth()) {
      return this.getChineseMonth(false);
    }
    return this.getChineseDay();
  }

  /**
   * 是否是农历的第一天
   */
  public isFirstDayOfMonth(): boolean {
    if (this.mLunarDay === 1) {
      return true;
    } else {
      return false;
    }
  }

  /**
   * 是否是农历新年
   */
  public isNewYear(): boolean {
    if (this.mLunarMonth === 1 && this.mLunarDay === 1) {
      return true;
    } else {
      return false;
    }
  }

  /**
   * 获取农历月份
   * @param isShowNum
   */
  public getChineseMonth(isShowNum: boolean): string {
    let chineseMonth = '';
    if (this.mIsLeap) {
      chineseMonth += '闰';
    }
    let normalMonthStr = '';
    normalMonthStr = this.getChineseNum(this.mLunarMonth) + '月';
    switch (this.mLunarMonth) {
      case LunarCalendar.MONTH_OF_ZHENG_YUE:
        return chineseMonth + this.getFormatChineseMonth(isShowNum, '正月', normalMonthStr);
      case LunarCalendar.MONTH_OF_DONG_YUE:
        return chineseMonth + this.getFormatChineseMonth(isShowNum, '冬月', normalMonthStr);
      case LunarCalendar.MONTH_OF_LA_YUE:
        return chineseMonth + this.getFormatChineseMonth(isShowNum, '腊月', normalMonthStr);
      default:
        break;
    }
    chineseMonth = chineseMonth + normalMonthStr;
    return chineseMonth;
  }

  private getChineseNum(num: number): string {
    if (num < 0) {
      return '';
    }
    let convertNum = '';

    switch (Math.floor(num / LunarCalendar.OFFSET_OF_TEN)) {
      case 1: // 大于十小于十九，农历前缀为‘十’
        convertNum = '十';
        break;
      case 2: // 大于二十小于二十九，农历前缀为‘二十’
        if ((num % LunarCalendar.OFFSET_OF_TWENTY) === 0) {
          convertNum = '二十';
        } else {
          convertNum = '廿';
        }
        break;
      case 3: // 农历三十
        convertNum = '三十';
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

  private getFormatChineseMonth(isShowNum: boolean, lunarMonthStr: string, normalMonthStr: string): string {
    return lunarMonthStr;
  }

  public getChineseDay(): string {
    let chineseDay = '';
    if (this.mLunarDay <= LunarCalendar.OFFSET_OF_TEN) {
      chineseDay = chineseDay + '初';
    }
    chineseDay = chineseDay + this.getChineseNum(this.mLunarDay);
    return chineseDay;
  }

  private getLunarTermNew(isShowQingMing: boolean, isShowLunarTerm: boolean): string {
    if (this.mInstanceYear !== this.mSolarYear) {
      this.mCurYearJqinfo.length = 0;
      this.mLunarTerm.setFromStr(this.mSolarYear, this.mSolarMonth, this.mSolarDay);
      this.mLunarTerm.getSolarTerms(this.mSolarYear - 1, this.mCurYearJqinfo, this.mSolarYear, false);
      this.mLunarTerm.getSolarTerms(this.mSolarYear, this.mCurYearJqinfo, this.mSolarYear, true);
      this.mInstanceYear = this.mSolarYear;
    }
    let size = this.mCurYearJqinfo.length;
    for (let index = 0; index < size; index++) {
      if (this.mCurYearJqinfo[index].isSameDay(this.mSolarDay) &&
      this.mCurYearJqinfo[index].isSameMonth(this.mSolarMonth + 1) &&
      this.mCurYearJqinfo[index].isSameYear(this.mSolarYear)) {
        if (index >= LunarCalendar.SOLAR_TERM.length || index < 0) {
          continue;
        }
        let name = LunarCalendar.SOLAR_TERM[index];
        if (!isShowQingMing && !isShowLunarTerm && this.mSolarMonth === LunarCalendar.NUMBER_OF_MARCH &&
          this.mSolarDay <= LunarCalendar.NUMBER_SIX) {
          return LunarCalendar.safeSubString(name, 0, LunarCalendar.NUMBER_TWO);
        }
        return name;
      }
    }
    return '';
  }

  private static safeSubString(string: string, start: number, end: number): string {
    if (string === null || string === undefined) {
      return '';
    }
    if (start < 0 || end > string.length || start > end) {
      return '';
    }
    return string.substring(start, end);
  }

  /**
   * 获取农历日期
   *
   * @param isShowFestival 是否显示节日
   */
  public getChineseDayInfo(isShowFestival: boolean): string {
    let isPossibleDayOfQingming = (this.mSolarDay === LunarCalendar.GREGORIAN_FOUR) ||
      (this.mSolarDay === LunarCalendar.GREGORIAN_FIVE) || (this.mSolarDay === LunarCalendar.GREGORIAN_SIX);
    if (isShowFestival && (this.mSolarMonth === LunarCalendar.NUMBER_OF_MARCH) && isPossibleDayOfQingming) {
      let chineseTerm = this.getLunarTermNew(isShowFestival, true);
      if (chineseTerm !== '') {
        this.isHasTerm = true;
        return chineseTerm;
      }
    }
    if (this.mSolarYear > LunarCalendar.YEAR_HOLIDAY_END || this.mSolarYear < LunarCalendar.YEAR_HOLIDAY_START) {
      return '';
    }
    let chineseTerm = this.getLunarTermNew(isShowFestival, true);
    if (chineseTerm !== '') {
      this.isHasTerm = true;
      return chineseTerm;
    }
    let fuAndJiu = this.getFuAndJiu();
    if (fuAndJiu !== '') {
      this.isHasTerm = true;
      return fuAndJiu;
    }
    return this.getChineseInfo();
  }

  private getFuAndJiu(): string {
    if (this.mCurYearJqinfo.length < LunarCalendar.DONG_ZHI) {
      return '';
    }
    let xiaZhi = this.mSexagenarianCycle.getGanZhi(this.mCurYearJqinfo[LunarCalendar.XIA_ZHI].mYear,
      this.mCurYearJqinfo[LunarCalendar.XIA_ZHI].mMonth, this.mCurYearJqinfo[LunarCalendar.XIA_ZHI].mDay);
    let liQiu = this.mSexagenarianCycle.getGanZhi(this.mCurYearJqinfo[LunarCalendar.QIU_FEN].mYear,
      this.mCurYearJqinfo[LunarCalendar.QIU_FEN].mMonth, this.mCurYearJqinfo[LunarCalendar.QIU_FEN].mDay);
    let startOfChuFu: number;

    // 计算夏至日是否为庚日，如为庚日（值为0）则向后第二个庚日（20天）入伏
    let daysToGeng = ((xiaZhi % LunarCalendar.GAN_ZHI_NUMBER) + LunarCalendar.NUMBER_FOUR) % LunarCalendar.NUMBER_TEN;
    let date = new Date(this.mCurYearJqinfo[LunarCalendar.XIA_ZHI].mYear, this.mCurYearJqinfo[LunarCalendar.XIA_ZHI].mMonth - 1,
      this.mCurYearJqinfo[LunarCalendar.XIA_ZHI].mDay);
    if (daysToGeng === 0) {
      startOfChuFu = date.getTime() + (LunarCalendar.ONE_DAY_MILL * LunarCalendar.NUMBER_TWENTY);
    } else {
      // 如夏至不是庚日，则计算夏至后第三个庚日的天干地支排位
      let y1 = Math.floor((xiaZhi % LunarCalendar.GAN_ZHI_NUMBER + LunarCalendar.NUMBER_THREE) /
      LunarCalendar.NUMBER_TEN) * LunarCalendar.NUMBER_TEN + LunarCalendar.NUMBER_TWENTY_SIX;
      let daysToChuFu = y1 - (xiaZhi % LunarCalendar.GAN_ZHI_NUMBER);
      startOfChuFu = date.getTime() + (daysToChuFu * LunarCalendar.ONE_DAY_MILL);
    }
    // 计算立秋日是否为庚日，如为庚日（值为0）则当天为末伏开始
    let l1 = ((liQiu % LunarCalendar.GAN_ZHI_NUMBER) + LunarCalendar.NUMBER_FOUR) % LunarCalendar.NUMBER_TEN;
    let lqdate = new Date(this.mCurYearJqinfo[LunarCalendar.QIU_FEN].mYear, this.mCurYearJqinfo[LunarCalendar.QIU_FEN].mMonth - 1,
      this.mCurYearJqinfo[LunarCalendar.QIU_FEN].mDay);
    let startOfMoFu: number;
    if (l1 === 0) {
      startOfMoFu = lqdate.getTime();
    } else {
      // 如立秋不是庚日，则计算立秋后第一个庚日的天干地支排位
      let m1 = Math.floor((liQiu % LunarCalendar.GAN_ZHI_NUMBER + LunarCalendar.NUMBER_THREE) /
      LunarCalendar.NUMBER_TEN) * LunarCalendar.NUMBER_TEN + LunarCalendar.NUMBER_SIX;
      let daysToMoFu = m1 - (liQiu % LunarCalendar.GAN_ZHI_NUMBER);
      startOfMoFu = lqdate.getTime() + (daysToMoFu * LunarCalendar.ONE_DAY_MILL);
    }
    let startOfJiu: number;
    // 获取当年冬至日，即为初九开始日
    let dzdate = new Date(this.mCurYearJqinfo[LunarCalendar.DONG_ZHI].mYear, this.mCurYearJqinfo[LunarCalendar.DONG_ZHI].mMonth - 1,
      this.mCurYearJqinfo[LunarCalendar.DONG_ZHI].mDay);
    startOfJiu = dzdate.getTime();
    return this.setFuAndJiu(startOfChuFu, startOfMoFu, startOfJiu, dzdate);
  }

  private setFuAndJiu(startOfChuFu: number, startOfMoFu: number, startOfJiu: number, dztime: Date): string {
    if (this.getFuAndJiuDate(startOfChuFu).getMonth() === this.mSolarMonth &&
      this.getFuAndJiuDate(startOfChuFu).getDate() === this.mSolarDay) {
      return '入伏';
    }
    let startOfZhongFu = startOfChuFu + (LunarCalendar.ONE_DAY_MILL * LunarCalendar.NUMBER_TEN);
    if (this.getFuAndJiuDate(startOfZhongFu).getMonth() === this.mSolarMonth &&
      this.getFuAndJiuDate(startOfZhongFu).getDate() === this.mSolarDay) {
      return '中伏';
    }
    if (this.getFuAndJiuDate(startOfMoFu).getMonth() === this.mSolarMonth &&
      this.getFuAndJiuDate(startOfMoFu).getDate() === this.mSolarDay) {
      return '末伏';
    }
    let sizeCurrentYear = LunarCalendar.NUMBER_TWO;
    // 在当年年底预置入九，视情况预置二九
    for (let i = 0; i < sizeCurrentYear; i++) {
      let jiuTime = startOfJiu + i * LunarCalendar.NINE_DAY_MILL;
      if (this.mCurYearJqinfo[LunarCalendar.DONG_ZHI].mDay === LunarCalendar.DONG_ZHI) {
        sizeCurrentYear = 1;
        if (this.getFuAndJiuDate(jiuTime).getMonth() === this.mSolarMonth &&
          this.getFuAndJiuDate(jiuTime).getDate() === this.mSolarDay) {
          return LunarCalendar.JIU_JIU[i];
        }
      } else {
        if (this.getFuAndJiuDate(jiuTime).getMonth() === this.mSolarMonth &&
          this.getFuAndJiuDate(jiuTime).getDate() === this.mSolarDay) {
          return LunarCalendar.JIU_JIU[i];
        }
      }
    }
    let dateDiff = dztime.getDate() - Math.floor(this.getDateOfWinter(this.mSolarYear - 1));
    // 计算去年冬至，如为23则仅有入九，剩余八九均在今年，反之则除入九二九外剩余七九在今年
    if (this.getDateOfWinter(this.mSolarYear - 1) > LunarCalendar.DONGZHI_IS_23) {
      dateDiff = dztime.getDate() - LunarCalendar.DONG_ZHI;
      let lastJiu = this.lastJiuTime(dztime);
      for (let j = 1; j < LunarCalendar.JIU_JIU.length; j++) {
        let jiuTime = lastJiu + j * LunarCalendar.NINE_DAY_MILL;
        if (this.getFuAndJiuDate(jiuTime).getMonth() === this.mSolarMonth &&
          this.getFuAndJiuDate(jiuTime).getDate() - dateDiff === this.mSolarDay) {
          return LunarCalendar.JIU_JIU[j];
        }
      }
    } else {
      let startOfLastJiu = this.lastJiuTime(dztime);
      for (let j = LunarCalendar.NUMBER_TWO; j < LunarCalendar.JIU_JIU.length; j++) {
        let jiuTime = startOfLastJiu + j * LunarCalendar.NINE_DAY_MILL;
        if (this.getFuAndJiuDate(jiuTime).getMonth() === this.mSolarMonth &&
          this.getFuAndJiuDate(jiuTime).getDate() - dateDiff === this.mSolarDay) {
          return LunarCalendar.JIU_JIU[j];
          break;
        }
      }
    }
    return '';
  }

  private lastJiuTime(dzTime: Date): number {
    let year = this.mCurYearJqinfo[LunarCalendar.DONG_ZHI].mYear - 1;
    let month = this.mCurYearJqinfo[LunarCalendar.DONG_ZHI].mMonth - 1;
    let day = this.mCurYearJqinfo[LunarCalendar.DONG_ZHI].mDay;
    dzTime = new Date(year, month, day);
    let startOfLastJiu = dzTime.getTime();
    return startOfLastJiu;
  }

  private getFuAndJiuDate(dateTime: number): Date {
    let time = new Date(dateTime);
    return time;
  }

  private getDateOfWinter(year: number): number {
    let yearNum = year % LunarCalendar.ONE_HUNDRED;
    let dateOfWinter: number;
    dateOfWinter = yearNum * LunarCalendar.D_NUMBER + this.getCenturyNumber(year) - Math.floor(yearNum / 4);
    if (year === LunarCalendar.SPECIAL_YEAR_ONE || year === LunarCalendar.SPECIAL_YEAR_TWO) {
      dateOfWinter = dateOfWinter - 1;
    }
    return dateOfWinter;
  }

  private getCenturyNumber(year: number): number {
    let century = Math.floor(year / LunarCalendar.ONE_HUNDRED);
    if (century === LunarCalendar.CENTURY_20) {
      return LunarCalendar.CENTURY_20_WINTER;
    } else {
      return LunarCalendar.CENTURY_21_WINTER;
    }
  }

  private getChineseHeavenlyEarthly(): string {
    let ganNum = (this.mLunarYear - LunarCalendar.YEAR_START + LunarCalendar.BEGIN_CHINESE_ERA) % 10;
    let zhiNum = (this.mLunarYear - LunarCalendar.YEAR_START + LunarCalendar.BEGIN_CHINESE_ERA) % 12;
    let result = '';
    let isGanNumValid = ganNum >= 0 && ganNum < LunarCalendar.HEAVENLY_STEMS.length;
    if (!isGanNumValid || zhiNum < 0 || zhiNum >= LunarCalendar.EARTHLY_BRANCHES.length) {
      return result;
    }
    result = LunarCalendar.HEAVENLY_STEMS[ganNum] + LunarCalendar.EARTHLY_BRANCHES[zhiNum];
    return result;
  }

  private getZodiac(): string {
    return LunarCalendar.ZODIAC[(this.mLunarYear - LunarCalendar.OFFSET_OF_ZODIAC) % LunarCalendar.SIZE_OF_ZODIAC];
  }

  /**
   * 获取农历年份，如：庚子鼠年
   *
   * @return 农历年份
   */
  public getChineseYearReal(): string {
    let result = this.getChineseHeavenlyEarthly() + this.getZodiac() + '年';
    return result;
  }
}