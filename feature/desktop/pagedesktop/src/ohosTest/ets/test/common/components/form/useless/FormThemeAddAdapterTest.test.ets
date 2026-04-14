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
import { FormThemeAddAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormThemeAddAdapter';

export function FormThemeAddAdapterTest() {
  describe('FormThemeAddAdapterTest', () => {
    it('FormThemeAddAdapter_001', 0, () => {
      expect(FormThemeAddAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormThemeAddAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormThemeAddAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormThemeAddAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormThemeAddAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormThemeAddAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormThemeAddAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormThemeAddAdapter_002', 0, () => {
      expect(FormThemeAddAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormThemeAddAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormThemeAddAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAddAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormThemeAddAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAddAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormThemeAddAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormThemeAddAdapter_003', 0, () => {
      expect(FormThemeAddAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormThemeAddAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAddAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAddAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAddAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAddAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormThemeAddAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormThemeAddAdapter_004', 0, () => {
      expect(FormThemeAddAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormThemeAddAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAddAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAddAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAddAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAddAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormThemeAddAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormThemeAddAdapter_005', 0, () => {
      expect(FormThemeAddAdapter.isNumber("")).assertFalse();
      expect(FormThemeAddAdapter.isNumber(null)).assertFalse();
      expect(FormThemeAddAdapter.isNumber(undefined)).assertFalse();
      expect(FormThemeAddAdapter.isNumber("abc")).assertFalse();
      expect(FormThemeAddAdapter.isNumber("123")).assertTrue();
    });

    it('FormThemeAddAdapter_006', 0, () => {
      expect(FormThemeAddAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormThemeAddAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormThemeAddAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormThemeAddAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormThemeAddAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormThemeAddAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormThemeAddAdapter_007', 0, () => {
      expect(FormThemeAddAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormThemeAddAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormThemeAddAdapter.getDefaultId('') === '').assertTrue();
      expect(FormThemeAddAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormThemeAddAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormThemeAddAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormThemeAddAdapter_008', 0, () => {
      expect(FormThemeAddAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormThemeAddAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormThemeAddAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormThemeAddAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormThemeAddAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormThemeAddAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormThemeAddAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormThemeAddAdapter_009', 0, () => {
      expect(FormThemeAddAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormThemeAddAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormThemeAddAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormThemeAddAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormThemeAddAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormThemeAddAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormThemeAddAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormThemeAddAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormThemeAddAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormThemeAddAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormThemeAddAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormThemeAddAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormThemeAddAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormThemeAddAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormThemeAddAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormThemeAddAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormThemeAddAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormThemeAddAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormThemeAddAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormThemeAddAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormThemeAddAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormThemeAddAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormThemeAddAdapter_010', 0, () => {
      expect(FormThemeAddAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormThemeAddAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormThemeAddAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormThemeAddAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormThemeAddAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormThemeAddAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormThemeAddAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormThemeAddAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormThemeAddAdapter_011', 0, () => {
      expect(FormThemeAddAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormThemeAddAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormThemeAddAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormThemeAddAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormThemeAddAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormThemeAddAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormThemeAddAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormThemeAddAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormThemeAddAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormThemeAddAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormThemeAddAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormThemeAddAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormThemeAddAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormThemeAddAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormThemeAddAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormThemeAddAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormThemeAddAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormThemeAddAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormThemeAddAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormThemeAddAdapter_012', 0, () => {
      expect(FormThemeAddAdapter.checkArr([]) === false).assertTrue();
      expect(FormThemeAddAdapter.checkArr(null) === false).assertTrue();
      expect(FormThemeAddAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormThemeAddAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormThemeAddAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormThemeAddAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormThemeAddAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormThemeAddAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormThemeAddAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormThemeAddAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormThemeAddAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormThemeAddAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormThemeAddAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormThemeAddAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormThemeAddAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormThemeAddAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormThemeAddAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormThemeAddAdapter_013', 0, () => {
      expect(FormThemeAddAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormThemeAddAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormThemeAddAdapter_014', 0, () => {
      expect(FormThemeAddAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormThemeAddAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormThemeAddAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormThemeAddAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormThemeAddAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormThemeAddAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormThemeAddAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormThemeAddAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormThemeAddAdapter_015', 0, () => {
      expect(FormThemeAddAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormThemeAddAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormThemeAddAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormThemeAddAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormThemeAddAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormThemeAddAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormThemeAddAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormThemeAddAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormThemeAddAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormThemeAddAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormThemeAddAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormThemeAddAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormThemeAddAdapter_016', 0, () => {
      expect(FormThemeAddAdapter.isEmpty(null)).assertTrue();
      expect(FormThemeAddAdapter.isEmpty(undefined)).assertTrue();
      expect(FormThemeAddAdapter.isEmpty('')).assertTrue();
      expect(FormThemeAddAdapter.isEmpty(0)).assertTrue();
      expect(FormThemeAddAdapter.isEmpty([])).assertTrue();
      expect(FormThemeAddAdapter.isEmpty(1, null)).assertTrue();
      expect(FormThemeAddAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormThemeAddAdapter.isEmpty(1, true)).assertTrue();
      expect(FormThemeAddAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormThemeAddAdapter_017', 0, () => {
      expect(FormThemeAddAdapter.equals(null, 'a')).assertFalse();
      expect(FormThemeAddAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormThemeAddAdapter.equals('a', null)).assertFalse();
      expect(FormThemeAddAdapter.equals('a', undefined)).assertFalse();
      expect(FormThemeAddAdapter.equals('a', 1)).assertFalse();
      expect(FormThemeAddAdapter.equals(1, 'a')).assertFalse();
      expect(FormThemeAddAdapter.equals(1, [])).assertFalse();
      expect(FormThemeAddAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormThemeAddAdapter.equals([], m)).assertFalse();
      expect(FormThemeAddAdapter.equals(m, [])).assertFalse();
      expect(FormThemeAddAdapter.equals([1,2], [])).assertFalse();
      expect(FormThemeAddAdapter.equals([], [1, 2])).assertFalse();
      expect(FormThemeAddAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormThemeAddAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormThemeAddAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormThemeAddAdapter.equals(2, 2)).assertTrue();
    })
  });
}