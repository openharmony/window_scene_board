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

import { CheckEmptyUtils, CommonUtils, LogDomain, Logger } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { NumberConstants } from '@ohos/commonconstants';
import { ObjectCopyUtil, desktopUtil } from '@ohos/componenthelper';
import { FolderReporter } from '../folder/FolderReporter';
import type GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { BaseTransferBean } from './BaseTransferBean';
import ScreenTransferBean from './ScreenTransferBean';
import { RdbStoreManager } from '../db/RdbStoreManager';
import { AppStatus, CommonConstants } from '../constants/CommonConstants';
import DefaultDesktopLayoutInfo from '../configs/DefaultDesktopLayoutInfo';
import { AppReserveType, BlankPageTransFormItem, DeliverUtil, GridLayoutUtil } from '../TsIndex';
import { NotHarmonyUtil, NOT_HARMONY_FOLDERNAME } from '../utils/NotHarmonyUtil';
import DataConvert from './DataConvert';
import { LogBatchPrint } from './dfx/LogBatchPrint';
import { DELIVER_FOLDERNAME, ABROAD_APP_FOLDERNAME } from '../utils/DeliverUtil';

const TAG = 'BaseTransferLayoutManager';
const log: Logger = Logger.getLogHelper(LogDomain.BACKUP);
const MAX_FOLDER_COLUMN_COUNT: number = 3;
const MAX_FOLDER_ROW_COUNT: number = 4;
const INITIAL_PAGE_OF_NEW_SCREEN: number = 2;
const PRINT_BATCH_NUMBER: number = 20;
const ONEMULFOURCLOCKWEATHERCARD: string = 'OneMulFourClockCard'

export class BaseTransferLayoutManager {
  // 旧布局的行列数
  public fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
  // 新布局的行列数
  public toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
  // 存放所有旧布局元素，key为屏数，value为每一屏的所有元素
  public screenDataMap: Map<number, ScreenTransferBean> = new Map();
  public maxScreen: number = 0;
  public dockList: BaseTransferBean[] = [];
  // 存放未鸿蒙化的元素
  public notHarmonyList: BaseTransferBean[] = [];
  // 存放可进入克隆应用文件夹的元素
  public deliverTongList: BaseTransferBean[] = [];
  // 存放应用应用
  public easyAbroadList: BaseTransferBean[] = [];
  // 布局的最大屏数
  public maxScreenCount: number = DefaultDesktopLayoutInfo.getDefaultLayoutInfo().layoutDescription.maxPage;
  public newSmallerCount: number = 0;
  public folderNamesCountArr: number[] = [];
  public defaultFolderName: string = '${new_folder_name}';
  // 只有第一个天气Widget需要考虑上下挤位和焕新首屏替换
  public isFirstWidgetProcessed: boolean = false;
  public isBigFold: boolean = DeviceHelper.isFoldButNotSmallFoldAndSingleDisplay();
  // 新桌面布局中的卡片信息集合
  public newLayoutCardItems: GridLayoutItemInfo[] = [];
  public curTimeSecond: number = new Date().getTime();
  // 在旧机屏最后新增屏,用于放置其余旧机屏及新机特有元素
  public addLastScrean: BaseTransferBean[] = [];

  constructor(fromGrid: number[], toGrid: number[]) {
    this.fromGrid = fromGrid;
    this.toGrid = toGrid;
  }

  /**
   * 将旧桌面布局根据用户选择的方案转换成新桌面布局，并更新数据库
   *
   * @param oldLayoutInfo 旧布局信息
   * @param type {BackupSceneBundleVersionName} 备份恢复类型
   * @returns
   */
  public async transferLayout(oldLayoutInfo: GridLayoutItemInfo [], isOuter?: boolean): Promise<boolean> {
    try {
      log.showWarn(TAG, 'transferData start, oldLayoutLength=%{public}d, isOuter=%{public}s', oldLayoutInfo.length, isOuter);
      await this.collectOldLayoutByScreen(oldLayoutInfo);
      let newLayoutInfo: GridLayoutItemInfo [] = this.transferOldLayoutToNewLayout();
      await this.insertNewLayoutToDb(newLayoutInfo, isOuter);
      log.showInfo(TAG, 'transferData end');
      return true;
    } catch (error) {
      log.showError(TAG, `transferData error message ${error?.message}  ${error?.stack}`);
      return false;
    }
  }

  private refreshLayout(layout: Map<number, ScreenTransferBean>): Map<number, ScreenTransferBean> {
    for (let i = 0; i < layout.size; i++) {
      let currentPage: ScreenTransferBean | undefined = layout.get(i);
      if (currentPage && currentPage.moveToNextPage.length > 0) {
        layout.set(i, this.dealWithExceedElement(currentPage));
      }
    }
    return layout;
  }

  /**
   * 处理满18屏场景,特殊应用与普通应用分开处理,防止合并进入同一个文件夹
   *
   * @param currentPage 当前页元素
   * @returns 返回处理后的
   */
  private dealWithExceedElement(currentPage: ScreenTransferBean): ScreenTransferBean {
    // 过滤出特殊文件夹，特殊文件夹需重新找位
    let notHamonyFolderItem: BaseTransferBean[] = [];
    let deliverTongFolderItem: BaseTransferBean[] = [];
    let easyAbroadFolderItem: BaseTransferBean[] = [];
    let notSpecialItem: BaseTransferBean[] = currentPage.moveToNextPage.filter(item => {
      if (item.typeId !== CommonConstants.TYPE_FOLDER) {
        return true;
      } else if (DeliverUtil.checkFolderbyInstallSource(item) && item.layoutInfo) {
        item.layoutInfo[0].forEach(folderApp => {
          let icon: BaseTransferBean = ObjectCopyUtil.simpleClone(folderApp) as BaseTransferBean;
          icon.layoutWeight = 0;
          notHamonyFolderItem.push(icon);
        });
        return false;
      } else if (DeliverUtil.checkFolderbyInstallSource(item, DeliverUtil.DELIVER_APPSTORE_PKG)  && item.layoutInfo) {
        item.layoutInfo[0].forEach(folderApp => {
          let icon: BaseTransferBean = ObjectCopyUtil.simpleClone(folderApp) as BaseTransferBean;
          icon.layoutWeight = 0;
          deliverTongFolderItem.push(icon);
        });
        return false;
      } else if (DeliverUtil.checkFolderbyInstallSource(item, DeliverUtil.ABROAD_APP_PKG) && item.layoutInfo) {
        item.layoutInfo[0].forEach(folderApp => {
          let icon: BaseTransferBean = ObjectCopyUtil.simpleClone(folderApp) as BaseTransferBean;
          icon.layoutWeight = 0;
          easyAbroadFolderItem.push(icon);
        });
        return false;
      }
      // 剩余是普通文件夹需要收集
      return true;
    });
    // 处理非特殊应用文件夹
    if (notSpecialItem) {
      currentPage.moveToNextPage = notSpecialItem;
      this.makeRestElementFolderToCurrentPage(currentPage, currentPage.occupied);
    }
    // 处理未鸿蒙化应用
    if (notHamonyFolderItem.length !== 0) {
      this.makeRestElementFolderToCurrentPage(currentPage, currentPage.occupied, notHamonyFolderItem, true);
    }
    // 处理克隆应用应用
    if (deliverTongFolderItem.length !== 0) {
      this.makeRestElementFolderToCurrentPage(currentPage, currentPage.occupied, deliverTongFolderItem, true);
    }
    // 处理应用
    if (easyAbroadFolderItem.length !== 0) {
      this.makeRestElementFolderToCurrentPage(currentPage, currentPage.occupied, easyAbroadFolderItem, true);
    }
    return currentPage;
  }

  private createNewScreen(moveItems: BaseTransferBean[], currentPage: number): ScreenTransferBean {
    let newScreen: ScreenTransferBean = new ScreenTransferBean();
    newScreen.page = currentPage;
    this.fillOccupied(newScreen.occupied, false);
    let currentPageElements: number[] = [];
    for (let i = 0; i < moveItems.length; i++) {
      let item: BaseTransferBean = moveItems[i];
      // 找位，如果最小元素找位失败，则停止找位
      if (this.findAndUpdatePosition(item, newScreen)) {
        newScreen.children.push(item);
        currentPageElements.push(i);
        if (!item.area) {
          continue;
        }
        switch (item.typeId) {
          case CommonConstants.TYPE_CARD:
          case CommonConstants.TYPE_FORM_STACK:
            newScreen.abilityFormUsedCellCnt =
              newScreen.abilityFormUsedCellCnt + item.area[0] * item.area[1];
            break;
          case CommonConstants.TYPE_FOLDER:
            newScreen.folderUsedCellCnt = newScreen.folderUsedCellCnt + item.area[0] * item.area[1];
            break;
          case CommonConstants.TYPE_SHORTCUT_ICON:
          case CommonConstants.TYPE_APP:
            newScreen.iconUsedCellCnt = newScreen.iconUsedCellCnt + item.area[0] * item.area[1];
            break;
          default:
            log.showWarn(TAG, `currentPageElements type:${item.typeId} key:${item.keyName}`);
            break;
        }
        newScreen.usedCellCnt = newScreen.usedCellCnt + item.area[0] * item.area[1];
      } else if (moveItems[i].area?.[0] === 1 && moveItems[i].area?.[1] === 1) {
        break;
      }
    }
    // 当前已找到位置的元素从抽离列表移除
    let temp: number | undefined = currentPageElements.pop();
    while (temp !== undefined && temp >= 0) {
      moveItems.splice(temp, 1);
      temp = currentPageElements.pop();
    }
    log.showInfo(TAG, `create new screen page:${newScreen.page} cnt:${newScreen.children.length}`);
    return newScreen;
  }

  private findAndUpdatePosition(item: BaseTransferBean, newPage: ScreenTransferBean): boolean {
    if (!item.area) {
      return false;
    }
    if (item.area[0] > this.toGrid[0] || item.area[1] > this.toGrid[1]) {
      return false;
    }
    for (let startRow = 0; startRow < this.toGrid[1] - item.area[1] + 1; startRow++) {
      for (let startCol = 0; startCol < this.toGrid[0] - item.area[0] + 1; startCol++) {
        if (this.checkAndUpdateItemInfo(newPage, startRow, startCol, item)) {
          return true;
        }
      }
    }
    return false;
  }

  private checkAndUpdateItemInfo(newPage: ScreenTransferBean, startRow: number, startCol: number,
    item: BaseTransferBean): boolean {
    if (!item.area) {
      return false;
    }
    if (!newPage.occupied[startRow] || newPage.occupied[startRow][startCol] !== true) {
      let endCol: number = item.area[0] + startCol;
      let endRow: number = item.area[1] + startRow;
      if ((item.area[0] === 1 && item.area[1] === 1) ||
      this.isPositionValid(startCol, startRow, endCol, endRow, newPage)) {
        item.row = startRow;
        item.column = startCol;
        item.page = newPage.page;
        item.container = CommonConstants.CONTAINER_DESKTOP;
        this.updateOccupied(startCol, startRow, endCol, endRow, newPage);
        return true;
      }
    }
    return false;
  }

  private isPositionValid(startCol: number, startRow: number, endCol: number, endRow: number,
    newPage: ScreenTransferBean): boolean {
    for (let i = startRow; i < endRow; i++) {
      for (let j = startCol; j < endCol; j++) {
        if (newPage.occupied[i] && newPage.occupied[i][j]) {
          return false;
        }
      }
    }
    return true;
  }

  private updateOccupied(startCol: number, startRow: number, endCol: number, endRow: number,
    newPage: ScreenTransferBean): void {
    for (let i = startRow; i < endRow; i++) {
      for (let j = startCol; j < endCol; j++) {
        if (!newPage.occupied[i]) {
          newPage.occupied[i] = [];
        }
        newPage.occupied[i][j] = true;
      }
    }
  }

  public async insertNewLayoutToDb(layoutInfo: GridLayoutItemInfo [], isOuter?: boolean): Promise<void> {
    log.showInfo(TAG, 'insertNewLayoutToDb start, isOuter=%{public}s', isOuter);
    this.updateInfoId(layoutInfo);
    this.updateInfoId(this.dockList);
    this.correctDockList();
    await RdbStoreManager.getInstance().deleteAllGridInfoData(isOuter);
    await RdbStoreManager.getInstance()
      .updateSettings(desktopUtil.getPageCount(), this.maxScreen);
    log.showInfo(TAG, 'insertNewLayoutToDb insert desktop length: %{public}d, maxScrean: %{public}d', layoutInfo.length,
      this.maxScreen);
    await RdbStoreManager.getInstance().insertGridLayoutInfo(layoutInfo, true, isOuter);
    if (isOuter === undefined || !isOuter) {
      await RdbStoreManager.getInstance().insertGridLayoutInfo(this.dockList);
      log.showInfo(TAG, 'insertNewLayoutToDb insert dockList length :%{public}d', this.dockList.length);
    }
    this.newLayoutCardItems = layoutInfo.filter(item => item.typeId === CommonConstants.TYPE_CARD);
  }

