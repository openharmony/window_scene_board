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

import ctx from '@ohos.app.ability.common';
import { LengthMetrics } from '@ohos.arkui.node';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { HiSysEventUtil, GlobalContext } from '@ohos/frameworkwrapper';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import { MultiKeyCode } from '@ohos/systemuicommon';
import StyleConfiguration, { ClickableMenuStyle, SoundSliderStyle } from '../common/StyleConfiguration';
import { NormalPanelInfo, StatusBarPanelManager } from '../../../common/manager/StatusBarPanelManager';
import Constants from '../common/Constants';
import { AudioPlayerHelper } from '../util/AudioPlayerNewHelper';
import SettingsUtil from '../util/SettingsUtil';
import { AudioOutputChangeListener4V, AudioSoundViewModel } from '../viewmodel/AudioSoundViewModel';
import { PanelManager, PanelStateChangeListener } from '../manager/PanelManager';

const TAG = 'SoundPanel-SoundSlider';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const SLIDER_KEY = 'h1_systemUI_product_pc_soundPanel_soundSlider';
const SOUND_ENABLE_KEY = 'is_volume_adjust_sound_enabled';
const COMPONENT_ID_VOLUME_ICON = TAG + '_Image_volumeIcon';
const COMPONENT_ID_SLIDER_VOLUME = TAG + '_Slider_volume';
const DELAY_TIME: number = 50;
const IS_SOUND_ENABLE: string = '1';
const KEYBOARD = 4;

@Component
export default struct SoundSlider {
  // 固定最小音量为 0
  private minVolume: number = Constants.DEFAULT_MIN_VOLUME;
  @State maxVolume: number = Constants.DEFAULT_MAX_VOLUME;
  @State curVolume: number = Constants.DEFAULT_MIN_VOLUME;
  @State sliderChangStatusTool: boolean = false;
  @State style: SoundSliderStyle = StyleConfiguration.getSoundSliderStyle();
  @State styleClickable: ClickableMenuStyle = StyleConfiguration.getClickableMenuStyle();
  @State isSelected: boolean = false;
  @State isHover: boolean = false;
  @State panelInfo: NormalPanelInfo | undefined = undefined;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  private audioPlayerHelper: AudioPlayerHelper | null = null;
  private timer: number | null = null;
  private sliderValue: number = Constants.DEFAULT_MIN_VOLUME;
  private model: AudioSoundViewModel = AudioSoundViewModel.getInstance();
  @Consume persistentId: number;
  // 当前出声设备Symbol图标
  @StorageLink('VolumeSymbolIcon') volumeSymbolIcon: string | undefined = undefined;

  @Styles normalStyles() {
    .border( {
      width: '2vp',
      color: '#00000000'
    })
  }

  @Styles focusedStyles() {
    .border( {
      width: '2vp',
      color: '#ff0a59f7'
    })
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    this.panelInfo = StatusBarPanelManager.getInstance()
      .getStatusBarInfoById(this.persistentId) as NormalPanelInfo;
    let context = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
    if (!this.audioPlayerHelper) {
      this.audioPlayerHelper = new AudioPlayerHelper(context);
    }
    this.model.registerOutputChangeListener(this.audioOutputChangeListener, TAG);
    PanelManager.getInstance().registerPanelStateChangeListener(this.panelStateChangeListener, TAG);
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    this.model.unregisterOutputChangeListener(this.audioOutputChangeListener, TAG);
    PanelManager.getInstance().unregisterPanelStateChangeListener(this.panelStateChangeListener, TAG);
  }

  private audioOutputChangeListener: AudioOutputChangeListener4V = {
    onVolumeChange: ( minVolume: number, curVolume: number, maxVolume: number ) => {
      log.showInfo(`audioOutputChangeListener onVolumeChange info: ${minVolume} - ${curVolume} - ${maxVolume}`);
      this.curVolume = curVolume ?? this.minVolume;
      this.maxVolume = maxVolume ?? this.maxVolume;
      // 通过更新状态工具变量的值，强制slider组件根据最新的状态刷新绘制
      this.sliderChangStatusTool = !this.sliderChangStatusTool;
    }
  };

  private panelStateChangeListener: PanelStateChangeListener = {
    onPanelForegroundStatusChange: (isPanelForeground: boolean) => {
      if (!isPanelForeground) {
        this.reset();
      }
    }
  };

