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
  AppModel,
  AppStatus,
  BadgeItemInfo,
  CommonConstants,
  ContractedFolderCommonViewModel,
  ContractedFolderLayoutViewModel,
  ContractedFolderViewModelManager,
  ContractedFolderViewModelType,
  DeleteItemType,
  DisappearLastAppData,
  EventConstants,
  FolderCommonUtil,
  FolderManager,
  FolderOperationFlag,
  FoldersData,
  GridLayoutItemInfo,
  GridLayoutUtil,
  IContractedFolderUninstallViewModel,
  ListenerItemType,
  lockedAppUninstallModel,
  MultiSelectListenerType,
  multiSelectListenManger,
  MultiSelectManager,
  ReceiveEventInfo,
  ShortcutViewModel,
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { UninstallActionLifeCycleStatusManager } from './UninstallActionLifeCycleStatusManager';
import { CommonUtils, LogDomain, Logger } from '@ohos/basicutils/src/main/ets/TsIndex';
import { HiSysEventUtil, localEventManager } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import FeatureConstants from '../../common/constants/FeatureConstants';
import OpenFolderDragHandler from '../../common/OpenFolderDragHandler';

const ONE_HUNDRED: number = 100;
const SMALL_FOLDER_UNINSTALL_DELAY = 20;
const TAG = 'ContractedFolderUninstallViewModel';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
const iconLog: Logger = Logger.getLogHelper(LogDomain.ICON);

/**
 * 文件夹卸载业务处理
 */
export class UninstallViewModel implements IContractedFolderUninstallViewModel {
  private static instance: UninstallViewModel;
  private mUninstallAction: UninstallActionLifeCycleStatusManager = UninstallActionLifeCycleStatusManager.getInstance();
  private mFolderMgr: FolderManager = FolderManager.getInstance();

  /**
   * 多选场景刷新文件夹数据的回调
   */
  private multiSelectListener: MultiSelectListenerType = {
    id: multiSelectListenManger.getListenerId(ListenerItemType.FOLDER_VIEW_MODEL, ''),
    onGather: (): void => {
      const manager = MultiSelectManager.getInstance();
      if (!manager.isInMultiSelect) {
        return;
      }
      const selectedItemMap: Map<GridLayoutItemInfo, GridLayoutItemInfo[]> = manager.getSelectedItemSortByFolder();
      if (selectedItemMap.size === 0) {
        log.showInfo(TAG, 'selectedList is empty');
        return;
      }
      log.showInfo(TAG, 'multi-select gather folder number %{public}d', selectedItemMap.size);
      this.handlerMultiSelectItem('multiSelect gather', selectedItemMap);
    }
  };

