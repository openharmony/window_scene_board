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
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import {
  AppStatus,
  CardItemInfo,
  GridLayoutConfig,
  LaunchLayoutCacheManager,
  StyleConstants
} from '../../TsIndex';
import { LauncherLayoutCacheUtil } from './LauncherLayoutCacheUtil';
import { DefaultDesktopLayoutInfo } from '../../TsIndex';
import { DesktopLayoutCacheData } from './DesktopLayoutCacheData';
import { CommonConstants, EventConstants } from '../../TsIndex';
import { GlobalContext } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { ResourceManager } from '@ohos/frameworkwrapper';
import prompt from '@ohos.promptAction';
import { systemParameterEnhance } from '@kit.BasicServicesKit';

const TAG = 'PadLaunchLayoutCacheManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const POSITION_INFO_INDEX_TWO = 2;
const DEFAULT_SCREEN_ANGLE: number = 270;
const PORTRAIT_SCREEN_ANGLE: number = 0;

export class PadLaunchLayoutCacheManager extends LaunchLayoutCacheManager {
  protected isPortraitMode: boolean = false;
  protected isGridConfigInit: boolean = false;
  private static padInstance: PadLaunchLayoutCacheManager;
  protected oldLandRowColumnList: RowColumnList[] = [];
  protected oldPortraitRowColumnList: RowColumnList[] = [];
  private beforeRotateLandRowColumnList: RowColumnList[] = [];
  private beforeRotatePortraitRowColumnList: RowColumnList[] = [];
  private defaultRotate: boolean = false;

  protected constructor() {
    super();
    LauncherLayoutCacheUtil.setUpdateLandscapeCacheCb((info: DefaultDesktopLayoutInfo) => this.updateLandscapeCacheData(info));
    LauncherLayoutCacheUtil.setUpdatePortraitCacheCb((info: DefaultDesktopLayoutInfo) => this.updatePortraitCacheData(info));
  }

  static getInstance(): PadLaunchLayoutCacheManager {
    if (PadLaunchLayoutCacheManager.padInstance == null) {
      PadLaunchLayoutCacheManager.padInstance = new PadLaunchLayoutCacheManager();
    }
    return PadLaunchLayoutCacheManager.padInstance;
  }

  public getIsGridConfigInit(): boolean {
    return this.isGridConfigInit;
  }

  public reInit(layoutCacheData: DesktopLayoutCacheData): void {
    super.reInit(layoutCacheData);
    this.isGridConfigInit = false;
    let screenHeight: number = AppStorage.get('screenHeight') as number;
    let screenWidth: number = AppStorage.get('screenWidth') as number;
    if (!screenHeight || !screenWidth) {
      log.showError(`screenHeight or screenWidth is empty! screenHeight：${screenHeight}, screenWidth：${screenWidth}`);
      return;
    }
    if (this.isPortraitMode !== screenWidth < screenHeight) {
      log.showWarn(`isPortraitMode is wrong mismatch screen!  screenHeight：${screenHeight}, screenWidth：${screenWidth}`);
      this.isPortraitMode = screenWidth < screenHeight;
    }
    log.showInfo(`reInit PortraitMode: ${this.isPortraitMode}`);
    LauncherLayoutCacheUtil.firstRotateTagCorrect();
    this.getDefaultRotatePowerOn();
  }

  /**
   * 获取设备默认开机角度，当前MLR平板开机默认为0度，其余pad默认为270度
   * 0度为默认竖屏，270度为默认横屏
   */
  private getDefaultRotatePowerOn(): void {
    let defaultScreenRotation: number = DEFAULT_SCREEN_ANGLE;
    try {
      defaultScreenRotation = Number.parseInt(systemParameterEnhance.getSync('const.window.device.default_screen_rotation', '-1'));
    } catch (e) {
      log.showError('get default_screen_rotation failed!');
    }
    log.showInfo(`defaultScreenRotation: ${defaultScreenRotation}`);
    if (defaultScreenRotation === PORTRAIT_SCREEN_ANGLE) {
      this.defaultRotate = true;
      return;
    }
    this.defaultRotate = false;
  }

  /**
   * 是否是默认竖屏平板MLR首次重启场景，此时firstRotate为true但是是竖屏状态
   */
  public defaultPortraitDeviceFirstRotate(): boolean {
    return this.defaultRotate && LauncherLayoutCacheUtil.getIsFirstRotate();
  }


  public initLayoutByRestore(layoutCacheData: DesktopLayoutCacheData): void {
  }

  /**
   * 切换横竖屏缓存
   *
   * @param isPortrait 是否切到竖屏缓存
   */
  changeCurrentLayoutCacheData(isPortrait: boolean, mPageIndex?: number): void {
    log.showWarn('changeCurrentLayoutCacheData isPortrait: %{public}s -> %{public}s, mPageIndex: %{public}d, isGridConfigInit: %{public}s',
      this.isPortraitMode, isPortrait, mPageIndex, this.isGridConfigInit);
    if (this.isPortraitMode === isPortrait) {
      return;
    }
    this.isPortraitMode = isPortrait;
    if (!this.isGridConfigInit) {
      LauncherLayoutCacheUtil.setIsPadPortrait(isPortrait);
      this.layoutCacheData.setIsPad(true);
      log.showWarn('changeCurrentLayoutCacheData isGridConfigInit not init');
      return;
    }
    if (isPortrait) {
      this.changeCurrentLayoutCacheDataPortrait(isPortrait);
    } else {
      this.changeCurrentLayoutCacheDataLandscape(isPortrait);
    }
    // 派发修改缓存通知
    GlobalContext.getContext()?.eventHub.emit(EventConstants.CHANGE_CURRENT_LAYOUT_CACHE_DATA);
  }

