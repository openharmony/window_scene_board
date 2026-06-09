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

// import simRemember from '@hms.telephony.enhanced';
import observer from '@ohos.telephony.observer';
import sim from '@ohos.telephony.sim';
import type { AsyncCallback, BusinessError, Callback } from '@ohos.base';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import type ArrayList from '@ohos.util.ArrayList';

const TAG = 'SimCardUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const MAX_SIM_CARD_COUNT = 2;
const PUK_INFO_LENGTH_2 = 2;
const PUK_PIN_LENGTH_4 = 4;
const PUK_PIN_LENGTH_8 = 8;
const PUK_INFO_LENGTH_8 = 8;
const PUK_ARRAY_LENGTH_2 = 2;

export class SimResult {
  private _retCode: number = -1;
  private _remain?: number = 0;

  public set retCode(value: number) {
    this._retCode = value;
  }

  public get retCode(): number {
    return this._retCode;
  }


  public set remain(value: number | undefined) {
    this._remain = value;
  }

  public get remain(): number | undefined {
    return this._remain;
  }
}

/**
 * SIM卡工具类
 */
export class SimCardUtils {
  private constructor() {
  }

  /**
   * 是否支持SIM相关功能
   *
   * @returns 是否支持
   */
  public static isSimCardSupport(): boolean {
    return canIUse('SystemCapability.Telephony.CoreService') && canIUse('SystemCapability.Telephony.StateRegistry');
  }

  /**
   * 获取最大支持的SIM数目
   *
   * @returns 最大支持的SIM数目
   */
  public static getMaxSimCount(): number {
    return Math.min(sim.getMaxSimCount(), MAX_SIM_CARD_COUNT);
  }

  /**
   * 同步获取SIM卡状态
   *
   * @param slotId slotID
   * @returns SIM卡状态
   */
  public static getSimStateSync(slotId: number): sim.SimState {
    return sim.getSimStateSync(slotId);
  }

  /**
   * 异步获取SIM卡状态
   *
   * @param slotId slotID
   * @returns SIM卡状态
   */
  public static async getSimState(slotId: number): Promise<sim.SimState> {
    try {
      return await sim.getSimState(slotId);
    } catch (error) {
      log.showError(`getSimState failed.`);
    }
    return sim.SimState.SIM_STATE_UNKNOWN;
  }

  /**
   * 查询SIM锁定类型
   *
   * @param slotId slotID
   * @returns SIM锁定类型
   */
  public static async getSimLockType(slotId: number): Promise<sim.LockType> {
    for (let simLockType of [sim.LockType.FDN_LOCK, sim.LockType.PIN_LOCK]) {
      if (await SimCardUtils.isLockTypeLockOn(slotId, simLockType)) {
        log.showDebug(`simLockType: ${simLockType}`);
        return simLockType;
      }
    }
    return sim.LockType.PIN_LOCK;
  }

  public static unlockPin(slotId: number, pin?: string, postHandle?: Function): SimResult {
    let result: SimResult = new SimResult();
    log.showInfo('unlockPin start');
    sim.unlockPin(slotId, pin).then((data: sim.LockStatusResponse) => {
      log.showInfo(`unlockPin ${slotId} success, promise: data->${JSON.stringify(data)}`);
      result.retCode = data?.result;
      result.remain = data?.remain;
    }).catch((err: BusinessError) => {
      log.showError(`unlockPin ${slotId} failed, promise: err->${JSON.stringify(err)}`);
    }).finally(() => {
      postHandle?.();
    });
    return result;
  }

  public static unlockPuk(slotId: number, pukInfo?: ArrayList<string>, postHandle?: Function): SimResult {
    let result: SimResult = new SimResult();
    if (!pukInfo || pukInfo.length !== PUK_INFO_LENGTH_2) {
      log.showError('unlockPuk failed, missing info.');
      return result;
    }
    const pukArray: string[] = pukInfo.convertToArray();
    const pukCode: string = pukArray[0];
    const newPin: string = pukArray[1];
    log.showInfo('unlockPuk start');
    sim.unlockPuk(slotId, newPin, pukCode).then((data: sim.LockStatusResponse) => {
      log.showInfo(`unlockPuk ${slotId} success, promise: data->${JSON.stringify(data)}`);
      result.retCode = data.result;
      result.remain = data.remain;
    }).catch((err: BusinessError) => {
      log.showError(`unlockPuk ${slotId} failed, promise: err->${JSON.stringify(err)}`);
    }).finally(() => {
      postHandle?.();
    });
    return result;
  }

  public static isValidPin(pin?: string): boolean {
    let length: number = pin?.length ?? 0;
    return length >= PUK_PIN_LENGTH_4 && length <= PUK_PIN_LENGTH_8;
  }

  public static isMatchedPin(pukArray: string[], pinConfirm?: string): boolean {
    if (pukArray?.length !== PUK_ARRAY_LENGTH_2) {
      return false;
    }
    const newPin: string = pukArray[1];
    return newPin === pinConfirm;
  }

  public static isValidPukCode(puk?: string): boolean {
    return puk?.length === PUK_INFO_LENGTH_8;
  }

