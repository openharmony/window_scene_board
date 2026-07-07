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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { ThreadUtil } from '@ohos/basicutils/src/main/ets/utils/ThreadUtil';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import audio from '@ohos.multimedia.audio';
import inputConsumer from '@ohos.multimodalInput.inputConsumer';
import { KeyCode } from '@ohos.multimodalInput.keyCode';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { ResourceVm } from '@ohos/systemuicommon/src/main/ets/vm/ResourceVm';
import { systemUIWorkerManager } from '@ohos/systemuicommon/src/main/ets/manager/SystemUIWorkerManager';
import CommonUtils from '../../Util/CommonUtils';
import Constants, { LocalDeviceInfo, DeviceSource, DeviceState, AVCastPickerDeviceIconName,ButtonIconName,
  CallSessionInfo, GeometryOptions, SetVolumeType, InputVolumeAction } from '../../Util/Constants';
import MeasuringUtil from '../../Util/MeasuringUtil';
import MediaInfoProvider from '../../Controller/MediaInfoProvider';
import { MediaInfoProviderDc } from '../../Controller/MediaInfoProviderDc';
import { DcMediaController } from '../../Controller/DcMediaController';
import { MediaViewModelManager, MediaVMType } from '../../viewmodel/MediaViewModelManager';
import { SysConfigData } from '../../viewmodel/SysConfigData';
import Curves from '@ohos.curves';

const TAG: string = 'CallInfoCard_debug';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

@Component
export struct CallInfoCard {
  /**
   * 是否开启worker子线程
   */
  private enableDc: boolean = systemUIWorkerManager.isEnabled();
  private isPad: boolean = DeviceHelper.isPad();
  @Prop isLandscape: boolean = false;
  @Prop panelWidth: number = 0;
  @Prop fadeOpacity: number = 0;
  @Prop titleMaxFontScale: number = Constants.SMALL_FOLD_DEVICE_TITLE_MAX_FONT_SCALE;
  @Prop textMaxFontScale: number = Constants.TEXT_MAX_FONT_SCALE;
  @Prop pointOpacityFirst: number = 0.1; // 播放动画透明度1
  @Prop pointOpacitySecond: number = 0.1; // 播放动画透明度2
  @Prop pointOpacityThird: number = 0.1; // 播放动画透明度3
  @Prop isSmallFoldDevice: boolean = false;
  @Prop mediaTransitionFlag: number = 0;
  @Prop dcController: DcMediaController | undefined = undefined;
  @Prop panelHeight: number = Constants.CALL_CARD_HEIGHT;
  @Prop showVolume: boolean = true;
  @Prop mediaTransitionDone: boolean = true;
  @Prop curCallDevice: LocalDeviceInfo = {
    deviceType: audio.DeviceType.SPEAKER,
    deviceId: 0,
    deviceName: 'xxx',
    deviceSource: DeviceSource.LOCAL,
    networkId: 'LocalDevice',
  };
  @Consume('isJumping') isJumping: boolean;
  @Consume('isQuiting') isQuiting: boolean;
  // 音量
  @StorageLink('callVolume') callVolume: number = 0;
  @Link isButtonHolding: boolean;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  private uiContext: UIContext = this.getUIContext();
  private mediaInfoProvider: MediaInfoProvider | MediaInfoProviderDc = this.enableDc ?
    MediaInfoProviderDc.getInstance() : MediaInfoProvider.getInstance(); // 开启worker时，使用DC子线程provider
  @State private volumeHeight: number = Constants.SLIDER_POINT_HEIGHT;
  @State defaultResourceName: string = 'app.string.volume_channel_voice_call';
  @StorageLink('callSessionInfo') callSession: CallSessionInfo | undefined = undefined;
  private geometryOptions: GeometryOptions = { hierarchyStrategy: TransitionHierarchyStrategy.NONE };
  private readonly LOST_DEVICE_TYPE_TV: number = 23; // AVSession缺失设备类型，标识TV
  private clickCurSwitchIcon: () => void = () => {};
  private readonly btnSize: number = 38;
  @State sysConfigData: SysConfigData | undefined = ThreadUtil.isMainThread ?
    MediaViewModelManager.getData(MediaVMType.SYS_CONFIG_DATA, true) as SysConfigData : undefined;

