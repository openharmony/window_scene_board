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
import { AnimationNames } from '@ohos/systemuicommon/src/main/ets/animation/AnimationNames';
import { AnimateParams, AnimationBase } from '@ohos/systemuicommon/src/main/ets/animation/AnimationBase';
import curves from '@ohos.curves';
import { INotificationCardVm, INotificationListScrollerVm,
  INotificationMoreHeaderVm } from '@ohos/systemuicommon/newIndex';
import { NotificationCategory } from '@ohos/systemuicommon';

const TAG = 'NotificationItemAppearAnimation';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 卡片依次出现，每个卡片的阶梯延时间隔
 */
const APPEAR_DELAY: number = 33.3;

/**
 * 缩放、透明度动画时长
 */
const SCALE_ANIMATION_DURATION: number = 300;

/**
 * 向上位移动画曲线
 */
const TRANSLATE_Y_ANIMATION_CURVE = curves.interpolatingSpring(0, 1, 300, 28);
/**
 * 缩放动画曲线
 */
const SCALE_ANIMATION_CURVE: Curve = Curve.Friction;

/**
 * 透明度动画曲线
 */
const OPACITY_ANIMATION_CURVE: Curve = Curve.Linear;

interface ListItemAnimateParams {
  index: number;
  firstIndex: number;
  lastIndex: number;
  itemId: string;
  cardVm: INotificationCardVm;
}

interface MoreHeaderAnimateParams {
  index: number;
  firstIndex: number;
  lastIndex: number;
  itemId: string;
  scale: number;
  opacity: number;
  transY: number;
}

/**
 * 通知卡片依次出现动效
 */
export class NotificationItemAppearAnimation extends AnimationBase {
  private listScrollerVm: INotificationListScrollerVm | undefined;
  private moreHeaderVm: INotificationMoreHeaderVm;

  constructor(listScrollerVm: INotificationListScrollerVm | undefined, moreHeaderVm: INotificationMoreHeaderVm) {
    super(AnimationNames.NTF_ITEM_APPEAR_ANIMATION);
    this.listScrollerVm = listScrollerVm;
    this.moreHeaderVm = moreHeaderVm;
  }

  public addListItemAnimation(itemAnimationParams: ListItemAnimateParams): void {
    this.addAnimation(this.getListItemAnimation(itemAnimationParams))
  }

  public addMoreHeaderAnimation(moreHeaderAnimationParams: MoreHeaderAnimateParams): void {
    this.addAnimation(this.getMoreHeaderAnimation(moreHeaderAnimationParams))
  }

  addLastItemAnimation(index: number, firstIndex: number, event: () => void): void {
    const delay = APPEAR_DELAY * (index - firstIndex);
    const animateParams: AnimateParams[] = [{
      duration: SCALE_ANIMATION_DURATION,
      curve: SCALE_ANIMATION_CURVE,
      delay: delay,
      event: () => event(),
    }]
    this.addAnimation(animateParams);
  }

  /**
   * 执行动画前
   */
  protected beforeAnimation(): void {
    super.beforeAnimation();
    // 打点
  }

  /**
   * 执行动画后
   */
  protected afterAnimation(): void {
    super.afterAnimation();
  }

  /**
   * 获取通知单个item动效
   * @param itemAnimationParams动效参数
   * @returns
   */
  private getListItemAnimation(itemAnimationParams: ListItemAnimateParams): AnimateParams[] {
    const animateParams: AnimateParams[] = [];
    const index: number =
      itemAnimationParams.cardVm.ntf.isMoreNtf() ? itemAnimationParams.index - 1 :
      itemAnimationParams.index;
    const firstIndex: number = itemAnimationParams.firstIndex;
    const cardVm: INotificationCardVm = itemAnimationParams.cardVm;
    const delay: number = APPEAR_DELAY * (index - firstIndex);

    animateParams.push(
      // 向上位移
      {
        curve: TRANSLATE_Y_ANIMATION_CURVE,
        delay: delay,
        iterations: 1,
        playMode: PlayMode.Normal,
        event: () => {
          cardVm.itemAppearAnimation(undefined, undefined, 0);
          cardVm.isInAppearAnim = false;
        },
      },
      // 缩放
      {
        duration: SCALE_ANIMATION_DURATION,
        curve: SCALE_ANIMATION_CURVE,
        delay: delay,
        iterations: 1,
        playMode: PlayMode.Normal,
        event: () => {
          if (itemAnimationParams.index !== this.listScrollerVm?.endIndex ?? 0) {
            cardVm.itemAppearAnimation(1, undefined, undefined);
          }
        },
      },
      // 透明度
      {
        duration: SCALE_ANIMATION_DURATION,
        curve: OPACITY_ANIMATION_CURVE,
        delay: delay,
        iterations: 1,
        playMode: PlayMode.Normal,
        event: () => {
          if (itemAnimationParams.index !== this.listScrollerVm?.endIndex ?? 0) {
            cardVm.itemAppearAnimation(undefined, 1, undefined);
          } else {
            this.listScrollerVm?.transformEndItem(undefined, undefined, true);
          }
        },
      },
    );
    return animateParams;
  }

  /**
   * 获取更多通知标题动效
   * @param MoreHeaderAnimateParams动效参数
   * @returns
   */
  private getMoreHeaderAnimation(moreHeaderAnimationParams: MoreHeaderAnimateParams): AnimateParams[] {
    const animateParams: AnimateParams[] = [];
    const index: number = moreHeaderAnimationParams.index;
    const firstIndex: number = moreHeaderAnimationParams.firstIndex;
    const delay: number = APPEAR_DELAY * (index - firstIndex);

    animateParams.push(
      // 向上位移
      {
        curve: TRANSLATE_Y_ANIMATION_CURVE,
        delay: delay,
        iterations: 1,
        playMode: PlayMode.Normal,
        event: () => {
          this.moreHeaderVm.moreHeaderAppearAnimation(undefined, undefined, moreHeaderAnimationParams.transY);
        },
      },
      // 缩放
      {
        duration: SCALE_ANIMATION_DURATION,
        curve: SCALE_ANIMATION_CURVE,
        delay: delay,
        iterations: 1,
        playMode: PlayMode.Normal,
        event: () => {
          this.moreHeaderVm.moreHeaderAppearAnimation(moreHeaderAnimationParams.scale, undefined, undefined);
        },
      },
      // 透明度
      {
        duration: SCALE_ANIMATION_DURATION,
        curve: OPACITY_ANIMATION_CURVE,
        delay: delay,
        iterations: 1,
        playMode: PlayMode.Normal,
        event: () => {
          this.moreHeaderVm.moreHeaderAppearAnimation(undefined, moreHeaderAnimationParams.opacity, undefined)
        },
      },
    );
    return animateParams;
  }
}
