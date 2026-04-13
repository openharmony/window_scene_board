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
import { StringUtilBeta } from '../../../../../../../main/ets/default/common/components/form/useless/StringUtilBeta';

export function FormStringUtilBetaTest() {
  describe('FormStringUtilBetaTest', () => {
    it('test_string_to_bool_text', 0, () => {
      expect(StringUtilBeta.getSum("", '1') === -1).assertEqual(true);
      expect(StringUtilBeta.getSum(null, '1') === -1).assertEqual(true);
      expect(StringUtilBeta.getSum(undefined, '1') === -1).assertEqual(true);
      expect(StringUtilBeta.getSum('1', '') === -1).assertEqual(true);
      expect(StringUtilBeta.getSum('1', null) === -1).assertEqual(true);
      expect(StringUtilBeta.getSum('1', undefined) === -1).assertEqual(true);
      expect(StringUtilBeta.getSum('1', '2') === 3).assertEqual(true);
    });

    it('test_string_to_array_target_is_empty', 0, () => {
      expect(StringUtilBeta.stringToArray("", ",").length === 0).assertTrue();
      expect(StringUtilBeta.stringToArray(null, ",").length === 0).assertTrue();
      expect(StringUtilBeta.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(StringUtilBeta.stringToArray("abc", null).length === 0).assertTrue();
      expect(StringUtilBeta.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(StringUtilBeta.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(StringUtilBeta.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('test_get_float_values_target_is_empty', 0, () => {
      expect(StringUtilBeta.getFloatValues("", ",").length === 0).assertTrue();
      expect(StringUtilBeta.getFloatValues(null, ",").length === 0).assertTrue();
      expect(StringUtilBeta.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(StringUtilBeta.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(StringUtilBeta.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(StringUtilBeta.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(StringUtilBeta.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('test_get_string_003', 0, () => {
      expect(StringUtilBeta.getIntValues("", ",").length === 0).assertTrue();
      expect(StringUtilBeta.getIntValues(null, ",").length === 0).assertTrue();
      expect(StringUtilBeta.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(StringUtilBeta.getIntValues("123.1", null).length === 0).assertTrue();
      expect(StringUtilBeta.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(StringUtilBeta.getIntValues("-123", ',').length === 0).assertTrue();
      expect(StringUtilBeta.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('test_is_number_text_is_empty', 0, () => {
      expect(StringUtilBeta.isNumber("")).assertFalse();
      expect(StringUtilBeta.isNumber(null)).assertFalse();
      expect(StringUtilBeta.isNumber(undefined)).assertFalse();
      expect(StringUtilBeta.isNumber("abc")).assertFalse();
      expect(StringUtilBeta.isNumber("123")).assertTrue();
    });

    it('test_get_str_by_count_is_zero_or_string_is_empty', 0, () => {
      expect(StringUtilBeta.getStrByCount(null , 1) === '').assertTrue();
      expect(StringUtilBeta.getStrByCount('' , 1) === '').assertTrue();
      expect(StringUtilBeta.getStrByCount(undefined , 1) === '').assertTrue();
      expect(StringUtilBeta.getStrByCount('abc' , 0) === '').assertTrue();
      expect(StringUtilBeta.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(StringUtilBeta.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('test_get_string_sync_when_value_is_null', 0, () => {
      expect(StringUtilBeta.getDefaultId(null) === null).assertTrue();
      expect(StringUtilBeta.getDefaultId(undefined) === undefined).assertTrue();
      expect(StringUtilBeta.getDefaultId('') === '').assertTrue();
      expect(StringUtilBeta.getDefaultId('default') !== '').assertTrue();
      expect(StringUtilBeta.getDefaultId('aaa') !== '').assertTrue();
      expect(StringUtilBeta.getDefaultId('ohos') === '').assertTrue();
    });

    it('test_get_string_by_key_not_start_with_INTERCEPT_STR_PREFIX', 0, () => {
      expect(StringUtilBeta.getIndexByString("", []) === -1).assertTrue();
      expect(StringUtilBeta.getIndexByString(null, []) === -1).assertTrue();
      expect(StringUtilBeta.getIndexByString(undefined, []) === -1).assertTrue();
      expect(StringUtilBeta.getIndexByString('aaa', null) === -1).assertTrue();
      expect(StringUtilBeta.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(StringUtilBeta.getIndexByString('aaa', []) === -1).assertTrue();
      expect(StringUtilBeta.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('test_get_string_002', 0, () => {
      expect(StringUtilBeta.drawFontWidth() === -1).assertTrue();
      expect(StringUtilBeta.drawFontWidth(100) === 1).assertTrue();
      expect(StringUtilBeta.drawFontWidth(200) === 2).assertTrue();
      expect(StringUtilBeta.drawFontWidth(300) === 3).assertTrue();
      expect(StringUtilBeta.drawFontWidth(400) === 4).assertTrue();
      expect(StringUtilBeta.drawFontWidth(500) === 6).assertTrue();
      expect(StringUtilBeta.drawFontWidth(600) === 7).assertTrue();
      expect(StringUtilBeta.drawFontWidth(700) === 8).assertTrue();
      expect(StringUtilBeta.drawFontWidth(800) === 9).assertTrue();
      expect(StringUtilBeta.drawFontWidth(900) === 1).assertTrue();
      expect(StringUtilBeta.drawFontWidth(1000) === 5).assertTrue();
      expect(StringUtilBeta.drawFontWeightFormat(100) === 0).assertTrue();
      expect(StringUtilBeta.drawFontWeightFormat() === 3).assertTrue();
      expect(StringUtilBeta.drawFontWeightFormat(200) === 1).assertTrue();
      expect(StringUtilBeta.drawFontWeightFormat(300) === 2).assertTrue();
      expect(StringUtilBeta.drawFontWeightFormat(400) === 3).assertTrue();
      expect(StringUtilBeta.drawFontWeightFormat(500) === 4).assertTrue();
      expect(StringUtilBeta.drawFontWeightFormat(600) === 5).assertTrue();
      expect(StringUtilBeta.drawFontWeightFormat(700) === 6).assertTrue();
      expect(StringUtilBeta.drawFontWeightFormat(800) === 7).assertTrue();
      expect(StringUtilBeta.drawFontWeightFormat(900) === 8).assertTrue();
      expect(StringUtilBeta.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('test_get_string_004', 0, () => {
      expect(StringUtilBeta.drawTextAlign() === -1).assertTrue();
      expect(StringUtilBeta.drawTextAlign(100) === 0).assertTrue();
      expect(StringUtilBeta.drawTextAlign(200) === 1).assertTrue();
      expect(StringUtilBeta.drawTextAlign(300) === 2).assertTrue();
      expect(StringUtilBeta.drawTextAlign(400) === 3).assertTrue();
      expect(StringUtilBeta.drawTextAlign(500) === 4).assertTrue();
      expect(StringUtilBeta.drawTextAlign(600) === 5).assertTrue();
      expect(StringUtilBeta.drawTextAlign(700) === 100).assertTrue();
    })

    it('test_get_string_005', 0, () => {
      expect(StringUtilBeta.getStringIndex('', '') === -1).assertTrue();
      expect(StringUtilBeta.getStringIndex(null, '') === -1).assertTrue();
      expect(StringUtilBeta.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(StringUtilBeta.getStringIndex('a', '') === -1).assertTrue();
      expect(StringUtilBeta.getStringIndex('a', null) === -1).assertTrue();
      expect(StringUtilBeta.getStringIndex('a', undefined) === -1).assertTrue();
      expect(StringUtilBeta.getStringIndex('ohos', '') === -1).assertTrue();
      expect(StringUtilBeta.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(StringUtilBeta.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(StringUtilBeta.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(StringUtilBeta.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(StringUtilBeta.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(StringUtilBeta.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(StringUtilBeta.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(StringUtilBeta.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(StringUtilBeta.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(StringUtilBeta.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(StringUtilBeta.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(StringUtilBeta.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('test_get_string_006', 0, () => {
      expect(StringUtilBeta.checkArr([]) === false).assertTrue();
      expect(StringUtilBeta.checkArr(null) === false).assertTrue();
      expect(StringUtilBeta.checkArr(undefined) === false).assertTrue();
      expect(StringUtilBeta.checkArr(['', 'b']) === false).assertTrue();
      expect(StringUtilBeta.checkArr([undefined, 'b']) === false).assertTrue();
      expect(StringUtilBeta.checkArr([null, 'b']) === false).assertTrue();
      expect(StringUtilBeta.checkArr(['a', '']) === false).assertTrue();
      expect(StringUtilBeta.checkArr(['a', undefined]) === false).assertTrue();
      expect(StringUtilBeta.checkArr(['a', null]) === false).assertTrue();
      expect(StringUtilBeta.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(StringUtilBeta.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(StringUtilBeta.checkArr(['default', 'b']) === false).assertTrue();
      expect(StringUtilBeta.checkArr(['a', 'default']) === false).assertTrue();
      expect(StringUtilBeta.checkArr(['a', 'b']) === true).assertTrue();
      expect(StringUtilBeta.checkArr(['a', 'a']) === false).assertTrue();
      expect(StringUtilBeta.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(StringUtilBeta.getUUID().length > 0).assertTrue();
    })

    it('test_get_string_007', 0, () => {
      expect(StringUtilBeta.verifyValue(1, 2) === 1).assertTrue();
      expect(StringUtilBeta.verifyValue(NaN, 2) === 2).assertTrue();
    })
  });
}