  /**
   * 包管理事件处理回调
   */
  private readonly mLocalEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: BadgeItemInfo | DeleteItemType | DeleteItemType[]) => {
      if (event === EventConstants.EVENT_BADGE_UPDATE) {
        iconLog.showInfo(TAG, 'FolderViewModel receive event: %{public}s', event);
      } else {
        log.showInfo(TAG, 'FolderViewModel receive event: %{public}s', event);
      }
      if (event === EventConstants.EVENT_BADGE_UPDATE) {
        this.handleBadgeUpdate(params as BadgeItemInfo);
      } else if (event === EventConstants.EVENT_FOLDER_PACKAGE_REMOVED) {
          const deleteItem: GridLayoutItemInfo = new GridLayoutItemInfo();
          const item: DeleteItemType = params as DeleteItemType;
          deleteItem.bundleName = item.bundleName as string;
          deleteItem.appIndex = item.appIndex;
          deleteItem.typeId = CommonConstants.TYPE_APP;
          this.deleteAfterUninstall('uninstall to refresh folder', [deleteItem]);
      } else if (event === EventConstants.EVENT_FOLDER_PACKAGE_REMOVED_BATCH) {
        const deleteList: GridLayoutItemInfo[] = [];
        const paramItems: DeleteItemType[] = params as DeleteItemType[];
        for (const item of paramItems) {
          let deleteItem: GridLayoutItemInfo = new GridLayoutItemInfo();
          deleteItem.bundleName = item.bundleName ?? '';
          deleteItem.appIndex = item.appIndex;
          deleteItem.typeId = CommonConstants.TYPE_APP;
          deleteList.push(deleteItem);
        }
        this.deleteAfterUninstall('batch uninstall to refresh folder', deleteList);
      }
    }
  };

  private constructor() {
    multiSelectListenManger.register(this.multiSelectListener);
    this.registerFolderUpdateEvent(this.mLocalEventListener);
  }

  public static getInstance(): UninstallViewModel {
    if (!UninstallViewModel.instance) {
      UninstallViewModel.instance = new UninstallViewModel();
      ContractedFolderViewModelManager.getInstance()
        .register(ContractedFolderViewModelType.UNINSTALL, UninstallViewModel.instance);
    }
    return UninstallViewModel.instance;
  }

  /**
   * 卸载加锁应用
   *
   * @param msg DFX的日志打印
   * @param folderId 文件夹id
   * @param itemInfo 文件夹item
   */
  public uninstallLockedItem(msg: string, folderId: string, itemInfo: GridLayoutItemInfo): void {
    log.showInfo(TAG, `uninstall locked app from (${msg})`);
    lockedAppUninstallModel.setUninstallData(itemInfo.bundleName, (): void => {
      log.showInfo(TAG, 'locked app uninstall success callback');
      this.uninstallItem(msg, folderId, itemInfo, false);
    });
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_UNINSTALL_APPLICATION, itemInfo);
  }

  /**
   * 卸载应用
   *
   * @param msg DFX的日志打印
   * @param folderId 文件夹id
   * @param itemInfo 文件夹item
   * @param needToUninstall 应用是否上锁，上锁需要用户选择确认后删除
   */
  public uninstallItem(msg: string, folderId: string, itemInfo: GridLayoutItemInfo,
    needToUninstall: boolean = true): void {
    let folder: FoldersData = this.mFolderMgr.getFolder(folderId);
    if (folder.isEmptyGrid() || !itemInfo) {
      log.showError(TAG, 'uninstall failure, as the folder %{public}s is not found', folderId);
      return;
    }
    this.mFolderMgr.updateUninstallFolderAppItem(itemInfo);
    let restApp: GridLayoutItemInfo[] =
      FolderCommonUtil.filterListAfterUninstall(folder.getGridInfo(), [itemInfo], true);
    let isRelease: boolean = FolderCommonUtil.isNeedReleased(restApp, folderId);
    log.showInfo(TAG, '(%{public}s) uninstall %{public}s in folder %{public}s, remain: %{public}d, release: %{public}s',
      msg, itemInfo.bundleName, folderId, restApp.length, isRelease);
    ContractedFolderLayoutViewModel.getInstance().waitFolderMoveAnimation(() => {
      let isDelete: boolean = itemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON ||
        itemInfo.appStatus !== AppStatus.INSTALLED;
      if (isRelease) {
        this.releaseFolder(msg, folderId, restApp, itemInfo, needToUninstall, isDelete);
      } else {
        this.updateFolder(folderId, restApp, itemInfo, needToUninstall, isDelete);
      }
      if (itemInfo.shortcutId) {
        log.showInfo(TAG, `removeShortcutItem ${itemInfo.bundleName}`);
        ShortcutViewModel.getInstance().deleteShortcutFromBMS({ bundleName: itemInfo.bundleName,
          appIndex: itemInfo.appIndex,
          id: itemInfo.shortcutId });
      }
    });
  }

  /**
   * 通知触发解散动效
   *
   * @param msg 用于DFX日志
   * @param folderId 文件夹id
   * @param flags 动画标识
   */
  public notifyDisbandFolder(msg: string, folderId: string, flags: number = FolderOperationFlag.NONE): void {
    let folder: GridLayoutItemInfo = this.mFolderMgr.getFolder(folderId).getGridInfo();
    if (flags === FolderOperationFlag.REPAIR) {
      this.mUninstallAction.toDisbandedRepair(msg, folder);
      return;
    }
    let disappearData: DisappearLastAppData = this.mFolderMgr.getDisappearLastAppData();
    this.mUninstallAction.toDisbanding(msg, folder, disappearData);
  }

  /**
   * 注册文件夹事件监听
   *
   * @param listener 事件处理监听
   */
  private registerFolderUpdateEvent(listener: ReceiveEventInfo): void {
    localEventManager.registerEventListener(listener, [
      EventConstants.EVENT_BADGE_UPDATE,
      EventConstants.EVENT_FOLDER_PACKAGE_REMOVED,
      EventConstants.EVENT_FOLDER_PACKAGE_REMOVED_BATCH,
      EventConstants.EVENT_FOLDER_ITEM_UPDATE
    ]);
  }

  private generateDisappearFolderData(restAppList: GridLayoutItemInfo[], folderId: string,
    uninstallItem: GridLayoutItemInfo): DisappearLastAppData {
    HiSysEventUtil.reportDissolveFolder(CommonConstants.NUMBER_TWO,
      !GridLayoutUtil.isSmallFolder(this.mFolderMgr.getOpenedFolder()), 'appRemovedInFolder', folderId);
    let hiddenAppKeyName = uninstallItem.keyName;
    let lastItem: GridLayoutItemInfo | undefined = restAppList.length === 1 ? restAppList[0] : undefined;
    return FolderCommonUtil.getDisappearFolderData(folderId, lastItem, hiddenAppKeyName, uninstallItem);
  }

  private releaseFolder(msg: string, folderId: string, restAppList: GridLayoutItemInfo[],
    uninstallItem: GridLayoutItemInfo, isUninstall: boolean, isDelete: boolean): void {
    if (!isDelete) {
      let delayTime: number = GridLayoutUtil.isSmallFolder(this.mFolderMgr.getOpenedFolder()) ?
      FeatureConstants.SMALL_FOLDER_REMOVE_APP_DELAY : FeatureConstants.BIG_FOLDER_REMOVE_APP_DELAY;
      setTimeout(() => this.onAnimationEndToUninstall(isUninstall, uninstallItem), delayTime);
    }
    if (uninstallItem.appStatus !== AppStatus.INSTALLED && uninstallItem.typeId === CommonConstants.TYPE_APP) {
      this.deleteNotInstallItem(uninstallItem);
    }
    this.mFolderMgr.updateOpenFolderLayout(msg, restAppList, false);
    OpenFolderDragHandler.getInstance().resetTranslateZero('releaseFolder');
    const disFolderData: DisappearLastAppData = this.generateDisappearFolderData(restAppList, folderId, uninstallItem);
    this.disbandFolder(msg, folderId, disFolderData);
  }

  private updateFolder(folderId: string, restAppList: GridLayoutItemInfo[], uninstallItem: GridLayoutItemInfo,
    isUninstall: boolean, isDelete: boolean): void {
    // 文件夹不解散的场景：卸载文件夹中应用、快捷方式与分身
    const folder: FoldersData = this.mFolderMgr.getFolder(folderId);
    const delayTime: number = folder.isSmall() ? SMALL_FOLDER_UNINSTALL_DELAY : 0;
    setTimeout(() => {
      if (uninstallItem.appStatus !== AppStatus.INSTALLED && uninstallItem.typeId === CommonConstants.TYPE_APP) {
        this.deleteNotInstallItem(uninstallItem);
      }
      this.mFolderMgr.batchDeleteInFolders('uninstall to updateFolder', [uninstallItem], [folder], true);
      OpenFolderDragHandler.getInstance().resetTranslateZero('by uninstall to updateFolder');
      this.mFolderMgr.updateUninstallFolderAppItem(new GridLayoutItemInfo());
    }, delayTime);

    if (!isDelete) {
      setTimeout(() => this.onAnimationEndToUninstall(isUninstall, uninstallItem), 50);
    }
  }

  /**
   * 删除未安装的应用
   *
   * @param deleteItem 删除元素
   */
  private deleteNotInstallItem(deleteItem: GridLayoutItemInfo): void {
    let isHarmony: boolean = deleteItem.appStatus !== AppStatus.WAIT_FOR_HARMONY;
    let appIndex: number = deleteItem.appIndex ?? 0;
    let bundleName: string = deleteItem.bundleName;
    // 未OpenHarmony化应用需要传映射表的包名
    if (!isHarmony) {
      bundleName = CommonUtils.jsonStrToMap(deleteItem.intent).get('requestBundleName') as string ?? bundleName;
    }
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_DELETE_NOT_UNINSTALL_APP, {
      bundleName: bundleName,
      isRemove: isHarmony,
      appIndex: appIndex
    });
  }

  private disbandFolder(msg: string, folderId: string, disappearFolderData: DisappearLastAppData): void {
    setTimeout(() => {
      const openFolderId: string = this.mFolderMgr.getOpenFolderId();
      let folderItem: GridLayoutItemInfo = this.mFolderMgr.getFolder(folderId).getGridInfo();
      if (openFolderId === '-1') {
        this.mUninstallAction.toDisbanding(msg, folderItem, disappearFolderData);
      } else {
        ContractedFolderCommonViewModel.getInstance().closeFolderWithCallback(folderId, () =>
          this.mUninstallAction.toDisbanding(msg, folderItem, disappearFolderData));
      }
      this.mFolderMgr.updateUninstallFolderAppItem(new GridLayoutItemInfo());
    }, ONE_HUNDRED);
  }

  private onAnimationEndToUninstall(isUninstall: boolean, uninstallItem: GridLayoutItemInfo): void {
    if (isUninstall) {
      let isCardFolder: boolean = GridLayoutUtil.isBigFolder(this.mFolderMgr.getOpenedFolder());
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_UNINSTALL_APPLICATION, uninstallItem);
    } else {
      AppModel.getInstance().onLockedAppUninstallAnimEnd(uninstallItem.bundleName, uninstallItem.appIndex);
    }
  }

  /**
   * 卸载应用后,批量更新文件夹内容
   *
   * @param msg 用于DFX日志定位
   * @param bundleName 删除应用的包名
   * @param appIndex 分身标识
   */
  private deleteAfterUninstall(msg: string, deleteItems: GridLayoutItemInfo[]): void {
    log.showInfo(TAG, '(%{public}s), delete item size %{public}d', msg, deleteItems.length);
    this.mFolderMgr.batchDeleteInFolders(msg, deleteItems, this.mFolderMgr.getFolders(), true);
  }

  private handlerMultiSelectItem(msg: string, selectedItemMap: Map<GridLayoutItemInfo, GridLayoutItemInfo[]>): void {
    let openFolder: GridLayoutItemInfo = this.mFolderMgr.getOpenedFolder();
    let autoAlignFolder: GridLayoutItemInfo[] = [];
    selectedItemMap.forEach((selectAppList: GridLayoutItemInfo[], folder: GridLayoutItemInfo) => {
      const isFolderOpened = openFolder.folderId === folder.folderId;
      const removedUniqueList: string[] = selectAppList.map(item => {
        return GridLayoutUtil.generateUniqueKey(item);
      });
      const cacheFolder: GridLayoutItemInfo = this.mFolderMgr.getFolder(folder.folderId).getGridInfo();
      // 剩余的应用列表
      const lastAppList: GridLayoutItemInfo[] = FolderCommonUtil.getFilterAppListInFolder(cacheFolder,
        (item: GridLayoutItemInfo) => !removedUniqueList.includes(GridLayoutUtil.generateUniqueKey(item)));
      if (FolderCommonUtil.isNeedReleased(lastAppList, folder.folderId)) {
        if (GridLayoutUtil.isOneMultiplyOneItem(folder)) {
          autoAlignFolder.push(folder);
        }
        // 解散场景
        if (isFolderOpened) {
          ContractedFolderCommonViewModel.getInstance().closeFolder(msg, FolderOperationFlag.IMMEDIATELY);
          //小文件消失自动对齐
          log.showInfo(TAG, 'folder execute autoAlign when breaking folder id: %{public}s, folder name: %{public}s',
            openFolder.folderId, openFolder.appName);
          localEventManager.sendLocalEventSticky(EventConstants.EVENT_DELETE_APP_AUTO_ALIGN, autoAlignFolder);
        }
        this.mFolderMgr.removeFolder(msg, cacheFolder, (lastAppList.length === 1 ? lastAppList[0] : undefined));
      } else {
        // 非解散场景
        if (isFolderOpened) {
          this.mFolderMgr.updateOpenFolderLayout(msg, lastAppList, true);
          ContractedFolderCommonViewModel.getInstance().closeFolder(msg, FolderOperationFlag.NONE);
        } else {
          this.mFolderMgr.updateFolderLayoutWithDb(msg, folder.folderId, lastAppList, false);
        }
      }
    });
  }

  private handleBadgeUpdate(badgeInfo: BadgeItemInfo): void {
    const folders: FoldersData[] = this.mFolderMgr.getFolders();
    for (let i = 0; i < folders.length; i++) {
      const folderItems: GridLayoutItemInfo[] = folders[i].getItems();
      let index: number = folderItems.findIndex(item => item.bundleName === badgeInfo.bundleName &&
        item.appIndex === badgeInfo.appIndex && item.typeId === CommonConstants.TYPE_APP);
      if (index !== -1) {
        const item = folderItems[index];
        iconLog.showWarn(TAG, `item ${badgeInfo.bundleName} BadgeUpdate ${badgeInfo.badgeNumber} in ${item.folderId}`);
        item.badgeNumber = badgeInfo.badgeNumber;
        this.mFolderMgr.updateFolderLayoutWithDb('update folder by badgeUpdate', folders[i].getGridInfo().folderId,
          folderItems, false);
        break;
      }
    }
  }
}