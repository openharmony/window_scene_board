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

import { BaseDataObserver } from './BaseDataObserver';
import { FolderAppItemInfo, GridLayoutItemInfo } from '../../../../TsIndex';
import { FoldersData } from '../model/data/FoldersData';
import { FolderSnapInfo, FolderSnapshotManager } from '../manager/FolderSnapshotManager';
import { image } from '@kit.ImageKit';
import { ContractedFolderMode } from '../../contractedfolder/viewmodel/layout/IContractedFolderObserver';
import { LogDomain, Logger } from '@ohos/basicutils';
import { FolderCommonUtil } from '../FolderCommonUtil';
import { BadgeAnimationType } from '../../../../uicomponents/CustomBadge';

const TAG: string = 'SmallFolderDataObserver';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
const iconLog: Logger = Logger.getLogHelper(LogDomain.ICON);

/**
 * 小文件夹数据状态变量类
 */
@ObservedV2
export class SmallFolderDataObserver extends BaseDataObserver {
  /**
   * 初始化小文件夹数据observer
   *
   * @param folderData
   */
  public init(folderData: FoldersData): void {
    const showItems: GridLayoutItemInfo[] = folderData.getContractedFolderShowItems();
    this.firstPageItems = showItems;
    const updateFstPage: (image: image.PixelMap) => void = (image: image.PixelMap): void => {
      this.setFirstPageIcon(image);
      this.contractedMode = ContractedFolderMode.MODE_IMAGE;
    }
    const fstSnapInfo: FolderSnapInfo = this.getFolderSnapInfo(false, false, showItems, updateFstPage);
    fstSnapInfo.mIsFirstBuild = true;
    FolderSnapshotManager.getInstance().notifyRefresh(this.folderId, fstSnapInfo);
    this.currentPageItems = showItems;
    const endItems: GridLayoutItemInfo[] = folderData.getLastPageItems();
    this.endPageItems = endItems;
    const updateEndPage: (image: image.PixelMap) => void = (image: image.PixelMap): void => {
      this.setEndPageIcon(image);
    }
    const endSnapInfo: FolderSnapInfo = this.getFolderSnapInfo(true, false, endItems, updateEndPage);
    FolderSnapshotManager.getInstance().notifyRefresh(this.folderId, endSnapInfo);
    this.updateBadge(folderData.getItems());
  }

  public updateBadge(items: GridLayoutItemInfo[]): void {
    let newNum: number = FolderCommonUtil.calculateBadgeNum(items);
    iconLog.showError(TAG, `${this.folderId} updateBadge:${newNum}`);
    if (this.badgeNum <= 0 && newNum > 0) {
      this.badgeAniType = BadgeAnimationType.CLOSE_FOLDER_COMPONENT_SHOW;
      this.badgeNum = newNum;
    } else {
      this.badgeNum = newNum;
    }
  }

  /**
   * 更新首页数据与截图
   *
   * @param items 更新元素
   */
  public setFirstPageItems(items: GridLayoutItemInfo[]): void {
    super.setFirstPageItems(items);
    if (items.length === 0) {
      this.setFirstPageIcon(null);
      return;
    }
    const updateFstPage: (image: image.PixelMap) => void = (image: image.PixelMap): void => {
      this.setFirstPageIcon(image);
    }
    const fstSnapInfo: FolderSnapInfo = this.getFolderSnapInfo(false, false, items, updateFstPage);
    FolderSnapshotManager.getInstance().notifyRefresh(this.folderId, fstSnapInfo);
  }

  /**
   * 更新尾页数据与截图
   *
   * @param items 更新元素
   */
  public setEndPageItems(items: GridLayoutItemInfo[]): void {
    super.setEndPageItems(items);
    if (items.length === 0) {
      this.setEndPageIcon(null);
      return;
    }
    const updateEndPage: (image: image.PixelMap) => void = (image: image.PixelMap): void => {
      this.setEndPageIcon(image);
    }
    const endSnapInfo: FolderSnapInfo = this.getFolderSnapInfo(true, false, items, updateEndPage);
    FolderSnapshotManager.getInstance().notifyRefresh(this.folderId, endSnapInfo);
  }

  public setCurrentPageIcon(showIcon: image.PixelMap | null): void {
    if (this.getFirstPageIcon() === null) {
      log.showWarn(TAG, 'getCurrentPageIcon skip for firstIcon null');
      showIcon?.release();
      super.setCurrentPageIcon(null);
      return;
    }
    super.setCurrentPageIcon(showIcon);
    if (this.contractedMode !== ContractedFolderMode.MODE_IMAGE && this.getCurrentPageIcon() !== null) {
      log.showInfo(TAG, 'change to imageMode by setCurrentPageIcon when folder close');
      this.contractedMode = ContractedFolderMode.MODE_IMAGE;
    }
  }

  private getFolderSnapInfo(isEndPage: boolean, isCurrent: boolean, items: GridLayoutItemInfo[],
    callback: (image: image.PixelMap) => void): FolderSnapInfo {
    const snapInfo: FolderSnapInfo = new FolderSnapInfo();
    snapInfo.folderId = this.folderId;
    snapInfo.mIsEndPage = isEndPage;
    snapInfo.mIsCurrent = isCurrent;
    snapInfo.callback = callback;
    snapInfo.items = items;
    return snapInfo;
  }

  public setCurrentPageItems(items: GridLayoutItemInfo[]): void {
    super.setCurrentPageItems(items);
    if (items.length === 0) {
      this.setCurrentPageIcon(null);
    }
  }
}