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
import { AppCenterGridStyleConfig } from '../AppCenterGridStyleConfig';
import { layoutConfigManager, AppItemInfo, StyleConstants } from '@ohos/launchercommon';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { PinyinSort } from '@ohos/frameworkpinyin';
import FeatureConstants from '../constants/FeatureConstants';
import { AppLayoutInfo } from './AppLayoutInfo';
import { AppGridStyleConfig } from '@ohos/launchercommon';
import { AppCenterDragMgr } from '../../controller/AppCenterDragMgr';
import { HashMap } from '@kit.ArkTS';
import AppGridLayoutCacheManager from '../cache/AppGridLayoutCacheManager';
import LayoutConstants from '../../constants/LayoutConstants';
// import SearchClient from '@hms.ai.search';
import { AppCenterSearchResultModel } from '../model/AppCenterSearchResultModel';
import { AppCenterSearchResultTask } from '../model/AppCenterSearchResultTask';
import { AppCenterDynamicEffects } from './AppCenterDynamicEffects';
import { BusinessError } from '@ohos.base';

const TAG = 'AppCenterViewModel';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const INVALID_INDEX = -1;
const BLUE_BACKGROUND_BUNDLES: string[] = [
  'com.ohos.samplemanagement', 'com.ohos.betaclub',
  'wps', 'com.ohos.totemweather',
  'com.openharmony.mbs.ismp.ep.epc.oh.ui', 'edrawmax',
  'com.openharmony.ideskos', 'com.openharmony.associateassistant',
  'com.ohos.ailife', 'com.ohos.meetime'
];
const OFFSET: number = 0;
// 分页大小
const SIZE: number = 100;
// 输出字段
const OUT_FIELDS = ['bundleName', 'appName', 'sourceChannel'];
// 检索字段是应用名
const QUERY_FIELDS_NAME: string = 'appName';

/*const searchIndex: SearchClient.Index = {
  indexId: '',
  ownerId: '',
  indexName: 'sysApp',
  schemaType: 0,
  version: '',
};*/

const SWIPER_PAGE_PRELOAD_DELAY: number = 3000;
const SWIPER_PAGE_PRELOAD_TIME_INTERVAL: number = 200;
const SWIPER_PAGE_PRELOAD_MIN_PAGES: number = 5;

export class AppCenterViewModel {
  public static readonly APP_CENTER_BK_BLUR = 233;
  public static readonly APP_CENTER_BK_OPACITY = 1;
  private static instance: AppCenterViewModel;
  private mAppGridStyleConfig: AppCenterGridStyleConfig;
  private mExtAppGridStyleConfig: AppCenterGridStyleConfig;
  private swiperController: SwiperController;
  private extSwiperController: SwiperController;
  private mPageIndex = 0;
  private mPinyinSort: PinyinSort;
  private initializedAnimationData: boolean = false;
  private appItemPosX: number[] = [];
  private rtlAppItemPosX: number[] = [];
  private appItemPosY: number[] = [];
  private appItemOpacity: number[] = [];
  private blur: number = 0;
  private bkOpacity: number = 0;
  private timeAsc: number[] = [];
  private timeDesc: number[] = [];
  private radius: number[] = [];
  private appItemEdgePos: Array<Array<number>> = [];
  private circleMap: Map<number, number[]> = new Map();
  // private searchSession?: SearchClient.SearchSession;
  private searchSession?: ESObject;
  private isSearchLinking: boolean = false;
  private dynamicEffects: AppCenterDynamicEffects = new AppCenterDynamicEffects();
  /* 单页面的应用动效参数集 */
  private animationParamsByScreen: Map<string, Map<number, AppCenterDynamicEffects>> = new Map();
  private preloadIntervalId: number = -1;
  private preloadPageIndex: number = 0;
  private curSwiperPageIndexes: number[] = [];
  private focusScreenId: number = 0;
  private appItemEdgePosFold: Array<Array<number>> = [];
  private curSearchPageIndex: number = 0;
  private isExtScreenEntered: boolean = false;
  /* 存放回车按键之前的输入字符串 */
  private searchInputTextBeforeEnter = '';

  private constructor() {
    log.showInfo('constructor');
    this.mPinyinSort = new PinyinSort();
    this.mAppGridStyleConfig = layoutConfigManager.getStyleConfig(AppCenterGridStyleConfig.APP_GRID_STYLE_CONFIG,
      FeatureConstants.FEATURE_NAME);
    this.mExtAppGridStyleConfig = layoutConfigManager.getStyleConfig(AppCenterGridStyleConfig.EXT_APP_GRID_STYLE_CONFIG,
      FeatureConstants.FEATURE_NAME);
    this.swiperController = new SwiperController();
    this.extSwiperController = new SwiperController();
  }

  public async beginSearch() {
    if (!this.isSearchLinking) {
      // this.searchSession = await SearchClient.beginSearch([]);
      this.isSearchLinking = true;
    }
  }

  public async endSearch() {
    if (this.isSearchLinking) {
      // await SearchClient.endSearch(this.searchSession);
      this.isSearchLinking = false;
    }
  }

