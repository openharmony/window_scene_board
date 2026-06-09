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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { IUserData } from '@ohos/screenlockcommon';
import accountModel from '../refactor/AccountsModel';
import UserItem from './UserItem';
import AccountsViewModel from '../vm/AccountsViewModel';
import StyleConfiguration from '../common/StyleConfiguration';
import { AccountsComponentStyle } from '../common/StyleConfiguration';
import Constants from '../common/Constants';
import MultiAccounts from './MultiAccounts';
import ScreenLockService from '../refactor/ScreenLockService';
import { SwitchAccountAnimationParameter } from './SwitchAccountAnimation'
import { SlLayoutData } from '../vm/SlLayoutData';

const TAG = 'ScreenLock-NewAccounts';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const COMPONENT_ID_ACCOUNTS_COLUMN = TAG + '_Column';

@Component
export default struct NewAccounts {
  @Link passwordInitial: string;
  @Link slLayoutData: SlLayoutData;
  @Link slideScreenLockMoveFocus2Pwd: boolean;
  @State userBegin: string = SwitchAccountAnimationParameter.userTranslateEnd;
  @Prop @Watch('switchAccountAnimation') isSwitchAnimation: boolean;
  @StorageLink('userList') accountList: IUserData[] = [];
  @Link selectedUserID: number | undefined;
  @Link isResetPwdByRecKeyPageShow: boolean;
  @Link isPinChangeTextShow: boolean;
  @Link passwordViewBlur: number;
  @Link passwordViewOpacity: number;
  @Link passwordViewScale: number;
  @Link passwordViewTranslate: number | string;
  @Link hasRecoveryKey: boolean;
  @Link isVirtualKeyboardActive: boolean | undefined;
  @StorageLink('currentUserItem') selectedUserData: IUserData | undefined = undefined;
  @StorageLink('isScreenOn') @Watch('exitUserList') isScreenOn: boolean = ScreenLockService.isScreenOn;
  @State haveTryUnlock: boolean = false;
  private unlockWithoutPassword: () => void = () => {};
  accountsViewModel: AccountsViewModel = new AccountsViewModel();
  private accountsStyle: AccountsComponentStyle = StyleConfiguration.getAccountsComponentStyle();
  private ctlaltdelSlectSwitchUser: boolean = false;

  exitUserList(): void {
    let curUser: number = accountModel.getCurrentUserId();
    let selectedUser: number | undefined = this.selectedUserID;
    log.showInfo(`exitUserList${this.isScreenOn} currentUsr:${curUser} ${selectedUser}`);
    if (!this.isScreenOn && this.selectedUserID === Constants.INVALID_USER_ID) {
      this.selectedUserID = accountModel.getCurrentUserId();
      AccountsViewModel.getInstance().selectedUserId = accountModel.getCurrentUserId();
    }
  }
  //SwitchAccount Animation
  private switchAccountAnimation(): void {
    if (this.isSwitchAnimation) {
      this.userBegin = SwitchAccountAnimationParameter.userTranslateBegin;
      animateTo({
        delay: SwitchAccountAnimationParameter.userTime,
        duration: 700 * SwitchAccountAnimationParameter.dynamicEffectRatio,
        curve: Curve.Friction
      }, () => {
        this.userBegin = SwitchAccountAnimationParameter.userTranslateEnd;
      });
    }
  }

  aboutToAppear(): void {
    log.showInfo('aboutToAppear');
    this.switchAccountAnimation();
    this.accountsStyle.initStyle();
    AccountsViewModel.getInstance().getMaxLoggedAmount();

    this.ctlaltdelSlectSwitchUser = AppStorage.get('ctlaltdelSlectSwitchUser') ?? false;
    if (this.ctlaltdelSlectSwitchUser) {
      this.selectedUserID = Constants.INVALID_USER_ID;
      AccountsViewModel.getInstance().selectedUserId = Constants.INVALID_USER_ID;
      AppStorage.setOrCreate('ctlaltdelSlectSwitchUser', false);
    }
    log.showInfo('this.ctlaltdelSlectSwitchUser:' + this.ctlaltdelSlectSwitchUser);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
    this.unlockWithoutPassword = (): void => {};
  }

  build() {
    Row() {
      if (this.selectedUserID === Constants.INVALID_USER_ID) {
        MultiAccounts({
          selectedUserID: this.selectedUserID
        })
      } else {
        UserItem({
          userItem: this.selectedUserData,
          selectedUserID: this.selectedUserID,
          singleUser: true,
          accountsStyle: this.accountsStyle,
          haveTryUnlock: this.haveTryUnlock,
          isSwitchAnimation: this.isSwitchAnimation,
          isResetPwdByRecKeyPageShow: this.isResetPwdByRecKeyPageShow,
          isPinChangeTextShow: this.isPinChangeTextShow,
          passwordViewBlur: this.passwordViewBlur,
          passwordViewOpacity: this.passwordViewOpacity,
          passwordViewScale: this.passwordViewScale,
          passwordViewTranslate: this.passwordViewTranslate,
          hasRecoveryKey: this.hasRecoveryKey,
          slLayoutData: this.slLayoutData,
          passwordInitial: this.passwordInitial,
          slideScreenLockMoveFocus2Pwd: this.slideScreenLockMoveFocus2Pwd,
          isVirtualKeyboardActive: this.isVirtualKeyboardActive,
          unlockWithoutPassword: () => {
            this.unlockWithoutPassword();
          }
        })
          .id(COMPONENT_ID_ACCOUNTS_COLUMN)
          .height(this.accountsStyle.screenLockAccountsHeight)
          .translate({ y: this.userBegin })
      }
    }
    .width('100%')
    .height('100%')
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}