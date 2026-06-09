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
import { FormStackDatabaseUtilTv } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackDatabaseUtilTv';

export function FormAddAdapterTest() {
  describe('FormAddAdapterTest', () => {
    it('FormAddAdapter_001', 0, () => {
      expect(FormStackDatabaseUtilTv.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackDatabaseUtilTv.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackDatabaseUtilTv.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackDatabaseUtilTv.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackDatabaseUtilTv.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackDatabaseUtilTv.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackDatabaseUtilTv.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAddAdapter_002', 0, () => {
      expect(FormStackDatabaseUtilTv.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilTv.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilTv.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilTv.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackDatabaseUtilTv.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackDatabaseUtilTv.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackDatabaseUtilTv.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAddAdapter_003', 0, () => {
      expect(FormStackDatabaseUtilTv.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilTv.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilTv.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilTv.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDatabaseUtilTv.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDatabaseUtilTv.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackDatabaseUtilTv.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAddAdapter_004', 0, () => {
      expect(FormStackDatabaseUtilTv.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilTv.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilTv.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDatabaseUtilTv.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDatabaseUtilTv.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDatabaseUtilTv.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackDatabaseUtilTv.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAddAdapter_005', 0, () => {
      expect(FormStackDatabaseUtilTv.isNumber("")).assertFalse();
      expect(FormStackDatabaseUtilTv.isNumber(null)).assertFalse();
      expect(FormStackDatabaseUtilTv.isNumber(undefined)).assertFalse();
      expect(FormStackDatabaseUtilTv.isNumber("abc")).assertFalse();
      expect(FormStackDatabaseUtilTv.isNumber("123")).assertTrue();
    });

    it('FormAddAdapter_006', 0, () => {
      expect(FormStackDatabaseUtilTv.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackDatabaseUtilTv.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackDatabaseUtilTv.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackDatabaseUtilTv.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackDatabaseUtilTv.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackDatabaseUtilTv.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAddAdapter_007', 0, () => {
      expect(FormStackDatabaseUtilTv.getDefaultId(null) === null).assertTrue();
      expect(FormStackDatabaseUtilTv.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackDatabaseUtilTv.getDefaultId('') === '').assertTrue();
      expect(FormStackDatabaseUtilTv.getDefaultId('default') !== '').assertTrue();
      expect(FormStackDatabaseUtilTv.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackDatabaseUtilTv.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAddAdapter_008', 0, () => {
      expect(FormStackDatabaseUtilTv.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAddAdapter_009', 0, () => {
      expect(FormStackDatabaseUtilTv.drawFontWidth() === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackDatabaseUtilTv.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackDatabaseUtilTv.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackDatabaseUtilTv.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackDatabaseUtilTv.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackDatabaseUtilTv.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackDatabaseUtilTv.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackDatabaseUtilTv.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackDatabaseUtilTv.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackDatabaseUtilTv.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackDatabaseUtilTv.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackDatabaseUtilTv.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackDatabaseUtilTv.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackDatabaseUtilTv.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackDatabaseUtilTv.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackDatabaseUtilTv.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackDatabaseUtilTv.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackDatabaseUtilTv.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackDatabaseUtilTv.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackDatabaseUtilTv.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackDatabaseUtilTv.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAddAdapter_010', 0, () => {
      expect(FormStackDatabaseUtilTv.drawTextAlign() === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackDatabaseUtilTv.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackDatabaseUtilTv.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackDatabaseUtilTv.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackDatabaseUtilTv.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackDatabaseUtilTv.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackDatabaseUtilTv.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAddAdapter_011', 0, () => {
      expect(FormStackDatabaseUtilTv.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAddAdapter_012', 0, () => {
      expect(FormStackDatabaseUtilTv.checkArr([]) === false).assertTrue();
      expect(FormStackDatabaseUtilTv.checkArr(null) === false).assertTrue();
      expect(FormStackDatabaseUtilTv.checkArr(undefined) === false).assertTrue();
      expect(FormStackDatabaseUtilTv.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackDatabaseUtilTv.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackDatabaseUtilTv.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackDatabaseUtilTv.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackDatabaseUtilTv.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackDatabaseUtilTv.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackDatabaseUtilTv.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackDatabaseUtilTv.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackDatabaseUtilTv.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackDatabaseUtilTv.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackDatabaseUtilTv.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackDatabaseUtilTv.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackDatabaseUtilTv.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackDatabaseUtilTv.getUUID().length > 0).assertTrue();
    })

    it('FormAddAdapter_013', 0, () => {
      expect(FormStackDatabaseUtilTv.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackDatabaseUtilTv.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAddAdapter_014', 0, () => {
      expect(FormStackDatabaseUtilTv.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackDatabaseUtilTv.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackDatabaseUtilTv.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackDatabaseUtilTv.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackDatabaseUtilTv.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackDatabaseUtilTv.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackDatabaseUtilTv.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackDatabaseUtilTv.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAddAdapter_015', 0, () => {
      expect(FormStackDatabaseUtilTv.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getArraySum([], null) === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackDatabaseUtilTv.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAddAdapter_016', 0, () => {
      expect(FormStackDatabaseUtilTv.isEmpty(null)).assertTrue();
      expect(FormStackDatabaseUtilTv.isEmpty(undefined)).assertTrue();
      expect(FormStackDatabaseUtilTv.isEmpty('')).assertTrue();
      expect(FormStackDatabaseUtilTv.isEmpty(0)).assertTrue();
      expect(FormStackDatabaseUtilTv.isEmpty([])).assertTrue();
      expect(FormStackDatabaseUtilTv.isEmpty(1, null)).assertTrue();
      expect(FormStackDatabaseUtilTv.isEmpty(1, undefined)).assertTrue();
      expect(FormStackDatabaseUtilTv.isEmpty(1, true)).assertTrue();
      expect(FormStackDatabaseUtilTv.isEmpty(1, false)).assertFalse();
    })

    it('FormAddAdapter_017', 0, () => {
      expect(FormStackDatabaseUtilTv.equals(null, 'a')).assertFalse();
      expect(FormStackDatabaseUtilTv.equals(undefined, 'a')).assertFalse();
      expect(FormStackDatabaseUtilTv.equals('a', null)).assertFalse();
      expect(FormStackDatabaseUtilTv.equals('a', undefined)).assertFalse();
      expect(FormStackDatabaseUtilTv.equals('a', 1)).assertFalse();
      expect(FormStackDatabaseUtilTv.equals(1, 'a')).assertFalse();
      expect(FormStackDatabaseUtilTv.equals(1, [])).assertFalse();
      expect(FormStackDatabaseUtilTv.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackDatabaseUtilTv.equals([], m)).assertFalse();
      expect(FormStackDatabaseUtilTv.equals(m, [])).assertFalse();
      expect(FormStackDatabaseUtilTv.equals([1,2], [])).assertFalse();
      expect(FormStackDatabaseUtilTv.equals([], [1, 2])).assertFalse();
      expect(FormStackDatabaseUtilTv.equals([1], [1, 2])).assertFalse();
      expect(FormStackDatabaseUtilTv.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackDatabaseUtilTv.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackDatabaseUtilTv.equals(2, 2)).assertTrue();
    })
  });
}