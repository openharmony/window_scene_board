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
import { CheckEmptyUtils, CommonUtils, FileUtils, LogDomain, Logger } from '@ohos/basicutils';
import { GlobalContext, ResourceManager  } from '@ohos/frameworkwrapper';
import { AppStatus } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import {
  AppCategoryInfoManager,
  AppItemInfo,
  AppModel,
  CommonConstants,
  DesktopPosition,
  GetLayoutInfoFromConfig,
  LayoutDescription,
  GridLayoutItemInfo,
  GridLayoutUtil,
  launcherAbilityManager,
  LaunchLayoutCacheManager,
  RdbStoreManager,
  scbBlankPositionUtils,
} from '@ohos/launchercommon';
import { promptAction } from '@kit.ArkUI';
import { util } from '@kit.ArkTS';
import type ctx from '@ohos.app.ability.common';
import DesktopAddDialogConstant from './DesktopAddDialogConstant';
import configPolicy from '@ohos.configPolicy';
import { NumberConstants } from '@ohos/commonconstants';
import { PinyinSort } from '@ohos/frameworkpinyin';
import {
  BusinessType
} from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { launcherStatusUtil } from '@ohos/windowscene';

export const FOLDER_ADD_SHEET_OTHER: string = 'folder_add_sheet_other';
const SOCIAL_CATEGORT: string = 'app_category_social';
const TRAVEL_NAVIGATION_CATEGORY: string = 'app_category_travel_navigation';
const TAG = 'SCBDesktopAddViewModel';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

export class SCBDesktopAddViewModel {
  private static sInstance: SCBDesktopAddViewModel;
  private cacheManager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
  private addListColumn: number = 4;
  public desktopAddDialogShowInfo = new DesktopAddDialogShowInfo();
  private allAppList: GridLayoutItemInfo[] = [];
  private presetAppList: string[] = [];
  private containAppList: string [] = [];
  private removedAppList: string [] = [];
  private allAppBundleName: string[] = [];

  /**
   * SCBDesktopAddViewModel单例
   * @returns sInstance
   */
  static getInstance(): SCBDesktopAddViewModel {
    if (SCBDesktopAddViewModel.sInstance === undefined) {
      SCBDesktopAddViewModel.sInstance = new SCBDesktopAddViewModel();
    }
    return SCBDesktopAddViewModel.sInstance;
  }

  /**
   * 将是否显示反选框的标志位置为false，用于back，home手势，息屏等关闭反选框
   */
  public closeDesktopAddDialog() {
    this.desktopAddDialogShowInfo.isDesktopDialogShow = false;
    launcherStatusUtil.setDesktopAddModeStatus(false);
  }

  /**
   * 刷新本次被移除的应用信息，用于广播
   * @param newRemoveAppList: GridLayoutItemInfo[]
   */
  public refreshRemovedAppList(newRemoveAppList: GridLayoutItemInfo[]): void {
    this.removedAppList = [];
    newRemoveAppList.forEach(item => {
      this.removedAppList.push(item.bundleName);
    })
    log.showInfo(TAG, `DesktopAddDialog removedAppList is ${this.removedAppList}`);
  }

  /**
   * 刷新本次已经被添加到桌面的应用，用于其他领域获取
   * @param newContainAppList: GridLayoutItemInfo[]
   */
  public refreshContainAppList(newContainAppList: GridLayoutItemInfo[]): void {
    this.containAppList = [];
    newContainAppList.forEach(item => {
      this.containAppList.push(item.bundleName);
    })
    log.showInfo(TAG, `DesktopAddDialog containAppList is ${this.containAppList}`);
  }

  /**
   * 刷新目前的全应用集
   */
  public refreshAllAppList():void {
    this.allAppList = [];
    this.allAppList = this.getAllApps();
    log.showInfo(TAG, `refreshAllAppList deone, allAppList length is ${this.allAppList.length}`);
  }

  /**
   * 刷新目前已经被添加到桌面的应用集，用于重启初始化
   */
  public async initQuerySelectItem():Promise<void> {
    const itemList: GridLayoutItemInfo[] = await RdbStoreManager.getInstance().queryAllGridLayoutInfo();
    let containsItemList: GridLayoutItemInfo[] = []
    itemList.forEach(item => {
      if (item.intent?.includes('userAdd')) {
        containsItemList.push(item);
      }
    })
    this.refreshContainAppList(containsItemList);
  }

