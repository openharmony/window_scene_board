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
import osAccount from '@ohos.account.osAccount';

const TAG = 'ScreenLock-PrivacySpaceManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export enum AuthState {
  UNAUTH = 0,
  PRE_AUTHED_BY_CREDENTIAL = 1,
  PRE_AUTHED_BY_FINGERPRINT = 2,
  PRE_AUTHED_BY_FACE = 3,
  AUTHED_BY_CREDENTIAL = 4,
  AUTHED_BY_FINGERPRINT = 5,
  AUTHED_BY_FACE = 6,
}

/**
 * 隐私用户类型
 */
const PRIVATE_TYPE = 1024;

/**
 * Privacy Space Manager.
 */
class PrivacySpaceManager {
  public privateUser: number = 0;

  public isToPrivacySpace: boolean = false;

  /**
   * 更新隐私用户ID
   *
   * @param AccountInfoList
   * @returns
   */
  public async updatePrivateUser(accountInfoList: Array<osAccount.OsAccountInfo>): Promise<void> {
    accountInfoList.forEach((accountInfo: osAccount.OsAccountInfo, index: number) => {
      if (accountInfo.type === PRIVATE_TYPE) {
        this.privateUser = accountInfo.localId;
      }
    });
    log.showInfo(`Update privateUserId= ${this.privateUser}`);
  }

  public isEnterPrivacySpace(userId: number): void {
    this.isToPrivacySpace = (userId === this.privateUser);
  }
}

export const privacySpaceManager: PrivacySpaceManager = new PrivacySpaceManager();
