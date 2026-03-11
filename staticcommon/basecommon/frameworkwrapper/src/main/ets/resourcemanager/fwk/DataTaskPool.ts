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

import { LogDomain, Logger, Trace } from '@ohos/basicutils';
import { image } from '@kit.ImageKit';
import { bundleResourceManager } from '@kit.AbilityKit';
// import { hdsDrawable } from '@kit.UIDesignKit';
import { taskpool } from '@kit.ArkTS';
import type Context from '@ohos.app.ability.common';
import rdb from '@ohos.data.relationalStore';
import bundleManager from '@ohos.bundle.bundleManager';
import { bundleManagerFwk } from './BundleManagerFwk';
import IconInfo from '../IconInfo';
import { IconPicType, IconDatabaseColumn } from '../IconInfo';
import { RdbStoreHelper } from '../../service/db/RdbStoreHelper';
import { GraphicUtils } from '../GraphicsUtils';
import commonBundleManager from '../../manager/CommonBundleManager';
import RdbStoreConfig from '../../service/db/RdbStoreConfig';
import { GlobalContext } from '../../utils/GlobalContext';
import { DataAndRefreshUtils, Icon } from './DataAndRefreshUtils';

const TAG = 'DataTaskPool';
const log: Logger = Logger.getLogHelper(LogDomain.SCB);

/**
 * 资源获取和缓存存储相关的任务处理,包含:
 * 1.记录当前运行的task集合,并支持打断
 * 2.支持全量资源查询和批量入库,后续可继续新增相关子线程处理
 */
export class DataTaskPool {
  private static instance?: DataTaskPool;

  private batchTaskMap: Map<number, Set<number>> = new Map();

  private constructor() {
  }

  public static getInstance(): DataTaskPool {
    if (!DataTaskPool.instance) {
      DataTaskPool.instance = new DataTaskPool();
    }
    return DataTaskPool.instance;
  }

  /**
   * 从bms全量查询数据并经过hds处理后的图标资源
   *
   * @param deliverAppIconInfosMap dh应用列表
   * @param batchId 刷新批次标识,如不考虑打断可传0
   * @returns 经过处理后的图标资源
   */
  public async startAllRes(deliverAppIconInfosMap: Map<string, IconInfo>, batchId: number): Promise<IconInfo[]> {
    let iconSizeOfGrid: number = bundleManagerFwk.getIconSizeOfGrid();
    let iconInfos: IconInfo[] = [];
    try {
      let task: taskpool.Task =
        new taskpool.Task('getIconResourceAll_' + batchId, getIconResourceAll, deliverAppIconInfosMap, iconSizeOfGrid,
          bundleManagerFwk.getMaskImage());
      let resFinish: () => void = () => {
        log.showWarn(TAG, 'startAllRes end, batchId: %{public}d, taskId: %{public}d', batchId, task.taskId);
        this.batchTaskMap.get(batchId)?.delete(task.taskId);
      };
      this.addRunningTask(task.taskId, batchId, 'startAllRes');
      this.addTaskCallback(task, batchId, 'startAllRes', resFinish);
      iconInfos = await taskpool.execute(task) as IconInfo[];
    } catch (error) {
      log.showError(TAG, `getIconResourceFromFwkAll error ${error}`);
    }
    return iconInfos;
  }

  private addRunningTask(taskId: number, batchId: number, tag: string): void {
    let set: Set<number> = this.batchTaskMap.get(batchId) ?? new Set();
    set.add(taskId);
    this.batchTaskMap.set(batchId, set);
    log.showWarn(TAG, '%{public}s add to set, taskId: %{public}d, batchId: %{public}d', tag, batchId, taskId);
  }

  /**
   * 将图标资源批量插入数据库缓存
   *
   * @param iconInfos 图标资源
   * @param batchId 刷新批次标识,如不考虑打断可传0
   * @param allFinished 任务执行完成回调,如不需要可传空
   */
  public async startBatchInsertInfo(iconInfos: IconInfo[], batchId: number, allFinished: () => void): Promise<void> {
    try {
      let task: taskpool.Task = new taskpool.Task('setIconDBResourceArray', batchInsertInfo, iconInfos,
        GlobalContext.getContext());
      this.addRunningTask(task.taskId, batchId, 'startBatchInsertInfo');
      let dbFinish: () => void = () => {
        iconInfos.filter((info: IconInfo) => {
          return info.iconType === IconPicType.ADAPTIVE;
        }).forEach((info: IconInfo) => {
          info.adaptivePicSrc[0].release();
          info.adaptivePicSrc[1].release();
        });
        if (this.batchTaskMap.get(batchId)?.has(task.taskId)) {
          log.showWarn(TAG, 'startBatchInsertInfo end, batchId: %{public}d, taskId: %{public}d', batchId, task.taskId);
          allFinished();
        } else {
          log.showWarn(TAG, 'startBatchInsertInfo cancel, batchId: %{public}d, taskId: %{public}d', batchId,
            task.taskId);
          GlobalContext.getContext().eventHub.emit(DataAndRefreshUtils.EVENT_STRATEGY_CANCEL_FINISH);
        }
        this.batchTaskMap.delete(batchId);
      };
      this.addTaskCallback(task, batchId, 'startBatchInsertInfo', dbFinish);
      taskpool.execute(task);
    } catch (error) {
      log.showError(TAG, `startBatchInsertInfo error ${error}`);
    }
  }

