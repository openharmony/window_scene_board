/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
  ArrayUtils,
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
  RectItem,
  SingleContext,
} from '@ohos/basicutils';
import { DeviceHelper, localEventManager, } from '@ohos/frameworkwrapper';
import { desktopUtil } from '@ohos/componenthelper';
import { GridOccupyStatus, GridOccupyStatusEnum } from '@ohos/componentdrag';
import { SCBScreenSessionManager, launcherStatusUtil, SCBScreenSession } from '@ohos/windowscene';
import { AppItemInfo } from '../../bean/AppItemInfo';
import { CardItemInfo } from '../../bean/CardItemInfo';
import { PageUpdateItem } from '../../bean/PageUpdateItem';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import LayoutDescription from '../../bean/LayoutDescription';
import DefaultDesktopLayoutInfo from '../../configs/DefaultDesktopLayoutInfo';
import { GridLayoutConfig } from '../../configs/GridLayoutConfigs';
import { BusinessType, CommonConstants, DeviceState, ItemParameter } from '../../constants/CommonConstants';
import { EventConstants } from '../../TsIndex';
import { RdbStoreManager } from '../../db/RdbStoreManager';
import { StyleConstants } from '../../constants/StyleConstants';
import GridLayoutUtil from '../../utils/GridLayoutUtil';
import { DesktopLayoutCacheData } from './DesktopLayoutCacheData';
import { ILayoutCacheManager } from './ILayoutCacheManager';
import { LauncherLayoutCacheUtil } from './LauncherLayoutCacheUtil';
import { SwiperLoadManager } from './SwiperLoadManager';
import { PageInfoManager } from './PageInfoManager';
import { SwiperLoadData } from '@ohos/swiperdata/src/main/ets/TsIndex';
import { EditModeUtils } from '../../TsIndex';

