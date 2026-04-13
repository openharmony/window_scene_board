/**
 * Copyright (c) 2022-2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


import {
  CloseAppManager,
  BaseCloseAppHandler,
  CommonConstants,
  GridLayoutConfig,
  BigFolderStyleConfig,
  GridLayoutItemInfo,
  AppItemInfo,
  AppListInfo,
  ClosePosition
} from '@ohos/launchercommon';
import {
  LogDomain,
  LogHelper,
  CheckEmptyUtils,
  SingleContext,
  singleManager
} from '@ohos/basicutils';
import { desktopUtil } from '@ohos/componenthelper';

import { BigFolderViewModel } from '@ohos/bigfolder/src/main/ets/default/viewmodel/BigFolderViewModel';
import { StyleConstants } from '@ohos/launchercommon';
import { PageDesktopViewModel } from './viewmodel/PageDesktopViewModel';
import { PageDesktopGridStyleConfig } from '@ohos/launchercommon/src/main/ets/layoutconfig/PageDesktopGridStyleConfig';

const TAG = 'PageDesktopCloseAppHandlerForPC';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Desktop workspace start app processing class
 */
export class PageDesktopCloseAppHandlerForPC extends BaseCloseAppHandler {
  public static singleName: string = 'PageDesktopCloseAppHandlerForPC';
  private mGridConfig: GridLayoutConfig;
  private mPageDesktopStyleConfig: PageDesktopGridStyleConfig;
  private mFolderStyleConfig: BigFolderStyleConfig;
  private mAppItemBundleName: string = '';
  private mCloseAppType: boolean = true;
  private mFindPagedesktopPosition: boolean = true;
  private mFolderItem: GridLayoutItemInfo | undefined;

  constructor(ctx?: SingleContext) {
    super(ctx);
    this.mGridConfig = PageDesktopViewModel.getInstance(this.singleContext).getGridConfig();
    this.mPageDesktopStyleConfig = PageDesktopViewModel.getInstance(this.singleContext).getPageDesktopStyleConfig();
    this.mFolderStyleConfig = BigFolderViewModel.getInstance().getFolderStyleConfig();
  }

  static getInstance(ctx?: SingleContext): PageDesktopCloseAppHandlerForPC {
    return singleManager.get<PageDesktopCloseAppHandlerForPC>(PageDesktopCloseAppHandlerForPC, ctx);
  }

  /**
   * get app icon info
   *
   * @param windowTarget close window target
   */
  public getAppIconInfo(windowTarget: AppItemInfo): void {
    this.mAppItemBundleName = windowTarget.bundleName;
    this.calculateAppIconPosition();
    if (this.mFindPagedesktopPosition) {
      let styleConfig = PageDesktopViewModel.getInstance(this.singleContext).getPageDesktopStyleConfig();
      let appCloseIconInfo: ClosePosition = {
        appIconSize: this.mCloseAppType ? styleConfig.mIconSize : StyleConstants.DEFAULT_FOLDER_APP_SIZE,
        appIconHeight: this.mCloseAppType ? styleConfig.mIconSize : StyleConstants.DEFAULT_FOLDER_APP_SIZE,
        appIconPositionX: this.mAppIconPositionX,
        appIconPositionY: this.mAppIconPositionY
      };
      let appItem: GridLayoutItemInfo | undefined = this.getCloseAppItemInfo();
      CloseAppManager.getInstance().addPagedesktopClosePosition(appCloseIconInfo, appItem as AppItemInfo);
    } else {
      CloseAppManager.getInstance().addPagedesktopClosePosition(null);
    }
  }

