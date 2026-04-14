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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import ModifyInstruction from '../../../../../../../main/ets/utils/differential/ModifyInstruction';
import GridLayoutItemInfo from '../../../../../../../main/ets/bean/GridLayoutItemInfo';
import { CommonConstants } from '../../../../../../../main/ets/constants/CommonConstants';

export default function ModifyInstructionTest() {
  describe('ModifyInstructionTest', () => {
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
    it('ModifyInstructionTest_constructor', 0, () => {
      let obj: ModifyInstruction = new ModifyInstruction(1, 1);
      expect(obj).not().assertNull();
    })

    it('ModifyInstructionTest_realize', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'com.ohos.photos';
      item.abilityName = 'com.ohos.contacts.MainAbility';
      item.bundleName = 'com.ohos.photos2';
      item.moduleName = 'entry';
      item.container = -100;
      item.typeId = 0;
      let gridLayoutInfo: GridLayoutItemInfo[] = [];
      gridLayoutInfo.push(item);

      let obj: ModifyInstruction = new ModifyInstruction(1, 1);
      let ret = obj['realize'](gridLayoutInfo, item);
      expect(ret).not().assertNull();
    })

    it('ModifyInstructionTest_getModifyType', 0, () => {
      let existItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      existItem.bundleName = 'com.ohos.photos';
      existItem.abilityName = 'com.ohos.contacts.MainAbility';
      existItem.bundleName = 'com.ohos.photos2';
      existItem.moduleName = 'entry';
      existItem.container = -100;
      existItem.typeId = 0;

      let modifyItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      modifyItem.bundleName = 'com.ohos.photos';
      modifyItem.abilityName = 'com.ohos.contacts.MainAbility';
      modifyItem.bundleName = 'com.ohos.photos2';
      modifyItem.moduleName = 'entry';
      modifyItem.container = -100;
      modifyItem.typeId = 0;

      let obj: ModifyInstruction = new ModifyInstruction(1, 1);
      let ret = obj['getModifyType'](null, null);
      expect(ret).assertInstanceOf('String');

      existItem.area = [1, 1];
      ret = obj['getModifyType'](existItem, null);
      expect(ret).assertInstanceOf('String');
      modifyItem.area = [1, 1];
      ret = obj['getModifyType'](existItem, modifyItem);
      expect(ret).assertInstanceOf('String');

      existItem.typeId = 0;
      modifyItem.typeId = 0;
      ret = obj['getModifyType'](existItem, modifyItem);
      expect(ret).assertInstanceOf('String');
    })

    it('ModifyInstructionTest_realize_invalid01', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'com.ohos.photos';
      item.abilityName = 'com.ohos.contacts.MainAbility';
      item.moduleName = 'entry';
      item.container = -100;
      item.typeId = 0;
      item.area = [0, 1];
      let gridLayoutInfo: GridLayoutItemInfo[] = [];
      gridLayoutInfo.push(item);
      let obj: ModifyInstruction = new ModifyInstruction(1, 1);
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.abilityName = 'com.ohos.contacts.MainAbility';
      item2.bundleName = 'com.ohos.photos3';
      item2.moduleName = 'entry1';
      item2.container = -101;
      item2.typeId = 0;
      item2.area = [0, 1];
      let ret2 = obj['realize'](gridLayoutInfo, item2);
      expect(ret2[0].bundleName).assertEqual(item.bundleName);
    })

    it('ModifyInstructionTest_realize_DOCK_2_APP_TYPE_NO_CHANGE', 0, () => {
      let bundleName = 'com.ohos.photos';
      let ability = 'ability.photos';
      let moduleName = 'moduleName.photos';
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = bundleName;
      item.abilityName = ability;
      item.moduleName = moduleName;
      item.container = CommonConstants.CONTAINER_SMARTDOCK;
      item.typeId = CommonConstants.TYPE_APP;
      item.area = [1, 1];
      item.page = 1;
      item.column = 1;
      item.row = 1;
      let gridLayoutInfo: GridLayoutItemInfo[] = [];
      gridLayoutInfo.push(item);
      let obj: ModifyInstruction = new ModifyInstruction(1, 1);
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = bundleName;
      item2.abilityName = ability;
      item2.moduleName = moduleName;
      item2.container = CommonConstants.CONTAINER_DESKTOP;
      item2.typeId = CommonConstants.TYPE_APP;
      item2.area = [1, 1];
      let ret2 = obj['realize'](gridLayoutInfo, item2);
      expect(ret2[0].bundleName).assertEqual(bundleName);
      item.container = CommonConstants.CONTAINER_SMARTDOCK;
      item2.container = CommonConstants.CONTAINER_SMARTDOCK;
      let ret3 = obj['realize']([item], item2);
      expect(ret3[0].bundleName).assertEqual(bundleName);
    })

    it('ModifyInstructionTest_realize_APP_2_DOCK', 0, () => {
      let bundleName = 'com.ohos.photos';
      let ability = 'ability.photos';
      let moduleName = 'moduleName.photos';
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = bundleName;
      item.abilityName = ability;
      item.moduleName = moduleName;
      item.container = CommonConstants.CONTAINER_DESKTOP;
      item.typeId = CommonConstants.TYPE_APP;
      item.area = [1, 1];
      item.page = 1;
      item.column = 1;
      item.row = 1;
      let gridLayoutInfo: GridLayoutItemInfo[] = [];
      gridLayoutInfo.push(item);
      let obj: ModifyInstruction = new ModifyInstruction(1, 1);
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = bundleName;
      item2.abilityName = ability;
      item2.moduleName = moduleName;
      item2.container = CommonConstants.CONTAINER_SMARTDOCK;
      item2.typeId = CommonConstants.TYPE_APP;
      item2.area = [1, 1];
      let ret2 = obj['realize'](gridLayoutInfo, item2);
      expect(ret2[0].bundleName).assertEqual(bundleName);
    })

    it('ModifyInstructionTest_realize_switch', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'com.ohos.photos';
      item.abilityName = 'com.ohos.contacts.MainAbility';
      item.moduleName = 'entry';
      item.container = -100;
      item.typeId = 0;
      let obj: ModifyInstruction = new ModifyInstruction(1, 1);
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.photos';
      item3.abilityName = 'com.ohos.contacts.MainAbility';
      item3.bundleName = 'com.ohos.photos3';
      item3.moduleName = 'entry1';
      item3.container = -101;
      item3.folderId = 'com.openharmony.grid.folderid111'
      item3.typeId = 3;
      let gridLayoutInfo3: GridLayoutItemInfo[] = [];
      gridLayoutInfo3.push(item);
      gridLayoutInfo3.push(item3);
      let ret3 = obj['realize'](gridLayoutInfo3, item3);
      expect(ret3).not().assertNull();
    })

    it('ModifyInstructionTest_realize1', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'com.ohos.photos';
      item.abilityName = 'com.ohos.contacts.MainAbility';
      item.bundleName = 'com.ohos.photos2';
      item.moduleName = 'entry';
      item.container = -100;
      item.folderId = '122233445654';
      item.typeId = 3;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.photos';
      item2.abilityName = 'com.ohos.contacts.MainAbility';
      item2.bundleName = 'com.ohos.photos3';
      item2.moduleName = 'entry1';
      item2.container = -101;
      item2.folderId = '122233445654';
      item2.typeId = 0;
      let gridLayoutInfo: GridLayoutItemInfo[] = [];
      gridLayoutInfo.push(item);
      let obj: ModifyInstruction = new ModifyInstruction(1, 1);
      let ret = obj['realize'](gridLayoutInfo, item2);
      expect(ret).not().assertNull();
    })

    it('ModifyInstructionTest_getModifyType_01', 0, () => {
      let existItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      existItem.bundleName = 'com.ohos.photos';
      existItem.abilityName = 'com.ohos.contacts.MainAbility';
      existItem.bundleName = 'com.ohos.photos2';
      existItem.moduleName = 'entry';
      existItem.container = -100;
      existItem.typeId = 0;
      let modifyItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      modifyItem.bundleName = 'com.ohos.photos';
      modifyItem.abilityName = 'com.ohos.contacts.MainAbility';
      modifyItem.bundleName = 'com.ohos.photos2';
      modifyItem.moduleName = 'entry';
      modifyItem.container = -100;
      modifyItem.typeId = 0;
      let obj: ModifyInstruction = new ModifyInstruction(1, 1);
      let ret = obj['getModifyType'](null, null);
      existItem.container = -100;
      modifyItem.container = -101;
      ret = obj['getModifyType'](existItem, modifyItem);
      expect(ret).assertInstanceOf('String');
      existItem.container = -101;
      modifyItem.container = -100;
      ret = obj['getModifyType'](existItem, modifyItem);
      expect(ret).assertInstanceOf('String');
      existItem.container = -101;
      modifyItem.container = -102;
      ret = obj['getModifyType'](existItem, modifyItem);
      expect(ret).assertInstanceOf('String');
      existItem.typeId = -3;
      modifyItem.typeId = -3;
      existItem.bundleName = 'com.ohos.photos1';
      modifyItem.bundleName = 'com.ohos.photos';
      existItem.folderId = '123ede32';
      modifyItem.folderId = '123ede32';
      ret = obj['getModifyType'](existItem, modifyItem);
      expect(ret).assertInstanceOf('String');
      existItem.typeId = -3;
      modifyItem.typeId = -3;
      existItem.bundleName = 'com.ohos.photos1';
      modifyItem.bundleName = 'com.ohos.photos';
      existItem.folderId = '123ede6666';
      modifyItem.folderId = '123ed8888';
      ret = obj['getModifyType'](existItem, modifyItem);
      expect(ret).assertInstanceOf('String');
    })

    it('test_getModifyType_NOT_SUPPORT', 0, () => {
      let bundleName = 'com.ohos.photos';
      let ability = 'ability.photos';
      let moduleName = 'moduleName.photos';
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = bundleName;
      item.abilityName = ability;
      item.moduleName = moduleName;
      item.container = CommonConstants.CONTAINER_SMARTDOCK;
      item.typeId = CommonConstants.TYPE_APP;
      item.area = [0, 1];
      item.page = 1;
      item.column = 1;
      item.row = 1;
      let obj: ModifyInstruction = new ModifyInstruction(1, 1);
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = bundleName;
      item2.abilityName = ability;
      item2.moduleName = moduleName;
      item2.container = CommonConstants.CONTAINER_RECENT;
      item2.typeId = CommonConstants.TYPE_APP;
      item2.area = [0, 1];
      let ret = obj['getModifyType'](item, item2);
      expect(ret).assertEqual('NOT_SUPPORT');
      item.area = [1, 1];
      let ret1 = obj['getModifyType'](item, item2);
      expect(ret1).assertEqual('NOT_SUPPORT');
    })

    it('test_getModifyType_NOT_SUPPORT001_TYPE_NO_CHANGE', 0, () => {
      let bundleName = 'com.ohos.photos';
      let ability = 'ability.photos';
      let moduleName = 'moduleName.photos';
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = bundleName;
      item.abilityName = ability;
      item.moduleName = moduleName;
      item.container = CommonConstants.CONTAINER_SMARTDOCK;
      item.typeId = CommonConstants.TYPE_FOLDER;
      item.folderId = '122222';
      item.area = [1, 1];
      item.page = 1;
      item.column = 1;
      item.row = 1;
      let obj: ModifyInstruction = new ModifyInstruction(1, 1);
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = bundleName;
      item2.abilityName = ability;
      item2.moduleName = moduleName;
      item2.container = CommonConstants.CONTAINER_RECENT;
      item2.typeId = CommonConstants.TYPE_FOLDER;
      item2.folderId = '122222';
      item2.area = [1, 1];
      let ret = obj['getModifyType'](item, item2);
      expect(ret).assertEqual('TYPE_NO_CHANGE');
      item.folderId = '1222223333';
      item2.folderId = '122222';
      let ret1 = obj['getModifyType'](item, item2);
      expect(ret1).assertEqual('NOT_SUPPORT');
    })
  })
}
