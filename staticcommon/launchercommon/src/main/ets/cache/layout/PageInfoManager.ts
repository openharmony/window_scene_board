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
import Queue from '@ohos.util.Queue';
import { EditModeHomePageSettingParams } from '../../editmode/hisysevent/EditModeReportParams';
import { launcherStatusUtil } from '@ohos/windowscene';
import { CommonConstants, DesktopLayoutState } from '../../constants/CommonConstants';
import { RdbStoreManager } from '../../db/RdbStoreManager';
import { LayoutViewModel } from '../../viewmodel/LayoutViewModel';
import { HiEditModeEventUtils } from '../../editmode/hisysevent/HiEditModeEventUtils';
import { DeviceHelper, HiDfxEventUtil } from '@ohos/frameworkwrapper';
import { SceneMsgEnum } from '../../TsIndex';

const TAG = 'PageInfoManager';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 页面信息管理类
 */
export class PageInfoManager {
  private static instance?: PageInfoManager;
  // 总页面数
  private pageCount: number = 0;
  // 外屏总页面数
  private outerPageCount: number = 0;
  // 空白页列表
  private blankPageList: Map<number, boolean> = new Map();
  // 外屏空白页列表
  private outerBlankPageList: Map<number, boolean> = new Map();
  // 不同模式主页下标Map<设备模式, 主屏下标>
  private homeIndexMap: Map<DesktopLayoutState, number> = new Map();
  // 预加载队列
  private preloadQueue: Queue<number> = new Queue();

  /**
   * 设置主屏参数
   *
   * @param value 主屏下标
   * @param isEasyMode 是否简易模式
   */
  public setHomePageIndex(value: number, isEasyMode: boolean): void {
    log.showInfo(`set home page index: ${value}, old index: ${this.homeIndexMap}, isEasyMode:${isEasyMode}`);
    // 简易模式
    if (isEasyMode) {
      this.homeIndexMap.set(DesktopLayoutState.SIMPLE_LAUNCHER_MODEL, value);
      // 更新配置文件
      RdbStoreManager.getInstance().updateSettings(CommonConstants.DB_EASY_HOME_SCREEN_INDEX, value);
    } else {
      this.homeIndexMap.set(DesktopLayoutState.HOME_LAUNCHER_MODE, value);
      // 更新配置文件
      RdbStoreManager.getInstance().updateSettings(CommonConstants.DB_HOME_SCREEN_INDEX, value);
    }
    // 打点上报
    this.reportSettingEvent(value);
  }

  /**
   * 获取主屏下标
   *
   * @returns 主屏下标
   */
  public getHomePageIndex(): number {
    // 外屏返回0
    if (!this.isHomePageSetSupport()) {
      return 0;
    }
    if (LayoutViewModel.getInstance().isSimpleLauncherMode()) {
      return this.homeIndexMap.get(DesktopLayoutState.SIMPLE_LAUNCHER_MODEL) ?? 0;
    } else {
      return this.homeIndexMap.get(DesktopLayoutState.HOME_LAUNCHER_MODE) ?? 0;
    }
  }

  /**
   * 从持久化的配置文件中读取主屏下标参数
   *
   * @returns 主屏下标
   */
  public async readHomePageIndex(): Promise<void> {
    // 读取简易模式主屏下标
    this.homeIndexMap.set(
      DesktopLayoutState.SIMPLE_LAUNCHER_MODEL,
      await RdbStoreManager.getInstance().querySettings(CommonConstants.DB_EASY_HOME_SCREEN_INDEX, 0) as number
    );

    // 读取主屏下标
    let homePageIndex: number =
      await RdbStoreManager.getInstance().querySettings(CommonConstants.DB_HOME_SCREEN_INDEX, 0) as number;
    // 读取总页数
    let totalPageCount: number = await RdbStoreManager.getInstance().querySettingsPageCount() as number;
    // 如果主屏下标（从0开始）大于等于总页数，主屏下标取最大下标
    if (homePageIndex >= totalPageCount) {
      log.showError(`home page index ${homePageIndex} is out of limit ${totalPageCount}`);
      homePageIndex = totalPageCount - 1;
    }
    // 如果主屏下标（从0开始）小于0，主屏下标取0
    if (homePageIndex < 0) {
      log.showError(`home page index ${homePageIndex} is less than 0`);
      homePageIndex = 0;
    }
    this.homeIndexMap.set(DesktopLayoutState.HOME_LAUNCHER_MODE, homePageIndex);
  }

