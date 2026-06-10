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
import { CustomMessageBase } from './CustomMessageBase';
import { settings } from '@kit.BasicServicesKit';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlobalContext, settingsDataManager } from '@ohos/frameworkwrapper';

const TAG = 'FocusEnableCustomMessage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

const focusModeEnableKey = 'focus_mode_enable';

export class FocusEnableCustomMessage extends CustomMessageBase {
  protected initDiff(): boolean {
    this.registerFocusEnableListener();
    return true;
  }

  // 免打扰面板一级菜单监听逻辑控制显隐
  private registerFocusEnableListener(): void {
    log.showInfo('init FocusEnableListener begin');
    this.getFocusModeEnableFromSettings().then((res) => {
      this.updateVisible(res);
    });

    try {
      let res = settingsDataManager.registerKeyObserverWithDomain(focusModeEnableKey, () => {
        this.getFocusModeEnableFromSettings().then((res) => {
          log.showInfo(`FocusEnableListener regStatus listen change, enable status: ${res}`);
          this.updateVisible(res);
        })
      }, settings.domainName.USER_SECURITY);
      log.showInfo(`FocusEnableListener regStatus listen res: ${res}`);
    } catch (e) {
      log.showError(`FocusEnableListener regStatus fail`);
    }
  };

  private async getFocusModeEnableFromSettings(): Promise<boolean> {
    let res: boolean = false;
    try {
      let focusMode: string = await settings.getValue(GlobalContext.getContext(),
        focusModeEnableKey, settings.domainName.USER_SECURITY);
      res = focusMode === '1';
    } catch (e) {
      log.showError(`getFocusModeEnableFromSettings fail, error: ${e?.message}`);
    }
    return res;
  }

  protected deInitDiff(): void {
    this.unregisterFocusEnableListener();
  }

  // 免打扰面板注销监听
  private unregisterFocusEnableListener(): void {
    log.showInfo('unregisterFocusEnableListener begin');
    const focusModeEnableKey = 'focus_mode_enable';
    try {
      let res =
        settingsDataManager.unregisterKeyObserverWithDomain(focusModeEnableKey, settings.domainName.USER_SECURITY);
      log.showInfo(`FocusEnableListener unregStatus listen res: ${res}`);
    } catch (e) {
      log.showError(`FocusEnableListener unregStatus fail`);
    }
  };
}