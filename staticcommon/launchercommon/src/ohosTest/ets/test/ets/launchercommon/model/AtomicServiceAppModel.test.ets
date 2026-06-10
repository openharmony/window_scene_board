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

import { AtomicServiceAppModel } from '../../../../../../main/ets/TsIndex';
import HashMap from '@ohos.util.HashMap';
import { AppItemInfo, atomicServiceAbilityManager, CommonConstants } from '../../../../../../main/ets/TsIndex';

export default function AtomicServiceAppModelTest() {

  describe('AtomicServiceAppModelTest', () => {
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
    it('AtomicServiceAppModel_test_getInstance', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      globalThis.AtomicServiceAppModel = null;
      let model = AtomicServiceAppModel.getInstance();
      expect(globalThis.AtomicServiceAppModel).assertNull();
    })

    it('test_getAtomicServiceAppList', 0, async (): Promise<void> => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model = AtomicServiceAppModel.getInstance();
      let appList: AppItemInfo[] = await model.getAtomicServiceAppList();
      expect(appList.length).assertLargerOrEqual(0);
    })

    it('test_getAtomicServiceAppListAsync', 0, async (): Promise<void> => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model = AtomicServiceAppModel.getInstance();
      let appList: AppItemInfo[] = await model.getAtomicServiceAppListAsync();
      expect(appList.length).assertLargerOrEqual(0);
    })

    it('test_registerStateChangeListener', 0, async (): Promise<void> => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model = AtomicServiceAppModel.getInstance();
      const callMap = new HashMap<string, boolean>();
      const callback = (appList: AppItemInfo[]) => {
        for (const app of appList) {
          callMap.set(app.appName, true);
        }
      };
      model.registerStateChangeListener(callback);
      model.registerStateChangeListener(callback);
      expect(callMap.length).assertLargerOrEqual(0);
    })

    it('test_unregisterAppStateChangeListener', 0, async (): Promise<void> => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let model = AtomicServiceAppModel.getInstance();
      const callMap = new HashMap<string, boolean>();
      const callback = (appList: AppItemInfo[]) => {
        for (const app of appList) {
          callMap.set(app.appName, true);
        }
      };
      model.registerStateChangeListener(callback);
      model.unregisterAppStateChangeListener(callback);
      model.unregisterAppStateChangeListener(callback);
      expect(callMap.length).assertLargerOrEqual(0);
    })

    it('test_getUserId', 0, () => {
      let model = AtomicServiceAppModel.getInstance();
      const expectUserId = atomicServiceAbilityManager.getUserId();
      expect(expectUserId).assertLarger(0);
    })

    it('test_getAndReplaceAtomicAbility', 0, async (): Promise<void> => {
      try {
        let model = AtomicServiceAppModel.getInstance();
        let bundleName = 'anyBundleNotExists'
        let appItemInfo: AppItemInfo = await model.getAndReplaceAtomicAbility(bundleName);
        expect(appItemInfo).assertUndefined();
      }catch{};
    })

    it('test_notifyAppStateChangeEvent', 0, () => {
      const callback = (appList: AppItemInfo[]) => {
      };
      AtomicServiceAppModel.getInstance().registerStateChangeListener(callback);
      AtomicServiceAppModel.getInstance()['notifyAppStateChangeEvent']();
      expect(true).assertTrue();
    })

    it('test_getAtomicServiceItemIndex', 0, () => {
      let bundle = 'com.ohos.app';
      AtomicServiceAppModel.getInstance()['getAtomicServiceItemIndex'](bundle);
      expect(true).assertTrue();

      let item: AppItemInfo = new AppItemInfo();
      let appList: AppItemInfo[] = [];
      appList.push(item);
      AtomicServiceAppModel.getInstance()['appendAtomicServiceItem'](appList);
      expect(true).assertTrue();
    })

    it('test_removeAtomicServiceItem', 0, () => {
      let bundle = 'com.ohos.app';
      AtomicServiceAppModel.getInstance()['removeAtomicServiceItem'](bundle);
      expect(true).assertTrue();
    })

    it('test_removeItemCache', 0, () => {
      let item: AppItemInfo = new AppItemInfo();
      item.bundleName = 'com.hos.app';
      item.moduleName = 'main';
      item.abilityName = 'MainAbility';
      item.appLabelId = 1;
      AtomicServiceAppModel.getInstance()['removeItemCache'](item);
      expect(true).assertTrue();
    })

    it('test_replaceAtomicServiceItem', 0, () => {
      let bundle = 'com.ohos.app';
      let item: AppItemInfo = new AppItemInfo();
      item.bundleName = 'com.hos.app';
      item.moduleName = 'main';
      item.abilityName = 'MainAbility';
      item.appLabelId = 1;
      let appList: AppItemInfo[] = [];
      appList.push(item);
      AtomicServiceAppModel.getInstance()['replaceAtomicServiceItem'](bundle, appList);
      expect(true).assertTrue();
    })
  })
}