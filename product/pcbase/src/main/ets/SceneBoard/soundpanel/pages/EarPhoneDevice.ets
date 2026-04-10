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

import audio from '@ohos.multimedia.audio'
import { BusinessError } from '@kit.BasicServicesKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import { SymbolIconUtil } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import Constants from '../common/Constants';
import StyleConfiguration, { ClickableMenuStyle, SoundDeviceStyle } from '../common/StyleConfiguration';
import { BatteryInfo, FeaturePopupType, soundFeatureModel, SoundFeatureType } from '../model/SoundFeatureModel';
import { NormalPanelInfo, StatusBarPanelManager } from '../../../common/manager/StatusBarPanelManager';
import { SoundReporterController } from '@ohos/soundcomponent';
import { curves, LengthMetrics } from '@kit.ArkUI';
import { EarphoneDeviceConstants } from '../common/EarphoneDeviceConstants';
import { PanelManager, PanelStateChangeListener } from '../manager/PanelManager';

const TAG = 'SoundPanel-EarPhoneDevice';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const COMPONENT_ID_DEVICE_ICON = `${TAG}_Image_deviceIcon`;
const COMPONENT_ID_DEVICE_NAME = `${TAG}_Text_deviceName`;
const COMPONENT_ID_BATTERY_VALUE = `${TAG}_Image_batterydevice`;
const COMPONENT_ID_RADIO = `${TAG}_Image`;
const SEMIBOLD = 600;

@Component
export default struct EarPhoneDevice {
  @Prop @Watch('onAudioDeviceIdChange') curViewIndex: number;
  private mClickEvent: Function = (data: number, isChecked: boolean): void => {
  };
  private getFeatureSupport: Function = (deviceMac: string): void => {
  };
  private mDeviceType: number = audio.DeviceType.SPEAKER;
  @State mDeviceIcon: string = '';
  @Prop mDeviceName: ResourceStr = '';
  @Prop mDeviceId: number = Constants.DEFAULT_DEVICE_ID;
  @Prop mDeviceAddress: string = '';
  @State style: SoundDeviceStyle = StyleConfiguration.getSoundDeviceStyle();
  @State styleClickable: ClickableMenuStyle = StyleConfiguration.getClickableMenuStyle();
  @State isDeviceSelected: boolean = false;
  @State panelInfo: NormalPanelInfo | undefined = undefined;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @Consume persistentId: number;
  // 特性面板是否展开
  @State isExpand: boolean = false;
  // 电量类型
  // @Prop batteryType: number = BatteryTypes.BATTERY_TYPE_UN_SUPPORT;
  @Prop batteryType: number = 0;
  // 当前设备是否为最后一个
  @Prop isLast: boolean = false;
  // 耳机电量信息
  // @Prop mDeviceBattery: DeviceBattery = new DeviceBattery();
  @Prop mDeviceBattery: ESObject = {};
  // 降噪配置
  @Link @Watch('onNoiseControlConfigChange') noiseControlConfig: SoundFeatureType[];
  // 空间音频配置
  @Link @Watch('onSpatialConfigChange') spatialConfig: SoundFeatureType[];
  //当前的降噪模式
  @Link ancMode: SoundFeatureType;
  // 当前的空间音频模式
  @Link spatialState: SoundFeatureType;
  // 特性面板的高度
  @Link featureHeight: number;
  // 特性点击的popup弹窗
  @State featurePopup: FeaturePopupType = new FeaturePopupType();
  // 气泡提示消失时间定时器id
  private popupTimeOut: number = -1;

  @Styles
  normalStyles() {
    .backgroundColor(this.styleClickable.stackBgColorUnSelected)
  }

  @Styles
  pressedStyles() {
    .backgroundColor(this.styleClickable.stackBgColorSelected)
  }

  aboutToAppear(): void {
    log.showInfo('EarPhoneDevice aboutToAppear');
    this.panelInfo = StatusBarPanelManager.getInstance()
      .getStatusBarInfoById(this.persistentId) as NormalPanelInfo;
    PanelManager.getInstance().registerPanelStateChangeListener(this.panelStateChangeListener, TAG);
    /*AamSdkClient.onConnection({
      onEvent: (event: string, address: string, data: SdkDeviceState) => {
        log.showInfo(`onConnection ${convertMac(address)} ${convertMac(this.mDeviceAddress)}`);
        if (address === this.mDeviceAddress) {
          AamSdkClient.refreshBatteryReport(this.mDeviceAddress);
          this.getCheckedFeature();
        }
      }
    })*/
    this.isExpand = this.isFeatureSupport();
    this.updateFeatureHeight();
  }

