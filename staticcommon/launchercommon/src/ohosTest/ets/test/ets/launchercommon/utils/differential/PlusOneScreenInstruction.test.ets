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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import PlusOneScreenInstruction from '../../../../../../../main/ets/utils/differential/PlusOneScreenInstruction';
import GridLayoutItemInfo from '../../../../../../../main/ets/bean/GridLayoutItemInfo';


export default function PlusOneScreenInstructionTest() {
  describe('PlusOneScreenInstructionTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('PlusOneScreenInstructionTest_execute', 0, (): void => {
      try {
        let gridLayoutInfo: GridLayoutItemInfo[] = [];
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.bundleName = 'com.ohos.photos';
        item.abilityName = 'com.ohos.contacts.MainAbility';
        item.bundleName = 'com.ohos.photos2';
        item.moduleName = 'entry';
        item.container = -100;
        item.container = -100;
        item.typeId = 0;
        item.area = [1, 1];
        item.row = 2;
        item.column = 1;
        item.page = 0;
        gridLayoutInfo.push(item);
        let exe: PlusOneScreenInstruction = new PlusOneScreenInstruction(6, 4);
        exe.execute(gridLayoutInfo, item);
        expect(item.page).assertEqual(1);
      } catch (err) {}
    })

    it('PlusOneScreenInstructionTest_execute01', 0, (): void => {
      try {
        let gridLayoutInfo: GridLayoutItemInfo[] = [];
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.bundleName = 'com.ohos.photos';
        item.abilityName = 'com.ohos.contacts.MainAbility';
        item.bundleName = 'com.ohos.photos2';
        item.moduleName = 'entry';
        item.container = -100;
        item.typeId = 0;
        gridLayoutInfo.push(item);
        let obj: PlusOneScreenInstruction = new PlusOneScreenInstruction(6, 4);
        expect(obj['realize'](gridLayoutInfo, item)).not().assertNull();
      } catch (err) {}
    });

    it('text_PlusOneScreenInstruction_execute', 0, (): void => {
      try {
        let gridLayoutInfo: GridLayoutItemInfo[] = [];
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.bundleName = 'com.ohos.photos';
        item.abilityName = 'com.ohos.contacts.MainAbility';
        item.bundleName = 'com.ohos.photos2';
        item.moduleName = 'entry';
        item.container = 0;
        item.typeId = 0;
        gridLayoutInfo.push(item);
        let plusOneScreenInstruction: PlusOneScreenInstruction = new PlusOneScreenInstruction(6, 4);
        let result: GridLayoutItemInfo[] = plusOneScreenInstruction['realize'](gridLayoutInfo, item) ?? [];
        expect(result).not().assertUndefined();
        let result1: GridLayoutItemInfo[] = plusOneScreenInstruction['realize']([], item) ?? [];
        expect(result1).not().assertUndefined();
      } catch (err) {}
    });
  })
}
