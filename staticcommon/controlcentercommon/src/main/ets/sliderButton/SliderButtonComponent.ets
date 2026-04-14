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

import { GlobalContext } from '@ohos/frameworkwrapper';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import {
  SliderButtonAnimViewData,
  SliderButtonViewData,
  SliderIconViewData,
  SubPageTransEffectData
} from './SliderButtonViewData';
import { DISABLE_BRIGHTNESS } from '@ohos/systemuicommon/src/main/ets/template/common/SCBVisualEffectOption';
import { LengthMetrics } from '@kit.ArkUI';
import { RTLUtil } from '@ohos/componenthelper';
import { StorageAdapter } from '../adapter/StorageAdapter';

export interface SliderOperation {
  onPanActionStart: Function;
  onPanActionUpdate: Function;
  onPanActionEnd: Function;
  onTapAction: Function;
  onLongPressAction?: Function;
  handleOnHover?: Function;
  onTouchEvent?: Function;
  onCanvasReady?: Function;
  onCanvasDisAppear?: Function;
  goSettingClick?: Function;
  getAccessibility?: Function;
  onKeyPreAction: Function;
  onSwitchChange?: Function;
}

const focusedBorderWidth: number = 2.5;

@Component
export struct SliderButtonComponent {
  private isExpand: boolean = false;
  private geometryTag: string = '';
  private readonly POINT_LIGHT_ILLUMINATED: number = 3;
  private transEffectData: SubPageTransEffectData = new SubPageTransEffectData();
  private viewData: SliderButtonViewData = new SliderButtonViewData();
  private iconViewData: SliderIconViewData = new SliderIconViewData();
  private isCanvasRotate: boolean = false;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @Link sliderOperation: SliderOperation;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @StorageLink('currColorMode') currColorMode: number = GlobalContext.getContext().config.colorMode as number;
  @StorageLink('isSysColor') isSysColor: boolean = true;
  @StorageLink('isToggleLightEnabled') isToggleLightEnabled: boolean = true;
  @Consume animViewData: SliderButtonAnimViewData;
  @State switchState: boolean = false;
  @StorageProp('isSystemLanguageRTL') isSystemLanguageRTL: boolean = RTLUtil.isRTL();
  /**
   * 进度值提亮效果
   * @returns
   */
  private getProgressBrightnessInternal(): BrightnessOptions | undefined {
    if (this.isExpand) {
      return this.animViewData.sliderProgressBrightnessInternal;
    } else if (this.animViewData.sliderChosen) {
      return this.colorModeViewData.brightnessChoosenOption;
    }
    return this.colorModeViewData.brightnessNotChosenOption;
  }

  /**
   * @returns 进度条颜色
   */
  private getProgressColor(): ResourceColor {
    if (this.isExpand) {
      return DISABLE_BRIGHTNESS ? this.colorModeViewData.brightnessBlockColor : this.animViewData.sliderProgressColor;
    } else if (this.animViewData.sliderChosen) {
      return this.colorModeViewData.brightnessBlockColor;
    }
    return this.colorModeViewData.wifiBgOffColor;
  }

  /**
   * 进度条背板提亮效果
   * @returns
   */
  private getBackBrightnessInternal(): BrightnessOptions | undefined {
    if (this.isExpand) {
      return this.colorModeViewData.brightnessSubpageBgOption;
    } else if (this.animViewData.sliderChosen) {
      return this.colorModeViewData.brightnessBgOption;
    }
    return this.colorModeViewData.mainCardOption;
  }

  /**
   * icon图标提亮效果
   * @returns
   */
  private getIconBrightnessInternal(): BrightnessOptions | undefined {
    if (this.isExpand) {
      return this.animViewData.iconBrightnessInternal;
    } else if (this.animViewData.sliderChosen) {
      return this.colorModeViewData.sliderIconChoosenOption;
    }
    return this.colorModeViewData.foregroundPrimaryOptionOnBackground;
  }

  private getIconTransitionEffect(): TransitionEffect | undefined {
    if (!this.iconViewData.iconTransitionEffect) {
      return undefined;
    } else if (this.isExpand && !this.geometryTag.endsWith('Vertical')) {
      return this.transEffectData.subpageBrightnessElementTransEffect;
    } else {
      return this.transEffectData.brightnessElementTransEffect;
    }
  }

