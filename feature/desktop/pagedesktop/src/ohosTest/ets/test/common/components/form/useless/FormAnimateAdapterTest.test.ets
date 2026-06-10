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
import { FormAnimateAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormAnimateAdapter';

export function FormAnimateAdapterTest() {
  describe('FormAnimateAdapterTest', () => {
    it('FormAnimateAdapter_001', 0, () => {
      expect(FormAnimateAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormAnimateAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormAnimateAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormAnimateAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormAnimateAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormAnimateAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormAnimateAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAnimateAdapter_002', 0, () => {
      expect(FormAnimateAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormAnimateAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormAnimateAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormAnimateAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormAnimateAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormAnimateAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormAnimateAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAnimateAdapter_003', 0, () => {
      expect(FormAnimateAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormAnimateAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormAnimateAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormAnimateAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormAnimateAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormAnimateAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormAnimateAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAnimateAdapter_004', 0, () => {
      expect(FormAnimateAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormAnimateAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormAnimateAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormAnimateAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormAnimateAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormAnimateAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormAnimateAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAnimateAdapter_005', 0, () => {
      expect(FormAnimateAdapter.isNumber("")).assertFalse();
      expect(FormAnimateAdapter.isNumber(null)).assertFalse();
      expect(FormAnimateAdapter.isNumber(undefined)).assertFalse();
      expect(FormAnimateAdapter.isNumber("abc")).assertFalse();
      expect(FormAnimateAdapter.isNumber("123")).assertTrue();
    });

    it('FormAnimateAdapter_006', 0, () => {
      expect(FormAnimateAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormAnimateAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormAnimateAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormAnimateAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormAnimateAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormAnimateAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAnimateAdapter_007', 0, () => {
      expect(FormAnimateAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormAnimateAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormAnimateAdapter.getDefaultId('') === '').assertTrue();
      expect(FormAnimateAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormAnimateAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormAnimateAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAnimateAdapter_008', 0, () => {
      expect(FormAnimateAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormAnimateAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormAnimateAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormAnimateAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormAnimateAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormAnimateAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormAnimateAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAnimateAdapter_009', 0, () => {
      expect(FormAnimateAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormAnimateAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormAnimateAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormAnimateAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormAnimateAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormAnimateAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormAnimateAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormAnimateAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormAnimateAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormAnimateAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormAnimateAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormAnimateAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormAnimateAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormAnimateAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormAnimateAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormAnimateAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormAnimateAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormAnimateAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormAnimateAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormAnimateAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormAnimateAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormAnimateAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAnimateAdapter_010', 0, () => {
      expect(FormAnimateAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormAnimateAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormAnimateAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormAnimateAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormAnimateAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormAnimateAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormAnimateAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormAnimateAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAnimateAdapter_011', 0, () => {
      expect(FormAnimateAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormAnimateAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormAnimateAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormAnimateAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormAnimateAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormAnimateAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormAnimateAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormAnimateAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormAnimateAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormAnimateAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormAnimateAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormAnimateAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormAnimateAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormAnimateAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormAnimateAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormAnimateAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormAnimateAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormAnimateAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormAnimateAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAnimateAdapter_012', 0, () => {
      expect(FormAnimateAdapter.checkArr([]) === false).assertTrue();
      expect(FormAnimateAdapter.checkArr(null) === false).assertTrue();
      expect(FormAnimateAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormAnimateAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormAnimateAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormAnimateAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormAnimateAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormAnimateAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormAnimateAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormAnimateAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormAnimateAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormAnimateAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormAnimateAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormAnimateAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormAnimateAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormAnimateAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormAnimateAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormAnimateAdapter_013', 0, () => {
      expect(FormAnimateAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormAnimateAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAnimateAdapter_014', 0, () => {
      expect(FormAnimateAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormAnimateAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormAnimateAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormAnimateAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormAnimateAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormAnimateAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormAnimateAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormAnimateAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAnimateAdapter_015', 0, () => {
      expect(FormAnimateAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormAnimateAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormAnimateAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormAnimateAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormAnimateAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormAnimateAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormAnimateAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormAnimateAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormAnimateAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormAnimateAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormAnimateAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormAnimateAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAnimateAdapter_016', 0, () => {
      expect(FormAnimateAdapter.isEmpty(null)).assertTrue();
      expect(FormAnimateAdapter.isEmpty(undefined)).assertTrue();
      expect(FormAnimateAdapter.isEmpty('')).assertTrue();
      expect(FormAnimateAdapter.isEmpty(0)).assertTrue();
      expect(FormAnimateAdapter.isEmpty([])).assertTrue();
      expect(FormAnimateAdapter.isEmpty(1, null)).assertTrue();
      expect(FormAnimateAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormAnimateAdapter.isEmpty(1, true)).assertTrue();
      expect(FormAnimateAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormAnimateAdapter_017', 0, () => {
      expect(FormAnimateAdapter.equals(null, 'a')).assertFalse();
      expect(FormAnimateAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormAnimateAdapter.equals('a', null)).assertFalse();
      expect(FormAnimateAdapter.equals('a', undefined)).assertFalse();
      expect(FormAnimateAdapter.equals('a', 1)).assertFalse();
      expect(FormAnimateAdapter.equals(1, 'a')).assertFalse();
      expect(FormAnimateAdapter.equals(1, [])).assertFalse();
      expect(FormAnimateAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormAnimateAdapter.equals([], m)).assertFalse();
      expect(FormAnimateAdapter.equals(m, [])).assertFalse();
      expect(FormAnimateAdapter.equals([1,2], [])).assertFalse();
      expect(FormAnimateAdapter.equals([], [1, 2])).assertFalse();
      expect(FormAnimateAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormAnimateAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormAnimateAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormAnimateAdapter.equals(2, 2)).assertTrue();
    })
  });
}