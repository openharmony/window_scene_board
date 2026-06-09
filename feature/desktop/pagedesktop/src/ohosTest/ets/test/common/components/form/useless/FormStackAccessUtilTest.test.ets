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
import { FormStackAccessUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackAccessUtil';

export function FormStackAccessUtilTest() {
  describe('FormStackAccessUtilTest', () => {
    it('FormStackAccessUtil_001', 0, () => {
      expect(FormStackAccessUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackAccessUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackAccessUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackAccessUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackAccessUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackAccessUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackAccessUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackAccessUtil_002', 0, () => {
      expect(FormStackAccessUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackAccessUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackAccessUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackAccessUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackAccessUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackAccessUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackAccessUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackAccessUtil_003', 0, () => {
      expect(FormStackAccessUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackAccessUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackAccessUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAccessUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAccessUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAccessUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackAccessUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackAccessUtil_004', 0, () => {
      expect(FormStackAccessUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackAccessUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackAccessUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAccessUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAccessUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAccessUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackAccessUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackAccessUtil_005', 0, () => {
      expect(FormStackAccessUtil.isNumber("")).assertFalse();
      expect(FormStackAccessUtil.isNumber(null)).assertFalse();
      expect(FormStackAccessUtil.isNumber(undefined)).assertFalse();
      expect(FormStackAccessUtil.isNumber("abc")).assertFalse();
      expect(FormStackAccessUtil.isNumber("123")).assertTrue();
    });

    it('FormStackAccessUtil_006', 0, () => {
      expect(FormStackAccessUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackAccessUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackAccessUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackAccessUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackAccessUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackAccessUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackAccessUtil_007', 0, () => {
      expect(FormStackAccessUtil.getDefaultId(null) === null).assertTrue();
      expect(FormStackAccessUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackAccessUtil.getDefaultId('') === '').assertTrue();
      expect(FormStackAccessUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormStackAccessUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackAccessUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackAccessUtil_008', 0, () => {
      expect(FormStackAccessUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackAccessUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackAccessUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackAccessUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackAccessUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackAccessUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackAccessUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackAccessUtil_009', 0, () => {
      expect(FormStackAccessUtil.drawFontWidth() === -1).assertTrue();
      expect(FormStackAccessUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackAccessUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackAccessUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackAccessUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackAccessUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackAccessUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackAccessUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackAccessUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackAccessUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackAccessUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackAccessUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackAccessUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackAccessUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackAccessUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackAccessUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackAccessUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackAccessUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackAccessUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackAccessUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackAccessUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackAccessUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackAccessUtil_010', 0, () => {
      expect(FormStackAccessUtil.drawTextAlign() === -1).assertTrue();
      expect(FormStackAccessUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackAccessUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackAccessUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackAccessUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackAccessUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackAccessUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackAccessUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackAccessUtil_011', 0, () => {
      expect(FormStackAccessUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackAccessUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackAccessUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackAccessUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackAccessUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackAccessUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackAccessUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackAccessUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackAccessUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackAccessUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackAccessUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackAccessUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackAccessUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackAccessUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackAccessUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackAccessUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackAccessUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackAccessUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackAccessUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackAccessUtil_012', 0, () => {
      expect(FormStackAccessUtil.checkArr([]) === false).assertTrue();
      expect(FormStackAccessUtil.checkArr(null) === false).assertTrue();
      expect(FormStackAccessUtil.checkArr(undefined) === false).assertTrue();
      expect(FormStackAccessUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackAccessUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackAccessUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackAccessUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackAccessUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackAccessUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackAccessUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackAccessUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackAccessUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackAccessUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackAccessUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackAccessUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackAccessUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackAccessUtil.getUUID().length > 0).assertTrue();
    })

    it('FormStackAccessUtil_013', 0, () => {
      expect(FormStackAccessUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackAccessUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackAccessUtil_014', 0, () => {
      expect(FormStackAccessUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackAccessUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackAccessUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackAccessUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackAccessUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackAccessUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackAccessUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackAccessUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackAccessUtil_015', 0, () => {
      expect(FormStackAccessUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackAccessUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackAccessUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormStackAccessUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackAccessUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackAccessUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackAccessUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackAccessUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackAccessUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackAccessUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackAccessUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackAccessUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackAccessUtil_016', 0, () => {
      expect(FormStackAccessUtil.isEmpty(null)).assertTrue();
      expect(FormStackAccessUtil.isEmpty(undefined)).assertTrue();
      expect(FormStackAccessUtil.isEmpty('')).assertTrue();
      expect(FormStackAccessUtil.isEmpty(0)).assertTrue();
      expect(FormStackAccessUtil.isEmpty([])).assertTrue();
      expect(FormStackAccessUtil.isEmpty(1, null)).assertTrue();
      expect(FormStackAccessUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormStackAccessUtil.isEmpty(1, true)).assertTrue();
      expect(FormStackAccessUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormStackAccessUtil_017', 0, () => {
      expect(FormStackAccessUtil.equals(null, 'a')).assertFalse();
      expect(FormStackAccessUtil.equals(undefined, 'a')).assertFalse();
      expect(FormStackAccessUtil.equals('a', null)).assertFalse();
      expect(FormStackAccessUtil.equals('a', undefined)).assertFalse();
      expect(FormStackAccessUtil.equals('a', 1)).assertFalse();
      expect(FormStackAccessUtil.equals(1, 'a')).assertFalse();
      expect(FormStackAccessUtil.equals(1, [])).assertFalse();
      expect(FormStackAccessUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackAccessUtil.equals([], m)).assertFalse();
      expect(FormStackAccessUtil.equals(m, [])).assertFalse();
      expect(FormStackAccessUtil.equals([1,2], [])).assertFalse();
      expect(FormStackAccessUtil.equals([], [1, 2])).assertFalse();
      expect(FormStackAccessUtil.equals([1], [1, 2])).assertFalse();
      expect(FormStackAccessUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackAccessUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackAccessUtil.equals(2, 2)).assertTrue();
    })
  });
}