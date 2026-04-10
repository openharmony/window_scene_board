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

import { LogDomain, Logger } from '@ohos/basicutils';
import accountModel from '../../refactor/AccountsModel';
import { setResetUserPinMark } from '@ohos/windowsceneinterfaces/src/main/ets/interfaces/stub/StubRecoveryKeyService';
import { BusinessError, osAccount } from '@kit.BasicServicesKit';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { RotationConstants } from '@ohos/commonconstants';
import { SCBResetPwdManager } from '../../common/SCBResetPwdManager';
import { ResetPwdBtnVD } from './ResetPwdBtnVD';

const TAG = 'ScreenLock-ResetPwdBtnVM';
const log: Logger = Logger.getLogHelper(LogDomain.KG);
const QUARTER: number = 0.25;

interface resetPwdPreCondition {
  /*
   * @description 是否设置恢复秘钥
   * */
  hasRecoveryKey: boolean;

  /*
   * @description 旧密码是否在96小时内
   * */
  isOldPwdValidPeriod: boolean;

  /*
   * @description 密码错误次数是否达3次
   * */
  isMaxAttemptsExceeded: boolean;
}

export class ResetPwdBtnVM {
  private resetPwdBtnVD: ResetPwdBtnVD = new ResetPwdBtnVD();
  private preCondition: resetPwdPreCondition = {
    hasRecoveryKey: false,
    isOldPwdValidPeriod: false,
    isMaxAttemptsExceeded: false,
  };
  public dialogOffsetHalfFold: Offset = { dx: 0, dy: 0 };
  private updateMaxAttemptsExceeded = (isMaxAttemptsExceeded: boolean) => {
    log.info(TAG, `isMaxAttemptsExceeded changed ${isMaxAttemptsExceeded}`);
    this.preCondition.isMaxAttemptsExceeded = isMaxAttemptsExceeded;
    this.resetPwdBtnVD.isVisible = this.isShowResetPwdBtn();
  };

  constructor() {
    this.initDialogOffsetHalfFold();
  }

  public init(viewData: ResetPwdBtnVD): void {
    this.resetPwdBtnVD = viewData;
    this.checkResetPwdPreCondition();
    SCBResetPwdManager.getInstance().registerResetPwdEntryChange(this.updateMaxAttemptsExceeded);
  }

  public destroy(): void {
    SCBResetPwdManager.getInstance().unregisterResetPwdEntryChange(this.updateMaxAttemptsExceeded);
  }

  private initDialogOffsetHalfFold(): void {
    let offsetY = 0;
    const screenProp = SCBScreenSessionManager.getInstance().getMainScreenSession().scbScreenProperty;
    if (screenProp.rotation === RotationConstants.ROTATION_90 ||
      screenProp.rotation === RotationConstants.ROTATION_270) {
      offsetY = screenProp.width * QUARTER;
    } else {
      offsetY = screenProp.height * QUARTER;
    }
    log.info(TAG, `initDialogOffsetHalfFold, offsetY:${offsetY}, rotation:${screenProp.rotation}`);
    this.dialogOffsetHalfFold = { dx: 0, dy: -px2vp(offsetY) };
  }

  private isShowResetPwdBtn(): boolean {
    return this.preCondition.isMaxAttemptsExceeded &&
      (this.preCondition.hasRecoveryKey || this.preCondition.isOldPwdValidPeriod);
  }

  // 恢复秘钥和旧密码96小时检查放在一个闭包函数保证状态同步
  private async checkResetPwdPreCondition(): Promise<void> {
    await this.checkRecoveryKey();
    await this.checkOldPwdValidPeriod();
    this.preCondition.isMaxAttemptsExceeded = SCBResetPwdManager.getInstance().resetPwdEntry;
    this.resetPwdBtnVD.isVisible = this.isShowResetPwdBtn();
  }

  private async checkOldPwdValidPeriod(): Promise<void> {
    try {
      const userIdentityManager: osAccount.UserIdentityManager = new osAccount.UserIdentityManager();
      const curAccountId = accountModel.getCurrentUserId();
      const credentials = await userIdentityManager.getAuthInfo(
        {
          authType: osAccount.AuthType.PIN,
          accountId: curAccountId,
        });
      const credential = credentials.find(item => item.isAbandoned && item.validityPeriod as number > 0);
      this.preCondition.isOldPwdValidPeriod = Boolean(credential);
    } catch (e) {
      log.error(TAG, `updateOldPwd error: code ${e?.code} message ${e?.message}`);
    }
  }

  private async checkRecoveryKey(): Promise<void> {
    try {
      log.info(TAG, 'checkRecoveryKey enter');
      let userIDM: osAccount.UserIdentityManager = new osAccount.UserIdentityManager();
      let arrCredInfos: osAccount.EnrolledCredInfo[] = await userIDM.getAuthInfo(osAccount.AuthType.RECOVERY_KEY);
      let recoverKeyCredInfoObj: osAccount.EnrolledCredInfo = arrCredInfos[0];
      log.info(TAG, `checkRecoveryKey recoverKeyCredInfoObj?.authType:${recoverKeyCredInfoObj?.authType}`);
      this.preCondition.hasRecoveryKey =
        (recoverKeyCredInfoObj?.credentialId && recoverKeyCredInfoObj?.authType === osAccount.AuthType.RECOVERY_KEY);
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      log.error(TAG, `checkRecoveryKey check error: ${err.message}, ${err.code}`);
    }
    log.info(TAG, `checkRecoveryKey: ${this.preCondition.hasRecoveryKey}`);
  }

  public async setResetUserPinMark(): Promise<void> {
    let curAcct = accountModel.getCurrentUserId();
    try {
      await setResetUserPinMark(curAcct);
    } catch (err) {
      log.showError(TAG, `setResetUserPinMark errCode: ${err.code}, errMsg: ${err.message}`)
    }
    log.showInfo(TAG, `setResetUserPinMark, curUsr: ${curAcct}`);
  }
}