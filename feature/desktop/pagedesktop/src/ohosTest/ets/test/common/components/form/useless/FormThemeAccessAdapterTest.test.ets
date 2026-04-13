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
import { FormThemeAccessAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormThemeAccessAdapter';

export function FormThemeAccessAdapterTest() {
  describe('FormThemeAccessAdapterTest', () => {
    it('FormThemeAccessAdapter_001', 0, () => {
      expect(FormThemeAccessAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormThemeAccessAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormThemeAccessAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormThemeAccessAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormThemeAccessAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormThemeAccessAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormThemeAccessAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormThemeAccessAdapter_002', 0, () => {
      expect(FormThemeAccessAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormThemeAccessAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormThemeAccessAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAccessAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormThemeAccessAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAccessAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormThemeAccessAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormThemeAccessAdapter_003', 0, () => {
      expect(FormThemeAccessAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormThemeAccessAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAccessAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAccessAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAccessAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAccessAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormThemeAccessAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormThemeAccessAdapter_004', 0, () => {
      expect(FormThemeAccessAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormThemeAccessAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAccessAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAccessAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAccessAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAccessAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormThemeAccessAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormThemeAccessAdapter_005', 0, () => {
      expect(FormThemeAccessAdapter.isNumber("")).assertFalse();
      expect(FormThemeAccessAdapter.isNumber(null)).assertFalse();
      expect(FormThemeAccessAdapter.isNumber(undefined)).assertFalse();
      expect(FormThemeAccessAdapter.isNumber("abc")).assertFalse();
      expect(FormThemeAccessAdapter.isNumber("123")).assertTrue();
    });

    it('FormThemeAccessAdapter_006', 0, () => {
      expect(FormThemeAccessAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormThemeAccessAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormThemeAccessAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormThemeAccessAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormThemeAccessAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormThemeAccessAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormThemeAccessAdapter_007', 0, () => {
      expect(FormThemeAccessAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormThemeAccessAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormThemeAccessAdapter.getDefaultId('') === '').assertTrue();
      expect(FormThemeAccessAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormThemeAccessAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormThemeAccessAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormThemeAccessAdapter_008', 0, () => {
      expect(FormThemeAccessAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormThemeAccessAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormThemeAccessAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormThemeAccessAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormThemeAccessAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormThemeAccessAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormThemeAccessAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormThemeAccessAdapter_009', 0, () => {
      expect(FormThemeAccessAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormThemeAccessAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormThemeAccessAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormThemeAccessAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormThemeAccessAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormThemeAccessAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormThemeAccessAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormThemeAccessAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormThemeAccessAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormThemeAccessAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormThemeAccessAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormThemeAccessAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormThemeAccessAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormThemeAccessAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormThemeAccessAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormThemeAccessAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormThemeAccessAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormThemeAccessAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormThemeAccessAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormThemeAccessAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormThemeAccessAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormThemeAccessAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormThemeAccessAdapter_010', 0, () => {
      expect(FormThemeAccessAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormThemeAccessAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormThemeAccessAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormThemeAccessAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormThemeAccessAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormThemeAccessAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormThemeAccessAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormThemeAccessAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormThemeAccessAdapter_011', 0, () => {
      expect(FormThemeAccessAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormThemeAccessAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormThemeAccessAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormThemeAccessAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormThemeAccessAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormThemeAccessAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormThemeAccessAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormThemeAccessAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormThemeAccessAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormThemeAccessAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormThemeAccessAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormThemeAccessAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormThemeAccessAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormThemeAccessAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormThemeAccessAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormThemeAccessAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormThemeAccessAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormThemeAccessAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormThemeAccessAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormThemeAccessAdapter_012', 0, () => {
      expect(FormThemeAccessAdapter.checkArr([]) === false).assertTrue();
      expect(FormThemeAccessAdapter.checkArr(null) === false).assertTrue();
      expect(FormThemeAccessAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormThemeAccessAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormThemeAccessAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormThemeAccessAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormThemeAccessAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormThemeAccessAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormThemeAccessAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormThemeAccessAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormThemeAccessAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormThemeAccessAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormThemeAccessAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormThemeAccessAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormThemeAccessAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormThemeAccessAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormThemeAccessAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormThemeAccessAdapter_013', 0, () => {
      expect(FormThemeAccessAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormThemeAccessAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormThemeAccessAdapter_014', 0, () => {
      expect(FormThemeAccessAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormThemeAccessAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormThemeAccessAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormThemeAccessAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormThemeAccessAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormThemeAccessAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormThemeAccessAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormThemeAccessAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormThemeAccessAdapter_015', 0, () => {
      expect(FormThemeAccessAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormThemeAccessAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormThemeAccessAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormThemeAccessAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormThemeAccessAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormThemeAccessAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormThemeAccessAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormThemeAccessAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormThemeAccessAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormThemeAccessAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormThemeAccessAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormThemeAccessAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormThemeAccessAdapter_016', 0, () => {
      expect(FormThemeAccessAdapter.isEmpty(null)).assertTrue();
      expect(FormThemeAccessAdapter.isEmpty(undefined)).assertTrue();
      expect(FormThemeAccessAdapter.isEmpty('')).assertTrue();
      expect(FormThemeAccessAdapter.isEmpty(0)).assertTrue();
      expect(FormThemeAccessAdapter.isEmpty([])).assertTrue();
      expect(FormThemeAccessAdapter.isEmpty(1, null)).assertTrue();
      expect(FormThemeAccessAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormThemeAccessAdapter.isEmpty(1, true)).assertTrue();
      expect(FormThemeAccessAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormThemeAccessAdapter_017', 0, () => {
      expect(FormThemeAccessAdapter.equals(null, 'a')).assertFalse();
      expect(FormThemeAccessAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormThemeAccessAdapter.equals('a', null)).assertFalse();
      expect(FormThemeAccessAdapter.equals('a', undefined)).assertFalse();
      expect(FormThemeAccessAdapter.equals('a', 1)).assertFalse();
      expect(FormThemeAccessAdapter.equals(1, 'a')).assertFalse();
      expect(FormThemeAccessAdapter.equals(1, [])).assertFalse();
      expect(FormThemeAccessAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormThemeAccessAdapter.equals([], m)).assertFalse();
      expect(FormThemeAccessAdapter.equals(m, [])).assertFalse();
      expect(FormThemeAccessAdapter.equals([1,2], [])).assertFalse();
      expect(FormThemeAccessAdapter.equals([], [1, 2])).assertFalse();
      expect(FormThemeAccessAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormThemeAccessAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormThemeAccessAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormThemeAccessAdapter.equals(2, 2)).assertTrue();
    })
  });
}