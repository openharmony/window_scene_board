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

import { ILiveCapsuleVm } from '../interface/ILiveCapsuleVm';
import { LiveVmInjector } from '../LiveVmInjector';
import { LiveNotification } from '../model/LiveNotification';
import { LengthMetrics } from '@ohos.arkui.node';
import { LiveStyle } from '../constants/LiveStyle';
import { LiveCapsuleMarqueeView } from './LiveCapsuleMarqueeView';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CapsuleShowType, LiveProgressModel } from '../model/LiveCommonModel';
import { LiveCapsuleLightWaveView } from './LiveCapsuleLightWaveView';
import { AccessibilityText } from '../../view/AccessibilityText';
import { ILiveCapsuleMarqueeVm } from '../interface/ILiveCapsuleMarqueeVm';
import { ResourceVm } from '../../vm/ResourceVm';
import { ILiveCapsuleListVm } from '../interface/ILiveCapsuleListVm';
import { LiveCapsuleSubpixelAntiAliasView } from './LiveCapsuleSubpixelAntiAliasView';
import { SystemEffectVm } from '../../vm/SystemEffectVm';
import { SystemUIColorVm } from '../../vm/SystemUIColorVm';
import { ArkUIAdapter } from '../../utils/ArkUIAdapter';
import { ILiveCapsuleFaceLockVm, ShowStage } from '../interface/ILiveCapsuleFaceLockVm';
import { LottieCapsuleViewNode } from './LottieCapsuleView';

const TAG = 'LiveCapsuleView';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const BORDER_HEIGHT = 2.4;

@ComponentV2
export struct LiveCapsuleView {
  @Consumer() liveVmInjector: LiveVmInjector = LiveVmInjector.HOLDER;
  @Param @Require live: LiveNotification;

  @Computed
  get capsuleListVm(): ILiveCapsuleListVm {
    return this.liveVmInjector.getCapsuleListVm();
  }

  @Computed
  get capsuleVm(): ILiveCapsuleVm {
    return this.liveVmInjector.getCapsuleVm(this.live);
  }

  @Computed
  get colorVm(): SystemUIColorVm {
    return this.liveVmInjector.getColorVm();
  }

  @Computed
  get capsuleMarqueeVm(): ILiveCapsuleMarqueeVm {
    return this.liveVmInjector.getCapsuleMarqueeVm(this.live);
  }

  @Computed
  get liveCapsuleFaceLockVm(): ILiveCapsuleFaceLockVm {
    return this.liveVmInjector.getLiveCapsuleFaceLockVm(this.live);
  }

  @Computed
  get progress(): LiveProgressModel | undefined {
    if (this.live.capsule?.isProgress()) {
      return this.live.capsule.progress;
    }
    return undefined;
  }

  private getLottieNode(): LottieCapsuleViewNode {
    if (!this.capsuleVm.faceLockLottieNode) {
      this.capsuleVm.faceLockLottieNode = new LottieCapsuleViewNode({live: this.live, vmInjector: this.liveVmInjector});
      return this.capsuleVm.faceLockLottieNode;
    }
    return this.capsuleVm.faceLockLottieNode;
  }

  aboutToAppear(): void {
    log.showWarn(`aboutToAppear, hashCode: ${this.live.hashCode}, capsule type = ${this.live.type}, showType=${this.capsuleVm.showType},
    livetext.length=${this.capsuleMarqueeVm.getText(this.live, this.capsuleVm.showType).length}`);
    this.capsuleVm.setCapsuleOpacity();
    this.liveCapsuleFaceLockVm.isOnTree = true;
    this.capsuleVm.appearPromise.resolve();
  }

  aboutToDisappear(): void {
    this.liveCapsuleFaceLockVm.isOnTree = false;
    log.showWarn(`aboutToDisappear, hashCode: ${this.live.hashCode}, capsule type = ${this.live.type}`);
  }

