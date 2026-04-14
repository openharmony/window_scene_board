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
import { FormThemeDeleteAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormThemeDeleteAdapter';

export function FormThemeDeleteAdapterTest() {
  describe('FormThemeDeleteAdapterTest', () => {
    it('FormThemeDeleteAdapter_001', 0, () => {
      expect(FormThemeDeleteAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormThemeDeleteAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormThemeDeleteAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormThemeDeleteAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormThemeDeleteAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormThemeDeleteAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormThemeDeleteAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormThemeDeleteAdapter_002', 0, () => {
      expect(FormThemeDeleteAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormThemeDeleteAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormThemeDeleteAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormThemeDeleteAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormThemeDeleteAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormThemeDeleteAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormThemeDeleteAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormThemeDeleteAdapter_003', 0, () => {
      expect(FormThemeDeleteAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormThemeDeleteAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormThemeDeleteAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeDeleteAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeDeleteAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeDeleteAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormThemeDeleteAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormThemeDeleteAdapter_004', 0, () => {
      expect(FormThemeDeleteAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormThemeDeleteAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormThemeDeleteAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeDeleteAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeDeleteAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeDeleteAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormThemeDeleteAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormThemeDeleteAdapter_005', 0, () => {
      expect(FormThemeDeleteAdapter.isNumber("")).assertFalse();
      expect(FormThemeDeleteAdapter.isNumber(null)).assertFalse();
      expect(FormThemeDeleteAdapter.isNumber(undefined)).assertFalse();
      expect(FormThemeDeleteAdapter.isNumber("abc")).assertFalse();
      expect(FormThemeDeleteAdapter.isNumber("123")).assertTrue();
    });

    it('FormThemeDeleteAdapter_006', 0, () => {
      expect(FormThemeDeleteAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormThemeDeleteAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormThemeDeleteAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormThemeDeleteAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormThemeDeleteAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormThemeDeleteAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormThemeDeleteAdapter_007', 0, () => {
      expect(FormThemeDeleteAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormThemeDeleteAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormThemeDeleteAdapter.getDefaultId('') === '').assertTrue();
      expect(FormThemeDeleteAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormThemeDeleteAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormThemeDeleteAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormThemeDeleteAdapter_008', 0, () => {
      expect(FormThemeDeleteAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormThemeDeleteAdapter_009', 0, () => {
      expect(FormThemeDeleteAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormThemeDeleteAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormThemeDeleteAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormThemeDeleteAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormThemeDeleteAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormThemeDeleteAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormThemeDeleteAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormThemeDeleteAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormThemeDeleteAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormThemeDeleteAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormThemeDeleteAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormThemeDeleteAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormThemeDeleteAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormThemeDeleteAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormThemeDeleteAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormThemeDeleteAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormThemeDeleteAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormThemeDeleteAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormThemeDeleteAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormThemeDeleteAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormThemeDeleteAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormThemeDeleteAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormThemeDeleteAdapter_010', 0, () => {
      expect(FormThemeDeleteAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormThemeDeleteAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormThemeDeleteAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormThemeDeleteAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormThemeDeleteAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormThemeDeleteAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormThemeDeleteAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormThemeDeleteAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormThemeDeleteAdapter_011', 0, () => {
      expect(FormThemeDeleteAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormThemeDeleteAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormThemeDeleteAdapter_012', 0, () => {
      expect(FormThemeDeleteAdapter.checkArr([]) === false).assertTrue();
      expect(FormThemeDeleteAdapter.checkArr(null) === false).assertTrue();
      expect(FormThemeDeleteAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormThemeDeleteAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormThemeDeleteAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormThemeDeleteAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormThemeDeleteAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormThemeDeleteAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormThemeDeleteAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormThemeDeleteAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormThemeDeleteAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormThemeDeleteAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormThemeDeleteAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormThemeDeleteAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormThemeDeleteAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormThemeDeleteAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormThemeDeleteAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormThemeDeleteAdapter_013', 0, () => {
      expect(FormThemeDeleteAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormThemeDeleteAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormThemeDeleteAdapter_014', 0, () => {
      expect(FormThemeDeleteAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormThemeDeleteAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormThemeDeleteAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormThemeDeleteAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormThemeDeleteAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormThemeDeleteAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormThemeDeleteAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormThemeDeleteAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormThemeDeleteAdapter_015', 0, () => {
      expect(FormThemeDeleteAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormThemeDeleteAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormThemeDeleteAdapter_016', 0, () => {
      expect(FormThemeDeleteAdapter.isEmpty(null)).assertTrue();
      expect(FormThemeDeleteAdapter.isEmpty(undefined)).assertTrue();
      expect(FormThemeDeleteAdapter.isEmpty('')).assertTrue();
      expect(FormThemeDeleteAdapter.isEmpty(0)).assertTrue();
      expect(FormThemeDeleteAdapter.isEmpty([])).assertTrue();
      expect(FormThemeDeleteAdapter.isEmpty(1, null)).assertTrue();
      expect(FormThemeDeleteAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormThemeDeleteAdapter.isEmpty(1, true)).assertTrue();
      expect(FormThemeDeleteAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormThemeDeleteAdapter_017', 0, () => {
      expect(FormThemeDeleteAdapter.equals(null, 'a')).assertFalse();
      expect(FormThemeDeleteAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormThemeDeleteAdapter.equals('a', null)).assertFalse();
      expect(FormThemeDeleteAdapter.equals('a', undefined)).assertFalse();
      expect(FormThemeDeleteAdapter.equals('a', 1)).assertFalse();
      expect(FormThemeDeleteAdapter.equals(1, 'a')).assertFalse();
      expect(FormThemeDeleteAdapter.equals(1, [])).assertFalse();
      expect(FormThemeDeleteAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormThemeDeleteAdapter.equals([], m)).assertFalse();
      expect(FormThemeDeleteAdapter.equals(m, [])).assertFalse();
      expect(FormThemeDeleteAdapter.equals([1,2], [])).assertFalse();
      expect(FormThemeDeleteAdapter.equals([], [1, 2])).assertFalse();
      expect(FormThemeDeleteAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormThemeDeleteAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormThemeDeleteAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormThemeDeleteAdapter.equals(2, 2)).assertTrue();
    })
  });
}