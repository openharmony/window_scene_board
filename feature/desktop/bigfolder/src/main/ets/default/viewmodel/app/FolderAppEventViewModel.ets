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

import { LogDomain, Logger } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  ContractedFolderLayoutViewModel,
  ContractedFolderViewModelManager,
  ContractedFolderViewModelType,
  FolderActionLifeCycleEventManager,
  FolderActionLifeCycleStatus,
  FolderCommonUtil,
  FolderManager,
  GridLayoutItemInfo,
  IContractedFolderAppEventViewModel
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { SCBAppExitToFolderController } from '@ohos/windowscene/src/main/ets/TsIndex';

const TAG = 'FolderAppEventViewModel';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

/**
 * 文件夹应用管理ViewModel, 堆叠图标接入图标新组件，剔除原有堆叠状态变量，统一使用图标状态变量更新
 */
export class FolderAppEventViewModel implements IContractedFolderAppEventViewModel {
  private static instance: FolderAppEventViewModel;

  private mFolderMgr: FolderManager = FolderManager.getInstance();

  private mLayoutVm: ContractedFolderLayoutViewModel = ContractedFolderLayoutViewModel.getInstance();

  private exitAppIndex: number = 0;

  private exitAppInfo: GridLayoutItemInfo | null = null;

  // 文件夹动效生命周期事件管理
  private mActionEventMgr: FolderActionLifeCycleEventManager = FolderActionLifeCycleEventManager.getInstance();
  
  private constructor() {
  }

  public static getInstance(): FolderAppEventViewModel {
    if (!FolderAppEventViewModel.instance) {
      FolderAppEventViewModel.instance = new FolderAppEventViewModel();
      ContractedFolderViewModelManager.getInstance()
        .register(ContractedFolderViewModelType.APP_EVENT, FolderAppEventViewModel.instance);
    }
    return FolderAppEventViewModel.instance;
  }

  /**
   * 获取文件夹应用退出controller
   *
   * @param folderId 文件夹id
   * @returns controller
   */
  public getAppExitController(folderId: string): SCBAppExitToFolderController {
    let folderKeyId = folderId.concat(new Date().getTime().toString());
    let controller = {
      folderKey: folderKeyId as string,
      onExitStart: (folderId: string, index: number): void => this.onAppExitStart(folderId, index),
      onExitEnd: (folderId: string, index: number): void => this.onAppExitEnd(folderId, index),
    } as SCBAppExitToFolderController;
    return controller;
  }

  private onAppExitStart(folderId: string, index: number): void {
    let isOpenFolder = this.mFolderMgr.isFolderOpen();
    log.showInfo(TAG, `onAppExitStart isOpenFolder: ${isOpenFolder}, index: ${index}`);
    this.exitAppIndex = index;
    this.mFolderMgr.setExitIndex(index);
    this.mLayoutVm.getViewOsrMgr(folderId)?.showPlaceHolder('app-exit');
  }

  private onAppExitEnd(folderId: string, index: number): void {
    let isOpenFolder = this.mFolderMgr.isFolderOpen();
    log.showInfo(TAG, `onAppExitEnd isOpenFolder: ${isOpenFolder}, index: ${index}, folderId: ${folderId}`);
    this.exitAppIndex = index;
    this.mFolderMgr.setExitIndex(index);
    let folderItem: GridLayoutItemInfo = this.mFolderMgr.getFolder(folderId).getGridInfo();
    this.setExitAppInfo(folderItem, this.exitAppIndex);
  }

  private setExitAppInfo(folderItem: GridLayoutItemInfo, exitAppIndex: number): void {
    let items: GridLayoutItemInfo[] = folderItem.layoutInfo?.flat() ?? [];
    if (exitAppIndex < 1 || exitAppIndex > items.length) {
      return;
    }
    this.exitAppInfo = items[exitAppIndex - 1];
    FolderManager.getInstance().setExitAppItem(this.exitAppInfo);
    log.showInfo(TAG, `setExitAppInfo exitAppIndex: ${exitAppIndex}; exitAppInfo: ${this.exitAppInfo?.bundleName}`);
  }
}