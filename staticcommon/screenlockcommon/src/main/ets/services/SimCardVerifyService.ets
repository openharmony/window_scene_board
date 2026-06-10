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

import sim from '@ohos.telephony.sim';
import ArrayList from '@ohos.util.ArrayList';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AbstractInitialAble } from '../base/AbstractInitialAble';
import { SimCardStateManager } from '../manager/SimCardStateManager';
import { SimCardUtils, SimResult } from '../utils/SimCardUtils';

const TAG = 'SimCardVerifyService';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const PUK_WARNING_THRESHOLD: number = 3;

export interface SimCardVerifyCallback {
  onPinVerifyCallback: (state: PinVerifyState) => void;
  onPukVerifyCallback: (state: PukVerifyState, psd?: string) => void;
}

export enum PinVerifyState {
  PIN_CODE_INVALID = 0,

  PIN_VERIFY_START,

  PIN_VERIFY_SUCCESS,

  PIN_VERIFY_FAIL,

  PIN_VERIFY_RESULT
}

export enum PukVerifyState {
  PUK_CODE_INVALID = 0,

  PIN_CODE_INVALID,

  PIN_CODE_NO_MATCH,

  PUK_VERIFY_START,

  PUK_VERIFY_SUCCESS,

  PUK_VERIFY_FAIL,

  PUK_VERIFY_SHOW_FAIL,

  PUK_VERIFY_CONTINUE,

  PUK_VERIFY_RESULT,
}

/**
 * Sim卡验证服务
 */
export class SimCardVerifyService extends AbstractInitialAble {
  private static sInstance: SimCardVerifyService;
  private simCardStateManager: SimCardStateManager = SimCardStateManager.getInstance();

  public static getInstance(): SimCardVerifyService {
    if (SimCardVerifyService.sInstance == null) {
      SimCardVerifyService.sInstance = new SimCardVerifyService();
    }
    return SimCardVerifyService.sInstance;
  }

  private constructor() {
    super();
  }

  public unlockSimCard(isRememberPin: boolean, password?: string, callBack?: SimCardVerifyCallback,
    pukArr?: ArrayList<string>): void {
    if (this.simCardStateManager.isPinLocked()) {
      this.verifyPin(isRememberPin, (this.simCardStateManager?.getLockQueue().getFirst() ?? 0) as number, password,
        callBack);
    } else if (this.simCardStateManager.isPukLocked()) {
      this.verifyPuk(isRememberPin, (this.simCardStateManager?.getLockQueue().getFirst() ?? 0) as number, password,
        callBack, pukArr);
    }
  }

  protected isSupport(): boolean {
    return SimCardUtils.isSimCardSupport();
  }

  protected doInit(): void {
    log.showInfo('doInit');

    // SIM卡数据初始化
    this.simCardStateManager.init();
  }

  protected doRelease(): void {
    log.showInfo('doRelease');

    // SIM卡数据释放
    this.simCardStateManager.release();
  }

  private verifyPin(isRememberPin: boolean, slotId: number, password?: string, callBack?: SimCardVerifyCallback): void {
    log.showInfo('unlock pin start');
    if (!SimCardUtils.isValidPin(password)) {
      log.showError('invalid pin format');
      callBack?.onPinVerifyCallback(PinVerifyState.PIN_CODE_INVALID);// state1
      return;
    }
    callBack?.onPinVerifyCallback(PinVerifyState.PIN_VERIFY_START);

    const result: SimResult = SimCardUtils.unlockPin(slotId, password, async () => {
      SimCardUtils.getSimState(slotId).then(async (state: sim.SimState) => {
        let unlockPinSuccess: boolean = result.retCode === 0 || state !== sim.SimState.SIM_STATE_LOCKED;
        if (unlockPinSuccess && isRememberPin) {
          SimCardUtils.setPinSavingFlag(slotId, isRememberPin, password);
        }
        if (unlockPinSuccess) {
          log.showInfo('unlock pin success');
          this.simCardStateManager.getLockQueue().remove(slotId);
          callBack?.onPinVerifyCallback(PinVerifyState.PIN_VERIFY_RESULT);
        }
        await this.simCardStateManager.updateCardState(slotId, state);
        if (result.retCode !== 0) {
          callBack?.onPinVerifyCallback(PinVerifyState.PIN_VERIFY_FAIL);
        } else {
          callBack?.onPinVerifyCallback(PinVerifyState.PIN_VERIFY_SUCCESS);
        }
      })
        .catch((err: Error) => {
          log.showError(`getSimState error. errCode ${err?.message}`);
        })
    });
  }

  /**
   * Puk码校验输入pukArr包含8位puk码和新设置的pin码，pin码需要输入两次
   */
  private verifyPuk(isRememberPin: boolean, slotId: number, password?: string, callBack?: SimCardVerifyCallback,
    pukArr?: ArrayList<string>): void {
    if (!pukArr) {
      log.showError('verifyPuk error, pukArr is undefined');
      return;
    }

    if (pukArr.length === 0 && !SimCardUtils.isValidPukCode(password)) {
      log.showError('invalid puk format');
      callBack?.onPukVerifyCallback(PukVerifyState.PUK_CODE_INVALID);
      return;
    }

    if (pukArr.length === 1 && !SimCardUtils.isValidPin(password)) {
      log.showError('invalid new pin format');
      callBack?.onPukVerifyCallback(PukVerifyState.PIN_CODE_INVALID);
      return;
    }

    if (pukArr.length === 2 && !SimCardUtils.isMatchedPin(pukArr.convertToArray(), password)) {
      log.showError('confirm pin not matched');
      callBack?.onPukVerifyCallback(PukVerifyState.PIN_CODE_NO_MATCH);
      return;
    }

    if (pukArr.length !== 2) {
      callBack?.onPukVerifyCallback(PukVerifyState.PUK_VERIFY_CONTINUE, password);
      return;
    }

    this.unlockPukInner(isRememberPin, slotId, password, callBack, pukArr);
  }

  private unlockPukInner(isRememberPin: boolean, slotId: number, password?: string, callBack?: SimCardVerifyCallback,
    pukArr?: ArrayList<string>): void {
    log.showInfo('unlock puk start');
    callBack?.onPukVerifyCallback(PukVerifyState.PUK_VERIFY_START);
    const result: SimResult = SimCardUtils.unlockPuk(slotId, pukArr, async () => {
      SimCardUtils.getSimState(slotId).then(async (state: sim.SimState) => {
        if (isRememberPin) {
          SimCardUtils.setPinSavingFlag(slotId, isRememberPin, password);
        }
        if (result.retCode === 0 || state !== sim.SimState.SIM_STATE_LOCKED) {
          log.showInfo('unlock puk success');
          SimCardUtils.updatePinSaving(slotId, password);
          this.simCardStateManager.getLockQueue().remove(slotId);
          callBack?.onPukVerifyCallback(PukVerifyState.PUK_VERIFY_RESULT);
        }
        await this.simCardStateManager.updateCardState(slotId, state);
        if (result.retCode !== 0) {
          let isPukRemainWarning: boolean = ((result.remain ?? 0) as number) <= PUK_WARNING_THRESHOLD;
            callBack?.onPukVerifyCallback(isPukRemainWarning ? PukVerifyState.PUK_VERIFY_SHOW_FAIL :
          PukVerifyState.PUK_VERIFY_FAIL);
        } else {
          callBack?.onPukVerifyCallback(PukVerifyState.PUK_VERIFY_SUCCESS);
        }
      })
        .catch((err: Error) => {
          log.showError(`getSimState error. errCode ${err?.message}`);
        })
    });
  }
}