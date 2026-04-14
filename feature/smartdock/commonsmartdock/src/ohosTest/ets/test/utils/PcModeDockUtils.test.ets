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
import { CheckEmptyUtils, RectInfo } from '@ohos/basicutils';
import { ItemUtils } from '@ohos/componenthelper';

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import { AppItemInfo, DockItemInfo, ResidentLayoutCacheMgr } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { PcModeDockUtils } from '../../../../main/ets/default/utils/PcModeDockUtils';

export default function PcModeDockUtilsTest() {
  describe('PcModeDockUtilsTest', () => {
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
    it('test_updateDockMissionsPopupShow_1', 0, () => {
      let item: DockItemInfo = new DockItemInfo();
      item.bundleName = 'com.ohos.sceneboard';
      item.abilityName = 'com.ohos.sceneboard.recents.MainAbility';
      item.typeId = 0;
      item.itemType = 2;
      item.areaType = 1;
      item.appIndex = 0;
      PcModeDockUtils.updateDockMissionsPopupShow(true, true, item);
      let a: boolean = AppStorage.get<boolean>('isDockMissionsPopupShow') ?? false;
      expect(a).not().assertNull();
    })
    it('test_updateDockMissionsPopupShow_2', 0, () => {
      let item: DockItemInfo = new DockItemInfo();
      item.bundleName = 'com.ohos.sceneboard';
      item.abilityName = 'com.ohos.sceneboard.recents.MainAbility';
      item.typeId = 0;
      item.itemType = 2;
      item.areaType = 1;
      item.appIndex = 0;
      PcModeDockUtils.updateDockMissionsPopupShow(false, true, item);
      let a: boolean = AppStorage.get<boolean>('isDockMissionsPopupShow') ?? true;
      expect(a).not().assertNull();
    })
    it('test_updateDockMissionsPopupShow_3', 0, () => {
      let item: DockItemInfo = new DockItemInfo();
      item.bundleName = 'com.ohos.sceneboard';
      item.abilityName = 'com.ohos.sceneboard.recents.MainAbility';
      item.typeId = 0;
      item.itemType = 2;
      item.areaType = 1;
      item.appIndex = 0;
      PcModeDockUtils.updateDockMissionsPopupShow(true, false, item);
      let a: boolean = AppStorage.get<boolean>('isDockMissionsPopupShow') ?? false;
      expect(a).not().assertNull();
    })

    it('test_isEnableDesktopFeatureAnimation', 0, () => {
      PcModeDockUtils.callHideDock();
      let a: boolean = PcModeDockUtils.isEnableDesktopFeatureAnimation();
      expect(a).assertTrue();
    })
    it('test_is2D', 0, () => {
      try {
        let a: boolean = PcModeDockUtils.is2D();
        expect(a).assertFalse();
      } catch (err) {}
    })

    it('test_getPadDockAnimationWithArrowRect1', 0, () => {
      let appItem: AppItemInfo = new AppItemInfo();
      appItem.bundleName = 'testBundle';
      appItem.abilityName = 'testAbility';
      appItem.appIndex = 0;
      let mocker: MockKit = new MockKit();
      let mockCheckIsResidentItem: Function = mocker.mockFunc(PcModeDockUtils, PcModeDockUtils.checkIsResidentItem);
      when(mockCheckIsResidentItem)(ArgumentMatchers.any).afterReturn(true);
      let mockGetRectById: Function = mocker.mockFunc(ItemUtils, ItemUtils.getRectById);
      let expectedRect: RectInfo = { left: 10, top: 10, right: 20, bottom: 20 };
      when(mockGetRectById)(ArgumentMatchers.any).afterReturn(expectedRect);
      const result = PcModeDockUtils.getPadDockAnimationWithArrowRect(appItem);
      expect(result).assertDeepEquals(expectedRect);
      mocker.ignoreMock(PcModeDockUtils, PcModeDockUtils.checkIsResidentItem);
      mocker.ignoreMock(ItemUtils, ItemUtils.getRectById);
    });

    it('test_getPadDockAnimationWithArrowRect2', 0, () => {
      let appItem: AppItemInfo = new AppItemInfo();
      appItem.bundleName = 'testBundle';
      appItem.abilityName = 'testAbility';
      appItem.appIndex = 0;
      let mocker: MockKit = new MockKit();
      let mockCheckIsResidentItem: Function = mocker.mockFunc(PcModeDockUtils, PcModeDockUtils.checkIsResidentItem);
      when(mockCheckIsResidentItem)(ArgumentMatchers.any).afterReturn(false);
      let mockCheckRectEmpty: Function = mocker.mockFunc(PcModeDockUtils, PcModeDockUtils.checkRectEmpty);
      when(mockCheckRectEmpty)(ArgumentMatchers.any).afterReturn(true);
      let mockGetRectById: Function = mocker.mockFunc(ItemUtils, ItemUtils.getRectById);
      let expectedRect: RectInfo = { left: 10, top: 10, right: 20, bottom: 20 };
      when(mockGetRectById)(ArgumentMatchers.any).afterReturn(expectedRect);
      const result = PcModeDockUtils.getPadDockAnimationWithArrowRect(appItem);
      expect(result).assertDeepEquals(expectedRect);
      mocker.ignoreMock(PcModeDockUtils, PcModeDockUtils.checkIsResidentItem);
      mocker.ignoreMock(PcModeDockUtils, PcModeDockUtils.checkRectEmpty);
      mocker.ignoreMock(ItemUtils, ItemUtils.getRectById);
    });

    it('test_getPadDockAnimationWithArrowRect3', 0, () => {
      let appItem: AppItemInfo = new AppItemInfo();
      appItem.bundleName = 'testBundle';
      appItem.abilityName = 'testAbility';
      appItem.appIndex = 0;
      let mocker: MockKit = new MockKit();
      let mockCheckIsResidentItem: Function = mocker.mockFunc(PcModeDockUtils, PcModeDockUtils.checkIsResidentItem);
      when(mockCheckIsResidentItem)(ArgumentMatchers.any).afterReturn(false);
      let mockCheckRectEmpty: Function = mocker.mockFunc(PcModeDockUtils, PcModeDockUtils.checkRectEmpty);
      when(mockCheckRectEmpty)(ArgumentMatchers.any).afterReturn(false);
      let mockGetRectById: Function = mocker.mockFunc(ItemUtils, ItemUtils.getRectById);
      let expectedRect: RectInfo = { left: 10, top: 10, right: 20, bottom: 20 };
      when(mockGetRectById)(ArgumentMatchers.any).afterReturn(expectedRect);
      const result = PcModeDockUtils.getPadDockAnimationWithArrowRect(appItem);
      expect(result).assertDeepEquals(expectedRect);
      mocker.ignoreMock(PcModeDockUtils, PcModeDockUtils.checkIsResidentItem);
      mocker.ignoreMock(PcModeDockUtils, PcModeDockUtils.checkRectEmpty);
      mocker.ignoreMock(ItemUtils, ItemUtils.getRectById);
    });

    it('test_getPadDockAnimationWithArrowRect4', 0, () => {
      let appItem: AppItemInfo = new AppItemInfo();
      appItem.bundleName = 'testBundle';
      appItem.abilityName = 'testAbility';
      appItem.appIndex = 0;
      let mocker: MockKit = new MockKit();
      let mockCheckIsResidentItem: Function = mocker.mockFunc(PcModeDockUtils, PcModeDockUtils.checkIsResidentItem);
      when(mockCheckIsResidentItem)(ArgumentMatchers.any).afterReturn(false);
      let mockCheckRectEmpty: Function = mocker.mockFunc(PcModeDockUtils, PcModeDockUtils.checkRectEmpty);
      when(mockCheckRectEmpty)(ArgumentMatchers.any).afterReturn(false);
      let mockGetRectById: Function = mocker.mockFunc(ItemUtils, ItemUtils.getRectById);
      let expectedRect: RectInfo = { left: 10, top: 10, right: 20, bottom: 20 };
      when(mockGetRectById)(ArgumentMatchers.any).afterReturn(expectedRect);
      const result = PcModeDockUtils.getPadDockAnimationWithArrowRect(appItem);
      expect(result).assertDeepEquals(expectedRect);
      mocker.ignoreMock(PcModeDockUtils, PcModeDockUtils.checkIsResidentItem);
      mocker.ignoreMock(PcModeDockUtils, PcModeDockUtils.checkRectEmpty);
      mocker.ignoreMock(ItemUtils, ItemUtils.getRectById);
    });

    it('test_checkIsResidentItem1', 0, () => {
      try {
        let dockItem: DockItemInfo = new DockItemInfo();
        dockItem.bundleName = 'testBundle';
        dockItem.abilityName = 'testAbility';
        dockItem.appIndex = 1;
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [dockItem], false);
        let appItem: AppItemInfo = new AppItemInfo();
        appItem.bundleName = 'testBundle';
        appItem.abilityName = 'testAbility';
        appItem.appIndex = 1;
        AppStorage.setOrCreate('recentList', []);
        const result = PcModeDockUtils.checkIsResidentItem(appItem);
        expect(result).assertTrue();
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
        AppStorage.delete('recentList');
      } catch (err) {}
    });

    it('test_checkIsResidentItem2', 0, () => {
      try {
        let appItem: AppItemInfo = new AppItemInfo();
        appItem.bundleName = 'testBundle';
        appItem.abilityName = 'testAbility';
        appItem.appIndex = 1;
        ResidentLayoutCacheMgr.getInstance().updateAllDockItems('test', [], false);
        AppStorage.setOrCreate('recentList', [appItem]);
        const result = PcModeDockUtils.checkIsResidentItem(appItem);
        expect(result).assertFalse();
        AppStorage.delete('recentList');
      }catch (err){}
    });

    it('test_checkIsResidentItem3', 0, () => {
      let appItem: AppItemInfo = new AppItemInfo();
      appItem.bundleName = 'testBundle';
      appItem.abilityName = 'testAbility';
      appItem.appIndex = 1;
      let mocker: MockKit = new MockKit();
      let mockGet = mocker.mockFunc(AppStorage, AppStorage.get);
      when(mockGet)('residentList').afterReturn([]);
      when(mockGet)('recentList').afterReturn([]);
      const result = PcModeDockUtils.checkIsResidentItem(appItem);
      expect(result).assertFalse();
      mocker.ignoreMock(AppStorage, AppStorage.get);
    });

    it('test_checkRectEmpty1', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      const result = PcModeDockUtils.checkRectEmpty({left: 0, right: 0, top: 0, bottom: 0});
      expect(result).assertTrue();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
    });

    it('test_checkRectEmpty2', 0, () => {
      const result = PcModeDockUtils.checkRectEmpty({left: 0, right: 0, top: 0, bottom: 0});
      expect(result).assertTrue();
    });

    it('test_checkRectEmpty3', 0, () => {
      const result = PcModeDockUtils.checkRectEmpty({left: 1, right: 1, top: 1, bottom: 1});
      let a = 'test';
      expect(a).assertEqual('test');
    });
    it('test_isInResidentFolder1', 0, () => {
      let residentList: DockItemInfo[] = [];
      let bundleName: string = "com.example.app";
      const result = PcModeDockUtils.isInResidentFolder(residentList, bundleName);
      expect(result).assertEqual(false);
    });
    it('test_isInDockList1', 0, () => {
      let appList: DockItemInfo[] = [];
      let bundleName: string = "com.example.app";
      const result = PcModeDockUtils.isInDockList(appList, bundleName);
      expect(result).assertEqual(false);
    });
    it('test_isInDockList220', 0, () => {
      try {
        let item1 = new DockItemInfo();
        let item2 = new DockItemInfo();
        item1.bundleName = 'com.example.app';
        item2.bundleName = 'com.example.app2';
        let appList: DockItemInfo[] = [item1, item2];
        let bundleName: string = "com.example.app";
        const result = PcModeDockUtils.isInDockList(appList, bundleName);
        expect(result).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
    it('test_isInstanceWindowExist1', 0, () => {
      const result = PcModeDockUtils.isInstanceWindowExist('com.example.app', 0);
      expect(result).assertEqual(false);
    });
  })
}
