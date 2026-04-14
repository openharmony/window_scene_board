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
import { FormStackAbilityController } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackAbilityController';

export function FormStackAbilityControllerTest() {
  describe('FormStackAbilityControllerTest', () => {
    it('FormStackAbilityController_001', 0, () => {
      expect(FormStackAbilityController.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackAbilityController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackAbilityController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackAbilityController.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackAbilityController.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackAbilityController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackAbilityController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackAbilityController_002', 0, () => {
      expect(FormStackAbilityController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackAbilityController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackAbilityController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackAbilityController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackAbilityController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackAbilityController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackAbilityController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackAbilityController_003', 0, () => {
      expect(FormStackAbilityController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackAbilityController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackAbilityController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAbilityController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAbilityController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAbilityController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackAbilityController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackAbilityController_004', 0, () => {
      expect(FormStackAbilityController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackAbilityController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackAbilityController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackAbilityController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackAbilityController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackAbilityController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackAbilityController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackAbilityController_005', 0, () => {
      expect(FormStackAbilityController.isNumber("")).assertFalse();
      expect(FormStackAbilityController.isNumber(null)).assertFalse();
      expect(FormStackAbilityController.isNumber(undefined)).assertFalse();
      expect(FormStackAbilityController.isNumber("abc")).assertFalse();
      expect(FormStackAbilityController.isNumber("123")).assertTrue();
    });

    it('FormStackAbilityController_006', 0, () => {
      expect(FormStackAbilityController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackAbilityController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackAbilityController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackAbilityController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackAbilityController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackAbilityController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackAbilityController_007', 0, () => {
      expect(FormStackAbilityController.getDefaultId(null) === null).assertTrue();
      expect(FormStackAbilityController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackAbilityController.getDefaultId('') === '').assertTrue();
      expect(FormStackAbilityController.getDefaultId('default') !== '').assertTrue();
      expect(FormStackAbilityController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackAbilityController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackAbilityController_008', 0, () => {
      expect(FormStackAbilityController.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackAbilityController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackAbilityController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackAbilityController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackAbilityController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackAbilityController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackAbilityController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackAbilityController_009', 0, () => {
      expect(FormStackAbilityController.drawFontWidth() === -1).assertTrue();
      expect(FormStackAbilityController.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackAbilityController.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackAbilityController.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackAbilityController.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackAbilityController.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackAbilityController.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackAbilityController.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackAbilityController.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackAbilityController.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackAbilityController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackAbilityController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackAbilityController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackAbilityController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackAbilityController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackAbilityController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackAbilityController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackAbilityController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackAbilityController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackAbilityController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackAbilityController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackAbilityController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackAbilityController_010', 0, () => {
      expect(FormStackAbilityController.drawTextAlign() === -1).assertTrue();
      expect(FormStackAbilityController.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackAbilityController.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackAbilityController.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackAbilityController.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackAbilityController.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackAbilityController.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackAbilityController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackAbilityController_011', 0, () => {
      expect(FormStackAbilityController.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackAbilityController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackAbilityController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackAbilityController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackAbilityController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackAbilityController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackAbilityController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackAbilityController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackAbilityController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackAbilityController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackAbilityController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackAbilityController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackAbilityController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackAbilityController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackAbilityController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackAbilityController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackAbilityController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackAbilityController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackAbilityController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackAbilityController_012', 0, () => {
      expect(FormStackAbilityController.checkArr([]) === false).assertTrue();
      expect(FormStackAbilityController.checkArr(null) === false).assertTrue();
      expect(FormStackAbilityController.checkArr(undefined) === false).assertTrue();
      expect(FormStackAbilityController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackAbilityController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackAbilityController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackAbilityController.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackAbilityController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackAbilityController.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackAbilityController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackAbilityController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackAbilityController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackAbilityController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackAbilityController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackAbilityController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackAbilityController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackAbilityController.getUUID().length > 0).assertTrue();
    })

    it('FormStackAbilityController_013', 0, () => {
      expect(FormStackAbilityController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackAbilityController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackAbilityController_014', 0, () => {
      expect(FormStackAbilityController.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackAbilityController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackAbilityController.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackAbilityController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackAbilityController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackAbilityController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackAbilityController.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackAbilityController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackAbilityController_015', 0, () => {
      expect(FormStackAbilityController.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackAbilityController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackAbilityController.getArraySum([], null) === -1).assertTrue();
      expect(FormStackAbilityController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackAbilityController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackAbilityController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackAbilityController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackAbilityController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackAbilityController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackAbilityController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackAbilityController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackAbilityController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackAbilityController_016', 0, () => {
      expect(FormStackAbilityController.isEmpty(null)).assertTrue();
      expect(FormStackAbilityController.isEmpty(undefined)).assertTrue();
      expect(FormStackAbilityController.isEmpty('')).assertTrue();
      expect(FormStackAbilityController.isEmpty(0)).assertTrue();
      expect(FormStackAbilityController.isEmpty([])).assertTrue();
      expect(FormStackAbilityController.isEmpty(1, null)).assertTrue();
      expect(FormStackAbilityController.isEmpty(1, undefined)).assertTrue();
      expect(FormStackAbilityController.isEmpty(1, true)).assertTrue();
      expect(FormStackAbilityController.isEmpty(1, false)).assertFalse();
    })

    it('FormStackAbilityController_017', 0, () => {
      expect(FormStackAbilityController.equals(null, 'a')).assertFalse();
      expect(FormStackAbilityController.equals(undefined, 'a')).assertFalse();
      expect(FormStackAbilityController.equals('a', null)).assertFalse();
      expect(FormStackAbilityController.equals('a', undefined)).assertFalse();
      expect(FormStackAbilityController.equals('a', 1)).assertFalse();
      expect(FormStackAbilityController.equals(1, 'a')).assertFalse();
      expect(FormStackAbilityController.equals(1, [])).assertFalse();
      expect(FormStackAbilityController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackAbilityController.equals([], m)).assertFalse();
      expect(FormStackAbilityController.equals(m, [])).assertFalse();
      expect(FormStackAbilityController.equals([1,2], [])).assertFalse();
      expect(FormStackAbilityController.equals([], [1, 2])).assertFalse();
      expect(FormStackAbilityController.equals([1], [1, 2])).assertFalse();
      expect(FormStackAbilityController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackAbilityController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackAbilityController.equals(2, 2)).assertTrue();
    })
  });
}