  /**
   * 是否支持设置主屏
   *
   * @returns 是否
   */
  public isHomePageSetSupport(): boolean {
    // VDE外屏
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      log.showInfo('isHomePageSetSupport Show Out Launcher');
      return false;
    }
    if (!DeviceHelper.isPhoneOrPad()) {
      log.showInfo('isHomePageSetSupport not Support Device');
      return false;
    }
    return true;
  }

  /**
   * is current page home page
   *
   * @param pageIndex current page index
   * @param homeSwiperKey used to refresh
   * @returns is home page
   */
  public isHomePage(pageIndex: number, homeSwiperKey?: number) : boolean {
    log.showInfo(`isHomePage>>> ${this.getHomePageIndex()} - ${pageIndex} - ${homeSwiperKey}`);
    return Math.floor(this.getHomePageIndex() / this.disPlayCount) === Math.floor(pageIndex / this.disPlayCount);
  }

  /**
   * 初始化加载队列，从主屏开始，左右交替加载
   * @param pageLength
   */
  public initPreloadQueue(pageLength: number): void {
    // 清空队列
    while (this.preloadQueue.length > 0) {
      this.preloadQueue.pop();
    }
    let homePageIndex = this.getHomePageIndex();
    // 主屏加入队列
    this.preloadQueue.add(homePageIndex);
    // 左边是否加载完
    let canLeft: boolean = homePageIndex > 0;
    // 右边是否加载完
    let canRight: boolean = homePageIndex < pageLength - 1;
    // 偏移量
    let fix: number = 0;
    // 还没到头就继续
    while (canLeft || canRight) {
      fix++;
      // 左边可加载
      if (canLeft) {
        let tmp = homePageIndex - fix;
        this.preloadQueue.add(tmp);
        // 左边到头
        if (tmp <= 0) {
          canLeft = false;
        }
      }
      // 右边可加载
      if (canRight) {
        let tmp = homePageIndex + fix;
        this.preloadQueue.add(tmp);
        // 右边到头
        if (tmp >= pageLength - 1) {
          canRight = false;
        }
      }
    }
    // 加载到最后，返回一个大于pageLength的值，执行选举mPageDesktopViewModel?.voteBootEvent()
    this.preloadQueue.add(pageLength + 1);
  }

  /**
   * 获取队头
   * @returns 队头数值
   */
  public getNextPreload(): number {
    if (this.preloadQueue.length > 0) {
      let p = this.preloadQueue.pop();
      log.showInfo(`getNextPreload>>> p:${p}`);
      return p;
    }
    return -1;
  }

  private reportSettingEvent(value: number): void {
    let params: EditModeHomePageSettingParams = { TYPE: value };
    HiEditModeEventUtils.reportHomePageSetting(params);
  }

  // 最大显示几屏
  private maxDisplayCount: number = 2;

  // 只用于开机使用1次， PageDesktopViewModel改成ets后可以删除
  private disPlayCount: number = 1;

  // 最近1次旋转前的页数
  private rotatePageIndexArrFrom: number[] = [];

  // 最近1次旋转后的页数
  private rotatePageIndexTo: number = 0;

  /**
   * 获取单例类
   */
  public static getInstance(): PageInfoManager {
    if (!PageInfoManager.instance) {
      PageInfoManager.instance = new PageInfoManager();
    }
    return PageInfoManager.instance;
  }

  /**
   * 获取总页面数
   */
  public getPageCount(isOuter?: boolean): number {
    return isOuter ? this.outerPageCount : this.pageCount;
  }

  /**
   * 更新总页面数
   */
  public updatePageCount(count: number, msg:string, isOuter?: boolean): void {
    this.printPageCountChange(count, msg, isOuter);
    if (isOuter) {
      this.outerPageCount = count;
    } else {
      this.pageCount = count;
    }
  }

  private printPageCountChange(count: number, msg:string, isOuter?: boolean): void {
    let currentPageCount = this.getPageCount(isOuter);
    let logInfo: string = `pageCount changed to ${count} from ${currentPageCount} when isOut:${isOuter} by: ${msg}`;
    log.showWarn(logInfo);
    if (currentPageCount !== count) {
      // 打点
      HiDfxEventUtil.reportLauncherLayoutAbnormal(SceneMsgEnum.SCENE_MSG_PAGE_INDEX_CHANGED, logInfo);
    }
  }

  /**
   * 获取空白页列表
   */
  public getBlankPageList(isOuter?: boolean): Map<number, boolean> {
    log.showInfo(`getBlankPageList isOuter: ${isOuter}`);
    if (isOuter) {
      return this.outerBlankPageList;
    }
    return this.blankPageList;
  }

  /**
   * 更新pageIndex
   */
  public updatePageIndex(pageIndex: number): void {
    AppStorage.set<number>('pageIndex', pageIndex);
    log.showWarn(`updatePageIndex:${pageIndex}`);
  }

  /**
   * 获取pageIndex
   */
  public getPageIndex(): number {
    return AppStorage.get<number>('pageIndex') ?? 0;
  }

  /**
   * 获取maxDisplayCount
   * @returns maxDisplayCount
   */
  public getMaxDisplayCount(): number {
    return this.maxDisplayCount;
  }

  /**
   * 设置maxDisplayCount
   * @param maxDisplayCount
   */
  public setMaxDisplayCount(maxDisplayCount: number): void {
    this.maxDisplayCount = maxDisplayCount;
  }

  /**
   * 获取disPlayCount
   * @returns disPlayCount
   */
  public getDisplayCount(): number {
    return this.disPlayCount;
  }

  /**
   * 设置disPlayCount
   * @param disPlayCount
   */
  public setDisplayCount(disPlayCount: number): void {
    this.disPlayCount = disPlayCount;
  }

  /**
   * 获取最近1次旋转前的页数
   * @returns 最近1次旋转前的页数
   */
  public getRotatePageIndexArrFrom(): number[] {
    return this.rotatePageIndexArrFrom;
  }

  /**
   * 设置最近1次旋转前的页数
   * @returns
   */
  public setRotatePageIndexArrFrom(rotatePageIndexArrFrom: number[]): void {
    this.rotatePageIndexArrFrom = rotatePageIndexArrFrom;
  }

  /**
   * 获取最近1次旋转后的页数
   * @returns 最近1次旋转后的页数
   */
  public getRotatePageIndexTo(): number {
    return this.rotatePageIndexTo;
  }

  /**
   * 设置最近1次旋转后的页数
   * @returns
   */
  public setRotatePageIndexTo(rotatePageIndexTo: number): void {
    this.rotatePageIndexTo = rotatePageIndexTo;
  }

  /**
   * 当前页是否显示
   * @param indexInSwiper
   * @param pageIndex
   * @returns 当前页是否显示
   */
  public isCurrentPageShow(indexInSwiper: number, pageIndex: number): boolean {
    // 如果就是当前页则要加动画
    if (indexInSwiper === pageIndex) {
      return true;
    }
    if (this.disPlayCount === 1) {
      return false;
    }
    if (this.disPlayCount === 0) {
      return false;
    }
    let firstPageIndex = Math.floor(pageIndex / this.disPlayCount) * this.disPlayCount;
    let isShow = indexInSwiper >= firstPageIndex && indexInSwiper < firstPageIndex + this.disPlayCount;
    log.showDebug('displayCount:%{public}d pageIndex:%{public}d indexInSwiper:%{public}d isShow:%{public}s',
      this.disPlayCount, pageIndex, indexInSwiper, isShow);
    return isShow;
  }

  /**
   * 循环处理当前显示页逻辑
   * @param currentPage 当前页
   * @param callback 待处理逻辑，返回是否继续
   * @param isIncludeCurrentPage 是否包含当前页
   */
  public loopPageCallback(currentPage: number, callback: (page:number) => boolean,
    isIncludeCurrentPage: boolean) : void {
    if (this.disPlayCount === 1) {
      if (isIncludeCurrentPage) {
        callback(currentPage);
      }
      log.showWarn(`loopPageCallback disPlayCount == 1, currentPage:${currentPage} isIncludeCurrentPage:${isIncludeCurrentPage}`);
      return;
    }
    const currentPageIndex: number = currentPage % this.disPlayCount;
    const firstPage:number = currentPage - currentPageIndex;
    if (isIncludeCurrentPage) {
      for (let index = 0; index < this.disPlayCount; index++) {
        if (!callback(firstPage + index)) {
          log.showWarn(`loopPageCallback break disPlayCount == 1, currentPage:${currentPage}` +
            ` isIncludeCurrentPage:${isIncludeCurrentPage} index:${index}`);
          return;
        }
      }
      return;
    }
    for (let index = 0; index < this.disPlayCount; index++) {
      if (index === currentPageIndex) {
        continue;
      }
      if (!callback(firstPage + index)) {
        log.showWarn(`loopPageCallback break disPlayCount == 1, currentPage:${currentPage}` +
          ` isIncludeCurrentPage:${isIncludeCurrentPage} index:${index}`);
        return;
      }
    }
  }
}