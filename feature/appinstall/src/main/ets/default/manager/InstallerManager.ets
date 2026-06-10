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

import { BaseAppInstaller } from '../installer/BaseAppInstaller';
import { AppNewInstaller } from '../installer/AppNewInstaller';
import { AppInstallConstants, InstallType } from '../constants/AppInstallConstants';
import { AppGalleryData, } from '../data/AppGalleryData';
import { InstallDataManager } from './InstallDataManager';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  CommonConstants,
  GridLayoutItemInfo,
  launcherAbilityManager,
  AppInstallUtils
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { CacheManager } from './CacheManager';
import { HashMap } from '@kit.ArkTS';

const TAG = 'appInstall_InstallerManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 下载管理类
 */
export class InstallerManager {
  private static mInstance: InstallerManager;
  private defaultAppInstaller: BaseAppInstaller = new AppNewInstaller();
  private installerMap: HashMap<InstallType, BaseAppInstaller> = new HashMap<InstallType, BaseAppInstaller>();

  public static getInstance(): InstallerManager {
    if (!InstallerManager.mInstance) {
      InstallerManager.mInstance = new InstallerManager();
    }
    return InstallerManager.mInstance;
  }

  /**
   * 添加安装器
   * @param installer
   */
  public addInstaller(installer: BaseAppInstaller): void {
    if (!installer) {
      return;
    }
    this.installerMap.set(installer.getInstallType(), installer);
  }

  /**
   * 获取具体的安装器
   * @param appGalleryData
   * @param bundleName
   * @returns
   */
  private getInstaller(appGalleryData: AppGalleryData, bundleName: string): InstallType {
    // updateStatus=0表示应用第一次安装，updateStatus=1表示应用更新
    let updateStatus: number = appGalleryData.updateStatus ?? CommonConstants.INVALID_VALUE;
    // distributeType=internaltesting或者enterprise表示企业应用，其它的是普通应用
    let distributeType: string = appGalleryData.distributeType ?? '';
    // 判断更新场景
    if (updateStatus === 1) {
      return this.getUpdater(distributeType);
    }

    // 判断是否是首次安装
    if (updateStatus === 0) {
      if (this.isCloneInstaller(appGalleryData, bundleName)) {
        return InstallType.APP_CLONE;
      }
      return this.isEnterpriseApp(distributeType) ? InstallType.ENTERPRISE_INSTALLER : InstallType.NEW_INSTALLER;
    }

    // 如果应用市场没有发送updateStatus，根据根据该应用能否从BMS中查询到判断
    let apps = launcherAbilityManager.getLauncherAbilityInfoByBundleName(bundleName);
    log.showWarn('findInstaller updateStatus:%{public}d, distributeType:%{public}s, findApp:%{public}s.',
      updateStatus, distributeType, JSON.stringify(apps));

    // 如果在BMS中找到了该应用说明是更新
    if (apps.length === 0) {
      if (this.isCloneInstaller(appGalleryData, bundleName)) {
        return InstallType.APP_CLONE;
      }
      return InstallType.NEW_INSTALLER;
    }
    return this.getUpdater(distributeType);
  }

  /**
   * 查询是否使用克隆安装器
   * @param appGalleryData
   * @param bundleName
   * @param boolean 是否使用克隆安装器
   * @returns
   */
  private isCloneInstaller(appGalleryData: AppGalleryData, bundleName: string): boolean {
    // ag发送的信息带有未OpenHarmony信息，直接使用clone的安装器
    if (!CheckEmptyUtils.isEmptyArr(appGalleryData.legacyInfos) &&
    appGalleryData.legacyInfos && appGalleryData.legacyInfos[0].pkgName) {
      log.showWarn(`findInstaller pkgName: ${appGalleryData.legacyInfos[0].pkgName}`);
      return true;
    }
    // 判断克隆场景， 克隆场景缓存中有callerName
    let appList: GridLayoutItemInfo[] = CacheManager.getInstance().getAllSameBundleNameAppItem(bundleName);
    if (!CheckEmptyUtils.isEmptyArr(appList) && appList[0].callerName) {
      log.showWarn(`findInstaller callerName: ${appList[0].callerName}`);
      return true;
    }
    return false;
  }

  /**
   * 查找Installer
   * @param appGalleryData
   * @param bundleName
   * @param is501Find 是否是501查找的
   * @returns
   */
  public findInstaller(appGalleryData: AppGalleryData, bundleName: string,
    is501Find: boolean = true): BaseAppInstaller {
    let installName = this.getInstaller(appGalleryData, bundleName);
    let installer: BaseAppInstaller | undefined = this.installerMap.get(installName);
    if (!installer) {
      installer = this.defaultAppInstaller;
    }
    InstallDataManager.getInstance().addTask(bundleName, installer);
    log.showWarn('findInstaller[%{public}d] is501Find:%{public}s', installer.getInstallType(), is501Find);
    return installer;
  }

  private getUpdater(distributeType: string): InstallType {
    return this.isEnterpriseApp(distributeType) ? InstallType.ENTERPRISE_UPDATER : InstallType.UPDATER;
  }

  private isEnterpriseApp(distributeType: string): boolean {
    return distributeType === AppInstallConstants.TYPE_ENTERPRISE ||
      distributeType === AppInstallConstants.TYPE_INTERNALTESTING;
  }
}