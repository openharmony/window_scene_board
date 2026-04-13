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
import { DragItemPosition } from '@ohos/componentdrag';
import { AppItemInfo, } from '@ohos/launchercommon/src/main/ets/TsIndex';

import { AppLayoutInfo } from '../viewmodel/AppLayoutInfo';
import { FoldedDeviceAcViewModel } from '../../folded/FoldedDeviceAcViewModel';
import DefaultAppCacheManager from './DefaultAppCacheManager';
import { FoldedAppCacheManager } from '../../folded/FoldedAppCacheManager';

const TAG = 'AppGridLayoutCacheManager';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export default class AppGridLayoutCacheManager {
  private static sInstance: AppGridLayoutCacheManager | undefined = undefined;
  private mCacheMgrImpl: DefaultAppCacheManager | undefined = undefined;

  private constructor() {
    log.showInfo('constructor');
       if (!FoldedDeviceAcViewModel.getInstance().isFoldedDevice()) {
      this.mCacheMgrImpl = new DefaultAppCacheManager();
    } else {
      log.showInfo('Create cache implementation for fold device');
      this.mCacheMgrImpl = new FoldedAppCacheManager();
    }
  }

  static getInstance(): AppGridLayoutCacheManager {
    if (!AppGridLayoutCacheManager.sInstance) {
      AppGridLayoutCacheManager.sInstance = new AppGridLayoutCacheManager();
    }
    return AppGridLayoutCacheManager.sInstance;
  }

  public setAppGridLayoutItemList(appGridLayoutItemList: AppLayoutInfo[]): void {
    this.mCacheMgrImpl?.setAppGridLayoutItemList(appGridLayoutItemList);
  }

  public setAndUpdateAppListForPkgChange(appGridLayoutItemList: AppLayoutInfo[], changedItem?: AppItemInfo): void {
    this.mCacheMgrImpl?.setAndUpdateAppListForPkgChange(appGridLayoutItemList, changedItem);
  }

  public updateAppPageList(appGridLayoutItemList: AppLayoutInfo[], newAddItem?: AppItemInfo): void {
    this.mCacheMgrImpl?.updateAppPageList(appGridLayoutItemList, newAddItem);
  }

  public getAppGridLayoutItemList(clone: boolean = true): AppLayoutInfo[] {
    return this.mCacheMgrImpl?.getAppGridLayoutItemList(clone) ?? [];
  }

  public getAppGridLayoutItemsByPage(pageIndex: number): AppItemInfo[] {
    return this.mCacheMgrImpl?.getAppGridLayoutItemsByPage(pageIndex) ?? [];
  }

  public getAppItemList(): AppItemInfo[] {
    return this.mCacheMgrImpl?.getAppItemList() ?? [];
  }

  public getPages(): number[] {
    return this.mCacheMgrImpl?.getPages() ?? [];
  }

  public getPageCount(): number {
    return this.mCacheMgrImpl?.getPageCount() ?? 0;
  }

  /**
   * 从缓存中删除元素
   * @param bundleName
   * @returns
   */
  public deleteCachedLayoutItem(bundleName: string, isOperateDb: boolean = true, appIndex: number = 0): boolean {
    return this.mCacheMgrImpl?.deleteCachedLayoutItem(bundleName, isOperateDb, appIndex) ?? false;
  }

  /**
   * 缓存中查找元素
   * @param bundleName
   * @returns
   */
  public findAppItem(bundleName: string): AppItemInfo | undefined {
    return this.mCacheMgrImpl?.findAppItem(bundleName) ?? undefined;
  }
  /**
   *
   * @param pagedAppList
   * @param bundleName
   * @param appIdx
   * @returns
   */
  public lookForApp(pagedAppList: AppLayoutInfo[], bundleName: string, appIdx?: number): AppItemInfo | undefined {
    return this.mCacheMgrImpl?.lookForApp(pagedAppList, bundleName, appIdx) ?? undefined;
  }

  /**
   * 已知页码快速查找App
   *
   * @param bundleName
   * @param pageIdx
   * @param appIdx
   * @returns
   */
  public findApp(bundleName: string, pageIdx: number, appIdx?: number): AppItemInfo | undefined {
    return this.mCacheMgrImpl?.findApp(bundleName, pageIdx, appIdx) ?? undefined;
  }

  /**
   * 指定页是否空白
   * @param pageIndex
   * @returns
   */
  public isBlankPage(pageIndex: number): boolean {
    return this.mCacheMgrImpl?.isBlankPage(pageIndex) ?? false;
  }

  /**
   * 添加新页
   */
  public addBlankPage(): boolean {
    return this.mCacheMgrImpl?.addBlankPage() ?? false;
  }

  /**
   * 删除空白页
   * @returns
   */
  public deleteBlankPage(dataSource?: AppLayoutInfo[]): boolean {
    return this.mCacheMgrImpl?.deleteBlankPage(dataSource) ?? false;
  }

  public isFullPage(page: number): boolean {
    return this.mCacheMgrImpl?.isFullPage(page) ?? false;
  }

  /**
   * 跨页拖拽时，处理对应元素
   * @param startItem
   * @returns
   */
  public updateItemForDifferentPage(startPos: DragItemPosition, endItem: AppItemInfo,
    isOperateDb: boolean = true): boolean {
    return this.mCacheMgrImpl?.updateItemForDifferentPage(startPos, endItem, isOperateDb) ?? false;
  }

  /**
   * 按当前顺序，给数据分配宫格
   * @param appLayoutInfo
   */
  public putAppItemToGrid(appLayoutInfo: AppLayoutInfo[]): void {
    this.mCacheMgrImpl?.putAppItemToGrid(appLayoutInfo);
  }

  /**
   * 位置偏移修正
   */
  public correctSelfPosition(): void {
    this.mCacheMgrImpl?.correctSelfPosition();
  }

  /**
   * 更新图标位置
   * @param updateItems
   * @param operationDataSource
   * @param isOperateDb
   */
  public updateItemPositionById(updateItems: AppItemInfo[], operationDataSource?: AppLayoutInfo[],
    isOperateDb: boolean = true): boolean {
    return this.mCacheMgrImpl?.updateItemPositionById(updateItems, operationDataSource, isOperateDb) ?? false;
  }

  /**
   * 校验数据中是否有重复位置元素
   * @param layoutPageInfo
   * @returns
   */
  public checkIfDuplicatePos(layoutPageInfo: AppLayoutInfo[]): boolean {
    return this.mCacheMgrImpl?.checkIfDuplicatePos(layoutPageInfo) ?? false;
  }

  /**
   * 排序指定页面
   */
  public sortAllData(pageIndex?: number[]): void {
    this.mCacheMgrImpl?.sortAllData(pageIndex);
  }

  /**
   * 宫格数据排序
   * @param pageItemInfos
   */
  public sortPageData(pageItemInfos: AppItemInfo[]): void {
    this.mCacheMgrImpl?.sortPageData(pageItemInfos);
  }

  /**
   * 获取图标位移的下一个位置
   * @param isSqueezeBack 是否向后挤位
   * @param row 图标当前所在行
   * @param column 图标当前所在列
   * @returns 能找到下一个合法位置，则返回对应位置，否则返回undefined
   */
  public getNextPosition(isSqueezeBack: boolean, row: number | undefined,
    column: number | undefined, page: number | undefined = undefined): number[] | undefined {
    return this.mCacheMgrImpl?.getNextPosition(isSqueezeBack, row, column, page) ?? undefined;
  }

  public reorderAllAppInPages(): void {
    this.mCacheMgrImpl?.reorderAllAppInPages();
  }

  public updateAppInstallStatus(item: AppItemInfo): void {
    this.mCacheMgrImpl?.updateAppInstallStatus(item);
  }
  public afterSetAppGridLayoutItemList(appGridLayoutItemList: AppLayoutInfo[]): void {
    this.mCacheMgrImpl?.afterSetAppGridLayoutItemList(appGridLayoutItemList);
  }
  public beyondOneScreen(pages: number): boolean {
    return this.mCacheMgrImpl?.beyondOneScreen(pages) ?? true;
  }
}