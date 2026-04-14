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
import hiSysEvent from '@ohos.hiSysEvent'
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { StringUtil } from '../common/model/StringUtil';

const TAG = 'DfxSceneBoard';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const DEVICE_TYPE_MAP = new Map<string, string>([['PHONE', '00E'], ['2IN1', 'A2F'],
  ['PAD', '011'], ['AUDIO', '082'], ['CAR', '083'], ['HEADSET', '082'], ['SPEAKER', '00A']]);
const brMacFlag = ':';

export enum BizScene {
  plCardShowPreDevice = 1,
  plCardShowRefreshDevice = 2,
  plCardStartContinuity = 3,
  plCardStopContinuity = 4,
}

export enum BizStage {
  STAGE1 = 1,
  STAGE2 = 2,
  STAGE3 = 3,
  STAGE4 = 4,
  STAGE5 = 5,
  STAGE6 = 6,
  STAGE7 = 7,
}

export enum StageRes {
  IDLE = 0,
  SUCCESS = 1,
  FAILED = 2,
  CANCEL = 3,
  UNKNOWN = 4,
}

export enum BizState {
  START = 1,
  STOP = 2,
}

export enum TriggerMode {
  PLUGINCARD = 0,
  LISTPAGE = 1,
}

export enum ErrCode {
  PLIUGIN_CARD_SUBSCRIBE_FAILED = 461769667,
  START_COLLABORATION_TIMEOUT = 461769668,
}

export class DfxSceneBoard {
  private static instance: DfxSceneBoard | undefined | null = undefined;
  private hasEndReport: boolean = false;
  private maxNameLength: number = 7;
  private minNameLength: number = 3;
  private maxBtMacLength: number = 14;
  private minBtMacLength: number = 9;
  private middleBtMacLength: number = 11;
  private middleBtMacLengthNext: number = 12;

  static getInstance(): DfxSceneBoard {
    if (!DfxSceneBoard.instance) {
      log.showDebug('first init DfxSceneBoard');
      DfxSceneBoard.instance = new DfxSceneBoard();
    }
    return DfxSceneBoard.instance;
  }

  reportPluginCardShow(dfxReportInfo: DfxReportSceneInfo): void {
    log.info(TAG, 'reportPluginCardShow');
    let event: SCBShowCardReDevice = new SCBShowCardReDevice(dfxReportInfo);
    this.reportSceneBoardEvent(event);
    this.hasEndReport = false;
  }

  reportCallBackToSD(dfxReportInfo: DfxReportSceneInfo): void {
    log.info(TAG, 'reportCallBackToSD');
    let event: SBtoSPCallbackErr = new SBtoSPCallbackErr(dfxReportInfo);
    this.reportSceneBoardEvent(event);
  }

  reportShowDevice(dfxReportInfo: DfxReportSceneInfo, reportList?: string): void {
    log.info(TAG, 'reportShowDevice');

    if (this.hasEndReport === false) {
      log.info(TAG, 'hasEndReport = false');
      if (reportList?.length === 0) {
        let event: SCBShowCardReDevice = new SCBShowCardReDevice(dfxReportInfo);
        this.reportSceneBoardEvent(event);
      } else {
        let event: SCBShowCardReDevice = new SCBShowCardReDevice(dfxReportInfo, reportList);
        this.reportSceneBoardEvent(event);
      }
      this.hasEndReport = true;
    } else {
      log.info(TAG, 'hasEndReport = true');
      return
    }
  }

  reportReDevice(dfxReportInfo: DfxReportSceneInfo): void {
    log.info(TAG, 'reportReDevice');
    let event: SCBShowCardReDevice = new SCBShowCardReDevice(dfxReportInfo);
    this.reportSceneBoardEvent(event);
  }

  reportClickAndShowState(dfxReportInfo: DfxReportSceneInfo, showInfo: DfxDeviceInfo): void {
    log.info(TAG, 'reportClickAndShowState');
    let event: SBClickAndShowState = new SBClickAndShowState(dfxReportInfo, showInfo);
    this.reportSceneBoardEvent(event);
  }

  getAnonymousDeviceUdID(deviceUdID: string): string {
    if (deviceUdID.length < 10) {
      log.error(TAG, 'getAnonymousDeviceUdID, wrong deviceIdId, return empty');
      return '';
    }
    return deviceUdID.substring(0, 5) + '**' + deviceUdID.substring(deviceUdID.length - 5);
  }

  getAnonymousDeviceName(deviceName: string): string {
    if (deviceName.length == 0) {
      log.error(TAG, 'getAnonymousDeviceName, wrong deviceName, return empty');
      return '';
    }
    if (deviceName.length > this.maxNameLength) {
      return deviceName.substring(0, this.minNameLength) + '**' +
      deviceName.substring(deviceName.length - this.minNameLength);
    } else if (deviceName.length > this.minNameLength && deviceName.length < this.maxNameLength) {
      return deviceName.substring(0, this.minNameLength) + '**';
    } else {
      return deviceName + '**';
    }
  }

  getAnonymousBtMAC(btMAC: string): string {
    if (btMAC.length != 17) {
      log.error(TAG, 'getAnonymousBtMAC, wrong btMAC, return empty');
      return '';
    }
    return btMAC.substring(0, this.minBtMacLength) + '**' +
    btMAC.substring(this.middleBtMacLength, this.middleBtMacLengthNext) + '**' + btMAC.substring(this.maxBtMacLength);
  }

  getStandardErrorCode(subSystemId: number, moduleId: number, errorCode: number ): number {
    let res: number = (subSystemId << 21) | (moduleId << 16) | errorCode;
    return res;
  }