  aboutToDisappear(): void {
    log.showInfo('EarPhoneDevice aboutToDisappear');
    PanelManager.getInstance().unregisterPanelStateChangeListener(this.panelStateChangeListener, TAG);
    // AamSdkClient.offConnection();
    this.isExpand = false;
  }

  private panelStateChangeListener: PanelStateChangeListener = {
    onPanelForegroundStatusChange: (isPanelForeground: boolean) => {
      log.showInfo(`onStateChange panelState: ${isPanelForeground}`);
      if (isPanelForeground) {
        // AamSdkClient.refreshBatteryReport(this.mDeviceAddress);
        this.getCheckedFeature();
      } else {
        this.reset();
      }
    }
  };

  onAudioDeviceIdChange(): void {
    if (this.isChecked()) {
      this.isExpand = true;
      this.updateFeatureHeight();
    }
  }

  onNoiseControlConfigChange(): void {
    this.updateFeatureHeight();
  }

  onSpatialConfigChange(): void {
    this.updateFeatureHeight();
  }

  getCheckedFeature() {
    log.showInfo(`getCheckedFeature ConfigLen: ${this.noiseControlConfig.length}, ${this.spatialConfig.length}`);
    if (this.isChecked()) {
      this.getFeatureSupport(this.mDeviceAddress);
    }
  }

  setSpatialState(item: SoundFeatureType): void {
    if (this.spatialState.value === item.value) {
      return;
    }
    log.showInfo(`setSpatialState item: ${item.value}`)
    /*AamSdkClient.setSpatialState(this.mDeviceAddress, item.value as SpatialState)
      .then((number) => {
        if (number === 0) {
          this.spatialState = item;
        }
      })*/
  }

  setAncMode(item: SoundFeatureType): void {
    if (this.ancMode.value === item.value) {
      return;
    }
    log.showInfo(`setAncMode item: ${item.value}`);
    /*AamSdkClient.setNoiseControlState(this.mDeviceAddress, item.value as NoiseSwitch)
      .then((code: NoiseErrorCode) => {
        if (code === NoiseErrorCode.SUCCESS) {
          this.ancMode = item;
          return;
        }
        if (code === NoiseErrorCode.UN_WEAR_ERROR || code === NoiseErrorCode.UN_WEAR_DOUBLE_ERROR) {
          // 佩戴原因导致无法设置，弹出提示
          clearTimeout(this.popupTimeOut);
          // 当前耳机未佩戴
          this.featurePopup.featureDes = item.des;
          this.featurePopup.isPopupShow = true;
          this.featurePopup.handlePopup = this.getPopupOptions(GlobalContext.getContext()?.resourceManager
            .getStringSync($r('app.string.toast_wear_headphone').id) ?? '');
          this.popupTimeOut = setTimeout(() => {
            this.featurePopup.isPopupShow = false;
          }, EarphoneDeviceConstants.POPUP_DISAPPEAR_TIME);
        }
      })*/
  }

  // 是否支持降噪或空间音频
  isFeatureSupport(): boolean {
    return this.noiseControlConfig.length > 0 || this.spatialConfig.length > 0;
  }

  @Builder
  DefaultDividerBuilder(): void {
    Divider()
      .strokeWidth(1)
      .color(this.panelInfo?.separatorColor)
      .margin({
        left: EarphoneDeviceConstants.FEATURE_MARGIN_LEFT,
        right: EarphoneDeviceConstants.FEATURE_MARGIN_RIGHT,
        top: EarphoneDeviceConstants.FEATURE_MARGIN_TOP_BOTTOM,
        bottom: EarphoneDeviceConstants.FEATURE_MARGIN_TOP_BOTTOM
      })
  }

