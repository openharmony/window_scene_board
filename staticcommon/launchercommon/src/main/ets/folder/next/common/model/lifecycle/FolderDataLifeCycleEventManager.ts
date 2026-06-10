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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GridLayoutItemInfo } from '../../../../../TsIndex';
import { FolderDataListener } from '../FolderManager';

const TAG = 'FolderDataLifeCycleEventManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件夹数据生命周期管理类（data、cache内部使用）
 */
export class FolderDataLifeCycleEventManager {
  private obsArray: FolderDataListener[] = [];
  private static instance: FolderDataLifeCycleEventManager;

  static getInstance(): FolderDataLifeCycleEventManager {
    if (!FolderDataLifeCycleEventManager.instance) {
      FolderDataLifeCycleEventManager.instance = new FolderDataLifeCycleEventManager();
    }
    return FolderDataLifeCycleEventManager.instance;
  }

  private constructor() {
  }

  /**
   * 注册文件夹数据生命周期事件
   * @param obs 事件回调实例
   */
  public register(obs: FolderDataListener): void {
    if (obs.folderId === undefined) {
      log.showDebug('register folder callback for all folder');
    }

    let index: number = this.obsArray.findIndex((item: FolderDataListener) => item.priority < obs.priority);
    if (index > -1) {
      this.obsArray.splice(index, 0, obs);
    } else {
      this.obsArray.push(obs);
    }
    log.showInfo('register the dataCallback: %{public}s length: %{public}d', obs.description, this.obsArray.length);
  }

  /**
   * 去注册文件夹数据生命周期事件
   * @param obs 事件回调实例
   */
  public unregister(obs: FolderDataListener): void {
    let index = this.obsArray.findIndex((item) => {
      return item === obs;
    });
    if (index < 0) {
      log.showWarn('cannot find registered event from %{public}s:%{public}s', obs.description, obs.folderId);
      return;
    }
    log.showInfo('unregister the dataCallback: %{public}s length: %{public}d', this.obsArray[index].description,
      this.obsArray.length);
    this.obsArray.splice(index, 1);
  }

  /**
   * 根据id去注册文件夹数据生命周期事件
   *
   * @param folderId 文件夹id
   */
  public unregisterByFolderId(folderId: string): void {
    let index = this.obsArray.findIndex((item) => {
      return item.folderId === folderId;
    });
    if (index < 0) {
      log.showWarn('cannot find registered event from %{public}s', folderId);
      return;
    }
    log.showInfo('unregister the dataCallback: %{public}s length: %{public}d', this.obsArray[index].description,
      this.obsArray.length);
    this.obsArray.splice(index, 1);
  }

  /**
   * 执行文件夹内容更新回调
   *
   * @param folderItem 更新的文件夹
   */
  public notifyUpdateFolder(folderId: string, updateItems: GridLayoutItemInfo[]): void {
    let tmpArray: FolderDataListener[] = this.obsArray.slice();
    log.showInfo('notify update folder callback %{public}d', tmpArray.length);
    tmpArray.forEach((item) => {
      if (item.folderId === undefined || item.folderId === folderId) {
        try {
          item.updateFolder?.(folderId, updateItems);
        } catch (err) {
          log.showError('do folderData updateCallback error %{public}s', item.description);
        }
      }
    });
  }

  /**
   * 文件夹中元素更新回调
   *
   * @param folderId 文件夹id
   * @param modifyItems 修改的元素
   */
  public notifyUpdateFolderItems(folderId: string, modifyItems: GridLayoutItemInfo[]): void {
    let tmpArray: FolderDataListener[] = this.obsArray.slice();
    log.showInfo('notify update folder items callback %{public}d', tmpArray.length);
    tmpArray.forEach((item) => {
      if (item.folderId === undefined || item.folderId === folderId) {
        try {
          item.updateFolderItems?.(folderId, modifyItems);
        } catch (err) {
          log.showError('do folderData updateCallback error %{public}s', item.description);
        }
      }
    });
  }

  /**
   * 执行文件夹夹删除的回调
   *
   * @param folder 文件夹
   */
  public notifyRemoveFolder(folder: GridLayoutItemInfo): void {
    let tmpArray: FolderDataListener[] = this.obsArray.slice();
    log.showInfo('notify remove folder callback %{public}d', tmpArray.length);
    tmpArray.forEach((item) => {
      if (item.folderId === undefined || item.folderId === folder.folderId) {
        try {
          item.removeFolder?.(folder);
        } catch (err) {
          log.showError('removeFolder callback error %{public}s', item.description);
        }
      }
    });
  }

  /**
   * 执行展开态数据更新回调
   *
   * @param folder 当前打开的文件夹
   */
  public notifyUpdateOpenFolder(folder: GridLayoutItemInfo): void {
    let tmpArray: FolderDataListener[] = this.obsArray.slice();
    log.showInfo('notify update openFolder callback %{public}d', tmpArray.length);
    tmpArray.forEach((item) => {
      if (item.folderId === undefined || item.folderId === folder.folderId) {
        try {
          item.updateOpenFolder?.(folder);
        } catch (err) {
          log.showError('removeFolder callback error %{public}s', item.description);
        }
      }
    });
  }

  /**
   * 通知添加应用到文件夹的回调
   *
   * @param folderId 文件夹id
   * @param addItems 添加的元素
   */
  public notifyAddToFolder(folderId: string, addItems: GridLayoutItemInfo[]): void {
    let tmpArray: FolderDataListener[] = this.obsArray.slice();
    log.showInfo('notify add to folder callback %{public}d', tmpArray.length);
    tmpArray.forEach((item) => {
      if (item.folderId === undefined || item.folderId === folderId) {
        try {
          item.addToFolder?.(folderId, addItems);
        } catch (err) {
          log.showError('addToFolder callback error %{public}s', item.description);
        }
      }
    });
  }

  /**
   * 通知创建文件夹的回调
   *
   * @param folder 创建的文件夹
   */
  public notifyCreateFolder(folder: GridLayoutItemInfo): void {
    let tmpArray: FolderDataListener[] = this.obsArray.slice();
    log.showInfo('notify add new folder callback %{public}d', tmpArray.length);
    tmpArray.forEach((item) => {
      if (item.folderId === undefined || item.folderId === folder.folderId) {
        try {
          item.createFolder?.(folder);
        } catch (err) {
          log.showError('create new folder callback error %{public}s', item.description);
        }
      }
    });
  }

  /**
   * 更新文件夹名字
   *
   * @param folderId
   */
  public notifyUpdateFolderName(folderId: string): void {
    let tmpArray: FolderDataListener[] = this.obsArray.slice();
    tmpArray.forEach((item) => {
      if (item.folderId === folderId || item.folderId === undefined) {
        try {
          item.updateFolderName?.(folderId);
        } catch (error) {
          log.showError('update folder name error %{public}s', error.message);
        }
      }
    });
  }
}