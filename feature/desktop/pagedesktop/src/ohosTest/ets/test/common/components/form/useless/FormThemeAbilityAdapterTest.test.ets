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
import { FormThemeAbilityAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormThemeAbilityAdapter';

export function FormThemeAbilityAdapterTest() {
  describe('FormThemeAbilityAdapterTest', () => {
    it('FormThemeAbilityAdapter_001', 0, () => {
      expect(FormThemeAbilityAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormThemeAbilityAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormThemeAbilityAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormThemeAbilityAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormThemeAbilityAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormThemeAbilityAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormThemeAbilityAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormThemeAbilityAdapter_002', 0, () => {
      expect(FormThemeAbilityAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormThemeAbilityAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormThemeAbilityAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAbilityAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormThemeAbilityAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAbilityAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormThemeAbilityAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormThemeAbilityAdapter_003', 0, () => {
      expect(FormThemeAbilityAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormThemeAbilityAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAbilityAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAbilityAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAbilityAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAbilityAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormThemeAbilityAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormThemeAbilityAdapter_004', 0, () => {
      expect(FormThemeAbilityAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormThemeAbilityAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAbilityAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAbilityAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAbilityAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAbilityAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormThemeAbilityAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormThemeAbilityAdapter_005', 0, () => {
      expect(FormThemeAbilityAdapter.isNumber("")).assertFalse();
      expect(FormThemeAbilityAdapter.isNumber(null)).assertFalse();
      expect(FormThemeAbilityAdapter.isNumber(undefined)).assertFalse();
      expect(FormThemeAbilityAdapter.isNumber("abc")).assertFalse();
      expect(FormThemeAbilityAdapter.isNumber("123")).assertTrue();
    });

    it('FormThemeAbilityAdapter_006', 0, () => {
      expect(FormThemeAbilityAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormThemeAbilityAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormThemeAbilityAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormThemeAbilityAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormThemeAbilityAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormThemeAbilityAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormThemeAbilityAdapter_007', 0, () => {
      expect(FormThemeAbilityAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormThemeAbilityAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormThemeAbilityAdapter.getDefaultId('') === '').assertTrue();
      expect(FormThemeAbilityAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormThemeAbilityAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormThemeAbilityAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormThemeAbilityAdapter_008', 0, () => {
      expect(FormThemeAbilityAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormThemeAbilityAdapter_009', 0, () => {
      expect(FormThemeAbilityAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormThemeAbilityAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormThemeAbilityAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormThemeAbilityAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormThemeAbilityAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormThemeAbilityAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormThemeAbilityAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormThemeAbilityAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormThemeAbilityAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormThemeAbilityAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormThemeAbilityAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormThemeAbilityAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormThemeAbilityAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormThemeAbilityAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormThemeAbilityAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormThemeAbilityAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormThemeAbilityAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormThemeAbilityAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormThemeAbilityAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormThemeAbilityAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormThemeAbilityAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormThemeAbilityAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormThemeAbilityAdapter_010', 0, () => {
      expect(FormThemeAbilityAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormThemeAbilityAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormThemeAbilityAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormThemeAbilityAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormThemeAbilityAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormThemeAbilityAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormThemeAbilityAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormThemeAbilityAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormThemeAbilityAdapter_011', 0, () => {
      expect(FormThemeAbilityAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormThemeAbilityAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormThemeAbilityAdapter_012', 0, () => {
      expect(FormThemeAbilityAdapter.checkArr([]) === false).assertTrue();
      expect(FormThemeAbilityAdapter.checkArr(null) === false).assertTrue();
      expect(FormThemeAbilityAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormThemeAbilityAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormThemeAbilityAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormThemeAbilityAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormThemeAbilityAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormThemeAbilityAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormThemeAbilityAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormThemeAbilityAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormThemeAbilityAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormThemeAbilityAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormThemeAbilityAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormThemeAbilityAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormThemeAbilityAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormThemeAbilityAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormThemeAbilityAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormThemeAbilityAdapter_013', 0, () => {
      expect(FormThemeAbilityAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormThemeAbilityAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormThemeAbilityAdapter_014', 0, () => {
      expect(FormThemeAbilityAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormThemeAbilityAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormThemeAbilityAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormThemeAbilityAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormThemeAbilityAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormThemeAbilityAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormThemeAbilityAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormThemeAbilityAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormThemeAbilityAdapter_015', 0, () => {
      expect(FormThemeAbilityAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormThemeAbilityAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormThemeAbilityAdapter_016', 0, () => {
      expect(FormThemeAbilityAdapter.isEmpty(null)).assertTrue();
      expect(FormThemeAbilityAdapter.isEmpty(undefined)).assertTrue();
      expect(FormThemeAbilityAdapter.isEmpty('')).assertTrue();
      expect(FormThemeAbilityAdapter.isEmpty(0)).assertTrue();
      expect(FormThemeAbilityAdapter.isEmpty([])).assertTrue();
      expect(FormThemeAbilityAdapter.isEmpty(1, null)).assertTrue();
      expect(FormThemeAbilityAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormThemeAbilityAdapter.isEmpty(1, true)).assertTrue();
      expect(FormThemeAbilityAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormThemeAbilityAdapter_017', 0, () => {
      expect(FormThemeAbilityAdapter.equals(null, 'a')).assertFalse();
      expect(FormThemeAbilityAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormThemeAbilityAdapter.equals('a', null)).assertFalse();
      expect(FormThemeAbilityAdapter.equals('a', undefined)).assertFalse();
      expect(FormThemeAbilityAdapter.equals('a', 1)).assertFalse();
      expect(FormThemeAbilityAdapter.equals(1, 'a')).assertFalse();
      expect(FormThemeAbilityAdapter.equals(1, [])).assertFalse();
      expect(FormThemeAbilityAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormThemeAbilityAdapter.equals([], m)).assertFalse();
      expect(FormThemeAbilityAdapter.equals(m, [])).assertFalse();
      expect(FormThemeAbilityAdapter.equals([1,2], [])).assertFalse();
      expect(FormThemeAbilityAdapter.equals([], [1, 2])).assertFalse();
      expect(FormThemeAbilityAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormThemeAbilityAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormThemeAbilityAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormThemeAbilityAdapter.equals(2, 2)).assertTrue();
    })
  });
}