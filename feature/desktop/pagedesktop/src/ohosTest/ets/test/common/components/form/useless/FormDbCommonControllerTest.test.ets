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
import { FormDbController } from '../../../../../../../main/ets/default/common/components/form/useless/FormDbController';

export function FormDbControllerTest() {
  describe('FormDbControllerTest', () => {
    it('FormDbController_001', 0, () => {
      expect(FormDbController.getSum("", '1') === -1).assertEqual(true);
      expect(FormDbController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormDbController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormDbController.getSum('1', '') === -1).assertEqual(true);
      expect(FormDbController.getSum('1', null) === -1).assertEqual(true);
      expect(FormDbController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormDbController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormDbController_002', 0, () => {
      expect(FormDbController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormDbController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormDbController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormDbController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormDbController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormDbController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormDbController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormDbController_003', 0, () => {
      expect(FormDbController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormDbController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormDbController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormDbController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormDbController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormDbController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormDbController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormDbController_004', 0, () => {
      expect(FormDbController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormDbController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormDbController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormDbController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormDbController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormDbController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormDbController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormDbController_005', 0, () => {
      expect(FormDbController.isNumber("")).assertFalse();
      expect(FormDbController.isNumber(null)).assertFalse();
      expect(FormDbController.isNumber(undefined)).assertFalse();
      expect(FormDbController.isNumber("abc")).assertFalse();
      expect(FormDbController.isNumber("123")).assertTrue();
    });

    it('FormDbController_006', 0, () => {
      expect(FormDbController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormDbController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormDbController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormDbController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormDbController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormDbController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormDbController_007', 0, () => {
      expect(FormDbController.getDefaultId(null) === null).assertTrue();
      expect(FormDbController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormDbController.getDefaultId('') === '').assertTrue();
      expect(FormDbController.getDefaultId('default') !== '').assertTrue();
      expect(FormDbController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormDbController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormDbController_008', 0, () => {
      expect(FormDbController.getIndexByString("", []) === -1).assertTrue();
      expect(FormDbController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormDbController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormDbController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormDbController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormDbController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormDbController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormDbController_009', 0, () => {
      expect(FormDbController.drawFontWidth() === -1).assertTrue();
      expect(FormDbController.drawFontWidth(100) === 1).assertTrue();
      expect(FormDbController.drawFontWidth(200) === 2).assertTrue();
      expect(FormDbController.drawFontWidth(300) === 3).assertTrue();
      expect(FormDbController.drawFontWidth(400) === 4).assertTrue();
      expect(FormDbController.drawFontWidth(500) === 6).assertTrue();
      expect(FormDbController.drawFontWidth(600) === 7).assertTrue();
      expect(FormDbController.drawFontWidth(700) === 8).assertTrue();
      expect(FormDbController.drawFontWidth(800) === 9).assertTrue();
      expect(FormDbController.drawFontWidth(900) === 1).assertTrue();
      expect(FormDbController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormDbController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormDbController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormDbController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormDbController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormDbController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormDbController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormDbController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormDbController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormDbController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormDbController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormDbController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormDbController_010', 0, () => {
      expect(FormDbController.drawTextAlign() === -1).assertTrue();
      expect(FormDbController.drawTextAlign(100) === 0).assertTrue();
      expect(FormDbController.drawTextAlign(200) === 1).assertTrue();
      expect(FormDbController.drawTextAlign(300) === 2).assertTrue();
      expect(FormDbController.drawTextAlign(400) === 3).assertTrue();
      expect(FormDbController.drawTextAlign(500) === 4).assertTrue();
      expect(FormDbController.drawTextAlign(600) === 5).assertTrue();
      expect(FormDbController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormDbController_011', 0, () => {
      expect(FormDbController.getStringIndex('', '') === -1).assertTrue();
      expect(FormDbController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormDbController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormDbController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormDbController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormDbController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormDbController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormDbController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormDbController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormDbController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormDbController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormDbController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormDbController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormDbController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormDbController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormDbController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormDbController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormDbController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormDbController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormDbController_012', 0, () => {
      expect(FormDbController.checkArr([]) === false).assertTrue();
      expect(FormDbController.checkArr(null) === false).assertTrue();
      expect(FormDbController.checkArr(undefined) === false).assertTrue();
      expect(FormDbController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormDbController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormDbController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormDbController.checkArr(['a', '']) === false).assertTrue();
      expect(FormDbController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormDbController.checkArr(['a', null]) === false).assertTrue();
      expect(FormDbController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormDbController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormDbController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormDbController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormDbController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormDbController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormDbController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormDbController.getUUID().length > 0).assertTrue();
    })

    it('FormDbController_013', 0, () => {
      expect(FormDbController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormDbController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormDbController_014', 0, () => {
      expect(FormDbController.getBinaryData(null, '') === '').assertTrue();
      expect(FormDbController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormDbController.getBinaryData(2, null) === '').assertTrue();
      expect(FormDbController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormDbController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormDbController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormDbController.getBinaryData(0, '') === '').assertTrue();
      expect(FormDbController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormDbController_015', 0, () => {
      expect(FormDbController.getArraySum(null, []) === -1).assertTrue();
      expect(FormDbController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormDbController.getArraySum([], null) === -1).assertTrue();
      expect(FormDbController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormDbController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormDbController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormDbController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormDbController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormDbController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormDbController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormDbController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormDbController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormDbController_016', 0, () => {
      expect(FormDbController.isEmpty(null)).assertTrue();
      expect(FormDbController.isEmpty(undefined)).assertTrue();
      expect(FormDbController.isEmpty('')).assertTrue();
      expect(FormDbController.isEmpty(0)).assertTrue();
      expect(FormDbController.isEmpty([])).assertTrue();
      expect(FormDbController.isEmpty(1, null)).assertTrue();
      expect(FormDbController.isEmpty(1, undefined)).assertTrue();
      expect(FormDbController.isEmpty(1, true)).assertTrue();
      expect(FormDbController.isEmpty(1, false)).assertFalse();
    })

    it('FormDbController_017', 0, () => {
      expect(FormDbController.equals(null, 'a')).assertFalse();
      expect(FormDbController.equals(undefined, 'a')).assertFalse();
      expect(FormDbController.equals('a', null)).assertFalse();
      expect(FormDbController.equals('a', undefined)).assertFalse();
      expect(FormDbController.equals('a', 1)).assertFalse();
      expect(FormDbController.equals(1, 'a')).assertFalse();
      expect(FormDbController.equals(1, [])).assertFalse();
      expect(FormDbController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormDbController.equals([], m)).assertFalse();
      expect(FormDbController.equals(m, [])).assertFalse();
      expect(FormDbController.equals([1,2], [])).assertFalse();
      expect(FormDbController.equals([], [1, 2])).assertFalse();
      expect(FormDbController.equals([1], [1, 2])).assertFalse();
      expect(FormDbController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormDbController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormDbController.equals(2, 2)).assertTrue();
    })
  });
}