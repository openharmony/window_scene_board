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

import { EventConstants } from '../../constants/EventConstants';
import { AppGalleryDownloadManager } from '../../manager/AppGalleryDownloadManager';
import { CommonConstants, SceneType } from '../../constants/CommonConstants';
import {
  CommonUtils,
  LogDomain,
  Logger,
  FileUtils,
  CheckEmptyUtils
} from '@ohos/basicutils';
import {
  GlobalContext,
  localEventManager,
  DeviceHelper,
} from '@ohos/frameworkwrapper';
import { NumberConstants } from '@ohos/commonconstants';
import type { IExecutor } from '../IExecutor';
import type ctx from '@ohos.app.ability.common';
import { CloneCloudRequestMethod, CloneCloudServiceResponse } from '../../constants/DesktopServiceConstant';
import preferences from '@ohos.data.preferences';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { AppStatus } from '../../constants/CommonConstants';
import fileuri from '@ohos.file.fileuri';
import fs from '@ohos.file.fs';
import {
  AppInstallUtils,
  LaunchLayoutCacheManager,
  LegacyInfo
} from '../../TsIndex';
import { image } from '@kit.ImageKit';
import { RestoreLauncherDataManager } from '../../manager/RestoreLauncherDataManager';
import { launcherStatusUtil } from '@ohos/windowscene/src/main/ets/TsIndex';

const TAG: string = 'RestoreLauncherData';
const log: Logger = Logger.getLogHelper(LogDomain.BACKUP);

/**
 * 开始克隆备份任务
 *
 * @since 2023-11-13
 */
export class RestoreLauncherData implements IExecutor {
  private backUpExtraData: ExtraDataInfo[] | null = null;

  private ownerInfo: OwnerInfo | null = null;

  private restorePkgList: Array<string> = [];

  private restoreBundleList: Array<string> = [];

  private restoreTitleList: Array<string> = [];

  private restoreIconUriList: Array<string> = [];

  private restoreLegacyInfoList: Array<LegacyInfo> = [];

  private restoreIsInContainerList: Array<boolean> = [];

  private restoreAppTypeList: Array<number> = [];

  private restoreEnterpriseLinkList: Array<string> = [];

  private isWaitForHarmonyList: Array<boolean> = [];

  private waitForHarmonyKeyList: Array<string> = [];

  private restoreAppIndexList: Array<number> = [];

  private isBackUpLauncherLayout: boolean = false;

  private versionCode: string = '';

  private sceneType: number = SceneType.FROM_SCENE_BOARD;

  private defaultUri: string = '';

  private oneTimeCloneFlag: number = 0;

  private readonly filesDir: string =
    (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)?.filesDir;

  /**
   * 克隆应用调用，触发应用占位
   */
  async execute(extra?: object): Promise<string> {
    if (CheckEmptyUtils.isEmpty(extra)) {
      log.showError(TAG, 'clone transfer null info');
      return CloneCloudServiceResponse.FAIL;
    }

    let cloneInfo = extra as ExtraInfo;
    this.backUpExtraData = cloneInfo.list as ExtraDataInfo[];
    this.ownerInfo = cloneInfo.ownerInfo as OwnerInfo;
    this.versionCode = cloneInfo.versionCode ?? '';
    this.sceneType = cloneInfo.sceneType ?? SceneType.FROM_SCENE_BOARD;
    this.oneTimeCloneFlag = cloneInfo.oneTimeCloneFlag ?? 0;
    log.showWarn(TAG, 'receive restore app length: %{public}d, cloneType: %{public}d, current clone batch: %{public}d',
      this.backUpExtraData?.length, this.sceneType, this.oneTimeCloneFlag);
    FileUtils.createFolder(this.filesDir + '/RestoreIconData');
    this.defaultUri = await this.getDefaultUri();
    for (let i = 0; i < this.backUpExtraData?.length; i++) {
      let curItem = this.backUpExtraData[i];
      if (CheckEmptyUtils.checkStrIsEmpty(curItem.bundleName)) {
        log.showWarn(TAG, `the bundleName is Empty ${curItem.bundleName},${curItem.packageName},${curItem.callerName}`);
        continue;
      }
      // 克隆场景传桌面包名表示勾选布局
      if (curItem.packageName === CloneCloudRequestMethod.RESTORE_LAUNCHER_LAYOUT ||
        curItem.bundleName === CloneCloudRequestMethod.RESTORE_LAUNCHER_LAYOUT) {
        log.showInfo(TAG, `Restore launcherLayout :${curItem.bundleName}`);
        this.isBackUpLauncherLayout = true;
      } else {
        await this.getIconUri(curItem).then((iconUri) => {
          this.parseItemParam(curItem, iconUri);
        });
      }
    };
    // 未勾选布局不插入sp, 防止sp存在脏数据
    if (!this.isBackUpLauncherLayout && !DeviceHelper.isPC()) {
      this.insertIntoLayout();
    } else {
      await this.saveRestoreItem2Sp();
    }
    return CloneCloudServiceResponse.SUCCESS;
  }

