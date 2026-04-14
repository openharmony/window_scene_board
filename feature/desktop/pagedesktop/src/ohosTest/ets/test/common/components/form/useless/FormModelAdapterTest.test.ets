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
import { FormModelAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormModelAdapter';

export function FormModelAdapterTest() {
  describe('FormModelAdapterTest', () => {
    it('FormModelAdapter_001', 0, () => {
      expect(FormModelAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormModelAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormModelAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormModelAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormModelAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormModelAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormModelAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormModelAdapter_002', 0, () => {
      expect(FormModelAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormModelAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormModelAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormModelAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormModelAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormModelAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormModelAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormModelAdapter_003', 0, () => {
      expect(FormModelAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormModelAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormModelAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormModelAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormModelAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormModelAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormModelAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormModelAdapter_004', 0, () => {
      expect(FormModelAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormModelAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormModelAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormModelAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormModelAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormModelAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormModelAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormModelAdapter_005', 0, () => {
      expect(FormModelAdapter.isNumber("")).assertFalse();
      expect(FormModelAdapter.isNumber(null)).assertFalse();
      expect(FormModelAdapter.isNumber(undefined)).assertFalse();
      expect(FormModelAdapter.isNumber("abc")).assertFalse();
      expect(FormModelAdapter.isNumber("123")).assertTrue();
    });

    it('FormModelAdapter_006', 0, () => {
      expect(FormModelAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormModelAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormModelAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormModelAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormModelAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormModelAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormModelAdapter_007', 0, () => {
      expect(FormModelAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormModelAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormModelAdapter.getDefaultId('') === '').assertTrue();
      expect(FormModelAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormModelAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormModelAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormModelAdapter_008', 0, () => {
      expect(FormModelAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormModelAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormModelAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormModelAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormModelAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormModelAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormModelAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormModelAdapter_009', 0, () => {
      expect(FormModelAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormModelAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormModelAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormModelAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormModelAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormModelAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormModelAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormModelAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormModelAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormModelAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormModelAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormModelAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormModelAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormModelAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormModelAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormModelAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormModelAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormModelAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormModelAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormModelAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormModelAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormModelAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormModelAdapter_010', 0, () => {
      expect(FormModelAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormModelAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormModelAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormModelAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormModelAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormModelAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormModelAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormModelAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormModelAdapter_011', 0, () => {
      expect(FormModelAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormModelAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormModelAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormModelAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormModelAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormModelAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormModelAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormModelAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormModelAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormModelAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormModelAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormModelAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormModelAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormModelAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormModelAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormModelAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormModelAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormModelAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormModelAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormModelAdapter_012', 0, () => {
      expect(FormModelAdapter.checkArr([]) === false).assertTrue();
      expect(FormModelAdapter.checkArr(null) === false).assertTrue();
      expect(FormModelAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormModelAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormModelAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormModelAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormModelAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormModelAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormModelAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormModelAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormModelAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormModelAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormModelAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormModelAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormModelAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormModelAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormModelAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormModelAdapter_013', 0, () => {
      expect(FormModelAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormModelAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormModelAdapter_014', 0, () => {
      expect(FormModelAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormModelAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormModelAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormModelAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormModelAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormModelAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormModelAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormModelAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormModelAdapter_015', 0, () => {
      expect(FormModelAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormModelAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormModelAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormModelAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormModelAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormModelAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormModelAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormModelAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormModelAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormModelAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormModelAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormModelAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormModelAdapter_016', 0, () => {
      expect(FormModelAdapter.isEmpty(null)).assertTrue();
      expect(FormModelAdapter.isEmpty(undefined)).assertTrue();
      expect(FormModelAdapter.isEmpty('')).assertTrue();
      expect(FormModelAdapter.isEmpty(0)).assertTrue();
      expect(FormModelAdapter.isEmpty([])).assertTrue();
      expect(FormModelAdapter.isEmpty(1, null)).assertTrue();
      expect(FormModelAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormModelAdapter.isEmpty(1, true)).assertTrue();
      expect(FormModelAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormModelAdapter_017', 0, () => {
      expect(FormModelAdapter.equals(null, 'a')).assertFalse();
      expect(FormModelAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormModelAdapter.equals('a', null)).assertFalse();
      expect(FormModelAdapter.equals('a', undefined)).assertFalse();
      expect(FormModelAdapter.equals('a', 1)).assertFalse();
      expect(FormModelAdapter.equals(1, 'a')).assertFalse();
      expect(FormModelAdapter.equals(1, [])).assertFalse();
      expect(FormModelAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormModelAdapter.equals([], m)).assertFalse();
      expect(FormModelAdapter.equals(m, [])).assertFalse();
      expect(FormModelAdapter.equals([1,2], [])).assertFalse();
      expect(FormModelAdapter.equals([], [1, 2])).assertFalse();
      expect(FormModelAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormModelAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormModelAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormModelAdapter.equals(2, 2)).assertTrue();
    })
  });
}