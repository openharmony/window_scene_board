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
import { FormDbAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormDbAdapter';

export function FormDbAdapterTest() {
  describe('FormDbAdapterTest', () => {
    it('FormDbAdapter_001', 0, () => {
      expect(FormDbAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormDbAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormDbAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormDbAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormDbAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormDbAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormDbAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormDbAdapter_002', 0, () => {
      expect(FormDbAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormDbAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormDbAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormDbAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormDbAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormDbAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormDbAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormDbAdapter_003', 0, () => {
      expect(FormDbAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormDbAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormDbAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormDbAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormDbAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormDbAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormDbAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormDbAdapter_004', 0, () => {
      expect(FormDbAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormDbAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormDbAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormDbAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormDbAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormDbAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormDbAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormDbAdapter_005', 0, () => {
      expect(FormDbAdapter.isNumber("")).assertFalse();
      expect(FormDbAdapter.isNumber(null)).assertFalse();
      expect(FormDbAdapter.isNumber(undefined)).assertFalse();
      expect(FormDbAdapter.isNumber("abc")).assertFalse();
      expect(FormDbAdapter.isNumber("123")).assertTrue();
    });

    it('FormDbAdapter_006', 0, () => {
      expect(FormDbAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormDbAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormDbAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormDbAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormDbAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormDbAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormDbAdapter_007', 0, () => {
      expect(FormDbAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormDbAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormDbAdapter.getDefaultId('') === '').assertTrue();
      expect(FormDbAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormDbAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormDbAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormDbAdapter_008', 0, () => {
      expect(FormDbAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormDbAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormDbAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormDbAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormDbAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormDbAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormDbAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormDbAdapter_009', 0, () => {
      expect(FormDbAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormDbAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormDbAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormDbAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormDbAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormDbAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormDbAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormDbAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormDbAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormDbAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormDbAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormDbAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormDbAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormDbAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormDbAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormDbAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormDbAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormDbAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormDbAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormDbAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormDbAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormDbAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormDbAdapter_010', 0, () => {
      expect(FormDbAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormDbAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormDbAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormDbAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormDbAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormDbAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormDbAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormDbAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormDbAdapter_011', 0, () => {
      expect(FormDbAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormDbAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormDbAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormDbAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormDbAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormDbAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormDbAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormDbAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormDbAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormDbAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormDbAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormDbAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormDbAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormDbAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormDbAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormDbAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormDbAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormDbAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormDbAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormDbAdapter_012', 0, () => {
      expect(FormDbAdapter.checkArr([]) === false).assertTrue();
      expect(FormDbAdapter.checkArr(null) === false).assertTrue();
      expect(FormDbAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormDbAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormDbAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormDbAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormDbAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormDbAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormDbAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormDbAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormDbAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormDbAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormDbAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormDbAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormDbAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormDbAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormDbAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormDbAdapter_013', 0, () => {
      expect(FormDbAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormDbAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormDbAdapter_014', 0, () => {
      expect(FormDbAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormDbAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormDbAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormDbAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormDbAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormDbAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormDbAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormDbAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormDbAdapter_015', 0, () => {
      expect(FormDbAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormDbAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormDbAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormDbAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormDbAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormDbAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormDbAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormDbAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormDbAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormDbAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormDbAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormDbAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormDbAdapter_016', 0, () => {
      expect(FormDbAdapter.isEmpty(null)).assertTrue();
      expect(FormDbAdapter.isEmpty(undefined)).assertTrue();
      expect(FormDbAdapter.isEmpty('')).assertTrue();
      expect(FormDbAdapter.isEmpty(0)).assertTrue();
      expect(FormDbAdapter.isEmpty([])).assertTrue();
      expect(FormDbAdapter.isEmpty(1, null)).assertTrue();
      expect(FormDbAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormDbAdapter.isEmpty(1, true)).assertTrue();
      expect(FormDbAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormDbAdapter_017', 0, () => {
      expect(FormDbAdapter.equals(null, 'a')).assertFalse();
      expect(FormDbAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormDbAdapter.equals('a', null)).assertFalse();
      expect(FormDbAdapter.equals('a', undefined)).assertFalse();
      expect(FormDbAdapter.equals('a', 1)).assertFalse();
      expect(FormDbAdapter.equals(1, 'a')).assertFalse();
      expect(FormDbAdapter.equals(1, [])).assertFalse();
      expect(FormDbAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormDbAdapter.equals([], m)).assertFalse();
      expect(FormDbAdapter.equals(m, [])).assertFalse();
      expect(FormDbAdapter.equals([1,2], [])).assertFalse();
      expect(FormDbAdapter.equals([], [1, 2])).assertFalse();
      expect(FormDbAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormDbAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormDbAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormDbAdapter.equals(2, 2)).assertTrue();
    })
  });
}