  protected changeCurrentLayoutCacheDataPortrait(isPortrait: boolean): void {
    let layoutInfo: DefaultDesktopLayoutInfo = this.layoutCacheData.getGridLayoutInfo();
    log.showWarn('land to portrait start');
    layoutInfo.layoutInfo.forEach(LauncherLayoutCacheUtil.padDeviceItemPositionLog);
    this.fixRotatePositionIfMiss(layoutInfo, isPortrait);
    this.layoutCacheData.setLandscapeLayoutInfo(this.cloneCache(layoutInfo));
    let duplicatePositionPage: number[] = this.getInValidPositionPage(isPortrait);
    let isNeedRotateAlgorithms = false;
    if (duplicatePositionPage.length > 0) {
      isNeedRotateAlgorithms = true;
    }
    log.showInfo(`land to portrait isNeedRotateAlgorithms:${isNeedRotateAlgorithms}`);
    let portraitLayout: DefaultDesktopLayoutInfo = LauncherLayoutCacheUtil
      .getRotateLayout(layoutInfo, isPortrait, duplicatePositionPage, [], isNeedRotateAlgorithms);
    if (LauncherLayoutCacheUtil.getIsFirstRotate() || isNeedRotateAlgorithms) {
      portraitLayout.layoutInfo.forEach(item => {
        let landItem = this.layoutCacheData.getLandscapeLayoutInfo()?.layoutInfo.find(landLayoutItem => {
          return landLayoutItem.landscapeRow === item.landscapeRow && landLayoutItem.page === item.page &&
            landLayoutItem.landscapeColumn === item.landscapeColumn;
        });
        if (!landItem) {
          log.showWarn(`changeCurrentLayoutCacheDataPortrait landItem: ${JSON.stringify(item)}`);
          return;
        }
        landItem.portraitRow = item.row;
        landItem.portraitColumn = item.column;
        landItem.portraitPage = item.page;
      });
      LauncherLayoutCacheUtil.putIsFirstRotate(false);
      LauncherLayoutCacheUtil.updateRotatePositionToDB(this.layoutCacheData.getLandscapeLayoutInfo()?.layoutInfo ?? []);
    }
    this.layoutCacheData.setPortraitLayoutInfo(portraitLayout);
    LauncherLayoutCacheUtil.setPortraitDesktopLayoutInfo(portraitLayout);
    this.layoutCacheData.changePadPortraitMode(true);
    LauncherLayoutCacheUtil.setIsPadPortrait(true);
    log.showWarn('land to portrait finish');
    portraitLayout.layoutInfo.forEach(LauncherLayoutCacheUtil.padDeviceItemPositionLog);
  }

  private getInValidPositionPage(isPortrait: boolean, isPortraitModePowerOn: boolean = false): number[] {
    if (LauncherLayoutCacheUtil.getIsFirstRotate() && !this.defaultPortraitDeviceFirstRotate()) {
      return [];
    }
    let outOfBoundPage: number[] = [];
    let duplicatePositionPage: number[] = [];
    outOfBoundPage = this.getOutOfBoundPage(isPortrait, isPortraitModePowerOn);
    duplicatePositionPage = this.getDuplicatePositionPage(isPortrait);
    let inValidPositionPage: number[] = Array.from(new Set([...outOfBoundPage, ...duplicatePositionPage]));
    log.showInfo(`inValidPositionPage:${inValidPositionPage.toString()}`);
    return inValidPositionPage;
  }

