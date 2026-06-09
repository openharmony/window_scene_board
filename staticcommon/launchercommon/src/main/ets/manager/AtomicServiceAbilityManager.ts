/**
 * Copyright (c) 2023-Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import bundleManager from '@ohos.bundle.bundleManager';
import { AppItemInfo } from '../bean/AppItemInfo';
import { CommonConstants } from '../constants/CommonConstants';
import {
  ResourceManager,
  commonBundleManager,
  IconResourceManager
} from '@ohos/frameworkwrapper';
import { AppTypeUtils } from '@ohos/componenthelper';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'AtomicServiceAbilityManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 原服务管理
 */
class AtomicServiceAbilityManager {
  private readonly mAtomicServiceAppMap = new Map<string, AppItemInfo>();
  private readonly mAppTypeUtils: AppTypeUtils = AppTypeUtils.getInstance();
  private static mInstance: AtomicServiceAbilityManager;

  /**
   * 获取桌面应用信息管理对象
   *
   * @return 桌面应用信息管理对象单一实例
   */
  static getInstance(): AtomicServiceAbilityManager {
    if (AtomicServiceAbilityManager.mInstance == null) {
      AtomicServiceAbilityManager.mInstance = new AtomicServiceAbilityManager();
      globalThis.AtomicServiceAbilityManagerInstance = AtomicServiceAbilityManager.mInstance;
    }
    log.showDebug('getInstance!');
    return AtomicServiceAbilityManager.mInstance;
  }

  private constructor() {
  }

  /**
   * 获取userId.
   */
  getUserId(): number {
    return commonBundleManager.getUserId();
  }

  /**
   * 从包管理获取所有的原服务应用信息
   *
   * @returns 所有的原服务应用信息
   */
  async getAtomicServiceAbilityList(): Promise<AppItemInfo[]> {
    let abilityList: Array<bundleManager.BundleInfo> = await commonBundleManager.getAllBundleList(bundleManager.BundleType.ATOMIC_SERVICE);
    log.showInfo(`getAtomicServiceAbilityList abilityList length: ${abilityList.length}`);
    let appItemInfoList: AppItemInfo[] = [];
    if (CheckEmptyUtils.isEmptyArr(abilityList)) {
      return appItemInfoList;
    }
    for (let i = 0; i < abilityList.length; i++) {
      if (!CheckEmptyUtils.isEmpty(abilityList[i])) {
        let atomicServerAppItemInfoList:AppItemInfo[] = await this.getAtomicServerAPPItemInfoList(abilityList[i]);
        if (atomicServerAppItemInfoList.length) {
          appItemInfoList.push(atomicServerAppItemInfoList[0]);
        }
      }
    }
    return appItemInfoList;
  }

