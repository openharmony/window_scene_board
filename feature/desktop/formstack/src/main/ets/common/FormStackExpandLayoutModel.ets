/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { FormStackConstants } from './FormStackConstants';
import type { FormStackExpandConfig } from './FormStackExpandConfig';
import { CommonConstants } from '@ohos/launchercommon';

const TAG: string = 'FormStackExpandLayoutModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormStackExpandLayoutModel {
  public mFormHeight: number = 0;
  public mShowMaxCount: number = 0;
  public mShowRatio: number = 0;
  public mChildCount: number = 0;
  public mShowSizePerPage: number = 0;
  public mPreShowSize: number = 0;
  public mDeltaRotation: number = 0;
  public mFormFirstRotationX: number = 0;
  public mChildInitRotationList: number[] = [];
  public mChildInitTranslateYList: number[] = [];
  public mChildEndTranslateYList: number[] = [];
  public mDisplayWidth: number = 0;
  public mLastChildEndTransValue: number = 0;
  public mLastShowItemIndex: number = 0;

  public mChildRestoreTransYList: number[] = [];
  public mChildRestoreRotateList: number[] = [];
  public mChildRestoreScaleList: number[] = [];
  public mChildRestoreVisibilityList: boolean[] = [];
  public mDragItemId: string = '';
  public mLongPressAvoidDistance: number = 0;

  private mDisplayHeight: number = 0;
  private mLayoutType: number = CommonConstants.CARD_DIMENSION_2x2;
  public mIsOuterDesktop: boolean = false;

  public initData(config: FormStackExpandConfig): void {
    this.mChildInitRotationList = [];
    this.mChildInitTranslateYList = [];
    this.mChildEndTranslateYList = [];
    this.mChildCount = config.mChildCount;
    this.mDisplayWidth = config.mDisplayWidth;
    this.mDisplayHeight = config.mDisplayHeight;
    this.mLayoutType = config.mLayoutType;
    // 展开态数据初始化使用实际展示大小
    this.mFormHeight = config.mFormShowHeight;
    this.mPreShowSize = config.mPreShowSize;
    this.mLastShowItemIndex = this.mChildCount - 1;
    this.mDeltaRotation = (FormStackConstants.FORM_DELTA_ROTATION_X.get(this.mLayoutType) as number);
    this.mFormFirstRotationX = FormStackConstants.FORM_START_ROTATION_X.get(this.mLayoutType) as number;
    this.mShowMaxCount = config.mMaxShowCount;
    this.mChildRestoreTransYList = [];
    this.mChildRestoreRotateList = [];
    this.mChildRestoreScaleList = [];
    this.mChildRestoreVisibilityList = [];
  }

  public resetData(): void {
    this.mDisplayWidth = 0;
    this.mDisplayHeight = 0;
    this.mFormHeight = 0;
    this.mShowMaxCount = 0;
    this.mShowRatio = 0;
    this.mChildCount = 0;
    this.mShowSizePerPage = 0;
    this.mPreShowSize = 0;
    this.mDeltaRotation = 0;
    this.mFormFirstRotationX = 0;
    this.mLastChildEndTransValue = 0;
    this.mChildInitRotationList = [];
    this.mChildInitTranslateYList = [];
    this.mChildEndTranslateYList = [];
    this.mChildRestoreTransYList = [];
    this.mChildRestoreRotateList = [];
    this.mChildRestoreScaleList = [];
    this.mChildRestoreVisibilityList = [];
    this.mDragItemId = '';
    this.mLongPressAvoidDistance = 0;
  }

  public getChildStart(config: FormStackExpandConfig): number {
    let childStart: number = this.calculateChildStart(this.mDisplayHeight, this.mFormHeight,
      this.mPreShowSize, this.mChildCount);

    // 为了保证网格对齐, 需要加上一定的偏移量
    childStart += config.mMarginTop;
    log.showInfo(`childStart: ${childStart}.`);
    return childStart;
  }

  public updateChildStart(index: number, childStart: number): number {
    let ret: number = childStart;
    let distance = this.getDistanceBetweenCard(this.mLayoutType);
    if (index >= (this.mChildCount - this.mShowMaxCount - 1)) {
      ret += this.mFormHeight + this.getDeltaOffset(index) + distance;
    }
    log.showInfo(`index: ${index}, childStart: ${childStart}, updateChildStart: ${ret}.`);
    return ret;
  }

  public initTranslateY(index: number, childStart: number): void {
    this.mChildInitTranslateYList.push(childStart);
    this.mChildEndTranslateYList.push(this.getEndTranslateY(index));
    this.mChildRestoreTransYList.push(childStart);
  }

  public initRotate(index: number): number {
    let rotate: number = this.getRotationByIndex(index, this.mChildCount, this.mShowMaxCount);
    this.mChildInitRotationList.push(rotate);
    this.mChildRestoreRotateList.push(rotate);
    return rotate;
  }

  public initScale(scale: number): void {
    this.mChildRestoreScaleList.push(scale);
  }

  public initVisibility(visible: boolean): void {
    if (this.mChildRestoreVisibilityList.length < this.mChildCount) {
      this.mChildRestoreVisibilityList.push(visible);
    }
  }

  public initLastChildEndTranslateY(): void {
    if (this.mChildCount <= this.mShowMaxCount) {
      this.mLastChildEndTransValue = 0;
      return;
    }

    this.mLastChildEndTransValue = this.mShowSizePerPage * (this.mChildCount - this.mShowMaxCount);
    log.showInfo(`mLastChildEndTransValue: ${this.mLastChildEndTransValue}.`);
  }

  public cacheChildSlideStartAttr(index: number,
                                  translateY: number, rotate: number, scale: number, visibility: boolean): void {
    if (index < 0 || index > this.mChildRestoreTransYList.length || index > this.mChildRestoreRotateList.length ||
      index > this.mChildRestoreScaleList.length || index > this.mChildRestoreVisibilityList.length) {
      log.showError('index out of limit, cache child slide start attr failed');
      return;
    }

    this.mChildRestoreTransYList[index] = translateY;
    this.mChildRestoreRotateList[index] = rotate;
    this.mChildRestoreScaleList[index] = scale;
    this.mChildRestoreVisibilityList[index] = visibility;
  }

  public setDragItemId(idStr: string): void {
    this.mDragItemId = idStr;
  }

  public getItemDraggable(index: number): boolean {
    return this.mChildCount <= this.mShowMaxCount || index > (this.mLastShowItemIndex - this.mShowMaxCount);
  }

  private getEndTranslateY(index: number): number {
    if (this.mChildCount <= this.mShowMaxCount) {
      return 0;
    }

    if (index >= this.mChildCount - this.mShowMaxCount) {
      return (this.mChildCount - this.mShowMaxCount) * this.mShowSizePerPage;
    } else {
      return index * this.mShowSizePerPage + this.mPreShowSize;
    }
  }

  private getDeltaOffset(index: number): number {
    let maskFormSize: number = this.getFormMaskSize(index, this.mChildCount, this.mShowMaxCount, this.mFormHeight,
      this.mShowRatio);

    let firstOffset: number = this.mFormHeight - this.mPreShowSize;
    return index === this.mChildCount - this.mShowMaxCount - 1 ? -firstOffset : -maskFormSize;
  }

  private getRotationByIndex(index: number, childCount: number, showMaxCount: number): number {
    let deltaRotation: number = FormStackConstants.FORM_DELTA_ROTATION_X.get(this.mLayoutType) ??
      FormStackConstants.FORM_DELTA_DEFAULT_ROTATION_X;
    let formFirstRotationX: number = FormStackConstants.FORM_START_ROTATION_X.get(this.mLayoutType) ??
      FormStackConstants.FORM_FIRST_DEFAULT_ROTATION_X;

    if (childCount <= showMaxCount) {
      return formFirstRotationX + (index * deltaRotation);
    } else {
      return formFirstRotationX + Math.max(0, (index + 1) - childCount + showMaxCount) * deltaRotation;
    }
  }

  private calculateTotalShowSize(childCount: number, showCount: number, formHeight: number, showRatio: number): number {
    let totalShowSize: number = 0;
    if (childCount > showCount) {
      // 如果卡片总数比显示卡片多，则表明有堆叠卡片
      totalShowSize = this.mPreShowSize;
    }

    for (let index: number = 0; index < showCount; index++) {
      let rotation: number = Math.abs(this.getRotationByIndex(index, showCount, showCount));
      let showSize: number = formHeight * showRatio * (1.0 - rotation / FormStackConstants.RIGHT_ANGLE_ROTATION);
      if (index === showCount - 1) {
        showSize = formHeight * (1.0 - rotation / FormStackConstants.RIGHT_ANGLE_ROTATION);
      }
      totalShowSize = totalShowSize + showSize;
    }
    log.showInfo(`form stack total show size: ${totalShowSize}.`);

    if (this.mLayoutType === CommonConstants.CARD_DIMENSION_1x2) {
      totalShowSize += (showCount - 1) * FormStackConstants.DISTANCE_BETWEEN_FORM_AND_FORM;
    }
    return totalShowSize;
  }

  private calculateOuterShowRatio(): void {
    if (this.mLayoutType === CommonConstants.CARD_DIMENSION_1x2) {
      this.mShowRatio = FormStackConstants.OUTER_SHOW_RATIO_OF_1X2_FORM;
    } else if (this.mLayoutType === CommonConstants.CARD_DIMENSION_2x2) {
      this.mShowRatio = FormStackConstants.OUTER_SHOW_RATIO_OF_2X2_FORM;
    } else if (this.mLayoutType === CommonConstants.CARD_DIMENSION_2x4) {
      this.mShowRatio = FormStackConstants.OUTER_SHOW_RATIO_OF_2X4_FORM;
    } else {
      this.mShowRatio = FormStackConstants.OUTER_SHOW_RATIO_OF_4X4_FORM;
    }
  }

  private calculateChildStart(displayHeight: number, formHeight: number, preShowSize: number,
                              childCount: number): number {
    let showCount: number = this.mIsOuterDesktop ? childCount :
      this.calculateShowMaxCount(displayHeight, formHeight, preShowSize, childCount);
    this.mShowMaxCount = showCount > this.mShowMaxCount ? this.mShowMaxCount : showCount;
    if (this.mIsOuterDesktop) {
      this.calculateOuterShowRatio();
    }
    this.mLongPressAvoidDistance = this.mFormHeight * (1 - this.mShowRatio);
    if (this.mIsOuterDesktop) {
      this.mLongPressAvoidDistance /= 2;
    }
    log.showInfo(`maxShowCount: ${this.mShowMaxCount}, mShowRatio: ${this.mShowRatio}, ` +
      `mLongPressAvoidDistance: ${this.mLongPressAvoidDistance}.`);

    let childStart: number = (displayHeight - this.calculateTotalShowSize(childCount, this.mShowMaxCount, formHeight,
      this.mShowRatio)) / FormStackConstants.HEIGHT_DIVISION;

    log.showInfo(`form stack expand item start positionY: ${childStart}, displayHeight: ${displayHeight}.`);
    return childStart;
  }

  private calculateShowMaxCount(displayHeight: number, formHeight: number, preShowSize: number,
                                childCount: number): number {
    if (formHeight === 0 || childCount < FormStackConstants.FORM_STACK_ITEM_MIN_LEN) {
      return 0;
    }

    let maxShowRatio: number = (displayHeight - formHeight) / (formHeight * (childCount - 1));
    this.mShowRatio = FormStackConstants.SHOW_SIZE_MIN_RATIO;
    if (maxShowRatio - FormStackConstants.SHOW_SIZE_MIN_RATIO >= 0) {
      // 单卡片可显示区域大于50%，说明显示空间足够所有卡片显示
      this.mShowRatio = Math.min(maxShowRatio, FormStackConstants.SHOW_SIZE_MAX_RATIO);
      if (this.mLayoutType === CommonConstants.CARD_DIMENSION_1x2) {
        this.mShowRatio = FormStackConstants.SHOW_MAX_RATIO_OF_1X2_FORM;
      }
      return childCount;
    }

    // 单卡片可显示区域小于50%，显示空间不足所有卡片显示，需要堆叠部分卡片
    let maxShowCount: number = Math.floor(((displayHeight - formHeight) /
      (formHeight * FormStackConstants.SHOW_SIZE_MIN_RATIO)) + 1);
    if (maxShowCount > 1) {
      this.mShowRatio = Math.min((displayHeight - formHeight - preShowSize) / (formHeight * (maxShowCount - 1)),
        FormStackConstants.SHOW_SIZE_MAX_RATIO);
    }

    // 根据当前计算结果获取显示区域占用总高度
    let totalShowSize: number = this.calculateTotalShowSize(childCount, maxShowCount, formHeight, this.mShowRatio);
    let remainSize: number = displayHeight - totalShowSize;
    if (remainSize - formHeight >= 0) {
      // 如果剩余空间还比一个卡片高度大，则继续追加显示卡片个数
      let rotation: number = Math.abs(this.getRotationByIndex(childCount - 1, childCount, maxShowCount));

      // rotation角度产生会显示偏差比
      let rotationRatio: number = 1.0 - rotation / FormStackConstants.RIGHT_ANGLE_ROTATION;
      let appendCount: number = ((remainSize - (formHeight * rotationRatio)) / (formHeight * this.mShowRatio *
        rotationRatio)) + 1;
      maxShowCount = Math.min(childCount, maxShowCount + appendCount);
    }

    return maxShowCount;
  }

  private getFormMaskSize(index: number, childCount: number, showMaxCount: number, formHeight: number,
                          showRatio: number): number {
    let rotation: number = Math.abs(this.getRotationByIndex(index, childCount, showMaxCount));

    // 角度的旋转会导致卡片可见部分的高度缩小，此时需要根据角度计算出减小的高度值h0, 下一张卡片上移h0使其顶部紧贴上一张卡片底部
    let rotationOffset: number = Math.abs((rotation / FormStackConstants.RIGHT_ANGLE_ROTATION) * formHeight) * 0.5;

    // 下一张卡片覆盖上一张卡片数值也需要根据角度计算出实际需要上移覆盖数值
    let maskFormSize: number = this.mLayoutType === CommonConstants.CARD_DIMENSION_1x2 ? 0 :
      Math.abs((1.0 - rotation / FormStackConstants.RIGHT_ANGLE_ROTATION) * (formHeight * (1.0 - showRatio)));

    return maskFormSize + rotationOffset;
  }

  private getDistanceBetweenCard(cardDimension: number): number {
    return cardDimension === CommonConstants.CARD_DIMENSION_1x2 ? FormStackConstants.DISTANCE_BETWEEN_FORM_AND_FORM : 0;
  }
}