  private getSliderBackgroundColor(): ResourceColor {
    if (this.isExpand) {
      return this.colorModeViewData.subLayoutBgColor;
    } else if (this.colorModeViewData.isUseDefaultColor() && this.animViewData.sliderChosen) {
      return this.colorModeViewData.chosenSliderBgColor;
    } else {
      return this.colorModeViewData.commonBgOffColor;
    }
  }

  build() {
    RelativeContainer() {
      this.loadBackground();
      this.loadSubpageElement();
      if (!this.viewData.isHorizontal) {
        this.buildVerticalItem();
      }
      if (this.isExpand && this.geometryTag.endsWith('Vertical')) {
        this.buildVerticalSubpageItem()
      }
      this.loadSliderLayer();
      this.loadIcon();
    }
    .shadow(this.animViewData.subpageHide ? undefined : {
      radius: this.animViewData.shadowRadius,
      color: '#26000000',
      offsetY: 0,
      offsetX: 0
    })
    .id('sliderRelativeContainer')
    .width(this.viewData.buttonWidth)
    .height(this.viewData.buttonHeight)
    .borderRadius(32)
    .scale(this.animViewData.buttonScale)
    .onHover((isHover?: boolean) => this.sliderOperation.handleOnHover?.(isHover))
    .onTouch((event: TouchEvent) => {
      this.sliderOperation.onTouchEvent?.(event);
    })
    // 增加键盘事件
    .onKeyPreIme((event: KeyEvent) => { return this.sliderOperation.onKeyPreAction(event) })
  }

  @Styles
  sliderAlignRulesStyles(){
    .alignRules({
      center: this.isExpand ? undefined : { anchor: '__container__', align: VerticalAlign.Center },
      middle: { anchor: '__container__', align: HorizontalAlign.Center },
      top: this.isExpand ? { anchor: '__container__', align: VerticalAlign.Top } : undefined
    })
    .margin(this.isExpand ? { top: 90 } : undefined)
  }

  @Styles
  centerAlignRulesStyles(){
    .alignRules({
      center: { anchor: '__container__', align: VerticalAlign.Center },
      middle: { anchor: '__container__', align: HorizontalAlign.Center }
    })
  }

  @Styles
  startAlignRulesStyles(){
    .alignRules(this.viewData.isHorizontal ? {
      center: {
        anchor: this.isAccessibilityMode ? 'slider_layer_access_' + this.geometryTag :
          'slider_layer_' + this.geometryTag,
        align: VerticalAlign.Center
      },
      left: { anchor: '__container__', align: HorizontalAlign.Start },
    } : {
      middle: {
        anchor: this.isAccessibilityMode ? 'slider_layer_access_' + this.geometryTag :
          'slider_layer_' + this.geometryTag,
        align: HorizontalAlign.Center
      },
      bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
    })
  }

  @Styles
  iconCommonStyles() {
    .foregroundBrightness(this.getIconBrightnessInternal())
    .margin(this.viewData.isHorizontal ? {
      start: LengthMetrics.vp((this.viewData.buttonWidth - this.viewData.sliderWidth) / 2 +
      this.viewData.iconMargin)
    } : {
      bottom: LengthMetrics.vp((this.viewData.buttonHeight - this.viewData.sliderHeight) / 2 +
      this.viewData.iconMargin)
    })
    .transition(this.getIconTransitionEffect())
    .offset(this.animViewData.iconOffset)
    .scale(this.animViewData.iconScale)
    .accessibilityLevel('no')
    .hitTestBehavior(HitTestMode.None)
  }

  @Styles
  sliderGestureStyles(){
    .gesture(GestureGroup(GestureMode.Exclusive,
      PanGesture({
        direction: this.viewData.isHorizontal ? PanDirection.Horizontal : PanDirection.Vertical,
        distance: 2,
        fingers: 1
      })
        .onActionStart((event: GestureEvent) => this.sliderOperation.onPanActionStart(event))
        .onActionUpdate((event: GestureEvent) => this.sliderOperation.onPanActionUpdate(event))
        .onActionEnd((event: GestureEvent) => this.sliderOperation.onPanActionEnd(event))
        .onActionCancel(() => this.sliderOperation.onPanActionEnd()),
      TapGesture()
        .onAction((event: GestureEvent) => {
          this.sliderOperation.onTapAction(event);
        }),
      LongPressGesture({ repeat: false })
        .onAction((event: GestureEvent) => {
          this.sliderOperation.onLongPressAction?.(event)
        })
    ))
  }

