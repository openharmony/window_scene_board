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

// import fusionConnectivityExt from '@ohos.fusionConnectivityExt';
import lottie from '@ohos/lottie';
import { LogDomain, Logger, SingletonHelper } from '@ohos/basicutils';
import { FASlotName } from '@ohos/commonconstants';
import { DeviceHelper, GlobalContext, HiDfxEventUtil, PluginSlot } from '@ohos/frameworkwrapper';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { ToggleScene, ToggleStyle } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import commonEvtMgr from '@ohos.commonEventManager';
import { BusinessError, systemParameterEnhance } from '@kit.BasicServicesKit';
import lazy { PhoneFusionToggleOperation } from './PhoneFusionToggleOperation';
import lazy { PcFusionToggleOperation } from './PcFusionToggleOperation';
import bluetoothConstant from '@ohos.bluetooth.constant';
import bluetoothConnection from '@ohos.bluetooth.connection';
import bluetoothBaseProfile from '@ohos.bluetooth.baseProfile';
import { RegisterAPIProtector } from '@ohos/systemuicommon/src/main/ets/statusbar/RegisterAPIProtector';
import { ControlCenterHiSysEventUtil } from '@ohos/controlcentercommon/src/main/ets/hiSysEvent/ControlCenterHiSysEventUtil';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { EdmAdminManager } from '@ohos/systemuicommon/src/main/ets/manager/EdmAdminManager';
import { taskpool } from '@kit.ArkTS';
import bluetoothA2dp from '@ohos.bluetooth.a2dp';
import bluetoothHfp from '@ohos.bluetooth.hfp';
import bluetoothHid from '@ohos.bluetooth.hid';
import { a2dp, baseProfile, hfp, hid } from '@kit.ConnectivityKit';
import type { CommonEventSubscriber } from 'commonEvent/commonEventSubscriber';
import type { CommonEventData } from 'commonEvent/commonEventData';
/*import nearlinkDevice from '@ohos.nearlink.remoteDevice';
import manager from '@hms.nearlink.manager';
import constant from '@hms.nearlink.constant';*/
import { WifiDecorator } from '@ohos/controlcentercommon/src/main/ets/toggle/decorator/WifiDecorator';
import { AntiTheftUtil } from '@ohos/systemuicommon/src/main/ets/utils/AntiTheftUtil';
import Constants, { BlueToothProtocol, BlueToothState, BondedDevice } from '../../common/Constants';

type BondStateParam = bluetoothConnection.BondStateParam;
type StateChangeParam = bluetoothBaseProfile.StateChangeParam;

const TAG = 'Ctrl.BluetoothNearLinkFusionController';
const DEFAULT_NAME = $r('app.string.control_center_complex_toggle_nearlink_bluetooth_title');
const DEFAULT_BLUETOOTH_NAME = $r('app.string.control_center_complex_toggle_bluetooth_title');
const DEFAULT_NEARLINK_NAME = $r('app.string.control_center_complex_toggle_nearlink_title');
const log: Logger = Logger.getLogHelper(LogDomain.CC);

const NEAR_LINK_CCM_CONFIG = 'const.nearlink.enable';
const PERSIST_EDM_NEAR_LINK_CONFIG = 'persist.edm.near_link_disallowed';
const sRegisterAPIProtector: RegisterAPIProtector = RegisterAPIProtector.get();
const ISWAIT_CLEAR_TIMEOUT: number = 5000;
const PERSIST_EDM_BLUETOOTH_CONFIG = 'persist.edm.prohibit_bluetooth';

export class BluetoothNearLinkFusionController extends ToggleBaseViewModel {
  private fusionDeviceInfo = new Set<FusionDeviceInfoCallback>();
  private isPC = DeviceHelper.isPC();
  private toggleOperation: ToggleOperation;
  private isWaitingLastActionDone: boolean = false;
  private mSubscriber: CommonEventSubscriber | null = null;
  private mBondedDevices: Map<string, BondedDevice> = new Map();
  private mConnectedData: ConnectedData = new ConnectedData();
  private mBluetoothState: BlueToothState = BlueToothState.STATE_UNKNOWN;
  private callbackTimeoutTimeId: number = -1;
  private isClickOpen: boolean = false;
  private isNearLinkEnable: boolean = true;
  private isBluetoothMode: boolean = false;
  private isNearLinkMode: boolean = false;

  private readonly SYSTEM_COMMON_EVENTS: commonEvtMgr.CommonEventSubscribeInfo = {
    events: [
      // 蓝牙名字变化
      commonEvtMgr.Support.COMMON_EVENT_BLUETOOTH_REMOTEDEVICE_NAME_UPDATE,
      // 星闪名称刷新
      Constants.NEARLINK_NAME_UPDATE_EVENT,
    ]
  };

