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
import { FormStackDbControllerPc } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackDbControllerPc';

export function FormStackDbControllerPcTest() {
  describe('FormStackDbControllerPcTest', () => {
    it('FormStackDbControllerPc_001', 0, () => {
      expect(FormStackDbControllerPc.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackDbControllerPc.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackDbControllerPc.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackDbControllerPc.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackDbControllerPc.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackDbControllerPc.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackDbControllerPc.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackDbControllerPc_002', 0, () => {
      expect(FormStackDbControllerPc.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackDbControllerPc.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackDbControllerPc.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbControllerPc.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackDbControllerPc.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbControllerPc.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackDbControllerPc.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackDbControllerPc_003', 0, () => {
      expect(FormStackDbControllerPc.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackDbControllerPc.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbControllerPc.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbControllerPc.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbControllerPc.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbControllerPc.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackDbControllerPc.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackDbControllerPc_004', 0, () => {
      expect(FormStackDbControllerPc.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackDbControllerPc.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbControllerPc.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbControllerPc.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbControllerPc.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbControllerPc.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackDbControllerPc.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackDbControllerPc_005', 0, () => {
      expect(FormStackDbControllerPc.isNumber("")).assertFalse();
      expect(FormStackDbControllerPc.isNumber(null)).assertFalse();
      expect(FormStackDbControllerPc.isNumber(undefined)).assertFalse();
      expect(FormStackDbControllerPc.isNumber("abc")).assertFalse();
      expect(FormStackDbControllerPc.isNumber("123")).assertTrue();
    });

    it('FormStackDbControllerPc_006', 0, () => {
      expect(FormStackDbControllerPc.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackDbControllerPc.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackDbControllerPc.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackDbControllerPc.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackDbControllerPc.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackDbControllerPc.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackDbControllerPc_007', 0, () => {
      expect(FormStackDbControllerPc.getDefaultId(null) === null).assertTrue();
      expect(FormStackDbControllerPc.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackDbControllerPc.getDefaultId('') === '').assertTrue();
      expect(FormStackDbControllerPc.getDefaultId('default') !== '').assertTrue();
      expect(FormStackDbControllerPc.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackDbControllerPc.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackDbControllerPc_008', 0, () => {
      expect(FormStackDbControllerPc.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackDbControllerPc.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackDbControllerPc.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackDbControllerPc.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackDbControllerPc.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackDbControllerPc.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackDbControllerPc.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackDbControllerPc_009', 0, () => {
      expect(FormStackDbControllerPc.drawFontWidth() === -1).assertTrue();
      expect(FormStackDbControllerPc.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackDbControllerPc.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackDbControllerPc.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackDbControllerPc.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackDbControllerPc.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackDbControllerPc.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackDbControllerPc.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackDbControllerPc.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackDbControllerPc.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackDbControllerPc.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackDbControllerPc.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackDbControllerPc.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackDbControllerPc.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackDbControllerPc.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackDbControllerPc.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackDbControllerPc.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackDbControllerPc.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackDbControllerPc.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackDbControllerPc.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackDbControllerPc.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackDbControllerPc.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackDbControllerPc_010', 0, () => {
      expect(FormStackDbControllerPc.drawTextAlign() === -1).assertTrue();
      expect(FormStackDbControllerPc.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackDbControllerPc.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackDbControllerPc.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackDbControllerPc.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackDbControllerPc.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackDbControllerPc.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackDbControllerPc.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackDbControllerPc_011', 0, () => {
      expect(FormStackDbControllerPc.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackDbControllerPc.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackDbControllerPc.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackDbControllerPc.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackDbControllerPc.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackDbControllerPc.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackDbControllerPc.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackDbControllerPc.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackDbControllerPc.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackDbControllerPc.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackDbControllerPc.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackDbControllerPc.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackDbControllerPc.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackDbControllerPc.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackDbControllerPc.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackDbControllerPc.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackDbControllerPc.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackDbControllerPc.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackDbControllerPc.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackDbControllerPc_012', 0, () => {
      expect(FormStackDbControllerPc.checkArr([]) === false).assertTrue();
      expect(FormStackDbControllerPc.checkArr(null) === false).assertTrue();
      expect(FormStackDbControllerPc.checkArr(undefined) === false).assertTrue();
      expect(FormStackDbControllerPc.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackDbControllerPc.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackDbControllerPc.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackDbControllerPc.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackDbControllerPc.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackDbControllerPc.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackDbControllerPc.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackDbControllerPc.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackDbControllerPc.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackDbControllerPc.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackDbControllerPc.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackDbControllerPc.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackDbControllerPc.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackDbControllerPc.getUUID().length > 0).assertTrue();
    })

    it('FormStackDbControllerPc_013', 0, () => {
      expect(FormStackDbControllerPc.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackDbControllerPc.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackDbControllerPc_014', 0, () => {
      expect(FormStackDbControllerPc.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackDbControllerPc.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackDbControllerPc.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackDbControllerPc.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackDbControllerPc.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackDbControllerPc.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackDbControllerPc.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackDbControllerPc.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackDbControllerPc_015', 0, () => {
      expect(FormStackDbControllerPc.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackDbControllerPc.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackDbControllerPc.getArraySum([], null) === -1).assertTrue();
      expect(FormStackDbControllerPc.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackDbControllerPc.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackDbControllerPc.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackDbControllerPc.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackDbControllerPc.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackDbControllerPc.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackDbControllerPc.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackDbControllerPc.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackDbControllerPc.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackDbControllerPc_016', 0, () => {
      expect(FormStackDbControllerPc.isEmpty(null)).assertTrue();
      expect(FormStackDbControllerPc.isEmpty(undefined)).assertTrue();
      expect(FormStackDbControllerPc.isEmpty('')).assertTrue();
      expect(FormStackDbControllerPc.isEmpty(0)).assertTrue();
      expect(FormStackDbControllerPc.isEmpty([])).assertTrue();
      expect(FormStackDbControllerPc.isEmpty(1, null)).assertTrue();
      expect(FormStackDbControllerPc.isEmpty(1, undefined)).assertTrue();
      expect(FormStackDbControllerPc.isEmpty(1, true)).assertTrue();
      expect(FormStackDbControllerPc.isEmpty(1, false)).assertFalse();
    })

    it('FormStackDbControllerPc_017', 0, () => {
      expect(FormStackDbControllerPc.equals(null, 'a')).assertFalse();
      expect(FormStackDbControllerPc.equals(undefined, 'a')).assertFalse();
      expect(FormStackDbControllerPc.equals('a', null)).assertFalse();
      expect(FormStackDbControllerPc.equals('a', undefined)).assertFalse();
      expect(FormStackDbControllerPc.equals('a', 1)).assertFalse();
      expect(FormStackDbControllerPc.equals(1, 'a')).assertFalse();
      expect(FormStackDbControllerPc.equals(1, [])).assertFalse();
      expect(FormStackDbControllerPc.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackDbControllerPc.equals([], m)).assertFalse();
      expect(FormStackDbControllerPc.equals(m, [])).assertFalse();
      expect(FormStackDbControllerPc.equals([1,2], [])).assertFalse();
      expect(FormStackDbControllerPc.equals([], [1, 2])).assertFalse();
      expect(FormStackDbControllerPc.equals([1], [1, 2])).assertFalse();
      expect(FormStackDbControllerPc.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackDbControllerPc.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackDbControllerPc.equals(2, 2)).assertTrue();
    })
  });
}