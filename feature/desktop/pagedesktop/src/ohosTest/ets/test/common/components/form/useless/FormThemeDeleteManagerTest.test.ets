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
import { FormThemeDeleteManager } from '../../../../../../../main/ets/default/common/components/form/useless/FormThemeDeleteManager';

export function FormThemeDeleteManagerTest() {
  describe('FormThemeDeleteManagerTest', () => {
    it('FormThemeDeleteManager_001', 0, () => {
      expect(FormThemeDeleteManager.getSum("", '1') === -1).assertEqual(true);
      expect(FormThemeDeleteManager.getSum(null, '1') === -1).assertEqual(true);
      expect(FormThemeDeleteManager.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormThemeDeleteManager.getSum('1', '') === -1).assertEqual(true);
      expect(FormThemeDeleteManager.getSum('1', null) === -1).assertEqual(true);
      expect(FormThemeDeleteManager.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormThemeDeleteManager.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormThemeDeleteManager_002', 0, () => {
      expect(FormThemeDeleteManager.stringToArray("", ",").length === 0).assertTrue();
      expect(FormThemeDeleteManager.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormThemeDeleteManager.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormThemeDeleteManager.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormThemeDeleteManager.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormThemeDeleteManager.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormThemeDeleteManager.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormThemeDeleteManager_003', 0, () => {
      expect(FormThemeDeleteManager.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormThemeDeleteManager.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormThemeDeleteManager.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeDeleteManager.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeDeleteManager.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeDeleteManager.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormThemeDeleteManager.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormThemeDeleteManager_004', 0, () => {
      expect(FormThemeDeleteManager.getIntValues("", ",").length === 0).assertTrue();
      expect(FormThemeDeleteManager.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormThemeDeleteManager.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeDeleteManager.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeDeleteManager.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeDeleteManager.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormThemeDeleteManager.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormThemeDeleteManager_005', 0, () => {
      expect(FormThemeDeleteManager.isNumber("")).assertFalse();
      expect(FormThemeDeleteManager.isNumber(null)).assertFalse();
      expect(FormThemeDeleteManager.isNumber(undefined)).assertFalse();
      expect(FormThemeDeleteManager.isNumber("abc")).assertFalse();
      expect(FormThemeDeleteManager.isNumber("123")).assertTrue();
    });

    it('FormThemeDeleteManager_006', 0, () => {
      expect(FormThemeDeleteManager.getStrByCount(null , 1) === '').assertTrue();
      expect(FormThemeDeleteManager.getStrByCount('' , 1) === '').assertTrue();
      expect(FormThemeDeleteManager.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormThemeDeleteManager.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormThemeDeleteManager.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormThemeDeleteManager.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormThemeDeleteManager_007', 0, () => {
      expect(FormThemeDeleteManager.getDefaultId(null) === null).assertTrue();
      expect(FormThemeDeleteManager.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormThemeDeleteManager.getDefaultId('') === '').assertTrue();
      expect(FormThemeDeleteManager.getDefaultId('default') !== '').assertTrue();
      expect(FormThemeDeleteManager.getDefaultId('aaa') !== '').assertTrue();
      expect(FormThemeDeleteManager.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormThemeDeleteManager_008', 0, () => {
      expect(FormThemeDeleteManager.getIndexByString("", []) === -1).assertTrue();
      expect(FormThemeDeleteManager.getIndexByString(null, []) === -1).assertTrue();
      expect(FormThemeDeleteManager.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormThemeDeleteManager.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormThemeDeleteManager.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormThemeDeleteManager.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormThemeDeleteManager.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormThemeDeleteManager_009', 0, () => {
      expect(FormThemeDeleteManager.drawFontWidth() === -1).assertTrue();
      expect(FormThemeDeleteManager.drawFontWidth(100) === 1).assertTrue();
      expect(FormThemeDeleteManager.drawFontWidth(200) === 2).assertTrue();
      expect(FormThemeDeleteManager.drawFontWidth(300) === 3).assertTrue();
      expect(FormThemeDeleteManager.drawFontWidth(400) === 4).assertTrue();
      expect(FormThemeDeleteManager.drawFontWidth(500) === 6).assertTrue();
      expect(FormThemeDeleteManager.drawFontWidth(600) === 7).assertTrue();
      expect(FormThemeDeleteManager.drawFontWidth(700) === 8).assertTrue();
      expect(FormThemeDeleteManager.drawFontWidth(800) === 9).assertTrue();
      expect(FormThemeDeleteManager.drawFontWidth(900) === 1).assertTrue();
      expect(FormThemeDeleteManager.drawFontWidth(1000) === 5).assertTrue();
      expect(FormThemeDeleteManager.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormThemeDeleteManager.drawFontWeightFormat() === 3).assertTrue();
      expect(FormThemeDeleteManager.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormThemeDeleteManager.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormThemeDeleteManager.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormThemeDeleteManager.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormThemeDeleteManager.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormThemeDeleteManager.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormThemeDeleteManager.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormThemeDeleteManager.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormThemeDeleteManager.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormThemeDeleteManager_010', 0, () => {
      expect(FormThemeDeleteManager.drawTextAlign() === -1).assertTrue();
      expect(FormThemeDeleteManager.drawTextAlign(100) === 0).assertTrue();
      expect(FormThemeDeleteManager.drawTextAlign(200) === 1).assertTrue();
      expect(FormThemeDeleteManager.drawTextAlign(300) === 2).assertTrue();
      expect(FormThemeDeleteManager.drawTextAlign(400) === 3).assertTrue();
      expect(FormThemeDeleteManager.drawTextAlign(500) === 4).assertTrue();
      expect(FormThemeDeleteManager.drawTextAlign(600) === 5).assertTrue();
      expect(FormThemeDeleteManager.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormThemeDeleteManager_011', 0, () => {
      expect(FormThemeDeleteManager.getStringIndex('', '') === -1).assertTrue();
      expect(FormThemeDeleteManager.getStringIndex(null, '') === -1).assertTrue();
      expect(FormThemeDeleteManager.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormThemeDeleteManager.getStringIndex('a', '') === -1).assertTrue();
      expect(FormThemeDeleteManager.getStringIndex('a', null) === -1).assertTrue();
      expect(FormThemeDeleteManager.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormThemeDeleteManager.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormThemeDeleteManager.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormThemeDeleteManager.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormThemeDeleteManager.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormThemeDeleteManager.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormThemeDeleteManager.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormThemeDeleteManager.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormThemeDeleteManager.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormThemeDeleteManager.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormThemeDeleteManager.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormThemeDeleteManager.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormThemeDeleteManager.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormThemeDeleteManager.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormThemeDeleteManager_012', 0, () => {
      expect(FormThemeDeleteManager.checkArr([]) === false).assertTrue();
      expect(FormThemeDeleteManager.checkArr(null) === false).assertTrue();
      expect(FormThemeDeleteManager.checkArr(undefined) === false).assertTrue();
      expect(FormThemeDeleteManager.checkArr(['', 'b']) === false).assertTrue();
      expect(FormThemeDeleteManager.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormThemeDeleteManager.checkArr([null, 'b']) === false).assertTrue();
      expect(FormThemeDeleteManager.checkArr(['a', '']) === false).assertTrue();
      expect(FormThemeDeleteManager.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormThemeDeleteManager.checkArr(['a', null]) === false).assertTrue();
      expect(FormThemeDeleteManager.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormThemeDeleteManager.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormThemeDeleteManager.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormThemeDeleteManager.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormThemeDeleteManager.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormThemeDeleteManager.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormThemeDeleteManager.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormThemeDeleteManager.getUUID().length > 0).assertTrue();
    })

    it('FormThemeDeleteManager_013', 0, () => {
      expect(FormThemeDeleteManager.verifyValue(1, 2) === 1).assertTrue();
      expect(FormThemeDeleteManager.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormThemeDeleteManager_014', 0, () => {
      expect(FormThemeDeleteManager.getBinaryData(null, '') === '').assertTrue();
      expect(FormThemeDeleteManager.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormThemeDeleteManager.getBinaryData(2, null) === '').assertTrue();
      expect(FormThemeDeleteManager.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormThemeDeleteManager.getBinaryData(-2, '') === '').assertTrue();
      expect(FormThemeDeleteManager.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormThemeDeleteManager.getBinaryData(0, '') === '').assertTrue();
      expect(FormThemeDeleteManager.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormThemeDeleteManager_015', 0, () => {
      expect(FormThemeDeleteManager.getArraySum(null, []) === -1).assertTrue();
      expect(FormThemeDeleteManager.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormThemeDeleteManager.getArraySum([], null) === -1).assertTrue();
      expect(FormThemeDeleteManager.getArraySum([], undefined) === -1).assertTrue();
      expect(FormThemeDeleteManager.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormThemeDeleteManager.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormThemeDeleteManager.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormThemeDeleteManager.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormThemeDeleteManager.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormThemeDeleteManager.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormThemeDeleteManager.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormThemeDeleteManager.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormThemeDeleteManager_016', 0, () => {
      expect(FormThemeDeleteManager.isEmpty(null)).assertTrue();
      expect(FormThemeDeleteManager.isEmpty(undefined)).assertTrue();
      expect(FormThemeDeleteManager.isEmpty('')).assertTrue();
      expect(FormThemeDeleteManager.isEmpty(0)).assertTrue();
      expect(FormThemeDeleteManager.isEmpty([])).assertTrue();
      expect(FormThemeDeleteManager.isEmpty(1, null)).assertTrue();
      expect(FormThemeDeleteManager.isEmpty(1, undefined)).assertTrue();
      expect(FormThemeDeleteManager.isEmpty(1, true)).assertTrue();
      expect(FormThemeDeleteManager.isEmpty(1, false)).assertFalse();
    })

    it('FormThemeDeleteManager_017', 0, () => {
      expect(FormThemeDeleteManager.equals(null, 'a')).assertFalse();
      expect(FormThemeDeleteManager.equals(undefined, 'a')).assertFalse();
      expect(FormThemeDeleteManager.equals('a', null)).assertFalse();
      expect(FormThemeDeleteManager.equals('a', undefined)).assertFalse();
      expect(FormThemeDeleteManager.equals('a', 1)).assertFalse();
      expect(FormThemeDeleteManager.equals(1, 'a')).assertFalse();
      expect(FormThemeDeleteManager.equals(1, [])).assertFalse();
      expect(FormThemeDeleteManager.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormThemeDeleteManager.equals([], m)).assertFalse();
      expect(FormThemeDeleteManager.equals(m, [])).assertFalse();
      expect(FormThemeDeleteManager.equals([1,2], [])).assertFalse();
      expect(FormThemeDeleteManager.equals([], [1, 2])).assertFalse();
      expect(FormThemeDeleteManager.equals([1], [1, 2])).assertFalse();
      expect(FormThemeDeleteManager.equals([1, 3], [1, 2])).assertFalse();
      expect(FormThemeDeleteManager.equals([1, 2], [1, 2])).assertTrue();
      expect(FormThemeDeleteManager.equals(2, 2)).assertTrue();
    })
  });
}