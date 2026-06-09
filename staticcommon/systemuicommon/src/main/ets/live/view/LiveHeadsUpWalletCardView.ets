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
import { CutoutVm } from '../../statusbar/vm/CutoutVm';
import { fontScaleManager, FontScaleState } from '@ohos/systemuiutils';
import { ResourceVm } from '../../vm/ResourceVm';
import { LiveStyle } from '../constants/LiveStyle';
import { LiveVmInjector } from '../LiveVmInjector';
import { LengthMetrics } from '@kit.ArkUI';
import { DeviceInfoVm } from '../../vm/DeviceInfoVm';

const TAG = 'LiveCardWalletView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ComponentV2
export struct LiveHeadsUpWalletCardView {
  @Consumer() liveVmInjector: LiveVmInjector = LiveVmInjector.HOLDER;
  fontScaleState: FontScaleState = fontScaleManager.getSysFontScaleState();
  headsUpVm = this.liveVmInjector.getLiveHeadsUpVm();
  colorVm = this.liveVmInjector.getColorVm();
  walletVm = this.liveVmInjector.getLiveHeadsUpWalletCardVm();
  bigFontOffsetY: number = 3;

  aboutToAppear() {
    if (CutoutVm.instance.isMiddleCutout() || DeviceInfoVm.instance.isXTSpecialState()) {
      this.walletVm.noAnchorPointOverallPageLayOutInfo.pageLayOutIsHaveHole = true;
    } else {
      this.walletVm.noAnchorPointOverallPageLayOutInfo.pageLayOutIsHaveHole = false;
    }
    this.bigFontOffsetY = this.walletVm.getBigFontOffsetY();
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisappear, destroy lottie animation`);
    this.walletVm.radioInfo.destroyLottie();
  }

  build() {
    Column() {
      Stack({
        alignContent: this.walletVm.noAnchorPointOverallPageLayOutInfo.pageLayOutAlignment ? Alignment.Start :
        Alignment.Center
      }) {
        Stack() {
        }
        .backgroundColor(this.walletVm.overlayBoxInfo.backGroundColor ? 'rgba(0, 0, 0, 0.6)' : Color.Black)
        .borderRadius(this.walletVm.overlayBoxInfo.borderRadius)
        .width(this.walletVm.overlayBoxInfo.width)
        .height(this.walletVm.overlayBoxInfo.height)
        .translate({ y: this.walletVm.overlayBoxInfo.translateY })
        .scale({ x: this.walletVm.overlayBoxInfo.scaleX, y: this.walletVm.overlayBoxInfo.scaleY })
        .backgroundBlurStyle(this.walletVm.overlayBoxInfo.backGroundColor ? BlurStyle.COMPONENT_ULTRA_THICK : undefined,
          this.walletVm.overlayBoxInfo.backGroundColor ? {
            colorMode: ThemeColorMode.DARK,
            adaptiveColor: AdaptiveColor.DEFAULT,
            scale: 0.8155
          } : undefined)
        .shadow(this.walletVm.overlayBoxInfo.backGroundColor ? ShadowStyle.OUTER_DEFAULT_MD : undefined)
        .opacity(this.walletVm.overlayBoxInfo.opacity)

        Stack() {
          Stack() {
            Stack() {
              Image(this.walletVm.imageInfo.updateCardimagePixelMap)
                .borderRadius(6)
                .opacity(this.walletVm.imageInfo.imageUpdateCardOpacity)
                .width(76)
                .height(48)
              Image(this.walletVm.imageInfo.cardimagePixelMap)
                .borderRadius(6)
                .opacity(this.walletVm.imageInfo.defaultCardOpacity)
                .width(76)
                .height(48)
              Row()
                .width(16)
                .height(90)
                .position({ x: this.walletVm.imageInfo.sweepPositionX, y: this.walletVm.imageInfo.sweepPositionY })
                .linearGradient({
                  direction: GradientDirection.Right,
                  repeating: false,
                  colors: [['rgba(255,255,255,0)', 0], ['rgba(255,255,255,0.6)', 0.4], ['rgba(255,255,255,0.7)', 0.5],
                    ['rgba(255,255,255,0.6)', 0.6], ['rgba(255,255,255,0)', 1]]
                })
                .rotate({
                  x: 0,
                  y: 0,
                  z: 1,
                  angle: -15
                })
            }
            .borderRadius(6)
            .clip(true)
            .width(76)
            .height(48)
            .rotate({
              x: this.walletVm.imageInfo.X,
              y: this.walletVm.imageInfo.Y,
              z: this.walletVm.imageInfo.Z,
              angle: this.walletVm.imageInfo.angle
            })
            .scale({ x: this.walletVm.imageInfo.scalaX, y: this.walletVm.imageInfo.scalaY })
            .translate({
              x: ResourceVm.instance.isRTL ? -(this.walletVm.imageInfo.translateX) : this.walletVm.imageInfo.translateX,
              y: this.walletVm.imageInfo.translateY,
              z: this.walletVm.imageInfo.translateZ
            })

            Column({ space: 4 }) {
              Text(this.walletVm.textInfo.textMainTitle)
                .maxLines(1)
                .fontColor('rgb(255, 255, 255)')
                .lineHeight(ResourceVm.instance.getFontSize(19, 1.45))
                .fontSize(ResourceVm.instance.getFontSize(14, 1.45))
                .fontWeight(500)
                .textOverflow({ overflow: TextOverflow.Ellipsis })

              Text(this.walletVm.textInfo.textSubTitle)
                .maxLines(1)
                .fontColor('rgba(255, 255, 255, 0.6)')
                .fontSize(ResourceVm.instance.getFontSize(14, 1.45))
                .lineHeight(ResourceVm.instance.getFontSize(19, 1.45))
                .fontWeight(400)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .width(this.walletVm.noAnchorPointOverallPageLayOutInfo.pageLayOutIsHaveHole ? this.walletVm.textWidth :
              164)
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.Center)
            .offset({
              start: LengthMetrics.vp(this.walletVm.textOffsetDisplacement),
              top: LengthMetrics.vp(this.bigFontOffsetY)
            })
            .opacity(this.walletVm.textInfo.textOpacity)
            .translate({
              x: ResourceVm.instance.isRTL ? -(this.walletVm.textInfo.textTranslateX) :
              this.walletVm.textInfo.textTranslateX
            })

            Column() {
              if (!this.walletVm.radioInfo.isSwipeFailureIcon) {
                Column() {
                  Canvas(this.walletVm.radioInfo.controller) {
                  }
                  .onReady(() => {
                  })
                  .width(20.52)
                }
                .clipShape(new Circle({ width: 40, height: 40 }))
                .height(40)
                .width(40)
                .alignItems(HorizontalAlign.Center)
                .justifyContent(FlexAlign.Center)
                .backgroundColor('rgb(100, 187, 92)')
                .offset({ start: LengthMetrics.vp(this.walletVm.iconOffsetDisplacement), top: LengthMetrics.vp(4) })
                .opacity(this.walletVm.radioInfo.radioOpacity)
                .scale({ x: this.walletVm.radioInfo.radioscalaX, y: this.walletVm.radioInfo.radioscalaY })

              } else {
                Column() {
                  Image(this.walletVm.radioInfo.cardImageFailPixelMap)
                }
                .height(40)
                .width(40)
                .alignItems(HorizontalAlign.Center)
                .justifyContent(FlexAlign.Center)
                .offset({
                  start: LengthMetrics.vp(this.walletVm.noAnchorPointOverallPageLayOutInfo.pageLayOutIsHaveHole ?
                    this.walletVm.iconOffsetDisplacement +
                      ((this.walletVm.bannerWidthConstantFinalState / 2) - 38 - 12) :
                  this.walletVm.iconOffsetDisplacement), top: LengthMetrics.vp(4)
                })
                .opacity(this.walletVm.radioInfo.radioOpacity)
                .scale({ x: this.walletVm.radioInfo.radioscalaX, y: this.walletVm.radioInfo.radioscalaY })
                .translate({
                  x: ResourceVm.instance.isRTL ? -(this.walletVm.radioInfo.radioTranslateX) :
                  this.walletVm.radioInfo.radioTranslateX
                })
              }
            }
          }
          .alignContent(Alignment.TopStart)
          .width(76)
          .height(48)
        }
        .offset({
          start: LengthMetrics.vp(this.walletVm.noAnchorPointOverallPageLayOutInfo.pageLayOutAlignment ?
          this.walletVm.noAnchorPointOverallPageLayOutInfo.pageLayOutOffsetX : 0)
        })
      }
      .width(100)
      .height(66)
    }
    .id(this.walletVm.componentId)
    .alignItems(this.walletVm.noAnchorPointOverallPageLayOutInfo.pageLayOutIsHaveHole ? HorizontalAlign.Center :
    HorizontalAlign.Start)
    .width('100%')
    .height(66)
    .onSizeChange((_, size) => {
      log.info('onSizeChange:', size);
      this.headsUpVm.onContentAppear();
    })
    .onDisAppear(this.headsUpVm.onContentDisappear)
  }
}