const TAG = 'BaseLayoutCacheManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class BaseLayoutCacheManager implements ILayoutCacheManager {
  private static baseLayoutInstance: BaseLayoutCacheManager;

  protected layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(DefaultDesktopLayoutInfo.getDefaultLayoutInfo());

  constructor() {
    log.showInfo('the mGridLayoutItemList size %{public}d', this.layoutCacheData.getGridLayoutItemList()?.length);
  }

  static getInstance(): BaseLayoutCacheManager {
    if (BaseLayoutCacheManager.baseLayoutInstance == null) {
      BaseLayoutCacheManager.baseLayoutInstance = new BaseLayoutCacheManager();
    }
    return BaseLayoutCacheManager.baseLayoutInstance;
  }

  public reInit(layoutCacheData: DesktopLayoutCacheData): void {
    this.layoutCacheData = layoutCacheData;
    log.showInfo('the mGridLayoutItemList size %{public}d', this.layoutCacheData.getGridLayoutItemList()?.length);
  }

  /**
   * 获取所有布局元素
   *
   * @param label 业务标识
   * @returns 所有布局元素
   */
  getAllGridLayoutItemList(label: string, isOuter?: boolean): GridLayoutItemInfo[] {
    let res = this.layoutCacheData.getGridLayoutItemList(isOuter);
    log.showInfo('getAllGridLayoutItemList from %{public}s, size: %{public}d', label, res.length);
    return res;
  }

  /**
   * 获取旋转后的缓存
   * @returns
   */
  public getRotateGridLayoutList(): GridLayoutItemInfo[] {
    return this.layoutCacheData.getRotateLayoutInfo();
  }

  /**
   * 是否是pad
   * @returns
   */
  public isPad(): boolean {
    return this.layoutCacheData.isPad();
  }

  /**
   * 从缓存中获取APP
   *
   * @param layoutList 缓存
   * @param appInfo 要查找的APP
   * @returns
   */
  public findAppInCache(layoutList: GridLayoutItemInfo[], appInfo: AppItemInfo): GridLayoutItemInfo | undefined {
    if (!layoutList || layoutList.length === 0) {
      return undefined;
    }
    for (let i = 0; i < layoutList.length; i++) {
      let gridItem = layoutList[i];
      if (gridItem.typeId === CommonConstants.TYPE_APP) {
        if (gridItem.bundleName === appInfo.bundleName && gridItem.appIndex === appInfo.appIndex) {
          return gridItem;
        }
      } else if (gridItem.typeId === CommonConstants.TYPE_FOLDER) {
        let gridLayoutInfo: GridLayoutItemInfo | undefined = gridItem.layoutInfo?.flat().find(
          item => item.bundleName === appInfo.bundleName && item.appIndex === appInfo.appIndex
        );
        if (gridLayoutInfo) {
          return gridLayoutInfo;
        }
      }
    }
    return undefined;
  }

  /**
   * 获取桌面布局信息
   *
   * @param label 业务标识
   * @returns 桌面布局
   */
  getDesktopLayoutInfo(label: string): DefaultDesktopLayoutInfo {
    log.showInfo('getDesktopLayoutInfo from %{public}s', label);
    return this.layoutCacheData.getGridLayoutInfo();
  }

  selectAppAndShortcutByContainer(container: number, isOuter: boolean): GridLayoutItemInfo[] {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    return gridLayoutItemList.filter(item => (item.container === container &&
      (item.typeId === CommonConstants.TYPE_APP || item.typeId === CommonConstants.TYPE_SHORTCUT_ICON)));
  }

  /**
   * 查询所在父容器元素
   */
  selectContainerGridLayoutItem(selectItem: GridLayoutItemInfo): GridLayoutItemInfo | undefined {
    if (!selectItem || selectItem.container === CommonConstants.CONTAINER_DESKTOP ||
    CheckEmptyUtils.isEmpty(selectItem.container)) {
      return undefined;
    }
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    return gridLayoutItemList.find(item => item.id === selectItem.container);
  }

  selectGridLayoutItemById(infoId: string | number): GridLayoutItemInfo | undefined {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    return gridLayoutItemList.find(item => item.infoId === infoId);
  }

  selectGridLayoutItemByIno(ino: string): GridLayoutItemInfo | undefined {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    return gridLayoutItemList.find(item => item.ino === ino);
  }

  selectGridLayoutItemsByBundleName(bundleName: string): GridLayoutItemInfo[] {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    return gridLayoutItemList.filter(item => item.bundleName === bundleName);
  }

  selectGridLayoutItemsByBundleNameAndAppIndex(bundleName: string, appIndex: number,
    isOuter: boolean): GridLayoutItemInfo[] {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    return gridLayoutItemList.filter(item => item.bundleName === bundleName && item.appIndex === appIndex);
  }

  selectGridLayoutItemsByType(typeId: number, isOuter?: boolean): GridLayoutItemInfo[] {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    return gridLayoutItemList.filter(item => item.typeId === typeId);
  }

  selectGridLayoutItemsByBundleAndType(bundleName: string, typeId: number): GridLayoutItemInfo[] {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    return gridLayoutItemList.filter(item => item.typeId === typeId && item.bundleName === bundleName);
  }

  selectGridLayoutItemByPosition(page: number, row: number, col: number): GridLayoutItemInfo | undefined {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    return gridLayoutItemList.find(item => item.page === page && item.row === row && item.column === col);
  }

  selectGridLayoutItemByIndex(index: number, isOuter?: boolean): GridLayoutItemInfo | undefined {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    if (index < 0 || index >= gridLayoutItemList.length || CheckEmptyUtils.isEmptyArr(gridLayoutItemList)) {
      return undefined;
    }
    return gridLayoutItemList[index];
  }

  selectIndexInLayout(item?: GridLayoutItemInfo, isOuter?: boolean): number {
    if (!item) {
      return -1;
    }
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    return gridLayoutItemList.indexOf(item);
  }

  /**
   * 更加删除的deleteItem信息删除布局元素
   *
   * @param deleteItem 删除的应用信息
   * @returns 布局元素列表
   * @returns 布局元素列表
   */
  selectSameAppAndFolder(keyName: string, bundleName: string, folderId: string, appIndex?: number,
    shortcutId?: string, isOuter?: boolean): GridLayoutItemInfo[] {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    return gridLayoutItemList.filter(item => LauncherLayoutCacheUtil.isSameAppOrSmallFolder(item, bundleName, keyName,
      folderId, appIndex, shortcutId));
  }

  /**
   * 查询页数
   *
   * @returns pageCount
   */
  selectPageCount(isOuter? : boolean): number {
    let gridLayoutInfo: DefaultDesktopLayoutInfo = this.layoutCacheData.getGridLayoutInfo(isOuter);
    return gridLayoutInfo.layoutDescription.pageCount;
  }

  /**
   * 查询最大页数
   *
   * @returns maxPage
   */
  selectMaxPageCount(isOuter?: boolean): number {
    let gridLayoutInfo: DefaultDesktopLayoutInfo = this.layoutCacheData.getGridLayoutInfo(isOuter);
    return gridLayoutInfo.layoutDescription.maxPage;
  }

  /**
   * 查询布局的描述信息
   *
   * @returns layoutDescription
   */
  selectLayoutDescription(isOuter?: boolean): LayoutDescription {
    let gridLayoutInfo: DefaultDesktopLayoutInfo = this.layoutCacheData.getGridLayoutInfo(isOuter);
    return gridLayoutInfo.layoutDescription;
  }

  /**
   * 查询最大的卡片数量
   *
   * @returns maxForm
   */
  selectMaxForm(): number {
    let gridLayoutInfo: DefaultDesktopLayoutInfo = this.layoutCacheData.getGridLayoutInfo();
    return gridLayoutInfo.layoutDescription.maxForm;
  }

  /**
   * 查询指定页数占用状态
   *
   * @param pageIndex 页数
   * @returns
   */
  selectGridOccupyStatusForPage(pageIndex: number): GridOccupyStatusEnum[][] {
    let gridLayoutInfo: DefaultDesktopLayoutInfo = this.layoutCacheData.getGridLayoutInfo();
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    let row: number = gridLayoutInfo.layoutDescription.row;
    let col: number = gridLayoutInfo.layoutDescription.column;
    let gridOccupyStatus: GridOccupyStatus = new GridOccupyStatus(row, col, GridOccupyStatusEnum.FREE);
    for (let j = 0; j < gridLayoutItemList.length; ++j) {
      let mArea = gridLayoutItemList[j].area;
      if (!mArea || CheckEmptyUtils.isEmptyArr(mArea) || mArea.length <= 1) {
        log.showWarn('the area of item is invalid bundleName %{public}s, type %{public}d',
          gridLayoutItemList[j].bundleName, gridLayoutItemList[j].typeId);
        continue;
      }
      if (gridLayoutItemList[j].page === pageIndex) {
        gridOccupyStatus.markGridForRect(new RectItem(gridLayoutItemList[j].row, gridLayoutItemList[j].column,
          (gridLayoutItemList[j].row ?? 0) + mArea[1], (gridLayoutItemList[j].column ?? 0) +
          mArea[0]), GridOccupyStatusEnum.OCCUPIED);
      }
    }

    return gridOccupyStatus.mStatus;
  }

  /**
   * 查询每页的元素
   *
   * @returns map
   */
  selectPageItemMap(): Map<string, number> {
    let gridLayoutInfo: DefaultDesktopLayoutInfo = this.layoutCacheData.getGridLayoutInfo();
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    const pageItemMap = new Map<string, number>();
    let pageCount: number = gridLayoutInfo.layoutDescription.pageCount;
    for (let i = 0; i < pageCount; i++) {
      pageItemMap.set(i.toString(), 0);
    }

    for (let i = 0; i < gridLayoutItemList.length; i++) {
      const tmpPage = gridLayoutItemList[i].page?.toString();
      if (tmpPage) {
        pageItemMap.set(tmpPage, (pageItemMap.get(tmpPage) ?? 0) + 1);
      }
    }
    return pageItemMap;
  }

  /**
   * 查询已占用的空间
   *
   * @returns 占用的空间
   */
  selectAllOccupiedSpace(): number {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    let itemCount: number = 0;
    for (let i = 0; i < gridLayoutItemList.length; i++) {
      let mArea = gridLayoutItemList[i].area;
      let mPage = gridLayoutItemList[i].page;
      if (mPage !== undefined && mPage >= 0 && mArea) {
        itemCount = itemCount + mArea[0] * mArea[1];
      }
    }

    return itemCount;
  }

  /**
   * 查询桌面最大的可容纳元素的网格空间数
   *
   * @returns 最大空间数
   */
  public selectMaxSpace(): number {
    let gridLayoutInfo: DefaultDesktopLayoutInfo = this.layoutCacheData.getGridLayoutInfo(false);
    let maxPageCount: number = gridLayoutInfo.layoutDescription.maxPage;
    let maxCol: number = gridLayoutInfo.layoutDescription.column;
    let maxRow: number = gridLayoutInfo.layoutDescription.row;
    return maxCol * maxRow * maxPageCount;
  }

  /**
   * 根据id查找item元素
   *
   * @param selectItem 用来查找的item信息
   * @returns 查找到的item信息
   */
  selectGridLayoutItemByItem(selectItem: GridLayoutItemInfo, isOuter?: boolean): GridLayoutItemInfo | undefined {
    if (CheckEmptyUtils.isEmpty(selectItem)) {
      log.showWarn('selectGridLayoutItemById error with null selectItem');
      return undefined;
    }
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    let layoutItem: GridLayoutItemInfo | undefined = gridLayoutItemList.find(item =>
    GridLayoutUtil.checkGridItemEqual(item, selectItem));
    if (CheckEmptyUtils.isEmpty(layoutItem)) {
      log.showWarn('selectGridLayoutItemById cannot find item. key: %{public}s', GridLayoutUtil.generateUniqueKey(selectItem, isOuter));
    }
    return layoutItem;
  }

  /**
   * 根据uniqueKey查找item元素
   * 同时支持string和string[], 参数是数组,返回值就是数组
   * @param uniqueKey gridLayoutUtil.generateUniqueKey生成的key
   * @returns 查找到的item信息
   */
  selectGridLayoutItemByUniqueKey<T extends string | string[], R = GridLayoutItemInfo | GridLayoutItemInfo[]>(
    uniqueKey: T
  ): R | undefined {
    if (CheckEmptyUtils.isEmpty(uniqueKey)) {
      log.showWarn('selectGridLayoutItemByUniqueKey error with null uniqueKey');
      return undefined;
    }
    const itemMap: Map<string, GridLayoutItemInfo | undefined> = new Map();
    (Array.isArray(uniqueKey) ? uniqueKey : [uniqueKey]).forEach((item: string) => {
      itemMap.set(item, undefined);
    });

    this.layoutCacheData.getGridLayoutItemList().forEach(item => {
      const itemKey: string = GridLayoutUtil.generateUniqueKey(item);
      if (itemMap.has(itemKey)) {
        if (CheckEmptyUtils.isEmpty(item)) {
          log.showWarn('selectGridLayoutItemByUniqueKey cannot find item. key: %{public}s', itemKey);
          return;
        }
        itemMap.set(itemKey, item);
      }
    });

    const itemList = Array.from(itemMap.values());
    return (Array.isArray(uniqueKey) ? itemList : itemList[0]) as R;
  }

  /**
   * 判断当前页是否为空白也
   *
   * @param page 当前页
   * @returns true表示是空白页
   */
  isBlankPage(page: number, isOuter?: boolean): boolean {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    for (const item of gridLayoutItemList) {
      if (item.page === page) {
        log.showInfo(`isBlankPage:false, page:${page}, row:${item.row}, column:${item.column}, bundleName:${item.bundleName}, ` +
          `typeId:${item.typeId}, cardId:${item.cardId}, folderId:${item.folderId}, formStackId:${item.formStackId}`);
        return false;
      }
    }
    return true;
  }

  /**
   * 通过传入fixedPageId判断新增应用是否会超过指定页面或最大页面
   *
   * @param gridConfig:桌面宫格信息,fixedPageId:需要统计的页面id,默认为-1时表示统计所有页面
   * @returns true表示新增应用会超过页面宫格数量
   */
  isAddAppOverMaxPage(gridConfig: GridLayoutConfig, fixedPageId: number = CommonConstants.INVALID_VALUE,
    gridLayoutItemList?: GridLayoutItemInfo[]): boolean {
    if (CheckEmptyUtils.isEmpty(gridConfig)) {
      log.showWarn('isAddAppOverMaxPage error as the gridConfig is null');
      return true;
    }
    let gridLayoutInfo: DefaultDesktopLayoutInfo = this.layoutCacheData.getGridLayoutInfo();
    const column = gridConfig.column;
    const row = gridConfig.row;
    if (!gridLayoutItemList) {
      gridLayoutItemList = this.layoutCacheData.getGridLayoutItemList();
    }

    let itemCount: number = 0;
    for (let i = 0; i < gridLayoutItemList.length; i++) {
      let mPage = gridLayoutItemList[i].page;
      let mArea = gridLayoutItemList[i].area;
      if (!mArea) {
        continue;
      }
      if ((fixedPageId === CommonConstants.INVALID_VALUE && mPage !== undefined && mPage >= 0) ||
        (fixedPageId >= 0 && mPage === fixedPageId)) {
          itemCount = itemCount + mArea[0] * mArea[1];
      }
    }
    // 没有指定页面则统计所有页面，否则只计算指定的1个页面
    const countPageNum: number = (fixedPageId === CommonConstants.INVALID_VALUE) ? gridLayoutInfo.layoutDescription.maxPage : 1;
    return itemCount + 1 > column * row * countPageNum;
  }

  /**
   * 查找应用是否在文件夹中
   *
   * @param appItemInfo 应用信息
   * @returns true表示在文件夹中
   */
  isAppInFolder(appItemInfo: AppItemInfo): boolean {
    if (CheckEmptyUtils.isEmpty(appItemInfo)) {
      log.showWarn(`isAppInFolder error as the appItem is null`);
      return false;
    }
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    for (let i = 0; i < gridLayoutItemList.length; i++) {
      if (gridLayoutItemList[i].typeId === CommonConstants.TYPE_FOLDER ||
        gridLayoutItemList[i].typeId === CommonConstants.TYPE_REGION_FOLDER) {
        const appIndex = gridLayoutItemList[i].layoutInfo?.[0].findIndex(item => {
          return item.keyName === appItemInfo?.keyName;
        }) ?? CommonConstants.INVALID_VALUE;
        if (appIndex !== CommonConstants.INVALID_VALUE) {
          return true;
        }
      }
    }
    return false;
  }

  /**
   * 检查当前页是否有空白位置
   *
   * @param item 元素
   * @param page 页数
   * @param startColumn 开始列
   * @param startRow 开始行
   * @returns true表示有空不位置
   */
  isPositionValid(item : GridLayoutItemInfo | CardItemInfo | ItemParameter, page: number,
    startColumn: number, startRow: number, isOuter?: boolean): boolean {
    if (!item || !item.area || CheckEmptyUtils.isEmptyArr(item.area)) {
      log.showWarn('isPositionValid error as the item is null');
      return false;
    }
    let gridLayoutInfo: DefaultDesktopLayoutInfo = this.layoutCacheData.getGridLayoutInfo(isOuter);
    const row: number = gridLayoutInfo.layoutDescription.row;
    const column: number = gridLayoutInfo.layoutDescription.column;
    if ((startColumn + item.area[0]) > column || (startRow + item.area[1]) > row) {
      return false;
    }
    let isValid = true;
    for (let x = startColumn; x < startColumn + item.area[0]; x++) {
      for (let y = startRow; y < startRow + item.area[1]; y++) {
        if (this.isPositionOccupied(page, x, y, isOuter)) {
          isValid = false;
          break;
        }
      }
    }
    return isValid;
  }

  /**
   * 检查当前页是否有空白位置
   *
   * @param page 页数
   * @param startColumn 开始列
   * @param startRow 开始行
   * @returns true表示有空位置
   */
  public isFindBlankPositionPage(area: number[], page: number, startColumn: number, startRow: number,
    isOuter?: boolean): boolean {
    if (CheckEmptyUtils.isEmpty(area)) {
      log.showWarn('isPositionValid error as the item is null');
      return false;
    }
    let gridLayoutInfo: DefaultDesktopLayoutInfo = this.layoutCacheData.getGridLayoutInfo(isOuter);
    const row: number = gridLayoutInfo.layoutDescription.row;
    const column: number = gridLayoutInfo.layoutDescription.column;
    let endColumn = startColumn + area[0];
    let endRow = startRow + area[1];
    if (endColumn > column || endRow > row) {
      return false;
    }
    let isValid = true;
    for (let x = startColumn; x < startColumn + area[0]; x++) {
      for (let y = startRow; y < startRow + area[1]; y++) {
        if (this.isPositionOccupied(page, x, y, isOuter)) {
          isValid = false;
          break;
        }
      }
    }
    return isValid;
  }

  /**
   * 判断位置是否合理
   *
   * @param page
   * @param column
   * @param row
   * @param gridList
   * @returns
   */
   isPositionOccupied(page: number, column: number, row: number, isOuter?: boolean): boolean {
    let gridList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    for (const item of gridList) {
      if (item.page === page) {
        if (item.column === undefined || !item.area || item.row === undefined) {
          continue;
        }
        const xMatch = (column >= item.column) && (column < item.column + item.area[0]);
        const yMatch = (row >= item.row) && (row < item.row + item.area[1]);
        if (xMatch && yMatch) {
          return true;
        }
      }
    }
    return false;
  }

  deleteGridLayoutItemByBundleNameAndType(bundleName: string, typeId: number, label: string, isOperateDb: boolean = true): void {
    log.showInfo('deleteGridLayoutItemByBundleNameAndType with bundleName %{public}s from business %{public}s db: %{public}s',
      bundleName, label, isOperateDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    let deleteItem = gridLayoutItemList.find(item => item.bundleName === bundleName && item.typeId === typeId);
    if (!deleteItem) {
      log.showWarn('deleteGridLayoutItemByBundleNameAndType failure with null deleteItem');
      return;
    }
    let filter = (item: GridLayoutItemInfo): boolean => item.bundleName !== bundleName || item.typeId !== typeId;
    let newGridLayoutItemList: GridLayoutItemInfo[] = gridLayoutItemList.filter(filter);
    this.layoutCacheData.updateLayoutListCache(newGridLayoutItemList);

    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.deleteGridLayoutItemByInfoIdCallBack(deleteItem.infoId, [deleteItem.page]);
      } catch (error) {
        log.showError('deleteGridLayoutItemByBundleNameAndType with error %{public}s', error.message);
      }
    }
  }

  deleteGridLayoutItemById(deleteItem: GridLayoutItemInfo, label: string, isOperateDb: boolean = true, isOuter?: boolean): void {
    if (CheckEmptyUtils.isEmpty(deleteItem)) {
      log.showWarn('deleteGridLayoutItemById error with null deleteItem');
      return;
    }
    log.showInfo('deleteGridLayoutItemById with id %{public}s from business %{public}s db %{public}s',
      String(deleteItem.id), label, isOperateDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    let filter = (item: GridLayoutItemInfo): boolean => !GridLayoutUtil.checkGridItemEqual(item, deleteItem);
    let newGridLayoutItemList: GridLayoutItemInfo[] = gridLayoutItemList.filter(filter);
    this.layoutCacheData.updateLayoutListCache(newGridLayoutItemList, isOuter);

    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.deleteGridLayoutItemByInfoIdCallBack(deleteItem.infoId, [deleteItem.page], isOuter);
      } catch (error) {
        log.showError('deleteGridLayoutItemById with error %{public}s', error.message);
      }
    }
  }

  deleteGridLayoutItemByItemId(id: string | number, label: string, isOperateDb: boolean = true): void {
    log.showInfo('deleteGridLayoutItemById with id %{public}s from business %{public}s db %{public}s', String(id), label, isOperateDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    let filter = (item: GridLayoutItemInfo): boolean => item.infoId !== id;
    let newGridLayoutItemList: GridLayoutItemInfo[] = gridLayoutItemList.filter(filter);
    this.layoutCacheData.updateLayoutListCache(newGridLayoutItemList);

    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.deleteGridLayoutItemByInfoIdCallBack(id, this.getAppItemListPage(newGridLayoutItemList));
      } catch (error) {
        log.showError('deleteGridLayoutItemById with error %{public}s', error.message);
      }
    }
  }

  getAppItemListPage(appItemsList: GridLayoutItemInfo[]): number[] {
    let updatePages: number[] = [];
    appItemsList.forEach((item) => {
      if (item.page && updatePages.indexOf(item.page) === -1) {
        updatePages.push(item.page);
      }
    });
    return updatePages;
  }

  deleteGridLayoutItemByPosition(page: number, row: number, col: number, label: string, isOperateDb: boolean = true): void {
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    let deleteItem: GridLayoutItemInfo | undefined =
      gridLayoutItemList.find(item => item.page === page && item.row === row && item.column === col);
    if (!deleteItem) {
      log.showWarn('deleteGridLayoutItemByPosition error with null deleteItem page %{public}d row %{public}d col %{public}d from %{public}s db %{public}s',
        page, row, col, label, isOperateDb);
      return;
    }
    log.showInfo('deleteGridLayoutItemByPosition with %{public}s page %{public}d row %{public}d col %{public}d from %{public}s db %{public}s',
      deleteItem.bundleName, page, row, col, label, isOperateDb);
    let filter = (item: GridLayoutItemInfo): boolean => item.page !== page || item.row !== row || item.column !== col;
    gridLayoutItemList = gridLayoutItemList.filter(filter);
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList);

    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.deleteGridLayoutItemByInfoIdCallBack(deleteItem.infoId, [deleteItem.page]);
      } catch (error) {
        log.showError('deleteGridLayoutItemByPosition with error %{public}s', error.message);
      }
    }
  }

  /**
   * 根据keyName删除应用
   *
   * @param keyName 应用的keyName
   * @param label 业务标识
   * @param isNeedOperationDb true需要数据库操作，false不需要
   */
  deleteAppItemByKeyName(keyName: string, label: string, isNeedOperationDb: boolean = true, isOuter?: boolean): void {
    log.showInfo('deleteAppItemByKeyName with keyname %{public}s from business %{public}s  db %{public}s',
      keyName, label, isNeedOperationDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    let deleteItem: GridLayoutItemInfo | undefined = gridLayoutItemList.find(item => item.keyName === keyName);
    if (!deleteItem) {
      log.showWarn('deleteAppItemByKeyName error with null deleteItem');
      return;
    }
    let filter = (item: GridLayoutItemInfo): boolean => item.keyName !== keyName;
    let newGridLayoutItemList: GridLayoutItemInfo[] = gridLayoutItemList.filter(filter);
    this.layoutCacheData.updateLayoutListCache(newGridLayoutItemList, isOuter);

    if (isNeedOperationDb) {
      try {
        LauncherLayoutCacheUtil.deleteGridLayoutItemByKeyNameCallBack(deleteItem);
      } catch (error) {
        log.showInfo('deleteAppItemByKeyName with error %{public}s', error.message);
      }
    }
  }

  /**
   * 过滤重复元素
   *
   * @param duplicateItem 重复的元素
   * @param label 业务标识
   * @param isOperateDb true需要数据库操作，false不需要
   * @param isOuter 是否是外屏
   */
  deleteDuplicateItemById(duplicateItem: GridLayoutItemInfo, label: string, isOperateDb: boolean = true,
    isOuter?: boolean): void {
    if (CheckEmptyUtils.isEmpty(duplicateItem)) {
      log.showWarn('deleteGridLayoutItemById error with null deleteItem');
      return;
    }
    log.showInfo('deleteGridLayoutItemById with id %{public}s from business %{public}s db %{public} isOuter %{public}s',
      String(duplicateItem.id), label, isOperateDb, isOuter);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    let newGridLayoutItemList: GridLayoutItemInfo[] = [];
    let isFirstFound: boolean = true;
    for (const item of gridLayoutItemList) {
      let isEqual: boolean = GridLayoutUtil.checkGridItemEqual(item, duplicateItem);
      if (duplicateItem.typeId === CommonConstants.TYPE_CARD) {
        if (isEqual && CheckEmptyUtils.checkStrIsEmpty(item.cardId) &&
        GridLayoutUtil.checkPositionAndAreaEqual(item, duplicateItem) && item.bundleName === duplicateItem.bundleName) {
          log.showInfo(`delete duplicate card, bundleName:${duplicateItem.bundleName}, cardId:${duplicateItem.cardId}, ` +
            `page:${duplicateItem.page}, row:${duplicateItem.row},column:${duplicateItem.column}, id:${item.id}`);
          continue;
        }
        if (isEqual && isFirstFound && item.bundleName === duplicateItem.bundleName) {
          newGridLayoutItemList.push(item);
          isFirstFound = false;
          continue;
        }
        if (isEqual && item.bundleName === duplicateItem.bundleName) {
          continue;
        }
      } else {
        if (isEqual && isFirstFound) {
          newGridLayoutItemList.push(item);
          isFirstFound = false;
          continue;
        }
        if (isEqual) {
          continue;
        }
      }
      newGridLayoutItemList.push(item);
    }
    this.layoutCacheData.updateLayoutListCache(newGridLayoutItemList, isOuter);
    if (isOperateDb) {
      try {
        // 目前isOperateDb都是false， 所以暂时不用处理竖屏缓存
        LauncherLayoutCacheUtil.deleteGridLayoutItemByInfoIdCallBack(duplicateItem.infoId, [duplicateItem.page],
          isOuter);
      } catch (error) {
        log.showError('deleteGridLayoutItemById with error %{public}s', error.message);
      }
    }
  }

  updateGridLayoutItemPositionById(updateItem: GridLayoutItemInfo, label: string, isOperateDb: boolean = true): void {
    if (CheckEmptyUtils.isEmpty(updateItem)) {
      log.showWarn('updateGridLayoutItemPositionById failure as the updateItem is null');
      return;
    }
    log.showInfo(`updateGridLayoutItemPositionById from id %{public}d %{public}s from %{public}s db %{public}s`,
      updateItem.id, updateItem.bundleName, label, isOperateDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    let selectItem: GridLayoutItemInfo | undefined = gridLayoutItemList.find(item =>
      GridLayoutUtil.checkGridItemEqual(item, updateItem));
    if (!selectItem) {
      log.showWarn('updateGridLayoutItemPositionById cannot find item. key: %{public}s',
        GridLayoutUtil.generateUniqueKey(updateItem));
      return;
    }
    selectItem.row = updateItem.row;
    selectItem.column = updateItem.column;
    selectItem.page = updateItem.page;
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList);

    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.updateItemToDesktopCallBack([updateItem]);
      } catch (error) {
        log.showError('updateGridLayoutItemPositionById with error %{public}s', error.message);
      }
    }
  }

  /**
   * 添加应用到缓存列表
   *
   * @param itemList 添加的应用列表
   * @param label 业务标识
   * @param isOperateDb true执行对应数据库操作，false不执行
   * @param isOuter 是否是外屏
   */
  public insertGridLayoutItemList(itemList: GridLayoutItemInfo[], label: string, isOperateDb: boolean = true,
    isOuter?: boolean): void {
    if (CheckEmptyUtils.isEmptyArr(itemList)) {
      log.showWarn('insertGridLayoutItemList with the empty list');
      return;
    }
    log.showInfo('insertGridLayoutItemList with size %{public}d, from %{public}s, db: %{public}s, isOuter: %{public}s',
      itemList.length, label, isOperateDb, isOuter);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    itemList = LauncherLayoutCacheUtil.updateListIfLazyRotateMode(itemList, gridLayoutItemList, 'insertGridLayoutItemList');
    if (CheckEmptyUtils.isEmptyArr(itemList)) {
      log.showWarn('insertGridLayoutItemList with the empty list after LazyRotateMode!');
      return;
    }
    gridLayoutItemList.push(...itemList);
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList, isOuter);
    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.updateItemToDesktopCallBack(itemList, isOuter);
      } catch (error) {
        log.showError('insertGridLayoutItemList with error %{public}s', error.message);
      }
    }
  }

  /**
   * 插入一个元素到布局中
   *
   * @param gridlayoutItem 新增的元素
   * @param label 业务标识
   * @param isOperateDb true需要数据库操作，false不需要
   * @param isOuter 是否是小外屏桌面
   * @returns 是否成功更新缓存
   */
  insertGridLayoutItemInfo(gridlayoutItem: GridLayoutItemInfo, label: string, isOperateDb: boolean = true,
    isOuter?: boolean, ctx?: SingleContext): boolean {
    if (CheckEmptyUtils.isEmpty(gridlayoutItem)) {
      log.showInfo('insertGridLayoutItemInfo failure as the null item');
      return false;
    }
    log.showInfo('insertGridLayoutItemInfo item bundleName %{public}s, from %{public}s db %{public}s',
      gridlayoutItem.bundleName, label, isOperateDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    if (!LauncherLayoutCacheUtil.getIsFirstRotate() || LauncherLayoutCacheUtil.getSuperFoldLazyRotate()) {
      if (!LauncherLayoutCacheUtil.findLazyRotatePosition(gridLayoutItemList, gridlayoutItem)) {
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_DESKTOP_CANT_ADD, null);
        log.showWarn('insertGridLayoutItemInfo not addable');
        return false;
      }
      const newItems: GridLayoutItemInfo[] = LauncherLayoutCacheUtil.getLazyRotateChangeItemsForCache([gridlayoutItem]);
      if (CheckEmptyUtils.isEmptyArr(newItems)) {
        log.showError('insertGridLayoutItemInfo array empty');
        return false;
      }
      gridlayoutItem = newItems[0];
    }
    gridLayoutItemList.push(gridlayoutItem);
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList, isOuter);
    LauncherLayoutCacheUtil.changeLazyRotateSettings(gridLayoutItemList);
    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.insertGridLayoutItemCallBack(gridlayoutItem, isOuter, ctx);
      } catch (error) {
        log.showError('updateOneAppLayoutInfo with error %{public}s', error.message);
      }
    }
    return true;
  }

  async insertGridLayoutItemInfoAsync(gridlayoutItem: GridLayoutItemInfo, label: string, isOperateDb: boolean = true,
    isOuter?: boolean, ctx?: SingleContext): Promise<void> {
    if (CheckEmptyUtils.isEmpty(gridlayoutItem)) {
      log.showInfo('insertGridLayoutItemInfo failure as the null item');
      return;
    }
    log.showInfo('insertGridLayoutItemInfo item bundleName %{public}s, from %{public}s db %{public}s',
      gridlayoutItem.bundleName, label, isOperateDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    gridlayoutItem = LauncherLayoutCacheUtil.updateListIfLazyRotateMode([gridlayoutItem], gridLayoutItemList, 'insertGridLayoutItemInfoAsync')[0];
    if (CheckEmptyUtils.isEmpty(gridlayoutItem)) {
      log.showInfo('insertGridLayoutItemInfo failure as the null item after LazyRotateMode!');
      return;
    }
    gridLayoutItemList.push(gridlayoutItem);
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList, isOuter);
    if (isOperateDb) {
      try {
        await LauncherLayoutCacheUtil.insertGridLayoutItemCallBack(gridlayoutItem, isOuter, ctx);
      } catch (error) {
        log.showError('updateOneAppLayoutInfo with error %{public}s', error.message);
      }
    }
  }

  /**
   * 插入文件夹到布局中
   *
   * @param gridlayoutItem 文件夹元素
   * @param label 业务标识
   * @param isOperateDb true需要数据库操作，false不需要
   */
  async insertFolderLayoutInfoAsync(gridlayoutItem: GridLayoutItemInfo, label: string, isOperateDb: boolean = true,
    isDeliverApp?: boolean): Promise<void> {
    if (CheckEmptyUtils.isEmpty(gridlayoutItem)) {
      log.showInfo('insertFolderLayoutInfoAsync failure as the null item');
      return;
    }
    log.showInfo('insertFolderLayoutInfoAsync item bundleName %{public}s, from %{public}s db %{public}s',
      gridlayoutItem.bundleName, label, isOperateDb);
    let deliverAppShowOuter: boolean | undefined = isDeliverApp ? false : undefined;
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(deliverAppShowOuter);
    gridlayoutItem = LauncherLayoutCacheUtil.updateListIfLazyRotateMode([gridlayoutItem], gridLayoutItemList, 'insertFolderLayoutInfoAsync')[0];
    if (CheckEmptyUtils.isEmpty(gridlayoutItem)) {
      log.showInfo('insertGridLayoutItemInfo failure as the null item after LazyRotateMode!');
      return;
    }
    gridLayoutItemList.push(gridlayoutItem);
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList, deliverAppShowOuter);
    if (isOperateDb) {
      try {
        gridlayoutItem.id = await LauncherLayoutCacheUtil.insertFolderLayoutInfo(gridlayoutItem);
      } catch (error) {
        log.showError('insertFolderLayoutInfoAsync with error %{public}s', error.message);
      }
    }
  }

  /**
   * 插入一个布局元素（写库时只写自身，不带layoutInfo内元素) （仅支持手机，pad)
   * @param item
   * @param label
   * @param isOperateDb 是否写库
   * @returns 写库后元素的id(行号), 没写库或者写库失败返回 -1
   */
  public async insertItemWithoutLayoutInfo(item: GridLayoutItemInfo, label: string, isOperateDb: boolean = true): Promise<number> {
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showInfo('insertItemWithoutLayoutInfo failure as the null item');
      return -1;
    }
    log.showWarn(`insertItemWithoutLayoutInfo bundleName ${item.bundleName}, by ${label} db ${isOperateDb}`);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    gridLayoutItemList.push(item);
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList);
    if (isOperateDb) {
      try {
        return LauncherLayoutCacheUtil.insertItemWithoutLayoutInfo(item);
      } catch (error) {
        log.showError('updateOneAppLayoutInfo with error %{public}s', error.message);
      }
    }
    return -1;
  }

  /**
   * 插入item到布局同时更新元素位置
   *
   * @param gridLayoutItem item信息
   * @param label 业务标识
   * @param isOperateDb true需要数据库操作，false不需要
   */
  insertGridLayoutItemAndUpdatePosition(gridLayoutItem: GridLayoutItemInfo, label: string, isOperateDb: boolean = true): void {
    if (CheckEmptyUtils.isEmpty(gridLayoutItem)) {
      log.showWarn('insertGridLayoutItemAndUpdatePosition failure as the null item');
      return;
    }
    log.showInfo('insertGridLayoutItemAndUpdatePosition item bundleName %{public}s, from %{public}s db %{public}s',
      gridLayoutItem.bundleName, label, isOperateDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    gridLayoutItemList.push(gridLayoutItem);
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList);
    if (isOperateDb) {
      try {
        LauncherLayoutCacheUtil.updateItemToDesktopCallBack([gridLayoutItem]);
      } catch (error) {
        log.showError('insertGridLayoutItemAndUpdatePosition with error %{public}s', error.message);
      }
    }
  }

  /**
   * 删除缓存中的空白页
   *
   * @param page 待删除页面
   * @param isOuter 是否外屏
   * @returns 是否删除成功
   */
  public deleteBlankPageFromLayoutInfo(page: number, isOuter?: boolean): boolean {
    // 如果是主屏不删除
    log.showInfo(`deleteBlankPageFromLayoutInfo, page>>> ${page}`);
    if (PageInfoManager.getInstance().isHomePage(page)) {
      log.showInfo(`deleteBlankPageFromLayoutInfo, page ${page} is home page`);
      return false;
    }
    if (DeviceHelper.isSuperFoldMachine()) {
      return false;
    }
    let pageCount: number = this.selectPageCount(isOuter);
    log.showInfo(`deleteBlankPageFromLayoutInfo, page:${page}, pageCount:${pageCount}`);
    if (page === CommonConstants.WATERFALL_PAGE_INDEX || pageCount <= page || page < 0) {
      return false;
    }

    if (!this.isBlankPage(page, isOuter)) {
      log.showInfo(`deleteBlankPage fail page: ${page}, nowPage has items`);
      return false;
    }

    let adaptivePage: number = PageInfoManager.getInstance().getDisplayCount();
    if (adaptivePage === StyleConstants.DEFAULT_3) {
      return this.deleteBlankPages(page, adaptivePage);
    }
    let pageDeleteCount: number = StyleConstants.DEFAULT_1;
    let pageAdjust: number = page;
    if (desktopUtil.isFoldExpandStatus() && !isOuter) {
      let neighborPage: number = EditModeUtils.getNeighborPage(page);
      if (!this.isBlankPage(neighborPage)) {
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
      this.updatePageCount(pageCount - pageDeleteCount, BusinessType.BUSINESS_BASIC_DESKTOP, true, isOuter);
    } else {
      log.showInfo(`deleteBlankPage fail, pageCount:${pageCount}, pageDeleteCount:${pageDeleteCount}`);
      return false;
    }
    log.showInfo(`deleteBlankPage success, page:${page}`);
    this.updateLayoutAfterDeletePage(pageAdjust, pageDeleteCount, BusinessType.BUSINESS_BASIC_DESKTOP, true, isOuter);
    const curPageIndex: number = desktopUtil.getPageIndexValue(isOuter);
    AppStorage.setOrCreate(desktopUtil.getPageIndex(), (curPageIndex > 0) ? (curPageIndex - 1) : curPageIndex);
    return true;
  }

  /**
   * 删除空白屏
   *
   * @param page 需要删除的page index
   * @param adaptivePage 当前屏显示的最大页数
   * @returns 是否需要删除
   */
  public deleteBlankPages(page: number, adaptivePage: number) : boolean {
    const pageIndex: number = Math.floor(page / adaptivePage) * adaptivePage;
    const pages: number[] = [];
    for (let i = 0; i < adaptivePage; i++) {
      pages.push(pageIndex + i);
    }
    let isBlank: boolean = true;
    for (let i = 0; i < adaptivePage; i++) {
      isBlank = isBlank && this.isBlankPage(pages[i]);
    }
    if (isBlank) {
      const pageCount = this.selectPageCount(false);
      this.updatePageCount(pageCount - adaptivePage, BusinessType.BUSINESS_BASIC_DESKTOP, true, false);
      this.updateLayoutAfterDeletePages(pages, 'deleteBlankPageFromLayoutInfo', true);
      SwiperLoadManager.getInstance().hardCodeDeleteBlankPageMiddle(pageIndex, adaptivePage);
    }
    return isBlank;
  }

  /**
   * 更新的页数
   *
   * @param pageCount 设置的新页数
   * @param label 业务标识
   * @param isNeedOperationDb true需要数据库操作，false不需要
   */
  updatePageCount(pageCount: number, label: string, isNeedOperationDb: boolean = true, isOuter?: boolean): void {
    log.showInfo('updatePageCount with pageCount %{public}d from %{public}s , db %{public}s', pageCount, label, isNeedOperationDb);
    if (pageCount <= 0) {
      log.showWarn('cannot update pageCount to zero');
      return;
    }
    const isOuterDesktop = (isOuter === undefined || isOuter === null) ?
      launcherStatusUtil.getShowOutLauncherStatus() : isOuter;
    PageInfoManager.getInstance().updatePageCount(pageCount, 'updatePageCount', isOuterDesktop);
    let gridLayoutInfo: DefaultDesktopLayoutInfo = this.layoutCacheData.getGridLayoutInfo(isOuter);
    if (gridLayoutInfo.layoutDescription) {
      gridLayoutInfo.layoutDescription.pageCount = pageCount;
    }
    this.layoutCacheData.setGridLayoutInfo(gridLayoutInfo, isOuter);
    if (this.layoutCacheData.isPad()) {
      let rotateLayout = this.layoutCacheData.getRotateLayout();
      if (rotateLayout && rotateLayout.layoutDescription) {
        rotateLayout.layoutDescription.pageCount = pageCount;
      }
    }
    if (isNeedOperationDb) {
      try {
        LauncherLayoutCacheUtil.updatePageCountCallBack(pageCount, isOuter);
      } catch (error) {
        log.showError('updatePageCount with error %{public}s', error.message);
      }
    }
  }

  private updateGridLayoutAfterDeletePages(gridLayoutItemList: GridLayoutItemInfo[], blankPages: number[]): GridLayoutItemInfo[] {
    let changeItem: GridLayoutItemInfo[] = [];
    for (let m = 0; m < gridLayoutItemList.length; m++) {
      let pageMinus: number = 0;
      let mPage = gridLayoutItemList[m].page;
      if (mPage === undefined) {
        continue;
      }
      for (let n = 0; n < blankPages.length; n++) {
        if (mPage > blankPages[n]) {
          pageMinus++;
        }
      }
      if (pageMinus !== 0) {
        gridLayoutItemList[m].page = mPage - pageMinus;
        gridLayoutItemList[m].portraitPage = gridLayoutItemList[m].page;
        gridLayoutItemList[m].landscapePage = gridLayoutItemList[m].page;
        changeItem.push(gridLayoutItemList[m]);
      }
    }
    return changeItem;
  }

  /**
   * 删除多张空白页后更新布局
   *
   * @param blankPages 删除的空白页列表
   * @param label 业务标识
   * @param isNeedOperationDb true需要数据库操作，false不需要
   */
  public updateLayoutAfterDeletePages(blankPages: number[], label: string, isNeedOperationDb: boolean = true): void {
    log.showInfo('updateLayoutAfterDeletePages from %{public}s db %{public}s', label, isNeedOperationDb);
    if (CheckEmptyUtils.isEmptyArr(blankPages)) {
      log.showWarn('updateLayoutAfterDeletePages as null blankPages');
      return;
    }
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(false);
    let changeItem: GridLayoutItemInfo[] = this.updateGridLayoutAfterDeletePages(gridLayoutItemList, blankPages);
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList, false);
    if (changeItem.length !== 0 && isNeedOperationDb) {
      try {
        LauncherLayoutCacheUtil.patchUpdateGridLayoutPositionCallBack(changeItem, false);
      } catch (error) {
        log.showError('updateLayoutAfterDeletePages with error %{public}s', error.message);
      }
    }
  }

  private updateGridLayoutAfterAddPage(gridLayoutItemList: GridLayoutItemInfo[], changeItems: GridLayoutItemInfo[],
    pageAddIndex: number, pageAddNum: number): PageUpdateItem {
    let maxPage: number = 0;
    for (let index = 0; index < gridLayoutItemList.length; index++) {
      let mPage = gridLayoutItemList[index].page;
      if (mPage === undefined) {
        continue;
      }
      if (mPage > maxPage) {
        maxPage = mPage;
      }
      if (mPage > pageAddIndex) {
        changeItems.push(gridLayoutItemList[index]);
        gridLayoutItemList[index].page = mPage + pageAddNum;
        gridLayoutItemList[index].portraitPage = gridLayoutItemList[index].page;
        gridLayoutItemList[index].landscapePage = gridLayoutItemList[index].page;
      }
    }
    return LauncherLayoutCacheUtil.buildPageUpdateItem(pageAddIndex + 1, maxPage, pageAddNum);
  }

  /**
   * 新增一页后更新布局
   *
   * @param pageAddIndex 新增页数位置
   * @param pageAddNum 新增多少也
   * @param label 业务标识
   * @param isOperateDb true需要数据库操作，false不需要
   * @param isSwiperToNewPage 添加后是否滑动到新页
   * @param updateItem 按页更新完后重新刷新增item的页数信息
   */
  public updateLayoutAfterAddPage(pageAddIndex: number, pageAddNum: number, label: string, isOperateDb: boolean = true,
    isSwiperToNewPage: boolean = true, updateItems?: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    log.showInfo('updateLayoutAfterAddPage pageIndex %{public}d, pageAddNum %{public}d from %{public}s db %{public}s',
      pageAddIndex, pageAddNum, label, isOperateDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    let changeItem: GridLayoutItemInfo[] = [];
    let pageUpdateItem: PageUpdateItem = this.updateGridLayoutAfterAddPage(gridLayoutItemList, changeItem,
      pageAddIndex, pageAddNum);
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList);
    if (this.layoutCacheData.isPad()) {
      let rotateList: GridLayoutItemInfo[] = this.layoutCacheData.getRotateLayoutInfo();
      // 更新旋转后的页数
      this.updateGridLayoutAfterAddPage(rotateList, [], pageAddIndex, pageAddNum);
    }

    if (isOperateDb && changeItem.length > 0) {
      try {
        LauncherLayoutCacheUtil.patchUpdateGridLayoutPages([pageUpdateItem], updateItems);
      } catch (error) {
        log.showError('updateLayoutAfterAddPage with error %{public}s', error.message);
      }
    }
    SwiperLoadManager.getInstance(launcherStatusUtil.getShowOutLauncherStatus())
      .hardCodeAddPageToMiddle(pageAddIndex, pageAddNum, isSwiperToNewPage);
    if (LauncherLayoutCacheUtil.getIsPadPortrait()) {
      // 加页业务的设备，默认是横屏缓存，需要changeItemsIfPortrait
      return LauncherLayoutCacheUtil.changeItemsIfPortrait(changeItem);
    }
    return changeItem;
  }

  private updateGridLayoutAfterDeletePage(gridLayoutItemList: GridLayoutItemInfo[], pageDeleteIndex: number,
    pageDeleteNum: number): GridLayoutItemInfo[] {
    const updateInfo: GridLayoutItemInfo[] = [];
    for (let m = 0; m < gridLayoutItemList.length; m++) {
      let mPage = gridLayoutItemList[m].page;
      if (mPage === undefined) {
        continue;
      }
      if (mPage > pageDeleteIndex) {
        gridLayoutItemList[m].page = mPage - pageDeleteNum;
        gridLayoutItemList[m].landscapePage = gridLayoutItemList[m].page;
        gridLayoutItemList[m].portraitPage = gridLayoutItemList[m].page;
        updateInfo.push(gridLayoutItemList[m]);
      }
    }
    return updateInfo;
  }

  /**
   * 删除空白页后更新布局
   *
   * @param pageDeleteIndex 删除的空白页起始index
   * @param pageDeleteNum 删除的数量 1-非折叠机展开态（直板机、平板）， 2-折叠机展开态
   * @param label 业务标识
   * @param isNeedOperationDb true需要数据库操作，false不需要
   */
  public updateLayoutAfterDeletePage(pageDeleteIndex: number, pageDeleteNum: number, label: string,
    isNeedOperationDb: boolean = true, isOuter?: boolean): void {
    log.showInfo('updateLayoutAfterDeletePage as pageDeleteIndex: %{public}d, pageDeleteNum: %{public}d from label %{public}s db %{public}s',
      pageDeleteIndex, pageDeleteNum, label, isNeedOperationDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    // 更新缓存中图标的page信息时，要从被删除的最后一页空白页开始向后更新
    const pageAdjustIndex: number = pageDeleteIndex + pageDeleteNum - 1;
    const updateInfo = this.updateGridLayoutAfterDeletePage(gridLayoutItemList, pageAdjustIndex, pageDeleteNum);
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList, isOuter);
    if (isNeedOperationDb) {
      try {
        LauncherLayoutCacheUtil.patchUpdateGridLayoutPositionCallBack(updateInfo, isOuter);
      } catch (error) {
        log.showError('updateLayoutAfterDeletePage with error %{public}s', error.message);
      }
    }
    SwiperLoadManager.getInstance(isOuter === undefined ? launcherStatusUtil.getShowOutLauncherStatus() : isOuter)
      .hardCodeDeleteBlankPageMiddle(pageDeleteIndex, pageDeleteNum);
  }

  /**
   * 拖拽页面后更新布局
   *
   * @param startDragPageIndex 拖拽的起始页index
   * @param endDragPageIndex 拖拽的起始页index
   * @param label 业务标识
   * @param isNeedOperationDb true需要数据库操作，false不需要
   */
  public updateLayoutAfterDragPage(startDragPageIndex: number, endDragPageIndex: number, label: string,
    isNeedOperationDb: boolean = true, isOuter?: boolean): void {
    log.showInfo('updateLayoutAfterDragPage as startDragPageIndex: %{public}d, endDragPageIndex: %{public}d from label %{public}s db %{public}s',
      startDragPageIndex, endDragPageIndex, label, isNeedOperationDb);
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList(isOuter);
    // 更新缓存中图标的page信息时，要从拖拽页到落位页，更新中间的全部元素图标信息
    const currentDisplayCount: number = PageInfoManager.getInstance().getDisplayCount();
    const updateInfo = this.updateGridLayoutAfterDragPage(gridLayoutItemList, startDragPageIndex, endDragPageIndex, currentDisplayCount);
    this.layoutCacheData.updateLayoutListCache(gridLayoutItemList, isOuter);
    if (this.layoutCacheData.isPad()) {
      let rotateList: GridLayoutItemInfo[] = this.layoutCacheData.getRotateLayoutInfo();
      // 更新旋转后的页数
      this.updateGridLayoutAfterDragPage(rotateList, startDragPageIndex, endDragPageIndex, currentDisplayCount);
    }
    if (isNeedOperationDb) {
      try {
        LauncherLayoutCacheUtil.patchUpdateGridLayoutPositionCallBack(updateInfo, isOuter);
      } catch (error) {
        log.showError('updateLayoutAfterDeletePage with error %{public}s', error.message);
      }
    }
    SwiperLoadManager.getInstance(launcherStatusUtil.getShowOutLauncherStatus())
      .hardCodeDragPage(startDragPageIndex, endDragPageIndex, currentDisplayCount);
  }

  /**
   * 拖拽页面后更新缓存
   *
   * @param startDragPageIndex 拖拽的起始页index
   * @param endDragPageIndex 拖拽的起始页index
   * @param gridLayoutItemList 缓存
   * @param isFold 是否为折叠屏
   */
  private updateGridLayoutAfterDragPage(
    gridLayoutItemList: GridLayoutItemInfo[],
    startDragPageIndex: number,
    endDragPageIndex: number,
    pageStep: number
  ): GridLayoutItemInfo[] {
    const updateInfo: GridLayoutItemInfo[] = [];
    if (startDragPageIndex === endDragPageIndex) {
      return gridLayoutItemList;
    } else if (startDragPageIndex > endDragPageIndex) {
      // 从后往前拖
      for (let m = 0; m < gridLayoutItemList.length; m++) {
        let mPage = gridLayoutItemList[m].page;
        if (mPage === undefined) {
          continue;
        }
        if (mPage >= endDragPageIndex && mPage < startDragPageIndex) {
          // 从落位页开始，位于中间的页面将加上pageStep，pad场景需要同步更新对应旋转屏字段
          gridLayoutItemList[m].page = mPage + pageStep;
          gridLayoutItemList[m].portraitPage = gridLayoutItemList[m].page;
          gridLayoutItemList[m].landscapePage = gridLayoutItemList[m].page;
          updateInfo.push(gridLayoutItemList[m]);
        } else if (
          (mPage - startDragPageIndex) + endDragPageIndex >= 0 &&
            mPage >= startDragPageIndex &&
            mPage < startDragPageIndex + pageStep
        ) {
          // 拖拽页自身要变为落位页的index，pad场景需要同步更新对应旋转屏字段
          gridLayoutItemList[m].page = (mPage - startDragPageIndex) + endDragPageIndex;
          gridLayoutItemList[m].portraitPage = gridLayoutItemList[m].page;
          gridLayoutItemList[m].landscapePage = gridLayoutItemList[m].page;
          updateInfo.push(gridLayoutItemList[m]);
        }
      }
    } else {
      // 从前往后拖
      for (let m = 0; m < gridLayoutItemList.length; m++) {
        let mPage = gridLayoutItemList[m].page;
        if (mPage === undefined) {
          continue;
        }
        // 确保更新后的page大于等于0，避免错误写库带来的不可恢复的页面问题
        if (
          mPage - pageStep >= 0 && mPage >= startDragPageIndex + pageStep && mPage < endDragPageIndex + pageStep
        ) {
          // 从起拖页的后一页开始，位于中间的页面将减去pageStep，pad场景需要同步更新对应旋转屏字段
          gridLayoutItemList[m].page = mPage - pageStep;
          gridLayoutItemList[m].portraitPage = gridLayoutItemList[m].page;
          gridLayoutItemList[m].landscapePage = gridLayoutItemList[m].page;
          updateInfo.push(gridLayoutItemList[m]);
        } else if (
          (mPage - startDragPageIndex) + endDragPageIndex >= 0 &&
            mPage >= startDragPageIndex &&
            mPage < startDragPageIndex + pageStep
        ) {
          // 拖拽页自身要变为落位页的index，pad场景需要同步更新对应旋转屏字段
          gridLayoutItemList[m].page = (mPage - startDragPageIndex) + endDragPageIndex;
          gridLayoutItemList[m].portraitPage = gridLayoutItemList[m].page;
          gridLayoutItemList[m].landscapePage = gridLayoutItemList[m].page;
          updateInfo.push(gridLayoutItemList[m]);
        }
      }
    }
    return updateInfo;
  }

  public updateLayoutListCacheAndPrebuild(gridLayoutList: GridLayoutItemInfo[], isOuter?: boolean): void {
    return this.layoutCacheData.updateLayoutListCacheAndPrebuild(gridLayoutList, isOuter);
  }

  public updateInfoToRdb(updateInfoItems: GridLayoutItemInfo[], msg: string, ctx?: SingleContext): void {
    if (ArrayUtils.isEmpty(updateInfoItems)) {
      log.showWarn('updateInfoToRdb update size is 0 by %{public}s', msg);
      return;
    }
    log.showInfo('updateInfoToRdb update size: %{public}d by %{public}s', updateInfoItems.length, msg);
    let desktopItems: GridLayoutItemInfo[] = [];
    let otherItems: GridLayoutItemInfo[] = [];
    updateInfoItems.forEach(item => {
      if (item.container === CommonConstants.CONTAINER_DESKTOP) {
        desktopItems.push(item);
      } else {
        otherItems.push(item);
      }
    });
    log.showInfo('updateInfoToRdb desktop item size: %{public}d, other item size: %{public}d',
      desktopItems.length, otherItems.length);
    let targetItems: GridLayoutItemInfo[] = LauncherLayoutCacheUtil.getChangeItems(desktopItems);
    if (targetItems.length !== 0) {
      desktopItems = targetItems;
    }
    desktopItems.push(...otherItems);
    RdbStoreManager.getInstance().updateAllInfoPosition(desktopItems, ctx);
  }

  /**
   * 当操作了一屏上的某一页并使这一整屏成为空白页时，取消同一屏上其余空白页的保护，保证此页可被正常删除
   *
   * @param changedPageSet 操作了哪些页
   * @param cacheList 元素分页数组
   * @param isOuter 是否外屏
   * */
  private cancelProtectWhenHandleLastPage(
    changedPageSet: Set<number>,
    cacheList: Array<GridLayoutItemInfo[]>,
    isOuter?: boolean
  ): void {
    const currentDisplayCount = PageInfoManager.getInstance().getDisplayCount();
    const changePageArray = Array.from(changedPageSet);
    for (let i = 0; i < changedPageSet.size; i++) {
      if (changePageArray[i] == null) {
        log.showWarn(`changedPageSet[${i}] is undefined`);
        continue;
      }
      const neighborPage: number[] = EditModeUtils.getCurrentShowingPage(changePageArray[i], currentDisplayCount);
      let pageHasIcon: boolean = false;
      for (let j = 0; j < neighborPage.length; j++) {
        if (cacheList[neighborPage[j]].length !== 0) {
          pageHasIcon = true;
        }
      }
      if (!pageHasIcon) {
        this.reSetBlankPageStatus(neighborPage, isOuter);
      }
    }
  }

  private reSetBlankPageStatus(neighborPage: number[], isOuter?: boolean): void {
    const pages = SwiperLoadData.getInstance().getPages();
    const blankPageList: Map<number, boolean> = PageInfoManager.getInstance().getBlankPageList(isOuter);
    for (let i = 0; i < neighborPage.length; i++) {
      if (blankPageList.get(pages[neighborPage[i]])) {
        blankPageList.set(pages[neighborPage[i]], false);
      }
    }
  }

  public deleteBlankPageByCache(changedPageSet: Set<number>, isOuter?: boolean): GridLayoutItemInfo[] {
    const updateInfo: GridLayoutItemInfo[] = [];
    const pageCount: number = this.selectPageCount();
    log.showInfo(`before delete blankpage, pageCount is ${pageCount}`);
    const cacheList: Array<GridLayoutItemInfo[]> = [];
    for (let i = 0; i < pageCount; i++) {
      cacheList.push([]);
    }
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutItemList();
    gridLayoutItemList.forEach(item => {
      if (item.page != null && item.page < pageCount) {
        cacheList[item.page].push(item);
      } else {
        log.showWarn(`${item.bundleName}'s page ${item.page} is undefined or beyound pageCount`);
        return;
      }
    });
    log.showInfo(`origin changedPageSet is ${Array.from(changedPageSet)}`);
    if (cacheList.length > 0) {
      this.cancelProtectWhenHandleLastPage(changedPageSet, cacheList, isOuter);
    }
    changedPageSet.add(pageCount - 1);
    let blankPages: number[] = [];
    let isFolder: boolean = DeviceHelper.isSuperFoldMachine() || desktopUtil.isFoldExpandStatus();
    let adaptivePage: number = PageInfoManager.getInstance().getDisplayCount();
    log.showInfo(`deleteBlankPageByCache ${Array.from(changedPageSet)} adaptivePage ${adaptivePage}`);
    let indexChanges: number[] = this.initIndexChanges(cacheList, isFolder, blankPages, adaptivePage, changedPageSet, isOuter);
    let deletePage: number = indexChanges[indexChanges.length - 1];
    if (deletePage === 0) {
      log.showInfo('Cache not have blank page');
      return [];
    }
    log.showInfo('pageCount is %{public}d, delete page: %{public}d', pageCount, deletePage);
    if (pageCount > deletePage) {
      this.updatePageCount(pageCount - deletePage, BusinessType.BUSINESS_BASIC_DESKTOP, true);
    } else {
      log.showInfo('deleteBlankPage fail, pageCount:%{public}d, pageDeleteCount:%{public}d', pageCount, deletePage);
      return [];
    }

    for (let i = blankPages.length - 1; i >= 0; i--) {
      if (blankPages[i] === adaptivePage) {
        SwiperLoadManager.getInstance(false)
          .hardCodeDeleteBlankPageMiddle(i, adaptivePage);
      }
    }

    let currentIndex: number = desktopUtil.getPageIndexValue();
    const currentPageIndex = Math.floor(currentIndex / adaptivePage) * adaptivePage;
    const newPageIndex = Math.max(currentPageIndex - indexChanges[currentIndex] ?? 0, 0);
    AppStorage.setOrCreate(desktopUtil.getPageIndex(), newPageIndex);
    log.showInfo('deleteBlankPage pageIndex from %{public}d to  %{public}d', currentPageIndex, newPageIndex);

    for (let i = 0; i < pageCount; i++) {
      if (cacheList[i].length === 0 || indexChanges[i] === 0) {
        log.showInfo('delete blankPage pageIndex: %{public}d not change', i);
        continue;
      }
      log.showInfo('delete blankPage pageIndex: %{public}d change to %{public}d', i, i - indexChanges[i]);
      cacheList[i].forEach(item => {
        if (item.page === undefined) {
          return;
        }
        item.page = item.page - indexChanges[i];
        item.portraitPage = item.page;
        item.landscapePage = item.page;
        updateInfo.push(item);
      });
    }
    return updateInfo;
  }

  /**
   * 拖拽页面后更新缓存
   *
   * @param return 是否为外屏
   */
  public isOuterDesktop(): boolean {
    return false;
  }

  /**
   * 判断当前页是否是手动添加的空白页
   *
   * @param pages: 当前页面
   * @param index: 要判断的页面
   * @param blankPageList: 缓存中记录的空白页信息
   * @returns 当前页是否是手动添加的空白页
   */
  private isCurrentBlankPageIsAdded(pages: number[], index: number, blankPageList: Map<number, boolean>): boolean {
    let currentDisplayCount = PageInfoManager.getInstance().getDisplayCount();
    let neighborPage: number[] = EditModeUtils.getCurrentShowingPage(index, currentDisplayCount);
    for (let i = 0; i < currentDisplayCount; i++) {
      if (blankPageList.get(pages[neighborPage[i]])) {
        return true;
      }
    }
    return false;
  }

  /**
   * 判断当前页是否是手动添加的空白页
   *
   * @param index: 要判断的页面
   * @returns 当前页是否是手动添加的空白页
   */
  public isBlankPageAddedByEditMode(index: number, isOuter: boolean): boolean {
    let pages = SwiperLoadData.getInstance().getPages();
    const blankPageList: Map<number, boolean> = PageInfoManager.getInstance().getBlankPageList(isOuter);
    let currentDisplayCount = PageInfoManager.getInstance().getDisplayCount();
    let neighborPage: number[] = EditModeUtils.getCurrentShowingPage(index, currentDisplayCount);
    for (let i = 0; i < currentDisplayCount; i++) {
      if (blankPageList.get(pages[neighborPage[i]])) {
        return true;
      }
    }
    return false;
  }

  private initIndexChanges(cacheList: Array<GridLayoutItemInfo[]>, isFolder: boolean, blankPages: number[],
    adaptivePage: number, changedPageSet: Set<number>, isOuter?: boolean): number[] {
    if (cacheList.length === 0) {
      return [0];
    }
    let change: number = 0;
    let indexChanges: number[] = [];
    const pageCount: number = this.selectPageCount();
    const blankPageList: Map<number, boolean> = PageInfoManager.getInstance().getBlankPageList(isOuter);
    // 将index替换为准确的swiperKey，保证过滤是准确的
    let pages = SwiperLoadData.getInstance().getPages();
    let changePage = new Set<number>();
    let currentDisplayCount = PageInfoManager.getInstance().getDisplayCount();
    for (let i = 0; i < Array.from(changedPageSet).length; i++) {
      let neighborPage: number[] = EditModeUtils.getCurrentShowingPage(Array.from(changedPageSet)[i], currentDisplayCount);
      for (let j = 0; j < neighborPage.length; j++) {
        changePage.add(neighborPage[j]);
      }
    }
    log.showInfo(`blankPageList ${Array.from(blankPageList.keys())} ${Array.from(blankPageList.values())}, pages ${pages} changedPageSet ${Array.from(changedPageSet)} changePage ${Array.from(changePage)}`);
    if (isFolder) {
      for (let i = 0; i < pageCount; i = i + adaptivePage) {
        let isBlankAppListPage = true;
        for (let j = 0; j < adaptivePage; j++) {
          // 主屏不当空白屏删除
          isBlankAppListPage =
            isBlankAppListPage && (cacheList[i + j].length === 0) && !PageInfoManager.getInstance().isHomePage(i + j);
        }
        if (isBlankAppListPage && changePage.has(i) && !this.isCurrentBlankPageIsAdded(pages, i, blankPageList)) {
          change = change + adaptivePage;
          blankPages[i] = adaptivePage;
        }
        for (let j = 0; j < adaptivePage; j++) {
          indexChanges[i + j] = change;
        }
      }
    } else {
      for (let i = 0; i < pageCount; i++) {
        if (cacheList[i].length === 0 && changedPageSet.has(i) &&
          // 主屏不当空白屏删除
          !this.isCurrentBlankPageIsAdded(pages, i, blankPageList) && !PageInfoManager.getInstance().isHomePage(i)
        ) {
          change = change + adaptivePage;
          blankPages[i] = adaptivePage;
        }
        indexChanges[i] = change;
      }
    }
    return indexChanges;
  }
}