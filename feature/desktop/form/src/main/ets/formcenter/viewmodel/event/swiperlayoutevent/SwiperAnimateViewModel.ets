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

import { AttributeUpdater, curves, LengthMetrics } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SwiperLayoutViewData } from '../../data/SwiperLayoutViewData';
import { NavDestinationViewData } from '../../../../default/viewmodel/FormCenterObservedData';

const TAG = 'SwiperFormAnimate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);


export class SwiperFormAnimate {
  private mViewData: SwiperLayoutViewData = new SwiperLayoutViewData();
  private mNavDestinationViewData: NavDestinationViewData = new NavDestinationViewData();
  private animateModifierList: AttributeUpdater<CommonAttribute>[] = [];
  private formWidthList: number[] = [];

  public initData(
    viewData: SwiperLayoutViewData,
    navDestinationViewData: NavDestinationViewData,
    animateModifierList: AttributeUpdater<CommonAttribute>[],
  ): void {
    this.mViewData = viewData;
    this.mNavDestinationViewData = navDestinationViewData;
    this.animateModifierList = animateModifierList;
  }

  public destroyData(): void {
    this.mViewData = new SwiperLayoutViewData();
    this.mNavDestinationViewData = new NavDestinationViewData();
    this.animateModifierList = [];
    this.formWidthList = [];
  }

  public setFormWidth(index: number, width: number): void {
    this.formWidthList[index] = width;
  }

  public getStartOffset(index: number): number {
    let offset: number = this.getFormOffset(index);
    if (index === this.mViewData.swipeTargetIndex - 1) {
    } else if (index === this.mViewData.swipeTargetIndex) {
      offset /= 2;
    } else {
      offset = 0;
    }
    return offset;
  }

  /**
   * 计算卡片偏移量和动画延时（左中右卡片）
   * @param targetIndex 目标索引
   * @param velocity 速度
   */
  public calculateOffSet(targetIndex: number, velocity: number): void {
    let left = targetIndex - 1;
    let right = targetIndex + 1;

    // 计算偏移量
    if (this.isIndexValid(left)) {
      this.formOffsetAnimate(left, this.getFormOffset(left), false, velocity);
    }

    if (this.isIndexValid(targetIndex)) {
      this.formOffsetAnimate(targetIndex, this.getFormOffset(targetIndex) / 2, true, velocity);
    }

    if (this.isIndexValid(right)) {
      this.formOffsetAnimate(right, 0, false, velocity);
    }
  }

  private formOffsetAnimate(index: number, offset: number, isMiddle: boolean, velocity: number): void {
    log.showInfo('calculateOffSet index:%{public}d, %{public}d', index, offset);
    if (velocity !== 0) {
      animateTo({
        curve: isMiddle ? curves.springMotion(0.468, 0.82) : curves.springMotion(0.33, 1),
      }, () => {
        this.animateModifierList[index]?.attribute?.margin({ start: LengthMetrics.vp(offset) })
      })
    } else {
      this.animateModifierList[index]?.attribute?.margin({ start: LengthMetrics.vp(offset) })
    }
  }

  /**
   * 索引是否合法
   * @param index 索引
   * @returns 是否合法
   */
  private isIndexValid(index: number): boolean {
    return index >= 0 && index < (this.mViewData?.appFormList.length ?? 0);
  }

  /**
   * 获取卡片在视图坐标露出时，相对偏移量
   * @param index 卡片位置索引
   * @returns 偏移量
   */
  public getFormOffset(index: number): number {
    let dimension: number = this.mViewData?.appFormList[index]?.cardDimension ?? 0;
    let width: number = this.formWidthList[index] ?? 0;
    let offset: number =
      this.mNavDestinationViewData.viewWidth - width - 2 * this.mNavDestinationViewData.cardViewMargin;
    return offset;
  }

  /**
   * 滑动中更新卡片偏移
   * @param index
   * @param currentOffset
   */
  public updateFormOffset(currentIndex: number, currentOffset: number): void {
    if (!this.isIndexValid(currentIndex)) {
      log.showError('updateFormOffset, currentIndex invalid');
      return;
    }
    let left = currentIndex - 1;
    let right = currentIndex + 1;
    currentOffset -= this.mNavDestinationViewData.cardViewMargin;

    // 滑动距离
    let distance = this.mNavDestinationViewData.viewWidth - 2 * this.mNavDestinationViewData.cardViewMargin;
    if (distance == 0 || currentOffset == 0) {
      log.showWarn('distance or currentOffset is zero');
      return;
    }

    // currentOffset为负是向左滑动，计算右边卡片偏移
    if (currentOffset < 0) {
      if (this.isIndexValid(left)) {
        this.updateFormOffsetAnimate(false, left, this.getFormOffset(left) * (1 + currentOffset / distance));
      }
      this.updateFormOffsetAnimate(true, currentIndex,
        (1 - currentOffset / distance) * this.getFormOffset(currentIndex) / 2);
      if (this.isIndexValid(right)) {
        this.updateFormOffsetAnimate(false, right, (-currentOffset / distance) * (this.getFormOffset(right) / 2));
      }
      if (this.isIndexValid(right + 1)) {
        this.updateFormOffsetAnimate(false, right + 1, 0);
      }
    } else {
      if (this.isIndexValid(right)) {
        this.updateFormOffsetAnimate(false, right, 0);
      }
      this.updateFormOffsetAnimate(true, currentIndex,
        (1 - currentOffset / distance) * this.getFormOffset(currentIndex) / 2);
      if (this.isIndexValid(left)) {
        this.updateFormOffsetAnimate(false, left, this.getFormOffset(left) * (1 - currentOffset / distance / 2));
      }
      if (this.isIndexValid(left - 1)) {
        this.updateFormOffsetAnimate(false, left - 1, this.getFormOffset(left - 1));
      }
    }
  }

  private updateFormOffsetAnimate(isMiddle: boolean, index: number, offset: number): void {
    log.showDebug('formOffset[%{public}%d]:%{public}d', index, offset);
    animateTo({
      curve: isMiddle ? curves.responsiveSpringMotion(0.468, 0.82) : curves.responsiveSpringMotion(0.33, 1),
    }, () => {
      this.animateModifierList[index]?.attribute?.margin({ start: LengthMetrics.vp(offset) });
    })
  }
}