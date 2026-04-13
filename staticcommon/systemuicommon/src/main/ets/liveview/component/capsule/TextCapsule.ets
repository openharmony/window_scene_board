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
import { capsuleStateMgr } from '../../CapsuleManager';
import CapsuleMarquee, { CapsuleMarqueeContent } from './CapsuleMarquee';
import { CapsuleIcon } from './CapsuleIcon';
import { LiveViewCapsuleStyle } from '../../common/LiveViewCapsuleStyle';
import { LengthMetrics } from '@ohos.arkui.node';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';

/**
 * 文本胶囊
 */
@Component
export default struct TextCapsule {
  @ObjectLink @Watch('refreshCapsule') data: LiveCapsuleData;
  @Prop marqueeEnabled: boolean;
  @Prop textOpacity: number;
  @Prop iconOpacity: number;
  @Prop fontColor: string = LiveViewCapsuleStyle.CAPSULE_TEXT_COLOR;
  @Prop isAnimation: boolean = false;
  @Prop shouldHideContent: boolean = false;
  @State capsuleListState: CapsuleListState = capsuleStateMgr.getCapsuleState();
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
    .width('100%')
    .height('100%')
  }

  private getMainMarqueeContent(): CapsuleMarqueeContent {
    this.mainMarqueeContent.contentText =
      this.shouldHideContent ? ResUtils.getInnerString($r('app.string.please_unlock')) : this.getMainText();
    this.mainMarqueeContent.contentWidth = this.capsuleListState.capsuleMainTextWidth;
    this.mainMarqueeContent.textSize = this.capsuleListState.getCapsuleTextSize(this.data);
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
    if (this.capsuleListState.isSplicing) {
      return `${this.data?.title}  ${this.getExtendText()}`;
    }
    return this.data?.title;
  }

  private getExtendText(): string | undefined {
    return this.data?.extend ?? '';
  }

  private refreshCapsule(): void {
    let capsuleMarqueeContent = `title:${this.data?.title}, extend:${this.data?.extend}` +
      `, isContentDisplayed:${this.data?.isContentDisplayed}`;
    if (capsuleMarqueeContent === this.capsuleMarqueeContent) {
      return;
    }
    this.capsuleMarqueeContent = capsuleMarqueeContent;
    this.capsuleListState.refreshTopCapsule(this.data);
  }
}