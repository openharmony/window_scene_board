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
import { FormStackAbilityManager } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackAbilityManager';

export function FormStackAbilityManagerTest() {
  describe('FormStackAbilityManagerTest', () => {
    it('FormStackAbilityManager_001', 0, () => {
      expect(FormStackAbilityManager.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackAbilityManager.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackAbilityManager.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackAbilityManager.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackAbilityManager.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackAbilityManager.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackAbilityManager.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackAbilityManager_002', 0, () => {
      expect(FormStackAbilityManager.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackAbilityManager.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackAbilityManager.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackAbilityManager.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackAbilityManager.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackAbilityManager.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackAbilityManager.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackAbilityManager_003', 0, () => {
      expect(FormStackAbilityManager.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackAbilityManager.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackAbilityManager.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAbilityManager.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAbilityManager.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAbilityManager.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackAbilityManager.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackAbilityManager_004', 0, () => {
      expect(FormStackAbilityManager.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackAbilityManager.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackAbilityManager.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAbilityManager.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAbilityManager.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAbilityManager.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackAbilityManager.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackAbilityManager_005', 0, () => {
      expect(FormStackAbilityManager.isNumber("")).assertFalse();
      expect(FormStackAbilityManager.isNumber(null)).assertFalse();
      expect(FormStackAbilityManager.isNumber(undefined)).assertFalse();
      expect(FormStackAbilityManager.isNumber("abc")).assertFalse();
      expect(FormStackAbilityManager.isNumber("123")).assertTrue();
    });

    it('FormStackAbilityManager_006', 0, () => {
      expect(FormStackAbilityManager.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackAbilityManager.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackAbilityManager.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackAbilityManager.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackAbilityManager.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackAbilityManager.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackAbilityManager_007', 0, () => {
      expect(FormStackAbilityManager.getDefaultId(null) === null).assertTrue();
      expect(FormStackAbilityManager.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackAbilityManager.getDefaultId('') === '').assertTrue();
      expect(FormStackAbilityManager.getDefaultId('default') !== '').assertTrue();
      expect(FormStackAbilityManager.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackAbilityManager.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackAbilityManager_008', 0, () => {
      expect(FormStackAbilityManager.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackAbilityManager.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackAbilityManager.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackAbilityManager.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackAbilityManager.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackAbilityManager.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackAbilityManager.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackAbilityManager_009', 0, () => {
      expect(FormStackAbilityManager.drawFontWidth() === -1).assertTrue();
      expect(FormStackAbilityManager.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackAbilityManager.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackAbilityManager.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackAbilityManager.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackAbilityManager.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackAbilityManager.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackAbilityManager.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackAbilityManager.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackAbilityManager.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackAbilityManager.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackAbilityManager.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackAbilityManager.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackAbilityManager.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackAbilityManager.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackAbilityManager.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackAbilityManager.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackAbilityManager.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackAbilityManager.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackAbilityManager.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackAbilityManager.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackAbilityManager.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackAbilityManager_010', 0, () => {
      expect(FormStackAbilityManager.drawTextAlign() === -1).assertTrue();
      expect(FormStackAbilityManager.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackAbilityManager.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackAbilityManager.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackAbilityManager.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackAbilityManager.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackAbilityManager.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackAbilityManager.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackAbilityManager_011', 0, () => {
      expect(FormStackAbilityManager.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackAbilityManager.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackAbilityManager.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackAbilityManager.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackAbilityManager.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackAbilityManager.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackAbilityManager.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackAbilityManager.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackAbilityManager.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackAbilityManager.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackAbilityManager.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackAbilityManager.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackAbilityManager.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackAbilityManager.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackAbilityManager.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackAbilityManager.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackAbilityManager.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackAbilityManager.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackAbilityManager.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackAbilityManager_012', 0, () => {
      expect(FormStackAbilityManager.checkArr([]) === false).assertTrue();
      expect(FormStackAbilityManager.checkArr(null) === false).assertTrue();
      expect(FormStackAbilityManager.checkArr(undefined) === false).assertTrue();
      expect(FormStackAbilityManager.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackAbilityManager.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackAbilityManager.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackAbilityManager.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackAbilityManager.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackAbilityManager.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackAbilityManager.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackAbilityManager.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackAbilityManager.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackAbilityManager.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackAbilityManager.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackAbilityManager.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackAbilityManager.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackAbilityManager.getUUID().length > 0).assertTrue();
    })

    it('FormStackAbilityManager_013', 0, () => {
      expect(FormStackAbilityManager.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackAbilityManager.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackAbilityManager_014', 0, () => {
      expect(FormStackAbilityManager.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackAbilityManager.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackAbilityManager.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackAbilityManager.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackAbilityManager.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackAbilityManager.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackAbilityManager.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackAbilityManager.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackAbilityManager_015', 0, () => {
      expect(FormStackAbilityManager.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackAbilityManager.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackAbilityManager.getArraySum([], null) === -1).assertTrue();
      expect(FormStackAbilityManager.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackAbilityManager.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackAbilityManager.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackAbilityManager.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackAbilityManager.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackAbilityManager.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackAbilityManager.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackAbilityManager.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackAbilityManager.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackAbilityManager_016', 0, () => {
      expect(FormStackAbilityManager.isEmpty(null)).assertTrue();
      expect(FormStackAbilityManager.isEmpty(undefined)).assertTrue();
      expect(FormStackAbilityManager.isEmpty('')).assertTrue();
      expect(FormStackAbilityManager.isEmpty(0)).assertTrue();
      expect(FormStackAbilityManager.isEmpty([])).assertTrue();
      expect(FormStackAbilityManager.isEmpty(1, null)).assertTrue();
      expect(FormStackAbilityManager.isEmpty(1, undefined)).assertTrue();
      expect(FormStackAbilityManager.isEmpty(1, true)).assertTrue();
      expect(FormStackAbilityManager.isEmpty(1, false)).assertFalse();
    })

    it('FormStackAbilityManager_017', 0, () => {
      expect(FormStackAbilityManager.equals(null, 'a')).assertFalse();
      expect(FormStackAbilityManager.equals(undefined, 'a')).assertFalse();
      expect(FormStackAbilityManager.equals('a', null)).assertFalse();
      expect(FormStackAbilityManager.equals('a', undefined)).assertFalse();
      expect(FormStackAbilityManager.equals('a', 1)).assertFalse();
      expect(FormStackAbilityManager.equals(1, 'a')).assertFalse();
      expect(FormStackAbilityManager.equals(1, [])).assertFalse();
      expect(FormStackAbilityManager.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackAbilityManager.equals([], m)).assertFalse();
      expect(FormStackAbilityManager.equals(m, [])).assertFalse();
      expect(FormStackAbilityManager.equals([1,2], [])).assertFalse();
      expect(FormStackAbilityManager.equals([], [1, 2])).assertFalse();
      expect(FormStackAbilityManager.equals([1], [1, 2])).assertFalse();
      expect(FormStackAbilityManager.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackAbilityManager.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackAbilityManager.equals(2, 2)).assertTrue();
    })
  });
}