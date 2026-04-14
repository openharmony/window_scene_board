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

import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import type { LivePositionName, LiveUsageScene } from '../../common/LiveConstants';
import { LiveExtendType, LivePropertyName, LiveViewCommonConstants } from '../../common/LiveConstants';
import type { ILiveExtendData } from '../../common/ILiveExtendData';
import { BaseExtendProperty } from '../../../base/common/info/BaseExtendProperty';

const timeTemplateReg = /\$\{placeholder.timer\}/g;
const TAG = LiveViewCommonConstants.LOG_PREFIX + 'LiveTimerData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 实况卡片、胶囊扩展数据，计时器信息
 */
@Observed
export class LiveTimerData extends BaseExtendProperty implements ILiveExtendData {
  /**
   * 计时初始值，单位ms
   * 一般用于倒计时，计时归0后回调应用
   */
  initialTime?: number;

  /**
   * 是否倒计时，默认正计时
   */
  isCountDown: boolean = false;

  /**
   * 是否暂停计时，默认false
   */
  isPause: boolean = false;

  /**
   * 是否在标题显示，默认true
   * 主要用于实况卡片，计时器显示位置是标题或副文本
   */
  isInTitle: boolean = true;

  /**
   * 计时器胶囊时间是否更新
   */
  isUpdateTimer: boolean = true;

  /**
   * 通知启动计时器时的时间与通知通知发送时的时间差
   */
  diffTime?: number;

  private updateTimeCallbacks?: ((remainingTime: number) => void)[] = [];

  /**
   * 时间数据更新时执行回调更新值
   * @param callback
   */
  public addUpdateTimeCallback(callback: ((remainingTime: number) => void)): void {
    log.showInfo(`addUpdateTimeCallback, callbacks length: ${this.updateTimeCallbacks?.length + 1}`);
    this.updateTimeCallbacks?.push(callback);
  }

  /**
   * 时间数据更新时执行回调更新值
   * @param callback
   */
  public removeUpdateTimeCallback(callback: ((remainingTime: number) => void)): void {
    const index = this.updateTimeCallbacks?.indexOf(callback);
    if (index !== undefined && index !== -1) {
      log.showInfo(`removeUpdateTimeCallback, callbacks length: ${this.updateTimeCallbacks?.length}`);
      this.updateTimeCallbacks?.splice(index, 1);
    }
  }

  /**
   * 每次倒计时更新时的回调函数
   *
   * @param remainingTime 更新后的时间
   */
  onTick(remainingTime: number): void {
    this.initialTime = remainingTime;
    this.updateTimeCallbacks?.forEach(callback => {
      callback(remainingTime);
    });
  }

  /**
   * 复写接口ILiveExtendData
   *
   * @returns 计时器类型
   */
  getLiveExtendType(): LiveExtendType {
    return LiveExtendType.TYPE_COMMON_TIMER;
  }

  /**
   * 复写接口ILiveUpdatable
   *
   * @param other 更新源数据
   * @param forceRefresh 是否强制刷新
   */
  update(other: object, forceRefresh?: boolean): void {
    if (!(other instanceof LiveTimerData)) {
      return;
    }
    let otherTimer = other as LiveTimerData;
    if (otherTimer.isUpdateTimer) {
      this.setInitialTime(otherTimer.initialTime, forceRefresh);
    }
    this.setCountDown(otherTimer.isCountDown, forceRefresh);
    this.setPause(otherTimer.isPause, forceRefresh);
    this.setIsUpdateTimer(otherTimer.isUpdateTimer, forceRefresh);
    this.setInTitle(otherTimer.isInTitle, forceRefresh);
  }

  /**
   * 设置倒计时初始值
   *
   * @param initialTime 初始值
   * @param forceRefresh 是否强制刷新
   */
  setInitialTime(initialTime?: number, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(initialTime)) {
      this.initialTime = initialTime;
      this.updateTimeCallbacks?.forEach(callback => {
        callback(initialTime);
      });
    }
  }

  /**
   * 设置是否更新胶囊时间
   *
   * @param isUpdateTimer 是否更新胶囊时间
   * @param forceRefresh 是否强制刷新
   */
  setIsUpdateTimer(isUpdateTimer?: boolean, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(isUpdateTimer)) {
      this.isUpdateTimer = isUpdateTimer;
    }
  }

  /**
   * 设置是否为倒计时
   *
   * @param isCountDown true倒计时
   * @param forceRefresh 是否强制刷新
   */
  setCountDown(isCountDown?: boolean, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(isCountDown)) {
      this.isCountDown = isCountDown;
    }
  }

  /**
   * 设置是否暂停计时器
   *
   * @param isPause true暂停计时器
   * @param forceRefresh 是否强制刷新
   */
  setPause(isPause?: boolean, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(isPause)) {
      this.isPause = isPause;
    }
  }

  /**
   * 设置计时器是否显示在标题位置
   *
   * @param isInTitle true显示在标题位置，false显示在副文本位置
   * @param forceRefresh 是否强制刷新
   */
  setInTitle(isInTitle?: boolean, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(isInTitle)) {
      this.isInTitle = isInTitle;
    }
  }

  /**
   * 设置计时器文本颜色
   *
   * @param scene 场景，实况卡片或胶囊
   * @param position 位置，标题或副文本
   * @param color 文本颜色
   */
  setTimerTextColor(scene: LiveUsageScene, position: LivePositionName, color?: string): void {
    this.setExtendPropertyValue(LivePropertyName.TEXT_COLOR, color, scene, position);
  }

  /**
   * 获取计时器文本颜色
   *
   * @param scene 场景
   * @param position 位置
   * @returns 文本颜色
   */
  getTimerTextColor(scene: LiveUsageScene, position: LivePositionName): string | undefined {
    let color = this.getExtendPropertyValue(LivePropertyName.TEXT_COLOR, scene, position);
    if (CommonUtils.isString(color as string)) {
      return color as string;
    }
    return undefined;
  }

  transformTimerText(text: string, timer: LiveTimerData): string {
    const timeString = LiveViewCommonConstants.formatDate(timer?.initialTime, new Date(), timer?.isCountDown ?? false);
    return text.replace(timeTemplateReg, timeString);
  }
}