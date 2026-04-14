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
import { FormStackDbAdapterPc } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackDbAdapterPc';

export function FormStackDbAdapterPcTest() {
  describe('FormStackDbAdapterPcTest', () => {
    it('FormStackDbAdapterPc_001', 0, () => {
      expect(FormStackDbAdapterPc.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackDbAdapterPc.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackDbAdapterPc.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackDbAdapterPc.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackDbAdapterPc.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackDbAdapterPc.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackDbAdapterPc.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackDbAdapterPc_002', 0, () => {
      expect(FormStackDbAdapterPc.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPc.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPc.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPc.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackDbAdapterPc.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbAdapterPc.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackDbAdapterPc.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackDbAdapterPc_003', 0, () => {
      expect(FormStackDbAdapterPc.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPc.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPc.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPc.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbAdapterPc.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbAdapterPc.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackDbAdapterPc.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackDbAdapterPc_004', 0, () => {
      expect(FormStackDbAdapterPc.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPc.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPc.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPc.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbAdapterPc.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbAdapterPc.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackDbAdapterPc.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackDbAdapterPc_005', 0, () => {
      expect(FormStackDbAdapterPc.isNumber("")).assertFalse();
      expect(FormStackDbAdapterPc.isNumber(null)).assertFalse();
      expect(FormStackDbAdapterPc.isNumber(undefined)).assertFalse();
      expect(FormStackDbAdapterPc.isNumber("abc")).assertFalse();
      expect(FormStackDbAdapterPc.isNumber("123")).assertTrue();
    });

    it('FormStackDbAdapterPc_006', 0, () => {
      expect(FormStackDbAdapterPc.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackDbAdapterPc.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackDbAdapterPc.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackDbAdapterPc.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackDbAdapterPc.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackDbAdapterPc.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackDbAdapterPc_007', 0, () => {
      expect(FormStackDbAdapterPc.getDefaultId(null) === null).assertTrue();
      expect(FormStackDbAdapterPc.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackDbAdapterPc.getDefaultId('') === '').assertTrue();
      expect(FormStackDbAdapterPc.getDefaultId('default') !== '').assertTrue();
      expect(FormStackDbAdapterPc.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackDbAdapterPc.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackDbAdapterPc_008', 0, () => {
      expect(FormStackDbAdapterPc.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackDbAdapterPc.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackDbAdapterPc.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackDbAdapterPc.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackDbAdapterPc.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackDbAdapterPc.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackDbAdapterPc.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackDbAdapterPc_009', 0, () => {
      expect(FormStackDbAdapterPc.drawFontWidth() === -1).assertTrue();
      expect(FormStackDbAdapterPc.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackDbAdapterPc.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackDbAdapterPc.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackDbAdapterPc.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackDbAdapterPc.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackDbAdapterPc.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackDbAdapterPc.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackDbAdapterPc.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackDbAdapterPc.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackDbAdapterPc.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackDbAdapterPc.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackDbAdapterPc.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackDbAdapterPc.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackDbAdapterPc.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackDbAdapterPc.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackDbAdapterPc.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackDbAdapterPc.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackDbAdapterPc.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackDbAdapterPc.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackDbAdapterPc.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackDbAdapterPc.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackDbAdapterPc_010', 0, () => {
      expect(FormStackDbAdapterPc.drawTextAlign() === -1).assertTrue();
      expect(FormStackDbAdapterPc.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackDbAdapterPc.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackDbAdapterPc.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackDbAdapterPc.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackDbAdapterPc.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackDbAdapterPc.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackDbAdapterPc.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackDbAdapterPc_011', 0, () => {
      expect(FormStackDbAdapterPc.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackDbAdapterPc.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackDbAdapterPc.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackDbAdapterPc.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackDbAdapterPc.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackDbAdapterPc.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackDbAdapterPc.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackDbAdapterPc.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackDbAdapterPc.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackDbAdapterPc.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackDbAdapterPc.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackDbAdapterPc.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackDbAdapterPc.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackDbAdapterPc.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackDbAdapterPc.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackDbAdapterPc.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackDbAdapterPc.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackDbAdapterPc.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackDbAdapterPc.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackDbAdapterPc_012', 0, () => {
      expect(FormStackDbAdapterPc.checkArr([]) === false).assertTrue();
      expect(FormStackDbAdapterPc.checkArr(null) === false).assertTrue();
      expect(FormStackDbAdapterPc.checkArr(undefined) === false).assertTrue();
      expect(FormStackDbAdapterPc.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackDbAdapterPc.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackDbAdapterPc.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackDbAdapterPc.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackDbAdapterPc.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackDbAdapterPc.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackDbAdapterPc.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackDbAdapterPc.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackDbAdapterPc.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackDbAdapterPc.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackDbAdapterPc.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackDbAdapterPc.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackDbAdapterPc.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackDbAdapterPc.getUUID().length > 0).assertTrue();
    })

    it('FormStackDbAdapterPc_013', 0, () => {
      expect(FormStackDbAdapterPc.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackDbAdapterPc.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackDbAdapterPc_014', 0, () => {
      expect(FormStackDbAdapterPc.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackDbAdapterPc.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackDbAdapterPc.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackDbAdapterPc.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackDbAdapterPc.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackDbAdapterPc.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackDbAdapterPc.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackDbAdapterPc.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackDbAdapterPc_015', 0, () => {
      expect(FormStackDbAdapterPc.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackDbAdapterPc.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackDbAdapterPc.getArraySum([], null) === -1).assertTrue();
      expect(FormStackDbAdapterPc.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackDbAdapterPc.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackDbAdapterPc.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackDbAdapterPc.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackDbAdapterPc.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackDbAdapterPc.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackDbAdapterPc.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackDbAdapterPc.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackDbAdapterPc.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackDbAdapterPc_016', 0, () => {
      expect(FormStackDbAdapterPc.isEmpty(null)).assertTrue();
      expect(FormStackDbAdapterPc.isEmpty(undefined)).assertTrue();
      expect(FormStackDbAdapterPc.isEmpty('')).assertTrue();
      expect(FormStackDbAdapterPc.isEmpty(0)).assertTrue();
      expect(FormStackDbAdapterPc.isEmpty([])).assertTrue();
      expect(FormStackDbAdapterPc.isEmpty(1, null)).assertTrue();
      expect(FormStackDbAdapterPc.isEmpty(1, undefined)).assertTrue();
      expect(FormStackDbAdapterPc.isEmpty(1, true)).assertTrue();
      expect(FormStackDbAdapterPc.isEmpty(1, false)).assertFalse();
    })

    it('FormStackDbAdapterPc_017', 0, () => {
      expect(FormStackDbAdapterPc.equals(null, 'a')).assertFalse();
      expect(FormStackDbAdapterPc.equals(undefined, 'a')).assertFalse();
      expect(FormStackDbAdapterPc.equals('a', null)).assertFalse();
      expect(FormStackDbAdapterPc.equals('a', undefined)).assertFalse();
      expect(FormStackDbAdapterPc.equals('a', 1)).assertFalse();
      expect(FormStackDbAdapterPc.equals(1, 'a')).assertFalse();
      expect(FormStackDbAdapterPc.equals(1, [])).assertFalse();
      expect(FormStackDbAdapterPc.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackDbAdapterPc.equals([], m)).assertFalse();
      expect(FormStackDbAdapterPc.equals(m, [])).assertFalse();
      expect(FormStackDbAdapterPc.equals([1,2], [])).assertFalse();
      expect(FormStackDbAdapterPc.equals([], [1, 2])).assertFalse();
      expect(FormStackDbAdapterPc.equals([1], [1, 2])).assertFalse();
      expect(FormStackDbAdapterPc.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackDbAdapterPc.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackDbAdapterPc.equals(2, 2)).assertTrue();
    })
  });
}