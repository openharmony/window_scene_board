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
import { FormStackAddManager } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackAddManager';

export function FormStackAddManagerTest() {
  describe('FormStackAddManagerTest', () => {
    it('FormStackAddManager_001', 0, () => {
      expect(FormStackAddManager.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackAddManager.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackAddManager.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackAddManager.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackAddManager.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackAddManager.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackAddManager.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackAddManager_002', 0, () => {
      expect(FormStackAddManager.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackAddManager.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackAddManager.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackAddManager.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackAddManager.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackAddManager.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackAddManager.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackAddManager_003', 0, () => {
      expect(FormStackAddManager.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackAddManager.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackAddManager.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAddManager.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAddManager.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAddManager.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackAddManager.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackAddManager_004', 0, () => {
      expect(FormStackAddManager.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackAddManager.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackAddManager.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAddManager.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAddManager.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAddManager.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackAddManager.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackAddManager_005', 0, () => {
      expect(FormStackAddManager.isNumber("")).assertFalse();
      expect(FormStackAddManager.isNumber(null)).assertFalse();
      expect(FormStackAddManager.isNumber(undefined)).assertFalse();
      expect(FormStackAddManager.isNumber("abc")).assertFalse();
      expect(FormStackAddManager.isNumber("123")).assertTrue();
    });

    it('FormStackAddManager_006', 0, () => {
      expect(FormStackAddManager.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackAddManager.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackAddManager.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackAddManager.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackAddManager.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackAddManager.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackAddManager_007', 0, () => {
      expect(FormStackAddManager.getDefaultId(null) === null).assertTrue();
      expect(FormStackAddManager.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackAddManager.getDefaultId('') === '').assertTrue();
      expect(FormStackAddManager.getDefaultId('default') !== '').assertTrue();
      expect(FormStackAddManager.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackAddManager.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackAddManager_008', 0, () => {
      expect(FormStackAddManager.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackAddManager.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackAddManager.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackAddManager.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackAddManager.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackAddManager.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackAddManager.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackAddManager_009', 0, () => {
      expect(FormStackAddManager.drawFontWidth() === -1).assertTrue();
      expect(FormStackAddManager.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackAddManager.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackAddManager.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackAddManager.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackAddManager.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackAddManager.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackAddManager.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackAddManager.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackAddManager.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackAddManager.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackAddManager.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackAddManager.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackAddManager.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackAddManager.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackAddManager.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackAddManager.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackAddManager.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackAddManager.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackAddManager.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackAddManager.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackAddManager.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackAddManager_010', 0, () => {
      expect(FormStackAddManager.drawTextAlign() === -1).assertTrue();
      expect(FormStackAddManager.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackAddManager.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackAddManager.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackAddManager.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackAddManager.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackAddManager.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackAddManager.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackAddManager_011', 0, () => {
      expect(FormStackAddManager.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackAddManager.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackAddManager.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackAddManager.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackAddManager.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackAddManager.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackAddManager.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackAddManager.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackAddManager.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackAddManager.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackAddManager.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackAddManager.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackAddManager.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackAddManager.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackAddManager.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackAddManager.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackAddManager.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackAddManager.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackAddManager.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackAddManager_012', 0, () => {
      expect(FormStackAddManager.checkArr([]) === false).assertTrue();
      expect(FormStackAddManager.checkArr(null) === false).assertTrue();
      expect(FormStackAddManager.checkArr(undefined) === false).assertTrue();
      expect(FormStackAddManager.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackAddManager.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackAddManager.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackAddManager.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackAddManager.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackAddManager.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackAddManager.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackAddManager.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackAddManager.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackAddManager.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackAddManager.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackAddManager.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackAddManager.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackAddManager.getUUID().length > 0).assertTrue();
    })

    it('FormStackAddManager_013', 0, () => {
      expect(FormStackAddManager.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackAddManager.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackAddManager_014', 0, () => {
      expect(FormStackAddManager.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackAddManager.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackAddManager.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackAddManager.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackAddManager.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackAddManager.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackAddManager.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackAddManager.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackAddManager_015', 0, () => {
      expect(FormStackAddManager.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackAddManager.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackAddManager.getArraySum([], null) === -1).assertTrue();
      expect(FormStackAddManager.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackAddManager.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackAddManager.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackAddManager.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackAddManager.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackAddManager.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackAddManager.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackAddManager.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackAddManager.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackAddManager_016', 0, () => {
      expect(FormStackAddManager.isEmpty(null)).assertTrue();
      expect(FormStackAddManager.isEmpty(undefined)).assertTrue();
      expect(FormStackAddManager.isEmpty('')).assertTrue();
      expect(FormStackAddManager.isEmpty(0)).assertTrue();
      expect(FormStackAddManager.isEmpty([])).assertTrue();
      expect(FormStackAddManager.isEmpty(1, null)).assertTrue();
      expect(FormStackAddManager.isEmpty(1, undefined)).assertTrue();
      expect(FormStackAddManager.isEmpty(1, true)).assertTrue();
      expect(FormStackAddManager.isEmpty(1, false)).assertFalse();
    })

    it('FormStackAddManager_017', 0, () => {
      expect(FormStackAddManager.equals(null, 'a')).assertFalse();
      expect(FormStackAddManager.equals(undefined, 'a')).assertFalse();
      expect(FormStackAddManager.equals('a', null)).assertFalse();
      expect(FormStackAddManager.equals('a', undefined)).assertFalse();
      expect(FormStackAddManager.equals('a', 1)).assertFalse();
      expect(FormStackAddManager.equals(1, 'a')).assertFalse();
      expect(FormStackAddManager.equals(1, [])).assertFalse();
      expect(FormStackAddManager.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackAddManager.equals([], m)).assertFalse();
      expect(FormStackAddManager.equals(m, [])).assertFalse();
      expect(FormStackAddManager.equals([1,2], [])).assertFalse();
      expect(FormStackAddManager.equals([], [1, 2])).assertFalse();
      expect(FormStackAddManager.equals([1], [1, 2])).assertFalse();
      expect(FormStackAddManager.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackAddManager.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackAddManager.equals(2, 2)).assertTrue();
    })
  });
}