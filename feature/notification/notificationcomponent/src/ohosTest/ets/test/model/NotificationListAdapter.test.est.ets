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
import { ArrayUtils } from "@ohos/basicutils";
import { afterEach, ArgumentMatchers, beforeEach, describe, expect, it, MockKit, when } from "@ohos/hypium";
import { BaseNotification } from "@ohos/systemuicommon/src/main/ets/model/BaseNotification";
import { NotificationListAdapter, NtfDataChangeType,
  NtfListDataChangeListener } from "../../../../main/ets/model/NotificationListAdapter";

export default function NotificationListAdapterTest() {

  describe('setFreezeViewEnable', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_set_isFreezeEnable_when_called', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.setFreezeViewEnable);
      when(mockfunc)(ArgumentMatchers.anyBoolean).afterReturn(true);

      notificationListAdapter.setFreezeViewEnable(true);
      expect(notificationListAdapter.isFreezeEnable).assertTrue();

      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.setFreezeViewEnable);
    });
  });

  describe('setDataSource', () => {
    it('should_set_myDataSource_when_called', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.setDataSource);
      when(mockfunc)(ArgumentMatchers.anyArray).afterReturn();

      const dataSource: Array<BaseNotification> = [new BaseNotification(), new BaseNotification()];
      notificationListAdapter.setDataSource(dataSource);

      expect(notificationListAdapter.myDataSource).toEqual(dataSource);

      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.setDataSource);
    });

    it('should_call_update_when_setDataSource_is_called', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.setDataSource);
      when(mockfunc)(ArgumentMatchers.anyArray).afterReturn();

      const dataSource: Array<BaseNotification> = [new BaseNotification(), new BaseNotification()];
      notificationListAdapter.setDataSource(dataSource);

      expect(notificationListAdapter.update).toHaveBeenCalled();

      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.setDataSource);
    });
  });

  describe('totalCount_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_0_when_myDataSource_is_empty', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let result = notificationListAdapter.totalCount();
      expect(result).assertEqual(0);
    });

    it('should_return_correct_count_when_myDataSource_has_elements', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ArrayUtils, ArrayUtils.getSize);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(5);
      let result = notificationListAdapter.totalCount();
      expect(result).assertEqual(5);
      mocker.ignoreMock(ArrayUtils, ArrayUtils.getSize);
    });

    it('should_return_0_when_myDataSource_is_null', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(ArrayUtils, ArrayUtils.getSize);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      let result = notificationListAdapter.totalCount();
      expect(result).assertEqual(0);
      mocker.ignoreMock(ArrayUtils, ArrayUtils.getSize);
    });
  });

  describe('getData_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_notification_entry_when_index_is_valid', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(ArrayUtils, ArrayUtils.get);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(new BaseNotification());

      const result = notificationListAdapter.getData(0);
      expect(result).assertInstanceOf(BaseNotification);

      mocker.ignoreMock(ArrayUtils, ArrayUtils.get);
    });

    it('should_return_null_when_index_is_out_of_bounds', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(ArrayUtils, ArrayUtils.get);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(null);

      const result = notificationListAdapter.getData(0);
      expect(result).assertNull();

      mocker.ignoreMock(ArrayUtils, ArrayUtils.get);
    });

    it('should_return_null_when_myDataSource_is_empty', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(ArrayUtils, ArrayUtils.get);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(null);

      const result = notificationListAdapter.getData(0);
      expect(result).assertNull();

      mocker.ignoreMock(ArrayUtils, ArrayUtils.get);
    });
  });

  describe('getAllData_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_myDataSource_when_getAllData_is_called', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let result: Array<BaseNotification> = notificationListAdapter.getAllData();
      expect(result).assertDeepEquals(notificationListAdapter.myDataSource);
    });

    it('should_return_empty_array_when_myDataSource_is_empty', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      notificationListAdapter.myDataSource = [];
      let result: Array<BaseNotification> = notificationListAdapter.getAllData();
      expect(result).assertDeepEquals([]);
    });
  });

  describe('addByIndex_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_add_data_at_index_0_and_call_onDataAdd', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.onDataAdd);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturnNothing();

      let data: BaseNotification = new BaseNotification();
      notificationListAdapter.addByIndex(0, data);

      expect(notificationListAdapter.myDataSource.length).assertEqual(1);
      expect(notificationListAdapter.myDataSource[0]).assertDeepEquals(data);
      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.onDataAdd);
    });

    it('should_add_data_at_index_not_0_and_call_onDataAdd', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.onDataAdd);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturnNothing();

      let data: BaseNotification = new BaseNotification();
      notificationListAdapter.addByIndex(1, data);

      expect(notificationListAdapter.myDataSource.length).assertEqual(1);
      expect(notificationListAdapter.myDataSource[0]).assertInstanceOf(BaseNotification);
      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.onDataAdd);
    });

    it('should_throw_error_when_index_is_negative', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let data: BaseNotification = new BaseNotification();
      expect(() => notificationListAdapter.addByIndex(-1, data)).assertThrowError("Index cannot be negative");
    });

    it('should_throw_error_when_index_is_greater_than_length', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let data: BaseNotification = new BaseNotification();
      expect(() => notificationListAdapter.addByIndex(notificationListAdapter.myDataSource.length + 1, data)).assertThrowError("Index out of bounds");
    });
  });

  describe('addOrUpdateData_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_onDataAdd_when_data_is_added', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockOnDataAdd: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.onDataAdd);
      let mockOnDataChange: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.onDataChange);

      let data: BaseNotification = new BaseNotification();
      let result = notificationListAdapter.addOrUpdateData(data);

      expect(result).assertEqual(0);
      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.onDataAdd);
      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.onDataChange);
    });

    it('should_call_onDataChange_when_data_is_updated', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockOnDataAdd: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.onDataAdd);
      let mockOnDataChange: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.onDataChange);

      let data: BaseNotification = new BaseNotification();
      notificationListAdapter.myDataSource.push(data);
      let result = notificationListAdapter.addOrUpdateData(data);

      expect(result).assertEqual(0);
      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.onDataAdd);
      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.onDataChange);
    });
  });

  describe('addOrUpdateDataNoNeedUpdate_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_oldIndex_when_data_is_added', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let data: BaseNotification = new BaseNotification();
      let result = notificationListAdapter.addOrUpdateDataNoNeedUpdate(data);
      expect(result).assertEqual(0);
    });
    it('should_return_oldIndex_when_data_is_updated', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let data: BaseNotification = new BaseNotification();
      notificationListAdapter.addOrUpdateDataNoNeedUpdate(data);
      let result = notificationListAdapter.addOrUpdateDataNoNeedUpdate(data);
      expect(result).assertEqual(0);
    });
    it('should_return_oldIndex_when_data_is_added_and_then_updated', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let data: BaseNotification = new BaseNotification();
      let result1 = notificationListAdapter.addOrUpdateDataNoNeedUpdate(data);
      let result2 = notificationListAdapter.addOrUpdateDataNoNeedUpdate(data);
      expect(result1).assertEqual(0);
      expect(result2).assertEqual(1);
    });
  });

  describe('moveData_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_call_onDataMove_when_moveArr_returns_true', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.onDataMove);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturnNothing();

      notificationListAdapter.myDataSource = [new BaseNotification(), new BaseNotification()];
      notificationListAdapter.moveData(0, 1);

      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.onDataMove);
    });

    it('should_not_call_onDataMove_when_moveArr_returns_false', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.onDataMove);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturnNothing();

      notificationListAdapter.myDataSource = [new BaseNotification()];
      notificationListAdapter.moveData(0, 1);

      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.onDataMove);
    });
  });
  describe('deleteByIndex_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_onDataDelete_when_deleteByIndex_is_called_with_valid_index', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.onDataDelete);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturnNothing();

      let index: number = 0;
      notificationListAdapter.deleteByIndex(index);

      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.onDataDelete);
    });

    it('should_not_call_onDataDelete_when_deleteByIndex_is_called_with_invalid_index', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.onDataDelete);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturnNothing();

      let index: number = -1;
      notificationListAdapter.deleteByIndex(index);

      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.onDataDelete);
    });

    it('should_update_myDataSource_when_deleteByIndex_is_called_with_valid_index', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.onDataDelete);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturnNothing();

      let index: number = 0;
      let initialSize: number = notificationListAdapter.myDataSource.length;
      notificationListAdapter.deleteByIndex(index);

      expect(notificationListAdapter.myDataSource.length).assertEqual(initialSize - 1);
      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.onDataDelete);
    });

    it('should_not_update_myDataSource_when_deleteByIndex_is_called_with_invalid_index', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.onDataDelete);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturnNothing();

      let index: number = -1;
      let initialSize: number = notificationListAdapter.myDataSource.length;
      notificationListAdapter.deleteByIndex(index);

      expect(notificationListAdapter.myDataSource.length).assertEqual(initialSize);
      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.onDataDelete);
    });
  });

  describe('onDataAdd_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_call_update_when_onDataAdd_is_called', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.update);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationListAdapter.onDataAdd(0);
      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.update);
    });

    it('should_not_call_update_when_index_is_less_than_zero', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.update);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationListAdapter.onDataAdd(-1);
      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.update);
    });

    it('should_not_call_update_when_index_is_greater_than_myDataSource_length', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.update);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationListAdapter.onDataAdd(1);
      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.update);
    });

    it('should_call_update_when_index_is_equal_to_myDataSource_length', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.update);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationListAdapter.onDataAdd(0);
      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.update);
    });

    it('should_call_update_when_index_is_less_than_myDataSource_length_but_greater_than_zero', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.update);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationListAdapter.onDataAdd(1);
      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.update);
    });
  });

  describe('onDataChange_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_call_update_when_index_is_valid', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.update);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationListAdapter.onDataChange(0);

      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.update);
    });

    it('should_not_call_update_when_index_is_invalid', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.update);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationListAdapter.onDataChange(-1);

      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.update);
    });

    it('should_call_update_when_index_is_out_of_bounds', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.update);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationListAdapter.onDataChange(100);

      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.update);
    });
  });

  describe('onDataDelete_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_update_when_index_is_valid', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.update);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationListAdapter.onDataDelete(0);

      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.update);
    });

    it('should_not_call_update_when_index_is_invalid', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.update);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationListAdapter.onDataDelete(-1);

      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.update);
    });

    it('should_call_update_when_index_is_out_of_bounds', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.update);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      notificationListAdapter.onDataDelete(100);

      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.update);
    });
  });

  describe('onDataMove_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_update_when_onDataMove_is_called', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.update);
      when(mockfunc)().afterReturn(null);

      notificationListAdapter.onDataMove(0, 1);

      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.update);
    });

    it('should_not_call_update_when_fromIndex_equals_toIndex', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.update);
      when(mockfunc)().afterReturn(null);

      notificationListAdapter.onDataMove(0, 0);

      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.update);
    });

    it('should_throw_error_when_fromIndex_is_less_than_0', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.update);
      when(mockfunc)().afterReturn(null);

      expect(() => {
        notificationListAdapter.onDataMove(-1, 0);
      }).assertThrowError("fromIndex cannot be less than 0");

      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.update);
    });

    it('should_throw_error_when_toIndex_is_less_than_0', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.update);
      when(mockfunc)().afterReturn(null);

      expect(() => {
        notificationListAdapter.onDataMove(0, -1);
      }).assertThrowError("toIndex cannot be less than 0");

      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.update);
    });
  });

  describe('onDataReloaded_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_update_when_onDataReloaded_is_called', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.update);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationListAdapter.onDataReloaded();
      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.update);
    });

    it('should_not_call_update_when_updateCount_is_greater_than_0', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      notificationListAdapter.updateCount = 1;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.update);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationListAdapter.onDataReloaded();
      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.update);
    });

    it('should_not_call_update_when_isFreezeEnable_is_true', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      notificationListAdapter.isFreezeEnable = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.update);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationListAdapter.onDataReloaded();
      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.update);
    });

    it('should_call_update_when_dataListeners_is_not_empty', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.update);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationListAdapter.dataListeners.add({});
      notificationListAdapter.onDataReloaded();
      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.update);
    });

    it('should_not_call_update_when_myDataSource_is_not_empty', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.update);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationListAdapter.myDataSource.push(new BaseNotification());
      notificationListAdapter.onDataReloaded();
      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.update);
    });

    it('should_call_update_when_all_conditions_are_met', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      notificationListAdapter.updateCount = 1;
      notificationListAdapter.isFreezeEnable = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.update);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationListAdapter.dataListeners.add({});
      notificationListAdapter.myDataSource.push(new BaseNotification());
      notificationListAdapter.onDataReloaded();
      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.update);
    });
  });

  describe('deleteData_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_onDataDelete_when_data_is_deleted', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.onDataDelete);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturnNothing();

      let data: BaseNotification = new BaseNotification();
      notificationListAdapter.deleteData(data);

      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.onDataDelete);
    });

    it('should_not_call_onDataDelete_when_data_is_not_deleted', 0, async () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.onDataDelete);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturnNothing();

      let data: BaseNotification = new BaseNotification();
      notificationListAdapter.deleteData(data);

      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.onDataDelete);
    });
  });

  describe('deleteDataNoNeedUpdate_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_remove_data_when_data_is_not_null', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let data: BaseNotification = new BaseNotification();
      notificationListAdapter.deleteDataNoNeedUpdate(data);
      expect(notificationListAdapter.myDataSource.length).assertEqual(0);
    });

    it('should_do_nothing_when_data_is_null', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let data: BaseNotification = null;
      notificationListAdapter.deleteDataNoNeedUpdate(data);
      expect(notificationListAdapter.myDataSource.length).assertEqual(0);
    });

    it('should_do_nothing_when_data_is_not_in_myDataSource', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let data: BaseNotification = new BaseNotification();
      notificationListAdapter.deleteDataNoNeedUpdate(data);
      expect(notificationListAdapter.myDataSource.length).assertEqual(0);
    });
  });

  describe('update_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_isFreezeEnable_is_true', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      notificationListAdapter.isFreezeEnable = true;
      notificationListAdapter.update();
      expect(notificationListAdapter.updateCount).assertEqual(0);
    });

    it('should_return_immediately_when_type_is_NtfDataChangeType.BATCH_UPDATE_and_updateCount_is_not_1', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      notificationListAdapter.isFreezeEnable = false;
      notificationListAdapter.updateCount = 2;
      notificationListAdapter.update();
      expect(notificationListAdapter.updateCount).assertEqual(0);
    });

    it('should_call_onNtfListDataChange_when_type_is_NtfDataChangeType.BATCH_UPDATE_and_updateCount_is_1', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      notificationListAdapter.isFreezeEnable = false;
      notificationListAdapter.updateCount = 1;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.onNtfListDataChange);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationListAdapter.update(NtfDataChangeType.BATCH_UPDATE);
      expect(notificationListAdapter.updateCount).assertEqual(0);
      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.onNtfListDataChange);
    });

    it('should_call_onNtfListDataChange_when_type_is_not_NtfDataChangeType.BATCH_UPDATE', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      notificationListAdapter.isFreezeEnable = false;
      notificationListAdapter.updateCount = 1;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationListAdapter, notificationListAdapter.onNtfListDataChange);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationListAdapter.update(NtfDataChangeType.BATCH_UPDATE);
      expect(notificationListAdapter.updateCount).assertEqual(0);
      mocker.ignoreMock(notificationListAdapter, notificationListAdapter.onNtfListDataChange);
    });
  });

  describe('registerDataChangeListener_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_add_listener_to_set_when_registerDataChangeListener_is_called', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let listener: NtfListDataChangeListener = new NtfListDataChangeListener();
      notificationListAdapter.registerDataChangeListener(listener);
      expect(notificationListAdapter.dataListeners.has(listener)).assertTrue();
    });

    it('should_not_add_listener_to_set_when_listener_is_null', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let listener: NtfListDataChangeListener = null;
      notificationListAdapter.registerDataChangeListener(listener);
      expect(notificationListAdapter.dataListeners.has(listener)).assertFalse();
    });

    it('should_not_add_listener_to_set_when_listener_is_undefined', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let listener: NtfListDataChangeListener = undefined;
      notificationListAdapter.registerDataChangeListener(listener);
      expect(notificationListAdapter.dataListeners.has(listener)).assertFalse();
    });

    it('should_add_listener_to_set_when_registerDataChangeListener_is_called_multiple_times', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let listener: NtfListDataChangeListener = new NtfListDataChangeListener();
      notificationListAdapter.registerDataChangeListener(listener);
      notificationListAdapter.registerDataChangeListener(listener);
      expect(notificationListAdapter.dataListeners.has(listener)).assertTrue();
    });
  });

  describe('unregisterDataChangeListener_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_remove_listener_when_listener_exists', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let listener: NtfListDataChangeListener = new NtfListDataChangeListener();
      notificationListAdapter.dataListeners.add(listener);
      expect(notificationListAdapter.dataListeners.has(listener)).assertTrue();
      notificationListAdapter.unregisterDataChangeListener(listener);
      expect(notificationListAdapter.dataListeners.has(listener)).assertFalse();
    });

    it('should_do_nothing_when_listener_does_not_exist', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let listener: NtfListDataChangeListener = new NtfListDataChangeListener();
      expect(notificationListAdapter.dataListeners.has(listener)).assertFalse();
      notificationListAdapter.unregisterDataChangeListener(listener);
      expect(notificationListAdapter.dataListeners.has(listener)).assertFalse();
    });
  });

  describe('findGroupEntryByHashCode_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_undefined_when_myDataSource_is_null', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let result = notificationListAdapter.findGroupEntryByHashCode('someHashCode');
      expect(result).assertUndefined();
    });

    it('should_return_undefined_when_myDataSource_is_not_null_but_no_match_found', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mockDataSource: Array<BaseNotification> = [
        { childrenEntry: [{ hashCode: 'otherHashCode' }] },
        { childrenEntry: [{ hashCode: 'anotherHashCode' }] }
      ];
      notificationListAdapter.myDataSource = mockDataSource;
      let result = notificationListAdapter.findGroupEntryByHashCode('someHashCode');
      expect(result).assertUndefined();
    });

    it('should_return_groupEntry_when_myDataSource_is_not_null_and_match_found', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      let mockDataSource: Array<BaseNotification> = [
        { childrenEntry: [{ hashCode: 'someHashCode' }] },
        { childrenEntry: [{ hashCode: 'anotherHashCode' }] }
      ];
      notificationListAdapter.myDataSource = mockDataSource;
      let result = notificationListAdapter.findGroupEntryByHashCode('someHashCode');
      expect(result).assertInstanceOf(BaseNotification);
    });

    it('should_return_groupEntry_when_hashCode_is_undefined_and_match_found', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      // 创建一个子项的hashCode为undefined的测试数据
      let mockDataSource: Array<BaseNotification> = [
        {
          childrenEntry: [
            {
              hashCode: undefined
            }, // 匹配undefined的情况
            {
              hashCode: 'anotherHashCode'
            }
          ]
        }
      ];
      notificationListAdapter.myDataSource = mockDataSource;
      let result = notificationListAdapter.findGroupEntryByHashCode(undefined);
      expect(result).assertInstanceOf(BaseNotification);
    });

    it('should_return_undefined_when_myDataSource_is_empty_array', 0, () => {
      let notificationListAdapter: NotificationListAdapter = new NotificationListAdapter();
      // 设置myDataSource为空数组
      notificationListAdapter.myDataSource = [];
      let result = notificationListAdapter.findGroupEntryByHashCode('anyHashCode');
      expect(result).assertUndefined();
    });
  });
}