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

import { FolderDataListener, FolderManager } from '../../../common/model/FolderManager';
import { ContractedFolderObserverType, IContractedFolderObserver } from './IContractedFolderObserver';
import { DragAppToFolderData, DragCoveredItem, FoldersData } from '../../../common/model/data/FoldersData';
import {
  ContractedFolderLayoutStyle,
  ContractedFolderLayoutStyleFactory
} from './style/ContractedFolderLayoutStyleFactory';
import {
  CommonConstants,
  DeliverUtil,
  DisappearLastAppData,
  editModeManager,
  EventConstants,
  FolderAppItemInfo,
  FolderCommonUtil,
  GridLayoutItemInfo,
  IContractedFolderOpenCloseViewModel,
  OBSERVER_TYPE,
  ScreenSplitUtil
} from '../../../../../TsIndex';
import { FolderCommonConstants, FolderLifeCyclePriority } from '../../../common/FolderCommonConstant';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { Callback } from '@kit.BasicServicesKit';
import { AreaSpan } from '../../../../../utils/GridLayoutUtil';
import { BackgroundUpdator, BaseObserverManager } from '../../../common/observer/BaseObserverManager';
import { BaseDataObserverManager } from '../../../common/observer/BaseDataObserverManager';
import { FolderDebug } from '../../../common/dfx/debug/FolderDebug';
import { evtHubMgr } from '@ohos/frameworkwrapper/src/main/ets/manager/EventHubManager';

const TAG = 'ContractedFolderLayoutViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 折叠态文件夹的布局控制入口
 */
export class ContractedFolderLayoutViewModel {
  private static instance: ContractedFolderLayoutViewModel;
  private dataManager: FolderManager = FolderManager.getInstance();
  private obsMap: Map<string, ContractedFolderObserverCollection> =
    new Map<string, ContractedFolderObserverCollection>();
  private mRgsFolderMap: Map<string, number> = new Map<string, number>(); // todo 修改注册与反注册的方法

  private enableActionFlag: number = CommonConstants.DEFAULT_ENABLE_FOLDER_ACTION_FLAG;

  private mIsNewStyle: boolean = AppStorage.get<boolean>('desktopNewStyle') ?? true;

  private autoEnterEditing: boolean = false;

  private mWaitFolderMoveAnimate: Callback<void>[] = [];

  private mWaitFolderCreateAnimate: Callback<void>[] = [];

  // 桌面进入退出编辑模式
  private onDesktopEditModeChange = (): void => {
    this.obsMap.forEach((value: ContractedFolderObserverCollection, key: string) => {
      if (key !== '-1') {
        (value.layoutOsrMgr?.getObserverUpdator('desktopModeChange', OBSERVER_TYPE.FOLDER_BG) as BackgroundUpdator)
          .updateByEditMode(editModeManager.isInEditMode());
      }
    });
  };

  private constructor() {
  }

  public static getInstance(): ContractedFolderLayoutViewModel {
    if (!ContractedFolderLayoutViewModel.instance) {
      ContractedFolderLayoutViewModel.instance = new ContractedFolderLayoutViewModel();
      ContractedFolderLayoutViewModel.instance.registerDeskModeChange();
      FolderDebug.getInstance();
    }
    return ContractedFolderLayoutViewModel.instance;
  }

  /**
   * 添加文件夹创建动效回调
   *
   * @param callback
   */
  public pushFolderCreateAnimation(callback: Callback<void>): void {
    this.mWaitFolderCreateAnimate.push(callback);
  }

  /**
   * 清除布局控制器内的子组件更新器的缓存Map
   */
  public clearViewUpdator(folderId: string): void {
    const collection: ContractedFolderObserverCollection | undefined = this.obsMap.get(folderId);
    if (collection) {
      collection.layoutOsrMgr?.clearObserverUpdatorMap();
    }
  }

  /**
   * 执行文件夹创建动效
   */
  public execFolderCreateAnimation(): void {
    try {
      this.mWaitFolderCreateAnimate.forEach((callback) => {
        callback?.();
      });
    } catch (error) {
      this.dataManager.clearDragCoverItem();
      log.error('execute callback error after createFolder', error);
    }
    this.mWaitFolderCreateAnimate = [];
  }

