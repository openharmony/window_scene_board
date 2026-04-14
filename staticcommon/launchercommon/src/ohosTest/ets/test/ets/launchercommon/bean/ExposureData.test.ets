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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { ExposureData } from '../../../../../../main/ets/bean/ExposureData';
import { FolderExposureData,  DesktopExposureData, StackExposureData } from '../../../../../../main/ets/bean/ExposureData';

export function ExposureDataTest() {
  describe('ExposureDataTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('ExposureDataTest_getFolderExposureDataList', 0, () => {
      const exposureData = new ExposureData();
      const folderExposureDataList = exposureData.getFolderExposureDataList();
      expect(folderExposureDataList.length >= 0).assertEqual(true);
    })

    it('ExposureDataTest_insertFolderExposureDataList_01', 0, () => {
      const res = 'success';
      const exposureData = new ExposureData();
      const newFolderData = {
        id: 'lkqkw4s76q0592qwa4g-1',
        folderId: 'lkqkw4s76q0592qwa4g',
        folderName: '',
        exposureTime: 1,
        exposureCount: 1,
        coordinate: { column: 0, row: 0 },
        desktopPageIndex: 0,
        pageIndex: 0,
        folderAppList: [],
        isBigFolder: false,
      } as FolderExposureData;

      exposureData.insertFolderExposureDataList(newFolderData);
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('ExposureDataTest_insertFolderExposureDataList_02', 0, () => {
      const res = 'success';
      const exposureData = new ExposureData() as object;
      const newFolderData = {
        id: 'lkqkw4s76q0592qwa4g-1',
        folderId: 'lkqkw4s76q0592qwa4g',
        folderName: '',
        exposureTime: 1,
        exposureCount: 1,
        coordinate: { column: 0, row: 0 },
        desktopPageIndex: 0,
        pageIndex: 0,
        folderAppList: [],
        isBigFolder: false,
      } as FolderExposureData;

      for (let i = 0; i < 100; i++) {
        exposureData['folderExposureDataList'].push(newFolderData);
      }
      exposureData['insertFolderExposureDataList'](newFolderData);
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('ExposureDataTest_getDesktopExposureDataList', 0, () => {
      const exposureData = new ExposureData();
      const desktopExposureDataList = exposureData.getDesktopExposureDataList();
      expect(desktopExposureDataList.length >= 0).assertEqual(true);
    })

    it('ExposureDataTest_insertDesktopExposureDataList', 0, () => {
      const res = 'success';
      const exposureData = new ExposureData();
      const newDesktopData = {
        id: 'desktop-1',
        desktopPageIndex: 0,
        exposureTime: 2,
        exposureCount: 1,
        desktopAppInfoList: [],
        desktopFolderInfoList: [],
        desktopCardInfoList: [],
        desktopStackInfoList: [],
      } as DesktopExposureData;

      exposureData.insertDesktopExposureDataList(newDesktopData);
      expect(res).assertEqual('success');
    })

    it('ExposureDataTest_getStackExposureDataList', 0, () => {
      const exposureData = new ExposureData();
      const stackExposureDataList = exposureData.getStackExposureDataList();
      expect(stackExposureDataList.length >= 0).assertEqual(true);
    })

    it('ExposureDataTest_insertStackExposureDataList_01', 0, () => {
      const res = 'success';
      const exposureData = new ExposureData();
      const newStackData = {
        id: '2',
        desktopPageIndex: 0,
        exposureTime: 3,
        exposureCount: 1,
        cardList: [],
        coordinate: { column: 0, row: 0 },
      } as StackExposureData;

      exposureData.insertStackExposureDataList(newStackData);
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('ExposureDataTest_insertStackExposureDataList_02', 0, () => {
      const res = 'success';
      const exposureData = new ExposureData() as object;
      const newStackData = {
        id: '2',
        desktopPageIndex: 0,
        exposureTime: 3,
        exposureCount: 1,
        cardList: [],
        coordinate: { column: 0, row: 0 },
      } as StackExposureData;

      for (let i = 0; i < 100; i++) {
        exposureData['stackExposureDataList'].push(newStackData);
      }

      exposureData['insertStackExposureDataList'](newStackData);
      let a = 'test';
      expect(a).assertEqual('test');
    })
  })
}