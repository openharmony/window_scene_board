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

import { BusinessError } from '@kit.BasicServicesKit';
import { SingletonHelper } from '@ohos/basicutils';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { BaseOobeManager } from './BaseOobeManager';
import account_osAccount from '@ohos.account.osAccount';
import { SettingsConstants, SettingsKeyConstants } from '@ohos/commonconstants';
import { sSettingsUtil } from '@ohos/frameworkwrapper';

const TAG = 'PrivateOobeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const MIGRATE_PRIVACY_SPACE_STATUS: string = 'migrate_privacy_space_status';
const PRIVATE_TYPE = 1024;
const ADMIN_USERID = 100;

export class PrivateOobeManager extends BaseOobeManager {
  private isPrivateUser: boolean = false;

  /**
   * 是否隐私空间用户
   *
   * @returns 是否是隐私空间用户
   */
  public getPrivateUserState(): boolean {
    return this.isPrivateUser;
  }

  /**
   * 是否是升级迁移过来的隐私空间
   *
   * @param spaceNumber 用户空间ID（100/101等）
   * @returns 是否是升级迁移过来的隐私空间
   */
  public async isPrivateUserOobe(spaceNumber: number): Promise<boolean> {
    if (spaceNumber === ADMIN_USERID) {
      return false;
    }
    await this.initPrivateUser();
    if (this.isPrivateUser && this.isMigratePrivacy()) {
      // 是隐私空间 且 是升级迁移过来的
      log.showInfo('isPrivateUserOobe user[%{public}d] is private', spaceNumber);
      this.finishPrivateOobe();
      return true;
    }
    return false;
  }

  /**
   * 是否隐私用户
   */
  private async initPrivateUser(): Promise<void> {
    let accountManager: account_osAccount.AccountManager = account_osAccount.getAccountManager();
    try {
      await accountManager.getOsAccountType().then((type: account_osAccount.OsAccountType) => {
        if (type === PRIVATE_TYPE) {
          log.showInfo('user is PRIVATE type');
          this.isPrivateUser = true;
        }
      }).catch((err: BusinessError) => {
        log.showError('getOsAccountType errInfo:' + JSON.stringify(err));
      });
    } catch (e) {
      log.showError('getOsAccountType exception: ' + JSON.stringify(e));
    }
  }

  /**
   * OTA升级过来后如果有这个字段，表示存在隐私空间，如果值为1则表示未进行迁移。切换到隐私空间后需要拉起OOBE走迁移流程，如果为0则表示已经迁移过，不需要走OOBE
   */
  private isMigratePrivacy(): boolean {
    let migratePrivacy: string = sSettingsUtil.getValue(MIGRATE_PRIVACY_SPACE_STATUS, SettingsConstants.OOBE_STATUS_OFF, this.context);
    log.showInfo('migrate_privacy_space_status is %{public}s', migratePrivacy);
    return migratePrivacy === SettingsConstants.OOBE_STATUS_OFF;
  }

  /**
   * 不需要拉起OOBE，但是需要修改OOBE的标记位，不然其他应用和服务 会受到影响
   */
  private finishPrivateOobe(): void {
    sSettingsUtil.setSecureValue(SettingsKeyConstants.BUILD_VERSION_RELEASE, this.getDisplayVersion());
    sSettingsUtil.setSecureValue(SettingsKeyConstants.USER_SETUP_COMPLETE, SettingsConstants.OOBE_STATUS_ON);
    sSettingsUtil.setSecureValue(SettingsKeyConstants.IS_OTA_FINISHED, SettingsConstants.OOBE_STATUS_ON);
    sSettingsUtil.setSecureValue(SettingsKeyConstants.BASIC_STATEMENT_AGREED, SettingsConstants.OOBE_STATUS_ON);
    this.setOobeMainAbilityEnable(false);
  }
}

let sPrivateOobeManager = SingletonHelper.getInstance(PrivateOobeManager, TAG);

export default sPrivateOobeManager as PrivateOobeManager;