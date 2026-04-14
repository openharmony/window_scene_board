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
import { FormThemeAccessUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormThemeAccessUtil';

export function FormThemeAccessUtilTest() {
  describe('FormThemeAccessUtilTest', () => {
    it('FormThemeAccessUtil_001', 0, () => {
      expect(FormThemeAccessUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormThemeAccessUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormThemeAccessUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormThemeAccessUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormThemeAccessUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormThemeAccessUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormThemeAccessUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormThemeAccessUtil_002', 0, () => {
      expect(FormThemeAccessUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormThemeAccessUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormThemeAccessUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAccessUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormThemeAccessUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAccessUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormThemeAccessUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormThemeAccessUtil_003', 0, () => {
      expect(FormThemeAccessUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormThemeAccessUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAccessUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAccessUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAccessUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAccessUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormThemeAccessUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormThemeAccessUtil_004', 0, () => {
      expect(FormThemeAccessUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormThemeAccessUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAccessUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAccessUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAccessUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAccessUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormThemeAccessUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormThemeAccessUtil_005', 0, () => {
      expect(FormThemeAccessUtil.isNumber("")).assertFalse();
      expect(FormThemeAccessUtil.isNumber(null)).assertFalse();
      expect(FormThemeAccessUtil.isNumber(undefined)).assertFalse();
      expect(FormThemeAccessUtil.isNumber("abc")).assertFalse();
      expect(FormThemeAccessUtil.isNumber("123")).assertTrue();
    });

    it('FormThemeAccessUtil_006', 0, () => {
      expect(FormThemeAccessUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormThemeAccessUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormThemeAccessUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormThemeAccessUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormThemeAccessUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormThemeAccessUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormThemeAccessUtil_007', 0, () => {
      expect(FormThemeAccessUtil.getDefaultId(null) === null).assertTrue();
      expect(FormThemeAccessUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormThemeAccessUtil.getDefaultId('') === '').assertTrue();
      expect(FormThemeAccessUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormThemeAccessUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormThemeAccessUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormThemeAccessUtil_008', 0, () => {
      expect(FormThemeAccessUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormThemeAccessUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormThemeAccessUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormThemeAccessUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormThemeAccessUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormThemeAccessUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormThemeAccessUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormThemeAccessUtil_009', 0, () => {
      expect(FormThemeAccessUtil.drawFontWidth() === -1).assertTrue();
      expect(FormThemeAccessUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormThemeAccessUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormThemeAccessUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormThemeAccessUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormThemeAccessUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormThemeAccessUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormThemeAccessUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormThemeAccessUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormThemeAccessUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormThemeAccessUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormThemeAccessUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormThemeAccessUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormThemeAccessUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormThemeAccessUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormThemeAccessUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormThemeAccessUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormThemeAccessUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormThemeAccessUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormThemeAccessUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormThemeAccessUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormThemeAccessUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormThemeAccessUtil_010', 0, () => {
      expect(FormThemeAccessUtil.drawTextAlign() === -1).assertTrue();
      expect(FormThemeAccessUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormThemeAccessUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormThemeAccessUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormThemeAccessUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormThemeAccessUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormThemeAccessUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormThemeAccessUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormThemeAccessUtil_011', 0, () => {
      expect(FormThemeAccessUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormThemeAccessUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormThemeAccessUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormThemeAccessUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormThemeAccessUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormThemeAccessUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormThemeAccessUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormThemeAccessUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormThemeAccessUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormThemeAccessUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormThemeAccessUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormThemeAccessUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormThemeAccessUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormThemeAccessUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormThemeAccessUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormThemeAccessUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormThemeAccessUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormThemeAccessUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormThemeAccessUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormThemeAccessUtil_012', 0, () => {
      expect(FormThemeAccessUtil.checkArr([]) === false).assertTrue();
      expect(FormThemeAccessUtil.checkArr(null) === false).assertTrue();
      expect(FormThemeAccessUtil.checkArr(undefined) === false).assertTrue();
      expect(FormThemeAccessUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormThemeAccessUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormThemeAccessUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormThemeAccessUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormThemeAccessUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormThemeAccessUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormThemeAccessUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormThemeAccessUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormThemeAccessUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormThemeAccessUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormThemeAccessUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormThemeAccessUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormThemeAccessUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormThemeAccessUtil.getUUID().length > 0).assertTrue();
    })

    it('FormThemeAccessUtil_013', 0, () => {
      expect(FormThemeAccessUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormThemeAccessUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormThemeAccessUtil_014', 0, () => {
      expect(FormThemeAccessUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormThemeAccessUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormThemeAccessUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormThemeAccessUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormThemeAccessUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormThemeAccessUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormThemeAccessUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormThemeAccessUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormThemeAccessUtil_015', 0, () => {
      expect(FormThemeAccessUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormThemeAccessUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormThemeAccessUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormThemeAccessUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormThemeAccessUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormThemeAccessUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormThemeAccessUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormThemeAccessUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormThemeAccessUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormThemeAccessUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormThemeAccessUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormThemeAccessUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormThemeAccessUtil_016', 0, () => {
      expect(FormThemeAccessUtil.isEmpty(null)).assertTrue();
      expect(FormThemeAccessUtil.isEmpty(undefined)).assertTrue();
      expect(FormThemeAccessUtil.isEmpty('')).assertTrue();
      expect(FormThemeAccessUtil.isEmpty(0)).assertTrue();
      expect(FormThemeAccessUtil.isEmpty([])).assertTrue();
      expect(FormThemeAccessUtil.isEmpty(1, null)).assertTrue();
      expect(FormThemeAccessUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormThemeAccessUtil.isEmpty(1, true)).assertTrue();
      expect(FormThemeAccessUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormThemeAccessUtil_017', 0, () => {
      expect(FormThemeAccessUtil.equals(null, 'a')).assertFalse();
      expect(FormThemeAccessUtil.equals(undefined, 'a')).assertFalse();
      expect(FormThemeAccessUtil.equals('a', null)).assertFalse();
      expect(FormThemeAccessUtil.equals('a', undefined)).assertFalse();
      expect(FormThemeAccessUtil.equals('a', 1)).assertFalse();
      expect(FormThemeAccessUtil.equals(1, 'a')).assertFalse();
      expect(FormThemeAccessUtil.equals(1, [])).assertFalse();
      expect(FormThemeAccessUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormThemeAccessUtil.equals([], m)).assertFalse();
      expect(FormThemeAccessUtil.equals(m, [])).assertFalse();
      expect(FormThemeAccessUtil.equals([1,2], [])).assertFalse();
      expect(FormThemeAccessUtil.equals([], [1, 2])).assertFalse();
      expect(FormThemeAccessUtil.equals([1], [1, 2])).assertFalse();
      expect(FormThemeAccessUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormThemeAccessUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormThemeAccessUtil.equals(2, 2)).assertTrue();
    })
  });
}