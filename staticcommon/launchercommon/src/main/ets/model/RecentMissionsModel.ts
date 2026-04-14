/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';
import { commonBundleManager } from '@ohos/frameworkwrapper';
import bundleManager from '@ohos.bundle.bundleManager';

const TAG = 'RecentMissionsModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Recent missions data model.
 */
export class RecentMissionsModel {

  private static mInstance: RecentMissionsModel;

  private constructor() {
  }

  /**
   * Return an instance of RecentMissionsModel.
   *
   * @return {object} the model.
   */
  static getInstance(): RecentMissionsModel {
    if (!RecentMissionsModel.mInstance) {
      RecentMissionsModel.mInstance = new RecentMissionsModel();
    }
    return RecentMissionsModel.mInstance;
  }

  async getHapAbilityInfoAsync(bundleName: string, moduleName: string): Promise<bundleManager.AbilityInfo> {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName) || CheckEmptyUtils.checkStrIsEmpty(moduleName)) {
      log.showError('getHapAbilityInfoAsync reqParam bundleName is empty');
      return null;
    }
    let bundleInfo: bundleManager.BundleInfo | undefined =
     await commonBundleManager.getBundleInfoByBundleName(bundleName, bundleManager.BundleType.ATOMIC_SERVICE);
    if (CheckEmptyUtils.isEmpty(bundleInfo)) {
      bundleInfo = await commonBundleManager.getBundleInfoByBundleName(bundleName, bundleManager.BundleType.APP);
    }
    if (!bundleInfo) {
      log.showError(`getHapAbilityInfoAsync by bundleName:${bundleName} no result`);
      return null;
    }
    if (CheckEmptyUtils.isEmptyArr(bundleInfo.hapModulesInfo)) {
      log.showError('getHapAbilityInfoAsync bundleInfo.hapModulesInfo is empty');
      return null;
    }
    for (let i = 0; i < bundleInfo.hapModulesInfo.length; i++) {
      if (CheckEmptyUtils.isEmptyArr(bundleInfo.hapModulesInfo[i].abilitiesInfo)) {
        continue;
      }
      for (let j = 0; j < bundleInfo.hapModulesInfo[i].abilitiesInfo.length; j++) {
        if (bundleInfo.hapModulesInfo[i].abilitiesInfo[j].moduleName === moduleName) {
          log.showDebug('getHapAbilityInfoAsync success');
          return bundleInfo.hapModulesInfo[i].abilitiesInfo[j];
        }
      }
    }
    return null;
  }
}