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
import { FormCommonControllerCardRadios } from '../../../../../../../main/ets/default/common/components/form/useless/FormCommonControllerCardRadios';

export function FormCommonControllerCardRadiosTest() {
  describe('FormCommonControllerCardRadiosTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormCommonControllerCardRadios.getSum("", '1') === -1).assertEqual(true);
      expect(FormCommonControllerCardRadios.getSum(null, '1') === -1).assertEqual(true);
      expect(FormCommonControllerCardRadios.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormCommonControllerCardRadios.getSum('1', '') === -1).assertEqual(true);
      expect(FormCommonControllerCardRadios.getSum('1', null) === -1).assertEqual(true);
      expect(FormCommonControllerCardRadios.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormCommonControllerCardRadios.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormCommonControllerCardRadios_002', 0, () => {
      expect(FormCommonControllerCardRadios.stringToArray("", ",").length === 0).assertTrue();
      expect(FormCommonControllerCardRadios.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormCommonControllerCardRadios.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormCommonControllerCardRadios.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormCommonControllerCardRadios.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormCommonControllerCardRadios.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormCommonControllerCardRadios.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormCommonControllerCardRadios_003', 0, () => {
      expect(FormCommonControllerCardRadios.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormCommonControllerCardRadios.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormCommonControllerCardRadios.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormCommonControllerCardRadios.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormCommonControllerCardRadios.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormCommonControllerCardRadios.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormCommonControllerCardRadios.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormCommonControllerCardRadios_004', 0, () => {
      expect(FormCommonControllerCardRadios.getIntValues("", ",").length === 0).assertTrue();
      expect(FormCommonControllerCardRadios.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormCommonControllerCardRadios.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormCommonControllerCardRadios.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormCommonControllerCardRadios.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormCommonControllerCardRadios.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormCommonControllerCardRadios.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormCommonControllerCardRadios_005', 0, () => {
      expect(FormCommonControllerCardRadios.isNumber("")).assertFalse();
      expect(FormCommonControllerCardRadios.isNumber(null)).assertFalse();
      expect(FormCommonControllerCardRadios.isNumber(undefined)).assertFalse();
      expect(FormCommonControllerCardRadios.isNumber("abc")).assertFalse();
      expect(FormCommonControllerCardRadios.isNumber("123")).assertTrue();
    });

    it('FormCommonControllerCardRadios_006', 0, () => {
      expect(FormCommonControllerCardRadios.getStrByCount(null , 1) === '').assertTrue();
      expect(FormCommonControllerCardRadios.getStrByCount('' , 1) === '').assertTrue();
      expect(FormCommonControllerCardRadios.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormCommonControllerCardRadios.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormCommonControllerCardRadios.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormCommonControllerCardRadios.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormCommonControllerCardRadios_007', 0, () => {
      expect(FormCommonControllerCardRadios.getDefaultId(null) === null).assertTrue();
      expect(FormCommonControllerCardRadios.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormCommonControllerCardRadios.getDefaultId('') === '').assertTrue();
      expect(FormCommonControllerCardRadios.getDefaultId('default') !== '').assertTrue();
      expect(FormCommonControllerCardRadios.getDefaultId('aaa') !== '').assertTrue();
      expect(FormCommonControllerCardRadios.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormCommonControllerCardRadios_008', 0, () => {
      expect(FormCommonControllerCardRadios.getIndexByString("", []) === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getIndexByString(null, []) === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormCommonControllerCardRadios_009', 0, () => {
      expect(FormCommonControllerCardRadios.drawFontWidth() === -1).assertTrue();
      expect(FormCommonControllerCardRadios.drawFontWidth(100) === 1).assertTrue();
      expect(FormCommonControllerCardRadios.drawFontWidth(200) === 2).assertTrue();
      expect(FormCommonControllerCardRadios.drawFontWidth(300) === 3).assertTrue();
      expect(FormCommonControllerCardRadios.drawFontWidth(400) === 4).assertTrue();
      expect(FormCommonControllerCardRadios.drawFontWidth(500) === 6).assertTrue();
      expect(FormCommonControllerCardRadios.drawFontWidth(600) === 7).assertTrue();
      expect(FormCommonControllerCardRadios.drawFontWidth(700) === 8).assertTrue();
      expect(FormCommonControllerCardRadios.drawFontWidth(800) === 9).assertTrue();
      expect(FormCommonControllerCardRadios.drawFontWidth(900) === 1).assertTrue();
      expect(FormCommonControllerCardRadios.drawFontWidth(1000) === 5).assertTrue();
      expect(FormCommonControllerCardRadios.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormCommonControllerCardRadios.drawFontWeightFormat() === 3).assertTrue();
      expect(FormCommonControllerCardRadios.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormCommonControllerCardRadios.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormCommonControllerCardRadios.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormCommonControllerCardRadios.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormCommonControllerCardRadios.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormCommonControllerCardRadios.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormCommonControllerCardRadios.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormCommonControllerCardRadios.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormCommonControllerCardRadios.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormCommonControllerCardRadios_010', 0, () => {
      expect(FormCommonControllerCardRadios.drawTextAlign() === -1).assertTrue();
      expect(FormCommonControllerCardRadios.drawTextAlign(100) === 0).assertTrue();
      expect(FormCommonControllerCardRadios.drawTextAlign(200) === 1).assertTrue();
      expect(FormCommonControllerCardRadios.drawTextAlign(300) === 2).assertTrue();
      expect(FormCommonControllerCardRadios.drawTextAlign(400) === 3).assertTrue();
      expect(FormCommonControllerCardRadios.drawTextAlign(500) === 4).assertTrue();
      expect(FormCommonControllerCardRadios.drawTextAlign(600) === 5).assertTrue();
      expect(FormCommonControllerCardRadios.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormCommonControllerCardRadios_011', 0, () => {
      expect(FormCommonControllerCardRadios.getStringIndex('', '') === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getStringIndex(null, '') === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormCommonControllerCardRadios.getStringIndex('a', '') === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getStringIndex('a', null) === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormCommonControllerCardRadios_012', 0, () => {
      expect(FormCommonControllerCardRadios.checkArr([]) === false).assertTrue();
      expect(FormCommonControllerCardRadios.checkArr(null) === false).assertTrue();
      expect(FormCommonControllerCardRadios.checkArr(undefined) === false).assertTrue();
      expect(FormCommonControllerCardRadios.checkArr(['', 'b']) === false).assertTrue();
      expect(FormCommonControllerCardRadios.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormCommonControllerCardRadios.checkArr([null, 'b']) === false).assertTrue();
      expect(FormCommonControllerCardRadios.checkArr(['a', '']) === false).assertTrue();
      expect(FormCommonControllerCardRadios.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormCommonControllerCardRadios.checkArr(['a', null]) === false).assertTrue();
      expect(FormCommonControllerCardRadios.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormCommonControllerCardRadios.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormCommonControllerCardRadios.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormCommonControllerCardRadios.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormCommonControllerCardRadios.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormCommonControllerCardRadios.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormCommonControllerCardRadios.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormCommonControllerCardRadios.getUUID().length > 0).assertTrue();
    })

    it('FormCommonControllerCardRadios_013', 0, () => {
      expect(FormCommonControllerCardRadios.verifyValue(1, 2) === 1).assertTrue();
      expect(FormCommonControllerCardRadios.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormCommonControllerCardRadios_014', 0, () => {
      expect(FormCommonControllerCardRadios.getBinaryData(null, '') === '').assertTrue();
      expect(FormCommonControllerCardRadios.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormCommonControllerCardRadios.getBinaryData(2, null) === '').assertTrue();
      expect(FormCommonControllerCardRadios.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormCommonControllerCardRadios.getBinaryData(-2, '') === '').assertTrue();
      expect(FormCommonControllerCardRadios.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormCommonControllerCardRadios.getBinaryData(0, '') === '').assertTrue();
      expect(FormCommonControllerCardRadios.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormCommonControllerCardRadios_015', 0, () => {
      expect(FormCommonControllerCardRadios.getArraySum(null, []) === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getArraySum([], null) === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getArraySum([], undefined) === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormCommonControllerCardRadios.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormCommonControllerCardRadios_016', 0, () => {
      expect(FormCommonControllerCardRadios.isEmpty(null)).assertTrue();
      expect(FormCommonControllerCardRadios.isEmpty(undefined)).assertTrue();
      expect(FormCommonControllerCardRadios.isEmpty('')).assertTrue();
      expect(FormCommonControllerCardRadios.isEmpty(0)).assertTrue();
      expect(FormCommonControllerCardRadios.isEmpty([])).assertTrue();
      expect(FormCommonControllerCardRadios.isEmpty(1, null)).assertTrue();
      expect(FormCommonControllerCardRadios.isEmpty(1, undefined)).assertTrue();
      expect(FormCommonControllerCardRadios.isEmpty(1, true)).assertTrue();
      expect(FormCommonControllerCardRadios.isEmpty(1, false)).assertFalse();
    })

    it('FormCommonControllerCardRadios_017', 0, () => {
      expect(FormCommonControllerCardRadios.equals(null, 'a')).assertFalse();
      expect(FormCommonControllerCardRadios.equals(undefined, 'a')).assertFalse();
      expect(FormCommonControllerCardRadios.equals('a', null)).assertFalse();
      expect(FormCommonControllerCardRadios.equals('a', undefined)).assertFalse();
      expect(FormCommonControllerCardRadios.equals('a', 1)).assertFalse();
      expect(FormCommonControllerCardRadios.equals(1, 'a')).assertFalse();
      expect(FormCommonControllerCardRadios.equals(1, [])).assertFalse();
      expect(FormCommonControllerCardRadios.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormCommonControllerCardRadios.equals([], m)).assertFalse();
      expect(FormCommonControllerCardRadios.equals(m, [])).assertFalse();
      expect(FormCommonControllerCardRadios.equals([1,2], [])).assertFalse();
      expect(FormCommonControllerCardRadios.equals([], [1, 2])).assertFalse();
      expect(FormCommonControllerCardRadios.equals([1], [1, 2])).assertFalse();
      expect(FormCommonControllerCardRadios.equals([1, 3], [1, 2])).assertFalse();
      expect(FormCommonControllerCardRadios.equals([1, 2], [1, 2])).assertTrue();
      expect(FormCommonControllerCardRadios.equals(2, 2)).assertTrue();
    })
  });
}