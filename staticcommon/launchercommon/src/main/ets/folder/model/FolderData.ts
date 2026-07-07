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

import { LogDomain, LogHelper, } from '@ohos/basicutils';
import { FolderState, FolderStateManager } from './FolderStateManager';
import {
  CommonConstants,
  ContractedFolderCommonViewModel,
  DeliverUtil,
  DockItemInfo,
  FolderLayoutCacheManager,
  FolderManager,
  FolderModel,
  GridLayoutItemInfo,
  GridLayoutUtil,
  ResidentLayoutCacheMgr
} from '../../TsIndex';

const TAG = 'FolderData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const EMPTY_ITEM: GridLayoutItemInfo = GridLayoutItemInfo.getEmptyItem();

export enum FolderOperationFlag {
  NONE = 0,
  /* 立刻跳转状态，即跳过ing的中间态 */
  IMMEDIATELY = 1,
  /* 状态跳转异常修复 */
  REPAIR = 2,
  /* 打断动效 */
  BREAK = 3,
}

/**
 * 文件夹数据模型，支持大、小、展开文件夹
 * 本模块是通用CacheManager和文件夹ViewModel的衔接流程。实现数据修改的状态管理
 */
export class FolderData {
  private static mInstance: FolderData;
  /* 打开的文件夹在Cache管理中的实例，需要特别注意的是，文件夹删除的时候，必须先清理本模块的变量，再释放Cache管理的内容 */
  private openedFolder: GridLayoutItemInfo | undefined = undefined;
  private closingFolder: GridLayoutItemInfo | undefined = undefined;
  private openedFolderId: string = '';
  private callBackList: FolderDataCallback[] = [];

  protected constructor() {
  }

  static getInstance(): FolderData {
    if (FolderData.mInstance == null) {
      log.showInfo('create FolderData');
      FolderData.mInstance = new FolderData();
    }
    return FolderData.mInstance;
  }

  private getFolderDesc(folder?: GridLayoutItemInfo): string {
    return folder?.folderId ?? 'unknown';
  }

  /**
   * 注册回调
   *
   * @param folderCallBack 文件夹回调封装对象,按Priority 顺序（大->小）注册
   */
  public registerCallBack(folderCallBack: FolderDataCallback): void {
    if (folderCallBack.folderId === undefined) {
      log.showDebug('register folder callback for all folder');
    }

    log.showInfo(`folderCallBack folderId:${folderCallBack.folderId},priority:${folderCallBack.priority}`);
    let index: number = this.callBackList.findIndex(
      (data: FolderDataCallback) => data.priority < folderCallBack.priority);
    if (index > -1) {
      this.callBackList.splice(index, 0, folderCallBack);
    } else {
      this.callBackList.push(folderCallBack);
    }
  }

  /**
   * 根据id反注册函数对应的回调
   *
   * @param moduleName 注册事件时的文件夹回调封装对象
   */
  public unregisterCallBack(cb: FolderDataCallback): void {
    log.showInfo(`folderCallBack folderId:${cb.folderId},priority:${cb.priority}`);
    let index = this.callBackList.findIndex((item) => {
      return item === cb;
    });
    this.callBackList.splice(index, 1);
  }

  /**
   * 根据id反注册函数对应的回调
   *
   * @param moduleName 注册事件时的id
   */
  public unregisterCallBackByName(moduleName: string): void {
    let index = this.callBackList.findIndex((item) => {
      return item.moduleName === moduleName;
    });
    this.callBackList.splice(index, 1);
  }

  /**
   * 通过TAG和folderId以及可选字段extend生成callback的唯一名称
   *
   * @param TAG callback所属TAG
   * @param folderId 文件夹Id
   * @extends extend 自定义额外字段
   * @return callBack唯一名称
   */
  public generateCallbackModuleName(TAG: string, folderId: string, extend: string = ''): string {
    return TAG + folderId + extend;
  }

