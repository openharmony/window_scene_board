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
import { FormStackViewFoldAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackViewFoldAdapter';

export function FormStackViewFoldAdapterTest() {
  describe('FormStackViewFoldAdapterTest', () => {
    it('FormStackViewFoldAdapter_001', 0, () => {
      expect(FormStackViewFoldAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackViewFoldAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackViewFoldAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackViewFoldAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackViewFoldAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackViewFoldAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackViewFoldAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackViewFoldAdapter_002', 0, () => {
      expect(FormStackViewFoldAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackViewFoldAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackViewFoldAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewFoldAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackViewFoldAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewFoldAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackViewFoldAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackViewFoldAdapter_003', 0, () => {
      expect(FormStackViewFoldAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackViewFoldAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewFoldAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewFoldAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewFoldAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewFoldAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackViewFoldAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackViewFoldAdapter_004', 0, () => {
      expect(FormStackViewFoldAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackViewFoldAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewFoldAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewFoldAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewFoldAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewFoldAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackViewFoldAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackViewFoldAdapter_005', 0, () => {
      expect(FormStackViewFoldAdapter.isNumber("")).assertFalse();
      expect(FormStackViewFoldAdapter.isNumber(null)).assertFalse();
      expect(FormStackViewFoldAdapter.isNumber(undefined)).assertFalse();
      expect(FormStackViewFoldAdapter.isNumber("abc")).assertFalse();
      expect(FormStackViewFoldAdapter.isNumber("123")).assertTrue();
    });

    it('FormStackViewFoldAdapter_006', 0, () => {
      expect(FormStackViewFoldAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackViewFoldAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackViewFoldAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackViewFoldAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackViewFoldAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackViewFoldAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackViewFoldAdapter_007', 0, () => {
      expect(FormStackViewFoldAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormStackViewFoldAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackViewFoldAdapter.getDefaultId('') === '').assertTrue();
      expect(FormStackViewFoldAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormStackViewFoldAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackViewFoldAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackViewFoldAdapter_008', 0, () => {
      expect(FormStackViewFoldAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackViewFoldAdapter_009', 0, () => {
      expect(FormStackViewFoldAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormStackViewFoldAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackViewFoldAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackViewFoldAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackViewFoldAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackViewFoldAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackViewFoldAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackViewFoldAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackViewFoldAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackViewFoldAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackViewFoldAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackViewFoldAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackViewFoldAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackViewFoldAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackViewFoldAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackViewFoldAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackViewFoldAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackViewFoldAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackViewFoldAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackViewFoldAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackViewFoldAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackViewFoldAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackViewFoldAdapter_010', 0, () => {
      expect(FormStackViewFoldAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormStackViewFoldAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackViewFoldAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackViewFoldAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackViewFoldAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackViewFoldAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackViewFoldAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackViewFoldAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackViewFoldAdapter_011', 0, () => {
      expect(FormStackViewFoldAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackViewFoldAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackViewFoldAdapter_012', 0, () => {
      expect(FormStackViewFoldAdapter.checkArr([]) === false).assertTrue();
      expect(FormStackViewFoldAdapter.checkArr(null) === false).assertTrue();
      expect(FormStackViewFoldAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormStackViewFoldAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackViewFoldAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackViewFoldAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackViewFoldAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackViewFoldAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackViewFoldAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackViewFoldAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackViewFoldAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackViewFoldAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackViewFoldAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackViewFoldAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackViewFoldAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackViewFoldAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackViewFoldAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormStackViewFoldAdapter_013', 0, () => {
      expect(FormStackViewFoldAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackViewFoldAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackViewFoldAdapter_014', 0, () => {
      expect(FormStackViewFoldAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackViewFoldAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackViewFoldAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackViewFoldAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackViewFoldAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackViewFoldAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackViewFoldAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackViewFoldAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackViewFoldAdapter_015', 0, () => {
      expect(FormStackViewFoldAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackViewFoldAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackViewFoldAdapter_016', 0, () => {
      expect(FormStackViewFoldAdapter.isEmpty(null)).assertTrue();
      expect(FormStackViewFoldAdapter.isEmpty(undefined)).assertTrue();
      expect(FormStackViewFoldAdapter.isEmpty('')).assertTrue();
      expect(FormStackViewFoldAdapter.isEmpty(0)).assertTrue();
      expect(FormStackViewFoldAdapter.isEmpty([])).assertTrue();
      expect(FormStackViewFoldAdapter.isEmpty(1, null)).assertTrue();
      expect(FormStackViewFoldAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormStackViewFoldAdapter.isEmpty(1, true)).assertTrue();
      expect(FormStackViewFoldAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormStackViewFoldAdapter_017', 0, () => {
      expect(FormStackViewFoldAdapter.equals(null, 'a')).assertFalse();
      expect(FormStackViewFoldAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormStackViewFoldAdapter.equals('a', null)).assertFalse();
      expect(FormStackViewFoldAdapter.equals('a', undefined)).assertFalse();
      expect(FormStackViewFoldAdapter.equals('a', 1)).assertFalse();
      expect(FormStackViewFoldAdapter.equals(1, 'a')).assertFalse();
      expect(FormStackViewFoldAdapter.equals(1, [])).assertFalse();
      expect(FormStackViewFoldAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackViewFoldAdapter.equals([], m)).assertFalse();
      expect(FormStackViewFoldAdapter.equals(m, [])).assertFalse();
      expect(FormStackViewFoldAdapter.equals([1,2], [])).assertFalse();
      expect(FormStackViewFoldAdapter.equals([], [1, 2])).assertFalse();
      expect(FormStackViewFoldAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormStackViewFoldAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackViewFoldAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackViewFoldAdapter.equals(2, 2)).assertTrue();
    })
  });
}