  private getOutOfBoundPage(isPortrait: boolean, isPortraitModePowerOn: boolean = false): number[] {
    let outOfBoundPage: number[] = [];
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutInfo().layoutInfo;
    const layoutInfo = this.layoutCacheData.getGridLayoutInfo();
    let row = isPortraitModePowerOn ? layoutInfo.layoutDescription.row : layoutInfo.layoutDescription.column;
    let column = isPortraitModePowerOn ? layoutInfo.layoutDescription.column : layoutInfo.layoutDescription.row;
    log.showWarn(`isPortraitModePowerOn:${isPortraitModePowerOn}, row:${row},column:${column}`);
    for (let i = 0; i < gridLayoutItemList.length; i++) {
      let mPage = gridLayoutItemList[i].page;
      if (isPortrait) {
        if (this.isPortItemOutOfBound(gridLayoutItemList[i], row, column) ||
          (mPage !== undefined && mPage < 0)) {
          log.showError('layout has invalid page or column or row. maxColumn:%{public}d, maxRow:%{public}d. ' +
            'layout info is {page:%{public}d, column:%{public}d, row:%{public}d, width:%{public}d, height:%{public}d, ' +
            'typeId:%{public}d, bundleName:%{public}s, cardId:%{public}s, folderId:%{public}s, formStackId:%{public}s}',
            column, row, gridLayoutItemList[i].page, gridLayoutItemList[i].column, gridLayoutItemList[i].row,
            gridLayoutItemList[i].area?.[0], gridLayoutItemList[i].area?.[1], gridLayoutItemList[i].typeId,
            gridLayoutItemList[i].bundleName, gridLayoutItemList[i].cardId, gridLayoutItemList[i].folderId,
            gridLayoutItemList[i].formStackId);
          outOfBoundPage.push(mPage);
        }
      } else {
        if (this.isLandItemOutOfBound(gridLayoutItemList[i], row, column) ||
          (mPage !== undefined && mPage < 0)) {
          log.showError('layout has invalid page or column or row. maxColumn:%{public}d, maxRow:%{public}d. ' +
            'layout info is {page:%{public}d, column:%{public}d, row:%{public}d, width:%{public}d, height:%{public}d, ' +
            'typeId:%{public}d, bundleName:%{public}s, cardId:%{public}s, folderId:%{public}s, formStackId:%{public}s}',
            column, row, gridLayoutItemList[i].page, gridLayoutItemList[i].column, gridLayoutItemList[i].row,
            gridLayoutItemList[i].area?.[0], gridLayoutItemList[i].area?.[1], gridLayoutItemList[i].typeId,
            gridLayoutItemList[i].bundleName, gridLayoutItemList[i].cardId, gridLayoutItemList[i].folderId,
            gridLayoutItemList[i].formStackId);
          outOfBoundPage.push(mPage);
        }
      }
    }
    return outOfBoundPage;
  }

  private isPortItemOutOfBound(item: GridLayoutItemInfo, layoutRow: number, layoutCol: number): boolean {
    return item.portraitRow === undefined || item.portraitColumn === undefined ||
      item.portraitPage === undefined || item.area === undefined ||
      (item.portraitRow < 0 || item.portraitRow + item.area[1] - 1 >= layoutRow) ||
      (item.portraitColumn < 0 || item.portraitColumn + item.area[0] - 1 >= layoutCol);
  }

  private isLandItemOutOfBound(item: GridLayoutItemInfo, layoutRow: number, layoutCol: number): boolean {
    return item.landscapeRow === undefined || item.landscapeColumn === undefined ||
      item.landscapePage === undefined || item.area === undefined ||
      (item.landscapeRow < 0 || item.landscapeRow + item.area[1] - 1 >= layoutRow) ||
      (item.landscapeColumn < 0 || item.landscapeColumn + item.area[0] - 1 >= layoutCol);
  }

  private getDuplicatePositionPage(isPortrait: boolean): number[] {
    const mPositionInfo: number[][] = [];
    let duplicatePositionPage: number[] = [];
    let gridLayoutItemList: GridLayoutItemInfo[] = this.layoutCacheData.getGridLayoutInfo().layoutInfo;
    for (let i = 0; i < gridLayoutItemList.length; i++) {
      if (CheckEmptyUtils.isEmptyArr(gridLayoutItemList[i].area) || gridLayoutItemList[i].area?.length !== StyleConstants.DEFAULT_2) {
        continue;
      }
      if (isPortrait) {
        this.getPortraitDuplicatePosition(gridLayoutItemList[i], mPositionInfo);
      } else {
        this.getLandDuplicatePosition(gridLayoutItemList[i], mPositionInfo);
      }
    }
    for (let i = 0; i < mPositionInfo.length; i++) {
      for (let j = mPositionInfo.length - 1; j > 0 && j > i; j--) {
        if (mPositionInfo[i][0] === mPositionInfo[j][0] &&
          mPositionInfo[i][1] === mPositionInfo[j][1] &&
          mPositionInfo[i][POSITION_INFO_INDEX_TWO] === mPositionInfo[j][POSITION_INFO_INDEX_TWO]) {
          LauncherLayoutCacheUtil.printDuplicateInfo(mPositionInfo[i][0], mPositionInfo[i][1],
            mPositionInfo[i][POSITION_INFO_INDEX_TWO], gridLayoutItemList);
          duplicatePositionPage.push(mPositionInfo[i][0]);
        }
      }
    }
    return duplicatePositionPage;
  }

  private getPortraitDuplicatePosition(gridLayoutItem: GridLayoutItemInfo, mPositionInfo: number[][]): void {
    if (!gridLayoutItem.area) {
      return;
    }
    for (let j = 0; j < gridLayoutItem.area[1]; j++) {
      for (let k = 0; k < gridLayoutItem.area[0]; k++) {
        const position: number[] = [];
        position[0] = gridLayoutItem.page ?? 0;
        position[1] = (gridLayoutItem.portraitRow ?? 0) + j;
        position[POSITION_INFO_INDEX_TWO] = (gridLayoutItem.portraitColumn ?? 0) + k;
        mPositionInfo.push(position);
      }
    }
  }

  private getLandDuplicatePosition(gridLayoutItem: GridLayoutItemInfo, mPositionInfo: number[][]): void {
    if (!gridLayoutItem.area) {
      return;
    }
    for (let j = 0; j < gridLayoutItem.area[1]; j++) {
      for (let k = 0; k < gridLayoutItem.area[0]; k++) {
        const position: number[] = [];
        position[0] = gridLayoutItem.page ?? 0;
        position[1] = (gridLayoutItem.landscapeRow ?? 0) + j;
        position[POSITION_INFO_INDEX_TWO] = (gridLayoutItem.landscapeColumn ?? 0) + k;
        mPositionInfo.push(position);
      }
    }
  }

