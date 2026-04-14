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

import { beforeAll, describe, expect, it } from '@ohos/hypium';
import rdb from '@ohos.data.relationalStore';
import { Table, Column } from '../../../../../main/ets/database/TableDecorator';
import { TableEntity } from '../../../../../main/ets/database/TableEntity';
import { ITableColumn } from '../../../../../main/ets/database/TableModel';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { RdbStore } from '../../../../../main/ets/database/RdbStore';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'TableEntityTest');

interface Person {
  name: string;
  age: number;
}

export function TableEntityTest() {
  describe('TableEntityTest', () => {
    const tableName = 'test_table';
    const dbConfig: rdb.StoreConfig = {
      name: 'test.db',
      securityLevel: rdb.SecurityLevel.S1,
    };

    beforeAll(async () => {
      await rdb.deleteRdbStore(GlobalContext.getContext(), dbConfig).catch((e: Error) => {
        log.error('Delete old store error:', e);
      });
    });

    @Table({ name: tableName })
    class TestEntity extends TableEntity {
      @Column({ name: 'fieldA', type: 'string' })
      fieldA: string = '';
      @Column({ name: 'fieldB', type: 'number' })
      fieldB: number = 0;
      @Column({ name: 'fieldC', type: 'boolean' })
      fieldC: boolean = false;
      @Column({ name: 'fieldD', type: 'string', serialize: true })
      fieldD: Person = { name: '', age: 0 };
    }

    it('should_return_correct_table_name', 0, () => {
      expect(TestEntity.getTableOptions()?.name).assertEqual(tableName);
    });

    it('should_return_correct_table_columns', 0, () => {
      const tableColumns = TestEntity.getTableColumns();
      log.info('tableColumns:', tableColumns);

      const expectedFieldAColumn: ITableColumn = {
        name: 'fieldA',
        entityFieldType: 'string',
        dbFieldType: 'TEXT',
        serialize: undefined,
        entityFieldName: 'fieldA',
      };
      expect(tableColumns[1]).assertDeepEquals(expectedFieldAColumn);

      const expectedFieldBColumn: ITableColumn = {
        name: 'fieldB',
        entityFieldType: 'number',
        dbFieldType: 'INTEGER',
        serialize: undefined,
        entityFieldName: 'fieldB',
      };
      expect(tableColumns[2]).assertDeepEquals(expectedFieldBColumn);

      const expectedFieldCColumn: ITableColumn = {
        name: 'fieldC',
        entityFieldType: 'boolean',
        dbFieldType: 'INTEGER',
        serialize: undefined,
        entityFieldName: 'fieldC',
      };
      expect(tableColumns[3]).assertDeepEquals(expectedFieldCColumn);

      const expectedFieldDColumn: ITableColumn = {
        name: 'fieldD',
        entityFieldType: 'string',
        dbFieldType: 'TEXT',
        serialize: true,
        entityFieldName: 'fieldD',
      };
      expect(tableColumns[4]).assertDeepEquals(expectedFieldDColumn);
    });

    it('should_create_table_successfully', 0, async () => {
      const rdbStore = new RdbStore(dbConfig);
      rdbStore.initStore(GlobalContext.getContext());
      TestEntity.init(rdbStore);
      await TestEntity.initTable();
      const tableResultSet = await rdbStore.querySql(`SELECT name, type FROM PRAGMA_TABLE_INFO('${tableName}')`);
      expect(tableResultSet.rowCount > 0).assertTrue();
    });

    it('should_insert_entity_successfully', 0, async () => {
      const entityAProps = TestEntity.build({
        fieldA: 'A',
        fieldB: 1,
        fieldC: true,
        fieldD: {
          name: 'Pip',
          age: 18
        },
      });
      await TestEntity.insert(entityAProps);
      log.info('entityAProps:', entityAProps);

      const entityBProps = TestEntity.build({
        fieldA: 'B',
        fieldB: 2,
        fieldC: false,
        fieldD: {
          name: 'He',
          age: 22
        },
      });
      await TestEntity.insert(entityBProps);
      log.info('entityBProps:', entityBProps);

      const predicatesA = TestEntity.getPredicates();
      predicatesA.equalTo({ fieldA: 'A' });
      const entityA = await TestEntity.query(predicatesA);
      log.info('entityA:', entityA);
      expect(entityA?.fieldA).assertEqual('A');
      expect(entityA?.fieldB).assertEqual(1);
      expect(entityA?.fieldC).assertEqual(true);
      expect(entityA?.fieldD).assertDeepEquals({
        name: 'Pip',
        age: 18
      });

      const predicatesB = TestEntity.getPredicates();
      predicatesB.equalTo({ fieldA: 'B' });
      const entityB = await TestEntity.query(predicatesB);
      log.info('entityB:', entityB);
      expect(entityB?.fieldA).assertEqual('B');
      expect(entityB?.fieldB).assertEqual(2);
      expect(entityB?.fieldC).assertEqual(false);
      expect(entityB?.fieldD).assertDeepEquals({
        name: 'He',
        age: 22
      });
    });

    it('should_update_entity_successfully', 0, async () => {
      const predicatesA = TestEntity.getPredicates();
      predicatesA.equalTo({ fieldA: 'A' });
      await TestEntity.update({ fieldB: 11 }, predicatesA);
      const entityA = await TestEntity.query(predicatesA);
      expect(entityA?.fieldB).assertDeepEquals(11);
    });

    it('should_delete_entity_successfully', 0, async () => {
      const predicatesA = TestEntity.getPredicates();
      predicatesA.equalTo({ fieldA: 'A1' });
      await TestEntity.delete(predicatesA);

      const entityA = await TestEntity.query(predicatesA);
      expect(entityA).assertUndefined();
    });
  });
}