  public dealSpecialFolderElements(specialFolderElements: BaseTransferBean[]): void {
    let specialFolder: BaseTransferBean | null = this.makeSmallerFolder(specialFolderElements, true, true);
    let findStartPage: number =
      this.isBigFold ? NumberConstants.CONSTANT_NUMBER_TWO : NumberConstants.CONSTANT_NUMBER_ONE;
    let isFind: boolean = false;
    for (let i = findStartPage; i < this.screenDataMap.size; i++) {
      let curPage = this.screenDataMap.get(i);
      if (curPage === undefined) {
        continue;
      }
      if (CheckEmptyUtils.isEmptyArr(curPage.occupied)) {
        this.fillOccupied(curPage.occupied, false);
      }
      isFind = this.findArea(curPage.occupied, specialFolder);
      if (isFind && specialFolder) {
        specialFolder.page = i;
        specialFolder.container = CommonConstants.CONTAINER_DESKTOP;
        curPage.children.push(specialFolder);
        this.fillOccupied(curPage.occupied, true, specialFolder);
        return;
      }
    }
    if (this.maxScreen >= this.maxScreenCount || this.screenDataMap.size >= this.maxScreenCount) {
      // 已满十八屏，在当前页形成1x1小文件夹放置
      let theLastPage = this.screenDataMap.get(this.screenDataMap.size - 1);
      if (theLastPage) {
        this.makeRestElementFolderToCurrentPage(theLastPage, theLastPage?.occupied, specialFolderElements, true);
      }
    } else {
      // 未满十八屏，新增一页放置
      let curPage = this.buildScreenPage(this.screenDataMap.size, this.screenDataMap);
      log.showInfo(TAG, `the page for specialFolder is ${curPage.page}`);
      this.fillOccupied(curPage.occupied, false);
      if (specialFolder) {
        specialFolder.row = 0;
        specialFolder.column = 0;
        specialFolder.page = curPage.page;
        curPage.children.push(specialFolder);
        this.fillOccupied(curPage.occupied, true, specialFolder);
      }
      this.maxScreen++;
    }
  }

  public getNewLayoutCardItems(): GridLayoutItemInfo[] {
    return this.newLayoutCardItems;
  }

  public updateInfoId(layoutInfo: GridLayoutItemInfo[]): void {
    if (CheckEmptyUtils.isEmptyArr(layoutInfo)) {
      return;
    }
    for (let i = 0; i < layoutInfo.length; i++) {
      if (layoutInfo[i].typeId === CommonConstants.TYPE_APP ||
        layoutInfo[i].typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        layoutInfo[i].infoId = RdbStoreManager.getInstance().generateRandomUUID();
      } else if (layoutInfo[i].typeId === CommonConstants.TYPE_FOLDER) {
        if (CheckEmptyUtils.isEmptyArr(layoutInfo[i].layoutInfo)) {
          continue;
        }
        // 打点 layoutinfo.container 判断桌面，dock
        FolderReporter.getInstance().reportCreateFolderInTransfer(layoutInfo[i],
          layoutInfo[i].container === CommonConstants.CONTAINER_DOCK);
        let mLayoutInfo = layoutInfo[i].layoutInfo;
        if (!mLayoutInfo) {
          continue;
        }
        for (let j = 0; j < mLayoutInfo[0]?.length; j++) {
          mLayoutInfo[0][j].infoId = RdbStoreManager.getInstance().generateRandomUUID();
        }
      }
    }
  }

  /**
   * 旧机dock存在重复位置数据时，修正元素位置，防止插库失败
   *
   */
  private correctDockList(): void {
    if (!RdbStoreManager.getInstance().ifDuplicatePosition(this.dockList, [], [])) {
      return;
    }
    for (let i = 0; i < this.dockList.length; i++) {
      log.showWarn(TAG, `item: ${this.dockList[i].bundleName} corect column ${this.dockList[i].column} to ${i}`);
      this.dockList[i].column = i;
    }
  }

  /**
   * 生成桌面布局列表
   *
   * @returns 返回最终桌面布局
   * @throws 位置校验重复
   */
  public getNewLayoutFromScreenDataMap(): GridLayoutItemInfo[] {
    log.showInfo(TAG, 'getNewLayoutFromScreenDataMap start');
    // 将所有屏元素统一起来生成最终桌面布局列表
    let gridList: GridLayoutItemInfo[] = [];
    this.screenDataMap.forEach((value, key) => {
      for (let child of value.children) {
        gridList.push(child);
      }
    });
    // 重新按照page再次归类
    let pageGridMap: Map<number, GridLayoutItemInfo[]> = new Map();
    gridList.forEach(item => {
      if (item.page === undefined) {
        return;
      }
      if (pageGridMap.has(item.page)) {
        let pageGridList: GridLayoutItemInfo[] = pageGridMap.get(item.page) ?? [];
        pageGridList.push(item);
        pageGridMap.set(item.page, pageGridList);
      } else {
        pageGridMap.set(item.page, [item]);
      }
    });
    // 按照page校验, 当页是否有重复
    pageGridMap.forEach((pageValue, key) => {
      if (RdbStoreManager.getInstance().ifDuplicatePosition(pageValue, [], [])) {
        this.printPageItem(pageValue);
        throw new Error('the layout has duplicate position');
      }
    });
    // 校验infoid是否重复
    this.checkDuplicateInfoId(gridList);
    return gridList;
  }

  public printPageItem(defaultLayoutInfo: GridLayoutItemInfo[]): void {
    defaultLayoutInfo.forEach(item => {
      log.showError(TAG, 'the page is duplicated, bundleName:%{public}s,typeId:%{public}d,page:%{public}d,row:%{public}d,' +
        'cloumn:%{public}d,area:%{public}d,%{public}d,container:%{public}d,infoid:%{public}s',
        item.bundleName, item.typeId, item.page, item.row, item.column, item.area?.[0], item.area?.[1], item.container,
        item.infoId);
    });
  }

  /**
   * 检查是否有重复位置，如果有则抽离重复元素，放置在新机屏
   */
  public checkAndDealDuplicatePosition(): void {
    let duplicateMap: Map<string, GridLayoutItemInfo[]> = new Map();
    this.screenDataMap.forEach((value, key) => {
      for (let i = value.children.length - 1; i >= 0; i--) {
        let mArea: number[] | undefined = value.children[i].area;
        if (!mArea) {
          continue;
        }
        this.checkDuplicatePosition(mArea, value, i, duplicateMap);
      }
    });

    // 如果同一个点位，出现两个以上元素，则认为这些元素位置重复
    duplicateMap.forEach((value, key) => {
      if (value.length > NumberConstants.CONSTANT_NUMBER_ONE) {
        log.showError(TAG, `the layout has duplicate position items : ${key},${value.length}`);
        this.printPageItem(value);
      }
    });
  }

  /**
   * 遍历每个元素，通过area计算每个元素所有占用坐标点位，将每个点位的四元素组合成key，value为元素对象，存放map
   *
   * @param mArea 元素尺寸
   * @param value 页面总元素
   * @param i 元素index
   * @param duplicateMap 重复位置元素
   */
  private checkDuplicatePosition(mArea: number[], value: ScreenTransferBean, i: number,
    duplicateMap: Map<string, GridLayoutItemInfo[]>): void {
    for (let j = 0; j < mArea[1]; j++) {
      for (let k = 0; k < mArea[0]; k++) {
        let pageIndex: string = (value.children[i].page ?? -1).toString();
        let rowIndex: string = ((value.children[i].row ?? 0) + j).toString();
        let columnIndex: string = ((value.children[i].column ?? 0) + k).toString();
        let container: string = (value.children[i].container ?? -1).toString();

        let keyName: string = pageIndex + '_' + rowIndex + '_' + columnIndex + '_' + container;
        if (duplicateMap.has(keyName)) {
          duplicateMap.get(keyName)?.push(value.children[i]);
          this.dealWithDuplicatePositionItem(value.children, value.children[i], i);
          return;
        } else {
          duplicateMap.set(keyName, [value.children[i]]);
        }
      }
    }
  }

  /**
   * 抽离重复位置元素，更新信息后放入新机屏
   *
   * @param value 旧机页面元素
   * @param needReorderItem 重复位置元素
   * @param removeIndex 重复位置元素index
   */
  private dealWithDuplicatePositionItem(value: BaseTransferBean[], needReorderItem: GridLayoutItemInfo,
    removeIndex: number): void {
    if (removeIndex < 0) {
      return;
    }
    value.splice(removeIndex, 1);
    // 将最终抽离的重复位置元素四元素初始化，放入新机屏重排
    let singleUniqueItem: BaseTransferBean = ObjectCopyUtil.simpleClone(needReorderItem) as BaseTransferBean;
    singleUniqueItem.page = 0;
    singleUniqueItem.column = 0;
    singleUniqueItem.row = 0;
    singleUniqueItem.container = CommonConstants.CONTAINER_UNIQUE_SINGLE;
    this.addLastScrean.push(singleUniqueItem);
  }

  /**
   * 处理卡片映射中尺寸变小的情况
   */
  public dealFormStackElement(): void {
    // key为当前page，value为page页需要重新找位的元素集合
    let rearrangeMap: Map<number, BaseTransferBean[]> = new Map();
    this.screenDataMap.forEach((value, key) => {
      for (let child of value.children) {
        if (child.typeId !== CommonConstants.TYPE_FORM_STACK) {
          continue;
        }
        let childElement: GridLayoutItemInfo[] = child.layoutInfo?.[0] ?? [];
        if (childElement.length <= 1) {
          return;
        }
        let rearrange: BaseTransferBean[] = rearrangeMap.has(key) ? (rearrangeMap.get(key) ?? []) : [];
        child.area = this.getFormStackMaxArea(childElement);
        // 移除不同尺寸卡片
        this.dealDiffSizeChildCards(childElement, child.area, rearrange);
        if (childElement.length === 1) {
          let card = childElement[0];
          card.page = child.page;
          card.row = child.row;
          card.column = child.column;
          card.container = CommonConstants.CONTAINER_DESKTOP;
          let cardItem: BaseTransferBean = ObjectCopyUtil.simpleClone(card)  as BaseTransferBean;
          cardItem.layoutWeight = 0;
          value.children.splice(value.children.indexOf(child), 1, cardItem);
        }
        rearrangeMap.set(key, rearrange);
      }
    });
    // 尺寸变换卡片从当前页开始找位,后面页面找不到直接丢弃
    rearrangeMap.forEach((rearrange, page) => {
      for (let i = 0; i < rearrange.length; i++) {
        log.showInfo(TAG, 'rearrangeCard -- cardId: %{public}s, cardName: %{public}s, bundleName: %{public}s, moduleName: %{public}s,' +
          ' area: [%{public}d, %{public}d], page: %{public}d, column: %{public}d, row: %{public}d', rearrange[i].cardId,
          rearrange[i].cardName, rearrange[i].bundleName, rearrange[i].moduleName, rearrange[i].area?.[0],
          rearrange[i].area?.[1], rearrange[i].page, rearrange[i].column, rearrange[i].row);
        this.rearrangeCardFromPage(page, rearrange[i]);
      }
    });
  }

  public getFormStackMaxArea(childElement: GridLayoutItemInfo[]): number[] {
    let maxArea: number[] = [1, 1];
    childElement.forEach((item) => {
      if (item.area === undefined) {
        return;
      }
      if (item.area[0] * item.area[1] >= maxArea[0] * maxArea[1]) {
        maxArea = item.area;
      }
    });
    return maxArea;
  }

  private dealDiffSizeChildCards(childElement: GridLayoutItemInfo[], maxArea: number[],
    rearrange: BaseTransferBean[]): void {
    for (let i = childElement.length - 1; i >= 0; i--) {
      let mArea = childElement[i].area;
      if (!mArea) {
        return;
      }
      if (mArea[0] !== maxArea[0] || mArea[1] !== maxArea[1]) {
        // 后续卡片的row不连续，但是不影响相对顺序
        let item: BaseTransferBean = ObjectCopyUtil.simpleClone(childElement[i])  as BaseTransferBean;
        item.layoutWeight = 0;
        rearrange.push(item);
        childElement.splice(i, 1);
      }
    }
  }

  public rearrangeCardFromPage(page: number, item: BaseTransferBean): void {
    for (let curPage = page; curPage < this.screenDataMap.size; curPage++) {
      let screenData = this.screenDataMap.get(curPage);
      if (!screenData) {
        return;
      }
      let isFind: boolean = this.findArea(screenData.occupied, item);
      if (isFind) {
        item.page = curPage;
        item.container = CommonConstants.CONTAINER_DESKTOP;
        this.fillOccupied(screenData.occupied, true, item);
        screenData.children.push(item);
        break;
      }
    }
  }

