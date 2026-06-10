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

import { Context } from '@kit.AbilityKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { sSettingsUtil } from '@ohos/frameworkwrapper';
import { SettingsConstants, SettingsKeyConstants } from '@ohos/commonconstants';
import { HiSysEventUtil } from '@ohos/frameworkwrapper';


/**
 * 不拉起OOBE的情况下，检查OOBE的几个标记位
 * */
export function checkOobeSettingsDataByTaskpool(context: Context): void {
  'use concurrent';
  const TAG = 'checkOobeSettingsDataByTaskpool_OobeManager';
  const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
  // 注意：DEVICE_PROVISIONED在global表中。deviceProvisioned为1.标识OOBE已完成，补齐其它标记位
  let provisioned: string = sSettingsUtil.getValue(SettingsKeyConstants.DEVICE_PROVISIONED, '', context);
  log.showInfo('checkOobeSettingsData start, provisioned: %{public}s', provisioned);
  if (provisioned === SettingsConstants.OOBE_STATUS_ON) {
    // USER_SETUP_COMPLETE
    let userSetupComplete: string = sSettingsUtil.getSecureValue(SettingsKeyConstants.USER_SETUP_COMPLETE, SettingsConstants.OOBE_STATUS_OFF, context);
    if (userSetupComplete === SettingsConstants.OOBE_STATUS_OFF) {
      log.warn('checkOobeSettingsData user_setup_complete: %{public}s', userSetupComplete);
      sSettingsUtil.setSecureValue(SettingsKeyConstants.USER_SETUP_COMPLETE, SettingsConstants.OOBE_STATUS_ON, context);
      HiSysEventUtil.reportSkipOOBE(SettingsKeyConstants.USER_SETUP_COMPLETE, SettingsConstants.OOBE_STATUS_ON);
    }

    // BASIC_STATEMENT_AGREED
    let basicStatementAgreed: string = sSettingsUtil.getSecureValue(SettingsKeyConstants.BASIC_STATEMENT_AGREED, '', context);
    if (basicStatementAgreed !== SettingsConstants.OOBE_STATUS_ON) {
      log.warn('checkOobeSettingsData basic_statement_agreed: %{public}s', basicStatementAgreed);
      sSettingsUtil.setSecureValue(SettingsKeyConstants.BASIC_STATEMENT_AGREED, SettingsConstants.OOBE_STATUS_ON, context);
      HiSysEventUtil.reportSkipOOBE(SettingsKeyConstants.BASIC_STATEMENT_AGREED, SettingsConstants.OOBE_STATUS_ON);
    }
  }
}