  /**
   * 提供本次移除的应用信息，提供对外调用
   * @returns this.removedAppList: string []
   */
  public getRemovedAppList(): string[] {
    return this.removedAppList;
  }

  /**
   * 提供目前已经添加到桌面的应用信息，提供对外调用
   * @returns this.containAppList: string []
   */
  public getContainAppList(): string [] {
    return this.containAppList;
  }

  /**
   * 展示最大可添加应用的Toast
   */
  public showToast(resId: string): void {
    try {
      promptAction.showToast({
        message: $r(resId)
      });
    } catch (err) {
      log.showError(TAG, 'showToast failed: ${public}d: %{public}s', err.code, err.message);
    }
  }

  /**
   * 获取最大可添加应用数
   * @returns number 最大可添加应用数
   */
  public getMaxAppCount(): number {
    return 0;
  }

  /**
   * 获取Dialog中Grid的列显示属性
   * @returns columnsTemplate.trim(): string 列模板化属性
   */
  public getColumnsTemplate(): string {
    let columnsTemplate = '';
    for (let index = 0; index < this.getDialogGridColumns(); index++) {
      columnsTemplate += '1fr ';
    }
    return columnsTemplate.trim();
  }

  /**
   * 获取Dialog中Grid列数
   * @returns this.addListColumn: number 列数
   */
  public getDialogGridColumns(): number {
    return this.addListColumn;
  }

  /**
   * 获取应用的分类Id
   * @param appList: DesktopAddItemInfo[] 应用信息集合
   */
  private setDesktopAddItemInfoCatId(appList: DesktopAddItemInfo[]): void {
    if (AppCategoryInfoManager.getInstance().isNeedRefreshAppCatIdMap()) {
      AppCategoryInfoManager.getInstance().initAllAppCatInfo(this.allAppBundleName); //不同步等待，异步执行
    }
    appList.forEach(item => {
      item.catId = AppCategoryInfoManager.getInstance().readCatIdFromCache(item.itemInfo.bundleName);
      log.showDebug(TAG, `item bundleName: ${item.itemInfo.bundleName}, catId: ${item.catId}`);
    })
  }

  /**
   * 获取已经添加到桌面的应用集合
   * @returns containsItemList: Promise<GridLayoutItemInfo[]> 已添加应用信息集合
   */
  public async getContainsItemList(): Promise<GridLayoutItemInfo[]> {
    const itemList: GridLayoutItemInfo[] = await RdbStoreManager.getInstance().queryAllGridLayoutInfo();
    let containsItemList: GridLayoutItemInfo[] = []
    itemList.forEach(item => {
      if (item.intent?.includes('userAdd')) {
        containsItemList.push(item);
      }
    })
    return containsItemList;
  }

  /**
   * 获取appName
   * @param gridLayoutInfo : GridLayoutItemInfo
   * @param resourceManager: ResourceManager
   */
  private getAppName(gridLayoutInfo : GridLayoutItemInfo, resourceManager: ResourceManager) : string {
    let appName = gridLayoutInfo.appName;
    if (!appName) {
      const cacheKey: string = `${gridLayoutInfo.appLabelId}${gridLayoutInfo.bundleName}${gridLayoutInfo.moduleName}`;
      appName = resourceManager.getAppResourceCache(cacheKey, 'name') as string;
    }
    if(!appName) {
      appName = resourceManager.getBundleAppName(gridLayoutInfo.bundleName);
    }
    return appName ?? '';
  }

  /**
   * 根据拼音字典序排序
   * @param gridLayoutInfoList: GridLayoutItemInfo[]
   */
  private sortGridLayoutItemInfos(gridLayoutInfoList: GridLayoutItemInfo[]): void {
    const pinyinSort: PinyinSort = new PinyinSort();
    gridLayoutInfoList.sort((a: GridLayoutItemInfo, b: GridLayoutItemInfo) => {
      return pinyinSort.sortByParameter(a.appName, b.appName);
    });
  }

