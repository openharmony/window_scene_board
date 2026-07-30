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
import bluetoothConstant from '@ohos.bluetooth.constant';
import bluetoothConnection from '@ohos.bluetooth.connection';
import bluetoothBaseProfile from '@ohos.bluetooth.baseProfile';
import bluetoothAccess from '@ohos.bluetooth.access';
import bluetoothA2dp from '@ohos.bluetooth.a2dp';
import bluetoothHfp from '@ohos.bluetooth.hfp';
import bluetoothHid from '@ohos.bluetooth.hid';
import { BluetoothDevice, BlueToothProtocol, BlueToothState } from '../common/Constants';
import commonEvtMgr from '@ohos.commonEventManager';
import type { CommonEventSubscriber } from 'commonEvent/commonEventSubscriber';
import type { CommonEventData } from 'commonEvent/commonEventData';
import { a2dp, hfp, hid } from '@kit.ConnectivityKit';
import type baseProfile from './@ohos.bluetooth.baseProfile';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import {
  LogDomain,
  LogHelper,
  SingletonHelper,
  AppStorageUtil,
  DataProperty,
} from '@ohos/basicutils';
import {
  PluginInfo,
  PluginSlot,
  HiDfxEventUtil,
  EventManager,
  sEventManager,
  obtainStartAbilityWithWant,
  EvtBus,
  PluginRequestEvent,
  DeviceHelper,
  PluginPosition,
  PluginClickInfo,
  WindowPositionChangeEvent,
  obtainLocalEvent,
  GlobalContext,
} from '@ohos/frameworkwrapper';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import lazy { windowMgr } from '@ohos/windowscene/src/main/ets/windowmanager/WindowManagerProxy';
import {
  ExtAppConstants,
  FASlotName,
  SettingsConstants,
  SettingsKeyConstants,
} from '@ohos/commonconstants';
import { BaseController, CommonData } from '@ohos/controlcentercommon/Index';
import Constants from '../common/Constants';
import { BusinessError } from '@ohos.base';

import {
  EdmAdminManager,
  DropDownPanelManager,
  PluginWidthChangeEvent,
  RegisterAPIProtector,
  StatusBarType
} from '@ohos/systemuicommon/Index';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import taskpool from '@ohos.taskpool';
import { performanceMonitor } from '@kit.ArkUI';
import {
  MultiDeviceCollaborationServiceEnableEvent
} from '@ohos/systemuicommon/src/main/ets/datasharemanager/SysUIDataShareEvent';
import {
  AirplaneStateEvent,
  SpecialIconEvent,
  LogWithHa,
  StatusBarTypeChangeEvent
} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { DataShareUtils } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { AntiTheftUtil } from '@ohos/systemuicommon/src/main/ets/utils/AntiTheftUtil';
import {
  ControlCenterHiSysEventUtil
} from '@ohos/controlcentercommon/src/main/ets/hiSysEvent/ControlCenterHiSysEventUtil';

