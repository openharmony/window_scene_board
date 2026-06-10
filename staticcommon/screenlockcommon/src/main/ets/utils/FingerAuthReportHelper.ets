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

// import fingerprintMgr from '@hms.userIAM.fingerAuthManager';
import type { BusinessError } from '@ohos.base';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AuthType } from './AccountHelper';
import { PowerUtils } from './PowerUtils';

const TAG = 'FingerAuthReportHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const REPORT_VERSION = '0';
const REPORT_COMMAND: number = 20041;
const REPORT_CURRENT_TIME: number = 60000;

/**
 * 解锁方式
 */
enum UnlockModel {
  /**
   * 指纹
   */
  KG_FP = 'KG_FP',

  /**
   * 人脸
   */
  KG_FACE = 'KG_FACE',

  /**
   * 密码
   */
  KG_PWD = 'KG_PWD',

  /**
   * 其他
   */
  KG_OTHER = 'KG_OTHER',
}

/**
 * 屏幕状态
 */
enum ScreenStatus {
  /**
   * 灭屏
   */
  OFF = '0',

  /**
   * 亮屏
   */
  ON = '1',
}

/**
 * 上报数据
 */
class ReportData {
  /**
   * 版本号
   */
  public version: string = REPORT_VERSION;

  /**
   * 解锁方式
   */
  public model: string;

  /**
   * 解锁时是亮屏还是灭屏
   */
  public isScreenOn: string = ScreenStatus.ON;

  /**
   * 锁屏应用接收到认证成功的信息马上记录的时间
   */
  public startTimeUnlock: string = '';

  /**
   * 通知桌面入场的时间，但是桌面可能还没有入场完，如果要感知桌面入场的时间，就要找桌面的同事下发时间戳
   */
  public endTimeUnlock: string = '';

  constructor(model: string) {
    this.model = model;
  }

  public reset(): void {
    this.isScreenOn = ScreenStatus.ON;
    this.startTimeUnlock = '';
    this.endTimeUnlock = '';
  }

  public setIsScreenOn(): void {
    this.isScreenOn = PowerUtils.isActive() ? ScreenStatus.ON : ScreenStatus.OFF;
    log.showDebug(`set isScreenOn to ${this.isScreenOn}`);
  }

  public setUnlockStartTime(): void {
    this.startTimeUnlock = this.getCurrentTime();
    log.showInfo(`set startTimeUnlock to ${this.startTimeUnlock}`);
  }

  public setUnlockEndTime(): void {
    this.endTimeUnlock = this.getCurrentTime();
    log.showInfo(`set endTimeUnlock to ${this.endTimeUnlock}`);
  }

  public isHasSetStartTime(): boolean {
    return this.startTimeUnlock !== '';
  }

  private getCurrentTime(): string {
    const date = new Date();
    const currentTime: string = new Date(date.getTime() - (date.getTimezoneOffset() * REPORT_CURRENT_TIME))
      .toISOString().split('Z')[0].replace(/[^\d]/gi, '');
    log.showInfo(`current time is ${currentTime}`);
    return currentTime;
  }
}

/**
 * 指纹大数据上报工具类
 */
export class FingerAuthReportHelper {
  private static sInstance: FingerAuthReportHelper;

  public static getInstance(): FingerAuthReportHelper {
    if (FingerAuthReportHelper.sInstance == null) {
      FingerAuthReportHelper.sInstance = new FingerAuthReportHelper();
    }
    return FingerAuthReportHelper.sInstance;
  }

  private readonly _reportDataMap: Map<UnlockModel, ReportData> = new Map();

  private constructor() {
    this._reportDataMap.set(UnlockModel.KG_FP, new ReportData(UnlockModel.KG_FP));
    this._reportDataMap.set(UnlockModel.KG_FACE, new ReportData(UnlockModel.KG_FACE));
    this._reportDataMap.set(UnlockModel.KG_PWD, new ReportData(UnlockModel.KG_PWD));
    this._reportDataMap.set(UnlockModel.KG_OTHER, new ReportData(UnlockModel.KG_OTHER));
  }

  /**
   * 解锁上报
   *
   * @param authType authType
   * @param unlockStage unlock stage
   */
  public unlockReport(authType: number = 0, isStart: boolean = false): void {
    log.showInfo(`unlockReport authType: ${authType}, isStart:${isStart}`);
    let reportData: ReportData | undefined = this._reportDataMap.get(this.getUnlockModel(authType));
    if (!reportData) {
      return;
    }
    if (isStart) {
      reportData.reset();
      reportData.setIsScreenOn();
      reportData.setUnlockStartTime();
    } else {
      if (reportData.isHasSetStartTime()) {
        reportData.setUnlockEndTime();
        this.doReport(reportData);
      }
      reportData.reset();
    }
  }

  private getUnlockModel(authType: number): UnlockModel {
    switch (authType) {
      case AuthType.PIN:
      case AuthType.DOMAIN:
        return UnlockModel.KG_PWD;
      case AuthType.FACE:
        return UnlockModel.KG_FACE;
      case AuthType.FINGERPRINT:
        return UnlockModel.KG_FP;
      default:
        return UnlockModel.KG_OTHER;
    }
  }

  private doReport(reportData: ReportData): void {
    this.sendCommand(REPORT_COMMAND, JSON.stringify(reportData));
  }

  private stringToUint8Array(str: string): Uint8Array {
    let arr: number[] = [];
    for (let i = 0, j = str.length; i < j; ++i) {
      arr.push(str.charCodeAt(i));
    }
    arr.push(0);
    let tmpUint8Array: Uint8Array = new Uint8Array(arr);
    return tmpUint8Array;
  }

  private sendCommand(command: number, reportData: string): void {
    log.showInfo(`fingerprint manager send command(${command}) data(${reportData}).`);
    let cmdInfo: Uint8Array = this.stringToUint8Array(reportData);
    try {
      this.doSendCommand(command, cmdInfo);
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      log.showError(`fingerprint manager send command fail ${e.code}`);
    }
  }

  private doSendCommand(command: number, cmdInfo: Uint8Array): void {
    // fingerprintMgr.sendCommand(command, cmdInfo, (err: BusinessError<void>, data: Uint8Array) => {
    //   log.showInfo(`fingerprint manager send command result code: ${err.code}`);
    //   if (err.code === 0) {
    //     log.showInfo('fingerprint manager send command success, start to parse data');
    //     let info: string = '';
    //     for (let i = 0; i < data.length; ++i) {
    //       let charA = String.fromCharCode(data[i]);
    //       info += charA;
    //     }
    //     log.showInfo(`fingerprint manager send command extraInfo: ${info}`);
    //   } else {
    //     log.showError(`fingerprint manager send command call fail: ${err.code}`);
    //   }
    // });
  }
}