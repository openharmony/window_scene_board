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
import { FormDeleteUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormDeleteUtil';

export function FormDeleteUtilTest() {
  describe('FormDeleteUtilTest', () => {
    it('FormDeleteUtil_001', 0, () => {
      expect(FormDeleteUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormDeleteUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormDeleteUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormDeleteUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormDeleteUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormDeleteUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormDeleteUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormDeleteUtil_002', 0, () => {
      expect(FormDeleteUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormDeleteUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormDeleteUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormDeleteUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormDeleteUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormDeleteUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormDeleteUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormDeleteUtil_003', 0, () => {
      expect(FormDeleteUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormDeleteUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormDeleteUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormDeleteUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormDeleteUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormDeleteUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormDeleteUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormDeleteUtil_004', 0, () => {
      expect(FormDeleteUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormDeleteUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormDeleteUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormDeleteUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormDeleteUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormDeleteUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormDeleteUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormDeleteUtil_005', 0, () => {
      expect(FormDeleteUtil.isNumber("")).assertFalse();
      expect(FormDeleteUtil.isNumber(null)).assertFalse();
      expect(FormDeleteUtil.isNumber(undefined)).assertFalse();
      expect(FormDeleteUtil.isNumber("abc")).assertFalse();
      expect(FormDeleteUtil.isNumber("123")).assertTrue();
    });

    it('FormDeleteUtil_006', 0, () => {
      expect(FormDeleteUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormDeleteUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormDeleteUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormDeleteUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormDeleteUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormDeleteUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormDeleteUtil_007', 0, () => {
      expect(FormDeleteUtil.getDefaultId(null) === null).assertTrue();
      expect(FormDeleteUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormDeleteUtil.getDefaultId('') === '').assertTrue();
      expect(FormDeleteUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormDeleteUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormDeleteUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormDeleteUtil_008', 0, () => {
      expect(FormDeleteUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormDeleteUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormDeleteUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormDeleteUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormDeleteUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormDeleteUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormDeleteUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormDeleteUtil_009', 0, () => {
      expect(FormDeleteUtil.drawFontWidth() === -1).assertTrue();
      expect(FormDeleteUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormDeleteUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormDeleteUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormDeleteUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormDeleteUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormDeleteUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormDeleteUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormDeleteUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormDeleteUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormDeleteUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormDeleteUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormDeleteUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormDeleteUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormDeleteUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormDeleteUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormDeleteUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormDeleteUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormDeleteUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormDeleteUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormDeleteUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormDeleteUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormDeleteUtil_010', 0, () => {
      expect(FormDeleteUtil.drawTextAlign() === -1).assertTrue();
      expect(FormDeleteUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormDeleteUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormDeleteUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormDeleteUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormDeleteUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormDeleteUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormDeleteUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormDeleteUtil_011', 0, () => {
      expect(FormDeleteUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormDeleteUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormDeleteUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormDeleteUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormDeleteUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormDeleteUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormDeleteUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormDeleteUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormDeleteUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormDeleteUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormDeleteUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormDeleteUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormDeleteUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormDeleteUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormDeleteUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormDeleteUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormDeleteUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormDeleteUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormDeleteUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormDeleteUtil_012', 0, () => {
      expect(FormDeleteUtil.checkArr([]) === false).assertTrue();
      expect(FormDeleteUtil.checkArr(null) === false).assertTrue();
      expect(FormDeleteUtil.checkArr(undefined) === false).assertTrue();
      expect(FormDeleteUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormDeleteUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormDeleteUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormDeleteUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormDeleteUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormDeleteUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormDeleteUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormDeleteUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormDeleteUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormDeleteUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormDeleteUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormDeleteUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormDeleteUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormDeleteUtil.getUUID().length > 0).assertTrue();
    })

    it('FormDeleteUtil_013', 0, () => {
      expect(FormDeleteUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormDeleteUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormDeleteUtil_014', 0, () => {
      expect(FormDeleteUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormDeleteUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormDeleteUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormDeleteUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormDeleteUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormDeleteUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormDeleteUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormDeleteUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormDeleteUtil_015', 0, () => {
      expect(FormDeleteUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormDeleteUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormDeleteUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormDeleteUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormDeleteUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormDeleteUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormDeleteUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormDeleteUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormDeleteUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormDeleteUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormDeleteUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormDeleteUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormDeleteUtil_016', 0, () => {
      expect(FormDeleteUtil.isEmpty(null)).assertTrue();
      expect(FormDeleteUtil.isEmpty(undefined)).assertTrue();
      expect(FormDeleteUtil.isEmpty('')).assertTrue();
      expect(FormDeleteUtil.isEmpty(0)).assertTrue();
      expect(FormDeleteUtil.isEmpty([])).assertTrue();
      expect(FormDeleteUtil.isEmpty(1, null)).assertTrue();
      expect(FormDeleteUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormDeleteUtil.isEmpty(1, true)).assertTrue();
      expect(FormDeleteUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormDeleteUtil_017', 0, () => {
      expect(FormDeleteUtil.equals(null, 'a')).assertFalse();
      expect(FormDeleteUtil.equals(undefined, 'a')).assertFalse();
      expect(FormDeleteUtil.equals('a', null)).assertFalse();
      expect(FormDeleteUtil.equals('a', undefined)).assertFalse();
      expect(FormDeleteUtil.equals('a', 1)).assertFalse();
      expect(FormDeleteUtil.equals(1, 'a')).assertFalse();
      expect(FormDeleteUtil.equals(1, [])).assertFalse();
      expect(FormDeleteUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormDeleteUtil.equals([], m)).assertFalse();
      expect(FormDeleteUtil.equals(m, [])).assertFalse();
      expect(FormDeleteUtil.equals([1,2], [])).assertFalse();
      expect(FormDeleteUtil.equals([], [1, 2])).assertFalse();
      expect(FormDeleteUtil.equals([1], [1, 2])).assertFalse();
      expect(FormDeleteUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormDeleteUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormDeleteUtil.equals(2, 2)).assertTrue();
    })
  });
}