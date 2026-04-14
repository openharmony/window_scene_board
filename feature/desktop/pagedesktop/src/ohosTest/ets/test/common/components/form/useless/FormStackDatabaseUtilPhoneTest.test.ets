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
import { FormStackDatabaseUtilPhone } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackDatabaseUtilPhone';

export function FormAddAdapterTest() {
  describe('FormAddAdapterTest', () => {
    it('FormAddAdapter_001', 0, () => {
      expect(FormStackDatabaseUtilPhone.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackDatabaseUtilPhone.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackDatabaseUtilPhone.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackDatabaseUtilPhone.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackDatabaseUtilPhone.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackDatabaseUtilPhone.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackDatabaseUtilPhone.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAddAdapter_002', 0, () => {
      expect(FormStackDatabaseUtilPhone.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPhone.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPhone.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPhone.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackDatabaseUtilPhone.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackDatabaseUtilPhone.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackDatabaseUtilPhone.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAddAdapter_003', 0, () => {
      expect(FormStackDatabaseUtilPhone.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPhone.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPhone.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPhone.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDatabaseUtilPhone.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDatabaseUtilPhone.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackDatabaseUtilPhone.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAddAdapter_004', 0, () => {
      expect(FormStackDatabaseUtilPhone.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPhone.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPhone.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPhone.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDatabaseUtilPhone.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDatabaseUtilPhone.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackDatabaseUtilPhone.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAddAdapter_005', 0, () => {
      expect(FormStackDatabaseUtilPhone.isNumber("")).assertFalse();
      expect(FormStackDatabaseUtilPhone.isNumber(null)).assertFalse();
      expect(FormStackDatabaseUtilPhone.isNumber(undefined)).assertFalse();
      expect(FormStackDatabaseUtilPhone.isNumber("abc")).assertFalse();
      expect(FormStackDatabaseUtilPhone.isNumber("123")).assertTrue();
    });

    it('FormAddAdapter_006', 0, () => {
      expect(FormStackDatabaseUtilPhone.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackDatabaseUtilPhone.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackDatabaseUtilPhone.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackDatabaseUtilPhone.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackDatabaseUtilPhone.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackDatabaseUtilPhone.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAddAdapter_007', 0, () => {
      expect(FormStackDatabaseUtilPhone.getDefaultId(null) === null).assertTrue();
      expect(FormStackDatabaseUtilPhone.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackDatabaseUtilPhone.getDefaultId('') === '').assertTrue();
      expect(FormStackDatabaseUtilPhone.getDefaultId('default') !== '').assertTrue();
      expect(FormStackDatabaseUtilPhone.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackDatabaseUtilPhone.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAddAdapter_008', 0, () => {
      expect(FormStackDatabaseUtilPhone.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAddAdapter_009', 0, () => {
      expect(FormStackDatabaseUtilPhone.drawFontWidth() === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAddAdapter_010', 0, () => {
      expect(FormStackDatabaseUtilPhone.drawTextAlign() === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackDatabaseUtilPhone.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAddAdapter_011', 0, () => {
      expect(FormStackDatabaseUtilPhone.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAddAdapter_012', 0, () => {
      expect(FormStackDatabaseUtilPhone.checkArr([]) === false).assertTrue();
      expect(FormStackDatabaseUtilPhone.checkArr(null) === false).assertTrue();
      expect(FormStackDatabaseUtilPhone.checkArr(undefined) === false).assertTrue();
      expect(FormStackDatabaseUtilPhone.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackDatabaseUtilPhone.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackDatabaseUtilPhone.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackDatabaseUtilPhone.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackDatabaseUtilPhone.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackDatabaseUtilPhone.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackDatabaseUtilPhone.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackDatabaseUtilPhone.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackDatabaseUtilPhone.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackDatabaseUtilPhone.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackDatabaseUtilPhone.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackDatabaseUtilPhone.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackDatabaseUtilPhone.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackDatabaseUtilPhone.getUUID().length > 0).assertTrue();
    })

    it('FormAddAdapter_013', 0, () => {
      expect(FormStackDatabaseUtilPhone.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackDatabaseUtilPhone.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAddAdapter_014', 0, () => {
      expect(FormStackDatabaseUtilPhone.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackDatabaseUtilPhone.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackDatabaseUtilPhone.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackDatabaseUtilPhone.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackDatabaseUtilPhone.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackDatabaseUtilPhone.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackDatabaseUtilPhone.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackDatabaseUtilPhone.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAddAdapter_015', 0, () => {
      expect(FormStackDatabaseUtilPhone.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getArraySum([], null) === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackDatabaseUtilPhone.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAddAdapter_016', 0, () => {
      expect(FormStackDatabaseUtilPhone.isEmpty(null)).assertTrue();
      expect(FormStackDatabaseUtilPhone.isEmpty(undefined)).assertTrue();
      expect(FormStackDatabaseUtilPhone.isEmpty('')).assertTrue();
      expect(FormStackDatabaseUtilPhone.isEmpty(0)).assertTrue();
      expect(FormStackDatabaseUtilPhone.isEmpty([])).assertTrue();
      expect(FormStackDatabaseUtilPhone.isEmpty(1, null)).assertTrue();
      expect(FormStackDatabaseUtilPhone.isEmpty(1, undefined)).assertTrue();
      expect(FormStackDatabaseUtilPhone.isEmpty(1, true)).assertTrue();
      expect(FormStackDatabaseUtilPhone.isEmpty(1, false)).assertFalse();
    })

    it('FormAddAdapter_017', 0, () => {
      expect(FormStackDatabaseUtilPhone.equals(null, 'a')).assertFalse();
      expect(FormStackDatabaseUtilPhone.equals(undefined, 'a')).assertFalse();
      expect(FormStackDatabaseUtilPhone.equals('a', null)).assertFalse();
      expect(FormStackDatabaseUtilPhone.equals('a', undefined)).assertFalse();
      expect(FormStackDatabaseUtilPhone.equals('a', 1)).assertFalse();
      expect(FormStackDatabaseUtilPhone.equals(1, 'a')).assertFalse();
      expect(FormStackDatabaseUtilPhone.equals(1, [])).assertFalse();
      expect(FormStackDatabaseUtilPhone.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackDatabaseUtilPhone.equals([], m)).assertFalse();
      expect(FormStackDatabaseUtilPhone.equals(m, [])).assertFalse();
      expect(FormStackDatabaseUtilPhone.equals([1,2], [])).assertFalse();
      expect(FormStackDatabaseUtilPhone.equals([], [1, 2])).assertFalse();
      expect(FormStackDatabaseUtilPhone.equals([1], [1, 2])).assertFalse();
      expect(FormStackDatabaseUtilPhone.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackDatabaseUtilPhone.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackDatabaseUtilPhone.equals(2, 2)).assertTrue();
    })
  });
}