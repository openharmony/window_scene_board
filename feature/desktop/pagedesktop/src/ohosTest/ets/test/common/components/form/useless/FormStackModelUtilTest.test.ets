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
import { FormStackModelUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackModelUtil';

export function FormStackModelUtilTest() {
  describe('FormStackModelUtilTest', () => {
    it('FormStackModelUtil_001', 0, () => {
      expect(FormStackModelUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackModelUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackModelUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackModelUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackModelUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackModelUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackModelUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackModelUtil_002', 0, () => {
      expect(FormStackModelUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackModelUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackModelUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackModelUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackModelUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackModelUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackModelUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackModelUtil_003', 0, () => {
      expect(FormStackModelUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackModelUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackModelUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackModelUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackModelUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackModelUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackModelUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackModelUtil_004', 0, () => {
      expect(FormStackModelUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackModelUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackModelUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackModelUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackModelUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackModelUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackModelUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackModelUtil_005', 0, () => {
      expect(FormStackModelUtil.isNumber("")).assertFalse();
      expect(FormStackModelUtil.isNumber(null)).assertFalse();
      expect(FormStackModelUtil.isNumber(undefined)).assertFalse();
      expect(FormStackModelUtil.isNumber("abc")).assertFalse();
      expect(FormStackModelUtil.isNumber("123")).assertTrue();
    });

    it('FormStackModelUtil_006', 0, () => {
      expect(FormStackModelUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackModelUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackModelUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackModelUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackModelUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackModelUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackModelUtil_007', 0, () => {
      expect(FormStackModelUtil.getDefaultId(null) === null).assertTrue();
      expect(FormStackModelUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackModelUtil.getDefaultId('') === '').assertTrue();
      expect(FormStackModelUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormStackModelUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackModelUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackModelUtil_008', 0, () => {
      expect(FormStackModelUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackModelUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackModelUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackModelUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackModelUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackModelUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackModelUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackModelUtil_009', 0, () => {
      expect(FormStackModelUtil.drawFontWidth() === -1).assertTrue();
      expect(FormStackModelUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackModelUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackModelUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackModelUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackModelUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackModelUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackModelUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackModelUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackModelUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackModelUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackModelUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackModelUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackModelUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackModelUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackModelUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackModelUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackModelUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackModelUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackModelUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackModelUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackModelUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackModelUtil_010', 0, () => {
      expect(FormStackModelUtil.drawTextAlign() === -1).assertTrue();
      expect(FormStackModelUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackModelUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackModelUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackModelUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackModelUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackModelUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackModelUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackModelUtil_011', 0, () => {
      expect(FormStackModelUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackModelUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackModelUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackModelUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackModelUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackModelUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackModelUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackModelUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackModelUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackModelUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackModelUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackModelUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackModelUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackModelUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackModelUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackModelUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackModelUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackModelUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackModelUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackModelUtil_012', 0, () => {
      expect(FormStackModelUtil.checkArr([]) === false).assertTrue();
      expect(FormStackModelUtil.checkArr(null) === false).assertTrue();
      expect(FormStackModelUtil.checkArr(undefined) === false).assertTrue();
      expect(FormStackModelUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackModelUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackModelUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackModelUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackModelUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackModelUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackModelUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackModelUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackModelUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackModelUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackModelUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackModelUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackModelUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackModelUtil.getUUID().length > 0).assertTrue();
    })

    it('FormStackModelUtil_013', 0, () => {
      expect(FormStackModelUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackModelUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackModelUtil_014', 0, () => {
      expect(FormStackModelUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackModelUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackModelUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackModelUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackModelUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackModelUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackModelUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackModelUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackModelUtil_015', 0, () => {
      expect(FormStackModelUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackModelUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackModelUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormStackModelUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackModelUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackModelUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackModelUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackModelUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackModelUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackModelUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackModelUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackModelUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackModelUtil_016', 0, () => {
      expect(FormStackModelUtil.isEmpty(null)).assertTrue();
      expect(FormStackModelUtil.isEmpty(undefined)).assertTrue();
      expect(FormStackModelUtil.isEmpty('')).assertTrue();
      expect(FormStackModelUtil.isEmpty(0)).assertTrue();
      expect(FormStackModelUtil.isEmpty([])).assertTrue();
      expect(FormStackModelUtil.isEmpty(1, null)).assertTrue();
      expect(FormStackModelUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormStackModelUtil.isEmpty(1, true)).assertTrue();
      expect(FormStackModelUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormStackModelUtil_017', 0, () => {
      expect(FormStackModelUtil.equals(null, 'a')).assertFalse();
      expect(FormStackModelUtil.equals(undefined, 'a')).assertFalse();
      expect(FormStackModelUtil.equals('a', null)).assertFalse();
      expect(FormStackModelUtil.equals('a', undefined)).assertFalse();
      expect(FormStackModelUtil.equals('a', 1)).assertFalse();
      expect(FormStackModelUtil.equals(1, 'a')).assertFalse();
      expect(FormStackModelUtil.equals(1, [])).assertFalse();
      expect(FormStackModelUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackModelUtil.equals([], m)).assertFalse();
      expect(FormStackModelUtil.equals(m, [])).assertFalse();
      expect(FormStackModelUtil.equals([1,2], [])).assertFalse();
      expect(FormStackModelUtil.equals([], [1, 2])).assertFalse();
      expect(FormStackModelUtil.equals([1], [1, 2])).assertFalse();
      expect(FormStackModelUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackModelUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackModelUtil.equals(2, 2)).assertTrue();
    })
  });
}