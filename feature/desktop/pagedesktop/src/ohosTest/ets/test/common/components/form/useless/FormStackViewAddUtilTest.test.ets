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
import { FormStackViewAddUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackViewAddUtil';

export function FormStackViewAddUtilTest() {
  describe('FormStackViewAddUtilTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackViewAddUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackViewAddUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackViewAddUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackViewAddUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackViewAddUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackViewAddUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackViewAddUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackViewAddUtil_002', 0, () => {
      expect(FormStackViewAddUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackViewAddUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackViewAddUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewAddUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackViewAddUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewAddUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackViewAddUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackViewAddUtil_003', 0, () => {
      expect(FormStackViewAddUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackViewAddUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewAddUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewAddUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewAddUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewAddUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackViewAddUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackViewAddUtil_004', 0, () => {
      expect(FormStackViewAddUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackViewAddUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewAddUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewAddUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewAddUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewAddUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackViewAddUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackViewAddUtil_005', 0, () => {
      expect(FormStackViewAddUtil.isNumber("")).assertFalse();
      expect(FormStackViewAddUtil.isNumber(null)).assertFalse();
      expect(FormStackViewAddUtil.isNumber(undefined)).assertFalse();
      expect(FormStackViewAddUtil.isNumber("abc")).assertFalse();
      expect(FormStackViewAddUtil.isNumber("123")).assertTrue();
    });

    it('FormStackViewAddUtil_006', 0, () => {
      expect(FormStackViewAddUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackViewAddUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackViewAddUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackViewAddUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackViewAddUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackViewAddUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackViewAddUtil_007', 0, () => {
      expect(FormStackViewAddUtil.getDefaultId(null) === null).assertTrue();
      expect(FormStackViewAddUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackViewAddUtil.getDefaultId('') === '').assertTrue();
      expect(FormStackViewAddUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormStackViewAddUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackViewAddUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackViewAddUtil_008', 0, () => {
      expect(FormStackViewAddUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackViewAddUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackViewAddUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackViewAddUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackViewAddUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackViewAddUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackViewAddUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackViewAddUtil_009', 0, () => {
      expect(FormStackViewAddUtil.drawFontWidth() === -1).assertTrue();
      expect(FormStackViewAddUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackViewAddUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackViewAddUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackViewAddUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackViewAddUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackViewAddUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackViewAddUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackViewAddUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackViewAddUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackViewAddUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackViewAddUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackViewAddUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackViewAddUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackViewAddUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackViewAddUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackViewAddUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackViewAddUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackViewAddUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackViewAddUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackViewAddUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackViewAddUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackViewAddUtil_010', 0, () => {
      expect(FormStackViewAddUtil.drawTextAlign() === -1).assertTrue();
      expect(FormStackViewAddUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackViewAddUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackViewAddUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackViewAddUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackViewAddUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackViewAddUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackViewAddUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackViewAddUtil_011', 0, () => {
      expect(FormStackViewAddUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackViewAddUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackViewAddUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackViewAddUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackViewAddUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackViewAddUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackViewAddUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackViewAddUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackViewAddUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackViewAddUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackViewAddUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackViewAddUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackViewAddUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackViewAddUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackViewAddUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackViewAddUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackViewAddUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackViewAddUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackViewAddUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackViewAddUtil_012', 0, () => {
      expect(FormStackViewAddUtil.checkArr([]) === false).assertTrue();
      expect(FormStackViewAddUtil.checkArr(null) === false).assertTrue();
      expect(FormStackViewAddUtil.checkArr(undefined) === false).assertTrue();
      expect(FormStackViewAddUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackViewAddUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackViewAddUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackViewAddUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackViewAddUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackViewAddUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackViewAddUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackViewAddUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackViewAddUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackViewAddUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackViewAddUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackViewAddUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackViewAddUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackViewAddUtil.getUUID().length > 0).assertTrue();
    })

    it('FormStackViewAddUtil_013', 0, () => {
      expect(FormStackViewAddUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackViewAddUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackViewAddUtil_014', 0, () => {
      expect(FormStackViewAddUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackViewAddUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackViewAddUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackViewAddUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackViewAddUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackViewAddUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackViewAddUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackViewAddUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackViewAddUtil_015', 0, () => {
      expect(FormStackViewAddUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackViewAddUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackViewAddUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormStackViewAddUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackViewAddUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackViewAddUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackViewAddUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackViewAddUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackViewAddUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackViewAddUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackViewAddUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackViewAddUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackViewAddUtil_016', 0, () => {
      expect(FormStackViewAddUtil.isEmpty(null)).assertTrue();
      expect(FormStackViewAddUtil.isEmpty(undefined)).assertTrue();
      expect(FormStackViewAddUtil.isEmpty('')).assertTrue();
      expect(FormStackViewAddUtil.isEmpty(0)).assertTrue();
      expect(FormStackViewAddUtil.isEmpty([])).assertTrue();
      expect(FormStackViewAddUtil.isEmpty(1, null)).assertTrue();
      expect(FormStackViewAddUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormStackViewAddUtil.isEmpty(1, true)).assertTrue();
      expect(FormStackViewAddUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormStackViewAddUtil_017', 0, () => {
      expect(FormStackViewAddUtil.equals(null, 'a')).assertFalse();
      expect(FormStackViewAddUtil.equals(undefined, 'a')).assertFalse();
      expect(FormStackViewAddUtil.equals('a', null)).assertFalse();
      expect(FormStackViewAddUtil.equals('a', undefined)).assertFalse();
      expect(FormStackViewAddUtil.equals('a', 1)).assertFalse();
      expect(FormStackViewAddUtil.equals(1, 'a')).assertFalse();
      expect(FormStackViewAddUtil.equals(1, [])).assertFalse();
      expect(FormStackViewAddUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackViewAddUtil.equals([], m)).assertFalse();
      expect(FormStackViewAddUtil.equals(m, [])).assertFalse();
      expect(FormStackViewAddUtil.equals([1,2], [])).assertFalse();
      expect(FormStackViewAddUtil.equals([], [1, 2])).assertFalse();
      expect(FormStackViewAddUtil.equals([1], [1, 2])).assertFalse();
      expect(FormStackViewAddUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackViewAddUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackViewAddUtil.equals(2, 2)).assertTrue();
    })
  });
}