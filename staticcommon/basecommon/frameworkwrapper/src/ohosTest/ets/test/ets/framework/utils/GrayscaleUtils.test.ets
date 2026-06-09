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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, DEFAULT } from '@ohos/hypium';
import { GrayscaleUtil } from '../../../../../../main/ets/utils/GrayscaleUtil';

const COLOR_PREFIX: string = '#';

export function GrayscaleUtilsTest() {
  describe('GrayscaleUtilsTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_calGrayscale_01', DEFAULT, (): void => {
      let colorStr: string = GrayscaleUtil.calGrayscale(1, 1, 1, 1);
      expect(colorStr).assertContain(COLOR_PREFIX);
    })

    it('test_calGrayscale_02', DEFAULT, (): void => {
      let colorStr: string = GrayscaleUtil.calGrayscale(255, 255, 255, 255);
      expect(colorStr).assertContain(COLOR_PREFIX);
    })

    it('test_dec2Hex_01', DEFAULT, (): void => {
      let color: string = (GrayscaleUtil as object)['dec2Hex'](1000, 1, '0');
      expect(color).not().assertUndefined();
    })

    it('test_dec2Hex_02', DEFAULT, (): void => {
      let color: string = (GrayscaleUtil as object)['dec2Hex'](-1000, 1, '0');
      expect(color).not().assertUndefined();
    })

    it('test_pow_01', DEFAULT, (): void => {
      let pow: number = (GrayscaleUtil as object)['pow'](-1, 1);
      expect(pow).assertEqual(-1);
    })
  })
}