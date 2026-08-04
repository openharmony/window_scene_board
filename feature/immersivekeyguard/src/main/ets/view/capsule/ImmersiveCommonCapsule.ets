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

import {
  LiveProgressComponent
} from '@ohos/systemuicommon/src/main/ets/liveview/component/card/SystemComponent/LiveProgressComponent';
import {
  LiveButtonComponent
} from '@ohos/systemuicommon/src/main/ets/liveview/component/card/SystemComponent/LiveButtonComponent';
import {
  LiveTimeComponent
} from '@ohos/systemuicommon/src/main/ets/liveview/component/card/SystemComponent/LiveTimeComponent';
import {
  ExtendComponent
} from '@ohos/systemuicommon/src/main/ets/liveview/component/card/OtherComponent/ExtendComponent';
import { AccessibilityAppName } from '@ohos/systemuicommon/src/main/ets/accessibility/AccessibilityAppName';
import {
  AodStyleType,
  bannerMgr,
  DarkModeState,
  ImmersiveAodStyle,
  immersiveKgMgr,
  LiveBaseTemplate,
  LiveButtonData,
  LiveTimerData,
  OverlayIconStyle
} from '@ohos/systemuicommon';
import { CapFadeTextStyle, CapItemId } from '../../common/constants/CapsuleLayoutStyle';
import { ImmersiveCapsuleConstants as CapConst } from '../../common/constants/ImmersiveCapsuleConstants';
import { ImmersiveCapsuleStyle } from '../../model/data/ImmersiveCapsuleStyle';
import { ImmersiveCapsuleData } from '../../viewmodel/viewdata/ImmersiveCapsuleData';
import { ImmersiveExtendStyle } from '../../model/data/ImmersiveExtendStyle';
import { immersiveVm } from '../../viewmodel/ImmersiveVm';
import {
  ColorModeViewData,
  ColorModeViewModel,
  BrightnessOptionUtils
} from '@ohos/systemuicommon/Index';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { SlVisualArgs, SlPositionType, SlVisualConfigManager, CcmOption, SlAreaType } from '@ohos/screenlockcommon';
import { LengthMetrics } from '@ohos.arkui.node';
import { WDefault } from '@ohos/screenlockcommon';
import { AppProtectedVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedVm';
import { SlVisualControl } from '@ohos/screenlockcommon/src/main/ets/visual/SlVisualControl';
import { ImmersiveDeliverBadge } from '../common/ImmersiveDeliverBadge';

/**
 * 沉浸胶囊实况样式
 */
@Component
export struct ImmersiveCommonCapsule {
  /**
   * 胶囊数据
   */
  @ObjectLink capsuleData: ImmersiveCapsuleData;
  @ObjectLink baseTemplate: LiveBaseTemplate;
  @ObjectLink templateTime: LiveTimerData;
  /**
   * 胶囊扩展样式
   */
  @ObjectLink capsuleStyle: ImmersiveCapsuleStyle;
  /**
   * 是否开启辅助功能朗读模式
   */
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  /**
   * Aod显示样式
   */
  @State aodStyle: ImmersiveAodStyle | undefined = immersiveKgMgr.getOneMirrorState().getAodStyle(true);

  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();

  /** 深色模式状态
   */
  @State darkMode: DarkModeState = bannerMgr.getBannerState().darkModeState as DarkModeState;

  /**
   * 辅助区样式
   */
  private extendStyle: ImmersiveExtendStyle = immersiveVm.getCapsuleExtendStyle();

  /**
   * 动效状态
   */
  @ObjectLink animState: WidgetAnimState;

  /**
   * 根据壁纸计算是否压暗
   */
  @Prop isDarken: boolean = false;

  /**
   * 应用是否加锁状态单例
   */
  @State appProtectedVm: AppProtectedVm = AppProtectedVm.get();

  @State contentBrightArgs?: SlVisualArgs =
    SlVisualControl.getInstance().getVisualArgs(SlPositionType.SL_CAP_FIRST_FOREGROUND);
  @State shadowBrightArgs?: SlVisualArgs =
    SlVisualControl.getInstance().getVisualArgs(SlPositionType.SL_CAP_SECOND_FOREGROUND);
  @State contentBackBrightArgs?: SlVisualArgs =
    SlVisualControl.getInstance().getVisualArgs(SlPositionType.SL_CAP_FIRST_BACKGROUND);
  @State secondBackBrightArgs?: SlVisualArgs =
    SlVisualControl.getInstance().getVisualArgs(SlPositionType.SL_CAP_SECOND_BACKGROUND);
  @State supportTextBrightArgs?: SlVisualArgs =
    SlVisualControl.getInstance().getVisualArgs(SlPositionType.SL_CAP_SUPPORT_TEXT_BRIGHT);
  @State supportBackBrightArgs?: SlVisualArgs =
    SlVisualControl.getInstance().getVisualArgs(SlPositionType.SL_CAP_SUPPORT_BACK_BRIGHT);
  @State firstButtonBrightArgs?: SlVisualArgs =
    SlVisualControl.getInstance().getVisualArgs(SlPositionType.SL_CAP_FIRST_BUTTON);
  @State secondButtonBrightArgs?: SlVisualArgs =
    SlVisualControl.getInstance().getVisualArgs(SlPositionType.SL_CAP_SECOND_BUTTON);

  /**
   * 是否响应事件
   */
  private isEnabled: boolean = true;

  /**
   * 开启纯色模式
   */
  private isEnableSolid: boolean = SlVisualConfigManager.getInstance().getEnable(CcmOption.SOLID, SlAreaType.CAPSULE);
  private enableBright: boolean = SlVisualControl.getInstance().getEnable(CcmOption.BRIGHT, SlAreaType.CAPSULE);

  build() {
    if (this.capsuleData) {
      RelativeContainer() {
        if (!this.capsuleData.shouldShowInImmersiveCard()) {
          AccessibilityAppName({
            name: this.capsuleData?.appName,
            isAccessibilityMode: this.isAccessibilityMode
          })
        }
        this.IconView() // 图标区域
        if (this.capsuleData?.isShowGroupStyle()) {
          // 组通知文本, 当前应用加锁时只能展示单行文本
          this.FadeTextView({
            // 第一条
            textId: CapItemId.TITLE_TEXT,
            mainText: this.capsuleData?.mainTitle,
            mainTextColor: this.getMainTextColor(),
            mainTextWeight: FontWeight.Medium,
            mainTextSize: CapConst.CAPSULE_MAIN_TEXT_FONT_SIZE,
            secondaryText: this.capsuleData?.mainContent,
            secondaryTextColor: this.getSecondaryTextColor(),
            secondaryTextWeight: FontWeight.Regular,
            secondaryTextSize: CapConst.CAPSULE_SECONDARY_TEXT_FONT_SIZE,
            mainMinFontSize: CapConst.CAPSULE_SECONDARY_TEXT_FONT_SIZE,
            isMainText: true
          })
          this.FadeTextView({
            // 第二条
            textId: CapItemId.CONTENT_TEXT,
            mainText: this.capsuleData?.secondaryTitle,
            mainTextColor: this.getMainTextColor(),
            mainTextWeight: FontWeight.Medium,
            mainTextSize: CapConst.CAPSULE_MAIN_TEXT_FONT_SIZE,
            secondaryText: this.capsuleData?.secondaryContent,
            secondaryTextColor: this.getSecondaryTextColor(),
            secondaryTextWeight: FontWeight.Regular,
            secondaryTextSize: CapConst.CAPSULE_SECONDARY_TEXT_FONT_SIZE,
            mainMinFontSize: CapConst.CAPSULE_SECONDARY_TEXT_FONT_SIZE,
            isMainText: true
          })
        } else { // 单通知文本
          this.normalText()
        }
        if (!this.capsuleData?.isHideContent) {
          this.ExtendView() // 辅助区域
        }
      }
      .enabled(this.isEnabled)
      .width(this.getInnerContentWidth())
      .height(this.capsuleStyle?.height)
      .padding({
        start: LengthMetrics.vp(CapConst.CAPSULE_PADDING),
        end: LengthMetrics.vp(CapConst.CAPSULE_PADDING)
      })
    }
  }

  @Styles
  private iconAttrs() {
    .width(CapConst.CAPSULE_ICON_SPECS)
    .height(CapConst.CAPSULE_ICON_SPECS)
    .borderRadius(CapConst.CAPSULE_EXTEND_ICON_RADIUS)
    .clip(this.capsuleData?.hasOverlayIcon())
    .alignRules({ center: { anchor: CapItemId.ROOT_ID, align: VerticalAlign.Center } })
    .margin({
      top: CapConst.CAPSULE_ICON_MARGIN,
      bottom: CapConst.CAPSULE_ICON_MARGIN
    })
  }

  @Builder
  FadeTextView(style: CapFadeTextStyle) { // 尾部渐隐效果文本
    Stack({ alignContent: Alignment.TopStart }) {
      if (style.secondaryText) {
        Row({ space: CapConst.CAPSULE_TEXT_SPACE }) {
          Text(style.mainText)
            .textAlign(TextAlign.Start)
            .fontWeight(style.mainTextWeight)
            .fontFamily('HarmonyHeiTi')
            .fontSize(style.mainTextSize)
            .minFontSize(style.mainMinFontSize)
            .maxFontSize(style.mainTextSize)
            .minFontScale(CapConst.CAPSULE_MIN_FONT_SCALE)
            .maxFontScale(CapConst.CAPSULE_MAX_FONT_SCALE)
            .fontColor(style.mainTextColor)
            .height(CapConst.CAPSULE_MAIN_TEXT_HEIGHT)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .draggable(false)
            .fontFeature('\"ss08\" on')
            .wordBreak(WordBreak.BREAK_ALL)
            .foregroundBrightness(this.getMainTextBrightness(style))

          Text(style.secondaryText)
            .textAlign(TextAlign.Start)
            .fontWeight(style.secondaryTextWeight)
            .fontFamily('HarmonyHeiTi')
            .fontSize(style.secondaryTextSize)
            .minFontScale(CapConst.CAPSULE_MIN_FONT_SCALE)
            .maxFontScale(CapConst.CAPSULE_MAX_FONT_SCALE)
            .fontColor(style.secondaryTextColor)
            .height(CapConst.CAPSULE_SECONDARY_TEXT_HEIGHT)
            .maxLines(1)
            .layoutWeight(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .draggable(false)
            .fontFeature('\"ss08\" on')
            .wordBreak(WordBreak.BREAK_ALL)
            .foregroundBrightness(this.geSecondTextBrightness(style))
        }
        .clip(true)
      } else {
        Text(style.mainText)
          .textAlign(TextAlign.Start)
          .fontWeight(style.mainTextWeight)
          .fontFamily('HarmonyHeiTi')
          .fontSize(style.mainTextSize)
          .minFontSize(style.mainMinFontSize)
          .maxFontSize(style.mainTextSize)
          .minFontScale(CapConst.CAPSULE_MIN_FONT_SCALE)
          .maxFontScale(CapConst.CAPSULE_MAX_FONT_SCALE)
          .fontColor(style.mainTextColor)
          .height(this.isTitle(style) ? CapConst.CAPSULE_MAIN_TEXT_HEIGHT : CapConst.CAPSULE_SECONDARY_TEXT_HEIGHT)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .draggable(false)
          .fontFeature('\"ss08\" on')
          .wordBreak(WordBreak.BREAK_ALL)
          .foregroundBrightness(this.getMainTextBrightness(style))
      }
    }
    .id(style.textId)
    .layoutWeight(1)
    .alignRules(style.isAodCenter ? {
      start: { anchor: CapItemId.ICON_AREA, align: HorizontalAlign.End },
      end: {
        anchor: this.hasExtend() ? CapItemId.EXTEND_AREA : CapItemId.ROOT_ID,
        align: this.hasExtend() ? HorizontalAlign.Start : HorizontalAlign.End
      },
      center: {
        anchor: CapItemId.ROOT_ID,
        align: VerticalAlign.Center
      }
    } : {
      start: { anchor: CapItemId.ICON_AREA, align: HorizontalAlign.End },
      end: {
        anchor: this.hasExtend() ? CapItemId.EXTEND_AREA : CapItemId.ROOT_ID,
        align: this.hasExtend() ? HorizontalAlign.Start : HorizontalAlign.End
      },
      top: {
        anchor: this.isTitle(style) ? CapItemId.ROOT_ID : CapItemId.TITLE_TEXT,
        align: this.isTitle(style) ? VerticalAlign.Top : VerticalAlign.Bottom
      }
    })
    .margin(style.isAodCenter ? {
      start: LengthMetrics.vp(CapConst.CAPSULE_ICON_MARGIN),
      end: LengthMetrics.vp(!this.hasExtend() ? CapConst.CAPSULE_GROUP_RIGHT_MARGIN : 0),
      top: LengthMetrics.vp(CapConst.CAPSULE_MAIN_TEXT_MARGIN_TOP)
    } : {
      start: LengthMetrics.vp(CapConst.CAPSULE_ICON_MARGIN),
      top: LengthMetrics.vp(this.isTitle(style) ? CapConst.CAPSULE_MAIN_TEXT_MARGIN_TOP :
      CapConst.CAPSULE_SECONDARY_TEXT_MARGIN_TOP),
      bottom: LengthMetrics.vp(this.isTitle(style) ? 0 : CapConst.CAPSULE_SECONDARY_TEXT_MARGIN_BOTTOM),
      end: LengthMetrics.vp(!this.hasExtend() ? CapConst.CAPSULE_GROUP_RIGHT_MARGIN : 0)
    })
    .opacity(this.getTextAlpha())
  }

  @Builder
  TimerView() { // 计时器
    LiveTimeComponent({
      timeData: this.capsuleData?.liveTimer,
      viewFontColor: this.capsuleData?.isTimerInTitle() ? this.getMainTextColor() : this.getSecondaryTextColor(),
      timeTextStyle: this.capsuleData?.isTimerInTitle() ? this.capsuleData?.getTimeTextStyle(false) :
      this.capsuleData?.getTimeTextStyle(true)
    })
      .id(this.capsuleData?.isTimerInTitle() ? CapItemId.TITLE_TEXT : CapItemId.CONTENT_TEXT)
      .layoutWeight(1)
      .alignRules({
        start: { anchor: CapItemId.ICON_AREA, align: HorizontalAlign.End },
        end: { anchor: CapItemId.EXTEND_AREA, align: HorizontalAlign.Start },
        top: {
          anchor: this.capsuleData?.isTimerInTitle() ? CapItemId.ROOT_ID : CapItemId.TITLE_TEXT,
          align: this.capsuleData?.isTimerInTitle() ? VerticalAlign.Top : VerticalAlign.Bottom
        }
      })
      .margin({
        start: LengthMetrics.vp(CapConst.CAPSULE_ICON_MARGIN),
        top: LengthMetrics.vp(this.capsuleData?.isTimerInTitle() ? CapConst.CAPSULE_MAIN_TIME_TEXT_MARGIN_TOP :
          CapConst.CAPSULE_SECONDARY_TEXT_MARGIN_TOP)
      })
      .opacity(this.getTextAlpha())
  }

  @Builder
  IconView() { // 左侧图标区域
    if (this.capsuleData?.hasOverlayIcon()) {
      RelativeContainer() {
        Image(this.capsuleData?.getLargeIcon())
          .id(CapItemId.LARGE_ICON)
          .colorFilter(this.capsuleData?.getLargeColorFilter(this.aodStyle?.isAod))
          .zIndex(CapConst.CAPSULE_LARGE_ICON_ZINDEX)
          .opacity(this.aodStyle?.getNtfIconOpacity() ?? WDefault.MAX_VALUE)
          .iconAttrs()
          .iconStyles()
        if (this.capsuleData?.overlayIconStyle === OverlayIconStyle.REVERSE) {
          ImmersiveDeliverBadge()
        } else {
          Column()
            .zIndex(CapConst.CAPSULE_SMALL_MASK_ZINDEX)
            .width(CapConst.CAPSULE_EXTEND_SMALL_ICON_SPECS)
            .height(CapConst.CAPSULE_EXTEND_SMALL_ICON_SPECS)
            .borderRadius(CapConst.CAPSULE_EXTEND_SMALL_ICON_RADIUS)
            .alignRules({
              end: { anchor: CapItemId.LARGE_ICON, align: HorizontalAlign.End },
              bottom: { anchor: CapItemId.LARGE_ICON, align: VerticalAlign.Bottom }
            })
            .offset({
              start: LengthMetrics.vp(CapConst.CAPSULE_SMALL_ICON_MARGIN),
              top: LengthMetrics.vp(CapConst.CAPSULE_SMALL_ICON_MARGIN)
            })
            .visibility(this.aodStyle?.isAod ? Visibility.Visible : Visibility.Hidden)
            .backgroundColor(this.aodStyle?.getStyleValue(AodStyleType.BACKGROUND_COLOR))
          Image(this.capsuleData?.getSmallIcon())
            .zIndex(CapConst.CAPSULE_SMALL_ICON_ZINDEX)
            .opacity(this.aodStyle?.getNtfIconOpacity() ?? WDefault.MAX_VALUE)
            .width(CapConst.CAPSULE_EXTEND_SMALL_ICON_SPECS)
            .height(CapConst.CAPSULE_EXTEND_SMALL_ICON_SPECS)
            .borderRadius(CapConst.CAPSULE_EXTEND_SMALL_ICON_RADIUS)
            .alignRules({
              // 大图标，右下角对齐
              end: { anchor: CapItemId.LARGE_ICON, align: HorizontalAlign.End },
              bottom: { anchor: CapItemId.LARGE_ICON, align: VerticalAlign.Bottom }
            })
            .offset({
              start: LengthMetrics.vp(CapConst.CAPSULE_SMALL_ICON_MARGIN),
              top: LengthMetrics.vp(CapConst.CAPSULE_SMALL_ICON_MARGIN)
            })
            .iconStyles()
        }
      }
      .id(CapItemId.ICON_AREA)
      .alignRules({ center: { anchor: CapItemId.ROOT_ID, align: VerticalAlign.Center } })
      .flexShrink(0)
      .width(CapConst.CAPSULE_ICON_SPECS)
      .height(CapConst.CAPSULE_ICON_SPECS)
      .accessibilityLevel(this.capsuleData?.shouldShowInImmersiveCard() ? 'yes' : 'no')
      .accessibilityText(this.capsuleData?.shouldShowInImmersiveCard() ? (this.capsuleData?.appName ?? '') : '')
      .onClick(this.capsuleData?.shouldShowInImmersiveCard() ? this.capsuleStyle.onIconClick : undefined)
    } else {
      Image(this.capsuleData?.getLargeIcon())
        .id(CapItemId.ICON_AREA)
        .colorFilter(this.capsuleData?.getLargeColorFilter(this.aodStyle?.isAod))
        .iconAttrs()
        .iconStyles()
        .accessibilityLevel(this.capsuleData?.shouldShowInImmersiveCard() ? 'yes' : 'no')
        .accessibilityText(this.capsuleData?.shouldShowInImmersiveCard() ? (this.capsuleData?.appName ?? '') : '')
        .onClick(this.capsuleData?.shouldShowInImmersiveCard() ? this.capsuleStyle.onIconClick : undefined)
        .opacity(this.aodStyle?.isAod ? this.aodStyle.getStyleValue(AodStyleType.NTF_APP_ICON_ALPHA) : undefined)
    }
  }

  @Builder
  ExtendView() { // 辅助区域
    if (this.hasProgress() || this.hasButton()) {
      Row({ space: CapConst.CAPSULE_EXTEND_BTN_SPACE }) {
        if (this.hasProgress()) { // 进度条
          LiveProgressComponent({
            baseData: this.capsuleData.liveView,
            progressData: this.capsuleData.liveProgress,
            extendStyle: this.extendStyle
          })
            .opacity(this.aodStyle?.isAod ? this.aodStyle.getStyleValue(AodStyleType.NTF_EXTEND_VIEW_ALPHA_CONTENT) : 1)
        }
        if (this.hasButton()) { // 按钮
          ForEach(this.capsuleData.getButtonData(this.capsuleStyle.btnCount), (btn: LiveButtonData) => {
            LiveButtonComponent({
              baseData: this.capsuleData.liveView,
              buttonData: btn,
              extendStyle: this.extendStyle,
              isDarkMode: this.darkMode.isDarkMode,
              isAod: this.aodStyle?.isAod ?? false,
              isNotBorder: true,
              bgBrightnessOption: this.getButtonBrightness(),
              isBrightnessDisable: this.isEnableSolid,
              liveBtnNoBrightnessBgColor: this.getButtonColor()
            })
          }, (btn: LiveButtonData) => btn.name + btn.iconKey);
        }
      }
      .clip(true)
      .id(CapItemId.EXTEND_AREA)
      .height(CapConst.CAPSULE_EXTEND_SPECS)
      .margin({
        top: LengthMetrics.vp(CapConst.CAPSULE_EXTEND_TOP_MARGIN),
        bottom: LengthMetrics.vp(CapConst.CAPSULE_EXTEND_BOTTOM_MARGIN),
        start: LengthMetrics.vp(CapConst.CAPSULE_EXTEND_LEFT_MARGIN)
      })
      .alignRules({
        // 父布局，靠右垂直居中
        end: { anchor: CapItemId.ROOT_ID, align: HorizontalAlign.End },
        center: { anchor: CapItemId.ROOT_ID, align: VerticalAlign.Center }
      })
      .opacity(this.getTextAlpha())
    } else if (this.hasOther()) { // 三方辅助区
      ExtendComponent({
        data: this.capsuleData?.liveOther,
        extendStyle: this.extendStyle,
        isLight: this.isDarken,
        foreBrightnessOption: this.getCapTextBrightness(),
        capsuleForegroundColor: this.getCapTextColor(),
        bgBrightnessOption: this.getSupportBgBright(),
        capsuleBackgroundColor: this.getSupportBgColor(),
        isCapsule: true
      })
        .clip(true)
        .id(CapItemId.EXTEND_AREA)
        .height(CapConst.CAPSULE_EXTEND_SPECS)
        .margin({
          top: LengthMetrics.vp(CapConst.CAPSULE_EXTEND_TOP_MARGIN),
          bottom: LengthMetrics.vp(CapConst.CAPSULE_EXTEND_BOTTOM_MARGIN),
          start: LengthMetrics.vp(CapConst.CAPSULE_EXTEND_LEFT_MARGIN)
        })
        .alignRules({
          // 父布局，靠右垂直居中
          end: { anchor: CapItemId.ROOT_ID, align: HorizontalAlign.End },
          center: { anchor: CapItemId.ROOT_ID, align: VerticalAlign.Center }
        })
    }
  }

  @Builder
  normalText() {
    if (!this.capsuleData?.isHideContent &&
    this.hasTimerInTitle()) { // 主文本中有计时器
      this.TimerView()
    } else { // 普通文本标题
      this.FadeTextView({
        textId: CapItemId.TITLE_TEXT,
        mainText: this.capsuleData?.getTitle(this.templateTime, this.capsuleData?.liveView?.creatorBundleName,
          this.aodStyle?.isAod),
        mainTextColor: this.getMainTextColor(),
        mainTextWeight: FontWeight.Medium,
        mainTextSize: CapConst.CAPSULE_MAIN_TEXT_FONT_SIZE,
        mainMinFontSize: CapConst.CAPSULE_SECONDARY_TEXT_FONT_SIZE,
        isMainText: true,
        isAodCenter:this.getAodCenterLayout(true)
      })
    }
    // 副文本
    if (!this.capsuleData?.isHideContent &&
    this.capsuleData?.isTimerInContent()) { // 副文本中有计时器
      this.TimerView()
    } else { // 普通文本副文本
      this.FadeTextView({
        textId: CapItemId.CONTENT_TEXT,
        mainText: this.capsuleData?.getContent(this.templateTime, this.capsuleData?.liveView?.creatorBundleName,
          this.aodStyle?.isAod),
        mainTextColor: this.getSecondaryTextColor(),
        mainTextWeight: FontWeight.Regular,
        mainTextSize: CapConst.CAPSULE_SECONDARY_TEXT_FONT_SIZE,
        isMainText: true,
        isAodCenter: this.getAodCenterLayout()
      })
    }
  }

  /**
   * 获取固定宽度
   *
   * @returns 宽度
   */
  private getInnerContentWidth(): number | string {
    if (this.animState?.isSceneAnimating()) {
      return this.animState?.getWidth() ?? '100%';
    }
    return '100%';
  }

  /**
   * 进度条判断
   *
   * @returns true进度条
   */
  private hasProgress(): boolean {
    return this.capsuleData?.hasProgress() ?? false;
  }

  /**
   * 按钮判断
   *
   * @returns true按钮
   */
  private hasButton(): boolean {
    return this.capsuleData?.hasButton() ?? false;
  }

  /**
   * 三方辅助区判断
   *
   * @returns true三方
   */
  private hasOther(): boolean {
    if (this.capsuleData?.liveOther?.isShowExtendArea()) {
      return true;
    }
    return false;
  }

  /**
   * 是否存在辅助区
   *
   * @returns true辅助区
   */
  private hasExtend(): boolean {
    if (this.capsuleData?.isHideContent) {
      return false;
    }
    return this.hasProgress() || this.hasButton() || this.hasOther();
  }

  /**
   * 是否为标题文本
   *
   * @param style 渐隐文本样式
   * @returns true标题
   */
  private isTitle(style: CapFadeTextStyle): boolean {
    return style.textId === CapItemId.TITLE_TEXT;
  }

  /**
   * 获取胶囊主文本提亮参数
   *
   * @param style 样式
   * @returns 主文本
   */
  private getMainTextBrightness(style: CapFadeTextStyle): BrightnessOptions | undefined {
    if (this.aodStyle?.isAod) {
      return BrightnessOptionUtils.aodTimeLightOptionForFillColor;
    }

    if (this.isEnableSolid || !this.enableBright) {
      return undefined;
    }

    return CapConst.getCapsuleTextBrightEffect(style.isMainText, this.isDarken);
  }

  private getMainTextColor(): ResourceColor | undefined {
    if (this.aodStyle?.isAod) {
      return this.aodStyle?.getStyleValue(AodStyleType.CAPSULE_MAIN_FONT_COLOR);
    }

    if (this.isEnableSolid) {
      return this.contentBrightArgs?.getSolidColor();
    }

    if (!this.enableBright) {
      return this.contentBrightArgs?.getBrightnessColor(this.isDarken);
    }

    return CapConst.getMainTextFontColor(this.isDarken);
  }

  /**
   * 获取胶囊副文本主文本提亮参数
   *
   * @param style 样式
   * @returns 主文本
   */
  private geSecondTextBrightness(style: CapFadeTextStyle): BrightnessOptions | undefined {
    if (this.aodStyle?.isAod) {
      return BrightnessOptionUtils.aodTimeLightOptionForFillColor;
    }

    if (this.isEnableSolid || !this.enableBright) {
      return undefined;
    }

    return CapConst.getCapsuleTextBrightEffect(style.isMainText, this.isDarken);
  }

  private getSecondaryTextColor(): ResourceColor | undefined {
    if (this.aodStyle?.isAod) {
      return this.aodStyle?.getStyleValue(AodStyleType.CAPSULE_MAIN_FONT_COLOR);
    }
    if (this.isEnableSolid) {
      return this.shadowBrightArgs?.getSolidColor();
    }
    if (!this.enableBright) {
      return this.contentBrightArgs?.getBrightnessColor(this.isDarken);
    }
    return this.shadowBrightArgs?.getSolidColor();
  }

  private hasTimerInTitle(): boolean {
    return this.capsuleData?.hasTimer() && !this.baseTemplate?.isTimeTemplate && this.capsuleData?.isTimerInTitle();
  }

  /**
   * 获取文本透明度
   *
   * @returns 文本透明度
   */
  private getTextAlpha(): number | undefined {
    if (this.animState?.isSceneAnimating()) {
      return this.animState?.getAlpha();
    }
    return undefined;
  }

  /**
   * aod模式 胶囊状态下, 实况辅助区文字提亮: aodTimeLightOptionForFillColor
   * 胶囊状态下, 实况辅助区文字提亮: immersiveCapTextLightOption/immersiveCapTextDarkOption
   */
  private getCapTextBrightness(): BrightnessOptions | undefined {
    if (this.aodStyle?.isAod) {
      return BrightnessOptionUtils.aodTimeLightOptionForFillColor;
    }

    if (this.isEnableSolid || !this.enableBright) {
      return undefined;
    }

    return this.isDarken ? this.colorModeViewData.immersiveCapTextLightOption :
      this.colorModeViewData.immersiveCapTextDarkOption;
  }

  /**
   * 实况辅助区文字纯色
   */
  private getCapTextColor(): ResourceColor | undefined {
    if (this.aodStyle?.isAod) {
      return this.aodStyle?.getStyleValue(AodStyleType.CAPSULE_MAIN_FONT_COLOR);
    }

    if (this.isEnableSolid) {
      return this.supportTextBrightArgs?.getSolidColor() ?? $r('app.color.immersive_capsule_default2');
    }

    if (!this.enableBright) {
      return this.contentBrightArgs?.getBrightnessColor(this.isDarken);
    }

    return this.isDarken ? $r('app.color.immersive_capsule_default') : $r('app.color.immersive_capsule_default2');
  }

  /**
   * 按钮提亮参数
   */
  private getButtonBrightness(): BrightnessOptions | undefined {
    if (this.isEnableSolid || !this.enableBright) {
      return undefined;
    }
    return CapConst.getCapsuleExtendBrightEffect(this.isDarken);
  }

  /**
   * 按钮纯色
   */
  private getButtonColor(): ResourceColor | undefined {
    if (this.isEnableSolid) {
      return this.firstButtonBrightArgs?.getSolidColor();
    }
    if (!this.enableBright) {
      return this.firstButtonBrightArgs?.getBrightnessColor(this.isDarken);
    }
    return undefined;
  }

  /**
   * aod模式 胶囊状态下, 实况辅助区背板提亮: aodTimeLightOptionForButtonBgColor
   * 胶囊状态下, 实况辅助区按钮背板提亮: immersiveCapBgcDarkOption/immersiveCapBgcLightOption
   */
  private getSupportBgBright(): BrightnessOptions | undefined {
    if (this.isEnableSolid || !this.enableBright) {
      return undefined;
    }

    return this.isDarken ? this.colorModeViewData.immersiveCapBgcDarkOption :
    this.colorModeViewData.immersiveCapBgcLightOption;
  }

  /**
   * 实况辅助区背板纯色
   */
  private getSupportBgColor(): ResourceColor | undefined {
    if (this.aodStyle?.isAod) {
      return this.aodStyle?.getStyleValue(AodStyleType.CAPSULE_MAIN_FONT_COLOR);
    }

    if (this.isEnableSolid) {
      return this.supportBackBrightArgs?.getSolidColor();
    }
    if (!this.enableBright) {
      return this.supportBackBrightArgs?.getBrightnessColor(this.isDarken);
    }
    return this.isDarken ? $r('app.color.immersive_capsule_default') : $r('app.color.immersive_capsule_default2');
  }

  /**
   * 获取是否AOD下含计时器胶囊主副文本居中布局
   *
   * @param  isTitle 是否是标题
   * @returns 是否AOD文本居中布局
   */
  private getAodCenterLayout(isTitle?: boolean): boolean | undefined {
    if (isTitle) {
      return this.capsuleData?.hasTimer() && !this.capsuleData?.isHideContent &&
      this.capsuleData?.isTimerInContent() && this.aodStyle?.isAod;
    }
    return this.capsuleData?.hasTimer() && !this.capsuleData?.isHideContent &&
    this.hasTimerInTitle() && this.aodStyle?.isAod;
  }
}

@Extend(Image)
function iconStyles() {
  .objectFit(ImageFit.Contain)
  .draggable(false)
  .syncLoad(true)
  .autoResize(false)
  .interpolation(ImageInterpolation.Medium)
}