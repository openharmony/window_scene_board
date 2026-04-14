/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import { UpdateType } from '@ohos/commonconstants';
import { BaseAppInstaller } from '../installer/BaseAppInstaller';
import { AppNewInstaller } from '../installer/AppNewInstaller';
import { AppUpdater } from '../installer/AppUpdater';
import { EnterpriseAppNewInstaller } from '../installer/EnterpriseAppNewInstaller';
import { EnterpriseAppUpdater } from '../installer/EnterpriseAppUpdater';
import { InstallerManager } from '../manager/InstallerManager';
import { AppGalleryEventStatus } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { AppDownloadInfo, AppGalleryData } from '../data/AppGalleryData';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { preferences } from '@kit.ArkData';
import {
  CommonEvent,
  DownloadingProgressChangeEvent,
  DownloadStatusChangeEvent,
  EvtBus,
  IconResourceManager,
  InstallStatusChangeEvent,
  ShutDownEvent,
  PackageDataClearedEvent,
  GlobalContext
} from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { BundleMappingChangeEvent } from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/CommonEvents';
import { InstallDataManager } from '../manager/InstallDataManager';
import { CacheManager } from '../manager/CacheManager';
import { AccountChangeListener } from './AccountChangeListener';
import {
  CommonConstants,
  NotHarmonyUtil,
  RdbStoreManager
} from '@ohos/launchercommon';
import { Clone } from '../installer/Clone';

const TAG = 'appInstall_AppGalleryListener';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const APPGALLERY_BUNDLENAME = 'com.ohos.appgallery';

/**
 * 应用市场事件监听类
 */
export class AppGalleryListener {
  private static mInstance: AppGalleryListener;
  private installerManager: InstallerManager = InstallerManager.getInstance();

  private dealWithDownloadStatusChangeEvent = (event: CommonEvent) => {
    let installer: BaseAppInstaller | undefined = this.getInstaller(event);
    if (installer) {
      installer.dealWithDownloadStatusChange(event);
    } else {
      log.showError('dealWithDownloadStatusChange can not find installer event: %{public}s', JSON.stringify(event));
    }
  };

  private dealWithDownloadProgressChangeEvent = (event: CommonEvent) => {
    let userId: number = AccountChangeListener.getInstance().getUserId();
    log.showDebug('dealWithDownloadProgressChangeEvent userId:' + userId);
    let installer: BaseAppInstaller | undefined = this.getInstaller(event);
    if (installer) {
      let eventData = event?.parameters as AppDownloadInfo;
      installer.dealWithDownloadProgressChange(eventData);
    } else {
      log.showError('dealWithDownloadProgressChange can not find installer event: %{public}s', JSON.stringify(event));
    }
  }

  private dealWithInstallStatusChangeEvent = (event: CommonEvent) => {
    this.dealClearIconCache(event);
    let installer: BaseAppInstaller | undefined = this.getInstaller(event);
    if (installer) {
      installer.dealWithInstallStatusChange(event);
    } else {
      log.showError('dealWithInstallStatusChange can not find installer event: %{public}s', JSON.stringify(event));
    }
  }

  private changeAllCacheAppToPause = () => {
    CacheManager.getInstance().changeAllCacheAppToPause();
  }

  private dealWithPackageDataClearedEvent = (event: CommonEvent) => {
    if (event.bundleName !== APPGALLERY_BUNDLENAME) {
      return;
    }
    this.removeAllNotInstalledApp();
  }

  private dealWithBundleMappingChangeEvent = (event: CommonEvent) => {
    this.handleBundleMappingEventChange(event);
  }

  public static getInstance(): AppGalleryListener {
    if (!AppGalleryListener.mInstance) {
      AppGalleryListener.mInstance = new AppGalleryListener();
    }
    return AppGalleryListener.mInstance;
  }

  private constructor() {
  }

  private dealClearIconCache(event: CommonEvent): void {
    let actionBundleName: string | undefined = event.parameters?.bundleName;
    // 无图标应用更新安装完成时，清理图标缓存，通知systemui重新获取图标
    if (this.isOnlyClearIconCache(actionBundleName, event.code ?? 0)) {
      this.clearIconCache(actionBundleName);
    }
  }

