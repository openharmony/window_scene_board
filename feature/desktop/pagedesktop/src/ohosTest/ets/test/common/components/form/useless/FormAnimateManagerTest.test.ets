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
import { FormAnimateManager } from '../../../../../../../main/ets/default/common/components/form/useless/FormAnimateManager';

export function FormAnimateManagerTest() {
  describe('FormAnimateManagerTest', () => {
    it('FormAnimateManager_001', 0, () => {
      expect(FormAnimateManager.getSum("", '1') === -1).assertEqual(true);
      expect(FormAnimateManager.getSum(null, '1') === -1).assertEqual(true);
      expect(FormAnimateManager.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormAnimateManager.getSum('1', '') === -1).assertEqual(true);
      expect(FormAnimateManager.getSum('1', null) === -1).assertEqual(true);
      expect(FormAnimateManager.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormAnimateManager.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAnimateManager_002', 0, () => {
      expect(FormAnimateManager.stringToArray("", ",").length === 0).assertTrue();
      expect(FormAnimateManager.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormAnimateManager.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormAnimateManager.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormAnimateManager.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormAnimateManager.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormAnimateManager.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAnimateManager_003', 0, () => {
      expect(FormAnimateManager.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormAnimateManager.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormAnimateManager.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormAnimateManager.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormAnimateManager.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormAnimateManager.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormAnimateManager.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAnimateManager_004', 0, () => {
      expect(FormAnimateManager.getIntValues("", ",").length === 0).assertTrue();
      expect(FormAnimateManager.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormAnimateManager.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormAnimateManager.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormAnimateManager.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormAnimateManager.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormAnimateManager.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAnimateManager_005', 0, () => {
      expect(FormAnimateManager.isNumber("")).assertFalse();
      expect(FormAnimateManager.isNumber(null)).assertFalse();
      expect(FormAnimateManager.isNumber(undefined)).assertFalse();
      expect(FormAnimateManager.isNumber("abc")).assertFalse();
      expect(FormAnimateManager.isNumber("123")).assertTrue();
    });

    it('FormAnimateManager_006', 0, () => {
      expect(FormAnimateManager.getStrByCount(null , 1) === '').assertTrue();
      expect(FormAnimateManager.getStrByCount('' , 1) === '').assertTrue();
      expect(FormAnimateManager.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormAnimateManager.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormAnimateManager.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormAnimateManager.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAnimateManager_007', 0, () => {
      expect(FormAnimateManager.getDefaultId(null) === null).assertTrue();
      expect(FormAnimateManager.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormAnimateManager.getDefaultId('') === '').assertTrue();
      expect(FormAnimateManager.getDefaultId('default') !== '').assertTrue();
      expect(FormAnimateManager.getDefaultId('aaa') !== '').assertTrue();
      expect(FormAnimateManager.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAnimateManager_008', 0, () => {
      expect(FormAnimateManager.getIndexByString("", []) === -1).assertTrue();
      expect(FormAnimateManager.getIndexByString(null, []) === -1).assertTrue();
      expect(FormAnimateManager.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormAnimateManager.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormAnimateManager.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormAnimateManager.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormAnimateManager.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAnimateManager_009', 0, () => {
      expect(FormAnimateManager.drawFontWidth() === -1).assertTrue();
      expect(FormAnimateManager.drawFontWidth(100) === 1).assertTrue();
      expect(FormAnimateManager.drawFontWidth(200) === 2).assertTrue();
      expect(FormAnimateManager.drawFontWidth(300) === 3).assertTrue();
      expect(FormAnimateManager.drawFontWidth(400) === 4).assertTrue();
      expect(FormAnimateManager.drawFontWidth(500) === 6).assertTrue();
      expect(FormAnimateManager.drawFontWidth(600) === 7).assertTrue();
      expect(FormAnimateManager.drawFontWidth(700) === 8).assertTrue();
      expect(FormAnimateManager.drawFontWidth(800) === 9).assertTrue();
      expect(FormAnimateManager.drawFontWidth(900) === 1).assertTrue();
      expect(FormAnimateManager.drawFontWidth(1000) === 5).assertTrue();
      expect(FormAnimateManager.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormAnimateManager.drawFontWeightFormat() === 3).assertTrue();
      expect(FormAnimateManager.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormAnimateManager.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormAnimateManager.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormAnimateManager.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormAnimateManager.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormAnimateManager.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormAnimateManager.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormAnimateManager.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormAnimateManager.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAnimateManager_010', 0, () => {
      expect(FormAnimateManager.drawTextAlign() === -1).assertTrue();
      expect(FormAnimateManager.drawTextAlign(100) === 0).assertTrue();
      expect(FormAnimateManager.drawTextAlign(200) === 1).assertTrue();
      expect(FormAnimateManager.drawTextAlign(300) === 2).assertTrue();
      expect(FormAnimateManager.drawTextAlign(400) === 3).assertTrue();
      expect(FormAnimateManager.drawTextAlign(500) === 4).assertTrue();
      expect(FormAnimateManager.drawTextAlign(600) === 5).assertTrue();
      expect(FormAnimateManager.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAnimateManager_011', 0, () => {
      expect(FormAnimateManager.getStringIndex('', '') === -1).assertTrue();
      expect(FormAnimateManager.getStringIndex(null, '') === -1).assertTrue();
      expect(FormAnimateManager.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormAnimateManager.getStringIndex('a', '') === -1).assertTrue();
      expect(FormAnimateManager.getStringIndex('a', null) === -1).assertTrue();
      expect(FormAnimateManager.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormAnimateManager.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormAnimateManager.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormAnimateManager.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormAnimateManager.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormAnimateManager.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormAnimateManager.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormAnimateManager.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormAnimateManager.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormAnimateManager.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormAnimateManager.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormAnimateManager.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormAnimateManager.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormAnimateManager.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAnimateManager_012', 0, () => {
      expect(FormAnimateManager.checkArr([]) === false).assertTrue();
      expect(FormAnimateManager.checkArr(null) === false).assertTrue();
      expect(FormAnimateManager.checkArr(undefined) === false).assertTrue();
      expect(FormAnimateManager.checkArr(['', 'b']) === false).assertTrue();
      expect(FormAnimateManager.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormAnimateManager.checkArr([null, 'b']) === false).assertTrue();
      expect(FormAnimateManager.checkArr(['a', '']) === false).assertTrue();
      expect(FormAnimateManager.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormAnimateManager.checkArr(['a', null]) === false).assertTrue();
      expect(FormAnimateManager.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormAnimateManager.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormAnimateManager.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormAnimateManager.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormAnimateManager.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormAnimateManager.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormAnimateManager.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormAnimateManager.getUUID().length > 0).assertTrue();
    })

    it('FormAnimateManager_013', 0, () => {
      expect(FormAnimateManager.verifyValue(1, 2) === 1).assertTrue();
      expect(FormAnimateManager.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAnimateManager_014', 0, () => {
      expect(FormAnimateManager.getBinaryData(null, '') === '').assertTrue();
      expect(FormAnimateManager.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormAnimateManager.getBinaryData(2, null) === '').assertTrue();
      expect(FormAnimateManager.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormAnimateManager.getBinaryData(-2, '') === '').assertTrue();
      expect(FormAnimateManager.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormAnimateManager.getBinaryData(0, '') === '').assertTrue();
      expect(FormAnimateManager.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAnimateManager_015', 0, () => {
      expect(FormAnimateManager.getArraySum(null, []) === -1).assertTrue();
      expect(FormAnimateManager.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormAnimateManager.getArraySum([], null) === -1).assertTrue();
      expect(FormAnimateManager.getArraySum([], undefined) === -1).assertTrue();
      expect(FormAnimateManager.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormAnimateManager.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormAnimateManager.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormAnimateManager.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormAnimateManager.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormAnimateManager.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormAnimateManager.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormAnimateManager.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAnimateManager_016', 0, () => {
      expect(FormAnimateManager.isEmpty(null)).assertTrue();
      expect(FormAnimateManager.isEmpty(undefined)).assertTrue();
      expect(FormAnimateManager.isEmpty('')).assertTrue();
      expect(FormAnimateManager.isEmpty(0)).assertTrue();
      expect(FormAnimateManager.isEmpty([])).assertTrue();
      expect(FormAnimateManager.isEmpty(1, null)).assertTrue();
      expect(FormAnimateManager.isEmpty(1, undefined)).assertTrue();
      expect(FormAnimateManager.isEmpty(1, true)).assertTrue();
      expect(FormAnimateManager.isEmpty(1, false)).assertFalse();
    })

    it('FormAnimateManager_017', 0, () => {
      expect(FormAnimateManager.equals(null, 'a')).assertFalse();
      expect(FormAnimateManager.equals(undefined, 'a')).assertFalse();
      expect(FormAnimateManager.equals('a', null)).assertFalse();
      expect(FormAnimateManager.equals('a', undefined)).assertFalse();
      expect(FormAnimateManager.equals('a', 1)).assertFalse();
      expect(FormAnimateManager.equals(1, 'a')).assertFalse();
      expect(FormAnimateManager.equals(1, [])).assertFalse();
      expect(FormAnimateManager.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormAnimateManager.equals([], m)).assertFalse();
      expect(FormAnimateManager.equals(m, [])).assertFalse();
      expect(FormAnimateManager.equals([1,2], [])).assertFalse();
      expect(FormAnimateManager.equals([], [1, 2])).assertFalse();
      expect(FormAnimateManager.equals([1], [1, 2])).assertFalse();
      expect(FormAnimateManager.equals([1, 3], [1, 2])).assertFalse();
      expect(FormAnimateManager.equals([1, 2], [1, 2])).assertTrue();
      expect(FormAnimateManager.equals(2, 2)).assertTrue();
    })
  });
}