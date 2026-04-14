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
import { describe, expect, it, TestType } from '@ohos/hypium';
import { StringUtils } from '../../main/ets/themeservice/kit/util/StringUtils';

export default function stringUtilsTest() {
  describe('StringUtilsTest', () => {
    it('isEmpty_true', TestType.FUNCTION, async () => {
      expect(StringUtils.isEmpty(``)).assertTrue();
      expect(StringUtils.isEmpty(null)).assertTrue();
      expect(StringUtils.isEmpty(undefined)).assertTrue();
      expect(StringUtils.isEmpty('')).assertTrue();
    })

    it('isEmpty_false', TestType.FUNCTION, async () => {
      expect(StringUtils.isEmpty(`test`)).assertFalse();
    })

    it('join', TestType.FUNCTION, async () => {
      expect(StringUtils.join(`,`, ["a,b,c"])).assertEqual('a,b,c');
    })

    it('equals', TestType.FUNCTION, async () => {
      expect(StringUtils.equals(``,``)).assertTrue();
      expect(StringUtils.equals(`1`,`1`)).assertTrue();
      expect(StringUtils.equals(`2`,`1`)).assertFalse();
      expect(StringUtils.equals(`2`,`11`)).assertFalse();
    })

  });
}