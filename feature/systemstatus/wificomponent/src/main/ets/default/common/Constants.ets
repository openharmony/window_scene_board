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

export default class Constants {
  public static DEFAULT_WIFI_OPEN_STATUS: boolean = false;
  public static DEFAULT_WIFI_NAME: string = 'WLAN';
  public static DEFAULT_WIFI_INFO: number = 0;
  public static DEFAULT_WIFI_STATUS: boolean = false;
  public static DEFAULT_WIFI_METERED: boolean = false;
  public static WIFI_SIGNAL_NO: number = 0;
  public static WIFI_SIGNAL_LOW: number = 1;
  public static WIFI_SIGNAL_MID: number = 2;
  public static WIFI_SIGNAL_HIGH: number = 3;
  public static WIFI_SIGNAL_FULL: number = 4;
  public static readonly CATEGORY_DEFAULT = 1;
  public static readonly CATEGORY_WIFI6 = 2;
  public static readonly CATEGORY_WIFI6_PLUS = 3;
  public static readonly CATEGORY_WIFI7 = 4;
  public static readonly CATEGORY_WIFI7_PLUS = 5;
  public static readonly CATEGORY_DOUBLE = 6;
  public static readonly CATEGORY_DOUBLE_WIFI6 = 7;
  public static readonly CATEGORY_DOUBLE_WIFI6_PLUS = 8;
  public static readonly CATEGORY_DOUBLE_WIFI7 = 9;
  public static readonly CATEGORY_DOUBLE_WIFI7_PLUS = 10;

  public static SPEED_THRESHOLD = 900;
  public static BYTE = 1024;

  public static BYTE_SHORT = 'B';
  public static KILO_BYTE_SHORT = 'K';
  public static MEGA_BYTE_SHORT = 'M';
  public static GIGA_BYTE_SHORT = 'G';

  public static readonly LOTTIE_NAME = 'wifi';
  public static readonly LOTTIE_DATA_OPEN: string = '03WiFi_on.json';
  public static readonly LOTTIE_DATA_CLOSE: string = '04WiFi_off.json';
  public static readonly LOTTIE_DATA_OPEN_DARK: string = '03WiFi_on.json';
  public static readonly LOTTIE_DATA_CLOSE_DARK: string = '04WiFi_off.json';
  /**
   * 从关闭态->打开态
   */
  public static readonly NEW_LOTTIE_DATA_OPEN: string = '03WiFi_on.json';
  /**
   * 从打开态->关闭态
   */
  public static readonly NEW_LOTTIE_DATA_CLOSE: string = '04WiFi_off.json';

  public static readonly DATA_FLOW_TYPE_NONE: number = 0;
  public static readonly DATA_FLOW_TYPE_DOWN: number = 1;
  public static readonly DATA_FLOW_TYPE_UP: number = 2;
  public static readonly DATA_FLOW_TYPE_UP_DOWN: number = 3;

  public static isNetworkAvailable: boolean = true;

  public static readonly IMAGE_EDGE = 0.5;

  public static DEFAULT_SCREENOFF_STATUS = false;
}

export enum WifiDetailState {
  /**
   * WIFI状态未知
   */
  STATE_UNKNOWN = -1,
  /**
   * 未激活
   */
  STATE_INACTIVE = 0,
  /**
   * 已激活
   */
  STATE_ACTIVE = 1,
  /**
   * 激活中
   */
  STATE_ACTIVATING = 2,
  /**
   * 去激活中
   */
  STATE_DEACTIVATING = 3,
  /**
   * 半激活中
   */
  STATE_SEMI_ACTIVATING = 4,
  /**
   * 已半激活
   */
  STATE_SEMI_ACTIVE = 5,
}

export class WifiData {
  public isConnected: boolean = Constants.DEFAULT_WIFI_STATUS;
  public isMetered: boolean = Constants.DEFAULT_WIFI_METERED;
  public signalLevel: number = Constants.DEFAULT_WIFI_INFO;
  public dataFlowType: number = Constants.DATA_FLOW_TYPE_NONE;
  public isNetworkAvailable: boolean = Constants.isNetworkAvailable;
  public supportedWifiCategory: number = Constants.CATEGORY_DEFAULT;
  public isScreenOff: boolean = Constants.DEFAULT_SCREENOFF_STATUS;
  public wifiName: string | Resource = '';
}
