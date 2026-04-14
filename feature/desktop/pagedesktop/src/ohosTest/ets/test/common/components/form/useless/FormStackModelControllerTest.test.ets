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
import { FormStackModelController } from '../../../../../../../main/ets/default/common/components/form/useless/FormStackModelController';

export function FormStackModelControllerTest() {
  describe('FormStackModelControllerTest', () => {
    it('FormStackModelController_001', 0, () => {
      expect(FormStackModelController.getSum("", '1') === -1).assertEqual(true);
      expect(FormStackModelController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormStackModelController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormStackModelController.getSum('1', '') === -1).assertEqual(true);
      expect(FormStackModelController.getSum('1', null) === -1).assertEqual(true);
      expect(FormStackModelController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormStackModelController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormStackModelController_002', 0, () => {
      expect(FormStackModelController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormStackModelController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormStackModelController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormStackModelController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormStackModelController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormStackModelController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormStackModelController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormStackModelController_003', 0, () => {
      expect(FormStackModelController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormStackModelController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormStackModelController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackModelController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormStackModelController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackModelController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormStackModelController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormStackModelController_004', 0, () => {
      expect(FormStackModelController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormStackModelController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormStackModelController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormStackModelController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormStackModelController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormStackModelController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormStackModelController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormStackModelController_005', 0, () => {
      expect(FormStackModelController.isNumber("")).assertFalse();
      expect(FormStackModelController.isNumber(null)).assertFalse();
      expect(FormStackModelController.isNumber(undefined)).assertFalse();
      expect(FormStackModelController.isNumber("abc")).assertFalse();
      expect(FormStackModelController.isNumber("123")).assertTrue();
    });

    it('FormStackModelController_006', 0, () => {
      expect(FormStackModelController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormStackModelController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormStackModelController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormStackModelController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormStackModelController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormStackModelController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormStackModelController_007', 0, () => {
      expect(FormStackModelController.getDefaultId(null) === null).assertTrue();
      expect(FormStackModelController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormStackModelController.getDefaultId('') === '').assertTrue();
      expect(FormStackModelController.getDefaultId('default') !== '').assertTrue();
      expect(FormStackModelController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormStackModelController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormStackModelController_008', 0, () => {
      expect(FormStackModelController.getIndexByString("", []) === -1).assertTrue();
      expect(FormStackModelController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormStackModelController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormStackModelController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormStackModelController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormStackModelController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormStackModelController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormStackModelController_009', 0, () => {
      expect(FormStackModelController.drawFontWidth() === -1).assertTrue();
      expect(FormStackModelController.drawFontWidth(100) === 1).assertTrue();
      expect(FormStackModelController.drawFontWidth(200) === 2).assertTrue();
      expect(FormStackModelController.drawFontWidth(300) === 3).assertTrue();
      expect(FormStackModelController.drawFontWidth(400) === 4).assertTrue();
      expect(FormStackModelController.drawFontWidth(500) === 6).assertTrue();
      expect(FormStackModelController.drawFontWidth(600) === 7).assertTrue();
      expect(FormStackModelController.drawFontWidth(700) === 8).assertTrue();
      expect(FormStackModelController.drawFontWidth(800) === 9).assertTrue();
      expect(FormStackModelController.drawFontWidth(900) === 1).assertTrue();
      expect(FormStackModelController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormStackModelController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormStackModelController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormStackModelController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormStackModelController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormStackModelController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormStackModelController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormStackModelController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormStackModelController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormStackModelController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormStackModelController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormStackModelController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormStackModelController_010', 0, () => {
      expect(FormStackModelController.drawTextAlign() === -1).assertTrue();
      expect(FormStackModelController.drawTextAlign(100) === 0).assertTrue();
      expect(FormStackModelController.drawTextAlign(200) === 1).assertTrue();
      expect(FormStackModelController.drawTextAlign(300) === 2).assertTrue();
      expect(FormStackModelController.drawTextAlign(400) === 3).assertTrue();
      expect(FormStackModelController.drawTextAlign(500) === 4).assertTrue();
      expect(FormStackModelController.drawTextAlign(600) === 5).assertTrue();
      expect(FormStackModelController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormStackModelController_011', 0, () => {
      expect(FormStackModelController.getStringIndex('', '') === -1).assertTrue();
      expect(FormStackModelController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormStackModelController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormStackModelController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormStackModelController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormStackModelController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormStackModelController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormStackModelController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormStackModelController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormStackModelController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormStackModelController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormStackModelController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormStackModelController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormStackModelController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormStackModelController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormStackModelController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormStackModelController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormStackModelController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormStackModelController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormStackModelController_012', 0, () => {
      expect(FormStackModelController.checkArr([]) === false).assertTrue();
      expect(FormStackModelController.checkArr(null) === false).assertTrue();
      expect(FormStackModelController.checkArr(undefined) === false).assertTrue();
      expect(FormStackModelController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormStackModelController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormStackModelController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormStackModelController.checkArr(['a', '']) === false).assertTrue();
      expect(FormStackModelController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormStackModelController.checkArr(['a', null]) === false).assertTrue();
      expect(FormStackModelController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormStackModelController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormStackModelController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormStackModelController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormStackModelController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormStackModelController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormStackModelController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormStackModelController.getUUID().length > 0).assertTrue();
    })

    it('FormStackModelController_013', 0, () => {
      expect(FormStackModelController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormStackModelController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormStackModelController_014', 0, () => {
      expect(FormStackModelController.getBinaryData(null, '') === '').assertTrue();
      expect(FormStackModelController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormStackModelController.getBinaryData(2, null) === '').assertTrue();
      expect(FormStackModelController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormStackModelController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormStackModelController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormStackModelController.getBinaryData(0, '') === '').assertTrue();
      expect(FormStackModelController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormStackModelController_015', 0, () => {
      expect(FormStackModelController.getArraySum(null, []) === -1).assertTrue();
      expect(FormStackModelController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormStackModelController.getArraySum([], null) === -1).assertTrue();
      expect(FormStackModelController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormStackModelController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormStackModelController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormStackModelController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormStackModelController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormStackModelController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormStackModelController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormStackModelController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormStackModelController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormStackModelController_016', 0, () => {
      expect(FormStackModelController.isEmpty(null)).assertTrue();
      expect(FormStackModelController.isEmpty(undefined)).assertTrue();
      expect(FormStackModelController.isEmpty('')).assertTrue();
      expect(FormStackModelController.isEmpty(0)).assertTrue();
      expect(FormStackModelController.isEmpty([])).assertTrue();
      expect(FormStackModelController.isEmpty(1, null)).assertTrue();
      expect(FormStackModelController.isEmpty(1, undefined)).assertTrue();
      expect(FormStackModelController.isEmpty(1, true)).assertTrue();
      expect(FormStackModelController.isEmpty(1, false)).assertFalse();
    })

    it('FormStackModelController_017', 0, () => {
      expect(FormStackModelController.equals(null, 'a')).assertFalse();
      expect(FormStackModelController.equals(undefined, 'a')).assertFalse();
      expect(FormStackModelController.equals('a', null)).assertFalse();
      expect(FormStackModelController.equals('a', undefined)).assertFalse();
      expect(FormStackModelController.equals('a', 1)).assertFalse();
      expect(FormStackModelController.equals(1, 'a')).assertFalse();
      expect(FormStackModelController.equals(1, [])).assertFalse();
      expect(FormStackModelController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormStackModelController.equals([], m)).assertFalse();
      expect(FormStackModelController.equals(m, [])).assertFalse();
      expect(FormStackModelController.equals([1,2], [])).assertFalse();
      expect(FormStackModelController.equals([], [1, 2])).assertFalse();
      expect(FormStackModelController.equals([1], [1, 2])).assertFalse();
      expect(FormStackModelController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormStackModelController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormStackModelController.equals(2, 2)).assertTrue();
    })
  });
}