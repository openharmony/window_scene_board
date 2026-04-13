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
  StyleConstants,
  BaseCloseAppHandler,
  CommonConstants,
  CloseAppManager,
  GridLayoutConfig,
  BigFolderStyleConfig,
  GridLayoutItemInfo,
  AppItemInfo,
  ClosePosition,
  AppListInfo,
} from '@ohos/launchercommon';
import {
  StartType,
  LogDomain,
  LogHelper,
  CheckEmptyUtils,
  SingleContext,
  singleManager
} from '@ohos/basicutils';
import { desktopUtil } from '@ohos/componenthelper';
import { BigFolderViewModel } from '@ohos/bigfolder/src/main/ets/default/viewmodel/BigFolderViewModel';
import { PageDesktopViewModel } from './viewmodel/PageDesktopViewModel';
import FeatureConstants from './constants/FeatureConstants';
import { PageDesktopGridStyleConfig } from '@ohos/launchercommon/src/main/ets/layoutconfig/PageDesktopGridStyleConfig';
import { FormViewModel } from '@ohos/form/src/main/ets/default/viewmodel/FormViewModel';
import { FormStyleConfig } from '@ohos/form/src/main/ets/default/common/FormStyleConfig';
import { FolderStyleManager } from '@ohos/launchercommon/src/main/ets/folder/next/common/FolderStyleManager';

const TAG = 'PageDesktopCloseAppHandler';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Desktop workspace start app processing class
 */
export class PageDesktopCloseAppHandler extends BaseCloseAppHandler {
  public static singleName: string = 'PageDesktopCloseAppHandler';
  private mGridConfig: GridLayoutConfig;
  private mPageDesktopStyleConfig: PageDesktopGridStyleConfig;
  private mFolderStyleConfig: BigFolderStyleConfig;
  private mAppItemBundleName: string = '';
  private mAppItemAbilityName: string = '';
  private mFindPagedesktopPosition: boolean = true;
  private mFolderItem: GridLayoutItemInfo | undefined;
  private appItem: GridLayoutItemInfo | undefined;
  private mIconId: string = '';

  constructor(ctx?: SingleContext) {
    super(ctx);
    this.mGridConfig = PageDesktopViewModel.getInstance(ctx).getGridConfig();
    this.mPageDesktopStyleConfig = PageDesktopViewModel.getInstance(ctx).getPageDesktopStyleConfig();
    this.mFolderStyleConfig = FolderStyleManager.getInstance().getFolderStyleConfig();
  }

  static getInstance(ctx?: SingleContext): PageDesktopCloseAppHandler {
    return singleManager.get<PageDesktopCloseAppHandler>(PageDesktopCloseAppHandler, ctx);
  }

  /**
   * get app icon info
   *
   * @param windowTarget close window target
   */
  public getAppIconInfo(windowTarget: AppItemInfo): void {
    this.mAppItemBundleName = windowTarget.bundleName;
    this.getAppIconInfoByName(this.mAppItemBundleName);
  }

