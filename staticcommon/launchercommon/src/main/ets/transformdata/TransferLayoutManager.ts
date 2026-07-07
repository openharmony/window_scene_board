/**
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
  CheckEmptyUtils,
  FileUtils,
  CommonUtils,
  LogDomain,
  Logger
} from '@ohos/basicutils';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { NumberConstants } from '@ohos/commonconstants';
import { ObjectCopyUtil, desktopUtil } from '@ohos/componenthelper';
import { FolderReporter } from '../folder/FolderReporter';
import type GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { BaseTransferBean } from './BaseTransferBean';
import ScreenTransferBean from './ScreenTransferBean';
import { RdbStoreManager } from '../db/RdbStoreManager';
import { AppStatus, CommonConstants, SuperFoldConstants } from '../constants/CommonConstants';
import DefaultDesktopLayoutInfo from '../configs/DefaultDesktopLayoutInfo';
import { preferences } from '@kit.ArkData';
import type ctx from '@ohos.app.ability.common';
import {
  AppReserveType,
  BlankPageTransFormItem,
  ConfigParseUtil,
  DeliverUtil,
  GridLayoutUtil
} from '../TsIndex';
import { NotHarmonyUtil, NOT_HARMONY_FOLDERNAME } from '../utils/NotHarmonyUtil';
import { DELIVER_FOLDERNAME, ABROAD_APP_FOLDERNAME } from '../utils/DeliverUtil';
import DataConvert from './DataConvert';

const TAG = 'TransferLayoutManager';
const log: Logger = Logger.getLogHelper(LogDomain.BACKUP);
const MAX_FOLDER_COLUMN_COUNT: number = 3;
const MAX_FOLDER_ROW_COUNT: number = 4;
const GRID_LAYOUT_CONFIG_PATH: string = 'etc/desktop/grid_layout_config.json';

export class TransferLayoutManager {
  // 旧布局的行列数
  private fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
  // 新布局的行列数
  private toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
  // 存放所有旧布局元素，key为屏数，value为每一屏的所有元素
  private screenDataMap: Map<number, ScreenTransferBean> = new Map();
  // 存放每一屏幕中无法放下元素，key为屏数，value为每一屏的需要新增的屏幕
  private moveToNextDataMap: Map<number, ScreenTransferBean[]> = new Map();
  private maxScreen: number = 0;
  // Dock区能存放元素的最大个数
  private maxDockNum: number = 0;
  private dockList: BaseTransferBean[] = [];
  // 存放Dock区多余的元素
  private restDockList: BaseTransferBean[] = [];
  // 存放设备特有的元素
  private otherList: BaseTransferBean[] = [];
  // 存放未鸿蒙化的元素
  private notHarmonyList: BaseTransferBean[] = [];
  // 存放可进入克隆应用文件夹的元素
  private deliverTongList: BaseTransferBean[] = [];
  // 存放应用应用
  public easyAbroadList: BaseTransferBean[] = []
  // 克隆场景存放新增解散组合卡片元素
  private disbandCombFormList: BaseTransferBean[] = [];
  // 布局的最大屏数
  private maxScreenCount: number = DefaultDesktopLayoutInfo.getDefaultLayoutInfo().layoutDescription.maxPage;
  private newSmallerCount: number = 0;
  private folderNamesCountArr: number[] = [];
  private defaultFolderName: string = '${new_folder_name}';
  // 是否采用焕新方案，默认选择维持方案
  private isNewLayout = false;
  // 只有第一个天气Widget需要考虑上下挤位和焕新首屏替换
  private isFirstWidgetProcessed: boolean = false;
  private isBigFold: boolean = DeviceHelper.isFoldButNotSmallFoldAndSingleDisplay();
  // 新桌面布局中的卡片信息集合
  private newLayoutCardItems: GridLayoutItemInfo[] = [];
  private isClone: boolean = false;
  private transferType: string = '';
  private curTimeSecond : number = new Date().getTime();

  constructor(fromGrid: number[], toGrid: number[]) {
    this.fromGrid = fromGrid;
    this.toGrid = toGrid;
  }

  /**
   * 将旧桌面布局根据用户选择的方案转换成新桌面布局，并更新数据库
   * @param oldLayoutInfo 旧布局信息
   * @returns
   */
  public async transferLayout(oldLayoutInfo: GridLayoutItemInfo [], type ?: string, isClone: boolean = false,
    isOuter?: boolean): Promise<boolean> {
    this.isClone = isClone;
    this.transferType = type ?? '';
    try {
      log.showWarn(TAG, 'transferData start, oldLayoutLength=%{public}d, type =%{public}s ,isClone=%{public}s, isOuter=%{public}s ', oldLayoutInfo.length, type, this.isClone, isOuter);
      await this.collectOldLayoutByScreen(oldLayoutInfo);
      if (!DeviceHelper.isPC()) {
        this.transferOldLayoutToNewLayout();
      } else {
        this.screenDataMap.forEach((value, key) => {
          this.placeAllElements(value, true);
        });
        this.placeAllElementsForSuperFold();
      }
      await this.insertNewLayoutToDb(isOuter);
      log.showInfo(TAG, 'transferData end');
      return true;
    } catch (error) {
      log.showError(TAG, `transferData error message ${error?.message}  ${error.stack}`);
      return false;
    }
  }

  private placeAllElementsForSuperFold(): void {
    if (!DeviceHelper.isSuperFoldMachine()) {
      return;
    }
    let newSortMap: Map<number, ScreenTransferBean> = new Map();
    this.screenDataMap.forEach((value, key) => {
      const children: BaseTransferBean[] = value.children;
      children.forEach(item => {
        if (item.landscapePage === undefined) {
          return;
        }
        if (!newSortMap.has(item.landscapePage)) {
          this.buildScreenPage(item.landscapePage, newSortMap);
        }
        newSortMap.get(item.landscapePage)?.children.push(item);
      });
    });
    log.showInfo(TAG, `landscape begins to place elements newSortMap size ${newSortMap.size}`);
    newSortMap.forEach((value, key) => {
      this.placeAllElements(value, false);
    });
  }

  private placeAllElements(screenData: ScreenTransferBean, isPortrait: boolean): void {
    let occupied: boolean[][] = [];
    if (DeviceHelper.isSuperFoldMachine()) {
      this.toGrid = isPortrait ? [SuperFoldConstants.DEFAULT_PORTRAIT_COLUMN, SuperFoldConstants.DEFAULT_PORTRAIT_ROW] :
        [SuperFoldConstants.DEFAULT_NON_PORTRAIT_COLUMN, SuperFoldConstants.DEFAULT_NON_PORTRAIT_ROW];
    }
    this.fillOccupiedForPc(occupied, false, isPortrait);
    let appList : BaseTransferBean[] = [];
    let cardList : BaseTransferBean[] = [];
    let regionFolderList : BaseTransferBean[] = [];
    screenData.children.filter(item => item.container === CommonConstants.CONTAINER_DESKTOP).forEach((item) => {
      if (!item.isNeedRestoreFromBackup) {
        this.fillOccupiedForPc(occupied, true, isPortrait, item);
      } else {
        if (item.typeId === CommonConstants.TYPE_APP || item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
          appList.push(item);
        } else if (item.typeId === CommonConstants.TYPE_CARD) {
          cardList.push(item);
        } else if (item.typeId === CommonConstants.TYPE_REGION_FOLDER) {
          regionFolderList.push(item);
        } else {
          log.showInfo(TAG, `ignore the item ${item.bundleName}`);
        }
      }
    });
    log.showInfo(TAG, `appList length ${appList.length} cardList length ${cardList.length} regionFolderList length ${regionFolderList.length} `);
    let allItemList: BaseTransferBean[] = [];
    // 布局恢复时，优先排列应用>收纳夹>卡片
    allItemList.push(...appList, ...regionFolderList, ...cardList);
    allItemList.forEach((item => {
      let isFind: boolean = this.findAreaInScreen(occupied, item, isPortrait);
      if (isFind) {
        this.fillOccupiedForPc(occupied, true, isPortrait, item);
      } else {
        screenData.children.splice(screenData.children.indexOf(item), 1);
        log.showInfo(TAG, `DesktopItem bundleName ${item.bundleName} can not place`);
      }
    }));
    screenData.occupied = occupied;
  }

  private findAreaInScreen(occupied: boolean[][], transferBean: BaseTransferBean, isPortrait: boolean = true): boolean {
    for (let i = 0; i < occupied[0].length; i++) {
      for (let j = 0; j < occupied.length; j++) {
        if (occupied[j][i] || !transferBean.area) {
          continue;
        }
        if (this.validElementArea(occupied, transferBean.area, j, i)) {
          this.modifyPosition(transferBean, i, j, isPortrait);
          return true;
        }
      }
    }
    return false;
  }

  private modifyPosition(transferBean: BaseTransferBean, i: number, j: number, isPortrait: boolean = true): void {
    if (isPortrait) {
      transferBean.column = i;
      transferBean.row = j;
    } else {
      transferBean.landscapeColumn = i;
      transferBean.landscapeRow = j;
    }
  }

  private async getIsNewLayoutFromSP(isOuter: boolean): Promise<boolean> {
    let isNewLayout = false;
    try {
      let desktopLayoutName = isOuter ? 'OUTER_DESKTOP_LAYOUT_INFO' : 'DESKTOP_LAYOUT_INFO';
      let context = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
      const preference: preferences.Preferences = preferences.getPreferencesSync(context, { name: desktopLayoutName });
      isNewLayout = preference.getSync('isNewLayout', false) as boolean;
      log.showInfo(TAG, `getLayoutFlagFromSP success, isNewLayout is %{public}s`, isNewLayout);
    } catch (error) {
      log.error(TAG, 'commonEventManager publish error %{public}s', error?.message);
    }
    return isNewLayout;
  }

  private async insertNewLayoutToDb(isOuter?: boolean): Promise<void> {
    log.showInfo(TAG, 'insertNewLayoutToDb start, isOuter=%{public}s', isOuter);
    let layoutInfo: GridLayoutItemInfo[] = this.getNewLayoutFromScreenDataMap();
    let needUpdateRegionList: GridLayoutItemInfo[] = [];
    this.updateInfoId(layoutInfo);
    this.updateInfoId(this.dockList);
    await RdbStoreManager.getInstance().deleteAllGridInfoData(isOuter);
    await RdbStoreManager.getInstance()
      .updateSettings(desktopUtil.getPageCount(), this.maxScreen);
    log.showInfo(TAG, 'insertNewLayoutToDb insert desktop length :%{public}d', layoutInfo.length);
    await RdbStoreManager.getInstance().insertGridLayoutInfo(layoutInfo, true, isOuter);
    if (needUpdateRegionList.length > 0) {
      for (let item of needUpdateRegionList) {
        await RdbStoreManager.getInstance().updateSubItemsInfo(item);
      }
    }
    log.showInfo(TAG, 'insertNewLayoutToDb insert dockList length :%{public}d', this.dockList.length);
    if (isOuter === undefined || !isOuter) {
      await RdbStoreManager.getInstance().insertGridLayoutInfo(this.dockList);
    }
    this.newLayoutCardItems = layoutInfo.filter(item => item.typeId === CommonConstants.TYPE_CARD);
  }

  private dealNotHarmonyElement(): void {
    log.showInfo(TAG, 'dealNotHarmonyElement start');
    if (CheckEmptyUtils.isEmptyArr(this.notHarmonyList) || NotHarmonyUtil.CANCEL_NOT_HARMONY_FOLDER) {
      return;
    }
    let theLastPage = this.screenDataMap.get(this.screenDataMap.size - 1);
    //在最后一页形成2x2文件夹放置，空间不够就尝试新增一页
    let notHarmonyElementFolder: BaseTransferBean | null = this.makeSmallerFolder(this.notHarmonyList, true, true);
    let isFind: boolean = this.findArea(theLastPage?.occupied ?? [], notHarmonyElementFolder);
    if (isFind && theLastPage && notHarmonyElementFolder) {
      notHarmonyElementFolder.page = theLastPage.page;
      this.fillOccupied(theLastPage.occupied, true, notHarmonyElementFolder);
      theLastPage.children.push(notHarmonyElementFolder);
      return;
    } else {
      if (this.maxScreen >= this.maxScreenCount || this.screenDataMap.size >= this.maxScreenCount) {
        // 已满十八屏，在当前页形成1x1小文件夹放置
        if (theLastPage) {
          this.makeRestElementFolderToCurrentPage(theLastPage, theLastPage?.occupied, this.notHarmonyList, true);
        }
      } else {
        // 未满十八屏，新增一页放置
        let curPage = this.buildScreenPage(this.screenDataMap.size, this.screenDataMap);
        log.showInfo(TAG, `the page for notHarmonyElement is ${curPage.page}`);
        this.fillOccupied(curPage.occupied, false);
        if (notHarmonyElementFolder) {
          notHarmonyElementFolder.row = 0;
          notHarmonyElementFolder.column = 0;
          notHarmonyElementFolder.page = curPage.page;
          curPage.children.push(notHarmonyElementFolder);
          this.fillOccupied(curPage.occupied, true, notHarmonyElementFolder);
        }
        this.maxScreen++;
      }
    }
  }

  private dealDhElement(installSource: string): void {
    let dhElementList: BaseTransferBean[] = [];
    if (installSource === DeliverUtil.DELIVER_APPSTORE_PKG) {
      dhElementList = this.deliverTongList;
    }
    if (installSource === DeliverUtil.ABROAD_APP_PKG) {
      dhElementList = this.easyAbroadList;
    }
    if (CheckEmptyUtils.isEmptyArr(dhElementList)) {
      return;
    }
    let dhFolder: BaseTransferBean | null = this.makeSmallerFolder(dhElementList, true, true);
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
      if (!dhFolder) {
        continue;
      }
      isFind = this.findArea(curPage.occupied, dhFolder);
      if (isFind) {
        dhFolder.page = i;
        dhFolder.container = CommonConstants.CONTAINER_DESKTOP;
        curPage.children.push(dhFolder);
        this.fillOccupied(curPage.occupied, true, dhFolder);
        return;
      }
    }
    if (this.maxScreen >= this.maxScreenCount || this.screenDataMap.size >= this.maxScreenCount) {
      // 已满十八屏，在当前页形成1x1小文件夹放置
      let theLastPage = this.screenDataMap.get(this.screenDataMap.size - 1);
      if (theLastPage) {
        this.makeRestElementFolderToCurrentPage(theLastPage, theLastPage?.occupied, dhElementList, true);
      }
    } else {
      // 未满十八屏，新增一页放置
      let curPage = this.buildScreenPage(this.screenDataMap.size, this.screenDataMap);
      log.showInfo(TAG, `the page for deliverTongElement is ${curPage.page}`);
      this.fillOccupied(curPage.occupied, false);
      if (dhFolder) {
        dhFolder.row = 0;
        dhFolder.column = 0;
        dhFolder.page = curPage.page;
        curPage.children.push(dhFolder);
        this.fillOccupied(curPage.occupied, true, dhFolder);
      }
      this.maxScreen++;
    }
  }

  public getNewLayoutCardItems(): GridLayoutItemInfo[] {
    return this.newLayoutCardItems;
  }

  /**
   * 每个屏幕元素放置不下会在当前屏下新增屏幕放置
   * 展开平铺所有屏幕，把新增屏插入到原有屏幕之间
   */
  private mergeScreenDataMap(): void {
    let newScreenDataMap: Map<number, ScreenTransferBean> = new Map();
    let screen: number = 0;
    this.screenDataMap.forEach((value, key) => {
      for (let child of value.children) {
        child.page = screen;
      }
      value.page = screen;
      newScreenDataMap.set(screen, value);
      screen++;
      if (!this.moveToNextDataMap.has(key)) {
        return;
      }
      let nextScreens: ScreenTransferBean[] = this.moveToNextDataMap.get(key) ?? [];
      nextScreens.forEach((nextScreen) => {
        for (let child of nextScreen.children) {
          child.page = screen;
        }
        nextScreen.page = screen;
        newScreenDataMap.set(screen, nextScreen);
        screen++;
      });
      this.moveToNextDataMap.delete(key);
    });
    this.maxScreen = screen;
    this.screenDataMap = newScreenDataMap;
    log.showInfo(TAG, `getNewLayoutFromScreenDataMap maxScreen is ${this.maxScreen}, screenDataMap size is ${this.screenDataMap.size}`);
  }

  private updateInfoId(layoutInfo: GridLayoutItemInfo[]): void {
    if (CheckEmptyUtils.isEmptyArr(layoutInfo)) {
      return;
    }
    for (let i = 0; i < layoutInfo.length; i++) {
      if (layoutInfo[i].typeId === CommonConstants.TYPE_APP ||
        layoutInfo[i].typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        layoutInfo[i].infoId = RdbStoreManager.getInstance().generateRandomUUID();
      } else if (layoutInfo[i].typeId === CommonConstants.TYPE_FOLDER) {
        let mLayoutInfo = layoutInfo[i].layoutInfo;
        if (!mLayoutInfo || CheckEmptyUtils.isEmptyArr(mLayoutInfo)) {
          continue;
        }
        // 打点 layoutinfo.container 判断桌面，dock
        FolderReporter.getInstance().reportCreateFolderInTransfer(layoutInfo[i],
          layoutInfo[i].container === CommonConstants.CONTAINER_DOCK);
        for (let j = 0; j < mLayoutInfo[0]?.length; j++) {
          mLayoutInfo[0][j].infoId = RdbStoreManager.getInstance().generateRandomUUID();
        }
      }
    }
  }

  /**
   * 生成桌面布局列表
   *
   * @returns 返回最终桌面布局
   */
  private getNewLayoutFromScreenDataMap(): GridLayoutItemInfo[] {
    log.showInfo(TAG, 'getNewLayoutFromScreenDataMap start');
    this.mergeScreenDataMap();
    if (!DeviceHelper.isPC()) {
      this.dealRestDockAndSingleUniqueElement();
      this.dealDisbandCombFormInStack();
      this.dealDhElement(DeliverUtil.DELIVER_APPSTORE_PKG);
      this.dealDhElement(DeliverUtil.ABROAD_APP_PKG);
      this.dealNotHarmonyElement();
      this.dealFormStackElement();
    }
    let gridList: GridLayoutItemInfo[] = [];
    this.screenDataMap.forEach((value, key) => {
      for (let child of value.children) {
        if (child.typeId === CommonConstants.TYPE_FORM_COMBINE) {
          this.disbandFormCombine(child).forEach(item => {
            gridList.push(item);
          });
        } else {
          gridList.push(child);
        }
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
      }
    });
    return gridList;
  }

  /**
   * 处理堆叠中解散的组合卡片，在最后新增屏幕放置
   */
  private dealDisbandCombFormInStack(): void {
    if (this.disbandCombFormList.length === 0) {
      return;
    }
    if (this.maxScreen >= this.maxScreenCount || this.screenDataMap.size >= this.maxScreenCount) {
      // 已满十八屏, 丢弃堆叠中解散的组合卡片
      this.disbandCombFormList = [];
      return;
    }
    // 未满十八屏，新增一页放置堆叠解散的组合卡片
    log.showInfo(TAG, `dealDisbandCombForm, form size: ${this.disbandCombFormList.length}, cur page: ${this.maxScreen}`);
    let curPage = this.buildScreenPage(this.maxScreen, this.screenDataMap);
    this.disbandCombFormList.forEach((item => {
      item.container = CommonConstants.CONTAINER_DESKTOP;
    }));
    curPage.children = [...this.disbandCombFormList];
    this.transferByScreen(curPage, true);
    this.mergeScreenDataMap();
  }

  private printPageItem(defaultLayoutInfo: GridLayoutItemInfo[]): void {
    defaultLayoutInfo.forEach(item => {
      log.showWarn(TAG, 'the page is duplicated, bundleName:%{public}s,typeId:%{public}d,page:%{public}d,row:%{public}d,cloumn:%{public}d,container:%{public}d,infoid:%{public}s',
        item.bundleName, item.typeId, item.page, item.row, item.column, item.container, item.infoId);
    });
  }

  /**
   * 处理卡片映射中尺寸变小的情况
   */
  private dealFormStackElement(): void {
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
          let cardItem: BaseTransferBean = ObjectCopyUtil.simpleClone(card) as BaseTransferBean;
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

  private getFormStackMaxArea(childElement: GridLayoutItemInfo[]): number[] {
    let maxArea: number[] = [1, 1];
    childElement.forEach((item) => {
      if (!item.area) {
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
      let tmpArea = childElement[i].area;
      if (!tmpArea) {
        continue;
      }
      if (tmpArea[0] !== maxArea[0] || tmpArea[1] !== maxArea[1]) {
        // 后续卡片的row不连续，但是不影响相对顺序
        let item: BaseTransferBean = ObjectCopyUtil.simpleClone(childElement[i]) as BaseTransferBean;
        item.layoutWeight = 0;
        rearrange.push(item);
        childElement.splice(i, 1);
      }
    }
  }

  private rearrangeCardFromPage(page: number, item: BaseTransferBean): void {
    for (let curPage = page; curPage < this.screenDataMap.size; curPage++) {
      let screenData = this.screenDataMap.get(curPage);
      if (!screenData) {
        continue;
      }
      let isFind: boolean = this.findAreaInScreen(screenData.occupied, item);
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
      if (formCombine.row === undefined || gridInner.row === undefined || formCombine.column === undefined ||
        gridInner.column === undefined) {
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
   */
  private transferOldLayoutToNewLayout(): void {
    log.showInfo(TAG, 'transferOldLayoutToNewLayout start');
    if (this.screenDataMap.size <= 0) {
      return;
    }
    this.screenDataMap.forEach((value, key) => {
      if (this.isNewLayout) {
        this.transferByScreen(value);
      } else {
        this.transferByScreen(value, false);
      }
    });
  }

  /**
   * 将screenDataMap中的元素按照屏数从小到大排序
   */
  private sortScreenDataMap(): void {
    let newSortMap: Map<number, ScreenTransferBean> = new Map();
    let keyArr: number[] = [];
    this.screenDataMap.forEach((value, key) => {
      keyArr.push(key);
    });
    keyArr.sort((x1, x2) => x1 - x2);
    keyArr.forEach(item => {
      let mData = this.screenDataMap.get(item);
      if (mData) {
        newSortMap.set(item, mData);
      }
    });
    this.screenDataMap = newSortMap;
  }

  /**
   * 对当前屏进行布局转换
   * @param screenData 当前屏所有元素
   * @param isNewPage 当前屏是否为新增的一屏，新增一屏的元素按照焕新方案排列
   */
  private transferByScreen(screenData: ScreenTransferBean, isNewPage?: boolean): void {
    this.preprocessScreenData(screenData);
    this.realignScreenData(screenData, isNewPage);
  }

  /**
   * 将当前屏的元素按照焕新或者维持方案进行重新排列
   * @param screenData 当前屏所有元素
   * @param isNewPage 当前屏是否为新增的一屏，新增一屏的元素按照焕新方案排列
   */
  private realignScreenData(screenData: ScreenTransferBean, isNewPage?: boolean): void {
    let occupied: boolean[][] = [];
    this.fillOccupied(occupied, false);
    if (isNewPage || this.isNewLayout) {
      this.realignByRefresh(screenData, occupied);
    } else {
      this.realignByMaintenance(screenData, occupied);
    }
    this.dealWithNeedMoveToNextPage(screenData, occupied);
    // 将每屏的宫格布局记录下来
    screenData.occupied = occupied;
  }

  /**
   * 将当前屏放不下的元素，新增一屏放置，如无法新增则在当前屏形成小文件夹放置
   * @param screenData 当前屏所有元素
   * @param occupied 代表桌面宫格布局的二维数组
   */
  private dealWithNeedMoveToNextPage(screenData: ScreenTransferBean, occupied: boolean[][]): void {
    if (screenData.moveToNextPage.length <= 0) {
      return;
    }
    if (this.toMaxScreen()) {
      log.showInfo(TAG, 'current is max screen, can not add new screen');
      this.makeRestElementFolderToCurrentPage(screenData, occupied);
    } else {
      this.maxScreen++;
      log.showWarn(TAG, `mapDataToCellLayout end need to add screen ${this.maxScreen} ` +
        `screenData.moveToNextPage :${screenData.moveToNextPage.length} `);
      let theLastPage: ScreenTransferBean = this.buildScreenNextPage(screenData.page, this.moveToNextDataMap);
      theLastPage.children = [...screenData.moveToNextPage];
      screenData.moveToNextPage = [];
      this.transferByScreen(theLastPage, true);
    }
  }

  private realignByMaintenance(screenData: ScreenTransferBean, occupied: boolean[][]): void {
    // 以行为单位，存放当前屏的元素
    let rowElementMap: Map<number, number[]> = new Map();
    // 存放当前屏所有天气widget
    let widgetIndexArr: number[] = [];
    // 存放当前屏所有空行
    let emptyRowArr: number[] = [];
    // 遍历当前屏元素，获取所有天气widget和空行
    this.calculateRowElement(screenData, rowElementMap, widgetIndexArr, emptyRowArr);
    // 天气widget变大挤位
    this.regroupWidgetPosition(widgetIndexArr, screenData, emptyRowArr, rowElementMap);
    // 收集当前屏每一行多出来的元素
    let extraElements: number[] = [];
    rowElementMap.forEach((value) => {
      // 一行一行的放置元素
      this.placeElementsByRow(value, screenData, occupied, extraElements);
    });
    // 维持方案一行一行放置完成后，可能存在很多空位，无需填充，多余元素放到下一屏
    this.fillNextPage(extraElements, screenData);
  }

  private fillNextPage(extraElements: number[], screenData: ScreenTransferBean): void {
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

  private calculateRowElement(screenData: ScreenTransferBean, rowElementMap: Map<number, number[]>,
    widgetIndexArr: number[], emptyRowArr: number[]): void {
    let rowElementLenMap: Map<number, number> = new Map();
    for (let i = 0; i < screenData.children.length; i++) {
      let baseTransferBean: BaseTransferBean = screenData.children[i];
      if (baseTransferBean.row === undefined) {
        continue;
      }
      if (!rowElementMap.has(baseTransferBean.row)) {
        rowElementMap.set(baseTransferBean.row, []);
      }
      rowElementLenMap.set(baseTransferBean.row, Math.max(rowElementLenMap.get(baseTransferBean.row) ?? 0,
        baseTransferBean.area?.[1] ?? 0));
      if (baseTransferBean.typeId === CommonConstants.TYPE_CARD && (baseTransferBean.cardName === 'ClockWeatherCard' ||
        baseTransferBean.cardName === 'ClockWeatherHoriCard')) {
        widgetIndexArr.push(i);
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

  private realignByRefresh(screenData: ScreenTransferBean, occupied: boolean[][]): void {
    // 当前屏放不下，需要移动到下一屏的元素
    let needToNextPageIndex: number[] = [];
    for (let i = 0; i < screenData.children.length; i++) {
      let transferBean: BaseTransferBean = screenData.children[i];
      let isFind: boolean = this.findArea(occupied, transferBean);
      if (isFind) {
        this.fillOccupied(occupied, true, transferBean);
      } else {
        log.showInfo(TAG, 'need to put next page item bundleName %{public}s, type %{public}d, row %{public}d, col %{public}d',
          transferBean.bundleName, transferBean.typeId, transferBean.row, transferBean.column);
        screenData.moveToNextPage.push(transferBean);
        needToNextPageIndex.push(i);
      }
    }
    if (needToNextPageIndex && needToNextPageIndex.length > 0) {
      for (let i = needToNextPageIndex.length - 1; i >= 0; i--) {
        screenData.children.splice(needToNextPageIndex[i], 1);
      }
    }
  }

  private regroupWidgetPosition(widgetIndexArr: number[], screenData: ScreenTransferBean, emptyRowArr: number[],
                                rowElementMap: Map<number, number[]>): void {
    if (CheckEmptyUtils.isEmptyArr(widgetIndexArr)) {
      return;
    }
    for (let i = 0; i < widgetIndexArr.length; i++) {
      let widget: BaseTransferBean = screenData.children[widgetIndexArr[i]];
      if (!this.isFirstWidgetProcessed) {
        let preEmptyRow = emptyRowArr.shift();
        if (preEmptyRow !== undefined && widget.row !== undefined && preEmptyRow < widget.row) {
         this.dealNoProcessedRowElementMapIf(rowElementMap, preEmptyRow, widget, screenData);
        } else {
          if (widget.row !== undefined && rowElementMap.has(widget.row + 1)) {
            let lastIndex = preEmptyRow ?? Number.MAX_VALUE;
            this.dealNoProcessedRowElementMapElse(rowElementMap, lastIndex, widget, screenData);
          }
        }
        if (widget.row !== undefined && widget.row > this.toGrid[1] - CommonConstants.NUMBER_TWO) {
          this.dealProcessedRowElementMapIf(rowElementMap, widget, screenData);
        }
        this.isFirstWidgetProcessed = true;
      } else {
        if (widget.row !== undefined && (!rowElementMap.has(widget.row + 1)) || DeviceHelper.isPad()) {
          continue;
        }
        this.dealProcessedRowElementMapElse(rowElementMap, widget, screenData);

      }
    }
  }

  private dealNoProcessedRowElementMapIf(rowElementMap: Map<number, number[]>, preEmptyRow: number,
    widget: BaseTransferBean, screenData: ScreenTransferBean): void {
    let tmpRow = (widget.row ?? 0);
    rowElementMap.forEach((value, key) => {
      if (key <= preEmptyRow || key > tmpRow) {
        return;
      }
      value.forEach(item => {
        let tmpRow = screenData.children[item].row;
        if (tmpRow !== undefined) {
          screenData.children[item].row = tmpRow - 1;
        }
      });
    });
  }

  private dealNoProcessedRowElementMapElse(rowElementMap: Map<number, number[]>, lastIndex: number,
    widget: BaseTransferBean, screenData: ScreenTransferBean): void {
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

  private dealProcessedRowElementMapIf(rowElementMap: Map<number, number[]>,
    widget: BaseTransferBean, screenData: ScreenTransferBean): void {
    let tmpRow = (widget.row ?? 0);
    rowElementMap.forEach((value, key) => {
      if (key > tmpRow) {
        return;
      }
      value.forEach(item => {
        let tmpRow = screenData.children[item].row;
        if (tmpRow !== undefined) {
          screenData.children[item].row = tmpRow - ((widget.row ?? 0) - this.toGrid[1] + 2);
        }
      });
    });
  }

  private dealProcessedRowElementMapElse(rowElementMap: Map<number, number[]>,
    widget: BaseTransferBean, screenData: ScreenTransferBean): void {
    let tmpRow = (widget.row ?? 0);
    rowElementMap.forEach((value, key) => {
      if (key <= tmpRow) {
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

  private placeElementsByRow(curRowElements: number[], screenData: ScreenTransferBean,
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

  private moveNarrowerElements(curRowElements: number[], rowLen: number, emptyLen: number,
                               screenData: ScreenTransferBean, needToNextPageIndex: number[]): void {
    if (emptyLen === 0) {
      return;
    }
    // 优先移app
    rowLen = this.moveElementByType(curRowElements, rowLen, emptyLen, screenData,
      needToNextPageIndex, CommonConstants.TYPE_APP);
    if (rowLen > emptyLen) {
      // 移完app空间仍不够，则移小文件夹
      this.moveElementByType(curRowElements, rowLen, emptyLen, screenData,
        needToNextPageIndex, CommonConstants.TYPE_FOLDER);
    }
  }

  private moveElementByType(curRowElements: number[], rowLen: number, emptyLen: number,
                            screenData: ScreenTransferBean, needToNextPageIndex: number[], type: number): number {
    if (rowLen <= emptyLen) {
      return rowLen;
    }
    let appIndex: number[] = [];
    for (let i = curRowElements.length - 1; i >= 0; i--) {
      if (rowLen <= emptyLen) {
        break;
      }
      if (this.isAppOrSmallFolder(screenData.children[curRowElements[i]]) &&
        screenData.children[curRowElements[i]].typeId === type) {
        appIndex.push(i);
        rowLen--;
      }
    }
    for (let i = 0; i < appIndex.length; i++) {
      needToNextPageIndex.push(curRowElements[appIndex[i]]);
      curRowElements.splice(appIndex[i], 1);
    }
    return rowLen;
  }

  private dealWithLessSpace(curRowElements: number[], occupied: boolean[][], screenData: ScreenTransferBean,
                            needToNextPageIndex: number[]): void {
    for (let j = 0; j < curRowElements.length; j++) {
      if (this.findAreaByRow(occupied, screenData.children[curRowElements[j]], true)) {
        this.fillOccupied(occupied, true, screenData.children[curRowElements[j]]);
      } else {
        needToNextPageIndex.push(curRowElements[j]);
      }
    }
  }

  private dealWithMoreSpace(screenData: ScreenTransferBean, curRowElements: number[], occupied: boolean[][],
                            needToNextPageIndex: number[]): void {
    let last = screenData.children[curRowElements[curRowElements.length - 1]];
    if (last.column === undefined || !last.area) {
      return;
    }
    if (last.column + last.area[0] > this.toGrid[0]) {
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

  private findAreaByRow(occupied: boolean[][], transferBean: BaseTransferBean, fromFirst: boolean = false): boolean {
    log.showInfo(TAG, 'findAreaByRow is fromFirst %{public}s', fromFirst);
    if (!fromFirst && this.validElementArea(occupied, transferBean.area, transferBean.row, transferBean.column)) {
      return true;
    }
    if (transferBean.row === undefined || transferBean.column === undefined) {
      return false;
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

  private findAreaByRowFromLast(occupied: boolean[][], transferBean: BaseTransferBean): boolean {
    if (this.validElementArea(occupied, transferBean.area, transferBean.row, transferBean.column)) {
      return true;
    }
    if (!transferBean.row) {
      return false;
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

  private findEmptyPosition(occupied: boolean[][], row: number): number {
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

  private makeRestElementFolderToCurrentPage(screenData: ScreenTransferBean, occupied: boolean[][],
    notFromCurrentPageElements?: BaseTransferBean[], isNotHamony?: boolean): void {
    let addToCurrentPage: BaseTransferBean[] = [];
    // 未鸿蒙化应用需要收进特殊文件夹
    let isSpecialFolder: boolean = false;
    if (notFromCurrentPageElements && !CheckEmptyUtils.isEmptyArr(notFromCurrentPageElements)) {
      addToCurrentPage = notFromCurrentPageElements;
      isSpecialFolder = isNotHamony ?? false;
    } else {
      this.updateUsedCellCnt(screenData, addToCurrentPage);
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
        if (lastFolder.layoutInfo) {
          this.updateFoldersRowAndColumn(lastFolder.layoutInfo[0]);
        }
        return;
      }
    }
  }

  private replaceLastCardWithFolder(screenData: ScreenTransferBean, occupied: boolean[][],
    addToCurrentPage: BaseTransferBean[],
    isSpecialFolder: boolean): void {
    let lastCard: BaseTransferBean = screenData.children[screenData.children.length - 1];
    screenData.children.splice(screenData.children.length - 1, 1);
    this.fillOccupied(occupied, false, lastCard);
    let restElementFolder: BaseTransferBean | null = this.makeSmallerFolder(addToCurrentPage, isSpecialFolder, false);
    if (!restElementFolder) {
      return;
    }
    this.fillElementInfo(restElementFolder, lastCard);
    let isFind: boolean = this.findArea(occupied, restElementFolder);
    if (isFind) {
      this.fillOccupied(occupied, true, restElementFolder);
      screenData.children.push(restElementFolder);
    }
  }

  private makeNotHarmonyElementToFolder(screenData: ScreenTransferBean, occupied: boolean[][],
    addToCurrentPage: BaseTransferBean[]): void {
    let lastElement: BaseTransferBean | undefined = this.findLastNotSmallContainerFolderElement(screenData);
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
        log.showWarn(TAG,
          `after mergeTwoSmallElement, lastElement bundleName:${lastElement.bundleName} type:${lastElement.typeId}` +
            ` page:${lastElement.page} row:${lastElement.row} column:${lastElement.column} area:${lastElement.area}`);
      }
      return;
    } else if (lastElement.typeId === CommonConstants.TYPE_FOLDER && lastElement.area &&
      (lastElement.area[0] > 1 || lastElement.area[1] > 1)) {
      this.fillOccupied(occupied, false, lastElement);
      lastElement.area = [1, 1];
      this.fillOccupied(occupied, true, lastElement);
      let notHarmonyElementFolder: BaseTransferBean | null = this.makeSmallerFolder(addToCurrentPage, true, false);
      if (!notHarmonyElementFolder) {
        return;
      }
      notHarmonyElementFolder.page = lastElement.page;
      let isFind: boolean = this.findArea(occupied, notHarmonyElementFolder);
      if (isFind) {
        this.fillOccupied(occupied, true, notHarmonyElementFolder);
        screenData.children.push(notHarmonyElementFolder);
      }
      return;
    }
  }

  private findLastNotSmallContainerFolderElement(screenData: ScreenTransferBean): BaseTransferBean | undefined {
    // 从后往前遍历，找到一个非1x1文件夹的元素
    let lastElement: BaseTransferBean | undefined;
    for (let i = screenData.children.length - 1; i >= 0; i--) {
      let tmpArea = screenData.children[i].area;
      if (!tmpArea) {
        continue;
      }
      if (screenData.children[i].typeId !== CommonConstants.TYPE_FOLDER ||
        !DeliverUtil.isContainerFolder(screenData.children[i].folderId) || tmpArea[0] !== 1 ||
        tmpArea[1] !== 1) {
        lastElement = screenData.children[i];
        break;
      }
    }
    return lastElement;
  }

  private mergeTwoSmallElement(screenData: ScreenTransferBean, lastElement: BaseTransferBean): void {
    if (lastElement.typeId === CommonConstants.TYPE_APP || lastElement.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      this.mergeLastAppAndOtherSmallElement(screenData, lastElement);
      return;
    } else if (lastElement.typeId === CommonConstants.TYPE_FOLDER) {
      this.mergeLastSmallFolderAndOtherSmallElement(screenData, lastElement);
      return;
    }
  }

  private mergeLastSmallFolderAndOtherSmallElement(screenData: ScreenTransferBean,
    lastElement: BaseTransferBean): void {
    if (!lastElement.layoutInfo) {
      return;
    }
    for (let i = screenData.children.indexOf(lastElement) - 1; i >= 0; i--) {
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
        !DeliverUtil.isContainerFolder(screenData.children[i].folderId)) {
        lastElement.layoutInfo[0].forEach(item => {
          screenData.children[i].layoutInfo?.[0].push(item);
        });
        this.updateFoldersRowAndColumn(screenData.children[i].layoutInfo?.[0] ?? []);
        return;
      }
    }
  }

  private mergeLastAppAndOtherSmallElement(screenData: ScreenTransferBean, lastElement: BaseTransferBean): void {
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
        !DeliverUtil.isContainerFolder(screenData.children[i].folderId)) {
        let tmpLayoutInfo = screenData.children[i].layoutInfo;
        if (!tmpLayoutInfo) {
          return;
        }
        tmpLayoutInfo[0].push(ObjectCopyUtil.deepClone(lastElement));
        this.updateFoldersRowAndColumn(tmpLayoutInfo[0]);
        return;
      }
    }
  }

  private fillElementInfo(toElement: BaseTransferBean, fromElement: BaseTransferBean): void {
    toElement.row = fromElement.row;
    toElement.column = fromElement.column;
    toElement.page = fromElement.page;
  }

  private updateUsedCellCnt(screenData: ScreenTransferBean, addToCurrentPage: BaseTransferBean[]): void {
    screenData.moveToNextPage.forEach(item => {
      if (!item.area) {
        return;
      }
      if (item.typeId === CommonConstants.TYPE_CARD || item.typeId === CommonConstants.TYPE_FORM_STACK ||
        item.typeId === CommonConstants.TYPE_FORM_COMBINE) {
        screenData.abilityFormUsedCellCnt -= item.area[0] * item.area[1];
        screenData.usedCellCnt -= item.area[0] * item.area[1];
      } else if (item.typeId === CommonConstants.TYPE_APP || item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        screenData.iconUsedCellCnt -= item.area[0] * item.area[1];
        screenData.usedCellCnt -= item.area[0] * item.area[1];
        addToCurrentPage.push(item);
        log.showInfo(TAG, `the element need make to folder is %{public}s`, item.bundleName);
      } else if (item.typeId === CommonConstants.TYPE_FOLDER) {
        if (item.area[0] === 1 && item.area[1] === 1) {
          screenData.iconUsedCellCnt -= item.area[0] * item.area[1];
        }
        screenData.usedCellCnt -= item.area[0] * item.area[1];
        item.layoutInfo?.[0].forEach(item => {
          let icon: BaseTransferBean = ObjectCopyUtil.simpleClone(item) as BaseTransferBean;
          icon.layoutWeight = 0;
          addToCurrentPage.push(icon);
          log.showInfo(TAG, `the element need make to folder is %{public}s`, icon.bundleName);
        });
      }
    });
  }

  private fillOccupiedForPc(occupied: boolean[][], fillValue: boolean, isPortrait: boolean,
    transferBean?: BaseTransferBean): void {
    if (transferBean) {
      if (!transferBean.area || transferBean.row === undefined) {
        return;
      }
      let rowSpan: number = transferBean.row + transferBean.area[1];
      if (isPortrait) {
        for (let i = transferBean.row; i < rowSpan; i++) {
          occupied[i].fill(fillValue, transferBean.column, (transferBean.column ?? 0) + transferBean.area[0]);
        }
      } else {
        rowSpan = (transferBean.landscapeRow ?? 0) + transferBean.area[1];
        for (let i = (transferBean.landscapeRow ?? 0); i < rowSpan; i++) {
          occupied[i].fill(fillValue, transferBean.landscapeColumn, (transferBean.landscapeColumn ?? 0) +
            transferBean.area[0]);
        }
      }
      log.showWarn(TAG, `fill element ${fillValue}, bundleName:${transferBean.bundleName} ${transferBean?.formStackId} type:${transferBean.typeId}` +
        ` page:${transferBean.page} row:${transferBean.row} column:${transferBean.column} area:${transferBean.area} landscapeRow ${transferBean.landscapeRow}
        landscapeColumn ${transferBean.landscapeColumn}, landscapePage ${transferBean.landscapePage}`);
    } else {
      for (let i = 0; i < this.toGrid[1]; i++) {
        let item: boolean[] = new Array(this.toGrid[0]);
        item.fill(fillValue, 0, item.length);
        occupied[i] = item;
      }
    }
  }

  private fillOccupied(occupied: boolean[][], fillValue: boolean, transferBean?: BaseTransferBean): void {
    if (transferBean) {
      if (!transferBean.area || transferBean.row === undefined || transferBean.column === undefined) {
        return;
      }
      let rowSpan: number = transferBean.row + transferBean.area[1];
      for (let i = transferBean.row; i < rowSpan; i++) {
        occupied[i].fill(fillValue, transferBean.column, transferBean.column + transferBean.area[0]);
      }
      log.showWarn(TAG, `fill element ${fillValue}, bundleName:${transferBean.bundleName} ${transferBean?.formStackId} type:${transferBean.typeId}` +
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
   * @param occupied 桌面宫格
   * @param transferBean 单个布局元素
   * @returns
   */
  private findArea(occupied: boolean[][], transferBean: BaseTransferBean | null): boolean {
    if (!transferBean) {
      return false;
    }
    for (let i = 0; i < occupied.length; i++) {
      for (let j = 0; j < occupied[0].length; j++) {
        if (occupied[i][j]) {
          continue;
        }
        if (this.validElementArea(occupied, transferBean.area, i, j)) {
          transferBean.row = i;
          transferBean.column = j;
          // 避免将宽度为2的元素放在一行的中间两个位置
          if (this.isNewLayout && (DeviceHelper.isPhone() || DeviceHelper.isFold())) {
            if (transferBean.area && transferBean.area[0] === 2 && transferBean.column === 1) {
              transferBean.column += 1;
            }
          }
          return true;
        }
      }
    }
    return false;
  }

  private validElementArea(occupied: boolean[][], area: number [] | undefined, fromIndexX: number | undefined,
    fromIndexY: number | undefined): boolean {
    if (occupied == null || fromIndexX === undefined || fromIndexX < 0 || !area ||
      area.length <= 1 || fromIndexY === undefined) {
      return false;
    }
    let xSpan: number = area[1] + fromIndexX;
    let ySpan: number = area[0] + fromIndexY;
    if (xSpan > this.toGrid[1] || ySpan > this.toGrid[0]) {
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
   * sort page element
   * @param lhs
   * @param rhs
   * @returns
   */
  private compare(lhs: BaseTransferBean, rhs: BaseTransferBean): number {
    if (lhs.layoutWeight < rhs.layoutWeight) {
      return -1;
    } else if (lhs.layoutWeight > rhs.layoutWeight) {
      return 1;
    } else {
      if ((lhs.row ?? 0) < (rhs.row ?? 0)) {
        return -1;
      } else if ((lhs.row ?? 0) > (rhs.row ?? 0)) {
        return 1;
      }
      if ((lhs.column ?? 0) < (rhs.column ?? 0)) {
        return -1;
      } else if ((lhs.column ?? 0) > (rhs.column ?? 0)) {
        return 1;
      }
      return (lhs.id ?? 0) - (rhs.id ?? 0);
    }
  }

  /**
   * 生成当前屏每个元素的权重，便于将元素按照权重从小到大放置
   * 校验元素宽高
   * 统计当前屏各种元素的数量
   * @param screenData
   */
  private preprocessScreenData(screenData: ScreenTransferBean): void {
    for (let childrenElement of screenData.children) {
      if (!childrenElement.area || childrenElement.row === undefined || childrenElement.column === undefined ||
        childrenElement.page === undefined) {
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
      if (this.isAppOrSmallFolder(childrenElement)) {
        screenData.iconUsedCellCnt += childrenElement.area[0] * childrenElement.area[1];
      }
      if (childrenElement.typeId === CommonConstants.TYPE_CARD ||
        childrenElement.typeId === CommonConstants.TYPE_FORM_STACK ||
        childrenElement.typeId === CommonConstants.TYPE_FORM_COMBINE) {
        screenData.abilityFormUsedCellCnt += childrenElement.area[0] * childrenElement.area[1];
      }
      screenData.usedCellCnt += childrenElement.area[0] * childrenElement.area[1];
    }
    screenData.children.sort((x1, x2) => this.compare(x1, x2));
  }

  /**
   * 以屏为单位收集旧布局列表，便于后续一屏一屏地进行布局转换处理
   * @param oldLayoutInfo
   * @returns
   */
  private async collectOldLayoutByScreen(oldLayoutInfo: GridLayoutItemInfo[]): Promise<void> {
    log.showInfo(TAG, 'collectOldLayoutByScreen start');
    this.manyToOneReplace(oldLayoutInfo);
    oldLayoutInfo = oldLayoutInfo.filter(item => {
      // 过滤并收集克隆应用应用
      if (this.isNeedAddTodeliverFolder(item)) {
        let icon: BaseTransferBean = ObjectCopyUtil.simpleClone(item) as BaseTransferBean;
        icon.layoutWeight = 0;
        log.showWarn(TAG, `deliver tong app bundleName: ${icon.bundleName}, appIndex: ${icon.appIndex}`);
        this.deliverTongList.push(icon);
        return false;
      }
      // 过滤并收集应用应用
      if (this.isNeedAddToEasyAbroadFolder(item)) {
        let icon: BaseTransferBean = ObjectCopyUtil.simpleClone(item) as BaseTransferBean;
        icon.layoutWeight = 0;
        log.showWarn(TAG, `eazy abroad app bundleName: ${icon.bundleName}, appIndex: ${icon.appIndex}`);
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
        log.showWarn(TAG, `the not harmony app bundleName: ${icon.bundleName}, appIndex: ${icon.appIndex}`);
        this.notHarmonyList.push(icon);
        return NotHarmonyUtil.CANCEL_NOT_HARMONY_FOLDER;
      }
      // 克隆场景过滤并收集新增一屏解散的组合卡片
      if (this.isClone && item.typeId === CommonConstants.TYPE_FORM_COMBINE &&
        item.container !== CommonConstants.CONTAINER_DESKTOP && item?.layoutInfo &&
        !CheckEmptyUtils.isEmptyArr(item?.layoutInfo[0]) ) {
        let disbandLayoutInfo: GridLayoutItemInfo[] = this.disbandFormCombine(item);
        disbandLayoutInfo.forEach(disbandItem => {
          let disbandCombineFrom: BaseTransferBean = ObjectCopyUtil.simpleClone(disbandItem) as BaseTransferBean;
          disbandCombineFrom.layoutWeight = 0;
          log.showInfo(TAG, `collect disbanded combo cards,container:${item?.container},cardid:${disbandItem?.cardId}`);
          this.disbandCombFormList.push(disbandCombineFrom);
        });
        return false;
      }
      return true;
    });
    for (let gridItem of oldLayoutInfo) {
      if (gridItem.container === CommonConstants.CONTAINER_DESKTOP) {
        this.collectDesktop(gridItem, oldLayoutInfo);
      } else if (gridItem.container === CommonConstants.CONTAINER_DOCK) {
        this.collectSmartDock(gridItem, oldLayoutInfo);
      } else if (gridItem.container === CommonConstants.CONTAINER_UNIQUE_SINGLE) {
        let icon: BaseTransferBean = ObjectCopyUtil.simpleClone(gridItem) as BaseTransferBean;
        icon.layoutWeight = 0;
        log.showWarn(TAG, `the single unique app is ${icon.bundleName},type:${icon?.typeId}`);
        this.otherList.push(icon);
      } else if (gridItem.container && gridItem.container > 0 && DeviceHelper.isPC()) {
        this.collectDesktop(gridItem, oldLayoutInfo);
      }
    }
    this.sortScreenDataMap();
    this.dealRestScreen();
  }

  private manyToOneReplace(oldLayoutInfo: GridLayoutItemInfo[]): void {
    // 将每一组多对一替换的应用分别收集起来，排序后保留第一个
    let manyToOneMapping: Map<string, GridLayoutItemInfo[]> = new Map();
    oldLayoutInfo.forEach(item => {
      if (CommonUtils.jsonStrToMap(item.intent).get('multiMappingRelationship') !== 1) {
        return;
      }
      if (manyToOneMapping.has(item.bundleName)) {
        manyToOneMapping.get(item.bundleName)?.push(item);
      } else {
        manyToOneMapping.set(item.bundleName, [item]);
      }
    });

    for (const myEntry of manyToOneMapping.entries()) {
      let key = myEntry[0];
      let value = myEntry[1];
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

  private isNeedAddToNotHarmnoyFolder(item: GridLayoutItemInfo): boolean {
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

  private isNeedAddTodeliverFolder(item: GridLayoutItemInfo): boolean {
    if (item.typeId !== CommonConstants.TYPE_APP) {
      return false;
    }
    let intentMap: Map<string, Object> = CommonUtils.jsonStrToMap(item.intent);
    if (intentMap.get(NotHarmonyUtil.INSTALL_SOURCE) !== DeliverUtil.DELIVER_APPSTORE_PKG) {
      return false;
    }
    if (DataConvert.isNotHarmonyManyToOne(item.bundleName)) {
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

  private compareAppItem(a: GridLayoutItemInfo, b: GridLayoutItemInfo): number {
    // 将分身排在最前面
    if (a.appIndex !== b.appIndex) {
      return this.compareNumber(b.appIndex, a.appIndex);
    }
    //桌面平铺 > 文件夹
    if (a.container !== b.container) {
      // 工作区 > Dock区
      if ((a.container ?? 0) < 0 && (b.container ?? 0) < 0) {
        return this.compareNumber(b.container, a.container);
      }
      return this.compareNumber(a.container, b.container);
    }
    //根据页码排序
    if (a.page !== b.page) {
      return this.compareNumber(a.page, b.page);
    }
    //根据行数排序
    if (a.row !== b.row) {
      return this.compareNumber(a.row, b.row);
    }
    //根据列数排序
    return this.compareNumber(a.column, b.column);
  }

  private compareNumber(a: number | undefined, b: number | undefined): number {
    return (a ?? 0) - (b ?? 0);
  }

  /**
   * 如果超过18屏，将多余的屏合并到第18屏
   */
  private dealRestScreen(): void {
    if (this.screenDataMap.size <= this.maxScreenCount) {
      return;
    }
    let keysArr = Array.from(this.screenDataMap.keys());
    let theLastPage = this.screenDataMap.get(keysArr[this.maxScreenCount - 1]);
    for (let i = this.maxScreenCount; i < keysArr.length; i++) {
      let curPage = this.screenDataMap.get(keysArr[i]);
      if (curPage === undefined) {
        continue;
      }
      curPage.children.forEach(item => {
        item.page = theLastPage?.page;
        item.row = (item.row ?? 0) + this.toGrid[1] * ((curPage?.page ?? 0) - (theLastPage?.page ?? 0));
        theLastPage?.children.push(item);
      });
      this.screenDataMap.delete(curPage.page);
    }
  }

  /**
   * 将dock区多余的元素和设备特有元素根据不同方案加至不同的屏幕
   */
  private dealRestDockAndSingleUniqueElement(): void {
    log.showInfo(TAG, 'dealRestDockAndSingleUniqueElement start');
    this.dockList.sort((x1, x2) => (x1.column ?? 0) - (x2.column ?? 0));
    this.loadMaxDockNumFromConfig();
    while (this.dockList.length > this.maxDockNum) {
      this.restDockList.push(this.dockList.pop() as BaseTransferBean);
    }
    this.restDockList.sort((x1, x2) => (x1.column ?? 0) - (x2.column ?? 0));
    // 将卡片放置最后插入
    this.otherList.sort((x1, x2) => x1.settlementPosition?.localeCompare(x2.settlementPosition ?? '') ?? 0);
    if (!this.isClone) {
      this.otherList.forEach(item => {
        item.settlementPosition = '';
        this.restDockList.push(item);
      });
    }
    // 避免转换后布局超过18屏
    if (this.maxScreen >= this.maxScreenCount || this.screenDataMap.size >= this.maxScreenCount) {
      let screenMapSize: number = this.screenDataMap.size;
      for (let i: number = this.maxScreenCount; i < screenMapSize; i++) {
        let childs: BaseTransferBean[] | undefined = this.screenDataMap.get(i)?.children;
        if (!childs) {
          continue;
        }
        if (!this.isClone) {
          this.restDockList.push(...childs);
        } else {
          this.otherList.push(...childs);
        }
        this.screenDataMap.delete(i);
      }
      this.maxScreen = this.screenDataMap.size;
    }
    if (this.restDockList.length <= 0 && !this.isClone) {
      return;
    }
    this.dealWithDockAndOtherList();
  }

  private dealWithDockAndOtherList(): void {
    if (this.screenDataMap.size <= 0) {
      this.buildScreenPage(0, this.screenDataMap);
    }
    // 克隆场景处理dock区多余元素,升级场景处理dock区多余元素和新机特有元素
    if (this.restDockList.length > 0) {
      if (!this.isBigFold) {
        this.addRestDockToCurrentPage(1, this.restDockList);
      } else {
        this.addRestDockToCurrentPage(2, this.restDockList);
      }
    }
    // 克隆场景要单独处理新机屏元素
    if (this.isClone && this.otherList.length > 0) {
      this.addRestDockToCurrentPage(this.maxScreen, this.otherList);
    }
  }

  /**
   * 从指定屏幕开始往后找空位放置多余的dock区元素和设备独有的元素
   * @param startPage 起始屏幕
   * @param dockOrUniqueElements 多余的dock元素集合或设备独有的元素
   */
  private addRestDockToCurrentPage(startPage: number, dockOrUniqueElements :BaseTransferBean[]): void {
    let needToMakeFolderElements: BaseTransferBean[] = [];
    let findStartPage = startPage;
    dockOrUniqueElements.forEach(item => {
      let isFind = false;
      for (let i = findStartPage; i < this.screenDataMap.size; i++) {
        let curPage = this.screenDataMap.get(i);
        if (!curPage) {
          continue;
        }
        if (CheckEmptyUtils.isEmptyArr(curPage.occupied)) {
          this.fillOccupied(curPage.occupied, false);
        }
        isFind = this.findArea(curPage.occupied, item);
        if (isFind) {
          item.page = i;
          item.container = CommonConstants.CONTAINER_DESKTOP;
          curPage.children.push(item);
          this.fillOccupied(curPage.occupied, true, item);
          findStartPage = item.page;
          break;
        }
      }
      if (!isFind) {
        if (this.toMaxScreen() || this.maxScreen >= this.maxScreenCount) {
          // 先收集起来
          needToMakeFolderElements.push(item);
        } else {
          // 新增一页放置
          let curPage = this.buildScreenPage(this.maxScreen, this.screenDataMap);
          log.showInfo(TAG, `theNewPage is ${curPage.page}`);
          this.fillOccupied(curPage.occupied, false);
          item.row = 0;
          item.column = 0;
          item.page = curPage.page;
          item.container = CommonConstants.CONTAINER_DESKTOP;
          curPage.children.push(item);
          this.fillOccupied(curPage.occupied, true, item);
          findStartPage = curPage.page;
          this.maxScreen++;
        }
      }
    });
    if (CheckEmptyUtils.isEmptyArr(needToMakeFolderElements)) {
      return;
    }
    log.showWarn(TAG, `needToMakeFolderElements size: ${needToMakeFolderElements.length}`);
    let theLastPage = this.screenDataMap.get(this.maxScreen - 1);
    let filterNotAppElements: BaseTransferBean[] = [];
    // 18屏场景过滤非应用元素,如果有文件夹则解析后写入
    needToMakeFolderElements.forEach((item: BaseTransferBean) => {
      if (item.typeId === CommonConstants.TYPE_APP || item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        filterNotAppElements.push(item);
      }
      // 18屏场景dock区多出的第五个元素可能是文件夹
      if (item.typeId === CommonConstants.TYPE_FOLDER && !CheckEmptyUtils.isEmptyArr(item?.layoutInfo)) {
        item.layoutInfo?.flat().forEach((floderChildrenItem: GridLayoutItemInfo) => {
          let backUpItem: BaseTransferBean = ObjectCopyUtil.simpleClone(floderChildrenItem) as BaseTransferBean;
          backUpItem.layoutWeight = 0;
          filterNotAppElements.push(backUpItem);
        });
      }
    });
    if (!theLastPage) {
      return;
    }
    // 18屏为新机元素时，计算屏幕使用空间
    for (let childrenElement of theLastPage.children) {
      if (!childrenElement.area) {
        continue;
      }
      theLastPage.usedCellCnt += childrenElement.area[0] * childrenElement.area[1];
    }
    this.makeRestElementFolderToCurrentPage(theLastPage, theLastPage?.occupied, filterNotAppElements, false);
  }

  /**
   * 新建屏幕，存放某一屏转换后的元素
   *
   * @param screenPage 屏数
   * @param screenDataMap key为屏数，value为每一屏的所有元素
   * @returns 新增的屏幕
   */
  private buildScreenPage(screenPage: number, screenDataMap: Map<number, ScreenTransferBean>): ScreenTransferBean {
    let theNewPage: ScreenTransferBean = new ScreenTransferBean();
    theNewPage.page = screenPage;
    screenDataMap.set(screenPage, theNewPage);
    return theNewPage;
  }

  /**
   * 新建屏幕，存放某一屏放不下的元素
   *
   * @param screenPage 屏数
   * @param screenDataMap key为屏数，value为这一屏的需要新增的屏幕元素
   * @returns 新增的屏幕
   */
  private buildScreenNextPage(screenPage: number, screenDataMap: Map<number, ScreenTransferBean[]>):
    ScreenTransferBean {
    let theNewPage: ScreenTransferBean = new ScreenTransferBean();
    theNewPage.page = screenPage;
    if (screenDataMap.has(screenPage)) {
      let screenPages: ScreenTransferBean[] | undefined = screenDataMap.get(screenPage);
      if (screenPages) {
        screenPages.push(theNewPage);
        screenDataMap.set(screenPage, screenPages);
      }
    } else {
      screenDataMap.set(screenPage, [theNewPage]);
    }
    return theNewPage;
  }

  private collectDesktop(dataElement: GridLayoutItemInfo, data: GridLayoutItemInfo[]): void {
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
      let stackInfo: BaseTransferBean[] | null = this.validAndCollectFormStack(dataElement, data);
      if (stackInfo && stackInfo.length > 0) {
        for (let i = 0; i < stackInfo.length; i++) {
          this.putPageData(stackInfo[i]);
        }
      }
    } else if (dataElement.typeId === CommonConstants.TYPE_FORM_COMBINE) {
      let combineTransferBean: BaseTransferBean = ObjectCopyUtil.simpleClone(dataElement) as BaseTransferBean;
      combineTransferBean.layoutWeight = 0;
      if (combineTransferBean.layoutInfo && !CheckEmptyUtils.isEmptyArr(combineTransferBean.layoutInfo[0])) {
        this.putPageData(combineTransferBean);
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

  private collectSmartDock(dataElement: GridLayoutItemInfo, data: GridLayoutItemInfo[]): void {
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
    if (DeviceHelper.isPC() && dataElement.typeId === CommonConstants.TYPE_FUNCTION) {
      let scbFunction: BaseTransferBean = ObjectCopyUtil.simpleClone(dataElement) as BaseTransferBean;
      scbFunction.layoutWeight = 0;
      this.dockList.push(scbFunction);
    }
  }

  private putPageData(dataElement: BaseTransferBean): void {
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

  private isAppOrSmallFolder(item: GridLayoutItemInfo): boolean {
    if (!item || !item.area) {
      return false;
    }
    return (item.typeId === CommonConstants.TYPE_FOLDER && item.area[0] === 1 && item.area[1] === 1) ||
      item.typeId === CommonConstants.TYPE_APP || item.typeId === CommonConstants.TYPE_SHORTCUT_ICON;
  }

  private validAndCollectFolder(dataElement: GridLayoutItemInfo, dataList: GridLayoutItemInfo[],
    container: number): BaseTransferBean | null {
    let folder: BaseTransferBean = ObjectCopyUtil.simpleClone(dataElement) as BaseTransferBean;
    folder.layoutWeight = 0;
    let childElement: GridLayoutItemInfo[] = [];
    if (dataElement.layoutInfo && !CheckEmptyUtils.isEmptyArr(dataElement.layoutInfo[0])) {
      log.showInfo(TAG, `the folder has layoutInfo, folderName: ${dataElement.folderName}, flodersize: ${dataElement.layoutInfo[0].length}`);
      childElement = dataElement.layoutInfo[0];
    } else {
      childElement = dataList.filter(item => item.container === dataElement.id);
    }
    if (childElement.length === 0) {
      return null;
    }
    if (childElement.length === 1 && !DeliverUtil.isContainerItem(folder.intent)) {
      childElement[0].page = dataElement.page;
      childElement[0].row = dataElement.row;
      childElement[0].column = dataElement.column;
      childElement[0].area = [1, 1];
      let icon: BaseTransferBean = ObjectCopyUtil.simpleClone(childElement[0]) as BaseTransferBean;
      icon.layoutWeight = 0;
      icon.container = container;
      return icon;
    }
    childElement = this.filterFolderDuplicateElement(childElement);
    childElement.sort((x1, x2) => {
      let x1Weight = (x1.page ?? 0) * (this.toGrid[0] * this.toGrid[1]) + (x1.row ?? 0) * this.toGrid[1] +
        (x1.column ?? 0);
      let x2Weight = (x2.page ?? 0) * (this.toGrid[0] * this.toGrid[1]) + (x2.row ?? 0) * this.toGrid[1] +
        (x2.column ?? 0);
      return x1Weight - x2Weight;
    });
    this.updateFoldersRowAndColumn(childElement);
    let folderName = folder.folderName ?? '';
    if (folderName.includes(this.defaultFolderName)) {
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
   * @returns 过滤后的文件夹列表
   */
  private filterFolderDuplicateElement<T extends GridLayoutItemInfo>(childElement: T[]): T[] {
    let childKeySet: Set<string> = new Set();
    let newChildElement: T[] = childElement.filter(item => {
      let itemKey: string = this.generateGridLayoutItemKey(item);
      if (childKeySet.has(itemKey)) {
        log.showInfo(TAG, 'the item %{public}s is duplicated in folder', itemKey);
        return false;
      }
      childKeySet.add(itemKey);
      return true;
    });
    log.showInfo(TAG, 'filterFolderDuplicateElement before length %{public}d after length %{public}d',
      childElement.length, newChildElement.length);
    return newChildElement;
  }

  private generateGridLayoutItemKey(item: GridLayoutItemInfo): string {
    return `${item.bundleName}${item.moduleName}${item.abilityName}${item.appIndex ?? 0}${item.typeId}${item.shortcutId}`;
  }

  private validAndCollectFormStack(dataElement: GridLayoutItemInfo, dataList: GridLayoutItemInfo[]):
    BaseTransferBean[] | null {
    let stackInfo: BaseTransferBean = ObjectCopyUtil.simpleClone(dataElement) as BaseTransferBean;
    stackInfo.layoutWeight = 0;
    let childElement: GridLayoutItemInfo[] = dataList.filter(item => item.container === dataElement.id);
    if (childElement.length === 0) {
      return null;
    }
    childElement.sort((x1, x2) => (x1.row ?? 0) - (x2.row ?? 0));
    let cards: GridLayoutItemInfo[] = [];
    let combines: GridLayoutItemInfo[] = [];
    for (let i = 0; i < childElement.length; i++) {
      if (childElement[i].typeId === CommonConstants.TYPE_CARD) {
        cards.push(childElement[i]);
      } else {
        combines.push(childElement[i]);
      }
    }
    let returnResult: BaseTransferBean[] = [];
    if (cards.length === 0) {
      let tmpCom = combines.shift();
      if (tmpCom) {
        cards.push(tmpCom);
      }
    }
    if (cards.length === 1) {
      cards[0].page = dataElement.page;
      cards[0].row = dataElement.row;
      cards[0].column = dataElement.column;
      let form: BaseTransferBean = ObjectCopyUtil.simpleClone(cards[0]) as BaseTransferBean;
      form.layoutWeight = 0;
      form.container = CommonConstants.CONTAINER_DESKTOP;
      returnResult.push(form);
      this.putCombineCard(combines, dataElement, returnResult);
    } else {
      for (let i = 0; i < cards.length; i++) {
        cards[i].column = i;
        cards[i].row = 0;
      }
      if (dataElement.infoId) {
        stackInfo.formStackId = dataElement.infoId;
      } else {
        stackInfo.formStackId = dataElement.formStackId;
      }
      stackInfo.layoutInfo = [cards];
      returnResult.push(stackInfo);
      this.putCombineCard(combines, dataElement, returnResult);
    }
    return returnResult;
  }

  private putCombineCard(combines: GridLayoutItemInfo[], dataElement: GridLayoutItemInfo,
    returnResult: BaseTransferBean[]): void {
    for (let i = 0; i < combines.length; i++) {
      let form: BaseTransferBean = ObjectCopyUtil.simpleClone(combines[i]) as BaseTransferBean;
      form.page = dataElement.page;
      form.layoutWeight = 0;
      form.container = CommonConstants.CONTAINER_DESKTOP;
      form.row = NumberConstants.CONSTANT_NUMBER_100;
      returnResult.push(form);
    }
  }

  private makeSmallerFolder(gridLayoutArr: BaseTransferBean[], isSpecialFolder: boolean = false,
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
      } else if (installSource === DeliverUtil.ABROAD_APP_PKG) {
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

  private updateFoldersRowAndColumn(childElement: GridLayoutItemInfo[]): void {
    let folderMaxPageCount = MAX_FOLDER_COLUMN_COUNT * MAX_FOLDER_ROW_COUNT;
    for (let i = 0; i < childElement.length; i++) {
      childElement[i].page = Math.floor(i / folderMaxPageCount);
      childElement[i].row = Math.floor((i - (childElement[i].page ?? 0) * folderMaxPageCount) /
        MAX_FOLDER_COLUMN_COUNT);
      childElement[i].column = i % MAX_FOLDER_COLUMN_COUNT;
    }
  }

  private toMaxScreen(): boolean {
    let nextPageNum: number = 0;
    this.moveToNextDataMap.forEach((value, key) => {
      nextPageNum += value.length;
    });
    return this.screenDataMap.size + nextPageNum >= this.maxScreenCount;
  }

  /**
   *  从配置文件读取Dock区可放置元素的最大个数，若没有则使用布局的列数
   */
  private loadMaxDockNumFromConfig(): void {
    try {
      let cfgFile: string = ConfigParseUtil.getConfigSync(GRID_LAYOUT_CONFIG_PATH);
      if (CheckEmptyUtils.checkStrIsEmpty(cfgFile)) {
        this.maxDockNum = this.toGrid[0];
        log.showWarn(TAG, 'cfgFile is empty, maxDockNum = ' + this.maxDockNum);
        return;
      }
      const cfgJson: ICfgJson = FileUtils.readJsonFile(cfgFile);
      const config = cfgJson?.dockConfig;
      const maxResidentListLength = config?.maxResidentListLength;
      this.maxDockNum = maxResidentListLength ?? this.toGrid[0];
      log.showInfo(TAG, 'read dock list length config JSON success, maxDockNum = ' + this.maxDockNum);
    } catch (e) {
      this.maxDockNum = this.toGrid[0];
      log.showError(TAG, 'read dock list length config JSON fail ' + e);
    }
  }
}

export interface ICfgJson {
  dockConfig: IBaseCfgInfo
}

export interface IBaseCfgInfo {
  maxResidentListLength: number;
}
