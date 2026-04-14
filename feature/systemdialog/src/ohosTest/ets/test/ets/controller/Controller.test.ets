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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import SystemDialogController from '../../../../../main/ets/controller/Controller';
import { SysDialogZOrder } from '../../../../../main/ets/common/Constants';
import { ISystemDialogData } from '../../../../../main/ets/common/DialogDataEvent';

export default function SystemDialogControllerTest() {
  const systemDialogController = new SystemDialogController();

  describe('SystemDialogControllerTest', () => {
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

    it('getInstance', 0, () => {
      const ins = SystemDialogController.getInstance();

      expect(ins instanceof SystemDialogController).assertTrue();
    })

    it('getContext', 0, () => {
      const context = systemDialogController.getContext();

      expect((systemDialogController as object)['context']).assertEqual(context);
    })

    it('setContext', 0, () => {
      const context = systemDialogController.getContext();

      systemDialogController.setContext(context);

      expect((systemDialogController as object)['context']).assertEqual(context);
    })

    it('getList_01', 0, () => {
      const list = systemDialogController.getList(SysDialogZOrder.DEFAULT);

      expect((systemDialogController as object)['defaultList']).assertEqual(list);
    })

    it('getList_02', 0, () => {
      const list = systemDialogController.getList(SysDialogZOrder.UPPER);

      expect((systemDialogController as object)['upperList']).assertEqual(list);
    })

    it('isAllListEmpty', 0, () => {
      const defaultList: Array<ISystemDialogData> = (systemDialogController as object)['defaultList'];
      const upperList: Array<ISystemDialogData> = (systemDialogController as object)['upperList'];
      const res: boolean = defaultList.length === 0 && upperList.length === 0;

      expect(systemDialogController.isAllListEmpty()).assertEqual(res);
    })

    it('getData', 0, () => {
      const data = systemDialogController.getData();

      expect((systemDialogController as object)['data']).assertEqual(data);
    })

    it('destroy', 0, () => {
      systemDialogController.destroy();

      const context = systemDialogController.getContext();

      expect(context).assertNull();
    })

    it('filterListByKey001', 0, () => {
      const list = systemDialogController.filterListByKey([], 'disableUpGesture', 0);
      const len = list?.length;
      expect(len).assertEqual(0);
    })

    it('filterListByKey002', 0, () => {
      const list = systemDialogController.filterListByKey([], 'isEnableRotate', 0);
      const len = list?.length;
      expect(len).assertEqual(0);
    })


    it('filterListByKey003', 0, () => {
      const list = systemDialogController.filterListByKey([], 'isEnableStatusBarGesture', 0);
      const len = list?.length;
      expect(len).assertEqual(0);
    })

    it('filterListByKey004', 0, () => {
      const list = systemDialogController.filterListByKey([], 'isEnableBackGesture', 0);
      const len = list?.length;
      expect(len).assertEqual(0);
    })


    it('getSysDialogStatus', 0, () => {
      const status = systemDialogController.getSysDialogStatus();
      expect(status).assertEqual(Boolean);
    })
    it('getStatusByScreenId', 0, () => {
      const status = systemDialogController.getStatusByScreenId(0);
      expect(status).assertEqual(Boolean);
    })

    it('setSysDialogStatus', 0, () => {
      systemDialogController.setSysDialogStatus(false);
      const status = systemDialogController.getSysDialogStatus();
      expect(status).assertEqual(false);
    })

    it('setStatusByScreenId', 0, () => {
      systemDialogController.setStatusByScreenId(0, false);
      const status = systemDialogController.getStatusByScreenId(0);
      expect(status).assertEqual(false);
    })



  })
}