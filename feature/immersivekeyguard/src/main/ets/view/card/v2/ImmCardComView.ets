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

import { LengthMetrics } from '@kit.ArkUI';
import { CommonUtils, LogDomain, Logger } from '@ohos/basicutils';
import { LiveCardView } from '@ohos/systemuicommon/newIndex';
import { SlWidgetId } from '@ohos/screenlockcommon';
import {
  SlIdHelper,
  WidgetAnimStateV2,
  WidgetStyleStateV2
} from '@ohos/screenlockcommon/Index';
import { CardAnimSuffix, CardStyleSuffix } from '../../../common/constants/ImmCardConst';
import { ImmCardData } from '../../../model/data/v2/ImmCardData';
import { SlCardBindStateV2 } from '../../../model/data/v2/SlCardBindStateV2';
import { v2Helper } from '../../../viewmodel/v2/helper/ImmersiveV2Helper';
import { ImmersiveLiveVmInjector } from '../../../viewmodel/v2/injector/ImmersiveLiveVmInjector';
import { ImmersiveNtfVmInjector } from '../../../viewmodel/v2/injector/ImmersiveNtfVmInjector';
import { SlCardStaticStateV2 } from '../../../model/data/v2/SlCardStaticStateV2';
import { IImmersiveCardVm } from '../../../common/interface/IImmersiveCardVm';

const TAG = 'ImmCardComView';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

/**
 * V2装饰器，沉浸大卡通用布局组件（大图/UIExtension）
 */
@ComponentV2
export struct ImmCardComView {
  // 沉浸模块通用业务能力注入器
  @Consumer() ntfVmInjector: ImmersiveNtfVmInjector = v2Helper.defaultNtfInjector;

  // 沉浸模块实况通知业务能力注入器
  @Consumer() liveVmInjector: ImmersiveLiveVmInjector = v2Helper.defaultLiveInjector;

  // 大卡条目数据
  @Require @Param cardData: ImmCardData;

  // 沉浸大卡业务管理器
  private cardVm: IImmersiveCardVm = this.ntfVmInjector?.getImmersiveCardVm();

  // 子样式
  private getItemStyle(suffix: CardStyleSuffix): WidgetStyleStateV2 | undefined {
    let helper = this.ntfVmInjector?.getImmItemHelperVm()?.getCardStyleH(suffix);
    return helper?.getItemSt(this.cardData?.getCardShowType());
  }

  // 大卡静态状态
  @Computed get staticSt(): SlCardStaticStateV2 {
    return this.ntfVmInjector?.getImmersiveCardVm()?.getSlStaticState() as SlCardStaticStateV2;
  }

  // 大卡UI绑定状态
  @Computed get bindSt(): SlCardBindStateV2 {
    return this.ntfVmInjector?.getImmersiveCardVm()?.getSlBindState() as SlCardBindStateV2;
  }

  // 大卡通用布局inner样式
  @Computed get innerStyle(): WidgetStyleStateV2 | undefined {
    return this.getItemStyle(CardStyleSuffix.ITEM_INNER_STYLE);
  }

  // 大卡通用布局实况卡片样式
  @Computed get liveStyle(): WidgetStyleStateV2 | undefined {
    return this.getItemStyle(CardStyleSuffix.ITEM_LIVE_STYLE);
  }

  // 大卡通用布局实况卡片箭头样式
  @Computed get liveArrowStyle(): WidgetStyleStateV2 | undefined {
    return this.getItemStyle(CardStyleSuffix.ITEM_LIVE_ARROW_STYLE);
  }

  // 大卡通用布局实况卡片线性渐变背景样式
  @Computed get linearBgStyle(): WidgetStyleStateV2 | undefined {
    return this.getItemStyle(CardStyleSuffix.ITEM_LINEAR_BG_STYLE);
  }

  // 大卡通用布局实况卡片提亮背景样式
  @Computed get brightBgStyle(): WidgetStyleStateV2 | undefined {
    return this.getItemStyle(CardStyleSuffix.ITEM_BRIGHT_BG_STYLE);
  }

