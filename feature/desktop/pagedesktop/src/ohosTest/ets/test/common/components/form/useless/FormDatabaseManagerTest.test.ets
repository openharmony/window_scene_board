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
import { FormDatabaseManager } from '../../../../../../../main/ets/default/common/components/form/useless/FormDatabaseManager';

export function FormAbilityAdapterTest() {
  describe('FormAbilityAdapterTest', () => {
    it('FormAbilityAdapter_001', 0, () => {
      expect(FormDatabaseManager.getSum("", '1') === -1).assertEqual(true);
      expect(FormDatabaseManager.getSum(null, '1') === -1).assertEqual(true);
      expect(FormDatabaseManager.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormDatabaseManager.getSum('1', '') === -1).assertEqual(true);
      expect(FormDatabaseManager.getSum('1', null) === -1).assertEqual(true);
      expect(FormDatabaseManager.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormDatabaseManager.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAbilityAdapter_002', 0, () => {
      expect(FormDatabaseManager.stringToArray("", ",").length === 0).assertTrue();
      expect(FormDatabaseManager.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormDatabaseManager.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormDatabaseManager.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormDatabaseManager.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormDatabaseManager.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormDatabaseManager.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAbilityAdapter_003', 0, () => {
      expect(FormDatabaseManager.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormDatabaseManager.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormDatabaseManager.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormDatabaseManager.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormDatabaseManager.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormDatabaseManager.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormDatabaseManager.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAbilityAdapter_004', 0, () => {
      expect(FormDatabaseManager.getIntValues("", ",").length === 0).assertTrue();
      expect(FormDatabaseManager.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormDatabaseManager.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormDatabaseManager.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormDatabaseManager.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormDatabaseManager.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormDatabaseManager.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAbilityAdapter_005', 0, () => {
      expect(FormDatabaseManager.isNumber("")).assertFalse();
      expect(FormDatabaseManager.isNumber(null)).assertFalse();
      expect(FormDatabaseManager.isNumber(undefined)).assertFalse();
      expect(FormDatabaseManager.isNumber("abc")).assertFalse();
      expect(FormDatabaseManager.isNumber("123")).assertTrue();
    });

    it('FormAbilityAdapter_006', 0, () => {
      expect(FormDatabaseManager.getStrByCount(null , 1) === '').assertTrue();
      expect(FormDatabaseManager.getStrByCount('' , 1) === '').assertTrue();
      expect(FormDatabaseManager.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormDatabaseManager.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormDatabaseManager.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormDatabaseManager.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAbilityAdapter_007', 0, () => {
      expect(FormDatabaseManager.getDefaultId(null) === null).assertTrue();
      expect(FormDatabaseManager.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormDatabaseManager.getDefaultId('') === '').assertTrue();
      expect(FormDatabaseManager.getDefaultId('default') !== '').assertTrue();
      expect(FormDatabaseManager.getDefaultId('aaa') !== '').assertTrue();
      expect(FormDatabaseManager.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAbilityAdapter_008', 0, () => {
      expect(FormDatabaseManager.getIndexByString("", []) === -1).assertTrue();
      expect(FormDatabaseManager.getIndexByString(null, []) === -1).assertTrue();
      expect(FormDatabaseManager.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormDatabaseManager.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormDatabaseManager.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormDatabaseManager.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormDatabaseManager.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAbilityAdapter_009', 0, () => {
      expect(FormDatabaseManager.drawFontWidth() === -1).assertTrue();
      expect(FormDatabaseManager.drawFontWidth(100) === 1).assertTrue();
      expect(FormDatabaseManager.drawFontWidth(200) === 2).assertTrue();
      expect(FormDatabaseManager.drawFontWidth(300) === 3).assertTrue();
      expect(FormDatabaseManager.drawFontWidth(400) === 4).assertTrue();
      expect(FormDatabaseManager.drawFontWidth(500) === 6).assertTrue();
      expect(FormDatabaseManager.drawFontWidth(600) === 7).assertTrue();
      expect(FormDatabaseManager.drawFontWidth(700) === 8).assertTrue();
      expect(FormDatabaseManager.drawFontWidth(800) === 9).assertTrue();
      expect(FormDatabaseManager.drawFontWidth(900) === 1).assertTrue();
      expect(FormDatabaseManager.drawFontWidth(1000) === 5).assertTrue();
      expect(FormDatabaseManager.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormDatabaseManager.drawFontWeightFormat() === 3).assertTrue();
      expect(FormDatabaseManager.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormDatabaseManager.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormDatabaseManager.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormDatabaseManager.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormDatabaseManager.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormDatabaseManager.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormDatabaseManager.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormDatabaseManager.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormDatabaseManager.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAbilityAdapter_010', 0, () => {
      expect(FormDatabaseManager.drawTextAlign() === -1).assertTrue();
      expect(FormDatabaseManager.drawTextAlign(100) === 0).assertTrue();
      expect(FormDatabaseManager.drawTextAlign(200) === 1).assertTrue();
      expect(FormDatabaseManager.drawTextAlign(300) === 2).assertTrue();
      expect(FormDatabaseManager.drawTextAlign(400) === 3).assertTrue();
      expect(FormDatabaseManager.drawTextAlign(500) === 4).assertTrue();
      expect(FormDatabaseManager.drawTextAlign(600) === 5).assertTrue();
      expect(FormDatabaseManager.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAbilityAdapter_011', 0, () => {
      expect(FormDatabaseManager.getStringIndex('', '') === -1).assertTrue();
      expect(FormDatabaseManager.getStringIndex(null, '') === -1).assertTrue();
      expect(FormDatabaseManager.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormDatabaseManager.getStringIndex('a', '') === -1).assertTrue();
      expect(FormDatabaseManager.getStringIndex('a', null) === -1).assertTrue();
      expect(FormDatabaseManager.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormDatabaseManager.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormDatabaseManager.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormDatabaseManager.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormDatabaseManager.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormDatabaseManager.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormDatabaseManager.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormDatabaseManager.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormDatabaseManager.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormDatabaseManager.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormDatabaseManager.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormDatabaseManager.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormDatabaseManager.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormDatabaseManager.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAbilityAdapter_012', 0, () => {
      expect(FormDatabaseManager.checkArr([]) === false).assertTrue();
      expect(FormDatabaseManager.checkArr(null) === false).assertTrue();
      expect(FormDatabaseManager.checkArr(undefined) === false).assertTrue();
      expect(FormDatabaseManager.checkArr(['', 'b']) === false).assertTrue();
      expect(FormDatabaseManager.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormDatabaseManager.checkArr([null, 'b']) === false).assertTrue();
      expect(FormDatabaseManager.checkArr(['a', '']) === false).assertTrue();
      expect(FormDatabaseManager.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormDatabaseManager.checkArr(['a', null]) === false).assertTrue();
      expect(FormDatabaseManager.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormDatabaseManager.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormDatabaseManager.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormDatabaseManager.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormDatabaseManager.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormDatabaseManager.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormDatabaseManager.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormDatabaseManager.getUUID().length > 0).assertTrue();
    })

    it('FormAbilityAdapter_013', 0, () => {
      expect(FormDatabaseManager.verifyValue(1, 2) === 1).assertTrue();
      expect(FormDatabaseManager.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAbilityAdapter_014', 0, () => {
      expect(FormDatabaseManager.getBinaryData(null, '') === '').assertTrue();
      expect(FormDatabaseManager.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormDatabaseManager.getBinaryData(2, null) === '').assertTrue();
      expect(FormDatabaseManager.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormDatabaseManager.getBinaryData(-2, '') === '').assertTrue();
      expect(FormDatabaseManager.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormDatabaseManager.getBinaryData(0, '') === '').assertTrue();
      expect(FormDatabaseManager.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAbilityAdapter_015', 0, () => {
      expect(FormDatabaseManager.getArraySum(null, []) === -1).assertTrue();
      expect(FormDatabaseManager.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormDatabaseManager.getArraySum([], null) === -1).assertTrue();
      expect(FormDatabaseManager.getArraySum([], undefined) === -1).assertTrue();
      expect(FormDatabaseManager.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormDatabaseManager.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormDatabaseManager.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormDatabaseManager.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormDatabaseManager.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormDatabaseManager.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormDatabaseManager.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormDatabaseManager.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAbilityAdapter_016', 0, () => {
      expect(FormDatabaseManager.isEmpty(null)).assertTrue();
      expect(FormDatabaseManager.isEmpty(undefined)).assertTrue();
      expect(FormDatabaseManager.isEmpty('')).assertTrue();
      expect(FormDatabaseManager.isEmpty(0)).assertTrue();
      expect(FormDatabaseManager.isEmpty([])).assertTrue();
      expect(FormDatabaseManager.isEmpty(1, null)).assertTrue();
      expect(FormDatabaseManager.isEmpty(1, undefined)).assertTrue();
      expect(FormDatabaseManager.isEmpty(1, true)).assertTrue();
      expect(FormDatabaseManager.isEmpty(1, false)).assertFalse();
    })

    it('FormAbilityAdapter_017', 0, () => {
      expect(FormDatabaseManager.equals(null, 'a')).assertFalse();
      expect(FormDatabaseManager.equals(undefined, 'a')).assertFalse();
      expect(FormDatabaseManager.equals('a', null)).assertFalse();
      expect(FormDatabaseManager.equals('a', undefined)).assertFalse();
      expect(FormDatabaseManager.equals('a', 1)).assertFalse();
      expect(FormDatabaseManager.equals(1, 'a')).assertFalse();
      expect(FormDatabaseManager.equals(1, [])).assertFalse();
      expect(FormDatabaseManager.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormDatabaseManager.equals([], m)).assertFalse();
      expect(FormDatabaseManager.equals(m, [])).assertFalse();
      expect(FormDatabaseManager.equals([1,2], [])).assertFalse();
      expect(FormDatabaseManager.equals([], [1, 2])).assertFalse();
      expect(FormDatabaseManager.equals([1], [1, 2])).assertFalse();
      expect(FormDatabaseManager.equals([1, 3], [1, 2])).assertFalse();
      expect(FormDatabaseManager.equals([1, 2], [1, 2])).assertTrue();
      expect(FormDatabaseManager.equals(2, 2)).assertTrue();
    })
  });
}