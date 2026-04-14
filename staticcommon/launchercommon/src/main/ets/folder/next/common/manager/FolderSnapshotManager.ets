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

import { image } from '@kit.ImageKit';
import { CheckEmptyUtils, DomainName, LogDomain, Logger, PixelMapUtil, TraceUtil } from '@ohos/basicutils';
import { launcherStatusUtil } from '@ohos/windowscene/src/main/ets/TsIndex';
import {
  CommonConstants,
  ContractedFolderLayoutViewModel,
  DesktopManager,
  EventConstants,
  FolderActionLifeCycleEvent,
  FolderActionLifeCycleEventManager,
  FolderCommonUtil,
  FolderLifeCyclePriority,
  GridLayoutItemInfo,
  GridLayoutUtil,
  NotHarmonyUtil,
  OBSERVER_SWITCH,
  SmallFolderIconFileUtil
} from '../../../../TsIndex';
import { SmallFolderCacheManager } from '../../../SmallFolderCacheManager';
import { CustomBuilder } from 'DragControllerParam';
import { FolderDataListener, FolderManager } from '../model/FolderManager';
import { componentSnapshot } from '@kit.ArkUI';
import { IconResourceManager, localEventManager } from '@ohos/frameworkwrapper';
import { desktopUtil, RTLUtil } from '@ohos/componenthelper';
import { FoldersData, FolderImageItemInfo } from '../model/data/FoldersData';
import { ReceiveEventInfo } from '../../../../bean/ReceiveEventInfo';
import { EventConstants as StaticEventConstants } from '@ohos/frameworkwrapper/src/main/ets/utils/EventManager';
import { BusinessError } from '@kit.BasicServicesKit';
import { ShortcutViewModel } from '../../../../launchericon/viewmodel/ShortcutViewModel'
import { AppItemInfo } from '../../../../bean/AppItemInfo';
import { AppInstallEventData } from '../../../../appinstall/AppInstallEventData';
import { BaseDataObserverManager } from '../observer/BaseDataObserverManager';
import {
  ContractedFolderLayoutStyle,
  ContractedFolderLayoutStyleFactory
} from '../../contractedfolder/viewmodel/layout/style/ContractedFolderLayoutStyleFactory';
import { BaseBundleInfo } from '../../../../bean/BaseBundleInfo';

const SNAPSHOT_DELAY: number = 10;
const DEFAULT_SNAPSHOT_TIME: number = 300;
// 截图重试次数, 1 表示只重试1次, 后期可以根据需要调整为其他的值
const SNAPSHOT_RETRY_TIMES: number = 1;
const TAG = 'FolderSnapshotManager';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

export class FolderSnapshotManager {
  private static instance: FolderSnapshotManager;
  private mUiContext?: UIContext;

  private mFolderCacheMgr: SmallFolderCacheManager = SmallFolderCacheManager.getInstance();

  private mLayoutVm: ContractedFolderLayoutViewModel = ContractedFolderLayoutViewModel.getInstance();

  private mDataMgr: FolderManager = FolderManager.getInstance();

  private mSnapBuilder: Map<string, CustomBuilder> = new Map<string, CustomBuilder>();

  private isSupportPreview: boolean = false;

  private calendarImageChangeCb: (image: PixelMap) => void = (image: PixelMap) => {
    // 避免循环调用卡死, 日历资源为空时不触发截图
    if (CheckEmptyUtils.isEmptyPixelMap(image)) {
      log.showError(TAG, 'calendarImage is null');
      return;
    }
    this.onCalendarImageChange();
  };

  private rtlChangeCallback = (isRtl: boolean) => {
    log.showInfo(TAG, 'RTL change: ' + isRtl);
    this.refreshAllFoldersPageIcon('RTL change');
  };

  private refreshAllFoldersPageIcon(msg: string) : void {
    let folders: FoldersData[] = this.mDataMgr.getSmallFolders() ?? [];
    for (const folder of folders) {
      let folderItem: GridLayoutItemInfo = folder.getGridInfo();
      let folderId: string = folderItem.folderId ?? '';
      this.refreshAllFolderIcon(msg, folderId);
    }
  }