  /**
   * 查找指定文件夹内的应用信息数组的拷贝
   *
   * @param folder 指定文件夹信息
   * @return 文件夹内一维化的列表
   */
  public getItemsInFolder(folder: GridLayoutItemInfo): GridLayoutItemInfo[] {
    let want: GridLayoutItemInfo | undefined = undefined;
    if (folder !== this.openedFolder) {
      want = this.getFolderByItem(folder);
    } else {
      want = folder;
    }
    if (want && want.layoutInfo) {
      DeliverUtil.addAddIcon(want, 'getItemsInFolder');
      return want.layoutInfo.flat();
    }
    let wantInDock: GridLayoutItemInfo[][] = this.getFolderDataAppListInDock(folder);
    if (wantInDock) {
      DeliverUtil.addAddIconToLayoutInfo(wantInDock, 'getItemsInFolder dock', folder.folderId);
      return wantInDock.flat();
    }
    return [];
  }

  private getFolderDataAppListInDock(folder: GridLayoutItemInfo): GridLayoutItemInfo[][] {
    let residentList: Array<DockItemInfo> = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    const folderId: string | undefined = folder.folderId;
    let dockItem: DockItemInfo | undefined = residentList.find((item) => {
      return item.keyName === folderId;
    });
    if (dockItem && dockItem.layoutInfo) {
      return dockItem.layoutInfo;
    }
    return [];
  }

  private getFolderByItem(target: GridLayoutItemInfo): GridLayoutItemInfo {
    let folderItem: GridLayoutItemInfo | undefined =
      FolderLayoutCacheManager.getInstance().selectGridLayoutItemByItem(target);
    if (folderItem) {
      return folderItem;
    }
    return this.getFolderByItemInDock(target) ?? EMPTY_ITEM;
  }

  public getFolderItemByFolderId(folderId: string, isOuter?: boolean): GridLayoutItemInfo {
    let folderItem: GridLayoutItemInfo | undefined =
      FolderLayoutCacheManager.getInstance().selectGridLayoutItemByFolderId(folderId, isOuter);
    if (folderItem) {
      return folderItem;
    }
    folderItem = FolderLayoutCacheManager.getInstance()
      .getAllGridLayoutItemList('getFolderItemByFolderId', isOuter)
      .find(item => item.typeId === CommonConstants.TYPE_REGION_FOLDER && item.folderId === folderId);
    if (folderItem) {
      return folderItem;
    }
    return this.getFolderByIdInDock(folderId) ?? EMPTY_ITEM;
  }

  private getFolderByIdInDock(folderId: string): GridLayoutItemInfo {
    let residentList: Array<DockItemInfo> = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let dockItem: DockItemInfo | undefined = residentList.find((item) =>
      item.keyName === folderId
    );
    return this.transDockItemToGridLayoutItem(dockItem) ?? EMPTY_ITEM;
  }


  private getFolderByItemInDock(target: GridLayoutItemInfo): GridLayoutItemInfo | undefined {
    let residentList: Array<DockItemInfo> = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    const folderId: string | undefined = target.folderId;
    let dockItem: DockItemInfo | undefined = residentList.find((item) =>
    item.keyName === folderId
    );
    return dockItem ? this.transDockItemToGridLayoutItem(dockItem) : undefined;
  }

