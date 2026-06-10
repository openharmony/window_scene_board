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

/**
 * telephony error code 电话子系统错误码
 */
enum TelephoneErrorCode {
  PARAM_ERROR = 401,
  INVALID_PARAM_VALUE = 8300001,
  NOT_CONNECT_SERVICE = 8300002,
  SYSTEM_INTERNAL_ERROR = 8300003,
  NO_SIM_CARD = 8300004,
  UNKNOWN_ERROR_CODE = 8300999,
  OPERATION_ERROR = 8301002,
};

export enum CardSituation {
  SINGLE_CARD_0 = '100', // 单卡0
  SINGLE_CARD_1 = '010', // 单卡1
  DUAL_CARD_0_1 = '110', // 双卡0/1
  NO_CARD = '000', // 无卡
  NO_CARD_EMPTY = '-1', // 特殊场景: 三卡信号强度都是-1显示空卡
  DUAL_CARD_SKY_0 = '101', // 天际通 + 单卡0
  DUAL_CARD_SKY_1 = '011', // 天际通 + 单卡1
  SINGLE_CARD_SKY = '001', // 仅天际通
  TRIPLE_CARD = '111', // 天际通 + 双卡0/1
}

export default class Constants {
  // 信号强度
  public static readonly CELLULAR_SIGNAL_NO: number = 0;
  public static readonly CELLULAR_SIGNAL_MIN: number = 1;
  public static readonly CELLULAR_SIGNAL_LOW: number = 2;
  public static readonly CELLULAR_SIGNAL_HALF: number = 3;
  public static readonly CELLULAR_SIGNAL_HIGH: number = 4;
  public static readonly CELLULAR_SIGNAL_FULL: number = 5;
  public static readonly CELLULAR_NO_SIM_CARD: number = -1;

  // 数据传输 上行还是下行
  public static readonly NET_NULL: string = 'NULL';
  public static readonly DATA_FLOW_TYPE_NONE: number = 0;
  public static readonly DATA_FLOW_TYPE_DOWN: number = 1;
  public static readonly DATA_FLOW_TYPE_UP: number = 2;
  public static readonly DATA_FLOW_TYPE_UP_DOWN: number = 3;
  public static readonly DATA_FLOW_TYPE_DORMANT: number = 4;

  // 运营商编码  中国移动
  public static readonly MOBILE_GSM_PLMN: string = '46000';
  public static readonly MOBILE_TDS_PLMN: string = '46002';
  public static readonly MOBILE_TDS2_PLMN: string = '46007';
  public static readonly MOBILE_HK_PLMN: string = '41004';

  // 运营商编码  中国联通
  public static readonly UNICOM_GSM_PLMN: string = '46001';
  public static readonly UNICOM_WCDMA_PLMN: string = '46006';

  // 运营商编码  中国电信
  public static readonly TELECOM_CDMA_PLMN: string = '46003';
  public static readonly TELECOM_CDMA2_PLMN: string = '46005';
  public static readonly TELECOM_FDD_PLMN: string = '46011';

  /**
   * RadioTechnology 无线接入技术
   */
  // 2g
  public static readonly RADIO_TECHNOLOGY_UNKNOWN = 0;
  public static readonly RADIO_TECHNOLOGY_GSM = 1;
  public static readonly RADIO_TECHNOLOGY_1XRTT = 2;
  // 3g
  public static readonly RADIO_TECHNOLOGY_WCDMA = 3;
  public static readonly RADIO_TECHNOLOGY_HSPA = 4;
  public static readonly RADIO_TECHNOLOGY_HSPAP = 5;
  public static readonly RADIO_TECHNOLOGY_TD_SCDMA = 6;
  public static readonly RADIO_TECHNOLOGY_EVDO = 7;
  public static readonly RADIO_TECHNOLOGY_EHRPD = 8;
  // 4g
  public static readonly RADIO_TECHNOLOGY_LTE = 9;
  public static readonly RADIO_TECHNOLOGY_LTE_CA = 10;
  public static readonly RADIO_TECHNOLOGY_IWLAN = 11;
  // 5g
  public static readonly RADIO_TECHNOLOGY_NR = 12;

  /**
   * RegState 网络注册状态
   */
  public static readonly REG_STATE_NO_SERVICE = 0;
  public static readonly REG_STATE_IN_SERVICE = 1;
  public static readonly REG_STATE_EMERGENCY_CALL_ONLY = 2;
  public static readonly REG_STATE_POWER_OFF = 3;

  /**
   * NetworkState isEmergency
   */
  public static readonly EMERGENCY_DEFAULT = -1;
  public static readonly EMERGENCY_TRUE = 1;
  public static readonly EMERGENCY_FALSE = 2;

  /**
   * DataConnectState
   */
  public static readonly DATA_STATE_UNKNOWN = -1;
  public static readonly DATA_STATE_DISCONNECTED = 0;
  public static readonly DATA_STATE_CONNECTING = 1;
  public static readonly DATA_STATE_CONNECTED = 2;
  public static readonly DATA_STATE_SUSPENDED = 3;

  public static readonly DATA_FLOW_SLOTID_DEFAULT: number = 0;

  public static readonly OPERATOR_NAME_LOOP: number = 2;
  public static readonly OPERATOR_NAME_STEP: number = 2;
  public static readonly OPERATOR_NAME_MAX_LINE: number = 1;
  public static readonly OPERATOR_NAME_DURATION: number = 2500;

  public static readonly NO_SIM_CARD_ERROR_CODE: Array<number> = [
    TelephoneErrorCode.INVALID_PARAM_VALUE,
    TelephoneErrorCode.NO_SIM_CARD,
    TelephoneErrorCode.OPERATION_ERROR,
  ];

  public static readonly IS_UNREGISTER: number = 0;
  public static readonly IS_REGISTER: number = 1;
  public static readonly IS_HD_REGISTER_TECH: number = 2;
  public static readonly IS_WLAN_REGISTER_TECH: number = 3;
}
