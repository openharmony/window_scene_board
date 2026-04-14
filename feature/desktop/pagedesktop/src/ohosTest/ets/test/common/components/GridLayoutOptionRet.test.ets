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
import { GridLayoutOptionRet } from '../../../../../main/ets/default/common/components/GridLayoutOptionRet'
import { GridLayoutItemInfo } from '@ohos/launchercommon';

export default function GridLayoutOptionRetTest() {
  describe('GridLayoutOptionRetTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    it('assertEqual', 0, () => {
      let appListInfo: GridLayoutItemInfo[] = [];
      let retValue: GridLayoutOptions =  GridLayoutOptionRet.getGridLayoutOptions(appListInfo);
      expect(retValue.regularSize[0]).assertEqual(1);
      expect(retValue.regularSize[1]).assertEqual(1);

      let gridInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      gridInfo.row = 1;
      gridInfo.column = 2;
      gridInfo.area = [0, 0];
      appListInfo = [gridInfo];
      retValue =  GridLayoutOptionRet.getGridLayoutOptions(appListInfo);
      if (retValue.onGetRectByIndex) {
        let retArray = retValue?.onGetRectByIndex(2);
        expect(retArray[0]).assertEqual(-1);
        expect(retArray[2]).assertEqual(-1);
        retArray = retValue.onGetRectByIndex(0);
        expect(retArray[0]).assertEqual(gridInfo?.row);
        expect(retArray[1]).assertEqual(gridInfo?.column);
        expect(retArray[2]).assertEqual(gridInfo?.area[1]);
        expect(retArray[3]).assertEqual(gridInfo?.area[0]);
      }
    })
  })
}
