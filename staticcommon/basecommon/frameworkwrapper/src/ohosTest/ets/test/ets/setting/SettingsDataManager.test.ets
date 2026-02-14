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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit } from '@ohos/hypium'
import { settingsDataManager } from '../../../../../main/ets/setting/SettingsDataManager';
import { dataShare } from '@kit.ArkData';
import { DomainName } from '@ohos/basicutils';
import { GlobalContext } from '../../../../../main/ets/utils/GlobalContext';
import { settings } from '@kit.BasicServicesKit';
import type ctx from '@ohos.app.ability.common';

export function SettingsDataManagerTest() {
  const manager = settingsDataManager;
  describe('SettingsDataManagerTest', () => {
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
    it('test_setValue', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      const helper = 0;
      const key = 'NotExistsKey';
      const value = 'SomeValue';
      const defaultValue = 'SomeDefaultValue';
      manager.setValue(helper, key, value);
      expect(manager.getValue(helper, key, defaultValue)).assertEqual(value);
    })

    it('test_getUri', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let settingDataKey = 'anyStringAsYouLike';
      const uri = manager.getUri(settingDataKey);
      expect(uri).not().assertUndefined();
      const prefix = 'datashare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true&key=';
      expect(uri).assertEqual(prefix + settingDataKey);
    })

    it('test_createDataShareHelper', 0, async (done: Function) => {
      const mocker = new MockKit();
      mocker.mockFunc(GlobalContext.getInstance(), GlobalContext.getInstance().getObject);
      manager.createDataShareHelper();
      mocker.verify('getObject', ['desktopContext']).times(2);
      mocker.clear(GlobalContext.getInstance());
      mocker.clearAll();
      done();
    })

    it('test_getHelper', 0, async (done: Function) => {
      const helper: dataShare.DataShareHelper = manager.getHelper('', '');
      expect(helper).not().assertNull();
      done();
    })

    it('test_setValueWithDomain', 0, async (done: Function) => {
      const key: string = 'NotExistsKey1';
      const value: string = 'SomeValue1';
      manager.setValueWithDomain(key, value);
      const valueWithDomain: string = manager.getValueWithDomain(key, value);
      let res: undefined | string = undefined;
      if (valueWithDomain !== undefined) {
        res = value;
      }
      expect(valueWithDomain === res).assertTrue();
      done();
    })

    it('test_registerKeyObserver', 0, async (done: Function) => {
      const key: string = 'NotExistsKey2';
      const key1: string = 'NotExistsKey22';
      const registerKeyObserver: boolean = manager.registerKeyObserver(key, () => {
      });
      let res: boolean = false;
      if (registerKeyObserver !== false) {
        try {
          const observer = () => {
          };
          res = settings.registerKeyObserver((GlobalContext.getInstance().getObject('desktopContext') as
          ctx.ServiceExtensionContext), key1, settings.domainName.USER_PROPERTY, observer);
        } catch (e) {
        }
      }
      expect(!registerKeyObserver === !res).assertTrue();
      done();
    })

    it('test_registerKeyObserverWithDomain', 0, async (done: Function) => {
      const key: string = 'NotExistsKey3';
      const key1: string = 'NotExistsKey33';
      const registerKeyObserverWithDomain: boolean = manager.registerKeyObserverWithDomain(key, () => {
      });
      let res: boolean = false;
      if (registerKeyObserverWithDomain !== false) {
        const observer = () => {
        };
        res = settings.registerKeyObserver((GlobalContext.getInstance().getObject('desktopContext') as
        ctx.ServiceExtensionContext), key1, settings.domainName.USER_PROPERTY, observer);
      }
      expect(registerKeyObserverWithDomain === res).assertTrue();
      done();
    })

    it('test_unregisterKeyObserver', 0, async (done: Function) => {
      const value: string = 'SomeValue2';
      const value1: string = 'SomeValue22';
      const unregisterKeyObserver: boolean = manager.unregisterKeyObserver(value);
      let res: boolean = false;
      if (unregisterKeyObserver !== false) {
        try {
          res = settings.unregisterKeyObserver((GlobalContext.getInstance().getObject('desktopContext') as
          ctx.ServiceExtensionContext), value1, DomainName.SCB);
        } catch (e) {
        }
      }
      expect(!unregisterKeyObserver === !res).assertTrue();
      done();
    })

    it('test_unregisterKeyObserverWithDomain', 0, async (done: Function) => {
      const value: string = 'SomeValue3';
      const value1: string = 'SomeValue33';
      const unregisterKeyObserverWithDomain: boolean = manager.unregisterKeyObserverWithDomain(value);
      let res: boolean = false;
      if (unregisterKeyObserverWithDomain !== false) {
        res = settings.unregisterKeyObserver((GlobalContext.getInstance().getObject('desktopContext') as
        ctx.ServiceExtensionContext), value1, settings.domainName.USER_PROPERTY);
      }
      expect(unregisterKeyObserverWithDomain === res).assertTrue();
      done();
    })

  })
}