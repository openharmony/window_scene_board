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

import { access } from '@kit.ConnectivityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { BluetoothConstants } from '../constants/BluetoothConstants';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, 'GlassBlueToothManager');

export class GlassBlueToothManager {
  private bluetoothState?: access.BluetoothState;
  private bluetoothColor?: string;
  private bluetoothFillColor?: string;

  public constructor() {
    this.bluetoothState = this.getBluetoothState();
    this.updateBluetoothStateColors();
  }

  public getBluetoothState(): access.BluetoothState {
    let curState: access.BluetoothState = access.BluetoothState.STATE_ON;
    let getState: access.BluetoothState = access.getState()

    switch (getState) {
      case access.BluetoothState.STATE_ON:
        curState = access.BluetoothState.STATE_ON;
        break;
      case access.BluetoothState.STATE_OFF:
        curState = access.BluetoothState.STATE_OFF;
        break;
      case access.BluetoothState.STATE_BLE_ON:
        curState = access.BluetoothState.STATE_BLE_ON;
        break;
      default:
        break;
    }
    log.showInfo(`getBluetoothState,curState is ${curState}`);
    return curState;
  }

  public updateBluetoothStateColors(): void {
    if (this.bluetoothState === access.BluetoothState.STATE_ON) {
      log.showInfo(`updateBluetoothStateColors,bluetoothState STATE_ON`);
      this.bluetoothColor = BluetoothConstants.CAPSULE_OPEN_COLOR;
      this.bluetoothFillColor = BluetoothConstants.CAPSULE_ICON_OPEN_COLOR;
    } else {
      log.showInfo(`updateBluetoothStateColors,bluetoothState STATE_OFF`);
      this.bluetoothColor = BluetoothConstants.CAPSULE_CLOSE_COLOR;
      this.bluetoothFillColor = BluetoothConstants.CAPSULE_ICON_CLOSE_COLOR;
    }
  }

  public updateBluetoothState(): void {
    this.bluetoothState = this.getBluetoothState();
    if (this.bluetoothState !== access.BluetoothState.STATE_ON) {
      try {
        access.enableBluetooth();
      } catch (err) {
        let catchedError: BusinessError = err as BusinessError
        log.error('errCode: ' + catchedError.code + ', errMessage: ' + catchedError.message);
      }
    }

    if (this.bluetoothState !== access.BluetoothState.STATE_OFF) {
      try {
        access.disableBluetooth();
      } catch (err) {
        let catchedError: BusinessError = err as BusinessError
        log.error('errCode: ' + catchedError.code + ', errMessage: ' + catchedError.message);
      }
    }
  }

  public enableBluetooth(): void {
    try {
      access.enableBluetooth();
    } catch (err) {
      let catchedError: BusinessError = err as BusinessError
      log.error('errCode: ' + catchedError.code + ', errMessage: ' + catchedError.message);
    }
  }

  public disableBluetooth(): void {
    try {
      access.disableBluetooth();
    } catch (err) {
      let catchedError: BusinessError = err as BusinessError
      log.error('errCode: ' + catchedError.code + ', errMessage: ' + catchedError.message);
    }
  }

  public registerStateChangeCallback(): void {
    try {
      access.on('stateChange', (data: access.BluetoothState) => {
        this.bluetoothState = data;
        this.updateBluetoothStateColors();
      });
    } catch (err) {
      log.showError(`registerStateChangeCallback fail,error is ${err.message}`);
    }
  }

  public unRegisterStateChangeCallback(): void {
    try {
      access.off('stateChange');
    } catch (err) {
      log.showError(`unRegisterStateChangeCallback fail,error is ${err.message}`);
    }
  }

  public getBluetoothColor(): string | undefined {
    return this.bluetoothColor
  }

  public getBluetoothFillColor(): string | undefined {
    return this.bluetoothFillColor;
  }
}