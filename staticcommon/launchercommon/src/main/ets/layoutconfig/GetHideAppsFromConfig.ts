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

import { CheckEmptyUtils, FileUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  HideAppAutoAlignStatus,
  LoadHideAppType,
} from '@ohos/commonconstants/src/main/ets/constants/Constants';
import { EvtBus } from '@ohos/frameworkwrapper';
import { HideAppConfigLoadEvent } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { BaseIconInfo } from '../bean/BaseIconInfo';
import HideAppsInfo from '../configs/HideDesktopLayoutInfo';
import { LauncherStartup, StartupStep } from '../tools/LauncherStartup';
import {
  CommonConstants,
  GridLayoutItemInfo,
  LauncherLayoutCacheUtil,
  PageDesktopModel,
  RdbStoreManager,
} from '../TsIndex';
import ConfigParseUtil from '../utils/ConfigParseUtil';

const TAG = 'GetHideAppsFromConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 通过配置文件获取隐藏应用数据
 */
export class GetHideAppsFromConfig {
  private static mInstance: GetHideAppsFromConfig;

  // 配置缓存机制
  public hideApps: Set<string>;
  public hideAppsLayoutItems: GridLayoutItemInfo[] = [];
  public loadStatus: boolean = false; // 加载状态 false:未加载, true:已经加载
  public autoAlignStatus: number; // 隐藏应用后是否自动补齐桌面布局，0（不补齐） 取值1（默认补齐）
  private hideAppConfigLoadEvent: HideAppConfigLoadEvent = new HideAppConfigLoadEvent();

  private constructor() {
    this.hideApps = new Set<string>();
    this.autoAlignStatus = HideAppAutoAlignStatus.AUTO_ALIGN;
  }

  static getInstance(): GetHideAppsFromConfig {
    if (!GetHideAppsFromConfig.mInstance) {
      GetHideAppsFromConfig.mInstance = new GetHideAppsFromConfig();
    }
    return GetHideAppsFromConfig.mInstance;
  }

  public deleteBlankPageFromLayoutInfo(): void {
    // 检查 hideAppsLayoutItems 是否为 null 或 undefined
    if (!this.hideAppsLayoutItems) {
      log.showInfo(`deleteBlankPageFromLayoutInfo -> hideAppsLayoutItems is null or undefined`);
      return;
    }
    log.showInfo(`deleteBlankPageFromLayoutInfo -> hideAppsLayoutItems.length:${this.hideAppsLayoutItems.length}`);
    // 删除空白页
    let pages: Set<number> = new Set<number>();
    for (let index = 0; index < this.hideAppsLayoutItems.length; index++) {
      const page = this.hideAppsLayoutItems[index].page;
      if (page !== undefined && !pages.has(page)) {
        log.showInfo(`deleteBlankPageFromLayoutInfo -> page:${page}`);
        pages.add(page);
        PageDesktopModel.getInstance().deleteBlankPageFromLayoutInfo(page);
      }
    }
  }

  public isHideApp(bundleName: string): boolean {
    const hideKeys = this.getHideConfig();
    return hideKeys.has(bundleName);
  }

  // 缓存隐藏应用
  public saveHideApps(allItemInfos: GridLayoutItemInfo[]): void {
    if (CheckEmptyUtils.isEmptyArr(allItemInfos)) {
      return;
    }
    log.showInfo(`saveHideApps -> start, allItemInfos.length:${allItemInfos.length}`);
    const hideKeys = this.getHideConfig();
    // 如果没有配置隐藏应用则直接返回
    if (hideKeys.size <= 0) {
      return;
    }
    this.hideAppsLayoutItems = allItemInfos.filter(item => {
      return this.isHideIcon(hideKeys, item);
    });
  }

  private updateRegionTypeItemPosition(autoAlignGridLayout: GridLayoutItemInfo[], container: number): void {
    // 无隐藏标准应用时直接返回
    if (CheckEmptyUtils.isEmptyArr(autoAlignGridLayout)) {
      log.showInfo('sortRegionTypeList no hidden desktop icon.');
      return;
    }
    try {
      // 更新布局到数据库
      LauncherLayoutCacheUtil.updateItemWithContainerCallBack(autoAlignGridLayout, container);
    } catch (error) {
      log.showError(`sortRegionTypeList with error.code: ${error?.code}, message: ${error?.message}`);
    }
  }

