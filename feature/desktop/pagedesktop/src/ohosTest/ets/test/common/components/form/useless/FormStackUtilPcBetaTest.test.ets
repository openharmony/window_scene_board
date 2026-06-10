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
import { FormStackUtilPcBeta } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackUtilPcBeta';

export function FormStackUtilPcBetaTest() {
  describe('FormStackUtilPcBetaTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackUtilPcBeta.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackUtilPcBeta.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackUtilPcBeta.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackUtilPcBeta.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackUtilPcBeta.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackUtilPcBeta.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackUtilPcBeta.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackUtilPcBeta_002', 0, () => {
      expect(FormStackUtilPcBeta.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackUtilPcBeta.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackUtilPcBeta.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackUtilPcBeta.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackUtilPcBeta.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackUtilPcBeta.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackUtilPcBeta.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackUtilPcBeta_003', 0, () => {
      expect(FormStackUtilPcBeta.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackUtilPcBeta.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackUtilPcBeta.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackUtilPcBeta.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackUtilPcBeta.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackUtilPcBeta.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackUtilPcBeta.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackUtilPcBeta_004', 0, () => {
      expect(FormStackUtilPcBeta.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackUtilPcBeta.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackUtilPcBeta.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackUtilPcBeta.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackUtilPcBeta.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackUtilPcBeta.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackUtilPcBeta.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackUtilPcBeta_005', 0, () => {
      expect(FormStackUtilPcBeta.isNumber("")).assertFalse();
      expect(FormStackUtilPcBeta.isNumber(null)).assertFalse();
      expect(FormStackUtilPcBeta.isNumber(undefined)).assertFalse();
      expect(FormStackUtilPcBeta.isNumber("abc")).assertFalse();
      expect(FormStackUtilPcBeta.isNumber("123")).assertTrue();
    });

    it('FormStackUtilPcBeta_006', 0, () => {
      expect(FormStackUtilPcBeta.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackUtilPcBeta.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackUtilPcBeta.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackUtilPcBeta.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackUtilPcBeta.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackUtilPcBeta.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackUtilPcBeta_007', 0, () => {
      expect(FormStackUtilPcBeta.getDefaultId(null) === null).assertTrue();
      expect(FormStackUtilPcBeta.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackUtilPcBeta.getDefaultId('') === '').assertTrue();
      expect(FormStackUtilPcBeta.getDefaultId('default') !== '').assertTrue();
      expect(FormStackUtilPcBeta.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackUtilPcBeta.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackUtilPcBeta_008', 0, () => {
      expect(FormStackUtilPcBeta.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackUtilPcBeta.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackUtilPcBeta.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackUtilPcBeta.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackUtilPcBeta.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackUtilPcBeta.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackUtilPcBeta.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackUtilPcBeta_009', 0, () => {
      expect(FormStackUtilPcBeta.drawFontWidth() === -1).assertTrue();
      expect(FormStackUtilPcBeta.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackUtilPcBeta.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackUtilPcBeta.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackUtilPcBeta.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackUtilPcBeta.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackUtilPcBeta.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackUtilPcBeta.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackUtilPcBeta.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackUtilPcBeta.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackUtilPcBeta.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackUtilPcBeta.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackUtilPcBeta.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackUtilPcBeta.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackUtilPcBeta.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackUtilPcBeta.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackUtilPcBeta.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackUtilPcBeta.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackUtilPcBeta.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackUtilPcBeta.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackUtilPcBeta.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackUtilPcBeta.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackUtilPcBeta_010', 0, () => {
      expect(FormStackUtilPcBeta.drawTextAlign() === -1).assertTrue();
      expect(FormStackUtilPcBeta.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackUtilPcBeta.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackUtilPcBeta.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackUtilPcBeta.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackUtilPcBeta.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackUtilPcBeta.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackUtilPcBeta.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackUtilPcBeta_011', 0, () => {
      expect(FormStackUtilPcBeta.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackUtilPcBeta.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackUtilPcBeta.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackUtilPcBeta.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackUtilPcBeta.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackUtilPcBeta.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackUtilPcBeta.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackUtilPcBeta.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackUtilPcBeta.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackUtilPcBeta.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackUtilPcBeta.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackUtilPcBeta.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackUtilPcBeta.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackUtilPcBeta.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackUtilPcBeta.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackUtilPcBeta.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackUtilPcBeta.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackUtilPcBeta.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackUtilPcBeta.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackUtilPcBeta_012', 0, () => {
      expect(FormStackUtilPcBeta.checkArr([]) === false).assertTrue();
      expect(FormStackUtilPcBeta.checkArr(null) === false).assertTrue();
      expect(FormStackUtilPcBeta.checkArr(undefined) === false).assertTrue();
      expect(FormStackUtilPcBeta.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackUtilPcBeta.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackUtilPcBeta.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackUtilPcBeta.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackUtilPcBeta.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackUtilPcBeta.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackUtilPcBeta.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackUtilPcBeta.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackUtilPcBeta.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackUtilPcBeta.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackUtilPcBeta.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackUtilPcBeta.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackUtilPcBeta.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackUtilPcBeta.getUUID().length > 0).assertTrue();
    })

    it('FormStackUtilPcBeta_013', 0, () => {
      expect(FormStackUtilPcBeta.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackUtilPcBeta.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackUtilPcBeta_014', 0, () => {
      expect(FormStackUtilPcBeta.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackUtilPcBeta.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackUtilPcBeta.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackUtilPcBeta.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackUtilPcBeta.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackUtilPcBeta.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackUtilPcBeta.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackUtilPcBeta.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackUtilPcBeta_015', 0, () => {
      expect(FormStackUtilPcBeta.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackUtilPcBeta.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackUtilPcBeta.getArraySum([], null) === -1).assertTrue();
      expect(FormStackUtilPcBeta.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackUtilPcBeta.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackUtilPcBeta.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackUtilPcBeta.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackUtilPcBeta.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackUtilPcBeta.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackUtilPcBeta.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackUtilPcBeta.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackUtilPcBeta.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackUtilPcBeta_016', 0, () => {
      expect(FormStackUtilPcBeta.isEmpty(null)).assertTrue();
      expect(FormStackUtilPcBeta.isEmpty(undefined)).assertTrue();
      expect(FormStackUtilPcBeta.isEmpty('')).assertTrue();
      expect(FormStackUtilPcBeta.isEmpty(0)).assertTrue();
      expect(FormStackUtilPcBeta.isEmpty([])).assertTrue();
      expect(FormStackUtilPcBeta.isEmpty(1, null)).assertTrue();
      expect(FormStackUtilPcBeta.isEmpty(1, undefined)).assertTrue();
      expect(FormStackUtilPcBeta.isEmpty(1, true)).assertTrue();
      expect(FormStackUtilPcBeta.isEmpty(1, false)).assertFalse();
    })

    it('FormStackUtilPcBeta_017', 0, () => {
      expect(FormStackUtilPcBeta.equals(null, 'a')).assertFalse();
      expect(FormStackUtilPcBeta.equals(undefined, 'a')).assertFalse();
      expect(FormStackUtilPcBeta.equals('a', null)).assertFalse();
      expect(FormStackUtilPcBeta.equals('a', undefined)).assertFalse();
      expect(FormStackUtilPcBeta.equals('a', 1)).assertFalse();
      expect(FormStackUtilPcBeta.equals(1, 'a')).assertFalse();
      expect(FormStackUtilPcBeta.equals(1, [])).assertFalse();
      expect(FormStackUtilPcBeta.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackUtilPcBeta.equals([], m)).assertFalse();
      expect(FormStackUtilPcBeta.equals(m, [])).assertFalse();
      expect(FormStackUtilPcBeta.equals([1,2], [])).assertFalse();
      expect(FormStackUtilPcBeta.equals([], [1, 2])).assertFalse();
      expect(FormStackUtilPcBeta.equals([1], [1, 2])).assertFalse();
      expect(FormStackUtilPcBeta.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackUtilPcBeta.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackUtilPcBeta.equals(2, 2)).assertTrue();
    })
  });
}