  private fixRotatePositionIfMiss(layoutInfo: DefaultDesktopLayoutInfo, isPortrait: Boolean): void {
    if (isPortrait) {
      layoutInfo.layoutInfo.forEach(item => {
        item.landscapeRow = item.row;
        item.landscapeColumn = item.column;
        item.landscapePage = item.page;
      });
    } else {
      layoutInfo.layoutInfo.forEach(item => {
        item.portraitRow = item.row;
        item.portraitColumn = item.column;
        item.portraitPage = item.page;
      });
    }
  }

  protected changeCurrentLayoutCacheDataLandscape(isPortrait: boolean): void {
    let layoutInfo: DefaultDesktopLayoutInfo = this.layoutCacheData.getGridLayoutInfo();
    log.showWarn('portrait to land start');
    layoutInfo.layoutInfo.forEach(LauncherLayoutCacheUtil.padDeviceItemPositionLog);
    this.fixRotatePositionIfMiss(layoutInfo, isPortrait);
    this.layoutCacheData.setPortraitLayoutInfo(this.cloneCache(layoutInfo));
    let duplicatePositionPage: number[] = this.getInValidPositionPage(isPortrait);
    let isNeedRotateAlgorithms = false;
    if (duplicatePositionPage.length > 0) {
      isNeedRotateAlgorithms = true;
    }
    log.showInfo(`portrait to land isNeedRotateAlgorithms:${isNeedRotateAlgorithms}`);
    let landscapeLayout = LauncherLayoutCacheUtil
      .getRotateLayout(layoutInfo, isPortrait, duplicatePositionPage, [], isNeedRotateAlgorithms);
    if (isNeedRotateAlgorithms) {
      LauncherLayoutCacheUtil.updateRotatePositionToDB(landscapeLayout.layoutInfo);
    }
    this.layoutCacheData.setLandscapeLayoutInfo(landscapeLayout);
    LauncherLayoutCacheUtil.setLandscapeDesktopLayoutInfo(landscapeLayout);
    this.layoutCacheData.changePadPortraitMode(false);
    LauncherLayoutCacheUtil.setIsPadPortrait(false);
    log.showWarn('portrait to land finish');
    landscapeLayout.layoutInfo.forEach(LauncherLayoutCacheUtil.padDeviceItemPositionLog);
  }

  /**
   * 初始化缓存
   */
  public initGridConfig(gridConfig: GridLayoutConfig): void {
    if (this.isGridConfigInit && this.layoutCacheData.getPortraitLayoutInfo()) {
      log.showWarn('initGridConfig return');
      return;
    }
    let curLayout: DefaultDesktopLayoutInfo = this.cloneCache(this.layoutCacheData.getGridLayoutInfo());
    log.showWarn(`poweron isPortraitMode: ${this.isPortraitMode}`);
    if (gridConfig && curLayout.layoutDescription) {
      curLayout.layoutDescription.row = this.isPortraitMode ? gridConfig.column : gridConfig.row;
      curLayout.layoutDescription.column = this.isPortraitMode ? gridConfig.row : gridConfig.column;
    }
    this.isGridConfigInit = true;
    // 设置pad双缓存
    LauncherLayoutCacheUtil.setIsLazyRotate(true);
    let landscapeLayoutInfo: DefaultDesktopLayoutInfo = curLayout;
    // 初始化横竖屏缓存
    this.initLandscapeLayoutInfo(landscapeLayoutInfo);
    let portraitLayout: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
    if (LauncherLayoutCacheUtil.getPadRotateAfterBackup()) {
      log.showWarn(`getPadRotateAfterBackup`);
      this.initPortraitLayoutInfoAfterBackup(landscapeLayoutInfo, portraitLayout);
      LauncherLayoutCacheUtil.setPadRotateAfterBackup(false);
    } else {
      this.initPortraitLayoutInfo(landscapeLayoutInfo, portraitLayout);
    }
    this.layoutCacheData.setLandscapeLayoutInfo(landscapeLayoutInfo);
    LauncherLayoutCacheUtil.setLandscapeDesktopLayoutInfo(landscapeLayoutInfo);
    // 设定pad状态
    LauncherLayoutCacheUtil.setIsPadPortrait(this.isPortraitMode);
    this.layoutCacheData.changePadPortraitMode(this.isPortraitMode);
  }

  private initLandscapeLayoutInfo(landscapeLayoutInfo: DefaultDesktopLayoutInfo): void {
    landscapeLayoutInfo.layoutInfo.forEach(item => {
      item.landscapeRow = item.row;
      item.landscapeColumn = item.column;
      item.landscapePage = item.page;
    });
  }

