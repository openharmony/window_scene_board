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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import formInfo from '@ohos/windowsceneinterfaces/src/main/ets/interfaces/@ohos.app.form.formInfo';
import { AbstractOverflowPolicy } from './AbstractOverflowPolicy';
import OverflowFormUtils from '../../common/OverflowFormUtils';
import { OverflowThresholdConfig } from '../../common/OverflowThresholdConfig';

const TAG: string = 'OverflowDefaultPolicy';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 三方应用管控策略
 */
export class OverflowDefaultPolicy extends AbstractOverflowPolicy {
  /**
   * 判断溢出请求是否合法
   *
   * @param overflowInfo 溢出休息
   * @param cardDimension 卡片宫格占用信息
   * @param formItemWidth 卡片宽度
   * @param formItemHeight 卡片高度
   * @returns 是否允许溢出
   */
  public canOverflow(overflowInfo: formInfo.OverflowInfo, cardDimension: number,
    formItemWidth: number, formItemHeight: number): boolean {
    if (!this.isOverflowInfoAvailable(overflowInfo)) {
      return false;
    }
    let duration: number = overflowInfo.duration;
    if (duration > OverflowThresholdConfig.getInstance().getOverflowMaxDuration()) {
      log.showError(`canOverflow: overflow duration is out of range:` +
        `${OverflowThresholdConfig.getInstance().getOverflowMaxDuration()}`);
      return false;
    }
    return this.isOverflowValid(overflowInfo.area, cardDimension, formItemWidth, formItemHeight);
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
    if (!super.isOverflowValid(area, cardDimension, formItemWidth, formItemHeight)) {
      log.showError('isOverflowValid data invalid');
      return false;
    }
    let scaleRatio: number[] | undefined =
      OverflowThresholdConfig.getInstance().getOverflowScaleRatio(cardDimension);
    if (!scaleRatio) {
      log.showError('isOverRangeValid, scaleRatio is undefined');
      return false;
    }
    if (scaleRatio.length !== 2) {
      log.showError('isOverRangeValid, the length of scaleRatio is not equal to 2');
      return false;
    }
    let overflowWidth: number = formItemWidth * scaleRatio[0];
    let overflowHeight: number = formItemHeight * scaleRatio[1];
    let overflowWidthHalf: number = (overflowWidth - formItemWidth) / 2.0;
    let overflowHeightHalf: number = (overflowHeight - formItemHeight) / 2.0;
    log.showInfo('isOverRangeValid, scaleRatio:%{public}d, overflowWidthHalf:%{public}d, overflowHeightHalf:%{public}d',
      scaleRatio, overflowWidthHalf, overflowHeightHalf);
    let isLegalLeft: boolean = OverflowFormUtils.isBiggerOrEqual(area.left, -overflowWidthHalf) &&
      OverflowFormUtils.isSmallerOrEqual(area.left, 0);
    let isLegalTop: boolean = OverflowFormUtils.isBiggerOrEqual(area.top, -overflowHeightHalf) &&
      OverflowFormUtils.isSmallerOrEqual(area.top, 0);
    let isLegalPosition: boolean = isLegalLeft && isLegalTop;
    let isLegalWidth: boolean = OverflowFormUtils.isBiggerOrEqual(area.width + area.left, formItemWidth) &&
      OverflowFormUtils.isSmallerOrEqual(area.width + area.left, formItemWidth + overflowWidthHalf);
    let isLegalHeight: boolean = OverflowFormUtils.isBiggerOrEqual(area.top + area.height, formItemHeight) &&
      OverflowFormUtils.isSmallerOrEqual(area.top + area.height, formItemHeight + overflowHeightHalf);

    if (isLegalPosition && isLegalWidth && isLegalHeight) {
      return true;
    }
    log.showError('isOverflowValid fail for area out of range');
    return false;
  }

  protected handleOverflowStatus(overflowInfo: formInfo.OverflowInfo, formItemWidth: number,
    formItemHeight: number, isLongActiveForm: boolean): void {
    log.showInfo('handleOverflowStatus');
    if (this.isInOverflowState) {
      log.showInfo('handleOverflowStatus is already overflow');
      return;
    }
    let duration: number = Math.min(
      overflowInfo.duration ?? OverflowThresholdConfig.getInstance().getOverflowMaxDuration(),
      OverflowThresholdConfig.getInstance().getOverflowMaxDuration()
    );
    this.startOverflowTimer(duration);
    this.isInOverflowState = true;
  }
}