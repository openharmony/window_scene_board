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
import { FormStackUtilPadBeta } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackUtilPadBeta';

export function FormStackUtilPadBetaTest() {
  describe('FormStackUtilPadBetaTest', () => {
    it('FormStackUtilPadBeta_001', 0, () => {
      expect(FormStackUtilPadBeta.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackUtilPadBeta.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackUtilPadBeta.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackUtilPadBeta.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackUtilPadBeta.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackUtilPadBeta.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackUtilPadBeta.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackUtilPadBeta_002', 0, () => {
      expect(FormStackUtilPadBeta.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackUtilPadBeta.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackUtilPadBeta.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackUtilPadBeta.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackUtilPadBeta.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackUtilPadBeta.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackUtilPadBeta.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackUtilPadBeta_003', 0, () => {
      expect(FormStackUtilPadBeta.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackUtilPadBeta.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackUtilPadBeta.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackUtilPadBeta.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackUtilPadBeta.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackUtilPadBeta.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackUtilPadBeta.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackUtilPadBeta_004', 0, () => {
      expect(FormStackUtilPadBeta.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackUtilPadBeta.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackUtilPadBeta.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackUtilPadBeta.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackUtilPadBeta.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackUtilPadBeta.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackUtilPadBeta.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackUtilPadBeta_005', 0, () => {
      expect(FormStackUtilPadBeta.isNumber("")).assertFalse();
      expect(FormStackUtilPadBeta.isNumber(null)).assertFalse();
      expect(FormStackUtilPadBeta.isNumber(undefined)).assertFalse();
      expect(FormStackUtilPadBeta.isNumber("abc")).assertFalse();
      expect(FormStackUtilPadBeta.isNumber("123")).assertTrue();
    });

    it('FormStackUtilPadBeta_006', 0, () => {
      expect(FormStackUtilPadBeta.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackUtilPadBeta.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackUtilPadBeta.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackUtilPadBeta.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackUtilPadBeta.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackUtilPadBeta.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackUtilPadBeta_007', 0, () => {
      expect(FormStackUtilPadBeta.getDefaultId(null) === null).assertTrue();
      expect(FormStackUtilPadBeta.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackUtilPadBeta.getDefaultId('') === '').assertTrue();
      expect(FormStackUtilPadBeta.getDefaultId('default') !== '').assertTrue();
      expect(FormStackUtilPadBeta.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackUtilPadBeta.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackUtilPadBeta_008', 0, () => {
      expect(FormStackUtilPadBeta.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackUtilPadBeta.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackUtilPadBeta.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackUtilPadBeta.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackUtilPadBeta.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackUtilPadBeta.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackUtilPadBeta.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackUtilPadBeta_009', 0, () => {
      expect(FormStackUtilPadBeta.drawFontWidth() === -1).assertTrue();
      expect(FormStackUtilPadBeta.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackUtilPadBeta.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackUtilPadBeta.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackUtilPadBeta.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackUtilPadBeta.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackUtilPadBeta.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackUtilPadBeta.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackUtilPadBeta.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackUtilPadBeta.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackUtilPadBeta.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackUtilPadBeta.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackUtilPadBeta.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackUtilPadBeta.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackUtilPadBeta.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackUtilPadBeta.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackUtilPadBeta.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackUtilPadBeta.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackUtilPadBeta.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackUtilPadBeta.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackUtilPadBeta.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackUtilPadBeta.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackUtilPadBeta_010', 0, () => {
      expect(FormStackUtilPadBeta.drawTextAlign() === -1).assertTrue();
      expect(FormStackUtilPadBeta.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackUtilPadBeta.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackUtilPadBeta.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackUtilPadBeta.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackUtilPadBeta.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackUtilPadBeta.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackUtilPadBeta.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackUtilPadBeta_011', 0, () => {
      expect(FormStackUtilPadBeta.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackUtilPadBeta.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackUtilPadBeta.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackUtilPadBeta.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackUtilPadBeta.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackUtilPadBeta.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackUtilPadBeta.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackUtilPadBeta.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackUtilPadBeta.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackUtilPadBeta.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackUtilPadBeta.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackUtilPadBeta.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackUtilPadBeta.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackUtilPadBeta.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackUtilPadBeta.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackUtilPadBeta.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackUtilPadBeta.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackUtilPadBeta.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackUtilPadBeta.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackUtilPadBeta_012', 0, () => {
      expect(FormStackUtilPadBeta.checkArr([]) === false).assertTrue();
      expect(FormStackUtilPadBeta.checkArr(null) === false).assertTrue();
      expect(FormStackUtilPadBeta.checkArr(undefined) === false).assertTrue();
      expect(FormStackUtilPadBeta.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackUtilPadBeta.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackUtilPadBeta.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackUtilPadBeta.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackUtilPadBeta.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackUtilPadBeta.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackUtilPadBeta.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackUtilPadBeta.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackUtilPadBeta.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackUtilPadBeta.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackUtilPadBeta.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackUtilPadBeta.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackUtilPadBeta.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackUtilPadBeta.getUUID().length > 0).assertTrue();
    })

    it('FormStackUtilPadBeta_013', 0, () => {
      expect(FormStackUtilPadBeta.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackUtilPadBeta.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackUtilPadBeta_014', 0, () => {
      expect(FormStackUtilPadBeta.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackUtilPadBeta.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackUtilPadBeta.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackUtilPadBeta.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackUtilPadBeta.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackUtilPadBeta.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackUtilPadBeta.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackUtilPadBeta.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackUtilPadBeta_015', 0, () => {
      expect(FormStackUtilPadBeta.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackUtilPadBeta.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackUtilPadBeta.getArraySum([], null) === -1).assertTrue();
      expect(FormStackUtilPadBeta.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackUtilPadBeta.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackUtilPadBeta.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackUtilPadBeta.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackUtilPadBeta.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackUtilPadBeta.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackUtilPadBeta.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackUtilPadBeta.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackUtilPadBeta.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackUtilPadBeta_016', 0, () => {
      expect(FormStackUtilPadBeta.isEmpty(null)).assertTrue();
      expect(FormStackUtilPadBeta.isEmpty(undefined)).assertTrue();
      expect(FormStackUtilPadBeta.isEmpty('')).assertTrue();
      expect(FormStackUtilPadBeta.isEmpty(0)).assertTrue();
      expect(FormStackUtilPadBeta.isEmpty([])).assertTrue();
      expect(FormStackUtilPadBeta.isEmpty(1, null)).assertTrue();
      expect(FormStackUtilPadBeta.isEmpty(1, undefined)).assertTrue();
      expect(FormStackUtilPadBeta.isEmpty(1, true)).assertTrue();
      expect(FormStackUtilPadBeta.isEmpty(1, false)).assertFalse();
    })

    it('FormStackUtilPadBeta_017', 0, () => {
      expect(FormStackUtilPadBeta.equals(null, 'a')).assertFalse();
      expect(FormStackUtilPadBeta.equals(undefined, 'a')).assertFalse();
      expect(FormStackUtilPadBeta.equals('a', null)).assertFalse();
      expect(FormStackUtilPadBeta.equals('a', undefined)).assertFalse();
      expect(FormStackUtilPadBeta.equals('a', 1)).assertFalse();
      expect(FormStackUtilPadBeta.equals(1, 'a')).assertFalse();
      expect(FormStackUtilPadBeta.equals(1, [])).assertFalse();
      expect(FormStackUtilPadBeta.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackUtilPadBeta.equals([], m)).assertFalse();
      expect(FormStackUtilPadBeta.equals(m, [])).assertFalse();
      expect(FormStackUtilPadBeta.equals([1,2], [])).assertFalse();
      expect(FormStackUtilPadBeta.equals([], [1, 2])).assertFalse();
      expect(FormStackUtilPadBeta.equals([1], [1, 2])).assertFalse();
      expect(FormStackUtilPadBeta.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackUtilPadBeta.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackUtilPadBeta.equals(2, 2)).assertTrue();
    })
  });
}