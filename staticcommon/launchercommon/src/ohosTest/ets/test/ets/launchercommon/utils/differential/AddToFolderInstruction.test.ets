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
} from '@ohos/hypium'
import { CommonConstants, GridLayoutItemInfo } from '../../../../../../../main/ets/TsIndex'
import { AddToFolderInstruction } from '../../../../../../../main/ets/utils/differential/AddToFolderInstruction'

export default function AddToFolderInstructionTest() {
  describe('AddToFolderInstructionTest', () => {
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
    it('assertEqual', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'test'
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
    })

    it("realize1", 0, async (done: Function) => {
      let addToFolderInstruction: AddToFolderInstruction = new AddToFolderInstruction(6, 4);
      let result = addToFolderInstruction['realize'](null, null);
      expect(result).assertEqual(null);
      done();
    })

    it("realize2", 0, async (done: Function) => {
      let addToFolderInstruction: AddToFolderInstruction = new AddToFolderInstruction(6, 4);
      let gridInfoItem = {
        typeId: CommonConstants.TYPE_APP,
        area: [1, 2],
        addPosition: 'top'
      } as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(addToFolderInstruction, addToFolderInstruction['isTargetFolderExist']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let result = addToFolderInstruction['realize']([gridInfoItem], gridInfoItem);
      expect(result.length).assertEqual(1);
      mocker.clear(addToFolderInstruction);
      mocker.clearAll();
      done();
    })

    it("realize3", 0, async (done: Function) => {
      let addToFolderInstruction: AddToFolderInstruction = new AddToFolderInstruction(6, 4);
      let gridInfoItem = {
        typeId: CommonConstants.TYPE_APP,
        area: [1, 2],
        addPosition: 'top'
      } as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(addToFolderInstruction, addToFolderInstruction['isTargetFolderExist']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function =
        mocker.mockFunc(addToFolderInstruction, addToFolderInstruction['addToTop']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn({
        typeId: CommonConstants.TYPE_APP,
        area: [1, 2],
        addPosition: 'top'
      });
      let mockFunction2: Function =
        mocker.mockFunc(addToFolderInstruction, addToFolderInstruction['addToBottom']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn({
        typeId: CommonConstants.TYPE_APP,
        area: [1, 2],
        addPosition: 'bottom'
      });
      let result = addToFolderInstruction['realize']([gridInfoItem], gridInfoItem);
      expect(result.length).assertEqual(undefined);
      mocker.clear(addToFolderInstruction);
      mocker.clearAll();
      done();
    })

    it("addToTop1", 0, async (done: Function) => {
      let addToFolderInstruction: AddToFolderInstruction = new AddToFolderInstruction(6, 4);
      let gridInfoItem = {
        typeId: CommonConstants.TYPE_APP,
        area: [1, 2],
        addPosition: 'top',
        page: 0,
        row: 0,
        column: 0,
        container: 0,
        layoutInfo: [[{
          page: 0,
          row: 0,
          column: 0
        }]]
      } as GridLayoutItemInfo;
      let result = addToFolderInstruction['addToTop']([gridInfoItem],0,gridInfoItem);
      expect(result.length).assertEqual(1);
      done();
    })

    it("addToTop2", 0, async (done: Function) => {
      let addToFolderInstruction: AddToFolderInstruction = new AddToFolderInstruction(6, 4);
      let gridInfoItem = {
        typeId: CommonConstants.TYPE_APP,
        area: [1, 2],
        addPosition: 'top',
        page: 0,
        row: 0,
        column: 1,
        container: 0,
        layoutInfo: [[{
          page: 0,
          row: 0,
          column: 1
        }]]
      } as GridLayoutItemInfo;
      let result = addToFolderInstruction['addToTop']([gridInfoItem],0,gridInfoItem);
      expect(result.length).assertEqual(1);
      done();
    })

    it("addToTop3", 0, async (done: Function) => {
      let addToFolderInstruction: AddToFolderInstruction = new AddToFolderInstruction(6, 4);
      let gridInfoItem = {
        typeId: CommonConstants.TYPE_APP,
        area: [1, 2],
        addPosition: 'top',
        page: 10,
        row: 10,
        column: 10,
        container: 0,
        layoutInfo: [[{
          page: 10,
          row: 10,
          column: 10
        }]]
      } as GridLayoutItemInfo;
      let result = addToFolderInstruction['addToTop']([gridInfoItem],0,gridInfoItem);
      expect(result.length).assertEqual(1);
      done();
    })

    it("addToBottom", 0, async (done: Function) => {
      let addToFolderInstruction: AddToFolderInstruction = new AddToFolderInstruction(6, 4);
      let gridInfoItem = {
        typeId: CommonConstants.TYPE_APP,
        area: [1, 2],
        addPosition: 'top',
        page: 0,
        row: 0,
        column: 0,
        container: 0,
        layoutInfo: [[{
          page: 0,
          row: 0,
          column: 0
        }]]
      } as GridLayoutItemInfo;
      let result = addToFolderInstruction['addToBottom']([gridInfoItem],0,gridInfoItem);
      expect(result.length).assertEqual(1);
      done();
    })

    it("isTargetFolderExist1", 0, async (done: Function) => {
      let addToFolderInstruction: AddToFolderInstruction = new AddToFolderInstruction(6, 4);
      let gridInfoItem = {
        typeId: CommonConstants.TYPE_APP,
        area: [1, 2],
      } as GridLayoutItemInfo;
      let result = addToFolderInstruction['isTargetFolderExist'](gridInfoItem,gridInfoItem);
      expect(result).assertEqual(false);
      done();
    })

    it("isTargetFolderExist2", 0, async (done: Function) => {
      let addToFolderInstruction: AddToFolderInstruction = new AddToFolderInstruction(6, 4);
      let gridInfoItem = {
        typeId: CommonConstants.TYPE_APP,
        area: [1, 2],
        folderId:'folderId',
        targetFolderId:'targetFolderId'
      } as GridLayoutItemInfo;
      let result = addToFolderInstruction['isTargetFolderExist'](gridInfoItem,gridInfoItem);
      expect(result).assertEqual(false);
      done();
    })
  })
}