  constructor() {
    super();
    this.getViewData().label = DEFAULT_NAME;
    this.getViewData().icon = $r('sys.symbol.nearlink');
    this.getViewData().isSymbolIcon = true;
    this.toggleOperation = this.isPC ?
      new PcFusionToggleOperation(this.getViewData(), this.records) :
      new PhoneFusionToggleOperation(this.getViewData(), this.records);
    this.onStart();
  }

  decorateStyle(style: ToggleStyle, scene: ToggleScene): ToggleStyle {
    if (scene === ToggleScene.PHONE || scene === ToggleScene.SINGLE_FOLD_OUTER_SCREEN) {
      style = new WifiDecorator().decorateEventHandler(style);
      style.toggleParam?.symbolFontWeight(FontWeight.Medium);
    }
    return style;
  }

  onStart(): void {
    super.onStart();
    if (DeviceHelper.isEmulator()) {
      log.showInfo(TAG, 'Disable the Bluetooth on the simulator');
      this.getViewData().isUnavailable = true;
      return;
    }
    this.isNearLinkEnable = BluetoothNearLinkFusionController.isNearLinkAvailable();
    log.showInfo(TAG, `onStart isNearLinkEnable: ${this.isNearLinkEnable}`);
    if (!this.isNearLinkEnable) {
      this.updateLabel();
      this.updateIcon();
    }
    this.registerBtDeviceInfoCallback(this);
    try {
      sRegisterAPIProtector.run(TAG, 'BluetoothStateChange', this.subscribeSwitchStateChange);
      this.onSwitchStateChange(this.getSwitchState());
      sRegisterAPIProtector.run(TAG, 'BondStateChange', this.subscribeBondStateChange);

      // 订阅监听蓝牙名字变化
      this.createSubscribeBluetoothName();
      // 监听蓝牙设备连接
      sRegisterAPIProtector.run(TAG, 'a2dpSrc connection', this.subscribeA2dpSrc);
      sRegisterAPIProtector.run(TAG, 'hfpAg connection', this.subscribeHfpAg);
      sRegisterAPIProtector.run(TAG, 'hidHost connection', this.subscribeHidHost);
      // 星闪监听
      if (this.isNearLinkEnable) {
        sRegisterAPIProtector.run(TAG, 'nearlink connection', this.subscribeNearLink);
      }
    } catch (error) {
      log.showError(TAG, `bluetoothManager register state error:${error}`);
    }
    // 检查是否有蓝牙设备已连接
    this.blueToothOrNearLinkCheckConnectedDevice();
    this.updateDisableState();
  }

  onStop(): void {
    super.onStop();
    log.showInfo(TAG, 'onStop');
    try {
      if (this.mSubscriber) {
        commonEvtMgr.unsubscribe(this.mSubscriber);
        this.mSubscriber = null;
      }
      this.unregisterBtDeviceInfoCallback(this);
      bluetoothA2dp.createA2dpSrcProfile().off('connectionStateChange');
      bluetoothHfp.createHfpAgProfile().off('connectionStateChange');
      bluetoothHid.createHidHostProfile().off('connectionStateChange');
      // manager.off('connectionStateChange');
      // fusionConnectivityExt.off('stateChange');
      bluetoothConnection.off('bondStateChange');
    } catch (error) {
      log.showError(TAG, `bluetoothManager unRegister1 state error:${error}`);
    }
  }

  public initLottieData(): void {
    log.showInfo(TAG, `initLottieData this.isAlreadyLoadLottie=${this.isAlreadyLoadLottie}`);
    if (this.isAlreadyLoadLottie) {
      return;
    }
    this.isAlreadyLoadLottie = true;
    if (this.isNearLinkEnable) {
      this.loadLottieData(Constants.LOTTIE_DATA_NEAR2BLE_DARK, (value) => {
        this.records.near2ble = value;
      });
      this.loadLottieData(Constants.LOTTIE_DATA_BLE2NEAR_DARK, (value) => {
        this.records.ble2near = value;
      });
      this.loadLottieData(Constants.LOTTIE_DATA_FUSION_DARK, (value) => {
        this.records.fusion = value;
      });
    } else {
      this.loadLottieData(Constants.LOTTIE_DATA_CLOSE_DARK, (value) => {
        this.records.bleOff = value;
      });
      this.loadLottieData(Constants.LOTTIE_DATA_OPEN_DARK, (value) => {
        this.records.bleOn = value;
      });
    }
  }

