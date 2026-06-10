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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { GridLayoutItemInfo } from '@ohos/launchercommon'
import {
  DesktopAddItemInfo,
  SCBDesktopAddViewModel
} from '../../../../../../../main/ets/default/common/components/desktopaddapp/SCBDesktopAddViewModel'

export default function SCBDesktopAddViewModelTest() {
  describe('SCBDesktopAddViewModelTest', () => {
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

    it('getInstance_01', 0, () => {
      let instance: SCBDesktopAddViewModel = SCBDesktopAddViewModel.getInstance();
      expect(instance).not().assertNull();
    });

    it('closeDesktopAddDialog_01', 0, () => {
      let instance: SCBDesktopAddViewModel = SCBDesktopAddViewModel.getInstance();
      instance.closeDesktopAddDialog();
      expect(instance.desktopAddDialogShowInfo.isDesktopDialogShow).assertFalse();
    });

    it('refreshRemovedAppList_01', 0, () => {
      let instance: SCBDesktopAddViewModel = SCBDesktopAddViewModel.getInstance();
      let newRemoveAppList: GridLayoutItemInfo[] = [];
      newRemoveAppList.push(new GridLayoutItemInfo());
      instance.refreshRemovedAppList(newRemoveAppList);
      expect(instance.getRemovedAppList().length).not().assertEqual(0);
    });

    it('refreshContainAppList_01', 0, () => {
      let instance: SCBDesktopAddViewModel = SCBDesktopAddViewModel.getInstance();
      let newContainAppList: GridLayoutItemInfo[] = [];
      newContainAppList.push(new GridLayoutItemInfo());
      instance.refreshContainAppList(newContainAppList);
      expect(instance.getContainAppList().length).not().assertEqual(0);
    });

    it('refreshAllAppList_01', 0, () => {
      let instance: SCBDesktopAddViewModel = SCBDesktopAddViewModel.getInstance();
      instance.refreshAllAppList();
      expect(instance).not().assertNull();
    });

    it('initQuerySelectItem_01', 0, () => {
      let instance: SCBDesktopAddViewModel = SCBDesktopAddViewModel.getInstance();
      instance.initQuerySelectItem();
      expect(instance).not().assertNull();
    });

    it('getRemovedAppList_01', 0, () => {
      let instance: SCBDesktopAddViewModel = SCBDesktopAddViewModel.getInstance();
      instance.getRemovedAppList();
      expect(instance).not().assertNull();
    });

    it('getContainAppList_01', 0, () => {
      let instance: SCBDesktopAddViewModel = SCBDesktopAddViewModel.getInstance();
      instance.getContainAppList();
      expect(instance).not().assertNull();
    });

    it('showToast_01', 0, () => {
      let instance: SCBDesktopAddViewModel = SCBDesktopAddViewModel.getInstance();
      instance.showToast("app.string.desktop_add");
      expect(instance).not().assertNull();
    });

    it('getColumnsTemplate_01', 0, () => {
      let instance: SCBDesktopAddViewModel = SCBDesktopAddViewModel.getInstance();
      let columnTemplate = instance.getColumnsTemplate()
      expect(columnTemplate.length).not().assertEqual(0);
    });

    it('getDialogGridColumns_01', 0, () => {
      let instance: SCBDesktopAddViewModel = SCBDesktopAddViewModel.getInstance();
      let columns = instance.getDialogGridColumns()
      expect(columns).assertEqual(4);
    });

    it('getContainsItemList_01', 0, () => {
      let instance: SCBDesktopAddViewModel = SCBDesktopAddViewModel.getInstance();
      let containsItemList = instance.getContainsItemList()
      expect(instance).not().assertNull();
    });

    it('getAllAppsBundleName_01', 0, () => {
      let instance: SCBDesktopAddViewModel = SCBDesktopAddViewModel.getInstance();
      let allAppBundleName = instance.getAllAppsBundleName()
      expect(instance).not().assertNull();
    });

    it('getRecommendedCategoryMap_01', 0, () => {
      let instance: SCBDesktopAddViewModel = SCBDesktopAddViewModel.getInstance();
      let appList: DesktopAddItemInfo[] = [];
      let catIdMap = instance.getRecommendedCategoryMap(appList);
      expect(instance).not().assertNull();
    });

    it('getAllDesktopAddItemInfos_01', 0, () => {
      let instance: SCBDesktopAddViewModel = SCBDesktopAddViewModel.getInstance();
      let containsList: GridLayoutItemInfo[] = [];
      let catIdMap = instance.getAllDesktopAddItemInfos(containsList, true);
      expect(instance).not().assertNull();
    });

    it('findApp_01', 0, () => {
      let instance: SCBDesktopAddViewModel = SCBDesktopAddViewModel.getInstance();
      let appList: GridLayoutItemInfo[] = [];
      let bundleName: string = "com.ohos.camera";
      let ret = instance.findApp(appList, bundleName);
      expect(instance).not().assertNull();
    });

    it('getAddIconInfo_01', 0, () => {
      let instance: SCBDesktopAddViewModel = SCBDesktopAddViewModel.getInstance();
      let addInfo = instance.getAddIconInfo();
      expect(instance).not().assertNull();
    });

    it('getLastCheckedApp_01', 0, () => {
      let instance: SCBDesktopAddViewModel = SCBDesktopAddViewModel.getInstance();
      let checkedAppList: GridLayoutItemInfo[] = [];
      let lastApp = instance.getLastCheckedApp(checkedAppList);
      expect(instance).not().assertNull();
    });

    it('insertAddIcon_01', 0, () => {
      let instance: SCBDesktopAddViewModel = SCBDesktopAddViewModel.getInstance();
      let addInfo = instance.getAddIconInfo();
      let checkedAppInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      instance.insertAddIcon(checkedAppInfo, addInfo);
      expect(instance).not().assertNull();
    });

    it('insertGridLayout_01', 0, () => {
      let instance: SCBDesktopAddViewModel = SCBDesktopAddViewModel.getInstance();
      let checkedAppInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      instance.insertGridLayout(checkedAppInfo);
      expect(instance).not().assertNull();
    });

    it('setDesktopAddItemInfoCatId_01', 0, () => {
      let sCBDesktopAddViewModel: SCBDesktopAddViewModel = new SCBDesktopAddViewModel();
      let appList: DesktopAddItemInfo[] = [];
      (sCBDesktopAddViewModel as object)['setDesktopAddItemInfoCatId'](appList);
      expect(sCBDesktopAddViewModel).not().assertNull();
    });

    it('getAllApps_01', 0, () => {
      let sCBDesktopAddViewModel: SCBDesktopAddViewModel = new SCBDesktopAddViewModel();
      let appList: GridLayoutItemInfo[] = (sCBDesktopAddViewModel as object)['getAllApps']();
      expect(appList.length).not().assertEqual(0);
    });

    it('getPresetApps_01', 0, () => {
      let sCBDesktopAddViewModel: SCBDesktopAddViewModel = new SCBDesktopAddViewModel();
      let presetAppList: string[] = (sCBDesktopAddViewModel as object)['getPresetApps']();
      expect(presetAppList.length).not().assertEqual(0);
    });

    it('addOtherApp_01', 0, () => {
      let sCBDesktopAddViewModel: SCBDesktopAddViewModel = new SCBDesktopAddViewModel();
      let appList: DesktopAddItemInfo[] = [];
      let containsList: GridLayoutItemInfo[] = [];
      (sCBDesktopAddViewModel as object)['addOtherApp'](appList, containsList);
      expect(sCBDesktopAddViewModel).not().assertNull();
    });

    it('checkApps_01', 0, () => {
      let sCBDesktopAddViewModel: SCBDesktopAddViewModel = new SCBDesktopAddViewModel();
      let appList: DesktopAddItemInfo[] = [];
      let containsList: GridLayoutItemInfo[] = [];
      (sCBDesktopAddViewModel as object)['checkApps'](appList, containsList);
      expect(sCBDesktopAddViewModel).not().assertNull();
    });

    it('categorizeApps_01', 0, () => {
      let sCBDesktopAddViewModel: SCBDesktopAddViewModel = new SCBDesktopAddViewModel();
      let appList: DesktopAddItemInfo[] = [];
      let containsList: GridLayoutItemInfo[] = [];
      let recommendedCategories : Map<number, string> = new Map<number, string>();
      let includeOthers: boolean = true;
      (sCBDesktopAddViewModel as object)['checkApps'](appList, containsList, recommendedCategories, includeOthers);
      expect(sCBDesktopAddViewModel).not().assertNull();
    });

  })
}
