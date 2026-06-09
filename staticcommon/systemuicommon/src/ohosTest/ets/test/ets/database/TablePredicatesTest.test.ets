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
import rdb from '@ohos.data.relationalStore';
import { Class } from '@ohos/frameworkwrapper/src/main/ets/base/CommonType';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { ITableEntity, ITableProps } from '../../../main/ets/database/TableModel';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { TablePredicates } from '../../../main/ets/database/TablePredicates';
export default function TablePredicatesTest() {
  describe('equalTo_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_rdbPredicates_isNull_when_value_is_undefined', 0, () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates("test");
      let mockIsNull: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.isNull);
      let mockEqualTo: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.equalTo);

      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let matchCondition: MatchCondition = new MatchCondition();
      matchCondition.equalTo = new Map([["field1", undefined]]);
      tablepredicates.equalTo(matchCondition);

      mocker.ignoreMock(rdbPredicates, rdbPredicates.isNull);
      mocker.ignoreMock(rdbPredicates, rdbPredicates.equalTo);
    });

    it('should_call_rdbPredicates_equalTo_when_value_is_defined', 0, () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates("test");
      let mockIsNull: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.isNull);
      let mockEqualTo: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.equalTo);

      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let matchCondition: MatchCondition = new MatchCondition();
      matchCondition.equalTo = new Map([["field1", "value1"]]);
      tablepredicates.equalTo(matchCondition);

      mocker.ignoreMock(rdbPredicates, rdbPredicates.isNull);
      mocker.ignoreMock(rdbPredicates, rdbPredicates.equalTo);
    });

    it('should_call_rdbPredicates_isNotNull_when_value_is_undefined', 0, () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates("test");
      let mockfuncIsNoNull: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.isNotNull);
      let mockfuncNotEqualTo: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.notEqualTo);

      when(mockfuncIsNoNull)(ArgumentMatchers.anyString).afterReturn(rdbPredicates);
      when(mockfuncNotEqualTo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(rdbPredicates);

      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let matchCondition: MatchCondition = new MatchCondition();
      matchCondition.condition = new Map([['field1', undefined]]);
      tablepredicates.notEqualTo(matchCondition);

      mocker.ignoreMock(rdbPredicates, rdbPredicates.isNotNull);
      mocker.ignoreMock(rdbPredicates, rdbPredicates.notEqualTo);
    });

    it('should_call_rdbPredicates_notEqualTo_when_value_is_not_undefined', 0, () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates("test");
      let mockfuncIsNoNull: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.isNotNull);
      let mockfuncNotEqualTo: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.notEqualTo);

      when(mockfuncIsNoNull)(ArgumentMatchers.anyString).afterReturn(rdbPredicates);
      when(mockfuncNotEqualTo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(rdbPredicates);

      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let matchCondition: MatchCondition = new MatchCondition();
      matchCondition.condition = new Map([['field1', 'value1']]);
      tablepredicates.notEqualTo(matchCondition);

      mocker.ignoreMock(rdbPredicates, rdbPredicates.isNotNull);
      mocker.ignoreMock(rdbPredicates, rdbPredicates.notEqualTo);
    });

    it('should_call_rdbPredicates_beginWrap_when_beginWrap_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates("test");
      let mockfunc: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.beginWrap);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(rdbPredicates);

      let tablepredicates: Class<TablePredicates> = TablePredicates.INSTANCE;
      let result = tablepredicates.beginWrap();

      expect(result).assertInstanceOf(TablePredicates);
      mocker.ignoreMock(rdbPredicates, rdbPredicates.beginWrap);
    });

    it('should_call_rdbPredicates_endWrap_when_endWrap_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates("test");
      let mockfunc: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.endWrap);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(rdbPredicates);

      let tablepredicates: Class<TablePredicates> = TablePredicates.INSTANCE;
      let result = tablepredicates.endWrap();

      expect(result).assertInstanceOf(TablePredicates);
      mocker.ignoreMock(rdbPredicates, rdbPredicates.endWrap);
    });

    it('should_call_rdbPredicates_and_return_this', 0, async () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates('test');
      let mockfunc: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.and);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(rdbPredicates);

      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let result = tablepredicates.and();

      expect(result).assertInstanceOf(TablePredicates);
      mocker.ignoreMock(rdbPredicates, rdbPredicates.and);
    });

    it('should_call_rdbPredicates_contains_when_condition_is_valid', 0, () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates("test");
      let mockfunc: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.contains);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(rdbPredicates);

      let predicates: TablePredicates = TablePredicates.INSTANCE;
      let matchCondition: MatchCondition = new MatchCondition();
      matchCondition.condition = new Map<string, string>();
      matchCondition.condition.set("field1", "value1");
      predicates.contains(matchCondition);

      mocker.ignoreMock(rdbPredicates, rdbPredicates.contains);
    });

    it('should_handle_null_condition', 0, () => {
      let predicates: TablePredicates = TablePredicates.INSTANCE;
      let result = predicates.contains(null);
      expect(result).assertInstanceOf(TablePredicates);
    });

    it('should_handle_empty_condition', 0, () => {
      let predicates: TablePredicates = TablePredicates.INSTANCE;
      let matchCondition: MatchCondition = new MatchCondition();
      matchCondition.condition = new Map<string, string>();
      let result = predicates.contains(matchCondition);
      expect(result).assertInstanceOf(TablePredicates);
    });

    it('should_call_rdbPredicates_beginsWith_when_condition_is_valid', 0, () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates("test");
      let mockfunc: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.beginsWith);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(rdbPredicates);

      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let matchCondition: MatchCondition = new MatchCondition();
      matchCondition.condition = new Map<string, string>();
      matchCondition.condition.set("field", "value");
      tablepredicates.beginsWith(matchCondition);

      mocker.ignoreMock(rdbPredicates, rdbPredicates.beginsWith);
    });

    it('should_not_call_rdbPredicates_beginsWith_when_condition_is_invalid', 0, () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates("test");
      let mockfunc: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.beginsWith);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(rdbPredicates);

      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let matchCondition: MatchCondition = new MatchCondition();
      matchCondition.condition = new Map<string, string>();
      matchCondition.condition.set("field", null);
      tablepredicates.beginsWith(matchCondition);

      mocker.ignoreMock(rdbPredicates, rdbPredicates.beginsWith);
    });

    it('should_call_rdbPredicates_endsWith_when_condition_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates('test');
      let mockfunc: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.endsWith);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(rdbPredicates);

      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let matchCondition: MatchCondition = new MatchCondition();
      matchCondition.condition = new Map<string, string>();
      matchCondition.condition.set('field1', 'value1');
      let result = tablepredicates.endsWith(matchCondition);

      mocker.ignoreMock(rdbPredicates, rdbPredicates.endsWith);
    });

    it('should_return_this_when_condition_is_null', 0, () => {
      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let result = tablepredicates.endsWith(null);
      expect(result).assertEqual(tablepredicates);
    });

    it('should_call_rdbPredicates_isNull_when_isUndefined_is_called', 0, () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates("test");
      let mockfunc: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.isNull);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(rdbPredicates);

      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let result = tablepredicates.isUndefined("testField");

      mocker.ignoreMock(rdbPredicates, rdbPredicates.isNull);
    });

    it('should_return_this_when_isUndefined_is_called', 0, () => {
      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let result = tablepredicates.isUndefined("testField");

      expect(result).assertInstanceOf(TablePredicates);
    });

    it('should_call_isNotNull_when_isDefined_is_called', 0, () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates("test");
      let mockfunc: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.isNotNull);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(rdbPredicates);

      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let result = tablepredicates.isDefined("testField");

      mocker.ignoreMock(rdbPredicates, rdbPredicates.isNotNull);
    });

    it('should_return_this_when_isDefined_is_called', 0, () => {
      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let result = tablepredicates.isDefined("testField");

      expect(result).assertInstanceOf(TablePredicates);
    });

    it('should_call_rdbPredicates_isNull_when_value_is_undefined', 0, () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates("test");
      let mockIsNull: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.isNull);
      let mockEqualTo: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.equalTo);

      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let matchCondition: MatchCondition = new MatchCondition();
      matchCondition.equalTo = new Map([["field1", undefined]]);
      tablepredicates.equalTo(matchCondition);

      mocker.ignoreMock(rdbPredicates, rdbPredicates.isNull);
      mocker.ignoreMock(rdbPredicates, rdbPredicates.equalTo);
    });

    it('should_call_rdbPredicates_equalTo_when_value_is_defined', 0, () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates("test");
      let mockIsNull: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.isNull);
      let mockEqualTo: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.equalTo);

      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let matchCondition: MatchCondition = new MatchCondition();
      matchCondition.equalTo = new Map([["field1", "value1"]]);
      tablepredicates.equalTo(matchCondition);

      mocker.ignoreMock(rdbPredicates, rdbPredicates.isNull);
      mocker.ignoreMock(rdbPredicates, rdbPredicates.equalTo);
    });

    it('should_call_rdbPredicates_isNotNull_when_value_is_undefined', 0, () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates("test");
      let mockfuncIsNoNull: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.isNotNull);
      let mockfuncNotEqualTo: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.notEqualTo);

      when(mockfuncIsNoNull)(ArgumentMatchers.anyString).afterReturn(rdbPredicates);
      when(mockfuncNotEqualTo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(rdbPredicates);

      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let matchCondition: MatchCondition = new MatchCondition();
      matchCondition.condition = new Map([['field1', undefined]]);
      tablepredicates.notEqualTo(matchCondition);

      mocker.ignoreMock(rdbPredicates, rdbPredicates.isNotNull);
      mocker.ignoreMock(rdbPredicates, rdbPredicates.notEqualTo);
    });

    it('should_call_rdbPredicates_notEqualTo_when_value_is_not_undefined', 0, () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates("test");
      let mockfuncIsNoNull: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.isNotNull);
      let mockfuncNotEqualTo: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.notEqualTo);

      when(mockfuncIsNoNull)(ArgumentMatchers.anyString).afterReturn(rdbPredicates);
      when(mockfuncNotEqualTo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturn(rdbPredicates);

      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let matchCondition: MatchCondition = new MatchCondition();
      matchCondition.condition = new Map([['field1', 'value1']]);
      tablepredicates.notEqualTo(matchCondition);

      mocker.ignoreMock(rdbPredicates, rdbPredicates.isNotNull);
      mocker.ignoreMock(rdbPredicates, rdbPredicates.notEqualTo);
    });

    it('should_call_rdbPredicates_beginWrap_when_beginWrap_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates("test");
      let mockfunc: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.beginWrap);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(rdbPredicates);

      let tablepredicates: Class<TablePredicates> = TablePredicates.INSTANCE;
      let result = tablepredicates.beginWrap();

      expect(result).assertInstanceOf(TablePredicates);
      mocker.ignoreMock(rdbPredicates, rdbPredicates.beginWrap);
    });

    it('should_call_rdbPredicates_endWrap_when_endWrap_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates("test");
      let mockfunc: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.endWrap);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(rdbPredicates);

      let tablepredicates: Class<TablePredicates> = TablePredicates.INSTANCE;
      let result = tablepredicates.endWrap();

      expect(result).assertInstanceOf(TablePredicates);
      mocker.ignoreMock(rdbPredicates, rdbPredicates.endWrap);
    });

    it('should_call_rdbPredicates_and_return_this', 0, async () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates('test');
      let mockfunc: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.and);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(rdbPredicates);

      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let result = tablepredicates.and();

      expect(result).assertInstanceOf(TablePredicates);
      mocker.ignoreMock(rdbPredicates, rdbPredicates.and);
    });

    it('should_call_rdbPredicates_contains_when_condition_is_valid', 0, () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates("test");
      let mockfunc: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.contains);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(rdbPredicates);

      let predicates: TablePredicates = TablePredicates.INSTANCE;
      let matchCondition: MatchCondition = new MatchCondition();
      matchCondition.condition = new Map<string, string>();
      matchCondition.condition.set("field1", "value1");
      predicates.contains(matchCondition);

      mocker.ignoreMock(rdbPredicates, rdbPredicates.contains);
    });

    it('should_handle_null_condition', 0, () => {
      let predicates: TablePredicates = TablePredicates.INSTANCE;
      let result = predicates.contains(null);
      expect(result).assertInstanceOf(TablePredicates);
    });

    it('should_handle_empty_condition', 0, () => {
      let predicates: TablePredicates = TablePredicates.INSTANCE;
      let matchCondition: MatchCondition = new MatchCondition();
      matchCondition.condition = new Map<string, string>();
      let result = predicates.contains(matchCondition);
      expect(result).assertInstanceOf(TablePredicates);
    });

    it('should_call_rdbPredicates_beginsWith_when_condition_is_valid', 0, () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates("test");
      let mockfunc: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.beginsWith);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(rdbPredicates);

      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let matchCondition: MatchCondition = new MatchCondition();
      matchCondition.condition = new Map<string, string>();
      matchCondition.condition.set("field", "value");
      tablepredicates.beginsWith(matchCondition);

      mocker.ignoreMock(rdbPredicates, rdbPredicates.beginsWith);
    });

    it('should_not_call_rdbPredicates_beginsWith_when_condition_is_invalid', 0, () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates("test");
      let mockfunc: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.beginsWith);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(rdbPredicates);

      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let matchCondition: MatchCondition = new MatchCondition();
      matchCondition.condition = new Map<string, string>();
      matchCondition.condition.set("field", null);
      tablepredicates.beginsWith(matchCondition);

      mocker.ignoreMock(rdbPredicates, rdbPredicates.beginsWith);
    });

    it('should_call_rdbPredicates_endsWith_when_condition_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates('test');
      let mockfunc: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.endsWith);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.anyString).afterReturn(rdbPredicates);

      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let matchCondition: MatchCondition = new MatchCondition();
      matchCondition.condition = new Map<string, string>();
      matchCondition.condition.set('field1', 'value1');
      let result = tablepredicates.endsWith(matchCondition);

      mocker.ignoreMock(rdbPredicates, rdbPredicates.endsWith);
    });

    it('should_return_this_when_condition_is_null', 0, () => {
      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let result = tablepredicates.endsWith(null);
      expect(result).assertEqual(tablepredicates);
    });

    it('should_call_rdbPredicates_isNull_when_isUndefined_is_called', 0, () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates("test");
      let mockfunc: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.isNull);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(rdbPredicates);

      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let result = tablepredicates.isUndefined("testField");

      mocker.ignoreMock(rdbPredicates, rdbPredicates.isNull);
    });

    it('should_return_this_when_isUndefined_is_called', 0, () => {
      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let result = tablepredicates.isUndefined("testField");

      expect(result).assertInstanceOf(TablePredicates);
    });

    it('should_call_isNotNull_when_isDefined_is_called', 0, () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates("test");
      let mockfunc: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.isNotNull);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(rdbPredicates);

      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let result = tablepredicates.isDefined("testField");

      mocker.ignoreMock(rdbPredicates, rdbPredicates.isNotNull);
    });

    it('should_return_this_when_isDefined_is_called', 0, () => {
      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let result = tablepredicates.isDefined("testField");

      expect(result).assertInstanceOf(TablePredicates);
    });
    it('should_return_this_when_isUndefined_is_called', 0, () => {
      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let result = tablepredicates.isUndefined("testField");

      expect(result).assertInstanceOf(TablePredicates);
    });

    it('should_call_isNotNull_when_isDefined_is_called', 0, () => {
      let mocker: MockKit = new MockKit();
      let rdbPredicates: rdb.RdbPredicates = new rdb.RdbPredicates("test");
      let mockfunc: Function = mocker.mockFunc(rdbPredicates, rdbPredicates.isNotNull);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(rdbPredicates);

      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let result = tablepredicates.isDefined("testField");

      mocker.ignoreMock(rdbPredicates, rdbPredicates.isNotNull);
    });

    it('should_return_this_when_isDefined_is_called', 0, () => {
      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let result = tablepredicates.isDefined("testField");

      expect(result).assertInstanceOf(TablePredicates);
    });

    it('should_return_this_when_isDefined_is_called', 0, () => {
      let tablepredicates: TablePredicates = TablePredicates.INSTANCE;
      let result = tablepredicates.isDefined("testField");

      expect(result).assertInstanceOf(TablePredicates);
    });
  });
}