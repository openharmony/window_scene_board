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

import { common } from '@kit.AbilityKit';
import { curves } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { LengthMetrics } from '@kit.ArkUI';
import { GlobalContext } from '@ohos/frameworkwrapper';
import {
  ColorModeViewModel,
  ColorModeViewData
} from '@ohos/systemuicommon/Index';
import { SliderButtonViewData, SubPageTransEffectData } from '@ohos/controlcentercommon/src/main/ets/sliderButton/SliderButtonViewData';
import audio from '@ohos.multimedia.audio';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { PromptAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/PromptAdapter';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import SoundReporterController from '../../controller/SoundReporterController';
import { DeviceInfoBean } from '../../common/DeviceInfoBean';
import SoundDataShareController from '../../controller/SoundDataShareController';
import LottieCanvas from './LottieCanvas';
import { AudioHelper } from '../../utils/AudioHelper';
import {
  BottomBtnPara,
  soundSubPageController,
  SubPageStatus
} from '../../controller/SoundSubPageLayoutController';

const TAG: string = 'Ctrl.soundcomponent-BLEHeadsetPanel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

class HoverConstants {
  public static readonly HOVER_DEFAULT_SCALE: number = 1.0;
  public static readonly HOVER_DOWN_SCALE: number = 0.9;
}

const THRESHOLD_SLIDE: number = 5;

@Component
export struct BLEHeadsetPanel {
  private viewData: SliderButtonViewData = new SliderButtonViewData();
  private subPageTransEffectData: SubPageTransEffectData = new SubPageTransEffectData();
  private showToastMethod?: (msg: ResourceStr) => void;
  @Consume flexDirection: FlexDirection;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State deviceBleName: string = '';
  @State outputDevice: audio.AudioDeviceDescriptor | undefined = AudioHelper.getInstance().outputDevice;
  @State pageStatus: SubPageStatus = SubPageStatus.DETAIL;
  //  @State @Watch('onNoiseControlAbilityChange') noiseControlAbility: NoiseControlSupportMode =
  //     NoiseControlSupportMode.NOT_SUPPORT;
  //   @State @Watch('onSpatialAbilityChange') spatialAbility: SpatialSupportMode = SpatialSupportMode.NOT_SUPPORT;
  @State @Watch('onNoiseControlAbilityChange') noiseControlAbility: number =
    0;
  @State @Watch('onSpatialAbilityChange') spatialAbility: number = 0;
  @Prop noiseControlConfig: BottomBtnPara[] = [];
  @State spatialConfig: BottomBtnPara[] = [];
  animTimes: number = 250;
  @State ancMode: BottomBtnPara = {
    label: '',
    // value: NoiseSwitch.NOISE_CANCELING_OFF,
    value: 0,
    icon: $r('app.media.ic_noise_control_0'),
    des: '',
  };
  @State spatialState: BottomBtnPara = {
    label: '',
    // value: SpatialState.OFF,
    value: 0,
    icon: $r('app.media.ic_audio_spatial_0'),
    des: ''
  };
  @State deviceInfo: DeviceInfoBean | null = null;
  @State forePageMode: SubPageStatus = SubPageStatus.DETAIL;
  @State isSpatialEnable: boolean = true;

  async getDeviceInfo() {
    if (!this.outputDevice?.address) {
      return;
    }
    this.deviceBleName = soundSubPageController.getDeviceNameSync(this.outputDevice.address);
    this.deviceInfo = await SoundDataShareController.queryDeviceInfo(this.outputDevice?.address);
    return this.deviceInfo;
  }

  async aboutToAppear() {
    // 获取出声通道的设备
    log.showInfo('BLEHeadsetPanel aboutToAppear');
    this.outputDevice = AudioHelper.getInstance().getOutputDevice();
    const info = this.getDeviceInfo();
    if (!info) {
      return;
    }
    this.initAamSFeature();
    AudioHelper.getInstance().onOutputDeviceChange();
    AudioHelper.getInstance().addOutputDeviceChangeListener(TAG, {
      onEvent: (outputDevice: audio.AudioDeviceDescriptor) => {
        this.resetAbility();
        this.outputDevice = outputDevice;
        SoundDataShareController.destroy();
        if (this.isBleDevice()) {
          this.getDeviceInfo();
          this.initAamSFeature();
        }
      }
    })
  }

  aboutToDisappear(): void {
    // AamSdkClient.offSpatialState();
    // if (this.outputDevice?.address) {
    //   AamSdkClient.offNoiseControlState(this.outputDevice?.address as string);
    // }
    // AamSdkClient.destroy();
    AudioHelper.getInstance().removeOutputDeviceChangeListener(TAG);
  }

  isEqualMac(callbackMac: string) {
    return callbackMac === this.outputDevice?.address || callbackMac === this.deviceInfo?.deviceBtMac ||
      callbackMac === this.deviceInfo?.deviceLeftSleMac || callbackMac === this.deviceInfo?.deviceRightSleMac;
  }

  onSpatialStateChange() {
    // AamSdkClient.onSpatialState({
    //   onEvent: (event: string, address: string, data: SpatialState) => {
    //     log.showInfo(`onSpatialState ${data}, spatialConfig length: ${this.spatialConfig.length}`);
    //     if (data === SpatialState.DISABLED ||
    //       (data !== SpatialState.OFF && data !== SpatialState.TRACK && data !== SpatialState.FIX)) {
    //       this.isSpatialEnable = false;
    //       return;
    //     }
    //     if (this.isEqualMac(address) && this.spatialAbility !== SpatialSupportMode.NOT_SUPPORT &&
    //       this.spatialConfig.length > 0) {
    //       this.spatialState = this.spatialConfig.find(item => item.value === data) as BottomBtnPara;
    //     }
    //   }
    // });
  }

  getSpatialState() {
    // AamSdkClient.getSpatialState(this.outputDevice?.address as string).then((data: SpatialState) => {
    //   log.showInfo(`getSpatialState: ${data}, spatialConfig length: ${this.spatialConfig.length}`);
    //   if (data === SpatialState.DISABLED ||
    //     (data !== SpatialState.OFF && data !== SpatialState.TRACK && data !== SpatialState.FIX)) {
    //     this.isSpatialEnable = false;
    //     return;
    //   }
    //   if (this.spatialAbility !== SpatialSupportMode.NOT_SUPPORT && this.spatialConfig.length > 0) {
    //     this.spatialState = this.spatialConfig.find(item => item.value === data) as BottomBtnPara;
    //   }
    // })
  }

  onNoiseControlStateChange() {
    // AamSdkClient.onNoiseControlState(this.outputDevice?.address as string, {
    //   onEvent: (event: string, address: string, data: NoiseControlState) => {
    //     log.showInfo(`onNoiseControlState state: ${data.state} code: ${data.errorCode}, noiseControlConfig.length: ${this.noiseControlConfig.length}`);
    //     if (this.noiseControlAbility !== NoiseControlSupportMode.NOT_SUPPORT &&
    //     this.isEqualMac(address) && this.noiseControlConfig.length > 0) {
    //       this.ancMode = this.noiseControlConfig.find(item => item.value === data.state) as BottomBtnPara;
    //     }
    //   }
    // })
  }

  getNoiseControlState() {
    // AamSdkClient.getNoiseControlState(this.outputDevice?.address as string).then((data: NoiseSwitch) => {
    //   log.showInfo(`getNoiseControlState: ${data}, noiseControlConfig length: ${this.noiseControlConfig.length}`);
    //   if (this.noiseControlAbility !== NoiseControlSupportMode.NOT_SUPPORT && this.noiseControlConfig.length > 0) {
    //     this.ancMode = this.noiseControlConfig.find(item => item.value === data) as BottomBtnPara;
    //   }
    // })
  }

  doGeometryTransitionBackToDefaultPanel() {
    animateTo({
      curve: Curve.ExtremeDeceleration,
      duration: this.animTimes,
    }, () => {
      this.forePageMode = this.pageStatus
      this.pageStatus = SubPageStatus.DETAIL;
    });
  }

  resetAbility() {
    // this.noiseControlAbility = NoiseControlSupportMode.NOT_SUPPORT;
    // this.spatialAbility = SpatialSupportMode.NOT_SUPPORT;
    this.deviceInfo = null;
    // AamSdkClient.offSpatialState();
    if (this.outputDevice?.address) {
      // AamSdkClient.offNoiseControlState(this.outputDevice?.address as string);
    }
  }

  initAamSFeature() {
    if (!this.isBleDevice()) {
      return;
    }
    // log.showInfo(`start initAamSFeature: ${convertMac(this.outputDevice?.address as string)}`);
    // AamSdkClient.init(GlobalContext.getContext());
    // AamSdkClient.getFeatureSupport(this.outputDevice?.address as string).then((data: FeatureSupport) => {
    //   log.showInfo(`getFeatureSupport noiseControlSupportMode: ${data.noiseControlSupportMode} spatialSupportMode: ${data.spatialSupportMode}`);
    //   this.noiseControlAbility = data.noiseControlSupportMode;
    //   this.spatialAbility = data.spatialSupportMode;
    //   if (this.noiseControlAbility !== NoiseControlSupportMode.NOT_SUPPORT) {
    //     this.onNoiseControlStateChange();
    //     this.getNoiseControlState();
    //   }
    //   if (this.spatialAbility !== SpatialSupportMode.NOT_SUPPORT) {
    //     this.onSpatialStateChange();
    //     this.getSpatialState();
    //   }
    // }).catch((error: BusinessError) => {
    //   log.showError(`getFeatureSupport BusinessError ${error.message}`);
    // })
  }

  /**
   * 判断是否蓝牙连接的设备
   * @returns boolean
   */
  isBleDevice(): boolean {
    return Boolean(this.outputDevice && AudioHelper.getInstance().isWirelessDevice(this.outputDevice.deviceType) &&
      this.outputDevice.address !== '');
  }

  onNoiseControlAbilityChange() {
    // if (this.noiseControlAbility === NoiseControlSupportMode.TWO_MODE) {
    //   this.noiseControlConfig = soundSubPageController.getNoiseControlTwoConfig();
    // } else if (this.noiseControlAbility === NoiseControlSupportMode.THREE_MODE) {
    //   this.noiseControlConfig = soundSubPageController.getNoiseControlThreeConfig();
    // }
  }

  onSpatialAbilityChange() {
    // if (this.spatialAbility === SpatialSupportMode.TWO_MODE) {
    //   this.spatialConfig = soundSubPageController.getSpatialTwoConfig();
    // } else if (this.spatialAbility === SpatialSupportMode.THREE_MODE) {
    //   this.spatialConfig = soundSubPageController.getSpatialThreeConfig();
    // }
  }

  jumpNoiseControlPanel() {
    animateTo({
      curve: Curve.ExtremeDeceleration,
      duration: this.animTimes
    }, () => {
      this.pageStatus = SubPageStatus.NOISECONTROL
    })
  }

  clickNoiseControlBtn(callback: () => void) {
    // if (this.noiseControlAbility === NoiseControlSupportMode.TWO_MODE) {
    //   log.showInfo(`clickNoiseControlBtn: ${this.ancMode.des}, ${this.noiseControlConfig[0]?.des}`)
    //   if (this.ancMode.des === this.noiseControlConfig[0]?.des) {
    //     this.setAncMode(this.noiseControlConfig[1], callback);
    //   } else {
    //     this.setAncMode(this.noiseControlConfig[0], callback);
    //   }
    //   return;
    // }
    this.jumpNoiseControlPanel();
  }

  clickSpatialBtn(callback: () => void) {
    // if (this.spatialAbility === SpatialSupportMode.TWO_MODE) {
      log.showInfo(`clickSpatialBtn: ${this.spatialState.des}, ${this.spatialConfig[0]?.des}`)
      if (this.spatialState.des === this.spatialConfig[0]?.des) {
        this.setSpatialState(this.spatialConfig[1], callback);
      } else {
        this.setSpatialState(this.spatialConfig[0], callback);
      }
      return;
    // }
    this.jumpSpatialPanel();
  }

  jumpSpatialPanel() {
    animateTo({
      curve: Curve.ExtremeDeceleration,
      duration: this.animTimes
    }, () => {
      this.pageStatus = SubPageStatus.SPATIAL;
    })
  }

  setAncMode(item: BottomBtnPara, callback?: () => void) {
    if (this.ancMode.value === item.value) {
      return;
    }
    log.showInfo(`setAncMode item: ${item.value}`);
    // AamSdkClient.setNoiseControlState(this.outputDevice?.address as string, item.value as NoiseSwitch)
    //   .then((code: NoiseErrorCode) => {
    //     if (code === NoiseErrorCode.SUCCESS) {
    //       callback?.();
    //     } else if (code === NoiseErrorCode.UN_WEAR_ERROR) {
    //       PromptAdapter.showToast(ResUtils.getInnerString(item.value === NoiseSwitch.NOISE_CANCELING_ON ?
    //         $r('app.string.toast_noise_control') :
    //         $r('app.string.toast_voice_enhance')));
    //     } else if (code === NoiseErrorCode.UN_WEAR_DOUBLE_ERROR) {
    //       PromptAdapter.showToast(ResUtils.getInnerString($r('app.string.toast_noise_control_amphora')));
    //     }
    //   })
  }

  setSpatialState(item: BottomBtnPara, callback: () => void) {
    if (this.spatialState.value === item.value) {
      return;
    }
    log.showInfo(`setSpatialState item: ${item.value}`)
    // AamSdkClient.setSpatialState(this.outputDevice?.address as string, item.value as SpatialState).then((number) => {
    //   if (number === 0) {
    //     this.spatialState = item;
    //     callback();
    //   }
    // })
  }

  build() {
    if (AudioHelper.getInstance().isWirelessDevice(this.outputDevice?.deviceType) && this.deviceInfo) {
      Column() {
        this.loadDeviceTitlePanel();
        this.loadAbilityPanel();
      }
      // .height((this.noiseControlAbility !== NoiseControlSupportMode.NOT_SUPPORT ||
      //         this.spatialAbility !== SpatialSupportMode.NOT_SUPPORT) ? 146 : 56)
      //
      .height( 56)
      .width(this.viewData.buttonWidth)
      .justifyContent(FlexAlign.Center)
      .margin(this.flexDirection === FlexDirection.Row ? { start: LengthMetrics.vp(16) } : { top: 12 })
      .animation({ duration: 100 })
      .alignItems(HorizontalAlign.Center)
      .borderRadius(32)
      .backgroundColor(this.colorModeViewData.commonBgOffColor)
      // .backgroundBrightnessInternal(this.colorModeViewData.brightnessSubpageBgOption)
      .transition(this.subPageTransEffectData.subpageElementTransEffect)
    }
  }

  @Builder
  loadAbilityPanel() {
    // if (this.noiseControlAbility !== NoiseControlSupportMode.NOT_SUPPORT ||
    //   this.spatialAbility !== SpatialSupportMode.NOT_SUPPORT) {
      Row() {
        if (this.pageStatus === SubPageStatus.DETAIL) {
          this.loadFeatureEntryPanel()
        } else if (this.pageStatus === SubPageStatus.NOISECONTROL) {
          this.loadBackBtn()
          this.loadNoiseControlPanel(this.viewData.buttonWidth / 4)
        } else if (this.pageStatus === SubPageStatus.SPATIAL) {
          this.loadBackBtn()
          this.loadSpatialPanel(this.viewData.buttonWidth / 4)
        }
      }
      .width('100%')
      .height(94)
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Top)
    // }
  }

  @Builder
  loadDeviceTitlePanel() {
    Row() {
      Text(this.deviceBleName || this.outputDevice?.name)
        .constraintSize({
          maxWidth: this.viewData.buttonWidth - 76
        })
        .id('deviceTitle')
        .maxFontSize('16vp')
        .minFontSize('14vp')
        .fontWeight(FontWeight.Medium)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .wordBreak(WordBreak.BREAK_ALL)
        .maxLines(1)
        // .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOptionOnBackground)
        .fontColor(this.colorModeViewData.commonIconOffColor)
      SymbolGlyph($r('sys.symbol.chevron_right'))
        .width(12)
        .height(24)
        .margin({ left: 4 })
        .fontSize('24vp')
        // .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOptionOnBackground)
    }
    .width(this.viewData.buttonWidth - 48)
    .height(24)
    .justifyContent(FlexAlign.Center)
    // .margin((this.noiseControlAbility !== NoiseControlSupportMode.NOT_SUPPORT ||
    //   this.spatialAbility !== SpatialSupportMode.NOT_SUPPORT) ? { top: 12, bottom: 16 } : {})
    .visibility(this.pageStatus === SubPageStatus.DETAIL ? Visibility.Visible : Visibility.Hidden)
    .onClick(() => {
      if (!this.deviceInfo) {
        return;
      }
      SoundReporterController.clickDeviceTitleReport(this.outputDevice);
      soundSubPageController.goToAudioAccessoryManager(this.outputDevice?.address as string);
    })
  }

  @Builder
  loadFeatureEntryPanel() {
    // if (this.noiseControlAbility !== NoiseControlSupportMode.NOT_SUPPORT && this.ancMode.des) {
      BottomBtn({
        boxWidth: 126,
        para: {
          icon: this.ancMode.icon,
          selectedIcon: this.ancMode.selectedIcon,
          selectedCanvas: this.ancMode.selectedCanvas,
          label: $r('app.string.base_noise_control'),
          // subLabel: this.ancMode.value !== NoiseSwitch.NOISE_CANCELING_OFF ? this.ancMode.label : '',
          // isSelected: this.ancMode.value !== NoiseSwitch.NOISE_CANCELING_OFF,
          des: 'noise_control',
        },
        clickFun: (callback) => {
          this.clickNoiseControlBtn(callback);
          SoundReporterController.clickNoiseReport(this.outputDevice);
        }
      })
        .id(this.ancMode.des)
        // .margin(this.spatialAbility !== SpatialSupportMode.NOT_SUPPORT ? { right: 6 } : {})
        .geometryTransition(this.ancMode.des)
        .transition(this.forePageMode === SubPageStatus.NOISECONTROL ?
        TransitionEffect.IDENTITY :
        TransitionEffect.scale({ x: 0, y: 0 })
          .combine(TransitionEffect.OPACITY))
    // }
    // if (this.spatialAbility !== SpatialSupportMode.NOT_SUPPORT && (this.spatialState.des || !this.isSpatialEnable)) {
      BottomBtn({
        boxWidth: 126,
        // para: {
        //   icon: this.spatialState.icon,
        //   selectedCanvas: this.spatialState.selectedCanvas,
          // label: this.spatialAbility === SpatialSupportMode.THREE_MODE ? $r('app.string.HD_spatial_audio') :
          // $r('app.string.spatial_audio'),
          // subLabel: this.spatialState.value !== SpatialState.OFF ? this.spatialState.label : '',
          // isSelected: this.spatialState.value !== SpatialState.OFF,
        //   des: 'spatial'
        // },
        clickFun: (callback) => {
          this.clickSpatialBtn(callback);
          SoundReporterController.clickSpatialReport(this.outputDevice);
        }
      })
        .id(this.spatialState.des)
        // .margin(this.noiseControlAbility !== NoiseControlSupportMode.NOT_SUPPORT ? { start: LengthMetrics.vp(6) } : {})
        .enabled(this.isSpatialEnable)
        .opacity(this.isSpatialEnable ? 1 : 0.4)
        .geometryTransition(this.spatialState.des)
        .transition(this.forePageMode === SubPageStatus.SPATIAL ?
        TransitionEffect.IDENTITY :
        TransitionEffect.scale({ x: 0, y: 0 })
          .combine(TransitionEffect.OPACITY))
    // }
  }

  @Builder
  loadBackBtn() {
    Row() {
      Row() {
        SymbolGlyph($r('sys.symbol.chevron_backward'))
          .width(24)
          .height(24)
          .fontSize('24vp')
          // .foregroundBrightness(this.colorModeViewData.getPrimaryFgOption(false))
      }
      .width(40)
      .height(40)
      .borderRadius(20)
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .backgroundColor(this.colorModeViewData.wifiBgOffColor)
      // .backgroundBrightnessInternal(this.colorModeViewData.getTopOption(false))
      .onClick(() => {
        this.doGeometryTransitionBackToDefaultPanel();
      })
    }
    .width(this.viewData.buttonWidth / 4)
    .justifyContent(FlexAlign.Center)
  }

  /**
   * 降噪面板
   */
  @Builder
  loadNoiseControlPanel(boxWidth: number) {
    ForEach(this.noiseControlConfig, (item: BottomBtnPara, index: number) => {
      BottomBtn({
        boxWidth: boxWidth,
        para: {
          icon: item.icon,
          selectedIcon: item.selectedIcon,
          selectedCanvas: item.selectedCanvas,
          label: item.label,
          isSelected: this.ancMode.value === item.value,
          des: item.des
        },
        clickFun: (callback) => {
          this.setAncMode(item, callback);
          SoundReporterController.clickNoiseReport(this.outputDevice, item.value);
        }
      })
        .id(item.des)
        .geometryTransition(item.des)
        .transition(TransitionEffect.scale({ x: 0, y: 0 })
          .combine(TransitionEffect.OPACITY)
          .animation({
            duration: this.ancMode.des !== item.des ? this.animTimes : 0,
          }))
    }, (item: BottomBtnPara) => item.des)
  }

  @Builder
  loadSpatialPanel(boxWidth: number) {
    ForEach(this.spatialConfig, (item: BottomBtnPara, index: number) => {
      BottomBtn({
        boxWidth: boxWidth,
        para: {
          icon: item.icon,
          selectedCanvas: item.selectedCanvas,
          label: item.label,
          isSelected: this.spatialState.value === item.value,
          des: item.des
        },
        clickFun: (callback) => {
          this.setSpatialState(item, callback);
          SoundReporterController.clickSpatialReport(this.outputDevice, item.value);
        }
      })
        .id(item.des)
        .geometryTransition(item.des)
        .transition(TransitionEffect.scale({ x: 0, y: 0 })
          .combine(TransitionEffect.OPACITY)
          .animation({
            duration: this.spatialState.des !== item.des ? this.animTimes : 0,
          }))
    }, (item: BottomBtnPara) => item.des)
  }
}

