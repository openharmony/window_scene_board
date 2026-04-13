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
import { FormStackDbControllerPad } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackDbControllerPad';

export function FormStackDbControllerPadTest() {
  describe('FormStackDbControllerPadTest', () => {
    it('FormStackDbControllerPad_001', 0, () => {
      expect(FormStackDbControllerPad.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackDbControllerPad.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackDbControllerPad.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackDbControllerPad.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackDbControllerPad.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackDbControllerPad.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackDbControllerPad.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackDbControllerPad_002', 0, () => {
      expect(FormStackDbControllerPad.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackDbControllerPad.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackDbControllerPad.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbControllerPad.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackDbControllerPad.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbControllerPad.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackDbControllerPad.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackDbControllerPad_003', 0, () => {
      expect(FormStackDbControllerPad.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackDbControllerPad.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbControllerPad.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbControllerPad.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbControllerPad.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbControllerPad.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackDbControllerPad.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackDbControllerPad_004', 0, () => {
      expect(FormStackDbControllerPad.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackDbControllerPad.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbControllerPad.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbControllerPad.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbControllerPad.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbControllerPad.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackDbControllerPad.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackDbControllerPad_005', 0, () => {
      expect(FormStackDbControllerPad.isNumber("")).assertFalse();
      expect(FormStackDbControllerPad.isNumber(null)).assertFalse();
      expect(FormStackDbControllerPad.isNumber(undefined)).assertFalse();
      expect(FormStackDbControllerPad.isNumber("abc")).assertFalse();
      expect(FormStackDbControllerPad.isNumber("123")).assertTrue();
    });

    it('FormStackDbControllerPad_006', 0, () => {
      expect(FormStackDbControllerPad.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackDbControllerPad.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackDbControllerPad.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackDbControllerPad.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackDbControllerPad.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackDbControllerPad.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackDbControllerPad_007', 0, () => {
      expect(FormStackDbControllerPad.getDefaultId(null) === null).assertTrue();
      expect(FormStackDbControllerPad.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackDbControllerPad.getDefaultId('') === '').assertTrue();
      expect(FormStackDbControllerPad.getDefaultId('default') !== '').assertTrue();
      expect(FormStackDbControllerPad.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackDbControllerPad.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackDbControllerPad_008', 0, () => {
      expect(FormStackDbControllerPad.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackDbControllerPad.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackDbControllerPad.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackDbControllerPad.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackDbControllerPad.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackDbControllerPad.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackDbControllerPad.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackDbControllerPad_009', 0, () => {
      expect(FormStackDbControllerPad.drawFontWidth() === -1).assertTrue();
      expect(FormStackDbControllerPad.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackDbControllerPad.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackDbControllerPad.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackDbControllerPad.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackDbControllerPad.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackDbControllerPad.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackDbControllerPad.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackDbControllerPad.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackDbControllerPad.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackDbControllerPad.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackDbControllerPad.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackDbControllerPad.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackDbControllerPad.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackDbControllerPad.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackDbControllerPad.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackDbControllerPad.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackDbControllerPad.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackDbControllerPad.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackDbControllerPad.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackDbControllerPad.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackDbControllerPad.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackDbControllerPad_010', 0, () => {
      expect(FormStackDbControllerPad.drawTextAlign() === -1).assertTrue();
      expect(FormStackDbControllerPad.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackDbControllerPad.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackDbControllerPad.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackDbControllerPad.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackDbControllerPad.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackDbControllerPad.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackDbControllerPad.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackDbControllerPad_011', 0, () => {
      expect(FormStackDbControllerPad.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackDbControllerPad.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackDbControllerPad.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackDbControllerPad.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackDbControllerPad.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackDbControllerPad.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackDbControllerPad.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackDbControllerPad.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackDbControllerPad.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackDbControllerPad.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackDbControllerPad.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackDbControllerPad.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackDbControllerPad.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackDbControllerPad.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackDbControllerPad.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackDbControllerPad.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackDbControllerPad.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackDbControllerPad.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackDbControllerPad.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackDbControllerPad_012', 0, () => {
      expect(FormStackDbControllerPad.checkArr([]) === false).assertTrue();
      expect(FormStackDbControllerPad.checkArr(null) === false).assertTrue();
      expect(FormStackDbControllerPad.checkArr(undefined) === false).assertTrue();
      expect(FormStackDbControllerPad.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackDbControllerPad.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackDbControllerPad.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackDbControllerPad.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackDbControllerPad.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackDbControllerPad.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackDbControllerPad.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackDbControllerPad.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackDbControllerPad.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackDbControllerPad.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackDbControllerPad.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackDbControllerPad.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackDbControllerPad.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackDbControllerPad.getUUID().length > 0).assertTrue();
    })

    it('FormStackDbControllerPad_013', 0, () => {
      expect(FormStackDbControllerPad.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackDbControllerPad.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackDbControllerPad_014', 0, () => {
      expect(FormStackDbControllerPad.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackDbControllerPad.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackDbControllerPad.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackDbControllerPad.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackDbControllerPad.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackDbControllerPad.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackDbControllerPad.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackDbControllerPad.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackDbControllerPad_015', 0, () => {
      expect(FormStackDbControllerPad.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackDbControllerPad.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackDbControllerPad.getArraySum([], null) === -1).assertTrue();
      expect(FormStackDbControllerPad.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackDbControllerPad.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackDbControllerPad.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackDbControllerPad.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackDbControllerPad.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackDbControllerPad.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackDbControllerPad.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackDbControllerPad.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackDbControllerPad.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackDbControllerPad_016', 0, () => {
      expect(FormStackDbControllerPad.isEmpty(null)).assertTrue();
      expect(FormStackDbControllerPad.isEmpty(undefined)).assertTrue();
      expect(FormStackDbControllerPad.isEmpty('')).assertTrue();
      expect(FormStackDbControllerPad.isEmpty(0)).assertTrue();
      expect(FormStackDbControllerPad.isEmpty([])).assertTrue();
      expect(FormStackDbControllerPad.isEmpty(1, null)).assertTrue();
      expect(FormStackDbControllerPad.isEmpty(1, undefined)).assertTrue();
      expect(FormStackDbControllerPad.isEmpty(1, true)).assertTrue();
      expect(FormStackDbControllerPad.isEmpty(1, false)).assertFalse();
    })

    it('FormStackDbControllerPad_017', 0, () => {
      expect(FormStackDbControllerPad.equals(null, 'a')).assertFalse();
      expect(FormStackDbControllerPad.equals(undefined, 'a')).assertFalse();
      expect(FormStackDbControllerPad.equals('a', null)).assertFalse();
      expect(FormStackDbControllerPad.equals('a', undefined)).assertFalse();
      expect(FormStackDbControllerPad.equals('a', 1)).assertFalse();
      expect(FormStackDbControllerPad.equals(1, 'a')).assertFalse();
      expect(FormStackDbControllerPad.equals(1, [])).assertFalse();
      expect(FormStackDbControllerPad.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackDbControllerPad.equals([], m)).assertFalse();
      expect(FormStackDbControllerPad.equals(m, [])).assertFalse();
      expect(FormStackDbControllerPad.equals([1,2], [])).assertFalse();
      expect(FormStackDbControllerPad.equals([], [1, 2])).assertFalse();
      expect(FormStackDbControllerPad.equals([1], [1, 2])).assertFalse();
      expect(FormStackDbControllerPad.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackDbControllerPad.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackDbControllerPad.equals(2, 2)).assertTrue();
    })
  });
}