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
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
} from '@ohos/hypium'
import {
  FolderState
} from '../../../../../../../main/ets/folder/common/FolderConstans'
import {
  FolderDataModelManager
} from '../../../../../../../main/ets/folder/model/FolderDataModelManager'
import { GridLayoutItemInfo } from '../../../../../../../main/ets/TsIndex'

export default function FolderDataModelManagerTest() {
  describe('FolderDataModelManagerTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // 构造测试用folderItem参数
      let testFolderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      testFolderItem.appName = 'testFolder';
      testFolderItem.appIconId = 0;
      testFolderItem.bundleName = '54321';
      testFolderItem.folderId = 'dtFolder';
      testFolderItem.abilityName = '';
      testFolderItem.downloadProgress = 0;
      testFolderItem.appStatus = 0;
      testFolderItem.typeId = 3;
      testFolderItem.appLabelId = 0;
      testFolderItem.keyName = '54321'
      testFolderItem.area = [1, 1];
      testFolderItem.container = 6;
      testFolderItem.column = 1;
      testFolderItem.row = 1;
      testFolderItem.layoutInfo = [[]];
      for (let i = 0; i < 2; ++i) {
        let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        folderItem.id = i;
        testFolderItem.layoutInfo[0].push(folderItem);
      }
      FolderDataModelManager.getInstance().updateFolderDataModel(testFolderItem);
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
      FolderDataModelManager.getInstance().deleteFolderInMap('dtFolder');
    })

    it('FolderDataModelManager_getInstance', 0, () => {
      let instance1: FolderDataModelManager = FolderDataModelManager.getInstance();
      expect(instance1).not().assertNull();
      let instance2: FolderDataModelManager = FolderDataModelManager.getInstance();
      expect(instance1).assertEqual(instance2);
    })

    it('FolderDataModelManager_updateFolderDataModel', 0, () => {
      let testFolderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      testFolderItem.appName = 'updateFolderDataModel';
      testFolderItem.appIconId = 0;
      testFolderItem.bundleName = 'updateFolderDataModel';
      testFolderItem.folderId = 'updateFolderDataModel';
      testFolderItem.abilityName = '';
      testFolderItem.downloadProgress = 0;
      testFolderItem.appStatus = 0;
      testFolderItem.typeId = 3;
      testFolderItem.appLabelId = 0;
      testFolderItem.keyName = 'updateFolderDataModel'
      testFolderItem.area = [1, 1];
      testFolderItem.container = 6;
      testFolderItem.column = 1;
      testFolderItem.row = 1;
      testFolderItem.layoutInfo = [[]];
      for (let i = 0; i < 2; ++i) {
        let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        folderItem.id = i;
        testFolderItem.layoutInfo[0].push(folderItem);
      }
      FolderDataModelManager.getInstance().updateFolderDataModel(testFolderItem);
      expect(FolderDataModelManager.getInstance().isRegisteredFolderId('updateFolderDataModel')).assertTrue();
    })

    it('FolderDataModelManager_isRegisteredFolderId', 0, () => {
      let result: boolean = FolderDataModelManager.getInstance().isRegisteredFolderId('dtFolder');
      expect(result).assertTrue();
      result = FolderDataModelManager.getInstance().isRegisteredFolderId('');
      expect(result).assertFalse();
      result = FolderDataModelManager.getInstance().isRegisteredFolderId('undefinedFolderId');
      expect(result).assertFalse();
    })

    it('FolderDataModelManager_getFolderDataModelById', 0, () => {
      expect(FolderDataModelManager.getInstance().getFolderDataModelById('undefined')).assertNull();
      expect(FolderDataModelManager.getInstance().getFolderDataModelById('dtFolder')).not().assertNull();
    })

    it('FolderDataModelManager_getFolderStateById', 0, () => {
      let folderState: FolderState = FolderDataModelManager.getInstance()
        .getFolderStateById('dtFolder');
      expect(folderState).assertEqual(FolderState.SMALL_FOLDER_CLOSE);
    })

    it('FolderDataModelManager_empty_test', 0, () => {
      let folderState: FolderState = FolderDataModelManager.getInstance()
        .getFolderStateById('undefined');
      FolderDataModelManager.getInstance().deleteFolderInMap('undefined');
      FolderDataModelManager.getInstance().getFolderStateContextById('undefined');
      FolderDataModelManager.getInstance().setOpenFolderId('');
      FolderDataModelManager.getInstance().setFolderStateById('', FolderState.SMALL_FOLDER_CLOSE);
      let undefinedItem = new GridLayoutItemInfo();
      undefinedItem.folderId = '';
      FolderDataModelManager.getInstance().updateFolderDataModel(undefinedItem);
      expect(folderState).assertNull();
    })
  })
}
