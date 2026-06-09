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
  ArgumentMatchers,
  when
} from '@ohos/hypium'
import { FolderDebug, FolderDebugParameter } from '../../../../../../../../main/ets/folder/dfx/debug/FolderDebug';
import { FolderData } from '../../../../../../../../main/ets/TsIndex';

export default function FolderDebugTest() {
  describe('FolderDebugTest', () => {
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
    it('test_getFolderItemsDesc', 0, () => {
      const folderData: FolderData = FolderData.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderData, folderData.getFolderItemsDesc);
      when(mockFunc)(ArgumentMatchers.any).afterReturn('1');
      const folderDebug: FolderDebug = FolderDebug.getInstance();
      let arrayStr: string[] = [];
      expect(folderDebug['getFolderItemsDesc'](arrayStr)).assertInstanceOf('String');
      arrayStr = ['1'];
      expect(folderDebug['getFolderItemsDesc'](arrayStr)).assertEqual('1');
      mocker.clear(folderData);
      mocker.clearAll();
    })

    it('test_listParameterWithCmd', 0, () => {
      const folderDebug: FolderDebug = FolderDebug.getInstance();
      let arrayStr: string[] = [];
      expect(folderDebug['listParameterWithCmd'](arrayStr)).assertInstanceOf('String');
      folderDebug['parameters'].forEach(item => {
        item.name = 'name_1';
      })
      expect(folderDebug['listParameterWithCmd'](arrayStr)).assertInstanceOf('String');
    })

    it('test_setParameterWithCmd', 0, () => {
      const folderDebug: FolderDebug = FolderDebug.getInstance();
      let arrayStr: string[] = [];
      expect(folderDebug['setParameterWithCmd'](arrayStr)).assertInstanceOf('String');
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderDebug, folderDebug['getParameterByName']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(null);
      arrayStr = ['1'];
      expect(folderDebug['setParameterWithCmd'](arrayStr)).assertInstanceOf('String');
      when(mockFunc)(ArgumentMatchers.any).afterReturn(folderDebug?.['parameters']?.[0]);
      expect(folderDebug['setParameterWithCmd'](arrayStr)).assertInstanceOf('String');
      mocker.clear(folderDebug);
      mocker.clearAll();
    })

    it('test_getParameterWithCmd', 0, () => {
      const folderDebug: FolderDebug = FolderDebug.getInstance();
      let arrayStr: string[] = [];
      expect(folderDebug['getParameterWithCmd'](arrayStr)).assertInstanceOf('String');
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderDebug, folderDebug['getParameterByName']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(null);
      arrayStr = ['1'];
      expect(folderDebug['getParameterWithCmd'](arrayStr)).assertInstanceOf('String');
      when(mockFunc)(ArgumentMatchers.any).afterReturn(folderDebug?.['parameters']?.[0]);
      expect(folderDebug['getParameterWithCmd'](arrayStr)).assertInstanceOf('String');
      mocker.clear(folderDebug);
      mocker.clearAll();
    })

    it('test_getParameterById', 0, () => {
      const folderDebug: FolderDebug = FolderDebug.getInstance();
      let arrayStr: string[] = [];
      folderDebug['getParameterById'](FolderDebugParameter.FOLDER_PARAM_START);
      expect(arrayStr.length).assertEqual(0);
    })

    it('test_getParameterByName', 0, () => {
      const folderDebug: FolderDebug = FolderDebug.getInstance();
      expect(folderDebug['getParameterByName']('100001')).assertNull();
      folderDebug['parameters'].forEach(item => {
        item.name = 'name_1';
      })
      expect(folderDebug['getParameterByName']('name_1')).not().assertUndefined();
    })
  })
}