  private disbandFormCombine(formCombine: GridLayoutItemInfo): GridLayoutItemInfo[] {
    log.showInfo(TAG, `FormCombine is ${JSON.stringify(formCombine)}`);
    let formList: GridLayoutItemInfo[] = [];
    if (!formCombine.layoutInfo) {
      return formList;
    }
    for (let j = 0; j < formCombine.layoutInfo[0]?.length; j++) {
      let gridInner = formCombine.layoutInfo[0][j];
      if (formCombine.row === undefined || gridInner.row === undefined ||
        formCombine.column === undefined || gridInner.column === undefined) {
        continue;
      }
      gridInner.row = formCombine.row + gridInner.row;
      gridInner.column = formCombine.column + gridInner.column;
      gridInner.container = formCombine.container;
      gridInner.page = formCombine.page;
      formList.push(gridInner);
    }
    log.showInfo(TAG, `after disband, formList length is ${formList.length}`);
    return formList;
  }

  /**
   * 以屏为单位，将旧布局转换成新布局
   *
   * @returns 返回新布局元素集合
   */
  public transferOldLayoutToNewLayout(): GridLayoutItemInfo[] {
    log.showInfo(TAG, 'transferOldLayoutToNewLayout start, screen size is %{public}d', this.screenDataMap.size);
    if (this.screenDataMap.size <= 0) {
      this.buildScreenPage(0, this.screenDataMap);
      let occupied: boolean[][] = [];
      this.fillOccupied(occupied, false);
      let mScreenTransferBean: ScreenTransferBean | undefined = this.screenDataMap.get(0);
      if (mScreenTransferBean) {
        mScreenTransferBean.occupied = occupied;
      }
    }
    this.screenDataMap.forEach((value, key) => {
      this.transferByScreen(value);
    });
    this.mergeScreenDataMap();
    this.checkAndDealDuplicatePosition();
    this.screenDataMap = this.handleExtractedElements(this.screenDataMap);
    // 处理未鸿蒙化文件夹
    if (!CheckEmptyUtils.isEmptyArr(this.notHarmonyList) && !NotHarmonyUtil.CANCEL_NOT_HARMONY_FOLDER) {
      log.showInfo(TAG, 'deal not Harmony elements start');
      this.dealSpecialFolderElements(this.notHarmonyList);
    }
    // 处理克隆应用文件夹
    if (!CheckEmptyUtils.isEmptyArr(this.deliverTongList)) {
      log.showInfo(TAG, 'deal deliver tong elements start');
      this.dealSpecialFolderElements(this.deliverTongList);
    }
    // 处理应用文件夹
    if (!CheckEmptyUtils.isEmptyArr(this.easyAbroadList)) {
      log.showInfo(TAG, 'deal easy abroad elements start');
      this.dealSpecialFolderElements(this.easyAbroadList);
    }

    return this.getNewLayoutFromScreenDataMap();
  }

  /**
   * 将screenDataMap中的元素按照屏数从小到大排序
   */
  public sortScreenDataMap(): void {
    let newSortMap: Map<number, ScreenTransferBean> = new Map();
    let keyArr: number[] = [];
    this.screenDataMap.forEach((value, key) => {
      keyArr.push(key);
    });
    keyArr.sort((x1, x2) => x1 - x2);
    keyArr.forEach(item => {
      let mScreenTransferBean: ScreenTransferBean | undefined = this.screenDataMap.get(item);
      if (mScreenTransferBean) {
        newSortMap.set(item, mScreenTransferBean);
      }
    });
    this.screenDataMap = newSortMap;
  }

  /**
   * 对当前屏进行布局转换
   *
   * @param screenData 当前屏所有元素
   * @param isNewPage 当前屏是否为新增的一屏，新增一屏的元素按照焕新方案排列
   */
  public transferByScreen(screenData: ScreenTransferBean): void {
    this.preprocessScreenData(screenData);
    this.realignScreenData(screenData);
  }

  /**
   * 将当前屏的元素按照维持方案进行排列
   *
   * @param screenData 当前屏所有元素
   */
  public realignScreenData(screenData: ScreenTransferBean): void {
    let occupied: boolean[][] = [];
    for (let i = 0; i < this.fromGrid[1]; i++) {
      let item: boolean[] = new Array(this.toGrid[0]);
      item.fill(false, 0, item.length);
      occupied[i] = item;
    }
    this.realignByMaintenance(screenData, occupied);
    // 将每屏的宫格布局记录下来
    screenData.occupied = occupied;
  }

  public realignByMaintenance(screenData: ScreenTransferBean, occupied: boolean[][]): void {
    // 以行为单位，存放当前屏的元素
    let rowElementMap: Map<number, number[]> = new Map();
    // 存放当前屏所有天气widget，不包含1*4卡片
    let widgetIndexArr: number[] = [];
    // 存放当前屏所有天气widget，包含1*4卡片
    let allWidgetIndexArr: number[] = [];
    // 存放当前屏所有空行
    let emptyRowArr: number[] = [];
    // 遍历当前屏元素，获取所有天气widget和空行
    this.calculateRowElement(screenData, rowElementMap, widgetIndexArr, emptyRowArr, allWidgetIndexArr);
    // 天气widget变大挤位
    if (!CheckEmptyUtils.isEmptyArr(widgetIndexArr)) {
      this.regroupWidgetPosition(widgetIndexArr, screenData, emptyRowArr, rowElementMap);
    }
    // 抽离天气上方的空行
    if (!CheckEmptyUtils.isEmptyArr(allWidgetIndexArr)) {
      this.removeWidgetEmptyRow(screenData);
    }
    // 收集当前屏每一行多出来的元素
    let extraElements: number[] = [];
    rowElementMap.forEach((value) => {
      // 一行一行的放置元素
      this.placeElementsByRow(value, screenData, occupied, extraElements);
    });
    // 维持方案一行一行放置完成后，可能存在很多空位，无需填充，多余元素放到下一屏
    this.fillNextPage(extraElements, screenData);
  }

  /**
   * 系统迁移场景放置抽离的多余元素前需要先缩进第一张天气卡片上方的空行
   *
   * @param screenData 屏幕元素数据
   * @param emptyRowArr 空行列表
   * @param rowElementMap 当页数据行
   * @returns 返回更新后的当页数据行
   */
  private removeWidgetEmptyRow(screenData: ScreenTransferBean): void {
    let firstWidgetIndex = screenData.children.findIndex(item => item.typeId === CommonConstants.TYPE_CARD &&
      CommonConstants.TRANSLUCENT_CLOCK_WEATHER_CARD.includes(item.cardName ?? ''));
    let emptyRowArr: number[] = this.refreshEmptyRowArr(screenData);
    let rowElementMap: Map<number, number[]> = this.refreshRowElementMap(screenData);
    if (CheckEmptyUtils.isEmptyArr(emptyRowArr) || firstWidgetIndex === CommonConstants.INVALID_VALUE) {
      return;
    }
    // 比较空行的位置与第一张天气卡片的位置，如果第一张卡片上有空行则进行缩进,否则返回
    if ((screenData.children[firstWidgetIndex].row ?? 0) < emptyRowArr[0]) {
      return;
    }
    // 设置空行标记位
    let emptyRowNum = 0;
    for (let i = 0; i < this.fromGrid[1] * 2; i++) {
      if (i < (screenData.children[0].row ?? 0) && emptyRowArr.includes(i)) {
        emptyRowNum++;
        continue;
      }
      let rowValue: number[] | undefined = rowElementMap.get(i);
      // 如果不为空行且当前行上面有空行则减去对应空行
      if (emptyRowNum !== 0 && rowValue) {
        this.dealRowValue(rowValue, screenData, emptyRowNum);
      }
    }
    log.showInfo(TAG, `delete empty row: ${emptyRowNum}`);
  }

  private dealRowValue(rowValue: number[], screenData: ScreenTransferBean, emptyRowNum: number): void {
    rowValue.forEach(item => {
      let tmpRow = screenData.children[item].row;
      if (tmpRow !== undefined) {
        screenData.children[item].row = tmpRow - emptyRowNum;
      }
    });
  }

  public fillNextPage(extraElements: number[], screenData: ScreenTransferBean): void {
    if (!extraElements || extraElements.length === 0) {
      log.showInfo(TAG, `no item need to put next page, this page is ${screenData?.page}`);
      return;
    }
    extraElements.sort((x1, x2) => x1 - x2);
    for (let i = extraElements.length - 1; i >= 0; i--) {
      screenData.moveToNextPage.push(screenData.children[extraElements[i]]);
      screenData.children.splice(extraElements[i], 1);
    }
  }

  public calculateRowElement(screenData: ScreenTransferBean, rowElementMap: Map<number, number[]>,
    widgetIndexArr: number[], emptyRowArr: number[], allWidgetIndexArr: number[]): void {
    let rowElementLenMap: Map<number, number> = new Map();
    for (let i = 0; i < screenData.children.length; i++) {
      let baseTransferBean: BaseTransferBean = screenData.children[i];
      if (baseTransferBean.row === undefined || !baseTransferBean.area) {
        continue;
      }
      if (!rowElementMap.has(baseTransferBean.row)) {
        rowElementMap.set(baseTransferBean.row, []);
      }
      rowElementLenMap.set(baseTransferBean.row,
        Math.max(rowElementLenMap.get(baseTransferBean.row) ?? 0, baseTransferBean.area[1]));
      if (baseTransferBean.typeId === CommonConstants.TYPE_CARD && baseTransferBean.cardName !== undefined &&
        CommonConstants.TRANSLUCENT_CLOCK_WEATHER_CARD.includes(baseTransferBean.cardName)) {
        if (baseTransferBean.cardName !== ONEMULFOURCLOCKWEATHERCARD) {
          widgetIndexArr.push(i);
        }
        allWidgetIndexArr.push(i);
      }
      rowElementMap.get(baseTransferBean.row)?.push(i);
    }
    let elementHasRow: boolean[] = new Array(this.fromGrid[1]);
    elementHasRow.fill(false);
    rowElementLenMap.forEach((value, key) => {
      elementHasRow.fill(true, key, key + value);
    });
    for (let i = 0; i < this.fromGrid[1]; i++) {
      if (!elementHasRow[i]) {
        emptyRowArr.push(i);
      }
    }
  }

  public regroupWidgetPosition(widgetIndexArr: number[], screenData: ScreenTransferBean, emptyRowArr: number[],
    rowElementMap: Map<number, number[]>): void {
    this.isFirstWidgetProcessed = !this.checkNeedMoveUp(widgetIndexArr, screenData, emptyRowArr);
    for (let i = 0; i < widgetIndexArr.length; i++) {
      let widget: BaseTransferBean = screenData.children[widgetIndexArr[i]];
      if (!this.isFirstWidgetProcessed) {
        let preEmptyRow = emptyRowArr.shift();
        if (preEmptyRow !== undefined && widget.row !== undefined && preEmptyRow < widget.row) {
          this.dealRowElementMapIf(rowElementMap, preEmptyRow, widget, screenData);
          rowElementMap = this.refreshRowElementMap(screenData);
        } else {
          if (widget.row !== undefined && rowElementMap.has(widget.row + 1)) {
            let lastIndex = preEmptyRow ?? Number.MAX_VALUE;
            this.dealRowElementMapElse(rowElementMap, lastIndex, widget, screenData);
            rowElementMap = this.refreshRowElementMap(screenData);
          }
        }
        this.isFirstWidgetProcessed = true;
      } else {
        if (widget.row === undefined || !rowElementMap.has(widget.row + 1) || DeviceHelper.isPad()) {
          continue;
        }
        rowElementMap.forEach((value, key) => {
          if (key > (widget.row ?? 0)) {
              value.forEach(item => {
                let tmpRow = screenData.children[item].row;
                if (tmpRow !== undefined) {
                  screenData.children[item].row = tmpRow + 1;
                }
              });
          }
        });
        rowElementMap = this.refreshRowElementMap(screenData);
      }
    }
  }

  private dealRowElementMapIf(rowElementMap: Map<number, number[]>, preEmptyRow: number, widget: BaseTransferBean,
    screenData: ScreenTransferBean): void {
    let tmpRow = (widget.row ?? 0);
    rowElementMap.forEach((value, key) => {
      if (key <= preEmptyRow || key > tmpRow) {
        return;
      }
      value.forEach(item => {
        let tmpRow = screenData.children[item].row;
        if (tmpRow !== undefined) {
          screenData.children[item].row = tmpRow -1;
        }
      });
    });
  }

  private dealRowElementMapElse(rowElementMap: Map<number, number[]>, lastIndex: number, widget: BaseTransferBean,
    screenData: ScreenTransferBean): void {
    let tmpRow = (widget.row ?? 0);
    rowElementMap.forEach((value, key) => {
      if (key <= tmpRow || key >= lastIndex) {
        return;
      }
      value.forEach(item => {
        let tmpRow = screenData.children[item].row;
        if (tmpRow !== undefined) {
          screenData.children[item].row = tmpRow + 1;
        }
      });
    });
  }

