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

import { ThreeButtonUpgradeConstants } from '@ohos/phonebase/src/main/ets/SceneBoard/aiBar/ThreeButtonUpgradeConstants';
import { ThreeButtonUpgradeData, ThreeButtonUpgradeViewData } from '@ohos/phonebase/src/main/ets/SceneBoard/aiBar/AIBarModel/ThreeButtonUpgradeViewData';
import { ThreeButtonUpgradeViewModel } from '@ohos/phonebase/src/main/ets/SceneBoard/aiBar/AIBarModel/ThreeButtonUpgradeViewModel';
import lottie from '@ohos/lottie';
import { UIExtensionContentSession } from '@kit.AbilityKit';
import { SwiperItem } from '@ohos/phonebase/src/main/ets/SceneBoard/aiBar/settings/model/SwiperItem';

let storage = LocalStorage.getShared();

/**
 * 三键导航升级向导页面
 */
@Entry(storage)
@Component
export struct ThreeButtonUpgradeView {
  private upgradeData?: ThreeButtonUpgradeData = new ThreeButtonUpgradeData();
  @State upgradeViewData?: ThreeButtonUpgradeViewData = new ThreeButtonUpgradeViewData();
  private upgradeViewModel?: ThreeButtonUpgradeViewModel =
    new ThreeButtonUpgradeViewModel(this.upgradeData ?? new ThreeButtonUpgradeData(),
      this.upgradeViewData ?? new ThreeButtonUpgradeViewData());

  aboutToAppear(): void {
    if (this.upgradeData) {
      this.upgradeData.session = storage?.get<UIExtensionContentSession>('session');
    }
    this.upgradeViewModel?.aboutToAppear();
  }

  aboutToDisappear(): void {
    this.releaseResources();
    this.upgradeData = undefined;
    this.upgradeViewData = undefined;
    this.upgradeViewModel = undefined;
  }

  private releaseResources(): void {
    this.upgradeViewModel?.closeSelf();
    storage?.clear();
    lottie.destroy();
  }

  build() {
    Column() {
      Swiper(this.upgradeData?.swiperController) {
        ForEach(this.upgradeViewData?.swiperItems, (item: SwiperItem, index: number) => {
          this.buildSinglePageContent(item);
        }, (item: SwiperItem) => item.name)
      }
      .width(this.upgradeViewData?.swiperWidth)
      .height(this.upgradeViewData?.swiperHeight)
      .borderRadius(ThreeButtonUpgradeConstants.SWIPER_RADIUS)
      .backdropBlur(ThreeButtonUpgradeConstants.SWIPER_BLUR_RADIUS, undefined, { disableSystemAdaptation: true })
      .shadow({
        radius: ThreeButtonUpgradeConstants.SWIPER_SHADOW_RADIUS,
        color: ThreeButtonUpgradeConstants.SWIPER_SHADOW_COLOR
      })
      .backgroundColor(ThreeButtonUpgradeConstants.SWIPER_COLOR)
      .indicator(Indicator.dot())
      .margin({
        top: ThreeButtonUpgradeConstants.SWIPER_TOP_MARGIN,
        left: ThreeButtonUpgradeConstants.SWIPER_LEFT_MARGIN,
        right: ThreeButtonUpgradeConstants.SWIPER_RIGHT_MARGIN,
        bottom: ThreeButtonUpgradeConstants.SWIPER_BOTTOM_MARGIN,
      })
      .onChange((index: number) => {
        this.upgradeViewModel?.setButtonOpacity(index);
      })
      .onAnimationStart((index: number, targetIndex: number, extraInfo: SwiperAnimationEvent) => {
        this.upgradeViewModel?.swiperChangeStart(index);
      })
      .onAnimationEnd((index: number, extraInfo: SwiperAnimationEvent) => {
        this.upgradeViewModel?.swiperChangeEnd(index);
      })

      this.buildButton();
    }
    .align(Alignment.Top)
    .width('100%')
    .height('100%')
  }

  @Builder
  buildSinglePageContent(item: SwiperItem): void {
    Column() {
      Text(item.function)
        .margin({ top: ThreeButtonUpgradeConstants.TEXT_TITLE_TOP_MARGIN })
        .fontWeight(FontWeight.Medium)
        .fontFamily('HarmonyHeiTi')
        .fontSize(ThreeButtonUpgradeConstants.TEXT_TITLE_FONT_SIZE)
        .textAlign(TextAlign.Center)
      Text(item.detail)
        .fontFamily('HarmonyHeiTi')
        .fontWeight(FontWeight.Regular)
        .margin({ top: ThreeButtonUpgradeConstants.TEXT_DETAIL_TOP_MARGIN })
        .fontSize(ThreeButtonUpgradeConstants.TEXT_DETAIL_FONT_SIZE)
        .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        .textAlign(TextAlign.Center)
      Canvas(this.upgradeViewData?.renderingContexts[item.index])
        .margin({ top: ThreeButtonUpgradeConstants.CANVAS_TOP_MARGIN })
        .width(this.upgradeViewData?.canvasSize)
        .height(this.upgradeViewData?.canvasSize)
        .translate({ y: this.upgradeViewData?.lottieMoveUpDistance })
        .onReady(() => {
          this.upgradeViewModel?.playLottie(item.index);
        })
    }
    .padding({
      top: ThreeButtonUpgradeConstants.SWIPER_TOP_PADDING,
      left: this.upgradeViewData?.horizontal,
      right: this.upgradeViewData?.horizontal,
      bottom: ThreeButtonUpgradeConstants.SWIPER_BOTTOM_PADDING,
    })
  }

  @Builder
  buildButton(): void {
    if (this.upgradeViewData?.buttonOpacity === 1) {
      Button($r('app.string.continue'), { type: ButtonType.Capsule, stateEffect: true })
        .backgroundColor(ThreeButtonUpgradeConstants.BUTTON_COLOR)
        .align(Alignment.Center)
        .width(this.upgradeViewData?.buttonWidth)
        .height(ThreeButtonUpgradeConstants.BUTTON_HEIGHT)
        .margin({ bottom: ThreeButtonUpgradeConstants.BUTTON_BOTTOM_MARGIN })
        .onClick(async () => {
          this.releaseResources();
        })
        .transition(TransitionEffect.OPACITY)
    }
  }
}
