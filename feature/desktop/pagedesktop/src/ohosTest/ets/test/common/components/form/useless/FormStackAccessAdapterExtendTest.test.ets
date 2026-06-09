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
import { FormStackAccessAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackAccessAdapter';

export function FormStackAccessAdapterExtendTest() {
  describe('FormStackAccessAdapterExtendTest', () => {
    it('FormStackAccessAdapter_001', 0, () => {
      expect(FormStackAccessAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackAccessAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackAccessAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackAccessAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackAccessAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackAccessAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackAccessAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackAccessAdapter_002', 0, () => {
      expect(FormStackAccessAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackAccessAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackAccessAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackAccessAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackAccessAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackAccessAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackAccessAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackAccessAdapter_003', 0, () => {
      expect(FormStackAccessAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackAccessAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackAccessAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAccessAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAccessAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAccessAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackAccessAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackAccessAdapter_004', 0, () => {
      expect(FormStackAccessAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackAccessAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackAccessAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAccessAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAccessAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAccessAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackAccessAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackAccessAdapter_005', 0, () => {
      expect(FormStackAccessAdapter.isNumber("")).assertFalse();
      expect(FormStackAccessAdapter.isNumber(null)).assertFalse();
      expect(FormStackAccessAdapter.isNumber(undefined)).assertFalse();
      expect(FormStackAccessAdapter.isNumber("abc")).assertFalse();
      expect(FormStackAccessAdapter.isNumber("123")).assertTrue();
    });

    it('FormStackAccessAdapter_006', 0, () => {
      expect(FormStackAccessAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackAccessAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackAccessAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackAccessAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackAccessAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackAccessAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackAccessAdapter_007', 0, () => {
      expect(FormStackAccessAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormStackAccessAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackAccessAdapter.getDefaultId('') === '').assertTrue();
      expect(FormStackAccessAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormStackAccessAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackAccessAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackAccessAdapter_008', 0, () => {
      expect(FormStackAccessAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackAccessAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackAccessAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackAccessAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackAccessAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackAccessAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackAccessAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackAccessAdapter_009', 0, () => {
      expect(FormStackAccessAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormStackAccessAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackAccessAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackAccessAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackAccessAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackAccessAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackAccessAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackAccessAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackAccessAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackAccessAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackAccessAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackAccessAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackAccessAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackAccessAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackAccessAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackAccessAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackAccessAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackAccessAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackAccessAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackAccessAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackAccessAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackAccessAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackAccessAdapter_010', 0, () => {
      expect(FormStackAccessAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormStackAccessAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackAccessAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackAccessAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackAccessAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackAccessAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackAccessAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackAccessAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackAccessAdapter_011', 0, () => {
      expect(FormStackAccessAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackAccessAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackAccessAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackAccessAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackAccessAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackAccessAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackAccessAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackAccessAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackAccessAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackAccessAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackAccessAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackAccessAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackAccessAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackAccessAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackAccessAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackAccessAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackAccessAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackAccessAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackAccessAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackAccessAdapter_012', 0, () => {
      expect(FormStackAccessAdapter.checkArr([]) === false).assertTrue();
      expect(FormStackAccessAdapter.checkArr(null) === false).assertTrue();
      expect(FormStackAccessAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormStackAccessAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackAccessAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackAccessAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackAccessAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackAccessAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackAccessAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackAccessAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackAccessAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackAccessAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackAccessAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackAccessAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackAccessAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackAccessAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackAccessAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormStackAccessAdapter_013', 0, () => {
      expect(FormStackAccessAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackAccessAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackAccessAdapter_014', 0, () => {
      expect(FormStackAccessAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackAccessAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackAccessAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackAccessAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackAccessAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackAccessAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackAccessAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackAccessAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackAccessAdapter_015', 0, () => {
      expect(FormStackAccessAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackAccessAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackAccessAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormStackAccessAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackAccessAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackAccessAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackAccessAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackAccessAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackAccessAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackAccessAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackAccessAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackAccessAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackAccessAdapter_016', 0, () => {
      expect(FormStackAccessAdapter.isEmpty(null)).assertTrue();
      expect(FormStackAccessAdapter.isEmpty(undefined)).assertTrue();
      expect(FormStackAccessAdapter.isEmpty('')).assertTrue();
      expect(FormStackAccessAdapter.isEmpty(0)).assertTrue();
      expect(FormStackAccessAdapter.isEmpty([])).assertTrue();
      expect(FormStackAccessAdapter.isEmpty(1, null)).assertTrue();
      expect(FormStackAccessAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormStackAccessAdapter.isEmpty(1, true)).assertTrue();
      expect(FormStackAccessAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormStackAccessAdapter_017', 0, () => {
      expect(FormStackAccessAdapter.equals(null, 'a')).assertFalse();
      expect(FormStackAccessAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormStackAccessAdapter.equals('a', null)).assertFalse();
      expect(FormStackAccessAdapter.equals('a', undefined)).assertFalse();
      expect(FormStackAccessAdapter.equals('a', 1)).assertFalse();
      expect(FormStackAccessAdapter.equals(1, 'a')).assertFalse();
      expect(FormStackAccessAdapter.equals(1, [])).assertFalse();
      expect(FormStackAccessAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackAccessAdapter.equals([], m)).assertFalse();
      expect(FormStackAccessAdapter.equals(m, [])).assertFalse();
      expect(FormStackAccessAdapter.equals([1,2], [])).assertFalse();
      expect(FormStackAccessAdapter.equals([], [1, 2])).assertFalse();
      expect(FormStackAccessAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormStackAccessAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackAccessAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackAccessAdapter.equals(2, 2)).assertTrue();
    })
  });
}