  private transDockItemToGridLayoutItem(dockItem?: DockItemInfo): GridLayoutItemInfo | undefined {
    if (!dockItem) {
      return undefined;
    }
    let gridLayoutItemInfo = new GridLayoutItemInfo();
    gridLayoutItemInfo.itemType = CommonConstants.TYPE_FOLDER;
    gridLayoutItemInfo.typeId = CommonConstants.TYPE_FOLDER;
    gridLayoutItemInfo.folderId = dockItem.keyName;
    gridLayoutItemInfo.bundleName = dockItem.bundleName;
    gridLayoutItemInfo.moduleName = dockItem.moduleName;
    gridLayoutItemInfo.abilityName = dockItem.abilityName;
    gridLayoutItemInfo.appIconId = dockItem.appIconId;
    gridLayoutItemInfo.appLabelId = dockItem.appLabelId;
    gridLayoutItemInfo.applicationLabelId = dockItem.applicationLabelId;
    gridLayoutItemInfo.appName = dockItem.appName;
    gridLayoutItemInfo.folderName = dockItem.appName;
    gridLayoutItemInfo.areaType = dockItem.areaType;
    gridLayoutItemInfo.keyName = dockItem.keyName;
    gridLayoutItemInfo.layoutInfo = dockItem.layoutInfo;
    gridLayoutItemInfo.container = CommonConstants.CONTAINER_SMARTDOCK;
    gridLayoutItemInfo.area = [1, 1];
    gridLayoutItemInfo.row = dockItem.row;
    gridLayoutItemInfo.column = dockItem.column;
    gridLayoutItemInfo.badgeNumber = dockItem.badgeNumber;
    gridLayoutItemInfo.isInDock = true;
    return gridLayoutItemInfo;
  }

  private notifyFolderOpened(): void {
    let callbacks: FolderDataCallback[] = this.callBackList.slice();
    callbacks.forEach((item) => {
      if (item.folderId === undefined || item.folderId === this.getOpenedFolder().folderId) {
        try {
         this.dealOpenedFolderCallback(item);
        } catch (err) {
          log.showError(`notifyFolderOpened err moduleName:${item.moduleName} ${err?.toString?.()}`);
        }
      }
    });
  }

  private dealOpenedFolderCallback(item: FolderDataCallback): void {
    if (!this.openedFolder) {
      return;
    }
    item.openedFolderCallback?.(this.openedFolder);
  }

  private notifyFolderOpening(): void {
    let callbacks: FolderDataCallback[] = this.callBackList.slice();
    callbacks.forEach((item) => {
      if (item.folderId === undefined || item.folderId === this.getOpenedFolder().folderId) {
        try {
         this.dealOpeningFolderCallback(item);
        } catch (err) {
          log.showError(`notifyFolderOpening err moduleName:${item.moduleName} ${err?.toString?.()}`);
        }
      }
    });
  }

  private dealOpeningFolderCallback(item: FolderDataCallback): void {
    if (!this.openedFolder) {
      return;
    }
    item.openingFolderCallback?.(this.openedFolder);
  }

  private notifyFolderClosed(): void {
    if (!this.closingFolder) {
      log.showWarn('null closing folder ?');
      return;
    }
    let callbacks: FolderDataCallback[] = this.callBackList.slice();
    callbacks.forEach((item) => {
      if (item.folderId === undefined || item.folderId === this.getOpenedFolder().folderId) {
        try {
         this.dealFolderClosed(item);
        } catch (err) {
          log.showError(`notifyFolderClosed err moduleName:${item.moduleName} ${err?.toString?.()}`);
        }
      }
    });
  }

  private dealFolderClosed(item: FolderDataCallback): void {
    if (!this.closingFolder) {
      return;
    }
    item.closedFolderCallback?.(this.closingFolder);
  }

  private notifyFolderClosing(): void {
    if (!this.closingFolder) {
      log.showWarn('null closing folder ?');
      return;
    }
    let callbacks: FolderDataCallback[] = this.callBackList.slice();
    callbacks.forEach((item) => {
      if (item.folderId === undefined || item.folderId === this.getOpenedFolder().folderId) {
        try {
         this.dealFolderClosing(item);
        } catch (err) {
          log.showError(`notifyFolderClosing err moduleName:${item.moduleName} ${err?.toString?.()}`);
        }
      }
    });
  }

  private dealFolderClosing(item: FolderDataCallback): void {
    if (!this.closingFolder) {
      return;
    }
    item.closingFolderCallback?.(this.closingFolder);
  }

