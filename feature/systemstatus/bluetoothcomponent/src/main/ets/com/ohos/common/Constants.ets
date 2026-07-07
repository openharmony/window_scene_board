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

import bluetoothConnection from '@ohos.bluetooth.connection';
/*import fusionConnectivityExt from '@ohos.fusionConnectivityExt';
import nearlinkDevice from '@hms.nearlink.remoteDevice';
import constant from '@hms.nearlink.constant';*/
import { LogDomain, LogHelper } from '@ohos/basicutils';
// instrument ignore file

const TAG = 'Ctrl.BluetoothNearLinkConstants';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

export default class Constants {
  public static readonly LOTTIE_NAME: string = 'blue_tooth';
  public static readonly LOTTIE_DATA_OPEN: string = '01bluetooth_on.json';
  public static readonly LOTTIE_DATA_CLOSE: string = '02bluetooth_off.json';
  public static readonly LOTTIE_DATA_OPEN_DARK: string = '01bluetooth_on.json';
  public static readonly LOTTIE_DATA_CLOSE_DARK: string = '02bluetooth_off.json';
  public static readonly LOTTIE_DATA_FUSION_DARK: string = 'new_near_link.json';
  public static readonly LOTTIE_DATA_BLE2NEAR_DARK: string = 'bluetooth2nearlink.json';
  public static readonly LOTTIE_DATA_NEAR2BLE_DARK: string = 'nearlink2bluetooth.json';
  public static readonly DEFAULT_ERROR_NAME: string = 'bluetooth_2900003_near_link_1009700003';
  public static readonly NEARLINK_NAME_UPDATE_EVENT: string = 'usual.event.nearlink.remotedevice.NAME_UPDATE';

  /**
   * 从关闭态->打开态
   */
  public static readonly NEW_LOTTIE_DATA_OPEN: string = '01bluetooth_on.json';
  /**
   * 从打开态->关闭态
   */
  public static readonly NEW_LOTTIE_DATA_CLOSE: string = '02bluetooth_off.json';

  /**
   * 电量配置项
   */
  public static readonly BATTERY_LEVEL_LOW = 20;
  public static readonly BATTERY_LEVEL_VERY_LOW = 10;
  public static readonly BATTERY_RED = '#FF3320';
  public static readonly BATTERY_ORANGE = '#FF9B1A';

  /**
   * 星闪设备链接状态
   */
  public static readonly STATE_CONNECTED: number = 1;
  public static readonly STATE_DISCONNECTED: number = 3;
}

export class BondedDevice {
  /**
   * 设备id: address
   */
  public deviceId: string;
  /**
   * 设备名称
   */
  public deviceName: string;
  /**
   * 设备类型: 蓝牙/星闪
   */
  // public deviceMode: fusionConnectivityExt.DeviceMode = fusionConnectivityExt.DeviceMode.BLUETOOTH_MODE;
  public deviceMode: ESObject = 0;
  /**
   * 蓝牙设备协议集合
   */
  public statusMap: Map<BlueToothProtocol, boolean> = new Map();

  constructor(deviceId: string, deviceMode: ESObject) {
    this.deviceId = deviceId;
    this.deviceMode = deviceMode;
    this.deviceName = BondedDevice.getDeviceName(deviceId, deviceMode);
  }

  /**
   * 创建设备
   *
   * @param deviceId 设备ID: address
   * @param deviceMode 设备类型
   * @returns BondedDevice 绑定设备
   */
  static createDevice(deviceId: string,
    // deviceMode: fusionConnectivityExt.DeviceMode = fusionConnectivityExt.DeviceMode.BLUETOOTH_MODE): BondedDevice {
    deviceMode: ESObject = 0): BondedDevice {
    let device = new BondedDevice(deviceId, deviceMode);
    return device;
  }

