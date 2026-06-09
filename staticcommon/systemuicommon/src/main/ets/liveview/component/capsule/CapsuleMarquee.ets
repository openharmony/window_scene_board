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

import { i18n } from '@kit.LocalizationKit';
import { RTLUtil } from '@ohos/componenthelper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveViewCapsuleStyle } from '../../common/LiveViewCapsuleStyle';
import measure from '@ohos.measure';
import { capsuleStateMgr } from '../../CapsuleManager';
import { OverlayStartAnimHelper } from '../../../overlay/OverlayStartAnimHelper';
import { CapsuleListState } from '../../info/capsule/CapsuleListState';

const TAG = 'CapsuleMarquee';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@Component
export default struct CapsuleMarquee {
  static readonly FONT_FAMILY: string = 'HarmonyHeiTi';
  static readonly FONT_WEIGHT: FontWeight = FontWeight.Medium;
  static readonly FADE_SCALE: number = 0.6;
  static readonly FADE_BLEND_INNER: number = 7;
  static readonly FADE_SCALE_OUTER: number = 1000;

  /**
   * 实况胶囊样式
   */
  @State capsuleListState: CapsuleListState = capsuleStateMgr.getCapsuleState();
  @Prop @Watch('setMarqueeStatus') marqueeEnabled: boolean = false;
  @ObjectLink content: CapsuleMarqueeContent;
  @State private isMarqueeRunning: boolean = false;
  @State private isMarqueeBack: boolean = false;
  @State marqueeHasScroll: boolean = false;
  @Prop isAnimation: boolean = false;
  @Prop isExtend: boolean = false;
  @State isMarqueeAppearred: boolean = false;

  aboutToAppear() {
    log.showInfo(`aboutToAppear`);
    this.setMarqueeStatus();
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
  }

  build() {
    Stack() {
      if (this.marqueeEnabled && this.isMarqueeRunning) {
        this.buildMarquee()
      } else {
        this.buildText()
      }
      Column() {}
        .width('100%')
        .height('100%')
        .blendMode(CapsuleMarquee.FADE_BLEND_INNER)
        .linearGradient({
          direction: this.isTextRTL() ? GradientDirection.Left : GradientDirection.Right,
          colors: [[this.content?.textColor, this.hasScroll() ? CapsuleMarquee.FADE_SCALE : 1], [Color.Transparent, 1]]
        })
    }
    .blendMode(CapsuleMarquee.FADE_SCALE_OUTER)
    .width(this.content?.contentWidth ?? 0)
    .animation(this.isAnimation ? {
      duration: 600,
      curve: Curve.Linear
    } : undefined)
    .height(this.capsuleListState.capsuleHeight)
    .clip(true)
  }

  @Builder
  buildMarquee() {
    Marquee({
      start: true,
      step: LiveViewCapsuleStyle.CAPSULE_TEXT_STEP,
      loop: LiveViewCapsuleStyle.CAPSULE_TEXT_LOOP,
      fromStart: true,
      src: this.content?.contentText ?? '',
    })
      .draggable(false)
      .width('100%')
      .height('100%')
      .fontSize((this.content?.textSize ?? LiveViewCapsuleStyle.TEXT_FONT_SIZE) + 'vp')
      .fontWeight(CapsuleMarquee.FONT_WEIGHT)
      .fontFamily(CapsuleMarquee.FONT_FAMILY)
      .fontColor(this.content?.textColor)
      .marqueeUpdateStrategy(MarqueeUpdateStrategy.PRESERVE_POSITION)
      .onFinish(() => {
        this.isMarqueeRunning = false;
        this.isMarqueeBack = true;
      })
      .align(this.getAlign())
      .onDisAppear(() => {
        this.isMarqueeAppearred = false;
      });
  }

  @Builder
  buildText() {
    Marquee({
      start: false,
      src: this.content?.contentText ?? '',
    })
      .draggable(false)
      .width('100%')
      .height('100%')
      .fontSize((this.content?.textSize ?? LiveViewCapsuleStyle.TEXT_FONT_SIZE) + 'vp')
      .fontWeight(CapsuleMarquee.FONT_WEIGHT)
      .fontFamily(CapsuleMarquee.FONT_FAMILY)
      .fontColor(this.content?.textColor)
      .transition(this.marqueeEnabled && this.isMarqueeBack ?
        TransitionEffect.asymmetric(
          TransitionEffect.translate({ x: this.isTextRTL() ? '-100%' : '100%' }).animation({ duration: 2000, curve: Curve.Linear }),
          TransitionEffect.IDENTITY
        ) : TransitionEffect.IDENTITY
      )
      .visibility((this.marqueeEnabled && this.isMarqueeAppearred) ? Visibility.None : Visibility.Visible)
      .align(this.getAlign())
  }

  private hasScroll() {
    let textWidthPx = measure.measureText({
      textContent: this.content?.contentText ?? '',
      fontSize: (this.content?.textSize ?? LiveViewCapsuleStyle.TEXT_FONT_SIZE) + 'vp',
      fontWeight: CapsuleMarquee.FONT_WEIGHT,
      fontFamily: CapsuleMarquee.FONT_FAMILY
    })
    let textWidth = px2vp(textWidthPx);
    let viewWidth = this.content?.contentWidth ?? 0;
    this.marqueeHasScroll = textWidth > viewWidth;
    return textWidth > viewWidth;
  }

  async setMarqueeStatus() {
    // 开启跑马灯时，如果有动效代替胶囊则等待其动效做完再跑，避免动效代理胶囊消失后跑马灯已经跑了一段的情况
    if (this.marqueeEnabled) {
      if (capsuleStateMgr.animPromise) {
        await capsuleStateMgr.animPromise;
      }
      if (OverlayStartAnimHelper.animPromise) {
        await OverlayStartAnimHelper.animPromise;
      }
    }
    this.isMarqueeRunning = this.marqueeEnabled;
    if (this.isMarqueeRunning) {
      this.isMarqueeAppearred = true;
    }
  }

  getAlign(): Alignment {
    if (this.marqueeHasScroll || this.isExtend) {
      return RTLUtil.isRTL() ? Alignment.End : Alignment.Start;
    }
    return Alignment.Center;
  }

  isTextRTL(): boolean {
    let text = this.content?.contentText ?? '';
    const str = text.replaceAll(/[\d\s\.\+-:]/g, '');
    if (!str) {
      return RTLUtil.isRTL();
    }
    return i18n.Unicode.isRTL(str);
  }
}

@Observed
export class CapsuleMarqueeContent {
  public contentText: string | undefined = undefined;
  public contentWidth: number = 0;
  public textColor: string = LiveViewCapsuleStyle.CAPSULE_TEXT_COLOR;
  public textSize: number = LiveViewCapsuleStyle.TEXT_FONT_SIZE;
}