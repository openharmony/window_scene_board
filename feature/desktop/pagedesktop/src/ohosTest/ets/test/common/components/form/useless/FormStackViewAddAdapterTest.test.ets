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
import { FormStackViewAddAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackViewAddAdapter';

export function FormStackViewAddAdapterTest() {
  describe('FormStackViewAddAdapterTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackViewAddAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackViewAddAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackViewAddAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackViewAddAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackViewAddAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackViewAddAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackViewAddAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackViewAddAdapter_002', 0, () => {
      expect(FormStackViewAddAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackViewAddAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackViewAddAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewAddAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackViewAddAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewAddAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackViewAddAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackViewAddAdapter_003', 0, () => {
      expect(FormStackViewAddAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackViewAddAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewAddAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewAddAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewAddAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewAddAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackViewAddAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackViewAddAdapter_004', 0, () => {
      expect(FormStackViewAddAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackViewAddAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewAddAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewAddAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewAddAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewAddAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackViewAddAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackViewAddAdapter_005', 0, () => {
      expect(FormStackViewAddAdapter.isNumber("")).assertFalse();
      expect(FormStackViewAddAdapter.isNumber(null)).assertFalse();
      expect(FormStackViewAddAdapter.isNumber(undefined)).assertFalse();
      expect(FormStackViewAddAdapter.isNumber("abc")).assertFalse();
      expect(FormStackViewAddAdapter.isNumber("123")).assertTrue();
    });

    it('FormStackViewAddAdapter_006', 0, () => {
      expect(FormStackViewAddAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackViewAddAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackViewAddAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackViewAddAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackViewAddAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackViewAddAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackViewAddAdapter_007', 0, () => {
      expect(FormStackViewAddAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormStackViewAddAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackViewAddAdapter.getDefaultId('') === '').assertTrue();
      expect(FormStackViewAddAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormStackViewAddAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackViewAddAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackViewAddAdapter_008', 0, () => {
      expect(FormStackViewAddAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackViewAddAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackViewAddAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackViewAddAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackViewAddAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackViewAddAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackViewAddAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackViewAddAdapter_009', 0, () => {
      expect(FormStackViewAddAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormStackViewAddAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackViewAddAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackViewAddAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackViewAddAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackViewAddAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackViewAddAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackViewAddAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackViewAddAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackViewAddAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackViewAddAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackViewAddAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackViewAddAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackViewAddAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackViewAddAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackViewAddAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackViewAddAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackViewAddAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackViewAddAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackViewAddAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackViewAddAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackViewAddAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackViewAddAdapter_010', 0, () => {
      expect(FormStackViewAddAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormStackViewAddAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackViewAddAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackViewAddAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackViewAddAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackViewAddAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackViewAddAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackViewAddAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackViewAddAdapter_011', 0, () => {
      expect(FormStackViewAddAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackViewAddAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackViewAddAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackViewAddAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackViewAddAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackViewAddAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackViewAddAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackViewAddAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackViewAddAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackViewAddAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackViewAddAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackViewAddAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackViewAddAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackViewAddAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackViewAddAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackViewAddAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackViewAddAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackViewAddAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackViewAddAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackViewAddAdapter_012', 0, () => {
      expect(FormStackViewAddAdapter.checkArr([]) === false).assertTrue();
      expect(FormStackViewAddAdapter.checkArr(null) === false).assertTrue();
      expect(FormStackViewAddAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormStackViewAddAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackViewAddAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackViewAddAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackViewAddAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackViewAddAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackViewAddAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackViewAddAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackViewAddAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackViewAddAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackViewAddAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackViewAddAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackViewAddAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackViewAddAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackViewAddAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormStackViewAddAdapter_013', 0, () => {
      expect(FormStackViewAddAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackViewAddAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackViewAddAdapter_014', 0, () => {
      expect(FormStackViewAddAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackViewAddAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackViewAddAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackViewAddAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackViewAddAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackViewAddAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackViewAddAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackViewAddAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackViewAddAdapter_015', 0, () => {
      expect(FormStackViewAddAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackViewAddAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackViewAddAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormStackViewAddAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackViewAddAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackViewAddAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackViewAddAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackViewAddAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackViewAddAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackViewAddAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackViewAddAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackViewAddAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackViewAddAdapter_016', 0, () => {
      expect(FormStackViewAddAdapter.isEmpty(null)).assertTrue();
      expect(FormStackViewAddAdapter.isEmpty(undefined)).assertTrue();
      expect(FormStackViewAddAdapter.isEmpty('')).assertTrue();
      expect(FormStackViewAddAdapter.isEmpty(0)).assertTrue();
      expect(FormStackViewAddAdapter.isEmpty([])).assertTrue();
      expect(FormStackViewAddAdapter.isEmpty(1, null)).assertTrue();
      expect(FormStackViewAddAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormStackViewAddAdapter.isEmpty(1, true)).assertTrue();
      expect(FormStackViewAddAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormStackViewAddAdapter_017', 0, () => {
      expect(FormStackViewAddAdapter.equals(null, 'a')).assertFalse();
      expect(FormStackViewAddAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormStackViewAddAdapter.equals('a', null)).assertFalse();
      expect(FormStackViewAddAdapter.equals('a', undefined)).assertFalse();
      expect(FormStackViewAddAdapter.equals('a', 1)).assertFalse();
      expect(FormStackViewAddAdapter.equals(1, 'a')).assertFalse();
      expect(FormStackViewAddAdapter.equals(1, [])).assertFalse();
      expect(FormStackViewAddAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackViewAddAdapter.equals([], m)).assertFalse();
      expect(FormStackViewAddAdapter.equals(m, [])).assertFalse();
      expect(FormStackViewAddAdapter.equals([1,2], [])).assertFalse();
      expect(FormStackViewAddAdapter.equals([], [1, 2])).assertFalse();
      expect(FormStackViewAddAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormStackViewAddAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackViewAddAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackViewAddAdapter.equals(2, 2)).assertTrue();
    })
  });
}