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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit,
  ArgumentMatchers,
  when} from '@ohos/hypium'
import { FolderOpenSwipingState } from '../../../../../../../main/ets/folder/state/FolderOpenSwipingState'
import { FolderDataModelManager } from '../../../../../../../main/ets/folder/model/FolderDataModelManager'
export default function FolderOpenSwipingStateTest() {
  describe('FolderOpenSwipingStateTest', () => {
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

    it('test_clickCloseSmallFolder_01', 0, () => {
      let instance: FolderOpenSwipingState = new FolderOpenSwipingState();
      let folderId: string = 'folderId_00';
      let folderDataModelManager: FolderDataModelManager = FolderDataModelManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderDataModelManager, folderDataModelManager.isRegisteredFolderId);
      when(mockFunc)(ArgumentMatchers).afterReturn(false);
      instance.clickCloseSmallFolder(folderId);
      expect(instance).not().assertNull();
      mocker.clear(folderDataModelManager);
      mocker.clearAll();
    });

    it('test_clickCloseSmallFolder_02', 0, () => {
      let instance: FolderOpenSwipingState = new FolderOpenSwipingState();
      let folderId: string = 'lkqkw4s76q0592qwa4g';
      let folderDataModelManager: FolderDataModelManager = FolderDataModelManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderDataModelManager, folderDataModelManager.isRegisteredFolderId);
      when(mockFunc)(ArgumentMatchers).afterReturn(true);
      instance.clickCloseSmallFolder(folderId);
      expect(instance).not().assertNull();
      mocker.clear(folderDataModelManager);
      mocker.clearAll();
    });

  })
}