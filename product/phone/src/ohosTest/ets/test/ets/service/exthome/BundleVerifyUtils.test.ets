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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { BundleVerifyUtils } from '@ohos/phonebase/src/main/ets/service/exthome/BundleVerifyUtils';

/**
 * BundleVerifyUtils DT测试套
 */
export default function BundleVerifyUtilsTest() {
  describe('BundleVerifyUtilsTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('BundleVerifyUtils_isSystemApp_return_true', Level.LEVEL0, (done: Function) => {
      let result: boolean = BundleVerifyUtils.isSystemApp('com.ohos.sceneboard');
      expect(result).assertTrue();
      done();
    })

    it('BundleVerifyUtils_isSystemApp_return_false', Level.LEVEL0, (done: Function) => {
      let result: boolean = BundleVerifyUtils.isSystemApp('com.test');
      expect(result).assertFalse();
      done();
    })

    it('BundleVerifyUtils_hasPermission_return_true', Level.LEVEL0, (done: Function) => {
      let result: boolean = BundleVerifyUtils.hasPermission('com.ohos.sceneboard','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
      expect(result).assertTrue();
      done();
    })

    it('BundleVerifyUtils_hasPermission_return_false', Level.LEVEL0, (done: Function) => {
      let result1: boolean = BundleVerifyUtils.hasPermission('com.test.test','ohos.permission.ACCESS_SCREEN_LOCK_INNER');
      expect(result1).assertFalse();
      let result2: boolean = BundleVerifyUtils.hasPermission('com.ohos.sceneboard','ohos.permission.TEST');
      expect(result2).assertFalse();
      done();
    })
  })
}