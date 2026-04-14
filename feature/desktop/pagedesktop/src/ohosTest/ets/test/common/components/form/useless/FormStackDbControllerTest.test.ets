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
import { FormStackDbController } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackDbController';

export function FormStackDbControllerTest() {
  describe('FormStackDbControllerTest', () => {
    it('FormStackDbController_001', 0, () => {
      expect(FormStackDbController.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackDbController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackDbController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackDbController.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackDbController.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackDbController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackDbController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackDbController_002', 0, () => {
      expect(FormStackDbController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackDbController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackDbController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackDbController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackDbController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackDbController_003', 0, () => {
      expect(FormStackDbController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackDbController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackDbController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackDbController_004', 0, () => {
      expect(FormStackDbController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackDbController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackDbController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackDbController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackDbController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackDbController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackDbController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackDbController_005', 0, () => {
      expect(FormStackDbController.isNumber("")).assertFalse();
      expect(FormStackDbController.isNumber(null)).assertFalse();
      expect(FormStackDbController.isNumber(undefined)).assertFalse();
      expect(FormStackDbController.isNumber("abc")).assertFalse();
      expect(FormStackDbController.isNumber("123")).assertTrue();
    });

    it('FormStackDbController_006', 0, () => {
      expect(FormStackDbController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackDbController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackDbController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackDbController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackDbController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackDbController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackDbController_007', 0, () => {
      expect(FormStackDbController.getDefaultId(null) === null).assertTrue();
      expect(FormStackDbController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackDbController.getDefaultId('') === '').assertTrue();
      expect(FormStackDbController.getDefaultId('default') !== '').assertTrue();
      expect(FormStackDbController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackDbController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackDbController_008', 0, () => {
      expect(FormStackDbController.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackDbController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackDbController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackDbController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackDbController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackDbController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackDbController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackDbController_009', 0, () => {
      expect(FormStackDbController.drawFontWidth() === -1).assertTrue();
      expect(FormStackDbController.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackDbController.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackDbController.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackDbController.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackDbController.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackDbController.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackDbController.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackDbController.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackDbController.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackDbController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackDbController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackDbController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackDbController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackDbController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackDbController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackDbController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackDbController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackDbController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackDbController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackDbController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackDbController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackDbController_010', 0, () => {
      expect(FormStackDbController.drawTextAlign() === -1).assertTrue();
      expect(FormStackDbController.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackDbController.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackDbController.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackDbController.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackDbController.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackDbController.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackDbController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackDbController_011', 0, () => {
      expect(FormStackDbController.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackDbController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackDbController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackDbController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackDbController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackDbController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackDbController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackDbController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackDbController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackDbController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackDbController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackDbController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackDbController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackDbController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackDbController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackDbController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackDbController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackDbController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackDbController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackDbController_012', 0, () => {
      expect(FormStackDbController.checkArr([]) === false).assertTrue();
      expect(FormStackDbController.checkArr(null) === false).assertTrue();
      expect(FormStackDbController.checkArr(undefined) === false).assertTrue();
      expect(FormStackDbController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackDbController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackDbController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackDbController.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackDbController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackDbController.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackDbController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackDbController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackDbController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackDbController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackDbController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackDbController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackDbController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackDbController.getUUID().length > 0).assertTrue();
    })

    it('FormStackDbController_013', 0, () => {
      expect(FormStackDbController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackDbController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackDbController_014', 0, () => {
      expect(FormStackDbController.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackDbController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackDbController.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackDbController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackDbController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackDbController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackDbController.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackDbController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackDbController_015', 0, () => {
      expect(FormStackDbController.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackDbController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackDbController.getArraySum([], null) === -1).assertTrue();
      expect(FormStackDbController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackDbController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackDbController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackDbController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackDbController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackDbController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackDbController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackDbController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackDbController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackDbController_016', 0, () => {
      expect(FormStackDbController.isEmpty(null)).assertTrue();
      expect(FormStackDbController.isEmpty(undefined)).assertTrue();
      expect(FormStackDbController.isEmpty('')).assertTrue();
      expect(FormStackDbController.isEmpty(0)).assertTrue();
      expect(FormStackDbController.isEmpty([])).assertTrue();
      expect(FormStackDbController.isEmpty(1, null)).assertTrue();
      expect(FormStackDbController.isEmpty(1, undefined)).assertTrue();
      expect(FormStackDbController.isEmpty(1, true)).assertTrue();
      expect(FormStackDbController.isEmpty(1, false)).assertFalse();
    })

    it('FormStackDbController_017', 0, () => {
      expect(FormStackDbController.equals(null, 'a')).assertFalse();
      expect(FormStackDbController.equals(undefined, 'a')).assertFalse();
      expect(FormStackDbController.equals('a', null)).assertFalse();
      expect(FormStackDbController.equals('a', undefined)).assertFalse();
      expect(FormStackDbController.equals('a', 1)).assertFalse();
      expect(FormStackDbController.equals(1, 'a')).assertFalse();
      expect(FormStackDbController.equals(1, [])).assertFalse();
      expect(FormStackDbController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackDbController.equals([], m)).assertFalse();
      expect(FormStackDbController.equals(m, [])).assertFalse();
      expect(FormStackDbController.equals([1,2], [])).assertFalse();
      expect(FormStackDbController.equals([], [1, 2])).assertFalse();
      expect(FormStackDbController.equals([1], [1, 2])).assertFalse();
      expect(FormStackDbController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackDbController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackDbController.equals(2, 2)).assertTrue();
    })
  });
}