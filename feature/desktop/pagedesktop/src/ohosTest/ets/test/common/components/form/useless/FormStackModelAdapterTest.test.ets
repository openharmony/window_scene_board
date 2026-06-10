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
import { FormStackModelAdapter } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackModelAdapter';

export function FormStackModelAdapterTest() {
  describe('FormStackModelAdapterTest', () => {
    it('FormStackModelAdapter_001', 0, () => {
      expect(FormStackModelAdapter.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackModelAdapter.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackModelAdapter.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackModelAdapter.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackModelAdapter.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackModelAdapter.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackModelAdapter.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackModelAdapter_002', 0, () => {
      expect(FormStackModelAdapter.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackModelAdapter.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackModelAdapter.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackModelAdapter.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackModelAdapter.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackModelAdapter.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackModelAdapter.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackModelAdapter_003', 0, () => {
      expect(FormStackModelAdapter.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackModelAdapter.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackModelAdapter.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackModelAdapter.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackModelAdapter.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackModelAdapter.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackModelAdapter.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackModelAdapter_004', 0, () => {
      expect(FormStackModelAdapter.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackModelAdapter.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackModelAdapter.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackModelAdapter.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackModelAdapter.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackModelAdapter.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackModelAdapter.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackModelAdapter_005', 0, () => {
      expect(FormStackModelAdapter.isNumber("")).assertFalse();
      expect(FormStackModelAdapter.isNumber(null)).assertFalse();
      expect(FormStackModelAdapter.isNumber(undefined)).assertFalse();
      expect(FormStackModelAdapter.isNumber("abc")).assertFalse();
      expect(FormStackModelAdapter.isNumber("123")).assertTrue();
    });

    it('FormStackModelAdapter_006', 0, () => {
      expect(FormStackModelAdapter.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackModelAdapter.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackModelAdapter.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackModelAdapter.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackModelAdapter.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackModelAdapter.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackModelAdapter_007', 0, () => {
      expect(FormStackModelAdapter.getDefaultId(null) === null).assertTrue();
      expect(FormStackModelAdapter.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackModelAdapter.getDefaultId('') === '').assertTrue();
      expect(FormStackModelAdapter.getDefaultId('default') !== '').assertTrue();
      expect(FormStackModelAdapter.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackModelAdapter.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackModelAdapter_008', 0, () => {
      expect(FormStackModelAdapter.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackModelAdapter.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackModelAdapter.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackModelAdapter.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackModelAdapter.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackModelAdapter.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackModelAdapter.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackModelAdapter_009', 0, () => {
      expect(FormStackModelAdapter.drawFontWidth() === -1).assertTrue();
      expect(FormStackModelAdapter.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackModelAdapter.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackModelAdapter.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackModelAdapter.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackModelAdapter.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackModelAdapter.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackModelAdapter.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackModelAdapter.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackModelAdapter.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackModelAdapter.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackModelAdapter.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackModelAdapter.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackModelAdapter.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackModelAdapter.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackModelAdapter.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackModelAdapter.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackModelAdapter.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackModelAdapter.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackModelAdapter.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackModelAdapter.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackModelAdapter.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackModelAdapter_010', 0, () => {
      expect(FormStackModelAdapter.drawTextAlign() === -1).assertTrue();
      expect(FormStackModelAdapter.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackModelAdapter.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackModelAdapter.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackModelAdapter.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackModelAdapter.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackModelAdapter.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackModelAdapter.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackModelAdapter_011', 0, () => {
      expect(FormStackModelAdapter.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackModelAdapter.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackModelAdapter.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackModelAdapter.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackModelAdapter.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackModelAdapter.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackModelAdapter.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackModelAdapter.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackModelAdapter.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackModelAdapter.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackModelAdapter.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackModelAdapter.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackModelAdapter.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackModelAdapter.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackModelAdapter.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackModelAdapter.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackModelAdapter.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackModelAdapter.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackModelAdapter.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackModelAdapter_012', 0, () => {
      expect(FormStackModelAdapter.checkArr([]) === false).assertTrue();
      expect(FormStackModelAdapter.checkArr(null) === false).assertTrue();
      expect(FormStackModelAdapter.checkArr(undefined) === false).assertTrue();
      expect(FormStackModelAdapter.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackModelAdapter.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackModelAdapter.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackModelAdapter.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackModelAdapter.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackModelAdapter.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackModelAdapter.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackModelAdapter.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackModelAdapter.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackModelAdapter.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackModelAdapter.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackModelAdapter.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackModelAdapter.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackModelAdapter.getUUID().length > 0).assertTrue();
    })

    it('FormStackModelAdapter_013', 0, () => {
      expect(FormStackModelAdapter.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackModelAdapter.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackModelAdapter_014', 0, () => {
      expect(FormStackModelAdapter.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackModelAdapter.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackModelAdapter.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackModelAdapter.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackModelAdapter.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackModelAdapter.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackModelAdapter.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackModelAdapter.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackModelAdapter_015', 0, () => {
      expect(FormStackModelAdapter.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackModelAdapter.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackModelAdapter.getArraySum([], null) === -1).assertTrue();
      expect(FormStackModelAdapter.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackModelAdapter.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackModelAdapter.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackModelAdapter.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackModelAdapter.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackModelAdapter.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackModelAdapter.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackModelAdapter.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackModelAdapter.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackModelAdapter_016', 0, () => {
      expect(FormStackModelAdapter.isEmpty(null)).assertTrue();
      expect(FormStackModelAdapter.isEmpty(undefined)).assertTrue();
      expect(FormStackModelAdapter.isEmpty('')).assertTrue();
      expect(FormStackModelAdapter.isEmpty(0)).assertTrue();
      expect(FormStackModelAdapter.isEmpty([])).assertTrue();
      expect(FormStackModelAdapter.isEmpty(1, null)).assertTrue();
      expect(FormStackModelAdapter.isEmpty(1, undefined)).assertTrue();
      expect(FormStackModelAdapter.isEmpty(1, true)).assertTrue();
      expect(FormStackModelAdapter.isEmpty(1, false)).assertFalse();
    })

    it('FormStackModelAdapter_017', 0, () => {
      expect(FormStackModelAdapter.equals(null, 'a')).assertFalse();
      expect(FormStackModelAdapter.equals(undefined, 'a')).assertFalse();
      expect(FormStackModelAdapter.equals('a', null)).assertFalse();
      expect(FormStackModelAdapter.equals('a', undefined)).assertFalse();
      expect(FormStackModelAdapter.equals('a', 1)).assertFalse();
      expect(FormStackModelAdapter.equals(1, 'a')).assertFalse();
      expect(FormStackModelAdapter.equals(1, [])).assertFalse();
      expect(FormStackModelAdapter.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackModelAdapter.equals([], m)).assertFalse();
      expect(FormStackModelAdapter.equals(m, [])).assertFalse();
      expect(FormStackModelAdapter.equals([1,2], [])).assertFalse();
      expect(FormStackModelAdapter.equals([], [1, 2])).assertFalse();
      expect(FormStackModelAdapter.equals([1], [1, 2])).assertFalse();
      expect(FormStackModelAdapter.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackModelAdapter.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackModelAdapter.equals(2, 2)).assertTrue();
    })
  });
}