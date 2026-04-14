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

import { CheckEmptyUtils, CommonUtils, LogDomain, Logger } from '@ohos/basicutils/src/main/ets/TsIndex';
import { desktopUtil, ObjectCopyUtil } from '@ohos/componenthelper/src/main/ets/TsIndex';
import {
  DownloadingProgressChangeEvent,
  DownloadStatusChangeEvent,
  GlobalContext,
  InstallStatusChangeEvent
} from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { AppInstallEventType } from '@ohos/launchercommon/src/main/ets/appinstall/AppInstallEventKey';
import {
  AppGalleryEventInfo,
  AppStatus,
  CommonConstants,
  ContractedFolderLayoutViewModel,
  ContractedFolderViewModelManager,
  ContractedFolderViewModelType,
  FolderActionLifeCycleEvent,
  FolderActionLifeCycleEventManager,
  FolderActionLifeCycleStatus,
  FolderCommonConstants,
  FolderCommonUtil,
  FolderDataListener,
  FolderLifeCyclePriority,
  FolderManager,
  GridLayoutItemInfo,
  GridLayoutUtil,
  IContractedFolderDownloadViewModel,
  NotHarmonyUtil,
  OBSERVER_SWITCH
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import ServiceExtensionContext from 'application/ServiceExtensionContext';

const TAG: string = 'DownloadViewModel';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
// 下载进度默认值为0，正在下载状态0表示开始下载，已经安装完成恢复默认值0
const PROGRESS_START: number = 0;
// 下载完成后的进度值为1
const PROGRESS_END: number = 1;

/**
 * 文件夹下载业务处理
 */
export class DownloadViewModel implements IContractedFolderDownloadViewModel {
  private static instance: DownloadViewModel;

  private mFolderMgr: FolderManager = FolderManager.getInstance();

  private mLayoutVm: ContractedFolderLayoutViewModel = ContractedFolderLayoutViewModel.getInstance();

  private mActionEventMgr: FolderActionLifeCycleEventManager = FolderActionLifeCycleEventManager.getInstance();

  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();

  private mDownloadDataMap: Map<string, FolderDownloadData> = new Map<string, FolderDownloadData>();

  private progressUpdateCallMap: Map<string, (curSize: number, totalSize: number, isNewProgress?: boolean,
    isReset?: boolean) => void> = new Map();

  private mDownloadCallback: FolderActionLifeCycleEvent = {
    description: TAG,
    priority: FolderLifeCyclePriority.NORMAL,
    onInstalledFolder: (folder: GridLayoutItemInfo) => {
      if (!folder.folderId || folder.folderId === FolderCommonConstants.INVALID_FOLDER_ID) {
        return;
      }
      let downloadData: FolderDownloadData = this.getFolderDownloadData(folder.folderId);
      this.changeDownloadProgress(folder.folderId, 0, downloadData);
      downloadData.changeAlreadyDownloadSize(-CommonConstants.MAX_DOWNLOAD_VALUE);
      downloadData.changeTotalDownloadSize(-CommonConstants.MAX_DOWNLOAD_VALUE);
      // 直径扩展动效做完后，isProgressShow可以设置false了
      this.mLayoutVm.getViewOsrMgr(folder.folderId).switchStatus('install-show', OBSERVER_SWITCH.PROGRESS_SHOW, false);
      setTimeout(() => {
        this.onInstallAniFinish(downloadData.getDownloadFinishBundle());
        downloadData.setDownloadFinishBundle('');
      }, 1000);
    }
  };

  private mDataCallback: FolderDataListener = {
    description: TAG,
    priority: FolderLifeCyclePriority.NORMAL,
    addToFolder: (folderId: string, addItems: GridLayoutItemInfo[]) => {
      if (!this.mFolderMgr.getFolder(folderId).isSmall()) {
        return;
      }
      let isNeedUpdate: boolean = addItems.some(item => this.isNeedCalculateProgress(item));
      if (isNeedUpdate) {
        this.updateDownloadList('add app to folder', folderId);
      }
    },
    updateFolder: (folderId: string, updateItems: GridLayoutItemInfo[]) => {
      if (this.mFolderMgr.getFolder(folderId).isSmall()) {
        this.updateDownloadList('update folder', folderId);
      }
    },
    updateOpenFolder: (updateFolder: GridLayoutItemInfo) => {
      if (FolderCommonUtil.isLayout1X1(updateFolder.area)) {
        this.updateDownloadList('update open folder', updateFolder.folderId as string);
      }
    },
    createFolder: (folder: GridLayoutItemInfo) => {
      if (FolderCommonUtil.isLayout1X1(folder.area)) {
        this.mDownloadDataMap.set(folder.folderId as string, new FolderDownloadData());
      }
    },
    removeFolder: (folder: GridLayoutItemInfo) => {
      log.showInfo(TAG, 'unregister download data for folder %{public}s', folder.folderId);
      folder.layoutInfo?.flat().forEach(item => this.unregisterEventhubEvent(item));
      this.mDownloadDataMap.delete(folder.folderId as string);
      this.progressUpdateCallMap.delete(folder.folderId as string);
    },
    updateFolderItems: (folderId: string, modifiedItems: GridLayoutItemInfo[]) => {
      if (this.mFolderMgr.getFolder(folderId).isSmall()) {
        this.updateDownloadList('update app status in folder', folderId);
      }
    }
  };

  private constructor() {
    FolderActionLifeCycleEventManager.getInstance().register(this.mDownloadCallback);
    this.mFolderMgr.registerDataLifeListener(this.mDataCallback);
  }

  public static getInstance(): DownloadViewModel {
    if (!DownloadViewModel.instance) {
      DownloadViewModel.instance = new DownloadViewModel();
      ContractedFolderViewModelManager.getInstance()
        .register(ContractedFolderViewModelType.DOWNLOAD, DownloadViewModel.instance);
    }
    return DownloadViewModel.instance;
  }

  private getFolderDownloadData(folderId: string): FolderDownloadData {
    let data: FolderDownloadData | undefined = this.mDownloadDataMap.get(folderId);
    if (data === undefined) {
      data = new FolderDownloadData();
      this.mDownloadDataMap.set(folderId, data);
    }
    return data;
  }

  public unregisterEvents(folderId: string, callback?: (curSize: number, totalSize: number,
    isNewProgress?: boolean, isReset?: boolean) => void): void {
    let folder: GridLayoutItemInfo = this.mFolderMgr.getFolder(folderId).getGridInfo();
    let notInstallList: GridLayoutItemInfo[] =
      this.getNewAppNotInstallList(folderId, folder.layoutInfo?.flat() ?? []);
    notInstallList.forEach(item => this.unregisterEventhubEvent(item));
    this.desktopContext?.eventHub.off(this.getAppUpdateEventName(folderId));
    if (callback) {
      const lastCallback = this.progressUpdateCallMap.get(folderId);
      if (lastCallback === callback) {
        this.progressUpdateCallMap.delete(folderId);
      }
    }
  }

  /**
   * 设置下载进度更新回调
   *
   * @param msg DFX日志打印
   * @param folderId 文件夹id
   * @param callback 回调
   */
  public initDownloadState(msg: string, folderId: string, callBack: (curSize: number, totalSize: number,
    isNewProgress?: boolean, isReset?: boolean) => void): void {
    this.progressUpdateCallMap.set(folderId, callBack);
    this.updateDownloadList(msg, folderId);
    this.initAppUpdateEvent(msg, folderId);
  }

  private initAppUpdateEvent(msg: string, folderId: string): void {
    let appUpdateEventName: string = this.getAppUpdateEventName(folderId);
    log.showInfo(TAG, 'appInstall onAppUpdateEvent appUpdateEventName:%{public}s', appUpdateEventName);
    this.desktopContext?.eventHub.off(appUpdateEventName);
    this.desktopContext?.eventHub.on(appUpdateEventName, () => this.appUpdateEvent(msg, folderId));
  }

  private getAppUpdateEventName(folderId: string): string {
    return `appGalleryStatusChange${folderId}${CommonConstants.MAIN_APP_INDEX}${AppInstallEventType.UPDATE_FOLDER}`;
  }

  private appUpdateEvent(msg: string, folderId: string): void {
    let folderDownloadData: FolderDownloadData | undefined = this.mDownloadDataMap.get(folderId);
    if (folderDownloadData && folderDownloadData.getNotInstallApps().length === 0) {
      this.updateDownloadList(msg, folderId);
    }
  }

  /**
   * 更新文件夹下载的应用列表
   *
   * @param msg 用于DFX的日志打印
   * @param folderId 文件夹id
   */
  public updateDownloadList(msg: string, folderId: string): void {
    log.showInfo(TAG, 'update download status: %{public}s for folder %{public}s', msg, folderId);
    let folder: GridLayoutItemInfo = this.mFolderMgr.getFolder(folderId).getGridInfo();
    if (!FolderCommonUtil.isLayout1X1(folder.area)) {
      return;
    }
    // 重置文件夹已下载应用数量
    let downloadData: FolderDownloadData = this.getFolderDownloadData(folderId);
    downloadData.resetDownloadSize();
    /* 更新未安装应用的列表 */
    let notInstallList: GridLayoutItemInfo[] =
      this.getNewAppNotInstallList(folderId, folder.layoutInfo?.flat() ?? []);
    if (CheckEmptyUtils.isEmpty(notInstallList)) {
      log.showWarn(TAG, 'the folder not has uninstall app');
      return;
    }
    this.initDownloadProgress(folderId, notInstallList, downloadData);
    downloadData.setNotInstallApps(this.removeAppInstalled(notInstallList, downloadData));
    /* 更新文件夹下载状态 */
    this.updateFolderDownloadState(folderId, downloadData);
  }

  private updateFolderDownloadState(folderId: string, downloadData: FolderDownloadData, actionBundleName?: string,
    actionStatus?: AppStatus): void {
    let downloadStatusMap: Map<AppStatus, number> = new Map<AppStatus, number>();
    let notInstallApps: GridLayoutItemInfo[] = downloadData.getNotInstallApps();
    actionBundleName && notInstallApps.forEach((item) => {
      if (CheckEmptyUtils.isEmpty(item)) {
        log.showInfo(TAG, 'DownloadState notInstallAppList item is empty');
        return;
      }
      if (item.bundleName === actionBundleName) {
        item.appStatus = actionStatus;
      }
      if (item.appStatus && downloadStatusMap.has(item.appStatus as AppStatus)) {
        downloadStatusMap.set(item.appStatus as AppStatus, (downloadStatusMap.get(item.appStatus) ?? 0 ) + 1);
      } else {
        downloadStatusMap.set(item.appStatus as AppStatus, 1);
      }
    });
    log.showInfo(TAG, 'the downloading item length %{public}d in folder %{public}s  already download %{public}d, total download %{public}d',
      notInstallApps.length, folderId, downloadData.getAlreadyDownloadSize(), downloadData.getTotalDownloadSize());
    if (notInstallApps.length === 1) {
      this.handleOneAppInstall(folderId, downloadData, notInstallApps[0]);
    } else if (notInstallApps.length > 1) {
      this.handleAppsInstall(folderId, downloadStatusMap, downloadData);
    } else {
      this.finish(folderId, downloadData);
    }
  }

  private handleOneAppInstall(folderId: string, downloadData: FolderDownloadData, item: GridLayoutItemInfo): void {
    if (downloadData.getAlreadyDownloadSize() <= downloadData.getTotalDownloadSize()) {
      this.mLayoutVm.getViewOsrMgr(folderId).switchStatus('one-install-show', OBSERVER_SWITCH.PROGRESS_SHOW, true);
      downloadData.setItemDownloadState(item.appStatus as AppStatus);
      this.updateDownloadProgress(folderId, downloadData.getAlreadyDownloadSize(), downloadData.getTotalDownloadSize());
      if (downloadData.getItemDownloadState() === AppStatus.INSTALLING) {
        this.mActionEventMgr.notify('install animation', this.mFolderMgr.getFolder(folderId).getGridInfo(),
          FolderActionLifeCycleStatus.INSTALLING_FOLDER);
      }
    }
  }

  private handleAppsInstall(folderId: string, downloadStatusMap: Map<AppStatus, number>,
    downloadData: FolderDownloadData): void {
    this.mLayoutVm.getViewOsrMgr(folderId).switchStatus('multi-install-show', OBSERVER_SWITCH.PROGRESS_SHOW, true);
    let pauseItemNum: number = (downloadStatusMap.get(AppStatus.PAUSING) ?? 0) +
      (downloadStatusMap.get(AppStatus.WIFI_WAITING) ?? 0);
    if (pauseItemNum === downloadData.getNotInstallApps().length) {
      // 此时所有应用均为暂停状态，小文件夹状态为暂停
      downloadData.setItemDownloadState(AppStatus.PAUSING);
    } else {
      downloadData.setItemDownloadState(AppStatus.DOWNLOADING);
    }
    this.updateDownloadProgress(folderId, downloadData.getAlreadyDownloadSize(),
      downloadData.getTotalDownloadSize(), true, false);
  }

  private finish(folderId: string, downloadData: FolderDownloadData): void {
    downloadData.setItemDownloadState(AppStatus.INSTALLED);
    this.mLayoutVm.getViewOsrMgr(folderId).switchStatus('finish-hide', OBSERVER_SWITCH.PROGRESS_SHOW, false);
    downloadData.resetDownloadSize();
    this.updateDownloadProgress(folderId, 0, 0, false, true);
  }

  private removeAppInstalled(newNotInstallApps: GridLayoutItemInfo[],
    downloadData: FolderDownloadData): GridLayoutItemInfo[] {
    return downloadData.getNotInstallApps().filter((item: GridLayoutItemInfo) => {
      if (CheckEmptyUtils.isEmpty(item)) {
        log.showInfo(TAG, 'updateNotInstalledApp notInstallAppList item is empty');
        return false;
      }
      let isFind = newNotInstallApps.some(newItem => newItem.bundleName === item.bundleName);
      if (!isFind) {
        this.removeUnInstalledApp(item.bundleName, downloadData, true);
      }
      return isFind;
    });
  }

  private getNewAppNotInstallList(folderId: string, itemList: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    if (CheckEmptyUtils.isEmptyArr(itemList)) {
      return [];
    }
    if (this.mFolderMgr.getDisappearLastAppData()?.folderId === folderId) {
      log.showWarn(TAG, 'getNoInstallAppList folder is disappearing %{public}s', folderId);
      return [];
    }
    let newNotInstalledAppList: GridLayoutItemInfo[] = [];
    itemList.forEach((item: GridLayoutItemInfo) => {
      if (CheckEmptyUtils.isEmpty(item)) {
        log.showInfo(TAG, 'updateNotInstalledApp layoutInfo item is empty');
        return;
      }
      if (GridLayoutUtil.isAddIcon(item)) {
        return;
      }
      // 不处理加号和从当前文件夹中拖出的元素
      let dragLeaveItem: GridLayoutItemInfo | undefined = this.mFolderMgr.getDragItemFolder();
      if (item.typeId !== CommonConstants.TYPE_APP || (dragLeaveItem && dragLeaveItem.keyName === item.keyName &&
        dragLeaveItem.folderId === folderId)) {
        return;
      }
      let cloneItem: GridLayoutItemInfo = ObjectCopyUtil.deepClone(item);
      if (this.isNeedCalculateProgress(item)) {
        newNotInstalledAppList.push(cloneItem);
      }
    });
    return newNotInstalledAppList;
  }

  // 通过应用类型和状态判断是否需要在小文件夹中计算下载进度
  private isNeedCalculateProgress(item: GridLayoutItemInfo): boolean {
    if (GridLayoutUtil.isAppInstalled(item)) {
      return false;
    }
    // 未OpenHarmony化的应用不需要计算下载进度
    if (item.appStatus === AppStatus.WAIT_FOR_HARMONY) {
      return false;
    }
    // OpenHarmony化的企业应用，点亮未下载时不需要计算下载进度
    if (item.appStatus === AppStatus.PENDING && CommonUtils.jsonStrToMap(item.intent).get('appType') === 1) {
      return false;
    }
    return true;
  }

  private initDownloadProgress(folderId: string, newNotInstalledAppList: GridLayoutItemInfo[],
    downloadData: FolderDownloadData): void {
    let notInstallApps: GridLayoutItemInfo[] = downloadData.getNotInstallApps();
    newNotInstalledAppList.forEach((cloneItem: GridLayoutItemInfo) => {
      let itemIndex: number = notInstallApps.findIndex(item => item?.keyName === cloneItem.keyName);
      if (itemIndex === -1) {
        notInstallApps.push(cloneItem);
      } else {
        // 继承下载进度
        cloneItem.downloadProgress = notInstallApps[itemIndex].downloadProgress;
        notInstallApps[itemIndex] = cloneItem;
      }
      let progress: number = cloneItem.downloadProgress;
      log.showInfo(TAG, 'getNoInstallAppList folder is progress: %{public}d', progress);
      downloadData.changeAlreadyDownloadSize(progress * CommonConstants.MAX_DOWNLOAD_VALUE);
      downloadData.changeTotalDownloadSize(CommonConstants.MAX_DOWNLOAD_VALUE);
      this.initEventhubEvent(folderId, cloneItem);
    });
  }

  private initEventhubEvent(folderId: string, item: GridLayoutItemInfo): void {
    if (item.bundleName) {
      let eventId: string = this.getAppGalleryEventId(item);
      this.desktopContext?.eventHub.off(eventId);
      this.desktopContext?.eventHub.on(eventId, (eventInfo: AppGalleryEventInfo): void =>
        this.appGalleryStatusChangeEvent(folderId, eventInfo));
      log.showInfo(TAG, `onEventhubAppDownloadStatusChangedEvent for AppName ${eventId}`);
    }
  }

  private unregisterEventhubEvent(item: GridLayoutItemInfo): void {
    this.desktopContext?.eventHub.off(this.getAppGalleryEventId(item));
  }

  private appGalleryStatusChangeEvent(folderId: string, eventInfo: AppGalleryEventInfo): void {
    if (this.mLayoutVm.isFolderUnregister(folderId)) {
      return;
    }
    log.showInfo(TAG, 'app gallery event %{public}s for folder %{public}s', eventInfo.eventType, folderId);
    switch (eventInfo.eventType) {
      case DownloadStatusChangeEvent.DOWNLOAD_STATUS_CHANGE:
        this.updateFolderDownloadState(folderId, this.getFolderDownloadData(folderId), eventInfo.bundleName,
          eventInfo.status as AppStatus);
        break;
      case DownloadingProgressChangeEvent.DOWNLOAD_PROGRESS_CHANGE:
        this.onEventhubAppDownloadProgressChangedEvent(folderId, eventInfo);
        break;
      case InstallStatusChangeEvent.INSTALL_STATUS_CHANGE:
        this.onEventhubAppInstallStatusChangedEvent(folderId, eventInfo);
        break;
      default :
        break;
    }
  }

  private onEventhubAppDownloadProgressChangedEvent(folderId: string, eventInfo: AppGalleryEventInfo): void {
    if (this.mLayoutVm.isFolderUnregister(folderId)) {
      return;
    }
    if (eventInfo.totalSize && eventInfo.downloadedSize) {
      let downloadData: FolderDownloadData = this.getFolderDownloadData(folderId);
      downloadData.setItemDownloadState(eventInfo.status);
      let totalSize: number = eventInfo.totalSize;
      let downloadedSize: number = eventInfo.downloadedSize;
      downloadData.setAlreadyDownloadSize(0);
      downloadData.getNotInstallApps().forEach((item) => {
        if (CheckEmptyUtils.isEmpty(item)) {
          log.showInfo(TAG, 'event notInstallAppList item is empty');
          return;
        }
        if (item.bundleName === eventInfo.bundleName) {
          item.downloadProgress = downloadedSize / totalSize;
        }
        downloadData.changeAlreadyDownloadSize((item.downloadProgress ?? 0) * CommonConstants.MAX_DOWNLOAD_VALUE);
      });
      this.changeDownloadProgress(folderId, Math.floor(downloadData.getAlreadyDownloadSize()), downloadData);
    }
  }

  private onEventhubAppInstallStatusChangedEvent(folderId: string, eventInfo: AppGalleryEventInfo): void {
    this.refreshInstalledAppDownloadProgress(folderId);
    let downloadData: FolderDownloadData = this.getFolderDownloadData(folderId);
    this.removeUnInstalledApp(eventInfo.bundleName, downloadData);
    downloadData.setNotInstallApps(downloadData.getNotInstallApps()
      .filter(item => item.bundleName !== eventInfo.bundleName));
    if (downloadData.getNotInstallApps().length === 0) {
      downloadData.setDownloadFinishBundle(eventInfo.bundleName);
      downloadData.setItemDownloadState(AppStatus.INSTALLED);
      this.mActionEventMgr.notify('finish download', this.mFolderMgr.getFolder(folderId).getGridInfo(),
        FolderActionLifeCycleStatus.INSTALLED_FOLDER);
    } else {
      this.updateFolderDownloadState(folderId, downloadData);
    }
  }

  private refreshInstalledAppDownloadProgress(folderId: string): void {
    let folders: GridLayoutItemInfo[] = this.mFolderMgr.getFolder(folderId).getItems();
    folders.forEach(item => {
      if (GridLayoutUtil.isAppInstalled(item) && item.downloadProgress === PROGRESS_END) {
        item.downloadProgress = PROGRESS_START;
      }
    });
  }

  private getAppGalleryEventId(item: GridLayoutItemInfo): string {
    return `appGalleryStatusChange${item.bundleName}${item.appIndex ?? 0}smallFolder`;
  }

  private removeUnInstalledApp(bundleName: string, downloadData: FolderDownloadData,
    isDeleteDownloadSize: boolean = false): void {
    if (isDeleteDownloadSize) {
      downloadData.changeTotalDownloadSize(-CommonConstants.MAX_DOWNLOAD_VALUE);
      downloadData.changeAlreadyDownloadSize(-(CommonConstants.MAX_DOWNLOAD_VALUE - 1));
    }
    let item: GridLayoutItemInfo | undefined =
      downloadData.getNotInstallApps().find(item => item?.bundleName === bundleName);
    if (item) {
      this.unregisterEventhubEvent(item);
    }
  }

  private onInstallAniFinish(bundleName: string): void {
    const smartDockInstallAniFinishEvent: string = `smartDockInstallAniFinish${bundleName}`;
    this.desktopContext?.eventHub?.emit(smartDockInstallAniFinishEvent);
    const desktopInstallAniFinishEvent: string = `desktopInstallAniFinish${bundleName}`;
    this.desktopContext?.eventHub?.emit(desktopInstallAniFinishEvent);
  }

  private changeDownloadProgress(folderId: string, progress: number, downloadData: FolderDownloadData): void {
    if (downloadData.getDownloadProgress() === progress) {
      return;
    }
    downloadData.setDownloadProgress(progress);
    if ((downloadData.getItemDownloadState() === AppStatus.DOWNLOADING ||
      downloadData.getItemDownloadState() === AppStatus.UPDATING) && desktopUtil.isDesktopForeground()) {
      let totalSize: number = downloadData.getTotalDownloadSize();
      let curProgress: number = (downloadData.getDownloadProgress() >= totalSize - 1) ?
        totalSize - 1 : downloadData.getDownloadProgress();
      this.updateDownloadProgress(folderId, curProgress, totalSize, false, (totalSize === 0));
    }
  }

  private updateDownloadProgress(folderId: string, curSize: number, totalSize: number, isNewProgress?: boolean,
    isReset?: boolean): void {
     let progressUpdate = this.progressUpdateCallMap.get(folderId);
     if (progressUpdate) {
       progressUpdate(curSize, totalSize, isNewProgress, isReset);
     }
  }
}

/**
 *
 * this.totalDownloadSize： 当前小文件夹总进度
 * this.alreadyDownloadSize： 当前小文件夹内已经下载的进度
 * this.installedAppInSmallFolder： 小文件夹中通过下载安装完成的应用数目。
 *
 * this.alreadyDownloadSize = this.installedAppInSmallFolder(小文件夹通过下载安装的应用数目)
 *     * 500 + progress(待下载应用的进度:0 < progress < 1 ) * 500
 *
 * 小文件夹的月牙进度（下载进度）： this.alreadyDownloadSize / this.totalDownloadSize;
 *
 * this.installedAppInSmallFolder，文件夹内总应用数目发生变化的时候, 小文件夹内的已下载应用数目会变为0.
 */
class FolderDownloadData {
  private alreadyDownloadSize: number = 0;

  private totalDownloadSize: number = 0;

  private itemDownloadState: number = AppStatus.INSTALLED;

  private mNotInstallApps: GridLayoutItemInfo[] = [];

  private mDownloadFinishBundleName: string = '';

  private downloadProgress: number = 0;

  /**
   * 增加下载进度
   *
   * @param changeValue 增加的进度值
   */
  public changeAlreadyDownloadSize(changeValue: number): void {
    this.alreadyDownloadSize += changeValue;
  }

  /**
   * 修改总的文件夹下载总进度
   *
   * @param changeValue 增加值
   */
  public changeTotalDownloadSize(changeValue: number): void {
    this.totalDownloadSize += changeValue;
  }

  /**
   * 获取当前总下载进度
   *
   * @returns 总下载进度值
   */
  public getTotalDownloadSize(): number {
    return this.totalDownloadSize;
  }

  /**
   * 获取已下载进度值
   *
   * @returns 已下载进度值
   */
  public getAlreadyDownloadSize(): number {
    return this.alreadyDownloadSize;
  }

  /**
   * 设置已下载进度值
   *
   * @param size 下载进度值
   */
  public setAlreadyDownloadSize(size: number): void {
    this.alreadyDownloadSize = size;
  }

  /**
   * 设置下载状态
   *
   * @param state 下载状态
   */
  public setItemDownloadState(state: number): void {
    this.itemDownloadState = state;
  }

  /**
   * 获取下载进度
   *
   * @returns 下载进度
   */
  public getItemDownloadState(): number {
    return this.itemDownloadState;
  }

  /**
   * 设置未安装的应用列表
   *
   * @param notInstallApps 未安装列表
   */
  public setNotInstallApps(notInstallApps: GridLayoutItemInfo[]): void {
    this.mNotInstallApps = notInstallApps;
  }

  /**
   * 获取未安装的应用列表
   *
   * @returns 未安装应用列表
   */
  public getNotInstallApps(): GridLayoutItemInfo[] {
    return this.mNotInstallApps;
  }

  /**
   * 设置下载完成的应用bundleName
   *
   * @param bundleName 应用包名
   */
  public setDownloadFinishBundle(bundleName: string): void {
    this.mDownloadFinishBundleName = bundleName;
  }

  /**
   * 获取下载完成的应用包名
   *
   * @returns 应用包名
   */
  public getDownloadFinishBundle(): string {
    return this.mDownloadFinishBundleName;
  }

  /**
   * 设置下载进度
   *
   * @param progress 下载进度
   */
  public setDownloadProgress(progress: number): void {
    this.downloadProgress = progress;
  }

  /**
   * 获取下载进度
   *
   * @returns 下载进度
   */
  public getDownloadProgress(): number {
    return this.downloadProgress;
  }

  /**
   * 重置下载进度值
   */
  public resetDownloadSize(): void {
    this.alreadyDownloadSize = 0;
    this.totalDownloadSize = 0;
    this.mNotInstallApps = [];
  }
}