  /**
   * 等待展开态位移动效结束后执行
   *
   * @param callback 执行的回调操作
   */
  public waitFolderMoveAnimation(callback?: Callback<void>): void {
    try {
      if (!this.dataManager.getIsSqueezing()) {
        log.showInfo('waitFolderMoveAnimation callback Immediately');
        if (callback) {
          callback();
        }
      } else {
        if (callback) {
          this.mWaitFolderMoveAnimate.push(callback);
        }
      }
    } catch (error) {
      log.error('waitFolderMoveAnimation: callback error', error);
    }
  }

  /**
   * 展开态位移动效结束后，执行所有注册的mWaitFolderMoveAnimate回调
   */
  public executeAfterMoveAnimation(): void {
    if (this.mWaitFolderMoveAnimate !== undefined && this.mWaitFolderMoveAnimate.length > 0) {
      log.showInfo('executeAfterMoveAnimation finish callback length: %{public}d', this.mWaitFolderMoveAnimate.length);
      try {
        this.mWaitFolderMoveAnimate.forEach((callback) => {
          callback?.();
        });
      } catch (error) {
        log.error('executeAfterMoveAnimation callback error', error);
      }
    }
    this.mWaitFolderMoveAnimate = [];
    FolderManager.getInstance().setIsSqueezing(false);
  }

  /**
   * 文件夹支持项的判断
   *
   * @param action
   * @returns
   */
  public isEnableAction(action: number): boolean {
    if (this.enableActionFlag & action) {
      return true;
    }
    return false;
  }

  /**
   * 更新文件夹支持项
   *
   * @param action 文件夹支持项
   */
  public updateEnableAction(action: number): void {
    this.enableActionFlag = this.enableActionFlag ^ action;
  }

  /**
   * 开始注册，将id绑定的文件夹注册记录加一
   *
   * @param folderId 文件夹id
   */
  public startRegisterByFolderId(folderId: string): void {
    let registerNum: number = this.mRgsFolderMap.get(folderId) ?? 0;
    this.mRgsFolderMap.set(folderId, registerNum + 1);
  }

  /**
   * 取消注册记录减一或删除，返回是否需要取消注册
   *
   * @param folderId 文件夹id
   * @returns true需要取消注册，false则不需要
   */
  public isNeedUnRegisterByFolderId(folderId: string): boolean {
    if (this.mRgsFolderMap.get(folderId) as number > 1) {
      let registerNum: number = this.mRgsFolderMap.get(folderId) as number;
      this.mRgsFolderMap.set(folderId, registerNum - 1);
      return false;
    }
    this.mRgsFolderMap.delete(folderId);
    return true;
  }

  /**
   * 是否当前id的文件夹已取消注册
   *
   * @param folderId 文件夹id
   * @returns true文件夹取消注册
   */
  public isFolderUnregister(folderId: string): boolean {
    return this.mRgsFolderMap.get(folderId) === undefined || this.mRgsFolderMap.get(folderId) as number <= 0;
  }

  /**
   * 是否使用桌面新样式
   *
   * @returns true
   */
  public getIsNewStyle(): boolean {
    return this.mIsNewStyle;
  }

  /**
   * 注册单个文件夹的数据更新生命周期回调
   *
   * @param folderId 文件夹id
   */
  public registerFolderDataLifeCycleEvent(folderId: string): void {
    this.dataManager.registerDataLifeListener(this.getFolderDataLifeCycleEvent(folderId));
  }

  /**
   * 取消注册单个文件夹的数据更新生命周期回调
   *
   * @param folderId 文件夹id
   */
  public unRegisterFolderDataLifeCycleEvent(folderId: string): void {
    this.dataManager.unregisterByFolderId(folderId);
  }

  private getFolderDataLifeCycleEvent(folderId: string): FolderDataListener {
    return {
      folderId: folderId,
      description: `ContractedFolder update ${folderId}`,
      priority: FolderLifeCyclePriority.HIGH,
      updateFolder: (folderId: string, updateItems: GridLayoutItemInfo[]) => {
        this.getDataOsrMgr(folderId).updateShowList('update folder');
      },
      updateFolderItems: (folderId: string, modifiedItems: GridLayoutItemInfo[]) => {
        // 改成按条件更新
        this.getDataOsrMgr(folderId).updateShowList('update folder item');
      },
      updateOpenFolder: (openFolder: GridLayoutItemInfo) => {
        this.getDataOsrMgr(openFolder.folderId as string).updateShowList('update openFolder layout');
      },
      addToFolder: (folderId: string, addItems: GridLayoutItemInfo[]) => {
        this.getDataOsrMgr(folderId).updateShowList('add to folder update');
      }
    } as FolderDataListener;
  }

