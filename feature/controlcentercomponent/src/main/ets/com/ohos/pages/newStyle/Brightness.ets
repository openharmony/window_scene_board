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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import StyleConfiguration, { ControlCenterQuickToggleLayoutStyle } from '../../common/StyleConfiguration';
import { ControlCenterAnimationData } from '../../model/ControlCenterAnimationData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { BrightnessViewModel } from '../../viewModel/BrightnessViewModel';
import {
  BrightnessAnimViewData,
  BrightnessDraggingViewData,
  BrightnessProgress,
} from '../../model/BrightnessViewData';
import { CC_LAYOUT_CONFIGS, ControlCenterLayoutIndex } from '../../controller/ControlCenterLayoutController';
import { LengthMetrics } from '@kit.ArkUI';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { KeyCode } from '@kit.InputKit';

const TAG = 'Ctrl.Brightness';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const COMPONENT_ID_IMAGE_BRIGHTNESS = TAG + '_Image_brightness_filled';
const COMPONENT_ID_BRIGHTNESS = TAG + '_cc_brightness';
const FOCUS_OFFSET_WIDTH: number = 4;
const FOCUS_OFFSET_HEIGHT: number = 5;

@Component
export default struct Brightness {
  readonly POINT_LIGHT_ILLUMINATED: number = 3;
  // 亮度条左边到图标的长度 12vp
  readonly BRIGHTNESS_LEFT_TO_ICON: number = 12;
  // UI参数
  private style: ControlCenterQuickToggleLayoutStyle = StyleConfiguration.getControlCenterQuickToggleLayoutStyle();
  private isPc: boolean = DeviceHelper.isPC();
  // viewModel
  private viewModel: BrightnessViewModel = new BrightnessViewModel();
  @State viewData: BrightnessProgress = this.viewModel.getViewData();
  @ObjectLink animationData: ControlCenterAnimationData | null;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State animViewData: BrightnessAnimViewData = new BrightnessAnimViewData();
  @StorageLink('BrightnessValue') @Watch('onPhysicsValueChanged') physicsValue: number = 0;
  @State draggingViewData: BrightnessDraggingViewData = new BrightnessDraggingViewData();
  @Consume @Watch('onLayoutChange') ccLayoutIndex: ControlCenterLayoutIndex;
  @StorageLink('BrightnessController_lottieDataReady') isLottieDataReady: boolean = false;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  private brightnessFocusable: boolean = true;
  
  // 用于维测
  @Prop isLandscapeBrightness: boolean = false;


  @Styles normalStyle() {
    .width(this.style.brightnessWidth + FOCUS_OFFSET_WIDTH)
    .height(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.brightnessHeight + FOCUS_OFFSET_HEIGHT)
    .outlineWidth(0)
  }

  @Styles focusedStyle() {
    .width(this.style.brightnessWidth + FOCUS_OFFSET_WIDTH)
    .height(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.brightnessHeight + FOCUS_OFFSET_HEIGHT)
    .borderRadius((CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.brightnessHeight + FOCUS_OFFSET_HEIGHT) / 2)
    .outlineStyle(OutlineStyle.SOLID)
    .outlineWidth(2)
    .outlineColor(this.colorModeViewData.commonBgOnColor)
    .outlineRadius((CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.brightnessHeight + FOCUS_OFFSET_WIDTH * 2) / 2)
  }

  aboutToAppear(): void {
    this.viewModel.initData(this.draggingViewData, this.animViewData);
    this.viewModel.aboutToAppear(this.isLandscapeBrightness, this.physicsValue);
  }

  aboutToDisappear(): void {
    this.viewModel.aboutToDisappear();
  }

  isDarkMode() {
    return AppStorage.get('currColorMode') !== ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
  }

  getSymbolColor(): ResourceColor {
    if (this.isDarkMode()) {
      return this.viewData.brightnessUIValue <= this.BRIGHTNESS_LEFT_TO_ICON ?
      Color.White : Color.Black;
    } else {
      return Color.Black;
    }
  }

