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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import relationalStore from '@ohos.data.relationalStore';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { SysUIUpdateRdbManager } from '../../../main/ets/manager/SysUIUpdateRdbManager';
export default function SysUIUpdateRdbManagerTest() {
  describe('setNotificationRdbStore_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_log_info_when_setNotificationRdbStore_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let sysuiupdaterdbmanager: SysUIUpdateRdbManager = new SysUIUpdateRdbManager();
      let notificationRdbStore: relationalStore.RdbStore = new relationalStore.RdbStore();
      await sysuiupdaterdbmanager.setNotificationRdbStore(notificationRdbStore);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
    it('should_set_notificationRdbStore_when_setNotificationRdbStore_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let sysuiupdaterdbmanager: SysUIUpdateRdbManager = new SysUIUpdateRdbManager();
      let notificationRdbStore: relationalStore.RdbStore = new relationalStore.RdbStore();
      await sysuiupdaterdbmanager.setNotificationRdbStore(notificationRdbStore);

      expect(sysuiupdaterdbmanager.mNotificationRdbStore).assertDeepEquals(notificationRdbStore);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_empty_list_when_query_returns_empty_result', 0, async () => {
      let sysuiupdaterdbmanager: SysUIUpdateRdbManager = new SysUIUpdateRdbManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockResultSet: relationalStore.ResultSet = new relationalStore.ResultSet();
      mockResultSet.goToFirstRow = () => false;

      sysuiupdaterdbmanager.mNotificationRdbStore = {
        querySql: async (query: string) => mockResultSet
      } as relationalStore.RdbStore;

      const result = await sysuiupdaterdbmanager.queryNotificationSetting();
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_list_with_items_when_query_returns_result', 0, async () => {
      let sysuiupdaterdbmanager: SysUIUpdateRdbManager = new SysUIUpdateRdbManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockResultSet: relationalStore.ResultSet = new relationalStore.ResultSet();
      mockResultSet.goToFirstRow = () => true;
      mockResultSet.goToNextRow = () => false;
      mockResultSet.getString = (index: number) => index === 0 ? 'key1' : 'value1';
      mockResultSet.getColumnIndex = (columnName: string) => columnName === 'preference_key' ? 0 : 1;

      sysuiupdaterdbmanager.mNotificationRdbStore = {
        querySql: async (query: string) => mockResultSet
      } as relationalStore.RdbStore;

      const result = await sysuiupdaterdbmanager.queryNotificationSetting();
      expect(result.length).assertEqual(1);
      expect(result[0].preferenceKey).assertEqual('key1');
      expect(result[0].preferenceValue).assertEqual('value1');

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_log_error_when_query_throws_exception', 0, async () => {
      let sysuiupdaterdbmanager: SysUIUpdateRdbManager = new SysUIUpdateRdbManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      sysuiupdaterdbmanager.mNotificationRdbStore = {
        querySql: async (query: string) => {
          throw new Error('Test error');
        }
      } as relationalStore.RdbStore;

      const result = await sysuiupdaterdbmanager.queryNotificationSetting();
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_empty_list_when_query_returns_empty_result', 0, async () => {
      let sysuiupdaterdbmanager: SysUIUpdateRdbManager = new SysUIUpdateRdbManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockResultSet: relationalStore.ResultSet = {
        goToFirstRow: () => false,
        goToNextRow: () => false,
        getColumnIndex: (columnName: string) => 0,
        getString: (index: number) => ''
      };

      const result = await sysuiupdaterdbmanager.queryNotificationEnableSetting();
      expect(result.length).assertEqual(0);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_settings_info_list_when_query_returns_result', 0, async () => {
      let sysuiupdaterdbmanager: SysUIUpdateRdbManager = new SysUIUpdateRdbManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockResultSet: relationalStore.ResultSet = {
        goToFirstRow: () => true,
        goToNextRow: () => false,
        getColumnIndex: (columnName: string) => 0,
        getString: (index: number) => 'com.example.app',
        getInt: (index: number) => 1
      };

      const result = await sysuiupdaterdbmanager.queryNotificationEnableSetting();
      expect(result.length).assertEqual(1);
      expect(result[0].packageName).assertEqual('com.example.app');
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_log_error_when_query_throws_exception', 0, async () => {
      let sysuiupdaterdbmanager: SysUIUpdateRdbManager = new SysUIUpdateRdbManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockResultSet: relationalStore.ResultSet = {
        goToFirstRow: () => true,
        goToNextRow: () => false,
        getColumnIndex: (columnName: string) => 0,
        getString: (index: number) => 'com.example.app',
        getInt: (index: number) => 1
      };

      let mockQuerySql: Function = mocker.mockFunc(sysuiupdaterdbmanager.mNotificationRdbStore, sysuiupdaterdbmanager.mNotificationRdbStore.querySql);
      when(mockQuerySql)(ArgumentMatchers.anyString).afterThrow('Database error');

      const result = await sysuiupdaterdbmanager.queryNotificationEnableSetting();
      expect(result.length).assertEqual(1);
      expect(result[0].packageName).assertEqual('com.example.app');
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
      mocker.ignoreMock(sysuiupdaterdbmanager.mNotificationRdbStore, sysuiupdaterdbmanager.mNotificationRdbStore.querySql);
    });

    it('should_return_empty_list_when_query_returns_empty_result', 0, async () => {
      let sysuiupdaterdbmanager: SysUIUpdateRdbManager = new SysUIUpdateRdbManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockResultSet: relationalStore.ResultSet = new relationalStore.ResultSet();
      when(mockResultSet.goToFirstRow()).afterReturn(false);

      const result = await sysuiupdaterdbmanager.queryNotificationAppSetting();
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_list_with_one_element_when_query_returns_one_row_result', 0, async () => {
      let sysuiupdaterdbmanager: SysUIUpdateRdbManager = new SysUIUpdateRdbManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockResultSet: relationalStore.ResultSet = new relationalStore.ResultSet();
      when(mockResultSet.goToFirstRow()).afterReturn(true);
      when(mockResultSet.goToNextRow()).afterReturn(false);
      when(mockResultSet.getString(ArgumentMatchers.anyNumber)).afterReturn('bundle1', 'uid1', 'pinTop1');
      when(mockResultSet.getColumnIndex(ArgumentMatchers.anyString)).afterReturn(0, 1, 2);

      const result = await sysuiupdaterdbmanager.queryNotificationAppSetting();
      expect(result.length).assertEqual(1);
      expect(result[0].appBundle).assertEqual('bundle1');
      expect(result[0].uid).assertEqual('uid1');
      expect(result[0].pinTopEnable).assertEqual('pinTop1');

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_list_with_multiple_elements_when_query_returns_multiple_row_result', 0, async () => {
      let sysuiupdaterdbmanager: SysUIUpdateRdbManager = new SysUIUpdateRdbManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockResultSet: relationalStore.ResultSet = new relationalStore.ResultSet();
      when(mockResultSet.goToFirstRow()).afterReturn(true);
      when(mockResultSet.goToNextRow()).afterReturn(true, false);
      when(mockResultSet.getString(ArgumentMatchers.anyNumber)).afterReturn('bundle1', 'uid1', 'pinTop1', 'bundle2', 'uid2', 'pinTop2');
      when(mockResultSet.getColumnIndex(ArgumentMatchers.anyString)).afterReturn(0, 1, 2);

      const result = await sysuiupdaterdbmanager.queryNotificationAppSetting();
      expect(result.length).assertEqual(2);
      expect(result[0].appBundle).assertEqual('bundle1');
      expect(result[0].uid).assertEqual('uid1');
      expect(result[0].pinTopEnable).assertEqual('pinTop1');
      expect(result[1].appBundle).assertEqual('bundle2');
      expect(result[1].uid).assertEqual('uid2');
      expect(result[1].pinTopEnable).assertEqual('pinTop2');

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_log_error_when_query_throws_exception', 0, async () => {
      let sysuiupdaterdbmanager: SysUIUpdateRdbManager = new SysUIUpdateRdbManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      when(sysuiupdaterdbmanager.mNotificationRdbStore.querySql(ArgumentMatchers.anyString)).afterThrow('Database error');

      const result = await sysuiupdaterdbmanager.queryNotificationAppSetting();
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_log_info_when_setNotificationRdbStore_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let sysuiupdaterdbmanager: SysUIUpdateRdbManager = new SysUIUpdateRdbManager();
      let notificationRdbStore: relationalStore.RdbStore = new relationalStore.RdbStore();
      await sysuiupdaterdbmanager.setNotificationRdbStore(notificationRdbStore);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
    it('should_set_notificationRdbStore_when_setNotificationRdbStore_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let sysuiupdaterdbmanager: SysUIUpdateRdbManager = new SysUIUpdateRdbManager();
      let notificationRdbStore: relationalStore.RdbStore = new relationalStore.RdbStore();
      await sysuiupdaterdbmanager.setNotificationRdbStore(notificationRdbStore);

      expect(sysuiupdaterdbmanager.mNotificationRdbStore).assertDeepEquals(notificationRdbStore);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_empty_list_when_query_returns_empty_result', 0, async () => {
      let sysuiupdaterdbmanager: SysUIUpdateRdbManager = new SysUIUpdateRdbManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockResultSet: relationalStore.ResultSet = new relationalStore.ResultSet();
      mockResultSet.goToFirstRow = () => false;

      sysuiupdaterdbmanager.mNotificationRdbStore = {
        querySql: async (query: string) => mockResultSet
      } as relationalStore.RdbStore;

      const result = await sysuiupdaterdbmanager.queryNotificationSetting();
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_list_with_items_when_query_returns_result', 0, async () => {
      let sysuiupdaterdbmanager: SysUIUpdateRdbManager = new SysUIUpdateRdbManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockResultSet: relationalStore.ResultSet = new relationalStore.ResultSet();
      mockResultSet.goToFirstRow = () => true;
      mockResultSet.goToNextRow = () => false;
      mockResultSet.getString = (index: number) => index === 0 ? 'key1' : 'value1';
      mockResultSet.getColumnIndex = (columnName: string) => columnName === 'preference_key' ? 0 : 1;

      sysuiupdaterdbmanager.mNotificationRdbStore = {
        querySql: async (query: string) => mockResultSet
      } as relationalStore.RdbStore;

      const result = await sysuiupdaterdbmanager.queryNotificationSetting();
      expect(result.length).assertEqual(1);
      expect(result[0].preferenceKey).assertEqual('key1');
      expect(result[0].preferenceValue).assertEqual('value1');

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_log_error_when_query_throws_exception', 0, async () => {
      let sysuiupdaterdbmanager: SysUIUpdateRdbManager = new SysUIUpdateRdbManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      sysuiupdaterdbmanager.mNotificationRdbStore = {
        querySql: async (query: string) => {
          throw new Error('Test error');
        }
      } as relationalStore.RdbStore;

      const result = await sysuiupdaterdbmanager.queryNotificationSetting();
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_empty_list_when_query_returns_empty_result', 0, async () => {
      let sysuiupdaterdbmanager: SysUIUpdateRdbManager = new SysUIUpdateRdbManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockResultSet: relationalStore.ResultSet = {
        goToFirstRow: () => false,
        goToNextRow: () => false,
        getColumnIndex: (columnName: string) => 0,
        getString: (index: number) => ''
      };

      const result = await sysuiupdaterdbmanager.queryNotificationEnableSetting();
      expect(result.length).assertEqual(0);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_settings_info_list_when_query_returns_result', 0, async () => {
      let sysuiupdaterdbmanager: SysUIUpdateRdbManager = new SysUIUpdateRdbManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockResultSet: relationalStore.ResultSet = {
        goToFirstRow: () => true,
        goToNextRow: () => false,
        getColumnIndex: (columnName: string) => 0,
        getString: (index: number) => 'com.example.app',
        getInt: (index: number) => 1
      };

      const result = await sysuiupdaterdbmanager.queryNotificationEnableSetting();
      expect(result.length).assertEqual(1);
      expect(result[0].packageName).assertEqual('com.example.app');
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_log_error_when_query_throws_exception', 0, async () => {
      let sysuiupdaterdbmanager: SysUIUpdateRdbManager = new SysUIUpdateRdbManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockResultSet: relationalStore.ResultSet = {
        goToFirstRow: () => true,
        goToNextRow: () => false,
        getColumnIndex: (columnName: string) => 0,
        getString: (index: number) => 'com.example.app',
        getInt: (index: number) => 1
      };

      let mockQuerySql: Function = mocker.mockFunc(sysuiupdaterdbmanager.mNotificationRdbStore, sysuiupdaterdbmanager.mNotificationRdbStore.querySql);
      when(mockQuerySql)(ArgumentMatchers.anyString).afterThrow('Database error');

      const result = await sysuiupdaterdbmanager.queryNotificationEnableSetting();
      expect(result.length).assertEqual(1);
      expect(result[0].packageName).assertEqual('com.example.app');
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
      mocker.ignoreMock(sysuiupdaterdbmanager.mNotificationRdbStore, sysuiupdaterdbmanager.mNotificationRdbStore.querySql);
    });

    it('should_return_empty_list_when_query_returns_empty_result', 0, async () => {
      let sysuiupdaterdbmanager: SysUIUpdateRdbManager = new SysUIUpdateRdbManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockResultSet: relationalStore.ResultSet = new relationalStore.ResultSet();
      when(mockResultSet.goToFirstRow()).afterReturn(false);

      const result = await sysuiupdaterdbmanager.queryNotificationAppSetting();
      expect(result.length).assertEqual(0);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

    it('should_return_list_with_one_element_when_query_returns_one_row_result', 0, async () => {
      let sysuiupdaterdbmanager: SysUIUpdateRdbManager = new SysUIUpdateRdbManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockShowError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockResultSet: relationalStore.ResultSet = new relationalStore.ResultSet();
      when(mockResultSet.goToFirstRow()).afterReturn(true);
      when(mockResultSet.goToNextRow()).afterReturn(false);
      when(mockResultSet.getString(ArgumentMatchers.anyNumber)).afterReturn('bundle1', 'uid1', 'pinTop1');
      when(mockResultSet.getColumnIndex(ArgumentMatchers.anyString)).afterReturn(0, 1, 2);

      const result = await sysuiupdaterdbmanager.queryNotificationAppSetting();
      expect(result.length).assertEqual(1);
      expect(result[0].appBundle).assertEqual('bundle1');
      expect(result[0].uid).assertEqual('uid1');
      expect(result[0].pinTopEnable).assertEqual('pinTop1');

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(LogHelper, LogHelper.showError);
    });

  });
}
