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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { LiveSortPriority, LiveViewHelper } from 'liveview/src/main/ets/common/LiveViewHelper';

enum SysTypeCode {
  PHONE = 0,
  SCREEN_RECORDING = 1,
};

export default function LiveViewHelperTest() {
  describe('LiveViewHelperTest', () => {
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

    test1();
    test2();
  })
}

function test1() {
  it('getLiveEntryPriority_001', 0, () => {
    const priority = LiveViewHelper.getLiveEntryPriority(Object({
      sysTypeCode: SysTypeCode.PHONE
    }));
    expect(priority).assertEqual(LiveSortPriority.PHONE);
  })

  it('getLiveEntryPriority_003', 0, () => {
    expect(LiveViewHelper.getLiveEntryPriority()).assertEqual(LiveSortPriority.NORMAL);
  })

  it('isScreenRecordCapsule_001', 0, () => {
    const isScreenRecordCapsule = LiveViewHelper.isScreenRecordCapsule(Object({
      sysTypeCode: SysTypeCode.SCREEN_RECORDING,
      isSysTypeCode: () => true,
    }));
    expect(isScreenRecordCapsule).assertTrue();
  })
}

function test2() {
  it('sortLiveEntry_001', 0, () => {
    const sortRes = LiveViewHelper.sortLiveEntry(Object({
      sysTypeCode: SysTypeCode.PHONE
    }), Object({
      sysTypeCode: SysTypeCode.SCREEN_RECORDING
    }));
    expect(sortRes).not().assertEqual(0);
  })

  it('sortLiveEntry_002', 0, () => {
    const sortRes = LiveViewHelper.sortLiveEntry(Object({
      createTime: 1000
    }), Object({
      createTime: 2000
    }));
    expect(sortRes).not().assertEqual(0);
  })

  it('sortLiveEntry_003', 0, () => {
    const sortRes = LiveViewHelper.sortLiveEntry(Object(), Object({
      createTime: 2000
    }));
    expect(sortRes).not().assertEqual(0);
  })

  it('sortLiveEntry_004', 0, () => {
    const sortRes = LiveViewHelper.sortLiveEntry(Object({
      createTime: 1000
    }), Object());
    expect(sortRes).not().assertEqual(0);
  })

  it('sortLiveEntry_005', 0, () => {
    const sortRes = LiveViewHelper.sortLiveEntry(Object(), Object());
    expect(sortRes).assertEqual(0);
  })
}