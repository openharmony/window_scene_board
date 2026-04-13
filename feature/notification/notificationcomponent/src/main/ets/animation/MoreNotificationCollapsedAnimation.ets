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
import { NtfAnimationConsts } from '../common/NtfAnimationConsts';
import { curves } from '@kit.ArkUI';
import { AnimateParams, AnimationBase } from '@ohos/systemuicommon/src/main/ets/animation/AnimationBase';
import { AnimationNames } from '@ohos/systemuicommon/src/main/ets/animation/AnimationNames';
import { ResourceVm } from '@ohos/systemuicommon/newIndex';

const TAG = 'ExtraNtfCollapsedAnimation';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const NTF_DELAY = 50;
const GROUP_ITEM_EXPAND_CURVE = curves.cubicBezierCurve(0.2, 0, 0.2, 1);

// 更多通知折叠删除场景 标题的转场动效
export const MORE_NTF_HEADER_DELETE_TRANSITION =
  TransitionEffect.asymmetric(TransitionEffect.OPACITY.animation({ duration: 350, curve: Curve.Friction }),
    TransitionEffect.OPACITY.animation({ duration: 100, curve: Curve.Friction }))

/**
 * 更多通知折叠展开动效
 *
 * @since 2024-11-16
 */
export class MoreNotificationCollapsedAnimation extends AnimationBase {
  constructor() {
    super(AnimationNames.MORE_NTF_COLLAPSED_ANIMATION, true);
  }

  /**
   * 更多通知折叠展开图标动效
   * 1、透明度从0变到1，耗时100ms，第二个图标延迟183ms，第三个图标延迟233ms;
   * 2、缩放从0.8变到1，第二个图标延迟183ms，耗时100ms；第三个图标延迟233ms，耗时183ms
   * 3、位移20vp，第二个图标延迟183ms，耗时183ms；第三个图标延迟233ms，耗时183ms
   *
   * @param index 图标索引
   * @returns 动效参数
   */
  static getOtherIconTranEffect(index: number): TransitionEffect {
    if (index === 0) {
      return TransitionEffect.IDENTITY;
    }
    const delayTime = index === 2 ? 233 : 183;
    const durationTime = index === 2 ? 183 : 100;
    return TransitionEffect.asymmetric(
      TransitionEffect.OPACITY.animation({ duration: 100, delay: delayTime })// 透明度
        .combine(TransitionEffect.scale({ x: 0.8, y: 0.8 })// 缩放
          .animation({ duration: durationTime, delay: delayTime, curve: GROUP_ITEM_EXPAND_CURVE }))
        .combine(TransitionEffect.translate({ x: ResourceVm.instance.getXDirectionValue(-20) })// 位移
          .animation({ duration: durationTime, delay: delayTime, curve: GROUP_ITEM_EXPAND_CURVE })),
      TransitionEffect.OPACITY.animation({ duration: 100, delay: index == 2 ? 100 : 0 })// 透明度
        .combine(TransitionEffect.scale({ x: 0.8, y: 0.8 })// 缩放
          .animation({ duration: index == 2 ? 183 : 100, curve: GROUP_ITEM_EXPAND_CURVE }))
        .combine(TransitionEffect.translate({ x: ResourceVm.instance.getXDirectionValue(-20) })// 位移
          .animation({ curve: curves.interpolatingSpring(0, 1, 228, 30) }))
    );
  }

