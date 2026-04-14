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

/**
 * GridLayoutInfo  Columns
 */
export default class DockMenuTaskInfoColumns {
  public static readonly ID: string = '_id';
  public static readonly DATA_TYPE: string = 'data_type'; // 如果是0，则是category，如果是1，则是task
  public static readonly TASK_ID: string = 'task_id';
  public static readonly TASK_NAME: string = 'task_name';
  public static readonly TASK_ICON: string = 'task_icon';
  public static readonly TASK_DETAIL: string = 'task_detail';
  public static readonly TASK_PARAMETERS: string = 'task_parameters';
  public static readonly TASK_STATE: string = 'task_state'; // 任务状态，是否pinion状态，保留字段
  public static readonly BUNDLE_NAME: string = 'bundle_name';
  public static readonly MODULE_NAME: string = 'module_name';
  public static readonly ABILITY_NAME: string = 'ability_name';
  public static readonly CATEGORY_ID: string = 'category_id';
  public static readonly CATEGORY_NAME: string = 'category_name';
  public static readonly CATEGORY_TYPE: string = 'category_type';
  public static readonly CREATE_TIME: string = 'create_time';
}