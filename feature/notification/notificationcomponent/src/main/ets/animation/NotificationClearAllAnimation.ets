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

import { AnimationNames } from '@ohos/systemuicommon/src/main/ets/animation/AnimationNames';
import { AnimateParams, AnimationBase } from '@ohos/systemuicommon/src/main/ets/animation/AnimationBase';
import curves from '@ohos.curves';
import { INotificationCardVm, INotificationClearButtonVm,
  INotificationMoreHeaderVm } from '@ohos/systemuicommon/newIndex';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { HiDfxEventUtil } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { ItemUtils } from '@ohos/componenthelper/src/main/ets/utils/ItemUtils';

const TAG = 'NotificationClearAllAnimation';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
/**
 * 一建删除按钮ID
 */
const CLEAR_BUTTON_ID: string = 'NotificationClearButtonView_button';
/**
 * 横屏通知列表list组件ID
 */
const LANDSCAPE_LIST_ID: string = '[Dropdown]NotificationListComponent';
/**
 * 位移动画曲线
 */
const TRANSLATE_ANIMATION_CURVE = curves.cubicBezierCurve(0.66, 0, 0.34, 1);
/**
 * 一键删除按钮动画曲线
 */
const CLEAR_BUTTON_ANIMATION_CURVE = curves.cubicBezierCurve(0.22, 0, 0.2, 1);

export interface ItemAnimateParams {
  index: number;
  itemId: string;
  delay: number;
  cardVm: INotificationCardVm;
  translateY?: number;
}

export interface MoreHeaderAnimateParams {
  delay: number;
  moreHeaderVm: INotificationMoreHeaderVm;
  translateY?: number;
}

/**
 * 一键清除动效，包括卡片的位移、缩放、翻转等
 *
 * @since 2024-11-19
 */
export class NotificationClearAllAnimation extends AnimationBase {
  /**
   * 每条通知卡片动效延迟时间
   */
  public static readonly delayPerItem: number = 33;
  /**
   * 删除按钮动效时长
   */
  public static readonly clearButtonAniDuration: number = 167;
  /**
   * 通知卡片vm列表
   */
  private cardVmArray: INotificationCardVm[] = [];
  /**
   * 是否横屏布局
   */
  public isLandscapeLayout: boolean = false;

  constructor() {
    super(AnimationNames.NTF_CLEAR_ALL_ANIMATION);
  }

  public addClearButtonAnimation(clearButtonVm: INotificationClearButtonVm): void {
    this.addAnimation(this.getClearButtonAnimation(clearButtonVm));
  }

  public addListItemAnimationDownwards(itemAnimationParams: ItemAnimateParams): void {
    this.cardVmArray.push(itemAnimationParams.cardVm);
    this.addAnimation(this.getListItemAnimationDownwards(itemAnimationParams));
  }

  public addListItemAnimationUpwards(itemAnimationParams: ItemAnimateParams): void {
    this.cardVmArray.push(itemAnimationParams.cardVm);
    this.addAnimation(this.getListItemAnimationUpwards(itemAnimationParams));
  }

  public addMoreHeaderDisappearAnimation(moreHeaderAnimationParams: MoreHeaderAnimateParams): void {
    this.addAnimation(this.getMoreHeaderDisappearAnimation(moreHeaderAnimationParams));
  }

  public addMoreHeaderAnimationUpwards(moreHeaderAnimationParams: MoreHeaderAnimateParams): void {
    this.addAnimation(this.getMoreHeaderAnimationUpwards(moreHeaderAnimationParams));
  }

  /**
   * 执行动画前进行打点
   */
  protected beforeAnimation(): void {
    super.beforeAnimation();
    HiDfxEventUtil.reportDeleteAllNotification();
  }

  protected afterAnimation(): void {
    super.afterAnimation();
    this.clearAnimations();
    this.cardVmArray.forEach((cardVm) => {
      cardVm?.reset();
    })
    this.cardVmArray = [];
  }