  static getIconDisappearTranEffect(index: number): TransitionEffect {
    if (index === 0) {
      return TransitionEffect.OPACITY.animation({ duration: 116 });
    }
    return TransitionEffect.scale({ x: 0.8, y: 0.8 })
      .animation({ duration: 116, curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1) })
      .combine(TransitionEffect.OPACITY.animation({ duration: 116 }));
  }

  /**
   * 获取每条更多通知的入场及出场动效
   *
   * @param endIndex 最后一条通知的索引值
   * @param mainNtfLength 主通知数量
   * @param moreNtfLength 更多通知数量
   * @param extraNtfVisibleCount 更多通知展开可见通知数
   * @returns 动效列表
   */
  getExtraNtfAnimationArray(endIndex: number, mainNtfLength: number, moreNtfLength: number,
    extraNtfVisibleCount: number): TransitionEffect[] {
    let tranEffectArray: TransitionEffect[] = [];
    for (let i = 0; i < moreNtfLength; i++) {
      tranEffectArray.push(this.getExtraNtfComponentTransition(i, endIndex, mainNtfLength, extraNtfVisibleCount));
    }
    return tranEffectArray;
  }

  /**
   * 执行更多通知折叠展开动效
   *
   * @param event 事件
   */
  public doCollapsedAnimation(event: () => void, onFinish: () => void, delay: number): void {
    this.executeAnimation(this.getCollapsedAnimations(event, onFinish, delay));
  }

  /**
   * 动效包含如下几个部分：
   * 1、上下位移：60vp；2、缩放：0.8，耗时250ms；3、翻转：绕x轴翻转20度，耗时200ms；4、透明度：耗时200ms
   *
   * @param index 通知的索引值
   * @param endIndex 最后一条通知的索引值
   * @param mainNtfLength 主通知数量
   * @param extraNtfVisibleCount 更多通知展开可见通知数
   * @returns 动效参数
   */
  private getExtraNtfComponentTransition(index: number, endIndex: number, mainNtfLength: number,
    extraNtfVisibleCount: number): TransitionEffect {
    if (index === 0) {
      return TransitionEffect.OPACITY;
    }
    return TransitionEffect.asymmetric(this.getExtraNtfComponentAppearTransition(index, extraNtfVisibleCount),
      this.getExtraNtfComponentDisappearTransition(index, endIndex, mainNtfLength));
  }

  private getExtraNtfComponentAppearTransition(index: number, extraNtfVisibleCount: number): TransitionEffect {
    if (index >= extraNtfVisibleCount) {
      return TransitionEffect.IDENTITY;
    }
    const delayTime = 50;
    return TransitionEffect.translate({ y: -60 * index })
      .animation({ delay: delayTime, curve: NtfAnimationConsts.GROUP_DETAIL_EXPAND_CURVE }).combine(
        TransitionEffect.scale({ x: 0.8, y: 0.8 })
          .animation({ delay: delayTime, duration: 250, curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE }).combine(
          TransitionEffect.rotate({ x: 1, angle: 20 })
            .animation({ delay: delayTime, duration: 200, curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE }).combine(
            TransitionEffect.OPACITY.animation({ delay: delayTime, duration: 200 })
          )
        )
      );
  }

  private getExtraNtfComponentDisappearTransition(index: number, endIndex: number,
    mainNtfLength: number): TransitionEffect {
    const ntfIndex = index + mainNtfLength + 1;
    if (ntfIndex > endIndex) {
      // 如果通知不在可见通知列表内，则不执行动效
      return TransitionEffect.IDENTITY;
    }
    let collapsedDelayTime = (endIndex - ntfIndex) * NTF_DELAY;
    return TransitionEffect.translate({ y: -60 * index })
      .animation({ delay: collapsedDelayTime, curve: NtfAnimationConsts.GROUP_DETAIL_EXPAND_CURVE }).combine(
        TransitionEffect.scale({ x: 0.8, y: 0.8 })
          .animation({ delay: collapsedDelayTime, duration: 250, curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE })
          .combine(
            TransitionEffect.rotate({ x: 1, angle: 20 })
              .animation({
                delay: collapsedDelayTime,
                duration: 200,
                curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE
              }).combine(
              TransitionEffect.OPACITY.animation({ delay: collapsedDelayTime, duration: 200 })
            )
          )
      );
  }

  private getCollapsedAnimations(event: () => void, onFinish: () => void, delay: number): AnimateParams[] {
    let animateParams: AnimateParams[] = [];
    animateParams.push(
      {
        duration: 333,
        delay: delay,
        curve: GROUP_ITEM_EXPAND_CURVE,
        event: event,
        onFinish: onFinish,
      },
    );
    return animateParams;
  }
}