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

import { LogDomain, Logger, SingletonHelper } from '@ohos/basicutils';
import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { ExposureData } from '../bean/ExposureData';
import type {
  DesktopExposureData,
  FolderExposureData,
  StackExposureData,
  FolderApp,
  DesktopAppInfo,
  DesktopFolderInfo,
  DesktopCardInfo,
  DesktopStackInfo,
  FormStackInfo
} from '../bean/ExposureData';
import { RecentLayoutCacheMgr } from '../dock/cache/RecentLayoutCacheMgr';
import { FolderManager } from '../folder/next/common/model/FolderManager';
import { LaunchLayoutCacheManager } from '../cache/layout/LaunchLayoutCacheManager';
import { CommonConstants } from '../constants/CommonConstants';
import { DockItemInfo } from '../bean/DockItemInfo';
import { ResidentLayoutCacheMgr } from '../dock/cache/ResidentLayoutCacheMgr';
import { CardItemInfo } from '../bean/CardItemInfo';
import { DailyScheduledReporter } from '../hisysevent/DailyScheduledReporter';
import GridLayoutUtil from '../utils/GridLayoutUtil';
import { systemDateTime } from '@kit.BasicServicesKit';
import { HiSysEventUtil } from '@ohos/frameworkwrapper';
import { DisplayCountViewModel } from '../displaycount/DisplayCountViewModel';
import { FolderViewModel } from '../folder/FolderViewModel';

const TAG: string = 'ExposureManager';
const PRE_INSTALL_EXPOSURE_TIME: number = 3000; // 单位：毫秒
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
const STATION_DESKTOP: string = 'desktop';
const STATION_DOCK: string = 'dock';
const FOLDER_DEFAULT_AREA: number = 1;
const DISPLAY_DEFAULT_COUNT: number = 1;
const DESKTOP_EXPOSURE_DATA: string = 'DESKTOP_EXPOSURE_DATA';
const FOLDER_EXPOSURE_DATA: string = 'FOLDER_EXPOSURE_DATA';
const STACK_EXPOSURE_DATA: string = 'STACK_EXPOSURE_DATA';

/**
 * 统一管理文件夹，桌面，堆叠的曝光操作
 */
export class ExposureManager {
  public static getInstance = SingletonHelper.createFactory(() => new ExposureManager());
  // 文件夹曝光操作相关参数
  private folderExposureTimeStart: number = -1;
  private folderPageIndex: number = 0;
  private openFolderData: GridLayoutItemInfo | null = null;

  // 桌面曝光操作相关参数
  private desktopExposureTimeStart: number = -1;
  private oldDesktopPageIndex: number = 0;
  private newDesktopPageIndex: number = 1;

  // 堆叠曝光操作相关参数
  private stackExposureTimeStart: number = -1;
  private formStackInfo: FormStackInfo | null = null;

  // 已经曝光的存储的数据
  private exposureData: ExposureData = new ExposureData();

  // 每日定时任务
  private dailyTask = (): Promise<void> => this.reportExposureData();

  constructor() {
    this.startReportTask();
  }

  /**
   * 记录文件夹曝光开始时间
   * @param pageIndex
   * @returns
   */
  public async handleFolderExposureTimeStart(pageIndex: number): Promise<void> {
    log.showWarn(TAG, `handleFolderExposureTimeStart`);
    // 预装曝光打点记录打开文件夹的时间
    this.folderExposureTimeStart = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
    this.folderPageIndex = pageIndex;
    this.openFolderData = FolderManager.getInstance().getOpenedFolder();
    this.handleDesktopExposureTimeEnd(this.oldDesktopPageIndex, this.newDesktopPageIndex, true);
  }

