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
import { FormThemeAbilityController } from '../../../../../../../main/ets/default/common/components/form/useless/FormThemeAbilityController';

export function FormThemeAbilityControllerTest() {
  describe('FormThemeAbilityControllerTest', () => {
    it('FormThemeAbilityController_001', 0, () => {
      expect(FormThemeAbilityController.getSum("", '1') === -1).assertEqual(true);
      expect(FormThemeAbilityController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormThemeAbilityController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormThemeAbilityController.getSum('1', '') === -1).assertEqual(true);
      expect(FormThemeAbilityController.getSum('1', null) === -1).assertEqual(true);
      expect(FormThemeAbilityController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormThemeAbilityController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormThemeAbilityController_002', 0, () => {
      expect(FormThemeAbilityController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormThemeAbilityController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormThemeAbilityController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAbilityController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormThemeAbilityController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAbilityController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormThemeAbilityController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormThemeAbilityController_003', 0, () => {
      expect(FormThemeAbilityController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormThemeAbilityController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAbilityController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAbilityController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAbilityController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAbilityController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormThemeAbilityController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormThemeAbilityController_004', 0, () => {
      expect(FormThemeAbilityController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormThemeAbilityController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAbilityController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAbilityController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAbilityController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAbilityController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormThemeAbilityController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormThemeAbilityController_005', 0, () => {
      expect(FormThemeAbilityController.isNumber("")).assertFalse();
      expect(FormThemeAbilityController.isNumber(null)).assertFalse();
      expect(FormThemeAbilityController.isNumber(undefined)).assertFalse();
      expect(FormThemeAbilityController.isNumber("abc")).assertFalse();
      expect(FormThemeAbilityController.isNumber("123")).assertTrue();
    });

    it('FormThemeAbilityController_006', 0, () => {
      expect(FormThemeAbilityController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormThemeAbilityController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormThemeAbilityController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormThemeAbilityController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormThemeAbilityController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormThemeAbilityController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormThemeAbilityController_007', 0, () => {
      expect(FormThemeAbilityController.getDefaultId(null) === null).assertTrue();
      expect(FormThemeAbilityController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormThemeAbilityController.getDefaultId('') === '').assertTrue();
      expect(FormThemeAbilityController.getDefaultId('default') !== '').assertTrue();
      expect(FormThemeAbilityController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormThemeAbilityController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormThemeAbilityController_008', 0, () => {
      expect(FormThemeAbilityController.getIndexByString("", []) === -1).assertTrue();
      expect(FormThemeAbilityController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormThemeAbilityController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormThemeAbilityController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormThemeAbilityController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormThemeAbilityController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormThemeAbilityController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormThemeAbilityController_009', 0, () => {
      expect(FormThemeAbilityController.drawFontWidth() === -1).assertTrue();
      expect(FormThemeAbilityController.drawFontWidth(100) === 1).assertTrue();
      expect(FormThemeAbilityController.drawFontWidth(200) === 2).assertTrue();
      expect(FormThemeAbilityController.drawFontWidth(300) === 3).assertTrue();
      expect(FormThemeAbilityController.drawFontWidth(400) === 4).assertTrue();
      expect(FormThemeAbilityController.drawFontWidth(500) === 6).assertTrue();
      expect(FormThemeAbilityController.drawFontWidth(600) === 7).assertTrue();
      expect(FormThemeAbilityController.drawFontWidth(700) === 8).assertTrue();
      expect(FormThemeAbilityController.drawFontWidth(800) === 9).assertTrue();
      expect(FormThemeAbilityController.drawFontWidth(900) === 1).assertTrue();
      expect(FormThemeAbilityController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormThemeAbilityController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormThemeAbilityController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormThemeAbilityController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormThemeAbilityController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormThemeAbilityController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormThemeAbilityController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormThemeAbilityController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormThemeAbilityController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormThemeAbilityController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormThemeAbilityController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormThemeAbilityController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormThemeAbilityController_010', 0, () => {
      expect(FormThemeAbilityController.drawTextAlign() === -1).assertTrue();
      expect(FormThemeAbilityController.drawTextAlign(100) === 0).assertTrue();
      expect(FormThemeAbilityController.drawTextAlign(200) === 1).assertTrue();
      expect(FormThemeAbilityController.drawTextAlign(300) === 2).assertTrue();
      expect(FormThemeAbilityController.drawTextAlign(400) === 3).assertTrue();
      expect(FormThemeAbilityController.drawTextAlign(500) === 4).assertTrue();
      expect(FormThemeAbilityController.drawTextAlign(600) === 5).assertTrue();
      expect(FormThemeAbilityController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormThemeAbilityController_011', 0, () => {
      expect(FormThemeAbilityController.getStringIndex('', '') === -1).assertTrue();
      expect(FormThemeAbilityController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormThemeAbilityController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormThemeAbilityController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormThemeAbilityController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormThemeAbilityController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormThemeAbilityController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormThemeAbilityController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormThemeAbilityController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormThemeAbilityController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormThemeAbilityController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormThemeAbilityController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormThemeAbilityController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormThemeAbilityController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormThemeAbilityController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormThemeAbilityController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormThemeAbilityController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormThemeAbilityController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormThemeAbilityController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormThemeAbilityController_012', 0, () => {
      expect(FormThemeAbilityController.checkArr([]) === false).assertTrue();
      expect(FormThemeAbilityController.checkArr(null) === false).assertTrue();
      expect(FormThemeAbilityController.checkArr(undefined) === false).assertTrue();
      expect(FormThemeAbilityController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormThemeAbilityController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormThemeAbilityController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormThemeAbilityController.checkArr(['a', '']) === false).assertTrue();
      expect(FormThemeAbilityController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormThemeAbilityController.checkArr(['a', null]) === false).assertTrue();
      expect(FormThemeAbilityController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormThemeAbilityController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormThemeAbilityController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormThemeAbilityController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormThemeAbilityController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormThemeAbilityController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormThemeAbilityController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormThemeAbilityController.getUUID().length > 0).assertTrue();
    })

    it('FormThemeAbilityController_013', 0, () => {
      expect(FormThemeAbilityController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormThemeAbilityController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormThemeAbilityController_014', 0, () => {
      expect(FormThemeAbilityController.getBinaryData(null, '') === '').assertTrue();
      expect(FormThemeAbilityController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormThemeAbilityController.getBinaryData(2, null) === '').assertTrue();
      expect(FormThemeAbilityController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormThemeAbilityController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormThemeAbilityController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormThemeAbilityController.getBinaryData(0, '') === '').assertTrue();
      expect(FormThemeAbilityController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormThemeAbilityController_015', 0, () => {
      expect(FormThemeAbilityController.getArraySum(null, []) === -1).assertTrue();
      expect(FormThemeAbilityController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormThemeAbilityController.getArraySum([], null) === -1).assertTrue();
      expect(FormThemeAbilityController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormThemeAbilityController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormThemeAbilityController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormThemeAbilityController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormThemeAbilityController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormThemeAbilityController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormThemeAbilityController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormThemeAbilityController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormThemeAbilityController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormThemeAbilityController_016', 0, () => {
      expect(FormThemeAbilityController.isEmpty(null)).assertTrue();
      expect(FormThemeAbilityController.isEmpty(undefined)).assertTrue();
      expect(FormThemeAbilityController.isEmpty('')).assertTrue();
      expect(FormThemeAbilityController.isEmpty(0)).assertTrue();
      expect(FormThemeAbilityController.isEmpty([])).assertTrue();
      expect(FormThemeAbilityController.isEmpty(1, null)).assertTrue();
      expect(FormThemeAbilityController.isEmpty(1, undefined)).assertTrue();
      expect(FormThemeAbilityController.isEmpty(1, true)).assertTrue();
      expect(FormThemeAbilityController.isEmpty(1, false)).assertFalse();
    })

    it('FormThemeAbilityController_017', 0, () => {
      expect(FormThemeAbilityController.equals(null, 'a')).assertFalse();
      expect(FormThemeAbilityController.equals(undefined, 'a')).assertFalse();
      expect(FormThemeAbilityController.equals('a', null)).assertFalse();
      expect(FormThemeAbilityController.equals('a', undefined)).assertFalse();
      expect(FormThemeAbilityController.equals('a', 1)).assertFalse();
      expect(FormThemeAbilityController.equals(1, 'a')).assertFalse();
      expect(FormThemeAbilityController.equals(1, [])).assertFalse();
      expect(FormThemeAbilityController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormThemeAbilityController.equals([], m)).assertFalse();
      expect(FormThemeAbilityController.equals(m, [])).assertFalse();
      expect(FormThemeAbilityController.equals([1,2], [])).assertFalse();
      expect(FormThemeAbilityController.equals([], [1, 2])).assertFalse();
      expect(FormThemeAbilityController.equals([1], [1, 2])).assertFalse();
      expect(FormThemeAbilityController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormThemeAbilityController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormThemeAbilityController.equals(2, 2)).assertTrue();
    })
  });
}