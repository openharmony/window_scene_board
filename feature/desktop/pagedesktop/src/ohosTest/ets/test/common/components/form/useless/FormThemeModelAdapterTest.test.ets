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
import { FormThemeModelAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormThemeModelAdapter';

export function FormThemeModelAdapterTest() {
  describe('FormThemeModelAdapterTest', () => {
    it('FormThemeModelAdapter_001', 0, () => {
      expect(FormThemeModelAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormThemeModelAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormThemeModelAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormThemeModelAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormThemeModelAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormThemeModelAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormThemeModelAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormThemeModelAdapter_002', 0, () => {
      expect(FormThemeModelAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormThemeModelAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormThemeModelAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormThemeModelAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormThemeModelAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormThemeModelAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormThemeModelAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormThemeModelAdapter_003', 0, () => {
      expect(FormThemeModelAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormThemeModelAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormThemeModelAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeModelAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeModelAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeModelAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormThemeModelAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormThemeModelAdapter_004', 0, () => {
      expect(FormThemeModelAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormThemeModelAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormThemeModelAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeModelAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeModelAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeModelAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormThemeModelAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormThemeModelAdapter_005', 0, () => {
      expect(FormThemeModelAdapter.isNumber("")).assertFalse();
      expect(FormThemeModelAdapter.isNumber(null)).assertFalse();
      expect(FormThemeModelAdapter.isNumber(undefined)).assertFalse();
      expect(FormThemeModelAdapter.isNumber("abc")).assertFalse();
      expect(FormThemeModelAdapter.isNumber("123")).assertTrue();
    });

    it('FormThemeModelAdapter_006', 0, () => {
      expect(FormThemeModelAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormThemeModelAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormThemeModelAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormThemeModelAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormThemeModelAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormThemeModelAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormThemeModelAdapter_007', 0, () => {
      expect(FormThemeModelAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormThemeModelAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormThemeModelAdapter.getDefaultId('') === '').assertTrue();
      expect(FormThemeModelAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormThemeModelAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormThemeModelAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormThemeModelAdapter_008', 0, () => {
      expect(FormThemeModelAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormThemeModelAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormThemeModelAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormThemeModelAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormThemeModelAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormThemeModelAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormThemeModelAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormThemeModelAdapter_009', 0, () => {
      expect(FormThemeModelAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormThemeModelAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormThemeModelAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormThemeModelAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormThemeModelAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormThemeModelAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormThemeModelAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormThemeModelAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormThemeModelAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormThemeModelAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormThemeModelAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormThemeModelAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormThemeModelAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormThemeModelAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormThemeModelAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormThemeModelAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormThemeModelAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormThemeModelAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormThemeModelAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormThemeModelAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormThemeModelAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormThemeModelAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormThemeModelAdapter_010', 0, () => {
      expect(FormThemeModelAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormThemeModelAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormThemeModelAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormThemeModelAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormThemeModelAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormThemeModelAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormThemeModelAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormThemeModelAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormThemeModelAdapter_011', 0, () => {
      expect(FormThemeModelAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormThemeModelAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormThemeModelAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormThemeModelAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormThemeModelAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormThemeModelAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormThemeModelAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormThemeModelAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormThemeModelAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormThemeModelAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormThemeModelAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormThemeModelAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormThemeModelAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormThemeModelAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormThemeModelAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormThemeModelAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormThemeModelAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormThemeModelAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormThemeModelAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormThemeModelAdapter_012', 0, () => {
      expect(FormThemeModelAdapter.checkArr([]) === false).assertTrue();
      expect(FormThemeModelAdapter.checkArr(null) === false).assertTrue();
      expect(FormThemeModelAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormThemeModelAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormThemeModelAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormThemeModelAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormThemeModelAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormThemeModelAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormThemeModelAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormThemeModelAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormThemeModelAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormThemeModelAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormThemeModelAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormThemeModelAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormThemeModelAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormThemeModelAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormThemeModelAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormThemeModelAdapter_013', 0, () => {
      expect(FormThemeModelAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormThemeModelAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormThemeModelAdapter_014', 0, () => {
      expect(FormThemeModelAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormThemeModelAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormThemeModelAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormThemeModelAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormThemeModelAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormThemeModelAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormThemeModelAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormThemeModelAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormThemeModelAdapter_015', 0, () => {
      expect(FormThemeModelAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormThemeModelAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormThemeModelAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormThemeModelAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormThemeModelAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormThemeModelAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormThemeModelAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormThemeModelAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormThemeModelAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormThemeModelAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormThemeModelAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormThemeModelAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormThemeModelAdapter_016', 0, () => {
      expect(FormThemeModelAdapter.isEmpty(null)).assertTrue();
      expect(FormThemeModelAdapter.isEmpty(undefined)).assertTrue();
      expect(FormThemeModelAdapter.isEmpty('')).assertTrue();
      expect(FormThemeModelAdapter.isEmpty(0)).assertTrue();
      expect(FormThemeModelAdapter.isEmpty([])).assertTrue();
      expect(FormThemeModelAdapter.isEmpty(1, null)).assertTrue();
      expect(FormThemeModelAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormThemeModelAdapter.isEmpty(1, true)).assertTrue();
      expect(FormThemeModelAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormThemeModelAdapter_017', 0, () => {
      expect(FormThemeModelAdapter.equals(null, 'a')).assertFalse();
      expect(FormThemeModelAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormThemeModelAdapter.equals('a', null)).assertFalse();
      expect(FormThemeModelAdapter.equals('a', undefined)).assertFalse();
      expect(FormThemeModelAdapter.equals('a', 1)).assertFalse();
      expect(FormThemeModelAdapter.equals(1, 'a')).assertFalse();
      expect(FormThemeModelAdapter.equals(1, [])).assertFalse();
      expect(FormThemeModelAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormThemeModelAdapter.equals([], m)).assertFalse();
      expect(FormThemeModelAdapter.equals(m, [])).assertFalse();
      expect(FormThemeModelAdapter.equals([1,2], [])).assertFalse();
      expect(FormThemeModelAdapter.equals([], [1, 2])).assertFalse();
      expect(FormThemeModelAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormThemeModelAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormThemeModelAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormThemeModelAdapter.equals(2, 2)).assertTrue();
    })
  });
}