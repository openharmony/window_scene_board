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

import formInfo from '@ohos/windowsceneinterfaces/src/main/ets/interfaces/@ohos.app.form.formInfo';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { AbstractOverflowPolicy } from './AbstractOverflowPolicy';
import { OverflowThresholdConfig } from '../../common/OverflowThresholdConfig';

const TAG: string = 'OverflowNoLimitPolicy';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 系统应用管控策略
 */
export class OverflowNoLimitPolicy extends AbstractOverflowPolicy {
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
    return this.isOverflowValid(overflowInfo.area, cardDimension, formItemWidth, formItemHeight);
  }

  /**
   * 处理溢出具体动效
   *
   * @param overflowInfo 溢出信息
   * @param formItemWidth 卡片宽度
   * @param formItemHeight 卡片高度
   */
  protected handleOverflowStatus(overflowInfo: formInfo.OverflowInfo, formItemWidth: number,
    formItemHeight: number, isLongActiveForm: boolean): void {
    log.showInfo('handleOverflowStatus');
    if (this.isInOverflowState) {
      log.showInfo('handleOverflowStatus is already overflow');
      return;
    }
    let duration: number = overflowInfo.duration === undefined ? 0 : overflowInfo.duration;

    // 系统应用的长时激活卡片，发起长时溢出请求时，不限制溢出时间
    log.showInfo('handleOverflowStatus isLongActiveForm: %{public}s, duration: %{public}d', isLongActiveForm, duration);
    if (!isLongActiveForm || duration < OverflowThresholdConfig.getInstance().getLongOverflowProtectedDuration()) {
      this.startOverflowTimer(duration);
    }
    this.isInOverflowState = true;
  }
}