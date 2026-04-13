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
import { FormAbilityAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormAbilityAdapter';

export function FormAbilityAdapterTest() {
  describe('FormAbilityAdapterTest', () => {
    it('FormAbilityAdapter_001', 0, () => {
      expect(FormAbilityAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormAbilityAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormAbilityAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormAbilityAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormAbilityAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormAbilityAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormAbilityAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAbilityAdapter_002', 0, () => {
      expect(FormAbilityAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormAbilityAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormAbilityAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormAbilityAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormAbilityAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormAbilityAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormAbilityAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAbilityAdapter_003', 0, () => {
      expect(FormAbilityAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormAbilityAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormAbilityAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormAbilityAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormAbilityAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormAbilityAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormAbilityAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAbilityAdapter_004', 0, () => {
      expect(FormAbilityAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormAbilityAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormAbilityAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormAbilityAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormAbilityAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormAbilityAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormAbilityAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAbilityAdapter_005', 0, () => {
      expect(FormAbilityAdapter.isNumber("")).assertFalse();
      expect(FormAbilityAdapter.isNumber(null)).assertFalse();
      expect(FormAbilityAdapter.isNumber(undefined)).assertFalse();
      expect(FormAbilityAdapter.isNumber("abc")).assertFalse();
      expect(FormAbilityAdapter.isNumber("123")).assertTrue();
    });

    it('FormAbilityAdapter_006', 0, () => {
      expect(FormAbilityAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormAbilityAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormAbilityAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormAbilityAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormAbilityAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormAbilityAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAbilityAdapter_007', 0, () => {
      expect(FormAbilityAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormAbilityAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormAbilityAdapter.getDefaultId('') === '').assertTrue();
      expect(FormAbilityAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormAbilityAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormAbilityAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAbilityAdapter_008', 0, () => {
      expect(FormAbilityAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormAbilityAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormAbilityAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormAbilityAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormAbilityAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormAbilityAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormAbilityAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAbilityAdapter_009', 0, () => {
      expect(FormAbilityAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormAbilityAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormAbilityAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormAbilityAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormAbilityAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormAbilityAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormAbilityAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormAbilityAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormAbilityAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormAbilityAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormAbilityAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormAbilityAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormAbilityAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormAbilityAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormAbilityAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormAbilityAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormAbilityAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormAbilityAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormAbilityAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormAbilityAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormAbilityAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormAbilityAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAbilityAdapter_010', 0, () => {
      expect(FormAbilityAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormAbilityAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormAbilityAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormAbilityAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormAbilityAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormAbilityAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormAbilityAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormAbilityAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAbilityAdapter_011', 0, () => {
      expect(FormAbilityAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormAbilityAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormAbilityAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormAbilityAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormAbilityAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormAbilityAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormAbilityAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormAbilityAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormAbilityAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormAbilityAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormAbilityAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormAbilityAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormAbilityAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormAbilityAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormAbilityAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormAbilityAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormAbilityAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormAbilityAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormAbilityAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAbilityAdapter_012', 0, () => {
      expect(FormAbilityAdapter.checkArr([]) === false).assertTrue();
      expect(FormAbilityAdapter.checkArr(null) === false).assertTrue();
      expect(FormAbilityAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormAbilityAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormAbilityAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormAbilityAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormAbilityAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormAbilityAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormAbilityAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormAbilityAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormAbilityAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormAbilityAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormAbilityAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormAbilityAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormAbilityAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormAbilityAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormAbilityAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormAbilityAdapter_013', 0, () => {
      expect(FormAbilityAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormAbilityAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAbilityAdapter_014', 0, () => {
      expect(FormAbilityAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormAbilityAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormAbilityAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormAbilityAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormAbilityAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormAbilityAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormAbilityAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormAbilityAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAbilityAdapter_015', 0, () => {
      expect(FormAbilityAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormAbilityAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormAbilityAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormAbilityAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormAbilityAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormAbilityAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormAbilityAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormAbilityAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormAbilityAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormAbilityAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormAbilityAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormAbilityAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAbilityAdapter_016', 0, () => {
      expect(FormAbilityAdapter.isEmpty(null)).assertTrue();
      expect(FormAbilityAdapter.isEmpty(undefined)).assertTrue();
      expect(FormAbilityAdapter.isEmpty('')).assertTrue();
      expect(FormAbilityAdapter.isEmpty(0)).assertTrue();
      expect(FormAbilityAdapter.isEmpty([])).assertTrue();
      expect(FormAbilityAdapter.isEmpty(1, null)).assertTrue();
      expect(FormAbilityAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormAbilityAdapter.isEmpty(1, true)).assertTrue();
      expect(FormAbilityAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormAbilityAdapter_017', 0, () => {
      expect(FormAbilityAdapter.equals(null, 'a')).assertFalse();
      expect(FormAbilityAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormAbilityAdapter.equals('a', null)).assertFalse();
      expect(FormAbilityAdapter.equals('a', undefined)).assertFalse();
      expect(FormAbilityAdapter.equals('a', 1)).assertFalse();
      expect(FormAbilityAdapter.equals(1, 'a')).assertFalse();
      expect(FormAbilityAdapter.equals(1, [])).assertFalse();
      expect(FormAbilityAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormAbilityAdapter.equals([], m)).assertFalse();
      expect(FormAbilityAdapter.equals(m, [])).assertFalse();
      expect(FormAbilityAdapter.equals([1,2], [])).assertFalse();
      expect(FormAbilityAdapter.equals([], [1, 2])).assertFalse();
      expect(FormAbilityAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormAbilityAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormAbilityAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormAbilityAdapter.equals(2, 2)).assertTrue();
    })
  });
}