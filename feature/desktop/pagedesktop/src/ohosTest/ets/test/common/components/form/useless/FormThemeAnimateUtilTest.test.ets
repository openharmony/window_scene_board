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
import { FormThemeAnimateUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormThemeAnimateUtil';

export function FormThemeAnimateUtilTest() {
  describe('FormThemeAnimateUtilTest', () => {
    it('FormThemeAnimateUtil_001', 0, () => {
      expect(FormThemeAnimateUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormThemeAnimateUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormThemeAnimateUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormThemeAnimateUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormThemeAnimateUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormThemeAnimateUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormThemeAnimateUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormThemeAnimateUtil_002', 0, () => {
      expect(FormThemeAnimateUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormThemeAnimateUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormThemeAnimateUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAnimateUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormThemeAnimateUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAnimateUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormThemeAnimateUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormThemeAnimateUtil_003', 0, () => {
      expect(FormThemeAnimateUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormThemeAnimateUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAnimateUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAnimateUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAnimateUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAnimateUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormThemeAnimateUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormThemeAnimateUtil_004', 0, () => {
      expect(FormThemeAnimateUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormThemeAnimateUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAnimateUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAnimateUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAnimateUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAnimateUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormThemeAnimateUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormThemeAnimateUtil_005', 0, () => {
      expect(FormThemeAnimateUtil.isNumber("")).assertFalse();
      expect(FormThemeAnimateUtil.isNumber(null)).assertFalse();
      expect(FormThemeAnimateUtil.isNumber(undefined)).assertFalse();
      expect(FormThemeAnimateUtil.isNumber("abc")).assertFalse();
      expect(FormThemeAnimateUtil.isNumber("123")).assertTrue();
    });

    it('FormThemeAnimateUtil_006', 0, () => {
      expect(FormThemeAnimateUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormThemeAnimateUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormThemeAnimateUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormThemeAnimateUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormThemeAnimateUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormThemeAnimateUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormThemeAnimateUtil_007', 0, () => {
      expect(FormThemeAnimateUtil.getDefaultId(null) === null).assertTrue();
      expect(FormThemeAnimateUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormThemeAnimateUtil.getDefaultId('') === '').assertTrue();
      expect(FormThemeAnimateUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormThemeAnimateUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormThemeAnimateUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormThemeAnimateUtil_008', 0, () => {
      expect(FormThemeAnimateUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormThemeAnimateUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormThemeAnimateUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormThemeAnimateUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormThemeAnimateUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormThemeAnimateUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormThemeAnimateUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormThemeAnimateUtil_009', 0, () => {
      expect(FormThemeAnimateUtil.drawFontWidth() === -1).assertTrue();
      expect(FormThemeAnimateUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormThemeAnimateUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormThemeAnimateUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormThemeAnimateUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormThemeAnimateUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormThemeAnimateUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormThemeAnimateUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormThemeAnimateUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormThemeAnimateUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormThemeAnimateUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormThemeAnimateUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormThemeAnimateUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormThemeAnimateUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormThemeAnimateUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormThemeAnimateUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormThemeAnimateUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormThemeAnimateUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormThemeAnimateUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormThemeAnimateUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormThemeAnimateUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormThemeAnimateUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormThemeAnimateUtil_010', 0, () => {
      expect(FormThemeAnimateUtil.drawTextAlign() === -1).assertTrue();
      expect(FormThemeAnimateUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormThemeAnimateUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormThemeAnimateUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormThemeAnimateUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormThemeAnimateUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormThemeAnimateUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormThemeAnimateUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormThemeAnimateUtil_011', 0, () => {
      expect(FormThemeAnimateUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormThemeAnimateUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormThemeAnimateUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormThemeAnimateUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormThemeAnimateUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormThemeAnimateUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormThemeAnimateUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormThemeAnimateUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormThemeAnimateUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormThemeAnimateUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormThemeAnimateUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormThemeAnimateUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormThemeAnimateUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormThemeAnimateUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormThemeAnimateUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormThemeAnimateUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormThemeAnimateUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormThemeAnimateUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormThemeAnimateUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormThemeAnimateUtil_012', 0, () => {
      expect(FormThemeAnimateUtil.checkArr([]) === false).assertTrue();
      expect(FormThemeAnimateUtil.checkArr(null) === false).assertTrue();
      expect(FormThemeAnimateUtil.checkArr(undefined) === false).assertTrue();
      expect(FormThemeAnimateUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormThemeAnimateUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormThemeAnimateUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormThemeAnimateUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormThemeAnimateUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormThemeAnimateUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormThemeAnimateUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormThemeAnimateUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormThemeAnimateUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormThemeAnimateUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormThemeAnimateUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormThemeAnimateUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormThemeAnimateUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormThemeAnimateUtil.getUUID().length > 0).assertTrue();
    })

    it('FormThemeAnimateUtil_013', 0, () => {
      expect(FormThemeAnimateUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormThemeAnimateUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormThemeAnimateUtil_014', 0, () => {
      expect(FormThemeAnimateUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormThemeAnimateUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormThemeAnimateUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormThemeAnimateUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormThemeAnimateUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormThemeAnimateUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormThemeAnimateUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormThemeAnimateUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormThemeAnimateUtil_015', 0, () => {
      expect(FormThemeAnimateUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormThemeAnimateUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormThemeAnimateUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormThemeAnimateUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormThemeAnimateUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormThemeAnimateUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormThemeAnimateUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormThemeAnimateUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormThemeAnimateUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormThemeAnimateUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormThemeAnimateUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormThemeAnimateUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormThemeAnimateUtil_016', 0, () => {
      expect(FormThemeAnimateUtil.isEmpty(null)).assertTrue();
      expect(FormThemeAnimateUtil.isEmpty(undefined)).assertTrue();
      expect(FormThemeAnimateUtil.isEmpty('')).assertTrue();
      expect(FormThemeAnimateUtil.isEmpty(0)).assertTrue();
      expect(FormThemeAnimateUtil.isEmpty([])).assertTrue();
      expect(FormThemeAnimateUtil.isEmpty(1, null)).assertTrue();
      expect(FormThemeAnimateUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormThemeAnimateUtil.isEmpty(1, true)).assertTrue();
      expect(FormThemeAnimateUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormThemeAnimateUtil_017', 0, () => {
      expect(FormThemeAnimateUtil.equals(null, 'a')).assertFalse();
      expect(FormThemeAnimateUtil.equals(undefined, 'a')).assertFalse();
      expect(FormThemeAnimateUtil.equals('a', null)).assertFalse();
      expect(FormThemeAnimateUtil.equals('a', undefined)).assertFalse();
      expect(FormThemeAnimateUtil.equals('a', 1)).assertFalse();
      expect(FormThemeAnimateUtil.equals(1, 'a')).assertFalse();
      expect(FormThemeAnimateUtil.equals(1, [])).assertFalse();
      expect(FormThemeAnimateUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormThemeAnimateUtil.equals([], m)).assertFalse();
      expect(FormThemeAnimateUtil.equals(m, [])).assertFalse();
      expect(FormThemeAnimateUtil.equals([1,2], [])).assertFalse();
      expect(FormThemeAnimateUtil.equals([], [1, 2])).assertFalse();
      expect(FormThemeAnimateUtil.equals([1], [1, 2])).assertFalse();
      expect(FormThemeAnimateUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormThemeAnimateUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormThemeAnimateUtil.equals(2, 2)).assertTrue();
    })
  });
}