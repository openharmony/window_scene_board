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

import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import {
  MultiSelectCheckboxViewModel
} from '../../../../../../../main/ets/editmode/viewModel/MultiSelectCheckboxViewModel';
import { CheckboxParentEnum } from '../../../../../../../main/ets/TsIndex';
import { CheckboxCheckState, MultiSelectStatus } from '../../../../../../../main/ets/editmode/data/MultiSelectData';


export function MultiSelectCheckboxViewModelTest() {
  describe('MultiSelectCheckboxViewModelTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })
    it('test_getMultiSelectBelongId_01', 0, () => {
      const multiSelectCheckboxViewModel = new MultiSelectCheckboxViewModel();
      let parentType: CheckboxParentEnum = CheckboxParentEnum.AppInFolder;
      let res: object = (multiSelectCheckboxViewModel as object)['getMultiSelectBelongId'](parentType)
      expect(res !== null).assertTrue()
    })

    it('test_getMultiSelectBelongId_02', 0, () => {
      const multiSelectCheckboxViewModel = new MultiSelectCheckboxViewModel();
      let parentType: CheckboxParentEnum = CheckboxParentEnum.App;
      let res: object = (multiSelectCheckboxViewModel as object)['getMultiSelectBelongId'](parentType)
      expect(res === undefined).assertTrue()
    })

    it('test_getShowStatus_01', 0, () => {
      const multiSelectCheckboxViewModel = new MultiSelectCheckboxViewModel();
      (multiSelectCheckboxViewModel as object)['checkboxInfo']['parentType'] = CheckboxParentEnum.Folder
      let res: object = (multiSelectCheckboxViewModel as object)['getShowStatus']()
      expect(res !== null).assertTrue()
    })

    it('test_getShowStatus_02', 0, () => {
      const multiSelectCheckboxViewModel = new MultiSelectCheckboxViewModel();
      (multiSelectCheckboxViewModel as object)['checkboxInfo']['parentType'] = CheckboxParentEnum.AppInFolder
      let res: object = (multiSelectCheckboxViewModel as object)['getShowStatus']()
      expect(res !== null).assertTrue()
    })

    it('test_getShowStatus_03', 0, () => {
      const multiSelectCheckboxViewModel = new MultiSelectCheckboxViewModel();
      (multiSelectCheckboxViewModel as object)['checkboxInfo']['parentType'] = CheckboxParentEnum.App
      let res: object = (multiSelectCheckboxViewModel as object)['getShowStatus']()
      expect(res !== null).assertTrue()
    })

    it('test_setShow_01', 0, () => {
      const multiSelectCheckboxViewModel = new MultiSelectCheckboxViewModel();
      (multiSelectCheckboxViewModel as object)['checkboxViewState']['show'] = false;
      let res: object = (multiSelectCheckboxViewModel as object)['setShow'](true, true)
      expect(res !== null).assertTrue()
    })

    it('test_setShow_02', 0, () => {
      const multiSelectCheckboxViewModel = new MultiSelectCheckboxViewModel();
      (multiSelectCheckboxViewModel as object)['checkboxViewState']['show'] = true;
      let res: object = (multiSelectCheckboxViewModel as object)['setShow'](true, false)
      expect(res !== null).assertTrue()
    })

    it('test_setShow_03', 0, () => {
      const multiSelectCheckboxViewModel = new MultiSelectCheckboxViewModel();
      (multiSelectCheckboxViewModel as object)['checkboxViewState']['show'] = false;
      let res: object = (multiSelectCheckboxViewModel as object)['setShow'](true, false)
      expect(res !== null).assertTrue()
    })

    it('test_setShow_04', 0, () => {
      const multiSelectCheckboxViewModel = new MultiSelectCheckboxViewModel();
      (multiSelectCheckboxViewModel as object)['checkboxViewState']['show'] = false;
      let res: object = (multiSelectCheckboxViewModel as object)['setShow'](false, true)
      expect(res !== null).assertTrue()
    })

    it('test_setShow_05', 0, () => {
      const multiSelectCheckboxViewModel = new MultiSelectCheckboxViewModel();
      (multiSelectCheckboxViewModel as object)['checkboxViewState']['show'] = false;
      let res: object = (multiSelectCheckboxViewModel as object)['setShow'](false, false)
      expect(res !== null).assertTrue()
    })

    it('test_getCheckedStatus_01', 0, () => {
      const multiSelectCheckboxViewModel = new MultiSelectCheckboxViewModel();
      const checkboxCheckState = new CheckboxCheckState();
      (checkboxCheckState as object)['state'] = 1
      const multiSelectStatus = new MultiSelectStatus();
      (multiSelectStatus as object)['status'] = 1
      let res: boolean = (multiSelectCheckboxViewModel as object)['getCheckedStatus']
      expect(res !== null).assertTrue()
    })

    it('test_getCheckedStatus_02', 0, () => {
      const multiSelectCheckboxViewModel = new MultiSelectCheckboxViewModel();
      const checkboxCheckState = new CheckboxCheckState();
      (checkboxCheckState as object)['state'] = 0
      const multiSelectStatus = new MultiSelectStatus();
      (multiSelectStatus as object)['status'] = 0
      let res: boolean = (multiSelectCheckboxViewModel as object)['getCheckedStatus']
      expect(res !== null).assertTrue()
    })

    it('test_getCheckedStatus_03', 0, () => {
      const multiSelectCheckboxViewModel = new MultiSelectCheckboxViewModel();
      const checkboxCheckState = new CheckboxCheckState();
      (checkboxCheckState as object)['state'] = 1
      const multiSelectStatus = new MultiSelectStatus();
      (multiSelectStatus as object)['status'] = 0
      let res: boolean = (multiSelectCheckboxViewModel as object)['getCheckedStatus']
      expect(res !== null).assertTrue()
    })

    it('test_getCheckedStatus_04', 0, () => {
      const multiSelectCheckboxViewModel = new MultiSelectCheckboxViewModel();
      const checkboxCheckState = new CheckboxCheckState();
      (checkboxCheckState as object)['state'] = 0
      const multiSelectStatus = new MultiSelectStatus();
      (multiSelectStatus as object)['status'] = 1
      let res: boolean = (multiSelectCheckboxViewModel as object)['getCheckedStatus']
      expect(res !== null).assertTrue()
    })

    it('test_updateCheckboxViewState_01', 0, () => {
      const multiSelectCheckboxViewModel = new MultiSelectCheckboxViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc((multiSelectCheckboxViewModel as object),
        (multiSelectCheckboxViewModel as object)['getShowStatus']);
      when(mockFunc)().afterReturn(true);
      let res: void = (multiSelectCheckboxViewModel as object)['updateCheckboxViewState'](true)
      expect(res !== null).assertTrue()
      mocker.ignoreMock((multiSelectCheckboxViewModel as object),
        (multiSelectCheckboxViewModel as object)['getShowStatus']);
      mocker.clearAll();
    })

    it('test_updateCheckboxViewState_02', 0, () => {
      const multiSelectCheckboxViewModel = new MultiSelectCheckboxViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc((multiSelectCheckboxViewModel as object),
        (multiSelectCheckboxViewModel as object)['getShowStatus']);
      when(mockFunc)().afterReturn(false);
      let res: void = (multiSelectCheckboxViewModel as object)['updateCheckboxViewState'](true)
      expect(res !== null).assertTrue()
      mocker.ignoreMock((multiSelectCheckboxViewModel as object),
        (multiSelectCheckboxViewModel as object)['getShowStatus']);
      mocker.clearAll();
    })

    it('test_updateCheckboxViewState_03', 0, () => {
      const multiSelectCheckboxViewModel = new MultiSelectCheckboxViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc((multiSelectCheckboxViewModel as object),
        (multiSelectCheckboxViewModel as object)['getShowStatus']);
      when(mockFunc)().afterReturn(true);
      let res: void = (multiSelectCheckboxViewModel as object)['updateCheckboxViewState'](false)
      expect(res !== null).assertTrue()
      mocker.ignoreMock((multiSelectCheckboxViewModel as object),
        (multiSelectCheckboxViewModel as object)['getShowStatus']);
      mocker.clearAll();
    })

    it('test_updateCheckboxViewState_04', 0, () => {
      const multiSelectCheckboxViewModel = new MultiSelectCheckboxViewModel();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc((multiSelectCheckboxViewModel as object),
        (multiSelectCheckboxViewModel as object)['getShowStatus']);
      when(mockFunc)().afterReturn(false);
      let res: void = (multiSelectCheckboxViewModel as object)['updateCheckboxViewState'](false)
      expect(res !== null).assertTrue()
      mocker.ignoreMock((multiSelectCheckboxViewModel as object),
        (multiSelectCheckboxViewModel as object)['getShowStatus']);
      mocker.clearAll();
    })
  })
}