  private parseItemParam(curItem: ExtraDataInfo, iconUri: string): void {
    let appType: number = curItem.appType ?? 0;
    this.restorePkgList.push(curItem.packageName ?? '');
    this.restoreBundleList.push(curItem.bundleName ?? '');
    this.isWaitForHarmonyList.push(false);
    this.waitForHarmonyKeyList.push('');
    this.restoreIsInContainerList.push(curItem.isInContainer ?? false);
    this.restoreTitleList.push(curItem.title ?? '');
    this.restoreAppIndexList.push(curItem.index ?? CommonConstants.MAIN_APP_INDEX);
    this.restoreIconUriList.push(iconUri ?? '');
    if (!CommonUtils.isEmpty(this.versionCode)) {
      this.parseLegacyInfo(curItem);
      this.restoreAppTypeList.push(appType);
      this.restoreEnterpriseLinkList.push(curItem.enterpriseLink ?? '');
    }
  }

  private parseLegacyInfo(curItem: ExtraDataInfo): void {
    if (!CommonUtils.isEmpty(curItem.legacyInfo?.pkgName)) {
      let legacyInfo: LegacyInfo = curItem.legacyInfo;
      this.restoreLegacyInfoList.push(curItem.legacyInfo);
      log.showInfo(TAG, `legacyInfo.installSource ${legacyInfo.installSource}`);
    } else {
      this.restoreLegacyInfoList.push(new LegacyInfo());
    }
  }

