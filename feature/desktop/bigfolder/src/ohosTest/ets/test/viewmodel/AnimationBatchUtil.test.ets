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
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit,
  ArgumentMatchers,
  when} from '@ohos/hypium'
import { FolderModel,
  GridLayoutConfig,
  GridLayoutItemInfo, SettingsModel } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { FolderType } from '@ohos/launchercommon/src/main/ets/utils/FolderLayoutUtil';
import { aniBatchUtil } from '../../../../main/ets/default/viewmodel/AnimationBatchUtil';

export default function AnimationBatchUtilTest() {
  describe('AnimationBatchUtilTest', () => {
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

    it('test_getFolderType', 0, () => {
      expect(aniBatchUtil.getFolderType([1, 1])).assertEqual(FolderType.TYPE_SMALL_FOLDER);
      expect(aniBatchUtil.getFolderType([2, 2])).assertEqual(FolderType.TYPE_NORMAL_BIG_FOLDER);
      expect(aniBatchUtil.getFolderType([2, 1])).assertEqual(FolderType.TYPE_2X1_BIG_FOLDER);
      expect(aniBatchUtil.getFolderType([1, 2])).assertEqual(FolderType.TYPE_1X2_BIG_FOLDER);
      expect(aniBatchUtil.getFolderType([4, 2])).assertEqual(FolderType.TYPE_4X2_BIG_FOLDER);
      expect(aniBatchUtil.getFolderType([0, 0])).assertEqual(FolderType.TYPE_SMALL_FOLDER);
    })

    it('test_getShouldOptIndex', 0, () => {
      expect(aniBatchUtil.getShouldOptIndex(FolderType.TYPE_SMALL_FOLDER)).assertEqual(9);
      expect(aniBatchUtil.getShouldOptIndex(FolderType.TYPE_NORMAL_BIG_FOLDER)).assertEqual(11);
      expect(aniBatchUtil.getShouldOptIndex(FolderType.TYPE_2X1_BIG_FOLDER)).assertEqual(5);
      expect(aniBatchUtil.getShouldOptIndex(FolderType.TYPE_1X2_BIG_FOLDER)).assertEqual(5);
      expect(aniBatchUtil.getShouldOptIndex(FolderType.TYPE_4X2_BIG_FOLDER)).assertEqual(12);
    })

    it('test_getFolderItemOrder', 0, () => {
      let mocker: MockKit = new MockKit();
      let folderModel: FolderModel = FolderModel.getInstance();
      let mockFunc: Function = mocker.mockFunc(folderModel, folderModel.getFolderLayoutInOpen);
      when(mockFunc)(ArgumentMatchers.any).afterReturn('4X3');
      expect(aniBatchUtil.getFolderItemOrder(0, 10, false)).assertEqual(2);
      expect(aniBatchUtil.getFolderItemOrder(0, 10, true)).assertEqual(1);
      when(mockFunc)(ArgumentMatchers.any).afterReturn('4X4');
      expect(aniBatchUtil.getFolderItemOrder(0, 10, false)).assertEqual(0);
      expect(aniBatchUtil.getFolderItemOrder(0, 10, true)).assertEqual(3);
    })

    it('test_getFolderRegion', 0, () => {
      //固定GridConfig, 避免DT执行失败
      let mocker: MockKit = new MockKit();
      let mockGridConfig: Function = mocker.mockFunc(SettingsModel.getInstance(),
        SettingsModel.getInstance().getGridConfig);
      let testGridConfig :GridLayoutConfig = {
        id: 10,
        layout: '4X4',
        name: '4X4',
        value: 1,
        row: 4,
        column: 4,
        checked: false
      }
      when(mockGridConfig)(ArgumentMatchers.any).afterReturn(testGridConfig);

      // 判空return分支
      let fakeArr: GridLayoutItemInfo[] = [];
      let emptyItem = fakeArr.find(item => item.keyName === 'fake');
      expect(aniBatchUtil.getFolderRegion(emptyItem as GridLayoutItemInfo)).assertEqual(0);
      // isFoldablePhoneExpandStatus为false分支
      let mockGetFolderExpandStatus: Function = mocker.mockFunc(SCBScreenSessionManager.getInstance(),
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus);
      when(mockGetFolderExpandStatus)(ArgumentMatchers.any).afterReturn(false);
      let folderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      folderItem.isInDock = true;
      folderItem.dockRegion = 4;
      expect(aniBatchUtil.getFolderRegion(folderItem)).assertEqual(4);
      folderItem.dockRegion = undefined;
      expect(aniBatchUtil.getFolderRegion(folderItem)).assertEqual(0);
      folderItem.isInDock = false;
      folderItem.area = [1,1];
      let testFolderRegion = (column: number, row: number, expectValue: number): void => {
        folderItem.column = column;
        folderItem.row = row;
        expect(aniBatchUtil.getFolderRegion(folderItem)).assertEqual(expectValue);
      }
      testFolderRegion(0,0,0);
      testFolderRegion(0,3,2);
      testFolderRegion(3,3,3);
      testFolderRegion(3,0,1);
      // isFoldablePhoneExpandStatus为true分支
      when(mockGetFolderExpandStatus)(ArgumentMatchers.any).afterReturn(true);
      let mockAppStorage: Function = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockAppStorage)(ArgumentMatchers.any).afterReturn([1, 2, 3, 4]);
      folderItem.isInDock = true;
      testFolderRegion(0,0,2);
      folderItem.isInDock = false;
      folderItem.page = 0;
      testFolderRegion(0,0,0);
      mocker.clear(AppStorage);
    })
  })
}
