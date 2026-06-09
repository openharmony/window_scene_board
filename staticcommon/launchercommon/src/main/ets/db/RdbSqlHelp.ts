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

import type GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { CommonConstants } from '../constants/CommonConstants';
import GridLayoutInfoColumns from './column/GridLayoutInfoColumns';
import rdb from '@ohos.data.relationalStore';
import { RdbStoreHelper } from '@ohos/frameworkwrapper/src/main/ets/service/db/RdbStoreHelper';
import { ArrayUtils, LogDomain, LogHelper, } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG: string = 'RdbSqlHelp';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const RESULT_COLUMN_ARRAY: string[] = [
  GridLayoutInfoColumns.ID, // int
  GridLayoutInfoColumns.TYPE_ID, // int
  GridLayoutInfoColumns.INFO_ID, // string
  GridLayoutInfoColumns.BUNDLE_NAME, // string
  GridLayoutInfoColumns.ABILITY_NAME, // string
  GridLayoutInfoColumns.MODULE_NAME, // string
  GridLayoutInfoColumns.APP_INDEX, // int
  GridLayoutInfoColumns.SHORTCUT_ID, // string
  GridLayoutInfoColumns.FILE_INO, // string
];
const QUERY_BATCH_COUNT: number = 1000;

export default class RdbSqlHelp {
  public static getInstance(): RdbSqlHelp {
    if (globalThis.RdbSqlHelp == null) {
      globalThis.RdbSqlHelp = new RdbSqlHelp();
    }
    return globalThis.RdbSqlHelp;
  }

  /**
   * 批量查询数据库并在本地建立数据和_id的映射关系，每次查询数量上限为QUERY_BATCH_COUNT
   *
   * @param rdbStoreHelper 数据库操作类
   * @param tableName 需要查询的表名
   * @param sqlItemData 映射关系存储集合
   * @param startId 批量查询的起始id
   */
  public async getAllDataByBatchSql(rdbStoreHelper: RdbStoreHelper, tableName: string, sqlItemData: SqlItemData,
    startId: number): Promise<void> {
    log.showInfo('getAllDataByBatchSql start, startId: %{public}d', startId);
    const predicates = new rdb.RdbPredicates(tableName);
    if (!DeviceHelper.isPhoneOrPad()) {
      predicates.notEqualTo(GridLayoutInfoColumns.CONTAINER, CommonConstants.CONTAINER_SMARTDOCK).and();
    }
    predicates.greaterThanOrEqualTo(GridLayoutInfoColumns.ID, startId)
      .orderByAsc(GridLayoutInfoColumns.ID)
      .limitAs(QUERY_BATCH_COUNT);
    let queryResult: rdb.ResultSet | undefined = await rdbStoreHelper.query(predicates, RESULT_COLUMN_ARRAY);
    if (queryResult && queryResult.rowCount > 0) {
      while (queryResult.goToNextRow()) {
        let key: string = this.getItemDataKey(queryResult);
        let id: number = queryResult.getLong(queryResult.getColumnIndex(GridLayoutInfoColumns.ID));
        sqlItemData.keyMap.set(key, id);
      }
    }
    if (queryResult?.rowCount === QUERY_BATCH_COUNT) {
      await this.getAllDataByBatchSql(rdbStoreHelper, tableName, sqlItemData, startId + QUERY_BATCH_COUNT);
    }
    queryResult?.close();
  }

