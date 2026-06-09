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

import { LogDomain, LogHelper, CommonUtils } from '@ohos/basicutils';
import { AppItemInfo } from '../bean/AppItemInfo';
import { DockItemInfo } from '../bean/DockItemInfo';
import { RdbStoreManager } from '../db/RdbStoreManager';
import { AppModel } from '../model/AppModel';
import { CommonConstants, NotHarmonyUtil } from '../TsIndex';

const TAG = 'CommonDockModel';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class CommonDockModel {
  private static instance?: CommonDockModel;

  /**
   * 获取单例类
   */
  public static getInstance(): CommonDockModel {
    if (!CommonDockModel.instance) {
      CommonDockModel.instance = new CommonDockModel();
    }
    return CommonDockModel.instance;
  }

  /**
   * 查询smartDock元素
   *
   * @returns smartDock元素列表
   */
  public async querySmartDock(isOuter?: boolean, tableName?: string): Promise<DockItemInfo[]> {
    let dockItems: DockItemInfo[] = await RdbStoreManager.getInstance().querySmartDock(isOuter, tableName);
    dockItems.forEach((itemInfo) => {
      let findItem: AppItemInfo | undefined = AppModel.getInstance().getAppInfoByKeyName(itemInfo.keyName ?? '');
      itemInfo.installTime = findItem?.installTime;
      itemInfo.isSystemApp = findItem?.isSystemApp;
      itemInfo.isUninstallAble = findItem?.isUninstallAble;
      itemInfo.badgeNumber = findItem?.badgeNumber;
      itemInfo.codePath = findItem?.codePath;
      if (NotHarmonyUtil.isNotHarmonyFolderByIntent(itemInfo.intent ?? '') || itemInfo.appName === '${not_harmony_apps}') {
        log.showInfo('init not harmony folder in dock');
        let map: Map<string, Object> = CommonUtils.jsonStrToMap(itemInfo.intent);
        if (!map.has(NotHarmonyUtil.NOT_HARMONY_FOLDER_KEY_NAME_FOR_INTENT)) {
          let intentMap: Map<string, string> = new Map();
          intentMap.set(NotHarmonyUtil.NOT_HARMONY_FOLDER_KEY_NAME_FOR_INTENT, itemInfo.appId ?? '');
          itemInfo.intent = CommonUtils.mapToJonStr(intentMap);
          RdbStoreManager.getInstance().updateFolderIntentByInfoId(itemInfo.appId ?? '', itemInfo.intent);
        }
        NotHarmonyUtil.setNotHarmonyFolderId(itemInfo.appId ?? '');
      }
    });
    return dockItems;
  }

  /**
   * 查询recentDock元素
   *
   * @returns recentDock元素列表
   */
  public async queryRecentDock(): Promise<DockItemInfo[]> {
    let dockItems: DockItemInfo[] = await RdbStoreManager.getInstance().queryRecentDock();
    dockItems.forEach((itemInfo) => {
      let appInfo = AppModel.getInstance().getAppInfoByKeyName(itemInfo.keyName ?? '');
      itemInfo.appIconId = appInfo?.appIconId ?? 0;
      itemInfo.badgeNumber = appInfo?.badgeNumber;
    });
    return dockItems;
  }
}