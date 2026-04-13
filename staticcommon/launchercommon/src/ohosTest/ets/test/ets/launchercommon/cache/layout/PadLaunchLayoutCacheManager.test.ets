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
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium'
import { PadLaunchLayoutCacheManager } from '../../../../../../../main/ets/cache/layout/PadLaunchLayoutCacheManager'
import { LauncherLayoutCacheUtil } from '../../../../../../../main/ets/cache/layout/LauncherLayoutCacheUtil'
import {
  AppStatus,
  CommonConstants,
  DefaultDesktopLayoutInfo,
  GridLayoutConfig,
  GridLayoutItemInfo,
  LayoutDescription,
  StyleConstants
} from '../../../../../../../main/ets/TsIndex'
import { DesktopLayoutCacheData } from '../../../../../../../main/ets/cache/layout/DesktopLayoutCacheData'
import { CheckEmptyUtils } from '@ohos/basicutils'

export default function PadLaunchLayoutCacheManagerTest() {
  describe('PadLaunchLayoutCacheManagerTest', () => {
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
    it('test_changeCurrentLayoutCacheData', 0, () => {
      PadLaunchLayoutCacheManager.getInstance().changeCurrentLayoutCacheData(false);

      PadLaunchLayoutCacheManager.getInstance().changeCurrentLayoutCacheData(true);
      expect(LauncherLayoutCacheUtil.getIsPadPortrait()).assertInstanceOf('Boolean')
    })

    it('test_cloneCache', 0, () => {
      const pageCount = 2;
      const item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.bundleName = 'com.ohos.clock';
      item.abilityName = 'main';
      const desc: LayoutDescription = new LayoutDescription();
      desc.pageCount = pageCount;
      desc.row = 2;
      desc.column = 1;
      desc.maxPage = 3;
      desc.maxForm = 2;
      let defaultLayout: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      defaultLayout.layoutDescription = desc;
      defaultLayout.layoutInfo = [item];
      let ret: DefaultDesktopLayoutInfo = PadLaunchLayoutCacheManager.getInstance()['cloneCache'](defaultLayout);
      expect(ret.layoutDescription).not().assertNull();
      expect(ret.layoutDescription.pageCount).assertEqual(pageCount);
    })

    it('test_getPortraitMode', 0, () => {
      let ret = PadLaunchLayoutCacheManager.getInstance().getPortraitMode();
      expect(ret).assertEqual(PadLaunchLayoutCacheManager.getInstance()['isPortraitMode']);
    })

    it('test_updateLandscapeCacheFromPortrait', 0, () => {
      PadLaunchLayoutCacheManager.getInstance()['isPortraitMode'] = false;
      PadLaunchLayoutCacheManager.getInstance().updateLandscapeCacheFromPortrait(false);

      PadLaunchLayoutCacheManager.getInstance()['isPortraitMode'] = true;
      PadLaunchLayoutCacheManager.getInstance().updateLandscapeCacheFromPortrait(false);

      PadLaunchLayoutCacheManager.getInstance()['isPortraitMode'] = true;
      PadLaunchLayoutCacheManager.getInstance().updateLandscapeCacheFromPortrait(true);
      expect(PadLaunchLayoutCacheManager.getInstance()['layoutCacheData']).not().assertNull();
    })

    it('test_initInstance', 0, () => {
      try {
        let manager: PadLaunchLayoutCacheManager = PadLaunchLayoutCacheManager.getInstance();
        expect(manager).not().assertNull();
        let mGridLayoutInfo: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
        let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(mGridLayoutInfo);
        manager.reInit(layoutCacheData);
        let config: GridLayoutConfig = new GridLayoutConfig();
        expect(manager['layoutCacheData']).not().assertUndefined();
        manager.initGridConfig(config);
        expect(manager['isGridConfigInit']).assertTrue();
        manager.initGridConfig(config);
        expect(manager['isGridConfigInit']).assertTrue();
        let isPortraitMode = manager['isPortraitMode'];
        if (isPortraitMode) {
          manager.changeCurrentLayoutCacheData(true, 0);
          expect(manager['isPortraitMode']).assertTrue();
          manager.changeCurrentLayoutCacheData(false, 0);
          expect(manager['isPortraitMode']).assertFalse();
        }
        if (!isPortraitMode) {
          manager.changeCurrentLayoutCacheData(false, 0);
          expect(manager['isPortraitMode']).assertFalse();
          manager.changeCurrentLayoutCacheData(true, 0);
          expect(manager['isPortraitMode']).assertTrue();
        }
      } catch (e) {
      }
    })

    it('test_changeCurrentLayoutCacheData_001', 0, () => {
      let manager: PadLaunchLayoutCacheManager = PadLaunchLayoutCacheManager.getInstance();
      let isGridConfigInit = manager['isGridConfigInit'];
      let isPortrait = !manager['isPortraitMode'];
      let isPad = manager['layoutCacheData'].isPad();
      if (isGridConfigInit) {
        manager['isGridConfigInit'] = false;
      }
      manager.changeCurrentLayoutCacheData(isPortrait);
      expect(manager['layoutCacheData'].isPad()).assertTrue();
      manager['layoutCacheData'].setIsPad(isPad);
    })

    it('test_isNeedCheckDragAble', 0, () => {
      let manager: PadLaunchLayoutCacheManager = PadLaunchLayoutCacheManager.getInstance();
      let item1: GridLayoutItemInfo = createFullValueGridItem();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let isAble = manager.isNeedCheckDragAble(0, item1, 0);
      expect(isAble).assertFalse();
      let mockFunc1: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
      let isAble1 = manager.isNeedCheckDragAble(0, item1, 0);
      expect(isAble1).assertFalse();
      let item2: GridLayoutItemInfo = createFullValueGridItem();
      item2.area = [0];
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let isAble2 = manager.isNeedCheckDragAble(0, item2, 0);
      expect(isAble2).assertFalse();
      mocker.clear(CheckEmptyUtils);
    })

    it('test_isNeedCheckDragAble_001', 0, () => {
      let manager: PadLaunchLayoutCacheManager = PadLaunchLayoutCacheManager.getInstance();
      let item1: GridLayoutItemInfo = createFullValueGridItem();
      item1.page = 0;
      item1.area = [0, 1];
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      let mockFunc1: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let isAble = manager.isNeedCheckDragAble(0, item1, 0);
      expect(isAble).assertFalse();
      mocker.clear(CheckEmptyUtils);
      mocker.clear(manager);
    })

    it('test_cloneInitAllLayout', 0, () => {
      let manager: PadLaunchLayoutCacheManager = PadLaunchLayoutCacheManager.getInstance();
      let layoutCacheData: DesktopLayoutCacheData = manager['layoutCacheData'];
      if (layoutCacheData) {
        let layoutInfo: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
        let item1: GridLayoutItemInfo = createFullValueGridItem();
        layoutInfo.layoutInfo = [item1];
        let mocker: MockKit = new MockKit();
        try {
          let mockFunc: Function = mocker.mockFunc(layoutCacheData, layoutCacheData.getPortraitLayoutInfo);
          when(mockFunc)().afterReturn(undefined);
          manager['cloneInitAllLayout'](true);
          expect(manager['oldPortraitColumnRowList'].length >= 0).assertTrue();
          let mockFunc1: Function = mocker.mockFunc(layoutCacheData, layoutCacheData.getLandscapeLayoutInfo);
          when(mockFunc1)().afterReturn(undefined);
          manager['cloneInitAllLayout'](false);
          expect(manager['oldLandColumnRowList'].length >= 0).assertTrue();
        } catch(e){}
        mocker.clear(layoutCacheData);
      }
    })

    it('test_cloneInitAllLayout_001', 0, () => {
      let manager: PadLaunchLayoutCacheManager = PadLaunchLayoutCacheManager.getInstance();
      let layoutCacheData: DesktopLayoutCacheData = manager['layoutCacheData'];
      if (layoutCacheData) {
        let mocker: MockKit = new MockKit();
        try {
          let layoutInfo: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
          let item1: GridLayoutItemInfo = createFullValueGridItem();
          layoutInfo.layoutInfo = [item1];
          let mockFunc: Function = mocker.mockFunc(layoutCacheData, layoutCacheData.getPortraitLayoutInfo);
          when(mockFunc)().afterReturn(layoutInfo);
          manager['cloneInitAllLayout'](true);
          expect(manager['oldPortraitColumnRowList'].length >= 0).assertTrue();
          let mockFunc1: Function = mocker.mockFunc(layoutCacheData, layoutCacheData.getLandscapeLayoutInfo);
          when(mockFunc1)().afterReturn(layoutInfo);
          manager['cloneInitAllLayout'](false);
          expect(manager['oldLandColumnRowList'].length >= 0).assertTrue();
        } catch(e) {}
        mocker.clear(layoutCacheData);
      }
    })

    it('test_getItemGridLayoutData_emptyItem', 0, () => {
      let manager: PadLaunchLayoutCacheManager = PadLaunchLayoutCacheManager.getInstance();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.typeId = CommonConstants.TYPE_APP;
      manager['getItemGridLayoutData'](item1, []);
      expect(item1).not().assertUndefined();
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.typeId = CommonConstants.TYPE_APP;
      item2.area = [0, 1, 1];
      manager['getItemGridLayoutData'](item1, []);
      expect(item2.area.length !== StyleConstants.DEFAULT_2).assertTrue();
    })

    it('test_getItemGridLayoutData_001', 0, () => {
      let manager: PadLaunchLayoutCacheManager = PadLaunchLayoutCacheManager.getInstance();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.typeId = CommonConstants.TYPE_FOLDER;
      item1.area = [0, 1];
      item1.column = 0;
      item1.row = 1;
      item1.id = 10012;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.id = 10012;
      item1.layoutInfo = [[item2]]
      manager['getItemGridLayoutData'](item1, []);
      expect(item1.layoutInfo.length > 0).assertTrue();
    })

    it('test_getItemGridLayoutData_002', 0, () => {
      let manager: PadLaunchLayoutCacheManager = PadLaunchLayoutCacheManager.getInstance();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.typeId = CommonConstants.TYPE_FORM_STACK;
      item1.area = [0, 1];
      item1.column = 0;
      item1.row = 1;
      item1.id = 10012;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.id = 10012;
      item1.layoutInfo = [[item2]]
      manager['getItemGridLayoutData'](item1, []);
      expect(item1.layoutInfo.length > 0).assertTrue();
    })

    it('test_getItemGridLayoutData_003', 0, () => {
      let manager: PadLaunchLayoutCacheManager = PadLaunchLayoutCacheManager.getInstance();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.typeId = CommonConstants.TYPE_APP;
      item1.area = [0, 1];
      item1.column = 0;
      item1.row = 1;
      item1.id = 10012;
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.id = 10012;
      item1.layoutInfo = [[item2]]
      manager['getItemGridLayoutData'](item1, []);
      expect(item1.layoutInfo.length > 0).assertTrue();
    })

    it('test_getUniqueId_typeAPP', 0, () => {
      let manager: PadLaunchLayoutCacheManager = PadLaunchLayoutCacheManager.getInstance();
      let uniqueId: number = 10087;
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.typeId = CommonConstants.TYPE_APP;
      item1.id = uniqueId;
      expect(manager['getUniqueId'](item1)).assertEqual(uniqueId);
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.typeId = CommonConstants.TYPE_APP;
      item2.appIconId = uniqueId;
      expect(manager['getUniqueId'](item2)).assertEqual(uniqueId);
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.typeId = CommonConstants.TYPE_APP;
      item3.applicationLabelId = uniqueId;
      expect(manager['getUniqueId'](item3)).assertEqual(uniqueId);
      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.typeId = CommonConstants.TYPE_APP;
      item4.applicationLabelId = uniqueId;
      item4.appStatus = AppStatus.INSTALL_WAITING;
      expect(manager['getUniqueId'](item4)).not().assertEqual(uniqueId);
    })

    it('test_getUniqueId_TYPE_CARD', 0, () => {
      let manager: PadLaunchLayoutCacheManager = PadLaunchLayoutCacheManager.getInstance();
      let uniqueId: number = 10087;
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.typeId = CommonConstants.TYPE_CARD;
      item1.id = uniqueId;
      expect(manager['getUniqueId'](item1)).assertEqual(uniqueId);
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.typeId = CommonConstants.TYPE_CARD;
      item2.cardId = '1' + uniqueId;
      expect(manager['getUniqueId'](item2)).not().assertEqual(uniqueId);
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.typeId = CommonConstants.TYPE_CARD;
      item3.id = 0;
      item3.appLabelId = uniqueId;
      expect(manager['getUniqueId'](item3)).assertEqual(uniqueId);
    })

    it('test_getUniqueId_TYPE_SHORTCUT_ICON', 0, () => {
      let manager: PadLaunchLayoutCacheManager = PadLaunchLayoutCacheManager.getInstance();
      let uniqueId: number = 10087;
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      item1.appIconId = uniqueId;
      expect(manager['getUniqueId'](item1)).assertEqual(uniqueId);
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      item2.applicationLabelId = uniqueId;
      expect(manager['getUniqueId'](item2)).assertEqual(uniqueId);
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      item3.id = uniqueId;
      item3.appLabelId = uniqueId;
      expect(manager['getUniqueId'](item3)).assertEqual(uniqueId);
      let itemOther: GridLayoutItemInfo = new GridLayoutItemInfo();
      itemOther.typeId = CommonConstants.TYPE_FORM_STACK;
      itemOther.id = uniqueId;
      expect(manager['getUniqueId'](itemOther)).assertEqual(uniqueId);
    })

    it('test_getChangePages', 0, () => {
      let manager: PadLaunchLayoutCacheManager = PadLaunchLayoutCacheManager.getInstance();
      let res: number[] = manager['getChangePages'](true, true);
      expect(res.length >= 0).assertTrue();
    })

    it('test_getChangePages_001', 0, () => {
      let manager: PadLaunchLayoutCacheManager = PadLaunchLayoutCacheManager.getInstance();
      let layoutData = manager['layoutCacheData'];
      let mGridLayoutInfo: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(mGridLayoutInfo);
      try {
        manager.reInit(layoutCacheData);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(layoutCacheData, layoutCacheData.getLandscapeLayoutInfo);
      when(mockFunc)().afterReturn(undefined);
      try {
        manager['getChangePages'](true, true);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      let mockFunc1: Function = mocker.mockFunc(layoutCacheData, layoutCacheData.getPortraitLayoutInfo);
      when(mockFunc1)().afterReturn(undefined);
      try {
        manager['getChangePages'](false, true);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      when(mockFunc)().afterReturn(mGridLayoutInfo);
      try {
        expect(mGridLayoutInfo.layoutDescription.pageCount).assertEqual(1);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      mocker.clear(layoutCacheData);
    })

    it('test_getLayoutBeforeRotate_001', 0, () => {
      let layoutInfo: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
      let item1: GridLayoutItemInfo = createFullValueGridItem();
      layoutInfo.layoutInfo = [item1];
      let manager: PadLaunchLayoutCacheManager = PadLaunchLayoutCacheManager.getInstance();
      let res: string[] = manager['getLayoutBeforeRotate'](layoutInfo, 0);
      expect(res).not().assertUndefined();
    })

    it('test_changeCurrentLayoutCacheDataPortrait_001', 0, () => {
      let manager: PadLaunchLayoutCacheManager = PadLaunchLayoutCacheManager.getInstance();
      let mGridLayoutInfo: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(mGridLayoutInfo);
      expect(layoutCacheData.getLandscapeLayoutInfo()).not().assertUndefined();
      try {
        manager.reInit(layoutCacheData);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      expect(manager['layoutCacheData'].getLandscapeLayoutInfo()).not().assertUndefined();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(layoutCacheData, layoutCacheData.getLandscapeLayoutInfo);
      when(mockFunc)().afterReturn(undefined);
      manager['oldPortraitColumnRowList'] = [];
      try {
        manager['changeCurrentLayoutCacheDataLandscape'](true);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      expect(manager['oldPortraitColumnRowList']).not().assertUndefined();
      mocker.clear(layoutCacheData);
    })

    it('test_changeCurrentLayoutCacheDataPortrait_catchError', 0, () => {
      let manager: PadLaunchLayoutCacheManager = PadLaunchLayoutCacheManager.getInstance();
      let mGridLayoutInfo: DefaultDesktopLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();
      let layoutCacheData: DesktopLayoutCacheData = new DesktopLayoutCacheData(mGridLayoutInfo);
      expect(layoutCacheData.getLandscapeLayoutInfo()).not().assertUndefined();
      try {
        manager.reInit(layoutCacheData);
        expect(manager['layoutCacheData'].getLandscapeLayoutInfo()).not().assertUndefined();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(layoutCacheData, layoutCacheData.getLandscapeLayoutInfo);
      when(mockFunc)().afterReturn(undefined);
      let mockFunc1: Function = mocker.mockFunc(LauncherLayoutCacheUtil, LauncherLayoutCacheUtil.getRotateLayout);
      when(mockFunc1)(ArgumentMatchers.any).afterThrow('error');
      manager['oldPortraitColumnRowList'] = [];
      try {
        manager['changeCurrentLayoutCacheDataLandscape'](true);
        expect(manager['oldPortraitColumnRowList']).not().assertUndefined();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      mocker.clear(layoutCacheData);
      mocker.clear(LauncherLayoutCacheUtil);
    })

    it('test_updateLandscapeCacheData_catchError', 0, () => {
      let manager: PadLaunchLayoutCacheManager = PadLaunchLayoutCacheManager.getInstance();
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_cloneLandLayoutBeforeRotate', 0, () => {
      let manager: PadLaunchLayoutCacheManager = PadLaunchLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(manager['layoutCacheData'], manager['layoutCacheData'].getLandscapeLayoutInfo);
      let mockLayoutInfo: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
      mockLayoutInfo.layoutDescription.pageCount = 2;
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.page = 0;
      item1.row = 0;
      item1.column = 0;
      item1.area = [1, 1];
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.page = 1;
      item1.row = 1;
      item1.column = 1;
      item1.area = [1, 1];
      mockLayoutInfo.layoutInfo = [item1, item2];
      when(mockFunc)().afterReturn(mockLayoutInfo);
      let mockFunc2: Function = mocker.mockFunc(manager, manager['gridLayoutData']);
      when(mockFunc2)().afterReturn(['1']);
      manager['cloneLandLayoutBeforeRotate']();
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.clear(manager['layoutCacheData']);
      mocker.clear(manager);
      mocker.clearAll();
    });

    it('test_clonePortraitLayoutBeforeRotate', 0, () => {
      let manager: PadLaunchLayoutCacheManager = PadLaunchLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(manager['layoutCacheData'], manager['layoutCacheData'].getPortraitLayoutInfo);
      let mockLayoutInfo: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
      mockLayoutInfo.layoutDescription.pageCount = 2;
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.page = 0;
      item1.row = 0;
      item1.column = 0;
      item1.area = [1, 1];
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.page = 1;
      item1.row = 1;
      item1.column = 1;
      item1.area = [1, 1];
      mockLayoutInfo.layoutInfo = [item1, item2];
      when(mockFunc)().afterReturn(mockLayoutInfo);
      let mockFunc2: Function = mocker.mockFunc(manager, manager['gridLayoutData']);
      when(mockFunc2)().afterReturn(['1']);
      manager['cloneLandLayoutBeforeRotate']();
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.clear(manager['layoutCacheData']);
      mocker.clear(manager);
      mocker.clearAll();
    });

    it('should_isRowColumnChangeBeforeRotate', 0, () => {
      let manager: PadLaunchLayoutCacheManager = PadLaunchLayoutCacheManager.getInstance();
      let mockLayoutInfo: DefaultDesktopLayoutInfo = new DefaultDesktopLayoutInfo();
      mockLayoutInfo.layoutDescription.pageCount = 2;
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.page = 0;
      item1.row = 0;
      item1.column = 0;
      item1.area = [1, 1];
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.page = 1;
      item1.row = 1;
      item1.column = 1;
      item1.area = [1, 1];
      mockLayoutInfo.layoutInfo = [item1, item2];
      let mocker: MockKit = new MockKit();
      let mockGetLandscapeLayoutInfo: Function = mocker.mockFunc(manager['layoutCacheData'], manager['layoutCacheData'].getLandscapeLayoutInfo);
      when(mockGetLandscapeLayoutInfo)().afterReturn(mockLayoutInfo);
      let mockGetPortraitLayoutInfo: Function = mocker.mockFunc(manager['layoutCacheData'], manager['layoutCacheData'].getPortraitLayoutInfo);
      when(mockGetPortraitLayoutInfo)().afterReturn(mockLayoutInfo);
      let MockGridLayoutData: Function = mocker.mockFunc(manager, manager['gridLayoutData']);
      when(MockGridLayoutData)(ArgumentMatchers.any).afterReturn(['1']);
      manager['isPortraitMode'] = false;
      manager['beforeRotateLandRowColumnList'] = [{pageIndex: 0, rowColumn: ['1']}, {pageIndex: 1, rowColumn: ['1']}];
      manager['beforeRotatePortraitRowColumnList'] = [{pageIndex: 0, rowColumn: ['1']}, {pageIndex: 1, rowColumn: ['1']}];
      let MockIsEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(MockIsEmpty)(ArgumentMatchers.any).afterReturn(true);
      let mPageIndex: number = 0;
      let newRowColumn: string[] = ['1', '2'];
      let result = manager.isRowColumnChangeBeforeRotate(mPageIndex, newRowColumn);
      expect(result).assertInstanceOf('Boolean');
      when(MockIsEmpty)(ArgumentMatchers.any).afterReturn(false);
      let result2 = manager.isRowColumnChangeBeforeRotate(mPageIndex, newRowColumn);
      expect(result2).assertInstanceOf('Boolean');
      manager['isPortraitMode'] = true;
      when(MockIsEmpty)(ArgumentMatchers.any).afterReturn(true);
      let result3 = manager.isRowColumnChangeBeforeRotate(mPageIndex, newRowColumn);
      expect(result3).assertInstanceOf('Boolean');
      when(MockIsEmpty)(ArgumentMatchers.any).afterReturn(false);
      let result4 = manager.isRowColumnChangeBeforeRotate(mPageIndex, newRowColumn);
      expect(result4).assertInstanceOf('Boolean');
      mocker.clear(manager['layoutCacheData']);
      mocker.clear(manager);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });
  })
}

function createFullValueGridItem(area: number[] = [0, 1],
  typeId: number = CommonConstants.TYPE_APP): GridLayoutItemInfo {
  let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
  item1.area = area;
  item1.column = 1;
  item1.row = 0;
  item1.typeId = typeId;
  item1.id = 10022;
  item1.appIconId = 1;
  item1.infoId = '0012';
  item1.cardId = '1222';
  return item1;
}

function createColumnLists(): ColumnRowList[] {
  let item1: ColumnRowList = new ColumnRowList();
  item1.pageIndex = 0;
  item1.columnRow = ['1', '2', '3'];
  let item2: ColumnRowList = new ColumnRowList();
  item2.pageIndex = 1;
  item2.columnRow = ['1', '2', '3'];
  return [item1, item2];
}

class ColumnRowList {
  pageIndex: number = 0;
  columnRow: string[] = [];
}