  /**
   * 获取全集应用
   * @returns appList: GridLayoutItemInfo[]
   */
  private getAllApps(): GridLayoutItemInfo[] {
    let appList: AppItemInfo[] = AppModel.getInstance().getAppList();
    appList.forEach(appInfo => {
      if (appInfo?.codePath == String(NumberConstants.CONSTANT_NUMBER_ONE)) {
        let bmsApp: AppItemInfo | undefined = AppModel.getInstance().getAppInfoByBundleName(appInfo.bundleName);
      }
    })
    let newAppList: GridLayoutItemInfo[] =  appList as GridLayoutItemInfo[];
    const resourceManager: ResourceManager = ResourceManager.getInstance();
    newAppList.forEach(item => {
      this.allAppBundleName.push(item.bundleName);
      if (!item.appName) {
        item.appName = this.getAppName(item, resourceManager);
      }
      log.showInfo(TAG, `bundleName is ${item.bundleName} , appName is: ${item.appName}, intent is: ${item.intent}`);
    })
    this.sortGridLayoutItemInfos(newAppList);
    return newAppList;
  }

  /**
   * 获取全集应用包名
   * @returns allAppBundleName: string []
   */
  public getAllAppsBundleName(): string [] {
    return this.allAppBundleName;
  }

  /**
   * 应用过滤
   * @param containsList: GridLayoutItemInfo[] 已添加的应用列表
   * @returns appList: DesktopAddItemInfo[] 过滤后的可显示应用列表
   */
  private async addOtherApp(appList: DesktopAddItemInfo[], containsList: GridLayoutItemInfo[]): Promise<void> {
    if (!this.allAppList.length) {
      this.allAppList = this.getAllApps();
    }
    if (this.allAppList?.length > 0) {
      this.allAppList.forEach((item: GridLayoutItemInfo) => {
        if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON || item.appIndex !== 0) {//去掉快捷方式和应用分身
          return;
        }
        if (this.presetAppList.includes(item.bundleName)) {//去掉预置应用
          return;
        }
        let otherItem: DesktopAddItemInfo = new DesktopAddItemInfo();//重新封装
        otherItem.itemInfo = item;
        appList.push(otherItem);
      });
    }
    containsList.forEach((item: GridLayoutItemInfo) => {
      if (item.appStatus !== AppStatus.INSTALLED) {
        let containItem: DesktopAddItemInfo = new DesktopAddItemInfo();
        containItem.itemInfo = item;
        appList.push(containItem);
      }
    });
  }

  /**
   * 排列应用，已添加应用排在前
   * @param containsList: GridLayoutItemInfo[] 已添加的应用列表
   * @returns appList: DesktopAddItemInfo[] 排列后的可显示应用列表
   */
  private checkApps(appList: DesktopAddItemInfo[], containsList: GridLayoutItemInfo[]): void {
    const reversedContains = [...containsList].reverse();
    reversedContains.forEach((item: GridLayoutItemInfo) => {
      const index = appList.findIndex(app => app.itemInfo.keyName === item.keyName);
      if (index !== -1) {
        appList[index].isChecked = true;
        const element = appList.splice(index, 1);
        appList.unshift(...element);
      }
    });
  }

  /**
   * 获取所有分类映射
   * @param appList: DesktopAddItemInfo[] 筛选后的全集应用
   * @returns catIdMap: Map<number, string> 应用分类id与分类名映射
   */
  public getRecommendedCategoryMap(appList: DesktopAddItemInfo[]): Map<number, string> {
    const catIdMap: Map<number, string> = new Map();
    const uniqueCatIds = new Set(appList.filter((item) => item.catId !== undefined &&
    AppCategoryInfoManager.getInstance().catIdExist(item.catId))
      .map((item) => item.catId?.toString()));
    if (uniqueCatIds.size === 0) {
      return new Map();
    } else {
      const sortedCatIds = Array.from(uniqueCatIds).sort();
      sortedCatIds.forEach(catId => catIdMap.set(parseInt(catId!),
        AppCategoryInfoManager.getInstance().getAppCatName(parseInt(catId!)) ?? ''));
      return catIdMap;
    }
  }

  /**
   * 将应用与对应的分类进行排列
   * @param allApps: DesktopAddItemInfo[] 筛选后的全集应用
   * @param recommendedCategories： Map<number, string> 应用分类id与分类名映射
   * @param includeOthers: boolean 是否要添加其他分类
   * @returns categorizedApps: DesktopAddItemInfo 排列好了的应用名称与分类列表
   */
  private categorizeApps(allApps: DesktopAddItemInfo[], categorizedApps: DesktopAddItemInfo[],
    recommendedCategories : Map<number, string>, includeOthers: boolean) {
    let index = 0;
    recommendedCategories.forEach((catName, catId) => {
      if (catName === SOCIAL_CATEGORT || catName === TRAVEL_NAVIGATION_CATEGORY) {
        const desktopAddItemIfo = new DesktopAddItemInfo();
        desktopAddItemIfo.type = DesktopAddItemInfoType.Title;
        desktopAddItemIfo.catName = catName;
        desktopAddItemIfo.subTitlePaddingTop = index ? '15vp' : '1vp';
        const categoryApps = allApps.filter(app => app.catId === catId);//应用中属于这个分类
        allApps = allApps.filter(app => app.catId !== catId)//不属于这个分类的
        categorizedApps.push(desktopAddItemIfo, ...categoryApps)
        index++;
      }
    })
    if (includeOthers) {
      if (categorizedApps.length > 0) {
        const folderAddItemIfo = new DesktopAddItemInfo();
        folderAddItemIfo.type = DesktopAddItemInfoType.Title;
        folderAddItemIfo.catName = FOLDER_ADD_SHEET_OTHER;
        categorizedApps.push(folderAddItemIfo);
      }
      categorizedApps.push(...allApps);
    }
  }

  /**
   * 获取可以填入表单的数据，包括分类和应用信息
   * @param containsList: GridLayoutItemInfo[] 已添加的应用信息
   * @param includeOthers: boolean 是否要添加其他分类
   * @returns desktopAddItemInfos: DesktopAddItemInfo[] 排列好了的应用名称与分类列表
   */
  public async getAllDesktopAddItemInfos(containsList: GridLayoutItemInfo[], includeOthers: boolean):
    Promise<DesktopAddItemInfo[]> {
    let appList: DesktopAddItemInfo[] = [];
    const desktopAddItemInfos: DesktopAddItemInfo[] = [];
    await this.addOtherApp(appList, containsList);
    this.setDesktopAddItemInfoCatId(appList);
    this.checkApps(appList, containsList);//到这里是把所有的应用给筛出来并把已经下载的排列在前面
    const recommendedCategories = this.getRecommendedCategoryMap(appList);//筛选所有的分类
    this.categorizeApps(appList, desktopAddItemInfos, recommendedCategories, includeOthers);//把分类和对应的应用放在一起
    desktopAddItemInfos.forEach(item => {
      log.showDebug(TAG, `desktopAddItem type is: ${item.type}, catName is ${item.catName}s`);
    })
    return desktopAddItemInfos;//带有分类信息和对应分类内应用的列表
  }

  /**
   * 在列表中搜索应用是否存在
   * @param appList: GridLayoutItemInfo[]
   * @param key: string
   */
  public findApp(appList: GridLayoutItemInfo[], key: string): boolean {
    let isFind = false;
    appList.forEach(item => {
      if(item.bundleName === key) {
        isFind = true;
        return;
      }
    })
    return isFind;
  }

  /**
   * 获取加号应用信息
   * returns addInfo: GridLayoutItemInfo
   */
  public getAddIconInfo(): GridLayoutItemInfo {
    let addInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
    addInfo.typeId = CommonConstants.TYPE_ADD;
    addInfo.bundleName = CommonConstants.SCENEBOARD_BUNDLE;
    addInfo.infoId = '';
    addInfo.area = [1, 1];
    return addInfo;
  }

  /**
   * 获取最后一个位置的应用
   * returns lastApp: GridLayoutItemInfo|undefined
   */
  public getLastApp(): GridLayoutItemInfo | undefined {
    let lastApp: GridLayoutItemInfo | undefined = undefined;
    let appList: GridLayoutItemInfo [] = LaunchLayoutCacheManager.getInstance()
      .getAllGridLayoutItemList(BusinessType.BUSINESS_BASIC_DESKTOP);
    if (CheckEmptyUtils.isEmptyArr(appList)) {
      return lastApp;
    }
    lastApp = appList[0];
    let layoutDescription: LayoutDescription = LaunchLayoutCacheManager.getInstance()
      .selectLayoutDescription(false);
    let maxColumn = layoutDescription.column;
    let maxRow = layoutDescription.row;LaunchLayoutCacheManager.getInstance()
    appList.forEach(item =>{
      if (item.typeId !== CommonConstants.TYPE_ADD && lastApp != undefined) {
        let lastAppIndex = lastApp.page! * maxRow * maxColumn + lastApp.row! * maxColumn + lastApp.column!;
        let itemAppIndex = item.page! * maxRow * maxColumn + item.row! * maxColumn + item.column!
        if (itemAppIndex > lastAppIndex) {
          lastApp = item;
        }
      }
    })
    return lastApp;
  }

  /**
   * 计算加号所在的位置并插入
   * @param lastApp: GridLayoutItemInfo | undefined 最后一个应用位置
   * returns addInfo: GridLayoutItemInfo 加号应用信息
   */
  public appendAddIcon(): void {
    let addInfo: GridLayoutItemInfo = this.getAddIconInfo();
    let lastApp: GridLayoutItemInfo | undefined = this.getLastApp();

    if (lastApp != undefined) {
      let appInfo: GridLayoutItemInfo = lastApp as GridLayoutItemInfo;
      let page = appInfo.page!;
      let row = appInfo.row!;
      let column = appInfo.column!;
      log.showInfo(TAG, `last app position, bundleName: ${appInfo.bundleName},
        page:${page}, row: ${row}, column: ${column}`);
      let layoutDescription: LayoutDescription   = LaunchLayoutCacheManager.getInstance()
        .selectLayoutDescription(false);
      let maxColumn: number = layoutDescription.column;
      let maxRow: number = layoutDescription.row;
      log.showInfo(TAG, `layoutDescription, maxColumn:${maxColumn}, maxRow:${maxRow}`);
      if (column == maxColumn - 1) {
        column = 0;
        row = row + 1;
        if (row > maxRow - 1) {
          page = page + 1;
          row = 0;
        }
      } else {
        column = column + 1;
      }
      addInfo.page = page;
      addInfo.row = row;
      addInfo.column = column;
      LaunchLayoutCacheManager.getInstance()
        .insertGridLayoutItemInfo(addInfo, 'Add Application', false);
      log.showInfo(TAG, `findPosition for AddInfo, page:${page}, row: ${row}, column: ${column}`);
    } else {
      let desktopPosition: DesktopPosition = scbBlankPositionUtils.findBlankPosition(false);
      addInfo.page = desktopPosition.page;
      addInfo.column = desktopPosition.column;
      addInfo.row = desktopPosition.row;
      log.showInfo(TAG, `select 0 apps, findPosition for AddInfo, page:${addInfo.page}, row: ${
      addInfo.row}, column: ${addInfo.column}`);
      LaunchLayoutCacheManager.getInstance()
        .insertGridLayoutItemInfo(addInfo, 'Add Application', false);
    }
  }

  /**
   * 插入应用到桌面
   * @param item: GridLayoutItemInfo | AppItemInfo 应用信息
   */
  public insertGridLayout(item: GridLayoutItemInfo | AppItemInfo): void {
    let desktopPosition: DesktopPosition = scbBlankPositionUtils.findBlankPosition(false);
    item.page = desktopPosition.page;
    item.column = desktopPosition.column;
    item.row = desktopPosition.row;
    let gridlayoutItem: GridLayoutItemInfo =
      GridLayoutUtil.buildGridLayoutInfoFromItemInfo(item, desktopPosition.page, desktopPosition.column,
        desktopPosition.row);
    if (!gridlayoutItem.container) {
      log.showWarn(TAG, 'default container');
      gridlayoutItem.container = CommonConstants.CONTAINER_DESKTOP;
    }
    if (gridlayoutItem.typeId === undefined) {
      log.showWarn(TAG, 'default typeId');
      gridlayoutItem.typeId = CommonConstants.TYPE_APP;
    }

    if (!desktopPosition.isFind) {
      log.showWarn('findBlankPosition app[%{public}s] do not find blank position', item.bundleName);
      return;
    }
    LaunchLayoutCacheManager.getInstance()
      .insertGridLayoutItemInfo(gridlayoutItem, 'Add Application', true, false);
  }
}

export enum DesktopAddItemInfoType {
  Title = 'title',
  GridItem = 'gridItem'
}

/**
 * 桌面添加应用+号 dialog 中的数据Bean
 */
@Observed
export class DesktopAddItemInfo {
  public type: DesktopAddItemInfoType = DesktopAddItemInfoType.GridItem;
  public isChecked: boolean = false;
  public itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
  public catId: number | undefined;
  public catName: string | undefined;
  public subTitlePaddingTop: string = DesktopAddDialogConstant.DEFAULT_SUBTITLE_TOP_PADDING;
}

@Observed
export class DesktopAddDialogShowInfo {
  public isDesktopDialogShow: boolean = false;
}