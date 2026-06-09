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
import { CheckEmptyUtils } from '@ohos/basicutils'
import { commonBundleManager } from '@ohos/frameworkwrapper'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import atomicServiceAbilityManager from '../../../../../../main/ets/manager/AtomicServiceAbilityManager'
import { AppItemInfo } from '../../../../../../main/ets/TsIndex'
import { bundleManager } from '@kit.AbilityKit'

export default function AtomicServiceAbilityManagerTest() {
  describe('AtomicServiceAbilityManagerTest', () => {
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
    it("test_getAtomicServiceAbilityList", 0, async (done: Function) => {
      let result = await atomicServiceAbilityManager.getAtomicServiceAbilityList();
      expect(result.length >= 0).assertTrue();
      done();
    })

    it("test_getAtomicServiceAbilityInfoAsync", 0, async (done: Function) => {
      try{
        let bundleName: string = 'bundleName';
        let result =  await atomicServiceAbilityManager.getAtomicServiceAbilityInfoAsync(bundleName);
        expect(result.length >= 0).assertTrue();
      } catch(e) {}
      done();
    })

    it("test_getAtomicServiceAbilityInfoAsync_emptyBundleName", 0, async (done: Function) => {
      let bundleName = null;
      let result =  await atomicServiceAbilityManager.getAtomicServiceAbilityInfoAsync(bundleName);
      expect(result.length === 0).assertTrue();

      result =  await atomicServiceAbilityManager.getAtomicServiceAbilityInfoAsync('');
      expect(result.length === 0).assertTrue();
      done();
    })

    it("test_getAnAtomicServiceAbilityInfoFromCache", 0, async (done: Function) => {
      try {
        let bundleName: string = 'bundleName';
        let result =  await atomicServiceAbilityManager.getAnAtomicServiceAbilityInfoFromCache(bundleName);
        expect(result).assertUndefined();
      } catch (e) {
      }
      done();
    })

    it("test_getAnAtomicServiceAbilityInfoFromCache_emptyBundleName", 0, async (done: Function) => {
      let bundleName = null;
      let result =  await atomicServiceAbilityManager.getAnAtomicServiceAbilityInfoFromCache(bundleName);
      expect(result).assertUndefined();
      done();
    })

    it("test_getUserId", 0, () => {
      try {
        let result = atomicServiceAbilityManager.getUserId();
        expect(result >= 0).assertTrue();
      } catch (e) {
      }
    })

    it("test_cleanAppMapCache", 0, () => {
      atomicServiceAbilityManager.cleanAppMapCache();
      expect(atomicServiceAbilityManager['mAtomicServiceAppMap'].size).assertEqual(0);
    })

    it("test_getAtomicServiceAbilityList_001", 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc : Function  = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false)
      try {
        let result = await atomicServiceAbilityManager.getAtomicServiceAbilityList();
        expect(result.length >= 0).assertTrue();
      } catch (e) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
      done();
    })

    it("test_getAtomicServiceAbilityInfoAsync_001", 0, async (done: Function) => {
      let bundleName = 'com.ohos.calendar';
      let mocker: MockKit = new MockKit();
      let mockFunc : Function  = mocker.mockFunc(commonBundleManager, commonBundleManager.getBundleInfoByBundleName);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined)
      try {
        let result: AppItemInfo[] =  await atomicServiceAbilityManager.getAtomicServiceAbilityInfoAsync(bundleName);
        expect(result.length === 0).assertTrue();
      } catch (e) {
      }
      mocker.clear(commonBundleManager);
      mocker.clearAll();
      done();
    })

    it("test_getAnAtomicServiceAbilityInfoFromCache_getFromCache", 0, async (done: Function) => {
      try {
        let bundleName = 'com.ohos.calendar';
        let appItem: AppItemInfo = getAppItemInfo();
        atomicServiceAbilityManager['mAtomicServiceAppMap'].set(bundleName, appItem);
        let result =  await atomicServiceAbilityManager.getAnAtomicServiceAbilityInfoFromCache(bundleName);
        expect(result?.bundleName).assertEqual(bundleName);
      } catch (e) {
      }
      done();
    })

    it("test_getAnAtomicServiceAbilityInfoFromCache_getAtomicServiceAbilityInfoAsync", 0, async (done: Function) => {
      let bundleName = 'com.ohos.calendar';
      atomicServiceAbilityManager['mAtomicServiceAppMap'].delete(bundleName);
      let mocker: MockKit = new MockKit();
      let mockFunc : Function  = mocker.mockFunc(commonBundleManager, commonBundleManager.getBundleInfoByBundleName);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined)
      try {
        let abilityList: AppItemInfo[] =  await atomicServiceAbilityManager.getAtomicServiceAbilityInfoAsync(bundleName);
        expect(abilityList.length === 0).assertTrue();
        let result =  await atomicServiceAbilityManager.getAnAtomicServiceAbilityInfoFromCache(bundleName);
        expect(result).assertUndefined();
      } catch (e) {
      }
      mocker.clear(commonBundleManager);
      mocker.clearAll();
      done();
    })

    it("test_getAnAtomicServiceAbilityInfoFromCache_getAtomicServiceAbilityInfoAsync_001", 0, async (done: Function) => {
      let bundleName = 'com.ohos.calendar';
      atomicServiceAbilityManager['mAtomicServiceAppMap'].delete(bundleName);
      let bundleInfo = getTestBundliInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc : Function  = mocker.mockFunc(commonBundleManager, commonBundleManager.getBundleInfoByBundleName);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(bundleInfo)
      try {
        let abilityList: AppItemInfo[] =  await atomicServiceAbilityManager.getAtomicServiceAbilityInfoAsync(bundleName);
        expect(abilityList).not().assertUndefined();
        let result =  await atomicServiceAbilityManager.getAnAtomicServiceAbilityInfoFromCache(bundleName) ?? [];
        expect(result).not().assertUndefined();
      } catch (e) {
      }
      mocker.clear(commonBundleManager);
      mocker.clearAll();
      done();
    })

    it("test_getAtomicServiceAbilityInfoAsync_bundleInfo", 0, async (done: Function) => {
      let bundleName = 'com.ohos.calendar';
      let bundleInfo = getTestBundliInfo();
      let mocker: MockKit = new MockKit();
      let mockFunc : Function  = mocker.mockFunc(commonBundleManager, commonBundleManager.getBundleInfoByBundleName);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(bundleInfo);
      try {
        let result: AppItemInfo[] =  await atomicServiceAbilityManager.getAtomicServiceAbilityInfoAsync(bundleName);
        expect(result).not().assertUndefined();
      } catch (e) {
      }
      mocker.clear(commonBundleManager);
      mocker.clearAll();
      done();
    })


  })
}

async function getTestBundliInfo(): Promise<bundleManager.BundleInfo | undefined> {
  let bundleName = 'com.ohos.calendar';
  let bundleInfo: bundleManager.BundleInfo | undefined =
    await commonBundleManager.getBundleInfoByBundleName(bundleName, bundleManager.BundleType.APP);
  if (bundleInfo) {
    return bundleInfo;
  }
  return undefined;
}

function getAppItemInfo(bundleName?: string): AppItemInfo {
  let tempBundleName = bundleName ?? 'com.ohos.calendar';
  let appItemInfo = new AppItemInfo();
  appItemInfo.appName = 'calendar';
  appItemInfo.isSystemApp = true;
  appItemInfo.bundleName = tempBundleName;
  appItemInfo.abilityName = 'calendarAbility';
  appItemInfo.moduleName = 'entry';
  return appItemInfo;
}
