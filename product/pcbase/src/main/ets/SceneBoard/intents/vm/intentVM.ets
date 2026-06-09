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
import { SettingsUtil } from '@ohos/frameworkwrapper';
import mModel from '../../systempanel/model/SystemPanelModel';
import insightIntent from '@ohos.app.ability.insightIntent';
import { osAccount } from '@kit.BasicServicesKit';
import { Constants } from '@ohos/statusbarcomponent/src/main/ets/pc/common/Constants';
import { StatusBarType } from '@ohos/systemuicommon/src/main/ets/plugin/info/StatusBarType';
import { pcShutdownDialogVMP } from '@ohos/shutdownview/src/main/ets/pages/PcShutdownDialogVMP';

const TAG = 'IntentVM';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class IntentVM {
  static async reboot(): Promise<insightIntent.ExecuteResult> {
    let result: insightIntent.ExecuteResult = { code: 0 };
    try {
      AppStorage.setOrCreate('currentClickRebootOrShutdown', 'reboot');
      pcShutdownDialogVMP.showPcShutdownView();
      result.result = { msg: 'reboot intent execute success'};
    } catch (err) {
      log.showError('reboot error: ' + err.message);
      result.code = ResponseCode.REBOOT_INTENT_FAILED;
      result.result = {
        msg: err.message,
      };
    }
    return result;
  }

  static async sleep(): Promise<insightIntent.ExecuteResult> {
    let result: insightIntent.ExecuteResult = { code: 0 };
    try {
      mModel.sleep();
      result.result = { msg: 'sleep intent execute success' };
    } catch (err) {
      log.showError('sleep error: ' + err.message);
      result.code = ResponseCode.SLEEP_INTENT_FAILED;
      result.result = {
        msg: err.message,
      };
    }
    return result;
  }

  static async lockScreen(): Promise<insightIntent.ExecuteResult> {
    let result: insightIntent.ExecuteResult = { code: 0 };
    try {
      mModel.lockScreen();
      result.result = { msg: 'lockScreen intent execute success' };
    } catch (err) {
      log.showError('lockScreen error: ' + err.message);
      result.code = ResponseCode.SCREEN_LOCK_INTENT_FAILED;
      result.result = {
        msg: err.message,
      };
    }
    return result;
  }

  static async shutdown(): Promise<insightIntent.ExecuteResult> {
    let result: insightIntent.ExecuteResult = { code: 0 };
    try {
      AppStorage.setOrCreate('currentClickRebootOrShutdown', 'shutdown');
      pcShutdownDialogVMP.showPcShutdownView();
      result.result = { msg: 'shutdown intent execute success' };
    } catch (err) {
      log.showError('shutdown error: ' + err.message);
      result.code = ResponseCode.SHUTDOWN_INTENT_FAILED;
      result.result = {
        msg: err.message,
      };
    }
    return result;
  }

  static async deactivateOsAccount(): Promise<insightIntent.ExecuteResult> {
    let result: insightIntent.ExecuteResult = { code: 0 };
    try {
      let accountManager: osAccount.AccountManager = osAccount.getAccountManager();
      let currentUserId: number = AppStorage.get<number>('mCurrentUserId') as number;
      await accountManager.deactivateOsAccount(currentUserId);
      result.result = { msg: 'deactivateAccount intent execute success' };
    } catch (err) {
      log.showError('deactivateAccount error: ' + err.message);
      result.code = ResponseCode.SHUTDOWN_INTENT_FAILED;
      result.result = {
        msg: err.message,
      };
    }
    return result;
  }

  static async switchStatusBar(): Promise<insightIntent.ExecuteResult> {
    let result: insightIntent.ExecuteResult = { code: 0 };
    try {
      let statusbar = SettingsUtil.getSecureValue(Constants.SETTINGS_KEY);
      let type = Number(statusbar);
      if (!type) {
        SettingsUtil.setSecureValue(Constants.SETTINGS_KEY, StatusBarType.TYPE_MAIN_WINDOW_STATUS_BAR.toString());
      } else {
        if (type === StatusBarType.TYPE_MAIN_WINDOW_STATUS_BAR) {
          SettingsUtil.setSecureValue(Constants.SETTINGS_KEY, StatusBarType.TYPE_MAIN_MAC_STATUS_BAR.toString());
        } else {
          SettingsUtil.setSecureValue(Constants.SETTINGS_KEY, StatusBarType.TYPE_MAIN_WINDOW_STATUS_BAR.toString());
        }
      }
    } catch (err) {
      log.showError('switchStatusBar error: ' + err.message);
      result.code = ResponseCode.SHUTDOWN_INTENT_FAILED;
      result.result = {
        msg: err.message,
      };
    }
    return result;
  }
}

export enum ResponseCode {
  SUCCESS = 0,
  SLEEP_INTENT_FAILED = 10110001,
  SCREEN_LOCK_INTENT_FAILED = 10110002,
  REBOOT_INTENT_FAILED = 10110003,
  SHUTDOWN_INTENT_FAILED = 10110004,
  DEACTIVATE_ACCOUNT_INTENT_FAILED = 10110005,
}