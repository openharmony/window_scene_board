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

import { DragGridParam, DragGridPosition } from '@ohos/componentdrag';
import { RTLUtil } from '@ohos/componenthelper';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { describe, it, expect, MockKit, ArgumentMatchers, when } from '@ohos/hypium';
import { DesktopFileInfo } from '../../../../../../main/ets/bean/DesktopFileInfo';
import {
  AppStatus,
  CommonConstants,
  DockItemInfo,
  GridLayoutItemInfo,
  GridLayoutUtil,
  DefaultDesktopLayoutInfo,
  LayoutDescription,
  AppItemInfo,
  NotHarmonyUtil,
  BitSet
} from '../../../../../../main/ets/TsIndex';

const TEST_PROP_NAME = 'test_gridlayout_item_info';

export default function GridLayoutUtilTest() {
  describe('GridLayoutUtilTest', (): void => {
    it('isProxyTypeGridLayout', 0, (): void => {
      const itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.ohos.sceneboard.plrdtest';
      expect(GridLayoutUtil.isProxyTypeGridLayout(itemInfo)).assertFalse();

      AppStorage.setOrCreate<GridLayoutItemInfo>(TEST_PROP_NAME, itemInfo);
      expect(GridLayoutUtil.isProxyTypeGridLayout(itemInfo)).assertFalse();

      const itemInfoFromStorage = AppStorage.get<GridLayoutItemInfo>(TEST_PROP_NAME);
      expect(GridLayoutUtil.isProxyTypeGridLayout(itemInfoFromStorage)).assertTrue();
    })

    it('mapProxyTypeGridLayoutTest', 0, (): void => {
      const layoutInfo: Array<GridLayoutItemInfo[]> = [];
      const firstPageItems: GridLayoutItemInfo[] = [];

      const itemInfo1 = new GridLayoutItemInfo();
      itemInfo1.bundleName = 'com.ohos.ailife';
      firstPageItems.push(itemInfo1);

      const itemInfo2 = new GridLayoutItemInfo();
      itemInfo2.bundleName = 'com.ohos.totemweather';
      firstPageItems.push(itemInfo2);

      const itemInfo3 = new GridLayoutItemInfo();
      itemInfo3.bundleName = 'com.ohos.samplemanagement';
      firstPageItems.push(itemInfo3);

      const itemInfo4 = new GridLayoutItemInfo();
      firstPageItems.push(itemInfo4);

      layoutInfo.push(firstPageItems);

      const itemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.ohos.sceneboard.plrdtest';

      itemInfo.layoutInfo = layoutInfo;

      AppStorage.setOrCreate<GridLayoutItemInfo>(TEST_PROP_NAME, itemInfo);
      const itemInfoFromStorage = AppStorage.get<GridLayoutItemInfo>(TEST_PROP_NAME);
      expect(GridLayoutUtil.isProxyTypeGridLayout(itemInfoFromStorage)).assertTrue();

      const mappedItemInfo = GridLayoutUtil.mapProxyTypeGridLayout(itemInfoFromStorage);
      expect(GridLayoutUtil.isProxyTypeGridLayout(mappedItemInfo)).assertFalse();

      expect(mappedItemInfo.bundleName === 'com.ohos.sceneboard.plrdtest').assertTrue();
      expect(mappedItemInfo.layoutInfo?.length === 1).assertTrue();
      expect(mappedItemInfo.layoutInfo?.[0]?.length === 4).assertTrue();
      expect(mappedItemInfo.layoutInfo?.[0]?.[0].bundleName === 'com.ohos.ailife').assertTrue();
    })

    it('test_calculateItemRowEnd', 0, (): void => {
      let itemInfo: GridLayoutItemInfo | undefined = undefined;
      let res = GridLayoutUtil.calculateItemRowEnd(itemInfo);
      expect(res === 0).assertTrue();
    })

    it('test_calculateItemRowEnd_1', 0, (): void => {
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.ohos.sceneboard.plrdtest';
      itemInfo.container = 100;
      itemInfo.typeId = 1;
      itemInfo.row = 3;
      itemInfo.column = 0;
      itemInfo.area = [2, 1];
      let res = GridLayoutUtil.calculateItemRowEnd(itemInfo);
      expect(res === 3).assertTrue();
    })

    it('test_calculateItemRowEnd_2', 0, (): void => {
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.ohos.sceneboard.plrdtest';
      itemInfo.container = 100;
      itemInfo.typeId = 1;
      itemInfo.column = 0;
      itemInfo.area = [2, 1];
      let res = GridLayoutUtil.calculateItemRowEnd(itemInfo);
      expect(res === 0).assertTrue();
    })

    it('test_calculateItemRowEnd_3', 0, (): void => {
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.ohos.sceneboard.plrdtest';
      itemInfo.container = 100;
      itemInfo.typeId = 1;
      itemInfo.row = -1;
      itemInfo.column = 0;
      itemInfo.area = [2, 1];
      let res = GridLayoutUtil.calculateItemRowEnd(itemInfo);
      expect(res === 0).assertTrue();
    })

    it('test_calculateItemRowEnd_4', 0, (): void => {
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.ohos.sceneboard.plrdtest';
      itemInfo.container = 100;
      itemInfo.typeId = 1;
      itemInfo.row = 3;
      itemInfo.column = 0;
      let res = GridLayoutUtil.calculateItemRowEnd(itemInfo);
      expect(res === 0).assertTrue();
    })

    it('test_calculateItemColEnd', 0, (): void => {
      let itemInfo: GridLayoutItemInfo | undefined = undefined;
      let res = GridLayoutUtil.calculateItemColEnd(itemInfo);
      expect(res === 0).assertTrue();
    })

    it('test_calculateItemColEnd_1', 0, (): void => {
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.ohos.sceneboard.plrdtest';
      itemInfo.container = 100;
      itemInfo.typeId = 1;
      itemInfo.row = 3;
      itemInfo.column = 0;
      itemInfo.area = [2, 1];
      let res = GridLayoutUtil.calculateItemColEnd(itemInfo);
      expect(res === 1).assertTrue();
    })

    it('test_calculateItemColEnd_2', 0, (): void => {
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.ohos.sceneboard.plrdtest';
      itemInfo.container = 100;
      itemInfo.typeId = 1;
      itemInfo.row = 3;
      itemInfo.area = [2, 1];
      let res = GridLayoutUtil.calculateItemColEnd(itemInfo);
      expect(res === 0).assertTrue();
    })

    it('test_calculateItemColEnd_3', 0, (): void => {
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.ohos.sceneboard.plrdtest';
      itemInfo.container = 100;
      itemInfo.typeId = 1;
      itemInfo.row = 3;
      itemInfo.column = -1;
      itemInfo.area = [2, 1];
      let res = GridLayoutUtil.calculateItemColEnd(itemInfo);
      expect(res === 0).assertTrue();
    })

    it('test_calculateItemColEnd_4', 0, (): void => {
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'com.ohos.sceneboard.plrdtest';
      itemInfo.container = 100;
      itemInfo.typeId = 1;
      itemInfo.row = 3;
      itemInfo.column = 0;
      let res = GridLayoutUtil.calculateItemColEnd(itemInfo);
      expect(res === 0).assertTrue();
    })

    it('test_isValidLayoutItem', 0, (): void => {
      let itemInfo: GridLayoutItemInfo | undefined | null = undefined;
      try {
        let res = GridLayoutUtil.isValidLayoutItem(itemInfo);
        expect(res).not().assertNull();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      itemInfo = null;
      try {
        let res = GridLayoutUtil.isValidLayoutItem(itemInfo);
        expect(res).not().assertNull();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('test_isValidLayoutItem_1', 0, (): void => {
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'abc123';
      itemInfo.container = 100;
      itemInfo.typeId = 3;
      itemInfo.page = 0;
      itemInfo.row = 1;
      itemInfo.column = 1;
      let res = GridLayoutUtil.isValidLayoutItem(itemInfo);
      expect(res).not().assertNull();
      itemInfo.typeId = CommonConstants.TYPE_FOLDER;
      res = GridLayoutUtil.isValidLayoutItem(itemInfo);
      expect(res).not().assertNull();
      itemInfo.folderId = 'opq';
      res = GridLayoutUtil.isValidLayoutItem(itemInfo);
      expect(res).not().assertNull();
    })

    it('test_isValidLayoutItem_2', 0, (): void => {
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'abc123';
      itemInfo.container = 100;
      itemInfo.typeId = 1;
      itemInfo.page = 0;
      itemInfo.row = 1;
      itemInfo.column = 1;
      let res = GridLayoutUtil.isValidLayoutItem(itemInfo);
      expect(res).not().assertNull();
      itemInfo.typeId = CommonConstants.TYPE_CARD;
      res = GridLayoutUtil.isValidLayoutItem(itemInfo);
      expect(res).not().assertNull();
      itemInfo.cardId = '7890';
      res = GridLayoutUtil.isValidLayoutItem(itemInfo);
      expect(res).not().assertNull();
    })

    it('test_isValidLayoutItem_3', 0, (): void => {
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'abc123';
      itemInfo.container = 100;
      itemInfo.typeId = 5
      itemInfo.page = 0;
      itemInfo.row = 1;
      itemInfo.column = 1;
      let res = GridLayoutUtil.isValidLayoutItem(itemInfo);
      expect(res).not().assertNull();
      itemInfo.typeId = CommonConstants.TYPE_FILE_FOLDER;
      res = GridLayoutUtil.isValidLayoutItem(itemInfo);
      expect(res).not().assertNull();
      itemInfo.ino = 'rst';
      res = GridLayoutUtil.isValidLayoutItem(itemInfo);
      expect(res).not().assertNull();
    })

    it('test_isValidLayoutItem_4', 0, (): void => {
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.bundleName = 'abc123';
      itemInfo.container = 100;
      itemInfo.typeId = 6;
      itemInfo.page = 0;
      itemInfo.row = 1;
      itemInfo.column = 1;
      let res = GridLayoutUtil.isValidLayoutItem(itemInfo);
      expect(res).not().assertNull();
      itemInfo.typeId = CommonConstants.TYPE_FORM_STACK;
      res = GridLayoutUtil.isValidLayoutItem(itemInfo);
      expect(res).not().assertNull();
      itemInfo.formStackId = 'uvw';
      res = GridLayoutUtil.isValidLayoutItem(itemInfo);
      expect(res).not().assertNull();
    })

    it('test_isValidLayoutItem_5', 0, (): void => {
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.container = 100;
      itemInfo.page = 0;
      itemInfo.row = 1;
      itemInfo.column = 1;
      let res = GridLayoutUtil.isValidLayoutItem(itemInfo);
      expect(itemInfo.column == 1).assertTrue();
      expect(res).not().assertNull();

      itemInfo.bundleName = 'abc123';
      res = GridLayoutUtil.isValidLayoutItem(itemInfo);
      expect(itemInfo.bundleName).not().assertUndefined();
      expect(res).assertTrue();

      itemInfo.typeId = CommonConstants.TYPE_FORM_STACK;
      res = GridLayoutUtil.isValidLayoutItem(itemInfo);
      expect(res).not().assertNull();
      itemInfo.formStackId = 'xyz';
      res = GridLayoutUtil.isValidLayoutItem(itemInfo);
      expect(res).assertTrue();
    })

    it('test_isValidLayoutItem_6', 0, (): void => {
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.container = 100;
      itemInfo.page = 0;
      itemInfo.row = 1;
      itemInfo.column = 1;
      let res = GridLayoutUtil.isValidLayoutItem(itemInfo);
      expect(itemInfo.column === 1).assertTrue();
      expect(res).not().assertNull();

      itemInfo.bundleName = 'abc123';
      res = GridLayoutUtil.isValidLayoutItem(itemInfo);
      expect(itemInfo.bundleName).not().assertUndefined();
      expect(res).assertTrue();

      itemInfo.typeId = CommonConstants.TYPE_REGION_FOLDER;
      res = GridLayoutUtil.isValidLayoutItem(itemInfo);
      expect(res).not().assertNull();
      itemInfo.folderId = 'xyz';
      res = GridLayoutUtil.isValidLayoutItem(itemInfo);
      expect(res).assertTrue();
    })

    it('test_isAppInstalled', 0, (): void => {
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      expect(itemInfo.appStatus === 0).assertTrue();
      let res = GridLayoutUtil.isAppInstalled(itemInfo);
      expect(res).assertTrue();

      itemInfo.appStatus = AppStatus.INSTALLED;
      expect(itemInfo.appStatus === 0).assertTrue();
      res = GridLayoutUtil.isAppInstalled(itemInfo);
      expect(res).assertTrue();

      itemInfo.appStatus = AppStatus.DOWNLOADING;
      expect(itemInfo.appStatus === 0).assertFalse();
      res = GridLayoutUtil.isAppInstalled(itemInfo);
      expect(res).assertFalse();
    })

    it('test_isAppInstalled_1', 0, (): void => {
      let itemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemInfo.appStatus = undefined;
      expect(itemInfo.appStatus === undefined).assertTrue();
      let res = GridLayoutUtil.isAppInstalled(itemInfo);
      expect(res).assertTrue();
    })

    it('test_dockItemToGridLayout', 0, (): void => {
      let dockItem: DockItemInfo = new DockItemInfo();
      dockItem.itemType = 321;
      dockItem.typeId = 789;
      dockItem.appId = 'dockItemAppId';
      dockItem.moduleName = 'dockItemModuleName';
      let gridLayoutInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);
      expect(gridLayoutInfo.itemType === '321').assertFalse();
    })

    it('test_dockItemToGridLayout_1', 0, (): void => {
      let dockItem: DockItemInfo = new DockItemInfo();
      dockItem.itemType = 321;
      dockItem.typeId = 789;
      dockItem.appId = 'dockItemAppId';
      dockItem.moduleName = 'dockItemModuleName';
      let gridLayoutInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);
      expect(gridLayoutInfo.typeId === 789).assertTrue();
    })

    it('test_dockItemToGridLayout_2', 0, (): void => {
      let dockItem: DockItemInfo = new DockItemInfo();
      dockItem.itemType = 321;
      dockItem.typeId = 789;
      dockItem.appId = 'dockItemAppId';
      dockItem.moduleName = 'dockItemModuleName';
      let gridLayoutInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);
      expect(gridLayoutInfo.infoId === 'dockItemAppId').assertTrue();
    })

    it('test_dockItemToGridLayout_3', 0, (): void => {
      let dockItem: DockItemInfo = new DockItemInfo();
      dockItem.itemType = 321;
      dockItem.typeId = 789;
      dockItem.appId = 'dockItemAppId';
      dockItem.moduleName = 'dockItemModuleName';
      let gridLayoutInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);
      expect(gridLayoutInfo.bundleName === '').assertTrue();
    })

    it('test_dockItemToGridLayout_4', 0, (): void => {
      let dockItem: DockItemInfo = new DockItemInfo();
      dockItem.itemType = 321;
      dockItem.typeId = 789;
      dockItem.appId = 'dockItemAppId';
      dockItem.moduleName = 'dockItemModuleName';
      let gridLayoutInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);
      expect(gridLayoutInfo.abilityName === '').assertTrue();
    })

    it('test_dockItemToGridLayout_5', 0, (): void => {
      let dockItem: DockItemInfo = new DockItemInfo();
      dockItem.itemType = 321;
      dockItem.typeId = 789;
      dockItem.appId = 'dockItemAppId';
      dockItem.moduleName = 'dockItemModuleName';
      let gridLayoutInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);
      expect(gridLayoutInfo.moduleName === 'dockItemModuleName').assertTrue();
    })

    it('test_dockItemToGridLayout_6', 0, (): void => {
      let dockItem: DockItemInfo = new DockItemInfo();
      dockItem.appLabelId = 1;
      dockItem.applicationLabelId = 2;
      dockItem.appName = 'dockItemAppName';
      dockItem.areaType = 3;
      dockItem.keyName = 'dockItemKeyName';
      dockItem.badgeNumber = 4;
      let gridLayoutInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);

      expect(gridLayoutInfo.appIconId === 0).assertTrue();
      dockItem.appIconId = 753;
      gridLayoutInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);
      expect(gridLayoutInfo.appIconId === 753).assertTrue();

      expect(gridLayoutInfo.container === -101).assertTrue();
      expect(gridLayoutInfo.appLabelId === 1).assertTrue();
      expect(gridLayoutInfo.applicationLabelId === 2).assertTrue();
      expect(gridLayoutInfo.appName === 'dockItemAppName').assertTrue();
      expect(gridLayoutInfo.areaType === 3).assertTrue();
      expect(gridLayoutInfo.keyName === 'dockItemKeyName').assertTrue();
      expect(gridLayoutInfo.badgeNumber === 4).assertTrue();
    })

    it('test_dockItemToGridLayout_7', 0, (): void => {
      let dockItem: DockItemInfo = new DockItemInfo();
      dockItem.appLabelId = 1;
      dockItem.applicationLabelId = 2;
      dockItem.areaType = 3;
      dockItem.keyName = 'dockItemKeyName';
      dockItem.badgeNumber = 4;
      dockItem.appIconId = 5;
      let gridLayoutInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);

      expect(gridLayoutInfo.appName === '').assertTrue();
      dockItem.appName = 'dockItemAppName';
      gridLayoutInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);
      expect(gridLayoutInfo.appName === 'dockItemAppName').assertTrue();

      expect(gridLayoutInfo.container === -101).assertTrue();
      expect(gridLayoutInfo.appLabelId === 1).assertTrue();
      expect(gridLayoutInfo.applicationLabelId === 2).assertTrue();
      expect(gridLayoutInfo.areaType === 3).assertTrue();
      expect(gridLayoutInfo.keyName === 'dockItemKeyName').assertTrue();
      expect(gridLayoutInfo.badgeNumber === 4).assertTrue();
      expect(gridLayoutInfo.appIconId === 5).assertTrue();
    })

    it('test_dockItemToGridLayout_8', 0, (): void => {
      let dockItem: DockItemInfo = new DockItemInfo();
      dockItem.appName = 'dockItemAppName';
      dockItem.appLabelId = 1;
      dockItem.applicationLabelId = 2;
      dockItem.areaType = 3;
      dockItem.keyName = 'dockItemKeyName';
      dockItem.badgeNumber = 4;
      dockItem.appIconId = 5;
      let gridLayoutInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);

      expect(gridLayoutInfo.appLabelId === 1).assertTrue();
      dockItem.appLabelId = 1000;
      gridLayoutInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);
      expect(gridLayoutInfo.appLabelId === 1000).assertTrue();

      expect(gridLayoutInfo.container === -101).assertTrue();
      expect(gridLayoutInfo.appName === 'dockItemAppName').assertTrue();
      expect(gridLayoutInfo.applicationLabelId === 2).assertTrue();
      expect(gridLayoutInfo.areaType === 3).assertTrue();
      expect(gridLayoutInfo.keyName === 'dockItemKeyName').assertTrue();
      expect(gridLayoutInfo.badgeNumber === 4).assertTrue();
      expect(gridLayoutInfo.appIconId === 5).assertTrue();
    })

    it('test_dockItemToGridLayout_9', 0, (): void => {
      let dockItem: DockItemInfo = new DockItemInfo();
      dockItem.appName = 'dockItemAppName';
      dockItem.appLabelId = 1;
      dockItem.applicationLabelId = 2;
      dockItem.areaType = 3;
      dockItem.keyName = 'dockItemKeyName';
      dockItem.badgeNumber = 4;
      dockItem.appIconId = 5;
      let gridLayoutInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);

      expect(gridLayoutInfo.applicationLabelId === 2).assertTrue();
      dockItem.applicationLabelId = 1000;
      gridLayoutInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);
      expect(gridLayoutInfo.applicationLabelId === 1000).assertTrue();

      expect(gridLayoutInfo.container === -101).assertTrue();
      expect(gridLayoutInfo.appName === 'dockItemAppName').assertTrue();
      expect(gridLayoutInfo.appLabelId === 1).assertTrue();
      expect(gridLayoutInfo.areaType === 3).assertTrue();
      expect(gridLayoutInfo.keyName === 'dockItemKeyName').assertTrue();
      expect(gridLayoutInfo.badgeNumber === 4).assertTrue();
      expect(gridLayoutInfo.appIconId === 5).assertTrue();
    })

    it('test_dockItemToGridLayout_10', 0, (): void => {
      let dockItem: DockItemInfo = new DockItemInfo();
      dockItem.appName = 'dockItemAppName';
      dockItem.appLabelId = 1;
      dockItem.applicationLabelId = 2;
      dockItem.areaType = 3;
      dockItem.keyName = 'dockItemKeyName';
      dockItem.badgeNumber = 4;
      dockItem.appIconId = 5;
      let gridLayoutInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);

      expect(gridLayoutInfo.areaType === 3).assertTrue();
      dockItem.areaType = 1000;
      gridLayoutInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);
      expect(gridLayoutInfo.areaType === 1000).assertTrue();

      expect(gridLayoutInfo.container === -101).assertTrue();
      expect(gridLayoutInfo.appName === 'dockItemAppName').assertTrue();
      expect(gridLayoutInfo.appLabelId === 1).assertTrue();
      expect(gridLayoutInfo.applicationLabelId === 2).assertTrue();
      expect(gridLayoutInfo.keyName === 'dockItemKeyName').assertTrue();
      expect(gridLayoutInfo.badgeNumber === 4).assertTrue();
      expect(gridLayoutInfo.appIconId === 5).assertTrue();
    })

    it('test_dockItemToGridLayout_11', 0, (): void => {
      let dockItem: DockItemInfo = new DockItemInfo();
      dockItem.appName = 'dockItemAppName';
      dockItem.appLabelId = 1;
      dockItem.applicationLabelId = 2;
      dockItem.areaType = 3;
      dockItem.keyName = 'dockItemKeyName';
      dockItem.badgeNumber = 4;
      dockItem.appIconId = 5;
      let gridLayoutInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);

      expect(gridLayoutInfo.keyName === 'dockItemKeyName').assertTrue();
      dockItem.keyName = 'dockItemKeyName2';
      gridLayoutInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);
      expect(gridLayoutInfo.keyName === 'dockItemKeyName2').assertTrue();

      expect(gridLayoutInfo.container === -101).assertTrue();
      expect(gridLayoutInfo.appName === 'dockItemAppName').assertTrue();
      expect(gridLayoutInfo.appLabelId === 1).assertTrue();
      expect(gridLayoutInfo.applicationLabelId === 2).assertTrue();
      expect(gridLayoutInfo.areaType === 3).assertTrue();
      expect(gridLayoutInfo.badgeNumber === 4).assertTrue();
      expect(gridLayoutInfo.appIconId === 5).assertTrue();
    })

    it('test_dockItemToGridLayout_12', 0, (): void => {
      let dockItem: DockItemInfo = new DockItemInfo();
      dockItem.appName = 'dockItemAppName';
      dockItem.appLabelId = 1;
      dockItem.applicationLabelId = 2;
      dockItem.areaType = 3;
      dockItem.keyName = 'dockItemKeyName';
      dockItem.badgeNumber = 4;
      dockItem.appIconId = 5;
      let gridLayoutInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);

      expect(gridLayoutInfo.badgeNumber === 4).assertTrue();
      dockItem.badgeNumber = 1000;
      gridLayoutInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);
      expect(gridLayoutInfo.badgeNumber === 1000).assertTrue();

      expect(gridLayoutInfo.container === -101).assertTrue();
      expect(gridLayoutInfo.appName === 'dockItemAppName').assertTrue();
      expect(gridLayoutInfo.appLabelId === 1).assertTrue();
      expect(gridLayoutInfo.applicationLabelId === 2).assertTrue();
      expect(gridLayoutInfo.areaType === 3).assertTrue();
      expect(gridLayoutInfo.appIconId === 5).assertTrue();
    })

    it('test_dockItemToGridLayout_13', 0, (): void => {
      let dockItem: DockItemInfo = new DockItemInfo();
      dockItem.row = 1;
      dockItem.column = 2;
      dockItem.isUninstallAble = true;
      dockItem.appStatus = 3;
      dockItem.downloadProgress = 4;
      dockItem.iconResource = 'dockItemIconResource';
      dockItem.callerName = 'dockItemCallerName';
      let gridLayoutInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);

      expect(gridLayoutInfo.row === 1).assertTrue();
      dockItem.row = 1000;
      gridLayoutInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);
      expect(gridLayoutInfo.row === 1000).assertTrue();

      expect(gridLayoutInfo.area?.[0] === 1).assertTrue();
      expect(gridLayoutInfo.area?.[1] === 1).assertTrue();
      expect(gridLayoutInfo.column === 2).assertTrue();
      expect(gridLayoutInfo.isUninstallAble === true).assertTrue();
      expect(gridLayoutInfo.appStatus === 3).assertTrue();
      expect(gridLayoutInfo.downloadProgress === 4).assertTrue();
      expect(gridLayoutInfo.iconResource === 'dockItemIconResource').assertTrue();
      expect(gridLayoutInfo.callerName === 'dockItemCallerName').assertTrue();
    })

    it('test_dockItemToGridLayout_14', 0, (): void => {
      let dockItem: DockItemInfo = new DockItemInfo();
      dockItem.row = 1;
      dockItem.column = 2;
      dockItem.isUninstallAble = true;
      dockItem.appStatus = 3;
      dockItem.downloadProgress = 4;
      dockItem.iconResource = 'dockItemIconResource';
      dockItem.callerName = 'dockItemCallerName';
      let gridLayoutInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);

      expect(gridLayoutInfo.column === 2).assertTrue();
      dockItem.column = 1000;
      gridLayoutInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);
      expect(gridLayoutInfo.column === 1000).assertTrue();

      expect(gridLayoutInfo.area?.[0] === 1).assertTrue();
      expect(gridLayoutInfo.area?.[1] === 1).assertTrue();
      expect(gridLayoutInfo.row === 1).assertTrue();
      expect(gridLayoutInfo.isUninstallAble === true).assertTrue();
      expect(gridLayoutInfo.appStatus === 3).assertTrue();
      expect(gridLayoutInfo.downloadProgress === 4).assertTrue();
      expect(gridLayoutInfo.iconResource === 'dockItemIconResource').assertTrue();
      expect(gridLayoutInfo.callerName === 'dockItemCallerName').assertTrue();
    })

    it('test_dockItemToGridLayout_15', 0, (): void => {
      let dockItem: DockItemInfo = new DockItemInfo();
      dockItem.row = 1;
      dockItem.column = 2;
      dockItem.isUninstallAble = true;
      dockItem.appStatus = 3;
      dockItem.downloadProgress = 4;
      dockItem.iconResource = 'dockItemIconResource';
      dockItem.callerName = 'dockItemCallerName';
      let gridLayoutInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);

      expect(gridLayoutInfo.isUninstallAble === true).assertTrue();
      dockItem.isUninstallAble = false;
      gridLayoutInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);
      expect(gridLayoutInfo.isUninstallAble === false).assertTrue();

      expect(gridLayoutInfo.area?.[0] === 1).assertTrue();
      expect(gridLayoutInfo.area?.[1] === 1).assertTrue();
      expect(gridLayoutInfo.row === 1).assertTrue();
      expect(gridLayoutInfo.column === 2).assertTrue();
      expect(gridLayoutInfo.appStatus === 3).assertTrue();
      expect(gridLayoutInfo.downloadProgress === 4).assertTrue();
      expect(gridLayoutInfo.iconResource === 'dockItemIconResource').assertTrue();
      expect(gridLayoutInfo.callerName === 'dockItemCallerName').assertTrue();
    })

    it('test_dockItemToGridLayout_16', 0, (): void => {
      let dockItem: DockItemInfo = new DockItemInfo();
      dockItem.row = 1;
      dockItem.column = 2;
      dockItem.isUninstallAble = true;
      dockItem.downloadProgress = 4;
      dockItem.iconResource = 'dockItemIconResource';
      dockItem.callerName = 'dockItemCallerName';
      let gridLayoutInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);

      expect(gridLayoutInfo.appStatus === 0).assertTrue();
      dockItem.appStatus = 1000;
      gridLayoutInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);
      expect(gridLayoutInfo.appStatus === 1000).assertTrue();

      expect(gridLayoutInfo.area?.[0] === 1).assertTrue();
      expect(gridLayoutInfo.area?.[1] === 1).assertTrue();
      expect(gridLayoutInfo.row === 1).assertTrue();
      expect(gridLayoutInfo.column === 2).assertTrue();
      expect(gridLayoutInfo.isUninstallAble === true).assertTrue();
      expect(gridLayoutInfo.downloadProgress === 4).assertTrue();
      expect(gridLayoutInfo.iconResource === 'dockItemIconResource').assertTrue();
      expect(gridLayoutInfo.callerName === 'dockItemCallerName').assertTrue();
    })

    it('test_dockItemToGridLayout_17', 0, (): void => {
      let dockItem: DockItemInfo = new DockItemInfo();
      dockItem.row = 1;
      dockItem.column = 2;
      dockItem.isUninstallAble = true;
      dockItem.appStatus = 3;
      dockItem.iconResource = 'dockItemIconResource';
      dockItem.callerName = 'dockItemCallerName';
      let gridLayoutInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);

      expect(gridLayoutInfo.downloadProgress === 0).assertTrue();
      dockItem.downloadProgress = 1000;
      gridLayoutInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);
      expect(gridLayoutInfo.downloadProgress === 1000).assertTrue();

      expect(gridLayoutInfo.area?.[0] === 1).assertTrue();
      expect(gridLayoutInfo.area?.[1] === 1).assertTrue();
      expect(gridLayoutInfo.row === 1).assertTrue();
      expect(gridLayoutInfo.column === 2).assertTrue();
      expect(gridLayoutInfo.isUninstallAble === true).assertTrue();
      expect(gridLayoutInfo.appStatus === 3).assertTrue();
      expect(gridLayoutInfo.iconResource === 'dockItemIconResource').assertTrue();
      expect(gridLayoutInfo.callerName === 'dockItemCallerName').assertTrue();
    })

    it('test_dockItemToGridLayout_18', 0, (): void => {
      let dockItem: DockItemInfo = new DockItemInfo();
      dockItem.row = 1;
      dockItem.column = 2;
      dockItem.isUninstallAble = true;
      dockItem.appStatus = 3;
      dockItem.downloadProgress = 4;
      dockItem.iconResource = 'dockItemIconResource';
      dockItem.callerName = 'dockItemCallerName';
      let gridLayoutInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);

      expect(gridLayoutInfo.iconResource === 'dockItemIconResource').assertTrue();
      dockItem.iconResource = 'dockItemIconResource2';
      gridLayoutInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);
      expect(gridLayoutInfo.iconResource === 'dockItemIconResource2').assertTrue();

      expect(gridLayoutInfo.area?.[0] === 1).assertTrue();
      expect(gridLayoutInfo.area?.[1] === 1).assertTrue();
      expect(gridLayoutInfo.row === 1).assertTrue();
      expect(gridLayoutInfo.column === 2).assertTrue();
      expect(gridLayoutInfo.isUninstallAble === true).assertTrue();
      expect(gridLayoutInfo.appStatus === 3).assertTrue();
      expect(gridLayoutInfo.downloadProgress === 4).assertTrue();
      expect(gridLayoutInfo.callerName === 'dockItemCallerName').assertTrue();
    })

    it('test_dockItemToGridLayout_19', 0, (): void => {
      let dockItem: DockItemInfo = new DockItemInfo();
      dockItem.row = 1;
      dockItem.column = 2;
      dockItem.isUninstallAble = true;
      dockItem.appStatus = 3;
      dockItem.downloadProgress = 4;
      dockItem.iconResource = 'dockItemIconResource';
      dockItem.callerName = 'dockItemCallerName';
      let gridLayoutInfo: GridLayoutItemInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);

      expect(gridLayoutInfo.callerName === 'dockItemCallerName').assertTrue();
      dockItem.callerName = 'dockItemCallerName2';
      gridLayoutInfo = GridLayoutUtil.dockItemToGridLayout(dockItem);
      expect(gridLayoutInfo.callerName === 'dockItemCallerName2').assertTrue();

      expect(gridLayoutInfo.area?.[0] === 1).assertTrue();
      expect(gridLayoutInfo.area?.[1] === 1).assertTrue();
      expect(gridLayoutInfo.row === 1).assertTrue();
      expect(gridLayoutInfo.column === 2).assertTrue();
      expect(gridLayoutInfo.isUninstallAble === true).assertTrue();
      expect(gridLayoutInfo.appStatus === 3).assertTrue();
      expect(gridLayoutInfo.downloadProgress === 4).assertTrue();
      expect(gridLayoutInfo.iconResource === 'dockItemIconResource').assertTrue();
    })

    it('test_gridLayoutToDockItem', 0, (): void => {
      let gridLayout: GridLayoutItemInfo | undefined = undefined;
      expect(gridLayout).assertUndefined();

      let dockItem: DockItemInfo = GridLayoutUtil.gridLayoutToDockItem(gridLayout);
      expect(dockItem.appName === '').assertTrue();
    })

    it('test_gridLayoutToDockItem_1', 0, (): void => {
      let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      expect(gridLayout).not().assertUndefined();

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
      gridLayout.area = [6, 7];
      gridLayout.areaType = 8;

      let dockItem: DockItemInfo = GridLayoutUtil.gridLayoutToDockItem(gridLayout);
      expect(dockItem.appName === 'gridLayoutAppName').assertTrue();
      expect(dockItem.bundleName === 'gridLayoutBundleName').assertTrue();
      expect(dockItem.keyName === 'gridLayoutKeyName').assertTrue();
      expect(dockItem.typeId === CommonConstants.TYPE_APP).assertTrue();

      expect(dockItem.editable === false).assertTrue();
      expect(dockItem.visible === true).assertTrue();
      expect(dockItem.abilityName === 'gridLayoutAbilityName').assertTrue();
      expect(dockItem.moduleName === 'gridLayoutModuleName').assertTrue();
      expect(dockItem.iconId === '1').assertTrue();
      expect(dockItem.appLabelId === 2).assertTrue();
      expect(dockItem.applicationLabelId === 2).assertTrue();
      expect(dockItem.applicationName === 'gridLayoutAppName').assertTrue();
      expect(dockItem.badgeNumber === 3).assertTrue();
      expect(dockItem.appIconId === 1).assertTrue();
      expect(dockItem.row === 4).assertTrue();
      expect(dockItem.column === 5).assertTrue();
      expect(dockItem.area?.[0] === 6).assertTrue();
      expect(dockItem.area?.[1] === 7).assertTrue();
      expect(dockItem.areaType === 8).assertTrue();
    })

    it('test_gridLayoutToDockItem_2', 0, (): void => {
      let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      expect(gridLayout).not().assertUndefined();

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
      gridLayout.area = [6, 7];
      gridLayout.areaType = 8;

      let dockItem: DockItemInfo = GridLayoutUtil.gridLayoutToDockItem(gridLayout);
      expect(dockItem.typeId === CommonConstants.TYPE_APP).assertTrue();
      gridLayout.typeId = 3;
      dockItem = GridLayoutUtil.gridLayoutToDockItem(gridLayout);
      expect(dockItem.typeId === CommonConstants.TYPE_FOLDER).assertTrue();
      expect(dockItem.appName === 'gridLayoutFolderName').assertTrue();
      expect(dockItem.bundleName === 'gridLayoutInfoId').assertTrue();
      expect(dockItem.keyName === 'gridLayoutInfoId').assertTrue();

      expect(dockItem.editable === false).assertTrue();
      expect(dockItem.visible === true).assertTrue();
      expect(dockItem.abilityName === 'gridLayoutAbilityName').assertTrue();
      expect(dockItem.moduleName === 'gridLayoutModuleName').assertTrue();
      expect(dockItem.iconId === '1').assertTrue();
      expect(dockItem.appLabelId === 2).assertTrue();
      expect(dockItem.applicationLabelId === 2).assertTrue();
      expect(dockItem.applicationName === 'gridLayoutAppName').assertTrue();
      expect(dockItem.badgeNumber === 3).assertTrue();
      expect(dockItem.appIconId === 1).assertTrue();
      expect(dockItem.row === 4).assertTrue();
      expect(dockItem.column === 5).assertTrue();
      expect(dockItem.area?.[0] === 6).assertTrue();
      expect(dockItem.area?.[1] === 7).assertTrue();
      expect(dockItem.areaType === 8).assertTrue();
    })

    it('test_gridLayoutToDockItem_3', 0, (): void => {
      let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      expect(gridLayout).not().assertUndefined();

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
      gridLayout.area = [6, 7];
      gridLayout.areaType = 8;

      let dockItem: DockItemInfo = GridLayoutUtil.gridLayoutToDockItem(gridLayout);
      expect(dockItem.badgeNumber === 3).assertTrue();
      gridLayout.badgeNumber = 1000;
      dockItem = GridLayoutUtil.gridLayoutToDockItem(gridLayout);
      expect(dockItem.badgeNumber === 1000).assertTrue();

      expect(dockItem.appName === 'gridLayoutAppName').assertTrue();
      expect(dockItem.bundleName === 'gridLayoutBundleName').assertTrue();
      expect(dockItem.keyName === 'gridLayoutKeyName').assertTrue();
      expect(dockItem.typeId === CommonConstants.TYPE_APP).assertTrue();

      expect(dockItem.editable === false).assertTrue();
      expect(dockItem.visible === true).assertTrue();
      expect(dockItem.abilityName === 'gridLayoutAbilityName').assertTrue();
      expect(dockItem.moduleName === 'gridLayoutModuleName').assertTrue();
      expect(dockItem.iconId === '1').assertTrue();
      expect(dockItem.appLabelId === 2).assertTrue();
      expect(dockItem.applicationLabelId === 2).assertTrue();
      expect(dockItem.applicationName === 'gridLayoutAppName').assertTrue();
      expect(dockItem.appIconId === 1).assertTrue();
      expect(dockItem.row === 4).assertTrue();
      expect(dockItem.column === 5).assertTrue();
      expect(dockItem.area?.[0] === 6).assertTrue();
      expect(dockItem.area?.[1] === 7).assertTrue();
      expect(dockItem.areaType === 8).assertTrue();
    })

    it('test_gridLayoutToDockItem_4', 0, (): void => {
      let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      expect(gridLayout).not().assertUndefined();

      gridLayout.typeId = 0;
      gridLayout.infoId = 'gridLayoutInfoId';
      gridLayout.appName = 'gridLayoutAppName';
      gridLayout.bundleName = 'gridLayoutBundleName';
      gridLayout.keyName = 'gridLayoutKeyName';
      gridLayout.folderName = 'gridLayoutFolderName'
      gridLayout.abilityName = 'gridLayoutAbilityName';
      gridLayout.moduleName = 'gridLayoutModuleName';
      gridLayout.appIconId = 1
      gridLayout.appLabelId = 2;
      gridLayout.badgeNumber = 3;
      gridLayout.row = 4;
      gridLayout.column = 5;
      gridLayout.area = [6, 7];
      gridLayout.areaType = 8;

      let dockItem: DockItemInfo = GridLayoutUtil.gridLayoutToDockItem(gridLayout);
      expect(dockItem.appName === 'gridLayoutAppName').assertTrue();
      gridLayout.appName = 'gridLayoutAppName2';
      dockItem = GridLayoutUtil.gridLayoutToDockItem(gridLayout);
      expect(dockItem.appName === 'gridLayoutAppName2').assertTrue();
      expect(dockItem.applicationName === 'gridLayoutAppName2').assertTrue();
      expect(dockItem.bundleName === 'gridLayoutBundleName').assertTrue();
      expect(dockItem.keyName === 'gridLayoutKeyName').assertTrue();
      expect(dockItem.typeId === CommonConstants.TYPE_APP).assertTrue();

      expect(dockItem.editable === false).assertTrue();
      expect(dockItem.visible === true).assertTrue();
      expect(dockItem.abilityName === 'gridLayoutAbilityName').assertTrue();
      expect(dockItem.moduleName === 'gridLayoutModuleName').assertTrue();
      expect(dockItem.iconId === '1').assertTrue();
      expect(dockItem.appLabelId === 2).assertTrue();
      expect(dockItem.applicationLabelId === 2).assertTrue();
      expect(dockItem.badgeNumber === 3).assertTrue();
      expect(dockItem.appIconId === 1).assertTrue();
      expect(dockItem.row === 4).assertTrue();
      expect(dockItem.column === 5).assertTrue();
      expect(dockItem.area?.[0] === 6).assertTrue();
      expect(dockItem.area?.[1] === 7).assertTrue();
      expect(dockItem.areaType === 8).assertTrue();
    })


    it('test_gridLayoutToDockItem_5', 0, (): void => {
      let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      expect(gridLayout).not().assertUndefined();

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
      gridLayout.area = [6, 7];
      gridLayout.areaType = 8;

      let dockItem: DockItemInfo = GridLayoutUtil.gridLayoutToDockItem(gridLayout);
      expect(dockItem.abilityName === 'gridLayoutAbilityName').assertTrue();
      gridLayout.abilityName = 'gridLayoutAbilityName2';
      dockItem = GridLayoutUtil.gridLayoutToDockItem(gridLayout);
      expect(dockItem.abilityName === 'gridLayoutAbilityName2').assertTrue();

      expect(dockItem.appName === 'gridLayoutAppName').assertTrue();
      expect(dockItem.bundleName === 'gridLayoutBundleName').assertTrue();
      expect(dockItem.keyName === 'gridLayoutKeyName').assertTrue();
      expect(dockItem.typeId === CommonConstants.TYPE_APP).assertTrue();

      expect(dockItem.editable === false).assertTrue();
      expect(dockItem.visible === true).assertTrue();
      expect(dockItem.moduleName === 'gridLayoutModuleName').assertTrue();
      expect(dockItem.iconId === '1').assertTrue();
      expect(dockItem.appLabelId === 2).assertTrue();
      expect(dockItem.applicationLabelId === 2).assertTrue();
      expect(dockItem.applicationName === 'gridLayoutAppName').assertTrue();
      expect(dockItem.appIconId === 1).assertTrue();
      expect(dockItem.row === 4).assertTrue();
      expect(dockItem.column === 5).assertTrue();
      expect(dockItem.area?.[0] === 6).assertTrue();
      expect(dockItem.area?.[1] === 7).assertTrue();
      expect(dockItem.areaType === 8).assertTrue();
    })

    it('test_gridLayoutToDockItem_6', 0, (): void => {
      let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      expect(gridLayout).not().assertUndefined();

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
      gridLayout.area = [6, 7];
      gridLayout.areaType = 8;

      let dockItem: DockItemInfo = GridLayoutUtil.gridLayoutToDockItem(gridLayout);
      expect(dockItem.row === 4).assertTrue();
      gridLayout.row = 1000;
      dockItem = GridLayoutUtil.gridLayoutToDockItem(gridLayout);
      expect(dockItem.row === 1000).assertTrue();

      expect(dockItem.appName === 'gridLayoutAppName').assertTrue();
      expect(dockItem.bundleName === 'gridLayoutBundleName').assertTrue();
      expect(dockItem.keyName === 'gridLayoutKeyName').assertTrue();
      expect(dockItem.typeId === CommonConstants.TYPE_APP).assertTrue();

      expect(dockItem.editable === false).assertTrue();
      expect(dockItem.visible === true).assertTrue();
      expect(dockItem.moduleName === 'gridLayoutModuleName').assertTrue();
      expect(dockItem.iconId === '1').assertTrue();
      expect(dockItem.appLabelId === 2).assertTrue();
      expect(dockItem.applicationLabelId === 2).assertTrue();
      expect(dockItem.applicationName === 'gridLayoutAppName').assertTrue();
      expect(dockItem.appIconId === 1).assertTrue();
      expect(dockItem.column === 5).assertTrue();
      expect(dockItem.area?.[0] === 6).assertTrue();
      expect(dockItem.area?.[1] === 7).assertTrue();
      expect(dockItem.areaType === 8).assertTrue();
    })

    it('test_gridLayoutToDockItem_7', 0, (): void => {
      let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      expect(gridLayout).not().assertUndefined();

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
      gridLayout.area = [6, 7];
      gridLayout.areaType = 8;

      let dockItem: DockItemInfo = GridLayoutUtil.gridLayoutToDockItem(gridLayout);
      expect(dockItem.column === 5).assertTrue();
      gridLayout.column = 1000;
      dockItem = GridLayoutUtil.gridLayoutToDockItem(gridLayout);
      expect(dockItem.column === 1000).assertTrue();

      expect(dockItem.appName === 'gridLayoutAppName').assertTrue();
      expect(dockItem.bundleName === 'gridLayoutBundleName').assertTrue();
      expect(dockItem.keyName === 'gridLayoutKeyName').assertTrue();
      expect(dockItem.typeId === CommonConstants.TYPE_APP).assertTrue();

      expect(dockItem.editable === false).assertTrue();
      expect(dockItem.visible === true).assertTrue();
      expect(dockItem.moduleName === 'gridLayoutModuleName').assertTrue();
      expect(dockItem.iconId === '1').assertTrue();
      expect(dockItem.appLabelId === 2).assertTrue();
      expect(dockItem.applicationLabelId === 2).assertTrue();
      expect(dockItem.applicationName === 'gridLayoutAppName').assertTrue();
      expect(dockItem.appIconId === 1).assertTrue();
      expect(dockItem.row === 4).assertTrue();
      expect(dockItem.area?.[0] === 6).assertTrue();
      expect(dockItem.area?.[1] === 7).assertTrue();
      expect(dockItem.areaType === 8).assertTrue();
    })

    it('test_gridLayoutToDockItem_8', 0, (): void => {
      let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      expect(gridLayout).not().assertUndefined();

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
      gridLayout.area = [6, 7];
      gridLayout.areaType = 8;

      let dockItem: DockItemInfo = GridLayoutUtil.gridLayoutToDockItem(gridLayout);
      expect(dockItem.areaType === 8).assertTrue();
      gridLayout.areaType = 1000;
      dockItem = GridLayoutUtil.gridLayoutToDockItem(gridLayout);
      expect(dockItem.areaType === 1000).assertTrue();

      expect(dockItem.appName === 'gridLayoutAppName').assertTrue();
      expect(dockItem.bundleName === 'gridLayoutBundleName').assertTrue();
      expect(dockItem.keyName === 'gridLayoutKeyName').assertTrue();
      expect(dockItem.typeId === CommonConstants.TYPE_APP).assertTrue();

      expect(dockItem.editable === false).assertTrue();
      expect(dockItem.visible === true).assertTrue();
      expect(dockItem.moduleName === 'gridLayoutModuleName').assertTrue();
      expect(dockItem.iconId === '1').assertTrue();
      expect(dockItem.appLabelId === 2).assertTrue();
      expect(dockItem.applicationLabelId === 2).assertTrue();
      expect(dockItem.applicationName === 'gridLayoutAppName').assertTrue();
      expect(dockItem.appIconId === 1).assertTrue();
      expect(dockItem.row === 4).assertTrue();
      expect(dockItem.column === 5).assertTrue();
      expect(dockItem.area?.[0] === 6).assertTrue();
      expect(dockItem.area?.[1] === 7).assertTrue();
    })

    it('test_gridLayoutToDockItem_9', 0, (): void => {
      let gridLayout: GridLayoutItemInfo = new GridLayoutItemInfo();
      expect(gridLayout).not().assertUndefined();

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
      gridLayout.area = [6, 7];
      gridLayout.areaType = 8;

      let dockItem: DockItemInfo = GridLayoutUtil.gridLayoutToDockItem(gridLayout);
      expect(dockItem.moduleName === 'gridLayoutModuleName').assertTrue();
      gridLayout.moduleName = 'gridLayoutModuleName2';
      dockItem = GridLayoutUtil.gridLayoutToDockItem(gridLayout);
      expect(dockItem.moduleName === 'gridLayoutModuleName2').assertTrue();

      expect(dockItem.appName === 'gridLayoutAppName').assertTrue();
      expect(dockItem.bundleName === 'gridLayoutBundleName').assertTrue();
      expect(dockItem.keyName === 'gridLayoutKeyName').assertTrue();
      expect(dockItem.typeId === CommonConstants.TYPE_APP).assertTrue();

      expect(dockItem.editable === false).assertTrue();
      expect(dockItem.visible === true).assertTrue();
      expect(dockItem.iconId === '1').assertTrue();
      expect(dockItem.appLabelId === 2).assertTrue();
      expect(dockItem.applicationLabelId === 2).assertTrue();
      expect(dockItem.applicationName === 'gridLayoutAppName').assertTrue();
      expect(dockItem.appIconId === 1).assertTrue();
      expect(dockItem.row === 4).assertTrue();
      expect(dockItem.column === 5).assertTrue();
      expect(dockItem.area?.[0] === 6).assertTrue();
      expect(dockItem.area?.[1] === 7).assertTrue();
    })

    it('test_updateGridLayoutInfo', 0, (): void => {
      let layoutInfoList: GridLayoutItemInfo[] = [];
      let demoApp: GridLayoutItemInfo = new GridLayoutItemInfo();
      demoApp.infoId = '';
      demoApp.bundleName = 'com.ohos.contacts';
      demoApp.typeId = CommonConstants.TYPE_APP;
      demoApp.page = 0;
      demoApp.row = 0;
      demoApp.column = 0;
      demoApp.keyName = 'key';
      layoutInfoList.push(demoApp);

      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      defaultLayout.layoutInfo = layoutInfoList;
      defaultLayout.layoutDescription = new LayoutDescription();
      expect(true).assertTrue();
    })

    it('test_checkGridItemEqual', 0, (): void => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_APP;
      item.keyName = 'app';
      item.cardId = '3';
      item.folderId = '456';
      item.ino = '';
      item.formStackId = '4321';
      let itemOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemOther.typeId = CommonConstants.TYPE_APP;
      itemOther.keyName = 'app';
      itemOther.cardId = '3';
      itemOther.folderId = '456';
      itemOther.ino = '';
      itemOther.formStackId = '4321';
      expect(GridLayoutUtil.checkGridItemEqual(item,itemOther)).assertTrue();
    })

    it('test_getFloorVp', 0, (): void => {
      let vp: number = 5;
      let px: number = vp2px(vp);
      let floor: number = Math.floor(px);
      let ceil: number = Math.ceil(px);
      let round: number = Math.round(px);
      expect(px2vp(floor)).assertEqual(GridLayoutUtil.getFloorVp(vp));
      expect(px2vp(ceil)).assertEqual(GridLayoutUtil.getCeilVp(vp));
      expect(px2vp(round)).assertEqual(GridLayoutUtil.getRoundVp(vp));
    })

    it('test_updatePositionSuccess_1', 0, (): void => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let currentPageBitset:BitSet = new BitSet(3);
      expect(GridLayoutUtil['updatePositionSuccess'](gridLayoutItemInfo, currentPageBitset, 1, 1, 1))
        .not().assertEqual(0);
      expect(GridLayoutUtil['updatePositionSuccess'](gridLayoutItemInfo, currentPageBitset, 1, 10, 1))
        .not().assertEqual(2);
      currentPageBitset = new BitSet(0);
      expect(GridLayoutUtil['updatePositionSuccess'](gridLayoutItemInfo, currentPageBitset, 0, 0, 0))
        .not().assertEqual(4);
    })

    it('test_isSmallFolder_1', 0, (): void => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.area = undefined;
      expect(GridLayoutUtil.isSmallFolder(gridLayoutItemInfo)).assertFalse();
      gridLayoutItemInfo.area = [1, 1];
      gridLayoutItemInfo.typeId = 3;
      expect(GridLayoutUtil.isSmallFolder(gridLayoutItemInfo)).assertTrue();
    })

    it('test_isBigFolder_1', 0, (): void => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.area = undefined;
      expect(GridLayoutUtil.isBigFolder(gridLayoutItemInfo)).assertFalse();
      gridLayoutItemInfo.area = [1, 1];
      gridLayoutItemInfo.typeId = 3;
      expect(GridLayoutUtil.isBigFolder(gridLayoutItemInfo)).assertFalse();
      gridLayoutItemInfo.area = [1, 2];
      expect(GridLayoutUtil.isBigFolder(gridLayoutItemInfo)).assertTrue();
    })

    it('test_isAddIcon_1', 0, (): void => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      expect(GridLayoutUtil.isAddIcon(gridLayoutItemInfo)).assertFalse();
      gridLayoutItemInfo.typeId = 4;
      expect(GridLayoutUtil.isAddIcon(gridLayoutItemInfo)).assertTrue();
    })

    it('test_getCountPerPageFolderOpen_1', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let mockFunc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      try {
        expect(GridLayoutUtil.getCountPerPageFolderOpen()).assertEqual(16);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
        expect(GridLayoutUtil.getCountPerPageFolderOpen()).assertEqual(12);
        AppStorage.set('folderStatus', 1);
        expect(GridLayoutUtil.getCountPerPageFolderOpen()).assertEqual(16);
        AppStorage.set('folderStatus', undefined);
        expect(GridLayoutUtil.getCountPerPageFolderOpen()).assertEqual(12);
      } catch (e) {}
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_isIconType_1', 0, (): void => {
      expect(GridLayoutUtil.isIconType(0)).assertTrue();
      expect(GridLayoutUtil.isIconType(7)).assertTrue();
      expect(GridLayoutUtil.isIconType(100)).assertFalse();
    })

    it('test_isFolderType_1', 0, () => {
      expect(GridLayoutUtil.isFolderType(3)).assertTrue();
      expect(GridLayoutUtil.isFolderType(0)).assertFalse();
      expect(GridLayoutUtil.isFolderType(100)).assertFalse();
    });

    it('test_isRegionFolderType_1', 0, () => {
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.typeId = 9;
      expect(GridLayoutUtil.isRegionFolderType(gridLayoutItemInfo)).assertTrue();
      gridLayoutItemInfo.typeId = 0;
      expect(GridLayoutUtil.isRegionFolderType(gridLayoutItemInfo)).assertFalse();
      gridLayoutItemInfo.typeId = 100;
      expect(GridLayoutUtil.isRegionFolderType(gridLayoutItemInfo)).assertFalse();
    });

    it('test_isFSFileFolderType_1', 0, () => {
      let gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.typeId = 5;
      expect(GridLayoutUtil.isFSFileFolderType(gridLayoutItemInfo)).assertTrue();
      gridLayoutItemInfo.fileType = 1;
      expect(GridLayoutUtil.isFSFileType(gridLayoutItemInfo)).assertTrue();
      gridLayoutItemInfo.typeId = 0;
      expect(GridLayoutUtil.isFSFolderType(gridLayoutItemInfo)).assertTrue();
    });

    it('test_mapProxyTypeGridLayout_1', 0, (): void => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isProxyTypeGridLayout);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(GridLayoutUtil.mapProxyTypeGridLayout(gridLayoutItemInfo)).not().assertNull();
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })

    it('test_isImageSyncLoad_1', 0, (): void => {
      GridLayoutUtil.isImageSyncLoad('http:');
      expect(GridLayoutUtil.isImageSyncLoad('')).assertTrue();
    })

    it('test_ifDuplicatePosition_1', 0, (): void => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.page = 1;
      gridLayoutItemInfo.row = 1;
      gridLayoutItemInfo.column = 1;
      gridLayoutItemInfo.area = [1, 6];
      try {
        expect(GridLayoutUtil.ifDuplicatePosition([gridLayoutItemInfo])).assertInstanceOf('Boolean');
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      gridLayoutItemInfo.area = [1, 1];
      try {
        expect(GridLayoutUtil.ifDuplicatePosition([gridLayoutItemInfo])).assertInstanceOf('Boolean');
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      gridLayoutItemInfo.area = [];
      try {
        expect(GridLayoutUtil.ifDuplicatePosition([gridLayoutItemInfo])).assertInstanceOf('Boolean');
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('test_printDuplicateInfo_1', 0, (): void => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.page = 1;
      gridLayoutItemInfo.row = 1;
      gridLayoutItemInfo.area = [1, 1]
      gridLayoutItemInfo.column = 1;
      GridLayoutUtil['printDuplicateInfo']([gridLayoutItemInfo], 1, 1, 1);
      GridLayoutUtil['printDuplicateInfo']([gridLayoutItemInfo], 1, 1, 1000);
      expect(gridLayoutItemInfo).not().assertNull();
    })

    it('test_generateUniqueKey_1', 0, (): void => {
      try {
        const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
        gridLayoutItemInfo.keyName = '1';
        gridLayoutItemInfo.cardId = '1';
        gridLayoutItemInfo.folderId = '1';
        gridLayoutItemInfo.ino = '1';
        gridLayoutItemInfo.formStackId = '1';
        expect(GridLayoutUtil.generateUniqueKey()).assertEqual('');
        gridLayoutItemInfo.typeId = 0;
        expect(GridLayoutUtil.generateUniqueKey(gridLayoutItemInfo)?.trim()).assertEqual('00');
        gridLayoutItemInfo.appIndex = 1;
        gridLayoutItemInfo.bundleName = '1';
        expect(GridLayoutUtil.generateUniqueKey(gridLayoutItemInfo)).assertEqual('011');
        gridLayoutItemInfo.typeId = 1;
        expect(GridLayoutUtil.generateUniqueKey(gridLayoutItemInfo)).assertEqual('11');
        gridLayoutItemInfo.typeId = 3;
        expect(GridLayoutUtil.generateUniqueKey(gridLayoutItemInfo)).assertEqual('31');
        gridLayoutItemInfo.typeId = 5;
        expect(GridLayoutUtil.generateUniqueKey(gridLayoutItemInfo)).assertEqual('51');
        gridLayoutItemInfo.typeId = 6;
        expect(GridLayoutUtil.generateUniqueKey(gridLayoutItemInfo)).assertEqual('61');
        gridLayoutItemInfo.typeId = 7;
        expect(GridLayoutUtil.generateUniqueKey(gridLayoutItemInfo)).assertEqual('71');
        gridLayoutItemInfo.typeId = 9;
        expect(GridLayoutUtil.generateUniqueKey(gridLayoutItemInfo)).assertEqual('91');
        gridLayoutItemInfo.typeId = 17;
        expect(GridLayoutUtil.generateUniqueKey(gridLayoutItemInfo)).assertInstanceOf('String');
      } catch (e) {}
    })

    it('test_isFileFolderItemModified_1', 0, () => {
      let fileInfo: DesktopFileInfo = new DesktopFileInfo();
      let fileItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      fileInfo.thumbnail = 1;
      fileInfo.fileName = 'fileName';
      fileInfo.uri = 'testUri';
      fileInfo.size = 1;
      fileInfo.ctime = 1;
      fileInfo.mtime = 1;
      fileItem.appIconId = 1;
      fileItem.fileFolderName = 'fileName';
      fileItem.uri = 'testUri';
      fileItem.size = 1;
      fileItem.ctime = 1;
      fileItem.mtime = 1;

      expect(GridLayoutUtil.isFileFolderItemModified(fileInfo, fileItem)).assertFalse();
      fileInfo.thumbnail = 2;
      expect(GridLayoutUtil.isFileFolderItemModified(fileInfo, fileItem)).assertTrue();
    })

    it('test_isFileFolderItemModified_2', 0, () => {
      let fileInfo: DesktopFileInfo = new DesktopFileInfo();
      let fileItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      fileInfo.thumbnail = 1;
      fileInfo.fileName = 'fileName';
      fileInfo.uri = 'testUri';
      fileInfo.size = 1;
      fileInfo.ctime = 1;
      fileInfo.mtime = 1;
      fileItem.appIconId = 1;
      fileItem.fileFolderName = 'fileName';
      fileItem.uri = 'testUri';
      fileItem.size = 1;
      fileItem.ctime = 1;
      fileItem.mtime = 1;

      expect(GridLayoutUtil.isFileFolderItemModified(fileInfo, fileItem)).assertFalse();
      fileInfo.fileName = 'testName1';
      expect(GridLayoutUtil.isFileFolderItemModified(fileInfo, fileItem)).assertTrue();
    })

    it('test_isFileFolderItemModified_3', 0, () => {
      let fileInfo: DesktopFileInfo = new DesktopFileInfo();
      let fileItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      fileInfo.thumbnail = 1;
      fileInfo.fileName = 'fileName';
      fileInfo.uri = 'testUri';
      fileInfo.size = 1;
      fileInfo.ctime = 1;
      fileInfo.mtime = 1;
      fileItem.appIconId = 1;
      fileItem.fileFolderName = 'fileName';
      fileItem.uri = 'testUri';
      fileItem.size = 1;
      fileItem.ctime = 1;
      fileItem.mtime = 1;

      expect(GridLayoutUtil.isFileFolderItemModified(fileInfo, fileItem)).assertFalse();
      fileInfo.uri = 'testUri1';
      expect(GridLayoutUtil.isFileFolderItemModified(fileInfo, fileItem)).assertTrue();
    })

    it('test_isFileFolderItemModified_4', 0, () => {
      let fileInfo: DesktopFileInfo = new DesktopFileInfo();
      let fileItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      fileInfo.thumbnail = 1;
      fileInfo.fileName = 'fileName';
      fileInfo.uri = 'testUri';
      fileInfo.size = 1;
      fileInfo.ctime = 1;
      fileInfo.mtime = 1;
      fileItem.appIconId = 1;
      fileItem.fileFolderName = 'fileName';
      fileItem.uri = 'testUri';
      fileItem.size = 1;
      fileItem.ctime = 1;
      fileItem.mtime = 1;

      expect(GridLayoutUtil.isFileFolderItemModified(fileInfo, fileItem)).assertFalse();
      fileInfo.size = 2;
      expect(GridLayoutUtil.isFileFolderItemModified(fileInfo, fileItem)).assertTrue();
    })

    it('test_isFileFolderItemModified_5', 0, () => {
      let fileInfo: DesktopFileInfo = new DesktopFileInfo();
      let fileItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      fileInfo.thumbnail = 1;
      fileInfo.fileName = 'fileName';
      fileInfo.uri = 'testUri';
      fileInfo.size = 1;
      fileInfo.ctime = 1;
      fileInfo.mtime = 1;
      fileItem.appIconId = 1;
      fileItem.fileFolderName = 'fileName';
      fileItem.uri = 'testUri';
      fileItem.size = 1;
      fileItem.ctime = 1;
      fileItem.mtime = 1;

      expect(GridLayoutUtil.isFileFolderItemModified(fileInfo, fileItem)).assertFalse();
      fileInfo.ctime = 12;
      expect(GridLayoutUtil.isFileFolderItemModified(fileInfo, fileItem)).assertTrue();
    })

    it('test_isFileFolderItemModified_6', 0, () => {
      let fileInfo: DesktopFileInfo = new DesktopFileInfo();
      let fileItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      fileInfo.thumbnail = 1;
      fileInfo.fileName = 'fileName';
      fileInfo.uri = 'testUri';
      fileInfo.size = 1;
      fileInfo.ctime = 1;
      fileInfo.mtime = 1;
      fileItem.appIconId = 1;
      fileItem.fileFolderName = 'fileName';
      fileItem.uri = 'testUri';
      fileItem.size = 1;
      fileItem.ctime = 1;
      fileItem.mtime = 1;

      expect(GridLayoutUtil.isFileFolderItemModified(fileInfo, fileItem)).assertFalse();
      fileInfo.mtime = 12;
      expect(GridLayoutUtil.isFileFolderItemModified(fileInfo, fileItem)).assertTrue();
    })

    it('test_checkPositionAndAreaEqual_1', 0, (): void => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.page = 1;
      gridLayoutItemInfo.row = 1;
      gridLayoutItemInfo.area = [1, 1];
      gridLayoutItemInfo.column = 1;
      gridLayoutItemInfoOther.page = 1;
      gridLayoutItemInfoOther.row = 1;
      gridLayoutItemInfoOther.area = [1, 1];
      gridLayoutItemInfoOther.column = 1;
      expect(GridLayoutUtil.checkPositionAndAreaEqual(gridLayoutItemInfo, gridLayoutItemInfoOther))
        .assertTrue();
      gridLayoutItemInfoOther.area = [1, 2];
      expect(GridLayoutUtil.checkPositionAndAreaEqual(gridLayoutItemInfo, gridLayoutItemInfoOther))
        .assertFalse();
    })

    it('test_isFolderItemValid_1', 0, (): void => {
      expect(GridLayoutUtil.isFolderItemValid(undefined)).assertFalse();
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.layoutInfo = [[gridLayoutItemInfoOther]];
      expect(GridLayoutUtil.isFolderItemValid(gridLayoutItemInfo)).assertTrue();
      gridLayoutItemInfo.layoutInfo = [[]];
      expect(GridLayoutUtil.isFolderItemValid(gridLayoutItemInfo)).assertTrue();
    })

    it('test_getColSpan_1', 0, (): void => {
      expect(GridLayoutUtil.getColSpan(undefined)).assertEqual(1);
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.area = [1];
      expect(GridLayoutUtil.getColSpan(gridLayoutItemInfo)).assertEqual(1);
    })

    it('test_getGridItemPosition_1', 0, (): void => {
      GridLayoutUtil['isEditMode'] = true;
      expect(GridLayoutUtil.getGridItemPosition(1, 1, 1)).not().assertNull();
      GridLayoutUtil['isEditMode'] = false;
      expect(GridLayoutUtil.getGridItemPosition(1, 1, 1)).not().assertNull();
    })

    it('test_getGridItemPositionWithoutRTL_1', 0, (): void => {
      GridLayoutUtil['isEditMode'] = true;
      expect(GridLayoutUtil.getGridItemPositionWithoutRTL(1, 1, 1)).not().assertNull();
      GridLayoutUtil['isEditMode'] = false;
      expect(GridLayoutUtil.getGridItemPositionWithoutRTL(1, 1, 1)).not().assertNull();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(GridLayoutUtil.getGridItemPositionWithoutRTL(1, 1, 1)).not().assertNull();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(GridLayoutUtil.getGridItemPositionWithoutRTL(1, 1, 1)).not().assertNull();
      expect(GridLayoutUtil.getGridItemPositionWithoutRTL(1, 1, 0)).not().assertNull();
      mocker.clear(RTLUtil);
      mocker.clearAll();
    })

    it('test_getRealGridItemPosition_1', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil['getExpandPaddingLeft']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      let mockFunc1: Function = mocker.mockFunc(RTLUtil, RTLUtil.getColumnByRTL);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(1);
      let mockFunc2: Function =
        mocker.mockFunc(GridLayoutUtil['positionUtil'], GridLayoutUtil['positionUtil'].getPosition);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn({
        x: 0,
        y: 0
      });
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      expect(GridLayoutUtil.getRealGridItemPosition(gridLayoutItemInfo)).not().assertNull();
      gridLayoutItemInfo.column = 1;
      gridLayoutItemInfo.row = 1;
      gridLayoutItemInfo.page = 1;
      gridLayoutItemInfo.area = [1];
      expect(GridLayoutUtil.getRealGridItemPosition(gridLayoutItemInfo)).not().assertNull();
      mocker.clear(GridLayoutUtil);
      mocker.clear(RTLUtil);
      mocker.clearAll();
    })

    it('test_getIconCenterPosition_1', 0, (): void => {
      GridLayoutUtil['isEditMode'] = true;
      let editModePositionUtil = GridLayoutUtil['editModePositionUtil'];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      let mockFunc1: Function = mocker.mockFunc(editModePositionUtil, editModePositionUtil.getCenterPosition);
      let mockFunc2: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil['getExpandPaddingLeft']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(1);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn({
        x: 1,
        y: 1
      });
      expect(GridLayoutUtil.getIconCenterPosition(1, 1, [1])).not().assertNull();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(GridLayoutUtil.getIconCenterPosition(1, 1, [1], 1)).not().assertNull();
      expect(GridLayoutUtil.getIconCenterPosition(1, 1, [1], 0)).not().assertNull();
      mocker.clear(RTLUtil);
      mocker.clear(editModePositionUtil);
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })

    it('test_getIconCenterPosition_2', 0, (): void => {
      GridLayoutUtil['isEditMode'] = false;
      let positionUtil = GridLayoutUtil['positionUtil'];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      let mockFunc1: Function = mocker.mockFunc(positionUtil, positionUtil.getCenterPosition);
      let mockFunc2: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil['getExpandPaddingLeft']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(1);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn({
        x: 1,
        y: 1
      });
      expect(GridLayoutUtil.getIconCenterPosition(1, 1, [1])).not().assertNull();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(GridLayoutUtil.getIconCenterPosition(1, 1, [1], 1)).not().assertNull();
      expect(GridLayoutUtil.getIconCenterPosition(1, 1, [1], 0)).not().assertNull();
      mocker.clear(RTLUtil);
      mocker.clear(positionUtil);
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })

    it('test_getIconCenterPositionWithoutRTL_1', 0, (): void => {
      GridLayoutUtil['isEditMode'] = true;
      let editModePositionUtil  = GridLayoutUtil['editModePositionUtil'];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(editModePositionUtil , editModePositionUtil.getCenterPosition);
      let mockFunc1: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil['getExpandPaddingLeft']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(1);
      when(mockFunc)(ArgumentMatchers.any).afterReturn({
        x:1,
        y:1
      });
      expect(GridLayoutUtil.getIconCenterPositionWithoutRTL(1, 1, [1], 1)).not().assertNull();
      mocker.clear(editModePositionUtil);
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })

    it('test_getIconCenterPositionWithoutRTL_2', 0, (): void => {
      GridLayoutUtil['isEditMode'] = false;
      let positionUtil = GridLayoutUtil['positionUtil'];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(positionUtil, positionUtil.getCenterPosition);
      let mockFunc1: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil['getExpandPaddingLeft']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(1);
      when(mockFunc)(ArgumentMatchers.any).afterReturn({
        x:1,
        y:1
      });
      expect(GridLayoutUtil.getIconCenterPositionWithoutRTL(1, 1, [1], 1)).not().assertNull();
      mocker.clear(positionUtil);
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })

    it('test_updatePositionByRTL_1', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      GridLayoutUtil['updatePositionByRTL']({x:1,y:1});
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      GridLayoutUtil['updatePositionByRTL']({x:1,y:1});
      expect(mocker).not().assertNull();
      mocker.clear(RTLUtil);
      mocker.clearAll();
    })

    it('test_getRowAndColumn_1', 0, (): void => {
      const dragGridPosition:DragGridPosition = {
        row:1,
        column:1
      }
      GridLayoutUtil['isEditMode'] = false;
      let positionUtil = GridLayoutUtil['positionUtil'];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(positionUtil, positionUtil.getRowAndColumn);
      let mockFunc1: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil['getExpandPaddingLeft']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(1);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(dragGridPosition);
      expect(GridLayoutUtil.getRowAndColumn(1, 1, 1)).not().assertNull();
      mocker.clear(positionUtil);
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })

    it('test_getRowAndColumn_2', 0, (): void => {
      const dragGridPosition:DragGridPosition = {
        row:1,
        column:1
      }
      GridLayoutUtil['isEditMode'] = true;
      let editModePositionUtil  = GridLayoutUtil['editModePositionUtil'];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(editModePositionUtil , editModePositionUtil.getRowAndColumn);
      let mockFunc1: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil['getExpandPaddingLeft']);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(1);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(dragGridPosition);
      try {
        expect(GridLayoutUtil.getRowAndColumn(1, 1, 1)).not().assertNull();
      } catch (e) {}
      mocker.clear(editModePositionUtil);
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
    })

    it('test_getAppEnterpriseUrl_1', 0, (): void => {
      const appItemInfo: AppItemInfo = new AppItemInfo();
      expect(GridLayoutUtil.getAppEnterpriseUrl(appItemInfo)).assertEqual('');
      appItemInfo.intent = JSON.stringify({
        targetModuleUrl: '1'
      })
      expect(GridLayoutUtil.getAppEnterpriseUrl(appItemInfo)?.trim()).assertEqual('1');
      appItemInfo.intent = JSON.stringify({
        targetModuleUrl_1: '1'
      })
      expect(GridLayoutUtil.getAppEnterpriseUrl(appItemInfo)).assertEqual('1');
    })

    it('test_getSingleDragItemInfo_1', 0, (): void => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      expect(GridLayoutUtil.getSingleDragItemInfo()).not().assertNull();
      AppStorage.set('dragItemInfo', [gridLayoutItemInfo]);
      expect(GridLayoutUtil.getSingleDragItemInfo()).not().assertNull();
      AppStorage.set('dragItemInfo',undefined);
      expect(GridLayoutUtil.getSingleDragItemInfo()).not().assertNull();
    })

    it('test_isLargeFoldExpanded_1', 0, (): void => {
      AppStorage.set('DeviceState',1);
      GridLayoutUtil['isLargeFold '] = true;
      expect(GridLayoutUtil.isLargeFoldExpanded()).assertFalse();
      AppStorage.set('DeviceState',2);
      expect(GridLayoutUtil.isLargeFoldExpanded()).assertFalse();
    })

    it('test_isMajorApp_1', 0, (): void => {
      const gridLayoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.appIndex = 0;
      gridLayoutItemInfo.typeId = 0;
      expect(GridLayoutUtil.isMajorApp(gridLayoutItemInfo)).assertTrue();
      gridLayoutItemInfo.typeId = 1;
      expect(GridLayoutUtil.isMajorApp(gridLayoutItemInfo)).assertFalse();
    })

    it('checkCurrentItemAppName01', 0, () => {
      let appInfo = new GridLayoutItemInfo();
      appInfo.appName = '联系人';
      expect(GridLayoutUtil.checkCurrentItemAppName(appInfo) === undefined).assertTrue();
    })

    it('checkCurrentItemAppName02', 0, () => {
      let appInfo = new GridLayoutItemInfo();
      expect(GridLayoutUtil.checkCurrentItemAppName(appInfo) === undefined).assertTrue();
    })

    it('test_GridLayoutUtil_initGridPosition', 0, () => {
      let gridParam: DragGridParam = { paddingLeft: 1, paddingTop: 2, row: 3, column: 4, rowGap: 5,
        columnGap: 6,  gridWidth: 7, gridHeight:8 };
      let foldScreenExpandPaddingLeft: number[] = [ 1, 2, 3 ];
      let screenWidth: number = 0;
      GridLayoutUtil.initGridPosition(gridParam, foldScreenExpandPaddingLeft, screenWidth);
    })

    it('test_GridLayoutUtil_initGridPosition_01', 0, () => {
      let gridParam: DragGridParam = { paddingLeft: 0, paddingTop: 0, row: 0, column: 0, rowGap: 0,
        columnGap: 0,  gridWidth: 0, gridHeight:0 };
      let foldScreenExpandPaddingLeft: number[] = [ 1, 2, 3 ];
      let screenWidth: number = 0;
      GridLayoutUtil.initGridPosition(gridParam, foldScreenExpandPaddingLeft, screenWidth);
    })

    it('test_GridLayoutUtil_initGridPosition_02', 0, () => {
      let gridParam: DragGridParam = { paddingLeft: 1, paddingTop: 2, row: 3, column: 4, rowGap: 5,
        columnGap: 6,  gridWidth: 7, gridHeight:8 };
      let foldScreenExpandPaddingLeft: number[] = [];
      let screenWidth: number = 0;
      GridLayoutUtil.initGridPosition(gridParam, foldScreenExpandPaddingLeft, screenWidth);
    })

    it('test_GridLayoutUtil_initGridPosition_03', 0, () => {
      let gridParam: DragGridParam = { paddingLeft: 1, paddingTop: 2, row: 3, column: 4, rowGap: 5,
        columnGap: 6,  gridWidth: 7, gridHeight:8 };
      let foldScreenExpandPaddingLeft: number[] = [ 0, 0, 0 ];
      let screenWidth: number = 0;
      GridLayoutUtil.initGridPosition(gridParam, foldScreenExpandPaddingLeft, screenWidth);
    })

    it('test_GridLayoutUtil_initGridPosition_04', 0, () => {
      let gridParam: DragGridParam = { paddingLeft: 1, paddingTop: 2, row: 3, column: 4, rowGap: 5,
        columnGap: 6,  gridWidth: 7, gridHeight:8 };
      let foldScreenExpandPaddingLeft: number[] = [ -1, -1, -1 ];
      let screenWidth: number = 0;
      GridLayoutUtil.initGridPosition(gridParam, foldScreenExpandPaddingLeft, screenWidth);
    })

    it('test_GridLayoutUtil_initGridPosition_05', 0, () => {
      let gridParam: DragGridParam = { paddingLeft: 1, paddingTop: 2, row: 3, column: 4, rowGap: 5,
        columnGap: 6,  gridWidth: 7, gridHeight:8 };
      let foldScreenExpandPaddingLeft: number[] = [ 1, 1, 1 ];
      let screenWidth: number = 1;
      GridLayoutUtil.initGridPosition(gridParam, foldScreenExpandPaddingLeft, screenWidth);
    })

    it('test_GridLayoutUtil_initGridPosition_06', 0, () => {
      let gridParam: DragGridParam = { paddingLeft: 1, paddingTop: 2, row: 3, column: 4, rowGap: 5,
        columnGap: 6,  gridWidth: 7, gridHeight:8 };
      let foldScreenExpandPaddingLeft: number[] = [ 1, 1, 1 ];
      let screenWidth: number = -1;
      GridLayoutUtil.initGridPosition(gridParam, foldScreenExpandPaddingLeft, screenWidth);
    })

    it('test_GridLayoutUtil_initGridPosition_07', 0, () => {
      let gridParam: DragGridParam = { paddingLeft: 1, paddingTop: 2, row: 3, column: 4, rowGap: 5,
        columnGap: 6,  gridWidth: 7, gridHeight:8 };
      let foldScreenExpandPaddingLeft: number[] = [ 1, 1, 1 ];
      let screenWidth: number = 1;
      let centerX: number = 0;
      GridLayoutUtil.initGridPosition(gridParam, foldScreenExpandPaddingLeft, screenWidth, centerX);
    })

    it('test_GridLayoutUtil_initGridPosition_08', 0, () => {
      let gridParam: DragGridParam = {paddingLeft : 1, paddingTop: 2, row: 3, column: 4, rowGap: 5,
        columnGap: 6,  gridWidth: 7, gridHeight:8 };
      let foldScreenExpandPaddingLeft: number[] = [1, 1, 1];
      let screenWidth: number = 1;
      let centerX: number = -1;
      GridLayoutUtil.initGridPosition(gridParam, foldScreenExpandPaddingLeft, screenWidth, centerX);
    })

    it('test_GridLayoutUtil_initGridPosition_09', 0, () => {
      let gridParam: DragGridParam = {paddingLeft : 1, paddingTop: 2, row: 3, column: 4, rowGap: 5,
        columnGap: 6,  gridWidth: 7, gridHeight:8 };
      let foldScreenExpandPaddingLeft: number[] = [1, 1, 1];
      let screenWidth: number = 1;
      let centerX: number = 1;
      GridLayoutUtil.initGridPosition(gridParam, foldScreenExpandPaddingLeft, screenWidth, centerX);
    })

    it('test_GridLayoutUtil_initGridPosition_10', 0, () => {
      let gridParam: DragGridParam = {paddingLeft : 1, paddingTop: 2, row: 3, column: 4, rowGap: 5,
        columnGap: 6,  gridWidth: 7, gridHeight:8 };
      let foldScreenExpandPaddingLeft: number[] = [1, 1, 1];
      let screenWidth: number = 1;
      let centerX: number = 1;
      let centerY: number = 0;
      GridLayoutUtil.initGridPosition(gridParam, foldScreenExpandPaddingLeft, screenWidth, centerX, centerY);
    })

    it('test_GridLayoutUtil_initGridPosition_11', 0, () => {
      let gridParam: DragGridParam = {paddingLeft : 1, paddingTop: 2, row: 3, column: 4, rowGap: 5,
        columnGap: 6,  gridWidth: 7, gridHeight:8 };
      let foldScreenExpandPaddingLeft: number[] = [1, 1, 1];
      let screenWidth: number = 1;
      let centerX: number = 1;
      let centerY: number = -1;
      GridLayoutUtil.initGridPosition(gridParam, foldScreenExpandPaddingLeft, screenWidth, centerX, centerY);
    })

    it('test_GridLayoutUtil_initGridPosition_12', 0, () => {
      let gridParam: DragGridParam = {paddingLeft : 1, paddingTop: 2, row: 3, column: 4, rowGap: 5,
        columnGap: 6,  gridWidth: 7, gridHeight:8 };
      let foldScreenExpandPaddingLeft: number[] = [1, 1, 1];
      let screenWidth: number = 1;
      let centerX: number = 1;
      let centerY: number = 1;
      GridLayoutUtil.initGridPosition(gridParam, foldScreenExpandPaddingLeft, screenWidth, centerX, centerY);
    })

    it('test_GridLayoutUtil_updateEditModeGridPosition', 0, () => {
      let gridParam: DragGridParam = {paddingLeft : 1, paddingTop: 2, row: 3, column: 4, rowGap: 5,
        columnGap: 6,  gridWidth: 7, gridHeight:8 };
      let foldScreenExpandPaddingLeft: number[] = [1, 1, 1];
      GridLayoutUtil.updateEditModeGridPosition(gridParam, foldScreenExpandPaddingLeft);
    })

    it('test_GridLayoutUtil_updateEditModeGridPosition_01', 0, () => {
      let gridParam: DragGridParam = {paddingLeft : 0, paddingTop: 0, row: 0, column: 0, rowGap: 0,
        columnGap: 0,  gridWidth: 0, gridHeight: 0 };
      let foldScreenExpandPaddingLeft: number[] = [1, 1, 1];
      GridLayoutUtil.updateEditModeGridPosition(gridParam, foldScreenExpandPaddingLeft);
    })

    it('test_GridLayoutUtil_updateEditModeGridPosition_02', 0, () => {
      let gridParam: DragGridParam = {paddingLeft : -1, paddingTop: -1, row: -1, column: -1, rowGap: -1,
        columnGap: -1,  gridWidth: -1, gridHeight: -1 };
      let foldScreenExpandPaddingLeft: number[] = [1, 1, 1];
      GridLayoutUtil.updateEditModeGridPosition(gridParam, foldScreenExpandPaddingLeft);
    })

    it('test_GridLayoutUtil_updateEditModeGridPosition_03', 0, () => {
      let gridParam: DragGridParam = {paddingLeft : 1, paddingTop: 2, row: 3, column: 4, rowGap: 5,
        columnGap: 6,  gridWidth: 7, gridHeight:8 };
      let foldScreenExpandPaddingLeft: number[] = [];
      GridLayoutUtil.updateEditModeGridPosition(gridParam, foldScreenExpandPaddingLeft);
    })

    it('test_GridLayoutUtil_updateEditModeGridPosition_04', 0, () => {
      let gridParam: DragGridParam = {paddingLeft : 1, paddingTop: 2, row: 3, column: 4, rowGap: 5,
        columnGap: 6,  gridWidth: 7, gridHeight:8 };
      let foldScreenExpandPaddingLeft: number[] = [ 0 ];
      GridLayoutUtil.updateEditModeGridPosition(gridParam, foldScreenExpandPaddingLeft);
    })

    it('test_GridLayoutUtil_updateEditModeGridPosition_05', 0, () => {
      let gridParam: DragGridParam = {paddingLeft : 1, paddingTop: 2, row: 3, column: 4, rowGap: 5,
        columnGap: 6,  gridWidth: 7, gridHeight:8 };
      let foldScreenExpandPaddingLeft: number[] = [ -1 ];
      GridLayoutUtil.updateEditModeGridPosition(gridParam, foldScreenExpandPaddingLeft);
    })

    it('test_GridLayoutUtil_updateEditModeGridPosition_06', 0, () => {
      let gridParam: DragGridParam = {paddingLeft : 1, paddingTop: 2, row: 3, column: 4, rowGap: 5,
        columnGap: 6,  gridWidth: 7, gridHeight:8 };
      let foldScreenExpandPaddingLeft: number[] = [ -1 ];
      let centerX: number = 0;
      GridLayoutUtil.updateEditModeGridPosition(gridParam, foldScreenExpandPaddingLeft, centerX);
    })

    it('test_GridLayoutUtil_updateEditModeGridPosition_07', 0, () => {
      let gridParam: DragGridParam = {paddingLeft : 1, paddingTop: 2, row: 3, column: 4, rowGap: 5,
        columnGap: 6,  gridWidth: 7, gridHeight:8 };
      let foldScreenExpandPaddingLeft: number[] = [ -1 ];
      let centerX: number = -1;
      GridLayoutUtil.updateEditModeGridPosition(gridParam, foldScreenExpandPaddingLeft, centerX);
    })

    it('test_GridLayoutUtil_updateEditModeGridPosition_08', 0, () => {
      let gridParam: DragGridParam = {paddingLeft : 1, paddingTop: 2, row: 3, column: 4, rowGap: 5,
        columnGap: 6,  gridWidth: 7, gridHeight:8 };
      let foldScreenExpandPaddingLeft: number[] = [ -1 ];
      let centerX: number = 1;
      GridLayoutUtil.updateEditModeGridPosition(gridParam, foldScreenExpandPaddingLeft, centerX);
    })

    it('test_GridLayoutUtil_updateEditModeGridPosition_09', 0, () => {
      let gridParam: DragGridParam = {paddingLeft : 1, paddingTop: 2, row: 3, column: 4, rowGap: 5,
        columnGap: 6,  gridWidth: 7, gridHeight:8 };
      let foldScreenExpandPaddingLeft: number[] = [ -1 ];
      let centerX: number = 1;
      let centerY: number = 1;
      GridLayoutUtil.updateEditModeGridPosition(gridParam, foldScreenExpandPaddingLeft, centerX, centerY);
    })

    it('test_GridLayoutUtil_updateEditModeGridPosition_10', 0, () => {
      let gridParam: DragGridParam = {paddingLeft : 1, paddingTop: 2, row: 3, column: 4, rowGap: 5,
        columnGap: 6,  gridWidth: 7, gridHeight:8 };
      let foldScreenExpandPaddingLeft: number[] = [ -1 ];
      let centerX: number = 1;
      let centerY: number = 0;
      GridLayoutUtil.updateEditModeGridPosition(gridParam, foldScreenExpandPaddingLeft, centerX, centerY);
    })

    it('test_GridLayoutUtil_updateEditModeGridPosition_11', 0, () => {
      let gridParam: DragGridParam = {paddingLeft : 1, paddingTop: 2, row: 3, column: 4, rowGap: 5,
        columnGap: 6,  gridWidth: 7, gridHeight:8 };
      let foldScreenExpandPaddingLeft: number[] = [ -1 ];
      let centerX: number = 1;
      let centerY: number = -1;
      GridLayoutUtil.updateEditModeGridPosition(gridParam, foldScreenExpandPaddingLeft, centerX, centerY);
    })

    it('test_GridLayoutUtil_getColSpan', 0, () => {
      let item: GridLayoutItemInfo | undefined = undefined;
      GridLayoutUtil.getColSpan(item);
    })

    it('test_GridLayoutUtil_getColSpan_01', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.area = [1];
      GridLayoutUtil.getColSpan(item);
    })

    it('test_GridLayoutUtil_getGridItemPosition', 0, () => {
      let row: number = -1;
      let column: number = -1;
      GridLayoutUtil.getGridItemPosition(row, column);
    })

    it('test_GridLayoutUtil_getGridItemPosition_01', 0, () => {
      let row: number = 0;
      let column: number = 0;
      GridLayoutUtil.getGridItemPosition(row, column);
    })

    it('test_GridLayoutUtil_getGridItemPosition_02', 0, () => {
      let row: number = 1;
      let column: number = 1;
      GridLayoutUtil.getGridItemPosition(row, column);
    })

    it('test_GridLayoutUtil_getGridItemPosition_03', 0, () => {
      let row: number = 1;
      let column: number = 1;
      let page: number = 0;
      GridLayoutUtil.getGridItemPosition(row, column, page);
    })

    it('test_GridLayoutUtil_getGridItemPosition_04', 0, () => {
      let row: number = 1;
      let column: number = 1;
      let page: number = -1;
      GridLayoutUtil.getGridItemPosition(row, column, page);
    })

    it('test_GridLayoutUtil_getGridItemPosition_05', 0, () => {
      let row: number = 1;
      let column: number = 1;
      let page: number = 1;
      GridLayoutUtil.getGridItemPosition(row, column, page);
    })

    it('test_GridLayoutUtil_getBigScreenGridItemPositionWithRTL', 0, () => {
      let row: number = 1;
      let column: number = 1;
      let page: number = 1;
      let isPortrait: boolean = true;
      GridLayoutUtil.getBigScreenGridItemPositionWithRTL(row, column, page, isPortrait);
    })

    it('test_GridLayoutUtil_getBigScreenGridItemPosition', 0, () => {
      let row: number = 1;
      let column: number = 1;
      let page: number = 1;
      let isPortrait: boolean = true;
      GridLayoutUtil.getBigScreenGridItemPosition(row, column, page, isPortrait);
    })

    it('test_GridLayoutUtil_getBigScreenGridItemPosition_01', 0, () => {
      let row: number = -1;
      let column: number = -1;
      let page: number = -1;
      let isPortrait: boolean = true;
      GridLayoutUtil.getBigScreenGridItemPosition(row, column, page, isPortrait);
    })

    it('test_GridLayoutUtil_getBigScreenGridItemPosition_02', 0, () => {
      let row: number = 0;
      let column: number = 0;
      let page: number = 0;
      let isPortrait: boolean = false;
      GridLayoutUtil.getBigScreenGridItemPosition(row, column, page, isPortrait);
    })

    it('test_GridLayoutUtil_getGridItemPositionWithoutRTL', 0, () => {
      let row: number = -1;
      let column: number = -1;
      GridLayoutUtil.getGridItemPositionWithoutRTL(row, column);
    })

    it('test_GridLayoutUtil_getGridItemPositionWithoutRTL_01', 0, () => {
      let row: number = 0;
      let column: number = 0;
      GridLayoutUtil.getGridItemPositionWithoutRTL(row, column);
    })

    it('test_GridLayoutUtil_getGridItemPositionWithoutRTL_02', 0, () => {
      let row: number = 1;
      let column: number = 1;
      GridLayoutUtil.getGridItemPositionWithoutRTL(row, column);
    })

    it('test_GridLayoutUtil_getGridItemPositionWithoutRTL_03', 0, () => {
      let row: number = 1;
      let column: number = 1;
      let page: number = -1;
      GridLayoutUtil.getGridItemPositionWithoutRTL(row, column, page);
    })

    it('test_GridLayoutUtil_getGridItemPositionWithoutRTL_04', 0, () => {
      let row: number = 1;
      let column: number = 1;
      let page: number = 0;
      GridLayoutUtil.getGridItemPositionWithoutRTL(row, column, page);
    })

    it('test_GridLayoutUtil_getGridItemPositionWithoutRTL_05', 0, () => {
      let row: number = 1;
      let column: number = 1;
      let page: number = 1;
      GridLayoutUtil.getGridItemPositionWithoutRTL(row, column, page);
    })

    it('test_GridLayoutUtil_getRealGridItemPosition', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      GridLayoutUtil.getRealGridItemPosition(item);
    })

    it('test_GridLayoutUtil_getRealGridItemPosition_01', 0, () => {
      let item: GridLayoutItemInfo | undefined = undefined;
      GridLayoutUtil.getRealGridItemPosition(item);
    })

    it('test_GridLayoutUtil_getIconCenterPosition', 0, () => {
      let row: number = 1;
      let column: number = 1;
      let area: number[] = [ 1 ];
      GridLayoutUtil.getIconCenterPosition(row, column, area);
    })

    it('test_GridLayoutUtil_getIconCenterPosition_01', 0, () => {
      let row: number = 1;
      let column: number = 1;
      let area: number[] = [];
      GridLayoutUtil.getIconCenterPosition(row, column, area);
    })

    it('test_GridLayoutUtil_getIconCenterPosition_02', 0, () => {
      let row: number = 1;
      let column: number = 1;
      let area: number[] = [ 0 ];
      GridLayoutUtil.getIconCenterPosition(row, column, area);
    })

    it('test_GridLayoutUtil_getIconCenterPosition_03', 0, () => {
      let row: number = 1;
      let column: number = 1;
      let area: number[] = [ -1 ];
      GridLayoutUtil.getIconCenterPosition(row, column, area);
    })

    it('test_GridLayoutUtil_getIconCenterPosition_04', 0, () => {
      let row: number = 0;
      let column: number = 0;
      let area: number[] = [ 1 ];
      GridLayoutUtil.getIconCenterPosition(row, column, area);
    })

    it('test_GridLayoutUtil_getIconCenterPosition_05', 0, () => {
      let row: number = -1;
      let column: number = -1;
      let area: number[] = [ 1 ];
      GridLayoutUtil.getIconCenterPosition(row, column, area);
    })

    it('test_GridLayoutUtil_getIconCenterPosition_06', 0, () => {
      let row: number = -1;
      let column: number = -1;
      let area: number[] = [ 1 ];
      let page: number = 0;
      GridLayoutUtil.getIconCenterPosition(row, column, area, page);
    })

    it('test_GridLayoutUtil_getIconCenterPosition_07', 0, () => {
      let row: number = -1;
      let column: number = -1;
      let area: number[] = [ 1 ];
      let page: number = -1;
      GridLayoutUtil.getIconCenterPosition(row, column, area, page);
    })

    it('test_GridLayoutUtil_getIconCenterPosition_08', 0, () => {
      let row: number = -1;
      let column: number = -1;
      let area: number[] = [ 1 ];
      let page: number = 1;
      GridLayoutUtil.getIconCenterPosition(row, column, area, page);
    })

    it('test_GridLayoutUtil_getIconCenterPosition_09', 0, () => {
      let row: number = -1;
      let column: number = -1;
      let area: number[] = [ 1 ];
      let page: number = 1;
      let isVertical: boolean = true;
      GridLayoutUtil.getIconCenterPosition(row, column, area, page, isVertical);
    })

    it('test_GridLayoutUtil_getIconCenterPosition_10', 0, () => {
      let row: number = -1;
      let column: number = -1;
      let area: number[] = [ 1 ];
      let page: number = 1;
      let isVertical: boolean = false;
      GridLayoutUtil.getIconCenterPosition(row, column, area, page, isVertical);
    })

    it('test_GridLayoutUtil_getIconCenterPosition_11', 0, () => {
      let row: number = 1;
      let column: number = 1;
      let area: number[] = [ 1 ];
      let page: number = 1;
      let isVertical: boolean = true;
      GridLayoutUtil.getIconCenterPosition(row, column, area, page, isVertical);
    })

    it('test_GridLayoutUtil_getIconCenterPositionWithoutRTL', 0, () => {
      let row: number = 1;
      let column: number = 1;
      GridLayoutUtil.getIconCenterPositionWithoutRTL(row, column);
    })

    it('test_GridLayoutUtil_getIconCenterPositionWithoutRTL_01', 0, () => {
      let row: number = 0;
      let column: number = 0;
      GridLayoutUtil.getIconCenterPositionWithoutRTL(row, column);
    })

    it('test_GridLayoutUtil_getIconCenterPositionWithoutRTL_02', 0, () => {
      let row: number = -1;
      let column: number = -1;
      GridLayoutUtil.getIconCenterPositionWithoutRTL(row, column);
    })

    it('test_GridLayoutUtil_getIconCenterPositionWithoutRTL_03', 0, () => {
      let row: number = -1;
      let column: number = -1;
      let area: number[] = [ -1 ];
      GridLayoutUtil.getIconCenterPositionWithoutRTL(row, column, area);
    })

    it('test_GridLayoutUtil_getIconCenterPositionWithoutRTL_04', 0, () => {
      let row: number = -1;
      let column: number = -1;
      let area: number[] = [ 0 ];
      GridLayoutUtil.getIconCenterPositionWithoutRTL(row, column, area);
    })

    it('test_GridLayoutUtil_getIconCenterPositionWithoutRTL_05', 0, () => {
      let row: number = -1;
      let column: number = -1;
      let area: number[] = [ 1 ];
      GridLayoutUtil.getIconCenterPositionWithoutRTL(row, column, area);
    })

    it('test_GridLayoutUtil_getIconCenterPositionWithoutRTL_06', 0, () => {
      let row: number = -1;
      let column: number = -1;
      let area: number[] = [ 1 ];
      let page: number = -1;
      GridLayoutUtil.getIconCenterPositionWithoutRTL(row, column, area, page);
    })

    it('test_GridLayoutUtil_getIconCenterPositionWithoutRTL_07', 0, () => {
      let row: number = -1;
      let column: number = -1;
      let area: number[] = [ 1 ];
      let page: number = 0;
      GridLayoutUtil.getIconCenterPositionWithoutRTL(row, column, area, page);
    })

    it('test_GridLayoutUtil_getIconCenterPositionWithoutRTL_08', 0, () => {
      let row: number = -1;
      let column: number = -1;
      let area: number[] = [ 1 ];
      let page: number = 1;
      GridLayoutUtil.getIconCenterPositionWithoutRTL(row, column, area, page);
    })

    it('test_GridLayoutUtil_getIconCenterPositionWithoutRTL_09', 0, () => {
      let row: number = -1;
      let column: number = -1;
      let area: number[] = [ 1 ];
      let page: number = 1;
      let isPortrait: boolean = true;
      GridLayoutUtil.getIconCenterPositionWithoutRTL(row, column, area, page, isPortrait);
    })

    it('test_GridLayoutUtil_getIconCenterPositionWithoutRTL_10', 0, () => {
      let row: number = -1;
      let column: number = -1;
      let area: number[] = [ 1 ];
      let page: number = 1;
      let isPortrait: boolean = false;
      GridLayoutUtil.getIconCenterPositionWithoutRTL(row, column, area, page, isPortrait);
    })

    it('test_GridLayoutUtil_getRealIconCenterPosition', 0, () => {
      let row: number = -1;
      let column: number = -1;
      let area: number[] = [ -1 ];
      let page: number = -1;
      GridLayoutUtil.getRealIconCenterPosition(row, column, area, page);
    })

    it('test_GridLayoutUtil_getRealIconCenterPosition_01', 0, () => {
      let row: number = 0;
      let column: number = 0;
      let area: number[] = [ 0 ];
      let page: number = 0;
      GridLayoutUtil.getRealIconCenterPosition(row, column, area, page);
    })

    it('test_GridLayoutUtil_getRealIconCenterPosition_02', 0, () => {
      let row: number = 1;
      let column: number = 1;
      let area: number[] = [ 1 ];
      let page: number = 1;
      GridLayoutUtil.getRealIconCenterPosition(row, column, area, page);
    })

    it('test_GridLayoutUtil_getFloorVp', 0, () => {
      let vp: number = -1;
      GridLayoutUtil.getFloorVp(vp);
    })

    it('test_GridLayoutUtil_getFloorVp_01', 0, () => {
      let vp: number = 0;
      GridLayoutUtil.getFloorVp(vp);
    })

    it('test_GridLayoutUtil_getFloorVp_02', 0, () => {
      let vp: number = 1;
      GridLayoutUtil.getFloorVp(vp);
    })

    it('test_GridLayoutUtil_getCeilVp', 0, () => {
      let vp: number = -1;
      GridLayoutUtil.getCeilVp(vp);
    })

    it('test_GridLayoutUtil_getCeilVp_01', 0, () => {
      let vp: number = 0;
      GridLayoutUtil.getCeilVp(vp);
    })

    it('test_GridLayoutUtil_getCeilVp_02', 0, () => {
      let vp: number = 1;
      GridLayoutUtil.getCeilVp(vp);
    })

    it('test_GridLayoutUtil_getRoundVp', 0, () => {
      let vp: number = -1;
      GridLayoutUtil.getRoundVp(vp);
    })

    it('test_GridLayoutUtil_getRoundVp_01', 0, () => {
      let vp: number = 0;
      GridLayoutUtil.getRoundVp(vp);
    })

    it('test_GridLayoutUtil_getRoundVp_02', 0, () => {
      let vp: number = 1;
      GridLayoutUtil.getRoundVp(vp);
    })

    it('test_GridLayoutUtil_getRowAndColumn', 0, () => {
      let x:number = -1;
      let y:number = -1;
      let page:number = -1;
      GridLayoutUtil.getRowAndColumn(x, y, page);
    })

    it('test_GridLayoutUtil_getRowAndColumn_01', 0, () => {
      let x:number = 0;
      let y:number = 0;
      let page:number = 0;
      GridLayoutUtil.getRowAndColumn(x, y, page);
    })

    it('test_GridLayoutUtil_getRowAndColumn_02', 0, () => {
      let x:number = 1;
      let y:number = 1;
      let page:number = 1;
      GridLayoutUtil.getRowAndColumn(x, y, page);
    })

    it('test_GridLayoutUtil_getAppEnterpriseUrl', 0, () => {
      let appItemInfo: AppItemInfo = new AppItemInfo();
      GridLayoutUtil.getAppEnterpriseUrl(appItemInfo);
    })

    it('test_GridLayoutUtil_getSingleDragItemInfo', 0, () => {
      GridLayoutUtil.getSingleDragItemInfo();
    })

    it('test_GridLayoutUtil_isSupportLargeForm', 0, () => {
      let cardDimension:number = -1;
      GridLayoutUtil.isSupportLargeForm(cardDimension);
    })

    it('test_GridLayoutUtil_isSupportLargeForm_01', 0, () => {
      let cardDimension:number = 0;
      GridLayoutUtil.isSupportLargeForm(cardDimension);
    })

    it('test_GridLayoutUtil_isSupportLargeForm_02', 0, () => {
      let cardDimension:number = 1;
      GridLayoutUtil.isSupportLargeForm(cardDimension);
    })

    it('test_GridLayoutUtil_isLargeFoldExpanded', 0, () => {
      GridLayoutUtil.isLargeFoldExpanded();
    })

    it('test_GridLayoutUtil_isLargeFoldOrTrifoldExpanded', 0, () => {
      GridLayoutUtil.isLargeFoldOrTrifoldExpanded();
    })

    it('test_GridLayoutUtil_isMajorApp', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      GridLayoutUtil.isMajorApp(item);
    })

    it('test_GridLayoutUtil_isValidArea', 0, () => {
      let area = [1, 1];
      expect(GridLayoutUtil.isValidArea(area)).assertTrue();
    })
  })
}
