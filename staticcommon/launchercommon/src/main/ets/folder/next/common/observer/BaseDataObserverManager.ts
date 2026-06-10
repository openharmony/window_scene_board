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
  ContractedFolderMode,
  editModeManager,
  FolderAccessibilityUtil,
  FolderAppItemInfo,
  FolderCommonConstants,
  FolderCommonUtil,
  FolderManager,
  GridLayoutItemInfo,
  GridLayoutUtil,
  IContractedFolderObserver,
  OBSERVER_DATA
} from '../../../../TsIndex';
import { FoldersData } from '../model/data/FoldersData';
import { image } from '@kit.ImageKit';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { AccessibilityManager } from '@ohos/frameworkwrapper';

const TAG = 'BaseDataObserverManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
/**
 * BadgeAnimationType.HIDE_WITHOUT_ANIM
 */
const BADGE_HIDE: number = 7;

/**
 * 文件夹数据observer管理
 */
export class BaseDataObserverManager {
  private folderId: string = '';
  private dataOsr: IContractedFolderObserver;
  private isSmall: boolean = false;
  private mFolderMgr: FolderManager;

  public constructor(folderId: string, osr: IContractedFolderObserver) {
    this.folderId = folderId;
    this.dataOsr = osr;
    this.mFolderMgr = FolderManager.getInstance();
    let area: number[] = this.mFolderMgr.getFolder(folderId).getGridInfo().area ?? [];
    this.isSmall = FolderCommonUtil.isLayout1X1(area);
    AccessibilityManager.getInstance().registerAccessibilityChangeCallback(TAG + this.folderId,
      this.accessibilityChangeCallback)
  }

  private accessibilityChangeCallback = (): void => {
    this.updateAccessibilityText();
  }

  /**
   * 更新首页元素
   *
   * @param msg 用于DFX的日志
   * @param items 更新元素列表
   */
  public setFirstPageItems(msg: string, items: GridLayoutItemInfo[]): void {
    this.dataOsr.setData(msg, OBSERVER_DATA.FIRST_PAGE_DATA, items);
  }

  /**
   * 获取首页元素列表
   *
   * @returns 首页元素列表
   */
  public getFirstPageItems(): GridLayoutItemInfo[] {
    return this.dataOsr.getData(OBSERVER_DATA.FIRST_PAGE_DATA) as GridLayoutItemInfo[];
  }

  /**
   * 更新尾页元素
   *
   * @param msg 用于DFX的日志
   * @param items 更新元素列表
   */
  public setEndPageItems(msg: string, items: GridLayoutItemInfo[]): void {
    this.dataOsr.setData(msg, OBSERVER_DATA.END_PAGE_DATA, items);
  }

  /**
   * 获取尾页元素列表
   *
   * @returns
   */
  public getEndPageItems(): GridLayoutItemInfo[] {
    return this.dataOsr.getData(OBSERVER_DATA.END_PAGE_DATA) as GridLayoutItemInfo[];
  }

  /**
   * 更新当前页元素
   *
   * @param msg 用于DFX的日志
   * @param items 更新元素列表
   */
  public setCurrentPageItems(msg: string, items: GridLayoutItemInfo[]): void {
    this.dataOsr.setData(msg, OBSERVER_DATA.CURRENT_PAGE_DATA, items);
  }

  /**
   * 设置首页截图
   *
   * @param msg 用于DFX的日志
   * @param image 截图
   */
  public setFirstPageIcon(msg: string, image: image.PixelMap): void {
    this.dataOsr.setImage(msg, OBSERVER_DATA.FIRST_PAGE_DATA, image);
  }

  /**
   * 设置尾页截图
   *
   * @param msg 用于DFX的日志
   * @param image 截图
   */
  public setEndPageIcon(msg: string, image: image.PixelMap): void {
    this.dataOsr.setImage(msg, OBSERVER_DATA.END_PAGE_DATA, image);
  }

  /**
   * 设置当前页截图
   *
   * @param msg 用于DFX的日志
   * @param image 截图
   */
  public setCurrentPageIcon(msg: string, image: image.PixelMap): void {
    this.dataOsr.setImage(msg, OBSERVER_DATA.CURRENT_PAGE_DATA, image);
  }

  /**
   * 是否小文件夹
   *
   * @returns true小文件夹
   */
  public isSmallFolder(): boolean {
    return this.isSmall;
  }

  /**
   * 刷新首页显示的应用列表
   *
   * @param msg 用于DFX日志
   */
  public updateShowList(msg: string): void {
    let folder: FoldersData = this.mFolderMgr.getFolder(this.folderId);
    this.setFirstPageItems(msg, folder.getContractedFolderShowItems());
    this.setEndPageItems(msg, folder.getLastPageItems());
    this.updateBadge(folder.getItems(), `updateShowList ${folder.getFolderName()}`);
    this.updateAccessibilityText();
  }

