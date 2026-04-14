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
import { DeviceHelper, HiSysEventUtil } from '@ohos/frameworkwrapper';
import hiSysEvent from '@ohos.hiSysEvent';
import { BusinessError } from '@kit.BasicServicesKit';

const PKG_NAME = 'com.ohos.sceneboard'
const TAG = 'Model.CastReportUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

export default class CastReportUtils {
  public reportUEProjectionStart(triggerMode: number): void {
    let event: UEProjectionStartEvent = new UEProjectionStartEvent(triggerMode);
    this.reportUEEvent('PROJECTION_START_EVENT', event);
  }

  public reportUEWifiBtDialogEvent(isWifiOpen: boolean, isBluetoothOpen: boolean, state: number): void {
    let event: UEWifiBtDialogEvent = new UEWifiBtDialogEvent(state, isWifiOpen ? 1 : 0, isBluetoothOpen ? 1 : 0);
    this.reportUEEvent('WIFI_BT_DIALOG_EVENT', event);
  }

  public reportUEPrivacyDialogEvent(state: number): void {
    let event: UEPrivacyDialogEvent = new UEPrivacyDialogEvent(state);
    this.reportUEEvent('PRIVACY_DIALOG_EVENT', event);
  }

  public reportUEFailDialogEvent(state: number, errorCode: number): void {
    let event: UEFailDialogEvent = new UEFailDialogEvent(state, errorCode);
    this.reportUEEvent('FAIL_DIALOG_EVENT', event);
  }

  private reportUEEvent(eventName: string, event: UEEvent): void {
    let eventInfo: hiSysEvent.SysEventInfo = {
      domain: 'PROJECTION_UE',
      name: eventName,
      eventType: hiSysEvent.EventType.BEHAVIOR,
      params: event
    };
    try {
      hiSysEvent.write(eventInfo);
    } catch (err) {
      log.showError(`reportUEEvent err: ${(err as BusinessError).code}, ${(err as BusinessError).message}`);
    }
  }
}

type UEEvent = UEProjectionStartEvent | UEPrivacyDialogEvent | UEWifiBtDialogEvent | UEFailDialogEvent;

class UEProjectionStartEvent {
  public PNAMEID: string = PKG_NAME;
  public PVERSIONID = HiSysEventUtil.getVersionName(PKG_NAME);
  public LOCAL_DEV_TYPE = DeviceHelper.getDeviceType();
  public TRIGGER_MODE: number;

  constructor(triggerMode: number) {
    this.TRIGGER_MODE = triggerMode;
  }
}

class UEPrivacyDialogEvent {
  public PNAMEID: string = PKG_NAME;
  public PVERSIONID = HiSysEventUtil.getVersionName(PKG_NAME);
  public LOCAL_DEV_TYPE = DeviceHelper.getDeviceType();
  public STATE: number;

  constructor(state: number) {
    this.STATE = state;
  }
}

class UEWifiBtDialogEvent {
  public PNAMEID: string = PKG_NAME;
  public PVERSIONID = HiSysEventUtil.getVersionName(PKG_NAME);
  public LOCAL_DEV_TYPE = DeviceHelper.getDeviceType();
  public STATE: number;
  public WIFI_STATE: number;
  public BLUETOOTH_STATE: number;

  constructor(state: number, wifiState: number, bluetoothState: number) {
    this.STATE = state;
    this.WIFI_STATE = wifiState;
    this.BLUETOOTH_STATE = bluetoothState;
  }
}

class UEFailDialogEvent {
  public PNAMEID: string = PKG_NAME;
  public PVERSIONID = HiSysEventUtil.getVersionName(PKG_NAME);
  public LOCAL_DEV_TYPE = DeviceHelper.getDeviceType();
  public STATE: number;
  public ERROR_CODE: number;

  constructor(state: number, errorCode: number) {
    this.STATE = state;
    this.ERROR_CODE = errorCode;
  }
}