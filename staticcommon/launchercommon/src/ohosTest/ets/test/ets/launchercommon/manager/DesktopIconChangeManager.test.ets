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

import { AccountMgr, sSettingsUtil } from '@ohos/frameworkwrapper';
import { CommonConstants } from '@ohos/commonconstants';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit,
  ArgumentMatchers, when} from '@ohos/hypium'
import { IconChangeSizeManager } from '../../../../../../main/ets/TsIndex'

export default function DesktopIconChangeManagerTest() {
  describe('DesktopIconChangeManagerTest', () => {
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

    it("getInstance", 0, async(done:Function) => {
      IconChangeSizeManager.getInstance();
      let instance2 = IconChangeSizeManager.getInstance();
      expect(instance2).not().assertEqual(null);
      done();
    })

    it("init1", 0, async(done:Function) => {
      let instance = IconChangeSizeManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(AccountMgr, AccountMgr.getCurrentAccountId);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(-1);
      let mockFunction1: Function =
        mocker.mockFunc(CommonConstants, CommonConstants.getSettingsSecureUriSync);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn('datashare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true&key=1');
      expect(instance['datashareHelper']).not().assertNull();
      mocker.clear(AccountMgr);
      mocker.clear(CommonConstants);
      mocker.clearAll();
      done();
    })

    it("init2", 0, async(done:Function) => {
      let instance = IconChangeSizeManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(AccountMgr, AccountMgr.getCurrentAccountId);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(-1);
      let mockFunction1: Function =
        mocker.mockFunc(CommonConstants, CommonConstants.getSettingsSecureUriSync);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      expect(instance['url']).assertUndefined();
      mocker.clear(AccountMgr);
      mocker.clear(CommonConstants);
      mocker.clearAll();
      done();
    })

    it("init3", 0, async(done:Function) => {
      let instance = IconChangeSizeManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(AccountMgr, AccountMgr.getCurrentAccountId);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(-1);
      let mockFunction1: Function =
        mocker.mockFunc(CommonConstants, CommonConstants.getSettingsSecureUriSync);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn('');
      let mockFunction2: Function =
        mocker.mockFunc(instance, instance['desktopIconChangeCallback']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      expect(instance['url']).assertUndefined();
      mocker.clear(AccountMgr);
      mocker.clear(CommonConstants);
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("init4", 0, async(done:Function) => {
      let instance = IconChangeSizeManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(AccountMgr, AccountMgr.getCurrentAccountId);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(-1);
      let mockFunction1: Function =
        mocker.mockFunc(CommonConstants, CommonConstants.getSettingsSecureUriSync);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn('');
      let mockFunction2: Function =
        mocker.mockFunc(instance, instance['desktopIconChangeCallback']);
      when(mockFunction2)(ArgumentMatchers.any).afterThrow('error');
      expect(instance['url']).assertUndefined();
      mocker.clear(AccountMgr);
      mocker.clear(CommonConstants);
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("desktopIconChangeCallback1", 0, async(done:Function) => {
      let instance = IconChangeSizeManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(-7);
      expect(instance).not().assertNull();
      mocker.clear(sSettingsUtil);
      mocker.clearAll();
      done();
    })

    it("desktopIconChangeCallback2", 0, async(done:Function) => {
      let instance = IconChangeSizeManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(1);
      expect(instance).not().assertNull();
      mocker.clear(sSettingsUtil);
      mocker.clearAll();
      done();
    })

    it('test_init', 0, async(done: Function) => {
      let instance: IconChangeSizeManager = IconChangeSizeManager.getInstance();
      await instance.init();
      expect(instance).not().assertNull();
      expect(instance['datashareHelper']).not().assertNull();
      done();
    })

    it("initDataShareListener1", 0, async(done: Function) => {
      let instance: IconChangeSizeManager = IconChangeSizeManager.getInstance();
      await instance['initDataShareListener'](1);
      expect(instance['datashareHelper']).not().assertNull();
      done();
    })

    it("initDataShareListener2", 0, async(done: Function) => {
      let instance: IconChangeSizeManager = IconChangeSizeManager.getInstance();
      await instance['initDataShareListener'](2);
      expect(instance['datashareHelper']).not().assertNull();
      done();
    })

    it("initDataShareListener3", 0, async(done: Function) => {
      let instance: IconChangeSizeManager = IconChangeSizeManager.getInstance();
      await instance['initDataShareListener'](3);
      expect(instance['datashareHelper']).not().assertNull();
      done();
    })

    it("initDataShareListener4", 0, async(done: Function) => {
      let instance: IconChangeSizeManager = IconChangeSizeManager.getInstance();
      await instance['initDataShareListener'](0);
      expect(instance['datashareHelper']).not().assertNull();;
      done();
    })

    it("testUserId1", 0, async(done: Function) => {
      let instance: IconChangeSizeManager = IconChangeSizeManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(AccountMgr, AccountMgr.getCurrentAccountId);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(-1);
      await instance.init();
      expect(instance['datashareHelper']).not().assertNull();
      mocker.clear(instance);
      mocker.clear(AccountMgr);
      mocker.clearAll();
      done();
    })

    it("testUserId2", 0, async(done: Function) => {
      let instance: IconChangeSizeManager = IconChangeSizeManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(AccountMgr, AccountMgr.getCurrentAccountId);
      when(mockFunction)(ArgumentMatchers.any).afterReturn('userId');
      await instance.init();
      expect(instance['datashareHelper']).not().assertNull();
      mocker.clear(instance);
      mocker.clear(AccountMgr);
      mocker.clearAll();
      done();
    })
  })
}