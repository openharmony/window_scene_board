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
import UIExtensionAbility from '@ohos.app.ability.UIExtensionAbility';
import Want from '@ohos.app.ability.Want';
import type UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { LogDomain, Logger } from '@ohos/basicutils';
import { AlertViewModelParams, AlertViewModel } from '../vm/AlertViewModel';
import { ResourceUtil } from '../common/ResourceUtil';

const TAG = 'AlertAbility';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

export class AlertAbility extends UIExtensionAbility {
  onCreate(): void {
    log.showInfo(TAG, 'onCreate');
    ResourceUtil.setContext(this.context);
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession): void {
    try {
      log.showInfo(TAG, 'onSessionCreate');
      const params = (want?.parameters?.['extraInfo']) as AlertViewModelParams;
      const alertViewModel = new AlertViewModel(session, params);
      let storage: LocalStorage = new LocalStorage();
      storage.setOrCreate('alertViewModel', alertViewModel);
      session?.loadContent('SystemDialog/pages/AlertPage', storage);
      session?.setWindowBackgroundColor('#00000000');
      this.setHideNonSecureWindows(session, true);
    } catch (err) {
      log.showError(TAG, `onSessionCreate failed ${err.code} ${err.message}`);
    }
  }

  async onSessionDestroy(session: UIExtensionContentSession): Promise<void> {
    log.showInfo(TAG, `onSessionDestroy`);
    this.setHideNonSecureWindows(session, false);
  }

  /**
   * 隐藏非安全窗口
   * @param session UIExtensionContentSession
   * @param flag boolean
   */
  private setHideNonSecureWindows(session: UIExtensionContentSession, flag: boolean): void {
    log.showInfo(TAG, `setHideNonSecureWindows flag: ${flag}`);
    try {
      const extensionHostWindow = session?.getUIExtensionHostWindowProxy();
      extensionHostWindow?.hideNonSecureWindows(flag);
    } catch (err) {
      log.showError(TAG, `setHideNonSecureWindows failed code: ${err?.code}, message: ${err?.message} `);
    }
  }

  onDestroy(): void {
    log.showInfo(TAG, 'onDestroy');
  }
}