  aboutToAppear() {
    if (this.showVolume) {
      this.registerInputConsumer();
    }
  }

  aboutToDisappear() {
    if (this.showVolume) {
      this.removeInputConsumer();
    }
  }

  private registerInputConsumer(): void {
    if (this.mediaInfoProvider) {
      // 注册回调事件，父组件监听后调用该方法
      this.mediaInfoProvider.inputCallVolumeCallback = this.callbackInputConsumer;
    }
  }

  private removeInputConsumer(): void {
    if (this.mediaInfoProvider) {
      // 解除注册回调
      this.mediaInfoProvider.inputCallVolumeCallback = () => {};
    }
  }

  /**
   * 物理音量键回调
   */
  private callbackInputConsumer = (callback: inputConsumer.KeyOptions) => {
    log.showWarn(`callbackInputConsumer call`)
    if (callback.finalKey !== KeyCode.KEYCODE_VOLUME_UP &&
      callback.finalKey !== KeyCode.KEYCODE_VOLUME_DOWN) {
      return;
    }
    const actionType: InputVolumeAction = callback.finalKey === KeyCode.KEYCODE_VOLUME_UP ?
      InputVolumeAction.PLUS : InputVolumeAction.MINUS;
    this.mediaInfoProvider?.callVolumeInput(SetVolumeType.CALL, actionType);
  }

  getResourceString(data: Resource) {
    // 隔离主线程调用
    if (ThreadUtil.isMainThread) {
      return ResUtils.getInnerString(data);
    } else {
      return ResourceVm.instance.getString(data);
    }
  }

  getFontSizeScale() {
    // 隔离主线程调用
    if (ThreadUtil.isMainThread) {
      return this.sysConfigData?.fontSizeScale || 1;
    } else {
      return ResourceVm.instance.fontScale;
    }
  }

  isRTL() {
    // 隔离主线程调用
    return ThreadUtil.isMainThread ? !!this.sysConfigData?.isRTL : ResourceVm.instance.isRTL;
  }

  isShowButtonIcon(): boolean {
    if (this.curCallDevice.deviceSource === DeviceSource.LOCAL && this.isLocalDeviceState()) {
      return false;
    } else if (this.curCallDevice.deviceState !== DeviceState.CONNECTING) {
      return true;
    }
    return false;
  }

  /**
   * 本机扬声器及通话场景（麦克风，蓝牙SCO）返回按钮默认样式
   * @returns 是否使用默认样式（无设备连接）
   */
  isLocalDeviceState(): boolean {
    // 本机扬声器
    let isSpeaker = this.curCallDevice.deviceType === audio.DeviceType.SPEAKER &&
      this.curCallDevice.networkId === 'LocalDevice';
    // 本机听筒
    let isEarpiece = this.curCallDevice.deviceType === audio.DeviceType.EARPIECE &&
      !AppStorage.get('isConnectedPadCar');
    // 投播
    let isRemote = this.curCallDevice.deviceType === audio.DeviceType.REMOTE_CAST;
    return isSpeaker || isEarpiece || isRemote;
  }