  private getItemDataKey(result: rdb.ResultSet) : string {
    let key: string = '';
    let type: number = result.getLong(result.getColumnIndex(GridLayoutInfoColumns.TYPE_ID));
    if (type === CommonConstants.TYPE_APP || type === CommonConstants.TYPE_SHORTCUT_ICON) {
      // 待添加result的安全操作类
      key = type + result.getString(result.getColumnIndex(GridLayoutInfoColumns.BUNDLE_NAME)) +
      result.getString(result.getColumnIndex(GridLayoutInfoColumns.ABILITY_NAME)) +
      result.getString(result.getColumnIndex(GridLayoutInfoColumns.MODULE_NAME)) +
      result.getLong(result.getColumnIndex(GridLayoutInfoColumns.APP_INDEX)) +
      result.getString(result.getColumnIndex(GridLayoutInfoColumns.SHORTCUT_ID));
    } else if (type === CommonConstants.TYPE_FILE_FOLDER) {
      key = type + result.getString(result.getColumnIndex(GridLayoutInfoColumns.FILE_INO));
    } else if (type === CommonConstants.TYPE_FOLDER || type === CommonConstants.TYPE_CARD ||
      type === CommonConstants.TYPE_FORM_STACK) {
      key = type + result.getString(result.getColumnIndex(GridLayoutInfoColumns.INFO_ID));
    }
    return key;
  }

  public getItemKey(item: GridLayoutItemInfo): string {
    let key: string = '';
    if (item.typeId === CommonConstants.TYPE_APP || item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      key = `${item.typeId}${item.bundleName}${item.abilityName ?? ''}${item.moduleName ??
        ''}${item.appIndex ?? 0}${item.shortcutId ?? ''}`;
    } else if (item.typeId === CommonConstants.TYPE_FOLDER) {
      key = `${item.typeId}${item.folderId}`;
    } else if (item.typeId === CommonConstants.TYPE_CARD) {
      key = `${item.typeId}${item.cardId}`;
    } else if (item.typeId === CommonConstants.TYPE_FORM_STACK) {
      key = `${item.typeId}${item.formStackId}`;
    } else if (item.typeId === CommonConstants.TYPE_FILE_FOLDER) {
      key = `${item.typeId}${item.ino}`;
    }
    return key;
  }

  public getUpdateSqlDataSet(sqlItemData: SqlItemData, container: number | undefined): UpdateSqlDataSet {
    const updateSqlDataSet: UpdateSqlDataSet = new UpdateSqlDataSet();
    sqlItemData.updateList.forEach(item => {
      let itemKey: string = this.getItemKey(item);
      let id: number | undefined = sqlItemData.keyMap.get(itemKey);
      if (id === undefined) {
        return;
      }
      updateSqlDataSet.idArray.push(id);
      updateSqlDataSet.getUpdateData(GridLayoutInfoColumns.ROW)?.params.set(id, item.row);
      updateSqlDataSet.getUpdateData(GridLayoutInfoColumns.COLUMN)?.params.set(id, item.column);
      updateSqlDataSet.getUpdateData(GridLayoutInfoColumns.PAGE_INDEX)?.params.set(id, item.page);
      updateSqlDataSet.getUpdateData(GridLayoutInfoColumns.CONTAINER)?.params.set(id,
        container ? container : (item.container ?? CommonConstants.CONTAINER_DESKTOP));
      updateSqlDataSet.getUpdateData(GridLayoutInfoColumns.WIDTH)?.params.set(id, item.area[0]);
      updateSqlDataSet.getUpdateData(GridLayoutInfoColumns.HEIGHT)?.params.set(id, item.area[1]);
      updateSqlDataSet.getUpdateData(GridLayoutInfoColumns.PORTRAIT_ROW)?.params.set(id, item.portraitRow ?? 0);
      updateSqlDataSet.getUpdateData(GridLayoutInfoColumns.PORTRAIT_COLUMN)?.params.set(id, item.portraitColumn ?? 0);
      updateSqlDataSet.getUpdateData(GridLayoutInfoColumns.PORTRAIT_PAGE_INDEX)?.params.set(id, item.portraitPage ?? 0);
      updateSqlDataSet.getUpdateData(GridLayoutInfoColumns.LANDSCAPE_ROW)?.params.set(id, item.landscapeRow ?? 0);
      updateSqlDataSet.getUpdateData(GridLayoutInfoColumns.LANDSCAPE_COLUMN)?.params.set(id, item.landscapeColumn ?? 0);
      updateSqlDataSet.getUpdateData(GridLayoutInfoColumns.LANDSCAPE_PAGE_INDEX)?.params.set(id, item.landscapePage ?? 0);
      if (item.typeId === CommonConstants.TYPE_FILE_FOLDER) {
        updateSqlDataSet.getUpdateData(GridLayoutInfoColumns.URI)?.params.set(id, item.uri ?? '');
        updateSqlDataSet.getUpdateData(GridLayoutInfoColumns.INFO_NAME)?.params.set(id, item.fileFolderName ?? '');
      }
    });
    return updateSqlDataSet;
  }

