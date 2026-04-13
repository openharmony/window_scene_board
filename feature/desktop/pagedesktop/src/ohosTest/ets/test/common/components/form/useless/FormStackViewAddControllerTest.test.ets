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
import { FormStackViewAddController } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackViewAddController';

export function FormStackViewAddControllerTest() {
  describe('FormStackViewAddControllerTest', () => {
    it('FormStackUtilPcBeta_001', 0, () => {
      expect(FormStackViewAddController.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackViewAddController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackViewAddController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackViewAddController.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackViewAddController.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackViewAddController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackViewAddController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackViewAddController_002', 0, () => {
      expect(FormStackViewAddController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackViewAddController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackViewAddController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewAddController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackViewAddController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewAddController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackViewAddController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackViewAddController_003', 0, () => {
      expect(FormStackViewAddController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackViewAddController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewAddController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewAddController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewAddController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewAddController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackViewAddController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackViewAddController_004', 0, () => {
      expect(FormStackViewAddController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackViewAddController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackViewAddController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackViewAddController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackViewAddController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackViewAddController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackViewAddController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackViewAddController_005', 0, () => {
      expect(FormStackViewAddController.isNumber("")).assertFalse();
      expect(FormStackViewAddController.isNumber(null)).assertFalse();
      expect(FormStackViewAddController.isNumber(undefined)).assertFalse();
      expect(FormStackViewAddController.isNumber("abc")).assertFalse();
      expect(FormStackViewAddController.isNumber("123")).assertTrue();
    });

    it('FormStackViewAddController_006', 0, () => {
      expect(FormStackViewAddController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackViewAddController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackViewAddController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackViewAddController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackViewAddController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackViewAddController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackViewAddController_007', 0, () => {
      expect(FormStackViewAddController.getDefaultId(null) === null).assertTrue();
      expect(FormStackViewAddController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackViewAddController.getDefaultId('') === '').assertTrue();
      expect(FormStackViewAddController.getDefaultId('default') !== '').assertTrue();
      expect(FormStackViewAddController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackViewAddController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackViewAddController_008', 0, () => {
      expect(FormStackViewAddController.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackViewAddController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackViewAddController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackViewAddController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackViewAddController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackViewAddController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackViewAddController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackViewAddController_009', 0, () => {
      expect(FormStackViewAddController.drawFontWidth() === -1).assertTrue();
      expect(FormStackViewAddController.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackViewAddController.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackViewAddController.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackViewAddController.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackViewAddController.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackViewAddController.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackViewAddController.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackViewAddController.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackViewAddController.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackViewAddController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackViewAddController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackViewAddController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackViewAddController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackViewAddController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackViewAddController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackViewAddController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackViewAddController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackViewAddController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackViewAddController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackViewAddController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackViewAddController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackViewAddController_010', 0, () => {
      expect(FormStackViewAddController.drawTextAlign() === -1).assertTrue();
      expect(FormStackViewAddController.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackViewAddController.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackViewAddController.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackViewAddController.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackViewAddController.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackViewAddController.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackViewAddController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackViewAddController_011', 0, () => {
      expect(FormStackViewAddController.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackViewAddController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackViewAddController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackViewAddController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackViewAddController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackViewAddController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackViewAddController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackViewAddController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackViewAddController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackViewAddController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackViewAddController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackViewAddController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackViewAddController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackViewAddController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackViewAddController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackViewAddController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackViewAddController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackViewAddController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackViewAddController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackViewAddController_012', 0, () => {
      expect(FormStackViewAddController.checkArr([]) === false).assertTrue();
      expect(FormStackViewAddController.checkArr(null) === false).assertTrue();
      expect(FormStackViewAddController.checkArr(undefined) === false).assertTrue();
      expect(FormStackViewAddController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackViewAddController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackViewAddController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackViewAddController.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackViewAddController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackViewAddController.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackViewAddController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackViewAddController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackViewAddController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackViewAddController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackViewAddController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackViewAddController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackViewAddController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackViewAddController.getUUID().length > 0).assertTrue();
    })

    it('FormStackViewAddController_013', 0, () => {
      expect(FormStackViewAddController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackViewAddController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackViewAddController_014', 0, () => {
      expect(FormStackViewAddController.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackViewAddController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackViewAddController.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackViewAddController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackViewAddController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackViewAddController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackViewAddController.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackViewAddController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackViewAddController_015', 0, () => {
      expect(FormStackViewAddController.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackViewAddController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackViewAddController.getArraySum([], null) === -1).assertTrue();
      expect(FormStackViewAddController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackViewAddController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackViewAddController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackViewAddController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackViewAddController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackViewAddController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackViewAddController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackViewAddController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackViewAddController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackViewAddController_016', 0, () => {
      expect(FormStackViewAddController.isEmpty(null)).assertTrue();
      expect(FormStackViewAddController.isEmpty(undefined)).assertTrue();
      expect(FormStackViewAddController.isEmpty('')).assertTrue();
      expect(FormStackViewAddController.isEmpty(0)).assertTrue();
      expect(FormStackViewAddController.isEmpty([])).assertTrue();
      expect(FormStackViewAddController.isEmpty(1, null)).assertTrue();
      expect(FormStackViewAddController.isEmpty(1, undefined)).assertTrue();
      expect(FormStackViewAddController.isEmpty(1, true)).assertTrue();
      expect(FormStackViewAddController.isEmpty(1, false)).assertFalse();
    })

    it('FormStackViewAddController_017', 0, () => {
      expect(FormStackViewAddController.equals(null, 'a')).assertFalse();
      expect(FormStackViewAddController.equals(undefined, 'a')).assertFalse();
      expect(FormStackViewAddController.equals('a', null)).assertFalse();
      expect(FormStackViewAddController.equals('a', undefined)).assertFalse();
      expect(FormStackViewAddController.equals('a', 1)).assertFalse();
      expect(FormStackViewAddController.equals(1, 'a')).assertFalse();
      expect(FormStackViewAddController.equals(1, [])).assertFalse();
      expect(FormStackViewAddController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackViewAddController.equals([], m)).assertFalse();
      expect(FormStackViewAddController.equals(m, [])).assertFalse();
      expect(FormStackViewAddController.equals([1,2], [])).assertFalse();
      expect(FormStackViewAddController.equals([], [1, 2])).assertFalse();
      expect(FormStackViewAddController.equals([1], [1, 2])).assertFalse();
      expect(FormStackViewAddController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackViewAddController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackViewAddController.equals(2, 2)).assertTrue();
    })
  });
}