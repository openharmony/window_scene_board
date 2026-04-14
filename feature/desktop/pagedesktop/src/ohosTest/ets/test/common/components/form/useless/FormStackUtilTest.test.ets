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
import { FormStackUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackUtil';

export function FormStackUtilTest() {
  describe('FormStackUtilTest', () => {
    it('FormStackUtil_001', 0,() => {
      expect(FormStackUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackUtil_002', 0, () => {
      expect(FormStackUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackUtil_003', 0, () => {
      expect(FormStackUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackUtil_004', 0, () => {
      expect(FormStackUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackUtil_005', 0, () => {
      expect(FormStackUtil.isNumber("")).assertFalse();
      expect(FormStackUtil.isNumber(null)).assertFalse();
      expect(FormStackUtil.isNumber(undefined)).assertFalse();
      expect(FormStackUtil.isNumber("abc")).assertFalse();
      expect(FormStackUtil.isNumber("123")).assertTrue();
    });

    it('FormStackUtil_006', 0, () => {
      expect(FormStackUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackUtil_007', 0, () => {
      expect(FormStackUtil.getDefaultId(null) === null).assertTrue();
      expect(FormStackUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackUtil.getDefaultId('') === '').assertTrue();
      expect(FormStackUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormStackUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackUtil_008', 0, () => {
      expect(FormStackUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackUtil_009', 0, () => {
      expect(FormStackUtil.drawFontWidth() === -1).assertTrue();
      expect(FormStackUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackUtil_010', 0, () => {
      expect(FormStackUtil.drawTextAlign() === -1).assertTrue();
      expect(FormStackUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackUtil_011', 0, () => {
      expect(FormStackUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackUtil_012', 0, () => {
      expect(FormStackUtil.checkArr([]) === false).assertTrue();
      expect(FormStackUtil.checkArr(null) === false).assertTrue();
      expect(FormStackUtil.checkArr(undefined) === false).assertTrue();
      expect(FormStackUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackUtil.getUUID().length > 0).assertTrue();
    })

    it('FormStackUtil_013', 0, () => {
      expect(FormStackUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackUtil_014', 0, () => {
      expect(FormStackUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackUtil_015', 0, () => {
      expect(FormStackUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormStackUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackUtil_016', 0, () => {
      expect(FormStackUtil.isEmpty(null)).assertTrue();
      expect(FormStackUtil.isEmpty(undefined)).assertTrue();
      expect(FormStackUtil.isEmpty('')).assertTrue();
      expect(FormStackUtil.isEmpty(0)).assertTrue();
      expect(FormStackUtil.isEmpty([])).assertTrue();
      expect(FormStackUtil.isEmpty(1, null)).assertTrue();
      expect(FormStackUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormStackUtil.isEmpty(1, true)).assertTrue();
      expect(FormStackUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormStackUtil_017', 0, () => {
      expect(FormStackUtil.equals(null, 'a')).assertFalse();
      expect(FormStackUtil.equals(undefined, 'a')).assertFalse();
      expect(FormStackUtil.equals('a', null)).assertFalse();
      expect(FormStackUtil.equals('a', undefined)).assertFalse();
      expect(FormStackUtil.equals('a', 1)).assertFalse();
      expect(FormStackUtil.equals(1, 'a')).assertFalse();
      expect(FormStackUtil.equals(1, [])).assertFalse();
      expect(FormStackUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackUtil.equals([], m)).assertFalse();
      expect(FormStackUtil.equals(m, [])).assertFalse();
      expect(FormStackUtil.equals([1,2], [])).assertFalse();
      expect(FormStackUtil.equals([], [1, 2])).assertFalse();
      expect(FormStackUtil.equals([1], [1, 2])).assertFalse();
      expect(FormStackUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackUtil.equals(2, 2)).assertTrue();
    })
  });
}