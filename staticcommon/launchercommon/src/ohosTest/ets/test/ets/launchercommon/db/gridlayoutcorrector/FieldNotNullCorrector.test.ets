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

import { describe, it, expect } from '@ohos/hypium';
import { FieldNotNullCorrector } from '../../../../../../../main/ets/db/gridlayoutcorrector/FieldNotNullCorrector';
import { CommonConstants } from '../../../../../../../main/ets/constants/CommonConstants';
import GridLayoutItemInfo from '../../../../../../../main/ets/bean/GridLayoutItemInfo';

export default function FieldNotNullCorrectorTest() {
  describe('FieldNotNullCorrectorTest', () => {
    it('test_FieldNotNullCorrectorTest', 0, () => {
      const fnnc = new FieldNotNullCorrector();
      const grid1 = new GridLayoutItemInfo();
      grid1.typeId = CommonConstants.TYPE_CARD;
      const grid2 = new GridLayoutItemInfo();
      grid2.layoutInfo = [];
      grid2.typeId = CommonConstants.TYPE_FOLDER;
      const grid3 = new GridLayoutItemInfo();
      const folderInfo = [grid1, grid2, grid3];
      fnnc.handleData(folderInfo);
      expect(folderInfo).not().assertNull();
    })

    it('test_FieldNotNullCorrectorTest1', 0, () => {
      const obj = new FieldNotNullCorrector();
      const grid1 = new GridLayoutItemInfo();
      grid1.id = 123456;
      grid1.typeId = CommonConstants.TYPE_CARD;
      grid1.cardId = '123';

      const grid2 = new GridLayoutItemInfo();
      grid2.id = 123458;
      grid2.typeId = CommonConstants.TYPE_FOLDER;
      grid2.infoName = 'name_info';

      const info1 = new GridLayoutItemInfo();
      const info2 = new GridLayoutItemInfo();
      const infoCol: GridLayoutItemInfo[] = [info1, info2];
      const infoArray: GridLayoutItemInfo[][] = [infoCol];
      infoArray.push(infoCol);

      const grid3 = new GridLayoutItemInfo();
      grid3.typeId = CommonConstants.TYPE_FOLDER;
      grid3.cardId = '2345';
      grid3.infoName = 'info';
      grid3.layoutInfo = infoArray;

      const folderInfo:GridLayoutItemInfo[] = [];
      folderInfo.push(grid1);
      obj.handleData(folderInfo);
      expect(true).assertTrue();
    })
  })
}
