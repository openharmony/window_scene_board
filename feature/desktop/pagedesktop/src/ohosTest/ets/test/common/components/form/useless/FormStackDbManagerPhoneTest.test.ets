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
import { FormStackDbManagerPhone } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackDbManagerPhone';

export function FormStackDbManagerPhoneTest() {
  describe('FormStackDbManagerPhoneTest', () => {
    it('FormStackDbManagerPhone_001', 0, () => {
      expect(FormStackDbManagerPhone.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackDbManagerPhone.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackDbManagerPhone.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackDbManagerPhone.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackDbManagerPhone.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackDbManagerPhone.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackDbManagerPhone.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackDbManagerPhone_002', 0, () => {
      expect(FormStackDbManagerPhone.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackDbManagerPhone.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackDbManagerPhone.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbManagerPhone.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackDbManagerPhone.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbManagerPhone.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackDbManagerPhone.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackDbManagerPhone_003', 0, () => {
      expect(FormStackDbManagerPhone.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackDbManagerPhone.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbManagerPhone.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbManagerPhone.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbManagerPhone.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbManagerPhone.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackDbManagerPhone.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackDbManagerPhone_004', 0, () => {
      expect(FormStackDbManagerPhone.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackDbManagerPhone.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbManagerPhone.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbManagerPhone.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbManagerPhone.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbManagerPhone.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackDbManagerPhone.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackDbManagerPhone_005', 0, () => {
      expect(FormStackDbManagerPhone.isNumber("")).assertFalse();
      expect(FormStackDbManagerPhone.isNumber(null)).assertFalse();
      expect(FormStackDbManagerPhone.isNumber(undefined)).assertFalse();
      expect(FormStackDbManagerPhone.isNumber("abc")).assertFalse();
      expect(FormStackDbManagerPhone.isNumber("123")).assertTrue();
    });

    it('FormStackDbManagerPhone_006', 0, () => {
      expect(FormStackDbManagerPhone.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackDbManagerPhone.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackDbManagerPhone.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackDbManagerPhone.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackDbManagerPhone.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackDbManagerPhone.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackDbManagerPhone_007', 0, () => {
      expect(FormStackDbManagerPhone.getDefaultId(null) === null).assertTrue();
      expect(FormStackDbManagerPhone.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackDbManagerPhone.getDefaultId('') === '').assertTrue();
      expect(FormStackDbManagerPhone.getDefaultId('default') !== '').assertTrue();
      expect(FormStackDbManagerPhone.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackDbManagerPhone.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackDbManagerPhone_008', 0, () => {
      expect(FormStackDbManagerPhone.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackDbManagerPhone.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackDbManagerPhone.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackDbManagerPhone.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackDbManagerPhone.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackDbManagerPhone.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackDbManagerPhone.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackDbManagerPhone_009', 0, () => {
      expect(FormStackDbManagerPhone.drawFontWidth() === -1).assertTrue();
      expect(FormStackDbManagerPhone.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackDbManagerPhone.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackDbManagerPhone.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackDbManagerPhone.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackDbManagerPhone.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackDbManagerPhone.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackDbManagerPhone.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackDbManagerPhone.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackDbManagerPhone.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackDbManagerPhone.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackDbManagerPhone.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackDbManagerPhone.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackDbManagerPhone.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackDbManagerPhone.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackDbManagerPhone.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackDbManagerPhone.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackDbManagerPhone.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackDbManagerPhone.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackDbManagerPhone.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackDbManagerPhone.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackDbManagerPhone.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackDbManagerPhone_010', 0, () => {
      expect(FormStackDbManagerPhone.drawTextAlign() === -1).assertTrue();
      expect(FormStackDbManagerPhone.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackDbManagerPhone.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackDbManagerPhone.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackDbManagerPhone.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackDbManagerPhone.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackDbManagerPhone.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackDbManagerPhone.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackDbManagerPhone_011', 0, () => {
      expect(FormStackDbManagerPhone.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackDbManagerPhone.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackDbManagerPhone.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackDbManagerPhone.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackDbManagerPhone.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackDbManagerPhone.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackDbManagerPhone.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackDbManagerPhone.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackDbManagerPhone.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackDbManagerPhone.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackDbManagerPhone.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackDbManagerPhone.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackDbManagerPhone.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackDbManagerPhone.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackDbManagerPhone.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackDbManagerPhone.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackDbManagerPhone.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackDbManagerPhone.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackDbManagerPhone.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackDbManagerPhone_012', 0, () => {
      expect(FormStackDbManagerPhone.checkArr([]) === false).assertTrue();
      expect(FormStackDbManagerPhone.checkArr(null) === false).assertTrue();
      expect(FormStackDbManagerPhone.checkArr(undefined) === false).assertTrue();
      expect(FormStackDbManagerPhone.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackDbManagerPhone.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackDbManagerPhone.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackDbManagerPhone.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackDbManagerPhone.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackDbManagerPhone.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackDbManagerPhone.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackDbManagerPhone.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackDbManagerPhone.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackDbManagerPhone.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackDbManagerPhone.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackDbManagerPhone.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackDbManagerPhone.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackDbManagerPhone.getUUID().length > 0).assertTrue();
    })

    it('FormStackDbManagerPhone_013', 0, () => {
      expect(FormStackDbManagerPhone.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackDbManagerPhone.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackDbManagerPhone_014', 0, () => {
      expect(FormStackDbManagerPhone.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackDbManagerPhone.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackDbManagerPhone.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackDbManagerPhone.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackDbManagerPhone.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackDbManagerPhone.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackDbManagerPhone.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackDbManagerPhone.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackDbManagerPhone_015', 0, () => {
      expect(FormStackDbManagerPhone.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackDbManagerPhone.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackDbManagerPhone.getArraySum([], null) === -1).assertTrue();
      expect(FormStackDbManagerPhone.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackDbManagerPhone.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackDbManagerPhone.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackDbManagerPhone.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackDbManagerPhone.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackDbManagerPhone.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackDbManagerPhone.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackDbManagerPhone.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackDbManagerPhone.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackDbManagerPhone_016', 0, () => {
      expect(FormStackDbManagerPhone.isEmpty(null)).assertTrue();
      expect(FormStackDbManagerPhone.isEmpty(undefined)).assertTrue();
      expect(FormStackDbManagerPhone.isEmpty('')).assertTrue();
      expect(FormStackDbManagerPhone.isEmpty(0)).assertTrue();
      expect(FormStackDbManagerPhone.isEmpty([])).assertTrue();
      expect(FormStackDbManagerPhone.isEmpty(1, null)).assertTrue();
      expect(FormStackDbManagerPhone.isEmpty(1, undefined)).assertTrue();
      expect(FormStackDbManagerPhone.isEmpty(1, true)).assertTrue();
      expect(FormStackDbManagerPhone.isEmpty(1, false)).assertFalse();
    })

    it('FormStackDbManagerPhone_017', 0, () => {
      expect(FormStackDbManagerPhone.equals(null, 'a')).assertFalse();
      expect(FormStackDbManagerPhone.equals(undefined, 'a')).assertFalse();
      expect(FormStackDbManagerPhone.equals('a', null)).assertFalse();
      expect(FormStackDbManagerPhone.equals('a', undefined)).assertFalse();
      expect(FormStackDbManagerPhone.equals('a', 1)).assertFalse();
      expect(FormStackDbManagerPhone.equals(1, 'a')).assertFalse();
      expect(FormStackDbManagerPhone.equals(1, [])).assertFalse();
      expect(FormStackDbManagerPhone.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackDbManagerPhone.equals([], m)).assertFalse();
      expect(FormStackDbManagerPhone.equals(m, [])).assertFalse();
      expect(FormStackDbManagerPhone.equals([1,2], [])).assertFalse();
      expect(FormStackDbManagerPhone.equals([], [1, 2])).assertFalse();
      expect(FormStackDbManagerPhone.equals([1], [1, 2])).assertFalse();
      expect(FormStackDbManagerPhone.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackDbManagerPhone.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackDbManagerPhone.equals(2, 2)).assertTrue();
    })
  });
}