  /**
   * 设备按钮图标
   * @returns
   */
  getCurSwitchIcon() : string {
    log.showInfo(`curSwitch call device type is ${this.curCallDevice.deviceType}`);
    switch (this.curCallDevice.deviceType) {
      case audio.DeviceType.SPEAKER:
        if (CommonUtils.isShowCarIcon(this.curCallDevice.networkId, this.curCallDevice.deviceType)) {
          return AVCastPickerDeviceIconName.CAR_SYMBOL;
        }
        return AVCastPickerDeviceIconName.CAST_STREAM_SYMBOL;
      case audio.DeviceType.USB_HEADSET:
      case audio.DeviceType.WIRED_HEADSET:
      case audio.DeviceType.WIRED_HEADPHONES:
        return AVCastPickerDeviceIconName.WIRED_SYMBOL;
      case audio.DeviceType.BLUETOOTH_A2DP:
      case audio.DeviceType.BLUETOOTH_SCO:
        return CommonUtils.getBluetoothFillIcon(this.curCallDevice.deviceAddress);
      case audio.DeviceType.NEARLINK:
        return CommonUtils.getNearlinkFillIcon(this.curCallDevice.deviceAddress);
      case Constants.DEVICE_TYPE_HEARING_AID:
        return AVCastPickerDeviceIconName.HEARING_AID_SYMBOL;
      case audio.DeviceType.EARPIECE:
        if (CommonUtils.isShowCarIcon(this.curCallDevice.networkId, this.curCallDevice.deviceType)) {
          return AVCastPickerDeviceIconName.CAR_SYMBOL;
        }
        return AVCastPickerDeviceIconName.CAST_STREAM_SYMBOL;
      default:
        return AVCastPickerDeviceIconName.CAST_STREAM_SYMBOL;
    }
  }

  /**
   * 渲染策略
   * @param iconName
   * @returns
   */
  getRenderingStrategy(iconName: string): SymbolRenderingStrategy {
    if (iconName === AVCastPickerDeviceIconName.CAST_STREAM_SYMBOL ||
      iconName === AVCastPickerDeviceIconName.CAST_SCREEN_SYMBOL) {
      return SymbolRenderingStrategy.SINGLE;
    }
    return SymbolRenderingStrategy.MULTIPLE_OPACITY;
  }

  /**
   * 获取进度条长度
   * @returns
   */
  getSliderWidth(): number {
    let volumeWidth: number = 0;
    let cardEdgePadding: number = Constants.CARD_EDGE_PADDING;
    if (this.isLandscape) { //横屏
      let cardWidth: number = (Constants.PANEL_LANDSCAPE_WIDTH - Constants.LANDSCAPE_CARD_MARGIN) / 2;
      volumeWidth = cardWidth - (cardEdgePadding + Constants.COMMON_PICTURE_SIZE +
        Constants.CARD_ICON_PADDING - Constants.SLIDER_INNER_PADDING) * 2;
    } else { //竖屏，音量条宽度 = 卡片宽度-(卡片边距+图标宽度+图标与音量条间距-音量条组件内边距)x2
      volumeWidth = Constants.PANEL_PORTRAIT_WIDTH - (cardEdgePadding + Constants.COMMON_PICTURE_SIZE +
        Constants.CARD_ICON_PADDING - Constants.SLIDER_INNER_PADDING) * 2;
    }
    return volumeWidth
  }

