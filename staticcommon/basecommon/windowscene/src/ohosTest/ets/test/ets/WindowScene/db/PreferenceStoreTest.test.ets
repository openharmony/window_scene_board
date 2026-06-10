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
  describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers
} from '@ohos/hypium';
import { PreferenceStore } from '../../../../../../main/ets/db/PreferenceStore';
import data_preferences from '@ohos.data.preferences';

export default function PreferenceStoreTest() {
  describe('PreferenceStoreTest', () => {
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
    getInstanceTest();
    getStoreSyncTest();
    putSyncTest();
    getSyncTest();
    clearTest();
    it('assertEqual', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'test'
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
    })
  })
}

function getInstanceTest() {
  it('getInstanceTest', 0, async (): Promise<void> => {
    let mocker: MockKit = new MockKit();
    let func: Function = mocker.mockFunc(PreferenceStore, PreferenceStore.getInstance);
    when(func)(ArgumentMatchers.any).afterReturn(PreferenceStore);
    expect(true).assertTrue();
    mocker.clear(PreferenceStore);
    mocker.clearAll();
  });
}

function getStoreSyncTest() {
  it('getStoreSyncTest', 0, async (): Promise<void> => {
    let mocker: MockKit = new MockKit();
    let func: Function = Reflect.get(PreferenceStore, 'getStoreSync');
    let func2: Function = mocker.mockFunc(PreferenceStore, func);
    when(func2)(ArgumentMatchers.any).afterReturn(data_preferences.getPreferences);
    expect(true).assertTrue();
    mocker.clear(PreferenceStore);
    mocker.clearAll();
  });
}

function putSyncTest() {
  it('putSyncTest', 0, async (): Promise<void> => {
    let mocker: MockKit = new MockKit();
    let func: Function = Reflect.get(PreferenceStore, 'putSync');
    let func2: Function = mocker.mockFunc(PreferenceStore, func);
    when(func2)(ArgumentMatchers.any).afterReturnNothing();
    expect(true).assertTrue();
    mocker.clear(PreferenceStore);
    mocker.clearAll();
  });
}

function getSyncTest() {
  it('getSyncTest', 0, async (): Promise<void> => {
    let mocker: MockKit = new MockKit();
    let func: Function = Reflect.get(PreferenceStore, 'putSync');
    let func2: Function = mocker.mockFunc(PreferenceStore, func);
    when(func2)(ArgumentMatchers.any).afterReturn(undefined);
    expect(true).assertTrue();
    mocker.clear(PreferenceStore);
    mocker.clearAll();
  });
}

function clearTest() {
  it('getSyncTest', 0, async (): Promise<void> => {
    let mocker: MockKit = new MockKit();
    let func: Function = Reflect.get(PreferenceStore, 'clear');
    let func2: Function = mocker.mockFunc(PreferenceStore, func);
    when(func2)(ArgumentMatchers.any).afterReturnNothing();
    expect(true).assertTrue();
    mocker.clear(PreferenceStore);
    mocker.clearAll();
  });
}
