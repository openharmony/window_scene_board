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
import { FormDatabaseController } from '../../../../../../../main/ets/default/common/components/form/useless/FormDatabaseController';

export function FormAbilityAdapterTest() {
  describe('FormAbilityAdapterTest', () => {
    it('FormAbilityAdapter_001', 0, () => {
      expect(FormDatabaseController.getSum("", '1') === -1).assertEqual(true);
      expect(FormDatabaseController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormDatabaseController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormDatabaseController.getSum('1', '') === -1).assertEqual(true);
      expect(FormDatabaseController.getSum('1', null) === -1).assertEqual(true);
      expect(FormDatabaseController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormDatabaseController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAbilityAdapter_002', 0, () => {
      expect(FormDatabaseController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormDatabaseController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormDatabaseController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormDatabaseController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormDatabaseController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormDatabaseController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormDatabaseController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAbilityAdapter_003', 0, () => {
      expect(FormDatabaseController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormDatabaseController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormDatabaseController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormDatabaseController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormDatabaseController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormDatabaseController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormDatabaseController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAbilityAdapter_004', 0, () => {
      expect(FormDatabaseController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormDatabaseController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormDatabaseController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormDatabaseController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormDatabaseController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormDatabaseController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormDatabaseController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAbilityAdapter_005', 0, () => {
      expect(FormDatabaseController.isNumber("")).assertFalse();
      expect(FormDatabaseController.isNumber(null)).assertFalse();
      expect(FormDatabaseController.isNumber(undefined)).assertFalse();
      expect(FormDatabaseController.isNumber("abc")).assertFalse();
      expect(FormDatabaseController.isNumber("123")).assertTrue();
    });

    it('FormAbilityAdapter_006', 0, () => {
      expect(FormDatabaseController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormDatabaseController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormDatabaseController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormDatabaseController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormDatabaseController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormDatabaseController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAbilityAdapter_007', 0, () => {
      expect(FormDatabaseController.getDefaultId(null) === null).assertTrue();
      expect(FormDatabaseController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormDatabaseController.getDefaultId('') === '').assertTrue();
      expect(FormDatabaseController.getDefaultId('default') !== '').assertTrue();
      expect(FormDatabaseController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormDatabaseController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAbilityAdapter_008', 0, () => {
      expect(FormDatabaseController.getIndexByString("", []) === -1).assertTrue();
      expect(FormDatabaseController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormDatabaseController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormDatabaseController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormDatabaseController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormDatabaseController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormDatabaseController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAbilityAdapter_009', 0, () => {
      expect(FormDatabaseController.drawFontWidth() === -1).assertTrue();
      expect(FormDatabaseController.drawFontWidth(100) === 1).assertTrue();
      expect(FormDatabaseController.drawFontWidth(200) === 2).assertTrue();
      expect(FormDatabaseController.drawFontWidth(300) === 3).assertTrue();
      expect(FormDatabaseController.drawFontWidth(400) === 4).assertTrue();
      expect(FormDatabaseController.drawFontWidth(500) === 6).assertTrue();
      expect(FormDatabaseController.drawFontWidth(600) === 7).assertTrue();
      expect(FormDatabaseController.drawFontWidth(700) === 8).assertTrue();
      expect(FormDatabaseController.drawFontWidth(800) === 9).assertTrue();
      expect(FormDatabaseController.drawFontWidth(900) === 1).assertTrue();
      expect(FormDatabaseController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormDatabaseController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormDatabaseController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormDatabaseController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormDatabaseController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormDatabaseController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormDatabaseController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormDatabaseController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormDatabaseController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormDatabaseController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormDatabaseController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormDatabaseController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAbilityAdapter_010', 0, () => {
      expect(FormDatabaseController.drawTextAlign() === -1).assertTrue();
      expect(FormDatabaseController.drawTextAlign(100) === 0).assertTrue();
      expect(FormDatabaseController.drawTextAlign(200) === 1).assertTrue();
      expect(FormDatabaseController.drawTextAlign(300) === 2).assertTrue();
      expect(FormDatabaseController.drawTextAlign(400) === 3).assertTrue();
      expect(FormDatabaseController.drawTextAlign(500) === 4).assertTrue();
      expect(FormDatabaseController.drawTextAlign(600) === 5).assertTrue();
      expect(FormDatabaseController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAbilityAdapter_011', 0, () => {
      expect(FormDatabaseController.getStringIndex('', '') === -1).assertTrue();
      expect(FormDatabaseController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormDatabaseController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormDatabaseController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormDatabaseController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormDatabaseController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormDatabaseController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormDatabaseController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormDatabaseController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormDatabaseController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormDatabaseController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormDatabaseController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormDatabaseController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormDatabaseController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormDatabaseController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormDatabaseController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormDatabaseController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormDatabaseController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormDatabaseController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAbilityAdapter_012', 0, () => {
      expect(FormDatabaseController.checkArr([]) === false).assertTrue();
      expect(FormDatabaseController.checkArr(null) === false).assertTrue();
      expect(FormDatabaseController.checkArr(undefined) === false).assertTrue();
      expect(FormDatabaseController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormDatabaseController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormDatabaseController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormDatabaseController.checkArr(['a', '']) === false).assertTrue();
      expect(FormDatabaseController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormDatabaseController.checkArr(['a', null]) === false).assertTrue();
      expect(FormDatabaseController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormDatabaseController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormDatabaseController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormDatabaseController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormDatabaseController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormDatabaseController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormDatabaseController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormDatabaseController.getUUID().length > 0).assertTrue();
    })

    it('FormAbilityAdapter_013', 0, () => {
      expect(FormDatabaseController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormDatabaseController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAbilityAdapter_014', 0, () => {
      expect(FormDatabaseController.getBinaryData(null, '') === '').assertTrue();
      expect(FormDatabaseController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormDatabaseController.getBinaryData(2, null) === '').assertTrue();
      expect(FormDatabaseController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormDatabaseController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormDatabaseController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormDatabaseController.getBinaryData(0, '') === '').assertTrue();
      expect(FormDatabaseController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAbilityAdapter_015', 0, () => {
      expect(FormDatabaseController.getArraySum(null, []) === -1).assertTrue();
      expect(FormDatabaseController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormDatabaseController.getArraySum([], null) === -1).assertTrue();
      expect(FormDatabaseController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormDatabaseController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormDatabaseController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormDatabaseController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormDatabaseController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormDatabaseController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormDatabaseController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormDatabaseController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormDatabaseController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAbilityAdapter_016', 0, () => {
      expect(FormDatabaseController.isEmpty(null)).assertTrue();
      expect(FormDatabaseController.isEmpty(undefined)).assertTrue();
      expect(FormDatabaseController.isEmpty('')).assertTrue();
      expect(FormDatabaseController.isEmpty(0)).assertTrue();
      expect(FormDatabaseController.isEmpty([])).assertTrue();
      expect(FormDatabaseController.isEmpty(1, null)).assertTrue();
      expect(FormDatabaseController.isEmpty(1, undefined)).assertTrue();
      expect(FormDatabaseController.isEmpty(1, true)).assertTrue();
      expect(FormDatabaseController.isEmpty(1, false)).assertFalse();
    })

    it('FormAbilityAdapter_017', 0, () => {
      expect(FormDatabaseController.equals(null, 'a')).assertFalse();
      expect(FormDatabaseController.equals(undefined, 'a')).assertFalse();
      expect(FormDatabaseController.equals('a', null)).assertFalse();
      expect(FormDatabaseController.equals('a', undefined)).assertFalse();
      expect(FormDatabaseController.equals('a', 1)).assertFalse();
      expect(FormDatabaseController.equals(1, 'a')).assertFalse();
      expect(FormDatabaseController.equals(1, [])).assertFalse();
      expect(FormDatabaseController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormDatabaseController.equals([], m)).assertFalse();
      expect(FormDatabaseController.equals(m, [])).assertFalse();
      expect(FormDatabaseController.equals([1,2], [])).assertFalse();
      expect(FormDatabaseController.equals([], [1, 2])).assertFalse();
      expect(FormDatabaseController.equals([1], [1, 2])).assertFalse();
      expect(FormDatabaseController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormDatabaseController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormDatabaseController.equals(2, 2)).assertTrue();
    })
  });
}