  public getAppIconInfoByName(bundleName: string, abilityName?: string, iconId?: number): void {
    this.mAppItemBundleName = bundleName;
    this.mAppItemAbilityName = abilityName ?? '';
    this.mIconId = String(iconId);
    log.showDebug(`getAppIconInfoByBundleName: ${bundleName} mIconId: ${iconId}`);

    this.calculateAppIconPosition();
    if (this.mFindPagedesktopPosition) {
      let styleConfig = PageDesktopViewModel.getInstance(this.singleContext).getPageDesktopStyleConfig();
      const mFormStyleConfig: FormStyleConfig = FormViewModel.getInstance(this.singleContext).getFormStyleConfig();
      switch (this.mStartAppType) {
        case StartType.APP:
          this.mAppIconSize = styleConfig.mIconSize;
          this.mAppIconHeight = styleConfig.mIconSize;
          break;
        case StartType.CARD:
          this.mAppIconSize = mFormStyleConfig.mFormWidth.get(this.appItem?.cardDimension?.toString() ?? '') ?? 0;
          this.mAppIconHeight = mFormStyleConfig.mFormHeight.get(this.appItem?.cardDimension?.toString() ?? '') ?? 0;
          break;
        case StartType.FOLDER:
          this.mAppIconSize = this.mFolderStyleConfig.mFolderAppSize;
          this.mAppIconHeight = this.mFolderStyleConfig.mFolderAppSize;
          break;
        case StartType.RECENT_DOCK_APP:
        case StartType.AI_SUGGESTION_APP:
        default:
          break;
      }
      let appCloseIconInfo: ClosePosition = {
        appIconSize: this.mAppIconSize,
        appIconHeight: this.mAppIconHeight,
        appIconPositionX: this.mAppIconPositionX,
        appIconPositionY: this.mAppIconPositionY
      };
      log.showDebug('closeAppItemInfo: bundleName: %{public}s, abilityName: %{public}s, row: %{public}d, column: %{public}d',
        this.appItem?.bundleName, this.appItem?.abilityName, this.appItem?.row, this.appItem?.column);
      log.showDebug('closeAppIcon InfoappIconSize: %{public}d, appIconHeight: %{public}d, appIconPositionX: %{public}d, appIconPositionY: %{public}d',
        appCloseIconInfo.appIconSize, appCloseIconInfo.appIconHeight, appCloseIconInfo.appIconPositionX,
        appCloseIconInfo.appIconPositionY);
      CloseAppManager.getInstance().addPagedesktopClosePosition(appCloseIconInfo, this.appItem as AppItemInfo);
    } else {
      CloseAppManager.getInstance().addPagedesktopClosePosition(null);
    }
  }

