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
import { FormAccessUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormAccessUtil';

export function FormAccessUtilTest() {
  describe('FormAccessUtilTest', () => {
    it('FormAccessUtil_001', 0, () => {
      expect(FormAccessUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormAccessUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormAccessUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormAccessUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormAccessUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormAccessUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormAccessUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAccessUtil_002', 0, () => {
      expect(FormAccessUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormAccessUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormAccessUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormAccessUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormAccessUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormAccessUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormAccessUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAccessUtil_003', 0, () => {
      expect(FormAccessUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormAccessUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormAccessUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormAccessUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormAccessUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormAccessUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormAccessUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAccessUtil_004', 0, () => {
      expect(FormAccessUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormAccessUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormAccessUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormAccessUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormAccessUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormAccessUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormAccessUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAccessUtil_005', 0, () => {
      expect(FormAccessUtil.isNumber("")).assertFalse();
      expect(FormAccessUtil.isNumber(null)).assertFalse();
      expect(FormAccessUtil.isNumber(undefined)).assertFalse();
      expect(FormAccessUtil.isNumber("abc")).assertFalse();
      expect(FormAccessUtil.isNumber("123")).assertTrue();
    });

    it('FormAccessUtil_006', 0, () => {
      expect(FormAccessUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormAccessUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormAccessUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormAccessUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormAccessUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormAccessUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAccessUtil_007', 0, () => {
      expect(FormAccessUtil.getDefaultId(null) === null).assertTrue();
      expect(FormAccessUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormAccessUtil.getDefaultId('') === '').assertTrue();
      expect(FormAccessUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormAccessUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormAccessUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAccessUtil_008', 0, () => {
      expect(FormAccessUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormAccessUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormAccessUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormAccessUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormAccessUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormAccessUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormAccessUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAccessUtil_009', 0, () => {
      expect(FormAccessUtil.drawFontWidth() === -1).assertTrue();
      expect(FormAccessUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormAccessUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormAccessUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormAccessUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormAccessUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormAccessUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormAccessUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormAccessUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormAccessUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormAccessUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormAccessUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormAccessUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormAccessUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormAccessUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormAccessUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormAccessUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormAccessUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormAccessUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormAccessUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormAccessUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormAccessUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAccessUtil_010', 0, () => {
      expect(FormAccessUtil.drawTextAlign() === -1).assertTrue();
      expect(FormAccessUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormAccessUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormAccessUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormAccessUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormAccessUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormAccessUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormAccessUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAccessUtil_011', 0, () => {
      expect(FormAccessUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormAccessUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormAccessUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormAccessUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormAccessUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormAccessUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormAccessUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormAccessUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormAccessUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormAccessUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormAccessUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormAccessUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormAccessUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormAccessUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormAccessUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormAccessUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormAccessUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormAccessUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormAccessUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAccessUtil_012', 0, () => {
      expect(FormAccessUtil.checkArr([]) === false).assertTrue();
      expect(FormAccessUtil.checkArr(null) === false).assertTrue();
      expect(FormAccessUtil.checkArr(undefined) === false).assertTrue();
      expect(FormAccessUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormAccessUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormAccessUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormAccessUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormAccessUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormAccessUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormAccessUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormAccessUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormAccessUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormAccessUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormAccessUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormAccessUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormAccessUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormAccessUtil.getUUID().length > 0).assertTrue();
    })

    it('FormAccessUtil_013', 0, () => {
      expect(FormAccessUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormAccessUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAccessUtil_014', 0, () => {
      expect(FormAccessUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormAccessUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormAccessUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormAccessUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormAccessUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormAccessUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormAccessUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormAccessUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAccessUtil_015', 0, () => {
      expect(FormAccessUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormAccessUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormAccessUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormAccessUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormAccessUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormAccessUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormAccessUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormAccessUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormAccessUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormAccessUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormAccessUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormAccessUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAccessUtil_016', 0, () => {
      expect(FormAccessUtil.isEmpty(null)).assertTrue();
      expect(FormAccessUtil.isEmpty(undefined)).assertTrue();
      expect(FormAccessUtil.isEmpty('')).assertTrue();
      expect(FormAccessUtil.isEmpty(0)).assertTrue();
      expect(FormAccessUtil.isEmpty([])).assertTrue();
      expect(FormAccessUtil.isEmpty(1, null)).assertTrue();
      expect(FormAccessUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormAccessUtil.isEmpty(1, true)).assertTrue();
      expect(FormAccessUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormAccessUtil_017', 0, () => {
      expect(FormAccessUtil.equals(null, 'a')).assertFalse();
      expect(FormAccessUtil.equals(undefined, 'a')).assertFalse();
      expect(FormAccessUtil.equals('a', null)).assertFalse();
      expect(FormAccessUtil.equals('a', undefined)).assertFalse();
      expect(FormAccessUtil.equals('a', 1)).assertFalse();
      expect(FormAccessUtil.equals(1, 'a')).assertFalse();
      expect(FormAccessUtil.equals(1, [])).assertFalse();
      expect(FormAccessUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormAccessUtil.equals([], m)).assertFalse();
      expect(FormAccessUtil.equals(m, [])).assertFalse();
      expect(FormAccessUtil.equals([1,2], [])).assertFalse();
      expect(FormAccessUtil.equals([], [1, 2])).assertFalse();
      expect(FormAccessUtil.equals([1], [1, 2])).assertFalse();
      expect(FormAccessUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormAccessUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormAccessUtil.equals(2, 2)).assertTrue();
    })
  });
}