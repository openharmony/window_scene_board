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
import { FormStackDbManager } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackDbManager';

export function FormStackDbManagerTest() {
  describe('FormStackDbManagerTest', () => {
    it('FormStackDbManager_001', 0, () => {
      expect(FormStackDbManager.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackDbManager.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackDbManager.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackDbManager.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackDbManager.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackDbManager.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackDbManager.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackDbManager_002', 0, () => {
      expect(FormStackDbManager.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackDbManager.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackDbManager.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbManager.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackDbManager.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbManager.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackDbManager.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackDbManager_003', 0, () => {
      expect(FormStackDbManager.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackDbManager.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbManager.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbManager.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbManager.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbManager.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackDbManager.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackDbManager_004', 0, () => {
      expect(FormStackDbManager.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackDbManager.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbManager.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbManager.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbManager.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbManager.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackDbManager.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackDbManager_005', 0, () => {
      expect(FormStackDbManager.isNumber("")).assertFalse();
      expect(FormStackDbManager.isNumber(null)).assertFalse();
      expect(FormStackDbManager.isNumber(undefined)).assertFalse();
      expect(FormStackDbManager.isNumber("abc")).assertFalse();
      expect(FormStackDbManager.isNumber("123")).assertTrue();
    });

    it('FormStackDbManager_006', 0, () => {
      expect(FormStackDbManager.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackDbManager.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackDbManager.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackDbManager.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackDbManager.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackDbManager.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackDbManager_007', 0, () => {
      expect(FormStackDbManager.getDefaultId(null) === null).assertTrue();
      expect(FormStackDbManager.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackDbManager.getDefaultId('') === '').assertTrue();
      expect(FormStackDbManager.getDefaultId('default') !== '').assertTrue();
      expect(FormStackDbManager.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackDbManager.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackDbManager_008', 0, () => {
      expect(FormStackDbManager.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackDbManager.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackDbManager.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackDbManager.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackDbManager.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackDbManager.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackDbManager.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackDbManager_009', 0, () => {
      expect(FormStackDbManager.drawFontWidth() === -1).assertTrue();
      expect(FormStackDbManager.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackDbManager.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackDbManager.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackDbManager.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackDbManager.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackDbManager.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackDbManager.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackDbManager.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackDbManager.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackDbManager.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackDbManager.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackDbManager.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackDbManager.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackDbManager.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackDbManager.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackDbManager.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackDbManager.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackDbManager.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackDbManager.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackDbManager.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackDbManager.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackDbManager_010', 0, () => {
      expect(FormStackDbManager.drawTextAlign() === -1).assertTrue();
      expect(FormStackDbManager.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackDbManager.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackDbManager.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackDbManager.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackDbManager.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackDbManager.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackDbManager.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackDbManager_011', 0, () => {
      expect(FormStackDbManager.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackDbManager.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackDbManager.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackDbManager.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackDbManager.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackDbManager.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackDbManager.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackDbManager.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackDbManager.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackDbManager.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackDbManager.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackDbManager.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackDbManager.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackDbManager.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackDbManager.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackDbManager.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackDbManager.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackDbManager.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackDbManager.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackDbManager_012', 0, () => {
      expect(FormStackDbManager.checkArr([]) === false).assertTrue();
      expect(FormStackDbManager.checkArr(null) === false).assertTrue();
      expect(FormStackDbManager.checkArr(undefined) === false).assertTrue();
      expect(FormStackDbManager.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackDbManager.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackDbManager.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackDbManager.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackDbManager.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackDbManager.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackDbManager.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackDbManager.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackDbManager.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackDbManager.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackDbManager.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackDbManager.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackDbManager.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackDbManager.getUUID().length > 0).assertTrue();
    })

    it('FormStackDbManager_013', 0, () => {
      expect(FormStackDbManager.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackDbManager.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackDbManager_014', 0, () => {
      expect(FormStackDbManager.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackDbManager.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackDbManager.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackDbManager.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackDbManager.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackDbManager.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackDbManager.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackDbManager.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackDbManager_015', 0, () => {
      expect(FormStackDbManager.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackDbManager.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackDbManager.getArraySum([], null) === -1).assertTrue();
      expect(FormStackDbManager.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackDbManager.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackDbManager.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackDbManager.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackDbManager.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackDbManager.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackDbManager.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackDbManager.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackDbManager.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackDbManager_016', 0, () => {
      expect(FormStackDbManager.isEmpty(null)).assertTrue();
      expect(FormStackDbManager.isEmpty(undefined)).assertTrue();
      expect(FormStackDbManager.isEmpty('')).assertTrue();
      expect(FormStackDbManager.isEmpty(0)).assertTrue();
      expect(FormStackDbManager.isEmpty([])).assertTrue();
      expect(FormStackDbManager.isEmpty(1, null)).assertTrue();
      expect(FormStackDbManager.isEmpty(1, undefined)).assertTrue();
      expect(FormStackDbManager.isEmpty(1, true)).assertTrue();
      expect(FormStackDbManager.isEmpty(1, false)).assertFalse();
    })

    it('FormStackDbManager_017', 0, () => {
      expect(FormStackDbManager.equals(null, 'a')).assertFalse();
      expect(FormStackDbManager.equals(undefined, 'a')).assertFalse();
      expect(FormStackDbManager.equals('a', null)).assertFalse();
      expect(FormStackDbManager.equals('a', undefined)).assertFalse();
      expect(FormStackDbManager.equals('a', 1)).assertFalse();
      expect(FormStackDbManager.equals(1, 'a')).assertFalse();
      expect(FormStackDbManager.equals(1, [])).assertFalse();
      expect(FormStackDbManager.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackDbManager.equals([], m)).assertFalse();
      expect(FormStackDbManager.equals(m, [])).assertFalse();
      expect(FormStackDbManager.equals([1,2], [])).assertFalse();
      expect(FormStackDbManager.equals([], [1, 2])).assertFalse();
      expect(FormStackDbManager.equals([1], [1, 2])).assertFalse();
      expect(FormStackDbManager.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackDbManager.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackDbManager.equals(2, 2)).assertTrue();
    })
  });
}