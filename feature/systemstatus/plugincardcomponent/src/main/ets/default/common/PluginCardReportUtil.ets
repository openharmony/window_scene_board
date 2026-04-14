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
import {
  DeviceHelper,
  HiSysEventUtil
} from '@ohos/frameworkwrapper';
import hiSysEvent from '@ohos.hiSysEvent';
import { BusinessError } from '@kit.BasicServicesKit';
import { DeviceShowInfo } from './model/DeviceShowInfo';
import { DeviceStateInfo } from './model/DeviceStateInfo';
import { DeviceItem } from '../controller/PluginCardController';
import { ContinuityState } from './model/ContinuityState';
import Constants from './model/Constants';
import { DeviceType } from './model/DeviceType';

const PKG_NAME = 'com.ohos.sceneboard'
const TAG = 'Model.PluginCardReportUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const DEVICE_TYPE_MAP = new Map<string, string>([['phone', 'PHONE'], ['2in1', '2IN1'], ['tablet', 'PAD'], ['car', 'SMART_CAR']]);
const DEVICE_TYPE = DeviceHelper.getDeviceType();
const deviceTypeIconMap: Map<string, Resource> =
  new Map<string, Resource>([
    [DeviceType.PHONE, $r('sys.symbol.phone_fill_1')],
    [DeviceType.LAPTOP, $r('sys.symbol.matebook_fill')],
    [DeviceType.TWO_IN_ONE, $r('sys.symbol.matebook_fill')],
    [DeviceType.TABLET, $r('sys.symbol.pad_fill')],
    [DeviceType.SMART_CAR, $r('sys.symbol.car_fill')]
  ]);
export default class PluginCardReportUtil {
  /**
   * 上报进入列表页事件
   *
   * @param triggerMode 触发位置
   * @param hasDevice 是否有设备
   */
  public reportUEEnterListPageEvent(triggerMode: string, hasDevice: number): void {
    let event: UEEnterListPageEvent = new UEEnterListPageEvent(triggerMode, hasDevice);
    this.reportUEEvent(Constants.ENTER_LIST_PAGE, event);
  }

  /**
   * 上报打开蓝牙wifi事件
   */
  public reportUEClickOpenWLANBtEvent(): void {
    this.reportUEEvent(Constants.CLICK_OPEN_WLANANDBLUETOOTH, new UEClickOpenWLANBtEvent());
  }

  /**
   * 上报打开wifi事件
   */
  public reportUEClickOpenWLANEvent(): void {
    this.reportUEEvent(Constants.CLICK_OPEN_WLAN, new UEClickOpenWLANEvent());
  }

  /**
   * 上报打开蓝牙事件
   */
  public reportUEClickOpenBluetoothEvent(): void {
    this.reportUEEvent(Constants.CLICK_OPEN_BLUETOOTH, new UEClickOpenBluetoothEvent());
  }

  /**
   * 上报登录账号事件
   */
  public reportUEClickOpenHWAccountEvent(): void {
    this.reportUEEvent(Constants.CLICK_OPEN_HWACCOUNT, new UEClickOpenHWAccountEvent());
  }

  public getDeviceTypeIcon(deviceType: string): Resource | undefined {
    return deviceTypeIconMap.get(deviceType);
  }

  /**
   * 上报协同成功、失败事件
   *
   * @param deviceListCur 当前设备列表
   * @param deviceStateInfo 设备状态信息
   * @param deviceListPre 旧设备列表
   */
  public reportUECollaborationStateEvent(deviceListCur: DeviceShowInfo[] | undefined,
    deviceStateInfo: DeviceStateInfo | undefined, deviceListPre: DeviceItem[]): void {
    if (!deviceListCur && !deviceStateInfo) {
      return;
    } else if (deviceListCur) {
      this.reportCollaborationState(deviceListCur, deviceListPre);
    } else if (deviceStateInfo) {
      this.reportCollaborationError(deviceListPre, deviceStateInfo);
    }
  }

  private reportCollaborationState(deviceListCur: DeviceShowInfo[], deviceListPre: DeviceItem[]): void {
    for (let i = 0; i < deviceListCur.length; i++) {
      const index = deviceListPre.findIndex((device) => (device.showInfo.uniqueId === deviceListCur[i].uniqueId));
      if (index < 0) {
        continue;
      }

      if (!deviceListPre[index].showInfo.getIsClickPluginCard()) {
        continue;
      }

      let previousState = this.getCurrentState(deviceListPre[index].showInfo);
      let currentState = this.getCurrentState(deviceListCur[i]);
      if (currentState === ContinuityState.PREPARE || currentState == ContinuityState.CONNECTING) {
        return;
      }

      let isReportSuccess: boolean = this.judgeUpdateState(previousState, currentState, deviceListCur[i].deviceType,
        '', deviceListPre[index].showInfo.deviceClass);
      if (isReportSuccess) {
        deviceListPre[index].showInfo.setIsClickPluginCard(false);
      }
    }
  }