  getDeviceType(deviceName: string, deviceClass?: string): string | undefined {
    let deviceType = DEVICE_TYPE_MAP.has(deviceName) ?
    DEVICE_TYPE_MAP.get(deviceName) : deviceName;
    if (deviceClass) {
      deviceType = DEVICE_TYPE_MAP.has(deviceClass) ?
      DEVICE_TYPE_MAP.get(deviceClass) : deviceType
    }
    return deviceType;
  }

  isBrMac(brMac: string): boolean {
    return brMac.includes(brMacFlag);
  }

  getAnonymousDeviceId(deviceId: string): string {
    if (StringUtil.checkStrIsEmpty(deviceId)) {
      return '';
    }

    let isBrMacStr = this.isBrMac(deviceId);
    if (isBrMacStr) {
      return this.getAnonymousBtMAC(deviceId);
    } else {
      return this.getAnonymousDeviceUdID(deviceId);
    }
  }

  reportSceneBoardEvent(event: SPEvent): void {
    let eventInfo: hiSysEvent.SysEventInfo = {
      domain: 'COLLABORATIONFWK',
      name: 'SUPER_DEVICE_BEHAVIOR',
      eventType: hiSysEvent.EventType.BEHAVIOR,
      params: event
    };
    log.info(TAG, 'start hiSysEvent write');
    hiSysEvent.write(eventInfo)
    log.info(TAG, 'stop hiSysEvent write');
  }
}

export interface DfxReportSceneInfo {
  FUNC: string;
  BIZ_SCENE: number;
  BIZ_STAGE: number;
  STAGE_RES: number;
  BIZ_STATE?: number;
  ERROR_CODE?: number;
  TRIGGER_MODE?: number;
  CONCURRENT_ID?: string;
}

export interface DfxDeviceInfo {
  PEER_UDID?: string;
  PEER_DEV_NAME: string;
  PEER_BT_MAC: string;
  PEER_NET_ID: string;
  PEER_DEV_TYPE?: string;
  SERVICE_NAME: string;
}

export interface DfxReportOnlineDevice {
  PEER_UDID: string;
  PEER_DEV_NAME: string;
  PEER_BT_MAC: string;
  PEER_NET_ID: string;
  PEER_DEV_TYPE: string;
  PEER_SUPPORT_RULE_LIST: string;
}

class SCBShowCardReDevice {
  public ORG_PKG: string = 'com.ohos.superdevice';
  public FUNC: string;
  public BIZ_SCENE: number;
  public BIZ_STAGE: number;
  public STAGE_RES: number;
  public BIZ_STATE?: number;
  public SUPPORT_DEVICE_LIST?: string;

  constructor(dfxReportInfo: DfxReportSceneInfo, reportList?: string) {
    this.FUNC = dfxReportInfo.FUNC
    this.BIZ_SCENE = dfxReportInfo.BIZ_SCENE;
    this.BIZ_STAGE = dfxReportInfo.BIZ_STAGE;
    this.STAGE_RES = dfxReportInfo.STAGE_RES;
    this.BIZ_STATE = dfxReportInfo.BIZ_STATE;
    this.SUPPORT_DEVICE_LIST = reportList;
  }
}

class SBtoSPCallbackErr {
  public ORG_PKG: string = 'com.ohos.superdevice';
  public FUNC: string;
  public BIZ_SCENE: number;
  public BIZ_STAGE: number;
  public STAGE_RES: number;
  public ERROR_CODE?: number;

  constructor(dfxReportInfo: DfxReportSceneInfo) {
    this.FUNC = dfxReportInfo.FUNC
    this.BIZ_SCENE = dfxReportInfo.BIZ_SCENE;
    this.BIZ_STAGE = dfxReportInfo.BIZ_STAGE;
    this.STAGE_RES = dfxReportInfo.STAGE_RES;
    this.ERROR_CODE = dfxReportInfo.ERROR_CODE;
  }
}

class SBClickAndShowState {
  public ORG_PKG: string = 'com.ohos.superdevice';
  public FUNC: string;
  public BIZ_SCENE: number;
  public BIZ_STAGE: number;
  public STAGE_RES: number;
  public BIZ_STATE?: number;
  public PEER_UDID?: string;
  public PEER_DEV_NAME: string;
  public PEER_BT_MAC: string;
  public PEER_NET_ID: string;
  public PEER_DEV_TYPE?: string;
  public SERVICE_NAME: string;
  public TRIGGER_MODE?: number;
  public CONCURRENT_ID?: string;

  constructor(dfxReportInfo: DfxReportSceneInfo, dfxDeviceInfo: DfxDeviceInfo) {
    this.FUNC = dfxReportInfo.FUNC
    this.BIZ_SCENE = dfxReportInfo.BIZ_SCENE;
    this.BIZ_STAGE = dfxReportInfo.BIZ_STAGE;
    this.STAGE_RES = dfxReportInfo.STAGE_RES;
    this.BIZ_STATE = dfxReportInfo.BIZ_STATE;
    this.PEER_UDID = dfxDeviceInfo.PEER_UDID;
    this.PEER_DEV_NAME = dfxDeviceInfo.PEER_DEV_NAME;
    this.PEER_BT_MAC = dfxDeviceInfo.PEER_BT_MAC;
    this.PEER_NET_ID = dfxDeviceInfo.PEER_NET_ID;
    this.PEER_DEV_TYPE = dfxDeviceInfo.PEER_DEV_TYPE;
    this.SERVICE_NAME = dfxDeviceInfo.SERVICE_NAME;
    this.TRIGGER_MODE = dfxReportInfo.TRIGGER_MODE;
    this.CONCURRENT_ID = dfxReportInfo.CONCURRENT_ID;
  }
}

type SPEvent = SCBShowCardReDevice | SBtoSPCallbackErr | SBClickAndShowState