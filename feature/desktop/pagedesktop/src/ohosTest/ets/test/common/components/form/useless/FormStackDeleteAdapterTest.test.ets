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
import { FormStackDeleteAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackDeleteAdapter';

export function FormStackDeleteAdapterTest() {
  describe('FormStackDeleteAdapterTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackDeleteAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackDeleteAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackDeleteAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackDeleteAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackDeleteAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackDeleteAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackDeleteAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackDeleteAdapter_002', 0, () => {
      expect(FormStackDeleteAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackDeleteAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackDeleteAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackDeleteAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackDeleteAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackDeleteAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackDeleteAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackDeleteAdapter_003', 0, () => {
      expect(FormStackDeleteAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackDeleteAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackDeleteAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDeleteAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDeleteAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDeleteAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackDeleteAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackDeleteAdapter_004', 0, () => {
      expect(FormStackDeleteAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackDeleteAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackDeleteAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDeleteAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDeleteAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDeleteAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackDeleteAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackDeleteAdapter_005', 0, () => {
      expect(FormStackDeleteAdapter.isNumber("")).assertFalse();
      expect(FormStackDeleteAdapter.isNumber(null)).assertFalse();
      expect(FormStackDeleteAdapter.isNumber(undefined)).assertFalse();
      expect(FormStackDeleteAdapter.isNumber("abc")).assertFalse();
      expect(FormStackDeleteAdapter.isNumber("123")).assertTrue();
    });

    it('FormStackDeleteAdapter_006', 0, () => {
      expect(FormStackDeleteAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackDeleteAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackDeleteAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackDeleteAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackDeleteAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackDeleteAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackDeleteAdapter_007', 0, () => {
      expect(FormStackDeleteAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormStackDeleteAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackDeleteAdapter.getDefaultId('') === '').assertTrue();
      expect(FormStackDeleteAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormStackDeleteAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackDeleteAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackDeleteAdapter_008', 0, () => {
      expect(FormStackDeleteAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackDeleteAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackDeleteAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackDeleteAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackDeleteAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackDeleteAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackDeleteAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackDeleteAdapter_009', 0, () => {
      expect(FormStackDeleteAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormStackDeleteAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackDeleteAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackDeleteAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackDeleteAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackDeleteAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackDeleteAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackDeleteAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackDeleteAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackDeleteAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackDeleteAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackDeleteAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackDeleteAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackDeleteAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackDeleteAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackDeleteAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackDeleteAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackDeleteAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackDeleteAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackDeleteAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackDeleteAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackDeleteAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackDeleteAdapter_010', 0, () => {
      expect(FormStackDeleteAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormStackDeleteAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackDeleteAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackDeleteAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackDeleteAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackDeleteAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackDeleteAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackDeleteAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackDeleteAdapter_011', 0, () => {
      expect(FormStackDeleteAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackDeleteAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackDeleteAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackDeleteAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackDeleteAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackDeleteAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackDeleteAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackDeleteAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackDeleteAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackDeleteAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackDeleteAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackDeleteAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackDeleteAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackDeleteAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackDeleteAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackDeleteAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackDeleteAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackDeleteAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackDeleteAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackDeleteAdapter_012', 0, () => {
      expect(FormStackDeleteAdapter.checkArr([]) === false).assertTrue();
      expect(FormStackDeleteAdapter.checkArr(null) === false).assertTrue();
      expect(FormStackDeleteAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormStackDeleteAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackDeleteAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackDeleteAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackDeleteAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackDeleteAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackDeleteAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackDeleteAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackDeleteAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackDeleteAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackDeleteAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackDeleteAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackDeleteAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackDeleteAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackDeleteAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormStackDeleteAdapter_013', 0, () => {
      expect(FormStackDeleteAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackDeleteAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackDeleteAdapter_014', 0, () => {
      expect(FormStackDeleteAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackDeleteAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackDeleteAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackDeleteAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackDeleteAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackDeleteAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackDeleteAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackDeleteAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackDeleteAdapter_015', 0, () => {
      expect(FormStackDeleteAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackDeleteAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackDeleteAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormStackDeleteAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackDeleteAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackDeleteAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackDeleteAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackDeleteAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackDeleteAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackDeleteAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackDeleteAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackDeleteAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackDeleteAdapter_016', 0, () => {
      expect(FormStackDeleteAdapter.isEmpty(null)).assertTrue();
      expect(FormStackDeleteAdapter.isEmpty(undefined)).assertTrue();
      expect(FormStackDeleteAdapter.isEmpty('')).assertTrue();
      expect(FormStackDeleteAdapter.isEmpty(0)).assertTrue();
      expect(FormStackDeleteAdapter.isEmpty([])).assertTrue();
      expect(FormStackDeleteAdapter.isEmpty(1, null)).assertTrue();
      expect(FormStackDeleteAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormStackDeleteAdapter.isEmpty(1, true)).assertTrue();
      expect(FormStackDeleteAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormStackDeleteAdapter_017', 0, () => {
      expect(FormStackDeleteAdapter.equals(null, 'a')).assertFalse();
      expect(FormStackDeleteAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormStackDeleteAdapter.equals('a', null)).assertFalse();
      expect(FormStackDeleteAdapter.equals('a', undefined)).assertFalse();
      expect(FormStackDeleteAdapter.equals('a', 1)).assertFalse();
      expect(FormStackDeleteAdapter.equals(1, 'a')).assertFalse();
      expect(FormStackDeleteAdapter.equals(1, [])).assertFalse();
      expect(FormStackDeleteAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackDeleteAdapter.equals([], m)).assertFalse();
      expect(FormStackDeleteAdapter.equals(m, [])).assertFalse();
      expect(FormStackDeleteAdapter.equals([1,2], [])).assertFalse();
      expect(FormStackDeleteAdapter.equals([], [1, 2])).assertFalse();
      expect(FormStackDeleteAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormStackDeleteAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackDeleteAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackDeleteAdapter.equals(2, 2)).assertTrue();
    })
  });
}