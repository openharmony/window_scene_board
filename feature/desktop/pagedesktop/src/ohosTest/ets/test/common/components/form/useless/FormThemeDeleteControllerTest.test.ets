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
import { FormThemeDeleteController } from '../../../../../../../main/ets/default/common/components/form/useless/FormThemeDeleteController';

export function FormThemeDeleteControllerTest() {
  describe('FormThemeDeleteControllerTest', () => {
    it('FormThemeDeleteController_001', 0, () => {
      expect(FormThemeDeleteController.getSum("", '1') === -1).assertEqual(true);
      expect(FormThemeDeleteController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormThemeDeleteController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormThemeDeleteController.getSum('1', '') === -1).assertEqual(true);
      expect(FormThemeDeleteController.getSum('1', null) === -1).assertEqual(true);
      expect(FormThemeDeleteController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormThemeDeleteController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormThemeDeleteController_002', 0, () => {
      expect(FormThemeDeleteController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormThemeDeleteController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormThemeDeleteController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormThemeDeleteController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormThemeDeleteController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormThemeDeleteController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormThemeDeleteController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormThemeDeleteController_003', 0, () => {
      expect(FormThemeDeleteController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormThemeDeleteController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormThemeDeleteController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeDeleteController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeDeleteController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeDeleteController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormThemeDeleteController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormThemeDeleteController_004', 0, () => {
      expect(FormThemeDeleteController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormThemeDeleteController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormThemeDeleteController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeDeleteController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeDeleteController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeDeleteController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormThemeDeleteController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormThemeDeleteController_005', 0, () => {
      expect(FormThemeDeleteController.isNumber("")).assertFalse();
      expect(FormThemeDeleteController.isNumber(null)).assertFalse();
      expect(FormThemeDeleteController.isNumber(undefined)).assertFalse();
      expect(FormThemeDeleteController.isNumber("abc")).assertFalse();
      expect(FormThemeDeleteController.isNumber("123")).assertTrue();
    });

    it('FormThemeDeleteController_006', 0, () => {
      expect(FormThemeDeleteController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormThemeDeleteController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormThemeDeleteController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormThemeDeleteController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormThemeDeleteController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormThemeDeleteController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormThemeDeleteController_007', 0, () => {
      expect(FormThemeDeleteController.getDefaultId(null) === null).assertTrue();
      expect(FormThemeDeleteController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormThemeDeleteController.getDefaultId('') === '').assertTrue();
      expect(FormThemeDeleteController.getDefaultId('default') !== '').assertTrue();
      expect(FormThemeDeleteController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormThemeDeleteController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormThemeDeleteController_008', 0, () => {
      expect(FormThemeDeleteController.getIndexByString("", []) === -1).assertTrue();
      expect(FormThemeDeleteController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormThemeDeleteController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormThemeDeleteController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormThemeDeleteController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormThemeDeleteController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormThemeDeleteController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormThemeDeleteController_009', 0, () => {
      expect(FormThemeDeleteController.drawFontWidth() === -1).assertTrue();
      expect(FormThemeDeleteController.drawFontWidth(100) === 1).assertTrue();
      expect(FormThemeDeleteController.drawFontWidth(200) === 2).assertTrue();
      expect(FormThemeDeleteController.drawFontWidth(300) === 3).assertTrue();
      expect(FormThemeDeleteController.drawFontWidth(400) === 4).assertTrue();
      expect(FormThemeDeleteController.drawFontWidth(500) === 6).assertTrue();
      expect(FormThemeDeleteController.drawFontWidth(600) === 7).assertTrue();
      expect(FormThemeDeleteController.drawFontWidth(700) === 8).assertTrue();
      expect(FormThemeDeleteController.drawFontWidth(800) === 9).assertTrue();
      expect(FormThemeDeleteController.drawFontWidth(900) === 1).assertTrue();
      expect(FormThemeDeleteController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormThemeDeleteController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormThemeDeleteController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormThemeDeleteController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormThemeDeleteController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormThemeDeleteController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormThemeDeleteController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormThemeDeleteController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormThemeDeleteController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormThemeDeleteController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormThemeDeleteController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormThemeDeleteController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormThemeDeleteController_010', 0, () => {
      expect(FormThemeDeleteController.drawTextAlign() === -1).assertTrue();
      expect(FormThemeDeleteController.drawTextAlign(100) === 0).assertTrue();
      expect(FormThemeDeleteController.drawTextAlign(200) === 1).assertTrue();
      expect(FormThemeDeleteController.drawTextAlign(300) === 2).assertTrue();
      expect(FormThemeDeleteController.drawTextAlign(400) === 3).assertTrue();
      expect(FormThemeDeleteController.drawTextAlign(500) === 4).assertTrue();
      expect(FormThemeDeleteController.drawTextAlign(600) === 5).assertTrue();
      expect(FormThemeDeleteController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormThemeDeleteController_011', 0, () => {
      expect(FormThemeDeleteController.getStringIndex('', '') === -1).assertTrue();
      expect(FormThemeDeleteController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormThemeDeleteController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormThemeDeleteController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormThemeDeleteController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormThemeDeleteController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormThemeDeleteController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormThemeDeleteController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormThemeDeleteController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormThemeDeleteController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormThemeDeleteController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormThemeDeleteController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormThemeDeleteController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormThemeDeleteController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormThemeDeleteController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormThemeDeleteController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormThemeDeleteController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormThemeDeleteController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormThemeDeleteController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormThemeDeleteController_012', 0, () => {
      expect(FormThemeDeleteController.checkArr([]) === false).assertTrue();
      expect(FormThemeDeleteController.checkArr(null) === false).assertTrue();
      expect(FormThemeDeleteController.checkArr(undefined) === false).assertTrue();
      expect(FormThemeDeleteController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormThemeDeleteController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormThemeDeleteController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormThemeDeleteController.checkArr(['a', '']) === false).assertTrue();
      expect(FormThemeDeleteController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormThemeDeleteController.checkArr(['a', null]) === false).assertTrue();
      expect(FormThemeDeleteController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormThemeDeleteController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormThemeDeleteController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormThemeDeleteController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormThemeDeleteController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormThemeDeleteController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormThemeDeleteController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormThemeDeleteController.getUUID().length > 0).assertTrue();
    })

    it('FormThemeDeleteController_013', 0, () => {
      expect(FormThemeDeleteController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormThemeDeleteController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormThemeDeleteController_014', 0, () => {
      expect(FormThemeDeleteController.getBinaryData(null, '') === '').assertTrue();
      expect(FormThemeDeleteController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormThemeDeleteController.getBinaryData(2, null) === '').assertTrue();
      expect(FormThemeDeleteController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormThemeDeleteController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormThemeDeleteController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormThemeDeleteController.getBinaryData(0, '') === '').assertTrue();
      expect(FormThemeDeleteController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormThemeDeleteController_015', 0, () => {
      expect(FormThemeDeleteController.getArraySum(null, []) === -1).assertTrue();
      expect(FormThemeDeleteController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormThemeDeleteController.getArraySum([], null) === -1).assertTrue();
      expect(FormThemeDeleteController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormThemeDeleteController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormThemeDeleteController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormThemeDeleteController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormThemeDeleteController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormThemeDeleteController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormThemeDeleteController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormThemeDeleteController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormThemeDeleteController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormThemeDeleteController_016', 0, () => {
      expect(FormThemeDeleteController.isEmpty(null)).assertTrue();
      expect(FormThemeDeleteController.isEmpty(undefined)).assertTrue();
      expect(FormThemeDeleteController.isEmpty('')).assertTrue();
      expect(FormThemeDeleteController.isEmpty(0)).assertTrue();
      expect(FormThemeDeleteController.isEmpty([])).assertTrue();
      expect(FormThemeDeleteController.isEmpty(1, null)).assertTrue();
      expect(FormThemeDeleteController.isEmpty(1, undefined)).assertTrue();
      expect(FormThemeDeleteController.isEmpty(1, true)).assertTrue();
      expect(FormThemeDeleteController.isEmpty(1, false)).assertFalse();
    })

    it('FormThemeDeleteController_017', 0, () => {
      expect(FormThemeDeleteController.equals(null, 'a')).assertFalse();
      expect(FormThemeDeleteController.equals(undefined, 'a')).assertFalse();
      expect(FormThemeDeleteController.equals('a', null)).assertFalse();
      expect(FormThemeDeleteController.equals('a', undefined)).assertFalse();
      expect(FormThemeDeleteController.equals('a', 1)).assertFalse();
      expect(FormThemeDeleteController.equals(1, 'a')).assertFalse();
      expect(FormThemeDeleteController.equals(1, [])).assertFalse();
      expect(FormThemeDeleteController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormThemeDeleteController.equals([], m)).assertFalse();
      expect(FormThemeDeleteController.equals(m, [])).assertFalse();
      expect(FormThemeDeleteController.equals([1,2], [])).assertFalse();
      expect(FormThemeDeleteController.equals([], [1, 2])).assertFalse();
      expect(FormThemeDeleteController.equals([1], [1, 2])).assertFalse();
      expect(FormThemeDeleteController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormThemeDeleteController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormThemeDeleteController.equals(2, 2)).assertTrue();
    })
  });
}