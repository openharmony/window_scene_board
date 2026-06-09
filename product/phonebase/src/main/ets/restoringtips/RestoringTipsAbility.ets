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

import Want from '@ohos.app.ability.Want';
import UIExtensionAbility from '@ohos.app.ability.UIExtensionAbility';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { restoringTipsController } from './RestoringTipsController';

const TAG = 'RestoringTipsAbility';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const BG_COLOR_TRANSPARENT = '#00000000';

export default class RestoringTipsAbility extends UIExtensionAbility {
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

  /**
   * 隐藏非安全窗口
   * @param session UIExtensionContentSession
   * @param flag boolean
   */
  private setHideNonSecureWindows(session: UIExtensionContentSession, flag: boolean): void {
    const extensionHostWindow = session.getUIExtensionHostWindowProxy();
    extensionHostWindow.hideNonSecureWindows(flag);
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession): void {
    log.showInfo('onSessionCreate');
    restoringTipsController.setSession(session);
    session.loadContent('restoringtips/RestoringTipsDialog');
    session.setWindowBackgroundColor(BG_COLOR_TRANSPARENT);
    this.setHideNonSecureWindows(session, true);
  }

  onSessionDestroy(session: UIExtensionContentSession): void {
    this.setHideNonSecureWindows(session, false);
  }
}
