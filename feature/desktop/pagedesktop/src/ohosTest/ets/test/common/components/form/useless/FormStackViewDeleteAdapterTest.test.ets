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
import { FormStackViewDeleteAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackViewDeleteAdapter';

export function FormStackViewDeleteAdapterTest() {
  describe('FormStackViewDeleteAdapterTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackViewDeleteAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackViewDeleteAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackViewDeleteAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackViewDeleteAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackViewDeleteAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackViewDeleteAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackViewDeleteAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackViewDeleteAdapter_002', 0, () => {
      expect(FormStackViewDeleteAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackViewDeleteAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackViewDeleteAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewDeleteAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackViewDeleteAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewDeleteAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackViewDeleteAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackViewDeleteAdapter_003', 0, () => {
      expect(FormStackViewDeleteAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackViewDeleteAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewDeleteAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewDeleteAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewDeleteAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewDeleteAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackViewDeleteAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackViewDeleteAdapter_004', 0, () => {
      expect(FormStackViewDeleteAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackViewDeleteAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewDeleteAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewDeleteAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewDeleteAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewDeleteAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackViewDeleteAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackViewDeleteAdapter_005', 0, () => {
      expect(FormStackViewDeleteAdapter.isNumber("")).assertFalse();
      expect(FormStackViewDeleteAdapter.isNumber(null)).assertFalse();
      expect(FormStackViewDeleteAdapter.isNumber(undefined)).assertFalse();
      expect(FormStackViewDeleteAdapter.isNumber("abc")).assertFalse();
      expect(FormStackViewDeleteAdapter.isNumber("123")).assertTrue();
    });

    it('FormStackViewDeleteAdapter_006', 0, () => {
      expect(FormStackViewDeleteAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackViewDeleteAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackViewDeleteAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackViewDeleteAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackViewDeleteAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackViewDeleteAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackViewDeleteAdapter_007', 0, () => {
      expect(FormStackViewDeleteAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormStackViewDeleteAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackViewDeleteAdapter.getDefaultId('') === '').assertTrue();
      expect(FormStackViewDeleteAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormStackViewDeleteAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackViewDeleteAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackViewDeleteAdapter_008', 0, () => {
      expect(FormStackViewDeleteAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackViewDeleteAdapter_009', 0, () => {
      expect(FormStackViewDeleteAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackViewDeleteAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackViewDeleteAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackViewDeleteAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackViewDeleteAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackViewDeleteAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackViewDeleteAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackViewDeleteAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackViewDeleteAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackViewDeleteAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackViewDeleteAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackViewDeleteAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackViewDeleteAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackViewDeleteAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackViewDeleteAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackViewDeleteAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackViewDeleteAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackViewDeleteAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackViewDeleteAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackViewDeleteAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackViewDeleteAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackViewDeleteAdapter_010', 0, () => {
      expect(FormStackViewDeleteAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackViewDeleteAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackViewDeleteAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackViewDeleteAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackViewDeleteAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackViewDeleteAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackViewDeleteAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackViewDeleteAdapter_011', 0, () => {
      expect(FormStackViewDeleteAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackViewDeleteAdapter_012', 0, () => {
      expect(FormStackViewDeleteAdapter.checkArr([]) === false).assertTrue();
      expect(FormStackViewDeleteAdapter.checkArr(null) === false).assertTrue();
      expect(FormStackViewDeleteAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormStackViewDeleteAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackViewDeleteAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackViewDeleteAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackViewDeleteAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackViewDeleteAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackViewDeleteAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackViewDeleteAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackViewDeleteAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackViewDeleteAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackViewDeleteAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackViewDeleteAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackViewDeleteAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackViewDeleteAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackViewDeleteAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormStackViewDeleteAdapter_013', 0, () => {
      expect(FormStackViewDeleteAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackViewDeleteAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackViewDeleteAdapter_014', 0, () => {
      expect(FormStackViewDeleteAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackViewDeleteAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackViewDeleteAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackViewDeleteAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackViewDeleteAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackViewDeleteAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackViewDeleteAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackViewDeleteAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackViewDeleteAdapter_015', 0, () => {
      expect(FormStackViewDeleteAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackViewDeleteAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackViewDeleteAdapter_016', 0, () => {
      expect(FormStackViewDeleteAdapter.isEmpty(null)).assertTrue();
      expect(FormStackViewDeleteAdapter.isEmpty(undefined)).assertTrue();
      expect(FormStackViewDeleteAdapter.isEmpty('')).assertTrue();
      expect(FormStackViewDeleteAdapter.isEmpty(0)).assertTrue();
      expect(FormStackViewDeleteAdapter.isEmpty([])).assertTrue();
      expect(FormStackViewDeleteAdapter.isEmpty(1, null)).assertTrue();
      expect(FormStackViewDeleteAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormStackViewDeleteAdapter.isEmpty(1, true)).assertTrue();
      expect(FormStackViewDeleteAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormStackViewDeleteAdapter_017', 0, () => {
      expect(FormStackViewDeleteAdapter.equals(null, 'a')).assertFalse();
      expect(FormStackViewDeleteAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormStackViewDeleteAdapter.equals('a', null)).assertFalse();
      expect(FormStackViewDeleteAdapter.equals('a', undefined)).assertFalse();
      expect(FormStackViewDeleteAdapter.equals('a', 1)).assertFalse();
      expect(FormStackViewDeleteAdapter.equals(1, 'a')).assertFalse();
      expect(FormStackViewDeleteAdapter.equals(1, [])).assertFalse();
      expect(FormStackViewDeleteAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackViewDeleteAdapter.equals([], m)).assertFalse();
      expect(FormStackViewDeleteAdapter.equals(m, [])).assertFalse();
      expect(FormStackViewDeleteAdapter.equals([1,2], [])).assertFalse();
      expect(FormStackViewDeleteAdapter.equals([], [1, 2])).assertFalse();
      expect(FormStackViewDeleteAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormStackViewDeleteAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackViewDeleteAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackViewDeleteAdapter.equals(2, 2)).assertTrue();
    })
  });
}