  /**
   * 文件夹打开动效完成。此接口是内部细化打开过程生命周期的子接口，仅在打开动效的指定场景调用，调用后表明打开动效完成。
   *
   *     此接口只能由最后的动效类调用。即opening的生命周期，和动效保持一致。但是这样会导致业务在此过程中执行的一些数据处理，特别是异步的，
   * 会需要业务自行打断，但是这些过程中，应该是基本没有数据处理的。
   *     考虑几种场景：
   * 1. 拖拽可能会涉及数据的刷新。但是这个刷新应该设计上被动效遮住。这种是不应该被打断的
   * 2. 打开的过程中，一个图标从下载中切换到下载完成状态，这里也涉及数据库的刷新，也是不应该被打断的
   *     综上看，目前并没有需要支持打断的异步的操作。
   *     再继续看待这个问题，假如确实需要支持拖拽落位过程中，可被其他状态打断，那么，仅需要此函数提供一个callback接口，
   * 接口注册到拖拽->另一状态的when回调上，然后就可以由业务在callback里判断数据刷新是否完成，如果完成就可以直接打断。
   * 这样同时不会影响其他的状态变化。
   *
   * @param msg 操作标记，用于DFX维测
   */
  public opened(msg: string): void {
    if (!this.openedFolder) {
      log.showWarn('opened dir failed, no opening folder ?');
      return;
    }
    log.showInfo('folder(%{public}s) opened, by (%{public}s)', this.getFolderDesc(this.openedFolder), msg);
    FolderStateManager.getInstance().tryAction(FolderState.OPENED, undefined, (from, to) => {
      this.notifyFolderOpened();
    });
  }

  private isImmediately(flags: number): boolean {
    return (flags & FolderOperationFlag.IMMEDIATELY) !== 0;
  }

  private closedImmediately(): void {
    FolderStateManager.getInstance().tryAction(FolderState.CLOSED,
      /* 优先标记，避免业务在callback回调中调用data接口无法获取准确状态 */
      (from, to) => {
        /*
         * 释放openedFolder，这样isFolderOpen返回结果正确。但是又希望callback回调能够获取当前文件夹的信息，
         * 所以新增了一个不对外开放的变量
         */
        this.closingFolder = this.openedFolder;
        this.openedFolder = undefined;
      },
      /* 再通知上层业务 */
      (from, to) => {
        this.notifyFolderClosed();
        this.closingFolder = undefined;
      },
    );
  }

  private closedForRepair(): void {
    FolderStateManager.getInstance().tryAction(FolderState.CLOSED,
      /* 优先标记，避免业务在callback回调中调用data接口无法获取准确状态 */
      (from, to) => {
        /* 不同于closedImmediately，这里不能覆盖closingFolder，否则就被清空了，导致notifyFolderClosed无法进行 */
        this.openedFolder = undefined;
      },
      /* 再通知上层业务 */
      (from, to) => {
        this.notifyFolderClosed();
        this.closingFolder = undefined;
      },
    );
  }

