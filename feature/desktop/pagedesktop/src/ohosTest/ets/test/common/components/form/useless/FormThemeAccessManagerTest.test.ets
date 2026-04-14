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
import { FormThemeAccessManager } from '../../../../../../../main/ets/default/common/components/form/useless/FormThemeAccessManager';

export function FormThemeAccessManagerTest() {
  describe('FormThemeAccessManagerTest', () => {
    it('FormThemeAccessManager_001', 0, () => {
      expect(FormThemeAccessManager.getSum("", '1') === -1).assertEqual(true);
      expect(FormThemeAccessManager.getSum(null, '1') === -1).assertEqual(true);
      expect(FormThemeAccessManager.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormThemeAccessManager.getSum('1', '') === -1).assertEqual(true);
      expect(FormThemeAccessManager.getSum('1', null) === -1).assertEqual(true);
      expect(FormThemeAccessManager.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormThemeAccessManager.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormThemeAccessManager_002', 0, () => {
      expect(FormThemeAccessManager.stringToArray("", ",").length === 0).assertTrue();
      expect(FormThemeAccessManager.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormThemeAccessManager.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAccessManager.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormThemeAccessManager.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAccessManager.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormThemeAccessManager.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormThemeAccessManager_003', 0, () => {
      expect(FormThemeAccessManager.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormThemeAccessManager.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAccessManager.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAccessManager.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAccessManager.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAccessManager.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormThemeAccessManager.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormThemeAccessManager_004', 0, () => {
      expect(FormThemeAccessManager.getIntValues("", ",").length === 0).assertTrue();
      expect(FormThemeAccessManager.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAccessManager.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAccessManager.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAccessManager.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAccessManager.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormThemeAccessManager.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormThemeAccessManager_005', 0, () => {
      expect(FormThemeAccessManager.isNumber("")).assertFalse();
      expect(FormThemeAccessManager.isNumber(null)).assertFalse();
      expect(FormThemeAccessManager.isNumber(undefined)).assertFalse();
      expect(FormThemeAccessManager.isNumber("abc")).assertFalse();
      expect(FormThemeAccessManager.isNumber("123")).assertTrue();
    });

    it('FormThemeAccessManager_006', 0, () => {
      expect(FormThemeAccessManager.getStrByCount(null , 1) === '').assertTrue();
      expect(FormThemeAccessManager.getStrByCount('' , 1) === '').assertTrue();
      expect(FormThemeAccessManager.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormThemeAccessManager.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormThemeAccessManager.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormThemeAccessManager.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormThemeAccessManager_007', 0, () => {
      expect(FormThemeAccessManager.getDefaultId(null) === null).assertTrue();
      expect(FormThemeAccessManager.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormThemeAccessManager.getDefaultId('') === '').assertTrue();
      expect(FormThemeAccessManager.getDefaultId('default') !== '').assertTrue();
      expect(FormThemeAccessManager.getDefaultId('aaa') !== '').assertTrue();
      expect(FormThemeAccessManager.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormThemeAccessManager_008', 0, () => {
      expect(FormThemeAccessManager.getIndexByString("", []) === -1).assertTrue();
      expect(FormThemeAccessManager.getIndexByString(null, []) === -1).assertTrue();
      expect(FormThemeAccessManager.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormThemeAccessManager.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormThemeAccessManager.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormThemeAccessManager.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormThemeAccessManager.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormThemeAccessManager_009', 0, () => {
      expect(FormThemeAccessManager.drawFontWidth() === -1).assertTrue();
      expect(FormThemeAccessManager.drawFontWidth(100) === 1).assertTrue();
      expect(FormThemeAccessManager.drawFontWidth(200) === 2).assertTrue();
      expect(FormThemeAccessManager.drawFontWidth(300) === 3).assertTrue();
      expect(FormThemeAccessManager.drawFontWidth(400) === 4).assertTrue();
      expect(FormThemeAccessManager.drawFontWidth(500) === 6).assertTrue();
      expect(FormThemeAccessManager.drawFontWidth(600) === 7).assertTrue();
      expect(FormThemeAccessManager.drawFontWidth(700) === 8).assertTrue();
      expect(FormThemeAccessManager.drawFontWidth(800) === 9).assertTrue();
      expect(FormThemeAccessManager.drawFontWidth(900) === 1).assertTrue();
      expect(FormThemeAccessManager.drawFontWidth(1000) === 5).assertTrue();
      expect(FormThemeAccessManager.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormThemeAccessManager.drawFontWeightFormat() === 3).assertTrue();
      expect(FormThemeAccessManager.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormThemeAccessManager.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormThemeAccessManager.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormThemeAccessManager.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormThemeAccessManager.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormThemeAccessManager.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormThemeAccessManager.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormThemeAccessManager.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormThemeAccessManager.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormThemeAccessManager_010', 0, () => {
      expect(FormThemeAccessManager.drawTextAlign() === -1).assertTrue();
      expect(FormThemeAccessManager.drawTextAlign(100) === 0).assertTrue();
      expect(FormThemeAccessManager.drawTextAlign(200) === 1).assertTrue();
      expect(FormThemeAccessManager.drawTextAlign(300) === 2).assertTrue();
      expect(FormThemeAccessManager.drawTextAlign(400) === 3).assertTrue();
      expect(FormThemeAccessManager.drawTextAlign(500) === 4).assertTrue();
      expect(FormThemeAccessManager.drawTextAlign(600) === 5).assertTrue();
      expect(FormThemeAccessManager.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormThemeAccessManager_011', 0, () => {
      expect(FormThemeAccessManager.getStringIndex('', '') === -1).assertTrue();
      expect(FormThemeAccessManager.getStringIndex(null, '') === -1).assertTrue();
      expect(FormThemeAccessManager.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormThemeAccessManager.getStringIndex('a', '') === -1).assertTrue();
      expect(FormThemeAccessManager.getStringIndex('a', null) === -1).assertTrue();
      expect(FormThemeAccessManager.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormThemeAccessManager.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormThemeAccessManager.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormThemeAccessManager.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormThemeAccessManager.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormThemeAccessManager.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormThemeAccessManager.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormThemeAccessManager.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormThemeAccessManager.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormThemeAccessManager.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormThemeAccessManager.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormThemeAccessManager.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormThemeAccessManager.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormThemeAccessManager.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormThemeAccessManager_012', 0, () => {
      expect(FormThemeAccessManager.checkArr([]) === false).assertTrue();
      expect(FormThemeAccessManager.checkArr(null) === false).assertTrue();
      expect(FormThemeAccessManager.checkArr(undefined) === false).assertTrue();
      expect(FormThemeAccessManager.checkArr(['', 'b']) === false).assertTrue();
      expect(FormThemeAccessManager.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormThemeAccessManager.checkArr([null, 'b']) === false).assertTrue();
      expect(FormThemeAccessManager.checkArr(['a', '']) === false).assertTrue();
      expect(FormThemeAccessManager.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormThemeAccessManager.checkArr(['a', null]) === false).assertTrue();
      expect(FormThemeAccessManager.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormThemeAccessManager.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormThemeAccessManager.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormThemeAccessManager.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormThemeAccessManager.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormThemeAccessManager.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormThemeAccessManager.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormThemeAccessManager.getUUID().length > 0).assertTrue();
    })

    it('FormThemeAccessManager_013', 0, () => {
      expect(FormThemeAccessManager.verifyValue(1, 2) === 1).assertTrue();
      expect(FormThemeAccessManager.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormThemeAccessManager_014', 0, () => {
      expect(FormThemeAccessManager.getBinaryData(null, '') === '').assertTrue();
      expect(FormThemeAccessManager.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormThemeAccessManager.getBinaryData(2, null) === '').assertTrue();
      expect(FormThemeAccessManager.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormThemeAccessManager.getBinaryData(-2, '') === '').assertTrue();
      expect(FormThemeAccessManager.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormThemeAccessManager.getBinaryData(0, '') === '').assertTrue();
      expect(FormThemeAccessManager.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormThemeAccessManager_015', 0, () => {
      expect(FormThemeAccessManager.getArraySum(null, []) === -1).assertTrue();
      expect(FormThemeAccessManager.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormThemeAccessManager.getArraySum([], null) === -1).assertTrue();
      expect(FormThemeAccessManager.getArraySum([], undefined) === -1).assertTrue();
      expect(FormThemeAccessManager.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormThemeAccessManager.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormThemeAccessManager.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormThemeAccessManager.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormThemeAccessManager.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormThemeAccessManager.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormThemeAccessManager.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormThemeAccessManager.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormThemeAccessManager_016', 0, () => {
      expect(FormThemeAccessManager.isEmpty(null)).assertTrue();
      expect(FormThemeAccessManager.isEmpty(undefined)).assertTrue();
      expect(FormThemeAccessManager.isEmpty('')).assertTrue();
      expect(FormThemeAccessManager.isEmpty(0)).assertTrue();
      expect(FormThemeAccessManager.isEmpty([])).assertTrue();
      expect(FormThemeAccessManager.isEmpty(1, null)).assertTrue();
      expect(FormThemeAccessManager.isEmpty(1, undefined)).assertTrue();
      expect(FormThemeAccessManager.isEmpty(1, true)).assertTrue();
      expect(FormThemeAccessManager.isEmpty(1, false)).assertFalse();
    })

    it('FormThemeAccessManager_017', 0, () => {
      expect(FormThemeAccessManager.equals(null, 'a')).assertFalse();
      expect(FormThemeAccessManager.equals(undefined, 'a')).assertFalse();
      expect(FormThemeAccessManager.equals('a', null)).assertFalse();
      expect(FormThemeAccessManager.equals('a', undefined)).assertFalse();
      expect(FormThemeAccessManager.equals('a', 1)).assertFalse();
      expect(FormThemeAccessManager.equals(1, 'a')).assertFalse();
      expect(FormThemeAccessManager.equals(1, [])).assertFalse();
      expect(FormThemeAccessManager.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormThemeAccessManager.equals([], m)).assertFalse();
      expect(FormThemeAccessManager.equals(m, [])).assertFalse();
      expect(FormThemeAccessManager.equals([1,2], [])).assertFalse();
      expect(FormThemeAccessManager.equals([], [1, 2])).assertFalse();
      expect(FormThemeAccessManager.equals([1], [1, 2])).assertFalse();
      expect(FormThemeAccessManager.equals([1, 3], [1, 2])).assertFalse();
      expect(FormThemeAccessManager.equals([1, 2], [1, 2])).assertTrue();
      expect(FormThemeAccessManager.equals(2, 2)).assertTrue();
    })
  });
}