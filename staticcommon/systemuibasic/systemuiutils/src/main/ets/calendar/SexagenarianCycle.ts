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

/**
 * 干支纪日法19世纪对应常数
 */
const CENTURY_19_NUMBER: number = 31;

const CENTURY_19: number = 18;

/**
 * 干支纪日法20世纪对应常数
 */
const CENTURY_20_NUMBER: number = 15;

const CENTURY_20: number = 19;

/**
 * 干支纪日法21世纪对应常数
 */
const CENTURY_21_NUMBER: number = 0;

const CENTURY_YEARS: number = 100;

const MONTH_DAYS: Array<number> = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

const NUMBER_THREE: number = 3;

const NUMBER_FOUR: number = 4;

const NUMBER_FIVE: number = 5;

const NUMBER_SIX: number = 6;

const GAN_ZHI_NUMBER: number = 60;

export class SexagenarianCycle {
  /**
   * 干支纪日法
   *
   * @param year 公历年
   * @param month 公历月
   * @param day 公历日
   * @return 对应日期当天的干支纪日法结果数字，60为一个周期，由甲子开始，癸亥结束
   * 例：1为甲子，2为乙丑，3为丙寅，以此类推
   * 计算公式：r = s / 4 * 6 + 5 * (s / 4 * 3 + u) + m + d + x
   * s:公元念书后两位-1。  u:s除以4的余数。  m:月基数。  d:日基数， x:世纪常数
   */
  public getGanZhi(year: number, month: number, day: number): number {
    let yearNum = year % CENTURY_YEARS - 1;
    let uuNum = yearNum % NUMBER_FOUR;
    let dayNum = day;
    let isRunYear = year % NUMBER_FOUR;
    let resultNum = Math.floor(yearNum / NUMBER_FOUR) * NUMBER_SIX + NUMBER_FIVE * (Math.floor(yearNum / NUMBER_FOUR) *
      NUMBER_THREE + uuNum) + this.getMonthNum(month) + dayNum + this.getCenturyNum(year) - 1;
    if (isRunYear === 0) {
      resultNum = resultNum + 1;
    }
    return resultNum;
  }

  /**
   * 获取对应年份所在的世纪常数
   *
   * @param year 当前公历年份
   * @return 世纪常数
   */
  public getCenturyNum(year: number): number {
    let century = Math.floor(year / CENTURY_YEARS);
    if (century === CENTURY_19) {
      return CENTURY_19_NUMBER;
    } else if (century === CENTURY_20) {
      return CENTURY_20_NUMBER;
    } else {
      return CENTURY_21_NUMBER;
    }
  }

  /**
   * 获取对应月份的常数,数值为前几个月的日数总和除以60的余数
   *
   * @param month 当前公历月份
   * @return 当前月份的对应常数
   */
  public getMonthNum(month: number): number {
    let monthNum = 0;
    for (let i = 0; i < month; i++) {
      monthNum += MONTH_DAYS[i];
    }
    let monthNumber = monthNum % GAN_ZHI_NUMBER;
    return monthNumber;
  }
}