  /**
   * 记录文件夹曝光结束时间
   * @param pageIndex
   * @returns
   */
  public async handleFolderExposureTimeEnd(pageIndex: number): Promise<void> {
    // 预装曝光打点记录关闭文件夹的时间
    const folderExposureTimeStart: number = this.folderExposureTimeStart;
    const folderExposureTimeEnd: number = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
    const lastTime: number = folderExposureTimeEnd - folderExposureTimeStart;
    log.showWarn(TAG, `folder exposure folderExposureTimeStart: ${folderExposureTimeStart}, lastTime: ${lastTime}`);
    if (folderExposureTimeStart > 0 && lastTime > PRE_INSTALL_EXPOSURE_TIME) {
      try {
        await this.saveFolderExposureData(Math.floor(lastTime / 1000), this.folderPageIndex);
      } catch (err) {
        log.showWarn(TAG, `saveFolderExposureData failed, code: ${err.code}, message: ${err.message}`);
      }
    }
    this.folderPageIndex = pageIndex;
    this.folderExposureTimeStart = -1;
    this.openFolderData = null;
    this.handleDesktopExposureTimeStart();
  }

  /**
   * 记录文件夹曝光数据
   * @param lastTime
   * @param pageIndex
   * @returns
   */
  public async saveFolderExposureData(lastTime: number, pageIndex: number): Promise<void> {
    const openFolderData: GridLayoutItemInfo = this.openFolderData!;
    const folderExposureDataList: FolderExposureData[] = this.exposureData.getFolderExposureDataList();
    const folderId = openFolderData.folderId!;
    const id = `${folderId}-${pageIndex}`;
    const folderData: FolderExposureData | undefined =
      folderExposureDataList.find((item: FolderExposureData) => item.id === id);
    const layoutInfo: GridLayoutItemInfo[] = openFolderData.layoutInfo ? openFolderData.layoutInfo[pageIndex] : [];
    const folderAppList: FolderApp[] = layoutInfo.map<FolderApp>((item: GridLayoutItemInfo) => {
      return {
        bundleName: item.bundleName,
        coordinate: { column: item.column, row: item.row }
      };
    });

    const isBigFolder = openFolderData.area![0] !== FOLDER_DEFAULT_AREA ||
      openFolderData.area![1] !== FOLDER_DEFAULT_AREA;

    if (folderData) {
      // 如果记录中有值
      folderData.folderName = FolderExtension.getInstance().getRealFolderName(openFolderData.folderName!);
      folderData.exposureTime = folderData.exposureTime + lastTime;
      folderData.exposureCount = folderData.exposureCount + 1;
      folderData.coordinate = { column: openFolderData.column, row: openFolderData.row };
      folderData.desktopPageIndex = openFolderData.page!;
      folderData.pageIndex = openFolderData.page!;
      folderData.folderAppList = folderAppList;
      folderData.isBigFolder = isBigFolder;
      this.showLog(folderData, FOLDER_EXPOSURE_DATA);
    } else {
      // 如果记录中没有值
      const newFolderData: FolderExposureData = {
        id: id,
        folderId: folderId,
        folderName: FolderExtension.getInstance().getRealFolderName(openFolderData.folderName!),
        exposureTime: lastTime,
        exposureCount: 1,
        coordinate: { column: openFolderData.column, row: openFolderData.row },
        desktopPageIndex: openFolderData.page!,
        pageIndex: pageIndex,
        folderAppList: folderAppList,
        isBigFolder: isBigFolder,
      };
      this.exposureData.insertFolderExposureDataList(newFolderData);
      this.showLog(newFolderData, FOLDER_EXPOSURE_DATA);
    }
  }

  /**
   * 桌面获取焦点
   * @returns
   */
  public async handleDesktopGainFocus(): Promise<void> {
    // 如果有文件夹打开，则记录文件夹初始时间
    const isFolderOpen: boolean = FolderManager.getInstance().isFolderOpen();
    if (isFolderOpen) {
      this.handleFolderExposureTimeStart(this.folderPageIndex);
    } else {
      this.handleDesktopExposureTimeStart();
    }
  }

  /**
   * 桌面失去焦点
   * @returns
   */
  public async handleDesktopLoseFocus(): Promise<void> {
    // 如果有文件夹打开，则记录文件夹结束时间
    const isFolderOpen: boolean = FolderManager.getInstance().isFolderOpen();
    if (isFolderOpen) {
      this.handleFolderExposureTimeEnd(this.folderPageIndex);
    } else {
      this.handleDesktopExposureTimeEnd(this.oldDesktopPageIndex, this.newDesktopPageIndex, true);
    }
  }