  /**
   * 从包管理获取应用信息
   *
   * @param bundleName 包名
   * @returns 应用信息
   */
  async getAtomicServiceAbilityInfoAsync(bundleName: string): Promise<AppItemInfo[]> {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      log.showError('getAtomicServiceAbilityInfoAsync reqParam bundleName is empty');
      return [];
    }
    let bundleInfo: bundleManager.BundleInfo | undefined =
      await commonBundleManager.getBundleInfoByBundleName(bundleName, bundleManager.BundleType.ATOMIC_SERVICE);
    if (!bundleInfo) {
      log.showInfo(`getAtomicServiceAbilityInfoAsync by bundleName:${bundleName} no result from MGR`);
      return [];
    }
    return this.getAtomicServerAPPItemInfoList(bundleInfo);
  }

  async getAtomicServerAPPItemInfoList(bundleInfo: bundleManager.BundleInfo): Promise<AppItemInfo[]> {
    let appItemInfoList :AppItemInfo[] = [];
    if (CheckEmptyUtils.isEmptyArr(bundleInfo.hapModulesInfo)) {
      return appItemInfoList;
    }
    for (let i = 0; i < bundleInfo.hapModulesInfo.length; i++) {
      if (CheckEmptyUtils.isEmptyArr(bundleInfo.hapModulesInfo[i].abilitiesInfo)) {
        continue;
      }
      for (let j = 0; j < bundleInfo.hapModulesInfo[i].abilitiesInfo.length; j++) {
        let appItem: AppItemInfo | undefined = await this.convertAtomicServiceToAppItemInfo(
          bundleInfo.hapModulesInfo[i].abilitiesInfo[j], bundleInfo.appInfo);
        if (appItem) {
          appItemInfoList.push(appItem);
        }
      }
    }
    return appItemInfoList;
  }

  /**
   * 从缓存中获取或包管理获取原服务ability信息
   *
   * @param bundleName 包名
   * @returns 一个ability信息
   */
  async getAnAtomicServiceAbilityInfoFromCache(bundleName: string): Promise<AppItemInfo | undefined> {
    let appItemInfo: AppItemInfo | undefined = undefined;
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      log.showError('getAnAtomicServiceAbilityInfoFromCache reqParam bundleName is empty');
      return appItemInfo;
    }
    // get from cache
    if (this.mAtomicServiceAppMap != null && this.mAtomicServiceAppMap.has(bundleName)) {
      appItemInfo = this.mAtomicServiceAppMap.get(bundleName);
    }
    if (appItemInfo) {
      log.showInfo('getAnAtomicServiceAbilityInfoFromCache cache result, appIconId: %{private}d', appItemInfo.appLabelId);
      return appItemInfo;
    }
    // get from mgr
    let abilityList: AppItemInfo[] = await this.getAtomicServiceAbilityInfoAsync(bundleName);
    if (CheckEmptyUtils.isEmptyArr(abilityList)) {
      log.showInfo(`${bundleName} has no atomic ability`);
      return undefined;
    }
    log.showInfo('getAnAtomicServiceAbilityInfoFromCache from MGR, appIconId: %{private}d', abilityList[0].appIconId);
    return abilityList[0];
  }

  private async convertAtomicServiceToAppItemInfo(info: bundleManager.AbilityInfo,
    applicationInfo?: bundleManager.ApplicationInfo): Promise<AppItemInfo | undefined> {
    if (CheckEmptyUtils.isEmpty(info)) {
      log.showError('convertAtomicServiceToAppItemInfo reqParam is empty');
      return undefined;
    }
    let appInfo: bundleManager.ApplicationInfo = info.applicationInfo;
    if (CheckEmptyUtils.isEmpty(appInfo) && applicationInfo) {
      appInfo = applicationInfo;
    }
    if (CheckEmptyUtils.isEmpty(appInfo)) {
      log.showError('convertAtomicServiceToAppItemInfo applicationInfo is empty');
      return undefined;
    }
    const appItemInfo = new AppItemInfo();
    appItemInfo.appName = await IconResourceManager.getInstance().getAppName(
      appInfo.labelResource.id, info.bundleName, appInfo.labelResource.moduleName, appInfo.label
    );
    if (info.applicationInfo) {
      appItemInfo.applicationName = await IconResourceManager.getInstance().getAppName(
        info.applicationInfo.labelResource?.id, info.bundleName,
        info.applicationInfo.labelResource?.moduleName, info.applicationInfo.label
      );
    } else {
      appItemInfo.applicationName = await IconResourceManager.getInstance().getAppName(
        appInfo.labelResource?.id, appInfo.labelResource?.bundleName,
        appInfo.labelResource?.moduleName, appInfo.label
      );
    }
    appItemInfo.isSystemApp = appInfo.systemApp;
    appItemInfo.isUninstallAble = appInfo.removable;
    appItemInfo.appIconId = appInfo.iconResource.id;
    appItemInfo.applicationIconId = appInfo.iconId;
    appItemInfo.appLabelId = appInfo.labelResource.id;
    appItemInfo.applicationLabelId = info.applicationInfo ? info.applicationInfo.labelResource?.id :
      appInfo.labelResource?.id;
    appItemInfo.bundleName = info.bundleName;
    appItemInfo.kindId = this.mAppTypeUtils.queryAppTypeByPackage(info.bundleName);
    appItemInfo.abilityName = info.name;
    appItemInfo.moduleName = appInfo.labelResource.moduleName;
    appItemInfo.areaType = CommonConstants.TYPE_AREA_APP_CENTER;
    appItemInfo.bundleType = bundleManager.BundleType.ATOMIC_SERVICE;
    appItemInfo.keyName = AppItemInfo.getKeyName(appItemInfo);
    IconResourceManager.getInstance().deleteIconResource(appItemInfo.bundleName);
    await ResourceManager.getInstance().updateIconCache(appItemInfo.applicationLabelId, appItemInfo.bundleName,
      appItemInfo.moduleName);
    this.mAtomicServiceAppMap.set(appItemInfo.bundleName, appItemInfo);
    log.showInfo('convertAtomicServiceToAppItemInfo appItemInfo, appName: %{public}s moduleName: %{public}s',
      appItemInfo.appName, appItemInfo.moduleName);
    return appItemInfo;
  }

  cleanAppMapCache(): void {
    this.mAtomicServiceAppMap.clear();
  }
}

const atomicServiceAbilityManager = AtomicServiceAbilityManager.getInstance();
export default atomicServiceAbilityManager;