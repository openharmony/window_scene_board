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
import { CheckEmptyUtils, LogDomain, LogHelper, SingletonHelper, RectInfo } from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';
import { RectangularCoordinates } from '@ohos/componenthelper';
import { EditModeUtils, FolderConstants, folderLayoutUtil, GridLayoutItemInfo } from '../../TsIndex';
import { FolderData, FolderDataCallback, PriorityLevel } from './FolderData';

const TAG = 'FolderGestureData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/*
 * 原先共享转场时文件夹展开态是直接下树，通过共享元素完成动画，所以动效过程中手势完全不响应，重构后通过展开态元素完成动效则需要对展开态元素完成
 * 各类型手势屏蔽，特添加此类
 */
export class FolderGestureData {
  // 打开或关闭文件夹动效过程中，是否展开态图标支持点击
  private isOpenFolderIconTouchEnabled: boolean = false;
  /**
   * 文件夹+Dialog是否打开状态
   */
  private isAddDialogOpen: boolean = false;
  private folderLifeCallback: FolderDataCallback = {
    moduleName: 'folderDragData',
    priority: PriorityLevel.HIGHER, /* 数据状态类，优先级放到最高 */
    openingFolderCallback: (folder: GridLayoutItemInfo) => { this.openingFolder(folder) },
    openedFolderCallback: (folder: GridLayoutItemInfo) => { this.openedFolder(folder) },
    closingFolderCallback: (folder: GridLayoutItemInfo) => { this.closingFolder(folder) },
    closedFolderCallback: (folder: GridLayoutItemInfo) => { this.closedFolder(folder) },
  };

  public registerCallback(): void {
    FolderData.getInstance().registerCallBack(this.folderLifeCallback);
  }

  public unregisterCallback(): void {
    FolderData.getInstance().unregisterCallBack(this.folderLifeCallback);
  }

  private openingFolder(folder: GridLayoutItemInfo): void {
    this.setOpenFolderIconTouchEnabled(false);
  }

  private openedFolder(folder: GridLayoutItemInfo): void {
    this.setOpenFolderIconTouchEnabled(true);
  }

  private closingFolder(folder: GridLayoutItemInfo): void {
    this.setOpenFolderIconTouchEnabled(false);
  }

  private closedFolder(folder: GridLayoutItemInfo): void {
    this.setOpenFolderIconTouchEnabled(true);
  }

  /**
   * 设置打开关闭过程中图标是否支持触摸
   */
  public setOpenFolderIconTouchEnabled(enabled: boolean = true): void {
    log.showInfo(`setOpenFolderIconTouchEnabled ${enabled}`);
    this.isOpenFolderIconTouchEnabled = enabled;
  }

  /**
   * 设置文件夹+Dialog是否打开状态
   *
   * @param isOpen 文件夹+Dialog是否打开状态
   */
  public setAddDialogOpening(isOpen: boolean): void {
    this.isAddDialogOpen = isOpen;
  }

  /**
   * 文件夹+Dialog是否打开状态
   *
   * @returns true: 文件夹+Dialog打开状态
   */
  public isAddDialogOpening(): boolean {
    return this.isAddDialogOpen;
  }

}

export let folderGesData: FolderGestureData = SingletonHelper.getInstance(FolderGestureData, TAG);