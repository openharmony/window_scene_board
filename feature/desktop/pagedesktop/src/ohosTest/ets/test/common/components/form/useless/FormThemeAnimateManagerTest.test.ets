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
import { FormThemeAnimateManager } from '../../../../../../../main/ets/default/common/components/form/useless/FormThemeAnimateManager';

export function FormThemeAnimateManagerTest() {
  describe('FormThemeAnimateManagerTest', () => {
    it('FormThemeAnimateManager_001', 0, () => {
      expect(FormThemeAnimateManager.getSum("", '1') === -1).assertEqual(true);
      expect(FormThemeAnimateManager.getSum(null, '1') === -1).assertEqual(true);
      expect(FormThemeAnimateManager.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormThemeAnimateManager.getSum('1', '') === -1).assertEqual(true);
      expect(FormThemeAnimateManager.getSum('1', null) === -1).assertEqual(true);
      expect(FormThemeAnimateManager.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormThemeAnimateManager.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormThemeAnimateManager_002', 0, () => {
      expect(FormThemeAnimateManager.stringToArray("", ",").length === 0).assertTrue();
      expect(FormThemeAnimateManager.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormThemeAnimateManager.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAnimateManager.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormThemeAnimateManager.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAnimateManager.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormThemeAnimateManager.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormThemeAnimateManager_003', 0, () => {
      expect(FormThemeAnimateManager.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormThemeAnimateManager.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAnimateManager.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAnimateManager.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAnimateManager.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAnimateManager.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormThemeAnimateManager.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormThemeAnimateManager_004', 0, () => {
      expect(FormThemeAnimateManager.getIntValues("", ",").length === 0).assertTrue();
      expect(FormThemeAnimateManager.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAnimateManager.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAnimateManager.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAnimateManager.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAnimateManager.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormThemeAnimateManager.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormThemeAnimateManager_005', 0, () => {
      expect(FormThemeAnimateManager.isNumber("")).assertFalse();
      expect(FormThemeAnimateManager.isNumber(null)).assertFalse();
      expect(FormThemeAnimateManager.isNumber(undefined)).assertFalse();
      expect(FormThemeAnimateManager.isNumber("abc")).assertFalse();
      expect(FormThemeAnimateManager.isNumber("123")).assertTrue();
    });

    it('FormThemeAnimateManager_006', 0, () => {
      expect(FormThemeAnimateManager.getStrByCount(null , 1) === '').assertTrue();
      expect(FormThemeAnimateManager.getStrByCount('' , 1) === '').assertTrue();
      expect(FormThemeAnimateManager.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormThemeAnimateManager.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormThemeAnimateManager.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormThemeAnimateManager.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormThemeAnimateManager_007', 0, () => {
      expect(FormThemeAnimateManager.getDefaultId(null) === null).assertTrue();
      expect(FormThemeAnimateManager.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormThemeAnimateManager.getDefaultId('') === '').assertTrue();
      expect(FormThemeAnimateManager.getDefaultId('default') !== '').assertTrue();
      expect(FormThemeAnimateManager.getDefaultId('aaa') !== '').assertTrue();
      expect(FormThemeAnimateManager.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormThemeAnimateManager_008', 0, () => {
      expect(FormThemeAnimateManager.getIndexByString("", []) === -1).assertTrue();
      expect(FormThemeAnimateManager.getIndexByString(null, []) === -1).assertTrue();
      expect(FormThemeAnimateManager.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormThemeAnimateManager.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormThemeAnimateManager.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormThemeAnimateManager.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormThemeAnimateManager.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormThemeAnimateManager_009', 0, () => {
      expect(FormThemeAnimateManager.drawFontWidth() === -1).assertTrue();
      expect(FormThemeAnimateManager.drawFontWidth(100) === 1).assertTrue();
      expect(FormThemeAnimateManager.drawFontWidth(200) === 2).assertTrue();
      expect(FormThemeAnimateManager.drawFontWidth(300) === 3).assertTrue();
      expect(FormThemeAnimateManager.drawFontWidth(400) === 4).assertTrue();
      expect(FormThemeAnimateManager.drawFontWidth(500) === 6).assertTrue();
      expect(FormThemeAnimateManager.drawFontWidth(600) === 7).assertTrue();
      expect(FormThemeAnimateManager.drawFontWidth(700) === 8).assertTrue();
      expect(FormThemeAnimateManager.drawFontWidth(800) === 9).assertTrue();
      expect(FormThemeAnimateManager.drawFontWidth(900) === 1).assertTrue();
      expect(FormThemeAnimateManager.drawFontWidth(1000) === 5).assertTrue();
      expect(FormThemeAnimateManager.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormThemeAnimateManager.drawFontWeightFormat() === 3).assertTrue();
      expect(FormThemeAnimateManager.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormThemeAnimateManager.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormThemeAnimateManager.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormThemeAnimateManager.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormThemeAnimateManager.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormThemeAnimateManager.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormThemeAnimateManager.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormThemeAnimateManager.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormThemeAnimateManager.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormThemeAnimateManager_010', 0, () => {
      expect(FormThemeAnimateManager.drawTextAlign() === -1).assertTrue();
      expect(FormThemeAnimateManager.drawTextAlign(100) === 0).assertTrue();
      expect(FormThemeAnimateManager.drawTextAlign(200) === 1).assertTrue();
      expect(FormThemeAnimateManager.drawTextAlign(300) === 2).assertTrue();
      expect(FormThemeAnimateManager.drawTextAlign(400) === 3).assertTrue();
      expect(FormThemeAnimateManager.drawTextAlign(500) === 4).assertTrue();
      expect(FormThemeAnimateManager.drawTextAlign(600) === 5).assertTrue();
      expect(FormThemeAnimateManager.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormThemeAnimateManager_011', 0, () => {
      expect(FormThemeAnimateManager.getStringIndex('', '') === -1).assertTrue();
      expect(FormThemeAnimateManager.getStringIndex(null, '') === -1).assertTrue();
      expect(FormThemeAnimateManager.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormThemeAnimateManager.getStringIndex('a', '') === -1).assertTrue();
      expect(FormThemeAnimateManager.getStringIndex('a', null) === -1).assertTrue();
      expect(FormThemeAnimateManager.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormThemeAnimateManager.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormThemeAnimateManager.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormThemeAnimateManager.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormThemeAnimateManager.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormThemeAnimateManager.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormThemeAnimateManager.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormThemeAnimateManager.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormThemeAnimateManager.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormThemeAnimateManager.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormThemeAnimateManager.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormThemeAnimateManager.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormThemeAnimateManager.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormThemeAnimateManager.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormThemeAnimateManager_012', 0, () => {
      expect(FormThemeAnimateManager.checkArr([]) === false).assertTrue();
      expect(FormThemeAnimateManager.checkArr(null) === false).assertTrue();
      expect(FormThemeAnimateManager.checkArr(undefined) === false).assertTrue();
      expect(FormThemeAnimateManager.checkArr(['', 'b']) === false).assertTrue();
      expect(FormThemeAnimateManager.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormThemeAnimateManager.checkArr([null, 'b']) === false).assertTrue();
      expect(FormThemeAnimateManager.checkArr(['a', '']) === false).assertTrue();
      expect(FormThemeAnimateManager.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormThemeAnimateManager.checkArr(['a', null]) === false).assertTrue();
      expect(FormThemeAnimateManager.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormThemeAnimateManager.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormThemeAnimateManager.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormThemeAnimateManager.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormThemeAnimateManager.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormThemeAnimateManager.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormThemeAnimateManager.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormThemeAnimateManager.getUUID().length > 0).assertTrue();
    })

    it('FormThemeAnimateManager_013', 0, () => {
      expect(FormThemeAnimateManager.verifyValue(1, 2) === 1).assertTrue();
      expect(FormThemeAnimateManager.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormThemeAnimateManager_014', 0, () => {
      expect(FormThemeAnimateManager.getBinaryData(null, '') === '').assertTrue();
      expect(FormThemeAnimateManager.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormThemeAnimateManager.getBinaryData(2, null) === '').assertTrue();
      expect(FormThemeAnimateManager.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormThemeAnimateManager.getBinaryData(-2, '') === '').assertTrue();
      expect(FormThemeAnimateManager.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormThemeAnimateManager.getBinaryData(0, '') === '').assertTrue();
      expect(FormThemeAnimateManager.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormThemeAnimateManager_015', 0, () => {
      expect(FormThemeAnimateManager.getArraySum(null, []) === -1).assertTrue();
      expect(FormThemeAnimateManager.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormThemeAnimateManager.getArraySum([], null) === -1).assertTrue();
      expect(FormThemeAnimateManager.getArraySum([], undefined) === -1).assertTrue();
      expect(FormThemeAnimateManager.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormThemeAnimateManager.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormThemeAnimateManager.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormThemeAnimateManager.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormThemeAnimateManager.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormThemeAnimateManager.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormThemeAnimateManager.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormThemeAnimateManager.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormThemeAnimateManager_016', 0, () => {
      expect(FormThemeAnimateManager.isEmpty(null)).assertTrue();
      expect(FormThemeAnimateManager.isEmpty(undefined)).assertTrue();
      expect(FormThemeAnimateManager.isEmpty('')).assertTrue();
      expect(FormThemeAnimateManager.isEmpty(0)).assertTrue();
      expect(FormThemeAnimateManager.isEmpty([])).assertTrue();
      expect(FormThemeAnimateManager.isEmpty(1, null)).assertTrue();
      expect(FormThemeAnimateManager.isEmpty(1, undefined)).assertTrue();
      expect(FormThemeAnimateManager.isEmpty(1, true)).assertTrue();
      expect(FormThemeAnimateManager.isEmpty(1, false)).assertFalse();
    })

    it('FormThemeAnimateManager_017', 0, () => {
      expect(FormThemeAnimateManager.equals(null, 'a')).assertFalse();
      expect(FormThemeAnimateManager.equals(undefined, 'a')).assertFalse();
      expect(FormThemeAnimateManager.equals('a', null)).assertFalse();
      expect(FormThemeAnimateManager.equals('a', undefined)).assertFalse();
      expect(FormThemeAnimateManager.equals('a', 1)).assertFalse();
      expect(FormThemeAnimateManager.equals(1, 'a')).assertFalse();
      expect(FormThemeAnimateManager.equals(1, [])).assertFalse();
      expect(FormThemeAnimateManager.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormThemeAnimateManager.equals([], m)).assertFalse();
      expect(FormThemeAnimateManager.equals(m, [])).assertFalse();
      expect(FormThemeAnimateManager.equals([1,2], [])).assertFalse();
      expect(FormThemeAnimateManager.equals([], [1, 2])).assertFalse();
      expect(FormThemeAnimateManager.equals([1], [1, 2])).assertFalse();
      expect(FormThemeAnimateManager.equals([1, 3], [1, 2])).assertFalse();
      expect(FormThemeAnimateManager.equals([1, 2], [1, 2])).assertTrue();
      expect(FormThemeAnimateManager.equals(2, 2)).assertTrue();
    })
  });
}