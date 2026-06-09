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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit,when,ArgumentMatchers } from '@ohos/hypium';
import RdbSqlHelp, { SqlItemData, UpdateSqlDataSet } from '../../../../../../main/ets/db/RdbSqlHelp';
import rdb from '@ohos.data.relationalStore';
import { CommonConstants, GridLayoutItemInfo } from '../../../../../../main/ets/TsIndex';
export default function RdbSqlHelpTest() {
  describe('RdbSqlHelpTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('test_getItemDataKey', 0, () => {
      const rdbSqlHelp: RdbSqlHelp = RdbSqlHelp.getInstance();
      let result: rdb.ResultSet = {
        getColumnIndex: (columnName: string) => {
          return 1;
        },
        getLong: (columnName: number) => {
          return 0;
        },
        getString: (columnName: number) => {
          return '1'
        }
      } as rdb.ResultSet;
      expect(rdbSqlHelp['getItemDataKey'](result)).assertEqual('011101');
      result = {
        getColumnIndex: (columnName: string) => {
          return 1;
        },
        getLong: (columnName: number) => {
          return 7;
        },
        getString: (columnName: number) => {
          return '1'
        }
      } as rdb.ResultSet;
      expect(rdbSqlHelp['getItemDataKey'](result)).assertEqual('711171');
      result = {
        getColumnIndex: (columnName: string) => {
          return 1;
        },
        getLong: (columnName: number) => {
          return 5;
        },
        getString: (columnName: number) => {
          return '1'
        }
      } as rdb.ResultSet;
      expect(rdbSqlHelp['getItemDataKey'](result)).assertEqual('51');
      result = {
        getColumnIndex: (columnName: string) => {
          return 1;
        },
        getLong: (columnName: number) => {
          return 50;
        },
        getString: (columnName: number) => {
          return '1'
        }
      } as rdb.ResultSet;
      expect(rdbSqlHelp['getItemDataKey'](result)).assertEqual('501');
    })
    it('test_getItemKey', 0, () => {
      const rdbSqlHelp: RdbSqlHelp = RdbSqlHelp.getInstance();
      const gridLayoutItemInfo:GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.typeId =  CommonConstants.TYPE_APP;
      gridLayoutItemInfo.bundleName = 'nameStr';
      expect(rdbSqlHelp.getItemKey(gridLayoutItemInfo)).assertEqual('0nameStr0');
      gridLayoutItemInfo.abilityName = '1';
      expect(rdbSqlHelp.getItemKey(gridLayoutItemInfo)).assertEqual('0nameStr10');
      gridLayoutItemInfo.moduleName = '1';
      expect(rdbSqlHelp.getItemKey(gridLayoutItemInfo)).assertEqual('0nameStr110');
      gridLayoutItemInfo.appIndex = 1;
      expect(rdbSqlHelp.getItemKey(gridLayoutItemInfo)).assertEqual('0nameStr111');
      gridLayoutItemInfo.shortcutId = '1';
      expect(rdbSqlHelp.getItemKey(gridLayoutItemInfo)).assertEqual('0nameStr1111');
    })

    it('test_getItemKey_1', 0, () => {
      const rdbSqlHelp: RdbSqlHelp = RdbSqlHelp.getInstance();
      const gridLayoutItemInfo:GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.typeId =  CommonConstants.TYPE_SHORTCUT_ICON;
      gridLayoutItemInfo.bundleName = 'nameStr';
      expect(rdbSqlHelp.getItemKey(gridLayoutItemInfo)).assertEqual('7nameStr0');
      gridLayoutItemInfo.abilityName = '1';
      expect(rdbSqlHelp.getItemKey(gridLayoutItemInfo)).assertEqual('7nameStr10');
      gridLayoutItemInfo.moduleName = '1';
      expect(rdbSqlHelp.getItemKey(gridLayoutItemInfo)).assertEqual('7nameStr110');
      gridLayoutItemInfo.appIndex = 1;
      expect(rdbSqlHelp.getItemKey(gridLayoutItemInfo)).assertEqual('7nameStr111');
      gridLayoutItemInfo.shortcutId = '1';
      expect(rdbSqlHelp.getItemKey(gridLayoutItemInfo)).assertEqual('7nameStr1111');
    })

    it('test_getItemKey_2', 0, () => {
      const rdbSqlHelp: RdbSqlHelp = RdbSqlHelp.getInstance();
      const gridLayoutItemInfo:GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.typeId =  CommonConstants.TYPE_FOLDER;
      gridLayoutItemInfo.folderId = 'nameStr';
      gridLayoutItemInfo.cardId = 'nameStr';
      gridLayoutItemInfo.formStackId = 'nameStr';
      gridLayoutItemInfo.ino = 'nameStr';
      expect(rdbSqlHelp.getItemKey(gridLayoutItemInfo)).assertEqual('3nameStr');
      gridLayoutItemInfo.typeId =  CommonConstants.TYPE_CARD;
      expect(rdbSqlHelp.getItemKey(gridLayoutItemInfo)).assertEqual('1nameStr');
      gridLayoutItemInfo.typeId =  CommonConstants.TYPE_FORM_STACK;
      expect(rdbSqlHelp.getItemKey(gridLayoutItemInfo)).assertEqual('6nameStr');
      gridLayoutItemInfo.typeId =  CommonConstants.TYPE_FILE_FOLDER;
      expect(rdbSqlHelp.getItemKey(gridLayoutItemInfo)).assertEqual('5nameStr');
    })

    it('test_getUpdateSqlDataSet', 0, () => {
      const rdbSqlHelp: RdbSqlHelp = RdbSqlHelp.getInstance();
      const sqlItemData:SqlItemData = new SqlItemData();
      const gridLayoutItemInfo:GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.row = 1;
      gridLayoutItemInfo.column = 1;
      gridLayoutItemInfo.page = 1;
      gridLayoutItemInfo.row = 1;
      gridLayoutItemInfo.area = [1,2];
      gridLayoutItemInfo.uri = 'http://www.baidu.com';
      gridLayoutItemInfo.fileFolderName = 'good_file';
      let mocker: MockKit = new MockKit();
      let func: Function = mocker.mockFunc(rdbSqlHelp, rdbSqlHelp.getItemKey);
      when(func)(ArgumentMatchers.any).afterReturn('oldName');
      try {
        sqlItemData.keyMap.set('oldName', 1);
        gridLayoutItemInfo.typeId = CommonConstants.DOCK_SPACE;
        sqlItemData.updateList = [gridLayoutItemInfo];
        expect(rdbSqlHelp.getUpdateSqlDataSet(sqlItemData, 1)).not().assertNull();
        expect(rdbSqlHelp.getUpdateSqlDataSet(sqlItemData, 0)).not().assertNull();
        gridLayoutItemInfo.container = 10;
        sqlItemData.updateList = [gridLayoutItemInfo];
        expect(rdbSqlHelp.getUpdateSqlDataSet(sqlItemData, 0)).not().assertNull();
        gridLayoutItemInfo.typeId = CommonConstants.TYPE_FILE_FOLDER;
        expect(rdbSqlHelp.getUpdateSqlDataSet(sqlItemData, 0)).not().assertNull();
      } catch (e) {
      }
      mocker.clear(rdbSqlHelp);
      mocker.clearAll();
    })

    it('test_getBatchUpdateSql', 0, () => {
      const rdbSqlHelp: RdbSqlHelp = RdbSqlHelp.getInstance();
      const updateSqlDataSet:UpdateSqlDataSet = new UpdateSqlDataSet();
      updateSqlDataSet.idArray = [1];
      expect(rdbSqlHelp.getBatchUpdateSql(updateSqlDataSet,2,'1',1)).assertEqual('');
      expect(rdbSqlHelp.getBatchUpdateSql(updateSqlDataSet,0,'1',1)).assertInstanceOf('String');
    })
  })
}