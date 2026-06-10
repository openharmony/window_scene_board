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
import { FormStackUtilFolderBeta } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackUtilFolderBeta';

export function FormStackUtilFolderBetaTest() {
  describe('FormStackUtilFolderBetaTest', () => {
    it('FormStackUtilFolderBeta_001', 0, () => {
      expect(FormStackUtilFolderBeta.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackUtilFolderBeta.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackUtilFolderBeta.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackUtilFolderBeta.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackUtilFolderBeta.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackUtilFolderBeta.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackUtilFolderBeta.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackUtilFolderBeta_002', 0, () => {
      expect(FormStackUtilFolderBeta.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackUtilFolderBeta.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackUtilFolderBeta.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackUtilFolderBeta.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackUtilFolderBeta.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackUtilFolderBeta.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackUtilFolderBeta.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackUtilFolderBeta_003', 0, () => {
      expect(FormStackUtilFolderBeta.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackUtilFolderBeta.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackUtilFolderBeta.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackUtilFolderBeta.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackUtilFolderBeta.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackUtilFolderBeta.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackUtilFolderBeta.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackUtilFolderBeta_004', 0, () => {
      expect(FormStackUtilFolderBeta.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackUtilFolderBeta.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackUtilFolderBeta.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackUtilFolderBeta.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackUtilFolderBeta.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackUtilFolderBeta.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackUtilFolderBeta.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackUtilFolderBeta_005', 0, () => {
      expect(FormStackUtilFolderBeta.isNumber("")).assertFalse();
      expect(FormStackUtilFolderBeta.isNumber(null)).assertFalse();
      expect(FormStackUtilFolderBeta.isNumber(undefined)).assertFalse();
      expect(FormStackUtilFolderBeta.isNumber("abc")).assertFalse();
      expect(FormStackUtilFolderBeta.isNumber("123")).assertTrue();
    });

    it('FormStackUtilFolderBeta_006', 0, () => {
      expect(FormStackUtilFolderBeta.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackUtilFolderBeta.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackUtilFolderBeta.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackUtilFolderBeta.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackUtilFolderBeta.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackUtilFolderBeta.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackUtilFolderBeta_007', 0, () => {
      expect(FormStackUtilFolderBeta.getDefaultId(null) === null).assertTrue();
      expect(FormStackUtilFolderBeta.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackUtilFolderBeta.getDefaultId('') === '').assertTrue();
      expect(FormStackUtilFolderBeta.getDefaultId('default') !== '').assertTrue();
      expect(FormStackUtilFolderBeta.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackUtilFolderBeta.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackUtilFolderBeta_008', 0, () => {
      expect(FormStackUtilFolderBeta.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackUtilFolderBeta_009', 0, () => {
      expect(FormStackUtilFolderBeta.drawFontWidth() === -1).assertTrue();
      expect(FormStackUtilFolderBeta.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackUtilFolderBeta.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackUtilFolderBeta.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackUtilFolderBeta.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackUtilFolderBeta.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackUtilFolderBeta.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackUtilFolderBeta.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackUtilFolderBeta.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackUtilFolderBeta.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackUtilFolderBeta.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackUtilFolderBeta.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackUtilFolderBeta.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackUtilFolderBeta.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackUtilFolderBeta.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackUtilFolderBeta.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackUtilFolderBeta.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackUtilFolderBeta.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackUtilFolderBeta.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackUtilFolderBeta.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackUtilFolderBeta.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackUtilFolderBeta.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackUtilFolderBeta_010', 0, () => {
      expect(FormStackUtilFolderBeta.drawTextAlign() === -1).assertTrue();
      expect(FormStackUtilFolderBeta.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackUtilFolderBeta.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackUtilFolderBeta.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackUtilFolderBeta.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackUtilFolderBeta.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackUtilFolderBeta.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackUtilFolderBeta.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackUtilFolderBeta_011', 0, () => {
      expect(FormStackUtilFolderBeta.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackUtilFolderBeta.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackUtilFolderBeta_012', 0, () => {
      expect(FormStackUtilFolderBeta.checkArr([]) === false).assertTrue();
      expect(FormStackUtilFolderBeta.checkArr(null) === false).assertTrue();
      expect(FormStackUtilFolderBeta.checkArr(undefined) === false).assertTrue();
      expect(FormStackUtilFolderBeta.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackUtilFolderBeta.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackUtilFolderBeta.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackUtilFolderBeta.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackUtilFolderBeta.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackUtilFolderBeta.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackUtilFolderBeta.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackUtilFolderBeta.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackUtilFolderBeta.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackUtilFolderBeta.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackUtilFolderBeta.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackUtilFolderBeta.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackUtilFolderBeta.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackUtilFolderBeta.getUUID().length > 0).assertTrue();
    })

    it('FormStackUtilFolderBeta_013', 0, () => {
      expect(FormStackUtilFolderBeta.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackUtilFolderBeta.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackUtilFolderBeta_014', 0, () => {
      expect(FormStackUtilFolderBeta.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackUtilFolderBeta.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackUtilFolderBeta.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackUtilFolderBeta.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackUtilFolderBeta.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackUtilFolderBeta.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackUtilFolderBeta.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackUtilFolderBeta.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackUtilFolderBeta_015', 0, () => {
      expect(FormStackUtilFolderBeta.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getArraySum([], null) === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackUtilFolderBeta.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackUtilFolderBeta_016', 0, () => {
      expect(FormStackUtilFolderBeta.isEmpty(null)).assertTrue();
      expect(FormStackUtilFolderBeta.isEmpty(undefined)).assertTrue();
      expect(FormStackUtilFolderBeta.isEmpty('')).assertTrue();
      expect(FormStackUtilFolderBeta.isEmpty(0)).assertTrue();
      expect(FormStackUtilFolderBeta.isEmpty([])).assertTrue();
      expect(FormStackUtilFolderBeta.isEmpty(1, null)).assertTrue();
      expect(FormStackUtilFolderBeta.isEmpty(1, undefined)).assertTrue();
      expect(FormStackUtilFolderBeta.isEmpty(1, true)).assertTrue();
      expect(FormStackUtilFolderBeta.isEmpty(1, false)).assertFalse();
    })

    it('FormStackUtilFolderBeta_017', 0, () => {
      expect(FormStackUtilFolderBeta.equals(null, 'a')).assertFalse();
      expect(FormStackUtilFolderBeta.equals(undefined, 'a')).assertFalse();
      expect(FormStackUtilFolderBeta.equals('a', null)).assertFalse();
      expect(FormStackUtilFolderBeta.equals('a', undefined)).assertFalse();
      expect(FormStackUtilFolderBeta.equals('a', 1)).assertFalse();
      expect(FormStackUtilFolderBeta.equals(1, 'a')).assertFalse();
      expect(FormStackUtilFolderBeta.equals(1, [])).assertFalse();
      expect(FormStackUtilFolderBeta.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackUtilFolderBeta.equals([], m)).assertFalse();
      expect(FormStackUtilFolderBeta.equals(m, [])).assertFalse();
      expect(FormStackUtilFolderBeta.equals([1,2], [])).assertFalse();
      expect(FormStackUtilFolderBeta.equals([], [1, 2])).assertFalse();
      expect(FormStackUtilFolderBeta.equals([1], [1, 2])).assertFalse();
      expect(FormStackUtilFolderBeta.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackUtilFolderBeta.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackUtilFolderBeta.equals(2, 2)).assertTrue();
    })
  });
}