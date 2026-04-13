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

import { Class } from '@ohos/frameworkwrapper/src/main/ets/base/CommonType';
import type { TableEntity } from './TableEntity';
import {
  IColumnOptions,
  ITableColumn,
  ITableOptions,
  ENTITY_FIELD_TYPE_2_DB_COLUMN_TYPE_MAP,
} from './TableModel';

interface TableDecoratorOptions {
  table?: ITableOptions;
  columns?: ITableColumn[];
}

export const TABLE_OPTIONS_MAP: WeakMap<Class<TableEntity>, TableDecoratorOptions> = new WeakMap();

/**
 * 装饰数据库表
 * @param options 选项
 */
export const Table = (options: ITableOptions) => {
  return (target: Class<TableEntity>): void => {
    let tableOptions = TABLE_OPTIONS_MAP.get(target);
    if (!tableOptions) {
      tableOptions = {};
      TABLE_OPTIONS_MAP.set(target, tableOptions);
    }
    tableOptions.table = options;
  };
};

/**
 * 装饰数据库表的列属性
 *
 * @param options
 */
export const Column = (options: IColumnOptions) => {
  return (target: TableEntity, propertyKey: string): void => {
    const entityClass = target.constructor as Class<TableEntity>;
    const entityFieldType = options.type;
    let tableOptions = TABLE_OPTIONS_MAP.get(entityClass);

    if (!tableOptions) {
      tableOptions = {};
      TABLE_OPTIONS_MAP.set(entityClass, tableOptions);
    }
    const columns: ITableColumn[] = tableOptions.columns ?? [];
    columns.push({
      name: options?.name ?? propertyKey,
      dbFieldType: ENTITY_FIELD_TYPE_2_DB_COLUMN_TYPE_MAP[entityFieldType],
      entityFieldType,
      serialize: options?.serialize,
      entityFieldName: propertyKey
    });
    tableOptions.columns = columns;
  };
};
