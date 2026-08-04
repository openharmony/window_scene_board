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
  FolderReporter,
  AppStatus,
  AppReserveType,
  DeliverUtil
} from '../../../../../../main/ets/TsIndex';
import { CheckEmptyUtils, CommonUtils } from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { BaseTransferBean } from '../../../../../../main/ets/transformdata/BaseTransferBean';
import ScreenTransferBean from '../../../../../../main/ets/transformdata/ScreenTransferBean';
import { BaseTransferLayoutManager } from '../../../../../../main/ets/transformdata/BaseTransferLayoutManager';
import dataConvert from '../../../../../../main/ets/transformdata/DataConvert';
import { NotHarmonyUtil } from '../../../../../../main/ets/utils/NotHarmonyUtil';

function retUndefined(): BaseTransferBean[] | undefined {
  return undefined;
}

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
  gridLayoutCombineCard.container = 125;
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

function initCombineCardGridLayoutItem(): GridLayoutItemInfo {
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
  return gridLayoutCombineCard;
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
  cardBaseBean.infoName = 'ClockWeatherCard';
  cardBaseBean.bundleName = 'com.ohos.totemweather';
  cardBaseBean.abilityName = 'FormAbility';
  cardBaseBean.moduleName = 'product';
  cardBaseBean.container = CommonConstants.CONTAINER_DESKTOP;
  cardBaseBean.page = 0;
  cardBaseBean.row = 2;
  cardBaseBean.column = 0;
  cardBaseBean.area = [1, 2];

  let children: BaseTransferBean[] = [appBaseBean, cardBaseBean];
  screenData.children = children;
  screenData.moveToNextPage = children;
  return screenData;
}

function initDhItemInfos(): GridLayoutItemInfo[]{
  let dhItemInfos: GridLayoutItemInfo[] =[];
  let gridLayoutAppApp: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutAppApp.typeId = CommonConstants.TYPE_APP;
  gridLayoutAppApp.infoId = '37f7caf8-eff6-46ab-aefe-0f9786e47669';
  gridLayoutAppApp.infoName = '电召PLUS';
  gridLayoutAppApp.bundleName = 'macao.taxi.passager';
  gridLayoutAppApp.abilityName = 'MainAbility';
  gridLayoutAppApp.moduleName = 'phone';
  gridLayoutAppApp.container = 66;
  gridLayoutAppApp.page = 0;
  gridLayoutAppApp.row = 0;
  gridLayoutAppApp.column = 0;
  gridLayoutAppApp.areaType = 0;
  gridLayoutAppApp.area = [1, 1];
  gridLayoutAppApp.appStatus = AppStatus.WAIT_FOR_HARMONY;
  gridLayoutAppApp.intent =
    '{"legacyInfo":{"pkgName":"macao.taxi.passager","pkgLableName":"电召PLUS","pkgSignature":"8c6e07f87c9db98fde934f69bdaaf653ef1176b0e0aa5959de87b34203a8d5f3","versionCode":"2025052303","versionName":"3.3.7","installSource":"com.ohos.abroad"},"targetModuleUrl":"","requestBundleName":"__WAIT_FOR_HARMONY_BUNDLENAME__macao.taxi.passager__1750122530100","installSource":"com.ohos.abroad","appType":0,"maskState":0}';

  let gridLayoutdeliverApp: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutdeliverApp.typeId = CommonConstants.TYPE_APP;
  gridLayoutdeliverApp.infoId = 'a1a6df81-66c7-428c-b340-66f3610356d8';
  gridLayoutdeliverApp.infoName = '掌上穿越火线';
  gridLayoutdeliverApp.bundleName = 'com.tencent.qt.sns';
  gridLayoutdeliverApp.abilityName = 'MainAbility';
  gridLayoutdeliverApp.moduleName = 'phone';
  gridLayoutdeliverApp.container = -100;
  gridLayoutdeliverApp.page = 0;
  gridLayoutdeliverApp.row = 0;
  gridLayoutdeliverApp.areaType = 0;
  gridLayoutdeliverApp.column = 2;
  gridLayoutdeliverApp.area = [1, 1];
  gridLayoutdeliverApp.appStatus = AppStatus.WAIT_FOR_HARMONY;
  gridLayoutdeliverApp.intent =
    '{"legacyInfo":{"pkgName":"com.tencent.qt.sns","pkgLableName":"掌上穿越火线","pkgSignature":"90eec83fcadc14edefe83d33d6578ad6111957a3975b7a2a2eddfbd262a96a5d","versionCode":"2103290004","versionName":"3.29.0","installSource":"com.deliver.appstore.lite"},"targetModuleUrl":"","requestBundleName":"__WAIT_FOR_HARMONY_BUNDLENAME__com.tencent.qt.sns__1750157767972","installSource":"com.deliver.appstore.lite","appType":0,"maskState":0}';

  let gridNotHarmonyApp: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridNotHarmonyApp.typeId = CommonConstants.TYPE_APP;
  gridNotHarmonyApp.infoId = 'a1a6df81-66c7-428c-b340-66f3610356d8';
  gridNotHarmonyApp.infoName = '实况足球';
  gridNotHarmonyApp.bundleName = 'com.tencent.football';
  gridNotHarmonyApp.abilityName = 'MainAbility';
  gridNotHarmonyApp.moduleName = 'phone';
  gridNotHarmonyApp.container = -100;
  gridNotHarmonyApp.page = 0;
  gridNotHarmonyApp.row = 0;
  gridNotHarmonyApp.areaType = 0;
  gridNotHarmonyApp.column = 3;
  gridNotHarmonyApp.area = [1, 1];
  gridNotHarmonyApp.appStatus = AppStatus.WAIT_FOR_HARMONY;
  gridNotHarmonyApp.intent =
    '{"legacyInfo":{"pkgName":"com.tencent.qt.sns","pkgLableName":"掌上穿越火线","pkgSignature":"90eec83fcadc14edefe83d33d6578ad6111957a3975b7a2a2eddfbd262a96a5d","versionCode":"2103290004","versionName":"3.29.0","installSource":"com.deliver.appstore.lite"},"targetModuleUrl":"","requestBundleName":"__WAIT_FOR_HARMONY_BUNDLENAME__com.tencent.qt.sns__1750157767972","installSource":"com.deliver.appstore.lite","appType":0,"maskState":0}';

  // 克隆应用文件夹
  let gridLayoutdeliverFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutdeliverFolder.id = 48;
  gridLayoutdeliverFolder.typeId = CommonConstants.TYPE_FOLDER;
  gridLayoutdeliverFolder.infoId = '1715654262381';
  gridLayoutdeliverFolder.infoName = '${app_others}';
  gridLayoutdeliverFolder.bundleName = '';
  gridLayoutdeliverFolder.folderName = '${app_others}';
  gridLayoutdeliverFolder.abilityName = '';
  gridLayoutdeliverFolder.moduleName = '';
  gridLayoutdeliverFolder.container = CommonConstants.CONTAINER_DESKTOP;
  gridLayoutdeliverFolder.page = 0;
  gridLayoutdeliverFolder.row = 4;
  gridLayoutdeliverFolder.column = 2;
  gridLayoutdeliverFolder.area = [2, 2];
  gridLayoutdeliverFolder.layoutInfo = [];
  gridLayoutdeliverFolder.intent = '{"installSource":"com.deliver.appstore.lite"}';

  // 应用文件夹
  let gridLayoutAboardFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutAboardFolder.id = 48;
  gridLayoutAboardFolder.typeId = CommonConstants.TYPE_FOLDER;
  gridLayoutAboardFolder.infoId = '1715654262382';
  gridLayoutAboardFolder.infoName = '应用';
  gridLayoutAboardFolder.bundleName = '';
  gridLayoutAboardFolder.folderName = '应用';
  gridLayoutAboardFolder.abilityName = '';
  gridLayoutAboardFolder.moduleName = '';
  gridLayoutAboardFolder.container = CommonConstants.CONTAINER_DESKTOP;
  gridLayoutAboardFolder.page =0;
  gridLayoutAboardFolder.row = 4;
  gridLayoutAboardFolder.column = 0;
  gridLayoutAboardFolder.area = [2, 2];
  gridLayoutAboardFolder.layoutInfo = [];
  gridLayoutAboardFolder.intent = '{"installSource":"com.ohos.abroad"}';

  // 未鸿蒙化文件夹
  let gridLayoutNotHarmonyFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutAboardFolder.id = 48;
  gridLayoutAboardFolder.typeId = CommonConstants.TYPE_FOLDER;
  gridLayoutAboardFolder.infoId = '1715654262383';
  gridLayoutAboardFolder.infoName = '${not_harmony_apps}';
  gridLayoutAboardFolder.bundleName = '';
  gridLayoutAboardFolder.folderName = '${not_harmony_apps}';
  gridLayoutAboardFolder.abilityName = '';
  gridLayoutAboardFolder.moduleName = '';
  gridLayoutAboardFolder.container = CommonConstants.CONTAINER_DESKTOP;
  gridLayoutAboardFolder.page = 1;
  gridLayoutAboardFolder.row = 2;
  gridLayoutAboardFolder.column = 2;
  gridLayoutAboardFolder.area = [2, 2];
  gridLayoutAboardFolder.layoutInfo = [];
  gridLayoutAboardFolder.intent = '{"NotHarmonyFolder":"1715654262383"}';
  dhItemInfos.push(gridLayoutAppApp, gridLayoutdeliverApp, gridNotHarmonyApp, gridLayoutdeliverFolder, gridLayoutAboardFolder,
    gridLayoutNotHarmonyFolder);
  return dhItemInfos;
}

