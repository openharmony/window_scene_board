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
import { FormModelUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormModelUtil';

export function FormModelUtilTest() {
  describe('FormModelUtilTest', () => {
    it('FormModelUtil_001', 0, () => {
      expect(FormModelUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormModelUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormModelUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormModelUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormModelUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormModelUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormModelUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormModelUtil_002', 0, () => {
      expect(FormModelUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormModelUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormModelUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormModelUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormModelUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormModelUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormModelUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormModelUtil_003', 0, () => {
      expect(FormModelUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormModelUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormModelUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormModelUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormModelUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormModelUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormModelUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormModelUtil_004', 0, () => {
      expect(FormModelUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormModelUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormModelUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormModelUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormModelUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormModelUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormModelUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormModelUtil_005', 0, () => {
      expect(FormModelUtil.isNumber("")).assertFalse();
      expect(FormModelUtil.isNumber(null)).assertFalse();
      expect(FormModelUtil.isNumber(undefined)).assertFalse();
      expect(FormModelUtil.isNumber("abc")).assertFalse();
      expect(FormModelUtil.isNumber("123")).assertTrue();
    });

    it('FormModelUtil_006', 0, () => {
      expect(FormModelUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormModelUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormModelUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormModelUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormModelUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormModelUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormModelUtil_007', 0, () => {
      expect(FormModelUtil.getDefaultId(null) === null).assertTrue();
      expect(FormModelUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormModelUtil.getDefaultId('') === '').assertTrue();
      expect(FormModelUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormModelUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormModelUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormModelUtil_008', 0, () => {
      expect(FormModelUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormModelUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormModelUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormModelUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormModelUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormModelUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormModelUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormModelUtil_009', 0, () => {
      expect(FormModelUtil.drawFontWidth() === -1).assertTrue();
      expect(FormModelUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormModelUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormModelUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormModelUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormModelUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormModelUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormModelUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormModelUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormModelUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormModelUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormModelUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormModelUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormModelUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormModelUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormModelUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormModelUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormModelUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormModelUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormModelUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormModelUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormModelUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormModelUtil_010', 0, () => {
      expect(FormModelUtil.drawTextAlign() === -1).assertTrue();
      expect(FormModelUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormModelUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormModelUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormModelUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormModelUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormModelUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormModelUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormModelUtil_011', 0, () => {
      expect(FormModelUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormModelUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormModelUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormModelUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormModelUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormModelUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormModelUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormModelUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormModelUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormModelUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormModelUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormModelUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormModelUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormModelUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormModelUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormModelUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormModelUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormModelUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormModelUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormModelUtil_012', 0, () => {
      expect(FormModelUtil.checkArr([]) === false).assertTrue();
      expect(FormModelUtil.checkArr(null) === false).assertTrue();
      expect(FormModelUtil.checkArr(undefined) === false).assertTrue();
      expect(FormModelUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormModelUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormModelUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormModelUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormModelUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormModelUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormModelUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormModelUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormModelUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormModelUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormModelUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormModelUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormModelUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormModelUtil.getUUID().length > 0).assertTrue();
    })

    it('FormModelUtil_013', 0, () => {
      expect(FormModelUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormModelUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormModelUtil_014', 0, () => {
      expect(FormModelUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormModelUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormModelUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormModelUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormModelUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormModelUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormModelUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormModelUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormModelUtil_015', 0, () => {
      expect(FormModelUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormModelUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormModelUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormModelUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormModelUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormModelUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormModelUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormModelUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormModelUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormModelUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormModelUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormModelUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormModelUtil_016', 0, () => {
      expect(FormModelUtil.isEmpty(null)).assertTrue();
      expect(FormModelUtil.isEmpty(undefined)).assertTrue();
      expect(FormModelUtil.isEmpty('')).assertTrue();
      expect(FormModelUtil.isEmpty(0)).assertTrue();
      expect(FormModelUtil.isEmpty([])).assertTrue();
      expect(FormModelUtil.isEmpty(1, null)).assertTrue();
      expect(FormModelUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormModelUtil.isEmpty(1, true)).assertTrue();
      expect(FormModelUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormModelUtil_017', 0, () => {
      expect(FormModelUtil.equals(null, 'a')).assertFalse();
      expect(FormModelUtil.equals(undefined, 'a')).assertFalse();
      expect(FormModelUtil.equals('a', null)).assertFalse();
      expect(FormModelUtil.equals('a', undefined)).assertFalse();
      expect(FormModelUtil.equals('a', 1)).assertFalse();
      expect(FormModelUtil.equals(1, 'a')).assertFalse();
      expect(FormModelUtil.equals(1, [])).assertFalse();
      expect(FormModelUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormModelUtil.equals([], m)).assertFalse();
      expect(FormModelUtil.equals(m, [])).assertFalse();
      expect(FormModelUtil.equals([1,2], [])).assertFalse();
      expect(FormModelUtil.equals([], [1, 2])).assertFalse();
      expect(FormModelUtil.equals([1], [1, 2])).assertFalse();
      expect(FormModelUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormModelUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormModelUtil.equals(2, 2)).assertTrue();
    })
  });
}