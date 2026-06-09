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

import { LogDomain, LogHelper, RectInfo } from '@ohos/basicutils';
import { ItemUtils } from '@ohos/componenthelper';
import { DeviceHelper, HiDfxEventUtil } from '@ohos/frameworkwrapper';
import { NotificationAnimationParas } from '../common/NotificationAnimationParas';
import { NotificationEntry } from '../model/NotificationEntry';
import { AnimationNames } from '@ohos/systemuicommon/src/main/ets/animation/AnimationNames';
import { AnimateParams, AnimationBase } from '@ohos/systemuicommon/src/main/ets/animation/AnimationBase';
import curves from '@ohos.curves';
import { NotificationListAdapter } from '../model/NotificationListAdapter';
import { ClearButtonModifier } from '../vm/style/ClearButtonModifier';
import { ClearButtonCoverModifier } from '../vm/style/ClearButtonCoverModifier';
import { NotificationConstants } from '../common/NotificationConstants';

const TAG = 'NtfClearAllAnimation';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

export const NTF_CLEAR_ALL_SCALE = 0.1;
export const NTF_CLEAR_ALL_OPACITY = 0.1;
export const NTF_CLEAR_ALL_ROTATE_ANGEL = -15;

/**
 * 一键清除动效，包括卡片的位移、缩放、翻转等
 *
 * @since 2024-08-02
 */
export class NtfClearAllAnimation extends AnimationBase {
  /**
   * 每条通知卡片动效延迟时间
   */
  public static readonly delayPerItem: number = 17;
  /**
   * 删除按钮动效时长
   */
  public static readonly clearButtonAniDuration: number = 167;
  /**
   * 卡片属性参数
   */
  private ntfAnimationParas: Map<string, NotificationAnimationParas> = new Map();
  /**
   * 通知列表
   */
  private ntfAdapter: NotificationListAdapter | undefined = undefined;
  /**
   * 一键清除按钮的动效参数
   */
  private clearButtonModifier: ClearButtonModifier = new ClearButtonModifier();
  /**
   * 一键清除按钮的动效参数
   */
  private clearButtonCoverModifier: ClearButtonCoverModifier = new ClearButtonCoverModifier();
  /*
   * 一键删除通知卡片透明度渐变曲线
   */
  public clearItemOpacityCurve = curves.cubicBezierCurve(0.78, 0.34, 0.74, 0.44);
  /**
   * 待删除的通知列表
   */
  private deletedNtfKey: string[] = [];
  /**
   * 是否使用transition转场
   */
  public useTransition: boolean = false;

  constructor(clearButtonModifier: ClearButtonModifier, clearButtonCoverModifier: ClearButtonCoverModifier,
    ntfAdapter: NotificationListAdapter | undefined, useTransition: boolean = false) {
    super(AnimationNames.NTF_CLEAR_ALL_ANIMATION);
    this.clearButtonModifier = clearButtonModifier;
    this.clearButtonCoverModifier = clearButtonCoverModifier;
    this.ntfAdapter = ntfAdapter;
    this.useTransition = useTransition;
  }

  /**
   * 初始化动效
   *
   * @param firstIndex 第一张卡片的index
   * @param lastIndex 最后一张卡片的index
   * @param ntfAnimationParas 动效参数
   */
  public init(firstIndex: number, lastIndex: number,
    ntfAnimationParas: Map<string, NotificationAnimationParas>, useTransition: boolean = false): void {
    this.clearAnimations();
    this.ntfAnimationParas = ntfAnimationParas;
    this.addAnimation(this.getClearButtonAnimation());

    // 使用transition消失转场时，不需要添加卡片的动效
    if (!useTransition) {
      this.addAnimation(this.getAnimationParams(firstIndex, lastIndex));
    }
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
    this.deletedNtfKey.forEach((key) => {
      this.ntfAnimationParas[key]?.reset();
    })
    this.deletedNtfKey = [];
  }