  // 更新pc大文件夹过滤隐藏应用后的布局应用坐标
  private sortRegionTypeList(layoutInfo: GridLayoutItemInfo[], hideKeys: Set<string>): void {
    if (CheckEmptyUtils.isEmptyArr(layoutInfo)) {
      log.showInfo('regionTypeItem is empty.');
      return;
    }
    layoutInfo.forEach((itemInfo: GridLayoutItemInfo) => {
      if (itemInfo.typeId !== CommonConstants.TYPE_REGION_FOLDER) {
        return;
      }
      itemInfo.layoutInfo?.forEach((regionFolderLayoutInfo: GridLayoutItemInfo[]) => {
        const sortedItems = [...regionFolderLayoutInfo].sort((a, b) => this.compareGridLayoutItemByLocation(a, b));
        const autoAlignGridLayout = this.autoAlignFilterItems(sortedItems, hideKeys, itemInfo.id);
        this.updateRegionTypeItemPosition(autoAlignGridLayout, itemInfo.id ?? 0);
      })
    })
  }

  private autoAlignFilterItems(sortedItems: GridLayoutItemInfo[], hideKeys: Set<string>,
    container?: number): GridLayoutItemInfo[] {
    // 提取所有桌面小图标（area=1*1, container=-100）
    const originalLayout = sortedItems.filter(item =>
      this.isSmallArea(item) && item.container === (container ?? CommonConstants.CONTAINER_DESKTOP)
    );
    let originalLocation: number[][] = [];
    originalLayout.forEach((layoutItem) =>
      originalLocation.push([layoutItem.row ?? 0, layoutItem.column ?? 0, layoutItem.page ?? 0]));
    const autoAlignGridLayout = originalLayout.filter(item => !this.isHideIcon(hideKeys, item));
    // 无隐藏标准应用时直接返回
    if (autoAlignGridLayout.length === originalLocation.length) {
      log.showInfo('No hidden desktop icon.');
      return [];
    }
    // 更新过滤隐藏应用后的布局应用坐标
    this.autoAlign(originalLocation, autoAlignGridLayout);
    return autoAlignGridLayout;
  }

  // 隐藏应用后删除数据库并自动补齐
  public async autoAlignGridLayoutItem(itemList: GridLayoutItemInfo[],
    isZSort: boolean = true): Promise<GridLayoutItemInfo[]> {
    const hideKeys = this.getHideConfig();
    // 如果没有配置隐藏应用则直接返回
    if (hideKeys.size <= 0) {
      return itemList;
    }
    // 保存隐藏应用布局缓存信息,删除空白页时会用到
    this.saveHideApps(itemList);
    // 删除DB的隐藏应用(包括桌面,Dock和文件夹内隐藏的应用)
    await this.checkToRemoveHideApp();
    // 1. 不需要自动补齐逻辑处理
    if (this.autoAlignStatus === HideAppAutoAlignStatus.NOT_AUTO_ALIGN) {
      log.showInfo(`config is not auto align,hideKeys size: ${hideKeys.size}`);
      // 1.1 有隐藏应用则过滤后返回（隐藏应用过滤后所有布局）
      if (hideKeys.size > 0) {
        return this.filterAllHideApp(itemList, hideKeys);
      }
      // 1.2 不需要自动补齐并且无隐藏应用则直接返回原数组
      return itemList;
    }
    log.showInfo(`Hidden apps: ${hideKeys.size}, Total items: ${itemList.length}`);
    // 2. 创建排序副本避免污染原数组
    const sortedItems = [...itemList].sort((a, b) => this.compareGridLayoutItemByLocation(a, b, isZSort));
    // 3. 更新过滤隐藏应用后的布局应用坐标
    const autoAlignGridLayout = this.autoAlignFilterItems(sortedItems, hideKeys);
    // 4. 更新pc大文件夹过滤隐藏应用后的布局应用坐标
    this.sortRegionTypeList(sortedItems, hideKeys);
    // 5. 无隐藏标准应用时直接返回
    if (autoAlignGridLayout.length === 0) {
      log.showInfo('No hidden desktop icon.');
      return this.filterAllHideApp(itemList, hideKeys);
    }
    // 6. 最终过滤（隐藏应用过滤后所有布局）
    const finalLayout = this.filterAllHideApp(sortedItems, hideKeys);
    try {
      // 7.更新布局到数据库
      LauncherLayoutCacheUtil.updateItemToDesktopCallBack(finalLayout);
      LauncherStartup.getInstance().passStep(StartupStep.CONFIG_INTO_DB, `len:${finalLayout?.length}`);
    } catch (error) {
      log.showError(`updateItemToDesktopCallBack with error.code: ${error?.code}, message: ${error?.message}`);
    }
    return finalLayout;
  }

