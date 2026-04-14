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

import { AnimValue,
  LiveNavigationTemplate,
  LiveType,
  LiveUseScene,
  OtherBaseTemplate
} from '@ohos/systemuicommon';
import { SlWidgetId } from '@ohos/screenlockcommon';
import { SlStateMgr } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { CardAnimType } from '../../common/ImmersiveConstants';
import { ImmersiveCardData } from '../../viewmodel/viewdata/ImmersiveCardData';
import { immersiveVm } from '../../viewmodel/ImmersiveVm';
import { ImmersiveNtfData } from '../../viewmodel/viewdata/ImmersiveNtfData';
import { OtherCard } from '@ohos/systemuicommon/src/main/ets/liveview/component/card/OtherCard';
import { OtherNavigationCard } from '@ohos/systemuicommon/src/main/ets/liveview/component/card/OtherNavigationCard';
import { LiveCustomerStyle } from '@ohos/systemuicommon/src/main/ets/liveview/info/card/LiveCustomerStyle';
import { ImmersiveCardStyle } from '../../model/data/ImmersiveCardStyle';
import { SlIdHelper, WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { SlCardWidgetBindState } from '../../model/data/SlCardWidgetBindState';
import { immersiveStateHelper } from '../../common/helper/ImmersiveStateHelper';
import { ResUtils } from '@ohos/windowscene';

@Component
export struct ImmersiveCommonCard {
  @ObjectLink @Watch('onDataChange') mItemData: ImmersiveNtfData;
  @State cardData: ImmersiveCardData =
    immersiveVm.getImmersiveCardVm().getShowList()?.showData?.cardData as ImmersiveCardData;
  @State cardContentAnimState: WidgetAnimState =
    immersiveVm.getImmersiveAnimMgr().getCardAnimState(CardAnimType.CARD_LIVE_CONTENT_TYPE);
  @Prop cardStyle: ImmersiveCardStyle;
  @Prop previewAlpha: number;
  @Prop isSmallFoldOuterScreen: boolean = false;
  @State bindCardStateCtrl: SlCardWidgetBindState | undefined =
    immersiveStateHelper.getImmerseCardBindState() as SlCardWidgetBindState;

  private handleSmallFoldOuterCardClick: () => void = () => {
    immersiveVm.getCardEventHandle().execCardUpDownAnim(!(this.bindCardStateCtrl?.getIsCardFold()));
  };
  private customerStyle: LiveCustomerStyle = immersiveVm.getImmersiveCardVm()?.getLiveStyle();
  private smallFoldOuterStyle: LiveCustomerStyle = immersiveVm.getImmersiveCardVm()?.getSmallFoldOuterStyle();

  onDataChange(): void {
    if (this.mItemData) {
      this.cardData = this.mItemData?.cardData as ImmersiveCardData;
    }
  }

  build() {
    if (this.isSmallFoldOuterScreen) {
      this.buildSmallFoldOuterCard()
    } else {
      this.buildNormalCard()
    }
  }

  @Builder
  buildNormalCard() {
    Column() {
      this.buildBigImage()
      this.buildLiveCard()
    }
    .height(this.cardStyle.height)
    .width(this.cardStyle.width)
    .opacity(this.cardStyle.opacity)
    .enabled(this.cardStyle.enabled)
    .visibility(this.cardStyle.visibility)
  }

  @Builder
  buildSmallFoldOuterCardTip() {
    Column() {
      Image(immersiveVm.getImmersiveCardVm()
        .getCardTipImg(false, !!this.bindCardStateCtrl?.getIsCardFold()))
        .objectFit(ImageFit.Contain)
        .width($r('app.float.immersive_card_tip_img_width'))
        .height($r('app.float.immersive_card_tip_img_height'))
        .fillColor($r('app.color.card_tip_fill_color'))
        .draggable(false)
        .interpolation(ImageInterpolation.Medium)
        .autoResize(false)
        .margin({
          top: $r('app.float.immersive_card_tip_img_margin_top'),
          bottom: $r('app.float.immersive_card_tip_img_margin_bottom')
        })
    }
    .width('100%')
    .onClick(this.handleSmallFoldOuterCardClick)
    .accessibilityDescription(this.bindCardStateCtrl?.getIsCardFold() ?
    ResUtils.getInnerString($r('app.string.immersive_card_tip_to_up')) :
    ResUtils.getInnerString($r('app.string.immersive_card_tip_to_down')))
  }

  @Builder
  buildSmallFoldOuterCard() {
    RelativeContainer() {
      this.buildBigImage()
      Column() {
        this.buildSmallFoldOuterCardTip()
        this.buildLiveCard()
      }
      .onClick((event: ClickEvent) => {
        immersiveVm.getImmersiveCardVm().clickToApp(this.mItemData);
      })
      .gesture(
        PanGesture({
          direction: PanDirection.Down
        })
          .onActionEnd((event: GestureEvent) => {
            immersiveVm.getCardEventHandle().execCardUpDownAnim(true);
          })
      )
      .onAreaChange((oldValue, newValue) => {
        immersiveVm.getImmersiveAnimMgr().setCardViewArea(CardAnimType.CARD_LIVE_CONTENT_TYPE, newValue)
      })
      .translate(this.getCardContentTranslate())
      .scale(this.getCardContentScale())
      .clip(true)
      .backgroundBlurStyle(BlurStyle.Regular)
      .borderRadius(this.cardContentAnimState.getBorderRadiusTL() ?? 20)
      .margin(immersiveVm.getImmersiveCardVm()
        .getCardMargin(false, !!this.bindCardStateCtrl?.getIsCardFold()))
      .backgroundColor(undefined)
      .id(SlIdHelper.getViewId(SlStateMgr.MGR_OUTER_SCREEN, SlWidgetId.IMMERSIVE_lIVE_CARD))
      .alignRules(immersiveVm.getImmersiveCardVm()
        .getCardAlign(false, !!this.bindCardStateCtrl?.getIsCardFold()))
    }
    .onClick(this.handleSmallFoldOuterCardClick)
    .height(this.cardStyle.height)
    .width(this.cardStyle.width)
    .opacity(this.cardStyle.opacity)
    .enabled(this.cardStyle.enabled)
    .visibility(this.cardStyle.visibility)
  }

  private getCardContentScale(): ScaleOptions {
    if (this.cardContentAnimState.isSceneAnimating()) {
      return {
        x: this.cardContentAnimState.getScaleX(),
        y: this.cardContentAnimState.getScaleY()
      }
    }
    return {
      x: AnimValue.VALUE_MAX,
      y: AnimValue.VALUE_MAX
    }
  }

  private getCardContentTranslate(): TranslateOptions {
    if (this.cardContentAnimState.isSceneAnimating()) {
      return {
        x: this.cardContentAnimState.getTranX(),
        y: this.cardContentAnimState.getTranY(),
      }
    }
    return {
      x: AnimValue.VALUE_MIN,
      y: AnimValue.VALUE_MIN
    }
  }

  @Builder
  buildBigImage() {
    // 大图
    Image(this.mItemData?.cardData?.bigIcon)
      .objectFit(ImageFit.Cover)
      .draggable(false)
      .width('100%')
      .height(this.getImageHeight())
      .layoutWeight(1)
      .syncLoad(true)
      .opacity(this.previewAlpha)
  }

  @Builder
  buildLiveCard() {
    // 实况卡片
    if (this.mItemData?.cardData?.cardLiveView) {
      if ((
        this.mItemData?.cardData?.cardLiveView?.template as OtherBaseTemplate)?.layoutType === LiveType.NAVIGATION) {
        this.buildNavigationCard()
      } else {
        this.buildOtherCard()
      }
    }
  }

  @Builder
  buildOtherCard() {
    OtherCard({
      baseData: this.mItemData?.cardData?.cardLiveView,
      data: this.mItemData?.cardData?.cardLiveView?.template as OtherBaseTemplate,
      timerData: (this.mItemData?.cardData?.cardLiveView?.template as OtherBaseTemplate)?.timer,
      useScene: LiveUseScene.SCENE_IMMERSIVE_CARD,
      isImmersiveLive: true,
      customerStyle: this.isSmallFoldOuterScreen ? this.smallFoldOuterStyle : this.customerStyle,
      isSmallFoldOuterScreen: this.isSmallFoldOuterScreen,
    })
  }

  @Builder
  buildNavigationCard() {
    OtherNavigationCard({
      baseData: this.mItemData?.cardData?.cardLiveView,
      data: this.mItemData?.cardData?.cardLiveView?.template as LiveNavigationTemplate,
      useScene: LiveUseScene.SCENE_IMMERSIVE_CARD,
      timerData: (this.mItemData?.cardData?.cardLiveView?.template as LiveNavigationTemplate)?.timer,
      isImmersiveLive: true,
      customerStyle: this.isSmallFoldOuterScreen ? this.smallFoldOuterStyle : this.customerStyle,
      isSmallFoldOuterScreen: this.isSmallFoldOuterScreen,
    })
  }

  private getImageHeight(): string {
    return this.isSmallFoldOuterScreen ? '100%' : '';
  }
}
