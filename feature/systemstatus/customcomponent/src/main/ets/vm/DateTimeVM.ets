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

import {
  BaseVM,
  ViewCallback
} from './BaseVM';
import { DateUtils } from '../common/DateUtils';
import { ResUtils } from '@ohos/windowscene';

/**
 * 日期/时间组件数据处理
 * 主要用于通知栏时间显示
 *
 * @since 2022-12-12
 */
export class DateTimeVM extends BaseVM {
  /**
   * 延时更新时间时刻
   */
  private updateTimeMillis: number = 0;

  /**
   * 相对时刻值
   * 一般为通知发送时刻
   */
  private timeMillis: number = 0;

  /**
   * 初始化（复写）
   *
   * @param timeMillis 相对时刻值
   * @param slot 唯一标示
   * @param callback 回调器
   */
  initOv(timeMillis: number, slot: string, callback: ViewCallback): void {
    this.timeMillis = timeMillis;
    this.init(slot, callback);
  }

  /**
   * 更新基准时间
   *
   * @param timeMillis 基准时间
   */
  updateOvTimeMillis(timeMillis: number): void {
    this.timeMillis = timeMillis;
    this.checkUpdateTime();
  }

  /**
   * 更新时间文本
   *
   * @return 全新时间文本
   */
  protected async updateTime(): Promise<string> {
    // 时间相差1小时内，区分 刚刚 和 几分钟前
    let now = Date.now();
    let timeMinute = this.microsecondCeilToMinute(this.timeMillis);
    let duration = Math.abs(now - timeMinute);
    // 1小时内
    if (duration < DateUtils.HOUR_IN_MILLIS) {
      return this.updateRelativeTime(timeMinute);
    }
    // 区分 昨天 场景
    let dateNow = new Date();
    // 只留下 日期
    dateNow.setHours(0, 0, 0, 0);
    // 当天时间戳
    let yesterdayLimit = dateNow.getTime();
    // 前一天时间戳
    let beforeYesterdayLimit = DateUtils.minusDays(dateNow, 1);
    // 后一天时间戳
    let afterYesterdayLimit = DateUtils.plusDays(dateNow, 1);
    // 判断显示昨天
    if (yesterdayLimit > this.timeMillis && beforeYesterdayLimit < this.timeMillis) {
      this.updateTimeMillis = afterYesterdayLimit;
      return ResUtils.getInnerString($r('app.string.date_time_view_yesterday'));
    }
    // 判断一天内显示时间，一天以上显示年月日
    let localNow = new Date(this.timeMillis);
    // 当前午夜
    let localStartOfDay = new Date(this.timeMillis);
    localStartOfDay.setHours(0, 0, 0, 0);
    let midnightBefore = localStartOfDay.getTime();
    // 后一天午夜
    let midnightAfter = DateUtils.plusDays(localStartOfDay, 1);
    // 12小时前
    let twelveHoursBefore = DateUtils.minusHours(localNow, 12);
    // 12小时后
    let twelveHoursAfter = DateUtils.plusHours(localNow, 12);
    // 不显示秒
    localNow.setSeconds(0, 0);
    // 当前时间没有超过一天或12小时，显示时间
    if ((now >= midnightBefore && now < midnightAfter) || 
      (now >= twelveHoursBefore && now < twelveHoursAfter)) {
      // 更新时间
      this.updateTimeMillis = twelveHoursAfter < midnightAfter ? twelveHoursAfter : midnightAfter;
      return DateUtils.formatLocalTime(localNow);
    }
    // 其他场景显示年月日
    if (this.timeMillis < now) {
      this.updateTimeMillis = 0;
    } else {
      this.updateTimeMillis = twelveHoursBefore < midnightBefore
        ? twelveHoursBefore : midnightBefore;
    }
    return DateUtils.formatLocalDate(localNow, DateUtils.STYLE_SHORT);
  }

  /**
   * 获取tick时延时更新时刻
   *
   * @return 延时更新时刻
   */
  protected getSoonestUpdateTime(): number {
    return this.updateTimeMillis;
  }

  /**
   * 更新相对时间
   * 只处理1小时内
   *
   * @return 字串
   */
  private async updateRelativeTime(timeMinute: number): Promise<string> {
    let now = Date.now();
    let duration = Math.abs(now - timeMinute);
    // 相对值前后判断
    let past = (now >= timeMinute);
    // 1分钟内，刚刚
    if (duration < DateUtils.MINUTE_IN_MILLIS) {
      this.updateTimeMillis = timeMinute + DateUtils.MINUTE_IN_MILLIS + 1;
      return ResUtils.getInnerString($r('app.string.now_string_shortest'));
    }
    // 1小时内，几分钟前
    if (duration < DateUtils.HOUR_IN_MILLIS) {
      let millisIncrease = DateUtils.MINUTE_IN_MILLIS;
      let count = Math.floor(duration / millisIncrease);
      if (past) {
        this.updateTimeMillis = timeMinute + millisIncrease * (count + 1) + 1;
      } else {
        this.updateTimeMillis = timeMinute - millisIncrease * count + 1;
      }
      return ResUtils.getInnerPlural(past
        ? $r('app.plural.duration_minutes_shortest')
        : $r('app.plural.duration_minutes_shortest_future'), count);
    }
    // 其他
    return '';
  }

  /**
   * 微秒转换分钟，向上取整
   *
   * @param timeMillis 时间（单位：ms）
   * @return 取整后的时间（单位：min）
   */
  private microsecondCeilToMinute(timeMillis: number): number {
    return Math.ceil(timeMillis / DateUtils.MINUTE_IN_MILLIS) * DateUtils.MINUTE_IN_MILLIS;
  };
}