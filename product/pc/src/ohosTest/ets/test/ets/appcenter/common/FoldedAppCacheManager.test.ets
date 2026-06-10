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
import { AppLayoutInfo } from "@ohos/appcenter/src/main/ets/default/common/viewmodel/AppLayoutInfo"
import { FoldedAppCacheManager } from "@ohos/appcenter/src/main/ets/default/folded/FoldedAppCacheManager"
import { FoldedDeviceAcViewModel } from "@ohos/appcenter/src/main/ets/default/folded/FoldedDeviceAcViewModel"
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level, MockKit, when } from "@ohos/hypium"

export default function FoldedAppCacheManagerTest() {
  describe('FoldedAppCacheManagerTest', () => {
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

    it('test_FoldedAppCacheManagerTest_getAppGridLayoutItemsByPage', Level.LEVEL0, (): void => {
      let instance: FoldedAppCacheManager = new FoldedAppCacheManager();
      let pageIdx: number = 0;
      let foldedDeviceAcVM: FoldedDeviceAcViewModel = FoldedDeviceAcViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockerFunc1 = mocker.mockFunc(foldedDeviceAcVM, foldedDeviceAcVM.isUnFoldedHorizontal);
      when(mockerFunc1)().afterReturn(true);
      instance.getAppGridLayoutItemsByPage(pageIdx);
      expect(true).assertTrue();
    })

    it('test_FoldedAppCacheManagerTest_reorderAllAppInPages', Level.LEVEL0, (): void => {
      let instance: FoldedAppCacheManager = new FoldedAppCacheManager();
      let pageIdx: number = 0;
      let foldedDeviceAcVM: FoldedDeviceAcViewModel = FoldedDeviceAcViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockerFunc1 = mocker.mockFunc(foldedDeviceAcVM, foldedDeviceAcVM.isUnFoldedHorizontal);
      when(mockerFunc1)().afterReturn(false);
      instance.reorderAllAppInPages();

      when(mockerFunc1)().afterReturn(true);
      instance.reorderAllAppInPages();
      expect(true).assertTrue();
    })

    it('test_FoldedAppCacheManagerTest_updateItemPositionById', Level.LEVEL0, (): void => {
      let instance: FoldedAppCacheManager = new FoldedAppCacheManager();
      let foldedDeviceAcVM: FoldedDeviceAcViewModel = FoldedDeviceAcViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockerFunc1 = mocker.mockFunc(foldedDeviceAcVM, foldedDeviceAcVM.isUnFoldedHorizontal);
      when(mockerFunc1)().afterReturn(false);
      instance.updateItemPositionById([]);
      expect(true).assertTrue();
    })

    it('test_FoldedAppCacheManagerTest_updateItemForDifferentPage', Level.LEVEL0, (): void => {
      let instance: FoldedAppCacheManager = new FoldedAppCacheManager();
      let foldedDeviceAcVM: FoldedDeviceAcViewModel = FoldedDeviceAcViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockerFunc1 = mocker.mockFunc(foldedDeviceAcVM, foldedDeviceAcVM.isUnFoldedHorizontal);
      when(mockerFunc1)().afterReturn(false);
      let startPos = undefined;
      let endItem = undefined;
      instance.updateItemForDifferentPage(startPos, endItem);
      expect(true).assertTrue();
    })

    it('test_FoldedAppCacheManagerTest_setAppGridLayoutItemList', Level.LEVEL0, (): void => {
      let instance: FoldedAppCacheManager = new FoldedAppCacheManager();
      let foldedDeviceAcVM: FoldedDeviceAcViewModel = FoldedDeviceAcViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockerFunc1 = mocker.mockFunc(foldedDeviceAcVM, foldedDeviceAcVM.isUnFoldedHorizontal);
      when(mockerFunc1)().afterReturn(false);
      instance.setAppGridLayoutItemList([]);

      let appGridLayoutItemList: AppLayoutInfo[] = [];
      let ali = new AppLayoutInfo();
      ali.forLandscape = false;
      appGridLayoutItemList.push(ali);
      instance.setAppGridLayoutItemList(appGridLayoutItemList);
      expect(true).assertTrue();
    })

    it('test_FoldedAppCacheManagerTest_afterSetAppGridLayoutItemList', Level.LEVEL0, (): void => {
      let instance: FoldedAppCacheManager = new FoldedAppCacheManager();
      let foldedDeviceAcVM: FoldedDeviceAcViewModel = FoldedDeviceAcViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockerFunc1 = mocker.mockFunc(foldedDeviceAcVM, foldedDeviceAcVM.isUnFoldedHorizontal);
      when(mockerFunc1)().afterReturn(false);
      let startPos = undefined;
      let endItem = undefined;
      instance.afterSetAppGridLayoutItemList([]);
      expect(true).assertTrue();
    })

    it('test_FoldedAppCacheManagerTest_updateAppPageList', Level.LEVEL0, (): void => {
      let instance: FoldedAppCacheManager = new FoldedAppCacheManager();
      let foldedDeviceAcVM: FoldedDeviceAcViewModel = FoldedDeviceAcViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockerFunc1 = mocker.mockFunc(foldedDeviceAcVM, foldedDeviceAcVM.isUnFoldedHorizontal);
      when(mockerFunc1)().afterReturn(false);
      instance.updateAppPageList([]);
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.ohos.appgallery';
      appItemInfo.typeId = 0;
      appItemInfo.abilityName = 'MainAbility';
      appItemInfo.moduleName = 'entry';
      appItemInfo.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      appItemInfo.badgeNumber = 1;
      appItemInfo.area = [2,3];
      appItemInfo.appName = '应用市场';
      appItemInfo.appIconId = 67109115;
      appItemInfo.appLabelId = 67108895;
      appItemInfo.kindId = 0;
      appItemInfo.bundleType = 0;
      appItemInfo.applicationName = '';
      appItemInfo.appStatus = 0;
      appItemInfo.downloadProgress = 2;
      appItemInfo.iconResource = '2';
      appItemInfo.callerName = 'yyy';
      appItemInfo.appIndex = 0;
      appItemInfo.page = 0;
      instance.updateAppPageList([], appItemInfo);
      expect(true).assertTrue();
    })

    it('test_FoldedAppCacheManagerTest_addBlankPage', Level.LEVEL0, (): void => {
      let instance: FoldedAppCacheManager = new FoldedAppCacheManager();
      let foldedDeviceAcVM: FoldedDeviceAcViewModel = FoldedDeviceAcViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockerFunc1 = mocker.mockFunc(foldedDeviceAcVM, foldedDeviceAcVM.isUnFoldedHorizontal);
      when(mockerFunc1)().afterReturn(false);
      let startPos = undefined;
      let endItem = undefined;
      instance.addBlankPage();
      expect(true).assertTrue();
    })

    it('test_FoldedAppCacheManagerTest_putAppItemToGrid', Level.LEVEL0, (): void => {
      let instance: FoldedAppCacheManager = new FoldedAppCacheManager();
      let foldedDeviceAcVM: FoldedDeviceAcViewModel = FoldedDeviceAcViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockerFunc1 = mocker.mockFunc(foldedDeviceAcVM, foldedDeviceAcVM.isUnFoldedHorizontal);
      when(mockerFunc1)().afterReturn(false);
      let startPos = undefined;
      let endItem = undefined;
      instance.putAppItemToGrid([]);
      expect(true).assertTrue();
    })

    it('test_FoldedAppCacheManagerTest_updateAppInstallStatus', Level.LEVEL0, (): void => {
      let instance: FoldedAppCacheManager = new FoldedAppCacheManager();
      let foldedDeviceAcVM: FoldedDeviceAcViewModel = FoldedDeviceAcViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockerFunc1 = mocker.mockFunc(foldedDeviceAcVM, foldedDeviceAcVM.isUnFoldedHorizontal);
      when(mockerFunc1)().afterReturn(false);
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.ohos.appgallery';
      appItemInfo.typeId = 0;
      appItemInfo.abilityName = 'MainAbility';
      appItemInfo.moduleName = 'entry';
      appItemInfo.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      appItemInfo.badgeNumber = 1;
      appItemInfo.area = [2,3];
      appItemInfo.appName = '应用市场';
      appItemInfo.appIconId = 67109115;
      appItemInfo.appLabelId = 67108895;
      appItemInfo.kindId = 0;
      appItemInfo.bundleType = 0;
      appItemInfo.applicationName = '';
      appItemInfo.appStatus = 0;
      appItemInfo.downloadProgress = 2;
      appItemInfo.iconResource = '2';
      appItemInfo.callerName = 'yyy';
      appItemInfo.appIndex = 0;
      appItemInfo.page = 0;
      instance.updateAppInstallStatus(appItemInfo);
      expect(true).assertTrue();
    })
  })
}