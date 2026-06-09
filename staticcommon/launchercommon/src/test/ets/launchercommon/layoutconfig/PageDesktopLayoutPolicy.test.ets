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
import {
  PageDesktopLayoutConfig,
  CommonConstants,
  RdbStoreManager,
  GetLayoutInfoFromConfig
} from '../../../../main/ets/TsIndex';
import { DefaultDesktopLayoutInfo } from '../../../../main/ets/TsIndex';
import GridLayoutItemInfo from '../../../../main/ets/bean/GridLayoutItemInfo';
import { AppItemInfo } from '../../../../main/ets/bean/AppItemInfo';

const COMMON_FEATURE_NAME: string = 'featureCommon';

export default function PageDesktopLayoutPolicyTest() {
  describe('PageDesktopLayoutPolicyTest', () => {
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

    it('PageDesktopLayoutConfigTest_getGridLayoutInfo', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const config = PageDesktopLayoutConfig.getInstance();
      expect(config.getGridLayoutInfo().layoutDescription.column).assertEqual(4);
    });

    it('PageDesktopLayoutConfigTest_getConfigFileAbsPath', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const config = PageDesktopLayoutConfig.getInstance();
      expect(config.getConfigFileAbsPath()).assertContain('.json');
    });

    it('PageDesktopLayoutConfigTest_updateGridLayoutInfo', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const config = PageDesktopLayoutConfig.getInstance();
      config.deleteConfig();
      config.updateGridLayoutInfo(DefaultDesktopLayoutInfo.getDefaultLayoutInfo());
      expect(config.getGridLayoutInfo().layoutInfo.length).assertEqual(0);
    });

    it('PageDesktopLayoutConfigTest_updateLayoutDescription', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const config = PageDesktopLayoutConfig.getInstance();
      config.deleteConfig();
      config.updateLayoutDescription(DefaultDesktopLayoutInfo.getDefaultLayoutInfo());
      expect(config.mGridLayoutInfo.layoutDescription.row).assertEqual(6);
      expect(config.getGridLayoutInfo().layoutDescription.column).assertEqual(4);
    });

    it('test_getGridLayoutInfo', 0, () => {
      const PageDesktopLayoutConfigInstance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      const gridLayoutInfo: DefaultDesktopLayoutInfo = PageDesktopLayoutConfigInstance.getGridLayoutInfo();
      expect(gridLayoutInfo).assertEqual(PageDesktopLayoutConfigInstance.getGridLayoutInfo());
    })

    it('test_loadPersistConfig', 0, async () => {
      const PageDesktopLayoutConfigInstance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      expect(await PageDesktopLayoutConfigInstance.loadPersistConfig() === undefined).assertTrue();
    })

    it('test_filterDbListByInstalled01', 0, async () => {
      const pageDesktopLayoutConfigInstance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();

      let appInfos: GridLayoutItemInfo[] = [];

      let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let appInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.clock';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      item1.page = 4;
      item1.row = 2;
      item1.column = 1;
      item1.area = [1, 2, 3];
      item1.keyName = 'key-clock';
      item1.cardId = 22;
      item1.folderId = '1';
      item1.formStackId = '1';

      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = ' com.ohos.notepad';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      item2.page = 1;
      item2.row = 1;
      item2.column = 1;
      item2.area = [5, 2, 3];
      item2.keyName = 'notepad';
      item2.cardId = 11;
      item2.folderId = 'notepad_s';
      item2.formStackId = '1';

      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.typeId = CommonConstants.TYPE_ADD;
      item3.page = 1;
      item3.row = 1;
      item3.column = 1;
      item3.area = [1, 2, 3];
      item3.keyName = '1';
      item3.cardId = 2;
      item3.folderId = '1';
      item3.formStackId = '1';


      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.bundleName = 'com.dt.sceneboard';
      item4.typeId = CommonConstants.TYPE_ADD;
      item4.page = 1;
      item4.row = 1;
      item4.column = 1;
      item4.area = [1, 2, 3];
      item4.keyName = '1keyName';
      item4.cardId = 2;
      item4.folderId = '1';
      item4.formStackId = '1';

      appInfo1.layoutInfo = [[item1], [item2]];
      appInfo1.typeId = CommonConstants.TYPE_FOLDER;
      appInfo1.keyName = 'keyName0';
      appInfo1.page = 1;
      appInfo1.row = 1;
      appInfo1.column = 1;
      appInfo1.area = [1, 2, 3];
      appInfo1.keyName = '1';
      appInfo1.cardId = 2;
      appInfo1.folderId = '11112222';
      appInfo1.formStackId = '1';

      appInfo2.layoutInfo = [[item3], [item4]];
      appInfo2.typeId = CommonConstants.TYPE_CARD;
      appInfo2.keyName = 'keyName100';
      appInfo2.page = 1;
      appInfo2.row = 1;
      appInfo2.column = 1;
      appInfo2.area = [1, 2, 3];
      appInfo2.keyName = '1';
      appInfo2.cardId = 2;
      appInfo2.folderId = '1';
      appInfo2.formStackId = '1';
      appInfos.push(appInfo1);
      appInfos.push(appInfo2);

      const dbListByInstalled: GridLayoutItemInfo[] = await pageDesktopLayoutConfigInstance.filterDbListByInstalled(appInfos);
      expect(dbListByInstalled).not().assertNull();
    })

    it('test_filterDbListByInstalled02', 0, async () => {
      const pageDesktopLayoutConfigInstance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();

      let appInfos: GridLayoutItemInfo[] = [];

      let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      let appInfo2: GridLayoutItemInfo = new GridLayoutItemInfo();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      item1.page = 1;
      item1.row = 1;
      item1.column = 1;
      item1.area = [1, 2, 3];
      item1.keyName = '1';
      item1.cardId = 2;
      item1.folderId = 'folderId1';

      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.vmal';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      item2.page = 1;
      item2.row = 1;
      item2.column = 1;
      item2.area = [1, 2, 3];
      item2.keyName = '1';
      item2.cardId = 2000;
      item2.formStackId = 'formStackId1';

      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.typeId = CommonConstants.TYPE_ADD;
      item3.page = 1;
      item3.row = 1;
      item3.column = 1;
      item3.area = [1, 2, 3];
      item3.keyName = 'key__1';
      item3.cardId = 2;
      item3.folderId = '1';
      item3.formStackId = '1';

      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.bundleName = 'com.ohos.sceneboard';
      item4.typeId = CommonConstants.TYPE_ADD;
      item4.page = 1;
      item4.row = 1;
      item4.column = 1;
      item4.area = [1, 2, 3];
      item4.keyName = '1';
      item4.cardId = 2;
      item4.folderId = 'f1';
      item4.formStackId = 'st1';


      appInfo1.layoutInfo = [[item1], [item2]];
      appInfo1.typeId = CommonConstants.TYPE_FOLDER;
      appInfo1.keyName = 'a key here';
      appInfo1.page = 1;
      appInfo1.row = 1;
      appInfo1.column = 1;
      appInfo1.area = [1, 2, 3];
      appInfo1.keyName = '1';
      appInfo1.cardId = 2;
      appInfo1.folderId = '1';
      appInfo1.formStackId = '1';
      appInfo2.layoutInfo = [[item3], [item4]];
      appInfo2.typeId = CommonConstants.TYPE_CARD;
      appInfo2.keyName = 'folder name here';
      appInfo2.page = 1;
      appInfo2.row = 1;
      appInfo2.column = 1;
      appInfo2.area = [1, 2, 3];
      appInfo2.keyName = 'keyName1';
      appInfo2.cardId = 2;
      appInfo2.folderId = '1';
      appInfo2.formStackId = 'formStackId1';
      appInfos.push(appInfo1);
      appInfos.push(appInfo2);

      const dbListByInstalled: GridLayoutItemInfo[] = await pageDesktopLayoutConfigInstance.filterDbListByInstalled(appInfos);
      expect(dbListByInstalled).not().assertNull();
    })

    it('test_refreshLayoutAfterRecover', 0, async () => {
      const PageDesktopLayoutConfigInstance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      expect(await PageDesktopLayoutConfigInstance.refreshLayoutAfterRecover() === undefined).assertTrue();
    })

    it('test_updateGridLayoutInfo', 0, () => {
      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      try {
        instance.updateGridLayoutInfo(undefined);

        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.bundleName = 'com.ohos.sceneboard.dt';
        item1.typeId = CommonConstants.TYPE_FOLDER;
        item1.page = 1;
        item1.row = 1;
        item1.column = 1;
        item1.area = [1, 2, 3];
        item1.keyName = 'keyName1';
        item1.cardId = 2;
        item1.folderId = '1';
        item1.formStackId = '1';

        instance.updateGridLayoutInfo(item1);
      } catch (e) {
        expect(instance).not().assertNull();
      }
      expect(instance).not().assertNull();
    })

    it('test_initConfig', 0, () => {
      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();

      let mocker: MockKit = new MockKit();
      let manager = RdbStoreManager.getInstance();
      let mockFunc1: Function = mocker.mockFunc(manager, manager.querySettingsPageCount);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunc2: Function = mocker.mockFunc(manager, manager.queryGridLayoutInfo);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([]);

      instance.initConfig();
      expect(instance).not().assertNull();
      mocker.clear(manager);
      mocker.clearAll();
    })

    it('test_loadPersistConfig_0', 0, async (done: Function) => {
      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();

      let mocker: MockKit = new MockKit();
      let manager = RdbStoreManager.getInstance();
      let mockFunc1: Function = mocker.mockFunc(manager, manager.querySettingsPageCount);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(0);
      let mockFunc2: Function = mocker.mockFunc(manager, manager.queryGridLayoutInfo);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([]);

      let config = GetLayoutInfoFromConfig.getInstance();
      config['isFinishedFlag'] = true;

      let info = new DefaultDesktopLayoutInfo();
      info.layoutInfo = [];
      let mockFunc3: Function = mocker.mockFunc(config, config.getAllLayoutConfigFile);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(info);

      await instance.loadPersistConfig();
      instance.getGridLayoutInfo();

      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.wallet';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      item1.page = 1;
      item1.row = 1;
      item1.column = 1;
      item1.area = [1, 2, 3];
      item1.keyName = 'wallet_1';
      item1.cardId = 2;
      item1.folderId = '1';
      item1.formStackId = '1';

      let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      appInfo1.layoutInfo = [[item1]];
      appInfo1.typeId = CommonConstants.TYPE_FOLDER;
      appInfo1.keyName = 'wallet00';
      appInfo1.page = 1;
      appInfo1.row = 1;
      appInfo1.column = 1;
      appInfo1.area = [1, 2, 3];
      appInfo1.keyName = 'name_1';
      appInfo1.cardId = 2;
      appInfo1.folderId = '1';
      appInfo1.formStackId = '1';

      instance.updateGridLayoutInfo(appInfo1);
      expect(instance).not().assertNull();
      mocker.clear(manager);
      mocker.clear(config);
      mocker.clearAll();
      done();
    })

    it('test_checkAppList1', 0, () => {
      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.weather';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      item1.page = 1;
      item1.row = 1;
      item1.column = 1;
      item1.area = [1, 2, 3];
      item1.keyName = '1';
      item1.cardId = 22;
      item1.folderId = 'folderId1';
      item1.formStackId = '1';
      item1.layoutInfo = [[]];
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.openharmony.calculator';
      item2.typeId = CommonConstants.TYPE_CARD;
      item2.page = 2;
      item2.row = 1;
      item2.column = 1;
      item2.area = [1, 2, 3];
      item2.keyName = 'keyName1';
      item2.cardId = 22;
      item2.folderId = '1';
      item2.formStackId = '1';
      let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      appInfo1.layoutInfo = [[item1, item2]];
      appInfo1.typeId = CommonConstants.TYPE_FOLDER;
      appInfo1.keyName = 'keyName2334';
      appInfo1.page = 1;
      appInfo1.row = 1;
      appInfo1.column = 1;
      appInfo1.area = [1, 2, 3];
      appInfo1.keyName = 'keyName01';
      appInfo1.cardId = 2;
      appInfo1.folderId = '1';
      appInfo1.formStackId = '1';
      instance.updateGridLayoutInfo(appInfo1);
      try {
        instance['checkAppList']();
        expect(instance).not().assertNull();
      } catch (error) {
        expect(instance).assertThrowError('checkAppList error');
      }
    })

    it('test_bindAppAndFolder', 0, () => {
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.music';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      item1.page = 1;
      item1.row = 1;
      item1.column = 1;
      item1.area = [1, 2, 3];
      item1.keyName = '1';
      item1.cardId = 2;
      item1.folderId = '1';
      item1.formStackId = '1';
      item1.layoutInfo = [];

      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.calculator';
      item2.typeId = CommonConstants.TYPE_CARD;
      item2.page = 2;
      item2.row = 2;
      item2.column = 2;
      item2.area = [0, 3, 4];
      item2.keyName = 'key8888';
      item2.cardId = 22;
      item2.folderId = '2222';
      item2.formStackId = '1';

      let list: GridLayoutItemInfo[] = [];
      list.push(item1);
      list.push(item2);

      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      instance.mGridLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();

      instance['bindAppAndFolder']();
      expect(instance).not().assertNull();
    })

    it('test_complementAppInfo00', 0, () => {
      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      const appItem = new AppItemInfo();
      appItem.appName = 'appname';
      appItem.appIconId = 1;
      appItem.appLabelId = 2;
      appItem.bundleName = 'com.ohos.calculator';
      appItem.abilityName = 'abilityName app';
      appItem.moduleName = 'moduleName';
      appItem.typeId = CommonConstants.TYPE_APP;
      appItem.area = [2, 2, 4];
      appItem.page = 1;
      appItem.column = 2;
      appItem.kindId = 1;

      appItem.bundleType = 0;
      appItem.applicationName = 'calculator';
      appItem.downloadProgress = 1;
      appItem.appStatus = 0;
      appItem.iconResource = 'icon.png';
      appItem.callerName = 'callerName';
      appItem.applicationIconId = 1234;
      appItem.isUninstallAble = true;
      appItem.isSystemApp = false;
      appItem.keyName = 'key name';
      let layoutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      instance['complementAppInfo'](layoutItem, appItem);
      expect(layoutItem.bundleType).assertEqual(appItem.bundleType);
    })

    it('test_getAllLayoutConfigFile00', 0, async (done: Function) => {
      let ret = await PageDesktopLayoutConfig.getInstance()['getAllLayoutConfigFile']();
      expect(ret).not().assertNull();
      done();
    });
  })
}