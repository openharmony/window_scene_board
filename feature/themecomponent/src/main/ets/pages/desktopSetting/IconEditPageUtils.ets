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
import { appManager } from '@kit.AbilityKit';
import { Log } from '../../aigcServiceAbility/IdlService/Log';

const TAG: string = 'IconEditPageUtil';

/**
 * IconEditPage 工具类
 */
export class IconEditPageUtils {
  /**
   * 预加载EditModeIconAbility
   */
  static async preloadIconEditPageExtAbility(context: Context,
    abilityName: string, parameters: Record<string, Object>
  ): Promise<void> {
    if (!context) {
      Log.error(TAG, 'context is null');
      return;
    }
    const iconEditPageLoaded: boolean = await IconEditPageUtils.isIconEditPageLoaded(abilityName);
    if (iconEditPageLoaded) {
      Log.info(TAG, 'iconEditPage uiExtAbility has loaded');
      return;
    }
    const iconEditPageWant: Want = {
      bundleName: 'com.ohos.sceneboard',
      abilityName: abilityName,
      parameters: parameters
    };
    try {
      await context.getApplicationContext().preloadUIExtensionAbility(iconEditPageWant);
      Log.info(TAG, 'preloadUIExtensionAbility success');
    } catch (err) {
      Log.error(TAG, `preloadUIExtensionAbility failed errCode: ${err.code}, errMessage: ${err.message}`);
    }
  }

  static async isIconEditPageLoaded(abilityName: string): Promise<boolean> {
    try {
      const processInformation: appManager.ProcessInformation[] =
        await appManager.getRunningProcessInfoByBundleName('com.ohos.sceneboard');
      if (!processInformation) {
        Log.info(TAG, 'IconEditPage uiExtAbility not load');
        return false;
      }
      for (let info of processInformation) {
        if (info?.processName?.match(abilityName)) {
          Log.info(TAG, 'uiExtAbility has load');
          return true;
        }
      }
    } catch (err) {
      Log.error(TAG, `getRunningProcessInfoByBundleName failed errCode: ${err.code}, errMessage: ${err.message}`);
    }
    return false;
  }
}
