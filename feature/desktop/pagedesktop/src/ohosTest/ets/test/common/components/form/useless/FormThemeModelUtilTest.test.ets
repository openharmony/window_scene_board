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
import { FormThemeModelUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormThemeModelUtil';

export function FormThemeModelUtilTest() {
  describe('FormThemeModelUtilTest', () => {
    it('FormThemeModelUtil_001', 0, () => {
      expect(FormThemeModelUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormThemeModelUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormThemeModelUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormThemeModelUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormThemeModelUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormThemeModelUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormThemeModelUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormThemeModelUtil_002', 0, () => {
      expect(FormThemeModelUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormThemeModelUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormThemeModelUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormThemeModelUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormThemeModelUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormThemeModelUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormThemeModelUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormThemeModelUtil_003', 0, () => {
      expect(FormThemeModelUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormThemeModelUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormThemeModelUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeModelUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeModelUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeModelUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormThemeModelUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormThemeModelUtil_004', 0, () => {
      expect(FormThemeModelUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormThemeModelUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormThemeModelUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeModelUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeModelUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeModelUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormThemeModelUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormThemeModelUtil_005', 0, () => {
      expect(FormThemeModelUtil.isNumber("")).assertFalse();
      expect(FormThemeModelUtil.isNumber(null)).assertFalse();
      expect(FormThemeModelUtil.isNumber(undefined)).assertFalse();
      expect(FormThemeModelUtil.isNumber("abc")).assertFalse();
      expect(FormThemeModelUtil.isNumber("123")).assertTrue();
    });

    it('FormThemeModelUtil_006', 0, () => {
      expect(FormThemeModelUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormThemeModelUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormThemeModelUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormThemeModelUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormThemeModelUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormThemeModelUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormThemeModelUtil_007', 0, () => {
      expect(FormThemeModelUtil.getDefaultId(null) === null).assertTrue();
      expect(FormThemeModelUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormThemeModelUtil.getDefaultId('') === '').assertTrue();
      expect(FormThemeModelUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormThemeModelUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormThemeModelUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormThemeModelUtil_008', 0, () => {
      expect(FormThemeModelUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormThemeModelUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormThemeModelUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormThemeModelUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormThemeModelUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormThemeModelUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormThemeModelUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormThemeModelUtil_009', 0, () => {
      expect(FormThemeModelUtil.drawFontWidth() === -1).assertTrue();
      expect(FormThemeModelUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormThemeModelUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormThemeModelUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormThemeModelUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormThemeModelUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormThemeModelUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormThemeModelUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormThemeModelUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormThemeModelUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormThemeModelUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormThemeModelUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormThemeModelUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormThemeModelUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormThemeModelUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormThemeModelUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormThemeModelUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormThemeModelUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormThemeModelUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormThemeModelUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormThemeModelUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormThemeModelUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormThemeModelUtil_010', 0, () => {
      expect(FormThemeModelUtil.drawTextAlign() === -1).assertTrue();
      expect(FormThemeModelUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormThemeModelUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormThemeModelUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormThemeModelUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormThemeModelUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormThemeModelUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormThemeModelUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormThemeModelUtil_011', 0, () => {
      expect(FormThemeModelUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormThemeModelUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormThemeModelUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormThemeModelUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormThemeModelUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormThemeModelUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormThemeModelUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormThemeModelUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormThemeModelUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormThemeModelUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormThemeModelUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormThemeModelUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormThemeModelUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormThemeModelUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormThemeModelUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormThemeModelUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormThemeModelUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormThemeModelUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormThemeModelUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormThemeModelUtil_012', 0, () => {
      expect(FormThemeModelUtil.checkArr([]) === false).assertTrue();
      expect(FormThemeModelUtil.checkArr(null) === false).assertTrue();
      expect(FormThemeModelUtil.checkArr(undefined) === false).assertTrue();
      expect(FormThemeModelUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormThemeModelUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormThemeModelUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormThemeModelUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormThemeModelUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormThemeModelUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormThemeModelUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormThemeModelUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormThemeModelUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormThemeModelUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormThemeModelUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormThemeModelUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormThemeModelUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormThemeModelUtil.getUUID().length > 0).assertTrue();
    })

    it('FormThemeModelUtil_013', 0, () => {
      expect(FormThemeModelUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormThemeModelUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormThemeModelUtil_014', 0, () => {
      expect(FormThemeModelUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormThemeModelUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormThemeModelUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormThemeModelUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormThemeModelUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormThemeModelUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormThemeModelUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormThemeModelUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormThemeModelUtil_015', 0, () => {
      expect(FormThemeModelUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormThemeModelUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormThemeModelUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormThemeModelUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormThemeModelUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormThemeModelUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormThemeModelUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormThemeModelUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormThemeModelUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormThemeModelUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormThemeModelUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormThemeModelUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormThemeModelUtil_016', 0, () => {
      expect(FormThemeModelUtil.isEmpty(null)).assertTrue();
      expect(FormThemeModelUtil.isEmpty(undefined)).assertTrue();
      expect(FormThemeModelUtil.isEmpty('')).assertTrue();
      expect(FormThemeModelUtil.isEmpty(0)).assertTrue();
      expect(FormThemeModelUtil.isEmpty([])).assertTrue();
      expect(FormThemeModelUtil.isEmpty(1, null)).assertTrue();
      expect(FormThemeModelUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormThemeModelUtil.isEmpty(1, true)).assertTrue();
      expect(FormThemeModelUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormThemeModelUtil_017', 0, () => {
      expect(FormThemeModelUtil.equals(null, 'a')).assertFalse();
      expect(FormThemeModelUtil.equals(undefined, 'a')).assertFalse();
      expect(FormThemeModelUtil.equals('a', null)).assertFalse();
      expect(FormThemeModelUtil.equals('a', undefined)).assertFalse();
      expect(FormThemeModelUtil.equals('a', 1)).assertFalse();
      expect(FormThemeModelUtil.equals(1, 'a')).assertFalse();
      expect(FormThemeModelUtil.equals(1, [])).assertFalse();
      expect(FormThemeModelUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormThemeModelUtil.equals([], m)).assertFalse();
      expect(FormThemeModelUtil.equals(m, [])).assertFalse();
      expect(FormThemeModelUtil.equals([1,2], [])).assertFalse();
      expect(FormThemeModelUtil.equals([], [1, 2])).assertFalse();
      expect(FormThemeModelUtil.equals([1], [1, 2])).assertFalse();
      expect(FormThemeModelUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormThemeModelUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormThemeModelUtil.equals(2, 2)).assertTrue();
    })
  });
}