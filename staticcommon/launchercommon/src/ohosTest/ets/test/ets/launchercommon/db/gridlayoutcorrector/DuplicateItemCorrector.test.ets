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

import { describe, it, expect } from '@ohos/hypium';
import { AbnormalItemCorrector } from '../../../../../../../main/ets/db/gridlayoutcorrector/AbnormalItemCorrector';
import { CommonConstants } from '../../../../../../../main/ets/constants/CommonConstants';
import GridLayoutItemInfo from '../../../../../../../main/ets/bean/GridLayoutItemInfo';

export default function DuplicateItemCorrectorTest() {
  describe('DuplicateItemCorrectorTest', () => {
    it('test_DuplicateItemCorrectorTest', 0, () => {
      const dup = new AbnormalItemCorrector();
      const grid = new GridLayoutItemInfo();
      const grid2 = new GridLayoutItemInfo();
      grid2.bundleName = 'bundle_name';
      grid.typeId = CommonConstants.TYPE_FOLDER;
      grid.layoutInfo = [[grid2, grid2]];

      const nullItem = new GridLayoutItemInfo();
      const folderInfo = [grid, grid, nullItem];
      dup.handleData(folderInfo);
      expect(folderInfo).not().assertNull();
      expect(grid.layoutInfo[0].length).assertEqual(1);
    })

    it('test_DuplicateItemCorrectorTest01', 0, () => {
      const dup = new AbnormalItemCorrector();
      const grid = new GridLayoutItemInfo();
      grid.id = 5000;
      grid.typeId = CommonConstants.TYPE_APP;
      grid.container = 133;
      grid.bundleName = 'bundle_name';
      grid.moduleName = 'm_name';
      grid.abilityName = 'a_name';

      const grid1 = new GridLayoutItemInfo();
      grid1.id = 5001;
      grid1.typeId = CommonConstants.TYPE_APP;
      grid1.container = 133;
      grid1.bundleName = 'bundle_name_other';
      grid1.moduleName = 'm_name';
      grid1.abilityName = 'a_name';

      const grid2 = new GridLayoutItemInfo();
      grid1.id = 5001;
      grid1.typeId = CommonConstants.TYPE_APP;
      grid1.container = 133;
      grid1.bundleName = '';
      grid1.moduleName = 'm_name';
      grid1.abilityName = 'a_name';

      const folderInfo = [grid, grid1, grid2]
      dup.handleData(folderInfo);
      expect(folderInfo.length).assertLessOrEqual(2);
    })

    it('test_DuplicateItemCorrectorTest02', 0, () => {
      const info1 = new GridLayoutItemInfo();
      const info2 = new GridLayoutItemInfo();
      const infoCol: GridLayoutItemInfo[] = [info1, info2];
      const infoArray: GridLayoutItemInfo[][] = [infoCol];
      const grid = new GridLayoutItemInfo();
      grid.id = 10000;
      grid.folderId = '147288';
      grid.typeId = CommonConstants.TYPE_FOLDER;
      grid.layoutInfo = infoArray;
      grid.container = 144;
      grid.bundleName = 'bundle_name';
      grid.moduleName = 'm_name';
      grid.abilityName = 'a_name';
      const folderInfo = [grid, grid];

      const obj = new AbnormalItemCorrector();
      obj.handleData(folderInfo);

      const grid1 = new GridLayoutItemInfo();
      grid1.id = 10001;
      grid1.folderId = '147288';
      grid1.typeId = CommonConstants.TYPE_FOLDER;
      grid1.layoutInfo = infoArray;
      grid1.container = 144;
      grid1.bundleName = 'bundle_name';
      grid1.moduleName = 'm_name';
      grid1.abilityName = 'a_name';
      const folderInfoOther = [grid, grid1];
      obj.handleData(folderInfoOther);
      expect(true).assertTrue();
    })
  })
}
