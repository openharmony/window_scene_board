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

import { LogDomain, LogHelper, ArrayUtils } from '@ohos/basicutils';
import { SCBSceneInfo, SCBSceneSessionManager, SceneInfoAdapterUtil } from '@ohos/windowscene';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { AppModel } from '../model/AppModel';
import type { AppItemInfo } from '../bean/AppItemInfo';
import { VassistantConstants } from '@ohos/commonconstants';

const TAG = 'UsageStatisticUtils';
const APP_MAX_AMOUNT: number = 20;
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class UsageStatisticUtils {
  private static readonly recentlyUsedApps: AppItemInfo[] = [];

  /**
   * get recently used apps
   *
   * @returns recentlyUsedApps
   */
  public static getRecentlyUsedApps(): AppItemInfo[] {
    log.showInfo('getRecentlyUsedApps');
    ArrayUtils.clearArr(UsageStatisticUtils.recentlyUsedApps);
    let sessionList = SCBSceneSessionManager.getInstance().getContainerSessionList();
    if (ArrayUtils.isEmpty(sessionList)) {
      return UsageStatisticUtils.recentlyUsedApps;
    }

    for (let index = sessionList.length - 1; index >= 0; index--) {
      let sceneInfo: SCBSceneInfo | undefined = sessionList[index].primarySession?.sceneInfo;
      if (!sceneInfo) {
        continue;
      }
      if (sceneInfo?.bundleName === VassistantConstants.VASSISTANT_BUNDLE_NAME) {
        sceneInfo = SceneInfoAdapterUtil.getAdapterSceneInfo(sceneInfo.bundleName,
          sceneInfo.moduleName, sceneInfo.abilityName, sceneInfo.appIndex);
      }
      let appInfo = ObjectCopyUtil.deepClone(AppModel.getInstance().getAppInfoByBundleName(
        sceneInfo.bundleName));
      if (appInfo) {
        appInfo.appIndex = sceneInfo.appIndex ?? 0;
        if (!ArrayUtils.contains(UsageStatisticUtils.recentlyUsedApps, appInfo)) {
          UsageStatisticUtils.recentlyUsedApps.push(appInfo);
        }
        if (UsageStatisticUtils.recentlyUsedApps.length >= APP_MAX_AMOUNT) {
          return UsageStatisticUtils.recentlyUsedApps;
        }
      }
    }
    return UsageStatisticUtils.recentlyUsedApps;
  }
}