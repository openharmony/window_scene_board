/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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

import { EventConstants } from '../../constants/EventConstants';
import {
  CheckEmptyUtils,
  StartType,
  LogDomain,
  LogHelper,
  RectItem,
  ObjUtil,
  CompanionIconInfo,
  RectInfo,
  SingleBase,
  SingleContext,
  singleManager,
} from '@ohos/basicutils';
import {
  GlobalContext,
  sOutSideWindowMgr,
  DeviceHelper,
  localEventManager,
  ResourceManager,
} from '@ohos/frameworkwrapper';
import { } from '@ohos/componentanimator';
import { ItemUtils, desktopUtil, } from '@ohos/componenthelper';
import { SCBConstants, } from '@ohos/commonconstants';
import { SCBTransitionManager, SCBSceneSessionManager, launcherStatusUtil, } from '@ohos/windowscene';
import { GridOccupyStatusEnum, GridOccupyStatus, } from '@ohos/componentdrag';
import type { AppData, SCBTransitionController, AppInFolderInfo } from '@ohos/windowscene';
import { BusinessType, CommonConstants } from '../../constants/CommonConstants';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import type { DockItemInfo } from '../../bean/DockItemInfo';
import type { RecentBundleMissionInfo } from '../../bean/RecentBundleMissionInfo';
import { AppItemInfo } from '../../bean/AppItemInfo';
import type { AppExitLocationInfo, SCBSceneContainerSession } from '@ohos/windowscene';
import { StyleConstants } from '../../constants/StyleConstants';
import GridLayoutUtil from '../../utils/GridLayoutUtil';
import type DefaultDesktopLayoutInfo from '../../configs/DefaultDesktopLayoutInfo';
import { AppModel } from '../../model/AppModel';
import { CloseAppManager, StartSubtype } from '../../manager/CloseAppManager';
import { PageDesktopGridStyleConfig } from '../../layoutconfig/PageDesktopGridStyleConfig';
import { layoutConfigManager } from '../../layoutconfig/LayoutConfigManager';
import {
  LaunchLayoutCacheManager,
  LayoutDescription,
  DesktopModeManager,
  LauncherLayoutCacheUtil,
  DeliverUtil,
  FormLayoutCacheManager,
  ResidentLayoutCacheMgr,
  RecentLayoutCacheMgr,
  FolderManager,
  PageInfoManager,
  ReceiveEventInfo,
  AppListInfo
} from '../../TsIndex';

const TAG = 'PageDesktopModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export interface  AppTransitionInfo {
  appInFolderInfo: AppInFolderInfo | null;
  app?: GridLayoutItemInfo;
}

export type FindAppInPageMethod = (eleInCurrentPage: GridLayoutItemInfo[], companionIconInfo: CompanionIconInfo) => AppTransitionInfo;

/**
 * PageDesktop Model
 */

export class PageDesktopModel extends SingleBase {
  public static singleName: string = 'PageDesktopModel';
  public mOuterFormStackExitScale: number = 1;
  private mPageDesktopStyleConfig: PageDesktopGridStyleConfig;

  constructor(ctx?: SingleContext) {
    super(ctx);
    this.mPageDesktopStyleConfig = layoutConfigManager.getStyleConfig(PageDesktopGridStyleConfig.APP_GRID_STYLE_CONFIG,
      CommonConstants.PAGE_DESKTOP_FEATURE_NAME) as PageDesktopGridStyleConfig;
    if (this.mPageDesktopStyleConfig == null) {
      // 添加时序异常的调用堆栈打印,用于问题时序排查,后续删除
      let stack: string = new Error('StyleConfig_empty').stack;
      log.showError('StyleConfig_empty: %{public}s', stack);
    }
  }

  /**
  * Obtains the pageDesktop data model object.
  *
  * @return PageDesktopModel
   */
  static getInstance(ctx?: SingleContext): PageDesktopModel {
    return singleManager.get<PageDesktopModel>(PageDesktopModel, ctx);
  }

  setOuterFormStackExitScale(scale: number): void {
    this.mOuterFormStackExitScale = scale;
  }

  /**
  * Register for the PageDesktop application list add event.
  *
  * @param listener
   */
  registerPageDesktopItemAddEvent(listener: ReceiveEventInfo): void {
    localEventManager.registerEventListener(listener, [
      EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_ADD,
      EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_DELETE,
      EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_DELETE_BATCH,
      EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_UPDATE,
      EventConstants.EVENT_REQUEST_PAGEDESK_FORM_ITEM_ADD,
      EventConstants.EVENT_REQUEST_PAGEDESK_FORM_ITEM_DELETE,
      EventConstants.EVENT_REQUEST_PAGEDESK_FORM_ITEM_DELETE_BY_INTELLIGENT,
      EventConstants.EVENT_REQUEST_DELETE_DEFAULT_CARD,
      EventConstants.EVENT_SMARTDOCK_INIT_FINISHED,
      EventConstants.EVENT_REQUEST_PAGEDESK_LIGHT_REFRESH,
      EventConstants.EVENT_REQUEST_PAGEDESK_RELOAD_REFRESH,
      EventConstants.EVENT_REQUEST_OUTER_PAGEDESK_LIGHT_REFRESH,
      EventConstants.EVENT_REQUEST_FORM_ITEM_VISIBLE,
      EventConstants.EVENT_REQUEST_DESKTOP_ITEM_UNSELECT,
      EventConstants.EVENT_PACKAGE_CHANGED,
      EventConstants.EVENT_REQUEST_APPGALLERY_CREATED,
      EventConstants.EVENT_LAYOUT_INIT_FINISHED,
      EventConstants.EVENT_REQUEST_DESKTOP_FOCUS_CHANGE,
      EventConstants.EVENT_REQUEST_PAGEDESK_FILE_REFRESH,
      EventConstants.EVENT_REQUEST_PAGEDESK_FILE_ITEM_ICON_REFRESH,
      EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_SELECTED,
      EventConstants.EVENT_INTELLIGENT_SIGN_STATUS,
      EventConstants.EVENT_REQUEST_PAGEDESK_ADD_TO_FOLDER,
      EventConstants.EVENT_REQUEST_FORM_RECYCLE,
      EventConstants.EVENT_REQUEST_SINGLE_DISPLAY_SWITCH_REFRESH,
      EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_SORT,
      EventConstants.EVENT_DESKTOP_TRIM,
      EventConstants.EVENT_DESKTOP_CANT_ADD,
      EventConstants.EVENT_REQUEST_APPGALLERY_FINISH,
      EventConstants.EVENT_DELIVER_APP_ITEM_REMOVE,
      EventConstants.EVENT_REQUEST_INNER_PAGEDESK_LIGHT_REFRESH,
      EventConstants.EVENT_DESKTOP_PASTE,
      EventConstants.EVENT_ADD_APP_WHEN_EXCEED_MAX_PAGE,
      EventConstants.APP_INSTALL_BMS_CHANGE_EVENT,
      EventConstants.EVENT_RESET_ALL_SELECT_STATUS,
      EventConstants.EVENT_CLEAR_SELECT_ITEMS,
      EventConstants.EVENT_REQUEST_SHORTCUT_ITEM_DELETE,
      EventConstants.EVENT_REQUEST_APP_DOUBLE_CLICK,
      EventConstants.EVENT_REQUEST_FALL_BOX_HIDE,
      EventConstants.EVENT_OPEN_APPLICATION,
      EventConstants.EVENT_UNINSTALL_APPLICATION,
      EventConstants.EVENT_BATCH_UPDATE_ITEM_POSITION,
      EventConstants.EVENT_SHOW_NEXT_PATE,
      EventConstants.EVENT_ADD_MIDDLE_PAGE,
      EventConstants.EVENT_DELETE_NOT_UNINSTALL_APP,
      EventConstants.EVENT_DELETE_APP_AUTO_ALIGN,
      EventConstants.EVENT_ANNOUNCED_SWIPER_PAGE,
      EventConstants.EVENT_AUTO_ALIGN_AFTER_UNINSTALL,
      EventConstants.EVENT_UPDATE_GIRD_ITEM_POOL_STATUS
    ]);
  }

  /**
  * register badge update event.
  *
  * @param listener
   */
  registerPageDesktopBadgeUpdateEvent(listener: ReceiveEventInfo): void {
    localEventManager.registerEventListener(listener, [
      EventConstants.EVENT_BADGE_UPDATE
    ]);
  }

  /**
  * Unregister application list change listener.
  *
  * @param listener
   */
  unregisterEventListener(listener: ReceiveEventInfo): void {
    localEventManager.unregisterEventListener(listener);
  }