  /**
   * 提交并搜索
   * @param input
   * @returns
   */
  public async inputChangeEvent(input: string): Promise<AppCenterSearchResultTask> {
    await this.beginSearch();
    let resultList = await this.getSearchResult(input);
    let query: AppCenterSearchResultTask = {
      resultList: resultList,
      searchKey: input
    };
    return query;
  }
  /**
   * 获取搜索结果
   * @param value
   * @returns
   */
  async getSearchResult(value: string): Promise<AppCenterSearchResultModel[]> {
    try {
      log.showInfo(`getSearchResult`);
      if (!this.searchSession) {
        log.showWarn(`searchSession is null`);
        return [];
      }
      log.showInfo(`getSearchResult start value:${value}`);
      /*let query: SearchClient.Query = this.getSearchQuery(value);
      let result: SearchClient.SearchResult<AppCenterSearchResultModel> = await this.searchSession.search(query);
      log.showInfo(`getSearchResult end: ${result.records?.length}`);
      if (result != null && result.records?.length) {
        return result.records;
      }*/
      return [];
    } catch (error) {
      log.showInfo(`getSearchResult faild: ${error}`);
    }
    return [];
  }

  /**
   * 构建搜索query
   * @param value
   * @returns
   */
/*
  private getSearchQuery(value: string): SearchClient.Query {
    let queryClause: SearchClient.SimpleQueryClause = {
      query: value,
      searchFields: [QUERY_FIELDS_NAME],
      queryType: 'match'
    }

    const query: SearchClient.Query = {
      index: searchIndex,
      outFields: OUT_FIELDS,
      query: queryClause,
      offset: OFFSET,
      size: SIZE,
    }
    return query;
  }
*/

  /**
   * Obtains the AppCenterViewModel instance.
   *
   * @return AppCenterViewModel
   */
  public static getInstance(): AppCenterViewModel {
    log.showInfo('getInstance');
    if (AppCenterViewModel.instance == null) {
      AppCenterViewModel.instance = new AppCenterViewModel();
    }
    return AppCenterViewModel.instance;
  }

  public getAppGridStyleConfig(screenId: number = 0): AppCenterGridStyleConfig {
    log.showInfo(`getAppGridStyleConfig screenId: ${screenId}`)
    if (screenId === 0) {
      return this.mAppGridStyleConfig;
    } else {
      return this.mExtAppGridStyleConfig;
    }
  }

  public setSwiperController(swiperController: SwiperController, screenId: number = 0): void {
    if (screenId === 0) {
      this.swiperController = swiperController;
    } else {
      this.extSwiperController = swiperController;
    }
  }

  public getSwiperController(screenId: number = 0): SwiperController {
    if (screenId === 0) {
      return this.swiperController;
    } else {
      return this.extSwiperController;
    }
  }

  /**
   * 跳转下一页
   */
  public showNext(screenId: number = 0): void {
    log.showInfo(`show next page; screenId: ${screenId} `);
    if (screenId === 0) {
      if (this.swiperController) {
        this.swiperController.showNext();
        AppCenterDragMgr.getInstance().updateDragPageIndex(true);
      }
    } else {
      if (this.extSwiperController) {
        this.extSwiperController.showNext();
        AppCenterDragMgr.getInstance().updateDragPageIndex(true);
      }
    }
  }

  /**
   * 跳转上页
   */
  public showPrevious(screenId: number = 0): void {
    log.showInfo(`show previous page; screenId: ${screenId}`);
    if (screenId === 0) {
      if (this.swiperController) {
        this.swiperController.showPrevious();
        AppCenterDragMgr.getInstance().updateDragPageIndex(false);
      }
    } else {
      if (this.extSwiperController) {
        this.extSwiperController.showPrevious();
        AppCenterDragMgr.getInstance().updateDragPageIndex(false);
      }
    }
  }

  /**
   * 跳转到指定页面
   * @param pageIndex 目标页面
   * @param pageNum 总页数
   */
  public goExactPage(pageIndex: number, pageNum: number): void {
    log.showInfo(`goExactPage: ${pageIndex}`);
    if (this.swiperController && pageIndex >= 0 && pageIndex < pageNum) {
      this.swiperController.changeIndex(pageIndex);
      AppCenterDragMgr.getInstance().setDragPageIndex(pageIndex);
    }
  }