  private async saveRestoreItem2Sp(): Promise<void> {
    let restoreBatchNum: number = GlobalContext.getInstance().getObject('restoreBatchNum') as number;
    let needRefresh: boolean = false;
    if (this.oneTimeCloneFlag !== restoreBatchNum) {
      GlobalContext.getInstance().setObject('restoreBatchNum', this.oneTimeCloneFlag);
      needRefresh = true;
    }
    try {
      let context = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
      const preference: preferences.Preferences =
        preferences.getPreferencesSync(context, { name: CommonConstants.RESTORE_LAUNCHER_DATA });
      log.showInfo(TAG, `saveRestoreItem2Sp, isNeed restore layout: ${this.isBackUpLauncherLayout}, current caller: ` +
        `${this.ownerInfo?.bundleName}, legacyInfoList: ${JSON.stringify(this.restoreLegacyInfoList)}`);
      let pkgList: string[] = preference.getSync('RestorePkgData', []) as string[];
      let bundleList: string[] = preference.getSync('RestoreBundleData', []) as string[];
      log.showInfo(TAG, `saveRestoreItem2Sp update bundleList before length: ${bundleList.length}`);
      let iconUriList: string[] = preference.getSync('RestoreIconUriData', []) as string[];
      let titleList: string[] = preference.getSync('RestoreIconTitleData', []) as string[];
      let appIndexList: number[] = preference.getSync('RestoreAppIndexData', []) as number[];
      let isInContainerList: boolean[] = preference.getSync('RestoreIsInContainerData', []) as boolean[];
      preference.putSync('RestorePkgData', needRefresh ? this.restorePkgList : pkgList.concat(this.restorePkgList));
      preference.putSync('RestoreBundleData',
        needRefresh ? this.restoreBundleList : bundleList.concat(this.restoreBundleList));
      preference.putSync('RestoreIconUriData',
        needRefresh ? this.restoreIconUriList : iconUriList.concat(this.restoreIconUriList));
      preference.putSync('RestoreIconTitleData',
        needRefresh ? this.restoreTitleList : titleList.concat(this.restoreTitleList));
      preference.putSync('RestoreAppIndexData',
        needRefresh ? this.restoreAppIndexList : appIndexList.concat(this.restoreAppIndexList));
      preference.putSync('RestoreIsInContainerData',
        needRefresh ? this.restoreIsInContainerList : isInContainerList.concat(this.restoreIsInContainerList));
      preference.putSync('RestoreCallerName', this.ownerInfo?.bundleName);
      preference.putSync('RestoreLauncherLayout', this.isBackUpLauncherLayout);
      preference.putSync('RestoreOwnerInfo',
        [this.ownerInfo?.bundleName, this.ownerInfo?.moduleName, this.ownerInfo?.abilityName]);
      if (!CommonUtils.isEmpty(this.versionCode)) {
        let legacyInfoList: LegacyInfo[] = preference.getSync('RestoreLegacyInfoData', []) as LegacyInfo[];
        let appTypeList: number[] = preference.getSync('RestoreAppTypeData', []) as number[];
        let enterpriseLinkList: string[] = preference.getSync('RestoreEnterpriseLinkData', []) as string[];
        let oldIsWaitForHarmonyList: boolean[] = preference.getSync('RestoreIsWaitForHarmonyListData', []) as boolean[];
        let oldWaitForHarmonyKeyList: string[] = preference.getSync('RestoreWaitForHarmonyKeyListData', []) as string[];
        preference.putSync('RestoreLegacyInfoData',
          needRefresh ? this.restoreLegacyInfoList : legacyInfoList.concat(this.restoreLegacyInfoList));
        preference.putSync('RestoreAppTypeData',
          needRefresh ? this.restoreAppTypeList : appTypeList.concat(this.restoreAppTypeList));
        preference.putSync('RestoreEnterpriseLinkData',
          needRefresh ? this.restoreEnterpriseLinkList : enterpriseLinkList.concat(this.restoreEnterpriseLinkList));
        preference.putSync('RestoreIsWaitForHarmonyListData',
          needRefresh ? this.isWaitForHarmonyList : oldIsWaitForHarmonyList.concat(this.isWaitForHarmonyList));
        preference.putSync('RestoreWaitForHarmonyKeyListData',
          needRefresh ? this.waitForHarmonyKeyList : oldWaitForHarmonyKeyList.concat(this.waitForHarmonyKeyList));
      }
      preference.flushSync();
      log.showInfo(TAG, 'save restore data to sp successs');
    } catch (err) {
      log.showError(TAG, `saveRestoreItem2Sp occur err: ${err.message}`);
    }
  }

  /**
   * 高版本数据库往低版本数据库克隆的布局处理接口
   */
  public handleHighDbCloneToLowDb(): void {
    try {
      this.parseSp2RestoreItems();
      if (CheckEmptyUtils.isEmptyArr(this.restorePkgList)) {
        log.showWarn(TAG, 'the package name of the old app to be restored is empty');
        return;
      }
      log.showInfo(TAG, `start processing high-to-low process, length: ${this.restorePkgList.length}`);
      GlobalContext.getInstance().setObject('backupStatus', false);
      this.insertIntoLayout();
    } catch (err) {
      log.showError(TAG, `get restore items from SP error: ${err}`);
    }
  }