  /**
   * 开始打开文件夹
   *
   * @param msg 操作标记，用于DFX维测
   * @param folder folder信息
   * @param flags FolderOperationFlag枚举的组合
   */
  public open(msg: string, folder: GridLayoutItemInfo, flags: number = FolderOperationFlag.NONE): void {
    let want = this.getFolderByItem(folder);
    if (!want) {
      log.showWarn('opening folder failed, cannot find folder(%{public}s) in cache list ...', folder.keyName);
      return;
    }
    log.showInfo('folder(%{public}s) opening, by (%{public}s)', this.getFolderDesc(want), msg);
    if (want.folderId) {
      this.openedFolderId = want.folderId;
    }
    if (this.openedFolder || this.closingFolder) {
      log.showWarn('folder(%{public}s) has already opened, close it firstly ...',
        this.getFolderDesc(this.openedFolder));
      this.close('close folder by repeat open', FolderOperationFlag.IMMEDIATELY);
    }
    if (this.isImmediately(flags)) {
      /* 立刻切换状态，跳过ING的过程态，避免业务的动效被触发，直接组件上下树 */
      FolderStateManager.getInstance().tryAction(FolderState.OPENED,
        /* 优先标记，避免业务在callback回调中调用data接口无法获取准确状态 */
        (from, to) => {
          this.openedFolder = want;
          this.closingFolder = undefined;
        },
        /* 再通知上层业务 */
        (from, to) => {
          this.notifyFolderOpened();
        },
      );
    } else {
      FolderStateManager.getInstance().tryAction(FolderState.OPENING,
        /* 优先标记，避免业务在callback回调中调用data接口无法获取准确状态 */
        (from, to) => {
          this.openedFolder = want;
          this.closingFolder = undefined;
        },
        /* 再通知上层业务 */
        (from, to) => {
          this.notifyFolderOpening();
        },
      );
    }
  }

  /**
   * 文件夹关闭动效完成。此接口是内部细化打开过程生命周期的子接口，仅在关闭动效的指定场景调用，调用后表明关闭动效完成。
   *
   * @param msg 操作标记，用于DFX维测
   */
  public closed(msg: string): void {
    if (!this.closingFolder) {
      let err = '';
      if (this.openedFolder) {
        err = 'clear opened-folder';
      }
      log.showWarn('closed folder by(%{public}s) failed, no opening folder ... %{public}s', msg, err);
      return;
    }
    log.showInfo('folder(%{public}s) closed, by (%{public}s)', this.getFolderDesc(this.closingFolder), msg);
    FolderStateManager.getInstance().tryAction(FolderState.CLOSED, undefined, (from, to) => {
      this.notifyFolderClosed();
      this.closingFolder = undefined;
    });
  }

  /**
   * 开始关闭文件夹
   * 注意：close一定要先于文件夹解散
   *
   * @param msg 操作标记，用于DFX维测
   * @param flags FolderOperationFlag枚举的组合
   */
  public close(msg: string, flags: number = FolderOperationFlag.NONE): void {
    ContractedFolderCommonViewModel.getInstance().closeFolder(msg, flags);
  }

  /* todo: 待删除，by 欧阳书星 */
  /**
   * 文件夹展开状态变更刷新
   * @param state
   */
  public notifyFolderStateChange(state: number): void {
    let callbacks: FolderDataCallback[] = this.callBackList.slice();
    callbacks.forEach((item) => {
      if (item.folderId === undefined || item.folderId === this.getOpenedFolder().folderId) {
        try {
          this.dealFolderStateChange(item, state);
        } catch (err) {
          log.showError(`notifyFolderStateChange err moduleName:${item.moduleName} ${err?.toString?.()}`);
        }
      }
    });
  }

  private dealFolderStateChange(item: FolderDataCallback, state: number): void {
    if (!this.openedFolder) {
      return;
    }
    item.stateChangeCallback?.(this.openedFolder, state);
  }

  /**
   * 判断是否有文件夹打开
   *
   * @return 有任意文件夹打开，则返回TRUE
   */
  public isFolderOpen(): boolean {
    return FolderManager.getInstance().isFolderOpen();
  }

  /**
   * 获取正在打开状态的文件夹folder信息
   * 特别注意，调用者不要修改返回的变量内容，也不要时间持有，避免文件夹删除后，访问到失效的数据
   *
   * @returns 正在打开状态的文件夹folder信息
   */
  public getOpenedFolder(): GridLayoutItemInfo {
    if (this.openedFolder) {
      return this.openedFolder;
    }
    return this.closingFolder ?? EMPTY_ITEM;
  }

  /**
   * 获取打开文件夹的folderId
   *
   * @return 获取文件夹展开态folderId
   */
  public getOpenFolderId(): string {
    return this.openedFolderId;
  }