  sendDockItemChangeEvent(appInfo: AppItemInfo): void {
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_REQUEST_DOCK_ITEM_ADD, appInfo);
  }

  /**
   * 获取桌面布局参数配置
   *
   * @returns PageDesktopGridStyleConfig
   */
  public getPageDesktopStyleConfig(): PageDesktopGridStyleConfig {
    return this.mPageDesktopStyleConfig;
  }

  /**
   * 获取相邻页 折叠屏用
   * @param page
   * @returns
   */
  public getNeighborPage(page: number): number {
    if (page % StyleConstants.DEFAULT_2 === 0) {
      return page + StyleConstants.DEFAULT_1;
    } else {
      return page - StyleConstants.DEFAULT_1;
    }
  }

  /**
   * delete blank page from layoutInfo
   *
   * @param layoutInfo
   * @param page
   */
  deleteBlankPageFromLayoutInfo(page, isOuter?: boolean): boolean {
    if (isNaN(page)) {
      log.showError(`invalid page value. page:${page}`);
      return false;
    }
    if (PageInfoManager.getInstance().isHomePage(page)) {
      log.showInfo(`deleteBlankPageFromLayoutInfo, page ${page} is home page`);
      return false;
    }
    if (DeviceHelper.isSuperFoldMachine()) {
      return false;
    }
    let launcherLayoutCache: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
    let pageCount: number = launcherLayoutCache.selectPageCount(isOuter);
    log.showInfo(`deleteBlankPageFromLayoutInfo, page:${page}, pageCount:${pageCount}`);
    if (page === CommonConstants.WATERFALL_PAGE_INDEX || pageCount <= page || page < 0) {
      return false;
    }

    if (!launcherLayoutCache.isBlankPage(page, isOuter)) {
      log.showInfo(`deleteBlankPage fail page: ${page}, nowPage has items`);
      return false;
    }

    let adaptivePage: number = PageInfoManager.getInstance().getDisplayCount();
    if (adaptivePage === StyleConstants.DEFAULT_3) {
      return LaunchLayoutCacheManager.getInstance().deleteBlankPages(page, adaptivePage);
    }
    let pageDeleteCount: number = StyleConstants.DEFAULT_1;
    let pageAdjust: number = page;

    if (desktopUtil.isFoldExpandStatus() && !isOuter) {
      let neighborPage: number = this.getNeighborPage(page);
      if (!launcherLayoutCache.isBlankPage(neighborPage)) {
        log.showInfo(`deleteBlankPage fail neighborPage: ${neighborPage}, neighborPage has items`);
        return false;
      }
      if (neighborPage < pageCount) {
        // 删除中间页或者pageCount总页数为偶数时，删两页
        // pageCount为奇数时展开手机，删除最后一页，pageDeleteCount只能为1。
        pageDeleteCount = StyleConstants.DEFAULT_2;
      }
      // 用于删除空白页，折叠屏展开态的空白页从左侧较小的页码开始计数
      pageAdjust = page < neighborPage ? page : neighborPage;
    }

    // 清空桌面上的元素，桌面仍会保留一张空白页
    if (pageCount > pageDeleteCount) {
      launcherLayoutCache.updatePageCount(pageCount - pageDeleteCount, BusinessType.BUSINESS_BASIC_DESKTOP, true, isOuter);
    } else {
      log.showInfo(`deleteBlankPage fail, pageCount:${pageCount}, pageDeleteCount:${pageDeleteCount}`);
      return false;
    }
    log.showInfo(`deleteBlankPage success, page:${page}`);
    launcherLayoutCache.updateLayoutAfterDeletePage(pageAdjust, pageDeleteCount, BusinessType.BUSINESS_BASIC_DESKTOP, true, isOuter);
    return true;
  }

  updateAppItemLayoutInfo(info: DefaultDesktopLayoutInfo, item: GridLayoutItemInfo): void {
    const pageCount = info.layoutDescription.pageCount;
    const row = info.layoutDescription.row;
    const column = info.layoutDescription.column;
    const layoutInfo = info.layoutInfo;
    // current page has space
    let isNeedNewPage = true;
    pageCycle: for (let i = 0; i < pageCount; i++) {
      for (let y = 0; y < row; y++) {
        for (let x = 0; x < column; x++) {
          if (this.isPositionValid(info, item, i, x, y)) {
            log.showDebug(`updateAppItemLayoutInfo isPositionValid: x:${x} y:${y} page:${i}`);
            isNeedNewPage = false;
            let tmpItem = new GridLayoutItemInfo();
            tmpItem.bundleName = item.bundleName;
            tmpItem.typeId = item.typeId;
            tmpItem.abilityName = item.abilityName;
            tmpItem.moduleName = item.moduleName;
            tmpItem.keyName = item.keyName;
            tmpItem.badgeNumber = item.badgeNumber;
            tmpItem.area = item.area;
            tmpItem.page = i;
            tmpItem.column = x;
            tmpItem.row = y
            layoutInfo.push(tmpItem);
            break pageCycle;
          }
        }
      }
    }
    if (isNeedNewPage) {
      let tmpItem = new GridLayoutItemInfo();
      tmpItem.bundleName = item.bundleName;
      tmpItem.typeId = item.typeId;
      tmpItem.abilityName = item.abilityName;
      tmpItem.moduleName = item.moduleName;
      tmpItem.keyName = item.keyName;
      tmpItem.badgeNumber = item.badgeNumber;
      tmpItem.area = item.area;
      tmpItem.page = pageCount;
      tmpItem.column = 0;
      tmpItem.row = 0;
      layoutInfo.push(tmpItem);
      ++info.layoutDescription.pageCount;
    }
  }

  updatePageDesktopLayoutInfo(item: GridLayoutItemInfo, findAreaCount?: number): boolean {
    let pageCount: number = LaunchLayoutCacheManager.getInstance().selectPageCount();
    if (findAreaCount !== undefined) {
      pageCount = Math.min(findAreaCount, pageCount);
    }
    const curPageIndex = this.getPageIndex();
    let isNeedNewPage: boolean = !this.findBlankPosition(curPageIndex, pageCount, item);
    if (isNeedNewPage) {
      item.page = curPageIndex + 1;
      item.column = 0;
      item.row = 0;
    }
    return isNeedNewPage;
  }

  /**
   * 找空位，并更新应用的位置信息
   *
   * @param startPage 找位起始页
   * @param endPage 找位结束页
   * @param item 应用信息
   * @returns true：找到空位
   */
  public findBlankPosition(startPage: number, endPage: number, item: GridLayoutItemInfo, isOuter?: boolean): boolean {
    let launcherLayout: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
    let layoutDescription: LayoutDescription = launcherLayout.selectLayoutDescription(isOuter);
    let first: number = layoutDescription.row;
    let second: number = layoutDescription.column;
    if (this.getIsPad()) {
      first = layoutDescription.column;
      second = layoutDescription.row;
    }
    for (let i = startPage; i < endPage; i++) {
      for (let y = 0; y < first; y++) {
        for (let x = 0; x < second; x++) {
          let positionX = this.getIsPad() ? y : x;
          let positionY = this.getIsPad() ? x : y;
          let isFindPosition: boolean = this.findBlankPositionInDetail(i, positionX, positionY, item, isOuter);
          if (isFindPosition) {
            log.showInfo(`updatePageDesktopLayoutInfo isPositionValid: positionX:${positionX} positionY:${positionY} page:${i}`);
            item.page = i;
            item.column = positionX;
            item.row = positionY;
            return true;
          }
        }
      }
    }
    return false;
  }

  private findBlankPositionInDetail(pageIndex: number, positionX: number, positionY: number,
    item: GridLayoutItemInfo, isOuter?: boolean): boolean {
    let isFindBlankPosition: boolean = LaunchLayoutCacheManager.getInstance().isPositionValid(item, pageIndex, positionX, positionY, isOuter);
    if (isFindBlankPosition && DeviceHelper.isPad()) {
      // 如果是pad 旋转之后是否能放得下
      let gridLayoutInfo: DefaultDesktopLayoutInfo = LaunchLayoutCacheManager.getInstance().getDesktopLayoutInfo('findPosition');
      let isAddableDefault: boolean = LauncherLayoutCacheUtil.isAddableForRotate(gridLayoutInfo, pageIndex,
        item.area?.[0] ?? 0, item.area?.[1] ?? 0);
      if (LauncherLayoutCacheUtil.getIsFirstRotate() || !isAddableDefault) {
        isFindBlankPosition = isAddableDefault;
      } else {
        isFindBlankPosition = LauncherLayoutCacheUtil.checkIfElementsIsAddable(gridLayoutInfo.layoutInfo, pageIndex, item);
        if (!isFindBlankPosition) {
          isFindBlankPosition = LauncherLayoutCacheUtil.forceRotatePage(gridLayoutInfo.layoutInfo, pageIndex, item);
        }
      }
      log.showInfo(`pad isFindBlankPosition:${isFindBlankPosition}`);
    }
    return isFindBlankPosition;
  }

  public updatePageDesktopLayoutInfoForFolder(itemArr: GridLayoutItemInfo[]): void {
    let launcherLayout: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
    let layoutDescription: LayoutDescription = launcherLayout.selectLayoutDescription();
    const pageCount: number = launcherLayout.selectPageCount();
    let curPageIndex = this.getPageIndex();
    let gridOccupyStatusEnum = launcherLayout.selectGridOccupyStatusForPage(curPageIndex);
    let isNextPage: boolean = false;
    let deviceMaxPage: number = layoutDescription.maxPage;
    for (let k = 0; k < itemArr.length; k++) {
      let isNeedNewPage = true;
      curPageIndex = this.getPageIndex();
      let max = pageCount - 1 < curPageIndex ? curPageIndex : pageCount - 1;
      let i = curPageIndex;
      pageCycle: for (; i <= max; i++) {
        if (isNextPage) {
          gridOccupyStatusEnum = launcherLayout.selectGridOccupyStatusForPage(i);
          isNextPage = false;
          this.setPageIndex(i);
        }
        let isFindLocation: boolean = this.findElementLocationInPage(gridOccupyStatusEnum, itemArr[k], i);
        if (isFindLocation) {
          isNeedNewPage = false;
          isNextPage = false;
          break pageCycle;
        } else {
          isNextPage = true;
        }
      }
      while (isNeedNewPage && i < deviceMaxPage) {
        log.showInfo(`updatePageDesktopLayoutInfoForFolder isNeedNewPage
          of page ${JSON.stringify(i)} and maxPage ${JSON.stringify(deviceMaxPage)}`);
        this.setPageIndex(i);
        gridOccupyStatusEnum = launcherLayout.selectGridOccupyStatusForPage(i);
        isNeedNewPage = !this.findElementLocationInPage(gridOccupyStatusEnum, itemArr[k], i);
        if (isNeedNewPage) {
          log.showError('No free space in the new Page');
          i++;
        } else {
          isNextPage = false;
        }
      }
    }
  }

  private findElementLocationInPage(gridOccupyStatusEnum: GridOccupyStatusEnum[][], item: GridLayoutItemInfo,
    curPage: number): boolean {
    for (let m = 0; m < gridOccupyStatusEnum.length; m++) {
      for (let n = 0; n < gridOccupyStatusEnum[0].length; n++) {
        if (gridOccupyStatusEnum[m][n] === 'F') {
          log.showInfo(`updatePageDesktopLayoutInfoForFolder grid[${m}][${n}] is free`);
          item.page = curPage;
          item.row = m;
          item.column = n;
          gridOccupyStatusEnum[m][n] = GridOccupyStatusEnum.OCCUPIED;
          return true;
        }
      }
    }
    return false;
  }

  public getGridOccupyStatusEnum(layoutInfo: GridLayoutItemInfo[], row: number, column: number,
    pageIndex: number): GridOccupyStatusEnum[][] {
    let gridOccupyStatus: GridOccupyStatus = new GridOccupyStatus(row, column, GridOccupyStatusEnum.FREE);

    for (let j = 0; j < layoutInfo.length; ++j) {
      if (layoutInfo[j].page === pageIndex) {
        let mRow = layoutInfo[j].row;
        let mArea = layoutInfo[j].area;
        let mColumn = layoutInfo[j].column;
        if (mRow === undefined || !mArea || mColumn === undefined) {
          continue;
        }
        gridOccupyStatus.markGridForRect(new RectItem(layoutInfo[j].row, layoutInfo[j].column,
          mRow + mArea[1], mColumn + mArea[0]), GridOccupyStatusEnum.OCCUPIED);
      }
    }

    return gridOccupyStatus.mStatus;
  }

  /**
   * 获取某页最后一个空位索引
   * @param layoutInfo 布局
   * @param row 行数
   * @param column 列数
   * @param pageIndex 页数
   * @returns 最后一个空位索引
   */
  public getLastIndexOfGridOccupy(layoutInfo: GridLayoutItemInfo[], row: number, column: number,
    pageIndex: number): number {
    let gridOccupyStatusFlat = this.getGridOccupyStatusEnum(layoutInfo, row, column, pageIndex).flat();
    return gridOccupyStatusFlat.lastIndexOf(GridOccupyStatusEnum.OCCUPIED);
  }

  /**
   * 获取指定屏幕上各个位置的占位状态，F为空闲，O被占用，U被卡片或者大文件占用
   *
   * @param layoutInfo 布局配置
   * @param row 屏幕的最大行
   * @param column 屏幕的最大列
   * @param pageIndex 当前屏幕索引
   * @returns  返回指定屏蔽上的占位状态，F为空闲，O被占用，U被卡片或者大文件占用
   */
  public getGridOccupyStatusEnumForInsertInto(layoutInfo: GridLayoutItemInfo[], row: number, column: number, pageIndex: number): GridOccupyStatusEnum[][] {
    if (layoutInfo === null || row < 1 || column < 1 || pageIndex < 0) {
      return new Array<Array<GridOccupyStatusEnum>>(0);
    }
    let gridOccupyStatus: GridOccupyStatus = new GridOccupyStatus(row, column, GridOccupyStatusEnum.FREE);
    for (let j = 0; j < layoutInfo.length; ++j) {
      if (layoutInfo[j].page === pageIndex) {
        let mRow = layoutInfo[j].row;
        let mArea = layoutInfo[j].area;
        let mColumn = layoutInfo[j].column;
        if (mRow === undefined || !mArea || mColumn === undefined) {
          continue;
        }
        if (mArea[1] > 1 || mArea[0] > 1) {
          gridOccupyStatus.markGridForRect(new RectItem(layoutInfo[j].row, layoutInfo[j].column,
            mRow + mArea[1], mColumn + mArea[0]), GridOccupyStatusEnum.UNKNOWN);
        } else {
          gridOccupyStatus.markGridForRect(new RectItem(layoutInfo[j].row, layoutInfo[j].column,
            mRow + mArea[1], mColumn + mArea[0]), GridOccupyStatusEnum.OCCUPIED);
        }
      }
    }
    return gridOccupyStatus.mStatus;
  }


  /**
   * 判断元素位置是否有效
   *
   * @param info 布局数据
   * @param item 元素数据
   * @param page 页数
   * @param startColumn 开始列
   * @param startRow 开始行
   * @returns true有效，false无效
   */
  public isPositionValid(info: DefaultDesktopLayoutInfo, item: GridLayoutItemInfo, page: number,
    startColumn: number, startRow: number): boolean {
    const row = info.layoutDescription.row;
    const column = info.layoutDescription.column;
    if (!item.area || page === undefined || page < 0) {
      return false;
    }
    if ((startColumn + item.area[0]) > column || (startRow + item.area[1]) > row) {
      return false;
    }
    let isValid = true;
    for (let x = startColumn; x < startColumn + item.area[0]; x++) {
      for (let y = startRow; y < startRow + item.area[1]; y++) {
        if (this.isPositionOccupied(info, page, x, y)) {
          isValid = false;
          break;
        }
      }
    }
    return isValid;
  }

  private isPositionOccupied(info: DefaultDesktopLayoutInfo, page: number, column: number, row: number): boolean {
    const layoutInfo = info?.layoutInfo;
    // current page has space
    for (const layout of layoutInfo) {
      if (layout.page === page) {
        if (!layout.area || layout.column === undefined || layout.row === undefined) {
          continue;
        }
        const xMatch = (column >= layout.column) && (column < layout.column + layout.area[0]);
        const yMatch = (row >= layout.row) && (row < layout.row + layout.area[1]);
        if (xMatch && yMatch) {
          return true;
        }
      }
    }
    return false;
  }

  /**
   * current position is Occupied.
   *
   * @param info: info deskTop items
   * @param item: Page item
   */
  public isCurrentPositionOccupied(item: GridLayoutItemInfo): boolean {
    let launcherLayout: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
    let description: LayoutDescription = launcherLayout.selectLayoutDescription();
    let isPad = this.getIsPad();
    let positionX = isPad ? item.row : item.column;
    let positionY = isPad ? item.column : item.row;
    const row = description.row;
    const column = description.column;
    if (positionX === undefined || positionY === undefined || !item.area) {
      return false;
    }
    if ((positionX + item.area[0]) > column || (positionY + item.area[1]) > row) {
      log.showInfo('currentPosition occupied positionX: %{public}d, positionY: %{public}d, areaX: %{public}d, ' +
        'areaY: %{public}d', positionX, positionY, item.area[0], item.area[1]);
      return true;
    }
    let isValid = false;
    outerLayer: for (let x = positionX; x < positionX + item.area[0]; x++) {
      for (let y = positionY; y < positionY + item.area[1]; y++) {
        // current page has space
        if (launcherLayout.isPositionOccupied(item.page ?? -1, x, y)) {
          log.showInfo('currentPosition occupied x: %{public}d, y: %{public}d, areaX: %{public}d, ' +
            'areaY: %{public}d, page: %{public}d', x, y, item.area[0], item.area[1], item.page);
          isValid = true;
          break outerLayer;
        }
      }
    }
    return isValid;
  }

  /**
   * Changing the Desktop Page Number.
   *
   * @param idx: Page number
   */
  setPageIndex(idx: number, isOuter?: boolean): void {
    log.showInfo('setPageIndex: ' + idx);
    AppStorage.setOrCreate(desktopUtil.getPageIndex(), idx);
  }

  /**
   * Get the Desktop Page Number.
   */
  getPageIndex(isOuter?: boolean): number {
    return desktopUtil.getPageIndexValue(isOuter) as number;
  }

  /**
   * get device type
   *
   * @return {boolean} isPad.
   */
  getIsPad(): boolean {
    return CommonConstants.PAD_DEVICE_TYPE === AppStorage.get('device');
  }

  /**
   * update page number if blank page is exist
   *
   * @param pageItemMap
   * @param layoutInfo
   */
  updateBlankPage(pageItemMap: Map<number, number>): void {
    log.showInfo('updateBlankPage');
    let launcherLayout: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
    let pageCount: number = launcherLayout.selectPageCount(false);
    log.showInfo(`updateBlankPage start, pageCount:${pageCount}`);
    let blankPages: number[] = [];
    for (let mEntry of pageItemMap) {
      let page = mEntry[0];
      let count = mEntry[1];
      log.showInfo(`pageIndex: ${page}, itemCount:${count}`);
      if (count === 0 && pageCount > 1) {
        pageCount--;
        blankPages.push(page);
      }
    }
    launcherLayout.updatePageCount(pageCount, BusinessType.BUSINESS_BASIC_DESKTOP, true, false);
    launcherLayout.updateLayoutAfterDeletePages(blankPages, BusinessType.BUSINESS_BASIC_DESKTOP, true);
  }

  private searchInCurrentPage(companionIconInfo: CompanionIconInfo): AppExitLocationInfo {
    const isFolderOpen: boolean = FolderManager.getInstance().isFolderOpen();
    if (isFolderOpen) {
      return this.searchInCurrentFolderOpenPage(companionIconInfo);
    } else {
      return this.searchInCurrentDeskTopPage(companionIconInfo);
    }
  }

  private checkAppInfoValidity(companionIconInfo: CompanionIconInfo, exitInfo: AppExitLocationInfo): boolean {
    return CheckEmptyUtils.isEmpty(companionIconInfo) || CheckEmptyUtils.isEmpty(exitInfo) ||
      !companionIconInfo.iconId || !exitInfo.isInScreen ||
      DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode();
  }

  /**
   * 执行应用退出
   *
   * @param sceneContainerSession 退出动效对应窗口的数据
   * @returns 应用退出数据
   */
  public buildAppExitInfo(sceneContainerSession: SCBSceneContainerSession): AppExitLocationInfo {
    // 退出应用时清除overlay动效信息
    sceneContainerSession.overlayCardTransition = null;
    let exitInfo: AppExitLocationInfo = this.searchInScreen(sceneContainerSession.companionIconInfo);
    log.showWarn(`buildAppExitInfo iconId: ${sceneContainerSession.companionIconInfo?.iconId}, isInScreen: ${exitInfo?.isInScreen}`);
    if (this.checkAppInfoValidity(sceneContainerSession.companionIconInfo, exitInfo)) {
      return { isInScreen: false, iconRect: null, appInFolderInfo: null, pageIndex: null, type: null };
    }
    let iconId = sceneContainerSession.companionIconInfo.iconId;
    let appInFolder: AppInFolderInfo = exitInfo.appInFolderInfo;
    const isOpenFolder: boolean = FolderManager.getInstance().isFolderOpen();
    if (!CheckEmptyUtils.isEmpty(appInFolder)) {
      log.showWarn(`buildAppExitInfo isOpenFolder: ${isOpenFolder}; index: ${appInFolder.index} size: ${appInFolder.size}`);
      if (!isOpenFolder && appInFolder.isSmallFolder) {
        // 应用图标在小文件夹中
        log.showWarn('buildAppExitInfo icon in small folder');
        exitInfo.iconRect = null;
        return exitInfo;
      }
      // 文件夹的折叠图标
      if (!isOpenFolder && appInFolder.index > appInFolder.size + 2) {
        // the 12th and later application icons in the folder,
        // return appIconId of the 11th application in the folder for position finding. Otherwise, return''
        let controller = SCBTransitionManager.getInstance().findTransitionController(appInFolder.bundleName, () => {
          return PageDesktopModel.getInstance().getCloseAppData(appInFolder?.bundleName ?? '',
            appInFolder?.abilityName ?? '',
            appInFolder?.startType, undefined, undefined, appInFolder?.appIndex, appInFolder?.shortcutId);
        });
        let appIconId: string = controller?.appData?.appIconId;
        let iconRadius: number = controller?.appData?.iconRadius;
        log.showWarn(`buildAppExitInfo appIconId: ${appIconId}, iconRadius: ${iconRadius}`);
        // 单层图标/快捷图标退出需要通过iconId获取位置并计算动效参数
        sceneContainerSession.companionIconInfo.iconId = appIconId;
        sceneContainerSession.companionIconInfo.iconRadius = iconRadius;
        iconId = String(appIconId);
      }
    }
    return this.getAppExitLocationInfo(exitInfo, iconId, sceneContainerSession);
  }

  private getAppExitLocationInfo(exitInfo: AppExitLocationInfo, iconId: string,
    sceneContainerSession: SCBSceneContainerSession): AppExitLocationInfo {
    if (CheckEmptyUtils.isEmpty(exitInfo)) {
      return {
        isInScreen: false,
        iconRect: null,
        appInFolderInfo: null,
        pageIndex: null,
        type: null
      };
    }
    if (CheckEmptyUtils.isEmpty(iconId)) {
      return exitInfo;
    }
    exitInfo.iconRect = ItemUtils.getRectByIdWithAttachedFrameNode(iconId);
    let isExitFromOuterStack: boolean = FormLayoutCacheManager.getInstance().checkIfFormInExternalStack(
      sceneContainerSession.companionIconInfo?.cardId) ?? false;
    isExitFromOuterStack = isExitFromOuterStack && launcherStatusUtil.getShowOutLauncherStatus() &&
    sceneContainerSession.companionIconInfo !== undefined && sceneContainerSession.companionIconInfo !== null;
    if (isExitFromOuterStack) {
      let outerStackExitPosScale: number = this.mOuterFormStackExitScale;
      let centerOfWidth: number = (exitInfo.iconRect.left + exitInfo.iconRect.right) / 2;
      let outerStackWidth: number = (centerOfWidth - exitInfo.iconRect.left) * outerStackExitPosScale;
      let outerStackHeight: number = (exitInfo.iconRect.bottom - exitInfo.iconRect.top) * outerStackExitPosScale;
      exitInfo.iconRect.bottom = exitInfo.iconRect.top + outerStackHeight;
      exitInfo.iconRect.left = centerOfWidth - outerStackWidth;
      exitInfo.iconRect.right = centerOfWidth + outerStackWidth;
      sceneContainerSession.companionIconInfo.iconRadius *= outerStackExitPosScale;
    }
    if (iconId.includes(SCBConstants.AI_SUGGESTION_BUNDLE_NAME) && exitInfo.iconRect?.left === 0 &&
      exitInfo.iconRect?.top === 0) {
      // iconId包含语音助手建议包名，且获取位置为0,0,0,0,改变语音助手建议的iconId尝试获取
      let oobeExitInfo = this.getOObeIconRect(exitInfo, sceneContainerSession);
      return oobeExitInfo as AppExitLocationInfo;
    }
    return exitInfo;
  }

  private getOObeIconRect(exitInfo: AppExitLocationInfo, scb: SCBSceneContainerSession): AppExitLocationInfo | null {
    if (exitInfo.iconRect && exitInfo.iconRect.left === 0 && exitInfo.iconRect.top === 0) {
      let iconId = scb.companionIconInfo?.iconId;
      let index = iconId?.lastIndexOf('_');
      if (index >= 0) {
        iconId = iconId.slice(0, index);
      }
      let newId = iconId + '_undefined';
      exitInfo.iconRect = ItemUtils.getRectById(newId);
      log.showInfo(`getRectById: ${newId} exitInfo.iconRect.left is: ${exitInfo.iconRect.left}}`);
      if (exitInfo.iconRect.left !== 0) {
        scb.companionIconInfo.iconId = newId;
        return exitInfo;
      }
    }
    if (exitInfo.iconRect && exitInfo.iconRect.left === 0 && exitInfo.iconRect.top === 0) {
      let newId: string = 'FormStackView_com.ohos.suggestion_' + scb.companionIconInfo?.extraId;
      exitInfo.iconRect = ItemUtils.getRectById(newId);
      log.showInfo(`getRectById: ${newId} exitInfo.iconRect.left is: ${exitInfo.iconRect.left}}`);
      if (exitInfo.iconRect.left !== 0) {
        scb.companionIconInfo.iconId = newId;
        return exitInfo;
      }
    }
    return null;
  }

  private searchInScreen(companionIconInfo: CompanionIconInfo): AppExitLocationInfo {
    let appExitInfo: AppExitLocationInfo = {
      isInScreen: false, iconRect: null, appInFolderInfo: null, pageIndex: null, type: null
    };
    if (sOutSideWindowMgr.isShowGlobalSearch()) {
      log.showInfo('app start or exit in globalSearch');
      appExitInfo.isInScreen = false;
      return appExitInfo;
    }
    if (sOutSideWindowMgr.isShowNegative() && !sOutSideWindowMgr.getDesktopEnabled()) {
      let isCardsShowFull: boolean = sOutSideWindowMgr.isIntelligentCardShowFull(companionIconInfo?.iconNumber?.toString());
      let isUserAnimation: boolean = AppStorage.get<boolean>('isIntelligentCardUseAnimation')  ?? false;
      appExitInfo.isInScreen = isCardsShowFull ? isUserAnimation && companionIconInfo?.iconId?.startsWith('CardsView_CardFrame_') : false;
      log.showInfo(`isShowNegative isCardsShow = ${isCardsShowFull}isUserAnim = ${isUserAnimation} iconId = ${companionIconInfo?.iconId}`);
      return appExitInfo;
    }
    if (companionIconInfo?.startAppType === StartType.RECENT_DOCK_APP) {
      log.showInfo(TAG, `is enter RECENT_DOCK_APP`);
      appExitInfo.isInScreen = true;
      return appExitInfo;
    }
    const isOpenFolder: boolean = FolderManager.getInstance().isFolderOpen();
    if (!isOpenFolder && !this.isFromSuggestion(companionIconInfo) &&
    this.isInDock(companionIconInfo?.bundleName, companionIconInfo?.abilityName, companionIconInfo?.appIndex, companionIconInfo?.shortcutId)) {
      log.showInfo(TAG, `is enter isInDock`);
      appExitInfo.isInScreen = true;
      return appExitInfo;
    }
    appExitInfo = this.searchInCurrentPage(companionIconInfo);
    return appExitInfo;
  }

  private isFromSuggestion(companionIconInfo: CompanionIconInfo): boolean {
    return (companionIconInfo?.startAppType === StartType.AI_SUGGESTION_APP ||
      (companionIconInfo?.startAppType === StartType.CARD && !CheckEmptyUtils.isEmpty(companionIconInfo.extraId) &&
        !Number.isNaN(companionIconInfo.extraId)));
  }

  /**
   * 待分屏启动
   */
  public onTransitionActiveForSplit(sceneContainerSession: SCBSceneContainerSession): void {
    let iconId: string = sceneContainerSession.companionIconInfo?.iconId;
    log.showWarn('onTransitionActiveForSplit companionIconInfo:{iconId:%{public}s, bundleName:%{public}s}',
      iconId, sceneContainerSession.companionIconInfo?.bundleName);
    let iconRectInfo: RectInfo | undefined;
    if (iconId && !sOutSideWindowMgr.isShowGlobalSearch()) {
      iconRectInfo = ItemUtils.getRectById(iconId);
    }
    sceneContainerSession.onTransitionActiveToRectForSplit(iconRectInfo);
  }

  /**
   * 应用启动
   *
   * @param sceneContainerSession 应用启动对应的窗口数据
   */
  public onTransitionActive(sceneContainerSession: SCBSceneContainerSession, isInScreen: boolean = false): void {
    let iconId: string = sceneContainerSession.companionIconInfo?.iconId;
    log.showWarn('onTransitionActive iconId:%{public}s, bundleName:%{public}s, isInScreen:%{public}s',
      iconId, sceneContainerSession.companionIconInfo?.bundleName, isInScreen);
    // 开始桌面图标动效，清除overlay动效信息
    sceneContainerSession.overlayCardTransition = null;
    sceneContainerSession.onTransitionActiveToRect(this.getIconRectInfo(sceneContainerSession.companionIconInfo,
      isInScreen, iconId));
  }

  private getIconRectInfo(companionIconInfo: CompanionIconInfo, isInScreen: boolean, iconId: string): RectInfo | null {
    // 正式商用版本上定制文件夹中不显示克隆应用与应用应用，因此需要定制处理
    const folderId: string = FolderManager.getInstance().getOpenedFolder().folderId;
    if (DeliverUtil.isContainerPkg(companionIconInfo?.bundleName) &&
      DeliverUtil.isContainerFolder(folderId)) {
      return null;
    }
    let iconRectInfo: RectInfo | null = null;
    if (!isInScreen) {
      isInScreen = this.searchInScreen(companionIconInfo)?.isInScreen;
    }
    if (iconId && isInScreen) {
      iconRectInfo = ItemUtils.getRectByIdWithAttachedFrameNode(iconId);
    }
    return iconRectInfo;
  }

  private searchInCurrentFolderOpenPage(companionIconInfo: CompanionIconInfo): AppExitLocationInfo {
    const openFolderData: GridLayoutItemInfo = FolderManager.getInstance().getOpenedFolder();
    if (!openFolderData || !openFolderData.layoutInfo) {
      log.showWarn('searchInCurrentFolderOpenPage, opened-folder or its layout is Empty');
      return { isInScreen: false, iconRect: null, appInFolderInfo: null, pageIndex: null, type: null };
    }
    const openFolderPageIndex: number = FolderManager.getInstance().getPageIndex();
    log.showWarn('searchInCurrentFolderOpenPage, folder page index is %{public}d', openFolderPageIndex);
    if (openFolderPageIndex >= openFolderData.layoutInfo.length) {
      log.showWarn('searchInCurrentFolderOpenPage, folder page index (%{public}d) larger than layout page (%{public}d)',
        openFolderPageIndex, openFolderData.layoutInfo.length);
      return { isInScreen: false, iconRect: null, appInFolderInfo: null, pageIndex: null, type: null };
    }

    let folderApp = openFolderData.layoutInfo[openFolderPageIndex].find((folderAppInfo: GridLayoutItemInfo) => {
      return this.isFoundApp(folderAppInfo, companionIconInfo);
    });
    let isInScreen = folderApp !== null && folderApp !== undefined;
    log.showWarn(`searchInCurrentFolderOpenPage ${companionIconInfo?.iconNumber}, ${folderApp}, ${isInScreen}`);
    return { isInScreen: isInScreen, iconRect: null, appInFolderInfo: null, pageIndex: null, type: null };
  }
  /**
   * 查找当前显示页元素
   * @param companionIconInfo 查找元素信息
   * @returns 查找到的元素结果
   */
  private findAppInCurrentShowingPage(companionIconInfo: CompanionIconInfo): AppTransitionInfo  {
    log.showWarn(`findAppInCurrentShowingPage bundleName: ${companionIconInfo.bundleName}` +
      `abilityName: ${companionIconInfo.abilityName}, moduleName: ${companionIconInfo.moduleName};` +
      `startAppType: ${companionIconInfo.startAppType}; cardId: ${companionIconInfo.cardId} ` +
      `appIndex: ${companionIconInfo.appIndex}, shortcutId: ${companionIconInfo.shortcutId}`);
    const appListInfo = AppStorage.get(desktopUtil.getAppListInfo()) as AppListInfo;
    const appGridInfo = appListInfo?.appGridInfo;
    if (ObjUtil.isInvalid(appGridInfo)) {
      log.showWarn('findAppInCurrentShowingPage appGridInfo is invalid, return');
      return { appInFolderInfo: null, app: null };
    }

    // 语音助手建议优先找位，找到则返回
    if (this.isFromSuggestion(companionIconInfo)) {
      // 需注意语音助手建议子图标不在appListInfo里面
      const suggestionInfo = this.findAppInCurrentShowingPageWithMethod(this.findSuggestAppInPageItems, appGridInfo,
        companionIconInfo, 'findAppSuggestInfo');
      if (suggestionInfo?.app != null) {
        log.showWarn(`findAppInCurrentShowingPage find suggest icon success, iconId:${companionIconInfo?.iconId}`);
        return suggestionInfo;
      }
    }

    return this.findAppInCurrentShowingPageWithMethod(this.findAppInCurrentPage, appGridInfo,
      companionIconInfo, 'findAppInfo');
  }

  /**
   * 根据传入的查找方法查找当前显示页的布局元素
   * @param findAppInPageMethod 页面元素查找方法
   * @param appGridInfo 当前布局元素
   * @param companionIconInfo 查找元素信息
   * @param msg 查找信息，补充tag说明
   * @returns 查找的结果
   */
  private findAppInCurrentShowingPageWithMethod(findAppInPageMethod: FindAppInPageMethod,
    appGridInfo: GridLayoutItemInfo[][], companionIconInfo: CompanionIconInfo, msg: string) : AppTransitionInfo {
    const page = this.getPageIndex();
    log.showWarn(`findAppInCurrentShowingPageWithMethod page: ${page} msg:${msg}`);
    let appTransitionInfo = findAppInPageMethod(appGridInfo[page], companionIconInfo);
    if (appTransitionInfo?.app != null) {
      log.showWarn(`findAppInCurrentShowingPageWithMethod page: ${page} componentId:${appTransitionInfo?.app?.componentId} msg:${msg}`);
      return appTransitionInfo;
    }
    // 三折叠需要查找关联显示页
    if (desktopUtil.isThreeScreenGState()) {
      PageInfoManager.getInstance().loopPageCallback(page, (callbackPage: number) : boolean => {
        appTransitionInfo = findAppInPageMethod(appGridInfo[callbackPage], companionIconInfo);
        const app = appTransitionInfo?.app;
        log.showWarn(`loopPageCallback callbackPage: ${callbackPage} page:${page} app is null? ${app == null}`);
        return app == null;
      }, false);
      return appTransitionInfo;
    }
    // 双折叠展开态需要查找隔壁页
    if (desktopUtil.isFoldExpandStatus()) {
      return findAppInPageMethod(appGridInfo[this.getNeighborPage(page)], companionIconInfo);
    }
    return { appInFolderInfo: null, app: null };
  }

  /**
   * 语音助手建议查找元素方法
   */
  private findSuggestAppInPageItems: FindAppInPageMethod =
    (eleInCurrentPage: GridLayoutItemInfo[], companionIconInfo: CompanionIconInfo): AppTransitionInfo => {
    const app: GridLayoutItemInfo | undefined = eleInCurrentPage?.find((appInfo: GridLayoutItemInfo) => {
      if (appInfo === null || appInfo === undefined) {
        log.showWarn(`findSuggestAppInPageItems startAppType is AI_SUGGESTION_APP appInfo is ${appInfo}`);
        return false;
      }
      return this.isFoundAiSuggestion(appInfo, companionIconInfo);
    });
    return { appInFolderInfo: null, app: app };
  }

  /**
   * 桌面普通元素(非语音助手建议图标)查找方法
   */
  private findAppInCurrentPage: FindAppInPageMethod =
    (eleInCurrentPage: GridLayoutItemInfo[], companionIconInfo: CompanionIconInfo): AppTransitionInfo => {
    log.showWarn('findAppInCurrentPage, eleInCurrentPage length: %{public}d', eleInCurrentPage?.length);
    let appInFolderInfo: AppInFolderInfo | null = null;
    const app: GridLayoutItemInfo | undefined = eleInCurrentPage?.find((appInfo: GridLayoutItemInfo) => {
      if (appInfo === null || appInfo === undefined) {
        log.showWarn(`findAppInCurrentPage appInfo ${appInfo}`);
        return false;
      }
      log.showDebug(`findAppInCurrentPage typeId: ${appInfo.typeId}`);
      if (appInfo?.typeId === CommonConstants.TYPE_FOLDER) {
        appInFolderInfo = this.searchInFolderComponent(appInfo, companionIconInfo);
        return appInFolderInfo !== null;
      } else {
        let isFound = this.isFoundApp(appInfo, companionIconInfo);
        if (isFound) {
          log.showWarn(`findAppInCurrentPage icon ${companionIconInfo.iconNumber}, ${appInfo.appIconId},` +
            `${appInfo.cardId}, ${appInfo.bundleName}`);
        }
        return isFound;
      }
    });
    return { appInFolderInfo: appInFolderInfo, app: app };
  }

  private isFoundAiSuggestion(appInfo: GridLayoutItemInfo, companionIconInfo: CompanionIconInfo): boolean {
    log.showDebug(`isFoundAiSuggestion startAppType=%{public}d, LayoutCardId=%{public}s, LayoutTypeId=%{public}d, companionExtraId=%{public}s`,
      companionIconInfo.startAppType, appInfo.cardId, appInfo.typeId, companionIconInfo.extraId);
    if (appInfo?.typeId === CommonConstants.TYPE_FORM_STACK) {
      const formStackId: string | undefined = appInfo.formStackId;
      const gridLayoutItemInfo =
        FormLayoutCacheManager.getInstance().selectGridLayoutItemByFormstackId(formStackId ?? '');
      let stackCards: GridLayoutItemInfo[] = gridLayoutItemInfo?.layoutInfo?.[0] ?? [];
      const endIndex = (stackCards?.length ?? 1) - 1;
      let isStackTop: boolean = stackCards?.[endIndex]?.cardId === companionIconInfo.extraId;
      if (isStackTop) {
        log.showWarn(`found in formStack cardId: ${companionIconInfo.extraId}, iconId: ${companionIconInfo.iconId}`);
        return true;
      }
    }
    if (appInfo?.cardId !== companionIconInfo.extraId) {
      return false;
    }
    if (companionIconInfo.startAppType === StartType.AI_SUGGESTION_APP) {
      const iconIdList: string[] = (GlobalContext.getInstance().getObject('AiSuggestionSubItems') as string[]) ?? [];
      let isFound: boolean = iconIdList.includes(companionIconInfo.iconId);
      if (isFound) {
        log.showWarn(`found in AiSuggestion cardId: ${companionIconInfo.extraId}, iconId: ${companionIconInfo.iconId}`);
      } else {
        let subItems: string = iconIdList.filter(iconId => iconId.endsWith(companionIconInfo.extraId ?? '')).toString();
        log.showWarn(`find app in AiSuggestion error, cardId: ${companionIconInfo.extraId}, subitems: ${subItems}`);
      }
      return isFound;
    }
    log.showInfo('isFoundAiSuggestion  startAppType=%{public}d, LayoutCardId=%{public}s, LayoutTypeId=%{public}d,' +
      ' companionExtraId=%{public}s LayoutKeyName=%{public}s',
      companionIconInfo.startAppType, appInfo.cardId, appInfo.typeId, companionIconInfo.extraId, appInfo.keyName);
    // 语音助手推荐中服务卡片，直接返回true
    return true;
  }

  public searchInCurrentDeskTopPage(companionIconInfo: CompanionIconInfo): AppExitLocationInfo {
    const notInCurrentPage: AppExitLocationInfo = {
      isInScreen: false,
      iconRect: null,
      appInFolderInfo: null,
      pageIndex: null,
      type: null
    };
    if (!companionIconInfo) {
      log.showError('companionIconInfo is null');
      return notInCurrentPage;
    }
    const appTransitionInfo :AppTransitionInfo = this.findAppInCurrentShowingPage(companionIconInfo);
    const appInFolderInfo = appTransitionInfo?.appInFolderInfo;
    const app =  appTransitionInfo?.app;
    const isInScreen = app !== null && app !== undefined;
    log.showWarn(`searchInCurrentDeskTopPage ${companionIconInfo?.iconNumber}, ${isInScreen}, ${app?.typeId}`);
    if (this.isFromSuggestion(companionIconInfo) && app?.typeId !== CommonConstants.TYPE_FORM_STACK && app?.typeId !== CommonConstants.TYPE_CARD) {
      log.showWarn(`searchInCurrentDeskTopPage isFromSuggestion but find app info, should back to app icon`);
      return notInCurrentPage;
    }
    return { isInScreen: isInScreen, iconRect: null, appInFolderInfo: appInFolderInfo, pageIndex: app?.page, type: null };
  }

  private initEleventhItemInfo(inFolderInfo: AppInFolderInfo, folderAppInfo: GridLayoutItemInfo): void {
    if (!folderAppInfo) {
      return;
    }
    inFolderInfo.bundleName = folderAppInfo.bundleName;
    inFolderInfo.abilityName = folderAppInfo.abilityName;
    inFolderInfo.appIndex = folderAppInfo.appIndex ?? 0;
    if (folderAppInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      inFolderInfo.shortcutId = folderAppInfo.shortcutId ?? '';
      inFolderInfo.startType = StartType.SHORTCUT_APP;
    }
  }

  private searchInFolderComponent(appInfo: GridLayoutItemInfo, companionIconInfo: CompanionIconInfo):
    AppInFolderInfo | null {
    let length = appInfo?.layoutInfo?.length ?? 0;
    let index: number = 0;
    let inFolderInfo: AppInFolderInfo = {
      folderId: '',
      isSmallFolder: false,
      index: 0,
      size: 0,
      bundleName: '',
      abilityName: '',
      appIndex: 0,
      shortcutId: '',
      startType: StartType.APP
    };
    log.showDebug('searchInFolderComponent length: %{public}i', length);
    let maxAppShowWhenClosed: number = GridLayoutUtil.getCountPerPageInFolder(appInfo.area ?? [1, 1]);
    for (let i = 0; i < length; i++) {
      let folderApp = appInfo?.layoutInfo?.[i]?.find((folderAppInfo: GridLayoutItemInfo) => {
        index++;
        if (index === maxAppShowWhenClosed + 2) {
          this.initEleventhItemInfo(inFolderInfo, folderAppInfo);
        }
        return this.isFoundApp(folderAppInfo, companionIconInfo);
      });
      let isFound = folderApp !== null && folderApp !== undefined;
      if (isFound) {
        log.showInfo('searchInFolderComponent i: %{public}i, index: %{public}i, folderId: %{public}s, folderApp: %{public}s',
          i, index, appInfo?.folderId, JSON.stringify(folderApp));
        inFolderInfo.folderId = appInfo?.folderId ?? '';
        inFolderInfo.isSmallFolder = GridLayoutUtil.isSmallFolder(appInfo);
        inFolderInfo.index = index;
        inFolderInfo.size = maxAppShowWhenClosed;
        return inFolderInfo;
      }
    }
    log.showWarn('searchInFolderComponent %{public}i; %{public}s, not found, return null', companionIconInfo?.iconNumber, companionIconInfo?.bundleName);
    return null;
  }

  /**
   * The appIconIds of different apps may be the same. Therefore, bundleName need to be checked.
   * @param appInfo app info
   * @param companionIconInfo companionIcon info
   * @returns is found app
   */
  private isFoundApp(appInfo: GridLayoutItemInfo, companionIconInfo: CompanionIconInfo): boolean {
    if (!companionIconInfo || !appInfo) {
      return false;
    }

    if (!CheckEmptyUtils.isEmpty(appInfo) && !CheckEmptyUtils.isEmpty(companionIconInfo) &&
      !CheckEmptyUtils.checkStrIsEmpty(appInfo.formStackId)) {
      return this.isFoundFormStackCardTop(appInfo, companionIconInfo);
    }
    if (companionIconInfo.startAppType === StartType.CARD) {
      return appInfo?.cardId === companionIconInfo?.cardId;
    }

    let isSameName:boolean = appInfo.bundleName === companionIconInfo.bundleName &&
      appInfo.abilityName === companionIconInfo.abilityName &&
      appInfo.moduleName === companionIconInfo.moduleName;
    let isSameIndex:boolean = (appInfo.appIndex ?? 0) === (companionIconInfo.appIndex ?? 0);
    let isSameShortcutId:boolean = (appInfo.shortcutId ?? '') === (companionIconInfo.shortcutId ?? '');
    let isFound:boolean = isSameName && isSameIndex && isSameShortcutId;
    if (isFound) {
      log.showWarn(`isFoundApp bundleName: ${appInfo.bundleName} abilityName: ${appInfo.abilityName}, ` +
        `moduleName: ${appInfo.moduleName}; appIconId: ${appInfo.appIconId}; cardId: ${appInfo.cardId} ` +
        `appIndex: ${appInfo.appIndex}, shortcutId: ${appInfo.shortcutId}`);
    }
    return isFound;
  }

  private isFoundFormStackCardTop(appInfo: GridLayoutItemInfo, companionIconInfo: CompanionIconInfo): boolean {
    if (!appInfo.layoutInfo || CheckEmptyUtils.isEmptyArr(appInfo.layoutInfo[0])) {
      log.showError('input is invalid, failed to find form stack card!');
      return false;
    }
    const formStackId: string | undefined = appInfo.formStackId;
    const gridLayoutItemInfo =
      FormLayoutCacheManager.getInstance().selectGridLayoutItemByFormstackId(formStackId ?? '');
    let formList: GridLayoutItemInfo[] = gridLayoutItemInfo?.layoutInfo?.[0] ?? [];
    const stackCardId = formList?.[(formList?.length ?? 1) - 1]?.cardId;
    log.showInfo(`stackCardId:${stackCardId},cardId:${companionIconInfo.cardId},extraId:${companionIconInfo.extraId}`);
    return stackCardId === companionIconInfo.cardId || stackCardId === companionIconInfo.extraId;
  }

  public isInDock(bundleName: string, abilityName: string, appIndex?: number, shortcutId?: string): boolean {
    let resistDockItems: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    if (resistDockItems?.length === undefined || resistDockItems.length === 0) {
      log.showWarn('resistDockItems is invalid, return');
      return false;
    }
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      log.showInfo(`isInDock: false, show outer screen`);
      return false;
    }
    if (!appIndex) {
      appIndex = 0;
    }
    if (!shortcutId) {
      shortcutId = '';
    }
    let dockItem = resistDockItems.find((item: DockItemInfo) => {
      if (!item) {
        return false;
      }
      return item.bundleName === bundleName && item.abilityName === abilityName && item.appIndex === appIndex &&
        (item.shortcutId ?? '') === shortcutId;
    });
    if (dockItem) {
      log.showInfo(`isInResident ${bundleName}, ${abilityName}, ${dockItem};resistDockItems length:${resistDockItems.length}`);
      return true;
    }
    return false;
  }

  public isInRecentDock(bundleName: string, abilityName: string): boolean {
    // find app from recent dock
    let recentDockList: DockItemInfo[] = RecentLayoutCacheMgr.getInstance().getAllDockItems();
    let recentDockItem = recentDockList?.find((item: DockItemInfo) => {
      return item?.bundleName === bundleName && item?.abilityName === abilityName;
    });
    return recentDockItem !== null && recentDockItem !== undefined;
  }

  private checkDockAppItem(item: DockItemInfo | RecentBundleMissionInfo, dockItemInfo: DockItemInfo): boolean {
    if (CheckEmptyUtils.isEmpty(dockItemInfo?.appIndex) && CheckEmptyUtils.checkStrIsEmpty(dockItemInfo?.appInstanceKey)) {
      return item?.bundleName === dockItemInfo.bundleName &&
        item?.abilityName === dockItemInfo.abilityName &&
        (item?.persistentId ?? '') === (dockItemInfo?.persistentId ?? '');
    }
    if (!CheckEmptyUtils.isEmpty(dockItemInfo?.appIndex) && CheckEmptyUtils.checkStrIsEmpty(dockItemInfo?.appInstanceKey)) {
      return item?.bundleName === dockItemInfo.bundleName &&
        item?.abilityName === dockItemInfo.abilityName &&
        item?.appIndex === dockItemInfo.appIndex &&
        (item?.persistentId ?? '') === (dockItemInfo?.persistentId ?? '');
    }
    if (CheckEmptyUtils.isEmpty(dockItemInfo?.appIndex) && !CheckEmptyUtils.checkStrIsEmpty(dockItemInfo?.appInstanceKey)) {
      return item?.bundleName === dockItemInfo.bundleName &&
        item?.abilityName === dockItemInfo.abilityName &&
        item?.appInstanceKey === dockItemInfo.appInstanceKey &&
        (item?.persistentId ?? '') === (dockItemInfo?.persistentId ?? '');
    }
    return item?.bundleName === dockItemInfo.bundleName &&
      item?.abilityName === dockItemInfo.abilityName &&
      item?.appIndex === dockItemInfo.appIndex &&
      item?.appInstanceKey === dockItemInfo.appInstanceKey &&
      (item?.persistentId ?? '') === (dockItemInfo?.persistentId ?? '');
  }

  public getAppInfoFromDock(dockItemInfo: DockItemInfo): AppItemInfo | RecentBundleMissionInfo | undefined {
    let resistDockItems: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let dockItem = resistDockItems.find((item: DockItemInfo) => {
      return this.checkDockAppItem(item, dockItemInfo);
    });
    if (dockItem) {
      return dockItem;
    }

    let recentItems: RecentBundleMissionInfo[] | undefined = AppStorage.get('recentList');
    let recentItem = recentItems?.find((item: RecentBundleMissionInfo) => {
      return this.checkDockAppItem(item, dockItemInfo);
    });
    return recentItem;
  }

  /**
   * 查询找到对应AppItemInfo数据
   *
   * @param bundleName 包名
   * @param moduleName 模块名
   * @param abilityName abilityName
   * @returns 对应的AppItemInfo数据
   */
  public getAbilityItemInfo(bundleName: string, moduleName: string, abilityName: string): AppItemInfo | undefined {
    let abilityItemInfo = SCBSceneSessionManager.getInstance().getAbilityInfo(bundleName, moduleName, abilityName);
    if (abilityItemInfo) {
      const appItemInfo = new AppItemInfo();
      appItemInfo.appLabelId = abilityItemInfo.appLabelId;
      appItemInfo.appIconId = abilityItemInfo.appIconId;

      const cacheKey = appItemInfo.appLabelId + bundleName + moduleName;
      const appName: string = ResourceManager.getInstance().getAppResourceCache(cacheKey, 'name') as string;
      if (!CheckEmptyUtils.isEmpty(appName)) {
        appItemInfo.appName = appName;
      } else {
        appItemInfo.appName = '';
      }
      appItemInfo.abilityName = abilityItemInfo.name;
      appItemInfo.moduleName = abilityItemInfo.moduleName;
      appItemInfo.bundleName = abilityItemInfo.bundleName;

      log.showDebug('getAbilityItemInfo appItemInfo' + JSON.stringify(appItemInfo));
      return appItemInfo;
    }
    log.showWarn('getAbilityItemInfo find no key');
    return undefined;
  }

  /**
   * 根据应用数据获取对应的SCBTransitionController
   *
   * @param appItem 应用数据
   * @returns 对应的SCBTransitionController
   */
  public getDefaultTransitionController(appItem: AppItemInfo): SCBTransitionController {
    return {
      appData: {
        bundleName: appItem?.bundleName,
        abilityName: appItem?.abilityName,
        appIconId: AppModel.getInstance().getAppIconContainerId('SmartDock_AppIcon', appItem?.bundleName, appItem?.abilityName, appItem?.appIndex),
        iconRadius: 0,
        appIconNumber: appItem?.appIconId,
      },
      onActive: (): void => {
      },
      onInactive: (): void => {
      }
    };
  }

  /**
   * 根据CompanionIconInfo获取当前应用启动场景类型
   *
   * @param companionIconInfo 应用启动退出所对应的CompanionIconInfo数据
   * @returns 启动场景类型
   */
  public getSceneLaunchType(companionIconInfo: CompanionIconInfo): string {
    if ((CloseAppManager.getInstance().getStartAppType() === StartType.APP_CENTER_APP) &&
      (CloseAppManager.getInstance().getStartAppSubtype() === StartSubtype.ICON_FROM_APP_CENTER)) {
      return 'LAUNCHER_APP_LAUNCH_FROM_APPCENTER';
    }
    if ((CloseAppManager.getInstance().getStartAppType() === StartType.DOCK_APP) &&
      (CloseAppManager.getInstance().getStartAppSubtype() === StartSubtype.DOCK_RIGHT_MENU)) {
      return 'START_APP_ANI_MENU';
    }
    if ((CloseAppManager.getInstance().getStartAppType() === StartType.CARD)) {
      return 'START_APP_ANI_FORM';
    }
    if ((CloseAppManager.getInstance().getStartAppType() === StartType.DESKTOP_APP)) {
      return 'LAUNCHER_APP_LAUNCH_FROM_ICON';
    }
    if ((CloseAppManager.getInstance().getStartAppType() === StartType.APP) &&
      (CloseAppManager.getInstance().getStartAppSubtype() === StartSubtype.ICON_FROM_OTHER)) {
      return 'LAUNCHER_APP_LAUNCH_FROM_OTHER';
    }
    if (this.isInDock(companionIconInfo?.bundleName, companionIconInfo?.abilityName, companionIconInfo?.appIndex)) {
      log.showInfo(`start app from dock: ${companionIconInfo?.bundleName} ${companionIconInfo?.abilityName} ${companionIconInfo?.appIndex}`);
      return 'LAUNCHER_APP_LAUNCH_FROM_DOCK';
    }
    if (this.searchInCurrentPage(companionIconInfo)?.isInScreen) {
      log.showInfo('start app from current page: ' + companionIconInfo?.bundleName + ':' + companionIconInfo?.abilityName);
      return 'LAUNCHER_APP_LAUNCH_FROM_ICON';
    }
    return 'LAUNCHER_APP_LAUNCH_FROM_APPCENTER';
  }

  /**
   * 获取应用启动数据
   *
   * @param bundleName 包名
   * @param abilityName AbilityName
   * @param startType 启动类型
   * @param formCardId 卡片ID
   * @param extraId 扩展ID
   * @returns 应用启动数据
   */
  public getCloseAppData(bundleName: string, abilityName: string, startType?: StartType,
      formCardId?: string, extraId?: string, appIndex?: number, shortcutId?: string, appInstanceKey?: string, screenId?: number): AppData {
    if (startType === undefined || startType === null) {
      startType = CloseAppManager.getInstance().getStartAppType();
    }
    // when folder opened only find in type StartType.FOLDER
    const isOpenFolder: boolean = FolderManager.getInstance().isFolderOpen();
    if (isOpenFolder && startType !== StartType.SHORTCUT_MENU && startType !== StartType.SHORTCUT_APP) {
      startType = StartType.FOLDER;
    }
    if (!appIndex) {
      appIndex = 0;
    }
    const cardId = (startType === StartType.CARD) ?
      formCardId ?? CloseAppManager.getInstance().getStartCardId() : undefined;
    if (extraId === undefined || extraId === null) {
      extraId = (startType === StartType.AI_SUGGESTION_APP || startType === StartType.RECENT_DOCK_APP ||
        startType === StartType.APP_CENTER_APP) ? CloseAppManager.getInstance().getExtraId() : undefined;
    }
    if (CheckEmptyUtils.checkStrIsEmpty(shortcutId)) {
      log.showWarn(`findTransitionController shortcutId empty bundleName:${bundleName}`);
      shortcutId = (startType === StartType.SHORTCUT_APP || startType === StartType.SHORTCUT_MENU) ?
        CloseAppManager.getInstance().getShortcutId() : undefined;
    }
    log.showWarn('findTransitionController bundleName: %{public}s, abilityName: %{public}s, startType: %{public}d, ' +
      'formCardId: %{public}s, cardId: %{public}s, extraId: %{public}s, appIndex: %{public}d, shortcutId: %{public}s, appInstanceKey: %{public}s',
      bundleName, abilityName, startType, formCardId, cardId, extraId, appIndex, shortcutId);
    let findData: AppData = {
      bundleName: bundleName,
      abilityName: abilityName,
      appIndex: appIndex,
      appIconId: '',
      iconRadius: 0,
      appIconNumber: 0,
      cardId: cardId,
      startAppType: startType,
      extraId: extraId,
      shortcutId: shortcutId,
      isOuterDesktop: launcherStatusUtil.getShowOutLauncherStatus() ? 'OuterDesktop' : undefined,
      appInstanceKey: appInstanceKey,
      screenId: screenId,
      isOpenFolder: isOpenFolder
    };
    return findData;
  }

  /**
   * 获取应用退出数据
   *
   * @param bundleName 包名
   * @param abilityName AbilityName
   * @param startType 启动类型
   * @param formCardId 卡片ID
   * @param extraId 扩展ID
   * @returns 应用退出数据
   */
  public getExitAppData(bundleName: string, abilityName: string, appIndex?: number, startType?: StartType,
                        formCardId?: string, extraId?: string, shortcutId?: string): AppData {
    if (startType === undefined || startType === null) {
      startType = CloseAppManager.getInstance().getStartAppType();
      log.showWarn(`getExitAppData startType getDefault:${startType}`);
    }
    let cardId = startType === StartType.CARD ? formCardId ?? CloseAppManager.getInstance().getStartCardId() : undefined;
    log.showWarn(`getExitAppData formCardId:${formCardId};cardId:${cardId}`);
    // when folder opened only find in type StartType.FOLDER
    const isOpenFolder: boolean = FolderManager.getInstance().isFolderOpen();
    if (isOpenFolder && startType !== StartType.SHORTCUT_MENU && startType !== StartType.SHORTCUT_APP) {
      startType = StartType.FOLDER;
    }
    if (!appIndex) {
      appIndex = 0;
    }
    if (extraId === undefined || extraId === null) {
      extraId = (startType === StartType.AI_SUGGESTION_APP || startType === StartType.RECENT_DOCK_APP) ?
      CloseAppManager.getInstance().getExtraId() : undefined;
    }
    if (CheckEmptyUtils.checkStrIsEmpty(shortcutId)) {
      shortcutId = (startType === StartType.SHORTCUT_APP || startType === StartType.SHORTCUT_MENU) ?
        CloseAppManager.getInstance().getShortcutId() : undefined;
    }
    log.showWarn('getExitAppData bundleName: %{public}s, abilityName: %{public}s, startType: %{public}d, ' +
      'formCardId: %{public}s, cardId: %{public}s, extraId: %{public}s, appIndex: %{public}d, shortcutId: %{public}s',
      bundleName, abilityName, startType, formCardId, cardId, extraId, appIndex, shortcutId);
    let findData: AppData = {
      bundleName: bundleName,
      abilityName: abilityName,
      appIndex: appIndex,
      appIconId: '',
      iconRadius: 0,
      appIconNumber: 0,
      cardId: cardId,
      startAppType: startType,
      extraId: extraId,
      shortcutId: shortcutId,
      isOuterDesktop: launcherStatusUtil.getShowOutLauncherStatus() ? 'OuterDesktop' : undefined
    };
    return findData;
  }
}

