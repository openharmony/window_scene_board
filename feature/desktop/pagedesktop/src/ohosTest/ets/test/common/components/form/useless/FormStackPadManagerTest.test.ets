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
import { FormStackPadManager } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackPadManager';

export function FormStackPadManagerTest() {
  describe('FormStackPadManagerTest', () => {
    it('FormStackPadManager_001', 0, () => {
      expect(FormStackPadManager.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackPadManager.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackPadManager.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackPadManager.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackPadManager.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackPadManager.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackPadManager.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackPadManager_002', 0, () => {
      expect(FormStackPadManager.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackPadManager.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackPadManager.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackPadManager.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackPadManager.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackPadManager.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackPadManager.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackPadManager_003', 0, () => {
      expect(FormStackPadManager.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackPadManager.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackPadManager.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackPadManager.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackPadManager.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackPadManager.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackPadManager.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackPadManager_004', 0, () => {
      expect(FormStackPadManager.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackPadManager.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackPadManager.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackPadManager.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackPadManager.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackPadManager.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackPadManager.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackPadManager_005', 0, () => {
      expect(FormStackPadManager.isNumber("")).assertFalse();
      expect(FormStackPadManager.isNumber(null)).assertFalse();
      expect(FormStackPadManager.isNumber(undefined)).assertFalse();
      expect(FormStackPadManager.isNumber("abc")).assertFalse();
      expect(FormStackPadManager.isNumber("123")).assertTrue();
    });

    it('FormStackPadManager_006', 0, () => {
      expect(FormStackPadManager.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackPadManager.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackPadManager.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackPadManager.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackPadManager.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackPadManager.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackPadManager_007', 0, () => {
      expect(FormStackPadManager.getDefaultId(null) === null).assertTrue();
      expect(FormStackPadManager.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackPadManager.getDefaultId('') === '').assertTrue();
      expect(FormStackPadManager.getDefaultId('default') !== '').assertTrue();
      expect(FormStackPadManager.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackPadManager.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackPadManager_008', 0, () => {
      expect(FormStackPadManager.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackPadManager.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackPadManager.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackPadManager.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackPadManager.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackPadManager.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackPadManager.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackPadManager_009', 0, () => {
      expect(FormStackPadManager.drawFontWidth() === -1).assertTrue();
      expect(FormStackPadManager.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackPadManager.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackPadManager.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackPadManager.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackPadManager.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackPadManager.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackPadManager.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackPadManager.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackPadManager.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackPadManager.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackPadManager.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackPadManager.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackPadManager.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackPadManager.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackPadManager.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackPadManager.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackPadManager.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackPadManager.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackPadManager.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackPadManager.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackPadManager.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackPadManager_010', 0, () => {
      expect(FormStackPadManager.drawTextAlign() === -1).assertTrue();
      expect(FormStackPadManager.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackPadManager.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackPadManager.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackPadManager.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackPadManager.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackPadManager.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackPadManager.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackPadManager_011', 0, () => {
      expect(FormStackPadManager.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackPadManager.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackPadManager.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackPadManager.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackPadManager.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackPadManager.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackPadManager.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackPadManager.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackPadManager.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackPadManager.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackPadManager.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackPadManager.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackPadManager.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackPadManager.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackPadManager.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackPadManager.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackPadManager.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackPadManager.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackPadManager.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackPadManager_012', 0, () => {
      expect(FormStackPadManager.checkArr([]) === false).assertTrue();
      expect(FormStackPadManager.checkArr(null) === false).assertTrue();
      expect(FormStackPadManager.checkArr(undefined) === false).assertTrue();
      expect(FormStackPadManager.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackPadManager.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackPadManager.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackPadManager.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackPadManager.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackPadManager.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackPadManager.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackPadManager.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackPadManager.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackPadManager.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackPadManager.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackPadManager.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackPadManager.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackPadManager.getUUID().length > 0).assertTrue();
    })

    it('FormStackPadManager_013', 0, () => {
      expect(FormStackPadManager.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackPadManager.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackPadManager_014', 0, () => {
      expect(FormStackPadManager.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackPadManager.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackPadManager.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackPadManager.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackPadManager.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackPadManager.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackPadManager.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackPadManager.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackPadManager_015', 0, () => {
      expect(FormStackPadManager.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackPadManager.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackPadManager.getArraySum([], null) === -1).assertTrue();
      expect(FormStackPadManager.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackPadManager.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackPadManager.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackPadManager.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackPadManager.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackPadManager.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackPadManager.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackPadManager.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackPadManager.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackPadManager_016', 0, () => {
      expect(FormStackPadManager.isEmpty(null)).assertTrue();
      expect(FormStackPadManager.isEmpty(undefined)).assertTrue();
      expect(FormStackPadManager.isEmpty('')).assertTrue();
      expect(FormStackPadManager.isEmpty(0)).assertTrue();
      expect(FormStackPadManager.isEmpty([])).assertTrue();
      expect(FormStackPadManager.isEmpty(1, null)).assertTrue();
      expect(FormStackPadManager.isEmpty(1, undefined)).assertTrue();
      expect(FormStackPadManager.isEmpty(1, true)).assertTrue();
      expect(FormStackPadManager.isEmpty(1, false)).assertFalse();
    })

    it('FormStackPadManager_017', 0, () => {
      expect(FormStackPadManager.equals(null, 'a')).assertFalse();
      expect(FormStackPadManager.equals(undefined, 'a')).assertFalse();
      expect(FormStackPadManager.equals('a', null)).assertFalse();
      expect(FormStackPadManager.equals('a', undefined)).assertFalse();
      expect(FormStackPadManager.equals('a', 1)).assertFalse();
      expect(FormStackPadManager.equals(1, 'a')).assertFalse();
      expect(FormStackPadManager.equals(1, [])).assertFalse();
      expect(FormStackPadManager.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackPadManager.equals([], m)).assertFalse();
      expect(FormStackPadManager.equals(m, [])).assertFalse();
      expect(FormStackPadManager.equals([1,2], [])).assertFalse();
      expect(FormStackPadManager.equals([], [1, 2])).assertFalse();
      expect(FormStackPadManager.equals([1], [1, 2])).assertFalse();
      expect(FormStackPadManager.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackPadManager.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackPadManager.equals(2, 2)).assertTrue();
    })
  });
}