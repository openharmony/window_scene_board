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
import { LiveVmInjector } from '../LiveVmInjector';
import { LiveNotification } from '../model/LiveNotification';
import { LengthMetrics } from '@ohos.arkui.node';
import { LiveStyle } from '../constants/LiveStyle';
import { LiveCapsuleMarqueeView } from './LiveCapsuleMarqueeView';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveCapsuleLightWaveView } from './LiveCapsuleLightWaveView';
import { AccessibilityText } from '../../view/AccessibilityText';
import { ILiveCapsuleMarqueeVm } from '../interface/ILiveCapsuleMarqueeVm';
import { CapsuleShowType } from '../model/LiveCommonModel';
import { ILiveMediaPlayerVm } from '../interface/ILiveMediaPlayerVm';
import { ILiveCapsuleVm } from '../interface/ILiveCapsuleVm';
import { ResourceVm } from '../../vm/ResourceVm';
import { ILiveCapsuleListVm } from '../interface/ILiveCapsuleListVm';
import { SystemEffectVm } from '../../vm/SystemEffectVm';
import { LiveCapsuleSubpixelAntiAliasView } from './LiveCapsuleSubpixelAntiAliasView';
import { ArkUIAdapter } from '../../utils/ArkUIAdapter';

const TAG = 'LiveCapsuleMediaPlayerView';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const BORDER_HEIGHT = 2.4;

@ComponentV2
export struct LiveCapsuleMediaPlayerView {
  @Consumer() liveVmInjector: LiveVmInjector = LiveVmInjector.HOLDER;
  @Param @Require live: LiveNotification;

  @Computed get capsuleListVm(): ILiveCapsuleListVm {
    return this.liveVmInjector.getCapsuleListVm();
  }

  @Computed
  get capsuleVm(): ILiveCapsuleVm {
    return this.liveVmInjector.getCapsuleVm(this.live);
  }

  @Computed
  get capsuleMarqueeVm(): ILiveCapsuleMarqueeVm {
    return this.liveVmInjector.getCapsuleMarqueeVm(this.live);
  }

  @Computed
  get liveMediaPlayerVm(): ILiveMediaPlayerVm {
    return this.liveVmInjector.getLiveMediaPlayerVm(this.live);
  }

  @Computed
  get capsuleTextMarginStart(): number {
    if (!this.capsuleVm.isShowCapsuleIcon && this.capsuleVm.showType !== CapsuleShowType.HANGING_HOLE) {
      return LiveStyle.CAPSULE_TEXT_MARGIN - LiveStyle.CAPSULE_ICON_PADDING;
    }

    return LiveStyle.CAPSULE_ICON_TEXT_MARGIN_START + this.capsuleMarqueeVm.offsetX;
  }