  public initAnimationData(screenId: number = 0): AppCenterDynamicEffects | undefined {
    if (this.initializedAnimationData) {
      return this.dynamicEffects;
    }

    let centerRow = (this.getAppGridStyleConfig(screenId).mRows - 1) / 2;
    if (centerRow == 0) {
      centerRow = 1;
    }
    let centerColumn = (this.getAppGridStyleConfig(screenId).mColumns - 1) / 2;
    if (centerColumn == 0) {
      centerColumn = 1;
    }

    log.showInfo(`columns=${this.getAppGridStyleConfig(screenId).mColumns},
     rows=${this.getAppGridStyleConfig(screenId).mRows}, centerRow=${centerRow}, centerColumn=${centerColumn}`);

    let circles = Math.ceil(this.getAppGridStyleConfig(screenId).mColumns / 2);
    let maxTime = 400;
    let minTime = 200;
    let timeAscMax = 0;
    let stepTime = (circles <= 1) ? maxTime : (maxTime - minTime) / (circles - 1);

    for (let column = Math.floor(centerColumn); column >= 0; column--) {
      let r = Math.sqrt(Math.pow(centerColumn - column, 2) + Math.pow(centerColumn - column, 2));
      this.radius.push(r);
    }

    for (let timeAsc = minTime, i = 0; timeAsc <= maxTime; timeAsc += stepTime, i++) {
      timeAsc = Math.floor(timeAsc);
      this.timeAsc.push(timeAsc);
      this.circleMap.set(i, new Array<number>());
      log.showDebug(`circleMap i=${i}, timeAsc=${timeAsc}}`);
    }

    for (let index = this.timeAsc.length - 1; index >= 0; index--) {
      this.timeDesc.push(this.timeAsc[index]);
      if (timeAscMax < this.timeAsc[index]) {
        timeAscMax = this.timeAsc[index];
      }
      log.showDebug(`timeDesc i=${index}, timeAsc=${this.timeDesc[index]}}`);
    }
    log.showInfo(`timeAscMax max=${timeAscMax}`);
    let total = this.getAppGridStyleConfig(screenId).mRows * this.getAppGridStyleConfig(screenId).mColumns;
    for (let index = 0; index < total; index++) {
      this.appItemOpacity.push(0);

      let rawRow = index / this.getAppGridStyleConfig(screenId).mColumns;
      let rawColumn = index % this.getAppGridStyleConfig(screenId).mColumns;

      let transX = (rawColumn - centerColumn) / centerColumn * 100;
      let rtlTransX = (centerColumn - rawColumn) / centerColumn * 100;
      let transY = (Math.floor(rawRow) - centerRow) / centerRow * 100;

      this.appItemEdgePos.push([transX, transY, rtlTransX]);
      this.appItemPosX.push(transX);
      this.rtlAppItemPosX.push(rtlTransX);
      this.appItemPosY.push(transY);

      log.showDebug(`index=${index}, transX=${transX}, transY=${transY}, rtlTransX=${rtlTransX}`);

      let distance = Math.sqrt(Math.pow(Math.floor(rawRow) - centerRow, 2) +
      Math.pow(Math.floor(rawColumn) - centerColumn, 2));

      for (let i = this.radius.length - 1; i >= 0; i--) {
        if (distance > this.radius[i]) {
          let circle = (i + 1 < this.radius.length ? i + 1 : i);
          log.showDebug(`> circle=${circle} start`);
          this.circleMap.get(circle)?.push(index);
          log.showDebug(`> circle=${circle} end`);
          break;
        } else if (distance === this.radius[i]) {
          log.showDebug(`== circle=${i} start`);
          this.circleMap.get(i)?.push(index);
          log.showDebug(`== circle=${i} end`);
          break;
        } else if (i === 0) {
          this.circleMap.get(i)?.push(index);
        }
      }
    }
    AppStorage.setOrCreate('AppCenterItemPosX', this.appItemPosX);
    AppStorage.setOrCreate('AppCenterItemPosY', this.appItemPosY);
    AppStorage.setOrCreate('AppCenterItemOpacity', this.appItemOpacity);
    AppStorage.setOrCreate('AppCenterBkBlur', this.blur);
    AppStorage.setOrCreate('AppCenterBkOpacity', this.bkOpacity);

    this.dynamicEffects = new AppCenterDynamicEffects(
      this.appItemPosX, this.rtlAppItemPosX, this.appItemPosY, this.appItemOpacity, this.bkOpacity);
    this.initializedAnimationData = true;
    return this.dynamicEffects;
  }

  public getCircleMap(): Map<number, Array<number>> {
    return this.circleMap;
  }

  public getTimeAsc(): Array<number> {
    return this.timeAsc;
  }

  public getTimeDesc(): Array<number> {
    return this.timeDesc;
  }

  public getAppItemEdgePos(): Array<Array<number>> {
    return this.appItemEdgePos;
  }

  /**
   * 二维坐标转一维索引
   * @param row
   * @param column
   * @returns
   */
  public getIndexOfGrid(row: number, column: number): number {
    if (isNaN(column) || isNaN(row)) {
      return -1;
    }
    return column + row * this.mAppGridStyleConfig.mColumns;
  }

  // 将分页转换为总的list 数据
  public convertToAllList(fullAppPageList: AppLayoutInfo[]): AppItemInfo[] {
    let appItems: AppItemInfo[] = [];
    for (let appLayoutInfo of fullAppPageList) {
      for (let appItem of appLayoutInfo.pageInfo) {
        appItems.push(appItem);
      }
    }
    return appItems;
  }

