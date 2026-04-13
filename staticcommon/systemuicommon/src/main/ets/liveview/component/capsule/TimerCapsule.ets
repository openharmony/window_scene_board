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

import { CapsuleListState } from '../../info/capsule/CapsuleListState';
import { LiveCapsuleData } from '../../data/capsule/LiveCapsuleData';
import { LiveTimerData } from '../../data/extend/LiveTimerData';
import { capsuleStateMgr } from '../../CapsuleManager';
import CapsuleMarquee, { CapsuleMarqueeContent } from './CapsuleMarquee';
import { CapsuleIcon } from './CapsuleIcon';
import { LiveViewCapsuleStyle } from '../../common/LiveViewCapsuleStyle';
import { LengthMetrics } from '@ohos.arkui.node';
import { LiveAccessibilityUtil } from '../../common/liveAccessibilityUtil';
import { LiveViewCommonConstants } from '../../common/LiveConstants';
import { immersiveKgMgr } from '../../../immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';

export enum TimeState {
  Time_START, //计时开始*
  Time_ACTIVE, //计时中*
  Time_WAITING, //计时暂停*
  Time_STOPPING, //正在结束计时 *
  Time_STOPPED //计时结束
}

/**
 * 计时器胶囊
 */
@Component
export default struct TimerCapsule {
  @State capsuleListState: CapsuleListState = capsuleStateMgr.getCapsuleState();
  @ObjectLink @Watch('refreshCapsule') data: LiveCapsuleData;
  @ObjectLink timeData: LiveTimerData;
  @Prop textOpacity: number;
  @Prop iconOpacity: number;
  @Prop marqueeEnabled: boolean;
  @Prop fontColor: string = LiveViewCapsuleStyle.CAPSULE_TEXT_COLOR;
  @Prop isAnimation: boolean = false;
  @Prop shouldHideContent: boolean = false;
  @Prop isLockScreen: boolean = false;
  @Prop isOuterHomeAod: boolean = false;
  dateFormat?: Date = new Date();
  mainMarqueeContent: CapsuleMarqueeContent = new CapsuleMarqueeContent();
  extentMarqueeContent: CapsuleMarqueeContent = new CapsuleMarqueeContent();
  private capsuleMarqueeContent?: string;

  build() {
    Row() {
      CapsuleIcon({
        data: this.data,
        iconOpacity: this.iconOpacity,
      })

      Row() {
        CapsuleMarquee({
          content: this.getMainMarqueeContent(),
          marqueeEnabled: this.marqueeEnabled,
          isAnimation: this.isAnimation
        })
          .accessibilityText(this.shouldHideContent ? ResUtils.getInnerString($r('app.string.please_unlock')) :
          LiveAccessibilityUtil.getTImeAccessibilityText(this.timeData))
        if (this.capsuleListState.isShowExtendNoSplicing) {
          CapsuleMarquee({
            content: this.getExtendMarqueeContent(),
            marqueeEnabled: this.marqueeEnabled,
            isAnimation: this.isAnimation,
            isExtend: true,
          })
            .margin({ start: LengthMetrics.vp(this.capsuleListState.capsuleTextSpace) })
        }
      }
      .height('100%')
      .opacity(this.textOpacity)
      .margin({
        left: this.capsuleListState.capsuleTextMargin,
        right: this.capsuleListState.capsuleTextMargin
      })
    }
    .draggable(false)
    .width('100%')
    .height('100%')
  }

  private getMainMarqueeContent(): CapsuleMarqueeContent {
    this.mainMarqueeContent.contentText =
      this.shouldHideContent ? ResUtils.getInnerString($r('app.string.please_unlock')) : this.getMainText();
    this.mainMarqueeContent.contentWidth = this.capsuleListState.capsuleMainTextWidth;
    this.mainMarqueeContent.textSize = this.capsuleListState.getCapsuleTextSize(this.data)
    this.mainMarqueeContent.textColor = this.fontColor;
    return this.mainMarqueeContent;
  }

  private getExtendMarqueeContent(): CapsuleMarqueeContent {
    this.extentMarqueeContent.contentText = this.getExtendText();
    this.extentMarqueeContent.contentWidth = this.capsuleListState.capsuleExtendTextWidth;
    this.extentMarqueeContent.textSize = this.capsuleListState.getCapsuleTextSize(this.data);
    this.extentMarqueeContent.textColor = this.fontColor;
    return this.extentMarqueeContent;
  }

  private getMainText(): string | undefined {
    let mainText = this.capsuleListState.getTimeCapsuleMainText(this.timeData);
    if (this.capsuleListState.isSplicing) {
      return `${mainText}  ${this.getExtendText()}`;
    }
    // 只有扩展形态小外屏锁屏需要展示胶囊并且锁屏时需要隐藏胶囊内容
    if (this.isOuterHomeAod) {
      return ResUtils.getInnerString(this.timeData?.isCountDown ?
        $r('app.string.aod_count_down_capsule_timer_text') :
        $r('app.string.aod_timing_capsule_timer_text'));
    }
    return mainText;
  }

  private getExtendText(): string | undefined {
    if (this.isOuterHomeAod) {
      return LiveViewCommonConstants.COUNTDOWN_TEXT;
    }
    return this.data?.extend ?? '';
  }

  private refreshCapsule(): void {
    let capsuleMarqueeContent = `extend:${this.data?.extend}, isContentDisplayed:${this.data?.isContentDisplayed}`;
    if (capsuleMarqueeContent === this.capsuleMarqueeContent) {
      return;
    }
    this.capsuleMarqueeContent = capsuleMarqueeContent;
    this.capsuleListState.refreshTopCapsule(this.data);
  }
}