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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit,
  ArgumentMatchers,
  when} from '@ohos/hypium'
import { FolderModel } from '../../../../../../main/ets/folder/FolderModel'
import { AppItemInfo, FolderLayoutStruct, GridLayoutItemInfo } from '../../../../../../main/ets/TsIndex'
import { CommonConstants } from '../../../../../../../../../staticcommon/launchercommon/src/main/ets/constants/CommonConstants';


export default function FolderModelTest() {
  describe('FolderModelTest', () => {
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
    it('assertEqual', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'test'
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
    })

    it('test_updateFolderSize', 0, () => {
      let testFolderItemData: GridLayoutItemInfo = new GridLayoutItemInfo();
      testFolderItemData.appName = 'testFolder';
      testFolderItemData.appIconId = 0;
      testFolderItemData.bundleName = '54321';
      testFolderItemData.folderId = 'dtFolder';
      testFolderItemData.abilityName = '';
      testFolderItemData.downloadProgress = 0;
      testFolderItemData.appStatus = 0;
      testFolderItemData.typeId = 3;
      testFolderItemData.appLabelId = 0;
      testFolderItemData.keyName = '54321'
      testFolderItemData.area = [1, 1];
      testFolderItemData.container = 6;
      testFolderItemData.column = 1;
      testFolderItemData.row = 1;
      testFolderItemData.layoutInfo = [[]];
      for (let i = 0; i < 2; ++i) {
        let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        folderItem.id = i;
        testFolderItemData.layoutInfo[0].push(folderItem);
      }
      expect(FolderModel.getInstance().updateFolderSize(testFolderItemData) === undefined).assertTrue()
    })

    it('test_getBigFolderLayout_01', 0, () => {
      let instance: FolderModel = FolderModel.getInstance();
      let ret: FolderLayoutStruct = instance.getBigFolderLayout();
      expect(ret).not().assertNull();
    });

    it('test_getFolderAddAppLayout_01', 0, () => {
      let instance: FolderModel = FolderModel.getInstance();
      let ret: FolderLayoutStruct = instance.getFolderAddAppLayout();
      expect(ret).not().assertNull();
    });

    it('test_getFolderLayoutInOpen_01', 0, () => {
      let instance: FolderModel = FolderModel.getInstance();
      let ret: string = instance.getFolderLayoutInOpen();
      expect(ret).not().assertNull();
    });

    it('test_getFolderList_01', 0, async (done: Function) => {
      let instance: FolderModel = FolderModel.getInstance();
      let installedAppInfoList: AppItemInfo[] = [];
      let ret: GridLayoutItemInfo[] = await instance.getFolderList(installedAppInfoList, false);
      expect(ret).not().assertNull();
      done();
    });

    it('test_getFolderOpenLayout_01', 0, () => {
      let instance: FolderModel = FolderModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc)().afterReturn(true);

      let ret: FolderLayoutStruct = instance.getFolderOpenLayout();
      expect(ret).not().assertNull();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('test_getFolderOpenLayout_02', 0, () => {
      let instance: FolderModel = FolderModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc1)().afterReturn(false);
      let sessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let mockFunc2: Function = mocker.mockFunc(sessionManager, sessionManager.isFoldablePhoneExpandStatus);
      when(mockFunc2)().afterReturn(false);
      
      let ret: FolderLayoutStruct = instance.getFolderOpenLayout();
      expect(ret).not().assertNull();
      mocker.clear(DeviceHelper);
      mocker.clear(sessionManager);
      mocker.clearAll();
    });

    it('test_getOpenFolderMaxPerPage_01', 0, () => {
      let instance: FolderModel = FolderModel.getInstance();
      let ret: number = instance.getOpenFolderMaxPerPage();
      expect(ret).assertLargerOrEqual(0);
    });

    it('test_getSmallFolderLayout_01', 0, () => {
      let instance: FolderModel = FolderModel.getInstance();
      let ret: FolderLayoutStruct = instance.getSmallFolderLayout();
      expect(ret).not().assertNull();
    });

    it('test_getInstance', 0, () => {
      globalThis.FolderModelInstance = null;
      let instance = FolderModel.getInstance();
      expect(instance instanceof FolderModel).assertTrue();
    })

  })
}
