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

import { LogDomain, Logger } from '@ohos/basicutils';
import { DockItemInfo } from '../../bean/DockItemInfo';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { LaunchLayoutCacheManager } from '../../cache/layout/LaunchLayoutCacheManager';
import { ResidentLayoutCacheMgr } from '../../dock/cache/ResidentLayoutCacheMgr';
import GridLayoutUtil from '../../utils/GridLayoutUtil';
import { IconChangeListener } from '../AppModel';
import { ArrayUtils } from '@ohos/basicutils';
import { CommonConstants } from '../../constants/CommonConstants';
import { FolderAppItemInfo } from '../../folder/FolderItemInfo';
import { desktopUtil } from '@ohos/componenthelper';
import IconInfo from '@ohos/frameworkwrapper/src/main/ets/resourcemanager/IconInfo';
import { IconExtendParam, TaskInfo } from '@ohos/frameworkwrapper';
import { SCBConstants } from '@ohos/commonconstants';
import { LauncherAnimUtil } from '../../utils/LauncherAnimUtil';
import { FolderManager } from '../../folder/next/common/model/FolderManager';

const BATCH_COUNT: number = 12;
const REFRESH_INTERVAL: number = 100;
const MAX_BREAK_COUNT: number = 3;
const BREAK_DELAY: number = 600;

const TAG = 'LayoutRefreshManager';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

/**
 * 控件刷新通知类，用于按不同有优先级刷新布局（优先级逻辑和被交互打断场景待补充）
 */
export class LayoutRefreshManager {
  private static instance?: LayoutRefreshManager;

  private timeOutId: number = -1;

  private isCancelRefresh: boolean = false;

  private breakCount: number = 0;

  private constructor() {
  }

  public static getInstance(): LayoutRefreshManager {
    if (!LayoutRefreshManager.instance) {
      LayoutRefreshManager.instance = new LayoutRefreshManager();
    }
    return LayoutRefreshManager.instance;
  }

  /**
   * 将桌面上所有图标控件按当前显示页进行排序,不显示在桌面上的图标排在最后
   *
   * @param deliverAppIconInfosMap dh相关应用列表
   * @returns 排序好的图标集合,当前页上的图标显示在最前面，其次是相邻页,最后是显示在文件夹内的图标
   */
  public sortLayout(deliverAppIconInfosMap: Map<string, IconInfo>): RefreshViewDataCollection {
    log.showWarn(TAG, 'sortLayout start');
    let launchAppInfos: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance().getGridLayoutItemList();
    let showLaunchAppInfos: RefreshViewData[] = [];
    // 待补充获取文件夹折叠态上显示元素加入优先级排序
    FolderManager.getInstance();
    launchAppInfos.filter((item: GridLayoutItemInfo) => {
      return item.typeId === CommonConstants.TYPE_APP;
    }).forEach((item: GridLayoutItemInfo) => {
      showLaunchAppInfos.push(new RefreshViewData(item));
    });

    let pageIndex: number = desktopUtil.getPageIndexValue();
    let dockLayoutItemList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    dockLayoutItemList?.forEach((dockItem: DockItemInfo) => {
      let gridItemInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);
      if (gridItemInfo.typeId === CommonConstants.TYPE_APP) {
        showLaunchAppInfos.push(new RefreshViewData(gridItemInfo, pageIndex));
      }
    });

    let collection: RefreshViewDataCollection = new RefreshViewDataCollection();
    collection.currentViews = showLaunchAppInfos.filter((data: RefreshViewData) => {
      return data.pageIndex === pageIndex;
    }).map<TaskInfo>((data: RefreshViewData) => {
      return this.dataToTaskInfo(data, deliverAppIconInfosMap);
    });
    log.showWarn(TAG, 'sortLayout currentViews size: %{public}d', collection.currentViews.length);

    collection.otherViews = showLaunchAppInfos.filter((data: RefreshViewData) => {
      return data.pageIndex !== pageIndex;
    }).sort((dataA: RefreshViewData, dataB: RefreshViewData) => {
      return Math.abs(dataA.pageIndex - pageIndex) - Math.abs(dataB.pageIndex - pageIndex);
    }).map<TaskInfo>((data: RefreshViewData) => {
      return this.dataToTaskInfo(data, deliverAppIconInfosMap);
    });
    log.showWarn(TAG, 'sortLayout otherViews size: %{public}d', collection.otherViews.length);

