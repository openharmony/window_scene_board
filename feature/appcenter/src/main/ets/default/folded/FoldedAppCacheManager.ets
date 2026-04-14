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
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { DragItemPosition } from '@ohos/componentdrag';
import { AppItemInfo, RdbStoreManager } from '@ohos/launchercommon';
import DefaultAppCacheManager from '../common/cache/DefaultAppCacheManager';
import { AppLayoutInfo } from '../common/viewmodel/AppLayoutInfo';
import { CheckEmptyUtils} from '@ohos/basicutils';
import { FoldAcGridLayoutConstants, FoldedDeviceAcViewModel, SCBFoldedState } from './FoldedDeviceAcViewModel';
import { AppGridItemInfo } from '@ohos/launchercommon/src/main/ets/bean/AppGridItemInfo';
import AppGridLayoutUtil from '../common/util/AppGridLayoutUtil';

const TAG = 'FoldedAppCacheManager';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const PAGES_IN_ONE_SCREEN = 2;

export class FoldedAppCacheManager extends DefaultAppCacheManager {
  protected mAppPageListForLandscape: AppLayoutInfo[] = [];

  public reorderAllAppInPages(): void {
    log.showInfo('reorderAllAppInPages');

    if (!FoldedDeviceAcViewModel.getInstance().isUnFoldedHorizontal()) {
      return;
    }

    if (this.mAppPageListForLandscape.length === 0) {
      this.mAppPageListForLandscape = this.deepCloneAppList(this.mAppGridLayoutItemList);
      this.doReorderAppsToLandscape();
    }
  }

  protected getCachedAppList(): AppLayoutInfo[] {
    if (FoldedDeviceAcViewModel.getInstance().isUnFoldedHorizontal()) {
      return this.mAppPageListForLandscape;
    } else {
      return this.mAppGridLayoutItemList;
    }
  }

  public getAppGridLayoutItemsByPage(pageIndex: number): AppItemInfo[] {
    let pageList = this.mAppGridLayoutItemList;
    if (FoldedDeviceAcViewModel.getInstance().isUnFoldedHorizontal()) {
      pageList = this.mAppPageListForLandscape;
    }

    if (!pageList || pageIndex >= pageList.length) {
      return [];
    }

    let sourcePageInfo: AppItemInfo[] = pageList[pageIndex]?.pageInfo ?? [];
    let destItemList: AppItemInfo[] = [];
    sourcePageInfo.forEach((item: AppItemInfo) => {
      destItemList.push(ObjectCopyUtil.deepClone(item, new AppItemInfo()));
    });
    return destItemList;
  }

