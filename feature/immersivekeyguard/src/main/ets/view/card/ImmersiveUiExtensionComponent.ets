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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  AnimValue,
  LiveNavigationTemplate,
  LiveSystemTemplate,
  LiveType,
  LiveUseScene,
  OtherBaseTemplate,
  SysTypeCode
} from '@ohos/systemuicommon';
import { SlWidgetId } from '@ohos/screenlockcommon';
import { SlStateMgr } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { CardAnimType, ImmersiveConstants } from '../../common/ImmersiveConstants';
import { ImmersiveCardData } from '../../viewmodel/viewdata/ImmersiveCardData';
import { immersiveVm } from '../../viewmodel/ImmersiveVm';
import { ImmersiveNtfData } from '../../viewmodel/viewdata/ImmersiveNtfData';
import { OtherCard } from '@ohos/systemuicommon/src/main/ets/liveview/component/card/OtherCard';
import { OtherNavigationCard } from '@ohos/systemuicommon/src/main/ets/liveview/component/card/OtherNavigationCard';
import { LiveCustomerStyle } from '@ohos/systemuicommon/src/main/ets/liveview/info/card/LiveCustomerStyle';
import { BrightnessOptionUtils, ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import { ImmersiveCardStyle } from '../../model/data/ImmersiveCardStyle';
import { ImmersiveCardVm } from '../../viewmodel/ImmersiveCardVm';
import {
  ImmersiveCardConst,
  ImmersiveCardUIExtentionNoLocationConst
} from '../../common/constants/ImmersiveCardConst';
import { immersiveStateHelper } from '../../common/helper/ImmersiveStateHelper';
import { SlCardWidgetBindState } from '../../model/data/SlCardWidgetBindState';
import { SlIdHelper, WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { SystemCard } from '@ohos/systemuicommon/src/main/ets/liveview/component/card/SystemCard';
import { ResUtils } from '@ohos/windowscene';
import { cardList, ImmersiveCardList } from '../../viewmodel/viewdata/ImmersiveCardList';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';

const TAG = 'ImmersiveUiExtensionComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

// loading时长
const MAX_LOADING_TIME_MS: number = 500;

@Component
export struct ImmersiveUiExtensionComponent {
  private itemName: string = '';
  @ObjectLink @Watch('onDataChange') mItemData: ImmersiveNtfData;
  @State cardData: ImmersiveCardData =
    immersiveVm.getImmersiveCardVm().getShowList()?.showData?.cardData as ImmersiveCardData;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State cardContentAnimState: WidgetAnimState =
    immersiveVm.getImmersiveAnimMgr().getCardAnimState(CardAnimType.CARD_LIVE_CONTENT_TYPE);
  @Prop cardStyle: ImmersiveCardStyle;
  @Prop previewAlpha: number;
  @Prop isSmallFoldOuterScreen: boolean = false;
  private immersiveCardVm: ImmersiveCardVm = immersiveVm.getImmersiveCardVm();
  private customerStyle: LiveCustomerStyle = this.immersiveCardVm?.getLiveStyle();
  private smallFoldOuterStyle: LiveCustomerStyle = immersiveVm.getImmersiveCardVm()?.getSmallFoldOuterStyle();
  @State bindCardStateCtrl: SlCardWidgetBindState | undefined =
    immersiveStateHelper.getImmerseCardBindState() as SlCardWidgetBindState;
  @State cardBgSize: SizeOptions = { width: 278, height: this.cardData?.isMediaCenter() ? 108 : 76 };
  @State isLoading: boolean = true;
  // 沉浸卡片loading加载定时器
  private loadingStateTimer?: number;

  /**
   * 沉浸卡片UI数据
   */
  private showList: ImmersiveCardList = cardList;

  private handleSmallFoldOuterCardClick: () => void = () => {
    immersiveVm.getCardEventHandle().execCardUpDownAnim(!(this.bindCardStateCtrl?.getIsCardFold()));
  };

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    this.cardData.locationErrorCode = Infinity;
    this.clearLoadingState(false);
  }

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
      this.buildExtensionComponent()
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
      Image(this.immersiveCardVm.getCardTipImg(false, !!this.bindCardStateCtrl?.getIsCardFold()))
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
      this.buildSmallFoldOuterExtensionComponent()
      Column() {
        if (SystemUICcmConfig.instance.isEnabledLive2) {
          this.buildOuterSmallCardBg()
        }
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
        this.cardBgSize = { width: newValue.width, height: newValue.height };
        immersiveVm.getImmersiveAnimMgr().setCardViewArea(CardAnimType.CARD_LIVE_CONTENT_TYPE, newValue)
      })
      .translate(this.getCardContentTranslate())
      .scale(this.getCardContentScale())
      .clip(true)
      .backgroundBlurStyle(this.getBackgroundBlurStyle())
      .borderRadius(ImmersiveCardConst.CARD_RADIUS_SMALL_FOLD)
      .margin(this.immersiveCardVm.getCardMargin(false, !!this.bindCardStateCtrl?.getIsCardFold()))
      .backgroundColor(undefined)
      .id(this.getOuterLiveCardId())
      .alignRules(this.immersiveCardVm.getCardAlign(false, !!this.bindCardStateCtrl?.getIsCardFold()))
    }
    .onClick(this.cardData?.isSupportInteraction ? undefined : this.handleSmallFoldOuterCardClick)
    .height(this.cardStyle.widescreenHeight)
    .width(this.cardStyle.widescreenWidth)
    .backgroundColor(this.getSmallFoldOuterCardContainerBgColor())
    .opacity(this.cardStyle.opacity)
    .enabled(this.cardStyle.enabled)
    .visibility(this.cardStyle.visibility)
  }

  @Builder
  buildSmallFoldOuterNoLocationComponent() {
    Column({ space: ImmersiveCardUIExtentionNoLocationConst.IMG_TEXT_SPACE }) {
      LoadingProgress()
        .height(ImmersiveCardUIExtentionNoLocationConst.IMG_SIZE)
        .width(ImmersiveCardUIExtentionNoLocationConst.IMG_SIZE)
      Text($r('app.string.text_loading'))
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.font_secondary'))
    }
    .width('100%')
    .opacity(this.previewAlpha)
    .visibility(this.getNoLocationVisibility())
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .alignRules({
      bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
      top: { anchor: '__container__', align: VerticalAlign.Top },
    })
    .margin({
      top: ImmersiveCardUIExtentionNoLocationConst.MARGIN_TOP,
    })
  }

  @Builder
  buildNoLocationComponent() {
    Column({ space: ImmersiveCardUIExtentionNoLocationConst.IMG_TEXT_SPACE }) {
      LoadingProgress()
        .height(ImmersiveCardUIExtentionNoLocationConst.IMG_SIZE)
        .width(ImmersiveCardUIExtentionNoLocationConst.IMG_SIZE)
      Text($r('app.string.text_loading'))
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.font_secondary'))
    }
    .width('100%')
    .height('100%')
    .layoutWeight(1)
    .opacity(this.previewAlpha)
    .visibility(this.getNoLocationVisibility())
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.getNoLocationBgColor())
  }

  @Builder
  buildExtensionComponent() {
    // 扩展组件
    if (this.cardData?.immersiveWant) {
      if (this.isLocationError()) {
        this.buildAuthOverlay()
      } else {
        Stack() {
          this.buildUiExtension()
          this.buildNoLocationComponent()
        }
        .width('100%')
        .height('100%')
        .layoutWeight(1)
      }
    }
  }

  @Builder
  buildSmallFoldOuterExtensionComponent() {
    // 扩展组件
    if (this.cardData?.immersiveWant) {
      if (this.isLocationError()) {
        this.buildSmallFoldOuterAuthOverlay()
      } else {
        this.buildSmallFoldOuterUiExtension()
      }
    }
  }

  @Builder
  buildLiveCard() {
    if (this.cardData?.cardLiveView) {
      // 实况卡片
      if ((this.cardData?.cardLiveView?.template as OtherBaseTemplate)?.layoutType ===
      LiveType.NAVIGATION) {
        this.buildNavigationCard()
      } else if (this.cardData?.liveView?.sysTypeCode === SysTypeCode.SCENARIO_MODE) {
        this.buildIntelligentCard()
      } else {
        this.buildOtherCard()
      }
    }
  }

  @Builder
  buildUiExtension() {
    UIExtensionComponent(this.cardData?.immersiveWant)
      .draggable(false)
      .width('100%')
      .height('100%')
      .layoutWeight(1)
      .opacity(this.previewAlpha)
      .onRemoteReady((proxy: UIExtensionProxy) => {
        this.extensionOnRemoteReady(proxy);
      })
      .onReceive((receiveData: Record<string, Object>) => {
        this.cardData = this.immersiveCardVm.receiveExtensionData(this.cardData, receiveData);
      })
      .onTerminated((info: TerminationInfo) => {
        log.showInfo(`onTerminated ${info.code}`);
      })
      .onError((error: ErrorObject) => {
        log.showError(`onError ${error.message} code: ${error.code}`);
      })
      .hitTestBehavior(this.cardData?.isSupportInteraction ? HitTestMode.Block :
      HitTestMode.None)
      .visibility(this.getUIExtensionVisibility())
  }

  @Builder
  buildSmallFoldOuterUiExtension() {
    Column() {
      this.buildUiExtension()
    }
    .alignRules({
      bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
      top: { anchor: '__container__', align: VerticalAlign.Top },
    })
    this.buildSmallFoldOuterNoLocationComponent()
  }

  @Builder
  buildNoPermissionText() {
    Text(this.immersiveCardVm.getNoPermissionTip(this.cardData))
      .fontSize($r('app.float.immersive_location_font_size'))
      .maxFontScale(this.cardStyle.uiExtensionTipFontScale)
      .fontWeight(FontWeight.Regular)
      .fontFamily('HarmonyHeiTi')
      .lineHeight(this.cardStyle.uiExtensionTipLineHeight)
      .fontColor($r('sys.color.ohos_id_color_text_secondary'))
      .textAlign(TextAlign.Center)
  }

  @Builder
  buildGoAuthText() {
    Text($r('app.string.immersive_go_auth'))
      .fontSize($r('app.float.immersive_authorize_font_size'))
      .maxFontScale(this.cardStyle.uiExtensionTipFontScale)
      .fontWeight(FontWeight.Medium)
      .fontFamily('HarmonyHeiTi')
      .fontColor($r('sys.color.ohos_id_color_emphasize'))
      .lineHeight(this.cardStyle.uiExtensionTipBtnLineHeight)
  }

  @Builder
  buildAuthOverlay() {
    Column() {
      Column() {
        if (this.cardStyle.uiExtensionTipImageVisibility) {
          Image($r('app.media.no_permission'))
            .objectFit(ImageFit.Contain)
            .draggable(false)
            .interpolation(ImageInterpolation.Medium)
            .height($r('app.float.immersive_location_img_size'))
            .width($r('app.float.immersive_location_img_size'))
            .margin({ bottom: $r('app.float.immersive_location_img_margin_bottom') })
        }
        this.buildNoPermissionText()
      }
      .justifyContent(FlexAlign.Center)
      .layoutWeight(1)
      .padding({
        left: $r('app.float.immersive_live_card_app_margin'),
        right: $r('app.float.immersive_live_card_app_margin')
      })

      Row() {
        this.buildGoAuthText()
      }
      .margin({ bottom: $r('app.float.immersive_location_info_margin_bottom') })
      .height($r('app.float.immersive_location_info_height'))
      .width(this.cardStyle.uiExtensionTipBtnWidth)
      .constraintSize({ maxWidth: $r('app.float.immersive_location_info_max_width') })
      .borderRadius($r('sys.float.corner_radius_level10'))
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .justifyContent(FlexAlign.Center)
      .accessibilityLevel('yes')
      .onClick((event: ClickEvent) => {
        this.immersiveCardVm.onclickGoSettingBtn(this.cardData, this.mItemData);
      })
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.End)
    .backgroundColor(this.colorModeViewData.noPermissionBgc)
    .width('100%')
    .layoutWeight(1)
    .opacity(this.previewAlpha)
  }

  @Builder
  buildSmallFoldOuterAuthOverlay() {
    Column() {
      this.buildNoPermissionText()
    }
    .opacity(this.previewAlpha)
    .width(this.cardStyle.uiExtensionTipBtnWidth)
    .justifyContent(FlexAlign.Center)
    .alignRules({
      top: { anchor: '__container__', align: VerticalAlign.Top },
      middle: { anchor: '__container__', align: HorizontalAlign.Center },
      bottom: { anchor: ImmersiveConstants.IMMERSIVE_GO_TO_AUTH_BTN_ID, align: VerticalAlign.Top },
    })
    .margin({
      top: ImmersiveCardConst.CARD_NO_PERMISSION_MARGIN_SMALL_FOLD,
    })

    Row() {
      this.buildGoAuthText()
    }
    .height($r('app.float.immersive_location_info_height'))
    .width(this.cardStyle.uiExtensionTipBtnWidth)
    .constraintSize({ maxWidth: $r('app.float.immersive_location_info_max_width') })
    .borderRadius($r('sys.float.corner_radius_level10'))
    .backgroundColor($r('sys.color.comp_background_tertiary'))
    .justifyContent(FlexAlign.Center)
    .accessibilityLevel('yes')
    .onClick((event: ClickEvent) => {
      this.immersiveCardVm.onclickGoSettingBtn(this.cardData, this.mItemData);
    })
    .opacity(this.previewAlpha)
    .margin({
      bottom: ImmersiveCardConst.CARD_MARGIN_SMALL_FOLD,
    })
    .id(ImmersiveConstants.IMMERSIVE_GO_TO_AUTH_BTN_ID)
    .alignRules({
      bottom: { anchor: this.getOuterLiveCardId(), align: VerticalAlign.Top },
      left: { anchor: this.getOuterLiveCardId(), align: HorizontalAlign.Start },
    })
  }

  @Builder
  buildOtherCard() {
    OtherCard({
      baseData: this.cardData?.cardLiveView,
      data: this.cardData?.cardLiveView?.template as OtherBaseTemplate,
      timerData: (this.cardData?.cardLiveView?.template as OtherBaseTemplate)?.timer,
      useScene: LiveUseScene.SCENE_IMMERSIVE_CARD,
      isImmersiveLive: true,
      customerStyle: this.isSmallFoldOuterScreen ? this.smallFoldOuterStyle : this.customerStyle,
      isSmallFoldOuterScreen: this.isSmallFoldOuterScreen,
    })
  }

  @Builder
  buildIntelligentCard() {
    SystemCard({
      baseData: this.cardData?.cardLiveView,
      data: this.cardData?.cardLiveView?.template as LiveSystemTemplate,
      useScene: LiveUseScene.SCENE_IMMERSIVE_CARD,
      isImmersiveLive: true,
      customerStyle: this.isSmallFoldOuterScreen ? this.smallFoldOuterStyle : this.customerStyle,
      isSmallFoldOuterScreen: this.isSmallFoldOuterScreen,
    })
  }

  @Builder
  buildNavigationCard() {
    OtherNavigationCard({
      baseData: this.cardData?.cardLiveView,
      data: this.cardData?.cardLiveView?.template as LiveNavigationTemplate,
      useScene: LiveUseScene.SCENE_IMMERSIVE_CARD,
      timerData: (this.cardData?.cardLiveView?.template as LiveNavigationTemplate)?.timer,
      isImmersiveLive: true,
      customerStyle: this.isSmallFoldOuterScreen ? this.smallFoldOuterStyle : this.customerStyle,
      isSmallFoldOuterScreen: this.isSmallFoldOuterScreen,
    })
  }

  @Builder
  buildOuterSmallCardBg() {
    Stack() {
      Column() {
      }
      .width('100%')
      .height('100%')
      .backgroundBlurStyle(BlurStyle.Regular)

      Column() {
      }
      .width('100%')
      .height('100%')
      .backgroundColor('rgba(0, 0, 0, 1)')
      .backgroundBrightnessInternal(BrightnessOptionUtils.bannerCardDarkOption)

      Column() {
      }
      .width('100%')
      .height('100%')
      .backgroundColor('rgba(0, 0, 0, 0.1)')
      .linearGradient({
        direction: GradientDirection.Top,
        colors: [['rgba(0, 0, 0, 0)', 0], ['rgba(0, 0, 0, 0)', 1]]
      })
    }
    .position({ left: 0, top: 0 })
    .size(this.cardBgSize)
  }

  private getBackgroundBlurStyle() {
    if (SystemUICcmConfig.instance.isEnabledLive2 && this.isSmallFoldOuterScreen) {
      return BlurStyle.NONE;
    }
    return BlurStyle.Regular;
  }

  private getUIExtensionVisibility(): Visibility {
    return this.isLoading ? Visibility.Hidden : Visibility.Visible
  }

  private getNoLocationVisibility(): Visibility {
    return this.isLoading ? Visibility.Visible : Visibility.None;
  }

  private getSmallFoldOuterCardContainerBgColor(): ResourceColor | undefined {
    return this.isLoading ? this.getNoLocationBgColor() : this.getSmallFoldOuterCardBgColor();
  }

  private extensionOnRemoteReady(proxy: UIExtensionProxy): void {
    let isUiExtensionCache = this.showList.isUiExtensionCache(this.mItemData);
    log.showInfo(`onRemoteReady hashcode:${this.mItemData?.hashCode} isUiExtensionCache：${isUiExtensionCache}`);
    if (!isUiExtensionCache) {
      this.isLoading = true;
      this.delayUpdateLoadingState();
    } else {
      this.isLoading = false;
    }
  }

  /**
   * 清除定时器
   */
  private clearLoadingState(hasTimeout: boolean): void {
    if (this.loadingStateTimer) {
      if (!hasTimeout) {
        clearTimeout(this.loadingStateTimer);
      }
      this.loadingStateTimer = undefined;
    }
  }

  /**
   * 创建定时器
   */
  private delayUpdateLoadingState(): void {
    this.clearLoadingState(false);
    this.loadingStateTimer = setTimeout(() => {
      this.clearLoadingState(true);
      this.isLoading = false;
    }, MAX_LOADING_TIME_MS);
  }

  private getNoLocationBgColor(): ResourceColor | undefined {
    return this.isSmallFoldOuterScreen ? $r('sys.color.ohos_id_color_sub_background') :
    this.colorModeViewData.noLocationBgc;
  }

  /**
   * 小外屏实况卡片ID
   *
   * @returns 实况卡片ID
   */
  private getOuterLiveCardId(): string {
    return SlIdHelper.getViewId(SlStateMgr.MGR_OUTER_SCREEN, SlWidgetId.IMMERSIVE_lIVE_CARD);
  }

  private getSmallFoldOuterCardBgColor(): ResourceColor | undefined {
    if (this.cardData?.immersiveWant) {
      if (this.isLocationError()) {
        return this.cardStyle.uiExtensionTipBackgroundColor ?? this.colorModeViewData.noPermissionBgc;
      } else {
        return this.colorModeViewData.brightnessBlockColor;
      }
    }
    return undefined;
  }

  private isLocationError() {
    return this.immersiveCardVm.hasLocationErrorCode(this.cardData.locationErrorCode);
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
}

interface ErrorObject {
  code: number;
  name: string;
  message: string;
}