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
import { FormAnimateUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormAnimateUtil';

export function FormAnimateUtilTest() {
  describe('FormAnimateUtilTest', () => {
    it('FormAnimateUtil_001', 0, () => {
      expect(FormAnimateUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormAnimateUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormAnimateUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormAnimateUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormAnimateUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormAnimateUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormAnimateUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAnimateUtil_002', 0, () => {
      expect(FormAnimateUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormAnimateUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormAnimateUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormAnimateUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormAnimateUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormAnimateUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormAnimateUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAnimateUtil_003', 0, () => {
      expect(FormAnimateUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormAnimateUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormAnimateUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormAnimateUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormAnimateUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormAnimateUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormAnimateUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAnimateUtil_004', 0, () => {
      expect(FormAnimateUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormAnimateUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormAnimateUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormAnimateUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormAnimateUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormAnimateUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormAnimateUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAnimateUtil_005', 0, () => {
      expect(FormAnimateUtil.isNumber("")).assertFalse();
      expect(FormAnimateUtil.isNumber(null)).assertFalse();
      expect(FormAnimateUtil.isNumber(undefined)).assertFalse();
      expect(FormAnimateUtil.isNumber("abc")).assertFalse();
      expect(FormAnimateUtil.isNumber("123")).assertTrue();
    });

    it('FormAnimateUtil_006', 0, () => {
      expect(FormAnimateUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormAnimateUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormAnimateUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormAnimateUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormAnimateUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormAnimateUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAnimateUtil_007', 0, () => {
      expect(FormAnimateUtil.getDefaultId(null) === null).assertTrue();
      expect(FormAnimateUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormAnimateUtil.getDefaultId('') === '').assertTrue();
      expect(FormAnimateUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormAnimateUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormAnimateUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAnimateUtil_008', 0, () => {
      expect(FormAnimateUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormAnimateUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormAnimateUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormAnimateUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormAnimateUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormAnimateUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormAnimateUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAnimateUtil_009', 0, () => {
      expect(FormAnimateUtil.drawFontWidth() === -1).assertTrue();
      expect(FormAnimateUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormAnimateUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormAnimateUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormAnimateUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormAnimateUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormAnimateUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormAnimateUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormAnimateUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormAnimateUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormAnimateUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormAnimateUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormAnimateUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormAnimateUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormAnimateUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormAnimateUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormAnimateUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormAnimateUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormAnimateUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormAnimateUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormAnimateUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormAnimateUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAnimateUtil_010', 0, () => {
      expect(FormAnimateUtil.drawTextAlign() === -1).assertTrue();
      expect(FormAnimateUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormAnimateUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormAnimateUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormAnimateUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormAnimateUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormAnimateUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormAnimateUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAnimateUtil_011', 0, () => {
      expect(FormAnimateUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormAnimateUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormAnimateUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormAnimateUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormAnimateUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormAnimateUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormAnimateUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormAnimateUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormAnimateUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormAnimateUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormAnimateUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormAnimateUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormAnimateUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormAnimateUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormAnimateUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormAnimateUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormAnimateUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormAnimateUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormAnimateUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAnimateUtil_012', 0, () => {
      expect(FormAnimateUtil.checkArr([]) === false).assertTrue();
      expect(FormAnimateUtil.checkArr(null) === false).assertTrue();
      expect(FormAnimateUtil.checkArr(undefined) === false).assertTrue();
      expect(FormAnimateUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormAnimateUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormAnimateUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormAnimateUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormAnimateUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormAnimateUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormAnimateUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormAnimateUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormAnimateUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormAnimateUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormAnimateUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormAnimateUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormAnimateUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormAnimateUtil.getUUID().length > 0).assertTrue();
    })

    it('FormAnimateUtil_013', 0, () => {
      expect(FormAnimateUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormAnimateUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAnimateUtil_014', 0, () => {
      expect(FormAnimateUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormAnimateUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormAnimateUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormAnimateUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormAnimateUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormAnimateUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormAnimateUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormAnimateUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAnimateUtil_015', 0, () => {
      expect(FormAnimateUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormAnimateUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormAnimateUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormAnimateUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormAnimateUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormAnimateUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormAnimateUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormAnimateUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormAnimateUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormAnimateUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormAnimateUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormAnimateUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAnimateUtil_016', 0, () => {
      expect(FormAnimateUtil.isEmpty(null)).assertTrue();
      expect(FormAnimateUtil.isEmpty(undefined)).assertTrue();
      expect(FormAnimateUtil.isEmpty('')).assertTrue();
      expect(FormAnimateUtil.isEmpty(0)).assertTrue();
      expect(FormAnimateUtil.isEmpty([])).assertTrue();
      expect(FormAnimateUtil.isEmpty(1, null)).assertTrue();
      expect(FormAnimateUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormAnimateUtil.isEmpty(1, true)).assertTrue();
      expect(FormAnimateUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormAnimateUtil_017', 0, () => {
      expect(FormAnimateUtil.equals(null, 'a')).assertFalse();
      expect(FormAnimateUtil.equals(undefined, 'a')).assertFalse();
      expect(FormAnimateUtil.equals('a', null)).assertFalse();
      expect(FormAnimateUtil.equals('a', undefined)).assertFalse();
      expect(FormAnimateUtil.equals('a', 1)).assertFalse();
      expect(FormAnimateUtil.equals(1, 'a')).assertFalse();
      expect(FormAnimateUtil.equals(1, [])).assertFalse();
      expect(FormAnimateUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormAnimateUtil.equals([], m)).assertFalse();
      expect(FormAnimateUtil.equals(m, [])).assertFalse();
      expect(FormAnimateUtil.equals([1,2], [])).assertFalse();
      expect(FormAnimateUtil.equals([], [1, 2])).assertFalse();
      expect(FormAnimateUtil.equals([1], [1, 2])).assertFalse();
      expect(FormAnimateUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormAnimateUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormAnimateUtil.equals(2, 2)).assertTrue();
    })
  });
}