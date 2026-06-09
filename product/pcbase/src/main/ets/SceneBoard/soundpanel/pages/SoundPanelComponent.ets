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
import window from '@ohos.window';
import { windowMgr, StartAbilityUtil, } from '@ohos/windowscene';
import { BusinessError } from '@ohos.base';
import common from '@ohos.app.ability.common';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import { AudioHelper, SoundReporterController } from '@ohos/soundcomponent';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  DeviceHelper,
  EvtBus,
  HiSysEventUtil,
  PluginPosition,
  PluginSlot,
  ScreenLockEvent,
  WindowPositionChangeEvent
} from '@ohos/frameworkwrapper';
import { ExtAppConstants } from '@ohos/commonconstants';
import { NormalPanelInfo, StatusBarPanelManager } from '../../../common/manager/StatusBarPanelManager';
import XmlParseUtil from '../../microphonepanel/util/XmlParseUtil';
import StyleConfiguration, { ClickableMenuStyle, SoundPanelComponentStyle } from '../common/StyleConfiguration';
import { soundFeatureModel, SoundFeatureType } from '../model/SoundFeatureModel';
import { audioDevice, AudioOutputChangeListener4V, AudioSoundViewModel } from '../viewmodel/AudioSoundViewModel';
import { PanelManager, PanelStateChangeListener } from '../manager/PanelManager';
import Constants from '../common/Constants';
import AIEffectCallNoiseReductionView from './AIEffectCallNoiseReductionView';
import AIEffectVoiceCancelView from './AIEffectVoiceCancelView';
import { HorizontalCardComponent } from './HorizontalCardComponent';
import EarPhoneDevice from './EarPhoneDevice';
import DeviceItem from './DeviceItem';
import SoundSlider from './SoundSlider';

const TAG = 'SoundPanel-SoundPanelComponent';
const DEBUG_TAG = 'AudioSettingDebug';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 窗口名
 */
const WINDOW_NAME = PluginSlot.SLOT_STATUS_SOUND_PANEL;
const KEYBOARD = 4;

@Component
export default struct SoundPanelComponent {
  @State devices: audioDevice[] = [];
  @State viewIndex: number = Constants.DEFAULT_DEVICE_ID;
  @State style: SoundPanelComponentStyle = StyleConfiguration.getSoundPanelComponentStyle();
  @State styleClickable: ClickableMenuStyle = StyleConfiguration.getClickableMenuStyle();
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @Consume mHeight: number;
  @Consume persistentId: number;
  @State panelInfo: NormalPanelInfo | undefined = undefined;
  private eventType: string = HiSysEventUtil.TOUCH_EVENT;
  @State deviceBatteryMap: Map<string, ESObject> = new Map();
  @State deviceBatteryTypeMap: Map<string, number> = new Map();
  private curDeviceMac: string = '';
  // 降噪配置
  @State noiseControlConfig: SoundFeatureType[] = [];
  // 空间音频配置
  @State spatialConfig: SoundFeatureType[] = [];
  //当前的降噪模式
  @State ancMode: SoundFeatureType = soundFeatureModel.getDefaultAncMode();
  // 当前的空间音频模式
  @State spatialState: SoundFeatureType = soundFeatureModel.getDefaultSpatialState();
  // 特性面板高度
  @State @Watch('updateWindowPosition') featureHeight: number = 0;
  // 支持的降噪能力模式
  // private noiseControlAbility: NoiseControlSupportMode = NoiseControlSupportMode.NOT_SUPPORT;
  // 支持的空间音频能力模式
  // private spatialAbility: SpatialSupportMode = SpatialSupportMode.NOT_SUPPORT;

  @Styles
  normalStyles() {
    .border({
      width: '2vp',
      color: '#00000000'
    })
  }

  @Styles
  focusedStyles() {
    .border({
      width: '2vp',
      color: '#ff0a59f7'
    })
  }