  /**
   * 记录桌面曝光开始时间
   * @returns
   */
  public async handleDesktopExposureTimeStart(): Promise<void> {
    if (FolderManager.getInstance().isFolderOpen() || this.formStackInfo) {
      return;
    }
    // 预装曝光打点记录打开文件夹的时间
    log.showWarn(TAG, `handleDesktopExposureTimeStart`);
    this.desktopExposureTimeStart = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
  }

  /**
   * 记录桌面曝光结束时间
   * @param oldDesktopPageIndex
   * @param newDesktopPageIndex
   * @param isCurrent
   * @returns
   */
  public async handleDesktopExposureTimeEnd(oldDesktopPageIndex: number, newDesktopPageIndex: number,
    isCurrent: boolean = false): Promise<void> {
    this.oldDesktopPageIndex = oldDesktopPageIndex;
    this.newDesktopPageIndex = newDesktopPageIndex;
    const desktopExposureTimeStart: number = this.desktopExposureTimeStart;
    const desktopExposureTimeEnd: number = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
    const lastTime: number = desktopExposureTimeEnd - desktopExposureTimeStart;
    log.showWarn(TAG, `desktop exposure desktopExposureTimeStart: ${desktopExposureTimeStart}, lastTime: ${lastTime}`);
    if (desktopExposureTimeStart > 0 && lastTime > PRE_INSTALL_EXPOSURE_TIME) {
      const pageCount: number = DisplayCountViewModel.getInstance().getDisplayCount();
      log.showWarn(TAG, `desktop exposure displayCount: ${pageCount}`);
      const pageIndexStart: number = Math.floor(this.oldDesktopPageIndex / pageCount);
      const pageIndexEnd: number = Math.floor(this.newDesktopPageIndex / pageCount);
      log.showWarn(TAG, `desktop exposure pageIndexStart: ${pageIndexStart}, pageIndexEnd: ${pageIndexEnd}, pageCount: ${pageCount}`);
      // 折叠屏中要记录所有展示页的曝光
      try {
        await this.handleSaveDesktopExposureData(pageIndexStart, pageIndexEnd, pageCount, isCurrent, lastTime);
      } catch (err) {
        log.showWarn(TAG, `saveDesktopExposureData failed, code: ${err.code}, message: ${err.message}`);
      }
    }
    this.desktopExposureTimeStart = -1;
  }

  /**
   * 处理桌面曝光数据保存
   * @param pageIndexStart
   * @param pageIndexEnd
   * @param pageCount
   * @param isCurrent
   * @param lastTime
   * @returns
   */
  private async handleSaveDesktopExposureData(pageIndexStart: number, pageIndexEnd: number, pageCount: number,
    isCurrent: boolean, lastTime: number): Promise<void> {
    if (isCurrent) {
      for (let i = pageIndexEnd * pageCount; i < pageIndexEnd * pageCount + pageCount; i++) {
        await this.saveDesktopExposureData(Math.floor(lastTime / 1000), i);
      }
    } else {
      for (let i = pageIndexStart * pageCount; i < pageIndexStart * pageCount + pageCount; i++) {
        await this.saveDesktopExposureData(Math.floor(lastTime / 1000), i);
      }
    }
  }

