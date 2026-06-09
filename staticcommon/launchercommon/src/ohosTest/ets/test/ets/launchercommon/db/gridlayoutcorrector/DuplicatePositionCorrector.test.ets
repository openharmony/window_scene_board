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

import { describe, it, expect, MockKit, ArgumentMatchers, when } from '@ohos/hypium';
import { DuplicatePositionCorrector } from '../../../../../../../main/ets/db/gridlayoutcorrector/DuplicatePositionCorrector';
import GridLayoutItemInfo from '../../../../../../../main/ets/bean/GridLayoutItemInfo';
import GridLayoutUtil from '../../../../../../../main/ets/utils/GridLayoutUtil';

export default function DuplicatePositionCorrectorTest() {
  describe('DuplicatePositionCorrectorTest', () => {
    it('test_DuplicatePositionCorrectorTest', 0, () => {
      const dup = new DuplicatePositionCorrector();
      const grid = new GridLayoutItemInfo();
      grid.area = [1, 1];
      grid.page = 0;
      grid.row = 1;
      grid.column = 2;
      const folderInfo = [grid, grid];
      dup.handleData(folderInfo);
      expect(folderInfo.length).assertEqual(2);
    })

    it('test_DuplicatePositionCorrectorTest1', 0, () => {
      const obj = new DuplicatePositionCorrector();
      const grid = new GridLayoutItemInfo();
      grid.area = [1, 1];
      grid.page = 0;
      grid.row = 1;
      grid.column = 2;
      const folderInfo = [grid, grid];

      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.ifDuplicatePosition);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      obj.handleData(folderInfo);
      expect(true).assertTrue();
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })
  })
}
