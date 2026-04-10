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
import osAccount from '@ohos.account.osAccount';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { UserTextStyle } from '../../UserText/UserText';
import { UserButtonStyle, UserButtonVM } from '../../UserButton/UserButton';
import { IUserItemConfig, UserItemStyle, UserItemVM } from '../../UserList/UserList';

const TAG = 'UserPanel-LogoutConfirmViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export interface ILogoutConfirmConfig {
  title: ResourceStr;
  content: ResourceStr;
  contentAlignment?: FlexAlign;
  isLoginUserListVisible?: boolean;
  cancelText?: ResourceStr;
  confirmText?: ResourceStr;
  onCancel?: () => void;
  onConfirm?: () => void;
  isVirtualMachineUpdating?: boolean;
}

/**
 * LogoutConfirm 组件的 ViewModel 类
 * @since 2024-07-25
 */
@Observed
export class LogoutConfirmVM {
  public static readonly PREFIX: string = 'logout_confirm';
  public static readonly BUTTON_STYLE = new UserButtonStyle({
    size: {
      width: 176,
      height: 40,
    },
    backgroundColor: $r('sys.color.comp_background_tertiary'),
  });
  public static readonly SINGLE_BUTTON_STYLE = new UserButtonStyle({
    size: {
      width: '100%',
      height: 40,
    },
    backgroundColor: $r('sys.color.comp_background_tertiary'),
  });
  // 标题
  public title: ResourceStr;
  public titleStyle = new UserTextStyle({
    size: $r('sys.float.Title_S'),
    weight: FontWeight.Bold,
    color: $r('sys.color.font_primary'),
    lineHeight: 27,
  });
  // 内容
  public content: ResourceStr;
  public contentStyle = new UserTextStyle({
    size: $r('sys.float.Title_S'),
    weight: FontWeight.Medium,
    color: $r('sys.color.font_primary'),
    lineHeight: 21,
  });
  public contentAlignment: FlexAlign; // 内容水平布局
  // 已登录用户列表
  public isLoginUserListVisible: boolean = false;
  public userList: UserItemVM[] = [];
  // 虚拟机是否在更新
  public isVirtualMachineUpdating: boolean = false;
  // 底部按钮
  public cancelBtn = new UserButtonVM({
    id: `${LogoutConfirmVM.PREFIX}_cancel_button`,
    style: LogoutConfirmVM.BUTTON_STYLE,
    text: $r('app.string.cancel'),
    textStyle: new UserTextStyle({
      size: $r('sys.float.Body_L'),
      color: $r('sys.color.font_emphasize'),
    }),
  });
  public confirmBtn = new UserButtonVM({
    id: `${LogoutConfirmVM.PREFIX}_confirm_button`,
    style: LogoutConfirmVM.BUTTON_STYLE,
    text: $r('app.string.confirm'),
    textStyle: new UserTextStyle({
      size: $r('sys.float.Body_L'),
      color: $r('sys.color.warning'),
    }),
  });

  constructor(config: ILogoutConfirmConfig) {
    this.title = config.title;
    this.content = config.content;
    this.contentAlignment = config.contentAlignment || FlexAlign.Start;
    this.isLoginUserListVisible = config.isLoginUserListVisible || false;
    this.cancelBtn.text = config.cancelText || this.cancelBtn.text;
    this.cancelBtn.onClick = config.onCancel;
    this.cancelBtn.style = config.isVirtualMachineUpdating ? 
      LogoutConfirmVM.SINGLE_BUTTON_STYLE : LogoutConfirmVM.BUTTON_STYLE;
    this.confirmBtn.text = config.confirmText || this.confirmBtn.text;
    this.confirmBtn.onClick = config.onConfirm;
    this.isVirtualMachineUpdating = config.isVirtualMachineUpdating || false;
  }

  private async getLoginUserList(): Promise<UserItemVM[]> {
    log.showInfo('getLoginUserList invoked');
    try {
      const acctManager = osAccount.getAccountManager();
      const accounts: osAccount.OsAccountInfo[] = await acctManager.queryAllCreatedOsAccounts();
      const loginUserList: UserItemVM[] = accounts
        .filter((acct: osAccount.OsAccountInfo) => acct.isLoggedIn)
        .map((acct: osAccount.OsAccountInfo) => {
          const userConfig: IUserItemConfig = {
            style: new UserItemStyle({
              padding: {
                top: 8,
                bottom: 8,
                left: 20,
                right: 20
              }
            }),
            textStyle: new UserTextStyle({ maxLines: 4 }, TextOverflow.None),
            subTextStyle: new UserTextStyle({ maxLines: 4 }, TextOverflow.None)
          }
          const userItem: UserItemVM = UserItemVM.createUserItemVM(acct, userConfig);
          userItem.enableHoverEffect = false;
          return userItem;
        });
      log.showInfo(`accounts length ${accounts.length}. loginAcctList length ${loginUserList.length}`);
      return loginUserList;
    } catch (err) {
      log.showError(`getLoginUserList failed with error ${err?.code} ${err?.message}`);
      return [];
    }
  }

  public async updateUserList(): Promise<void> {
    log.showInfo(`updateUserList invoked`);
    if (this.isLoginUserListVisible) {
      this.userList = await this.getLoginUserList();
    }
  }
}