  private reportCollaborationError(deviceListPre: DeviceItem[], deviceStateInfo: DeviceStateInfo): void {
    const index = deviceListPre.findIndex(device => (device.showInfo.uniqueId === deviceStateInfo.key));
    if (!deviceListPre[index].showInfo.getIsClickPluginCard()) {
      return;
    }

    let previousState: number = this.getCurrentState(deviceListPre[index].showInfo);
    let isReportSuccess: boolean = this.judgeUpdateState(previousState, deviceStateInfo.state,
      deviceListPre[index].showInfo.deviceType, deviceStateInfo.errorCode, deviceListPre[index].showInfo.deviceClass);
    if (isReportSuccess) {
      deviceListPre[index].showInfo.setIsClickPluginCard(false);
    }
  }

  private judgeUpdateState(previousState: number, currentState: number, remoteDeviceType: string,
    errorCode?: string, deviceClass?: string): boolean {
    log.info(TAG, `UE report previousState: ${previousState}` + ` currentState: ${currentState}`);
    let deviceType = remoteDeviceType === Constants.AUDIO && deviceClass ? deviceClass : remoteDeviceType;
    if (errorCode && errorCode.length > 0) {
      // Failed ContinuityState, errorCode
      this.reportUEDeviceCollaborationEvent(deviceType, Constants.REPORT_COLLABORATION_FAIL, errorCode);
      return true;
    } else {
      // Success ContinuityState
      if ((previousState === ContinuityState.IDLE || previousState === ContinuityState.PREPARE ||
        previousState === ContinuityState.CONNECTING) &&
        currentState === ContinuityState.CONNECTED) {
        // CONNECTING->CONNECTED
        this.reportUEDeviceCollaborationEvent(deviceType, Constants.REPORT_COLLABORATION_SUCCEED, '');
        return true;
      } else if ((previousState === ContinuityState.CONNECTED || previousState === ContinuityState.DISCONNECTING) &&
        currentState === ContinuityState.IDLE) {
        // CONNECTED->IDLE
        this.reportUEDeviceCollaborationEvent(deviceType, Constants.REPORT_COLLABORATION_SUCCEED, '', true);
        return true;
      }
    }

    return false;
  }

  private getCurrentState(showInfo: DeviceShowInfo): ContinuityState {
    const currentService = this.getCurrentServiceName(showInfo);
    if (currentService.length === 0) {
      log.showError('serviceName is null');
      return ContinuityState.IDLE;
    }
    const serviceIndex = showInfo.serviceRuleList.findIndex(service => service.serviceName === currentService);
    if (serviceIndex < 0) {
      log.showError('current service do not support');
      return ContinuityState.IDLE;
    }
    return showInfo.serviceRuleList[serviceIndex].state;
  }

  private getCurrentServiceName(showInfo: DeviceShowInfo): string {
    const serviceIndex = showInfo.serviceRuleList.findIndex(service => service.priority === 0);
    if (serviceIndex < 0) {
      log.showError('current service do not support');
      return '';
    }
    return showInfo.serviceRuleList[serviceIndex].serviceName;
  }

  private reportUEDeviceCollaborationEvent(remoteDeviceType: string, collaborationResult: number,
    collaborationErrCode: string, isCancelContinuity: boolean = false, remoteDeviceFramework?: string,
    deviceClass?: string): void {
    let localDeviceType = DEVICE_TYPE_MAP.get(DEVICE_TYPE);
    if ((localDeviceType === Constants.PHONE && (remoteDeviceType === Constants.PC ||
      remoteDeviceType === Constants.INI) || ((localDeviceType === Constants.PC ||
      localDeviceType === Constants.INI) && remoteDeviceType === Constants.PHONE))) {
      let event = this.getCollaborationEvent(remoteDeviceType, collaborationResult,
        collaborationErrCode, isCancelContinuity);
      this.reportUEEvent(isCancelContinuity ? Constants.CANCEL_PHONE_PC_COLLABORATION :
      Constants.PHONE_PC_COLLABORATION, event);
    } else if ((localDeviceType === Constants.PHONE && remoteDeviceType === Constants.PAD) ||
      (localDeviceType === Constants.PAD && remoteDeviceType === Constants.PHONE)) {
      let event = this.getCollaborationEvent(remoteDeviceType, collaborationResult,
        collaborationErrCode, isCancelContinuity);
      this.reportUEEvent(isCancelContinuity ? Constants.CANCEL_PHONE_PAD_COLLABORATION :
      Constants.PHONE_PAD_COLLABORATION, event);
    } else if (remoteDeviceType === Constants.AUDIO || remoteDeviceType === Constants.SPEAKER ||
      remoteDeviceType === Constants.HEADSET) {
      let event = this.getCollaborationEvent(remoteDeviceType, collaborationResult,
        collaborationErrCode, isCancelContinuity);
      this.reportUEEvent(isCancelContinuity ? Constants.CANCEL_AUDIO_COLLABORATION :
      Constants.AUDIO_COLLABORATION, event);
    }
 }

