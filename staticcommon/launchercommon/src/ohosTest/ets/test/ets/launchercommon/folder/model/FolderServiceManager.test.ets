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
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium'
import FolderDataModel from '../../../../../../../main/ets/folder/data/FolderDataModel'
import {
  FolderDataModelManager
} from '../../../../../../../main/ets/folder/model/FolderDataModelManager'
import {
  FolderServiceManager
} from '../../../../../../../main/ets/folder/model/FolderServiceManager'
import { BaseFolderState } from '../../../../../../../main/ets/folder/state/BaseFolderState'
import { GridLayoutItemInfo } from '../../../../../../../main/ets/TsIndex'

export default function FolderServiceManagerTest() {
  describe('FolderServiceManagerTest', () => {
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

    it('FolderService_getInstance', 0, () => {
      let instance1: FolderServiceManager = FolderServiceManager.getInstance();
      expect(instance1).not().assertNull();
      let instance2: FolderServiceManager = FolderServiceManager.getInstance();
      expect(instance1).assertEqual(instance2);
    })

    it('FolderService_clickCloseFolder', 0, () => {
      FolderServiceManager.getInstance().clickCloseFolder('-1');
      let result = FolderDataModelManager.getInstance().isRegisteredFolderId('-1');
      expect(result).assertFalse();
      FolderServiceManager.getInstance().clickCloseFolder('dtFolder');
      result = FolderDataModelManager.getInstance().isRegisteredFolderId('dtFolder');
      expect(result).assertTrue();
    })

    it('FolderService_clickOpenFolder', 0, () => {
      let mock: MockKit = new MockKit();
      mock.mockFunc(FolderDataModelManager.getInstance(), FolderDataModelManager.getInstance()
        .getFolderStateContextById);
      FolderServiceManager.getInstance().clickOpenFolder('dtFolder');
      let result = FolderDataModelManager.getInstance().getOpenFolderId();
      expect(result).assertEqual('dtFolder')
    })

    it('test_clickCloseFolder_01', 0, () => {
      let instance: FolderServiceManager = FolderServiceManager.getInstance();
      let folderId: string = 'folderId_dt';
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(instance['mFolderDataModelManager'], instance['mFolderDataModelManager'].getFolderStateContextById);
      let folderStateContext: BaseFolderState = {} as BaseFolderState;
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(folderStateContext);

      let mockFunc2: Function = mocker.mockFunc(instance['mFolderDataModelManager'], instance['mFolderDataModelManager'].getFolderStateContextById);
      let folderDataModel: FolderDataModel = {} as FolderDataModel;
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(folderDataModel);

      instance.clickCloseFolder(folderId);
      expect(instance).not().assertNull();
    });

  })
}