  /**
   * folderId对应文件夹的数据变化后，进行刷新
   *
   * @param layoutInfo
   */
  public refreshView(msg: string, folderId: string, isOuter?: boolean): void {
    log.showWarn('folder(%{public}s) refresh, by (%{public}s)', folderId, msg);
    let callbacks: FolderDataCallback[] = this.callBackList.slice();
    callbacks.forEach((item) => {
      if (!item.refreshViewCallback) {
        return;
      }
      if (item.folderId === undefined || (item.folderId === folderId)) {
        try {
          this.checkRefreshCallback(folderId, item, isOuter);
        } catch (err) {
          log.showError(`refreshView err moduleName:${item.moduleName} ${err?.toString?.()}`);
        }
      }
    });
  }

  /**
   * 关闭态的其他文件夹也注册了refresh回调，在桌面数据刷新的流程中也会调用refreshView接口，
   * 此处需要根据folderId回调对应的数据
   *
   * @param folderId 刷新的文件夹的folderId
   * @param item  对应的回调方法
   */
  private checkRefreshCallback(folderId: string, item: FolderDataCallback, isOuter?: boolean): void {
    if (this.openedFolder?.folderId === folderId) {
      item.refreshViewCallback?.(this.openedFolder);
    } else {
      let folderInfo: GridLayoutItemInfo = this.getFolderItemByFolderId(item.folderId ?? '', isOuter);
      if (folderInfo?.layoutInfo) {
        item.refreshViewCallback?.(folderInfo);
      }
    }
  }

  /**
   * 获取展开态文件夹需要做动效的图标数量
   *
   * @returns 文件夹内图标数量 < 展开态每页最大显示数量 ? 返回文件夹内图标数量 : 展开态每页最大显示数量（4*2 最大18）
   */
  getOpenFolderAppAnimateCount(): number {
    let mLayoutInfo = this.getOpenedFolder().layoutInfo;
    if ( mLayoutInfo && mLayoutInfo.length > 0) {
      let appListLength: number = mLayoutInfo.flat().length;
      let appNumberWhenFolderOpen = GridLayoutUtil.getCountPerPageFolderOpen();
      if (appListLength > appNumberWhenFolderOpen) {
        const maxNum = GridLayoutUtil.getCountPerPageInFolder(this.getOpenedFolder().area ?? [1, 1]);
        return Math.max(Math.min(appListLength, maxNum), appNumberWhenFolderOpen);
      } else {
        return appListLength;
      }
    }
    return 12;
  }

  /**
   * 获取文件夹列表内应用所在的索引
   * @param item 目标应用
   * @returns 图标在列表中的索引
   */
  public getIndex(item: GridLayoutItemInfo): number {
    let findIndex = this.getOpenedFolder()?.layoutInfo?.flat().findIndex((idx) => {
      return item?.keyName === idx?.keyName;
    });
    let maxPerPage =
      FolderModel.getInstance().getFolderOpenLayout().column * FolderModel.getInstance().getFolderOpenLayout().row;
    if (maxPerPage === 0) {
      log.showError(`maxPerPage is 0 error,findIndex = ${findIndex}`);
      return findIndex ?? 1;
    }
    return (findIndex ?? 1) % maxPerPage;
  }

  /**
   * 获取文件夹列表内应用所在的页
   * @param item 目标应用
   * @returns 图标所在的page页码
   */
  public getPageIndex(item: GridLayoutItemInfo): number {
    let findIndex = this.getOpenedFolder()?.layoutInfo?.flat().findIndex((idx) => {
      return item?.keyName === idx?.keyName;
    });
    let maxPerPage =
      FolderModel.getInstance().getFolderOpenLayout().column * FolderModel.getInstance().getFolderOpenLayout().row;
    if (maxPerPage === 1) {
      log.showError(`maxPerPage is 0 error,findIndex = ${findIndex}`);
      return findIndex ?? 1;
    }
    return Math.floor((findIndex ?? 1) / maxPerPage);
  }

