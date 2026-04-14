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
import { FormStackExpandUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackExpandUtil';

export function FormStackExpandUtilTest() {
  describe('FormStackExpandUtilTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackExpandUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackExpandUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackExpandUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackExpandUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackExpandUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackExpandUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackExpandUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackExpandUtil_002', 0, () => {
      expect(FormStackExpandUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackExpandUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackExpandUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackExpandUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackExpandUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackExpandUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackExpandUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackExpandUtil_003', 0, () => {
      expect(FormStackExpandUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackExpandUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackExpandUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackExpandUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackExpandUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackExpandUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackExpandUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackExpandUtil_004', 0, () => {
      expect(FormStackExpandUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackExpandUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackExpandUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackExpandUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackExpandUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackExpandUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackExpandUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackExpandUtil_005', 0, () => {
      expect(FormStackExpandUtil.isNumber("")).assertFalse();
      expect(FormStackExpandUtil.isNumber(null)).assertFalse();
      expect(FormStackExpandUtil.isNumber(undefined)).assertFalse();
      expect(FormStackExpandUtil.isNumber("abc")).assertFalse();
      expect(FormStackExpandUtil.isNumber("123")).assertTrue();
    });

    it('FormStackExpandUtil_006', 0, () => {
      expect(FormStackExpandUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackExpandUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackExpandUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackExpandUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackExpandUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackExpandUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackExpandUtil_007', 0, () => {
      expect(FormStackExpandUtil.getDefaultId(null) === null).assertTrue();
      expect(FormStackExpandUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackExpandUtil.getDefaultId('') === '').assertTrue();
      expect(FormStackExpandUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormStackExpandUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackExpandUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackExpandUtil_008', 0, () => {
      expect(FormStackExpandUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackExpandUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackExpandUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackExpandUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackExpandUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackExpandUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackExpandUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackExpandUtil_009', 0, () => {
      expect(FormStackExpandUtil.drawFontWidth() === -1).assertTrue();
      expect(FormStackExpandUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackExpandUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackExpandUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackExpandUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackExpandUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackExpandUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackExpandUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackExpandUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackExpandUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackExpandUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackExpandUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackExpandUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackExpandUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackExpandUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackExpandUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackExpandUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackExpandUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackExpandUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackExpandUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackExpandUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackExpandUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackExpandUtil_010', 0, () => {
      expect(FormStackExpandUtil.drawTextAlign() === -1).assertTrue();
      expect(FormStackExpandUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackExpandUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackExpandUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackExpandUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackExpandUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackExpandUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackExpandUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackExpandUtil_011', 0, () => {
      expect(FormStackExpandUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackExpandUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackExpandUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackExpandUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackExpandUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackExpandUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackExpandUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackExpandUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackExpandUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackExpandUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackExpandUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackExpandUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackExpandUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackExpandUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackExpandUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackExpandUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackExpandUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackExpandUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackExpandUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackExpandUtil_012', 0, () => {
      expect(FormStackExpandUtil.checkArr([]) === false).assertTrue();
      expect(FormStackExpandUtil.checkArr(null) === false).assertTrue();
      expect(FormStackExpandUtil.checkArr(undefined) === false).assertTrue();
      expect(FormStackExpandUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackExpandUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackExpandUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackExpandUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackExpandUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackExpandUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackExpandUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackExpandUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackExpandUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackExpandUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackExpandUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackExpandUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackExpandUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackExpandUtil.getUUID().length > 0).assertTrue();
    })

    it('FormStackExpandUtil_013', 0, () => {
      expect(FormStackExpandUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackExpandUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackExpandUtil_014', 0, () => {
      expect(FormStackExpandUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackExpandUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackExpandUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackExpandUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackExpandUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackExpandUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackExpandUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackExpandUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackExpandUtil_015', 0, () => {
      expect(FormStackExpandUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackExpandUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackExpandUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormStackExpandUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackExpandUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackExpandUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackExpandUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackExpandUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackExpandUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackExpandUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackExpandUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackExpandUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackExpandUtil_016', 0, () => {
      expect(FormStackExpandUtil.isEmpty(null)).assertTrue();
      expect(FormStackExpandUtil.isEmpty(undefined)).assertTrue();
      expect(FormStackExpandUtil.isEmpty('')).assertTrue();
      expect(FormStackExpandUtil.isEmpty(0)).assertTrue();
      expect(FormStackExpandUtil.isEmpty([])).assertTrue();
      expect(FormStackExpandUtil.isEmpty(1, null)).assertTrue();
      expect(FormStackExpandUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormStackExpandUtil.isEmpty(1, true)).assertTrue();
      expect(FormStackExpandUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormStackExpandUtil_017', 0, () => {
      expect(FormStackExpandUtil.equals(null, 'a')).assertFalse();
      expect(FormStackExpandUtil.equals(undefined, 'a')).assertFalse();
      expect(FormStackExpandUtil.equals('a', null)).assertFalse();
      expect(FormStackExpandUtil.equals('a', undefined)).assertFalse();
      expect(FormStackExpandUtil.equals('a', 1)).assertFalse();
      expect(FormStackExpandUtil.equals(1, 'a')).assertFalse();
      expect(FormStackExpandUtil.equals(1, [])).assertFalse();
      expect(FormStackExpandUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackExpandUtil.equals([], m)).assertFalse();
      expect(FormStackExpandUtil.equals(m, [])).assertFalse();
      expect(FormStackExpandUtil.equals([1,2], [])).assertFalse();
      expect(FormStackExpandUtil.equals([], [1, 2])).assertFalse();
      expect(FormStackExpandUtil.equals([1], [1, 2])).assertFalse();
      expect(FormStackExpandUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackExpandUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackExpandUtil.equals(2, 2)).assertTrue();
    })
  });
}