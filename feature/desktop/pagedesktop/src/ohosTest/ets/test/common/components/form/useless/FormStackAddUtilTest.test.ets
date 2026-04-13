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
import { FormStackAddUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackAddUtil';

export function FormStackAddUtilTest() {
  describe('FormStackAddUtilTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackAddUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackAddUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackAddUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackAddUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackAddUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackAddUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackAddUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackAddUtil_002', 0, () => {
      expect(FormStackAddUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackAddUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackAddUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackAddUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackAddUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackAddUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackAddUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackAddUtil_003', 0, () => {
      expect(FormStackAddUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackAddUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackAddUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAddUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAddUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAddUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackAddUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackAddUtil_004', 0, () => {
      expect(FormStackAddUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackAddUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackAddUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAddUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAddUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAddUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackAddUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackAddUtil_005', 0, () => {
      expect(FormStackAddUtil.isNumber("")).assertFalse();
      expect(FormStackAddUtil.isNumber(null)).assertFalse();
      expect(FormStackAddUtil.isNumber(undefined)).assertFalse();
      expect(FormStackAddUtil.isNumber("abc")).assertFalse();
      expect(FormStackAddUtil.isNumber("123")).assertTrue();
    });

    it('FormStackAddUtil_006', 0, () => {
      expect(FormStackAddUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackAddUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackAddUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackAddUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackAddUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackAddUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackAddUtil_007', 0, () => {
      expect(FormStackAddUtil.getDefaultId(null) === null).assertTrue();
      expect(FormStackAddUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackAddUtil.getDefaultId('') === '').assertTrue();
      expect(FormStackAddUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormStackAddUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackAddUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackAddUtil_008', 0, () => {
      expect(FormStackAddUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackAddUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackAddUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackAddUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackAddUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackAddUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackAddUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackAddUtil_009', 0, () => {
      expect(FormStackAddUtil.drawFontWidth() === -1).assertTrue();
      expect(FormStackAddUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackAddUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackAddUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackAddUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackAddUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackAddUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackAddUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackAddUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackAddUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackAddUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackAddUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackAddUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackAddUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackAddUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackAddUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackAddUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackAddUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackAddUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackAddUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackAddUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackAddUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackAddUtil_010', 0, () => {
      expect(FormStackAddUtil.drawTextAlign() === -1).assertTrue();
      expect(FormStackAddUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackAddUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackAddUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackAddUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackAddUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackAddUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackAddUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackAddUtil_011', 0, () => {
      expect(FormStackAddUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackAddUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackAddUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackAddUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackAddUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackAddUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackAddUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackAddUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackAddUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackAddUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackAddUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackAddUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackAddUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackAddUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackAddUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackAddUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackAddUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackAddUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackAddUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackAddUtil_012', 0, () => {
      expect(FormStackAddUtil.checkArr([]) === false).assertTrue();
      expect(FormStackAddUtil.checkArr(null) === false).assertTrue();
      expect(FormStackAddUtil.checkArr(undefined) === false).assertTrue();
      expect(FormStackAddUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackAddUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackAddUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackAddUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackAddUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackAddUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackAddUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackAddUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackAddUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackAddUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackAddUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackAddUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackAddUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackAddUtil.getUUID().length > 0).assertTrue();
    })

    it('FormStackAddUtil_013', 0, () => {
      expect(FormStackAddUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackAddUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackAddUtil_014', 0, () => {
      expect(FormStackAddUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackAddUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackAddUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackAddUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackAddUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackAddUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackAddUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackAddUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackAddUtil_015', 0, () => {
      expect(FormStackAddUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackAddUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackAddUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormStackAddUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackAddUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackAddUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackAddUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackAddUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackAddUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackAddUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackAddUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackAddUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackAddUtil_016', 0, () => {
      expect(FormStackAddUtil.isEmpty(null)).assertTrue();
      expect(FormStackAddUtil.isEmpty(undefined)).assertTrue();
      expect(FormStackAddUtil.isEmpty('')).assertTrue();
      expect(FormStackAddUtil.isEmpty(0)).assertTrue();
      expect(FormStackAddUtil.isEmpty([])).assertTrue();
      expect(FormStackAddUtil.isEmpty(1, null)).assertTrue();
      expect(FormStackAddUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormStackAddUtil.isEmpty(1, true)).assertTrue();
      expect(FormStackAddUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormStackAddUtil_017', 0, () => {
      expect(FormStackAddUtil.equals(null, 'a')).assertFalse();
      expect(FormStackAddUtil.equals(undefined, 'a')).assertFalse();
      expect(FormStackAddUtil.equals('a', null)).assertFalse();
      expect(FormStackAddUtil.equals('a', undefined)).assertFalse();
      expect(FormStackAddUtil.equals('a', 1)).assertFalse();
      expect(FormStackAddUtil.equals(1, 'a')).assertFalse();
      expect(FormStackAddUtil.equals(1, [])).assertFalse();
      expect(FormStackAddUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackAddUtil.equals([], m)).assertFalse();
      expect(FormStackAddUtil.equals(m, [])).assertFalse();
      expect(FormStackAddUtil.equals([1,2], [])).assertFalse();
      expect(FormStackAddUtil.equals([], [1, 2])).assertFalse();
      expect(FormStackAddUtil.equals([1], [1, 2])).assertFalse();
      expect(FormStackAddUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackAddUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackAddUtil.equals(2, 2)).assertTrue();
    })
  });
}