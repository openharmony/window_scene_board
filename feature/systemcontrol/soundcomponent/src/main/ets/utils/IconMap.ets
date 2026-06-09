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

import { audio } from '@kit.AudioKit';
import { SymbolIconUtil } from '@ohos/systemuicommon/src/main/ets/TsIndex';

export class IconMap {
  /**
   * 扬声器默认图标
   */
  public static readonly SPEAKER_FILL_ICON = $r('sys.symbol.speaker_wave_3_fill');

  /**
   * 有线耳机默认图标
   */
  public static readonly HEADSET_FILL_ICON = 'sys.symbol.earphone_16640_fill';

  public static readonly BLUETOOTH_ICON = 'sys.symbol.bluetooth';

  public static readonly NEARLINK_SYMBOL = 'sys.symbol.nearlink';

  public static getFillEarphoneIcon(deviceId: string, deviceType?: audio.DeviceType) {
    return deviceType === audio.DeviceType.NEARLINK ?
      $r(`${SymbolIconUtil.getNearlinkFillIcon(deviceId)}`) :
      $r(`${SymbolIconUtil.getBluetoothFillIcon(deviceId)}`);
  }

  public static getUsbHeadsetIcon() {
    return $r(`${IconMap.HEADSET_FILL_ICON}`);
  }

  public static getDeviceTypeIconString(deviceType: audio.DeviceType, deviceMac: string): string {
    switch (deviceType) {
      case audio.DeviceType.WIRED_HEADSET:
      case audio.DeviceType.WIRED_HEADPHONES:
      case audio.DeviceType.USB_HEADSET:
        return IconMap.HEADSET_FILL_ICON;
      case audio.DeviceType.BLUETOOTH_A2DP:
      case audio.DeviceType.BLUETOOTH_SCO:
        return SymbolIconUtil.getEarphoneFillIcon(deviceMac);
      case audio.DeviceType.NEARLINK:
        return IconMap.NEARLINK_SYMBOL;
      default:
        return IconMap.BLUETOOTH_ICON;
    }
  }

  public static isEarphoneIconString(iconString: string): boolean {
    return iconString.startsWith('sys.symbol.earphone_');
  }
}