  @Computed
  get capsuleTextMarginEnd(): number {
    if (!this.capsuleVm.isShowCapsuleIcon && this.capsuleVm.showType !== CapsuleShowType.HANGING_HOLE) {
      return LiveStyle.CAPSULE_ICON_TEXT_MARGIN_START;
    }

    let capsuleTextMarginEnd: number = LiveStyle.CAPSULE_TEXT_MARGIN - LiveStyle.CAPSULE_ICON_PADDING;
    switch (this.capsuleVm.showType) {
      case CapsuleShowType.HANGING_HOLE:
        if (this.capsuleVm.isShowCapsuleIcon) {
          capsuleTextMarginEnd = this.capsuleVm.button ? LiveStyle.HANGING_CAPSULE_TEXT_MARGIN :
            (LiveStyle.HANGING_CAPSULE_TEXT_MARGIN - LiveStyle.CAPSULE_ICON_PADDING);
        } else {
          capsuleTextMarginEnd = LiveStyle.HANGING_CAPSULE_TEXT_MARGIN - LiveStyle.CAPSULE_ICON_PADDING;
        }
        break;

      default:
        capsuleTextMarginEnd = LiveStyle.CAPSULE_TEXT_MARGIN - LiveStyle.CAPSULE_ICON_PADDING;
        break;
    }

    return capsuleTextMarginEnd;
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear, hashCode: ${this.live.hashCode}`);
    this.capsuleVm.appearPromise.resolve();
  }

  build(): void {
    Stack() {
      this.buildSubpixelAntiAlias();

      if (SystemEffectVm.instance.isShowLightWhenExpandCapsule()) {
        LiveCapsuleLightWaveView({
          live: this.live,
          isToRight: false,
        })
          .id(this.capsuleVm.componentId + '-left_lightWave')
        if (this.capsuleVm.showType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) {
          LiveCapsuleLightWaveView({
            live: this.live,
            isToRight: true,
          })
            .id(this.capsuleVm.componentId + '-right_lightWave')
        }
      }

      Stack() {
        // 胶囊背板
        Stack() {
          // 挂孔
          Row()
            .opacity(this.capsuleVm.showType === CapsuleShowType.HANGING_HOLE ? 1 : 0)
            .width(this.capsuleVm.linearGradientSingleEndWidth + 2)
            .height('100%')
            .justifyContent(this.capsuleVm.width > this.capsuleVm.capsuleCircleWidth ?
              FlexAlign.Start : FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .linearGradient({
              direction: ResourceVm.instance.isRTL ? GradientDirection.Left : GradientDirection.Right,
              repeating: false,
              colors: this.capsuleVm.linearGradientSingleEndColors
            })
            .borderRadius(LiveStyle.CAPSULE_RADIUS)

          // 双端挂孔
          Row()
            .opacity(this.capsuleVm.showType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED ? 1 : 0)
            .width(this.capsuleVm.linearGradientDoubleEndWidth + 2)
            .height('100%')
            .justifyContent(this.capsuleVm.width > this.capsuleVm.capsuleCircleWidth ?
              FlexAlign.Start : FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .linearGradient({
              direction: ResourceVm.instance.isRTL ? GradientDirection.Left : GradientDirection.Right,
              repeating: false,
              colors: this.capsuleVm.linearGradientDoubleEndColors
            })
            .borderRadius(LiveStyle.CAPSULE_RADIUS)

          // 其他
          Row()
            .opacity(
              (this.capsuleVm.showType !== CapsuleShowType.HANGING_HOLE &&
                this.capsuleVm.showType !== CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED)
                ? 1
                : 0
            )
            .width('100%')
            .height('100%')
            .justifyContent(this.capsuleVm.width > this.capsuleVm.capsuleCircleWidth ?
              FlexAlign.Start : FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .linearGradient({
              direction: ResourceVm.instance.isRTL ? GradientDirection.Left : GradientDirection.Right,
              repeating: false,
              colors: [['rgba(0, 0, 0, 0)', 0], ['rgba(0, 0, 0, 0)', 1]]
            })
            .borderRadius(LiveStyle.CAPSULE_RADIUS)
        }
        .width('100%')
        .height('100%')
        .opacity(this.capsuleVm.showType === CapsuleShowType.SHADOW ? 0 : 1)

        // 胶囊内容
        Row() {
          AccessibilityText({ text: this.live.getAccessibilityAppName() })
          this.buildMediaPlayerIcon()
          Row({ space: this.capsuleVm.capsuleMarqueeSpace }) {
            LiveCapsuleMarqueeView({ live: this.live })
            if (this.capsuleMarqueeVm.isExtendShow && this.capsuleMarqueeVm.extendTextWidth !== 0) {
              LiveCapsuleMarqueeView({ live: this.live, isExtend: true })
            }
          }.margin({
            start: LengthMetrics.vp(this.capsuleVm.capsuleTextMarginStart),
            end: LengthMetrics.vp(this.capsuleVm.capsuleTextMarginEnd)
          })
        }
        .opacity(this.capsuleVm.showType === CapsuleShowType.SHADOW ? 0 : this.capsuleVm.contentOpacity)
        .width('100%')
        .height('100%')
        .justifyContent(this.capsuleVm.width > this.capsuleVm.capsuleCircleWidth ? FlexAlign.Start : FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .padding(this.capsuleVm.capsulePadding + 'px')
        .id(this.capsuleVm.componentId + '-Content')
        .borderRadius(LiveStyle.CAPSULE_RADIUS)
        .scale({
          x: this.capsuleVm.contentScaleX,
          y: this.capsuleVm.contentScaleY,
          centerX: ResourceVm.instance.isRTL ? '100%' : '0%',
          centerY: '50%'
        })

        // 阴影胶囊
        if (!(this.capsuleVm.isTempDisplay || !this.capsuleVm.isShowCapsuleIcon)) {
          Stack({ alignContent: Alignment.Center }) {
            Row()
              .width('100%')
              .height('100%')
              .backgroundColor(this.capsuleListVm.shadowColor)
              .opacity(this.capsuleVm.showType === CapsuleShowType.SHADOW ? 1 : 0)
              .id(this.capsuleVm.componentId + '-shadow')
              .borderRadius(this.capsuleVm.shadowBorderRadius)

            Row()
              .radialGradient({
                center: ['50%', '50%'],
                radius: this.capsuleVm.shadowClipBorderRadius + LiveStyle.CAPSULE_OUTLINE_WIDTH,
                colors: [['rgba(0, 255, 255, 0)', 0], ['rgba(0, 255, 255, 0)', 1]]
              })
              .offset({ start: LengthMetrics.vp(-this.capsuleVm.distanceBetweenShadowAndOutside) })
              .blendMode(6)
              .width(this.capsuleVm.height + LiveStyle.CAPSULE_OUTLINE_WIDTH * 2)
              .height(this.capsuleVm.height + LiveStyle.CAPSULE_OUTLINE_WIDTH * 2)
              .opacity(this.capsuleVm.showType === CapsuleShowType.SHADOW ? 1 : 0)
              .borderRadius(this.capsuleVm.shadowClipBorderRadius + LiveStyle.CAPSULE_OUTLINE_WIDTH)
          }
          .height('100%')
          .width('100%')
          .blendMode(1000, BlendApplyType.OFFSCREEN)
        }
      }
      .outline({
        width: this.capsuleVm.showType === CapsuleShowType.SHADOW || this.capsuleVm.disableOutline ?
          0 : LiveStyle.CAPSULE_OUTLINE_WIDTH,
        color: LiveStyle.CAPSULE_OUTLINE_COLOR,
        radius: LiveStyle.CAPSULE_RADIUS,
        style: OutlineStyle.SOLID
      })
      .width(this.capsuleVm.width)
      .height(this.capsuleVm.showType === CapsuleShowType.SHADOW ? this.capsuleVm.capsuleShadowHeight :
        (this.capsuleVm.showType !== CapsuleShowType.HANGING_HOLE &&
          this.capsuleVm.showType !== CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) ? this.capsuleVm.capsuleCircleWidth :
        this.capsuleVm.height)
      .borderRadius(LiveStyle.CAPSULE_RADIUS)
      .opacity(this.capsuleVm.opacity)
      .clip(true)
      .backgroundColor(this.capsuleVm.backgroundColor
        ? this.capsuleVm.backgroundColor : (this.capsuleVm.showType !== CapsuleShowType.HANGING_HOLE &&
          this.capsuleVm.showType !== CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED &&
          this.capsuleVm.showType !== CapsuleShowType.SHADOW)
          ? LiveStyle.CAPSULE_BACKGROUND_COLOR : undefined)
    }
    .scale({
      x: this.capsuleVm.scaleX,
      y: this.capsuleVm.scaleY,
      centerX: '50%',
      centerY: '50%',
    })
    .offset({
      start: LengthMetrics.vp(this.capsuleVm.offsetX - BORDER_HEIGHT / 2),
      top: LengthMetrics.vp(this.capsuleVm.offsetY)
    })
    .zIndex(this.capsuleVm.zIndex)
    .onClick(this.capsuleVm.onClick)
    .id(this.capsuleVm.componentId)
    .width(this.capsuleVm.width + BORDER_HEIGHT)
    .height(this.capsuleVm.height + BORDER_HEIGHT)
    .alignContent(Alignment.Center)
    .borderRadius(LiveStyle.CAPSULE_RADIUS)
    .opacity(this.capsuleVm.opacity)
    .clip(true)
  }

  @Builder
  buildMediaPlayerIcon() {
    Stack() {
      Row() {
        Image(this.capsuleVm.icon)
          .id(this.liveVmInjector.getId(`${TAG}_icon_${this.live.hashCode}`))
          .draggable(false)
          .syncLoad(true)
          .objectFit(ImageFit.Cover)
          .interpolation(ImageInterpolation.Medium)
          .width(this.capsuleVm.capsuleIconWidthPx  + 'px')
          .height(this.capsuleVm.capsuleIconWidthPx  + 'px')
      }
      .clipShape(this.liveMediaPlayerVm.mediaCircleShape)
      .width(this.capsuleVm.capsuleIconWidthPx  + 'px')
      .height(this.capsuleVm.capsuleIconWidthPx  + 'px')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .borderRadius('100%')
      .backgroundColor(this.capsuleVm.contentColor)
      .offset({
        x: this.liveMediaPlayerVm.mediaIconOffsetX,
        y: this.liveMediaPlayerVm.mediaIconOffsetY,
      })
      .scale(this.liveMediaPlayerVm.mediaIconScale)

      this.buildOldMediaIcon();
      this.buildOldMediaIconMask();
    }
    .clip(this.live.isMediaPlayer())
    .width(this.capsuleVm.capsuleIconWidthPx  + 'px')
    .height(this.capsuleVm.capsuleIconWidthPx  + 'px')
    .borderRadius(this.capsuleVm.capsuleIconWidthPx  + 'px')
  }

  @Builder
  buildOldMediaIcon() {
    Row() {
      Image(this.liveMediaPlayerVm.oldMediaIcon)
        .draggable(false)
        .syncLoad(true)
        .objectFit(ImageFit.Contain)
        .interpolation(ImageInterpolation.Medium)
        .width(this.capsuleVm.capsuleIconWidthPx  + 'px')
        .height(this.capsuleVm.capsuleIconWidthPx  + 'px')
    }
    .clipShape(this.liveMediaPlayerVm.mediaCircleShape)
    .width(this.capsuleVm.capsuleIconWidthPx  + 'px')
    .height(this.capsuleVm.capsuleIconWidthPx  + 'px')
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .opacity(this.liveMediaPlayerVm.oldMediaIconOpacity)
    .borderRadius('100%')
    .offset({
      x: this.liveMediaPlayerVm.oldMediaIconOffsetX,
      y: this.liveMediaPlayerVm.oldMediaIconOffsetY,
    })
    .scale(this.liveMediaPlayerVm.oldMediaIconScale)
  }

  @Builder
  buildOldMediaIconMask() {
    Row() {}
    .width(this.capsuleVm.capsuleIconWidthPx  + 'px')
    .height(this.capsuleVm.capsuleIconWidthPx  + 'px')
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .borderRadius('100%')
    .backgroundColor(Color.Black)
    .opacity(this.liveMediaPlayerVm.maskOpacity)
  }

  @Builder
  buildSubpixelAntiAlias() {
    LiveCapsuleSubpixelAntiAliasView({ live: this.live, borderHeight: BORDER_HEIGHT})
  }
}