export interface SelectChangeListener {
  onSelectStatusChange(selectStatus: boolean): void;
  onCutStatusChange(cutStatus: boolean): void;
  onFocusStatusChange(isGainFocus : boolean): void;
}

export interface FocusChangeListener {
  onFocusChange(): void;
}

export interface SelectItemChangeListener {
  selectAllOrSomeDesktopItem(selectPaste?: string[]): void;
}

export interface VisibleChangeListener {
  onVisibleChange(visible: boolean): void;
}

export interface UninstallListener {
  uninstallApp: (bundleName: string, appIndex?: number, shortcutId?: string) => void;
  uninstallAppResult: (bundleName: string, resultCode: number, appIndex?: number, shortcutId?: string) => void;
}

export class GridAppListInfo {
  public gridAppsInfos: GridLayoutItemInfo[][] = [];
  public waterfallAppInfos: GridLayoutItemInfo[] = [];
}

export class GridAppListInfoNew {
  public appGridInfo: GridLayoutItemInfo[][] = [];
  public waterfallItemListInfo: GridLayoutItemInfo[] = [];
}

export class PageInfo {
  public startPageIndex: number = 0;
  public pageCount: number = 0
}

export class StartInfo {
  public startColumn: number = 0;
  public startRow: number = 0
}

export class PageColumnInfo {
  public pageIndex: number = 0;
  public row: number = 0;
  public column: number = 0
}

export class ResponseCode {
  public code: number = -1;
  public errorCode: number = -1
}

export class FormAnimateData {
  public cardId: string = '';
  public isOpenRemoveFormDialog: boolean = false;
}