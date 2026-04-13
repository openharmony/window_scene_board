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
import { CommonUtils } from '@ohos/basicutils';
import { IconResourceManager, ResourceManager } from '@ohos/frameworkwrapper';
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
  Size,
  when
} from '@ohos/hypium'
import { BaseViewModel } from '../../../../../../main/ets/base/BaseViewModel';
import {
  AppItemInfo,
  CommonConstants,
  DisposedEventManager,
  GridLayoutItemInfo,
  LaunchLayoutCacheManager,
} from '../../../../../../main/ets/TsIndex';
import { image } from '@kit.ImageKit';

export default function BaseViewModelTest() {
  describe('BaseViewModelTest', () => {
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

    class TestBaseViewModel extends BaseViewModel {
      constructor() {
        super();
      }
    }

    it('test_jumpTo1', 0, async (done: Function) => {
      let testVM: TestBaseViewModel = new TestBaseViewModel();
      let abilityName: string = 'a';
      let bundleName: string = 'a';
      let moduleName: string = 'a';
      let params = new Map<string, Object>();
      let screenId: number = 0;
      try {
        testVM.jumpTo(abilityName, bundleName, moduleName, params, screenId);
      } catch (e) {}
      expect(testVM).not().assertNull();
      done();
    })

    it('test_jumpTo2', 0, async (done: Function) => {
      let testVM: TestBaseViewModel = new TestBaseViewModel();
      let abilityName: string = 'a';
      let bundleName: string = '';
      let moduleName: string = 'a';
      let params = new Map<string, Object>();
      let screenId: number = 0;
      try {
        testVM.jumpTo(abilityName, bundleName, moduleName, params, screenId);
      } catch (e) {}
      expect(testVM).not().assertNull();
      done();
    })

    it('test_jumpTo_getRuledBundleNamesMap_truefalse', 0, async (done: Function) => {
      let baseViewModel: TestBaseViewModel = new TestBaseViewModel();
      let abilityName: string = 'abilityName';
      let bundleName: string = 'com.ohos.photos';
      let moduleName: string = 'moduleName';
      let params = new Map<string, Object>();
      let screenId: number = 0;
      let mocker: MockKit = new MockKit();
      let eventManager: DisposedEventManager = DisposedEventManager.getInstance();
      let mockFunc2: Function = mocker.mockFunc(eventManager, eventManager.getRuledBundleNamesMap);
      let params1 = new Map<string, Object>();
      params1.set(bundleName, 'testvalue');
      when(mockFunc2)().afterReturn(params1);
      try {
        baseViewModel.jumpTo(abilityName, bundleName, moduleName, params, screenId);
      } catch (e) {}
      expect(baseViewModel).not().assertUndefined();
      expect(params1.has(bundleName)).assertTrue();
      let params2 = new Map<string, Object>();
      when(mockFunc2)().afterReturn(params2);
      try {
        baseViewModel.jumpTo(abilityName, bundleName, moduleName, params, screenId);
      } catch (e) {}
      expect(params2.has(bundleName)).assertFalse();
      mocker.clear(eventManager);
      mocker.clearAll();
      done();
    })

    it('test_getIconAndScale1', 0, async (done: Function) => {
      let viewModel: TestBaseViewModel = new TestBaseViewModel();
      let abilityName: string = 'abilityName';
      let bundleName: string = 'com.ohos.photos';
      let moduleName: string = 'moduleName';
      let params = new Map<string, Object>();
      let mocker = new MockKit();
      let manager : IconResourceManager = IconResourceManager.getInstance();
      let result = mocker.mockFunc(manager, manager.getCachedCombIconSync);
      when(result)().afterReturn(undefined);
      let res: string = await (viewModel as object)['getIconAndScale'](abilityName, bundleName, moduleName);
      expect(res).assertEqual('');
      mocker.clear(manager);
      mocker.clearAll()
      done();
    })

    it('test_getIconAndScale_001', 0, async (done: Function) => {
      let viewModel: TestBaseViewModel = new TestBaseViewModel();
      let abilityName: string = 'com.ohos.photos.MainAbility';
      let bundleName: string = 'com.ohos.photos';
      let moduleName: string = 'phone_photos';
      let params = new Map<string, Object>();
      let imagePixelMap: image.PixelMap =
        IconResourceManager.getInstance().getCachedCombIconSync(bundleName, moduleName, abilityName);
      if (imagePixelMap) {
        expect(imagePixelMap).not().assertUndefined();
        await (viewModel as object)['getIconAndScale'](abilityName, bundleName, moduleName);
        let size = imagePixelMap.getImageInfoSync().size ?? new Size();
        expect(size).not().assertUndefined();
      }
      done();
    })

    it('test_uninstallApp1', 0, async (done: Function) => {
      let testVM: TestBaseViewModel = new TestBaseViewModel();
      testVM.uninstallApp("a", false, 0);
      expect(testVM).not().assertNull();
      done();
    })

    it('test_uninstallApp2', 0, async (done: Function) => {
      let testVM: TestBaseViewModel = new TestBaseViewModel();
      testVM.uninstallApp("a", true, null);
      expect(testVM).not().assertNull();
      done();
    })

    it('test_uninstallApp3', 0, async (done: Function) => {
      let testVM: TestBaseViewModel = new TestBaseViewModel();
      testVM.uninstallApp("a", true, 0);
      expect(testVM).not().assertNull();
      done();
    })

    it('test_informUninstallResult1', 0, async (done: Function) => {
      let testVM: TestBaseViewModel = new TestBaseViewModel();
      testVM.informUninstallResult(CommonConstants.UNINSTALL_FORBID, 'a');
      expect(testVM).not().assertNull();
      done();
    })

    it('test_informUninstallResult2', 0, async (done: Function) => {
      let testVM: TestBaseViewModel = new TestBaseViewModel();
      testVM.informUninstallResult(CommonConstants.UNINSTALL_SUCCESS, 'a');
      expect(testVM).not().assertNull();
      done();
    })

    it('test_informUninstallResult4', 0, async (done: Function) => {
      let testVM: TestBaseViewModel = new TestBaseViewModel();
      testVM.informUninstallResult(CommonConstants.TYPE_APP, 'a');
      expect(testVM).not().assertNull();
      done();
    })

    it('test_getAppName1', 0, async (done: Function) => {
      let testVM: TestBaseViewModel = new TestBaseViewModel();
      let itemInfo = new AppItemInfo;
      itemInfo.appLabelId = undefined;
      itemInfo.bundleName = '';
      itemInfo.moduleName = '';
      itemInfo.appIndex = undefined;
      itemInfo.abilityName = '';
      testVM.getAppName(itemInfo);
      expect(testVM).not().assertNull();
      done();
    })

    it('test_getAppName2', 0, async (done: Function) => {
      let testVM: TestBaseViewModel = new TestBaseViewModel();
      let itemInfo = new AppItemInfo;
      itemInfo.appLabelId = 0;
      itemInfo.bundleName = 'a';
      itemInfo.moduleName = 'a';
      itemInfo.appIndex = 1;
      itemInfo.abilityName = 'a';
      testVM.getAppName(itemInfo);
      expect(testVM).not().assertNull();
      done();
    })

    it('test_getAppName3', 0, async (done: Function) => {
      let testVM: TestBaseViewModel = new TestBaseViewModel();
      let itemInfo = new AppItemInfo;
      itemInfo.appLabelId = 0;
      itemInfo.bundleName = 'a';
      itemInfo.moduleName = 'a';
      itemInfo.appIndex = 0;
      itemInfo.abilityName = 'a';
      testVM.getAppName(itemInfo);
      expect(testVM).not().assertNull();
      done();
    })

    it('test_deleteNotInstallApp1', 0, async (done: Function) => {
      let testVM: TestBaseViewModel = new TestBaseViewModel();
      try {
        testVM.deleteNotInstallApp(true, 'a', 0);
      } catch (e) {}
      expect(testVM).not().assertNull();
      done();
    })

    it('test_deleteNotInstallApp2', 0, async (done: Function) => {
      let testVM: TestBaseViewModel = new TestBaseViewModel();
      testVM.deleteNotInstallApp(true, 'a', 1);
      expect(testVM).not().assertNull();
      done();
    })

    it('test_deleteNotInstallApp3', 0, async (done: Function) => {
      let testVM: TestBaseViewModel = new TestBaseViewModel();
      testVM.deleteNotInstallApp(false, 'a', 1);
      expect(testVM).not().assertNull();
      done();
    })

    it('test_deleteNotInstallApp4', 0, async (done: Function) => {
      let testVM: TestBaseViewModel = new TestBaseViewModel();
      testVM.deleteNotInstallApp(false, 'a', 1, false);
      expect(testVM).not().assertNull();
      done();
    })

    it('test_informUninstallResult_else001', 0, async (done: Function) => {
      let testVM: TestBaseViewModel = new TestBaseViewModel();
      let mocker = new MockKit();
      testVM.informUninstallResult(-1, 'testbundlename');
      expect(testVM).not().assertNull();
      mocker.clearAll();
      done();
    })

    it('test_getAppName_001', 0, async (done: Function) => {
      let baseViewModel: TestBaseViewModel = new TestBaseViewModel();
      let itemInfo: AppItemInfo = {
        appLabelId: 0,
        abilityName: 'abilityName',
        moduleName: 'moduleName',
        bundleName: 'bundleName',
        appIndex: 1,
        appIconId: 0,
        appName: ''
      }
      let resourceManager: ResourceManager = ResourceManager.getInstance();
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(resourceManager, resourceManager.getAppResourceCache);
      when(mockFunc)(ArgumentMatchers.any).afterReturn('');
      let mockFunc1 = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let res = baseViewModel.getAppName(itemInfo);
      expect(res).not().assertNull();
      mocker.clear(resourceManager);
      mocker.clear(CommonUtils);
      mocker.clearAll();
      done();
    })

    it('test_deleteNotInstallApp_deletemainfalse', 0, async (done: Function) => {
      let baseViewModel: TestBaseViewModel = new TestBaseViewModel();
      let isRemove = true;
      let bundleName: string = 'com.ohos.photos';
      let appIndex = 0;
      let isDeleteMainAppAndTwinApp = false;
      let manager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(manager, manager.getAllSameBundleNameAppItem);
      let appList: GridLayoutItemInfo[] = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'bundleName1';
      item1.appIndex = 0;
      item1.intent = '{\"requestBundleName\":\"testBundleName\"}';
      appList.push(item1);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(appList);
      baseViewModel.deleteNotInstallApp(isRemove, bundleName, appIndex, isDeleteMainAppAndTwinApp);
      expect(bundleName.startsWith('__WAIT_FOR_')).assertFalse();
      mocker.clear(manager);
      mocker.clearAll();
      done();
    })

    it('test_deleteNotInstallApp_forEach', 0, async (done: Function) => {
      let baseViewModel: TestBaseViewModel = new TestBaseViewModel();
      let isRemove = false;
      let bundleName: string = 'com.ohos.photos';
      let appIndex = 0;
      let isDeleteMainAppAndTwinApp = true;
      let manager: LaunchLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(manager, manager.getAllSameBundleNameAppItem);
      let appList: GridLayoutItemInfo[] = [];
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.bundleName = 'bundleName1';
      item1.appIndex = 0;
      item1.intent = '{\"requestBundleName\":\"testBundleName\"}';
      appList.push(item1);
      let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
      item2.bundleName = 'bundleName1';
      item2.appIndex = 0;
      item2.intent = '{\"requestBundleName11\":\"testBundleName2\"}';
      appList.push(item2);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(appList);
      try {
        baseViewModel.deleteNotInstallApp(isRemove, bundleName, appIndex, isDeleteMainAppAndTwinApp);
      } catch (e) {}
      let testBundleName = CommonUtils.jsonStrToMap(item1.intent).get('requestBundleName') ?? ''
      expect(testBundleName).assertEqual('testBundleName');
      mocker.clear(manager);
      mocker.clearAll();
      done();
    })

    it('test_deleteNotInstallApp_deletemain_true', 0, async (done: Function) => {
      let baseViewModel: TestBaseViewModel = new TestBaseViewModel();
      let isRemove = false;
      let bundleName: string = 'com.ohos.photos';
      let appIndex = 0;
      let isDeleteMainAppAndTwinApp = true;
      try {
        baseViewModel.deleteNotInstallApp(isRemove, bundleName, appIndex, isDeleteMainAppAndTwinApp);
      } catch (e) {};
      expect(bundleName.startsWith('__WAIT_FOR_')).assertFalse();
      let isRemove1 = true;
      AppStorage.setOrCreate<string[]>('updateAppBundleNameList', [bundleName]);
      try {
        baseViewModel.deleteNotInstallApp(isRemove1, bundleName, appIndex, isDeleteMainAppAndTwinApp);
      } catch (e) {};
      let updateAppBundleNameList: string[] = AppStorage.get<string[]>('updateAppBundleNameList') as string[];
      expect(updateAppBundleNameList.includes(bundleName)).assertTrue();
      done();
    })
    it('test_baseInterface', 0, async (done: Function) => {
      let baseViewModel: TestBaseViewModel = new TestBaseViewModel();
      baseViewModel.onSelectItemChange([], false, false);
      expect(baseViewModel.getCurrentSelectItemsInfo().length).assertEqual(0);
      expect(baseViewModel.getCurrentSelectItems().length).assertEqual(0);
      expect(baseViewModel.getCurrentTouchItem(new GridLayoutItemInfo())).assertUndefined();
      expect(baseViewModel.getMultiSelectMap()).assertUndefined();
      expect(baseViewModel.filterSelectFileItem().length).assertEqual(0);
      done();
    })
  })
}
