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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { localEventManager } from '@ohos/frameworkwrapper';
import { DockItemInfo, EventConstants, ReceiveEventInfo } from '@ohos/launchercommon';
import { DockMenuDataType, DockMenuTaskInfo } from '../bean/DockMenuTaskInfo';
import { DockRdbManager } from '../db/DockRdbManager';
import { DockMenuCategory } from '../model/DockMenuCategory';
import { DockMenuTaskUtils, ErrorCode } from '../utils/DockMenuTaskUtils';

const TAG = 'PCDock-DockMenuTaskManager';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

class CategoryInfo {
  public categoryList: DockMenuCategory[] = [];
  public primaryId: number = 0;
  public maxCategoryId: number = 0;
  public maxTaskId: number = 0;
  public isInitFromDb: boolean = false;
  public isDirty: boolean = false;
}

/**
 * 维护数据库 和 本地状态
 */
export class DockMenuTaskManager {
  // 所有菜单数据，数据始终保持有序
  private taskMap: Map<string, CategoryInfo> = new Map();
  private static instance: DockMenuTaskManager | undefined = undefined;

  private localEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: DockItemInfo) => {
      log.showInfo('localEventListener receive event: %{public}s', event);
      switch (event) {
        case EventConstants.EVENT_SUGGEST_MENU_REMOVED:
          this.deleteAllCategory(params.bundleName);
          break;
        default:
          break;
      }
    }
  };

  private constructor() {
    this.init();
  }

  public static getInstance(): DockMenuTaskManager {
    if (!DockMenuTaskManager.instance) {
      DockMenuTaskManager.instance = new DockMenuTaskManager();
    }
    return DockMenuTaskManager.instance;
  }

  private init(): void {
    localEventManager.registerEventListener(this.localEventListener, [EventConstants.EVENT_SUGGEST_MENU_REMOVED]);
  }

  /**
   * 从数据库初始化数据
   * @param bundleName
   * @returns
   */
  public async initMenuTaskListFromDb(bundleName: string): Promise<CategoryInfo> {
    log.showInfo(`initMenuTaskListFromDb: ${bundleName}`);
    let taskInfoList: DockMenuTaskInfo[] = await DockRdbManager.getInstance().queryDockTaskInfoList(bundleName);

    // 1、列表按创建时间排序
    this.sortTaskInfoList(taskInfoList);

    // 2、获取该应用的所有分组信息
    let categoryDbList = taskInfoList.filter((item) => item.dataType === DockMenuDataType.TYPE_CATEGORY);
    let categoryInfo: CategoryInfo = this.buildCategoryList(categoryDbList);

    // 3、遍历所有的任务，将task添加到各自分组中
    let taskList = taskInfoList.filter((item) => item.dataType === DockMenuDataType.TYPE_TASK);
    this.buildTaskList(categoryInfo, taskList);

    // 将数据保存至map中
    this.taskMap.set(bundleName, categoryInfo);
    categoryInfo.isInitFromDb = true;
    return categoryInfo;
  }

  /**
   * 获取某个图标下的分组信息
   * @param bundleName
   * @returns
   */
  public async getCategoryInfo(bundleName: string): Promise<CategoryInfo> {
    let info = this.taskMap.get(bundleName);
    if (!info) {
      log.showWarn(`do not exist menu task. query from Db`);
      info = await this.initMenuTaskListFromDb(bundleName);
    }
    return info;
  }

  /**
   * 获取某个图标下的分组信息
   * @param bundleName
   * @returns
   */
  public getOrCreateCategoryInfo(bundleName: string): CategoryInfo {
    let info = this.taskMap.get(bundleName);
    if (!info) {
      log.showWarn(`do not exist menu task. create now`);
      info = new CategoryInfo();
      this.taskMap.set(bundleName, info);
    }
    return info;
  }

  private sortTaskInfoList(taskInfoList: DockMenuTaskInfo[]): void {
    taskInfoList.sort((a: DockMenuTaskInfo, b: DockMenuTaskInfo) => {
      return b.createTime - a.createTime;
    });
  }

  private buildCategoryList(categoryList: DockMenuTaskInfo[]): CategoryInfo {
    let categoryInfo = new CategoryInfo();
    categoryList.forEach((item) => {
      categoryInfo.categoryList.push({
        bundleName: item.bundleName,
        categoryId: item.categoryId,
        categoryName: item.categoryName,
        categoryType: item.categoryType,
        createTime: item.createTime,
        taskList: []
      });
      categoryInfo.maxCategoryId = Math.max(categoryInfo.maxCategoryId, item.categoryId);
    });
    return categoryInfo;
  }

  private buildTaskList(categoryInfo: CategoryInfo, taskList: DockMenuTaskInfo[]): void {
    taskList.forEach((task: DockMenuTaskInfo) => {
      let index = categoryInfo.categoryList.findIndex((item) => item.categoryId == task.categoryId);
      if (index < 0) {
        log.showError(`this task is illegal:${task.taskName} categoryId:${task.categoryId} taskId:${task.taskId}`);
        return;
      }
      categoryInfo.maxTaskId = Math.max(categoryInfo.maxTaskId, task.taskId);
      categoryInfo.categoryList[index].taskList.push(task);
    });
  }

  private isCategoryExist(categoryList: DockMenuCategory[], category: DockMenuCategory): boolean {
    if (categoryList.length) {
      return false;
    }
    return categoryList.some((item) => item.categoryName === category.categoryName ||
      item.categoryId === item.categoryId);
  }

  public async deleteAllCategory(bundleName: string): Promise<void> {
    let categoryInfo = await this.getCategoryInfo(bundleName);
    if (!categoryInfo) {
      log.showError('no category info');
      return;
    }
    categoryInfo.categoryList = [];
    categoryInfo.maxCategoryId = 0;
    categoryInfo.maxTaskId = 0;
    DockRdbManager.getInstance().deleteAllDockMenuTask(bundleName);
  }

  /**
   * 新增分组
   * @param category
   * @returns
   */
  public async addCategory(category: DockMenuCategory): Promise<number | DockMenuCategory> {
    let categoryInfo = await this.getCategoryInfo(category.bundleName);
    if (categoryInfo.categoryList?.length >= DockMenuTaskUtils.MAX_CATEGORY_COUNT) {
      return ErrorCode.CATEGORY_LIMIT;
    }
    if (categoryInfo.categoryList.some(item => item.categoryName === category.categoryName)) {
      return ErrorCode.CATEGORY_NAME_DUPLICATE;
    }

    // 添加到列表中，保持有序
    category.createTime = Date.now();
    category.categoryId = ++categoryInfo.maxCategoryId;
    categoryInfo.categoryList.unshift(category);
    categoryInfo.isDirty = true;
    log.showWarn('addCategory:' + JSON.stringify(category) + ' len:' + categoryInfo.categoryList.length);
    DockRdbManager.getInstance().insertDockMenuCategory(category);
    return category;
  }

  /**
   * 删除分组
   * @param bundleName
   * @param categoryId
   * @returns
   */
  public async deleteCategory(bundleName: string, categoryId: number): Promise<number> {
    let categoryInfo = await this.getCategoryInfo(bundleName);
    if (!categoryInfo) {
      log.showError('no category info');
      return ErrorCode.CATEGORY_NOT_FOUND;
    }
    let index: number = categoryInfo.categoryList.findIndex((item) => item.categoryId === categoryId);
    if (index < 0) {
      log.showError('category not exist!!');
      return ErrorCode.CATEGORY_NOT_FOUND;
    }
    let deleteCategory: DockMenuCategory = categoryInfo.categoryList[index];
    log.showInfo('deleteCategory:' + JSON.stringify(deleteCategory));
    categoryInfo.categoryList.splice(index, 1);
    categoryInfo.isDirty = true;
    if (categoryInfo.categoryList.length === 0) {
      categoryInfo.maxCategoryId = 0;
    }
    DockRdbManager.getInstance().deleteDockMenuCategory(deleteCategory);
    return ErrorCode.OK;
  }

  /**
   * 修改分组
   * @param category
   * @returns
   */
  public async updateCategory(category: DockMenuCategory): Promise<number> {
    let categoryInfo = await this.getCategoryInfo(category.bundleName);
    if (!categoryInfo) {
      log.showError('no category info');
      return ErrorCode.CATEGORY_NOT_FOUND;
    }
    let idIndex: number = categoryInfo.categoryList.findIndex(item => item.categoryId === category.categoryId);
    if (idIndex < 0) {
      log.showError('category not exist!!');
      return ErrorCode.CATEGORY_NOT_FOUND;
    }
    let nameIndex: number = categoryInfo.categoryList.findIndex(item => item.categoryName === category.categoryName);
    if (nameIndex >= 0) {
      log.showError('Duplicate category name!!');
      return ErrorCode.CATEGORY_NAME_DUPLICATE;
    }
    categoryInfo.categoryList[idIndex].createTime = Date.now();
    categoryInfo.categoryList[idIndex].categoryName = category.categoryName;
    categoryInfo.categoryList.sort((a, b) => b.createTime - a.createTime);
    categoryInfo.isDirty = true;
    DockRdbManager.getInstance().updateDockMenuCategory(categoryInfo.categoryList[idIndex]);
    log.showWarn('updateCategory:' + JSON.stringify(category) + ' len:' + categoryInfo.categoryList.length);
    return ErrorCode.OK;
  }

  /**
   * 查询分组信息
   * @param bundleName
   * @returns
   */
  public async getCategoryList(bundleName: string): Promise<DockMenuCategory[]> {
    let categoryInfo = await this.getCategoryInfo(bundleName);
    if (!categoryInfo) {
      log.showError('no category info');
      categoryInfo = await this.initMenuTaskListFromDb(bundleName);
    }
    return categoryInfo.categoryList;
  }

  /**
   * 新增一个菜单
   * @param taskInfo
   * @returns
   */
  public async addTask(taskInfo: DockMenuTaskInfo): Promise<number | DockMenuTaskInfo> {
    let categoryInfo = await this.getCategoryInfo(taskInfo.bundleName);
    if (!categoryInfo) {
      log.showError(`the categoryInfo is exist!`);
      return ErrorCode.CATEGORY_NOT_FOUND;
    }

    // 检测分组是否存在
    let index = categoryInfo.categoryList.findIndex(item => item.categoryId === taskInfo.categoryId);
    if (index < 0) {
      log.showError(`the category:${taskInfo.categoryId} is exist!`);
      return ErrorCode.CATEGORY_NOT_FOUND;
    }

    let taskList = categoryInfo.categoryList[index].taskList;
    // 存在任务数超过数量时，删除老缓存
    if (taskList.length >= DockMenuTaskUtils.MAX_TASK_CACHE_COUNT) {
      let deleteTasks = taskList.splice(taskList.length - 1, 1);
      DockRdbManager.getInstance().deleteDockMenuTask(deleteTasks[0]);
    }
    taskInfo.createTime = Date.now();
    taskInfo.taskId = ++categoryInfo.maxTaskId;
    taskList.unshift(taskInfo);
    DockRdbManager.getInstance().insertDockMenuTask(taskInfo);
    return taskInfo;
  }

  /**
   * 删除一个task
   * @param bundleName
   * @param taskId
   * @returns
   */
  public async deleteTask(bundleName: string, taskId: number): Promise<number> {
    let categoryInfo = await this.getCategoryInfo(bundleName);
    if (!categoryInfo) {
      log.showError(`the categoryInfo is exist!`);
      return ErrorCode.CATEGORY_NOT_FOUND;
    }

    let categoryIndex: number = -1;
    let taskIndex: number = -1;
    const cateCount = categoryInfo.categoryList.length;
    for (let i = 0; i < cateCount; i++) {
      taskIndex = categoryInfo.categoryList[i].taskList.findIndex(item => item.taskId === taskId);
      if (taskIndex >= 0) {
        categoryIndex = i;
        break;
      }
    }

    if (taskIndex < 0 || categoryIndex < 0) {
      log.showError(`the task is exist!`);
      return ErrorCode.QUICK_TASK_NOT_FOUND;
    }

    let task: DockMenuTaskInfo[] = categoryInfo.categoryList[categoryIndex].taskList.splice(taskIndex, 1);
    DockRdbManager.getInstance().deleteDockMenuTask(task[0]);
    log.showInfo(`delete task success! ${taskIndex} ${categoryIndex} ${task[0].taskName} ${task[0].abilityName}`);
    return ErrorCode.OK;
  }

  /**
   * 删除一个task
   * @param bundleName
   * @param task
   * @returns
   */
  public async updateTask(task: DockMenuTaskInfo): Promise<number> {
    let categoryInfo = await this.getCategoryInfo(task.bundleName);
    if (!categoryInfo) {
      log.showError(`the categoryInfo is exist!`);
      return ErrorCode.CATEGORY_NOT_FOUND;
    }

    let index = categoryInfo.categoryList.findIndex(item => item.categoryId === task.categoryId);
    if (index < 0) {
      log.showError(`the category:${task.categoryId} is exist!`);
      return ErrorCode.CATEGORY_NOT_FOUND;
    }

    let taskList = categoryInfo.categoryList[index].taskList;
    let taskIndex = taskList.findIndex(item => item.taskId === task.taskId);
    if (taskIndex < 0) {
      log.showError(`the task :${task.taskName} is not found!!`);
      return ErrorCode.QUICK_TASK_NOT_FOUND;
    }

    taskList[taskIndex].createTime = Date.now();
    taskList[taskIndex].taskName = task.taskName;
    taskList[taskIndex].taskIcon = task.taskIcon;
    taskList[taskIndex].taskIconImg = task.taskIconImg;
    taskList[taskIndex].parametersStr = task.parametersStr;
    taskList[taskIndex].taskDetail = task.taskDetail;
    taskList[taskIndex].parameters = task.parameters;
    taskList[taskIndex].moduleName = task.moduleName;
    taskList[taskIndex].abilityName = task.abilityName;
    DockRdbManager.getInstance().updateDockMenuTask(taskList[taskIndex]);
    log.showInfo(`update task success! ${taskIndex} ${index} ${task.taskName} ${task.abilityName}`);
    return ErrorCode.OK;
  }

  /**
   * 更新一个task
   * @param bundleName
   * @param taskId
   * @returns
   */
  public async getTaskList(bundleName: string, categoryId: number): Promise<DockMenuTaskInfo[] | number> {
    let categoryInfo = await this.getCategoryInfo(bundleName);
    if (!categoryInfo) {
      log.showError(`the categoryInfo is exist!`);
      return ErrorCode.CATEGORY_NOT_FOUND;
    }

    let index = categoryInfo.categoryList.findIndex(item => item.categoryId === categoryId);
    if (index < 0) {
      log.showError(`the category:${categoryId} is exist!`);
      return ErrorCode.CATEGORY_NOT_FOUND;
    }

    let taskList = categoryInfo.categoryList[index].taskList;
    if (taskList.length === 0) {
      log.showError(`the taskList is empty!!!`);
      return ErrorCode.QUICK_TASK_NOT_FOUND;
    }
    log.showInfo(`update task success! length:${taskList.length}`);
    return taskList;
  }

  public dump(bundleName: string): string {
    if (bundleName.length) {
      return JSON.stringify(this.taskMap.get(bundleName));
    }
    return '';
  }
}