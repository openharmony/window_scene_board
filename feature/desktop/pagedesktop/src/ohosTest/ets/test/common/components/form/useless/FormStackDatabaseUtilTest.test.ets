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
import { FormStackDatabaseUtilAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackDatabaseUtilAdapter';

export function FormAddAdapterTest() {
  describe('FormAddAdapterTest', () => {
    it('FormAddAdapter_001', 0, () => {
      expect(FormStackDatabaseUtilAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackDatabaseUtilAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackDatabaseUtilAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackDatabaseUtilAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackDatabaseUtilAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackDatabaseUtilAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackDatabaseUtilAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAddAdapter_002', 0, () => {
      expect(FormStackDatabaseUtilAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackDatabaseUtilAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackDatabaseUtilAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackDatabaseUtilAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAddAdapter_003', 0, () => {
      expect(FormStackDatabaseUtilAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAddAdapter_004', 0, () => {
      expect(FormStackDatabaseUtilAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAddAdapter_005', 0, () => {
      expect(FormStackDatabaseUtilAdapter.isNumber("")).assertFalse();
      expect(FormStackDatabaseUtilAdapter.isNumber(null)).assertFalse();
      expect(FormStackDatabaseUtilAdapter.isNumber(undefined)).assertFalse();
      expect(FormStackDatabaseUtilAdapter.isNumber("abc")).assertFalse();
      expect(FormStackDatabaseUtilAdapter.isNumber("123")).assertTrue();
    });

    it('FormAddAdapter_006', 0, () => {
      expect(FormStackDatabaseUtilAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackDatabaseUtilAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackDatabaseUtilAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackDatabaseUtilAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackDatabaseUtilAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackDatabaseUtilAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAddAdapter_007', 0, () => {
      expect(FormStackDatabaseUtilAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getDefaultId('') === '').assertTrue();
      expect(FormStackDatabaseUtilAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormStackDatabaseUtilAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackDatabaseUtilAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAddAdapter_008', 0, () => {
      expect(FormStackDatabaseUtilAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAddAdapter_009', 0, () => {
      expect(FormStackDatabaseUtilAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAddAdapter_010', 0, () => {
      expect(FormStackDatabaseUtilAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackDatabaseUtilAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAddAdapter_011', 0, () => {
      expect(FormStackDatabaseUtilAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAddAdapter_012', 0, () => {
      expect(FormStackDatabaseUtilAdapter.checkArr([]) === false).assertTrue();
      expect(FormStackDatabaseUtilAdapter.checkArr(null) === false).assertTrue();
      expect(FormStackDatabaseUtilAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormStackDatabaseUtilAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackDatabaseUtilAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackDatabaseUtilAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackDatabaseUtilAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackDatabaseUtilAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackDatabaseUtilAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackDatabaseUtilAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackDatabaseUtilAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackDatabaseUtilAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackDatabaseUtilAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackDatabaseUtilAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackDatabaseUtilAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackDatabaseUtilAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormAddAdapter_013', 0, () => {
      expect(FormStackDatabaseUtilAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAddAdapter_014', 0, () => {
      expect(FormStackDatabaseUtilAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackDatabaseUtilAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackDatabaseUtilAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackDatabaseUtilAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackDatabaseUtilAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackDatabaseUtilAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackDatabaseUtilAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackDatabaseUtilAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAddAdapter_015', 0, () => {
      expect(FormStackDatabaseUtilAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackDatabaseUtilAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAddAdapter_016', 0, () => {
      expect(FormStackDatabaseUtilAdapter.isEmpty(null)).assertTrue();
      expect(FormStackDatabaseUtilAdapter.isEmpty(undefined)).assertTrue();
      expect(FormStackDatabaseUtilAdapter.isEmpty('')).assertTrue();
      expect(FormStackDatabaseUtilAdapter.isEmpty(0)).assertTrue();
      expect(FormStackDatabaseUtilAdapter.isEmpty([])).assertTrue();
      expect(FormStackDatabaseUtilAdapter.isEmpty(1, null)).assertTrue();
      expect(FormStackDatabaseUtilAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormStackDatabaseUtilAdapter.isEmpty(1, true)).assertTrue();
      expect(FormStackDatabaseUtilAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormAddAdapter_017', 0, () => {
      expect(FormStackDatabaseUtilAdapter.equals(null, 'a')).assertFalse();
      expect(FormStackDatabaseUtilAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormStackDatabaseUtilAdapter.equals('a', null)).assertFalse();
      expect(FormStackDatabaseUtilAdapter.equals('a', undefined)).assertFalse();
      expect(FormStackDatabaseUtilAdapter.equals('a', 1)).assertFalse();
      expect(FormStackDatabaseUtilAdapter.equals(1, 'a')).assertFalse();
      expect(FormStackDatabaseUtilAdapter.equals(1, [])).assertFalse();
      expect(FormStackDatabaseUtilAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackDatabaseUtilAdapter.equals([], m)).assertFalse();
      expect(FormStackDatabaseUtilAdapter.equals(m, [])).assertFalse();
      expect(FormStackDatabaseUtilAdapter.equals([1,2], [])).assertFalse();
      expect(FormStackDatabaseUtilAdapter.equals([], [1, 2])).assertFalse();
      expect(FormStackDatabaseUtilAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormStackDatabaseUtilAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackDatabaseUtilAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackDatabaseUtilAdapter.equals(2, 2)).assertTrue();
    })
  });
}