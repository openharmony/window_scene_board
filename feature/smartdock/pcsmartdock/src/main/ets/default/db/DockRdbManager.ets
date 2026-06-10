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

import taskPool from '@ohos.taskpool';
import rdb from '@ohos.data.relationalStore';
import { LogDomain, Logger } from '@ohos/basicutils';
import { GlobalContext, GraphicUtils, rdbStoreHelper } from '@ohos/frameworkwrapper';
import type Context from '@ohos.app.ability.common';
import { CommonConstants } from '@ohos/launchercommon';
import { rdbTaskPool } from '@ohos/launchercommon/Index';
import { DockMenuDataType, DockMenuTaskInfo } from '../bean/DockMenuTaskInfo';
import DockMenuTaskInfoColumns from './DockMenuTaskInfoColumns';
import { DockMenuTaskDbBuilder } from './DockMenuTaskInfoDbBuilder';
import { DockRdbStoreConfig } from './DockRdbStoreConfig';
import { DockMenuCategory } from '../model/DockMenuCategory';
import { DockMenuTaskUtils } from '../utils/DockMenuTaskUtils';

const TAG = 'DockRdbManager';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

export class DockRdbManager {
  private static instance: DockRdbManager | undefined = undefined;

  public static getInstance(): DockRdbManager {
    if (!DockRdbManager.instance) {
      DockRdbManager.instance = new DockRdbManager();
    }
    return DockRdbManager.instance;
  }

  /**
   * 表初始化
   */
  async initDockMenuTaskTable(): Promise<void> {
    log.showInfo(TAG, 'initQuickBarMenuTable start');
    try {
      await rdbStoreHelper.executeSql(DockRdbStoreConfig.dockMenuTaskInfo.createTable);
    } catch (err) {
      log.showError(TAG, `initTable error: ${err?.message}`);
    }
  }

  /**
   * 查询所有菜单项
   * @returns
   */
  async queryAllDockTaskInfo(): Promise<DockMenuTaskInfo[]> {
    log.showInfo(TAG, 'queryAllDockTaskInfo');
    let conditions: Map<string, rdb.ValueType> = new Map();
    return await this.queryDockMenuTask(DockRdbStoreConfig.dockMenuTaskInfo.tableName, conditions);
  }

  /**
   * 查询某一个菜单项下的任务信息
   * @param bundleName
   * @returns
   */
  async queryDockTaskInfoList(bundleName: string): Promise<DockMenuTaskInfo[]> {
    log.showInfo(TAG, `queryTaskInfoWithBundleName bundleName: ${bundleName}`);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(DockMenuTaskInfoColumns.BUNDLE_NAME, bundleName);
    return await this.queryDockMenuTask(DockRdbStoreConfig.dockMenuTaskInfo.tableName, conditions);
  }

  /**
   * 新增分组
   * @param category
   * @returns
   */
  async insertDockMenuCategory(category: DockMenuCategory): Promise<boolean> {
    log.showInfo(TAG, `insertDockMenuCategory insert item ${category.categoryName} bundleName:${category.bundleName}`);
    let changeRows = -1;
    try {
      const insertBucket: rdb.ValuesBucket = {
        'data_type': DockMenuDataType.TYPE_CATEGORY,
        'task_id': -1,
        'task_name': '',
        'task_icon': '',
        'task_detail': '',
        'task_parameters': '',
        'task_state': -1,
        'bundle_name': category.bundleName,
        'module_name': '',
        'ability_name': '',
        'category_id': category.categoryId,
        'category_name': category.categoryName,
        'category_type': category.categoryType,
        'create_time': category.createTime
      };
      changeRows = await rdbTaskPool.insert(DockRdbStoreConfig.dockMenuTaskInfo.tableName, insertBucket);
    } catch (err) {
      log.showError(TAG, `insertDockMenuCategory failed, code: ${err?.code}, message: ${err?.message}`);
    }
    log.showInfo(TAG, `insertDockMenuCategory insert: ${changeRows}`);
    return (changeRows !== CommonConstants.INVALID_VALUE);
  }

