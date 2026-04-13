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
import { FormAbilityUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormAbilityUtil';

export function FormAbilityUtilTest() {
  describe('FormAbilityUtilTest', () => {
    it('FormAbilityUtil_001', 0, () => {
      expect(FormAbilityUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormAbilityUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormAbilityUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormAbilityUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormAbilityUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormAbilityUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormAbilityUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAbilityUtil_002', 0, () => {
      expect(FormAbilityUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormAbilityUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormAbilityUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormAbilityUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormAbilityUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormAbilityUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormAbilityUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAbilityUtil_003', 0, () => {
      expect(FormAbilityUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormAbilityUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormAbilityUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormAbilityUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormAbilityUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormAbilityUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormAbilityUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAbilityUtil_004', 0, () => {
      expect(FormAbilityUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormAbilityUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormAbilityUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormAbilityUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormAbilityUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormAbilityUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormAbilityUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAbilityUtil_005', 0, () => {
      expect(FormAbilityUtil.isNumber("")).assertFalse();
      expect(FormAbilityUtil.isNumber(null)).assertFalse();
      expect(FormAbilityUtil.isNumber(undefined)).assertFalse();
      expect(FormAbilityUtil.isNumber("abc")).assertFalse();
      expect(FormAbilityUtil.isNumber("123")).assertTrue();
    });

    it('FormAbilityUtil_006', 0, () => {
      expect(FormAbilityUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormAbilityUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormAbilityUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormAbilityUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormAbilityUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormAbilityUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAbilityUtil_007', 0, () => {
      expect(FormAbilityUtil.getDefaultId(null) === null).assertTrue();
      expect(FormAbilityUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormAbilityUtil.getDefaultId('') === '').assertTrue();
      expect(FormAbilityUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormAbilityUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormAbilityUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAbilityUtil_008', 0, () => {
      expect(FormAbilityUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormAbilityUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormAbilityUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormAbilityUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormAbilityUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormAbilityUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormAbilityUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAbilityUtil_009', 0, () => {
      expect(FormAbilityUtil.drawFontWidth() === -1).assertTrue();
      expect(FormAbilityUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormAbilityUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormAbilityUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormAbilityUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormAbilityUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormAbilityUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormAbilityUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormAbilityUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormAbilityUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormAbilityUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormAbilityUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormAbilityUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormAbilityUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormAbilityUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormAbilityUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormAbilityUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormAbilityUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormAbilityUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormAbilityUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormAbilityUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormAbilityUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAbilityUtil_010', 0, () => {
      expect(FormAbilityUtil.drawTextAlign() === -1).assertTrue();
      expect(FormAbilityUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormAbilityUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormAbilityUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormAbilityUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormAbilityUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormAbilityUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormAbilityUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAbilityUtil_011', 0, () => {
      expect(FormAbilityUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormAbilityUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormAbilityUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormAbilityUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormAbilityUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormAbilityUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormAbilityUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormAbilityUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormAbilityUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormAbilityUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormAbilityUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormAbilityUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormAbilityUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormAbilityUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormAbilityUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormAbilityUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormAbilityUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormAbilityUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormAbilityUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAbilityUtil_012', 0, () => {
      expect(FormAbilityUtil.checkArr([]) === false).assertTrue();
      expect(FormAbilityUtil.checkArr(null) === false).assertTrue();
      expect(FormAbilityUtil.checkArr(undefined) === false).assertTrue();
      expect(FormAbilityUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormAbilityUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormAbilityUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormAbilityUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormAbilityUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormAbilityUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormAbilityUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormAbilityUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormAbilityUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormAbilityUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormAbilityUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormAbilityUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormAbilityUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormAbilityUtil.getUUID().length > 0).assertTrue();
    })

    it('FormAbilityUtil_013', 0, () => {
      expect(FormAbilityUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormAbilityUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAbilityUtil_014', 0, () => {
      expect(FormAbilityUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormAbilityUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormAbilityUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormAbilityUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormAbilityUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormAbilityUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormAbilityUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormAbilityUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAbilityUtil_015', 0, () => {
      expect(FormAbilityUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormAbilityUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormAbilityUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormAbilityUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormAbilityUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormAbilityUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormAbilityUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormAbilityUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormAbilityUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormAbilityUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormAbilityUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormAbilityUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAbilityUtil_016', 0, () => {
      expect(FormAbilityUtil.isEmpty(null)).assertTrue();
      expect(FormAbilityUtil.isEmpty(undefined)).assertTrue();
      expect(FormAbilityUtil.isEmpty('')).assertTrue();
      expect(FormAbilityUtil.isEmpty(0)).assertTrue();
      expect(FormAbilityUtil.isEmpty([])).assertTrue();
      expect(FormAbilityUtil.isEmpty(1, null)).assertTrue();
      expect(FormAbilityUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormAbilityUtil.isEmpty(1, true)).assertTrue();
      expect(FormAbilityUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormAbilityUtil_017', 0, () => {
      expect(FormAbilityUtil.equals(null, 'a')).assertFalse();
      expect(FormAbilityUtil.equals(undefined, 'a')).assertFalse();
      expect(FormAbilityUtil.equals('a', null)).assertFalse();
      expect(FormAbilityUtil.equals('a', undefined)).assertFalse();
      expect(FormAbilityUtil.equals('a', 1)).assertFalse();
      expect(FormAbilityUtil.equals(1, 'a')).assertFalse();
      expect(FormAbilityUtil.equals(1, [])).assertFalse();
      expect(FormAbilityUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormAbilityUtil.equals([], m)).assertFalse();
      expect(FormAbilityUtil.equals(m, [])).assertFalse();
      expect(FormAbilityUtil.equals([1,2], [])).assertFalse();
      expect(FormAbilityUtil.equals([], [1, 2])).assertFalse();
      expect(FormAbilityUtil.equals([1], [1, 2])).assertFalse();
      expect(FormAbilityUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormAbilityUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormAbilityUtil.equals(2, 2)).assertTrue();
    })
  });
}