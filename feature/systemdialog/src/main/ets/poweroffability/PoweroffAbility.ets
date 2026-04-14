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

import Want from '@ohos.app.ability.Want';
import type { BusinessError } from '@ohos.base';
import UIExtensionAbility from '@ohos.app.ability.UIExtensionAbility';
import { LogDomain, Logger } from '@ohos/basicutils';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { poweroffController } from '../controller/PoweroffController';
import { ResourceUtil } from '../common/ResourceUtil';

const TAG = 'PoweroffAbility';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

export class PoweroffAbility extends UIExtensionAbility {
  onCreate() {
    ResourceUtil.setContext(this.context);
    log.showInfo(TAG, 'onCreate');
  }

  onDestroy(): void {
    log.showInfo(TAG, 'onDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    log.showInfo(TAG, 'onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    log.showInfo(TAG, 'onBackground');
  }

  /**
   * 隐藏非安全窗口
   * @param session UIExtensionContentSession
   * @param flag boolean
   */
  private setHideNonSecureWindows(session: UIExtensionContentSession, flag: boolean): void {
    log.showInfo(TAG, `setHideNonSecureWindows flag: ${flag}`);
    try {
      const extensionHostWindow = session.getUIExtensionHostWindowProxy();
      extensionHostWindow.hideNonSecureWindows(flag);
    } catch (err) {
      const code = (err as BusinessError)?.code;
      const message = (err as BusinessError)?.message;
      log.showError(TAG, `setHideNonSecureWindows failed code: ${code}, message: ${message} `);
    }
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession): void {
    log.showInfo(TAG, 'onSessionCreate');
    poweroffController.setSession(session);
    let storage: LocalStorage = new LocalStorage();
    storage.setOrCreate('session', session);
    session.loadContent('SystemDialog/pages/PoweroffIndex', storage);
    // 设置窗口透明
    session.setWindowBackgroundColor('#00000000');
    this.setHideNonSecureWindows(session, true);
  }

  onSessionDestroy(session: UIExtensionContentSession): void {
    this.setHideNonSecureWindows(session, false);
  }
}
