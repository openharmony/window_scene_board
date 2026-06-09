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
import { FormStackDatabaseUtilPc } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackDatabaseUtilPc';

export function FormAddAdapterTest() {
  describe('FormAddAdapterTest', () => {
    it('FormAddAdapter_001', 0, () => {
      expect(FormStackDatabaseUtilPc.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackDatabaseUtilPc.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackDatabaseUtilPc.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackDatabaseUtilPc.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackDatabaseUtilPc.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackDatabaseUtilPc.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackDatabaseUtilPc.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAddAdapter_002', 0, () => {
      expect(FormStackDatabaseUtilPc.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPc.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPc.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPc.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackDatabaseUtilPc.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackDatabaseUtilPc.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackDatabaseUtilPc.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAddAdapter_003', 0, () => {
      expect(FormStackDatabaseUtilPc.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPc.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPc.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPc.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDatabaseUtilPc.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDatabaseUtilPc.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackDatabaseUtilPc.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAddAdapter_004', 0, () => {
      expect(FormStackDatabaseUtilPc.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPc.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPc.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilPc.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDatabaseUtilPc.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDatabaseUtilPc.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackDatabaseUtilPc.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAddAdapter_005', 0, () => {
      expect(FormStackDatabaseUtilPc.isNumber("")).assertFalse();
      expect(FormStackDatabaseUtilPc.isNumber(null)).assertFalse();
      expect(FormStackDatabaseUtilPc.isNumber(undefined)).assertFalse();
      expect(FormStackDatabaseUtilPc.isNumber("abc")).assertFalse();
      expect(FormStackDatabaseUtilPc.isNumber("123")).assertTrue();
    });

    it('FormAddAdapter_006', 0, () => {
      expect(FormStackDatabaseUtilPc.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackDatabaseUtilPc.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackDatabaseUtilPc.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackDatabaseUtilPc.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackDatabaseUtilPc.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackDatabaseUtilPc.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAddAdapter_007', 0, () => {
      expect(FormStackDatabaseUtilPc.getDefaultId(null) === null).assertTrue();
      expect(FormStackDatabaseUtilPc.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackDatabaseUtilPc.getDefaultId('') === '').assertTrue();
      expect(FormStackDatabaseUtilPc.getDefaultId('default') !== '').assertTrue();
      expect(FormStackDatabaseUtilPc.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackDatabaseUtilPc.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAddAdapter_008', 0, () => {
      expect(FormStackDatabaseUtilPc.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAddAdapter_009', 0, () => {
      expect(FormStackDatabaseUtilPc.drawFontWidth() === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackDatabaseUtilPc.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackDatabaseUtilPc.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackDatabaseUtilPc.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackDatabaseUtilPc.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackDatabaseUtilPc.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackDatabaseUtilPc.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackDatabaseUtilPc.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackDatabaseUtilPc.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackDatabaseUtilPc.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackDatabaseUtilPc.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackDatabaseUtilPc.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackDatabaseUtilPc.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackDatabaseUtilPc.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackDatabaseUtilPc.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackDatabaseUtilPc.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackDatabaseUtilPc.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackDatabaseUtilPc.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackDatabaseUtilPc.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackDatabaseUtilPc.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackDatabaseUtilPc.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAddAdapter_010', 0, () => {
      expect(FormStackDatabaseUtilPc.drawTextAlign() === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackDatabaseUtilPc.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackDatabaseUtilPc.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackDatabaseUtilPc.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackDatabaseUtilPc.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackDatabaseUtilPc.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackDatabaseUtilPc.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAddAdapter_011', 0, () => {
      expect(FormStackDatabaseUtilPc.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAddAdapter_012', 0, () => {
      expect(FormStackDatabaseUtilPc.checkArr([]) === false).assertTrue();
      expect(FormStackDatabaseUtilPc.checkArr(null) === false).assertTrue();
      expect(FormStackDatabaseUtilPc.checkArr(undefined) === false).assertTrue();
      expect(FormStackDatabaseUtilPc.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackDatabaseUtilPc.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackDatabaseUtilPc.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackDatabaseUtilPc.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackDatabaseUtilPc.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackDatabaseUtilPc.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackDatabaseUtilPc.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackDatabaseUtilPc.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackDatabaseUtilPc.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackDatabaseUtilPc.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackDatabaseUtilPc.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackDatabaseUtilPc.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackDatabaseUtilPc.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackDatabaseUtilPc.getUUID().length > 0).assertTrue();
    })

    it('FormAddAdapter_013', 0, () => {
      expect(FormStackDatabaseUtilPc.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackDatabaseUtilPc.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAddAdapter_014', 0, () => {
      expect(FormStackDatabaseUtilPc.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackDatabaseUtilPc.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackDatabaseUtilPc.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackDatabaseUtilPc.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackDatabaseUtilPc.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackDatabaseUtilPc.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackDatabaseUtilPc.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackDatabaseUtilPc.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAddAdapter_015', 0, () => {
      expect(FormStackDatabaseUtilPc.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getArraySum([], null) === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackDatabaseUtilPc.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAddAdapter_016', 0, () => {
      expect(FormStackDatabaseUtilPc.isEmpty(null)).assertTrue();
      expect(FormStackDatabaseUtilPc.isEmpty(undefined)).assertTrue();
      expect(FormStackDatabaseUtilPc.isEmpty('')).assertTrue();
      expect(FormStackDatabaseUtilPc.isEmpty(0)).assertTrue();
      expect(FormStackDatabaseUtilPc.isEmpty([])).assertTrue();
      expect(FormStackDatabaseUtilPc.isEmpty(1, null)).assertTrue();
      expect(FormStackDatabaseUtilPc.isEmpty(1, undefined)).assertTrue();
      expect(FormStackDatabaseUtilPc.isEmpty(1, true)).assertTrue();
      expect(FormStackDatabaseUtilPc.isEmpty(1, false)).assertFalse();
    })

    it('FormAddAdapter_017', 0, () => {
      expect(FormStackDatabaseUtilPc.equals(null, 'a')).assertFalse();
      expect(FormStackDatabaseUtilPc.equals(undefined, 'a')).assertFalse();
      expect(FormStackDatabaseUtilPc.equals('a', null)).assertFalse();
      expect(FormStackDatabaseUtilPc.equals('a', undefined)).assertFalse();
      expect(FormStackDatabaseUtilPc.equals('a', 1)).assertFalse();
      expect(FormStackDatabaseUtilPc.equals(1, 'a')).assertFalse();
      expect(FormStackDatabaseUtilPc.equals(1, [])).assertFalse();
      expect(FormStackDatabaseUtilPc.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackDatabaseUtilPc.equals([], m)).assertFalse();
      expect(FormStackDatabaseUtilPc.equals(m, [])).assertFalse();
      expect(FormStackDatabaseUtilPc.equals([1,2], [])).assertFalse();
      expect(FormStackDatabaseUtilPc.equals([], [1, 2])).assertFalse();
      expect(FormStackDatabaseUtilPc.equals([1], [1, 2])).assertFalse();
      expect(FormStackDatabaseUtilPc.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackDatabaseUtilPc.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackDatabaseUtilPc.equals(2, 2)).assertTrue();
    })
  });
}