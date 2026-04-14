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
import { FormDeleteAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormDeleteAdapater';

export function FormDeleteAdapterTest() {
  describe('FormDeleteAdapterTest', () => {
    it('FormDeleteAdapter_001', 0, () => {
      expect(FormDeleteAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormDeleteAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormDeleteAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormDeleteAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormDeleteAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormDeleteAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormDeleteAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormDeleteAdapter_002', 0, () => {
      expect(FormDeleteAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormDeleteAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormDeleteAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormDeleteAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormDeleteAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormDeleteAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormDeleteAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormDeleteAdapter_003', 0, () => {
      expect(FormDeleteAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormDeleteAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormDeleteAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormDeleteAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormDeleteAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormDeleteAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormDeleteAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormDeleteAdapter_004', 0, () => {
      expect(FormDeleteAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormDeleteAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormDeleteAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormDeleteAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormDeleteAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormDeleteAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormDeleteAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormDeleteAdapter_005', 0, () => {
      expect(FormDeleteAdapter.isNumber("")).assertFalse();
      expect(FormDeleteAdapter.isNumber(null)).assertFalse();
      expect(FormDeleteAdapter.isNumber(undefined)).assertFalse();
      expect(FormDeleteAdapter.isNumber("abc")).assertFalse();
      expect(FormDeleteAdapter.isNumber("123")).assertTrue();
    });

    it('FormDeleteAdapter_006', 0, () => {
      expect(FormDeleteAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormDeleteAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormDeleteAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormDeleteAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormDeleteAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormDeleteAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormDeleteAdapter_007', 0, () => {
      expect(FormDeleteAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormDeleteAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormDeleteAdapter.getDefaultId('') === '').assertTrue();
      expect(FormDeleteAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormDeleteAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormDeleteAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormDeleteAdapter_008', 0, () => {
      expect(FormDeleteAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormDeleteAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormDeleteAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormDeleteAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormDeleteAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormDeleteAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormDeleteAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormDeleteAdapter_009', 0, () => {
      expect(FormDeleteAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormDeleteAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormDeleteAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormDeleteAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormDeleteAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormDeleteAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormDeleteAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormDeleteAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormDeleteAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormDeleteAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormDeleteAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormDeleteAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormDeleteAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormDeleteAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormDeleteAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormDeleteAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormDeleteAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormDeleteAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormDeleteAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormDeleteAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormDeleteAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormDeleteAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormDeleteAdapter_010', 0, () => {
      expect(FormDeleteAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormDeleteAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormDeleteAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormDeleteAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormDeleteAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormDeleteAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormDeleteAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormDeleteAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormDeleteAdapter_011', 0, () => {
      expect(FormDeleteAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormDeleteAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormDeleteAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormDeleteAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormDeleteAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormDeleteAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormDeleteAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormDeleteAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormDeleteAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormDeleteAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormDeleteAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormDeleteAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormDeleteAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormDeleteAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormDeleteAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormDeleteAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormDeleteAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormDeleteAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormDeleteAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormDeleteAdapter_012', 0, () => {
      expect(FormDeleteAdapter.checkArr([]) === false).assertTrue();
      expect(FormDeleteAdapter.checkArr(null) === false).assertTrue();
      expect(FormDeleteAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormDeleteAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormDeleteAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormDeleteAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormDeleteAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormDeleteAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormDeleteAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormDeleteAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormDeleteAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormDeleteAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormDeleteAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormDeleteAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormDeleteAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormDeleteAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormDeleteAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormDeleteAdapter_013', 0, () => {
      expect(FormDeleteAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormDeleteAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormDeleteAdapter_014', 0, () => {
      expect(FormDeleteAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormDeleteAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormDeleteAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormDeleteAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormDeleteAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormDeleteAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormDeleteAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormDeleteAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormDeleteAdapter_015', 0, () => {
      expect(FormDeleteAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormDeleteAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormDeleteAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormDeleteAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormDeleteAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormDeleteAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormDeleteAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormDeleteAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormDeleteAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormDeleteAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormDeleteAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormDeleteAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormDeleteAdapter_016', 0, () => {
      expect(FormDeleteAdapter.isEmpty(null)).assertTrue();
      expect(FormDeleteAdapter.isEmpty(undefined)).assertTrue();
      expect(FormDeleteAdapter.isEmpty('')).assertTrue();
      expect(FormDeleteAdapter.isEmpty(0)).assertTrue();
      expect(FormDeleteAdapter.isEmpty([])).assertTrue();
      expect(FormDeleteAdapter.isEmpty(1, null)).assertTrue();
      expect(FormDeleteAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormDeleteAdapter.isEmpty(1, true)).assertTrue();
      expect(FormDeleteAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormDeleteAdapter_017', 0, () => {
      expect(FormDeleteAdapter.equals(null, 'a')).assertFalse();
      expect(FormDeleteAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormDeleteAdapter.equals('a', null)).assertFalse();
      expect(FormDeleteAdapter.equals('a', undefined)).assertFalse();
      expect(FormDeleteAdapter.equals('a', 1)).assertFalse();
      expect(FormDeleteAdapter.equals(1, 'a')).assertFalse();
      expect(FormDeleteAdapter.equals(1, [])).assertFalse();
      expect(FormDeleteAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormDeleteAdapter.equals([], m)).assertFalse();
      expect(FormDeleteAdapter.equals(m, [])).assertFalse();
      expect(FormDeleteAdapter.equals([1,2], [])).assertFalse();
      expect(FormDeleteAdapter.equals([], [1, 2])).assertFalse();
      expect(FormDeleteAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormDeleteAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormDeleteAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormDeleteAdapter.equals(2, 2)).assertTrue();
    })
  });
}