  private async clearIconCache(bundleName: string | undefined): Promise<void> {
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      log.showWarn(`bundleName is empty`);
      return;
    }
    await IconResourceManager.getInstance().deleteIconResource(bundleName, UpdateType.UPDATE);
  }

  private isOnlyClearIconCache(bundleName: string | undefined, code: number): boolean {
    return (bundleName === undefined || bundleName === null) && code === AppGalleryEventStatus.INSTALL_SUCCEED_EVENT_ID;
  }

  /**
   * 初始化该类
   */
  public init(): void {
    this.initAppGalleryEvent();
    this.initInstaller();
  }

  /**
   * 类销毁是需要off以下事件
   */
  public destroy(): void {
    EvtBus.off(DownloadStatusChangeEvent, this.dealWithDownloadStatusChangeEvent);
    EvtBus.off(DownloadingProgressChangeEvent, this.dealWithDownloadProgressChangeEvent);
    EvtBus.off(InstallStatusChangeEvent, this.dealWithInstallStatusChangeEvent);
    EvtBus.off(ShutDownEvent, this.changeAllCacheAppToPause);
    EvtBus.off(PackageDataClearedEvent, this.dealWithPackageDataClearedEvent);
    EvtBus.off(BundleMappingChangeEvent, this.dealWithBundleMappingChangeEvent);
  }

  /**
   * 监听如下事件
   */
  private initAppGalleryEvent(): void {
    EvtBus.on(DownloadStatusChangeEvent, this.dealWithDownloadStatusChangeEvent);
    EvtBus.on(DownloadingProgressChangeEvent, this.dealWithDownloadProgressChangeEvent);
    EvtBus.on(InstallStatusChangeEvent, this.dealWithInstallStatusChangeEvent);
    EvtBus.on(ShutDownEvent, this.changeAllCacheAppToPause);
    EvtBus.on(PackageDataClearedEvent, this.dealWithPackageDataClearedEvent);
    EvtBus.on(BundleMappingChangeEvent, this.dealWithBundleMappingChangeEvent);
  }

  /**
   * 添加可用的Installer
   */
  private initInstaller(): void {
    this.installerManager.addInstaller(new AppNewInstaller());
    this.installerManager.addInstaller(new AppUpdater());
    this.installerManager.addInstaller(new EnterpriseAppNewInstaller());
    this.installerManager.addInstaller(new EnterpriseAppUpdater());
    this.installerManager.addInstaller(new Clone());
  }

  private getInstaller(event: CommonEvent): BaseAppInstaller | undefined {
    if (!event || !event.parameters) {
      log.showWarn('getInstaller event is undefined! data: %{public}s', JSON.stringify(event));
      return undefined;
    }
    let eventData = event.parameters as AppGalleryData;
    let bundleName: string = eventData.bundleName;
    if (!bundleName) {
      log.showWarn('getInstaller invalid bundleName %{public}s', JSON.stringify(event));
      return undefined;
    }
    // 501新建任务
    if (event.code === AppGalleryEventStatus.DOWNLOAD_CREATE_EVENT_ID) {
      return this.installerManager.findInstaller(eventData, bundleName);
    }
    // 非501事件从缓存中查找installer
    let installer: BaseAppInstaller | undefined = InstallDataManager.getInstance().getTask(bundleName);
    // 如果找不到Installer
    if (!installer) {
      installer = this.installerManager.findInstaller(eventData, bundleName, false);
    }
    return installer;
  }

  private handleBundleMappingEventChange(event: CommonEvent): void {
    log.showInfo('handleBundleMappingEventChange start');
    if (!event.parameters) {
      log.showInfo('handleBundleMappingEventChange end, event parameters are null');
      return;
    }
    // 根据应用市场通知去点亮或熄灭占位的未OpenHarmony化应用
    let hasohosApp: string[] | undefined = Reflect.get(event.parameters, 'ag.params.HARMONY_PKGS_ADDED');
    let notohosApp: string[] | undefined = Reflect.get(event.parameters, 'ag.params.HARMONY_PKGS_REMOVED');
    let publicTestohosApp: string[] | undefined = Reflect.get(event.parameters, 'ag.params.PUBLIC_TEST_APP_PKGS_ADDED');
    // 普通三方应用的点亮熄灭映射关系
    let relationMap: Map<string, boolean> = new Map();
    // 尝鲜应用的点亮熄灭映射关系
    let publicTestRelationMap: Map<string, boolean> = new Map();
    if (hasohosApp && hasohosApp.length > 0) {
      hasohosApp.forEach(item => {
        log.showInfo(`BundleMappingEventChange hasohosApp: ${item}`);
        relationMap.set(item, true);
      });
    }
    if (publicTestohosApp && publicTestohosApp.length > 0) {
      publicTestohosApp.forEach(item => {
        log.showInfo(`BundleMappingEventChange publicTestohosApp: ${item}`);
        publicTestRelationMap.set(item, true);
      });
    }
    this.dealNotohosApp(notohosApp, relationMap, publicTestRelationMap);
    // 兼容老版本未OpenHarmony化应用平铺在桌面的场景
    NotHarmonyUtil.lightingNotHarmonyAppIcons(relationMap, publicTestRelationMap);
    // 刷新未OpenHarmony化应用文件夹中的应用排序状态
    if (notohosApp !== undefined && !CheckEmptyUtils.isEmptyArr(notohosApp)) {
      for (let i = 0; i < notohosApp.length; i++) {
        relationMap.delete(notohosApp[i]);
        publicTestRelationMap.delete(notohosApp[i]);
      }
    }
    NotHarmonyUtil.refreshNotHarmonyFolderPosition(relationMap, publicTestRelationMap);
    log.showInfo('handleBundleMappingEventChange end');
  }

  private dealNotohosApp(notohosApp: string[] | undefined, relationMap: Map<string, boolean>,
    publicTestRelationMap: Map<string, boolean>): void {
    if (CheckEmptyUtils.isEmptyArr(notohosApp)) {
      log.showInfo('BundleMappingEventChange dealNotohosApp is empty');
      return;
    }
    try {
      // delivery点亮的 忽略掉AG的熄灭事件
      let preference = preferences.getPreferencesSync(GlobalContext.getContext(), { name: 'DESKTOP_LAYOUT_INFO' });
      let lightDeliverBundleNames: string = preference.getSync('lightDeliverBundleNames', '') as string;
      let lightArr: string[] = lightDeliverBundleNames.split(',');
      notohosApp?.forEach(item => {
        if (lightArr.indexOf(item) !== CommonConstants.INVALID_VALUE) {
          return;
        }
        log.showInfo(`BundleMappingEventChange notohosApp: ${item}`);
        relationMap.set(item, false);
        publicTestRelationMap.set(item, false);
      });
    } catch (error) {
      log.showInfo('set  notohosApp error: ${public}s', error?.message);
    }
  }

  private async removeAllNotInstalledApp(): Promise<void> {
    let notInstalledApplicationList: string[] = await RdbStoreManager.getInstance().queryNotInstalledApplication();
    notInstalledApplicationList.forEach(bundleName => {
      log.showInfo('delete not installed app: %{public}s', bundleName);
      CacheManager.getInstance().removeItem(bundleName);
    });
  }
}