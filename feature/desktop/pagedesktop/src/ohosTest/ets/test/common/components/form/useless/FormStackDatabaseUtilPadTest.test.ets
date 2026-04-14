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
import { FormStackDatabaseUtilPad } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackDatabaseUtilPad';

export function FormAddAdapterTest() {
  describe('FormAddAdapterTest', () => {
    it('FormAddAdapter_001', 0, () => {
      expect(FormStackDatabaseUtilPad.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackDatabaseUtilPad.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackDatabaseUtilPad.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackDatabaseUtilPad.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackDatabaseUtilPad.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackDatabaseUtilPad.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackDatabaseUtilPad.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAddAdapter_002', 0, () => {
      expect(FormStackDatabaseUtilPad.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPad.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPad.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPad.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackDatabaseUtilPad.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackDatabaseUtilPad.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackDatabaseUtilPad.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAddAdapter_003', 0, () => {
      expect(FormStackDatabaseUtilPad.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPad.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPad.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPad.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDatabaseUtilPad.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDatabaseUtilPad.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackDatabaseUtilPad.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAddAdapter_004', 0, () => {
      expect(FormStackDatabaseUtilPad.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPad.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPad.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPad.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDatabaseUtilPad.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDatabaseUtilPad.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackDatabaseUtilPad.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAddAdapter_005', 0, () => {
      expect(FormStackDatabaseUtilPad.isNumber("")).assertFalse();
      expect(FormStackDatabaseUtilPad.isNumber(null)).assertFalse();
      expect(FormStackDatabaseUtilPad.isNumber(undefined)).assertFalse();
      expect(FormStackDatabaseUtilPad.isNumber("abc")).assertFalse();
      expect(FormStackDatabaseUtilPad.isNumber("123")).assertTrue();
    });

    it('FormAddAdapter_006', 0, () => {
      expect(FormStackDatabaseUtilPad.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackDatabaseUtilPad.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackDatabaseUtilPad.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackDatabaseUtilPad.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackDatabaseUtilPad.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackDatabaseUtilPad.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAddAdapter_007', 0, () => {
      expect(FormStackDatabaseUtilPad.getDefaultId(null) === null).assertTrue();
      expect(FormStackDatabaseUtilPad.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackDatabaseUtilPad.getDefaultId('') === '').assertTrue();
      expect(FormStackDatabaseUtilPad.getDefaultId('default') !== '').assertTrue();
      expect(FormStackDatabaseUtilPad.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackDatabaseUtilPad.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAddAdapter_008', 0, () => {
      expect(FormStackDatabaseUtilPad.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAddAdapter_009', 0, () => {
      expect(FormStackDatabaseUtilPad.drawFontWidth() === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackDatabaseUtilPad.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackDatabaseUtilPad.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackDatabaseUtilPad.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackDatabaseUtilPad.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackDatabaseUtilPad.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackDatabaseUtilPad.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackDatabaseUtilPad.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackDatabaseUtilPad.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackDatabaseUtilPad.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackDatabaseUtilPad.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackDatabaseUtilPad.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackDatabaseUtilPad.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackDatabaseUtilPad.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackDatabaseUtilPad.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackDatabaseUtilPad.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackDatabaseUtilPad.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackDatabaseUtilPad.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackDatabaseUtilPad.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackDatabaseUtilPad.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackDatabaseUtilPad.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAddAdapter_010', 0, () => {
      expect(FormStackDatabaseUtilPad.drawTextAlign() === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackDatabaseUtilPad.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackDatabaseUtilPad.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackDatabaseUtilPad.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackDatabaseUtilPad.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackDatabaseUtilPad.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackDatabaseUtilPad.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAddAdapter_011', 0, () => {
      expect(FormStackDatabaseUtilPad.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAddAdapter_012', 0, () => {
      expect(FormStackDatabaseUtilPad.checkArr([]) === false).assertTrue();
      expect(FormStackDatabaseUtilPad.checkArr(null) === false).assertTrue();
      expect(FormStackDatabaseUtilPad.checkArr(undefined) === false).assertTrue();
      expect(FormStackDatabaseUtilPad.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackDatabaseUtilPad.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackDatabaseUtilPad.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackDatabaseUtilPad.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackDatabaseUtilPad.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackDatabaseUtilPad.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackDatabaseUtilPad.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackDatabaseUtilPad.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackDatabaseUtilPad.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackDatabaseUtilPad.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackDatabaseUtilPad.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackDatabaseUtilPad.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackDatabaseUtilPad.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackDatabaseUtilPad.getUUID().length > 0).assertTrue();
    })

    it('FormAddAdapter_013', 0, () => {
      expect(FormStackDatabaseUtilPad.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackDatabaseUtilPad.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAddAdapter_014', 0, () => {
      expect(FormStackDatabaseUtilPad.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackDatabaseUtilPad.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackDatabaseUtilPad.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackDatabaseUtilPad.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackDatabaseUtilPad.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackDatabaseUtilPad.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackDatabaseUtilPad.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackDatabaseUtilPad.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAddAdapter_015', 0, () => {
      expect(FormStackDatabaseUtilPad.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getArraySum([], null) === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackDatabaseUtilPad.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAddAdapter_016', 0, () => {
      expect(FormStackDatabaseUtilPad.isEmpty(null)).assertTrue();
      expect(FormStackDatabaseUtilPad.isEmpty(undefined)).assertTrue();
      expect(FormStackDatabaseUtilPad.isEmpty('')).assertTrue();
      expect(FormStackDatabaseUtilPad.isEmpty(0)).assertTrue();
      expect(FormStackDatabaseUtilPad.isEmpty([])).assertTrue();
      expect(FormStackDatabaseUtilPad.isEmpty(1, null)).assertTrue();
      expect(FormStackDatabaseUtilPad.isEmpty(1, undefined)).assertTrue();
      expect(FormStackDatabaseUtilPad.isEmpty(1, true)).assertTrue();
      expect(FormStackDatabaseUtilPad.isEmpty(1, false)).assertFalse();
    })

    it('FormAddAdapter_017', 0, () => {
      expect(FormStackDatabaseUtilPad.equals(null, 'a')).assertFalse();
      expect(FormStackDatabaseUtilPad.equals(undefined, 'a')).assertFalse();
      expect(FormStackDatabaseUtilPad.equals('a', null)).assertFalse();
      expect(FormStackDatabaseUtilPad.equals('a', undefined)).assertFalse();
      expect(FormStackDatabaseUtilPad.equals('a', 1)).assertFalse();
      expect(FormStackDatabaseUtilPad.equals(1, 'a')).assertFalse();
      expect(FormStackDatabaseUtilPad.equals(1, [])).assertFalse();
      expect(FormStackDatabaseUtilPad.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackDatabaseUtilPad.equals([], m)).assertFalse();
      expect(FormStackDatabaseUtilPad.equals(m, [])).assertFalse();
      expect(FormStackDatabaseUtilPad.equals([1,2], [])).assertFalse();
      expect(FormStackDatabaseUtilPad.equals([], [1, 2])).assertFalse();
      expect(FormStackDatabaseUtilPad.equals([1], [1, 2])).assertFalse();
      expect(FormStackDatabaseUtilPad.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackDatabaseUtilPad.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackDatabaseUtilPad.equals(2, 2)).assertTrue();
    })
  });
}