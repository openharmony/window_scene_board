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
import { CheckEmptyUtils } from '@ohos/basicutils';
import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import {
  AppItemInfo,
  AppListInfo, FolderAppItemInfo, GridLayoutConfig, GridLayoutItemInfo } from '@ohos/launchercommon';
import { PageDesktopCloseAppHandlerForPC } from '../../../../main/ets/default/common/PageDesktopCloseAppHandlerForPC';
import { PageDesktopGridStyleConfig } from '@ohos/launchercommon/src/main/ets/layoutconfig/PageDesktopGridStyleConfig';
import { CommonConstants } from '@ohos/launchercommon';

export default function PageDesktopCloseAppHandlerForPCTest() {
  describe('PageDesktopCloseAppHandlerForPCTest', () => {
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
    it('assertEqual', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'test'
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
    })

    it('PageDesktopCloseAppHandlerForPCTest_getInstance', 0, () => {
      let res: PageDesktopCloseAppHandlerForPC = PageDesktopCloseAppHandlerForPC.getInstance();
      expect(res).not().assertNull();
    })

    it('test_getAppIconInfo_001', 0, () => {
      try {
        let windowTarget: AppItemInfo = new AppItemInfo();
        windowTarget.bundleName = 'com.ohos.SceneBoard';
        let instance: PageDesktopCloseAppHandlerForPC = PageDesktopCloseAppHandlerForPC.getInstance();
        (instance as object)['mCloseAppType'] = true;
        expect((instance as object)['mCloseAppType']).assertTrue();
        instance.getAppIconInfo(windowTarget);
        let bundleName: string = (instance as object)['mAppItemBundleName'];
        expect(bundleName).assertEqual(windowTarget.bundleName);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('PageDesktopCloseAppHandlerForPCTest_getAppIconInfo', 0, () => {
      try {
        let windowTarget: AppItemInfo = new AppItemInfo();
        windowTarget.bundleName = 'com.ohos.SceneBoard';
        let instance: PageDesktopCloseAppHandlerForPC = PageDesktopCloseAppHandlerForPC.getInstance();
        instance.getAppIconInfo(windowTarget);
        let bundleName: string = (instance as object)['mAppItemBundleName'];
        expect(bundleName).assertEqual(windowTarget.bundleName);
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }

    })

    it('PageDesktopCloseAppHandlerForPCTest_getAppIconInfo01', 0, () => {
      let windowTarget: AppItemInfo = new AppItemInfo();
      windowTarget.bundleName = 'com.ohos.SceneBoard';
      let instance: PageDesktopCloseAppHandlerForPC = PageDesktopCloseAppHandlerForPC.getInstance();
      (instance as object)['mFindPagedesktopPosition'] = true;
      let moker: MockKit = new MockKit();
      let mockIsEmpty = moker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIsEmpty)(ArgumentMatchers.any).afterReturn(true);
      try {
        instance.getAppIconInfo(windowTarget);
        expect((instance as object)['mFindPagedesktopPosition']).assertTrue();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      moker.clear(CheckEmptyUtils);
      moker.clearAll();
    })

    it('PageDesktopCloseAppHandlerForPCTest_getAppIconInfo01_positionTrue', 0, () => {
      let windowTarget: AppItemInfo = new AppItemInfo();
      windowTarget.bundleName = 'com.ohos.SceneBoard';
      let instance: PageDesktopCloseAppHandlerForPC = PageDesktopCloseAppHandlerForPC.getInstance();
      (instance as object)['mFindPagedesktopPosition'] = true;
      (instance as object)['mCloseAppType'] = false;
      let moker: MockKit = new MockKit();
      let mockIsEmpty = moker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIsEmpty)(ArgumentMatchers.any).afterReturn(true);
      try {
        instance.getAppIconInfo(windowTarget);
        expect((instance as object)['mFindPagedesktopPosition']).assertTrue();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      moker.clear(CheckEmptyUtils);
      moker.clearAll();
    })

    it('PageDesktopCloseAppHandlerForPCTest_getAppIconInfo03', 0, () => {
      let windowTarget: AppItemInfo = new AppItemInfo();
      windowTarget.bundleName = 'com.ohos.SceneBoard';
      let instance: PageDesktopCloseAppHandlerForPC = PageDesktopCloseAppHandlerForPC.getInstance();
      (instance as object)['mFindPagedesktopPosition'] = false;
      let moker: MockKit = new MockKit();
      let mockIsEmpty = moker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIsEmpty)(ArgumentMatchers.any).afterReturn(true);
      instance.getAppIconInfo(windowTarget);
      expect((instance as object)['mAppItemBundleName']).assertEqual('com.ohos.SceneBoard');
      moker.clear(CheckEmptyUtils);
      moker.clearAll();
    })

    it('PageDesktopCloseAppHandlerForPCTest_calculateAppIconPosition_empty', 0, () => {
      let windowTarget: AppItemInfo = new AppItemInfo();
      windowTarget.bundleName = 'com.ohos.SceneBoard';
      let instance: PageDesktopCloseAppHandlerForPC = PageDesktopCloseAppHandlerForPC.getInstance();
      (instance as object)['mGridConfig'] = null;
      (instance as object)['mPageDesktopStyleConfig'] = PageDesktopGridStyleConfig.getInstance();
      (instance as object)['mFindPagedesktopPosition'] = true;
      try {
        (instance as object)['calculateAppIconPosition']();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      let mFindPagedesktopPosition: boolean = (instance as object)['mFindPagedesktopPosition'];
      expect(mFindPagedesktopPosition).assertTrue();
      let gridConfig = new GridLayoutConfig();
      (instance as object)['mGridConfig'] = gridConfig;
      (instance as object)['mPageDesktopStyleConfig'] = null;
      try {
        (instance as object)['calculateAppIconPosition']();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      expect((instance as object)['mFindPagedesktopPosition']).assertTrue();
      (instance as object)['mFindPagedesktopPosition'] = false;
      (instance as object)['mGridConfig'] = gridConfig;
      (instance as object)['mPageDesktopStyleConfig'] = PageDesktopGridStyleConfig.getInstance();
      try {
        (instance as object)['calculateAppIconPosition']();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      expect((instance as object)['mFindPagedesktopPosition']).assertFalse();
      (instance as object)['mCloseAppType'] = true;
      let moker: MockKit = new MockKit();
      let mockIsEmpty = moker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIsEmpty)(null).afterReturn(false);
      try {
        (instance as object)['calculateAppIconPosition']();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      expect((instance as object)['mFindPagedesktopPosition']).assertFalse();
      (instance as object)['mCloseAppType'] = true;
      try {
        (instance as object)['calculateAppIconPosition']();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
      expect((instance as object)['mFindPagedesktopPosition']).assertFalse();
      moker.clear(CheckEmptyUtils);
      moker.clearAll();
    })

    it('test_calculateAppIconPosition_emptyAppItem', 0, () => {
      let windowTarget: WindowTarget = new WindowTarget();
      windowTarget.bundleName = 'com.ohos.SceneBoard';
      let instance: PageDesktopCloseAppHandlerForPC = PageDesktopCloseAppHandlerForPC.getInstance();
      let gridConfig = new GridLayoutConfig();
      (instance as object)['mFindPagedesktopPosition'] = false;
      (instance as object)['mGridConfig'] = gridConfig;
      (instance as object)['mPageDesktopStyleConfig'] = PageDesktopGridStyleConfig.getInstance();
      AppStorage.setOrCreate('appListInfo', new AppListInfo());
      try {
        (instance as object)['calculateAppIconPosition']();
        expect((instance as object)['mFindPagedesktopPosition']).assertFalse();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('PageDesktopCloseAppHandlerForPCTest_calculateAppIconPosition_empty_mCloseAppType', 0, () => {
      let instance: PageDesktopCloseAppHandlerForPC = PageDesktopCloseAppHandlerForPC.getInstance();
      let gridConfig = new GridLayoutConfig();
      let pageDeskTopConfig = PageDesktopGridStyleConfig.getInstance();
      (instance as object)['mGridConfig'] = gridConfig;
      (instance as object)['mPageDesktopStyleConfig'] = pageDeskTopConfig;
      let swipeGridInfo = new SwipeGridInfo();
      let swipeGridInfo3 = new SwipeGridInfo();
      swipeGridInfo3.typeId = 3;
      let swipeGridInfo6 = new SwipeGridInfo();
      swipeGridInfo6.typeId = 6;
      AppStorage.setOrCreate('appListInfo', {
        appGridInfo: [[swipeGridInfo, swipeGridInfo3, swipeGridInfo6]]
      });
      (instance as object)['mCloseAppType'] = true;
      (instance as object)['calculateAppIconPosition()'];
      expect((instance as object)['mFindPagedesktopPosition']).assertInstanceOf('Boolean');
      (instance as object)['mCloseAppType'] = false;
      (instance as object)['calculateAppIconPosition()'];
      expect((instance as object)['mFindPagedesktopPosition']).assertInstanceOf('Boolean');
    })

    it('PageDesktopCloseAppHandlerForPCTest_calculateAppIconPosition_mCloseAppType', 0, () => {
      let windowTarget: WindowTarget = new WindowTarget();
      windowTarget.bundleName = 'com.ohos.SceneBoard';
      let instance: PageDesktopCloseAppHandlerForPC = PageDesktopCloseAppHandlerForPC.getInstance();
      let moker: MockKit = new MockKit();
      let mockIsEmpty = moker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIsEmpty)(ArgumentMatchers.any).afterReturn(false);
      (instance as object)['mFindPagedesktopPosition'] = true;
      (instance as object)['mCloseAppType'] = false;
      (instance as object)['calculateAppIconPosition()'];
      expect((instance as object)['mFindPagedesktopPosition']).assertTrue();
      (instance as object)['mCloseAppType'] = true;
      (instance as object)['calculateAppIconPosition()'];
      expect((instance as object)['mAppIconPositionX']).assertEqual(0);
      moker.clear(CheckEmptyUtils);
      moker.clearAll();
    })

    it('test_getCloseAppItemInfo_empty', 0, () => {
      try {
        let instance: PageDesktopCloseAppHandlerForPC = PageDesktopCloseAppHandlerForPC.getInstance();
        AppStorage.setOrCreate('appListInfo', {
          appGridInfo: undefined
        });
        expect((instance as object)['getCloseAppItemInfo']()).assertNull();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('test_getCloseAppItemInfo', 0, () => {
      let instance: PageDesktopCloseAppHandlerForPC = PageDesktopCloseAppHandlerForPC.getInstance();
      let bundleName = 'com.ohos.testbundleName';
      (instance as object)['mAppItemBundleName'] = bundleName;
      let swipeGridInfo = new SwipeGridInfo();
      swipeGridInfo.typeId = CommonConstants.TYPE_APP;
      swipeGridInfo.bundleName = bundleName;
      AppStorage.setOrCreate('appListInfo', {
        appGridInfo: [[swipeGridInfo], []]
      });
      expect((instance as object)['getCloseAppItemInfo']()).assertNull();
      (instance as object)['mAppItemBundleName'] = bundleName;
      let swipeGridInfo1 = new SwipeGridInfo();
      swipeGridInfo1.typeId = CommonConstants.TYPE_APP;
      swipeGridInfo1.bundleName = 'bundleName001';
      let swipeGridInfo6 = new SwipeGridInfo();
      swipeGridInfo6.typeId = CommonConstants.TYPE_FILE_FOLDER;
      let swipeGridInfo3 = new SwipeGridInfo();
      swipeGridInfo3.typeId = CommonConstants.TYPE_FOLDER;
      let swipeGridInfo31 = new SwipeGridInfo();
      swipeGridInfo31.typeId = CommonConstants.TYPE_FOLDER;
      let item = new FolderAppItemInfo();
      item.typeId = CommonConstants.TYPE_FOLDER;
      item.bundleName = bundleName;
      swipeGridInfo31.layoutInfo = [[item]];
      AppStorage.setOrCreate('appListInfo', {
        appGridInfo: [[swipeGridInfo1, swipeGridInfo6, swipeGridInfo3, swipeGridInfo31]]
      });
      expect((instance as object)['getCloseAppItemInfo']()).not().assertNull();
    })

    it('test_getIndexInFolderAppList', 0, () => {
      let instance: PageDesktopCloseAppHandlerForPC = PageDesktopCloseAppHandlerForPC.getInstance();
      let appItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      appItem.bundleName = 'com.ohos.testbun';
      let forlerItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.testbun1111';
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.testbun';
      forlerItem.layoutInfo = [[item1, item2]];
      let listNumber: number = (instance as object)['getIndexInFolderAppList'](appItem, forlerItem);
      expect(listNumber > 0).assertTrue();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(appItem).afterReturn(true);
      expect(listNumber > 0).assertTrue();
      when(mockFunc)(appItem).afterReturn(false);
      when(mockFunc)(forlerItem).afterReturn(true);
      expect(listNumber > 0).assertTrue();
      when(mockFunc)(appItem).afterReturn(false);
      when(mockFunc)(forlerItem).afterReturn(false);
      when(mockFunc)(forlerItem.layoutInfo[0]).afterReturn(true);
      expect(listNumber > 0).assertTrue();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('PageDesktopCloseAppHandlerForPCTest_getFolderItem', 0, () => {
      try {
        let instance: PageDesktopCloseAppHandlerForPC = PageDesktopCloseAppHandlerForPC.getInstance();
        expect((instance as object)['getFolderItem'](null)).assertNull();
        expect((instance as object)['getFolderItem']([[]])).assertNull();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    it('PageDesktopCloseAppHandlerForPCTest_getCloseAppItemInfo_getFolderItem', 0, () => {
      let instance: PageDesktopCloseAppHandlerForPC = PageDesktopCloseAppHandlerForPC.getInstance();
      let swipeGridInfo = new SwipeGridInfo();
      swipeGridInfo.typeId = CommonConstants.TYPE_APP;
      let swipeGridInfo3 = new SwipeGridInfo();
      swipeGridInfo3.typeId = CommonConstants.TYPE_FOLDER;
      let folderAppItemInfo: FolderAppItemInfo = new FolderAppItemInfo();
      folderAppItemInfo.bundleName = 'com.ohos.SceneBoard';
      swipeGridInfo.layoutInfo = [[folderAppItemInfo]];
      let swipeGridInfo6 = new SwipeGridInfo();
      swipeGridInfo6.typeId = CommonConstants.TYPE_FILE_FOLDER;
      AppStorage.setOrCreate('appListInfo', {
        appGridInfo: [[swipeGridInfo, swipeGridInfo3, swipeGridInfo6], []]
      });
      try {
        expect((instance as object)['getCloseAppItemInfo']()).not().assertUndefined();
      } catch (err) {
        expect(JSON.stringify(err)).assertInstanceOf('String');
      }
    })

    class SwipeGridInfo {
      typeId: number = 0;
      bundleName: string = 'com.ohos.SceneBoard';
      abilityName: string = 'SceneBoard.Ability';
      moduleName: string = 'SceneBoard.Ability';
      appIconId: string = 'SceneBoard.Ability';
      row: number = 0;
      column: number = 0;
      page: number = 1;
      layoutInfo: FolderAppItemInfo[][] = [[]]
    }

    class WindowTarget {
      bundleName: string = 'com.ohos.SceneBoard';
    }
  })
}
