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
import { EvtBus } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import StyleConfiguration, {
  ControlCenterQuickToggleLayoutStyle
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/common/StyleConfiguration';
import {
  ControlCenterAnimationData
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/model/ControlCenterAnimationData';
import { ColorModeViewModel, ColorModeViewData } from '@ohos/systemuicommon/Index';
import { VolumeAnimViewData, VolumeDraggingViewData, VolumeViewData, } from '../model/VolumeViewData';
import volumeViewModel, { VolumeSharedViewData } from '../viewmodel/VolumeViewModel';
import {
  CC_LAYOUT_CONFIGS,
  ControlCenterLayoutIndex
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/ControlCenterLayoutController';
import Constants from '../common/Constants';
import { LengthMetrics } from '@kit.ArkUI';
import { ControlCenterHideEvent } from '@ohos/systemuicommon/src/main/ets/event/ControlCenterHideEvent';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { KeyCode } from '@kit.InputKit';
import { vibratorMgr, CommonConstants } from '@ohos/launchercommon';
import { AudioOutputChangeListener4V, AudioSoundViewModel } from '../../../soundpanel/viewmodel/AudioSoundViewModel';

const TAG = 'Ctrl.Volume';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const COMPONENT_ID_IMAGE_VOLUME = TAG + '_Image_volume';
const COMPONENT_ID_VOLUME = TAG + '_cc_volume';
const FOCUS_OFFSET_WIDTH: number = 4;
const FOCUS_OFFSET_HEIGHT: number = 5;
const VOLUME_ICON_MARGIN_LEFT: number = 2;

@Component
export default struct Volume {
  @State volumeIconPaddingRight: Length | undefined = 0;
  readonly POINT_LIGHT_ILLUMINATED: number = 3;
  // 音量条左边到图标的长度 12vp
  readonly VOLUME_LEFT_TO_ICON: number = 12;
  // UI参数
  private style: ControlCenterQuickToggleLayoutStyle = StyleConfiguration.getControlCenterQuickToggleLayoutStyle();
  // viewModel
  @State viewData: VolumeViewData = volumeViewModel.getViewData();
  @ObjectLink animationData: ControlCenterAnimationData | null;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State animViewData: VolumeAnimViewData = VolumeSharedViewData.getInstance().getAnimViewData();
  @State volumePanelMaxVolume: number = Constants.DEFAULT_MAX_VOLUME;
  @State physicsValue: number = 0;
  private volumePanelMinVolume: number = Constants.DEFAULT_MIN_VOLUME;
  @State @Watch('onDraggingStop') draggingViewData: VolumeDraggingViewData = VolumeSharedViewData.getInstance()
    .getDraggingViewData();
  @Consume @Watch('onLayoutChange') ccLayoutIndex: ControlCenterLayoutIndex;
  @StorageLink('BrightnessController_lottieDataReady') isLottieDataReady: boolean = false;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  // 用于维测
  @Prop isLandscapeBrightness: boolean = false;
  private icon: Resource | null = null;
  @State isHover: boolean = false;
  @StorageLink('VolumeSymbolIcon') volumeSymbolIcon: string | undefined = undefined;
  private eventMgr = EvtBus.createEventManager();
  private muteIcon: Resource = $r('app.media.ic_sound_mute');
  private lowIcon: Resource = $r('app.media.ic_sound_low');
  private middleIcon: Resource = $r('app.media.ic_sound_middle');
  private highIcon: Resource = $r('app.media.ic_sound_high');
  private model: AudioSoundViewModel = AudioSoundViewModel.getInstance();

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
    volumeViewModel.aboutToAppear(this.isLandscapeBrightness, this.physicsValue);
    this.eventMgr.on(ControlCenterHideEvent, (event: ControlCenterHideEvent): void => {
      this.updateHoverStatus(event?.isShowOfWindow)
    });
    this.model.registerOutputChangeListener(this.audioOutputChangeListener, TAG);
  }

  aboutToDisappear(): void {
    volumeViewModel.aboutToDisappear();
    if (this.eventMgr !== undefined) {
      this.eventMgr.offAll();
    }
    this.model.unregisterOutputChangeListener(this.audioOutputChangeListener, TAG);
  }

  private audioOutputChangeListener: AudioOutputChangeListener4V = {
    onVolumeChange: ( minVolume: number, curVolume: number, maxVolume: number ) => {
      log.showInfo(`audioOutputChangeListener onVolumeChange info: ${minVolume} - ${curVolume} - ${maxVolume}`);
      this.physicsValue = curVolume ?? this.volumePanelMinVolume;
      this.volumePanelMaxVolume = maxVolume ?? this.volumePanelMaxVolume;
      this.onPhysicsValueChanged();
    }
  };

  onPhysicsValueChanged() {
    volumeViewModel.updatePhysicsValue(this.physicsValue, this.volumePanelMinVolume);
  }

  onLayoutChange() {
    volumeViewModel.onLayoutChange();
  }

  onDraggingStop() {
    volumeViewModel.onDraggingStop();
  }

  private getVolumeWidth(): number {
    return this.style.brightnessWidth + ResUtils.getConvertNumber($r('app.float.Control_center_volume_hover_row_width'));
  }

  private updateHoverStatus(isShowOfWindow: boolean) {
    this.isHover = isShowOfWindow;
  }

  build() {
    if (this.isAccessibilityMode) {
      Column() {
        this.loadBrightnessLayout();
      }
      .gesture(GestureGroup(GestureMode.Exclusive,
        PanGesture({ direction: PanDirection.Horizontal, distance: 0, fingers: 1 })
          .onActionStart((event: GestureEvent) => volumeViewModel.onPanActionStart(event))
          .onActionUpdate((event: GestureEvent) => volumeViewModel.onPanActionUpdate(event))
          .onActionEnd((event: GestureEvent) => volumeViewModel.onPanActionEnd(event))
          .onActionCancel(() => volumeViewModel.onPanActionCancel()),
        TapGesture()
          .onAction((event: GestureEvent) => {
            log.showInfo('TapGesture.onAction is not execute');
          })
      ))
      .onTouch((event?: TouchEvent) => volumeViewModel.handleOnTouch(event))
      .accessibilityGroup(true)
      .accessibilityLevel('yes')
      .accessibilityText(ResUtils.getInnerStringNumS($r('app.string.cc_accessibility_str_brightness'),
        `${volumeViewModel.getAccessibilityVolumeValue(this.physicsValue)}%`))
      .accessibilityDescription(ResUtils.getInnerString($r('app.string.cc_accessibility_str_change_brightness_desc')))
    } else {
      this.loadBrightnessLayout();
    }
  }

  @Styles
  VolumeSliderStyles() {
    .width(this.style.brightnessWidth)
    .height(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.brightnessHeight)
    .borderRadius(this.style.brightnessBorderRadius)
    .gesture(GestureGroup(GestureMode.Exclusive,
      PanGesture({ direction: PanDirection.Horizontal, distance: 1, fingers: 1 })
        .onActionStart((event: GestureEvent) => volumeViewModel.onPanActionStart(event))
        .onActionUpdate((event: GestureEvent) => volumeViewModel.onPanActionUpdate(event))
        .onActionEnd((event: GestureEvent) => volumeViewModel.onPanActionEnd(event))
        .onActionCancel(() => volumeViewModel.onPanActionCancel()),
      TapGesture()
        .onAction((event: GestureEvent) => {
          log.showInfo('TapGesture.onAction is not execute');
        })
    ))
    .gesture(LongPressGesture({ repeat: false }).onAction(this.handleLongClick))
    .onTouch((event?: TouchEvent) => volumeViewModel.handleOnTouch(event))
    .opacity(this.animationData?.opacity)
    .translate({ y: this.getTranslateY() })
    .id(COMPONENT_ID_VOLUME)
  }

  @Builder
  loadBrightnessLayout() {
    Row() {
      Stack() {
        Stack() {
          this.VolumeSlider()
        }
        .alignContent(Alignment.Start)
        .clip(true)
        .shadow({
          radius: $r('app.float.Control_center_icon_shadow_radius'),
          color: $r('app.color.Control_center_icon_shadow_color'),
          offsetY: this.style.toggleIconShadowOffsetY
        })
        .VolumeSliderStyles()
        .focusable(true)
      }
      .focusable(true)
      .onKeyEvent((event: KeyEvent) => {
        if (event.type === KeyType.Down && event.keyCode === KeyCode.KEYCODE_DPAD_LEFT) {
          volumeViewModel.adjustVolumeWithArrowKey(-1);
        }
        if (event.type === KeyType.Down && event.keyCode === KeyCode.KEYCODE_DPAD_RIGHT) {
          volumeViewModel.adjustVolumeWithArrowKey(1);
        }
        if (event.type === KeyType.Up &&
          (event.keyCode === KeyCode.KEYCODE_DPAD_RIGHT || event.keyCode === KeyCode.KEYCODE_DPAD_LEFT)) {
          volumeViewModel.playAudioOnce();
        }
      })
      .padding({
        start: LengthMetrics.vp(ResUtils.getConvertNumber($r('app.float.Control_center_focus_padding'))),
        end: LengthMetrics.vp(ResUtils.getConvertNumber($r('app.float.Control_center_focus_padding'))),
        top: LengthMetrics.vp(ResUtils.getConvertNumber($r('app.float.Control_center_focus_padding_top'))),
        bottom: LengthMetrics.vp(ResUtils.getConvertNumber($r('app.float.Control_center_focus_padding')))
      })
      .stateStyles({
        normal: this.normalStyle,
        focused: this.focusedStyle,
      })

      Row() {
        Image($r('app.media.icon_arrow'))
          .fillColor(this.colorModeViewData.wifiOffTextColor)
          .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOptionOnBackground)
          .draggable(false)
          .width($r('app.float.Control_center_volume_hover_img_size'))
          .height($r('app.float.Control_center_volume_hover_img_size'))
          .matchTextDirection(true)
      }
      .padding({
        start: LengthMetrics.vp(ResUtils.getConvertNumber($r('app.float.Control_center_volume_hover_img_padding_left'))),
        bottom: LengthMetrics.vp(ResUtils.getConvertNumber($r('app.float.Control_center_long_button_arrow_bottom_padding')))
      })
      .focusable(false)
      .width($r('app.float.Control_center_volume_hover_row_width'))
      .justifyContent(FlexAlign.Start)
      .visibility(this.isHover ? Visibility.Visible : Visibility.Hidden)
      .onClick(() => {
        log.showInfo(`laber onclick`);
        volumeViewModel.handleLabelClick();
      })
    }
    .width(this.getVolumeWidth())
    .onHover((isHover) => {
      this.isHover = isHover;
    })
  }

  handleLongClick(event?: GestureEvent): boolean {
    log.showDebug('handleLongClick: long click');
    if (volumeViewModel.handleLabelClick() && event?.source !== SourceType.Mouse) {
      vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_MEDIUM,
        CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
    }
    return true;
  }


  @Builder
  VolumeSlider() {
    Column() {
    }
    .width(this.style.brightnessWidth)
    .height(this.style.brightnessHeight)
    .borderRadius(this.style.brightnessBorderRadius)
    .backgroundColor(this.colorModeViewData.brightnessBgColor)
    .backgroundBrightnessInternal(this.colorModeViewData.volumeAndBrightNessBgOption)

    Column() {
    }
    .width(this.viewData.volumeUIValue)
    .height(this.style.brightnessHeight)
    .backgroundColor($r('app.color.Control_center_brightness_block_color'))
    .backgroundBrightnessInternal(this.colorModeViewData.brightnessChoosenOption)

    Column() {
      if (this.volumeSymbolIcon) {
        SymbolGlyph($r(`${this.volumeSymbolIcon}`))
          .draggable(false)
          .id(COMPONENT_ID_IMAGE_VOLUME)
          .fontSize($r('app.float.Control_center_brightness_icon_width'))
          .fontColor([this.getSymbolColor()])
          .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_OPACITY)
          .margin({
            top: LengthMetrics.vp(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.brightnessSunIconMargin?.top as number),
            start: LengthMetrics.vp(VOLUME_ICON_MARGIN_LEFT)
          })
          .foregroundBrightness(this.getPrimaryFgOption())
      } else {
        Image(this.getVolumeIcon(this.physicsValue,
          this.volumePanelMaxVolume, this.volumePanelMinVolume))
          .width($r('app.float.Control_center_brightness_icon_width'))
          .height($r('app.float.Control_center_brightness_icon_width'))
          .fillColor(this.getSymbolColor())
          .margin({
            top: LengthMetrics.vp(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.brightnessSunIconMargin?.top as number),
            start: LengthMetrics.vp(VOLUME_ICON_MARGIN_LEFT)
          })
          .matchTextDirection(true)
          .draggable(false)
          .edgeAntialiasing(0.5)
          .id(COMPONENT_ID_IMAGE_VOLUME)
          .foregroundBrightness(this.getPrimaryFgOption())
          .padding({
            end: LengthMetrics.vp(this.volumeIconPaddingRight as number)
          })
      }
    }
    .width($r('app.float.Control_center_volume_background_width'))
    .height($r('app.float.Control_center_volume_background_height'))
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }

  getPrimaryFgOption() : BrightnessOptions | undefined {
    if (this.isDarkMode()) {
      if (this.viewData.volumeUIValue <= this.VOLUME_LEFT_TO_ICON) {
        return this.colorModeViewData.getPrimaryFgOption(false);
      } else {
        return this.colorModeViewData.getVolumePrimaryFgOption(false);
      }
    } else {
      return this.colorModeViewData.getVolumePrimaryFgOption(false);
    }
  }

  getSymbolColor(): ResourceColor {
    if (this.isDarkMode()) {
      return this.viewData.volumeUIValue <= this.VOLUME_LEFT_TO_ICON ?
        this.colorModeViewData.commonIconOnColor : Color.Black;
    } else {
      return Color.Black;
    }
  }

  isDarkMode() {
    return AppStorage.get('currColorMode') !== ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
  }

  private getVolumeIcon(volume: number, maxVolume: number, minVolume: number): Resource | null {
    log.showInfo(`getVolumeIcon, volume: ${volume} maxVolume: ${maxVolume} minVolume: ${minVolume}`);
    if (volume === 0) {
      this.icon = this.muteIcon;
      this.volumeIconPaddingRight = 0;
    } else {
      if (volume < ((maxVolume - minVolume) / 3 + minVolume)) {
        this.icon = this.lowIcon;
      } else if (volume < (((maxVolume - minVolume) / 3) * 2 + minVolume)) {
        this.icon = this.middleIcon;
      } else {
        this.icon = this.highIcon;
      }
      this.volumeIconPaddingRight = 0;
    }
    return this.icon;
  }

  private getTranslateY(): string | number | undefined {
    if (this.animationData) {
      return this.animationData?.itemTranslate + Math.max(this.animationData?.translate, 0);
    } else {
      return undefined;
    }
  }

  private getScale(): number | undefined {
    if (this.viewData.isHover) {
      return this.viewData.animateScale;
    } else {
      if (this.viewData.showBlurLayer === true) {
        return this.animViewData.scaleX;
      } else {
        return this.animationData?.scale;
      }
    }
  }
}