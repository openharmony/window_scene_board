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
import { FormAbilityController } from '../../../../../../../main/ets/default/common/components/form/useless/FormAbilityController';

export function FormAbilityControllerTest() {
  describe('FormAbilityControllerTest', () => {
    it('FormAbilityController_001', 0, () => {
      expect(FormAbilityController.getSum("", '1') === -1).assertEqual(true);
      expect(FormAbilityController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormAbilityController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormAbilityController.getSum('1', '') === -1).assertEqual(true);
      expect(FormAbilityController.getSum('1', null) === -1).assertEqual(true);
      expect(FormAbilityController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormAbilityController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAbilityController_002', 0, () => {
      expect(FormAbilityController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormAbilityController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormAbilityController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormAbilityController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormAbilityController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormAbilityController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormAbilityController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAbilityController_003', 0, () => {
      expect(FormAbilityController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormAbilityController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormAbilityController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormAbilityController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormAbilityController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormAbilityController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormAbilityController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAbilityController_004', 0, () => {
      expect(FormAbilityController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormAbilityController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormAbilityController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormAbilityController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormAbilityController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormAbilityController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormAbilityController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAbilityController_005', 0, () => {
      expect(FormAbilityController.isNumber("")).assertFalse();
      expect(FormAbilityController.isNumber(null)).assertFalse();
      expect(FormAbilityController.isNumber(undefined)).assertFalse();
      expect(FormAbilityController.isNumber("abc")).assertFalse();
      expect(FormAbilityController.isNumber("123")).assertTrue();
    });

    it('FormAbilityController_006', 0, () => {
      expect(FormAbilityController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormAbilityController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormAbilityController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormAbilityController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormAbilityController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormAbilityController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAbilityController_007', 0, () => {
      expect(FormAbilityController.getDefaultId(null) === null).assertTrue();
      expect(FormAbilityController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormAbilityController.getDefaultId('') === '').assertTrue();
      expect(FormAbilityController.getDefaultId('default') !== '').assertTrue();
      expect(FormAbilityController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormAbilityController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAbilityController_008', 0, () => {
      expect(FormAbilityController.getIndexByString("", []) === -1).assertTrue();
      expect(FormAbilityController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormAbilityController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormAbilityController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormAbilityController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormAbilityController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormAbilityController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAbilityController_009', 0, () => {
      expect(FormAbilityController.drawFontWidth() === -1).assertTrue();
      expect(FormAbilityController.drawFontWidth(100) === 1).assertTrue();
      expect(FormAbilityController.drawFontWidth(200) === 2).assertTrue();
      expect(FormAbilityController.drawFontWidth(300) === 3).assertTrue();
      expect(FormAbilityController.drawFontWidth(400) === 4).assertTrue();
      expect(FormAbilityController.drawFontWidth(500) === 6).assertTrue();
      expect(FormAbilityController.drawFontWidth(600) === 7).assertTrue();
      expect(FormAbilityController.drawFontWidth(700) === 8).assertTrue();
      expect(FormAbilityController.drawFontWidth(800) === 9).assertTrue();
      expect(FormAbilityController.drawFontWidth(900) === 1).assertTrue();
      expect(FormAbilityController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormAbilityController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormAbilityController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormAbilityController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormAbilityController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormAbilityController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormAbilityController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormAbilityController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormAbilityController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormAbilityController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormAbilityController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormAbilityController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAbilityController_010', 0, () => {
      expect(FormAbilityController.drawTextAlign() === -1).assertTrue();
      expect(FormAbilityController.drawTextAlign(100) === 0).assertTrue();
      expect(FormAbilityController.drawTextAlign(200) === 1).assertTrue();
      expect(FormAbilityController.drawTextAlign(300) === 2).assertTrue();
      expect(FormAbilityController.drawTextAlign(400) === 3).assertTrue();
      expect(FormAbilityController.drawTextAlign(500) === 4).assertTrue();
      expect(FormAbilityController.drawTextAlign(600) === 5).assertTrue();
      expect(FormAbilityController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAbilityController_011', 0, () => {
      expect(FormAbilityController.getStringIndex('', '') === -1).assertTrue();
      expect(FormAbilityController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormAbilityController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormAbilityController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormAbilityController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormAbilityController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormAbilityController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormAbilityController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormAbilityController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormAbilityController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormAbilityController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormAbilityController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormAbilityController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormAbilityController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormAbilityController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormAbilityController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormAbilityController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormAbilityController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormAbilityController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAbilityController_012', 0, () => {
      expect(FormAbilityController.checkArr([]) === false).assertTrue();
      expect(FormAbilityController.checkArr(null) === false).assertTrue();
      expect(FormAbilityController.checkArr(undefined) === false).assertTrue();
      expect(FormAbilityController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormAbilityController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormAbilityController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormAbilityController.checkArr(['a', '']) === false).assertTrue();
      expect(FormAbilityController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormAbilityController.checkArr(['a', null]) === false).assertTrue();
      expect(FormAbilityController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormAbilityController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormAbilityController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormAbilityController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormAbilityController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormAbilityController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormAbilityController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormAbilityController.getUUID().length > 0).assertTrue();
    })

    it('FormAbilityController_013', 0, () => {
      expect(FormAbilityController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormAbilityController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAbilityController_014', 0, () => {
      expect(FormAbilityController.getBinaryData(null, '') === '').assertTrue();
      expect(FormAbilityController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormAbilityController.getBinaryData(2, null) === '').assertTrue();
      expect(FormAbilityController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormAbilityController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormAbilityController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormAbilityController.getBinaryData(0, '') === '').assertTrue();
      expect(FormAbilityController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAbilityController_015', 0, () => {
      expect(FormAbilityController.getArraySum(null, []) === -1).assertTrue();
      expect(FormAbilityController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormAbilityController.getArraySum([], null) === -1).assertTrue();
      expect(FormAbilityController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormAbilityController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormAbilityController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormAbilityController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormAbilityController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormAbilityController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormAbilityController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormAbilityController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormAbilityController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAbilityController_016', 0, () => {
      expect(FormAbilityController.isEmpty(null)).assertTrue();
      expect(FormAbilityController.isEmpty(undefined)).assertTrue();
      expect(FormAbilityController.isEmpty('')).assertTrue();
      expect(FormAbilityController.isEmpty(0)).assertTrue();
      expect(FormAbilityController.isEmpty([])).assertTrue();
      expect(FormAbilityController.isEmpty(1, null)).assertTrue();
      expect(FormAbilityController.isEmpty(1, undefined)).assertTrue();
      expect(FormAbilityController.isEmpty(1, true)).assertTrue();
      expect(FormAbilityController.isEmpty(1, false)).assertFalse();
    })

    it('FormAbilityController_017', 0, () => {
      expect(FormAbilityController.equals(null, 'a')).assertFalse();
      expect(FormAbilityController.equals(undefined, 'a')).assertFalse();
      expect(FormAbilityController.equals('a', null)).assertFalse();
      expect(FormAbilityController.equals('a', undefined)).assertFalse();
      expect(FormAbilityController.equals('a', 1)).assertFalse();
      expect(FormAbilityController.equals(1, 'a')).assertFalse();
      expect(FormAbilityController.equals(1, [])).assertFalse();
      expect(FormAbilityController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormAbilityController.equals([], m)).assertFalse();
      expect(FormAbilityController.equals(m, [])).assertFalse();
      expect(FormAbilityController.equals([1,2], [])).assertFalse();
      expect(FormAbilityController.equals([], [1, 2])).assertFalse();
      expect(FormAbilityController.equals([1], [1, 2])).assertFalse();
      expect(FormAbilityController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormAbilityController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormAbilityController.equals(2, 2)).assertTrue();
    })
  });
}