  private initPortraitLayoutInfo(landscapeLayoutInfo: DefaultDesktopLayoutInfo, portraitLayout: DefaultDesktopLayoutInfo): void {
    let isNeedRotateAlgorithms = false;
    let duplicatePositionPage: number[] = [];
    if (!LauncherLayoutCacheUtil.getIsFirstRotate() || this.defaultPortraitDeviceFirstRotate()) {
      duplicatePositionPage = this.getInValidPositionPage(true, this.isPortraitMode);
      if (duplicatePositionPage.length > 0) {
        isNeedRotateAlgorithms = true;
      }
    }
    log.showWarn(`initPortraitLayoutInfo:${isNeedRotateAlgorithms}, duplicatePositionPage:${duplicatePositionPage.toString()}`);
    portraitLayout = LauncherLayoutCacheUtil.getRotateLayout(landscapeLayoutInfo, true, duplicatePositionPage, [], isNeedRotateAlgorithms);
    if (!LauncherLayoutCacheUtil.getIsFirstRotate() || this.defaultPortraitDeviceFirstRotate()) {
      portraitLayout.layoutInfo.forEach(item => {
        let landItem = landscapeLayoutInfo.layoutInfo.find(landLayoutItem => {
          return landLayoutItem.landscapeRow === item.landscapeRow && landLayoutItem.landscapePage === item.landscapePage &&
            landLayoutItem.landscapeColumn === item.landscapeColumn;
        });
        if (!landItem) {
          log.showWarn(`initPortraitLayoutInfo landItem: ${JSON.stringify(item)}`);
          return;
        }
        landItem.portraitRow = item.row;
        landItem.portraitColumn = item.column;
        landItem.portraitPage = item.page;
      });
    }
    if (isNeedRotateAlgorithms && !this.defaultPortraitDeviceFirstRotate()) {
      let updateItemList: GridLayoutItemInfo[] = landscapeLayoutInfo.layoutInfo.filter(item => {
        return duplicatePositionPage.includes(item.page ?? -1);
      });
      LauncherLayoutCacheUtil.updateRotatePositionToDB(updateItemList);
    }
    if (this.defaultPortraitDeviceFirstRotate()) {
      LauncherLayoutCacheUtil.putIsFirstRotate(false);
      let updateList = landscapeLayoutInfo.layoutInfo.filter(item => {
        return item.typeId !== CommonConstants.TYPE_CARD;
      })
      LauncherLayoutCacheUtil.updateRotatePositionToDB(updateList);
    }
    this.layoutCacheData.setPortraitLayoutInfo(portraitLayout);
    LauncherLayoutCacheUtil.setPortraitDesktopLayoutInfo(portraitLayout);
  }

  private initPortraitLayoutInfoAfterBackup(landscapeLayoutInfo: DefaultDesktopLayoutInfo, portraitLayout: DefaultDesktopLayoutInfo): void {
    let pageCount: number = landscapeLayoutInfo.layoutDescription.pageCount;
    let needForceRotatePage: number[] = [];
    let noNeedForceRotatePage: number[] = [];
    this.getBackupChangePage(needForceRotatePage, noNeedForceRotatePage, pageCount, landscapeLayoutInfo);
    let portraitCacheList = ObjectCopyUtil.deepClone(landscapeLayoutInfo.layoutInfo.filter(item => {
      return noNeedForceRotatePage.includes(item.page ?? -1);
    }));
    portraitLayout = LauncherLayoutCacheUtil.getRotateLayout(landscapeLayoutInfo, true, needForceRotatePage, [], true);
    let portraitChangeList = portraitLayout.layoutInfo.filter(item => {
      return needForceRotatePage.includes(item.page ?? -1);
    })
    portraitLayout.layoutInfo.forEach(item => {
      if (noNeedForceRotatePage.includes(item.page ?? -1)) {
        return;
      }
      let landItem = landscapeLayoutInfo.layoutInfo.find(landLayoutItem => {
        return landLayoutItem.landscapeRow === item.landscapeRow && landLayoutItem.landscapePage === item.landscapePage &&
          landLayoutItem.landscapeColumn === item.landscapeColumn;
      });
      if (!landItem) {
        log.showWarn(`initPortraitLayoutInfoAfterBackup landItem: ${JSON.stringify(item)}`);
        return;
      }
      landItem.portraitRow = item.row ?? 0;
      landItem.portraitColumn = item.column ?? 0;
      landItem.portraitPage = item.page ?? -1;
    });
    portraitLayout.layoutInfo = [...portraitChangeList, ...portraitCacheList];
    if (this.isPortraitMode) {
      this.updatePositionIfPortrait(portraitLayout, landscapeLayoutInfo);
    }
    LauncherLayoutCacheUtil.updateRotatePositionToDB(landscapeLayoutInfo.layoutInfo);
    this.layoutCacheData.setPortraitLayoutInfo(portraitLayout);
    LauncherLayoutCacheUtil.setPortraitDesktopLayoutInfo(portraitLayout);
  }

  private updatePositionIfPortrait(portraitLayout: DefaultDesktopLayoutInfo, landscapeLayoutInfo: DefaultDesktopLayoutInfo): void {
    portraitLayout.layoutInfo.forEach(item => {
      item.row = item.portraitRow;
      item.column = item.portraitColumn;
      item.page = item.portraitPage;
    })
    landscapeLayoutInfo.layoutInfo.forEach(item => {
      item.row = item.landscapeRow;
      item.column = item.landscapeColumn;
      item.page = item.landscapePage;
    })
  }

