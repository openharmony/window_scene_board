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

import { LiveVmInjector } from '../LiveVmInjector';
import { LiveNotification } from '../model/LiveNotification';
import { LiveCardView } from './LiveCardView';
import { LengthMetrics } from '@ohos.arkui.node';
import { ILiveCardListItemVm } from '../interface/ILiveCardListItemVm';
import { LiveCardMenuView } from './LiveCardMenuView';
import { ILiveCardMenuVm } from '../interface/ILiveCardMenuVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveStyle } from '../constants/LiveStyle';
import { BaseGesture } from '../../vm/BaseGesture';
import { CutoutVm } from '../../statusbar/vm/CutoutVm';
import { BannerVm } from '../../vm/BannerVm';
import { SystemEffectVm } from '../../vm/SystemEffectVm';
import { DeviceInfoVm } from '../../vm/DeviceInfoVm';

const TAG = 'LiveCardListItemView';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ComponentV2
export struct LiveCardListItemView {
  @Consumer() liveVmInjector: LiveVmInjector = LiveVmInjector.HOLDER;

  @Param @Require hashCode: string;

  colorVm = this.liveVmInjector.getColorVm();

  @Computed
  get live(): LiveNotification | undefined {
    return this.liveVmInjector.getCardListVm().liveMap.get(this.hashCode);
  }

  @Computed
  get itemVm(): ILiveCardListItemVm | undefined {
    return this.live ? this.liveVmInjector.getCardListItemVm(this.live) : undefined;
  }

  @Computed
  get menuVm(): ILiveCardMenuVm | undefined {
    return this.live ? this.liveVmInjector.getCardMenuVm(this.live) : undefined;
  }

  @Computed
  get contentId(): string {
    return this.liveVmInjector.getId(`${TAG}_content_${this.hashCode}`);
  }

  private _contentGesture = new BaseGesture();

  @Computed
  get contentGesture(): BaseGesture {
    this._contentGesture.destroy();
    if (this.menuVm?.horizontalPanGesture) {
      log.showInfo('Add menu gesture');
      this._contentGesture.addGesture(this.menuVm.horizontalPanGesture);
    }
    if (this.itemVm?.gesture){
      log.showInfo('Add item gesture');
      this._contentGesture.addGesture(this.itemVm.gesture);
    }
    return this._contentGesture;
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear: ${this.hashCode}`);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear: ${this.hashCode}`);
    this.menuVm?.destroy();
  }

  build() {
    if (this.live && this.itemVm && this.menuVm) {
      Stack({ alignContent: this.itemVm.contentAlign }) {
        if (this.menuVm.isShowMenu && this.menuVm.isSwiped) {
          LiveCardMenuView({ live: this.live })
        }

        RelativeContainer() {
          Column() {
          }
          .scale(this.itemVm.contentScale)
          .backgroundEffect({
            policy: 1,
            radius: 30
          })
          .borderRadius(this.itemVm.contentBorderRadius)
          .opacity(this.itemVm.cardBackOpacity)
          .clip(true)
          .alignRules({
            left: { anchor: this.contentId, align: HorizontalAlign.Start },
            top: { anchor: this.contentId, align: VerticalAlign.Top },
            right: { anchor: this.contentId, align: HorizontalAlign.End },
            bottom: { anchor: this.contentId, align: VerticalAlign.Bottom },
          })

          Column() {
          }
          .scale(this.itemVm.contentScale)
          .borderRadius(this.itemVm.contentBorderRadius)
          .clip(true)
          .opacity(this.itemVm.cardBackOpacity)
          .backgroundColor(SystemEffectVm.instance.isCloseBrightness() ? this.colorVm.liveListCardBgColor :
            'rgba(0,0,0,1)')
          .backgroundBrightnessInternal(SystemEffectVm.instance.isCloseBrightness() ? undefined :
          this.colorVm.liveCardBgBrightness)
          .backgroundEffect(this.colorVm.liveListItemBgEffect)
          .alignRules({
            left: { anchor: this.contentId, align: HorizontalAlign.Start },
            top: { anchor: this.contentId, align: VerticalAlign.Top },
            right: { anchor: this.contentId, align: HorizontalAlign.End },
            bottom: { anchor: this.contentId, align: VerticalAlign.Bottom },
          })

          if (!this.colorVm.isSolidEnable()) {
            Column() {
            }
            .scale(this.itemVm.contentScale)
            .borderRadius(this.itemVm.contentBorderRadius)
            .clip(true)
            .opacity(this.itemVm.cardGradientOpacity)
            .backgroundColor('rgba(0, 0, 0, 0.1)')
            .linearGradient({
              direction: GradientDirection.Top,
              colors: this.itemVm.cardGradientColor
            })
            .alignRules({
              left: { anchor: this.contentId, align: HorizontalAlign.Start },
              top: { anchor: this.contentId, align: VerticalAlign.Top },
              right: { anchor: this.contentId, align: HorizontalAlign.End },
              bottom: { anchor: this.contentId, align: VerticalAlign.Bottom },
            })
          }

          if (CutoutVm.instance.isMiddleCutout()) {
            // 竖屏场景下增加黑色底板
            Column() {
            }
            .scale(this.itemVm.contentScale)
            .borderRadius(this.itemVm.contentBorderRadius)
            .clip(true)
            .opacity(1 - this.itemVm.cardGradientOpacity)
            .backgroundColor('rgb(0, 0, 0)')
            .alignRules({
              left: { anchor: this.contentId, align: HorizontalAlign.Start },
              top: { anchor: this.contentId, align: VerticalAlign.Top },
              right: { anchor: this.contentId, align: HorizontalAlign.End },
              bottom: { anchor: this.contentId, align: VerticalAlign.Bottom },
            })
          }

          Column() {
            LiveCardView({ live: this.live })
          }
          .id(this.contentId)
          .size(this.itemVm.contentSize)
          .scale(this.itemVm.contentScale)
          .opacity(this.itemVm.contentOpacity)
          .blur(this.itemVm.contentBlur)
          .borderRadius(LiveStyle.CARD_RADIUS)
          .clip(true)
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Center)
          .alignRules(this.itemVm.contentSize ? {
            middle: { anchor: '__container__', align: HorizontalAlign.Center },
            center: { anchor: '__container__', align: VerticalAlign.Center },
          } : {})
        }
        .size(this.itemVm.containerSize)
        .scale(this.itemVm.containerScale)
        .borderRadius(this.itemVm.containerBorderRadius)
        .clip(true)
        .opacity(this.itemVm.containerOpacity)
        .shadow(ShadowStyle.OUTER_DEFAULT_MD)
        .offset({
          start: LengthMetrics.vp(this.itemVm.containerOffsetX),
          top: LengthMetrics.vp(this.itemVm.containerOffsetY)
        })
      }
      .id(this.itemVm.componentId)
      .width(this.itemVm.cardWidth)
      .height(this.itemVm.contentSize?.height)
      .scale(this.itemVm.cardScale)
      .margin({ bottom: this.itemVm?.marginBottom })
      .zIndex(this.itemVm.zIndex)
      .accessibilityDescription(!this.live.wantAgent ? ' ' : '')
      .onTouch(this.itemVm.onTouchEvent)
      .gestureModifier(this.contentGesture)
      .transition(this.itemVm.transition)
      .onSizeChange((_, size) => this.itemVm?.onSizeChange?.(size))
    }
  }
}