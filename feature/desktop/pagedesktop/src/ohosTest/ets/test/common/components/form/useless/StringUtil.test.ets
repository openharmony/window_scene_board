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
import { StringUtil } from '../../../../../../../main/ets/default/common/components/form/useless/StringUtil';

export function FormStringUtilTest() {
  describe('FormStringUtilTest', () => {
    it('test_string_to_bool_text', 0, () => {
      expect(StringUtil.getSum("", '1') === -1).assertEqual(true);
      expect(StringUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(StringUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(StringUtil.getSum('1', '') === -1).assertEqual(true);
      expect(StringUtil.getSum('1', null) === -1).assertEqual(true);
      expect(StringUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(StringUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('test_string_to_array_target_is_empty', 0, () => {
      expect(StringUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(StringUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(StringUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(StringUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(StringUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(StringUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(StringUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('test_get_float_values_target_is_empty', 0, () => {
      expect(StringUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(StringUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(StringUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(StringUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(StringUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(StringUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(StringUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('test_get_string_003', 0, () => {
      expect(StringUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(StringUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(StringUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(StringUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(StringUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(StringUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(StringUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('test_is_number_text_is_empty', 0, () => {
      expect(StringUtil.isNumber("")).assertFalse();
      expect(StringUtil.isNumber(null)).assertFalse();
      expect(StringUtil.isNumber(undefined)).assertFalse();
      expect(StringUtil.isNumber("abc")).assertFalse();
      expect(StringUtil.isNumber("123")).assertTrue();
    });

    it('test_get_str_by_count_is_zero_or_string_is_empty', 0, () => {
      expect(StringUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(StringUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(StringUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(StringUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(StringUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(StringUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('test_get_string_sync_when_value_is_null', 0, () => {
      expect(StringUtil.getDefaultId(null) === null).assertTrue();
      expect(StringUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(StringUtil.getDefaultId('') === '').assertTrue();
      expect(StringUtil.getDefaultId('default') !== '').assertTrue();
      expect(StringUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(StringUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('test_get_string_by_key_not_start_with_INTERCEPT_STR_PREFIX', 0, () => {
      expect(StringUtil.getIndexByString("", []) === -1).assertTrue();
      expect(StringUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(StringUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(StringUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(StringUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(StringUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(StringUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('test_get_string_002', 0, () => {
      expect(StringUtil.drawFontWidth() === -1).assertTrue();
      expect(StringUtil.drawFontWidth(100) === 1).assertTrue();
      expect(StringUtil.drawFontWidth(200) === 2).assertTrue();
      expect(StringUtil.drawFontWidth(300) === 3).assertTrue();
      expect(StringUtil.drawFontWidth(400) === 4).assertTrue();
      expect(StringUtil.drawFontWidth(500) === 6).assertTrue();
      expect(StringUtil.drawFontWidth(600) === 7).assertTrue();
      expect(StringUtil.drawFontWidth(700) === 8).assertTrue();
      expect(StringUtil.drawFontWidth(800) === 9).assertTrue();
      expect(StringUtil.drawFontWidth(900) === 1).assertTrue();
      expect(StringUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(StringUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(StringUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(StringUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(StringUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(StringUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(StringUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(StringUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(StringUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(StringUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(StringUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(StringUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('test_get_string_004', 0, () => {
      expect(StringUtil.drawTextAlign() === -1).assertTrue();
      expect(StringUtil.drawTextAlign(100) === 0).assertTrue();
      expect(StringUtil.drawTextAlign(200) === 1).assertTrue();
      expect(StringUtil.drawTextAlign(300) === 2).assertTrue();
      expect(StringUtil.drawTextAlign(400) === 3).assertTrue();
      expect(StringUtil.drawTextAlign(500) === 4).assertTrue();
      expect(StringUtil.drawTextAlign(600) === 5).assertTrue();
      expect(StringUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('test_get_string_005', 0, () => {
      expect(StringUtil.getStringIndex('', '') === -1).assertTrue();
      expect(StringUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(StringUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(StringUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(StringUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(StringUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(StringUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(StringUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(StringUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(StringUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(StringUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(StringUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(StringUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(StringUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(StringUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(StringUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(StringUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(StringUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(StringUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('test_get_string_006', 0, () => {
      expect(StringUtil.checkArr([]) === false).assertTrue();
      expect(StringUtil.checkArr(null) === false).assertTrue();
      expect(StringUtil.checkArr(undefined) === false).assertTrue();
      expect(StringUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(StringUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(StringUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(StringUtil.checkArr(['a', '']) === false).assertTrue();
      expect(StringUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(StringUtil.checkArr(['a', null]) === false).assertTrue();
      expect(StringUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(StringUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(StringUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(StringUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(StringUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(StringUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(StringUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(StringUtil.getUUID().length > 0).assertTrue();
    })

    it('test_get_string_007', 0, () => {
      expect(StringUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(StringUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })
  });
}