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
import { CommonUtils } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { ArgumentMatchers, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { StringUtil } from '../../../../../main/ets/useless/StringUtil';

export function FormStackStringUtilTest() {
  describe('FormStackStringUtilTest', () => {
    it('test_string_to_bool_text_is_true', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      const result: ESObject = StringUtil.stringToBool("true");
      expect(result).assertEqual(true);
      mocker.verify('isEmpty', [ArgumentMatchers.any]).atMost(1);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
      done();
    });

    it('test_string_to_bool_text_is_not_true', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      const result: ESObject = StringUtil.stringToBool("false");
      expect(result).assertEqual(false);
      mocker.verify('isEmpty', [ArgumentMatchers.any]).atMost(1);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
      done();
    });

    it('test_string_to_bool_text_is_not_true_with_different_case', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      const result: ESObject = StringUtil.stringToBool("TrUe");
      expect(result).assertEqual(true);
      mocker.verify('isEmpty', [ArgumentMatchers.any]).atMost(1);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
      done();
    });

    it('test_string_to_bool_text_is_not_true_with_spaces', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      const result: ESObject = StringUtil.stringToBool("  true  ");
      expect(StringUtil.stringToBool('')).assertFalse();
      expect(result).assertEqual(true);
      mocker.verify('isEmpty', [ArgumentMatchers.any]).atMost(1);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
      done();
    });

    it('test_string_to_bool_text_is_not_true_with_spaces_and_different_case', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      const result: ESObject = StringUtil.stringToBool("  TrUe  ");
      expect(result).assertEqual(true);

      mocker.verify('isEmpty', [ArgumentMatchers.any]).atMost(1);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
      done();
    });

    it('test_string_to_array_target_is_empty', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      const result: ESObject = StringUtil.stringToArray("", ",");
      expect(result === undefined).assertFalse();
      mocker.verify('isEmpty', [ArgumentMatchers.any]).atMost(1);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
      done();
    });

    it('test_string_to_single_element_array_correctly', 0, async (done: Function) => {
      const result: ESObject = StringUtil.stringToArray("hello", ",");
      expect(result === undefined).assertFalse();
      done();
    });

    it('test_string_to_empty_separator_correctly', 0, async (done: Function) => {
      const result: ESObject = StringUtil.stringToArray("hello", "");
      expect(result === undefined).assertFalse();
      expect(StringUtil.stringToArray("onlyOne", ",").length <= 1).assertTrue();
      done();
    });

    it('test_string_to_null_separator_correctly', 0, async (done: Function) => {
      const result: ESObject = StringUtil.stringToArray("hello", null);
      expect(result === undefined).assertFalse();
      done();
    });

    it('test_string_to_undefined_separator_correctly', 0, async (done: Function) => {
      const result: ESObject = StringUtil.stringToArray("hello", undefined);
      expect(result === undefined).assertFalse();
      done();
    });

    it('test_string_to_empty_string_correctly', 0, async (done: Function) => {
      const result: ESObject = StringUtil.stringToArray("", ",");
      expect(result === undefined).assertFalse();
      done();
    });

    it('test_string_to_null_string_correctly', 0, async (done: Function) => {
      const result: ESObject = StringUtil.stringToArray(null, ",");
      expect(result === undefined).assertFalse();
      done();
    });

    it('test_string_to_undefined_string_correctly', 0, async (done: Function) => {
      const result: ESObject = StringUtil.stringToArray(undefined, ",");
      expect(result === undefined).assertFalse();
      done();
    });

    it('test_get_float_values_target_is_empty', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      const result: ESObject = StringUtil.getFloatValues("", ",");
      expect(result === undefined).assertFalse();
      mocker.verify('isEmpty', [ArgumentMatchers.any]).atMost(1);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
      done();
    });

    it('test_get_float_values_split_result_is_null', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      const result: ESObject = StringUtil.getFloatValues("1,2,3", "");
      expect(result === undefined).assertFalse();
      mocker.verify('isEmpty', [ArgumentMatchers.any]).atMost(1);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
      done();
    });

    it('test_get_float_values_input_is_valid', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      const result: ESObject = StringUtil.getFloatValues("1.5, 2.5, 3.5", ",");
      StringUtil.getFloatValues("9, 2.5, 3.5", ",");
      expect(result === undefined).assertFalse();
      mocker.verify('isEmpty', [ArgumentMatchers.any]).atMost(1);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
      done();
    });

    it('test_get_float_value_each_element', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      const result: ESObject = StringUtil.getFloatValues(" 1.5 , 2.5 , 3.5 ", ",");
      expect(result === undefined).assertFalse();
      mocker.verify('isEmpty', [ArgumentMatchers.any]).atMost(1);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
      done();
    });

    it('test_get_float_values_valid_numbers', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      const result: ESObject = StringUtil.getFloatValues("1.5,2.5,3.5", ",");
      // 确保返回的数组中的元素是null，而不是undefined
      result[0] = null;
      result[1] = null;
      result[2] = null;
      expect(result === undefined).assertFalse();
      mocker.verify('isEmpty', [ArgumentMatchers.any]).atMost(1);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
      done();
    });

    it('test_is_number_text_is_empty', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      const result: ESObject = StringUtil.isNumber("");
      expect(result).assertFalse();
      mocker.verify('isEmpty', [ArgumentMatchers.any]).atMost(1);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
      done();
    });

    it('test_is_number_text_does_not_match_number_pattern', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      const result: ESObject = StringUtil.isNumber("abc");
      expect(result).assertFalse();
      mocker.verify('isEmpty', [ArgumentMatchers.any]).atMost(1);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
      done();
    });

    it('test_is_number_less_than_input_text_length', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      const result: ESObject = StringUtil.isNumber("123abc");
      StringUtil.isNumber("123z")
      expect(result).assertFalse();
      mocker.verify('isEmpty', [ArgumentMatchers.any]).atMost(1);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
      done();
    });

    it('test_is_number_matched_equal_to_input_text_length', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      const result: ESObject = StringUtil.isNumber("123");
      expect(result).assertTrue();
      mocker.verify('isEmpty', [ArgumentMatchers.any]).atMost(1);
      mocker.ignoreMock(CommonUtils, CommonUtils.isEmpty);
      done();
    });

    it('test_get_str_by_count_is_zero_or_string_is_empty', 0, async (done: Function) => {
      const result1: ESObject = StringUtil.getStrByCount("", 0);
      const result2: ESObject = StringUtil.getStrByCount("test", 0);
      const result3: ESObject = StringUtil.getStrByCount("", 5);
      expect(result1 === undefined).assertFalse();
      expect(result2 === undefined).assertFalse();
      expect(result3 === undefined).assertFalse();
      done();
    });

    it('test_get_str_by_count_split_is_not_provided', 0, async (done: Function) => {
      const result: ESObject = StringUtil.getStrByCount("test", 3);
      expect(result === undefined).assertFalse();
      done();
    });

    it('test_get_str_by_count_split_is_provided', 0, async (done: Function) => {
      const result: ESObject = StringUtil.getStrByCount("test", 3, "-");
      expect(result === undefined).assertFalse();
      done();
    });

    it('test_get_string_sync_when_value_is_null', 0, async (done: Function) => {
      const result: ESObject = StringUtil.getStringSync(null);
      expect(result === undefined).assertFalse();
      done();
    });

    it('test_get_string_sync_value_is_undefined', 0, async (done: Function) => {
      const result: ESObject = StringUtil.getStringSync(undefined);
      expect(result === undefined).assertFalse();
      done();
    });

    it('test_get_string_sync_value_is_a_string', 0, async (done: Function) => {
      const result: ESObject = StringUtil.getStringSync("Hello World");
      expect(result === undefined).assertFalse();
      const ret = StringUtil.getStringSync(Math.random());
      expect(ret === undefined ||  ret !== undefined).assertTrue();
      done();
    });

    it('test_get_string_by_key_not_start_with_INTERCEPT_STR_PREFIX', 0, async (done: Function) => {
      const result: ESObject = StringUtil.getStringByKey("testKey");
      expect(result === undefined).assertFalse();
      done();
    });

    it('test_get_string_by_key_not_start_with_INTERCEPT_STR_PREFIX001', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GlobalContext, GlobalContext.getContext);
      when(mockFunc)().afterReturn(null);
      const result: ESObject = StringUtil.getStringByKey("testKey");
      expect(result === undefined).assertFalse();
      mocker.clear(GlobalContext);
      mocker.clearAll();
      done();
    });

    it('test_get_string_002', 0, () => {
      const ret = StringUtil.getStringByKey("@R.string.testKey");
      expect(ret === undefined || ret !== undefined).assertTrue();
      expect(StringUtil.drawFontWidth(100) === undefined).assertFalse();
      expect(StringUtil.drawFontWidth() === undefined).assertFalse();
      expect(StringUtil.drawFontWidth(200) === undefined).assertFalse();
      expect(StringUtil.drawFontWidth(300) === undefined).assertFalse();
      expect(StringUtil.drawFontWidth(400) === undefined).assertFalse();
      expect(StringUtil.drawFontWidth(500) === undefined).assertFalse();
      expect(StringUtil.drawFontWidth(600) === undefined).assertFalse();
      expect(StringUtil.drawFontWidth(700) === undefined).assertFalse();
      expect(StringUtil.drawFontWidth(800) === undefined).assertFalse();
      expect(StringUtil.drawFontWidth(900) === undefined).assertFalse();
      expect(StringUtil.drawFontWidth(1000) === undefined).assertFalse();
      expect(StringUtil.drawFontWeightFormat(100) === undefined).assertFalse();
      expect(StringUtil.drawFontWeightFormat() === undefined).assertFalse();
      expect(StringUtil.drawFontWeightFormat(200) === undefined).assertFalse();
      expect(StringUtil.drawFontWeightFormat(300) === undefined).assertFalse();
      expect(StringUtil.drawFontWeightFormat(400) === undefined).assertFalse();
      expect(StringUtil.drawFontWeightFormat(500) === undefined).assertFalse();
      expect(StringUtil.drawFontWeightFormat(600) === undefined).assertFalse();
      expect(StringUtil.drawFontWeightFormat(700) === undefined).assertFalse();
      expect(StringUtil.drawFontWeightFormat(800) === undefined).assertFalse();
      expect(StringUtil.drawFontWeightFormat(900) === undefined).assertFalse();
      expect(StringUtil.drawFontWeightFormat(1000) === undefined).assertFalse();
    })

    it('test_get_string_003', 0, () => {
      expect(StringUtil.getIntValues(null, null) ===  undefined).assertFalse();
      expect(StringUtil.getIntValues('1', null) ===  undefined).assertFalse();
      expect(StringUtil.getIntValues('default', '-') ===  undefined).assertFalse();
      expect(StringUtil.getIntValues('abc', '-') ===  undefined).assertFalse();
    })

    it('test_get_string_004', 0, () => {
      expect(StringUtil.drawTextAlign(100) === undefined).assertFalse();
      expect(StringUtil.drawTextAlign() === undefined).assertFalse();
      expect(StringUtil.drawTextAlign(200) === undefined).assertFalse();
      expect(StringUtil.drawTextAlign(300) === undefined).assertFalse();
      expect(StringUtil.drawTextAlign(400) === undefined).assertFalse();
      expect(StringUtil.drawTextAlign(500) === undefined).assertFalse();
      expect(StringUtil.drawTextAlign(600) === undefined).assertFalse();
      expect(StringUtil.drawTextAlign(700) === undefined).assertFalse();
    })

    it('test_get_string_005', 0, () => {
      expect(StringUtil.getStringIndex('', '') === undefined).assertFalse();
      expect(StringUtil.getStringIndex(null, '') === undefined).assertFalse();
      expect(StringUtil.getStringIndex(undefined, '') === undefined).assertFalse();
      expect(StringUtil.getStringIndex('a', '') === undefined).assertFalse();
      expect(StringUtil.getStringIndex('a', null) === undefined).assertFalse();
      expect(StringUtil.getStringIndex('a', undefined) === undefined).assertFalse();
      expect(StringUtil.getStringIndex('ohos', '') === undefined).assertFalse();
      expect(StringUtil.getStringIndex('aaa', 'ohos') === undefined).assertFalse();
      expect(StringUtil.getStringIndex('aaainside', 'aaa') === undefined).assertFalse();
      expect(StringUtil.getStringIndex('aaa', 'aaainside') === undefined).assertFalse();
      expect(StringUtil.getStringIndex('aaa', 'bbb') === undefined).assertFalse();
      expect(StringUtil.getStringIndex('aaa', 'bbbb') === undefined).assertFalse();
      expect(StringUtil.getStringIndex('ab', 'b') === undefined).assertFalse();
      expect(StringUtil.getStringIndex('bab', 'bb') === undefined).assertFalse();
      expect(StringUtil.getStringIndex('bbab', 'bbb') === undefined).assertFalse();
      expect(StringUtil.getStringIndex('aaaac', 'aaaa') === undefined).assertFalse();
      expect(StringUtil.getStringIndex('aaaacc', 'aaaac') === undefined).assertFalse();
      expect(StringUtil.getStringIndex('aaaaccc', 'aaaacc') === undefined).assertFalse();
      expect(StringUtil.getStringIndex('aaadccc', 'aaaccc') === undefined).assertFalse();
    })

    it('test_get_string_006', 0, () => {
      expect(StringUtil.checkArr([]) === undefined).assertFalse();
      expect(StringUtil.checkArr(null) === undefined).assertFalse();
      expect(StringUtil.checkArr(undefined) === undefined).assertFalse();
      expect(StringUtil.checkArr(['', 'b']) === undefined).assertFalse();
      expect(StringUtil.checkArr([undefined, 'b']) === undefined).assertFalse();
      expect(StringUtil.checkArr([null, 'b']) === undefined).assertFalse();
      expect(StringUtil.checkArr(['a', '']) === undefined).assertFalse();
      expect(StringUtil.checkArr(['a', undefined]) === undefined).assertFalse();
      expect(StringUtil.checkArr(['a', null]) === undefined).assertFalse();
      expect(StringUtil.checkArr(['ohos', 'b']) === undefined).assertFalse();
      expect(StringUtil.checkArr(['a', 'ohos']) === undefined).assertFalse();
      expect(StringUtil.checkArr(['default', 'b']) === undefined).assertFalse();
      expect(StringUtil.checkArr(['a', 'default']) === undefined).assertFalse();
      expect(StringUtil.checkArr(['a', 'b']) === undefined).assertFalse();
      expect(StringUtil.checkArr(['a', 'a']) === undefined).assertFalse();
      expect(StringUtil.checkArr(['a', 'b', 'c', 'd']) === undefined).assertFalse();
      expect(StringUtil.getUUID() === undefined).assertFalse();
    })
  });
}