  /**
   * 垃圾桶整体： 1、先缩放到0.9倍，时长167ms；2、再放大到1.2倍，时长167ms；3、最后再缩到1倍，时长333ms，延迟467ms
   * 垃圾桶盖：1、先旋转30度，时长300ms，延迟167ms；2、再恢复到原来的状态，时长333ms，延迟467ms
   *
   * @returns 动效参数
   */
  private getClearButtonAnimation(): AnimateParams[] {
    let animateParams: AnimateParams[] = [];
    animateParams.push(
      {
        duration: NtfClearAllAnimation.clearButtonAniDuration,
        curve: Curve.Friction,
        event: () => {
          this.clearButtonModifier.scale = 0.9;
        },
      },
      {
        duration: NtfClearAllAnimation.clearButtonAniDuration,
        curve: Curve.Friction,
        delay: NtfClearAllAnimation.clearButtonAniDuration,
        event: () => {
          this.clearButtonModifier.scale = 1.2;
        },
      },
      {
        duration: 300,
        curve: Curve.Friction,
        delay: NtfClearAllAnimation.clearButtonAniDuration,
        event: () => {
          this.clearButtonCoverModifier.angle = 30;
        },
      },
      {
        duration: 333,
        curve: Curve.Friction,
        delay: 467,
        event: () => {
          this.clearButtonModifier.scale = 1;
          this.clearButtonCoverModifier.angle = 0;
        },
      },
    );
    return animateParams;
  }

  public getAnimationParams(firstIndex: number, lastIndex: number): AnimateParams[] {
    const isOuterHome = !DeviceHelper.isFoldExpandedOrHalf();
    let animateParams: AnimateParams[] = [];
    for (let i = lastIndex; i >= firstIndex; i--) {
      const entry: NotificationEntry | undefined = this.ntfAdapter?.getData(i);
      const groupKey = entry?.getGroupTypeKey();
      if (!entry?.canClear() || !groupKey) {
        continue;
      }
      const ntfAnimationParam = this.ntfAnimationParas.get(groupKey);
      if (!ntfAnimationParam) {
        continue;
      }
      this.deletedNtfKey.push(groupKey);
      const delayTime = this.getDelayTime(isOuterHome, i, lastIndex);
      animateParams.push(
        // 位移
        {
          curve: this.getTranslateCurve(isOuterHome, i, firstIndex),
          delay: delayTime,
          event: () => ntfAnimationParam.ntfItemTranslateY = this.getTranslateY(groupKey),
        },
        // 缩放、翻转
        {
          duration: this.getScaleDuration(isOuterHome, i, firstIndex),
          curve: Curve.Linear,
          delay: delayTime + this.getScaleDelay(isOuterHome, i, firstIndex),
          event: () => {
            ntfAnimationParam.clearAnimScale = NTF_CLEAR_ALL_SCALE;
            ntfAnimationParam.ntfItemRotateAngels = NTF_CLEAR_ALL_ROTATE_ANGEL;
          },
        },
        // 透明度
        {
          duration: this.getOpacityDuration(isOuterHome, i, firstIndex),
          curve: this.clearItemOpacityCurve,
          delay: delayTime,
          event: () => ntfAnimationParam.clearAnimOpacity = NTF_CLEAR_ALL_OPACITY,
        },
      );
    }
    return animateParams;
  }

  public getScaleDuration(isOuterHome: boolean, i: number, firstIndex: number) {
    return this.getAnimationDurationOrDelayByIndex(isOuterHome, i, firstIndex, 700, 67);
  }

  public getOpacityDuration(isOuterHome: boolean, i: number, firstIndex: number) {
    return this.getAnimationDurationOrDelayByIndex(isOuterHome, i, firstIndex, 280, 17);
  }

  public getScaleDelay(isOuterHome: boolean, i: number, firstIndex: number) {
    return this.getAnimationDurationOrDelayByIndex(isOuterHome, i, firstIndex, 250, 50);
  }

  public getDelayTime(isOuterHome: boolean, index: number, lastIndex: number): number {
    let delayTime =
      (lastIndex - index) * NtfClearAllAnimation.delayPerItem + NtfClearAllAnimation.clearButtonAniDuration;
    if (isOuterHome) {
      // 小外屏延迟时间减半
      delayTime /= 2;
    }
    return delayTime;
  }

  public getTranslateY(groupKey: string): number {
    let ntfCenterInfo = ItemUtils.getRectById(NotificationConstants.NTF_LIST_CONTENT_ROW_ID);
    let rectInfo: RectInfo = ItemUtils.getRectById(groupKey);
    return ntfCenterInfo.bottom - rectInfo.bottom;
  }

  public getTranslateCurve(isOuterHome: boolean, index: number, firstIndex: number): ICurve {
    if (isOuterHome) {
      return curves.interpolatingSpring(0, 1, 34 + (index - firstIndex) * 4, 8);
    }
    return curves.interpolatingSpring(0, 1, 18 + (index - firstIndex) * 4, 8);
  }

  public getAnimationDurationOrDelayByIndex(isOuterHome: boolean, index: number, firstIndex: number, maxTime: number,
    reduceTime: number): number {
    let time = Math.max(maxTime - (index - firstIndex) * reduceTime, 0);
    if (isOuterHome) {
      // 小外屏时长减半
      time /= 2;
    }
    return time;
  }
}
