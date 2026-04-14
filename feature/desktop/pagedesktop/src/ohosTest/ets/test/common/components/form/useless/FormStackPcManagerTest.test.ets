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
import { FormStackPcManager } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackPcManager';

export function FormStackPcManagerTest() {
  describe('FormStackPcManagerTest', () => {
    it('FormStackPcManager_001', 0, () => {
      expect(FormStackPcManager.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackPcManager.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackPcManager.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackPcManager.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackPcManager.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackPcManager.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackPcManager.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackPcManager_002', 0, () => {
      expect(FormStackPcManager.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackPcManager.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackPcManager.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackPcManager.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackPcManager.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackPcManager.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackPcManager.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackPcManager_003', 0, () => {
      expect(FormStackPcManager.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackPcManager.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackPcManager.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackPcManager.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackPcManager.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackPcManager.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackPcManager.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackPcManager_004', 0, () => {
      expect(FormStackPcManager.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackPcManager.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackPcManager.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackPcManager.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackPcManager.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackPcManager.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackPcManager.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackPcManager_005', 0, () => {
      expect(FormStackPcManager.isNumber("")).assertFalse();
      expect(FormStackPcManager.isNumber(null)).assertFalse();
      expect(FormStackPcManager.isNumber(undefined)).assertFalse();
      expect(FormStackPcManager.isNumber("abc")).assertFalse();
      expect(FormStackPcManager.isNumber("123")).assertTrue();
    });

    it('FormStackPcManager_006', 0, () => {
      expect(FormStackPcManager.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackPcManager.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackPcManager.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackPcManager.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackPcManager.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackPcManager.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackPcManager_007', 0, () => {
      expect(FormStackPcManager.getDefaultId(null) === null).assertTrue();
      expect(FormStackPcManager.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackPcManager.getDefaultId('') === '').assertTrue();
      expect(FormStackPcManager.getDefaultId('default') !== '').assertTrue();
      expect(FormStackPcManager.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackPcManager.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackPcManager_008', 0, () => {
      expect(FormStackPcManager.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackPcManager.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackPcManager.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackPcManager.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackPcManager.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackPcManager.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackPcManager.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackPcManager_009', 0, () => {
      expect(FormStackPcManager.drawFontWidth() === -1).assertTrue();
      expect(FormStackPcManager.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackPcManager.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackPcManager.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackPcManager.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackPcManager.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackPcManager.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackPcManager.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackPcManager.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackPcManager.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackPcManager.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackPcManager.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackPcManager.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackPcManager.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackPcManager.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackPcManager.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackPcManager.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackPcManager.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackPcManager.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackPcManager.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackPcManager.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackPcManager.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackPcManager_010', 0, () => {
      expect(FormStackPcManager.drawTextAlign() === -1).assertTrue();
      expect(FormStackPcManager.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackPcManager.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackPcManager.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackPcManager.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackPcManager.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackPcManager.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackPcManager.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackPcManager_011', 0, () => {
      expect(FormStackPcManager.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackPcManager.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackPcManager.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackPcManager.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackPcManager.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackPcManager.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackPcManager.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackPcManager.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackPcManager.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackPcManager.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackPcManager.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackPcManager.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackPcManager.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackPcManager.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackPcManager.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackPcManager.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackPcManager.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackPcManager.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackPcManager.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackPcManager_012', 0, () => {
      expect(FormStackPcManager.checkArr([]) === false).assertTrue();
      expect(FormStackPcManager.checkArr(null) === false).assertTrue();
      expect(FormStackPcManager.checkArr(undefined) === false).assertTrue();
      expect(FormStackPcManager.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackPcManager.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackPcManager.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackPcManager.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackPcManager.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackPcManager.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackPcManager.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackPcManager.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackPcManager.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackPcManager.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackPcManager.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackPcManager.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackPcManager.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackPcManager.getUUID().length > 0).assertTrue();
    })

    it('FormStackPcManager_013', 0, () => {
      expect(FormStackPcManager.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackPcManager.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackPcManager_014', 0, () => {
      expect(FormStackPcManager.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackPcManager.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackPcManager.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackPcManager.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackPcManager.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackPcManager.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackPcManager.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackPcManager.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackPcManager_015', 0, () => {
      expect(FormStackPcManager.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackPcManager.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackPcManager.getArraySum([], null) === -1).assertTrue();
      expect(FormStackPcManager.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackPcManager.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackPcManager.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackPcManager.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackPcManager.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackPcManager.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackPcManager.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackPcManager.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackPcManager.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackPcManager_016', 0, () => {
      expect(FormStackPcManager.isEmpty(null)).assertTrue();
      expect(FormStackPcManager.isEmpty(undefined)).assertTrue();
      expect(FormStackPcManager.isEmpty('')).assertTrue();
      expect(FormStackPcManager.isEmpty(0)).assertTrue();
      expect(FormStackPcManager.isEmpty([])).assertTrue();
      expect(FormStackPcManager.isEmpty(1, null)).assertTrue();
      expect(FormStackPcManager.isEmpty(1, undefined)).assertTrue();
      expect(FormStackPcManager.isEmpty(1, true)).assertTrue();
      expect(FormStackPcManager.isEmpty(1, false)).assertFalse();
    })

    it('FormStackPcManager_017', 0, () => {
      expect(FormStackPcManager.equals(null, 'a')).assertFalse();
      expect(FormStackPcManager.equals(undefined, 'a')).assertFalse();
      expect(FormStackPcManager.equals('a', null)).assertFalse();
      expect(FormStackPcManager.equals('a', undefined)).assertFalse();
      expect(FormStackPcManager.equals('a', 1)).assertFalse();
      expect(FormStackPcManager.equals(1, 'a')).assertFalse();
      expect(FormStackPcManager.equals(1, [])).assertFalse();
      expect(FormStackPcManager.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackPcManager.equals([], m)).assertFalse();
      expect(FormStackPcManager.equals(m, [])).assertFalse();
      expect(FormStackPcManager.equals([1,2], [])).assertFalse();
      expect(FormStackPcManager.equals([], [1, 2])).assertFalse();
      expect(FormStackPcManager.equals([1], [1, 2])).assertFalse();
      expect(FormStackPcManager.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackPcManager.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackPcManager.equals(2, 2)).assertTrue();
    })
  });
}