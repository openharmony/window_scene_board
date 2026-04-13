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

import { LiveViewCapsuleStyle } from '../../common/LiveViewCapsuleStyle';
import { CapsuleListState } from '../../info/capsule/CapsuleListState';
import { LiveCapsuleData } from '../../data/capsule/LiveCapsuleData';
import { LiveProgressData } from '../../data/extend/LiveProgressData';
import { capsuleStateMgr } from '../../CapsuleManager';
import CapsuleMarquee, { CapsuleMarqueeContent } from './CapsuleMarquee';
import ProgressCapsuleWave from './ProgressCapsuleWave';
import { CapsuleIcon } from './CapsuleIcon';
import { LengthMetrics } from '@ohos.arkui.node';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';

/**
 * 进度胶囊
 */
@Component
export default struct ProgressCapsule {
  private showProgressWaveAnim: boolean = false;
  @ObjectLink data: LiveCapsuleData;
  @ObjectLink typeData: LiveProgressData;
  @Prop textOpacity: number;
  @Prop iconOpacity: number;
  @Prop marqueeEnabled: boolean;
  @State capsuleListState: CapsuleListState = capsuleStateMgr.getCapsuleState();
  @Prop capsuleWidth: number = 0;
  @Prop fontColor: string = LiveViewCapsuleStyle.CAPSULE_TEXT_COLOR;
  @Prop isAnimation: boolean = false;
  @Prop shouldHideContent: boolean = false;
  mainMarqueeContent: CapsuleMarqueeContent = new CapsuleMarqueeContent();
  extentMarqueeContent: CapsuleMarqueeContent = new CapsuleMarqueeContent();

  build() {
    Stack({ alignContent: Alignment.Start }) {
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
      }
      .height('100%')
      .opacity(this.textOpacity)
      .margin({
        start: LengthMetrics.vp(this.getTextRowMarginLeft()),
        end: LengthMetrics.vp(this.capsuleListState.capsuleTextMargin)
      })

      if (this.showProgressWaveAnim) {
        ProgressCapsuleWave({
          data: this.data,
          typeData: this.typeData,
          capsuleWidth: this.capsuleWidth,
          capsuleListState: this.capsuleListState,
        })
      }
    }
    .draggable(false)
    .width('100%')
    .height('100%')
    .borderRadius(LiveViewCapsuleStyle.CAPSULE_RADIUS)
    .clip(true)
  }

  private getMainMarqueeContent(): CapsuleMarqueeContent {
    this.mainMarqueeContent.contentText =
      this.shouldHideContent ? ResUtils.getInnerString($r('app.string.please_unlock')) :
      this.capsuleListState.getProgressCapsuleMainText(this.typeData);
    this.mainMarqueeContent.contentWidth = this.capsuleListState.capsuleMainTextWidth;
    this.mainMarqueeContent.textSize = this.capsuleListState.getCapsuleTextSize(this.data);
    this.mainMarqueeContent.textColor = this.fontColor;
    return this.mainMarqueeContent;
  }

  private getTextRowMarginLeft(): number {
    return this.capsuleListState.capsuleTextMargin +
    this.capsuleListState.capsuleIconWidth +
    this.capsuleListState.capsuleIconLeftMargin;
  }
}