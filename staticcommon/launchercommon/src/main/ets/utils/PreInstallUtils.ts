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
  LogDomain,
  LogHelper,
  FileUtils,
  CommonUtils
} from '@ohos/basicutils';
import { AppStatus, CommonConstants, DownloadInfoItem } from '../constants/CommonConstants';
import { AppItemInfo } from '../bean/AppItemInfo';
import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { dbCache } from '@ohos/frameworkwrapper/src/main/ets/resourcemanager/cache/DbCache';
import { PreInstallConstants, RdbStoreManager } from '../TsIndex';
import { HashMap } from '@kit.ArkTS';

const TAG = 'PreInstallUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const THIRD_PART_APP_LIST_PATH = '/data/bms/uninstalled_preload/thirdPartyAppList.json';

/**
 * 将卸载的三方预装软件图标置灰，点击重新下载
 */
export class PreInstallUtils {
  private static unInstallPreloadList: string[] = [];
  private static iconsResourceMap: HashMap<string, string>;
  /**
   * 开机时读取BMS不卸载清单，并获取对应的应用图标资源
   */
  public static async initNeedInstallAppCache(): Promise<void> {
    const thirdPartAppList: IJsonThirdPart = FileUtils.readJsonFile(THIRD_PART_APP_LIST_PATH);
    if (thirdPartAppList && thirdPartAppList.uninstall_preload_list &&
      thirdPartAppList.uninstall_preload_list.length > 0 && Array.isArray(thirdPartAppList.uninstall_preload_list)) {
      PreInstallUtils.unInstallPreloadList = thirdPartAppList.uninstall_preload_list;

      const result = await dbCache.getIconByBundles(Array.from(PreInstallUtils.unInstallPreloadList as string[]), true);
      PreInstallUtils.iconsResourceMap = result;
    }
  }

  /**
   * 判断应用是否需要置灰
   * @param appInfo
   */
  public static checkIsNeedInstallApp(appInfo: AppItemInfo | GridLayoutItemInfo): boolean {
    // 如果是分身应用，直接删除
    if (appInfo.appIndex !== CommonConstants.MAIN_APP_INDEX) {
      return false;
    }

    if (PreInstallUtils.checkIsNeedInstallAppByIntent(appInfo)) {
      return true;
    }

    const thirdPartApp = PreInstallUtils.unInstallPreloadList.find((item: string) => {
      return item === appInfo.bundleName && appInfo.typeId === CommonConstants.TYPE_APP;
    });

    if (thirdPartApp) {
      const intent = CommonUtils.jsonStrToMap(appInfo.intent);
      intent.set(PreInstallConstants.IS_NEED_INSTALLED_APP, true);
      appInfo.intent = CommonUtils.mapToJonStr(intent);
      appInfo.appStatus = AppStatus.PENDING;
      appInfo.abilityName = '';
      appInfo.moduleName = undefined;
      appInfo.keyName = appInfo.bundleName + appInfo.appIndex;
      if (!appInfo.iconResource) {
        const iconInfoResource = PreInstallUtils.iconsResourceMap.get(appInfo.bundleName);
        if (iconInfoResource) {
          appInfo.iconResource = iconInfoResource;
        }
      }
      log.showWarn(`preInstall needInstallAppInfo: ${JSON.stringify(appInfo)}`);
      return true;
    }
    return false;
  }

  /**
   * 判断应用intent字段是否有过置灰标记
   * @param appInfo
   */
  public static checkIsNeedInstallAppByIntent(appInfo: AppItemInfo | GridLayoutItemInfo): boolean {
    const intent: Map<string, Object> = CommonUtils.jsonStrToMap(appInfo.intent);
    return intent.get(PreInstallConstants.IS_NEED_INSTALLED_APP) as boolean;
  }

  /**
   * 将需要置灰的应用统一放在数组中
   * @param appInfo
   * @param layoutInfo
   */
  public static checkIsResetAppInfo(appInfo: GridLayoutItemInfo, layoutInfo: GridLayoutItemInfo,
    needResetAppInfoList: GridLayoutItemInfo[]): void {
    if (PreInstallUtils.checkIsNeedInstallAppByIntent(layoutInfo)) {
      needResetAppInfoList.push(appInfo);
    }
  }

  /**
   * 修改置灰应用列表中应用的状态
   * @param needResetAppInfoList
   */
  public static resetAppInfoList(needResetAppInfoList: GridLayoutItemInfo[]): void {
    needResetAppInfoList.forEach(appInfo => {
      appInfo.appStatus = AppStatus.PENDING;
      appInfo.abilityName = '';
      appInfo.moduleName = undefined;
      appInfo.keyName = appInfo.bundleName + appInfo.appIndex;
      if (!appInfo.iconResource) {
        const iconInfoResource = PreInstallUtils.iconsResourceMap.get(appInfo.bundleName);
        if (iconInfoResource) {
          appInfo.iconResource = iconInfoResource;
        }
      }
      // 修改表中的数据
      RdbStoreManager.getInstance().updateDownloadInfo(appInfo as DownloadInfoItem);
    });
    needResetAppInfoList = [];
  }

  /**
   * 删除intent里的isNeedInstallApp字段
   * @param appInfo
   */
  public static resetIntent(appInfo: AppItemInfo | GridLayoutItemInfo): void {
    const intent = CommonUtils.jsonStrToMap(appInfo.intent);
    if (intent.get(PreInstallConstants.IS_NEED_INSTALLED_APP)) {
      intent.delete(PreInstallConstants.IS_NEED_INSTALLED_APP);
      appInfo.intent = CommonUtils.mapToJonStr(intent);
      const downloadInfo: DownloadInfoItem = {
        bundleName: appInfo.bundleName,
        intent: appInfo.intent
      };
      // 修改表中的数据
      RdbStoreManager.getInstance().updateDownloadInfo(downloadInfo);
    }
  }
}

export interface IJsonThirdPart {
  uninstall_preload_list: string[];
}