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
import { AppGridItemInfo } from '../../../../../../main/ets/bean/AppGridItemInfo'
import { AppItemInfo } from '../../../../../../main/ets/TsIndex'
import type rdb from '@ohos.data.relationalStore';

export default function AppGridItemInfoTest() {
  describe('AppGridItemInfoTest', () => {
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
    it('test_toValuesBucket', 0, () => {
      const appGridItemInfo: AppGridItemInfo = new AppGridItemInfo();
      expect(AppGridItemInfo.toValuesBucket(undefined)).not().assertNull();
      expect(AppGridItemInfo.toValuesBucket(appGridItemInfo)).not().assertNull();
    })

    it('test_fromAppItemInfo', 0, () => {
      const appGridItemInfo: AppGridItemInfo = new AppGridItemInfo();
      const appItemInfo: AppItemInfo = new AppItemInfo()
      expect(appGridItemInfo.fromAppItemInfo(undefined) === appGridItemInfo).assertTrue();
      expect(appGridItemInfo.fromAppItemInfo(appItemInfo) === appGridItemInfo).assertTrue();
    })

    it('test_fromResultSet', 0, () => {
      const obj: rdb.ResultSet = {
        getColumnIndex: (columnIndex: string) => 1,
        getLong: (columnIndex: number) => 1,
        getString: (columnIndex: number) => '1',
      } as rdb.ResultSet;
      expect(AppGridItemInfo.fromResultSet(undefined)).assertUndefined();
      expect(AppGridItemInfo.fromResultSet(obj)).not().assertNull();
    })
  })
}