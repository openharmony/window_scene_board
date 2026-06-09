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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { DragItemPosition } from '@ohos/componentdrag';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { AppGridItemInfo } from '@ohos/launchercommon/src/main/ets/bean/AppGridItemInfo';
import {
  AppItemInfo,
  CommonConstants,
  GridLayoutItemInfo,
  GridLayoutUtil,
  layoutConfigManager,
  RdbStoreManager
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import LayoutConstants from '../../constants/LayoutConstants';
import { AppCenterGridStyleConfig } from '../AppCenterGridStyleConfig';
import FeatureConstants from '../constants/FeatureConstants';
import AppGridLayoutUtil from '../util/AppGridLayoutUtil';
import { AppLayoutInfo } from '../viewmodel/AppLayoutInfo';
import { FoldAcGridLayoutConstants } from '../../folded/FoldedDeviceAcViewModel'
import { HashMap } from '@kit.ArkTS';

const TAG = 'DefaultAppCacheManager';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const PAGES_IN_ONE_SCREEN = 1;

export default class DefaultAppCacheManager {
  protected mAppGridLayoutItemList: AppLayoutInfo[] = [];
  protected mGridStyleConfig: AppCenterGridStyleConfig;

  public constructor() {
    this.mGridStyleConfig = layoutConfigManager.getStyleConfig(AppCenterGridStyleConfig.APP_GRID_STYLE_CONFIG,
      FeatureConstants.FEATURE_NAME);
  }

  public setAppGridLayoutItemList(appGridLayoutItemList: AppLayoutInfo[]): void {
    if (!this.mAppGridLayoutItemList) {
      return;
    }
    log.showInfo(`setAppGridLayoutItemList: ${appGridLayoutItemList?.length}`);
    this.mAppGridLayoutItemList = appGridLayoutItemList;
  }

  public setAndUpdateAppListForPkgChange(appGridLayoutItemList: AppLayoutInfo[], changedItem?: AppItemInfo): void {
    this.setAppGridLayoutItemList(appGridLayoutItemList);
  }

  public updateAppPageList(appGridLayoutItemList: AppLayoutInfo[], newAddItem?: AppItemInfo): void {
    this.setAppGridLayoutItemList(appGridLayoutItemList);
  }

  public getAppGridLayoutItemList(clone: boolean = true): AppLayoutInfo[] {
    return clone ? this.deepCloneAppList(this.mAppGridLayoutItemList) : this.mAppGridLayoutItemList;
  }

  public getAppGridLayoutItemsByPage(pageIndex: number): AppItemInfo[] {
    if (!this.mAppGridLayoutItemList || pageIndex >= this.mAppGridLayoutItemList.length) {
      return [];
    }
    let sourcePageInfo: AppItemInfo[] = this.mAppGridLayoutItemList[pageIndex]?.pageInfo ?? [];
    let destItemList: AppItemInfo[] = [];
    sourcePageInfo.forEach((item: AppItemInfo) => {
      destItemList.push(ObjectCopyUtil.deepClone(item, new AppItemInfo()));
    });
    return destItemList;
  }

  public getAppItemList(): AppItemInfo[] {
    if (CheckEmptyUtils.isEmptyArr(this.mAppGridLayoutItemList)) {
      log.showWarn('getAppItemList invalid cache');
      return [];
    }
    let resultList: AppItemInfo[] = [];
    for (let i = 0; i < this.mAppGridLayoutItemList.length; i++) {
      if (!this.mAppGridLayoutItemList[i].pageInfo) {
        continue;
      }
      for (let j = 0; j < this.mAppGridLayoutItemList[i].pageInfo.length; j++) {
        resultList.push(this.mAppGridLayoutItemList[i].pageInfo[j]);
      }
    }
    log.showInfo(`getAppItemList length: ${resultList?.length}`);
    return resultList;
  }

  /**
   * 获取应用在当前页面的序列数，便于计算对应行与列
   * */
  public getAppItemIndex(bundleName: string, appIndex: number = 0, pageIndex: number = 0): number {
    let index: number = 0;
    log.showInfo(`getAppItemIndex budleName:${bundleName}, appIndex:${appIndex}, pageIndex:${pageIndex}`)
    if (CheckEmptyUtils.checkStrIsEmpty(bundleName)) {
      log.showWarn('getAppItemIndex invalid cache');
      return index;
    }
    let appList = AppStorage.get<AppLayoutInfo[]>('appCenterLayoutInfo');
    if (!appList || appList.length <= 0) {
      log.showInfo('appList appList is empty');
      return index;
    }
    for (let i = 0; i < appList.length; i++) {
      if (i === pageIndex) {
        index = appList[i].pageInfo.findIndex(
          (j) => j.bundleName === bundleName && j.appIndex === appIndex);
      }
    }
    log.showInfo(`getAppItemIndex index: ${index}`);
    return index;
  }

  public getPages(): number[] {
    let newPages: number[] = [];
    for (let i = 0; i < this.mAppGridLayoutItemList?.length; i++) {
      newPages.push(i);
    }
    return newPages;
  }

  public getPageCount(): number {
    return this.mAppGridLayoutItemList?.length ?? 0;
  }

  /**
   * 从缓存中删除元素
   * @param bundleName
   * @returns
   */
  public deleteCachedLayoutItem(bundleName: string, isOperateDb: boolean = true, appIndex: number = 0,
    mRows?: number, mColumns?: number): boolean {
    log.showInfo(`deleteCachedLayoutItem: ${bundleName} appIndex:${appIndex}`);
    if (CheckEmptyUtils.isEmpty(bundleName)) {
      return false;
    }
    if (CheckEmptyUtils.isEmptyArr(this.mAppGridLayoutItemList)) {
      log.showWarn('deleteCachedLayoutItem, mAppGridLayoutItemList is empty');
      return false;
    }
    let deleteRet: boolean = false;
    let updateDbInfo: AppGridItemInfo[] = [];
    let itemInfo: AppItemInfo | undefined = undefined;
    this.mAppGridLayoutItemList.forEach((pageInfo: AppLayoutInfo) => {
      let findItemIndex: number = pageInfo.pageInfo?.findIndex((itemInfo: AppItemInfo) => {
        return itemInfo.bundleName === bundleName && itemInfo.appIndex === appIndex;
      });
      if (findItemIndex > -1) {
        itemInfo = pageInfo.pageInfo[findItemIndex];
        for (let i = findItemIndex + 1; i < pageInfo.pageInfo.length; i++) {
          const nextPos: number[] | undefined =
            this.getNextPosition(true, pageInfo.pageInfo[i].row, pageInfo.pageInfo[i].column,
              undefined, mRows, mColumns);
          pageInfo.pageInfo[i].page = itemInfo.page;
          pageInfo.pageInfo[i].row = nextPos ? nextPos[0] : pageInfo.pageInfo[i].row;
          pageInfo.pageInfo[i].column = nextPos ? nextPos[1] : pageInfo.pageInfo[i].column;
          updateDbInfo.push(AppGridItemInfo.newInstanceFromAppItemInfo(pageInfo.pageInfo[i]));
        }
        pageInfo.pageInfo.splice(findItemIndex, 1);
        deleteRet = true;
      }
    });
    let beforeLen = updateDbInfo.length;
    let pageChangedApps: AppItemInfo[] = [];
    this.checkBlankPagesAndDelete(pageChangedApps);
    pageChangedApps?.forEach((itemInfo: AppItemInfo) => {
      updateDbInfo.push(AppGridItemInfo.newInstanceFromAppItemInfo(itemInfo));
    });
    log.showInfo(`findAppItem:beforeLen:${beforeLen} afterLen:${updateDbInfo.length}`);
    if (isOperateDb && itemInfo) {
      RdbStoreManager.getInstance().deleteAppCenterItem(itemInfo).then(() => {
        this.updateItemPositionToDB(updateDbInfo, true);
      });
    }
    return deleteRet;
  }

  /**
   * 缓存中查找元素
   * @param bundleName
   * @returns
   */
  public findAppItem(bundleName: string): AppItemInfo | undefined {
    log.showInfo(`findAppItem: ${bundleName}`);
    if (CheckEmptyUtils.isEmpty(bundleName) || CheckEmptyUtils.isEmptyArr(this.mAppGridLayoutItemList)) {
      log.showWarn('findAppItem: invalid param');
      return undefined;
    }
    for (let index = 0; index < this.mAppGridLayoutItemList.length; index++) {
      let findItem: AppItemInfo | undefined =
        this.mAppGridLayoutItemList[index]?.pageInfo?.find((itemInfo: AppItemInfo) => {
          return itemInfo.bundleName === bundleName;
        });
      if (findItem) {
        return findItem;
      }
    }
    return undefined;
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
    log.showInfo(`findApp: ${bundleName}-${pageIdx}-${appIdx}`);

    if (CheckEmptyUtils.isEmptyArr(this.mAppGridLayoutItemList)) {
      log.showInfo('findApp: empty cache list');
      return undefined;
    }

    if (CheckEmptyUtils.isEmpty(bundleName) || pageIdx < 0 || pageIdx >= this.mAppGridLayoutItemList.length) {
      log.showWarn('findApp: invalid params');
      return undefined;
    }

    let result: AppItemInfo | undefined =
      this.mAppGridLayoutItemList[pageIdx]?.pageInfo?.find((itemInfo: AppItemInfo) => {
        return itemInfo.bundleName === bundleName && itemInfo.appIndex === appIdx;
      });

    return result;
  }

  /**
   * 遍历查找某个App
   *
   * @param bundleName
   * @param pageIdx
   * @param appIdx
   * @returns
   */
  public lookForApp(pagedAppList: AppLayoutInfo[], bundleName: string, appIdx?: number): AppItemInfo | undefined {
    log.showInfo(`lookForApp: ${bundleName}-${appIdx}-${pagedAppList.length}`);
    if (CheckEmptyUtils.isEmptyArr(pagedAppList)) {
      log.showInfo('lookForApp: empty cache list');
      return undefined;
    }
    if (CheckEmptyUtils.isEmpty(bundleName)) {
      log.showWarn('lookForApp: invalid params');
      return undefined;
    }
    for (let index = 0; index < pagedAppList.length; index++) {
      let result: AppItemInfo | undefined = pagedAppList[index]?.pageInfo?.find((itemInfo: AppItemInfo) => {
        return itemInfo.bundleName === bundleName && itemInfo.appIndex === appIdx;
      });
      if (result) {
        return result;
      }
    }
    return undefined;
  }
  /**
   * 指定页是否空白
   * @param pageIndex
   * @returns
   */
  public isBlankPage(pageIndex: number): boolean {
    log.showInfo(`isBlankPage pageIndex: ${pageIndex}`);
    if (!this.mAppGridLayoutItemList || pageIndex < 0 || pageIndex >= this.mAppGridLayoutItemList.length) {
      return false;
    }
    return this.mAppGridLayoutItemList[pageIndex].pageInfo?.length === 0;
  }

  /**
   * 添加新页
   */
  public addBlankPage(): boolean {
    if (!this.mAppGridLayoutItemList) {
      return false;
    }
    if (this.mAppGridLayoutItemList.length === LayoutConstants.MAX_PAGE_COUNT) {
      log.showWarn('can not exceed max page at app center');
      return false;
    }
    this.mAppGridLayoutItemList.push(
      {
        pageInfo: [],
        index: this.mAppGridLayoutItemList.length,
        packageChangeTime: 0,
        forLandscape: false
      }
    );
    return true;
  }

  /**
   * 删除空白页
   * @returns
   */
  public deleteBlankPage(dataSource?: AppLayoutInfo[]): boolean {
    log.showInfo('deleteBlankPage');
    if (!dataSource) {
      dataSource = this.mAppGridLayoutItemList;
    }
    if (CheckEmptyUtils.isEmptyArr(dataSource)) {
      return false;
    }
    for (let index = 0; index < dataSource.length; index++) {
      if (dataSource[index]?.pageInfo?.length === 0) {
        dataSource.splice(index, 1);
        log.showWarn(`deleteBlankPage, index: ${index}`);
        this.resetLaterPageAfterDeleteBlank(dataSource);
        return true;
      }
    }
    return false;
  }

  /**
   * 删除空白页
   * pageChangedApps 删除空白页后面页的所有item
   * dataSource 整个list
   * 返回数据更新的list
   * @returns
   */
  public checkBlankPagesAndDelete(pageChangedApps: AppItemInfo[], dataSource?: AppLayoutInfo[]): boolean {
    log.showInfo(`checkBlankPageAndDelete - ${dataSource?.length}`);
    if (!dataSource) {
      dataSource = this.getAppGridLayoutItemList(false);
    }
    if (CheckEmptyUtils.isEmptyArr(dataSource)) {
      return false;
    }
    // 先把空白的页从缓存/DS里删掉
    let pageIdxesDeleted: number[] = [];
    for (let index = 0; index < dataSource.length; index++) {
      if (dataSource[index]?.pageInfo?.length === 0) {
        dataSource.splice(index, 1);
        pageIdxesDeleted.push(index);
        log.showInfo(`deleteBlankPage on page with index=${index}`);
      }
    }
    log.showInfo(`pageIdxesDeleted - ${pageIdxesDeleted.length} vs ${dataSource.length}`);
    if (pageIdxesDeleted.length > 0) {
      // 简单排序一下分页数据
      dataSource.sort((a: AppLayoutInfo, b: AppLayoutInfo) => {
        return a.index - b.index;
      });
      // 页码检测与矫正
      for (let idx = 0; idx < dataSource.length; ++idx) {
        if (dataSource[idx].index !== idx) {
          log.showInfo(`apps need repage on page index=${dataSource[idx].index}-${idx}`);
          dataSource[idx].index = idx;
          dataSource[idx].pageInfo.forEach((app: AppItemInfo) => {
            app.page = idx;
            pageChangedApps.push(app);
          });
        }
      }
      log.showInfo(`page changed apps length=${pageChangedApps.length}`);
      return true;
    } else {
      return false;
    }
  }
  private resetLaterPageAfterDeleteBlank(dataSource?: AppLayoutInfo[]): void {
    log.showInfo('resetLaterPageAfterDeleteBlank');
    if (!dataSource) {
      return;
    }
    for (let index = 0; index < dataSource.length; index++) {
      if (!dataSource[index] || index === dataSource[index].index) {
        continue;
      }
      log.showInfo(`resetLaterPageAfterDeleteBlank, index: ${index}`);
      dataSource[index].index = index;
      dataSource[index].pageInfo?.forEach((item: AppItemInfo) => {
        item.page = index;
      });
    }
  }

  public isFullPage(page: number): boolean {
    const length: number = this.mAppGridLayoutItemList[page]?.pageInfo?.length;
    log.showInfo(`isFullPage length: ${length}, page: ${page}`);
    return length >= this.mGridStyleConfig.mColumns * this.mGridStyleConfig.mRows;
  }

  /**
   * 跨页拖拽时，处理对应元素
   * @param startItem
   * @returns
   */
  public updateItemForDifferentPage(startPos: DragItemPosition, endItem: AppItemInfo,
    isOperateDb: boolean = true): boolean {
    log.showInfo('updateItemForDifferentPage');
    if (!this.checkInputPosition(startPos, endItem)) {
      return false;
    }
    const startPageInfo: AppItemInfo[] = this.mAppGridLayoutItemList[startPos.page].pageInfo;
    const endPageInfo: AppItemInfo[] = this.mAppGridLayoutItemList[endItem.page ?? 0].pageInfo;
    const startIndex: number = startPos.column + startPos.row * this.mGridStyleConfig.mColumns;
    const endIndex: number = (endItem.column ?? 0) + (endItem.row ?? 0) * this.mGridStyleConfig.mColumns;
    if (!this.checkUpdatePageInfo(startPageInfo, endPageInfo, startIndex, endIndex)) {
      return false;
    }
    let updateDbInfo: AppGridItemInfo[] = [];
    if (startPageInfo.length === 1) {
      log.showInfo('updateItemForDifferentPage: startPage only one item');
    } else {
      for (let i = startIndex + 1; i < startPageInfo.length; i++) {
        const nextPos: number[] | undefined = this.getNextPosition(true, startPageInfo[i].row, startPageInfo[i].column);
        if (!nextPos) {
          log.showWarn(`updateItemForDifferentPage position invalid: [${AppGridLayoutUtil.appGridItemToString(startPageInfo[i])}]`);
          return false;
        }
        log.showInfo(`updateItemForDifferentPage start, move from: [${AppGridLayoutUtil.appGridItemToString(startPageInfo[i])}]`);
        startPageInfo[i].page = startPos.page;
        startPageInfo[i].row = nextPos[0];
        startPageInfo[i].column = nextPos[1];
        log.showInfo(`updateItemForDifferentPage start, move to: [${AppGridLayoutUtil.appGridItemToString(startPageInfo[i])}]`);
        updateDbInfo.push(AppGridItemInfo.newInstanceFromAppItemInfo(startPageInfo[i]));
      }
    }
    startPageInfo.splice(startIndex, 1);
    this.updateEndPage(endIndex, endPageInfo, endItem, updateDbInfo);
    // 删除空白页后的list,更新位置
    let beforeLen = updateDbInfo.length;
    let pageChangedApps: AppItemInfo[] = [];
    this.checkBlankPagesAndDelete(pageChangedApps);
    pageChangedApps?.forEach((itemInfo: AppItemInfo) => {
      updateDbInfo.push(AppGridItemInfo.newInstanceFromAppItemInfo(itemInfo));
    });
    log.showInfo(`findAppItem:beforeLen:${beforeLen} afterLen:${updateDbInfo.length}`);
    updateDbInfo.push(AppGridItemInfo.newInstanceFromAppItemInfo(endItem));
    return this.checkAndUpdateDB(updateDbInfo, isOperateDb);
  }

  protected deepCloneAppList(appLayoutInfo: AppLayoutInfo[]): AppLayoutInfo[] {
    log.showInfo(`deepCloneAppList: ${appLayoutInfo?.length}`);
    if (!appLayoutInfo) {
      return [];
    }
    let appLayoutInfoList: AppLayoutInfo[] = [];
    appLayoutInfo.forEach((layoutInfo: AppLayoutInfo) => {
      let newLayoutInfo: AppLayoutInfo = new AppLayoutInfo();
      let layoutItemList: AppItemInfo[] = [];
      if (layoutInfo && layoutInfo.pageInfo) {
        layoutInfo.pageInfo.forEach((item: AppItemInfo) => {
          layoutItemList.push(ObjectCopyUtil.deepClone(item, new AppItemInfo()));
        });
      }
      newLayoutInfo.pageInfo = layoutItemList;
      newLayoutInfo.index = layoutInfo?.index ?? 0;
      newLayoutInfo.packageChangeTime = layoutInfo?.packageChangeTime ?? 0;
      newLayoutInfo.forLandscape = layoutInfo.forLandscape;
      appLayoutInfoList.push(newLayoutInfo);
    });
    return appLayoutInfoList;
  }

  protected updateEndPage(endIndex: number, endPageInfo: AppItemInfo[],
    endItem: AppItemInfo, updateDbInfo: AppGridItemInfo[]): void {
    for (let j = endIndex; j < endPageInfo.length; j++) {
      const nextPos: number[] | undefined = this.getNextPosition(false, endPageInfo[j]?.row, endPageInfo[j]?.column);
      log.showInfo(`updateItemForDifferentPage end, move from: [${AppGridLayoutUtil.appGridItemToString(endPageInfo[j])}]`);
      if (!nextPos) {
        continue;
      }
      endPageInfo[j].page = endItem.page;
      endPageInfo[j].row = nextPos[0];
      endPageInfo[j].column = nextPos[1];
      log.showInfo(`updateItemForDifferentPage end, move to: [${AppGridLayoutUtil.appGridItemToString(endPageInfo[j])}]`);
      updateDbInfo.push(AppGridItemInfo.newInstanceFromAppItemInfo(endPageInfo[j]));
    }
    if (endPageInfo.length === 0) {
      endItem.row = 0;
      endItem.column = 0;
    }
    if (endIndex >= endPageInfo.length && endPageInfo.length !== 0) {
      const lastOne: AppItemInfo = endPageInfo[endPageInfo.length - 1];
      const nextPos: number[] | undefined = this.getNextPosition(false, lastOne.row, lastOne.column);
      if (nextPos) {
        endItem.row = nextPos[0];
        endItem.column = nextPos[1];
      }
    }
    endPageInfo.splice(endIndex, 0, endItem);
  }

  protected checkAndUpdateDB(updateDbInfo: AppGridItemInfo[], isOperateDb: boolean): boolean {
    if (this.checkIfDuplicatePos(this.mAppGridLayoutItemList)) {
      log.showError('updateItemPositionById duplicate data');
      this.putAppItemToGrid(this.mAppGridLayoutItemList);
      return false;
    }
    return this.updateItemPositionToDB(updateDbInfo, isOperateDb);
  }

  private updateItemPositionToDB(updateDbInfo: AppGridItemInfo[], isOperateDb: boolean): boolean {
    if (isOperateDb && updateDbInfo.length > 0) {
      try {
        RdbStoreManager.getInstance().updateAppCenterItemPositions(updateDbInfo);
        return true;
      } catch (error) {
        log.showError(`updateItemForDifferentPage with error: ${error.message}`);
        return false;
      }
    }
    return false;
  }

  protected checkInputPosition(startPos: DragItemPosition, endItem: AppItemInfo): boolean {
    let appGridLayoutItemList = this.getAppGridLayoutItemList(false);
    if (!startPos || !endItem || CheckEmptyUtils.isEmpty(startPos.page) || CheckEmptyUtils.isEmpty(endItem.page) ||
      (endItem.page ?? 0) >= appGridLayoutItemList?.length) {
      log.showWarn(`invalid param, startPos: ${startPos?.row}, ${startPos?.column}, endItem: ${endItem?.row},
      ${endItem?.column}`);
      return false;
    }
    if (startPos.page < 0 || startPos.page >= appGridLayoutItemList?.length ||
      (endItem.page ?? 0) < 0 || (endItem.page ?? 0) >= appGridLayoutItemList?.length) {
      log.showWarn('checkInputPosition invalid page index');
      return false;
    }
    return true;
  }

  protected checkUpdatePageInfo(startPageInfo: AppItemInfo[], endPageInfo: AppItemInfo[], startIndex: number,
    endIndex: number): boolean {
    if (!startPageInfo || startIndex < 0 || startIndex >= startPageInfo.length) {
      log.showWarn('updateItemForDifferentPage invalid startIndex');
      return false;
    }
    const maxSize: number = this.mGridStyleConfig.mColumns * this.mGridStyleConfig.mRows;
    if (!endPageInfo || endIndex < 0 || endIndex >= maxSize) {
      log.showWarn(`invalid endIndex: ${endIndex}, endPageInfo length: ${endPageInfo?.length}`);
      return false;
    }
    if (endPageInfo.length === this.mGridStyleConfig.mColumns * this.mGridStyleConfig.mRows) {
      log.showWarn('updateItemForDifferentPage endPage full');
      return false;
    }
    return true;
  }

  protected getAppGridKey(item: AppItemInfo | undefined): string {
    if (item) {
      item.typeId = CommonConstants.TYPE_APP;
      return 'AppGrid_' + GridLayoutUtil.generateUniqueKey(item as GridLayoutItemInfo);
    }
    return '';
  }

  /**
   * 按当前顺序，给数据分配宫格
   * @param appLayoutInfo
   */
  public putAppItemToGrid(appLayoutInfo: AppLayoutInfo[]): void {
    log.showInfo(`putAppItemToGrid: ${appLayoutInfo?.length}`);
    if (!appLayoutInfo) {
      log.showWarn('input param not legal');
      return;
    }
    const pageCount: number = appLayoutInfo.length;
    for (let i = 0; i < pageCount; i++) {
      let curColIndex: number = 0;
      let curRowIndex: number = 0;
      for (let j = 0; j < appLayoutInfo[i].pageInfo.length; j++) {
        appLayoutInfo[i].pageInfo[j].page = appLayoutInfo[i].index;
        appLayoutInfo[i].pageInfo[j].row = curRowIndex;
        appLayoutInfo[i].pageInfo[j].column = curColIndex;
        curColIndex++;
        // 换行
        if (curColIndex === this.mGridStyleConfig.mColumns) {
          curColIndex = 0;
          curRowIndex++;
        }
      }
    }
  }

  /**
   * 位置偏移修正
   */
  public correctSelfPosition(): void {
    log.showInfo('correctSelfPosition');
    this.putAppItemToGrid(this.mAppGridLayoutItemList);
  }
  protected rePageByItemPageNumber(dataSource: AppLayoutInfo[]): void {
    let crossPageItemInfos: AppItemInfo[] = [];
    dataSource.forEach((pageValue: AppLayoutInfo) => {
      crossPageItemInfos.push(...pageValue.pageInfo.filter((item) => {
        return item.page !== pageValue.index;
      }));
    });
    dataSource.forEach((pageValue: AppLayoutInfo) => {
      log.showInfo(`rePageByItemPageNumber page ${pageValue.index}, before filter length: ${pageValue.pageInfo.length}`);
      pageValue.pageInfo = pageValue.pageInfo.filter((item) => {
        return item.page === pageValue.index;
      });
      log.showInfo(`rePageByItemPageNumber page ${pageValue.index}, after filter length: ${pageValue.pageInfo.length}`);
    });
    let appLayoutItem: AppLayoutInfo = new AppLayoutInfo();
    appLayoutItem.pageInfo = [];
    appLayoutItem.index = dataSource.length;
    appLayoutItem.packageChangeTime = 0;
    appLayoutItem.forLandscape = false;
    crossPageItemInfos.forEach((item: AppItemInfo, index: number) => {
      let addToNewPage: boolean = true;
      dataSource.forEach((pageValue: AppLayoutInfo) => {
        if (item.page === pageValue.index) {
          pageValue.pageInfo.push(item);
          addToNewPage = false;
          log.showInfo(`rePageByItemPageNumber push ${item.bundleName}(${item.row}, ${item.column}, ${item.page}), to page ${pageValue.index}, after length: ${pageValue.pageInfo.length}, addToNewPage: false`);
        }
      });
      if (addToNewPage) {
        if (item.page === dataSource.length) {
          appLayoutItem.pageInfo.push(item);
        } else {
          log.showError(`rePageByItemPageNumber error! page error: ${item.bundleName} page: ${item.page}`);
          item.page = dataSource.length;
          appLayoutItem.pageInfo.push(item);
        }
      }
    });
    if (appLayoutItem.pageInfo.length > 0) {
      log.showWarn(`rePageByItemPageNumber add new page ${appLayoutItem.index}, length: ${appLayoutItem.pageInfo.length}, dataSource.length: ${dataSource.length}`);
      dataSource.push(appLayoutItem);
    }
    dataSource.forEach((pageValue: AppLayoutInfo) => {
      this.sortPageData(pageValue.pageInfo);
    });
  }

  /**
   * 更新图标位置
   * @param updateItems
   * @param operationDataSource
   * @param isOperateDb
   */
  public updateItemPositionById(updateItems: AppItemInfo[], operationDataSource?: AppLayoutInfo[],
    isOperateDb: boolean = true): boolean {
    log.showInfo(`updateItemPositionById isLocal: ${operationDataSource !== undefined}`);
    if (CheckEmptyUtils.isEmptyArr(updateItems)) {
      log.showWarn('updateItemPositionById updateItem empty');
      return false;
    }
    let dataSource: AppLayoutInfo[] = operationDataSource ? operationDataSource : this.mAppGridLayoutItemList;
    if (CheckEmptyUtils.isEmptyArr(dataSource)) {
      log.showWarn(`updateItemPositionById list: ${updateItems.length} `);
      return false;
    }
    const map: Map<string, AppItemInfo> = new Map();
    updateItems.forEach((value: AppItemInfo) => map.set(this.getAppGridKey(value),
      value));
    log.showInfo(`updateItemPositionById map size: ${map.size}`);
    let updateDbInfo: AppGridItemInfo[] = [];
    dataSource.forEach((pageValue: AppLayoutInfo) => {
      log.showInfo(`updateItemPositionById pageIndex: ${pageValue?.index}`);
      pageValue.pageInfo?.forEach((pageItem: AppItemInfo) => {
        const updateItem: AppItemInfo | undefined = map.get(this.getAppGridKey(pageItem));
        log.showInfo(`updateItemPositionById pageItem : ${AppGridLayoutUtil.appGridItemToString(pageItem)}`);
        if (updateItem && ((pageItem.row !== updateItem.row || pageItem.column !== updateItem.column ||
          pageItem.page !== updateItem.page))) {
          pageItem.row = updateItem.row;
          pageItem.column = updateItem.column;
          pageItem.page = updateItem.page;
          log.showInfo(`updateItemPositionById update item inner: ${AppGridLayoutUtil.appGridItemToString(updateItem)}`);
          updateDbInfo.push(AppGridItemInfo.newInstanceFromAppItemInfo(updateItem));
        }
      });
    });
    this.rePageByItemPageNumber(dataSource);
    if (this.checkIfDuplicatePos(operationDataSource ?? []) && operationDataSource) {
      log.showError('updateItemPositionById duplicate data');
      this.putAppItemToGrid(operationDataSource);
      return false;
    }
    if (isOperateDb &&　!operationDataSource &&　updateDbInfo.length > 0) {
      try {
        RdbStoreManager.getInstance().updateAppCenterItemPositions(updateDbInfo);
      } catch (error) {
        log.showError(`updateItemPositionById with error ${error.message}`);
      }
    }
    return true;
  }

  /**
   * 校验数据中是否有重复位置元素
   * @param layoutPageInfo
   * @returns
   */
  public checkIfDuplicatePos(layoutPageInfo: AppLayoutInfo[]): boolean {
    if (CheckEmptyUtils.isEmptyArr(layoutPageInfo)) {
      return false;
    }
    for (let i = 0; i < layoutPageInfo.length; i++) {
      let appItems: AppItemInfo[] = layoutPageInfo[i]?.pageInfo;
      if (CheckEmptyUtils.isEmptyArr(appItems)) {
        log.showWarn(`checkIfDuplicatePos page ${i} is undefined`);
        continue;
      }
      let map: HashMap<string, AppItemInfo> = new HashMap();
      for (let j = 0; j < appItems.length; j++) {
        const item: AppItemInfo = map.get(this.gridPosToString(appItems[j]));
        if (item) {
          log.showWarn(`checkIfDuplicatePos checked true, it is: ${AppGridLayoutUtil.appGridItemToString(appItems[j])}-${appItems.length}`);
          return true;
        }
        map.set(this.gridPosToString(appItems[j]), appItems[j]);
      }
    }
    return false;
  }

  private gridPosToString(item: AppItemInfo): string {
    return item ? `${item.row}-${item.column}-${item.page}` : '';
  }

  /**
   * 排序指定页面
   */
  public sortAllData(pageIndex?: number[]): void {
    log.showInfo(`start to sort all Data`);
    this.mAppGridLayoutItemList?.forEach((pageData: AppLayoutInfo) => {
      if (pageIndex) {
        if (pageIndex.includes(pageData.index)) {
          this.sortPageData(pageData?.pageInfo);
        }
      } else {
        this.sortPageData(pageData?.pageInfo);
      }
    });
  }

  /**
   * 宫格数据排序
   * @param pageItemInfos
   */
  public sortPageData(pageItemInfos: AppItemInfo[]): void {
    if (!pageItemInfos) {
      log.showWarn(`sortPageData input data in undefined`);
      return;
    }
    pageItemInfos.sort((item1: AppItemInfo, item2: AppItemInfo) => {
      if (item1.row === item2.row) {
        return (item1.column ?? 0) - (item2.column ?? 0);
      } else {
        return (item1.row ?? 0) - (item2.row ?? 0);
      }
    });
  }

  /**
   * 获取图标位移的下一个位置
   * @param isSqueezeBack 是否向后挤位
   * @param row 图标当前所在行
   * @param column 图标当前所在列
   * @returns 能找到下一个合法位置，则返回对应位置，否则返回undefined
   */
  public getNextPosition(isSqueezeBack: boolean, row: number | undefined, column: number | undefined,
    page: number | undefined = undefined, mRows?: number, mColumns?: number): number[] | undefined {
    if (row === undefined || column === undefined) {
      log.showWarn('getNextPosition, param undefined!');
      return undefined;
    }
    if (page !== undefined && (page < 0 || page >= this.getPages().length)) {
      log.showWarn(`getNextPosition, page ${page} invalid!`);
      return undefined;
    }
    let nextPosRow: number = row;
    let nextPosColumn: number = column;
    nextPosColumn = isSqueezeBack ? column - 1 : column + 1;
    let nextPosPage: number | undefined = page;
    if (!mRows) {
      mRows = this.mGridStyleConfig.mRows
    }
    if (!mColumns) {
      mColumns = this.mGridStyleConfig.mColumns
    }
    if (nextPosColumn === mColumns) {
      //过右边界
      nextPosColumn = 0;
      nextPosRow++;
      if (nextPosRow === mRows) {
        if (nextPosPage === undefined || nextPosPage + 1 >= LayoutConstants.MAX_PAGE_COUNT) {
          // 过下边界，无效
          log.showWarn('getNextPosition, next position exceed bottom!');
          return undefined;
        } else {
          nextPosRow = 0;
          nextPosPage++;
        }
      }
    }
    if (nextPosColumn === -1) {
      //过左边界
      nextPosColumn = mColumns - 1;
      nextPosRow--;
      if (nextPosRow === -1) {
        // 过下边界，无效
        log.showWarn('getNextPosition, next position exceed top!');
        return undefined;
      }
    }
    if (nextPosPage === undefined) {
      return [nextPosRow, nextPosColumn];
    } else {
      return [nextPosRow, nextPosColumn, nextPosPage];
    }
  }

  public reorderAllAppInPages(): void {
  }

  public updateAppInstallStatus(item: AppItemInfo): void {
    if (this.mAppGridLayoutItemList.length === 0) {
      log.showWarn('updateAppInstallStatus app list empty');
      return;
    }

    if (item.page === undefined || item.page >= this.mAppGridLayoutItemList.length) {
      log.showWarn('updateAppInstallStatus page index invalid');
      return;
    }

    let dstAppItem = this.mAppGridLayoutItemList[item.page].pageInfo.find(app => {
      return item.appIndex === app.appIndex && item.bundleName === app.bundleName;
    });
    log.showInfo(`updateAppInstallStatus src app item: ${item?.bundleName} ${item.appStatus}`);

    if (dstAppItem) {
      dstAppItem.appStatus = item.appStatus;
      log.showInfo(`updateAppInstallStatus dst app item: ${dstAppItem?.bundleName} ${dstAppItem.appStatus}`);
    }
  }
  public afterSetAppGridLayoutItemList(appGridLayoutItemList: AppLayoutInfo[]): void {
  }

  public beyondOneScreen(pages: number): boolean {
    return pages > PAGES_IN_ONE_SCREEN;
  }
}