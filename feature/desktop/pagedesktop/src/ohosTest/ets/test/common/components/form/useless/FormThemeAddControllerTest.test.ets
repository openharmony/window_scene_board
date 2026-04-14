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
import { FormThemeAddController } from '../../../../../../../main/ets/default/common/components/form/useless/FormThemeAddController';

export function FormThemeAddControllerTest() {
  describe('FormThemeAddControllerTest', () => {
    it('FormThemeAddController_001', 0, () => {
      expect(FormThemeAddController.getSum("", '1') === -1).assertEqual(true);
      expect(FormThemeAddController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormThemeAddController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormThemeAddController.getSum('1', '') === -1).assertEqual(true);
      expect(FormThemeAddController.getSum('1', null) === -1).assertEqual(true);
      expect(FormThemeAddController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormThemeAddController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormThemeAddController_002', 0, () => {
      expect(FormThemeAddController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormThemeAddController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormThemeAddController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAddController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormThemeAddController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAddController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormThemeAddController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormThemeAddController_003', 0, () => {
      expect(FormThemeAddController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormThemeAddController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAddController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAddController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAddController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAddController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormThemeAddController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormThemeAddController_004', 0, () => {
      expect(FormThemeAddController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormThemeAddController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAddController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAddController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAddController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAddController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormThemeAddController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormThemeAddController_005', 0, () => {
      expect(FormThemeAddController.isNumber("")).assertFalse();
      expect(FormThemeAddController.isNumber(null)).assertFalse();
      expect(FormThemeAddController.isNumber(undefined)).assertFalse();
      expect(FormThemeAddController.isNumber("abc")).assertFalse();
      expect(FormThemeAddController.isNumber("123")).assertTrue();
    });

    it('FormThemeAddController_006', 0, () => {
      expect(FormThemeAddController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormThemeAddController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormThemeAddController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormThemeAddController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormThemeAddController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormThemeAddController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormThemeAddController_007', 0, () => {
      expect(FormThemeAddController.getDefaultId(null) === null).assertTrue();
      expect(FormThemeAddController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormThemeAddController.getDefaultId('') === '').assertTrue();
      expect(FormThemeAddController.getDefaultId('default') !== '').assertTrue();
      expect(FormThemeAddController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormThemeAddController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormThemeAddController_008', 0, () => {
      expect(FormThemeAddController.getIndexByString("", []) === -1).assertTrue();
      expect(FormThemeAddController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormThemeAddController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormThemeAddController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormThemeAddController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormThemeAddController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormThemeAddController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormThemeAddController_009', 0, () => {
      expect(FormThemeAddController.drawFontWidth() === -1).assertTrue();
      expect(FormThemeAddController.drawFontWidth(100) === 1).assertTrue();
      expect(FormThemeAddController.drawFontWidth(200) === 2).assertTrue();
      expect(FormThemeAddController.drawFontWidth(300) === 3).assertTrue();
      expect(FormThemeAddController.drawFontWidth(400) === 4).assertTrue();
      expect(FormThemeAddController.drawFontWidth(500) === 6).assertTrue();
      expect(FormThemeAddController.drawFontWidth(600) === 7).assertTrue();
      expect(FormThemeAddController.drawFontWidth(700) === 8).assertTrue();
      expect(FormThemeAddController.drawFontWidth(800) === 9).assertTrue();
      expect(FormThemeAddController.drawFontWidth(900) === 1).assertTrue();
      expect(FormThemeAddController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormThemeAddController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormThemeAddController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormThemeAddController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormThemeAddController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormThemeAddController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormThemeAddController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormThemeAddController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormThemeAddController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormThemeAddController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormThemeAddController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormThemeAddController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormThemeAddController_010', 0, () => {
      expect(FormThemeAddController.drawTextAlign() === -1).assertTrue();
      expect(FormThemeAddController.drawTextAlign(100) === 0).assertTrue();
      expect(FormThemeAddController.drawTextAlign(200) === 1).assertTrue();
      expect(FormThemeAddController.drawTextAlign(300) === 2).assertTrue();
      expect(FormThemeAddController.drawTextAlign(400) === 3).assertTrue();
      expect(FormThemeAddController.drawTextAlign(500) === 4).assertTrue();
      expect(FormThemeAddController.drawTextAlign(600) === 5).assertTrue();
      expect(FormThemeAddController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormThemeAddController_011', 0, () => {
      expect(FormThemeAddController.getStringIndex('', '') === -1).assertTrue();
      expect(FormThemeAddController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormThemeAddController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormThemeAddController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormThemeAddController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormThemeAddController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormThemeAddController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormThemeAddController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormThemeAddController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormThemeAddController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormThemeAddController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormThemeAddController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormThemeAddController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormThemeAddController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormThemeAddController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormThemeAddController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormThemeAddController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormThemeAddController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormThemeAddController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormThemeAddController_012', 0, () => {
      expect(FormThemeAddController.checkArr([]) === false).assertTrue();
      expect(FormThemeAddController.checkArr(null) === false).assertTrue();
      expect(FormThemeAddController.checkArr(undefined) === false).assertTrue();
      expect(FormThemeAddController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormThemeAddController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormThemeAddController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormThemeAddController.checkArr(['a', '']) === false).assertTrue();
      expect(FormThemeAddController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormThemeAddController.checkArr(['a', null]) === false).assertTrue();
      expect(FormThemeAddController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormThemeAddController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormThemeAddController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormThemeAddController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormThemeAddController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormThemeAddController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormThemeAddController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormThemeAddController.getUUID().length > 0).assertTrue();
    })

    it('FormThemeAddController_013', 0, () => {
      expect(FormThemeAddController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormThemeAddController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormThemeAddController_014', 0, () => {
      expect(FormThemeAddController.getBinaryData(null, '') === '').assertTrue();
      expect(FormThemeAddController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormThemeAddController.getBinaryData(2, null) === '').assertTrue();
      expect(FormThemeAddController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormThemeAddController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormThemeAddController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormThemeAddController.getBinaryData(0, '') === '').assertTrue();
      expect(FormThemeAddController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormThemeAddController_015', 0, () => {
      expect(FormThemeAddController.getArraySum(null, []) === -1).assertTrue();
      expect(FormThemeAddController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormThemeAddController.getArraySum([], null) === -1).assertTrue();
      expect(FormThemeAddController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormThemeAddController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormThemeAddController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormThemeAddController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormThemeAddController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormThemeAddController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormThemeAddController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormThemeAddController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormThemeAddController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormThemeAddController_016', 0, () => {
      expect(FormThemeAddController.isEmpty(null)).assertTrue();
      expect(FormThemeAddController.isEmpty(undefined)).assertTrue();
      expect(FormThemeAddController.isEmpty('')).assertTrue();
      expect(FormThemeAddController.isEmpty(0)).assertTrue();
      expect(FormThemeAddController.isEmpty([])).assertTrue();
      expect(FormThemeAddController.isEmpty(1, null)).assertTrue();
      expect(FormThemeAddController.isEmpty(1, undefined)).assertTrue();
      expect(FormThemeAddController.isEmpty(1, true)).assertTrue();
      expect(FormThemeAddController.isEmpty(1, false)).assertFalse();
    })

    it('FormThemeAddController_017', 0, () => {
      expect(FormThemeAddController.equals(null, 'a')).assertFalse();
      expect(FormThemeAddController.equals(undefined, 'a')).assertFalse();
      expect(FormThemeAddController.equals('a', null)).assertFalse();
      expect(FormThemeAddController.equals('a', undefined)).assertFalse();
      expect(FormThemeAddController.equals('a', 1)).assertFalse();
      expect(FormThemeAddController.equals(1, 'a')).assertFalse();
      expect(FormThemeAddController.equals(1, [])).assertFalse();
      expect(FormThemeAddController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormThemeAddController.equals([], m)).assertFalse();
      expect(FormThemeAddController.equals(m, [])).assertFalse();
      expect(FormThemeAddController.equals([1,2], [])).assertFalse();
      expect(FormThemeAddController.equals([], [1, 2])).assertFalse();
      expect(FormThemeAddController.equals([1], [1, 2])).assertFalse();
      expect(FormThemeAddController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormThemeAddController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormThemeAddController.equals(2, 2)).assertTrue();
    })
  });
}