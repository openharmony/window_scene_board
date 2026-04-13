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
import { FormThemeAddManager } from '../../../../../../../main/ets/default/common/components/form/useless/FormThemeAddManager';

export function FormThemeAddManagerTest() {
  describe('FormThemeAddManagerTest', () => {
    it('FormThemeAddManager_001', 0, () => {
      expect(FormThemeAddManager.getSum("", '1') === -1).assertEqual(true);
      expect(FormThemeAddManager.getSum(null, '1') === -1).assertEqual(true);
      expect(FormThemeAddManager.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormThemeAddManager.getSum('1', '') === -1).assertEqual(true);
      expect(FormThemeAddManager.getSum('1', null) === -1).assertEqual(true);
      expect(FormThemeAddManager.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormThemeAddManager.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormThemeAddManager_002', 0, () => {
      expect(FormThemeAddManager.stringToArray("", ",").length === 0).assertTrue();
      expect(FormThemeAddManager.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormThemeAddManager.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAddManager.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormThemeAddManager.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAddManager.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormThemeAddManager.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormThemeAddManager_003', 0, () => {
      expect(FormThemeAddManager.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormThemeAddManager.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAddManager.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAddManager.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAddManager.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAddManager.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormThemeAddManager.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormThemeAddManager_004', 0, () => {
      expect(FormThemeAddManager.getIntValues("", ",").length === 0).assertTrue();
      expect(FormThemeAddManager.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAddManager.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAddManager.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAddManager.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAddManager.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormThemeAddManager.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormThemeAddManager_005', 0, () => {
      expect(FormThemeAddManager.isNumber("")).assertFalse();
      expect(FormThemeAddManager.isNumber(null)).assertFalse();
      expect(FormThemeAddManager.isNumber(undefined)).assertFalse();
      expect(FormThemeAddManager.isNumber("abc")).assertFalse();
      expect(FormThemeAddManager.isNumber("123")).assertTrue();
    });

    it('FormThemeAddManager_006', 0, () => {
      expect(FormThemeAddManager.getStrByCount(null , 1) === '').assertTrue();
      expect(FormThemeAddManager.getStrByCount('' , 1) === '').assertTrue();
      expect(FormThemeAddManager.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormThemeAddManager.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormThemeAddManager.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormThemeAddManager.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormThemeAddManager_007', 0, () => {
      expect(FormThemeAddManager.getDefaultId(null) === null).assertTrue();
      expect(FormThemeAddManager.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormThemeAddManager.getDefaultId('') === '').assertTrue();
      expect(FormThemeAddManager.getDefaultId('default') !== '').assertTrue();
      expect(FormThemeAddManager.getDefaultId('aaa') !== '').assertTrue();
      expect(FormThemeAddManager.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormThemeAddManager_008', 0, () => {
      expect(FormThemeAddManager.getIndexByString("", []) === -1).assertTrue();
      expect(FormThemeAddManager.getIndexByString(null, []) === -1).assertTrue();
      expect(FormThemeAddManager.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormThemeAddManager.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormThemeAddManager.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormThemeAddManager.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormThemeAddManager.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormThemeAddManager_009', 0, () => {
      expect(FormThemeAddManager.drawFontWidth() === -1).assertTrue();
      expect(FormThemeAddManager.drawFontWidth(100) === 1).assertTrue();
      expect(FormThemeAddManager.drawFontWidth(200) === 2).assertTrue();
      expect(FormThemeAddManager.drawFontWidth(300) === 3).assertTrue();
      expect(FormThemeAddManager.drawFontWidth(400) === 4).assertTrue();
      expect(FormThemeAddManager.drawFontWidth(500) === 6).assertTrue();
      expect(FormThemeAddManager.drawFontWidth(600) === 7).assertTrue();
      expect(FormThemeAddManager.drawFontWidth(700) === 8).assertTrue();
      expect(FormThemeAddManager.drawFontWidth(800) === 9).assertTrue();
      expect(FormThemeAddManager.drawFontWidth(900) === 1).assertTrue();
      expect(FormThemeAddManager.drawFontWidth(1000) === 5).assertTrue();
      expect(FormThemeAddManager.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormThemeAddManager.drawFontWeightFormat() === 3).assertTrue();
      expect(FormThemeAddManager.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormThemeAddManager.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormThemeAddManager.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormThemeAddManager.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormThemeAddManager.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormThemeAddManager.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormThemeAddManager.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormThemeAddManager.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormThemeAddManager.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormThemeAddManager_010', 0, () => {
      expect(FormThemeAddManager.drawTextAlign() === -1).assertTrue();
      expect(FormThemeAddManager.drawTextAlign(100) === 0).assertTrue();
      expect(FormThemeAddManager.drawTextAlign(200) === 1).assertTrue();
      expect(FormThemeAddManager.drawTextAlign(300) === 2).assertTrue();
      expect(FormThemeAddManager.drawTextAlign(400) === 3).assertTrue();
      expect(FormThemeAddManager.drawTextAlign(500) === 4).assertTrue();
      expect(FormThemeAddManager.drawTextAlign(600) === 5).assertTrue();
      expect(FormThemeAddManager.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormThemeAddManager_011', 0, () => {
      expect(FormThemeAddManager.getStringIndex('', '') === -1).assertTrue();
      expect(FormThemeAddManager.getStringIndex(null, '') === -1).assertTrue();
      expect(FormThemeAddManager.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormThemeAddManager.getStringIndex('a', '') === -1).assertTrue();
      expect(FormThemeAddManager.getStringIndex('a', null) === -1).assertTrue();
      expect(FormThemeAddManager.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormThemeAddManager.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormThemeAddManager.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormThemeAddManager.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormThemeAddManager.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormThemeAddManager.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormThemeAddManager.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormThemeAddManager.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormThemeAddManager.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormThemeAddManager.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormThemeAddManager.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormThemeAddManager.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormThemeAddManager.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormThemeAddManager.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormThemeAddManager_012', 0, () => {
      expect(FormThemeAddManager.checkArr([]) === false).assertTrue();
      expect(FormThemeAddManager.checkArr(null) === false).assertTrue();
      expect(FormThemeAddManager.checkArr(undefined) === false).assertTrue();
      expect(FormThemeAddManager.checkArr(['', 'b']) === false).assertTrue();
      expect(FormThemeAddManager.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormThemeAddManager.checkArr([null, 'b']) === false).assertTrue();
      expect(FormThemeAddManager.checkArr(['a', '']) === false).assertTrue();
      expect(FormThemeAddManager.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormThemeAddManager.checkArr(['a', null]) === false).assertTrue();
      expect(FormThemeAddManager.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormThemeAddManager.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormThemeAddManager.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormThemeAddManager.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormThemeAddManager.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormThemeAddManager.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormThemeAddManager.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormThemeAddManager.getUUID().length > 0).assertTrue();
    })

    it('FormThemeAddManager_013', 0, () => {
      expect(FormThemeAddManager.verifyValue(1, 2) === 1).assertTrue();
      expect(FormThemeAddManager.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormThemeAddManager_014', 0, () => {
      expect(FormThemeAddManager.getBinaryData(null, '') === '').assertTrue();
      expect(FormThemeAddManager.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormThemeAddManager.getBinaryData(2, null) === '').assertTrue();
      expect(FormThemeAddManager.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormThemeAddManager.getBinaryData(-2, '') === '').assertTrue();
      expect(FormThemeAddManager.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormThemeAddManager.getBinaryData(0, '') === '').assertTrue();
      expect(FormThemeAddManager.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormThemeAddManager_015', 0, () => {
      expect(FormThemeAddManager.getArraySum(null, []) === -1).assertTrue();
      expect(FormThemeAddManager.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormThemeAddManager.getArraySum([], null) === -1).assertTrue();
      expect(FormThemeAddManager.getArraySum([], undefined) === -1).assertTrue();
      expect(FormThemeAddManager.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormThemeAddManager.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormThemeAddManager.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormThemeAddManager.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormThemeAddManager.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormThemeAddManager.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormThemeAddManager.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormThemeAddManager.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormThemeAddManager_016', 0, () => {
      expect(FormThemeAddManager.isEmpty(null)).assertTrue();
      expect(FormThemeAddManager.isEmpty(undefined)).assertTrue();
      expect(FormThemeAddManager.isEmpty('')).assertTrue();
      expect(FormThemeAddManager.isEmpty(0)).assertTrue();
      expect(FormThemeAddManager.isEmpty([])).assertTrue();
      expect(FormThemeAddManager.isEmpty(1, null)).assertTrue();
      expect(FormThemeAddManager.isEmpty(1, undefined)).assertTrue();
      expect(FormThemeAddManager.isEmpty(1, true)).assertTrue();
      expect(FormThemeAddManager.isEmpty(1, false)).assertFalse();
    })

    it('FormThemeAddManager_017', 0, () => {
      expect(FormThemeAddManager.equals(null, 'a')).assertFalse();
      expect(FormThemeAddManager.equals(undefined, 'a')).assertFalse();
      expect(FormThemeAddManager.equals('a', null)).assertFalse();
      expect(FormThemeAddManager.equals('a', undefined)).assertFalse();
      expect(FormThemeAddManager.equals('a', 1)).assertFalse();
      expect(FormThemeAddManager.equals(1, 'a')).assertFalse();
      expect(FormThemeAddManager.equals(1, [])).assertFalse();
      expect(FormThemeAddManager.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormThemeAddManager.equals([], m)).assertFalse();
      expect(FormThemeAddManager.equals(m, [])).assertFalse();
      expect(FormThemeAddManager.equals([1,2], [])).assertFalse();
      expect(FormThemeAddManager.equals([], [1, 2])).assertFalse();
      expect(FormThemeAddManager.equals([1], [1, 2])).assertFalse();
      expect(FormThemeAddManager.equals([1, 3], [1, 2])).assertFalse();
      expect(FormThemeAddManager.equals([1, 2], [1, 2])).assertTrue();
      expect(FormThemeAddManager.equals(2, 2)).assertTrue();
    })
  });
}