  /**
   * 注册文件夹功能监听
   */
  public registerFolderCommonListener(folderId: string, openCloser: IContractedFolderOpenCloseViewModel): void {
    // 注册文件夹监听回调
    this.registerFolderDataLifeCycleEvent(folderId);
    openCloser?.registerFolderActionEventByFolderId(folderId);
  }

  /**
   * 取消文件夹公共监听的注册
   */
  public unregisterFolderCommonListener(folderId: string, openCloser: IContractedFolderOpenCloseViewModel): void {
    this.unRegisterFolderDataLifeCycleEvent(folderId);
    openCloser?.unregisterFolderActionEventByFolderId(folderId);
  }

  /**
   * 注册observer
   *
   * @param folderId 文件夹ID
   * @param obs 状态变量
   */
  public addObserver(folderId: string, obs: IContractedFolderObserver): void {
    let collection = this.obsMap.get(folderId);
    if (collection && folderId === FolderCommonConstants.INVALID_FOLDER_ID) {
      return;
    }
    if (!collection) {
      collection = new ContractedFolderObserverCollection();
      this.obsMap.set(folderId, collection);
    }
    let observeType: number = obs.getObserverType();
    if (observeType === ContractedFolderObserverType.CONTRACTED_FOLDER_DATA) {
      collection.dataOsrMgr = new BaseDataObserverManager(folderId, obs);
    } else if (observeType === ContractedFolderObserverType.CONTRACTED_FOLDER_VIEW) {
      collection.layoutOsrMgr = new BaseObserverManager(folderId, obs);
    } else {
      collection.dataOsrMgr = new BaseDataObserverManager(folderId, obs);
      collection.layoutOsrMgr = new BaseObserverManager(folderId, obs);
      log.showWarn('the type %{public}d in not defined and add error', observeType);
    }
  }

  /**
   * 取消注册Observer
   *
   * @param folderId 文件夹id
   */
  public removeObserver(folderId: string): void {
    let collection = this.obsMap.get(folderId);
    if (!collection) {
      log.showWarn(`the folder(${folderId}) observer collection is not found in map ..`);
      return;
    }
    collection.layoutOsrMgr = undefined;
    collection.dataOsrMgr?.unRegisterAll();
    collection.dataOsrMgr = undefined;
    this.deleteCollectionIsNull(folderId);
  }

  private deleteCollectionIsNull(folderId: string): void {
    let collection = this.obsMap.get(folderId);
    if (!collection) {
      return;
    }
    if (collection.isNull()) {
      this.obsMap.delete(folderId);
    }
  }

  /**
   * 获取layout相关状态变量的管理类
   *
   * @param folderId 文件夹id
   * @returns
   */
  public getViewOsrMgr(folderId: string): BaseObserverManager {
    let observerMgr: BaseObserverManager = this.obsMap.get(folderId)?.layoutOsrMgr as BaseObserverManager;
    if (!observerMgr) {
      observerMgr = this.obsMap.get(FolderCommonConstants.INVALID_FOLDER_ID)?.layoutOsrMgr as BaseObserverManager;
      log.showError('the folder %{public}s of view observer is not exist and return default mgr', folderId);
    }
    return observerMgr;
  }

  /**
   * 获取数据类observer状态变量管理类
   *
   * @param folderId 文件夹id
   * @returns
   */
  public getDataOsrMgr(folderId: string): BaseDataObserverManager {
    let dataOsrMgr: BaseDataObserverManager = this.obsMap.get(folderId)?.dataOsrMgr as BaseDataObserverManager;
    if (!dataOsrMgr) {
      dataOsrMgr = this.obsMap.get(FolderCommonConstants.INVALID_FOLDER_ID)?.dataOsrMgr as BaseDataObserverManager;
      log.showError('the folder %{public}s of data observer is not exist and return default mgr', folderId);
    }
    return dataOsrMgr;
  }