  /**
   * 检查首张天气单卡片是否向上挤位
   *
   * @param widgetIndexArr 首页天气
   * @param screenData 当屏布局
   * @param emptyRowArr 当屏空行
   * @returns true为须要向上挤位
   */
  private checkNeedMoveUp(widgetIndexArr: number[], screenData: ScreenTransferBean, emptyRowArr: number[]): boolean {
    let needMoveUp: boolean = false;
    if (widgetIndexArr[0] !== undefined && !screenData.children[widgetIndexArr[0]]) {
      return needMoveUp;
    }
    let twoRowWidgetList: number[] = GlobalContext.getInstance().getObject('twoRowWidgetList') as number[];
    let firstWidget = screenData.children[widgetIndexArr[0]];
    // 如果首个空行大于首张天气卡片的位置且旧机不为4*2的天气卡片,则不再向上挤位
    if (!CheckEmptyUtils.isEmptyArr(emptyRowArr) && (!twoRowWidgetList ||
      !twoRowWidgetList.includes(firstWidget.id ?? 0))) {
      needMoveUp = emptyRowArr[0] >= (firstWidget.row ?? 0) ? false : true;
    }
    return needMoveUp;
  }

  /**
   * 刷新当页空白行
   *
   * @param screenData 当页数据
   * @returns 空白行
   */
  private refreshEmptyRowArr(screenData: ScreenTransferBean): number[] {
    let emptyRowList: number[] = [];
    let occupied: boolean[][] = [];
    for (let i = 0; i < this.fromGrid[1] * 2; i++) {
      let item: boolean[] = new Array(this.toGrid[0]);
      item.fill(false, 0, item.length);
      occupied[i] = item;
    }
    screenData.children.forEach(item => {
      this.fillOccupied(occupied, true, item);
    });
    occupied.forEach((rowOocupied, index) => {
      let cellOccupied: boolean = rowOocupied.find(cell => cell) ?? false;
      if (!cellOccupied && index < this.fromGrid[1]) {
        emptyRowList.push(index);
      }
    });
    return emptyRowList;
  }

  private refreshRowElementMap(screenData: ScreenTransferBean): Map<number, number[]> {
    let rowElementMap: Map<number, number[]> = new Map();
    for (let i = 0; i < screenData.children.length; i++) {
      let baseTransferBean: BaseTransferBean = screenData.children[i];
      if (baseTransferBean.row === undefined) {
        continue;
      }
      if (!rowElementMap.has(baseTransferBean.row)) {
        rowElementMap.set(baseTransferBean.row, []);
      }
      rowElementMap.get(baseTransferBean.row)?.push(i);
    }
    return rowElementMap;
  }

  public placeElementsByRow(curRowElements: number[], screenData: ScreenTransferBean,
    occupied: boolean[][], needToNextPageIndex: number[]): void {
    if (CheckEmptyUtils.isEmptyArr(curRowElements)) {
      return;
    }
    let curRow: number | undefined = screenData.children[curRowElements[0]].row;
    if (curRow === undefined) {
      return;
    }
    let emptyLen: number = this.findEmptyPosition(occupied, curRow);
    let rowLen: number = 0;
    for (let j = 0; j < curRowElements.length; j++) {
      let tmpArea = screenData.children[curRowElements[j]].area;
      if (tmpArea) {
        rowLen += tmpArea[0];
      }
    }
    if (rowLen >= emptyLen) {
      // 当前行待放置元素宽度大于空白位置宽度，将当前行较窄的元素移出
      this.moveNarrowerElements(curRowElements, rowLen, emptyLen, screenData, needToNextPageIndex);
      // 当前行空间不够，在当前行从前之后依次放置
      this.dealWithLessSpace(curRowElements, occupied, screenData, needToNextPageIndex);
    } else {
      // 当前行空间足够，按原位放置
      this.dealWithMoreSpace(screenData, curRowElements, occupied, needToNextPageIndex);
    }
  }

  public moveNarrowerElements(curRowElements: number[], rowLen: number, emptyLen: number,
    screenData: ScreenTransferBean, needToNextPageIndex: number[]): void {
    if (emptyLen === 0) {
      return;
    }
    // 优先移app和shortcut
    rowLen = this.moveElementByType(curRowElements, rowLen, emptyLen, screenData, needToNextPageIndex,
      [CommonConstants.TYPE_APP, CommonConstants.TYPE_SHORTCUT_ICON]);
    if (rowLen > emptyLen) {
      // 移完app空间仍不够，则移小文件夹或1*2竖形文件夹
      this.moveElementByType(curRowElements, rowLen, emptyLen, screenData, needToNextPageIndex,
        [CommonConstants.TYPE_FOLDER]);
    }
  }

  public moveElementByType(curRowElements: number[], rowLen: number, emptyLen: number,
    screenData: ScreenTransferBean, needToNextPageIndex: number[], type: number[]): number {
    if (rowLen <= emptyLen) {
      return rowLen;
    }
    let appIndex: number[] = [];
    let singleColumnFolderList: number[] = [];
    for (let i = curRowElements.length - 1; i >= 0; i--) {
      if (rowLen <= emptyLen) {
        break;
      }
      let rowItem: BaseTransferBean = screenData.children[curRowElements[i]];
      if (rowItem === undefined) {
        continue;
      }
      if (rowItem.typeId === undefined || type.indexOf(rowItem.typeId) < 0) {
        continue;
      }
      if (this.isAppOrSmallFolder(rowItem)) {
        appIndex.push(i);
        rowLen--;
      } else if ((type.indexOf(CommonConstants.TYPE_FOLDER) >= 0) && rowItem.area &&
        rowItem.area[0] === NumberConstants.CONSTANT_NUMBER_ONE &&
        rowItem.area[1] === NumberConstants.CONSTANT_NUMBER_TWO) { // 如果抽离类型为文件夹且该元素行高为2则收集
        singleColumnFolderList.push(i);
      }
    }
    // 如果还放不下, 当页无1*1的应用或文件夹但有1*2的文件夹则移除从右至左第一个1*2的文件夹
    if (rowLen > emptyLen && (type.indexOf(CommonConstants.TYPE_FOLDER) >= 0) && singleColumnFolderList.length !== 0) {
      let lastFolderIndex = singleColumnFolderList[singleColumnFolderList.length - 1];
      appIndex.push(lastFolderIndex);
      rowLen--;
      log.showWarn(TAG, `remove 1*2 folder,folderId:${screenData.children[curRowElements[lastFolderIndex]].folderId}`);
    }
    for (let i = 0; i < appIndex.length; i++) {
      needToNextPageIndex.push(curRowElements[appIndex[i]]);
      curRowElements.splice(appIndex[i], 1);
    }
    return rowLen;
  }

  public dealWithLessSpace(curRowElements: number[], occupied: boolean[][], screenData: ScreenTransferBean,
    needToNextPageIndex: number[]): void {
    for (let j = 0; j < curRowElements.length; j++) {
      if (this.findAreaByRow(occupied, screenData.children[curRowElements[j]], true)) {
        this.fillOccupied(occupied, true, screenData.children[curRowElements[j]]);
      } else {
        needToNextPageIndex.push(curRowElements[j]);
      }
    }
  }

  public dealWithMoreSpace(screenData: ScreenTransferBean, curRowElements: number[], occupied: boolean[][],
    needToNextPageIndex: number[]): void {
    let last = screenData.children[curRowElements[curRowElements.length - 1]];
    if (last.column !== undefined && last.area && last.column + last.area[0] > this.toGrid[0]) {
      for (let j = curRowElements.length - 1; j >= 0; j--) {
        if (this.findAreaByRowFromLast(occupied, screenData.children[curRowElements[j]])) {
          this.fillOccupied(occupied, true, screenData.children[curRowElements[j]]);
        } else {
          needToNextPageIndex.push(curRowElements[j]);
        }
      }
    } else {
      for (let j = 0; j < curRowElements.length; j++) {
        if (this.findAreaByRow(occupied, screenData.children[curRowElements[j]])) {
          this.fillOccupied(occupied, true, screenData.children[curRowElements[j]]);
        } else {
          needToNextPageIndex.push(curRowElements[j]);
        }
      }
    }
  }

  public findAreaByRow(occupied: boolean[][], transferBean: BaseTransferBean, fromFirst: boolean = false): boolean {
    if (!transferBean.area || transferBean.row === undefined || transferBean.column === undefined) {
      return false;
    }
    if (!fromFirst && this.validElementArea(occupied, transferBean.area, transferBean.row, transferBean.column)) {
      return true;
    }
    if (transferBean.row > occupied.length - 1 || transferBean.row < 0) {
      return false;
    }
    let formColIndex = fromFirst ? 0 : transferBean.column;
    for (let j = formColIndex; j < occupied[transferBean.row].length; j++) {
      if (occupied[transferBean.row][j]) {
        continue;
      }
      if (this.validElementArea(occupied, transferBean.area, transferBean.row, j)) {
        transferBean.column = j;
        return true;
      }
    }
    return false;
  }

  public findAreaByRowFromLast(occupied: boolean[][], transferBean: BaseTransferBean): boolean {
    if (!transferBean.area || transferBean.row === undefined || transferBean.column === undefined) {
      return false;
    }
    if (this.validElementArea(occupied, transferBean.area, transferBean.row, transferBean.column)) {
      return true;
    }
    if (transferBean.row > occupied.length - 1) {
      return false;
    }
    for (let j = this.toGrid[0] - 1; j >= 0; j--) {
      if (occupied[transferBean.row][j]) {
        continue;
      }
      if (this.validElementArea(occupied, transferBean.area, transferBean.row, j)) {
        transferBean.column = j;
        return true;
      }
    }
    return false;
  }

  public findEmptyPosition(occupied: boolean[][], row: number): number {
    let result = 0;
    if (row <= occupied.length - 1 && row >= 0) {
      for (let i = occupied[row].length - 1; i >= 0; i--) {
        if (!occupied[row][i]) {
          result++;
        }
      }
    }
    return result;
  }

  public makeRestElementFolderToCurrentPage(screenData: ScreenTransferBean, occupied: boolean[][],
    notFromCurrentPageElements?: BaseTransferBean[], isNotHamony?: boolean): void {
    let addToCurrentPage: BaseTransferBean[] = [];
    // 未鸿蒙化应用需要收进特殊文件夹
    let isSpecialFolder: boolean = false;
    if (notFromCurrentPageElements && !CheckEmptyUtils.isEmptyArr(notFromCurrentPageElements)) {
      addToCurrentPage = notFromCurrentPageElements;
      isSpecialFolder = isNotHamony ?? false;
    } else {
      this.filterNotAppElement(screenData, addToCurrentPage);
      screenData.moveToNextPage = [];
    }
    if (addToCurrentPage.length === 0) {
      return;
    }
    if (screenData.usedCellCnt < this.toGrid[1] * this.toGrid[0]) {
      let restElementFolder: BaseTransferBean | null = this.makeSmallerFolder(addToCurrentPage, isSpecialFolder, false);
      let isFind: boolean = this.findArea(occupied, restElementFolder);
      if (isFind && restElementFolder) {
        restElementFolder.page = screenData.page;
        this.fillOccupied(occupied, true, restElementFolder);
        screenData.children.push(restElementFolder);
        return;
      }
    }
    if (isSpecialFolder) {
      this.makeNotHarmonyElementToFolder(screenData, occupied, addToCurrentPage);
      return;
    }
    if (screenData.abilityFormUsedCellCnt === this.toGrid[1] * this.toGrid[0]) {
      this.replaceLastCardWithFolder(screenData, occupied, addToCurrentPage, false);
      return;
    }
    this.dealRestElementFolderToCurrentPage(screenData, addToCurrentPage);
  }

  private dealRestElementFolderToCurrentPage(screenData: ScreenTransferBean,
    addToCurrentPage: BaseTransferBean[]): void {
    for (let i = screenData.children.length - 1; i >= 0; i--) {
      if (screenData.children[i].typeId === CommonConstants.TYPE_APP ||
        screenData.children[i].typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        let lastApp: BaseTransferBean = ObjectCopyUtil.deepClone(screenData.children[i]);
        addToCurrentPage.unshift(ObjectCopyUtil.deepClone(screenData.children[i]));
        let restElementFolder: BaseTransferBean | null = this.makeSmallerFolder(addToCurrentPage, false, false);
        if (restElementFolder) {
          this.fillElementInfo(restElementFolder, lastApp);
          screenData.children[i] = restElementFolder;
        }
        return;
      } else if (screenData.children[i].typeId === CommonConstants.TYPE_FOLDER) {
        let lastFolder: BaseTransferBean = screenData.children[i];
        addToCurrentPage.forEach(item => {
          lastFolder.layoutInfo?.[0].push(item);
        });
        this.updateFoldersRowAndColumn(lastFolder.layoutInfo?.[0] ?? []);
        return;
      }
    }
  }

