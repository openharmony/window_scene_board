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

import { settingsDataManager } from '@ohos/frameworkwrapper';
import settings from '@ohos.settings';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG: string = 'InversionDetector';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

const ACCESSIBILITY_DISPLAY_INVERSION_KEY: string = 'accessibility_display_inversion_enabled';

const DOMAIN_USER_SECURITY: string = settings.domainName.USER_SECURITY;

export class InversionDetector {

  private static inversionDetector: InversionDetector;
  private isDisplayInversionEnable: boolean = false;

  static getInstance(): InversionDetector {
    if (InversionDetector.inversionDetector == null) {
      log.showInfo('InversionDetector getInstance');
      InversionDetector.inversionDetector = new InversionDetector();
    }
    return InversionDetector.inversionDetector;
  }

  /**
   * Whether the Accessibility Display Inversion Mode is Enable.
   *
   * @returns true means InversionMode is On else Off.
   */
  public isInversionModeEnable(): boolean {
    return this.isDisplayInversionEnable;
  }

  /**
   * Register AccessibilityMode Listeners
   *
   */
  public registerAccessibilityListeners(): void {
    try {
      this.initInversionMode();
      this.registerDisplayInversionAsyncCallback();
    } catch (err) {
      log.showError(`registerAccessibilityListeners error ${err?.message}`);
    }
  }

  /**
   * UnRegister Accessibility Listeners from SettingsDataManager
   *
   */
  public unregisterAccessibilityListeners(): void {
    settingsDataManager.unregisterKeyObserverWithDomain(ACCESSIBILITY_DISPLAY_INVERSION_KEY, DOMAIN_USER_SECURITY);
  }

  private initInversionMode(): void {
    const newStatus: boolean = settingsDataManager
      .getValueWithDomain(ACCESSIBILITY_DISPLAY_INVERSION_KEY, '0', DOMAIN_USER_SECURITY) === '1';
    this.updateDisplayInversionMode(newStatus);
  }

  private updateDisplayInversionMode(newStatus: boolean): void {
    if (newStatus === this.isDisplayInversionEnable) {
      return;
    }
    log.showInfo(`updateDisplayInversionMode: ${newStatus}`);
    this.isDisplayInversionEnable = newStatus;
  }

  private registerDisplayInversionAsyncCallback(): boolean {
    return settingsDataManager.registerKeyObserverWithDomain(
      ACCESSIBILITY_DISPLAY_INVERSION_KEY,
      () => {
        let newValue: string = settingsDataManager
          .getValueWithDomain(ACCESSIBILITY_DISPLAY_INVERSION_KEY, '0', DOMAIN_USER_SECURITY);
        const newStatus: boolean = newValue === '1';
        log.showInfo(`accessibilityDisplayInversionStateChange: type ${typeof newValue} value ${newValue}`);
        this.updateDisplayInversionMode(newStatus);
      },
      DOMAIN_USER_SECURITY);
  }
}