  /**
   * 获取文件夹的布局样式
   *
   * @param folderId 文件夹id
   * @returns 文件夹样式
   */
  public getLayoutStyle(folderId: string): ContractedFolderLayoutStyle {
    let folder: FoldersData = this.dataManager.getFolder(folderId);
    let style: ContractedFolderLayoutStyle =
      ContractedFolderLayoutStyleFactory.getInstance().getStyle(folder.getGridInfo());
    return style;
  }

  /**
   * 根据id查询文件夹Data
   *
   * @param folderId 文件夹id
   * @returns 文件夹Data
   */
  public getFolderDataById(folderId: string): FoldersData {
    let folder: FoldersData = this.dataManager.getFolder(folderId);
    return folder;
  }

  /**
   * 仅用于折叠开合、屏幕旋转场景更新文件夹布局
   *
   * @param msg DFX日志
   * @param folderId 文件夹Id
   */
  public updateFolderLayout(msg: string, folderId: string): void {
    let folder: FoldersData = this.getFolderDataById(folderId);
    let itemList: GridLayoutItemInfo[] = folder.getItems();
    this.dataManager.updateFolderLayout(msg, folderId, itemList, itemList, folder.isInDock());
  }

  /**
   * 是否正在调整大小的文件夹
   *
   * @param folderId 文件夹id
   */
  public isResizeFolder(folderId: string): boolean {
    return this.dataManager.getResizeFolderId() === folderId;
  }

  /**
   * 应用是否隐藏
   *
   * @param item 当前的应用
   * @returns true 需要隐藏
   */
  public isAppHidden(item: GridLayoutItemInfo | FolderAppItemInfo, folderId: string): boolean {
    let uninstallFolderApp: GridLayoutItemInfo = this.dataManager.getUninstallFolderAppItem();
    let disappearAppData: DisappearLastAppData = this.dataManager.getDisappearLastAppData();
    let folderDragItemInfo: GridLayoutItemInfo | undefined = this.dataManager.getDragItemFolder();
    // 从大文件夹中拖出的元素需要隐藏
    if (item.keyName === folderDragItemInfo?.keyName || this.isEqualDragToFolderApp(folderId, item.keyName)) {
      return true;
    }
    // 卸载的应用需要隐藏
    if (item.keyName === uninstallFolderApp.keyName) {
      return true;
    }
    // 解散动效过程中, 原本在大文件夹中被拖出/卸载/移除的元素需要隐藏
    if (item.keyName === disappearAppData.hiddenAppKeyName && folderId === disappearAppData.folderId) {
      return true;
    }
    // 解散动效过程中, 剩余最后的一个元素需要隐藏，由另外动效节点做动效
    if (item.keyName === disappearAppData.lastAppKeyName) {
      return true;
    }
    // 主应用卸载连带的分身和快捷方式需要隐藏
    if (disappearAppData.lastAppKeyName !== item.keyName && folderId === disappearAppData.folderId) {
      return true;
    }
    return false;
  }

  /**
   * 是否与当前拖拽到文件夹应用key值相同
   *
   * @param itemKey 应用item的key值
   * @returns true 相同
   */
  public isEqualDragToFolderApp(folderId: string, itemKey?: string): boolean {
    let dragToFolderApp: DragAppToFolderData = this.dataManager.getDragAppToFolder();
    let keyname: string | undefined = itemKey ?? this.dataManager.getLastAnimateInfo()?.keyName;
    return (keyname && keyname === dragToFolderApp.appKeyName && (folderId === dragToFolderApp.folderId ||
    CheckEmptyUtils.isEmpty(dragToFolderApp.folderId))) as boolean;
  }

  /**
   * 在合成文件夹时，是否与当前覆盖元素的key值相同
   *
   * @param itemKey 应用item的key值
   * @returns true相同
   */
  public isEqualCoverFolderApp(itemKey: string): boolean {
    let coverFolderApp: DragCoveredItem = this.dataManager.getDragCoverItem();
    return itemKey === coverFolderApp.coveredItemInfo?.keyName;
  }

  /**
   * 是否与当前文件夹解散剩余应用key值相同
   *
   * @param itemKey 应用item的key值
   * @returns true 相同
   */
  public isEqualDisappearData(itemKey: string): boolean {
    let appData: DisappearLastAppData = this.dataManager.getDisappearLastAppData();
    return itemKey === appData.lastAppKeyName;
  }

