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
import { describe, expect, it } from '@ohos/hypium';
import { ArrayUtils } from '@ohos/themeservicebase/Index';

export default function ArrayUtilsTest() {
  describe('ArrayUtilsTest', () => {
    it('Test001_isNull', 0, () => {
      expect(ArrayUtils.isNull<undefined>(undefined)).assertTrue();
      expect(ArrayUtils.isNull([])).assertTrue();
      expect(ArrayUtils.isNull(new Set<string>())).assertTrue();
      expect(ArrayUtils.isNull(new Set(["1"]))).assertFalse();
      expect(ArrayUtils.isNull(new Array())).assertTrue();
      expect(ArrayUtils.isNull(new Array("1"))).assertFalse();
    })

    it('Test002_size', 0, () => {
      expect(ArrayUtils.size<undefined>(undefined)).assertEqual(0);
      expect(ArrayUtils.size(new Set<number>())).assertEqual(0);
      expect(ArrayUtils.size(new Set([1, 2, 3]))).assertEqual(3);
      expect(ArrayUtils.size([1, 2, 3])).assertEqual(3);
    })

    it('Test003_isArray', 0, () => {
      expect(ArrayUtils.isArray([])).assertTrue();
      expect(ArrayUtils.isArray<undefined>(undefined)).assertFalse();
    })
        it('Test005_map_string', 0, () => {
      const expectedData: number[] = [1, 2, 3]
      const result: number[] = ArrayUtils.map<string, number>(['1', '2', '3'], (str: string) => parseInt(str))
      expect(result).assertDeepEquals(expectedData)
    });

    it('Test005_map_empty', 0, () => {
      const expectedData: number[] = []
      const result: number[] = ArrayUtils.map<string, number>(undefined, (str: string) => parseInt(str))
      expect(result).assertDeepEquals(expectedData)
    });
  })
}