  // 大卡定位权限授权提醒样式
  @Computed get authStyle(): WidgetStyleStateV2 | undefined {
    return this.getItemStyle(CardStyleSuffix.ITEM_AUTH_STYLE);
  }

  // 大卡通用布局实况卡片动效
  @Computed get liveAnim(): WidgetAnimStateV2 | undefined {
    let helper = this.ntfVmInjector?.getImmItemHelperVm()?.getCardAnimH(CardAnimSuffix.LIVE_CARD_ANIM);
    return helper?.getItemSt(this.cardData?.getCardShowType());
  }

  // 大卡预览图区域样式（静态图/UIextension/播控通用）
  @Computed get previewStyle(): WidgetStyleStateV2 | undefined {
    return this.getItemStyle(CardStyleSuffix.ITEM_PREVIEW_STYLE);
  }

  // 大卡UIExtension loading组件样式
  @Computed get extLoadingStyle(): WidgetStyleStateV2 | undefined {
    return this.getItemStyle(CardStyleSuffix.ITEM_EXTENSION_LOADING_STYLE);
  }

  aboutToDisappear() {
    log.showInfo(TAG, `aboutToDisappear ${this.cardData?.getHashcode()}`);
    this.cardData?.setExtLoading(false);
    this.cardData?.clearLoadingState(false);
  }

  /**
   * 定位权限提醒布局
   */
  @Builder
  private LocationAuthView() {
    // 背景
    Column()
      .width('100%')
      .backgroundColor(this.authStyle?.getBgColor())
      .opacity(this.previewStyle?.getAlpha())
      .alignRules({
        top: { anchor: SlWidgetId.ROOT_ID, align: VerticalAlign.Top },
        // 非全屏时，内容保持实况卡片上方
        bottom: this.bindSt?.isContentFullEnable() ? { anchor: SlWidgetId.ROOT_ID, align: VerticalAlign.Bottom } :
          { anchor: this.getViewId(SlWidgetId.IMMERSIVE_lIVE_CARD), align: VerticalAlign.Top }
      })

    // 内容
    Column() {
      // 提示内容占用剩余空间，居中
      Column() {
        // 权限提醒图标
        if (!this.bindSt?.isHideAuthImg()) {
          Image($r('app.media.no_permission'))
            .draggable(false)
            .objectFit(ImageFit.Contain)
            .interpolation(ImageInterpolation.Medium)
            .height($r('app.float.immersive_location_img_size'))
            .width($r('app.float.immersive_location_img_size'))
            .margin({ bottom: $r('app.float.immersive_location_img_margin_bottom') })
        }

        // 权限提醒提示语
        Text(this.cardData?.locationNoPermissionTip)
          .fontFamily('HarmonyHeiTi')
          .fontWeight(FontWeight.Regular)
          .fontSize($r('app.float.immersive_location_font_size'))
          .fontColor($r('sys.color.ohos_id_color_text_secondary'))
          .maxFontScale(this.authStyle?.getMaxFontScale())
      }
      .justifyContent(FlexAlign.Center)
      .layoutWeight(1)

      // 设置按钮底部对齐
      Row() {
        Text($r('app.string.immersive_go_auth'))
          .fontFamily('HarmonyHeiTi')
          .fontWeight(FontWeight.Medium)
          .fontSize($r('app.float.immersive_authorize_font_size'))
          .fontColor($r('sys.color.ohos_id_color_emphasize'))
          .maxFontScale(this.authStyle?.getMaxFontScale())
      }
      .height($r('app.float.immersive_location_info_height'))
      .width(this.authStyle?.getWidth())
      .constraintSize({ maxWidth: $r('app.float.immersive_location_info_max_width') })
      .borderRadius($r('sys.float.corner_radius_level10'))
      .backgroundColor($r('sys.color.comp_background_tertiary'))
      .justifyContent(FlexAlign.Center)
      .accessibilityLevel('yes')
      .onClick(() => this.cardVm?.onAuthBtnClick(this.cardData))
    }
    .margin({
      top: this.authStyle?.getMarginT(),
      bottom: this.authStyle?.getMarginB(),
      start: LengthMetrics.vp(this.authStyle?.getMarginL()),
      end: LengthMetrics.vp(this.authStyle?.getMarginR())
    })
    .width(this.getAuthContentWidth())
    .justifyContent(FlexAlign.End)
    .alignRules({
      top: { anchor: SlWidgetId.ROOT_ID, align: VerticalAlign.Top },
      // 内容保持实况卡片上方
      bottom: { anchor: this.getViewId(SlWidgetId.IMMERSIVE_lIVE_CARD), align: VerticalAlign.Top }
    })
    .opacity(this.previewStyle?.getAlpha())
  }

