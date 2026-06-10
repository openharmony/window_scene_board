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

import dataPreferences from '@ohos.data.preferences';
import type common from '@ohos.app.ability.common';
import type { BusinessError } from '@ohos.base';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { PreviewConstants } from '../../preview/PreviewConstants';
import { DesktopManager } from '@ohos/launchercommon/src/main/ets/TsIndex';

const LOGGER: LogHelper = LogHelper.getLogHelper(LogDomain.SCS, 'DesktopParamPreference');

export class DesktopParamPreference {
  private context: common.Context | common.ApplicationContext;
  private storeName: string;
  private preference: dataPreferences.Preferences | undefined;

  constructor(context: common.Context | common.ApplicationContext, storeName = 'DesktopParam') {
    this.context = context;
    this.storeName = storeName;
    try {
      dataPreferences.getPreferences(this.context, this.storeName).then((preferences: dataPreferences.Preferences) => {
        this.preference = preferences;
        // 默认为true
        this.setDesktopParamReady(true);
        DesktopManager.getInstance().saveDesktopParam();
        this.preference.on('multiProcessChange', this.preferenceCallback);
      });
    } catch (err) {
      LOGGER.showError(`getPreferences error:, ${(err as BusinessError).message}`);
    }
  }

  public preferenceCallback = async (key: string): Promise<void> => {
    try {
      if (key !== PreviewConstants.IS_DESKTOP_PARAM_READY) {
        return;
      }
      this.removeStoreCache();
      dataPreferences.getPreferences(this.context, this.storeName).then(
        async (preferences: dataPreferences.Preferences) => {
        this.preference = preferences;
        let isDesktopParamReady = this.preference.getSync(PreviewConstants.IS_DESKTOP_PARAM_READY, true) as boolean;
        LOGGER.showInfo(`preferenceCallback, isDesktopParamReady: ${isDesktopParamReady}, key: ${key}, dir: ${this.context.preferencesDir}`);
        if (!isDesktopParamReady) {
          DesktopManager.getInstance().saveDesktopParam();
          await this.setDesktopParamReady(true);
        }
        this.preference.on('multiProcessChange', this.preferenceCallback);
      });
    } catch (err) {
      LOGGER.showError(`preference error:, ${(err as BusinessError).message}`);
    }
  };

  private async setDesktopParamReady(isDesktopParamReady: boolean): Promise<void> {
    this.preference?.putSync(PreviewConstants.IS_DESKTOP_PARAM_READY, isDesktopParamReady);
    await this.preference?.flush();
    LOGGER.info('set isDesktopParamReady true, preferencesDir: ', this.context.preferencesDir);
  }

  public removeStoreCache(): void {
    dataPreferences.removePreferencesFromCacheSync(this.context, this.storeName);
    this.preference?.off('multiProcessChange', this.preferenceCallback);
  }
}