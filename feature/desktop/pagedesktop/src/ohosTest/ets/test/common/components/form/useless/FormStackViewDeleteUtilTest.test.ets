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
import { FormStackViewDeleteUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackViewDeleteUtil';

export function FormStackViewDeleteUtilTest() {
  describe('FormStackViewDeleteUtilTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackViewDeleteUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackViewDeleteUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackViewDeleteUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackViewDeleteUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackViewDeleteUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackViewDeleteUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackViewDeleteUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackViewDeleteUtil_002', 0, () => {
      expect(FormStackViewDeleteUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackViewDeleteUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackViewDeleteUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewDeleteUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackViewDeleteUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewDeleteUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackViewDeleteUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackViewDeleteUtil_003', 0, () => {
      expect(FormStackViewDeleteUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackViewDeleteUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewDeleteUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewDeleteUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewDeleteUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewDeleteUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackViewDeleteUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackViewDeleteUtil_004', 0, () => {
      expect(FormStackViewDeleteUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackViewDeleteUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewDeleteUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewDeleteUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewDeleteUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewDeleteUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackViewDeleteUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackViewDeleteUtil_005', 0, () => {
      expect(FormStackViewDeleteUtil.isNumber("")).assertFalse();
      expect(FormStackViewDeleteUtil.isNumber(null)).assertFalse();
      expect(FormStackViewDeleteUtil.isNumber(undefined)).assertFalse();
      expect(FormStackViewDeleteUtil.isNumber("abc")).assertFalse();
      expect(FormStackViewDeleteUtil.isNumber("123")).assertTrue();
    });

    it('FormStackViewDeleteUtil_006', 0, () => {
      expect(FormStackViewDeleteUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackViewDeleteUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackViewDeleteUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackViewDeleteUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackViewDeleteUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackViewDeleteUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackViewDeleteUtil_007', 0, () => {
      expect(FormStackViewDeleteUtil.getDefaultId(null) === null).assertTrue();
      expect(FormStackViewDeleteUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackViewDeleteUtil.getDefaultId('') === '').assertTrue();
      expect(FormStackViewDeleteUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormStackViewDeleteUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackViewDeleteUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackViewDeleteUtil_008', 0, () => {
      expect(FormStackViewDeleteUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackViewDeleteUtil_009', 0, () => {
      expect(FormStackViewDeleteUtil.drawFontWidth() === -1).assertTrue();
      expect(FormStackViewDeleteUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackViewDeleteUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackViewDeleteUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackViewDeleteUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackViewDeleteUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackViewDeleteUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackViewDeleteUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackViewDeleteUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackViewDeleteUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackViewDeleteUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackViewDeleteUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackViewDeleteUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackViewDeleteUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackViewDeleteUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackViewDeleteUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackViewDeleteUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackViewDeleteUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackViewDeleteUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackViewDeleteUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackViewDeleteUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackViewDeleteUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackViewDeleteUtil_010', 0, () => {
      expect(FormStackViewDeleteUtil.drawTextAlign() === -1).assertTrue();
      expect(FormStackViewDeleteUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackViewDeleteUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackViewDeleteUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackViewDeleteUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackViewDeleteUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackViewDeleteUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackViewDeleteUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackViewDeleteUtil_011', 0, () => {
      expect(FormStackViewDeleteUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackViewDeleteUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackViewDeleteUtil_012', 0, () => {
      expect(FormStackViewDeleteUtil.checkArr([]) === false).assertTrue();
      expect(FormStackViewDeleteUtil.checkArr(null) === false).assertTrue();
      expect(FormStackViewDeleteUtil.checkArr(undefined) === false).assertTrue();
      expect(FormStackViewDeleteUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackViewDeleteUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackViewDeleteUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackViewDeleteUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackViewDeleteUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackViewDeleteUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackViewDeleteUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackViewDeleteUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackViewDeleteUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackViewDeleteUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackViewDeleteUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackViewDeleteUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackViewDeleteUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackViewDeleteUtil.getUUID().length > 0).assertTrue();
    })

    it('FormStackViewDeleteUtil_013', 0, () => {
      expect(FormStackViewDeleteUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackViewDeleteUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackViewDeleteUtil_014', 0, () => {
      expect(FormStackViewDeleteUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackViewDeleteUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackViewDeleteUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackViewDeleteUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackViewDeleteUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackViewDeleteUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackViewDeleteUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackViewDeleteUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackViewDeleteUtil_015', 0, () => {
      expect(FormStackViewDeleteUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackViewDeleteUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackViewDeleteUtil_016', 0, () => {
      expect(FormStackViewDeleteUtil.isEmpty(null)).assertTrue();
      expect(FormStackViewDeleteUtil.isEmpty(undefined)).assertTrue();
      expect(FormStackViewDeleteUtil.isEmpty('')).assertTrue();
      expect(FormStackViewDeleteUtil.isEmpty(0)).assertTrue();
      expect(FormStackViewDeleteUtil.isEmpty([])).assertTrue();
      expect(FormStackViewDeleteUtil.isEmpty(1, null)).assertTrue();
      expect(FormStackViewDeleteUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormStackViewDeleteUtil.isEmpty(1, true)).assertTrue();
      expect(FormStackViewDeleteUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormStackViewDeleteUtil_017', 0, () => {
      expect(FormStackViewDeleteUtil.equals(null, 'a')).assertFalse();
      expect(FormStackViewDeleteUtil.equals(undefined, 'a')).assertFalse();
      expect(FormStackViewDeleteUtil.equals('a', null)).assertFalse();
      expect(FormStackViewDeleteUtil.equals('a', undefined)).assertFalse();
      expect(FormStackViewDeleteUtil.equals('a', 1)).assertFalse();
      expect(FormStackViewDeleteUtil.equals(1, 'a')).assertFalse();
      expect(FormStackViewDeleteUtil.equals(1, [])).assertFalse();
      expect(FormStackViewDeleteUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackViewDeleteUtil.equals([], m)).assertFalse();
      expect(FormStackViewDeleteUtil.equals(m, [])).assertFalse();
      expect(FormStackViewDeleteUtil.equals([1,2], [])).assertFalse();
      expect(FormStackViewDeleteUtil.equals([], [1, 2])).assertFalse();
      expect(FormStackViewDeleteUtil.equals([1], [1, 2])).assertFalse();
      expect(FormStackViewDeleteUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackViewDeleteUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackViewDeleteUtil.equals(2, 2)).assertTrue();
    })
  });
}