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

import { CommonUtils } from '@ohos/basicutils';
import { LiveExtendType } from '../../common/LiveConstants';
import type { ILiveExtendData } from '../../common/ILiveExtendData';
import { BaseExtendProperty } from '../../../base/common/info/BaseExtendProperty';

/**
 * 实况卡片、胶囊扩展数据，进度条信息
 */
@Observed
export class LiveProgressData extends BaseExtendProperty implements ILiveExtendData {
  /**
   * 最大值
   */
  maxValue?: number = 1;

  /**
   * 当前进度值
   */
  currentValue?: number = 0;

  /**
   * 是否显示为百分比
   */
  isPercentage?: boolean = false;

  /**
   * 胶囊进度环颜色
   */
  progressColor?: ResourceColor = '#0A59F7';

  /**
   * 复写接口ILiveExtendData
   *
   * @returns 进度类型
   */
  getLiveExtendType(): LiveExtendType {
    return LiveExtendType.TYPE_COMMON_PROGRESS;
  }

  /**
   * 复写接口ILiveUpdatable
   *
   * @param other 更新源数据
   * @param forceRefresh 是否强制刷新
   */
  update(other: object, forceRefresh?: boolean): void {
    if (!(other instanceof LiveProgressData)) {
      return;
    }
    let otherProgress = other as LiveProgressData;
    this.setMaxValue(otherProgress.maxValue, forceRefresh);
    this.setCurrentValue(otherProgress.currentValue, forceRefresh);
    this.setPercentage(otherProgress.isPercentage, forceRefresh);
  }

  /**
   * 设置最大值
   *
   * @param maxValue 最大值
   * @param forceRefresh 是否强制刷新
   */
  setMaxValue(maxValue?: number, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(maxValue)) {
      this.maxValue = maxValue;
    }
  }

  /**
   * 设置当前进度值
   *
   * @param currentValue 当前值
   * @param forceRefresh 是否强制刷新
   */
  setCurrentValue(currentValue?: number, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(currentValue)) {
      this.currentValue = currentValue;
    }
  }

  /**
   * 设置是否按百分比显示
   *
   * @param isPercentage true百分比显示
   * @param forceRefresh 是否强制刷新
   */
  setPercentage(isPercentage?: boolean, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(isPercentage)) {
      this.isPercentage = isPercentage;
    }
  }

  setProgressColor(color: ResourceColor): void {
    if (color) {
      this.progressColor = color;
    }
  }

  /**
   * 是否以百分比样式显示
   *
   * @returns true百分比样式
   */
  isShowPercentage(): boolean {
    // 默认使用百分比样式
    if (CommonUtils.isInvalid(this.isPercentage)) {
      return true;
    }
    return this.isPercentage;
  }

  toString(): string {
    return 'LiveProgressTemplate{' +
      ', maxValue:' + this.maxValue +
      ', currentValue:' + this.currentValue +
      ', isPercentage:' + this.isPercentage +
      '}';
  }
}