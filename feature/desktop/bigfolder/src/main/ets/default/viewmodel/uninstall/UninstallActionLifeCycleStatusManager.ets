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
  DisappearLastAppData,
  FolderManager,
  FolderActionLifeCycleEventManager,
  FolderActionLifeCycleStatus,
  FolderActionLifeCycleStatusManager,
  FolderActionTransition,
  GridLayoutItemInfo
} from '@ohos/launchercommon/src/main/ets/TsIndex';

/**
 * 卸载动效的状态管理类
 */
export class UninstallActionLifeCycleStatusManager extends FolderActionLifeCycleStatusManager {
  private static sInstance: UninstallActionLifeCycleStatusManager;
  private mActionEventMgr: FolderActionLifeCycleEventManager = FolderActionLifeCycleEventManager.getInstance();

  static getInstance(): UninstallActionLifeCycleStatusManager {
    if (!UninstallActionLifeCycleStatusManager.sInstance) {
      UninstallActionLifeCycleStatusManager.sInstance = new UninstallActionLifeCycleStatusManager();
    }
    return UninstallActionLifeCycleStatusManager.sInstance;
  }

  constructor() {
    super();
    this.now = FolderActionLifeCycleStatus.DISBANDED;
    /* 操作：文件夹解散完成 */
    this.transitions.push(new FolderActionTransition()
      .from(FolderActionLifeCycleStatus.DISBANDING).to(FolderActionLifeCycleStatus.DISBANDED));
    this.transitions.push(new FolderActionTransition()
      .from(FolderActionLifeCycleStatus.DISBANDED).to(FolderActionLifeCycleStatus.DISBANDING));
  }

  /**
   * 切换到文件夹解散状态中
   *
   * @param folderItem 切换的文件夹对象
   */
  public toDisbanding(msg: string, folderItem: GridLayoutItemInfo, disappearData: DisappearLastAppData): void {
    this.tryAction(FolderActionLifeCycleStatus.DISBANDING, (from, to) => {
      /* 状态切换的前置操作 */
      FolderManager.getInstance().setDisappearLastAppData(disappearData);
    }, (from, to) => {
      this.mActionEventMgr.notify(msg, folderItem, FolderActionLifeCycleStatus.DISBANDING);
    });
  }

  /**
   * 切换到文件夹解散完成状态
   *
   * @param msg DFX日志
   * @param folderItem 切换的文件夹对象
   * @param disappearData 解散的数据信息
   */
  public toDisbanded(msg: string, folderItem: GridLayoutItemInfo, disappearData: DisappearLastAppData): void {
    this.tryAction(FolderActionLifeCycleStatus.DISBANDED, (from, to) => {
      /* 状态切换的前置操作 */
      FolderManager.getInstance().setDisappearLastAppData(disappearData);
    }, (from, to) => {
      this.mActionEventMgr.notify(msg, folderItem, FolderActionLifeCycleStatus.DISBANDED);
    });
  }

  /**
   * 解散状态修复
   *
   * @param msg 用于DFX日志
   * @param folderItem 切换的文件夹对象
   */
  public toDisbandedRepair(msg: string, folderItem: GridLayoutItemInfo): void {
    this.tryAction(FolderActionLifeCycleStatus.DISBANDED, (from, to) => {
      /* 状态切换的前置操作 */
      FolderManager.getInstance().setDisappearLastAppData(new DisappearLastAppData());
    });
  }
}