  private getBackupChangePage(needForceRotatePage: number[], noNeedForceRotatePage: number[], pageCount: number,
    landscapeLayoutInfo: DefaultDesktopLayoutInfo): void {
    for (let selectPage = 0; selectPage < pageCount; selectPage++) {
      let selectPageLayoutList = landscapeLayoutInfo.layoutInfo.filter(item => {
        return item.page === selectPage;
      });
      for (let i = 0; i < selectPageLayoutList.length; i++) {
        if (CheckEmptyUtils.isEmpty(selectPageLayoutList[i].portraitRow) ||
        CheckEmptyUtils.isEmpty(selectPageLayoutList[i].portraitColumn) || CheckEmptyUtils.isEmpty(selectPageLayoutList[i].portraitPage)) {
          log.showWarn(`selectPageLayoutList1: ${JSON.stringify(selectPageLayoutList[i])}`);
          needForceRotatePage.push(selectPage);
          break;
        }
        if (selectPageLayoutList[i].portraitPage !== selectPage) {
          log.showWarn(`selectPageLayoutList2: ${JSON.stringify(selectPageLayoutList[i])}`);
          needForceRotatePage.push(selectPage);
          break;
        }
        if (i === selectPageLayoutList.length - 1) {
          noNeedForceRotatePage.push(selectPage)
        }
      }
    }
    log.showWarn(`needForceRotatePage: ${JSON.stringify(needForceRotatePage)}, noNeedForceRotatePage:${JSON.stringify(noNeedForceRotatePage)}`);
  }

  protected cloneCache(desktopLayoutInfo: DefaultDesktopLayoutInfo): DefaultDesktopLayoutInfo {
    let result: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
    result.layoutDescription = {
      pageCount: desktopLayoutInfo.layoutDescription.pageCount,
      row: desktopLayoutInfo.layoutDescription.row,
      column: desktopLayoutInfo.layoutDescription.column,
      maxPage: desktopLayoutInfo.layoutDescription.maxPage,
      maxForm: desktopLayoutInfo.layoutDescription.maxForm
    };
    result.layoutInfo = JSON.parse(JSON.stringify(desktopLayoutInfo.layoutInfo));
    return result;
  }

  public isNeedCheckDragAble(index: number, item: GridLayoutItemInfo, dragItemType: number): boolean {
    if (!item || !item.area || item.area.length < 2) {
      return false;
    }
    // 1*1 元素不需要校验，能够落位的位置，当前屏有空位旋转屏必定有空位
    let isOverIconItemDrag: boolean = (item.area[0] > 1 || item.area[1] > 1);
    if (!isOverIconItemDrag) {
      log.showInfo('isNeedCheckDragAble true element is 1*1');
      return false;
    }
    // 当前页桌面工作区元素的拖拽不需要校验，双缓存不需要改变对应旋转屏的布局
    log.showWarn(`index:${index},item.page:${item.page}`)
    let isOverPageDrag: boolean = (item.page !== index);
    if (!isOverPageDrag && dragItemType === CommonConstants.DRAG_FROM_DESKTOP) {
      log.showWarn('current page drag return！');
      return false;
    }
    let isAddableForRotate: boolean = LauncherLayoutCacheUtil
      .isAddableForRotate(this.layoutCacheData.getGridLayoutInfo(), index, item.area[0], item.area[1]);
    if (LauncherLayoutCacheUtil.getIsFirstRotate() || !isAddableForRotate) {
      log.showInfo(`isAddableForRotate when first or can not find position: ${isAddableForRotate}`);
      if (!isAddableForRotate) {
        prompt.showToast({
          message: ResourceManager.getInstance().getStringByName('content_add_toast')
        });
      }
      return !isAddableForRotate;
    }
    let isAddable: boolean = LauncherLayoutCacheUtil
      .checkIfElementsIsAddable(this.layoutCacheData.getGridLayoutItemList(), index, item);
    if (!isAddable && LauncherLayoutCacheUtil.isAddableDefault(this.layoutCacheData.getGridLayoutInfo(), index, item.area[0], item.area[1])) {
      let result: boolean = LauncherLayoutCacheUtil.forceRotatePage(this.layoutCacheData.getGridLayoutItemList(), index, item);
      log.showInfo(`result: ${result}`)
    }
    return !isAddableForRotate;
  }

  getPortraitMode(): boolean {
    return this.isPortraitMode;
  }

  /**
   * 刷新横屏缓存
   * @param desktopLayoutInfo
   */
  public updateLandscapeCacheData(desktopLayoutInfo: DefaultDesktopLayoutInfo): void {
    log.showInfo('updateLandscapeCacheData');
    if (desktopLayoutInfo) {
      this.layoutCacheData.setLandscapeLayoutInfo(desktopLayoutInfo);
    }
  }

  /**
   * 刷新竖屏缓存
   * @param desktopLayoutInfo
   */
  public updatePortraitCacheData(desktopLayoutInfo: DefaultDesktopLayoutInfo): void {
    log.showInfo('updatePortraitCacheData');
    if (desktopLayoutInfo) {
      this.layoutCacheData.setPortraitLayoutInfo(desktopLayoutInfo);
    }
  }

