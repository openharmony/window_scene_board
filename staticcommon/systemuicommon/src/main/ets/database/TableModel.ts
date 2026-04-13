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
import { ExcludeFunction, Props } from '@ohos/frameworkwrapper/src/main/ets/base/CommonType';

/**
 * 表实体支持的字段类型
 */
export const ENTITY_FIELD_TYPES = ['string', 'number', 'boolean'] as const;

/**
 * 数据库表支持的字段类型
 */
export const DB_COLUMN_TYPES = ['TEXT', 'INTEGER', 'DOUBLE'] as const;

export type IEntityFieldType = typeof ENTITY_FIELD_TYPES[number];

export type IDbColumnType = typeof DB_COLUMN_TYPES[number];

/**
 * 表实体字段类型对应到数据库列类型
 */
export const ENTITY_FIELD_TYPE_2_DB_COLUMN_TYPE_MAP: Record<IEntityFieldType, IDbColumnType> = {
  string: 'TEXT',
  number: 'INTEGER',
  boolean: 'INTEGER',
};

/**
 * 数据库表装饰器选项
 */
export interface ITableOptions {
  /**
   * 表名
   */
  name: string;
}

interface IColumn {
  /**
   * 列名
   */
  name: string;

  /**
   * 是否序列化，用来存取JSON格式数据，默认：false
   */
  serialize?: boolean;
}

/**
 * 数据库表列装饰器选项
 */
export interface IColumnOptions extends IColumn {
  /**
   * 列类型，不指定时从类实体字段类型映射，映射关系参考TABLE_FIELD_TYPE_2_DB_COLUMN_TYPE_MAP
   */
  type: IEntityFieldType;
}

/**
 * 数据库表列信息
 */
export interface ITableColumn extends IColumn {
  /**
   * 表实体类对应字段名
   */
  entityFieldName: string;

  /**
   * 数据库对应列类型
   */
  dbFieldType: IDbColumnType;

  /**
   * 表实体类对应字段类型
   */
  entityFieldType: IEntityFieldType;
}

/**
 * 表实体接口，使用class关键字是为了解决interface不支持static的问题
 */
export declare class ITableEntity {
  /**
   * 获取表选项
   */
  static getTableOptions: () => ITableOptions;

  /**
   * 获取表列
   */
  static getTableColumn: (field: string) => ITableColumn;
}

/**
 * 表格实体字段属性集合
 */
export type ITableProps<T> = Partial<Props<T>>;

/**
 * 查询选项
 */
export interface ITableQueryOptions<T> {
  /**
   * 查询结果指定的列
   */
  columns?: Array<keyof ExcludeFunction<T>>;
}

/**
 * SQL查询选项
 */
export interface ITableQuerySqlOptions {
  /**
   * SQL语句参数
   */
  bindArgs?: rdb.ValueType[];
}