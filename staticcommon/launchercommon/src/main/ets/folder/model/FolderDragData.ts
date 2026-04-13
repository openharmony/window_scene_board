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
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { GridLayoutItemInfo } from '../../TsIndex';
import { FolderData, FolderDataCallback, PriorityLevel } from './FolderData';

const TAG = 'FolderDragData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/*
 * 原来有些拖拽相关的状态变量，文件重构后，纯保存类型的状态变量不建议放到FolderData；部分带刷新的也可以配合refresh替代，所以新增了这个类。
 * 此外此模块还要支持拖拽重构的场景。
 */
export class FolderDragData {
  private isFolderOpened: boolean = false;
  private isFolderChanging: boolean = false;
  private folderLifeCallback: FolderDataCallback = {
    moduleName: 'folderDragData',
    priority: PriorityLevel.HIGHER, /* 数据状态类，优先级放到最高 */
    openingFolderCallback: (folder: GridLayoutItemInfo) => { this.openingFolder(folder) },
    openedFolderCallback: (folder: GridLayoutItemInfo) => { this.openedFolder(folder) },
    closingFolderCallback: (folder: GridLayoutItemInfo) => { this.closingFolder(folder) },
    closedFolderCallback: (folder: GridLayoutItemInfo) => { this.closedFolder(folder) },
    getDescCallback: () => { return this.getDescription() },
  };
  private constructor() {
    FolderData.getInstance().registerCallBack(this.folderLifeCallback);
  }

  static getInstance(): FolderDragData {
    if (globalThis.folderDragData == null) {
      log.showInfo('create FolderDragData');
      globalThis.folderDragData = new FolderDragData();
    }
    return globalThis.folderDragData;
  }

  private openingFolder(folder: GridLayoutItemInfo): void {
    this.isFolderOpened = false;
    this.isFolderChanging = true;
  }

  private openedFolder(folder: GridLayoutItemInfo): void {
    this.isFolderOpened = true;
    this.isFolderChanging = false;
  }

  private closingFolder(folder: GridLayoutItemInfo): void {
    this.isFolderOpened = false;
    this.isFolderChanging = true;
  }

  private closedFolder(folder: GridLayoutItemInfo): void {
    this.isFolderOpened = false;
    this.isFolderChanging = false;
  }

  private getDescription(): string {
      return 'isFolderOpened: ' + this.isFolderOpened + '\r\n' +
        'isFolderChanging: ' + this.isFolderChanging + '\r\n' +
        'canOpenedFolderDragStart: ' + this.canOpenedFolderDragStart() + '\r\n' +
        'canOpenedFolderDragDrop: ' + this.canOpenedFolderDragDrop();
  }

  /**
   * 文件夹展开态当前是否可以开始拖拽
   * 当前根据重构前的实现，文件夹打开后才允许拖拽
   * @returns 是否可以开始拖拽
   */
  public canOpenedFolderDragStart(): boolean {
    log.showDebug('can opened-folder drag start: %{public}s', this.isFolderOpened);
    return this.isFolderOpened;
  }

  /**
   * 文件夹展开态当前是否可以落位
   *
   * @returns 是否可以开始落位
   */
  public canOpenedFolderDragDrop(): boolean {
    log.showDebug('can opened-folder drag drop: %{public}s', !this.isFolderChanging);
    return !this.isFolderChanging;
  }
}

export let folderDragData: FolderDragData = FolderDragData.getInstance();