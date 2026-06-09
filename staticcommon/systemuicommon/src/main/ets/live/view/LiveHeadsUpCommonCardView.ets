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

import { LiveStyle } from '../constants/LiveStyle';
import { LiveVmInjector } from '../LiveVmInjector';
import { LiveCardView } from './LiveCardView';
import { LengthMetrics } from '@kit.ArkUI';
import { LiveNotification } from '../model/LiveNotification';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { SystemEffectVm } from '../../vm/SystemEffectVm';
import { ILiveCardFloatingVm } from '../interface/ILiveCardFloatingVm';
import { LiveFloatingView } from './LiveFloatingView';

const TAG = 'LiveHeadsUpCommonCardView';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ComponentV2
export struct LiveHeadsUpCommonCardView {
  @Consumer() liveVmInjector: LiveVmInjector = LiveVmInjector.HOLDER;
  @Param @Require live: LiveNotification;

  headsUpVm = this.liveVmInjector.getLiveHeadsUpVm();
  cardVm = this.liveVmInjector.getLiveHeadsUpCommonCardVm();
  colorVm = this.liveVmInjector.getColorVm();

  @Computed get contentId(): string {
    return this.liveVmInjector.getId(`${TAG}_content_${this.live.hashCode}`);
  }
  @Computed get floatingVm(): ILiveCardFloatingVm {
    return this.liveVmInjector.getCardFloatingVm(this.live);
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear for ${this.live.hashCode}`);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear for ${this.live.hashCode}`);
    this.headsUpVm.onContentDisappear();
  }

  build() {
    Stack({ alignContent: this.floatingVm.isDeformFlag ? Alignment.Center : Alignment.TopStart }) {
      RelativeContainer() {
        Column() {
        }
        .scale(this.cardVm.contentScale)
        .useEffect(true)
        .borderRadius(this.cardVm.containerBorderRadius)
        .clip(true)
        .alignRules({
          left: { anchor: this.contentId, align: HorizontalAlign.Start },
          top: { anchor: this.contentId, align: VerticalAlign.Top },
          right: { anchor: this.contentId, align: HorizontalAlign.End },
          bottom: { anchor: this.contentId, align: VerticalAlign.Bottom },
        })

        Column() {
        }
        .scale(this.cardVm.contentScale)
        .borderRadius(this.cardVm.containerBorderRadius)
        .clip(true)
        .backgroundColor(SystemEffectVm.instance.isCloseBrightness() ? this.colorVm.liveListCardBgColor :
          'rgba(0,0,0,1)')
        .backgroundBrightnessInternal(SystemEffectVm.instance.isCloseBrightness() ? undefined :
        this.colorVm.liveCardBgBrightness)
        .backgroundEffect(this.colorVm.headsUpBgEffect)
        .alignRules({
          left: { anchor: this.contentId, align: HorizontalAlign.Start },
          top: { anchor: this.contentId, align: VerticalAlign.Top },
          right: { anchor: this.contentId, align: HorizontalAlign.End },
          bottom: { anchor: this.contentId, align: VerticalAlign.Bottom },
        })

        Column() {}
        .scale(this.cardVm.contentScale)
        .borderRadius(this.cardVm.containerBorderRadius)
        .clip(true)
        .backgroundColor('rgba(0,0,0,1)')
        .opacity(this.cardVm.backCardOpacity)
        .alignRules({
          left: { anchor: this.contentId, align: HorizontalAlign.Start },
          top: { anchor: this.contentId, align: VerticalAlign.Top },
          right: { anchor: this.contentId, align: HorizontalAlign.End },
          bottom: { anchor: this.contentId, align: VerticalAlign.Bottom },
        })

        Column() {
        }
        .scale(this.cardVm.contentScale)
        .borderRadius(this.cardVm.containerBorderRadius)
        .clip(true)
        .opacity(this.cardVm.cardGradientOpacity)
        .backgroundColor('rgba(0,0,0,0.1)')
        .linearGradient({
          direction: GradientDirection.Top,
          colors: this.cardVm.cardGradientColor
        })
        .alignRules({
          left: { anchor: this.contentId, align: HorizontalAlign.Start },
          top: { anchor: this.contentId, align: VerticalAlign.Top },
          right: { anchor: this.contentId, align: HorizontalAlign.End },
          bottom: { anchor: this.contentId, align: VerticalAlign.Bottom },
        })

        Column() {
          LiveCardView({ live: this.live })
        }
        .id(this.contentId)
        .size(this.cardVm.contentSize)
        .scale(this.cardVm.contentScale)
        .opacity(this.cardVm.contentOpacity)
        .borderRadius(LiveStyle.CARD_RADIUS)
        .clip(true)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)
        .alignRules(this.cardVm.contentSize ? {
          middle: { anchor: '__container__', align: HorizontalAlign.Center },
          center: { anchor: '__container__', align: VerticalAlign.Center },
        } : {})
      }
      .size(this.cardVm.containerSize)
      .scale(this.cardVm.containerScale)
      .borderRadius(this.cardVm.containerBorderRadius)
      .clip(true)
      .opacity(this.cardVm.containerOpacity)
      .shadow(ShadowStyle.OUTER_DEFAULT_MD)
      .offset({
        start: LengthMetrics.vp(this.cardVm.containerOffsetX),
        top: LengthMetrics.vp(this.cardVm.containerOffsetY)
      })
      if (this.floatingVm.isDeformFlag) {
        LiveFloatingView(this.floatingVm)
      }
    }
    .pixelRound({start: PixelRoundCalcPolicy.NO_FORCE_ROUND, end: PixelRoundCalcPolicy.NO_FORCE_ROUND})
    .id(this.cardVm.componentId)
    .width(this.floatingVm.isDeformFlag ? this.floatingVm.cardDeformWidth : this.cardVm.cardWidth)
    .scale(this.cardVm.cardScale)
    .height(this.floatingVm.isDeformFlag ? this.floatingVm.cardDeformHeight : this.cardVm.contentSize?.height)
    .offset(this.floatingVm.isDeformFlag ? {
      start: LengthMetrics.vp(this.floatingVm.cardDeformOffsetX),
      top: LengthMetrics.vp(this.floatingVm.cardDeformOffsetY)
    } : undefined)
    .onAppear(()=> {
      this.headsUpVm.onContentAppear();
    })
  }
}