  /**
   * 根据竖屏缓存更新横屏缓存
   *
   * @param isNeedOperationDb true需要数据库操作，false不需要
   */
  public updateLandscapeCacheFromPortrait(isNeedOperationDb: boolean, updatePages?: number[]): void {
    if (this.isPortraitMode) {
      let newLandscapeLayout: DefaultDesktopLayoutInfo = LauncherLayoutCacheUtil.getRotateLayout(
        this.layoutCacheData.getGridLayoutInfo(), false, updatePages);
      let oldLandscapeLayout: DefaultDesktopLayoutInfo | null = this.layoutCacheData.getLandscapeLayoutInfo();
      this.layoutCacheData.setLandscapeLayoutInfo(newLandscapeLayout);
      if (isNeedOperationDb && oldLandscapeLayout) {
        let changedItems: GridLayoutItemInfo[] = LauncherLayoutCacheUtil.getChangedLayout(newLandscapeLayout, oldLandscapeLayout);
        log.showWarn(`updateLandscapeCacheFromPortrait changedItems ${changedItems.length}`);
        try {
          LauncherLayoutCacheUtil.updateItemToDesktopCallBack(changedItems);
        } catch (error) {
          log.showError('updateLandscapeCacheFromPortrait with error %{public}s', error.message);
        }
      }
    }
  }

  protected cloneInitAllLayout(isPortrait: boolean): void {
    let rowColumnList: RowColumnList[] = [];
    let layoutInfo =
      isPortrait ? this.layoutCacheData.getPortraitLayoutInfo() : this.layoutCacheData.getLandscapeLayoutInfo();
    if (!layoutInfo || !layoutInfo.layoutDescription) {
      if (isPortrait) {
        this.oldPortraitRowColumnList = rowColumnList;
      } else {
        this.oldLandRowColumnList = rowColumnList;
      }
      return;
    }
    if (isPortrait) {
      for (let i = 0; i < layoutInfo.layoutDescription.pageCount; i++) {
        let oldPortraitRowColumnObj = new RowColumnList();
        let portraitLayoutInfo = layoutInfo.layoutInfo.filter(item => item.page === i);
        oldPortraitRowColumnObj.pageIndex = i;
        oldPortraitRowColumnObj.rowColumn = this.gridLayoutData(portraitLayoutInfo);
        rowColumnList.push(oldPortraitRowColumnObj);
      }
      this.oldPortraitRowColumnList = rowColumnList;
    } else {
      for (let i = 0; i < layoutInfo.layoutDescription.pageCount; i++) {
        let oldLandRowColumnObj = new RowColumnList();
        let landLayoutInfo = layoutInfo.layoutInfo.filter(item => item.page === i);
        oldLandRowColumnObj.pageIndex = i;
        oldLandRowColumnObj.rowColumn = this.gridLayoutData(landLayoutInfo);
        rowColumnList.push(oldLandRowColumnObj);
      }
      this.oldLandRowColumnList = rowColumnList;
    }
  }

  private getItemGridLayoutData(item: GridLayoutItemInfo, rowColumnList: string[]): void {
    if (!item || !item.area || item.area.length !== StyleConstants.DEFAULT_2) {
      return;
    }
    let rowColumn = [item.row, item.column, item.area[0], item.area[1]];
    if (item.typeId === CommonConstants.TYPE_FOLDER || item.typeId === CommonConstants.TYPE_FORM_STACK) {
      item.layoutInfo?.flat().forEach((child: GridLayoutItemInfo) => {
        rowColumn.push(this.getUniqueId(child));
      });
    } else {
      rowColumn.push(this.getUniqueId(item));
    }
    rowColumnList.push(rowColumn.join(','));
  }

