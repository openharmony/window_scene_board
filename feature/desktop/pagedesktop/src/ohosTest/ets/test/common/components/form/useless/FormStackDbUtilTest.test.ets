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
import { FormStackDbUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackDbUtil';

export function FormStackDbUtilTest() {
  describe('FormStackDbUtilTest', () => {
    it('FormStackDbUtil_001', 0, () => {
      expect(FormStackDbUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackDbUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackDbUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackDbUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackDbUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackDbUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackDbUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackDbUtil_002', 0, () => {
      expect(FormStackDbUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackDbUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackDbUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackDbUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackDbUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackDbUtil_003', 0, () => {
      expect(FormStackDbUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackDbUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackDbUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackDbUtil_004', 0, () => {
      expect(FormStackDbUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackDbUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackDbUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackDbUtil_005', 0, () => {
      expect(FormStackDbUtil.isNumber("")).assertFalse();
      expect(FormStackDbUtil.isNumber(null)).assertFalse();
      expect(FormStackDbUtil.isNumber(undefined)).assertFalse();
      expect(FormStackDbUtil.isNumber("abc")).assertFalse();
      expect(FormStackDbUtil.isNumber("123")).assertTrue();
    });

    it('FormStackDbUtil_006', 0, () => {
      expect(FormStackDbUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackDbUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackDbUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackDbUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackDbUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackDbUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackDbUtil_007', 0, () => {
      expect(FormStackDbUtil.getDefaultId(null) === null).assertTrue();
      expect(FormStackDbUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackDbUtil.getDefaultId('') === '').assertTrue();
      expect(FormStackDbUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormStackDbUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackDbUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackDbUtil_008', 0, () => {
      expect(FormStackDbUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackDbUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackDbUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackDbUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackDbUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackDbUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackDbUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackDbUtil_009', 0, () => {
      expect(FormStackDbUtil.drawFontWidth() === -1).assertTrue();
      expect(FormStackDbUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackDbUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackDbUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackDbUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackDbUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackDbUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackDbUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackDbUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackDbUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackDbUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackDbUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackDbUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackDbUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackDbUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackDbUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackDbUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackDbUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackDbUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackDbUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackDbUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackDbUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackDbUtil_010', 0, () => {
      expect(FormStackDbUtil.drawTextAlign() === -1).assertTrue();
      expect(FormStackDbUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackDbUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackDbUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackDbUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackDbUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackDbUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackDbUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackDbUtil_011', 0, () => {
      expect(FormStackDbUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackDbUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackDbUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackDbUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackDbUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackDbUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackDbUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackDbUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackDbUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackDbUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackDbUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackDbUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackDbUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackDbUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackDbUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackDbUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackDbUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackDbUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackDbUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackDbUtil_012', 0, () => {
      expect(FormStackDbUtil.checkArr([]) === false).assertTrue();
      expect(FormStackDbUtil.checkArr(null) === false).assertTrue();
      expect(FormStackDbUtil.checkArr(undefined) === false).assertTrue();
      expect(FormStackDbUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackDbUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackDbUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackDbUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackDbUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackDbUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackDbUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackDbUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackDbUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackDbUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackDbUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackDbUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackDbUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackDbUtil.getUUID().length > 0).assertTrue();
    })

    it('FormStackDbUtil_013', 0, () => {
      expect(FormStackDbUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackDbUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackDbUtil_014', 0, () => {
      expect(FormStackDbUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackDbUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackDbUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackDbUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackDbUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackDbUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackDbUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackDbUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackDbUtil_015', 0, () => {
      expect(FormStackDbUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackDbUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackDbUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormStackDbUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackDbUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackDbUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackDbUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackDbUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackDbUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackDbUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackDbUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackDbUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackDbUtil_016', 0, () => {
      expect(FormStackDbUtil.isEmpty(null)).assertTrue();
      expect(FormStackDbUtil.isEmpty(undefined)).assertTrue();
      expect(FormStackDbUtil.isEmpty('')).assertTrue();
      expect(FormStackDbUtil.isEmpty(0)).assertTrue();
      expect(FormStackDbUtil.isEmpty([])).assertTrue();
      expect(FormStackDbUtil.isEmpty(1, null)).assertTrue();
      expect(FormStackDbUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormStackDbUtil.isEmpty(1, true)).assertTrue();
      expect(FormStackDbUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormStackDbUtil_017', 0, () => {
      expect(FormStackDbUtil.equals(null, 'a')).assertFalse();
      expect(FormStackDbUtil.equals(undefined, 'a')).assertFalse();
      expect(FormStackDbUtil.equals('a', null)).assertFalse();
      expect(FormStackDbUtil.equals('a', undefined)).assertFalse();
      expect(FormStackDbUtil.equals('a', 1)).assertFalse();
      expect(FormStackDbUtil.equals(1, 'a')).assertFalse();
      expect(FormStackDbUtil.equals(1, [])).assertFalse();
      expect(FormStackDbUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackDbUtil.equals([], m)).assertFalse();
      expect(FormStackDbUtil.equals(m, [])).assertFalse();
      expect(FormStackDbUtil.equals([1,2], [])).assertFalse();
      expect(FormStackDbUtil.equals([], [1, 2])).assertFalse();
      expect(FormStackDbUtil.equals([1], [1, 2])).assertFalse();
      expect(FormStackDbUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackDbUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackDbUtil.equals(2, 2)).assertTrue();
    })
  });
}