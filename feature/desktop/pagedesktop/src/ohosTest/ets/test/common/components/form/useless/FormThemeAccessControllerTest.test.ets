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
import { FormThemeAccessController } from '../../../../../../../main/ets/default/common/components/form/useless/FormThemeAccessController';

export function FormThemeAccessControllerTest() {
  describe('FormThemeAccessControllerTest', () => {
    it('FormThemeAccessController_001', 0, () => {
      expect(FormThemeAccessController.getSum("", '1') === -1).assertEqual(true);
      expect(FormThemeAccessController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormThemeAccessController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormThemeAccessController.getSum('1', '') === -1).assertEqual(true);
      expect(FormThemeAccessController.getSum('1', null) === -1).assertEqual(true);
      expect(FormThemeAccessController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormThemeAccessController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormThemeAccessController_002', 0, () => {
      expect(FormThemeAccessController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormThemeAccessController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormThemeAccessController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAccessController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormThemeAccessController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAccessController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormThemeAccessController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormThemeAccessController_003', 0, () => {
      expect(FormThemeAccessController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormThemeAccessController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAccessController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAccessController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAccessController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAccessController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormThemeAccessController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormThemeAccessController_004', 0, () => {
      expect(FormThemeAccessController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormThemeAccessController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAccessController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAccessController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAccessController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAccessController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormThemeAccessController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormThemeAccessController_005', 0, () => {
      expect(FormThemeAccessController.isNumber("")).assertFalse();
      expect(FormThemeAccessController.isNumber(null)).assertFalse();
      expect(FormThemeAccessController.isNumber(undefined)).assertFalse();
      expect(FormThemeAccessController.isNumber("abc")).assertFalse();
      expect(FormThemeAccessController.isNumber("123")).assertTrue();
    });

    it('FormThemeAccessController_006', 0, () => {
      expect(FormThemeAccessController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormThemeAccessController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormThemeAccessController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormThemeAccessController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormThemeAccessController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormThemeAccessController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormThemeAccessController_007', 0, () => {
      expect(FormThemeAccessController.getDefaultId(null) === null).assertTrue();
      expect(FormThemeAccessController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormThemeAccessController.getDefaultId('') === '').assertTrue();
      expect(FormThemeAccessController.getDefaultId('default') !== '').assertTrue();
      expect(FormThemeAccessController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormThemeAccessController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormThemeAccessController_008', 0, () => {
      expect(FormThemeAccessController.getIndexByString("", []) === -1).assertTrue();
      expect(FormThemeAccessController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormThemeAccessController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormThemeAccessController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormThemeAccessController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormThemeAccessController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormThemeAccessController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormThemeAccessController_009', 0, () => {
      expect(FormThemeAccessController.drawFontWidth() === -1).assertTrue();
      expect(FormThemeAccessController.drawFontWidth(100) === 1).assertTrue();
      expect(FormThemeAccessController.drawFontWidth(200) === 2).assertTrue();
      expect(FormThemeAccessController.drawFontWidth(300) === 3).assertTrue();
      expect(FormThemeAccessController.drawFontWidth(400) === 4).assertTrue();
      expect(FormThemeAccessController.drawFontWidth(500) === 6).assertTrue();
      expect(FormThemeAccessController.drawFontWidth(600) === 7).assertTrue();
      expect(FormThemeAccessController.drawFontWidth(700) === 8).assertTrue();
      expect(FormThemeAccessController.drawFontWidth(800) === 9).assertTrue();
      expect(FormThemeAccessController.drawFontWidth(900) === 1).assertTrue();
      expect(FormThemeAccessController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormThemeAccessController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormThemeAccessController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormThemeAccessController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormThemeAccessController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormThemeAccessController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormThemeAccessController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormThemeAccessController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormThemeAccessController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormThemeAccessController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormThemeAccessController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormThemeAccessController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormThemeAccessController_010', 0, () => {
      expect(FormThemeAccessController.drawTextAlign() === -1).assertTrue();
      expect(FormThemeAccessController.drawTextAlign(100) === 0).assertTrue();
      expect(FormThemeAccessController.drawTextAlign(200) === 1).assertTrue();
      expect(FormThemeAccessController.drawTextAlign(300) === 2).assertTrue();
      expect(FormThemeAccessController.drawTextAlign(400) === 3).assertTrue();
      expect(FormThemeAccessController.drawTextAlign(500) === 4).assertTrue();
      expect(FormThemeAccessController.drawTextAlign(600) === 5).assertTrue();
      expect(FormThemeAccessController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormThemeAccessController_011', 0, () => {
      expect(FormThemeAccessController.getStringIndex('', '') === -1).assertTrue();
      expect(FormThemeAccessController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormThemeAccessController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormThemeAccessController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormThemeAccessController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormThemeAccessController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormThemeAccessController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormThemeAccessController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormThemeAccessController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormThemeAccessController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormThemeAccessController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormThemeAccessController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormThemeAccessController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormThemeAccessController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormThemeAccessController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormThemeAccessController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormThemeAccessController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormThemeAccessController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormThemeAccessController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormThemeAccessController_012', 0, () => {
      expect(FormThemeAccessController.checkArr([]) === false).assertTrue();
      expect(FormThemeAccessController.checkArr(null) === false).assertTrue();
      expect(FormThemeAccessController.checkArr(undefined) === false).assertTrue();
      expect(FormThemeAccessController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormThemeAccessController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormThemeAccessController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormThemeAccessController.checkArr(['a', '']) === false).assertTrue();
      expect(FormThemeAccessController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormThemeAccessController.checkArr(['a', null]) === false).assertTrue();
      expect(FormThemeAccessController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormThemeAccessController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormThemeAccessController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormThemeAccessController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormThemeAccessController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormThemeAccessController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormThemeAccessController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormThemeAccessController.getUUID().length > 0).assertTrue();
    })

    it('FormThemeAccessController_013', 0, () => {
      expect(FormThemeAccessController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormThemeAccessController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormThemeAccessController_014', 0, () => {
      expect(FormThemeAccessController.getBinaryData(null, '') === '').assertTrue();
      expect(FormThemeAccessController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormThemeAccessController.getBinaryData(2, null) === '').assertTrue();
      expect(FormThemeAccessController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormThemeAccessController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormThemeAccessController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormThemeAccessController.getBinaryData(0, '') === '').assertTrue();
      expect(FormThemeAccessController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormThemeAccessController_015', 0, () => {
      expect(FormThemeAccessController.getArraySum(null, []) === -1).assertTrue();
      expect(FormThemeAccessController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormThemeAccessController.getArraySum([], null) === -1).assertTrue();
      expect(FormThemeAccessController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormThemeAccessController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormThemeAccessController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormThemeAccessController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormThemeAccessController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormThemeAccessController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormThemeAccessController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormThemeAccessController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormThemeAccessController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormThemeAccessController_016', 0, () => {
      expect(FormThemeAccessController.isEmpty(null)).assertTrue();
      expect(FormThemeAccessController.isEmpty(undefined)).assertTrue();
      expect(FormThemeAccessController.isEmpty('')).assertTrue();
      expect(FormThemeAccessController.isEmpty(0)).assertTrue();
      expect(FormThemeAccessController.isEmpty([])).assertTrue();
      expect(FormThemeAccessController.isEmpty(1, null)).assertTrue();
      expect(FormThemeAccessController.isEmpty(1, undefined)).assertTrue();
      expect(FormThemeAccessController.isEmpty(1, true)).assertTrue();
      expect(FormThemeAccessController.isEmpty(1, false)).assertFalse();
    })

    it('FormThemeAccessController_017', 0, () => {
      expect(FormThemeAccessController.equals(null, 'a')).assertFalse();
      expect(FormThemeAccessController.equals(undefined, 'a')).assertFalse();
      expect(FormThemeAccessController.equals('a', null)).assertFalse();
      expect(FormThemeAccessController.equals('a', undefined)).assertFalse();
      expect(FormThemeAccessController.equals('a', 1)).assertFalse();
      expect(FormThemeAccessController.equals(1, 'a')).assertFalse();
      expect(FormThemeAccessController.equals(1, [])).assertFalse();
      expect(FormThemeAccessController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormThemeAccessController.equals([], m)).assertFalse();
      expect(FormThemeAccessController.equals(m, [])).assertFalse();
      expect(FormThemeAccessController.equals([1,2], [])).assertFalse();
      expect(FormThemeAccessController.equals([], [1, 2])).assertFalse();
      expect(FormThemeAccessController.equals([1], [1, 2])).assertFalse();
      expect(FormThemeAccessController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormThemeAccessController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormThemeAccessController.equals(2, 2)).assertTrue();
    })
  });
}