    let backgroundViews: TaskInfo[] = [];
    let allInfo: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance().getAllApps();
    allInfo.filter((item: GridLayoutItemInfo) => {
      return item.typeId === CommonConstants.TYPE_APP && !collection.getShowBundleSet().has(item.bundleName);
    }).forEach((item: GridLayoutItemInfo) => {
      backgroundViews.push(this.dataToTaskInfo(new RefreshViewData(item), deliverAppIconInfosMap));
    });
    collection.backgroundViews = backgroundViews;
    log.showWarn(TAG, 'sortLayout backgroundViews size: %{public}d', collection.backgroundViews.length);
    return collection;
  }

  private dataToTaskInfo(data: RefreshViewData, deliverAppIconInfosMap: Map<string, IconInfo>): TaskInfo {
    let param = new IconExtendParam();
    param.bundleName = deliverAppIconInfosMap.has(data.bundleName) ?
      data.bundleName + SCBConstants.BUNDLENAME_APPEND_TEMPLATE : data.bundleName;
    return new TaskInfo(data.bundleName, data.moduleName, data.abilityName, param);
  }

  /**
   * 批量刷新图标控件
   *
   * @param iconChangeListener 图标控件刷新回调
   * @param taskInfos 需要刷新的图标集合
   */
  public refreshViewBatch(iconChangeListener: IconChangeListener[], taskInfos: TaskInfo[]): void {
    if (ArrayUtils.isEmpty(iconChangeListener) || ArrayUtils.isEmpty(taskInfos)) {
      log.showError(TAG, 'listener array is null in refreshView');
      return;
    }
    log.showWarn(TAG, 'refreshView start, listener size: %{public}d', iconChangeListener.length);
    taskInfos.forEach((info: TaskInfo) => {
      iconChangeListener.filter((listener: IconChangeListener) => {
        return listener.bundleName === info.bundleName && listener.moduleName === info.moduleName &&
          listener.abilityName === info.abilityName;
      }).forEach((listener: IconChangeListener) => {
        listener.onIconResourceChange();
      });
    });
  }

  /**
   * 通知图标控件批量完成UI刷新
   *
   * @param iconChangeListener 控件刷新监听
   * @param collection 控件刷新优先级标识
   * @param allFinished 刷新完成回调
   */
  public refreshView(iconChangeListener: IconChangeListener[], collection: RefreshViewDataCollection,
    allFinished: () => void): void {
    if (ArrayUtils.isEmpty(iconChangeListener)) {
      log.showError(TAG, 'listener array is null in refreshView');
      allFinished();
      return;
    }
    this.isCancelRefresh = false;
    this.breakCount = 0;

    // 当前显示页优先刷新,不会被当前用户交互打断,避免因为打断导致用户感官刷新慢
    let currentViews: TaskInfo[] = [];
    if (!ArrayUtils.isEmpty(collection.currentViews)) {
      currentViews = collection.getTaskInfoAndDelete(BATCH_COUNT);
    }
    currentViews.forEach((task: TaskInfo) => {
      iconChangeListener.filter((listener: IconChangeListener) => {
        return listener.bundleName === task.bundleName && listener.moduleName === task.moduleName &&
          listener.abilityName === task.abilityName;
      }).forEach((listener: IconChangeListener) => {
        listener.onIconResourceChange();
      });
    });

    log.showWarn(TAG, 'refreshView start, listener size: %{public}d, currentView size:', iconChangeListener.length,
      currentViews.length);
    this.batchRefreshView(collection, iconChangeListener, allFinished);
  }

  private batchRefreshView(collection: RefreshViewDataCollection, iconChangeListener: IconChangeListener[],
    allFinished: () => void): void {
    if (LauncherAnimUtil.isUiThreadBusy() && this.breakCount < MAX_BREAK_COUNT) {
      // 当前存在交互时则延后刷新,避免因为控件刷新导致交互过程中丢帧,打断超过3次后则强行批量刷新，每次打断延时2s后继续刷新
      log.showWarn(TAG, 'batchRefreshView by break, breakCount: %{public}d', this.breakCount);
      this.breakCount++;
      this.timeOutId = setTimeout(() => {
        this.batchRefreshView(collection, iconChangeListener, allFinished);
      }, BREAK_DELAY);
      return;
    }

    let tasks: TaskInfo[] = collection.getTaskInfoAndDelete(BATCH_COUNT);
    if (tasks.length === 0) {
      log.showWarn(TAG, 'batchRefreshView end');
      allFinished();
      return;
    }

    log.showWarn(TAG, 'batchRefreshView start, refresh: %{public}d', tasks.length);
    tasks.forEach((task: TaskInfo) => {
      iconChangeListener.filter((listener: IconChangeListener) => {
        return listener.bundleName === task.bundleName && listener.moduleName === task.moduleName &&
          listener.abilityName === task.abilityName;
      }).forEach((listener: IconChangeListener) => {
        listener.onIconResourceChange();
      });
    });

    if (this.isCancelRefresh) {
      return;
    }

    // 分批刷新控件，避免因为刷新控件过多导致超大帧
    this.timeOutId = setTimeout(() => {
      this.batchRefreshView(collection, iconChangeListener, allFinished);
    }, REFRESH_INTERVAL);
  }

  /**
   * 如当前正在进行分批刷新则取消当前的刷新
   */
  public cancelRefresh(): void {
    log.showWarn(TAG, 'cancelRefresh, timeOutId: %{public}d', this.timeOutId);
    this.isCancelRefresh = true;
    if (this.timeOutId !== -1) {
      clearTimeout(this.timeOutId);
    }
  }
}

