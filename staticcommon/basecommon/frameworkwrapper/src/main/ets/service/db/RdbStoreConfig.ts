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
import { IconDatabaseColumn } from '../../resourcemanager/IconInfo';
import { BadgeColumns } from './column/BadgeColumns';

interface RdbInfo {
  tableName: string;
  createTable: string;
  dropTable: string;
}

interface TableNameInfo {
  tableName: string;
}

interface CreateTableInfo {
  tableName: string;
  createTable: string;
}

interface DropTableInfo {
  tableName: string;
  dropTable: string;
}

interface ErrorCode {
  DATABASE_CORRUPTED: 14800011,
  DATABASE_BUSY_BY_OTHER_PROCESSES: 14800024,
  DATABASE_BUSY_BY_OTHER_THREADS: 14800025,
  MEMORY_APPLY_FAILED: 14800026,
  IO_ACCESS_FAILED: 14800028,
  DISK_FULL: 14800029,
  DATABASE_NO_RESPONSE: 14800015,
  WAL_FILE_LIMIT: 14800047
}

interface RdbStoreConfig {
  dbName: string;
  badge: RdbInfo;
  formSwiper: TableNameInfo;
  voiceCard: CreateTableInfo;
  gridLayoutInfo: TableNameInfo;
  pc_mode_gridLayoutInfo: TableNameInfo;
  cardInfo: TableNameInfo;
  appCenterLayoutInfo: TableNameInfo;
  outerGridLayoutInfo: TableNameInfo;
  simpleLayoutInfo: TableNameInfo;
  outdoorLayoutInfo: TableNameInfo;
  drawerModeAppInfo: TableNameInfo;
  lightOutdoorLayoutInfo: TableNameInfo;
  appCategoryInfo: RdbInfo;
  recentDockInfo: TableNameInfo;
  recentLockInfo: TableNameInfo;
  recentDockLayoutInfo: TableNameInfo;
  sessionPersistInfo: CreateTableInfo;
  intelligentDiscoveryInfo: RdbInfo;
  intelligentImage: RdbInfo;
  intelligentCard: RdbInfo;
  intelligentCommonData: DropTableInfo;
  iconInfo: RdbInfo;
  pageIndexTypeInfo: RdbInfo;
  simplePageIndexTypeInfo: RdbInfo;
  outerPageIndexTypeInfo: RdbInfo;
  outerAppCategorize: RdbInfo;
  errorCode: ErrorCode
}