  /**
   * 更新角标
   * @param items
   */
  public updateBadge(items: GridLayoutItemInfo[], msg: string): void {
    log.showWarn(`updateBadge from ${msg}`);
    this.dataOsr.updateBadge(items);
    this.updateAccessibilityText();
  }

  /**
   * 角标动效
   * @param type 动效类型
   * @param msg 用于DFX日志
   */
  public updateBadgeAniType(type: number, msg: string): void {
    let isEditMode: boolean = editModeManager.isInEditMode();
    log.showWarn(`updateBadgeAnimator to ${type} from ${msg}, isEditMode:${isEditMode}`);
    this.dataOsr.updateBadgeAniType(isEditMode ? BADGE_HIDE : type);
  }

  /**
   * 刷新当前页的应用列表
   *
   * @param msg 用于DFX的日志
   * @param isCreate 是否创建文件夹
   */
  public updateCurrentList(msg: string, isCreate: boolean): void {
    let folder: FoldersData = this.mFolderMgr.getFolder(this.folderId);
    if (folder.isEmptyGrid()) {
      log.showError('%{public}s, update currentList error');
      return;
    }
    let currentList: GridLayoutItemInfo[] = folder.getItemsByPageIndex(isCreate ? 0 : folder.getFolderPages() - 1);
    let pageCount:number = GridLayoutUtil.getCountPerPageFolderOpen();
    let showLen: number = ((currentList.length - 1) % pageCount);
    if (showLen >= FolderCommonConstants.DEFAULT_FOLDER_SHOW_LENGTH &&
      showLen < pageCount) {
      this.mFolderMgr.setLastAnimateInfo(folder.getLastItem());
    }
    this.setCurrentPageItems(msg, currentList);
  }

  /**
   * 设置拖入堆叠最后一个动效元素节点数据
   *
   * @param msg 用于DFX日志打印
   */
  public setLastAppInfo(msg: string): void {
    let folder: FoldersData = this.mFolderMgr.getFolder(this.folderId);
    let lastItem: GridLayoutItemInfo = folder.getLastItem();
    log.showInfo('%{public}s : update last app info bundle %{public}s', msg, lastItem?.keyName);
    this.mFolderMgr.setLastAnimateInfo(lastItem);
  }

  /**
   * 设置文件夹mode
   *
   * @param msg 用于DFX日志打印
   * @param folderId 文件夹id
   * @param mode 文件夹mode
   */
  public setFolderModel(msg: string, mode: ContractedFolderMode): void {
    log.showWarn(`setFolderMode ${mode} from ${msg}`);
    this.dataOsr.setMode(msg, mode);
  }

  /**
   * 设置文件夹名字
   *
   * @param folderName 文件夹名字
   */
  public setFolderName(folderName: string): void {
    this.dataOsr.setFolderName(folderName);
    this.updateAccessibilityText();
  }

  /**
   * 更新文件夹数据
   *
   * @param msg 用于DFX日志
   * @param type 更新的数据类型
   * @param items 元素列表
   */
  public setData(msg: string, type: number, items: GridLayoutItemInfo[] | FolderAppItemInfo[]): void {
    this.dataOsr.setData(msg, type, items);
  }

  /**
   * 设置多选选中元素的keyname列表
   *
   * @param selectNames 选中元素的keyname列表
   */
  public setSelectItemNames(selectNames: string[]): void {
    return this.dataOsr.setSelectItemNames(selectNames);
  }

  /**
   * 获取多选选中元素的keyname列表
   *
   * @returns 选择元素的keyname列表
   */
  public getSelectItemNames(): string[] {
    return this.dataOsr.getSelectItemNames();
  }

  /**
   * 文件夹是否显示的截图
   *
   * @returns true显示截图
   */
  public isShowModeImage(): boolean {
    return this.dataOsr.isFolderImageMode();
  }


  /**
   * 是否首页截图存在
   *
   * @returns true 首页截图存在
   */
  public isFolderImageExist(): boolean {
    return !CheckEmptyUtils.isEmpty(this.dataOsr.getImage(OBSERVER_DATA.FIRST_PAGE_DATA));
  }

  /**
   * 更新无障碍播报内容
   * @param value
   */
  public updateAccessibilityText(): void {
    const isAccessibilityMode: boolean = AccessibilityManager.getInstance().getIsAccessibilityMode();
    if (!isAccessibilityMode) {
      log.showInfo(`Currently not in accessibility mode, no update required.`);
      return;
    }
    let accessibilityText: string = FolderAccessibilityUtil.getFolderReaderText(this.folderId, this.isSmall,
      this.dataOsr.getBadgeNumber());
    this.dataOsr.updateAccessibilityText(accessibilityText);
  }

  /**
   * 反注册方法
   */
  public unRegisterAll(): void {
    AccessibilityManager.getInstance().unRegisterAccessibilityChangeCallback(TAG + this.folderId,
      this.accessibilityChangeCallback);
  }
}