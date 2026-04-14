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
import { DataType } from './DataType'

const TAG = 'StringUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

export class StringUtil {
  private static readonly DATA_LENGTH_MIN = 10;
  private static readonly SUB_STRING_LENGTH = 5;
  private static readonly BR_STRING_LENGTH = 17;
  private static readonly MAC_FIRST_STRING_LENGTH = 9;
  private static readonly MAC_SECOND_STRING_INDEX = 14;
  private static readonly MAX_BT_MAC_LENGTH: number = 14;
  private static readonly MIN_BT_MAC_LENGTH: number = 9;
  private static readonly MIDDLE_BT_MAC_LENGTH: number = 11;
  private static readonly MIDDLE_BT_MAC_LENGTH_NEXT: number = 12;
  private static readonly BT_MAC_FLAG: string = ':';
  private static readonly BT_MAC_LENGTH: number = 17;
  private static readonly BT_MAC_INDEX_START: number = 0;
  private static readonly NETWORK_ID_LIMIT: number = 10;
  private static readonly NETWORK_ID_INDEX_START: number = 0;
  private static readonly NETWORK_ID_SPLIT_LENGTH: number = 5;
  private static readonly DEVICE_UDID_MIN_LENGTH: number = 1;
  private static readonly DEVICE_UDID_CONCAT_FLAG: string = '#';
  private static readonly MIN_DEVICE_NAME_LENGTH = 3;
  private static readonly MIN_DEVICE_NAME_LENGTH_TO_GET_PREFIX = 6;

  private constructor() {
  }

  public static getAnonymousData(data: string, type: DataType): string {
    switch (type) {
      case DataType.UDID:
      case DataType.NET_ID:
        if (data && data.length >= StringUtil.DATA_LENGTH_MIN) {
          return data.substring(0, StringUtil.SUB_STRING_LENGTH) +
            '**' + data.substring(data.length - StringUtil.SUB_STRING_LENGTH);
        }
        return data;
      case DataType.BT_MAC:
        if (data && data.length === StringUtil.BR_STRING_LENGTH) {
          return data.substring(0, StringUtil.MAC_FIRST_STRING_LENGTH) +
            '**:**' + data.substring(StringUtil.MAC_SECOND_STRING_INDEX);
        }
        return data;
      case DataType.DEVICE_NAME:
        if (data && data.length >= StringUtil.MIN_DEVICE_NAME_LENGTH) {
          let prefix = data.length >= StringUtil.MIN_DEVICE_NAME_LENGTH_TO_GET_PREFIX ?
          data.substring(0, StringUtil.MIN_DEVICE_NAME_LENGTH) : '';
          return prefix + '**' + data.substring(data.length - StringUtil.MIN_DEVICE_NAME_LENGTH, data.length);
        }
        return data;
      default:
        return data;
    }
  }

  /**
   * Check str is empty.
   *
   * @param {string} str
   * @return {boolean} true(empty)
   */
  public static checkStrIsEmpty(str: string): boolean {
    return str === undefined || str === null || (typeof str === 'string' && str.trim().length === 0);
  }

  private static getAnonymousDeviceNetworkId(deviceNetworkId: string): string {
    if (deviceNetworkId.length < StringUtil.NETWORK_ID_LIMIT) {
      log.showError(TAG, 'getAnonymousDeviceNetworkId, wrong DeviceNetworkId, return empty');
      return '';
    }

    return deviceNetworkId.substring(StringUtil.NETWORK_ID_INDEX_START, StringUtil.NETWORK_ID_SPLIT_LENGTH) + '**' +
    deviceNetworkId.substring(deviceNetworkId.length - StringUtil.NETWORK_ID_SPLIT_LENGTH);
  }

  private static getAnonymousBtMAC(btMAC: string): string {
    if (btMAC.length != StringUtil.BT_MAC_LENGTH) {
      log.showError(TAG, 'getAnonymousBtMAC, wrong btMAC, return empty');
      return '';
    }

    return btMAC.substring(StringUtil.BT_MAC_INDEX_START, StringUtil.MIN_BT_MAC_LENGTH) + '**' +
    btMAC.substring(StringUtil.MIDDLE_BT_MAC_LENGTH,
      StringUtil.MIDDLE_BT_MAC_LENGTH_NEXT) + '**' + btMAC.substring(StringUtil.MAX_BT_MAC_LENGTH);
  }

  /**
   * get Anonymous uniqueId
   *
   * @param uniqueId
   * @returns Anonymous uniqueId
   */
  public static getAnonymousUniqueId(uniqueId: string): string {
    if (StringUtil.checkStrIsEmpty(uniqueId) ||
      uniqueId.length === StringUtil.DEVICE_UDID_MIN_LENGTH) {
      log.showWarn(TAG, 'uniqueId is invalid');
      return '';
    }

    if (uniqueId.startsWith(StringUtil.DEVICE_UDID_CONCAT_FLAG) &&
    StringUtil.isBrMac(uniqueId.substring(StringUtil.DEVICE_UDID_MIN_LENGTH))) {
      return StringUtil.getAnonymousBtMAC(uniqueId.substring(StringUtil.DEVICE_UDID_MIN_LENGTH));
    } else {
      return StringUtil.getAnonymousDeviceNetworkId(uniqueId.substring(StringUtil.NETWORK_ID_INDEX_START,
        uniqueId.length - StringUtil.DEVICE_UDID_MIN_LENGTH));
    }
  }

  private static isBrMac(brMac: string): boolean {
    return brMac.includes(StringUtil.BT_MAC_FLAG);
  }
}