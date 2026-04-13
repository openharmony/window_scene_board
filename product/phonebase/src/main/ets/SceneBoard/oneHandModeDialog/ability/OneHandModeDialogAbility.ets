/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { settings } from '@kit.BasicServicesKit';
import UIExtensionAbility from '@ohos.app.ability.UIExtensionAbility';
import Want from '@ohos.app.ability.Want';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { OneHandDialogConstants } from '../config/OneHandModeDialogConstants';

const TAG: string = 'OneHandModeDialogAbility';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export default class OneHandModeDialogAbility extends UIExtensionAbility {

  private isOobeFinished(): boolean {
    try {
      if (settings.getValueSync(this.context, 'device_provisioned', '0', settings.domainName.DEVICE_SHARED) === '1' &&
          settings.getValueSync(this.context, 'user_setup_complete', '0', settings.domainName.USER_SECURITY) === '1' &&
          settings.getValueSync(this.context, 'is_ota_finished', '1', settings.domainName.USER_SECURITY) !== '0') {
        return true;
      }
    } catch (err) {
      log.showError('getValueSync failed.');
    }
    return false;
  }

  onCreate() {
    log.showInfo('onCreate');
  }

  onDestroy(): void {
    log.showInfo('onDestroy');
  }

  onForeground(): void {
    log.showInfo('onForeground');
  }

  onBackground(): void {
    log.showInfo('onBackground');
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession): void {
    log.showInfo('onSessionCreate');
    if (!this.isOobeFinished()) {
      log.showInfo('is oobe status');
      this.context?.terminateSelf();
      return;
    }
    let storage: LocalStorage = new LocalStorage();
    storage?.setOrCreate('session', session);
    session?.loadContent(OneHandDialogConstants.ONE_HAND_MODE_DIALOG_PAGE_PATH, storage);
    // 设置窗口透明
    session?.setWindowBackgroundColor('#00000000');
  }
}