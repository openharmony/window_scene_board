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
import { FormModelController } from '../../../../../../../main/ets/default/common/components/form/useless/FormModelController';

export function FormModelControllerTest() {
  describe('FormModelControllerTest', () => {
    it('FormModelController_001', 0, () => {
      expect(FormModelController.getSum("", '1') === -1).assertEqual(true);
      expect(FormModelController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormModelController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormModelController.getSum('1', '') === -1).assertEqual(true);
      expect(FormModelController.getSum('1', null) === -1).assertEqual(true);
      expect(FormModelController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormModelController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormModelController_002', 0, () => {
      expect(FormModelController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormModelController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormModelController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormModelController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormModelController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormModelController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormModelController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormModelController_003', 0, () => {
      expect(FormModelController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormModelController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormModelController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormModelController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormModelController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormModelController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormModelController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormModelController_004', 0, () => {
      expect(FormModelController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormModelController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormModelController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormModelController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormModelController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormModelController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormModelController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormModelController_005', 0, () => {
      expect(FormModelController.isNumber("")).assertFalse();
      expect(FormModelController.isNumber(null)).assertFalse();
      expect(FormModelController.isNumber(undefined)).assertFalse();
      expect(FormModelController.isNumber("abc")).assertFalse();
      expect(FormModelController.isNumber("123")).assertTrue();
    });

    it('FormModelController_006', 0, () => {
      expect(FormModelController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormModelController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormModelController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormModelController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormModelController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormModelController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormModelController_007', 0, () => {
      expect(FormModelController.getDefaultId(null) === null).assertTrue();
      expect(FormModelController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormModelController.getDefaultId('') === '').assertTrue();
      expect(FormModelController.getDefaultId('default') !== '').assertTrue();
      expect(FormModelController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormModelController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormModelController_008', 0, () => {
      expect(FormModelController.getIndexByString("", []) === -1).assertTrue();
      expect(FormModelController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormModelController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormModelController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormModelController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormModelController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormModelController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormModelController_009', 0, () => {
      expect(FormModelController.drawFontWidth() === -1).assertTrue();
      expect(FormModelController.drawFontWidth(100) === 1).assertTrue();
      expect(FormModelController.drawFontWidth(200) === 2).assertTrue();
      expect(FormModelController.drawFontWidth(300) === 3).assertTrue();
      expect(FormModelController.drawFontWidth(400) === 4).assertTrue();
      expect(FormModelController.drawFontWidth(500) === 6).assertTrue();
      expect(FormModelController.drawFontWidth(600) === 7).assertTrue();
      expect(FormModelController.drawFontWidth(700) === 8).assertTrue();
      expect(FormModelController.drawFontWidth(800) === 9).assertTrue();
      expect(FormModelController.drawFontWidth(900) === 1).assertTrue();
      expect(FormModelController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormModelController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormModelController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormModelController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormModelController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormModelController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormModelController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormModelController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormModelController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormModelController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormModelController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormModelController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormModelController_010', 0, () => {
      expect(FormModelController.drawTextAlign() === -1).assertTrue();
      expect(FormModelController.drawTextAlign(100) === 0).assertTrue();
      expect(FormModelController.drawTextAlign(200) === 1).assertTrue();
      expect(FormModelController.drawTextAlign(300) === 2).assertTrue();
      expect(FormModelController.drawTextAlign(400) === 3).assertTrue();
      expect(FormModelController.drawTextAlign(500) === 4).assertTrue();
      expect(FormModelController.drawTextAlign(600) === 5).assertTrue();
      expect(FormModelController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormModelController_011', 0, () => {
      expect(FormModelController.getStringIndex('', '') === -1).assertTrue();
      expect(FormModelController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormModelController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormModelController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormModelController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormModelController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormModelController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormModelController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormModelController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormModelController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormModelController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormModelController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormModelController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormModelController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormModelController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormModelController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormModelController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormModelController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormModelController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormModelController_012', 0, () => {
      expect(FormModelController.checkArr([]) === false).assertTrue();
      expect(FormModelController.checkArr(null) === false).assertTrue();
      expect(FormModelController.checkArr(undefined) === false).assertTrue();
      expect(FormModelController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormModelController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormModelController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormModelController.checkArr(['a', '']) === false).assertTrue();
      expect(FormModelController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormModelController.checkArr(['a', null]) === false).assertTrue();
      expect(FormModelController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormModelController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormModelController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormModelController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormModelController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormModelController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormModelController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormModelController.getUUID().length > 0).assertTrue();
    })

    it('FormModelController_013', 0, () => {
      expect(FormModelController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormModelController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormModelController_014', 0, () => {
      expect(FormModelController.getBinaryData(null, '') === '').assertTrue();
      expect(FormModelController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormModelController.getBinaryData(2, null) === '').assertTrue();
      expect(FormModelController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormModelController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormModelController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormModelController.getBinaryData(0, '') === '').assertTrue();
      expect(FormModelController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormModelController_015', 0, () => {
      expect(FormModelController.getArraySum(null, []) === -1).assertTrue();
      expect(FormModelController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormModelController.getArraySum([], null) === -1).assertTrue();
      expect(FormModelController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormModelController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormModelController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormModelController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormModelController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormModelController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormModelController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormModelController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormModelController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormModelController_016', 0, () => {
      expect(FormModelController.isEmpty(null)).assertTrue();
      expect(FormModelController.isEmpty(undefined)).assertTrue();
      expect(FormModelController.isEmpty('')).assertTrue();
      expect(FormModelController.isEmpty(0)).assertTrue();
      expect(FormModelController.isEmpty([])).assertTrue();
      expect(FormModelController.isEmpty(1, null)).assertTrue();
      expect(FormModelController.isEmpty(1, undefined)).assertTrue();
      expect(FormModelController.isEmpty(1, true)).assertTrue();
      expect(FormModelController.isEmpty(1, false)).assertFalse();
    })

    it('FormModelController_017', 0, () => {
      expect(FormModelController.equals(null, 'a')).assertFalse();
      expect(FormModelController.equals(undefined, 'a')).assertFalse();
      expect(FormModelController.equals('a', null)).assertFalse();
      expect(FormModelController.equals('a', undefined)).assertFalse();
      expect(FormModelController.equals('a', 1)).assertFalse();
      expect(FormModelController.equals(1, 'a')).assertFalse();
      expect(FormModelController.equals(1, [])).assertFalse();
      expect(FormModelController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormModelController.equals([], m)).assertFalse();
      expect(FormModelController.equals(m, [])).assertFalse();
      expect(FormModelController.equals([1,2], [])).assertFalse();
      expect(FormModelController.equals([], [1, 2])).assertFalse();
      expect(FormModelController.equals([1], [1, 2])).assertFalse();
      expect(FormModelController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormModelController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormModelController.equals(2, 2)).assertTrue();
    })
  });
}