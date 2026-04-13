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

import image from '@ohos.multimedia.image';
import { CheckEmptyUtils, LogDomain, Logger } from '@ohos/basicutils';
import { DockMenuTaskManager } from '../manager/DockMenuTaskManager';
import { rpc } from '@kit.IPCKit';
import { DockMenuTaskInfo } from '../bean/DockMenuTaskInfo';
import { DockMenuTaskUtils, ErrorCode } from '../utils/DockMenuTaskUtils';
import {
  DockMenuCategory,
  ParameterItem,
  QuickTask,
  QuickTaskInfo
} from '../model/DockMenuCategory';

export enum QuickBarConnectEvent {
  UNKNOWN = -1,
  GET_CUSTOM_CATEGORIES = 1,
  ADD_CUSTOM_CATEGORY = 2,
  UPDATE_CUSTOM_CATEGORY = 3,
  DELETE_CUSTOM_CATEGORY = 4,
  GET_TASKS_FROM_CATEGORY = 5,
  ADD_QUICK_TASK = 6,
  UPDATE_QUICK_TASK = 7,
  DELETE_QUICK_TASK = 8
}

const TAG = 'QuickBarServiceManager';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

export class QuickBarServiceManager {
  private static instance: QuickBarServiceManager | undefined = undefined;
  private taskManager: DockMenuTaskManager = DockMenuTaskManager.getInstance();

  public static getInstance(): QuickBarServiceManager {
    if (!QuickBarServiceManager.instance) {
      QuickBarServiceManager.instance = new QuickBarServiceManager();
    }
    return QuickBarServiceManager.instance;
  }

  private constructor() {
  }

  private getOptions(data: rpc.MessageSequence): QuickTaskInfo {
    let taskInfo: QuickTaskInfo = new QuickTaskInfo(data.readString(), data.readString(),
      data.readBoolean() ? data.readString() : undefined,
      data.readBoolean() ? image.createPixelMapFromParcel(data) : undefined,
      data.readBoolean() ? data.readString() : undefined,
      data.readBoolean() ? JSON.parse(data.readString()) as ParameterItem[] : undefined);
    return taskInfo;
  }

  public async getCustomCategories(bundleName: string, reply: rpc.MessageSequence): Promise<number> {
    let categoryList = await this.taskManager.getCategoryList(bundleName);
    if (!CheckEmptyUtils.isEmptyArr(categoryList)) {
      reply.writeBoolean(false);
      reply.writeInt(categoryList?.length);
      log.showWarn(TAG, 'getCustomCategories_length_'+categoryList.length);
      reply.writeParcelableArray(DockMenuTaskUtils.getParcelCategoryList(categoryList));
      return ErrorCode.OK;
    } else {
      return ErrorCode.CATEGORY_NOT_FOUND;
    }
  }

  public async addCustomCategory(bundleName: string,
    data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<number> {
    let category = new DockMenuCategory();
    category.bundleName = bundleName;
    category.categoryName = data.readString();

    let res = await this.taskManager.addCategory(category);
    if (typeof res === 'number') {
      return res;
    }

    let out = DockMenuTaskUtils.getParcelCategory(res);
    log.showWarn(TAG, 'DockMenuCategory:' + JSON.stringify(res));
    reply.writeBoolean(false);
    reply.writeParcelable(out);
    return ErrorCode.OK;
  }

  public async updateCustomCategory(bundleName: string,
    data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<number> {
    let category = new DockMenuCategory();
    category.bundleName = bundleName;
    category.categoryId = data.readInt();
    category.categoryName = data.readString();
    return await this.taskManager.updateCategory(category);
  }

  public async deleteCustomCategory(bundleName: string,
    data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<number> {
    let categoryId = data.readInt();
    return await this.taskManager.deleteCategory(bundleName, categoryId);
  }

  public async getTasksFromCategory(bundleName: string,
    data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<number> {
    let categoryId = data.readInt();
    let res = await this.taskManager.getTaskList(bundleName, categoryId);
    if (typeof res === 'number' ) {
      return res;
    }
    let taskList = DockMenuTaskUtils.getParcelTaskList(res);
    reply.writeBoolean(false);
    reply.writeInt(taskList.length);
    reply.writeParcelableArray(taskList);
    return ErrorCode.OK;
  }

  public async addQuickTask(bundleName: string, data: rpc.MessageSequence,
    reply: rpc.MessageSequence): Promise<number> {
    let input = new QuickTask(0, data.readInt(), this.getOptions(data));
    let task: DockMenuTaskInfo = await DockMenuTaskUtils.getMenuTask(bundleName, input);
    let res = await this.taskManager.addTask(task);
    if (typeof res === 'number') {
      return res;
    }
    reply.writeBoolean(false);
    reply.writeParcelable(DockMenuTaskUtils.getParcelTask(res));
    log.showWarn(TAG, 'addQuickTaskFirst_'+JSON.stringify(res));
    return ErrorCode.OK;
  }

  public async updateQuickTask(bundleName: string,
    data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<number> {
    let quickTask = new QuickTask(data.readInt(), data.readInt(), this.getOptions(data));
    log.showWarn(TAG, 'updateQuickTask_'+JSON.stringify(quickTask));
    let menuTask: DockMenuTaskInfo = await DockMenuTaskUtils.getMenuTask(bundleName, quickTask);
    let res = await this.taskManager.updateTask(menuTask);
    log.showWarn(TAG, `updateQuickTask res:${res}`);
    return res;
  }

  public async deleteQuickTask(bundleName: string,
    data: rpc.MessageSequence, reply: rpc.MessageSequence): Promise<number> {
    const deleteTaskId = data.readInt();
    return await this.taskManager.deleteTask(bundleName, deleteTaskId);
  }
}