  public updateItemPositionById(updateItems: AppItemInfo[], operationDataSource?: AppLayoutInfo[],
    isOperateDb: boolean = true): boolean {
    log.showInfo(`updateItemPositionById isLocal: ${operationDataSource !== undefined}`);
    if (CheckEmptyUtils.isEmptyArr(updateItems)) {
      log.showWarn('updateItemPositionById updateItem empty');
      return false;
    }
    let dataSource: AppLayoutInfo[] = operationDataSource ? operationDataSource : this.getCachedAppList();
    if (CheckEmptyUtils.isEmptyArr(dataSource)) {
      log.showWarn(`updateItemPositionById list: ${updateItems.length} `);
      return false;
    }
    const map: Map<string, AppItemInfo> = new Map();
    updateItems.forEach((value: AppItemInfo) => map.set(this.getAppGridKey(value), value));
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
      if (FoldedDeviceAcViewModel.getInstance().isUnFoldedHorizontal()) {
        this.transformAndSyncPortraitCaches(updateDbInfo, true);
      } else {
        this.transformAndSyncLandscapeCaches(updateDbInfo, true);
      }

      try {
        RdbStoreManager.getInstance().updateAppCenterItemPositions(updateDbInfo);
      } catch (error) {
        log.showError(`updateItemPositionById with error ${error.message}`);
      }
    }
    return true;
  }

  private transformAndSyncLandscapeCaches(updateDbInfo: AppGridItemInfo[], isCrossPage: boolean = false): void {
    log.showInfo(`transformAndSyncLandscapeCaches ${isCrossPage}`);

    if (this.mAppPageListForLandscape.length === 0) {
      log.showInfo('Ignore txf landscape app coordinate for empty ls app list');
      return;
    }

    updateDbInfo.forEach((app: AppGridItemInfo, index: number) => {
      let idx = ((app?.row ?? 0) * FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_GRID_COLUMNS) + (app?.column ?? 0);
      let newMappedRow = Math.floor(idx / FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_HORIZONTAL_GRID_COLUMNS);
      let newMappedCol = idx % FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_HORIZONTAL_GRID_COLUMNS;
      log.showInfo(`transformAndSyncLsCaches-${app.bundleName}-${app.page}-${app.row}-${app.column}` +
        `-${idx}-${newMappedRow}-${newMappedCol}`);

      if (app.page !== undefined && app.page < this.mAppPageListForLandscape.length) {
        let appItem = this.mAppPageListForLandscape[app.page].pageInfo.find(item => {
          return item.appIndex === app.appIndex && item.bundleName === app.bundleName;
        });

        if (appItem) {
          log.showInfo(`Found app item in landscape list-${appItem.bundleName}-${appItem.row}-${appItem.column}`);
          appItem.row = newMappedRow;
          appItem.column = newMappedCol;
        } else if (isCrossPage) {
          for (let i = 0; i < this.mAppPageListForLandscape.length; i++) {
            appItem = this.mAppPageListForLandscape[i].pageInfo.find((item) => {
              return item.appIndex === app.appIndex && item.bundleName === app.bundleName;
            });
            if (appItem) {
              break;
            }
          }
          if (!appItem) {
            log.showError(`transformAndSyncLandscapeCaches failed. can't find ${app.bundleName}`);
            return;
          }
          log.showInfo(`transformAndSyncLandscapeCaches cross page sync ${app.bundleName}(${app.page}, ${app.row}, ${app.column}) to (${appItem.row}, ${appItem.column}, ${appItem.page})`);
          appItem.row = newMappedRow;
          appItem.column = newMappedCol;
          appItem.page = app.page;
          this.rePageByItemPageNumber(this.mAppPageListForLandscape);
        }
      }
    });
    // 重新排序数组
    for (let i = 0; i < this.mAppPageListForLandscape.length; i++) {
      this.mAppPageListForLandscape[i].pageInfo.sort((a, b) => {
        if (a.row !== b.row) {
          return (a.row ?? 0) - (b.row ?? 0);
        } else {
          return (a.column ?? 0) - (b.column ?? 0);
        }
      });
    }
  }

  private transformAndSyncPortraitCaches(updateDbInfo: AppGridItemInfo[], isCrossPage: boolean = false): void {
    log.showInfo(`transformAndSyncPortraitCaches ${isCrossPage}`);
    updateDbInfo.forEach((app: AppGridItemInfo, index: number) => {
      let idx = ((app?.row ?? 0) * 10) + (app?.column ?? 0);
      let newMappedRow = Math.floor(idx / 8);
      let newMappedCol = idx % 8;
      log.showInfo(`transformAndSyncPortCaches-${app.bundleName}-${app.page}-${app.row}-${app.column}` +
        `-${idx}-${newMappedRow}-${newMappedCol}`);
      app.row = newMappedRow;
      app.column = newMappedCol;

      if (app.page !== undefined && app.page < this.mAppGridLayoutItemList.length) {
        let appItem = this.mAppGridLayoutItemList[app.page].pageInfo.find(item => {
          return item.appIndex === app.appIndex && item.bundleName === app.bundleName;
        });

        if (appItem) {
          log.showInfo(`Found app item in potrait list-${appItem.bundleName}-${appItem.row}-${appItem.column}`);
          appItem.row = newMappedRow;
          appItem.column = newMappedCol;
        } else if (isCrossPage) {
          for (let i = 0; i < this.mAppGridLayoutItemList.length; i++) {
            appItem = this.mAppGridLayoutItemList[i].pageInfo.find((item) => {
              return item.appIndex === app.appIndex && item.bundleName === app.bundleName;
            });
            if (appItem) {
              break;
            }
          }
          if (!appItem) {
            log.showError(`transformAndSyncPortraitCaches failed. can't find ${app.bundleName}`);
            return;
          }
          log.showInfo(`transformAndSyncPortraitCaches cross page sync ${app.bundleName}(${app.page}, ${app.row}, ${app.column}) to (${appItem.row}, ${appItem.column}, ${appItem.page})`);
          appItem.row = newMappedRow;
          appItem.column = newMappedCol;
          appItem.page = app.page;
          this.rePageByItemPageNumber(this.mAppGridLayoutItemList);
        }
      }
    });
    // 重新排序数组
    for (let i = 0; i < this.mAppGridLayoutItemList.length; i++) {
      this.mAppGridLayoutItemList[i].pageInfo.sort((a, b) => {
        if (a.row !== b.row) {
          return (a.row ?? 0) - (b.row ?? 0);
        } else {
          return (a.column ?? 0) - (b.column ?? 0);
        }
      });
    }
  }

  public updateItemForDifferentPage(startPos: DragItemPosition, endItem: AppItemInfo,
    isOperateDb: boolean = true): boolean {
    log.showInfo('updateItemForDifferentPageNew');

    if (!this.checkInputPosition(startPos, endItem)) {
      return false;
    }
    if (endItem.page === undefined || endItem.column === undefined || endItem.row === undefined) {
      log.showError(`updateItemForDifferentPage failed. endItem invalid (${endItem.row}, ${endItem.column}, ${endItem.page})`);
      return false;
    }

    let fs = FoldedDeviceAcViewModel.getInstance().getCurrentFoldState();
    let isLandscape = FoldedDeviceAcViewModel.getInstance().isUnFoldedHorizontal();
    let pagesList: AppLayoutInfo[] = isLandscape ? this.mAppPageListForLandscape : this.mAppGridLayoutItemList;

    const startPageInfo: AppItemInfo[] = pagesList[startPos.page].pageInfo;
    const endPageInfo: AppItemInfo[] = pagesList[endItem.page].pageInfo;
    const startIndex: number = startPos.column + startPos.row * this.mGridStyleConfig.mColumns;
    const endIndex: number = endItem.column + endItem.row * this.mGridStyleConfig.mColumns;
    log.showInfo(`updateItemForDifferentPageNew: endPageInfo-${pagesList.length}-${isLandscape}-${fs}-` +
      `${startPos.page}-${endItem.page}-${endItem.row}-${endItem.column}-${endIndex}`);

    if (!this.checkUpdatePageInfo(startPageInfo, endPageInfo, startIndex, endIndex)) {
      return false;
    }

    let updateDbInfo: AppGridItemInfo[] = [];
    if (startPageInfo.length === 1) {
      log.showInfo('updateItemForDifferentPage: startPage only one item');
    } else {
      log.showInfo(`updateItemForDifferentPageNew-reposition-${startIndex}-${endIndex}`);
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

    let idxInStartPage = startPageInfo.findIndex((itemInfo: AppItemInfo) => {
      return itemInfo.bundleName === endItem.bundleName && itemInfo.appIndex === endItem.appIndex;
    });
    log.showInfo(`updateItemForDifferentPageNew-remove cache app-${idxInStartPage}-${startPageInfo.length}-` +
      `${startIndex}`);
    let rsDelResult = startPageInfo.splice(idxInStartPage, 1);
    if (!rsDelResult || rsDelResult.length === 0 || rsDelResult[0]?.bundleName !== endItem.bundleName) {
      log.showWarn(`Delete fail00-${endItem.bundleName}-${rsDelResult[0]?.bundleName}-${startIndex}-${fs}` +
        `-${startPos.page}`);
    }
    this.updateEndPage(endIndex, endPageInfo, endItem, updateDbInfo);

    // 横竖屏数据同步
    this.moveTargetAppBetweenStartAndEndPages(isLandscape, startIndex, endIndex, startPos, endItem);

    // 删除空白页后的list,更新位置
    let beforeLen = updateDbInfo.length;
    let pageChangedApps: AppItemInfo[] = [];
    this.checkBlankPagesAndDelete(pageChangedApps);
    pageChangedApps?.forEach((itemInfo: AppItemInfo) => {
      updateDbInfo.push(AppGridItemInfo.newInstanceFromAppItemInfo(itemInfo));
    });
    log.showInfo(`findAppItem:beforeLen:${beforeLen} afterLen:${updateDbInfo.length}`);
    updateDbInfo.push(AppGridItemInfo.newInstanceFromAppItemInfo(endItem));

    if (isLandscape) {
      this.transformAndSyncPortraitCaches(updateDbInfo);
    } else {
      this.transformAndSyncLandscapeCaches(updateDbInfo);
    }

    log.showInfo('updateItemForDifferentPageNew-udb');
    return this.checkAndUpdateDB(updateDbInfo, isOperateDb);
  }

  private moveTargetAppBetweenStartAndEndPages(isLandscape: boolean, startIndex: number, endIndex: number,
    startPos: DragItemPosition, endItem: AppItemInfo): boolean {
    if (endItem.page === undefined || endItem.column === undefined || endItem.row === undefined) {
      log.showError(`moveTargetAppBetweenStartAndEndPages failed. endItem invalid (${endItem.row}, ${endItem.column}, ${endItem.page})`);
      return false;
    }
    let result = true;
    if (isLandscape) {
      let lenBefore = this.mAppGridLayoutItemList[startPos.page].pageInfo.length;
      let oldIdxInPortrait = this.mAppGridLayoutItemList[startPos.page].pageInfo.findIndex((itemInfo: AppItemInfo) => {
        return itemInfo.bundleName === endItem.bundleName && itemInfo.appIndex === endItem.appIndex;
      });
      let originItem = this.mAppGridLayoutItemList[startPos.page].pageInfo.splice(oldIdxInPortrait, 1)[0];
      let lenAfter = this.mAppGridLayoutItemList[startPos.page].pageInfo.length;
      if (!originItem || originItem.bundleName !== endItem.bundleName) {
        let curIdx = this.mAppGridLayoutItemList[startPos.page].pageInfo.findIndex((itemInfo: AppItemInfo) => {
          return itemInfo.bundleName === endItem.bundleName && itemInfo.appIndex === endItem.appIndex;
        });
        log.showWarn(`Delete fail01-${endItem.bundleName}-${originItem?.bundleName}-${startIndex}` +
          `-${oldIdxInPortrait}-${curIdx}-${lenBefore}`);
        result = false;
      } else {
        let curIdx = this.mAppGridLayoutItemList[startPos.page].pageInfo.findIndex((itemInfo: AppItemInfo) => {
          return itemInfo.bundleName === endItem.bundleName && itemInfo.appIndex === endItem.appIndex;
        });
        log.showInfo(`Delete success-${endItem.bundleName}-${originItem?.bundleName}-${startIndex}-` +
          `-${oldIdxInPortrait}-${endIndex}-${curIdx}-${lenBefore}-${lenAfter}`);
      }

      let idx = (endItem.row * 10) + endItem.column;
      let newMappedRow = Math.floor(endIndex / 8);
      let newMappedCol = endIndex % 8;
      originItem.row = newMappedRow;
      originItem.column = newMappedCol;
      originItem.page = endItem.page;
      this.mAppGridLayoutItemList[endItem.page].pageInfo.splice(endIndex, 0, originItem);
      log.showInfo(`updateItemForDifferentPage LS-${startIndex}-${idx}-${newMappedRow}-${newMappedCol}-${endIndex}, ` +
        `endPage-${endItem.page}-bdl-${originItem?.bundleName}-${lenBefore}-${lenAfter}-${endItem.bundleName}`);
    } else {
      let validLs = this.mAppPageListForLandscape.length !== 0 && this.mAppPageListForLandscape[startPos.page];
      log.showInfo(`updateItemForDifferentPageNew-pt-tls-${this.mAppPageListForLandscape.length}-${validLs}`);
      if (!validLs) {
        return result;
      }

      let realIdxLs = this.mAppPageListForLandscape[startPos.page].pageInfo.findIndex((itemInfo: AppItemInfo) => {
        return itemInfo.bundleName === endItem.bundleName && itemInfo.appIndex === endItem.appIndex;
      });
      let rsLsItems = this.mAppPageListForLandscape[startPos.page].pageInfo.splice(realIdxLs, 1);
      if (!rsLsItems || rsLsItems.length === 0) {
        log.showWarn(`Delete fail02-${endItem.bundleName}-${startIndex}` +
          `-${realIdxLs}-${this.mAppPageListForLandscape[startPos.page]?.pageInfo?.length}`);
        result = false;
        return result;
      }

      let lsInitPosItem = rsLsItems[0];
      if (!lsInitPosItem || lsInitPosItem.bundleName !== endItem.bundleName) {
        let curIdx = this.mAppPageListForLandscape[startPos.page].pageInfo.findIndex((itemInfo: AppItemInfo) => {
          return itemInfo.bundleName === endItem.bundleName && itemInfo.appIndex === endItem.appIndex;
        });
        log.showWarn(`Delete fail03-${endItem.bundleName}-${lsInitPosItem?.bundleName}-${startIndex}` +
          `-${realIdxLs}-${curIdx}`);
        result = false;
        return result;
      }

      let idx = (endItem.row * 8) + endItem.column;
      let newMappedRow = Math.floor(endIndex / 10);
      let newMappedCol = endIndex % 10;
      lsInitPosItem.row = newMappedRow;
      lsInitPosItem.column = newMappedCol;
      lsInitPosItem.page = endItem.page;
      this.mAppPageListForLandscape[endItem.page].pageInfo.splice(endIndex, 0, lsInitPosItem);
      log.showInfo(`updateItemForDifferentPage PT-${startIndex}-${idx}-${newMappedRow}-${newMappedCol}-${endIndex}` +
        `-${realIdxLs}, endPage-${endItem.page}`);
    }

    return result;
  }

  public setAppGridLayoutItemList(appGridLayoutItemList: AppLayoutInfo[]): void {
    if (appGridLayoutItemList.length === 0) {
      log.showWarn('Invalid page list data');
      return;
    }

    if (!appGridLayoutItemList[0].forLandscape) {
      log.showInfo('setAppGridLayoutItemList not for ls');
      super.setAppGridLayoutItemList(appGridLayoutItemList);
      return;
    }

    if (this.mAppPageListForLandscape.length === 0) {
      this.mAppPageListForLandscape = appGridLayoutItemList;

      if (this.mAppGridLayoutItemList.length === 0) {
        log.showInfo('setAppGridLayoutItemList tx portrait');
        this.mAppGridLayoutItemList = this.deepCloneAppList(this.mAppPageListForLandscape);
        this.doReorderAppsToPortrait();
      }
    }
  }

  public afterSetAppGridLayoutItemList(appGridLayoutItemList: AppLayoutInfo[]): void {
    if (!FoldedDeviceAcViewModel.getInstance().isUnFoldedHorizontal()) {
      return;
    }
    if (this.mAppPageListForLandscape.length === 0) {
      log.showInfo('setAppGridLayoutItemList tx landscape');
      this.mAppPageListForLandscape = this.deepCloneAppList(this.mAppGridLayoutItemList);
      this.doReorderAppsToLandscape();
    }
  }

  /**
   *
   * 应用中心更新专用缓存管理
   *
   * @param appGridLayoutItemList
   * @param changedItem
   */
  public setAndUpdateAppListForPkgChange(appGridLayoutItemList: AppLayoutInfo[], changedItem?: AppItemInfo): void {
    this.setAppGridLayoutItemList(appGridLayoutItemList);

    if (!changedItem || appGridLayoutItemList.length === 0) {
      log.showInfo(`null change item-${appGridLayoutItemList.length}`);
      return;
    }

    if (this.mAppPageListForLandscape.length === 0 || changedItem.page === undefined) {
      log.showInfo(`setAndUpdateAppListForPkgChange page invalid or empty ls list-${changedItem.page}-${this.mAppPageListForLandscape.length}`);
      return;
    }

    // 不管是竖屏還是橫屏态，横屏有缓存数据，刷新其属性
    let idxLs = this.mAppPageListForLandscape[changedItem.page]?.pageInfo?.findIndex((itemInfo: AppItemInfo) => {
      return itemInfo.bundleName === changedItem.bundleName && itemInfo.appIndex === changedItem.appIndex;
    });

    if (idxLs >= 0) {
      this.mAppPageListForLandscape[changedItem.page].pageInfo[idxLs].isUninstallAble = changedItem.isUninstallAble;
      log.showInfo(`setAndUpdateAppListForPkgChange-${idxLs}-${this.mAppPageListForLandscape[changedItem.page].pageInfo[idxLs].appStatus}`);
      this.mAppPageListForLandscape[changedItem.page].pageInfo[idxLs].appStatus = changedItem.appStatus;
      this.mAppPageListForLandscape[changedItem.page].pageInfo[idxLs].abilityName = changedItem.abilityName;
      this.mAppPageListForLandscape[changedItem.page].pageInfo[idxLs].moduleName = changedItem.moduleName;
      this.mAppPageListForLandscape[changedItem.page].pageInfo[idxLs].appIndex = changedItem.appIndex;
      this.mAppPageListForLandscape[changedItem.page].pageInfo[idxLs].appLabelId = changedItem.appLabelId;
      this.mAppPageListForLandscape[changedItem.page].pageInfo[idxLs].appIconId = changedItem.appIconId;
      this.mAppPageListForLandscape[changedItem.page].pageInfo[idxLs].applicationLabelId =
        changedItem.applicationLabelId;
      this.mAppPageListForLandscape[changedItem.page].pageInfo[idxLs].keyName = changedItem.keyName;
    } else {
      log.showInfo(`setAndUpdateAppListForPkgChange-not found-ls-${idxLs}-${changedItem?.bundleName}`);
    }

    // 橫屏需要更新豎屏緩存
    if (appGridLayoutItemList[0].forLandscape) {
      let idxPt = this.mAppGridLayoutItemList[changedItem.page]?.pageInfo?.findIndex((itemInfo: AppItemInfo) => {
        return itemInfo.bundleName === changedItem.bundleName && itemInfo.appIndex === changedItem.appIndex;
      });

      if (idxPt >= 0) {
        this.mAppGridLayoutItemList[changedItem.page].pageInfo[idxPt].isUninstallAble = changedItem.isUninstallAble;
        this.mAppGridLayoutItemList[changedItem.page].pageInfo[idxPt].appStatus = changedItem.appStatus;
        this.mAppGridLayoutItemList[changedItem.page].pageInfo[idxPt].abilityName = changedItem.abilityName;
        this.mAppGridLayoutItemList[changedItem.page].pageInfo[idxPt].moduleName = changedItem.moduleName;
        this.mAppGridLayoutItemList[changedItem.page].pageInfo[idxPt].appIndex = changedItem.appIndex;
        this.mAppGridLayoutItemList[changedItem.page].pageInfo[idxPt].appLabelId = changedItem.appLabelId;
        this.mAppGridLayoutItemList[changedItem.page].pageInfo[idxPt].appIconId = changedItem.appIconId;
        this.mAppGridLayoutItemList[changedItem.page].pageInfo[idxPt].applicationLabelId =
          changedItem.applicationLabelId;
        this.mAppGridLayoutItemList[changedItem.page].pageInfo[idxPt].keyName = changedItem.keyName;
        log.showInfo(`update portrait app data-${changedItem.appStatus}-${this.mAppGridLayoutItemList[changedItem.page].pageInfo[idxPt].appStatus}`);
      } else {
        log.showInfo(`setAndUpdateAppListForPkgChange-not found-pt-${idxPt}-${changedItem?.bundleName}`);
      }
    }
  }

  /**
   *
   * 大屏幕机安装新应用专用，会走两次
   *
   * @param appGridLayoutItemList
   * @param newAddItem
   */
  public updateAppPageList(appGridLayoutItemList: AppLayoutInfo[], newAddItem?: AppItemInfo): void {
    this.setAppGridLayoutItemList(appGridLayoutItemList);

    if (!newAddItem || appGridLayoutItemList.length === 0) {
      return;
    }

    if (this.mAppPageListForLandscape.length === 0 || newAddItem.page === undefined) {
      log.showInfo(`updateAppPageList page invalid or empty ls list-${newAddItem.page}-${this.mAppPageListForLandscape.length}`);
      return;
    }

    // 先处理横屏的缓存
    let idxLs = this.mAppPageListForLandscape[newAddItem.page].pageInfo.findIndex((itemInfo: AppItemInfo) => {
      return itemInfo.bundleName === newAddItem.bundleName && itemInfo.appIndex === newAddItem.appIndex;
    });

    if (idxLs >= 0) {
      this.mAppPageListForLandscape[newAddItem.page].pageInfo[idxLs].isUninstallAble = newAddItem.isUninstallAble;
      log.showInfo(`updateAppPageList findIndex-${idxLs}-${this.mAppPageListForLandscape[newAddItem.page].pageInfo[idxLs].appStatus}`);
      this.mAppPageListForLandscape[newAddItem.page].pageInfo[idxLs].appStatus = newAddItem.appStatus;
      this.mAppPageListForLandscape[newAddItem.page].pageInfo[idxLs].abilityName = newAddItem.abilityName;
      this.mAppPageListForLandscape[newAddItem.page].pageInfo[idxLs].moduleName = newAddItem.moduleName;
      this.mAppPageListForLandscape[newAddItem.page].pageInfo[idxLs].appIndex = newAddItem.appIndex;
      this.mAppPageListForLandscape[newAddItem.page].pageInfo[idxLs].appLabelId = newAddItem.appLabelId;
      this.mAppPageListForLandscape[newAddItem.page].pageInfo[idxLs].appIconId = newAddItem.appIconId;
      this.mAppPageListForLandscape[newAddItem.page].pageInfo[idxLs].applicationLabelId = newAddItem.applicationLabelId;
      this.mAppPageListForLandscape[newAddItem.page].pageInfo[idxLs].keyName = newAddItem.keyName;
    } else {
      if (!FoldedDeviceAcViewModel.getInstance().isUnFoldedHorizontal()) {
        let r1 = newAddItem.row;
        let c1 = newAddItem.column;
        let idx1 = (r1 ?? 0) * FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_GRID_COLUMNS + (c1 ?? 0);
        let newItem1 = ObjectCopyUtil.deepClone(newAddItem, new AppItemInfo());
        newItem1.row = Math.floor(idx1 / FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_HORIZONTAL_GRID_COLUMNS);
        newItem1.column = idx1 % FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_HORIZONTAL_GRID_COLUMNS;
        newItem1.appStatus = newAddItem.appStatus;
        this.mAppPageListForLandscape[newAddItem.page].pageInfo.push(newItem1);
        log.showInfo(`updateAppPageList add new item to ls-${idx1}-${r1}-${c1}-${newItem1.row}-${newItem1.column}-${newItem1.isUninstallAble}-${newAddItem.isUninstallAble}`);
      } else {
        log.showInfo('add new item strait to ls list');
        this.mAppPageListForLandscape[newAddItem.page].pageInfo.push(newAddItem);
      }
    }

    // 再处理竖屏的缓存
    let idxPt = this.mAppGridLayoutItemList[newAddItem.page].pageInfo.findIndex((itemInfo: AppItemInfo) => {
      return itemInfo.bundleName === newAddItem.bundleName && itemInfo.appIndex === newAddItem.appIndex;
    });

    if (idxPt >= 0) {
      this.mAppGridLayoutItemList[newAddItem.page].pageInfo[idxPt].isUninstallAble = newAddItem.isUninstallAble;
      this.mAppGridLayoutItemList[newAddItem.page].pageInfo[idxPt].appStatus = newAddItem.appStatus;
      this.mAppGridLayoutItemList[newAddItem.page].pageInfo[idxPt].abilityName = newAddItem.abilityName;
      this.mAppGridLayoutItemList[newAddItem.page].pageInfo[idxPt].moduleName = newAddItem.moduleName;
      this.mAppGridLayoutItemList[newAddItem.page].pageInfo[idxPt].appIndex = newAddItem.appIndex;
      this.mAppGridLayoutItemList[newAddItem.page].pageInfo[idxPt].appLabelId = newAddItem.appLabelId;
      this.mAppGridLayoutItemList[newAddItem.page].pageInfo[idxPt].appIconId = newAddItem.appIconId;
      this.mAppGridLayoutItemList[newAddItem.page].pageInfo[idxPt].applicationLabelId = newAddItem.applicationLabelId;
      this.mAppGridLayoutItemList[newAddItem.page].pageInfo[idxPt].keyName = newAddItem.keyName;
      log.showInfo(`handle portrait app data-${newAddItem.appStatus}-${this.mAppGridLayoutItemList[newAddItem.page].pageInfo[idxPt].appStatus}`);
    } else {
      if (FoldedDeviceAcViewModel.getInstance().isUnFoldedHorizontal()) {
        let r2 = newAddItem.row;
        let c2 = newAddItem.column;
        let idx2 = (r2 ?? 0) * FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_HORIZONTAL_GRID_COLUMNS + (c2 ?? 0);
        let newItem2 = ObjectCopyUtil.deepClone(newAddItem, new AppItemInfo());
        newItem2.row = Math.floor(idx2 / FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_GRID_COLUMNS);
        newItem2.column = idx2 % FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_GRID_COLUMNS;
        this.mAppGridLayoutItemList[newAddItem.page].pageInfo.push(newItem2);
        log.showInfo(`updateAppPageList add new item to pt-${idx2}-${r2}-${c2}-${newItem2.row}-${newItem2.column}-${newItem2.isUninstallAble}-${newAddItem.isUninstallAble}`);
      } else {
        log.showInfo('add new item strait to pt list');
        this.mAppGridLayoutItemList[newAddItem.page].pageInfo.push(newAddItem);
      }
    }
  }

  public addBlankPage(): boolean {
    let result = super.addBlankPage();
    if (result) {
      if (this.mAppPageListForLandscape.length > 0) {
        this.mAppPageListForLandscape.push({
          pageInfo: [],
          index: this.mAppPageListForLandscape.length,
          packageChangeTime: 0,
          forLandscape: true
        });
      } else {
        log.showInfo('addBlankPage ignore empty landscape app list');
      }
    }
    return result;
  }

  public putAppItemToGrid(appLayoutInfos: AppLayoutInfo[]): void {
    super.putAppItemToGrid(appLayoutInfos);
    if (this.mGridStyleConfig.mColumns > FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_GRID_COLUMNS) {
      appLayoutInfos.forEach((page: AppLayoutInfo) => {
        page.forLandscape = true;
      });
    }
  }

  public updateAppInstallStatus(item: AppItemInfo): void {
    if (this.mAppPageListForLandscape.length === 0) {
      return;
    }

    if (item.page === undefined || item.page >= this.mAppGridLayoutItemList.length) {
      log.showWarn('updateAppInstallStatus page index invalid');
      return;
    }

    let portItem = this.mAppGridLayoutItemList[item.page].pageInfo.find(app => {
      return item.appIndex === app.appIndex && item.bundleName === app.bundleName;
    });

    if (portItem) {
      log.showInfo(`updateAppInstallStatus p to ${item.appStatus}`);
      portItem.appStatus = item.appStatus;
    }

    if (item.page >= this.mAppPageListForLandscape.length) {
      log.showWarn('updateAppInstallStatus page index invalid exceed landscape pages');
      return;
    }

    let lsAppItem = this.mAppPageListForLandscape[item.page].pageInfo.find(app => {
      return item.appIndex === app.appIndex && item.bundleName === app.bundleName;
    });

    if (lsAppItem) {
      log.showInfo(`updateAppInstallStatus l to ${item.appStatus}`);
      lsAppItem.appStatus = item.appStatus;
    }
  }

  public deleteCachedLayoutItem(bundleName: string, isOperateDb: boolean = true, appIndex: number = 0): boolean {
    let mRows: number = FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_GRID_ROWS;
    let mColumns: number = FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_GRID_COLUMNS;
    let result = super.deleteCachedLayoutItem(bundleName, isOperateDb, appIndex, mRows, mColumns);
    mRows = FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_HORIZONTAL_GRID_ROWS;
    mColumns = FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_HORIZONTAL_GRID_COLUMNS;
    log.showInfo(`deleteCachedLayoutItem2-${result}`);

    if (!result) {
      return result;
    }

    if (this.mAppPageListForLandscape.length === 0) {
      return result;
    }

    this.mAppPageListForLandscape.forEach((page: AppLayoutInfo) => {
      let itemIndex: number = page.pageInfo?.findIndex((itemInfo: AppItemInfo) => {
        return itemInfo.bundleName === bundleName && itemInfo.appIndex === appIndex;
      });

      if (itemIndex > -1) {
        let item = page.pageInfo[itemIndex];
        for (let i = itemIndex + 1; i < page.pageInfo.length; i++) {
          const nextPos: number[] | undefined =
            this.getNextPosition(true, page.pageInfo[i].row, page.pageInfo[i].column, undefined, mRows, mColumns);
          page.pageInfo[i].page = item.page;
          page.pageInfo[i].row = nextPos ? nextPos[0] : page.pageInfo[i].row;
          page.pageInfo[i].column = nextPos ? nextPos[1] : page.pageInfo[i].column;
        }

        log.showInfo(`deleteCachedLayoutItem2-${bundleName}-${itemIndex}`);
        page.pageInfo.splice(itemIndex, 1);
      }
    });

    let pageChangedApps: AppItemInfo[] = [];
    this.checkBlankPagesAndDelete(pageChangedApps, this.mAppPageListForLandscape);
    if (FoldedDeviceAcViewModel.getInstance().isUnFoldedHorizontal()) {
      super.deleteBlankPage(this.mAppGridLayoutItemList);
    }

    return result;
  }

  /**
   * HPR-删除空白页
   * @returns
   */
  public deleteBlankPage(dataSource?: AppLayoutInfo[]): boolean {
    log.showInfo('deleteBlankPage-hpr');
    const retForLandscape: boolean = super.deleteBlankPage(this.mAppPageListForLandscape);
    const ret: boolean = super.deleteBlankPage(this.mAppGridLayoutItemList);
    return retForLandscape || ret;
  }

  public getAppGridLayoutItemList(clone: boolean = true): AppLayoutInfo[] {
    log.showInfo('getAppGridLayoutItemList');
    if (clone) {
      if (FoldedDeviceAcViewModel.getInstance().isUnFoldedHorizontal()) {
        log.showInfo(`getAppGridLayoutItemList2-${this.mAppPageListForLandscape.length}`);
        return this.deepCloneAppList(this.mAppPageListForLandscape);
      } else {
        return this.deepCloneAppList(this.mAppGridLayoutItemList);
      }
    } else {
      if (FoldedDeviceAcViewModel.getInstance().isUnFoldedHorizontal()) {
        return this.mAppPageListForLandscape;
      } else {
        return this.mAppGridLayoutItemList;
      }
    }
  }

  private doReorderAppsToLandscape(): void {
    this.mAppPageListForLandscape.forEach((page: AppLayoutInfo) => {
      page.pageInfo.forEach((item: AppItemInfo) => {
        let oldRow = item.row;
        let oldCol = item.column;
        let idx = (oldRow ?? 0) * FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_GRID_COLUMNS +
          (oldCol ?? 0);

        item.row = Math.floor(idx / FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_HORIZONTAL_GRID_COLUMNS);
        item.column = idx % FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_HORIZONTAL_GRID_COLUMNS;
        log.showInfo(`doReorderAppsToLandscape-${oldRow}-${oldCol}-${item.page}-${idx}-${item.row}-${item.column}`);
      });

      page.forLandscape = true;
    });
  }

  private doReorderAppsToPortrait(): void {
    this.mAppGridLayoutItemList.forEach((page: AppLayoutInfo) => {
      page.pageInfo.forEach((item: AppItemInfo) => {
        let oldRow = item.row;
        let oldCol = item.column;
        let idx = (oldRow ?? 0) *
        FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_HORIZONTAL_GRID_COLUMNS + (oldCol ?? 0);

        item.row = Math.floor(idx / FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_GRID_COLUMNS);
        item.column = idx % FoldAcGridLayoutConstants.DEFAULT_HPR_APP_CENTER_GRID_COLUMNS;
        log.showInfo(`doReorderAppsToPortrait-${oldRow}-${oldCol}-${item.page}-${idx}-${item.row}-${item.column}`);
      });

      page.forLandscape = false;
    });
  }

  /**
   * 排序指定页面h
   */
  public sortAllData(pageIndex?: number[]): void {
    log.showInfo(`folded start to sort all Data`);
    if (pageIndex) {
      this.mAppGridLayoutItemList?.forEach((pageData: AppLayoutInfo) => {
        if (pageIndex.includes(pageData.index)) {
          this.sortPageData(pageData?.pageInfo);
        }
      });

      this.mAppPageListForLandscape?.forEach((pageData: AppLayoutInfo) => {
        if (pageIndex.includes(pageData.index)) {
          this.sortPageData(pageData?.pageInfo);
        }
      });
    } else {
      this.mAppGridLayoutItemList?.forEach((pageData: AppLayoutInfo) => {
        this.sortPageData(pageData?.pageInfo);
      });

      this.mAppPageListForLandscape?.forEach((pageData: AppLayoutInfo) => {
        this.sortPageData(pageData?.pageInfo);
      });
    }
  }


  public beyondOneScreen(pages: number): boolean {
    const fs: SCBFoldedState = FoldedDeviceAcViewModel.getInstance().getCurrentFoldState();
    switch (fs) {
      case SCBFoldedState.HALF_FOLDED_VIRTUAL_KEYBOARD:
      case SCBFoldedState.HALF_FOLDED_PHYSICAL_KEYBOARD:
        return super.beyondOneScreen(pages);
      default :
        return pages > PAGES_IN_ONE_SCREEN;
    }
  }
}