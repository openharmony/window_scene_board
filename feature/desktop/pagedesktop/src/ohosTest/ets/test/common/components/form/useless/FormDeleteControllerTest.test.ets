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
import { FormDeleteController } from '../../../../../../../main/ets/default/common/components/form/useless/FormDeleteController';

export function FormDeleteControllerTest() {
  describe('FormDeleteControllerTest', () => {
    it('FormDeleteController_001', 0, () => {
      expect(FormDeleteController.getSum("", '1') === -1).assertEqual(true);
      expect(FormDeleteController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormDeleteController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormDeleteController.getSum('1', '') === -1).assertEqual(true);
      expect(FormDeleteController.getSum('1', null) === -1).assertEqual(true);
      expect(FormDeleteController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormDeleteController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormDeleteController_002', 0, () => {
      expect(FormDeleteController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormDeleteController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormDeleteController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormDeleteController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormDeleteController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormDeleteController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormDeleteController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormDeleteController_003', 0, () => {
      expect(FormDeleteController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormDeleteController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormDeleteController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormDeleteController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormDeleteController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormDeleteController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormDeleteController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormDeleteController_004', 0, () => {
      expect(FormDeleteController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormDeleteController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormDeleteController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormDeleteController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormDeleteController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormDeleteController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormDeleteController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormDeleteController_005', 0, () => {
      expect(FormDeleteController.isNumber("")).assertFalse();
      expect(FormDeleteController.isNumber(null)).assertFalse();
      expect(FormDeleteController.isNumber(undefined)).assertFalse();
      expect(FormDeleteController.isNumber("abc")).assertFalse();
      expect(FormDeleteController.isNumber("123")).assertTrue();
    });

    it('FormDeleteController_006', 0, () => {
      expect(FormDeleteController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormDeleteController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormDeleteController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormDeleteController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormDeleteController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormDeleteController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormDeleteController_007', 0, () => {
      expect(FormDeleteController.getDefaultId(null) === null).assertTrue();
      expect(FormDeleteController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormDeleteController.getDefaultId('') === '').assertTrue();
      expect(FormDeleteController.getDefaultId('default') !== '').assertTrue();
      expect(FormDeleteController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormDeleteController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormDeleteController_008', 0, () => {
      expect(FormDeleteController.getIndexByString("", []) === -1).assertTrue();
      expect(FormDeleteController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormDeleteController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormDeleteController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormDeleteController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormDeleteController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormDeleteController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormDeleteController_009', 0, () => {
      expect(FormDeleteController.drawFontWidth() === -1).assertTrue();
      expect(FormDeleteController.drawFontWidth(100) === 1).assertTrue();
      expect(FormDeleteController.drawFontWidth(200) === 2).assertTrue();
      expect(FormDeleteController.drawFontWidth(300) === 3).assertTrue();
      expect(FormDeleteController.drawFontWidth(400) === 4).assertTrue();
      expect(FormDeleteController.drawFontWidth(500) === 6).assertTrue();
      expect(FormDeleteController.drawFontWidth(600) === 7).assertTrue();
      expect(FormDeleteController.drawFontWidth(700) === 8).assertTrue();
      expect(FormDeleteController.drawFontWidth(800) === 9).assertTrue();
      expect(FormDeleteController.drawFontWidth(900) === 1).assertTrue();
      expect(FormDeleteController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormDeleteController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormDeleteController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormDeleteController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormDeleteController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormDeleteController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormDeleteController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormDeleteController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormDeleteController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormDeleteController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormDeleteController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormDeleteController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormDeleteController_010', 0, () => {
      expect(FormDeleteController.drawTextAlign() === -1).assertTrue();
      expect(FormDeleteController.drawTextAlign(100) === 0).assertTrue();
      expect(FormDeleteController.drawTextAlign(200) === 1).assertTrue();
      expect(FormDeleteController.drawTextAlign(300) === 2).assertTrue();
      expect(FormDeleteController.drawTextAlign(400) === 3).assertTrue();
      expect(FormDeleteController.drawTextAlign(500) === 4).assertTrue();
      expect(FormDeleteController.drawTextAlign(600) === 5).assertTrue();
      expect(FormDeleteController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormDeleteController_011', 0, () => {
      expect(FormDeleteController.getStringIndex('', '') === -1).assertTrue();
      expect(FormDeleteController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormDeleteController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormDeleteController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormDeleteController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormDeleteController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormDeleteController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormDeleteController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormDeleteController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormDeleteController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormDeleteController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormDeleteController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormDeleteController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormDeleteController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormDeleteController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormDeleteController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormDeleteController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormDeleteController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormDeleteController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormDeleteController_012', 0, () => {
      expect(FormDeleteController.checkArr([]) === false).assertTrue();
      expect(FormDeleteController.checkArr(null) === false).assertTrue();
      expect(FormDeleteController.checkArr(undefined) === false).assertTrue();
      expect(FormDeleteController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormDeleteController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormDeleteController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormDeleteController.checkArr(['a', '']) === false).assertTrue();
      expect(FormDeleteController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormDeleteController.checkArr(['a', null]) === false).assertTrue();
      expect(FormDeleteController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormDeleteController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormDeleteController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormDeleteController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormDeleteController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormDeleteController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormDeleteController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormDeleteController.getUUID().length > 0).assertTrue();
    })

    it('FormDeleteController_013', 0, () => {
      expect(FormDeleteController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormDeleteController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormDeleteController_014', 0, () => {
      expect(FormDeleteController.getBinaryData(null, '') === '').assertTrue();
      expect(FormDeleteController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormDeleteController.getBinaryData(2, null) === '').assertTrue();
      expect(FormDeleteController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormDeleteController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormDeleteController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormDeleteController.getBinaryData(0, '') === '').assertTrue();
      expect(FormDeleteController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormDeleteController_015', 0, () => {
      expect(FormDeleteController.getArraySum(null, []) === -1).assertTrue();
      expect(FormDeleteController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormDeleteController.getArraySum([], null) === -1).assertTrue();
      expect(FormDeleteController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormDeleteController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormDeleteController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormDeleteController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormDeleteController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormDeleteController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormDeleteController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormDeleteController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormDeleteController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormDeleteController_016', 0, () => {
      expect(FormDeleteController.isEmpty(null)).assertTrue();
      expect(FormDeleteController.isEmpty(undefined)).assertTrue();
      expect(FormDeleteController.isEmpty('')).assertTrue();
      expect(FormDeleteController.isEmpty(0)).assertTrue();
      expect(FormDeleteController.isEmpty([])).assertTrue();
      expect(FormDeleteController.isEmpty(1, null)).assertTrue();
      expect(FormDeleteController.isEmpty(1, undefined)).assertTrue();
      expect(FormDeleteController.isEmpty(1, true)).assertTrue();
      expect(FormDeleteController.isEmpty(1, false)).assertFalse();
    })

    it('FormDeleteController_017', 0, () => {
      expect(FormDeleteController.equals(null, 'a')).assertFalse();
      expect(FormDeleteController.equals(undefined, 'a')).assertFalse();
      expect(FormDeleteController.equals('a', null)).assertFalse();
      expect(FormDeleteController.equals('a', undefined)).assertFalse();
      expect(FormDeleteController.equals('a', 1)).assertFalse();
      expect(FormDeleteController.equals(1, 'a')).assertFalse();
      expect(FormDeleteController.equals(1, [])).assertFalse();
      expect(FormDeleteController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormDeleteController.equals([], m)).assertFalse();
      expect(FormDeleteController.equals(m, [])).assertFalse();
      expect(FormDeleteController.equals([1,2], [])).assertFalse();
      expect(FormDeleteController.equals([], [1, 2])).assertFalse();
      expect(FormDeleteController.equals([1], [1, 2])).assertFalse();
      expect(FormDeleteController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormDeleteController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormDeleteController.equals(2, 2)).assertTrue();
    })
  });
}