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

import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { IUserData } from '@ohos/screenlockcommon';
import StyleConfiguration from '../common/StyleConfiguration';
import { AccountsComponentStyle } from '../common/StyleConfiguration';
import { MultiUserItem } from './MultiUserItem';
import osAccount from '@ohos.account.osAccount';
import accountModel from '../refactor/AccountsModel';
import AccountsViewModel from '../vm/AccountsViewModel';
import styleManager from '../style/StyleManager';
import { SwitchAccountAnimationMethod } from '../../screenlock/pages/SwitchAccountAnimation';
import { ScreenLockLayoutManager } from '../common/ScreenLockLayoutManager';

const TAG = 'ScreenLock-MultiAccounts';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

@Component
export default struct MultiAccounts {
  @StorageLink('userList') accountList: IUserData[] = [];
  @State userAccountList: IUserData[] = [];
  @State userNameMaxLength: number = 0;
  @Link selectedUserID: number | undefined;
  private accountsStyle: AccountsComponentStyle = StyleConfiguration.getAccountsComponentStyle();
  private screenLockLayoutManager: ScreenLockLayoutManager = ScreenLockLayoutManager.getInstance();
  @StorageLink('currentUserItem') private userData: IUserData | null = null;

  userListChange(): void {
    log.showInfo(`userListChange : userListLength: ${this.accountList.length}`);
    AccountsViewModel.userLoggedAmount = 0;
    for (const user of this.accountList) {
      if (user.isLoggedIn) {
        AccountsViewModel.userLoggedAmount++;
        log.showInfo(`isLoggedIn:${user.isLoggedIn}`);
      }
    }
  }

  private reGroupUserData(): void {
    if (!this.accountList || this.accountList.length === 0) {
      log.showError('reGroupUserData : all user length invalid');
      return;
    }
    this.accountList.sort((userA: IUserData, userB: IUserData): number => {
      if (SwitchAccountAnimationMethod.enableEnterpriseSpace()) {
        return userA.createTime - userB.createTime;
      } else {
        if (userA.isLoggedIn && userB.isLoggedIn) {
          return userA.lastLoginTime - userB.lastLoginTime;
        }
        if (userA.isLoggedIn || userB.isLoggedIn) {
          return userA.isLoggedIn ? -1 : 1;
        }
        return userA.createTime - userB.createTime;
      }
    });
    this.userAccountList = [...this.accountList];
    this.userAccountList.forEach((user, index) => {
      log.showInfo(`reGroupUserData : index: ${index}, isLoggedIn:${user.isLoggedIn},
      create:${user.createTime}, last:${user.lastLoginTime}`);
    });
  }

  private getUseInfo(): void {
    // pin码认证成功的企业用户，进入多用户界面，需要更新用户登录状态，以保证显示绿点
    if (this.userData?.isDomain && !this.userData?.isLoggedIn) {
      accountModel.updateAllUsers(() => {
        this.userListChange();
        this.reGroupUserData();
      });
    } else {
      this.userListChange();
      this.reGroupUserData();
    }
  }


  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.getUseInfo();
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
  }

  getHeight(): number {
    const rowHeight: number = 112;
    const rows = Math.floor((this.accountList.length + 1) / 2);
    const res = (rowHeight * rows + (rows - 1) * this.screenLockLayoutManager.multiUserRowGap);
    log.showInfo(`rowH: ${rowHeight} row: ${rows} res: ${res}`);
    return res;
  }

  getOffsetX(): number {
    // 剩余宽度  318 - 8 - 80 - 12 - 8;
    const remainder: number = 210;
    const offsetX: number = (remainder - this.userNameMaxLength) / 2;
    return offsetX;
  }

  build() {
    Column() {
      Grid() {
        ForEach(this.userAccountList, (item: IUserData, index: number) => {
          GridItem() {
            MultiUserItem({
              userItem: item,
              accountsStyle: this.accountsStyle,
              selectedUserID: this.selectedUserID,
              index: index + 1,
              userNameMaxLength: this.userNameMaxLength,
            })
          }
          .clip(false)
        })
      }
      .clip(false)
      .height(this.getHeight())
      .margin({
        bottom: '84vp'
      })
      .columnsTemplate('1fr 1fr')
      .columnsGap(this.screenLockLayoutManager.multiUserColGap)
      .rowsGap(this.screenLockLayoutManager.multiUserRowGap)
    }
    .width(this.screenLockLayoutManager.multiUserWidth)
    .height(this.screenLockLayoutManager.multiUserHeight)
    .justifyContent(FlexAlign.Center)
    .offset({ x: this.getOffsetX() })
  }
}