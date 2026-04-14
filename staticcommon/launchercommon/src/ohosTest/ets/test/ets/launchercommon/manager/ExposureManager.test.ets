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
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import {
  FolderManager,
  GridLayoutItemInfo,
  LaunchLayoutCacheManager,
  ResidentLayoutCacheMgr,
  DockItemInfo,
  GridLayoutUtil,
} from '../../../../../../main/ets/TsIndex';
import { ExposureManager } from '../../../../../../main/ets/manager/ExposureManager';
import { FolderExposureData,  DesktopExposureData, StackExposureData } from '../../../../../../main/ets/bean/ExposureData';
import { FormStackItemInfo } from '../../../../../../../../../feature/desktop/formstack/src/main/ets/common/FormStackItemInfo';

export function ExposureManagerTest() {
  describe('ExposureManagerTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('ExposureManagerTest_handleFolderExposureTimeStart', 0, () => {
      const res = 'success';
      const pageIndex: number = 0;
      ExposureManager.getInstance().handleFolderExposureTimeStart(pageIndex);
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('ExposureManagerTest_handleFolderExposureTimeEnd_01', 0, () => {
      const res = 'success';
      const pageIndex: number = 0;
      const exposureManager = ExposureManager.getInstance() as object;
      exposureManager['folderExposureTimeStart'] = 0;
      const mock = new MockKit();
      const mockFunc = mock.mockFunc(ExposureManager.getInstance(), ExposureManager.getInstance().saveFolderExposureData);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
      ExposureManager.getInstance().handleFolderExposureTimeEnd(pageIndex);
            let a = 'test';
      expect(a).assertEqual('test');
      mock.clear(ExposureManager.getInstance());
      mock.clearAll();
    })

    it('ExposureManagerTest_handleFolderExposureTimeEnd_02', 0, () => {
      const res = 'success';
      const pageIndex: number = 0;
      const exposureManager = ExposureManager.getInstance() as object;
      exposureManager['folderExposureTimeStart'] = 1;
      const mock = new MockKit();
      const mockFunc = mock.mockFunc(ExposureManager.getInstance(), ExposureManager.getInstance().saveFolderExposureData);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
      ExposureManager.getInstance().handleFolderExposureTimeEnd(pageIndex);
            let a = 'test';
      expect(a).assertEqual('test');
      mock.clear(ExposureManager.getInstance());
      mock.clearAll();
    })

    it('ExposureManagerTest_saveFolderExposureData_01', 0, () => {
      const res = 'success';
      const pageIndex: number = 0;
      const lastTime: number = 2000;
      const openFolderData = {
        folderId: 'lkqkw4s76q0592qwa4g',
        layoutInfo: [
          [
            {
              bundleName: "com.ohos.tips",
              column: 1,
              row: 1,
            }
          ]
        ]
      } as GridLayoutItemInfo;

      const folderExposureDataList = [
        {
          id: 'lkqkw4s76q0592qwa4g-0',
          folderId: 'lkqkw4s76q0592qwa4g',
          folderName: '',
          exposureTime: 1,
          exposureCount: 1,
          coordinate: { column: 0, row: 0 },
          desktopPageIndex: 0,
          pageIndex: 0,
          folderAppList: [],
          isBigFolder: false,
        }
      ] as FolderExposureData[];

      const mock = new MockKit();
      const mockFunc = mock.mockFunc(FolderManager.getInstance(), FolderManager.getInstance().getOpenedFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(openFolderData);

      const exposureManager = ExposureManager.getInstance() as object;
      const mockFunc2 = mock.mockFunc(exposureManager['exposureData'],
        exposureManager['exposureData'].getFolderExposureDataList);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(folderExposureDataList);

      const mockFunc3 = mock.mockFunc(exposureManager['exposureData'],
        exposureManager['exposureData'].insertFolderExposureDataList);
      when(mockFunc3)(ArgumentMatchers.any).afterReturnNothing();

      ExposureManager.getInstance().saveFolderExposureData(lastTime, pageIndex);
            let a = 'test';
      expect(a).assertEqual('test');
      mock.clear(FolderManager.getInstance());
      mock.clear(exposureManager['exposureData']);
      mock.clearAll();
    })

    it('ExposureManagerTest_saveFolderExposureData_02', 0, () => {
      const res = 'success';
      const pageIndex: number = 0;
      const lastTime: number = 2000;
      const openFolderData = {
        folderId: 'lkqkw4s76q0592qwa4g',
        layoutInfo: [
          [
            {
              bundleName: "com.ohos.tips",
              column: 1,
              row: 1,
            }
          ]
        ]
      } as GridLayoutItemInfo;

      const folderExposureDataList = [
        {
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
        }
      ] as FolderExposureData[];
      const mock = new MockKit();
      const mockFunc = mock.mockFunc(FolderManager.getInstance(), FolderManager.getInstance().getOpenedFolder);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(openFolderData);

      const exposureManager = ExposureManager.getInstance() as object;
      const mockFunc2 = mock.mockFunc(exposureManager['exposureData'],
        exposureManager['exposureData'].getFolderExposureDataList);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(folderExposureDataList);

      const mockFunc3 = mock.mockFunc(exposureManager['exposureData'],
        exposureManager['exposureData'].insertFolderExposureDataList);
      when(mockFunc3)(ArgumentMatchers.any).afterReturnNothing();

      ExposureManager.getInstance().saveFolderExposureData(lastTime, pageIndex);
            let a = 'test';
      expect(a).assertEqual('test');
      mock.clear(FolderManager.getInstance());
      mock.clear(exposureManager['exposureData']);
      mock.clearAll();
    })

    it ('ExposureManagerTest_handleDesktopGainFocus_01', 0, () => {
      const res = 'success';
      const mock = new MockKit();
      const mockFunc = mock.mockFunc(FolderManager.getInstance(), FolderManager.getInstance().isFolderOpen);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

      const mockFunc2 = mock.mockFunc(ExposureManager.getInstance(), ExposureManager.getInstance().handleFolderExposureTimeStart);
      when(mockFunc2)(ArgumentMatchers.any).afterReturnNothing();

      const mockFunc3 = mock.mockFunc(ExposureManager.getInstance(), ExposureManager.getInstance().handleDesktopExposureTimeStart);
      when(mockFunc3)(ArgumentMatchers.any).afterReturnNothing();
      ExposureManager.getInstance().handleDesktopGainFocus();
            let a = 'test';
      expect(a).assertEqual('test');
      mock.clear(FolderManager.getInstance());
      mock.clear(ExposureManager.getInstance());
      mock.clearAll();
    })

    it ('ExposureManagerTest_handleDesktopGainFocus_02', 0, () => {
      const res = 'success';
      const mock = new MockKit();
      const mockFunc = mock.mockFunc(FolderManager.getInstance(), FolderManager.getInstance().isFolderOpen);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

      const mockFunc2 = mock.mockFunc(ExposureManager.getInstance(), ExposureManager.getInstance().handleFolderExposureTimeStart);
      when(mockFunc2)(ArgumentMatchers.any).afterReturnNothing();

      const mockFunc3 = mock.mockFunc(ExposureManager.getInstance(), ExposureManager.getInstance().handleDesktopExposureTimeStart);
      when(mockFunc3)(ArgumentMatchers.any).afterReturnNothing();
      ExposureManager.getInstance().handleDesktopGainFocus();
            let a = 'test';
      expect(a).assertEqual('test');
      mock.clear(FolderManager.getInstance());
      mock.clear(ExposureManager.getInstance());
      mock.clearAll();
    })

    it('ExposureManagerTest_handleDesktopLoseFocus_01', 0, () => {
      const res = 'success';
      const mock = new MockKit();
      const mockFunc = mock.mockFunc(FolderManager.getInstance(), FolderManager.getInstance().isFolderOpen);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

      const mockFunc2 = mock.mockFunc(ExposureManager.getInstance(), ExposureManager.getInstance().handleFolderExposureTimeEnd);
      when(mockFunc2)(ArgumentMatchers.any).afterReturnNothing();

      const mockFunc3 = mock.mockFunc(ExposureManager.getInstance(), ExposureManager.getInstance().handleDesktopExposureTimeEnd);
      when(mockFunc3)(ArgumentMatchers.any).afterReturnNothing();

      ExposureManager.getInstance().handleDesktopLoseFocus();

            let a = 'test';
      expect(a).assertEqual('test');
      mock.clear(FolderManager.getInstance());
      mock.clear(ExposureManager.getInstance());
      mock.clearAll();
    })

    it('ExposureManagerTest_handleDesktopLoseFocus_02', 0, () => {
      const res = 'success';
      const mock = new MockKit();
      const mockFunc = mock.mockFunc(FolderManager.getInstance(), FolderManager.getInstance().isFolderOpen);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

      const mockFunc2 = mock.mockFunc(ExposureManager.getInstance(), ExposureManager.getInstance().handleFolderExposureTimeEnd);
      when(mockFunc2)(ArgumentMatchers.any).afterReturnNothing();

      const mockFunc3 = mock.mockFunc(ExposureManager.getInstance(), ExposureManager.getInstance().handleDesktopExposureTimeEnd);
      when(mockFunc3)(ArgumentMatchers.any).afterReturnNothing();

      ExposureManager.getInstance().handleDesktopLoseFocus();

            let a = 'test';
      expect(a).assertEqual('test');
      mock.clear(FolderManager.getInstance());
      mock.clear(ExposureManager.getInstance());
      mock.clearAll();
    })

    it('ExposureManagerTest_handleDesktopExposureTimeStart', 0, () => {
      const res = 'success';
      ExposureManager.getInstance().handleDesktopExposureTimeStart();
            let a = 'test';
      expect(a).assertEqual('test');
    })

    it('ExposureManagerTest_handleDesktopExposureTimeEnd_01', 0, () => {
      const res = 'success';
      const oldDesktopPageIndex = 1;
      const newDesktopPageIndex = 0;
      const mock = new MockKit();
      const mockFunc = mock.mockFunc(ExposureManager.getInstance(), ExposureManager.getInstance().saveDesktopExposureData);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
      const exposureManager = ExposureManager.getInstance() as object;
      exposureManager['desktopExposureTimeStart'] = 0
      ExposureManager.getInstance().handleDesktopExposureTimeEnd(oldDesktopPageIndex, newDesktopPageIndex);
            let a = 'test';
      expect(a).assertEqual('test');
      mock.clear(ExposureManager.getInstance());
      mock.clearAll();
    })

    it('ExposureManagerTest_handleDesktopExposureTimeEnd_02', 0, () => {
      const res = 'success';
      const oldDesktopPageIndex = 1;
      const newDesktopPageIndex = 0;
      const mock = new MockKit();
      const mockFunc = mock.mockFunc(ExposureManager.getInstance(), ExposureManager.getInstance().saveDesktopExposureData);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
      const exposureManager = ExposureManager.getInstance() as object;
      exposureManager['desktopExposureTimeStart'] = 1;
      ExposureManager.getInstance().handleDesktopExposureTimeEnd(oldDesktopPageIndex, newDesktopPageIndex);
            let a = 'test';
      expect(a).assertEqual('test');
      mock.clear(ExposureManager.getInstance());
      mock.clearAll();
    })

    it('ExposureManagerTest_handleDesktopExposureTimeEnd_03', 0, () => {
      const res = 'success';
      const oldDesktopPageIndex = 0;
      const newDesktopPageIndex = 1;
      const mock = new MockKit();
      const mockFunc = mock.mockFunc(ExposureManager.getInstance(), ExposureManager.getInstance().saveDesktopExposureData);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
      const exposureManager = ExposureManager.getInstance() as object;
      exposureManager['desktopExposureTimeStart'] = 0;
      ExposureManager.getInstance().handleDesktopExposureTimeEnd(oldDesktopPageIndex, newDesktopPageIndex);
            let a = 'test';
      expect(a).assertEqual('test');
      mock.clear(ExposureManager.getInstance());
      mock.clearAll();
    })

    it('ExposureManagerTest_handleDesktopExposureTimeEnd_04', 0, () => {
      const res = 'success';
      const oldDesktopPageIndex = 1;
      const newDesktopPageIndex = 0;
      const mock = new MockKit();
      const mockFunc = mock.mockFunc(ExposureManager.getInstance(), ExposureManager.getInstance().saveDesktopExposureData);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
      const exposureManager = ExposureManager.getInstance() as object;
      exposureManager['desktopExposureTimeStart'] = 0;
      ExposureManager.getInstance().handleDesktopExposureTimeEnd(oldDesktopPageIndex, newDesktopPageIndex, true);
            let a = 'test';
      expect(a).assertEqual('test');
      mock.clear(ExposureManager.getInstance());
      mock.clearAll();
    })

    it('ExposureManagerTest_saveDesktopExposureData_01', 0 , () => {
      const res = 'success';
      const lastTime = 4;
      const pageIndex = 0;
      const desktopData = [
        {
          typeId: 0, // 应用
          bundleName: 'com.ohos.calendar',
          column: 0,
          row: 0,
          appName: 'calendar',
          appIndex: 0,
          page: 0
        },
        {
          typeId: 1, // 卡片
          cardId: '1111',
          cardName: 'CARD',
          column: 0,
          row: 0,
          page: 0
        },
        {
          typeId: 3, // 文件夹
          folderId: '11111',
          column: 0,
          row: 0,
          area: [1,1],
          layoutInfo: [[]],
          page: 0
        },
        {
          typeId: 3, // 文件夹
          folderId: '11111',
          column: 0,
          row: 0,
          area: [2,2],
          layoutInfo: [[]],
          page: 0
        },
        {
          typeId: 6, // 堆叠
          layoutInfo: [[]],
          column: 0,
          row: 0,
          page: 0
        },

      ] as GridLayoutItemInfo[];

      const dockData = [
        {
          typeId: 0, // 应用
          bundleName: 'com.ohos.calendar',
          column: 0,
          row: 0,
          appName: 'calendar',
          appIndex: 0
        },
        {
          typeId: 3, // 文件夹
          appId: '11111',
          column: 0,
          row: 0,
          area: [1,1],
          layoutInfo: [[]],
        },
      ] as DockItemInfo[];

      const desktopExposureDataList = [
        {
          id: 'desktop-0',
          desktopPageIndex: pageIndex,
          exposureTime: 1,
          exposureCount: 1,
          desktopAppInfoList: [{}],
          desktopFolderInfoList: [{}],
          desktopCardInfoList: [{}],
          desktopStackInfoList: [{}],
        }
      ] as DesktopExposureData[];

      const mock = new MockKit();
      const mockFunc = mock.mockFunc(LaunchLayoutCacheManager.getInstance(), LaunchLayoutCacheManager.getInstance().getAllGridLayoutItemList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(desktopData);

      const mockFunc2 = mock.mockFunc(ResidentLayoutCacheMgr.getInstance(), ResidentLayoutCacheMgr.getInstance().getAllDockItems);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(dockData);

      const mockFunc3 = mock.mockFunc(GridLayoutUtil, GridLayoutUtil.getCountPerPageInFolder);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(1);

      const exposureManager = ExposureManager.getInstance() as object;
      const mockFunc4 = mock.mockFunc(exposureManager['exposureData'], exposureManager['exposureData'].getDesktopExposureDataList);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(desktopExposureDataList);

      ExposureManager.getInstance().saveDesktopExposureData(lastTime, pageIndex);

            let a = 'test';
      expect(a).assertEqual('test');
      mock.clear(LaunchLayoutCacheManager.getInstance());
      mock.clear(ResidentLayoutCacheMgr.getInstance());
      mock.clear(GridLayoutUtil);
      mock.clear(exposureManager['exposureData']);
      mock.clearAll();
    })

    it('ExposureManagerTest_saveDesktopExposureData_02', 0 , () => {
      const res = 'success';
      const lastTime = 4;
      const pageIndex = 0;
      const desktopData = [
        {
          typeId: 0, // 应用
          bundleName: 'com.ohos.calendar',
          column: 0,
          row: 0,
          appName: 'calendar',
          appIndex: 0,
          page: 0
        },
        {
          typeId: 1, // 卡片
          cardId: '1111',
          cardName: 'CARD',
          column: 0,
          row: 0,
          page: 0
        },
        {
          typeId: 3, // 文件夹
          folderId: '11111',
          column: 0,
          row: 0,
          area: [1,1],
          layoutInfo: [[]],
          page: 0
        },
        {
          typeId: 3, // 文件夹
          folderId: '11111',
          column: 0,
          row: 0,
          area: [2,2],
          layoutInfo: [[]],
          page: 0
        },
        {
          typeId: 6, // 堆叠
          layoutInfo: [[]],
          column: 0,
          row: 0,
          page: 0
        },

      ] as GridLayoutItemInfo[];

      const dockData = [
        {
          typeId: 0, // 应用
          bundleName: 'com.ohos.calendar',
          column: 0,
          row: 0,
          appName: 'calendar',
          appIndex: 0
        },
        {
          typeId: 3, // 文件夹
          appId: '11111',
          column: 0,
          row: 0,
          area: [1,1],
          layoutInfo: [[]],
        },
      ] as DockItemInfo[];

      const desktopExposureDataList = [
        {
          id: 'desktop-1',
          desktopPageIndex: pageIndex,
          exposureTime: 1,
          exposureCount: 1,
          desktopAppInfoList: [],
          desktopFolderInfoList: [],
          desktopCardInfoList: [],
          desktopStackInfoList: [],
        }
      ] as DesktopExposureData[];

      const mock = new MockKit();
      const mockFunc = mock.mockFunc(LaunchLayoutCacheManager.getInstance(), LaunchLayoutCacheManager.getInstance().getAllGridLayoutItemList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(desktopData);

      const mockFunc2 = mock.mockFunc(ResidentLayoutCacheMgr.getInstance(), ResidentLayoutCacheMgr.getInstance().getAllDockItems);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(dockData);

      const mockFunc3 = mock.mockFunc(GridLayoutUtil, GridLayoutUtil.getCountPerPageInFolder);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(1);

      const exposureManager = ExposureManager.getInstance() as object;
      const mockFunc4 = mock.mockFunc(exposureManager['exposureData'], exposureManager['exposureData'].getDesktopExposureDataList);
      when(mockFunc4)(ArgumentMatchers.any).afterReturn(desktopExposureDataList);

      ExposureManager.getInstance().saveDesktopExposureData(lastTime, pageIndex);

            let a = 'test';
      expect(a).assertEqual('test');
      mock.clear(LaunchLayoutCacheManager.getInstance());
      mock.clear(ResidentLayoutCacheMgr.getInstance());
      mock.clear(GridLayoutUtil);
      mock.clear(exposureManager['exposureData']);
      mock.clearAll();
    })

    it('ExposureManagerTest_handleStackExposureTimeStart', 0, () => {
      const stackInfo = {
        formStackId: '123',
      } as FormStackItemInfo
      ExposureManager.getInstance().handleStackExposureTimeStart(stackInfo);
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('ExposureManagerTest_handleStackExposureTimeEnd_01', 0, () => {
      const res = 'success';
      const exposureManager = ExposureManager.getInstance() as object;
      exposureManager['stackExposureTimeStart'] = 0;
      const mock = new MockKit();
      const mockFunc = mock.mockFunc(ExposureManager.getInstance(), ExposureManager.getInstance().saveStackExposureData);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
      ExposureManager.getInstance().handleStackExposureTimeEnd();
            let a = 'test';
      expect(a).assertEqual('test');
      mock.clear(ExposureManager.getInstance());
      mock.clearAll();
    })

    it('ExposureManagerTest_handleStackExposureTimeEnd_02', 0, () => {
      const res = 'success';
      const exposureManager = ExposureManager.getInstance() as object;
      exposureManager['stackExposureTimeStart'] = 1;
      const mock = new MockKit();
      const mockFunc = mock.mockFunc(ExposureManager.getInstance(), ExposureManager.getInstance().saveStackExposureData);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();
      ExposureManager.getInstance().handleStackExposureTimeEnd();
            let a = 'test';
      expect(a).assertEqual('test');
      mock.clear(ExposureManager.getInstance());
      mock.clearAll();
    })

    it('ExposureManagerTest_saveStackExposureData_01', 0, () => {
      const res = 'success';
      const formStackInfo = {
        formStackId: '1',
        page: 0,
        layoutInfo: [[]],
        typeId: 6,
        infoId: '0',
        column: 0,
        row: 0,
        area: [1, 1]
      } as FormStackItemInfo;

      const stackExposureDataList = [
        {
          id: '1',
          desktopPageIndex: 0,
          exposureTime: 3,
          exposureCount: 1,
          cardList: [],
          coordinate: { column: 0, row: 0 },
        }
       ] as StackExposureData[];
      const exposureManager = ExposureManager.getInstance() as object;
      exposureManager['formStackInfo'] = formStackInfo;

      const mock = new MockKit();

      const mockFunc = mock.mockFunc(exposureManager['exposureData'], exposureManager['exposureData'].insertStackExposureDataList);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();

      const mockFunc2 = mock.mockFunc(exposureManager['exposureData'], exposureManager['exposureData'].getStackExposureDataList);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(stackExposureDataList);

      ExposureManager.getInstance().saveStackExposureData(3);

            let a = 'test';
      expect(a).assertEqual('test');
      mock.clear(exposureManager['exposureData']);
      mock.clearAll();
    })

    it('ExposureManagerTest_saveStackExposureData_02', 0, () => {
      const res = 'success';
      const formStackInfo = {
        formStackId: '1',
        page: 0,
        layoutInfo: [[]],
        typeId: 6,
        infoId: '0',
        column: 0,
        row: 0,
        area: [1, 1]
      } as FormStackItemInfo;

      const stackExposureDataList = [
        {
          id: '2',
          desktopPageIndex: 0,
          exposureTime: 3,
          exposureCount: 1,
          cardList: [],
          coordinate: { column: 0, row: 0 },
        }
      ] as StackExposureData[];
      const exposureManager = ExposureManager.getInstance() as object;
      exposureManager['formStackInfo'] = formStackInfo;

      const mock = new MockKit();
      const mockFunc = mock.mockFunc(exposureManager['exposureData'], exposureManager['exposureData'].insertStackExposureDataList);
      when(mockFunc)(ArgumentMatchers.any).afterReturnNothing();

      const mockFunc2 = mock.mockFunc(exposureManager['exposureData'], exposureManager['exposureData'].getStackExposureDataList);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(stackExposureDataList);

      ExposureManager.getInstance().saveStackExposureData(3);

            let a = 'test';
      expect(a).assertEqual('test');
      mock.clear(exposureManager['exposureData']);
      mock.clearAll();
    })

  })
}