  getPrimaryFgOption() : BrightnessOptions | undefined {
    if (this.isDarkMode()) {
      if (this.viewData.brightnessUIValue <= this.BRIGHTNESS_LEFT_TO_ICON) {
        return this.colorModeViewData.getPrimaryFgOption(false);
      } else {
        return this.colorModeViewData.getVolumePrimaryFgOption(false);
      }
    } else {
      return this.colorModeViewData.getVolumePrimaryFgOption(false);
    }
  }

  onPhysicsValueChanged() {
    this.viewModel.updatePhysicsValue(this.physicsValue);
  }

  onLayoutChange() {
    this.viewModel.onLayoutChange();
  }

  build() {
    if (this.isAccessibilityMode) {
      Column() {
        this.loadBrightnessLayout();
      }
      .gesture(GestureGroup(GestureMode.Exclusive,
        PanGesture({ direction: PanDirection.Horizontal, distance: 0, fingers: 1 })
          .onActionStart((event: GestureEvent) => this.viewModel.onPanActionStart(event))
          .onActionUpdate((event: GestureEvent) => this.viewModel.onPanActionUpdate(event))
          .onActionEnd((event: GestureEvent) => this.viewModel.onPanActionEnd(event))
          .onActionCancel(() => this.viewModel.onPanActionCancel()),
        TapGesture()
          .onAction((event: GestureEvent) => {
            log.showInfo('AccessibilityMode TapGesture.onAction is not execute');
          })
      ))
      .onTouch((event: TouchEvent) => this.viewModel.handleOnTouch(event))
      .accessibilityGroup(true)
      .accessibilityLevel('yes')
      .accessibilityText(ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_brightness'),
        `${this.viewModel.getAccessibilityBrightnessValue(this.physicsValue)}%`))
      .accessibilityDescription(ResUtils.getInnerString($r('app.string.cc_accessibility_str_change_brightness_desc')))
    } else {
      this.loadBrightnessLayout();
    }
  }

  @Builder
  loadBrightnessLayout() {
    Stack() {
      Stack() {
        if (!this.isPc) {
          this.phoneBrightness()
        } else {
          this.pcBrightness()
        }
      }
      .alignContent(Alignment.Start)
      .clip(true)
      .shadow(this.isPc ?
        {
          radius: $r('app.float.Control_center_icon_shadow_radius'),
          color: $r('app.color.Control_center_icon_shadow_color'),
          offsetY: this.style.toggleIconShadowOffsetY
        } :
        { radius: this.animViewData.shadowRadius, color: '#26000000', offsetY: 0, offsetX: 0 })
      .width(this.style.brightnessWidth)
      .height(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.brightnessHeight)
      .borderRadius(this.style.brightnessBorderRadius)
      .gesture(GestureGroup(GestureMode.Exclusive,
        PanGesture({ direction: PanDirection.Horizontal, distance: 0, fingers: 1 })
          .onActionStart((event: GestureEvent) => this.viewModel.onPanActionStart(event))
          .onActionUpdate((event: GestureEvent) => this.viewModel.onPanActionUpdate(event))
          .onActionEnd((event: GestureEvent) => this.viewModel.onPanActionEnd(event))
          .onActionCancel(() => this.viewModel.onPanActionCancel()),
        TapGesture()
          .onAction((event: GestureEvent) => {
            log.showInfo('TapGesture.onAction is not execute');
          })
      ))
      .onTouch((event: TouchEvent) => this.viewModel.handleOnTouch(event))
      .opacity(this.animationData?.opacity)
      .translate({ y: this.getTranslateY() })
      .focusable(this.brightnessFocusable)
      .id(COMPONENT_ID_BRIGHTNESS)
    }
    .padding({
      start: LengthMetrics.vp(ResUtils.getConvertNumber($r('app.float.Control_center_focus_padding'))),
      end: LengthMetrics.vp(ResUtils.getConvertNumber($r('app.float.Control_center_focus_padding'))),
      top: LengthMetrics.vp(ResUtils.getConvertNumber($r('app.float.Control_center_focus_padding_top'))),
      bottom: LengthMetrics.vp(ResUtils.getConvertNumber($r('app.float.Control_center_focus_padding')))
    })
    .focusable(this.brightnessFocusable)
    .onKeyEvent((event: KeyEvent) => {
      if (event.type === KeyType.Down && event.keyCode === KeyCode.KEYCODE_DPAD_LEFT) {
        this.viewModel.adjustBrightWithArrowKey(-1);
      }
      if (event.type === KeyType.Down && event.keyCode === KeyCode.KEYCODE_DPAD_RIGHT) {
        this.viewModel.adjustBrightWithArrowKey(1);
      }
    })
    .stateStyles({
      normal: this.normalStyle,
      focused: this.focusedStyle,
    })
  }

  @Builder
  pcBrightness() {
    Column() {
    }
    .width(this.style.brightnessWidth)
    .height(this.style.brightnessHeight)
    .borderRadius(this.style.brightnessBorderRadius)
    .backgroundColor(this.colorModeViewData.volumeAndBrightNessBgColor)
    .backgroundBrightnessInternal(this.colorModeViewData.volumeAndBrightNessBgOption)
    Column() {
    }
    .width(this.viewData.brightnessUIValue)
    .height(this.style.brightnessWidth)
    .backgroundColor($r('app.color.Control_center_brightness_block_color'))
    .backgroundBrightnessInternal(this.colorModeViewData.brightnessChoosenOption)


    SymbolGlyph($r('sys.symbol.sun_max'))
      .fontSize($r('app.float.Control_center_brightness_icon_width'))
      .fontColor([this.getSymbolColor()])
      .margin({
        top: LengthMetrics.vp(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.brightnessSunIconMargin?.top as number),
        start: LengthMetrics.vp(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.brightnessSunIconMargin?.left as number)
      })
      .draggable(false)
      .id(COMPONENT_ID_IMAGE_BRIGHTNESS)
      .foregroundBrightness(this.getPrimaryFgOption())
  }

  @Builder
  phoneBrightness() {
    if (this.animViewData.showBlurLayer) {
      Column() {
      }
      .width('100%')
      .height('100%')
      .borderRadius(this.style.brightnessBorderRadius)
      .backgroundEffect({
        policy: 1,
        radius: 45,
        blurOptions: { grayscale: [38, 38] }
      }, { disableSystemAdaptation: true })
      .opacity(this.animViewData.brightnessBlurOpacity);
    }
    Column()
      .width(this.style.brightnessWidth)
      .height(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.brightnessHeight)
      .borderRadius(this.style.brightnessBorderRadius)
      .backgroundColor(this.colorModeViewData.brightnessBgColor)
      .backgroundBrightnessInternal(this.colorModeViewData.brightnessBgOption)
      .pointLight({
        illuminated: this.POINT_LIGHT_ILLUMINATED,
      })

    Column()
      .width(this.viewData.brightnessUIValue)
      .height(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.brightnessHeight)
      .backgroundColor(this.colorModeViewData.brightnessBlockColor)
      .backgroundBrightnessInternal(this.colorModeViewData.brightnessChoosenOption)
    if (this.isLottieDataReady) {
      Canvas(this.viewModel.mainCanvasRenderingContext)
        .width(56)
        .height(56)
        .margin({
          left: 5
        })
        .onReady(() => {
          this.viewModel.onCanvasReady();
        })
        .onDisAppear(() => {
          this.viewModel.onCanvasDisappear();
        })
    }
  }

  private getTranslateY(): string | number | undefined {
    if (this.animationData) {
      return this.animationData?.itemTranslate + Math.max(this.animationData?.translate, 0);
    } else {
      return undefined;
    }
  }

  private getScale(): number | undefined {
    if (this.animViewData.isHover) {
      return this.animViewData.animateScale;
    } else {
      if (this.animViewData.showBlurLayer) {
        return this.animViewData.scaleX;
      } else {
        return this.animationData?.scale;
      }
    }
  }
}