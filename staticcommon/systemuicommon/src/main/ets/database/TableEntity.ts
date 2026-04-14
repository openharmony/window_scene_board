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

import rdb from '@ohos.data.relationalStore';
import { Class, ExcludeFunction } from '@ohos/frameworkwrapper/src/main/ets/base/CommonType';
import { CustomPromise } from '@ohos/frameworkwrapper/src/main/ets/base/CustomPromise';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { RdbStore } from './RdbStore';
import { TABLE_OPTIONS_MAP } from './TableDecorator';
import {
  ITableColumn,
  ITableEntity,
  ITableOptions,
  ITableProps,
  ITableQueryOptions,
  ITableQuerySqlOptions,
} from './TableModel';
import { TablePredicates } from './TablePredicates';
import lazy { LogWithHa } from '../maintenance/CommonExceptionMaintenance';
import { CommonExceptionCode } from '../maintenance/CommonExceptionCode';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'TableEntity');

/**
 * 数据库表的基类，所有业务表都应该继承自该类
 */
export class TableEntity implements ITableEntity {
  protected static storePromise: CustomPromise<RdbStore> = new CustomPromise();

  private static idColumn: ITableColumn = {
    name: 'id',
    entityFieldType: 'number',
    dbFieldType: 'INTEGER',
    entityFieldName: 'id'
  };

  private static columnMap: Record<string, ITableColumn> | null;

  /**
   * 查询时指定的列
   */
  private _columns?: string[];

  /**
   * 主键ID列
   */
  public id?: number;

  /**
   * 初始化表
   * @param store 数据库实例
   */
  public static init(store: RdbStore): void {
    this.storePromise.resolve(store);
  }

  /**
   * 获取表名
   * @returns
   */
  public static getTableOptions(): ITableOptions | undefined {
    return TABLE_OPTIONS_MAP.get(this)?.table;
  }

  /**
   * 获取表的所有列配置，id列在第一列
   * @returns
   */
  public static getTableColumns(): ITableColumn[] {
    return [this.idColumn, ...TABLE_OPTIONS_MAP.get(this)?.columns];
  }

  /**
   * 根据字段名获取表的某个列配置
   */
  public static getTableColumn<T extends TableEntity>(
    this: Class<T> & typeof TableEntity,
    name: keyof ExcludeFunction<T>
  ): ITableColumn {
    if (!this.columnMap) {
      this.columnMap = {};
      for (const column of this.getTableColumns()) {
        this.columnMap[column.entityFieldName] = column;
      }
    }

    return this.columnMap[name as string];
  }

  /**
   * 获取表的查询条件实例
   * @returns
   */
  public static getPredicates<T extends TableEntity>(this: Class<T> & typeof TableEntity): TablePredicates<T> {
    return new TablePredicates<T>(this);
  }

  /**
   * 使用属性构建表实体
   * @param props 属性集合
   */
  public static build<T extends TableEntity>(
    this: Class<T> & typeof TableEntity,
    props: ITableProps<T>
  ): T {
    const entity = new this();
    for (const key of Object.keys(props)) {
      entity[key] = props[key];
    }
    return entity;
  }

  /**
   * 执行sql语句
   *
   * @param sql 待执行的sql语句
   */
  public static async executeSql(sql: string): Promise<void> {
    const store = await this.storePromise;
    await store.executeSql(sql);
  }

  /**
   * 插入实体
   *
   * @return 返回插入数据的ID
   */
  public static async insert<T extends TableEntity>(
    this: Class<T> & typeof TableEntity,
    props: ITableProps<T>
  ): Promise<number> {
    const tableOptions = this.getTableOptions();
    if (!tableOptions) {
      log.showError(`Table options is undefined`);
      return -1;
    }
    const store = await this.storePromise;
    return store.insert(tableOptions.name, this.convertPropsToRdbValue(props));
  }

  /**
   * 更新实体
   *
   * @return 返回更新数据的行数
   */
  public static async update<T extends TableEntity>(
    this: Class<T> & typeof TableEntity,
    props: ITableProps<T>,
    predicates: TablePredicates<T>,
    columns?: string[],
  ): Promise<number> {
    const store = await this.storePromise;
    return store.update(this.convertPropsToRdbValue(props, columns), predicates.rdbPredicates);
  }