  /**
   * 获取GridLayoutItemInfo唯一id
   * @returns GridLayoutItemInfo唯一id
   */
  private getUniqueId(item: GridLayoutItemInfo): number {
    let uniqueId: number = 0;
    try {
      if (item.typeId === CommonConstants.TYPE_APP) {
        if (item.id) {
          uniqueId = item.id;
        } else if (item.appIconId) {
          uniqueId = item.appIconId;
        } else if (item.applicationLabelId) {
          uniqueId = item.applicationLabelId;
        }
        if (item.appStatus && item.appStatus !== AppStatus.INSTALLED) {
          // 非安装完成的应用用小数点区分
          uniqueId = this.string2number(item.infoId ?? '') + this.string2number((item.appStatus * 0.1).toFixed(1));
        }
      } else if (item.typeId === CommonConstants.TYPE_CARD) {
        if (item.id) {
          uniqueId = item.id;
        } else if (item.cardId) {
          uniqueId = this.string2number(item.cardId);
        }
        if (uniqueId === 0 && item.appLabelId) {
          uniqueId = item.appLabelId;
        }
      } else if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        if (item.appIconId) {
          uniqueId = item.appIconId;
        } else if (item.applicationLabelId) {
          uniqueId = item.applicationLabelId;
        } else if (item.id) {
          uniqueId = item.id;
        }
      } else if (item.id) {
        uniqueId = item.id;
      }
    } catch (error) {
      log.showError('getUniqueId error %{public}s', error.message);
    }
    return uniqueId;
  }

  private gridLayoutData(layoutInfo: GridLayoutItemInfo[]): string[] {
    let rowColumnList: string[] = [];
    for (let i = 0; i < layoutInfo.length; i++) {
      this.getItemGridLayoutData(layoutInfo[i], rowColumnList);
    }
    return rowColumnList;
  }

  private string2number(id: string | number): number {
    let result = Number(id);
    return Number.isNaN(result) ? 0 : result;
  }

  protected getChangePages(isPortrait: boolean, isAllPage?: boolean): number[] {
    if (!this.layoutCacheData) {
      return [];
    }
    let layoutInfo: DefaultDesktopLayoutInfo | null =
      isPortrait ? this.layoutCacheData.getLandscapeLayoutInfo() : this.layoutCacheData.getPortraitLayoutInfo();
    if (!layoutInfo || !layoutInfo.layoutInfo) {
      return [];
    }
    let pageCount = layoutInfo.layoutDescription.pageCount;
    if (isAllPage) {
      let pages: number[] = [];
      for (let i = 0; i < pageCount; i++) {
        pages.push(i);
      }
      return pages;
    }
    let changePages: number[] = [];
    let oldRowColumn = isPortrait ? this.oldLandRowColumnList : this.oldPortraitRowColumnList;
    for (let pageIndex = 0; pageIndex < pageCount; pageIndex++) {
      let newRowColumn = this.getLayoutBeforeRotate(layoutInfo, pageIndex);
      if (this.isRowColumnChange(oldRowColumn, newRowColumn, pageIndex)) {
        log.showInfo(`pageCount: ${pageCount} changePages.push: ${pageIndex}`);
        changePages.push(pageIndex);
      }
    }
    return changePages;
  }

  private getLayoutBeforeRotate(layoutInfo: DefaultDesktopLayoutInfo, mPageIndex: number): string[] {
    let beforeRotateLandRowColumnList: string[] = [];
    if (layoutInfo && layoutInfo.layoutInfo) {
      let beforeRotateLandLayoutInfo = layoutInfo.layoutInfo.filter(item => item.page === mPageIndex);
      beforeRotateLandRowColumnList = this.gridLayoutData(beforeRotateLandLayoutInfo);
    }
    return beforeRotateLandRowColumnList;
  }

  private isRowColumnChange(oldRowColumnList: RowColumnList[], newRowColumn: string[], mPageIndex: number): boolean {
    let oldRowColumn: string[] = [];
    for (let i = 0; i < oldRowColumnList.length; i++) {
      if (oldRowColumnList[i].pageIndex === mPageIndex) {
        oldRowColumn = oldRowColumnList[i].rowColumn;
        break;
      }
    }
    log.showInfo(`oldRowColumn[${mPageIndex}] ${JSON.stringify(oldRowColumn)}`);
    if (oldRowColumn.length !== newRowColumn.length) {
      log.showInfo(`check Layout changes before after length mismatch, newRowColumn: ${JSON.stringify(newRowColumn)}`);
      return true;
    }
    let equalsNum: number = 0;
    for (let i = 0; i < newRowColumn.length; i++) {
      for (let j = 0; j < oldRowColumn.length; j++) {
        if (newRowColumn[i] === oldRowColumn[j]) {
          equalsNum++;
          break;
        }
      }
    }
    if (equalsNum !== newRowColumn.length) {
      log.showInfo(`check Layout changes before after element mismatch, newRowColumn ${JSON.stringify(newRowColumn)}`);
      return true;
    }
    return false;
  }

  public isRowColumnChangeBeforeRotate(mPageIndex: number, newRowColumn: string[]): boolean {
    let currentLandLayout = this.layoutCacheData.getLandscapeLayoutInfo();
    let currentPortraitLayout = this.layoutCacheData.getPortraitLayoutInfo();
    if (!this.isPortraitMode && currentLandLayout) {
      let currentPageLandRowColumnList: string[] = [];
      let currentLandLayoutInfo = currentLandLayout.layoutInfo.filter(item => item.page === mPageIndex);
      currentPageLandRowColumnList = this.gridLayoutData(currentLandLayoutInfo);
      let oldLandItem: RowColumnList | undefined =
        this.beforeRotateLandRowColumnList.find(item => item.pageIndex === mPageIndex);
      if (!oldLandItem) {
        log.showError(`check Layout changes oldLandItem is empty!`);
        return true;
      }
      let oldLandItemRowColumn = oldLandItem.rowColumn;
      if (oldLandItemRowColumn.toString() !== currentPageLandRowColumnList.toString()) {
        log.showWarn(`check Layout changes before beforeRotateLand, newRowColumn ${JSON.stringify(newRowColumn)}`);
        return true;
      }
    }
    if (this.isPortraitMode && currentPortraitLayout) {
      let currentPagePortraitRowColumnList: string[] = [];
      let currentPortraitLayoutInfo = currentPortraitLayout.layoutInfo.filter(item => item.page === mPageIndex);
      currentPagePortraitRowColumnList = this.gridLayoutData(currentPortraitLayoutInfo);
      let oldPortraitItem: RowColumnList | undefined =
        this.beforeRotatePortraitRowColumnList.find(item => item.pageIndex === mPageIndex);
      if (!oldPortraitItem) {
        log.showError(`check Layout changes oldPortraitItem is empty!`);
        return true;
      }
      let oldPortraitItemRowColumn = oldPortraitItem.rowColumn;
      if (oldPortraitItemRowColumn.toString() !== currentPagePortraitRowColumnList.toString()) {
        log.showWarn(`check Layout changes before beforeRotatePortrait, newRowColumn ${JSON.stringify(newRowColumn)}`);
        return true;
      }
    }
    return false;
  }
}

class RowColumnList {
  pageIndex: number = -1;
  rowColumn: string[] = [];
}