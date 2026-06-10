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

import power from '@ohos.power';
import { HiSysEventUtil, viewMgrPolicy, ViewType, DeviceHelper } from '@ohos/frameworkwrapper';
import { CheckEmptyUtils, Log } from '@ohos/basicutils';
import { MenuType, StateChangeListener } from '../common/Constants';
import screenLockMediator from '../../screenlock/refactor/ScreenLockMediator';
import osAccount from '@ohos.account.osAccount';
import { pcShutdownDialogVMP } from '@ohos/shutdownview/src/main/ets/pages/PcShutdownDialogVMP';
import { IUserData } from '@ohos/screenlockcommon';
import { systemParameter } from '@kit.BasicServicesKit';
import { Constants } from '../../userspanel/common/Constants';
import { MultiInputViewModel } from '@ohos/multiinput';

const TAG = 'SystemPanel-SystemPanelModel';
const accountManager: osAccount.AccountManager = osAccount.getAccountManager();
export const CONFIRM_LOGOUT_DIALOG_KEY: string = 'confirm_logout';

export class SystemPanelModel {
  mStateChangeListeners = new Set<StateChangeListener>();
  public confirmLogout: (() => Promise<boolean>) | null = null;
  openPowerOffDialog?: Function = undefined;
  private eventType: string = HiSysEventUtil.TOUCH_EVENT;

  registerStateChangeListener(listener: StateChangeListener): void {
    let res = this.mStateChangeListeners.add(listener);
    Log.showInfo(TAG, `register StateChangeListener res: ${res}, size: ${this.mStateChangeListeners.size}`);
  }

  unregisterStateChangeListener(listener: StateChangeListener): void {
    let res = this.mStateChangeListeners.delete(listener);
    Log.showInfo(TAG, `unregister StateChangeListener res: ${res}, size: ${this.mStateChangeListeners.size}`);
  }

  /**
   * 更改窗口状态
   * @param panelState
   */
  updateState(panelState: boolean): void {
    Log.showInfo(TAG, `updateState, panelState: ${panelState}`);
    this.mStateChangeListeners.forEach(listener => {
      listener.onStateChange(panelState);
    });
  }

  /**
   * 关机
   */
  shutdown(): void {
    Log.showInfo(TAG, `shutdown by user`);
    try {
      power.shutdown('shutdown_by_user');
    } catch (error) {
      Log.showError(TAG, `shutdown fail, error -> ${error?.code} ${error?.message}`);
    }
  }

  /**
   * 锁屏
   */
  lockScreen(): void {
    Log.showInfo(TAG, `lockScreen by user`);
    try {
      if (DeviceHelper.is2In1DevicePcType()) {
        MultiInputViewModel.getInstance().winLCallBack();
      } else {
        screenLockMediator.doScreenLockWithLocalCallback(() => {
          Log.showInfo(TAG, 'lockScreen success');
        });
      }
    } catch (err) {
      Log.showError(TAG, `lock fail, promise: err -> ${err?.code} ${err?.message}`);
    }
  }

  /**
   * 睡眠
   */
  sleep(): void {
    Log.showInfo(TAG, `sleep by user`);
    try {
      power.suspend(true);
    } catch (error) {
      Log.showError(TAG, `sleep fail, error -> ${error?.code} ${error?.message}`);
    }
  }

  /**
   * 休眠
   */
  hibernate(): void {
    Log.showInfo(TAG, `hibernate by user`);
    try {
      power.hibernate(true);
    } catch (error) {
      Log.showError(TAG, `hibernate fail, error -> ${error?.code} ${error?.message}`);
    }
  }

  /**
   * 重启
   */
  reboot(): void {
    Log.showInfo(TAG, `rebootDevice by user`);
    try {
      power.reboot('reboot_by_user');
    } catch (error) {
      Log.showError(TAG, `reboot fail, error -> ${error?.code} ${error?.message}`);
    }
  }

  /**
   * 注销
   */
  async logout(): Promise<void> {
    Log.showInfo(TAG, 'logout by user');
    try {
      if (this.confirmLogout === null) {
        Log.showWarn(TAG, 'confirmLogout method is null');
        return;
      }
      const isConfirm: boolean = await this.confirmLogout();
      if (!isConfirm) {
        Log.showInfo(TAG, 'cancel logout');
        return;
      }
      const currentUserId: number = await accountManager.getForegroundOsAccountLocalId();
      if (!currentUserId) {
        Log.showWarn(TAG, 'invalid currentUserId');
        return;
      }
      Log.showInfo(TAG, 'start logout');
    } catch (error) {
      Log.showError(TAG, `logout fail, error -> ${error?.code} ${error?.message}`);
    }
  }

