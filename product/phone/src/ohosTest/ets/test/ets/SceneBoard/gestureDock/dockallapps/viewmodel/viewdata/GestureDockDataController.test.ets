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

import { LogHelper } from "@ohos/basicutils";
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from "@ohos/hypium";
import { AppItemInfo, AppModel, DockItemInfo } from "@ohos/launchercommon";
import {
  GestureDockDataController
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockallapps/viewmodel/viewdata/GestureDockDataController';

export default function GestureDockDataControllerTest() {
  describe('GestureDockDataControllerTest', () => {
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

    it('GestureDockDataController_getAllAppsList_test_01', 0, () => {
      let gestureDockDataController: GestureDockDataController = GestureDockDataController.getInstance();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAppList);
      let appItemInfos: AppItemInfo[] = [{
        appIconId: 1,
        abilityName: 'test_abilityName',
        appName: 'test_appName',
        bundleName: 'test_bundleName'
      }];
      when(mockfunc)().afterReturn(appItemInfos);

      let result: ESObject = gestureDockDataController.getAllAppsList();
      expect(result.length).assertEqual(1);
      expect(result[0].appIconId).assertEqual(1);
      expect(result[0].abilityName).assertEqual('test_abilityName');
      expect(result[0].appName).assertEqual('test_appName');
      expect(result[0].bundleName).assertEqual('test_bundleName');
      mocker.ignoreMock(AppModel.getInstance(), AppModel.getInstance().getAppList);
    });

    it('GestureDockDataController_fillDockItemByAppInfo_01', 0, () => {
      let dataController: GestureDockDataController = GestureDockDataController.getInstance();
      let itemInfo: DockItemInfo = new DockItemInfo();
      let appDataFromSystem: AppItemInfo = new AppItemInfo();
      dataController.fillDockItemByAppInfo(itemInfo, appDataFromSystem);
      expect(itemInfo.appName).assertNull();
    });

    it('GestureDockDataController_fillDockItemByAppInfo_02', 0, () => {
      let gesturedockdatacontroller: GestureDockDataController = GestureDockDataController.getInstance();
      let itemInfo: DockItemInfo = new DockItemInfo();
      let appDataFromSystem: AppItemInfo = new AppItemInfo();
      appDataFromSystem.appName = 'testApp';
      appDataFromSystem.bundleName = 'testBundle';
      appDataFromSystem.moduleName = 'testModule';
      appDataFromSystem.abilityName = 'testAbility';
      appDataFromSystem.appIndex = 1;
      appDataFromSystem.appIconId = 2;
      appDataFromSystem.appLabelId = 3;
      appDataFromSystem.applicationLabelId = 4;
      appDataFromSystem.applicationName = 'testAppName';
      appDataFromSystem.installTime = '5';
      appDataFromSystem.appStatus = 6;
      appDataFromSystem.isUninstallAble = true;
      appDataFromSystem.badgeNumber = 8;
      appDataFromSystem.enableNewAppInstance = true;
      appDataFromSystem.isSystemApp = true;
      appDataFromSystem.isActionItem = true;
      gesturedockdatacontroller.fillDockItemByAppInfo(itemInfo, appDataFromSystem);
      expect(itemInfo.appName).assertEqual('testApp');
      expect(itemInfo.bundleName).assertEqual('testBundle');
      expect(itemInfo.moduleName).assertEqual('testModule');
      expect(itemInfo.abilityName).assertEqual('testAbility');
      expect(itemInfo.appIndex).assertEqual(1);
      expect(itemInfo.appIconId).assertEqual(2);
      expect(itemInfo.appLabelId).assertEqual(3);
      expect(itemInfo.applicationLabelId).assertEqual(4);
      expect(itemInfo.applicationName).assertEqual('testAppName');
      expect(itemInfo.installTime).assertEqual('5');
      expect(itemInfo.appStatus).assertEqual(6);
      expect(itemInfo.isUninstallAble).assertEqual(true);
      expect(itemInfo.badgeNumber).assertEqual(8);
      expect(itemInfo.enableNewAppInstance).assertEqual(true);
      expect(itemInfo.isSystemApp).assertEqual(true);
      expect(itemInfo.isActionItem).assertEqual(true);
    });

    it('GestureDockDataController_createDockAppInfo_01', 0, async () => {
      let dataController: GestureDockDataController = GestureDockDataController.getInstance();
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = "com.ohos.app";
      appItemInfo.appLabelId = 1;
      appItemInfo.appIconId = 2;
      appItemInfo.iconResource = "icon";
      let index: number = 0;
      let result: DockItemInfo = await dataController.createDockAppInfo(appItemInfo, index);
      expect(result).assertInstanceOf('DockItemInfo');
    });

  });
}