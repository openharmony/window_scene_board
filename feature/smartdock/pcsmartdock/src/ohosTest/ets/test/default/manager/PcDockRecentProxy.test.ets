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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { PcDockRecentProxy } from '../../../../../main/ets/default/manager/PcDockRecentProxy'

export default function PcDockRecentProxyTest() {
  describe('PcDockRecentProxyTest', () => {
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

    it('test_getInstance', 0, test_getInstance);
    it('test_registerDockRecent', 0, test_registerDockRecent);
    it('test_enterRecent', 0, test_enterRecent1);
    it('test_enterRecent', 0, test_enterRecent2);
    it('test_enterAppCenter', 0, test_enterAppCenter1);
    it('test_enterAppCenter', 0, test_enterAppCenter2);
  })
}

function test_getInstance() {
  try {
    let instance = PcDockRecentProxy.getInstance();
    expect(instance instanceof PcDockRecentProxy).assertTrue();
  } catch {
    expect(false).assertTrue();
  }
}

function test_registerDockRecent() {
  try {
    let instance = PcDockRecentProxy.getInstance();
    instance['dockRecent'] = {
      enterRecent: (() => {}),
      enterAppCenter: ((screenId: number = 0) => {}),
    }
    instance.registerDockRecent({
      enterRecent: (() => {}),
      enterAppCenter: ((screenId: number = 0) => {}),
    })
  } catch {
    expect(false).assertTrue();
  }
}

function test_enterRecent1() {
  try {
    let instance = PcDockRecentProxy.getInstance();
    instance.enterRecent();
  } catch {
    expect(false).assertTrue();
  }
}

function test_enterRecent2() {
  try {
    let instance = PcDockRecentProxy.getInstance();
    instance['dockRecent'] = {
      enterRecent: (() => {}),
      enterAppCenter: ((screenId: number = 0) => {}),
    }
    instance.enterRecent();
  } catch {
    expect(false).assertTrue();
  }
}

function test_enterAppCenter1() {
  try {
    let instance = PcDockRecentProxy.getInstance();
    instance.enterAppCenter()
  } catch {
    expect(false).assertTrue();
  }
}

function test_enterAppCenter2() {
  try {
    let instance = PcDockRecentProxy.getInstance();
    instance['dockRecent'] = {
      enterRecent: (() => {}),
      enterAppCenter: ((screenId: number = 0) => {}),
    }
    instance.enterAppCenter()
  } catch {
    expect(false).assertTrue();
  }
}