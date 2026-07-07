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
import { NumberConstants } from '@ohos/commonconstants';
import { CommonConstants, GridLayoutItemInfo, DockItemInfo, } from '../../../../../../../main/ets/TsIndex';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  Level,
} from '@ohos/hypium';
import { LogBatchPrint } from '../../../../../../../main/ets/transformdata/dfx/LogBatchPrint';
import { BaseTransferBean } from '../../../../../../../main/ets/transformdata/BaseTransferBean';


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
  // 文件夹子应用
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
  // 文件夹子应用1
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
  // 子卡1
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
  // 子卡2
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
  // 堆叠卡片
  let gridLayoutStackCard: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutStackCard.id = 66;
  gridLayoutStackCard.typeId = CommonConstants.TYPE_FORM_STACK;
  gridLayoutStackCard.infoId = '666';
  gridLayoutStackCard.container = CommonConstants.CONTAINER_DESKTOP;
  gridLayoutStackCard.page = 3;
  gridLayoutStackCard.row = 0;
  gridLayoutStackCard.column = 4;
  gridLayoutStackCard.area = [2, 4];
  gridLayoutStackCard.layoutInfo = [];
  gridLayoutStackCard.layoutInfo[0] = [gridLayoutCombineItemCard1, gridLayoutCombineItemCard2];
  // 组合卡片
  let gridLayoutCombineCard: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutCombineCard.id = 66;
  gridLayoutCombineCard.typeId = CommonConstants.TYPE_FORM_COMBINE;
  gridLayoutCombineCard.infoId = '666';
  gridLayoutCombineCard.container = CommonConstants.CONTAINER_DESKTOP;
  gridLayoutCombineCard.page = 3;
  gridLayoutCombineCard.row = 0;
  gridLayoutCombineCard.column = 4;
  gridLayoutCombineCard.area = [2, 4];
  gridLayoutCombineCard.layoutInfo = [];
  gridLayoutCombineCard.layoutInfo[0] = [gridLayoutCombineItemCard1, gridLayoutCombineItemCard2];
  // 快捷方式
  let gridLayoutShortcut: GridLayoutItemInfo = new GridLayoutItemInfo();
  gridLayoutShortcut.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
  gridLayoutShortcut.infoId = '60';
  gridLayoutShortcut.infoName = '联系人';
  gridLayoutShortcut.bundleName = 'com.ohos.settings';
  gridLayoutShortcut.abilityName = 'com.ohos.settings.MainAbility';
  gridLayoutShortcut.moduleName = 'phone_settings';
  gridLayoutShortcut.container = CommonConstants.CONTAINER_DESKTOP;
  gridLayoutShortcut.badgeNumber = 3;
  gridLayoutShortcut.page = 0;
  gridLayoutShortcut.row = 0;
  gridLayoutShortcut.column = 1;
  gridLayoutShortcut.area = [1, 1];

  layoutInfos = [gridLayoutApp, gridLayoutItemCard, gridLayoutFolder, gridLayoutStackCard, gridLayoutCombineCard,
    gridLayoutShortcut];
  return layoutInfos;
}

