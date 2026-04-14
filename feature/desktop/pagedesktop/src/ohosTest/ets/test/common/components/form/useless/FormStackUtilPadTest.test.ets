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
import { FormStackUtilPad } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackUtilPad';

export function FormStackUtilPadTest() {
  describe('FormStackUtilPadTest', () => {
    it('FormStackUtilPad_001', 0, () => {
      expect(FormStackUtilPad.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackUtilPad.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackUtilPad.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackUtilPad.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackUtilPad.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackUtilPad.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackUtilPad.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackUtilPad_002', 0, () => {
      expect(FormStackUtilPad.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackUtilPad.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackUtilPad.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackUtilPad.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackUtilPad.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackUtilPad.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackUtilPad.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackUtilPad_003', 0, () => {
      expect(FormStackUtilPad.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackUtilPad.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackUtilPad.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackUtilPad.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackUtilPad.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackUtilPad.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackUtilPad.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackUtilPad_004', 0, () => {
      expect(FormStackUtilPad.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackUtilPad.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackUtilPad.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackUtilPad.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackUtilPad.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackUtilPad.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackUtilPad.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackUtilPad_005', 0, () => {
      expect(FormStackUtilPad.isNumber("")).assertFalse();
      expect(FormStackUtilPad.isNumber(null)).assertFalse();
      expect(FormStackUtilPad.isNumber(undefined)).assertFalse();
      expect(FormStackUtilPad.isNumber("abc")).assertFalse();
      expect(FormStackUtilPad.isNumber("123")).assertTrue();
    });

    it('FormStackUtilPad_006', 0, () => {
      expect(FormStackUtilPad.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackUtilPad.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackUtilPad.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackUtilPad.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackUtilPad.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackUtilPad.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackUtilPad_007', 0, () => {
      expect(FormStackUtilPad.getDefaultId(null) === null).assertTrue();
      expect(FormStackUtilPad.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackUtilPad.getDefaultId('') === '').assertTrue();
      expect(FormStackUtilPad.getDefaultId('default') !== '').assertTrue();
      expect(FormStackUtilPad.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackUtilPad.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackUtilPad_008', 0, () => {
      expect(FormStackUtilPad.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackUtilPad.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackUtilPad.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackUtilPad.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackUtilPad.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackUtilPad.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackUtilPad.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackUtilPad_009', 0, () => {
      expect(FormStackUtilPad.drawFontWidth() === -1).assertTrue();
      expect(FormStackUtilPad.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackUtilPad.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackUtilPad.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackUtilPad.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackUtilPad.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackUtilPad.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackUtilPad.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackUtilPad.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackUtilPad.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackUtilPad.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackUtilPad.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackUtilPad.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackUtilPad.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackUtilPad.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackUtilPad.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackUtilPad.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackUtilPad.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackUtilPad.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackUtilPad.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackUtilPad.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackUtilPad.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackUtilPad_010', 0, () => {
      expect(FormStackUtilPad.drawTextAlign() === -1).assertTrue();
      expect(FormStackUtilPad.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackUtilPad.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackUtilPad.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackUtilPad.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackUtilPad.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackUtilPad.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackUtilPad.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackUtilPad_011', 0, () => {
      expect(FormStackUtilPad.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackUtilPad.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackUtilPad.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackUtilPad.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackUtilPad.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackUtilPad.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackUtilPad.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackUtilPad.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackUtilPad.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackUtilPad.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackUtilPad.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackUtilPad.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackUtilPad.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackUtilPad.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackUtilPad.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackUtilPad.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackUtilPad.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackUtilPad.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackUtilPad.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackUtilPad_012', 0, () => {
      expect(FormStackUtilPad.checkArr([]) === false).assertTrue();
      expect(FormStackUtilPad.checkArr(null) === false).assertTrue();
      expect(FormStackUtilPad.checkArr(undefined) === false).assertTrue();
      expect(FormStackUtilPad.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackUtilPad.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackUtilPad.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackUtilPad.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackUtilPad.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackUtilPad.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackUtilPad.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackUtilPad.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackUtilPad.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackUtilPad.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackUtilPad.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackUtilPad.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackUtilPad.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackUtilPad.getUUID().length > 0).assertTrue();
    })

    it('FormStackUtilPad_013', 0, () => {
      expect(FormStackUtilPad.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackUtilPad.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackUtilPad_014', 0, () => {
      expect(FormStackUtilPad.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackUtilPad.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackUtilPad.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackUtilPad.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackUtilPad.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackUtilPad.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackUtilPad.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackUtilPad.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackUtilPad_015', 0, () => {
      expect(FormStackUtilPad.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackUtilPad.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackUtilPad.getArraySum([], null) === -1).assertTrue();
      expect(FormStackUtilPad.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackUtilPad.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackUtilPad.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackUtilPad.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackUtilPad.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackUtilPad.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackUtilPad.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackUtilPad.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackUtilPad.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackUtilPad_016', 0, () => {
      expect(FormStackUtilPad.isEmpty(null)).assertTrue();
      expect(FormStackUtilPad.isEmpty(undefined)).assertTrue();
      expect(FormStackUtilPad.isEmpty('')).assertTrue();
      expect(FormStackUtilPad.isEmpty(0)).assertTrue();
      expect(FormStackUtilPad.isEmpty([])).assertTrue();
      expect(FormStackUtilPad.isEmpty(1, null)).assertTrue();
      expect(FormStackUtilPad.isEmpty(1, undefined)).assertTrue();
      expect(FormStackUtilPad.isEmpty(1, true)).assertTrue();
      expect(FormStackUtilPad.isEmpty(1, false)).assertFalse();
    })

    it('FormStackUtilPad_017', 0, () => {
      expect(FormStackUtilPad.equals(null, 'a')).assertFalse();
      expect(FormStackUtilPad.equals(undefined, 'a')).assertFalse();
      expect(FormStackUtilPad.equals('a', null)).assertFalse();
      expect(FormStackUtilPad.equals('a', undefined)).assertFalse();
      expect(FormStackUtilPad.equals('a', 1)).assertFalse();
      expect(FormStackUtilPad.equals(1, 'a')).assertFalse();
      expect(FormStackUtilPad.equals(1, [])).assertFalse();
      expect(FormStackUtilPad.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackUtilPad.equals([], m)).assertFalse();
      expect(FormStackUtilPad.equals(m, [])).assertFalse();
      expect(FormStackUtilPad.equals([1,2], [])).assertFalse();
      expect(FormStackUtilPad.equals([], [1, 2])).assertFalse();
      expect(FormStackUtilPad.equals([1], [1, 2])).assertFalse();
      expect(FormStackUtilPad.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackUtilPad.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackUtilPad.equals(2, 2)).assertTrue();
    })
  });
}