  /**
   *
   * 对应用中心的应用列表数据进行分页
   *
   * @returns
   * @param packageChangeTime
   * @returns
   */
  public doAppCenterDataPaging(appInfos: AppItemInfo[], packageChangeTime?: number): Array<AppLayoutInfo> {
    // 深拷贝复制应用列表的数组
    let appListInfo: AppItemInfo[] = JSON.parse(JSON.stringify(appInfos));

    let itemCountByPage = this.mAppGridStyleConfig.mColumns * this.mAppGridStyleConfig.mRows;
    log.showInfo(`mRows:${this.mAppGridStyleConfig.mRows} mColumns:${this.mAppGridStyleConfig.mColumns} ` +
      `app_count:${appListInfo.length} countPerPage:${itemCountByPage}`);

    // 极端异常，例如屏幕宽高获取异常时，取默认值
    if (itemCountByPage === 0) {
      log.showError('this.mAppGridStyleConfig error:' + JSON.stringify(this.mAppGridStyleConfig));
      itemCountByPage = StyleConstants.DEFAULT_APP_GRID_ROW * StyleConstants.DEFAULT_APP_GRID_COLUMN;
    }

    // 分页数计算
    let pageCount = Math.floor(appListInfo.length / itemCountByPage);
    if (appListInfo.length % itemCountByPage != 0) {
      pageCount = pageCount + 1;
    }

    // 组装形成图标的分页数组
    let appCenterLayoutInfo = new Array<AppLayoutInfo>();
    for (let i = 0; i < pageCount; i++) {
      let pageInfo: AppItemInfo[] = [];
      let pageItem: AppLayoutInfo = {
        pageInfo: [],
        index: 0,
        packageChangeTime: 0,
        forLandscape: false
      };

      if (itemCountByPage > appListInfo.length) {
        pageInfo = appListInfo.splice(0, appListInfo.length);
      } else {
        pageInfo = appListInfo.splice(0, itemCountByPage);
      }
      log.showInfo(`doAppCenterDataPaging info: ${pageInfo.length} - ${i}`)
      pageItem.pageInfo = pageInfo;
      pageItem.index = i;
      pageItem.packageChangeTime = packageChangeTime as number;
      appCenterLayoutInfo.push(pageItem);
    }

    log.showInfo(`doAppCenterDataPaging end: ${appCenterLayoutInfo.length} - ${pageCount}`)
    return appCenterLayoutInfo;
  }

  changeIndex(idx: number): void {
    this.mPageIndex = idx;
    AppStorage.setOrCreate('openAppCenterPageIndex', this.mPageIndex);
  }

  private getUpdateAreaIndex(bundleLength: number, pageInfoLength: number): number[] {
    const appGridColumn: number = AppGridStyleConfig.getInstance().mColumns + 1;
    log.showInfo(`updateAppCenterLayout pageInfoLength:${pageInfoLength}, appGridColumn:${appGridColumn}`);
    let updateAreaIndexList: number[] = [];
    let startRow: number = Math.floor(pageInfoLength / appGridColumn);
    let updateColumn: number = appGridColumn;
    // start index
    let updateIndex = startRow * appGridColumn - 1;
    let updateRow = startRow;
    for (let count = 0; count < bundleLength; count++) {
      updateAreaIndexList.push(updateIndex);
      updateRow--;
      if (updateRow <= 0) {
        updateRow = startRow;
        updateColumn--;
      }
      updateIndex = (updateRow - 1) * appGridColumn + updateColumn - 1;
      if (updateIndex <= INVALID_INDEX || updateIndex >= pageInfoLength) {
        log.showWarn(`updateAppCenterLayout updateIndex error = ${updateIndex}`);
        return [];
      }
    }
    log.showInfo(`updateAppCenterLayout updateAreaIndexList${updateAreaIndexList}`);
    return updateAreaIndexList;
  }

  /**
   * 卸载1个后后面的往前面减一。如果数组遇到的蓝色图标则跳过(蓝色图标暂需靠右5.0版本后去除)
   *
   * @param appItemInfoList
   * @param bundleName
   * @returns
   */
  public removeAppUpdateAppCenter(appItemInfoList: AppItemInfo[], bundleName: string): AppItemInfo[] {
    // index 为卸载的应用坐标
    let indexes: number[] = [];
    for (let i = 0; i < appItemInfoList.length; i++) {
      log.showInfo(`updateAppCenterLayout updateAreaIndexList${i} needRemove:${bundleName}`);
      if (appItemInfoList[i].bundleName === bundleName) {
        indexes.push(i);
      }
    }

    for (let m = 0; m < indexes.length; m++) {
      for (let i = indexes[m]; i < appItemInfoList.length; i++) {
        if (i !== appItemInfoList.length - 1) {
          appItemInfoList[i - m] = appItemInfoList[i - m + 1];
        }
      }
    }

    // delete last one
    appItemInfoList.splice(appItemInfoList.length - indexes.length, indexes.length);
    return appItemInfoList;
  }

