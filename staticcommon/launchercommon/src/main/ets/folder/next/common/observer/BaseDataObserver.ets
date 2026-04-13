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

import { GridLayoutItemInfo } from '../../../../TsIndex';
import { FolderAppItemInfo } from '../../../../TsIndex';
import { FoldersData } from '../model/data/FoldersData';
import { image } from '@kit.ImageKit';
import { ContractedFolderMode } from '../../contractedfolder/viewmodel/layout/IContractedFolderObserver';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { BadgeAnimationType } from '../../../../uicomponents/CustomBadge';

const TAG: string = 'BaseDataObserver';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 基础文件夹数据状态变量类
 */
@ObservedV2
export class BaseDataObserver {
  public folderId: string = '';

  @Trace public contractedMode: ContractedFolderMode = ContractedFolderMode.MODE_COMPONENT;

  @Trace public firstPageItems: GridLayoutItemInfo[] = [];

  @Trace public currentPageItems: GridLayoutItemInfo[] = [];

  @Trace public endPageItems: GridLayoutItemInfo[] = [];

  @Trace private mFirstPageIcon: image.PixelMap | null = null;

  @Trace private mEndPageShowIcon: image.PixelMap | null = null;

  @Trace private mCurrentPageIcon: image.PixelMap | null = null;

  @Trace public badgeNum: number = 0;

  @Trace public badgeAniType: BadgeAnimationType = BadgeAnimationType.DEFAULT;

  public constructor(folderId: string) {
    this.folderId = folderId;
  }

  public getFirstPageIcon(): image.PixelMap | null {
    return this.mFirstPageIcon;
  }

  public getCurrentPageIcon(): image.PixelMap | null {
    return this.mCurrentPageIcon;
  }

  public getEndPageShowIcon(): image.PixelMap | null {
    return this.mEndPageShowIcon;
  }

  /**
   * 初始化文件夹数据observer
   *
   * @param folderData
   */
  public init(folderData: FoldersData): void {
  }

  /**
   * 更新首页数据
   *
   * @param items 更新元素
   */
  public setFirstPageItems(items: GridLayoutItemInfo[]): void {
    this.firstPageItems = items;
  }

  /**
   * 更新当前页数据
   *
   * @param items 更新元素
   */
  public setCurrentPageItems(items: GridLayoutItemInfo[]): void {
    this.currentPageItems = items;
  }

  /**
   * 更新尾页数据
   *
   * @param items 更新元素
   */
  public setEndPageItems(items: GridLayoutItemInfo[]): void {
    this.endPageItems = items;
  }

  /**
   * 更新首页截图
   *
   * @param showIcon 截图
   */
  public setFirstPageIcon(showIcon: image.PixelMap | null): void {
    log.showInfo('update folder:%{public}s first page icon:%{public}s', this.folderId, showIcon !== null);
    this.mFirstPageIcon?.release();
    this.mFirstPageIcon = showIcon;
  }

  /**
   * 更新当前页截图
   *
   * @param showIcon 截图
   */
  public setCurrentPageIcon(showIcon: image.PixelMap | null): void {
    log.showInfo('update folder:%{public}s current page icon:%{public}s', this.folderId, showIcon !== null);
    this.mCurrentPageIcon?.release();
    this.mCurrentPageIcon = showIcon;
  }

  /**
   * 更新尾页截图
   *
   * @param showIcon 截图
   */
  public setEndPageIcon(showIcon: image.PixelMap | null): void {
    log.showInfo('update folder:%{public}s end page icon:%{public}s', this.folderId, showIcon !== null);
    this.mEndPageShowIcon?.release();
    this.mEndPageShowIcon = showIcon;
  }

  /**
   * 更新角标
   * @param items 元素
   */
  public updateBadge(items: GridLayoutItemInfo[]): void {
  }
}