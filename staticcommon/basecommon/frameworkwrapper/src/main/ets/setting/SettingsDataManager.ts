/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper, DomainName} from '@ohos/basicutils';
import { GlobalContext } from '../utils/GlobalContext';
import settings from '@ohos.settings';
import dataShare from '@ohos.data.dataShare';
import type ctx from '@ohos.app.ability.common';
import { AsyncCallback } from '@kit.BasicServicesKit';
import { BusinessError } from '@ohos.base';

const TAG = 'SettingsDataManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Wrapper class for settings interfaces.
 */
class SettingsDataManager {
  private readonly uriShare: string = 'datashare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true&key=';
  private dataShareHelper: dataShare.DataShareHelper | undefined = undefined;

  private constructor() {
  }

  /**
   * settingsData manager instance
   *
   * @return settingsDataManager instance
   */
  static getInstance(): SettingsDataManager {
    if (globalThis.SettingsDataManagerInstance == null) {
      globalThis.SettingsDataManagerInstance = new SettingsDataManager();
    }
    return globalThis.SettingsDataManagerInstance;
  }

  public createDataShareHelper(): void {
    log.showInfo('createDataShareHelper context:' + GlobalContext.getInstance().getObject('desktopContext'));
    try {
      dataShare.createDataShareHelper((GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext), this.uriShare)
        .then((dataHelper) => {
          log.showInfo('then dataHelper:' + dataHelper);
          this.dataShareHelper = dataHelper;
        })
        .catch((error: BusinessError) => {
          log.error('createDataShareHelper error', error);
        });
    } catch (error) {
      log.error('createDataShareHelper error', error);
    }

  }

  /**
   * Update settingData by settingDataKey.
   */
  setValue(helper: dataShare.DataShareHelper | undefined | null, settingDataKey: string, value: string): void {
    log.showInfo('setValue:' + value);
    try {
      settings.setValueSync((GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext), settingDataKey, value);
    } catch (err) {
      log.showInfo('setValue err : %{public}s', err?.message);
    }
  }

  /**
   * Update settingData by settingDataKey.
   */
  setValueWithDomain(settingDataKey: string, value: string,
    domain: string = settings.domainName.USER_PROPERTY): void {
    log.showInfo('setValueWithDomain:' + value);
    try {
      settings.setValueSync((GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext),
        settingDataKey, value, domain);
    } catch (err) {
      log.showInfo('setValueWithDomain err : %{public}s', err?.message);
    }
  }

  /**
   * get settingDataValue by settingDataKey.
   *
   * @return settingsDataValue by settingDataKey.
   */
  getValue(helper: dataShare.DataShareHelper | undefined | null, settingDataKey: string, defaultValue: string): string {
    try {
      let value: string = settings.getValueSync((GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext), settingDataKey, defaultValue);
      log.showInfo('getValue:' + value);
      return value;
    } catch (err) {
      log.showInfo('getValue err : %{public}s', err?.message);
    }
    return '';
  }

  /**
   * get settingDataValue by settingDataKey.
   *
   * @return settingsDataValue by settingDataKey.
   */
  getValueWithDomain(settingDataKey: string, defaultValue: string,
    domain: string = settings.domainName.USER_PROPERTY): string {
    try {
      let value: string =
        settings.getValueSync((GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext),
          settingDataKey, defaultValue, domain);
      log.showInfo('getValueWithDomain:' + value);
      return value;
    } catch (err) {
      log.showInfo('getValueWithDomain err : %{public}s', err?.message);
    }
    return '';
  }

  /**
   * get settingDataUri by settingDataKey.
   *
   * @return settingDataUri by settingDataKey.
   */
  getUri(settingDataKey: string): string {
    return this.uriShare + settingDataKey;
  }

  /**
   * get settingDataHelper by settingDataKey.
   *
   * @return settingDataHelper by settingDataUri.
   */
  getHelper(): dataShare.DataShareHelper | undefined {
    return this.dataShareHelper;
  }

  /**
   * Monitor registration key(synchronous method)
   *
   * @returns { boolean } Returns {@code true} if the operation is successful; returns {@code false} otherwise.
   */
  registerKeyObserver(settingDataKey: string, observer: AsyncCallback<void>): boolean {
    try {
      return settings.registerKeyObserver((GlobalContext.getInstance().getObject('desktopContext') as
      ctx.ServiceExtensionContext), settingDataKey, DomainName.SCB, observer);
    } catch (err) {
      log.showInfo('registerKeyObserver err : %{public}s', err?.message);
    }
    return false;
  }

  /**
   * Monitor registration key(synchronous method)
   *
   * @returns { boolean } Returns {@code true} if the operation is successful; returns {@code false} otherwise.
   */
  registerKeyObserverWithDomain(settingDataKey: string, observer: AsyncCallback<void>,
    domain: string = settings.domainName.USER_PROPERTY): boolean {
    try {
      return settings.registerKeyObserver((GlobalContext.getInstance().getObject('desktopContext') as
      ctx.ServiceExtensionContext), settingDataKey, domain, observer);
    } catch (err) {
      log.showInfo('registerKeyObserverWithDomain err : %{public}s', err?.message);
    }
    return false;
  }

  /**
   * Monitor unregister key(synchronous method)
   *
   * @returns { boolean } Returns {@code true} if the operation is successful; returns {@code false} otherwise.
   */
  unregisterKeyObserver(settingDataKey: string): boolean {
    try {
      return settings.unregisterKeyObserver((GlobalContext.getInstance().getObject('desktopContext') as
      ctx.ServiceExtensionContext), settingDataKey, DomainName.SCB);
    } catch (err) {
      log.showInfo('unregisterKeyObserver err : %{public}s', err?.message);
    }
    return false;
  }

  /**
   * Monitor unregister key(synchronous method)
   *
   * @returns { boolean } Returns {@code true} if the operation is successful; returns {@code false} otherwise.
   */
  unregisterKeyObserverWithDomain(settingDataKey: string, domain: string = settings.domainName.USER_PROPERTY): boolean {
    try {
      return settings.unregisterKeyObserver((GlobalContext.getInstance().getObject('desktopContext') as
      ctx.ServiceExtensionContext), settingDataKey, domain);
    } catch (err) {
      log.showInfo('unregisterKeyObserverWithDomain err : %{public}s', err?.message);
    }
    return false;
  }
}

export const settingsDataManager = SettingsDataManager.getInstance();