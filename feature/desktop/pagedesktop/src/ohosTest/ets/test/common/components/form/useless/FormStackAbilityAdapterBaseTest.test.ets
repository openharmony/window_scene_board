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
import { FormStackAbilityAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackAbilityAdapter';

export function FormStackAbilityAdapterBaseTest() {
  describe('FormStackAbilityAdapterBaseTest', () => {
    it('FormStackAbilityAdapter_001', 0, () => {
      expect(FormStackAbilityAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackAbilityAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackAbilityAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackAbilityAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackAbilityAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackAbilityAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackAbilityAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackAbilityAdapter_002', 0, () => {
      expect(FormStackAbilityAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackAbilityAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackAbilityAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackAbilityAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackAbilityAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackAbilityAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackAbilityAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackAbilityAdapter_003', 0, () => {
      expect(FormStackAbilityAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackAbilityAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackAbilityAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAbilityAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAbilityAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAbilityAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackAbilityAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackAbilityAdapter_004', 0, () => {
      expect(FormStackAbilityAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackAbilityAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackAbilityAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAbilityAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAbilityAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAbilityAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackAbilityAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackAbilityAdapter_005', 0, () => {
      expect(FormStackAbilityAdapter.isNumber("")).assertFalse();
      expect(FormStackAbilityAdapter.isNumber(null)).assertFalse();
      expect(FormStackAbilityAdapter.isNumber(undefined)).assertFalse();
      expect(FormStackAbilityAdapter.isNumber("abc")).assertFalse();
      expect(FormStackAbilityAdapter.isNumber("123")).assertTrue();
    });

    it('FormStackAbilityAdapter_006', 0, () => {
      expect(FormStackAbilityAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackAbilityAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackAbilityAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackAbilityAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackAbilityAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackAbilityAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackAbilityAdapter_007', 0, () => {
      expect(FormStackAbilityAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormStackAbilityAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackAbilityAdapter.getDefaultId('') === '').assertTrue();
      expect(FormStackAbilityAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormStackAbilityAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackAbilityAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackAbilityAdapter_008', 0, () => {
      expect(FormStackAbilityAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackAbilityAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackAbilityAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackAbilityAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackAbilityAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackAbilityAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackAbilityAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackAbilityAdapter_009', 0, () => {
      expect(FormStackAbilityAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormStackAbilityAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackAbilityAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackAbilityAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackAbilityAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackAbilityAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackAbilityAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackAbilityAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackAbilityAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackAbilityAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackAbilityAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackAbilityAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackAbilityAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackAbilityAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackAbilityAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackAbilityAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackAbilityAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackAbilityAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackAbilityAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackAbilityAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackAbilityAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackAbilityAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackAbilityAdapter_010', 0, () => {
      expect(FormStackAbilityAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormStackAbilityAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackAbilityAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackAbilityAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackAbilityAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackAbilityAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackAbilityAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackAbilityAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackAbilityAdapter_011', 0, () => {
      expect(FormStackAbilityAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackAbilityAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackAbilityAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackAbilityAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackAbilityAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackAbilityAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackAbilityAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackAbilityAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackAbilityAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackAbilityAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackAbilityAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackAbilityAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackAbilityAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackAbilityAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackAbilityAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackAbilityAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackAbilityAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackAbilityAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackAbilityAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackAbilityAdapter_012', 0, () => {
      expect(FormStackAbilityAdapter.checkArr([]) === false).assertTrue();
      expect(FormStackAbilityAdapter.checkArr(null) === false).assertTrue();
      expect(FormStackAbilityAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormStackAbilityAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackAbilityAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackAbilityAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackAbilityAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackAbilityAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackAbilityAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackAbilityAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackAbilityAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackAbilityAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackAbilityAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackAbilityAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackAbilityAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackAbilityAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackAbilityAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormStackAbilityAdapter_013', 0, () => {
      expect(FormStackAbilityAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackAbilityAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackAbilityAdapter_014', 0, () => {
      expect(FormStackAbilityAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackAbilityAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackAbilityAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackAbilityAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackAbilityAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackAbilityAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackAbilityAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackAbilityAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackAbilityAdapter_015', 0, () => {
      expect(FormStackAbilityAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackAbilityAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackAbilityAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormStackAbilityAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackAbilityAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackAbilityAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackAbilityAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackAbilityAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackAbilityAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackAbilityAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackAbilityAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackAbilityAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackAbilityAdapter_016', 0, () => {
      expect(FormStackAbilityAdapter.isEmpty(null)).assertTrue();
      expect(FormStackAbilityAdapter.isEmpty(undefined)).assertTrue();
      expect(FormStackAbilityAdapter.isEmpty('')).assertTrue();
      expect(FormStackAbilityAdapter.isEmpty(0)).assertTrue();
      expect(FormStackAbilityAdapter.isEmpty([])).assertTrue();
      expect(FormStackAbilityAdapter.isEmpty(1, null)).assertTrue();
      expect(FormStackAbilityAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormStackAbilityAdapter.isEmpty(1, true)).assertTrue();
      expect(FormStackAbilityAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormStackAbilityAdapter_017', 0, () => {
      expect(FormStackAbilityAdapter.equals(null, 'a')).assertFalse();
      expect(FormStackAbilityAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormStackAbilityAdapter.equals('a', null)).assertFalse();
      expect(FormStackAbilityAdapter.equals('a', undefined)).assertFalse();
      expect(FormStackAbilityAdapter.equals('a', 1)).assertFalse();
      expect(FormStackAbilityAdapter.equals(1, 'a')).assertFalse();
      expect(FormStackAbilityAdapter.equals(1, [])).assertFalse();
      expect(FormStackAbilityAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackAbilityAdapter.equals([], m)).assertFalse();
      expect(FormStackAbilityAdapter.equals(m, [])).assertFalse();
      expect(FormStackAbilityAdapter.equals([1,2], [])).assertFalse();
      expect(FormStackAbilityAdapter.equals([], [1, 2])).assertFalse();
      expect(FormStackAbilityAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormStackAbilityAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackAbilityAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackAbilityAdapter.equals(2, 2)).assertTrue();
    })
  });
}