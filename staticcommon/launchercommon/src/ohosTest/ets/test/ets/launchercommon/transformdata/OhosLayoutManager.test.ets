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
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  Level,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { CommonConstants, GridLayoutItemInfo } from '../../../../../../main/ets/TsIndex';
import { NumberConstants } from '@ohos/commonconstants';
import { BaseTransferBean } from '../../../../../../main/ets/transformdata/BaseTransferBean';
import ScreenTransferBean from '../../../../../../main/ets/transformdata/ScreenTransferBean';
import { OhosLayoutManager } from '../../../../../../main/ets/transformdata/OhosLayoutManager';
import { RdbStoreManager } from '../../../../../../main/ets/db/RdbStoreManager';
import { CheckEmptyUtils } from '@ohos/basicutils';

function initGridLayoutItemInfos(): GridLayoutItemInfo[] {
  let layoutInfos: GridLayoutItemInfo[] = [];
  // 应用
  let gridLayoutApp: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutApp.typeId = CommonConstants.TYPE_APP;
  gridLayoutApp.infoId = '60';
  gridLayoutApp.infoName = '设置';
  gridLayoutApp.bundleName = 'com.ohos.settings';
  gridLayoutApp.abilityName = 'com.ohos.settings.MainAbility';
  gridLayoutApp.moduleName = 'phone_settings';
  gridLayoutApp.container = CommonConstants.CONTAINER_DESKTOP;
  gridLayoutApp.badgeNumber = 3;
  gridLayoutApp.page = 0;
  gridLayoutApp.row = 0;
  gridLayoutApp.column = 1;
  gridLayoutApp.area = [1, 1];

  let gridLayoutFolderItem: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutFolderItem.typeId = CommonConstants.TYPE_APP;
  gridLayoutFolderItem.infoId = '50';
  gridLayoutFolderItem.infoName = '应用市场';
  gridLayoutFolderItem.bundleName = 'com.ohos.appgallery';
  gridLayoutFolderItem.abilityName = 'MainAbility';
  gridLayoutFolderItem.moduleName = 'entry';
  gridLayoutFolderItem.container = 48;
  gridLayoutFolderItem.row = 0;
  gridLayoutFolderItem.column = 0;
  gridLayoutFolderItem.area = [1, 1];

  let gridLayoutFolderItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutFolderItem1.typeId = CommonConstants.TYPE_APP;
  gridLayoutFolderItem1.infoId = '51';
  gridLayoutFolderItem1.infoName = '主题';
  gridLayoutFolderItem1.bundleName = 'com.ohos.thememanager';
  gridLayoutFolderItem1.abilityName = 'MainAbility';
  gridLayoutFolderItem1.moduleName = 'entry';
  gridLayoutFolderItem1.container = 48;
  gridLayoutFolderItem1.row = 0;
  gridLayoutFolderItem1.column = 1;
  gridLayoutFolderItem1.area = [1, 1];

  // 文件夹
  let gridLayoutFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutFolder.id = 48;
  gridLayoutFolder.typeId = CommonConstants.TYPE_FOLDER;
  gridLayoutFolder.infoId = '1715654262380';
  gridLayoutFolder.infoName = '应用';
  gridLayoutFolder.bundleName = '';
  gridLayoutFolder.folderName = '应用';
  gridLayoutFolder.abilityName = '';
  gridLayoutFolder.moduleName = '';
  gridLayoutFolder.container = CommonConstants.CONTAINER_DESKTOP;
  gridLayoutFolder.page = 1;
  gridLayoutFolder.row = 4;
  gridLayoutFolder.column = 2;
  gridLayoutFolder.area = [2, 2];
  gridLayoutFolder.layoutInfo = [];
  gridLayoutFolder.layoutInfo[0] = [gridLayoutFolderItem, gridLayoutFolderItem1];

  // 卡片
  let gridLayoutItemCard: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutItemCard.typeId = CommonConstants.TYPE_CARD;
  gridLayoutItemCard.infoId = '72001000';
  gridLayoutItemCard.infoName = 'OneMulTwoRealTimeCard';
  gridLayoutItemCard.bundleName = 'com.ohos.totemweather';
  gridLayoutItemCard.abilityName = 'FormAbility';
  gridLayoutItemCard.moduleName = 'product';
  gridLayoutItemCard.container = CommonConstants.CONTAINER_DESKTOP;
  gridLayoutItemCard.page = 2;
  gridLayoutItemCard.row = 0;
  gridLayoutItemCard.column = 2;
  gridLayoutItemCard.area = [1, 2];

  // 首页天气卡片
  let gridLayoutItemWeatherCard: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutItemWeatherCard.typeId = CommonConstants.TYPE_CARD;
  gridLayoutItemWeatherCard.infoId = '72002000';
  gridLayoutItemWeatherCard.infoName = 'ClockWeatherCard';
  gridLayoutItemWeatherCard.bundleName = 'com.ohos.totemweather';
  gridLayoutItemWeatherCard.abilityName = 'FormAbility';
  gridLayoutItemWeatherCard.moduleName = 'product';
  gridLayoutItemWeatherCard.container = CommonConstants.CONTAINER_DESKTOP;
  gridLayoutItemWeatherCard.page = 0;
  gridLayoutItemWeatherCard.row = 0;
  gridLayoutItemWeatherCard.column = 2;
  gridLayoutItemWeatherCard.area = [2, 4];

  // 组合卡片
  let gridLayoutCombineItemCard1: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutCombineItemCard1.id = 64;
  gridLayoutCombineItemCard1.typeId = CommonConstants.TYPE_CARD;
  gridLayoutCombineItemCard1.infoId = '999';
  gridLayoutCombineItemCard1.bundleName = 'com.ohos.totemweather';
  gridLayoutCombineItemCard1.abilityName = 'FormAbility';
  gridLayoutCombineItemCard1.moduleName = 'product';
  gridLayoutCombineItemCard1.container = 66;
  gridLayoutCombineItemCard1.row = 0;
  gridLayoutCombineItemCard1.column = 1;
  gridLayoutCombineItemCard1.area = [2, 4];

  let gridLayoutCombineItemCard2: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutCombineItemCard2.id = 65;
  gridLayoutCombineItemCard2.typeId = CommonConstants.TYPE_CARD;
  gridLayoutCombineItemCard2.infoId = '998';
  gridLayoutCombineItemCard2.bundleName = 'com.ohos.totemweather';
  gridLayoutCombineItemCard2.abilityName = 'FormAbility';
  gridLayoutCombineItemCard2.moduleName = 'product';
  gridLayoutCombineItemCard2.container = 66;
  gridLayoutCombineItemCard2.row = 0;
  gridLayoutCombineItemCard2.column = 2;
  gridLayoutCombineItemCard2.area = [2, 4];

  let gridLayoutCombineCard: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutCombineCard.id = 66;
  gridLayoutCombineCard.typeId = CommonConstants.TYPE_FORM_COMBINE;
  gridLayoutCombineCard.infoId = '666';
  gridLayoutCombineCard.bundleName = '';
  gridLayoutCombineCard.abilityName = '';
  gridLayoutCombineCard.moduleName = '';
  gridLayoutCombineCard.container = CommonConstants.CONTAINER_DESKTOP;
  gridLayoutCombineCard.page = 3;
  gridLayoutCombineCard.row = 0;
  gridLayoutCombineCard.column = 4;
  gridLayoutCombineCard.area = [2, 4];
  gridLayoutCombineCard.layoutInfo = [];
  gridLayoutCombineCard.layoutInfo[0] = [gridLayoutCombineItemCard1, gridLayoutCombineItemCard2];

  let gridLayoutDockApp: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutDockApp.typeId = CommonConstants.TYPE_APP;
  gridLayoutDockApp.infoId = '74';
  gridLayoutDockApp.infoName = '电话';
  gridLayoutDockApp.bundleName = 'com.ohos.contacts';
  gridLayoutDockApp.abilityName = 'com.ohos.contacts.MainAbility';
  gridLayoutDockApp.moduleName = 'entry';
  gridLayoutDockApp.container = CommonConstants.CONTAINER_DOCK;
  gridLayoutDockApp.appIconId = 100663911;
  gridLayoutDockApp.appLabelId = 100663320;
  gridLayoutDockApp.badgeNumber = 3;
  gridLayoutDockApp.page = 4;
  gridLayoutDockApp.row = 0;
  gridLayoutDockApp.column = 0;
  gridLayoutDockApp.area = [1, 1];

  let gridLayoutDockFolderItem1: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutDockFolderItem1.typeId = CommonConstants.TYPE_APP;
  gridLayoutDockFolderItem1.infoId = '789';
  gridLayoutDockFolderItem1.infoName = '音乐';
  gridLayoutDockFolderItem1.bundleName = 'com.ohos.music';
  gridLayoutDockFolderItem1.abilityName = 'MainAbility';
  gridLayoutDockFolderItem1.moduleName = 'phone';
  gridLayoutDockFolderItem1.container = 66;
  gridLayoutDockFolderItem1.row = 1;
  gridLayoutDockFolderItem1.column = 0;
  gridLayoutDockFolderItem1.area = [1, 1];

  let gridLayoutDockFolderItem2: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutDockFolderItem2.typeId = CommonConstants.TYPE_APP;
  gridLayoutDockFolderItem2.infoId = '789';
  gridLayoutDockFolderItem2.infoName = '音乐';
  gridLayoutDockFolderItem2.bundleName = 'com.ohos.music';
  gridLayoutDockFolderItem2.abilityName = 'MainAbility';
  gridLayoutDockFolderItem2.moduleName = 'phone';
  gridLayoutDockFolderItem2.container = 66;
  gridLayoutDockFolderItem2.row = 1;
  gridLayoutDockFolderItem2.column = 0;
  gridLayoutDockFolderItem2.area = [1, 1];

  // 文件夹
  let gridLayoutDockFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutDockFolder.id = 66;
  gridLayoutDockFolder.typeId = CommonConstants.TYPE_FOLDER;
  gridLayoutDockFolder.infoId = '1715654262380';
  gridLayoutDockFolder.infoName = '应用11';
  gridLayoutDockFolder.bundleName = '';
  gridLayoutDockFolder.folderName = '应用11';
  gridLayoutDockFolder.abilityName = '';
  gridLayoutDockFolder.moduleName = '';
  gridLayoutDockFolder.container = CommonConstants.CONTAINER_DOCK;
  gridLayoutDockFolder.column = 0;
  gridLayoutDockFolder.area = [1, 1];
  gridLayoutDockFolder.layoutInfo = [];
  gridLayoutDockFolder.layoutInfo[0] = [gridLayoutDockFolderItem1, gridLayoutDockFolderItem2];

  layoutInfos = [gridLayoutApp, gridLayoutFolder, gridLayoutItemCard, gridLayoutItemWeatherCard, gridLayoutCombineCard,
    gridLayoutDockApp, gridLayoutDockFolder];
  return layoutInfos;
}


