/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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
import { FormDatabaseAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormDatabaseAdapter';

export function FormAddAdapterTest() {
  describe('FormAddAdapterTest', () => {
    it('FormAddAdapter_001', 0, () => {
      expect(FormDatabaseAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormDatabaseAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormDatabaseAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormDatabaseAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormDatabaseAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormDatabaseAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormDatabaseAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAddAdapter_002', 0, () => {
      expect(FormDatabaseAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormDatabaseAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormDatabaseAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormDatabaseAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormDatabaseAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormDatabaseAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormDatabaseAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAddAdapter_003', 0, () => {
      expect(FormDatabaseAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormDatabaseAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormDatabaseAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormDatabaseAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormDatabaseAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormDatabaseAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormDatabaseAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAddAdapter_004', 0, () => {
      expect(FormDatabaseAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormDatabaseAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormDatabaseAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormDatabaseAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormDatabaseAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormDatabaseAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormDatabaseAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAddAdapter_005', 0, () => {
      expect(FormDatabaseAdapter.isNumber("")).assertFalse();
      expect(FormDatabaseAdapter.isNumber(null)).assertFalse();
      expect(FormDatabaseAdapter.isNumber(undefined)).assertFalse();
      expect(FormDatabaseAdapter.isNumber("abc")).assertFalse();
      expect(FormDatabaseAdapter.isNumber("123")).assertTrue();
    });

    it('FormAddAdapter_006', 0, () => {
      expect(FormDatabaseAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormDatabaseAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormDatabaseAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormDatabaseAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormDatabaseAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormDatabaseAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAddAdapter_007', 0, () => {
      expect(FormDatabaseAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormDatabaseAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormDatabaseAdapter.getDefaultId('') === '').assertTrue();
      expect(FormDatabaseAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormDatabaseAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormDatabaseAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAddAdapter_008', 0, () => {
      expect(FormDatabaseAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormDatabaseAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormDatabaseAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormDatabaseAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormDatabaseAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormDatabaseAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormDatabaseAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAddAdapter_009', 0, () => {
      expect(FormDatabaseAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormDatabaseAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormDatabaseAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormDatabaseAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormDatabaseAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormDatabaseAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormDatabaseAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormDatabaseAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormDatabaseAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormDatabaseAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormDatabaseAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormDatabaseAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormDatabaseAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormDatabaseAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormDatabaseAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormDatabaseAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormDatabaseAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormDatabaseAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormDatabaseAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormDatabaseAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormDatabaseAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormDatabaseAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAddAdapter_010', 0, () => {
      expect(FormDatabaseAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormDatabaseAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormDatabaseAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormDatabaseAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormDatabaseAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormDatabaseAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormDatabaseAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormDatabaseAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAddAdapter_011', 0, () => {
      expect(FormDatabaseAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormDatabaseAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormDatabaseAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormDatabaseAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormDatabaseAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormDatabaseAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormDatabaseAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormDatabaseAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormDatabaseAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormDatabaseAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormDatabaseAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormDatabaseAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormDatabaseAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormDatabaseAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormDatabaseAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormDatabaseAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormDatabaseAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormDatabaseAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormDatabaseAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAddAdapter_012', 0, () => {
      expect(FormDatabaseAdapter.checkArr([]) === false).assertTrue();
      expect(FormDatabaseAdapter.checkArr(null) === false).assertTrue();
      expect(FormDatabaseAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormDatabaseAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormDatabaseAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormDatabaseAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormDatabaseAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormDatabaseAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormDatabaseAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormDatabaseAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormDatabaseAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormDatabaseAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormDatabaseAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormDatabaseAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormDatabaseAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormDatabaseAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormDatabaseAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormAddAdapter_013', 0, () => {
      expect(FormDatabaseAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormDatabaseAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAddAdapter_014', 0, () => {
      expect(FormDatabaseAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormDatabaseAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormDatabaseAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormDatabaseAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormDatabaseAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormDatabaseAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormDatabaseAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormDatabaseAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAddAdapter_015', 0, () => {
      expect(FormDatabaseAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormDatabaseAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormDatabaseAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormDatabaseAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormDatabaseAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormDatabaseAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormDatabaseAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormDatabaseAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormDatabaseAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormDatabaseAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormDatabaseAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormDatabaseAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAddAdapter_016', 0, () => {
      expect(FormDatabaseAdapter.isEmpty(null)).assertTrue();
      expect(FormDatabaseAdapter.isEmpty(undefined)).assertTrue();
      expect(FormDatabaseAdapter.isEmpty('')).assertTrue();
      expect(FormDatabaseAdapter.isEmpty(0)).assertTrue();
      expect(FormDatabaseAdapter.isEmpty([])).assertTrue();
      expect(FormDatabaseAdapter.isEmpty(1, null)).assertTrue();
      expect(FormDatabaseAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormDatabaseAdapter.isEmpty(1, true)).assertTrue();
      expect(FormDatabaseAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormAddAdapter_017', 0, () => {
      expect(FormDatabaseAdapter.equals(null, 'a')).assertFalse();
      expect(FormDatabaseAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormDatabaseAdapter.equals('a', null)).assertFalse();
      expect(FormDatabaseAdapter.equals('a', undefined)).assertFalse();
      expect(FormDatabaseAdapter.equals('a', 1)).assertFalse();
      expect(FormDatabaseAdapter.equals(1, 'a')).assertFalse();
      expect(FormDatabaseAdapter.equals(1, [])).assertFalse();
      expect(FormDatabaseAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormDatabaseAdapter.equals([], m)).assertFalse();
      expect(FormDatabaseAdapter.equals(m, [])).assertFalse();
      expect(FormDatabaseAdapter.equals([1,2], [])).assertFalse();
      expect(FormDatabaseAdapter.equals([], [1, 2])).assertFalse();
      expect(FormDatabaseAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormDatabaseAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormDatabaseAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormDatabaseAdapter.equals(2, 2)).assertTrue();
    })
  });
}