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
import { FormAccessAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormAccessAdapter';

export function FormAccessAdapterTest() {
  describe('FormAccessAdapterTest', () => {
    it('FormAccessAdapter_001', 0, () => {
      expect(FormAccessAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormAccessAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormAccessAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormAccessAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormAccessAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormAccessAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormAccessAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAccessAdapter_002', 0, () => {
      expect(FormAccessAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormAccessAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormAccessAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormAccessAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormAccessAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormAccessAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormAccessAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAccessAdapter_003', 0, () => {
      expect(FormAccessAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormAccessAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormAccessAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormAccessAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormAccessAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormAccessAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormAccessAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAccessAdapter_004', 0, () => {
      expect(FormAccessAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormAccessAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormAccessAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormAccessAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormAccessAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormAccessAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormAccessAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAccessAdapter_005', 0, () => {
      expect(FormAccessAdapter.isNumber("")).assertFalse();
      expect(FormAccessAdapter.isNumber(null)).assertFalse();
      expect(FormAccessAdapter.isNumber(undefined)).assertFalse();
      expect(FormAccessAdapter.isNumber("abc")).assertFalse();
      expect(FormAccessAdapter.isNumber("123")).assertTrue();
    });

    it('FormAccessAdapter_006', 0, () => {
      expect(FormAccessAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormAccessAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormAccessAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormAccessAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormAccessAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormAccessAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAccessAdapter_007', 0, () => {
      expect(FormAccessAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormAccessAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormAccessAdapter.getDefaultId('') === '').assertTrue();
      expect(FormAccessAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormAccessAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormAccessAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAccessAdapter_008', 0, () => {
      expect(FormAccessAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormAccessAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormAccessAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormAccessAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormAccessAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormAccessAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormAccessAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAccessAdapter_009', 0, () => {
      expect(FormAccessAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormAccessAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormAccessAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormAccessAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormAccessAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormAccessAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormAccessAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormAccessAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormAccessAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormAccessAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormAccessAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormAccessAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormAccessAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormAccessAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormAccessAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormAccessAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormAccessAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormAccessAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormAccessAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormAccessAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormAccessAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormAccessAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAccessAdapter_010', 0, () => {
      expect(FormAccessAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormAccessAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormAccessAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormAccessAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormAccessAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormAccessAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormAccessAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormAccessAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAccessAdapter_011', 0, () => {
      expect(FormAccessAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormAccessAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormAccessAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormAccessAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormAccessAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormAccessAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormAccessAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormAccessAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormAccessAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormAccessAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormAccessAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormAccessAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormAccessAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormAccessAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormAccessAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormAccessAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormAccessAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormAccessAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormAccessAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAccessAdapter_012', 0, () => {
      expect(FormAccessAdapter.checkArr([]) === false).assertTrue();
      expect(FormAccessAdapter.checkArr(null) === false).assertTrue();
      expect(FormAccessAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormAccessAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormAccessAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormAccessAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormAccessAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormAccessAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormAccessAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormAccessAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormAccessAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormAccessAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormAccessAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormAccessAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormAccessAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormAccessAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormAccessAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormAccessAdapter_013', 0, () => {
      expect(FormAccessAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormAccessAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAccessAdapter_014', 0, () => {
      expect(FormAccessAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormAccessAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormAccessAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormAccessAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormAccessAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormAccessAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormAccessAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormAccessAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAccessAdapter_015', 0, () => {
      expect(FormAccessAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormAccessAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormAccessAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormAccessAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormAccessAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormAccessAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormAccessAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormAccessAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormAccessAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormAccessAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormAccessAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormAccessAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAccessAdapter_016', 0, () => {
      expect(FormAccessAdapter.isEmpty(null)).assertTrue();
      expect(FormAccessAdapter.isEmpty(undefined)).assertTrue();
      expect(FormAccessAdapter.isEmpty('')).assertTrue();
      expect(FormAccessAdapter.isEmpty(0)).assertTrue();
      expect(FormAccessAdapter.isEmpty([])).assertTrue();
      expect(FormAccessAdapter.isEmpty(1, null)).assertTrue();
      expect(FormAccessAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormAccessAdapter.isEmpty(1, true)).assertTrue();
      expect(FormAccessAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormAccessAdapter_017', 0, () => {
      expect(FormAccessAdapter.equals(null, 'a')).assertFalse();
      expect(FormAccessAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormAccessAdapter.equals('a', null)).assertFalse();
      expect(FormAccessAdapter.equals('a', undefined)).assertFalse();
      expect(FormAccessAdapter.equals('a', 1)).assertFalse();
      expect(FormAccessAdapter.equals(1, 'a')).assertFalse();
      expect(FormAccessAdapter.equals(1, [])).assertFalse();
      expect(FormAccessAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormAccessAdapter.equals([], m)).assertFalse();
      expect(FormAccessAdapter.equals(m, [])).assertFalse();
      expect(FormAccessAdapter.equals([1,2], [])).assertFalse();
      expect(FormAccessAdapter.equals([], [1, 2])).assertFalse();
      expect(FormAccessAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormAccessAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormAccessAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormAccessAdapter.equals(2, 2)).assertTrue();
    })
  });
}