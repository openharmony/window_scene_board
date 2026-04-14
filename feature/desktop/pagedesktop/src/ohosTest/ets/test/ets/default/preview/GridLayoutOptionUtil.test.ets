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
import { GridLayoutOptionUtil } from '../../../../../../main/ets/default/preview/GridLayoutOptionUtil'
import { GridLayoutItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';

export default function GridLayoutOptionUtilTest() {
  describe('GridLayoutOptionUtilTest', () => {
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
    it('assertEqual', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'test'
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
    })

    it("getGridLayoutOptions1", 0, async (done: Function) => {
      let appListInfo1: GridLayoutItemInfo[] = [];
      let result1: GridLayoutOptions = GridLayoutOptionUtil.getGridLayoutOptions(appListInfo1);
      expect(result1).not().assertUndefined();
      done();
    })

    it("getGridLayoutOptions2", 0, async (done: Function) => {
      let appListInfo2: GridLayoutItemInfo[] = new Array<GridLayoutItemInfo>()
      let result2: GridLayoutOptions = GridLayoutOptionUtil.getGridLayoutOptions(appListInfo2)
      expect(result2).not().assertUndefined();
      done();
    })

    it("getGridLayoutOptions3", 0, async (done: Function) => {
      let gridLayoutItemInfo: GridLayoutItemInfo = new Object({
        row: 1,
        column: 1,
        area: [1, 1]
      }) as GridLayoutItemInfo
      let appListInfo3: GridLayoutItemInfo[] = [gridLayoutItemInfo, gridLayoutItemInfo]
      let result3: GridLayoutOptions = GridLayoutOptionUtil.getGridLayoutOptions(appListInfo3)
      expect(result3).not().assertUndefined();
      done();
    })

    it("getGridLayoutOptions4", 0, async (done: Function) => {
      let gridLayoutItemInfo: GridLayoutItemInfo = new Object({
        row: 1,
        column: 1,
        area: [1, 1]
      }) as GridLayoutItemInfo;
      let appListInfo3: GridLayoutItemInfo[] = [gridLayoutItemInfo, gridLayoutItemInfo];
      let result1: GridLayoutOptions = GridLayoutOptionUtil.getGridLayoutOptions(appListInfo3);
      result1.onGetRectByIndex!(2);
      let result3 = result1.onGetRectByIndex!(2);
      expect(result3.length).assertEqual(4);
      done();
    })
  })
}