  /**
   * 获取动效元素item信息
   *
   * @returns item
   */
  public getLastAnimateInfo(): GridLayoutItemInfo {
    return this.dataManager.getLastAnimateInfo() as GridLayoutItemInfo;
  }

  /**
   * 获取退出到堆叠处应用的item
   *
   * @returns item
   */
  public getExitAppItem(): GridLayoutItemInfo {
    return this.dataManager.getExitAppItem() as GridLayoutItemInfo;
  }

  /**
   * 是否创建文件夹
   *
   * @param folderId 文件夹id
   * @returns true 创建文件夹
   */
  public isCreateFolder(folderId: string): boolean {
    return DeliverUtil.isCreateFolder(this.getFolderDataById(folderId).getGridInfo());
  }

  /**
   * 设置是否创建文件夹
   *
   * @param isCreate 创建文件夹
   */
  public setIsCreateFolder(isCreate: boolean): void {
    DeliverUtil.setIsCreateFolder(isCreate);
  }

  /**
   * 更新打开态文件夹状态
   *
   * @param status
   */
  public updateOpenFolderStatus(status: number): void {
    AppStorage.setOrCreate('openFolderStatus', status);
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

  /**
   * 检测文件夹大小是否符合标准大小，异常则修复
   *
   * @param folderId 文件夹id
   */
  public checkAndModifyFolder(folderId: string): void {
    let folder: GridLayoutItemInfo = this.dataManager.getFolder(folderId).getGridInfo();
    let tmpArea: number[] = folder.area ?? [AreaSpan.SPAN_2, AreaSpan.SPAN_2];
    let area: number[] = [FolderCommonUtil.getModifyAreaWidth(tmpArea[0]),
      FolderCommonUtil.getModifyAreaHeight(tmpArea[1])];
    if (tmpArea[0] !== area[0] || tmpArea[1] !== area[1]) {
      folder.area = area;
      // 更新缓存
      this.dataManager.updateFolderSize('from folder by updateFolderSize', folder);
      log.showError(`checkAndModify oldWidth:${tmpArea[0]} oldHeight:${tmpArea[1]}`);
    }
  }

  /**
   * 是否ScreenSplit
   *
   * @param msg 用于DFX的日志
   * @returns
   */
  public isScreenSplit(msg: string): boolean {
    return ScreenSplitUtil.isScreenSplit(msg);
  }

  /**
   * 是否显示取消弹框的应用
   *
   * @param item
   * @returns
   */
  public isShowCancelDialog(item: GridLayoutItemInfo): boolean {
    return false;
  }

  /**
   * 是否多选落位的应用
   *
   * @param keyname 应用的keyname
   * @returns true是多选落位的应用
   */
  public isInMultiSelectDrop(keyname: string, folderId: string): boolean {
    return this.getDataOsrMgr(folderId).getSelectItemNames().findIndex(item => item === keyname) >= 0;
  }

  /**
   * 是否是dock区文件夹
   *
   * @param folderId 文件夹id
   * @returns true是dock区文件夹
   */
  public isInDock(folderId: string): boolean {
    let folderItem: GridLayoutItemInfo = this.dataManager.getFolder(folderId).getGridInfo();
    return folderItem.container === CommonConstants.CONTAINER_SMARTDOCK;
  }

  /**
   * 是否打开态的文件夹
   *
   * @param folderId 文件夹id
   * @returns true是当前打开态的文件夹
   */
  public isOpenedFolder(folderId: string): boolean {
    const openFolder: GridLayoutItemInfo = this.dataManager.getOpenedFolder();
    return folderId === openFolder.folderId;
  }

  private registerDeskModeChange(): void {
    this.unRegisterDeskModeChange();
    evtHubMgr.on(EventConstants.EVENT_CHANGE_DESKTOP_MODE, this.onDesktopEditModeChange);
  }

  private unRegisterDeskModeChange(): void {
    evtHubMgr.off(EventConstants.EVENT_CHANGE_DESKTOP_MODE, this.onDesktopEditModeChange);
  }
}

class ContractedFolderObserverCollection {
  public layoutOsrMgr: BaseObserverManager | undefined = undefined;
  public dataOsrMgr: BaseDataObserverManager | undefined = undefined;

  public isNull(): boolean {
    return !this.layoutOsrMgr || !this.dataOsrMgr;
  }
}