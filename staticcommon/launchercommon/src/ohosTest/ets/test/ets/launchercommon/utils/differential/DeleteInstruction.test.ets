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
import { DeleteInstruction } from '../../../../../../../main/ets/utils/differential/DeleteInstruction';
import { GridLayoutItemInfo } from '../../../../../../../main/ets/TsIndex';


export default function DeleteInstructionTest() {
  describe('DeleteInstructionTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('DeleteInstructionTest_execute', 0, (): void => {
      let gridLayoutInfo: GridLayoutItemInfo[] = [];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'com.ohos.photos';
      item.abilityName = 'com.ohos.contacts.MainAbility';
      item.bundleName = 'com.ohos.photos2';
      item.moduleName = 'entry';
      item.container = -100;
      item.typeId = 0;
      gridLayoutInfo.push(item);
      let deleteExe: DeleteInstruction = new DeleteInstruction(6, 4);
      let newLayout = deleteExe.execute(gridLayoutInfo, item);
      expect(newLayout.length).assertEqual(0);
    })

    it('DeleteInstructionTest_realize', 0, (): void => {
      let gridLayoutInfo: GridLayoutItemInfo[] = [];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'com.ohos.photos';
      item.abilityName = 'com.ohos.contacts.MainAbility';
      item.bundleName = 'com.ohos.photos2';
      item.moduleName = 'entry';
      item.container = -100;
      item.typeId = 0;
      gridLayoutInfo.push(item);
      let deleteExe: DeleteInstruction = new DeleteInstruction(6, 4);
      expect(deleteExe['realize'](gridLayoutInfo, item)).not().assertNull();
    })

    it('test_DeleteInstruction_realize', 0, (): void => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'com.ohos.photos';
      item.abilityName = 'com.ohos.contacts.MainAbility';
      item.bundleName = 'com.ohos.photos2';
      item.moduleName = 'entry';
      item.container = -100;
      item.typeId = 0;
      let deleteExe: DeleteInstruction = new DeleteInstruction(6, 4);
      let result: GridLayoutItemInfo[] = deleteExe['realize']([], item);
      expect(result.length).assertEqual(0);
    })
  })
}
