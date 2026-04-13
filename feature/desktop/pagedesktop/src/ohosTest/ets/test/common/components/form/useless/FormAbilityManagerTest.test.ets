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
import { FormAbilityManager } from '../../../../../../../main/ets/default/common/components/form/useless/FormAbilityManager';

export function FormAbilityManagerTest() {
  describe('FormAbilityManagerTest', () => {
    it('FormAbilityManager_001', 0, () => {
      expect(FormAbilityManager.getSum("", '1') === -1).assertEqual(true);
      expect(FormAbilityManager.getSum(null, '1') === -1).assertEqual(true);
      expect(FormAbilityManager.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormAbilityManager.getSum('1', '') === -1).assertEqual(true);
      expect(FormAbilityManager.getSum('1', null) === -1).assertEqual(true);
      expect(FormAbilityManager.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormAbilityManager.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAbilityManager_002', 0, () => {
      expect(FormAbilityManager.stringToArray("", ",").length === 0).assertTrue();
      expect(FormAbilityManager.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormAbilityManager.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormAbilityManager.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormAbilityManager.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormAbilityManager.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormAbilityManager.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAbilityManager_003', 0, () => {
      expect(FormAbilityManager.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormAbilityManager.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormAbilityManager.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormAbilityManager.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormAbilityManager.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormAbilityManager.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormAbilityManager.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAbilityManager_004', 0, () => {
      expect(FormAbilityManager.getIntValues("", ",").length === 0).assertTrue();
      expect(FormAbilityManager.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormAbilityManager.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormAbilityManager.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormAbilityManager.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormAbilityManager.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormAbilityManager.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAbilityManager_005', 0, () => {
      expect(FormAbilityManager.isNumber("")).assertFalse();
      expect(FormAbilityManager.isNumber(null)).assertFalse();
      expect(FormAbilityManager.isNumber(undefined)).assertFalse();
      expect(FormAbilityManager.isNumber("abc")).assertFalse();
      expect(FormAbilityManager.isNumber("123")).assertTrue();
    });

    it('FormAbilityManager_006', 0, () => {
      expect(FormAbilityManager.getStrByCount(null , 1) === '').assertTrue();
      expect(FormAbilityManager.getStrByCount('' , 1) === '').assertTrue();
      expect(FormAbilityManager.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormAbilityManager.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormAbilityManager.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormAbilityManager.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAbilityManager_007', 0, () => {
      expect(FormAbilityManager.getDefaultId(null) === null).assertTrue();
      expect(FormAbilityManager.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormAbilityManager.getDefaultId('') === '').assertTrue();
      expect(FormAbilityManager.getDefaultId('default') !== '').assertTrue();
      expect(FormAbilityManager.getDefaultId('aaa') !== '').assertTrue();
      expect(FormAbilityManager.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAbilityManager_008', 0, () => {
      expect(FormAbilityManager.getIndexByString("", []) === -1).assertTrue();
      expect(FormAbilityManager.getIndexByString(null, []) === -1).assertTrue();
      expect(FormAbilityManager.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormAbilityManager.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormAbilityManager.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormAbilityManager.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormAbilityManager.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAbilityManager_009', 0, () => {
      expect(FormAbilityManager.drawFontWidth() === -1).assertTrue();
      expect(FormAbilityManager.drawFontWidth(100) === 1).assertTrue();
      expect(FormAbilityManager.drawFontWidth(200) === 2).assertTrue();
      expect(FormAbilityManager.drawFontWidth(300) === 3).assertTrue();
      expect(FormAbilityManager.drawFontWidth(400) === 4).assertTrue();
      expect(FormAbilityManager.drawFontWidth(500) === 6).assertTrue();
      expect(FormAbilityManager.drawFontWidth(600) === 7).assertTrue();
      expect(FormAbilityManager.drawFontWidth(700) === 8).assertTrue();
      expect(FormAbilityManager.drawFontWidth(800) === 9).assertTrue();
      expect(FormAbilityManager.drawFontWidth(900) === 1).assertTrue();
      expect(FormAbilityManager.drawFontWidth(1000) === 5).assertTrue();
      expect(FormAbilityManager.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormAbilityManager.drawFontWeightFormat() === 3).assertTrue();
      expect(FormAbilityManager.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormAbilityManager.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormAbilityManager.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormAbilityManager.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormAbilityManager.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormAbilityManager.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormAbilityManager.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormAbilityManager.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormAbilityManager.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAbilityManager_010', 0, () => {
      expect(FormAbilityManager.drawTextAlign() === -1).assertTrue();
      expect(FormAbilityManager.drawTextAlign(100) === 0).assertTrue();
      expect(FormAbilityManager.drawTextAlign(200) === 1).assertTrue();
      expect(FormAbilityManager.drawTextAlign(300) === 2).assertTrue();
      expect(FormAbilityManager.drawTextAlign(400) === 3).assertTrue();
      expect(FormAbilityManager.drawTextAlign(500) === 4).assertTrue();
      expect(FormAbilityManager.drawTextAlign(600) === 5).assertTrue();
      expect(FormAbilityManager.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAbilityManager_011', 0, () => {
      expect(FormAbilityManager.getStringIndex('', '') === -1).assertTrue();
      expect(FormAbilityManager.getStringIndex(null, '') === -1).assertTrue();
      expect(FormAbilityManager.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormAbilityManager.getStringIndex('a', '') === -1).assertTrue();
      expect(FormAbilityManager.getStringIndex('a', null) === -1).assertTrue();
      expect(FormAbilityManager.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormAbilityManager.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormAbilityManager.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormAbilityManager.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormAbilityManager.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormAbilityManager.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormAbilityManager.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormAbilityManager.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormAbilityManager.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormAbilityManager.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormAbilityManager.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormAbilityManager.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormAbilityManager.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormAbilityManager.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAbilityManager_012', 0, () => {
      expect(FormAbilityManager.checkArr([]) === false).assertTrue();
      expect(FormAbilityManager.checkArr(null) === false).assertTrue();
      expect(FormAbilityManager.checkArr(undefined) === false).assertTrue();
      expect(FormAbilityManager.checkArr(['', 'b']) === false).assertTrue();
      expect(FormAbilityManager.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormAbilityManager.checkArr([null, 'b']) === false).assertTrue();
      expect(FormAbilityManager.checkArr(['a', '']) === false).assertTrue();
      expect(FormAbilityManager.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormAbilityManager.checkArr(['a', null]) === false).assertTrue();
      expect(FormAbilityManager.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormAbilityManager.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormAbilityManager.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormAbilityManager.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormAbilityManager.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormAbilityManager.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormAbilityManager.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormAbilityManager.getUUID().length > 0).assertTrue();
    })

    it('FormAbilityManager_013', 0, () => {
      expect(FormAbilityManager.verifyValue(1, 2) === 1).assertTrue();
      expect(FormAbilityManager.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAbilityManager_014', 0, () => {
      expect(FormAbilityManager.getBinaryData(null, '') === '').assertTrue();
      expect(FormAbilityManager.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormAbilityManager.getBinaryData(2, null) === '').assertTrue();
      expect(FormAbilityManager.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormAbilityManager.getBinaryData(-2, '') === '').assertTrue();
      expect(FormAbilityManager.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormAbilityManager.getBinaryData(0, '') === '').assertTrue();
      expect(FormAbilityManager.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAbilityManager_015', 0, () => {
      expect(FormAbilityManager.getArraySum(null, []) === -1).assertTrue();
      expect(FormAbilityManager.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormAbilityManager.getArraySum([], null) === -1).assertTrue();
      expect(FormAbilityManager.getArraySum([], undefined) === -1).assertTrue();
      expect(FormAbilityManager.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormAbilityManager.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormAbilityManager.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormAbilityManager.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormAbilityManager.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormAbilityManager.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormAbilityManager.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormAbilityManager.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAbilityManager_016', 0, () => {
      expect(FormAbilityManager.isEmpty(null)).assertTrue();
      expect(FormAbilityManager.isEmpty(undefined)).assertTrue();
      expect(FormAbilityManager.isEmpty('')).assertTrue();
      expect(FormAbilityManager.isEmpty(0)).assertTrue();
      expect(FormAbilityManager.isEmpty([])).assertTrue();
      expect(FormAbilityManager.isEmpty(1, null)).assertTrue();
      expect(FormAbilityManager.isEmpty(1, undefined)).assertTrue();
      expect(FormAbilityManager.isEmpty(1, true)).assertTrue();
      expect(FormAbilityManager.isEmpty(1, false)).assertFalse();
    })

    it('FormAbilityManager_017', 0, () => {
      expect(FormAbilityManager.equals(null, 'a')).assertFalse();
      expect(FormAbilityManager.equals(undefined, 'a')).assertFalse();
      expect(FormAbilityManager.equals('a', null)).assertFalse();
      expect(FormAbilityManager.equals('a', undefined)).assertFalse();
      expect(FormAbilityManager.equals('a', 1)).assertFalse();
      expect(FormAbilityManager.equals(1, 'a')).assertFalse();
      expect(FormAbilityManager.equals(1, [])).assertFalse();
      expect(FormAbilityManager.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormAbilityManager.equals([], m)).assertFalse();
      expect(FormAbilityManager.equals(m, [])).assertFalse();
      expect(FormAbilityManager.equals([1,2], [])).assertFalse();
      expect(FormAbilityManager.equals([], [1, 2])).assertFalse();
      expect(FormAbilityManager.equals([1], [1, 2])).assertFalse();
      expect(FormAbilityManager.equals([1, 3], [1, 2])).assertFalse();
      expect(FormAbilityManager.equals([1, 2], [1, 2])).assertTrue();
      expect(FormAbilityManager.equals(2, 2)).assertTrue();
    })
  });
}