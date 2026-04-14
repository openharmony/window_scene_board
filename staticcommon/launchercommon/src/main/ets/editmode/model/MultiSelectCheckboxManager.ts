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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  FolderActionLifeCycleEvent,
  FolderActionLifeCycleEventManager,
  FolderLifeCyclePriority,
  GridLayoutItemInfo,
  GridLayoutUtil
} from '../../TsIndex';

const TAG: string = 'MultiSelectCheckboxManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 编辑模式多选框管理类
 * 后续吧MultiSelectManager里checkbox相关的都拆过来
 */
export default class MultiSelectCheckboxManager {
  private static _instance: MultiSelectCheckboxManager;

  /**获取单例*/
  public static getInstance(): MultiSelectCheckboxManager {
    if (!MultiSelectCheckboxManager._instance) {
      MultiSelectCheckboxManager._instance = new MultiSelectCheckboxManager();
    }
    return MultiSelectCheckboxManager._instance;
  };

  /** 文件夹状态 */
  public readonly folderState: FolderStatus = new FolderStatus();

  /** 获取当前打开的文件夹Id */
  public get openFolderParentId(): string {
    return this._openFolderParentId;
  }

  private _openFolderParentId: string = '';

  constructor() {
    this.registerOpenCloseFolderCallback();
  };

  /** 监听文件夹展开事件 */
  private registerOpenCloseFolderCallback(): void {
    FolderActionLifeCycleEventManager.getInstance().register(this.mOpenCloseCallback);
  }

  private mOpenCloseCallback: FolderActionLifeCycleEvent = {
    description: TAG,
    priority: FolderLifeCyclePriority.HIGH,
    onOpeningFolder: (folder: GridLayoutItemInfo) => {
      this.folderState.setStatus(FolderStatusEnum.OPENING);
      this._openFolderParentId = GridLayoutUtil.generateUniqueKey(folder);
    },
    onOpenedFolder: (folder: GridLayoutItemInfo) => {
      this.folderState.setStatus(FolderStatusEnum.OPENED);
    },
    onClosingFolder: (folder: GridLayoutItemInfo) => {
      this.folderState.setStatus(FolderStatusEnum.CLOSING);
      this._openFolderParentId = '';
    },
    onClosedFolder: (folder: GridLayoutItemInfo) => {
      this.folderState.setStatus(FolderStatusEnum.CLOSED);
    }
  };
}

/**
 * 文件夹状态类
 * 想放到FolderData, 但是暂时自己维护
 */
class FolderStatus {
  private status: FolderStatusEnum = FolderStatusEnum.CLOSED;

  /** 设置文件夹状态 */
  public setStatus(status: FolderStatusEnum) : boolean {
    if (this.status === status) {
      return false;
    }
    this.status = status;
    return true;
  };

  /** 文件夹是否为关闭状态 */
  public get isClosed(): boolean {
    return this.status === FolderStatusEnum.CLOSED;
  };

  /** 文件夹是否为打开中状态 */
  public get isOpening(): boolean {
    return this.status === FolderStatusEnum.OPENING;
  };

  /** 文件夹是否为打开状态 */
  public get isOpened(): boolean {
    return this.status === FolderStatusEnum.OPENED;
  };

  /** 文件夹是否为关闭中状态 */
  public get isClosing(): boolean {
    return this.status === FolderStatusEnum.CLOSING;
  };
}

enum FolderStatusEnum {
  /**文件夹关闭状态*/
  CLOSED = 0,
  /**文件夹打开中状态*/
  OPENING = 1,
  /**文件夹打开状态*/
  OPENED = 2,
  /**文件夹关闭中状态*/
  CLOSING = 3,
}