  // 页面布局分页自动补齐逻辑
  public autoAlign(originalLocation: number[][], autoAlignGridLayout: GridLayoutItemInfo[]): void {
    // (1).先按原始页码分组（关键步骤）
    const originalPageMap = new Map<number, number[][]>();
    originalLocation.forEach((tmpPosition: number[], index) => {
      const row = tmpPosition[0];
      const column = tmpPosition[1];
      const page = tmpPosition[2];
      const group = originalPageMap.get(page) || [];
      group.push([row, column, page]);
      originalPageMap.set(page, group);
    });

    // (2). 对过滤后的应用按当前页码分组
    const filteredPageMap = new Map<number, GridLayoutItemInfo[]>();
    autoAlignGridLayout.forEach(item => {
      if (item.page === undefined) {
        return;
      }
      const group = filteredPageMap.get(item.page) || [];
      group.push(item);
      filteredPageMap.set(item.page, group);
    });

    // (3). 逐页处理对齐逻辑
    filteredPageMap.forEach((filteredItems, currentPage) => {
      // 获取当前页对应的原始坐标集合
      const originalPositions = originalPageMap.get(currentPage) || [];
      // 按原始坐标顺序对齐（假设过滤后顺序与原始顺序一致）
      filteredItems.forEach((item, indexInPage) => {
        // 超出原始位置数量
        if (indexInPage >= originalPositions.length) {
          log.error('autoAlignGridLayoutItem index is bigger than original index');
          return;
        }
        const tmpPosition: number[] = originalPositions[indexInPage];
        const originRow = tmpPosition[0];
        const originCol = tmpPosition[1];
        const originPage = tmpPosition[2];
        // 强制保持在本页
        item.page = originPage;
        // 更新坐标（即使相同也重置，确保布局刷新）
        item.row = originRow;
        item.column = originCol;
      });
    });
  }

  //过滤隐藏应用
  public filterHideApp<T extends BaseIconInfo>(itemInfos: T[]): T[] {
    if (CheckEmptyUtils.isEmptyArr(itemInfos)) {
      return itemInfos;
    }
    log.showWarn(`filterHideApp -> start allItemInfos.length:${itemInfos?.length}`);
    const hideKeys = this.getHideConfig();
    if (hideKeys.size <= 0) {
      log.showInfo('hideKeys is null');
      return itemInfos;
    }
    // 2. 过滤保留未隐藏的项
    const finalLayout = itemInfos.filter(item => {
      return !hideKeys.has(item.bundleName);
    });
    log.showWarn(`filterHideApp end finalLayout length:${finalLayout?.length}`);
    return finalLayout;
  }

