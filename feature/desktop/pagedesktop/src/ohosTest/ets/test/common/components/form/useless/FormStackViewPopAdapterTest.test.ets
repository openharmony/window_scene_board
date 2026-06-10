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
import { FormStackViewPopAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackViewPopAdapter';

export function FormStackViewPopAdapterTest() {
  describe('FormStackViewPopAdapterTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackViewPopAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackViewPopAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackViewPopAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackViewPopAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackViewPopAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackViewPopAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackViewPopAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackViewPopAdapter_002', 0, () => {
      expect(FormStackViewPopAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackViewPopAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackViewPopAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewPopAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackViewPopAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewPopAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackViewPopAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackViewPopAdapter_003', 0, () => {
      expect(FormStackViewPopAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackViewPopAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewPopAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewPopAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewPopAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewPopAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackViewPopAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackViewPopAdapter_004', 0, () => {
      expect(FormStackViewPopAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackViewPopAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewPopAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewPopAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewPopAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewPopAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackViewPopAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackViewPopAdapter_005', 0, () => {
      expect(FormStackViewPopAdapter.isNumber("")).assertFalse();
      expect(FormStackViewPopAdapter.isNumber(null)).assertFalse();
      expect(FormStackViewPopAdapter.isNumber(undefined)).assertFalse();
      expect(FormStackViewPopAdapter.isNumber("abc")).assertFalse();
      expect(FormStackViewPopAdapter.isNumber("123")).assertTrue();
    });

    it('FormStackViewPopAdapter_006', 0, () => {
      expect(FormStackViewPopAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackViewPopAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackViewPopAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackViewPopAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackViewPopAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackViewPopAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackViewPopAdapter_007', 0, () => {
      expect(FormStackViewPopAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormStackViewPopAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackViewPopAdapter.getDefaultId('') === '').assertTrue();
      expect(FormStackViewPopAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormStackViewPopAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackViewPopAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackViewPopAdapter_008', 0, () => {
      expect(FormStackViewPopAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackViewPopAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackViewPopAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackViewPopAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackViewPopAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackViewPopAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackViewPopAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackViewPopAdapter_009', 0, () => {
      expect(FormStackViewPopAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormStackViewPopAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackViewPopAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackViewPopAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackViewPopAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackViewPopAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackViewPopAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackViewPopAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackViewPopAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackViewPopAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackViewPopAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackViewPopAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackViewPopAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackViewPopAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackViewPopAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackViewPopAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackViewPopAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackViewPopAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackViewPopAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackViewPopAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackViewPopAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackViewPopAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackViewPopAdapter_010', 0, () => {
      expect(FormStackViewPopAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormStackViewPopAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackViewPopAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackViewPopAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackViewPopAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackViewPopAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackViewPopAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackViewPopAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackViewPopAdapter_011', 0, () => {
      expect(FormStackViewPopAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackViewPopAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackViewPopAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackViewPopAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackViewPopAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackViewPopAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackViewPopAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackViewPopAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackViewPopAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackViewPopAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackViewPopAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackViewPopAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackViewPopAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackViewPopAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackViewPopAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackViewPopAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackViewPopAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackViewPopAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackViewPopAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackViewPopAdapter_012', 0, () => {
      expect(FormStackViewPopAdapter.checkArr([]) === false).assertTrue();
      expect(FormStackViewPopAdapter.checkArr(null) === false).assertTrue();
      expect(FormStackViewPopAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormStackViewPopAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackViewPopAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackViewPopAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackViewPopAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackViewPopAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackViewPopAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackViewPopAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackViewPopAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackViewPopAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackViewPopAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackViewPopAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackViewPopAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackViewPopAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackViewPopAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormStackViewPopAdapter_013', 0, () => {
      expect(FormStackViewPopAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackViewPopAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackViewPopAdapter_014', 0, () => {
      expect(FormStackViewPopAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackViewPopAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackViewPopAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackViewPopAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackViewPopAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackViewPopAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackViewPopAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackViewPopAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackViewPopAdapter_015', 0, () => {
      expect(FormStackViewPopAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackViewPopAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackViewPopAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormStackViewPopAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackViewPopAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackViewPopAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackViewPopAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackViewPopAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackViewPopAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackViewPopAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackViewPopAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackViewPopAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackViewPopAdapter_016', 0, () => {
      expect(FormStackViewPopAdapter.isEmpty(null)).assertTrue();
      expect(FormStackViewPopAdapter.isEmpty(undefined)).assertTrue();
      expect(FormStackViewPopAdapter.isEmpty('')).assertTrue();
      expect(FormStackViewPopAdapter.isEmpty(0)).assertTrue();
      expect(FormStackViewPopAdapter.isEmpty([])).assertTrue();
      expect(FormStackViewPopAdapter.isEmpty(1, null)).assertTrue();
      expect(FormStackViewPopAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormStackViewPopAdapter.isEmpty(1, true)).assertTrue();
      expect(FormStackViewPopAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormStackViewPopAdapter_017', 0, () => {
      expect(FormStackViewPopAdapter.equals(null, 'a')).assertFalse();
      expect(FormStackViewPopAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormStackViewPopAdapter.equals('a', null)).assertFalse();
      expect(FormStackViewPopAdapter.equals('a', undefined)).assertFalse();
      expect(FormStackViewPopAdapter.equals('a', 1)).assertFalse();
      expect(FormStackViewPopAdapter.equals(1, 'a')).assertFalse();
      expect(FormStackViewPopAdapter.equals(1, [])).assertFalse();
      expect(FormStackViewPopAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackViewPopAdapter.equals([], m)).assertFalse();
      expect(FormStackViewPopAdapter.equals(m, [])).assertFalse();
      expect(FormStackViewPopAdapter.equals([1,2], [])).assertFalse();
      expect(FormStackViewPopAdapter.equals([], [1, 2])).assertFalse();
      expect(FormStackViewPopAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormStackViewPopAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackViewPopAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackViewPopAdapter.equals(2, 2)).assertTrue();
    })
  });
}