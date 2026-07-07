/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2024. All rights reserved.
 */

import { BaseVM } from './BaseVM';
import { DateUtils } from '../common/DateUtils';

/**
 * 日期数据处理
 *
 * @since 2024-10-15
 */
export class DateVM extends BaseVM {
  /**
   * 延时更新时间时刻
   */
  private updateTimeMillis: number = 0;

  /**
   * 获取当前格式化日期文本
   *
   * @returns 当前格式化日期文本：X月Y日
   */
  public getCurrentDate(): string {
    let current = new Date();
    let result = DateUtils.formatDateNoWeek(current);
    // 一天后更新
    current.setHours(0, 0, 0, 0);
    current.setDate(current.getDate() + 1);
    this.updateTimeMillis = current.getTime();
    return result;
  }

  /**
   * 更新日期文本
   *
   * @return 日期文本
   */
  protected async updateTime(): Promise<string> {
    return this.getCurrentDate();
  }

  /**
   * 获取tick时延时更新时刻
   *
   * @return 延时更新时刻
   */
  protected getSoonestUpdateTime(): number {
    // 一天一更新
    return this.updateTimeMillis;
  }
}