  public matchLottieData(isDarkMode: boolean): object | null {
    if (this.isNearLinkEnable) {
      if (this.getViewData().isOn) {
        return this.isBluetoothMode ? this.records.near2ble : this.records.fusion;
      } else {
        return this.isBluetoothMode ? this.records.ble2near : this.records.fusion;
      }
    } else {
      return this.getViewData().isOn ? this.records.bleOff : this.records.bleOn;
    }
  }

  isLoadLottie(): boolean {
    return true;
  }

  isPersist(): boolean {
    return true;
  }

  isAvailable(): boolean {
    return true;
  }

  /**
   * Controller单例获取
   *
   * @returns BluetoothNearLinkFusionController
   */
  public static getInstance(): BluetoothNearLinkFusionController {
    return SingletonHelper.getInstance(BluetoothNearLinkFusionController, TAG);
  }

  private blueToothOrNearLinkCheckConnectedDevice(): void {
    try {
      if (this.getViewData().isOn) {
        let a2dpSrc = a2dp.createA2dpSrcProfile();
        let hfpAgSrc = hfp.createHfpAgProfile();
        let hidHostSrc = hid.createHidHostProfile();
        this.protocolCheckConnectedDevice(a2dpSrc, BlueToothProtocol.A2DP_SRC);
        this.protocolCheckConnectedDevice(hfpAgSrc, BlueToothProtocol.HFP_AG);
        this.protocolCheckConnectedDevice(hidHostSrc, BlueToothProtocol.HID_HOST);

        if (this.isNearLinkEnable) {
          // 星闪链接状态处理
          /*manager.getPairedDevices()?.forEach(deviceId => {
            let remoteDevice: nearlinkDevice.RemoteDevice = nearlinkDevice.createRemoteDevice(deviceId);
            if (remoteDevice.getConnectionState() === constant.ConnectionState.STATE_CONNECTED) {
              this.mBondedDevices.set(deviceId,
                BondedDevice.createDevice(deviceId, fusionConnectivityExt.DeviceMode.NEARLINK_MODE));
            }
          });*/
        }
        if (this.mBondedDevices.size > 0) {
          let deviceId: string = this.mBondedDevices.keys().next().value;
          this.getViewData().label = this.mBondedDevices.get(deviceId)?.deviceName;
          log.showInfo(TAG, `mBondedDevices.deviceName: ${this.getViewData().label}`)
          this.mConnectedData.isConnected = true;
          this.mConnectedData.deviceId = deviceId;
        }
      }
    } catch (err) {
      log.showError(TAG, `blueToothOrNearLinkCheckConnectedDevice error:${err}`);
    }
  }

  private registerBtDeviceInfoCallback(cb: FusionDeviceInfoCallback) {
    log.showInfo(TAG, `registerTintCallback`);
    this.fusionDeviceInfo.add(cb);
  }

  private unregisterBtDeviceInfoCallback(cb: FusionDeviceInfoCallback) {
    log.showInfo(TAG, `unregisterTintCallback`);
    this.fusionDeviceInfo.delete(cb);
  }

  private notifyBtDeviceInfoChange(data: ConnectedData) {
    this.fusionDeviceInfo.forEach((listener) => {
      listener.notifyDeviceInfoChange(data);
    })
  }

