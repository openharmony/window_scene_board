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
import { FormThemeAddUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormThemeAddUtil';

export function FormThemeAddUtilTest() {
  describe('FormThemeAddUtilTest', () => {
    it('FormThemeAddUtil_001', 0, () => {
      expect(FormThemeAddUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormThemeAddUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormThemeAddUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormThemeAddUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormThemeAddUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormThemeAddUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormThemeAddUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormThemeAddUtil_002', 0, () => {
      expect(FormThemeAddUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormThemeAddUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormThemeAddUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAddUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormThemeAddUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAddUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormThemeAddUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormThemeAddUtil_003', 0, () => {
      expect(FormThemeAddUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormThemeAddUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAddUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAddUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAddUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAddUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormThemeAddUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormThemeAddUtil_004', 0, () => {
      expect(FormThemeAddUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormThemeAddUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAddUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAddUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAddUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAddUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormThemeAddUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormThemeAddUtil_005', 0, () => {
      expect(FormThemeAddUtil.isNumber("")).assertFalse();
      expect(FormThemeAddUtil.isNumber(null)).assertFalse();
      expect(FormThemeAddUtil.isNumber(undefined)).assertFalse();
      expect(FormThemeAddUtil.isNumber("abc")).assertFalse();
      expect(FormThemeAddUtil.isNumber("123")).assertTrue();
    });

    it('FormThemeAddUtil_006', 0, () => {
      expect(FormThemeAddUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormThemeAddUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormThemeAddUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormThemeAddUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormThemeAddUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormThemeAddUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormThemeAddUtil_007', 0, () => {
      expect(FormThemeAddUtil.getDefaultId(null) === null).assertTrue();
      expect(FormThemeAddUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormThemeAddUtil.getDefaultId('') === '').assertTrue();
      expect(FormThemeAddUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormThemeAddUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormThemeAddUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormThemeAddUtil_008', 0, () => {
      expect(FormThemeAddUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormThemeAddUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormThemeAddUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormThemeAddUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormThemeAddUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormThemeAddUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormThemeAddUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormThemeAddUtil_009', 0, () => {
      expect(FormThemeAddUtil.drawFontWidth() === -1).assertTrue();
      expect(FormThemeAddUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormThemeAddUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormThemeAddUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormThemeAddUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormThemeAddUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormThemeAddUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormThemeAddUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormThemeAddUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormThemeAddUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormThemeAddUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormThemeAddUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormThemeAddUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormThemeAddUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormThemeAddUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormThemeAddUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormThemeAddUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormThemeAddUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormThemeAddUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormThemeAddUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormThemeAddUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormThemeAddUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormThemeAddUtil_010', 0, () => {
      expect(FormThemeAddUtil.drawTextAlign() === -1).assertTrue();
      expect(FormThemeAddUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormThemeAddUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormThemeAddUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormThemeAddUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormThemeAddUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormThemeAddUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormThemeAddUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormThemeAddUtil_011', 0, () => {
      expect(FormThemeAddUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormThemeAddUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormThemeAddUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormThemeAddUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormThemeAddUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormThemeAddUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormThemeAddUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormThemeAddUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormThemeAddUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormThemeAddUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormThemeAddUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormThemeAddUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormThemeAddUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormThemeAddUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormThemeAddUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormThemeAddUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormThemeAddUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormThemeAddUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormThemeAddUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormThemeAddUtil_012', 0, () => {
      expect(FormThemeAddUtil.checkArr([]) === false).assertTrue();
      expect(FormThemeAddUtil.checkArr(null) === false).assertTrue();
      expect(FormThemeAddUtil.checkArr(undefined) === false).assertTrue();
      expect(FormThemeAddUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormThemeAddUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormThemeAddUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormThemeAddUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormThemeAddUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormThemeAddUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormThemeAddUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormThemeAddUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormThemeAddUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormThemeAddUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormThemeAddUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormThemeAddUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormThemeAddUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormThemeAddUtil.getUUID().length > 0).assertTrue();
    })

    it('FormThemeAddUtil_013', 0, () => {
      expect(FormThemeAddUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormThemeAddUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormThemeAddUtil_014', 0, () => {
      expect(FormThemeAddUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormThemeAddUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormThemeAddUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormThemeAddUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormThemeAddUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormThemeAddUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormThemeAddUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormThemeAddUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormThemeAddUtil_015', 0, () => {
      expect(FormThemeAddUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormThemeAddUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormThemeAddUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormThemeAddUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormThemeAddUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormThemeAddUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormThemeAddUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormThemeAddUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormThemeAddUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormThemeAddUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormThemeAddUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormThemeAddUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormThemeAddUtil_016', 0, () => {
      expect(FormThemeAddUtil.isEmpty(null)).assertTrue();
      expect(FormThemeAddUtil.isEmpty(undefined)).assertTrue();
      expect(FormThemeAddUtil.isEmpty('')).assertTrue();
      expect(FormThemeAddUtil.isEmpty(0)).assertTrue();
      expect(FormThemeAddUtil.isEmpty([])).assertTrue();
      expect(FormThemeAddUtil.isEmpty(1, null)).assertTrue();
      expect(FormThemeAddUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormThemeAddUtil.isEmpty(1, true)).assertTrue();
      expect(FormThemeAddUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormThemeAddUtil_017', 0, () => {
      expect(FormThemeAddUtil.equals(null, 'a')).assertFalse();
      expect(FormThemeAddUtil.equals(undefined, 'a')).assertFalse();
      expect(FormThemeAddUtil.equals('a', null)).assertFalse();
      expect(FormThemeAddUtil.equals('a', undefined)).assertFalse();
      expect(FormThemeAddUtil.equals('a', 1)).assertFalse();
      expect(FormThemeAddUtil.equals(1, 'a')).assertFalse();
      expect(FormThemeAddUtil.equals(1, [])).assertFalse();
      expect(FormThemeAddUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormThemeAddUtil.equals([], m)).assertFalse();
      expect(FormThemeAddUtil.equals(m, [])).assertFalse();
      expect(FormThemeAddUtil.equals([1,2], [])).assertFalse();
      expect(FormThemeAddUtil.equals([], [1, 2])).assertFalse();
      expect(FormThemeAddUtil.equals([1], [1, 2])).assertFalse();
      expect(FormThemeAddUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormThemeAddUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormThemeAddUtil.equals(2, 2)).assertTrue();
    })
  });
}