  private parseSp2RestoreItems(): void {
    try {
      let context = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
      // 清除缓存强制从本地文件读取，防止因进程未取消读到上一次克隆的缓存数据
      preferences.removePreferencesFromCacheSync(context, CommonConstants.RESTORE_LAUNCHER_DATA);
      const preference: preferences.Preferences =
        preferences.getPreferencesSync(context, { name: CommonConstants.RESTORE_LAUNCHER_DATA });
      this.restorePkgList = preference.getSync('RestorePkgData', []) as string[];
      this.restoreBundleList = preference.getSync('RestoreBundleData', []) as string[];
      this.restoreAppIndexList = preference.getSync('RestoreAppIndexData', []) as number[];
      this.isWaitForHarmonyList = preference.getSync('RestoreIsWaitForHarmonyListData', []) as boolean[];
      this.restoreLegacyInfoList = preference.getSync('RestoreLegacyInfoData', []) as LegacyInfo[];
      this.waitForHarmonyKeyList = preference.getSync('RestoreWaitForHarmonyKeyListData', []) as string[];
      this.restoreEnterpriseLinkList = preference.getSync('RestoreEnterpriseLinkData', []) as string[];
      this.restoreAppTypeList = preference.getSync('RestoreAppTypeData', []) as number[];
      this.restoreTitleList = preference.getSync('RestoreIconTitleData', []) as string[];
      this.restoreIconUriList = preference.getSync('RestoreIconUriData', []) as string[];
      let restoreOwnerInfo = preference.getSync('RestoreOwnerInfo', []) as Array<string>;
      let ownerInfo: OwnerInfo = new OwnerInfo();
      ownerInfo.bundleName = restoreOwnerInfo[0];
      ownerInfo.moduleName = restoreOwnerInfo[1];
      ownerInfo.abilityName = restoreOwnerInfo[2];
      this.ownerInfo = ownerInfo;
    } catch (err) {
      this.restorePkgList = [];
      log.showError(TAG, `parseSp2RestoreItems catch error: ${err}`);
    }
  }

  /**
   * 获取图标URI，优先级：克隆 -》双上桌面-》AG-》默认图标
   */
  private async getIconUri(item: ExtraDataInfo): Promise<string> {
    let iconUri: string = '';
    if (!CommonUtils.isEmpty(item.iconUri)) {
      iconUri = await this.getIconCopyUri(item.iconUri);
    }
    if (CommonUtils.isEmpty(iconUri)) {
      iconUri = await this.getIconAppGalleryUri(item);
    }
    if (CommonUtils.isEmpty(iconUri)) {
      // 默认的四叶草图标
      iconUri = this.defaultUri;
    }
    log.showWarn(TAG, 'backUp item = %{public}s, %{public}d, %{public}d, %{public}s, %{public}s, %{public}s',
      item.bundleName, item.index, item.appType, item.title, item.packageName, iconUri);
    return iconUri;
  }

  private async getDefaultUri(): Promise<string> {
    let pixelMap: image.PixelMap | null = null;
    try {
      let dstPath: string = this.filesDir + CommonConstants.DEFAULT_CLONE_ICON_URI;
      pixelMap = GlobalContext.getContext()?.resourceManager.getDrawableDescriptor($r('app.media.default_icon').id)
        .getPixelMap();
      await RestoreLauncherDataManager.getInstance().saveImage2Disk(dstPath, pixelMap);
      let dstUriObject = new fileuri.FileUri(dstPath);
      return dstUriObject.toString();
    } catch (err) {
      log.error('getDefaultUri error', err);
    } finally {
      pixelMap?.release();
    }
    return '';
  }

  private async getIconAppGalleryUri(item: ExtraDataInfo): Promise<string> {
    let appGalleryIcon = await AppInstallUtils.getInstance().getIconFromAppGallery([item.bundleName]);
    if (appGalleryIcon === undefined) {
      log.showInfo(TAG, 'get appIcon from appGallery failed, current use default icon');
      return '';
    }
    let appGalleryIconUri = new fileuri.FileUri(appGalleryIcon).toString();
    log.showInfo(TAG, `get appIcon from appGalllery, icon: ${appGalleryIconUri}`);
    return appGalleryIconUri;
  }

