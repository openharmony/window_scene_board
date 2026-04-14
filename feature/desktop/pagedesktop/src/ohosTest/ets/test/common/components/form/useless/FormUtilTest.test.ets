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
import { FormUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormUtil';

export function FormUtilTest() {
  describe('FormUtilTest', () => {
    it('FormUtil_001', 0, () => {
      expect(FormUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormUtil_002', 0, () => {
      expect(FormUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormUtil_003', 0, () => {
      expect(FormUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormUtil_004', 0, () => {
      expect(FormUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormUtil_005', 0, () => {
      expect(FormUtil.isNumber("")).assertFalse();
      expect(FormUtil.isNumber(null)).assertFalse();
      expect(FormUtil.isNumber(undefined)).assertFalse();
      expect(FormUtil.isNumber("abc")).assertFalse();
      expect(FormUtil.isNumber("123")).assertTrue();
    });

    it('FormUtil_006', 0, () => {
      expect(FormUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormUtil_007', 0, () => {
      expect(FormUtil.getDefaultId(null) === null).assertTrue();
      expect(FormUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormUtil.getDefaultId('') === '').assertTrue();
      expect(FormUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormUtil_008', 0, () => {
      expect(FormUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormUtil_009', 0, () => {
      expect(FormUtil.drawFontWidth() === -1).assertTrue();
      expect(FormUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormUtil_010', 0, () => {
      expect(FormUtil.drawTextAlign() === -1).assertTrue();
      expect(FormUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormUtil_011', 0, () => {
      expect(FormUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormUtil_012', 0, () => {
      expect(FormUtil.checkArr([]) === false).assertTrue();
      expect(FormUtil.checkArr(null) === false).assertTrue();
      expect(FormUtil.checkArr(undefined) === false).assertTrue();
      expect(FormUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormUtil.getUUID().length > 0).assertTrue();
    })

    it('FormUtil_013', 0, () => {
      expect(FormUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormUtil_014', 0, () => {
      expect(FormUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormUtil_015', 0, () => {
      expect(FormUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormUtil_016', 0, () => {
      expect(FormUtil.isEmpty(null)).assertTrue();
      expect(FormUtil.isEmpty(undefined)).assertTrue();
      expect(FormUtil.isEmpty('')).assertTrue();
      expect(FormUtil.isEmpty(0)).assertTrue();
      expect(FormUtil.isEmpty([])).assertTrue();
      expect(FormUtil.isEmpty(1, null)).assertTrue();
      expect(FormUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormUtil.isEmpty(1, true)).assertTrue();
      expect(FormUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormUtil_017', 0, () => {
      expect(FormUtil.equals(null, 'a')).assertFalse();
      expect(FormUtil.equals(undefined, 'a')).assertFalse();
      expect(FormUtil.equals('a', null)).assertFalse();
      expect(FormUtil.equals('a', undefined)).assertFalse();
      expect(FormUtil.equals('a', 1)).assertFalse();
      expect(FormUtil.equals(1, 'a')).assertFalse();
      expect(FormUtil.equals(1, [])).assertFalse();
      expect(FormUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormUtil.equals([], m)).assertFalse();
      expect(FormUtil.equals(m, [])).assertFalse();
      expect(FormUtil.equals([1,2], [])).assertFalse();
      expect(FormUtil.equals([], [1, 2])).assertFalse();
      expect(FormUtil.equals([1], [1, 2])).assertFalse();
      expect(FormUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormUtil.equals(2, 2)).assertTrue();
    })
  });
}