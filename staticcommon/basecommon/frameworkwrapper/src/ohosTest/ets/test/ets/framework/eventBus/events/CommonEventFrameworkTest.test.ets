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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { CommonEvent, SplitScreenEvent, PackageCommonEvent } from '../../../../../../../main/ets/TsIndex';

export function CommonEventFrameworkTest() {
  describe('CommonEventFrameworkTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_constructor', 0, (): void => {
      let mCommonEvt: CommonEvent = new CommonEvent({
        event:'mTest',
        bundleName:'mbundleName',
        code:0,
        data:'mData'
      })
      let mPackageCommonEvt: PackageCommonEvent = new PackageCommonEvent({
        event:'mTest1',
        bundleName:'mbundleName1',
        code:1,
        data:'mData1'
      })
      let mSplitScreenEvt: SplitScreenEvent = new SplitScreenEvent({
        event:'mTest2',
        bundleName:'mbundleName2',
        code:2,
        data:'mData2'
      })
      expect(mSplitScreenEvt.windowMode).assertUndefined();
    })
  })
}