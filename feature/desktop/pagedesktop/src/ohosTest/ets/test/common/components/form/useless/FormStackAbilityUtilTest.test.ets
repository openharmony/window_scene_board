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
import { FormStackAbilityUtil } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackAbilityUtil';

export function FormStackAbilityUtilTest() {
  describe('FormStackAbilityUtilTest', () => {
    it('FormStackAbilityUtil_001', 0, () => {
      expect(FormStackAbilityUtil.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackAbilityUtil.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackAbilityUtil.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackAbilityUtil.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackAbilityUtil.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackAbilityUtil.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackAbilityUtil.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackAbilityUtil_002', 0, () => {
      expect(FormStackAbilityUtil.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackAbilityUtil.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackAbilityUtil.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackAbilityUtil.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackAbilityUtil.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackAbilityUtil.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackAbilityUtil.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackAbilityUtil_003', 0, () => {
      expect(FormStackAbilityUtil.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackAbilityUtil.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackAbilityUtil.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAbilityUtil.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAbilityUtil.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAbilityUtil.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackAbilityUtil.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackAbilityUtil_004', 0, () => {
      expect(FormStackAbilityUtil.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackAbilityUtil.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackAbilityUtil.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAbilityUtil.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAbilityUtil.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAbilityUtil.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackAbilityUtil.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackAbilityUtil_005', 0, () => {
      expect(FormStackAbilityUtil.isNumber("")).assertFalse();
      expect(FormStackAbilityUtil.isNumber(null)).assertFalse();
      expect(FormStackAbilityUtil.isNumber(undefined)).assertFalse();
      expect(FormStackAbilityUtil.isNumber("abc")).assertFalse();
      expect(FormStackAbilityUtil.isNumber("123")).assertTrue();
    });

    it('FormStackAbilityUtil_006', 0, () => {
      expect(FormStackAbilityUtil.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackAbilityUtil.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackAbilityUtil.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackAbilityUtil.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackAbilityUtil.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackAbilityUtil.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackAbilityUtil_007', 0, () => {
      expect(FormStackAbilityUtil.getDefaultId(null) === null).assertTrue();
      expect(FormStackAbilityUtil.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackAbilityUtil.getDefaultId('') === '').assertTrue();
      expect(FormStackAbilityUtil.getDefaultId('default') !== '').assertTrue();
      expect(FormStackAbilityUtil.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackAbilityUtil.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackAbilityUtil_008', 0, () => {
      expect(FormStackAbilityUtil.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackAbilityUtil.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackAbilityUtil.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackAbilityUtil.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackAbilityUtil.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackAbilityUtil.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackAbilityUtil.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackAbilityUtil_009', 0, () => {
      expect(FormStackAbilityUtil.drawFontWidth() === -1).assertTrue();
      expect(FormStackAbilityUtil.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackAbilityUtil.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackAbilityUtil.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackAbilityUtil.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackAbilityUtil.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackAbilityUtil.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackAbilityUtil.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackAbilityUtil.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackAbilityUtil.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackAbilityUtil.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackAbilityUtil.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackAbilityUtil.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackAbilityUtil.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackAbilityUtil.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackAbilityUtil.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackAbilityUtil.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackAbilityUtil.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackAbilityUtil.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackAbilityUtil.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackAbilityUtil.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackAbilityUtil.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackAbilityUtil_010', 0, () => {
      expect(FormStackAbilityUtil.drawTextAlign() === -1).assertTrue();
      expect(FormStackAbilityUtil.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackAbilityUtil.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackAbilityUtil.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackAbilityUtil.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackAbilityUtil.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackAbilityUtil.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackAbilityUtil.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackAbilityUtil_011', 0, () => {
      expect(FormStackAbilityUtil.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackAbilityUtil.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackAbilityUtil.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackAbilityUtil.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackAbilityUtil.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackAbilityUtil.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackAbilityUtil.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackAbilityUtil.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackAbilityUtil.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackAbilityUtil.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackAbilityUtil.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackAbilityUtil.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackAbilityUtil.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackAbilityUtil.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackAbilityUtil.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackAbilityUtil.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackAbilityUtil.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackAbilityUtil.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackAbilityUtil.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackAbilityUtil_012', 0, () => {
      expect(FormStackAbilityUtil.checkArr([]) === false).assertTrue();
      expect(FormStackAbilityUtil.checkArr(null) === false).assertTrue();
      expect(FormStackAbilityUtil.checkArr(undefined) === false).assertTrue();
      expect(FormStackAbilityUtil.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackAbilityUtil.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackAbilityUtil.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackAbilityUtil.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackAbilityUtil.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackAbilityUtil.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackAbilityUtil.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackAbilityUtil.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackAbilityUtil.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackAbilityUtil.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackAbilityUtil.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackAbilityUtil.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackAbilityUtil.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackAbilityUtil.getUUID().length > 0).assertTrue();
    })

    it('FormStackAbilityUtil_013', 0, () => {
      expect(FormStackAbilityUtil.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackAbilityUtil.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackAbilityUtil_014', 0, () => {
      expect(FormStackAbilityUtil.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackAbilityUtil.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackAbilityUtil.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackAbilityUtil.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackAbilityUtil.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackAbilityUtil.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackAbilityUtil.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackAbilityUtil.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackAbilityUtil_015', 0, () => {
      expect(FormStackAbilityUtil.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackAbilityUtil.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackAbilityUtil.getArraySum([], null) === -1).assertTrue();
      expect(FormStackAbilityUtil.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackAbilityUtil.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackAbilityUtil.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackAbilityUtil.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackAbilityUtil.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackAbilityUtil.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackAbilityUtil.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackAbilityUtil.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackAbilityUtil.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackAbilityUtil_016', 0, () => {
      expect(FormStackAbilityUtil.isEmpty(null)).assertTrue();
      expect(FormStackAbilityUtil.isEmpty(undefined)).assertTrue();
      expect(FormStackAbilityUtil.isEmpty('')).assertTrue();
      expect(FormStackAbilityUtil.isEmpty(0)).assertTrue();
      expect(FormStackAbilityUtil.isEmpty([])).assertTrue();
      expect(FormStackAbilityUtil.isEmpty(1, null)).assertTrue();
      expect(FormStackAbilityUtil.isEmpty(1, undefined)).assertTrue();
      expect(FormStackAbilityUtil.isEmpty(1, true)).assertTrue();
      expect(FormStackAbilityUtil.isEmpty(1, false)).assertFalse();
    })

    it('FormStackAbilityUtil_017', 0, () => {
      expect(FormStackAbilityUtil.equals(null, 'a')).assertFalse();
      expect(FormStackAbilityUtil.equals(undefined, 'a')).assertFalse();
      expect(FormStackAbilityUtil.equals('a', null)).assertFalse();
      expect(FormStackAbilityUtil.equals('a', undefined)).assertFalse();
      expect(FormStackAbilityUtil.equals('a', 1)).assertFalse();
      expect(FormStackAbilityUtil.equals(1, 'a')).assertFalse();
      expect(FormStackAbilityUtil.equals(1, [])).assertFalse();
      expect(FormStackAbilityUtil.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackAbilityUtil.equals([], m)).assertFalse();
      expect(FormStackAbilityUtil.equals(m, [])).assertFalse();
      expect(FormStackAbilityUtil.equals([1,2], [])).assertFalse();
      expect(FormStackAbilityUtil.equals([], [1, 2])).assertFalse();
      expect(FormStackAbilityUtil.equals([1], [1, 2])).assertFalse();
      expect(FormStackAbilityUtil.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackAbilityUtil.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackAbilityUtil.equals(2, 2)).assertTrue();
    })
  });
}