  public getBatchUpdateSql(updateSqlDataSet: UpdateSqlDataSet, startIndex: number, tableName: string,
    updateCount: number): string {
    log.showInfo('getBatchUpdateSql startIndex = %{public}d', startIndex);
    if (startIndex >= updateSqlDataSet.idArray.length) {
      return '';
    }
    let sqlStr: StringBuilder = new StringBuilder();
    sqlStr.append(`UPDATE ${tableName} SET`);
    let endIndex: number = startIndex + updateCount;
    sqlStr.append(updateSqlDataSet.getUpdateSql(startIndex, endIndex));
    sqlStr.append(` WHERE ${GridLayoutInfoColumns.ID} IN (${updateSqlDataSet.getIds(startIndex, endIndex)})`);
    return sqlStr.toString();
  }
}

export class SqlItemData {
  // key -> key为缓存数据的itemKey, value -> _id
  // ItemKey的组成规则见getItemKey方法
  keyMap: Map<string, number>;
  updateList: GridLayoutItemInfo[];
  insertList: GridLayoutItemInfo[];

  constructor() {
    this.keyMap = new Map();
    this.updateList = [];
    this.insertList = [];
  }
}

/**
 * 用于生成批量更新数据库sql语句的数据集合类，sql语句格式如下：
 * update table
 * set columName1 = case id
 * when 1 then %value
 * when 2 then %value
 * when 3 then %value
 * end,
 * ...
 * columNameX = case id
 * when 1 then %value
 * when 2 then %value
 * when 3 then %value
 * end,
 * where id in (1, 2, 3)
 * 每一个列名的when语句集合生成通过UpdateSqlData来控制
 * dataMap中key为columName，value为when语句的数据集合UpdateSqlData，则用于生成主体语句
 */
export class UpdateSqlDataSet {
  idArray: number[];
  private dataMap: Map<string, UpdateSqlData> = new Map();

