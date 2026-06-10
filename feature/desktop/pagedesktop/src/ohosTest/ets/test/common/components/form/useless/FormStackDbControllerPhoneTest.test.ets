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
import { FormStackDbControllerPhone } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackDbControllerPhone';

export function FormStackDbControllerPhoneTest() {
  describe('FormStackDbControllerPhoneTest', () => {
    it('FormStackDbControllerPhone_001', 0, () => {
      expect(FormStackDbControllerPhone.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackDbControllerPhone.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackDbControllerPhone.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackDbControllerPhone.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackDbControllerPhone.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackDbControllerPhone.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackDbControllerPhone.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackDbControllerPhone_002', 0, () => {
      expect(FormStackDbControllerPhone.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackDbControllerPhone.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackDbControllerPhone.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbControllerPhone.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackDbControllerPhone.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbControllerPhone.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackDbControllerPhone.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackDbControllerPhone_003', 0, () => {
      expect(FormStackDbControllerPhone.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackDbControllerPhone.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbControllerPhone.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbControllerPhone.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbControllerPhone.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbControllerPhone.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackDbControllerPhone.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackDbControllerPhone_004', 0, () => {
      expect(FormStackDbControllerPhone.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackDbControllerPhone.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbControllerPhone.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbControllerPhone.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbControllerPhone.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbControllerPhone.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackDbControllerPhone.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackDbControllerPhone_005', 0, () => {
      expect(FormStackDbControllerPhone.isNumber("")).assertFalse();
      expect(FormStackDbControllerPhone.isNumber(null)).assertFalse();
      expect(FormStackDbControllerPhone.isNumber(undefined)).assertFalse();
      expect(FormStackDbControllerPhone.isNumber("abc")).assertFalse();
      expect(FormStackDbControllerPhone.isNumber("123")).assertTrue();
    });

    it('FormStackDbControllerPhone_006', 0, () => {
      expect(FormStackDbControllerPhone.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackDbControllerPhone.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackDbControllerPhone.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackDbControllerPhone.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackDbControllerPhone.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackDbControllerPhone.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackDbControllerPhone_007', 0, () => {
      expect(FormStackDbControllerPhone.getDefaultId(null) === null).assertTrue();
      expect(FormStackDbControllerPhone.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackDbControllerPhone.getDefaultId('') === '').assertTrue();
      expect(FormStackDbControllerPhone.getDefaultId('default') !== '').assertTrue();
      expect(FormStackDbControllerPhone.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackDbControllerPhone.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackDbControllerPhone_008', 0, () => {
      expect(FormStackDbControllerPhone.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackDbControllerPhone.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackDbControllerPhone.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackDbControllerPhone.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackDbControllerPhone.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackDbControllerPhone.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackDbControllerPhone.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackDbControllerPhone_009', 0, () => {
      expect(FormStackDbControllerPhone.drawFontWidth() === -1).assertTrue();
      expect(FormStackDbControllerPhone.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackDbControllerPhone.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackDbControllerPhone.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackDbControllerPhone.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackDbControllerPhone.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackDbControllerPhone.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackDbControllerPhone.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackDbControllerPhone.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackDbControllerPhone.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackDbControllerPhone.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackDbControllerPhone.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackDbControllerPhone.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackDbControllerPhone.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackDbControllerPhone.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackDbControllerPhone.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackDbControllerPhone.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackDbControllerPhone.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackDbControllerPhone.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackDbControllerPhone.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackDbControllerPhone.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackDbControllerPhone.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackDbControllerPhone_010', 0, () => {
      expect(FormStackDbControllerPhone.drawTextAlign() === -1).assertTrue();
      expect(FormStackDbControllerPhone.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackDbControllerPhone.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackDbControllerPhone.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackDbControllerPhone.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackDbControllerPhone.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackDbControllerPhone.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackDbControllerPhone.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackDbControllerPhone_011', 0, () => {
      expect(FormStackDbControllerPhone.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackDbControllerPhone.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackDbControllerPhone.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackDbControllerPhone.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackDbControllerPhone.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackDbControllerPhone.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackDbControllerPhone.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackDbControllerPhone.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackDbControllerPhone.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackDbControllerPhone.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackDbControllerPhone.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackDbControllerPhone.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackDbControllerPhone.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackDbControllerPhone.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackDbControllerPhone.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackDbControllerPhone.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackDbControllerPhone.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackDbControllerPhone.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackDbControllerPhone.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackDbControllerPhone_012', 0, () => {
      expect(FormStackDbControllerPhone.checkArr([]) === false).assertTrue();
      expect(FormStackDbControllerPhone.checkArr(null) === false).assertTrue();
      expect(FormStackDbControllerPhone.checkArr(undefined) === false).assertTrue();
      expect(FormStackDbControllerPhone.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackDbControllerPhone.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackDbControllerPhone.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackDbControllerPhone.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackDbControllerPhone.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackDbControllerPhone.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackDbControllerPhone.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackDbControllerPhone.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackDbControllerPhone.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackDbControllerPhone.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackDbControllerPhone.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackDbControllerPhone.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackDbControllerPhone.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackDbControllerPhone.getUUID().length > 0).assertTrue();
    })

    it('FormStackDbControllerPhone_013', 0, () => {
      expect(FormStackDbControllerPhone.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackDbControllerPhone.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackDbControllerPhone_014', 0, () => {
      expect(FormStackDbControllerPhone.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackDbControllerPhone.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackDbControllerPhone.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackDbControllerPhone.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackDbControllerPhone.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackDbControllerPhone.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackDbControllerPhone.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackDbControllerPhone.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackDbControllerPhone_015', 0, () => {
      expect(FormStackDbControllerPhone.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackDbControllerPhone.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackDbControllerPhone.getArraySum([], null) === -1).assertTrue();
      expect(FormStackDbControllerPhone.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackDbControllerPhone.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackDbControllerPhone.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackDbControllerPhone.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackDbControllerPhone.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackDbControllerPhone.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackDbControllerPhone.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackDbControllerPhone.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackDbControllerPhone.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackDbControllerPhone_016', 0, () => {
      expect(FormStackDbControllerPhone.isEmpty(null)).assertTrue();
      expect(FormStackDbControllerPhone.isEmpty(undefined)).assertTrue();
      expect(FormStackDbControllerPhone.isEmpty('')).assertTrue();
      expect(FormStackDbControllerPhone.isEmpty(0)).assertTrue();
      expect(FormStackDbControllerPhone.isEmpty([])).assertTrue();
      expect(FormStackDbControllerPhone.isEmpty(1, null)).assertTrue();
      expect(FormStackDbControllerPhone.isEmpty(1, undefined)).assertTrue();
      expect(FormStackDbControllerPhone.isEmpty(1, true)).assertTrue();
      expect(FormStackDbControllerPhone.isEmpty(1, false)).assertFalse();
    })

    it('FormStackDbControllerPhone_017', 0, () => {
      expect(FormStackDbControllerPhone.equals(null, 'a')).assertFalse();
      expect(FormStackDbControllerPhone.equals(undefined, 'a')).assertFalse();
      expect(FormStackDbControllerPhone.equals('a', null)).assertFalse();
      expect(FormStackDbControllerPhone.equals('a', undefined)).assertFalse();
      expect(FormStackDbControllerPhone.equals('a', 1)).assertFalse();
      expect(FormStackDbControllerPhone.equals(1, 'a')).assertFalse();
      expect(FormStackDbControllerPhone.equals(1, [])).assertFalse();
      expect(FormStackDbControllerPhone.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackDbControllerPhone.equals([], m)).assertFalse();
      expect(FormStackDbControllerPhone.equals(m, [])).assertFalse();
      expect(FormStackDbControllerPhone.equals([1,2], [])).assertFalse();
      expect(FormStackDbControllerPhone.equals([], [1, 2])).assertFalse();
      expect(FormStackDbControllerPhone.equals([1], [1, 2])).assertFalse();
      expect(FormStackDbControllerPhone.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackDbControllerPhone.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackDbControllerPhone.equals(2, 2)).assertTrue();
    })
  });
}