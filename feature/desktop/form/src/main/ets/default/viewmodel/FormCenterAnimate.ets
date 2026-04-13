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
import curves from '@ohos.curves';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { desktopUtil } from '@ohos/componenthelper';
import { CardItemInfo, StyleConstants } from '@ohos/launchercommon';
import { FormStyleConfig } from '../common/FormStyleConfig';
import { AppFormItemData, NavDestinationViewData, RecommendFormItemData } from './FormCenterObservedData';
import { AppFormsViewData, FormCenterViewData } from './FormCenterViewData';

const TAG: string = 'FormCenterAnimate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

enum CardArea {
  SMALL,
  MIDDLE,
  LARGE
};

interface CardAnimParams {
  params: AnimateParam;
  scale: number;
};

export class FormCenterAnimateUtil {
  public static mInstance: FormCenterAnimateUtil;

  public static getInstance(): FormCenterAnimateUtil {
    if (FormCenterAnimateUtil.mInstance == null) {
      FormCenterAnimateUtil.mInstance = new FormCenterAnimateUtil();
    }
    return FormCenterAnimateUtil.mInstance;
  }

  private getFormArea(cardDimension: number): number {
    switch (cardDimension) {
      case FormDimension.Dimension_1_2:
      case FormDimension.Dimension_2_1:
        return CardArea.SMALL;
      case FormDimension.Dimension_2_2:
      case FormDimension.Dimension_2_4:
        return CardArea.MIDDLE;
      case FormDimension.Dimension_4_4:
      default:
        return CardArea.LARGE;
    }
  }

  public getPressAnimParams(isZoomOut: boolean, cardDimension: number): CardAnimParams {
    let params: CardAnimParams = { params: { playMode: PlayMode.Normal }, scale: 1 };
    let area = this.getFormArea(cardDimension);
    if (!isZoomOut) {
      params.params.duration = 250;
      params.params.curve = Curve.Friction;
      return params;
    }
    if (area === CardArea.SMALL) {
      params.params.curve = curves.interpolatingSpring(1, 1, 410, 38);
      params.scale = StyleConstants.DEFAULT_LONG_PRESS_SCALE_90;
    } else if (area === CardArea.MIDDLE) {
      params.params.curve = curves.interpolatingSpring(0.5, 1, 350, 35);
      params.scale = StyleConstants.DEFAULT_LONG_PRESS_SCALE_95;
    } else {
      params.params.curve = curves.interpolatingSpring(0, 1, 240, 28);
      params.scale = StyleConstants.DEFAULT_LONG_PRESS_SCALE_95;
    }
    return params;
  }
}

export class RecommendFormsAnimate {
  private mFormList: CardItemInfo[] = [];
  private mAnimateData: RecommendFormItemData[] = [];

  public initData(formList: CardItemInfo[], animateData: RecommendFormItemData[]): void {
    this.mFormList = formList;
    this.mAnimateData = animateData;
    this.mFormList.forEach(() => {
      let item: RecommendFormItemData = new RecommendFormItemData();
      item.animateScale = 1;
      this.mAnimateData.push(item);
    })
  }

  public scaleAnimate(isZoomOut: boolean, index: number, recommendScale: number, isTouchUp?: boolean): void {
    if (this.mFormList.length <= 0 || index < 0 || index >= this.mFormList.length) {
      log.showWarn(`error: listSize ${this.mFormList.length} index ${index}`);
      return;
    }
    let animateUtil = FormCenterAnimateUtil.getInstance();
    let params: CardAnimParams = animateUtil.getPressAnimParams(isZoomOut, this.mFormList[index].cardDimension);
    animateTo(params.params, () => {
      if (isTouchUp) {
        this.mAnimateData[index].animateScale = params.scale;
      } else {
        this.mAnimateData[index].animateScale = params.scale * recommendScale;
      }
    });
  }
}

export class AppFormsAnimate {
  private mViewData: AppFormsViewData = new AppFormsViewData();
  private mNavDestinationViewData: NavDestinationViewData = new NavDestinationViewData();
  private animateData: AppFormItemData[] = [];
  private mFormStyleConfig: FormStyleConfig | undefined = undefined;
  private mGetFormSize: (cardDimension: number) => Size = () => { return { width: 0, height: 0 } };

  public initData(
    viewData: AppFormsViewData,
    navDestinationViewData: NavDestinationViewData,
    animateData: AppFormItemData[],
    getFormSize: (cardDimension: number) => Size
  ): void {
    this.mViewData = viewData;
    this.mNavDestinationViewData = navDestinationViewData;
    this.animateData = animateData;
    this.mGetFormSize = getFormSize;
    for (let index: number = 0; index < this.animateData.length; index++) {
      this.animateData[index] = new AppFormItemData();
    }
    this.mFormStyleConfig = FormStyleConfig.getInstance();
  }