  private addTaskCallback(task: taskpool.Task, batchId: number, tag: string, taskFinished: () => void): void {
    task.onExecutionFailed((error: Error) => {
      log.showError(TAG, `${tag} onExecutionFailed error: ${error}`);
      taskFinished();
    });
    task.onExecutionSucceeded(() => {
      log.showWarn(TAG, '%{public}s end, batchId: %{public}d, taskId: %{public}d', tag, batchId, task.taskId);
      taskFinished();
    });
  }

  /**
   * 取消对应刷新批次中正在执行的任务
   *
   * @param batchId 刷新批次标识
   */
  public cancelTask(batchId: number): void {
    log.showWarn(TAG, 'start task cancel, batchId: %{public}d', batchId);
    if (this.batchTaskMap.has(batchId)) {
      let values: IterableIterator<number> = this.batchTaskMap.get(batchId)?.values();
      for (let i = 0; i < this.batchTaskMap.get(batchId)?.size; i++) {
        let taskId: number = values.next()?.value;
        try {
          this.batchTaskMap.get(batchId)?.delete(taskId);
          taskpool.cancel(taskId);
          log.showWarn(TAG, 'cancelTask id: %{public}d', taskId);
        } catch (error) {
          log.showError(TAG, `cancelTask id ${taskId} error ${error}`);
        }
      }
    } else {
      log.showWarn(TAG, 'no task cancel, batchId: %{public}d', batchId);
      GlobalContext.getContext().eventHub.emit(DataAndRefreshUtils.EVENT_STRATEGY_CANCEL_FINISH);
    }
  }
}

async function getIconResourceAll(deliverAppIconInfosMap: Map<string, IconInfo>, iconSizeOfGrid: number,
  maskImage: image.PixelMap): Promise<IconInfo[]> {
  'use concurrent';

  const TAG = 'DataTaskPool_getIconResourceAll';
  const log: Logger = Logger.getLogHelper(LogDomain.SCB);

  // hds批量处理图片的范围是4-10,避免因为批量处理时线程过程导致内存增大,此处选取适中值8
  const HDS_BATCH_COUNT: number = 8;

  let bmsRes: bundleResourceManager.LauncherAbilityResourceInfo[] = [];
  log.showWarn(TAG, `getAllLauncherAbilityResourceInfo start`);
  Trace.start(`onThemeChange_BMS`);
  try {
    let resourceFlag = 0x00000020 | 0x00000010;
    bmsRes = await bundleResourceManager.getAllLauncherAbilityResourceInfo(resourceFlag);
  } catch (e) {
    log.showError(TAG, `getAllLauncherAbilityResourceInfo error ${e}`);
  }
  Trace.end(`onThemeChange_BMS`);
  log.showWarn(TAG, `getAllLauncherAbilityResourceInfo end, res.length ${bmsRes.length}`);

  log.showWarn(TAG, 'getHdsData start');
  let icons: Icon[] = [];
  // let layeredIcons: hdsDrawable.LayeredIcon[] = [];
  let iconInfos: IconInfo[] = [];
  DataAndRefreshUtils.handleLayeredIconAndIcon(bmsRes, icons, iconInfos, deliverAppIconInfosMap);
  log.showWarn(TAG, 'HdsData has been organized， icons size: %{public}d', icons.length);

  if (taskpool.Task.isCanceled()) {
    log.showWarn(TAG, 'getAllLauncherAbilityResourceInfo cancel on getBms');
    DataAndRefreshUtils.releaseBmsInoRes(bmsRes);
    return [];
  }

  // Trace.start(`onThemeChange_HDS`);
  // let res: hdsDrawable.ProcessedIcon[] = [];
  // try {
  //   let option: hdsDrawable.Options = {
  //     size : iconSizeOfGrid,
  //     hasBorder : false,
  //     parallelNumber: HDS_BATCH_COUNT,
  //   };
  //   if (layeredIcons.length > 0) {
  //     let layeredRes: hdsDrawable.ProcessedIcon[] = await hdsDrawable.getHdsLayeredIcons(layeredIcons, option);
  //     res.push(...layeredRes);
  //     // 双层图标需待转换完pixmap后释放
  //   }
  //   if (icons.length > 0) {
  //     let iconRes: hdsDrawable.ProcessedIcon[] = await hdsDrawable.getHdsIcons(icons, maskImage, option);
  //     res.push(...iconRes);
  //     icons.forEach((icon: hdsDrawable.Icon) => {
  //       icon.pixelMap.release();
  //     });
  //   }
  // } catch (error) {
  //   log.showError(TAG, `hds error ${error}`);
  // }
  // Trace.end(`onThemeChange_HDS`);
  // log.showWarn(TAG, 'getHdsData end, res size: %{public}d', res.length);

  // if (taskpool.Task.isCanceled()) {
  //   log.showWarn(TAG, 'getAllLauncherAbilityResourceInfo cancel on getHds');
  //   DataAndRefreshUtils.releaseBmsInoRes(bmsRes);
  //   res.forEach((icon: hdsDrawable.ProcessedIcon) => {
  //     icon.pixelMap.release();
  //   });
  //   return [];
  // }

  DataAndRefreshUtils.handleInfos(iconInfos, bmsRes);
  return iconInfos;
}