  @Builder
  loadBackground() {
    // 模糊图层
    if (this.animViewData.showBlurLayer) {
      Row()
        .width(this.isExpand ? this.viewData.sliderWidth : this.viewData.buttonWidth)
        .height(this.isExpand ? this.viewData.sliderHeight : this.viewData.buttonHeight)
        .borderRadius(32)
        .backgroundEffect({
          policy: 1,
          radius: 60,
          blurOptions: { grayscale: [38, 38] }
        })
        .scale(this.isExpand ? this.animViewData.sliderScale : undefined)
        .sliderAlignRulesStyles()
        .accessibilityLevel('no')
    }
    // 背景框
    Row()
      .width(this.viewData.buttonWidth)
      .height(this.viewData.buttonHeight)
      .borderRadius(32)
      .backgroundColor(this.colorModeViewData.getSolidColor(
        this.getSliderBackgroundColor(), this.getBackBrightnessInternal()))
      .backgroundBrightnessInternal(this.colorModeViewData.getBrightnessOption(
        this.getBackBrightnessInternal()))
      .pointLight({
        illuminated: this.isToggleLightEnabled ? this.POINT_LIGHT_ILLUMINATED : IlluminatedType.NONE,
      })
      .centerAlignRulesStyles()
      .geometryTransition('back_frame' + this.geometryTag)
      .transition(this.isExpand ? this.transEffectData.subpageTransEffect : TransitionEffect.opacity(0.01))
      .id('back_frame')
      .opacity(this.animViewData.subpageHide ? 0 : 1)
      .accessibilityLevel('no')
  }

  @Builder
  loadSliderLayer() {
    if (this.isAccessibilityMode) {
      this.loadSliderOfAccessibility();
    } else {
      this.loadSlider();
    }
  }

  @Builder
  buildVerticalItem() {
    Row() {
    }
    .size({ width: 1, height: 1 })
    .centerAlignRulesStyles()
    .geometryTransition(this.getVerticalIconGeometry())

    Row() {
    }
    .size({ width: this.viewData.sliderWidth, height: 1 })
    .centerAlignRulesStyles()
    .geometryTransition('slider_layer' + this.geometryTag)

    Row() {
    }
    .size({ width: this.viewData.sliderWidth, height: 1 })
    .centerAlignRulesStyles()
    .geometryTransition('back_color_layer' + this.geometryTag)
  }

  private getVerticalIconGeometry(): string {
    if (this.animViewData.useLottieData) {
      return 'lottie_icon' + this.geometryTag;
    } else if (this.animViewData.useSymbol) {
      return 'symbol_icon' + this.geometryTag;
    } else {
      return 'image_icon' + this.geometryTag;
    }
  }

  @Builder
  sliderBuilder() {
    // 颜色图层（二级页显示）
    if (this.viewData.isHorizontal) {
      Row()
        .width(this.viewData.sliderWidth)
        .height(this.viewData.sliderHeight)
        .borderRadius(32)
        .backgroundColor(this.isExpand ? (!DISABLE_BRIGHTNESS ? this.colorModeViewData.subpageBrightnessBgColor :
        this.colorModeViewData.brightnessBgColor) : undefined)
        .backgroundBrightnessInternal(this.isExpand ? this.colorModeViewData.getBrightnessOption(
          this.colorModeViewData.subpageBrightnessBgOption) : undefined)
        .geometryTransition(this.viewData.isHorizontal ? ('back_color_layer' + this.geometryTag) : '')
        .transition(this.isExpand ? this.transEffectData.subpageBrightBackTransEffect : undefined)
    }

    // 进度条
    Stack() {
      Column()
        .size(this.getSliderSizeByDirection())
        .backgroundColor(this.getProgressColor())
        .backgroundBrightnessInternal(this.colorModeViewData.getBrightnessOption(
          this.getProgressBrightnessInternal()))
        .transition(this.isExpand ? this.transEffectData.brightnessTransEffect(this.viewData.subpageSliderScale) :
          undefined)
    }
    .clip(true)
    .alignContent(this.viewData.isHorizontal ? Alignment.Start : Alignment.Bottom)
    .width(this.viewData.sliderWidth)
    .height(this.viewData.sliderHeight)
    .scale(this.isExpand ? undefined : this.animViewData.sliderScale)
    .borderRadius(32)
    .geometryTransition(this.viewData.isHorizontal ? ('slider_layer' + this.geometryTag) : 'slider' + this.geometryTag)
    .transition(this.isExpand ? TransitionEffect.asymmetric(
      TransitionEffect.OPACITY,
      TransitionEffect.OPACITY.animation({
        duration: this.geometryTag.endsWith('Vertical') ? 50 : 160,
        delay: this.geometryTag.endsWith('Vertical') ? 0 : 200,
        curve: Curve.Friction
      })
    ) : this.transEffectData.brightnessElementTransEffect)

    if (this.animViewData.isSliderButtonFocused) {
      Column()
        .borderWidth(focusedBorderWidth)
        .borderColor(this.colorModeViewData.commonBgOnColor)
        .width(this.viewData.sliderWidth + focusedBorderWidth * 2)
        .height(this.viewData.sliderHeight + focusedBorderWidth * 2)
        .borderRadius(32 + focusedBorderWidth)
    }
  }

