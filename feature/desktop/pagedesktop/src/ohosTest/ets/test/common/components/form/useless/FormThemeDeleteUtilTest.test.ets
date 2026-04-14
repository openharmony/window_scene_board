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
import { FormThemeDeleteUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormThemeDeleteUtil';

export function FormThemeDeleteUtilTest() {
  describe('FormThemeDeleteUtilTest', () => {
    it('FormThemeDeleteUtil_001', 0, () => {
      expect(FormThemeDeleteUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormThemeDeleteUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormThemeDeleteUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormThemeDeleteUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormThemeDeleteUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormThemeDeleteUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormThemeDeleteUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormThemeDeleteUtil_002', 0, () => {
      expect(FormThemeDeleteUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormThemeDeleteUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormThemeDeleteUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormThemeDeleteUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormThemeDeleteUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormThemeDeleteUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormThemeDeleteUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormThemeDeleteUtil_003', 0, () => {
      expect(FormThemeDeleteUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormThemeDeleteUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormThemeDeleteUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeDeleteUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeDeleteUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeDeleteUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormThemeDeleteUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormThemeDeleteUtil_004', 0, () => {
      expect(FormThemeDeleteUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormThemeDeleteUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormThemeDeleteUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeDeleteUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeDeleteUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeDeleteUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormThemeDeleteUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormThemeDeleteUtil_005', 0, () => {
      expect(FormThemeDeleteUtil.isNumber("")).assertFalse();
      expect(FormThemeDeleteUtil.isNumber(null)).assertFalse();
      expect(FormThemeDeleteUtil.isNumber(undefined)).assertFalse();
      expect(FormThemeDeleteUtil.isNumber("abc")).assertFalse();
      expect(FormThemeDeleteUtil.isNumber("123")).assertTrue();
    });

    it('FormThemeDeleteUtil_006', 0, () => {
      expect(FormThemeDeleteUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormThemeDeleteUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormThemeDeleteUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormThemeDeleteUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormThemeDeleteUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormThemeDeleteUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormThemeDeleteUtil_007', 0, () => {
      expect(FormThemeDeleteUtil.getDefaultId(null) === null).assertTrue();
      expect(FormThemeDeleteUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormThemeDeleteUtil.getDefaultId('') === '').assertTrue();
      expect(FormThemeDeleteUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormThemeDeleteUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormThemeDeleteUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormThemeDeleteUtil_008', 0, () => {
      expect(FormThemeDeleteUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormThemeDeleteUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormThemeDeleteUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormThemeDeleteUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormThemeDeleteUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormThemeDeleteUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormThemeDeleteUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormThemeDeleteUtil_009', 0, () => {
      expect(FormThemeDeleteUtil.drawFontWidth() === -1).assertTrue();
      expect(FormThemeDeleteUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormThemeDeleteUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormThemeDeleteUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormThemeDeleteUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormThemeDeleteUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormThemeDeleteUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormThemeDeleteUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormThemeDeleteUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormThemeDeleteUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormThemeDeleteUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormThemeDeleteUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormThemeDeleteUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormThemeDeleteUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormThemeDeleteUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormThemeDeleteUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormThemeDeleteUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormThemeDeleteUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormThemeDeleteUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormThemeDeleteUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormThemeDeleteUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormThemeDeleteUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormThemeDeleteUtil_010', 0, () => {
      expect(FormThemeDeleteUtil.drawTextAlign() === -1).assertTrue();
      expect(FormThemeDeleteUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormThemeDeleteUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormThemeDeleteUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormThemeDeleteUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormThemeDeleteUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormThemeDeleteUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormThemeDeleteUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormThemeDeleteUtil_011', 0, () => {
      expect(FormThemeDeleteUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormThemeDeleteUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormThemeDeleteUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormThemeDeleteUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormThemeDeleteUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormThemeDeleteUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormThemeDeleteUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormThemeDeleteUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormThemeDeleteUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormThemeDeleteUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormThemeDeleteUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormThemeDeleteUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormThemeDeleteUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormThemeDeleteUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormThemeDeleteUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormThemeDeleteUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormThemeDeleteUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormThemeDeleteUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormThemeDeleteUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormThemeDeleteUtil_012', 0, () => {
      expect(FormThemeDeleteUtil.checkArr([]) === false).assertTrue();
      expect(FormThemeDeleteUtil.checkArr(null) === false).assertTrue();
      expect(FormThemeDeleteUtil.checkArr(undefined) === false).assertTrue();
      expect(FormThemeDeleteUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormThemeDeleteUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormThemeDeleteUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormThemeDeleteUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormThemeDeleteUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormThemeDeleteUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormThemeDeleteUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormThemeDeleteUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormThemeDeleteUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormThemeDeleteUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormThemeDeleteUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormThemeDeleteUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormThemeDeleteUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormThemeDeleteUtil.getUUID().length > 0).assertTrue();
    })

    it('FormThemeDeleteUtil_013', 0, () => {
      expect(FormThemeDeleteUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormThemeDeleteUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormThemeDeleteUtil_014', 0, () => {
      expect(FormThemeDeleteUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormThemeDeleteUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormThemeDeleteUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormThemeDeleteUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormThemeDeleteUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormThemeDeleteUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormThemeDeleteUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormThemeDeleteUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormThemeDeleteUtil_015', 0, () => {
      expect(FormThemeDeleteUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormThemeDeleteUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormThemeDeleteUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormThemeDeleteUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormThemeDeleteUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormThemeDeleteUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormThemeDeleteUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormThemeDeleteUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormThemeDeleteUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormThemeDeleteUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormThemeDeleteUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormThemeDeleteUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormThemeDeleteUtil_016', 0, () => {
      expect(FormThemeDeleteUtil.isEmpty(null)).assertTrue();
      expect(FormThemeDeleteUtil.isEmpty(undefined)).assertTrue();
      expect(FormThemeDeleteUtil.isEmpty('')).assertTrue();
      expect(FormThemeDeleteUtil.isEmpty(0)).assertTrue();
      expect(FormThemeDeleteUtil.isEmpty([])).assertTrue();
      expect(FormThemeDeleteUtil.isEmpty(1, null)).assertTrue();
      expect(FormThemeDeleteUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormThemeDeleteUtil.isEmpty(1, true)).assertTrue();
      expect(FormThemeDeleteUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormThemeDeleteUtil_017', 0, () => {
      expect(FormThemeDeleteUtil.equals(null, 'a')).assertFalse();
      expect(FormThemeDeleteUtil.equals(undefined, 'a')).assertFalse();
      expect(FormThemeDeleteUtil.equals('a', null)).assertFalse();
      expect(FormThemeDeleteUtil.equals('a', undefined)).assertFalse();
      expect(FormThemeDeleteUtil.equals('a', 1)).assertFalse();
      expect(FormThemeDeleteUtil.equals(1, 'a')).assertFalse();
      expect(FormThemeDeleteUtil.equals(1, [])).assertFalse();
      expect(FormThemeDeleteUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormThemeDeleteUtil.equals([], m)).assertFalse();
      expect(FormThemeDeleteUtil.equals(m, [])).assertFalse();
      expect(FormThemeDeleteUtil.equals([1,2], [])).assertFalse();
      expect(FormThemeDeleteUtil.equals([], [1, 2])).assertFalse();
      expect(FormThemeDeleteUtil.equals([1], [1, 2])).assertFalse();
      expect(FormThemeDeleteUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormThemeDeleteUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormThemeDeleteUtil.equals(2, 2)).assertTrue();
    })
  });
}