function initDockItemInfos(): DockItemInfo[] {
  let dockLayoutInfos: DockItemInfo[] = [];
  // DockAPP
  let gridLayoutDockApp: DockItemInfo = new DockItemInfo();
  gridLayoutDockApp.typeId = CommonConstants.TYPE_APP;
  gridLayoutDockApp.bundleName = 'com.ohos.contacts';
  gridLayoutDockApp.abilityName = 'com.ohos.contacts.MainAbility';
  gridLayoutDockApp.moduleName = 'entry';
  gridLayoutDockApp.container = CommonConstants.CONTAINER_DOCK;
  gridLayoutDockApp.badgeNumber = 3;
  gridLayoutDockApp.page = 4;
  gridLayoutDockApp.row = 0;
  gridLayoutDockApp.column = 0;
  gridLayoutDockApp.area = [1, 1];
  // Dock文件夹应用
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
  // Dock文件夹应用
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
  let gridLayoutDockFolder: DockItemInfo = new DockItemInfo();
  gridLayoutDockFolder.id = 66;
  gridLayoutDockFolder.typeId = CommonConstants.TYPE_FOLDER;
  gridLayoutDockFolder.bundleName = '';
  gridLayoutDockFolder.abilityName = '';
  gridLayoutDockFolder.moduleName = '';
  gridLayoutDockFolder.container = CommonConstants.CONTAINER_DOCK;
  gridLayoutDockFolder.column = 0;
  gridLayoutDockFolder.area = [1, 1];
  gridLayoutDockFolder.layoutInfo = [];
  gridLayoutDockFolder.layoutInfo[0] = [gridLayoutDockFolderItem1, gridLayoutDockFolderItem2];
  // 快捷方式
  let gridLayoutShortcut: DockItemInfo = new DockItemInfo();
  gridLayoutShortcut.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
  gridLayoutShortcut.bundleName = 'com.ohos.settings';
  gridLayoutShortcut.abilityName = 'com.ohos.settings.MainAbility';
  gridLayoutShortcut.moduleName = 'phone_settings';
  gridLayoutShortcut.container = CommonConstants.CONTAINER_DESKTOP;
  gridLayoutShortcut.badgeNumber = 3;
  gridLayoutShortcut.page = 0;
  gridLayoutShortcut.row = 0;
  gridLayoutShortcut.column = 1;
  gridLayoutShortcut.area = [1, 1];

  dockLayoutInfos = [gridLayoutDockApp, gridLayoutDockFolder, gridLayoutShortcut];
  return dockLayoutInfos;
}

