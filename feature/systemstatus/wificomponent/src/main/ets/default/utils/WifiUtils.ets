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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import constants from '../common/Constants';
import { WifiDetailState } from '../common/Constants';
import wifiManager from '@ohos.wifiManager';
import { BusinessError } from '@ohos.base';
import connection from '@ohos.net.connection';


const TAG: string = 'WifiUtils : ';
export const WIFI_INACTIVE_HEIGHT: number = 109;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const NETWORK_CAPABILITY_LENGTH: number = 1;

// Indicates that the network is available.
const NET_CAPABILITY_VALIDATED: number = 16;

// Indicates that the network is detection.
const NET_CAPABILITY_DETECTION: number = 31;

@Observed
export class WifiDataPC {
  public wifiName: string = constants.DEFAULT_WIFI_NAME;
  public isConnected: boolean = false;
  public isMetered: boolean = false;
  public signalLevel: number = constants.WIFI_SIGNAL_NO;
  public dataFlowType: number = constants.DATA_FLOW_TYPE_NONE;
  public isNetworkAvailable: boolean = false;
  public supportedWifiCategory: number = constants.CATEGORY_DEFAULT;
  public isScreenOff: boolean = false;
  public state: WifiDetailState = WifiDetailState.STATE_UNKNOWN;
  public isEthernetAvailable: boolean = false;
}

/**
 * Wifi工具类
 *
 * @since 2022-03-21
 */
export class WifiUtils {
  /**
   * Wifi是否开启
   */
  static isWifiActive(): boolean {
    try {
      let isActive: boolean = wifiManager.isWifiActive();
      log.info(`${TAG} check wifi active status is : ${isActive}`);
      return isActive;
    } catch (error) {
      log.error(`${TAG} failed to check whether wifi is active, errCode:${(error as BusinessError).code}, message:${(error as BusinessError).message}`);
      return false;
    }
  }

  /**
   * wifiStateChange 监听事件
   */
  static wifiStateChangeOn(tag: string, fn: Callback<number>): void {
    try {
      wifiManager.on('wifiStateChange', fn);
    } catch (e) {
      log.error(`${tag} wifiStateChange.on catch error code:${e?.code} message:${e?.message}`);
    }
  }

  /**
   * wifiStateChange 卸载事件
   */
  static wifiStateChangeOff(tag: string, fn: Callback<number>): void {
    try {
      wifiManager.off('wifiStateChange', fn);
    } catch (e) {
      log.error(`${tag} wifiStateChange.off catch error code:${e?.code} message:${e?.message}`);
    }
  }

  /**
   * wifiConnectionChange 监听事件
   */
  static wifiConnectionChangeOn(tag: string, fn: Callback<number>): void {
    try {
      wifiManager.on('wifiConnectionChange', fn);
    } catch (e) {
      log.error(`${tag} wifiConnectionChange.on catch error code:${e?.code} message:${e?.message}`);
    }
  }

  /**
   * wifiConnectionChange 卸载事件
   */
  static wifiConnectionChangeOff(tag: string, fn: Callback<number>): void {
    try {
      wifiManager.off('wifiConnectionChange', fn);
    } catch (e) {
      log.error(`${tag} wifiConnectionChange.off catch error code:${e?.code} message:${e?.message}`);
    }
  }

  /**
   * wifiRssiChange 监听事件
   */
  static wifiRssiChangeOn(tag: string, fn: Callback<number>): void {
    try {
      wifiManager.on('wifiRssiChange', fn);
    } catch (e) {
      log.error(`${tag} wifiRssiChange.on catch error code:${e?.code} message:${e?.message}`);
    }
  }

  /**
   * wifiRssiChange 卸载事件
   */
  static wifiRssiChangeOff(tag: string, fn: Callback<number>): void {
    try {
      wifiManager.off('wifiRssiChange', fn);
    } catch (e) {
      log.error(`${tag} wifiRssiChange.off catch error code:${e?.code} message:${e?.message}`);
    }
  }

  /**
   * wifiStreamChange 监听事件
   */
  static wifiStreamChangeOn(tag: string, fn: Callback<number>): void {
    try {
      wifiManager.on('streamChange', fn);
    } catch (e) {
      log.error(`${tag} wifiStreamChangeOn.on error catch code:${e?.code} message:${e?.message}`);
    }
  }

  /**
   * wifiStreamChange 卸载事件
   */
  static wifiStreamChangeOff(tag: string, fn: Callback<number>): void {
    try {
      wifiManager.off('streamChange', fn);
    } catch (e) {
      log.error(`${tag} wifiStreamChangeOff.off error catch code:${e?.code} message:${e?.message}`);
    }
  }

  /**
   * 是否是wifi网络
   *
   * @param bearerTypes 网络类型
   * @returns true, wifi网络
   */
  static isBearerWifi(bearerTypes?: Array<connection.NetBearType>): boolean {
    return bearerTypes?.length === NETWORK_CAPABILITY_LENGTH && bearerTypes[0] === connection.NetBearType.BEARER_WIFI;
  }

  /**
   * 网络是否可用
   *
   * @param caps 网络能力
   * @returns true, 网络可用
   */
  static isWifiNetworkValidated(caps?: Array<connection.NetCap>): boolean {
    // 当网络能力包含16的时候为可用状态
    return caps?.includes(NET_CAPABILITY_VALIDATED) as boolean;
  }

  /**
   * 是否存在Ethernet以太网网络
   *
   * @param bearerTypes 网络类型
   * @returns true, 当前存在以太网网络
   */
  static isBearerEthernet(bearerTypes?: Array<connection.NetBearType>): boolean {
    return (bearerTypes?.length === NETWORK_CAPABILITY_LENGTH) &&
      (bearerTypes[0] === connection.NetBearType.BEARER_ETHERNET);
  }

  /**
   * 有线网络是否可用
   *
   * @param caps 网络能力
   * @returns true, 网络可用
   */
  static isEthernetNetworkValidated(caps?: Array<connection.NetCap>): boolean {
    // 首次插入网线会触发探测，"networkCap":[12,15,16,31] 16为网络可用，31为触发探测，在探测过程会同时上报16，只有当存在16没有31的场景才能保证有网
    let networkValidated: boolean =
      (caps?.includes(NET_CAPABILITY_VALIDATED) as boolean) && !(caps?.includes(NET_CAPABILITY_DETECTION) as boolean);
    return networkValidated;
  }

  /**
   * 转换成可以打印的ssid掩码
   *
   * @param ssidString 待转换的ssid
   */
  static getLogSsidString(ssidString: String): string {
    if (!ssidString) {
      return '';
    }

    let maskString: string = '************************************';
    let minMaskLen: number = 3;
    let maxLen: number = 32;
    let len = ssidString.length;
    if (len <= 1 || len > maxLen) {
      return '*****';
    }

    let maskLen: number = len + minMaskLen;
    let midLen: number = 10;
    if (len <= midLen) {
      return ssidString.charAt(0) + maskString.substring(0, maskLen - 1);
    }

    return ssidString.charAt(0) + maskString.substring(0, maskLen - 1) + ssidString.charAt(len - 1);
  }



}