import StyleConfiguration, { StatusBarBluetoothComponentStyle } from '../common/StyleConfiguration';
import { EventManagerAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/EventManagerAdapter';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { ToggleScene, ToggleStyle } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { ToggleViewData } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleViewData';
import { WifiDecorator } from '@ohos/controlcentercommon/src/main/ets/toggle/decorator/WifiDecorator';
import { StatusBarExceptionCode } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarExceptionCode';
import { InnerEventUtil } from '@ohos/systemuicommon/newTsIndex';

// instrument ignore file
type BondStateParam = bluetoothConnection.BondStateParam;
type StateChangeParam = bluetoothBaseProfile.StateChangeParam;

const TAG = 'Model.BluetoothController';
const DEFAULT_NAME = $r('app.string.control_center_complex_toggle_bluetooth_title');
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const sRegisterAPIProtector: RegisterAPIProtector = RegisterAPIProtector.get();
const BLUETOOTH_SERVICE_STOP: number = 2900001;
const LOCAL_EVENT_TYPE = 'local';
const ISWAIT_CLEAR_TIMEOUT: number = 5000;
const PERSIST_EDM_BLUETOOTH_CONFIG = 'persist.edm.prohibit_bluetooth';

/**
 * 蓝牙已连接事件
 */
const EVENT_CONNECT_STATUS = 'usual.event.bluetooth.remotedevice.CONNECT_STATUS_VALUE';
const PERMISSION_CONNECT: string = 'ohos.permission.PERMISSION_USED_STATS';

/**
 * 蓝牙连接设备更新电量事件
 */
const EVENT_BATTERY_VALUE_UPDATE = 'usual.event.bluetooth.remotedevice.BATTERY_VALUE_UPDATE';

@Observed
export class BluetoothData {
  public deviceName: string = '';
  // active设备的电量，取值 -1 ~ 100，-1表示不支持显示电量
  public batteryValue: number = -1;
  // 是否有设备连接
  public isConnected: boolean = false;
}

export class BluetoothController extends ToggleBaseViewModel {
  private bluetoothDeviceInfo = new Set<BluetoothDeviceInfoCallback>();
  private currentBluetoothStatus?: boolean;
  private timerId?: number;
  private mdName: string | undefined = DeviceHelper.isPC() ? undefined : 'phone_settings';
  private mBluetoothState: BlueToothState = BlueToothState.STATE_UNKNOWN;
  private mBluetoothData: BluetoothData = new BluetoothData();
  private mBondedDevices: Map<string, BluetoothDevice> = new Map();
  private isClickOpen: boolean = false;
  private isWaitingLastActionDone: boolean = false;
  private mSubscriber: CommonEventSubscriber | null = null;
  private mBluetoothId: string = '';
  private multiDeviceCollaborationSwitch: boolean = true;
  private airplaneStatus: boolean = false;
  private bluetoothControllerEventMgr: EventManager = EvtBus.createEventManager();
  private connectStatusSubscribe: commonEvtMgr.CommonEventSubscriber | null = null;
  private batterySubscribe: commonEvtMgr.CommonEventSubscriber | null = null;
  private callbackTimeoutTimeId: number = -1;
  private statusBarType: StatusBarType = StatusBarType.TYPE_MAIN_PHONE_LAUNCHER;

  private specialEvent: SpecialIconEvent = SpecialIconEvent.create(PluginSlot.SLOT_STATUS_BLE, false);

  public openDetailPageFunc: (() => void) | undefined = () => {
    this.openDetailPage();
  };

  private readonly SYSTEM_COMMON_EVENTS: commonEvtMgr.CommonEventSubscribeInfo = {
    events: [
    // 蓝牙名字变化
    commonEvtMgr.Support.COMMON_EVENT_BLUETOOTH_REMOTEDEVICE_NAME_UPDATE,
    ]
  };

  private style: StatusBarBluetoothComponentStyle = StyleConfiguration.getStatusBarBluetoothComponentStyle();

  private pluginWidthChangeEvent = PluginWidthChangeEvent.create(this.getSbPluginSlot(),
    ResUtils.getNumberFromLength(this.style.staticBarBluetoothWidth));

  constructor() {
    super();
    this.getViewData().isSymbolIcon = true;
    this.getViewData().icon = $r('sys.symbol.bluetooth');
    this.getViewData().label = DEFAULT_NAME;
    this.onStart();
  }

  isPersist(): boolean {
    return true;
  }

  public static getInstance(): BluetoothController {
    return SingletonHelper.getInstance(BluetoothController, TAG);
  }

  /**
   * 获取蓝牙状态
   */
  getBluetoothState(): BlueToothState {
    let curState: BlueToothState = BlueToothState.STATE_UNKNOWN;
    let getState: bluetoothAccess.BluetoothState = bluetoothAccess.BluetoothState.STATE_TURNING_OFF;
    try {
      getState = bluetoothAccess.getState();
    } catch (error) {
      LogWithHa.error(log, `getBluetoothState getState() err: code is ${error?.code}, message is ${error?.message}`,
        StatusBarExceptionCode.BLUETOOTH_FAIL, error, TAG);
    }
    log.showInfo(`getBluetoothState getState()=${getState} + curState=${this.mBluetoothState} | ${this.isWaitingLastActionDone}`);

    switch (getState) {
      case bluetoothAccess.BluetoothState.STATE_ON:
        curState = BlueToothState.STATE_ON;
        break;
      case bluetoothAccess.BluetoothState.STATE_OFF:
        curState = BlueToothState.STATE_OFF;
        break;
      case bluetoothAccess.BluetoothState.STATE_BLE_ON:
        curState = BlueToothState.STATE_BLE_ON;
        break;
      default:
        break;
    }
    if ((this.airplaneStatus || !this.multiDeviceCollaborationSwitch) && curState === BlueToothState.STATE_BLE_ON) {
      return BlueToothState.STATE_UNKNOWN;
    }
    return curState;
  }

  getLottieOpenDarkName(): string {
    return Constants.LOTTIE_DATA_OPEN_DARK;
  }

  getLottieCloseDarkName(): string {
    return Constants.LOTTIE_DATA_CLOSE_DARK;
  }

  getLottieOpenName(): string {
    return Constants.LOTTIE_DATA_OPEN;
  }

  getLottieCloseName(): string {
    return Constants.LOTTIE_DATA_CLOSE;
  }

  getLottieDarkName(): string {
    return Constants.LOTTIE_DATA_OPEN_DARK;
  }

  getNewLottieOpenName(): string {
    return Constants.NEW_LOTTIE_DATA_OPEN;
  }

  getNewLottieCloseName(): string {
    return Constants.NEW_LOTTIE_DATA_CLOSE;
  }

  isLoadLottie(): boolean {
    return true;
  }

  registerBtDeviceInfoCallback(cb: BluetoothDeviceInfoCallback) {
    log.showInfo(`registerTintCallback`);
    this.bluetoothDeviceInfo.add(cb);
  }

  unregisterBtDeviceInfoCallback(cb: BluetoothDeviceInfoCallback) {
    log.showInfo(`unregisterTintCallback`);
    this.bluetoothDeviceInfo.delete(cb);
  }

  notifyBtDeviceInfoChange(data: BluetoothData) {
    this.bluetoothDeviceInfo.forEach((listener) => {
      listener.notifyDeviceInfoChange(data);
    })
  }

  private onMultiDeviceCollaborationSwitchChange = (event: MultiDeviceCollaborationServiceEnableEvent): void => {
    const isEnable: boolean = event.isMultiDeviceCollaborationServiceEnable();
    log.showInfo('onMultiDeviceCollaborationSwitchChange isEnable: ' + isEnable);
    this.multiDeviceCollaborationSwitch = isEnable;
  };

  private onAirplaneStateChange = (event: AirplaneStateEvent): void => {
    log.showInfo('onAirplaneStateChange isEnable: ' + event.getAirplaneState());
    this.airplaneStatus = event.getAirplaneState();
  }

  public subscribeBluetoothStateChange = () => {
    bluetoothAccess.on('stateChange', (data) => {
      log.showInfo('onstart onbluetoothstatechange data: ' + data);
      if (data == bluetoothAccess.BluetoothState.STATE_OFF ||
        data == bluetoothAccess.BluetoothState.STATE_TURNING_OFF ||
        data == bluetoothAccess.BluetoothState.STATE_BLE_TURNING_OFF) {
        this.mBondedDevices.clear();
      }
      if (data == bluetoothAccess.BluetoothState.STATE_TURNING_ON ||
        data == bluetoothAccess.BluetoothState.STATE_BLE_TURNING_ON ||
        data == bluetoothAccess.BluetoothState.STATE_TURNING_OFF ||
        data == bluetoothAccess.BluetoothState.STATE_BLE_TURNING_OFF) {
        return;
      }
      this.onBluetoothStateChange(this.getBluetoothState());
    });
  };

  public subscribeBondStateChange = () => {
    try {
      bluetoothConnection.on('bondStateChange', (param) => {
        this.onBondStateChange(param)
      });
    } catch (err) {
      LogWithHa.error(log, `subscribeBondStateChange error:${err?.message}`,
        StatusBarExceptionCode.BLUETOOTH_FAIL, err, TAG);
    }
  };

  public subscribeA2dpSrc = () => {
    try {
      let a2dpSrc = bluetoothA2dp.createA2dpSrcProfile();
      a2dpSrc.on('connectionStateChange', this.onReceiveEvent(BlueToothProtocol.A2DP_SRC));
    } catch (err) {
      LogWithHa.error(log, `subscribeA2dpSrc error:${err?.message}`, StatusBarExceptionCode.BLUETOOTH_FAIL, err, TAG);
    }
  };

  public subscribeHfpAg = () => {
    try {
      let hfpAg = bluetoothHfp.createHfpAgProfile();
      hfpAg.on('connectionStateChange', this.onReceiveEvent(BlueToothProtocol.HFP_AG));
    } catch (err) {
      LogWithHa.error(log, `subscribeHfpAg error:${err?.message}`, StatusBarExceptionCode.BLUETOOTH_FAIL, err, TAG);
    }
  };

  public subscribeHidHost = () => {
    try {
      let hidHost = bluetoothHid.createHidHostProfile();
      hidHost.on('connectionStateChange', this.onReceiveEvent(BlueToothProtocol.HID_HOST));
    } catch (err) {
      LogWithHa.error(log, `subscribeHidHost error:${err?.message}`, StatusBarExceptionCode.BLUETOOTH_FAIL, err, TAG);
    }
  };

  updateIcon() {
    this.getViewData().isSymbolIcon = true;
    this.getViewData().icon = $r('sys.symbol.bluetooth');
  }

  decorateStyle(style: ToggleStyle, scene: ToggleScene): ToggleStyle {
    if (scene === ToggleScene.PHONE || scene === ToggleScene.SINGLE_FOLD_OUTER_SCREEN) {
      style = new WifiDecorator().decorateEventHandler(style);
    }
    return style;
  }

  notifyDeviceInfoChange(data: BluetoothData) {
    this.mBluetoothData = data;
  }

  onStart(): void {
    super.onStart();
    log.showInfo('onStart');
    InnerEventUtil.on(StatusBarTypeChangeEvent, this.onStatusBarTypeChangeEvent);
    InnerEventUtil.produceOn(SpecialIconEvent, this.handleSpecialEvent);
    if (DeviceHelper.isEmulator()) {
      log.showInfo('Disable the Bluetooth on the simulator');
      this.getViewData().isUnavailable = true;
      return;
    }
    this.updateDisableState();
    this.registerBtDeviceInfoCallback(this);
    // 监听蓝牙设备连接和设备电量
    this.listenConnectStatusAndBattery();
    try {
      sRegisterAPIProtector.run(TAG, 'BluetoothStateChange', this.subscribeBluetoothStateChange);
      this.onBluetoothStateChange(this.getBluetoothState());
      sRegisterAPIProtector.run(TAG, 'BondStateChange', this.subscribeBondStateChange);

      // 订阅监听蓝牙名字变化
      this.createSubscribeBluetoothName();
      // 监听蓝牙设备连接
      sRegisterAPIProtector.run(TAG, 'a2dpSrc connection', this.subscribeA2dpSrc);
      sRegisterAPIProtector.run(TAG, 'hfpAg connection', this.subscribeHfpAg);
      sRegisterAPIProtector.run(TAG, 'hidHost connection', this.subscribeHidHost);
    } catch (error) {
      LogWithHa.error(log, 'bluetoothManager register state error' + error?.message,
        StatusBarExceptionCode.BLUETOOTH_FAIL, error, TAG);
    }
    this.initModeChangeSwitchEvent();

    // 检查是否有蓝牙设备已连接
    this.blueToothCheckConnectedDevice();
  }

  /**
   * 监听蓝牙连接状态和连接设备的电量
   */
  private async listenConnectStatusAndBattery() {
    // 系统公共事件注册
    const SYSTEM_SUBSCRIBE_INFO: commonEvtMgr.CommonEventSubscribeInfo = {
      events: [
        EVENT_BATTERY_VALUE_UPDATE
      ]
    };
    try {
      this.batterySubscribe = await commonEvtMgr.createSubscriber(SYSTEM_SUBSCRIBE_INFO);
      commonEvtMgr.subscribe(this.batterySubscribe, (err, data) => {
        // 处理电量事件
        if (err && err.code !== 0) {
          LogWithHa.error(log, `Can't handle common event, err: ${err?.message}`,
            StatusBarExceptionCode.BLUETOOTH_FAIL, err, TAG);
          return;
        }
        log.showWarn(`listenBattery, event: ${data.event}` + `batteryLevel: ${data.parameters?.batteryLevel}`);
        if (data.event === EVENT_BATTERY_VALUE_UPDATE) {
          // 更新电量, 默认:-1
          this.mBluetoothData.batteryValue = data.parameters?.batteryLevel ?? -1;
          this.updatePluginWidthChangeEvent();
          log.showInfo(`listenConnectStatusAndBattery, batteryLeve: ${data.parameters?.batteryLevel}`);
        }
      });
    } catch (e) {
      LogWithHa.error(log, `subscribe bluetooth battery error: ${e?.message}`,
        StatusBarExceptionCode.BLUETOOTH_FAIL, e, TAG)
    }
    // 自定义公共事件注册
    const SUBSCRIBE_INFO: commonEvtMgr.CommonEventSubscribeInfo = {
      events: [
        EVENT_CONNECT_STATUS
      ],
      publisherPermission: PERMISSION_CONNECT
    };
    try {
      this.connectStatusSubscribe = await commonEvtMgr.createSubscriber(SUBSCRIBE_INFO);
      commonEvtMgr.subscribe(this.connectStatusSubscribe, (err, data) => {
        // 处理蓝牙连接、电量事件
        if (err && err.code !== 0) {
          LogWithHa.error(log, `Can't handle common event, err: ${err.message}`,
            StatusBarExceptionCode.BLUETOOTH_FAIL, err, TAG);
          return;
        }
        log.showWarn(`listenConnectStatus, event: ${data.event}` + `state: ${data.parameters?.state}`);
        if (data.event === EVENT_CONNECT_STATUS) {
          // 连接状态, 1:建连成功, 3:断连
          this.mBluetoothData.isConnected = data.parameters?.state === 1;
          this.updatePluginWidthChangeEvent();
          this.handleStateByTypeAndConnected(this.statusBarType, this.mBluetoothData.isConnected, this.getViewData().isOn);
        }
      });
    } catch (e) {
      LogWithHa.error(log, `subscribe bluetooth connect status: ${e?.message}}`,
        StatusBarExceptionCode.BLUETOOTH_FAIL, e, TAG)
    }
  }

  private onStatusBarTypeChangeEvent = (event: StatusBarTypeChangeEvent) => {
    this.statusBarType = event.statusBarType;
    this.handleStateByTypeAndConnected(this.statusBarType, this.mBluetoothData.isConnected, this.getViewData().isOn);
  }

  private handleSpecialEvent = () => {
    return this.specialEvent;
  }


  onStop(): void {
    super.onStop();
    InnerEventUtil.off(StatusBarTypeChangeEvent, this.onStatusBarTypeChangeEvent);
    InnerEventUtil.off(SpecialIconEvent, this.handleSpecialEvent);
    try {
      if (this.mSubscriber) {
        commonEvtMgr.unsubscribe(this.mSubscriber);
        this.mSubscriber = null;
      }
      this.unregisterBtDeviceInfoCallback(this);
      log.showInfo('onStop');
      this.bluetoothControllerEventMgr.offAll();
      bluetoothAccess.off('stateChange');
      bluetoothConnection.off('bondStateChange');
      if (this.batterySubscribe) {
        commonEvtMgr.unsubscribe(this.batterySubscribe);
        this.batterySubscribe = null;
      }
    } catch (error) {
      LogWithHa.error(log, 'bluetoothManager unRegister state error' + error?.message,
        StatusBarExceptionCode.BLUETOOTH_FAIL, error, TAG);
    }
    try {
      if (this.connectStatusSubscribe) {
        commonEvtMgr.unsubscribe(this.connectStatusSubscribe);
        this.connectStatusSubscribe = null;
      }
    } catch (error) {
      LogWithHa.error(log, 'bluetoothManager unRegister state error' + error?.message,
        StatusBarExceptionCode.BLUETOOTH_FAIL, error, TAG);
    }
  }

  private blueToothCheckConnectedDevice(): void {
    try {
      if (this.getViewData().isOn) {
        let a2dpSrc = a2dp.createA2dpSrcProfile();
        let hfpAgSrc = hfp.createHfpAgProfile();
        let hidHostSrc = hid.createHidHostProfile();
        this.protocolCheckConnectedDevice(a2dpSrc, BlueToothProtocol.A2DP_SRC);
        this.protocolCheckConnectedDevice(hfpAgSrc, BlueToothProtocol.HFP_AG);
        this.protocolCheckConnectedDevice(hidHostSrc, BlueToothProtocol.HID_HOST);
      }
    } catch (err) {
      LogWithHa.error(log, `onStart error:${err?.message}`, StatusBarExceptionCode.BLUETOOTH_FAIL, err, TAG);
    }
  }

  addBondedDevice(protocol: BlueToothProtocol, deviceId: string): void {
    if (deviceId) {
      if (this.mBondedDevices.get(deviceId) === undefined) {
        this.mBondedDevices.set(deviceId, BluetoothDevice.createDevice(deviceId));
      }
      this.mBondedDevices.get(deviceId)?.statusMap.set(protocol, true);
    }
  }

  private protocolCheckConnectedDevice(protocolProfile: baseProfile.BaseProfile, protocol: BlueToothProtocol): boolean {
    try {
      if (protocolProfile === null || protocolProfile === undefined) {
        return false;
      }
      let connectedDevices: string[] = protocolProfile.getConnectedDevices();
      if (connectedDevices === null || connectedDevices === undefined) {
        return false;
      }
      log.showInfo('Number of connected devices: ' + connectedDevices.length);
      connectedDevices.forEach(deviceId => {
        this.addBondedDevice(protocol, deviceId);
      });
      if (connectedDevices.length > 0) {
        let deviceId: string = connectedDevices[0];
        this.getViewData().label = bluetoothConnection.getRemoteDeviceName(deviceId);
        log.showInfo('mBluetoothData.deviceName: ' + this.getViewData().label)
        this.mBluetoothData.isConnected = true;
        this.updatePluginWidthChangeEvent();
        this.handleStateByTypeAndConnected(this.statusBarType, this.mBluetoothData.isConnected, this.getViewData().isOn);
        this.mBluetoothId = deviceId;
        return true;
      }
    } catch (error) {
      LogWithHa.error(log, 'Get connected devices error', StatusBarExceptionCode.BLUETOOTH_FAIL, error, TAG);
    }
    return false;
  }

  private createSubscribeBluetoothName(): void {
    try {
      commonEvtMgr.createSubscriber(this.SYSTEM_COMMON_EVENTS).then((subscriber) => {
        log.showInfo('init createSubscriber end');
        this.mSubscriber = subscriber;
        this.subscribeBluetoothName(subscriber);
      });
    } catch (error) {
      LogWithHa.error(log, 'createSubscriber error', StatusBarExceptionCode.BLUETOOTH_FAIL, error, TAG);
    }
  }

  private subscribeBluetoothName(subscriber: CommonEventSubscriber) {
    try {
      commonEvtMgr.subscribe(subscriber, (err: object | undefined, data: CommonEventData) => {
        if (err) {
          log.error(`Can't handle common event, err: ${err}`);
          return;
        }
        log.showInfo(`receive event data:${data?.event}`);
        this.handleBluetoothNameEvent(data);
      });
    } catch (error) {
      LogWithHa.error(log, 'subscribe error', StatusBarExceptionCode.BLUETOOTH_FAIL, error, TAG);
    }
  }

  private handleBluetoothNameEvent(data: CommonEventData): void {
    let deviceAddr: string = data?.parameters?.deviceAddr;
    if (this.mBluetoothData.isConnected && this.mBluetoothId === deviceAddr) {
      this.getViewData().label = data?.parameters?.remoteName;
      log.showInfo('mBluetoothData.deviceName: ' + this.getViewData().label)
    }
    if (this.mBondedDevices.has(deviceAddr)) {
      this.mBondedDevices.get(deviceAddr)?.updateDevice();
    }
  }

  initModeChangeSwitchEvent(): void {
    // 飞行模式开关
    let airplaneMode: ToggleViewData | undefined = AppStorage.get('AirplaneModel_AirplaneStatus');
    this.airplaneStatus = airplaneMode ? airplaneMode.isOn : false;
    this.bluetoothControllerEventMgr.on(AirplaneStateEvent, this.onAirplaneStateChange);
    log.showInfo('onstart initModeChangeSwitchEvent data: ' + this.airplaneStatus);

    // 互联互通服务开关
    this.multiDeviceCollaborationSwitch = DataShareUtils.getSettingsValueSync(
      SettingsKeyConstants.MULTI_DEVICE_COLLABORATION_SERVICE_SWITCH,
      SettingsConstants.MULTI_DEVICE_COLLABORATION_SERVICE_SWITCH_DEFAULT) ===
      SettingsConstants.CELLULAR_DATA_ENABLE_DEFAULT;
    this.bluetoothControllerEventMgr.on(MultiDeviceCollaborationServiceEnableEvent,
      this.onMultiDeviceCollaborationSwitchChange);
    log.showInfo('onstart multiDeviceCollaborationSwitch data: ' + this.multiDeviceCollaborationSwitch);
  }

  /**
   * 蓝牙图标标示
   */
  getSbPluginSlot(): string {
    return PluginSlot.SLOT_STATUS_BLE;
  }

  onReceiveEvent(protocol: BlueToothProtocol): (param: StateChangeParam) => void {
    return (param: StateChangeParam) => {
      this.onReceiveEventImpl(param, protocol);
    };
  }

  onReceiveEventImpl(param: StateChangeParam, protocol: BlueToothProtocol): void {
    log.showInfo(`enter onReceiveEventImpl, current protocol: ${protocol}, current state: ${param.state}`);
    if ((param.state !== bluetoothConstant.ProfileConnectionState.STATE_DISCONNECTED) &&
      (param.state !== bluetoothConstant.ProfileConnectionState.STATE_CONNECTED)) {
      log.showInfo(`connectionStateChange, undeal state: ${param.state}`);
      return;
    }
    if (this.mBluetoothState === BlueToothState.STATE_BLE_ON &&
      param.state === bluetoothConstant.ProfileConnectionState.STATE_CONNECTED) {
      log.showInfo(`curState is STATE_BLE_ON, undeal STATE_CONNECTED state`);
      return;
    }
    this.updateBTProtocolState(param, protocol);
    let deviceId = param.deviceId;
    log.showInfo(`current protocol connect state: ${this.mBondedDevices.get(deviceId)?.statusMap.get(protocol)}`);
    if (this.mBondedDevices.get(deviceId)?.getBlueToothConnState()) {
      let device = BluetoothDevice.createDevice(deviceId);
      this.mBluetoothState = BlueToothState.STATE_ON;
      this.getViewData().isOn = true;
      this.mBluetoothData.isConnected = (this.mBondedDevices.get(deviceId)?.statusMap.get(protocol)) as boolean;
      this.mBluetoothData.deviceName = device?.deviceName;
      this.handleStateByTypeAndConnected(this.statusBarType, this.mBluetoothData.isConnected, this.getViewData().isOn);
      this.getViewData().label = device?.deviceName;
      this.updateIcon();
      this.mBluetoothId = deviceId;
    } else {
      this.setBluetoothDataStatus();
      this.getViewData().label = DEFAULT_NAME;
      this.mBluetoothId = '';
      this.mBondedDevices.forEach(device => {
        if (device.getBlueToothConnState()) {
          this.getViewData().label = device.deviceName;
          this.mBluetoothId = device.deviceId;
          return;
        }
      });
    }
    this.notifyBtDeviceInfoChange(this.mBluetoothData);
    log.showInfo(`connectionStateChange, state: ${param.state}, devices: ${this.mBondedDevices?.size}, deviceName: ${this.getViewData().label}`);
  }

  updateBTProtocolState(param: StateChangeParam, protocol: BlueToothProtocol): void {
    if (param.state === bluetoothConstant.ProfileConnectionState.STATE_CONNECTED) {
      if (param.deviceId) {
        if (this.mBondedDevices.get(param.deviceId) === undefined) {
          this.mBondedDevices.set(param.deviceId, BluetoothDevice.createDevice(param.deviceId));
        }
        this.mBondedDevices.get(param.deviceId)?.statusMap.set(protocol, true);
      }
    } else if (param.state === bluetoothConstant.ProfileConnectionState.STATE_DISCONNECTED) {
      this.mBondedDevices.get(param.deviceId)?.statusMap.set(protocol, false);
    }
  }

  onBondStateChange(param: BondStateParam): void {
    let deviceId = param.deviceId;
    if (param.state !== bluetoothConnection.BondState.BOND_STATE_BONDED) {
      this.mBondedDevices.delete(deviceId);
      this.setBluetoothDataStatus();
    }
    if (param.state === bluetoothConnection.BondState.BOND_STATE_BONDED && !this.mBondedDevices.has(deviceId)) {
      this.mBondedDevices.set(deviceId, BluetoothDevice.createDevice(deviceId));
      this.mBluetoothState = BlueToothState.STATE_ON;
      this.getViewData().isOn = true;
      this.handleStateByTypeAndConnected(this.statusBarType, this.mBluetoothData.isConnected, this.getViewData().isOn);
      this.updateIcon();
    }
    this.notifyBtDeviceInfoChange(this.mBluetoothData)
    log.showInfo(`onBondStateChange, devices: ${this.mBondedDevices?.size}`);
  }

  setBluetoothDataStatus(): void {
    try {
      this.mBluetoothState = this.getBluetoothState();
      this.getViewData().isOn = this.mBluetoothState === BlueToothState.STATE_ON;
      this.updateIcon();
      if (!this.getViewData().isOn) {
        this.mBluetoothData.isConnected = false;
        this.updatePluginWidthChangeEvent();
      }
      this.handleStateByTypeAndConnected(this.statusBarType, this.mBluetoothData.isConnected, this.getViewData().isOn);
      log.showInfo(`setBluetoothDataStatus result: ${this.getViewData().isOn},${this.mBluetoothData.isConnected}`);
    } catch (error) {
      // 如果错误码是2900001，则表示蓝牙服务已停止……
      LogWithHa.error(log, 'handleUpdateState error:' + error?.message,
        StatusBarExceptionCode.BLUETOOTH_FAIL, error, TAG);
      if (error === BLUETOOTH_SERVICE_STOP) {
        this.mBluetoothState = BlueToothState.STATE_OFF;
        this.getViewData().isOn = false;
        this.handleStateByTypeAndConnected(this.statusBarType, this.mBluetoothData.isConnected, this.getViewData().isOn);
        this.updateIcon();
      }
    }
  }

  onBluetoothStateChange(state: BlueToothState) {
    let curState = this.mBluetoothState;
    log.showInfo(`onBluetoothStateChange iswaitingDone: ${this.isWaitingLastActionDone}  | State: ${curState} | ${state}`);
    if (state === BlueToothState.STATE_UNKNOWN) {
      log.showInfo(`onBluetoothStateChange return  ${curState} | ${state}`);
      return;
    }
    // 状态回调打点
    ControlCenterHiSysEventUtil.reportQuickToggleTristateMode({
      TOGGLE_NAME: FASlotName.BLUETOOTH,
      CURRENT_STATE: state,
      TIMESTAMP: this.isWaitingLastActionDone ? DropDownPanelManager.getLastDropdownTime().toString() : undefined
    });
    //设置界面蓝牙状态切换，改变图标状态
    let status: boolean = state === BlueToothState.STATE_ON;
    if (!this.isWaitingLastActionDone && this.getViewData().isOn !== status) {
      log.showInfo(`onBluetoothStateChange changestatus  ${curState} | ${state} | ${status}`);
      this.mBluetoothState = state;
      curState = state;
      this.getViewData().isOn = status;
      this.handleStateByTypeAndConnected(this.statusBarType, this.mBluetoothData.isConnected, this.getViewData().isOn);
      this.updateIcon();
    }
    this.handleUpdateState();
    this.handleStateByTypeAndConnected(this.statusBarType, this.mBluetoothData.isConnected, status);
    //底层返回状态和图标状态不符，改变底层状态
    if (this.isWaitingLastActionDone && this.getViewData().isOn != status) {
      log.showInfo('onBluetoothStateChange mBluetoothData status !== current');
      this.switchBluetoothStatus(this.getViewData().isOn);
      this.isWaitingLastActionDone = false;
      return;
    }
    this.isWaitingLastActionDone = false;
  }

  handleUpdateState(): void {
    if (this.isClickOpen && this.getViewData().isOn) {
      this.setBluetoothScanMode();
      this.isClickOpen = false;
    }
    if (this.getViewData().isOn && this.mBondedDevices.size > 0) {
      let key: string | undefined = Array.from(this.mBondedDevices.keys()).pop();
      if (key) {
        let lastDevice: BluetoothDevice | undefined = this.mBondedDevices.get(key);
        lastDevice?.updateDevice();
      }
    } else {
      this.getViewData().label = DEFAULT_NAME;
    }
    log.showInfo(`handleUpdateState, status: ${this.mBluetoothData.isConnected},${this.getViewData().isOn},${this.getViewData().label}`);
  }

  /**
   * 蓝牙显隐受下拉和连接态控制
   */
  private handleStateByTypeAndConnected = (statusbarType: StatusBarType, isConnected: boolean, status: boolean) => {
    // 未连接态且非下拉不显示，其余情况受控制中心开关控制
    log.showInfo(`handleStateByTypeAndConnected change, isConnected: ${isConnected}, status: ${status}`);
    this.handleStatusBarState(status);
    this.specialEvent.isCanShowInLauncherStatusBar = isConnected;
    EvtBus.post(SpecialIconEvent, this.specialEvent);
  }

  /**
   * 控制状态栏图标显示与隐藏，与控制中心逻辑解耦
   * @param newState
   */
  private handleStatusBarState(newState: boolean): void {
    let oldState = this.sbPluginRequest.isVisible();
    if (oldState !== newState) {
      log.showInfo(`status bar status change, newState: ${newState}, oldState: ${oldState}`);
      // 发送事件，触发PluginRootComponent组件中的状态更新，进而统一控制整个图标的显示与隐藏。
      this.sbPluginRequest.setIsVisible(newState);
      EvtBus.post(PluginRequestEvent, this.sbPluginRequest);
    }
  }

  private setBluetoothScanMode(): void {
    try {
      bluetoothConnection.setBluetoothScanMode(
        bluetoothConnection.ScanMode.SCAN_MODE_CONNECTABLE_GENERAL_DISCOVERABLE, 0);
    } catch (error) {
      LogWithHa.error(log, 'setBluetoothScanMode error' + error?.message,
        StatusBarExceptionCode.BLUETOOTH_FAIL, error, TAG);
    }
  }


  getData(): BluetoothData {
    return this.mBluetoothData;
  }

  isAvailable(): boolean {
    return true;
  }

  /**
   * 更新快捷开关的置灰状态
   */
  public updateDisableState(): void {
    if (DeviceHelper.isEmulator() || !EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_BLUETOOTH_CONFIG)) {
      this.getViewData().isUnavailable = true;
      return;
    }
    this.getViewData().isUnavailable = false;
  }

  switchBluetoothStatus(isOn: boolean): void {
    log.showInfo('switchBluetoothStatus');
    try {
      taskpool.execute(switchBluetooth, isOn, this.multiDeviceCollaborationSwitch, this.airplaneStatus)
        .then((result: Object) => {
          log.showError(`switchBluetooth to ${isOn}, result:${result} -- ${this.multiDeviceCollaborationSwitch}`);
          if (result as number !== 0) {
            this.isWaitingLastActionDone = false;
          }
        }).catch((err: BusinessError) => {
          LogWithHa.error(log, `taskpool.execute error`, StatusBarExceptionCode.BLUETOOTH_FAIL, err, TAG);
        });
    } catch (error) {
      log.error('switchBluetoothStatus error', error);
    }
    return;
  }

  getNextState(curState: BlueToothState): BlueToothState {
    if (!this.multiDeviceCollaborationSwitch || this.airplaneStatus) {
      return curState !== BlueToothState.STATE_ON ? BlueToothState.STATE_ON : BlueToothState.STATE_OFF;
    }
    return curState !== BlueToothState.STATE_ON ? BlueToothState.STATE_ON : BlueToothState.STATE_BLE_ON;
  }

  handleOneClick(): void {
    if (this.getViewData().isUnavailable) {
      log.showWarn('bluetooth disabled');
      if (!EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_BLUETOOTH_CONFIG)) {
        EdmAdminManager.instance.showToastWhenInoperable();
      }
      return;
    }
    // 防盗值守判断
    if (this.getViewData().isOn && AntiTheftUtil.antiTheftConfirm(GlobalContext.getContext())) {
      const resource: Resource = $r('app.string.control_center_anti_theft_for_toggle');
      AntiTheftUtil.antiTheftShowToast(resource);
      log.showWarn('anti-theft, click disabled');
      return;
    }
    let curStatus = this.getViewData().isOn;
    let nextState = this.getNextState(this.mBluetoothState);
    log.showInfo(`handleClick, status: ${curStatus}, ${this.mBluetoothState}, ${nextState}`);
    // click打点
    ControlCenterHiSysEventUtil.reportQuickToggleTristateModeClick({
      TOGGLE_NAME: FASlotName.BLUETOOTH,
      CURRENT_STATE: this.mBluetoothState,
      NEXT_STATE: nextState,
      TIMESTAMP: DropDownPanelManager.getLastDropdownTime().toString(),
      SCREENTYPE: 0,
    });
    this.mBluetoothState = nextState;
    this.getViewData().isOn = !curStatus;
    this.handleStateByTypeAndConnected(this.statusBarType, this.mBluetoothData.isConnected, this.getViewData().isOn);
    this.updateIcon();
    curStatus = this.getViewData().isOn;
    log.showInfo(`handleClick, this.isWaitingLastActionDone: ${this.isWaitingLastActionDone} ${this.mBluetoothState} ,${curStatus}`);
    if (!this.isWaitingLastActionDone) {
      this.isWaitingLastActionDone = true;
      this.handleCallbackTimeout();
      this.switchBluetoothStatus(curStatus);
    }
    if (!curStatus) {
      this.mBluetoothData.isConnected = false;
      this.updatePluginWidthChangeEvent();
      this.handleStateByTypeAndConnected(this.statusBarType, this.mBluetoothData.isConnected, this.getViewData().isOn);
      this.mBondedDevices.clear();
    }
    log.showInfo(`handleClick end, mBluetoothData: ${this.mBluetoothData.isConnected}`);
  }

  openDetailPage(): void {
    if (this.getViewData().isUnavailable) {
      log.showWarn('bluetooth disabled');
      if (!EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_BLUETOOTH_CONFIG)) {
        EdmAdminManager.instance.showToastWhenInoperable();
      }
      return;
    }
    log.showInfo('handleLongClick');
    if (DeviceHelper.isPC()) {
      log.showDebug('handleLongClick: long click on pc');
      //由于PC设置应用不开源，故屏蔽PC控制中心点击蓝牙图标拉起蓝牙设置面板的功能
    } else {
      this.handleOnControlCenterWithScreenLockForUIE(
        (): void => this.showBluetoothWindow(FASlotName.BLUETOOTH_UI_EXTENSION), true);
    }
  }

  private handleCallbackTimeout(): void {
    if (this.callbackTimeoutTimeId !== -1) {
      clearTimeout(this.callbackTimeoutTimeId);
      this.callbackTimeoutTimeId = -1;
    }
    this.callbackTimeoutTimeId = setTimeout(() => {
      log.showInfo('reset wait action flag');
      this.isWaitingLastActionDone = false;
      this.callbackTimeoutTimeId = -1;
    }, ISWAIT_CLEAR_TIMEOUT);
  }

  private goBluetoothSetting(): void {
    EventManagerAdapter.startAbility(obtainStartAbilityWithWant({
      bundleName: ExtAppConstants.ABILITY_SETTINGS_BUNDLENAME,
      abilityName: ExtAppConstants.ABILITY_SETTINGS_ABILITYNAME,
      uri: 'bluetooth_entry',
      moduleName: this.mdName
    }
    ));
    HiDfxEventUtil.reportToggleClick(PluginSlot.SLOT_STATUS_BLE, 1);
  }

  private showBluetoothWindow(slot: string): void {
    log.showInfo(`showWifiSubWindow, slot${slot}`);
    HiDfxEventUtil.reportQuickToggleSubMenuClick(slot);
    performanceMonitor.begin('INTO_CC_SUB_BLUETOOTH_ANI', performanceMonitor.ActionType.LAST_UP);
    sToggleSubWindowController.showSubWindowByClickInfo(FASlotName.BLUETOOTH_UI_EXTENSION, {
      clickType: 'window',
      bundleName: 'com.ohos.settings',
      abilityName: 'BluetoothUIExtensionSettingsAbility',
      uiExtensionType: 'sys/commonUI',
      windowHeight: 398
    } as PluginClickInfo);
  }

  updatePluginWidthChangeEvent(): void {
    let width = 0;
    if (this.mBluetoothData.isConnected) {
      // 蓝牙已连接
      if (this.mBluetoothData.batteryValue === -1) {
        width = ResUtils.getNumberFromLength(this.style.staticBarBluetoothWidth);
      } else {
        width = ResUtils.getNumberFromLength(this.style.staticBarBluetoothBatteryWidth);
      }
    } else {
      // 蓝牙未连接
      width = ResUtils.getNumberFromLength(this.style.staticBarBluetoothWidth);
    }

    this.pluginWidthChangeEvent.setWidth(width);
    if (this.pluginWidthChangeEvent.getChangeDelta() !== 0) {
      EvtBus.post(PluginWidthChangeEvent, this.pluginWidthChangeEvent);
    }
  }
}

export interface BluetoothDeviceInfoCallback {
  notifyDeviceInfoChange(data: BluetoothData): void;
}

function switchBluetooth(isOn: boolean, multiDeviceCollaborationSwitch: boolean, airplaneStatus: boolean): number {
  'use concurrent';
  try {
    if (!isOn) {
      if (multiDeviceCollaborationSwitch && !airplaneStatus) {
        bluetoothAccess.restrictBluetooth();
      } else {
        bluetoothAccess.disableBluetooth();
      }
    } else {
      bluetoothAccess.enableBluetooth();
    }
    HiDfxEventUtil.reportToggleClick(PluginSlot.SLOT_STATUS_BLE, 0);
    return 0;
  } catch (err) {
    return err?.code;
  }
}

let sBluetoothController = SingletonHelper.getInstance(BluetoothController, TAG);
export default sBluetoothController as BluetoothController;