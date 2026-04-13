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
import { FormStackDatabaseManager } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackDatabaseManager';

export function FormAddAdapterTest() {
  describe('FormAddAdapterTest', () => {
    it('FormAddAdapter_001', 0, () => {
      expect(FormStackDatabaseManager.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackDatabaseManager.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackDatabaseManager.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackDatabaseManager.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackDatabaseManager.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackDatabaseManager.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackDatabaseManager.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAddAdapter_002', 0, () => {
      expect(FormStackDatabaseManager.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackDatabaseManager.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackDatabaseManager.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackDatabaseManager.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackDatabaseManager.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackDatabaseManager.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackDatabaseManager.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAddAdapter_003', 0, () => {
      expect(FormStackDatabaseManager.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackDatabaseManager.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackDatabaseManager.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDatabaseManager.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDatabaseManager.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDatabaseManager.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackDatabaseManager.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAddAdapter_004', 0, () => {
      expect(FormStackDatabaseManager.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackDatabaseManager.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackDatabaseManager.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDatabaseManager.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDatabaseManager.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDatabaseManager.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackDatabaseManager.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAddAdapter_005', 0, () => {
      expect(FormStackDatabaseManager.isNumber("")).assertFalse();
      expect(FormStackDatabaseManager.isNumber(null)).assertFalse();
      expect(FormStackDatabaseManager.isNumber(undefined)).assertFalse();
      expect(FormStackDatabaseManager.isNumber("abc")).assertFalse();
      expect(FormStackDatabaseManager.isNumber("123")).assertTrue();
    });

    it('FormAddAdapter_006', 0, () => {
      expect(FormStackDatabaseManager.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackDatabaseManager.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackDatabaseManager.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackDatabaseManager.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackDatabaseManager.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackDatabaseManager.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAddAdapter_007', 0, () => {
      expect(FormStackDatabaseManager.getDefaultId(null) === null).assertTrue();
      expect(FormStackDatabaseManager.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackDatabaseManager.getDefaultId('') === '').assertTrue();
      expect(FormStackDatabaseManager.getDefaultId('default') !== '').assertTrue();
      expect(FormStackDatabaseManager.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackDatabaseManager.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAddAdapter_008', 0, () => {
      expect(FormStackDatabaseManager.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackDatabaseManager.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackDatabaseManager.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackDatabaseManager.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackDatabaseManager.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackDatabaseManager.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackDatabaseManager.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAddAdapter_009', 0, () => {
      expect(FormStackDatabaseManager.drawFontWidth() === -1).assertTrue();
      expect(FormStackDatabaseManager.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackDatabaseManager.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackDatabaseManager.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackDatabaseManager.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackDatabaseManager.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackDatabaseManager.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackDatabaseManager.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackDatabaseManager.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackDatabaseManager.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackDatabaseManager.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackDatabaseManager.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackDatabaseManager.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackDatabaseManager.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackDatabaseManager.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackDatabaseManager.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackDatabaseManager.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackDatabaseManager.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackDatabaseManager.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackDatabaseManager.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackDatabaseManager.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackDatabaseManager.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAddAdapter_010', 0, () => {
      expect(FormStackDatabaseManager.drawTextAlign() === -1).assertTrue();
      expect(FormStackDatabaseManager.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackDatabaseManager.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackDatabaseManager.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackDatabaseManager.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackDatabaseManager.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackDatabaseManager.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackDatabaseManager.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAddAdapter_011', 0, () => {
      expect(FormStackDatabaseManager.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackDatabaseManager.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackDatabaseManager.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackDatabaseManager.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackDatabaseManager.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackDatabaseManager.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackDatabaseManager.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackDatabaseManager.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackDatabaseManager.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackDatabaseManager.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackDatabaseManager.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackDatabaseManager.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackDatabaseManager.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackDatabaseManager.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackDatabaseManager.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackDatabaseManager.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackDatabaseManager.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackDatabaseManager.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackDatabaseManager.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAddAdapter_012', 0, () => {
      expect(FormStackDatabaseManager.checkArr([]) === false).assertTrue();
      expect(FormStackDatabaseManager.checkArr(null) === false).assertTrue();
      expect(FormStackDatabaseManager.checkArr(undefined) === false).assertTrue();
      expect(FormStackDatabaseManager.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackDatabaseManager.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackDatabaseManager.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackDatabaseManager.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackDatabaseManager.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackDatabaseManager.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackDatabaseManager.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackDatabaseManager.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackDatabaseManager.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackDatabaseManager.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackDatabaseManager.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackDatabaseManager.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackDatabaseManager.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackDatabaseManager.getUUID().length > 0).assertTrue();
    })

    it('FormAddAdapter_013', 0, () => {
      expect(FormStackDatabaseManager.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackDatabaseManager.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAddAdapter_014', 0, () => {
      expect(FormStackDatabaseManager.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackDatabaseManager.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackDatabaseManager.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackDatabaseManager.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackDatabaseManager.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackDatabaseManager.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackDatabaseManager.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackDatabaseManager.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAddAdapter_015', 0, () => {
      expect(FormStackDatabaseManager.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackDatabaseManager.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackDatabaseManager.getArraySum([], null) === -1).assertTrue();
      expect(FormStackDatabaseManager.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackDatabaseManager.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackDatabaseManager.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackDatabaseManager.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackDatabaseManager.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackDatabaseManager.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackDatabaseManager.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackDatabaseManager.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackDatabaseManager.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAddAdapter_016', 0, () => {
      expect(FormStackDatabaseManager.isEmpty(null)).assertTrue();
      expect(FormStackDatabaseManager.isEmpty(undefined)).assertTrue();
      expect(FormStackDatabaseManager.isEmpty('')).assertTrue();
      expect(FormStackDatabaseManager.isEmpty(0)).assertTrue();
      expect(FormStackDatabaseManager.isEmpty([])).assertTrue();
      expect(FormStackDatabaseManager.isEmpty(1, null)).assertTrue();
      expect(FormStackDatabaseManager.isEmpty(1, undefined)).assertTrue();
      expect(FormStackDatabaseManager.isEmpty(1, true)).assertTrue();
      expect(FormStackDatabaseManager.isEmpty(1, false)).assertFalse();
    })

    it('FormAddAdapter_017', 0, () => {
      expect(FormStackDatabaseManager.equals(null, 'a')).assertFalse();
      expect(FormStackDatabaseManager.equals(undefined, 'a')).assertFalse();
      expect(FormStackDatabaseManager.equals('a', null)).assertFalse();
      expect(FormStackDatabaseManager.equals('a', undefined)).assertFalse();
      expect(FormStackDatabaseManager.equals('a', 1)).assertFalse();
      expect(FormStackDatabaseManager.equals(1, 'a')).assertFalse();
      expect(FormStackDatabaseManager.equals(1, [])).assertFalse();
      expect(FormStackDatabaseManager.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackDatabaseManager.equals([], m)).assertFalse();
      expect(FormStackDatabaseManager.equals(m, [])).assertFalse();
      expect(FormStackDatabaseManager.equals([1,2], [])).assertFalse();
      expect(FormStackDatabaseManager.equals([], [1, 2])).assertFalse();
      expect(FormStackDatabaseManager.equals([1], [1, 2])).assertFalse();
      expect(FormStackDatabaseManager.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackDatabaseManager.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackDatabaseManager.equals(2, 2)).assertTrue();
    })
  });
}