@Component
struct BottomBtn {
  private viewData: SliderButtonViewData = new SliderButtonViewData(true);
  @Prop para: BottomBtnPara;
  @State isFirst: boolean = true;
  clickFun: (callback: () => void) => void = () => {
  };
  @Prop boxWidth: number = this.viewData.buttonWidth / 4;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State scaleX: number = HoverConstants.HOVER_DEFAULT_SCALE;
  @Provide canvasScale: number = HoverConstants.HOVER_DEFAULT_SCALE;
  private startY: number = 0;
  touchAction = (event: TouchEvent) => {
    if (event.type === TouchType.Down) {
      this.startY = event.touches[0].y;
      animateTo({
        curve: curves.springMotion(0.31, 0.94)
      }, () => {
        this.scaleX = HoverConstants.HOVER_DOWN_SCALE;
        this.canvasScale = HoverConstants.HOVER_DOWN_SCALE;
      })
    } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      this.TopToggleTouchOff();
    } else if (event.type === TouchType.Move) {
      if (Math.abs(event.touches[0].y - this.startY) > THRESHOLD_SLIDE) {
        this.TopToggleTouchOff();
      }
    }
  }

  TopToggleTouchOff() {
    animateTo({
      curve: curves.springMotion(0.31, 0.94),
      finishCallbackType: FinishCallbackType.LOGICALLY,
    }, () => {
      this.scaleX = HoverConstants.HOVER_DEFAULT_SCALE;
      this.canvasScale = HoverConstants.HOVER_DEFAULT_SCALE;
    })
  }

  build() {
    Column() {
      Stack() {
        Row() {
        }
        .width(40)
        .height(40)
        .borderRadius(20)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(this.para.isSelected ? this.colorModeViewData.wifiBgOnColor :
        this.colorModeViewData.wifiBgOffColor)
        // .backgroundBrightnessInternal(this.colorModeViewData.getTopOption(this.para.isSelected))

        if (this.para.isSelected && !this.isFirst) {
          LottieCanvas({
            animationData: this.para.selectedCanvas,
            name: this.para.des,
            canvasScale: this.canvasScale
          })
        } else {
          if (this.para.selectedIcon) {
            Image(this.para.isSelected ? this.para.selectedIcon : this.para.icon)
              .width(20)
              .height(20)
              .scale({ x: this.scaleX, y: this.scaleX })
              // .foregroundBrightness(this.colorModeViewData.getPrimaryFgOption(this.para.isSelected))
          } else {
            Image(this.para.icon)
              .width(20)
              .height(20)
              .scale({ x: this.scaleX, y: this.scaleX })
              .draggable(false)
              .fillColor(this.para.isSelected ? this.colorModeViewData.commonIconOnColor :
              this.colorModeViewData.commonIconOffColor)
              // .foregroundBrightness(this.colorModeViewData.getPrimaryFgOption(this.para.isSelected))
          }
        }
      }
      .width(40)
      .height(40)
      .onTouch(this.touchAction)
      .scale({ x: this.scaleX, y: this.scaleX })
      .onClick(() => {
        this.clickFun(() => {
          this.isFirst = false;
        })
      })

      Text(this.para.label)
        .margin({ top: 4 })
        .fontSize('12vp')
        // .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOptionOnBackground)
        .fontColor(this.colorModeViewData.commonIconOffColor)
        .onClick(() => {
          this.clickFun(() => {
            this.isFirst = false;
          })
        })

      if (this.para.subLabel) {
        Text(this.para.subLabel)
          .margin({ top: 2 })
          .fontSize('10vp')
          // .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOptionOnBackground)
          .fontColor(this.colorModeViewData.commonIconOffColor)
          .opacity(0.6)
          .onClick(() => {
            this.clickFun(() => {
              this.isFirst = false;
            })
          })
      }
    }
    .width(this.boxWidth)
  }
}