  /**
   * 使用 = 条件根据表实体字段更新表数据
   *
   * @param props 表实体属性
   * @param options 查询选项
   * @returns 返回数据
   */
  public static async updateByProps<T extends TableEntity>(
    this: Class<T> & typeof TableEntity,
    updateProps: ITableProps<T>,
    predicatesProps: ITableProps<T>,
    columns?: string[],
  ): Promise<number> {
    const predicates = this.getPredicates();
    predicates.equalTo(predicatesProps);
    return this.update(updateProps, predicates, columns);
  }

  /**
   * 保存实体，如果存在id则为修改，如果不存在则修改
   */
  public static async delete<T extends TableEntity>(
    this: Class<T> & typeof TableEntity,
    predicates: TablePredicates<T>
  ): Promise<number> {
    const store = await this.storePromise;
    return store.delete(predicates.rdbPredicates);
  }

  /**
   * 使用 = 条件根据表实体字段删除数据库数据
   *
   * @param props 表实体属性
   * @param options 查询选项
   * @returns 返回数据
   */
  public static async deleteByProps<T extends TableEntity>(
    this: Class<T> & typeof TableEntity,
    props: ITableProps<T>,
  ): Promise<number> {
    const predicates = this.getPredicates();
    predicates.equalTo(props);
    return this.delete(predicates);
  }

  /**
   * 查询数据库单条数据
   *
   * @param predicates 查询条件
   * @param options 查询选项
   * @returns 返回数据
   */
  public static async query<T extends TableEntity>(
    this: Class<T> & typeof TableEntity,
    predicates: TablePredicates<T>,
    options?: ITableQueryOptions<T>
  ): Promise<T | undefined> {
    predicates.limitAs(1);
    const ret = await this.queryList<T>(predicates, options);
    return ret[0];
  }

  /**
   * 查询数据库多条数据
   *
   * @param predicates 查询条件
   * @param options 查询选项
   * @returns 数组返回数据
   */
  public static async queryList<T extends TableEntity>(
    this: Class<T> & typeof TableEntity,
    predicates: TablePredicates<T>,
    options?: ITableQueryOptions<T>
  ): Promise<T[]> {
    const columns = options?.columns ?
      options.columns.map((c) => this.getTableColumn(c as keyof ExcludeFunction<T>).name) :
      undefined;
    if (columns && !columns.includes('id')) {
      columns.push('id');
    }
    const store = await this.storePromise;
    const resultSet = await store.query(predicates.rdbPredicates, columns);
    const ret = await this.processResultSet<T>(resultSet, options);
    return ret;
  }

  /**
   * 使用 = 条件根据表实体字段查询数据库单条数据
   *
   * @param props 表实体属性
   * @param options 查询选项
   * @returns 返回数据
   */
  public static async queryByProps<T extends TableEntity>(
    this: Class<T> & typeof TableEntity,
    props: ITableProps<T>,
    options?: ITableQueryOptions<T>
  ): Promise<T | undefined> {
    const predicates = this.getPredicates<T>();
    predicates.equalTo(props);
    predicates.limitAs(1);
    const ret = await this.queryList<T>(predicates, options);
    return ret[0];
  }

  /**
   * 使用 = 条件根据表实体字段查询数据库多条数据
   *
   * @param props 表实体属性
   * @param options 查询选项
   * @returns 返回数据
   */
  public static async queryListByProps<T extends TableEntity>(
    this: Class<T> & typeof TableEntity,
    props: ITableProps<T>,
    options?: ITableQueryOptions<T>
  ): Promise<T[]> {
    const predicates = this.getPredicates<T>();
    predicates.equalTo(props);
    const ret = await this.queryList<T>(predicates, options);
    return ret;
  }

  /**
   * 查询数据条数
   * @param this
   * @param predicates
   * @returns
   */
  public static async queryCount<T extends TableEntity>(
    this: Class<T> & typeof TableEntity,
    predicates: TablePredicates<T>,
  ): Promise<number> {
    const list = await this.queryList(predicates, { columns: ['id'] as Array<keyof ExcludeFunction<T>> });
    return list.length;
  }

  /**
   * 使用 = 条件根据表实体字段查询数据库数据条数
   * @param this
   * @param props
   * @returns
   */
  public static async queryCountByProps<T extends TableEntity>(
    this: Class<T> & typeof TableEntity,
    props: ITableProps<T>,
  ): Promise<number> {
    const list = await this.queryListByProps(props, { columns: ['id'] });
    return list.length;
  }