  private getSliderSizeByDirection(): SizeOptions {
    if (this.viewData.isHorizontal) {
      return {
        width: this.animViewData.uiValue,
        height: this.viewData.sliderHeight
      }
    } else {
      return {
        width: this.viewData.sliderWidth,
        height: this.animViewData.uiValue
      }
    }
  }

  @Builder
  loadSlider() {
    Stack() {
      this.sliderBuilder();
    }
    .width(this.isExpand ? this.viewData.sliderWidth : this.viewData.buttonWidth)
    .height(this.isExpand ? this.viewData.sliderHeight : this.viewData.buttonHeight)
    .borderRadius(32)
    .scale(this.isExpand ? this.animViewData.sliderScale : undefined)
    .shadow(this.animViewData.subpageHide ? {
      radius: this.animViewData.shadowRadius,
      color: '#26000000',
      offsetY: 0,
      offsetX: 0
    } : undefined)
    .clip(!this.isExpand && this.animViewData.sliderChosen)
    .pointLight({
      illuminated: this.isToggleLightEnabled ? this.POINT_LIGHT_ILLUMINATED : IlluminatedType.NONE,
    })
    .sliderGestureStyles()
    .sliderAlignRulesStyles()
    .id('slider_layer_' + this.geometryTag)
  }

  @Builder
  loadSliderOfAccessibility() {
    Stack() {
      this.sliderBuilder()
    }
    .width(this.isExpand ? this.viewData.sliderWidth : this.viewData.buttonWidth)
    .height(this.isExpand ? this.viewData.sliderHeight : this.viewData.buttonHeight)
    .borderRadius(32)
    .scale(this.isExpand ? this.animViewData.sliderScale : undefined)
    .clip(!this.isExpand && this.animViewData.sliderChosen)
    .id('slider_layer_access_' + this.geometryTag)
    .sliderAlignRulesStyles()
    .sliderGestureStyles()
    .accessibilityText(this.sliderOperation.getAccessibility?.('text'))
    .accessibilityDescription(this.sliderOperation.getAccessibility?.('description'))
  }

  @Builder
  loadIcon() {
    if (this.animViewData.useLottieData) {
      this.loadCanvasIcon();
    } else {
      this.loadImageIcon();
    }
  }

  /**
   * lottie格式的icon
   */
  @Builder
  loadCanvasIcon() {
    Canvas(this.iconViewData.mainCanvasRenderingContext)
      .rotate({ z: 1, angle: this.isSystemLanguageRTL && this.isCanvasRotate ? 180 : 0})
      .width(this.viewData.canvasSize)
      .height(this.viewData.canvasSize)
      .startAlignRulesStyles()
      .margin(this.getIconMargin())
      .offset(this.animViewData.iconOffset)
      .foregroundBrightness(this.getIconBrightnessInternal())
      .geometryTransition(this.viewData.isHorizontal ? ('lottie_icon' + this.geometryTag) : 'icon' + this.geometryTag)
      .transition(this.getIconTransitionEffect())
      .scale(this.animViewData.iconScale)
      .id('lottie_icon')
      .accessibilityLevel('no')
      .hitTestBehavior(HitTestMode.None)
      .onReady(() => {
        this.sliderOperation.onCanvasReady?.();
      })
      .onDisAppear(() => {
        this.sliderOperation.onCanvasDisAppear?.();
      })
  }

  private getIconMargin(): LocalizedPadding {
    if (this.viewData.isHorizontal) {
      return {
        start: LengthMetrics.vp((this.viewData.buttonWidth - this.viewData.sliderWidth) / 2 + this.viewData.iconMargin)
      }
    } else {
      return {
        bottom: LengthMetrics.vp((this.viewData.buttonWidth - this.viewData.sliderWidth) / 2 + this.viewData.iconMargin)
      }
    }
  }

