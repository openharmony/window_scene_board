/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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
import { FormDatabaseUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormDatabaseUtil';

export function FormAbilityAdapterTest() {
  describe('FormAbilityAdapterTest', () => {
    it('FormAbilityAdapter_001', 0, () => {
      expect(FormDatabaseUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormDatabaseUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormDatabaseUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormDatabaseUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormDatabaseUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormDatabaseUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormDatabaseUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAbilityAdapter_002', 0, () => {
      expect(FormDatabaseUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormDatabaseUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormDatabaseUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormDatabaseUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormDatabaseUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormDatabaseUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormDatabaseUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAbilityAdapter_003', 0, () => {
      expect(FormDatabaseUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormDatabaseUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormDatabaseUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormDatabaseUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormDatabaseUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormDatabaseUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormDatabaseUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAbilityAdapter_004', 0, () => {
      expect(FormDatabaseUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormDatabaseUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormDatabaseUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormDatabaseUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormDatabaseUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormDatabaseUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormDatabaseUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAbilityAdapter_005', 0, () => {
      expect(FormDatabaseUtil.isNumber("")).assertFalse();
      expect(FormDatabaseUtil.isNumber(null)).assertFalse();
      expect(FormDatabaseUtil.isNumber(undefined)).assertFalse();
      expect(FormDatabaseUtil.isNumber("abc")).assertFalse();
      expect(FormDatabaseUtil.isNumber("123")).assertTrue();
    });

    it('FormAbilityAdapter_006', 0, () => {
      expect(FormDatabaseUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormDatabaseUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormDatabaseUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormDatabaseUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormDatabaseUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormDatabaseUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAbilityAdapter_007', 0, () => {
      expect(FormDatabaseUtil.getDefaultId(null) === null).assertTrue();
      expect(FormDatabaseUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormDatabaseUtil.getDefaultId('') === '').assertTrue();
      expect(FormDatabaseUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormDatabaseUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormDatabaseUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAbilityAdapter_008', 0, () => {
      expect(FormDatabaseUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormDatabaseUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormDatabaseUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormDatabaseUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormDatabaseUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormDatabaseUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormDatabaseUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAbilityAdapter_009', 0, () => {
      expect(FormDatabaseUtil.drawFontWidth() === -1).assertTrue();
      expect(FormDatabaseUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormDatabaseUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormDatabaseUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormDatabaseUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormDatabaseUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormDatabaseUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormDatabaseUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormDatabaseUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormDatabaseUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormDatabaseUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormDatabaseUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormDatabaseUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormDatabaseUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormDatabaseUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormDatabaseUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormDatabaseUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormDatabaseUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormDatabaseUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormDatabaseUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormDatabaseUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormDatabaseUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAbilityAdapter_010', 0, () => {
      expect(FormDatabaseUtil.drawTextAlign() === -1).assertTrue();
      expect(FormDatabaseUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormDatabaseUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormDatabaseUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormDatabaseUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormDatabaseUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormDatabaseUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormDatabaseUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAbilityAdapter_011', 0, () => {
      expect(FormDatabaseUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormDatabaseUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormDatabaseUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormDatabaseUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormDatabaseUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormDatabaseUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormDatabaseUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormDatabaseUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormDatabaseUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormDatabaseUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormDatabaseUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormDatabaseUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormDatabaseUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormDatabaseUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormDatabaseUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormDatabaseUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormDatabaseUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormDatabaseUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormDatabaseUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAbilityAdapter_012', 0, () => {
      expect(FormDatabaseUtil.checkArr([]) === false).assertTrue();
      expect(FormDatabaseUtil.checkArr(null) === false).assertTrue();
      expect(FormDatabaseUtil.checkArr(undefined) === false).assertTrue();
      expect(FormDatabaseUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormDatabaseUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormDatabaseUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormDatabaseUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormDatabaseUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormDatabaseUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormDatabaseUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormDatabaseUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormDatabaseUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormDatabaseUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormDatabaseUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormDatabaseUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormDatabaseUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormDatabaseUtil.getUUID().length > 0).assertTrue();
    })

    it('FormAbilityAdapter_013', 0, () => {
      expect(FormDatabaseUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormDatabaseUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAbilityAdapter_014', 0, () => {
      expect(FormDatabaseUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormDatabaseUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormDatabaseUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormDatabaseUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormDatabaseUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormDatabaseUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormDatabaseUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormDatabaseUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAbilityAdapter_015', 0, () => {
      expect(FormDatabaseUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormDatabaseUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormDatabaseUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormDatabaseUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormDatabaseUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormDatabaseUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormDatabaseUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormDatabaseUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormDatabaseUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormDatabaseUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormDatabaseUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormDatabaseUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAbilityAdapter_016', 0, () => {
      expect(FormDatabaseUtil.isEmpty(null)).assertTrue();
      expect(FormDatabaseUtil.isEmpty(undefined)).assertTrue();
      expect(FormDatabaseUtil.isEmpty('')).assertTrue();
      expect(FormDatabaseUtil.isEmpty(0)).assertTrue();
      expect(FormDatabaseUtil.isEmpty([])).assertTrue();
      expect(FormDatabaseUtil.isEmpty(1, null)).assertTrue();
      expect(FormDatabaseUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormDatabaseUtil.isEmpty(1, true)).assertTrue();
      expect(FormDatabaseUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormAbilityAdapter_017', 0, () => {
      expect(FormDatabaseUtil.equals(null, 'a')).assertFalse();
      expect(FormDatabaseUtil.equals(undefined, 'a')).assertFalse();
      expect(FormDatabaseUtil.equals('a', null)).assertFalse();
      expect(FormDatabaseUtil.equals('a', undefined)).assertFalse();
      expect(FormDatabaseUtil.equals('a', 1)).assertFalse();
      expect(FormDatabaseUtil.equals(1, 'a')).assertFalse();
      expect(FormDatabaseUtil.equals(1, [])).assertFalse();
      expect(FormDatabaseUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormDatabaseUtil.equals([], m)).assertFalse();
      expect(FormDatabaseUtil.equals(m, [])).assertFalse();
      expect(FormDatabaseUtil.equals([1,2], [])).assertFalse();
      expect(FormDatabaseUtil.equals([], [1, 2])).assertFalse();
      expect(FormDatabaseUtil.equals([1], [1, 2])).assertFalse();
      expect(FormDatabaseUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormDatabaseUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormDatabaseUtil.equals(2, 2)).assertTrue();
    })
  });
}