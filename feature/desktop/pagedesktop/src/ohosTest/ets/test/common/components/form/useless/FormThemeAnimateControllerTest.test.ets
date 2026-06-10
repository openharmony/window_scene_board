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
import { FormThemeAnimateController } from '../../../../../../../main/ets/default/common/components/form/useless/FormThemeAnimateController';

export function FormThemeAnimateControllerTest() {
  describe('FormThemeAnimateControllerTest', () => {
    it('FormThemeAnimateController_001', 0, () => {
      expect(FormThemeAnimateController.getSum("", '1') === -1).assertEqual(true);
      expect(FormThemeAnimateController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormThemeAnimateController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormThemeAnimateController.getSum('1', '') === -1).assertEqual(true);
      expect(FormThemeAnimateController.getSum('1', null) === -1).assertEqual(true);
      expect(FormThemeAnimateController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormThemeAnimateController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormThemeAnimateController_002', 0, () => {
      expect(FormThemeAnimateController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormThemeAnimateController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormThemeAnimateController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAnimateController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormThemeAnimateController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAnimateController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormThemeAnimateController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormThemeAnimateController_003', 0, () => {
      expect(FormThemeAnimateController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormThemeAnimateController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAnimateController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAnimateController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAnimateController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAnimateController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormThemeAnimateController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormThemeAnimateController_004', 0, () => {
      expect(FormThemeAnimateController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormThemeAnimateController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormThemeAnimateController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormThemeAnimateController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormThemeAnimateController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormThemeAnimateController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormThemeAnimateController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormThemeAnimateController_005', 0, () => {
      expect(FormThemeAnimateController.isNumber("")).assertFalse();
      expect(FormThemeAnimateController.isNumber(null)).assertFalse();
      expect(FormThemeAnimateController.isNumber(undefined)).assertFalse();
      expect(FormThemeAnimateController.isNumber("abc")).assertFalse();
      expect(FormThemeAnimateController.isNumber("123")).assertTrue();
    });

    it('FormThemeAnimateController_006', 0, () => {
      expect(FormThemeAnimateController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormThemeAnimateController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormThemeAnimateController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormThemeAnimateController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormThemeAnimateController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormThemeAnimateController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormThemeAnimateController_007', 0, () => {
      expect(FormThemeAnimateController.getDefaultId(null) === null).assertTrue();
      expect(FormThemeAnimateController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormThemeAnimateController.getDefaultId('') === '').assertTrue();
      expect(FormThemeAnimateController.getDefaultId('default') !== '').assertTrue();
      expect(FormThemeAnimateController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormThemeAnimateController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormThemeAnimateController_008', 0, () => {
      expect(FormThemeAnimateController.getIndexByString("", []) === -1).assertTrue();
      expect(FormThemeAnimateController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormThemeAnimateController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormThemeAnimateController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormThemeAnimateController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormThemeAnimateController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormThemeAnimateController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormThemeAnimateController_009', 0, () => {
      expect(FormThemeAnimateController.drawFontWidth() === -1).assertTrue();
      expect(FormThemeAnimateController.drawFontWidth(100) === 1).assertTrue();
      expect(FormThemeAnimateController.drawFontWidth(200) === 2).assertTrue();
      expect(FormThemeAnimateController.drawFontWidth(300) === 3).assertTrue();
      expect(FormThemeAnimateController.drawFontWidth(400) === 4).assertTrue();
      expect(FormThemeAnimateController.drawFontWidth(500) === 6).assertTrue();
      expect(FormThemeAnimateController.drawFontWidth(600) === 7).assertTrue();
      expect(FormThemeAnimateController.drawFontWidth(700) === 8).assertTrue();
      expect(FormThemeAnimateController.drawFontWidth(800) === 9).assertTrue();
      expect(FormThemeAnimateController.drawFontWidth(900) === 1).assertTrue();
      expect(FormThemeAnimateController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormThemeAnimateController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormThemeAnimateController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormThemeAnimateController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormThemeAnimateController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormThemeAnimateController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormThemeAnimateController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormThemeAnimateController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormThemeAnimateController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormThemeAnimateController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormThemeAnimateController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormThemeAnimateController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormThemeAnimateController_010', 0, () => {
      expect(FormThemeAnimateController.drawTextAlign() === -1).assertTrue();
      expect(FormThemeAnimateController.drawTextAlign(100) === 0).assertTrue();
      expect(FormThemeAnimateController.drawTextAlign(200) === 1).assertTrue();
      expect(FormThemeAnimateController.drawTextAlign(300) === 2).assertTrue();
      expect(FormThemeAnimateController.drawTextAlign(400) === 3).assertTrue();
      expect(FormThemeAnimateController.drawTextAlign(500) === 4).assertTrue();
      expect(FormThemeAnimateController.drawTextAlign(600) === 5).assertTrue();
      expect(FormThemeAnimateController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormThemeAnimateController_011', 0, () => {
      expect(FormThemeAnimateController.getStringIndex('', '') === -1).assertTrue();
      expect(FormThemeAnimateController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormThemeAnimateController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormThemeAnimateController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormThemeAnimateController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormThemeAnimateController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormThemeAnimateController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormThemeAnimateController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormThemeAnimateController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormThemeAnimateController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormThemeAnimateController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormThemeAnimateController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormThemeAnimateController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormThemeAnimateController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormThemeAnimateController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormThemeAnimateController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormThemeAnimateController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormThemeAnimateController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormThemeAnimateController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormThemeAnimateController_012', 0, () => {
      expect(FormThemeAnimateController.checkArr([]) === false).assertTrue();
      expect(FormThemeAnimateController.checkArr(null) === false).assertTrue();
      expect(FormThemeAnimateController.checkArr(undefined) === false).assertTrue();
      expect(FormThemeAnimateController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormThemeAnimateController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormThemeAnimateController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormThemeAnimateController.checkArr(['a', '']) === false).assertTrue();
      expect(FormThemeAnimateController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormThemeAnimateController.checkArr(['a', null]) === false).assertTrue();
      expect(FormThemeAnimateController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormThemeAnimateController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormThemeAnimateController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormThemeAnimateController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormThemeAnimateController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormThemeAnimateController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormThemeAnimateController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormThemeAnimateController.getUUID().length > 0).assertTrue();
    })

    it('FormThemeAnimateController_013', 0, () => {
      expect(FormThemeAnimateController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormThemeAnimateController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormThemeAnimateController_014', 0, () => {
      expect(FormThemeAnimateController.getBinaryData(null, '') === '').assertTrue();
      expect(FormThemeAnimateController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormThemeAnimateController.getBinaryData(2, null) === '').assertTrue();
      expect(FormThemeAnimateController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormThemeAnimateController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormThemeAnimateController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormThemeAnimateController.getBinaryData(0, '') === '').assertTrue();
      expect(FormThemeAnimateController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormThemeAnimateController_015', 0, () => {
      expect(FormThemeAnimateController.getArraySum(null, []) === -1).assertTrue();
      expect(FormThemeAnimateController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormThemeAnimateController.getArraySum([], null) === -1).assertTrue();
      expect(FormThemeAnimateController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormThemeAnimateController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormThemeAnimateController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormThemeAnimateController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormThemeAnimateController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormThemeAnimateController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormThemeAnimateController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormThemeAnimateController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormThemeAnimateController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormThemeAnimateController_016', 0, () => {
      expect(FormThemeAnimateController.isEmpty(null)).assertTrue();
      expect(FormThemeAnimateController.isEmpty(undefined)).assertTrue();
      expect(FormThemeAnimateController.isEmpty('')).assertTrue();
      expect(FormThemeAnimateController.isEmpty(0)).assertTrue();
      expect(FormThemeAnimateController.isEmpty([])).assertTrue();
      expect(FormThemeAnimateController.isEmpty(1, null)).assertTrue();
      expect(FormThemeAnimateController.isEmpty(1, undefined)).assertTrue();
      expect(FormThemeAnimateController.isEmpty(1, true)).assertTrue();
      expect(FormThemeAnimateController.isEmpty(1, false)).assertFalse();
    })

    it('FormThemeAnimateController_017', 0, () => {
      expect(FormThemeAnimateController.equals(null, 'a')).assertFalse();
      expect(FormThemeAnimateController.equals(undefined, 'a')).assertFalse();
      expect(FormThemeAnimateController.equals('a', null)).assertFalse();
      expect(FormThemeAnimateController.equals('a', undefined)).assertFalse();
      expect(FormThemeAnimateController.equals('a', 1)).assertFalse();
      expect(FormThemeAnimateController.equals(1, 'a')).assertFalse();
      expect(FormThemeAnimateController.equals(1, [])).assertFalse();
      expect(FormThemeAnimateController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormThemeAnimateController.equals([], m)).assertFalse();
      expect(FormThemeAnimateController.equals(m, [])).assertFalse();
      expect(FormThemeAnimateController.equals([1,2], [])).assertFalse();
      expect(FormThemeAnimateController.equals([], [1, 2])).assertFalse();
      expect(FormThemeAnimateController.equals([1], [1, 2])).assertFalse();
      expect(FormThemeAnimateController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormThemeAnimateController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormThemeAnimateController.equals(2, 2)).assertTrue();
    })
  });
}