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

import { BusinessError } from '@kit.BasicServicesKit';
import {
  AppStatus,
  CommonConstants,
  GridLayoutItemInfo,
  LaunchLayoutCacheManager,
  AppReserveType,
  FolderLayoutCacheManager,
  DockItemInfo,
  LayoutViewModel,
  DownloadInfoItem,
  RdbStoreManager,
  LegacyInfo,
  ResidentLayoutCacheMgr,
  AppInstallUtils,
  AppCategoryInfoManager,
  DeliverUtil
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { BaseAppInstaller } from './BaseAppInstaller';
import { InstallType } from '../constants/AppInstallConstants';
import {
  LogDomain,
  LogHelper,
  CheckEmptyUtils,
  CommonUtils
} from '@ohos/basicutils/src/main/ets/TsIndex';
import { AppGalleryData } from '../data/AppGalleryData';
import { InstallUtils } from '../utils/InstallUtils';
import { CacheManager } from '../manager/CacheManager';

const TAG = 'appInstall_Clone';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const SHORTCUT_LIMIT_KEY = 'shortcutLimit';
const APP_TYPE = 'appType';

/**
 * TASKPOOL_NUM：克隆过程中能拉起的最多taskpool数量
 */
const TASKPOOL_NUM = 20;
const WAIT_INTERVAL = 200;
const sleep = (delay: number): Promise<number> => new Promise((resolve) => setTimeout(resolve, delay));

/**
 * 克隆类
 */
export class Clone extends BaseAppInstaller {
  constructor() {
    super();
    this.type = InstallType.APP_CLONE;
  }

  protected buildInsertItem(data: AppGalleryData, appList?: GridLayoutItemInfo[]): GridLayoutItemInfo {
    let item: GridLayoutItemInfo = InstallUtils.buildInsertItem(data);
    // 克隆，升级场景，存在设备包名的占位图标，根据ag传参构造oldBundleNames
    if (!CheckEmptyUtils.isEmptyArr(data.legacyInfos) && data.legacyInfos) {
      item.oldBundleNames = [data.legacyInfos[0].pkgName];
    }
    if (CheckEmptyUtils.isEmptyArr(appList) || !appList) {
      return item;
    }
    //企业应用保留apptype
    let intentMap: Map<string, Object> = CommonUtils.jsonStrToMap(item.intent);
    if (CommonUtils.jsonStrToMap(appList[0].intent).get(APP_TYPE) === AppReserveType.ENTERPRISE) {
      intentMap.set(APP_TYPE, AppReserveType.ENTERPRISE);
    }
    // 加桌上限设置 需保留
    let limitNum = CommonUtils.jsonStrToMap(appList[0].intent).get(SHORTCUT_LIMIT_KEY);
    if (limitNum) {
      intentMap.set(SHORTCUT_LIMIT_KEY, limitNum);
    }
    item.intent = JSON.stringify(CommonUtils.mapToObject(intentMap));
    return item;
  }

  protected code501(appGalleryData: AppGalleryData, bundleName: string): void {
    log.showInfo('code501 data: %{public}s', JSON.stringify(appGalleryData));
    // 加入任务列表
    appGalleryData.status = AppStatus.WAITING;
    appGalleryData.startTime = Date.now();
    this.addDownloadTaskInfo(appGalleryData);
    // 如果是多对一的场景，删除第一个之外的所有占位图标
    this.deleteOtherNotHarmonyTaskIfNeed(appGalleryData);
    this.appGallerDatas.push(appGalleryData);
    this.getAppIconLimit();
  }
 
  protected async getAppIconLimit(): Promise<void> {
    if (this.isRunning) {
      return;
    }

    while (!CheckEmptyUtils.isEmptyArr(this.appGallerDatas)) {
      this.isRunning = true;
      while (this.taskPoolNum < TASKPOOL_NUM && !CheckEmptyUtils.isEmptyArr(this.appGallerDatas)) {
        let eventData: AppGalleryData = this.appGallerDatas.shift() as AppGalleryData;
        let appList: GridLayoutItemInfo[] = this.getAppListByBundleName(eventData);
        //处理未鸿蒙化应用占位图标
        this.dealNotHarmonyTaskIfNeeded(eventData, appList);
        let item: GridLayoutItemInfo = this.buildInsertItem(eventData, appList);
        let bundleName: string = eventData.bundleName;
        this.taskPoolNum++;
        this.getAppIcon(item, bundleName);
        log.showInfo('current taskpool num for clone: %{public}d', this.taskPoolNum);
      }
      await sleep(WAIT_INTERVAL);
    }
    this.isRunning = false;
  }

  /**
   * 查询缓存中的占位图标信息
   * @param data ag传来的信息
   */
  private getAppListByBundleName(data: AppGalleryData): GridLayoutItemInfo[] {
    let appList: GridLayoutItemInfo[] = [];
    let pkgName: string | undefined = data.legacyInfos?.[0]?.pkgName;
    let bundleName = pkgName ? pkgName : data.bundleName;
    appList = LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(bundleName);
    return appList;
  }

  /**
   * 处理未鸿蒙化占位图标
   * @param data ag传来的信息
   * @param appList 缓存中占位图标信息
   */
  private dealNotHarmonyTaskIfNeeded(data: AppGalleryData, appList: GridLayoutItemInfo[]): void {
    let pkgName: string | undefined = data.legacyInfos?.[0]?.pkgName;
    if (CheckEmptyUtils.isEmpty(pkgName)) {
      return;
    }
    // 存在未鸿蒙化应用文件夹，需要删除掉应用和分身，否则需要更新包名，兼容之前用户的情况
    if (FolderLayoutCacheManager.getInstance().isAppExistNotDragOutFolder(pkgName)) {
      for (let i = 0; i < appList?.length; i++) {
        CacheManager.getInstance().removeItem(appList[i].bundleName, appList[i].appIndex);
        log.showInfo('wait for OpenHarmony app delete folder app  bundleName %{public}s, appIndex :%{public}d',
          appList[i].bundleName, appList[i].appIndex);
      }
      data.legacyInfos = [];
    } else {
      // 不存在未鸿蒙化文件夹，需要更新设备包名未设备包名，避免图标异常导致新增异常图标
      // 如未鸿蒙化应用在dock区，需单独先更新dock区缓存
      let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
      appList.forEach(item => {
        for (let i = 0; i < residentList.length; i++) {
          this.updateInDock(residentList[i], item.bundleName, item.appIndex, data);
        }
      });
      LayoutViewModel.getInstance().updateResidentDockLayout(TAG.concat('_deal'), residentList);
      let downloadInfo: DownloadInfoItem = {
        bundleName: data.bundleName,
        appStatus: AppStatus.WAITING,
        oldBundleName: pkgName,
        updateTwinApp: true
      };
      log.showInfo(`wait for OpenHarmony app update bundleName in db, oldBundleName ${pkgName}, bundleName ${data.bundleName}`);
      RdbStoreManager.getInstance().updateDownloadInfo(downloadInfo);
    }
  }

  private updateInDock(dockItem: DockItemInfo, bundleName: string, appIndex: number = 0, data: AppGalleryData): void {
    if (dockItem.typeId === CommonConstants.TYPE_FOLDER) {
      dockItem.layoutInfo?.flat().forEach(appItem => {
        if (appItem.typeId === CommonConstants.TYPE_APP &&
          appItem.bundleName === bundleName && (appItem.appIndex ?? 0) === appIndex) {
          appItem.bundleName = data.bundleName;
          appItem.keyName = data.bundleName + appItem.appIndex;
        }
      })
    } else if (dockItem.typeId === CommonConstants.TYPE_APP) {
      if (dockItem.bundleName === bundleName && (dockItem.appIndex ?? 0) === appIndex) {
        dockItem.bundleName = data.bundleName;
        dockItem.keyName = data.bundleName + dockItem.appIndex;
      }
    }
  }

  /**
   * 多对一的场景，删除第一个之外的所有占位图标
   * @param data ag传来的信息
   */
  private deleteOtherNotHarmonyTaskIfNeed(data: AppGalleryData): void {
    let legacyInfos: LegacyInfo[] | undefined = data.legacyInfos;
    if (!legacyInfos || legacyInfos.length <= 1) {
      return;
    }
    for (let i = 1; i < legacyInfos.length; i++) {
      // 避免应用市场传递多个相同的设备包名导致异常问题
      if (legacyInfos[i].pkgName === legacyInfos[0].pkgName) {
        continue;
      }
      let appList: GridLayoutItemInfo[] =
        CacheManager.getInstance().getAllSameBundleNameAppItem(legacyInfos[i].pkgName);
      appList.forEach(item => {
        CacheManager.getInstance().removeItem(item.bundleName, item.appIndex);
        log.showInfo('many to one, delete other item, bundleName %{public}s, appIndex :%{public}d',
          item.bundleName, item.appIndex);
      });
    }
  }

  protected code508(data: AppGalleryData): void {
    if (data.bundleName.startsWith(DeliverUtil.WAIT_FOR_HARMONY_PREFIX)) {
      this.deleteNotHarmonyItem(data);
      return;
    }
    log.showWarn('code508 bundleName: %{public}s', data.bundleName);
    this.deleteDownloadProgressInfo(data.bundleName);
    this.removeApp(data.bundleName);
  }

  private deleteNotHarmonyItem(data: AppGalleryData): void {
    let pkgName: string = data.bundleName;
    if (!CheckEmptyUtils.isEmptyArr(data.legacyInfos) && data.legacyInfos) {
      pkgName = data.legacyInfos[0].pkgName ?? AppInstallUtils.getInstance().getNormalBundleName(pkgName);
      log.showWarn('pkgName : %{public}s bundleName : %{public}s', pkgName, data.bundleName);
    } else {
      pkgName = AppInstallUtils.getInstance().getNormalBundleName(pkgName);
      log.showWarn('pkgName : %{public}s bundleName : %{public}s', pkgName, data.bundleName);
    }
    this.removeApp(pkgName);
  }
}