  protected calculateAppIconPosition(): void {
    if (CheckEmptyUtils.isEmpty(this.mGridConfig) || CheckEmptyUtils.isEmpty(this.mPageDesktopStyleConfig)) {
      log.showError('calculateAppIconPosition with invalid config');
      return;
    }

    const gridWidth: number = this.mPageDesktopStyleConfig.mGridWidth;
    const gridHeight: number = this.mPageDesktopStyleConfig.mGridHeight;
    const column: number = this.mGridConfig.column;
    const row: number = this.mGridConfig.row;
    const columnsGap: number = this.mPageDesktopStyleConfig.mColumnsGap;
    const rowGap: number = this.mPageDesktopStyleConfig.mRowsGap;
    const gridItemHeight: number = row > 0 ? (gridHeight + rowGap) / row : 0;
    const gridItemWidth: number = column > 0 ? (gridWidth + columnsGap) / column : 0;
    const paddingTop: number = this.mPageDesktopStyleConfig.mPaddingTop;
    let appItem: GridLayoutItemInfo | undefined = this.getCloseAppItemInfo();
    if (!appItem) {
      log.showError('calculateAppIconPosition pagedesktop not has close app');
      this.mFindPagedesktopPosition = false;
      return;
    }
    if (this.mCloseAppType) {
      this.mAppIconPositionY =
        this.mPageDesktopStyleConfig.mDesktopMarginTop + paddingTop + (appItem.row ?? 0) * gridItemHeight - 1.5;
      let columnSize: number = (this.mPageDesktopStyleConfig.mGridWidth - (column - 1) * columnsGap) / column;
      let iconLeftMargin: number = (columnSize - this.mPageDesktopStyleConfig.mIconSize) / 2;
      this.mAppIconPositionX = this.mPageDesktopStyleConfig.mMargin + iconLeftMargin + (appItem.column ?? 0) *
        (gridItemWidth);

      if (CommonConstants.OVERLAY_TYPE_CARD !== AppStorage.get('startAppTypeFromPageDesktop') &&
        appItem.page !== desktopUtil.getPageIndexValue()) {
        AppStorage.setOrCreate(desktopUtil.getPageIndex(), appItem.page);
      }
    } else {
      let folderItem: GridLayoutItemInfo | undefined = this.mFolderItem;
      if (!folderItem || !folderItem.area || folderItem.row === undefined || folderItem.column === undefined) {
        log.showWarn('folderItem info is empty');
        this.mFindPagedesktopPosition = false;
        return;
      }
      const folderGridSize: number = this.mFolderStyleConfig.mGridSize;
      const folderGridGap: number = this.mFolderStyleConfig.mFolderGridGap;
      const folderAppSize: number = this.mFolderStyleConfig.mFolderAppSize;
      let folderLeftMargin: number = (gridItemWidth * folderItem.area[0] - folderGridSize - columnsGap) / 2;
      let folderRow: number = Math.floor((folderGridSize) / (folderGridGap + folderAppSize));
      let folderColumn: number = folderRow;
      let folderLeftPadding: number =
        (folderGridSize - folderColumn * (folderGridGap + folderAppSize) + folderGridGap) / 2;
      let folderTopPadding: number = (folderGridSize - folderRow * (folderGridGap + folderAppSize) + folderGridGap) / 2;

      let index: number = this.getIndexInFolderAppList(appItem, folderItem);
      if (index >= folderRow * folderColumn) {
        index = 9;
      }
      let row: number = Math.floor(index / folderColumn);
      let column: number = index % folderColumn;
      if (column !== 0) {
        row += 1;
      } else {
        column = folderColumn;
      }
      log.showDebug(`calculateAppIconPosition index ${index} row ${row} column ${column}`);
      this.mAppIconPositionY = this.mPageDesktopStyleConfig.mDesktopMarginTop + folderItem.row * (gridItemHeight) +
        paddingTop + this.mPageDesktopStyleConfig.mIconMarginVertical + folderTopPadding +
        (row - 1) * (folderGridGap + folderAppSize);

      this.mAppIconPositionX = this.mPageDesktopStyleConfig.mMargin + folderItem.column * (gridItemWidth) +
        folderLeftMargin + folderLeftPadding + (column - 1) * (folderGridGap + folderAppSize);

      if (folderItem.page !== desktopUtil.getPageIndexValue()) {
        AppStorage.setOrCreate(desktopUtil.getPageIndex(), folderItem.page);
      }
    }
    this.mFindPagedesktopPosition = true;
  }

  private getIndexInFolderAppList(appItem: GridLayoutItemInfo, folderItem: GridLayoutItemInfo): number {
    let index: number = 0;
    if (CheckEmptyUtils.isEmpty(appItem) || CheckEmptyUtils.isEmpty(folderItem) ||
      !folderItem.layoutInfo || CheckEmptyUtils.isEmpty(folderItem.layoutInfo[0])) {
      log.showError('getIndexInFolderAppList with invalid appItem or folderItem');
      return index;
    }
    for (let i = 0; i < folderItem.layoutInfo[0].length; i++) {
      if (folderItem.layoutInfo[0][i]?.bundleName === appItem.bundleName) {
        index = i;
        break;
      }
    }

    return index + 1;
  }

  private getCloseAppItemInfo(): GridLayoutItemInfo | undefined {
    log.showDebug('getCloseAppItemInfo called!');
    let appListInfo: AppListInfo | undefined = AppStorage.get('appListInfo');
    let appGridInfo = appListInfo?.appGridInfo;
    if (!appGridInfo || CheckEmptyUtils.isEmptyArr(appGridInfo)) {
      log.showError('getCloseAppItemInfo appGridInfo is null');
      return undefined;
    } else {
      for (let i = 0; i < appGridInfo.length; i++) {
        let swipeGridInfo: GridLayoutItemInfo[] = appGridInfo[i];
        if (!CheckEmptyUtils.isEmptyArr(swipeGridInfo)) {
          for (let j = 0; j < swipeGridInfo.length; j++) {
            let item = swipeGridInfo[j];
            switch (item.typeId) {
              case CommonConstants.TYPE_APP:
                if (this.mAppItemBundleName === item.bundleName) {
                  this.mCloseAppType = true;
                  return item;
                }
                break;
              case CommonConstants.TYPE_FOLDER:
                log.showDebug(`getCloseAppItemInfo foldItem case ${item.layoutInfo}`);
                let foldItem = this.getFolderItem(item.layoutInfo ?? []);
                if (!foldItem) {
                  log.showError('getCloseAppItemInfo foldItem is null');
                  break;
                } else {
                  this.mCloseAppType = false;
                  this.mFolderItem = item;
                  return foldItem;
                }
              default:
                break;
            }
          }
        }
      }
      return undefined;
    }
  }

  private getFolderItem(layoutInfo: GridLayoutItemInfo[][]): GridLayoutItemInfo | null {
    if (CheckEmptyUtils.isEmptyArr(layoutInfo)) {
      log.showError('getFolderItem layoutInfo is null');
      return null;
    } else {
      let foldPage: GridLayoutItemInfo[] = layoutInfo[0];
      if (!CheckEmptyUtils.isEmptyArr(foldPage)) {
        for (let j = 0; j < foldPage.length; j++) {
          let appItem: GridLayoutItemInfo = foldPage[j];
          log.showDebug(`getFolderItem appItem is ${JSON.stringify(appItem)}`);
          if (!CheckEmptyUtils.isEmpty(appItem) && this.mAppItemBundleName === appItem.bundleName) {
            log.showDebug(`getFolderItem return item is ${JSON.stringify(appItem)}`);
            return appItem;
          }
        }
      }
      return null;
    }
  }
}
