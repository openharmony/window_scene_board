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

import {
  CommonConstants,
  DockItemInfo,
  FolderLayoutCacheManager,
  GridLayoutItemInfo
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { AppGalleryData } from '../data/AppGalleryData';
import { CommonUtils } from '@ohos/basicutils/src/main/ets/TsIndex';

/**
 * 应用安装帮助类
 */
export class InstallUtils {
  /**
   * 构建GridLayoutItemInfo
   * @param data
   * @returns
   */
  public static buildInsertItem(data: AppGalleryData): GridLayoutItemInfo {
    let item: GridLayoutItemInfo = new GridLayoutItemInfo();
    item.bundleName = data.bundleName;
    item.appIndex = CommonConstants.MAIN_APP_INDEX;
    item.keyName = data.bundleName + CommonConstants.MAIN_APP_INDEX;
    item.typeId = CommonConstants.TYPE_APP;
    item.appStatus = data.status;
    item.appName = data.appName;
    item.area = [1, 1];
    item.container = CommonConstants.CONTAINER_DESKTOP;
    if (data.isSupportShare !== undefined) {
      let intentMap: Map<string, Object> = CommonUtils.jsonStrToMap(item.intent);
      intentMap.set('isSupportShare', data.isSupportShare);
      item.intent = JSON.stringify(CommonUtils.mapToObject(intentMap));
    }
    return item;
  }

  /**
   * 获取folderId
   * @param findApp
   * @returns
   */
  public static getFolderId(findApp?: GridLayoutItemInfo | DockItemInfo ): string {
    let folderId = '';
    if (!findApp) {
      return folderId;
    }
    if (findApp.container !== CommonConstants.CONTAINER_DESKTOP &&
      findApp.container !== CommonConstants.CONTAINER_DOCK) {
      let folderItem = FolderLayoutCacheManager.getInstance().selectFolderByKeyName(findApp.keyName);
      if (folderItem) {
        folderId = folderItem.folderId ?? '';
      }
    }
    return folderId;
  }
}