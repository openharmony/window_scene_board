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
import { FormThemeModelController } from '../../../../../../../main/ets/default/common/components/form/useless/FormThemeModelController';

export function FormThemeModelControllerTest() {
  describe('FormThemeModelControllerTest', () => {
    it('FormThemeModelController_001', 0, () => {
      expect(FormThemeModelController.getSum("", '1') === -1).assertEqual(true);
      expect(FormThemeModelController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormThemeModelController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormThemeModelController.getSum('1', '') === -1).assertEqual(true);
      expect(FormThemeModelController.getSum('1', null) === -1).assertEqual(true);
      expect(FormThemeModelController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormThemeModelController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormThemeModelController_002', 0, () => {
      expect(FormThemeModelController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormThemeModelController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormThemeModelController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormThemeModelController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormThemeModelController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormThemeModelController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormThemeModelController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormThemeModelController_003', 0, () => {
      expect(FormThemeModelController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormThemeModelController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormThemeModelController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeModelController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeModelController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeModelController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormThemeModelController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormThemeModelController_004', 0, () => {
      expect(FormThemeModelController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormThemeModelController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormThemeModelController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeModelController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeModelController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeModelController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormThemeModelController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormThemeModelController_005', 0, () => {
      expect(FormThemeModelController.isNumber("")).assertFalse();
      expect(FormThemeModelController.isNumber(null)).assertFalse();
      expect(FormThemeModelController.isNumber(undefined)).assertFalse();
      expect(FormThemeModelController.isNumber("abc")).assertFalse();
      expect(FormThemeModelController.isNumber("123")).assertTrue();
    });

    it('FormThemeModelController_006', 0, () => {
      expect(FormThemeModelController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormThemeModelController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormThemeModelController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormThemeModelController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormThemeModelController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormThemeModelController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormThemeModelController_007', 0, () => {
      expect(FormThemeModelController.getDefaultId(null) === null).assertTrue();
      expect(FormThemeModelController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormThemeModelController.getDefaultId('') === '').assertTrue();
      expect(FormThemeModelController.getDefaultId('default') !== '').assertTrue();
      expect(FormThemeModelController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormThemeModelController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormThemeModelController_008', 0, () => {
      expect(FormThemeModelController.getIndexByString("", []) === -1).assertTrue();
      expect(FormThemeModelController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormThemeModelController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormThemeModelController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormThemeModelController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormThemeModelController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormThemeModelController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormThemeModelController_009', 0, () => {
      expect(FormThemeModelController.drawFontWidth() === -1).assertTrue();
      expect(FormThemeModelController.drawFontWidth(100) === 1).assertTrue();
      expect(FormThemeModelController.drawFontWidth(200) === 2).assertTrue();
      expect(FormThemeModelController.drawFontWidth(300) === 3).assertTrue();
      expect(FormThemeModelController.drawFontWidth(400) === 4).assertTrue();
      expect(FormThemeModelController.drawFontWidth(500) === 6).assertTrue();
      expect(FormThemeModelController.drawFontWidth(600) === 7).assertTrue();
      expect(FormThemeModelController.drawFontWidth(700) === 8).assertTrue();
      expect(FormThemeModelController.drawFontWidth(800) === 9).assertTrue();
      expect(FormThemeModelController.drawFontWidth(900) === 1).assertTrue();
      expect(FormThemeModelController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormThemeModelController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormThemeModelController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormThemeModelController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormThemeModelController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormThemeModelController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormThemeModelController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormThemeModelController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormThemeModelController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormThemeModelController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormThemeModelController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormThemeModelController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormThemeModelController_010', 0, () => {
      expect(FormThemeModelController.drawTextAlign() === -1).assertTrue();
      expect(FormThemeModelController.drawTextAlign(100) === 0).assertTrue();
      expect(FormThemeModelController.drawTextAlign(200) === 1).assertTrue();
      expect(FormThemeModelController.drawTextAlign(300) === 2).assertTrue();
      expect(FormThemeModelController.drawTextAlign(400) === 3).assertTrue();
      expect(FormThemeModelController.drawTextAlign(500) === 4).assertTrue();
      expect(FormThemeModelController.drawTextAlign(600) === 5).assertTrue();
      expect(FormThemeModelController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormThemeModelController_011', 0, () => {
      expect(FormThemeModelController.getStringIndex('', '') === -1).assertTrue();
      expect(FormThemeModelController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormThemeModelController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormThemeModelController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormThemeModelController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormThemeModelController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormThemeModelController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormThemeModelController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormThemeModelController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormThemeModelController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormThemeModelController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormThemeModelController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormThemeModelController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormThemeModelController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormThemeModelController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormThemeModelController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormThemeModelController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormThemeModelController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormThemeModelController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormThemeModelController_012', 0, () => {
      expect(FormThemeModelController.checkArr([]) === false).assertTrue();
      expect(FormThemeModelController.checkArr(null) === false).assertTrue();
      expect(FormThemeModelController.checkArr(undefined) === false).assertTrue();
      expect(FormThemeModelController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormThemeModelController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormThemeModelController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormThemeModelController.checkArr(['a', '']) === false).assertTrue();
      expect(FormThemeModelController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormThemeModelController.checkArr(['a', null]) === false).assertTrue();
      expect(FormThemeModelController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormThemeModelController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormThemeModelController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormThemeModelController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormThemeModelController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormThemeModelController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormThemeModelController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormThemeModelController.getUUID().length > 0).assertTrue();
    })

    it('FormThemeModelController_013', 0, () => {
      expect(FormThemeModelController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormThemeModelController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormThemeModelController_014', 0, () => {
      expect(FormThemeModelController.getBinaryData(null, '') === '').assertTrue();
      expect(FormThemeModelController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormThemeModelController.getBinaryData(2, null) === '').assertTrue();
      expect(FormThemeModelController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormThemeModelController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormThemeModelController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormThemeModelController.getBinaryData(0, '') === '').assertTrue();
      expect(FormThemeModelController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormThemeModelController_015', 0, () => {
      expect(FormThemeModelController.getArraySum(null, []) === -1).assertTrue();
      expect(FormThemeModelController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormThemeModelController.getArraySum([], null) === -1).assertTrue();
      expect(FormThemeModelController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormThemeModelController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormThemeModelController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormThemeModelController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormThemeModelController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormThemeModelController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormThemeModelController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormThemeModelController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormThemeModelController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormThemeModelController_016', 0, () => {
      expect(FormThemeModelController.isEmpty(null)).assertTrue();
      expect(FormThemeModelController.isEmpty(undefined)).assertTrue();
      expect(FormThemeModelController.isEmpty('')).assertTrue();
      expect(FormThemeModelController.isEmpty(0)).assertTrue();
      expect(FormThemeModelController.isEmpty([])).assertTrue();
      expect(FormThemeModelController.isEmpty(1, null)).assertTrue();
      expect(FormThemeModelController.isEmpty(1, undefined)).assertTrue();
      expect(FormThemeModelController.isEmpty(1, true)).assertTrue();
      expect(FormThemeModelController.isEmpty(1, false)).assertFalse();
    })

    it('FormThemeModelController_017', 0, () => {
      expect(FormThemeModelController.equals(null, 'a')).assertFalse();
      expect(FormThemeModelController.equals(undefined, 'a')).assertFalse();
      expect(FormThemeModelController.equals('a', null)).assertFalse();
      expect(FormThemeModelController.equals('a', undefined)).assertFalse();
      expect(FormThemeModelController.equals('a', 1)).assertFalse();
      expect(FormThemeModelController.equals(1, 'a')).assertFalse();
      expect(FormThemeModelController.equals(1, [])).assertFalse();
      expect(FormThemeModelController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormThemeModelController.equals([], m)).assertFalse();
      expect(FormThemeModelController.equals(m, [])).assertFalse();
      expect(FormThemeModelController.equals([1,2], [])).assertFalse();
      expect(FormThemeModelController.equals([], [1, 2])).assertFalse();
      expect(FormThemeModelController.equals([1], [1, 2])).assertFalse();
      expect(FormThemeModelController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormThemeModelController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormThemeModelController.equals(2, 2)).assertTrue();
    })
  });
}