  // 初始化隐藏app配置文件 1.开机时加载系统预装的隐藏配置;2.oobe修改完隐藏配置刷新桌面重新加载
  public async loadHideConfig(loadHideConfigType?: number): Promise<void> {
    // 如果是刷新必须强制加载
    if (loadHideConfigType !== LoadHideAppType.LOAD_BY_REFRESH && this.loadStatus) {
        return;
    }
    const hideKeys = new Set<string>();
    // 通用场景CCM配置文件读取隐藏应用
    try {
      const hideCfgPath = 'etc/openharmony_launcher_hide_workspace.json';
      const hideCfgFiles = await ConfigParseUtil.getAllConfig(hideCfgPath);
      if (CheckEmptyUtils.isEmptyArr(hideCfgFiles)) {
        log.showWarn('hideCfgFiles is empty');
        this.hideApps = hideKeys;
        this.loadStatus = true;
        this.postHideConfigLoadStatusEvent(true);
        return;
      }
      const hideAppsInfo = this.hideConfigLisTraversal(hideCfgFiles);
      if (hideAppsInfo) {
        for (const hideItem of hideAppsInfo?.hideAppsBundleInfo) {
          const key = hideItem.bundleName;
          hideKeys.add(key);
        }
      }
      this.hideApps = hideKeys;
      this.autoAlignStatus = hideAppsInfo?.autoAlignStatus ?? 1;
      this.loadStatus = true;
      this.postHideConfigLoadStatusEvent(true);
    } catch (error) {
      log.showError(`Failed to load hide config, code: ${error?.code}, message: ${error?.message}`);
    }
  }

  // 是否为小图标
  public isSmallArea(item: GridLayoutItemInfo): boolean {
    return item.area?.[0] === 1 && item.area?.[1] === 1;
  }

  /**
   * 用于 sort 函数中进行比较
   * @param itemA 比较函数中左侧元素, 不能为 `null` 或者 `undefined`
   * @param itemB 比较函数中右侧元素, 不能为 `null` 或者 `undefined`
   * @param isZSort 是否Z字排序，默认true
   * @returns 返回比较结果, 小于0 `itemA < itemB`, 等于 0 `itemA === itemB`, 大于 0 `itemA > itemB`
   */
  public compareGridLayoutItemByLocation(itemA: GridLayoutItemInfo, itemB: GridLayoutItemInfo,
    isZSort: boolean = true): number {
    if (!itemA || !itemB) {
      log.showError('Invalid items for comparison');
      throw new Error('Cannot compare null items');
    }
    // 层级排序：手机 page → row → column  PC page → column → row
    if (itemA.page !== itemB.page) {
      return (itemA.page ?? 0) - (itemB.page ?? 0);
    }
    if (isZSort) {
      if (itemA.row !== itemB.row) {
        return (itemA.row ?? 0) - (itemB.row ?? 0);
      }
      return (itemA.column ?? 0) - (itemB.column ?? 0);
    }
    if (itemA.column !== itemB.column) {
      return (itemA.column ?? 0) - (itemB.column ?? 0);
    }
    return (itemA.row ?? 0) - (itemB.row ?? 0);
  }

  public getHideConfig(): Set<string> {
    // 使用缓存数据（若已经加载隐藏应用配置文件）
    if (this.loadStatus) {
      return this.hideApps;
    }
    log.showError('hide app config has not been loaded');
    return new Set<string>();
  }

  // 删除DB隐藏应用(包括桌面,Dock和文件夹内隐藏的应用)
  private async checkToRemoveHideApp(): Promise<void> {
    const hideKeys = this.getHideConfig();
    let deleteList: GridLayoutItemInfo[] = [];
    try {
      const gridLayoutList = await RdbStoreManager.getInstance().queryAllGridLayoutInfo();
      gridLayoutList.forEach(layoutInfo => {
        if (this.isHideIcon(hideKeys, layoutInfo)) {
          deleteList.push(layoutInfo);
        } else {
          this.processFolderItems(layoutInfo, hideKeys, deleteList);
        }
      });
    } catch (err) {
      log.showError(`checkToRemoveHideApp query database failed ${err?.code}, ${err?.message}`);
    }
    log.showInfo(`checkToRemoveHideApp deleteList length: ${deleteList.length}`);
    if (!CheckEmptyUtils.isEmptyArr(deleteList)) {
      LauncherLayoutCacheUtil.deleteLayoutInfoById(deleteList);
    }
  }
  