  aboutToAppear() {
    log.showInfo(`SoundPanelComponent, aboutToAppear`);
    this.panelInfo = StatusBarPanelManager.getInstance()
      .getStatusBarInfoById(this.persistentId) as NormalPanelInfo;
    AudioSoundViewModel.getInstance().registerOutputChangeListener(this.audioOutputChangeListener, TAG);
    PanelManager.getInstance().registerPanelStateChangeListener(this.panelStateChangeListener, TAG);
    // 适应多用户切换场景，音频框架分用户音量区分，但不会发布任何通知；因此根据切换用户必定触发锁屏逻辑特点，锁屏状态变更时，重新查询音频输出
    EvtBus.on(ScreenLockEvent, () => {
      log.showInfo('user screen lock change, update output audio info');
      AudioSoundViewModel.getInstance().getOutputState(TAG);
    });
  }

  aboutToDisappear() {
    log.showInfo(`SoundPanelComponent, aboutToDisAppear`);
    AudioSoundViewModel.getInstance().unregisterOutputChangeListener(this.audioOutputChangeListener, TAG);
    PanelManager.getInstance().unregisterPanelStateChangeListener(this.panelStateChangeListener, TAG);
  }

  private audioOutputChangeListener: AudioOutputChangeListener4V = {
    onOutputDevicesChange: (devices: audioDevice[]) => {
      log.showInfo(`audioOutputChangeListener onOutputDevicesChange devices length: ${devices.length}`);
      this.devices = [];
      this.devices = devices;
      // 音频管家特性，蓝牙设备电量业务
      const map: Map<string, ESObject> = new Map();
      devices.forEach((device) => {
        // 使电量map与展示的ui数组数量一致
        const mac = device.address;
        const battery: ESObject | undefined = this.deviceBatteryMap.get(mac);
        if (battery) {
          map.set(mac, battery);
        }
      });
      this.deviceBatteryMap = map;
      // 刷新声音面板高度
      this.updateWindowPosition();
    },
    onCurrentOutputDeviceChange: (viewIndex: number) => {
      log.showInfo(`audioOutputChangeListener onCurrentOutputDeviceChange device viewIndex: ${viewIndex}`);
      this.viewIndex = viewIndex;
      this.getCurDevice();
    }
  };

  updateWindowPosition(): void {
    let defaultRect = windowMgr.getWindowPosition(WINDOW_NAME);
    let height = Constants.HAD_WINDOW_HEIGHT;
    const vocalSupport = XmlParseUtil.getVocalCancelSupport();
    const callReductSupport = XmlParseUtil.getCallNoiseReductforceSupport();
    let aiEffectTitleHeight =
      vocalSupport || callReductSupport ? Constants.TITLE_HEIGHT : Constants.CARD_DEFAULT_HEIGHT;
    let vocalCancelCardHeight = vocalSupport && callReductSupport ? Constants.CARD_CALL_HEIGHT :
      vocalSupport ? Constants.CARD_CALL_DEFAULT_HEIGHT : Constants.CARD_DEFAULT_HEIGHT;
    let callNoiseReductionCardHeight =
      callReductSupport ? Constants.CARD_NOISE_HEIGHT : Constants.CARD_DEFAULT_HEIGHT;
    height = height + aiEffectTitleHeight + vocalCancelCardHeight + callNoiseReductionCardHeight;
    if (this.devices.length > 1) {
      const featureHeight: number = this.getFeatureHeight();
      this.mHeight = height + (this.devices.length - 1) * Constants.DEVICE_ITEM_HEIGHT + featureHeight;
    } else {
      this.mHeight = height;
    }
    let heightWin = vp2px(this.mHeight);
    let updateRect: window.Rect = {
      top: defaultRect.top,
      left: defaultRect.left,
      width: defaultRect.width,
      height: heightWin
    };
    log.showInfo(`onAudioDeviceChange: updateRect: ${JSON.stringify(updateRect)} - ${this.mHeight}`);
    EvtBus.post(WindowPositionChangeEvent, {
      windowName: WINDOW_NAME,
      position: PluginPosition.POSITION_RIGHT, area: updateRect
    });
  }

