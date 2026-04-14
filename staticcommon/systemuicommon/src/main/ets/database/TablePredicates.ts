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
import { Class } from '@ohos/frameworkwrapper/src/main/ets/base/CommonType';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { ITableEntity, ITableProps } from './TableModel';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'TablePredicates');

export class TablePredicates<
  /**
   * 表实体类
   */
  T,
  /**
   * 表实体匹配条件
   */
  MatchCondition = ITableProps<T>,
  /**
   * 表实体范围条件
   */
  RangeCondition = { [K in keyof MatchCondition]: [MatchCondition[K], MatchCondition[K]] },
  /**
   * 表实体包含条件
   */
  InCondition = { [K in keyof MatchCondition]: Array<MatchCondition[K]> }
> {
  /**
   * OHOS的rdb predicates实例，最终传递给rdb使用的对象
   */
  public readonly rdbPredicates: rdb.RdbPredicates;

  constructor(private tableEntityClass: Class<T> & typeof ITableEntity) {
    this.rdbPredicates = new rdb.RdbPredicates(tableEntityClass.getTableOptions().name);
  }

  /**
   * 添加 = 条件，支持undefined转成null
   * @param condition 条件集合
   */
  equalTo(condition: MatchCondition): this {
    this.iterateCondition(condition, (field, value) => {
      if (value === undefined) {
        this.rdbPredicates.isNull(field);
      } else {
        this.rdbPredicates.equalTo(field, value as rdb.ValueType);
      }
    });
    return this;
  }

  /**
   * 添加 != 条件，支持undefined转成null
   * @param condition 条件集合
   */
  notEqualTo(condition: MatchCondition): this {
    this.iterateCondition(condition, (field, value) => {
      if (value === undefined) {
        this.rdbPredicates.isNotNull(field);
      } else {
        this.rdbPredicates.notEqualTo(field, value as rdb.ValueType);
      }
    });
    return this;
  }

  /**
   * 添加开始括号(
   */
  beginWrap(): this {
    this.rdbPredicates.beginWrap();
    return this;
  }

  /**
   * 添加结束括号)
   */
  endWrap(): this {
    this.rdbPredicates.endWrap();
    return this;
  }

  /**
   * 添加 OR 条件
   */
  or(): this {
    this.rdbPredicates.or();
    return this;
  }

  /**
   * 添加 AND 条件
   */
  and(): this {
    this.rdbPredicates.and();
    return this;
  }

  /**
   * 添加包含条件
   * @param condition 条件集合
   */
  contains(condition: MatchCondition): this {
    this.iterateCondition(condition, (field, value) => {
      this.rdbPredicates.contains(field, value as string);
    });
    return this;
  }

  /**
   * 添加 like value% 条件
   * @param condition 条件集合
   */
  beginsWith(condition: MatchCondition): this {
    this.iterateCondition(condition, (field, value) => {
      this.rdbPredicates.beginsWith(field, value as string);
    });
    return this;
  }

  /**
   * 添加 like %value 条件
   * @param condition 条件集合
   */
  endsWith(condition: MatchCondition): this {
    this.iterateCondition(condition, (field, value) => {
      this.rdbPredicates.endsWith(field, value as string);
    });
    return this;
  }

  /**
   * 添加 is null 条件
   * @param condition 条件集合
   */
  isUndefined(field: keyof MatchCondition): this {
    this.rdbPredicates.isNull(this.tableEntityClass.getTableColumn(field as string).name);
    return this;
  }

  /**
   * 添加 is not null 条件
   * @param condition 条件集合
   */
  isDefined(field: keyof MatchCondition): this {
    this.rdbPredicates.isNotNull(this.tableEntityClass.getTableColumn(field as string).name);
    return this;
  }

  /**
   * 添加 like %value% 条件
   * @param condition 条件集合
   */
  like(condition: MatchCondition): this {
    this.iterateCondition(condition, (field, value) => {
      this.rdbPredicates.like(field, value as string);
    });
    return this;
  }

  /**
   * 添加 glob 条件
   * @param condition 条件集合
   */
  glob(condition: MatchCondition): this {
    this.iterateCondition(condition, (field, value) => {
      this.rdbPredicates.glob(field, value as string);
    });
    return this;
  }

  /**
   * 添加 between 条件
   * @param condition 条件集合
   */
  between(condition: RangeCondition): this {
    this.iterateCondition(condition, (field, value) => {
      this.rdbPredicates.between(field, value[0], value[1]);
    });
    return this;
  }

  /**
   * 添加 not between 条件
   * @param condition 条件集合
   */
  notBetween(condition: RangeCondition): this {
    this.iterateCondition(condition, (field, value) => {
      this.rdbPredicates.notBetween(field, value[0], value[1]);
    });
    return this;
  }

  /**
   * 添加 > 条件
   * @param condition 条件集合
   */
  greaterThan(condition: MatchCondition): this {
    this.iterateCondition(condition, (field, value) => {
      this.rdbPredicates.greaterThan(field, value as string);
    });
    return this;
  }

  /**
   * 添加 < 条件
   * @param condition 条件集合
   */
  lessThan(condition: MatchCondition): this {
    this.iterateCondition(condition, (field, value) => {
      this.rdbPredicates.lessThan(field, value as string);
    });
    return this;
  }

  /**
   * 添加 >= 条件
   * @param condition 条件集合
   */
  greaterThanOrEqualTo(condition: MatchCondition): this {
    this.iterateCondition(condition, (field, value) => {
      this.rdbPredicates.greaterThanOrEqualTo(field, value as string);
    });
    return this;
  }

  /**
   * 添加 <= 条件
   * @param condition 条件集合
   */
  lessThanOrEqualTo(condition: MatchCondition): this {
    this.iterateCondition(condition, (field, value) => {
      this.rdbPredicates.lessThanOrEqualTo(field, value as string);
    });
    return this;
  }

  /**
   * 添加 order by asc
   * @param field 属性名
   */
  orderByAsc(field: keyof MatchCondition): this {
    this.rdbPredicates.orderByAsc(this.tableEntityClass.getTableColumn(field as string).name);
    return this;
  }

  /**
   * 添加 order by desc
   * @param field 属性名
   */
  orderByDesc(field: keyof MatchCondition): this {
    this.rdbPredicates.orderByDesc(this.tableEntityClass.getTableColumn(field as string).name);
    return this;
  }

  /**
   * 添加 distinct
   */
  distinct(): this {
    this.rdbPredicates.distinct();
    return this;
  }

  /**
   * 添加 limit
   * @param value limit数值
   */
  limitAs(value: number): this {
    this.rdbPredicates.limitAs(value);
    return this;
  }

  /**
   * 添加 offset，与需要与limit一起使用
   * @param value offset数值
   */
  offsetAs(value: number): this {
    this.rdbPredicates.offsetAs(value);
    return this;
  }

  /**
   * 添加 group by
   * @param fields 属性名集合
   */
  groupBy(fields: Array<keyof MatchCondition>): this {
    this.rdbPredicates.groupBy(fields.map((field) => this.tableEntityClass.getTableColumn(field as string).name));
    return this;
  }

  /**
   * 添加 indexed by
   * @param fields 属性名集合
   */
  indexedBy(field: keyof MatchCondition): this {
    this.rdbPredicates.indexedBy(this.tableEntityClass.getTableColumn(field as string).name);
    return this;
  }

  /**
   * 添加 in 条件
   * @param condition 条件集合
   */
  inCondition(condition: InCondition): this {
    this.iterateCondition(condition, (field, value) => {
      this.rdbPredicates.in(field, value as rdb.ValueType[]);
    });
    return this;
  }

  /**
   * 添加 not in 条件
   * @param condition 条件集合
   */
  notIn(condition: InCondition): this {
    this.iterateCondition(condition, (field, value) => {
      this.rdbPredicates.notIn(field, value as rdb.ValueType[]);
    });
    return this;
  }

  /**
   * 遍历条件集合
   * @param condition 条件集合
   * @param callback 回调
   */
  private iterateCondition<C>(condition: C, callback: (field: string, value: Object) => void): void {
    for (const field of Object.keys(condition)) {
      const column = this.tableEntityClass.getTableColumn(field);

      if (!column) {
        log.showWarn(`Cannot find table column for field ${field}.`);
        continue;
      }

      callback(column.name, condition[field]);
    }
  }
}