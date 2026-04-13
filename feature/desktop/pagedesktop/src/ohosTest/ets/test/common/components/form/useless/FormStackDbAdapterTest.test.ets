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
import { FormStackDbAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackDbAdapter';

export function FormStackDbAdapterTest() {
  describe('FormStackDbAdapterTest', () => {
    it('FormStackDbAdapter_001', 0, () => {
      expect(FormStackDbAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackDbAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackDbAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackDbAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackDbAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackDbAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackDbAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackDbAdapter_002', 0, () => {
      expect(FormStackDbAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackDbAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackDbAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackDbAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackDbAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackDbAdapter_003', 0, () => {
      expect(FormStackDbAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackDbAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackDbAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackDbAdapter_004', 0, () => {
      expect(FormStackDbAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackDbAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackDbAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackDbAdapter_005', 0, () => {
      expect(FormStackDbAdapter.isNumber("")).assertFalse();
      expect(FormStackDbAdapter.isNumber(null)).assertFalse();
      expect(FormStackDbAdapter.isNumber(undefined)).assertFalse();
      expect(FormStackDbAdapter.isNumber("abc")).assertFalse();
      expect(FormStackDbAdapter.isNumber("123")).assertTrue();
    });

    it('FormStackDbAdapter_006', 0, () => {
      expect(FormStackDbAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackDbAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackDbAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackDbAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackDbAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackDbAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackDbAdapter_007', 0, () => {
      expect(FormStackDbAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormStackDbAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackDbAdapter.getDefaultId('') === '').assertTrue();
      expect(FormStackDbAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormStackDbAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackDbAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackDbAdapter_008', 0, () => {
      expect(FormStackDbAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackDbAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackDbAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackDbAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackDbAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackDbAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackDbAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackDbAdapter_009', 0, () => {
      expect(FormStackDbAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormStackDbAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackDbAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackDbAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackDbAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackDbAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackDbAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackDbAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackDbAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackDbAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackDbAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackDbAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackDbAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackDbAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackDbAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackDbAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackDbAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackDbAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackDbAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackDbAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackDbAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackDbAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackDbAdapter_010', 0, () => {
      expect(FormStackDbAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormStackDbAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackDbAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackDbAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackDbAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackDbAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackDbAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackDbAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackDbAdapter_011', 0, () => {
      expect(FormStackDbAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackDbAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackDbAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackDbAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackDbAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackDbAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackDbAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackDbAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackDbAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackDbAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackDbAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackDbAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackDbAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackDbAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackDbAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackDbAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackDbAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackDbAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackDbAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackDbAdapter_012', 0, () => {
      expect(FormStackDbAdapter.checkArr([]) === false).assertTrue();
      expect(FormStackDbAdapter.checkArr(null) === false).assertTrue();
      expect(FormStackDbAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormStackDbAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackDbAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackDbAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackDbAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackDbAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackDbAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackDbAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackDbAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackDbAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackDbAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackDbAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackDbAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackDbAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackDbAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormStackDbAdapter_013', 0, () => {
      expect(FormStackDbAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackDbAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackDbAdapter_014', 0, () => {
      expect(FormStackDbAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackDbAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackDbAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackDbAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackDbAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackDbAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackDbAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackDbAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackDbAdapter_015', 0, () => {
      expect(FormStackDbAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackDbAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackDbAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormStackDbAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackDbAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackDbAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackDbAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackDbAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackDbAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackDbAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackDbAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackDbAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackDbAdapter_016', 0, () => {
      expect(FormStackDbAdapter.isEmpty(null)).assertTrue();
      expect(FormStackDbAdapter.isEmpty(undefined)).assertTrue();
      expect(FormStackDbAdapter.isEmpty('')).assertTrue();
      expect(FormStackDbAdapter.isEmpty(0)).assertTrue();
      expect(FormStackDbAdapter.isEmpty([])).assertTrue();
      expect(FormStackDbAdapter.isEmpty(1, null)).assertTrue();
      expect(FormStackDbAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormStackDbAdapter.isEmpty(1, true)).assertTrue();
      expect(FormStackDbAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormStackDbAdapter_017', 0, () => {
      expect(FormStackDbAdapter.equals(null, 'a')).assertFalse();
      expect(FormStackDbAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormStackDbAdapter.equals('a', null)).assertFalse();
      expect(FormStackDbAdapter.equals('a', undefined)).assertFalse();
      expect(FormStackDbAdapter.equals('a', 1)).assertFalse();
      expect(FormStackDbAdapter.equals(1, 'a')).assertFalse();
      expect(FormStackDbAdapter.equals(1, [])).assertFalse();
      expect(FormStackDbAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackDbAdapter.equals([], m)).assertFalse();
      expect(FormStackDbAdapter.equals(m, [])).assertFalse();
      expect(FormStackDbAdapter.equals([1,2], [])).assertFalse();
      expect(FormStackDbAdapter.equals([], [1, 2])).assertFalse();
      expect(FormStackDbAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormStackDbAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackDbAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackDbAdapter.equals(2, 2)).assertTrue();
    })
  });
}