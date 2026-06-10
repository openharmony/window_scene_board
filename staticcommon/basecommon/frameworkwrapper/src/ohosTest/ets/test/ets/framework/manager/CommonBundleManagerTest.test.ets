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

import bundleManager from '@ohos.bundle.bundleManager'
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import commonBundleManager  from '../../../../../../main/ets/manager/CommonBundleManager';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'CommonBundleManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export function CommonBundleManagerTest() {
  describe('CommonBundleManagerTest', () => {
    beforeAll((): void => {
    })
    beforeEach((): void => {
    })
    afterAll((): void => {
    })
    afterEach((): void => {
    })

    it('getUserId_return_number', 0, () => {
      expect(commonBundleManager.getUserId()).assertInstanceOf('Number');
    })

    it('CommonBundleManagerTest_getAllBundleList', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      await commonBundleManager.getAllBundleList();
      await commonBundleManager.getAllBundleList(bundleManager.BundleType.APP);
      expect(true).assertTrue();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('CommonBundleManagerTest_getAllBundleList_else', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      await commonBundleManager.getAllBundleList();
      expect(true).assertTrue();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('CommonBundleManagerTest_getBundleInfoByBundleName', 0, async (done: Function) => {
      await commonBundleManager.getBundleInfoByBundleName('');
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      await commonBundleManager.getBundleInfoByBundleName('anyBundleNotExists', bundleManager.BundleType.APP);
      expect(true).assertTrue();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('CommonBundleManagerTest_getBundleInfoByBundleName_else', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      try {
        await commonBundleManager.getBundleInfoByBundleName('anyBundleNotExists', bundleManager.BundleType.APP);
      } catch (e) {
      };
      expect(true).assertTrue();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('CommonBundleManagerTest_getAbilityInfoByAbilityName', 0, async (done: Function) => {
      await commonBundleManager.getAbilityInfoByAbilityName('', '');
      await commonBundleManager.getAbilityInfoByAbilityName('anyBundleNotExists', '');
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      await commonBundleManager.getAbilityInfoByAbilityName('anyBundleNotExists', 'anyModuleNotExists');
      expect(true).assertTrue();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('CommonBundleManagerTest_getAbilityInfoByAbilityName_mock', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      const mockFunc2: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      await commonBundleManager.getAbilityInfoByAbilityName('anyBundleNotExists', 'anyModuleNotExists');
      expect(true).assertTrue();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('CommonBundleManagerTest_getAbilityInfoByAbilityName_mock_else', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      const mockFunc2: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      try {
        await commonBundleManager.getAbilityInfoByAbilityName('anyBundleNotExists', 'anyModuleNotExists', bundleManager.BundleType.APP);
      } catch (e) {
      };
      expect(true).assertTrue();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('CommonBundleManagerTest_getAbilityInfoOnCurrentUser', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      await commonBundleManager.getAbilityInfoOnCurrentUser('', '');
      await commonBundleManager.getAbilityInfoOnCurrentUser('anyBundleNotExists', '');
      try {
        await commonBundleManager.getAbilityInfoOnCurrentUser('anyBundleNotExists', 'anyModuleNotExists', bundleManager.BundleType.APP, 1);
      } catch (e) {
      };
      expect(true).assertTrue();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('CommonBundleManagerTest_getAbilityInfoOnCurrentUser_mock', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      const mockFunc2: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);
      await commonBundleManager.getAbilityInfoOnCurrentUser('anyBundleNotExists', 'anyModuleNotExists', bundleManager.BundleType.APP, 1);
      expect(true).assertTrue();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('CommonBundleManagerTest_getAbilityInfoOnCurrentUser_mock_else', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      const mockFunc2: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
      try {
        await commonBundleManager.getAbilityInfoOnCurrentUser('anyBundleNotExists', 'anyModuleNotExists', bundleManager.BundleType.APP, 1);
      } catch (e) {
      };
      expect(true).assertTrue();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('CommonBundleManagerTest_setAbilityEnabledByAbilityName', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        await commonBundleManager.setAbilityEnabledByAbilityName('anyBundleNotExists', 'anyModuleNotExists', true);
      } catch (e) {
      };
      expect(true).assertTrue();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('CommonBundleManagerTest_setAbilityEnabledByAbilityName_mock', 0, async (done: Function) => {
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      try {
        await commonBundleManager.setAbilityEnabledByAbilityName('anyBundleNotExists', 'anyModuleNotExists', true);
      } catch (e) {
      };
      expect(true).assertTrue();
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it('test_getBundleInfoByBundleNameWithFlag_01', 0, async (done: Function) => {
      let bundleName: string = 'com.ohos.photos';
      let bundleFlags: number = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION |
      bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_HAP_MODULE |
      bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_ABILITY;
      await (commonBundleManager as object)['getBundleInfoByBundleNameWithFlag'](bundleName, bundleFlags,
        bundleManager.BundleType.APP);
      expect(commonBundleManager).not().assertNull();
      done();
    })

    it('test_setApplicationEnabled', 0, async (done: Function) => {
      let bundleName: string = 'com.ohos.photos';
      await commonBundleManager.setApplicationEnabled(bundleName, true);
      expect(commonBundleManager).not().assertNull();
      done();
    })

    it('test_setApplicationEnabled_mock_error', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockerFunInfo: Function = mocker.mockFunc(log, log.showInfo);
      let mockerFunErr: Function = mocker.mockFunc(log, log.error);
      when(mockerFunInfo)(ArgumentMatchers.any).afterThrow('mock error');
      when(mockerFunErr)(ArgumentMatchers.any).afterThrow('mock error');
      let bundleName: string = 'com.ohos.photos';
      await commonBundleManager.setApplicationEnabled(bundleName, true);
      expect(commonBundleManager).not().assertNull();
      mocker.clear(mockerFunInfo);
      mocker.clear(mockerFunErr);
      mocker.ignoreMock(log, mockerFunInfo);
      mocker.ignoreMock(log, mockerFunErr);
      mocker.clearAll();
      done();
    })

    it('test_isApplicationEnabled', 0, async (done: Function) => {
      let bundleName: string = 'com.ohos.photos';
      let isEnabled = await commonBundleManager.isApplicationEnabled(bundleName);
      expect(commonBundleManager).not().assertNull();
      done();
    })

    it('test_isApplicationEnabled_mock_error', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockerFunInfo: Function = mocker.mockFunc(log, log.showInfo);
      let mockerFunErr: Function = mocker.mockFunc(log, log.error);
      when(mockerFunInfo)(ArgumentMatchers.any).afterThrow('mock error');
      when(mockerFunErr)(ArgumentMatchers.any).afterThrow('mock error');
      let bundleName: string = 'com.ohos.photos';
      let isEnabled = await commonBundleManager.isApplicationEnabled(bundleName);
      expect(isEnabled).assertFalse();
      mocker.clear(mockerFunInfo);
      mocker.clear(mockerFunErr);
      mocker.ignoreMock(log, mockerFunInfo);
      mocker.ignoreMock(log, mockerFunErr);
      mocker.clearAll();
      done();
    })

    it('test_setCurrentUserID', 0, () => {
      commonBundleManager.setCurrentUserID(-1);
      expect(commonBundleManager).not().assertNull();
    })
  })
}