  private insertIntoLayout(): void {
    GlobalContext.getInstance().setObject('restoreBatchNum', NumberConstants.CONSTANT_NUMBER_ZERO);
    let items: GridLayoutItemInfo[] = [];
    for (let i = 0; i < this.restorePkgList.length; i++) {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = this.restoreBundleList[i];
      item.keyName = this.restoreBundleList[i] + this.restoreAppIndexList[i];
      item.appIndex = this.restoreAppIndexList[i];
      item.typeId = CommonConstants.TYPE_APP;
      // 过滤已安装应用和快捷方式
      if (this.checkIsInstalled(item)) {
        continue;
      }
      if (this.isWaitForHarmonyList[i]) {
        item.appStatus = AppStatus.WAIT_FOR_HARMONY;
      } else {
        item.appStatus = AppStatus.PENDING;
      }
      item.appName = this.restoreTitleList[i];
      log.showInfo(TAG, `Insert ${item.bundleName},${item.keyName} callName is ${this.ownerInfo?.bundleName}`);
      item.callerName = this.ownerInfo?.bundleName;
      item.iconResource = this.restoreIconUriList[i];
      item.area = [1, 1];
      item.container = CommonConstants.CONTAINER_DESKTOP;
      items.push(item);
    }
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_APPGALLERY_CREATED, items);
  }

  private getIconCopyUri(srcPath: string): string {
    let openSrc: fs.File | undefined;
    try {
      let srcUriObject = new fileuri.FileUri(srcPath);
      let dstPath: string = this.filesDir + '/RestoreIconData/' + srcUriObject.name;
      let dstUriObject = new fileuri.FileUri(dstPath);
      openSrc = fs.openSync(srcPath);
      fs.copyFileSync(openSrc.fd, dstUriObject.path);
      return dstUriObject.toString();
    } catch (err) {
      log.error('getAppIcons err :', err);
    } finally {
      if (openSrc) {
        FileUtils.closeFile(openSrc);
      }
    }
    return '';
  }

  private checkIsInstalled(item: GridLayoutItemInfo): boolean {
    let installedItems: GridLayoutItemInfo[] =
      LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(item.bundleName);
    if (CheckEmptyUtils.isEmptyArr(installedItems)) {
      return false;
    }
    for (let i = 0; i < installedItems.length; i++) {
      if (installedItems[i].appIndex === item.appIndex && installedItems[i].appStatus === AppStatus.INSTALLED) {
        log.showInfo(TAG, `the application has been installed, bundleName: ${installedItems[i].bundleName},index: ${installedItems[i].appIndex}`);
        return true;
      }
    }
    return false;
  }
}

class ExtraInfo {
  /**
   * 克隆信息列表
   */
  list: ExtraDataInfo[] = [];

  /**
   * 任务拥有者信息
   */
  ownerInfo: OwnerInfo = new OwnerInfo();

  /**
   * 版本信息（便于新老接口兼容）
   */
  versionCode?: string;

  /**
   * 克隆类型
   */
  sceneType?: number;

  /**
   * 克隆批次号,单次克隆唯一
   */
  oneTimeCloneFlag?: number;
}

/**
 * 备份数据格式
 *
 * @since 2023-10-08
 */
export class ExtraDataInfo {
  callerName: string = '';

  callerType: number = 0;

  /**
   * OpenHarmony应用包名（未OpenHarmony化应用不能填）
   */
  bundleName: string = '';

  /**
   * 桌面上显示的应用包名（保留设计，防止云备份与桌面版本节奏不匹配）
   */
  packageName: string = '';

  /**
   * 应用显示名称
   */
  title: string = '';

  /**
   * 应用图标uri
   */
  iconUri: string = '';

  /**
   * 应用类型：0：非企业应用  1：企业应用   2：尝鲜应用 支持后续类型扩展（若无值，则默认0）
   */
  appType: number = 0;

  /**
   * 企业应用对应的跳转链接，若桌面识别不为空，则点击图标优先跳转对应链接
   */
  enterpriseLink: string = '';

  /**
   * 未OpenHarmony化应用相关信息
   */
  legacyInfo: LegacyInfo = new LegacyInfo();

  /**
   * 分身应用index
   */
  index: number = 0;

  /**
   * 区分内置应用，true为内置应用
   */
  isInContainer: boolean = false;
}

/**
 * 备份数据格式
 *
 * @since 2023-10-08
 */
export class OwnerInfo {
  /**
   * 任务拥有者包名
   */
  bundleName: string = '';

  /**
   * 任务拥有者模块名
   */
  moduleName: string = '';

  /**
   * 任务拥有者对应ability名称
   */
  abilityName: string = '';
}

export interface IExtendInfo {
  targetModuleUrl: string;
  appType: number;
  maskState?: number
}