  /**
   * 分页并排序
   * @param appItems
   * @returns
   */
  public doDataPagingAndSort(appItems: AppItemInfo[]): AppLayoutInfo[] {
    log.showInfo(`doDataPagingAndSort, appItems: ${appItems.length}`);
    if (CheckEmptyUtils.isEmptyArr(appItems)) {
      log.showWarn('doDataPagingAndSort, list empty');
      return [];
    }
    // 页码->页上元素数组map
    let groupMap: HashMap<number, AppItemInfo[]> = new HashMap<number, AppItemInfo[]>();
    // 新增元素
    let needPositionItems: AppItemInfo[] = [];
    // 循环遍历每个待分组元素
    appItems.forEach((item: AppItemInfo) => {
      if (item && !CheckEmptyUtils.isEmpty(item.page)) {
        // 查询获取该元素的数组
        let crrArrForPage: AppItemInfo[] = groupMap.get(item.page);
        if (CheckEmptyUtils.isEmptyArr(crrArrForPage)) {
          crrArrForPage = [];
        }
        crrArrForPage.push(item);
        groupMap.set(item.page, crrArrForPage);
      } else {
        needPositionItems.push(item);
      }
    })
    // 转换成数组
    const pages: number[] = Array.from(groupMap.keys());
    pages.sort((a, b) => {
      return a - b;
    })
    log.showWarn('doDataPagingAndSort, needPositionItems length:' + needPositionItems?.length);
    needPositionItems.sort((a, b): number => {
      return this.mPinyinSort.sortByParameter(a.appName, b.appName);
    });
    let appCenterLayoutInfo: AppLayoutInfo[] = [];
    pages.forEach((page: number) => {
      let appLayoutItem: AppLayoutInfo = new AppLayoutInfo();
      appLayoutItem.pageInfo = groupMap.get(page);
      this.sortPageData(appLayoutItem.pageInfo);
      appLayoutItem.index = page;
      appLayoutItem.packageChangeTime = new Date().getTime();
      this.findPositionForAppItem(appLayoutItem.pageInfo, needPositionItems, page);
      appCenterLayoutInfo.push(appLayoutItem);
    })
    return appCenterLayoutInfo;
  }

  private findPositionForAppItem(currItemsOnPage: AppItemInfo[], leftAppItems: AppItemInfo[], page: number): boolean {
    log.showInfo(`findPositionForAppItem, length: ${currItemsOnPage.length}, ${leftAppItems.length}`);
    if (currItemsOnPage.length >= this.mAppGridStyleConfig.mRows * this.mAppGridStyleConfig.mColumns) {
      //放满了
      log.showWarn(`findPositionForAppItem: page full on page ${page}`);
      return false;
    } else if (currItemsOnPage.length === 0) {
      // 本页只一个元素
      let item: AppItemInfo | undefined = leftAppItems.shift();
      log.showInfo(`findPositionForAppItem. length: ${leftAppItems.length}`);
      if (item) {
        item.page = page;
        item.column = 0;
        item.row = 0;
        currItemsOnPage.push(item);
        return true;
      }
    } else {
      let lastItemOfPageList: AppItemInfo | undefined = currItemsOnPage[currItemsOnPage.length - 1];
      let item: AppItemInfo | undefined = leftAppItems.shift();
      log.showInfo(`findPositionForAppItem. length: ${leftAppItems?.length}`);
      if (item && lastItemOfPageList) {
        const nextPos: number[] = AppGridLayoutCacheManager.getInstance().getNextPosition(false,
          lastItemOfPageList.row, lastItemOfPageList.column) as number[];
        if (!nextPos) {
          log.showWarn('findPositionForAppItem. invalid next pos');
          return false;
        }
        item.page = lastItemOfPageList.page;
        item.column = nextPos[1];
        item.row = nextPos[0];
        currItemsOnPage.push(item);
        return true;
      }
    }
    return false;
  }

  /**
   * 在当前缓存页中找位置放元素
   * @param appCenterLayoutInfo
   * @param leftAppItems
   * @returns
   */
  public findPositionOnPage(appCenterLayoutInfo: AppLayoutInfo[], leftAppItems: AppItemInfo[]): boolean {
    log.showInfo(`findPositionOnPage. length: ${leftAppItems.length}`);
    if (CheckEmptyUtils.isEmptyArr(appCenterLayoutInfo) || CheckEmptyUtils.isEmptyArr(leftAppItems)) {
      log.showInfo('findPositionOnPage param empty');
      return false;
    }
    if (this.isAllPageFull(appCenterLayoutInfo)) {
      AppGridLayoutCacheManager.getInstance().addBlankPage();
    }
    let curPageIndex: number = 0;
    let findTimes: number = 0;
    while (leftAppItems.length > 0 &&　findTimes　< appCenterLayoutInfo.length) {
      if (this.isAllPageFull(appCenterLayoutInfo)) {
        if (appCenterLayoutInfo.length + 1 > LayoutConstants.MAX_PAGE_COUNT) {
          // 无法新增页
          return false;
        } else {
          // 合理加页
          appCenterLayoutInfo.push(
            {
              pageInfo: [],
              index: appCenterLayoutInfo.length,
              packageChangeTime: new Date().getTime(),
              forLandscape: false
            }
          );
          curPageIndex++;
        }
      }
      if (curPageIndex === appCenterLayoutInfo.length) {
        return false;
      }
      let findRet: boolean =
        this.findPositionForAppItem(appCenterLayoutInfo[curPageIndex].pageInfo, leftAppItems, curPageIndex);
      if (!findRet) {
        // 当页放满了
        curPageIndex++;
        if (curPageIndex === appCenterLayoutInfo.length &&
          appCenterLayoutInfo.length + 1 > LayoutConstants.MAX_PAGE_COUNT) {
          // 越界且无法再加页
          return false;
        }
      }
      findTimes ++;
    }
    return true;
  }