  /**
   * 记录桌面曝光数据
   * @param lastTime
   * @param pageIndex
   * @returns
   */
  public async saveDesktopExposureData(lastTime: number, pageIndex: number): Promise<void> {
    const desktopData: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance().getAllGridLayoutItemList('exposure');
    const residentDockData: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    const recentDockData: DockItemInfo[] = RecentLayoutCacheMgr.getInstance().getAllDockItems();
    const dockData: DockItemInfo[] = DisplayCountViewModel.getInstance().getDisplayCount() === DISPLAY_DEFAULT_COUNT ?
      residentDockData : residentDockData.concat(recentDockData);
    const desktopExposureDataList: DesktopExposureData[] = this.exposureData.getDesktopExposureDataList();
    const id = `desktop-${pageIndex}`;
    const desktopExposureData: DesktopExposureData | undefined =
      desktopExposureDataList.find((item: DesktopExposureData) => item.id === id);
    const currentPageLayoutInfoList: GridLayoutItemInfo[] =
      desktopData.filter((item: GridLayoutItemInfo) => item.page === pageIndex);

    const desktopAppList: DesktopAppInfo[] = [];
    const desktopFolderList: DesktopFolderInfo[] = [];
    const desktopCardList: DesktopCardInfo[] = [];
    const desktopStackList: DesktopStackInfo[] = [];

    this.handleDesktopExposureData(desktopAppList, desktopFolderList, desktopCardList,
      desktopStackList, currentPageLayoutInfoList);
    this.handleDockExposureData(desktopAppList, desktopFolderList, dockData);

    if (desktopExposureData) {
      // 更新数据
      desktopExposureData.desktopPageIndex = pageIndex;
      desktopExposureData.exposureTime = desktopExposureData.exposureTime + lastTime;
      desktopExposureData.exposureCount = desktopExposureData.exposureCount + 1;
      desktopExposureData.desktopAppInfoList = desktopAppList;
      desktopExposureData.desktopFolderInfoList = desktopFolderList;
      desktopExposureData.desktopCardInfoList = desktopCardList;
      desktopExposureData.desktopStackInfoList = desktopStackList;
      this.showLog(desktopExposureData, DESKTOP_EXPOSURE_DATA);
    } else {
      // 插入新数据
      const newDesktopData: DesktopExposureData = {
        id: id,
        desktopPageIndex: pageIndex,
        exposureTime: lastTime,
        exposureCount: 1,
        desktopAppInfoList: desktopAppList,
        desktopFolderInfoList: desktopFolderList,
        desktopCardInfoList: desktopCardList,
        desktopStackInfoList: desktopStackList,
      };

      this.exposureData.insertDesktopExposureDataList(newDesktopData);
      this.showLog(newDesktopData, DESKTOP_EXPOSURE_DATA);
    }
  }

  /**
   * 处理桌面曝光数据
   * @param appList
   * @param folderList
   * @param cardList
   * @param stackList
   * @param currentPageLayoutInfoList
   * @returns
   */
  private handleDesktopExposureData(desktopAppList: DesktopAppInfo[], desktopFolderList: DesktopFolderInfo[],
    desktopCardList: DesktopCardInfo[], desktopStackList: DesktopStackInfo[],
    currentPageLayoutInfoList: GridLayoutItemInfo[]): void {
    // 添加桌面数据
    currentPageLayoutInfoList.forEach((layoutInfo: GridLayoutItemInfo) => {
      if (layoutInfo.typeId === CommonConstants.TYPE_APP || layoutInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        const appItem: DesktopAppInfo = {
          bundleName: layoutInfo.bundleName,
          coordinate: { column: layoutInfo.column, row: layoutInfo.row },
          station: STATION_DESKTOP,
        };
        desktopAppList.push(appItem);
      } else if (layoutInfo.typeId === CommonConstants.TYPE_FOLDER) {
        const row: number = layoutInfo!.area![0];
        const col: number = layoutInfo!.area![1];
        const isBigFolder: boolean = row !== FOLDER_DEFAULT_AREA || col !== FOLDER_DEFAULT_AREA;
        const bigFolderDisplayAppList = this.handleBigFolderDisPlayAppList(layoutInfo, isBigFolder);
        const folderItem: DesktopFolderInfo = {
          folderId: layoutInfo.folderId!,
          coordinate: { column: layoutInfo.column, row: layoutInfo.row },
          folderName: FolderExtension.getInstance().getRealFolderName(layoutInfo.folderName!),
          bigFolderDisplayAppList: bigFolderDisplayAppList,
          station: STATION_DESKTOP,
          isBigFolder: isBigFolder
        }
        desktopFolderList.push(folderItem);
      } else if (layoutInfo.typeId === CommonConstants.TYPE_CARD) {
        const cardItem: DesktopCardInfo = {
          cardName: layoutInfo.cardName!,
          coordinate: { column: layoutInfo.column, row: layoutInfo.row },
        }
        desktopCardList.push(cardItem);
      } else if (layoutInfo.typeId === CommonConstants.TYPE_FORM_STACK) {
        const cardList = this.handleStackDisplayList(layoutInfo);
        const stackItem: DesktopStackInfo = {
          coordinate: { column: layoutInfo.column, row: layoutInfo.row },
          cardList: cardList,
        }
        desktopStackList.push(stackItem);
      }
    });
  }