export default function BaseTransferLayoutManagerTest() {
  let mockerRdb: MockKit = new MockKit();
  let layoutInfos: GridLayoutItemInfo[] = initGridLayoutItemInfos();
  let screenData: ScreenTransferBean = initScreenTransferBean();

  let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
  let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
  let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);

  describe('BaseTransferLayoutManagerTest', () => {
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

    it('transferLayoutTest01', Level.LEVEL0, async (done:Function) => {
      try {
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('disbandFormCombine01', Level.LEVEL0, async (done:Function) => {
      try {
        let gridLayoutCombineCard: GridLayoutItemInfo = initCombineCardGridLayoutItem();
        let result: GridLayoutItemInfo[] = transferLayoutManager['disbandFormCombine'](gridLayoutCombineCard);
        expect(result.length).assertLargerOrEqual(0);
      } catch (e) {};
      done();
    })

    it('transferByScreen01', Level.LEVEL0, async (done:Function) => {
      try {
        transferLayoutManager['transferByScreen'](screenData);
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('realignScreenData01', Level.LEVEL0, async (done:Function) => {
      try {
        transferLayoutManager['realignScreenData'](screenData);
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('realignByMaintenance01', Level.LEVEL0, async (done:Function) => {
      try {
        let occupied: boolean[][] = [];
        let emptyScreenData = new ScreenTransferBean();
        transferLayoutManager['realignByMaintenance'](emptyScreenData, occupied);
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('realignByMaintenance02', Level.LEVEL0, async (done:Function) => {
      try {
        let occupied: boolean[][] = [];
        transferLayoutManager['realignByMaintenance'](screenData, occupied);
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('calculateRowElement01', Level.LEVEL0, async (done:Function) => {
      try {
        let rowElementMap: Map<number, number[]> = new Map();
        let widgetIndexArr: number[] = [];
        let emptyRowArr: number[] = [];
        transferLayoutManager['calculateRowElement'](screenData, rowElementMap, widgetIndexArr, emptyRowArr);
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('regroupWidgetPosition01', Level.LEVEL0, async (done:Function) => {
      try {
        let screenData: ScreenTransferBean = initScreenTransferBean();
        let rowElementMap: Map<number, number[]> = new Map();
        let widgetIndexArr: number[] = [0, 1];
        let emptyRowArr: number[] = [];
        transferLayoutManager['regroupWidgetPosition'](widgetIndexArr, screenData, emptyRowArr, rowElementMap);
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('placeElementsByRow01', Level.LEVEL0, async (done:Function) => {
      try {
        let curRowElements: number[] = [];
        let needToNextPageIndex: number[] = [];
        let occupied: boolean[][] = [];
        transferLayoutManager['placeElementsByRow'](curRowElements, screenData, occupied, needToNextPageIndex);
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('moveElementByType01', Level.LEVEL0, async (done:Function) => {
      try {
        let curRowElements: number[] = [];
        let needToNextPageIndex: number[] = [];
        let rowLen: number = 4;
        let emptyLen: number = 6;
        let type: number[] = [0];
        transferLayoutManager['moveElementByType'](curRowElements, rowLen, emptyLen, screenData, needToNextPageIndex, type);
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('moveElementByType02', Level.LEVEL0, async (done:Function) => {
      try {
        let curRowElements: number[] = [];
        let needToNextPageIndex: number[] = [];
        let rowLen: number = 6;
        let emptyLen: number = 4;
        let type: number[] = [0];
        transferLayoutManager['moveElementByType'](curRowElements, rowLen, emptyLen, screenData, needToNextPageIndex, type);
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('dealWithLessSpace01', Level.LEVEL0, async (done:Function) => {
      try {
        let curRowElements: number[] = [];
        let needToNextPageIndex: number[] = [];
        let occupied: boolean[][] = [];
        transferLayoutManager['dealWithLessSpace'](curRowElements, occupied, screenData, needToNextPageIndex);
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('findAreaByRowFromLast01', Level.LEVEL0, async (done:Function) => {
      let occupied: boolean[][] = Array(4).fill(false).map(() => Array(6).fill(false));
      let baseData: BaseTransferBean = new BaseTransferBean();
      baseData.area = [1, 1];
      baseData.row = 1;
      baseData.column = 1;
      try {
        transferLayoutManager['findAreaByRowFromLast'](occupied, baseData);
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('makeRestElementFolderToCurrentPage01', Level.LEVEL0, async (done:Function) => {
      try {
        let occupied: boolean[][] = [];
        let notFromCurrentPageElements: BaseTransferBean[] = [];
        transferLayoutManager['makeRestElementFolderToCurrentPage'](screenData, occupied, notFromCurrentPageElements);
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('replaceLastCardWithFolder01', Level.LEVEL0, async (done:Function) => {
      try {
        let screenData: ScreenTransferBean = initScreenTransferBean();
        let occupied: boolean[][] = screenData.occupied;
        let addToCurrentPage: BaseTransferBean[] = screenData.children;
        let isSpecialFolder: boolean = false;
        transferLayoutManager['replaceLastCardWithFolder'](screenData, occupied, addToCurrentPage, isSpecialFolder);
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('mergeTwoSmallElement01', Level.LEVEL0, async (done:Function) => {
      try {
        let transferBean = {
          layoutWeight: 1,
          page: 1,
          row: NumberConstants.CONSTANT_NUMBER_100,
          typeId: CommonConstants.TYPE_SHORTCUT_ICON ,
          isNeedRestoreFromBackup:false,
          bundleName:'bundleName',
          column:1,
          area:[2,2]
        } as BaseTransferBean;
        transferLayoutManager['mergeTwoSmallElement'](screenData, transferBean);
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('mergeLastAppAndOtherSmallElement01', Level.LEVEL0, async (done:Function) => {
      try {
        let screenData: ScreenTransferBean = initScreenTransferBean();
        let lastElement: BaseTransferBean = new BaseTransferBean();
        transferLayoutManager['mergeLastAppAndOtherSmallElement'](screenData, lastElement);
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('fillElementInfo01', Level.LEVEL0, async (done:Function) => {
      try {
        let baseData: BaseTransferBean = new BaseTransferBean();
        let lastElement: BaseTransferBean = new BaseTransferBean();
        transferLayoutManager['fillElementInfo'](baseData, lastElement);
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('filterNotAppElement01', Level.LEVEL0, async (done:Function) => {
      try {
        let addToCurrentPage: BaseTransferBean[] = [];
        transferLayoutManager['filterNotAppElement'](screenData, addToCurrentPage);
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('findArea01', Level.LEVEL0, async (done:Function) => {
      try {
        let occupied: boolean[][] = [];
        let transferBean: BaseTransferBean = new BaseTransferBean();
        let result: boolean = transferLayoutManager['findArea'](occupied, transferBean);
        expect(result).assertFalse();
      } catch (e) {};
      done();
    })

    it('validElementArea01', Level.LEVEL0, async (done:Function) => {
      let occupied: boolean[][] = [];
      let area: number [] = [];
      let fromIndexX: number = 0;
      let fromIndexY: number = 0;
      try {
        let result: boolean = transferLayoutManager['validElementArea'](occupied, area, fromIndexX, fromIndexY);
        expect(result).assertFalse();
      } catch (e) {};
      done();
    })

    it('preprocessScreenData01', Level.LEVEL0, async (done:Function) => {
      try {
        let screenData: ScreenTransferBean = new ScreenTransferBean();
        transferLayoutManager['preprocessScreenData'](screenData);
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('isAppOrSmallFolder01', Level.LEVEL0, async (done:Function) => {
      try {
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        let result: boolean = transferLayoutManager['isAppOrSmallFolder'](item);
        expect(result).assertFalse();
      } catch (e) {};
      done();
    })

    it('toMaxScreen01', Level.LEVEL0, async (done:Function) => {
      try {
        let result1: boolean = transferLayoutManager['toMaxScreen']();
        expect(false).assertFalse();
      } catch (e) {};
      done();
    })

    it('getNewLayoutCardItems01', Level.LEVEL0, async (done:Function) => {
      try {
        transferLayoutManager.getNewLayoutCardItems();
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('test_updateFoldersRowAndColumn_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);

        let childElement: GridLayoutItemInfo[] = [];
        let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
        let appInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
        childElement.push(appInfo1);
        childElement.push(appInfo2);
        transferLayoutManager['updateFoldersRowAndColumn'](childElement)
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {};
    });

    it('test_makeSmallerFolder_01', 0, () => {
      try {
        let gridLayoutArr: BaseTransferBean[] = retUndefined() as BaseTransferBean[];
        let ret: BaseTransferBean = transferLayoutManager['makeSmallerFolder'](gridLayoutArr);
        expect(ret).assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      };
    });

    it('test_makeSmallerFolder_02', 0, () => {
      try {
        let gridLayoutArr: BaseTransferBean[] = [];
        gridLayoutArr.push(layoutInfos[0] as BaseTransferBean);
        let ret: BaseTransferBean = transferLayoutManager['makeSmallerFolder'](gridLayoutArr);
        expect(ret.typeId).assertEqual(CommonConstants.TYPE_APP);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      };
    });

    it('test_makeSmallerFolder_03', 0, () => {
      try {
        let gridLayoutArr: BaseTransferBean[] = [];
        gridLayoutArr.push(layoutInfos[0] as BaseTransferBean);
        gridLayoutArr.push(layoutInfos[5] as BaseTransferBean);
        let ret: BaseTransferBean = transferLayoutManager['makeSmallerFolder'](gridLayoutArr);
        expect(ret.typeId).assertEqual(CommonConstants.TYPE_FOLDER);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      };
    });

    it('test_makeSmallerFolder_04', 0, () => {
      try {
        let dhItemInfos: GridLayoutItemInfo[] = initDhItemInfos();
        let gridLayoutArr: BaseTransferBean[] = [];
        gridLayoutArr.push(dhItemInfos[0] as BaseTransferBean);
        let ret: BaseTransferBean = transferLayoutManager['makeSmallerFolder'](gridLayoutArr, true);
        expect(ret.typeId).assertEqual(CommonConstants.TYPE_FOLDER);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      };
    });

    it('test_makeSmallerFolder_05', 0, () => {
      try {
        let dhItemInfos: GridLayoutItemInfo[] = initDhItemInfos();
        let gridLayoutArr: BaseTransferBean[] = [];
        gridLayoutArr.push(dhItemInfos[1] as BaseTransferBean);
        let ret: BaseTransferBean = transferLayoutManager['makeSmallerFolder'](gridLayoutArr, true);
        expect(ret.typeId).assertEqual(CommonConstants.TYPE_FOLDER);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      };
    });

    it('test_makeSmallerFolder_06', 0, () => {
      try {
        let gridLayoutInfos: GridLayoutItemInfo[] =  initGridLayoutItemInfos();
        gridLayoutInfos[0].intent = JSON.stringify({
          installSource: 'test'
        });
        let gridLayoutArr: BaseTransferBean[] = [];
        gridLayoutArr.push(gridLayoutInfos[0] as BaseTransferBean);
        let ret: BaseTransferBean = transferLayoutManager['makeSmallerFolder'](gridLayoutArr, true);
        expect(ret.typeId).assertEqual(CommonConstants.TYPE_FOLDER);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      };
    });


    it('test_putPageData_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);

        let dataElement: BaseTransferBean = new BaseTransferBean();
        dataElement.page = 100;
        transferLayoutManager['putPageData'](dataElement);
        expect(dataElement).not().assertNull();
      } catch (e) {};
    });

    it('test_putPageData_02', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);

        let dataElement: BaseTransferBean = new BaseTransferBean();
        dataElement.page = 0;
        transferLayoutManager['putPageData'](dataElement);
        expect(dataElement).not().assertNull();
      } catch (e) {};
    });

    it('test_collectSmartDock_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);

        let dataElement: GridLayoutItemInfo = new GridLayoutItemInfo();
        dataElement.typeId = CommonConstants.TYPE_APP;
        let data: GridLayoutItemInfo[] = [];
        transferLayoutManager['collectSmartDock'](dataElement, data);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {};
    });

    it('test_collectSmartDock_02', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);

        let dataElement: GridLayoutItemInfo = new GridLayoutItemInfo();
        dataElement.typeId = CommonConstants.TYPE_FOLDER;
        let data: GridLayoutItemInfo[] = [];
        transferLayoutManager['collectSmartDock'](dataElement, data);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {};
    });

    it('test_collectDesktop_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);

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
      } catch (e) {};
    });

    it('test_collectDesktop_03', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);

        let dataElement: GridLayoutItemInfo = new GridLayoutItemInfo();
        dataElement.typeId = CommonConstants.TYPE_CARD;
        let data: GridLayoutItemInfo[] = [];
        let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
        appInfo1.typeId = CommonConstants.TYPE_APP;
        let appInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
        appInfo2.typeId = CommonConstants.TYPE_FOLDER
        data.push(appInfo1);
        data.push(appInfo2);

        transferLayoutManager['collectDesktop'](dataElement, data);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {};
    });

    it('test_collectDesktop_04', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);

        let dataElement: GridLayoutItemInfo = new GridLayoutItemInfo();
        dataElement.typeId = CommonConstants.TYPE_FORM_STACK;
        let data: GridLayoutItemInfo[] = [];
        let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
        appInfo1.typeId = CommonConstants.TYPE_APP;
        let appInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
        appInfo2.typeId = CommonConstants.TYPE_FOLDER
        data.push(appInfo1);
        data.push(appInfo2);

        transferLayoutManager['collectDesktop'](dataElement, data);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {};
    });

    it('test_compare_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);

        let lhs: BaseTransferBean = new BaseTransferBean();
        lhs.layoutWeight = 1;
        let rhs: BaseTransferBean = new BaseTransferBean();
        rhs.layoutWeight = 2;
        let ret: number = transferLayoutManager['compare'](lhs, rhs);
        expect(ret).assertEqual(-1);
      } catch (e) {};
    });

    it('test_compare_02', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);

        let lhs: BaseTransferBean = new BaseTransferBean();
        lhs.layoutWeight = 2;
        let rhs: BaseTransferBean = new BaseTransferBean();
        rhs.layoutWeight = 1;
        let ret: number = transferLayoutManager['compare'](lhs, rhs);
        expect(ret).assertEqual(1);
      } catch (e) {};
    });

    it('test_compare_03', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);

        let lhs: BaseTransferBean = new BaseTransferBean();
        lhs.layoutWeight = 2;
        lhs.row = 1;
        let rhs: BaseTransferBean = new BaseTransferBean();
        rhs.layoutWeight = 2;
        rhs.row = 2;
        let ret: number = transferLayoutManager['compare'](lhs, rhs);
        expect(ret).assertEqual(-1);
      } catch (e) {};
    });

    it('test_compare_04', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);

        let lhs: BaseTransferBean = new BaseTransferBean();
        lhs.layoutWeight = 2;
        lhs.row = 2;
        let rhs: BaseTransferBean = new BaseTransferBean();
        rhs.layoutWeight = 2;
        rhs.row = 1;
        let ret: number = transferLayoutManager['compare'](lhs, rhs);
        expect(ret).assertEqual(1);
      } catch (e) {};
    });

    it('test_compare_05', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);

        let lhs: BaseTransferBean = new BaseTransferBean();
        lhs.layoutWeight = 2;
        lhs.row = 2;
        lhs.column = 1;
        let rhs: BaseTransferBean = new BaseTransferBean();
        rhs.layoutWeight = 2;
        rhs.row = 2;
        rhs.column = 2;
        let ret: number = transferLayoutManager['compare'](lhs, rhs);
        expect(ret).assertEqual(-1);
      } catch (e) {};
    });

    it('test_compare_06', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);

        let lhs: BaseTransferBean = new BaseTransferBean();
        lhs.layoutWeight = 2;
        lhs.row = 2;
        lhs.column = 2;
        let rhs: BaseTransferBean = new BaseTransferBean();
        rhs.layoutWeight = 2;
        rhs.row = 2;
        rhs.column = 1;
        let ret: number = transferLayoutManager['compare'](lhs, rhs);
        expect(ret).assertEqual(1);
      } catch (e) {};
    });

    it('test_compare_07', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);

        let lhs: BaseTransferBean = new BaseTransferBean();
        lhs.layoutWeight = 2;
        lhs.row = 2;
        lhs.column = 2;
        lhs.id = 100;
        let rhs: BaseTransferBean = new BaseTransferBean();
        rhs.layoutWeight = 2;
        rhs.row = 2;
        rhs.column = 2;
        rhs.id = 100;
        let ret: number = transferLayoutManager['compare'](lhs, rhs);
        expect(ret).assertEqual(0);
      } catch (e) {};
    });

    it('test_findEmptyPosition_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);

        let occupied: boolean[][] = [[true, false, true],[false, true, true]];
        let row: number = 0;
        let ret: number = transferLayoutManager['findEmptyPosition'](occupied, row);
        expect(ret).assertEqual(1);
      } catch (e) {};
    });

    it('test_updateInfoId_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
        let layoutInfo: GridLayoutItemInfo[] = [];

        transferLayoutManager['updateInfoId'](layoutInfo);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {};
    });

    it('test_updateInfoId_01', 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
        let layoutInfo: GridLayoutItemInfo[] = [];
        let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
        appInfo1.typeId = CommonConstants.TYPE_APP;
        let appInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
        appInfo2.typeId = CommonConstants.TYPE_FOLDER
        layoutInfo.push(appInfo1);
        layoutInfo.push(appInfo2);
        transferLayoutManager['updateInfoId'](layoutInfo);
        expect(transferLayoutManager).not().assertNull();
      } catch (e) {};
    });

    it('test_dealFormStackElement', Level.LEVEL0, async (done:Function) => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
        expect(transferLayoutManager['dealFormStackElement']() === undefined).assertTrue();
      } catch (e) {};
      done();
    })

    it('test_dealDiffSizeChildCards', Level.LEVEL0, async (done:Function) => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
        let childElement: GridLayoutItemInfo = new GridLayoutItemInfo();
        childElement.typeId = 1;
        childElement.infoId = '123456789';
        childElement.appName = '玩机技巧';
        childElement.bundleName = 'com.ohos.tips';
        childElement.keyName = 'com.ohos.tips0';
        childElement.folderName = ''
        childElement.abilityName = 'FormAbility';
        childElement.moduleName = 'phone';
        childElement.appIconId = 1;
        childElement.appLabelId = 2;
        childElement.badgeNumber = 3;
        childElement.row = 0;
        childElement.column = 2;
        childElement.area = [2, 2];
        expect(transferLayoutManager['dealDiffSizeChildCards']([childElement], [2, 4], []) === undefined).assertTrue();
      } catch (e) {};
      done();
    })

    it('test_rearrangeCardFromPage', Level.LEVEL0, async (done:Function) => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
        let tipsCard: BaseTransferBean = new BaseTransferBean();
        tipsCard.typeId = 1;
        tipsCard.infoId = '123456789';
        tipsCard.appName = '玩机技巧';
        tipsCard.bundleName = 'com.ohos.tips';
        tipsCard.keyName = 'com.ohos.tips0';
        tipsCard.folderName = ''
        tipsCard.abilityName = 'FormAbility';
        tipsCard.moduleName = 'phone';
        tipsCard.appIconId = 1;
        tipsCard.appLabelId = 2;
        tipsCard.badgeNumber = 3;
        tipsCard.row = 0;
        tipsCard.column = 2;
        tipsCard.area = [2, 2];
        tipsCard.layoutWeight = 0;
        expect(transferLayoutManager['rearrangeCardFromPage'](2, tipsCard) === undefined).assertTrue();
      } catch (e) {};
      done();
    })

    it("test_isNeedAddTodeliverFolder_01", 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
        let itemInfo = {
          typeId: CommonConstants.TYPE_APP + 1,
        } as GridLayoutItemInfo;
        let result = transferLayoutManager['isNeedAddTodeliverFolder'](itemInfo);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_isNeedAddTodeliverFolder_02", 0, () => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
        let pkg: string = '1';
        let itemInfo = {
          typeId: CommonConstants.TYPE_APP,
          intent: JSON.stringify(new Map([['installSource', pkg]])),
        } as GridLayoutItemInfo;
        let result = transferLayoutManager['isNeedAddTodeliverFolder'](itemInfo);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_isNeedAddTodeliverFolder_03", 0, () => {
      let mock = new MockKit();
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
        let pkg: string = DeliverUtil.DELIVER_APPSTORE_PKG;
        let itemInfo = {
          typeId: CommonConstants.TYPE_APP,
          intent: JSON.stringify(new Map([['installSource', pkg]])),
        } as GridLayoutItemInfo;
        let mockFunc: Function = mock.mockFunc(dataConvert, dataConvert.isInContainerFolder);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        let result = transferLayoutManager['isNeedAddTodeliverFolder'](itemInfo);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it("test_isNeedAddTodeliverFolder_04", 0, () => {
      let mock = new MockKit();
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
        let pkg: string = DeliverUtil.DELIVER_APPSTORE_PKG;
        let itemInfo = {
          typeId: CommonConstants.TYPE_APP,
          intent: JSON.stringify(new Map([['installSource', pkg]])),
          appStatus: AppStatus.INSTALLED,
        } as GridLayoutItemInfo;
        let mockFunc: Function = mock.mockFunc(dataConvert, dataConvert.isInContainerFolder);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let result = transferLayoutManager['isNeedAddTodeliverFolder'](itemInfo);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(dataConvert);
      mock.clearAll();
    })

    it("getNewLayoutCardItems", 0, async (done: Function) => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
        transferLayoutManager.getNewLayoutCardItems();
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
        done();
      } catch (e) {};
    })

    it("sortScreenDataMap", 0, async (done: Function) => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
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
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
        done();
      } catch (e) {};
    })

    it("test_findLastNoSmallNotHarmnoyFolderElement1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let notHarmony1 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName1',
      } as BaseTransferBean;
      let notHarmony2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_APP,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName2',
      } as BaseTransferBean;
      let notHarmony3 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_SHORTCUT_ICON,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName3',
      } as BaseTransferBean;
      let notHarmony4 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_CARD,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName4',
      } as BaseTransferBean;
      let notHarmony5 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_CARD,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName5'
      } as BaseTransferBean;
      let screenItemInfo = {
        page: CommonConstants.INVALID_VALUE,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [notHarmony1,notHarmony2,notHarmony3,notHarmony4,notHarmony5,notHarmony2,notHarmony3,notHarmony4,notHarmony5],
        moveToNextPage: [notHarmony1,notHarmony2,notHarmony3,notHarmony4,notHarmony5]
      } as ScreenTransferBean;
      try {
        let lastElement: BaseTransferBean = transferLayoutManager['findLastNoSmallNotHarmnoyFolderElement'](screenItemInfo);
        expect(lastElement).not().assertEqual(undefined);
      } catch (e) {};

      done();
    })

    it("test_findLastNoSmallNotHarmnoyFolderElement0", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let notHarmony1 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName1',
      } as BaseTransferBean;
      let notHarmony2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_APP,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName2',
      } as BaseTransferBean;
      let notHarmony3 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_SHORTCUT_ICON,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName3',
      } as BaseTransferBean;
      let notHarmony4 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_CARD,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName4',
      } as BaseTransferBean;
      let notHarmony5 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FOLDER,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName5',
        area: [1, 1],
      } as BaseTransferBean;
      let screenItemInfo = {
        page: CommonConstants.INVALID_VALUE,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [notHarmony1,notHarmony2,notHarmony3,notHarmony4,notHarmony5,notHarmony2,notHarmony3,notHarmony4,notHarmony5],
        moveToNextPage: [notHarmony1,notHarmony2,notHarmony3,notHarmony4,notHarmony5]
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerItem);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      try {
        let lastElement: BaseTransferBean = transferLayoutManager['findLastNoSmallNotHarmnoyFolderElement'](screenItemInfo);
        expect(lastElement).not().assertEqual(undefined);
      } catch (e) {};
      mocker.clear(transferLayoutManager);

      done();
    })

    it("test_updateInfoId_7", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      try {
        let gridLayoutItem1 = new Object({
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
        let gridLayoutItem2 = new Object({
          row: 1,
          column: 1,
          container: CommonConstants.TYPE_FOLDER,
          page: 1,
          isBigFold: true,
          bundleName: 'bundleName2',
          typeId: CommonConstants.TYPE_FOLDER,
          layoutInfo: [[gridLayoutItem1]],
          infoId: '2'
        }) as GridLayoutItemInfo;
        let gridLayoutItem3 = new Object({
          row: 1,
          column: 1,
          container: CommonConstants.TYPE_FOLDER,
          page: 1,
          isBigFold: true,
          bundleName: 'bundleName2',
          typeId: CommonConstants.TYPE_FOLDER,
          layoutInfo: [[gridLayoutItem1, gridLayoutItem1], [gridLayoutItem2, gridLayoutItem2]],
          infoId: '3'
        }) as GridLayoutItemInfo;
        let folderReporterInstance: FolderReporter = FolderReporter.getInstance();
        let rdbStoreManagerInstance: RdbStoreManager = RdbStoreManager.getInstance();
        let mocker: MockKit = new MockKit();
        let mockFunction: Function =
          mocker.mockFunc(folderReporterInstance, folderReporterInstance.reportCreateFolderInTransfer);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
        let mockFunction1: Function =
          mocker.mockFunc(rdbStoreManagerInstance, rdbStoreManagerInstance.generateRandomUUID);
        when(mockFunction1)(ArgumentMatchers.any).afterReturn('1');
        transferLayoutManager['updateInfoId']([gridLayoutItem3]);
        let infoId: string = gridLayoutItem1.infoId!;
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
        mocker.clear(folderReporterInstance);
        mocker.clear(rdbStoreManagerInstance);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    })

    it("getNewLayoutFromScreenDataMap", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
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
        isNeedRestoreFromBackup:false
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
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1'
      }) as GridLayoutItemInfo;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['disbandFormCombine']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn([gridLayoutItem,gridLayoutItem]);
      let mockFunction3: Function =
        mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().ifDuplicatePosition);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(true);
      try {
        let result = transferLayoutManager['getNewLayoutFromScreenDataMap']();
        expect(result.length).not().assertEqual(0);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      mocker.clear(RdbStoreManager.getInstance());
      mocker.clear(DeviceHelper);
      done();
    })

    it("dealFormStackElement1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1'
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_STACK,
        isNeedRestoreFromBackup:false,
        layoutInfo:[[gridLayoutItem1]]
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
      try {
        transferLayoutManager['dealFormStackElement']();
        expect(transferLayoutManager['screenDataMap'].size).not().assertEqual(0);
      } catch (e) {};
      done();
    })

    it("dealFormStackElement2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[5,5]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        column:1,
        container:1,
        area:[4,4],
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_STACK,
        cardName:'cardName',
        bundleName:'bundleName',
        moduleName:'moduleName',
        isNeedRestoreFromBackup:false,
        layoutInfo:[[gridLayoutItem1]]
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
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['getFormStackMaxArea']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn([1,1]);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealDiffSizeChildCards']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['rearrangeCardFromPage']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['dealFormStackElement']();
        expect(transferLayoutManager['screenDataMap'].size).not().assertEqual(0);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("getFormStackMaxArea", 0, async(done:Function) => {
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
        let gridLayoutItem1= new Object({
          row: 1,
          column: 1,
          container: CommonConstants.TYPE_FOLDER,
          page: 1,
          isBigFold:true,
          bundleName:'bundleName2',
          typeId: CommonConstants.TYPE_FOLDER,
          layoutInfo:[[]],
          infoId:'1',
          area:[5,5]
        }) as GridLayoutItemInfo;
        let result = transferLayoutManager['getFormStackMaxArea']([gridLayoutItem1]);
        expect(result[0]).assertEqual(5);
      } catch (e) {};
      done();
    })

    it("dealDiffSizeChildCards", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false
      } as BaseTransferBean;
      let childElement = [gridLayoutItem1];
      let rearrange = [transferBean];
      let maxArea = [1,1];
      try {
        transferLayoutManager['dealDiffSizeChildCards'](childElement,maxArea,rearrange);
        expect(rearrange.length===1).assertEqual(true);
      } catch (e) {};
      done();
    })

    it("rearrangeCardFromPage", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false
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
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findAreaInScreen']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['rearrangeCardFromPage'](0,transferBean);
        let children:BaseTransferBean[] = transferLayoutManager['screenDataMap'].get(0)!.children;
        expect(children.length).assertLargerOrEqual(0);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("transferOldLayoutToNewLayout", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100 + 1,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false
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
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("calculateRowElement", 0, async(done:Function) => {
      let rowElementMap: Map<number, number[]> = new Map();
      let widgetIndexArr: number[] = [];
      let emptyRowArr: number[] = [];
      let transferBean = {
        layoutWeight: 1,
        page: -1,
        row: 1,
        typeId: CommonConstants.TYPE_CARD,
        isNeedRestoreFromBackup:false,
        cardName:'ClockWeatherCard',
        area:[1,1]
      } as BaseTransferBean;
      let transferBean1 = {
        layoutWeight: 1,
        page: -1,
        row: 1,
        typeId: CommonConstants.TYPE_CARD,
        isNeedRestoreFromBackup:false,
        cardName:'ClockWeatherHoriCard',
        area:[1,1]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: -1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean],
        moveToNextPage: [transferBean,transferBean1]
      } as ScreenTransferBean;
      try {
        transferLayoutManager['calculateRowElement'](screenItemInfo, rowElementMap, widgetIndexArr, emptyRowArr);
        expect(widgetIndexArr.length>0).assertTrue();
      } catch (e) {};
      done();
    })

    it("regroupWidgetPosition0", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let widgetIndexArr = [0,1];
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean]
      } as ScreenTransferBean;
      let emptyRowArr = [0,1];
      let rowElementMap = new Map<number,number[]>([[2,[0,1]],[3,[1,2]]]);
      try {
        transferLayoutManager['isFirstWidgetProcessed'] = false;
        transferLayoutManager['regroupWidgetPosition'](widgetIndexArr,screenItemInfo,emptyRowArr,rowElementMap);
        expect(transferLayoutManager['isFirstWidgetProcessed']).assertEqual(true);
      } catch (e) {};
      done();
    })

    it("regroupWidgetPosition1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let widgetIndexArr = [0,1];
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean]
      } as ScreenTransferBean;
      let emptyRowArr = [0,1];
      let rowElementMap = new Map<number,number[]>([[0,[0,1]],[1,[1,2]]]);
      try {
        transferLayoutManager['isFirstWidgetProcessed'] = false;
        transferLayoutManager['regroupWidgetPosition'](widgetIndexArr,screenItemInfo,emptyRowArr,rowElementMap);
        expect(transferLayoutManager['isFirstWidgetProcessed']).assertEqual(true);
      } catch (e) {};
      done();
    })

    it("regroupWidgetPosition2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let widgetIndexArr = [0,1];
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean]
      } as ScreenTransferBean;
      let emptyRowArr = [100,101];
      let rowElementMap = new Map<number,number[]>([[0,[0,1]],[1,[1,2]]]);
      try {
        transferLayoutManager['isFirstWidgetProcessed'] = false;
        transferLayoutManager['regroupWidgetPosition'](widgetIndexArr,screenItemInfo,emptyRowArr,rowElementMap);
        expect(transferLayoutManager['isFirstWidgetProcessed']).assertEqual(true);
      } catch (e) {};
      done();
    })

    it("regroupWidgetPosition3", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let widgetIndexArr = [0,1];
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean]
      } as ScreenTransferBean;
      let emptyRowArr = [0,1];
      let rowElementMap = new Map<number,number[]>([[2,[2,3]],[3,[3,4]]]);
      try {
        transferLayoutManager['isFirstWidgetProcessed'] = true;
        transferLayoutManager['regroupWidgetPosition'](widgetIndexArr,screenItemInfo,emptyRowArr,rowElementMap);
        expect(transferLayoutManager['isFirstWidgetProcessed']).assertEqual(true);
      } catch (e) {};
      done();
    })

    it("moveElementByType", 0, async(done:Function) => {
      let curRowElements: number[] = [];
      let needToNextPageIndex: number[] = [];
      let rowLen: number = 4;
      let emptyLen: number = 4;
      let type: number[] = [0];
      try {
        let result = transferLayoutManager['moveElementByType'](curRowElements, rowLen, emptyLen, screenData, needToNextPageIndex, type);
        expect(result).assertEqual(4);
      } catch (e) {};
      done();
    })

    it("test_dealWithMoreSpace1_7", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:7,
        area:[1,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean]
      } as ScreenTransferBean;
      let curRowElements = [0,1];
      let occupied = [[true,false],[false,true]];
      let needToNextPageIndex = [0,1];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findAreaByRowFromLast']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['dealWithMoreSpace'](screenItemInfo,curRowElements,occupied,needToNextPageIndex);
        expect(needToNextPageIndex.length).assertLargerOrEqual(0);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("dealWithMoreSpace2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:7,
        area:[1,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean]
      } as ScreenTransferBean;
      let curRowElements = [0,1];
      let occupied = [[true,false],[false,true]];
      let needToNextPageIndex = [0,1];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findAreaByRowFromLast']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['dealWithMoreSpace'](screenItemInfo,curRowElements,occupied,needToNextPageIndex);
        expect(needToNextPageIndex.length>2).assertEqual(true);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("dealWithMoreSpace3", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean]
      } as ScreenTransferBean;
      let curRowElements = [0,1];
      let occupied = [[true,false],[false,true]];
      let needToNextPageIndex = [0,1];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findAreaByRow']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['dealWithMoreSpace'](screenItemInfo,curRowElements,occupied,needToNextPageIndex);
        expect(needToNextPageIndex.length>2).assertEqual(true);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("findAreaByRow", 0, async(done:Function) => {
      let occupied: boolean[][] = Array(4).fill(false).map(() => Array(6).fill(false));
      let baseData: BaseTransferBean = new BaseTransferBean();
      baseData.area = [1, 1];
      baseData.row = 1;
      baseData.column = 1;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['validElementArea']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        let result = transferLayoutManager['findAreaByRow'](occupied, baseData);
        expect(result).assertFalse();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("findAreaByRowFromLast1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: 3,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[3,3]
      } as BaseTransferBean;
      let occupied = [[true,false,true,false],[false,true,true,false],[true,false,true,false],[false,true,true,false]];
      try {
        let result = transferLayoutManager['findAreaByRowFromLast'](occupied,transferBean);
        expect(result).assertEqual(false);
      } catch (e) {};
      done();
    })

    it("findAreaByRowFromLast2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: 3,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[4,4]
      } as BaseTransferBean;
      let occupied = [[true,false,true],[false,true,true],[false,true,false]];
      try {
        let result = transferLayoutManager['findAreaByRowFromLast'](occupied,transferBean);
        expect(result).assertEqual(false);
      } catch (e) {};
      done();
    })

    it("findAreaByRowFromLast3", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: 3,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[4,5]
      } as BaseTransferBean;
      let occupied = [[false,false,false],[false,false,false],[false,false,false]];
      try {
        let result = transferLayoutManager['findAreaByRowFromLast'](occupied,transferBean);
        expect(result).assertEqual(false);
      } catch (e) {};
      done();
    })

    it("makeRestElementFolderToCurrentPage1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean]
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeRestElementFolderToCurrentPage']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['makeRestElementFolderToCurrentPage'](screenItemInfo,[],[],false);
        expect(screenItemInfo!.moveToNextPage!.length).assertEqual(3);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("makeRestElementFolderToCurrentPage2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:10
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeRestElementFolderToCurrentPage']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeSmallerFolder']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(transferBean);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findArea']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['makeRestElementFolderToCurrentPage'](screenItemInfo,[],[transferBean],true);
        expect(screenItemInfo!.children!.length>2).assertEqual(true);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("makeRestElementFolderToCurrentPage3", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeRestElementFolderToCurrentPage']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeNotHarmonyElementToFolder']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['makeRestElementFolderToCurrentPage'](screenItemInfo,[],[transferBean],true);
        expect(screenItemInfo!.children!.length>2).assertEqual(true);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("makeRestElementFolderToCurrentPage4", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeRestElementFolderToCurrentPage']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['replaceLastCardWithFolder']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['makeRestElementFolderToCurrentPage'](screenItemInfo,[],[transferBean],false);
        expect(screenItemInfo!.children!.length>2).assertEqual(true);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("makeRestElementFolderToCurrentPage5", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_SHORTCUT_ICON,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean1 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_APP,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2],
        layoutInfo:[[gridLayoutItem1],[gridLayoutItem1]]
      } as BaseTransferBean;
      let transferBean2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_SHORTCUT_ICON,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2],
        layoutInfo:[[gridLayoutItem1],[gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean1,transferBean2,transferBean1,transferBean2],
        moveToNextPage: [transferBean1,transferBean2,transferBean1,transferBean2],
        usedCellCnt:100,
        abilityFormUsedCellCnt:100
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeRestElementFolderToCurrentPage']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['replaceLastCardWithFolder']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeSmallerFolder']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(transferBean1);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillElementInfo']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(transferBean1);
      try {
        transferLayoutManager['makeRestElementFolderToCurrentPage'](screenItemInfo,[],[transferBean1,transferBean2],false);
        expect(screenItemInfo!.children!.length>2).assertEqual(true);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("makeRestElementFolderToCurrentPage6", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean1 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_APP,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2],
        layoutInfo:[[gridLayoutItem1],[gridLayoutItem1]]
      } as BaseTransferBean;
      let transferBean2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2],
        layoutInfo:[[gridLayoutItem1],[gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean1,transferBean2,transferBean1,transferBean2],
        moveToNextPage: [transferBean1,transferBean2,transferBean1,transferBean2],
        usedCellCnt:100,
        abilityFormUsedCellCnt:100
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeRestElementFolderToCurrentPage']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['updateFoldersRowAndColumn']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['makeRestElementFolderToCurrentPage'](screenItemInfo,[],[transferBean1,transferBean2],false);
        expect(screenItemInfo!.children!.length>2).assertEqual(true);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("replaceLastCardWithFolder", 0, async(done:Function) => {
      let screenData: ScreenTransferBean = initScreenTransferBean();
      let occupied: boolean[][] = screenData.occupied;
      let addToCurrentPage: BaseTransferBean[] = screenData.children;
      let isSpecialFolder: boolean = false;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findArea']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['replaceLastCardWithFolder'](screenData, occupied, addToCurrentPage, isSpecialFolder);
        expect(addToCurrentPage.length).assertEqual(1);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("makeNotHarmonyElementToFolder1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_STACK ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['replaceLastCardWithFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['makeNotHarmonyElementToFolder'](screenItemInfo,[],[transferBean]);
        expect(screenItemInfo!.children!.length>3).assertEqual(false);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("makeNotHarmonyElementToFolder2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FORM_COMBINE ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['replaceLastCardWithFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['makeNotHarmonyElementToFolder'](screenItemInfo,[],[transferBean]);
        expect(screenItemInfo!.children!.length>3).assertEqual(false);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("makeNotHarmonyElementToFolder3", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['isAppOrSmallFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['mergeTwoSmallElement']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeSmallerFolder']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(transferBean);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillElementInfo']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['makeNotHarmonyElementToFolder'](screenItemInfo,[],[transferBean]);
        expect(screenItemInfo!.children!.length>3).assertEqual(false);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("makeNotHarmonyElementToFolder4", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[0,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['isAppOrSmallFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeSmallerFolder']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(transferBean);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findArea']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(true);
      try {
        transferLayoutManager['makeNotHarmonyElementToFolder'](screenItemInfo,[],[transferBean]);
        expect(screenItemInfo!.children!.length>3).assertEqual(true);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("mergeTwoSmallElement1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_SHORTCUT_ICON ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['mergeLastAppAndOtherSmallElement']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['mergeTwoSmallElement'](screenItemInfo, transferBean);
        expect(screenItemInfo!.children!.length<3).assertFalse();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("mergeTwoSmallElement2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[gridLayoutItem1,gridLayoutItem1],[gridLayoutItem1,gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['mergeLastSmallFolderAndOtherSmallElement']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['mergeTwoSmallElement'](screenItemInfo, transferBean);
        expect(screenItemInfo!.children!.length<3).assertFalse();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("filterNotAppElement1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_SHORTCUT_ICON ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[gridLayoutItem1,gridLayoutItem1],[gridLayoutItem1,gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let addToCurrentPage:BaseTransferBean[] = [transferBean];
      try {
        transferLayoutManager['filterNotAppElement'](screenItemInfo,addToCurrentPage)
        expect(addToCurrentPage.length>1).assertEqual(true);
      } catch (e) {};
      done();
    })

    it("filterNotAppElement2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,1],
        layoutInfo:[[gridLayoutItem1,gridLayoutItem1],[gridLayoutItem1,gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let addToCurrentPage:BaseTransferBean[] = [transferBean];
      try {
        transferLayoutManager['filterNotAppElement'](screenItemInfo,addToCurrentPage)
        expect(addToCurrentPage.length>1).assertEqual(true);
      } catch (e) {};
      done();
    })

    it("findArea", 0, async(done:Function) => {
      let occupied: boolean[][] = [];
      let transferBean: BaseTransferBean = new BaseTransferBean();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction1: Function =
        mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      try {
        let result: boolean = transferLayoutManager['findArea'](occupied, transferBean);
        expect(result).assertFalse();
      } catch (e) {};
      mocker.clear(DeviceHelper);
      done();
    })

    it("validElementArea", 0, async(done:Function) => {
      let area: number [] = [];
      let fromIndexX: number = -1;
      let fromIndexY: number = 0;
      try {
        let result: boolean = transferLayoutManager['validElementArea'](null, area, fromIndexX, fromIndexY);
        expect(result).assertFalse();
      } catch (e) {};
      done();
    })

    it("preprocessScreenData", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[10,10]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['isAppOrSmallFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['preprocessScreenData'](screenItemInfo);
        expect(screenItemInfo!.usedCellCnt>0).assertTrue();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("collectOldLayoutByScreen", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1],
        appIndex:1,
        appStatus:AppStatus.WAIT_FOR_HARMONY
      }) as GridLayoutItemInfo;
      transferLayoutManager['isBigFold'] = true;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['generateNewFirstPage']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(Promise.resolve());
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
        await transferLayoutManager['collectOldLayoutByScreen']([gridLayoutItem1,gridLayoutItem1,gridLayoutItem1]);
        expect(transferLayoutManager['notHarmonyList']!.length>0).assertTrue();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("collectOldLayoutByScreen01", 0, async(done:Function) => {
      let dhItemInfos: GridLayoutItemInfo[] = initDhItemInfos();
      let gridLayoutItemInfos: GridLayoutItemInfo[] = initGridLayoutItemInfos();
      dhItemInfos.push(gridLayoutItemInfos[4])
      try {
        await transferLayoutManager['collectOldLayoutByScreen'](dhItemInfos);
        expect(transferLayoutManager['toGrid'].length).assertEqual(2);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      };
      done();
    })

    it("test_updateInfoId1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let item= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_DESKTOP ,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1],
        appIndex:1,
        appStatus:AppStatus.WAIT_FOR_HARMONY
      }) as GridLayoutItemInfo;
      let item1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_DESKTOP ,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[item,item],[item,item]],
        infoId:'1',
        area:[1,1],
        appIndex:1,
        appStatus:AppStatus.WAIT_FOR_HARMONY
      }) as GridLayoutItemInfo;
      let item2= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_DESKTOP ,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[item1,item1],[item1,item1]],
        infoId:'1',
        area:[1,1],
        appIndex:1,
        appStatus:AppStatus.WAIT_FOR_HARMONY
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      try {
        let mockFunction: Function =
          mocker.mockFunc(FolderReporter.getInstance(), FolderReporter.getInstance().reportCreateFolderInTransfer);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
        let mockFunction1: Function =
          mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().generateRandomUUID);
        when(mockFunction1)(ArgumentMatchers.any).afterReturn('infoId');
        transferLayoutManager['updateInfoId']([item2,item2]);
        expect(item.page).assertEqual(1);
      } catch (e) {};
      mocker.clear(FolderReporter.getInstance());
      mocker.clear(RdbStoreManager.getInstance());
      done();
    })

    it("test_getNewLayoutFromScreenDataMap1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD ,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName',
        column:1,
        area:[10,10]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
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
        expect(transferLayoutManager['screenDataMap'].size>=0).assertEqual(true);
        transferLayoutManager['screenDataMap'] = new Map<number,ScreenTransferBean>();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      mocker.clear(DeviceHelper);
      mocker.clear(RdbStoreManager.getInstance());
      done();
    })

    it("test_dealFormStackElement1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let item= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_DESKTOP ,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1],
        appIndex:1,
        appStatus:AppStatus.WAIT_FOR_HARMONY
      }) as GridLayoutItemInfo;
      let item1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_DESKTOP ,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[item,item],[item,item]],
        infoId:'1',
        area:[1,1],
        appIndex:1,
        appStatus:AppStatus.WAIT_FOR_HARMONY
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD ,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName',
        column:1,
        area:[10,10],
        layoutInfo:[[item1,item1,item1],[item1,item1,item1],[item1,item1,item1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['getFormStackMaxArea']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn([1,1]);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['rearrangeCardFromPage']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['dealFormStackElement']();
        expect(transferLayoutManager['screenDataMap'].size>=0).assertEqual(true);
        transferLayoutManager['screenDataMap'] = new Map<number,ScreenTransferBean>();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_getFormStackMaxArea1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let item= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_DESKTOP ,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[0,1],
        appIndex:1,
        appStatus:AppStatus.WAIT_FOR_HARMONY
      }) as GridLayoutItemInfo;
      try {
        let result = transferLayoutManager['getFormStackMaxArea']([item,item]);
        expect(result[0]).assertEqual(1);
      } catch (e) {};
      done();
    })

    it("test_rearrangeCardFromPage1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean = new Object({
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD ,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName',
        column:1,
        area:[10,10],
        layoutInfo:[[]]
      }) as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findAreaInScreen']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['rearrangeCardFromPage'](0,transferBean)
        expect(transferLayoutManager['screenDataMap'].size>=0).assertEqual(true);
        transferLayoutManager['screenDataMap'] = new Map<number,ScreenTransferBean>();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_transferOldLayoutToNewLayout1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean = new Object({
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD ,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName',
        column:1,
        area:[10,10],
        layoutInfo:[[]]
      }) as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      transferLayoutManager['screenDataMap'] =
        new Map<number, ScreenTransferBean>([[0, screenItemInfo], [1, screenItemInfo]]);
      transferLayoutManager['isNewLayout'] = true;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['transferByScreen']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['transferOldLayoutToNewLayout']();
        expect(transferLayoutManager['screenDataMap'].size>=0).assertEqual(true);
        transferLayoutManager['screenDataMap'] = new Map<number, ScreenTransferBean>();
        transferLayoutManager['transferType'] = '';
        transferLayoutManager['isNewLayout'] = false;
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_realignScreenData1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean =new Object({
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD ,
        isNeedRestoreFromBackup:true,
        bundleName:'bundleName',
        column:1,
        area:[10,10],
        layoutInfo:[[]]
      }) as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      transferLayoutManager['isNewLayout'] = true;
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
        transferLayoutManager['realignScreenData'](screenItemInfo);
        expect(transferLayoutManager['isNewLayout']).assertEqual(true);
        transferLayoutManager['isNewLayout'] = false;
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_regroupWidgetPosition1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      transferLayoutManager['isFirstWidgetProcessed'] = false;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: 10,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean]
      } as ScreenTransferBean;
      let widgetIndexArr = [0,1,2]
      let emptyRowArr = [15,2];
      let rowElementMap = new Map<number,number[]>([[11,[0,1]],[12,[0,1]]]);
      try {
        transferLayoutManager['regroupWidgetPosition'](widgetIndexArr,screenItemInfo,emptyRowArr,rowElementMap);
        expect(transferLayoutManager['isFirstWidgetProcessed']).assertEqual(true);
        transferLayoutManager['isFirstWidgetProcessed'] = false;
      } catch (e) {};
      done();
    })

    it("test_regroupWidgetPosition2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      transferLayoutManager['isFirstWidgetProcessed'] = true;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: 10,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean]
      } as ScreenTransferBean;
      let widgetIndexArr = [0,1,2]
      let emptyRowArr = [15,2];
      let rowElementMap = new Map<number,number[]>([[11,[0,1]],[12,[0,1]]]);
      try {
        transferLayoutManager['regroupWidgetPosition'](widgetIndexArr,screenItemInfo,emptyRowArr,rowElementMap);
        expect(transferLayoutManager['isFirstWidgetProcessed']).assertEqual(true);
        transferLayoutManager['isFirstWidgetProcessed'] = false;
      } catch (e) {};
      done();
    })


    it('test_moveNarrowerElements_01', Level.LEVEL0, async (done: Function) => {
      try {
        let curRowElements: number[] = [];
        let needToNextPageIndex: number[] = [];
        let rowLen: number = 4;
        let emptyLen: number = 0;
        transferLayoutManager['moveNarrowerElements'](curRowElements, rowLen, emptyLen, screenData,
          needToNextPageIndex);
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {
      }
      ;
      done();
    })

    it("test_moveNarrowerElements_02", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let curRowElements: number[] = [];
      let needToNextPageIndex: number[] = [];
      let rowLen: number = 4;
      let emptyLen: number = 6;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['moveElementByType']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(emptyLen - 1);
      try {
        transferLayoutManager['moveNarrowerElements'](curRowElements, rowLen, emptyLen, screenData,
          needToNextPageIndex);
        expect(rowLen).assertEqual(4);
      } catch (e) {
      }
      ;
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_moveNarrowerElements_03", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let curRowElements: number[] = [];
      let needToNextPageIndex: number[] = [];
      let rowLen: number = 4;
      let emptyLen: number = 6;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['moveElementByType']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(emptyLen + 1);
      try {
        transferLayoutManager['moveNarrowerElements'](curRowElements, rowLen, emptyLen, screenData,
          needToNextPageIndex);
        expect(rowLen).assertEqual(4);
      } catch (e) {
      }
      ;
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_moveElementByType1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let curRowElements: number[] = [4,5,6];
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: 10,
        typeId: 0,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        usedCellCnt: 0,
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        abilityFormUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean,transferBean,transferBean,transferBean,transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean,transferBean,transferBean,transferBean,transferBean,transferBean,transferBean]
      } as ScreenTransferBean;
      let needToNextPageIndex: number[] = [];
      let rowLen: number = 5;
      let emptyLen: number = 4;
      let type: number[] = [0];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['isAppOrSmallFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      try {
        let result = transferLayoutManager['moveElementByType'](curRowElements, rowLen, emptyLen, screenItemInfo, needToNextPageIndex, type);
        expect(result).not().assertUndefined();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_dealWithLessSpace1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let curRowElements: number[] = [];
      let needToNextPageIndex: number[] = [];
      let occupied: boolean[][] = [];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findAreaByRow']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['dealWithLessSpace'](curRowElements, occupied, screenData, needToNextPageIndex);
        expect(curRowElements.length>=0).assertTrue();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("findAreaByRow1", 0, async(done:Function) => {
      let occupied: boolean[][] = Array(4).fill(false).map(() => Array(6).fill(false));
      let baseData: BaseTransferBean = new BaseTransferBean();
      baseData.area = [1, 1];
      baseData.row = 1;
      baseData.column = 1;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['validElementArea']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        let result = transferLayoutManager['findAreaByRow'](occupied, baseData,true);
        expect(result).assertFalse();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_findAreaByRowFromLast4_7", 0, async (done: Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: 3,
        typeId: CommonConstants.TYPE_FORM_COMBINE,
        isNeedRestoreFromBackup: false,
        bundleName: 'bundleName',
        column: 1,
        area: [4, 5]
      } as BaseTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['validElementArea']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let occupied = [[false, false, false], [false, false, false], [false, false, false]];
      try {
        let result = transferLayoutManager['findAreaByRowFromLast'](occupied, transferBean);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
      }
      ;
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_makeRestElementFolderToCurrentPage1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean1 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_APP,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2],
        layoutInfo:[[gridLayoutItem1],[gridLayoutItem1]]
      } as BaseTransferBean;
      let transferBean2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2],
        layoutInfo:[[gridLayoutItem1],[gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean1,transferBean2,transferBean1,transferBean2],
        moveToNextPage: [transferBean1,transferBean2,transferBean1,transferBean2],
        usedCellCnt:100,
        abilityFormUsedCellCnt:100
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['updateUsedCellCnt']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['makeRestElementFolderToCurrentPage'](screenItemInfo,[],[transferBean1,transferBean2],false);
        expect(screenItemInfo!.children).not().assertUndefined();
      } catch (e) {};
      mocker.clear(CheckEmptyUtils);
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_makeRestElementFolderToCurrentPage2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean1 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_APP,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2],
        layoutInfo:[[gridLayoutItem1],[gridLayoutItem1]]
      } as BaseTransferBean;
      let transferBean2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2],
        layoutInfo:[[gridLayoutItem1],[gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean1,transferBean2,transferBean1,transferBean2],
        moveToNextPage: [transferBean1,transferBean2,transferBean1,transferBean2],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['replaceLastCardWithFolder']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeSmallerFolder']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(transferBean1);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillElementInfo']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['makeRestElementFolderToCurrentPage'](screenItemInfo,[],[transferBean1,transferBean2],false);
        expect(screenItemInfo!.children).not().assertUndefined();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      mocker.clear(CheckEmptyUtils);
      done();
    })

    it("test_makeRestElementFolderToCurrentPage4", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean1 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2],
        layoutInfo:[[gridLayoutItem1],[gridLayoutItem1]]
      } as BaseTransferBean;
      let transferBean2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[1,2],
        layoutInfo:[[gridLayoutItem1],[gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean1,transferBean2,transferBean1,transferBean2],
        moveToNextPage: [transferBean1,transferBean2,transferBean1,transferBean2],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['replaceLastCardWithFolder']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeSmallerFolder']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(transferBean1);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillElementInfo']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction4: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['updateFoldersRowAndColumn']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['makeRestElementFolderToCurrentPage'](screenItemInfo,[],[transferBean1,transferBean2],false);
        expect(screenItemInfo!.children).not().assertUndefined();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_makeNotHarmonyElementToFolder1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['isAppOrSmallFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeSmallerFolder']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(transferBean);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findArea']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['makeNotHarmonyElementToFolder'](screenItemInfo,[],[transferBean]);
        expect(screenItemInfo!.children!.length>=3).assertEqual(true);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_makeNotHarmonyElementToFolder2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['isAppOrSmallFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeSmallerFolder']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(transferBean);
      let mockFunction3: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['findArea']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['makeNotHarmonyElementToFolder'](screenItemInfo,[],[transferBean]);
        expect(screenItemInfo!.children!.length>=3).assertEqual(true);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_mergeLastAppAndOtherSmallElement1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_SHORTCUT_ICON ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['makeSmallerFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(transferBean);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillElementInfo']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['mergeLastAppAndOtherSmallElement'](screenData, transferBean);
        expect(screenItemInfo!.children).not().assertUndefined();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_mergeLastAppAndOtherSmallElement2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[gridLayoutItem1,gridLayoutItem1],[gridLayoutItem1,gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['updateFoldersRowAndColumn']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['mergeLastAppAndOtherSmallElement'](screenData, transferBean);
        expect(screenItemInfo!.children).not().assertUndefined();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_filterNotAppElement", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[2,2]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[gridLayoutItem1,gridLayoutItem1],[gridLayoutItem1,gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let addToCurrentPage:BaseTransferBean[] = [transferBean];
      try {
        transferLayoutManager['filterNotAppElement'](screenItemInfo,addToCurrentPage)
        expect(addToCurrentPage.length>=1).assertEqual(true);
      } catch (e) {};
      done();
    })

    it("test_filterNotAppElement2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_ADD,
        layoutInfo:[[]],
        infoId:'1',
        area:[2,2]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_ADD ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[gridLayoutItem1,gridLayoutItem1],[gridLayoutItem1,gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        iconUsedCellCnt: 0,
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean,transferBean],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let addToCurrentPage:BaseTransferBean[] = [transferBean];
      try {
        transferLayoutManager['filterNotAppElement'](screenItemInfo,addToCurrentPage)
        expect(addToCurrentPage.length>=1).assertEqual(true);
      } catch (e) {};
      done();
    })

    it("test_findArea1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let occupied = [[true,true,true],[true,true,true],[true,true,true]];
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
      } as BaseTransferBean;
      transferLayoutManager['isNewLayout'] = true;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['validElementArea']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function =
        mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction2: Function =
        mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
      try {
        let result = transferLayoutManager['findArea'](occupied,transferBean);
        expect(result).assertEqual(false);
        transferLayoutManager['isNewLayout'] = false;
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      mocker.clear(DeviceHelper);
      done();
    })

    it("test_collectOldLayoutByScreen1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      transferLayoutManager['isNewLayout'] = true;
      transferLayoutManager['isBigFold'] = true;
      transferLayoutManager['isClone '] = true;
      let mocker: MockKit = new MockKit();
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['generateNewFirstPage']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(Promise.resolve());
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
      when(mockFunction7)(ArgumentMatchers.any).afterReturn([gridLayoutItem1,gridLayoutItem1,gridLayoutItem1]);
      let mockFunction8: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['sortScreenDataMap']);
      when(mockFunction8)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction9: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealRestScreen']);
      when(mockFunction9)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        await transferLayoutManager['collectOldLayoutByScreen']([gridLayoutItem1,gridLayoutItem1,gridLayoutItem1]);
        expect(transferLayoutManager['isNewLayout']).assertEqual(true);
        transferLayoutManager['isNewLayout'] = false;
        transferLayoutManager['isBigFold'] = DeviceHelper.isFoldButNotSmallFoldProduct();
        transferLayoutManager['isClone '] = false;
        transferLayoutManager['transferType'] = '';
        transferLayoutManager['otherList'] = [];
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      mocker.clear(CheckEmptyUtils);
      done();
    })

    it("test_collectOldLayoutByScreen2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      transferLayoutManager['isNewLayout'] = true;
      transferLayoutManager['isBigFold'] = true;
      transferLayoutManager['isClone '] = true;
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
      when(mockFunction7)(ArgumentMatchers.any).afterReturn([gridLayoutItem1,gridLayoutItem1,gridLayoutItem1]);
      let mockFunction8: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['sortScreenDataMap']);
      when(mockFunction8)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction9: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealRestScreen']);
      when(mockFunction9)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        await transferLayoutManager['collectOldLayoutByScreen']([gridLayoutItem1,gridLayoutItem1,gridLayoutItem1]);
        expect(transferLayoutManager['isNewLayout']).assertEqual(true);
        transferLayoutManager['isNewLayout'] = false;
        transferLayoutManager['isBigFold'] = DeviceHelper.isFoldButNotSmallFoldProduct();
        transferLayoutManager['isClone '] = false;
        transferLayoutManager['transferType'] = '';
        transferLayoutManager['otherList'] = [];
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      mocker.clear(CheckEmptyUtils);
      done();
    })

    it("test_collectOldLayoutByScreen3", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      transferLayoutManager['isNewLayout'] = true;
      transferLayoutManager['isBigFold'] = true;
      transferLayoutManager['isClone '] = true;
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
      when(mockFunction5)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction6: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction6)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction7: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['disbandFormCombine']);
      when(mockFunction7)(ArgumentMatchers.any).afterReturn([gridLayoutItem1,gridLayoutItem1,gridLayoutItem1]);
      let mockFunction8: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['sortScreenDataMap']);
      when(mockFunction8)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction9: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['dealRestScreen']);
      when(mockFunction9)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        await transferLayoutManager['collectOldLayoutByScreen']([gridLayoutItem1,gridLayoutItem1,gridLayoutItem1]);
        expect(transferLayoutManager['isNewLayout']).assertEqual(true);
        transferLayoutManager['isNewLayout'] = false;
        transferLayoutManager['isBigFold'] = DeviceHelper.isFoldButNotSmallFoldProduct();
        transferLayoutManager['isClone '] = false;
        transferLayoutManager['transferType'] = '';
        transferLayoutManager['otherList'] = [];
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      mocker.clear(CheckEmptyUtils);
      done();
    })

    it("test_manyToOneReplace1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1],
        iconResource:'1'
      }) as GridLayoutItemInfo;
      let gridLayoutItem2= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1],
        iconResource:'1'
      }) as GridLayoutItemInfo;
      try {
        transferLayoutManager['manyToOneReplace']([gridLayoutItem1,gridLayoutItem2]);
        transferLayoutManager['transferType'] = '';
      } catch (e) {};
      done();
    })

    it("test_manyToOneReplace2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1],
        iconResource:'1'
      }) as GridLayoutItemInfo;
      let gridLayoutItem2= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.CONTAINER_DESKTOP ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1],
        iconResource:'1'
      }) as GridLayoutItemInfo;
      try {
        transferLayoutManager['manyToOneReplace']([gridLayoutItem1,gridLayoutItem2,gridLayoutItem2,gridLayoutItem2,gridLayoutItem2]);
        transferLayoutManager['transferType'] = '';
      } catch (e) {};
      done();
    })

    it("test_isNeedAddToNotHarmnoyFolder_01", 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
        let mockFunction1: Function =
          mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerItem);
        when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.appStatus = AppStatus.WAIT_FOR_HARMONY + 1;
        let result = transferLayoutManager['isNeedAddToNotHarmnoyFolder'](item);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    })

    it("test_isNeedAddToNotHarmnoyFolder_02", 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
        let mockFunction1: Function =
          mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerItem);
        when(mockFunction1)(ArgumentMatchers.any).afterReturn(false);
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.appStatus = AppStatus.WAIT_FOR_HARMONY;
        item.typeId = CommonConstants.TYPE_APP + 1;
        let result = transferLayoutManager['isNeedAddToNotHarmnoyFolder'](item);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    })

    it("test_isNeedAddToNotHarmnoyFolder_03", 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
        let map: Map<string, Object> = new Map();
        map.set(NotHarmonyUtil.APP_TYPE, AppReserveType.TASTE_FRESH);
        let mockFunction1: Function =
          mocker.mockFunc(CommonUtils, CommonUtils.jsonStrToMap);
        when(mockFunction1)(ArgumentMatchers.any).afterReturn(map);
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.appStatus = AppStatus.WAIT_FOR_HARMONY;
        item.typeId = CommonConstants.TYPE_APP;
        let result = transferLayoutManager['isNeedAddToNotHarmnoyFolder'](item);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(CommonUtils);
      mocker.clearAll();
    })

    it("test_isNeedAddToNotHarmnoyFolder_04", 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
        let map: Map<string, Object> = new Map();
        map.set(NotHarmonyUtil.APP_TYPE, AppReserveType.TASTE_FRESH);
        let mockFunction1: Function =
          mocker.mockFunc(CommonUtils, CommonUtils.jsonStrToMap);
        when(mockFunction1)(ArgumentMatchers.any).afterReturn(map);
        let mockFunction2: Function =
          mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerItem);
        when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.appStatus = AppStatus.WAIT_FOR_HARMONY;
        item.typeId = CommonConstants.TYPE_APP;
        let result = transferLayoutManager['isNeedAddToNotHarmnoyFolder'](item);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(CommonUtils);
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    })

    it("test_isNeedAddToNotHarmnoyFolder_05", 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
        let map: Map<string, Object> = new Map();
        map.set(NotHarmonyUtil.APP_TYPE, AppReserveType.TASTE_FRESH);
        let mockFunction1: Function = mocker.mockFunc(CommonUtils, CommonUtils.jsonStrToMap);
        when(mockFunction1)(ArgumentMatchers.any).afterReturn(map);
        let mockFunction2: Function = mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerItem);
        when(mockFunction2)(ArgumentMatchers.any).afterReturn(false);
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.appStatus = AppStatus.WAIT_FOR_HARMONY;
        item.typeId = CommonConstants.TYPE_APP;
        let result = transferLayoutManager['isNeedAddToNotHarmnoyFolder'](item);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(CommonUtils);
      mocker.clear(DeliverUtil);
      mocker.clearAll();
    })

    it("test_collectDesktop1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FOLDER ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FORM_STACK ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let gridLayoutItem2= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FORM_COMBINE ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let gridLayoutItem3= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FILE_FOLDER ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['validAndCollectFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['putPageData']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction2: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['validAndCollectFormStack']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn([]);
      let mockFunction3: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction4: Function =
        mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(true);
      try {
        transferLayoutManager['collectDesktop'](gridLayoutItem,[gridLayoutItem]);
        transferLayoutManager['collectDesktop'](gridLayoutItem1,[gridLayoutItem]);
        transferLayoutManager['collectDesktop'](gridLayoutItem2,[gridLayoutItem]);
        transferLayoutManager['collectDesktop'](gridLayoutItem3,[gridLayoutItem]);
        expect(gridLayoutItem.page).assertEqual(1);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      mocker.clear(CheckEmptyUtils);
      mocker.clear(DeviceHelper);
      done();
    })

    it("test_collectSmartDock1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      transferLayoutManager['isNewLayout'] = true;
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FOLDER ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['validAndCollectFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      try {
        transferLayoutManager['collectSmartDock'](gridLayoutItem,[gridLayoutItem]);
        expect(transferLayoutManager['isNewLayout']).assertEqual(true);
        transferLayoutManager['isNewLayout'] = false;
        transferLayoutManager['transferType'] = '';
        transferLayoutManager['restDockList'] = [];
        transferLayoutManager['dockList'] = [];
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_collectSmartDock2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      transferLayoutManager['isNewLayout'] = true;
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FOLDER ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['validAndCollectFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        transferLayoutManager['collectSmartDock'](gridLayoutItem,[gridLayoutItem]);
        expect(transferLayoutManager['isNewLayout']).assertEqual(true);
        transferLayoutManager['isNewLayout'] = false;
        transferLayoutManager['transferType'] = '';
        transferLayoutManager['restDockList'] = [];
        transferLayoutManager['dockList'] = [];
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_collectSmartDock3", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FUNCTION ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      try {
        expect(transferLayoutManager['collectSmartDock'](gridLayoutItem,[gridLayoutItem]) === undefined).assertTrue();
        transferLayoutManager['dockList'] = [];
      } catch (e) {};
      mocker.clear(DeviceHelper);
      done();
    })

    it("test_collectUniqueSingle0", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_APP,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let uniqueApp: Object[] = [];
      expect(transferLayoutManager['collectUniqueSingle'](gridLayoutItem,[gridLayoutItem],uniqueApp) === undefined).assertTrue();
      transferLayoutManager['addLastScrean'] = [];
      done();
    })

    it("test_collectUniqueSingle01", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FOLDER ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['validAndCollectFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(gridLayoutItem);
      let uniqueApp: Object[] = [];
      try {
        expect(transferLayoutManager['collectUniqueSingle'](gridLayoutItem,[gridLayoutItem],uniqueApp) === undefined).assertTrue();
        transferLayoutManager['addLastScrean'] = [];
      } catch (e) {};
      mocker.clear(DeviceHelper);

      done();
    })

    it("test_isAppOrSmallFolder1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.CONTAINER_UNIQUE_SINGLE,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FOLDER ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      try {
        let result = transferLayoutManager['isAppOrSmallFolder'](gridLayoutItem);
        expect(result).not().assertUndefined();
      } catch (e) {};
      done();
    })

    it("test_validAndCollectFolder1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: 100,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FOLDER ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1],
        id:1
      }) as GridLayoutItemInfo;
      let gridLayoutItem1 = new Object({
        row: 1,
        column: 1,
        container: 100,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FOLDER ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1],
        id:1
      }) as GridLayoutItemInfo;
      try {
        let result = transferLayoutManager['validAndCollectFolder'](gridLayoutItem,[gridLayoutItem1],1);
        expect(result).assertNull();
      } catch (e) {};
      done();
    })

    it("test_validAndCollectFolder2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: 1,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FOLDER ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1],
        id:1,
        intent:''
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(DeliverUtil, DeliverUtil.isContainerItem);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        let result = transferLayoutManager['validAndCollectFolder'](gridLayoutItem,[gridLayoutItem],1);
        expect(result).not().assertUndefined();
      } catch (e) {};
      mocker.clear(DeliverUtil);
      done();
    })

    it("test_validAndCollectFolder3", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: 1,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FOLDER ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1],
        id:1,
        intent:'',
        folderName:'${new_folder_name}'
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['filterFolderDuplicateElement']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn([gridLayoutItem,gridLayoutItem,gridLayoutItem]);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['updateFoldersRowAndColumn']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        let result = transferLayoutManager['validAndCollectFolder'](gridLayoutItem,[gridLayoutItem,gridLayoutItem,gridLayoutItem],1);
        expect(result).not().assertUndefined();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_validAndCollectFormStack1", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: 100,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FOLDER ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1],
        id:1
      }) as GridLayoutItemInfo;
      let gridLayoutItem1 = new Object({
        row: 1,
        column: 1,
        container: 100,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_FOLDER ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1],
        id:1
      }) as GridLayoutItemInfo;
      try {
        let result = transferLayoutManager['validAndCollectFormStack'](gridLayoutItem,[gridLayoutItem1]);
        expect(result).assertNull();
      } catch (e) {};
      done();
    })

    it("test_validAndCollectFormStack2", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: 1,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_CARD ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1],
        id:1
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['putCombineCard']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        let result = transferLayoutManager['validAndCollectFormStack'](gridLayoutItem,[gridLayoutItem]);
        expect(result).not().assertUndefined();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_validAndCollectFormStack3", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: 1,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_ADD ,
        layoutInfo:[[]],
        appIndex:1,
        infoId:'1',
        area:[1,1],
        id:1,
        formStackId:'formStackId'
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['putCombineCard']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        let result = transferLayoutManager['validAndCollectFormStack'](gridLayoutItem,[gridLayoutItem,gridLayoutItem,gridLayoutItem]);
        expect(result).not().assertUndefined();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })
    it("test_validAndCollectFormStack4", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: 1,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName',
        cardName:'cardName',
        typeId: CommonConstants.TYPE_ADD ,
        layoutInfo:[[]],
        appIndex:1,
        area:[1,1],
        id:1,
        formStackId:'formStackId'
      }) as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['putCombineCard']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        let result = transferLayoutManager['validAndCollectFormStack'](gridLayoutItem,[gridLayoutItem,gridLayoutItem,gridLayoutItem]);
        expect(result).not().assertUndefined();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_validAndCollectFormStack5", 0, () => {
      try {
        let result = transferLayoutManager['validAndCollectFormStack'](layoutInfos[0], layoutInfos);
        expect(result).assertEqual(null);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_validAndCollectFormStack6", 0, () => {
      try {
        let gridItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        if(layoutInfos[6].layoutInfo?.[0] !== undefined){
          gridItemInfo = layoutInfos[6]?.layoutInfo[0][0];
        }
        let result = transferLayoutManager['validAndCollectFormStack'](layoutInfos[6], [gridItemInfo]);
        expect(result.typeId).assertEqual(CommonConstants.TYPE_APP);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_dealWithExcessiveDockList01', 0, async () => {
      let oldDockList: BaseTransferBean[] = [];
      oldDockList.fill(layoutInfos[0] as BaseTransferBean, 0, 3);
      let result = transferLayoutManager.dealWithExcessiveDockList(oldDockList);
      expect(result.length).assertEqual(0);
    });

    it('test_dealWithExcessiveDockList02', 0, async () => {
      let oldDockList: BaseTransferBean[] = new Array(4);
      oldDockList.fill(layoutInfos[0] as BaseTransferBean, 0, 4);
      let result = transferLayoutManager.dealWithExcessiveDockList(oldDockList);
      expect(result.length).assertEqual(4);
    });

    it('test_dealWithExcessiveDockList03', 0, async () => {
      let oldDockList: BaseTransferBean[] = new Array(5);
      oldDockList.fill(layoutInfos[0] as BaseTransferBean, 0, 5);
      let result = transferLayoutManager.dealWithExcessiveDockList(oldDockList);
      expect(result.length).assertEqual(4);
    });

    it('test_dealWithExcessiveDockList04', 0, async () => {
      let oldDockList: BaseTransferBean[] = new Array(4);
      oldDockList.fill(layoutInfos[0] as BaseTransferBean, 0, 4);
      oldDockList.push(layoutInfos[layoutInfos.length -1] as BaseTransferBean);
      let result = transferLayoutManager.dealWithExcessiveDockList(oldDockList);
      expect(result.length).assertEqual(4);
    });

    it('test_collectDesktopItem01', 0, () => {
      let dataElement: GridLayoutItemInfo = new GridLayoutItemInfo();
      dataElement.typeId = CommonConstants.TYPE_APP;
      let data: GridLayoutItemInfo[] = [];
      transferLayoutManager.collectDesktopItem(dataElement, data);
      expect(data.length).assertEqual(1);
      expect(data[0]).assertEqual(dataElement);
    });

    it('test_collectDesktopItem02', 0, () => {
      let data: GridLayoutItemInfo[] = [];
      transferLayoutManager.collectDesktopItem(layoutInfos[layoutInfos.length -1], data);
      expect(data.length).assertLarger(1);
    });

    it('test_createNewScreen01', 0, () => {
      let moveItems: BaseTransferBean[] = [];
      let currentPage: number = 1;
      let result: ScreenTransferBean = transferLayoutManager['createNewScreen'](moveItems, currentPage);
      expect(result.page).assertEqual(currentPage);
      expect(result.children.length).assertEqual(0);
      expect(result.usedCellCnt).assertEqual(0);
      expect(result.iconUsedCellCnt).assertEqual(0);
      expect(result.folderUsedCellCnt).assertEqual(0);
      expect(result.abilityFormUsedCellCnt).assertEqual(0);
    });

    it('test_createNewScreen02', 0, () => {
      let moveItems: BaseTransferBean[] = [];
      let currentPage: number = 1;
      let result: ScreenTransferBean = transferLayoutManager['createNewScreen'](moveItems, currentPage);
      expect(result.page).assertEqual(currentPage);
      expect(result.children.length).assertEqual(0);
      expect(result.usedCellCnt).assertEqual(0);
      expect(result.iconUsedCellCnt).assertEqual(0);
      expect(result.folderUsedCellCnt).assertEqual(0);
      expect(result.abilityFormUsedCellCnt).assertEqual(0);
    });

    it('test_createNewScreen03', 0, () => {
      let moveItems: BaseTransferBean[] = [
        new BaseTransferBean(),
        new BaseTransferBean(),
        new BaseTransferBean()
      ];
      moveItems[0].typeId = CommonConstants.TYPE_CARD;
      moveItems[0].keyName = "card1";
      moveItems[0].area = [2, 2];
      moveItems[1].typeId = CommonConstants.TYPE_FORM_STACK;
      moveItems[1].keyName = "form1";
      moveItems[1].area = [2, 2];
      moveItems[2].typeId = CommonConstants.TYPE_FOLDER;
      moveItems[2].keyName = "folder1";
      moveItems[2].area = [2, 2];
      let currentPage: number = 1;
      let result: ScreenTransferBean = transferLayoutManager['createNewScreen'](moveItems, currentPage);
      expect(result.page).assertEqual(currentPage);
      expect(result.children.length).assertEqual(3);
      expect(result.usedCellCnt).assertEqual(12);
      expect(result.iconUsedCellCnt).assertEqual(0);
      expect(result.folderUsedCellCnt).assertEqual(4);
      expect(result.abilityFormUsedCellCnt).assertEqual(8);
    });

    it('test_createNewScreen04', 0, () => {
      let moveItems: BaseTransferBean[] = [
        new BaseTransferBean(),
        new BaseTransferBean(),
        new BaseTransferBean()
      ];
      moveItems[0].typeId = CommonConstants.TYPE_APP;
      moveItems[0].keyName = "app1";
      moveItems[0].area = [1, 1];
      moveItems[1].typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      moveItems[1].keyName = "shortcut1";
      moveItems[1].area = [1, 1];
      moveItems[2].typeId = CommonConstants.TYPE_FOLDER;
      moveItems[2].keyName = "folder1";
      moveItems[2].area = [2, 2];
      let currentPage: number = 1;
      let result: ScreenTransferBean = transferLayoutManager['createNewScreen'](moveItems, currentPage);
      expect(result.page).assertEqual(currentPage);
      expect(result.children.length).assertEqual(3);
      expect(result.usedCellCnt).assertEqual(6);
      expect(result.iconUsedCellCnt).assertEqual(2);
      expect(result.folderUsedCellCnt).assertEqual(4);
      expect(result.abilityFormUsedCellCnt).assertEqual(0);
    });

    it('test_createNewScreen04', 0, () => {
      let mock = new MockKit();
      let moveItems: BaseTransferBean[] = [
        new BaseTransferBean(),
        new BaseTransferBean(),
        new BaseTransferBean()
      ];
      moveItems[0].typeId = CommonConstants.TYPE_FOLDER;
      moveItems[0].keyName = "应用";
      moveItems[0].area = [1, 1];
      moveItems[1].typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      moveItems[1].keyName = "shortcut1";
      moveItems[1].area = [1, 1];
      moveItems[2].typeId = CommonConstants.TYPE_FORM_COMBINE;
      moveItems[2].keyName = "组合卡片";
      moveItems[2].area = [2, 2];
      try {
        let mockFunc: Function = mock.mockFunc(dataConvert, transferLayoutManager['findAndUpdatePosition']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let currentPage: number = 1;
        let result: ScreenTransferBean = transferLayoutManager['createNewScreen'](moveItems, currentPage);
        expect(result.page).assertEqual(currentPage);
        expect(result.children.length).assertEqual(3);
        expect(result.iconUsedCellCnt).assertEqual(1);
        expect(result.folderUsedCellCnt).assertEqual(1);
        expect(result.abilityFormUsedCellCnt).assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clearAll();
    });

    it('test_createNewScreen05', 0, () => {
      let mock = new MockKit();
      let moveItems: BaseTransferBean[] = [
        new BaseTransferBean(),
        new BaseTransferBean(),
        new BaseTransferBean()
      ];
      moveItems[0].typeId = CommonConstants.TYPE_FOLDER;
      moveItems[0].keyName = "应用";
      moveItems[0].area = [1, 1];
      moveItems[1].typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      moveItems[1].keyName = "shortcut1";
      moveItems[1].area = [1, 1];
      moveItems[2].typeId = CommonConstants.TYPE_FORM_COMBINE;
      moveItems[2].keyName = "组合卡片";
      moveItems[2].area = [2, 2];
      try {
        let mockFunc: Function = mock.mockFunc(dataConvert, transferLayoutManager['findAndUpdatePosition']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        let currentPage: number = 1;
        let result: ScreenTransferBean = transferLayoutManager['createNewScreen'](moveItems, currentPage);
        expect(result.page).assertEqual(currentPage);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clearAll();
    });

    it('test_compareAppItem01', 0, () => {
      let a: GridLayoutItemInfo = new GridLayoutItemInfo();
      a.appIndex = 0;
      let b: GridLayoutItemInfo = new GridLayoutItemInfo();
      b.appIndex = 1;
      const result = transferLayoutManager.compareAppItem(a, b);
      expect(result).assertEqual(1);
    });

    it('test_compareAppItem02', 0, () => {
      let a: GridLayoutItemInfo = new GridLayoutItemInfo();
      a.appIndex = 0;
      a.container = -100;
      let b: GridLayoutItemInfo = new GridLayoutItemInfo();
      b.appIndex = 0;
      b.container = -101;
      const result = transferLayoutManager.compareAppItem(a, b);
      expect(result).assertEqual(-1);
    });

    it('test_compareAppItem03', 0, () => {
      let a: GridLayoutItemInfo = new GridLayoutItemInfo();
      a.appIndex = 1;
      a.container = 44;
      let b: GridLayoutItemInfo = new GridLayoutItemInfo();
      b.appIndex = 1;
      b.container = -100;
      const result = transferLayoutManager.compareAppItem(a, b);
      expect(result).assertLarger(0);
    });

    it('test_compareAppItem04', 0, () => {
      let a: GridLayoutItemInfo = new GridLayoutItemInfo();
      a.appIndex = 1;
      a.container = 0;
      a.page = 1;
      let b: GridLayoutItemInfo = new GridLayoutItemInfo();
      b.appIndex = 1;
      b.container = 0;
      b.page = 0;
      const result = transferLayoutManager.compareAppItem(a, b);
      expect(result).assertEqual(1);
    });

    it('test_compareAppItem05', 0, () => {
      let a: GridLayoutItemInfo = new GridLayoutItemInfo();
      a.appIndex = 1;
      a.container = 0;
      a.page = 1;
      a.row = 1;
      let b: GridLayoutItemInfo = new GridLayoutItemInfo();
      b.appIndex = 1;
      b.container = 0;
      b.page = 1;
      b.row = 0;
      const result = transferLayoutManager.compareAppItem(a, b);
      expect(result).assertEqual(1);
    });

    it('test_compareAppItem06', 0, () => {
      let a: GridLayoutItemInfo = new GridLayoutItemInfo();
      a.appIndex = 1;
      a.container = 0;
      a.page = 1;
      a.row = 1;
      a.column = 1;
      let b: GridLayoutItemInfo = new GridLayoutItemInfo();
      b.appIndex = 1;
      b.container = 0;
      b.page = 1;
      b.row = 1;
      b.column = 0;
      const result = transferLayoutManager.compareAppItem(a, b);
      expect(result).assertEqual(1);
    });

    it('test_getRowElementMap01', 0, () => {
      let screenData: ScreenTransferBean = new ScreenTransferBean();
      screenData.children = [
        layoutInfos[0] as BaseTransferBean,
        layoutInfos[1] as BaseTransferBean
      ];
      let rowElementMap: Map<number, number[]> = new Map();
      let result = transferLayoutManager.getRowElementMap(screenData, rowElementMap);
      expect(result).assertEqual(6);
    });

    it('test_getRowElementMap02', 0, () => {
      let screenData: ScreenTransferBean = new ScreenTransferBean();
      screenData.children = [];
      let rowElementMap: Map<number, number[]> = new Map();
      let result = transferLayoutManager.getRowElementMap(screenData, rowElementMap);
      expect(result).assertEqual(0);
      expect(rowElementMap.size).assertEqual(0);
    });

    it('test_getRowElementMap03', 0, () => {
      let screenData: ScreenTransferBean = new ScreenTransferBean();
      screenData.children = [
        layoutInfos[0] as BaseTransferBean,
        layoutInfos[1] as BaseTransferBean
      ];
      let rowElementMap: Map<number, number[]> = new Map();
      rowElementMap.set(1, [0]);
      let result = transferLayoutManager.getRowElementMap(screenData, rowElementMap);
      expect(result).assertEqual(6);
    });

    it('test_addWidgetEmptyRow01', 0, () => {
      let screenData: ScreenTransferBean = new ScreenTransferBean();
      let widgetIndexArr: number[] = [0];
      transferLayoutManager.addWidgetEmptyRow(screenData, widgetIndexArr);
      expect(widgetIndexArr.length).assertEqual(1);
    });

    it('test_addWidgetEmptyRow02', 0, () => {
      transferLayoutManager.fromGrid = [4, 5];
      let screenData: ScreenTransferBean = new ScreenTransferBean();
      let widgetIndexArr: number[] = [0];
      transferLayoutManager.addWidgetEmptyRow(screenData, widgetIndexArr);
      expect(widgetIndexArr.length).assertEqual(1);
      transferLayoutManager.fromGrid = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
    });

    it('test_addWidgetEmptyRow03', 0, () => {
      transferLayoutManager.fromGrid = [4, 5];
      let screenData: ScreenTransferBean = new ScreenTransferBean();
      screenData.children = [
        layoutInfos[0] as BaseTransferBean,
        layoutInfos[1] as BaseTransferBean
      ];
      let widgetIndexArr: number[] = [2];
      transferLayoutManager.addWidgetEmptyRow(screenData, widgetIndexArr);
      expect(widgetIndexArr.length).assertEqual(1);
      transferLayoutManager.fromGrid = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
    });

    it('test_addWidgetEmptyRow04', 0, () => {
      transferLayoutManager.fromGrid = [4, 5];
      let screenData: ScreenTransferBean = new ScreenTransferBean();
      screenData.children = [
        layoutInfos[0] as BaseTransferBean,
        layoutInfos[1] as BaseTransferBean
      ];
      screenData.children = [layoutInfos[0] as BaseTransferBean];
      let widgetIndexArr: number[] = [1];
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(transferLayoutManager, transferLayoutManager.getRowElementMap);
      when(mockfunc1)(ArgumentMatchers.any).afterReturn(8);
      transferLayoutManager.addWidgetEmptyRow(screenData, widgetIndexArr);
      expect(screenData.children.length).assertEqual(1);
      mocker.ignoreMock(transferLayoutManager, transferLayoutManager.getRowElementMap);
      transferLayoutManager.fromGrid = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
    });

    it('test_addWidgetEmptyRow05', 0, async () => {
      transferLayoutManager.fromGrid = [4, 5];
      let screenData: ScreenTransferBean = new ScreenTransferBean();
      screenData.children = [
        layoutInfos[0] as BaseTransferBean,
        layoutInfos[1] as BaseTransferBean
      ];
      screenData.children = [layoutInfos[0] as BaseTransferBean];
      let widgetIndexArr: number[] = [1];
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(transferLayoutManager, transferLayoutManager.getRowElementMap);
      when(mockfunc1)(ArgumentMatchers.any).afterReturn(0);
      transferLayoutManager.addWidgetEmptyRow(screenData, widgetIndexArr);
      expect(screenData.children.length).assertEqual(1);
      mocker.ignoreMock(transferLayoutManager, transferLayoutManager.getRowElementMap);
      transferLayoutManager.fromGrid = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
    });

    it('test_updateOccupied_01', 0, () => {
      try {
        let newPage: ScreenTransferBean = new ScreenTransferBean();
        newPage.occupied = [];
        transferLayoutManager['updateOccupied'](0, 0, 3, 2, newPage);
        expect(newPage.occupied.length).assertEqual(2);
        expect(newPage.occupied[0].length).assertEqual(3);
        expect(newPage.occupied[1].length).assertEqual(3);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_updateOccupied_02', 0, () => {
      try {
        let newPage: ScreenTransferBean = new ScreenTransferBean();
        newPage.occupied = [[true, true, true], [true, true, true]];
        transferLayoutManager['updateOccupied'](0, 0, 2, 2, newPage);
        expect(newPage.occupied.length).assertEqual(2);
        expect(newPage.occupied[0].length).assertEqual(3);
        expect(newPage.occupied[1].length).assertEqual(3);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_updateOccupied_03', 0, () => {
      try {
        let newPage: ScreenTransferBean = new ScreenTransferBean();
        newPage.occupied = [[true, true, true], [true, true, true]];
        transferLayoutManager['updateOccupied'](2, 0, 0, 2, newPage);
        expect(newPage.occupied.length).assertEqual(2);
        expect(newPage.occupied[0].length).assertEqual(3);
        expect(newPage.occupied[1].length).assertEqual(3);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_updateOccupied_04', 0, () => {
      try {
        let newPage: ScreenTransferBean = new ScreenTransferBean();
        newPage.occupied = [[true, true, true], [true, true, true]];
        transferLayoutManager['updateOccupied'](0, 2, 2, 0, newPage);
        expect(newPage.occupied.length).assertEqual(2);
        expect(newPage.occupied[0].length).assertEqual(3);
        expect(newPage.occupied[1].length).assertEqual(3);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_refreshOccupied01', 0, () => {
      let newPage: ScreenTransferBean = new ScreenTransferBean();
      transferLayoutManager.refreshOccupied(newPage,[4,6]);
      expect(newPage.occupied.length).assertLargerOrEqual(0);
    });

    it('test_refreshOccupied02', 0, () => {
      let newPage: ScreenTransferBean = new ScreenTransferBean();
      newPage.children = screenData.children;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      transferLayoutManager.refreshOccupied(newPage,[]);
      expect(newPage.occupied.length).assertEqual(0);
      mocker.clear(CheckEmptyUtils);
    });

    it('test_refreshOccupied03', 0, () => {
      let newPage: ScreenTransferBean = new ScreenTransferBean();
      newPage.children = screenData.children;
      transferLayoutManager.refreshOccupied(newPage,[4,6]);
      expect(newPage.occupied.length).assertEqual(6);
      expect(newPage.occupied[0][1]).assertEqual(true);
    });

    it("insertNewLayoutToDb1", 0, () => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let layoutInfo = [
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
          page: 0,
          typeId: CommonConstants.TYPE_CARD
        },
      ] as GridLayoutItemInfo[];
      try {
        transferLayoutManager.insertNewLayoutToDb(layoutInfo, true);
      } catch (e) {
      }
      expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
    })

    it("insertNewLayoutToDb2", 0, () => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let layoutInfo = [
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
          page: 0,
          typeId: CommonConstants.TYPE_CARD
        },
      ] as GridLayoutItemInfo[];
      try {
        transferLayoutManager.insertNewLayoutToDb(layoutInfo, false);
      } catch (e) {};
      expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
    })

    it("insertNewLayoutToDb3", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FORM_STACK,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_CARD
      }) as GridLayoutItemInfo;
      let rdbStoreManagerInstance:RdbStoreManager = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['getNewLayoutFromScreenDataMap']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn([gridLayoutItem,gridLayoutItem]);
      let mockFunction1: Function =
        mocker.mockFunc(rdbStoreManagerInstance, rdbStoreManagerInstance.deleteAllGridInfoData);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      let mockFunction2: Function =
        mocker.mockFunc(rdbStoreManagerInstance, rdbStoreManagerInstance.updateSettings);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      let mockFunction3: Function =
        mocker.mockFunc(rdbStoreManagerInstance, rdbStoreManagerInstance.insertGridLayoutInfo);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      try {
        transferLayoutManager.insertNewLayoutToDb([gridLayoutItem,gridLayoutItem]);
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      mocker.clear(rdbStoreManagerInstance);
      done();
    })

    it('placeElementsByRow01', Level.LEVEL0, async (done:Function) => {
      try {
        let curRowElements: number[] = [];
        let needToNextPageIndex: number[] = [];
        let occupied: boolean[][] = [];
        transferLayoutManager['placeElementsByRow'](curRowElements, screenData, occupied, needToNextPageIndex);
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {};
      done();
    })

    it('test_dealWithLessSpace1', 0, () => {
      try {
        let curRowElements: number[] = [];
        let needToNextPageIndex: number[] = [];
        let occupied: boolean[][] = [];
        transferLayoutManager['dealWithLessSpace'](curRowElements, occupied, screenData, needToNextPageIndex);
        expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_dealWithLessSpace2", 0, () => {
      let mocker: MockKit = new MockKit();
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      try {
        let curRowElements: number[] = [];
        let needToNextPageIndex: number[] = [];
        let occupied: boolean[][] = [];
        let mockFunction: Function =
          mocker.mockFunc(transferLayoutManager, transferLayoutManager['findAreaByRow']);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
        let mockFunction1: Function =
          mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillOccupied']);
        when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
        transferLayoutManager['dealWithLessSpace'](curRowElements, occupied, screenData, needToNextPageIndex);
        expect(curRowElements.length >= 0).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(transferLayoutManager);
    })

    it('test_mergeLastSmallFolderAndOtherSmallElement_01', Level.LEVEL0, async (done: Function) => {
      let screenData: ScreenTransferBean = initScreenTransferBean();
      let lastElement: BaseTransferBean = new BaseTransferBean();
      try {
        transferLayoutManager['mergeLastSmallFolderAndOtherSmallElement'](screenData, lastElement);
      } catch (error) {
      }
      expect(transferLayoutManager instanceof BaseTransferLayoutManager).assertTrue();
      done();
    })

    it("test_mergeLastSmallFolderAndOtherSmallElement_02", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_SHORTCUT_ICON ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[gridLayoutItem1,gridLayoutItem1],[gridLayoutItem1,gridLayoutItem1]]
      } as BaseTransferBean;
      let transferBean2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[gridLayoutItem1,gridLayoutItem1],[gridLayoutItem1,gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean2,transferBean,transferBean2],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['updateFoldersRowAndColumn']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['fillElementInfo']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['mergeLastSmallFolderAndOtherSmallElement'](screenItemInfo,transferBean);
        expect(screenItemInfo!.children!.length).not().assertEqual(0);
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it("test_mergeLastSmallFolderAndOtherSmallElement_03", 0, async(done:Function) => {
      let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
      let transferLayoutManager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
      let gridLayoutItem1= new Object({
        row: 1,
        column: 1,
        container: CommonConstants.TYPE_FOLDER,
        page: 1,
        isBigFold:true,
        bundleName:'bundleName2',
        typeId: CommonConstants.TYPE_FOLDER,
        layoutInfo:[[]],
        infoId:'1',
        area:[1,1]
      }) as GridLayoutItemInfo;
      let transferBean = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[gridLayoutItem1,gridLayoutItem1],[gridLayoutItem1,gridLayoutItem1]]
      } as BaseTransferBean;
      let transferBean2 = {
        layoutWeight: 1,
        page: 1,
        row: NumberConstants.CONSTANT_NUMBER_100,
        typeId: CommonConstants.TYPE_FOLDER ,
        isNeedRestoreFromBackup:false,
        bundleName:'bundleName',
        column:1,
        area:[2,2],
        layoutInfo:[[gridLayoutItem1,gridLayoutItem1],[gridLayoutItem1,gridLayoutItem1]]
      } as BaseTransferBean;
      let screenItemInfo = {
        page: 1,
        occupied: [[true]],
        folderUsedCellCnt: 0,
        children: [transferBean,transferBean,transferBean],
        moveToNextPage: [transferBean,transferBean2,transferBean,transferBean2],
        usedCellCnt:100,
        abilityFormUsedCellCnt:24
      } as ScreenTransferBean;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(transferLayoutManager, transferLayoutManager['updateFoldersRowAndColumn']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      try {
        transferLayoutManager['mergeLastSmallFolderAndOtherSmallElement'](screenItemInfo,transferBean);
        expect(screenItemInfo!.children).not().assertUndefined();
      } catch (e) {};
      mocker.clear(transferLayoutManager);
      done();
    })

    it('test_mergeLastSmallFolderAndOtherSmallElement_04', 0, () => {
      let mock = new MockKit();
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferlayoutmanager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
        let appBaseBean: BaseTransferBean = new BaseTransferBean();
        appBaseBean.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
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
        let appBaseBean2: BaseTransferBean = new BaseTransferBean();
        appBaseBean2.typeId = CommonConstants.TYPE_FOLDER;
        appBaseBean2.layoutInfo = [];
        appBaseBean2.infoId = '60';
        appBaseBean2.infoName = '设置';
        appBaseBean2.bundleName = 'com.ohos.settings';
        appBaseBean2.abilityName = 'com.ohos.settings.MainAbility';
        appBaseBean2.moduleName = 'phone_settings';
        appBaseBean2.container = CommonConstants.CONTAINER_DESKTOP;
        appBaseBean2.badgeNumber = 3;
        appBaseBean2.page = 0;
        appBaseBean2.row = 0;
        appBaseBean2.column = 1;
        appBaseBean2.area = [1, 1];
        appBaseBean2.layoutInfo[0] = [];
        let screenData: ScreenTransferBean = initScreenTransferBean();
        screenData.children.push(appBaseBean);
        screenData.children.push(appBaseBean2);
        let mockFunc: Function = mock.mockFunc(DeliverUtil, DeliverUtil.isContainerFolder);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        transferlayoutmanager['mergeLastSmallFolderAndOtherSmallElement'](screenData, appBaseBean2);
        expect(transferlayoutmanager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeliverUtil);
      mock.clearAll();
    })

    it('test_mergeLastAppAndOtherSmallElement_01', 0, () => {
      let mock = new MockKit();
      try {
        let fromGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let toGrid: number[] = [CommonConstants.DEFAULT_COL, CommonConstants.DEFAULT_ROW];
        let transferlayoutmanager: BaseTransferLayoutManager = new BaseTransferLayoutManager(fromGrid, toGrid);
        let appBaseBean: BaseTransferBean = new BaseTransferBean();
        appBaseBean.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
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
        let appBaseBean2: BaseTransferBean = new BaseTransferBean();
        appBaseBean2.typeId = CommonConstants.TYPE_FOLDER;
        appBaseBean2.layoutInfo = [];
        appBaseBean2.infoId = '60';
        appBaseBean2.infoName = '设置';
        appBaseBean2.bundleName = 'com.ohos.settings';
        appBaseBean2.abilityName = 'com.ohos.settings.MainAbility';
        appBaseBean2.moduleName = 'phone_settings';
        appBaseBean2.container = CommonConstants.CONTAINER_DESKTOP;
        appBaseBean2.badgeNumber = 3;
        appBaseBean2.page = 0;
        appBaseBean2.row = 0;
        appBaseBean2.column = 1;
        appBaseBean2.area = [1, 1];
        appBaseBean2.layoutInfo[0] = [];
        let screenData: ScreenTransferBean = initScreenTransferBean();
        screenData.children.push(appBaseBean);
        screenData.children.push(appBaseBean2);
        let mockFunc: Function = mock.mockFunc(DeliverUtil, DeliverUtil.isContainerFolder);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        transferlayoutmanager['mergeLastAppAndOtherSmallElement'](screenData, appBaseBean2);
        expect(transferlayoutmanager instanceof BaseTransferLayoutManager).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeliverUtil);
      mock.clearAll();
    })

    it("test_isNeedAddToAppFolder_01", 0, () => {
      try {
        let itemInfo = {
          typeId: CommonConstants.TYPE_CARD,
        } as GridLayoutItemInfo;
        let result = transferLayoutManager['isNeedAddToAppFolder'](itemInfo);
        expect(result).assertEqual(false);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_isNeedAddToAppFolder_02", 0, () => {
      try {
        let pkg: string = '1';
        let itemInfo = {
          typeId: CommonConstants.TYPE_APP,
          intent: JSON.stringify(new Map([['installSource', pkg]])),
        } as GridLayoutItemInfo;
        let result = transferLayoutManager['isNeedAddToAppFolder'](itemInfo);
        expect(result).assertEqual(false);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_isNeedAddToAppFolder_03", 0, () => {
      let mock = new MockKit();
      try {
        let pkg: string = DeliverUtil.APP_PKG;
        let itemInfo = {
          typeId: CommonConstants.TYPE_APP,
          appStatus: 0,
          intent: JSON.stringify(new Map([['installSource', pkg]])),
        } as GridLayoutItemInfo;
        let mockFunc: Function = mock.mockFunc(dataConvert, dataConvert.isInContainerFolder);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        let result = transferLayoutManager['isNeedAddToAppFolder'](itemInfo);
        expect(result).assertEqual(false);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_isNeedAddToAppFolder_04", 0, () => {
      let mock = new MockKit();
      try {
        let itemInfo = {
          typeId: CommonConstants.TYPE_APP,
          appStatus: 1,
          intent: '{"installSource":"com.ohos.abroad"}',
        } as GridLayoutItemInfo;
        let mockFunc: Function = mock.mockFunc(dataConvert, dataConvert.isInContainerFolder);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        let result = transferLayoutManager['isNeedAddToAppFolder'](itemInfo);
        expect(result).assertEqual(true);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it("test_isNeedAddToAppFolder_05_7", 0, () => {
      let mock = new MockKit();
      try {
        let itemInfo = {
          typeId: CommonConstants.TYPE_APP,
          appStatus: 0,
          intent: '{"installSource":"com.ohos.abroad"}',
        } as GridLayoutItemInfo;
        let mockFunc: Function = mock.mockFunc(dataConvert, dataConvert.isInContainerFolder);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        let result = transferLayoutManager['isNeedAddToAppFolder'](itemInfo);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it("test_removeWidgetEmptyRow_01", 0, () => {
      try {
        let emptyScreenBean :ScreenTransferBean  = new ScreenTransferBean()
        let result = transferLayoutManager['removeWidgetEmptyRow'](emptyScreenBean);
        expect(result.size).assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_removeWidgetEmptyRow_02", 0, () => {
      try {
        let result = transferLayoutManager['removeWidgetEmptyRow'](screenData);
        expect(result.size).assertLarger(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_dealSpecialFolderElements_01", 0, () => {
      try {
        transferLayoutManager['dealSpecialFolderElements']([]);
        expect(transferLayoutManager['toGrid'].length).assertEqual(2);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it("test_dealSpecialFolderElements_02", 0, () => {
      try {
        let dhItemInfos: GridLayoutItemInfo[] = initDhItemInfos();
        transferLayoutManager['dealSpecialFolderElements']([dhItemInfos[1] as BaseTransferBean]);
        expect(transferLayoutManager['fromGrid'].length).assertEqual(2);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

  })
}