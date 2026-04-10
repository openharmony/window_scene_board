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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DNDConstants } from '../common/Constants';
import { NotDisturbTimerParam, NotDisturbTimerRepeatType } from '../manager/NotDisturbTimerManager';

const TAG = 'NotDisturbUtils';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class NotDisturbUtils {

  private emptyTime: Array<number> = [0, 0];

  /**
   * 获取下一个timer生效的时间区间
   *
   * @param zenTimerParam 定时规则
   * @param currentTime 当前时间
   * @returns 开始时间和结束时间
   */
  public getNextTime(zenTimerParam: NotDisturbTimerParam, currentTime: number): Array<number> {
    if (!zenTimerParam || !currentTime) {
      return this.emptyTime;
    }
    const timeInterval = this.getTimeInterval(zenTimerParam, currentTime);
    if (timeInterval === undefined) {
      return this.emptyTime;
    }
    const startAlarmTime = timeInterval[0];
    const endAlarmTime = timeInterval[1];
    const now = new Date(currentTime);
    const repeatType = zenTimerParam.repeatType;
    if (repeatType === NotDisturbTimerRepeatType.ONES) {
      if (endAlarmTime.getTime() <= now.getTime()) {
        // 结束时间小于等于当前时间，表示本次timer已过去
        return this.emptyTime;
      }
    } else {
      let daysOfWeek: number[] = this.getDaysOfWeek(zenTimerParam.repeat as string);
      if (daysOfWeek.length === 0) {
        // 无重复周期，不进行定时
        return this.emptyTime;
      }
      if (endAlarmTime.getTime() <= now.getTime()) {
        // 结束时间小于等于当前时间，表示本次timer已过去，偏倚定时
        startAlarmTime.setDate(startAlarmTime.getDate() + DNDConstants.ONE_DAY);
        endAlarmTime.setDate(endAlarmTime.getDate() + DNDConstants.ONE_DAY);
      }
      const daysToAdd = this.getDaysToNextAlarm(daysOfWeek, startAlarmTime.getDay() + DNDConstants.ONE_DAY);
      startAlarmTime.setDate(startAlarmTime.getDate() + daysToAdd);
      endAlarmTime.setDate(endAlarmTime.getDate() + daysToAdd);
    }
    log.info(`${TAG} getNextTime startAlarmTime: ${startAlarmTime.getDate()} - ` +
      `${startAlarmTime.getHours()} - ${startAlarmTime.getMinutes()}`);
    log.info(`${TAG} getNextTime endAlarmTime: ${endAlarmTime.getDate()} - ` +
      `${endAlarmTime.getHours()} - ${endAlarmTime.getMinutes()}`);
    return [startAlarmTime.getTime(), endAlarmTime.getTime()];
  }

  /**
   * 单次生效定时任务是否已过期
   *
   * @param zenTimerParam 定时规则
   * @param currentTime 当前时间
   * @returns 是否过期结果
   */
  public isOnceOverTime(zenTimerParam: NotDisturbTimerParam, currentTime: number): boolean {
    let res: boolean = true;
    if (!zenTimerParam || !currentTime) {
      return res;
    }
    const timeInterval = this.getTimeInterval(zenTimerParam, currentTime);
    if (timeInterval === undefined) {
      return res;
    }
    const startAlarmTime = timeInterval[0];
    const endAlarmTime = timeInterval[1];
    const now = new Date(currentTime);
    res = now.getTime() < startAlarmTime.getTime() || endAlarmTime.getTime() <= now.getTime();
    return res;
  }

  /**
   * 解析时间区间，保证返回结果的结束时间大于当前时间
   *
   * @param zenTimerParam 定时规则
   * @param currentTime 当前时间
   * @returns [开始时间Date, 结束时间Date]
   */
  private getTimeInterval(zenTimerParam: NotDisturbTimerParam, currentTime: number): Array<Date> | undefined {
    const timeStart: number[] = this.forMatTime(zenTimerParam.startTime as string);
    const timeEnd: number[] = this.forMatTime(zenTimerParam.endTime as string);
    if (timeStart[DNDConstants.INDEX_HOUR] === -1 || timeEnd[DNDConstants.INDEX_HOUR] === -1) {
      return undefined;
    }
    const startAlarmTime = new Date(currentTime);
    startAlarmTime.setHours(timeStart[DNDConstants.INDEX_HOUR]);
    startAlarmTime.setMinutes(timeStart[DNDConstants.INDEX_MIN]);
    startAlarmTime.setSeconds(0);
    startAlarmTime.setMilliseconds(0);

    const endAlarmTime = new Date(currentTime);
    endAlarmTime.setHours(timeEnd[DNDConstants.INDEX_HOUR]);
    endAlarmTime.setMinutes(timeEnd[DNDConstants.INDEX_MIN]);
    endAlarmTime.setSeconds(0);
    endAlarmTime.setMilliseconds(0);

    const now = new Date(currentTime);
    if (startAlarmTime.getTime() >= endAlarmTime.getTime()) {
      if (endAlarmTime.getTime() > now.getTime()) {
        startAlarmTime.setHours(startAlarmTime.getHours() - DNDConstants.ONE_DAY_HOUR);
      } else {
        endAlarmTime.setHours(endAlarmTime.getHours() + DNDConstants.ONE_DAY_HOUR);
      }
    }
    return [startAlarmTime, endAlarmTime];
  }

  /**
   * 解析时间类型如7:00的字串
   *
   * @param timeStr 待解析的字符串
   * @returns [小时, 分钟]
   */
  private forMatTime(timeStr: string): Array<number> {
    if (this.checkStrIsEmpty(timeStr)) {
      return [-1, -1];
    }
    let timeArray: string[] = timeStr.split(':');
    let hour: number = -1;
    let minute: number = -1;
    try {
      hour = Number(timeArray[DNDConstants.INDEX_HOUR]);
      minute = Number(timeArray[DNDConstants.INDEX_MIN]);
    } catch (e) {
      log.error(`forMatTime error: ${e?.message}}`);
      return [-1, -1];
    }
    if ((hour < 0 && hour > 23) || (minute < 0 && minute > 59)) { // 限定时、分解析，防异常时间入参
      return [-1, -1];
    }
    return [hour, minute];
  }

  /**
   * 检查字串是否合法
   *
   * @param str 字串
   * @return {boolean} true(为空)
   */
  private checkStrIsEmpty(str: string): boolean {
    return str === undefined || str === null || str.trim().length === 0;
  }

  private getDaysOfWeek(strdaysOfWeek: string): Array<number> {
    let arrayStr: string[] = strdaysOfWeek.split(',');
    let daysOfWeek: number[] = [];
    for (let index = 0; index < arrayStr.length; index++) {
      daysOfWeek.push(Number(arrayStr[index]));
    }
    return daysOfWeek;
  }

  private getDaysToNextAlarm(daysOfWeek: number[], nearWeekDay: number): number {
    let dayCount = 0;
    if (daysOfWeek.length <= 0) {
      return dayCount;
    }
    for (; dayCount < DNDConstants.DAYS_OF_WEEK_COUNT; dayCount++) {
      const day = (nearWeekDay + dayCount) % (DNDConstants.DAYS_OF_WEEK_COUNT + 1);
      if (daysOfWeek.some(item => item === day)) {
        break;
      }
    }
    const week = (nearWeekDay + dayCount) / (DNDConstants.DAYS_OF_WEEK_COUNT + 1);
    log.info(`${TAG} getDaysToNextAlarm week: ${week}`);
    if (week >= 1) {
      dayCount--;
    }
    return dayCount;
  }
}

let notDisturbUtils = new NotDisturbUtils();

export default notDisturbUtils as NotDisturbUtils;