  private isAllPageFull(appCenterLayoutInfo: AppLayoutInfo[]): boolean {
    if (!appCenterLayoutInfo) {
      return false;
    }
    let fullPageCount: number = 0;
    for (let i = 0; i < appCenterLayoutInfo.length; i++) {
      if (appCenterLayoutInfo[i]?.pageInfo?.length >=
        this.mAppGridStyleConfig.mColumns * this.mAppGridStyleConfig.mRows) {
        fullPageCount++;
      }
    }
    return fullPageCount === appCenterLayoutInfo.length;
  }

  /**
   * 宫格数据排序
   * @param pageItemInfos
   */
  public sortPageData(pageItemInfos: AppItemInfo[]): void {
    if (CheckEmptyUtils.isEmptyArr(pageItemInfos)) {
      log.showWarn(`sortPageData input data in undefined`);
      return;
    }
    pageItemInfos.sort((item1: AppItemInfo, item2: AppItemInfo) => {
      if (item1.row === item2.row) {
        return (item1.column === undefined || item2.column === undefined) ? 1 : item1.column - item2.column;
      } else {
        return (item1.row === undefined || item2.row === undefined) ? 1 : item1.row - item2.row;
      }
    });
  }

  /**
   * 排序指定页面
   */
  public sortAllData(layoutItems: AppLayoutInfo[], pageIndex?: number[]): void {
    log.showInfo(`start to sort all Data`);
    layoutItems?.forEach((pageData: AppLayoutInfo) => {
      if (pageIndex) {
        if (pageIndex.includes(pageData.index)) {
          this.sortPageData(pageData?.pageInfo);
        }
      } else {
        this.sortPageData(pageData?.pageInfo);
      }
    })
  }

  public getAppItemPosX(): Array<number> {
    return this.appItemPosX;
  }

  public getAppItemPosY(): Array<number> {
    return this.appItemPosY;
  }

  public getAppItemOpacity(): Array<number> {
    return this.appItemOpacity;
  }

  /**
   * 初始化动效参数的Map
   *
   * @param screenId
   */
  public initAnimationParamsByScreen(screenId: number, inSearch: boolean = false): void {
    const key = this.getAnimationParamKey(screenId, inSearch);
    if (this.animationParamsByScreen.has(key)) {
      log.showInfo(`initAnimationParamsByScreen-exist-${key}`);
      return;
    }

    let detMap = new Map<number, AppCenterDynamicEffects>();
    this.animationParamsByScreen.set(key, detMap);
    log.showInfo(`initAnimationParamsByScreen-${key}`);
  }

  /**
   * 清理动效参数map
   *
   * @param screenId
   * @returns
   */
  public destroyAnimationParamsByScreen(screenId: number, inSearch: boolean = false): boolean {
    const key = this.getAnimationParamKey(screenId, inSearch);
    if (!this.animationParamsByScreen.has(key)) {
      log.showInfo(`destroyAnimationParamsByScreen-not exist-${key}`);
      return false;
    }

    this.animationParamsByScreen.get(key)?.clear();
    this.animationParamsByScreen.delete(key);
    log.showInfo(`destroyAnimationParamsByScreen-${key}-${this.animationParamsByScreen.size}`);
    return true;
  }

  /**
   *
   * 初始化单页面的动效参数数组
   *
   * @param screenId
   * @param pageIdx
   * @param appItemPosX
   * @param rtlAppItemPosX
   * @param appItemPosY
   * @param appItemOpacity
   */
  public initDynamicEffect(screenId: number, pageIdx: number, appItemPosX: number[], rtlAppItemPosX: number[],
    appItemPosY: number[], appItemOpacity: number[]): void {
    let total = this.getAppGridStyleConfig(screenId).mRows * this.getAppGridStyleConfig(screenId).mColumns;

    if (pageIdx > 0) {
      for (let index = 0; index < total; index++) {
        appItemOpacity.push(1);
        appItemPosX.push(0);
        rtlAppItemPosX.push(0);
        appItemPosY.push(0);
      }
    } else {
      for (let index = 0; index < this.dynamicEffects.getAppItemPosX().length; index++) {
        appItemOpacity.push(this.dynamicEffects.getAppItemOpacity()[index]);
        appItemPosX.push(this.dynamicEffects.getAppItemPosX()[index]);
        rtlAppItemPosX.push(this.dynamicEffects.getRtlAppItemPosX()[index]);
        appItemPosY.push(this.dynamicEffects.getAppItemPosY()[index]);
      }
    }

    log.showInfo(`initDynamicEffect-${screenId}-${pageIdx}-${total}`);
  }

