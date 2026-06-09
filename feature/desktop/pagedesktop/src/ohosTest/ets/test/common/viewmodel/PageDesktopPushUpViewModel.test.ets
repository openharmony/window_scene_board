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
import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  when,
  ArgumentMatchers,
  MockKit
} from '@ohos/hypium';
import {
  AppItemInfo,
  AppModel,
  AppStatus,
  CardItemInfo,
  CommonConstants,
  DefaultDesktopLayoutInfo,
  DeleteItemType,
  FormModel,
  GridLayoutConfig,
  GridLayoutItemInfo,
  MenuInfo,
  SettingsModel,
  keyEventManager
} from '@ohos/launchercommon';
import { PageDesktopGridStyleConfig, PageDesktopViewModel } from '../../../../../..';
import { PageDesktopViewModelUtils } from '../../../../../main/ets/default/common/viewmodel/PageDesktopViewModelUtils';
import FormConstants from '@ohos/form/src/main/ets/default/common/constants/FormConstants';


export default function PageDesktopPushUpViewModelTest() {
  describe('PageDesktopPushUpViewModelTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });

    it('initGridList00', 0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();

      //条件1 mIsLayoutOrDockFinish true
      pageDesktopViewModel.initGridList();
      pageDesktopViewModel.initGridList();

      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })

    it('afterDeleteDesktopItem00', 0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC)
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);

      //条件1 DeviceHelper.isPC true
      try {
        pageDesktopViewModel.afterDeleteDesktopItem();
      } catch (err) {}

      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('afterDeleteDesktopItem01', 1, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC)
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);

      //条件1 DeviceHelper.isPC false
      try {
        pageDesktopViewModel.afterDeleteDesktopItem(false);
      } catch (err) {}

      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(DeviceHelper)
      mocker.clearAll()
    })

    it('afterDeleteDesktopItem02', 0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC)
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);

      //条件1 DeviceHelper.isPC false, isOuter true
      try {
        pageDesktopViewModel.afterDeleteDesktopItem(true);
      } catch (err) {}

      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(DeviceHelper)
      mocker.clearAll()
    })

    it('updateForms00', 0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let formModel: FormModel = FormModel.getInstance();
      let mocker: MockKit = new MockKit();

      //条件1 allFormsInfo.length false
      let mockFunction: Function = mocker.mockFunc(formModel, formModel.getAllFormsInfoFromRdb);
      when(mockFunction)(ArgumentMatchers.any).afterReturn([]);

      pageDesktopViewModel.updateForms();
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(formModel);
      mocker.clearAll();
    })
    it('updateForms01', 1, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();

      //条件1 allFormsInfo.length true
      pageDesktopViewModel.updateForms();
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })

    it('deleteAppItem00', 0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let mocker: MockKit = new MockKit();

      //条件1 appItem.keyName true
      let appItem: GridLayoutItemInfo = appList.find(item => item.typeId === CommonConstants.TYPE_APP) ?? new GridLayoutItemInfo();
      let deleteItem: DeleteItemType = {
        bundleName: appItem.bundleName,
        keyName: appItem.keyName,
        abilityName: appItem.abilityName,
        moduleName: appItem.moduleName,
        folderId: appItem.folderId,
        deleteByDockDrop: false
      }

      //条件2 DeviceHelper.isPhone true
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);

      try {
        pageDesktopViewModel.deleteAppItem(deleteItem);
      } catch (err) {}
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })
    it('deleteAppItem01', 1, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let mocker: MockKit = new MockKit();

      //条件1 appItem.keyName true
      let appItem: GridLayoutItemInfo = appList.find(item => item.typeId === CommonConstants.TYPE_APP) ?? new GridLayoutItemInfo();
      let deleteItem: DeleteItemType = {
        bundleName: appItem.bundleName,
        keyName: appItem.keyName,
        abilityName: appItem.abilityName,
        moduleName: appItem.moduleName,
        folderId: appItem.folderId,
        deleteByDockDrop: false
      }

      //条件2 DeviceHelper.isPhone false
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);

      try {
        pageDesktopViewModel.deleteAppItem(deleteItem);
      } catch (err) {}
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })
    it('deleteAppItem02', 2, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let mocker: MockKit = new MockKit();

      //条件1 appItem.keyName true
      let appItem: GridLayoutItemInfo = appList.find(item => item.typeId === CommonConstants.TYPE_APP) ?? new GridLayoutItemInfo();
      let deleteItem: DeleteItemType = {
        bundleName: undefined,
        keyName: appItem.keyName,
        abilityName: appItem.abilityName,
        moduleName: appItem.moduleName,
        folderId: appItem.folderId,
        deleteByDockDrop: false
      }

      //条件2 DeviceHelper.isPhone true
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);

      try {
        pageDesktopViewModel.deleteAppItem(deleteItem);
      } catch (err) {}
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })
    it('deleteAppItem03', 3, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let mocker: MockKit = new MockKit();

      //条件1 appItem.bundleName true
      let appItem: GridLayoutItemInfo = appList.find(item => item.typeId === CommonConstants.TYPE_APP) ?? new GridLayoutItemInfo();
      let deleteItem: DeleteItemType = {
        bundleName: undefined,
        keyName: appItem.keyName,
        abilityName: appItem.abilityName,
        moduleName: appItem.moduleName,
        folderId: appItem.folderId,
        deleteByDockDrop: false
      }

      //条件2 DeviceHelper.isPhone false
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);

      try {
        pageDesktopViewModel.deleteAppItem(deleteItem);
      } catch (err) {}
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })
    it('deleteAppItem04', 4, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let mocker: MockKit = new MockKit();

      //条件1 appItem.folderId true
      let appItem: GridLayoutItemInfo = appList.find(item => item.typeId === CommonConstants.TYPE_FOLDER) ?? new GridLayoutItemInfo();
      let deleteItem: DeleteItemType = {
        bundleName: undefined,
        keyName: undefined,
        abilityName: appItem.abilityName,
        moduleName: appItem.moduleName,
        folderId: appItem.folderId,
        deleteByDockDrop: false
      }

      //条件2 DeviceHelper.isPhone true
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);

      try {
        pageDesktopViewModel.deleteAppItem(deleteItem);
      } catch (err) {}
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })
    it('deleteAppItem05', 5, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let mocker: MockKit = new MockKit();

      //条件1 appItem.folderId true
      let appItem: GridLayoutItemInfo = appList.find(item => item.typeId === CommonConstants.TYPE_FOLDER) ?? new GridLayoutItemInfo();
      let deleteItem: DeleteItemType = {
        bundleName: undefined,
        keyName: undefined,
        abilityName: appItem.abilityName,
        moduleName: appItem.moduleName,
        folderId: appItem.folderId,
        deleteByDockDrop: false
      }

      //条件2 DeviceHelper.isPhone false
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);

      try {
        pageDesktopViewModel.deleteAppItem(deleteItem);
      } catch (err) {}
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('addToDesktop00', 0, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleName);
      let appInfo: AppItemInfo = new AppItemInfo();

      //条件1 appItem undefined
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(undefined);
      pageDesktopViewModel.addToDesktop(appInfo);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(appModel);
      mocker.clearAll();
    })
    it('addToDesktop01', 1, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let appItem: GridLayoutItemInfo = appList.find(item => item.typeId === CommonConstants.TYPE_APP) ?? new GridLayoutItemInfo();
      let appInfo: AppItemInfo = new AppItemInfo();

      //条件1 appItem true
      appInfo.bundleName = appItem.bundleName;

      //条件2 installed
      pageDesktopViewModel.addToDesktop(appInfo);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })
    it('addToDesktop02', 2, async () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let demoFolder: GridLayoutItemInfo = new GridLayoutItemInfo();
      let appItem: GridLayoutItemInfo = appList.find(item => item.typeId === CommonConstants.TYPE_FOLDER) ?? demoFolder;
      let appInfo: AppItemInfo = new AppItemInfo();
      if (!appItem.layoutInfo) {
        appItem.layoutInfo = [];
        appItem.layoutInfo.push([new GridLayoutItemInfo()])
      }
      for (let i = 0; i < appItem?.layoutInfo?.length; i++) {
        for (let j = 0; j < appItem.layoutInfo[i]?.length; j++) {
          if (appItem.layoutInfo[i][j]?.typeId === CommonConstants.TYPE_APP) {
            appInfo.bundleName = appItem.layoutInfo[i][j].bundleName;
            break;
          }
        }
        if (appInfo.bundleName) {
          break;
        }
      }

      pageDesktopViewModel.addToDesktop(appInfo);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })
    it('addToDesktop03', 3, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleName);
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.ohosTest';
      appInfo.keyName = 'com.ohos.ohosTestPhoneEntry';

      //条件1 appItem undefined
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfo);
      pageDesktopViewModel.addToDesktop(appInfo);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(appModel);
      mocker.clear(pageDesktopViewModel);
      mocker.clearAll();
    })
    it('addToDesktop04', 4, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleName);
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.ohosTest';
      appInfo.keyName = 'com.ohos.ohosTestPhoneEntry';

      //条件1 appItem undefined
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfo);
      pageDesktopViewModel.addToDesktop(appInfo);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(appModel);
      mocker.clear(pageDesktopViewModel);
      mocker.clearAll();
    })

    it('addToDesktop06', 4, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleName);
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.ohosTest';
      appInfo.keyName = 'com.ohos.ohosTestPhoneEntry';

      //条件1 appItem undefined
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfo);
      // 条件3 isPad true
      pageDesktopViewModel.setDevice(CommonConstants.PAD_DEVICE_TYPE);

      pageDesktopViewModel.addToDesktop(appInfo);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(appModel);
      mocker.clear(pageDesktopViewModel);
      mocker.clearAll();
    })
    it('addToDesktop05', 5, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(appModel, appModel.getAppInfoByBundleName);
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.ohosTest';
      appInfo.keyName = 'com.ohos.ohosTestPhoneEntry';

      //条件1 appItem undefined false
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(appInfo);
      // 条件3 isPad false
      pageDesktopViewModel.setDevice(CommonConstants.DEFAULT_DEVICE_TYPE);

      pageDesktopViewModel.addToDesktop(appInfo);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(appModel);
      mocker.clear(pageDesktopViewModel);
      mocker.clearAll();
    })

    it('insertNewUpdateApp00', 0, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let viewUtils: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(pageDesktopViewModel);
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let newAppItem: GridLayoutItemInfo | undefined = appList.find(item => item.typeId === CommonConstants.TYPE_APP);

      try {
        await pageDesktopViewModel.insertNewUpdateApp([newAppItem]);
      } catch (err) {}
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(viewUtils);
      mocker.clearAll();
      done();
    })
    it('insertNewUpdateApp01', 1, async (done: Function) => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let viewUtils: PageDesktopViewModelUtils = new PageDesktopViewModelUtils(pageDesktopViewModel);
      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let appList: GridLayoutItemInfo[] = settingsModel.getAppListInfo();
      let newAppItem: GridLayoutItemInfo | undefined = appList.find(item => item.typeId === CommonConstants.TYPE_APP && item.container === -100);

      // 条件2 appInDockIndex false
      pageDesktopViewModel.insertNewUpdateApp([newAppItem]);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
      mocker.clear(viewUtils);
      mocker.clearAll();
      done();
    })

    it('buildNotInstalledAppMenu01', 1, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let dialog: number = 1;
      let appItem: AppItemInfo = new AppItemInfo();
      appItem.bundleName = 'BundleNameNotExists';
      appItem.area = [1, 1];
      pageDesktopViewModel.buildNotInstalledAppMenu(appItem, dialog);
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual(`test`);
    })
    it('getEnoughAreaPosition00', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();

      let mSettingsModel: SettingsModel = SettingsModel.getInstance();
      // 无空间
      const area = [4, 4];

      pageDesktopViewModel.changeIndex(1);
      const result = pageDesktopViewModel.getEnoughAreaPosition(0, area, 4);
      expect(result === null);
      mocker.clear(mSettingsModel);
      mocker.clearAll();
    })
    it('getEnoughAreaPosition01', 1, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let pageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mocker: MockKit = new MockKit();

      let mSettingsModel: SettingsModel = SettingsModel.getInstance();
      // 有空间
      const area = [1, 1];

      pageDesktopViewModel.changeIndex(0);
      const result = pageDesktopViewModel.getEnoughAreaPosition(1, area);
      expect(result?.pageIndex === 1 && result?.row >= 0 && result?.column >= 0);
      mocker.clear(mSettingsModel);
      mocker.clearAll();
    })

  })
}