  public replaceLastCardWithFolder(screenData: ScreenTransferBean, occupied: boolean[][],
    addToCurrentPage: BaseTransferBean[],
    isSpecialFolder: boolean): void {
    let lastCard: BaseTransferBean = screenData.children[screenData.children.length - 1];
    screenData.children.splice(screenData.children.length - 1, 1);
    this.fillOccupied(occupied, false, lastCard);
    let restElementFolder: BaseTransferBean | null = this.makeSmallerFolder(addToCurrentPage, isSpecialFolder, false);
    if (restElementFolder) {
      this.fillElementInfo(restElementFolder, lastCard);
      let isFind: boolean = this.findArea(occupied, restElementFolder);
      if (isFind) {
        this.fillOccupied(occupied, true, restElementFolder);
        screenData.children.push(restElementFolder);
      }
    }
  }

  public makeNotHarmonyElementToFolder(screenData: ScreenTransferBean, occupied: boolean[][],
    addToCurrentPage: BaseTransferBean[]): void {
    let lastElement: BaseTransferBean | undefined = this.findLastNoSmallNotHarmnoyFolderElement(screenData);
    if (!lastElement) {
      return;
    }
    log.showWarn(TAG, `makeNotHarmonyElementToFolder start, lastElement bundleName:${lastElement.bundleName} type:${lastElement.typeId}` +
      ` page:${lastElement.page} row:${lastElement.row} column:${lastElement.column} area:${lastElement.area}`);
    if (lastElement.typeId === CommonConstants.TYPE_CARD ||
      lastElement.typeId === CommonConstants.TYPE_FORM_STACK ||
      lastElement.typeId === CommonConstants.TYPE_FORM_COMBINE) {
      this.replaceLastCardWithFolder(screenData, occupied, addToCurrentPage, true);
      return;
    } else if (this.isAppOrSmallFolder(lastElement)) {
      this.mergeTwoSmallElement(screenData, lastElement);
      let notHarmonyElementFolder: BaseTransferBean | null = this.makeSmallerFolder(addToCurrentPage, true, false);
      if (notHarmonyElementFolder) {
        this.fillElementInfo(notHarmonyElementFolder, lastElement);
        screenData.children.splice(screenData.children.indexOf(lastElement), 1, notHarmonyElementFolder);
        log.showWarn(TAG, `after mergeTwoSmallElement, lastElement bundleName:${lastElement.bundleName} type:${lastElement.typeId}` +
          ` page:${lastElement.page} row:${lastElement.row} column:${lastElement.column} area:${lastElement.area}`);
      }
      return;
    } else if (lastElement.typeId === CommonConstants.TYPE_FOLDER && lastElement.area &&
      (lastElement.area[0] > 1 || lastElement.area[1] > 1)) {
      this.fillOccupied(occupied, false, lastElement);
      lastElement.area = [1, 1];
      this.fillOccupied(occupied, true, lastElement);
      let notHarmonyElementFolder: BaseTransferBean | null = this.makeSmallerFolder(addToCurrentPage, true, false);
      if (notHarmonyElementFolder) {
        notHarmonyElementFolder.page = lastElement.page;
        let isFind: boolean = this.findArea(occupied, notHarmonyElementFolder);
        if (isFind) {
          this.fillOccupied(occupied, true, notHarmonyElementFolder);
          screenData.children.push(notHarmonyElementFolder);
        }
      }
      return;
    }
  }

  public findLastNoSmallNotHarmnoyFolderElement(screenData: ScreenTransferBean): BaseTransferBean | undefined {
    // 从后往前遍历，找到一个非1x1即将发布应用文件夹的元素
    let lastElement: BaseTransferBean | undefined;
    for (let i = screenData.children.length - 1; i >= 0; i--) {
      if (screenData.children[i].typeId !== CommonConstants.TYPE_FOLDER ||
        !NotHarmonyUtil.isNotHarmonyFolderById(screenData.children[i].folderId) ||
        screenData.children[i].area?.[0] !== 1 ||
        screenData.children[i].area?.[1] !== 1) {
        lastElement = screenData.children[i];
        break;
      }
    }
    return lastElement;
  }

  public mergeTwoSmallElement(screenData: ScreenTransferBean, lastElement: BaseTransferBean): void {
    if (lastElement.typeId === CommonConstants.TYPE_APP || lastElement.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      this.mergeLastAppAndOtherSmallElement(screenData, lastElement);
      return;
    } else if (lastElement.typeId === CommonConstants.TYPE_FOLDER) {
      this.mergeLastSmallFolderAndOtherSmallElement(screenData, lastElement);
      return;
    }
  }

  public mergeLastSmallFolderAndOtherSmallElement(screenData: ScreenTransferBean, lastElement: BaseTransferBean): void {
    for (let i = screenData.children.indexOf(lastElement) - 1; i >= 0; i--) {
      if (!lastElement.layoutInfo) {
        continue;
      }
      if (screenData.children[i].typeId === CommonConstants.TYPE_APP ||
        screenData.children[i].typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        log.showInfo(TAG, `merge app is ${JSON.stringify(screenData.children[i])}`);
        let tempItem = ObjectCopyUtil.deepClone(screenData.children[i]);
        lastElement.layoutInfo[0].push(ObjectCopyUtil.deepClone(screenData.children[i]));
        this.updateFoldersRowAndColumn(lastElement.layoutInfo[0]);
        screenData.children[i] = ObjectCopyUtil.deepClone(lastElement);
        this.fillElementInfo(screenData.children[i], tempItem);
        return;
      } else if (screenData.children[i].typeId === CommonConstants.TYPE_FOLDER &&
        !NotHarmonyUtil.isNotHarmonyFolderById(screenData.children[i].folderId)) {
        lastElement.layoutInfo[0].forEach(item => {
          screenData.children[i].layoutInfo?.[0].push(item);
        });
        let mLayoutInfo = screenData.children[i].layoutInfo;
        if (mLayoutInfo) {
          this.updateFoldersRowAndColumn(mLayoutInfo[0]);
        }
        return;
      }
    }
  }

  public mergeLastAppAndOtherSmallElement(screenData: ScreenTransferBean, lastElement: BaseTransferBean): void {
    for (let i = screenData.children.indexOf(lastElement) - 1; i >= 0; i--) {
      if (screenData.children[i].typeId === CommonConstants.TYPE_APP ||
        screenData.children[i].typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        let mergeFolder = this.makeSmallerFolder([ObjectCopyUtil.deepClone(screenData.children[i]), lastElement]);
        if (mergeFolder) {
          this.fillElementInfo(mergeFolder, screenData.children[i]);
          screenData.children.splice(i, 1, mergeFolder);
        }
        return;
      } else if (screenData.children[i].typeId === CommonConstants.TYPE_FOLDER &&
        !NotHarmonyUtil.isNotHarmonyFolderById(screenData.children[i].folderId)) {
        let tmpLayoutInfo = screenData.children[i].layoutInfo;
        if (tmpLayoutInfo) {
          tmpLayoutInfo[0].push(ObjectCopyUtil.deepClone(lastElement));
          this.updateFoldersRowAndColumn(tmpLayoutInfo[0]);
        }
        return;
      }
    }
  }

  public fillElementInfo(toElement: BaseTransferBean, fromElement: BaseTransferBean): void {
    toElement.row = fromElement.row;
    toElement.column = fromElement.column;
    toElement.page = fromElement.page;
  }

  public filterNotAppElement(screenData: ScreenTransferBean, addToCurrentPage: BaseTransferBean[]): void {
    screenData.moveToNextPage.forEach(item => {
      if (item.typeId === CommonConstants.TYPE_APP || item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        addToCurrentPage.push(item);
        log.showInfo(TAG, `the element need make to folder is %{public}s`, item.bundleName);
      } else if (item.typeId === CommonConstants.TYPE_FOLDER && item.layoutInfo) {
        item.layoutInfo[0].forEach(item => {
          let icon: BaseTransferBean = ObjectCopyUtil.simpleClone(item) as BaseTransferBean;
          icon.layoutWeight = 0;
          addToCurrentPage.push(icon);
          log.showInfo(TAG, `the element need make to folder is %{public}s`, icon.bundleName);
        });
      }
    });
  }

  public fillOccupied(occupied: boolean[][], fillValue: boolean, transferBean?: BaseTransferBean): void {
    if (transferBean) {
      if (transferBean.row === undefined || transferBean.column === undefined || !transferBean.area) {
        return;
      }
      let rowSpan: number = transferBean.row + transferBean.area[1];
      if (transferBean.row < 0) {
        log.showError(TAG, `item out of layout bundleName:${transferBean.bundleName},row:${transferBean.row},page:${transferBean.page}`);
        return;
      }
      for (let i = transferBean.row; i < rowSpan; i++) {
        occupied[i].fill(fillValue, transferBean.column, transferBean.column + transferBean.area[0]);
      }
      log.showWarn(TAG, `fill element ${fillValue}, bundleName:${transferBean.bundleName} ${transferBean.formStackId} type:${transferBean.typeId}` +
        ` page:${transferBean.page} row:${transferBean.row} column:${transferBean.column} area:${transferBean.area}`);
    } else {
      for (let i = 0; i < this.toGrid[1]; i++) {
        let item: boolean[] = new Array(this.toGrid[0]);
        item.fill(fillValue, 0, item.length);
        occupied[i] = item;
      }
    }
  }

  /**
   * 在桌面宫格中为每个布局元素寻找合适的位置
   *
   * @param occupied 桌面宫格
   * @param transferBean 单个布局元素
   * @returns 是否找位成功
   */
  public findArea(occupied: boolean[][], transferBean: BaseTransferBean | null): boolean {
    if (!transferBean) {
      return false;
    }
    for (let i = 0; i < occupied.length; i++) {
      for (let j = 0; j < occupied[0].length; j++) {
        if (occupied[i][j]) {
          continue;
        }
        if (!transferBean.area) {
          continue;
        }
        if (this.validElementArea(occupied, transferBean.area, i, j)) {
          transferBean.row = i;
          transferBean.column = j;
          return true;
        }
      }
    }
    return false;
  }

  public validElementArea(occupied: boolean[][], area: number [], fromIndexX: number, fromIndexY: number): boolean {
    if (CheckEmptyUtils.isEmptyArr(occupied) || fromIndexX < 0) {
      return false;
    }
    let xSpan: number = area[1] + fromIndexX;
    let ySpan: number = area[0] + fromIndexY;
    if (xSpan > occupied.length || ySpan > occupied[0].length) {
      return false;
    }
    for (let i = fromIndexX; i < xSpan; i++) {
      for (let j = fromIndexY; j < ySpan; j++) {
        if (occupied[i][j]) {
          return false;
        }
      }
    }
    return true;
  }

  /**
   * 按照大小、新旧机元素、相对位置进行排序,用于sort方法
   *
   * @param lhs 左元素
   * @param rhs 右元素
   * @returns 返回比较值
   */
  public compare(lhs: BaseTransferBean, rhs: BaseTransferBean): number {
    if (!rhs.area || !lhs.area) {
      return 0;
    }
    let volumeWeight = rhs.area[0] * rhs.area[1] - lhs.area[0] * lhs.area[1];
    if (volumeWeight !== 0) {
      return volumeWeight;
    }
    if (lhs.area[0] !== rhs.area[0]) {
      return rhs.area[0] - lhs.area[0];
    }
    if (lhs.container !== rhs.container) {
      return lhs.container === CommonConstants.CONTAINER_DESKTOP ? -1 : 1;
    }
    if (lhs.page !== rhs.page && lhs.page !== undefined && rhs.page !== undefined) {
      return lhs.page - rhs.page;
    }
    if (lhs.layoutWeight !== rhs.layoutWeight) {
      return lhs.layoutWeight - rhs.layoutWeight;
    }
    return lhs.settlementPosition?.localeCompare(rhs.settlementPosition ?? '') ?? 0;
  }

  /**
   * 生成当前屏每个元素的权重，便于将元素按照权重从小到大放置
   *
   * 校验元素宽高
   * @param screenData
   */
  public preprocessScreenData(screenData: ScreenTransferBean): void {
    for (let childrenElement of screenData.children) {
      if (childrenElement.page === undefined || childrenElement.row === undefined ||
        childrenElement.column === undefined ||!childrenElement.area) {
        continue;
      }
      childrenElement.layoutWeight = childrenElement.page *
        (this.toGrid[0] * this.toGrid[1]) + childrenElement.row * this.toGrid[0] + childrenElement.column;
      if (!this.isAppOrSmallFolder(childrenElement)) {
        if (childrenElement.area[0] > CommonConstants.DEFAULT_COL) {
          childrenElement.area[0] = CommonConstants.DEFAULT_COL;
        }
        if (childrenElement.area[1] > this.toGrid[1]) {
          childrenElement.area[1] = this.toGrid[1];
        }
      }
    }
    screenData.children.sort((item1, item2) => {
      return item1.row !== item2.row ? (item1.row ?? 0) - (item2.row ?? 0) : (item1.column ?? 0) - (item2.column ?? 0);
    });
  }