  /**
   *
   * 初始化单页面的动效参数数组 - 大屏幕机
   *
   * @param screenId
   * @param pageIdx
   * @param appItemPosX
   * @param rtlAppItemPosX
   * @param appItemPosY
   * @param appItemOpacity
   * @param rfAppItemPosX
   * @param rfRtlAppItemPosX
   * @param rfAppItemPosY
   * @param rfAppItemOpacity
   */
  public initDynamicEffectFold(screenId: number, pageIdx: number, appItemPosX: number[], rtlAppItemPosX: number[],
    appItemPosY: number[], appItemOpacity: number[], rfAppItemPosX: number[], rfRtlAppItemPosX: number[],
    rfAppItemPosY: number[], rfAppItemOpacity: number[], inSearch: boolean): void {
    if (inSearch) {
      for (let index = 0; index < rfAppItemPosX.length; index++) {
        appItemOpacity.push(1);
        appItemPosX.push(0);
        rtlAppItemPosX.push(0);
        appItemPosY.push(0);
      }
      return;
    }
    if (pageIdx > 1) {
      for (let index = 0; index < rfAppItemPosX.length; index++) {
        appItemOpacity.push(1);
        appItemPosX.push(0);
        rtlAppItemPosX.push(0);
        appItemPosY.push(0);
      }
    } else {
      let withoutTxl = false;
      if (pageIdx === 0 && AppStorage.get('isAppCenterShow')) {
        withoutTxl = true;
        if (screenId > 0 && !this.isExtScreenEntered) {
          this.isExtScreenEntered = true;
        }
      } else if (pageIdx === 1) {
        let m = this.getDynamicEffectMap(screenId, inSearch);
        if (m) {
          let acd = m.get(0);
          if (!acd && AppStorage.get('isAppCenterShow')) {
            withoutTxl = true;
          } else if (acd && acd.getAppItemOpacity()) {
            // 首页已经是可见的则说明是新增第1号页的场景
            withoutTxl = acd.getAppItemOpacity()[0] === 1;
          }
        }
      }
      if (AppStorage.get('isAppCenterShow') && withoutTxl) {
      for (let index = 0; index < rfAppItemPosX.length; index++) {
          appItemOpacity.push(1);
          appItemPosX.push(0);
          rtlAppItemPosX.push(0);
          appItemPosY.push(0);
        }
      } else {
        for (let index = 0; index < this.appItemEdgePosFold.length; index++) {
          appItemOpacity.push(0);
          appItemPosX.push(this.appItemEdgePosFold[index][0]);
          appItemPosY.push(this.appItemEdgePosFold[index][1]);
          rtlAppItemPosX.push(this.appItemEdgePosFold[index][2]);
        }
        // 磁吸态
        if (this.appItemEdgePosFold.length < rfAppItemPosX.length) {
          for (let index2 = this.appItemEdgePosFold.length; index2 < rfAppItemPosX.length; index2++) {
            appItemOpacity.push(1);
            appItemPosX.push(0);
            appItemPosY.push(0);
            rtlAppItemPosX.push(0);
          }
        }
      }
    }

    log.showInfo(`initDynamicEffectFold-${screenId}-${pageIdx}-${rfAppItemPosX.length}-${rfAppItemOpacity.length}-` +
      `${this.appItemEdgePosFold.length}`);
  }
  /**
   * 设置大屏幕机边缘动效参数
   * @param ep
   */
  public setAppItemEdgePosForFold(ep: Array<Array<number>>): void {
    this.appItemEdgePosFold = ep;
  }
  /**
   * 更新搜索结果页当前停留页码
   * @param index
   */
  public setCurSearchPageIndex(index: number): void {
    log.showInfo(`setCurSearchPageIndex-${this.curSearchPageIndex}-${index}`);
    this.curSearchPageIndex = index;
  }
  /**
   * 获取搜索结果停留页
   * @param index
   */
  public getCurSearchPageIndex(): number {
    return this.curSearchPageIndex;
  }

  /**
   *
   * 注册单页面的动效参数集，暂时不考虑扩展屏
   *
   * @param pageIdx
   * @param det
   * @returns
   */
  public registerDynamicEffect(screenId: number, pageIdx: number, appItemPosX: number[], rtlAppItemPosX: number[],
    appItemPosY: number[], appItemOpacity: number[], inSearch: boolean = false): boolean {
    log.showInfo(`registerDynamicEffect screenId:${screenId},inSearch:${inSearch}`);
    const key = this.getAnimationParamKey(screenId, inSearch);
    if (!this.animationParamsByScreen.has(key)) {
      this.initAnimationParamsByScreen(screenId, inSearch);
    }
    let detMap = this.animationParamsByScreen.get(key);

    if (!detMap) {
      log.showWarn(`registerDynamicEffect-no det map ${key}-${pageIdx}`);
      return false;
    }
    if (detMap.has(pageIdx)) {
      log.showInfo(`registerDynamicEffect-page ${screenId}-${pageIdx} exist`);
      return false;
    }

    let det = new AppCenterDynamicEffects(appItemPosX, rtlAppItemPosX, appItemPosY, appItemOpacity);
    detMap.set(pageIdx, det);
    log.showInfo(`registerDynamicEffect-add new page ${screenId}-${pageIdx}`);
    return true;
  }
  /**
   * 反注册单页面的动效参数集
   *
   * @param pageIdx
   * @returns
   */
  public unregisterDynamicEffect(screenId: number, pageIdx: number, inSearch: boolean = false): boolean {
    const key = this.getAnimationParamKey(screenId, inSearch);
    if (!this.animationParamsByScreen.has(key)) {
      this.initAnimationParamsByScreen(screenId, inSearch);
    }

    let detMap = this.animationParamsByScreen.get(key);
    if (!detMap) {
      log.showWarn(`unregisterDynamicEffect-no det map ${screenId}-${pageIdx}`);
      return false;
    }


    if (!detMap.has(pageIdx)) {
      log.showInfo(`unregisterDynamicEffect-page ${pageIdx} not exist`);
      return false;
    }

    detMap.delete(pageIdx);
    log.showInfo(`unregisterDynamicEffect-del page ${pageIdx}`);
    return true;
  }