async function batchInsertInfo(iconInfos: IconInfo[], context: Context.BaseContext): Promise<void> {
  'use concurrent';
  const TAG = 'DataTaskPool_batchInsertInfo';
  const log: Logger = Logger.getLogHelper(LogDomain.SCB);

  // 避免一次性插入数据量过大导致写库较慢,综合比对耗时和sql连接次数后,30条数据为一次插入较优
  const BATCH_INSERT_COUNT: number = 30;
  const BACK_PICTURE_INDEX: number = 0;
  const FORE_PICTURE_INDEX: number = 1;

  log.showWarn(TAG, 'batchInsertIconInfo start, iconInfos size: %{public}d', iconInfos.length);
  let rdbStoreHelper: RdbStoreHelper = new RdbStoreHelper();
  await rdbStoreHelper.createRdbStore(context);
  let rdbStore: rdb.RdbStore = rdbStoreHelper.getRdbStore();
  if (!rdbStore) {
    log.showError(TAG, 'batchInsertIconInfo error, rdbStore is null!!!');
    return;
  }

  let childTaskInfos: IconInfo[] = [];
  let insertIconInfos: rdb.ValuesBucket[] = [];
  let insertBatchIndex: number = 0;
  try {
    rdbStore.beginTransaction();
    while (iconInfos.length > 0) {
      insertIconInfos = [];
      childTaskInfos = iconInfos.splice(0, BATCH_INSERT_COUNT);
      await DataAndRefreshUtils.handleInsertIconInfos(insertIconInfos, childTaskInfos);
      if (taskpool.Task.isCanceled()) {
        log.showWarn(TAG, 'batchInsertIconInfo cancel, break');
        break;
      }
      let succRow: number = await rdbStore.batchInsert(RdbStoreConfig.iconInfo.tableName, insertIconInfos);
      log.showWarn(TAG, 'batchInsertIconInfo batchIndex: %{public}d end, succRow: %{public}d', insertBatchIndex, succRow);
      insertBatchIndex++;
    }
    if (taskpool.Task.isCanceled()) {
      log.showWarn(TAG, 'batchInsertIconInfo cancel, return');
      rdbStore.rollBack();
      return;
    }
    rdbStore.commit();
    log.showWarn(TAG, 'batchInsertIconInfo end');
  } catch (error) {
    log.showError(TAG, `batchInsertInfo error. Code is ${error}, message is ${error?.message}`);
    rdbStore.rollBack();
  } finally {
    // 为防止写库过程中出现异常或该任务被取消时,所以在最后进行一次数组内的图片释放
    iconInfos.filter((info: IconInfo) => {
      return info.iconType === IconPicType.ADAPTIVE;
    }).forEach((info: IconInfo) => {
      info.adaptivePicSrc[BACK_PICTURE_INDEX]?.release();
      info.adaptivePicSrc[FORE_PICTURE_INDEX]?.release();
    });
    childTaskInfos.filter((info: IconInfo) => {
      return info.iconType === IconPicType.ADAPTIVE;
    }).forEach((info: IconInfo) => {
      info.adaptivePicSrc[BACK_PICTURE_INDEX]?.release();
      info.adaptivePicSrc[FORE_PICTURE_INDEX]?.release();
    });
    rdbStoreHelper.release();
  }
}