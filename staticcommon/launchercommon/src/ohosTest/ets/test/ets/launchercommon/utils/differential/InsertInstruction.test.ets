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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import { InsertInstruction } from '../../../../../../../main/ets/utils/differential/InsertInstruction';
import { GridLayoutItemInfo, PageDesktopModel } from '../../../../../../../main/ets/TsIndex';
export default function InsertInstructionTest() {


  describe('InsertInstructionTest', (): void => {
    beforeAll((): void => {
    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('InsertInstructionTest_execute', 0, (): void => {
      const layoutinfo: string = '[{"bundleName": "com.ohos.contacts","abilityName": "com.ohos.contacts.MainAbility","moduleName": "entry","container": -101,"typeId": 0,"area": [1,1],"page": 0,"row": 0,"column": 0},{"bundleName": "com.ohos.mms","abilityName": "com.ohos.mms.MainAbility","moduleName": "entry","container": -101,"typeId": 0,"area": [1,1],"page": 0,"row": 0,"column": 3},{"bundleName": "com.ohos.browser","abilityName": "MainAbility","moduleName": "entry","container": -101,"typeId": 0,"area": [1,1],"page": 0,"row": 0,"column": 2},{"bundleName": "com.ohos.browser222","abilityName": "MainAbility333","moduleName": "entry","container": -100,"typeId": 0,"area": [1,1],"page": 1,"row": 0,"column": 2},{"bundleName": "com.ohos.camera","abilityName": "com.ohos.camera.MainAbility","moduleName": "phone","container": -101,"typeId": 0,"area": [1,1],"page": 2,"row": 10}]';
      const gridLayoutInfo = JSON.parse(JSON.stringify(layoutinfo)) as GridLayoutItemInfo[];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'com.ohos.photos2';
      item.abilityName = 'com.ohos.contacts.MainAbility';
      item.bundleName = 'com.ohos.photos2';
      item.moduleName = 'entry';
      item.container = -100;
      item.typeId = 0;
      item.area = [1, 1];
      item.row = 2;
      item.column = 1;
      item.page = 0;
      let insertIntoExe = new InsertInstruction(6, 4);
      expect(insertIntoExe['rows'] === 6).assertTrue();
    })

    it('InsertInstructionTest_realize', 0, (): void => {
      const gridLayoutInfo: GridLayoutItemInfo[] = [];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'com.ohos.photos2';
      item.abilityName = 'com.ohos.contacts.MainAbility';
      item.bundleName = 'com.ohos.photos2';
      item.moduleName = 'entry';
      item.container = -100;
      item.typeId = 0;
      item.area = [1, 1];
      item.row = 2;
      item.column = 1;
      item.page = 0;
      gridLayoutInfo.push(item);
      let insertIntoExe = new InsertInstruction(6, 4);
      expect(insertIntoExe['realize'](gridLayoutInfo, item)).not().assertNull();
    })

    it('InsertInstructionTest_dealInsertAppInDock', 0, (): void => {
      let insertIntoExe = new InsertInstruction(6, 4);
      expect(insertIntoExe['dealInsertAppInDock'](null, null)).assertNull();
      const gridLayoutInfo: GridLayoutItemInfo[] = [];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'com.ohos.photos2';
      item.abilityName = 'com.ohos.contacts.MainAbility';
      item.bundleName = 'com.ohos.photos2';
      item.moduleName = 'entry';
      item.container = -100;
      item.typeId = 0;
      item.area = [1, 1];
      item.row = 2;
      item.column = 1;
      item.page = 0;
      gridLayoutInfo.push(item);
      expect(insertIntoExe['dealInsertAppInDock'](gridLayoutInfo, item)).not().assertNull();
    })

    it('InsertInstructionTest_realize02', 0, (): void => {
      let gridLayoutInfo: GridLayoutItemInfo[] = [];
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'com.ohos.photos2';
      item.abilityName = 'com.ohos.contacts.MainAbility';
      item.bundleName = 'com.ohos.photos2';
      item.moduleName = 'entry';
      item.container = -101;
      item.typeId = 1;
      item.area = [1, 1];
      item.row = 2;
      item.column = 1;
      item.page = 0;
      gridLayoutInfo.push(item);
      let insertIntoExe = new InsertInstruction(6, 4);
      let ret = insertIntoExe['realize'](gridLayoutInfo, item);
      expect(ret[0].container).assertEqual(-101);
      gridLayoutInfo = [item, item, item, item, item];
      ret = insertIntoExe['realize'](gridLayoutInfo, item);
      expect(ret.length).assertEqual(5);
      item.container = -100;
      gridLayoutInfo = [item];
      let pageDesktopModel = PageDesktopModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(pageDesktopModel, pageDesktopModel.isPositionValid);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      ret = insertIntoExe['realize'](gridLayoutInfo, item);
      expect(ret[0].container).assertEqual(-100);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      ret = insertIntoExe['realize'](gridLayoutInfo, item);
      expect(ret[1].container).assertEqual(-100);
      mocker.clear(pageDesktopModel);
      mocker.clearAll();
    })
  })
}