  @Builder
  SoundIcon(): void {
    if (this.volumeSymbolIcon) {
      // symbol图标存在
      SymbolGlyph($r(`${this.volumeSymbolIcon}`))
        .draggable(false)
        .id(COMPONENT_ID_VOLUME_ICON)
        .fontColor([this.colorModeViewData.commonIconOffColor])
        .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
        .focusable(true)
        .key(Constants.REQUEST_FOCUS_MENU)
        .size({ width: this.style.imageWidth,
          height: this.style.imageHeight })
        .fontSize(this.style.imageHeight)
        .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_OPACITY)
        .onKeyEvent((event?: KeyEvent) => {
          if (event) {
            this.handleKeyEvent(event);
          }
        })
    } else {
      Image(this.getVolumeIcon(this.curVolume, this.maxVolume, this.minVolume))
        .draggable(false)
        .id(COMPONENT_ID_VOLUME_ICON)
        .objectFit(ImageFit.Contain)
        .fillColor(this.colorModeViewData.commonIconOffColor)
        .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
        .focusable(true)
        .matchTextDirection(true)
        .key(Constants.REQUEST_FOCUS_MENU)
        .size({ width: this.style.imageWidth,
          height: this.style.imageHeight })
        .onKeyEvent((event?: KeyEvent) => {
          if (event) {
            this.handleKeyEvent(event);
          }
        })
        .edgeAntialiasing(0.5)
    }
  }

  build() {
    Row() {
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Center }) {
        Column() {
          this.SoundIcon();
        }
        .backgroundColor(this.getBackgroundColor())
        .width(this.style.imageHoverWidth)
        .height(this.style.imageHoverHeight)
        .borderRadius(this.style.imageHoverRadius)
        .justifyContent(FlexAlign.Center)
        .stateStyles({
          normal: this.normalStyles,
          focused: this.focusedStyles
        })
        .clip(true)
        .onClick((event: ClickEvent): void => {
          this.onClickEvent(event);
        })
        .onTouch((event?: TouchEvent): void => {
          if (event) {
            this.onTouchEvent(event);
          }
        })
        .onHover((isHover) => {
          this.isHover = isHover || false;
        })
        .onMouse((event?: MouseEvent): void => {
          if (event) {
            this.onMouseEvent(event);
          }
        })

        Row() {
          Slider({
            value: this.sliderChangStatusTool ? this.curVolume : this.curVolume,
            min: this.minVolume,
            max: this.maxVolume,
            step: 1,
            style: SliderStyle.InSet
          })
            .id(COMPONENT_ID_SLIDER_VOLUME)
            .key(COMPONENT_ID_SLIDER_VOLUME)
            .trackThickness(this.style.soundPanSliderHeight)
            .blockColor(this.style.soundPanelSliderBlockColor)
            .trackColor(this.panelInfo?.isDark ? $r('sys.color.ohos_id_color_component_normal_dark') :
            $r('sys.color.ohos_id_color_component_normal'))
            .selectedColor(this.panelInfo?.isDark ? $r('sys.color.ohos_id_color_component_activated_dark') :
            $r('sys.color.ohos_id_color_component_activated'))
            .onChange((value: number, mode: SliderChangeMode): void => {
              this.onVolumeChange(value, mode)
            })
            .focusable(false)
        }
        .width(this.style.soundPanSliderWidth)
        .margin({
          start: LengthMetrics.resource($r('app.float.common_margin2'))
        })
      }
      .padding({
        start: LengthMetrics.resource($r('app.float.sound_slider_margin_left')),
        end: LengthMetrics.resource($r('app.float.sound_slider_margin_right')),
      })
    }.key(SLIDER_KEY)
    .width('100%')
    .height(40)
  }

  private onMouseEvent(event: MouseEvent) {
    log.showInfo(`onMouseEvent, event: ${JSON.stringify(event)}`);
    if (event.button == MouseButton.Left && event.action == MouseAction.Press) {
      this.isSelected = true;
    } else if (event.button == MouseButton.Left && event.action == MouseAction.Release) {
      this.isSelected = false;
    }
  }

  private onTouchEvent(event: TouchEvent) {
    log.showInfo(`onTouchEvent, event: ${JSON.stringify(event)}`);
    if (event.type == TouchType.Down) {
      this.isSelected = true;
    } else if (event.type == TouchType.Up) {
      this.isSelected = false;
    }
    if (event.stopPropagation) {
      event.stopPropagation();
    }
  }

  private async onClickEvent(event: ClickEvent): Promise<void> {
    log.showInfo(`click mute botton, try mute status: ${this.curVolume === this.minVolume}`);
    if (this.curVolume === this.minVolume) {
      await this.model.setOutputMute(false, TAG);
    } else {
      await this.model.setOutputMute(true, TAG);
    }
    let eventType: string = HiSysEventUtil.TOUCH_EVENT;
    if (event.source === SourceType.Mouse) {
      eventType = HiSysEventUtil.MOUSE_EVENT;
    } else if (event.source === KEYBOARD) {
      eventType = HiSysEventUtil.SHORTCUT_EVENT;
    } else {
      eventType = HiSysEventUtil.TOUCH_EVENT;
    }
    HiSysEventUtil.reportSoundMenu(HiSysEventUtil.CHANGE_VOLUME, eventType, this.curVolume);
  }

  throttleSetVolume(value: number): void {
    this.sliderValue = value;
    if (!this.timer) {
      this.timer = setTimeout(() => {
        this.model.setOutputVolume(this.sliderValue, TAG);
        clearTimeout(this.timer);
        this.timer = null;
      }, DELAY_TIME);
    }
  }

  onVolumeChange(value: number, mode: SliderChangeMode) {
    log.showInfo(`onVolumeChange, value: ${value} mode: ${mode}`);
    if (mode === SliderChangeMode.Begin) {
      log.showInfo('SliderChangeMode.Begin');
    } else if (mode === SliderChangeMode.Moving) {
      log.showInfo('SliderChangeMode.Moving');
      this.throttleSetVolume(value);
    } else {
      this.throttleSetVolume(value);
      if (mode === SliderChangeMode.End) {
        HiSysEventUtil.reportSoundMenu(HiSysEventUtil.CHANGE_VOLUME, '', value);
        SettingsUtil.getSystemValue(SOUND_ENABLE_KEY, IS_SOUND_ENABLE).then((isSoundEnabled) => {
          if (isSoundEnabled === IS_SOUND_ENABLE) {
            (this.audioPlayerHelper as AudioPlayerHelper).playAudioOnce();
          }
        });
      }
    }
  }

  private getVolumeIcon(volume: number, maxVolume: number, minVolume: number): Resource {
    log.showInfo(`getVolumeIcon, volume: ${volume} maxVolume: ${maxVolume} minVolume: ${minVolume}`);
    let icon: Resource = $r('app.media.ic_sound_mute');
    if (volume === minVolume) {
      icon = $r('app.media.ic_sound_mute');
    } else {
      if (volume < ((maxVolume - minVolume) / 3 + minVolume)) {
        icon = $r('app.media.ic_sound_low')
      } else if (volume < (((maxVolume - minVolume) / 3) * 2 + minVolume)) {
        icon = $r('app.media.ic_sound_middle')
      } else {
        icon = $r('app.media.ic_sound_high');
      }
    }
    return icon;
  }

  private getBackgroundColor(): ResourceColor {
    if (this.isSelected) {
      return this.styleClickable.stackBgColorSelected;
    }
    if (this.isHover) {
      return this.styleClickable.stackBgColorHover;
    }
    return this.styleClickable.stackBgColorUnSelected;
  }

  private reset() {
    this.isSelected = false;
    this.isHover = false;
  }

  private async handleKeyEvent(keyEvent: KeyEvent): Promise<void> {
    log.showInfo(`KeyEvent, event: ${JSON.stringify(keyEvent)}`);
    if (keyEvent.type !== KeyType.Down) {
      return;
    }
    if (keyEvent.keyCode === MultiKeyCode.DPAD_LEFT) {
      await this.model.turnOutputVolume(false, TAG);
    } else if (keyEvent.keyCode === MultiKeyCode.DPAD_RIGHT) {
      await this.model.turnOutputVolume(true, TAG);
    }
    HiSysEventUtil.reportSoundMenu(HiSysEventUtil.CHANGE_VOLUME, '', this.curVolume);
    SettingsUtil.getSystemValue(SOUND_ENABLE_KEY, IS_SOUND_ENABLE).then((isSoundEnabled) => {
      if (isSoundEnabled === IS_SOUND_ENABLE) {
        (this.audioPlayerHelper as AudioPlayerHelper).playAudioOnce();
      }
    });
  }
}
