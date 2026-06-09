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
import { FormAddAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormAddAdapter';

export function FormAddAdapterTest() {
  describe('FormAddAdapterTest', () => {
    it('FormAddAdapter_001', 0, () => {
      expect(FormAddAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormAddAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormAddAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormAddAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormAddAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormAddAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormAddAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAddAdapter_002', 0, () => {
      expect(FormAddAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormAddAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormAddAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormAddAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormAddAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormAddAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormAddAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAddAdapter_003', 0, () => {
      expect(FormAddAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormAddAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormAddAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormAddAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormAddAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormAddAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormAddAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAddAdapter_004', 0, () => {
      expect(FormAddAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormAddAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormAddAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormAddAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormAddAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormAddAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormAddAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAddAdapter_005', 0, () => {
      expect(FormAddAdapter.isNumber("")).assertFalse();
      expect(FormAddAdapter.isNumber(null)).assertFalse();
      expect(FormAddAdapter.isNumber(undefined)).assertFalse();
      expect(FormAddAdapter.isNumber("abc")).assertFalse();
      expect(FormAddAdapter.isNumber("123")).assertTrue();
    });

    it('FormAddAdapter_006', 0, () => {
      expect(FormAddAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormAddAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormAddAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormAddAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormAddAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormAddAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAddAdapter_007', 0, () => {
      expect(FormAddAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormAddAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormAddAdapter.getDefaultId('') === '').assertTrue();
      expect(FormAddAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormAddAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormAddAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAddAdapter_008', 0, () => {
      expect(FormAddAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormAddAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormAddAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormAddAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormAddAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormAddAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormAddAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAddAdapter_009', 0, () => {
      expect(FormAddAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormAddAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormAddAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormAddAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormAddAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormAddAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormAddAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormAddAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormAddAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormAddAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormAddAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormAddAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormAddAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormAddAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormAddAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormAddAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormAddAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormAddAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormAddAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormAddAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormAddAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormAddAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAddAdapter_010', 0, () => {
      expect(FormAddAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormAddAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormAddAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormAddAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormAddAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormAddAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormAddAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormAddAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAddAdapter_011', 0, () => {
      expect(FormAddAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormAddAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormAddAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormAddAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormAddAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormAddAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormAddAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormAddAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormAddAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormAddAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormAddAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormAddAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormAddAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormAddAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormAddAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormAddAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormAddAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormAddAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormAddAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAddAdapter_012', 0, () => {
      expect(FormAddAdapter.checkArr([]) === false).assertTrue();
      expect(FormAddAdapter.checkArr(null) === false).assertTrue();
      expect(FormAddAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormAddAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormAddAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormAddAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormAddAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormAddAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormAddAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormAddAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormAddAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormAddAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormAddAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormAddAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormAddAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormAddAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormAddAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormAddAdapter_013', 0, () => {
      expect(FormAddAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormAddAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAddAdapter_014', 0, () => {
      expect(FormAddAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormAddAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormAddAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormAddAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormAddAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormAddAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormAddAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormAddAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAddAdapter_015', 0, () => {
      expect(FormAddAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormAddAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormAddAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormAddAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormAddAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormAddAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormAddAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormAddAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormAddAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormAddAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormAddAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormAddAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAddAdapter_016', 0, () => {
      expect(FormAddAdapter.isEmpty(null)).assertTrue();
      expect(FormAddAdapter.isEmpty(undefined)).assertTrue();
      expect(FormAddAdapter.isEmpty('')).assertTrue();
      expect(FormAddAdapter.isEmpty(0)).assertTrue();
      expect(FormAddAdapter.isEmpty([])).assertTrue();
      expect(FormAddAdapter.isEmpty(1, null)).assertTrue();
      expect(FormAddAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormAddAdapter.isEmpty(1, true)).assertTrue();
      expect(FormAddAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormAddAdapter_017', 0, () => {
      expect(FormAddAdapter.equals(null, 'a')).assertFalse();
      expect(FormAddAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormAddAdapter.equals('a', null)).assertFalse();
      expect(FormAddAdapter.equals('a', undefined)).assertFalse();
      expect(FormAddAdapter.equals('a', 1)).assertFalse();
      expect(FormAddAdapter.equals(1, 'a')).assertFalse();
      expect(FormAddAdapter.equals(1, [])).assertFalse();
      expect(FormAddAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormAddAdapter.equals([], m)).assertFalse();
      expect(FormAddAdapter.equals(m, [])).assertFalse();
      expect(FormAddAdapter.equals([1,2], [])).assertFalse();
      expect(FormAddAdapter.equals([], [1, 2])).assertFalse();
      expect(FormAddAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormAddAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormAddAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormAddAdapter.equals(2, 2)).assertTrue();
    })
  });
}