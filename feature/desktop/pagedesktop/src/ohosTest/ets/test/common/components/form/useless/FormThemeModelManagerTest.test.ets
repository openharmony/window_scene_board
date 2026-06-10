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
import { FormThemeModelManager } from '../../../../../../../main/ets/default/common/components/form/useless/FormThemeModelManager';

export function FormThemeModelManagerTest() {
  describe('FormThemeModelManagerTest', () => {
    it('FormThemeModelManager_001', 0, () => {
      expect(FormThemeModelManager.getSum("", '1') === -1).assertEqual(true);
      expect(FormThemeModelManager.getSum(null, '1') === -1).assertEqual(true);
      expect(FormThemeModelManager.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormThemeModelManager.getSum('1', '') === -1).assertEqual(true);
      expect(FormThemeModelManager.getSum('1', null) === -1).assertEqual(true);
      expect(FormThemeModelManager.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormThemeModelManager.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormThemeModelManager_002', 0, () => {
      expect(FormThemeModelManager.stringToArray("", ",").length === 0).assertTrue();
      expect(FormThemeModelManager.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormThemeModelManager.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormThemeModelManager.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormThemeModelManager.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormThemeModelManager.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormThemeModelManager.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormThemeModelManager_003', 0, () => {
      expect(FormThemeModelManager.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormThemeModelManager.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormThemeModelManager.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeModelManager.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeModelManager.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeModelManager.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormThemeModelManager.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormThemeModelManager_004', 0, () => {
      expect(FormThemeModelManager.getIntValues("", ",").length === 0).assertTrue();
      expect(FormThemeModelManager.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormThemeModelManager.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeModelManager.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeModelManager.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeModelManager.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormThemeModelManager.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormThemeModelManager_005', 0, () => {
      expect(FormThemeModelManager.isNumber("")).assertFalse();
      expect(FormThemeModelManager.isNumber(null)).assertFalse();
      expect(FormThemeModelManager.isNumber(undefined)).assertFalse();
      expect(FormThemeModelManager.isNumber("abc")).assertFalse();
      expect(FormThemeModelManager.isNumber("123")).assertTrue();
    });

    it('FormThemeModelManager_006', 0, () => {
      expect(FormThemeModelManager.getStrByCount(null , 1) === '').assertTrue();
      expect(FormThemeModelManager.getStrByCount('' , 1) === '').assertTrue();
      expect(FormThemeModelManager.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormThemeModelManager.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormThemeModelManager.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormThemeModelManager.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormThemeModelManager_007', 0, () => {
      expect(FormThemeModelManager.getDefaultId(null) === null).assertTrue();
      expect(FormThemeModelManager.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormThemeModelManager.getDefaultId('') === '').assertTrue();
      expect(FormThemeModelManager.getDefaultId('default') !== '').assertTrue();
      expect(FormThemeModelManager.getDefaultId('aaa') !== '').assertTrue();
      expect(FormThemeModelManager.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormThemeModelManager_008', 0, () => {
      expect(FormThemeModelManager.getIndexByString("", []) === -1).assertTrue();
      expect(FormThemeModelManager.getIndexByString(null, []) === -1).assertTrue();
      expect(FormThemeModelManager.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormThemeModelManager.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormThemeModelManager.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormThemeModelManager.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormThemeModelManager.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormThemeModelManager_009', 0, () => {
      expect(FormThemeModelManager.drawFontWidth() === -1).assertTrue();
      expect(FormThemeModelManager.drawFontWidth(100) === 1).assertTrue();
      expect(FormThemeModelManager.drawFontWidth(200) === 2).assertTrue();
      expect(FormThemeModelManager.drawFontWidth(300) === 3).assertTrue();
      expect(FormThemeModelManager.drawFontWidth(400) === 4).assertTrue();
      expect(FormThemeModelManager.drawFontWidth(500) === 6).assertTrue();
      expect(FormThemeModelManager.drawFontWidth(600) === 7).assertTrue();
      expect(FormThemeModelManager.drawFontWidth(700) === 8).assertTrue();
      expect(FormThemeModelManager.drawFontWidth(800) === 9).assertTrue();
      expect(FormThemeModelManager.drawFontWidth(900) === 1).assertTrue();
      expect(FormThemeModelManager.drawFontWidth(1000) === 5).assertTrue();
      expect(FormThemeModelManager.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormThemeModelManager.drawFontWeightFormat() === 3).assertTrue();
      expect(FormThemeModelManager.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormThemeModelManager.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormThemeModelManager.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormThemeModelManager.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormThemeModelManager.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormThemeModelManager.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormThemeModelManager.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormThemeModelManager.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormThemeModelManager.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormThemeModelManager_010', 0, () => {
      expect(FormThemeModelManager.drawTextAlign() === -1).assertTrue();
      expect(FormThemeModelManager.drawTextAlign(100) === 0).assertTrue();
      expect(FormThemeModelManager.drawTextAlign(200) === 1).assertTrue();
      expect(FormThemeModelManager.drawTextAlign(300) === 2).assertTrue();
      expect(FormThemeModelManager.drawTextAlign(400) === 3).assertTrue();
      expect(FormThemeModelManager.drawTextAlign(500) === 4).assertTrue();
      expect(FormThemeModelManager.drawTextAlign(600) === 5).assertTrue();
      expect(FormThemeModelManager.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormThemeModelManager_011', 0, () => {
      expect(FormThemeModelManager.getStringIndex('', '') === -1).assertTrue();
      expect(FormThemeModelManager.getStringIndex(null, '') === -1).assertTrue();
      expect(FormThemeModelManager.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormThemeModelManager.getStringIndex('a', '') === -1).assertTrue();
      expect(FormThemeModelManager.getStringIndex('a', null) === -1).assertTrue();
      expect(FormThemeModelManager.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormThemeModelManager.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormThemeModelManager.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormThemeModelManager.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormThemeModelManager.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormThemeModelManager.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormThemeModelManager.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormThemeModelManager.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormThemeModelManager.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormThemeModelManager.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormThemeModelManager.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormThemeModelManager.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormThemeModelManager.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormThemeModelManager.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormThemeModelManager_012', 0, () => {
      expect(FormThemeModelManager.checkArr([]) === false).assertTrue();
      expect(FormThemeModelManager.checkArr(null) === false).assertTrue();
      expect(FormThemeModelManager.checkArr(undefined) === false).assertTrue();
      expect(FormThemeModelManager.checkArr(['', 'b']) === false).assertTrue();
      expect(FormThemeModelManager.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormThemeModelManager.checkArr([null, 'b']) === false).assertTrue();
      expect(FormThemeModelManager.checkArr(['a', '']) === false).assertTrue();
      expect(FormThemeModelManager.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormThemeModelManager.checkArr(['a', null]) === false).assertTrue();
      expect(FormThemeModelManager.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormThemeModelManager.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormThemeModelManager.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormThemeModelManager.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormThemeModelManager.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormThemeModelManager.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormThemeModelManager.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormThemeModelManager.getUUID().length > 0).assertTrue();
    })

    it('FormThemeModelManager_013', 0, () => {
      expect(FormThemeModelManager.verifyValue(1, 2) === 1).assertTrue();
      expect(FormThemeModelManager.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormThemeModelManager_014', 0, () => {
      expect(FormThemeModelManager.getBinaryData(null, '') === '').assertTrue();
      expect(FormThemeModelManager.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormThemeModelManager.getBinaryData(2, null) === '').assertTrue();
      expect(FormThemeModelManager.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormThemeModelManager.getBinaryData(-2, '') === '').assertTrue();
      expect(FormThemeModelManager.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormThemeModelManager.getBinaryData(0, '') === '').assertTrue();
      expect(FormThemeModelManager.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormThemeModelManager_015', 0, () => {
      expect(FormThemeModelManager.getArraySum(null, []) === -1).assertTrue();
      expect(FormThemeModelManager.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormThemeModelManager.getArraySum([], null) === -1).assertTrue();
      expect(FormThemeModelManager.getArraySum([], undefined) === -1).assertTrue();
      expect(FormThemeModelManager.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormThemeModelManager.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormThemeModelManager.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormThemeModelManager.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormThemeModelManager.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormThemeModelManager.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormThemeModelManager.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormThemeModelManager.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormThemeModelManager_016', 0, () => {
      expect(FormThemeModelManager.isEmpty(null)).assertTrue();
      expect(FormThemeModelManager.isEmpty(undefined)).assertTrue();
      expect(FormThemeModelManager.isEmpty('')).assertTrue();
      expect(FormThemeModelManager.isEmpty(0)).assertTrue();
      expect(FormThemeModelManager.isEmpty([])).assertTrue();
      expect(FormThemeModelManager.isEmpty(1, null)).assertTrue();
      expect(FormThemeModelManager.isEmpty(1, undefined)).assertTrue();
      expect(FormThemeModelManager.isEmpty(1, true)).assertTrue();
      expect(FormThemeModelManager.isEmpty(1, false)).assertFalse();
    })

    it('FormThemeModelManager_017', 0, () => {
      expect(FormThemeModelManager.equals(null, 'a')).assertFalse();
      expect(FormThemeModelManager.equals(undefined, 'a')).assertFalse();
      expect(FormThemeModelManager.equals('a', null)).assertFalse();
      expect(FormThemeModelManager.equals('a', undefined)).assertFalse();
      expect(FormThemeModelManager.equals('a', 1)).assertFalse();
      expect(FormThemeModelManager.equals(1, 'a')).assertFalse();
      expect(FormThemeModelManager.equals(1, [])).assertFalse();
      expect(FormThemeModelManager.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormThemeModelManager.equals([], m)).assertFalse();
      expect(FormThemeModelManager.equals(m, [])).assertFalse();
      expect(FormThemeModelManager.equals([1,2], [])).assertFalse();
      expect(FormThemeModelManager.equals([], [1, 2])).assertFalse();
      expect(FormThemeModelManager.equals([1], [1, 2])).assertFalse();
      expect(FormThemeModelManager.equals([1, 3], [1, 2])).assertFalse();
      expect(FormThemeModelManager.equals([1, 2], [1, 2])).assertTrue();
      expect(FormThemeModelManager.equals(2, 2)).assertTrue();
    })
  });
}