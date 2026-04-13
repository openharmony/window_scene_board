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
import { FormStackDbAdapterPhone } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackDbAdapterPhone';

export function FormStackDbAdapterPhoneTest() {
  describe('FormStackDbAdapterPhoneTest', () => {
    it('FormStackDbAdapterPhone_001', 0, () => {
      expect(FormStackDbAdapterPhone.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackDbAdapterPhone.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackDbAdapterPhone.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackDbAdapterPhone.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackDbAdapterPhone.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackDbAdapterPhone.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackDbAdapterPhone.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackDbAdapterPhone_002', 0, () => {
      expect(FormStackDbAdapterPhone.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPhone.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPhone.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPhone.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackDbAdapterPhone.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbAdapterPhone.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackDbAdapterPhone.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackDbAdapterPhone_003', 0, () => {
      expect(FormStackDbAdapterPhone.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPhone.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPhone.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPhone.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbAdapterPhone.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbAdapterPhone.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackDbAdapterPhone.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackDbAdapterPhone_004', 0, () => {
      expect(FormStackDbAdapterPhone.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPhone.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPhone.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbAdapterPhone.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbAdapterPhone.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbAdapterPhone.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackDbAdapterPhone.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackDbAdapterPhone_005', 0, () => {
      expect(FormStackDbAdapterPhone.isNumber("")).assertFalse();
      expect(FormStackDbAdapterPhone.isNumber(null)).assertFalse();
      expect(FormStackDbAdapterPhone.isNumber(undefined)).assertFalse();
      expect(FormStackDbAdapterPhone.isNumber("abc")).assertFalse();
      expect(FormStackDbAdapterPhone.isNumber("123")).assertTrue();
    });

    it('FormStackDbAdapterPhone_006', 0, () => {
      expect(FormStackDbAdapterPhone.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackDbAdapterPhone.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackDbAdapterPhone.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackDbAdapterPhone.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackDbAdapterPhone.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackDbAdapterPhone.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackDbAdapterPhone_007', 0, () => {
      expect(FormStackDbAdapterPhone.getDefaultId(null) === null).assertTrue();
      expect(FormStackDbAdapterPhone.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackDbAdapterPhone.getDefaultId('') === '').assertTrue();
      expect(FormStackDbAdapterPhone.getDefaultId('default') !== '').assertTrue();
      expect(FormStackDbAdapterPhone.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackDbAdapterPhone.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackDbAdapterPhone_008', 0, () => {
      expect(FormStackDbAdapterPhone.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackDbAdapterPhone_009', 0, () => {
      expect(FormStackDbAdapterPhone.drawFontWidth() === -1).assertTrue();
      expect(FormStackDbAdapterPhone.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackDbAdapterPhone.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackDbAdapterPhone.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackDbAdapterPhone.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackDbAdapterPhone.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackDbAdapterPhone.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackDbAdapterPhone.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackDbAdapterPhone.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackDbAdapterPhone.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackDbAdapterPhone.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackDbAdapterPhone.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackDbAdapterPhone.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackDbAdapterPhone.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackDbAdapterPhone.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackDbAdapterPhone.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackDbAdapterPhone.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackDbAdapterPhone.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackDbAdapterPhone.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackDbAdapterPhone.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackDbAdapterPhone.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackDbAdapterPhone.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackDbAdapterPhone_010', 0, () => {
      expect(FormStackDbAdapterPhone.drawTextAlign() === -1).assertTrue();
      expect(FormStackDbAdapterPhone.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackDbAdapterPhone.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackDbAdapterPhone.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackDbAdapterPhone.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackDbAdapterPhone.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackDbAdapterPhone.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackDbAdapterPhone.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackDbAdapterPhone_011', 0, () => {
      expect(FormStackDbAdapterPhone.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackDbAdapterPhone.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackDbAdapterPhone_012', 0, () => {
      expect(FormStackDbAdapterPhone.checkArr([]) === false).assertTrue();
      expect(FormStackDbAdapterPhone.checkArr(null) === false).assertTrue();
      expect(FormStackDbAdapterPhone.checkArr(undefined) === false).assertTrue();
      expect(FormStackDbAdapterPhone.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackDbAdapterPhone.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackDbAdapterPhone.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackDbAdapterPhone.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackDbAdapterPhone.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackDbAdapterPhone.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackDbAdapterPhone.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackDbAdapterPhone.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackDbAdapterPhone.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackDbAdapterPhone.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackDbAdapterPhone.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackDbAdapterPhone.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackDbAdapterPhone.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackDbAdapterPhone.getUUID().length > 0).assertTrue();
    })

    it('FormStackDbAdapterPhone_013', 0, () => {
      expect(FormStackDbAdapterPhone.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackDbAdapterPhone.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackDbAdapterPhone_014', 0, () => {
      expect(FormStackDbAdapterPhone.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackDbAdapterPhone.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackDbAdapterPhone.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackDbAdapterPhone.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackDbAdapterPhone.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackDbAdapterPhone.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackDbAdapterPhone.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackDbAdapterPhone.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackDbAdapterPhone_015', 0, () => {
      expect(FormStackDbAdapterPhone.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getArraySum([], null) === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackDbAdapterPhone.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackDbAdapterPhone_016', 0, () => {
      expect(FormStackDbAdapterPhone.isEmpty(null)).assertTrue();
      expect(FormStackDbAdapterPhone.isEmpty(undefined)).assertTrue();
      expect(FormStackDbAdapterPhone.isEmpty('')).assertTrue();
      expect(FormStackDbAdapterPhone.isEmpty(0)).assertTrue();
      expect(FormStackDbAdapterPhone.isEmpty([])).assertTrue();
      expect(FormStackDbAdapterPhone.isEmpty(1, null)).assertTrue();
      expect(FormStackDbAdapterPhone.isEmpty(1, undefined)).assertTrue();
      expect(FormStackDbAdapterPhone.isEmpty(1, true)).assertTrue();
      expect(FormStackDbAdapterPhone.isEmpty(1, false)).assertFalse();
    })

    it('FormStackDbAdapterPhone_017', 0, () => {
      expect(FormStackDbAdapterPhone.equals(null, 'a')).assertFalse();
      expect(FormStackDbAdapterPhone.equals(undefined, 'a')).assertFalse();
      expect(FormStackDbAdapterPhone.equals('a', null)).assertFalse();
      expect(FormStackDbAdapterPhone.equals('a', undefined)).assertFalse();
      expect(FormStackDbAdapterPhone.equals('a', 1)).assertFalse();
      expect(FormStackDbAdapterPhone.equals(1, 'a')).assertFalse();
      expect(FormStackDbAdapterPhone.equals(1, [])).assertFalse();
      expect(FormStackDbAdapterPhone.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackDbAdapterPhone.equals([], m)).assertFalse();
      expect(FormStackDbAdapterPhone.equals(m, [])).assertFalse();
      expect(FormStackDbAdapterPhone.equals([1,2], [])).assertFalse();
      expect(FormStackDbAdapterPhone.equals([], [1, 2])).assertFalse();
      expect(FormStackDbAdapterPhone.equals([1], [1, 2])).assertFalse();
      expect(FormStackDbAdapterPhone.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackDbAdapterPhone.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackDbAdapterPhone.equals(2, 2)).assertTrue();
    })
  });
}