const rdbStoreConfig: RdbStoreConfig = {
  dbName: 'Launcher.db',
  badge: {
    tableName: 'badge_info',
    createTable: 'CREATE TABLE IF NOT EXISTS badge_info (' +
    BadgeColumns.ID + ' INTEGER PRIMARY KEY AUTOINCREMENT, ' +
    BadgeColumns.BUNDLE_NAME + ' TEXT UNIQUE, ' +
    BadgeColumns.BADGE_NUMBER + ' INTEGER, ' +
    BadgeColumns.IS_SHOW + ' INTEGER, ' +
    BadgeColumns.USER_ID + ' INTEGER)',
    dropTable: 'DROP TABLE IF EXISTS badge_info'
  },

  formSwiper: {
    tableName: 'form_swiper'
  },

  voiceCard: {
    tableName: 'voice_card',
    createTable: 'CREATE TABLE IF NOT EXISTS voice_card ' +
      '(id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
      'voice_info TEXT)'
  },

  gridLayoutInfo: {
    tableName: 'gridlayout_info'
  },

  pc_mode_gridLayoutInfo: {
    tableName: 'pc_mode_gridlayout_info'
  },

  cardInfo: {
    tableName: 'card_info'
  },

  appCenterLayoutInfo: {
    tableName: 'app_center_layout_info'
  },

  outerGridLayoutInfo: {
    tableName: 'outer_gridlayout_info'
  },

  simpleLayoutInfo: {
    tableName: 'simple_gridlayout_info'
  },

  outdoorLayoutInfo: {
    tableName: 'outdoor_gridlayout_info',
  },

  lightOutdoorLayoutInfo: {
    tableName: 'outdoor_gridlayout_info',
  },

  drawerModeAppInfo: {
    tableName: 'drawer_mode_app_info',
  },

  appCategoryInfo: {
    tableName: 'app_category_info',
    dropTable: 'DROP TABLE IF EXISTS app_category_info',
    createTable: 'CREATE TABLE IF NOT EXISTS app_category_info ' +
      '(_id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
      'bundle_name TEXT UNIQUE, ' +
      'secondary_category_id INTEGER) '
  },

  recentDockInfo: {
    tableName: 'recent_dock_info'
  },

  recentLockInfo: {
    tableName: 'recent_lock_info'
  },

  recentDockLayoutInfo: {
    tableName: 'recent_dock_layout_Info'
  },

  sessionPersistInfo: {
    tableName: 'session_persist',
    createTable: 'CREATE TABLE IF NOT EXISTS session_persist ' +
      '(id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
      'data TEXT)'
  },

  intelligentDiscoveryInfo: {
    tableName: 'intelligent_discovery',
    dropTable: 'DROP TABLE IF EXISTS intelligent_discovery',
    createTable: 'CREATE TABLE IF NOT EXISTS intelligent_discovery ' +
      '(id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
      'parent_id TEXT, ' +
      'service_id TEXT, ' +
      'service_name TEXT, ' +
      'icon_url TEXT, ' +
      'ability_jump_url TEXT, ' +
      'candidate_jump_url TEXT, ' +
      'priority TEXT, ' +
      'subtitle_name TEXT, ' +
      'subtitle_start_time TEXT, ' +
      'subtitle_end_time TEXT, ' +
      'show_toast TEXT, ' +
      'toast_info TEXT) '
  },

  intelligentImage: {
    tableName: 'intelligent_image',
    dropTable: 'DROP TABLE IF EXISTS intelligent_image',
    createTable: 'CREATE TABLE IF NOT EXISTS intelligent_image ' +
      '(id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
      'module_name TEXT, ' +
      'image_url TEXT UNIQUE, ' +
      'image_base64 TEXT, ' +
      'extra_data TEXT)'
  },

  intelligentCard: {
    tableName: 'intelligent_card_list',
    dropTable: 'DROP TABLE IF EXISTS intelligent_card_list',
    createTable: 'CREATE TABLE IF NOT EXISTS intelligent_card_list' +
      '(name TEXT, ' +
      'intelligent_info TEXT) '
  },

  intelligentCommonData: {
    tableName: 'intelligent_common_data',
    dropTable: 'DELETE FROM intelligent_common_data',
  },

  iconInfo: {
    tableName: 'icon_info',
    createTable: 'CREATE TABLE IF NOT EXISTS icon_info (' +
    IconDatabaseColumn.BUNDLE_NAME + ' TEXT, ' +
    IconDatabaseColumn.MODULE_NAME + ' TEXT, ' +
    IconDatabaseColumn.ABILITY_NAME + ' TEXT, ' +
    IconDatabaseColumn.ICON_TYPE + ' INTEGER, ' +
      'fore_pic' + ' TEXT, ' +
      'back_pic' + ' TEXT, ' +
      'combine_pic' + ' TEXT, ' +
    IconDatabaseColumn.SYSTEM_STATE + ' TEXT, ' +
    IconDatabaseColumn.APP_VERSION + ' TEXT,' +
      'primary key (bundle_name, module_name, ability_name))',
    dropTable: 'DELETE FROM icon_info'
  },

  pageIndexTypeInfo: {
    tableName: 'page_index_type_info',
    dropTable: 'DROP TABLE IF EXISTS page_index_type_info',
    createTable: 'CREATE TABLE IF NOT EXISTS page_index_type_info' +
      '(page_index number, ' +
      'type TEXT) '
  },

  simplePageIndexTypeInfo: {
    tableName: 'simple_page_index_type_info',
    dropTable: 'DROP TABLE IF EXISTS simple_page_index_type_info',
    createTable: 'CREATE TABLE IF NOT EXISTS simple_page_index_type_info' +
      '(page_index number, ' +
      'type TEXT) '
  },

  outerPageIndexTypeInfo: {
    tableName: 'outer_page_index_type_info',
    dropTable: 'DROP TABLE IF EXISTS outer_page_index_type_info',
    createTable: 'CREATE TABLE IF NOT EXISTS outer_page_index_type_info' +
      '(page_index number, ' +
      'type TEXT) '
  },

  outerAppCategorize: {
    tableName: 'outer_app_categorize',
    dropTable: 'DROP TABLE IF EXISTS outer_app_categorize',
    createTable: 'CREATE TABLE IF NOT EXISTS outer_app_categorize ' +
      '(id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
      'bundle_name TEXT, category TEXT)'
  },

  errorCode: {
    DATABASE_CORRUPTED: 14800011,
    DATABASE_BUSY_BY_OTHER_PROCESSES: 14800024,
    DATABASE_BUSY_BY_OTHER_THREADS: 14800025,
    MEMORY_APPLY_FAILED: 14800026,
    IO_ACCESS_FAILED: 14800028,
    DISK_FULL: 14800029,
    DATABASE_NO_RESPONSE: 14800015,
    WAL_FILE_LIMIT: 14800047
  },
};

export default rdbStoreConfig;
