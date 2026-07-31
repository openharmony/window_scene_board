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

import { describe, it, expect, MockKit, when } from '@ohos/hypium';

import { CommonConstants } from '../../../../../../../main/ets/constants/CommonConstants';
import GridLayoutItemInfo from '../../../../../../../main/ets/bean/GridLayoutItemInfo';
import { DirtyFormCorrector } from '../../../../../../../main/ets/db/gridlayoutcorrector/DirtyFormCorrector';
import { RdbStoreManager } from '../../../../../../../main/ets/TsIndex';

export default function DirtyFormCorrectorTest() {
  describe('DirtyFormCorrectorTest', () => {
    it('test_handleData_basic', 0, () => {
      const corrector: DirtyFormCorrector = new DirtyFormCorrector();
      const cardItem = new GridLayoutItemInfo();
      cardItem.typeId = CommonConstants.TYPE_CARD;
      cardItem.bundleName = 'com.example.bundle';

      const folderItem = new GridLayoutItemInfo();
      folderItem.typeId = CommonConstants.TYPE_FOLDER;
      folderItem.layoutInfo = [];

      const stackItem = new GridLayoutItemInfo();
      stackItem.typeId = CommonConstants.TYPE_FORM_STACK;

      const gridInfo = [cardItem, folderItem, stackItem];
      corrector.handleData(gridInfo);
      expect(gridInfo.length).assertEqual(3);
    });
  });
}
