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
import { FormPadUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormPadUtil';

export function FormPadUtilTest() {
  describe('FormPadUtilTest', () => {
    it('FormPadUtil_001', 0, () => {
      expect(FormPadUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormPadUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormPadUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormPadUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormPadUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormPadUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormPadUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormPadUtil_002', 0, () => {
      expect(FormPadUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormPadUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormPadUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormPadUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormPadUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormPadUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormPadUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormPadUtil_003', 0, () => {
      expect(FormPadUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormPadUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormPadUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormPadUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormPadUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormPadUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormPadUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormPadUtil_004', 0, () => {
      expect(FormPadUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormPadUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormPadUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormPadUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormPadUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormPadUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormPadUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormPadUtil_005', 0, () => {
      expect(FormPadUtil.isNumber("")).assertFalse();
      expect(FormPadUtil.isNumber(null)).assertFalse();
      expect(FormPadUtil.isNumber(undefined)).assertFalse();
      expect(FormPadUtil.isNumber("abc")).assertFalse();
      expect(FormPadUtil.isNumber("123")).assertTrue();
    });

    it('FormPadUtil_006', 0, () => {
      expect(FormPadUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormPadUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormPadUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormPadUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormPadUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormPadUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormPadUtil_007', 0, () => {
      expect(FormPadUtil.getDefaultId(null) === null).assertTrue();
      expect(FormPadUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormPadUtil.getDefaultId('') === '').assertTrue();
      expect(FormPadUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormPadUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormPadUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormPadUtil_008', 0, () => {
      expect(FormPadUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormPadUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormPadUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormPadUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormPadUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormPadUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormPadUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormPadUtil_009', 0, () => {
      expect(FormPadUtil.drawFontWidth() === -1).assertTrue();
      expect(FormPadUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormPadUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormPadUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormPadUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormPadUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormPadUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormPadUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormPadUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormPadUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormPadUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormPadUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormPadUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormPadUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormPadUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormPadUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormPadUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormPadUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormPadUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormPadUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormPadUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormPadUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormPadUtil_010', 0, () => {
      expect(FormPadUtil.drawTextAlign() === -1).assertTrue();
      expect(FormPadUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormPadUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormPadUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormPadUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormPadUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormPadUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormPadUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormPadUtil_011', 0, () => {
      expect(FormPadUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormPadUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormPadUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormPadUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormPadUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormPadUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormPadUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormPadUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormPadUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormPadUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormPadUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormPadUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormPadUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormPadUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormPadUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormPadUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormPadUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormPadUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormPadUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormPadUtil_012', 0, () => {
      expect(FormPadUtil.checkArr([]) === false).assertTrue();
      expect(FormPadUtil.checkArr(null) === false).assertTrue();
      expect(FormPadUtil.checkArr(undefined) === false).assertTrue();
      expect(FormPadUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormPadUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormPadUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormPadUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormPadUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormPadUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormPadUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormPadUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormPadUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormPadUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormPadUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormPadUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormPadUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormPadUtil.getUUID().length > 0).assertTrue();
    })

    it('FormPadUtil_013', 0, () => {
      expect(FormPadUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormPadUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormPadUtil_014', 0, () => {
      expect(FormPadUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormPadUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormPadUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormPadUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormPadUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormPadUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormPadUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormPadUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormPadUtil_015', 0, () => {
      expect(FormPadUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormPadUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormPadUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormPadUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormPadUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormPadUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormPadUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormPadUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormPadUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormPadUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormPadUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormPadUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormPadUtil_016', 0, () => {
      expect(FormPadUtil.isEmpty(null)).assertTrue();
      expect(FormPadUtil.isEmpty(undefined)).assertTrue();
      expect(FormPadUtil.isEmpty('')).assertTrue();
      expect(FormPadUtil.isEmpty(0)).assertTrue();
      expect(FormPadUtil.isEmpty([])).assertTrue();
      expect(FormPadUtil.isEmpty(1, null)).assertTrue();
      expect(FormPadUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormPadUtil.isEmpty(1, true)).assertTrue();
      expect(FormPadUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormPadUtil_017', 0, () => {
      expect(FormPadUtil.equals(null, 'a')).assertFalse();
      expect(FormPadUtil.equals(undefined, 'a')).assertFalse();
      expect(FormPadUtil.equals('a', null)).assertFalse();
      expect(FormPadUtil.equals('a', undefined)).assertFalse();
      expect(FormPadUtil.equals('a', 1)).assertFalse();
      expect(FormPadUtil.equals(1, 'a')).assertFalse();
      expect(FormPadUtil.equals(1, [])).assertFalse();
      expect(FormPadUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormPadUtil.equals([], m)).assertFalse();
      expect(FormPadUtil.equals(m, [])).assertFalse();
      expect(FormPadUtil.equals([1,2], [])).assertFalse();
      expect(FormPadUtil.equals([], [1, 2])).assertFalse();
      expect(FormPadUtil.equals([1], [1, 2])).assertFalse();
      expect(FormPadUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormPadUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormPadUtil.equals(2, 2)).assertTrue();
    })
  });
}