  /**
   * 查询所有激活的SIM信息
   *
   * @param slotId SlotID
   * @param callback 查询回调
   * @returns true下发成功/false失败
   */
  public static getSimAccountInfo(slotId: number, callback: AsyncCallback<sim.IccAccountInfo>): boolean {
    try {
      sim.getSimAccountInfo(slotId, callback);
      log.showInfo('getSimAccountInfo success.');
      return true;
    } catch (error) {
      log.showError('getSimAccountInfo failed.');
    }
    return false;
  }

  /**
   * 查询所有激活的SIM信息
   * @param callback
   */
  public static getActiveSimAccountInfoList(callback: AsyncCallback<Array<sim.IccAccountInfo>>): void {
    try {
      sim.getActiveSimAccountInfoList(callback);
      log.showInfo('getActiveSimAccountInfoList success.');
    } catch (error) {
      log.showError('getActiveSimAccountInfoList failed.');
    }
  }

  /**
   * 注册SIM状态变化监听
   *
   * @param slotId slotID
   * @param callback 回调函数
   * @returns 是否注册成功
   */
  public static registerSimStateChangeListener(slotId: number, callback: Callback<observer.SimStateData>): boolean {
    try {
      log.showInfo(`registerSimStateChangeListener for slotId ${slotId}`);
      observer.on('simStateChange', { slotId: slotId }, callback);
      return true;
    } catch (error) {
      log.showError('registerSimStateChangeListener failed.');
    }
    return false;
  }

  /**
   * 注销SIM状态变化监听
   *
   * @param callback 回调函数
   */
  public static unRegisterSimStateChangeListener(callback: Callback<observer.SimStateData>): void {
    try {
      log.showInfo('unRegisterSimStateChangeListener');
      observer.off('simStateChange', callback);
    } catch (error) {
      log.showError('unRegisterSimStateChangeListener failed.');
    }
  }

  public static registerIccChangeListener(callback: Callback<void>): void {
    log.showInfo('registerIccChangeListener');
    try {
      observer.on('iccAccountInfoChange', callback);
    } catch (error) {
      log.showError('registerIccChangeListener failed.');
    }
    log.showInfo('registerIccChangeListener success');
  }

  public static unRegisterIccChangeListener(callback: Callback<void>): void {
    log.showInfo('unRegisterIccChangeListener');
    try {
      observer.off('iccAccountInfoChange', callback);
    } catch (error) {
      log.showError('unRegisterIccChangeListener failed.');
    }
    log.showInfo('unRegisterIccChangeListener success');
  }

  private static async isLockTypeLockOn(slotId: number, simLockType: sim.LockType): Promise<boolean> {
    try {
      return (await sim.getLockState(slotId, simLockType)) === sim.LockState.LOCK_ON;
    } catch (error) {
      log.showError(`getLockState failed.`);
    }
    return false;
  }

  public static setPinSavingFlag(slotId: number, enabled: boolean, pinCode?: string): void {
    try {
      // simRemember.setPinSavingFlag(slotId, enabled, pinCode).then((val:ESObject) => {
      //   log.showInfo(`setPinSavingFlag slotId ${slotId} enabled ${enabled}  result ${val.result}`);
      // }).catch((err: Error) => {
      //   let error: BusinessError = err as BusinessError;
      //   log.showInfo(`setPinSavingFlag err, slotId ${slotId} enabled ${enabled} code ${error?.code} ${error?.message}`);
      // });
    } catch (e) {
      log.showError('setPinSavingFlag err');
    }
  }

  public static getPinSavingSupported(): boolean {
    try {
      // let pinSavingSupported: boolean = simRemember.isPinSavingSupported();
      // log.showInfo(`getPinSavingSupported ${pinSavingSupported}`);
      // return pinSavingSupported;
      return false
    } catch (err) {
      log.showError(`getPinSavingSupported err: ${err?.message} code: ${err?.code}`);
      return false;
    }
  }

  public static async isPinSavingEnabled(slotId: number): Promise<boolean> {
    try {
      // let isPinSavingEnabled:ESObject = await simRemember.isPinSavingEnabled(slotId);
      // log.showInfo(`isPinSavingEnabled ${isPinSavingEnabled} slotId ${slotId}`);
      // return isPinSavingEnabled;
      return false
    } catch (err) {
      log.showError('isPinSavingEnabled err');
      return new Promise((resolve) => {
        resolve(false);
      });
    }
  }

  /**
   * 设置PUK成功之后，更新记住PIN的PIN码
   *
   * @param slotId slotId
   * @param pinCode pinCode
   */
  public static updatePinSaving(slotId: number, pinCode?: string): void {
    if (pinCode === undefined) {
      log.showError('updatePinSaving error, pinCode is undefined');
      return;
    }
    // let param: simRemember.UpdatePinParams = {
    //   pinCode: pinCode,
    //   scenario: 0
    // };
    try {
      // simRemember.updatePin(slotId, param).then(data:ESObject => {
      //   log.showInfo(`updatePinSaving, result: ${data?.result}, cause: ${data?.cause}`);
      // });
    } catch (err) {
      log.showError('updatePinSaving err');
    }
  }
}