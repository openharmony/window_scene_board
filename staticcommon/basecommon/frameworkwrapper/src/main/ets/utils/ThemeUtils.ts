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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import Want from '@ohos.app.ability.Want';
import { viewMgrPolicy, ViewType } from '../manager/view/ViewManagerPolicy';
import { appManager } from '@kit.AbilityKit';

const TAG: string = 'ThemeUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * Theme 工具类
 *
 * @since 2024-07-26
 */
export class ThemeUtils {

  /**
   * 预加载HomeThemeComponentExtAbility
   */
  static async preloadThemeExtAbility(context: Context, shouldCheckIsLoaded?: boolean): Promise<void> {
    if (!context) {
      log.showError('context is null');
      return;
    }
    if ((shouldCheckIsLoaded ?? true) && await this.isThemeLoaded()) {
      log.showInfo('theme uiExtAbility has loaded');
      return;
    }
    const themeWant: Want = {
      bundleName: 'com.ohos.sceneboard',
      abilityName: 'HomeThemeComponentExtAbility',
      parameters: {
        'ability.want.params.uiExtensionType': 'sys/commonUI',
        'nav': 'wallpaperPicker',
        'isFull': false,
        'statusBarHeight': viewMgrPolicy.getViewController(ViewType.STATUS_BAR)?.getArea().height
      }
    };
    try {
      context.getApplicationContext().preloadUIExtensionAbility(themeWant);
      log.showInfo('theme uiExtAbility preload success');
    } catch (err) {
      log.showError(`preloadUIExtensionAbility failed errCode: ${err.code}, errMessage: ${err.message}`);
    }
  }

  static async isThemeLoaded(): Promise<boolean> {
    let result: boolean = false;
    try {
      const processInformation: appManager.ProcessInformation[] =
        await appManager.getRunningProcessInfoByBundleName('com.ohos.sceneboard');
      if (!processInformation) {
        log.showInfo('theme uiExtAbility not load');
        return result;
      }
      for (let info of processInformation) {
        if (info?.processName?.match(`HomeThemeComponentExtAbility`)) {
          log.showInfo('uiExtAbility has load');
          result = true;
        }
      }
    } catch (err) {
      log.showError(`getRunningProcessInfoByBundleName failed errCode: ${err.code}, errMessage: ${err.message}`);
    }
    return result;
  }
}
