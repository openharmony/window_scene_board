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

import { Context } from '@ohos/windowsceneinterfaces';
import Want from '@ohos.app.ability.Want';
import { appManager } from '@kit.AbilityKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG: string = 'SubThemeUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const ABILITY_NAME: string = 'CoverExtensionAbility';
const BUNDLE_NAME: string = 'com.ohos.sceneboard';

/**
 * Theme 工具类
 *
 * @since 2025-01-06
 */
export class SubThemeUtils {
  /**
   * 预加载CoverExtensionAbility
   */
  static async preloadThemeExtAbility(context: Context): Promise<void> {
    if (!context) {
      log.showError('context is null');
      return;
    }
    const themeLoaded: boolean = await this.isThemeLoaded();
    if (themeLoaded) {
      log.showInfo('theme uiExtAbility has loaded skip preloadThemeExtAbility');
      return;
    }
    const themeWant: Want = {
      bundleName: BUNDLE_NAME,
      abilityName: ABILITY_NAME,
      parameters: {
        'ability.want.params.uiExtensionType': 'sys/commonUI',
        'nav': 'subThemeGallery',
        'isFull': false
      }
    };
    try {
      context.getApplicationContext().preloadUIExtensionAbility(themeWant);
      log.showInfo('theme uiExtAbility load success');
    } catch (err) {
      log.showError(`preloadUIExtensionAbility failed errCode: ${err.code}}`);
    }
  }

  static async isThemeLoaded(): Promise<boolean> {
    let result: boolean = false;
    const processInformation: appManager.ProcessInformation[] =
      await appManager.getRunningProcessInfoByBundleName(BUNDLE_NAME);
    if (!processInformation) {
      log.showInfo('theme uiExtAbility not load');
      return result;
    }
    try {
      for (let info of processInformation) {
        if (info?.processName?.match(ABILITY_NAME)) {
          log.showInfo('uiExtAbility has loaded skip preloadThemeExtAbility');
          result = true;
          break;
        }
      }
    } catch (err) {
      log.showError(`getRunningProcessInfoByBundleName failed errCode: ${err.code}`);
    }
    return result;
  }
}