  protected calculateAppIconPosition(): void {
    if (CheckEmptyUtils.isEmpty(this.mGridConfig) || CheckEmptyUtils.isEmpty(this.mPageDesktopStyleConfig)) {
      log.showError('calculateAppIconPosition with invalid config');
      return;
    }
    const column: number = this.mGridConfig.column;
    const row: number = this.mGridConfig.row;
    const gridWidth: number = this.mPageDesktopStyleConfig.mGridWidth;
    const gridHeight: number = this.mPageDesktopStyleConfig.mGridHeight;
    const columnsGap: number = this.mPageDesktopStyleConfig.mColumnsGap;
    const rowGap: number = this.mPageDesktopStyleConfig.mRowsGap;
    const gridItemHeight: number = row > 0 ? (gridHeight + rowGap) / row : 0;
    const gridItemWidth: number = column > 0 ? (gridWidth + columnsGap) / column : 0;
    const paddingTop: number = this.mPageDesktopStyleConfig.mPaddingTop;
    this.appItem = this.getCloseAppItemInfo();
    if (!this.appItem) {
      log.showError('calculateAppIconPosition pagedesktop not has close app');
      this.mFindPagedesktopPosition = false;
      return;
    }
    if (this.mStartAppType === StartType.APP || this.mStartAppType === StartType.CARD) {
      this.mAppIconPositionY = this.mPageDesktopStyleConfig.mDesktopMarginTop + paddingTop +
        (this.appItem.row ?? 0) * gridItemHeight - FeatureConstants.CALCULATE_ONE_POINT_FIVE;
      let columnSize: number = (this.mPageDesktopStyleConfig.mGridWidth - (column - 1) * columnsGap) / column;
      let iconLeftMargin: number = (columnSize - this.mPageDesktopStyleConfig.mIconSize) /
        FeatureConstants.CALCULATE_TWO;
      this.mAppIconPositionX = this.mPageDesktopStyleConfig.mMargin + iconLeftMargin +
        (this.appItem.column ?? 0) * (gridItemWidth);
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
      let folderLeftMargin: number =
        (gridItemWidth * folderItem.area[0] - folderGridSize - columnsGap) / FeatureConstants.CALCULATE_TWO;
      let folderRow: number = Math.floor((folderGridSize) / (folderGridGap + folderAppSize));
      let folderColumn: number = folderRow;
      let folderLeftPadding: number = (folderGridSize - folderColumn * (folderGridGap + folderAppSize) +
        folderGridGap) / FeatureConstants.CALCULATE_TWO;
      let folderTopPadding: number =
        (folderGridSize - folderRow * (folderGridGap + folderAppSize) + folderGridGap) / FeatureConstants.CALCULATE_TWO;

      let index: number = this.getIndexInFolderAppList(this.appItem, folderItem);
      if (index >= folderRow * folderColumn) {
        index = FeatureConstants.INDEX_NINE;
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
        (row - 1) * (folderGridGap + folderAppSize) - FeatureConstants.CALCULATE_ONE_POINT_FIVE;

      this.mAppIconPositionX = this.mPageDesktopStyleConfig.mMargin + folderItem.column * (gridItemWidth) +
        folderLeftMargin + folderLeftPadding + (column - 1) * (folderGridGap + folderAppSize);
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
    let layoutInfo: GridLayoutItemInfo[][] | undefined = folderItem.layoutInfo;
    if (!layoutInfo) {
      return index;
    }
    for (let i = 0; i < layoutInfo.length; i++) {
      for (let j = 0; j < layoutInfo[i].length; j++) {
        index++;
        let item: GridLayoutItemInfo = layoutInfo[i][j];
        if (item.bundleName === appItem.bundleName) {
          return index;
        }
      }
    }
    return index;
  }

  private getCloseAppItemInfo(): GridLayoutItemInfo | undefined {
    log.showDebug('getCloseAppItemInfo called!');
    let appListInfo: AppListInfo = AppStorage.get(desktopUtil.getAppListInfo()) as AppListInfo;
    let appGridInfo = appListInfo.appGridInfo;
    if (CheckEmptyUtils.isEmptyArr(appGridInfo)) {
      log.showError('getCloseAppItemInfo appGridInfo is null');
      return undefined;
    }
    for (let i = 0; i < appGridInfo.length; i++) {
      let swipeGridInfo: GridLayoutItemInfo[] = appGridInfo[i];
      if (!CheckEmptyUtils.isEmptyArr(swipeGridInfo)) {
        for (let j = 0; j < swipeGridInfo.length; j++) {
          let item: GridLayoutItemInfo = swipeGridInfo[j];
          log.showDebug('item:' + JSON.stringify(item));
          log.showDebug('item:startAppType:' + this.mStartAppType + 'mAppItemBundleName:' + this.mAppItemBundleName);
          switch (item.typeId) {
            case CommonConstants.TYPE_APP:
              if (this.isMatchApp(item.bundleName, item.abilityName) && (this.mStartAppType === StartType.APP)) {
                return item;
              }
              break;
            case CommonConstants.TYPE_CARD:
              // 逻辑待完善，相同的两张卡片退出时，windowTarget返回的值，完全不能区分出来，
              if (this.isMatchApp(item.bundleName, item.abilityName) && this.mStartAppType === StartType.CARD &&
              this.isMatchIconId(item.cardId ?? '')) {
                return item;
              } else if (this.mStartAppType === StartType.AI_SUGGESTION_APP) {
                return undefined;
              }
              break;
            case CommonConstants.TYPE_FOLDER:
              if (this.mStartAppType === StartType.FOLDER) {
                log.showDebug(`getCloseAppItemInfo foldItem case ${item.layoutInfo}`);
                let foldItem = this.getFolderItem(item.layoutInfo ?? []);
                if (!foldItem) {
                  log.showError('getCloseAppItemInfo foldItem is null');
                  break;
                } else {
                  this.mFolderItem = item;
                  foldItem.page = item.page;
                  return foldItem;
                }
              }
            default:
              break;
          }
        }
      }
    }
    return undefined;
  }

  private isMatchApp(bundleName: string, abilityName: string): boolean {
    return this.mAppItemBundleName === bundleName &&
      (!this.mAppItemAbilityName || this.mAppItemAbilityName === abilityName);
  }

  private isMatchIconId(cardId: string): boolean {
    return this.mIconId === cardId;
  }

  private getFolderItem( layoutInfo: GridLayoutItemInfo[][]): GridLayoutItemInfo | null {
    if (CheckEmptyUtils.isEmptyArr(layoutInfo)) {
      log.showError('getFolderItem layoutInfo is null');
      return null;
    }
    for (let i = 0; i < layoutInfo.length; i++) {
      for (let j = 0; j < layoutInfo[i].length; j++) {
        let appItem: GridLayoutItemInfo = layoutInfo[i][j];
        if (this.isMatchApp(appItem.bundleName, appItem.abilityName)) {
          log.showDebug(`getFolderItem return item is ${JSON.stringify(appItem)}`);
          return appItem;
        }
      }
    }
    return null;
  }

}