  /**
   * 处理大文件夹曝光元素
   * @param layoutInfo
   * @param layoutInfoInFolder
   * @param isBigFolder
   * @returns
   */
  private handleBigFolderDisPlayAppList(layoutInfo: GridLayoutItemInfo, isBigFolder: boolean): string[] {
    const bigFolderDisplayAppList: string[] = [];
    const layoutInfoInFolder: GridLayoutItemInfo[][] | undefined = layoutInfo.layoutInfo;
    if (isBigFolder && layoutInfoInFolder) {
      // 判断为大文件夹
      const folderCount = GridLayoutUtil.getCountPerPageInFolder(layoutInfo.area);
      const layoutCount = layoutInfoInFolder[0] ? layoutInfoInFolder[0].length : 0;
      const count = Math.min(folderCount - 1, layoutCount);
      for (let i = 0; i < count; i++) {
        const el: GridLayoutItemInfo = layoutInfoInFolder[0][i];
        bigFolderDisplayAppList.push(el.bundleName);
      }
    }
    return bigFolderDisplayAppList;
  }

  /**
   * 处理堆叠卡片曝光元素
   * @param layoutInfo
   * @returns
   */
  private handleStackDisplayList(layoutInfo: GridLayoutItemInfo | FormStackInfo): string[] {
    const cardList: string[] = [];
    if (layoutInfo.layoutInfo) {
      layoutInfo.layoutInfo.flat().forEach((item: GridLayoutItemInfo | CardItemInfo) => {
        cardList.push(item.cardName!);
      })
    }
    return cardList;
  }

  /**
   * 处理桌面Dock曝光数据
   * @param appList
   * @param folderList
   * @param dockData
   * @returns
   */
  private handleDockExposureData(desktopAppList: DesktopAppInfo[], desktopFolderList: DesktopFolderInfo[],
    dockData: DockItemInfo[]): void {
    // 添加dock数据
    dockData.forEach((dockInfo: DockItemInfo) => {
      if (dockInfo.typeId === CommonConstants.TYPE_APP || dockInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        const appItem: DesktopAppInfo = {
          bundleName: dockInfo.bundleName,
          coordinate: { column: dockInfo.column, row: dockInfo.row },
          station: STATION_DOCK,
        }
        desktopAppList.push(appItem);
      } else if (dockInfo.typeId === CommonConstants.TYPE_FOLDER) {
        const folderItem: DesktopFolderInfo = {
          folderId: dockInfo.appId!,
          coordinate: { column: dockInfo.column, row: dockInfo.row },
          folderName: FolderExtension.getInstance().getRealFolderName(dockInfo.appName),
          bigFolderDisplayAppList: [],
          station: STATION_DOCK,
          isBigFolder: false
        }
        desktopFolderList.push(folderItem);
      }
    });
  }

  /**
   * 处理折叠屏
   * @param isFoldStatus
   * @param isUltraScreen
   * @returns
   */
  public async handleFolderChange(isFoldStatus: boolean): Promise<void> {
    if (this.desktopExposureTimeStart !== -1) {
      await this.handleDesktopExposureTimeEnd(this.oldDesktopPageIndex, this.newDesktopPageIndex, true);
      await this.handleDesktopExposureTimeStart();
    }
  }

  /**
   * 记录堆叠曝光开始时间
   * @param stackInfo
   * @returns
   */
  public async handleStackExposureTimeStart(stackInfo: FormStackInfo): Promise<void> {
    log.showWarn(TAG, `handleStackExposureTimeStart`);
    this.stackExposureTimeStart = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
    this.formStackInfo = stackInfo;
    this.handleDesktopExposureTimeEnd(this.oldDesktopPageIndex, this.newDesktopPageIndex, true);
  }

