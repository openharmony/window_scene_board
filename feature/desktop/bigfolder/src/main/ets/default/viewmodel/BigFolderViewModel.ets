/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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
import Prompt from '@ohos.promptAction';
import {
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
  TraceUtil,
  DomainName,
  ArrayUtils,
  ObjUtil
} from '@ohos/basicutils';
import {
  GlobalContext,
  HiSysEventUtil,
  localEventManager,
  DeviceHelper,
  ResourceManager,
  SceneIdentificationManager,
  SceneState,
  SCBDesktopCacheManager
} from '@ohos/frameworkwrapper';
import { AppTypeUtils, ObjectCopyUtil, desktopUtil } from '@ohos/componenthelper';
import { CurrentMemScene, PerformanceReporter } from '@ohos/frameworkcommon';
import { NumberConstants } from '@ohos/commonconstants';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import {
  PageDesktopModel,
  AppModel,
  ShortcutViewModel,
  CommonDockModel,
  CommonConstants,
  EventConstants,
  FolderViewModel,
  layoutConfigManager,
  RdbStoreManager,
  LayoutViewModel,
  SmallFolderIconFileUtil,
  StyleConstants,
  DockItemInfo,
  FolderReporter,
  NotHarmonyUtil,
  MultiSelectListenerType,
  MultiSelectManager,
  multiSelectListenManger,
  FolderData,
  FolderOperationFlag,
  LauncherLayoutCacheUtil,
  FolderDebug,
  LaunchLayoutCacheManager,
  ReceiveEventInfo,
  scbBlankPositionUtils,
  ListenerItemType,
  ResidentLayoutCacheMgr,
  SmallFolderCacheManager,
  ContractedFolderCommonViewModel,
  BigFolderStyleConfig,
  BadgeItemInfo,
  DeleteItemType
} from '@ohos/launchercommon';
import type { AppItemInfo } from '@ohos/launchercommon';
import FeatureConstants from '../common/constants/FeatureConstants';
import type { OpenFolderData } from '@ohos/launchercommon';
import FolderAddDialogConstant from '../common/constants/FolderAddDialogConstant';
import { GridLayoutItemInfo } from '@ohos/launchercommon';
import type { FolderLayoutStruct } from '@ohos/launchercommon';
import { GridLayoutUtil } from '@ohos/launchercommon';
import type { Callback } from '@ohos.base';
import type { FolderItemInfo } from '@ohos/launchercommon';
import type ServiceExtensionContext from 'application/ServiceExtensionContext';
import { LayoutDescription } from '@ohos/launchercommon';
import type { DragItemFromFolderStartInfo } from '../common/DragItemFromFolderStartInfo';
import { FolderDataModelManager } from '@ohos/launchercommon';
import { BusinessType } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { HashMap } from '@kit.ArkTS';
import { FolderManager } from '@ohos/launchercommon/src/main/ets/folder/next/common/model/FolderManager';

const TAG = 'BigFolderViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const HEXADECIMAL_VALUE = 36;
const CONVERT_RESULT_0 = 'RES: 0, FAILREASON: 0';
const CONVERT_RESULT_1_FAILREASON_2 = 'RES: 1, FAILREASON: 2';
const CONVERT_RESULT_1_FAILREASON_3 = 'RES: 1, FAILREASON: 3';
const FOLDER_OPEN_WAIT_MILLS = 20;
const APP_LAUNCH_TIME = 85;

export class BigFolderViewModel extends FolderViewModel {
  private mFolderReporter: FolderReporter;
  private mPageIndex = 0;
  private mLastAppLaunchTime: number = 0;
  private mGeometryTransitionCount: number = 0;
  private mGeometryTransitionFolderId: string = '';
  private readonly mFolderStyleConfig: BigFolderStyleConfig;
  private readonly mAppTypeUtils = AppTypeUtils.getInstance();
  private mWaitFolderAnimateCallbackList: Callback<void>[] = [];
  private mWaitFolderOpenedCallbackList: Callback<void>[] = [];
  private mWaitFolderMoveAnimate: Callback<void>[] = [];
  private mCloseType: FolderCloseType = FolderCloseType.CLICK_BLANK;
  private desktopContext?: ServiceExtensionContext = GlobalContext.getContext();
  private mLayoutViewModel: LayoutViewModel = LayoutViewModel.getInstance();
  private mFolderOpened: boolean = false;
  private isDropAnimationStatus: boolean = false;
  private autoEnterEditing: boolean = false;
  private isSqueezing: boolean = false;
  private isFolderOpening: boolean = false;
  private isFolderClosing: boolean = false;

  private changeList: HashMap<string, BigFolderComponentChange> = new HashMap<string, BigFolderComponentChange>();
  private openFolderStatusChangeCallBacks: FolderAnimationStatusCallback[] = [];

  public registerBigFolderFlush(folderId: string, bigFolderFlushCallBack: BigFolderComponentChange): void {
    this.changeList.set(folderId, bigFolderFlushCallBack);
  }

  public unRegisterBigFolderFlush(folderId: string): void {
    if (this.changeList.hasKey(folderId)) {
      this.changeList.remove(folderId);
    }
  }