  /**
   * 查询数据库单条数据
   *
   * @param sql sql语句
   * @param bindArgs 查询列属性
   * @returns 返回数据
   */
  public static async querySql<T extends TableEntity>(
    this: Class<T> & typeof TableEntity,
    sql: string,
    options?: ITableQuerySqlOptions
  ): Promise<T> {
    const ret = this.querySqlList(sql, options);
    return ret[0];
  }

  /**
   * 查询数据库多条数据
   *
   * @param sql sql语句
   * @param bindArgs 查询列属性
   * @returns 数组返回数据
   */
  public static async querySqlList<T extends TableEntity>(
    this: Class<T> & typeof TableEntity,
    sql: string,
    options?: ITableQuerySqlOptions
  ): Promise<T[]> {
    const store = await this.storePromise;
    const resultSet = await store.querySql(sql, options?.bindArgs);
    const ret = await this.processResultSet<T>(resultSet);
    return ret;
  }

  /**
   * 初始化表
   */
  public static async initTable(): Promise<void> {
    const tableOptions = this.getTableOptions();
    if (!tableOptions) {
      log.showError(`Table options is undefined`);
      return;
    }
    let resultSet: rdb.ResultSet | undefined;
    try {
      const store = await this.storePromise;
      resultSet = await store.querySql(`PRAGMA TABLE_INFO (${tableOptions.name})`);
      const columnNames = this.getColumnNames(resultSet);
      log.showInfo(`Table ${tableOptions.name} column names: ${columnNames}`);
      if (!columnNames.length) {
        await this.createTable(tableOptions);
        return;
      }
      const newColumns = this.getTableColumns().filter((c) => !columnNames.includes(c.name));
      if (newColumns.length) {
        await this.alterTable(tableOptions, newColumns);
      }
      log.showInfo(`Init table ${tableOptions.name} success.`);
    } catch (e) {
      LogWithHa.error(log, `Init table ${tableOptions.name} error: ${e}`, CommonExceptionCode.INIT_TABLE_FAIL, e);
    } finally {
      this.closeResultSet(resultSet);
    }
  }

  private static getColumnNames(resultSet: rdb.ResultSet): string[] {
    const columnNames: string[] = [];

    if (resultSet.rowCount > 0 && resultSet.columnNames.includes('name')) {
      const columnIndex = resultSet.getColumnIndex('name');
      resultSet.goToFirstRow();
      while (!resultSet.isEnded) {
        columnNames.push(resultSet.getString(columnIndex));
        resultSet.goToNextRow();
      }
    }

    return columnNames;
  }

  private static async createTable(tableOptions: ITableOptions): Promise<void> {
    const tableColumns = this.getTableColumns();
    const columnData: string[] = tableColumns.map((column) => {
      if (column.name === 'id') {
        return 'id INTEGER primary key autoincrement';
      }
      return `${column.name} ${column.dbFieldType}`;
    });
    const sql = `CREATE TABLE IF NOT EXISTS ${tableOptions.name} (${columnData.join(',\n')})`;
    await this.executeSql(sql);
    log.info(`Create table ${tableOptions.name} success.`);
  }

  private static async alterTable(tableOptions: ITableOptions, newColumns: ITableColumn[]): Promise<void> {
    const store = await this.storePromise;
    await store.beginTransaction();
    for (const column of newColumns) {
      await store.executeSql(`ALTER TABLE ${tableOptions.name} ADD ${column.name} ${column.dbFieldType};`);
      log.showInfo(`Add table ${tableOptions.name} column ${column.name}`);
    }
    await store.commit();
  }

