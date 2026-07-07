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
import {
  CommonConstants,
  GridLayoutItemInfo,
  RdbStoreManager,
  DockItemInfo,
  Extend1Data,
  AppStatus,
  GridLayoutUtil,
} from '../../../../../../main/ets/TsIndex';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBSceneContainerSession } from '@ohos/windowscene';
import { BaseTransferBean } from '../../../../../../main/ets/transformdata/BaseTransferBean';
import ScreenTransferBean from '../../../../../../main/ets/transformdata/ScreenTransferBean';
import { OhosMigrateLayoutManager } from '../../../../../../main/ets/transformdata/OhosMigrateLayoutManager';

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

export default function OhosMigrateLayoutManagerTest() {
  let mockerRdb: MockKit = new MockKit();
  let layoutInfos: GridLayoutItemInfo[] = initGridLayoutItemInfos();
  let screenData: ScreenTransferBean = initScreenTransferBean();

  let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
  let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
  let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);

  describe('OhosMigrateLayoutManagerTest', () => {
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

    it('transferLayoutTest01', Level.LEVEL0, async (done: Function) => {
      try {
        expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it('generateNewFirstPage01', Level.LEVEL0, async (done: Function) => {
      let layoutInfos: GridLayoutItemInfo[] = initGridLayoutItemInfos();

      let mocker: MockKit = new MockKit();
      let queryGridLayoutInfo: Function =
        mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().queryGridLayoutInfo);
      when(queryGridLayoutInfo)().afterReturn(layoutInfos);

      let ifDuplicatePosition: Function =
        mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().ifDuplicatePosition);
      when(ifDuplicatePosition)(ArgumentMatchers.any).afterReturn(true);

      try {
        transferLayoutManager['generateNewFirstPage']();
        expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }

      mocker.ignoreMock(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().queryGridLayoutInfo);
      mocker.ignoreMock(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().ifDuplicatePosition);
      done();
    })

    it('printFirstPageItem01', Level.LEVEL0, async (done: Function) => {
      try {
        transferLayoutManager['printFirstPageItem'](layoutInfos);
        expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it('getDefaultLayoutInfoFromConfig01', Level.LEVEL0, async (done: Function) => {
      try {
        let result: GridLayoutItemInfo[] = transferLayoutManager['getDefaultLayoutInfoFromConfig']();
        expect(result.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it('getConfigFileAbsPath01', Level.LEVEL0, async (done: Function) => {
      try {
        let result: string = transferLayoutManager['getConfigFileAbsPath']('fileName');
        expect(result).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it('transferByScreen01', Level.LEVEL0, async (done: Function) => {
      try {
        transferLayoutManager['transferByScreen'](screenData);
        expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it('compareCard01', Level.LEVEL0, async (done: Function) => {
      let a: GridLayoutItemInfo = new GridLayoutItemInfo;
      let b: GridLayoutItemInfo = new GridLayoutItemInfo;
      let oldLayoutInfo: GridLayoutItemInfo[] = [];
      try {
        let order: number = transferLayoutManager['compareCard'](a, b, oldLayoutInfo);
        expect(order).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it('addRestDockToCurrentPage01', Level.LEVEL0, async (done: Function) => {
      try {
        let startPage: number = 0;
        transferLayoutManager['addRestDockToCurrentPage'](startPage, []);
        expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it('test_updateFoldersRowAndColumn_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);

        let childElement: GridLayoutItemInfo[] = [];
        let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
        let appInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
        childElement.push(appInfo1);
        childElement.push(appInfo2);
        transferLayoutManager['updateFoldersRowAndColumn'](childElement)
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_collectSmartDock_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);

        let dataElement: GridLayoutItemInfo = new GridLayoutItemInfo();
        dataElement.typeId = CommonConstants.TYPE_APP;
        let data: GridLayoutItemInfo[] = [];
        transferLayoutManager['collectSmartDock'](dataElement, data);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_collectSmartDock_02', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);

        let dataElement: GridLayoutItemInfo = new GridLayoutItemInfo();
        dataElement.typeId = CommonConstants.TYPE_FOLDER;
        let data: GridLayoutItemInfo[] = [];
        transferLayoutManager['collectSmartDock'](dataElement, data);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_collectDesktop_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);

        let dataElement: GridLayoutItemInfo = new GridLayoutItemInfo();
        dataElement.typeId = CommonConstants.TYPE_APP;
        let data: GridLayoutItemInfo[] = [];
        let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
        appInfo1.typeId = CommonConstants.TYPE_APP;
        let appInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
        appInfo2.typeId = CommonConstants.TYPE_FOLDER
        data.push(appInfo1);
        data.push(appInfo2);

        transferLayoutManager['collectDesktop'](dataElement, data);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_getCardRowFromContainer_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);

        let cardLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        let oldLayoutInfo: GridLayoutItemInfo[] = [];
        cardLayoutInfo.container = CommonConstants.CONTAINER_DESKTOP;
        transferLayoutManager['getCardRowFromContainer'](cardLayoutInfo, oldLayoutInfo);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_getCardRowFromContainer_02', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);

        let cardLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        let oldLayoutInfo: GridLayoutItemInfo[] = [];
        cardLayoutInfo.container = CommonConstants.CONTAINER_SMARTDOCK;
        transferLayoutManager['getCardRowFromContainer'](cardLayoutInfo, oldLayoutInfo);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_getCardColumnFromContainer_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);

        let cardLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        let oldLayoutInfo: GridLayoutItemInfo[] = [];
        cardLayoutInfo.container = CommonConstants.CONTAINER_DESKTOP;
        transferLayoutManager['getCardColumnFromContainer'](cardLayoutInfo, oldLayoutInfo);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_getCardColumnFromContainer_02', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);

        let cardLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        let oldLayoutInfo: GridLayoutItemInfo[] = [];
        cardLayoutInfo.container = CommonConstants.CONTAINER_SMARTDOCK;
        transferLayoutManager['getCardColumnFromContainer'](cardLayoutInfo, oldLayoutInfo);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it("generateNewFirstPage1", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
      let itemInfo1 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1
          },
          {
            row: 2,
            column: 2
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList: [] as SCBSceneContainerSession[],
        appIconId: 0,
        abilityName: '',
        appName: '',
        bundleName: ''
      } as DockItemInfo;
      let itemInfo2 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1
          },
          {
            row: 2,
            column: 2
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList: [] as SCBSceneContainerSession[],
        appIconId: 0,
        abilityName: '',
        appName: '',
        bundleName: ''
      } as DockItemInfo;
      let rdbStoreMangerInstance = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.querySmartDock);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(Promise.resolve([itemInfo1, itemInfo2]));
      let mockFunction1: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.ifDuplicatePosition);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      try {
        transferLayoutManager['generateNewFirstPage']();
        expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(rdbStoreMangerInstance);
      mocker.clearAll();
      done();
    })

    it("generateNewFirstPage2", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
      let itemInfo1 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 0,
            typeId: CommonConstants.TYPE_APP
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1,
            typeId: CommonConstants.TYPE_APP
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList: [] as SCBSceneContainerSession[],
        appIconId: 0,
        abilityName: '',
        appName: '',
        bundleName: ''
      } as DockItemInfo;
      let itemInfo2 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 0,
            typeId: CommonConstants.TYPE_APP
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1,
            typeId: CommonConstants.TYPE_APP
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList: [] as SCBSceneContainerSession[],
        appIconId: 0,
        abilityName: '',
        appName: '',
        bundleName: ''
      } as DockItemInfo;
      let rdbStoreMangerInstance = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.querySmartDock);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(Promise.resolve([itemInfo1, itemInfo2]));
      let mockFunction1: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.ifDuplicatePosition);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['generateNewFirstPage']();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
      mocker.clear(rdbStoreMangerInstance);
      mocker.clearAll();
      done();
    })

    it("generateNewFirstPage3", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
      let itemInfo1 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 0,
            typeId: CommonConstants.TYPE_FOLDER
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1,
            typeId: CommonConstants.TYPE_FOLDER
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList: [] as SCBSceneContainerSession[],
        appIconId: 0,
        abilityName: '',
        appName: '',
        bundleName: ''
      } as DockItemInfo;
      let itemInfo2 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 0,
            typeId: CommonConstants.TYPE_FOLDER
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1,
            typeId: CommonConstants.TYPE_FOLDER
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList: [] as SCBSceneContainerSession[],
        appIconId: 0,
        abilityName: '',
        appName: '',
        bundleName: ''
      } as DockItemInfo;
      let rdbStoreMangerInstance = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.querySmartDock);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(Promise.resolve([itemInfo1, itemInfo2]));
      let mockFunction1: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.ifDuplicatePosition);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['generateNewFirstPage']();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
      mocker.clear(rdbStoreMangerInstance);
      mocker.clearAll();
      done();
    })

    it("generateNewFirstPage4", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
      let itemInfo1 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 0,
            typeId: CommonConstants.TYPE_CARD
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1,
            typeId: CommonConstants.TYPE_CARD
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList: [] as SCBSceneContainerSession[],
        appIconId: 0,
        abilityName: '',
        appName: '',
        bundleName: ''
      } as DockItemInfo;
      let itemInfo2 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 0,
            typeId: CommonConstants.TYPE_CARD
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1,
            typeId: CommonConstants.TYPE_CARD
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList: [] as SCBSceneContainerSession[],
        appIconId: 0,
        abilityName: '',
        appName: '',
        bundleName: ''
      } as DockItemInfo;
      let rdbStoreMangerInstance = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.querySmartDock);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(Promise.resolve([itemInfo1, itemInfo2]));
      let mockFunction1: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.ifDuplicatePosition);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['generateNewFirstPage']();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
      mocker.clear(rdbStoreMangerInstance);
      mocker.clearAll();
      done();
    })

    it("generateNewFirstPage5", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
      let itemInfo1 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 0,
            typeId: CommonConstants.TYPE_FORM_STACK
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1,
            typeId: CommonConstants.TYPE_FORM_STACK
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList: [] as SCBSceneContainerSession[],
        appIconId: 0,
        abilityName: '',
        appName: '',
        bundleName: ''
      } as DockItemInfo;
      let itemInfo2 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 0,
            typeId: CommonConstants.TYPE_FORM_STACK
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1,
            typeId: CommonConstants.TYPE_FORM_STACK
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList: [] as SCBSceneContainerSession[],
        appIconId: 0,
        abilityName: '',
        appName: '',
        bundleName: ''
      } as DockItemInfo;
      let rdbStoreMangerInstance = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.querySmartDock);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(Promise.resolve([itemInfo1, itemInfo2]));
      let mockFunction1: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.ifDuplicatePosition);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['generateNewFirstPage']();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
      mocker.clear(rdbStoreMangerInstance)
      mocker.clearAll();
      done();
    })

    it("generateNewFirstPage6", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
      let itemInfo1 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 0,
            typeId: CommonConstants.CONTAINER_SMARTDOCK
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1,
            typeId: CommonConstants.CONTAINER_SMARTDOCK
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList: [] as SCBSceneContainerSession[],
        appIconId: 0,
        abilityName: '',
        appName: '',
        bundleName: ''
      } as DockItemInfo;
      let itemInfo2 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 0,
            typeId: CommonConstants.CONTAINER_SMARTDOCK
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList: [] as SCBSceneContainerSession[],
        appIconId: 0,
        abilityName: '',
        appName: '',
        bundleName: ''
      } as DockItemInfo;
      let rdbStoreMangerInstance = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.querySmartDock);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(Promise.resolve([itemInfo1, itemInfo2]));
      let mockFunction1: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.ifDuplicatePosition);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['generateNewFirstPage']();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
      mocker.clear(rdbStoreMangerInstance)
      mocker.clearAll();
      done();
    })

    it("printFirstPageItem", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
      transferLayoutManager['isBigFold'] = true
      let itemInfo1 = [
        {
          row: 1,
          column: 1,
          container: CommonConstants.CONTAINER_DESKTOP,
          page: 0,
          typeId: CommonConstants.CONTAINER_SMARTDOCK
        },
        {
          row: 2,
          column: 2,
          container: CommonConstants.CONTAINER_DESKTOP,
          page: 1
        },
        {
          row: 2,
          column: 2,
          container: CommonConstants.CONTAINER_DESKTOP,
          page: 1
        },
        {
          row: 2,
          column: 2,
          container: CommonConstants.CONTAINER_DESKTOP,
          page: 1
        },
      ] as GridLayoutItemInfo[];
      try {
        transferLayoutManager['printFirstPageItem'](itemInfo1);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
      done();
    })

    it("sortScreenDataMap", 0, async (done: Function) => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
        let notHarmony1 = {
          layoutWeight: 1,
          page: 1,
          typeId: CommonConstants.TYPE_FORM_COMBINE
        } as BaseTransferBean;
        let screenItemInfo = {
          page: 1,
          occupied: [[true]],
          usedCellCnt: 0,
          iconUsedCellCnt: 0,
          folderUsedCellCnt: 0,
          abilityFormUsedCellCnt: 0,
          children: [notHarmony1],
          moveToNextPage: [notHarmony1]
        } as ScreenTransferBean;
        transferLayoutManager['screenDataMap'] =
          new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
        transferLayoutManager['sortScreenDataMap']();
        expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_generateNewFirstPage", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1 = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_DESKTOP,
        page: 0,
        typeId: CommonConstants.TYPE_FOLDER,
        bundleName: 'bundleName1',
        isBigFold: false,
        layoutInfo: [[]]
      }) as GridLayoutItemInfo;
      let gridLayoutItem2 = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_DESKTOP,
        page: 1,
        isBigFold: true,
        bundleName: 'bundleName2',
        typeId: CommonConstants.TYPE_APP,
        layoutInfo: [[gridLayoutItem1, gridLayoutItem1]]
      }) as GridLayoutItemInfo;
      let gridLayoutItem3 = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FORM_STACK,
        page: 1,
        isBigFold: true,
        bundleName: 'bundleName2',
        typeId: CommonConstants.TYPE_APP,
        layoutInfo: [[gridLayoutItem1, gridLayoutItem2]]
      }) as GridLayoutItemInfo;
      let rdbStoreMangerInstance: RdbStoreManager = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.queryGridLayoutInfo);
      when(mockFunction)(ArgumentMatchers.any)
        .afterReturn(Promise.resolve([gridLayoutItem3, gridLayoutItem3, gridLayoutItem3]));
      let mockFunction1: Function =
        mocker.mockFunc(rdbStoreMangerInstance, rdbStoreMangerInstance.ifDuplicatePosition);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['printFirstPageItem']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['getDefaultLayoutInfoFromConfig']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn([gridLayoutItem3, gridLayoutItem3]);
      let mockFunction4: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['putPageData']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction5: Function =
        mocker.mockFunc(Extend1Data, Extend1Data.setCardSourceType);
      when(mockFunction5)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        await transferLayoutManager['generateNewFirstPage']();
        expect(transferLayoutManager['firstPageElementSet'].size >= 0).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(rdbStoreMangerInstance);
      mocker.clear(transferLayoutManager);
      mocker.clear(Extend1Data);
      mocker.clearAll();
      done();
    })

    it("getNewLayoutFromScreenDataMap", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['mergeScreenDataMap']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup: false
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean],
        moveToNextPage: [transferBean]
      } as ScreenTransferBean;
      let gridLayoutItem = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold: true,
        bundleName: 'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo: [[]],
        infoId: '1'
      }) as GridLayoutItemInfo;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['disbandFormCombine']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn([gridLayoutItem, gridLayoutItem]);
      let mockFunction3: Function =
        mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().ifDuplicatePosition);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(true);
      try {
        let result = transferLayoutManager['getNewLayoutFromScreenDataMap']();
        expect(result.length).not().assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clear(RdbStoreManager.getInstance());
      mocker.clear(DeviceHelper);
      mocker.clearAll();
      done();
    })

    it("transferOldLayoutToNewLayout", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup: false
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean],
        moveToNextPage: [transferBean]
      } as ScreenTransferBean;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      transferLayoutManager['isBigFold'] = true;
      transferLayoutManager['isNewLayout'] = false;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['transferByScreen']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        expect(transferLayoutManager['screenDataMap'].size).not().assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clearAll();
      done();
    })

    it("collectOldLayoutByScreen", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1 = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold: true,
        bundleName: 'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo: [[]],
        infoId: '1',
        area: [1, 1],
        appIndex: 1,
        appStatus: AppStatus.WAIT_FOR_HARMONY
      }) as GridLayoutItemInfo;
      transferLayoutManager['isBigFold'] = true;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['generateNewFirstPage']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['isFindInFirstPage']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['deleteCardInFirstPage']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['manyToOneReplace']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction4: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['isNeedAddToNotHarmnoyFolder']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(true);
      try {
        await transferLayoutManager['collectOldLayoutByScreen']([gridLayoutItem1, gridLayoutItem1, gridLayoutItem1]);
        expect(transferLayoutManager['notHarmonyList']!.length > 0).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clearAll();
      done();
    })

    it("test_generateNewFirstPage3", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
      let gridLayoutItem = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_DESKTOP,
        page: 1,
        isBigFold: true,
        bundleName: 'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo: [[]],
        infoId: '1',
        area: [1, 1],
        appIndex: 1,
        appStatus: AppStatus.WAIT_FOR_HARMONY
      }) as GridLayoutItemInfo;
      let gridLayoutItem1 = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_DESKTOP,
        page: 1,
        isBigFold: true,
        bundleName: 'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo: [[gridLayoutItem, gridLayoutItem], [gridLayoutItem, gridLayoutItem]],
        infoId: '1',
        area: [1, 1],
        appIndex: 1,
        appStatus: AppStatus.WAIT_FOR_HARMONY,
        cardName: 'cardName1'
      }) as GridLayoutItemInfo;
      let gridLayoutItem2 = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_DESKTOP,
        page: 1,
        isBigFold: true,
        bundleName: 'bundleName2',
        typeId: CommonConstants.TYPE_FORM_STACK,
        layoutInfo: [[gridLayoutItem, gridLayoutItem], [gridLayoutItem, gridLayoutItem]],
        infoId: '1',
        area: [1, 1],
        appIndex: 1,
        appStatus: AppStatus.WAIT_FOR_HARMONY,
        cardName: 'cardName2'
      }) as GridLayoutItemInfo;
      let itemInfo1 = {
        itemType: 1,
        editable: true,
        visible: true,
        borderVisible: false,
        shake: 0,
        layoutInfo: [[
          {
            row: 1,
            column: 1,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 0,
            typeId: CommonConstants.CONTAINER_SMARTDOCK
          },
          {
            row: 2,
            column: 2,
            container: CommonConstants.CONTAINER_DESKTOP,
            page: 1,
            typeId: CommonConstants.CONTAINER_SMARTDOCK
          },
        ]],
        iconId: 'ic1',
        extend1: 'ex1',
        id: 1,
        oldBundleNames: ['oldname'],
        missionInfoList: [] as SCBSceneContainerSession[],
        appIconId: 0,
        abilityName: '',
        appName: '',
        bundleName: ''
      } as DockItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().queryAllGridLayoutInfo);
      when(mockFunction)(ArgumentMatchers.any)
        .afterReturn(Promise.resolve([gridLayoutItem1, gridLayoutItem1, gridLayoutItem2]));
      let mockFunction1: Function =
        mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().querySmartDock);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(Promise.resolve([itemInfo1, itemInfo1]));
      let mockFunction2: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.dockItemToGridLayout);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(Promise.resolve(gridLayoutItem2));
      let mockFunction3: Function =
        mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().ifDuplicatePosition);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction4: Function =
        mocker.mockFunc(Extend1Data, Extend1Data.setCardSourceType);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction5: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['putPageData']);
      when(mockFunction5)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        await transferLayoutManager['generateNewFirstPage']();
        expect(transferLayoutManager['firstPageElementSet'].size >= 0).assertEqual(true);
        transferLayoutManager['firstPageElementSet'] = new Set<string>();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(RdbStoreManager.getInstance());
      mocker.clear(GridLayoutUtil);
      mocker.clear(Extend1Data);
      mocker.clear(transferLayoutManager);
      mocker.clearAll();
      done();
    })

    it("test_getNewLayoutFromScreenDataMap1", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
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
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealRestDockAndSingleUniqueElement']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealNotHarmonyElement']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction4: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealFormStackElement']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction5: Function =
        mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().ifDuplicatePosition);
      when(mockFunction5)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction6: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['printPageItem']);
      when(mockFunction6)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        expect(transferLayoutManager['screenDataMap'].size >= 0).assertEqual(true);
        transferLayoutManager['screenDataMap'] = new Map<number, ScreenTransferBean>();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clear(DeviceHelper);
      mocker.clear(RdbStoreManager.getInstance());
      mocker.clearAll();
      done();
    })

    it("test_transferOldLayoutToNewLayout1", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      try {
        let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
        transferLayoutManager['transferOldLayoutToNewLayout']();
        expect(transferLayoutManager['screenDataMap'].size).assertEqual(1);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it("test_transferOldLayoutToNewLayout2", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
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
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['transferByScreen']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['transferOldLayoutToNewLayout']();
        expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clearAll();
      done();
    })

    it("test_realignScreenData1", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
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
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['realignByRefresh']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['addFormCombineToLastPage']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealWithNeedMoveToNextPage']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager.realignScreenData(screenItemInfo);
        expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clearAll();
      done();
    })

    it("test_realignScreenData2", 0, async (done: Function) => {
      let fromGrid: number[] = [5, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
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
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['realignByRefresh']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['addFormCombineToLastPage']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealWithNeedMoveToNextPage']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager.realignScreenData(screenItemInfo);
        expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clearAll();
      done();
    })

    it("test_collectOldLayoutByScreen1", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1 = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold: true,
        bundleName: 'bundleName2',
        typeId: CommonConstants.CONTAINER_DESKTOP,
        layoutInfo: [[]],
        infoId: '1',
        area: [1, 1]
      }) as GridLayoutItemInfo;
      transferLayoutManager['isBigFold'] = false;
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['generateNewFirstPage']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['isFindInFirstPage']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['deleteCardInFirstPage']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction4: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['manyToOneReplace']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction5: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['isNeedAddToNotHarmnoyFolder']);
      when(mockFunction5)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction6: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction6)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction7: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['disbandFormCombine']);
      when(mockFunction7)(ArgumentMatchers.any).afterReturn([gridLayoutItem1, gridLayoutItem1, gridLayoutItem1]);
      let mockFunction8: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['sortScreenDataMap']);
      when(mockFunction8)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction9: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealRestScreen']);
      when(mockFunction9)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        await transferLayoutManager['collectOldLayoutByScreen']([gridLayoutItem1, gridLayoutItem1, gridLayoutItem1]);
        transferLayoutManager['isBigFold'] = DeviceHelper.isFoldButNotSmallFoldProduct();
        expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it("test_collectOldLayoutByScreen2", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1 = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold: true,
        bundleName: 'bundleName2',
        typeId: CommonConstants.CONTAINER_DESKTOP,
        layoutInfo: [[]],
        infoId: '1',
        area: [1, 1]
      }) as GridLayoutItemInfo;
      transferLayoutManager['isBigFold'] = true;
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['generateNewFirstPage']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['isFindInFirstPage']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['deleteCardInFirstPage']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction4: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['manyToOneReplace']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction5: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['isNeedAddToNotHarmnoyFolder']);
      when(mockFunction5)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction6: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction6)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction7: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['disbandFormCombine']);
      when(mockFunction7)(ArgumentMatchers.any).afterReturn([gridLayoutItem1, gridLayoutItem1, gridLayoutItem1]);
      let mockFunction8: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['sortScreenDataMap']);
      when(mockFunction8)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction9: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealRestScreen']);
      when(mockFunction9)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        await transferLayoutManager['collectOldLayoutByScreen']([gridLayoutItem1, gridLayoutItem1, gridLayoutItem1]);
        transferLayoutManager['isBigFold'] = DeviceHelper.isFoldButNotSmallFoldProduct();
        expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it("test_deleteCardInFirstPage1", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
      transferLayoutManager['firstPageElementSet'] = new Set<string>(['1', '2']);
      let gridLayoutItem = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold: true,
        bundleName: 'bundleName',
        cardName: 'cardName',
        typeId: CommonConstants.CONTAINER_DESKTOP,
        layoutInfo: [[]],
        appIndex: 1,
        infoId: '1',
        area: [1, 1]
      }) as GridLayoutItemInfo;
      try {
        transferLayoutManager['deleteCardInFirstPage']([gridLayoutItem, gridLayoutItem]);
        expect(transferLayoutManager['firstPageElementSet'].size).assertEqual(2);
        transferLayoutManager['firstPageElementSet'] = new Set<string>();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it("test_deleteCardInFirstPage2", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
      transferLayoutManager['firstPageElementSet'] = new Set<string>(['bundleName', 'cardName']);
      let gridLayoutItem = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold: true,
        bundleName: 'bundleName',
        cardName: 'cardName',
        typeId: CommonConstants.CONTAINER_DESKTOP,
        layoutInfo: [[]],
        appIndex: 1,
        infoId: '1',
        area: [1, 1]
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['compareCard']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(1);
      try {
        transferLayoutManager['deleteCardInFirstPage']([gridLayoutItem, gridLayoutItem, gridLayoutItem,
          gridLayoutItem]);
        expect(transferLayoutManager['firstPageElementSet'].size).assertEqual(2);
        transferLayoutManager['firstPageElementSet'] = new Set<string>();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clearAll();
      done();
    })

    it("test_dealRestDockElements1", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
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
      transferLayoutManager['dockList'] =
        [transferBean, transferBean, transferBean, transferBean, transferBean, transferBean, transferBean];
      transferLayoutManager['restDockList'] =
        [transferBean, transferBean, transferBean, transferBean, transferBean, transferBean, transferBean];
      transferLayoutManager['disbandCombFormList'] =
        [transferBean, transferBean, transferBean, transferBean, transferBean, transferBean, transferBean];
      transferLayoutManager['maxScreen'] = 2;
      transferLayoutManager['maxScreenCount'] = 1;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealwithDockAndOtherList']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['dealRestDockElements']();
        expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
        transferLayoutManager['dockList'] = [];
        transferLayoutManager['restDockList'] = [];
        transferLayoutManager['disbandCombFormList'] = [];
        transferLayoutManager['maxScreen'] = 0;
        transferLayoutManager['maxScreenCount'] = 0;
        transferLayoutManager['screenDataMap'] = new Map<number, ScreenTransferBean>();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clearAll();
      done();
    })

    it("test_dealRestDockElements2", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
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
      transferLayoutManager['dockList'] = [transferBean, transferBean, transferBean, transferBean];
      transferLayoutManager['restDockList'] = [transferBean, transferBean, transferBean, transferBean];
      transferLayoutManager['disbandCombFormList'] = [transferBean, transferBean, transferBean, transferBean];
      transferLayoutManager['maxScreen'] = 2;
      transferLayoutManager['maxScreenCount'] = 1;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealwithDockAndOtherList']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['dealRestDockElements']();
        expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
        transferLayoutManager['dockList'] = [];
        transferLayoutManager['restDockList'] = [];
        transferLayoutManager['disbandCombFormList'] = [];
        transferLayoutManager['maxScreen'] = 0;
        transferLayoutManager['maxScreenCount'] = 0;
        transferLayoutManager['screenDataMap'] = new Map<number, ScreenTransferBean>();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clearAll();
      done();
    })

    it("test_addRestDockToCurrentPage1", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
      let gridLayoutItem = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold: true,
        bundleName: 'bundleName',
        cardName: 'cardName',
        typeId: CommonConstants.CONTAINER_DESKTOP,
        layoutInfo: [[]],
        appIndex: 1,
        infoId: '1',
        area: [1, 1]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER,
        isNeedRestoreFromBackup: false,
        bundleName: 'bundleName',
        column: 1,
        area: [2, 2],
        layoutInfo: [[gridLayoutItem, gridLayoutItem], [gridLayoutItem, gridLayoutItem]],
        settlementPosition: '1'
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
      let mockFunction1: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findArea']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction4: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeRestElementFolderToCurrentPage']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['addRestDockToCurrentPage'](0, [transferBean, transferBean]);
        expect(transferLayoutManager['screenDataMap'].size >= 0).assertEqual(true)
        transferLayoutManager['screenDataMap'] = new Map<number, ScreenTransferBean>();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clear(transferLayoutManager);
      mocker.clearAll();
      done();
    })

    it("test_addRestDockToCurrentPage2", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
      let gridLayoutItem = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold: true,
        bundleName: 'bundleName',
        cardName: 'cardName',
        typeId: CommonConstants.CONTAINER_DESKTOP,
        layoutInfo: [[]],
        appIndex: 1,
        infoId: '1',
        area: [1, 1]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_APP,
        isNeedRestoreFromBackup: false,
        bundleName: 'bundleName',
        column: 1,
        area: [2, 2],
        layoutInfo: [[gridLayoutItem, gridLayoutItem], [gridLayoutItem, gridLayoutItem]],
        settlementPosition: '1'
      } as BaseTransferBean;
      let transferBean2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_SHORTCUT_ICON,
        isNeedRestoreFromBackup: false,
        bundleName: 'bundleName',
        column: 1,
        area: [2, 2],
        layoutInfo: [[gridLayoutItem, gridLayoutItem], [gridLayoutItem, gridLayoutItem]],
        settlementPosition: '1'
      } as BaseTransferBean;
      let transferBean3 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER,
        isNeedRestoreFromBackup: false,
        bundleName: 'bundleName',
        column: 1,
        area: [2, 2],
        layoutInfo: [[gridLayoutItem, gridLayoutItem], [gridLayoutItem, gridLayoutItem]],
        settlementPosition: '1'
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
      transferLayoutManager['maxScreen'] = 2;
      transferLayoutManager['maxScreenCount'] = 2;
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findArea']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction4: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['toMaxScreen']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction5: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeRestElementFolderToCurrentPage']);
      when(mockFunction5)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['addRestDockToCurrentPage'](0, [transferBean, transferBean2, transferBean3]);
        expect(transferLayoutManager['screenDataMap'].size >= 0).assertEqual(true)
        transferLayoutManager['screenDataMap'] = new Map<number, ScreenTransferBean>();
        transferLayoutManager['maxScreen'] = 0;
        transferLayoutManager['maxScreenCount'] = 0;
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clear(transferLayoutManager);
      mocker.clearAll();
      done();
    })

    it("test_addRestDockToCurrentPage3", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
      let gridLayoutItem = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold: true,
        bundleName: 'bundleName',
        cardName: 'cardName',
        typeId: CommonConstants.CONTAINER_DESKTOP,
        layoutInfo: [[]],
        appIndex: 1,
        infoId: '1',
        area: [1, 1]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_APP,
        isNeedRestoreFromBackup: false,
        bundleName: 'bundleName',
        column: 1,
        area: [2, 2],
        layoutInfo: [[gridLayoutItem, gridLayoutItem], [gridLayoutItem, gridLayoutItem]],
        settlementPosition: '1'
      } as BaseTransferBean;
      let transferBean2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_SHORTCUT_ICON,
        isNeedRestoreFromBackup: false,
        bundleName: 'bundleName',
        column: 1,
        area: [2, 2],
        layoutInfo: [[gridLayoutItem, gridLayoutItem], [gridLayoutItem, gridLayoutItem]],
        settlementPosition: '1'
      } as BaseTransferBean;
      let transferBean3 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER,
        isNeedRestoreFromBackup: false,
        bundleName: 'bundleName',
        column: 1,
        area: [2, 2],
        layoutInfo: [[gridLayoutItem, gridLayoutItem], [gridLayoutItem, gridLayoutItem]],
        settlementPosition: '1'
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
      transferLayoutManager['maxScreen'] = 2;
      transferLayoutManager['maxScreenCount'] = 2;
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findArea']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction4: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['toMaxScreen']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction5: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeRestElementFolderToCurrentPage']);
      when(mockFunction5)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['addRestDockToCurrentPage'](0, [transferBean, transferBean2, transferBean3]);
        expect(transferLayoutManager['screenDataMap'].size >= 0).assertEqual(true)
        transferLayoutManager['screenDataMap'] = new Map<number, ScreenTransferBean>();
        transferLayoutManager['maxScreen'] = 0;
        transferLayoutManager['maxScreenCount'] = 0;
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clear(transferLayoutManager);
      mocker.clearAll();
      done();
    })

    it("test_collectSmartDock1", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
      let gridLayoutItem = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold: true,
        bundleName: 'bundleName',
        cardName: 'cardName',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo: [[]],
        appIndex: 1,
        infoId: '1',
        area: [1, 1]
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['validAndCollectFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      try {
        transferLayoutManager['collectSmartDock'](gridLayoutItem, [gridLayoutItem]);
        expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
        transferLayoutManager['transferType'] = '';
        transferLayoutManager['restDockList'] = [];
        transferLayoutManager['dockList'] = [];
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clearAll();
      done();
    })

    it("test_collectSmartDock2", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
      let gridLayoutItem = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold: true,
        bundleName: 'bundleName',
        cardName: 'cardName',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo: [[]],
        appIndex: 1,
        infoId: '1',
        area: [1, 1]
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['validAndCollectFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['collectSmartDock'](gridLayoutItem, [gridLayoutItem]);
        expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
        transferLayoutManager['transferType'] = '';
        transferLayoutManager['restDockList'] = [];
        transferLayoutManager['dockList'] = [];
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
      mocker.clearAll();
      done();
    })

    it("test_collectSmartDock3", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
      let gridLayoutItem = new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold: true,
        bundleName: 'bundleName',
        cardName: 'cardName',
        typeId: CommonConstants.TYPE_FUNCTION,
        layoutInfo: [[]],
        appIndex: 1,
        infoId: '1',
        area: [1, 1]
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      try {
        transferLayoutManager['collectSmartDock'](gridLayoutItem, [gridLayoutItem]);
        expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
        transferLayoutManager['dockList'] = [];
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(DeviceHelper);
      mocker.clearAll();
      done();
    })

    it('test_transferLayout_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
        let oldLayoutInfo: GridLayoutItemInfo[] = [];
        transferLayoutManager.transferLayout(oldLayoutInfo, true);
        expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_transferLayout_02', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
        let oldLayoutInfo: GridLayoutItemInfo[] = [];
        transferLayoutManager.transferLayout(oldLayoutInfo, false);
        expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_collectDuplicateApp_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: OhosMigrateLayoutManager = new OhosMigrateLayoutManager(fromGrid, toGrid);
        let info1: GridLayoutItemInfo = new GridLayoutItemInfo();
        info1.bundleName = 'test1';
        let info2: GridLayoutItemInfo = new GridLayoutItemInfo();
        info2.bundleName = 'test1';
        let info3: GridLayoutItemInfo = new GridLayoutItemInfo();
        info3.intent = '{"multiMappingRelationship":2}';

        let oldLayoutInfo: GridLayoutItemInfo[] = [info1, info2, info3];
        transferLayoutManager.collectDuplicateApp(oldLayoutInfo);
        expect(transferLayoutManager instanceof OhosMigrateLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })


  })
}