  build(): void {
    Stack() {
      this.buildSubpixelAntiAlias();

      if (SystemEffectVm.instance.isShowLightWhenExpandCapsule()) {
        LiveCapsuleLightWaveView({
          live: this.live,
          isToRight: false,
        })
        if (this.capsuleVm.showType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) {
          LiveCapsuleLightWaveView({
            live: this.live,
            isToRight: true,
          })
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
          if (this.capsuleVm.isShowCapsuleIcon) {
            Stack() {
              if (this.capsuleVm.isStackIcons) {
                this.buildCapsuleIcon(true)
              }
              this.buildIcon()
            }
            .alignContent(Alignment.Start)
            Row({ space: this.capsuleVm.capsuleMarqueeSpace }) {
              LiveCapsuleMarqueeView({ live: this.live })
              if (this.capsuleMarqueeVm.isExtendShow && this.capsuleMarqueeVm.extendTextWidth !== 0) {
                this.buildSeparator()
                LiveCapsuleMarqueeView({ live: this.live, isExtend: true })
              }
            }
            .width(this.capsuleVm.totalTextWidth)
            .margin({
              start: LengthMetrics.vp(this.capsuleVm.capsuleTextMarginStart),
              end: LengthMetrics.vp(this.capsuleVm.capsuleTextMarginEnd)
            })
            if (this.capsuleVm.isShowRightIcon) {
              this.buildCapsuleIcon(true)
            }
            this.buildButton()
          } else if (this.capsuleVm.showType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) {
            this.buildButton()
            if (this.capsuleVm.width > this.capsuleVm.capsuleCircleWidth) {
              Row({ space: this.capsuleVm.capsuleMarqueeSpace }) {
                LiveCapsuleMarqueeView({ live: this.live })
                if (this.capsuleMarqueeVm.isExtendShow && this.capsuleMarqueeVm.extendTextWidth !== 0) {
                  LiveCapsuleMarqueeView({ live: this.live, isExtend: true })
                }
              }
              .margin({
                start: LengthMetrics.vp(this.capsuleVm.capsuleTextMarginStart),
                end: LengthMetrics.vp(this.capsuleVm.capsuleTextMarginEnd)
              })
            }
          } else {
            // 无锚点录屏胶囊按钮位于左侧
            this.buildButton()
            if (this.capsuleVm.width > this.capsuleVm.capsuleCircleWidth) {
              LiveCapsuleMarqueeView({ live: this.live })
                .margin({
                  start: LengthMetrics.vp(this.capsuleVm.capsuleTextMarginStart),
                  end: LengthMetrics.vp(this.capsuleVm.capsuleTextMarginEnd)
                })
            }
          }
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
      .height(this.capsuleVm.capsuleHeight)
      .borderRadius(LiveStyle.CAPSULE_RADIUS)
      .opacity(this.capsuleVm.opacity)
      .clip(true)
      .foregroundEffect({ radius: this.capsuleVm.blur })
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
    // 即时胶囊不响应屏幕朗读点击播报
    .accessibilityDescription(this.live.isInstant() ? ' ' : '')
    .width(this.capsuleVm.width + BORDER_HEIGHT)
    .height(this.capsuleVm.height + BORDER_HEIGHT)
    .alignContent(Alignment.Center)
    .id(this.capsuleVm.componentId)
    .opacity(this.capsuleVm.opacity)
    .borderRadius(LiveStyle.CAPSULE_RADIUS)
    .clip(true)
    // 增加一个可以走进布局但不影响业务的状态变量，保证能在状态改变时走进布局像素取整方案，后续arkUI修复bug后可删除
    .constraintSize({ maxHeight: 10000 - this.capsuleVm.opacity })
  }

  @Builder
  buildIcon() {
    if (this.capsuleVm.isShowProgress) {
      this.buildProgress();
    } else if (this.live.isFaceLock()) {
      NodeContainer(this.getLottieNode())
    } else {
      this.buildCapsuleIcon();
    }
  }

  @Builder
  buildProgress() {
    Stack({ alignContent: Alignment.Center }) {
      Progress({
        value: this.progress?.currentValue,
        total: this.progress?.maxValue,
        type: ProgressType.Ring
      })
        .backgroundColor(LiveStyle.CAPSULE_PROGRESS_BACKGROUND_COLOR)
        .color(this.progress?.color)
        .height(this.capsuleVm.capsuleIconWidthPx  + 'px')
        .width(this.capsuleVm.capsuleIconWidthPx + 'px')
        .style({ strokeWidth: LiveStyle.CAPSULE_PROGRESS_STROKE_WIDTH, enableSmoothEffect: false })
        .accessibilityLevel('yes')
      Progress({
        value: 0,
        total: this.progress?.maxValue,
        type: ProgressType.Ring
      })
        .backgroundColor(Color.White)
        .foregroundBrightness(this.colorVm.progressBrightness)
        .height(this.capsuleVm.capsuleIconWidthPx  + 'px')
        .width(this.capsuleVm.capsuleIconWidthPx + 'px')
        .style({ strokeWidth: LiveStyle.CAPSULE_PROGRESS_STROKE_WIDTH, enableSmoothEffect: false })
      Image(this.capsuleVm.icon)
        .draggable(false)
        .syncLoad(true)
        .objectFit(ImageFit.Contain)
        .interpolation(ImageInterpolation.Medium)
        .width(LiveStyle.CAPSULE_PROGRESS_ICON_WIDTH)
        .height(LiveStyle.CAPSULE_PROGRESS_ICON_WIDTH)
    }
    .height(this.capsuleVm.capsuleIconWidthPx  + 'px')
    .width(this.capsuleVm.capsuleIconWidthPx + 'px')
    .borderRadius(this.capsuleVm.capsuleIconWidthPx + 'px')
  }

  @Builder
  buildCapsuleIcon(isRightIcon?: boolean) {
    Row() {
      Image(isRightIcon ? this.capsuleVm.rightIcon : this.capsuleVm.icon)
        .id(this.liveVmInjector.getId(`${TAG}_icon_${this.live.hashCode}`))
        .draggable(false)
        .syncLoad(true)
        .objectFit(ImageFit.Cover)
        .interpolation(ImageInterpolation.Medium)
        .width(this.capsuleVm.capsuleIconWidthPx + 'px')
        .height(this.capsuleVm.capsuleIconWidthPx + 'px')
        .backgroundColor(this.capsuleVm.contentColor)
        .onError((error) => {
          log.showWarn(`capsule icon load error: ${error?.message}, ${typeof this.capsuleVm.icon}}`);
        })
    }
    .renderGroup(true)
    .freeze(this.capsuleListVm.isIconFreeze)
    .clip(true)
    .width(this.capsuleVm.capsuleIconWidthPx + 'px')
    .height(this.capsuleVm.capsuleIconWidthPx + 'px')
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .borderRadius('100%')
    .margin({
      start: isRightIcon && this.capsuleVm.showType === CapsuleShowType.HANGING_HOLE ?
      LengthMetrics.vp(this.capsuleVm.stackIconMargin) : LengthMetrics.vp(0)
    })
  }

  @Builder
  buildButton() {
    if (this.capsuleVm.button) {
      Row() {
        Image(this.capsuleVm.buttonIcon)
          .id(this.liveVmInjector.getId(`${TAG}_button_${this.live.hashCode}`))
          .draggable(false)
          .syncLoad(true)
          .objectFit(ImageFit.Contain)
          .interpolation(ImageInterpolation.Medium)
          .width(this.capsuleVm.iconWidth)
          .height(this.capsuleVm.iconWidth)
          .accessibilityText(this.capsuleVm.button.accessibilityText)
      }
      .opacity(this.capsuleVm.buttonOpacity)
      .width(this.capsuleVm.capsuleIconWidthPx + 'px')
      .height(this.capsuleVm.capsuleIconWidthPx + 'px')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .borderRadius('100%')
      .backgroundColor(this.capsuleVm.contentColor)
      .responseRegion({
        width: this.capsuleVm.capsuleCircleWidth,
        height: this.capsuleVm.height,
        x: -(this.capsuleVm.capsuleCircleWidth - this.capsuleVm.capsuleIconWidth) / 2,
        y: -(this.capsuleVm.height - this.capsuleVm.capsuleIconWidth) / 2,
      })
      .onClick(this.capsuleVm.onClickButton)
    }
  }

  @Builder
  buildSubpixelAntiAlias() {
    LiveCapsuleSubpixelAntiAliasView({ live: this.live, borderHeight: BORDER_HEIGHT})
  }

  @Builder
  buildSeparator() {
    if (this.capsuleVm.isNeedSeparator) {
      Stack() {
        Text(':')
          .width('100%')
          .height('100%')
          .fontSize(this.capsuleMarqueeVm.extendTextSize + 'vp')
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
          .align(Alignment.Center)
          .textAlign(TextAlign.Center)
      }
      .width(this.capsuleVm.separatorWidth)
      .height('100%')
    }
  }
}