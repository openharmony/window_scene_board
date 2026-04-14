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

import { BaseIconInfo } from './BaseIconInfo';
import { AppItemInfo } from './AppItemInfo';
import type rdb from '@ohos.data.relationalStore';
import GridLayoutInfoColumns, {GridLayoutInfoEnums} from '../db/column/GridLayoutInfoColumns';
import { LogDomain, LogHelper } from '@ohos/basicutils';

/**
 * 应用中心元素基础信息
 */
const TAG = 'AppGridItemInfo';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class AppGridItemInfo implements BaseIconInfo {
  public id: number | undefined;
  public bundleName: string = '';
  public abilityName: string = '';
  public moduleName?: string | undefined;
  public shortcutId?: string | undefined;
  public appIndex?: number | undefined;

  public page?: number | undefined;
  public column?: number | undefined;
  public row?: number | undefined;

  public downloadProgress: number | undefined = 0;
  public appStatus: number | undefined = 0;
  public callerName: string | undefined;

  private static toValuesBucketBase(itemInfo: AppGridItemInfo): rdb.ValuesBucket {
    let bucket: rdb.ValuesBucket = {
      [GridLayoutInfoEnums.BUNDLE_NAME]: itemInfo.bundleName,
      [GridLayoutInfoEnums.ABILITY_NAME]: itemInfo.abilityName,
      [GridLayoutInfoEnums.MODULE_NAME]: itemInfo.moduleName,
      [GridLayoutInfoEnums.APP_INDEX]: itemInfo.appIndex,
      [GridLayoutInfoEnums.PAGE_INDEX]: itemInfo.page,
      [GridLayoutInfoEnums.COLUMN]: itemInfo.column,
      [GridLayoutInfoEnums.ROW]: itemInfo.row,
      [GridLayoutInfoEnums.DOWNLOAD_PROGRESS]: itemInfo.downloadProgress,
      [GridLayoutInfoEnums.APP_STATUS]: itemInfo.appStatus,
      [GridLayoutInfoEnums.CALLER_NAME]: itemInfo.callerName,
    };
    return bucket;
  }

  /**
   * 生成数据库存取ValuesBucket
   * @returns
   */
  public static toValuesBucket(itemInfo: AppGridItemInfo): rdb.ValuesBucket {
    log.showInfo('toValuesBucket');
    if (!itemInfo) {
      return {};
    }
    let bucket: rdb.ValuesBucket = AppGridItemInfo.toValuesBucketBase(itemInfo);
    bucket[GridLayoutInfoColumns.SCREEN_ID] = 0;
    return bucket;
  }

  /**
   * 生成应用中心数据库存取ValuesBucket
   * @returns
   */
  public static toValuesBucketForAppCenter(itemInfo: AppGridItemInfo): rdb.ValuesBucket {
    log.showInfo('toValuesBucket');
    if (!itemInfo) {
      return {};
    }
    return AppGridItemInfo.toValuesBucketBase(itemInfo);
  }

  /**
   *  AppItemInfo转AppGridItemInfo
   * @param itemInfo
   * @returns
   */
  public fromAppItemInfo(itemInfo: AppItemInfo): AppGridItemInfo {
    if (itemInfo) {
      this.bundleName = itemInfo.bundleName;
      this.abilityName = itemInfo.abilityName;
      this.moduleName = itemInfo.moduleName;
      this.shortcutId = itemInfo.shortcutId;
      this.appIndex = itemInfo.appIndex;
      this.page = itemInfo.page;
      this.column = itemInfo.column;
      this.row = itemInfo.row;

      this.downloadProgress = itemInfo.downloadProgress;
      this.appStatus = itemInfo.appStatus;
      this.callerName = itemInfo.callerName;
    }
    return this;
  }

  /**
   * AppItemInfo转AppGridItemInfo
   * @param itemInfo
   * @returns
   */
  public static newInstanceFromAppItemInfo(itemInfo: AppItemInfo): AppGridItemInfo {
    let item: AppGridItemInfo = new AppGridItemInfo();
    return item.fromAppItemInfo(itemInfo);
  }

  /**
   * 查询结果转AppGridItemInfo
   * @param resultSet
   * @returns
   */
  public static fromResultSet(resultSet: rdb.ResultSet): AppGridItemInfo | undefined {
    log.showInfo(`fromResultSet: data2: ${JSON.stringify(resultSet === undefined)}`);
    if (resultSet) {
      let item: AppGridItemInfo = new AppGridItemInfo();
      item.id = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.ID));
      item.bundleName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.BUNDLE_NAME));
      item.abilityName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.ABILITY_NAME));
      item.moduleName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.MODULE_NAME));
      item.page = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.PAGE_INDEX));
      item.column = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.COLUMN));
      item.row = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.ROW));
      item.appIndex = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APP_INDEX));
      item.downloadProgress = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.DOWNLOAD_PROGRESS));
      item.appStatus = resultSet.getLong(resultSet.getColumnIndex(GridLayoutInfoColumns.APP_STATUS));
      item.callerName = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.CALLER_NAME));
      return item;
    }
    return undefined;
  }
}