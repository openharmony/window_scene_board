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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { CommonConstants, GridLayoutItemInfo } from '@ohos/launchercommon'
import { FolderEventConstants } from '@ohos/launchercommon/src/main/ets/constants/FolderEventConstants';
import { OpenFolderAppMoveVm } from '../../../../main/ets/default/viewmodel/OpenFolderAppMoveVM'
import { openFolderAppMoveVMManager } from '../../../../main/ets/default/viewmodel/OpenFolderAppMoveVMManager'

function getNullObject(): GridLayoutItemInfo | null {
  return null;
}

export default function OpenFolderAppMoveVMManagerTest() {
  describe('OpenFolderAppMoveVMManagerTest', () => {
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

    it('test_OpenFolderAppMoveVMManagerTest_register_and_unregister', 0, () => {
      let item: OpenFolderAppMoveVm = new OpenFolderAppMoveVm();
      item.id = FolderEventConstants.KEY_FOLDER_ADD;
      openFolderAppMoveVMManager.registerItem(item);
      openFolderAppMoveVMManager.unregisterItem(item);
      let item2: OpenFolderAppMoveVm = new OpenFolderAppMoveVm();
      openFolderAppMoveVMManager.registerItem(item);
      openFolderAppMoveVMManager.unregisterItem(item2);
      let GridLayoutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      GridLayoutItem.id = 9;
      GridLayoutItem.typeId = CommonConstants.TYPE_ADD;
      GridLayoutItem.keyName = FolderEventConstants.KEY_FOLDER_ADD;
      let ret = openFolderAppMoveVMManager.getMoveVmByItem(GridLayoutItem);
      expect(ret.id).assertEqual(FolderEventConstants.KEY_FOLDER_ADD);
      openFolderAppMoveVMManager.unregisterItem(item);
    })

    it('test_OpenFolderAppMoveVMManagerTest_getMoveVmByItem', 0, () => {
      let item: OpenFolderAppMoveVm = new OpenFolderAppMoveVm();
      item.id = FolderEventConstants.KEY_FOLDER_ADD;
      let item2: OpenFolderAppMoveVm = new OpenFolderAppMoveVm();
      item2.id = 'bundleName99';
      let GridLayoutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      GridLayoutItem.id = 9;
      GridLayoutItem.typeId = CommonConstants.TYPE_ADD;
      openFolderAppMoveVMManager.registerItem(item);
      openFolderAppMoveVMManager.registerItem(item2);
      let ret: OpenFolderAppMoveVm = openFolderAppMoveVMManager.getMoveVmByItem(getNullObject() as GridLayoutItemInfo);
      expect(ret.id).assertEqual('');
      ret = openFolderAppMoveVMManager.getMoveVmByItem(GridLayoutItem);
      expect(ret.id).assertEqual(FolderEventConstants.KEY_FOLDER_ADD);
      GridLayoutItem.typeId = CommonConstants.TYPE_FOLDER;
      GridLayoutItem.keyName = undefined;
      GridLayoutItem.bundleName = 'bundleName';
      ret = openFolderAppMoveVMManager.getMoveVmByItem(GridLayoutItem);
      expect(ret.id).assertEqual('bundleName99');
      GridLayoutItem.bundleName = 'XX';
      ret = openFolderAppMoveVMManager.getMoveVmByItem(GridLayoutItem);
      expect(ret.id).assertEqual('');
    })

    it('test_OpenFolderAppMoveVMManagerTest_resetTransLate', 0, () => {
      let item: OpenFolderAppMoveVm = new OpenFolderAppMoveVm();
      item.translateX = 0;
      item.translateY = 1;
      let item2: OpenFolderAppMoveVm = new OpenFolderAppMoveVm();
      item2.translateX = 0;
      item2.translateY = 0;
      let item3: OpenFolderAppMoveVm = new OpenFolderAppMoveVm();
      item3.translateX = 1;
      item3.translateY = 0;
      openFolderAppMoveVMManager.registerItem(item);
      openFolderAppMoveVMManager.registerItem(item2);
      openFolderAppMoveVMManager.registerItem(item3);
      openFolderAppMoveVMManager.resetTransLate();
      expect(item2.translateY).assertEqual(0);
    })
  })
}