  getState(): number {
    return this.getViewData().isOn ? (this.isBluetoothMode ? 2 : 1) : 0;
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
      log.showInfo(TAG, 'Number of connected devices: ' + connectedDevices.length);
      connectedDevices.forEach(deviceId => {
        this.addBlueToothBondedDevice(protocol, deviceId);
      });
      if (connectedDevices.length > 0) {
        let deviceId: string = connectedDevices[0];
        this.getViewData().label = bluetoothConnection.getRemoteDeviceName(deviceId);
        log.showInfo(TAG, 'mBluetoothData.deviceName: ' + this.getViewData().label)
        this.mConnectedData.isConnected = true;
        this.mConnectedData.deviceId = deviceId;
        return true;
      }
    } catch (error) {
      log.showError(TAG, `Get connected devices error error:${error}`);
    }
    return false;
  }

  private addBlueToothBondedDevice(protocol: BlueToothProtocol, deviceId: string): void {
    if (deviceId) {
      if (this.mBondedDevices.get(deviceId) === undefined) {
        /*this.mBondedDevices.set(deviceId, BondedDevice.createDevice(deviceId,
          fusionConnectivityExt.DeviceMode.BLUETOOTH_MODE));*/
      }
      this.mBondedDevices.get(deviceId)?.statusMap.set(protocol, true);
    }
  }

  private createSubscribeBluetoothName(): void {
    try {
      commonEvtMgr.createSubscriber(this.SYSTEM_COMMON_EVENTS).then((subscriber) => {
        log.showInfo(TAG, 'init createSubscriber end');
        this.mSubscriber = subscriber;
        this.subscribeDeviceName(subscriber);
      });
    } catch (error) {
      log.showError(TAG, `createSubscriber error: ${error}`);
    }
  }

  private subscribeDeviceName(subscriber: CommonEventSubscriber) {
    try {
      commonEvtMgr.subscribe(subscriber, (err: object | undefined, data: CommonEventData) => {
        if (err) {
          log.error(TAG, `Can't handle common event, err: ${err}`);
          return;
        }
        log.showInfo(TAG, `receive event data:${data?.event}}`);
        if (data && data.event === commonEvtMgr.Support.COMMON_EVENT_BLUETOOTH_REMOTEDEVICE_NAME_UPDATE) {
          this.handleBluetoothNameEvent(data);
        } else if (data && data.event === Constants.NEARLINK_NAME_UPDATE_EVENT) {
          this.handleNearLinkNameEvent(data);
        }
      });
    } catch (error) {
      log.showError(TAG, `subscribe error ${error}`);
    }
  }

  private handleBluetoothNameEvent(data: CommonEventData): void {
    let deviceAddr: string = data?.parameters?.deviceAddr;
    log.showInfo(TAG, `handleBluetoothNameEvent mBluetoothData.deviceName: ${data?.parameters?.remoteName}  isConnected=${this.mConnectedData.isConnected}`)
    if (this.mConnectedData.isConnected && this.mConnectedData.deviceId === deviceAddr) {
      this.getViewData().label = data?.parameters?.remoteName;
      log.showInfo(TAG, `mBluetoothData.deviceName: ${this.getViewData().label}`)
    }
    if (this.mBondedDevices.has(deviceAddr) && this.getViewData().isOn) {
      this.mBondedDevices.get(deviceAddr)?.updateDevice();
    }
  }

  private handleNearLinkNameEvent(data: CommonEventData): void {
    log.showInfo(TAG, `handleNearLinkNameEvent isConnected=${this.mConnectedData.isConnected} isOn=${this.getViewData().isOn}`)
    // 由于当前DeviceId取值包含随机和真实ID，导致无法直接比对，先刷新当前已连接设备id
    if (this.getViewData().isOn) {
      this.mBondedDevices.forEach(device => {
        /*if (device.getDeviceConnState() && device.deviceMode === fusionConnectivityExt.DeviceMode.NEARLINK_MODE) {
          device.updateDevice();
        }*/
      });
      let deviceName = this.mBondedDevices.get(this.mConnectedData.deviceId)?.deviceName;
      this.getViewData().label = deviceName === Constants.DEFAULT_ERROR_NAME ? this.getViewData().label : deviceName;
      log.showInfo(TAG, `handleNearLinkNameEvent deviceName: ${this.getViewData().label}`)
    }
  }

  /**
   * 订阅合一开关状态回调
   */
  public subscribeSwitchStateChange = () => {
    /*fusionConnectivityExt.on('stateChange', (data: fusionConnectivityExt.FusionConnectivityExtState) => {
      this.onSwitchStateChange(data);
    });*/
  };

  /**
   * 订阅蓝牙设备绑定状态回调
   */
  public subscribeBondStateChange = () => {
    try {
      bluetoothConnection.on('bondStateChange', (param) => {
        this.onBondStateChange(param)
      });
    } catch (err) {
      log.showError(TAG, `subscribeBondStateChange error:${err}`);
    }
  };

  /**
   * 订阅蓝牙协议连接状态回调
   */
  public subscribeA2dpSrc = () => {
    try {
      let a2dpSrc = bluetoothA2dp.createA2dpSrcProfile();
      a2dpSrc.on('connectionStateChange', this.onReceiveEvent(BlueToothProtocol.A2DP_SRC));
    } catch (err) {
      log.showError(TAG, `subscribeA2dpSrc error:${err}`);
    }
  };

  /**
   * 订阅蓝牙协议连接状态回调
   */
  public subscribeHfpAg = () => {
    try {
      let hfpAg = bluetoothHfp.createHfpAgProfile();
      hfpAg.on('connectionStateChange', this.onReceiveEvent(BlueToothProtocol.HFP_AG));
    } catch (err) {
      log.showError(TAG, `subscribeHfpAg error:${err}`);
    }
  };

  /**
   * 订阅蓝牙协议连接状态回调
   */
  public subscribeHidHost = () => {
    try {
      let hidHost = bluetoothHid.createHidHostProfile();
      hidHost.on('connectionStateChange', this.onReceiveEvent(BlueToothProtocol.HID_HOST));
    } catch (err) {
      log.showError(TAG, `subscribeHidHost error:${err}`);
    }
  };

  /**
   * 订阅星闪连接状态回调
   */
  public subscribeNearLink = () => {
    try {
      /*manager.on('connectionStateChange', (connectionStateParam) => {
        log.showInfo(TAG, `connectionStateChange:state=${connectionStateParam?.state}`);
        if (connectionStateParam?.state === Constants.STATE_CONNECTED) {
          this.mBondedDevices.set(connectionStateParam?.address, BondedDevice.createDevice(
            connectionStateParam?.address, fusionConnectivityExt.DeviceMode.NEARLINK_MODE));
          this.getViewData().isOn = true;
          let deviceName = this.mBondedDevices.get(connectionStateParam?.address)?.deviceName;
          this.getViewData().label = deviceName === Constants.DEFAULT_ERROR_NAME ? this.getViewData().label : deviceName;
          log.showInfo(TAG, `connectionStateChange: label=${this.getViewData().label}**`);
          this.updateIcon();
          this.mConnectedData.deviceId = connectionStateParam?.address;
          this.mConnectedData.isConnected = true;
        }
        if (connectionStateParam?.state === Constants.STATE_DISCONNECTED) {
          this.mBondedDevices.delete(connectionStateParam?.address);
          this.getViewData().label = this.isNearLinkMode ? DEFAULT_NEARLINK_NAME :
            this.isNearLinkEnable && !this.isBluetoothMode ? DEFAULT_NAME : DEFAULT_BLUETOOTH_NAME;
          this.mConnectedData.deviceId = '';
          this.mConnectedData.isConnected = false;
          this.mBondedDevices.forEach(device => {
            if (device.getDeviceConnState()) {
              this.getViewData().label = device.deviceName === Constants.DEFAULT_ERROR_NAME ?
                this.getViewData().label : device.deviceName;
              this.mConnectedData.deviceId = device.deviceId;
              this.mConnectedData.isConnected = true;
              return;
            }
          });
        }
      });*/
    } catch (err) {
      log.showError(TAG, `connectionStateChange err, code: ${err?.code}, msg: ${err?.message}`);
    }
  }

  private onReceiveEvent(protocol: BlueToothProtocol): (param: StateChangeParam) => void {
    return (param: StateChangeParam) => {
      this.onReceiveEventImpl(param, protocol);
    };
  }

  private onReceiveEventImpl(param: StateChangeParam, protocol: BlueToothProtocol): void {
    log.showInfo(TAG, `enter onReceiveEventImpl, current protocol: ${protocol}, current state: ${param.state}`);
    if ((param.state !== bluetoothConstant.ProfileConnectionState.STATE_DISCONNECTED) &&
      (param.state !== bluetoothConstant.ProfileConnectionState.STATE_CONNECTED)) {
      log.showInfo(TAG, `connectionStateChange, undeal state: ${param.state}`);
      return;
    }
    if (this.mBluetoothState === BlueToothState.STATE_OFF &&
      param.state === bluetoothConstant.ProfileConnectionState.STATE_CONNECTED) {
      log.showInfo(TAG, `curState is STATE_BLE_ON, undeal STATE_CONNECTED state`);
      return;
    }
    this.updateBTProtocolState(param, protocol);
    let deviceId = param.deviceId;
    log.showInfo(TAG, `current protocol connect state: ${this.mBondedDevices.get(deviceId)?.statusMap.get(protocol)}`);
    if (this.mBondedDevices.get(deviceId)?.getDeviceConnState()) {
      let device = BondedDevice.createDevice(deviceId);
      this.mBluetoothState = BlueToothState.STATE_ON;
      this.getViewData().isOn = true;
      this.getViewData().label = device.deviceName === Constants.DEFAULT_ERROR_NAME ?
        this.getViewData().label : device.deviceName;
      this.updateIcon();
      this.mConnectedData.deviceId = deviceId;
      this.mConnectedData.isConnected = true;
    } else {
      this.getViewData().label = this.isNearLinkMode ? DEFAULT_NEARLINK_NAME :
        this.isNearLinkEnable && !this.isBluetoothMode ? DEFAULT_NAME : DEFAULT_BLUETOOTH_NAME;
      this.mConnectedData.deviceId = '';
      this.mConnectedData.isConnected = false;
      this.mBondedDevices.forEach(device => {
        if (device.getDeviceConnState()) {
          this.getViewData().label = device.deviceName === Constants.DEFAULT_ERROR_NAME ?
            this.getViewData().label : device.deviceName;
          this.mConnectedData.deviceId = device.deviceId;
          this.mConnectedData.isConnected = true;
          return;
        }
      });
    }
    this.notifyBtDeviceInfoChange(this.mConnectedData);
    log.showInfo(TAG, `connectionStateChange, state: ${param.state}, devices: ${this.mBondedDevices?.size}, deviceName: ${this.getViewData().label}`);
  }

  private onBondStateChange(param: BondStateParam): void {
    let deviceId = param.deviceId;
    if (param.state !== bluetoothConnection.BondState.BOND_STATE_BONDED) {
      this.mBondedDevices.delete(deviceId);
    }
    if (param.state === bluetoothConnection.BondState.BOND_STATE_BONDED && !this.mBondedDevices.has(deviceId)) {
      this.mBondedDevices.set(deviceId, BondedDevice.createDevice(deviceId));
      this.mBluetoothState = BlueToothState.STATE_ON;
      this.getViewData().isOn = true;
      this.updateIcon();
    }
    this.notifyBtDeviceInfoChange(this.mConnectedData)
    log.showInfo(TAG, `onBondStateChange, devices: ${this.mBondedDevices?.size}`);
  }

  private updateBTProtocolState(param: StateChangeParam, protocol: BlueToothProtocol): void {
    if (param.state === bluetoothConstant.ProfileConnectionState.STATE_CONNECTED) {
      if (param.deviceId) {
        if (this.mBondedDevices.get(param.deviceId) === undefined) {
          this.mBondedDevices.set(param.deviceId, BondedDevice.createDevice(param.deviceId));
        }
        this.mBondedDevices.get(param.deviceId)?.statusMap.set(protocol, true);
      }
    } else if (param.state === bluetoothConstant.ProfileConnectionState.STATE_DISCONNECTED) {
      this.mBondedDevices.get(param.deviceId)?.statusMap.set(protocol, false);
    }
  }

  private onSwitchStateChange(state: ESObject) {
    log.showInfo(TAG, `onSwitchStateChange iswaitingDone: ${this.isWaitingLastActionDone} | State:  ${state} | ison: ${this.getViewData().isOn}`);
    // 状态回调打点
    ControlCenterHiSysEventUtil.reportQuickToggleTristateMode({
      TOGGLE_NAME: FASlotName.BLUETOOTH,
      CURRENT_STATE: state,
      TIMESTAMP: this.isWaitingLastActionDone ? DropDownPanelManager.getLastDropdownTime().toString() : undefined
    });
    //设置界面开关状态切换，改变图标状态
    /*let status: boolean = state !== fusionConnectivityExt.FusionConnectivityExtState.STATE_OFF;
    let isBluetoothMode = state === fusionConnectivityExt.FusionConnectivityExtState.STATE_BLUETOOTH_ON;
    this.isNearLinkMode = state === fusionConnectivityExt.FusionConnectivityExtState.STATE_NEARLINK_ON;
    this.mBluetoothState = isBluetoothMode || state === fusionConnectivityExt.FusionConnectivityExtState.STATE_ON ?
      BlueToothState.STATE_ON : BlueToothState.STATE_OFF;
    log.showInfo(TAG, `onSwitchStateChange changestatus ${state} | ${status}`);
    if (!this.isWaitingLastActionDone && this.getViewData().isOn !== status) {
      this.getViewData().isOn = status;
      this.updateIcon();
    }
    this.clearBondedDevices(state);
    if (isBluetoothMode !== this.isBluetoothMode) {
      this.isBluetoothMode = isBluetoothMode;
      this.updateIcon();
    }
    this.updateLabel();
    this.handleUpdateState();
    //底层返回状态和图标状态不符，改变底层状态
    if (this.isWaitingLastActionDone && this.getViewData().isOn != status) {
      log.showInfo(TAG, 'onSwitchStateChange change status !== current');
      this.switchIntegrationStatus(this.getViewData().isOn);
      this.isWaitingLastActionDone = false;
      return;
    }
    this.isWaitingLastActionDone = false;*/
  }

  /**
   * 根据当前开关回调状态，清除对应设备缓存
   * @param state 开关回调
   */
  private clearBondedDevices(state: ESObject) {
    log.showInfo(TAG, `clearBondedDevices state=${state} deviceSize=${this.mBondedDevices.size}`);
    /*switch (state) {
      case fusionConnectivityExt.FusionConnectivityExtState.STATE_ON:
        return;
      case fusionConnectivityExt.FusionConnectivityExtState.STATE_OFF:
        this.mBondedDevices.clear();
        return;
      case fusionConnectivityExt.FusionConnectivityExtState.STATE_BLUETOOTH_ON:
        this.mBondedDevices.forEach(device => {
          if (device.deviceMode !== fusionConnectivityExt.DeviceMode.BLUETOOTH_MODE) {
            this.mBondedDevices.delete(device.deviceId);
          }
        });
        return;
      case fusionConnectivityExt.FusionConnectivityExtState.STATE_NEARLINK_ON:
        this.mBondedDevices.forEach(device => {
          if (device.deviceMode !== fusionConnectivityExt.DeviceMode.NEARLINK_MODE) {
            this.mBondedDevices.delete(device.deviceId);
          }
        });
        return;
      default:
        return;
    }*/
  }

  updateIcon() {
    this.getViewData().isSymbolIcon = true;
    this.getViewData().icon = this.isNearLinkEnable && !this.isBluetoothMode ?
    $r('sys.symbol.nearlink') : $r('sys.symbol.bluetooth');
  }

  private updateLabel() {
    if (this.getViewData().label !== DEFAULT_NAME && this.getViewData().label !== DEFAULT_BLUETOOTH_NAME
      && this.getViewData().label !== DEFAULT_NEARLINK_NAME) {
      // 非默认开关文案
      return;
    }
    if (this.isNearLinkMode) {
      this.getViewData().label = DEFAULT_NEARLINK_NAME;
    } else {
      this.getViewData().label = this.isNearLinkEnable && !this.isBluetoothMode ? DEFAULT_NAME : DEFAULT_BLUETOOTH_NAME;
    }
  }

  handleUpdateState(): void {
    if (this.isClickOpen && this.getViewData().isOn) {
      this.isClickOpen = false;
    }
    if (this.getViewData().isOn && this.mBondedDevices.size > 0) {
      let key: string | undefined = Array.from(this.mBondedDevices.keys()).pop();
      if (key) {
        let lastDevice: BondedDevice | undefined = this.mBondedDevices.get(key);
        lastDevice?.updateDevice();
      }
    } else {
      this.getViewData().label = this.isNearLinkMode ? DEFAULT_NEARLINK_NAME :
        this.isNearLinkEnable && !this.isBluetoothMode ? DEFAULT_NAME : DEFAULT_BLUETOOTH_NAME;
    }
    log.showInfo(TAG, `handleUpdateState, status: ${this.mConnectedData.isConnected},${this.getViewData().isOn},${this.getViewData().label}`);
  }

  notifyDeviceInfoChange(data: ConnectedData) {
    this.mConnectedData = data;
  }

  /**
   * 获取开关当前状态
   */
  private getSwitchState(): ESObject {
    /*let fusionState: fusionConnectivityExt.FusionConnectivityExtState =
      fusionConnectivityExt.FusionConnectivityExtState.STATE_OFF;
    try {
      fusionState = fusionConnectivityExt.getState();
    } catch (error) {
      log.showError(TAG, `getSwitchState err:${error}`);
    }
    log.showInfo(TAG, `getSwitchState fusionState:${fusionState} , curState:${this.getViewData().isOn}`);
    return fusionState;*/
    return {};
  }

  /**
   * 打开开关二级页
   */
  public openDetailPageFunc: (() => void) | undefined = () => {
    if (this.getViewData().isUnavailable) {
      log.showWarn(TAG, 'bluetooth Integration disabled');
      if (!EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_BLUETOOTH_CONFIG)) {
        EdmAdminManager.instance.showToastWhenInoperable();
      }
      return;
    }
    log.showInfo(TAG, 'handleLongClick');
    this.toggleOperation.openDetailPage();
  };

  /**
   * 获取当前设备星闪功能是否可用
   *
   * @returns true 可用 false 不可用
   */
  public static isNearLinkAvailable(): boolean {
    if (DeviceHelper.isEmulator()) {
      log.showInfo(TAG, 'Disable the NearLink on the simulator');
      return false;
    }
    let isSupport: string = 'false';
    try {
      isSupport = systemParameterEnhance.getSync(NEAR_LINK_CCM_CONFIG, 'false');
    } catch (error) {
      log.showError(TAG, 'get isSupportNearLink fail', error);
    }
    let isEnable = isSupport === 'true';

    if (!EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_NEAR_LINK_CONFIG)) {
      isEnable = false;
    }
    return isEnable;
  }

  /**
   * 更新快捷开关的置灰状态
   */
  public updateDisableState(): void {
    // 如果星闪被禁用，需要刷新开关样式
    let curNearlinkEdmState = EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_NEAR_LINK_CONFIG);
    let curBluetoothEdmState = EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_BLUETOOTH_CONFIG);
    if (curNearlinkEdmState !== this.isNearLinkEnable || curBluetoothEdmState === this.getViewData().isUnavailable) {
      // Lottie销毁
      lottie.destroy(this.toggleId + this.viewData.isOn + this.getState());
      this.isNearLinkEnable = curNearlinkEdmState && BluetoothNearLinkFusionController.isNearLinkAvailable();
      this.updateIcon();
      this.updateLabel();
      this.removeAllLottieData();
      this.getViewData().isUnavailable = DeviceHelper.isEmulator() || !curBluetoothEdmState;
    }
    log.showInfo(TAG, `updateDisableState curNearlinkEdmState=${curNearlinkEdmState} curBluetoothEdmState=${curBluetoothEdmState} isUnavailable=${this.getViewData().isUnavailable} this.isNearLinkEnable=${this.isNearLinkEnable}`);
    if (!this.getViewData().isUnavailable) {
      this.initLottieData();
    }
  }

  private switchIntegrationStatus(isOn: boolean): void {
    log.showInfo(TAG, 'switchIntegrationStatus');
    try {
      taskpool.execute(switchIntegration, isOn)
        .then((result: Object) => {
          log.showError(TAG, `switchIntegrationStatus to ${isOn}, result:${result}`);
          if (result as number !== 0) {
            this.isWaitingLastActionDone = false;
          }
        }).catch((err: BusinessError) => {
        log.showError(TAG, `switchIntegrationStatus fail: ${err}`);
      });
    } catch (error) {
      log.error(TAG, `switchIntegrationStatus error:${error}`);
    }
    return;
  }

  handleOneClick(): void {
    if (this.getViewData().isUnavailable) {
      log.showWarn(TAG, 'handleOneClick disabled');
      if (!EdmAdminManager.instance.isEdmPolicyAvailable(PERSIST_EDM_BLUETOOTH_CONFIG)) {
        EdmAdminManager.instance.showToastWhenInoperable();
      }
      return;
    }
    // 防盗值守判断
    if (this.getViewData().isOn && AntiTheftUtil.antiTheftConfirm(GlobalContext.getContext())) {
      const resource: Resource = $r('app.string.control_center_anti_theft_for_toggle');
      AntiTheftUtil.antiTheftShowToast(resource);
      log.showWarn(TAG, 'anti-theft, click disabled');
      return;
    }
    let curStatus = this.getViewData().isOn;
    log.showInfo(TAG, `handleClick, status: ${curStatus}`);
    ControlCenterHiSysEventUtil.reportQuickToggleTristateModeClick({
      TOGGLE_NAME: FASlotName.BLUETOOTH,
      CURRENT_STATE: this.mBluetoothState,
      NEXT_STATE: curStatus ? 0 : 1,
      TIMESTAMP: DropDownPanelManager.getLastDropdownTime().toString(),
      SCREENTYPE: 0,
    });
    this.getViewData().isOn = !curStatus;
    this.updateIcon();
    curStatus = this.getViewData().isOn;
    log.showInfo(TAG, `handleClick, this.isWaitingLastActionDone: ${this.isWaitingLastActionDone} ${this.mBluetoothState},${curStatus}`);
    if (!this.isWaitingLastActionDone) {
      this.isWaitingLastActionDone = true;
      this.handleCallbackTimeout();
      this.switchIntegrationStatus(curStatus);
    }
    if (!curStatus) {
      this.mConnectedData.isConnected = false;
      this.mBondedDevices.clear();
    }
    log.showInfo(TAG, `handleClick end, mConnectedData: ${this.mConnectedData.isConnected}`);
  }

  private handleCallbackTimeout(): void {
    if (this.callbackTimeoutTimeId !== -1) {
      clearTimeout(this.callbackTimeoutTimeId);
      this.callbackTimeoutTimeId = -1;
    }
    this.callbackTimeoutTimeId = setTimeout(() => {
      log.showInfo(TAG, 'reset wait action flag');
      this.isWaitingLastActionDone = false;
      this.callbackTimeoutTimeId = -1;
    }, ISWAIT_CLEAR_TIMEOUT);
  }
}

export interface FusionDeviceInfoCallback {
  notifyDeviceInfoChange(data: ConnectedData): void;
}

function switchIntegration(isOn: boolean): number {
  'use concurrent';
  try {
    /*if (!isOn) {
      fusionConnectivityExt.disable();
    } else {
      fusionConnectivityExt.enable();
    }*/
    HiDfxEventUtil.reportToggleClick(PluginSlot.SLOT_STATUS_BLE, 0);
    return 0;
  } catch (err) {
    return err?.code;
  }
}

/**
 * 星闪蓝牙合一开关相关操作接口
 */
export interface ToggleOperation {
  openDetailPage(): void;
}

@Observed
export class ConnectedData {
  /**
   * 设备地址
   */
  public deviceId: string = '';
  /**
   * 设备名称
   */
  public deviceName: string = '';
  /**
   * 是否有设备连接
   */
  public isConnected: boolean = false;
  /**
   * 设备类型: 蓝牙/星闪
   */
  // public deviceMode: fusionConnectivityExt.DeviceMode = fusionConnectivityExt.DeviceMode.BLUETOOTH_MODE;
  public deviceMode: ESObject = 0;
}