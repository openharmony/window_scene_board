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
import { FormStackExpandAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackExpandAdapter';

export function FormStackExpandAdapterTest() {
  describe('FormStackExpandAdapterTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackExpandAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackExpandAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackExpandAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackExpandAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackExpandAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackExpandAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackExpandAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackExpandAdapter_002', 0, () => {
      expect(FormStackExpandAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackExpandAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackExpandAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackExpandAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackExpandAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackExpandAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackExpandAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackExpandAdapter_003', 0, () => {
      expect(FormStackExpandAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackExpandAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackExpandAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackExpandAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackExpandAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackExpandAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackExpandAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackExpandAdapter_004', 0, () => {
      expect(FormStackExpandAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackExpandAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackExpandAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackExpandAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackExpandAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackExpandAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackExpandAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackExpandAdapter_005', 0, () => {
      expect(FormStackExpandAdapter.isNumber("")).assertFalse();
      expect(FormStackExpandAdapter.isNumber(null)).assertFalse();
      expect(FormStackExpandAdapter.isNumber(undefined)).assertFalse();
      expect(FormStackExpandAdapter.isNumber("abc")).assertFalse();
      expect(FormStackExpandAdapter.isNumber("123")).assertTrue();
    });

    it('FormStackExpandAdapter_006', 0, () => {
      expect(FormStackExpandAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackExpandAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackExpandAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackExpandAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackExpandAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackExpandAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackExpandAdapter_007', 0, () => {
      expect(FormStackExpandAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormStackExpandAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackExpandAdapter.getDefaultId('') === '').assertTrue();
      expect(FormStackExpandAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormStackExpandAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackExpandAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackExpandAdapter_008', 0, () => {
      expect(FormStackExpandAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackExpandAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackExpandAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackExpandAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackExpandAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackExpandAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackExpandAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackExpandAdapter_009', 0, () => {
      expect(FormStackExpandAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormStackExpandAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackExpandAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackExpandAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackExpandAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackExpandAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackExpandAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackExpandAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackExpandAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackExpandAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackExpandAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackExpandAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackExpandAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackExpandAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackExpandAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackExpandAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackExpandAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackExpandAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackExpandAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackExpandAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackExpandAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackExpandAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackExpandAdapter_010', 0, () => {
      expect(FormStackExpandAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormStackExpandAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackExpandAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackExpandAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackExpandAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackExpandAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackExpandAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackExpandAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackExpandAdapter_011', 0, () => {
      expect(FormStackExpandAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackExpandAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackExpandAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackExpandAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackExpandAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackExpandAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackExpandAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackExpandAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackExpandAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackExpandAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackExpandAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackExpandAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackExpandAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackExpandAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackExpandAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackExpandAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackExpandAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackExpandAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackExpandAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackExpandAdapter_012', 0, () => {
      expect(FormStackExpandAdapter.checkArr([]) === false).assertTrue();
      expect(FormStackExpandAdapter.checkArr(null) === false).assertTrue();
      expect(FormStackExpandAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormStackExpandAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackExpandAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackExpandAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackExpandAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackExpandAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackExpandAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackExpandAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackExpandAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackExpandAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackExpandAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackExpandAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackExpandAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackExpandAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackExpandAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormStackExpandAdapter_013', 0, () => {
      expect(FormStackExpandAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackExpandAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackExpandAdapter_014', 0, () => {
      expect(FormStackExpandAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackExpandAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackExpandAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackExpandAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackExpandAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackExpandAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackExpandAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackExpandAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackExpandAdapter_015', 0, () => {
      expect(FormStackExpandAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackExpandAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackExpandAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormStackExpandAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackExpandAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackExpandAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackExpandAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackExpandAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackExpandAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackExpandAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackExpandAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackExpandAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackExpandAdapter_016', 0, () => {
      expect(FormStackExpandAdapter.isEmpty(null)).assertTrue();
      expect(FormStackExpandAdapter.isEmpty(undefined)).assertTrue();
      expect(FormStackExpandAdapter.isEmpty('')).assertTrue();
      expect(FormStackExpandAdapter.isEmpty(0)).assertTrue();
      expect(FormStackExpandAdapter.isEmpty([])).assertTrue();
      expect(FormStackExpandAdapter.isEmpty(1, null)).assertTrue();
      expect(FormStackExpandAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormStackExpandAdapter.isEmpty(1, true)).assertTrue();
      expect(FormStackExpandAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormStackExpandAdapter_017', 0, () => {
      expect(FormStackExpandAdapter.equals(null, 'a')).assertFalse();
      expect(FormStackExpandAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormStackExpandAdapter.equals('a', null)).assertFalse();
      expect(FormStackExpandAdapter.equals('a', undefined)).assertFalse();
      expect(FormStackExpandAdapter.equals('a', 1)).assertFalse();
      expect(FormStackExpandAdapter.equals(1, 'a')).assertFalse();
      expect(FormStackExpandAdapter.equals(1, [])).assertFalse();
      expect(FormStackExpandAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackExpandAdapter.equals([], m)).assertFalse();
      expect(FormStackExpandAdapter.equals(m, [])).assertFalse();
      expect(FormStackExpandAdapter.equals([1,2], [])).assertFalse();
      expect(FormStackExpandAdapter.equals([], [1, 2])).assertFalse();
      expect(FormStackExpandAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormStackExpandAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackExpandAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackExpandAdapter.equals(2, 2)).assertTrue();
    })
  });
}