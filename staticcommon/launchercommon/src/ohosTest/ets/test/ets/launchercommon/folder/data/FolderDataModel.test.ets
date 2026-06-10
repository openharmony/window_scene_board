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
﻿import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect} from '@ohos/hypium'
import {
  FolderState
} from '../../../../../../../main/ets/folder/common/FolderConstans'
import FolderDataModel
  from '../../../../../../../main/ets/folder/data/FolderDataModel'
import {
  FolderDataModelManager
} from '../../../../../../../main/ets/folder/model/FolderDataModelManager'
import { GridLayoutItemInfo } from '../../../../../../../main/ets/TsIndex'
export default function FolderDataModelTest() {
  describe('FolderDataModelTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // 构造测试用folderItem参数
      let testFolderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      testFolderItem.appName = 'testFolder';
      testFolderItem.appIconId = 0;
      testFolderItem.bundleName = 'FolderDataModelTest';
      testFolderItem.folderId = 'dtFolder';
      testFolderItem.abilityName = '';
      testFolderItem.downloadProgress = 0;
      testFolderItem.appStatus = 0;
      testFolderItem.typeId = 3;
      testFolderItem.appLabelId = 0;
      testFolderItem.keyName = 'FolderDataModelTest'
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

    it('test_getFolderItem', 0, () => {
      let dtFolderDataModel: FolderDataModel = FolderDataModelManager.getInstance()
        .getFolderDataModelById('dtFolder');
      expect(dtFolderDataModel.getFolderItem()).not().assertNull();
    })

    it('test_setFolderItem', 0, () => {
      let testFolderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      testFolderItem.appName = 'testFolder';
      testFolderItem.appIconId = 0;
      testFolderItem.bundleName = 'setFolderItem';
      testFolderItem.folderId = 'dtFolder';
      testFolderItem.abilityName = '';
      testFolderItem.downloadProgress = 0;
      testFolderItem.appStatus = 0;
      testFolderItem.typeId = 3;
      testFolderItem.appLabelId = 0;
      testFolderItem.keyName = 'setFolderItem'
      testFolderItem.area = [2, 2];
      testFolderItem.container = 6;
      testFolderItem.column = 1;
      testFolderItem.row = 1;
      testFolderItem.layoutInfo = [[]];
      for (let i = 0; i < 2; ++i) {
        let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        folderItem.id = i;
        testFolderItem.layoutInfo[0].push(folderItem);
      }
      let dtFolderDataModel: FolderDataModel = FolderDataModelManager.getInstance()
        .getFolderDataModelById('dtFolder');
      dtFolderDataModel.setFolderItem(testFolderItem);
      expect(dtFolderDataModel.isSmallFolder()).assertFalse();
    })

    it('test_getState', 0, () => {
      let dtFolderDataModel: FolderDataModel = FolderDataModelManager.getInstance()
        .getFolderDataModelById('dtFolder');
      expect(dtFolderDataModel.getState()).assertEqual(FolderState.SMALL_FOLDER_CLOSE)
    })

    it('test_getStateContext', 0, () => {
      let dtFolderDataModel: FolderDataModel = FolderDataModelManager.getInstance()
        .getFolderDataModelById('dtFolder');
      expect(dtFolderDataModel.getStateContext()).not().assertUndefined();
    })

    it('test_setFolderState', 0, () => {
      let dtFolderDataModel: FolderDataModel = FolderDataModelManager.getInstance()
        .getFolderDataModelById('dtFolder');
      dtFolderDataModel.setFolderState(FolderState.FOLDER_OPEN_STATIC);
      expect(dtFolderDataModel.getState()).assertEqual(FolderState.FOLDER_OPEN_STATIC)
    })

    it('test_getFolderItemStateData', 0, () => {
      let dtFolderDataModel: FolderDataModel = FolderDataModelManager.getInstance()
        .getFolderDataModelById('dtFolder');
      expect(dtFolderDataModel.getFolderItemStateData()).not().assertUndefined();
    })

    it('test_needPreLoadPage_1', 0, () => {
      let dtFolderDataModel: FolderDataModel = FolderDataModelManager.getInstance()
        .getFolderDataModelById('dtFolder');
      expect(dtFolderDataModel.needPreLoadPage(-1)).assertInstanceOf('Boolean');
      dtFolderDataModel['folderPageLoadState'] = [];
      expect(dtFolderDataModel.needPreLoadPage(0)).assertInstanceOf('Boolean');
      dtFolderDataModel['folderPageLoadState'] = [true];
      expect(dtFolderDataModel.needPreLoadPage(10)).assertInstanceOf('Boolean');
      dtFolderDataModel['folderPageLoadState'] = [true,true,true];
      expect(dtFolderDataModel.needPreLoadPage(1)).assertInstanceOf('Boolean');
    })

    it('test_setPageLoaded_1', 0, () => {
      let dtFolderDataModel: FolderDataModel = FolderDataModelManager.getInstance()
        .getFolderDataModelById('dtFolder');
      dtFolderDataModel.setPageLoaded(-1);
      dtFolderDataModel['folderPageLoadState'] = [];
      dtFolderDataModel.setPageLoaded(0);
      dtFolderDataModel['folderPageLoadState'] = [true];
      dtFolderDataModel.setPageLoaded(10);
      dtFolderDataModel['folderPageLoadState'] = [true,true,true];
      dtFolderDataModel.setPageLoaded(1);
      expect(dtFolderDataModel).not().assertNull();
    })

    it('test_initPageLoadState_1', 0, () => {
      const gridLayoutItemInfo:GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.layoutInfo = undefined;
      let dtFolderDataModel: FolderDataModel = FolderDataModelManager.getInstance()
        .getFolderDataModelById('dtFolder');
      dtFolderDataModel['initPageLoadState'](gridLayoutItemInfo);
      expect(dtFolderDataModel).not().assertNull();
    })
  })
}
