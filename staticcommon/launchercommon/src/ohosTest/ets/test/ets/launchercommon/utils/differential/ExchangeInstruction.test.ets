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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import { ExchangeInstruction } from '../../../../../../../main/ets/utils/differential/ExchangeInstruction';
import { GridLayoutItemInfo } from '../../../../../../../main/ets/TsIndex';


export default function ExchangeInstructionTest() {
  describe('ExchangeInstructionTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('ExchangeInstruction_execute', 0, (): void => {
      let gridLayoutInfo = [{
        bundleName:'com.ohos.photos',
        page: 0,
        row: 1,
        column: 1,
        container: -100
      }, {
        bundleName:'com.ohos.photos2',
        page: 1,
        row: 2,
        column: 2,
        container: -101
      }] as GridLayoutItemInfo[];
      let item = {
        operation: 'exchange',
        replacement: 'com.ohos.photos',
        settlement: 'com.ohos.photos1',
      } as GridLayoutItemInfo;
      let ExchangeExe: ExchangeInstruction = new ExchangeInstruction(6,4);
      let newLayout = ExchangeExe.execute(gridLayoutInfo, item);
      expect(newLayout.length).assertEqual(gridLayoutInfo.length);
    })
  })
}