  // 过滤所有app包括文件夹里面的
  private filterAllHideApp(layoutInfo: GridLayoutItemInfo[], hideKeys: Set<string>): GridLayoutItemInfo[] {
    return layoutInfo.filter(item => {
      if (this.isHideIcon(hideKeys, item)) {
        return false;
      }
      if (item.typeId === CommonConstants.TYPE_FOLDER) {
        if (!item.layoutInfo) {
          return true;
        }

        // 查找文件夹中是否有要过滤的图标
        let findItems: GridLayoutItemInfo | undefined =
          item.layoutInfo.flat().find(info => this.isHideIcon(hideKeys, info));

        // 如果文件夹中没有要过滤的图标，不做处理
        if (!findItems) {
          return true;
        }
        log.showInfo(`folder ${item.folderId} contain hide app, layoutInfo length:${item.layoutInfo.flat().length}`);
        item.layoutInfo = item.layoutInfo.map(folderPage => {
          return folderPage.filter(info => !this.isHideIcon(hideKeys, info));
        });
        return item.layoutInfo.flat().length > 1;
      }
      if (item.typeId === CommonConstants.TYPE_REGION_FOLDER) {
        item.layoutInfo = item.layoutInfo?.map(folderPage => {
          return folderPage.filter(info => !this.isHideIcon(hideKeys, info));
        });
        log.showInfo(`region folder layoutInfo length:${item.layoutInfo?.flat().length}`);
      }
      return true;
    });
  }

  // 将文件夹的隐藏应用添加到删除列表
  private processFolderItems(layoutInfo: GridLayoutItemInfo, hideKeys: Set<string>,
    deleteList: GridLayoutItemInfo[]): void {
    if ((layoutInfo.typeId === CommonConstants.TYPE_FOLDER ||
      layoutInfo.typeId === CommonConstants.TYPE_REGION_FOLDER) &&
      layoutInfo.layoutInfo) {
      const folderItems = layoutInfo.layoutInfo.flatMap(items => items);
      const hiddenItems = folderItems.filter(item => this.isHideIcon(hideKeys, item));
      deleteList.push(...hiddenItems);
    }
  }

  public hideConfigLisTraversal(cfgFiles: string[]): HideAppsInfo | null {
    let configList: Array<HideAppsInfo> = [];
    let mHideLayout: HideAppsInfo | null = null;
    if (CheckEmptyUtils.isEmptyArr(cfgFiles)) {
      return mHideLayout;
    }
    cfgFiles.forEach((filePath) => {
      try {
        log.showInfo('Succeeded in obtaining the CCM hide layout configuration file.');
        const layout: HideAppsInfo = FileUtils.readJsonFile(filePath);
        configList.push(layout);
      } catch (error) {
        log.showError(`Failed to parse hideConfig code: ${error?.code}, message: ${error?.message}`);
      }
    });
    // 处理无有效配置的情况
    if (configList.length > 0) {
      mHideLayout = new HideAppsInfo();
      mHideLayout.autoAlignStatus = HideAppAutoAlignStatus.NOT_AUTO_ALIGN;
      for (const item of configList) {
        mHideLayout.hideAppsBundleInfo = mHideLayout.hideAppsBundleInfo.concat(item.hideAppsBundleInfo);
        if (item.autoAlignStatus === HideAppAutoAlignStatus.AUTO_ALIGN) {
          mHideLayout.autoAlignStatus = HideAppAutoAlignStatus.AUTO_ALIGN;
        }
      }
    }
    return mHideLayout;
  }

  // 是否为隐藏应用图标,并且不是卡片
  private isHideIcon(hideKeys: Set<string>, item: GridLayoutItemInfo): boolean {
    return hideKeys.has(item.bundleName) && item.typeId !== CommonConstants.TYPE_CARD;
  }

  /**
   * 发送隐藏应用配置加载状态事件
   *
   * @param isLoad 隐藏应用配置是否加载
   */
  private postHideConfigLoadStatusEvent(isLoad: boolean): void {
    this.hideAppConfigLoadEvent.loadStatus = isLoad;
    EvtBus.post(HideAppConfigLoadEvent, this.hideAppConfigLoadEvent);
  }
}