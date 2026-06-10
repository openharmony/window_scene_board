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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { bundleManager, Want } from '@kit.AbilityKit';
import { SCBSceneContainerSession, SCBSceneInfo, SCBSceneInfoFromScreenLock, SCBSceneSessionManager } from '../TsIndex';

const TAG: string = 'SceneInfoAdapterUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * adapter util
 */
export class SceneInfoAdapterUtil {
  /**
   * 桌面图标信息适配
   */
  public static getAdapterSceneInfo(bundleName: string, moduleName: string, abilityName: string,
    appIndex?: number): SCBSceneInfo {
    let sceneInfo: SCBSceneInfo;
    sceneInfo = new SCBSceneInfo(bundleName, moduleName, abilityName, appIndex);
    const queryKey = `${bundleName}${moduleName}${abilityName}`;
    sceneInfo.launchType = SCBSceneSessionManager.getInstance().getAbilityLaunchType(queryKey);
    return sceneInfo;
  }

  /**
   * 从运行的服务中获取多任务标题的labelId
   */
  public static getAdapterLabelId(bundleName: string, abilityName: string): number | undefined {
    try {
      let extensionAbilityType: bundleManager.ExtensionAbilityType = bundleManager.ExtensionAbilityType.SERVICE;
      let extensionFlags: bundleManager.ExtensionAbilityFlag =
        bundleManager.ExtensionAbilityFlag.GET_EXTENSION_ABILITY_INFO_DEFAULT;
      let want: Want = {
        bundleName: bundleName,
        abilityName: abilityName
      };
      let extensionInfo = bundleManager.queryExtensionAbilityInfoSync(want, extensionAbilityType, extensionFlags);
      return extensionInfo[0].labelId;
    } catch (err) {
      log.showError(`getAdapterLabelId error, code: ${err.code}, message: ${err.message}`);
      return undefined;
    }
  }

  public static getScreenLockInfo(sceneContainerSession: SCBSceneContainerSession): SCBSceneInfoFromScreenLock | null {
    const sceneInfo = sceneContainerSession?.primarySession?.sceneInfo;
    if (sceneInfo instanceof SCBSceneInfoFromScreenLock) {
      return sceneInfo;
    }
    return null;
  }
}