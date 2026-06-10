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

interface CreateTableInfo {
  tableName: string;
  createTable: string;
}

export class DockRdbStoreConfig {
  public static dockMenuTaskInfo: CreateTableInfo = {
    tableName: 'dock_menu_task',
    createTable: 'CREATE TABLE IF NOT EXISTS dock_menu_task ' +
      '(_id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
      'data_type INTEGER, ' +
      'task_id INTEGER, ' +
      'task_name TEXT, ' +
      'task_icon TEXT, ' +
      'task_detail TEXT, ' +
      'task_parameters TEXT, ' +
      'task_state INTEGER, ' +
      'bundle_name TEXT, ' +
      'module_name TEXT, ' +
      'ability_name TEXT, ' +
      'category_id INTEGER, ' +
      'category_name TEXT, ' +
      'category_type INTEGER, ' +
      'create_time INTEGER)'
  };
}
