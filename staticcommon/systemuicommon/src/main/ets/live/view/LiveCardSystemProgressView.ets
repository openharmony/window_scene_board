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

import { LiveNotification } from '../model/LiveNotification';
import { LiveVmInjector } from '../LiveVmInjector';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ILiveCardSystemProgressVm } from '../interface/ILiveCardSystemProgressVm';
import { LiveStyle } from '../constants/LiveStyle';
import { ResourceVm } from '../../vm/ResourceVm';
import { AccessibilityVm } from '../../vm/AccessibilityVm';

const TAG = 'LiveCardSystemProgressView';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const PROGRESS_MAX_VALUE = 100;
const PROGRESS_VALUE_FONT_SIZE = 10;
const PERCENT = '%';
const PERCENT_FONT_SIZE = 6;

@ComponentV2
export struct LiveCardSystemProgressView {
  @Consumer() liveVmInjector: LiveVmInjector = LiveVmInjector.HOLDER;
  @Param @Require live: LiveNotification;

  @Computed get progressVm(): ILiveCardSystemProgressVm {
    return this.liveVmInjector.getCardSystemProgressVm(this.live);
  }

  aboutToAppear() {
    log.showInfo(`aboutToAppear: this = ${this}`);
  }

  build() {
    if (this.progressVm) {
      Stack({ alignContent: Alignment.Center }) {
        // 进度环加压暗材质，与button视觉效果保持一致
        Progress({
          value: 0,
          total: PROGRESS_MAX_VALUE,
          type: ProgressType.Ring
        })
          .backgroundColor(this.progressVm.getLiveProgressNoBrightnessBgColor())
          .foregroundBrightness(this.progressVm.getProgressBgBrightness())
          .height(this.progressVm.progressHeight)
          .width(this.progressVm.progressWidth)
          .style({ strokeWidth: this.progressVm.progressStrokeWidth })
        Progress({
          value: this.progressVm.progressValue,
          total: PROGRESS_MAX_VALUE,
          type: ProgressType.Ring
        })
          .color(this.progressVm.getProgressColor())
          .backgroundColor(LiveStyle.PROGRESS_BACKGROUND_COLOR)
          .height(this.progressVm.progressHeight)
          .width(this.progressVm.progressWidth)
          .style({ strokeWidth: this.progressVm.progressStrokeWidth })
          .accessibilityLevel('yes')
          .onClick(AccessibilityVm.instance.isEnabled && this.progressVm.isShowButton ?
          this.progressVm.onClickButton : undefined)
        if (this.progressVm.isShowText) {
          Text() {
            Span(this.progressVm.progressValue.toString())
              .fontSize(PROGRESS_VALUE_FONT_SIZE / ResourceVm.instance.fontScale)
            Span(PERCENT).fontSize(PERCENT_FONT_SIZE / ResourceVm.instance.fontScale)
          }
          .textAlign(TextAlign.Start)
          .fontFamily('HarmonyHeiTi')
          .fontWeight(FontWeight.Regular)
          .fontFeature('\"ss08\" on')
          .fontColor($r('app.color.theme_ntf_color_text_secondary'))
          .draggable(false)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        if (this.progressVm.isShowButton) {
          Image(this.progressVm.isButtonPaused ? $r('app.media.ic_public_play') : $r('app.media.ic_public_pause'))
            .width(20)
            .height(20)
            .objectFit(ImageFit.Contain)
            .draggable(false)
            .interpolation(ImageInterpolation.Medium)
            .fillColor(LiveStyle.SYS_TEXT_COLOR_SECONDARY)
        }
      }
      .height(this.progressVm.progressHeight)
      .width(this.progressVm.progressWidth)
      .onClick(this.progressVm.isShowButton ? this.progressVm.onClickButton : undefined)
      .accessibilityLevel('no')
      .opacity(this.progressVm.progressOpacity)
    }
  }
}