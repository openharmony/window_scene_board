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

import type rdb from '@ohos.data.relationalStore';
import { DockMenuTaskInfo } from '../bean/DockMenuTaskInfo';
import DockMenuTaskInfoColumns from './DockMenuTaskInfoColumns';

export class DockMenuTaskDbBuilder {
  public static buildDockMenuTaskInfo(resultSet: rdb.ResultSet): DockMenuTaskInfo {
    let taskInfo: DockMenuTaskInfo = new DockMenuTaskInfo();
    taskInfo.id = resultSet.getLong(resultSet.getColumnIndex(DockMenuTaskInfoColumns.ID));
    taskInfo.dataType = resultSet.getLong(resultSet.getColumnIndex(DockMenuTaskInfoColumns.DATA_TYPE));
    taskInfo.taskId = resultSet.getLong(resultSet.getColumnIndex(DockMenuTaskInfoColumns.TASK_ID));
    taskInfo.taskName = resultSet.getString(resultSet.getColumnIndex(DockMenuTaskInfoColumns.TASK_NAME));
    taskInfo.taskIcon = resultSet.getString(resultSet.getColumnIndex(DockMenuTaskInfoColumns.TASK_ICON));
    taskInfo.taskDetail = resultSet.getString(resultSet.getColumnIndex(DockMenuTaskInfoColumns.TASK_DETAIL));
    taskInfo.parametersStr = resultSet.getString(resultSet.getColumnIndex(DockMenuTaskInfoColumns.TASK_PARAMETERS));
    taskInfo.taskState = resultSet.getLong(resultSet.getColumnIndex(DockMenuTaskInfoColumns.TASK_STATE));
    taskInfo.bundleName = resultSet.getString(resultSet.getColumnIndex(DockMenuTaskInfoColumns.BUNDLE_NAME));
    taskInfo.moduleName = resultSet.getString(resultSet.getColumnIndex(DockMenuTaskInfoColumns.MODULE_NAME));
    taskInfo.abilityName = resultSet.getString(resultSet.getColumnIndex(DockMenuTaskInfoColumns.ABILITY_NAME));
    taskInfo.categoryId = resultSet.getLong(resultSet.getColumnIndex(DockMenuTaskInfoColumns.CATEGORY_ID));
    taskInfo.categoryName = resultSet.getString(resultSet.getColumnIndex(DockMenuTaskInfoColumns.CATEGORY_NAME));
    taskInfo.categoryType = resultSet.getLong(resultSet.getColumnIndex(DockMenuTaskInfoColumns.CATEGORY_TYPE));
    taskInfo.createTime = resultSet.getLong(resultSet.getColumnIndex(DockMenuTaskInfoColumns.CREATE_TIME));
    return taskInfo;
  }
}