  /**
   * 以屏为单位收集旧布局列表，便于后续一屏一屏地进行布局转换处理
   *
   * @param oldLayoutInfo
   * @returns
   */
  public async collectOldLayoutByScreen(oldLayoutInfo: GridLayoutItemInfo[]): Promise<void> {
    this.manyToOneReplace(oldLayoutInfo);
    let deliverObj: Object[] = [];
    let notHarmonyObj: Object[] = [];
    let abroadObj: Object[] = [];
    oldLayoutInfo = oldLayoutInfo.filter(item => {
      // 过滤并收集克隆应用应用
      if (this.isNeedAddTodeliverFolder(item)) {
        let icon: BaseTransferBean = ObjectCopyUtil.simpleClone(item) as BaseTransferBean;
        icon.layoutWeight = 0;
        deliverObj.push({ bundleName: icon.bundleName, appIndex: icon.appIndex } as IMyObj);
        this.deliverTongList.push(icon);
        return false;
      }
      // 过滤并收集应用应用
      if (this.isNeedAddToEasyAbroadFolder(item)) {
        let icon: BaseTransferBean = ObjectCopyUtil.simpleClone(item) as BaseTransferBean;
        icon.layoutWeight = 0;
        abroadObj.push({ bundleName: icon.bundleName, appIndex: icon.appIndex } as IMyObj);
        this.easyAbroadList.push(icon);
        return false;
      }
      // 未鸿蒙化多对一替换的应用放在新机屏
      if (DataConvert.isNotHarmonyManyToOneAndCanceldeliverFolder(item.bundleName)) {
        item.container = CommonConstants.CONTAINER_UNIQUE_SINGLE;
      }
      // 过滤并收集未鸿蒙化应用
      if (this.isNeedAddToNotHarmnoyFolder(item)) {
        let icon: BaseTransferBean = ObjectCopyUtil.simpleClone(item) as BaseTransferBean;
        icon.layoutWeight = 0;
        notHarmonyObj.push({ bundleName: icon.bundleName, appIndex: icon.appIndex } as IMyObj);
        this.notHarmonyList.push(icon);
        return NotHarmonyUtil.CANCEL_NOT_HARMONY_FOLDER;
      }
      // 过滤并收集堆叠中的组合卡片
      if (item.typeId === CommonConstants.TYPE_FORM_COMBINE &&
        item.container !== CommonConstants.CONTAINER_DESKTOP && !CheckEmptyUtils.isEmptyArr(item?.layoutInfo?.[0])) {
        let disbandLayoutInfo: GridLayoutItemInfo[] = this.disbandFormCombine(item);
        disbandLayoutInfo.forEach(disbandItem => {
          let disbandCombineFrom: BaseTransferBean = ObjectCopyUtil.simpleClone(disbandItem) as BaseTransferBean;
          disbandCombineFrom.layoutWeight = 0;
          log.showInfo(TAG, `collect disbanded combo cards,container:${item.container},cardid:${disbandItem.cardId}`);
          this.addLastScrean.push(disbandCombineFrom);
        });
        return false;
      }
      return true;
    });
    let uniqueItemObj: Object[] = [];
    for (let gridItem of oldLayoutInfo) {
      if (gridItem.container === CommonConstants.CONTAINER_DESKTOP) {
        this.collectDesktop(gridItem, oldLayoutInfo);
      } else if (gridItem.container === CommonConstants.CONTAINER_DOCK) {
        this.collectSmartDock(gridItem, oldLayoutInfo);
      } else if (gridItem.container === CommonConstants.CONTAINER_UNIQUE_SINGLE) {
        this.collectUniqueSingle(gridItem, oldLayoutInfo, uniqueItemObj);
      }
    }
    this.sortScreenDataMap();
    log.showInfo(TAG, `old layout max screen length: ${this.maxScreen}`);
    // 集中打印新机特有及特殊应用
    if (deliverObj.length !== 0) {
      LogBatchPrint.printLogsInBatch(deliverObj, PRINT_BATCH_NUMBER, 'collect deliver tong app', TAG);
      deliverObj = [];
    }
    if (notHarmonyObj.length !== 0) {
      LogBatchPrint.printLogsInBatch(notHarmonyObj, PRINT_BATCH_NUMBER, 'collect not harmony app', TAG);
      notHarmonyObj = [];
    }
    if (uniqueItemObj.length !== 0) {
      LogBatchPrint.printLogsInBatch(uniqueItemObj, PRINT_BATCH_NUMBER, 'collect single unique item', TAG);
      uniqueItemObj = [];
    }
    if (abroadObj.length !== 0) {
      LogBatchPrint.printLogsInBatch(abroadObj, PRINT_BATCH_NUMBER, 'collect easy abroad item', TAG);
      abroadObj = [];
    }
  }

  /**
   * 收集新机特有元素
   *
   * @param dataElement 待恢复新机特有元素
   * @param data 待恢复元素集合
   * @param uniqueItemObj 新机特有对象打印集合
   */
  public collectUniqueSingle(dataElement: GridLayoutItemInfo, data: GridLayoutItemInfo[],
    uniqueItemObj: Object[]): void {
    let newLayoutItem: BaseTransferBean | null = ObjectCopyUtil.simpleClone(dataElement) as BaseTransferBean;
    newLayoutItem.layoutWeight = 0;
    if (dataElement.typeId === CommonConstants.TYPE_FOLDER &&
      !CheckEmptyUtils.isEmptyArr(dataElement.layoutInfo?.[0])) {
      log.showWarn(TAG, `the single unique folder, folderName:${dataElement.folderName}, folderid: ${dataElement.folderId},` +
        ` flodersize: ${dataElement.layoutInfo?.[0].length}}`);
      newLayoutItem = this.validAndCollectFolder(dataElement, data, CommonConstants.CONTAINER_UNIQUE_SINGLE);
    }
    if (newLayoutItem) {
      this.addLastScrean.push(newLayoutItem);
      uniqueItemObj.push(LogBatchPrint.getUniqueItemObject(newLayoutItem));
    }
  }

  public manyToOneReplace(oldLayoutInfo: GridLayoutItemInfo[]): void {
    // 将每一组多对一替换的应用分别收集起来，排序后保留第一个
    let manyToOneMapping: Map<string, GridLayoutItemInfo[]> = this.collectDuplicateApp(oldLayoutInfo);
    for (const mEntry of manyToOneMapping.entries()) {
      let key = mEntry[0];
      let value = mEntry[1];
      if (value.length <= 1) {
        return;
      }
      value.sort((a, b) => this.compareAppItem(a, b));
      let startIndex = 1;
      if (value[0].appIndex !== CommonConstants.MAIN_APP_INDEX) {
        // 一组多对一替换的应用中如存在分身，则需要保留分身和对应的主应用
        let index = value.findIndex(item => {
          return item.iconResource === value[0].iconResource && item.appIndex === CommonConstants.MAIN_APP_INDEX;
        });
        value.unshift(value.splice(index, 1)[0]);
        startIndex = 2;
      }
      log.showInfo(TAG, `mutliMapping, delete startIndex is ${startIndex}, key is ${key}, value is ${JSON.stringify(value)}`);
      for (let i = startIndex; i < value.length; i++) {
        let removeApp = value[i];
        let index = oldLayoutInfo.findIndex(item => {
          return item.bundleName === removeApp.bundleName && item.container === removeApp.container &&
            item.page === removeApp.page && item.row === removeApp.row && item.column === removeApp.column;
        });
        log.showInfo(TAG, `remove mutliMapping item is ${JSON.stringify(oldLayoutInfo[index])}`);
        oldLayoutInfo.splice(index, 1);
      }
    }
  }

  /**
   * 收集旧机重复元素
   *
   * @param oldLayoutInfo 旧机待恢复元素
   * @returns 重复元素集合
   */
  public collectDuplicateApp(oldLayoutInfo: GridLayoutItemInfo[]): Map<string, GridLayoutItemInfo[]> {
    let manyToOneMapping: Map<string, GridLayoutItemInfo[]> = new Map();
    let moreToOneMappingTmp: Map<string, GridLayoutItemInfo[]> = new Map();
    oldLayoutInfo.forEach(item => {
      if (CommonUtils.isEmpty(item.bundleName) ||
        (item.typeId !== CommonConstants.TYPE_APP && item.typeId !== CommonConstants.TYPE_SHORTCUT_ICON)) {
        return;
      }
      let keyName: string = item.bundleName + item.appIndex + (item.shortcutId ?? '');
      if (moreToOneMappingTmp.has(keyName)) {
        moreToOneMappingTmp.get(keyName)?.push(item);
      } else {
        moreToOneMappingTmp.set(keyName, [item]);
      }
    });
    moreToOneMappingTmp.forEach((value, key) => {
      if (value.length > NumberConstants.CONSTANT_NUMBER_ONE) {
        log.showWarn(TAG, `more items : ${key},${value.length}`);
        manyToOneMapping.set(key, value);
      }
    });
    return manyToOneMapping;
  }

  public isNeedAddToNotHarmnoyFolder(item: GridLayoutItemInfo): boolean {
    if (item.appStatus !== AppStatus.WAIT_FOR_HARMONY) {
      return false;
    }
    if (item.typeId !== CommonConstants.TYPE_APP) {
      return false;
    }
    // 尝鲜应用不收进未鸿蒙化应用文件中
    if (CommonUtils.jsonStrToMap(item.intent).get(NotHarmonyUtil.APP_TYPE) === AppReserveType.TASTE_FRESH) {
      return false;
    }
    if (DeliverUtil.isContainerItem(item.intent)) {
      return false;
    }
    return true;
  }

  public isNeedAddTodeliverFolder(item: GridLayoutItemInfo): boolean {
    if (item.typeId !== CommonConstants.TYPE_APP) {
      return false;
    }
    if (!DeliverUtil.isdeliverApp(item.intent ?? '')) {
      return false;
    }
    if (!DeliverUtil.CANCEL_DELIVER_FOLDER && DataConvert.isNotHarmonyManyToOne(item.bundleName)) {
      return true;
    }
    if (item.container !== CommonConstants.CONTAINER_UNIQUE_SINGLE ||
      !DataConvert.isInContainerFolder(item.bundleName)) {
      return false;
    }
    return true;
  }

  /**
   * 是否需要收纳到应用文件夹
   *
   * @param item 待恢复对象
   * @returns 是否收纳
   */
  private isNeedAddToEasyAbroadFolder(item: GridLayoutItemInfo): boolean {
    if (item.typeId !== CommonConstants.TYPE_APP) {
      return false;
    }
    if (!DeliverUtil.isEasyAbroadItem(item.intent ?? '')) {
      return false;
    }
    // 预留应用拖出
    if (GridLayoutUtil.isAppInstalled(item) && !DataConvert.isInContainerFolder(item.bundleName)) {
      return false;
    }
    return true;
  }

  public compareAppItem(a: GridLayoutItemInfo, b: GridLayoutItemInfo): number {
    // 将分身排在最前面
    if (a.appIndex !== b.appIndex && a.appIndex !== undefined && b.appIndex !== undefined) {
      return b.appIndex - a.appIndex;
    }
    //桌面平铺 > 文件夹
    if (a.container !== b.container && a.container !== undefined && b.container !== undefined) {
      // 工作区 > Dock区
      if (a.container < 0 && b.container < 0) {
        return b.container - a.container;
      }
      return a.container - b.container;
    }
    //根据页码排序
    if (a.page !== b.page && a.page !== undefined && b.page !== undefined) {
      return a.page - b.page;
    }
    //根据行数排序
    if (a.row !== b.row && a.row !== undefined && b.row !== undefined) {
      return a.row - b.row;
    }
    //根据列数排序
    return (a.column ?? 0) - (b.column ?? 0);
  }

  /**
   * 新建屏幕，存放某一屏转换后的元素
   *
   * @param screenPage 屏数
   * @param screenDataMap key为屏数，value为每一屏的所有元素
   * @returns 新增的屏幕
   */
  public buildScreenPage(screenPage: number, screenDataMap: Map<number, ScreenTransferBean>): ScreenTransferBean {
    let theNewPage: ScreenTransferBean = new ScreenTransferBean();
    theNewPage.page = screenPage;
    screenDataMap.set(screenPage, theNewPage);
    return theNewPage;
  }