export class RefreshViewData {
  bundleName: string = '';
  moduleName: string = '';
  abilityName: string = '';
  pageIndex: number = 0;

  constructor(item: GridLayoutItemInfo | FolderAppItemInfo, page?: number) {
    this.bundleName = item.bundleName;
    this.moduleName = item.moduleName ?? '';
    this.abilityName = item.abilityName;
    this.pageIndex = (page === undefined ? item.page : page) ?? 0;
  }
}

export class RefreshViewDataCollection {
  currentViews: TaskInfo[] = [];
  otherViews: TaskInfo[] = [];
  backgroundViews: TaskInfo[] = [];

  // bms数据库中不存在的图标,如未安装的快捷方式,应用内加桌的快捷方式,不存在于桌面缓存内的图标等
  extraViews: TaskInfo[] = [];

  constructor() {
    this.currentViews = [];
    this.otherViews = [];
    this.backgroundViews = [];
    this.extraViews = [];
  }

  /**
   * 获取显示在桌面上图标控件的包名集合
   * PS:桌面支持单应用多图标后此处需要变更
   *
   * @returns 显示桌面上的图标(不包含快捷方式)包名集合
   */
  public getShowBundleSet(): Set<string> {
    let set: Set<string> = new Set();
    this.currentViews.forEach((data: TaskInfo) => {
      set.add(data.bundleName);
    });
    this.otherViews.forEach((data: TaskInfo) => {
      set.add(data.bundleName);
    });
    return set;
  }

  /**
   * 按刷新优先级从集合中获取需要刷新的控件
   *
   * @param batchCount 每批获取刷新控件的个数
   * @returns 需要刷新的控件
   */
  public getTaskInfoAndDelete(batchCount: number): TaskInfo[] {
    let tasks: TaskInfo[] = [];
    if (!ArrayUtils.isEmpty(this.currentViews)) {
      tasks = this.currentViews.splice(0, this.currentViews.length);
    } else if (!ArrayUtils.isEmpty(this.otherViews)) {
      tasks = this.otherViews.splice(0, this.otherViews.length >= batchCount ? batchCount : this.otherViews.length);
    } else if (!ArrayUtils.isEmpty(this.backgroundViews)) {
      tasks = this.backgroundViews.splice(0,
        this.backgroundViews.length >= batchCount ? batchCount : this.backgroundViews.length);
    } else {
      tasks = this.extraViews.splice(0,
        this.extraViews.length >= batchCount ? batchCount : this.extraViews.length);
    }
    return tasks;
  }

  /**
   * 将非应用图标类型的控件信息填充入额外刷新图标中
   *
   * @param iconChangeListener 控件监听信息
   */
  public fillingExtraView(iconChangeListener: IconChangeListener[]): void {
    iconChangeListener.forEach((listener: IconChangeListener) => {
      if (!listener.bundleName) {
        return;
      }
      if (this.isExistView(this.currentViews, listener) || this.isExistView(this.otherViews, listener) ||
      this.isExistView(this.backgroundViews, listener)) {
        return;
      }
      let task: TaskInfo =
        new TaskInfo(listener.bundleName, listener.moduleName, listener.abilityName, new IconExtendParam());
      if (this.isExistView(this.extraViews, task)) {
        return;
      }
      this.extraViews.push(task);
    });
  }

  private isExistView(tasks: TaskInfo[], info: IconChangeListener | TaskInfo): boolean {
    let index: number = tasks.findIndex((task: TaskInfo) => {
      return task.bundleName === info.bundleName && task.moduleName === info.moduleName &&
        task.abilityName === info.abilityName;
    });
    return index !== -1;
  }
}