  /**
   * 沉浸UIExtension
   */
  @Builder
  private CardUIExtensionView() {
    UIExtensionComponent(this.cardData?.getUIWant())
      .draggable(false)
      .width('100%')
      .onRemoteReady((proxy) => {
        log.showInfo(TAG, `CardUIExtensionView onRemoteReady: ${this.cardData?.getGroupKey()}`);
        this.cardData?.setExtOnRemoteReady(proxy);
      })
      .onReceive((receiveData) => {
        this.cardData?.setLocationErrCode(Number(receiveData?.errCode ?? 0));
      })
      .onTerminated((info: TerminationInfo) => {
        log.showInfo(TAG, `CardUIExtensionView onTerminated ${info?.code}, ${this.cardData?.getGroupKey()}`);
      })
      .onError((error) => {
        log.showError(TAG, `CardUIExtensionView onError ${error?.message} code: ${error?.code}`);
      })
      .hitTestBehavior(this.cardData?.isInteraction() ? HitTestMode.Block : HitTestMode.None)
      .alignRules({
        top: { anchor: SlWidgetId.ROOT_ID, align: VerticalAlign.Top },
        // 非全屏时，内容保持实况卡片上方
        bottom: this.bindSt?.isContentFullEnable() ? { anchor: SlWidgetId.ROOT_ID, align: VerticalAlign.Bottom } :
          { anchor: this.getViewId(SlWidgetId.IMMERSIVE_lIVE_CARD), align: VerticalAlign.Top }
      })
      .opacity(this.previewStyle?.getAlpha())
      .visibility(this.getExtVisibility())
  }

  /**
   * 沉浸UIExtension loading布局
   */
  @Builder
  private CardUIExtensionLoadingView() {
    Column({ space: this.extLoadingStyle?.getItemSpace() }) {
      LoadingProgress()
        .height(this.extLoadingStyle?.getHeight())
        .width(this.extLoadingStyle?.getWidth())
      Text($r('app.string.text_loading'))
        .fontSize($r('sys.float.ohos_id_text_size_body2'))
        .fontColor($r('sys.color.font_secondary'))
    }
    .width('100%')
    .visibility(this.getExtLoadingVisibility())
    .opacity(this.previewStyle?.getAlpha())
    .backgroundColor(this.extLoadingStyle?.getBgColor())
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .alignRules({
      top: { anchor: SlWidgetId.ROOT_ID, align: VerticalAlign.Top },
      // 内容保持实况卡片上方
      bottom: { anchor: this.getViewId(SlWidgetId.IMMERSIVE_lIVE_CARD), align: VerticalAlign.Top }
    })
  }

  /**
   * 沉浸大图
   */
  @Builder
  private CardBigImgView() {
    Image(this.cardData?.getBigPic())
      .objectFit(ImageFit.Cover)
      .draggable(false)
      .syncLoad(true)
      .width('100%')
      .opacity(this.previewStyle?.getAlpha())
      .alignRules({
        top: { anchor: SlWidgetId.ROOT_ID, align: VerticalAlign.Top },
        // 非全屏时，大图保持实况卡片上方
        bottom: this.bindSt?.isContentFullEnable() ? { anchor: SlWidgetId.ROOT_ID, align: VerticalAlign.Bottom } :
          { anchor: this.getViewId(SlWidgetId.IMMERSIVE_lIVE_CARD), align: VerticalAlign.Top }
      })
  }

