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
import CellAndSpan from '../../../../../../../main/ets/service/reorder/CellAndSpan';

/**
 * CellAndSpan DT测试套
 */
export function CellAndSpanTest() {
  describe('CellAndSpanTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_copyFrom', Level.LEVEL0, (): void => {
      let cellAndSpan1: CellAndSpan = new CellAndSpan(0, 0, 0, 0);
      let cellAndSpan2: CellAndSpan = new CellAndSpan(0, 0, 0, 0);
      cellAndSpan1.copyFrom(null);
      let string1: String = cellAndSpan1.toString();
      let string2: String = cellAndSpan2.toString();
      expect(string1).assertEqual(string2);
      cellAndSpan2.setCellX(1);
      cellAndSpan2.setCellY(1);
      cellAndSpan2.setSpanX(1);
      cellAndSpan2.setSpanY(1);
      cellAndSpan1.copyFrom(cellAndSpan2);
      string1 = cellAndSpan1.toString();
      string2 = cellAndSpan2.toString();
      expect(string1).assertEqual(string2);
    })

    it('test_isSpanValid', Level.LEVEL0, (): void => {
      let cellAndSpan: CellAndSpan = new CellAndSpan(0, 0, 0, 0);
      let res: boolean = cellAndSpan.isSpanValid();
      expect(res).assertFalse();
      cellAndSpan.setSpanY(1);
      res = cellAndSpan.isSpanValid();
      expect(res).assertFalse();
      cellAndSpan.setSpanX(1);
      res = cellAndSpan.isSpanValid();
      expect(res).assertTrue();
    })
  })
}