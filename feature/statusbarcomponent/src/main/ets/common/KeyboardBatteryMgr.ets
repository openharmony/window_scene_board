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
import settings from '@ohos.settings';
import type common from '@ohos.app.ability.common';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import systemParameter from '@ohos.systemParameterEnhance';

const TAG = 'KeyBoardBatteryManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const kbChargingSupportKey: string = 'ohos.keyboard.charge.support';
const kbChargingStateKey: string = 'ohos.keyboard.charging.state';
const kbConnectionStateKey: string = 'ohos.keyboard.connection.state';
const kbBatteryValueKey: string = 'ohos.keyboard.battery';
const kbShowKeyboardBattery: string = 'ohos.keyboard.showBattery';

enum ConnectStatus {
  OFF = 'off',
  ON = 'on',
}
export enum ChargingState {
  OFF = '0',
  ON = '1',
}

export class KeyboardBatteryMgr {
  private static instance: KeyboardBatteryMgr;
  private keyboardConnectStatus: boolean = false;
  private keyboardChargingSupport: boolean = false;
  private keyboardChargingStatus: boolean = false;
  private keyboardBatteryValue: number = 0;
  private showKeyboardBattery: string = ChargingState.OFF;

  public static getInstance(): KeyboardBatteryMgr {
    log.showDebug('getInstance');
    if (KeyboardBatteryMgr.instance === null || KeyboardBatteryMgr.instance === undefined) {
      KeyboardBatteryMgr.instance = new KeyboardBatteryMgr();
    }
    return KeyboardBatteryMgr.instance;
  }

  public getKeyboardConnectStatus(): boolean {
    try {
      let connectStatus = systemParameter.getSync(kbConnectionStateKey, ConnectStatus.OFF);
      this.keyboardConnectStatus = connectStatus === ConnectStatus.ON;
      log.showInfo(`ConnectStatus: ${this.keyboardConnectStatus}`);
    } catch (error) {
      log.showError(`get connect info fail code:${error?.code} msg:${error?.message}`);
      this.keyboardConnectStatus = false;
    }
    return this.keyboardConnectStatus;
  }

  public getKeyboardChargingSupport(): boolean {
    try {
      let chargingSupport = systemParameter.getSync(kbChargingSupportKey, ChargingState.OFF);
      this.keyboardChargingSupport = chargingSupport === ChargingState.ON;
      log.showInfo(`chargingSupport: ${this.keyboardChargingSupport}`);
    } catch (error) {
      log.showError(`get charging support info fail code:${error?.code} msg:${error?.message}`);
      this.keyboardChargingSupport = false;
    }
    return this.keyboardChargingSupport;
  }

  public getKeyboardBatteryChargingStatus(): boolean {
    if (!this.getKeyboardChargingSupport()) {
      return false;
    }
    try {
      let chargingStatus = systemParameter.getSync(kbChargingStateKey, ChargingState.OFF)
      this.keyboardChargingStatus = chargingStatus === ChargingState.ON;
      log.showInfo(`chargingStatus: ${this.keyboardChargingStatus}`);
    } catch (error) {
      log.showError(`$get charging status info fail code:${error?.code} msg:${error?.message}`);
      this.keyboardChargingStatus = false;
    }
    return this.keyboardChargingStatus;
  }

  public getKeyboardBatteryValue(): number {
    try {
      let keyboardBatteryValueS = systemParameter.getSync(kbBatteryValueKey, ChargingState.OFF);
      this.keyboardBatteryValue = Number(keyboardBatteryValueS);
      log.showInfo(`keyboard battery value: ${this.keyboardBatteryValue}`);
    } catch (error) {
      log.showError(`get keyboard battery value info fail code:${error?.code} msg:${error?.message}`);
      this.keyboardBatteryValue = Number(ChargingState.OFF);
    }
    return this.keyboardBatteryValue;
  }

  public getShowKeyboardBattery(context: common.Context): string {
    try {
      this.showKeyboardBattery = settings.getValueSync(context, kbShowKeyboardBattery, ChargingState.OFF);
      log.showInfo(`show keyboard battery value: ${this.showKeyboardBattery}`);
    } catch (error) {
      log.showError(`get show keyboard battery value info fail code:${error?.code} msg:${error?.message}`);
    }
    return this.showKeyboardBattery;
  }
}
