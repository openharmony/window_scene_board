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
import { FormPcUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormPcUtil';

export function FormPcUtilTest() {
  describe('FormPcUtilTest', () => {
    it('FormPcUtil_001', 0, () => {
      expect(FormPcUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormPcUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormPcUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormPcUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormPcUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormPcUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormPcUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormPcUtil_002', 0, () => {
      expect(FormPcUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormPcUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormPcUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormPcUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormPcUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormPcUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormPcUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormPcUtil_003', 0, () => {
      expect(FormPcUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormPcUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormPcUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormPcUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormPcUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormPcUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormPcUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormPcUtil_004', 0, () => {
      expect(FormPcUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormPcUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormPcUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormPcUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormPcUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormPcUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormPcUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormPcUtil_005', 0, () => {
      expect(FormPcUtil.isNumber("")).assertFalse();
      expect(FormPcUtil.isNumber(null)).assertFalse();
      expect(FormPcUtil.isNumber(undefined)).assertFalse();
      expect(FormPcUtil.isNumber("abc")).assertFalse();
      expect(FormPcUtil.isNumber("123")).assertTrue();
    });

    it('FormPcUtil_006', 0, () => {
      expect(FormPcUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormPcUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormPcUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormPcUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormPcUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormPcUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormPcUtil_007', 0, () => {
      expect(FormPcUtil.getDefaultId(null) === null).assertTrue();
      expect(FormPcUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormPcUtil.getDefaultId('') === '').assertTrue();
      expect(FormPcUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormPcUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormPcUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormPcUtil_008', 0, () => {
      expect(FormPcUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormPcUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormPcUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormPcUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormPcUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormPcUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormPcUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormPcUtil_009', 0, () => {
      expect(FormPcUtil.drawFontWidth() === -1).assertTrue();
      expect(FormPcUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormPcUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormPcUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormPcUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormPcUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormPcUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormPcUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormPcUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormPcUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormPcUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormPcUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormPcUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormPcUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormPcUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormPcUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormPcUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormPcUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormPcUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormPcUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormPcUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormPcUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormPcUtil_010', 0, () => {
      expect(FormPcUtil.drawTextAlign() === -1).assertTrue();
      expect(FormPcUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormPcUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormPcUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormPcUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormPcUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormPcUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormPcUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormPcUtil_011', 0, () => {
      expect(FormPcUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormPcUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormPcUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormPcUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormPcUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormPcUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormPcUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormPcUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormPcUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormPcUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormPcUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormPcUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormPcUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormPcUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormPcUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormPcUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormPcUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormPcUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormPcUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormPcUtil_012', 0, () => {
      expect(FormPcUtil.checkArr([]) === false).assertTrue();
      expect(FormPcUtil.checkArr(null) === false).assertTrue();
      expect(FormPcUtil.checkArr(undefined) === false).assertTrue();
      expect(FormPcUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormPcUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormPcUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormPcUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormPcUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormPcUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormPcUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormPcUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormPcUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormPcUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormPcUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormPcUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormPcUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormPcUtil.getUUID().length > 0).assertTrue();
    })

    it('FormPcUtil_013', 0, () => {
      expect(FormPcUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormPcUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormPcUtil_014', 0, () => {
      expect(FormPcUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormPcUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormPcUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormPcUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormPcUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormPcUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormPcUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormPcUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormPcUtil_015', 0, () => {
      expect(FormPcUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormPcUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormPcUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormPcUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormPcUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormPcUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormPcUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormPcUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormPcUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormPcUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormPcUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormPcUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormPcUtil_016', 0, () => {
      expect(FormPcUtil.isEmpty(null)).assertTrue();
      expect(FormPcUtil.isEmpty(undefined)).assertTrue();
      expect(FormPcUtil.isEmpty('')).assertTrue();
      expect(FormPcUtil.isEmpty(0)).assertTrue();
      expect(FormPcUtil.isEmpty([])).assertTrue();
      expect(FormPcUtil.isEmpty(1, null)).assertTrue();
      expect(FormPcUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormPcUtil.isEmpty(1, true)).assertTrue();
      expect(FormPcUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormPcUtil_017', 0, () => {
      expect(FormPcUtil.equals(null, 'a')).assertFalse();
      expect(FormPcUtil.equals(undefined, 'a')).assertFalse();
      expect(FormPcUtil.equals('a', null)).assertFalse();
      expect(FormPcUtil.equals('a', undefined)).assertFalse();
      expect(FormPcUtil.equals('a', 1)).assertFalse();
      expect(FormPcUtil.equals(1, 'a')).assertFalse();
      expect(FormPcUtil.equals(1, [])).assertFalse();
      expect(FormPcUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormPcUtil.equals([], m)).assertFalse();
      expect(FormPcUtil.equals(m, [])).assertFalse();
      expect(FormPcUtil.equals([1,2], [])).assertFalse();
      expect(FormPcUtil.equals([], [1, 2])).assertFalse();
      expect(FormPcUtil.equals([1], [1, 2])).assertFalse();
      expect(FormPcUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormPcUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormPcUtil.equals(2, 2)).assertTrue();
    })
  });
}