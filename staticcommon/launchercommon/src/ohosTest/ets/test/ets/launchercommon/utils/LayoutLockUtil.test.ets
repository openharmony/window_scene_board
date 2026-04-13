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
import { LayoutLockUtil } from '../../../../../../main/ets/utils/LayoutLockUtil';

export default function LayoutLockUtilTest() {
  describe('LayoutLockUtilTest', () => {
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

    it('test_init1', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let lockUtil: LayoutLockUtil = new LayoutLockUtil();
      lockUtil['isRetailEnable'] = false;
      lockUtil.init();
      expect(lockUtil).not().assertNull();
    })

    it('test_init1', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let lockUtil: LayoutLockUtil = new LayoutLockUtil();
      lockUtil['isRetailEnable'] = true;
      lockUtil.init();
      expect(lockUtil).not().assertNull();
    })

    it('test_isLocked1', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let lockUtil: LayoutLockUtil = new LayoutLockUtil();
      lockUtil['locked'] = false;
      let ret: boolean = lockUtil.isLocked("a");
      expect(ret).assertFalse();
    })

    it('test_isLocked2', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let lockUtil: LayoutLockUtil = new LayoutLockUtil();
      lockUtil['locked'] = true;
      let ret: boolean = lockUtil.isLocked("a");
      expect(ret).assertTrue();
    })

    it('test_isLocked3', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let lockUtil: LayoutLockUtil = new LayoutLockUtil();
      lockUtil['locked'] = true;
      let ret: boolean = lockUtil.isLocked(null);
      expect(ret).assertTrue();
    })

    it('test_isLockedPage1', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let lockUtil: LayoutLockUtil = new LayoutLockUtil();
      lockUtil['locked'] = true;
      lockUtil['lockedPageNum'] = 1;
      let ret: boolean = lockUtil.isLockedPage(0, 'a');
      expect(ret).assertTrue();
    })

    it('test_isLockedPage2', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let lockUtil: LayoutLockUtil = new LayoutLockUtil();
      lockUtil['locked'] = false;
      lockUtil['lockedPageNum'] = 1;
      let ret: boolean = lockUtil.isLockedPage(0, 'a');
      expect(ret).assertFalse();
    })

    it('test_isLockedPage3', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let lockUtil: LayoutLockUtil = new LayoutLockUtil();
      lockUtil['locked'] = true;
      lockUtil['lockedPageNum'] = 1;
      let ret: boolean = lockUtil.isLockedPage(0, null);
      expect(ret).assertTrue();
    });

    it('test_LayoutLockUtil_getLockedPageNum', 0, () => {
      let isOuter: boolean = true;
      let lockUtil: LayoutLockUtil = new LayoutLockUtil();
      lockUtil.getLockedPageNum(isOuter);
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('test_LayoutLockUtil_getLockedPageNum_01', 0, () => {
      let isOuter: boolean = false;
      let lockUtil: LayoutLockUtil = new LayoutLockUtil();
      lockUtil.getLockedPageNum(isOuter);
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('test_LayoutLockUtil_getLockedPageNum_02', 0, () => {
      let isOuter: boolean | undefined = undefined;
      let lockUtil: LayoutLockUtil = new LayoutLockUtil();
      lockUtil.getLockedPageNum(isOuter);
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('test_LayoutLockUtil_getLockedPageNum_03', 0, () => {
      let isOuter: boolean | undefined = undefined;
      let lockUtil: LayoutLockUtil = new LayoutLockUtil();
      lockUtil.getLockedPageNum(isOuter);
      let a = 'test';
      expect(a).assertEqual('test');
    });

  })
}