  private folderActionEvt: FolderActionLifeCycleEvent = {
    description: TAG,
    priority: FolderLifeCyclePriority.NORMAL,
    onClosingFolder: (folder: GridLayoutItemInfo) => {
      // 小文件夹非首尾页关闭时文件夹折叠态需要从当前页回到首页所以需要获取到当前页截图，而从展开态中拖出图标场景当前折叠态未实现动效则不进行截图
      if (!FolderCommonUtil.isLayout1X1(folder.area) || !folder.layoutInfo || folder.folderId === undefined) {
        return;
      }
      let folderId: string = folder.folderId;
      let pageIndex: number = this.mDataMgr.getPageIndex();
      if (pageIndex > 0 && pageIndex < folder.layoutInfo.length) {
        this.mLayoutVm.getDataOsrMgr(folderId).setCurrentPageItems('closing folder', folder.layoutInfo[pageIndex]);
        this.mLayoutVm.getViewOsrMgr(folderId).switchStatus('closing folder', OBSERVER_SWITCH.END_PAGE_SHOW, true);
        this.refreshCurrentFolderIcon('closing folder to snapshot', folderId, (image: image.PixelMap) => {
          this.mLayoutVm.getDataOsrMgr(folderId).setCurrentPageIcon('closing folder', image);
          this.mLayoutVm.getViewOsrMgr(folderId).switchStatus('closingFolder', OBSERVER_SWITCH.CURRENT_PAGE_SHOW, true);
        });
      }
    }
  };

  private mFolderDataListener: FolderDataListener = {
    description: TAG,
    priority: FolderLifeCyclePriority.LOW,
    removeFolder: (folder: GridLayoutItemInfo) => {
      this.deleteSnapshotBuilder(folder.folderId as string);
      this.deleteFolderIcon(folder);
    }
  };

  // 接受包管理事件, 刷新截图
  private onBmsChangEvent(event: string, bundleName: string): void {
    log.showInfo(TAG, 'onBmsChangEvent event: %{public}s bundleName: %{public}s', event, bundleName);
    if (event === EventConstants.EVENT_PACKAGE_ADDED || event === EventConstants.EVENT_PACKAGE_CHANGED) {
      this.onBundleNameChange(bundleName);
    }
  }