  /**
   * 记录堆叠曝光开始结束
   * @returns
   */
  public async handleStackExposureTimeEnd(): Promise<void> {
    const stackExposureTimeStart = this.stackExposureTimeStart;
    const stackExposureTimeEnd = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP, false);
    const lastTime = stackExposureTimeEnd - stackExposureTimeStart;
    log.showWarn(TAG, `stack exposure stackExposureTimeStart: ${stackExposureTimeStart}, lastTime: ${lastTime}`);
    if (stackExposureTimeStart > 0 && lastTime > PRE_INSTALL_EXPOSURE_TIME) {
      try {
        await this.saveStackExposureData(Math.floor(lastTime / 1000));
      } catch (err) {
        log.showWarn(TAG, `saveStackExposureData failed, code: ${err.code}, message: ${err.message}`);
      }
    }
    this.formStackInfo = null;
    this.stackExposureTimeStart = -1;
    this.handleDesktopExposureTimeStart();
  }

  /**
   * 记录堆叠曝光数据
   * @param lastTime
   * @returns
   */
  public async saveStackExposureData(lastTime: number): Promise<void> {
    const id = this.formStackInfo!.formStackId!;
    const stackExposureDataList = this.exposureData!.getStackExposureDataList();
    const stackExposureData: StackExposureData | undefined =
      stackExposureDataList.find((item: StackExposureData) => item.id === id);

    const cardList = this.handleStackDisplayList(this.formStackInfo!);

    if (stackExposureData) {
      stackExposureData.desktopPageIndex = this.formStackInfo!.page
      stackExposureData.exposureTime = stackExposureData.exposureTime + lastTime;
      stackExposureData.exposureCount = stackExposureData.exposureCount + 1;
      stackExposureData.cardList = cardList;
      this.showLog(stackExposureData, STACK_EXPOSURE_DATA);
    } else {
      const newStackData: StackExposureData = {
        id: id,
        desktopPageIndex: this.formStackInfo!.page,
        exposureTime: lastTime,
        exposureCount: 1,
        cardList: cardList,
        coordinate: { column: this.formStackInfo!.column, row: this.formStackInfo!.row },
      };
      this.exposureData.insertStackExposureDataList(newStackData);
      this.showLog(newStackData, STACK_EXPOSURE_DATA);
    }
  }

  /**
   * 开启上报任务
   * @returns
   */
  private startReportTask(): void {
    DailyScheduledReporter.getInstance().unRegisterTask(this.dailyTask);
    DailyScheduledReporter.getInstance().registerTask(this.dailyTask);
  }

  /**
   * 上报曝光数据
   * @returns
   */
  private async reportExposureData(): Promise<void> {
    const desktopReportData =
      this.exposureData.getDesktopExposureDataList().map((item: DesktopExposureData): string => {
        return JSON.stringify({
          desktopPageIndex: item.desktopPageIndex,
          exposureTime: item.exposureTime,
          exposureCount: item.exposureCount,
          desktopAppInfoList: item.desktopAppInfoList,
          desktopFolderInfoList: item.desktopFolderInfoList,
          desktopCardInfoList: item.desktopCardInfoList,
          desktopStackInfoList: item.desktopStackInfoList,
        });
      });
    const folderReportData =
      this.exposureData.getFolderExposureDataList().map((item: FolderExposureData): string => {
        return JSON.stringify({
          folderId: item.folderId,
          folderName: item.folderName,
          coordinate: item.coordinate,
          desktopPageIndex: item.desktopPageIndex,
          pageIndex: item.pageIndex,
          exposureTime: item.exposureTime,
          exposureCount: item.exposureCount,
          folderAppList: item.folderAppList,
          isBigFolder: item.isBigFolder,
        });
      });
    const stackReportData =
      this.exposureData.getStackExposureDataList().map((item: StackExposureData): string => {
        return JSON.stringify({
          coordinate: item.coordinate,
          desktopPageIndex: item.desktopPageIndex,
          exposureTime: item.exposureTime,
          exposureCount: item.exposureCount,
          cardList: item.cardList,
        });
      });
    const reportData = new Map<string, string[]>();
    reportData.set(DESKTOP_EXPOSURE_DATA, desktopReportData);
    reportData.set(FOLDER_EXPOSURE_DATA, folderReportData);
    reportData.set(STACK_EXPOSURE_DATA, stackReportData);
    await HiSysEventUtil.reportExposureData(reportData);
    this.exposureData.resetData();
  }

  private showLog(exposureData: DesktopExposureData | FolderExposureData | StackExposureData, type: string): void {
    if (type === DESKTOP_EXPOSURE_DATA) {
      const data: DesktopExposureData = exposureData as DesktopExposureData;
      let desktopAppInfoListStr = '';
      let desktopFolderInfoListStr = '';
      let desktopCardInfoListStr = '';
      let desktopStackInfoListStr = '';
      data.desktopAppInfoList.forEach((item: DesktopAppInfo) => {
        desktopAppInfoListStr += `{bundleName:${item.bundleName},` +
          `coordinate:{column:${item.coordinate?.column},row:${item.coordinate?.row}},` +
          `station:${item.station}},`;
      });

      data.desktopFolderInfoList.forEach((item: DesktopFolderInfo) => {
        desktopFolderInfoListStr += `{folderId:${item.folderId},` +
          `isBigFolder:${item.isBigFolder},` +
          `bigFolderDisplayAppList:[${item.bigFolderDisplayAppList.join(',')}],` +
          `coordinate:{column:${item.coordinate?.column},row:${item.coordinate?.row}},` +
          `station:${item.station}},`;
      });

      data.desktopCardInfoList.forEach((item: DesktopCardInfo) => {
        desktopCardInfoListStr += `{cardName:${item.cardName},` +
          `coordinate:{column:${item.coordinate?.column},row:${item.coordinate?.row}}},`;
      });

      data.desktopStackInfoList.forEach((item: DesktopStackInfo) => {
        desktopStackInfoListStr += `{coordinate:{column:${item.coordinate?.column},row:${item.coordinate?.row}},` +
          `cardList:[${item.cardList.join(',')}]},`;
      });

      log.showWarn(TAG, `desktop exposure save data: {` +
        `desktopPageIndex:${data.desktopPageIndex},` +
        `exposureTime:${data.exposureTime},` +
        `exposureCount:${data.exposureCount},` +
        `desktopAppInfoList:[${desktopAppInfoListStr}],` +
        `desktopFolderInfoList:[${desktopFolderInfoListStr}],` +
        `desktopCardInfoList:[${desktopCardInfoListStr}],` +
        `desktopStackInfoList:[${desktopStackInfoListStr}]}`);
    } else if (type === FOLDER_EXPOSURE_DATA) {
      const data: FolderExposureData = exposureData as FolderExposureData;
      let folderAppListStr = '';
      data.folderAppList.forEach((item: FolderApp) => {
        folderAppListStr += `{bundleName: ${item.bundleName},` +
          `coordinate:{column:${item.coordinate?.column},row:${item.coordinate?.row}}},`;
      });
      log.showWarn(TAG, `folder exposure save data: {` +
        `folderId:${data.folderId},` +
        `exposureTime:${data.exposureTime},` +
        `exposureCount:${data.exposureCount},` +
        `coordinate:{column:${data.coordinate?.column},row:${data.coordinate?.row}},` +
        `desktopPageIndex:${data.desktopPageIndex},` +
        `pageIndex:${data.pageIndex},` +
        `folderAppList:[${folderAppListStr}],` +
        `isBigFolder:${data.isBigFolder}}`);
    } else if (type === STACK_EXPOSURE_DATA) {
      const data: StackExposureData = exposureData as StackExposureData;
      log.showWarn(TAG, `stack exposure save data: {` +
        `desktopPageIndex:${data.desktopPageIndex},` +
        `exposureTime:${data.exposureTime},` +
        `exposureCount:${data.exposureCount},` +
        `cardList:[${data.cardList.join(',')}],` +
        `coordinate:{column:${data.coordinate?.column},row:${data.coordinate?.row}}}`);
    }
  }
}

class FolderExtension extends FolderViewModel {
  public static getInstance = SingletonHelper.createFactory(() => new FolderExtension());
  public constructor() {
    super();
  }

  async getNewFolderName(): Promise<string> {
    return '';
  }
}