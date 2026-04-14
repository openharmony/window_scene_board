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
import { FormThemeAbilityUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormThemeAbilityUtil';

export function FormThemeAbilityUtilTest() {
  describe('FormThemeAbilityUtilTest', () => {
    it('FormThemeAbilityUtil_001', 0, () => {
      expect(FormThemeAbilityUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormThemeAbilityUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormThemeAbilityUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormThemeAbilityUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormThemeAbilityUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormThemeAbilityUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormThemeAbilityUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormThemeAbilityUtil_002', 0, () => {
      expect(FormThemeAbilityUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormThemeAbilityUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormThemeAbilityUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAbilityUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormThemeAbilityUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAbilityUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormThemeAbilityUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormThemeAbilityUtil_003', 0, () => {
      expect(FormThemeAbilityUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormThemeAbilityUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAbilityUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAbilityUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAbilityUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAbilityUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormThemeAbilityUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormThemeAbilityUtil_004', 0, () => {
      expect(FormThemeAbilityUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormThemeAbilityUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAbilityUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAbilityUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAbilityUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAbilityUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormThemeAbilityUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormThemeAbilityUtil_005', 0, () => {
      expect(FormThemeAbilityUtil.isNumber("")).assertFalse();
      expect(FormThemeAbilityUtil.isNumber(null)).assertFalse();
      expect(FormThemeAbilityUtil.isNumber(undefined)).assertFalse();
      expect(FormThemeAbilityUtil.isNumber("abc")).assertFalse();
      expect(FormThemeAbilityUtil.isNumber("123")).assertTrue();
    });

    it('FormThemeAbilityUtil_006', 0, () => {
      expect(FormThemeAbilityUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormThemeAbilityUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormThemeAbilityUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormThemeAbilityUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormThemeAbilityUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormThemeAbilityUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormThemeAbilityUtil_007', 0, () => {
      expect(FormThemeAbilityUtil.getDefaultId(null) === null).assertTrue();
      expect(FormThemeAbilityUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormThemeAbilityUtil.getDefaultId('') === '').assertTrue();
      expect(FormThemeAbilityUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormThemeAbilityUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormThemeAbilityUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormThemeAbilityUtil_008', 0, () => {
      expect(FormThemeAbilityUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormThemeAbilityUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormThemeAbilityUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormThemeAbilityUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormThemeAbilityUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormThemeAbilityUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormThemeAbilityUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormThemeAbilityUtil_009', 0, () => {
      expect(FormThemeAbilityUtil.drawFontWidth() === -1).assertTrue();
      expect(FormThemeAbilityUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormThemeAbilityUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormThemeAbilityUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormThemeAbilityUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormThemeAbilityUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormThemeAbilityUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormThemeAbilityUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormThemeAbilityUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormThemeAbilityUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormThemeAbilityUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormThemeAbilityUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormThemeAbilityUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormThemeAbilityUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormThemeAbilityUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormThemeAbilityUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormThemeAbilityUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormThemeAbilityUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormThemeAbilityUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormThemeAbilityUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormThemeAbilityUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormThemeAbilityUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormThemeAbilityUtil_010', 0, () => {
      expect(FormThemeAbilityUtil.drawTextAlign() === -1).assertTrue();
      expect(FormThemeAbilityUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormThemeAbilityUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormThemeAbilityUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormThemeAbilityUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormThemeAbilityUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormThemeAbilityUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormThemeAbilityUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormThemeAbilityUtil_011', 0, () => {
      expect(FormThemeAbilityUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormThemeAbilityUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormThemeAbilityUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormThemeAbilityUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormThemeAbilityUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormThemeAbilityUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormThemeAbilityUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormThemeAbilityUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormThemeAbilityUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormThemeAbilityUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormThemeAbilityUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormThemeAbilityUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormThemeAbilityUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormThemeAbilityUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormThemeAbilityUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormThemeAbilityUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormThemeAbilityUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormThemeAbilityUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormThemeAbilityUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormThemeAbilityUtil_012', 0, () => {
      expect(FormThemeAbilityUtil.checkArr([]) === false).assertTrue();
      expect(FormThemeAbilityUtil.checkArr(null) === false).assertTrue();
      expect(FormThemeAbilityUtil.checkArr(undefined) === false).assertTrue();
      expect(FormThemeAbilityUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormThemeAbilityUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormThemeAbilityUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormThemeAbilityUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormThemeAbilityUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormThemeAbilityUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormThemeAbilityUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormThemeAbilityUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormThemeAbilityUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormThemeAbilityUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormThemeAbilityUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormThemeAbilityUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormThemeAbilityUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormThemeAbilityUtil.getUUID().length > 0).assertTrue();
    })

    it('FormThemeAbilityUtil_013', 0, () => {
      expect(FormThemeAbilityUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormThemeAbilityUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormThemeAbilityUtil_014', 0, () => {
      expect(FormThemeAbilityUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormThemeAbilityUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormThemeAbilityUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormThemeAbilityUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormThemeAbilityUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormThemeAbilityUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormThemeAbilityUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormThemeAbilityUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormThemeAbilityUtil_015', 0, () => {
      expect(FormThemeAbilityUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormThemeAbilityUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormThemeAbilityUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormThemeAbilityUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormThemeAbilityUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormThemeAbilityUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormThemeAbilityUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormThemeAbilityUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormThemeAbilityUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormThemeAbilityUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormThemeAbilityUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormThemeAbilityUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormThemeAbilityUtil_016', 0, () => {
      expect(FormThemeAbilityUtil.isEmpty(null)).assertTrue();
      expect(FormThemeAbilityUtil.isEmpty(undefined)).assertTrue();
      expect(FormThemeAbilityUtil.isEmpty('')).assertTrue();
      expect(FormThemeAbilityUtil.isEmpty(0)).assertTrue();
      expect(FormThemeAbilityUtil.isEmpty([])).assertTrue();
      expect(FormThemeAbilityUtil.isEmpty(1, null)).assertTrue();
      expect(FormThemeAbilityUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormThemeAbilityUtil.isEmpty(1, true)).assertTrue();
      expect(FormThemeAbilityUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormThemeAbilityUtil_017', 0, () => {
      expect(FormThemeAbilityUtil.equals(null, 'a')).assertFalse();
      expect(FormThemeAbilityUtil.equals(undefined, 'a')).assertFalse();
      expect(FormThemeAbilityUtil.equals('a', null)).assertFalse();
      expect(FormThemeAbilityUtil.equals('a', undefined)).assertFalse();
      expect(FormThemeAbilityUtil.equals('a', 1)).assertFalse();
      expect(FormThemeAbilityUtil.equals(1, 'a')).assertFalse();
      expect(FormThemeAbilityUtil.equals(1, [])).assertFalse();
      expect(FormThemeAbilityUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormThemeAbilityUtil.equals([], m)).assertFalse();
      expect(FormThemeAbilityUtil.equals(m, [])).assertFalse();
      expect(FormThemeAbilityUtil.equals([1,2], [])).assertFalse();
      expect(FormThemeAbilityUtil.equals([], [1, 2])).assertFalse();
      expect(FormThemeAbilityUtil.equals([1], [1, 2])).assertFalse();
      expect(FormThemeAbilityUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormThemeAbilityUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormThemeAbilityUtil.equals(2, 2)).assertTrue();
    })
  });
}