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

import { DragGridItem, DragGridParam, DragGridPosition, DragPosition } from '@ohos/componentdrag'
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
import { FolderGridPositionHelp, FolderGridPositionHook } from '../../../../../../../main/ets/TsIndex';

export default function FolderGridPositionHelpTest() {
  describe('FolderGridPositionHelpTest', () => {
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

    it('test_getPositionByRowCol1', 0, () => {
      const mocker: MockKit = new MockKit();
      const folderGridPositionHelp = new FolderGridPositionHelp();
      const dragPosition: DragPosition = {
        x: 1, y: 1
      };
      const getFolderPositionUtil =
        mocker.mockFunc(folderGridPositionHelp, folderGridPositionHelp['getFolderPositionUtil']);
      when(getFolderPositionUtil)(ArgumentMatchers.any).afterReturn({
        getPosition: (_: DragGridPosition) => dragPosition,
        getCenterPosition: (_: DragGridItem) => dragPosition
      });
      expect(folderGridPositionHelp.getPositionByRowCol('folderId', 100, 100)).not().assertNull();
      mocker.clear(folderGridPositionHelp);
      mocker.clearAll();
    })

    it('test_getPositionByRowCol2', 0, () => {
      const mocker: MockKit = new MockKit();
      const folderGridPositionHelp = new FolderGridPositionHelp();
      const getFolderPositionUtil =
        mocker.mockFunc(folderGridPositionHelp, folderGridPositionHelp['getFolderPositionUtil']);
      when(getFolderPositionUtil)(ArgumentMatchers.any).afterReturn(undefined);
      expect(folderGridPositionHelp.getPositionByRowCol('folderId', 100, 100) === undefined).assertTrue();
      mocker.clear(folderGridPositionHelp);
      mocker.clearAll();
    })

    it('test_getFolderPositionUtil1', 0, () => {
      const folderGridPositionHelp = new FolderGridPositionHelp();
      folderGridPositionHelp['getFolderPositionUtil']('folderId');
      expect(folderGridPositionHelp['getFolderPositionUtil']('folderId') === undefined).assertTrue();
    })

    it('test_getFolderPositionUtil2', 0, () => {
      const mocker: MockKit = new MockKit();
      const folderGridPositionHelp = new FolderGridPositionHelp();
      const hookMapGet =
        mocker.mockFunc(folderGridPositionHelp['hookMap'], folderGridPositionHelp['hookMap'].get);
      const dragGridParam:DragGridParam = {
        paddingLeft: 0,
        paddingTop: 0,
        row: 0,
        column: 0,
        rowGap: 0,
        columnGap: 0,
        gridWidth: 0,
        gridHeight: 0
      }
      when(hookMapGet)(ArgumentMatchers.any).afterReturn({
        gridParamsCallback:()=>dragGridParam
      });
      folderGridPositionHelp['getFolderPositionUtil']('folderId');
      expect(folderGridPositionHelp['getFolderPositionUtil']('folderId')).not().assertNull();
      mocker.clear(folderGridPositionHelp['hookMap']);
      mocker.clearAll();
    })

  })
}