  @Builder
  HeaderBuilder() {
    Flex({
      direction: FlexDirection.Row,
      justifyContent: FlexAlign.SpaceBetween,
      alignItems: ItemAlign.Center
    }) {
      Row() {
        Text($r('app.string.LocalDevice'))
          .fontColor($r('app.color.media_control_text_primary'))
          .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.ohos_id_text_size_body2'))
          .maxFontScale(this.titleMaxFontScale)
          .padding({ right: this.isRTL() ? 24 : 0 })
          .accessibilityLevel('yes')
          .accessibilityGroup(true)
          .id('callInfoHeader')
        if (this.isShowButtonIcon()) {
          this.ConnectBuilder()
          Text(this.curCallDevice.deviceName)
            .fontColor($r('app.color.media_control_text_primary'))
            .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
            .fontWeight(FontWeight.Medium)
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .maxFontScale(this.titleMaxFontScale)
            .maxLines(1)
            .wordBreak(WordBreak.BREAK_ALL)
            .direction(this.isRTL() ? Direction.Rtl : Direction.Ltr)
            .layoutWeight(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .accessibilityLevel('yes')
            .accessibilityGroup(true)
        }
      }
      .height('100%')
      .alignItems(VerticalAlign.Center)
      .layoutWeight(1)
      .flexGrow(1)
      .opacity(this.fadeOpacity)
      .id('callCardTitleEnd')
      .transition(this.mediaTransitionFlag > 0 || this.isQuiting ?
        this.getHeaderTransition() : TransitionEffect.IDENTITY)

      Button({ stateEffect: false }) {
        this.SwitchIconBuilder()
      }
      .type(ButtonType.Normal)
      .backgroundColor(Color.Transparent)
      .accessibilityGroup(true)
      .onClick(() => {
        this.clickCurSwitchIcon();
      })
      .accessibilityLevel('yes')
      .accessibilityText(this.getResourceString($r('app.string.access_switch_playback_device')))
      .height('100%')
      .width(Constants.COMMON_SWITCH_SIZE + 24)
      .margin({left: this.isRTL() ? -12 : 0, right: this.isRTL() ? 0 : 12})
      .id('callSwitchIconEnd')
      .geometryTransition('callSwitchIcon', this.geometryOptions)
    }
    .width('100%')
    .height(Constants.COMMON_PICTURE_SIZE + Constants.COMMON_ROW_PADDING)
    .padding({ left: Constants.COMMON_ROW_PADDING })
  }

  getHeaderTransition(): TransitionEffect {
    const transOptions: TranslateOptions = this.isLandscape ?
      { x: (Constants.PANEL_LANDSCAPE_WIDTH - this.panelWidth) / -2} :
      { y: this.isPad ? Constants.COMMON_ROW_PADDING * -1 :
        (Constants.COMMON_PICTURE_SIZE + Constants.COMMON_ROW_PADDING) * -2 };
    const opacityAnimation: AnimateParam = this.isQuiting ?
      { duration: 100, curve: Curve.Sharp } :
      { duration: 100, curve: Curve.Sharp, delay: 100 };
    return TransitionEffect.translate(transOptions)
      .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) })
      .combine(TransitionEffect.opacity(0).animation(opacityAnimation));
  }

  @Builder
  ConnectBuilder() {
    Flex({
      direction: FlexDirection.Row,
      justifyContent: FlexAlign.SpaceBetween,
      alignItems: ItemAlign.Center
    }) {
      Image($r('app.media.device_switch_point'))
        .draggable(false)
        .width(Constants.COMMON_POINT_SIZE)
        .height(Constants.COMMON_POINT_SIZE)
        .fillColor($r('app.color.media_control_ponit'))
        .opacity(this.pointOpacityFirst)
      Image($r('app.media.device_switch_point'))
        .draggable(false)
        .width(Constants.COMMON_POINT_SIZE)
        .height(Constants.COMMON_POINT_SIZE)
        .fillColor($r('app.color.media_control_ponit'))
        .opacity(this.pointOpacitySecond)
      Image($r('app.media.device_switch_point'))
        .draggable(false)
        .width(Constants.COMMON_POINT_SIZE)
        .height(Constants.COMMON_POINT_SIZE)
        .fillColor($r('app.color.media_control_ponit'))
        .opacity(this.pointOpacityThird)
    }
    .width(Constants.COMMON_POINT_GROUP_WIDTH)
    .margin({
      left: Constants.COMMON_POINT_GROUP_MARGIN,
      right: Constants.COMMON_POINT_GROUP_MARGIN,
    })
  }

  @Builder
  SwitchIconBuilder() {
    Column() {
      SymbolGlyph($r(this.getCurSwitchIcon()))
        .fontSize(Constants.COMMON_CAST_SMALL_SIZE)
        .backgroundColor(Constants.TRANSLUCENT_COLOR)
        .fontColor(this.isShowButtonIcon() ?
          [$r('app.color.media_control_switch_active_full')] : [$r('app.color.media_control_switch_full')])
        .foregroundBrightness(this.colorModeViewData.getPrimaryFgOption(this.isShowButtonIcon()))
        .draggable(false)
        .renderingStrategy(this.getRenderingStrategy(this.getCurSwitchIcon()))
    }
    .width(Constants.COMMON_SWITCH_SIZE)
    .height(Constants.COMMON_SWITCH_SIZE)
    .borderRadius(120)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(this.isShowButtonIcon() ?
      $r('app.color.media_control_switch_active_bgc') : (this.colorModeViewData.isBrightnessActive ?
        $r('app.color.media_control_color_brightness') : $r('app.color.media_control_component_normal')))
    .backgroundBrightnessInternal(this.colorModeViewData.getTopOption(this.isShowButtonIcon()))
    .id('callInfoSwitchIcon')
  }

  getCallTitle(): string {
    return this.getResourceString($r('app.string.device_in_call'));
  }

  @Builder
  BodyBuilder() {
    Row() {
      Stack({ alignContent: Alignment.Center }) {
        Column()
          .backgroundColor($r('app.color.media_control_default_img_bgc'))
          .borderRadius($r('sys.float.ohos_id_corner_radius_default_m'))
          .width('100%')
          .height('100%')
          .id('callImgBgEnd')
          .geometryTransition('callImgBg', this.geometryOptions)
        SymbolGlyph($r(ButtonIconName.CALL_SYMBOL))
          .fontSize(Constants.COMMON_CAST_SMALL_SIZE)
          .backgroundColor(Constants.TRANSLUCENT_COLOR)
          .fontColor( [$r('sys.color.icon_emphasize')])
          .draggable(false)
          .id('callImgEnd')
          .geometryTransition('callImg', this.geometryOptions)
        if (this.callSession?.appIcon) {
          Image(this.callSession?.appIcon)
            .backgroundColor(Constants.TRANSLUCENT_COLOR)
            .draggable(false)
            .interpolation(ImageInterpolation.Medium)
            .autoResize(false)
            .borderRadius($r('sys.float.ohos_id_corner_radius_default_xs'))
            .size({
              width: Constants.COMMON_PICTURE_SIZE_SMALL,
              height: Constants.COMMON_PICTURE_SIZE_SMALL
            })
            .position({
              top: Constants.COMMON_PICTURE_SIZE_LARGE - Constants.COMMON_PICTURE_SIZE_SMALL,
              left: this.isRTL() ? 0 : Constants.COMMON_PICTURE_SIZE_LARGE - Constants.COMMON_PICTURE_SIZE_SMALL,
              right: this.isRTL() ? Constants.COMMON_PICTURE_SIZE_LARGE - Constants.COMMON_PICTURE_SIZE_SMALL : 0,
            })
            .id('callIconEnd')
            .geometryTransition('callIcon', this.geometryOptions)
        }
      }
      .alignContent(Alignment.Center)
      .width(Constants.COMMON_PICTURE_SIZE_LARGE)
      .height(Constants.COMMON_PICTURE_SIZE_LARGE)

      Column() {
        Row() {
          Text(this.isRTL() ? `...${this.getCallTitle()}` : `${this.getCallTitle()}...`)
            .fontColor($r('app.color.media_control_text_primary'))
            .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
            .fontSize($r('sys.float.ohos_id_text_size_body1'))
            .maxFontScale(this.textMaxFontScale)
            .fontWeight(FontWeight.Medium)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .textAlign(TextAlign.Start)
        }
        .width('100%')
        .height(MeasuringUtil.getHeight(16, 24, this.textMaxFontScale, this.getFontSizeScale()))
        .accessibilityLevel('yes')
        .id('callTitleEnd')

        Row() {
          Text(this.callSession?.appName || $r(this.defaultResourceName))
            .fontColor($r('app.color.media_control_text_secondary'))
            .foregroundBrightness(this.colorModeViewData.foregroundTertiaryGlossSubOption)
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .maxFontScale(this.textMaxFontScale)
            .fontWeight(FontWeight.Regular)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .textAlign(TextAlign.Start)
        }
        .width('100%')
        .height(MeasuringUtil.getHeight(14, 19, this.textMaxFontScale, this.getFontSizeScale()))
        .accessibilityLevel('yes')
        .id('callSubTitleEnd')
      }
      .constraintSize({minHeight: Constants.COMMON_PICTURE_SIZE_LARGE})
      .width(`calc(100% - ${Constants.COMMON_PICTURE_SIZE_LARGE}vp)`)
      .padding({
        left: this.isRTL() ? 0 : 12,
        right: this.isRTL() ? 12 : 0,
      })
      .transition(this.mediaTransitionFlag > 0 || this.isQuiting ?
        this.getTitleTransition() : TransitionEffect.IDENTITY)
    }
    .alignItems(VerticalAlign.Top)
    .padding({ left: Constants.COMMON_ROW_PADDING, right: Constants.COMMON_ROW_PADDING })
    .margin({ bottom: Constants.SLIDER_MARGIN / 2 })
    .onClick(() => {
      //mediaTransitionFlag在一镜到底动画播放完后的值不为0，导致点击通话卡片，无法跳转到CallUI,暂不判断mediaTransitionFlag
      if (this.callSession) {
        this.isJumping = true;
        this.mediaInfoProvider?.startAimApp(this.callSession.sessionId || '');
      }
    })
  }

  getTitleTransition(): TransitionEffect {
    const transOptions: TranslateOptions = this.isLandscape ?
      { x: (Constants.PANEL_LANDSCAPE_WIDTH - this.panelWidth) / -2} :
      { y: this.isPad ? Constants.COMMON_PICTURE_SIZE_LARGE * -1 : Constants.COMMON_PICTURE_SIZE_LARGE * -2 };
    const opacityAnimation: AnimateParam = this.isQuiting ?
      { duration: 100, curve: Curve.Sharp } :
      { duration: 100, curve: Curve.Sharp, delay: 100 };
    return TransitionEffect.translate(transOptions)
      .animation({ curve: Curves.interpolatingSpring(0, 1, 228, 25) })
      .combine(TransitionEffect.opacity(0).animation(opacityAnimation));
  }

  onSliderChange(value: number, mode: SliderChangeMode) {
    log.showInfo(`call slider change: ${value}, mode=${mode}`);
    switch (mode) {
      case SliderChangeMode.Begin:
        this.uiContext.animateTo({ duration: 300 }, () => {
          this.volumeHeight *= 2.5;
        });
        break;
      case SliderChangeMode.Moving:
        this.isButtonHolding = true;
        break;
      case SliderChangeMode.End:
        if (value <= 0) {
          this.volumeHeight = Constants.SLIDER_POINT_HEIGHT;
        } else {
          this.uiContext.animateTo({ duration: 300 }, () => {
            this.volumeHeight = Constants.SLIDER_POINT_HEIGHT;
          });
        }
        this.isButtonHolding = false;
        break;
      default:
        this.isButtonHolding = false;
        break;
    }
    this.callVolume = value;
    this.mediaInfoProvider?.callVolumeChange(value, mode);
  }

  @Builder
  VolumeBuilder() {
    Stack() {
      Flex({
        direction: FlexDirection.Row,
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.Center
      }) {
        Column().width(this.btnSize).height(this.btnSize).id('buttonPreviousEnd')
          .geometryTransition('callButtonPrevious', this.geometryOptions)
        Column().width(this.btnSize).height(this.btnSize).id('buttonPlayEnd')
          .geometryTransition('callButtonPlay', this.geometryOptions)
        Column().width(this.btnSize).height(this.btnSize).id('buttonNextEnd')
          .geometryTransition('callButtonNext', this.geometryOptions)
      }
      .width('100%')
      .height(this.isSmallFoldDevice && !this.isLandscape ?
        Constants.SLIDER_SMALL_HEIGHT : Constants.SLIDER_HEIGHT)

      Flex({
        direction: FlexDirection.Row,
        justifyContent: FlexAlign.SpaceBetween,
        alignItems: ItemAlign.Center
      }) {
        Row() {
          SymbolGlyph($r(ButtonIconName.CALL_REDUCE_SYMBOL))
            .fontSize(`${Constants.COMMON_PICTURE_SIZE}vp`)
            .fontColor([$r('app.color.media_control_icon_disable')])
            .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
            .backgroundColor(Constants.TRANSLUCENT_COLOR)
            .draggable(false)
        }
        .width(Constants.COMMON_PICTURE_SIZE)
        .justifyContent(FlexAlign.Start)
        .id('callVolumeReduceEnd')
        .geometryTransition('callVolumeReduce', this.geometryOptions)
        .transition(TransitionEffect.OPACITY)

        Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Slider({
            value: this.callVolume,
            min: 0,
            max: Constants.CALL_VOLUME_SLIDER_MAX,
            step: 1,
            style: SliderStyle.InSet,
            direction: Axis.Horizontal
          })
            .trackColor($r('app.color.media_control_component_normal'))
            .blockColor(Color.Transparent)
            .selectedColor($r('app.color.media_control_slider_primary'))
            .showSteps(false)
            .showTips(false)
            .blockStyle({
              type: SliderBlockType.SHAPE,
              shape: new Path({ commands: Constants.SLICER_SHAPE_COMMANDS })
            })
            .accessibilityText(Math.round(this.callVolume * 2 / 3) + '% ' +
              this.getResourceString($r('app.string.access_call_volume_bar')))
            .trackThickness(this.volumeHeight)
            .onChange((value: number, mode: SliderChangeMode) => {
              this.onSliderChange(value, mode);
            })
        }
        .height(this.isSmallFoldDevice && !this.isLandscape ?
          Constants.SLIDER_SMALL_HEIGHT : Constants.SLIDER_HEIGHT)
        .width(this.getSliderWidth())
        .margin({ left: Constants.SLIDER_MARGIN, right: Constants.SLIDER_MARGIN })
        .backgroundColor(Constants.TRANSLUCENT_COLOR)
        .clip(true)
        .id('callVolumeEnd')
        .geometryTransition('callVolume', this.geometryOptions)
        .transition(TransitionEffect.OPACITY)

        Row() {
          SymbolGlyph($r(ButtonIconName.CALL_ADD_SYMBOL))
            .fontSize(`${Constants.COMMON_PICTURE_SIZE}vp`)
            .fontColor([$r('app.color.media_control_icon_disable')])
            .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
            .backgroundColor(Constants.TRANSLUCENT_COLOR)
            .draggable(false)
        }
        .width(Constants.COMMON_PICTURE_SIZE)
        .justifyContent(FlexAlign.Start)
        .id('callVolumeAddEnd')
        .geometryTransition('callVolumeAdd', this.geometryOptions)
        .transition(TransitionEffect.OPACITY)
      }
      .width('100%')
      .height(this.isSmallFoldDevice && !this.isLandscape ?
        Constants.SLIDER_SMALL_HEIGHT : Constants.SLIDER_HEIGHT)
      .padding({ left: Constants.COMMON_ROW_PADDING, right: Constants.COMMON_ROW_PADDING })
      .opacity(this.fadeOpacity)
    }
  }

  getHeight(): number {
    const fontSizeScale = this.getFontSizeScale();
    return MeasuringUtil.getHeight(16, MeasuringUtil.getHeight(14, this.panelHeight,
      this.textMaxFontScale, fontSizeScale), this.textMaxFontScale, fontSizeScale);
  }

  build() {
    Stack() {
      Column()
        .backgroundColor($r('app.color.media_control_card_bgc'))
        .backgroundBrightnessInternal(this.colorModeViewData.mainCardOption)
        .borderRadius(this.isLandscape ?
          Constants.MEDIA_CARD_LANDSCAPE_BORDER_RADIUS : Constants.MEDIA_CARD_BORDER_RADIUS)
        .height('100%')
        .width('100%')
        .id('callPanelEnd')
        .geometryTransition('callPanel', this.geometryOptions)
      Column() {
        this.HeaderBuilder()
        this.BodyBuilder()
        if (this.showVolume) {
          this.VolumeBuilder()
        }
      }
      .height('100%')
      .width('100%')
    }
    .height(this.getHeight())
    .width(this.panelWidth)
    .onTouch((event?: TouchEvent) => {
      event?.stopPropagation();
    })
  }
}