  // 获取显隐参数设置关键字
  private getAnimationParamKey(screenId: number, inSearch: boolean): string {
    return screenId + '_' + inSearch;
  }

  /**
   *
   * 获取当前参数集Map
   *
   * @returns
   */
  public getDynamicEffectMap(screenId: number,
    inSearch: boolean = false): Map<number, AppCenterDynamicEffects> | undefined {
    const key = this.getAnimationParamKey(screenId, inSearch);
    if (!this.animationParamsByScreen.has(key)) {
      log.showWarn(`getDynamicEffectMap-no map-${key}`);
      return undefined;
    }
    return this.animationParamsByScreen.get(key);
  }

  /**
   * Swiper预加载回调
   * @param err
   */
  private preloadCallBack = (err: BusinessError) => {
    log.showInfo(`ac swiper preload done, page: ${err.code}-${this.preloadPageIndex}`);
    if (err.code) {
      log.showError(`preloadItems failed, invalid input parameters. error code: ${err.code}`);
      if (this.preloadIntervalId !== -1) {
        clearTimeout(this.preloadIntervalId);
      }
      this.preloadIntervalId = -1;
      return;
    }

    if (this.preloadIntervalId !== -1) {
      clearTimeout(this.preloadIntervalId);
      this.preloadIntervalId = -1;
    }

    log.showInfo(`CallBack preload done, ac page idx: ${this.preloadPageIndex}`);
    this.preloadPageIndex += 1;
    if (this.preloadPageIndex >= this.curSwiperPageIndexes.length) {
      log.showInfo(`preloadCallBack: exit when to end-${this.curSwiperPageIndexes.length}-${this.preloadPageIndex}`);
      return;
    }
    log.showInfo(`preloadCallBack, next page idx: ${this.preloadPageIndex}`);
    this.preloadIntervalId = setTimeout(() => {
    this.doPreloadItem();
    }, SWIPER_PAGE_PRELOAD_TIME_INTERVAL);
  };

  /**
   * 启动Swiper预加载
   */
  public startPreloadSwiperPages(sid: number): void {
    log.showInfo(`preloadItems: a page begin-${this.preloadPageIndex}-${this.focusScreenId}-${sid}`);

    this.preloadPageIndex = 0;
    this.focusScreenId = sid;
    this.curSwiperPageIndexes = AppGridLayoutCacheManager.getInstance().getPages();
    if (!this.curSwiperPageIndexes || this.curSwiperPageIndexes.length === 0 ||
      this.curSwiperPageIndexes.length < SWIPER_PAGE_PRELOAD_MIN_PAGES) {
      log.showInfo('preloadItems: ignore');
      return;
    }

    if (this.preloadPageIndex >= this.curSwiperPageIndexes.length) {
      log.showInfo(`End to preload swiperPage as the preloadPage is ${this.preloadPageIndex}`);
      return;
    }

    if (this.preloadIntervalId !== -1) {
      clearTimeout(this.preloadIntervalId);
      this.preloadIntervalId = -1;
    }

    log.showInfo(`preloadItems: ${this.curSwiperPageIndexes.length}-${JSON.stringify(this.curSwiperPageIndexes)}`);
    this.preloadIntervalId = setTimeout(() => {
      this.doPreloadItem();
    }, SWIPER_PAGE_PRELOAD_DELAY);

    log.showInfo('preloadItems: a page end');
  }

  /**
   * 执行preload
   */
  private doPreloadItem(): void {
    log.showInfo(`preloadNextPage-time-begin, page: ${this.preloadPageIndex}-${this.curSwiperPageIndexes.length}`);

    if (this.preloadPageIndex >= this.curSwiperPageIndexes.length) {
      log.showInfo(`doPreloadItem: exit when to end-${this.curSwiperPageIndexes.length}-${this.preloadPageIndex}`);
      return;
    }

    if (this.focusScreenId > 0) {
      // this.extSwiperController?.preloadItems([this.preloadPageIndex], this.preloadCallBack);
      // this.extSwiperController?.preloadItems([this.preloadPageIndex]);
    } else {
      // this.swiperController?.preloadItems([this.preloadPageIndex], this.preloadCallBack);
      // this.swiperController?.preloadItems([this.preloadPageIndex]);
    }

    log.showInfo(`preloadNextPage-time-end, page: ${this.preloadPageIndex}-${this.curSwiperPageIndexes.length}`);
  }
  /**
   * 回车按键前的搜索输入字串
   * @param s
   */
  public updateSearchInputTextBeforeEnter(s: string): void {
    log.showInfo(`updateSearchInputTextBeforeEnter-${this.searchInputTextBeforeEnter}-${s}`);
    this.searchInputTextBeforeEnter = s;
  }
  /**
   *
   * 是否在Enter键之后改变了搜索串（说明是特定输入法的按键，无需响应打开）
   *
   * @param sNow
   * @returns
   */
  public isChangedAfterEnter(sNow: string): boolean {
    return this.searchInputTextBeforeEnter !== sNow;
  }
}