  /**
   * 获取注册的DEBUG描述信息
   *
   * @returns 汇总字符串
   */
  public getCallbackDesc(): string {
    let ret: string = 'there has ' + this.callBackList.length + ' modules registered callback \r\n';

    ret += 'Index'.padEnd(8, ' ') +
      'Name'.padEnd(48, ' ') +
      'Priority'.padEnd(12, ' ') +
      'ListenFolderId'.padEnd(32, ' ') +
      'OpeningFolderCallback'.padEnd(24, ' ') +
      'OpenedFolderCallback'.padEnd(24, ' ') +
      'ClosingFolderCallback'.padEnd(24, ' ') +
      'ClosedFolderCallback'.padEnd(24, ' ') +
      'RefreshViewCallback'.padEnd(24, ' ') + '\r\n';
    this.callBackList.forEach((item, index) => {
      ret += (index + 1).toString().padEnd(8, ' ') +
        item.moduleName.padEnd(48, ' ') +
        item.priority.toString().padEnd(12, ' ') +
        (item.folderId ?? 'all').padEnd(32, ' ') +
        (item.openingFolderCallback ? 'Y' : 'N').padEnd(24, ' ') +
        (item.openedFolderCallback ? 'Y' : 'N').padEnd(24, ' ') +
        (item.closingFolderCallback ? 'Y' : 'N').padEnd(24, ' ') +
        (item.closedFolderCallback ? 'Y' : 'N').padEnd(24, ' ') +
        (item.refreshViewCallback ? 'Y' : 'N').padEnd(24, ' ') + '\r\n';
    });

    this.callBackList.forEach((item) => {
      if (!item.getDescCallback) {
        return;
      }
      ret += '\r\nmodule: ' + item.moduleName + ' description below\r\n';
      ret += item.getDescCallback() + '\r\n';
    });

    return ret;
  }

  /**
   * 获取注册的FolderData状态信息
   *
   * @returns 汇总字符串
   */
  public getFolderDataDesc(): string {
    let ret: string = 'IsFolderOpen: ' + this.isFolderOpen() + '\r\n';
    ret += 'OpenedFolder: ' + this.getFolderDesc(this.openedFolder) + '\r\n';
    ret += 'ClosingFolder: ' + this.getFolderDesc(this.closingFolder) + '\r\n';
    ret += 'GetOpenFolderId: ' + this.getOpenFolderId() + '\r\n';

    return ret;
  }

  /**
   * 获取指定文件夹的元素信息
   *
   * @param folderId 文件夹ID
   * @returns 汇总字符串
   */
  public getFolderItemsDesc(folderId: string): string {
    const folder: GridLayoutItemInfo = this.getFolderItemByFolderId(folderId);
    let ret: string = 'folder ' + folder.folderId + ' has ' + folder.layoutInfo?.flat().length + ' items\r\n';

    ret += 'Page'.padEnd(8, ' ') +
      'Bundle'.padEnd(48, ' ') +
      'AppIndex'.padEnd(12, ' ') +
      'Badge'.padEnd(8, ' ') +
      'Typeid'.padEnd(8, ' ') +
      '\r\n';
    folder.layoutInfo?.forEach((page, index) => {
      page.forEach((item) => {
        ret += index.toString().padEnd(8, ' ') +
          item.bundleName.padEnd(48, ' ') +
          (item.appIndex ?? 'undefined').toString().padEnd(12, ' ') +
          (item.badgeNumber ?? -1).toString().padEnd(8, ' ') +
          (item.typeId ?? 'undefined').toString().padEnd(8, ' ') + '\r\n';
      });
    });

    return ret;
  }

