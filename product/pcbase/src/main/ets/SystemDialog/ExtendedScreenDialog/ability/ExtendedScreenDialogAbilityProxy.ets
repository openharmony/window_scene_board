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
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import { LogDomain, LogHelper } from '@ohos/basicutils';

// 自定义的Ability需继承UIExtensionAbility
const TAG = 'ExtendedScreenDialogAbilityProxy';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
export default class ExtendedScreenDialogAbilityProxy {
  private static mInstance: ExtendedScreenDialogAbilityProxy;

  public static getInstance(): ExtendedScreenDialogAbilityProxy {
    if (!ExtendedScreenDialogAbilityProxy.mInstance) {
      ExtendedScreenDialogAbilityProxy.mInstance = new ExtendedScreenDialogAbilityProxy();
    }
    return ExtendedScreenDialogAbilityProxy.mInstance;
  }

  onCreate() {
    log.showInfo('ExtendedScreenDialogAbility onCreate');
  }

  onDestroy(): void {
    log.showInfo('ExtendedScreenDialogAbility onDestroy');
  }

  onForeground(): void {
    log.showInfo('ExtendedScreenDialogAbility onForeground');
  }

  onBackground(): void {
    log.showInfo('ExtendedScreenDialogAbility onBackground');
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession): void {
    log.showInfo('ExtendedScreenDialogAbility onSessionCreate');
    try {
      let storage: LocalStorage = new LocalStorage();
      storage.setOrCreate('session', session);
      // 加载自定义的页面
      log.showInfo('ExtendedScreenDialogAbility set session to TaskStopPage');
      session.loadContent('SystemDialog/ExtendedScreenDialog/pages/ExtendedScreenDialogPage', storage);
      // 设置窗口透明
      session.setWindowBackgroundColor('#00000000');
    } catch (e) {
      log.showError(`ExtendedScreenDialogAbility Session loadContent fail: ${e?.message} - ${e?.code}`);
    }
  }

  onSessionDestroy(session: UIExtensionContentSession) {
    log.showInfo('ExtendedScreenDialogAbility onSessionDestroy');
  }
}