  /**
   * 新增任务
   * @param task
   * @returns
   */
  async insertDockMenuTask(task: DockMenuTaskInfo): Promise<boolean> {
    log.showInfo(TAG, `insertDockMenuTask insert item taskName: ${task.taskName} bundleName:${task.bundleName}`);
    let changeRows = -1;
    await DockMenuTaskUtils.updateTaskIconBaseStr(task);
    try {
      const insertBucket: rdb.ValuesBucket = {
        'data_type': task.dataType,
        'task_id': task.taskId,
        'task_name': task.taskName,
        'task_icon': task.taskIcon ?? '',
        'task_detail': task.taskDetail ?? '',
        'task_parameters': task.parametersStr ?? '',
        'task_state': task.taskState,
        'bundle_name': task.bundleName,
        'module_name': task.moduleName ?? '',
        'ability_name': task.abilityName,
        'category_id': task.categoryId,
        'category_name': task.categoryName,
        'category_type': task.categoryType,
        'create_time': task.createTime
      };
      changeRows = await rdbTaskPool.insert(DockRdbStoreConfig.dockMenuTaskInfo.tableName, insertBucket);
    } catch (err) {
      log.showError(TAG, `insertDockMenuTask failed, code: ${err?.code}, message: ${err?.message}`);
    }
    log.showInfo(TAG, `insertDockMenuTask insert: ${changeRows}`);
    return (changeRows !== CommonConstants.INVALID_VALUE);
  }

  /**
   * 更新某一个分组名和index
   * @param category
   * @returns
   */
  async updateDockMenuCategory(category: DockMenuCategory): Promise<boolean> {
    log.showInfo(TAG, `updateDockMenuCategory categoryName:${category.categoryName} bundleName:${category.bundleName}`);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(DockMenuTaskInfoColumns.BUNDLE_NAME, category.bundleName);
    conditions.set(DockMenuTaskInfoColumns.CATEGORY_ID, category.categoryId);
    conditions.set(DockMenuTaskInfoColumns.DATA_TYPE, DockMenuDataType.TYPE_CATEGORY);
    const updateBucket: rdb.ValuesBucket = {
      'category_name': category.categoryName,
      'category_type': category.categoryType,
      'create_time': category.createTime
    };
    let changeRows = await rdbTaskPool.update(DockRdbStoreConfig.dockMenuTaskInfo.tableName, conditions, updateBucket);
    log.showWarn(TAG, `updateDockMenuCategory affect ${changeRows}`);
    return (changeRows !== CommonConstants.INVALID_VALUE);
  }

  /**
   * 更新某一个menu task
   * @param task
   * @returns
   */
  async updateDockMenuTask(task: DockMenuTaskInfo): Promise<boolean> {
    log.showInfo(TAG, `updateDockMenuTaskInfo taskName: ${task.taskName} bundleName:${task.bundleName}`);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(DockMenuTaskInfoColumns.TASK_ID, task.taskId);
    conditions.set(DockMenuTaskInfoColumns.BUNDLE_NAME, task.bundleName);
    conditions.set(DockMenuTaskInfoColumns.CATEGORY_ID, task.categoryId);
    await DockMenuTaskUtils.updateTaskIconBaseStr(task);
    const updateBucket: rdb.ValuesBucket = {
      'task_name': task.taskName,
      'task_icon': task.taskIcon ?? '',
      'task_detail': task.taskDetail ?? '',
      'task_parameters': task.parametersStr ?? '',
      'bundle_name': task.bundleName,
      'module_name': task.moduleName ?? '',
      'ability_name': task.abilityName,
    };
    let changeRows = await rdbTaskPool.update(DockRdbStoreConfig.dockMenuTaskInfo.tableName, conditions, updateBucket);
    log.showWarn(TAG, `updateDockMenuTask, affect ${changeRows}`);
    return (changeRows !== CommonConstants.INVALID_VALUE);
  }

