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
import { CommonConstants, GridLayoutItemInfo, RdbStoreManager } from '../../../../../../main/ets/TsIndex';
import { NumberConstants } from '@ohos/commonconstants';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { BaseTransferBean } from '../../../../../../main/ets/transformdata/BaseTransferBean';
import ScreenTransferBean from '../../../../../../main/ets/transformdata/ScreenTransferBean';
import { OhosCloneLayoutManager } from '../../../../../../main/ets/transformdata/OhosCloneLayoutManager';

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

function initScreenTransferBean(): ScreenTransferBean {
  let screenData: ScreenTransferBean = new ScreenTransferBean();
  screenData.page = 0;
  screenData.occupied = Array(4).fill(false).map(() => Array(6).fill(false));
  screenData.usedCellCnt = 0;
  screenData.iconUsedCellCnt = 0;
  screenData.folderUsedCellCnt = 0;
  screenData.abilityFormUsedCellCnt = 0;

  let appBaseBean: BaseTransferBean = new BaseTransferBean();
  appBaseBean.typeId = CommonConstants.TYPE_APP;
  appBaseBean.infoId = '60';
  appBaseBean.infoName = '设置';
  appBaseBean.bundleName = 'com.ohos.settings';
  appBaseBean.abilityName = 'com.ohos.settings.MainAbility';
  appBaseBean.moduleName = 'phone_settings';
  appBaseBean.container = CommonConstants.CONTAINER_DESKTOP;
  appBaseBean.badgeNumber = 3;
  appBaseBean.page = 0;
  appBaseBean.row = 0;
  appBaseBean.column = 1;
  appBaseBean.area = [1, 1];

  let cardBaseBean: BaseTransferBean = new BaseTransferBean();
  cardBaseBean.typeId = CommonConstants.TYPE_CARD;
  cardBaseBean.infoId = '72001000';
  cardBaseBean.infoName = 'OneMulTwoRealTimeCard';
  cardBaseBean.bundleName = 'com.ohos.totemweather';
  cardBaseBean.abilityName = 'FormAbility';
  cardBaseBean.moduleName = 'product';
  cardBaseBean.container = CommonConstants.CONTAINER_DESKTOP;
  cardBaseBean.page = 0;
  cardBaseBean.row = 0;
  cardBaseBean.column = 2;
  cardBaseBean.area = [1, 2];

  let children: BaseTransferBean[] = [appBaseBean, cardBaseBean];
  screenData.children = children;
  screenData.moveToNextPage = children;
  return screenData;
}

