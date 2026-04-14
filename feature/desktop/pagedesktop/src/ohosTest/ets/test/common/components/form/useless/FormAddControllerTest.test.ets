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
import { FormAddController } from '../../../../../../../main/ets/default/common/components/form/useless/FormAddController';

export function FormAddControllerTest() {
  describe('FormAddControllerTest', () => {
    it('FormAddController_001', 0, () => {
      expect(FormAddController.getSum("", '1') === -1).assertEqual(true);
      expect(FormAddController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormAddController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormAddController.getSum('1', '') === -1).assertEqual(true);
      expect(FormAddController.getSum('1', null) === -1).assertEqual(true);
      expect(FormAddController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormAddController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAddController_002', 0, () => {
      expect(FormAddController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormAddController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormAddController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormAddController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormAddController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormAddController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormAddController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAddController_003', 0, () => {
      expect(FormAddController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormAddController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormAddController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormAddController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormAddController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormAddController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormAddController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAddController_004', 0, () => {
      expect(FormAddController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormAddController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormAddController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormAddController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormAddController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormAddController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormAddController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAddController_005', 0, () => {
      expect(FormAddController.isNumber("")).assertFalse();
      expect(FormAddController.isNumber(null)).assertFalse();
      expect(FormAddController.isNumber(undefined)).assertFalse();
      expect(FormAddController.isNumber("abc")).assertFalse();
      expect(FormAddController.isNumber("123")).assertTrue();
    });

    it('FormAddController_006', 0, () => {
      expect(FormAddController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormAddController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormAddController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormAddController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormAddController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormAddController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAddController_007', 0, () => {
      expect(FormAddController.getDefaultId(null) === null).assertTrue();
      expect(FormAddController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormAddController.getDefaultId('') === '').assertTrue();
      expect(FormAddController.getDefaultId('default') !== '').assertTrue();
      expect(FormAddController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormAddController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAddController_008', 0, () => {
      expect(FormAddController.getIndexByString("", []) === -1).assertTrue();
      expect(FormAddController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormAddController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormAddController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormAddController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormAddController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormAddController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAddController_009', 0, () => {
      expect(FormAddController.drawFontWidth() === -1).assertTrue();
      expect(FormAddController.drawFontWidth(100) === 1).assertTrue();
      expect(FormAddController.drawFontWidth(200) === 2).assertTrue();
      expect(FormAddController.drawFontWidth(300) === 3).assertTrue();
      expect(FormAddController.drawFontWidth(400) === 4).assertTrue();
      expect(FormAddController.drawFontWidth(500) === 6).assertTrue();
      expect(FormAddController.drawFontWidth(600) === 7).assertTrue();
      expect(FormAddController.drawFontWidth(700) === 8).assertTrue();
      expect(FormAddController.drawFontWidth(800) === 9).assertTrue();
      expect(FormAddController.drawFontWidth(900) === 1).assertTrue();
      expect(FormAddController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormAddController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormAddController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormAddController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormAddController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormAddController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormAddController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormAddController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormAddController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormAddController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormAddController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormAddController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAddController_010', 0, () => {
      expect(FormAddController.drawTextAlign() === -1).assertTrue();
      expect(FormAddController.drawTextAlign(100) === 0).assertTrue();
      expect(FormAddController.drawTextAlign(200) === 1).assertTrue();
      expect(FormAddController.drawTextAlign(300) === 2).assertTrue();
      expect(FormAddController.drawTextAlign(400) === 3).assertTrue();
      expect(FormAddController.drawTextAlign(500) === 4).assertTrue();
      expect(FormAddController.drawTextAlign(600) === 5).assertTrue();
      expect(FormAddController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAddController_011', 0, () => {
      expect(FormAddController.getStringIndex('', '') === -1).assertTrue();
      expect(FormAddController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormAddController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormAddController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormAddController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormAddController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormAddController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormAddController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormAddController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormAddController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormAddController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormAddController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormAddController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormAddController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormAddController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormAddController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormAddController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormAddController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormAddController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAddController_012', 0, () => {
      expect(FormAddController.checkArr([]) === false).assertTrue();
      expect(FormAddController.checkArr(null) === false).assertTrue();
      expect(FormAddController.checkArr(undefined) === false).assertTrue();
      expect(FormAddController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormAddController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormAddController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormAddController.checkArr(['a', '']) === false).assertTrue();
      expect(FormAddController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormAddController.checkArr(['a', null]) === false).assertTrue();
      expect(FormAddController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormAddController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormAddController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormAddController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormAddController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormAddController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormAddController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormAddController.getUUID().length > 0).assertTrue();
    })

    it('FormAddController_013', 0, () => {
      expect(FormAddController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormAddController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAddController_014', 0, () => {
      expect(FormAddController.getBinaryData(null, '') === '').assertTrue();
      expect(FormAddController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormAddController.getBinaryData(2, null) === '').assertTrue();
      expect(FormAddController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormAddController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormAddController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormAddController.getBinaryData(0, '') === '').assertTrue();
      expect(FormAddController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAddController_015', 0, () => {
      expect(FormAddController.getArraySum(null, []) === -1).assertTrue();
      expect(FormAddController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormAddController.getArraySum([], null) === -1).assertTrue();
      expect(FormAddController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormAddController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormAddController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormAddController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormAddController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormAddController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormAddController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormAddController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormAddController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAddController_016', 0, () => {
      expect(FormAddController.isEmpty(null)).assertTrue();
      expect(FormAddController.isEmpty(undefined)).assertTrue();
      expect(FormAddController.isEmpty('')).assertTrue();
      expect(FormAddController.isEmpty(0)).assertTrue();
      expect(FormAddController.isEmpty([])).assertTrue();
      expect(FormAddController.isEmpty(1, null)).assertTrue();
      expect(FormAddController.isEmpty(1, undefined)).assertTrue();
      expect(FormAddController.isEmpty(1, true)).assertTrue();
      expect(FormAddController.isEmpty(1, false)).assertFalse();
    })

    it('FormAddController_017', 0, () => {
      expect(FormAddController.equals(null, 'a')).assertFalse();
      expect(FormAddController.equals(undefined, 'a')).assertFalse();
      expect(FormAddController.equals('a', null)).assertFalse();
      expect(FormAddController.equals('a', undefined)).assertFalse();
      expect(FormAddController.equals('a', 1)).assertFalse();
      expect(FormAddController.equals(1, 'a')).assertFalse();
      expect(FormAddController.equals(1, [])).assertFalse();
      expect(FormAddController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormAddController.equals([], m)).assertFalse();
      expect(FormAddController.equals(m, [])).assertFalse();
      expect(FormAddController.equals([1,2], [])).assertFalse();
      expect(FormAddController.equals([], [1, 2])).assertFalse();
      expect(FormAddController.equals([1], [1, 2])).assertFalse();
      expect(FormAddController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormAddController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormAddController.equals(2, 2)).assertTrue();
    })
  });
}