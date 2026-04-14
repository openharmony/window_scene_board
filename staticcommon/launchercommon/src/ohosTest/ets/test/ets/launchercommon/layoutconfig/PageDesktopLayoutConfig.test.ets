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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import { PageDesktopLayoutConfig, CommonConstants, RdbStoreManager,
  GetLayoutInfoFromConfig,DesktopDataLoader,
  AppStatus,
  AppModel,
  launcherAbilityManager} from '../../../../../../main/ets/TsIndex'
import type ctx from '@ohos.app.ability.common';
import { ObjUtil } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { DefaultDesktopLayoutInfo } from '../../../../../../main/ets/TsIndex';
import GridLayoutItemInfo from '../../../../../../main/ets/bean/GridLayoutItemInfo';
import type GridLayoutItemBuilder from '../../../../../../main/ets/bean/GridLayoutItemBuilder';
import { AppItemInfo } from '../../../../../../main/ets/bean/AppItemInfo';
const COMMON_FEATURE_NAME: string = 'featureCommon';

export default function PageDesktopLayoutConfigTest() {
  describe('PageDesktopLayoutConfigTest', () => {
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

    it('test_getInstance', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      globalThis.PageDesktopLayoutConfigInstance = undefined;
      const pageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      expect(globalThis.PageDesktopLayoutConfigInstance).not().assertUndefined();
      expect(globalThis.PageDesktopLayoutConfigInstance).assertEqual(pageDesktopLayoutConfig);
    })

    it('test_persistConfig', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const pageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      const context = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
      if (ObjUtil.isValid(context)) {
        pageDesktopLayoutConfig.persistConfig();
        expect(pageDesktopLayoutConfig.isConfigExist()).assertTrue();
      } else {
        expect(context).assertUndefined();
      }
    })

    it('test_deleteConfig', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const pageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      // as config are loaded from db, delete it will do no harm
      const context = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
      if (ObjUtil.isValid(context)) {
        pageDesktopLayoutConfig.deleteConfig();
        expect(pageDesktopLayoutConfig.isConfigExist()).assertFalse();
      } else {
        expect(context).assertUndefined();
      }
    })
    it('PageDesktopLayoutConfigTest_getGridLayoutInfo', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const config = PageDesktopLayoutConfig.getInstance();
      expect(config.getGridLayoutInfo().layoutDescription.column).assertEqual(4);
    });

    it('PageDesktopLayoutConfigTest_getConfigLevel', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const config = PageDesktopLayoutConfig.getInstance();
      expect(config.getConfigLevel()).assertEqual(CommonConstants.LAYOUT_CONFIG_LEVEL_COMMON);
    });

    it('PageDesktopLayoutConfigTest_getConfigType', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const config = PageDesktopLayoutConfig.getInstance();
      expect(config.getConfigType()).assertEqual(CommonConstants.LAYOUT_CONFIG_TYPE_FUNCTION);
    });

    it('PageDesktopLayoutConfigTest_getConfigName', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const config = PageDesktopLayoutConfig.getInstance();
      expect(config.getConfigName()).assertEqual(PageDesktopLayoutConfig.GRID_LAYOUT_INFO);
    });

    it('PageDesktopLayoutConfigTest_getFeatureName', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const config = PageDesktopLayoutConfig.getInstance();
      expect(config.getFeatureName()).assertEqual(COMMON_FEATURE_NAME);
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
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      item1.page = 1;
      item1.row = 1;
      item1.column = 1;
      item1.area = [1, 2, 3];
      item1.keyName = '1';
      item1.cardId = '2';
      item1.folderId = '1';
      item1.formStackId = '1';

      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      item2.page = 1;
      item2.row = 1;
      item2.column = 1;
      item2.area = [1, 2, 3];
      item2.keyName = '1';
      item2.cardId = '2';
      item2.folderId = '1';
      item2.formStackId = '1';

      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.typeId = CommonConstants.TYPE_ADD;
      item3.page = 1;
      item3.row = 1;
      item3.column = 1;
      item3.area = [1, 2, 3];
      item3.keyName = '1';
      item3.cardId = '2';
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
      item4.cardId = '2';
      item4.folderId = '1';
      item4.formStackId = '1';

      appInfo1.layoutInfo = [[item1],[item2]];
      appInfo1.typeId = CommonConstants.TYPE_FOLDER;
      appInfo1.keyName = 'keyName0';
      appInfo1.page = 1;
      appInfo1.row = 1;
      appInfo1.column = 1;
      appInfo1.area = [1, 2, 3];
      appInfo1.keyName = '1';
      appInfo1.cardId = '2';
      appInfo1.folderId = '1';
      appInfo1.formStackId = '1';

      appInfo2.layoutInfo = [[item3],[item4]];
      appInfo2.typeId = CommonConstants.TYPE_CARD;
      appInfo2.keyName = 'folder0';
      appInfo2.page = 1;
      appInfo2.row = 1;
      appInfo2.column = 1;
      appInfo2.area = [1, 2, 3];
      appInfo2.keyName = '1';
      appInfo2.cardId = '2';
      appInfo2.folderId = '1';
      appInfo2.formStackId = '1';
      appInfos.push(appInfo1);
      appInfos.push(appInfo2);

      const dbListByInstalled: GridLayoutItemInfo[] =
        await pageDesktopLayoutConfigInstance.filterDbListByInstalled(appInfos, appInfos as object[] as AppItemInfo[], false);
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
      item1.cardId = '2';
      item1.folderId = '1';
      item1.formStackId = '1';

      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_FOLDER;
      item2.page = 1;
      item2.row = 1;
      item2.column = 1;
      item2.area = [1, 2, 3];
      item2.keyName = '1';
      item2.cardId = '2';
      item2.folderId = '1';
      item2.formStackId = '1';

      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.typeId = CommonConstants.TYPE_ADD;
      item3.page = 1;
      item3.row = 1;
      item3.column = 1;
      item3.area = [1, 2, 3];
      item3.keyName = '1';
      item3.cardId = '2';
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
      item4.cardId = '2';
      item4.folderId = '1';
      item4.formStackId = '1';


      appInfo1.layoutInfo = [[item1],[item2]];
      appInfo1.typeId = CommonConstants.TYPE_FOLDER;
      appInfo1.keyName = 'keyName0';
      appInfo1.page = 1;
      appInfo1.row = 1;
      appInfo1.column = 1;
      appInfo1.area = [1, 2, 3];
      appInfo1.keyName = '1';
      appInfo1.cardId = '2';
      appInfo1.folderId = '1';
      appInfo1.formStackId = '1';
      appInfo2.layoutInfo = [[item3],[item4]];
      appInfo2.typeId = CommonConstants.TYPE_CARD;
      appInfo2.keyName = 'folder0';
      appInfo2.page = 1;
      appInfo2.row = 1;
      appInfo2.column = 1;
      appInfo2.area = [1, 2, 3];
      appInfo2.keyName = '1';
      appInfo2.cardId = '2';
      appInfo2.folderId = '1';
      appInfo2.formStackId = '1';
      appInfos.push(appInfo1);
      appInfos.push(appInfo2);

      const dbListByInstalled: GridLayoutItemInfo[] =
        await pageDesktopLayoutConfigInstance.filterDbListByInstalled(appInfos, appInfos as object[] as AppItemInfo[], false);
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
        item1.bundleName = 'com.ohos.sceneboard';
        item1.typeId = CommonConstants.TYPE_FOLDER;
        item1.page = 1;
        item1.row = 1;
        item1.column = 1;
        item1.area = [1, 2, 3];
        item1.keyName = '1';
        item1.cardId = '2';
        item1.folderId = '1';
        item1.formStackId = '1';

        instance.updateGridLayoutInfo(item1);
      } catch (e) {
        expect(instance).not().assertNull();
      }
      expect(instance).not().assertNull();
    })

    it('test_loadPersistConfig', 0, () => {
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
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      item1.page = 1;
      item1.row = 1;
      item1.column = 1;
      item1.area = [1, 2, 3];
      item1.keyName = '1';
      item1.cardId = '2';
      item1.folderId = '1';
      item1.formStackId = '1';

      let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      appInfo1.layoutInfo = [[item1]];
      appInfo1.typeId = CommonConstants.TYPE_FOLDER;
      appInfo1.keyName = 'keyName0';
      appInfo1.page = 1;
      appInfo1.row = 1;
      appInfo1.column = 1;
      appInfo1.area = [1, 2, 3];
      appInfo1.keyName = '1';
      appInfo1.cardId = '2';
      appInfo1.folderId = '1';
      appInfo1.formStackId = '1';

      instance.updateGridLayoutInfo(appInfo1);
      expect(instance).not().assertNull();
      mocker.clear(manager);
      mocker.clear(config);
      mocker.clearAll();
      done();
    })

    it('test_checkAppList', 0, () => {
      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      item1.page = 1;
      item1.row = 1;
      item1.column = 1;
      item1.area = [1, 2, 3];
      item1.keyName = '1';
      item1.cardId = '2';
      item1.folderId = '1';
      item1.formStackId = '1';
      item1.layoutInfo = [[]];
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.calculator';
      item2.typeId = CommonConstants.TYPE_CARD;
      item2.page = 2;
      item2.row = 1;
      item2.column = 1;
      item2.area = [1, 2, 3];
      item2.keyName = '1';
      item2.cardId = '22';
      item2.folderId = '1';
      item2.formStackId = '1';
      let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
      appInfo1.layoutInfo = [[item1, item2]];
      appInfo1.typeId = CommonConstants.TYPE_FOLDER;
      appInfo1.keyName = 'keyName0';
      appInfo1.page = 1;
      appInfo1.row = 1;
      appInfo1.column = 1;
      appInfo1.area = [1, 2, 3];
      appInfo1.keyName = '1';
      appInfo1.cardId = '2';
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
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      item1.page = 1;
      item1.row = 1;
      item1.column = 1;
      item1.area = [1, 2, 3];
      item1.keyName = '1';
      item1.cardId = '2';
      item1.folderId = '1';
      item1.formStackId = '1';
      item1.layoutInfo = [];

      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.calculator';
      item2.typeId = CommonConstants.TYPE_CARD;
      item2.page = 2;
      item2.row = 2;
      item2.column = 2;
      item2.area = [2, 3, 4];
      item2.keyName = '1000';
      item2.cardId = '22';
      item2.folderId = '1001';
      item2.formStackId = '1';

      let list: GridLayoutItemInfo[] = [];
      list.push(item1);
      list.push(item2);

      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      instance.mGridLayoutInfo = DefaultDesktopLayoutInfo.getDefaultLayoutInfo();

      instance['bindAppAndFolder']();
      expect(instance).not().assertNull();
    })

    it('test_complementAppInfo', 0, () => {
      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      const appItem = new AppItemInfo();
      appItem.appName = 'appname';
      appItem.appIconId = 1;
      appItem.appLabelId = 2;
      appItem.bundleName = 'com.ohos.calculator';
      appItem.abilityName = 'abilityName';
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

    it('test_getAllLayoutConfigFile', 0, async (done: Function) => {
      let ret = await PageDesktopLayoutConfig.getInstance()['getAllLayoutConfigFile']();
      expect(ret).not().assertNull();
      done();
    });

    it("updateDesktopDataLoader", 0, async(done:Function) => {
      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      let desktopDataLoader = new DesktopDataLoader(1);
      instance.updateDesktopDataLoader(desktopDataLoader);
      expect(instance instanceof PageDesktopLayoutConfig).assertTrue();
      done();
    })

    it("registerPresetFinishedCallback1", 0, async(done:Function) => {
      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      let callback = ()=>{};
      instance['mIsPresetLayoutPersist'] = false;
      instance.registerPresetFinishedCallback(callback);
      expect(instance instanceof PageDesktopLayoutConfig).assertTrue();
      done();
    })

    it("registerPresetFinishedCallback2", 0, async(done:Function) => {
      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      let callback = ()=>{};
      instance['mIsPresetLayoutPersist'] = true;
      instance.registerPresetFinishedCallback(callback);
      expect(instance instanceof PageDesktopLayoutConfig).assertTrue();
      done();
    })

    it("loadPersistConfig", 0, async(done:Function) => {
      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(instance['mDesktopDataLoader'], instance['mDesktopDataLoader'].loadGridLayoutItemsFromRdb);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(instance, instance['isConfigExist']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn([]);
      instance['loadPersistConfig']();
      expect(instance instanceof PageDesktopLayoutConfig).assertTrue();
      mocker.clear(instance['mDesktopDataLoader']);
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("loadDataFromConfiguration", 0, async(done:Function) => {
      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      await instance.loadDataFromConfiguration(1);
      expect(instance instanceof PageDesktopLayoutConfig).assertTrue();
      done();
    })

    it("checkRemoveFromDb", 0, async(done:Function) => {
      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      let list: GridLayoutItemInfo[] = [];
      let promise = new Promise<boolean>((resolve)=>{
        resolve(false);
      });
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(launcherAbilityManager, launcherAbilityManager.isAbilityInstalledAsync);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(promise);
      await instance['loadLayoutInfoFromConfig'](2);
      expect(instance instanceof PageDesktopLayoutConfig).assertTrue();
      mocker.clear(launcherAbilityManager);
      mocker.clearAll();
      done();
    })

    it("loadLayoutInfoFromConfig1", 0, async(done:Function) => {
      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      let defaultDesktopLayoutInfo = await new DefaultDesktopLayoutInfo();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(instance['mDesktopDataLoader'], instance['mDesktopDataLoader'].loadFromJsonConfig);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(defaultDesktopLayoutInfo);
      await instance['loadLayoutInfoFromConfig'](2);
      expect(instance instanceof PageDesktopLayoutConfig).assertTrue();
      mocker.clear(instance['mDesktopDataLoader']);
      mocker.clearAll();
      done();
    })

    it("loadLayoutInfoFromConfig2", 0, async(done:Function) => {
      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(instance['mDesktopDataLoader'], instance['mDesktopDataLoader'].loadFromJsonConfig);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      await instance['loadLayoutInfoFromConfig'](2);
      expect(instance instanceof PageDesktopLayoutConfig).assertTrue();
      mocker.clear(instance['mDesktopDataLoader']);
      mocker.clearAll();
      done();
    })

    it("initLayoutCache", 0, async(done:Function) => {
      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      instance['initLayoutCache']();
      expect(instance instanceof PageDesktopLayoutConfig).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
      done();
    })

    it("checkAppList", 0, async(done:Function) => {
      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      let mocker: MockKit = new MockKit();
      GlobalContext.getInstance().setObject('backupStatus', undefined);
      let appInstance = AppModel.getInstance();
      const appItem = new AppItemInfo();
      appItem.appName = 'appname';
      appItem.appIconId = 1;
      appItem.appLabelId = 2;
      appItem.bundleName = 'com.ohos.calculator';
      appItem.abilityName = 'abilityName';
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
      let mockFunction1: Function =
        mocker.mockFunc(appInstance, appInstance.getAppList);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn([appItem]);
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.calculator';
      item2.typeId = CommonConstants.TYPE_ADD;
      item2.page = 2;
      item2.row = 2;
      item2.column = 2;
      item2.area = [2, 3, 4];
      item2.keyName = '1000';
      item2.cardId = '22';
      item2.folderId = '1001';
      item2.formStackId = '1';
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.calculator';
      item3.typeId = CommonConstants.TYPE_APP;
      item3.page = 2;
      item3.row = 2;
      item3.column = 2;
      item3.area = [2, 3, 4];
      item3.keyName = '1000';
      item3.cardId = '22';
      item3.folderId = '1001';
      item3.formStackId = '1';
      item3.layoutInfo = [[item2]];
      instance['mGridLayoutInfo'].layoutInfo = [item2,item3];
      instance['checkAppList']();
      expect(instance instanceof PageDesktopLayoutConfig).assertTrue();
      mocker.clear(appInstance);
      mocker.clearAll();
      done();
    })

    it("updateAppInfoFromBMS1", 0, async(done:Function) => {
      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      let appInstance = AppModel.getInstance();
      const appItem = new AppItemInfo();
      appItem.appName = 'appname';
      appItem.appIconId = 1;
      appItem.appLabelId = 2;
      appItem.bundleName = 'com.ohos.calculator';
      appItem.abilityName = '';
      appItem.moduleName = '';
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
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      item1.page = 1;
      item1.row = 1;
      item1.column = 1;
      item1.area = [1, 2, 3];
      item1.keyName = 'key name';
      item1.cardId = '2';
      item1.folderId = '1';
      item1.formStackId = '1';
      item1.layoutInfo = [];
      item1.appStatus= AppStatus.INSTALLED;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(appInstance, appInstance.getAppInfoByBundleNameAndAppIndex);
      when(mockFunction)(ArgumentMatchers.any).afterReturn([appItem]);
      let result = instance['updateAppInfoFromBMS'](item1,[appItem]);
      expect(result).assertInstanceOf('Boolean');
      mocker.clear(appInstance);
      mocker.clearAll();
      done();
    })

    it("updateAppInfoFromBMS2", 0, async(done:Function) => {
      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      let appInstance = AppModel.getInstance();
      const appItem = new AppItemInfo();
      appItem.appName = 'appname';
      appItem.appIconId = 1;
      appItem.appLabelId = 2;
      appItem.bundleName = 'com.ohos.calculator';
      appItem.abilityName = '';
      appItem.moduleName = '';
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
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      item1.page = 1;
      item1.row = 1;
      item1.column = 1;
      item1.area = [1, 2, 3];
      item1.keyName = 'key name';
      item1.cardId = '2';
      item1.folderId = '1';
      item1.formStackId = '1';
      item1.layoutInfo = [];
      item1.appStatus= AppStatus.INSTALLED;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(appInstance, appInstance.getAppInfoByBundleNameAndAppIndex);
      when(mockFunction)(ArgumentMatchers.any).afterReturn([]);
      let result = instance['updateAppInfoFromBMS'](item1,[appItem]);
      expect(result).assertInstanceOf('Boolean');
      mocker.clear(appInstance);
      mocker.clearAll();
      done();
    })

    it("updateAppInfoFromBMS3", 0, async(done:Function) => {
      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      let appInstance = AppModel.getInstance();
      const appItem = new AppItemInfo();
      appItem.appName = 'appname';
      appItem.appIconId = 1;
      appItem.appLabelId = 2;
      appItem.bundleName = 'com.ohos.calculator';
      appItem.abilityName = '';
      appItem.moduleName = '';
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
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      item1.page = 1;
      item1.row = 1;
      item1.column = 1;
      item1.area = [1, 2, 3];
      item1.keyName = 'key name';
      item1.cardId = '2';
      item1.folderId = '1';
      item1.formStackId = '1';
      item1.layoutInfo = [];
      item1.appStatus= AppStatus.INSTALLED;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(appInstance, appInstance.getAppInfoByBundleNameAndAppIndex);
      when(mockFunction)(ArgumentMatchers.any).afterReturn([appItem,appItem,appItem]);
      let result =instance['updateAppInfoFromBMS'](item1,[appItem]);
      expect(result).assertInstanceOf('Boolean');
      mocker.clear(appInstance);
      mocker.clearAll();
      done();
    })

    it("updateAppInfoFromBMS4", 0, async(done:Function) => {
      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      let appInstance = AppModel.getInstance();
      const appItem = new AppItemInfo();
      appItem.appName = 'appname';
      appItem.appIconId = 1;
      appItem.appLabelId = 2;
      appItem.bundleName = 'com.ohos.calculator';
      appItem.abilityName = '';
      appItem.moduleName = '';
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
      appItem.keyName = `${appItem.bundleName}${appItem.abilityName}${appItem.moduleName}${appItem.appIndex ?? 0}${appItem.shortcutId ?? ''}`;
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_FOLDER;
      item1.page = 1;
      item1.row = 1;
      item1.column = 1;
      item1.area = [1, 2, 3];
      item1.keyName = 'key name';
      item1.cardId = '2';
      item1.folderId = '1';
      item1.formStackId = '1';
      item1.layoutInfo = [];
      item1.appStatus= AppStatus.INSTALLED;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(appInstance, appInstance.getAppInfoByBundleNameAndAppIndex);
      when(mockFunction)(ArgumentMatchers.any).afterReturn([appItem,appItem,appItem]);
      let result = instance['updateAppInfoFromBMS'](item1,[appItem]);
      expect(result).assertInstanceOf('Boolean');
      mocker.clear(appInstance);
      mocker.clearAll();
      done();
    })

    it("bindAppAndFolder", 0, async(done:Function) => {
      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_ADD;
      item1.page = 1;
      item1.row = 1;
      item1.column = 1;
      item1.area = [1, 2, 3];
      item1.keyName = 'key name';
      item1.cardId = '2';
      item1.folderId = '1';
      item1.formStackId = '1';
      item1.layoutInfo = [];
      item1.infoId = 'infoId1';
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.sceneboard';
      item2.typeId = CommonConstants.TYPE_ADD;
      item2.page = 2;
      item2.row = 1;
      item2.column = 1;
      item2.area = [1, 2, 3];
      item2.keyName = 'key name';
      item2.cardId = '2';
      item2.folderId = '1';
      item2.formStackId = '1';
      item2.layoutInfo = [];
      item2.infoId = 'infoId2';
      let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
      item3.bundleName = 'com.ohos.sceneboard';
      item3.typeId = CommonConstants.TYPE_ADD;
      item3.page = 1;
      item3.row = 2;
      item3.column = 1;
      item3.area = [1, 2, 3];
      item3.keyName = 'key name';
      item3.cardId = '2';
      item3.folderId = '1';
      item3.formStackId = '1';
      item3.layoutInfo = [];
      item3.infoId = 'infoId3';
      let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
      item4.bundleName = 'com.ohos.calculator';
      item4.typeId = CommonConstants.TYPE_FOLDER ;
      item4.page = 2;
      item4.row = 2;
      item4.column = 2;
      item4.area = [2, 3, 4];
      item4.keyName = '1000';
      item4.layoutInfo = [[item1,item1,item2,item3]];
      item4.cardId = '22';
      item4.folderId = CommonConstants.PRESET_OpenHarmony_FOLDER_ID;
      item4.formStackId = '1';
      item4.infoId = 'infoId4';
      let item5: GridLayoutItemInfo = new GridLayoutItemInfo();
      item5.bundleName = 'com.ohos.calculator';
      item5.typeId = CommonConstants.TYPE_FOLDER ;
      item5.page = 2;
      item5.row = 2;
      item5.column = 2;
      item5.area = [2, 3, 4];
      item5.keyName = '1000';
      item5.layoutInfo = [[item1,item1,item2,item3]];
      item5.cardId = '22';
      item5.folderId = '5';
      item5.formStackId = '1';
      item5.infoId = 'infoId5';
      instance['mGridLayoutInfo'].layoutInfo = [item4,item5];
      let rdbStoreManager = RdbStoreManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(rdbStoreManager, rdbStoreManager.insertGridLayoutInfo);
      let promise = Promise.resolve(true);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(promise);
      let fun = ()=>1;
      instance['mPresetCardUpdateCallBack'] = [fun];
      instance['bindAppAndFolder']();
      expect(instance instanceof PageDesktopLayoutConfig).assertTrue();
      mocker.clear(rdbStoreManager);
      mocker.clearAll();
      done();
    })

    it("complementAppInfo", 0, async(done:Function) => {
      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      const appItem = new AppItemInfo();
      appItem.appName = 'appname';
      appItem.appIconId = 1;
      appItem.appLabelId = 2;
      appItem.bundleName = 'com.ohos.calculator';
      appItem.abilityName = 'abilityName';
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
      done();
    })

    it('refreshLayoutAfterRecover1', 0, async (done:Function) => {
      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_ADD;
      item1.page = 1;
      item1.row = 1;
      item1.column = 1;
      item1.area = [1, 2, 3];
      item1.keyName = 'key name';
      item1.cardId = '2';
      item1.folderId = '1';
      item1.formStackId = '1';
      item1.layoutInfo = [];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(globalThis.RdbStoreManagerInstance,globalThis.RdbStoreManagerInstance.querySettingsPageCount);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction1: Function =
        mocker.mockFunc(globalThis.RdbStoreManagerInstance,globalThis.RdbStoreManagerInstance.queryGridLayoutInfo);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn([]);
      instance['refreshLayoutAfterRecover']();
      expect(instance instanceof PageDesktopLayoutConfig).assertTrue();
      mocker.clear(globalThis.RdbStoreManagerInstance);
      mocker.clearAll();
      done();
    })

    it('refreshLayoutAfterRecover2', 0, async (done:Function) => {
      const instance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'com.ohos.sceneboard';
      item1.typeId = CommonConstants.TYPE_ADD;
      item1.page = 1;
      item1.row = 1;
      item1.column = 1;
      item1.area = [1, 2, 3];
      item1.keyName = 'key name';
      item1.cardId = '2';
      item1.folderId = '1';
      item1.formStackId = '1';
      item1.layoutInfo = [];
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'com.ohos.calculator';
      item2.typeId = CommonConstants.TYPE_FOLDER ;
      item2.page = 2;
      item2.row = 2;
      item2.column = 2;
      item2.area = [2, 3, 4];
      item2.keyName = '1000';
      item2.layoutInfo = [[item1,item1]];
      item2.cardId = '22';
      item2.folderId = CommonConstants.PRESET_OpenHarmony_FOLDER_ID;
      item2.formStackId = '1';
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(globalThis.RdbStoreManagerInstance,globalThis.RdbStoreManagerInstance.querySettingsPageCount);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(2);
      let mockFunction1: Function =
        mocker.mockFunc(globalThis.RdbStoreManagerInstance,globalThis.RdbStoreManagerInstance.queryGridLayoutInfo);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn([item1,item2]);
      instance['refreshLayoutAfterRecover']();
      expect(instance instanceof PageDesktopLayoutConfig).assertTrue();
      mocker.clear(globalThis.RdbStoreManagerInstance);
      mocker.clearAll();
      done();
    })

    it('test_loadPersistConfig_1', 0, async () => {
      const PageDesktopLayoutConfigInstance: PageDesktopLayoutConfig = PageDesktopLayoutConfig.getInstance();
      expect(await PageDesktopLayoutConfigInstance.loadPersistConfig() === undefined).assertTrue();
    });
  })
}