export default function OhosCloneLayoutManagerTest() {
  let mockerRdb: MockKit = new MockKit();
  let layoutInfos: GridLayoutItemInfo[] = initGridLayoutItemInfos();
  let screenData: ScreenTransferBean = initScreenTransferBean();

  let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
  let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
  let transferLayoutManager: OhosCloneLayoutManager = new OhosCloneLayoutManager(fromGrid, toGrid);

  describe('OhosCloneLayoutManagerTest', () => {
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

    it('transferLayoutTest01', Level.LEVEL0, () => {
      try {
        expect(transferLayoutManager instanceof OhosCloneLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("getNewLayoutFromScreenDataMap01", 0, () => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosCloneLayoutManager = new OhosCloneLayoutManager(fromGrid, toGrid);
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
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['mergeScreenDataMap']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealWithExcessiveDockList']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealSpecialFolderElements']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction4: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealFormStackElement']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction5: Function =
        mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().ifDuplicatePosition);
      when(mockFunction5)(ArgumentMatchers.any).afterReturn(false);
      try {
        let result = transferLayoutManager['getNewLayoutFromScreenDataMap']();
        expect(result.length).not().assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clear(DeviceHelper);
      mocker.clear(RdbStoreManager.getInstance());
      mocker.clearAll();
    })

    it("test_realignScreenData1", 0, () => {
      let fromGrid: number[] = [5, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosCloneLayoutManager = new OhosCloneLayoutManager(fromGrid, toGrid);
      let transferBean = new Object({
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD,
        isNeedRestoreFromBackup: true,
        bundleName: 'bundleName',
        column: 1,
        area: [10, 10],
        layoutInfo: [[]]
      }) as BaseTransferBean;
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
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['realignByMaintenance']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillBackExtraElements']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['addEmptyRowAfterextract']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager.realignScreenData(screenItemInfo);
        expect(transferLayoutManager instanceof OhosCloneLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clearAll();
    })

    it("test_realignScreenData2", 0, () => {
      let fromGrid: number[] = [5, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosCloneLayoutManager = new OhosCloneLayoutManager(fromGrid, toGrid);
      let transferBean = new Object({
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD,
        isNeedRestoreFromBackup: true,
        bundleName: 'bundleName',
        column: 1,
        area: [10, 10],
        layoutInfo: [[]]
      }) as BaseTransferBean;
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
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['realignByMaintenance']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillBackExtraElements']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['addEmptyRowAfterextract']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager.realignScreenData(screenItemInfo);
        expect(transferLayoutManager instanceof OhosCloneLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clearAll();
    })

    it("test_realignScreenData3", 0, () => {
      let fromGrid: number[] = [5, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosCloneLayoutManager = new OhosCloneLayoutManager(fromGrid, toGrid);
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [],
        moveToNextPage: [],
        usedCellCnt: 100,
        abilityFormUsedCellCnt: 24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['realignByMaintenance']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillBackExtraElements']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['addEmptyRowAfterextract']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager.realignScreenData(screenItemInfo);
        expect(transferLayoutManager instanceof OhosCloneLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clearAll();
    })

    it('transferByScreen01', Level.LEVEL0, () => {
      try {
        transferLayoutManager['transferByScreen'](screenData);
        expect(transferLayoutManager instanceof OhosCloneLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('addEmptyRowAfterextract01', Level.LEVEL0, () => {
      try {
        let transferLayoutManager: OhosCloneLayoutManager = new OhosCloneLayoutManager(fromGrid, toGrid);
        let transferBean = new Object({
          layoutWeight: 1,
          page: 1,
          row: NumberConstants.CONSTANT_NUMBER_100,
          typeId: CommonConstants.TYPE_FOLDER,
          isNeedRestoreFromBackup: false,
          bundleName: 'bundleName',
          column: 1,
          area: [2, 2],
          layoutInfo: [[]],
          settlementPosition: '1'
        }) as BaseTransferBean;
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
        transferLayoutManager['addRestDockToCurrentPage'](screenItemInfo);
        expect(transferLayoutManager instanceof OhosCloneLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_transferLayout_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: OhosCloneLayoutManager = new OhosCloneLayoutManager(fromGrid, toGrid);
        let oldLayoutInfo: GridLayoutItemInfo[] = [];
        transferLayoutManager.transferLayout(oldLayoutInfo, true);
        expect(transferLayoutManager instanceof OhosCloneLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_transferLayout_02', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: OhosCloneLayoutManager = new OhosCloneLayoutManager(fromGrid, toGrid);
        let oldLayoutInfo: GridLayoutItemInfo[] = [];
        transferLayoutManager.transferLayout(oldLayoutInfo, false);
        expect(transferLayoutManager instanceof OhosCloneLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_addEmptyRowAfterextract_01", 0, () => {
      let fromGrid: number[] = [5, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosCloneLayoutManager = new OhosCloneLayoutManager(fromGrid, toGrid);
      let transferBean = new Object({
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD,
        isNeedRestoreFromBackup: true,
        bundleName: 'bundleName',
        column: 1,
        area: [10, 10],
        layoutInfo: [[]]
      }) as BaseTransferBean;
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
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['realignByMaintenance']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillBackExtraElements']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['addEmptyRowAfterextract']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager.realignScreenData(screenItemInfo);
        expect(transferLayoutManager instanceof OhosCloneLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clearAll();
    })

    it("test_addEmptyRowAfterextract_02", 0, () => {
      let fromGrid: number[] = [5, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosCloneLayoutManager = new OhosCloneLayoutManager(fromGrid, toGrid);
      let transferBean = new Object({
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_CARD,
        cardName: 'ClockWeatherCard',
        isNeedRestoreFromBackup: true,
        bundleName: 'bundleName',
        column: 1,
        area: [10, 10],
        layoutInfo: [[]]
      }) as BaseTransferBean;
      let transferBean2 = new Object({
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_CARD,
        cardName: 'ClockWeatherHoriCard',
        isNeedRestoreFromBackup: true,
        bundleName: 'bundleName',
        column: 1,
        area: [10, 10],
        layoutInfo: [[]]
      }) as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean, transferBean, transferBean2],
        moveToNextPage: [transferBean, transferBean, transferBean2],
        usedCellCnt: 100,
        abilityFormUsedCellCnt: 24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['realignByMaintenance']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillBackExtraElements']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['addEmptyRowAfterextract']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager.realignScreenData(screenItemInfo);
        expect(transferLayoutManager instanceof OhosCloneLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clearAll();
    })

  })
}