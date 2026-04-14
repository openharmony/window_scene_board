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

import formInfo from '@ohos/windowsceneinterfaces/src/main/ets/interfaces/@ohos.app.form.formInfo';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import OverflowFormUtils from '../../common/OverflowFormUtils';

const TAG: string = 'AbstractOverflowPolicy';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 溢出策略接口
 */
export abstract class AbstractOverflowPolicy {
  protected mOverflowTimer?: number;
  protected startOverflow?: () => void;
  protected stopOverflow?: (hasAnimation: boolean, isTimeOut: boolean) => void;
  protected isInOverflowState: boolean = false;

  /**
   * 溢出控制函数初始化
   * @param stopOverflow 停止溢出
   */
  public initFunction(
    startOverflow?: () => void,
    stopOverflow?: (hasAnimation: boolean, isTimeOut: boolean) => void
  ): void {
    this.startOverflow = startOverflow;
    this.stopOverflow = stopOverflow;
  }

  /**
   * 处理溢出请求
   *
   * @param config 溢出配置信息
   * @param formItemWidth 卡片宽度
   * @param formItemHeight 卡片高度
   * @returns 是否成功处理溢出请求
   */
  public handleOverflowRequest(overflowInfo: formInfo.OverflowInfo, formItemWidth: number,
    formItemHeight: number, isLongActiveForm: boolean): boolean {
    if (!this.stopOverflow) {
      log.showError('handleOverflowRequest fail: function not init');
      return false;
    }
    this.startOverflow?.();
    this.handleOverflowStatus(overflowInfo, formItemWidth, formItemHeight, isLongActiveForm);
    return true;
  }

  /**
   * 取消溢出
   */
  public cancelOverflow() {
    this.stopOverflow?.(true, false);
    this.clearOverflowTimer();
  }

  /**
   * 清除溢出计时器
   */
  public release(): void {
    this.clearOverflowTimer();
  }

  /**
   * 启动溢出区域倒计时
   *
   * @param duration 计时器时长
   * @param config 溢出区域参数
   */
  public startOverflowTimer(duration: number): void {
    this.clearOverflowTimer();
    this.mOverflowTimer = setTimeout(() => {
      // 倒计时结束，执行关闭溢出区域
      this.stopOverflow?.(true, true);
      this.isInOverflowState = false;
    }, duration);
  }

  private clearOverflowTimer(): void {
    if (this.mOverflowTimer) {
      clearTimeout(this.mOverflowTimer);
    }
    this.isInOverflowState = false;
    this.mOverflowTimer = undefined;
  }

  /**
   * 判断溢出请求是否合法
   *
   * @param overflowInfo 溢出信息
   * @param cardDimension 卡片宫格占用信息
   * @param formItemWidth 卡片宽度
   * @param formItemHeight 卡片高度
   * @returns 是否允许溢出
   */
  public abstract canOverflow(overflowInfo: formInfo.OverflowInfo, cardDimension: number,
    formItemWidth: number, formItemHeight: number): boolean;

  /**
   * 处理溢出具体动效
   *
   * @param overflowInfo 溢出信息
   * @param formItemWidth 卡片宽度
   * @param formItemHeight 卡片高度
   */
  protected abstract handleOverflowStatus(overflowInfo: formInfo.OverflowInfo, formItemWidth: number,
    formItemHeight: number, isLongActiveForm: boolean): void;


  /**
   * 判断 OverflowInfo 数据是否有效
   *
   * @param overflowInfo 从 requestOverflow 接口带过来的请求信息
   * @returns True 表示 overflowInfo 是合法的
   */
  protected isOverflowInfoAvailable(overflowInfo: formInfo.OverflowInfo): boolean {
    if (!overflowInfo || overflowInfo.duration <= 0 || !overflowInfo.area) {
      log.showError('canOverflow: overflowInfo is invalid');
      return false;
    }
    return true;
  }

  /**
   * 判断请求的溢出区域是否超出允许区域
   *
   * @param area 溢出区域
   * @param cardDimension 卡片宫格占用信息
   * @param formItemWidth 卡片宽度
   * @param formItemHeight 卡片高度
   * @returns 是否超出允许区域
   */
  protected isOverflowValid(area: formInfo.Rect, cardDimension: number, formItemWidth: number,
    formItemHeight: number): boolean {
    if (CheckEmptyUtils.isEmpty(area.left) || CheckEmptyUtils.isEmpty(area.top) ||
      CheckEmptyUtils.isEmpty(area.width) || CheckEmptyUtils.isEmpty(area.height)) {
      log.showError('isOverflowValid data invalid');
      return false;
    }

    let isLegalPosition: boolean =
      OverflowFormUtils.isSmallerOrEqual(area.left, 0) && OverflowFormUtils.isSmallerOrEqual(area.top, 0);
    if (!isLegalPosition) {
      log.showError('isOverflowValid left or top invalid');
      return false;
    }
    let isLegalSize: boolean = OverflowFormUtils.isBiggerOrEqual(area.width + area.left, formItemWidth) &&
      OverflowFormUtils.isBiggerOrEqual(area.top + area.height, formItemHeight);
    if (!isLegalSize) {
      log.showError('isOverflowValid fail for area do not contain form');
      return false;
    }
    return true;
  }
}