  /**
   * 获取设备名称
   *
   * @param deviceId 设备ID: address
   * @param deviceMode 设备类型
   * @returns string 设备名称
   */
  static getDeviceName(deviceId: string, deviceMode: ESObject): string {
    if (!deviceId) {
      return deviceId;
    }
    let name = deviceId;
    /*try {
      name = deviceMode === fusionConnectivityExt.DeviceMode.BLUETOOTH_MODE ?
        bluetoothConnection.getRemoteDeviceName(deviceId) :
        nearlinkDevice.createRemoteDevice(deviceId)?.getDeviceAlias();
    } catch (error) {
      log.showError(`getDeviceName deviceMode:${deviceMode} error:${error}`);
      name = Constants.DEFAULT_ERROR_NAME;
    }*/
    return name;
  }

  /**
   * 刷新设备名称
   */
  public updateDevice(): void {
    /*try {
      this.deviceName = this.deviceMode === fusionConnectivityExt.DeviceMode.BLUETOOTH_MODE ?
        bluetoothConnection.getRemoteDeviceName(this.deviceId) :
        nearlinkDevice.createRemoteDevice(this.deviceId)?.getDeviceAlias();
    } catch (error) {
      log.showError(`updateDevice deviceMode:${this.deviceMode} error:${error}`);
    }*/
  }

  /**
   * get device connect state
   * @returns bluetooth connect state
   */
  public getDeviceConnState():boolean {
    try {
      /*if (this.deviceMode === fusionConnectivityExt.DeviceMode.NEARLINK_MODE) {
        return nearlinkDevice.createRemoteDevice(this.deviceId)?.getConnectionState() ===
          constant.ConnectionState.STATE_CONNECTED;
      }
      for (let state of this.statusMap.values()) {
        if (state) {
          return true;
        }
      }*/
    } catch (error) {
      log.showError(`getDeviceConnState deviceMode:${this.deviceMode} error:${error}`);
    }
    return false;
  }
}

export class BluetoothDevice {
  public deviceId: string;
  public deviceName: string;
  // Connect state：true:connect, false:disconnect
  public statusMap: Map<BlueToothProtocol, boolean> = new Map();

  constructor(deviceId: string) {
    this.deviceId = deviceId;
    this.deviceName = BluetoothDevice.getDeviceName(deviceId);
  }

  static createDevice(deviceId: string): BluetoothDevice {
    let device = new BluetoothDevice(deviceId);
    return device;
  }

  static getDeviceName(deviceId: string): string {
    if (!deviceId) {
      return deviceId;
    }
    let name = bluetoothConnection.getRemoteDeviceName(deviceId);
    if (!name) {
      return deviceId;
    }
    return name;
  }

  updateDevice(): void {
    this.deviceName = bluetoothConnection.getRemoteDeviceName(this.deviceId);
  }

  /**
   * get bluetooth connect state
   * @returns bluetooth connect state
   */
  getBlueToothConnState():boolean {
    for (let state of this.statusMap.values()) {
      if (state) {
        return true;
      }
    }
    return false;
  }
}

export enum BlueToothProtocol {
  A2DP_SRC = 0,
  HFP_AG = 1,
  HID_HOST = 2
}

export enum BlueToothState {
  /**
   * 蓝牙状态切换过程中 STATE_UNKNOWN
   */
  STATE_UNKNOWN = -1,
  /**
   * 蓝牙关闭 STATE_OFF
   */
  STATE_OFF = 0,
  /**
   * 蓝牙打开中
   */
  STATE_TURNING_ON = 1,
  /**
   * 蓝牙打开
   */
  STATE_ON = 2,
  /**
   * 蓝牙关闭中
   */
  STATE_TURNING_OFF = 3,
  /**
   * 蓝牙半关闭中
   */
  STATE_BLE_TURNING_ON = 4,
  /**
   * 蓝牙半关闭 STATE_BLE_ON
   */
  STATE_BLE_ON = 5,
  /**
   * 蓝牙全关闭中
   */
  STATE_BLE_TURNING_OFF = 6
}