  @Builder
  MyDivider(marginLeft: Length = this.style.soundPanelMarginLeft, key: string = '') {
    Divider()
      .strokeWidth(1)
      .color(this.panelInfo?.separatorColor)
      .key(`${TAG}_${key}`)
      .margin({
        left: marginLeft,
        right: this.style.soundPanelMarginRight,
        top: this.style.soundPanelDividerMarginTop,
        bottom: this.style.soundPanelDividerMarginTop
      })
  }

  build() {
    Column() {
      SoundSlider()

      this.MyDivider(this.style.soundPanelMarginLeft, 'First_Divider')

      Row() {
        Text($r('app.string.sound_output_device'))
          .draggable(false)
          .fontColor(this.colorModeViewData.wifiOffTextColor)
          .foregroundBrightness(this.colorModeViewData.foregroundTertiaryGlossOption)
          .fontSize(this.panelInfo?.subTitleTextSize)
          .fontWeight(FontWeight.Regular)
      }
      .alignItems(VerticalAlign.Center)
      .height($r('app.float.sound_slider_icon_hover_height'))
      .padding({
        left: this.style.soundPanelPaddingLeft,
        right: this.style.soundPanelPaddingRight
      })

      Column() {
        ForEach(this.devices, (item: audioDevice, index: number) => {
          if (index !== 0) {
            Column() {}
            .height(Constants.CARD_MORE_GAP)
          }
          if (AudioHelper.getInstance().isWirelessDevice(item.type)) {
            EarPhoneDevice({
              curViewIndex: this.viewIndex,
              mDeviceType: item.type,
              mDeviceName: item.name,
              mDeviceId: item.viewIndex,
              mDeviceAddress: item.address,
              isLast: this.devices.length - 1 === index,
              // batteryType: this.deviceBatteryTypeMap.get(item.address) ?? BatteryTypes.BATTERY_TYPE_UN_SUPPORT,
              batteryType: this.deviceBatteryTypeMap.get(item.address),
              // mDeviceBattery: this.deviceBatteryMap.get(item.address) ?? new DeviceBattery(),
              mDeviceBattery: this.deviceBatteryMap.get(item.address),
              noiseControlConfig: this.noiseControlConfig,
              spatialConfig: this.spatialConfig,
              ancMode: this.ancMode,
              spatialState: this.spatialState,
              featureHeight: this.featureHeight,
              mClickEvent: (data: number, isChecked: boolean, id: number,
                event: ClickEvent): void => this.onDeviceClickEvent(data, isChecked, id, event),
              getFeatureSupport:(deviceMac: string) => this.getFeatureSupport(deviceMac)
            })
          } else {
            DeviceItem({
              device: item,
              curViewIndex: this.viewIndex
            })
          }
        });
      }
      .justifyContent(FlexAlign.SpaceBetween)

      if (XmlParseUtil.getVocalCancelSupport() || XmlParseUtil.getCallNoiseReductforceSupport()) {
        this.MyDivider(this.style.soundPanelMarginLeft, 'Second_Divider')
        Row() {
          Text(XmlParseUtil.getLogSupport() ? $r('app.string.sound') : $r('app.string.ai_sound'))
            .draggable(false)
            .id(TAG + '_Text_AI_sound')
            .fontColor(this.colorModeViewData.wifiOffTextColor)
            .foregroundBrightness(this.colorModeViewData.foregroundTertiaryGlossOption)
            .fontSize(this.panelInfo?.subTitleTextSize)
            .fontWeight(FontWeight.Regular)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .alignItems(VerticalAlign.Center)
        .height($r('app.float.sound_slider_icon_hover_height'))
        .padding({
          left: this.style.soundPanelPaddingLeft,
          right: this.style.soundPanelPaddingRight
        })
      }

      if (XmlParseUtil.getVocalCancelSupport()) {
        AIEffectVoiceCancelView()
        if (XmlParseUtil.getCallNoiseReductforceSupport()) {
          this.MyDivider(this.style.soundPanelMarginLeft, 'Third_Divider')
        }
      }
      if (XmlParseUtil.getCallNoiseReductforceSupport()) {
        AIEffectCallNoiseReductionView()
      }
      this.MyDivider(this.style.soundPanelMarginLeft, 'Fourth_Divider')

      HorizontalCardComponent({
        title: $r('app.string.sound_settings'),
        isChecked: false,
        clickFunc: (clickEvent: ClickEvent) => this.execClickAction(clickEvent)
      })
    }
    .alignItems(HorizontalAlign.Start)
    .width('100%')
  }

  private onDeviceClickEvent(deviceType: number, isChecked: boolean, deviceId: number, event: ClickEvent): void {
    log.showInfo(`onDeviceClickEvent, SoundDeviceType: ${JSON.stringify(deviceType)},` +
     `isChecked: ${JSON.stringify(isChecked)}, event:  ${JSON.stringify(event)}`);
    if (event.source === SourceType.Mouse) {
      this.eventType = HiSysEventUtil.MOUSE_EVENT;
    } else if (event.source === KEYBOARD) {
      this.eventType = HiSysEventUtil.SHORTCUT_EVENT;
    } else {
      this.eventType = HiSysEventUtil.TOUCH_EVENT;
    }
    HiSysEventUtil.reportSoundMenu(deviceType, this.eventType);
    AudioSoundViewModel.getInstance().selectOutputDevice(deviceId, TAG);
  }

  private execClickAction(event: ClickEvent): void {
    log.showInfo(`click sound panel more settings`);
    let eventType: string = HiSysEventUtil.TOUCH_EVENT;
    if (event.source === SourceType.Mouse) {
      eventType = HiSysEventUtil.MOUSE_EVENT;
    } else if (event.source === KEYBOARD) {
      eventType = HiSysEventUtil.SHORTCUT_EVENT;
    } else {
      eventType = HiSysEventUtil.TOUCH_EVENT;
    }
    HiSysEventUtil.reportSoundMenu(HiSysEventUtil.CLICK_MORE, eventType);
    // 点击跳转页面，隐藏面板
    windowMgr.hideWindowWithAnim(WINDOW_NAME);
    const is2In1Pc: boolean = DeviceHelper.is2In1DevicePcType();
    StartAbilityUtil.startAbilityFromOther({
      bundleName: ExtAppConstants.PKG_PC_SETTINGS,
      abilityName: ExtAppConstants.ABILITY_PC_SETTINGS_AUDIO,
      uri: is2In1Pc ? 'volume_settings' : 'pc_audio_settings',
      moduleName: is2In1Pc ? 'phone_settings' : 'pc_settings'
    });
  }

  private panelStateChangeListener: PanelStateChangeListener = {
    onPanelForegroundStatusChange: (isPanelForeground: boolean) => {
      if (isPanelForeground) {
        AudioSoundViewModel.getInstance().getOutputState(TAG);
        this.initAamSFeature();
        this.getCurDevice();
        SoundReporterController.clickPcSoundMenuReport(this.curDeviceMac);
      } else {
        this.releaseAamSFeature();
      }
    }
  };

  private getCurDevice(): void {
    const device = this.devices.find((item) => {
      return item.viewIndex === this.viewIndex;
    });
    if (!device) {
      return;
    }
    const newAddress: string = device.address;
    // log.showInfo(`${DEBUG_TAG} onDeviceChange pre: ${convertMac(this.curDeviceMac)} cur: ${convertMac(newAddress)}`);
    const newDeviceType: number = device.type;
    if (newAddress === this.curDeviceMac) {
      return;
    }
    // 被选择的设备改变，取消之前设备的特性状态监听
    this.offFeatureListener(this.curDeviceMac);
    if (device && this.isBluetoothDevice(newAddress, newDeviceType)) {
      // 设备存在，记录mac并注册监听
      this.curDeviceMac = newAddress;
      this.onFeatureListener(newAddress);
      this.getFeatureSupport(newAddress);
    } else {
      this.curDeviceMac = '';
      this.featureHeight = 0;
    }
  }

  private getFeatureHeight(): number {
    // 显示电量的设备高度比不显示的多16
    const batterySize: number = this.deviceBatteryMap.size;
    // 电量高度 + 特性面板高度 + 特性面板上下边距和分割线的上下边距
    const height: number = (batterySize * 16) + this.featureHeight;
    log.showInfo(`${DEBUG_TAG} getHeight ${height}, batterySize: ${batterySize} featureHeight: ${this.featureHeight}`);
    return height;
  }

  /**
   * 判断是否蓝牙连接的设备
   * @returns boolean
   */
  private isBluetoothDevice(deviceAddress: string, deviceType: number): boolean {
    if (deviceAddress === Constants.INVALID_MAC || CheckEmptyUtils.checkStrIsEmpty(deviceAddress)) {
      // invalid mac
      return false;
    }
    return AudioHelper.getInstance().isWirelessDevice(deviceType);
  }

  private initAamSFeature(): void {
    log.showInfo(`${DEBUG_TAG} initAamSFeature`);
    // AamSdkClient.init(getContext(this) as common.UIAbilityContext);
    this.onBatteryChange();
  }

  /**
   * 注册特性监听
   * @param headsetMac 耳机mac
   */
  private onFeatureListener(headsetMac: string): void {
    // 注册手机侧空间音频开关状态监听
    /*AamSdkClient.onSpatialState({
      onEvent: (event: string, address: string, data: SpatialState) => {
        log.showInfo(`${DEBUG_TAG} onSpatialState ${data}`);
        if (address === this.curDeviceMac && this.spatialAbility !== SpatialSupportMode.NOT_SUPPORT &&
          this.spatialConfig.length > 0) {
          // 当前mac的空间音频状态改变
          this.spatialState = this.spatialConfig.find(item => item.value === data) as SoundFeatureType;
        }
      }
    });
    // 注册指定蓝牙设备的降噪控制开关状态监听
    AamSdkClient.onNoiseControlState(headsetMac, {
      onEvent: (event: string, address: string, data: NoiseControlState) => {
        log.showInfo(`${DEBUG_TAG} onNoiseControlState ${data.state} code:${data.errorCode}`);
        if (this.noiseControlAbility !== NoiseControlSupportMode.NOT_SUPPORT &&
          address === this.curDeviceMac && this.noiseControlConfig.length > 0) {
          // 当前mac的降噪状态改变
          this.ancMode = this.noiseControlConfig.find(item => item.value === data.state) as SoundFeatureType;
        }
      }
    });*/
  }

  /**
   * 获取特性状态信息
   */
  private getFeatureSupport(headsetMac: string): void {
   /* AamSdkClient.getFeatureSupport(headsetMac)
      .then((data: FeatureSupport) => {
        log.showInfo(`${DEBUG_TAG} getFeatureSupport ${convertMac(headsetMac)} noise: ${
        data.noiseControlSupportMode} spatial: ${data.spatialSupportMode}`);
        this.noiseControlAbility = data.noiseControlSupportMode;
        this.spatialAbility = data.spatialSupportMode;
        this.spatialConfig = soundFeatureModel.getSpatialConfig(this.spatialAbility);
        this.noiseControlConfig = soundFeatureModel.getNoiseControlConfig(this.noiseControlAbility);
        if (data?.spatialSupportMode !== SpatialSupportMode.NOT_SUPPORT) {
          this.getSpatialState(headsetMac);
        }
        if (data?.noiseControlSupportMode !== NoiseControlSupportMode.NOT_SUPPORT) {
          this.getNoiseControlState(headsetMac);
        }
      })
      .catch((error: BusinessError) => {
        log.showError(`${DEBUG_TAG} getFeatureSupport BusinessError ${error.message}`);
      });*/
  }

  /**
   * 获取空间音频状态
   */
  private getSpatialState(headsetMac: string): void {
    /*AamSdkClient.getSpatialState(headsetMac).then((data: SpatialState) => {
      log.showInfo(`${DEBUG_TAG} getSpatialState: ${data}, Config length: ${this.spatialConfig.length}`);
      if (this.spatialAbility !== SpatialSupportMode.NOT_SUPPORT && this.spatialConfig.length > 0) {
        this.spatialState = this.spatialConfig.find(item => item.value === data) as SoundFeatureType;
      }
    })*/
  }

  /**
   * 获取噪声控制状态
   */
  private getNoiseControlState(headsetMac: string): void {
    /*AamSdkClient.getNoiseControlState(headsetMac).then((data: NoiseSwitch) => {
      log.showInfo(`${DEBUG_TAG} getNoiseControlState: ${data}, Config length: ${this.noiseControlConfig.length}`);
      if (this.noiseControlAbility !== NoiseControlSupportMode.NOT_SUPPORT && this.noiseControlConfig.length > 0) {
        this.ancMode = this.noiseControlConfig.find(item => item.value === data) as SoundFeatureType;
      }
    })*/
  }

  /**
   * 移除特性监听
   * @param headsetMac 耳机mac
   */
  private offFeatureListener(headsetMac: string): void {
    log.showInfo(`${DEBUG_TAG} offFeatureListener`);
    /*AamSdkClient.offSpatialState();
    AamSdkClient.offNoiseControlState(headsetMac);*/
    // 重置特性数据
    // this.noiseControlAbility = NoiseControlSupportMode.NOT_SUPPORT;
    this.noiseControlConfig = [];
    this.ancMode = soundFeatureModel.getDefaultAncMode();
    // this.spatialAbility = SpatialSupportMode.NOT_SUPPORT;
    this.spatialConfig = [];
    this.spatialState = soundFeatureModel.getDefaultSpatialState();
  }

  /**
   * 释放aam
   */
  private releaseAamSFeature(): void {
    log.showInfo(`${DEBUG_TAG} releaseAamSFeature`);
    this.offFeatureListener(this.curDeviceMac);
    /*AamSdkClient.offBattery();
    AamSdkClient.destroy();*/
  }

  /**
   * 电量状态改变时回调
   */
  private onBatteryChange(): void {
    log.showInfo(`${DEBUG_TAG} onBatteryChange set listener`);
    // 注册设备电量变化事件
    /*AamSdkClient.onBattery({
      onEvent: (event, address, data) => {
        log.showInfo(`${DEBUG_TAG} onBatteryChange address = ${convertMac(address)}`);
        if (!data) {
          return;
        }
        this.getBatteryType(address);
        this.deviceBatteryMap.set(address, data);
        this.updateWindowPosition();
      }
    });*/
  }

  // 获取指定设备电量类型
  private getBatteryType(mDeviceAddress: string): void {
    /*AamSdkClient.getBatteryType(mDeviceAddress)
      .then((type: BatteryTypes) => {
        log.showInfo(`${DEBUG_TAG} getBatteryType mDeviceAddress: ${convertMac(mDeviceAddress)} type: ${type}`);
        if (type === BatteryTypes.BATTERY_TYPE_UN_SUPPORT) {
          return;
        }
        this.deviceBatteryTypeMap.set(mDeviceAddress, type);
      })
      .catch((error: BusinessError) => {
        log.showError(`getBatteryType BusinessError ${error.message}`);
      });*/
  }
}
