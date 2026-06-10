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
import { FormThemeAnimateAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormThemeAnimateAdapter';

export function FormThemeAnimateAdapterTest() {
  describe('FormThemeAnimateAdapterTest', () => {
    it('FormThemeAnimateAdapter_001', 0, () => {
      expect(FormThemeAnimateAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormThemeAnimateAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormThemeAnimateAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormThemeAnimateAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormThemeAnimateAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormThemeAnimateAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormThemeAnimateAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormThemeAnimateAdapter_002', 0, () => {
      expect(FormThemeAnimateAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormThemeAnimateAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormThemeAnimateAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAnimateAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormThemeAnimateAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAnimateAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormThemeAnimateAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormThemeAnimateAdapter_003', 0, () => {
      expect(FormThemeAnimateAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormThemeAnimateAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAnimateAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAnimateAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAnimateAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAnimateAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormThemeAnimateAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormThemeAnimateAdapter_004', 0, () => {
      expect(FormThemeAnimateAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormThemeAnimateAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAnimateAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAnimateAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAnimateAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAnimateAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormThemeAnimateAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormThemeAnimateAdapter_005', 0, () => {
      expect(FormThemeAnimateAdapter.isNumber("")).assertFalse();
      expect(FormThemeAnimateAdapter.isNumber(null)).assertFalse();
      expect(FormThemeAnimateAdapter.isNumber(undefined)).assertFalse();
      expect(FormThemeAnimateAdapter.isNumber("abc")).assertFalse();
      expect(FormThemeAnimateAdapter.isNumber("123")).assertTrue();
    });

    it('FormThemeAnimateAdapter_006', 0, () => {
      expect(FormThemeAnimateAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormThemeAnimateAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormThemeAnimateAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormThemeAnimateAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormThemeAnimateAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormThemeAnimateAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormThemeAnimateAdapter_007', 0, () => {
      expect(FormThemeAnimateAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormThemeAnimateAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormThemeAnimateAdapter.getDefaultId('') === '').assertTrue();
      expect(FormThemeAnimateAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormThemeAnimateAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormThemeAnimateAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormThemeAnimateAdapter_008', 0, () => {
      expect(FormThemeAnimateAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormThemeAnimateAdapter_009', 0, () => {
      expect(FormThemeAnimateAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormThemeAnimateAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormThemeAnimateAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormThemeAnimateAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormThemeAnimateAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormThemeAnimateAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormThemeAnimateAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormThemeAnimateAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormThemeAnimateAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormThemeAnimateAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormThemeAnimateAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormThemeAnimateAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormThemeAnimateAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormThemeAnimateAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormThemeAnimateAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormThemeAnimateAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormThemeAnimateAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormThemeAnimateAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormThemeAnimateAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormThemeAnimateAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormThemeAnimateAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormThemeAnimateAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormThemeAnimateAdapter_010', 0, () => {
      expect(FormThemeAnimateAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormThemeAnimateAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormThemeAnimateAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormThemeAnimateAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormThemeAnimateAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormThemeAnimateAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormThemeAnimateAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormThemeAnimateAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormThemeAnimateAdapter_011', 0, () => {
      expect(FormThemeAnimateAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormThemeAnimateAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormThemeAnimateAdapter_012', 0, () => {
      expect(FormThemeAnimateAdapter.checkArr([]) === false).assertTrue();
      expect(FormThemeAnimateAdapter.checkArr(null) === false).assertTrue();
      expect(FormThemeAnimateAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormThemeAnimateAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormThemeAnimateAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormThemeAnimateAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormThemeAnimateAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormThemeAnimateAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormThemeAnimateAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormThemeAnimateAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormThemeAnimateAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormThemeAnimateAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormThemeAnimateAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormThemeAnimateAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormThemeAnimateAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormThemeAnimateAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormThemeAnimateAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormThemeAnimateAdapter_013', 0, () => {
      expect(FormThemeAnimateAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormThemeAnimateAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormThemeAnimateAdapter_014', 0, () => {
      expect(FormThemeAnimateAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormThemeAnimateAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormThemeAnimateAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormThemeAnimateAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormThemeAnimateAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormThemeAnimateAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormThemeAnimateAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormThemeAnimateAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormThemeAnimateAdapter_015', 0, () => {
      expect(FormThemeAnimateAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormThemeAnimateAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormThemeAnimateAdapter_016', 0, () => {
      expect(FormThemeAnimateAdapter.isEmpty(null)).assertTrue();
      expect(FormThemeAnimateAdapter.isEmpty(undefined)).assertTrue();
      expect(FormThemeAnimateAdapter.isEmpty('')).assertTrue();
      expect(FormThemeAnimateAdapter.isEmpty(0)).assertTrue();
      expect(FormThemeAnimateAdapter.isEmpty([])).assertTrue();
      expect(FormThemeAnimateAdapter.isEmpty(1, null)).assertTrue();
      expect(FormThemeAnimateAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormThemeAnimateAdapter.isEmpty(1, true)).assertTrue();
      expect(FormThemeAnimateAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormThemeAnimateAdapter_017', 0, () => {
      expect(FormThemeAnimateAdapter.equals(null, 'a')).assertFalse();
      expect(FormThemeAnimateAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormThemeAnimateAdapter.equals('a', null)).assertFalse();
      expect(FormThemeAnimateAdapter.equals('a', undefined)).assertFalse();
      expect(FormThemeAnimateAdapter.equals('a', 1)).assertFalse();
      expect(FormThemeAnimateAdapter.equals(1, 'a')).assertFalse();
      expect(FormThemeAnimateAdapter.equals(1, [])).assertFalse();
      expect(FormThemeAnimateAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormThemeAnimateAdapter.equals([], m)).assertFalse();
      expect(FormThemeAnimateAdapter.equals(m, [])).assertFalse();
      expect(FormThemeAnimateAdapter.equals([1,2], [])).assertFalse();
      expect(FormThemeAnimateAdapter.equals([], [1, 2])).assertFalse();
      expect(FormThemeAnimateAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormThemeAnimateAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormThemeAnimateAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormThemeAnimateAdapter.equals(2, 2)).assertTrue();
    })
  });
}