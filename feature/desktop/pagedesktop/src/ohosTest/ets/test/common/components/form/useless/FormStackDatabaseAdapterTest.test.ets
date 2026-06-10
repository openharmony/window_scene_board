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
import { FormStackDatabaseAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackDatabaseAdapter';

export function FormStackDatabaseAdapterTest() {
  describe('FormStackDatabaseAdapterTest', () => {
    it('FormStackDatabaseAdapter_001', 0, () => {
      expect(FormStackDatabaseAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackDatabaseAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackDatabaseAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackDatabaseAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackDatabaseAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackDatabaseAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackDatabaseAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackDatabaseAdapter_002', 0, () => {
      expect(FormStackDatabaseAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackDatabaseAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackDatabaseAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackDatabaseAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackDatabaseAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackDatabaseAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackDatabaseAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackDatabaseAdapter_003', 0, () => {
      expect(FormStackDatabaseAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackDatabaseAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackDatabaseAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDatabaseAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDatabaseAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDatabaseAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackDatabaseAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackDatabaseAdapter_004', 0, () => {
      expect(FormStackDatabaseAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackDatabaseAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackDatabaseAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDatabaseAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDatabaseAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDatabaseAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackDatabaseAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackDatabaseAdapter_005', 0, () => {
      expect(FormStackDatabaseAdapter.isNumber("")).assertFalse();
      expect(FormStackDatabaseAdapter.isNumber(null)).assertFalse();
      expect(FormStackDatabaseAdapter.isNumber(undefined)).assertFalse();
      expect(FormStackDatabaseAdapter.isNumber("abc")).assertFalse();
      expect(FormStackDatabaseAdapter.isNumber("123")).assertTrue();
    });

    it('FormStackDatabaseAdapter_006', 0, () => {
      expect(FormStackDatabaseAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackDatabaseAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackDatabaseAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackDatabaseAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackDatabaseAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackDatabaseAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackDatabaseAdapter_007', 0, () => {
      expect(FormStackDatabaseAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormStackDatabaseAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackDatabaseAdapter.getDefaultId('') === '').assertTrue();
      expect(FormStackDatabaseAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormStackDatabaseAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackDatabaseAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackDatabaseAdapter_008', 0, () => {
      expect(FormStackDatabaseAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackDatabaseAdapter_009', 0, () => {
      expect(FormStackDatabaseAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormStackDatabaseAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackDatabaseAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackDatabaseAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackDatabaseAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackDatabaseAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackDatabaseAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackDatabaseAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackDatabaseAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackDatabaseAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackDatabaseAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackDatabaseAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackDatabaseAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackDatabaseAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackDatabaseAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackDatabaseAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackDatabaseAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackDatabaseAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackDatabaseAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackDatabaseAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackDatabaseAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackDatabaseAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackDatabaseAdapter_010', 0, () => {
      expect(FormStackDatabaseAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormStackDatabaseAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackDatabaseAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackDatabaseAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackDatabaseAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackDatabaseAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackDatabaseAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackDatabaseAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackDatabaseAdapter_011', 0, () => {
      expect(FormStackDatabaseAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackDatabaseAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackDatabaseAdapter_012', 0, () => {
      expect(FormStackDatabaseAdapter.checkArr([]) === false).assertTrue();
      expect(FormStackDatabaseAdapter.checkArr(null) === false).assertTrue();
      expect(FormStackDatabaseAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormStackDatabaseAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackDatabaseAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackDatabaseAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackDatabaseAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackDatabaseAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackDatabaseAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackDatabaseAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackDatabaseAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackDatabaseAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackDatabaseAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackDatabaseAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackDatabaseAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackDatabaseAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackDatabaseAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormStackDatabaseAdapter_013', 0, () => {
      expect(FormStackDatabaseAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackDatabaseAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackDatabaseAdapter_014', 0, () => {
      expect(FormStackDatabaseAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackDatabaseAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackDatabaseAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackDatabaseAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackDatabaseAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackDatabaseAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackDatabaseAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackDatabaseAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackDatabaseAdapter_015', 0, () => {
      expect(FormStackDatabaseAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackDatabaseAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackDatabaseAdapter_016', 0, () => {
      expect(FormStackDatabaseAdapter.isEmpty(null)).assertTrue();
      expect(FormStackDatabaseAdapter.isEmpty(undefined)).assertTrue();
      expect(FormStackDatabaseAdapter.isEmpty('')).assertTrue();
      expect(FormStackDatabaseAdapter.isEmpty(0)).assertTrue();
      expect(FormStackDatabaseAdapter.isEmpty([])).assertTrue();
      expect(FormStackDatabaseAdapter.isEmpty(1, null)).assertTrue();
      expect(FormStackDatabaseAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormStackDatabaseAdapter.isEmpty(1, true)).assertTrue();
      expect(FormStackDatabaseAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormStackDatabaseAdapter_017', 0, () => {
      expect(FormStackDatabaseAdapter.equals(null, 'a')).assertFalse();
      expect(FormStackDatabaseAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormStackDatabaseAdapter.equals('a', null)).assertFalse();
      expect(FormStackDatabaseAdapter.equals('a', undefined)).assertFalse();
      expect(FormStackDatabaseAdapter.equals('a', 1)).assertFalse();
      expect(FormStackDatabaseAdapter.equals(1, 'a')).assertFalse();
      expect(FormStackDatabaseAdapter.equals(1, [])).assertFalse();
      expect(FormStackDatabaseAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackDatabaseAdapter.equals([], m)).assertFalse();
      expect(FormStackDatabaseAdapter.equals(m, [])).assertFalse();
      expect(FormStackDatabaseAdapter.equals([1,2], [])).assertFalse();
      expect(FormStackDatabaseAdapter.equals([], [1, 2])).assertFalse();
      expect(FormStackDatabaseAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormStackDatabaseAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackDatabaseAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackDatabaseAdapter.equals(2, 2)).assertTrue();
    })
  });
}