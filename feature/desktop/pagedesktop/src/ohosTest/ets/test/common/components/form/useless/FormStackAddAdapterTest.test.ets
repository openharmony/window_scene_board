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
import { FormStackAddAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackAddAdapter';

export function FormStackAddAdapterTest() {
  describe('FormStackAddAdapterTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackAddAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackAddAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackAddAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackAddAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackAddAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackAddAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackAddAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackAddAdapter_002', 0, () => {
      expect(FormStackAddAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackAddAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackAddAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackAddAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackAddAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackAddAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackAddAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackAddAdapter_003', 0, () => {
      expect(FormStackAddAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackAddAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackAddAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAddAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAddAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAddAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackAddAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackAddAdapter_004', 0, () => {
      expect(FormStackAddAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackAddAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackAddAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAddAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAddAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAddAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackAddAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackAddAdapter_005', 0, () => {
      expect(FormStackAddAdapter.isNumber("")).assertFalse();
      expect(FormStackAddAdapter.isNumber(null)).assertFalse();
      expect(FormStackAddAdapter.isNumber(undefined)).assertFalse();
      expect(FormStackAddAdapter.isNumber("abc")).assertFalse();
      expect(FormStackAddAdapter.isNumber("123")).assertTrue();
    });

    it('FormStackAddAdapter_006', 0, () => {
      expect(FormStackAddAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackAddAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackAddAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackAddAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackAddAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackAddAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackAddAdapter_007', 0, () => {
      expect(FormStackAddAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormStackAddAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackAddAdapter.getDefaultId('') === '').assertTrue();
      expect(FormStackAddAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormStackAddAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackAddAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackAddAdapter_008', 0, () => {
      expect(FormStackAddAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackAddAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackAddAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackAddAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackAddAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackAddAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackAddAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackAddAdapter_009', 0, () => {
      expect(FormStackAddAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormStackAddAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackAddAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackAddAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackAddAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackAddAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackAddAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackAddAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackAddAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackAddAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackAddAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackAddAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackAddAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackAddAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackAddAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackAddAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackAddAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackAddAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackAddAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackAddAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackAddAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackAddAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackAddAdapter_010', 0, () => {
      expect(FormStackAddAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormStackAddAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackAddAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackAddAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackAddAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackAddAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackAddAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackAddAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackAddAdapter_011', 0, () => {
      expect(FormStackAddAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackAddAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackAddAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackAddAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackAddAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackAddAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackAddAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackAddAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackAddAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackAddAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackAddAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackAddAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackAddAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackAddAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackAddAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackAddAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackAddAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackAddAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackAddAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackAddAdapter_012', 0, () => {
      expect(FormStackAddAdapter.checkArr([]) === false).assertTrue();
      expect(FormStackAddAdapter.checkArr(null) === false).assertTrue();
      expect(FormStackAddAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormStackAddAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackAddAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackAddAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackAddAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackAddAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackAddAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackAddAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackAddAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackAddAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackAddAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackAddAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackAddAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackAddAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackAddAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormStackAddAdapter_013', 0, () => {
      expect(FormStackAddAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackAddAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackAddAdapter_014', 0, () => {
      expect(FormStackAddAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackAddAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackAddAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackAddAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackAddAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackAddAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackAddAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackAddAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackAddAdapter_015', 0, () => {
      expect(FormStackAddAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackAddAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackAddAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormStackAddAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackAddAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackAddAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackAddAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackAddAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackAddAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackAddAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackAddAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackAddAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackAddAdapter_016', 0, () => {
      expect(FormStackAddAdapter.isEmpty(null)).assertTrue();
      expect(FormStackAddAdapter.isEmpty(undefined)).assertTrue();
      expect(FormStackAddAdapter.isEmpty('')).assertTrue();
      expect(FormStackAddAdapter.isEmpty(0)).assertTrue();
      expect(FormStackAddAdapter.isEmpty([])).assertTrue();
      expect(FormStackAddAdapter.isEmpty(1, null)).assertTrue();
      expect(FormStackAddAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormStackAddAdapter.isEmpty(1, true)).assertTrue();
      expect(FormStackAddAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormStackAddAdapter_017', 0, () => {
      expect(FormStackAddAdapter.equals(null, 'a')).assertFalse();
      expect(FormStackAddAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormStackAddAdapter.equals('a', null)).assertFalse();
      expect(FormStackAddAdapter.equals('a', undefined)).assertFalse();
      expect(FormStackAddAdapter.equals('a', 1)).assertFalse();
      expect(FormStackAddAdapter.equals(1, 'a')).assertFalse();
      expect(FormStackAddAdapter.equals(1, [])).assertFalse();
      expect(FormStackAddAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackAddAdapter.equals([], m)).assertFalse();
      expect(FormStackAddAdapter.equals(m, [])).assertFalse();
      expect(FormStackAddAdapter.equals([1,2], [])).assertFalse();
      expect(FormStackAddAdapter.equals([], [1, 2])).assertFalse();
      expect(FormStackAddAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormStackAddAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackAddAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackAddAdapter.equals(2, 2)).assertTrue();
    })
  });
}