export default function OhosLayoutManagerTest() {
  let mockerRdb: MockKit = new MockKit();
  let layoutInfos: GridLayoutItemInfo[] = initGridLayoutItemInfos();
  let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
  let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
  let transferLayoutManager: OhosLayoutManager = new OhosLayoutManager(fromGrid, toGrid);

  describe('OhosLayoutManagerTest', () => {
    beforeAll((): void => {
      let func1: Function =
        mockerRdb.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().deleteAllGridInfoData);
      when(func1)(ArgumentMatchers.any).afterReturn(Promise.resolve(0));
      let func2: Function =
        mockerRdb.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().insertGridLayoutInfo);
      when(func2)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));
    })
    beforeEach((): void => {
    })
    afterEach((): void => {
    })
    afterAll((): void => {
      mockerRdb.clear(RdbStoreManager.getInstance());
      mockerRdb.clearAll();
    })

    it('test_transferLayout01', Level.LEVEL0, async (done: Function) => {
      try {
        expect(transferLayoutManager instanceof OhosLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it('test_transferLayout02', Level.LEVEL0, async (done: Function) => {
      try {
        await transferLayoutManager.transferLayout(layoutInfos);
        expect(transferLayoutManager instanceof OhosLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it('test_transferLayout03', Level.LEVEL0, async (done: Function) => {
      let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayout.typeId = 0;
      gridLayout.infoId = 'gridLayoutInfoId';
      gridLayout.appName = 'gridLayoutAppName';
      gridLayout.bundleName = 'gridLayoutBundleName';
      gridLayout.keyName = 'gridLayoutKeyName';
      gridLayout.folderName = 'gridLayoutFolderName'
      gridLayout.abilityName = 'gridLayoutAbilityName';
      gridLayout.moduleName = 'gridLayoutModuleName';
      gridLayout.appIconId = 1;
      gridLayout.appLabelId = 2;
      gridLayout.badgeNumber = 3;
      gridLayout.row = 4;
      gridLayout.column = 5;
      gridLayout.area = [2, 2];
      gridLayout.areaType = 0;
      try {
        let result1: boolean = await transferLayoutManager.transferLayout([gridLayout]);
        expect(result1).not().assertUndefined();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it("test_fillBackExtraElements_01", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosLayoutManager = new OhosLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD,
        isNeedRestoreFromBackup: true,
        bundleName: 'bundleName',
        column: 1,
        area: [10, 10]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean, transferBean, transferBean],
        moveToNextPage: [transferBean, transferBean, transferBean],
        usedCellCnt: 100,
        abilityFormUsedCellCnt: 24
      } as ScreenTransferBean;
      try {
        transferLayoutManager['fillBackExtraElements'](screenItemInfo);
        expect(transferLayoutManager instanceof OhosLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it("test_fillBackExtraElements_02", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosLayoutManager = new OhosLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD,
        isNeedRestoreFromBackup: true,
        bundleName: 'bundleName',
        column: 1,
        area: [10, 10]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean, transferBean, transferBean],
        moveToNextPage: [transferBean, transferBean, transferBean],
        usedCellCnt: 100,
        abilityFormUsedCellCnt: 24
      } as ScreenTransferBean;
      try {
        transferLayoutManager['fillBackExtraElements'](screenItemInfo);
        expect(transferLayoutManager instanceof OhosLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it("test_findAreafromToGrid_01", 0, async (done: Function) => {
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD,
        isNeedRestoreFromBackup: true,
        bundleName: 'bundleName',
        column: 1,
      } as BaseTransferBean;
      try {
        let occupied: boolean[][] = [[true]];
        let result: boolean = transferLayoutManager.findAreafromToGrid(occupied, transferBean);
        expect(result).assertEqual(false);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it("test_findAreafromToGrid_02", 0, async (done: Function) => {
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD,
        isNeedRestoreFromBackup: true,
        bundleName: 'bundleName',
        column: 1,
        area: [8, 8]
      } as BaseTransferBean;
      try {
        let occupied: boolean[][] = [[false, false]];
        let result: boolean = transferLayoutManager.findAreafromToGrid(occupied, transferBean);
        expect(result).assertEqual(false);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it("test_findAreafromToGrid_03", 0, () => {
      try {
        let transferBean = {
          layoutWeight: 1,
          page: 1,
          row: NumberConstants.CONSTANT_NUMBER_100,
          typeId: CommonConstants.TYPE_ADD,
          isNeedRestoreFromBackup: true,
          bundleName: 'bundleName',
          column: 1,
          area: [0, 1]
        } as BaseTransferBean;
        let occupied: boolean[][] = [[false, false]];
        let result: boolean = transferLayoutManager.findAreafromToGrid(occupied, transferBean);
        expect(result).assertEqual(true);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_findAreafromToGrid_04", 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let transferBean = {
          layoutWeight: 1,
          page: 1,
          row: NumberConstants.CONSTANT_NUMBER_100,
          typeId: CommonConstants.TYPE_ADD,
          isNeedRestoreFromBackup: true,
          bundleName: 'bundleName',
          column: 1,
          area: [0, 1]
        } as BaseTransferBean;
        let occupied: boolean[][] = [[false, false]];
        let result: boolean = transferLayoutManager.findAreafromToGrid(occupied, transferBean);
        expect(result).assertEqual(true);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it("test_findAreafromToGrid_05", 0, () => {
      try {
        let transferBean = {
          layoutWeight: 1,
          page: 1,
          row: NumberConstants.CONSTANT_NUMBER_100,
          typeId: CommonConstants.TYPE_ADD,
          isNeedRestoreFromBackup: true,
          bundleName: 'bundleName',
          column: 1,
          area: [0, 1]
        } as BaseTransferBean;
        let occupied: boolean[][] = [[false, false]];

        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, 0];
        let transferLayoutManager: OhosLayoutManager = new OhosLayoutManager(fromGrid, toGrid);
        let result: boolean = transferLayoutManager.findAreafromToGrid(occupied, transferBean);
        expect(result).assertEqual(true);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_findAreafromToGrid_06", 0, () => {
      try {
        let transferBean = {
          layoutWeight: 1,
          page: 1,
          row: NumberConstants.CONSTANT_NUMBER_100,
          typeId: CommonConstants.TYPE_ADD,
          isNeedRestoreFromBackup: true,
          bundleName: 'bundleName',
          column: 1,
          area: [0, 1]
        } as BaseTransferBean;
        let occupied: boolean[][] = [[true, true]];
        let result: boolean = transferLayoutManager.findAreafromToGrid(occupied, transferBean);
        expect(result).assertEqual(true);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_fillBackExtraElements_03", 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: OhosLayoutManager = new OhosLayoutManager(fromGrid, toGrid);
        let transferBean = {
          layoutWeight: 1,
          page: 1,
          row: NumberConstants.CONSTANT_NUMBER_100,
          typeId: CommonConstants.TYPE_ADD,
          isNeedRestoreFromBackup: true,
          bundleName: 'bundleName',
          column: 1,
          area: [10, 10]
        } as BaseTransferBean;
        let screenItemInfo = {
          page: 1,
          occupied: [[true]],
          iconUsedCellCnt: 0,
          folderUsedCellCnt: 0,
          children: [transferBean, transferBean, transferBean],
          moveToNextPage: [],
          usedCellCnt: 100,
          abilityFormUsedCellCnt: 24
        } as ScreenTransferBean;
        transferLayoutManager['fillBackExtraElements'](screenItemInfo);
        expect(transferLayoutManager instanceof OhosLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_fillBackExtraElements_04", 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: OhosLayoutManager = new OhosLayoutManager(fromGrid, toGrid);
        let transferBean = {
          layoutWeight: 1,
          page: 1,
          row: NumberConstants.CONSTANT_NUMBER_100,
          typeId: CommonConstants.TYPE_ADD,
          isNeedRestoreFromBackup: true,
          bundleName: 'bundleName',
          column: 1,
          area: [10, 10]
        } as BaseTransferBean;
        let screenItemInfo = {
          page: 1,
          occupied: [[true]],
          iconUsedCellCnt: 0,
          folderUsedCellCnt: 0,
          children: [transferBean, transferBean, transferBean],
          moveToNextPage: [],
          usedCellCnt: 100,
          abilityFormUsedCellCnt: 24
        } as ScreenTransferBean;
        transferLayoutManager['fillBackExtraElements'](screenItemInfo);
        expect(transferLayoutManager instanceof OhosLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })
  })
}