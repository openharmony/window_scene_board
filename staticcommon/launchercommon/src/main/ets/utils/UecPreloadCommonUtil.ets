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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';

const TAG: string = 'UecPreloadCommonUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

const BUNDLE_NAME:string = 'com.ohos.sceneboard';
const ABILITY_NAME:string = 'EngineServiceAbility';

export class UecPreloadCommonUtil {
  /**
   * 预加载UIExtensionAbility
   */
  public static async preloadUIExtensionAbility(want: Want): Promise<void> {
    if (await UecPreloadCommonUtil.isAbilityLoaded(want)) {
      log.showInfo(`${want?.abilityName} uiExtAbility has loaded`);
      return;
    }
    try {
      GlobalContext?.getContext().getApplicationContext().preloadUIExtensionAbility(want);
      log.showInfo(`${want?.abilityName} uiExtAbility preload success`);
    } catch (err) {
      log.showError(`${want?.abilityName} preloadUIExtensionAbility failed errCode: ${err.code}`);
    }
  }

  private static async isAbilityLoaded(want: Want): Promise<boolean> {
    try {
      const bundleName:string = want?.bundleName ?? BUNDLE_NAME;
      const abilityName:string = want?.abilityName ?? ABILITY_NAME;
      const processInformation: appManager.ProcessInformation[] =
        await appManager.getRunningProcessInfoByBundleName(bundleName);
      if (!processInformation) {
        log.showInfo(`${abilityName} uiExtAbility not load`);
        return false;
      }
      for (let info of processInformation) {
        if (info?.processName?.match(abilityName)) {
          log.showInfo(`${abilityName} uiExtAbility has load`);
          return true;
        }
      }
    } catch (err) {
      log.showError(`${want?.abilityName} getRunningProcessInfoByBundleName failed, errCode: ${err.code}`);
    }
    return false;
  }
}