  /**
   * 实况卡片模糊背景
   */
  @Builder
  private LiveCardBgView() {
    Stack() {
      // 模糊背景
      Column()
        .width('100%')
        .height('100%')
        .backgroundBlurStyle(this.brightBgStyle?.getBgBlurStyle())

      // 提亮背景
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor(this.brightBgStyle?.getBgColor())
        .backgroundBrightnessInternal(this.brightBgStyle?.getBgBrightnessInner())

      // 渐变背景
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor(this.linearBgStyle?.getBgColor())
        .linearGradient(this.linearBgStyle?.getLinearGradient())
    }
    // 背景保持卡片内容大小
    .alignRules({
      left: { anchor: SlWidgetId.ROOT_ID, align: HorizontalAlign.Start },
      right: { anchor: SlWidgetId.ROOT_ID, align: HorizontalAlign.End },
      top: { anchor: this.getViewId(SlWidgetId.IMMERSIVE_lIVE_CARD), align: VerticalAlign.Top },
      bottom: { anchor: SlWidgetId.ROOT_ID, align: VerticalAlign.Bottom }
    })
    .margin({
      start: LengthMetrics.vp(this.liveStyle?.getMarginL()),
      end: LengthMetrics.vp(this.liveStyle?.getMarginR()),
      bottom: LengthMetrics.vp(this.liveStyle?.getMarginB())
    })
    .clip(true)
    // 控制卡片收拢/展开
    .markAnchor(this.liveStyle?.getMarkAnchor())
    .borderRadius(this.getLiveCardRadius())
    .scale(this.getLiveCardScale())
    .translate(this.getLiveCardTran())
  }

  /**
   * 实况卡片上方箭头
   */
  @Builder
  private LiveCardTopArrow() {
    Stack() {
      Image(this.liveArrowStyle?.getImgSrc())
        .draggable(false)
        .autoResize(false)
        .objectFit(ImageFit.Contain)
        .interpolation(ImageInterpolation.Medium)
        .width(this.liveArrowStyle?.getWidth())
        .height(this.liveArrowStyle?.getHeight())
        .fillColor(this.liveArrowStyle?.getFillColor())
        .margin({
          top: this.liveArrowStyle?.getMarginT(),
          bottom: this.liveArrowStyle?.getMarginB()
        })
    }
    .width('100%')
    .accessibilityDescription(this.liveArrowStyle?.getAccessibilityLevel())
    .onClick(() => this.cardVm?.onLiveArrowClick?.())
  }

  /**
   * 实况卡片复用
   */
  @Builder
  private LiveCardView() {
    Column() {
      // 顶部箭头开启
      if (this.bindSt?.isLiveArrowEnable()) {
        this.LiveCardTopArrow()
      }

      // 实况卡片内容
      LiveCardView({ live: this.cardData?.getOriData() })
    }
    .id(this.getViewId(SlWidgetId.IMMERSIVE_lIVE_CARD))
    .zIndex(this.liveStyle?.getZIndex())
    .alignRules({
      left: { anchor: SlWidgetId.ROOT_ID, align: HorizontalAlign.Start },
      right: { anchor: SlWidgetId.ROOT_ID, align: HorizontalAlign.End },
      bottom: { anchor: SlWidgetId.ROOT_ID, align: VerticalAlign.Bottom }
    })
    .margin({
      start: LengthMetrics.vp(this.liveStyle?.getMarginL()),
      end: LengthMetrics.vp(this.liveStyle?.getMarginR()),
      bottom: LengthMetrics.vp(this.liveStyle?.getMarginB())
    })
    .padding({
      start: LengthMetrics.vp(this.liveStyle?.getPaddingL()),
      end: LengthMetrics.vp(this.liveStyle?.getPaddingR()),
      bottom: LengthMetrics.vp(this.liveStyle?.getPaddingB())
    })
    .clip(true)
    // 控制卡片收拢/展开
    .markAnchor(this.liveStyle?.getMarkAnchor())
    // 背景色用于AOD截图
    .backgroundColor(this.liveStyle?.getBgColor())
    .borderRadius(this.getLiveCardRadius())
    .width(this.getLiveCardWidth())
    .scale(this.getLiveCardScale())
    .translate(this.getLiveCardTran())
    .gestureModifier(this.liveStyle?.getGestureModifier())
    .onClick(this.getLiveCardClick())
    .onSizeChange((oldValue, newValue) =>
      this.cardVm?.onLiveCardSizeChange?.(this.cardData?.getGroupKey(), newValue))
  }

