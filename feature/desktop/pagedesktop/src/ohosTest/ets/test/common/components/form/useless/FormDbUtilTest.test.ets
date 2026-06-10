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
import { FormDbUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormDbUtil';

export function FormDbUtilTest() {
  describe('FormDbUtilTest', () => {
    it('FormDbUtil_001', 0, () => {
      expect(FormDbUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormDbUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormDbUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormDbUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormDbUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormDbUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormDbUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormDbUtil_002', 0, () => {
      expect(FormDbUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormDbUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormDbUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormDbUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormDbUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormDbUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormDbUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormDbUtil_003', 0, () => {
      expect(FormDbUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormDbUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormDbUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormDbUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormDbUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormDbUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormDbUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormDbUtil_004', 0, () => {
      expect(FormDbUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormDbUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormDbUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormDbUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormDbUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormDbUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormDbUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormDbUtil_005', 0, () => {
      expect(FormDbUtil.isNumber("")).assertFalse();
      expect(FormDbUtil.isNumber(null)).assertFalse();
      expect(FormDbUtil.isNumber(undefined)).assertFalse();
      expect(FormDbUtil.isNumber("abc")).assertFalse();
      expect(FormDbUtil.isNumber("123")).assertTrue();
    });

    it('FormDbUtil_006', 0, () => {
      expect(FormDbUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormDbUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormDbUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormDbUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormDbUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormDbUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormDbUtil_007', 0, () => {
      expect(FormDbUtil.getDefaultId(null) === null).assertTrue();
      expect(FormDbUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormDbUtil.getDefaultId('') === '').assertTrue();
      expect(FormDbUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormDbUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormDbUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormDbUtil_008', 0, () => {
      expect(FormDbUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormDbUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormDbUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormDbUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormDbUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormDbUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormDbUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormDbUtil_009', 0, () => {
      expect(FormDbUtil.drawFontWidth() === -1).assertTrue();
      expect(FormDbUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormDbUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormDbUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormDbUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormDbUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormDbUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormDbUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormDbUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormDbUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormDbUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormDbUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormDbUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormDbUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormDbUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormDbUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormDbUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormDbUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormDbUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormDbUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormDbUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormDbUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormDbUtil_010', 0, () => {
      expect(FormDbUtil.drawTextAlign() === -1).assertTrue();
      expect(FormDbUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormDbUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormDbUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormDbUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormDbUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormDbUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormDbUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormDbUtil_011', 0, () => {
      expect(FormDbUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormDbUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormDbUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormDbUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormDbUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormDbUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormDbUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormDbUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormDbUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormDbUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormDbUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormDbUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormDbUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormDbUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormDbUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormDbUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormDbUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormDbUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormDbUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormDbUtil_012', 0, () => {
      expect(FormDbUtil.checkArr([]) === false).assertTrue();
      expect(FormDbUtil.checkArr(null) === false).assertTrue();
      expect(FormDbUtil.checkArr(undefined) === false).assertTrue();
      expect(FormDbUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormDbUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormDbUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormDbUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormDbUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormDbUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormDbUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormDbUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormDbUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormDbUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormDbUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormDbUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormDbUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormDbUtil.getUUID().length > 0).assertTrue();
    })

    it('FormDbUtil_013', 0, () => {
      expect(FormDbUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormDbUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormDbUtil_014', 0, () => {
      expect(FormDbUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormDbUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormDbUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormDbUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormDbUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormDbUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormDbUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormDbUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormDbUtil_015', 0, () => {
      expect(FormDbUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormDbUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormDbUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormDbUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormDbUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormDbUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormDbUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormDbUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormDbUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormDbUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormDbUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormDbUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormDbUtil_016', 0, () => {
      expect(FormDbUtil.isEmpty(null)).assertTrue();
      expect(FormDbUtil.isEmpty(undefined)).assertTrue();
      expect(FormDbUtil.isEmpty('')).assertTrue();
      expect(FormDbUtil.isEmpty(0)).assertTrue();
      expect(FormDbUtil.isEmpty([])).assertTrue();
      expect(FormDbUtil.isEmpty(1, null)).assertTrue();
      expect(FormDbUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormDbUtil.isEmpty(1, true)).assertTrue();
      expect(FormDbUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormDbUtil_017', 0, () => {
      expect(FormDbUtil.equals(null, 'a')).assertFalse();
      expect(FormDbUtil.equals(undefined, 'a')).assertFalse();
      expect(FormDbUtil.equals('a', null)).assertFalse();
      expect(FormDbUtil.equals('a', undefined)).assertFalse();
      expect(FormDbUtil.equals('a', 1)).assertFalse();
      expect(FormDbUtil.equals(1, 'a')).assertFalse();
      expect(FormDbUtil.equals(1, [])).assertFalse();
      expect(FormDbUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormDbUtil.equals([], m)).assertFalse();
      expect(FormDbUtil.equals(m, [])).assertFalse();
      expect(FormDbUtil.equals([1,2], [])).assertFalse();
      expect(FormDbUtil.equals([], [1, 2])).assertFalse();
      expect(FormDbUtil.equals([1], [1, 2])).assertFalse();
      expect(FormDbUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormDbUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormDbUtil.equals(2, 2)).assertTrue();
    })
  });
}