  public collectDesktop(dataElement: GridLayoutItemInfo, data: GridLayoutItemInfo[]): void {
    if (dataElement.typeId === CommonConstants.TYPE_APP || dataElement.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      let icon: BaseTransferBean = ObjectCopyUtil.simpleClone(dataElement) as BaseTransferBean;
      icon.layoutWeight = 0;
      this.putPageData(icon);
    } else if (dataElement.typeId === CommonConstants.TYPE_FOLDER) {
      let folderInfo = this.validAndCollectFolder(dataElement, data, CommonConstants.CONTAINER_DESKTOP);
      if (folderInfo) {
        this.putPageData(folderInfo);
      }
    } else if (dataElement.typeId === CommonConstants.TYPE_CARD) {
      let card: BaseTransferBean = ObjectCopyUtil.simpleClone(dataElement) as BaseTransferBean;
      card.layoutWeight = 0;
      this.putPageData(card);
    } else if (dataElement.typeId === CommonConstants.TYPE_FORM_STACK) {
      let stackInfo: BaseTransferBean | null = this.validAndCollectFormStack(dataElement, data);
      if (stackInfo) {
        this.putPageData(stackInfo);
      }
    } else if (dataElement.typeId === CommonConstants.TYPE_FORM_COMBINE) {
      if (dataElement.layoutInfo && !CheckEmptyUtils.isEmptyArr(dataElement.layoutInfo[0])) {
        let disbandLayoutInfo: GridLayoutItemInfo[] = this.disbandFormCombine(dataElement);
        disbandLayoutInfo.forEach(item => {
          let card: BaseTransferBean = ObjectCopyUtil.simpleClone(item) as BaseTransferBean;
          card.layoutWeight = 0;
          this.putPageData(card);
        });
      }
    }
    if (DeviceHelper.isPC() && dataElement.typeId === CommonConstants.TYPE_FILE_FOLDER) {
      let fileFolder: BaseTransferBean = ObjectCopyUtil.simpleClone(dataElement) as BaseTransferBean;
      fileFolder.layoutWeight = 0;
      this.putPageData(fileFolder);
    }
    // 手机和pad保留克隆时旧机的空白页
    if (DeviceHelper.isPhoneOrPad()) {
      for (let i = 0; i < BlankPageTransFormItem.getInstance().oldBlankPageList.length; i++) {
        if (BlankPageTransFormItem.getInstance().oldBlankPageList[i] > this.maxScreen) {
          this.maxScreen = BlankPageTransFormItem.getInstance().oldBlankPageList[i];
        }
        if (!this.screenDataMap.has(BlankPageTransFormItem.getInstance().oldBlankPageList[i])) {
          this.buildScreenPage(BlankPageTransFormItem.getInstance().oldBlankPageList[i], this.screenDataMap);
        }
      }
    }
  }

  public collectSmartDock(dataElement: GridLayoutItemInfo, data: GridLayoutItemInfo[]): void {
    if (dataElement.typeId === CommonConstants.TYPE_APP || dataElement.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      let icon: BaseTransferBean = ObjectCopyUtil.simpleClone(dataElement) as BaseTransferBean;
      icon.layoutWeight = 0;
      this.dockList.push(icon);
    } else if (dataElement.typeId === CommonConstants.TYPE_FOLDER) {
      let folderInfo = this.validAndCollectFolder(dataElement, data, CommonConstants.CONTAINER_DOCK);
      if (folderInfo) {
        this.dockList.push(folderInfo);
      }
    }
  }

  public putPageData(dataElement: BaseTransferBean): void {
    if (dataElement.page === undefined) {
      return;
    }
    if (dataElement.page > this.maxScreen) {
      this.maxScreen = dataElement.page;
    }
    if (!this.screenDataMap.has(dataElement.page)) {
      this.buildScreenPage(dataElement.page, this.screenDataMap);
    }
    this.screenDataMap.get(dataElement.page)?.children.push(dataElement);
  }

  public isAppOrSmallFolder(item: GridLayoutItemInfo): boolean {
    if (!item || !item.area) {
      return false;
    }
    return (item.typeId === CommonConstants.TYPE_FOLDER && item.area[0] === 1 && item.area[1] === 1) ||
      item.typeId === CommonConstants.TYPE_APP || item.typeId === CommonConstants.TYPE_SHORTCUT_ICON;
  }

  public validAndCollectFolder(dataElement: GridLayoutItemInfo, dataList: GridLayoutItemInfo[],
    container: number): BaseTransferBean | null {
    let folder: BaseTransferBean = ObjectCopyUtil.simpleClone(dataElement) as BaseTransferBean;
    folder.layoutWeight = 0;
    let childElement: GridLayoutItemInfo[] = [];
    if (dataElement.layoutInfo && !CheckEmptyUtils.isEmptyArr(dataElement.layoutInfo?.[0])) {
      log.showInfo(TAG, `the folder has layoutInfo, folderName: ${dataElement.folderName}, flodersize: ${dataElement.layoutInfo?.[0].length}`);
      childElement = dataElement.layoutInfo[0];
    } else {
      childElement = dataList.filter(item => item.container === dataElement.id);
    }
    if (childElement.length === 0) {
      return null;
    }
    if (childElement.length === 1 && !DeliverUtil.isContainerItem(folder.intent) &&
      (!NotHarmonyUtil.CANCEL_NOT_HARMONY_FOLDER || !NotHarmonyUtil.isNotHarmonyFolderByIntent(folder.intent))) {
      childElement[0].page = dataElement.page;
      childElement[0].row = dataElement.row;
      childElement[0].column = dataElement.column;
      childElement[0].area = [1, 1];
      let icon: BaseTransferBean = ObjectCopyUtil.simpleClone(childElement[0]) as BaseTransferBean;
      icon.layoutWeight = 0;
      icon.container = container;
      return icon;
    }
    childElement = this.filterFolderDuplicateElement(childElement, folder);
    childElement.sort((x1, x2) => {
      if (x1.page === undefined || x1.row === undefined || x1.column === undefined || x2.page === undefined ||
        x2.row === undefined || x2.column === undefined) {
        return 0;
      }
      let x1Weight = x1.page * (this.toGrid[0] * this.toGrid[1]) + x1.row * this.toGrid[1] + x1.column;
      let x2Weight = x2.page * (this.toGrid[0] * this.toGrid[1]) + x2.row * this.toGrid[1] + x2.column;
      return x1Weight - x2Weight;
    });
    this.updateFoldersRowAndColumn(childElement);
    let folderName = folder.folderName;
    if (folderName?.includes(this.defaultFolderName)) {
      let curNameNumber: number = Number(folderName.substring(this.defaultFolderName.length));
      if (!Number.isNaN(curNameNumber)) {
        this.folderNamesCountArr.push(curNameNumber);
      }
    }
    folder.bundleName = folder.folderId ?? '';
    folder.layoutInfo = [childElement];
    return folder;
  }

  /**
   * 过滤掉文件夹中重复元素
   *
   * @param childElement 文件夹元素列表
   * @param folder 文件夹对象
   * @returns 过滤后的文件夹列表
   */
  public filterFolderDuplicateElement<T extends GridLayoutItemInfo>(childElement: T[], folder?: BaseTransferBean): T[] {
    let childKeySet: Set<string> = new Set();
    let newChildElement: T[] = childElement.filter(item => {
      let itemKey: string = this.generateGridLayoutItemKey(item);
      if (childKeySet.has(itemKey)) {
        log.showWarn(TAG, 'the item %{public}s is duplicated in folder,folderId:%{public}s', itemKey, folder?.folderId);
        return false;
      }
      childKeySet.add(itemKey);
      return true;
    });
    return newChildElement;
  }

  public generateGridLayoutItemKey(item: GridLayoutItemInfo): string {
    return `${item.bundleName}${item.moduleName}${item.abilityName}${item.appIndex ??
      0}${item.typeId}${item.shortcutId}`;
  }

  public validAndCollectFormStack(dataElement: GridLayoutItemInfo, dataList: GridLayoutItemInfo[]):
    BaseTransferBean | null {
    let stackInfo: BaseTransferBean = ObjectCopyUtil.simpleClone(dataElement) as BaseTransferBean;
    stackInfo.layoutWeight = 0;
    let childElement: GridLayoutItemInfo[] = dataList.filter(item => item.container === dataElement.id);
    if (childElement.length === 0) {
      return null;
    }
    childElement.sort((x1, x2) => (x1.row ?? 0) - (x2.row ?? 0));
    if (childElement.length === 1) {
      childElement[0].page = dataElement.page;
      childElement[0].row = dataElement.row;
      childElement[0].column = dataElement.column;
      let form: BaseTransferBean = ObjectCopyUtil.simpleClone(childElement[0]) as BaseTransferBean;
      form.layoutWeight = 0;
      form.container = CommonConstants.CONTAINER_DESKTOP;
      return form;
    } else {
      for (let i = 0; i < childElement.length; i++) {
        childElement[i].column = i;
        childElement[i].row = 0;
      }
      if (dataElement.infoId) {
        stackInfo.formStackId = dataElement.infoId;
      } else {
        stackInfo.formStackId = dataElement.formStackId;
      }
      stackInfo.layoutInfo = [childElement];
      // 旧机堆叠需要刷新intent
      DataConvert.initFormStackIntent(stackInfo, childElement);
      return stackInfo;
    }
  }

  public makeSmallerFolder(gridLayoutArr: BaseTransferBean[], isSpecialFolder: boolean = false,
    isMakeBigFolder: boolean = false): BaseTransferBean | null {
    if (CheckEmptyUtils.isEmptyArr(gridLayoutArr)) {
      return null;
    }
    // 过滤掉创建文件夹的重复应用
    gridLayoutArr = this.filterFolderDuplicateElement(gridLayoutArr);
    // 定制文件夹单个应用也要形成文件夹
    if (gridLayoutArr.length === 1 && !isSpecialFolder) {
      gridLayoutArr[0].container = CommonConstants.CONTAINER_DESKTOP;
      log.showWarn(TAG, 'makeSmallerFolder to current page fail, only one app is %{public}s', gridLayoutArr[0].bundleName);
      return gridLayoutArr[0];
    }
    if (!isSpecialFolder) {
      this.newSmallerCount++;
      while (this.folderNamesCountArr.includes(this.newSmallerCount)) {
        this.newSmallerCount++;
      }
    }
    let item: BaseTransferBean = new BaseTransferBean();
    item.id = ++this.curTimeSecond;
    item.folderName = this.defaultFolderName + this.newSmallerCount;
    item.folderId = item.id.toString();
    item.bundleName = item.folderId;
    item.typeId = CommonConstants.TYPE_FOLDER;
    item.area = isMakeBigFolder ? [NumberConstants.CONSTANT_NUMBER_TWO, NumberConstants.CONSTANT_NUMBER_TWO] :
      [NumberConstants.CONSTANT_NUMBER_ONE, NumberConstants.CONSTANT_NUMBER_ONE];
    item.container = CommonConstants.CONTAINER_DESKTOP;
    this.updateFoldersRowAndColumn(gridLayoutArr);
    item.layoutInfo = [gridLayoutArr];
    if (isSpecialFolder) {
      let installSource: string =
        CommonUtils.jsonStrToMap(item.layoutInfo[0][0].intent).get(NotHarmonyUtil.INSTALL_SOURCE) as string;
      let intentMap: Map<string, string> = new Map();
      if (installSource === DeliverUtil.DELIVER_APPSTORE_PKG) {
        intentMap.set(NotHarmonyUtil.INSTALL_SOURCE, DeliverUtil.DELIVER_APPSTORE_PKG);
        item.intent = CommonUtils.mapToJonStr(intentMap);
        DeliverUtil.setContainerFolderMapInDesktop(item);
        DeliverUtil.setIsCreateFolder(true);
        item.folderName = DELIVER_FOLDERNAME;
      } else if (installSource === DeliverUtil.ABROAD_APP_PKG){
        intentMap.set(NotHarmonyUtil.INSTALL_SOURCE, DeliverUtil.ABROAD_APP_PKG);
        item.intent = CommonUtils.mapToJonStr(intentMap);
        DeliverUtil.setContainerFolderMapInDesktop(item);
        DeliverUtil.setIsCreateFolder(true);
        item.folderName = ABROAD_APP_FOLDERNAME;
      } else {
        intentMap.set(NotHarmonyUtil.NOT_HARMONY_FOLDER_KEY_NAME_FOR_INTENT, item.folderId);
        NotHarmonyUtil.setNotHarmonyFolderId(item.folderId);
        item.intent = CommonUtils.mapToJonStr(intentMap);
        item.folderName = NOT_HARMONY_FOLDERNAME;
      }
    }
    log.showWarn(TAG, 'makeSmallerFolder to current page, folderName is %{public}s, folderLength is %{public}d, folderId is %{public}s, folderArea is %{public}d x %{public}d',
      item.folderName, item.layoutInfo[0].length, item.folderId, item.area[0], item.area[1]);
    return item;
  }

  public updateFoldersRowAndColumn(childElement: GridLayoutItemInfo[]): void {
    let folderMaxPageCount = MAX_FOLDER_COLUMN_COUNT * MAX_FOLDER_ROW_COUNT;
    for (let i = 0; i < childElement.length; i++) {
      childElement[i].page = Math.floor(i / folderMaxPageCount);
      childElement[i].row = Math.floor((i - (childElement[i].page ?? 0) * folderMaxPageCount) /
        MAX_FOLDER_COLUMN_COUNT);
      childElement[i].column = i % MAX_FOLDER_COLUMN_COUNT;
    }
  }

  public toMaxScreen(): boolean {
    return this.screenDataMap.size >= this.maxScreenCount;
  }