  public scaleAnimate(isZoomOut: boolean, index: number): void {
    if (this.mViewData.appFormList.length <= 0 || index < 0 || index >= this.mViewData.appFormList.length) {
      log.showWarn(`error: listSize ${this.mViewData.appFormList.length} index ${index}`);
      return;
    }
    let animateUtil = FormCenterAnimateUtil.getInstance();
    let params: CardAnimParams =
      animateUtil.getPressAnimParams(isZoomOut, this.mViewData.appFormList[index].cardDimension);
    animateTo(params.params, () => {
      this.animateData[index].animateScale = params.scale;
    });
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
      log.showInfo('calculateOffSet left:%{public}d, %{public}d', left, this.animateData[left].offset);
    }

    if (this.isIndexValid(targetIndex)) {
      this.formOffsetAnimate(targetIndex, this.getFormOffset(targetIndex) / 2, true, velocity);
      log.showInfo('calculateOffSet targetIndex:%{public}d, %{public}d',
        targetIndex, this.animateData[targetIndex].offset);
    }

    if (this.isIndexValid(right)) {
      this.formOffsetAnimate(right, 0, false, velocity);
      log.showInfo('calculateOffSet right:%{public}d, %{public}d', right, this.animateData[right].offset);
    }
  }

  private formOffsetAnimate(index: number, offset: number, isMiddle: boolean, velocity: number): void {
    if (velocity !== 0) {
      animateTo({
        curve: isMiddle ? curves.springMotion(0.468, 0.82) : curves.springMotion(0.33, 1),
      }, () => {
        this.animateData[index].offset = offset;
      })
    } else {
      this.animateData[index].offset = offset;
    }
  }

  /**
   * 索引是否合法
   * @param index 索引
   * @returns 是否合法
   */
  private isIndexValid(index: number): boolean {
    return index >= 0 && index < (this.mViewData?.appFormList.length as number);
  }

  /**
   * 获取卡片在视图坐标露出时，相对偏移量
   * @param index 卡片位置索引
   * @returns 偏移量
   */
  private getFormOffset(index: number): number {
    let dimension: number = this.mViewData?.appFormList[index].cardDimension as number;
    let width: number = this.mGetFormSize(dimension).width;
    let offset: number =
      this.mNavDestinationViewData.viewWidth - width - 2 * this.mNavDestinationViewData.cardViewMargin;
    log.showInfo(`get form ${index} dimension: ` + dimension + ' width: ' + width + ' offset: ' + offset);
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
      log.showDebug('formOffset[currentIndex]:%{public}d', this.animateData[currentIndex].offset);
      if (this.isIndexValid(right)) {
        this.updateFormOffsetAnimate(false, right, (-currentOffset / distance) * (this.getFormOffset(right) / 2));
        log.showDebug('formOffset[right]:%{public}d', this.animateData[right].offset);
      }
      if (this.isIndexValid(right + 1)) {
        this.updateFormOffsetAnimate(false, right + 1, 0);
        log.showDebug('formOffset[right+1]:%{public}d', this.animateData[right + 1].offset);
      }
    } else {
      if (this.isIndexValid(right)) {
        this.updateFormOffsetAnimate(false, right, 0);
      }
      this.updateFormOffsetAnimate(true, currentIndex,
        (1 - currentOffset / distance) * this.getFormOffset(currentIndex) / 2);
      log.showDebug('formOffset[currentIndex]:%{public}d', this.animateData[currentIndex].offset);
      if (this.isIndexValid(left)) {
        this.updateFormOffsetAnimate(false, left, this.getFormOffset(left) * (1 - currentOffset / distance / 2));
        log.showDebug('formOffset[left]:%{public}d', this.animateData[left].offset);
      }
      if (this.isIndexValid(left - 1)) {
        this.updateFormOffsetAnimate(false, left - 1, this.getFormOffset(left - 1));
        log.showDebug('formOffset[left-1]:%{public}d', this.animateData[left - 1].offset);
      }
    }
  }

  private updateFormOffsetAnimate(isMiddle: boolean, index: number, offset: number): void {
    animateTo({
      curve: isMiddle ? curves.responsiveSpringMotion(0.468, 0.82) : curves.responsiveSpringMotion(0.33, 1),
    }, () => {
      this.animateData[index].offset = offset;
    })
  }
}
