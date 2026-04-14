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
import { FormAccessController } from '../../../../../../../main/ets/default/common/components/form/useless/FormAccessController';

export function FormAccessControllerTest() {
  describe('FormAccessControllerTest', () => {
    it('FormAccessController_001', 0, () => {
      expect(FormAccessController.getSum("", '1') === -1).assertEqual(true);
      expect(FormAccessController.getSum(null, '1') === -1).assertEqual(true);
      expect(FormAccessController.getSum(undefined, '1') === -1).assertEqual(true);
      expect(FormAccessController.getSum('1', '') === -1).assertEqual(true);
      expect(FormAccessController.getSum('1', null) === -1).assertEqual(true);
      expect(FormAccessController.getSum('1', undefined) === -1).assertEqual(true);
      expect(FormAccessController.getSum('1', '2') === 3).assertEqual(true);
    });

    it('FormAccessController_002', 0, () => {
      expect(FormAccessController.stringToArray("", ",").length === 0).assertTrue();
      expect(FormAccessController.stringToArray(null, ",").length === 0).assertTrue();
      expect(FormAccessController.stringToArray(undefined, ",").length === 0).assertTrue();
      expect(FormAccessController.stringToArray("abc", null).length === 0).assertTrue();
      expect(FormAccessController.stringToArray("abc", undefined).length === 0).assertTrue();
      expect(FormAccessController.stringToArray("ohos", ',').length === 0).assertTrue();
      expect(FormAccessController.stringToArray("abc , cfg", ',').length === 2).assertTrue();
    });

    it('FormAccessController_003', 0, () => {
      expect(FormAccessController.getFloatValues("", ",").length === 0).assertTrue();
      expect(FormAccessController.getFloatValues(null, ",").length === 0).assertTrue();
      expect(FormAccessController.getFloatValues(undefined, ",").length === 0).assertTrue();
      expect(FormAccessController.getFloatValues("123.1", null).length === 0).assertTrue();
      expect(FormAccessController.getFloatValues("abc", undefined).length === 0).assertTrue();
      expect(FormAccessController.getFloatValues("-123", ',') != undefined).assertTrue();
      expect(FormAccessController.getFloatValues("123 , 456", ',').length !== 0).assertTrue();
    });

    it('FormAccessController_004', 0, () => {
      expect(FormAccessController.getIntValues("", ",").length === 0).assertTrue();
      expect(FormAccessController.getIntValues(null, ",").length === 0).assertTrue();
      expect(FormAccessController.getIntValues(undefined, ",").length === 0).assertTrue();
      expect(FormAccessController.getIntValues("123.1", null).length === 0).assertTrue();
      expect(FormAccessController.getIntValues("abc", undefined).length === 0).assertTrue();
      expect(FormAccessController.getIntValues("-123", ',').length === 0).assertTrue();
      expect(FormAccessController.getIntValues("123 , 456", ',') != undefined).assertTrue();
    })

    it('FormAccessController_005', 0, () => {
      expect(FormAccessController.isNumber("")).assertFalse();
      expect(FormAccessController.isNumber(null)).assertFalse();
      expect(FormAccessController.isNumber(undefined)).assertFalse();
      expect(FormAccessController.isNumber("abc")).assertFalse();
      expect(FormAccessController.isNumber("123")).assertTrue();
    });

    it('FormAccessController_006', 0, () => {
      expect(FormAccessController.getStrByCount(null , 1) === '').assertTrue();
      expect(FormAccessController.getStrByCount('' , 1) === '').assertTrue();
      expect(FormAccessController.getStrByCount(undefined , 1) === '').assertTrue();
      expect(FormAccessController.getStrByCount('abc' , 0) === '').assertTrue();
      expect(FormAccessController.getStrByCount('abc' , 2) === 'abcabc').assertTrue();
      expect(FormAccessController.getStrByCount('abc' , 2, '-') === 'abc-abc').assertTrue();
    });

    it('FormAccessController_007', 0, () => {
      expect(FormAccessController.getDefaultId(null) === null).assertTrue();
      expect(FormAccessController.getDefaultId(undefined) === undefined).assertTrue();
      expect(FormAccessController.getDefaultId('') === '').assertTrue();
      expect(FormAccessController.getDefaultId('default') !== '').assertTrue();
      expect(FormAccessController.getDefaultId('aaa') !== '').assertTrue();
      expect(FormAccessController.getDefaultId('ohos') === '').assertTrue();
    });

    it('FormAccessController_008', 0, () => {
      expect(FormAccessController.getIndexByString("", []) === -1).assertTrue();
      expect(FormAccessController.getIndexByString(null, []) === -1).assertTrue();
      expect(FormAccessController.getIndexByString(undefined, []) === -1).assertTrue();
      expect(FormAccessController.getIndexByString('aaa', null) === -1).assertTrue();
      expect(FormAccessController.getIndexByString('aaa', undefined) === -1).assertTrue();
      expect(FormAccessController.getIndexByString('aaa', []) === -1).assertTrue();
      expect(FormAccessController.getIndexByString('aaa', ['bbb', 'aaa']) === 1).assertTrue();
    });


    it('FormAccessController_009', 0, () => {
      expect(FormAccessController.drawFontWidth() === -1).assertTrue();
      expect(FormAccessController.drawFontWidth(100) === 1).assertTrue();
      expect(FormAccessController.drawFontWidth(200) === 2).assertTrue();
      expect(FormAccessController.drawFontWidth(300) === 3).assertTrue();
      expect(FormAccessController.drawFontWidth(400) === 4).assertTrue();
      expect(FormAccessController.drawFontWidth(500) === 6).assertTrue();
      expect(FormAccessController.drawFontWidth(600) === 7).assertTrue();
      expect(FormAccessController.drawFontWidth(700) === 8).assertTrue();
      expect(FormAccessController.drawFontWidth(800) === 9).assertTrue();
      expect(FormAccessController.drawFontWidth(900) === 1).assertTrue();
      expect(FormAccessController.drawFontWidth(1000) === 5).assertTrue();
      expect(FormAccessController.drawFontWeightFormat(100) === 0).assertTrue();
      expect(FormAccessController.drawFontWeightFormat() === 3).assertTrue();
      expect(FormAccessController.drawFontWeightFormat(200) === 1).assertTrue();
      expect(FormAccessController.drawFontWeightFormat(300) === 2).assertTrue();
      expect(FormAccessController.drawFontWeightFormat(400) === 3).assertTrue();
      expect(FormAccessController.drawFontWeightFormat(500) === 4).assertTrue();
      expect(FormAccessController.drawFontWeightFormat(600) === 5).assertTrue();
      expect(FormAccessController.drawFontWeightFormat(700) === 6).assertTrue();
      expect(FormAccessController.drawFontWeightFormat(800) === 7).assertTrue();
      expect(FormAccessController.drawFontWeightFormat(900) === 8).assertTrue();
      expect(FormAccessController.drawFontWeightFormat(1000) === 3).assertTrue();
    })

    it('FormAccessController_010', 0, () => {
      expect(FormAccessController.drawTextAlign() === -1).assertTrue();
      expect(FormAccessController.drawTextAlign(100) === 0).assertTrue();
      expect(FormAccessController.drawTextAlign(200) === 1).assertTrue();
      expect(FormAccessController.drawTextAlign(300) === 2).assertTrue();
      expect(FormAccessController.drawTextAlign(400) === 3).assertTrue();
      expect(FormAccessController.drawTextAlign(500) === 4).assertTrue();
      expect(FormAccessController.drawTextAlign(600) === 5).assertTrue();
      expect(FormAccessController.drawTextAlign(700) === 100).assertTrue();
    })

    it('FormAccessController_011', 0, () => {
      expect(FormAccessController.getStringIndex('', '') === -1).assertTrue();
      expect(FormAccessController.getStringIndex(null, '') === -1).assertTrue();
      expect(FormAccessController.getStringIndex(undefined, '')=== -1).assertTrue();
      expect(FormAccessController.getStringIndex('a', '') === -1).assertTrue();
      expect(FormAccessController.getStringIndex('a', null) === -1).assertTrue();
      expect(FormAccessController.getStringIndex('a', undefined) === -1).assertTrue();
      expect(FormAccessController.getStringIndex('ohos', '') === -1).assertTrue();
      expect(FormAccessController.getStringIndex('aaa', 'ohos') === -1).assertTrue();
      expect(FormAccessController.getStringIndex('aaainside', 'aaa') === -1).assertTrue();
      expect(FormAccessController.getStringIndex('aaa', 'aaainside') === -1).assertTrue();
      expect(FormAccessController.getStringIndex('aaa', 'bbb') === -1).assertTrue();
      expect(FormAccessController.getStringIndex('aaa', 'bbbb') === -1).assertTrue();
      expect(FormAccessController.getStringIndex('ab', 'b') === -1).assertTrue();
      expect(FormAccessController.getStringIndex('bab', 'bb') === -1).assertTrue();
      expect(FormAccessController.getStringIndex('bbab', 'bbb') === -1).assertTrue();
      expect(FormAccessController.getStringIndex('aaaac', 'aaaa') === -1).assertTrue();
      expect(FormAccessController.getStringIndex('aaaacc', 'aaaac') === -1).assertTrue();
      expect(FormAccessController.getStringIndex('aaaaccc', 'aaaacc') === -1).assertTrue();
      expect(FormAccessController.getStringIndex('aaacccccc', 'aaaccc') === 0).assertTrue();
    })

    it('FormAccessController_012', 0, () => {
      expect(FormAccessController.checkArr([]) === false).assertTrue();
      expect(FormAccessController.checkArr(null) === false).assertTrue();
      expect(FormAccessController.checkArr(undefined) === false).assertTrue();
      expect(FormAccessController.checkArr(['', 'b']) === false).assertTrue();
      expect(FormAccessController.checkArr([undefined, 'b']) === false).assertTrue();
      expect(FormAccessController.checkArr([null, 'b']) === false).assertTrue();
      expect(FormAccessController.checkArr(['a', '']) === false).assertTrue();
      expect(FormAccessController.checkArr(['a', undefined]) === false).assertTrue();
      expect(FormAccessController.checkArr(['a', null]) === false).assertTrue();
      expect(FormAccessController.checkArr(['ohos', 'b']) === false).assertTrue();
      expect(FormAccessController.checkArr(['a', 'ohos']) === false).assertTrue();
      expect(FormAccessController.checkArr(['default', 'b']) === false).assertTrue();
      expect(FormAccessController.checkArr(['a', 'default']) === false).assertTrue();
      expect(FormAccessController.checkArr(['a', 'b']) === true).assertTrue();
      expect(FormAccessController.checkArr(['a', 'a']) === false).assertTrue();
      expect(FormAccessController.checkArr(['a', 'b', 'c', 'd']) === false).assertTrue();
      expect(FormAccessController.getUUID().length > 0).assertTrue();
    })

    it('FormAccessController_013', 0, () => {
      expect(FormAccessController.verifyValue(1, 2) === 1).assertTrue();
      expect(FormAccessController.verifyValue(NaN, 2) === 2).assertTrue();
    })

    it('FormAccessController_014', 0, () => {
      expect(FormAccessController.getBinaryData(null, '') === '').assertTrue();
      expect(FormAccessController.getBinaryData(undefined, '') === '').assertTrue();
      expect(FormAccessController.getBinaryData(2, null) === '').assertTrue();
      expect(FormAccessController.getBinaryData(2, undefined) === '').assertTrue();
      expect(FormAccessController.getBinaryData(-2, '') === '').assertTrue();
      expect(FormAccessController.getBinaryData('aaaa', '') === '').assertTrue();
      expect(FormAccessController.getBinaryData(0, '') === '').assertTrue();
      expect(FormAccessController.getBinaryData(2, '') === '01').assertTrue();
    })

    it('FormAccessController_015', 0, () => {
      expect(FormAccessController.getArraySum(null, []) === -1).assertTrue();
      expect(FormAccessController.getArraySum(undefined, []) === -1).assertTrue();
      expect(FormAccessController.getArraySum([], null) === -1).assertTrue();
      expect(FormAccessController.getArraySum([], undefined) === -1).assertTrue();
      expect(FormAccessController.getArraySum([null], [1]) === -1).assertTrue();
      expect(FormAccessController.getArraySum([undefined], [1]) === -1).assertTrue();
      expect(FormAccessController.getArraySum([1], [null]) === -1).assertTrue();
      expect(FormAccessController.getArraySum([1], [undefined]) === -1).assertTrue();
      expect(FormAccessController.getArraySum([1], [2, 3]) === -1).assertTrue();
      expect(FormAccessController.getArraySum([-1, 2], [2, 3]) === -1).assertTrue();
      expect(FormAccessController.getArraySum([1, 2], [-2, 3]) === -1).assertTrue();
      expect(FormAccessController.getArraySum([1, 1], [1, 1]) === 4).assertTrue();
    })

    it('FormAccessController_016', 0, () => {
      expect(FormAccessController.isEmpty(null)).assertTrue();
      expect(FormAccessController.isEmpty(undefined)).assertTrue();
      expect(FormAccessController.isEmpty('')).assertTrue();
      expect(FormAccessController.isEmpty(0)).assertTrue();
      expect(FormAccessController.isEmpty([])).assertTrue();
      expect(FormAccessController.isEmpty(1, null)).assertTrue();
      expect(FormAccessController.isEmpty(1, undefined)).assertTrue();
      expect(FormAccessController.isEmpty(1, true)).assertTrue();
      expect(FormAccessController.isEmpty(1, false)).assertFalse();
    })

    it('FormAccessController_017', 0, () => {
      expect(FormAccessController.equals(null, 'a')).assertFalse();
      expect(FormAccessController.equals(undefined, 'a')).assertFalse();
      expect(FormAccessController.equals('a', null)).assertFalse();
      expect(FormAccessController.equals('a', undefined)).assertFalse();
      expect(FormAccessController.equals('a', 1)).assertFalse();
      expect(FormAccessController.equals(1, 'a')).assertFalse();
      expect(FormAccessController.equals(1, [])).assertFalse();
      expect(FormAccessController.equals([], 1)).assertFalse();
      const m = new Map<string, string>();
      expect(FormAccessController.equals([], m)).assertFalse();
      expect(FormAccessController.equals(m, [])).assertFalse();
      expect(FormAccessController.equals([1,2], [])).assertFalse();
      expect(FormAccessController.equals([], [1, 2])).assertFalse();
      expect(FormAccessController.equals([1], [1, 2])).assertFalse();
      expect(FormAccessController.equals([1, 3], [1, 2])).assertFalse();
      expect(FormAccessController.equals([1, 2], [1, 2])).assertTrue();
      expect(FormAccessController.equals(2, 2)).assertTrue();
    })
  });
}