  /**
   * 图片格式icon
   */
  @Builder
  loadImageIcon() {
    if (this.animViewData.useSymbol) {
      SymbolGlyph(this.animViewData.sliderIcon)
        .fontSize(`${this.viewData.iconSize}vp`)
        .fontWeight(FontWeight.Normal)
        .fontColor([this.animViewData.iconColor])
        .renderingStrategy(this.animViewData.symbolRendering ?? SymbolRenderingStrategy.SINGLE)
        .startAlignRulesStyles()
        .iconCommonStyles()
        .geometryTransition(this.viewData.isHorizontal ? ('symbol_icon' + this.geometryTag) : 'icon' + this.geometryTag)
        .id('symbol_icon')
    } else {
      Image(this.animViewData.sliderIcon)
        .width(this.viewData.iconSize)
        .height(this.viewData.iconSize)
        .fillColor(this.animViewData.iconColor)
        .startAlignRulesStyles()
        .iconCommonStyles()
        .geometryTransition(this.viewData.isHorizontal ? ('image_icon' + this.geometryTag) : 'icon' + this.geometryTag)
        .id('image_icon')
    }
  }

  /**
   * 二级页文字图片元素
   */
  @Builder
  loadSubpageElement() {
    if (this.isExpand) {
      Column() {
        Column() {
          SymbolGlyph(this.iconViewData.subPageIcon)
            .fontSize(`24vp`)
            .fontColor([this.colorModeViewData.subpageBrightnessTitleColor])
            .foregroundBrightness(this.colorModeViewData.getBrightnessOption(
              this.colorModeViewData.foregroundPrimaryOptionOnBackground))
            .accessibilityLevel('no')
            .margin({ top: '16vp' })

          Text(this.iconViewData.iconName)
            .fontSize('20vp')
            .lineHeight('27vp')
            .fontWeight(FontWeight.Medium)
            .fontFamily('HarmonyHeiTi')
            .fontColor(this.colorModeViewData.subpageBrightnessTitleColor)
            .foregroundBrightness(this.colorModeViewData.getBrightnessOption(
              this.colorModeViewData.foregroundPrimaryOptionOnBackground))
            .margin({ top: '8vp' })
            .id('subpage_element_text')

          Column() {
            Text($r('app.string.more_settings'))
              .fontSize(16)
              .lineHeight(21)
              .width('100%')
              .maxFontScale(2)
              .maxLines(1)
              .fontWeight(FontWeight.Medium)
              .textAlign(TextAlign.Center)
              .fontFamily('HarmonyHeiTi')
              .fontColor(this.colorModeViewData.subpageBrightnessSettingsColor)
              .foregroundBrightness(this.colorModeViewData.getBrightnessOption(
                this.colorModeViewData.subpageMoreSettingsOption))
              .padding({ top: 4, bottom: 4 })
          }
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .margin({ top: this.viewData.moreSettingTopMargin })
          .constraintSize({
            minHeight: '40vp',
            maxHeight: '48vp'
          })
          .width('280vp')
          .onClick(() => {
            this.sliderOperation.goSettingClick?.();
          })
          .stateStyles({
            normal: {
              .backgroundColor(Color.Transparent)
            },
            pressed: {
              .backgroundColor($r('sys.color.interactive_pressed'))
              .borderRadius(21)
            }
          })
        }
        .width('100%')
        .height('100%')
        .opacity(this.animViewData.subpageOpacity)
        .scale(this.animViewData.subpageScale)
      }
      .alignItems(HorizontalAlign.Center)
      .width(this.viewData.buttonWidth)
      .height(this.viewData.buttonHeight)
      .visibility(this.animViewData.subpageHide ? Visibility.Hidden : Visibility.Visible)
      .centerAlignRulesStyles()
      .geometryTransition('subpage_element' + this.geometryTag)
      .id('subpage_element')
    } else {
      Row()
        .size({ width: this.viewData.buttonWidth, height: this.viewData.buttonHeight })
        .centerAlignRulesStyles()
        .geometryTransition('subpage_element' + this.geometryTag)
        .transition(this.transEffectData.buttonTransEffect)
        .id('subpage_element')
        .accessibilityLevel('no')
    }
  }

  @Builder
  buildVerticalSubpageItem() {
    Row() {
    }
    .size({ width: 1, height: 1 })
    .centerAlignRulesStyles()
    .geometryTransition('slider' + this.geometryTag)

    Row() {
    }
    .size({ width: 1, height: 1 })
    .centerAlignRulesStyles()
    .geometryTransition('icon' + this.geometryTag)
  }
}
