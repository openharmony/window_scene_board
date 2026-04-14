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
import { StringUtils } from '@ohos/themeservicebase/Index';

export default function StringUtilsTest() {
  describe('StringUtilsTest_isEmpty', () => {
    it('isEmpty_true', TestType.FUNCTION, async () => {
      expect(StringUtils.isEmpty(``)).assertTrue();
      expect(StringUtils.isEmpty(undefined)).assertTrue();
      expect(StringUtils.isEmpty(undefined)).assertTrue();
      expect(StringUtils.isEmpty('')).assertTrue();
      expect(StringUtils.isEmpty('   ')).assertTrue();
    })

    it('isEmpty_false', TestType.FUNCTION, async () => {
      expect(StringUtils.isEmpty(`test`)).assertFalse();
    })
  });

  describe('StringUtilsTest_equals', () => {
    it('should_return_true_when_both_strings_are_undefined', 0, async (done: Function) => {
      const result = StringUtils.equals(undefined, undefined);
      expect(result).assertTrue();
      done();
    });

    it('should_return_false_when_first_string_is_undefined_and_second_is_not', 0, async (done: Function) => {
      const result = StringUtils.equals(undefined, "Hello");
      expect(result).assertFalse();
      done();
    });

    it('should_return_false_when_first_string_is_not_and_second_is_undefined', 0, async (done: Function) => {
      const result = StringUtils.equals("Hello", undefined);
      expect(result).assertFalse();
      done();
    });

    it('should_return_true_when_both_strings_are_null', 0, async (done: Function) => {
      const result = StringUtils.equals(undefined, undefined);
      expect(result).assertTrue();
      done();
    });

    it('should_return_false_when_first_string_is_null_and_second_is_not', 0, async (done: Function) => {
      const result = StringUtils.equals(undefined, "Hello");
      expect(result).assertFalse();
      done();
    });

    it('should_return_false_when_first_string_is_not_and_second_is_null', 0, async (done: Function) => {
      const result = StringUtils.equals("Hello", undefined);
      expect(result).assertFalse();
      done();
    });

    it('should_return_true_when_both_strings_are_equal', 0, async (done: Function) => {
      const result = StringUtils.equals("Hello", "Hello");
      expect(result).assertTrue();
      done();
    });

    it('should_return_false_when_strings_are_not_equal', 0, async (done: Function) => {
      const result = StringUtils.equals("Hello", "World");
      expect(result).assertFalse();
      done();
    });

    it('should_handle_mixed_case_strings_correctly', 0, async (done: Function) => {
      const result = StringUtils.equals("Hello", "hello");
      expect(result).assertFalse();
      done();
    });

    it('should_handle_empty_strings_correctly', 0, async (done: Function) => {
      const result = StringUtils.equals("", "");
      expect(result).assertTrue();
      done();
    });
  });

  describe('StringUtilsTest_join', () => {
    it('join_abc', TestType.FUNCTION, async () => {
      expect(StringUtils.join(`,`, ["a,b,c"])).assertEqual('a,b,c');
    })
    it('join_empty', TestType.FUNCTION, async () => {
      expect(StringUtils.join(`,`, [])).assertEqual('');
    })
  });
}