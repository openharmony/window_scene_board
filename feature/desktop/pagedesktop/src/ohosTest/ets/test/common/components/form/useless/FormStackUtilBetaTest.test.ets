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
import { FormStackUtilBeta } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackUtilBeta';

export function FormStackUtilBetaTest() {
  describe('FormStackUtilBetaTest', () => {
    it('FormStackUtilBeta_001', 0, () => {
      expect(FormStackUtilBeta.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackUtilBeta.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackUtilBeta.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackUtilBeta.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackUtilBeta.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackUtilBeta.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackUtilBeta.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackUtilBeta_002', 0, () => {
      expect(FormStackUtilBeta.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackUtilBeta.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackUtilBeta.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackUtilBeta.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackUtilBeta.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackUtilBeta.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackUtilBeta.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackUtilBeta_003', 0, () => {
      expect(FormStackUtilBeta.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackUtilBeta.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackUtilBeta.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackUtilBeta.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackUtilBeta.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackUtilBeta.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackUtilBeta.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackUtilBeta_004', 0, () => {
      expect(FormStackUtilBeta.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackUtilBeta.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackUtilBeta.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackUtilBeta.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackUtilBeta.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackUtilBeta.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackUtilBeta.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackUtilBeta_005', 0, () => {
      expect(FormStackUtilBeta.isNumber("")).assertFalse();
      expect(FormStackUtilBeta.isNumber(null)).assertFalse();
      expect(FormStackUtilBeta.isNumber(undefined)).assertFalse();
      expect(FormStackUtilBeta.isNumber("abc")).assertFalse();
      expect(FormStackUtilBeta.isNumber("123")).assertTrue();
    });

    it('FormStackUtilBeta_006', 0, () => {
      expect(FormStackUtilBeta.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackUtilBeta.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackUtilBeta.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackUtilBeta.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackUtilBeta.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackUtilBeta.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackUtilBeta_007', 0, () => {
      expect(FormStackUtilBeta.getDefaultId(null) === null).assertTrue();
      expect(FormStackUtilBeta.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackUtilBeta.getDefaultId('') === '').assertTrue();
      expect(FormStackUtilBeta.getDefaultId('default') !== '').assertTrue();
      expect(FormStackUtilBeta.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackUtilBeta.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackUtilBeta_008', 0, () => {
      expect(FormStackUtilBeta.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackUtilBeta.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackUtilBeta.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackUtilBeta.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackUtilBeta.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackUtilBeta.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackUtilBeta.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackUtilBeta_009', 0, () => {
      expect(FormStackUtilBeta.drawFontWidth() === -1).assertTrue();
      expect(FormStackUtilBeta.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackUtilBeta.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackUtilBeta.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackUtilBeta.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackUtilBeta.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackUtilBeta.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackUtilBeta.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackUtilBeta.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackUtilBeta.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackUtilBeta.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackUtilBeta.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackUtilBeta.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackUtilBeta.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackUtilBeta.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackUtilBeta.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackUtilBeta.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackUtilBeta.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackUtilBeta.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackUtilBeta.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackUtilBeta.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackUtilBeta.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackUtilBeta_010', 0, () => {
      expect(FormStackUtilBeta.drawTextAlign() === -1).assertTrue();
      expect(FormStackUtilBeta.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackUtilBeta.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackUtilBeta.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackUtilBeta.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackUtilBeta.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackUtilBeta.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackUtilBeta.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackUtilBeta_011', 0, () => {
      expect(FormStackUtilBeta.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackUtilBeta.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackUtilBeta.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackUtilBeta.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackUtilBeta.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackUtilBeta.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackUtilBeta.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackUtilBeta.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackUtilBeta.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackUtilBeta.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackUtilBeta.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackUtilBeta.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackUtilBeta.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackUtilBeta.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackUtilBeta.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackUtilBeta.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackUtilBeta.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackUtilBeta.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackUtilBeta.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackUtilBeta_012', 0, () => {
      expect(FormStackUtilBeta.checkArr([]) === false).assertTrue();
      expect(FormStackUtilBeta.checkArr(null) === false).assertTrue();
      expect(FormStackUtilBeta.checkArr(undefined) === false).assertTrue();
      expect(FormStackUtilBeta.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackUtilBeta.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackUtilBeta.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackUtilBeta.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackUtilBeta.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackUtilBeta.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackUtilBeta.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackUtilBeta.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackUtilBeta.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackUtilBeta.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackUtilBeta.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackUtilBeta.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackUtilBeta.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackUtilBeta.getUUID().length > 0).assertTrue();
    })

    it('FormStackUtilBeta_013', 0, () => {
      expect(FormStackUtilBeta.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackUtilBeta.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackUtilBeta_014', 0, () => {
      expect(FormStackUtilBeta.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackUtilBeta.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackUtilBeta.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackUtilBeta.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackUtilBeta.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackUtilBeta.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackUtilBeta.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackUtilBeta.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackUtilBeta_015', 0, () => {
      expect(FormStackUtilBeta.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackUtilBeta.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackUtilBeta.getArraySum([], null) === -1).assertTrue();
      expect(FormStackUtilBeta.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackUtilBeta.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackUtilBeta.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackUtilBeta.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackUtilBeta.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackUtilBeta.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackUtilBeta.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackUtilBeta.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackUtilBeta.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackUtilBeta_016', 0, () => {
      expect(FormStackUtilBeta.isEmpty(null)).assertTrue();
      expect(FormStackUtilBeta.isEmpty(undefined)).assertTrue();
      expect(FormStackUtilBeta.isEmpty('')).assertTrue();
      expect(FormStackUtilBeta.isEmpty(0)).assertTrue();
      expect(FormStackUtilBeta.isEmpty([])).assertTrue();
      expect(FormStackUtilBeta.isEmpty(1, null)).assertTrue();
      expect(FormStackUtilBeta.isEmpty(1, undefined)).assertTrue();
      expect(FormStackUtilBeta.isEmpty(1, true)).assertTrue();
      expect(FormStackUtilBeta.isEmpty(1, false)).assertFalse();
    })

    it('FormStackUtilBeta_017', 0, () => {
      expect(FormStackUtilBeta.equals(null, 'a')).assertFalse();
      expect(FormStackUtilBeta.equals(undefined, 'a')).assertFalse();
      expect(FormStackUtilBeta.equals('a', null)).assertFalse();
      expect(FormStackUtilBeta.equals('a', undefined)).assertFalse();
      expect(FormStackUtilBeta.equals('a', 1)).assertFalse();
      expect(FormStackUtilBeta.equals(1, 'a')).assertFalse();
      expect(FormStackUtilBeta.equals(1, [])).assertFalse();
      expect(FormStackUtilBeta.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackUtilBeta.equals([], m)).assertFalse();
      expect(FormStackUtilBeta.equals(m, [])).assertFalse();
      expect(FormStackUtilBeta.equals([1,2], [])).assertFalse();
      expect(FormStackUtilBeta.equals([], [1, 2])).assertFalse();
      expect(FormStackUtilBeta.equals([1], [1, 2])).assertFalse();
      expect(FormStackUtilBeta.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackUtilBeta.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackUtilBeta.equals(2, 2)).assertTrue();
    })
  });
}