  /**
   * 获取所有文件夹信息
   *
   * @returns 汇总字符串
   */
  public getFoldersDesc(): string {
    let folders = FolderLayoutCacheManager.getInstance().getAllGridLayoutItemList('folder debug');
    let ret: string = 'There has ' + folders.length + ' folders/apps in desktop\r\n';

    ret += 'FolderId'.padEnd(32, ' ') +
      'Area'.padEnd(24, ' ') +
      'Name'.padEnd(32, ' ') + '\r\n';
    folders.forEach((folder) => {
      if (folder.typeId !== CommonConstants.TYPE_FOLDER) {
        return;
      }
      ret += (folder.folderId ?? 'undefined').toString().padEnd(32, ' ') +
        ('[' + folder.area?.[0] + ',' + folder.area?.[1] + ']').padEnd(24, ' ') +
        (folder.folderName ?? 'undefined').padEnd(32, ' ') + '\r\n';
    });

    return ret;
  }
}

/**
 * 文件夹数据状态变更触发的callback系列类
 */
export interface FolderDataCallback {
  /* 系列callback的唯一名称，用于FolderData的内部查找，不用于匹配具体文件夹 */
  moduleName: string;

  /* 回调优先级 */
  priority: PriorityLevel;

  /* 文件夹Id */
  folderId?: string;

  /*
   * 文件夹打开关闭的生命周期及回调说明：
   * 用户操作              点击折叠态文件夹                         用户看到动效完毕
   * 动效过程             开始文件夹打开动效                       结束文件夹打开动效
   *                           │                                    │
   *                           │                                    │
   *          ┌────────────────▼────────────────────────────────────▼─────────────┬─►   时间
   *          │     closed     │               opening              │    opened   │     状态
   *          └────────────────┘▲───────────────────────────────────┘▲────────────┘
   *                            │                                    │
   *                            │                                    │
   * 回调通知           openingFolderCallback                   openedFolderCallback
   *
   * 用户操作              点击展开态文件夹空白处                    用户看到动效完毕
   * 动效过程             开始文件夹关闭动效                       结束文件夹关闭动效
   *                           │                                    │
   *                           │                                    │
   *          ┌────────────────▼────────────────────────────────────▼─────────────┬─►   时间
   *          │     opened     │               closing              │    closed   │     状态
   *          └────────────────┘▲───────────────────────────────────┘▲────────────┘
   *                            │                                    │
   *                            │                                    │
   * 回调通知           closingFolderCallback                   closedFolderCallback
   */

  /* 文件夹打开动效开始时，进入OPENING状态触发的回调 */
  openingFolderCallback?: (folder: GridLayoutItemInfo) => void;

  /* 文件夹打开动效结束时，进入OPENED状态触发的回调 */
  openedFolderCallback?: (folder: GridLayoutItemInfo) => void;

  /* 文件夹关闭动效开始时，进入CLOSING状态触发的回调 */
  closingFolderCallback?: (folder: GridLayoutItemInfo) => void;

  /* 文件夹关闭动效结束时，进入CLOSED状态触发的回调 */
  closedFolderCallback?: (folder: GridLayoutItemInfo) => void;

  /* todo: 待删除，by 欧阳书星 */
  /* 文件展开态状态变更回调 */
  stateChangeCallback?: (folder: GridLayoutItemInfo, state: number) => void;

  /* 文件夹刷新视图触发的回调，临时措施，最终在5.1上应该去掉，由ViewModel在其他的callback刷新状态变量触发view刷新 */
  refreshViewCallback?: (folder: GridLayoutItemInfo) => void;

  /* 文件夹子模块的 */
  getDescCallback?: () => string;
}

/**
 * 回调调度优先级
 */
export enum PriorityLevel {
  /* 低优先级，主要用于相关的布局控件刷新 */
  LOW = 1,

  /* 正常优先级，用于控件刷新前的控制变量变更 */
  NORMAL = 50,

  /* 高优先级，用于缓存数据的变更刷新 */
  HIGH = 90,

  /* 最高优先级，仅用于data/viewModel的数据更新 */
  HIGHER = 100,
}