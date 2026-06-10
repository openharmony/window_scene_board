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
import { FormCommonControllerCardUtils } from '../../../../../../../main/ets/default/common/components/form/useless/FormCommonControllerCardUtils';

export function FormCommonControllerCardUtilsTest() {
  describe('FormCommonControllerCardUtilsTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormCommonControllerCardUtils.getSum("", '1') === -1).assertEqual(true);
      expect(FormCommonControllerCardUtils.getSum(null, '1') === -1).assertEqual(true);
      expect(FormCommonControllerCardUtils.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormCommonControllerCardUtils.getSum('1', '') === -1).assertEqual(true);
      expect(FormCommonControllerCardUtils.getSum('1', null) === -1).assertEqual(true);
      expect(FormCommonControllerCardUtils.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormCommonControllerCardUtils.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormCommonControllerCardUtils_002', 0, () => {
      expect(FormCommonControllerCardUtils.stringToArray("", ",").length === 0).assertTrue();
      expect(FormCommonControllerCardUtils.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormCommonControllerCardUtils.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormCommonControllerCardUtils.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormCommonControllerCardUtils.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormCommonControllerCardUtils.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormCommonControllerCardUtils.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormCommonControllerCardUtils_003', 0, () => {
      expect(FormCommonControllerCardUtils.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormCommonControllerCardUtils.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormCommonControllerCardUtils.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormCommonControllerCardUtils.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormCommonControllerCardUtils.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormCommonControllerCardUtils.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormCommonControllerCardUtils.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormCommonControllerCardUtils_004', 0, () => {
      expect(FormCommonControllerCardUtils.getIntValues("", ",").length === 0).assertTrue();
      expect(FormCommonControllerCardUtils.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormCommonControllerCardUtils.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormCommonControllerCardUtils.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormCommonControllerCardUtils.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormCommonControllerCardUtils.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormCommonControllerCardUtils.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormCommonControllerCardUtils_005', 0, () => {
      expect(FormCommonControllerCardUtils.isNumber("")).assertFalse();
      expect(FormCommonControllerCardUtils.isNumber(null)).assertFalse();
      expect(FormCommonControllerCardUtils.isNumber(undefined)).assertFalse();
      expect(FormCommonControllerCardUtils.isNumber("abc")).assertFalse();
      expect(FormCommonControllerCardUtils.isNumber("123")).assertTrue();
    });

    it('FormCommonControllerCardUtils_006', 0, () => {
      expect(FormCommonControllerCardUtils.getStrByCount(null , 1) === '').assertTrue();
      expect(FormCommonControllerCardUtils.getStrByCount('' , 1) === '').assertTrue();
      expect(FormCommonControllerCardUtils.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormCommonControllerCardUtils.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormCommonControllerCardUtils.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormCommonControllerCardUtils.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormCommonControllerCardUtils_007', 0, () => {
      expect(FormCommonControllerCardUtils.getDefaultId(null) === null).assertTrue();
      expect(FormCommonControllerCardUtils.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormCommonControllerCardUtils.getDefaultId('') === '').assertTrue();
      expect(FormCommonControllerCardUtils.getDefaultId('default') !== '').assertTrue();
      expect(FormCommonControllerCardUtils.getDefaultId('aaa') !== '').assertTrue();
      expect(FormCommonControllerCardUtils.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormCommonControllerCardUtils_008', 0, () => {
      expect(FormCommonControllerCardUtils.getIndexByString("", []) === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getIndexByString(null, []) === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormCommonControllerCardUtils_009', 0, () => {
      expect(FormCommonControllerCardUtils.drawFontWidth() === -1).assertTrue();
      expect(FormCommonControllerCardUtils.drawFontWidth(100) === 1).assertTrue();
      expect(FormCommonControllerCardUtils.drawFontWidth(200) === 2).assertTrue();
      expect(FormCommonControllerCardUtils.drawFontWidth(300) === 3).assertTrue();
      expect(FormCommonControllerCardUtils.drawFontWidth(400) === 4).assertTrue();
      expect(FormCommonControllerCardUtils.drawFontWidth(500) === 6).assertTrue();
      expect(FormCommonControllerCardUtils.drawFontWidth(600) === 7).assertTrue();
      expect(FormCommonControllerCardUtils.drawFontWidth(700) === 8).assertTrue();
      expect(FormCommonControllerCardUtils.drawFontWidth(800) === 9).assertTrue();
      expect(FormCommonControllerCardUtils.drawFontWidth(900) === 1).assertTrue();
      expect(FormCommonControllerCardUtils.drawFontWidth(1000) === 5).assertTrue();
      expect(FormCommonControllerCardUtils.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormCommonControllerCardUtils.drawFontWeightFormat() === 3).assertTrue();
      expect(FormCommonControllerCardUtils.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormCommonControllerCardUtils.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormCommonControllerCardUtils.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormCommonControllerCardUtils.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormCommonControllerCardUtils.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormCommonControllerCardUtils.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormCommonControllerCardUtils.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormCommonControllerCardUtils.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormCommonControllerCardUtils.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormCommonControllerCardUtils_010', 0, () => {
      expect(FormCommonControllerCardUtils.drawTextAlign() === -1).assertTrue();
      expect(FormCommonControllerCardUtils.drawTextAlign(100) === 0).assertTrue();
      expect(FormCommonControllerCardUtils.drawTextAlign(200) === 1).assertTrue();
      expect(FormCommonControllerCardUtils.drawTextAlign(300) === 2).assertTrue();
      expect(FormCommonControllerCardUtils.drawTextAlign(400) === 3).assertTrue();
      expect(FormCommonControllerCardUtils.drawTextAlign(500) === 4).assertTrue();
      expect(FormCommonControllerCardUtils.drawTextAlign(600) === 5).assertTrue();
      expect(FormCommonControllerCardUtils.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormCommonControllerCardUtils_011', 0, () => {
      expect(FormCommonControllerCardUtils.getStringIndex('', '') === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getStringIndex(null, '') === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormCommonControllerCardUtils.getStringIndex('a', '') === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getStringIndex('a', null) === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormCommonControllerCardUtils_012', 0, () => {
      expect(FormCommonControllerCardUtils.checkArr([]) === false).assertTrue();
      expect(FormCommonControllerCardUtils.checkArr(null) === false).assertTrue();
      expect(FormCommonControllerCardUtils.checkArr(undefined) === false).assertTrue();
      expect(FormCommonControllerCardUtils.checkArr(['', 'b']) === false).assertTrue();
      expect(FormCommonControllerCardUtils.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormCommonControllerCardUtils.checkArr([null, 'b']) === false).assertTrue();
      expect(FormCommonControllerCardUtils.checkArr(['a', '']) === false).assertTrue();
      expect(FormCommonControllerCardUtils.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormCommonControllerCardUtils.checkArr(['a', null]) === false).assertTrue();
      expect(FormCommonControllerCardUtils.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormCommonControllerCardUtils.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormCommonControllerCardUtils.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormCommonControllerCardUtils.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormCommonControllerCardUtils.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormCommonControllerCardUtils.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormCommonControllerCardUtils.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormCommonControllerCardUtils.getUUID().length > 0).assertTrue();
    })

    it('FormCommonControllerCardUtils_013', 0, () => {
      expect(FormCommonControllerCardUtils.verifyValue(1, 2) === 1).assertTrue();
      expect(FormCommonControllerCardUtils.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormCommonControllerCardUtils_014', 0, () => {
      expect(FormCommonControllerCardUtils.getBinaryData(null, '') === '').assertTrue();
      expect(FormCommonControllerCardUtils.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormCommonControllerCardUtils.getBinaryData(2, null) === '').assertTrue();
      expect(FormCommonControllerCardUtils.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormCommonControllerCardUtils.getBinaryData(-2, '') === '').assertTrue();
      expect(FormCommonControllerCardUtils.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormCommonControllerCardUtils.getBinaryData(0, '') === '').assertTrue();
      expect(FormCommonControllerCardUtils.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormCommonControllerCardUtils_015', 0, () => {
      expect(FormCommonControllerCardUtils.getArraySum(null, []) === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getArraySum([], null) === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getArraySum([], undefined) === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormCommonControllerCardUtils.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormCommonControllerCardUtils_016', 0, () => {
      expect(FormCommonControllerCardUtils.isEmpty(null)).assertTrue();
      expect(FormCommonControllerCardUtils.isEmpty(undefined)).assertTrue();
      expect(FormCommonControllerCardUtils.isEmpty('')).assertTrue();
      expect(FormCommonControllerCardUtils.isEmpty(0)).assertTrue();
      expect(FormCommonControllerCardUtils.isEmpty([])).assertTrue();
      expect(FormCommonControllerCardUtils.isEmpty(1, null)).assertTrue();
      expect(FormCommonControllerCardUtils.isEmpty(1, undefined)).assertTrue();
      expect(FormCommonControllerCardUtils.isEmpty(1, true)).assertTrue();
      expect(FormCommonControllerCardUtils.isEmpty(1, false)).assertFalse();
    })

    it('FormCommonControllerCardUtils_017', 0, () => {
      expect(FormCommonControllerCardUtils.equals(null, 'a')).assertFalse();
      expect(FormCommonControllerCardUtils.equals(undefined, 'a')).assertFalse();
      expect(FormCommonControllerCardUtils.equals('a', null)).assertFalse();
      expect(FormCommonControllerCardUtils.equals('a', undefined)).assertFalse();
      expect(FormCommonControllerCardUtils.equals('a', 1)).assertFalse();
      expect(FormCommonControllerCardUtils.equals(1, 'a')).assertFalse();
      expect(FormCommonControllerCardUtils.equals(1, [])).assertFalse();
      expect(FormCommonControllerCardUtils.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormCommonControllerCardUtils.equals([], m)).assertFalse();
      expect(FormCommonControllerCardUtils.equals(m, [])).assertFalse();
      expect(FormCommonControllerCardUtils.equals([1,2], [])).assertFalse();
      expect(FormCommonControllerCardUtils.equals([], [1, 2])).assertFalse();
      expect(FormCommonControllerCardUtils.equals([1], [1, 2])).assertFalse();
      expect(FormCommonControllerCardUtils.equals([1, 3], [1, 2])).assertFalse();
      expect(FormCommonControllerCardUtils.equals([1, 2], [1, 2])).assertTrue();
      expect(FormCommonControllerCardUtils.equals(2, 2)).assertTrue();
    })
  });
}