  constructor() {
    this.idArray = [];
    let updateRowData: UpdateSqlData = new UpdateSqlData(GridLayoutInfoColumns.ROW);
    this.dataMap.set(GridLayoutInfoColumns.ROW, updateRowData);

    let updateColumnData: UpdateSqlData = new UpdateSqlData(GridLayoutInfoColumns.COLUMN);
    this.dataMap.set(GridLayoutInfoColumns.COLUMN, updateColumnData);

    let updatePageData: UpdateSqlData = new UpdateSqlData(GridLayoutInfoColumns.PAGE_INDEX);
    this.dataMap.set(GridLayoutInfoColumns.PAGE_INDEX, updatePageData);

    let updateContainerData: UpdateSqlData = new UpdateSqlData(GridLayoutInfoColumns.CONTAINER);
    this.dataMap.set(GridLayoutInfoColumns.CONTAINER, updateContainerData);

    let updateWidthData: UpdateSqlData = new UpdateSqlData(GridLayoutInfoColumns.WIDTH);
    this.dataMap.set(GridLayoutInfoColumns.WIDTH, updateWidthData);

    let updateHeightData: UpdateSqlData = new UpdateSqlData(GridLayoutInfoColumns.HEIGHT);
    this.dataMap.set(GridLayoutInfoColumns.HEIGHT, updateHeightData);

    let updateUriData: UpdateSqlData = new UpdateSqlData(GridLayoutInfoColumns.URI);
    this.dataMap.set(GridLayoutInfoColumns.URI, updateUriData);

    let updateInfoNameData: UpdateSqlData = new UpdateSqlData(GridLayoutInfoColumns.INFO_NAME);
    this.dataMap.set(GridLayoutInfoColumns.INFO_NAME, updateInfoNameData);

    let updatePortraitRowData: UpdateSqlData = new UpdateSqlData(GridLayoutInfoColumns.PORTRAIT_ROW);
    this.dataMap.set(GridLayoutInfoColumns.PORTRAIT_ROW, updatePortraitRowData);

    let updatePortraitColumnData: UpdateSqlData = new UpdateSqlData(GridLayoutInfoColumns.PORTRAIT_COLUMN);
    this.dataMap.set(GridLayoutInfoColumns.PORTRAIT_COLUMN, updatePortraitColumnData);

    let updatePortraitPageData: UpdateSqlData = new UpdateSqlData(GridLayoutInfoColumns.PORTRAIT_PAGE_INDEX);
    this.dataMap.set(GridLayoutInfoColumns.PORTRAIT_PAGE_INDEX, updatePortraitPageData);

    let updateLandscapeRowData: UpdateSqlData = new UpdateSqlData(GridLayoutInfoColumns.LANDSCAPE_ROW);
    this.dataMap.set(GridLayoutInfoColumns.LANDSCAPE_ROW, updateLandscapeRowData);

    let updateLandscapeColumnData: UpdateSqlData = new UpdateSqlData(GridLayoutInfoColumns.LANDSCAPE_COLUMN);
    this.dataMap.set(GridLayoutInfoColumns.LANDSCAPE_COLUMN, updateLandscapeColumnData);

    let updateLandscapePageData: UpdateSqlData = new UpdateSqlData(GridLayoutInfoColumns.LANDSCAPE_PAGE_INDEX);
    this.dataMap.set(GridLayoutInfoColumns.LANDSCAPE_PAGE_INDEX, updateLandscapePageData);
  }

  public getUpdateData(columnName: string) : UpdateSqlData | undefined {
    return this.dataMap.get(columnName);
  }

  public getIds(startIndex: number, endIndex: number): string {
    if (ArrayUtils.isEmpty(this.idArray)) {
      return '';
    }
    let idsStr: StringBuilder = new StringBuilder();
    this.idArray.slice(startIndex, endIndex).forEach((id) => {
      idsStr.append(`${id},`);
    });
    let ids: string = idsStr.toString();
    return ids.substring(0, ids.length - 1);
  }

  public getUpdateSql(startIndex: number, endIndex: number): string {
    let sqlStr: StringBuilder = new StringBuilder();
    this.dataMap.forEach((data) => {
      if (data.params.size === 0) {
        return;
      }
      sqlStr.append(` ${data.columnName} = CASE ${GridLayoutInfoColumns.ID}`);
      this.idArray.slice(startIndex, endIndex).forEach((id) => {
        sqlStr.append(data.getSqlStr(id));
      });
      sqlStr.append(` ELSE ${data.columnName} END,`);
    });
    let sql: string = sqlStr.toString();
    return sql.substring(0, sql.length - 1);
  }
}

export class UpdateSqlData {
  columnName: string;
  params: Map<number, string | number>;

  constructor(columnName: string) {
    this.columnName = columnName;
    this.params = new Map();
  }

  public getSqlStr(id: number): string {
    if (this.params.has(id)) {
      const value = this.params.get(id) ?? '';
      if (value !== '' && typeof value === 'string') {
        return ` WHEN ${id} THEN '${value}'`;
      } else {
        return ` WHEN ${id} THEN ${value}`;
      }
    }
    return '';
  }
}

class StringBuilder {
  private strings: string[];

  public constructor() {
    this.strings = [];
  }

  public append(str: string): StringBuilder {
    this.strings.push(str);
    return this;
  }

  public toString(): string {
    return this.strings.join('');
  }
}