  private getCollaborationEvent(remoteDeviceType: string, collaborationResult: number,
    collaborationErrCode: string, isCancelContinuity: boolean = false): UEEvent {
    let event = isCancelContinuity ? new UECancelDeviceCollaborationEvent(remoteDeviceType,
      collaborationResult, collaborationErrCode) : new UEDeviceCollaborationEvent(remoteDeviceType,
      collaborationResult, collaborationErrCode);
    return event;
  }

  private reportUEEvent(eventName: string, event: UEEvent): void {
    let eventInfo: hiSysEvent.SysEventInfo = {
      domain: Constants.SUPER_DEVICE_UE_DOMAIN,
      name: eventName,
      eventType: hiSysEvent.EventType.BEHAVIOR,
      params: event
    };
    try {
      hiSysEvent.write(eventInfo);
    } catch (err) {
      log.error(`reportUEEvent err: ${(err as BusinessError).code}, ${(err as BusinessError).message}`);
    }
  }
}

export const pluginCardReportUtil = new PluginCardReportUtil();

type UEEvent = UEEnterListPageEvent | UEClickOpenWLANBtEvent | UEClickOpenWLANEvent |
UEClickOpenBluetoothEvent | UEClickOpenHWAccountEvent | UEDeviceCollaborationEvent | UECancelDeviceCollaborationEvent;

class UEEnterListPageEvent {
  public PNAMEID: string = PKG_NAME;
  public PVERSIONID = HiSysEventUtil.getVersionName(PKG_NAME);
  public TRIGGER_MODE: string;
  public HAS_DEVICE: number;

  constructor(triggerMode: string, hasDevice: number) {
    this.TRIGGER_MODE = triggerMode;
    this.HAS_DEVICE = hasDevice;
  }
}

class UEClickOpenWLANBtEvent {
  public PNAMEID: string = PKG_NAME;
  public PVERSIONID = HiSysEventUtil.getVersionName(PKG_NAME);
}

class UEClickOpenWLANEvent {
  public PNAMEID: string = PKG_NAME;
  public PVERSIONID = HiSysEventUtil.getVersionName(PKG_NAME);
}

class UEClickOpenBluetoothEvent {
  public PNAMEID: string = PKG_NAME;
  public PVERSIONID = HiSysEventUtil.getVersionName(PKG_NAME);
}

class UEClickOpenHWAccountEvent {
  public PNAMEID: string = PKG_NAME;
  public PVERSIONID = HiSysEventUtil.getVersionName(PKG_NAME);
}

class UEDeviceCollaborationEvent {
  public PNAMEID: string = PKG_NAME;
  public PVERSIONID = HiSysEventUtil.getVersionName(PKG_NAME);
  public LOCAL_DEVICE_TYPE = DEVICE_TYPE_MAP.has(DEVICE_TYPE)
    ? DEVICE_TYPE_MAP.get(DEVICE_TYPE) : DEVICE_TYPE;
  public REMOTE_DEVICE_TYPE: string;
  public COLLABORATION_RESULT: number;
  public COLLABORATION_ERRCODE: string;
  public TRIGGER_LOCATION: string = Constants.REPORT_TRIGGER_LOCATION;
  public REMOTE_DEVICE_FRAMEWORK: string;

  constructor(remoteDeviceType: string, collaborationResult: number, collaborationErrcode: string,
    remoteDeviceFramework?: string, ) {
    this.REMOTE_DEVICE_TYPE = remoteDeviceType;
    this.COLLABORATION_RESULT = collaborationResult;
    this.COLLABORATION_ERRCODE = collaborationErrcode;
    this.REMOTE_DEVICE_FRAMEWORK = remoteDeviceFramework ?? '';
  }
}

class UECancelDeviceCollaborationEvent {
  public PNAMEID: string = PKG_NAME;
  public PVERSIONID = HiSysEventUtil.getVersionName(PKG_NAME);
  public LOCAL_DEVICE_TYPE = DEVICE_TYPE_MAP.has(DEVICE_TYPE)
    ? DEVICE_TYPE_MAP.get(DEVICE_TYPE) : DEVICE_TYPE;
  public REMOTE_DEVICE_TYPE: string;
  public CANCEL_COLLABORATION_RESULT: number;
  public CANCEL_COLLABORATION_ERRCODE: string;
  public TRIGGER_LOCATION: string = Constants.REPORT_TRIGGER_LOCATION;
  public REMOTE_DEVICE_FRAMEWORK: string;

  constructor(remoteDeviceType: string,
    cancelCollaborationResult: number, cancelCollaborationErrcode: string, remoteDeviceFramework?: string) {
    this.REMOTE_DEVICE_TYPE = remoteDeviceType;
    this.CANCEL_COLLABORATION_RESULT = cancelCollaborationResult;
    this.CANCEL_COLLABORATION_ERRCODE = cancelCollaborationErrcode;
    this.REMOTE_DEVICE_FRAMEWORK = remoteDeviceFramework ?? '';
  }
}