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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { NtfAnimationConsts } from '../common/NtfAnimationConsts';
import { NotificationEntry } from '../model/NotificationEntry';

const TAG = 'ExtraNtfCollapsedAnimation';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const NTF_DELAY = 50;
const MAX_APPEAR_NTF_NUM = 9;

/**
 * 更多通知折叠展开动效
 */
export class ExtraNtfCollapsedAnimation {
  /**
   * 更多通知折叠展开动效时长
   */
  public readonly extraNtfCollapsedDuration: number = 333;
  /**
   * 主通知列表
   */
  public mainNtfs: Array<NotificationEntry> = [];
  /**
   * 更多通知列表
   */
  public extraNtfs: Array<NotificationEntry> = [];
  /**
   * 可见列表的第一条通知
   */
  private firstIndex: number = 0;
  /**
   * 可见列表的最后一条通知
   */
  private lastIndex: number = 0;
  /**
   * 更多通知展开可见通知数
   */
  private extraNtfVisibleCount: number = 0;

  /**
   * 更新可见列表通知信息
   *
   * @param firstIndex 第一条通知
   * @param lastIndex 最后一条通知
   */
  public updateFirstAndLastIndex(firstIndex: number, lastIndex: number): void {
    this.firstIndex = firstIndex;
    this.lastIndex = lastIndex;
  }

  /**
   * 更新更多通知展开可见通知数
   *
   * @param extraNtfVisibleCount 更多通知可见通知数
   */
  public updateExtraNtfVisibleCount(extraNtfVisibleCount: number): void {
    this.extraNtfVisibleCount = extraNtfVisibleCount;
  }

  /**
   * 获取第一条更多通知的动效延迟时间
   *
   * @returns 动效延迟时间
   */
  public getFirstExtraNtfDelayTime(): number {
    // 第一条更多通知的动效延迟时间与第二条更多通知的延迟时间相同，且extraHeader会占一个位置，因此要减去2
    let delayNtfNum = this.lastIndex - this.mainNtfs?.length - 2;
    if (this.checkIsTransparentItemExist()) {
      // 如果存在透明卡片，则需要除去透明卡片
      delayNtfNum -= 1;
    }
    return Math.max(delayNtfNum, 0) * NTF_DELAY;
  }

  /**
   * 获取每条更多通知的入场及出场动效
   *
   * @returns 动效列表
   */
  public getExtraNtfAnimationArray(): TransitionEffect[] {
    let tranEffectArray: TransitionEffect[] = [];
    for (let i = 0; i < this.extraNtfs?.length; i++) {
      tranEffectArray.push(this.getExtraNtfComponentTransition(i));
    }
    return tranEffectArray;
  }

  /**
   * 动效包含如下几个部分：
   * 1、上下位移：60vp；2、缩放：0.8，耗时250ms；3、翻转：绕x轴翻转20度，耗时200ms；4、透明度：耗时200ms
   *
   * @param index 通知的索引值
   * @returns 动效参数
   */
  private getExtraNtfComponentTransition(index: number): TransitionEffect {
    if (index === 0) {
      //为首条通知添加消失时间，防止快速展开折叠造成首条通知浮动到主通知列表后才消失，造成重影
      let collapsedDelayTime = this.getCollapsedDelayTime(this.mainNtfs?.length + 1);
      return TransitionEffect.asymmetric(TransitionEffect.OPACITY,
        TransitionEffect.OPACITY.animation({ duration: 100, delay: collapsedDelayTime }));
    }
    return TransitionEffect.asymmetric(this.getExtraNtfComponentAppearTransition(index),
      this.getExtraNtfComponentDisappearTransition(index));
  }

  private getExtraNtfComponentAppearTransition(index: number): TransitionEffect {
    if (index >= this.extraNtfVisibleCount) {
      return TransitionEffect.IDENTITY;
    }
    const delayTime = index * NTF_DELAY;
    return TransitionEffect.translate({ y: -60 * index })
      .animation({ delay: delayTime, curve: NtfAnimationConsts.GROUP_DETAIL_EXPAND_CURVE })
      .combine(TransitionEffect.scale({ x: 0.8, y: 0.8 })
        .animation({ delay: delayTime, duration: 250, curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE }).combine(
          TransitionEffect.rotate({ x: 1, angle: 20 })
            .animation({ delay: delayTime, duration: 200, curve: NtfAnimationConsts.GROUP_ITEM_EXPAND_CURVE }).combine(
            TransitionEffect.OPACITY.animation({ delay: delayTime, duration: 200 })
          )
        )
      );
  }

  private getExtraNtfComponentDisappearTransition(index: number): TransitionEffect {
    const ntfIndex = index + this.mainNtfs?.length + 1;
    if (ntfIndex < this.firstIndex || ntfIndex > this.lastIndex) {
      // 如果通知不在可见通知列表内，则不执行动效
      return TransitionEffect.IDENTITY;
    }
    let collapsedDelayTime = this.getCollapsedDelayTime(ntfIndex);
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

  private getCollapsedDelayTime(ntfIndex: number): number {
    let delayNtfNum = this.lastIndex - ntfIndex;
    if (this.checkIsTransparentItemExist()) {
      // 如果存在空白卡片，则需要除去空白卡片
      delayNtfNum -= 1;
    }
    return delayNtfNum * NTF_DELAY;
  }

  /**
   * 校验可见列表里是否存在透明卡片
   *
   * @returns 校验结果
   */
  private checkIsTransparentItemExist(): boolean {
    return this.lastIndex === this.mainNtfs?.length + this.extraNtfs?.length + 1;
  }
}