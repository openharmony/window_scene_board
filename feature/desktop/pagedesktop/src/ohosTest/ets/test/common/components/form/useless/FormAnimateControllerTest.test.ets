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
import { FormAnimateController } from '../../../../../../../main/ets/default/common/components/form/useless/FormAnimateController';

export function FormAnimateControllerTest() {
  describe('FormAnimateControllerTest', () => {
    it('FormAnimateController_001', 0, () => {
      expect(FormAnimateController.getSum("", '1') === -1).assertEqual(true);
      expect(FormAnimateController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormAnimateController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormAnimateController.getSum('1', '') === -1).assertEqual(true);
      expect(FormAnimateController.getSum('1', null) === -1).assertEqual(true);
      expect(FormAnimateController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormAnimateController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAnimateController_002', 0, () => {
      expect(FormAnimateController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormAnimateController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormAnimateController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormAnimateController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormAnimateController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormAnimateController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormAnimateController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAnimateController_003', 0, () => {
      expect(FormAnimateController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormAnimateController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormAnimateController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormAnimateController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormAnimateController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormAnimateController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormAnimateController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAnimateController_004', 0, () => {
      expect(FormAnimateController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormAnimateController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormAnimateController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormAnimateController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormAnimateController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormAnimateController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormAnimateController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAnimateController_005', 0, () => {
      expect(FormAnimateController.isNumber("")).assertFalse();
      expect(FormAnimateController.isNumber(null)).assertFalse();
      expect(FormAnimateController.isNumber(undefined)).assertFalse();
      expect(FormAnimateController.isNumber("abc")).assertFalse();
      expect(FormAnimateController.isNumber("123")).assertTrue();
    });

    it('FormAnimateController_006', 0, () => {
      expect(FormAnimateController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormAnimateController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormAnimateController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormAnimateController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormAnimateController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormAnimateController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAnimateController_007', 0, () => {
      expect(FormAnimateController.getDefaultId(null) === null).assertTrue();
      expect(FormAnimateController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormAnimateController.getDefaultId('') === '').assertTrue();
      expect(FormAnimateController.getDefaultId('default') !== '').assertTrue();
      expect(FormAnimateController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormAnimateController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAnimateController_008', 0, () => {
      expect(FormAnimateController.getIndexByString("", []) === -1).assertTrue();
      expect(FormAnimateController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormAnimateController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormAnimateController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormAnimateController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormAnimateController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormAnimateController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAnimateController_009', 0, () => {
      expect(FormAnimateController.drawFontWidth() === -1).assertTrue();
      expect(FormAnimateController.drawFontWidth(100) === 1).assertTrue();
      expect(FormAnimateController.drawFontWidth(200) === 2).assertTrue();
      expect(FormAnimateController.drawFontWidth(300) === 3).assertTrue();
      expect(FormAnimateController.drawFontWidth(400) === 4).assertTrue();
      expect(FormAnimateController.drawFontWidth(500) === 6).assertTrue();
      expect(FormAnimateController.drawFontWidth(600) === 7).assertTrue();
      expect(FormAnimateController.drawFontWidth(700) === 8).assertTrue();
      expect(FormAnimateController.drawFontWidth(800) === 9).assertTrue();
      expect(FormAnimateController.drawFontWidth(900) === 1).assertTrue();
      expect(FormAnimateController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormAnimateController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormAnimateController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormAnimateController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormAnimateController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormAnimateController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormAnimateController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormAnimateController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormAnimateController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormAnimateController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormAnimateController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormAnimateController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAnimateController_010', 0, () => {
      expect(FormAnimateController.drawTextAlign() === -1).assertTrue();
      expect(FormAnimateController.drawTextAlign(100) === 0).assertTrue();
      expect(FormAnimateController.drawTextAlign(200) === 1).assertTrue();
      expect(FormAnimateController.drawTextAlign(300) === 2).assertTrue();
      expect(FormAnimateController.drawTextAlign(400) === 3).assertTrue();
      expect(FormAnimateController.drawTextAlign(500) === 4).assertTrue();
      expect(FormAnimateController.drawTextAlign(600) === 5).assertTrue();
      expect(FormAnimateController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAnimateController_011', 0, () => {
      expect(FormAnimateController.getStringIndex('', '') === -1).assertTrue();
      expect(FormAnimateController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormAnimateController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormAnimateController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormAnimateController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormAnimateController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormAnimateController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormAnimateController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormAnimateController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormAnimateController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormAnimateController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormAnimateController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormAnimateController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormAnimateController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormAnimateController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormAnimateController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormAnimateController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormAnimateController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormAnimateController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAnimateController_012', 0, () => {
      expect(FormAnimateController.checkArr([]) === false).assertTrue();
      expect(FormAnimateController.checkArr(null) === false).assertTrue();
      expect(FormAnimateController.checkArr(undefined) === false).assertTrue();
      expect(FormAnimateController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormAnimateController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormAnimateController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormAnimateController.checkArr(['a', '']) === false).assertTrue();
      expect(FormAnimateController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormAnimateController.checkArr(['a', null]) === false).assertTrue();
      expect(FormAnimateController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormAnimateController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormAnimateController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormAnimateController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormAnimateController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormAnimateController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormAnimateController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormAnimateController.getUUID().length > 0).assertTrue();
    })

    it('FormAnimateController_013', 0, () => {
      expect(FormAnimateController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormAnimateController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAnimateController_014', 0, () => {
      expect(FormAnimateController.getBinaryData(null, '') === '').assertTrue();
      expect(FormAnimateController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormAnimateController.getBinaryData(2, null) === '').assertTrue();
      expect(FormAnimateController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormAnimateController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormAnimateController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormAnimateController.getBinaryData(0, '') === '').assertTrue();
      expect(FormAnimateController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAnimateController_015', 0, () => {
      expect(FormAnimateController.getArraySum(null, []) === -1).assertTrue();
      expect(FormAnimateController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormAnimateController.getArraySum([], null) === -1).assertTrue();
      expect(FormAnimateController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormAnimateController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormAnimateController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormAnimateController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormAnimateController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormAnimateController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormAnimateController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormAnimateController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormAnimateController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAnimateController_016', 0, () => {
      expect(FormAnimateController.isEmpty(null)).assertTrue();
      expect(FormAnimateController.isEmpty(undefined)).assertTrue();
      expect(FormAnimateController.isEmpty('')).assertTrue();
      expect(FormAnimateController.isEmpty(0)).assertTrue();
      expect(FormAnimateController.isEmpty([])).assertTrue();
      expect(FormAnimateController.isEmpty(1, null)).assertTrue();
      expect(FormAnimateController.isEmpty(1, undefined)).assertTrue();
      expect(FormAnimateController.isEmpty(1, true)).assertTrue();
      expect(FormAnimateController.isEmpty(1, false)).assertFalse();
    })

    it('FormAnimateController_017', 0, () => {
      expect(FormAnimateController.equals(null, 'a')).assertFalse();
      expect(FormAnimateController.equals(undefined, 'a')).assertFalse();
      expect(FormAnimateController.equals('a', null)).assertFalse();
      expect(FormAnimateController.equals('a', undefined)).assertFalse();
      expect(FormAnimateController.equals('a', 1)).assertFalse();
      expect(FormAnimateController.equals(1, 'a')).assertFalse();
      expect(FormAnimateController.equals(1, [])).assertFalse();
      expect(FormAnimateController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormAnimateController.equals([], m)).assertFalse();
      expect(FormAnimateController.equals(m, [])).assertFalse();
      expect(FormAnimateController.equals([1,2], [])).assertFalse();
      expect(FormAnimateController.equals([], [1, 2])).assertFalse();
      expect(FormAnimateController.equals([1], [1, 2])).assertFalse();
      expect(FormAnimateController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormAnimateController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormAnimateController.equals(2, 2)).assertTrue();
    })
  });
}