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
import { FormStackAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackAdapter';

export function FormStackAdapterTest() {
  describe('FormStackAdapterTest', () => {
    it('FormStackAdapter_001', 0,() => {
      expect(FormStackAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackAdapter_002', 0, () => {
      expect(FormStackAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackAdapter_003', 0, () => {
      expect(FormStackAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackAdapter_004', 0, () => {
      expect(FormStackAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackAdapter_005', 0, () => {
      expect(FormStackAdapter.isNumber("")).assertFalse();
      expect(FormStackAdapter.isNumber(null)).assertFalse();
      expect(FormStackAdapter.isNumber(undefined)).assertFalse();
      expect(FormStackAdapter.isNumber("abc")).assertFalse();
      expect(FormStackAdapter.isNumber("123")).assertTrue();
    });

    it('FormStackAdapter_006', 0, () => {
      expect(FormStackAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackAdapter_007', 0, () => {
      expect(FormStackAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormStackAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackAdapter.getDefaultId('') === '').assertTrue();
      expect(FormStackAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormStackAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackAdapter_008', 0, () => {
      expect(FormStackAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackAdapter_009', 0, () => {
      expect(FormStackAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormStackAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackAdapter_010', 0, () => {
      expect(FormStackAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormStackAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackAdapter_011', 0, () => {
      expect(FormStackAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackAdapter_012', 0, () => {
      expect(FormStackAdapter.checkArr([]) === false).assertTrue();
      expect(FormStackAdapter.checkArr(null) === false).assertTrue();
      expect(FormStackAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormStackAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormStackAdapter_013', 0, () => {
      expect(FormStackAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackAdapter_014', 0, () => {
      expect(FormStackAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackAdapter_015', 0, () => {
      expect(FormStackAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormStackAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackAdapter_016', 0, () => {
      expect(FormStackAdapter.isEmpty(null)).assertTrue();
      expect(FormStackAdapter.isEmpty(undefined)).assertTrue();
      expect(FormStackAdapter.isEmpty('')).assertTrue();
      expect(FormStackAdapter.isEmpty(0)).assertTrue();
      expect(FormStackAdapter.isEmpty([])).assertTrue();
      expect(FormStackAdapter.isEmpty(1, null)).assertTrue();
      expect(FormStackAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormStackAdapter.isEmpty(1, true)).assertTrue();
      expect(FormStackAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormStackAdapter_017', 0, () => {
      expect(FormStackAdapter.equals(null, 'a')).assertFalse();
      expect(FormStackAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormStackAdapter.equals('a', null)).assertFalse();
      expect(FormStackAdapter.equals('a', undefined)).assertFalse();
      expect(FormStackAdapter.equals('a', 1)).assertFalse();
      expect(FormStackAdapter.equals(1, 'a')).assertFalse();
      expect(FormStackAdapter.equals(1, [])).assertFalse();
      expect(FormStackAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackAdapter.equals([], m)).assertFalse();
      expect(FormStackAdapter.equals(m, [])).assertFalse();
      expect(FormStackAdapter.equals([1,2], [])).assertFalse();
      expect(FormStackAdapter.equals([], [1, 2])).assertFalse();
      expect(FormStackAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormStackAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackAdapter.equals(2, 2)).assertTrue();
    })
  });
}