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

import { settings } from '@kit.BasicServicesKit';
import { LogDomain, Logger } from '@ohos/basicutils';
import { SCBConstants, SettingsConstants, SettingsKeyConstants } from '@ohos/commonconstants';
import {
  DeviceHelper,
  GlobalContext,
  IconExtendParam,
  IconResourceManager,
  TaskInfo,
  SettingsUtil
} from '@ohos/frameworkwrapper';
import { DataAndRefreshUtils } from '@ohos/frameworkwrapper/src/main/ets/resourcemanager/fwk/DataAndRefreshUtils';
import IconInfo from '@ohos/frameworkwrapper/src/main/ets/resourcemanager/IconInfo';
import { IconTaskManager } from '@ohos/frameworkwrapper/src/main/ets/resourcemanager/IconTaskManager';
import { IconChangeListener } from '../AppModel';
import { LayoutRefreshManager, RefreshViewDataCollection } from './LayoutRefreshManager';
import { RefreshStrategy } from './RefreshStrategy';

const TAG = 'MiniBatchRefreshStrategy';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
const REFRESH_BATCH_COUNT: number = 10;

/**
 * 默认处理策略，用于针对布局上图标控件很多时的场景，因为控件很多常驻内存较高，避免出现内存峰值过高场景，需要边获取资源边转化刷新控件并释放bms内存
 */
export class MiniBatchRefreshStrategy extends RefreshStrategy {
  public async refreshDataAndView(iconChangeListener: IconChangeListener[],
    deliverAppIconInfosMap: Map<string, IconInfo>, allFinished: () => void): Promise<void> {
    if (DeviceHelper.is2In1DevicePcType() || DeviceHelper.isPC()) {
      // pc和部分pad中因包含应用中心,缓存不包含全量元素,无法使用优先刷新当前页,需要按监听器进行全量刷新
      await this.refreshDataAndViewByListener(iconChangeListener, deliverAppIconInfosMap);
    } else {
      await this.refreshDataAndViewByCache(iconChangeListener, deliverAppIconInfosMap);
    }
    allFinished();
  }

  private async refreshDataAndViewByCache(iconChangeListener: IconChangeListener[],
    deliverAppIconInfosMap: Map<string, IconInfo>): Promise<void> {
    iconChangeListener.forEach((listener: IconChangeListener) => {
      if (!listener.bundleName) {
        listener.onIconResourceChange();
      }
    });
    let collection: RefreshViewDataCollection = LayoutRefreshManager.getInstance().sortLayout(deliverAppIconInfosMap);
    collection.fillingExtraView(iconChangeListener);
    let tasks: TaskInfo[][] = [];

    // 优先获取当前显示页的资源并完成刷新
    let taskInfos: TaskInfo[] = collection.currentViews;
    await this.getDataAndRefresh(tasks, taskInfos, iconChangeListener);

    // 刷新相邻页和非显示在桌面上的元素
    taskInfos = collection.otherViews;
    taskInfos.push(...collection.backgroundViews);
    taskInfos.push(...collection.extraViews);
    await this.getDataAndRefresh(tasks, taskInfos, iconChangeListener);
  }

  private async refreshDataAndViewByListener(iconChangeListener: IconChangeListener[],
    deliverAppIconInfosMap: Map<string, IconInfo>): Promise<void> {
    let taskInfos: TaskInfo[] = [];
    this.refreshReady(iconChangeListener, deliverAppIconInfosMap, taskInfos);
    let tasks: TaskInfo[][] = [];
    tasks = IconTaskManager.spliceTask(taskInfos);
    await Promise.all(tasks.map(async task => {
      log.showInfo(TAG, `childTask length = ${task.length} tasks length = ${tasks.length}`);
      await this.runTask(task, iconChangeListener);
    }));
  }

  private refreshReady(iconChangeListener: IconChangeListener[], deliverAppIconInfosMap: Map<string, IconInfo>,
    taskInfos: TaskInfo[]): void {
    iconChangeListener.forEach((listener: IconChangeListener) => {
      if (!listener.bundleName) {
        listener.onIconResourceChange();
        return;
      }
      let param = new IconExtendParam();
      param.bundleName = deliverAppIconInfosMap.has(listener.bundleName) ?
        listener.bundleName + SCBConstants.BUNDLENAME_APPEND_TEMPLATE : listener.bundleName;
      let taskInfo: TaskInfo = new TaskInfo(listener.bundleName, listener.moduleName ?? '',
        listener.abilityName ?? '', param);
      taskInfos.push(taskInfo);
    });
  }

  private async getDataAndRefresh(tasks: TaskInfo[][], taskInfos: TaskInfo[],
    iconChangeListener: IconChangeListener[]): Promise<void> {
    tasks = IconTaskManager.spliceTask(taskInfos);
    await Promise.all(tasks.map(async (task) => {
      log.showInfo(TAG, `childTask length = ${task.length} tasks length = ${tasks.length}`);
      await this.runTask(task, iconChangeListener);
    }));
  }

  private async runTask(task: TaskInfo[], iconChangeListener: IconChangeListener[]): Promise<void> {
    while (task.length > 0) {
      let childTask: TaskInfo[] = task.splice(0, REFRESH_BATCH_COUNT);
      await IconResourceManager.getInstance().refreshIconResourceBatch(childTask);
      LayoutRefreshManager.getInstance().refreshViewBatch(iconChangeListener, childTask);
    }
  }

  public cancelStrategy(): void {
    log.showWarn(TAG, 'cancel Strategy, batchId: %{public}d', this.getBatchId());
    super.cancelStrategy();
    GlobalContext.getContext().eventHub.emit(DataAndRefreshUtils.EVENT_STRATEGY_CANCEL_FINISH);
  }
}