  /**
   * OpenHarmony键睡眠通信接口
   * @returns
   */
  async sleepByHosKey(): Promise<void> {
    Log.showInfo(TAG, `sleep by HosKey`);
    mSystemPanelModel.sleep();
    HiSysEventUtil.reportSystemMenu(MenuType.SLEEP_MENU, this.eventType);
  }

  /**
   * OpenHarmony键锁屏通信接口
   * @returns
   */
  async lockScreenByHosKey(): Promise<void> {
    Log.showInfo(TAG, `lockScreen by HosKey`);
    mSystemPanelModel.lockScreen();
    HiSysEventUtil.reportSystemMenu(MenuType.LOCK_MENU, this.eventType);
  }

  /**
   * OpenHarmony键重启通信接口
   * @returns
   */
  async rebootByHosKey(): Promise<void> {
    Log.showInfo(TAG, `rebootDevice by HosKey`);
    try {
      AppStorage.setOrCreate('currentClickRebootOrShutdown', 'reboot');
      systemParameter.setSync('persist.dfx.userclicktime', new Date().getTime().toString());
      const isMultiUser = await this.isExistOtherLoginUser();
      Log.showInfo(TAG, `isMultiUser ${isMultiUser}}`);
      if (isMultiUser) {
        this.setCurrentClickItem(Constants.REBOOT);
        Log.showInfo(TAG, 'enter into multiUser');
        this.openPowerOffDialog?.('reboot');
      } else {
        Log.showInfo(TAG, 'enter into singleUser');
        HiSysEventUtil.hiSysWriteStorage(MenuType.REBOOT_MENU, this.eventType, () => {
          pcShutdownDialogVMP.showPcShutdownView();
        });
      }
    } catch (error) {
      Log.showError(TAG, `rebootByHosKey fail, error -> ${error?.code} ${error?.message}`);
    }
  }

  /**
   * OpenHarmony键关机通信接口
   * @returns
   */
  async shutdownByHosKey(): Promise<void> {
    Log.showInfo(TAG, `shutdownDevice by HosKey`);
    try {
      AppStorage.setOrCreate('currentClickRebootOrShutdown', 'shutdown');
      systemParameter.setSync('persist.dfx.userclicktime', new Date().getTime().toString());
      const isMultiUser = await this.isExistOtherLoginUser();
      if (isMultiUser) {
        this.setCurrentClickItem(Constants.SHUTDOWN);
        Log.showInfo(TAG, 'enter into multiUser');
        this.openPowerOffDialog?.('shutdown');
      } else {
        Log.showInfo(TAG, 'enter into singleUser');
        HiSysEventUtil.hiSysWriteStorage(MenuType.SHUTDOWN_MENU, this.eventType, () => {
          pcShutdownDialogVMP.showPcShutdownView();
        });
      }
    } catch (error) {
      Log.showError(TAG, `shutdownByHosKey fail, error -> ${error?.code} ${error?.message}`);
    }
  }

  public setCurrentClickItem(item: string): void {
    if (AppStorage.get('currentClickItem') !== item) {
      viewMgrPolicy.hideView(ViewType.DIALOG_VIEW);
    }
    AppStorage.setOrCreate('currentClickItem', item);
  }

  public async isExistOtherLoginUser(): Promise<boolean> {
    Log.showInfo(TAG, 'getLoginUserList invoked');
    try {
      let accountList: osAccount.OsAccountInfo[] = await accountManager.queryAllCreatedOsAccounts();
      Log.showInfo(TAG, `accountList.length: ${accountList?.length}`);
      const loginUserList: osAccount.OsAccountInfo[] = accountList?.filter((acct: osAccount.OsAccountInfo) => {
        Log.showInfo(TAG, `acct.isLoggedIn: ${acct?.isLoggedIn}`);
        return acct.isLoggedIn;
      });
      Log.showInfo(TAG, `loginUserList.length: ${loginUserList?.length}`);
      if (CheckEmptyUtils.isEmpty(loginUserList)) {
        Log.showInfo(TAG, 'loginUserList is empty');
        return false;
      }
      if (loginUserList.length > 1) {
        Log.showInfo(TAG, 'loginUserList more than one');
        return true;
      }
      Log.showInfo(TAG, 'loginUserList less than one');
      return false;
    } catch (err) {
      Log.showError(TAG, `isExistLoginUserList failed with error ${err?.code} ${err?.message}`);
      return false;
    }
  }
}

let mSystemPanelModel = new SystemPanelModel();

export default mSystemPanelModel as SystemPanelModel;