export default function LogBatchPrintTest() {
  describe('LogBatchPrintTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('test_getDesktopLayoutObject01', Level.LEVEL0, () => {
      let layoutInfos: GridLayoutItemInfo[] = initGridLayoutItemInfos();
      let reultObj: Object = LogBatchPrint.getDesktopLayoutObject(layoutInfos[0]);
      expect(Object.keys(reultObj).includes('appStatus')).assertTrue();
    });

    it('test_getDesktopLayoutObject02', Level.LEVEL0, () => {
      let layoutInfos: GridLayoutItemInfo[] = initGridLayoutItemInfos();
      let reultObj: Object = LogBatchPrint.getDesktopLayoutObject(layoutInfos[1]);
      expect(Object.keys(reultObj).includes('cardId')).assertTrue();
    });

    it('test_getDesktopLayoutObject03', Level.LEVEL0, () => {
      let layoutInfos: GridLayoutItemInfo[] = initGridLayoutItemInfos();
      let reultObj: Object = LogBatchPrint.getDesktopLayoutObject(layoutInfos[2]);
      expect(Object.keys(reultObj).includes('subItemLength')).assertTrue();
    });

    it('test_getDesktopLayoutObject04', Level.LEVEL0, () => {
      let layoutInfos: GridLayoutItemInfo[] = initGridLayoutItemInfos();
      let reultObj: Object = LogBatchPrint.getDesktopLayoutObject(layoutInfos[3]);
      expect(Object.keys(reultObj).includes('subCardIdList')).assertTrue();
    });

    it('test_getDesktopLayoutObject05', Level.LEVEL0, () => {
      let layoutInfos: GridLayoutItemInfo[] = initGridLayoutItemInfos();
      let reultObj: Object = LogBatchPrint.getDesktopLayoutObject(layoutInfos[4]);
      expect(Object.keys(reultObj).includes('typeId')).assertTrue();
    });

    it('test_getDesktopLayoutObject06', Level.LEVEL0, () => {
      let layoutInfos: GridLayoutItemInfo[] = initGridLayoutItemInfos();
      let reultObj: Object = LogBatchPrint.getDesktopLayoutObject(layoutInfos[5]);
      expect(Object.keys(reultObj).includes('appStatus')).assertTrue();
    });

    it('test_getDockCacheObject01', Level.LEVEL0, () => {
      let layoutInfos: DockItemInfo[] = initDockItemInfos();
      let reultObj: Object = LogBatchPrint.getDockCacheObject(layoutInfos[1]);
      expect(Object.keys(reultObj).includes('subKeyNameList')).assertTrue();
    });

    it('test_getDockCacheObject02', Level.LEVEL0, () => {
      let layoutInfos: DockItemInfo[] = initDockItemInfos();
      let reultObj: Object = LogBatchPrint.getDockCacheObject(layoutInfos[0]);
      expect(Object.keys(reultObj).includes('appName')).assertTrue();
    });

    it('test_getDockCacheObject03', Level.LEVEL0, () => {
      let layoutInfos: DockItemInfo[] = initDockItemInfos();
      let reultObj: Object = LogBatchPrint.getDockCacheObject(layoutInfos[2]);
      expect(Object.keys(reultObj).includes('keyName')).assertTrue();
    });

    it('test_getDesktopLayoutObject01', Level.LEVEL0, () => {
      let srcObj: Object[] = []
      let instance: LogBatchPrint = new LogBatchPrint();
      let desc: string = 'test';
      let callerName = 'backup';
      LogBatchPrint.printLogsInBatch(srcObj, 5, desc, callerName);
      expect(instance instanceof LogBatchPrint).assertTrue();
    });

    it('test_printLogsInBatch01', Level.LEVEL0, () => {
      let srcObj: Object[] = []
      let instance: LogBatchPrint = new LogBatchPrint();
      let desc: string = 'test';
      let callerName = 'backup';
      LogBatchPrint.printLogsInBatch(srcObj, 5, desc, callerName);
      expect(instance instanceof LogBatchPrint).assertTrue();
    });

    it('test_printLogsInBatch02', Level.LEVEL0, () => {
      let layoutInfos: GridLayoutItemInfo[] = initGridLayoutItemInfos();
      let srcObj: Object[] = [layoutInfos[0]];
      let instance: LogBatchPrint = new LogBatchPrint();
      let desc: string = 'test';
      let callerName = 'backup';
      LogBatchPrint.printLogsInBatch(srcObj, NumberConstants.CONSTANT_NUMBER_FIVE, desc, callerName);
      expect(instance instanceof LogBatchPrint).assertTrue();
    });

    it('test_getUniqueItemObject01', Level.LEVEL0, () => {
      let layoutInfos: GridLayoutItemInfo[] = initGridLayoutItemInfos();
      let reultObj: Object =  LogBatchPrint.getUniqueItemObject(layoutInfos[0] as BaseTransferBean);
      expect(Object.keys(reultObj).includes('appIndex')).assertTrue();
    });

    it('test_getUniqueItemObject02', Level.LEVEL0, () => {
      let layoutInfos: GridLayoutItemInfo[] = initGridLayoutItemInfos();
      let reultObj: Object =  LogBatchPrint.getUniqueItemObject(layoutInfos[1] as BaseTransferBean);
      expect(Object.keys(reultObj).includes('cardId')).assertTrue();
    });

    it('test_getUniqueItemObject03', Level.LEVEL0, () => {
      let layoutInfos: GridLayoutItemInfo[] = initGridLayoutItemInfos();
      let reultObj: Object =  LogBatchPrint.getUniqueItemObject(layoutInfos[2] as BaseTransferBean);
      expect(Object.keys(reultObj).includes('folderName')).assertTrue();
    });

    it('test_getUniqueItemObject04', Level.LEVEL0, () => {
      let layoutInfos: GridLayoutItemInfo[] = initGridLayoutItemInfos();
      let reultObj: Object =  LogBatchPrint.getUniqueItemObject(layoutInfos[2] as BaseTransferBean);
      expect(Object.keys(reultObj).includes('folderName')).assertTrue();
    });

    it('test_getUniqueItemObject04', Level.LEVEL0, () => {
      let layoutInfos: GridLayoutItemInfo[] = initGridLayoutItemInfos();
      let reultObj: Object =  LogBatchPrint.getUniqueItemObject(layoutInfos[3] as BaseTransferBean);
      expect(Object.keys(reultObj).includes('FormStackId')).assertTrue();
    });

    it('test_getUniqueItemObject04', Level.LEVEL0, () => {
      let layoutInfos: GridLayoutItemInfo[] = initGridLayoutItemInfos();
      let reultObj: Object =  LogBatchPrint.getUniqueItemObject(layoutInfos[5] as BaseTransferBean);
      expect(Object.keys(reultObj).includes('shortcutId')).assertTrue();
    });
  })
}