  /**
   * 垃圾桶整体： 1、先缩放到0.9倍，时长167ms；2、再放大到1.2倍，时长167ms；3、最后再缩到1倍，时长333ms，延迟500ms
   * 垃圾桶盖：1、先旋转30度，时长333ms，延迟167ms；2、再恢复到原来的状态，时长333ms，延迟500ms
   *
   * @returns 动效参数
   */
  private getClearButtonAnimation(clearButtonVm: INotificationClearButtonVm): AnimateParams[] {
    const animateParams: AnimateParams[] = [];
    animateParams.push(
      {
        duration: NotificationClearAllAnimation.clearButtonAniDuration,
        curve: CLEAR_BUTTON_ANIMATION_CURVE,
        event: () => clearButtonVm.updateClearButtonParams(0.9, undefined),
      },
      {
        duration: NotificationClearAllAnimation.clearButtonAniDuration,
        curve: CLEAR_BUTTON_ANIMATION_CURVE,
        delay: NotificationClearAllAnimation.clearButtonAniDuration,
        event: () => clearButtonVm.updateClearButtonParams(1.2, undefined),
      },
      {
        duration: 333,
        curve: CLEAR_BUTTON_ANIMATION_CURVE,
        delay: NotificationClearAllAnimation.clearButtonAniDuration,
        event: () => clearButtonVm.updateClearButtonParams(undefined, 30),
      },
      {
        duration: 333,
        curve: CLEAR_BUTTON_ANIMATION_CURVE,
        delay: 500,
        event: () => clearButtonVm.updateClearButtonParams(1, 0),
      },
    );
    return animateParams;
  }

  /**
   * 通知卡片向下位移动效
   */
  private getListItemAnimationDownwards(itemAnimationParams: ItemAnimateParams): AnimateParams[] {
    const animateParams: AnimateParams[] = [];
    const cardVm = itemAnimationParams.cardVm!;

    animateParams.push(
      // 位移、缩放
      {
        curve: TRANSLATE_ANIMATION_CURVE,
        duration: 333,
        delay: itemAnimationParams.delay,
        event: () => cardVm.clearAllAnimation(0.4, undefined, this.getTranslateYDownwards(itemAnimationParams.itemId)),
      },
      // 透明度
      {
        curve: TRANSLATE_ANIMATION_CURVE,
        duration: 222,
        delay: itemAnimationParams.delay,
        event: () => cardVm.clearAllAnimation(undefined, 0, undefined),
      },
    );
    return animateParams;
  }

  /**
   * 更多通知标题原地消失动效
   */
  private getMoreHeaderDisappearAnimation(moreHeaderAnimationParams: MoreHeaderAnimateParams): AnimateParams[] {
    const animateParams: AnimateParams[] = [];
    const moreHeaderVm = moreHeaderAnimationParams.moreHeaderVm;
    animateParams.push(
      // 透明度
      {
        curve: Curve.Sharp,
        duration: 150,
        delay: moreHeaderAnimationParams.delay,
        event: () => moreHeaderVm?.clearAllAnimation(undefined, 0, undefined),
      },
    );
    return animateParams;
  }

  /**
   * 通知卡片向上位移动效
   */
  private getListItemAnimationUpwards(itemAnimationParams: ItemAnimateParams): AnimateParams[] {
    const animateParams: AnimateParams[] = [];
    const cardVm = itemAnimationParams.cardVm!;
    animateParams.push(
      // 位移
      {
        curve: TRANSLATE_ANIMATION_CURVE,
        delay: itemAnimationParams.delay,
        duration: 333,
        event: () => cardVm.clearAllAnimation(1, 1, itemAnimationParams.translateY),
      },
    );
    return animateParams;
  }

  /**
   * 更多通知标题向上位移动效
   */
  private getMoreHeaderAnimationUpwards(moreHeaderAnimationParams: MoreHeaderAnimateParams): AnimateParams[] {
    const animateParams: AnimateParams[] = [];
    const moreHeaderVm = moreHeaderAnimationParams.moreHeaderVm;
    animateParams.push(
      // 位移
      {
        curve: TRANSLATE_ANIMATION_CURVE,
        delay: moreHeaderAnimationParams.delay,
        duration: 333,
        event: () => moreHeaderVm?.clearAllAnimation(1, 1, moreHeaderAnimationParams.translateY),
      },
    );
    return animateParams;
  }

  /**
   * 通知卡片向下动效位移值
   * 横屏：卡片中心位移至列表底部；竖屏卡片中心位移至垃圾桶顶部
   */
  private getTranslateYDownwards(itemId: string): number {
    const rectInfo = ItemUtils.getRectById(itemId);
    let targetLocation: number = 0;
    if (this.isLandscapeLayout) {
      targetLocation = ItemUtils.getRectById(LANDSCAPE_LIST_ID).bottom;
    } else {
      const clearButtonInfo = ItemUtils.getRectById(CLEAR_BUTTON_ID);
      targetLocation = clearButtonInfo.top;
    }
    const transY = targetLocation - (rectInfo.bottom + rectInfo.top) / 2;
    return transY;
  }
}