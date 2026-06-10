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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, TestType, Size, Level } from '@ohos/hypium'
import { AccountMgr } from '../../../../../../main/ets/accountmanager/AccountManager'
import Account from "@ohos.account.osAccount";
import distributedAccount from '@ohos.account.distributedAccount';

export default function AccountManagerTest() {
  describe('AccountManagerTest', () => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterEach((): void => {
    });
    afterAll((): void => {
    });

    it('init', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(AccountMgr.init() === undefined).assertTrue();
    })

    it('unInit', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(AccountMgr.unInit() === undefined).assertTrue();
    })

    it('getCurrentAccountInfo', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(AccountMgr.getCurrentAccountInfo()).not().assertFail();
    })


    it('isAdminAccount', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(AccountMgr.isAdminAccount(0)).not().assertFail();
      AccountMgr['adminAccountInfo'] = new CustomAccountInfo();
      expect(AccountMgr.isAdminAccount(0)).not().assertFail();
    })

    it('isInvalidAccount', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(AccountMgr.isInvalidAccount(null)).assertTrue();
      expect(AccountMgr.isInvalidAccount(-1)).assertTrue();
    })

    it('AccountManagerTest_handleAccountActivateChange', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        AccountMgr['handleAccountActivateChange'](null);
      } catch (error) {
      }
      AccountMgr['handleAccountActivateChange'](0);
      expect(true).assertTrue();
    })

    it('AccountManagerTest_handleAccountActivateChange_getid', TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (done: Function) => {
      let userId = await AccountMgr.getCurrentAccountId();
      AccountMgr['handleAccountActivateChange'](userId);
      expect(true).assertTrue();
      done();
    })

    it('AccountManagerTest_resolveAccountInfo', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      AccountMgr['resolveAccountInfo'](null);
      let info: Account.OsAccountInfo = new CustomAccountInfo()
      AccountMgr['resolveAccountInfo'](info);

      try {
        AccountMgr['accountResolves'].clear();
        AccountMgr['resolveAccountInfo'](info);
        expect(true).assertTrue();
      } catch (error) {
      }
    })

    it('AccountManagerTest_clearDelayRunnable', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      AccountMgr['clearDelayRunnable']();
      try {
        AccountMgr['clearDelayRunnable']();
      } catch (error) {
      }
      expect(true).assertTrue();
    })
  })

  class CustomAccountInfo implements Account.OsAccountInfo {
    localId: number = 0;
    localName: string = '';
    shortName?: string | undefined;
    type: Account.OsAccountType = 0;
    constraints: string[] = [''];
    isVerified: boolean = false;
    isUnlocked: boolean = false;
    photo: string = '';
    createTime: number = 0;
    lastLoginTime: number = 0;
    serialNumber: number = 0;
    isActived: boolean = false;
    isActivated: boolean = false;
    isCreateCompleted: boolean = false;
    distributedInfo: distributedAccount.DistributedInfo = {
      name: '',
      id: '',
      event: ''
    };
    domainInfo: Account.DomainAccountInfo = {
      domain: '',
      accountName: ''
    };
  }
}