  private readonly mLocalEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: BadgeItemInfo | DeleteItemType | DeleteItemType[] | AppItemInfo) => {
      log.showInfo('FolderViewModel receive event: %{public}s', event);
      let openFolderData: OpenFolderData = FolderData.getInstance().getOpenedFolder() as object as OpenFolderData;
      if (event === EventConstants.EVENT_BADGE_UPDATE) {
        if (openFolderData) {
          openFolderData = this.updateBadge(openFolderData, params as BadgeItemInfo);
          this.refreshFolder(openFolderData);
        }
      } else if (event === EventConstants.EVENT_FOLDER_PACKAGE_REMOVED) {
        let tmpParams = params as DeleteItemType;
        const isContainDeleteApp =
          this.deleteAppFromFolderByUninstall(tmpParams.bundleName ?? '', tmpParams.appIndex ?? 0);
        if (openFolderData && isContainDeleteApp) {
          this.updateFolderAppByInstall(openFolderData, tmpParams.bundleName as string, tmpParams.appIndex ?? 0);
          const copyOpenFolderData: OpenFolderData = {
            layoutInfo: openFolderData.layoutInfo,
            enterEditing: openFolderData.enterEditing,
            folderName: openFolderData.folderName,
            folderId: openFolderData.folderId
          };
          this.refreshFolder(copyOpenFolderData);
        }
      } else if (event === EventConstants.EVENT_FOLDER_PACKAGE_REMOVED_BATCH) {
        let refreshFolderList = [];
        let tmpParams = params as DeleteItemType[];
        for (const item of tmpParams) {
          const isContainDeleteApp = this.deleteAppFromFolderByUninstall(item.bundleName ?? '', item.appIndex ?? 0);
          if (openFolderData && isContainDeleteApp) {
            this.updateFolderAppByInstall(openFolderData, item.bundleName as string, item.appIndex ?? 0);
            this.collectRefreshFolder(openFolderData, refreshFolderList);
          }
        }
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_FOLDER_REFRESH_VIEW, null);
        for (const copyOpenFolderData of refreshFolderList) {
          this.refreshFolder(copyOpenFolderData);
        }
      } else if (event === EventConstants.EVENT_FOLDER_ITEM_UPDATE) {
        openFolderData = this.updateApp(openFolderData, params as AppItemInfo);
        if (openFolderData) {
          const copyOpenFolderData: OpenFolderData = {
            layoutInfo: openFolderData.layoutInfo,
            enterEditing: openFolderData.enterEditing,
            folderName: openFolderData.folderName,
            folderId: openFolderData.folderId
          };
          this.refreshFolder(copyOpenFolderData);
        }
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
      }
    }
  };

  /**
   * 收集需要刷新的文件夹
   *
   * @param openFolderData 文件夹数据
   * @param refreshFolderList 需要刷新的文件夹list
   */
  private collectRefreshFolder(openFolderData: OpenFolderData, refreshFolderList: OpenFolderData[]): void {
    for (const copyOpenFolderData of refreshFolderList) {
      if (copyOpenFolderData.folderId === openFolderData.folderId) {
        copyOpenFolderData.layoutInfo = openFolderData.layoutInfo;
        copyOpenFolderData.enterEditing = openFolderData.enterEditing;
        copyOpenFolderData.folderName = openFolderData.folderName;
        return;
      }
    }
    refreshFolderList.push({
      layoutInfo: openFolderData.layoutInfo,
      enterEditing: openFolderData.enterEditing,
      folderName: openFolderData.folderName,
      folderId: openFolderData.folderId
    });
  }

  private doFolderDisappear: Function =
    (openFolderData: GridLayoutItemInfo, isNeedClose: boolean, lastAppKeyName: string, hiddenAppKeyName: string) => {
      if (isNeedClose) {
        this.closeFolderPending(!GridLayoutUtil.isSmallFolder(openFolderData), () => {
          this.setDisappearFolderData((openFolderData?.folderId) ?? '-1', lastAppKeyName, hiddenAppKeyName);
        });
      } else {
        this.setDisappearFolderData((openFolderData?.folderId) ?? '-1', lastAppKeyName, hiddenAppKeyName);
      }
    };

  private closeByMultiSelect: Function = () => {
    ContractedFolderCommonViewModel.getInstance().closeFolder('multiSelect gather');
  };

  private mLastFolderStatusBeforeTransition: number = 0;

  private dragFromFolderStartInfo: DragItemFromFolderStartInfo | null = null;

  private mFolderDropAnimateWaitCallBack: Callback<void>[] = [];

  private isDragInFolderOpenComponent: boolean = false;

  public dropInFolderOpenComponent(): void {
    this.isDragInFolderOpenComponent = true;
  }

  private multiSelectListener: MultiSelectListenerType = {
    id: multiSelectListenManger.getListenerId(ListenerItemType.FOLDER_VIEW_MODEL, ''),
    onGather: (): void => {
      const manager = MultiSelectManager.getInstance();
      if (!manager.isInMultiSelect) {
        return;
      }
      const selectedItemMap: Map<GridLayoutItemInfo, GridLayoutItemInfo[]> = manager.getSelectedItemSortByFolder();
      if (selectedItemMap.size === 0) {
        log.showInfo('selectedList is empty');
        return;
      }
      let disappearList: Object[] = [];
      // 删除折叠态文件夹内应用
      let deleteFolderIdList: string[] = [];
      // 是否需要刷新布局
      const needUpdateLayout = this.handlerMultiSelectItem(selectedItemMap, disappearList, deleteFolderIdList);
      if (deleteFolderIdList.length > 0) {
        this.mFolderLayout.deleteGridLayoutItemByFolderIdList(deleteFolderIdList, 'from folder by updateFolderSize', true);
      }
      if (needUpdateLayout) {
        this.notifyDesktopUpdateLayout();
      }
    }
  };

  private handlerMultiSelectItem(
    selectedItemMap: Map<GridLayoutItemInfo, GridLayoutItemInfo[]>,
    disappearList: Object[],
    deleteFolderIdList: string[]
  ): boolean {
    let needUpdateLayout: boolean = false;
    const openedFolder: GridLayoutItemInfo = FolderData.getInstance().getOpenedFolder();
    selectedItemMap.forEach((selectAppList: GridLayoutItemInfo[], folder: GridLayoutItemInfo) => {
      const isFolderOpened = openedFolder?.folderId === folder.folderId;
      const removedUniqueList: string[] = selectAppList.map(item => {
        return GridLayoutUtil.generateUniqueKey(item);
      });
      const cacheFolder = this.mFolderLayout.selectGridLayoutItemByItem(folder);
      if (!cacheFolder) {
        return;
      }
      // 剩余的应用列表
      const lastAppList: GridLayoutItemInfo[] = this.layoutInfoToList(cacheFolder).filter(item => {
        return !removedUniqueList.includes(GridLayoutUtil.generateUniqueKey(item));
      });
      if (lastAppList.length === 0) {
        // 解散场景
        if (isFolderOpened) {
          FolderData.getInstance().close('multiSelect gather', FolderOperationFlag.IMMEDIATELY);
        }
        deleteFolderIdList.push(folder.folderId ?? '');
        needUpdateLayout = true;
      } else if (lastAppList.length === 1) {
        this.disPatchFolderWhenOnlyOneAppLeft(isFolderOpened, lastAppList, folder);
        deleteFolderIdList.push(folder.folderId ?? '');
        needUpdateLayout = true;
      } else {
        this.updateOpenedFolderLayout(isFolderOpened, openedFolder, removedUniqueList);
        // 更新角标
        this.updateBadgeNumberInFolder(lastAppList, folder);
        const map: Map<string, GridLayoutItemInfo[][]> = new Map();
        this.updateFolderAppLocation(lastAppList);
        // 剩余的应用列表（分页）
        const lastAppListGroupByPage: GridLayoutItemInfo[][] = this.updateAppLayoutInFolder(lastAppList);
        map.set(folder.folderId ?? '', lastAppListGroupByPage);
        this.mFolderLayout.updateFolderItemLayoutInfoByFolderIdList(map, 'multiSelect Gather', false, false);
        FolderData.getInstance().refreshView('multiSelect gather', folder.folderId);
      }
    });
    return needUpdateLayout;
  }

  private updateBadgeNumberInFolder(lastAppList: GridLayoutItemInfo[], folder: GridLayoutItemInfo): void {
    let badgeNumber: number = 0;
    lastAppList.forEach((item) => {
      if (item.badgeNumber && item.badgeNumber > 0) {
        badgeNumber = badgeNumber + item.badgeNumber;
      }
    });
    this.mFolderLayout.updateBadgeNumberByFolderId(badgeNumber, folder.folderId, 'from folder by updateBadgeNumberInFolder');
  }

  private updateAppLayoutInFolder(appList: GridLayoutItemInfo[]): GridLayoutItemInfo[][] {
    let updatedAppList: GridLayoutItemInfo[][] = [];
    let appListLength = appList.length;
    let maxPage = appList[appListLength - 1].page ?? 0;
    for (let i = 0; i <= maxPage; i++) {
      let updatedAppListInOnePage: GridLayoutItemInfo[] = appList.filter(item => {
        return item.page === i;
      });
      updatedAppList.push(updatedAppListInOnePage);
    }
    return updatedAppList;
  }

  private disPatchFolderWhenOnlyOneAppLeft(
    isFolderOpened: boolean,
    lastAppList: GridLayoutItemInfo[],
    folder: GridLayoutItemInfo
  ): void {
    if (isFolderOpened) {
      ContractedFolderCommonViewModel.getInstance().closeFolder('select gather', FolderOperationFlag.IMMEDIATELY);
    }
    let removeItem: GridLayoutItemInfo = JSON.parse(JSON.stringify(lastAppList[0]));
    removeItem.row = folder.row;
    removeItem.column = folder.column;
    removeItem.page = folder.page;
    const gridLayout: GridLayoutItemInfo = this.createAppLayoutInfo(removeItem);
    this.updateItemPositionFolderToItem(gridLayout, folder);
    this.mFolderLayout.convertFolderSize(gridLayout, false, 'from folder by disPatchFolderWhenOnlyOneAppLeft', true);
    const appListInfo: GridLayoutItemInfo[] = this.mSettingsModel.getAppListInfo();
    const appIndex = appListInfo.findIndex(item => {
      return GridLayoutUtil.checkGridItemEqual(item, removeItem);
    });
    if (appIndex === CommonConstants.INVALID_VALUE) {
      appListInfo.push(removeItem);
    }
    this.mSettingsModel.setAppListInfo(appListInfo);
  }

  private updateOpenedFolderLayout(
    isFolderOpened: boolean,
    openedFolder: GridLayoutItemInfo,
    removedUniqueList: string[]
  ): void {
    // 更新文件夹展开态
    if (isFolderOpened) {
      let openedLayoutInfo: GridLayoutItemInfo[] | undefined = openedFolder.layoutInfo?.flat();
      if (!openedLayoutInfo) {
        return;
      }
      openedLayoutInfo.sort((a, b) =>
      (
        removedUniqueList.includes(GridLayoutUtil.generateUniqueKey(a)) ? 1 : 0) -
        (removedUniqueList.includes(GridLayoutUtil.generateUniqueKey(b)) ? 1 : 0)
      );
      this.updateFolderAppLocation(openedLayoutInfo);
      openedFolder.layoutInfo = this.updateAppLayoutInFolder(openedLayoutInfo);
      setTimeout(this.closeByMultiSelect, 50);
    }
  }

  /**
   * resident local Listener
   */
  private readonly mAddToFolderListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: GridLayoutItemInfo): void => {
      log.showInfo('mAddToFolderListener receive event: %{public}s', event);
      if (event === EventConstants.EVENT_FOLDER_ITEM_ADD) {
        this.addBackToFolder(params);
      }
    }
  };

  public setDragFromFolderStartInfo(startInfo: DragItemFromFolderStartInfo): void {
    this.dragFromFolderStartInfo = startInfo;
  }

  public getDragFromFolderStartInfo(): DragItemFromFolderStartInfo | null {
    return this.dragFromFolderStartInfo;
  }

  public getNewFolderName(): Promise<string> {
    return ResourceManager.getInstance().getStringByIdSync($r('app.string.new_folder_name').id);
  }

  /**
   * 是否正在打开文件夹
   *
   * @returns true: 正在打开文件夹,false: 文件夹已打开或已关闭或正在关闭
   */
  public isOpening(): boolean {
    return this.isFolderOpening;
  }

  /**
   * 是否正在关闭文件夹
   *
   * @returns true: 正在关闭文件夹,false: 文件夹已打开或已关闭或正在打开
   */
  public isClosing(): boolean {
    return this.isFolderClosing;
  }

  /***
   * 快速挤位后迅速关闭大文件夹展开态场景中
   * 记录从落位动效执行完到大文件夹开始关闭转场动效前，存在的页面刷新任务
   * 避免转场过程中，因为落位动效导致界面刷新造成的动效异常
   * */
  public runFolderDropAnimateWaitCallBack(): void {
    log.showInfo('Run dropAnimateWaitCallBack status %{public}s  callBack length %{public}d', this.isDropAnimationStatus,
      this.mFolderDropAnimateWaitCallBack.length);
    if (this.isDropAnimationStatus) {
      this.mFolderDropAnimateWaitCallBack.forEach((callback) => {
        if (callback) {
          callback();
        }
      });
      this.mFolderDropAnimateWaitCallBack = [];
      this.setDropAnimationEnd();
    }
  }

  /***
   * 设置DropAnimation开始
   * */
  public setDropAnimationStart(): void {
    log.showInfo('SetDropAnimationStart ');
    this.isDropAnimationStatus = true;
  }

  /***
   * 设置DropAnimation结束
   * Note：如果不触发buildRefresh界面刷新，等待队列将会不执行，无法执行队列；
   * */
  private setDropAnimationEnd(): void {
    log.showInfo('SetDropAnimationEnd ');
    this.isDropAnimationStatus = false;
  }

  /***
   * 获取DropAnimation状态
   * */
  public getDropAnimationStatus(): boolean {
    log.showInfo('GetDropAnimationStatus  isDropAnimationStatus : %{public}s ', this.isDropAnimationStatus);
    return this.isDropAnimationStatus;
  }

  /***
   * 将callBack添加到等待队列中
   * */
  public pushDropAnimationCallBack(callback?: Callback<void>): void {
    if (this.mFolderDropAnimateWaitCallBack.length === 0 && callback) {
      this.mFolderDropAnimateWaitCallBack.push(callback);
    } else {
      this.mFolderDropAnimateWaitCallBack = [];
      callback?.();
      log.showInfo('Has already push , WaitCallBack.length : %{public}d ', this.mFolderDropAnimateWaitCallBack.length);
    }
  }

  /***
   * 注: 此方法已经废弃
   * 设置app点击启动时间为当前时间
   * */
  public setAppLaunchTime(): void {
    this.mLastAppLaunchTime = new Date().getTime();
  }

  /***
   * 设置文件夹打开自动进入编辑状态
   * */
  public setAutoEnterEditing(autoEnterEditing: boolean): void {
    this.autoEnterEditing = autoEnterEditing;
  }

  /***
   * 设置文件夹打开自动进入编辑状态
   * */
  public getAutoEnterEditing(): boolean {
    return this.autoEnterEditing;
  }

  /***
   * 注: 此方法已经废弃
   * 判断文件夹展开态app是否正在启动
   * */
  public isAppLaunching(): boolean {
    const now = new Date().getTime();
    return this.mLastAppLaunchTime + APP_LAUNCH_TIME > now;
  }

  /***
   * 获取卸载app弹窗提示内容
   * */
  public getUninstallDialogName(appName: string): string {
    let strName = this.getIsPad() ? 'is_delete_form' : 'isUninstall';
    return ResourceManager.getInstance().getStringByName(strName, appName || '');
  }

  /**
   * app卸载时的回调函数，大文件夹打开，卸载app时，需更新
   * @param abilityInfo
   */
  private updateFolderAppByInstall(openFolderData: OpenFolderData, bundleName: string, appIndex: number): void {
    log.showInfo('updateFolderAppByInstall start bundleName = %{public}s appIndex = %{public}d', bundleName, appIndex);
    if (openFolderData.layoutInfo.length === 0) {
      return;
    }
    // 从OpenFolderData中获取不带添加按钮的分页后的layoutInfo信息
    const folderLayoutInfo: GridLayoutItemInfo[][] =
      this.filterFolderPage(this.getAppListInFolder(openFolderData));
    if (folderLayoutInfo.length === 1 && folderLayoutInfo[0].length === 1) {
      log.showInfo('will close folder data');
      openFolderData.folderId = '';
      openFolderData.layoutInfo = [];
    } else {
      openFolderData.layoutInfo = folderLayoutInfo;
    }
  }

  /**
   * app信息更新时的回调函数，例如覆盖安装时
   * @param abilityInfo
   */
  private updateApp(openFolderData: OpenFolderData, abilityInfo: AppItemInfo): OpenFolderData {
    log.showInfo('updateApp start');
    if (openFolderData.layoutInfo.length === 0) {
      return openFolderData;
    }
    // 查找并替换覆盖安装的app
    for (let i = 0; i < openFolderData.layoutInfo.length; i++) {
      const appInfo: GridLayoutItemInfo | undefined = openFolderData.layoutInfo[i].find(item => {
        return item.keyName === abilityInfo.keyName;
      });
      if (appInfo !== undefined && appInfo.bundleName.length > 0) {
        const index = openFolderData.layoutInfo[i].indexOf(appInfo);
        appInfo.appName = abilityInfo.appName;
        appInfo.applicationName = abilityInfo.applicationName;
        appInfo.isSystemApp = abilityInfo.isSystemApp;
        appInfo.isUninstallAble = abilityInfo.isUninstallAble;
        appInfo.appIconId = abilityInfo.appIconId;
        appInfo.appLabelId = abilityInfo.appLabelId;
        appInfo.applicationLabelId = abilityInfo.applicationLabelId;
        appInfo.abilityName = abilityInfo.abilityName;
        appInfo.bundleName = abilityInfo.bundleName;
        appInfo.moduleName = abilityInfo.moduleName;
        appInfo.installTime = abilityInfo.installTime;
        appInfo.badgeNumber = abilityInfo.badgeNumber;
        openFolderData.layoutInfo[i][index] = appInfo;
        break;
      }
    }
    log.showInfo('updateApp end');
    return openFolderData;
  }

  private updateBadge(openFolderData: OpenFolderData, params: BadgeItemInfo): OpenFolderData {
    for (let i = 0; i < openFolderData?.layoutInfo?.length; i++) {
      const appInfo: GridLayoutItemInfo | undefined = openFolderData.layoutInfo[i].find(item => {
        return item.bundleName === params.bundleName && item.appIndex === params.appIndex;
      });
      if (appInfo && appInfo.bundleName.length > 0) {
        const index = openFolderData.layoutInfo[i].indexOf(appInfo);
        appInfo.badgeNumber = params.isShow ? params.badgeNumber : 0;
        openFolderData.layoutInfo[i][index] = appInfo;
        log.showDebug('updateBadge %{public}s badgeNumber %{public}d', appInfo?.bundleName, appInfo?.badgeNumber);
        break;
      }
    }
    return openFolderData;
  }

  private constructor() {
    super();
    this.mFolderStyleConfig = layoutConfigManager.getStyleConfig(BigFolderStyleConfig.APP_LIST_STYLE_CONFIG,
      FeatureConstants.FEATURE_NAME);
    this.registerFolderListener();
    this.mFolderReporter = FolderReporter.getInstance();
    this.registerMultiSelectListener();
  }

  private registerMultiSelectListener(): void {
    multiSelectListenManger.register(this.multiSelectListener);
  }

  /**
   * register residentList folder ADD ITEM Listener
   * local listener for model to model send and receive msg
   */
  registerFolderListener(): void {
    localEventManager.registerEventListener(this.mAddToFolderListener, [
      EventConstants.EVENT_FOLDER_ITEM_ADD,
    ]);
    log.showDebug('local listener on create');
  }

  /**
   * unregister residentList folder ADD ITEM Listener
   */
  unregisterFolderListener(): void {
    localEventManager.unregisterEventListener(this.mAddToFolderListener);
    log.showDebug('local listener on destroy');
  }

  addBackToFolder(appInfo: GridLayoutItemInfo): void {
    let bundleName = appInfo?.bundleName;
    log.showInfo('addBackToFolder start folderId:%{public}s', bundleName);
    if (bundleName === undefined || this.dragFromFolderStartInfo?.bundleName !== bundleName) {
      return;
    }
    let folderId = this.dragFromFolderStartInfo?.folderId;
    if (CheckEmptyUtils.isEmpty(folderId)) {
      log.showInfo('addBackToFolder folderId is null');
      return;
    }
    log.showInfo('addBackToFolder start folderId:%{public}s', folderId);
    let folderItem: GridLayoutItemInfo | DockItemInfo | undefined = undefined;
    folderItem = this.mFolderLayout.selectGridLayoutItemByFolderId(folderId);
    let residentList: DockItemInfo[] | null = null;
    if (folderItem?.layoutInfo === undefined) {
      log.showInfo('addBackToFolder not in gridLayoutInfo');
      residentList = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
      folderItem = residentList.find((item) => item?.keyName === folderItem?.keyName);
    }
    if (!folderItem || folderItem.layoutInfo === undefined) {
      log.showInfo('addBackToFolder not exist');
      this.dragFromFolderStartInfo = null;
      return;
    }
    let layoutTemp: GridLayoutItemInfo[] = folderItem?.layoutInfo?.flat();
    log.showInfo('addBackToFolder layoutTemp length:%{public}d', layoutTemp.length);
    let folderOpenColumn = this.mFolderModel.getFolderOpenLayout()?.column;
    let folderOpenRow = this.mFolderModel.getFolderOpenLayout()?.row;
    let index = (this.dragFromFolderStartInfo.page ?? 0) * folderOpenColumn * folderOpenRow +
      (this.dragFromFolderStartInfo.row ?? 0) * folderOpenColumn + (this.dragFromFolderStartInfo.column ?? 0);
    layoutTemp.splice(index, 0, appInfo);
    layoutTemp.pop();
    this.updateFolderAppLocation(layoutTemp);
    folderItem.layoutInfo = this.translateFolderLayout(layoutTemp);
    this.updateFolderAppList(layoutTemp, folderItem as GridLayoutItemInfo);
    this.dragFromFolderStartInfo = null;
    log.showInfo('addBackToFolder end');
    this.changeList.forEach((callBack: BigFolderComponentChange) => {
      callBack.onListChange(folderItem as Object as FolderItemInfo);
    });
  }

  static getInstance(): BigFolderViewModel {
    if (globalThis.FolderViewModelInstance == null) {
      globalThis.FolderViewModelInstance = new BigFolderViewModel();
      FolderDebug.getInstance();
    }
    return globalThis.FolderViewModelInstance;
  }

  /**
   * return BigFolderStyleConfig
   */
  getFolderStyleConfig(): BigFolderStyleConfig {
    if (!this.mFolderStyleConfig) {
      log.showWarn('FolderStyleConfig is empty,return new layoutConfig');
      return layoutConfigManager.getStyleConfig(BigFolderStyleConfig.APP_LIST_STYLE_CONFIG,
        FeatureConstants.FEATURE_NAME);
    }
    return this.mFolderStyleConfig;
  }

  /**
   * return folderOpenLayoutTable
   */
  getFolderLayoutConfig(): FolderLayoutStruct {
    return this.mFolderModel.getFolderOpenLayout();
  }

  /**
   * convert to BigFolder
   *
   * @param {folderInfo} GridLayoutItemInfo
   * @param {isFromDock} boolean
   * @param {initialFolderItem} GridLayoutItemInfo
   * @return boolean
   */
  public isConvertToBigFolder(originFolderInfo: GridLayoutItemInfo,
    isFromDock: boolean, initialFolderItem: GridLayoutItemInfo): boolean {
    let result: string = 'FIALREASON: 3';
    if (!originFolderInfo) {
      result = 'FAILREASON: 1';
      log.showError('isConvertToBigFolder: folderInfo error');
      return false;
    }
    const folderInfo: GridLayoutItemInfo = ObjectCopyUtil.deepClone(originFolderInfo);
    let folderItemInLayout: GridLayoutItemInfo | undefined =
      this.mFolderLayout.selectGridLayoutItemByFolderId(folderInfo?.folderId);
    let ownerIndex = this.mFolderLayout.selectIndexInLayout(folderItemInLayout);
    if (ownerIndex === -1 && !isFromDock) {
      log.showWarn('ownerIndex is error');
      result = CONVERT_RESULT_1_FAILREASON_3;
      this.mFolderReporter.reportMenuModifyFolderSize(initialFolderItem, result, 'showCardFolder');
      return false;
    }
    let removeLayout: GridLayoutItemInfo | undefined;
    if (ownerIndex >= 0) {
      const delLayout: GridLayoutItemInfo | undefined = this.mFolderLayout.deleteGridLayoutItemByIndex(
        ownerIndex, 'from folder by isConvertToBigFolder', false);
      // 深拷贝待移除的文件夹用于后续小转大失败恢复
      if (delLayout) {
        removeLayout = ObjectCopyUtil.deepClone(delLayout);
      }
    }
    folderInfo.area = [NumberConstants.CONSTANT_NUMBER_TWO, NumberConstants.CONSTANT_NUMBER_TWO];
    let isCurrentOccupied: boolean = true;
    if (!isFromDock) {
      isCurrentOccupied = this.mPageDesktopModel.isCurrentPositionOccupied(folderInfo);
    }
    let needNewPage: boolean = false;
    let curPageIndex = this.mPageDesktopModel.getPageIndex();
    let isFoldExpand = desktopUtil.isFoldExpandStatus();
    let isNeedCheckPadRotate = !isCurrentOccupied && DeviceHelper.isPad();
    log.showInfo(`isNeedCheckPadRotate:${isNeedCheckPadRotate}`);
    if (isCurrentOccupied || isNeedCheckPadRotate) {
      let findEndIndex = curPageIndex + (isFoldExpand ? StyleConstants.DEFAULT_4 : StyleConstants.DEFAULT_2);
      needNewPage = this.mPageDesktopModel.updatePageDesktopLayoutInfo(folderInfo, findEndIndex);
      log.showInfo(`needNewPage: ${needNewPage}, isFoldExpand: ${isFoldExpand}, findEndIndex: ${findEndIndex}`);
      if (isFoldExpand && needNewPage) {
        folderInfo.page = (folderInfo.page ?? 0) + 1;
      }
    }
    let changeItem: GridLayoutItemInfo[] = [];
    let pageCount: number = this.mFolderLayout.selectPageCount();
    let maxPageCount: number = this.mFolderLayout.selectMaxPageCount();
    if (needNewPage) {
      if (pageCount + 1 > maxPageCount) {
        try {
          Prompt.showToast({
            message: ResourceManager.getInstance().getStringByName('add_icon_to_desktop_max')
          });
        } catch (err) {
          log.showError('show add_icon_to_desktop_max message result: failed %{public}d:%{public}s', err.code, err.message);
        }

        // 前面为了方便大文件夹找位把小文件夹从布局缓存里删掉了，如果满18屏了不能转为大文件夹，需要恢复小文件夹布局信息
        if (removeLayout) {
          this.mFolderLayout.insertGridLayoutItemInfo(removeLayout, 'from folder by ConvertToBigFolder', false);
        }
        result = CONVERT_RESULT_1_FAILREASON_2;
        this.mFolderReporter.reportMenuModifyFolderSize(initialFolderItem, result, 'showCardFolder');
        return false;
      } else {
        if (pageCount !== undefined) {
          pageCount += 1;
          if (isFoldExpand) {
            pageCount += 1;
          }
          if (isFoldExpand) {
            this.mFolderLayout
              .updateLayoutAfterAddPage(curPageIndex + 1, 2, 'from folder by ConvertToBigFolder', true, true, [folderInfo]);
          } else {
            this.mFolderLayout
              .updateLayoutAfterAddPage(curPageIndex, 1, 'from folder by ConvertToBigFolder', true, true, [folderInfo]);
          }
        }
        this.mFolderLayout.updatePageCount(pageCount, BusinessType.BUSINESS_FOLDER, true);
      }
    }
    if (!isFromDock) {
      AppStorage.setOrCreate('isFolderChange', true);
    }
    AppStorage.setOrCreate('convertBigFolderArea', [2, 2]);
    AppStorage.setOrCreate('convertItemInfo', folderInfo);
    this.mFolderLayout.convertFolderSize(folderInfo, false, 'from folder by ConvertToBigFolder', true);
    if (needNewPage) {
      log.showInfo('init needNewPage changeItem length is: %{public}d', changeItem.length);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_ADD_MIDDLE_PAGE, null);
    } else {
      log.showInfo('no needNewPage');
      if ((isFoldExpand && folderInfo.page != undefined &&
        this.getIndexInFoldExpand(folderInfo.page) === this.getIndexInFoldExpand(curPageIndex) + 1) ||
        (!isFoldExpand && curPageIndex !== folderInfo.page)) {
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_SHOW_NEXT_PATE, null);
      }
    }
    // 文件夹打点 - 通过菜单方式转换文件夹类型
    result = CONVERT_RESULT_0;
    this.mFolderReporter.reportMenuModifyFolderSize(folderInfo, result, 'showCardFolder');
    // 最后将大文件夹落位的页数同步回去,只同步页数是因为动效坐标是由getIconCenterPosition方法确定的
    originFolderInfo.page = folderInfo.page;
    SmallFolderCacheManager.getInstance().deleteCacheAndFile(folderInfo.folderId);
    return true;
  }

  private getIndexInFoldExpand(index: number): number {
    return Math.floor(index / NumberConstants.CONSTANT_NUMBER_TWO);
  }

  /**
   * convert to SmallFolder
   *
   * @param {folderInfo} GridLayoutItemInfo
   */
  public convertToSmallFolder(folderInfo: GridLayoutItemInfo): void {
    if (!folderInfo) {
      return;
    }
    let result: string = 'FAILREASON: 3';
    let folderItemInLayout: GridLayoutItemInfo = folderInfo;
    let ownerIndex = this.mFolderLayout.selectIndexInLayout(folderItemInLayout);
    if (ownerIndex === -1) {
      log.showWarn('ownerIndex is error');
      return;
    }
    if (ownerIndex >= 0) {
      AppStorage.setOrCreate('convertBigFolderArea', folderItemInLayout?.area);
      this.mFolderLayout.deleteGridLayoutItemByIndex(ownerIndex, 'from folder by convertToSmallFolder', false);
    }
    folderItemInLayout.area = [1, 1];
    AppStorage.setOrCreate('isFolderChange', true);
    AppStorage.setOrCreate('convertItemInfo', folderItemInLayout);
    this.mFolderLayout.convertFolderSize(folderItemInLayout, true, 'from folder by convertToSmallFolder', true);

    // 文件夹打点 - 通过菜单方式转换文件夹类型
    result = CONVERT_RESULT_0;
    this.mFolderReporter.reportMenuModifyFolderSize(folderItemInLayout, result, 'showFolderIcon');
  }

  /**
   * Delete app from folder by draging todo 方法可去掉，未使用
   *
   * @param {any} folderAppList.
   * @param {number} index.
   */
  deleteAppByDraging(folderAppList: GridLayoutItemInfo[], index: number): boolean {
    if (folderAppList.length === 0 || folderAppList.length <= index) {
      return false;
    }
    const dragAppInfo: GridLayoutItemInfo = folderAppList[index];
    const two = 2;
    if (folderAppList.length > two) {
      const needNewPage: boolean = this.mPageDesktopModel.updatePageDesktopLayoutInfo(dragAppInfo);
      log.showDebug('deleteAppByDraging needNewPage: %{public}s', needNewPage);
      if (needNewPage) {
        return false;
      }
    }

    folderAppList.splice(index, 1);
    if (folderAppList.length > 0 && GridLayoutUtil.isAddIcon(folderAppList[folderAppList.length - 1])) {
      folderAppList.pop();
    }
    const folderLayoutInfo = this.filterFolderPage(folderAppList);
    const openFolderData: GridLayoutItemInfo = FolderData.getInstance().getOpenedFolder();
    const removeAppInfos = [dragAppInfo];
    let folderItemInLayout: GridLayoutItemInfo | undefined =
      this.mFolderLayout.selectGridLayoutItemByFolderId(openFolderData.folderId);
    const folderIndex = this.mFolderLayout.selectIndexInLayout(folderItemInLayout);
    if (!folderItemInLayout || folderIndex === CommonConstants.INVALID_VALUE) {
      log.showWarn('deleteAppByDraging layoutInfo find folderIndex is -1');
      return false;
    }
    log.showInfo('deleteAppByDraging layoutInfo find folderIndex:%{public}d', folderIndex);

    if (folderLayoutInfo.length === 1 && folderLayoutInfo[0].length === 1) {
      // delete folder and add app to desktop
      removeAppInfos.push(folderLayoutInfo[0][0]);
      this.mFolderLayout.deleteGridLayoutItemByItemId(folderItemInLayout.folderId, 'from folder by deleteAppByDraging', false);
    } else {
      this.updateBadgeNumber(folderItemInLayout, dragAppInfo);
      openFolderData.layoutInfo = folderLayoutInfo;
    }

    const appListInfo: GridLayoutItemInfo[] = this.mSettingsModel.getAppListInfo();
    for (let i = 0; i < removeAppInfos.length; i++) {
      this.mPageDesktopModel.updatePageDesktopLayoutInfo(removeAppInfos[i]);
      const gridLayout = this.createAppLayoutInfo(removeAppInfos[i]);
      this.mFolderLayout.insertGridLayoutItemInfo(gridLayout, 'from folder by deleteAppByDraging', false);
      appListInfo.push(removeAppInfos[i]);
    }
    this.mSettingsModel.setAppListInfo(appListInfo);
    return true;
  }

  /**
   * create new app layoutInfo
   *
   * @param appInfo
   */
  private createAppLayoutInfo(appInfo: GridLayoutItemInfo): GridLayoutItemInfo {
    const appLayout = {
      infoId: appInfo.infoId,
      bundleName: appInfo.bundleName,
      appName: appInfo.appName,
      abilityName: appInfo.abilityName,
      moduleName: appInfo.moduleName,
      keyName: appInfo.keyName,
      typeId: appInfo.typeId,
      area: appInfo.area,
      page: appInfo.page,
      column: appInfo.column,
      row: appInfo.row,
      appIconId: appInfo.appIconId,
      appLabelId: appInfo.appLabelId,
      downloadProgress: appInfo.downloadProgress,
      appStatus: appInfo.appStatus,
      iconResource: appInfo.iconResource,
      appIndex: appInfo.appIndex,
      shortcutId: appInfo.shortcutId,
      isUninstallAble: appInfo.isUninstallAble,
      intent: appInfo.intent,
      container: CommonConstants.CONTAINER_DESKTOP,
      callerName: appInfo.callerName
    } as GridLayoutItemInfo;
    return appLayout;
  }

  /**
   * pad设备转屏场景需要更新文件夹退化成元素的位置信息
   *
   * @param updateItem
   */
  private updateItemPositionFolderToItem(updateItem: GridLayoutItemInfo, originalFolder: GridLayoutItemInfo): void {
    if (!DeviceHelper.isPad()) {
      log.showWarn('default device no need to update.');
      return;
    }
    let gridLayoutItemList: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance()
      .getAllGridLayoutItemList(BusinessType.BUSINESS_BASIC_DESKTOP);
    let folder: GridLayoutItemInfo | undefined = gridLayoutItemList.find(item => {
      return item.folderId === originalFolder.folderId;
    })
    if (!folder) {
      log.showWarn('folder no find return.');
      return;
    }
    LauncherLayoutCacheUtil.padDeviceItemPositionLog(folder);
    updateItem.row = folder.row;
    updateItem.column = folder.column;
    updateItem.page = folder.page;
    updateItem.landscapeRow = folder.landscapeRow;
    updateItem.landscapeColumn = folder.landscapeColumn;
    updateItem.landscapePage = folder.landscapePage;
    updateItem.portraitRow = folder.portraitRow;
    updateItem.portraitColumn = folder.portraitColumn;
    updateItem.portraitPage = folder.portraitPage;
  }

  /**
   * update folder badgeNumber
   *
   * @param folderLayoutInfo
   * @param dragAppInfo
   */
  private updateBadgeNumber(folderLayoutInfo: GridLayoutItemInfo, dragAppInfo: GridLayoutItemInfo | AppItemInfo): void {
    let folderBadgeNumber = 0;
    if (folderLayoutInfo?.badgeNumber && folderLayoutInfo?.badgeNumber > 0) {
      folderBadgeNumber = folderLayoutInfo.badgeNumber;
      if (dragAppInfo?.badgeNumber && dragAppInfo?.badgeNumber > 0) {
        folderBadgeNumber = folderBadgeNumber - dragAppInfo.badgeNumber;
      }
      folderLayoutInfo.badgeNumber = folderBadgeNumber;
    }
  }

  /**
   * Delete app from open folder
   *
   * @param {any} appInfo.
   */
  deleteAppFromOpenFolder(appInfo: GridLayoutItemInfo): GridLayoutItemInfo {
    log.showInfo('deleteAppFromOpenFolder %{public}s', appInfo?.bundleName);
    // 暂时从FolderData获取，待文件夹拖拽重构后统一从文件夹拖拽数据管理类FolderDragData获取
    let openFolderData: GridLayoutItemInfo =
      FolderData.getInstance().getFolderItemByFolderId(FolderData.getInstance().getOpenFolderId());
    const folderLayoutInfo = this.getFolderLayoutInfo(openFolderData, appInfo);
    // Delete app from the folder
    let folderItemInLayout: GridLayoutItemInfo | undefined =
      this.mFolderLayout.selectGridLayoutItemByFolderId(openFolderData.folderId);
    const folderIndex = this.mFolderLayout.selectIndexInLayout(folderItemInLayout);
    if (!folderItemInLayout || folderIndex === CommonConstants.INVALID_VALUE) {
      log.showWarn('deleteAppFromOpenFolder layoutInfo find folderIndex is -1');
      if(folderLayoutInfo.flat().length <= 1){
        RdbStoreManager.getInstance().deleteItemByInfoId(openFolderData.folderId);
        SmallFolderIconFileUtil.deleteFolderIcon(openFolderData.folderId);
      }
      FolderData.getInstance().refreshView('remove item from dock-folder', openFolderData.folderId);
      return openFolderData;
    }
    log.showInfo('deleteAppFromOpenFolder layoutInfo find folderIndex: %{public}d, openFolderId: %{public}s',
      folderIndex, openFolderData?.folderId);

    const appListInfo: GridLayoutItemInfo[] = this.mSettingsModel.getAppListInfo();
    if (folderLayoutInfo.flat().length <= 1) {
      if (folderLayoutInfo.length === 1 && folderLayoutInfo[0].length === 1) {
        // 文件夹消失动效：将folderId和两个app的bundleName存入AppStore
        this.setDisappearFolderData(openFolderData.folderId, folderLayoutInfo[0][0].keyName, appInfo.keyName);
        // delete from folder and add app to desktop
        const appLayout = this.getAppLayout(folderLayoutInfo, folderItemInLayout);
        // 剩余一个应用需要从文件移除
        this.mFolderLayout.updateLastFolderItemToDesktop(appLayout, 'from folder by deleteAppFromOpenFolder', true);
        const appIndex = appListInfo.findIndex(item => {
          return item.typeId === appLayout.typeId && item.keyName === appLayout.keyName;
        });
        if (appIndex === CommonConstants.INVALID_VALUE) {
          appListInfo.push(folderLayoutInfo[0][0]);
        }
      }
      // 删除文件夹
      FolderDataModelManager.getInstance().deleteFolderInMap(folderItemInLayout.folderId);
      this.mFolderLayout.deleteGridLayoutItemByItemId(folderItemInLayout.folderId, 'from folder by deleteAppFromOpenFolder', true);
      if (AppStorage.get<number>('dragItemType') as number === CommonConstants.DRAG_FROM_FOLDER) {
        HiSysEventUtil.reportDissolveFolder(CommonConstants.NUMBER_TWO, false, 'iconDroppedOut', openFolderData?.folderId); // 文件夹卸载打点 - 桌面文件夹拖出卸载
      }
    } else {
      this.updateBadgeNumber(folderItemInLayout, appInfo);
      openFolderData.layoutInfo = folderLayoutInfo;
      this.mFolderLayout.updateFolderLayoutInfoByFolderId(folderItemInLayout.folderId, folderLayoutInfo, 'from folder by deleteAppFromOpenFolder', false);
    }
    this.mSettingsModel.setAppListInfo(appListInfo);
    FolderData.getInstance().refreshView('remove item from desktop-folder', openFolderData.folderId);
    return openFolderData;
  }

  private getAppLayout(folderLayoutInfo: GridLayoutItemInfo[][], folderItem: GridLayoutItemInfo): GridLayoutItemInfo {
    const appLayout = {
      bundleName: folderLayoutInfo[0][0].bundleName,
      abilityName: folderLayoutInfo[0][0].abilityName,
      moduleName: folderLayoutInfo[0][0].moduleName,
      keyName: folderLayoutInfo[0][0].keyName,
      typeId: folderLayoutInfo[0][0].typeId,
      area: folderLayoutInfo[0][0].area,
      page: folderItem.page,
      appName: folderLayoutInfo[0][0].appName,
      column: folderItem.column,
      row: folderItem.row,
      appStatus: folderLayoutInfo[0][0].appStatus,
      iconResource: folderLayoutInfo[0][0].iconResource,
      container: CommonConstants.CONTAINER_DESKTOP,
      isSelect: folderLayoutInfo[0][0].isSelect,
      infoId: folderLayoutInfo[0][0].infoId,
      id: folderLayoutInfo[0][0].id,
      badgeNumber: folderLayoutInfo[0][0].badgeNumber,
      appIconId: folderLayoutInfo[0][0].appIconId,
      appLabelId: folderLayoutInfo[0][0].appLabelId,
      isSystemApp: folderLayoutInfo[0][0].isSystemApp,
      isUninstallAble: folderLayoutInfo[0][0].isUninstallAble,
      appIndex: folderLayoutInfo[0][0].appIndex,
      shortcutId: folderLayoutInfo[0][0].shortcutId,
      intent: folderLayoutInfo[0][0].intent,
      callerName: folderLayoutInfo[0][0].callerName,
    } as GridLayoutItemInfo;

    // 维测日志 - 拖出app卸载小文件夹，非拖拽图标的所在位置
    log.showDebug('coveredItem: page=%{public}s, column=%{public}s, row=%{public}s', appLayout?.page, appLayout?.column,
      appLayout?.row);
    return appLayout;
  }

  /**
   * todo 拖拽应用到文件夹，展开态使用，展开态接入MVVM后适配
   *
   * @param newLayout 新布局
   * @param folder 文件夹
   */
  async dragAppLeaveFolder(newLayout: GridLayoutItemInfo[], folder: GridLayoutItemInfo): Promise<void> {
    if (!newLayout || !folder || newLayout.length <= 1 ||
    NotHarmonyUtil.isNotHarmonyFolderShouldReleased(folder.folderId, newLayout.length, newLayout)) {
      log.showError('dragAppLeaveFolder param error');
      return;
    }
    if (AppStorage.get(CommonConstants.OPEN_SOURCES)) {
      this.dockFolderAdd(newLayout, folder);
      this.moveAppFromOtherFolders(newLayout, folder);
      this.moveAppFromDesktopToFolder(newLayout);
      return;
    }
    // 重新文件夹分页
    const folderLayoutInfo = this.filterFolderPage(newLayout);
    // 修改了文件统一数据后，反向通知ViewModel层
    folder.layoutInfo = folderLayoutInfo;
    this.mFolderLayout.updateFolderItemLayoutInfoByFolderId(folder.folderId, folderLayoutInfo, newLayout,
      'drag item leave from folder', true);

    this.notifyDesktopUpdateLayout();
    this.updateFolderAppLocation(newLayout);
  }

  /**
   * todo 展开态文件夹依赖该接口调用
   * update folder app list info
   * appInfos是一维数组，folderItem.layoutInfo是二维分页，禁止直接[appInfos]赋值
   *
   * @param {any} appInfos.
   * @param {any} folderItem.
   */
  async updateFolderAppList(appInfos: GridLayoutItemInfo[], folderItem: GridLayoutItemInfo): Promise<void> {
    log.showDebug('updateFolderAppList start');
    let removeFolderApp: GridLayoutItemInfo[] = [];
    let curFolderLayoutInfo: GridLayoutItemInfo[][] = this.getCurFolderLayoutInfo(folderItem);
    let oldPageNum: number = this.getPageCountWithAddIcon(curFolderLayoutInfo);
    removeFolderApp = this.layoutInfoToList(folderItem);
    log.showInfo('updateFolderAppList id:%{public}s container:%{public}s', folderItem?.folderId, folderItem?.container);
    // checked app <= 1
    if (appInfos.length <= 1 &&
    NotHarmonyUtil.isNotHarmonyFolderShouldReleased(folderItem?.folderId, appInfos.length, appInfos)) {
      if (folderItem?.container === CommonConstants.CONTAINER_DOCK) {
        this.updateToReleaseFolderOnDock(appInfos, folderItem, removeFolderApp);
        return;
      }
      this.updateToReleaseFolderOnDesktop(folderItem, removeFolderApp);
    } else {
      if (folderItem?.container === CommonConstants.CONTAINER_DOCK) {
        this.updateFolderAppListOnDock(appInfos, folderItem, removeFolderApp, oldPageNum);
        return;
      }
      this.updateFolderAppListOnDesktop(appInfos, folderItem, removeFolderApp, oldPageNum);
    }
    log.showDebug('updateFolderAppList end');
  }

  // 更新时解散Dock文件夹
  private updateToReleaseFolderOnDock(appInfos: GridLayoutItemInfo[], folderItem: GridLayoutItemInfo,
    removeFolderApp: GridLayoutItemInfo[]): void {
    this.dockAddItem(appInfos, folderItem);
    this.moveAppFromFolderToDesktop(appInfos, removeFolderApp);
    // 文件夹消失动效，不刷新页面
    if (!this.isFolderDisappearing()) {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_RESIDENT_DOCK_ITEM_DELETE, folderItem);
    }
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
    folderItem.layoutInfo = [[]];
  }

  // 更新时解散桌面文件夹
  private updateToReleaseFolderOnDesktop(folderItem: GridLayoutItemInfo, removeFolderApp: GridLayoutItemInfo[]): void {
    this.mFolderLayout.deleteGridLayoutItemByItemId(folderItem.folderId, 'from folder by ReleaseFolder', true);
    folderItem.layoutInfo = [[]];
    this.mPageDesktopModel.updatePageDesktopLayoutInfoForFolder(removeFolderApp);
    let updateItemList: GridLayoutItemInfo[] = [];
    for (let i = 0; i < removeFolderApp.length; i++) {
      const gridLayout = this.createAppLayoutInfo(removeFolderApp[i]);
      // 剩余一个应用时回到桌面，更新位置
      updateItemList.push(gridLayout);
    }
    if (updateItemList.length > 0) {
      this.mFolderLayout.insertGridLayoutItemListFromFolder(updateItemList, 'from folder by ReleaseFolder', true);
    }
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
  }

  // 更新Dock文件夹
  private updateFolderAppListOnDock(appInfos: GridLayoutItemInfo[], folderItem: GridLayoutItemInfo,
    removeFolderApp: GridLayoutItemInfo[], oldPageNum: number): void {
    let pages: number[] = this.getAppFromDesktopPages(appInfos);
    if (this.isDragInFolderOpenComponent) {
      this.isDragInFolderOpenComponent = false;
    } else {
      this.dockFolderAdd(appInfos, folderItem);
    }

    // move app from other folder
    this.moveAppFromOtherFolders(appInfos, folderItem);
    // move apps from desktop to folder
    this.moveAppFromDesktopToFolder(appInfos);
    // move apps from folder to desktop
    this.moveAppFromFolderToDesktop(appInfos, removeFolderApp);
    // move apps from folder to folder
    this.moveAppFromFolderToFolder(appInfos, folderItem);
    // delete blank page
    this.deleteBlankPage(pages);
    // update folder app position and save to db
    this.updateFolderAppLocation(appInfos);
    this.updateFolderAppContainer(appInfos, folderItem.id ?? 0);
    let residentList: DockItemInfo[] = Array.from(ResidentLayoutCacheMgr.getInstance().getAllDockItems());
    let itemIndex: number = residentList.findIndex((item) => {
      return item.keyName === folderItem?.folderId;
    });
    if (itemIndex >= 0) {
      residentList[itemIndex].layoutInfo = this.translateFolderLayout(appInfos);
      let mCopy = ObjectCopyUtil.simpleClone(residentList[itemIndex].layoutInfo);
      folderItem.layoutInfo = mCopy;
    }
    LayoutViewModel.getInstance().updateResidentDockLayout(TAG.concat('_update'), residentList);
    this.checkChangeFolderPage(residentList[itemIndex].layoutInfo, oldPageNum);
    FolderData.getInstance().refreshView('update folder in dock', folderItem?.folderId);
    // 全局刷新保证一次，不容许多次调用
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
    this.updateFolderAppLocation(appInfos);
    RdbStoreManager.getInstance().addInfoToDockFolder(folderItem?.folderId, appInfos);
  }

  // 更新桌面文件夹
  private updateFolderAppListOnDesktop(appInfos: GridLayoutItemInfo[], folderItem: GridLayoutItemInfo,
    removeFolderApp: GridLayoutItemInfo[], oldPageNum: number): void {
    let pages: number[] = this.getAppFromDesktopPages(appInfos);
    // update badgeNumber of folder
    this.updateFolderBadgeNumber(appInfos, folderItem);
    // move app from other folder
    this.moveAppFromOtherFolders(appInfos, folderItem);
    // move apps from desktop to folder
    this.moveAppFromDesktopToFolder(appInfos);
    // move app from dock other folders
    this.moveAppFromDockOtherFolders(appInfos, folderItem);
    // move apps from dock to desktop
    this.moveAppFromDockToFolder(appInfos);
    // move apps from folder to desktop
    this.moveAppFromFolderToDesktop(appInfos, removeFolderApp);
    // move apps from folder to folder
    this.moveAppFromFolderToFolder(appInfos, folderItem);
    // delete blank page
    this.deleteBlankPage(pages);
    // 全局刷新保证一次，不容许多次调用
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
    if (this.mPageDesktopModel.getPageIndex() !== folderItem.page) {
      log.showInfo('page changed, set page index : %{public}d', folderItem.page);
      AppStorage.setOrCreate(desktopUtil.getPageIndex(), folderItem.page);
    }
    let folderLayoutInfo: GridLayoutItemInfo[][] = this.getCurFolderLayoutInfo(folderItem);
    this.checkChangeFolderPage(folderLayoutInfo, oldPageNum);
    this.updateFolderAppLocation(appInfos);
    this.updateFolderAppContainer(appInfos, folderItem.id ?? 0);
    // appInfos 当前留在文件夹内的应用位置更新  -- 可以优化
    this.mFolderLayout.updateFolderItemLayoutInfoByFolderId(folderItem?.folderId,
      this.translateFolderLayout(appInfos), appInfos, 'update folder app list', true, false);
  }

  // 获取从桌面添加到文件夹中的应用所在桌面时的页码集合
  private getAppFromDesktopPages(appInfos: GridLayoutItemInfo[]): number[] {
    let pages: number[] = [];
    for (let appInfo of appInfos) {
      if (appInfo.container === CommonConstants.CONTAINER_DESKTOP && appInfo.page != undefined &&
        !pages.includes(appInfo.page)) {
        pages.push(appInfo.page);
      }
    }
    log.showInfo(`getFromDesktopPages: ${pages}`);
    return pages;
  }

  private updateFolderAppContainer(appInfos: GridLayoutItemInfo[], folderId: number): void {
    appInfos.forEach(appInfo => appInfo.container = folderId);
  }

  /**
   * 文件夹展开态包含添加按钮时的总页数
   * @param layoutInfo 二维数组，文件夹内应用分页数据
   * @returns 文件夹展开态的页数
   */
  private getPageCountWithAddIcon(layoutInfo: GridLayoutItemInfo[][]): number {
    if (CheckEmptyUtils.isEmptyArr(layoutInfo)) {
      log.showWarn('getPageCountWithAddIcon layoutInfo is empty');
      return 0;
    }
    let lastPageItems: GridLayoutItemInfo[] = layoutInfo[layoutInfo.length - 1];
    while (CheckEmptyUtils.isEmptyArr(lastPageItems)) {
      layoutInfo.pop();
      if (layoutInfo.length === 0) {
        log.showWarn('getPageCountWithAddIcon pages all empty');
        return 0;
      }
      lastPageItems = layoutInfo[layoutInfo.length - 1];
    }
    if (GridLayoutUtil.isAddIcon(lastPageItems[lastPageItems.length - 1])) {
      return layoutInfo.length;
    }
    let folderOpenColumn: number = this.mFolderModel.getFolderOpenLayout()?.column;
    let folderOpenRow: number = this.mFolderModel.getFolderOpenLayout()?.row;
    let allCount: number = folderOpenColumn * folderOpenRow;
    return Math.ceil((layoutInfo.flat().length + 1) / allCount);
  }

  /**
   * 检查更新文件夹显示页
   * @param folderLayoutInfo 二维数组，文件夹内应用分页数据
   * @param oldPageNum 更新前文件夹页数
   */
  private checkChangeFolderPage(folderLayoutInfo: GridLayoutItemInfo[][] | undefined, oldPageNum: number): void {
    if (!folderLayoutInfo) {
      return;
    }
    let newPageNum: number = this.getPageCountWithAddIcon(folderLayoutInfo);
    // 更新文件夹页码
    if (oldPageNum > newPageNum && this.getIndex() === oldPageNum - 1) {
      log.showInfo('set openFolderPageIndex %{public}d', (newPageNum - 1));
      this.changeIndex(newPageNum - 1);
    }
  }

  private getCurFolderLayoutInfo(folderItem: GridLayoutItemInfo): Array<GridLayoutItemInfo[]> {
    if (folderItem?.container === CommonConstants.CONTAINER_DOCK) {
      let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
      let dockItem: DockItemInfo | undefined = residentList.find((item) => {
        return item.keyName === folderItem.folderId;
      });
      if (dockItem && dockItem.layoutInfo) {
        return dockItem.layoutInfo;
      }
      return [];
    }
    let folderItemInLayout: GridLayoutItemInfo | undefined =
      this.mFolderLayout.selectGridLayoutItemByFolderId(folderItem.folderId);
    if (folderItemInLayout) {
      return folderItemInLayout.layoutInfo ?? [];
    }
    return [];
  }

  private dockFolderAdd(appInfos: GridLayoutItemInfo[], folderItem: GridLayoutItemInfo): void {
    // 1.从桌面移入：桌面文件夹移入，桌面移入 2.dock栏移入：dock栏文件夹移入，dock元素移入 TODO
    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    //删掉在dock中的应用
    for (const info of appInfos) {
      let index: number = residentList.findIndex((item) => {
        return item.keyName === info.keyName;
      });
      if (index >= 0) {
        residentList.splice(index, 1);
      }
    }
    let newResidentList: DockItemInfo[] = [];
    for (let i = 0; i < residentList.length; i++) {
      let dockItemInfo = residentList[i];
      if (!dockItemInfo?.layoutInfo || dockItemInfo.layoutInfo.length === 0) {
        newResidentList.push(dockItemInfo);
        continue;
      }
      let resident = dockItemInfo;
      if (dockItemInfo.typeId === CommonConstants.TYPE_FOLDER && (dockItemInfo.appId === folderItem.folderId ||
        dockItemInfo.keyName === folderItem.folderId)) {
        resident.layoutInfo = this.translateFolderLayout(appInfos);
        newResidentList.push(resident);
        continue;
      }
      newResidentList.push(dockItemInfo);
    }
  }

  private dockAddItem(appInfos: GridLayoutItemInfo[], folderItem: GridLayoutItemInfo): void {
    if (!appInfos || appInfos.length !== CommonConstants.FOLDER_APP_VALUE) {
      return;
    }

    // appInfos length is 1; add AppItem to the dock.
    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let folderIndex: number = residentList.findIndex((item) => {
      return item?.keyName === folderItem?.keyName;
    });
    log.showInfo('dockAddItem folderIndex: %{public}d', folderIndex);
    if (folderIndex >= 0) {
      residentList.splice(folderIndex, 0, AppModel.getInstance().gridLayoutToDockItem(appInfos[0]));
      LayoutViewModel.getInstance().updateResidentDockLayout(TAG.concat('_addItem'), residentList);
    }
  }

  /**
   * delete blank page
   */
  private deleteBlankPage(desktopPages: number[]): void {
    log.showInfo('deleteBlankPage start');
    let pageCount: number = this.mFolderLayout.selectPageCount();
    for (let i = pageCount - 1; i >= 0; i--) {
      if (desktopPages.includes(i)) {
        PageDesktopModel.getInstance().deleteBlankPageFromLayoutInfo(i);
      }
    }
    log.showInfo('deleteBlankPage end');
  }

  /**
   * get apps in checked appinfos, not in folderAppList
   *
   * @param appInfos
   * @param folderAppList
   */
  getAppRemainInOtherFolder(appInfos: GridLayoutItemInfo[], folderAppList: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    const appInfosRemaining: GridLayoutItemInfo[] = [];
    for (let m = 0; m < folderAppList.length; m++) {
      const appIndex = appInfos.findIndex(item => {
        return item.keyName === folderAppList[m].keyName;
      });
      if (appIndex === CommonConstants.INVALID_VALUE) {
        appInfosRemaining.push(folderAppList[m]);
      }
    }
    return appInfosRemaining;
  }

  /**
   * update badgeNumber of folder
   *
   * @param appInfos
   * @param folderItem
   * @param gridLayoutInfo
   */
  private updateFolderBadgeNumber(appInfos: GridLayoutItemInfo[], folderItem: GridLayoutItemInfo): void {
    let folderItemInLayout: GridLayoutItemInfo | undefined =
      this.mFolderLayout.selectGridLayoutItemByFolderId(folderItem.folderId);
    if (ObjUtil.isInvalid(folderItemInLayout)) {
      log.showWarn('updateFolderBadgeNumber folder not found, folderId: ' + folderItem.folderId);
      return;
    }
    let badgeNumber = 0;
    appInfos.forEach((item) => {
      if (item.badgeNumber && item.badgeNumber > 0) {
        badgeNumber = badgeNumber + item.badgeNumber;
      }
    });
    const folderLayoutInfo = this.filterFolderPage(appInfos);
    folderItem.layoutInfo = folderLayoutInfo;
    folderItem.badgeNumber = badgeNumber;
    this.mFolderLayout.updateBadgeNumberByFolderId(badgeNumber, folderItem.folderId, 'from folder by updateFolderBadge');
  }

  private moveAppFromDockOtherFolders(appInfos: GridLayoutItemInfo[], folderItem: GridLayoutItemInfo): void {
    log.showInfo('moveAppFromDockOtherFolders');
    let rdbResidentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    if (CheckEmptyUtils.isEmptyArr(rdbResidentList)) {
      log.showInfo('dock app list len is 0');
      return;
    }
    let addDockToFolder: GridLayoutItemInfo[] = [];

    // traverse open folder apps
    for (let i = 0; i < appInfos.length; i++) {
      rdbResidentList.forEach((item) => {
        if (item.itemType === CommonConstants.TYPE_FOLDER && item.layoutInfo && item.layoutInfo[0].length > 0) {
          item.layoutInfo[0].forEach((ele: GridLayoutItemInfo) => {
            if (appInfos[i].keyName === ele.keyName) {
              addDockToFolder.push(ele);
            }
          });
        }
      });
    }

    // delete dock folder item
    for (const item of addDockToFolder) {
      AppStorage.setOrCreate('addDockAppFromDialog', true);
      log.showInfo('addDockToFolder item：%{public}s', item.bundleName);
    }

    // update dock folder app
    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let newResidentList: DockItemInfo[] = [];
    residentList.forEach((item) => {
      if (item.typeId === CommonConstants.TYPE_FOLDER &&
        (item.appId === folderItem.folderId || item.keyName === folderItem.folderId)) {
        item.layoutInfo = this.translateFolderLayout(appInfos);
      }
      newResidentList.push(item);
    });
    this.updateFolderAppLocation(appInfos);
    LayoutViewModel.getInstance().updateResidentDockLayout(TAG.concat('_moveApp'), newResidentList);
    RdbStoreManager.getInstance().addInfoToDockFolder(folderItem?.folderId, appInfos);
  }

  /**
   * move app from other folders to folder or to desktop
   *
   * @param appInfos
   * @param gridLayoutInfo
   * @param gridLayoutInfoTemp
   */
  private moveAppFromOtherFolders(appInfos: GridLayoutItemInfo[], folderItem: GridLayoutItemInfo): void {
    let folderLayoutItems: GridLayoutItemInfo[] =
      this.mFolderLayout.selectGridLayoutItemsByType(CommonConstants.TYPE_FOLDER)
      .filter(item => item.folderId !== folderItem.folderId);
    for (const item of folderLayoutItems) {
      const folderAppList = this.layoutInfoToList(item);
      const appInfosRemaining = this.getAppRemainInOtherFolder(appInfos, folderAppList);
      const thisFolderItemIndex = this.mFolderLayout.selectIndexInLayout(item);
      if (thisFolderItemIndex === CommonConstants.INVALID_VALUE || item.folderId === undefined) {
        log.showWarn('moveAppFromOtherFolders layoutInfo find folderIndex is -1');
        continue;
      }

      if (appInfosRemaining.length === 0) {
        // 其它文件内应用被迁移完后需要删除
        this.mFolderLayout.deleteGridLayoutItemByItemId(item.folderId, 'from folder by moveAppFromOtherFolders', true);
      } else if (appInfosRemaining.length <= 1 &&
      NotHarmonyUtil.isNotHarmonyFolderShouldReleased(item.folderId, appInfosRemaining.length,
        appInfosRemaining)) {
        // 剩下的一个应用继承文件夹的位置
        appInfosRemaining[0].page = item.page;
        appInfosRemaining[0].column = item.column;
        appInfosRemaining[0].row = item.row;
        this.mFolderLayout.deleteAndReplaceItem(thisFolderItemIndex, 1, appInfosRemaining[0], 'from folder by moveAppFromOtherFolders', true);
      } else {
        let badgeNumber: number = 0;
        appInfosRemaining.forEach((item) => {
          if (item.badgeNumber && item.badgeNumber > 0) {
            badgeNumber = badgeNumber + item.badgeNumber;
          }
        });
        this.mFolderLayout.updateBadgeNumberByFolderId(badgeNumber, item.folderId, 'from folder by moveAppFromOtherFolders');
        item.layoutInfo = this.filterFolderPage(appInfosRemaining);
        this.mFolderLayout.deleteAndReplaceItem(thisFolderItemIndex, 1, item, 'from folder by moveAppFromOtherFolders', false);
      }
    }
  }


  /**
   * move apps from resident dock to folder
   * @param appInfos of folder
   */
  private async moveAppFromDockToFolder(appInfos: GridLayoutItemInfo[]): Promise<void> {
    if (this.mSettingsModel.getDevice() !== CommonConstants.DEFAULT_DEVICE_TYPE) {
      // pc端不做处理
      return;
    }
    // query rdb data
    let rdbResidentList: DockItemInfo[] = [];
    rdbResidentList = await CommonDockModel.getInstance().querySmartDock();
    if (CheckEmptyUtils.isEmptyArr(rdbResidentList)) {
      return;
    } else {
      let addDockToFolder: DockItemInfo[] = [];
      for (let i = 0; i < appInfos.length; i++) {
        for (let j = 0; j < rdbResidentList.length; j++) {
          if (rdbResidentList[j].itemType === CommonConstants.TYPE_APP &&
            rdbResidentList[j].keyName === appInfos[i].keyName) {
            addDockToFolder.push(rdbResidentList[j]);
            break;
          }
        }
      }

      log.showInfo(`addDockToFolder item length：${addDockToFolder.length}`);
    }
  }

  /**
   * move apps from desktop to folder
   *
   * @param appInfos
   * @param gridLayoutInfo
   * @param gridLayoutInfoTemp
   */
  private moveAppFromDesktopToFolder(appInfos: GridLayoutItemInfo[]): void {
    const appDesktopToFolder: GridLayoutItemInfo[] = this.mFolderLayout.selectGridLayoutItemsByAppList(appInfos);
    if (appDesktopToFolder.length > 0) {
      this.deleteAppLayoutItems(appDesktopToFolder);
    }
  }

  /**
   * move app from folder to desktop
   *
   * @param appInfos 现在的app数组
   * @param removeFolderApp 之前的app数组
   * @param gridLayoutInfoTemp 之前桌面的布局信息
   */
  private moveAppFromFolderToDesktop(appInfos: GridLayoutItemInfo[], removeFolderApp: GridLayoutItemInfo[]): void {
    const appFolderToDesktop: GridLayoutItemInfo[] = [];
    const folderUnInstallItemInfo: GridLayoutItemInfo = FolderManager.getInstance().getUninstallFolderAppItem();
    // 判断哪些app 仍然存在文件夹内
    for (let i = 0; i < removeFolderApp.length; i++) {
      let remainFlag = false;
      for (let j = 0; j < appInfos.length; j++) {
        if (appInfos[j].keyName === removeFolderApp[i].keyName) {
          remainFlag = true;
          log.showInfo('moveAppFromFolderToDesktop remain %{public}s', removeFolderApp[i].bundleName);
          break;
        }
      }
      // 如果文件夹内应用已被卸载，不需要appFolderToDesktop
      if (!remainFlag && removeFolderApp[i].keyName !== folderUnInstallItemInfo?.keyName) {
        appFolderToDesktop.push(removeFolderApp[i]);
      }
    }

    if (appFolderToDesktop.length > 0) {
      let pageCount: number = this.mFolderLayout.selectPageCount();
      let maxPageCount: number = LaunchLayoutCacheManager.getInstance().selectLayoutDescription().maxPage;
      this.findBlankPosition(pageCount, maxPageCount, appFolderToDesktop);
    }
  }

  private setRemainingAppToDockFolder(appInfosRemaining: GridLayoutItemInfo[],
    folderItem: GridLayoutItemInfo, residentList: DockItemInfo[], index: number): void {
    if (appInfosRemaining.length === 0) {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_RESIDENT_DOCK_ITEM_DELETE, folderItem);
    } else {
      const isOneAppLeft = appInfosRemaining.length === 1;
      if (isOneAppLeft) {
        const newAddItemList =
          appInfosRemaining[0] ? [AppModel.getInstance().gridLayoutToDockItem(appInfosRemaining[0])] : [];
        residentList.splice(index, 1, ...newAddItemList);
        RdbStoreManager.getInstance().deleteItemByInfoId(folderItem.folderId);
      } else {
        residentList[index].layoutInfo = this.translateFolderLayout(appInfosRemaining);
        let mCopy = ObjectCopyUtil.simpleClone(residentList[index].layoutInfo);
        folderItem.layoutInfo = mCopy;
      }
    }
  }

  private setRemainingAppToDesktopFolder(appInfosRemaining: GridLayoutItemInfo[],
    folderItem: GridLayoutItemInfo): void {
    if (appInfosRemaining.length === 0) {
      this.mFolderLayout.deleteGridLayoutItemByItemId(folderItem.folderId,
        'from folder by moveAppFromDockFolderToDesktopFolder', true);
      return;
    }
    const isOneAppLeft = appInfosRemaining.length === 1;
    let gridItems: GridLayoutItemInfo[] = this.mFolderLayout.selectGridLayoutItemsByType(CommonConstants.TYPE_FOLDER);
    let gridItemIndex: number = gridItems.findIndex((dockItem) => {
      return dockItem.keyName === folderItem?.folderId;
    });
    if (isOneAppLeft) {
      appInfosRemaining[0].page = folderItem.page;
      appInfosRemaining[0].column = folderItem.column;
      appInfosRemaining[0].row = folderItem.row;
      this.mFolderLayout.deleteAndReplaceItem(gridItemIndex, 1, appInfosRemaining[0],
        'from folder by moveAppFromDockFolderToDesktopFolder', true);
    } else {
      let badgeNumber: number = 0;
      appInfosRemaining.forEach((item) => {
        if (item.badgeNumber && item.badgeNumber > 0) {
          badgeNumber = badgeNumber + item.badgeNumber;
        }
      });
      this.mFolderLayout.updateBadgeNumberByFolderId(badgeNumber, folderItem.folderId,
          'from folder by moveAppFromDockFolderToDesktopFolder');
      folderItem.layoutInfo = this.filterFolderPage(appInfosRemaining);
      this.mFolderLayout.deleteAndReplaceItem(gridItemIndex, 1, folderItem,
          'from folder by moveAppFromDockFolderToDesktopFolder', false);
    }
  }

  private moveAppFromFolderToFolder(appInfos: GridLayoutItemInfo[], folderItem: GridLayoutItemInfo): void {
    let folderItems: Set<GridLayoutItemInfo> = new Set();
    folderItems.add(folderItem);
    let folderLayoutItems: GridLayoutItemInfo[] = this.mFolderLayout.selectAllFolders()
      .filter(item => item.folderId !== folderItem.folderId);
    for (const item of folderLayoutItems) {
      const folderAppList = this.layoutInfoToList(item);
      const appInfosRemaining = this.getAppRemainInOtherFolder(appInfos, folderAppList);
      appInfosRemaining.forEach(() => {
        folderItems.add(item);
      });
      const thisFolderItemIndex = this.mFolderLayout.selectIndexInLayoutForAllApps(item);
      if (thisFolderItemIndex === CommonConstants.INVALID_VALUE || item.folderId === undefined) {
        log.showWarn('moveAppFromFolderToFolder layoutInfo find folderIndex is -1');
        continue;
      }
      let residentList: DockItemInfo[] | undefined = AppStorage.get('residentList');
      let residentFolderIndex: number = residentList?.findIndex((dockItem) => {
        return dockItem.keyName === item?.folderId;
      }) ?? -1;
      if (residentFolderIndex >= 0 && residentList) {
        this.setRemainingAppToDockFolder(appInfosRemaining, item, residentList, residentFolderIndex);
      } else {
        this.setRemainingAppToDesktopFolder(appInfosRemaining, item);
        residentFolderIndex = residentList?.findIndex((item) => {
          return item.keyName === folderItem?.folderId;
        }) ?? -1;
        if (residentFolderIndex >= 0 && residentList) {
          residentList[residentFolderIndex].layoutInfo = this.translateFolderLayout(folderAppList);
          let mCopy = ObjectCopyUtil.simpleClone(residentList[residentFolderIndex].layoutInfo);
          folderItem.layoutInfo = mCopy;
          AppStorage.setOrCreate('residentList', residentList);
        }
      }
    }
    for (let folderItem of folderItems) {
      FolderData.getInstance().refreshView('move apps from folder to folder', folderItem.folderId);
    }
  }

  /**
   * 从当前屏开始找位：
   * 1、当前屏及以后，有空位，更新缓存和数据；
   * 2、无空位，未满18屏，新增一屏；
   * 3、满18屏，从首屏后一屏至当前屏找空位
   * 4、无空位，合并或加入文件夹
   *
   * @param pageCount 当前页数
   * @param maxPageCount 最大页数
   * @param appsAddToDesktop 需要添加到桌面的所有应用
   */
  private findBlankPosition(pageCount: number, maxPageCount: number, appsAddToDesktop: GridLayoutItemInfo[]): void {
    let currentCount: number = pageCount;
    let toDesktopApps: GridLayoutItemInfo[] = [];
    for (let i = 0; i < appsAddToDesktop.length; i++) {
      let itemInfo: GridLayoutItemInfo = appsAddToDesktop[i];
      let needNewPage: boolean = this.mPageDesktopModel.updatePageDesktopLayoutInfo(itemInfo);
      if (needNewPage) {
        if (currentCount < maxPageCount) {
          // 在当前屏后新增一屏
          currentCount++;
          this.mFolderLayout.updatePageCount(currentCount, 'from folder by findBlankPosition', true);
          this.mFolderLayout.updateLayoutAfterAddPage(this.mPageDesktopModel.getPageIndex(), 1,
            'from folder by findBlankPosition', true, false);
        }
      }
      let gridLayout: GridLayoutItemInfo = this.createAppLayoutInfo(itemInfo);
      // 先仅更新缓存，保证后续的找位不会重复
      this.mFolderLayout.insertGridLayoutItemListFromFolder([gridLayout], 'from folder by findBlankPosition', false);
      toDesktopApps.push(gridLayout);
    }
    // 找位完成后再统一更新数据库
    try {
      LauncherLayoutCacheUtil.updateItemToDesktopCallBack(toDesktopApps);
    } catch (error) {
      log.showError('updateItemToDesktop with error %{public}s', error.message);
    }
  }

  /**
   * todo 展开态重构后去除
   * get folder app list
   *
   * @param {array} folderId.
   * @return {array} folderAppList.
   */
  async getFolderAppList(folderId: string): Promise<GridLayoutItemInfo[]> {
    log.showDebug('getFolderAppList start');
    // Get folder app list form the layout info
    let folderItemInLayout: GridLayoutItemInfo | undefined =
      this.mFolderLayout.selectGridLayoutItemByFolderId(folderId);
    let folderAppList: GridLayoutItemInfo[] = folderItemInLayout?.layoutInfo?.flat() ?? [];
    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    // Get folder app list form the dock
    for (const dockItemInfo of residentList) {
      if (!dockItemInfo?.layoutInfo || dockItemInfo.layoutInfo.length === 0) {
        continue;
      }
      if (dockItemInfo.typeId !== CommonConstants.TYPE_FOLDER || dockItemInfo.keyName !== folderId) {
        continue;
      }
      folderAppList = dockItemInfo.layoutInfo.flat();
    }
    if (folderAppList.length > 0 && GridLayoutUtil.isAddIcon(folderAppList[folderAppList.length - 1])) {
      folderAppList.pop();
    }
    AppStorage.setOrCreate('folderAppList', folderAppList);
    return folderAppList;
  }

  /**
   * open folder
   * @param {boolean} isRename.
   * @param {any} folderInfo.
   * @param {boolean} isFromSmall.
   */
  async openFolder(isRename: boolean, folderItem: FolderItemInfo | GridLayoutItemInfo, isFromSmall?: boolean):
    Promise<void> {
    log.showInfo('openFolder start folderId:%{public}s name:%{public}s', folderItem?.folderId, folderItem?.folderName);
    if (!GridLayoutUtil.isFolderItemValid(folderItem)) {
      log.showError('openFolder failed. folderItem invalid');
      return;
    }
    this.setAutoEnterEditing(isRename);
    FolderData.getInstance().open('open folder by user click', folderItem as GridLayoutItemInfo);
  }

  /**
   * 设置文件夹挤位状态
   * @param isSqueezing 当前挤位状态
   */
  public setFolderSqueezeStatus(isSqueezing: boolean): void {
    this.isSqueezing = isSqueezing;
  }

  waitFolderMoveAniamtion(callback?: Callback<void>): void {
    try {
      if (!this.isSqueezing) {
        log.showInfo('waitFolderMoveAnimation callback Immediately');
        callback?.();
      } else {
        if (!callback) {
          return;
        }
        this.mWaitFolderMoveAnimate.push(callback);
      }
    } catch (error) {
      log.error('waitFolderMoveAnimation: callback error', error);
    }
  }

  async excuteAfterMoveAnimation(): Promise<void> {
    if (this.mWaitFolderMoveAnimate !== undefined && this.mWaitFolderMoveAnimate.length > 0) {
      log.showInfo('excuteAfterMoveAnimation finish callback length: %{public}d', this.mWaitFolderMoveAnimate.length);
      try {
        this.mWaitFolderMoveAnimate.forEach((callback) => {
          if (callback) {
            callback();
          }
        });
      } catch (error) {
        log.error('excuteAfterMoveAnimation callback error', error);
      }
    }
    this.mWaitFolderMoveAnimate = [];
    this.isSqueezing = false;
  }

  async waitFolderAnimateFinish(callback?: Callback<void>): Promise<void> {
    try {
      if (this.mGeometryTransitionCount <= 0) {
        log.showDebug('waitFolderAnimateFinish callback Immediately');
        callback?.();
      } else {
        if (!callback) {
          return;
        }
        this.mWaitFolderAnimateCallbackList.push(callback);
      }
    } catch (error) {
      log.error('waitFolderAnimateFinish: callback error', error);
    }
  }

  async waitFolderOpenFinish(callback?: Callback<void>): Promise<void> {
    try {
      if (this.mFolderOpened) {
        log.showDebug('waitFolderOpenFinish callback Immediately');
        callback?.();
      } else {
        if (!callback) {
          return;
        }
        this.mWaitFolderOpenedCallbackList.push(callback);
      }
    } catch (error) {
      log.error('waitFolderOpenFinish: callback error', error);
    }
  }

  // todo 展开态重构后去掉
  setCloseType(type: FolderCloseType): void {
    log.showInfo(`folder close type: ${type}`);
    this.mCloseType = type;
  }

  // todo 展开态重构后去掉
  getCloseType(): string {
    return this.mCloseType;
  }

  async closeFolderPending(isPendingClose: boolean, callback?: Callback<void>): Promise<void> {
    const openFolderId: string | undefined = AppStorage.get('openFolderId');
    try {
      log.showInfo('closeFolderPending, openFolderId=%{public}s', openFolderId);
      if (openFolderId === '-1' && callback !== undefined) {
        callback();
      } else if (callback) {
        this.mWaitFolderAnimateCallbackList.push(callback);
      }
    } catch (error) {
      log.error('closeFolderPending: callback error', error);
    }
    FolderData.getInstance().close('close folder by uninstall to release.');
  }

  /**
   * close folder
   */
  async closeFolder(callback?: Callback<void>, isNeedKeepPageIndex?: boolean,
    isCloseImmediately?: boolean): Promise<void> {
    if (!isNeedKeepPageIndex) {
      this.mPageIndex = 0;
      log.showInfo('No need to keep page index');
      AppStorage.setOrCreate('openFolderPageIndex', this.mPageIndex);
    }
    if (isCloseImmediately === true) {
      FolderData.getInstance().close('close folder by user click immediately', FolderOperationFlag.IMMEDIATELY);
    } else {
      FolderData.getInstance().close('close folder by user click');
    }
    // 关闭文件夹时同时通知文件夹弹窗关闭
    localEventManager.sendLocalEvent(EventConstants.EVENT_EDIT_MODE_TOUCH_DOWN_ITEM);
  }

  /**
   * refresh folder data
   *
   * @param folderItem
   */
  async refreshFolder(folderItem: GridLayoutItemInfo | OpenFolderData): Promise<void> {
    if (!GridLayoutUtil.isFolderItemValid(folderItem)) {
      log.showError('refreshFolder failed. folderItem invalid');
      return;
    }
    folderItem.enterEditing = false;
    if (folderItem.folderId === '') {
      AppStorage.setOrCreate('openFolderStatus', FeatureConstants.OPEN_FOLDER_STATUS_CLOSE);
    } else {
      FolderData.getInstance().refreshView('BigFolderViewModel refreshFolder', folderItem.folderId, false);
    }
    log.showDebug('refreshFolder end');
  }

  private updateTransitionFolderId(folderId: string): void {
    this.mGeometryTransitionFolderId = folderId;
    AppStorage.setOrCreate<string>('geometryTransitionFolderId', folderId);
  }

  /**
   * get device type
   *
   * @return {boolean} isPad.
   */
  getIsPad(): boolean {
    return CommonConstants.PAD_DEVICE_TYPE === AppStorage.get('device');
  }

  private folderRenderGroup(isStart: boolean, isCloseFolderAni: boolean): void {
    if (isStart && isCloseFolderAni) {
      // 文件夹关闭动效开始取消桌面rendergroup
      let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
      SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(false, 'FolderOpenComponentReusable', false, expandStatus);
    }
    if (!isStart && !isCloseFolderAni) {
      // 文件夹打开动效结束添加桌面rendergroup
      let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
      SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(true, 'FolderOpenComponentReusable', false, expandStatus);
    }
  }

  /**
   * start folder transition animation
   *
   * @param boolean isStartAnimation
   * @param string the geometryTransiting folderId
   */
  startTransitionAnimation(isStart: boolean, folderId: string, isCloseFolderAni?: boolean): void {
    log.showDebug('in startTransitionAnimation');
    if (isStart) {
      TraceUtil.startAnimTrace(DomainName.HOME, !isCloseFolderAni ? TraceUtil.CORE_METHOD_OPEN_FOLDER_ANI :
        TraceUtil.CORE_METHOD_CLOSE_FOLDER_ANI);
      log.showInfo('%{public}s start', !isCloseFolderAni ? TraceUtil.CORE_METHOD_OPEN_FOLDER_ANI : TraceUtil.CORE_METHOD_CLOSE_FOLDER_ANI);
    } else {
      TraceUtil.endAnimTrace(DomainName.HOME, !isCloseFolderAni ? TraceUtil.CORE_METHOD_OPEN_FOLDER_ANI :
        TraceUtil.CORE_METHOD_CLOSE_FOLDER_ANI);

      log.showInfo('%{public}s end', !isCloseFolderAni ? TraceUtil.CORE_METHOD_OPEN_FOLDER_ANI : TraceUtil.CORE_METHOD_CLOSE_FOLDER_ANI);
      const folderItem = FolderManager.getInstance().getOpenedFolder();
      FolderReporter.getInstance().reportCloseFolder(isCloseFolderAni, folderItem, folderId); // 文件夹关闭 - 打点
    }
    this.folderRenderGroup(isStart, isCloseFolderAni ?? false);
    let status: number | undefined = AppStorage.get('openFolderStatus');
    if (status !== undefined && status !== FeatureConstants.OPEN_FOLDER_STATUS_TRANSITION_START &&
      status !== FeatureConstants.OPEN_FOLDER_STATUS_TRANSITION_END) {
      log.showInfo('startTransitionAnimation set lastFolderStatusBeforeTransition = %{public}d', status);
      this.mLastFolderStatusBeforeTransition = status;
    }
    if (isStart && this.mGeometryTransitionCount === 0) {
      log.showInfo('startTransitionAnimation start');
      this.updateTransitionFolderId(folderId);
    }

    if (this.mGeometryTransitionCount <= 0) {
      this.mGeometryTransitionCount = 0;
      this.updateTransitionFolderId('');
      log.showInfo('startTransitionAnimation finish');
      return;
    }
  }

  getFolderAnimationCount(): number {
    log.showInfo('getFolderAnimationCount mGeometryTransitionCount:%{public}d', this.mGeometryTransitionCount);
    return this.mGeometryTransitionCount;
  }

  getTransitingFolderId(): string {
    return this.mGeometryTransitionFolderId;
  }

  /**
   * make the applist into folder page
   * 会把appInfos JSON.stringify 拷贝一次
   * @param appInfos
   */
  filterFolderPage(appInfos: GridLayoutItemInfo[]): Array<GridLayoutItemInfo[]> {
    const folderLayoutInfo: GridLayoutItemInfo[][] = [];
    const appListInfo: GridLayoutItemInfo[] = JSON.parse(JSON.stringify(appInfos));
    const openFolderConfig = this.mFolderModel.getFolderOpenLayout();

    const itemCountByPage = openFolderConfig.column * openFolderConfig.row;
    let pageCount = Math.floor(appListInfo.length / itemCountByPage);
    if (appListInfo.length % itemCountByPage !== 0) {
      pageCount = pageCount + 1;
    }
    log.showDebug('filterFolderPage pageCount: %{public}d', pageCount);
    for (let i = 0; i < pageCount; i++) {
      let pageInfo: GridLayoutItemInfo[] = [];
      if (itemCountByPage > appListInfo.length) {
        pageInfo = appListInfo.splice(0, appListInfo.length);
      } else {
        pageInfo = appListInfo.splice(0, itemCountByPage);
      }
      folderLayoutInfo.push(pageInfo);
    }
    // 兼容多选时选择了文件夹内所有应用的场景
    if (folderLayoutInfo.length === 0) {
      folderLayoutInfo.push([]);
    }
    return folderLayoutInfo;
  }

  /**
   * make the folder layoutInfo into list
   *
   * @param folderInfo
   */
  private layoutInfoToList(folderInfo: GridLayoutItemInfo | DockItemInfo): GridLayoutItemInfo[] {
    let appInfo: GridLayoutItemInfo[] = [];
    if (!folderInfo.layoutInfo) {
      return appInfo;
    }
    for (let i = 0; i < folderInfo.layoutInfo.length; i++) {
      for (let j = 0; j < folderInfo.layoutInfo[i].length; j++) {
        if (!GridLayoutUtil.isAddIcon(folderInfo.layoutInfo[i][j])) {
          appInfo = appInfo.concat(folderInfo.layoutInfo[i][j]);
        }
      }
    }
    return appInfo;
  }

  /**
   * create folder info
   *
   * @return {any} folderInfo.
   */
  private async createNewFolderInfo(): Promise<GridLayoutItemInfo> {
    const folderConfig = this.mFolderModel.getBigFolderLayout();
    const folderName = await this.generateFolderName();
    // Create new folder info
    let folderInfo = new GridLayoutItemInfo();
    folderInfo.infoId = new Date().getTime().toString();
    folderInfo.folderId = new Date().getTime().toString();
    folderInfo.folderName = folderName;
    folderInfo.layoutInfo = [];
    folderInfo.typeId = CommonConstants.TYPE_FOLDER;
    folderInfo.area = folderConfig.area;
    folderInfo.badgeNumber = 0;
    folderInfo.page = 0;
    folderInfo.column = 0;
    folderInfo.row = 0;
    return folderInfo;
  }

  /**
   * generate a non duplicate ID
   *
   * @param {string} idLength
   */
  public getUUID(): string {
    log.showDebug('getUUID start');
    let id = Date.now().toString(HEXADECIMAL_VALUE);
    id += Math.random().toString(HEXADECIMAL_VALUE).substr(2);
    return id;
  }

  /**
   * change the open folder page number.
   *
   * @param idx: Page number
   */
  changeIndexOnly(idx: number): void {
    this.mPageIndex = idx;
  }

  /**
   * change the open folder page number.
   *
   * @param idx: Page number
   */
  changeIndex(idx: number): void {
    this.mPageIndex = idx;
    AppStorage.setOrCreate('openFolderPageIndex', this.mPageIndex);
  }

  /**
   * get the open folder page number.
   */
  getIndex(): number {
    return this.mPageIndex;
  }

  /**
   * get addlist dialog's column
   */
  getAddListColumn(): number {
    return this.mFolderModel.getFolderAddAppLayout().column;
  }

  removeShortCut(openFolderData: GridLayoutItemInfo, item: GridLayoutItemInfo): void {
    if (openFolderData.isInDock) {
      this.removeShortCutFromFolderInDock(openFolderData, item);
    } else {
      this.removeShortCutFromFolderInDesktop(openFolderData as OpenFolderData, item);
    }
  }

  /**
   * delete shortCut from folder
   *
   */
  removeShortCutFromFolderInDesktop(openFolderData: OpenFolderData, item: GridLayoutItemInfo): void {
    const openStatus: number | undefined = AppStorage.get('openFolderStatus');
    log.showInfo(`removeShortCutFromFolderInDesktop`);
    this.deleteShortCutFromFolder(item);
    if (openStatus !== FeatureConstants.OPEN_FOLDER_STATUS_CLOSE) {
      this.updateFolderAppByInstall(openFolderData, item.keyName as string, item.appIndex ?? 0);
      const copyOpenFolderData: OpenFolderData = {
        layoutInfo: openFolderData.layoutInfo,
        enterEditing: openFolderData.enterEditing,
        folderName: openFolderData.folderName,
        folderId: openFolderData.folderId
      };
      this.refreshFolder(copyOpenFolderData);
    } else {
      this.updateFolderInfoAfterRemoveShortIconInEditMode(item);
    }
  }

  removeShortCutFromFolderInDock(openFolderData: GridLayoutItemInfo, shortCut: GridLayoutItemInfo, ): void {
    log.showInfo('updateFolderLayoutAfterLeave');
    let tempArr: GridLayoutItemInfo[] = openFolderData.layoutInfo ? openFolderData.layoutInfo.flat() : [];
    let findIndex = tempArr.findIndex(item => LauncherLayoutCacheUtil
      .isSameShortcutApp(shortCut, item.bundleName, item.shortcutId, item.appIndex));
    if (findIndex < 0) {
      log.showError('Leave item is not in folder %{public}s', shortCut.keyName);
      return;
    }

    // 删除数据库中的快捷图标
    try {
      LauncherLayoutCacheUtil.deleteShortcutItemCallBack([shortCut]);
    } catch (error) {
      log.showError('deleteShortcutItem with error %{public}s', error.message);
    }
    tempArr.splice(findIndex, 1);
    let tempOpenFolderData: GridLayoutItemInfo = FolderManager.getInstance().getOpenedFolder();
    if (GridLayoutUtil.isSmallFolder(openFolderData)) {
      log.showDebug('updateFolderLayoutAfterLeave is smallFolder update openFolderData');
      tempOpenFolderData.layoutInfo = this.translateFolderLayout(tempArr.flat());
      AppStorage.set<GridLayoutItemInfo>('openFolderData', tempOpenFolderData);
      FolderManager.getInstance().updateUninstallFolderAppItem(new GridLayoutItemInfo());
    }
    this.updateResidentDockLayout(tempOpenFolderData, openFolderData);
    ShortcutViewModel.getInstance().deleteShortcutFromBMS({ bundleName: shortCut.bundleName,
      appIndex: shortCut.appIndex, id: shortCut.shortcutId });
  }

  /**
   * delete shortCut from folder
   *
   * @param shortCut item
   */
  deleteShortCutFromFolder(item: GridLayoutItemInfo): void {
    this.deleteAppFromOpenFolder(item);
    try {
      LauncherLayoutCacheUtil.deleteShortcutItemCallBack([item]);
    } catch (error) {
      log.showError('deleteShortcutItem with error %{public}s', error.message);
    }
    ShortcutViewModel.getInstance().deleteShortcutFromBMS({ bundleName: item.bundleName,
      appIndex: item.appIndex, id: item.shortcutId });
    FolderManager.getInstance().updateUninstallFolderAppItem(new GridLayoutItemInfo());
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
    log.showDebug('deleteAppFromFolderByUninstall end');
  }

  /**
   * update layoutInfo when only one item in the folder
   *
   * @param shortCut item
   */
  private updateFolderInfoAfterRemoveShortIconInEditMode(item: GridLayoutItemInfo): void {
    let folderItemInLayout: GridLayoutItemInfo | undefined = this.mFolderLayout.selectFolderByContainShortCut(item);
    if (folderItemInLayout) {
      let folderAppList: GridLayoutItemInfo[] = this.layoutInfoToList(folderItemInLayout);
      let folderIndex: number = this.mFolderLayout.selectIndexInLayout(folderItemInLayout);
      folderAppList = folderAppList.filter(appItem => !LauncherLayoutCacheUtil
        .isSameShortcutApp(item, appItem.bundleName, appItem.shortcutId, appItem.appIndex));
      log.showInfo(`updateFolderInfo start: ${folderAppList.length}`);
      if (folderAppList.length === 0) {
        this.mFolderLayout.deleteGridLayoutItemByIndex(folderIndex, 'from folder by RemoveShortIconInEditMode', true);
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
      } else if (folderAppList.length <= 1&&
      NotHarmonyUtil.isNotHarmonyFolderShouldReleased(folderItemInLayout?.folderId, folderAppList.length,
        folderAppList)) {
        const appLayoutInfo: GridLayoutItemInfo = ObjectCopyUtil.deepClone(folderAppList[0]);
        appLayoutInfo.page = folderItemInLayout.page;
        appLayoutInfo.column = folderItemInLayout.column;
        appLayoutInfo.row = folderItemInLayout.row;
        appLayoutInfo.container = CommonConstants.CONTAINER_DESKTOP;
        appLayoutInfo.areaType = CommonConstants.TYPE_AREA_DESKTOP;
        this.mFolderLayout.deleteFolderAndUpdateAppItemToDesktop(
          folderIndex, appLayoutInfo, 'from folder by RemoveShortIconInEditMode', true
        );
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
      } else {
        folderItemInLayout.layoutInfo = this.filterFolderPage(folderAppList);
        this.mFolderLayout.updateFolderLayoutInfoByFolderId(folderItemInLayout.folderId, folderItemInLayout.layoutInfo,
          'from folder by RemoveShortIconInEditMode', false);
        FolderData.getInstance().refreshView(`updateFolderInfoAfterRemoveShortIconInEditMode`, folderItemInLayout.folderId);
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
      }
    }
  }

  /**
   * delete app from folder
   *
   * @param bundleName
   */
  deleteAppFromFolderByUninstall(bundleName: string, appIndex: number): boolean {
    log.showDebug('deleteAppFromFolderByUninstall start');
    let isContainDeleteApp = false;
    let folderItemInLayoutList: GridLayoutItemInfo[] = this.mFolderLayout.selectFolderByContainApp(bundleName);
    RdbStoreManager.getInstance().deleteInfoByBundle(bundleName, undefined, appIndex, false);
    folderItemInLayoutList.forEach((folderItemInLayout: GridLayoutItemInfo) => {
      let folderAppList: GridLayoutItemInfo[] = this.layoutInfoToList(folderItemInLayout);
      folderAppList =
        folderAppList.filter(appItem => appItem.bundleName !== bundleName || appItem.appIndex !== appIndex);
      folderItemInLayout.layoutInfo = this.filterFolderPage(folderAppList);
      FolderData.getInstance().refreshView('deleteAppFromFolderByUninstall', folderItemInLayout.folderId, false);
      this.checkReleaseFolderIfNeeded(folderItemInLayout, folderAppList);
    });

    let dockDataList = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    for (let i = 0; i < dockDataList.length; i++) {
      if (isContainDeleteApp) {
        break;
      }
      let dockDataItem = dockDataList[i] ?? new DockItemInfo();
      if (dockDataItem.typeId !== CommonConstants.TYPE_FOLDER) {
        continue;
      }
      let folderAppList = this.layoutInfoToList(dockDataItem);
      for (let m = 0; m < folderAppList?.length; m++) {
        if (folderAppList[m]?.bundleName !== bundleName || folderAppList[m]?.appIndex !== appIndex) {
          continue;
        }
        RdbStoreManager.getInstance().deleteInfoByBundle(bundleName, undefined, appIndex);
        folderAppList.splice(m, 1);
        if ((folderAppList.length <= 1) &&
        NotHarmonyUtil.isNotHarmonyFolderShouldReleased(dockDataItem?.appId, folderAppList.length,
          folderAppList)) {
          let gridItemInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockDataList[i]);
          gridItemInfo.folderId = gridItemInfo.infoId;
          this.deleteFolder(gridItemInfo);
          FolderData.getInstance().close('uninstall to release folder on dock', FolderOperationFlag.IMMEDIATELY);
        }
        isContainDeleteApp = true;
        break;
      }
    }
    FolderManager.getInstance().updateUninstallFolderAppItem(new GridLayoutItemInfo());
    log.showDebug('deleteAppFromFolderByUninstall end');
    return isContainDeleteApp;
  }

  private checkReleaseFolderIfNeeded(folderItemInLayout: GridLayoutItemInfo,
    folderAppList: GridLayoutItemInfo[]): void {
    let folderIndex: number = this.mFolderLayout.selectIndexInLayout(folderItemInLayout, false);
    // 需要解散的文件夹如果还剩余一个应用时需要替换为剩余图标，避免桌面刷新时重新找位，若没有剩余应用则直接删除数据
    if ((folderAppList.length <= 1) && folderIndex >= 0 &&
    NotHarmonyUtil.isNotHarmonyFolderShouldReleased(folderItemInLayout.folderId, folderAppList.length,
      folderAppList)) {
      // 仅桌面解散逻辑，当前桌面缓存有一份异常的dock布局缓存，暂做保护处理，避免数据刷新异常。默认在桌面上
      if (!folderItemInLayout.container || folderItemInLayout.container === CommonConstants.CONTAINER_DESKTOP) {
        this.releaseFolder(folderAppList, folderIndex, folderItemInLayout);
      }
      FolderData.getInstance().close('uninstall to release folder', FolderOperationFlag.IMMEDIATELY);
    }
  }

  private releaseFolder(folderAppList: GridLayoutItemInfo[], folderIndex: number,
    folderItemInLayout: GridLayoutItemInfo): void {
    let addToDesktopElement: GridLayoutItemInfo | null = CheckEmptyUtils.isEmptyArr(folderAppList) ? null :
      folderAppList[0];
    // 如果解散到桌面,DH应用是安装状态, 但是在AppModel里面不存在，收到移除广播则不加桌,避免时序问题,只做清理文件夹的动作
    if (addToDesktopElement && this.releaseFolderAddDhAppToDesktop(addToDesktopElement)) {
      log.showWarn('releaseFolder deliver  folder bundleName = %{public}s',
        addToDesktopElement.bundleName);
      this.mFolderLayout.deleteFolderAndUpdateAppItemToDesktop(folderIndex, addToDesktopElement,
        BusinessType.BUSINESS_FOLDER_UNINSTALL, false);
      this.deleteFolder(folderItemInLayout);
      return;
    }
    this.mFolderLayout.deleteFolderAndUpdateAppItemToDesktop(folderIndex, addToDesktopElement,
      BusinessType.BUSINESS_FOLDER_UNINSTALL, true);
  }

  private releaseFolderAddDhAppToDesktop(addToDesktopElement: GridLayoutItemInfo): boolean {
    return false;
  }

  removeFolderAfterUninstallIfNeeded(openFolderData: GridLayoutItemInfo, folderAppList: GridLayoutItemInfo[],
    uninstallAppKeyName: string): void {
    this.removeFolderAfterUninstall(openFolderData, folderAppList, uninstallAppKeyName, true);
  }

  removeFolderAfterUninstallWithoutClose(openFolderData: GridLayoutItemInfo, folderAppList: GridLayoutItemInfo[],
    uninstallAppKeyName: string): void {
    this.removeFolderAfterUninstall(openFolderData, folderAppList, uninstallAppKeyName, false);
  }

  private removeFolderAfterUninstall(openFolderData: GridLayoutItemInfo, folderAppList: GridLayoutItemInfo[],
    uninstallAppKeyName: string, isNeedClose: boolean): void {
    log.showInfo('removeFolderAfterUninstallIfNeeded length: %{public}d, openFolderId: %{public}s',
      folderAppList.length, openFolderData?.folderId);
    const ONE_HUNDRED: number = 100;
    if (folderAppList.length - 1 <= 1) {
      log.showInfo('removeFolderAfterUninstallIfNeeded length <= 2');
      if (!PageDesktopModel.getInstance().isInDock(openFolderData?.bundleName, openFolderData?.abilityName,
        openFolderData?.appIndex)) {
        HiSysEventUtil.reportDissolveFolder(CommonConstants.NUMBER_TWO, !GridLayoutUtil.isSmallFolder(openFolderData),
          'appRemovedInFolder', openFolderData?.folderId);
      }
      let hiddenAppKeyName = uninstallAppKeyName;
      let lastAppKeyName = folderAppList[0]?.keyName !== uninstallAppKeyName ? folderAppList[0]?.keyName :
        folderAppList[1]?.keyName;
      setTimeout(this.doFolderDisappear, ONE_HUNDRED, openFolderData, isNeedClose, lastAppKeyName, hiddenAppKeyName);
    }
  }

  private isEnoughDropSpace(folderAppList: GridLayoutItemInfo[], msg: string | Resource): boolean {
    if (folderAppList.length > 2) {
      const gridConfig = this.mSettingsModel.getGridConfig();
      const column = gridConfig.column;
      const row = gridConfig.row;
      let itemCount: number = this.mFolderLayout.selectAllOccupiedSpace();
      let maxPage: number = this.mFolderLayout.selectMaxPageCount();
      if (itemCount > column * row * maxPage) {
        try {
          Prompt.showToast({
            message: msg
          });
        } catch (error) {
          log.error('removeAppOutOfFolder: Prompt error', error);
        }
        return false;
      }
    }
    return true;
  }

  /**
   * drag app from folder to desktop
   *
   * @param {any} appInfo.
   */
  dragAppFromFolderToDeskTop(removeAppList: GridLayoutItemInfo[],
    openFolderData: OpenFolderData | GridLayoutItemInfo): void {
    const folderAppList: GridLayoutItemInfo[] = this.getAppListInFolder(openFolderData);
    if (!this.isEnoughDropSpace(folderAppList, $r('app.string.add_icon_to_desktop_max'))) {
      log.showInfo('not enough space to drop item');
      return;
    }
    removeAppList.forEach(item => this.deleteAppFromFolderAppList(item, folderAppList));
    const folderLayoutInfo: GridLayoutItemInfo[][] = this.filterFolderPage(folderAppList);
    const appListInfo: GridLayoutItemInfo[] = this.mSettingsModel.getAppListInfo();
    let folderItemInLayout: GridLayoutItemInfo | undefined =
      this.mFolderLayout.selectGridLayoutItemByFolderId(openFolderData.folderId);
    const folderIndex = this.mFolderLayout.selectIndexInLayout(folderItemInLayout);
    if (!folderItemInLayout || folderIndex === CommonConstants.INVALID_VALUE) {
      log.showWarn('dragAppFromFolderToDeskTop layoutInfo find folderIndex is -1');
      // 删除dock区文件夹，不涉及desktop逻辑
      if (folderLayoutInfo.length === 1 && folderLayoutInfo[0].length === 1) {
        RdbStoreManager.getInstance().deleteItemByInfoId(openFolderData.folderId);
        SmallFolderIconFileUtil.deleteFolderIcon(openFolderData.folderId);
      }
      return;
    }
    log.showInfo('find folderIndex:%{public}d removeAppSize:%{public}d folderAppList.length: %{public}d, openFolderId: ${public}s',
      folderIndex, removeAppList.length, folderAppList.length, openFolderData?.folderId);
    this.updateDesktopAppList(folderLayoutInfo, openFolderData, removeAppList, folderItemInLayout, appListInfo);
  }

  private updateDesktopAppList(folderLayoutInfo: GridLayoutItemInfo[][],
    openFolderData: GridLayoutItemInfo | OpenFolderData, appInfo: GridLayoutItemInfo[],
    folderItemInLayout: GridLayoutItemInfo, appListInfo: GridLayoutItemInfo[]): void {
    if (folderLayoutInfo.length === 1 &&
      folderLayoutInfo[0].length <= 1 &&
    (folderLayoutInfo[0].length <= 1) &&
    NotHarmonyUtil.isNotHarmonyFolderShouldReleased(openFolderData.folderId, folderLayoutInfo[0].length,
      folderLayoutInfo[0])
    ) {
      log.showInfo('length %{public}d', folderLayoutInfo[0].length);
      // 多选时不启用文件夹自身的消失动效
      if (!MultiSelectManager.getInstance().isInMultiSelect && folderLayoutInfo[0].length > 0) {
        // 文件夹消失动效：将folderId和两个app的bundleName存入AppStore
        this.setDisappearFolderData(openFolderData.folderId, folderLayoutInfo[0][0].keyName, appInfo[0].keyName);
      }
      // delete folder and add app to desktop
      this.mFolderLayout.deleteGridLayoutItemByItemId(folderItemInLayout.folderId, 'from folder by updateDesktopAppList', true);
      if (folderLayoutInfo[0].length === 1) {
        //文件夹内剩下一个
        let removeItem: GridLayoutItemInfo = JSON.parse(JSON.stringify(folderLayoutInfo[0][0]));
        // last app set row and column to origin
        removeItem.row = folderItemInLayout.row;
        removeItem.column = folderItemInLayout.column;
        removeItem.page = folderItemInLayout.page;

        const gridLayout: GridLayoutItemInfo = this.createAppLayoutInfo(removeItem);
        gridLayout.landscapeRow = folderItemInLayout.landscapeRow;
        gridLayout.landscapeColumn = folderItemInLayout.landscapeColumn;
        gridLayout.landscapePage = folderItemInLayout.landscapePage;
        gridLayout.portraitRow = folderItemInLayout.portraitRow;
        gridLayout.portraitColumn = folderItemInLayout.portraitColumn;
        gridLayout.portraitPage = folderItemInLayout.portraitPage;
        log.showInfo('createAppLayoutInfo: %{public}s column: %{public}d row: %{public}d',
          gridLayout.bundleName, gridLayout.column, gridLayout.row);
        this.mFolderLayout.convertFolderSize(gridLayout, false, 'from folder by updateDesktopAppList', true);
        const appIndex = appListInfo.findIndex(item => {
          return GridLayoutUtil.checkGridItemEqual(item as Object as GridLayoutItemInfo, removeItem);
        });
        if (appIndex === CommonConstants.INVALID_VALUE) {
          appListInfo.push(removeItem);
        }
      } else {
        // 文件夹解散时更新当前拖拽元素的container和page信息
        appInfo.forEach((removeAppItemInfo: GridLayoutItemInfo) => {
          removeAppItemInfo.container = CommonConstants.CONTAINER_DESKTOP;
          removeAppItemInfo.areaType = CommonConstants.TYPE_AREA_DESKTOP;
          removeAppItemInfo.page = (openFolderData as GridLayoutItemInfo).page;
        });
      }
      HiSysEventUtil.reportDissolveFolder(StyleConstants.DEFAULT_2,
        !GridLayoutUtil.isSmallFolder(openFolderData as GridLayoutItemInfo),
        'iconDroppedOut', openFolderData?.folderId);
      openFolderData = new GridLayoutItemInfo();
    } else {
      if (folderItemInLayout) {
        appInfo.forEach(item => this.updateBadgeNumber(folderItemInLayout, item));
        openFolderData.layoutInfo = folderLayoutInfo;
        this.mFolderLayout.updateFolderLayoutInfoByFolderId(folderItemInLayout.folderId, folderLayoutInfo,
          'from folder by updateDesktopAppList', false);
      }
    }
    if (!this.getIsPad()) {
      this.mSettingsModel.setAppListInfo(appListInfo);
    }
    log.showInfo('dragAppFromFolderToDeskTop end');
  }

  /**
   * update folderData and openFolderStatus
   *
   * @param openFolderData
   */
  private updateOpenFolderStatus(openFolderData: OpenFolderData): void {
    log.showInfo('updateOpenFolderStatus change openFolderData');
    FolderData.getInstance().refreshView('useless scene', openFolderData.folderId);
    if (openFolderData.folderId === '') {
      AppStorage.setOrCreate('openFolderStatus', FeatureConstants.OPEN_FOLDER_STATUS_CLOSE);
    }
  }

  /**
   * delete appInfo from folder
   *
   * @param appInfo
   * @param folderAppList
   */
  private deleteAppFromFolderAppList(appInfo: GridLayoutItemInfo, folderAppList: GridLayoutItemInfo[]): void {
    const appIndex = folderAppList.findIndex(item => {
      return item.keyName === appInfo.keyName;
    });
    if (appIndex >= 0) {
      folderAppList.splice(appIndex, 1);
    }
  }

  /**
   * get folder's appList from appStorage
   *
   * @param openFolderData
   */
  public getAppListInFolder(openFolderData: OpenFolderData | GridLayoutItemInfo): GridLayoutItemInfo[] {
    let folderAppList: GridLayoutItemInfo[] = [];
    if (!openFolderData || !openFolderData.layoutInfo) {
      log.showWarn('open folder or its layout shouldn`t be null, do nothing ...');
      return folderAppList;
    }
    for (let i = 0; i < openFolderData.layoutInfo.length; i++) {
      folderAppList = folderAppList.concat(openFolderData.layoutInfo[i]);
    }
    folderAppList = folderAppList.filter(item => !GridLayoutUtil.isAddIcon(item));
    return folderAppList;
  }

  /**
   * get folder layoutInfo after delete appInfo from folder
   *
   * @param openFolderData
   * @param appInfo
   */
  private getFolderLayoutInfo(openFolderData: OpenFolderData | GridLayoutItemInfo,
    appInfo: GridLayoutItemInfo): GridLayoutItemInfo[][] {
    let folderAppList = this.getAppListInFolder(openFolderData);
    const index = folderAppList.findIndex(item => {
      return GridLayoutUtil.generateUniqueKey(item) === GridLayoutUtil.generateUniqueKey(appInfo);
    });
    if (index >= 0) {
      folderAppList.splice(index, 1);
    }
    return this.filterFolderPage(folderAppList);
  }

  /**
   * dock栏满 文件夹恢复原始布局
   */
  public revertLastFolderData(): void {
    let lastOpenFolderData: GridLayoutItemInfo | undefined = AppStorage.get('lastOpenFolderData');
    if (!lastOpenFolderData || !lastOpenFolderData.layoutInfo) {
      return;
    }
    this.updateFolderAppList(lastOpenFolderData.layoutInfo.flat().filter(
      item => !GridLayoutUtil.isAddIcon(item) ?? []), lastOpenFolderData);
  }

  private deleteFolder(folderItem: GridLayoutItemInfo): void {
    log.showDebug('deleteFolder folderId =  %{public}s', folderItem.folderId);
    FolderDataModelManager.getInstance().deleteFolderInMap(folderItem.folderId);
    RdbStoreManager.getInstance().deleteItemByInfoId(folderItem.folderId);
    if (GridLayoutUtil.isSmallFolder(folderItem)) {
      SmallFolderIconFileUtil.deleteFolderIcon(folderItem.folderId);
    }
  }

  /**
   * 计算图标在文件夹内的位置
   * @param layoutInfo 文件夹布局
   * @param item 拖拽图标
   * @returns [row, column, pageIndex]
   */
  public calculateArea(layoutInfo: GridLayoutItemInfo[][] | undefined, item: GridLayoutItemInfo): number[] {
    let column: number = this.getFolderLayoutConfig().column;
    // rst 中每列的含义： appIndex , appColumn , appRow
    let rst = [-1, -1, -1];
    if (!layoutInfo) {
      log.showError('calculateArea: layoutInfo error');
      return rst;
    }
    for (let j = 0; j < layoutInfo.length; j++) {
      if (CheckEmptyUtils.isEmptyArr(layoutInfo[j]) || CheckEmptyUtils.isEmpty(item)) {
        log.showInfo('calculateArea item bundleName:' + item?.bundleName);
        return rst;
      }
      for (let i = 0; i < layoutInfo[j].length; i++) {
        if (layoutInfo[j][i]?.appIconId === item.appIconId) {
          rst[NumberConstants.CONSTANT_NUMBER_TWO] = j;
          rst[1] = i % column;
          rst[0] = Math.floor(i / column);
        }
      }
    }
    return rst;
  }

  /**
   * 坐标是否在GridSwiper的区域内
   *
   * @param positionY number y坐标
   * @returns boolean y是否在GridSwiper的区域内
   */
  public isInGridSwiperArea(positionY: number): boolean {
    if (CheckEmptyUtils.isEmpty(positionY)) {
      return false;
    }
    let sysUIHeight: number = this.mLayoutViewModel.getSysUITopHeight();
    return (positionY > sysUIHeight && !this.isInDockArea(positionY)) ? true : false;
  }

  /**
   * 维测日志，按顺序打印文件夹内的app名称
   * @param layoutInfoList 文件夹list
   */
  public printFolderAppList(layoutInfoList: GridLayoutItemInfo[]): void {
    layoutInfoList?.forEach((folderItem: GridLayoutItemInfo) => {
      log.showDebug('print: %{public}s', folderItem?.bundleName);
    });
  }


  public isInDockArea(y: number): boolean {
    const swiperBottom: number = this.mLayoutViewModel.getScreenHeight() - this.mLayoutViewModel.getDockHeight();
    if (swiperBottom && y >= swiperBottom) {
      return true;
    }
    return false;
  }

  public registerOpenFolderStatusCallback(callback: FolderAnimationStatusCallback): void {
    this.openFolderStatusChangeCallBacks.push(callback);
  }

  public unRegisterOpenFolderStatusCallback(moduleName: string): void {
    let index = this.openFolderStatusChangeCallBacks.findIndex((item) => {
      return item.moduleName === moduleName;
    });
    this.openFolderStatusChangeCallBacks.splice(index, 1);
  }

  /**
   * 刷新文件夹布局元素，展开态适配MVVM解耦后整改
   *
   * @param leaveItemList 保留的应用列表
   * @param openFolderData 展开态文件夹的数据
   */
  updateFolderLayoutAfterLeave(leaveItemList: GridLayoutItemInfo[], openFolderData: GridLayoutItemInfo): void {
    log.showInfo('updateFolderLayoutAfterLeave');
    let tempArr: GridLayoutItemInfo[] = openFolderData.layoutInfo ? openFolderData.layoutInfo.flat() : [];
    leaveItemList.forEach(leaveItem => {
      let findIndex = tempArr.findIndex(item => item.keyName === leaveItem.keyName);
      if (findIndex < 0) {
        log.showError('Leave item is not in folder %{public}s', leaveItem.bundleName);
        return;
      }
      const currentLeaveItem = tempArr[findIndex];
      currentLeaveItem.extend3 = new Date().getTime(); // 使拖出最后一个应用不需要进行换位时也能够触发拖出刷新
      tempArr.splice(findIndex, 1);
      tempArr.push(currentLeaveItem);
    });
    const tempOpenFolderData: GridLayoutItemInfo = FolderManager.getInstance().getOpenedFolder();
    if (GridLayoutUtil.isSmallFolder(openFolderData)) {
      log.showDebug('updateFolderLayoutAfterLeave is smallFolder update openFolderData');
      tempOpenFolderData.layoutInfo = this.translateFolderLayout(tempArr.flat());
      FolderData.getInstance().refreshView('drag item leave from small-open-folder', openFolderData.folderId);
    }
    if (openFolderData.isInDock) {
      this.updateResidentDockLayout(tempOpenFolderData, openFolderData);
    } else {
      log.showInfo('updateFolderLayoutAfterLeave dragAppLeaveFolder');
      this.dragAppLeaveFolder(tempArr.flat(), openFolderData);
    }
  }

  private notifyDesktopUpdateLayout(): void {
    log.showDebug('notifyDesktopUpdateLayout');
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH, null);
  }

  private updateResidentDockLayout(tempOpenFolderData: GridLayoutItemInfo, openFolderData: GridLayoutItemInfo): void {
    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let findIndex: number = residentList.findIndex(item => item.keyName === openFolderData.folderId);
    if (findIndex === -1) {
      log.showError('updateFolderLayoutAfterLeave isInDock findIndex not found');
      return;
    }
    const itemArr = tempOpenFolderData.layoutInfo?.flat();
    if (!itemArr) {
      return;
    }
    // 文件夹未解散更新
    let isOneMoreApps: boolean = NotHarmonyUtil.isNotHarmonyFolderHasOneOrMoreApp(tempOpenFolderData.folderId, itemArr.length);
    // 单应用定制文件夹，最后一个应用移除时不能落位到dock区
    if (isOneMoreApps) {
      let findFolder: DockItemInfo = residentList[findIndex];
      findFolder.layoutInfo = tempOpenFolderData.layoutInfo;
      residentList.splice(findIndex, 1, findFolder);
    } else {
      const newAddItemList = itemArr[0] ? [AppModel.getInstance().gridLayoutToDockItem(itemArr[0])] : [];
      residentList.splice(findIndex, 1, ...newAddItemList);
      RdbStoreManager.getInstance().deleteItemByInfoId(tempOpenFolderData.folderId);
      // 对于文件夹解散，删除后同步更新到数据库
      RdbStoreManager.getInstance().insertIntoSmartdock(residentList).then((result) => {
        log.showInfo('updateResidentLayoutInfo success.');
      }).catch((err: Error) => {
        log.showError('updateResidentLayoutInfo error:%{public}s', err.message);
      });
    }
    LayoutViewModel.getInstance().updateResidentDockLayout(TAG.concat('_updateLayout'), residentList);
  }

  /**
   * 更新文件夹大小至缓存中
   * @param folderInfo 文件夹信息
   */
  public updateFolderSize(folderInfo: GridLayoutItemInfo): void {
    this.mFolderLayout.updateFolderSizeByFolderItem(folderInfo, 'from folder by updateFolderSize', false);
  }

  /**
   * 更新文件夹展开态中应用的下载安装状态
   * @param bundleName 应用的包名
   */
  public updateOpenFolderAppStatus(bundleName: string, newStatus: number): void {
    const openFolderData: GridLayoutItemInfo = FolderManager.getInstance().getOpenedFolder();
    if (!openFolderData.layoutInfo) {
      return;
    }
    openFolderData.layoutInfo.forEach((page: GridLayoutItemInfo[]) => {
      page.forEach((item: GridLayoutItemInfo) => {
        if (item?.bundleName === bundleName) {
          item.appStatus = newStatus;
        }
      });
    });
  }
}

export const enum FolderCloseType {
  BACK_GESTURE = 'BACK_GESTURE',
  HOME_GESTURE = 'HOME_GESTURE',
  CLICK_BLANK = 'CLICK_BLANK'
}

/**
 * 文件夹状态变更触发的callback系列类
 */
export interface FolderAnimationStatusCallback {
  /* 系列callback的唯一名称，用于动效管理类的内部查找，不用于匹配具体文件夹 */
  moduleName: string;

  /* 文件夹关闭动效结束时触发的回调 */
  closeFolderEndCallback?: () => void;

  /* 文件夹打开动效结束时触发的回调 */
  openFolderEndCallback?: () => void;
}

export interface BigFolderComponentChange {
  onListChange: (folderItem: FolderItemInfo) => void;
}