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
import { FormDeleteManager } from '../../../../../../../main/ets/default/common/components/form/useless/FormDeleteManager';

export function FormDeleteManagerTest() {
  describe('FormDeleteManagerTest', () => {
    it('FormDeleteManager_001', 0, () => {
      expect(FormDeleteManager.getSum("", '1') === -1).assertEqual(true);
      expect(FormDeleteManager.getSum(null, '1') === -1).assertEqual(true);
      expect(FormDeleteManager.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormDeleteManager.getSum('1', '') === -1).assertEqual(true);
      expect(FormDeleteManager.getSum('1', null) === -1).assertEqual(true);
      expect(FormDeleteManager.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormDeleteManager.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormDeleteManager_002', 0, () => {
      expect(FormDeleteManager.stringToArray("", ",").length === 0).assertTrue();
      expect(FormDeleteManager.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormDeleteManager.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormDeleteManager.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormDeleteManager.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormDeleteManager.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormDeleteManager.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormDeleteManager_003', 0, () => {
      expect(FormDeleteManager.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormDeleteManager.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormDeleteManager.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormDeleteManager.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormDeleteManager.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormDeleteManager.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormDeleteManager.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormDeleteManager_004', 0, () => {
      expect(FormDeleteManager.getIntValues("", ",").length === 0).assertTrue();
      expect(FormDeleteManager.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormDeleteManager.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormDeleteManager.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormDeleteManager.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormDeleteManager.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormDeleteManager.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormDeleteManager_005', 0, () => {
      expect(FormDeleteManager.isNumber("")).assertFalse();
      expect(FormDeleteManager.isNumber(null)).assertFalse();
      expect(FormDeleteManager.isNumber(undefined)).assertFalse();
      expect(FormDeleteManager.isNumber("abc")).assertFalse();
      expect(FormDeleteManager.isNumber("123")).assertTrue();
    });

    it('FormDeleteManager_006', 0, () => {
      expect(FormDeleteManager.getStrByCount(null , 1) === '').assertTrue();
      expect(FormDeleteManager.getStrByCount('' , 1) === '').assertTrue();
      expect(FormDeleteManager.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormDeleteManager.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormDeleteManager.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormDeleteManager.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormDeleteManager_007', 0, () => {
      expect(FormDeleteManager.getDefaultId(null) === null).assertTrue();
      expect(FormDeleteManager.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormDeleteManager.getDefaultId('') === '').assertTrue();
      expect(FormDeleteManager.getDefaultId('default') !== '').assertTrue();
      expect(FormDeleteManager.getDefaultId('aaa') !== '').assertTrue();
      expect(FormDeleteManager.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormDeleteManager_008', 0, () => {
      expect(FormDeleteManager.getIndexByString("", []) === -1).assertTrue();
      expect(FormDeleteManager.getIndexByString(null, []) === -1).assertTrue();
      expect(FormDeleteManager.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormDeleteManager.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormDeleteManager.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormDeleteManager.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormDeleteManager.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormDeleteManager_009', 0, () => {
      expect(FormDeleteManager.drawFontWidth() === -1).assertTrue();
      expect(FormDeleteManager.drawFontWidth(100) === 1).assertTrue();
      expect(FormDeleteManager.drawFontWidth(200) === 2).assertTrue();
      expect(FormDeleteManager.drawFontWidth(300) === 3).assertTrue();
      expect(FormDeleteManager.drawFontWidth(400) === 4).assertTrue();
      expect(FormDeleteManager.drawFontWidth(500) === 6).assertTrue();
      expect(FormDeleteManager.drawFontWidth(600) === 7).assertTrue();
      expect(FormDeleteManager.drawFontWidth(700) === 8).assertTrue();
      expect(FormDeleteManager.drawFontWidth(800) === 9).assertTrue();
      expect(FormDeleteManager.drawFontWidth(900) === 1).assertTrue();
      expect(FormDeleteManager.drawFontWidth(1000) === 5).assertTrue();
      expect(FormDeleteManager.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormDeleteManager.drawFontWeightFormat() === 3).assertTrue();
      expect(FormDeleteManager.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormDeleteManager.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormDeleteManager.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormDeleteManager.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormDeleteManager.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormDeleteManager.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormDeleteManager.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormDeleteManager.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormDeleteManager.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormDeleteManager_010', 0, () => {
      expect(FormDeleteManager.drawTextAlign() === -1).assertTrue();
      expect(FormDeleteManager.drawTextAlign(100) === 0).assertTrue();
      expect(FormDeleteManager.drawTextAlign(200) === 1).assertTrue();
      expect(FormDeleteManager.drawTextAlign(300) === 2).assertTrue();
      expect(FormDeleteManager.drawTextAlign(400) === 3).assertTrue();
      expect(FormDeleteManager.drawTextAlign(500) === 4).assertTrue();
      expect(FormDeleteManager.drawTextAlign(600) === 5).assertTrue();
      expect(FormDeleteManager.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormDeleteManager_011', 0, () => {
      expect(FormDeleteManager.getStringIndex('', '') === -1).assertTrue();
      expect(FormDeleteManager.getStringIndex(null, '') === -1).assertTrue();
      expect(FormDeleteManager.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormDeleteManager.getStringIndex('a', '') === -1).assertTrue();
      expect(FormDeleteManager.getStringIndex('a', null) === -1).assertTrue();
      expect(FormDeleteManager.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormDeleteManager.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormDeleteManager.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormDeleteManager.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormDeleteManager.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormDeleteManager.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormDeleteManager.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormDeleteManager.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormDeleteManager.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormDeleteManager.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormDeleteManager.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormDeleteManager.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormDeleteManager.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormDeleteManager.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormDeleteManager_012', 0, () => {
      expect(FormDeleteManager.checkArr([]) === false).assertTrue();
      expect(FormDeleteManager.checkArr(null) === false).assertTrue();
      expect(FormDeleteManager.checkArr(undefined) === false).assertTrue();
      expect(FormDeleteManager.checkArr(['', 'b']) === false).assertTrue();
      expect(FormDeleteManager.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormDeleteManager.checkArr([null, 'b']) === false).assertTrue();
      expect(FormDeleteManager.checkArr(['a', '']) === false).assertTrue();
      expect(FormDeleteManager.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormDeleteManager.checkArr(['a', null]) === false).assertTrue();
      expect(FormDeleteManager.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormDeleteManager.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormDeleteManager.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormDeleteManager.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormDeleteManager.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormDeleteManager.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormDeleteManager.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormDeleteManager.getUUID().length > 0).assertTrue();
    })

    it('FormDeleteManager_013', 0, () => {
      expect(FormDeleteManager.verifyValue(1, 2) === 1).assertTrue();
      expect(FormDeleteManager.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormDeleteManager_014', 0, () => {
      expect(FormDeleteManager.getBinaryData(null, '') === '').assertTrue();
      expect(FormDeleteManager.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormDeleteManager.getBinaryData(2, null) === '').assertTrue();
      expect(FormDeleteManager.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormDeleteManager.getBinaryData(-2, '') === '').assertTrue();
      expect(FormDeleteManager.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormDeleteManager.getBinaryData(0, '') === '').assertTrue();
      expect(FormDeleteManager.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormDeleteManager_015', 0, () => {
      expect(FormDeleteManager.getArraySum(null, []) === -1).assertTrue();
      expect(FormDeleteManager.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormDeleteManager.getArraySum([], null) === -1).assertTrue();
      expect(FormDeleteManager.getArraySum([], undefined) === -1).assertTrue();
      expect(FormDeleteManager.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormDeleteManager.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormDeleteManager.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormDeleteManager.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormDeleteManager.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormDeleteManager.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormDeleteManager.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormDeleteManager.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormDeleteManager_016', 0, () => {
      expect(FormDeleteManager.isEmpty(null)).assertTrue();
      expect(FormDeleteManager.isEmpty(undefined)).assertTrue();
      expect(FormDeleteManager.isEmpty('')).assertTrue();
      expect(FormDeleteManager.isEmpty(0)).assertTrue();
      expect(FormDeleteManager.isEmpty([])).assertTrue();
      expect(FormDeleteManager.isEmpty(1, null)).assertTrue();
      expect(FormDeleteManager.isEmpty(1, undefined)).assertTrue();
      expect(FormDeleteManager.isEmpty(1, true)).assertTrue();
      expect(FormDeleteManager.isEmpty(1, false)).assertFalse();
    })

    it('FormDeleteManager_017', 0, () => {
      expect(FormDeleteManager.equals(null, 'a')).assertFalse();
      expect(FormDeleteManager.equals(undefined, 'a')).assertFalse();
      expect(FormDeleteManager.equals('a', null)).assertFalse();
      expect(FormDeleteManager.equals('a', undefined)).assertFalse();
      expect(FormDeleteManager.equals('a', 1)).assertFalse();
      expect(FormDeleteManager.equals(1, 'a')).assertFalse();
      expect(FormDeleteManager.equals(1, [])).assertFalse();
      expect(FormDeleteManager.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormDeleteManager.equals([], m)).assertFalse();
      expect(FormDeleteManager.equals(m, [])).assertFalse();
      expect(FormDeleteManager.equals([1,2], [])).assertFalse();
      expect(FormDeleteManager.equals([], [1, 2])).assertFalse();
      expect(FormDeleteManager.equals([1], [1, 2])).assertFalse();
      expect(FormDeleteManager.equals([1, 3], [1, 2])).assertFalse();
      expect(FormDeleteManager.equals([1, 2], [1, 2])).assertTrue();
      expect(FormDeleteManager.equals(2, 2)).assertTrue();
    })
  });
}