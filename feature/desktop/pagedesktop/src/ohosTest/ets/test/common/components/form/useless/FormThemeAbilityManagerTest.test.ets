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
import { FormThemeAbilityManager } from '../../../../../../../main/ets/default/common/components/form/useless/FormThemeAbilityManager';

export function FormThemeAbilityManagerTest() {
  describe('FormThemeAbilityManagerTest', () => {
    it('FormThemeAbilityManager_001', 0, () => {
      expect(FormThemeAbilityManager.getSum("", '1') === -1).assertEqual(true);
      expect(FormThemeAbilityManager.getSum(null, '1') === -1).assertEqual(true);
      expect(FormThemeAbilityManager.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormThemeAbilityManager.getSum('1', '') === -1).assertEqual(true);
      expect(FormThemeAbilityManager.getSum('1', null) === -1).assertEqual(true);
      expect(FormThemeAbilityManager.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormThemeAbilityManager.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormThemeAbilityManager_002', 0, () => {
      expect(FormThemeAbilityManager.stringToArray("", ",").length === 0).assertTrue();
      expect(FormThemeAbilityManager.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormThemeAbilityManager.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAbilityManager.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormThemeAbilityManager.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAbilityManager.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormThemeAbilityManager.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormThemeAbilityManager_003', 0, () => {
      expect(FormThemeAbilityManager.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormThemeAbilityManager.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAbilityManager.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAbilityManager.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAbilityManager.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAbilityManager.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormThemeAbilityManager.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormThemeAbilityManager_004', 0, () => {
      expect(FormThemeAbilityManager.getIntValues("", ",").length === 0).assertTrue();
      expect(FormThemeAbilityManager.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAbilityManager.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAbilityManager.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAbilityManager.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAbilityManager.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormThemeAbilityManager.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormThemeAbilityManager_005', 0, () => {
      expect(FormThemeAbilityManager.isNumber("")).assertFalse();
      expect(FormThemeAbilityManager.isNumber(null)).assertFalse();
      expect(FormThemeAbilityManager.isNumber(undefined)).assertFalse();
      expect(FormThemeAbilityManager.isNumber("abc")).assertFalse();
      expect(FormThemeAbilityManager.isNumber("123")).assertTrue();
    });

    it('FormThemeAbilityManager_006', 0, () => {
      expect(FormThemeAbilityManager.getStrByCount(null , 1) === '').assertTrue();
      expect(FormThemeAbilityManager.getStrByCount('' , 1) === '').assertTrue();
      expect(FormThemeAbilityManager.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormThemeAbilityManager.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormThemeAbilityManager.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormThemeAbilityManager.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormThemeAbilityManager_007', 0, () => {
      expect(FormThemeAbilityManager.getDefaultId(null) === null).assertTrue();
      expect(FormThemeAbilityManager.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormThemeAbilityManager.getDefaultId('') === '').assertTrue();
      expect(FormThemeAbilityManager.getDefaultId('default') !== '').assertTrue();
      expect(FormThemeAbilityManager.getDefaultId('aaa') !== '').assertTrue();
      expect(FormThemeAbilityManager.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormThemeAbilityManager_008', 0, () => {
      expect(FormThemeAbilityManager.getIndexByString("", []) === -1).assertTrue();
      expect(FormThemeAbilityManager.getIndexByString(null, []) === -1).assertTrue();
      expect(FormThemeAbilityManager.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormThemeAbilityManager.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormThemeAbilityManager.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormThemeAbilityManager.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormThemeAbilityManager.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormThemeAbilityManager_009', 0, () => {
      expect(FormThemeAbilityManager.drawFontWidth() === -1).assertTrue();
      expect(FormThemeAbilityManager.drawFontWidth(100) === 1).assertTrue();
      expect(FormThemeAbilityManager.drawFontWidth(200) === 2).assertTrue();
      expect(FormThemeAbilityManager.drawFontWidth(300) === 3).assertTrue();
      expect(FormThemeAbilityManager.drawFontWidth(400) === 4).assertTrue();
      expect(FormThemeAbilityManager.drawFontWidth(500) === 6).assertTrue();
      expect(FormThemeAbilityManager.drawFontWidth(600) === 7).assertTrue();
      expect(FormThemeAbilityManager.drawFontWidth(700) === 8).assertTrue();
      expect(FormThemeAbilityManager.drawFontWidth(800) === 9).assertTrue();
      expect(FormThemeAbilityManager.drawFontWidth(900) === 1).assertTrue();
      expect(FormThemeAbilityManager.drawFontWidth(1000) === 5).assertTrue();
      expect(FormThemeAbilityManager.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormThemeAbilityManager.drawFontWeightFormat() === 3).assertTrue();
      expect(FormThemeAbilityManager.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormThemeAbilityManager.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormThemeAbilityManager.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormThemeAbilityManager.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormThemeAbilityManager.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormThemeAbilityManager.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormThemeAbilityManager.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormThemeAbilityManager.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormThemeAbilityManager.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormThemeAbilityManager_010', 0, () => {
      expect(FormThemeAbilityManager.drawTextAlign() === -1).assertTrue();
      expect(FormThemeAbilityManager.drawTextAlign(100) === 0).assertTrue();
      expect(FormThemeAbilityManager.drawTextAlign(200) === 1).assertTrue();
      expect(FormThemeAbilityManager.drawTextAlign(300) === 2).assertTrue();
      expect(FormThemeAbilityManager.drawTextAlign(400) === 3).assertTrue();
      expect(FormThemeAbilityManager.drawTextAlign(500) === 4).assertTrue();
      expect(FormThemeAbilityManager.drawTextAlign(600) === 5).assertTrue();
      expect(FormThemeAbilityManager.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormThemeAbilityManager_011', 0, () => {
      expect(FormThemeAbilityManager.getStringIndex('', '') === -1).assertTrue();
      expect(FormThemeAbilityManager.getStringIndex(null, '') === -1).assertTrue();
      expect(FormThemeAbilityManager.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormThemeAbilityManager.getStringIndex('a', '') === -1).assertTrue();
      expect(FormThemeAbilityManager.getStringIndex('a', null) === -1).assertTrue();
      expect(FormThemeAbilityManager.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormThemeAbilityManager.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormThemeAbilityManager.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormThemeAbilityManager.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormThemeAbilityManager.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormThemeAbilityManager.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormThemeAbilityManager.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormThemeAbilityManager.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormThemeAbilityManager.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormThemeAbilityManager.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormThemeAbilityManager.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormThemeAbilityManager.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormThemeAbilityManager.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormThemeAbilityManager.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormThemeAbilityManager_012', 0, () => {
      expect(FormThemeAbilityManager.checkArr([]) === false).assertTrue();
      expect(FormThemeAbilityManager.checkArr(null) === false).assertTrue();
      expect(FormThemeAbilityManager.checkArr(undefined) === false).assertTrue();
      expect(FormThemeAbilityManager.checkArr(['', 'b']) === false).assertTrue();
      expect(FormThemeAbilityManager.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormThemeAbilityManager.checkArr([null, 'b']) === false).assertTrue();
      expect(FormThemeAbilityManager.checkArr(['a', '']) === false).assertTrue();
      expect(FormThemeAbilityManager.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormThemeAbilityManager.checkArr(['a', null]) === false).assertTrue();
      expect(FormThemeAbilityManager.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormThemeAbilityManager.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormThemeAbilityManager.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormThemeAbilityManager.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormThemeAbilityManager.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormThemeAbilityManager.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormThemeAbilityManager.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormThemeAbilityManager.getUUID().length > 0).assertTrue();
    })

    it('FormThemeAbilityManager_013', 0, () => {
      expect(FormThemeAbilityManager.verifyValue(1, 2) === 1).assertTrue();
      expect(FormThemeAbilityManager.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormThemeAbilityManager_014', 0, () => {
      expect(FormThemeAbilityManager.getBinaryData(null, '') === '').assertTrue();
      expect(FormThemeAbilityManager.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormThemeAbilityManager.getBinaryData(2, null) === '').assertTrue();
      expect(FormThemeAbilityManager.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormThemeAbilityManager.getBinaryData(-2, '') === '').assertTrue();
      expect(FormThemeAbilityManager.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormThemeAbilityManager.getBinaryData(0, '') === '').assertTrue();
      expect(FormThemeAbilityManager.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormThemeAbilityManager_015', 0, () => {
      expect(FormThemeAbilityManager.getArraySum(null, []) === -1).assertTrue();
      expect(FormThemeAbilityManager.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormThemeAbilityManager.getArraySum([], null) === -1).assertTrue();
      expect(FormThemeAbilityManager.getArraySum([], undefined) === -1).assertTrue();
      expect(FormThemeAbilityManager.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormThemeAbilityManager.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormThemeAbilityManager.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormThemeAbilityManager.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormThemeAbilityManager.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormThemeAbilityManager.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormThemeAbilityManager.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormThemeAbilityManager.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormThemeAbilityManager_016', 0, () => {
      expect(FormThemeAbilityManager.isEmpty(null)).assertTrue();
      expect(FormThemeAbilityManager.isEmpty(undefined)).assertTrue();
      expect(FormThemeAbilityManager.isEmpty('')).assertTrue();
      expect(FormThemeAbilityManager.isEmpty(0)).assertTrue();
      expect(FormThemeAbilityManager.isEmpty([])).assertTrue();
      expect(FormThemeAbilityManager.isEmpty(1, null)).assertTrue();
      expect(FormThemeAbilityManager.isEmpty(1, undefined)).assertTrue();
      expect(FormThemeAbilityManager.isEmpty(1, true)).assertTrue();
      expect(FormThemeAbilityManager.isEmpty(1, false)).assertFalse();
    })

    it('FormThemeAbilityManager_017', 0, () => {
      expect(FormThemeAbilityManager.equals(null, 'a')).assertFalse();
      expect(FormThemeAbilityManager.equals(undefined, 'a')).assertFalse();
      expect(FormThemeAbilityManager.equals('a', null)).assertFalse();
      expect(FormThemeAbilityManager.equals('a', undefined)).assertFalse();
      expect(FormThemeAbilityManager.equals('a', 1)).assertFalse();
      expect(FormThemeAbilityManager.equals(1, 'a')).assertFalse();
      expect(FormThemeAbilityManager.equals(1, [])).assertFalse();
      expect(FormThemeAbilityManager.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormThemeAbilityManager.equals([], m)).assertFalse();
      expect(FormThemeAbilityManager.equals(m, [])).assertFalse();
      expect(FormThemeAbilityManager.equals([1,2], [])).assertFalse();
      expect(FormThemeAbilityManager.equals([], [1, 2])).assertFalse();
      expect(FormThemeAbilityManager.equals([1], [1, 2])).assertFalse();
      expect(FormThemeAbilityManager.equals([1, 3], [1, 2])).assertFalse();
      expect(FormThemeAbilityManager.equals([1, 2], [1, 2])).assertTrue();
      expect(FormThemeAbilityManager.equals(2, 2)).assertTrue();
    })
  });
}