  // 电量
  @Builder
  BatteryCard(): void {
    Row({ space: EarphoneDeviceConstants.BATTERY_COMPONENT_SPACE }) {
      /*if (this.batteryType === BatteryTypes.BATTERY_TYPE_TWS) {
        // 左右耳机+盒子电量显示
        this.TwsBatteryGroup();
      } else if (this.batteryType === BatteryTypes.BATTERY_TYPE_SINGLE) {
        // 单电量
        this.BatteryBuilder({
          icon: soundFeatureModel.getSingleBatteryIcon(this.mDeviceBattery.minBattery),
          iconSize: EarphoneDeviceConstants.BATTERY_SINGLE_ICON_SIZE,
          value: this.mDeviceBattery.minBattery,
          isCharging: this.mDeviceBattery.isLeftCharging || this.mDeviceBattery.isRightCharging,
          isChargingMargin: true,
          isSymbol: true
        })
      }*/
    }
    .margin({ top: EarphoneDeviceConstants.COMPONENT_SPACE })
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Start)
  }

  @Builder
  TwsBatteryGroup(): void {
    if (this.mDeviceBattery.isMerge) {
      // 左右混合图标电量
      this.BatteryBuilder({
        icon: $r('app.media.ic_device_battery_earphone_left_right'),
        iconSize: EarphoneDeviceConstants.BATTERY_MERGE_ICON_SIZE,
        value: this.mDeviceBattery.mergeValue,
        isCharging: this.mDeviceBattery.isMergeCharging,
      })
    } else {
      this.BatteryBuilder({
        icon: $r('app.media.ic_device_battery_earphone_left'),
        iconSize: EarphoneDeviceConstants.BATTERY_ICON_SIZE,
        value: this.mDeviceBattery.leftValue,
        isCharging: this.mDeviceBattery.isLeftCharging,
      })
      this.BatteryBuilder({
        icon: $r('app.media.ic_device_battery_earphone_right'),
        iconSize: EarphoneDeviceConstants.BATTERY_ICON_SIZE,
        value: this.mDeviceBattery.rightValue,
        isCharging: this.mDeviceBattery.isRightCharging,
      })
    }
    // 盒子图标电量
    this.BatteryBuilder({
      icon: $r(`${SymbolIconUtil.getEarphoneCaseIcon(this.mDeviceAddress)}`),
      iconSize: EarphoneDeviceConstants.BATTERY_CASE_ICON_SIZE,
      value: this.mDeviceBattery.boxValue,
      isCharging: this.mDeviceBattery.isBoxCharging,
      isChargingMargin: true,
      isSymbol: true
    })
  }

  @Builder
  BatteryBuilder($$: BatteryInfo): void {
    Row() {
      if ($$.isSymbol) {
        SymbolGlyph($$.icon)
          .id(COMPONENT_ID_BATTERY_VALUE)
          .draggable(false)
          .fontSize(`${$$.iconSize}vp`)
          .fontWeight(FontWeight.Normal)
          .fontColor([this.colorModeViewData.wifiOffTextColor])
          .foregroundBrightness(this.colorModeViewData.foregroundTertiaryGlossOption)
      } else {
        Image($$.icon)
          .id(COMPONENT_ID_BATTERY_VALUE)
          .draggable(false)
          .objectFit(ImageFit.Contain)
          .width($$.iconSize)
          .height($$.iconSize)
          .fillColor(this.colorModeViewData.wifiOffTextColor)
          .foregroundBrightness(this.colorModeViewData.foregroundTertiaryGlossOption)
          .edgeAntialiasing(EarphoneDeviceConstants.IMAGE_ANTIALIASING)
      }

      if ($$.isCharging) {
        SymbolGlyph($r('sys.symbol.bolt_fill'))
          .id(`${TAG}_Image_batteryCharging`)
          .draggable(false)
          .margin($$.isChargingMargin ? { start: LengthMetrics.vp(1) } : {})
          .fontSize('8vp')
          .fontColor([this.colorModeViewData.wifiOffTextColor])
          .foregroundBrightness(this.colorModeViewData.foregroundTertiaryGlossOption)
      }

      Text(`${$$.value > 0 ? $$.value : '--'}`)
        .id(`${TAG}_Text_batteryValue`)
        .margin({ start: LengthMetrics.vp(4) })
        .fontSize(this.panelInfo?.listAssistedTextSize)
        .fontColor(this.colorModeViewData.wifiOffTextColor)
        .fontWeight(FontWeight.Regular)
        .foregroundBrightness(this.colorModeViewData.foregroundTertiaryGlossOption)

      if ($$.value > 0) {
        Text('%')
          .id(`${TAG}_Text_batteryPercent`)
          .fontSize(EarphoneDeviceConstants.BATTERY_PERCENT_SIZE)
          .fontColor(this.colorModeViewData.wifiOffTextColor)
          .fontWeight(FontWeight.Regular)
          .foregroundBrightness(this.colorModeViewData.foregroundTertiaryGlossOption)
      }
    }
  }

  // 设备名
  @Builder
  DeviceNameText(): void {
    Text(this.getDeviceName())
      .draggable(false)
      .id(COMPONENT_ID_DEVICE_NAME)
      .fontColor(this.getCheckedColor())
      .foregroundBrightness(this.isChecked() ? undefined : this.colorModeViewData.foregroundPrimaryOption)
      .fontSize(this.panelInfo?.listTextSize)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .wordBreak(WordBreak.BREAK_WORD)
      .lineBreakStrategy(LineBreakStrategy.HIGH_QUALITY)
      .maxLines(1)
      .fontWeight(this.getCheckedFontWeight())
      .fontFamily('HarmonyHeiTi')
  }

  @Builder
  NoiseControlPanel(): void {
    this.FeatureTitle($r('app.string.base_noise_control'));

    Column({ space: EarphoneDeviceConstants.COMPONENT_SPACE }) {
      ForEach(this.noiseControlConfig, (item: SoundFeatureType) => {
        Row() {
          this.FeatureItem({
            label: item.label,
            value: item.value,
            icon: item.icon,
            des: item.des,
            isSelected: this.ancMode?.value === item?.value,
          })
        }
        .borderRadius(this.panelInfo?.hoverRadius)
        .focusBox({ margin: LengthMetrics.vp(-2) })
        .onClick(() => {
          this.setAncMode(item);
          SoundReporterController.clickPcSoundNoiseReport(this.mDeviceAddress, item.value);
        })
      })
    }
  }

  @Builder
  SpatialPanel(): void {
    this.FeatureTitle(this.spatialConfig.length === EarphoneDeviceConstants.SPATIAL_THREE_MODE_LENGTH ?
    $r('app.string.HD_spatial_audio') : $r('app.string.spatial_audio'));

    Column({ space: EarphoneDeviceConstants.COMPONENT_SPACE }) {
      ForEach(this.spatialConfig, (item: SoundFeatureType) => {
        Row() {
          this.FeatureItem({
            label: item.label,
            value: item.value,
            icon: item.icon,
            des: item.des,
            isSelected: this.spatialState.value === item.value,
          })
        }
        .borderRadius(this.panelInfo?.hoverRadius)
        .focusBox({ margin: LengthMetrics.vp(-2) })
        .onClick(() => {
          this.setSpatialState(item);
          SoundReporterController.clickPcSoundSpatialReport(this.mDeviceAddress, item.value);
        })
      })
    }
  }

  // 特性标题
  @Builder
  FeatureTitle(text: ResourceStr): void {
    Text(text)
      .draggable(false)
      .id(`${TAG}_Text_featureTitle`)
      .fontColor(this.colorModeViewData.wifiOffTextColor)
      .foregroundBrightness(this.colorModeViewData.foregroundTertiaryGlossOption)
      .fontSize(this.style.fontSize)
      .fontWeight(FontWeight.Regular)
      .height(EarphoneDeviceConstants.FEATURE_TITLE_HEIGHT)
      .padding({
        left: EarphoneDeviceConstants.FEATURE_MARGIN_LEFT,
        right: EarphoneDeviceConstants.FEATURE_MARGIN_RIGHT,
      })
  }

  @Builder
  FeatureItem(featureParam: SoundFeatureType): void {
    Row() {
      // 透传图片无法填充，需要等symbol资源上库后修改
      Image(featureParam.icon)
        .draggable(false)
        .id(`${TAG}_Image_featureIcon`)
        .objectFit(ImageFit.Contain)
        .width(this.style.imageWidth)
        .height(this.style.imageHeight)
        .margin({ start: LengthMetrics.vp(EarphoneDeviceConstants.FEATURE_MARGIN_LEFT) })
        .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
        .edgeAntialiasing(EarphoneDeviceConstants.IMAGE_ANTIALIASING)

      Text(featureParam.label)
        .id(`${TAG}_Text_featureLabel`)
        .fontColor(featureParam.isSelected ? this.panelInfo?.selectedListTextColor :
        this.colorModeViewData.wifiOffTextColor)
        .foregroundBrightness(featureParam.isSelected ? undefined : this.colorModeViewData.foregroundPrimaryOption)
        .fontSize(this.panelInfo?.listTextSize)
        .fontWeight(featureParam.isSelected ? SEMIBOLD : FontWeight.Medium)
        .fontFamily('HarmonyHeiTi')
        .margin({
          left: this.style.soundDeviceGap,
          right: this.style.soundDeviceGap
        })

      Blank()

      if (featureParam.isSelected) {
        SymbolGlyph($r('sys.symbol.checkmark'))
          .id(`${TAG}_Image_featureChecked`)
          .draggable(false)
          .fontSize(this.style.imageWidth)
          .fontColor([this.getCheckedColor()])
          .margin({ end: LengthMetrics.vp(EarphoneDeviceConstants.FEATURE_MARGIN_RIGHT) })
      }
    }
    .height(EarphoneDeviceConstants.FEATURE_ITEM_HEIGHT)
    .width('100%')
    .stateStyles({
      normal: this.normalStyles,
      pressed: this.pressedStyles,
    })
    .borderRadius(this.panelInfo?.hoverRadius)
    .hoverEffect(HoverEffect.Highlight)
    .bindPopup(this.featurePopup.isPopupShow && this.featurePopup.featureDes === featureParam.des,
      this.featurePopup.handlePopup)
  }

  @Builder
  FeatureGroup(): void {
    Column() {
      this.DefaultDividerBuilder();
      if (this.noiseControlConfig.length > 0) {
        this.NoiseControlPanel();
      }
      if (this.spatialConfig.length > 0) {
        this.SpatialPanel();
      }
      if (!this.isLast) {
        // 非最后一个设备，特性面板需要加分割线
        this.DefaultDividerBuilder();
      }
    }
    .height(this.featureHeight)
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .visibility(this.isExpand ? Visibility.Visible : Visibility.None)
    .transition(TransitionEffect.asymmetric(TransitionEffect.OPACITY.animation({
      delay: 100,
      duration: 150,
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1)
    }), TransitionEffect.IDENTITY))
  }

  @Builder
  DeviceCheckedIcon(): void {
    if (this.isFeatureSupport()) {
      SymbolGlyph(this.isExpand ? $r('sys.symbol.chevron_up') : $r('sys.symbol.chevron_down'))
        .draggable(false)
        .id(COMPONENT_ID_RADIO)
        .fontSize(this.style.imageHeight)
        .fontColor([this.getCheckedColor()])
        .flexShrink(0)
    } else {
      SymbolGlyph($r('sys.symbol.checkmark'))
        .draggable(false)
        .id(COMPONENT_ID_RADIO)
        .fontSize(this.style.imageHeight)
        .fontColor([this.getCheckedColor()])
        .flexShrink(0)
    }
  }

  @Builder
  DeviceInfo(): void {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      SymbolGlyph($r(`sys.symbol.${SymbolIconUtil.getEarphoneFillIcon(this.mDeviceAddress)}`))
        .draggable(false)
        .id(COMPONENT_ID_DEVICE_ICON)
        .fontSize(this.style.imageHeight)
        .fontColor([this.colorModeViewData.commonIconOffColor])
        .renderingStrategy(SymbolRenderingStrategy.MULTIPLE_OPACITY)
        .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
        .flexShrink(0)

      Column() {
        this.DeviceNameText();
        if (this.isShowBattery()) {
          this.BatteryCard();
        }
      }
      .alignItems(HorizontalAlign.Start)
      .margin({
        left: this.style.soundDeviceGap,
        right: this.style.soundDeviceGap
      })

      Blank()

      if (this.isChecked()) {
        this.DeviceCheckedIcon()
      }
    }
    .key('sound_output_device_bluetooth_device')
    .height(this.isShowBattery() ? EarphoneDeviceConstants.SUPPORT_BATTERY_HEIGHT :
    EarphoneDeviceConstants.NO_BATTERY_HEIGHT)
    .borderRadius(this.panelInfo?.hoverRadius)
    .focusBox({ margin: LengthMetrics.vp(-2) })
    .padding({
      left: this.styleClickable.stackPadding,
      right: this.styleClickable.stackPadding,
    })
    .onClick((event?: ClickEvent): void => {
      if (event) {
        this.onClickEvent(event);
      }
    })
    .onTouch((event?: TouchEvent): void => {
      if (event) {
        this.onTouchEvent(event);
      }
    })
  }

  build() {
    Column() {
      Row() {
        this.DeviceInfo()
      }
      .justifyContent(FlexAlign.Center)
      .borderRadius(this.panelInfo?.hoverRadius)
      .hoverEffect(HoverEffect.Highlight)
      .stateStyles({
        normal: this.normalStyles,
        pressed: this.pressedStyles,
      })

      if (this.isChecked() && this.isFeatureSupport()) {
        this.FeatureGroup();
      }
    }
    .padding({ left: this.style.menuMarginLeftRight, right: this.style.menuMarginLeftRight })
    .width('100%')
  }

  private getCheckedColor(): ResourceColor | undefined {
    return this.isChecked() ? this.panelInfo?.selectedListTextColor : this.colorModeViewData.wifiOffTextColor;
  }

  private getCheckedFontWeight(): string | FontWeight {
    return this.isChecked() ? SEMIBOLD : FontWeight.Medium;
  }

  private onTouchEvent(event: TouchEvent): void {
    if (event.type === TouchType.Down) {
      this.isDeviceSelected = true;
    } else if (event.type === TouchType.Up) {
      this.isDeviceSelected = false;
    }
  }

  private isChecked(): boolean {
    return this.mDeviceId === this.curViewIndex;
  }

  private isShowBattery(): boolean {
    /*if (this.batteryType === BatteryTypes.BATTERY_TYPE_UN_SUPPORT) {
      return false;
    }*/
    /*log.showInfo(`isShowBattery address: ${convertMac(this.mDeviceAddress)}, ${this.mDeviceBattery.mergeValue
    }, ${this.mDeviceBattery.leftValue}, ${this.mDeviceBattery.rightValue}, ${this.mDeviceBattery.boxValue}`);*/
    // 电量都小于0，隐藏电量显示
    return this.mDeviceBattery.boxValue >= 0 || this.mDeviceBattery.mergeValue >= 0 ||
      this.mDeviceBattery.minBattery >= 0 || this.mDeviceBattery.rightValue >= 0 || this.mDeviceBattery.leftValue >= 0;
  }

  private getDeviceName(): string | Resource {
    if (this.mDeviceName != undefined && this.mDeviceName != '' && this.mDeviceName != null) {
      log.showInfo(`getDeviceName: ${this.mDeviceName}`);
      return this.mDeviceName;
    }
    return $r('app.string.sound_output_device_bluetooth');
  }

  private onClickEvent(event: ClickEvent): void {
    if (this.isDeviceSelected) {
      return;
    }
    if (this.isChecked()) {
      this.clickSelectedDevice();
    } else {
      // 被点击设备未被选中，进行切换设备打点
      SoundReporterController.changePcSoundDeviceReport(this.mDeviceAddress);
    }
    if (this.mClickEvent) {
      this.mClickEvent(this.mDeviceType, this.isDeviceSelected, this.mDeviceId, event);
    }
  }

  // 点击时已被选中
  private clickSelectedDevice(): void {
    this.isExpand = !this.isExpand;
    if (this.isExpand) {
      this.updateFeatureHeight();
    } else {
      // 特性面板未展开，特性面板高度为0
      this.featureHeight = 0;
    }
  }

  private updateFeatureHeight(): void {
    if (!this.isChecked()) {
      // 非当前选中的设备不去计算
      return;
    }
    if (this.isFeatureSupport() && this.isExpand) {
      this.featureHeight = soundFeatureModel.getFeatureHeight(this.noiseControlConfig.length,
        this.spatialConfig.length, this.isLast);
    } else {
      this.featureHeight = 0;
    }
  }

  private getPopupOptions(message: string): PopupOptions {
    return {
      message: message,
      placement: Placement.BottomLeft,
      offset: { x: EarphoneDeviceConstants.POPUP_MESSAGE_OFFSET_X, y: 0 },
      arrowOffset: EarphoneDeviceConstants.POPUP_ARROW_OFFSET_X,
      onStateChange: (event) => {
        log.showInfo(`getPopupOptions onStateChange: isVisible = ${event.isVisible}`);
        if (!event.isVisible) {
          this.featurePopup.isPopupShow = event.isVisible;
          clearTimeout(this.popupTimeOut);
        }
      }
    }
  }

  private reset(): void {
    this.isDeviceSelected = false;
    this.featurePopup.isPopupShow = false;
  }
}