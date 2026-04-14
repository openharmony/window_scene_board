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
import {
  CustomCategory,
  DockMenuCategory,
  ParameterItem,
  QuickTask,
  QuickTaskInfo
} from '../model/DockMenuCategory';
import { GraphicUtils } from '@ohos/frameworkwrapper';
import { DockMenuDataType, DockMenuTaskInfo } from '../bean/DockMenuTaskInfo';
import image from '@ohos.multimedia.image';
import { LogDomain, Logger } from '@ohos/basicutils';

const log = Logger.getLogHelper(LogDomain.HOME);
const TAG = 'DockMenuTaskUtils';

export enum ErrorCode {
  OK = 0,
  CATEGORY_LIMIT = 1020210001,
  CATEGORY_NAME_DUPLICATE = 1020210002,
  CATEGORY_NOT_FOUND = 1020210003,
  QUICK_TASK_NOT_FOUND = 1020210004
}

const MAX_ICON_SIZE: number = 80;

export class DockMenuTaskUtils {
  public static readonly MAX_TASK_CACHE_COUNT: number = 20;
  public static readonly MAX_CATEGORY_COUNT = 3;

  public static getParcelCategory(category: DockMenuCategory): CustomCategory {
    return new CustomCategory(category.categoryId, category.categoryName);
  }

  public static getParcelCategoryList(categoryList: DockMenuCategory[]): CustomCategory[] {
    let out: CustomCategory[] = [];
    categoryList.forEach((item) => out.push(DockMenuTaskUtils.getParcelCategory(item)));
    return out;
  }

  private static async adjustIcon(icon: image.PixelMap): Promise<image.PixelMap> {
    const imageInfo = icon.getImageInfoSync();
    const iconWidth: number = imageInfo.size.width;
    const iconHeight: number = imageInfo.size.height;
    const maxValue: number = Math.max(iconWidth, iconHeight);
    if (maxValue <= MAX_ICON_SIZE) {
      return icon;
    }
    const scaleValue = MAX_ICON_SIZE / maxValue;
    log.showInfo(TAG, `adjustIcon scalueValue:${scaleValue} from:{${iconWidth}, ${iconHeight}}`);
    await icon.scale(scaleValue, scaleValue);
    return icon;
  }

  public static async getMenuTask(bundleName: string, task: QuickTask): Promise<DockMenuTaskInfo> {
    return {
      bundleName: bundleName,
      id: 0,
      taskId: task.taskId,
      taskState: 0,
      taskName: task.taskInfo.taskName,
      taskDetail: task.taskInfo.taskDetail,
      parametersStr: task.taskInfo.parameters ? JSON.stringify(task.taskInfo.parameters) : undefined,
      parameters: task.taskInfo.parameters ? task.taskInfo.parameters : undefined,
      taskIcon: undefined,
      taskIconImg: task.taskInfo.taskIcon,
      dataType: DockMenuDataType.TYPE_TASK,
      abilityName: task.taskInfo.abilityName,
      moduleName: task.taskInfo.moduleName,
      categoryId: task.categoryId,
      categoryName: '',
      categoryType: 0,
      createTime: 0,
    };
  }

  public static async updateTaskIconBaseStr(task: DockMenuTaskInfo): Promise<void> {
    if (task.taskIconImg) {
      task.taskIconImg = await DockMenuTaskUtils.adjustIcon(task.taskIconImg);
      task.taskIcon = await GraphicUtils.changePixelToBase64Child(task.taskIconImg);
    }
  }

  public static getParcelTask(task: DockMenuTaskInfo): QuickTask {
    let taskInfo: QuickTaskInfo = new QuickTaskInfo(task.taskName, task.abilityName, task.moduleName,
      task.taskIconImg, task.taskDetail, task.parameters ? task.parameters : undefined);
    return new QuickTask(task.taskId, task.categoryId, taskInfo);
  }

  public static getParcelTaskList(taskList: DockMenuTaskInfo[]): QuickTask[] {
    let out: QuickTask[] = [];
    taskList.forEach((task) => out.push(DockMenuTaskUtils.getParcelTask(task)));
    return out;
  }
}