  /**
   * 处理抽离元素(规则3、4)
   *
   * @param layout 每屏布局
   * @param offsetPage 有换新屏时首页偏移
   * @returns 新布局
   */
  public handleExtractedElements(layout: Map<number, ScreenTransferBean>,
    offsetPage: number = 0): Map<number, ScreenTransferBean> {
    log.showInfo(TAG, `handleExtractedElements start layout size: ${layout.size}, offset: ${offsetPage}, maxSize:${this.maxScreen}`);
    let result: Map<number, ScreenTransferBean> = new Map();
    if (this.maxScreen >= this.maxScreenCount) {
      let lastScreen: ScreenTransferBean | undefined = layout.get(this.maxScreen - 1);
      if (lastScreen) {
        lastScreen.moveToNextPage.push(...this.addLastScrean);
      }
      return this.refreshLayout(layout);
    }
    let moveItems: BaseTransferBean[] = [];
    let currentPage: number = 0;
    let newScreenPage = Math.min(INITIAL_PAGE_OF_NEW_SCREEN + offsetPage, this.maxScreen);
    let oldScreenNum = this.maxScreen;
    // 换新屏 + 前两屏抽离元素处理
    for (let i = 0; i < newScreenPage; i++) {
      log.showInfo(TAG, `handleExtractedElements currentPage: ${i}  moveToNextPage size : ${layout.get(i)?.moveToNextPage.length}`);
      if (i >= offsetPage) {
        moveItems.push(...(layout.get(i)?.moveToNextPage ?? []));
      }
      let mScreenTransferBean: ScreenTransferBean | undefined = layout.get(i);
      if (mScreenTransferBean) {
        result.set(i, mScreenTransferBean);
      }
    }
    currentPage = result.size;
    if (moveItems.length > 0) {
      // 抽离元素排序 大>小，旧>新，先>后
      moveItems.sort((lhs: BaseTransferBean, rhs: BaseTransferBean) => this.compare(lhs, rhs));
      let bean: ScreenTransferBean = this.createNewScreen(moveItems, currentPage);
      this.maxScreen ++;
      result.set(currentPage, bean);
    }
    currentPage = result.size;
    log.showInfo(TAG, `handleExtractedElements After the preset screen currentPage: ${currentPage}`);
    // 如果旧机屏幕总数大于默认新机屏1的页数,则开始新机屏1后面的旧机屏
    if (oldScreenNum > INITIAL_PAGE_OF_NEW_SCREEN + offsetPage) {
      for (let i = newScreenPage; i < oldScreenNum; i++) {
        let mScreenTransferBean: ScreenTransferBean | undefined = layout.get(i);
        if (mScreenTransferBean) {
          log.showInfo(TAG, `handleExtractedElements currentPage: ${i}  moveToNextPage size : ${layout.get(i)?.moveToNextPage.length}`);
          moveItems.push(...(layout.get(i)?.moveToNextPage ?? []));
          mScreenTransferBean.page = currentPage;
          mScreenTransferBean.children.forEach(item => item.page = currentPage);
          result.set(currentPage, mScreenTransferBean);
          currentPage = result.size;
        }
      }
    }
    moveItems.push(...this.addLastScrean);
    // 抽离元素排序 大>小，旧>新，先>后
    moveItems.sort((lhs: BaseTransferBean, rhs: BaseTransferBean) => this.compare(lhs, rhs));
    while (moveItems.length > 0) {
      currentPage = result.size;
      if (currentPage >= this.maxScreenCount) {
        break;
      }
      let bean: ScreenTransferBean = this.createNewScreen(moveItems, currentPage);
      this.maxScreen++;
      result.set(currentPage, bean);
    }
    let lastScreen: ScreenTransferBean | undefined = result.get(currentPage - 1);
    if (moveItems.length > 0 && lastScreen) {
      log.showInfo(TAG, `More than 18 screens ${moveItems.length}`);
      lastScreen.moveToNextPage.push(...moveItems);
      result.set(currentPage - 1, this.dealWithExceedElement(lastScreen));
    }
    log.showInfo(TAG, `handleExtractedElements end currentPage: ${currentPage}, result size: ${result.size}`);
    return result;
  }

  /**
   * 克隆场景在短宫格到长宫格时，第一张天气时钟卡片下新增空行与下方元素隔开
   *
   * @param screenData 屏幕元素数据
   * @param widgetIndexArr 天气时钟卡片列表
   */
  public addWidgetEmptyRow(screenData: ScreenTransferBean, widgetIndexArr: number[]): void {
    if (this.fromGrid[1] >= this.toGrid[1]) {
      return;
    }
    if (CheckEmptyUtils.isEmptyArr(widgetIndexArr) || CheckEmptyUtils.isEmptyArr(screenData?.children) ||
      widgetIndexArr[0] >= screenData.children.length) {
      log.showWarn(TAG, `no widget or screen children data, in page: ${screenData.page}`);
      return;
    }

    let firstWidget: BaseTransferBean = screenData.children[widgetIndexArr[0]];
    let rowElementMap: Map<number, number[]> = new Map();
    let maxRow: number = this.getRowElementMap(screenData, rowElementMap);
    if (maxRow > this.fromGrid[1]) {
      log.showInfo(TAG, `no empty row in current page: ${screenData.page}`);
      return;
    }
    if (firstWidget.row !== undefined && firstWidget.area) {
      // 新增空行等于旧机与新机的最大行差
      let emptyStartRow = firstWidget.row + firstWidget.area[1];
      let emptyRowNum = this.toGrid[1] - this.fromGrid[1];
      log.showWarn(TAG, `insert a empty Row under first widget, row: ${emptyStartRow}, rownum: ${emptyRowNum}, in page: ${screenData.page}`);
      this.dealRowElementMap(rowElementMap, emptyStartRow, screenData, emptyRowNum);
    }
    this.refreshOccupied(screenData, this.toGrid);
  }

  private dealRowElementMap(rowElementMap: Map<number, number[]>, emptyStartRow: number, screenData: ScreenTransferBean,
    emptyRowNum: number): void {
    for (let mEntry of rowElementMap.entries()) {
      let key = mEntry[0];
      let value = mEntry[1];
      if (key < emptyStartRow) {
        continue;
      }
      value.forEach(item => {
        let tmpRow = screenData.children[item].row;
        if (tmpRow !== undefined) {
          screenData.children[item].row = tmpRow + emptyRowNum;
        }
      });
    }
  }

  /**
   * 刷新当页占位
   *
   * @param screenData 页面对象
   * @param grid 布局大小
   */
  public refreshOccupied(screenData: ScreenTransferBean, grid: number[]): void {
    if (CheckEmptyUtils.isEmptyArr(screenData.children) || CheckEmptyUtils.isEmptyArr(grid)) {
      log.showWarn(TAG, `the page is a blank page or grid is null`);
      return;
    }
    let newOccupied: boolean[][] = [];
    for (let i = 0; i < grid[1]; i++) {
      let row: boolean[] = new Array(grid[0]);
      row.fill(false, 0, grid[0]);
      newOccupied[i] = row;
    }
    screenData.children.forEach(item => {
      this.fillOccupied(newOccupied, true, item);
    });
    screenData.occupied = newOccupied;
  }

  /**
   * 获取某一屏中每行的元素，并返回此屏幕元素占据的最大行数
   *
   * @param screenData 屏幕元素
   * @param rowElementMap 屏幕中的每行元素
   * @returns 此屏幕元素占据的最大行数
   */
  public getRowElementMap(screenData: ScreenTransferBean, rowElementMap: Map<number, number[]>): number {
    let maxRow: number = 0;
    for (let i = 0; i < screenData.children.length; i++) {
      let baseTransferBean: BaseTransferBean = screenData.children[i];
      if (baseTransferBean.row === undefined || !baseTransferBean.area) {
        continue;
      }
      maxRow = Math.max(baseTransferBean.row + baseTransferBean.area[1], maxRow);
      if (!rowElementMap.has(baseTransferBean.row)) {
        rowElementMap.set(baseTransferBean.row, []);
      }
      rowElementMap.get(baseTransferBean.row)?.push(i);
    }
    return maxRow;
  }

  /**
   * 将所有屏数从小到大重新排列，更新屏数
   */
  public mergeScreenDataMap(): void {
    let newScreenDataMap: Map<number, ScreenTransferBean> = new Map();
    let screen: number = 0;
    this.screenDataMap.forEach((value, key) => {
      for (let child of value.children) {
        child.page = screen;
      }
      value.page = screen;
      newScreenDataMap.set(screen, value);
      screen++;
    });
    this.maxScreen = screen;
    this.screenDataMap = newScreenDataMap;
    log.showInfo(TAG, `getNewLayoutFromScreenDataMap maxScreen is ${this.maxScreen}, screenDataMap size is ${this.screenDataMap.size}`);
  }

  /**
   * 系统迁移场景合并超出的dock区元素
   *
   * @param dockList 旧机dock区元素
   * @returns 返回合并后的dock区元素
   */
  public dealWithExcessiveDockList(oldDockList: BaseTransferBean[]): BaseTransferBean[] {
    if (!CheckEmptyUtils.isEmptyArr(oldDockList) && oldDockList.length <= CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM) {
      return oldDockList;
    }
    let folderName = '';
    oldDockList.sort((x1, x2) => (x1.column ?? 0) - (x2.column ?? 0));
    let excessiveDockList: BaseTransferBean[] = [];
    let newDockList: BaseTransferBean[] = [];
    oldDockList.forEach((item, index) => {
      if (index < CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM - 1) {
        newDockList.push(item);
        return;
      }
      this.collectDesktopItem(item, excessiveDockList);
      if (item.typeId === CommonConstants.TYPE_FOLDER && CheckEmptyUtils.isEmpty(folderName)) {
        folderName = item.folderName ?? '';
      }
    });
    if (excessiveDockList.length !== 0) {
      let dockFolderItem: BaseTransferBean | null = this.makeSmallerFolder(excessiveDockList);
      if (dockFolderItem) {
        dockFolderItem.container = CommonConstants.CONTAINER_SMARTDOCK;
        dockFolderItem.column = CommonConstants.DEFAULT_RECENT_DOCK_MAX_NUM - 1;
        dockFolderItem.folderName = !CheckEmptyUtils.isEmpty(folderName) ? folderName : dockFolderItem.folderName;
        newDockList.push(dockFolderItem);
      }
    }
    return newDockList;
  }

  /**
   * 系统迁移场景收集多余元素
   *
   * @param dataElement  超出元素
   * @param data 待合并集合
   */
  public collectDesktopItem(dataElement: GridLayoutItemInfo, data: GridLayoutItemInfo[]): void {
    if (dataElement.typeId === CommonConstants.TYPE_FOLDER) {
      dataElement.layoutInfo?.flat().forEach(item => {
        let folderItem: BaseTransferBean = ObjectCopyUtil.simpleClone(item) as BaseTransferBean;
        folderItem.layoutWeight = 0;
        data.push(folderItem);
      });
    } else {
      data.push(dataElement);
    }
  }

  /**
   * 校验infoid是否重复, 重复则打印
   *
   * @param data 待检查集合
   */
  private checkDuplicateInfoId(data: GridLayoutItemInfo[]): void {
    if (CheckEmptyUtils.isEmptyArr(data)) {
      return;
    }
    let newScreenDataMap: Map<String, number[]> = new Map();
    data.forEach((item, index) => {
      let infoId: string = this.getInfoIdByType(item);
      if (newScreenDataMap.has(infoId)) {
        let indexArr: number[] | undefined = newScreenDataMap.get(infoId);
        indexArr?.push(index);
        return;
      }
      newScreenDataMap.set(infoId, [index]);
    });
    newScreenDataMap.forEach((value,key) =>{
      if (value.length > 1) {
        let postionStr: string = '';
        value.forEach(itemIndex => {
          let duplicateItem = data[itemIndex];
          postionStr =
            postionStr + '-' + duplicateItem.container + '_' + duplicateItem.page + '_' + duplicateItem.row + '_' +
            duplicateItem.column;
        })
        log.showError(TAG, `duplicate infoid: ${key}, length: ${value.length}, postion: ${postionStr}`);
      }
    });
  }

  /**
   * 按照类型获取对应的infoid
   *
   * @param item 待检查元素
   */
  private getInfoIdByType(item: GridLayoutItemInfo): string {
    if(CheckEmptyUtils.isEmpty(item)){
      return '';
    }
    switch (item.typeId) {
      case CommonConstants.TYPE_APP:
      case CommonConstants.TYPE_SHORTCUT_ICON:
        return item.infoId ?? '';
      case CommonConstants.TYPE_FOLDER:
      case CommonConstants.TYPE_REGION_FOLDER:
        return item.folderId ?? '';
      case CommonConstants.TYPE_CARD:
        return item.cardId ?? '';
      case CommonConstants.TYPE_FORM_STACK:
        return item.formStackId ?? '';
      default:
        return item.infoId ?? '';
    }
  }
}

export interface IMyObj {
  bundleName: string;
  appIndex?: number
}