  /**
   * 删除某一个menu task
   * @param task
   * @returns
   */
  async deleteDockMenuTask(task: DockMenuTaskInfo): Promise<boolean> {
    log.showInfo(TAG, `deleteDockMenuTask taskName: ${task.taskName} bundleName:${task.bundleName}`);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(DockMenuTaskInfoColumns.BUNDLE_NAME, task.bundleName);
    conditions.set(DockMenuTaskInfoColumns.TASK_ID, task.taskId);
    let changeRows = await rdbTaskPool.delete(DockRdbStoreConfig.dockMenuTaskInfo.tableName, conditions);
    log.showWarn(TAG, `deleteDockMenuTask, affect ${changeRows}`);
    return (changeRows !== CommonConstants.INVALID_VALUE);
  }

  /**
   * 删除某一个category
   * @param task
   * @returns
   */
  async deleteDockMenuCategory(task: DockMenuCategory): Promise<boolean> {
    log.showInfo(TAG, `deleteDockMenuCategory taskName: ${task.categoryName} bundleName:${task.bundleName}`);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(DockMenuTaskInfoColumns.BUNDLE_NAME, task.bundleName);
    conditions.set(DockMenuTaskInfoColumns.CATEGORY_ID, task.categoryId);
    let changeRows = await rdbTaskPool.delete(DockRdbStoreConfig.dockMenuTaskInfo.tableName, conditions);
    log.showWarn(TAG, `badge fixed type updated, affect ${changeRows}`);
    return (changeRows !== CommonConstants.INVALID_VALUE);
  }

  /**
   * 删除某一个应用的全部菜单信息
   * @param bundleName 应用bundleName
   * @returns
   */
  async deleteAllDockMenuTask(bundleName: string): Promise<boolean> {
    log.showInfo(TAG, `deleteDockWithBundleName bundleName:${bundleName}`);
    let conditions: Map<string, rdb.ValueType> = new Map();
    conditions.set(DockMenuTaskInfoColumns.BUNDLE_NAME, bundleName);
    const changeRows = await rdbTaskPool.delete(DockRdbStoreConfig.dockMenuTaskInfo.tableName, conditions);
    log.showWarn(TAG, `deleteDockWithBundleName end. affect ${changeRows}`);
    return (changeRows !== CommonConstants.INVALID_VALUE);
  }

  public async queryDockMenuTask(table: string, condition: Map<string, rdb.ValueType>): Promise<DockMenuTaskInfo[]> {
    let result: DockMenuTaskInfo[] =
      await this.doTask('queryDockMenuTask', queryDockMenuTaskInfo, table, condition) as DockMenuTaskInfo[];
    return result === undefined ? [] : result;
  }

  private async doTask(name: string, func: Function, ...args: Object[]): Promise<Object | undefined> {
    try {
      let context = GlobalContext.getContext();
      args.push(context);
      log.showWarn(TAG, `doTask start name: ${name}`);
      const dbTask = new taskPool.Task(name, func, ...args);
      return await taskPool.execute(dbTask);
    } catch (err) {
      log.showError(TAG, `doTask[${func.name}] name:[${name}] error ${err?.code}: ${err?.message}`);
    }
    return undefined;
  }
}

@Concurrent
async function queryDockMenuTaskInfo(tableName: string, conditions: Map<string, rdb.ValueType>,
  context: Context.BaseContext): Promise<DockMenuTaskInfo[]> {
  const TAG = 'DockRdbManager';
  const log: Logger = Logger.getLogHelper(LogDomain.HOME);
  log.showWarn(TAG, 'queryDockMenuTaskInfo start');
  const predicates = new rdb.RdbPredicates(tableName);
  conditions?.forEach((value, key) => {
    predicates.and().equalTo(key, value);
  });
  let resultList: DockMenuTaskInfo[] = [];
  try {
    let resultSet = await rdbStoreHelper.query(predicates, [], context);
    while (resultSet.goToNextRow()) {
      let item: DockMenuTaskInfo = DockMenuTaskDbBuilder.buildDockMenuTaskInfo(resultSet);
      if (item.taskIcon) {
        item.taskIconImg = GraphicUtils.changeBase64ToPixelSync(item.taskIcon);
      }
      resultList.push(item);
    }
    resultSet.close();
  } catch (e) {
    log.showError(TAG, 'queryDockMenuTaskInfo error%{public}d:%{public}s', e.code, e.message);
  }
  log.showWarn(TAG, `queryDockMenuTaskInfo end ${resultList.length}`);
  return resultList;
}
