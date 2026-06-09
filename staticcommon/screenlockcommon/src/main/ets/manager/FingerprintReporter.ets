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

import osAccount from '@ohos.account.osAccount';
import { SingletonHelper, LogDomain, LogHelper } from '@ohos/basicutils';
import power from '@ohos.power';
// import fingerprintMgr from '@hms.userIAM.fingerAuthManager';
import type { BusinessError } from '@ohos.base';

const TAG = 'FingerprintReporter';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const REPORT_MODEL_FP: string = 'KG_FP';

const REPORT_MODEL_FACE: string = 'KG_FACE';

const REPORT_MODEL_PWD: string = 'KG_PWD';

const REPORT_MODEL_OTHER: string = 'KG_OTHER';

const REPORT_SCREEN_ON: string = '1';

const REPORT_SCREEN_OFF: string = '0';

const REPORT_COMMAND: number = 20041;

const REPORT_CURRENT_TIME: number = 60000;

export enum UnlockStage {
  START_UNLOCK = 0,
  END_UNLOCK = 1
}

class FingerprintReportData {
  public version: string = '0';
  public model: string = REPORT_MODEL_OTHER;
  public isScreenOn: string = REPORT_SCREEN_ON;
  public startTimeUnlock: string = '';
  public endTimeUnlock: string = '';
}


export class FingerprintReporter {
  private fingerprintReportData: FingerprintReportData = new FingerprintReportData();

  private resetReportData(): void {
    this.fingerprintReportData.model = REPORT_MODEL_OTHER;
    this.fingerprintReportData.isScreenOn = REPORT_SCREEN_ON;
    this.fingerprintReportData.startTimeUnlock = '';
    this.fingerprintReportData.endTimeUnlock = '';
  }

  private setUnLockModel(authType: osAccount.AuthType | undefined): void {
    if (!authType) {
      this.fingerprintReportData.model = REPORT_MODEL_OTHER;
      return;
    }
    switch (authType) {
      case osAccount.AuthType.PIN:
        this.fingerprintReportData.model = REPORT_MODEL_PWD;
        break;
      case osAccount.AuthType.FACE:
        this.fingerprintReportData.model = REPORT_MODEL_FACE;
        break;
      case osAccount.AuthType.FINGERPRINT:
        this.fingerprintReportData.model = REPORT_MODEL_FP;
        break;
      case osAccount.AuthType.DOMAIN:
        this.fingerprintReportData.model = REPORT_MODEL_PWD;
        break;
      default:
        this.fingerprintReportData.model = REPORT_MODEL_PWD;
        break;
    }
    log.showInfo(`set unlockModel to ${this.fingerprintReportData.model}`);
  }

  private getCurrentTime(): string {
    const date = new Date();
    const currentTime: string = new Date(date.getTime() - (date.getTimezoneOffset() * REPORT_CURRENT_TIME))
      .toISOString().split('Z')[0].replace(/[^\d]/gi, '');
    log.showInfo(`current time is ${currentTime}`);
    return currentTime;
  }

  private setUnlockStartTime(): void {
    this.fingerprintReportData.startTimeUnlock = this.getCurrentTime();
    log.showInfo(`set startTimeUnlock to ${this.fingerprintReportData.startTimeUnlock}`);
  }

  private setUnlockEndTime(): void {
    this.fingerprintReportData.endTimeUnlock = this.getCurrentTime();
    log.showInfo(`set endTimeUnlock to ${this.fingerprintReportData.endTimeUnlock}`);
  }


  private setIsScreenOn(): void {
    try {
      const currentIsActive: boolean = power.isActive();
      this.fingerprintReportData.isScreenOn = currentIsActive ? REPORT_SCREEN_ON : REPORT_SCREEN_OFF;
    } catch (e) {
      this.fingerprintReportData.isScreenOn = '';
      log.showInfo(`set isScreenOn fail(code ${e?.code})`);
    }
    log.showDebug(`set isScreenOn to ${this.fingerprintReportData.isScreenOn}`);
  }

  /**
   * key guard unlock report
   *
   * @param authType authType
   * @param unlockStage unlock stage
   */
  public kgUnlockReport(authType: osAccount.AuthType | undefined, unlockStage: UnlockStage): void {
    log.showInfo(`kgUnlockReport authType: ${authType}, unlockStage:${unlockStage}`);
    switch (unlockStage) {
      case UnlockStage.START_UNLOCK:
        this.resetReportData();
        this.setUnLockModel(authType);
        this.setUnlockStartTime();
        this.setIsScreenOn();
        break;
      case UnlockStage.END_UNLOCK:
        this.setUnlockEndTime();
        this.doReport();
        break;
    }
  }

  private doReport(): void {
    const reportData: string = JSON.stringify(this.fingerprintReportData);
    this.sendCommand(REPORT_COMMAND, reportData);
  }

  private stringToUint8Array(str: string): Uint8Array {
    let arr: number[] = [];
    for (let i: number = 0, j = str.length; i < j; ++i) {
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
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      log.showError(`fingerprint manager send command fail ${e.code}`);
    }
  }
}

// 单例
export let fingerprintReporter: FingerprintReporter = SingletonHelper.getInstance(FingerprintReporter, TAG);