  build() {
    RelativeContainer() {
      // UIExtension样式
      if (this.cardData?.isUiExtensionCard()) {
        // 定位权限授权提示
        if (this.cardData?.isShowLocationErr()) {
          this.LocationAuthView()
        } else {
          // 正常内容
          this.CardUIExtensionView()
          // loading组件
          this.CardUIExtensionLoadingView()
        }
      } else {
        // 底部大图样式
        this.CardBigImgView()
      }

      // 底部实况卡片
      this.LiveCardView()

      // 实况卡片背景
      if (this.bindSt?.isLiveBgBlurEnable()) {
        this.LiveCardBgView()
      }
    }
    .clip(true)
    .width('100%')
    .height('100%')
    .opacity(this.innerStyle?.getAlpha())
    .borderRadius(this.innerStyle?.getBorderRadiusTL())
    .backgroundColor(this.innerStyle?.getBgColor())
    .onClick(this.getRootClick())
  }

  private getLiveCardRadius(): number | undefined {
    let styleRadius = this.liveStyle?.getBorderRadiusTL();
    if (this.liveAnim?.isWidgetAnimating()) {
      return this.liveAnim?.getBorderRadiusTL() ?? styleRadius;
    }
    return styleRadius;
  }

  private getLiveCardScale(): ScaleOptions | undefined {
    if (this.liveAnim?.isWidgetAnimating()) {
      return { x: this.liveAnim?.getScaleX(), y: this.liveAnim?.getScaleY() };
    }
    return undefined;
  }

  private getLiveCardTran(): TranslateOptions | undefined {
    if (this.liveAnim?.isWidgetAnimating()) {
      return { x: this.liveAnim?.getTranX(), y: this.liveAnim?.getTranY() };
    }
    return undefined;
  }

  /**
   * 实况卡片宽度限制
   *
   * @returns 宽度
   */
  private getLiveCardWidth(): string {
    let marginL = this.liveStyle?.getMarginL() ?? 0;
    let marginR = this.liveStyle?.getMarginR() ?? 0;
    return `calc(100% - ${CommonUtils.spliceVp(marginL + marginR)})`;
  }

  /**
   * 定位权限内容宽度限制
   *
   * @returns 宽度
   */
  private getAuthContentWidth(): string {
    let marginL = this.authStyle?.getMarginL() ?? 0;
    let marginR = this.authStyle?.getMarginR() ?? 0;
    return `calc(100% - ${CommonUtils.spliceVp(marginL + marginR)})`;
  }

  /**
   * 全局点击，实况卡片收拢/展开
   *
   * @returns 点击事件
   */
  private getRootClick(): (() => void) | undefined {
    if (this.cardVm?.onLiveArrowClick) {
      return () => {
        this.cardVm?.onLiveArrowClick?.();
      };
    }
    return undefined;
  }

  /**
   * 实况卡片点击事件
   *
   * @returns 点击事件
   */
  private getLiveCardClick(): (() => void) | undefined {
    if (this.bindSt?.isItemCLickInner()) {
      return () => {
        this.cardVm?.onItemClick(this.cardData);
      };
    }
    return undefined;
  }

  /**
   * 子组件ID拼接
   *
   * @param id 组件ID
   * @returns 拼接ID
   */
  private getViewId(id: SlWidgetId): string {
    return SlIdHelper.getViewId(this.ntfVmInjector?.getStateMgr(), id);
  }

  /**
   * 获取uiExtension组件显示参数
   *
   * @returns uiExtension组件显示
   */
  private getExtVisibility(): Visibility {
    let loading = this.cardData?.isExtLoading();
    return loading ? Visibility.Hidden : Visibility.Visible;
  }

  /**
   * 获取uiExtension loading组件显示参数
   *
   * @returns uiExtension loading组件显示
   */
  private getExtLoadingVisibility(): Visibility {
    let loading = this.cardData?.isExtLoading();
    return loading ? Visibility.Visible : Visibility.None;
  }
}