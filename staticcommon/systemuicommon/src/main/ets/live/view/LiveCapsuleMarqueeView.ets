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
import { ArkUIAdapter } from '../../utils/ArkUIAdapter';
import { LiveStyle } from '../constants/LiveStyle';
import { ILiveCapsuleMarqueeVm } from '../interface/ILiveCapsuleMarqueeVm';
import { LiveVmInjector } from '../LiveVmInjector';
import { LiveNotification } from '../model/LiveNotification';


const TAG = 'LiveCapsuleMarqueeView';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const LIVE_CAPSULE_MARQUEE_STEP = 2;
const LIVE_CAPSULE_MARQUEE_LOOP = 2;
// 跑马灯默认每步延迟
const DEFAULT_MARQUEE_SCROLL_DELAY = 85;

@ComponentV2
export struct LiveCapsuleMarqueeView {
  @Param stackMargin: Margin | undefined = undefined;
  @Param @Require live: LiveNotification;
  @Param isExtend: boolean = false;
  @Consumer() liveVmInjector: LiveVmInjector = LiveVmInjector.HOLDER;

  @Computed
  get capsuleMarqueeVm(): ILiveCapsuleMarqueeVm {
    return this.liveVmInjector.getCapsuleMarqueeVm(this.live);
  }

  @Computed
  get marqueeDuration(): number {
    let width = ArkUIAdapter.vp2px(this.isExtend ?
    this.capsuleMarqueeVm.extendTextWidth : this.capsuleMarqueeVm.textWidth);
    return width * DEFAULT_MARQUEE_SCROLL_DELAY / ArkUIAdapter.vp2px(LIVE_CAPSULE_MARQUEE_STEP);
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear, hashCode: ${this.live.hashCode} isExtend ${this.isExtend}.
    text.length=${this.capsuleMarqueeVm.getText().length}`);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear, hashCode: ${this.live.hashCode} isExtend ${this.isExtend}.`);
  }

  build() {
    Stack() {
      if (this.capsuleMarqueeVm.isBuildScoreText && this.capsuleMarqueeVm.textWidth !== 0) {
        this.buildScoreText()
      } else {
        if (this.isBuildMarquee()) {
          this.buildMarquee()
        } else {
          this.buildText()
        }

        if (this.isExtend ? this.capsuleMarqueeVm.hasExtendScroll : this.capsuleMarqueeVm.hasScroll) {
          Column() {
          } // 阴影宽度比文本宽度多1VP，避免arkUI取整导致文本从阴影中漏出
          .width(this.isExtend ? this.capsuleMarqueeVm.extendTextWidth + 1 : this.capsuleMarqueeVm.textWidth + 1)
          .height('100%')
          .blendMode(7)
          .linearGradient({
            direction: this.capsuleMarqueeVm.isCapsuleMarqueeRTL(this.isExtend) ?
            GradientDirection.Left : GradientDirection.Right,
            colors: [[this.capsuleMarqueeVm.textColor, 0.8], [Color.Transparent, 1]]
          })
        }
      }
    }
    .id(this.liveVmInjector.getId(`${TAG}_${this.live.hashCode}`) + '-Marquee' + '-isExtend=' + this.isExtend)
    .width(this.isExtend ? this.capsuleMarqueeVm.extendTextWidth : this.capsuleMarqueeVm.textWidth)
    .height('100%')
    .blendMode(1000)
    .clip(true)
    .accessibilityGroup(true)
    .accessibilityText(this.capsuleMarqueeVm.getAccessibilityText(this.isExtend))
    .margin(this.stackMargin)
  }

  private isBuildMarquee(): boolean {
    return this.capsuleMarqueeVm.isEnabled(this.isExtend) &&
      (this.isExtend ? this.capsuleMarqueeVm.isExtendRunning : this.capsuleMarqueeVm.isRunning);
  }

  @Builder
  buildMarquee() {
    Marquee({
      start: this.capsuleMarqueeVm.isEnabled(this.isExtend),
      step: LIVE_CAPSULE_MARQUEE_STEP,
      loop: LIVE_CAPSULE_MARQUEE_LOOP,
      fromStart: true,
      src: this.isExtend ? this.capsuleMarqueeVm.getExtendText() : this.capsuleMarqueeVm.getText()
    })
      .draggable(false)
      .width('100%')
      .height('100%')
      .fontSize((this.isExtend ? this.capsuleMarqueeVm.extendTextSize : this.capsuleMarqueeVm.textSize) + 'vp')
      .fontWeight(LiveStyle.CAPSULE_FONT_WEIGHT)
      .fontFamily(LiveStyle.CAPSULE_FONT_FAMILY)
      .fontColor(this.capsuleMarqueeVm.textColor)
      .opacity(this.capsuleMarqueeVm.opacity)
      .scale({
        x: this.capsuleMarqueeVm.scaleX,
        y: this.capsuleMarqueeVm.scaleY,
        centerX: this.capsuleMarqueeVm.centerX,
        centerY: this.capsuleMarqueeVm.centerY,
      })
      .foregroundEffect({ radius: this.capsuleMarqueeVm.radius })
      .marqueeUpdateStrategy(this.capsuleMarqueeVm.marqueeStrategy)
      .onFinish(() => {
        if (this.isExtend) {
          this.capsuleMarqueeVm.isExtendRunning = false;
        } else {
          this.capsuleMarqueeVm.isRunning = false;
        }
      })
      .align(this.capsuleMarqueeVm.getCapsuleMarqueeAlign(this.isExtend))
      .accessibilityLevel('no')
  }

  @Builder
  buildText() {
    Marquee({
      start: false,
      src: this.isExtend ? this.capsuleMarqueeVm.getExtendText() : this.capsuleMarqueeVm.getText(),
    })
      .draggable(false)
      .width('100%')
      .height('100%')
      .fontSize((this.isExtend ? this.capsuleMarqueeVm.extendTextSize : this.capsuleMarqueeVm.textSize) + 'vp')
      .fontWeight(LiveStyle.CAPSULE_FONT_WEIGHT)
      .fontFamily(LiveStyle.CAPSULE_FONT_FAMILY)
      .fontColor(this.capsuleMarqueeVm.textColor)
      .opacity(this.capsuleMarqueeVm.opacity)
      .scale({
        x: this.capsuleMarqueeVm.scaleX,
        y: this.capsuleMarqueeVm.scaleY,
        centerX: this.capsuleMarqueeVm.centerX,
        centerY: this.capsuleMarqueeVm.centerY,
      })
      .foregroundEffect({ radius: this.capsuleMarqueeVm.radius })
      .transition(this.capsuleMarqueeVm.isEnabled(this.isExtend) ?
      TransitionEffect.asymmetric(
        TransitionEffect.translate({
          x: this.capsuleMarqueeVm.isCapsuleMarqueeRTL(this.isExtend) ? '-100%' : '100%'
        }).animation({ duration: this.marqueeDuration, curve: Curve.Linear }),
        TransitionEffect.IDENTITY
      ) : null
      )
      .align(this.capsuleMarqueeVm.getCapsuleMarqueeAlign(this.isExtend))
      .accessibilityLevel('no')
  }

  @Builder
  buildScoreText() {
    Text(this.isExtend ? this.capsuleMarqueeVm.getExtendText() : this.capsuleMarqueeVm.getText())
      .draggable(false)
      .width('100%')
      .height('100%')
      .fontSize((this.isExtend ? this.capsuleMarqueeVm.extendTextSize : this.capsuleMarqueeVm.textSize) + 'vp')
      .fontWeight(LiveStyle.CAPSULE_FONT_WEIGHT)
      .fontFamily(LiveStyle.CAPSULE_FONT_FAMILY)
      .fontColor(this.capsuleMarqueeVm.textColor)
      .opacity(this.capsuleMarqueeVm.opacity)
      .scale({
        x: this.capsuleMarqueeVm.scaleX,
        y: this.capsuleMarqueeVm.scaleY,
        centerX: this.capsuleMarqueeVm.centerX,
        centerY: this.capsuleMarqueeVm.centerY,
      })
      .foregroundEffect({ radius: this.capsuleMarqueeVm.radius })
      .textAlign(this.isExtend ? TextAlign.End : TextAlign.Start)
      .accessibilityLevel('no')
      .maxLines(1)
      .textOverflow({ overflow: TextOverflow.None })
      .contentTransition({ flipDirection: FlipDirection.DOWN, enableBlur: true })
  }
}