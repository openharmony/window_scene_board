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
import { PcTouchOutSideMgr, TouchOutsideListener } from '../../../../../main/ets/default/manager/PcTouchOutSideMgr'

export default function PcTouchOutSideMgrTest() {
  describe('PcTouchOutSideMgrTest', () => {
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
    it('test_getInstance1', 0, test_getInstance1);
    it('test_getInstance2', 0, test_getInstance2);
    it('test_registerDataChangeListener1', 0, test_registerDataChangeListener1);
    it('test_registerDataChangeListener2', 0, test_registerDataChangeListener2);
    it('test_unregisterDataChangeListener', 0, test_unregisterDataChangeListener);
    it('test_notifyTouchOutside', 0, test_notifyTouchOutside);
  })
}

function test_getInstance1() {
  try {
    const instance = PcTouchOutSideMgr.getInstance();
    expect(instance instanceof PcTouchOutSideMgr).assertTrue();
  } catch {
    expect(false).assertTrue();
  }
}

function test_getInstance2() {
  try {
    PcTouchOutSideMgr.getInstance();
    const instance = PcTouchOutSideMgr.getInstance();
    expect(instance instanceof PcTouchOutSideMgr).assertTrue();
  } catch {
    expect(false).assertTrue();
  }
}

function test_registerDataChangeListener1() {
  try {
    let listener: TouchOutsideListener = {
      onDealTouchOutside: (x: number, y: number) => {}
    }
    const instance = PcTouchOutSideMgr.getInstance();
    instance.registerDataChangeListener(listener);
  } catch {
    expect(false).assertTrue();
  }
}

function test_registerDataChangeListener2() {
  try {
    let listener: TouchOutsideListener = {
      onDealTouchOutside: (x: number, y: number) => {}
    }
    const instance = PcTouchOutSideMgr.getInstance();
    instance.registerDataChangeListener(listener);
    instance.registerDataChangeListener(listener);
  } catch {
    expect(false).assertTrue();
  }
}

function test_unregisterDataChangeListener() {
  try {
    let listener: TouchOutsideListener = {
      onDealTouchOutside: (x: number, y: number) => {}
    }
    const instance = PcTouchOutSideMgr.getInstance();
    instance.registerDataChangeListener(listener);
    instance.unregisterDataChangeListener(listener);
  } catch {
    expect(false).assertTrue();
  }
}

function test_notifyTouchOutside() {
  try {
    let listener: TouchOutsideListener = {
      onDealTouchOutside: (x: number, y: number) => {}
    }
    const instance = PcTouchOutSideMgr.getInstance();
    const x = 1;
    const y = 1;
    instance.registerDataChangeListener(listener);
    instance.notifyTouchOutside(x, y);
  } catch {
    expect(false).assertTrue();
  }
}