  /**
   * 将数据库查询结果转为表实体类的示例
   * @param resultSet 数据库查询结果
   * @param options 数据库选项
   * @returns
   */
  private static async processResultSet<T extends TableEntity>(
    this: Class<T> & typeof TableEntity,
    resultSet: rdb.ResultSet,
    options?: ITableQueryOptions<T>
  ): Promise<T[]> {
    const ret: T[] = [];

    try {
      const tableColumns: ITableColumn[] = this.getTableColumns();
      const columnIndexMap: Record<string, number> = {};

      resultSet.goToFirstRow();
      while (!resultSet.isEnded) {
        const row = new this();
        row._columns = options?.columns as string[];
        for (const columnName of resultSet.columnNames) {
          const column = tableColumns.find((c) => c.name === columnName);
          if (!column) {
            continue;
          }

          let columnIndex: number = columnIndexMap[columnName];
          if (columnIndex === undefined) {
            columnIndex = resultSet.getColumnIndex(columnName);
            columnIndexMap[columnName] = columnIndex;
          }
          let columnValue;

          let isColumnInvalid = false;
          try {
            // 数据库中的null取出时转换成undefined。并发删除和查询时，可能触发rdb抛错。
            isColumnInvalid = resultSet.isColumnNull(columnIndex);
          } catch (e) {
            log.error('ResultSet isColumnNull error:', e);
            isColumnInvalid = true;
          }

          if (isColumnInvalid) {
            columnValue = undefined;
          } else if (column.entityFieldType === 'number') {
            columnValue = resultSet.getLong(columnIndex);
          } else if (column.entityFieldType === 'boolean') {
            columnValue = Boolean(resultSet.getLong(columnIndex));
          } else {
            columnValue = resultSet.getString(columnIndex);
          }
          if (typeof columnValue === 'string' && column.serialize) {
            try {
              columnValue = JSON.parse(columnValue);
            } catch (e) {
              LogWithHa.error(log, `Column ${columnName} parse to JSON failed: ${e}`, CommonExceptionCode.PARSE_JSON_FAIL, e);
            }
          }

          row[column.entityFieldName] = columnValue;
        }

        ret.push(row);
        resultSet.goToNextRow();
      }
    } finally {
      this.closeResultSet(resultSet);
    }

    return ret;
  }

  /**
   * 将表实体属性转换为数据库表数据结构
   */
  private static convertPropsToRdbValue<T extends TableEntity>(
    this: Class<T> & typeof TableEntity,
    props: ITableProps<T>,
    columns?: string[],
  ): rdb.ValuesBucket {
    const valueBucket: rdb.ValuesBucket = {};

    for (const field of Object.keys(props)) {
      if (columns && !columns.includes(field)) {
        continue;
      }
      const column = this.getTableColumn(field as keyof ExcludeFunction<T>);
      let value = props[field];

      // 数据库不支持undefined，转换成null
      if (value === undefined) {
        value = null;
      }

      if (column) {
        value = (value && column.serialize)
          ? JSON.stringify(value)
          : value;
        valueBucket[field] = value;
      }
    }

    return valueBucket;
  }

  /**
   * 保存实体到数据库，如果存在ID则为更新，如果不存在则插入
   */
  public async save(): Promise<void> {
    const tableEntityClass = this.constructor as typeof TableEntity;

    if (typeof this.id === 'number') {
      await tableEntityClass.updateByProps(this, { id: this.id }, this._columns);
    } else {
      this.id = await tableEntityClass.insert(this);
    }
  }

  /**
   * 开始批量操作, 该接口需要与endBatch成对调用
   * 该接口将获取数据库连接, 若获取成功, 后续的相关操作都会共用同一连接
   * @returns  若返回true则表示获取数据库连接成功, 后续执行结束需要endBatch, 返回false则表示获取失败, 后续执行结束不能执行endBatch
   */
  public static async beginBatch<T extends TableEntity>(
    this: Class<T> & typeof TableEntity
  ): Promise<boolean> {
    try{
      const store = await this.storePromise;
      await store.beginBatch();
      log.showInfo('begin batch success!');
      return true;
    } catch (e) {
      log.error('begin batch error:', e);
      return false;
    }
  }

  /**
   * 结束批量操作, 该接口需要与beginBatch成对调用
   * 该接口将释放数据库连接
   * @returns
   */
  public static async endBatch<T extends TableEntity>(
    this: Class<T> & typeof TableEntity
  ): Promise<void> {
    try{
      const store = await this.storePromise;
      await store.endBatch();
      log.showInfo('end batch success!');
    } catch (e) {
      log.error('end batch error:', e);
    }
  }

  /**
   * 从数据库删除实体
   */
  public async delete(): Promise<void> {
    const tableEntityClass = this.constructor as typeof TableEntity;
    await tableEntityClass.deleteByProps({ id: this.id });
  }

  private static closeResultSet(resultSet?: rdb.ResultSet): void {
    try {
      resultSet?.close();
    } catch (e) {
      log.error('Close result set error:', e);
    }
  }
}