  private readonly mLocalEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: Array<string> | AppInstallEventData | Array<BaseBundleInfo>) => {
      if (event === EventConstants.EVENT_GRAY_PACKAGE_CHANGED) {
        let folders: FoldersData[] = this.mDataMgr.getSmallFolders() ?? [];
        folders.forEach(folder => this.onGrayStatusChangeInSmallFolder(params as BaseBundleInfo[], folder))
      } else if (event === StaticEventConstants.EVENT_REFRESH_SMALL_FOLDER_IMAGE) {
        let folders: FoldersData[] = this.mDataMgr.getSmallFolders() ?? [];
        folders.forEach(folder => {
          let changeBundleList: string[] = params as string[];
          for (let i = 0; i < changeBundleList.length; i++) {
            if (this.onChangeBundleInSmallFolderImage(changeBundleList[i], folder)) {
              break;
            }
          }
        })
      } else if (event === EventConstants.EVENT_REFRESH_ALL_SMALL_FOLDER_IMAGE) {
        let folders: FoldersData[] = this.mDataMgr.getSmallFolders() ?? [];
        folders.forEach(folder => {
          let folderId: string = folder.getGridInfo().folderId ?? '';
          this.reloadSmallFolderImage('refresh all smallFolderImage', folderId, false, folder.getMainPageItems());
          this.reloadSmallFolderImage('refresh all smallFolderImage', folderId, true, folder.getLastPageItems());
        })
      } else if (event === EventConstants.EVENT_REFRESH_SHORTCUT_IMAGE) {
        let folders: FoldersData[] = this.mDataMgr.getSmallFolders() ?? [];
        folders.forEach(folder => this.onShortcutImageChange(folder));
      } else if (event === EventConstants.APP_INSTALL_BMS_CHANGE_EVENT) {
        const event: AppInstallEventData = params as AppInstallEventData;
        this.onBmsChangEvent(event.eventName, event.bundleName);
      } else if (event === EventConstants.EVENT_CHANGE_THEME_BIG_FOLDER_PIC) {
        // 切换主题时清除小文件夹截图,对桌面首页所有大文件截图
        this.mFolderCacheMgr.clearCache();
        this.fisrtPageBigFolderPreviewSnapshot();
      }
    }
  };

  private constructor() {
    RTLUtil.registerRtlChangeCallback(this.rtlChangeCallback);
    FolderActionLifeCycleEventManager.getInstance().register(this.folderActionEvt);
    FolderManager.getInstance().registerDataLifeListener(this.mFolderDataListener);
    localEventManager.registerEventListener(this.mLocalEventListener,
      [EventConstants.EVENT_GRAY_PACKAGE_CHANGED, StaticEventConstants.EVENT_REFRESH_SMALL_FOLDER_IMAGE,
        EventConstants.EVENT_REFRESH_ALL_SMALL_FOLDER_IMAGE, EventConstants.EVENT_REFRESH_SHORTCUT_IMAGE,
        EventConstants.APP_INSTALL_BMS_CHANGE_EVENT, EventConstants.EVENT_CHANGE_THEME_BIG_FOLDER_PIC]);
  }

  public static getInstance(): FolderSnapshotManager {
    if (!FolderSnapshotManager.instance) {
      FolderSnapshotManager.instance = new FolderSnapshotManager();
    }
    return FolderSnapshotManager.instance;
  }

  /**
   * 设置是否支持预览显示
   */
  public setIsSupportPreviewMode(isSupport: boolean): void {
    this.isSupportPreview = isSupport;
  }

  private onBundleNameChange(bundleName: string): void {
    let folders: FoldersData[] = this.mDataMgr.getSmallFolders() ?? [];
    for (const folder of folders) {
      let folderItem: GridLayoutItemInfo = folder.getGridInfo();
      let folderId: string = folderItem.folderId ?? '';
      if (NotHarmonyUtil.isNotHarmonyFolderById(folderId)) {
        continue;
      }
      const dataOsrMgr: BaseDataObserverManager = this.mLayoutVm.getDataOsrMgr(folderId);
      if (!dataOsrMgr.isSmallFolder()) {
        continue;
      }
      let firstPageItems: GridLayoutItemInfo[] = dataOsrMgr.getFirstPageItems();
      if (FolderCommonUtil.isBundleNameInList(bundleName, firstPageItems)) {
        IconResourceManager.getInstance().deleteIconResource(bundleName);
        this.reloadSmallFolderImage('bundleName change refresh', folderId, false, firstPageItems, true);
      }
      let endPageItems: GridLayoutItemInfo[] = dataOsrMgr.getEndPageItems();
      if (FolderCommonUtil.isBundleNameInList(bundleName, endPageItems)) {
        IconResourceManager.getInstance().deleteIconResource(bundleName);
        this.reloadSmallFolderImage('bundleName change refresh', folderId, true, endPageItems, true);
      }
    }
  }

  private onCalendarImageChange(): void {
    let folders: FoldersData[] = this.mDataMgr.getSmallFolders() ?? [];
    for (const folder of folders) {
      let showAppList: GridLayoutItemInfo[] = folder.getContractedFolderShowItems();
      if (showAppList.findIndex(item => item.bundleName === CommonConstants.CALENDAR_BUNDLE) !== -1) {
        this.reloadSmallFolderImage('onCalendarImageChange', folder.getGridInfo().folderId ?? '', false, showAppList);
      }
    }
  }

  private onGrayStatusChangeInSmallFolder(changedBundles: BaseBundleInfo[], folderData: FoldersData): boolean {
    let showAppList: FolderImageItemInfo[] = folderData.getMainPageItems();
    let endPageList: FolderImageItemInfo[] = folderData.getLastPageItems();
    let folderId: string = folderData.getGridInfo().folderId ?? '';
    if (CheckEmptyUtils.isEmptyArr(showAppList)) {
      log.showError(TAG, 'isGrayStatusChangeInSmallFolder, showAppList is null');
      return false;
    }
    if (this.isGrayStatusChange(changedBundles, showAppList)) {
      log.showInfo(TAG, 'isGrayStatusChangeInSmallFolder is in showAppList');
      this.reloadSmallFolderImage('grayStatus change refresh main page', folderId, false, showAppList, true);
      return true;
    }
    if (CheckEmptyUtils.isEmptyArr(endPageList)) {
      log.showDebug(TAG, 'isGrayStatusChangeInSmallFolder, endPageAppList is null');
      return false;
    }
    if (this.isGrayStatusChange(changedBundles, endPageList)) {
      log.showWarn(TAG, `isGrayStatusChangeInSmallFolder is in endPageAppList  ${folderId}`);
      this.reloadSmallFolderImage('grayStatus change refresh end page', folderId, true, endPageList, true);
      return true;
    }
    log.showInfo(TAG, 'isGrayStatusChangeInSmallFolder is not in smallFolder image');
    return false;
  }

  private isGrayStatusChange(changedBundles: BaseBundleInfo[], grayIconInfos: FolderImageItemInfo[]): boolean {
    for (let i = 0; i < grayIconInfos.length; i++) {
      if (this.isContainGrayIcon(changedBundles, grayIconInfos[i]) && !grayIconInfos[i].isGrayIcon) {
        grayIconInfos[i].isGrayIcon = true;
        return true;
      } else if (!this.isContainGrayIcon(changedBundles, grayIconInfos[i]) && grayIconInfos[i].isGrayIcon) {
        grayIconInfos[i].isGrayIcon = false;
        return true;
      }
    }
    return false;
  }

  private isContainGrayIcon(changedBundles: BaseBundleInfo[], grayIcon: FolderImageItemInfo): boolean {
    return changedBundles.findIndex(item => item.bundleName === grayIcon.bundleName &&
      item.appIndex === grayIcon.appIndex) >= 0;
  }

  private onChangeBundleInSmallFolderImage(bundleName: string, folderData: FoldersData): boolean {
    let showAppList: GridLayoutItemInfo[] = folderData.getContractedFolderShowItems();
    let endPageList: GridLayoutItemInfo[] = folderData.getLastPageItems();
    let folderId: string = folderData.getGridInfo().folderId ?? '';
    if (CheckEmptyUtils.isEmptyArr(showAppList)) {
      log.showError(TAG, 'isChangeBundleInSmallFolderImage, showAppList is null');
      return false;
    }
    let findIndex = showAppList.findIndex(item => item.bundleName === bundleName);
    if (findIndex >= 0) {
      log.showInfo(TAG, 'isChangeBundleInSmallFolderImage is in showAppList');
      this.reloadSmallFolderImage('change bundle refresh main page', folderId, false, showAppList);
      return true;
    }
    if (CheckEmptyUtils.isEmptyArr(endPageList)) {
      log.showError(TAG, 'isChangeBundleInSmallFolderImage, endPageAppList is null');
      return false;
    }
    findIndex = endPageList.findIndex(item => item.bundleName === bundleName);
    if (findIndex >= 0) {
      log.showWarn(TAG, `isChangeBundleInSmallFolderImage is in endPageAppList  ${folderId}`);
      this.reloadSmallFolderImage('change bundle refresh end page', folderId, true, endPageList);
      return true;
    }
    log.showInfo(TAG, 'isChangeBundleInSmallFolderImage is not in smallfolder image');
    return false;
  }

  private onShortcutImageChange(folder: FoldersData): void {
    log.showInfo(TAG, 'onShortcutImageChange');
    let showAppList: GridLayoutItemInfo[] = folder.getContractedFolderShowItems();
    let folderId: string = folder.getGridInfo().folderId ?? '';
    if (showAppList.some(item => item.typeId === CommonConstants.TYPE_SHORTCUT_ICON)) {
      this.reloadSmallFolderImage('shortcut image change', folderId, false, showAppList);
    }
  }

  private reloadSmallFolderImage(msg: string, folderId: string, isEndPage: boolean, items: GridLayoutItemInfo[],
    forceUpdate: boolean = false): void {
    if (isEndPage) {
      this.mFolderCacheMgr.deleteCache(folderId + SmallFolderIconFileUtil.END_PAGE_IMAGE);
      if (desktopUtil.isFold()) {
        this.mFolderCacheMgr.deleteCache(folderId + SmallFolderIconFileUtil.END_PAGE_IMAGE +
        SmallFolderIconFileUtil.Expand_PAGE_IMAGE);
      }
    } else {
      this.mFolderCacheMgr.deleteCache(folderId);
    }
    const snapInfo: FolderSnapInfo = new FolderSnapInfo();
    snapInfo.folderId = folderId;
    snapInfo.mIsEndPage = isEndPage;
    snapInfo.items = items;
    snapInfo.callback = (image: image.PixelMap) => {
      if (isEndPage) {
        this.mLayoutVm.getDataOsrMgr(folderId).setEndPageIcon(msg, image);
      } else {
        this.mLayoutVm.getDataOsrMgr(folderId).setFirstPageIcon(msg, image);
      }
    }
    this.refreshFolderIcon(msg, folderId, snapInfo, forceUpdate);
  }

  /**
   * 桌面壁纸预览模式截图
   *
   * @param folderId 文件夹id
   */
  public processBigFolderPreviewSnapshot(folderId: string): void {
    if (!this.isSupportPreview) {
      return;
    }
    try {
      this.mUiContext?.getComponentSnapshot().get(`FolderComponent_grid_${folderId}`).then((pixmap: image.PixelMap) => {
        if (pixmap) {
          const bigFolderPreviewName = `BFP${folderId}`;
          PixelMapUtil.addName(pixmap, bigFolderPreviewName);
          DesktopManager.getInstance().savePixmap2file(pixmap, `big_${folderId}`).then(() => {
            pixmap.release();
          });
          log.showInfo(TAG, 'refreshFolderIcon saved png %{public}s', folderId);
        }
      }).catch((error: BusinessError) => {
        log.showError(TAG, 'getBigFolderSnapshot error code[ %{public}s]: %{public}s', error.code, error.message);
      });
    } catch (err) {
      log.showError(TAG, 'refreshFolderIcon error %{public}s', err.message);
    }
  }

  //大文件截图
  private bigFolderPreviewSnapshot(): void {
    if (!this.isSupportPreview) {
      return;
    }
    let folders: FoldersData[] = this.mDataMgr.getFolders() ?? [];
    if (CheckEmptyUtils.isEmptyArr(folders)) {
      log.showInfo(TAG, 'fisrtPageBigFolderPreviewSnapshot is return as folder is null');
      return;
    }
    for (const folder of folders) {
      let folderItem: GridLayoutItemInfo = folder.getGridInfo();
      if (folderItem.page === 0 && GridLayoutUtil.isBigFolder(folderItem)) {
        setTimeout(() => {
          log.showInfo('wallPaperChange get big folder pic folderId: %{public}s, appName: %{public}s', folderItem.folderId, folderItem.appName);
          FolderSnapshotManager.getInstance().processBigFolderPreviewSnapshot(folderItem.folderId as string);
        }, CommonConstants.BIG_FOLDER_TIMEOUT);
      }
    }
  }

  /**
   *桌面首页大文件截图（仅切换主题会调该函数）
   *
   * @return void
   */
  public fisrtPageBigFolderPreviewSnapshot(): void {
    //切换主题完成，第一次间隔9秒截图，但是由于大文件图标在截图时未更新完毕，小概率会导致截图不完整，或者还是上一个主题图标等异常
    this.bigFolderPreviewSnapshot();
    //基于第一次截图小概率会异常，再次延迟9秒后，第二次截图并覆盖，确保大文件截图完整无误
    setTimeout(() => {
      this.bigFolderPreviewSnapshot();
    }, CommonConstants.BIG_FOLDER_TIMEOUT);
  }

  /**
   * 通知截图刷新
   *
   * @param folderId 文件夹id
   * @param items 刷新元素列表
   * @param isEndPage 是否刷新最后一页
   * @param isCurrent 是否刷新当前页
   * @param callback 刷新后的截图更新回调
   */
  public notifyRefresh(folderId: string, snapInfo: FolderSnapInfo): void {
    if (snapInfo.mIsCurrent) {
      this.refreshCurrentFolderIcon('refresh current page', folderId, snapInfo.callback);
    } else {
      this.refreshFolderIcon('refresh main page', folderId, snapInfo);
    }
  }

  private refreshCurrentFolderIcon(msg: string, folderId: string, callback: (image: image.PixelMap) => void): void {
    if (!this.mUiContext) {
      log.showInfo(TAG, `refreshCurrentFolderIcon mUiContext is invalid.`);
      return;
    }
    try {
      log.showInfo(TAG, '(%{public}s) refresh current folder icon : %{public}s', msg, folderId);
      TraceUtil.startTrace(DomainName.HOME, TraceUtil.CORE_METHOD_SMALL_FOLDER_SNAPSHOT);
      let cacheBuilder: CustomBuilder = this.getSnapshotBuilder(this.getCurSnapshotKey(folderId));
      this.mUiContext?.getComponentSnapshot().createFromBuilder(cacheBuilder, 300, true,
        { waitUntilRenderFinished: true } as componentSnapshot.SnapshotOptions)
        .then((pixmap: image.PixelMap) => {
          TraceUtil.endTrace(DomainName.HOME, TraceUtil.CORE_METHOD_SMALL_FOLDER_SNAPSHOT);
          callback(pixmap);
          // 采用简短的名称, 避免不完整
          const tagUpdateCurrentIcon = 'SCI';
          PixelMapUtil.addName(pixmap, tagUpdateCurrentIcon + folderId);
        })
        .catch((error: object) => {
          log.error(TAG, 'create CurrentPage: image or componentSnapshot error', error);
        });
    } catch (error) {
      log.error(TAG, 'create CurrentPage: image or componentSnapshot error', error);
    }
  }

  /**
   * 刷新文件夹截图
   *
   * @param msg 用于DFX日志
   * @param folderId 文件夹id
   * @param snapInfo 截图info
   * @param forceUpdate 是否强制刷新
   */
  public refreshFolderIcon(msg: string, folderId: string, snapInfo: FolderSnapInfo,
    forceUpdate: boolean = false): void {
    const items: GridLayoutItemInfo[] = snapInfo.items;
    const isEndPage: boolean = snapInfo.mIsEndPage;
    if (!isEndPage && CheckEmptyUtils.isEmptyArr(items)) {
      log.showWarn(TAG, 'the appList is empty, not to snapshot: %{public}s', msg);
      return;
    }
    snapInfo.appListTag = SmallFolderIconFileUtil.generateAppListKey(isEndPage, items);
    snapInfo.iconTag = SmallFolderIconFileUtil.getIconKey(folderId, isEndPage);
    if (forceUpdate || this.mFolderCacheMgr.getFolderIconCache(snapInfo.iconTag) !== snapInfo.appListTag) {
      this.initAndUpdateFolder(folderId, snapInfo);
    } else {
      this.loadIconFromFile(msg, snapInfo);
    }
  }

  private loadIconFromFile(msg: string, snapInfo: FolderSnapInfo): void {
    const iconTag: string = snapInfo.iconTag;
    SmallFolderIconFileUtil.isIconFileExist(iconTag).then((isExist) => {
      log.showDebug(TAG, '(%{public}s) isIconFileExist: %{public}s', msg, isExist);
      if (!isExist) {
        return;
      }
      try {
        SmallFolderIconFileUtil.loadIconFromPath(iconTag).then((image) => {
          snapInfo.callback(image);
          snapInfo.mIsFirstBuild = false;
          // 采用简短的名称, 避免不完整
          const tagLoadFolderIcon = 'SLI';
          PixelMapUtil.addName(image, tagLoadFolderIcon + iconTag);
        }).catch((error: object) => {
          log.error(TAG, 'loadIconFromPath: image error', error);
        });
      } catch (error) {
        log.error(TAG, 'loadIconFromPath: image error', error);
      }
    });
  }

  private async initAndUpdateFolder(folderId: string, snapInfo: FolderSnapInfo): Promise<void> {
    this.initAppIcon(folderId, snapInfo);
    this.loadFolderIcon(folderId, snapInfo);
  }

  private loadFolderIcon(folderId: string, snapInfo: FolderSnapInfo): void {
    const isEndPage: boolean = snapInfo.mIsEndPage;
    const iconTag: string = snapInfo.iconTag;
    log.showInfo(TAG, 'updateIcon,isEndPage:%{public}s,iconTag:%{public}s,id:%{public}s', isEndPage, iconTag, folderId);
    let delay: number = snapInfo.mIsFirstBuild ? SNAPSHOT_DELAY : 0;
    setTimeout(() => {
      this.mFolderCacheMgr.deleteCache(iconTag);
      const delayTime: number = DEFAULT_SNAPSHOT_TIME;
      this.updateFolderIcon(folderId, snapInfo, delayTime);
    }, delay);
  }

  private updateFolderIcon(folderId: string, snapInfo: FolderSnapInfo, delayTime: number): void {
    if (!this.mUiContext) {
      log.showInfo(TAG, `updateFolderIcon mUiContext is invalid.`);
      return;
    }
    const appListTag: string = snapInfo.appListTag;
    const iconTag: string = snapInfo.iconTag;
    const isEndPage: boolean = snapInfo.mIsEndPage;
    try {
      log.showWarn(TAG, 'createFromBuilder start, folder %{public}s: %{public}s,%{public}s',
        folderId, iconTag, appListTag);
      TraceUtil.startTrace(DomainName.HOME, TraceUtil.CORE_METHOD_SMALL_FOLDER_SNAPSHOT);
      let cacheBuilder: CustomBuilder = this.getSnapshotBuilder(this.getSnapshotKey(folderId, isEndPage));
      this.mUiContext?.getComponentSnapshot().createFromBuilder(cacheBuilder, delayTime, true,
        { waitUntilRenderFinished: true } as componentSnapshot.SnapshotOptions)
        .then((pixmap: image.PixelMap) => {
          TraceUtil.endTrace(DomainName.HOME, TraceUtil.CORE_METHOD_SMALL_FOLDER_SNAPSHOT);
          snapInfo.callback(pixmap);
          snapInfo.mIsFirstBuild = false;
          SmallFolderIconFileUtil.writeFolderIcon(iconTag, pixmap).then(() => {
            this.mFolderCacheMgr.setCache(iconTag, appListTag);
          });
          // 采用简短的名称, 避免不完整
          const tagUpdateFolderIcon = 'SUI';
          PixelMapUtil.addName(pixmap, tagUpdateFolderIcon + iconTag);
          DesktopManager.getInstance().savePixmap2file(pixmap, `small_${folderId}`);
        })
        .catch((error: object) => {
          log.error(TAG, 'createFromBuilder: image or componentSnapshot error', error);
          this.retrySnapshot(folderId, snapInfo, delayTime);
        });
    } catch (error) {
      log.error(TAG, 'createFromBuilder: image or componentSnapshot error', error);
    }
  }

  private retrySnapshot(folderId: string, snapInfo: FolderSnapInfo, delayTime: number): void {
    let needRetry: boolean = false;
    const isEndPage: boolean = snapInfo.mIsEndPage;
    if (isEndPage) {
      snapInfo.mEndListRetryTime += 1;
      if (snapInfo.mEndListRetryTime <= SNAPSHOT_RETRY_TIMES) {
        needRetry = true;
      }
    } else {
      snapInfo.mShowListRetryTime += 1;
      if (snapInfo.mShowListRetryTime <= SNAPSHOT_RETRY_TIMES) {
        needRetry = true;
      }
    }
    if (needRetry) {
      log.showInfo(TAG, 'createSnapshot retry, show: ' + snapInfo.mShowListRetryTime + ', end: ' +
      snapInfo.mEndListRetryTime + ', isEndPage: ' + isEndPage);
      this.updateFolderIcon(folderId, snapInfo, delayTime);
    }
  }

  /**
   * 冷启动阶段，初始化截图缓存
   *
   * @param msg 用于DFX日志
   */
  public initFolderIconCache(msg: string): void {
    log.showInfo(TAG, 'start to init snapshot cache: %{public}s', msg);
    TraceUtil.startTrace(DomainName.HOME, TraceUtil.INIT_FOLDER_SNAPSHOT);
    let folders: FoldersData[] = FolderManager.getInstance().getSmallFolders() ?? [];
    folders.forEach((folder: FoldersData) => {
      let folderItem: GridLayoutItemInfo = folder.getGridInfo();
      let iconTag: string = SmallFolderIconFileUtil.getIconKey(folderItem.folderId, false);
      let appListTag: string = SmallFolderIconFileUtil.generateAppListKey(false, folder.getMainPageItems());
      let endIconKey: string = SmallFolderIconFileUtil.getIconKey(folderItem.folderId, true);
      let endAppListKey: string = SmallFolderIconFileUtil.generateAppListKey(true, folder.getLastPageItems());
      this.loadIconFromFileSync(iconTag, appListTag);
      this.loadIconFromFileSync(endIconKey, endAppListKey);
    });
    TraceUtil.endTrace(DomainName.HOME, TraceUtil.INIT_FOLDER_SNAPSHOT);
    log.showInfo(TAG, 'end to init snapshot cache: %{public}s', msg);
  }

  private loadIconFromFileSync(iconTag: string, appListTag: string): void {
    if (SmallFolderIconFileUtil.isIconFileExistSync(iconTag)) {
      try {
        this.mFolderCacheMgr.setCache(iconTag, appListTag);
      } catch (error) {
        log.error(TAG, 'loadIconFromPath: image error', error);
      }
    }
  }

  private async deleteFolderIcon(folderItem: GridLayoutItemInfo): Promise<void> {
    if (GridLayoutUtil.isSmallFolder(folderItem)) {
      SmallFolderIconFileUtil.deleteFolderIcon(folderItem.folderId);
    }
  }

  private async initAppIcon(folderId: string, snapInfo: FolderSnapInfo): Promise<void> {
    for (const item of snapInfo.items) {
      try {
        if (CheckEmptyUtils.isEmpty(item)) {
          log.showError(TAG, `initAppIcon error in folder ${folderId}`);
          continue;
        }
        if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
          await ShortcutViewModel.getInstance().getShortcutImageAsync(item as AppItemInfo);
          ShortcutViewModel.getInstance().getShortcutBackgroundImage(item as AppItemInfo);
        }
      } catch (error) {
        log.error(TAG, `initAppIcon bundlename:${item?.bundleName} error: ${error}`);
      }
    }
  }

  /**
   * 刷新首页与尾页截图
   *
   * @param msg 用于DFX日志
   * @param folderId 文件夹id
   */
  private refreshAllFolderIcon(msg: string, folderId: string): void {
    let folder: FoldersData = this.mDataMgr.getFolder(folderId);
    const snapInfoFst: FolderSnapInfo = this.getPageSnapInfo(msg, folderId, folder, false);
    const snapInfoEnd: FolderSnapInfo = this.getPageSnapInfo(msg, folderId, folder, true);
    this.refreshFolderIcon(msg + ' main page', folderId, snapInfoFst);
    this.refreshFolderIcon(msg + ' end page', folderId, snapInfoEnd);
  }

  /**
   * 用于外部调用是否刷新截图
   *
   * @param folderId 文件夹id
   * @param iconSize 当前图标大小
   * @param gridWidth 当前背板大小
   * @param msg 用于DFX日志
   */
  public checkRefreshSnapshot(folderId: string, iconSize: number, gridWidth: number, msg: string): void {
    if (!launcherStatusUtil.isCurrentDesktopVisible(false)) {
      return;
    }
    let folder: FoldersData = this.mDataMgr.getFolder(folderId);
    if (!FolderCommonUtil.isLayout1X1(folder.getGridInfo().area)) {
      return;
    }
    const style: ContractedFolderLayoutStyle =
      ContractedFolderLayoutStyleFactory.getInstance().getStyle(folder.getGridInfo());
    if (style.mFolderAppSize !== iconSize || style.backgroundWidth !== gridWidth) {
      this.refreshSmallFolderIcon(msg, folderId, true);
    }
  }

  /**
   * 用于外部调用来刷新小文件夹首页与尾页截图
   *
   * @param msg 用于DFX日志
   * @param folderId 文件夹id
   * @param forceUpdate 是否强制刷新
   */
  public refreshSmallFolderIcon(msg: string, folderId: string, forceUpdate: boolean = false): void {
    let folder: FoldersData = this.mDataMgr.getFolder(folderId);
    if (!folder.isSmall()) {
      return;
    }
    const snapInfoFst: FolderSnapInfo = this.getPageSnapInfo(msg, folderId, folder, false);
    const snapInfoEnd: FolderSnapInfo = this.getPageSnapInfo(msg, folderId, folder, true);
    this.refreshFolderIcon(msg + ' main page', folderId, snapInfoFst, forceUpdate);
    this.refreshFolderIcon(msg + ' end page', folderId, snapInfoEnd, forceUpdate);
  }

  private getPageSnapInfo(msg: string, folderId: string, folder: FoldersData, isEndPage: boolean): FolderSnapInfo {
    const snapInfo: FolderSnapInfo = new FolderSnapInfo();
    snapInfo.folderId = folderId;
    if (isEndPage) {
      snapInfo.items = folder.getLastPageItems();
      snapInfo.mIsEndPage = true;
      snapInfo.callback =
        (image: image.PixelMap) => this.mLayoutVm.getDataOsrMgr(folderId).setEndPageIcon(msg + ' end page', image);
    } else {
      snapInfo.items = folder.getContractedFolderShowItems();
      snapInfo.mIsEndPage = false;
      snapInfo.callback =
        (image: image.PixelMap) => this.mLayoutVm.getDataOsrMgr(folderId).setFirstPageIcon(msg + ' main page', image);
    }
    return snapInfo;
  }

  public notifySmallFolderUpdate(msg: string, folderId: string): void {
    SmallFolderIconFileUtil.isIconFileExist(folderId).then((isExist) => {
      if (isExist) {
        this.refreshSmallFolderIcon(msg, folderId);
      }
    })
  }

  /**
   * 初始化截图builder
   *
   * @param folderId 文件夹id
   * @param fstBuilder 首页截图builder
   * @param endBuilder 尾页截图builder
   * @param curBuilder 当前页截图builder
   */
  public initSnapCache(folderId: string, fstBuilder: CustomBuilder, endBuilder: CustomBuilder,
    curBuilder: CustomBuilder): void {
    this.setSnapshotBuilder(this.getSnapshotKey(folderId, false), fstBuilder);
    this.setSnapshotBuilder(this.getSnapshotKey(folderId, true), endBuilder);
    this.setSnapshotBuilder(this.getCurSnapshotKey(folderId), curBuilder);
  }

  public setUiContext(uiContext?: UIContext): void {
    this.mUiContext = uiContext;
  }

  /**
   * 缓存每个文件夹的builder，用于截图时使用
   *
   * @param key 截图的key值
   * @param builder builder对象
   */
  public setSnapshotBuilder(key: string, builder: CustomBuilder): void {
    this.mSnapBuilder.set(key, builder);
  }

  /**
   * 根据截图的key值获取文件夹的builder
   *
   * @param key 截图的key值
   * @returns 文件夹builder
   */
  public getSnapshotBuilder(key: string): CustomBuilder {
    return this.mSnapBuilder.get(key);
  }

  /**
   * 删除文件夹builder缓存
   *
   * @param folderId 文件夹id
   */
  public deleteSnapshotBuilder(folderId: string): void {
    this.mSnapBuilder.delete(this.getSnapshotKey(folderId, false));
    this.mSnapBuilder.delete(this.getSnapshotKey(folderId, true));
    this.mSnapBuilder.delete(this.getCurSnapshotKey(folderId));
  }

  /**
   * 获取截图的key值
   *
   * @param folderId 文件夹id
   * @param isEndPage 是否最后一页
   * @returns
   */
  public getSnapshotKey(folderId: string, isEndPage: boolean): string {
    return `${folderId}_${isEndPage}`;
  }

  /**
   * 获取当前显示页截图的key值
   *
   * @param folderId 文件夹id
   * @returns 截图的key值
   */
  public getCurSnapshotKey(folderId: string): string {
    return `${folderId}_refresh`;
  }
}

/**
 * 截图的信息类
 */
export class FolderSnapInfo {
  public mIsEndPage: boolean = false;

  public mIsCurrent: boolean = false;

  public mIsFirstBuild: boolean = false;

  public mEndListRetryTime: number = 0;

  public mShowListRetryTime: number = 0;

  public folderId: string = '';

  public appListTag: string = '';

  public iconTag: string = '';

  public items: GridLayoutItemInfo[] = [];
  /**
   * 用于截图状态变量切换回调
   */
  public callback: (image: image.PixelMap) => void = (image: image.PixelMap) => {};
}